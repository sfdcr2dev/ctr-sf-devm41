global class EMOC_TemporaryController {
	@RemoteAction
    global static List<Map<String, String>> getLookupUser(String searchParam) {

        String paramLike = '%' + searchParam + '%';
        List<User> userList = [SELECT Id, Username, LastName, FirstName, Employee_Id__c FROM User WHERE (Name LIKE :paramLike OR Id = :searchParam) AND IsActive = true LIMIT 99];
        List<Map<String, String>> userReturnList = new List<Map<String, String>>();
        for(User objUser: userList) {
            Map<String, String> userReturn = new Map<String, String>();
            userReturn.put('Id',objUser.Id);
            userReturn.put('Username',objUser.Username != null ? objUser.Username : '');
            userReturn.put('LastName',objUser.LastName != null ? objUser.LastName : '');
            userReturn.put('FirstName',objUser.FirstName != null ? objUser.FirstName : '');
            userReturn.put('Employee_Id__c',objUser.Employee_Id__c != null ? objUser.Employee_Id__c : '');
            PISUsers__c[] pisUser = [SELECT Id,ORGID__c,INDICATOR__c FROM PISUsers__c WHERE User__c = :objUser.Id AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
            if (pisUser.size() != 0) {
                userReturn.put('ORGID__c', pisUser[0].ORGID__c);
                userReturn.put('INDICATOR__c', pisUser[0].INDICATOR__c);
            } else {
                userReturn.put('ORGID__c', '');
                userReturn.put('INDICATOR__c', '');
            }
            userReturnList.add(userReturn);
        }
        return userReturnList;
    }
    
    @RemoteAction
    global static E_MOC_Application__c[] getLookupEmocNumber(String searchParam) {

        String paramLike = '%' + searchParam + '%';
        return [SELECT Id, Name  FROM E_MOC_Application__c WHERE (Name LIKE :paramLike OR Id = :searchParam)
                											AND (Status_Common_Workflow__c = 'VP Approval' 
                                                            OR Status_Common_Workflow__c = 'Implementation' 
                                                            OR Status_Common_Workflow__c = 'Readiness Review') LIMIT 99];
    }
    
    @RemoteAction
    global static Notification__c[] getLookupNotification(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        return [SELECT Id, Name  FROM Notification__c WHERE Integration_Status__c = 'Success' AND (Name LIKE :paramLike OR Id = :searchParam) LIMIT 99];
    }
    
    @RemoteAction
    global static List<Map<String, String>> getPeriodFrequencyList() {
        Schema.DescribeFieldResult fieldResult = E_MOC_Activity__c.Period_frequency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<Map<String, String>> valuesList = new List<Map<String, String>>();
        for( Schema.PicklistEntry pickListVal : ple){
            Map<String, String> listValues= new Map<String, String>();
            listValues.put('value', pickListVal.getValue());
            listValues.put('label', pickListVal.getLabel());
            valuesList.add(listValues);
        }
        return valuesList;
    }
    @RemoteAction
    global static MAP<String,Object> getEmocApplication(MAP<String, String> searchParam) {
        String emocApplicationId = searchParam.get('emocApplicationId');
        E_MOC_Application__c emocApplication = [SELECT Id, Status_Common_Workflow__c, Requestor_Name__c, Show_Require_to_Extend__c,Yes_Monitoring_Program_Requirement__c, No_Monitoring_Program_Requirement__c, 
                                                		Start_Date_Monitoring_Program__c, End_Date_Monitoring_Program__c, Remark_Monitoring_Program__c,Extend_Require_to_extend__c, Not_Extend_Require_to_extend__c, 
                                                		Reason_for_Extension_temporary_MOC__c,Yes_Require_to_demolish__c, No_Require_to_demolish__c, Reason_for_Extension_return_to_normal__c,
                                                		EMOC_Number_for_permanent_MOC__c, Notification_for_Permanent__c,Requestor_ID__c,Department_Resp__c, Show_Correct_the_problem_section__c,
                                               			Start_date__c,End_date__c,Return_to_Normal__c,Action_by_return_to_normal__c,Not_Extend_Require_to_extend_to_prevent__c,Remark__c,Extend_Require_to_extend_to_prevent__c
                                                  FROM E_MOC_Application__c
                                                 WHERE Id = :emocApplicationId];
       
        Map<String, Object> emocReturn = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(emocApplication));
        String startDateMonitoring = emocApplication.Start_Date_Monitoring_Program__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.Start_Date_Monitoring_Program__c)) : dateFormatMonddyyyy(String.valueOf(emocApplication.Start_date__c));
        String endDateMonitoring = emocApplication.End_Date_Monitoring_Program__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.End_Date_Monitoring_Program__c)) : dateFormatMonddyyyy(String.valueOf(emocApplication.End_date__c));
        String requireExtend = emocApplication.Show_Require_to_Extend__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.Show_Require_to_Extend__c)) : '';
        String endDate = emocApplication.End_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.End_date__c)) : '';
        emocReturn.put('Start_Date_Monitoring_Program__c',startDateMonitoring);
        emocReturn.put('End_Date_Monitoring_Program__c',endDateMonitoring);
        emocReturn.put('Show_Require_to_Extend__c',String.valueOf(emocApplication.Show_Require_to_Extend__c));
        Id userId = UserInfo.getUserId();
        User dataUser = [SELECT Id, Username, LastName, FirstName, ORG_ID__c, Employee_Id__c FROM User WHERE Id = :userId];
        emocReturn.put('User_Login',userId);
        emocReturn.put('Comfirm',false);
        emocReturn.put('End_date__c',endDate);
        emocReturn.put('End_date__Old',endDate);
        emocReturn.put('newEndDateTempoHis',''); 

        if (emocApplication.Requestor_Name__c == null) {
            emocReturn.put('Requestor_Name__c', dataUser.Id);
            emocReturn.put('Department_Resp__c', dataUser.ORG_ID__c);
            emocReturn.put('Requestor_ID__c', dataUser.Employee_Id__c);
        }
        
        if (emocApplication.Yes_Require_to_demolish__c == false && emocApplication.No_Require_to_demolish__c == false) {
            emocReturn.put('checkFirstConfirmDemolish',true);
            emocReturn.put('flgShowConfirmeNoRequireDemolish',emocApplication.No_Require_to_demolish__c);
        } else {
           emocReturn.put('checkFirstConfirmDemolish',false);
           emocReturn.put('flgShowConfirmeNoRequireDemolish',emocApplication.No_Require_to_demolish__c);
        }
        if (emocApplication.EMOC_Number_for_permanent_MOC__c != null) {
           E_MOC_Application__c[] emoc = [SELECT Id, Name  FROM E_MOC_Application__c WHERE Id = :emocApplication.EMOC_Number_for_permanent_MOC__c Limit 1];
           if (emoc.size() > 0) {
                emocReturn.put('EMOCNumberForPermanentMocName', emoc[0].Name);
           		emocReturn.put('EMOCNumberForPermanentMocLink', URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/E_MOC_Application__c/' + emocApplication.EMOC_Number_for_permanent_MOC__c + '/view'); 
           } 
        }
        return emocReturn;
    }
    
    public static String dateFormatMonddyyyy(String dateOrder) {
        String[] parts = dateOrder.split(' ');
        return parts[0].substring(8,10)+'/'+parts[0].substring(5,7)+ '/'+parts[0].substring(0,4);
    }
    
    @RemoteAction
    global static List<Map<String, Object>> getEmocActivity(MAP<String, String> emocApplicationId) {
        String emocId = emocApplicationId.get('emocApplicationId');
        List<E_MOC_Activity__c> EmocActivityList = [SELECT Id, E_MOC_Application__c, Name,Period_frequency__c, Action_by__c,Action_by__r.Name, Frequency_days__c, Acknowledge__c, Acknowledge_by__c, Acknowledge_by__r.Name
                                                     FROM E_MOC_Activity__c
                                                     WHERE E_MOC_Application__c = :emocId ];
        List<Map<String, Object>> emocActivityReturn = new List<Map<String, Object>>();
        FOR (E_MOC_Activity__c emocActivity:EmocActivityList) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('Id', emocActivity.Id);
            reMapKeyChk.put('E_MOC_Application__c', emocActivity.E_MOC_Application__c);
            reMapKeyChk.put('Name', emocActivity.Name);
            reMapKeyChk.put('Period_frequency__c', emocActivity.Period_frequency__c);
            reMapKeyChk.put('Action_by__c', emocActivity.Action_by__c);
            reMapKeyChk.put('Action_by__r', emocActivity.Action_by__r.Name);
            reMapKeyChk.put('Frequency_days__c', emocActivity.Frequency_days__c);
            reMapKeyChk.put('Acknowledge__c', emocActivity.Acknowledge__c);
            reMapKeyChk.put('Acknowledge_by__c', (emocActivity.Acknowledge_by__c != null) ? String.valueof(emocActivity.Acknowledge_by__c) : '');
            reMapKeyChk.put('Acknowledge_by__r', (emocActivity.Acknowledge_by__c != null) ? String.valueof(emocActivity.Acknowledge_by__r.Name) : '');
            reMapKeyChk.put('flgDelete', false);
            emocActivityReturn.add(reMapKeyChk); 
        }
        if (emocActivityReturn.size() == 0) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('Id', '');
            reMapKeyChk.put('E_MOC_Application__c', emocId);
            reMapKeyChk.put('Name', '');
            reMapKeyChk.put('Period_frequency__c', '');
            reMapKeyChk.put('Action_by__c', '');
            reMapKeyChk.put('Action_by__r', '');
            reMapKeyChk.put('Frequency_days__c', '');
            reMapKeyChk.put('Acknowledge__c', '');
            reMapKeyChk.put('Acknowledge_by__c', '');
            reMapKeyChk.put('Acknowledge_by__r', '');
            reMapKeyChk.put('flgDelete', false);
            emocActivityReturn.add(reMapKeyChk); 
        }          
        return emocActivityReturn;
    }
    
    @RemoteAction
    global static Map<String, Object> saveCreateEmoc (String paramSave) {
        Map<String, Object> responseStatus = new Map<String, Object>();
        Map<String, Object> paramSaveMap = (Map<String, Object>) JSON.deserializeUntyped(paramSave);
        String emocAppStr = JSON.serialize(paramSaveMap.get('emocApp'));

        E_MOC_Application__c insertEmocApplication = (E_MOC_Application__c) JSON.deserialize(emocAppStr, E_MOC_Application__c.class);
        System.savepoint sp = Database.setSavepoint();
        
        if (insertEmocApplication.Id != null) {
            try{
                update insertEmocApplication;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage update E_MOC_Application__c: '+ex.getMessage());
                responseStatus.put('errorMessage','update E_MOC_Application__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        
        List<Object> emocActivity = (List<Object>) paramSaveMap.get('emocActivity');
        if (insertEmocApplication.No_Monitoring_Program_Requirement__c == true) {
            List<E_MOC_Activity__c> delEmocActivity = [SELECT Id FROM E_MOC_Activity__c WHERE E_MOC_Application__c = :insertEmocApplication.Id];
            delete delEmocActivity;
        } else if (emocActivity.size() > 0 && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_Activity__c> delEmocActivity = new List<E_MOC_Activity__c>();
            List<E_MOC_Activity__c> upsertEmocActivity = new List<E_MOC_Activity__c>();
            for (Object emocActivityRec:emocActivity) {
                Map<String,Object> emocActivityRecMap = (Map<String,Object>)emocActivityRec;
                E_MOC_Activity__c emocActivityOpp = new E_MOC_Activity__c();
                emocActivityOpp.Id = emocActivityRecMap.get('Id') != '' ? String.valueof(emocActivityRecMap.get('Id')) : null;
                emocActivityOpp.E_MOC_Application__c = String.valueof(emocActivityRecMap.get('E_MOC_Application__c'));
                emocActivityOpp.Name = String.valueof(emocActivityRecMap.get('Name'));
                emocActivityOpp.Period_frequency__c = String.valueof(emocActivityRecMap.get('Period_frequency__c'));
                emocActivityOpp.Action_by__c = String.valueof(emocActivityRecMap.get('Action_by__c'));
              	String periodFrequency = String.valueof(emocActivityRecMap.get('Period_frequency__c'));
                if (periodFrequency == '15 days') {
                   emocActivityOpp.Frequency_days__c = 15;
                } else if (periodFrequency == '1 month') {
                   emocActivityOpp.Frequency_days__c = 30;
                } else if (periodFrequency == '2 months') {
                   emocActivityOpp.Frequency_days__c = 60;
                } else if (periodFrequency == '3 months') {
                   emocActivityOpp.Frequency_days__c = 90;
                } else if (periodFrequency == '4 months') {
                   emocActivityOpp.Frequency_days__c = 120;
                } else if (periodFrequency == '5 months') {
                   emocActivityOpp.Frequency_days__c = 150;
                } else if (periodFrequency == '6 months') {
                   emocActivityOpp.Frequency_days__c = 180;
                } else if (periodFrequency == '7 months') {
                   emocActivityOpp.Frequency_days__c = 210;
                } else if (periodFrequency == '8 months') {
                   emocActivityOpp.Frequency_days__c = 240;
                } else if (periodFrequency == '9 months') {
                   emocActivityOpp.Frequency_days__c = 270;
                } else if (periodFrequency == '10 months') {
                   emocActivityOpp.Frequency_days__c = 300;
                } else if (periodFrequency == '11 months') {
                   emocActivityOpp.Frequency_days__c = 330;
                } else if (periodFrequency == '1 year') {
                   emocActivityOpp.Frequency_days__c = 365;
                } else if (periodFrequency == '1.5 years') {
                   emocActivityOpp.Frequency_days__c = 545;
                } else if (periodFrequency == '2 years') {
                   emocActivityOpp.Frequency_days__c = 730;
                } else if (periodFrequency == '3 years') {
                   emocActivityOpp.Frequency_days__c = 1095;
                } else if (periodFrequency == '6 years') {
                   emocActivityOpp.Frequency_days__c = 2190;
                }
                
                emocActivityOpp.Acknowledge__c = emocActivityRecMap.get('Acknowledge__c') != null ? Boolean.valueOf(emocActivityRecMap.get('Acknowledge__c')) : false;
                emocActivityOpp.Acknowledge_by__c = emocActivityRecMap.get('Acknowledge_by__c') != '' ? String.valueof(emocActivityRecMap.get('Acknowledge_by__c')) : null;
                if (emocActivityOpp.Acknowledge__c == true) {
                    Integer day =  Integer.valueof(emocActivityOpp.Frequency_days__c);
                    Date dueDate = insertEmocApplication.Start_Date_Monitoring_Program__c.addDays(day);
                    emocActivityOpp.Next_Monitoring_Date__c = dueDate ;
                    Date dueDateMonitoring = dueDate.addDays(-10);
                    emocActivityOpp.Next_Reminder_Date__c = dueDateMonitoring ;
                }

                if (emocActivityRecMap.get('flgDelete') == true && emocActivityRecMap.get('Id') != null) {
                    delEmocActivity.add(emocActivityOpp);
                } else if (emocActivityRecMap.get('Name') != '' && emocActivityRecMap.get('flgDelete') != true) {
                    upsertEmocActivity.add(emocActivityOpp);
                }
            }
            try {    
                delete delEmocActivity;
                upsert upsertEmocActivity;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage update E_MOC_Activity__c: '+ex.getMessage());
                responseStatus.put('errorMessage','upsert E_MOC_Activity__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        
        String emocTemporaryHistory = JSON.serialize(paramSaveMap.get('emocTemporaryHistory'));
        E_MOC_Temporary_History__c insertEmocTemporaryHistory = (E_MOC_Temporary_History__c) JSON.deserialize(emocTemporaryHistory, E_MOC_Temporary_History__c.class);
        
        if (insertEmocTemporaryHistory.Id == null && (insertEmocTemporaryHistory.Yes__c == true || insertEmocTemporaryHistory.No__c == true)) {
            if (insertEmocTemporaryHistory.Yes__c == true) {
                insertEmocApplication.Show_Correct_the_problem_section__c = true;
            } else if (insertEmocTemporaryHistory.No__c == true) {
                insertEmocApplication.Status_Common_Workflow__c = 'Detailed Design/Study';
                insertEmocApplication.Show_Correct_the_problem_section__c = true;
                insertEmocApplication.No_Correct_the_problem__c = true;
            }

            try{
                insert insertEmocTemporaryHistory;
                update insertEmocApplication;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage insert E_MOC_Temporary_History__c: '+ex.getMessage());
                responseStatus.put('errorMessage','insert E_MOC_Temporary_History__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }

        String emocTemporaryHistory2 = JSON.serialize(paramSaveMap.get('emocTemporaryHistory2'));
        E_MOC_Temporary_History__c insertEmocTemporaryHistory2 = (E_MOC_Temporary_History__c) JSON.deserialize(emocTemporaryHistory2, E_MOC_Temporary_History__c.class);
        
        if (insertEmocTemporaryHistory2.Id == null && insertEmocTemporaryHistory2.Yes__c == true) {
            if (insertEmocTemporaryHistory2.Yes__c == true) {
                insertEmocApplication.Show_Correct_the_problem_section__c = true;
                insertEmocApplication.Status_Common_Workflow__c = 'Hazard Screening';
            }

            try{
                insert insertEmocTemporaryHistory2;
                update insertEmocApplication;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage insert E_MOC_Temporary_History__c: '+ex.getMessage());
                responseStatus.put('errorMessage','insert E_MOC_Temporary_History__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        
        String emocTemporaryHistory3 = JSON.serialize(paramSaveMap.get('emocTemporaryHistory3'));
        E_MOC_Temporary_History__c insertEmocTemporaryHistory3 = (E_MOC_Temporary_History__c) JSON.deserialize(emocTemporaryHistory3, E_MOC_Temporary_History__c.class);

        if (insertEmocTemporaryHistory3.Id == null && insertEmocTemporaryHistory3.Yes__c == true) {
            try{
                insert insertEmocTemporaryHistory3;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage insert E_MOC_Temporary_History__c: '+ex.getMessage());
                responseStatus.put('errorMessage','insert E_MOC_Temporary_History__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        return responseStatus;
    }
    
    @RemoteAction
	global static List<Map<String, Object>> getMonitoringResult(MAP<String, String> paramSearch) {
        String emocId = paramSearch.get('emocApplicationId'); 
        String emocActId = paramSearch.get('emocActivityId'); 
        String emocActName = paramSearch.get('emocActivityName'); 
        List<E_MOC_Monitoring_Activity__c> EmocMonitoringActivityList = [SELECT Id, E_MOC_Application_No__c, E_MOC_Activity__c, Name, Date_Monitoring__c, 
                                                                        	    Monitoring_result_Pass__c, Monitoring_result_Not_Pass__c, Monitoring_result_description__c, Remark__c
                                                                         FROM E_MOC_Monitoring_Activity__c
                                                                         WHERE E_MOC_Activity__c = :emocActId
                                                                         ORDER BY CreatedDate ASC];
        List<Map<String, Object>> emocMonitoringActivityReturn = new List<Map<String, Object>>();
        FOR (E_MOC_Monitoring_Activity__c emocMonitoringActivity:EmocMonitoringActivityList) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('Id', emocMonitoringActivity.Id);
            reMapKeyChk.put('E_MOC_Application_No__c', emocMonitoringActivity.E_MOC_Application_No__c);
            reMapKeyChk.put('E_MOC_Activity__c', emocMonitoringActivity.E_MOC_Activity__c);
            reMapKeyChk.put('Name', emocMonitoringActivity.Name);
            String DateMonitoring = emocMonitoringActivity.Date_Monitoring__c != null ? dateFormatMonddyyyy(String.valueOf(emocMonitoringActivity.Date_Monitoring__c)) : '';
            reMapKeyChk.put('Date_Monitoring__c', DateMonitoring);
            reMapKeyChk.put('Monitoring_result_Pass__c', emocMonitoringActivity.Monitoring_result_Pass__c);
            reMapKeyChk.put('Monitoring_result_Not_Pass__c', emocMonitoringActivity.Monitoring_result_Not_Pass__c);
            reMapKeyChk.put('Monitoring_result_description__c', emocMonitoringActivity.Monitoring_result_description__c);
            reMapKeyChk.put('Remark__c', emocMonitoringActivity.Remark__c);
            reMapKeyChk.put('flgDelete', false);
            emocMonitoringActivityReturn.add(reMapKeyChk); 
        }
		if (emocMonitoringActivityReturn.size() == 0) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('Id', '');
            reMapKeyChk.put('E_MOC_Application_No__c', emocId);
            reMapKeyChk.put('E_MOC_Activity__c', emocActId);
            reMapKeyChk.put('Name', emocActName);
            reMapKeyChk.put('Date_Monitoring__c', dateFormatMonddyyyy(String.valueOf(Date.today())));
            reMapKeyChk.put('Monitoring_result_Pass__c', false);
            reMapKeyChk.put('Monitoring_result_Not_Pass__c', false);
            reMapKeyChk.put('Monitoring_result_description__c', '');
            reMapKeyChk.put('Remark__c', '');
            reMapKeyChk.put('flgAdd', true);
            reMapKeyChk.put('flgDelete', false);
            emocMonitoringActivityReturn.add(reMapKeyChk); 
        }          
        return emocMonitoringActivityReturn;
    }
    
    @RemoteAction
    global static Map<String, Object> saveMonitoringResult (String paramSave) {
        Map<String, Object> responseStatus= new Map<String, Object>();
        List<Object> monitoringActivity = (List<Object>) JSON.deserializeUntyped(paramSave);

        System.savepoint sp = Database.setSavepoint();
        List<E_MOC_Monitoring_Activity__c> delMonitoringActivity = new List<E_MOC_Monitoring_Activity__c>();
        List<E_MOC_Monitoring_Activity__c> upsertMonitoringActivity = new List<E_MOC_Monitoring_Activity__c>();
        for (Object monitoringActivityRec:monitoringActivity) {
            Map<String,Object> monitoringActivityRecMap = (Map<String,Object>)monitoringActivityRec;
            E_MOC_Monitoring_Activity__c monitoring = new E_MOC_Monitoring_Activity__c();
            
            monitoring.Id = monitoringActivityRecMap.get('Id') != '' ? String.valueof(monitoringActivityRecMap.get('Id')) : null;
            monitoring.E_MOC_Application_No__c = String.valueof(monitoringActivityRecMap.get('E_MOC_Application_No__c'));
            monitoring.E_MOC_Activity__c = String.valueof(monitoringActivityRecMap.get('E_MOC_Activity__c'));
            monitoring.Name = String.valueof(monitoringActivityRecMap.get('Name'));
            monitoring.Date_Monitoring__c = Date.valueOf((string)monitoringActivityRecMap.get('Date_Monitoring__c'));
            monitoring.Monitoring_result_Pass__c = monitoringActivityRecMap.get('Monitoring_result_Pass__c') != null ? Boolean.valueOf(monitoringActivityRecMap.get('Monitoring_result_Pass__c')) : false;
            monitoring.Monitoring_result_Not_Pass__c = monitoringActivityRecMap.get('Monitoring_result_Not_Pass__c') != null ? Boolean.valueOf(monitoringActivityRecMap.get('Monitoring_result_Not_Pass__c')) : false;
            monitoring.Monitoring_result_description__c = String.valueof(monitoringActivityRecMap.get('Monitoring_result_description__c'));
            monitoring.Remark__c = String.valueof(monitoringActivityRecMap.get('Remark__c'));
            
            if (monitoringActivityRecMap.get('flgDelete') == true && monitoringActivityRecMap.get('Id') != null) {
                delMonitoringActivity.add(monitoring);
            } else if (monitoringActivityRecMap.get('Name') != null && monitoringActivityRecMap.get('flgDelete') != true) {
                upsertMonitoringActivity.add(monitoring);
                
                if (monitoring.Monitoring_result_Not_Pass__c == true) {
                    E_MOC_Application__c emocApp = new E_MOC_Application__c (
                        Id = monitoring.E_MOC_Application_No__c,
                        Show_Correct_the_problem_section__c = false
                    );
                    update emocApp; 
                } 
            }
        }
        try {    
            delete delMonitoringActivity;
            upsert upsertMonitoringActivity;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Save successful!');
            responseStatus.put('emocApplicationId', upsertMonitoringActivity[0].E_MOC_Application_No__c);
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage update E_MOC_Monitoring_Activity__c: '+ex.getMessage());
            responseStatus.put('errorMessage','upsert E_MOC_Monitoring_Activity__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        return responseStatus;
    }
    
    @RemoteAction
    global static Map<String, Object> getEmocTemporaryHistory (MAP<String, String> paramSearch) {
        String emocId = paramSearch.get('emocApplicationId'); 
		E_MOC_Application__c emocApplication = [SELECT Id, Show_Correct_the_problem_section__c FROM E_MOC_Application__c  WHERE Id = :emocId];
    	E_MOC_Monitoring_Activity__c[] emocMonitoringActivityList = [SELECT Id, Monitoring_result_Not_Pass__c FROM E_MOC_Monitoring_Activity__c  WHERE E_MOC_Application_No__c = :emocId AND Monitoring_result_Not_Pass__c = true];
        E_MOC_Temporary_History__c[] emocTempoHis = [SELECT Id, Yes__c, No__c, Remark__c, Date__c, E_MOC_Application__c, Type__c   
                                                     FROM E_MOC_Temporary_History__c 
                                                     WHERE E_MOC_Application__c = :emocId 
                                                     AND Type__c = 'Correct the problem by using existing solution' ORDER BY CreatedDate DESC LIMIT 1 ];
        
        Map<String, Object> emocTemporaryHistory = new Map<String, Object>();
        if (emocTempoHis.size() > 0 && emocApplication.Show_Correct_the_problem_section__c == true) {
            emocTemporaryHistory.put('Id', emocTempoHis[0].Id); 
            emocTemporaryHistory.put('Yes__c', emocTempoHis[0].Yes__c); 
            emocTemporaryHistory.put('No__c', emocTempoHis[0].No__c); 
            emocTemporaryHistory.put('Remark__c', emocTempoHis[0].Remark__c); 
            emocTemporaryHistory.put('Type__c', emocTempoHis[0].Type__c); 
            emocTemporaryHistory.put('Date__c', emocTempoHis[0].Date__c);
            emocTemporaryHistory.put('E_MOC_Application__c', emocId);  
            emocTemporaryHistory.put('Comfirm', false);
            if (emocMonitoringActivityList.size() > 0) {
                emocTemporaryHistory.put('showSectionCorrectProblem', true);
            } else {
                emocTemporaryHistory.put('showSectionCorrectProblem', false);
            }
        } else {
        	emocTemporaryHistory.put('Id', ''); 
            emocTemporaryHistory.put('Yes__c', false); 
            emocTemporaryHistory.put('No__c', false); 
            emocTemporaryHistory.put('Remark__c', ''); 
            emocTemporaryHistory.put('Type__c', 'Correct the problem by using existing solution');
            emocTemporaryHistory.put('Date__c', '');
            emocTemporaryHistory.put('E_MOC_Application__c', emocId);  
            emocTemporaryHistory.put('Comfirm', false);
            if (emocMonitoringActivityList.size() > 0) {
                emocTemporaryHistory.put('showSectionCorrectProblem', true);
            } else {
                emocTemporaryHistory.put('showSectionCorrectProblem', false);
            }
        } 

        return emocTemporaryHistory;
    } 
    @RemoteAction
    global static Map<String, Object> getEmocTemporaryHistory2 (MAP<String, String> paramSearch) {
        String emocId = paramSearch.get('emocApplicationId'); 

    	E_MOC_Monitoring_Activity__c[] emocMonitoringActivityList = [SELECT Id, Monitoring_result_Not_Pass__c FROM E_MOC_Monitoring_Activity__c  WHERE E_MOC_Application_No__c = :emocId AND Monitoring_result_Not_Pass__c = true];
 
        Map<String, Object> emocTemporaryHistory = new Map<String, Object>();
        emocTemporaryHistory.put('Id', ''); 
        emocTemporaryHistory.put('Yes__c', false); 
        emocTemporaryHistory.put('No__c', false); 
        emocTemporaryHistory.put('Remark__c', ''); 
        emocTemporaryHistory.put('Type__c', 'Require to extend to prevent overdue during return to normal');
        emocTemporaryHistory.put('Date__c', '');
        emocTemporaryHistory.put('E_MOC_Application__c', emocId);  
        emocTemporaryHistory.put('Comfirm', false);
        if (emocMonitoringActivityList.size() > 0) {
            emocTemporaryHistory.put('showSectionCorrectProblem', true);
        } else {
        	emocTemporaryHistory.put('showSectionCorrectProblem', false);
        }

        return emocTemporaryHistory;
    } 
    
}