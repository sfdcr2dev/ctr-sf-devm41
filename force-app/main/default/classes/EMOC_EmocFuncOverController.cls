global class EMOC_EmocFuncOverController {
    @RemoteAction
    global static List<Map<String, String>> getLookupFncLocation(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        List<Functional_Location__c> functionalLocation = [SELECT Id, Name, Description__c, MainWorkCenter_Text__c, mainWorkCenterPlant_Text__c, First_Related_Equipment__r.Name  
                                                           FROM Functional_Location__c WHERE Name LIKE :paramLike 
                                                           AND ((Functional_Location_Area__c = 'A' AND (
                                                                    (PlantSection__c = 'T1' AND mainWorkCenterPlant_Text__c IN ('1200', '7200')) OR
                                                                    (PlantSection__c = 'T2' AND mainWorkCenterPlant_Text__c IN ('1200', '3200', '7200'))
                                                                )) OR
                                                                (Functional_Location_Area__c = 'B' AND (
                                                                    (PlantSection__c = 'T4' AND mainWorkCenterPlant_Text__c IN ('1200', '3200', '7200')) OR
                                                                    (PlantSection__c = 'UT2' AND mainWorkCenterPlant_Text__c = '1200') OR
                                                                    (PlantSection__c = 'UT' AND mainWorkCenterPlant_Text__c IN ('1200', '8200'))
                                                                )) OR
                                                                (Functional_Location_Area__c = 'C' AND PlantSection__c IN ('T3', 'T5') AND mainWorkCenterPlant_Text__c = '1200') OR
                                                                (Functional_Location_Area__c = 'D' AND PlantSection__c IN ('OF', 'MO') AND mainWorkCenterPlant_Text__c = '1200') OR
                                                                (Functional_Location_Area__c = 'E') OR
                                                                (Functional_Location_Area__c = 'F')
                                                            )
                                                            AND System_Status__c = 'CRTE'
                                                            LIMIT 99 ];

        List<Map<String, String>> returnList = new List<Map<String, String>>();
        for(Functional_Location__c objLocation: functionalLocation) {
            Map<String, String> objList = new Map<String, String>();
            objList.put('Id',objLocation.Id);
            objList.put('Name',objLocation.Name != null ? objLocation.Name : '');
            objList.put('Description__c',objLocation.Description__c != null ? objLocation.Description__c : '');
            objList.put('MainWorkCenter_Text__c',objLocation.MainWorkCenter_Text__c != null ? objLocation.MainWorkCenter_Text__c : '');
            objList.put('mainWorkCenterPlant_Text__c',objLocation.mainWorkCenterPlant_Text__c != null ? objLocation.mainWorkCenterPlant_Text__c : '');
            objList.put('Equipment__c',objLocation.First_Related_Equipment__r.Name != null ? objLocation.First_Related_Equipment__r.Name : '');
            returnList.add(objList);
        }
        return returnList;
    }
    
    @RemoteAction
    global static List<Map<String, String>> getLookupUser(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        List<User> userList = [SELECT Id, Username, LastName, FirstName, Employee_Id__c FROM User WHERE IsActive = true AND (Name LIKE :paramLike OR Id = :searchParam) LIMIT 99];
        List<Map<String, String>> userReturnList = new List<Map<String, String>>();
        for(User objUser: userList) {
            Map<String, String> userReturn = new Map<String, String>();
            userReturn.put('Id',objUser.Id);
            userReturn.put('Username',objUser.Username != null ? objUser.Username : '');
            userReturn.put('LastName',objUser.LastName != null ? objUser.LastName : '');
            userReturn.put('FirstName',objUser.FirstName != null ? objUser.FirstName : '');
            userReturn.put('Employee_Id__c',objUser.Employee_Id__c != null ? objUser.Employee_Id__c : '');
            PISUsers__c[] pisUser = [SELECT Id, ORGID__c,INDICATOR__c  FROM PISUsers__c WHERE User__c = :objUser.Id AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
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
    global static Set<Map<String, String>> getLookupTa3(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        Set<Map<String, String>> ta3ReturnList = new Set<Map<String, String>>();
        for(E_MOC_TA3_Mandatory_Master__c forTa3ManMaster : [SELECT TA3_Name__c, TA3_Name__r.FirstName, TA3_Name__r.LastName FROM E_MOC_TA3_Mandatory_Master__c WHERE TA3_Name__r.Name LIKE :paramLike OR TA3_Name__c = :searchParam]) {
            Map<String, String> userReturn = new Map<String, String>();
            userReturn.put('Id',forTa3ManMaster.TA3_Name__c);
            userReturn.put('LastName',forTa3ManMaster.TA3_Name__r.LastName != null ? forTa3ManMaster.TA3_Name__r.LastName : '');
            userReturn.put('FirstName',forTa3ManMaster.TA3_Name__r.FirstName != null ? forTa3ManMaster.TA3_Name__r.FirstName : '');
            PISUsers__c[] pisUser = [SELECT Id,ORGID__c,INDICATOR__c FROM PISUsers__c WHERE User__c = :forTa3ManMaster.TA3_Name__c AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
            if (pisUser.size() != 0) {
                userReturn.put('ORGID__c', pisUser[0].ORGID__c);
                userReturn.put('INDICATOR__c', pisUser[0].INDICATOR__c);
            } else {
                userReturn.put('ORGID__c', '');
                userReturn.put('INDICATOR__c', '');
            }
            ta3ReturnList.add(userReturn);
            if (ta3ReturnList.size() >= 99) {
                break;
            }
        }
        return ta3ReturnList;
    }
    @RemoteAction
    global static THOR_Work_Clearance_Historical__c [] getLookupClearanceNumber(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        return [SELECT Id, Work_Clearance__c   FROM THOR_Work_Clearance_Historical__c  WHERE Work_Clearance__c  LIKE :paramLike OR Id = :searchParam LIMIT 99];
    }
    @RemoteAction
    global static MAP<String,Object> getEmocApplication(MAP<String, String> searchParam) {
        String emocApplicationId = searchParam.get('emocApplicationId');
        E_MOC_Application__c emocApplication = [SELECT Id,CPM_CAPEX__c,OPM_OPEX__c,Common_Workflow__c,Functional_Override__c,
                       Type_A_Maintenance_budget__c,Type_B_Operation_budget__c,Type_M_Maintenance_project__c,Type_P_Plant_change_budget__c,Type_S_Shutdown_budget__c,Type_V_Un_plan_shutdown_budget__c,
                       Functional_Location__c,Functional_Location__r.Name, Functional_Location_Description__c, Equipment__c,Plant_of_Main_Work_Center__c,Main_Work_Center__c,
                       Requestor_Name__c, Department_Resp__c, Requestor_ID__c, Description__c,
                       Notification__c, Integration_Status__c, Notification_Type__c, Notification_Status__c,
                       Mechanical_change__c,Instrument_change__c,Electrical_change__c,Civil_change__c,Catalyst_Chemical__c,
                       Design_limit_IOW_change__c,Tank_change_service__c,Idled_Retired_Assets_equipment__c,Air_Cooled_Exchangers__c,Fired_Heaters_Fire_Boiler__c,
                       Pipes_Flanges_Valve__c,Tracing_steam_Steam_trap__c,Pressure_Vessels__c,Rotating_equipment__c,Relief_Systems__c,
                       Shell_Tube_Heat_Exchangers__c,Tanks__c,SBM_CBM__c,HVAC_Refrigeration__c,Loading_arm_Jetty_Lorry__c,Hydraulic_power_unit__c,
                       Safety_Equipment__c,Golden_weld__c,Hot_tap__c,Temporary_repair__c,Alarm__c,
                       APC__c,Base_layer_control_DCS_PLC_TAS_TAM__c,SIF__c,Range__c,Control_valve__c,
                       Instrumentation_equipment__c,QMI__c,Valve__c,Fire_Gas_detection_system__c,Electrical_equipment_system__c,
                       Emergency_Backup_Systems__c,Communication__c,Driver_Actuator_process_at_Valve__c,Buildling_and_Road__c,Structures_foundations__c,
                       Drainage_system_AOC_COC_etc_Bund__c,Demolition__c,Mothballing__c,Preservation_unit__c,Normal__c,Emergency__c,
                       Permanent__c,Temporary__c,Completion_date__c,Start_date__c,End_date__c, Reason_of_Work__c,
                       Description_of_change__c,Reason_of_change__c,Justification__c,Precaution__c,
                       RAM_Rating__c,Assets_Severity__c,Environment_Severity__c,People_Severity__c,Product_Quality_Severity__c,Reputation_Severity__c,
                       Assets_Likelihood__c,Environment_Likelihood__c,People_Likelihood__c,Product_Quality_Likelihood__c,Reputation_Likelihood__c,
                       Assets_RAM__c,Environment_RAM__c,People_RAM__c,Product_Quality_RAM__c,Reputation_RAM__c,
                       Assets_Remark__c,Environment_Remark__c,People_Remark__c,Product_Quality_Remark__c,Reputation_Remark__c,
                       RAM_Total__c,OOS__c,MOS_for_ops_purpose__c,Inhibit_for_process_or_Equipment_S_D__c,Inhibit_alarm_for_maintenance__c,
                       Disable_Alarm_by_Ops_for_HW__c,Inhibit_Alarm_request_for_FOX__c,MOS_for_maintenance__c,Safeguarding_force_signal__c,
                       Status_Common_Workflow__c,MOC_Focal_Point_Name__c,MOC_Focal_Point_ID__c,Position__c,Budget_Estimate_Initial__c,Budget_Estimate_Final__c,
                       HAZOP__c,HRA__c,Environmental_Impact__c,Reliability_Checklist__c,
                       Assets_Severity_Final__c,Environment_Severity_Final__c,People_Severity_Final__c,Product_Quality_Severity_Final__c,
                       Reputation_Severity_Final__c,Assets_Likelihood_Final__c,Environment_Likelihood_Final__c,People_Likelihood_Final__c,Product_Quality_Likelihood_Final__c,
                       Reputation_Likelihood_Final__c,Assets_RAM_Final__c,Environment_RAM_Final__c,People_RAM_Final__c,Product_Quality_RAM_Final__c,Reputation_RAM_Final__c,
                       Assets_Remark_Final__c,Environment_Remark_Final__c,People_Remark_Final__c,Product_Quality_Remark_Final__c,Reputation_Remark_Final__c,
                       RAM_Total_Final__c,Show_TA_Mandatory__c, Status_Functional_Override__c,
                       Extend_Require_to_extend__c, Not_Extend_Require_to_extend__c, Reason_for_Extension_temporary_MOC__c,Potential_Risk_c__c, Other__c, 
                       SIL_Level__c, Design_Intent__c, Initiating_Event_Demand_Scenario__c, Consequence_of_Failure_on_Demand__c, Mitigation_Plan_1__c, Mitigation_Plan_2__c,
                       Clearance_Number__c, I_have_check__c, Return_to_Normal__c, TA_Selection_confirmed__c, Work_Clearance_c__c,Clearance_Number_Final__c,I_have_checked_and_confirmed_the_change__c,
                       Clearance_Number_Final_Group_C__c,Show_TA_section__c,PlantSection__c,Action_by_FN_closeout__c,Functional_Override_Group__c,Functional_Override_Category__c,Status_FN_Report__c,
                       Action_by_return_to_normal__c, FN_TA_Review_Date__c
                  FROM E_MOC_Application__c
                 WHERE Id = :emocApplicationId];
        Map<String, Object> emocReturn = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(emocApplication));
        String completionDate = emocApplication.Completion_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.Completion_date__c)) : '';
        String startDate = emocApplication.Start_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.Start_date__c)) : '';
        String endDate = emocApplication.End_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.End_date__c)) : '';
        String FnTaReviewDate = emocApplication.FN_TA_Review_Date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.FN_TA_Review_Date__c)) : '';
        Boolean checkClearanceNumberFinal = emocApplication.Clearance_Number_Final__c != null ? true : false ;
        emocReturn.put('Completion_date__c',completionDate);
        emocReturn.put('Start_date__c',startDate);
        emocReturn.put('End_date__c',endDate);
        emocReturn.put('End_date__Old',endDate); 
        emocReturn.put('FN_TA_Review_Date__c',FnTaReviewDate); 
        emocReturn.put('Comfirm',false);
        emocReturn.put('newEndDateTempoHis',''); 
        emocReturn.put('flgClearanceNumberFinal', checkClearanceNumberFinal); 
        Id userId = UserInfo.getUserId();
        emocReturn.put('User_Login',userId);
        PISUsers__c[] pisUser = [SELECT Id,INDICATOR__c  FROM PISUsers__c WHERE User__c = :emocApplication.Requestor_Name__c AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
        if (pisUser.size() > 0) {
            emocReturn.put('Indicator__c', pisUser[0].INDICATOR__c);
        }
        if (emocApplication.Clearance_Number__c == null && emocApplication.Notification__c != null) {
            Notification__c[] noti = [SELECT Id, Work_Clearance__c FROM Notification__c WHERE Id = :emocApplication.Notification__c];
            if (noti.size() > 0) {
                emocReturn.put('Clearance_Number__c', noti[0].Work_Clearance__c);
            } 
        }
        
        return emocReturn;
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
        } else {
            Id userId = UserInfo.getUserId();
            User dataUser = [SELECT Id, Username, LastName, FirstName, Department, Employee_Id__c FROM User WHERE Id = :userId];
            insertEmocApplication.Description__c = 'MOC';
            insertEmocApplication.Requestor_Name__c = dataUser.Id;
            try{
                insert insertEmocApplication;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage insert E_MOC_Application__c: '+ex.getMessage());
                responseStatus.put('errorMessage','insert E_MOC_Application__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        List<Object> ta2Man = (List<Object>) paramSaveMap.get('ta2Man');

        if (ta2Man.size() > 0 && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_TA_Mandatory_Mapping__c> delTaManMapping = new List<E_MOC_TA_Mandatory_Mapping__c>();
            List<E_MOC_TA_Mandatory_Mapping__c> upsertTaManMapping = new List<E_MOC_TA_Mandatory_Mapping__c>();
            for (Object ta2ManRec:ta2Man) {
                Map<String,Object> ta2ManRecMap = (Map<String,Object>)ta2ManRec;
                E_MOC_TA_Mandatory_Mapping__c taManMapping = new E_MOC_TA_Mandatory_Mapping__c();
                taManMapping.Id = ta2ManRecMap.get('Id') != '' ? String.valueof(ta2ManRecMap.get('Id')) : null;
                taManMapping.E_MOC_Application__c = insertEmocApplication.Id;
                taManMapping.Position__c = ta2ManRecMap.get('Position__c') != null ? String.valueof(ta2ManRecMap.get('Position__c')) : null;
                taManMapping.Require__c = ta2ManRecMap.get('Require__c') != null ? String.valueof(ta2ManRecMap.get('Require__c')) : null;
                taManMapping.TA_Level__c = ta2ManRecMap.get('TA_Level__c') != null ? String.valueof(ta2ManRecMap.get('TA_Level__c')) : null;
                taManMapping.TA3_Name_c__c = ta2ManRecMap.get('TA3_Name_c__c') == '' ? null : String.valueof(ta2ManRecMap.get('TA3_Name_c__c'));
                taManMapping.TA3_Id__c = ta2ManRecMap.get('TA3_Id__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Id__c')) : null;
                taManMapping.TA3_Position_c__c = ta2ManRecMap.get('TA3_Position_c__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Position_c__c')) : null;
                taManMapping.TA3_Comment__c = ta2ManRecMap.get('TA3_Comment__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Comment__c')) : null;
           
                taManMapping.TA2_Indicator__c = ta2ManRecMap.get('TA2_Indicator__c') != null ? String.valueof(ta2ManRecMap.get('TA2_Indicator__c')) : null;

                taManMapping.TA2_Name__c = ta2ManRecMap.get('TA2_Name__c') != null ? String.valueof(ta2ManRecMap.get('TA2_Name__c')) : null;
                taManMapping.TA2_Expert_Field__c = ta2ManRecMap.get('TA2_Expert_Field__c') != null ? String.valueof(ta2ManRecMap.get('TA2_Expert_Field__c')) : null;
                taManMapping.TA3_Expert_Field__c = ta2ManRecMap.get('TA3_Expert_Field__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Expert_Field__c')) : null;
                taManMapping.TA3_Indicator__c = ta2ManRecMap.get('TA3_Indicator__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Indicator__c')) : null;
                
                taManMapping.TA3_s_review_has_been_completed__c = ta2ManRecMap.get('TA3_s_review_has_been_completed__c') != null ? Boolean.valueOf(ta2ManRecMap.get('TA3_s_review_has_been_completed__c')) : false;
                if (String.valueof(ta2ManRecMap.get('Action_by_TA3__c')) != '') {
                	taManMapping.Action_by_TA3__c = ta2ManRecMap.get('Action_by_TA3__c') != null ? String.valueof(ta2ManRecMap.get('Action_by_TA3__c')) : null;
                }

                if (ta2ManRecMap.get('flgDelete') == true && ta2ManRecMap.get('Id') != null) {
                    delTaManMapping.add(taManMapping);
                } else if (ta2ManRecMap.get('TA2_Indicator__c') != '' && ta2ManRecMap.get('flgDelete') != true) {
                    upsertTaManMapping.add(taManMapping);
                } 
            }
            
            try {  
                delete delTaManMapping;
                upsert upsertTaManMapping;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage update E_MOC_TA_Mandatory_Mapping__c: '+ex.getMessage());
                responseStatus.put('errorMessage','upsert E_MOC_TA_Mandatory_Mapping__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        
        List<Object> potentialRisk = (List<Object>) paramSaveMap.get('potentialRisk');
        if (potentialRisk.size() > 0 && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_Prelim_Risk__c> upsertPotentialRisk = new List<E_MOC_Prelim_Risk__c>();
            for (Object potentialRiskRec:potentialRisk) {
                Map<String,Object> potentialRiskRecMap = (Map<String,Object>)potentialRiskRec;
                E_MOC_Prelim_Risk__c PrelimRisk = new E_MOC_Prelim_Risk__c();
                PrelimRisk.Id = potentialRiskRecMap.get('Id') != '' ? String.valueof(potentialRiskRecMap.get('Id')) : null;
                PrelimRisk.E_MOC_Application__c = insertEmocApplication.Id;
                PrelimRisk.Topic__c = String.valueof(potentialRiskRecMap.get('Topic__c'));
                PrelimRisk.Comment__c = String.valueof(potentialRiskRecMap.get('Comment__c'));
                PrelimRisk.Type__c = String.valueof(potentialRiskRecMap.get('Type__c'));
                upsertPotentialRisk.add(PrelimRisk);
            }
            try {    
                upsert upsertPotentialRisk;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage update E_MOC_Prelim_Risk__c: '+ex.getMessage());
                responseStatus.put('errorMessage','upsert E_MOC_Prelim_Risk__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        
        List<Object> potentialConsequence = (List<Object>) paramSaveMap.get('potentialConsequence');
        if (potentialConsequence.size() > 0 && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_Prelim_Risk__c> delPotentialConsequence = new List<E_MOC_Prelim_Risk__c>();
            List<E_MOC_Prelim_Risk__c> upsertPotentialConsequence = new List<E_MOC_Prelim_Risk__c>();
            for (Object potentialConsequenceRec:potentialConsequence) {
                Map<String,Object> potentialConsequenceRecMap = (Map<String,Object>)potentialConsequenceRec;
                E_MOC_Prelim_Risk__c PrelimRisk = new E_MOC_Prelim_Risk__c();
                PrelimRisk.Id = potentialConsequenceRecMap.get('Id') != '' ? String.valueof(potentialConsequenceRecMap.get('Id')) : null;
                PrelimRisk.E_MOC_Application__c = insertEmocApplication.Id;
                PrelimRisk.Topic__c = String.valueof(potentialConsequenceRecMap.get('Topic__c'));
                PrelimRisk.Comment__c = String.valueof(potentialConsequenceRecMap.get('Comment__c'));
                PrelimRisk.Type__c = String.valueof(potentialConsequenceRecMap.get('Type__c'));

                if (potentialConsequenceRecMap.get('flgDelete') == true && potentialConsequenceRecMap.get('Id') != null) {
                    delPotentialConsequence.add(PrelimRisk);
                } else if (potentialConsequenceRecMap.get('Topic__c') != '' && potentialConsequenceRecMap.get('flgDelete') != true) {
                    upsertPotentialConsequence.add(PrelimRisk);
                }
            }
            try {    
                delete delPotentialConsequence;
                upsert upsertPotentialConsequence;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage update E_MOC_Prelim_Risk__c: '+ex.getMessage());
                responseStatus.put('errorMessage','upsert E_MOC_Prelim_Risk__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        List<Object> mitigationPrecaution = (List<Object>) paramSaveMap.get('mitigationPrecaution');
        if (mitigationPrecaution.size() > 0 && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_Prelim_Risk__c> delMitigationPrecaution = new List<E_MOC_Prelim_Risk__c>();
            List<E_MOC_Prelim_Risk__c> upsertMitigationPrecaution = new List<E_MOC_Prelim_Risk__c>();
            for (Object mitigationPrecautionRec:mitigationPrecaution) {
                Map<String,Object> mitigationPrecautionRecMap = (Map<String,Object>)mitigationPrecautionRec;
                E_MOC_Prelim_Risk__c PrelimRisk = new E_MOC_Prelim_Risk__c();
                PrelimRisk.Id = mitigationPrecautionRecMap.get('Id') != '' ? String.valueof(mitigationPrecautionRecMap.get('Id')) : null;
                PrelimRisk.E_MOC_Application__c = insertEmocApplication.Id;
                PrelimRisk.Topic__c = String.valueof(mitigationPrecautionRecMap.get('Topic__c'));
                PrelimRisk.Comment__c = String.valueof(mitigationPrecautionRecMap.get('Comment__c'));
                PrelimRisk.Type__c = String.valueof(mitigationPrecautionRecMap.get('Type__c'));

                if (mitigationPrecautionRecMap.get('flgDelete') == true && mitigationPrecautionRecMap.get('Id') != null) {
                    delMitigationPrecaution.add(PrelimRisk);
                } else if (mitigationPrecautionRecMap.get('Topic__c') != '' && mitigationPrecautionRecMap.get('flgDelete') != true) {
                    upsertMitigationPrecaution.add(PrelimRisk);
                }
            }
            try {    
                delete delMitigationPrecaution;
                upsert upsertMitigationPrecaution;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage update E_MOC_Prelim_Risk__c: '+ex.getMessage());
                responseStatus.put('errorMessage','upsert E_MOC_Prelim_Risk__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        
        String emocTemporaryHistory = JSON.serialize(paramSaveMap.get('emocTemporaryHistory'));
        E_MOC_Temporary_History__c insertEmocTemporaryHistory = (E_MOC_Temporary_History__c) JSON.deserialize(emocTemporaryHistory, E_MOC_Temporary_History__c.class);

        if (insertEmocTemporaryHistory.Id == null && insertEmocTemporaryHistory.Yes__c == true) {
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
        return responseStatus;
    }

    public static String dateFormatMonddyyyy(String dateOrder) {
        String[] parts = dateOrder.split(' ');
        return parts[0].substring(8,10)+'/'+parts[0].substring(5,7)+ '/'+parts[0].substring(0,4);
    }
    @RemoteAction
    global static E_MOC_TA_Mandatory_Mapping__c[] getTaManMaster(Id emocAppId) {

        E_MOC_Application__c emocApp = [SELECT Id,Mechanical_change__c,Instrument_change__c,Electrical_change__c,Civil_change__c,Catalyst_Chemical__c,
                                                Design_limit_IOW_change__c,Tank_change_service__c,Idled_Retired_Assets_equipment__c,Air_Cooled_Exchangers__c,Fired_Heaters_Fire_Boiler__c,
                                                Pipes_Flanges_Valve__c,Tracing_steam_Steam_trap__c,Pressure_Vessels__c,Rotating_equipment__c,Relief_Systems__c,
                                                Shell_Tube_Heat_Exchangers__c,Tanks__c,SBM_CBM__c,HVAC_Refrigeration__c,Loading_arm_Jetty_Lorry__c,Hydraulic_power_unit__c,
                                                Safety_Equipment__c,Golden_weld__c,Hot_tap__c,Temporary_repair__c,Alarm__c,
                                                APC__c,Base_layer_control_DCS_PLC_TAS_TAM__c,SIF__c,Range__c,Control_valve__c,
                                                Instrumentation_equipment__c,QMI__c,Valve__c,Fire_Gas_detection_system__c,Electrical_equipment_system__c,
                                                Emergency_Backup_Systems__c,Communication__c,Driver_Actuator_process_at_Valve__c,Buildling_and_Road__c,Structures_foundations__c,
                                                Drainage_system_AOC_COC_etc_Bund__c,Demolition__c,Mothballing__c,Preservation_unit__c,Area__c,MOS_for_maintenance__c, Safeguarding_force_signal__c,
                                                PlantSection__c,Plant_of_Main_Work_Center__c
                                        FROM E_MOC_Application__c WHERE Id = :emocAppId];

        List<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingList = EMOC_EmocFuncOverController.generateTaMappingList(emocApp, 'Optional');
        return emocTaManMappingList;
    }
    @RemoteAction
    global static List<Map<String, Object>> getTaManMapping(Id emocAppId) {
        Id userId = UserInfo.getUserId();
        User user = [SELECT UserRole.Name FROM User WHERE Id = :userId];
        E_MOC_Application__c emocApp = [SELECT Id, Status_Functional_Override__c  FROM E_MOC_Application__c WHERE Id = :emocAppId];
        List<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingList = [SELECT Id, E_MOC_Application__c, Position__c, Require__c, CreatedById,
                                                                        Compliance_Standard__c, Compliance_Standard_Remark__c,
                                                                        Deviate_Standard__c, Deviate_Standard_Remark__c, N_A__c, N_A_Remark__c,
                                                                        TA3_Name_c__c, TA3_Id__c, TA3_Position_c__c, TA_Level__c, TA3_Comment__c, 
                                                                    	TA2_Indicator__c,TA2_Name__c, TA2_Name__r.Name,TA2_Position__c,TA2_Expert_Field__c,
                                                                        TA3_Indicator__c,TA3_Expert_Field__c, TA3_s_review_has_been_completed__c, Action_by_TA3__c
                                                                    FROM E_MOC_TA_Mandatory_Mapping__c
                                                                    WHERE E_MOC_Application__c = :emocAppId
                                                                    AND TA_Level__c = '2'];
        List<Map<String, Object>> taManMappingReturn = new List<Map<String, Object>>();
        FOR (E_MOC_TA_Mandatory_Mapping__c taManMapping:emocTaManMappingList) {
            Map<String, Object> reMapKeyChkUser = new Map<String, Object>();
            reMapKeyChkUser.put('Id', taManMapping.Id);
            reMapKeyChkUser.put('E_MOC_Application__c', taManMapping.E_MOC_Application__c);
            reMapKeyChkUser.put('Position__c', taManMapping.Position__c);
            reMapKeyChkUser.put('Require__c', taManMapping.Require__c);
            reMapKeyChkUser.put('TA_Level__c', taManMapping.TA_Level__c);
            reMapKeyChkUser.put('Edit_Enabled', userId == taManMapping.CreatedById);
            reMapKeyChkUser.put('Compliance_Standard__c', taManMapping.Compliance_Standard__c);
            reMapKeyChkUser.put('Compliance_Standard_Remark__c', taManMapping.Compliance_Standard_Remark__c == null ? '' : taManMapping.Compliance_Standard_Remark__c);
            reMapKeyChkUser.put('Deviate_Standard__c', taManMapping.Deviate_Standard__c);
            reMapKeyChkUser.put('Deviate_Standard_Remark__c', taManMapping.Deviate_Standard_Remark__c == null ? '' : taManMapping.Deviate_Standard_Remark__c);
            reMapKeyChkUser.put('N_A__c', taManMapping.N_A__c);
            reMapKeyChkUser.put('N_A_Remark__c', taManMapping.N_A_Remark__c == null ? '' : taManMapping.N_A_Remark__c);
            reMapKeyChkUser.put('TA3_Name_c__c', taManMapping.TA3_Name_c__c == null ? '' : taManMapping.TA3_Name_c__c);
            reMapKeyChkUser.put('TA3_Id__c', taManMapping.TA3_Id__c == null ? '' : taManMapping.TA3_Id__c);
            reMapKeyChkUser.put('TA3_Position_c__c', taManMapping.TA3_Position_c__c == null ? '' : taManMapping.TA3_Position_c__c);
            reMapKeyChkUser.put('TA3_Comment__c', taManMapping.TA3_Comment__c == null ? '' : taManMapping.TA3_Comment__c);
            reMapKeyChkUser.put('TA2_Indicator__c', taManMapping.TA2_Indicator__c == null ? '' : taManMapping.TA2_Indicator__c);
            reMapKeyChkUser.put('TA2_Name__c', taManMapping.TA2_Name__c);
            reMapKeyChkUser.put('TA2_Name__r_Name', taManMapping.TA2_Name__r.Name);
            reMapKeyChkUser.put('TA2_Position__c', taManMapping.TA2_Position__c);
            reMapKeyChkUser.put('TA2_Expert_Field__c', taManMapping.TA2_Expert_Field__c);
            reMapKeyChkUser.put('TA3_Indicator__c', taManMapping.TA3_Indicator__c == null ? '' : taManMapping.TA3_Indicator__c);
            reMapKeyChkUser.put('TA3_Expert_Field__c', taManMapping.TA3_Expert_Field__c == null ? '' : taManMapping.TA3_Expert_Field__c);
            reMapKeyChkUser.put('TA3_s_review_has_been_completed__c', taManMapping.TA3_s_review_has_been_completed__c);
            reMapKeyChkUser.put('Action_by_TA3__c', taManMapping.Action_by_TA3__c == null ? '' : taManMapping.Action_by_TA3__c);
            reMapKeyChkUser.put('flgDelete', false);
            reMapKeyChkUser.put('flgShowTa3Review', taManMapping.TA3_Indicator__c == null ? false : true);
            
            if (user.UserRole.Name.indexOf('Admin') != -1 || emocApp.Status_Functional_Override__c == 'Technical review') {
                reMapKeyChkUser.put('Enabled_TA_Checklist', true);
            } else {
                reMapKeyChkUser.put('Enabled_TA_Checklist', user.UserRole.Name.indexOf(taManMapping.Position__c) != -1);
            }
            Integer countTaChecklist = [SELECT Count() FROM E_MOC_Result__c WHERE E_MOC_Application__c = :emocAppId AND Document__c = 'TA Checklist' AND Position__c = :taManMapping.Position__c];
            reMapKeyChkUser.put('Ta_Checklist_Result', countTaChecklist);
            taManMappingReturn.add(reMapKeyChkUser);
        }
        return taManMappingReturn;
    }
    public static List<E_MOC_TA_Mandatory_Mapping__c> generateTaMappingList(E_MOC_Application__c emocApp, String requireType) {
        String subCateType = '';
        if (emocApp.MOS_for_maintenance__c) {
            subCateType = 'MOS for maintenance';
        } else if (emocApp.Safeguarding_force_signal__c) {
            subCateType = 'Safeguarding force signal';
        }

        List<Map<String, Object>> taManMappingReturn = new List<Map<String, Object>>();
        List<E_MOC_TA_Mandatory_Master__c> emocTaManMasterList = new List<E_MOC_TA_Mandatory_Master__c>();
        if (emocApp.Area__c == 'F') {
            emocTaManMasterList = [SELECT Position__c, TA_Level__c, Require__c, Indicator__c, User__c, Expert_field_for__c FROM E_MOC_TA_Mandatory_Master__c
                                                            WHERE ((Area__c = 'F' AND Plant_of_Main_Work_Center__c = :emocApp.Plant_of_Main_Work_Center__c AND Plant_of_Main_Work_Center__c != null) OR Area__c = null)
                                                            AND Require__c = :requireType 
                                                            AND TA_Level__c = '2'
                                                            AND Indicator__c != null
                                                            AND Category_Type__c = 'Functional Override'
                                                            AND Sub_Category_Type__c = :subCateType];
        } else if (emocApp.Area__c == 'D') {
            emocTaManMasterList = [SELECT Position__c, TA_Level__c, Require__c, Indicator__c, User__c, Expert_field_for__c FROM E_MOC_TA_Mandatory_Master__c
                                                            WHERE ((Area__c = 'D' AND PlantSection__c = :emocApp.PlantSection__c) OR Area__c = null)
                                                            AND Require__c = :requireType 
                                                            AND TA_Level__c = '2'
                                                            AND Indicator__c != null
                                                            AND Category_Type__c = 'Functional Override'
                                                            AND Sub_Category_Type__c = :subCateType];
        } else {
            emocTaManMasterList = [SELECT Position__c, TA_Level__c, Require__c, Indicator__c, User__c, Expert_field_for__c FROM E_MOC_TA_Mandatory_Master__c
                                                            WHERE ((Area__c = :emocApp.Area__c  AND Area__c NOT IN ('D', 'F')) OR Area__c = null)
                                                            AND Require__c = :requireType 
                                                            AND TA_Level__c = '2'
                                                            AND Indicator__c != null
                                                            AND Category_Type__c = 'Functional Override'
                                                            AND Sub_Category_Type__c = :subCateType];
        }

        Set<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingSet = new Set<E_MOC_TA_Mandatory_Mapping__c>();
        if (requireType == 'Require') {
            List<E_MOC_TA_Mandatory_Mapping__c> delEmocTaManMapList = [SELECT Id FROM E_MOC_TA_Mandatory_Mapping__c WHERE E_MOC_Application__c = :emocApp.Id AND Require__c = 'Require' AND TA_Level__c = '2'];
            Delete delEmocTaManMapList;
        }
        for (E_MOC_TA_Mandatory_Master__c emocTaManMaster:emocTaManMasterList) {
            E_MOC_TA_Mandatory_Mapping__c emocTaManMapping = new E_MOC_TA_Mandatory_Mapping__c();
            emocTaManMapping.Position__c            = emocTaManMaster.Position__c;
            emocTaManMapping.TA_Level__c            = emocTaManMaster.TA_Level__c;
            emocTaManMapping.E_MOC_Application__c   = emocApp.Id;
            emocTaManMapping.Require__c             = emocTaManMaster.Require__c;
            emocTaManMapping.TA2_Indicator__c       = emocTaManMaster.Indicator__c;
            emocTaManMapping.TA2_Name__c			= emocTaManMaster.User__c;
            emocTaManMapping.TA2_Position__c		= emocTaManMaster.Position__c;
            emocTaManMapping.TA2_Expert_Field__c    = emocTaManMaster.Expert_field_for__c;
            emocTaManMappingSet.add(emocTaManMapping);
        }
        List<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingList = new List<E_MOC_TA_Mandatory_Mapping__c>();
        emocTaManMappingList.addAll(emocTaManMappingSet);
        return emocTaManMappingList;
    }
    
    @RemoteAction
    global static List<Map<String, String>> getPotentialRiskList() {
        Schema.DescribeFieldResult fieldResult = E_MOC_Application__c.Potential_Risk_c__c.getDescribe();
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
    global static List<Map<String, String>> getPotentialConsequenceList() {
        Schema.DescribeFieldResult fieldResult = E_MOC_Application__c.Potential_Consequence_c__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<Map<String, String>> valuesList = new List<Map<String, String>>();
        for( Schema.PicklistEntry pickListVal : ple){
            Map<String, String> listValues= new Map<String, String>();
            listValues.put('Potential_Consequence_c__c', pickListVal.getValue());
            valuesList.add(listValues);
        }
        return valuesList;
    } 
    @RemoteAction
    global static List<Map<String, String>> getMitigationPrecautionList() {
        Schema.DescribeFieldResult fieldResult = E_MOC_Application__c.Mitigation_Precaution_1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<Map<String, String>> valuesList = new List<Map<String, String>>();
        for( Schema.PicklistEntry pickListVal : ple){
            Map<String, String> listValues= new Map<String, String>();
            listValues.put('Mitigation_Precaution_1__c', pickListVal.getValue());
            valuesList.add(listValues);
        }
        return valuesList;
    } 
    
    @RemoteAction
    global static List<Map<String, Object>> getPotentialConsequence(MAP<String, String> emocApplicationId) {
        String emocId = emocApplicationId.get('emocApplicationId');
        List<E_MOC_Prelim_Risk__c> PrelimRiskList = [SELECT Id, E_MOC_Application__c, Topic__c, Comment__c, Type__c
                                                     FROM E_MOC_Prelim_Risk__c
                                                     WHERE E_MOC_Application__c = :emocId 
                                                     AND Type__c = 'Potential Consequence' ];
        List<Map<String, Object>> potentialConReturn = new List<Map<String, Object>>();
        
        FOR (E_MOC_Prelim_Risk__c potentialCon:PrelimRiskList) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('Id', potentialCon.Id);
            reMapKeyChk.put('E_MOC_Application__c', potentialCon.E_MOC_Application__c);
            reMapKeyChk.put('Potential_Consequence_c__c', potentialCon.Topic__c);
            reMapKeyChk.put('Topic__c', potentialCon.Topic__c);
            reMapKeyChk.put('Comment__c', potentialCon.Comment__c);
            reMapKeyChk.put('Other_Potential_Consequence__c', potentialCon.Comment__c);
            reMapKeyChk.put('Type__c', potentialCon.Type__c);
            potentialConReturn.add(reMapKeyChk); 
        }
        if (potentialConReturn.size() == 0) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('E_MOC_Application__c', emocId);
            reMapKeyChk.put('Potential_Consequence_c__c', '');
            reMapKeyChk.put('Topic__c', '');
            reMapKeyChk.put('Comment__c', '');
            reMapKeyChk.put('Other_Potential_Consequence__c', '');
            reMapKeyChk.put('Type__c', '');
            potentialConReturn.add(reMapKeyChk); 
        }
        return potentialConReturn;
    }
    @RemoteAction
    global static List<Map<String, Object>> getMitigationPrecaution(MAP<String, String> emocApplicationId) {
        String emocId = emocApplicationId.get('emocApplicationId');
        List<E_MOC_Prelim_Risk__c> PrelimRiskList = [SELECT Id, E_MOC_Application__c, Topic__c, Comment__c, Type__c
                                                     FROM E_MOC_Prelim_Risk__c
                                                     WHERE E_MOC_Application__c = :emocId
                                                     AND Type__c = 'Mitigation/Precaution'];
        List<Map<String, Object>> mitigationPreReturn = new List<Map<String, Object>>();
        FOR (E_MOC_Prelim_Risk__c mitigationPre:PrelimRiskList) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('Id', mitigationPre.Id);
            reMapKeyChk.put('E_MOC_Application__c', mitigationPre.E_MOC_Application__c);
            reMapKeyChk.put('Mitigation_Precaution_1__c', mitigationPre.Topic__c);
            reMapKeyChk.put('Topic__c', mitigationPre.Topic__c);
            reMapKeyChk.put('Comment__c', mitigationPre.Comment__c);
            reMapKeyChk.put('Other_Mitigation__c', mitigationPre.Comment__c);
            reMapKeyChk.put('Type__c', mitigationPre.Type__c);
            mitigationPreReturn.add(reMapKeyChk); 
        }
        if (mitigationPreReturn.size() == 0) {
            Map<String, Object> reMapKeyChk = new Map<String, Object>();
            reMapKeyChk.put('E_MOC_Application__c', emocId);
            reMapKeyChk.put('Mitigation_Precaution_1__c', '');
            reMapKeyChk.put('Topic__c', '');
            reMapKeyChk.put('Comment__c', '');
            reMapKeyChk.put('Other_Mitigation__c', '');
            reMapKeyChk.put('Type__c', '');
            mitigationPreReturn.add(reMapKeyChk); 
        }
        return mitigationPreReturn;
    }
    @RemoteAction
     global static set<Map<String, String>> getTa3ManMaster(MAP<String, String> searchParam) {
        String Indicator = searchParam.get('Indicator');
        String checkSectionParam = searchParam.get('Section');
        String Section = searchParam.get('Section');
        if (checkSectionParam == 'MROA' || checkSectionParam == 'MROB' || checkSectionParam == 'MROC' || checkSectionParam == 'MMLF' || checkSectionParam == 'MMLD' || checkSectionParam == 'MPOE' || checkSectionParam == 'MPOF') {
            Section = 'MFOP';
        }
        String paramLike = '%' + Indicator + '%';
         
        Set<Map<String, String>> ta3ReturnList = new Set<Map<String, String>>();
        for(E_MOC_TA3_Mandatory_Master__c forTa3ManMaster : [SELECT TA3_Name__c, TA3_Name__r.FirstName, TA3_Name__r.LastName, Section__c, Expert_field_for__c, Indicator__c
                                                             FROM E_MOC_TA3_Mandatory_Master__c 
                                                             WHERE Section__c = :Section AND Indicator__c LIKE :paramLike ]) {
            Map<String, String> userReturn = new Map<String, String>();
            userReturn.put('Id',forTa3ManMaster.Indicator__c);
            userReturn.put('LastName',forTa3ManMaster.TA3_Name__r.LastName != null ? forTa3ManMaster.TA3_Name__r.LastName : '');
            userReturn.put('FirstName',forTa3ManMaster.TA3_Name__r.FirstName != null ? forTa3ManMaster.TA3_Name__r.FirstName : '');
            userReturn.put('Section__c',forTa3ManMaster.Section__c != null ? forTa3ManMaster.Section__c : '');
            userReturn.put('Expert_field_for__c',forTa3ManMaster.Expert_field_for__c != null ? forTa3ManMaster.Expert_field_for__c : '');
            userReturn.put('Indicator__c',forTa3ManMaster.Indicator__c != null ? forTa3ManMaster.Indicator__c : '');

            ta3ReturnList.add(userReturn);
            if (ta3ReturnList.size() >= 99) {
                break;
            }
        }
        return ta3ReturnList;
    }
    
   @RemoteAction
    global static void ApprovalProcess(Id emocAppId) {
       	List<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingList = [SELECT Position__c FROM E_MOC_TA_Mandatory_Mapping__c  WHERE E_MOC_Application__c = :emocAppId ];
        List<Group> positionReturn = new List<Group>();
        FOR (E_MOC_TA_Mandatory_Mapping__c position:emocTaManMappingList) {
            String positionSectionHead =  '%' + position.Position__c + '-Section Head%';
            String positionSenior =  '%' + position.Position__c + '-Senior%';
       		Group groupPosition = [SELECT Id FROM Group WHERE Type='Queue' AND (Name LIKE :positionSectionHead OR Name LIKE :positionSenior) LIMIT 1 ];
            positionReturn.add(groupPosition);
        }
	
        List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
        for(Group g : positionReturn){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(emocAppId);
            req.setSubmitterId(UserInfo.getUserId()); 
            req.setProcessDefinitionNameOrId('FN_Technical_Review_TA');
            req.setNextApproverIds(new List<Id>{g.Id});
            approvalRequestList.add(req); 
        }
        Approval.process(approvalRequestList);  
    }
}