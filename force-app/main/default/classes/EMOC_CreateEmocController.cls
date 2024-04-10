global class EMOC_CreateEmocController {
	@RemoteAction
    global static Functional_Location__c[] getLookupFncLocation(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        return [SELECT Id, Name, Description__c, MainWorkCenter_Text__c, mainWorkCenterPlant_Text__c
                  FROM Functional_Location__c
                 WHERE Name LIKE :paramLike LIMIT 99];
    }
	@RemoteAction
    global static Functional_Location__c[] getLookupFncLocationFilter(Map<String, String> searchParam) {
        String paramLike = '%' + searchParam.get('searchParam') + '%';
        String recordType = searchParam.get('recordType');
        List<Functional_Location__c> retFuncLocList = new List<Functional_Location__c>();
        if (recordType == 'Functional Override') {
            retFuncLocList = [SELECT Id, Name, Description__c, MainWorkCenter_Text__c, mainWorkCenterPlant_Text__c,wbsElement__c
                                FROM Functional_Location__c
                                WHERE Name LIKE :paramLike
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
                                LIMIT 99];
        } else {
            retFuncLocList = [SELECT Id, Name, Description__c, MainWorkCenter_Text__c, mainWorkCenterPlant_Text__c,wbsElement__c
                                FROM Functional_Location__c
                                WHERE Name LIKE :paramLike
                                AND (
                                    Mainworkcenter_type__c = 'MECH' OR
                                    Mainworkcenter_type__c = 'INST' OR
                                    Mainworkcenter_type__c = 'ELEC'
                                )
                              	AND System_Status__c = 'CRTE'
                                LIMIT 99];
        }
        return retFuncLocList;
    }
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
    global static List<Map<String, String>> getLookupFocalPoint(String searchParam) {
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
            PISUsers__c[] pisUser = [SELECT Id,INDICATOR__c FROM PISUsers__c WHERE User__c = :objUser.Id AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
            if (pisUser.size() != 0) {
                userReturn.put('INDICATOR__c', pisUser[0].INDICATOR__c);
            } else {
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
            PISUsers__c[] pisUser = [SELECT Id,ORGID__c, INDICATOR__c FROM PISUsers__c WHERE User__c = :forTa3ManMaster.TA3_Name__c AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
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
                       Requestor_Name__c, Department_Resp__c, Requestor_ID__c,
                       Mechanical_change__c,Instrument_change__c,Electrical_change__c,Civil_change__c,Catalyst_Chemical__c,
                       Design_limit_IOW_change__c,Tank_change_service__c,Idled_Retired_Assets_equipment__c,Air_Cooled_Exchangers__c,Fired_Heaters_Fire_Boiler__c,
                       Pipes_Flanges_Valve__c,Tracing_steam_Steam_trap__c,Pressure_Vessels__c,Rotating_equipment__c,Relief_Systems__c,
                       Shell_Tube_Heat_Exchangers__c,Tanks__c,SBM_CBM__c,HVAC_Refrigeration__c,Loading_arm_Jetty_Lorry__c,Hydraulic_power_unit__c,
                       Safety_Equipment__c,Golden_weld__c,Hot_tap__c,Temporary_repair__c,Alarm__c,
                       APC__c,Base_layer_control_DCS_PLC_TAS_TAM__c,SIF__c,Range__c,Control_valve__c,
                       Instrumentation_equipment__c,QMI__c,Valve__c,Fire_Gas_detection_system__c,Electrical_equipment_system__c,
                       Emergency_Backup_Systems__c,Communication__c,Driver_Actuator_process_at_Valve__c,Buildling_and_Road__c,Structures_foundations__c,
                       Drainage_system_AOC_COC_etc_Bund__c,Refractory_Fireproof__c,Insulation__c,Painting_and_coating__c,Demolition__c,Mothballing__c,Preservation_unit__c,Normal__c,Emergency__c,
                       Permanent__c,Temporary__c,Completion_date__c,Start_date__c,End_date__c,
                       Description_of_change__c,Reason_of_change__c,Justification__c,Precaution__c,
                       RAM_Rating__c,Assets_Severity__c,Environment_Severity__c,People_Severity__c,Product_Quality_Severity__c,Reputation_Severity__c,
                       Assets_Likelihood__c,Environment_Likelihood__c,People_Likelihood__c,Product_Quality_Likelihood__c,Reputation_Likelihood__c,
                       Assets_RAM__c,Environment_RAM__c,People_RAM__c,Product_Quality_RAM__c,Reputation_RAM__c,
                       Assets_Remark__c,Environment_Remark__c,People_Remark__c,Product_Quality_Remark__c,Reputation_Remark__c,
                       RAM_Total__c,OOS__c,MOS_for_ops_purpose__c,Inhibit_for_process_or_Equipment_S_D__c,Inhibit_alarm_for_maintenance__c,
                       Disable_Alarm_by_Ops_for_HW__c,Inhibit_Alarm_request_for_FOX__c,MOS_for_maintenance__c,Safeguarding_force_signal__c,
                       Status_Common_Workflow__c,MOC_Focal_Point_Name__c,MOC_Focal_Point_ID__c,Position__c,Budget_Estimate_Initial__c,Budget_Estimate_Final__c,wbs_element__c,
                       HAZOP__c,HRA__c,Environmental_Impact__c,Reliability_Checklist__c,HAZOP_Checklist_Link__c,HRA_Checklist_Link__c,Environmental_Impact_Checklist_Link__c,
                       Reliability_Checklist_Link__c,Assets_Severity_Final__c,Environment_Severity_Final__c,People_Severity_Final__c,Product_Quality_Severity_Final__c,
                       Reputation_Severity_Final__c,Assets_Likelihood_Final__c,Environment_Likelihood_Final__c,People_Likelihood_Final__c,Product_Quality_Likelihood_Final__c,
                       Reputation_Likelihood_Final__c,Assets_RAM_Final__c,Environment_RAM_Final__c,People_RAM_Final__c,Product_Quality_RAM_Final__c,Reputation_RAM_Final__c,
                       Assets_Remark_Final__c,Environment_Remark_Final__c,People_Remark_Final__c,Product_Quality_Remark_Final__c,Reputation_Remark_Final__c,
                       RAM_Total_Final__c,Show_TA_Mandatory__c,Show_Technical_review_by_MOC__c,I_have_incorporated_comments__c,
                       TA_Review_by_Technologist_Manager__c,TA_Review_by_Operation_Manager__c,TA_Review_by_Engineer_Manager__c,
                       Action_by_Technologist__c,Action_by_Operation__c,Action_by_Maintenance__c,
                       Action_by_Technologist__r.Name,Action_by_Operation__r.Name,Action_by_Maintenance__r.Name,Notification_Type__c,Order__c,
                       CATEGORY_1__c,Assigned_To_Category_1__c,Employee_ID_Category_1__c,Position_Category_1__c,CATEGORY_1_Form__c,
                       CATEGORY_2__c,Assigned_To_Category_2__c,Employee_ID_Category_2__c,Position_Category_2__c,CATEGORY_2_Form__c,
                       CATEGORY_3__c,Assigned_To_Category_3__c,Employee_ID_Category_3__c,Position_Category_3__c,CATEGORY_3_Form__c,
                       QA_QC__c,Assigned_To_QA_QC__c,Employee_ID_QA_QC__c,Position_QA_QC__c,
                       Position_Lesson_Learned__c,Lesson_Learn__c,Recommendation_for_future_improvement__c,Document_Guideline_type__c,
                       Yes_MOC_Accomplishment__c,No_MOC_Accomplishment__c,Reason_MOC_Accomplishment__c,Document_Storage_Guideline__c,
                       Show_Lesson_Learn_section__c,Work_Clearance_c__c,show_MOC_Focal_Point_section__c,Deviation_Form__c,Send_to_MROx__c,
                       Functional_Override_Group__c,Functional_Override_Category__c,Status_Common_Report__c,Status_FN_Report__c,
                       TA_Mandatory_Guideline__c,Action_by_MOC__c,I_have_confirmed_Risk_Analysis__c,Action_by_risk_analysis__c,
                       TA2_s_review_has_been_completed__c, Yes_Monitoring_Program_Requirement__c, No_Monitoring_Program_Requirement__c,
                       I_have_confirmed_already_upload_PSSR__c,Action_by_PSSR__c,Has_QA_QC_checklist__c,
                       E_MOC_Title__c,HAZOP_Recommendation__c,HRA_Recommendation__c,EA_Recommendation__c,Reliability_Recommendation__c,Summary_sheet__c,
                       Risk_analysis_report__c,Sub_category_report__c,PSSR_Cate_type_Report__c,Risk_Analysis_Guideline__c
                  FROM E_MOC_Application__c
                 WHERE Id = :emocApplicationId];
       	Map<String, Object> emocReturn = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(emocApplication));
        String completionDate = emocApplication.Completion_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.Completion_date__c)) : '';
        String startDate = emocApplication.Start_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.Start_date__c)) : '';
        String endDate = emocApplication.End_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApplication.End_date__c)) : '';
        emocReturn.put('Completion_date__c',completionDate);
        emocReturn.put('Start_date__c',startDate);
        emocReturn.put('End_date__c',endDate);
        Id userId = UserInfo.getUserId();
        User dataUser = [SELECT Id, Name, Username, LastName, FirstName, ORG_ID__c, Employee_Id__c FROM User WHERE Id = :userId];
        emocReturn.put('User_Login',userId);
        PISUsers__c[] pisUser = [SELECT Id,INDICATOR__c  FROM PISUsers__c WHERE User__c = :emocApplication.Requestor_Name__c AND Active__c = true AND MAINPOSITION__c = true  LIMIT 1];
        if (pisUser.size() > 0) {
            emocReturn.put('Indicator__c', pisUser[0].INDICATOR__c);
        }
        Integer countDocReq = [SELECT Count() FROM E_MOC_Result__c WHERE E_MOC_Application__c = :emocApplicationId AND Document__c = 'Document Require Checklist'];
        Integer countHazard = [SELECT Count() FROM E_MOC_Result__c WHERE E_MOC_Application__c = :emocApplicationId AND Document__c = 'Hazard Screen Checklist'];
        Integer countQaQc = [SELECT Count() FROM E_MOC_Result__c WHERE E_MOC_Application__c = :emocApplicationId AND Document__c = 'QA/QC checklist'];
        emocReturn.put('Doc_Req_Result', countDocReq);
        emocReturn.put('Hazard_Src_Result', countHazard);
        emocReturn.put('QA_QC_Checklist_Result', countQaQc);
        ProcessInstanceStep[] countAppr = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId = :emocApplicationId AND ProcessInstance.ProcessDefinition.Name LIKE '%Concept Approval%' ORDER BY CreatedDate DESC];

        emocReturn.put('UpdById', dataUser.Id);
        emocReturn.put('UpdByName', dataUser.Name);
        if (emocApplication.HAZOP__c || emocApplication.HRA__c || emocApplication.Environmental_Impact__c || emocApplication.Reliability_Checklist__c) {
            emocReturn.put('flgShowConfirmeRiskAnalysis', true); 
        } else {
            emocReturn.put('flgShowConfirmeRiskAnalysis', false);
        }
        if (emocApplication.CATEGORY_1__c || emocApplication.CATEGORY_2__c) {
            emocReturn.put('flgShowConfirmeAlreadyUploadPSSR', true); 
        } else {
            emocReturn.put('flgShowConfirmeAlreadyUploadPSSR', false);
        }
        emocReturn.put('flgShowConfirmeQaQc', emocApplication.QA_QC__c); 

        List<E_MOC_Functional_Location__c> emocFncLocaList = [SELECT Id,E_MOC_Application__c,Functional_Location__c,Functional_Location__r.Name,
                                                                    Functional_Location_Description__c,Main_Work_Center__c,Plant_of_Main_Work_Center__c
                                                            FROM E_MOC_Functional_Location__c
                                                            WHERE E_MOC_Application__c = :emocApplicationId];
        emocReturn.put('emocFuncLoca', emocFncLocaList);
        return emocReturn;
    }
    @RemoteAction
    global static Map<String, Object> saveCreateEmoc (String paramSave) {
        Id userId = UserInfo.getUserId();
        Map<String, Object> responseStatus = new Map<String, Object>();
        Map<String, Object> paramSaveMap = (Map<String, Object>) JSON.deserializeUntyped(paramSave);
        String emocAppStr = JSON.serialize(paramSaveMap.get('emocApp'));

        E_MOC_Application__c insertEmocApplication = (E_MOC_Application__c) JSON.deserialize(emocAppStr, E_MOC_Application__c.class);
        
        system.debug('Budget_Estimate_Initial__c'+insertEmocApplication.Budget_Estimate_Initial__c + ' |Budget_Estimate_Final__c= | ' +insertEmocApplication.Budget_Estimate_Final__c);
            
        String typeOfRecord = insertEmocApplication.Common_Workflow__c ? 'Common Workflow' : 'Functional Override';
        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = :typeOfRecord LIMIT 1];
        insertEmocApplication.RecordTypeId = recordType.Id;
        String categoryTypeReport = '';
        if (insertEmocApplication.Mechanical_change__c) {
            categoryTypeReport += ',Mechanical change';
        }
        if (insertEmocApplication.Instrument_change__c) {
            categoryTypeReport += ',Instrument change';
        }
        if (insertEmocApplication.Electrical_change__c) {
            categoryTypeReport += ',Electrical change';
        }
        if (insertEmocApplication.Civil_change__c) {
            categoryTypeReport += ',Civil change';
        }
        if (insertEmocApplication.Catalyst_Chemical__c) {
            categoryTypeReport += ',Catalyst & Chemical';
        }
        if (insertEmocApplication.Design_limit_IOW_change__c) {
            categoryTypeReport += ',Design limit + Integrity Operating window (IOW)';
        }
        if (insertEmocApplication.Tank_change_service__c) {
            categoryTypeReport += ',Tank change service';
        }
        if (insertEmocApplication.Idled_Retired_Assets_equipment__c) {
            categoryTypeReport += ',Idled / Retired Assets (equipment)';
        }
        categoryTypeReport = categoryTypeReport.length() > 0 ? categoryTypeReport.substring(1) : '';
        insertEmocApplication.Category_Type__c = categoryTypeReport;
        if (insertEmocApplication.Assigned_To_QA_QC__c == null) {
            insertEmocApplication.Assigned_To_QA_QC__c = insertEmocApplication.MOC_Focal_Point_Name__c;
            insertEmocApplication.Position_QA_QC__c = insertEmocApplication.Position__c;
        }
        
        
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
            User dataUser = [SELECT Id, Username, LastName, FirstName, Department, Employee_Id__c, ORG_ID__c FROM User WHERE Id = :userId];
            insertEmocApplication.Description__c = 'MOC';
            insertEmocApplication.Requestor_Name__c = dataUser.Id;
            if (insertEmocApplication.E_MOC_Type__c == 'Common Workflow') {
            	insertEmocApplication.Status_Common_Report__c = 'MS01';
            } else if (insertEmocApplication.E_MOC_Type__c == 'Functional Override') {
            	insertEmocApplication.Status_FN_Report__c = 'MS01';
            }
            
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
        if ((insertEmocApplication.CATEGORY_1__c == true || insertEmocApplication.CATEGORY_2__c == true || insertEmocApplication.CATEGORY_3__c == true) && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_Attachment_PSSR_category__c> listAttPssrCat = [SELECT Id FROM E_MOC_Attachment_PSSR_category__c WHERE E_MOC_Application__c = :insertEmocApplication.Id];
            if (listAttPssrCat.size() == 0) {
                E_MOC_Attachment_PSSR_category__c attPssrCat = new E_MOC_Attachment_PSSR_category__c();
                attPssrCat.E_MOC_Application__c = insertEmocApplication.Id;
                attPssrCat.E_MOC_Checklist_type__c = 'PSSR category';
                attPssrCat.E_MOC_Doc_Type__c = 'PSSR category';
                insert attPssrCat;
            }
        }
        List<Object> ta2Man = (List<Object>) paramSaveMap.get('ta2Man');
        if (ta2Man.size() > 0 && responseStatus.get('statusSuccess') == true) {
            User currentUser = [SELECT UserRole.Name FROM User WHERE Id = :userId];
            // currentUser.UserRole.Name = 'ENCM';
            List<E_MOC_TA_Mandatory_Mapping__c> delTaManMapping = new List<E_MOC_TA_Mandatory_Mapping__c>();
            List<E_MOC_TA_Mandatory_Mapping__c> upsertTaManMapping = new List<E_MOC_TA_Mandatory_Mapping__c>();
            for (Object ta2ManRec:ta2Man) {
                Map<String,Object> ta2ManRecMap = (Map<String,Object>)ta2ManRec;

                E_MOC_TA_Mandatory_Mapping__c taManMapping = new E_MOC_TA_Mandatory_Mapping__c();
                taManMapping.Id = ta2ManRecMap.get('Id') != '' ? String.valueof(ta2ManRecMap.get('Id')) : null;
                taManMapping.E_MOC_Application__c = String.valueof(ta2ManRecMap.get('E_MOC_Application__c'));
                taManMapping.Position__c = ta2ManRecMap.get('Position__c') != null ? String.valueof(ta2ManRecMap.get('Position__c')) : null;
                taManMapping.Require__c = ta2ManRecMap.get('Require__c') != null ? String.valueof(ta2ManRecMap.get('Require__c')) : null;
                taManMapping.TA_Level__c = ta2ManRecMap.get('TA_Level__c') != null ? String.valueof(ta2ManRecMap.get('TA_Level__c')) : null;
                taManMapping.Compliance_Standard__c = ta2ManRecMap.get('Compliance_Standard__c') != null ? Boolean.valueOf(ta2ManRecMap.get('Compliance_Standard__c')) : false;
                taManMapping.Compliance_Standard_Remark__c = ta2ManRecMap.get('Compliance_Standard_Remark__c') != null ? String.valueof(ta2ManRecMap.get('Compliance_Standard_Remark__c')) : null;
                taManMapping.Deviate_Standard__c = ta2ManRecMap.get('Deviate_Standard__c') != null ? Boolean.valueOf(ta2ManRecMap.get('Deviate_Standard__c')) : false;
                taManMapping.Deviate_Standard_Remark__c = ta2ManRecMap.get('Deviate_Standard_Remark__c') != null ? String.valueof(ta2ManRecMap.get('Deviate_Standard_Remark__c')) : null;
                taManMapping.N_A__c = ta2ManRecMap.get('N_A__c') != null ? Boolean.valueOf(ta2ManRecMap.get('N_A__c')) : false;
                taManMapping.N_A_Remark__c = ta2ManRecMap.get('N_A_Remark__c') != null ? String.valueof(ta2ManRecMap.get('N_A_Remark__c')) : null;
                taManMapping.TA3_Name_c__c = ta2ManRecMap.get('TA3_Name_c__c') == '' ? null : String.valueof(ta2ManRecMap.get('TA3_Name_c__c'));
                taManMapping.TA3_Id__c = ta2ManRecMap.get('TA3_Id__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Id__c')) : null;
                taManMapping.TA3_Position_c__c = ta2ManRecMap.get('TA3_Position_c__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Position_c__c')) : null;
                taManMapping.TA3_Comment__c = ta2ManRecMap.get('TA3_Comment__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Comment__c')) : null;
                taManMapping.I_have_finished_technical_review__c = ta2ManRecMap.get('I_have_finished_technical_review__c') != null ? Boolean.valueof(ta2ManRecMap.get('I_have_finished_technical_review__c')) : false;
                if ((taManMapping.TA3_Name_c__c != null || taManMapping.Compliance_Standard__c == true || taManMapping.Deviate_Standard__c == true || taManMapping.N_A__c == true) && taManMapping.TA2_Name__c == null) {
                    if (currentUser != null) {
                        if (currentUser.UserRole.Name != null) {
                            List<PISUsers__c> pisUserList = [SELECT INDICATOR__c FROM PISUsers__c WHERE User__c = :userId AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
                            if (currentUser.UserRole.Name.indexOf('Admin') != -1) {
                                if (pisUserList.size() > 0) {
                                    taManMapping.TA2_Position__c = pisUserList[0].INDICATOR__c;
                                }
                            } else {
                                if (currentUser.UserRole.Name.indexOf(taManMapping.Position__c) != -1) {
                                    if (pisUserList.size() > 0) {
                                        taManMapping.TA2_Position__c = pisUserList[0].INDICATOR__c;
                                    }
                                }
                            }
                        }
                    }
                }
                taManMapping.TA2_Indicator__c = ta2ManRecMap.get('TA2_Indicator__c') != null ? String.valueof(ta2ManRecMap.get('TA2_Indicator__c')) : null;
                if (taManMapping.TA2_Indicator__c != null) {
                    PISUsers__c[] pisUser = [SELECT Id, User__c  FROM PISUsers__c WHERE INDICATOR__c = :taManMapping.TA2_Indicator__c AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
                    if (pisUser.size() > 0) {
                		taManMapping.TA2_Name__c = ta2ManRecMap.get('TA2_Name__c') != null ? String.valueof(ta2ManRecMap.get('TA2_Name__c')) : pisUser[0].User__c;
                    }
                } 
                taManMapping.TA2_Expert_Field__c = ta2ManRecMap.get('TA2_Expert_Field__c') != null ? String.valueof(ta2ManRecMap.get('TA2_Expert_Field__c')) : null;
                taManMapping.TA2_s_review_has_been_completed__c = ta2ManRecMap.get('TA2_s_review_has_been_completed__c') != null ? Boolean.valueOf(ta2ManRecMap.get('TA2_s_review_has_been_completed__c')) : false;
                taManMapping.The_comment_need_to_be_verified__c = ta2ManRecMap.get('The_comment_need_to_be_verified__c') != null ? Boolean.valueOf(ta2ManRecMap.get('The_comment_need_to_be_verified__c')) : false;
                
				if (String.valueof(ta2ManRecMap.get('Action_by_TA2__c')) != '') {
                	taManMapping.Action_by_TA2__c = ta2ManRecMap.get('Action_by_TA2__c') != null ? String.valueof(ta2ManRecMap.get('Action_by_TA2__c')) : null;
                }
                
                taManMapping.TA3_Expert_Field__c = ta2ManRecMap.get('TA3_Expert_Field__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Expert_Field__c')) : null;
                taManMapping.TA3_Indicator__c = ta2ManRecMap.get('TA3_Indicator__c') != null ? String.valueof(ta2ManRecMap.get('TA3_Indicator__c')) : null;
                taManMapping.TA3_s_review_has_been_completed__c = ta2ManRecMap.get('TA3_s_review_has_been_completed__c') != null ? Boolean.valueOf(ta2ManRecMap.get('TA3_s_review_has_been_completed__c')) : false;
				if (String.valueof(ta2ManRecMap.get('Action_by_TA3__c')) != '') {
                	taManMapping.Action_by_TA3__c = ta2ManRecMap.get('Action_by_TA3__c') != null ? String.valueof(ta2ManRecMap.get('Action_by_TA3__c')) : null;
                }
                
                taManMapping.I_have_uploaded_the_deviation_form__c = ta2ManRecMap.get('I_have_uploaded_the_deviation_form__c') != null ? Boolean.valueOf(ta2ManRecMap.get('I_have_uploaded_the_deviation_form__c')) : false;
				if (String.valueof(ta2ManRecMap.get('Action_by_deviated_form__c')) != '') {
                	taManMapping.Action_by_deviated_form__c = ta2ManRecMap.get('Action_by_deviated_form__c') != null ? String.valueof(ta2ManRecMap.get('Action_by_deviated_form__c')) : null;
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
        List<Object> fncLocaAss = (List<Object>) paramSaveMap.get('fncLocaAss');
        if (fncLocaAss.size() > 0 && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_Functional_Location__c> delFncLocaAss = new List<E_MOC_Functional_Location__c>();
            List<E_MOC_Functional_Location__c> upsertFncLocaAss = new List<E_MOC_Functional_Location__c>();
            for (Object fncLocaAssRec:fncLocaAss) {
                Map<String,Object> fncLocaAssRecMap = (Map<String,Object>)fncLocaAssRec;
                E_MOC_Functional_Location__c funcLoca = new E_MOC_Functional_Location__c();
                funcLoca.Id = fncLocaAssRecMap.get('Id') != '' ? String.valueof(fncLocaAssRecMap.get('Id')) : null;
                funcLoca.Functional_Location__c = String.valueof(fncLocaAssRecMap.get('Functional_Location__c'));
                funcLoca.E_MOC_Application__c = insertEmocApplication.Id;
                if (fncLocaAssRecMap.get('flgDelete') == true && fncLocaAssRecMap.get('Id') != null && fncLocaAssRecMap.get('Id') != '') {
                    delFncLocaAss.add(funcLoca);
                } else if (fncLocaAssRecMap.get('Position__c') != '' && fncLocaAssRecMap.get('flgDelete') != true) {
                    upsertFncLocaAss.add(funcLoca);
                }
            }
            try {    
                delete delFncLocaAss;
                upsert upsertFncLocaAss;
                responseStatus.put('statusSuccess', true);
                responseStatus.put('errorMessage', 'Save successful!');
                responseStatus.put('emocApplicationId', insertEmocApplication.Id);
            } catch (DmlException ex) {
                responseStatus.put('statusSuccess', false);
                system.debug('errorMessage update E_MOC_Functional_Location__c: '+ex.getMessage());
                responseStatus.put('errorMessage','upsert E_MOC_Functional_Location__c: '+ex.getMessage());
                Database.rollback(sp);
            }
        }
        List<Object> potentialRisk = (List<Object>) paramSaveMap.get('potentialRisk');
        if (potentialRisk.size() > 0 && responseStatus.get('statusSuccess') == true) {
            List<E_MOC_Prelim_Risk__c> upsertPotentialRisk = new List<E_MOC_Prelim_Risk__c>();
            for (Object potentialRiskRec:potentialRisk) {
                Map<String,Object> potentialRiskRecMap = (Map<String,Object>)potentialRiskRec;
                E_MOC_Prelim_Risk__c PrelimRisk = new E_MOC_Prelim_Risk__c();
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
        return responseStatus;
    }
    @RemoteAction
    global static E_MOC_Result__c[] getDocReqChecklist(MAP<String, String> paramSearch) {
        String emocAppId = paramSearch.get('Id');
        String docType = paramSearch.get('DocType');
        List<AggregateResult> maxVersionAgg = [SELECT MAX(Version__c)Max_Version FROM E_MOC_Result__c WHERE E_MOC_Application__r.Id = :emocAppId AND Document__c = :docType];
        List<E_MOC_Result__c> eMocResultList = new List<E_MOC_Result__c>();
        Decimal maxVerDeci = maxVersionAgg[0].get('Max_Version') != null ? Decimal.valueOf(String.valueOf(maxVersionAgg[0].get('Max_Version'))) : null;
        if (maxVersionAgg[0].get('Max_Version') != null) {
            eMocResultList = [SELECT    E_MOC_Application__c, Sequence__c, Type__c, Question_No__c, Question__c, Yes__c, No__c, N_A__c, Remark__c, CreatedBy.Name, Version__c, Document__c,Priority__c,Help_text__c
                              FROM      E_MOC_Result__c
                              WHERE     E_MOC_Application__r.Id = :emocAppId
                              AND       Version__c = :maxVerDeci
                              AND       Document__c = :docType
                              ORDER BY  Sequence__c, Question_No__c];
        } else {
            E_MOC_Question__c[] eMocQuestion = [SELECT  Sequence__c, Type__c, Question_No__c, Question__c,Help_text__c
                                                FROM    E_MOC_Question__c
                                                WHERE   Document__c = :docType
                                                ORDER BY Sequence__c, Question_No__c];
            for(E_MOC_Question__c objMaster: eMocQuestion) {
                E_MOC_Result__c eMocResult = new E_MOC_Result__c();
                eMocResult.E_MOC_Application__c = emocAppId;
                eMocResult.Sequence__c          = objMaster.Sequence__c;
                eMocResult.Type__c              = objMaster.Type__c;
                eMocResult.Question_No__c       = objMaster.Question_No__c;
                eMocResult.Question__c          = objMaster.Question__c;
                eMocResult.Version__c           = 0;
                eMocResult.Document__c          = docType;
                eMocResult.Help_text__c			= objMaster.Help_text__c;
                eMocResultList.add(eMocResult);
            }
        }
        return eMocResultList;
    }
    @RemoteAction
    global static Map<String, Object> saveDocReqChecklist (String paramSave) {
        Map<String, Object> responseStatus= new Map<String, Object>();
        List<Object> objEmocResultList = (List<Object>) JSON.deserializeUntyped(paramSave);
        List<E_MOC_Result__c> insertEmocResultList = new List<E_MOC_Result__c>();
        List<E_MOC_Attachment_Doc_require__c> attachmentDocReqList = new List<E_MOC_Attachment_Doc_require__c>();
        for(Object emocResult : objEmocResultList) {
            Map<String,Object> mapOsbject = (Map<String,Object>)emocResult;
            E_MOC_Result__c insertEmocResult = new E_MOC_Result__c();
            insertEmocResult.E_MOC_Application__c    = mapOsbject.get('E_MOC_Application__c') == '' ? null : String.valueOf(mapOsbject.get('E_MOC_Application__c'));
            insertEmocResult.Sequence__c             = mapOsbject.get('Sequence__c') == '' ? null : Decimal.valueOf(String.valueOf(mapOsbject.get('Sequence__c')));
            insertEmocResult.Type__c                 = mapOsbject.get('Type__c') == '' ? null : String.valueOf(mapOsbject.get('Type__c'));
            insertEmocResult.Question_No__c          = mapOsbject.get('Question_No__c') == '' ? null : Decimal.valueOf(String.valueOf(mapOsbject.get('Question_No__c')));
            insertEmocResult.Question__c             = mapOsbject.get('Question__c') == '' ? null : String.valueOf(mapOsbject.get('Question__c'));
            insertEmocResult.Yes__c                  = mapOsbject.get('Yes__c') == '' ? false : Boolean.valueOf(String.valueOf(mapOsbject.get('Yes__c')));
            insertEmocResult.No__c                   = mapOsbject.get('No__c') == '' ? false : Boolean.valueOf(String.valueOf(mapOsbject.get('No__c')));
            insertEmocResult.N_A__c                  = mapOsbject.get('N_A__c') == '' ? false : Boolean.valueOf(String.valueOf(mapOsbject.get('N_A__c')));
            insertEmocResult.Remark__c               = mapOsbject.get('Remark__c') == '' ? null : String.valueOf(mapOsbject.get('Remark__c'));
            insertEmocResult.Version__c              = mapOsbject.get('Version__c') == '' ? null : Decimal.valueOf(String.valueOf(mapOsbject.get('Version__c')));
            insertEmocResult.Document__c             = mapOsbject.get('Document__c') == '' ? null : String.valueOf(mapOsbject.get('Document__c'));
            insertEmocResult.Position__c             = mapOsbject.get('Position__c') == '' ? null : String.valueOf(mapOsbject.get('Position__c'));
            insertEmocResult.Priority__c             = mapOsbject.get('Priority__c') == '' ? null : String.valueOf(mapOsbject.get('Priority__c'));
            insertEmocResult.Help_text__c			 = mapOsbject.get('Help_text__c') == '' ? null : String.valueOf(mapOsbject.get('Help_text__c'));
            insertEmocResultList.add(insertEmocResult);
            
            if (insertEmocResult.Document__c == 'Document Require Checklist' && insertEmocResult.Yes__c) {
                E_MOC_Attachment_Doc_require__c[] attachmentDocReq = [SELECT Id
                                                                        FROM E_MOC_Attachment_Doc_require__c
                                                                        WHERE E_MOC_Application__c = :insertEmocResult.E_MOC_Application__c
                                                                        AND E_MOC_Doc_Type__c = :insertEmocResult.Type__c
                                                                        AND Question_No__c = :insertEmocResult.Question_No__c
                                                                    LIMIT 1];
                if (attachmentDocReq.size() == 0 ) {
                    E_MOC_Attachment_Doc_require__c attachDocReqIns = new E_MOC_Attachment_Doc_require__c();
                    attachDocReqIns.E_MOC_Doc_Type__c = insertEmocResult.Type__c;
                    attachDocReqIns.E_MOC_Checklist_type__c = insertEmocResult.Question__c;
                    attachDocReqIns.Question_No__c = insertEmocResult.Question_No__c;
                    attachDocReqIns.E_MOC_Application__c = insertEmocResult.E_MOC_Application__c;
                    attachmentDocReqList.add(attachDocReqIns);
                }
            }
        }
        System.savepoint sp = Database.setSavepoint();
        try{
            insert insertEmocResultList;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Save successful!');
            responseStatus.put('emocApplicationId', insertEmocResultList[0].E_MOC_Application__c);
            E_MOC_Application__c updEmocApp = new E_MOC_Application__c();
            updEmocApp.Id = insertEmocResultList[0].E_MOC_Application__c;
            if (insertEmocResultList[0].Document__c == 'Document Require Checklist') {
                updEmocApp.Has_Doc_Req_Checklist__c = true;
            }
            if (insertEmocResultList[0].Document__c == 'Hazard Screen Checklist') {
                updEmocApp.Has_Hazard_Screening_Checklist__c = true;
            }
            if (insertEmocResultList[0].Document__c == 'QA/QC checklist') {
                updEmocApp.CATEGORY_1__c = false;
                updEmocApp.CATEGORY_2__c = false;
                updEmocApp.CATEGORY_3__c = false;
                updEmocApp.QA_QC__c = true;
                updEmocApp.Has_QA_QC_checklist__c = true;
            }
            update updEmocApp;
            insert attachmentDocReqList;
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage insert E_MOC_Result__c: '+ex.getMessage());
            responseStatus.put('errorMessage','insert E_MOC_Result__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        return responseStatus;
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
                                                Drainage_system_AOC_COC_etc_Bund__c,Refractory_Fireproof__c,Insulation__c,Painting_and_coating__c,Demolition__c,Mothballing__c,Preservation_unit__c,Area__c,
                                                PlantSection__c,Plant_of_Main_Work_Center__c,Maintenance_Plant__c
                                        FROM E_MOC_Application__c WHERE Id = :emocAppId];
        List<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingList = EMOC_CreateEmocController.generateTaMappingList(emocApp, 'Optional');
        return emocTaManMappingList;
    }
    @RemoteAction
    global static List<Map<String, Object>> getTaManMapping(Id emocAppId) {
        Id userId = UserInfo.getUserId();
        User currentUser = [SELECT UserRole.Name,Section__c FROM User WHERE Id = :userId];
        E_MOC_Application__c emocApp = [SELECT Status_Common_Workflow__c, Step__c FROM E_MOC_Application__c WHERE Id = :emocAppId];
        List<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingList = [SELECT Id, E_MOC_Application__c, Position__c, Require__c, CreatedById,
                                                                        Compliance_Standard__c, Compliance_Standard_Remark__c,
                                                                        Deviate_Standard__c, Deviate_Standard_Remark__c, N_A__c, N_A_Remark__c,
                                                                        TA3_Name_c__c, TA3_Id__c, TA3_Position_c__c, TA_Level__c,
                                                                        TA2_Name__c,TA2_Name__r.Name,TA2_Position__c,I_have_finished_technical_review__c,
                                                                        TA2_Indicator__c,TA2_Expert_Field__c,TA2_s_review_has_been_completed__c, Action_by_TA2__c,
                                                                        TA3_Indicator__c,TA3_Expert_Field__c, TA3_s_review_has_been_completed__c, Action_by_TA3__c,
                                                                        The_comment_need_to_be_verified__c,TA3_Comment__c,I_have_uploaded_the_deviation_form__c,Action_by_deviated_form__c
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
            reMapKeyChkUser.put('Enabled_TA_Checklist', false);
            reMapKeyChkUser.put('flgDisabledHold', false);
            reMapKeyChkUser.put('TA2_Name__c', taManMapping.TA2_Name__c);
            reMapKeyChkUser.put('TA2_Name__r_Name', taManMapping.TA2_Name__r.Name);
            reMapKeyChkUser.put('TA2_Position__c', taManMapping.TA2_Position__c);
            reMapKeyChkUser.put('flgShowIHaveFinishTechnicalReview', false);
            reMapKeyChkUser.put('I_have_finished_technical_review__c', taManMapping.I_have_finished_technical_review__c);
            if (currentUser != null) {
                if (currentUser.Section__c != null) {
                    reMapKeyChkUser.put('Enabled_TA_Checklist', currentUser.Section__c.indexOf(taManMapping.Position__c) != -1);
                } else {
                    reMapKeyChkUser.put('Enabled_TA_Checklist', true);
                }
               /* if (currentUser.UserRole.Name != null) {
                    if (currentUser.UserRole.Name.indexOf('Admin') != -1) {
                        reMapKeyChkUser.put('Enabled_TA_Checklist', true);
                    } else {
                        reMapKeyChkUser.put('Enabled_TA_Checklist', currentUser.UserRole.Name.indexOf(taManMapping.Position__c) != -1);
                    }
                }*/
            }
            if (taManMapping.TA3_Name_c__c != null || taManMapping.Compliance_Standard__c == true || taManMapping.Deviate_Standard__c == true || taManMapping.N_A__c == true) {
                reMapKeyChkUser.put('flgShowIHaveFinishTechnicalReview', true);
            }
            List<E_MOC_Hold_History__c> holdHistoryList = [SELECT Id
                                                             FROM E_MOC_Hold_History__c
                                                            WHERE E_MOC_Application__c = :emocAppId
                                                            AND Position__c = :taManMapping.Position__c
                                                            AND Status__c = :emocApp.Status_Common_Workflow__c
                                                            AND Step__c = :emocApp.Step__c];
            if (holdHistoryList.size() > 0) {
                reMapKeyChkUser.put('flgDisabledHold', true);
            }
            Integer countTaChecklist = [SELECT Count() FROM E_MOC_Result__c WHERE E_MOC_Application__c = :emocAppId AND Document__c = 'TA Checklist' AND Position__c = :taManMapping.Position__c];
            reMapKeyChkUser.put('Ta_Checklist_Result', countTaChecklist);
            reMapKeyChkUser.put('TA2_Indicator__c', taManMapping.TA2_Indicator__c);
            reMapKeyChkUser.put('TA2_Expert_Field__c', taManMapping.TA2_Expert_Field__c == null ? '' : taManMapping.TA2_Expert_Field__c);
            reMapKeyChkUser.put('TA2_s_review_has_been_completed__c', taManMapping.TA2_s_review_has_been_completed__c);
            reMapKeyChkUser.put('The_comment_need_to_be_verified__c', taManMapping.The_comment_need_to_be_verified__c); 
            reMapKeyChkUser.put('Action_by_TA2__c', taManMapping.Action_by_TA2__c == null ? '' : taManMapping.Action_by_TA2__c);
            reMapKeyChkUser.put('flgShowTa2Review', taManMapping.TA2_Indicator__c == null ? false : true);
            
            reMapKeyChkUser.put('TA3_Indicator__c', taManMapping.TA3_Indicator__c == null ? '' : taManMapping.TA3_Indicator__c);
            reMapKeyChkUser.put('TA3_Expert_Field__c', taManMapping.TA3_Expert_Field__c == null ? '' : taManMapping.TA3_Expert_Field__c);
            reMapKeyChkUser.put('TA3_s_review_has_been_completed__c', taManMapping.TA3_s_review_has_been_completed__c);
            reMapKeyChkUser.put('Action_by_TA3__c', taManMapping.Action_by_TA3__c == null ? '' : taManMapping.Action_by_TA3__c);
            reMapKeyChkUser.put('flgShowTa3Review', taManMapping.TA3_Indicator__c == null ? false : true);
            reMapKeyChkUser.put('TA3_Comment__c', taManMapping.TA3_Comment__c == null ? '' : taManMapping.TA3_Comment__c);
            reMapKeyChkUser.put('I_have_uploaded_the_deviation_form__c', taManMapping.I_have_uploaded_the_deviation_form__c);
            reMapKeyChkUser.put('Action_by_deviated_form__c', taManMapping.Action_by_deviated_form__c == null ? '' : taManMapping.Action_by_deviated_form__c);

            taManMappingReturn.add(reMapKeyChkUser);
        }
        return taManMappingReturn;
    }
    @RemoteAction
    global static E_MOC_Result__c[] generateTaChecklist(MAP<String, String> paramSearch) {
        String emocAppId = paramSearch.get('Id');
        String position = paramSearch.get('Position__c') == '' ? '%%' : paramSearch.get('Position__c');
        E_MOC_Application__c emocApp = [SELECT Id,Mechanical_change__c,Instrument_change__c,Electrical_change__c,Civil_change__c,Catalyst_Chemical__c,
                                                Design_limit_IOW_change__c,Tank_change_service__c,Idled_Retired_Assets_equipment__c,Air_Cooled_Exchangers__c,Fired_Heaters_Fire_Boiler__c,
                                                Pipes_Flanges_Valve__c,Tracing_steam_Steam_trap__c,Pressure_Vessels__c,Rotating_equipment__c,Relief_Systems__c,
                                                Shell_Tube_Heat_Exchangers__c,Tanks__c,SBM_CBM__c,HVAC_Refrigeration__c,Loading_arm_Jetty_Lorry__c,Hydraulic_power_unit__c,
                                                Safety_Equipment__c,Golden_weld__c,Hot_tap__c,Temporary_repair__c,Alarm__c,
                                                APC__c,Base_layer_control_DCS_PLC_TAS_TAM__c,SIF__c,Range__c,Control_valve__c,
                                                Instrumentation_equipment__c,QMI__c,Valve__c,Fire_Gas_detection_system__c,Electrical_equipment_system__c,
                                                Emergency_Backup_Systems__c,Communication__c,Driver_Actuator_process_at_Valve__c,Buildling_and_Road__c,Structures_foundations__c,
                                                Drainage_system_AOC_COC_etc_Bund__c,Refractory_Fireproof__c,Insulation__c,Painting_and_coating__c,Demolition__c,Mothballing__c,Preservation_unit__c,Area__c
                                        FROM E_MOC_Application__c WHERE Id = :emocAppId];
        E_MOC_TA_Mapping_Checklist__c[] emocTaMapChkList = [SELECT Type__c FROM E_MOC_TA_Mapping_Checklist__c WHERE Position__c LIKE :position];
        List<AggregateResult> maxVersionAgg = [SELECT MAX(Version__c)Max_Version FROM E_MOC_Result__c WHERE E_MOC_Application__r.Id = :emocAppId AND Document__c = 'TA Checklist' AND Position__c LIKE :position];
        List<E_MOC_Result__c> eMocResultList = new List<E_MOC_Result__c>();
        Decimal maxVerDeci = maxVersionAgg[0].get('Max_Version') != null ? Decimal.valueOf(String.valueOf(maxVersionAgg[0].get('Max_Version'))) : null;
        if (maxVersionAgg[0].get('Max_Version') != null) {
            eMocResultList = [SELECT    E_MOC_Application__c, Sequence__c, Type__c, Question_No__c, Question__c, Yes__c, No__c, N_A__c, Remark__c,CreatedBy.Name, Version__c, Document__c
                              FROM      E_MOC_Result__c
                              WHERE     E_MOC_Application__r.Id = :emocAppId
                              AND       Version__c = :maxVerDeci
                              AND       Document__c = 'TA Checklist'
                              AND       Position__c LIKE :position
                              ORDER BY  Sequence__c, Question_No__c];
        } else if (position != '%%') {
            String subCate = '';
            FOR (E_MOC_TA_Mapping_Checklist__c emocTaMapChk:emocTaMapChkList) {
                List<E_MOC_TA_Checklist_Require__c> tempEmocTaChkReqList = new List<E_MOC_TA_Checklist_Require__c>();
                if (emocTaMapChk.Type__c == 'Stationary Equipment and Piping Discipline Checklist') {
                    subCate = emocApp.Air_Cooled_Exchangers__c == true ? ',Air Cooled Exchangers' : '';
                    subCate += emocApp.Fired_Heaters_Fire_Boiler__c == true ? ',Fired Heaters / Fire Boiler' : '';
                    subCate += emocApp.Pipes_Flanges_Valve__c == true ? ',Pipes / Flanges / Valve' : '';
                    subCate += emocApp.Pressure_Vessels__c == true ? ',Pressure Vessels' : '';
                    subCate += emocApp.Tracing_steam_Steam_trap__c == true ? ',Tracing steam / Steam trap' : '';
                    subCate += emocApp.Relief_Systems__c == true ? ',Relief Systems' : '';
                    subCate += emocApp.Shell_Tube_Heat_Exchangers__c == true ? ',Shell & Tube Heat Exchangers' : '';
                    subCate += emocApp.Tanks__c == true ? ',Tanks' : '';
                    subCate += emocApp.SBM_CBM__c == true ? ',SBM/CBM' : '';
                    subCate += emocApp.Golden_weld__c == true ? ',Golden weld' : '';
                    subCate += emocApp.Hot_tap__c == true ? ',Hot tap' : '';
                    subCate += emocApp.Temporary_repair__c == true ? ',Temporary repair' : '';
                    subCate = subCate.length() > 0 ? subCate.substring(1) : '';
                } else if (emocTaMapChk.Type__c == 'Rotating Discipline Checklist') {
                    subCate = emocApp.Air_Cooled_Exchangers__c == true ? ',Air Cooled Exchangers' : '';
                    subCate += emocApp.Rotating_equipment__c == true ? ',Rotating equipment' : '';
                    subCate += emocApp.SBM_CBM__c == true ? ',SBM/CBM' : '';
                    subCate += emocApp.Loading_arm_Jetty_Lorry__c == true ? ',Loading arm (Jetty & Lorry)' : '';
                    subCate += emocApp.Hydraulic_power_unit__c == true ? ',Hydraulic power unit' : '';
                    subCate = subCate.length() > 0 ? subCate.substring(1) : '';
                } else if (emocTaMapChk.Type__c == 'Instrument Engineering Discipline Checklist') {
                    subCate = emocApp.Alarm__c == true ? ',Alarm' : '';
                    subCate += emocApp.APC__c == true ? ',APC' : '';
                    subCate += emocApp.SIF__c == true ? ',SIF' : '';
                    subCate += emocApp.Range__c == true ? ',Range' : '';
                    subCate += emocApp.Control_valve__c == true ? ',Control valve' : '';
                    subCate += emocApp.Instrumentation_equipment__c == true ? ',Instrumentation equipment' : '';
                    subCate += emocApp.Base_layer_control_DCS_PLC_TAS_TAM__c == true ? ',Base layer control (DCS), PLC, TAS/TAM' : '';
                    subCate += emocApp.QMI__c == true ? ',QMI' : '';
                    subCate += emocApp.Valve__c == true ? ',Valve (e.g. Pneumatic/Hydraulic,TSO, ROV, FSO)' : '';
                    subCate += emocApp.Fire_Gas_detection_system__c == true ? ',Fire & Gas detection system' : '';
                    subCate = subCate.length() > 0 ? subCate.substring(1) : '';
                } else if (emocTaMapChk.Type__c.indexOf('Electrical and Telecommunication Discipline Checklist') != -1) {
                    subCate = emocApp.Electrical_equipment_system__c == true ? ',Electrical equipment/system' : '';
                    subCate += emocApp.Emergency_Backup_Systems__c == true ? ',Emergency Backup Systems' : '';
                    subCate += emocApp.Communication__c == true ? ',Communication (e.g. talk-back, CCTV, radio, public announce & telecomunication network)' : '';
                    subCate += emocApp.Driver_Actuator_process_at_Valve__c == true ? ',Driver/Actuator (process) at Valve (e.g. Motor, MOV)' : '';
                    subCate = subCate.length() > 0 ? subCate.substring(1) : '';
                }
                if (subCate.indexOf(',') != -1 || subCate == '') {
                    FOR (E_MOC_Question__c forEmocQuestion : [SELECT Document__c,Sequence__c,Type__c,Question_No__c,Question__c
                                                        FROM E_MOC_Question__c
                                                        WHERE Type__c = :emocTaMapChk.Type__c
                                                        AND Document__c = 'TA Checklist'
                                                        ORDER BY  Sequence__c, Question_No__c]) {
                        E_MOC_TA_Checklist_Require__c emocTaChkReq = new E_MOC_TA_Checklist_Require__c();
                        emocTaChkReq.Document__c = forEmocQuestion.Document__c;
                        emocTaChkReq.Sequence__c = forEmocQuestion.Sequence__c;
                        emocTaChkReq.Type__c = forEmocQuestion.Type__c;
                        emocTaChkReq.Question_No__c = forEmocQuestion.Question_No__c;
                        emocTaChkReq.Question__c = forEmocQuestion.Question__c;
                        tempEmocTaChkReqList.add(emocTaChkReq);
                    }
                } else {
                    tempEmocTaChkReqList = [SELECT Document__c,Sequence__c,Type__c,Question_No__c,Question__c
                                            FROM E_MOC_TA_Checklist_Require__c
                                            WHERE Type__c = :emocTaMapChk.Type__c
                                            AND Notification_Sub_Type__c = :subCate
                                            ORDER BY  Sequence__c, Question_No__c];
                }
                for (E_MOC_TA_Checklist_Require__c forEmocTaChkReq : tempEmocTaChkReqList) {
                    E_MOC_Result__c eMocResult = new E_MOC_Result__c();
                    eMocResult.E_MOC_Application__c = emocAppId;
                    eMocResult.Sequence__c = forEmocTaChkReq.Sequence__c;
                    eMocResult.Type__c = forEmocTaChkReq.Type__c;
                    eMocResult.Question_No__c = forEmocTaChkReq.Question_No__c;
                    eMocResult.Question__c = forEmocTaChkReq.Question__c;
                    eMocResult.Yes__c = false;
                    eMocResult.No__c = false;
                    eMocResult.N_A__c = false;
                    eMocResult.Remark__c = '';
                    eMocResult.Version__c = 0;
                    eMocResult.Document__c = forEmocTaChkReq.Document__c;
                    eMocResultList.add(eMocResult);
                }
            }
        }
        return eMocResultList;
    }
    @RemoteAction
    global static E_MOC_Attachment_Consolidate__c[] getConsolidateComment(Map<String, String> searchParam) {
        String emocApplicationId = searchParam.get('emocApplicationId');
        return [SELECT Name, E_MOC_Doc_Type__c, E_MOC_Checklist_type__c FROM E_MOC_Attachment_Consolidate__c WHERE E_MOC_Application__c = :emocApplicationId];
    }
    public static String dateFormatMonddyyyy(String dateOrder) {
        String[] parts = dateOrder.split(' ');
        return parts[0].substring(8,10)+'/'+parts[0].substring(5,7)+ '/'+parts[0].substring(0,4);
    }
    public static List<E_MOC_TA_Mandatory_Mapping__c> generateTaMappingList(E_MOC_Application__c emocApp, String requireType) {
        String subCateMech;
        String subCateInst;
        String subCateElec;
        String subCateCivl;
        String subCateCata;
        String subCateDesi;
        String subCateTank;
        String subCateIdle;
        String mainQuery = '';
        if (emocApp.Area__c == 'F') {
            mainQuery = 'SELECT Position__c, TA_Level__c, Require__c, Indicator__c, User__c, Expert_field_for__c FROM E_MOC_TA_Mandatory_Master__c ' +
            'WHERE ((Area__c = \'F\' AND Plant_of_Main_Work_Center__c = \'' + emocApp.Maintenance_Plant__c + '\' AND Expert_field_for__c = \'TA2 Technology\') OR Area__c = null OR (Area__c = \'F\' AND Expert_field_for__c = \'TA2 Operation\')) ' +
            'AND Require__c = \'' + requireType + '\' AND TA_Level__c = \'2\' AND Indicator__c != null ';
        } else if (emocApp.Area__c == 'D') {
            mainQuery = 'SELECT Position__c, TA_Level__c, Require__c, Indicator__c, User__c, Expert_field_for__c FROM E_MOC_TA_Mandatory_Master__c ' +
            'WHERE ((Area__c = \'D\' AND PlantSection__c = \'' + emocApp.PlantSection__c + '\' AND Expert_field_for__c = \'TA2 Operation\') OR Area__c = null OR (Area__c = \'D\' AND Expert_field_for__c = \'TA2 Technology\')) ' +
            'AND Require__c = \'' + requireType + '\' AND TA_Level__c = \'2\' AND Indicator__c != null ';
        } else {
            mainQuery = 'SELECT Position__c, TA_Level__c, Require__c, Indicator__c, User__c, Expert_field_for__c FROM E_MOC_TA_Mandatory_Master__c ' +
            'WHERE ((Area__c = \'' + emocApp.Area__c + '\' AND Area__c NOT IN (\'D\', \'F\')) OR Area__c = null) ' +
            'AND Require__c = \'' + requireType + '\' AND TA_Level__c = \'2\' AND Indicator__c != null ';
        }
        List<E_MOC_TA_Mandatory_Master__c> emocTaManMasterList = new List<E_MOC_TA_Mandatory_Master__c>();
        Set<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingSet = new Set<E_MOC_TA_Mandatory_Mapping__c>();
        if (requireType == 'Require') {
            List<E_MOC_TA_Mandatory_Mapping__c> delEmocTaManMapList = [SELECT Id FROM E_MOC_TA_Mandatory_Mapping__c WHERE E_MOC_Application__c = :emocApp.Id AND Require__c = 'Require' AND TA_Level__c = '2'];
            Delete delEmocTaManMapList;
        }
        // =====Mechanical_change__c, 'Mechanical'
        if (emocApp.Mechanical_change__c == true) {
            subCateMech = emocApp.Air_Cooled_Exchangers__c == true ? ',\'Air Cooled Exchangers\'' : '';
            subCateMech += emocApp.Fired_Heaters_Fire_Boiler__c == true ? ',\'Fired Heaters / Fire Boiler\'' : '';
            subCateMech += emocApp.Pipes_Flanges_Valve__c == true ? ',\'Pipes / Flanges / Valve\'' : '';
            subCateMech += emocApp.Pressure_Vessels__c == true ? ',\'Pressure Vessels\'' : '';
            subCateMech += emocApp.Tracing_steam_Steam_trap__c == true ? ',\'Tracing steam/Steam trap\'' : '';
            subCateMech += emocApp.Rotating_equipment__c == true ? ',\'Rotating equipment\'' : '';
            subCateMech += emocApp.Relief_Systems__c == true ? ',\'Relief Systems\'' : '';
            subCateMech += emocApp.Shell_Tube_Heat_Exchangers__c == true ? ',\'Shell & Tube Heat Exchangers\'' : '';
            subCateMech += emocApp.Tanks__c == true ? ',\'Tanks\'' : '';
            subCateMech += emocApp.SBM_CBM__c == true ? ',\'SBM/CBM\'' : '';
            subCateMech += emocApp.HVAC_Refrigeration__c == true ? ',\'HVAC & Refrigeration\'' : '';
            subCateMech += emocApp.Loading_arm_Jetty_Lorry__c == true ? ',\'Loading arm (Jetty & Lorry)\'' : '';
            subCateMech += emocApp.Hydraulic_power_unit__c == true ? ',\'Hydraulic power unit\'' : '';
            subCateMech += emocApp.Safety_Equipment__c == true ? ',\'Safety Equipment\'' : '';
            subCateMech += emocApp.Golden_weld__c == true ? ',\'Golden weld\'' : '';
            subCateMech += emocApp.Hot_tap__c == true ? ',\'Hot tap\'' : '';
            subCateMech += emocApp.Temporary_repair__c == true ? ',\'Temporary repair\'' : '';
            subCateMech = subCateMech.length() > 0 ? subCateMech.substring(1) : '';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Mechanical\' AND Sub_Category_Type__c IN (' + subCateMech + ')');
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
        }
        // ====Instrument_change__c, 'Instrument'
        if (emocApp.Instrument_change__c == true) {
            subCateInst = emocApp.Alarm__c == true ? ',\'Alarm\'' : '';
            subCateInst += emocApp.APC__c == true ? ',\'APC\'' : '';
            subCateInst += emocApp.SIF__c == true ? ',\'SIF\'' : '';
            subCateInst += emocApp.Range__c == true ? ',\'Range\'' : '';
            subCateInst += emocApp.Control_valve__c == true ? ',\'Control valve\'' : '';
            subCateInst += emocApp.Instrumentation_equipment__c == true ? ',\'Instrumentation equipment\'' : '';
            subCateInst += emocApp.Base_layer_control_DCS_PLC_TAS_TAM__c == true ? ',\'Base layer control (DCS), PLC, TAS/TAM\'' : '';
            subCateInst += emocApp.QMI__c == true ? ',\'QMI\'' : '';
            subCateInst += emocApp.Valve__c == true ? ',\'Valve (e.g. Pneumatic/Hydraulic,TSO, ROV, FSO)\'' : '';
            subCateInst += emocApp.Fire_Gas_detection_system__c == true ? ',\'Fire & Gas detection system\'' : '';
            subCateInst = subCateInst.length() > 0 ? subCateInst.substring(1) : '';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Instrument\' AND Sub_Category_Type__c IN (' + subCateInst + ')');
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
        }
        // ====Electrical_change__c, 'Electrical'
        if (emocApp.Electrical_change__c == true) {
            subCateElec = emocApp.Electrical_equipment_system__c == true ? ',\'Electrical equipment/system\'' : '';
            subCateElec += emocApp.Emergency_Backup_Systems__c == true ? ',\'Emergency Backup Systems\'' : '';
            subCateElec += emocApp.Communication__c == true ? ',\'Communication (e.g. talk-back, CCTV, radio, public announce & telecomunication network)\'' : '';
            subCateElec += emocApp.Driver_Actuator_process_at_Valve__c == true ? ',\'Driver/Actuator (process) at Valve (e.g. Motor, MOV)\'' : '';
            subCateElec = subCateElec.length() > 0 ? subCateElec.substring(1) : '';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Electrical\' AND Sub_Category_Type__c IN (' + subCateElec + ')');
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
        }
        // ====Civil_change__c == true ? 'Civil' : '';
        if (emocApp.Civil_change__c == true) {
            subCateCivl = emocApp.Buildling_and_Road__c == true ? ',\'Buidling and Road\'' : '';
            subCateCivl += emocApp.Structures_foundations__c == true ? ',\'Structures / foundations\'' : '';
            subCateCivl += emocApp.Drainage_system_AOC_COC_etc_Bund__c == true ? ',\'Drainage system (AOC, COC, etc)  / Bund\'' : '';
            subCateCivl += emocApp.Refractory_Fireproof__c == true ? ',\'Refractory/Fireproof\'' : '';
            subCateCivl += emocApp.Insulation__c == true ? ',\'Insulation\'' : '';
            subCateCivl += emocApp.Painting_and_coating__c == true ? ',\'Painting and coating\'' : '';
            subCateCivl = subCateCivl.length() > 0 ? subCateCivl.substring(1) : '';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Civil\' AND Sub_Category_Type__c IN (' + subCateCivl + ')');
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
        }
        if (emocApp.Catalyst_Chemical__c == true) {
            subCateCata = '\'Catalyst & Chemical\'';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Catalyst & Chemical\' AND Sub_Category_Type__c IN (' + subCateCata + ')');
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
        }
        if (emocApp.Design_limit_IOW_change__c == true) {
            subCateDesi = '\'Design limit + Integrity Operating window (IOW)\'';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Design limit + Integrity Operating window (IOW)\' AND Sub_Category_Type__c IN (' + subCateDesi + ')');
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
        }
        if (emocApp.Tank_change_service__c == true) {
            subCateTank = '\'Tank change service\'';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Tank change service\' AND Sub_Category_Type__c IN (' + subCateTank + ')');
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
        }
        // ====Idled_Retired_Assets_equipment__c == true ? 'Idled / Retired Assets (equipment)' : '';
        if (emocApp.Idled_Retired_Assets_equipment__c == true) {
            subCateIdle = emocApp.Demolition__c == true ? ',\'Demolition\'' : '';
            subCateIdle += emocApp.Mothballing__c == true ? ',\'Mothballing/Preservation\'' : '';
            subCateIdle += emocApp.Preservation_unit__c == true ? ',\'Preservation unit\'' : '';
            subCateIdle = subCateIdle.length() > 0 ? subCateIdle.substring(1) : '';
            emocTaManMasterList = database.query(mainQuery + 'AND Category_Type__c = \'Idled / Retired Assets (equipment)\' AND Sub_Category_Type__c IN (' + subCateIdle + ')');
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
    global static Map<String, Object> saveTaHold (MAP<String, String> paramSave) {
        Map<String, Object> responseStatus= new Map<String, Object>();
        Id emocAppId = paramSave.get('emocAppId');
        String holdPosition = paramSave.get('Position__c');
        String remarkHold = paramSave.get('remarkHold');
        E_MOC_Application__c emocApp = [SELECT Id,Change_Type__c,RAM_Total__c,Step__c,
                                                Status_Common_Workflow__c,Next_Reminder_Date__c
                                        FROM E_MOC_Application__c
                                        WHERE Id = :emocAppId];
        List<E_MOC_Timeline__c> emocTimelineList = [SELECT Day__c, Status__c
                                                    FROM E_MOC_Timeline__c
                                                    WHERE Status__c = :emocApp.Status_Common_Workflow__c
                                                    AND Change_Type__c = :emocApp.Change_Type__c
                                                    AND RAM_Level__c = :emocApp.RAM_Total__c
                                                    AND Step__c = :emocApp.Step__c
                                                    LIMIT 1];
        E_MOC_Hold_History__c emocHoldHis = new E_MOC_Hold_History__c();
        emocHoldHis.Comment__c = remarkHold;
        emocHoldHis.E_MOC_Application__c = emocApp.Id;
        emocHoldHis.Step__c = emocApp.Step__c;
        emocHoldHis.Next_Reminder_Date__c = emocApp.Next_Reminder_Date__c;
        emocHoldHis.Position__c = holdPosition;
        if (emocTimelineList.size() == 0) {
            emocHoldHis.Status__c = emocApp.Status_Common_Workflow__c;
            emocHoldHis.Day__c = 0;
        } else {
            emocHoldHis.Status__c = emocTimelineList[0].Status__c;
            emocHoldHis.Day__c = emocTimelineList[0].Day__c;
        }
        if (emocApp.Next_Reminder_Date__c == null) {
            emocApp.Next_Reminder_Date__c = System.today();
        }
        emocApp.Next_Reminder_Date__c = (emocApp.Next_Reminder_Date__c + Integer.valueOf(emocHoldHis.Day__c));
        System.savepoint sp = Database.setSavepoint();
        try{
            update emocApp;
            insert emocHoldHis;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Save successful!');
            responseStatus.put('emocApplicationId', emocApp.Id);
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage insert E_MOC_Application__c: '+ex.getMessage());
            responseStatus.put('errorMessage','insert E_MOC_Application__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        return responseStatus;
    }
    @RemoteAction
    global static Map<String, Object> saveTaSendBack (MAP<String, String> paramSave) {
        Map<String, Object> responseStatus= new Map<String, Object>();
        String emocAppId = paramSave.get('emocAppId');
        String sendbackComment = paramSave.get('TA_Sendback_Comment__c');
        E_MOC_Application__c emocApp = new E_MOC_Application__c();
        emocApp.Id = emocAppId;
        emocApp.TA_Sendback_Comment__c = sendbackComment;
        emocApp.Status_Common_Workflow__c = 'Detailed Design/Study';
        Map<String,String> paramFlow = new Map<String, String>();
        paramFlow.put('recordId', emocAppId);
 
        System.savepoint sp = Database.setSavepoint();
        try{
            upsert emocApp;
            Flow.Interview.EMOC_Send_email_to_initiator flow1 = new Flow.Interview.EMOC_Send_email_to_initiator(paramFlow);
        	flow1.start();
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Save successful!');
            responseStatus.put('emocApplicationId', emocApp.Id);
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage insert E_MOC_Application__c: '+ex.getMessage());
            responseStatus.put('errorMessage','insert E_MOC_Application__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        return responseStatus;
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
			userReturn.put('TA3_Name__c',forTa3ManMaster.TA3_Name__c != null ? forTa3ManMaster.TA3_Name__c : '');
                                                                 
            ta3ReturnList.add(userReturn);
            if (ta3ReturnList.size() >= 99) {
                break;
            }
        }
        return ta3ReturnList;
    }
    @RemoteAction
    global static Map<String, Object> callFlowReturnToReviewStepConcernedTA (MAP<String, String> paramSave) {
        Map<String, Object> responseStatus= new Map<String, Object>();
        String emocAppId = paramSave.get('emocAppId');
        Map<String,String> paramFlow = new Map<String, String>();
        paramFlow.put('recordId', emocAppId);
        if (!Test.isRunningTest()) {
            Flow.Interview.E_MOC_Notification_TA_Confirm_to_MOC_2 flow1 = new Flow.Interview.E_MOC_Notification_TA_Confirm_to_MOC_2(paramFlow);
            flow1.start(); 
        }
        System.savepoint sp = Database.setSavepoint();
        try{
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Save successful!');
            responseStatus.put('emocApplicationId', emocAppId);
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage insert E_MOC_Application__c: '+ex.getMessage());
            responseStatus.put('errorMessage','insert E_MOC_Application__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        return responseStatus;
    }
    
    @RemoteAction
    global static void callAutomationTask(String oldStatusCommon, String newStatusCommon, Id emocId, String newStatusFunctional, String oldStatusFunctional) {
        
        string query = 'SELECT Id, Subject, Status  FROM Task WHERE WhatId = \'' + emocId + '\' AND Status = \'Open\'  ';
        if (oldStatusCommon == 'Concept Approval' && newStatusCommon == 'Budget Registration') {
            query += ' AND (Subject = \'Concept Approval-1-Line Manager\' OR Subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMA\' OR Subject = \'Approval #2 SM\' OR Subject = \'Approval #2 POM\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMB\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMC\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMD\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENME\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMF\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPA\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPB\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPC\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPD\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPE\' '+ 
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNFX\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNFL\' '+
                ' OR subject = \'Concept Approval-2-APUs-SCSC\' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMA\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMB\' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMC\' '+ 
                ' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMD\' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENME\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMF\' OR subject = \'Concept Approval-2-APUs\' OR subject = \'Concept Approval-3-APUs\' )';
        } else if (oldStatusCommon == 'Budget Registration' && newStatusCommon == 'Detailed Design/Study') {
            query += ' AND (Subject = \'Budget Approval\' OR Subject = \'Budget Estimate Initial\' )';
        } else if (oldStatusCommon == 'Detailed Design/Study' && newStatusCommon == 'Hazard Screening') {
            query += ' AND Subject = \'Budget Estimate Final & Detailed Design/Study\' ';
        } else if (oldStatusCommon == 'Hazard Screening' && newStatusCommon == 'Technical Review') {
            query += ' AND (Subject = \'Risk Analysis\' OR Subject = \'Risk Approval\' )';
        } else if (oldStatusCommon == 'Technical Review' && newStatusCommon == 'APU Approval') {
            query += ' AND (Subject = \'TA Review\' OR Subject = \'TA3 Review\'  OR Subject = \'Technical review by MOC Focal point\' )';
        } else if (oldStatusCommon == 'APU Approval' && newStatusCommon == 'VP Approval') {
            query += ' AND Subject = \'APU Approval\' ';
        } else if (oldStatusCommon == 'VP Approval' && newStatusCommon == 'Implementation') {
            query += ' AND Subject = \'VP Approval\' ';
        } else if (oldStatusCommon == 'Implementation' && newStatusCommon == 'Readiness Review') {
            query += ' AND (Subject = \'Fill in the budget number\' OR Subject = \'Issue WO to distribute work\'  OR Subject = \'Distribute work to concerned party (Executer)\' )';
        } else if (oldStatusCommon == 'Readiness Review' && (newStatusCommon == 'Close Out' || newStatusCommon == 'Monitoring')) {
            query += ' AND Subject = \'SOF/SU Approval\' ';
        } else if (oldStatusCommon == 'Close Out' && newStatusCommon == 'Closed') {
            query += ' AND (Subject = \'Verify whether all documents/drawing is updated\' OR Subject = \'Ensure all requirement is met objectives\' )';
        } else if (newStatusFunctional == 'Implementation#1' && oldStatusFunctional == 'Approval #1') {
            query += ' AND (Subject = \'Approval #1 ASM\' OR Subject = \'Approval #1 SM or POM\' OR Subject = \'Approval #1 Mechanical Duty Engineer\' OR Subject = \'Approval #1 ENMx or Duty Engineer\' OR Subject = \'Approval #1 POM\' OR Subject = \'Approval #1 SM\'  OR Subject = \'Approval #1 Engineer\' )';
        } else if ((newStatusFunctional == 'Risk assessment' || newStatusFunctional == 'Implementation#2') && oldStatusFunctional == 'Approval #2') {
            query += ' AND (Subject = \'Approval #2 ASM\' OR Subject = \'Approval #2 SM or POM\' OR Subject = \'Approval #2 SM\' OR Subject = \'Approval #2 POM\' )';
        }else if (newStatusFunctional == 'Close out' && oldStatusFunctional == 'Return to normal condition') {
            query += ' AND (Subject = \'ASM check work completion\' )';
        }
        
        List<Task> recordsToUpdate = new List<Task>();
        List<Task> TaskList = new List<Task>();
        TaskList = Database.query(query);
        if (TaskList.size() > 0) {
            for(Task taskL:TaskList) {
                taskL.Status = 'Completed';
                recordsToUpdate.add(taskL);
            }
          
            update recordsToUpdate;
        }
    }
}