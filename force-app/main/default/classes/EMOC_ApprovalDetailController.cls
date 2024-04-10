global class EMOC_ApprovalDetailController {
   @RemoteAction
    global static Map<String, Object> getDetailApproval (MAP<String, String> searchParam) {
        String Id = searchParam.get('Id');
        String sobjecttype = searchParam.get('sobjecttype');
		String emocAppId = '';
        Map<String, Object> detailApproval = new Map<String, Object>();
        detailApproval.put('RecordTypeName', ''); 
        if (sobjecttype == 'ProcessInstanceStep') {
            ProcessInstanceStep[] piStep = [SELECT Id, ProcessInstance.TargetObjectId  FROM ProcessInstanceStep WHERE Id = :Id   ];
            if (piStep.size() > 0) {
            	emocAppId = piStep[0].ProcessInstance.TargetObjectId;
            }
            
        } else {
            ProcessInstanceWorkItem[] piStep = [SELECT Id, ProcessInstance.TargetObjectId  FROM ProcessInstanceWorkItem where Id = :Id];
            if (piStep.size() > 0) {
                emocAppId = piStep[0].ProcessInstance.TargetObjectId;
            }
        }
        if (emocAppId != '') {
            E_MOC_Application__c[] emocApp = [SELECT Id
                                              , Functional_Location__r.Name
                                              , Type_A_Maintenance_budget__c, Type_B_Operation_budget__c, Type_M_Maintenance_project__c
                                              , Type_P_Plant_change_budget__c, Type_S_Shutdown_budget__c, Type_V_Un_plan_shutdown_budget__c
                                              , Description_of_change__c
                                              , Air_Cooled_Exchangers__c, Fired_Heaters_Fire_Boiler__c, Pipes_Flanges_Valve__c
                                              , Tracing_steam_Steam_trap__c, Pressure_Vessels__c, Rotating_equipment__c, Relief_Systems__c
                                              , Shell_Tube_Heat_Exchangers__c, Tanks__c, SBM_CBM__c
                                              , HVAC_Refrigeration__c, Loading_arm_Jetty_Lorry__c, Hydraulic_power_unit__c
                                              , Safety_Equipment__c, Golden_weld__c, Hot_tap__c
                                              , Temporary_repair__c, Alarm__c, APC__c
                                              , Base_layer_control_DCS_PLC_TAS_TAM__c, SIF__c, Range__c
                                              , Control_valve__c, Instrumentation_equipment__c, QMI__c
                                              , Valve__c, Fire_Gas_detection_system__c, Electrical_equipment_system__c
                                              , Emergency_Backup_Systems__c, Communication__c, Driver_Actuator_process_at_Valve__c
                                              , Buildling_and_Road__c, Structures_foundations__c, Drainage_system_AOC_COC_etc_Bund__c
                                              , Catalyst_Chemical__c, Design_limit_IOW_change__c, Tank_change_service__c
                                              , Demolition__c, Mothballing__c, Preservation_unit__c 
                                              , Completion_date__c, Start_date__c, End_date__c
                                              , MOC_Type__c, Change_Type__c, RAM_Total__c
                                              , Functional_Location_Description__c
                                              , Common_Workflow__c, Functional_Override__c
                                              , OOS__c, MOS_for_ops_purpose__c, Inhibit_for_process_or_Equipment_S_D__c
                                              , Inhibit_alarm_for_maintenance__c, Disable_Alarm_by_Ops_for_HW__c, Inhibit_Alarm_request_for_FOX__c
                                              , MOS_for_maintenance__c, Safeguarding_force_signal__c
                                              , RecordType.Name, Reason_of_Work__c, Budget_Estimate_Initial__c
                                              FROM E_MOC_Application__c WHERE Id = :emocAppId Limit 1];
            if (emocApp.size() > 0) {
				Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(emocApp[0]));
                detailApproval.putAll(obj);
                detailApproval.put('Functional_Location__c', emocApp[0].Functional_Location__r.Name);
                detailApproval.put('Completion_date__c', emocApp[0].Completion_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApp[0].Completion_date__c)) : '');
                detailApproval.put('Start_date__c', emocApp[0].Start_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApp[0].Start_date__c)) : '');
                detailApproval.put('End_date__c', emocApp[0].End_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApp[0].End_date__c)) : '');
                detailApproval.put('RecordTypeName', emocApp[0].RecordType.Name);
            } else {
                detailApproval.put('RecordTypeName', 'Standard');
            }
        }
        return detailApproval;
    } 
    
    public static String dateFormatMonddyyyy(String dateOrder) {
        String[] parts = dateOrder.split(' ');
        return parts[0].substring(8,10)+'/'+parts[0].substring(5,7)+ '/'+parts[0].substring(0,4);
    }
}