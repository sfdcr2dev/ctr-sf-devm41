public class  EMOC_ApplicationTriggerHandler {
    public static void onBeforeUpdateEmocApp(List<E_MOC_Application__c> emocAppList, Map<Id,E_MOC_Application__c> oldEmoc){
        for (E_MOC_Application__c emocApp : emocAppList) {
            E_MOC_Application__c oldEmocApp = oldEmoc.get(emocApp.Id);
            // EMOC_EmocAppBeforeUpdateTrigger
            
            if (emocApp.Status_Common_Workflow__c == 'Concept Approval' && oldEmocApp.Status_Common_Workflow__c == 'Emergency Approval') {
                emocApp.Emergency_Concept_Date__c = System.now();
            }
            if (emocApp.Status_Common_Workflow__c == 'Closed' && oldEmocApp.Status_Common_Workflow__c == 'Close Out') {
                emocApp.Update_close_date__c = System.now();
            }
            if (emocApp.Extend_Require_to_extend__c == true && oldEmocApp.Extend_Require_to_extend__c == false && emocApp.E_MOC_Type__c == 'Common Workflow') {
                emocApp.Status_Common_Workflow__c = 'Hazard Screening';
            }
            if (((emocApp.Yes_Require_to_demolish__c == true && oldEmocApp.Yes_Require_to_demolish__c == false) || (emocApp.Return_to_Normal__c == true && oldEmocApp.Return_to_Normal__c == false) || (emocApp.Not_Extend_Require_to_extend_to_prevent__c == true && oldEmocApp.Not_Extend_Require_to_extend_to_prevent__c == false)) && emocApp.E_MOC_Type__c == 'Common Workflow') {
                emocApp.Status_Common_Workflow__c = 'Close Out';
            }
            if (emocApp.Status_Common_Workflow__c == 'Implementation' && oldEmocApp.Status_Common_Workflow__c == 'VP Approval' && emocApp.Type_A_Maintenance_budget__c == true) {
                Functional_Location__c funcLoc = [SELECT Id, wbsElement__c FROM Functional_Location__c WHERE Id = :emocApp.Functional_Location__c];
                emocApp.wbs_element__c = funcLoc.wbsElement__c;
            }
            if (emocApp.Status_Common_Workflow__c == 'Monitoring' && oldEmocApp.Status_Common_Workflow__c != 'Readiness Review') {
                emocApp.Extend_Require_to_extend__c = false;
                emocApp.Extend_Require_to_extend_to_prevent__c = false;
            }
            if (emocApp.Status_Common_Workflow__c == 'E-MOC Register') {
                emocApp.Status_Common_Report__c = 'MS01';
            } else if (emocApp.Status_Common_Workflow__c == 'Concept Approval') {
                emocApp.Status_Common_Report__c = 'MS01';
            } else if (emocApp.Status_Common_Workflow__c == 'Emergency Approval') {
                emocApp.Status_Common_Report__c = 'MS01';
            } else if (emocApp.Status_Common_Workflow__c == 'Budget Registration') {
                emocApp.Status_Common_Report__c = 'MS01';
            } else if (emocApp.Status_Common_Workflow__c == 'Detailed Design/Study') {
                emocApp.Status_Common_Report__c = (emocApp.Extend_Require_to_extend__c) ? 'MS04' : 'MS01';
            } else if (emocApp.Status_Common_Workflow__c == 'Hazard Screening') {
                emocApp.Status_Common_Report__c = (emocApp.Extend_Require_to_extend__c) ? 'MS04' : 'MS01';
            } else if (emocApp.Status_Common_Workflow__c == 'Technical Review') {
                if (emocApp.Extend_Require_to_extend__c) {
                    emocApp.Status_Common_Report__c = 'MS04';
                } else {
                    emocApp.Status_Common_Report__c = (emocApp.Diff_TA2s_review__c || emocApp.Diff_TA_MOC_review__c) ? 'MS02-D' : 'MS02';
                }
            } else if (emocApp.Status_Common_Workflow__c == 'APU Approval') {
                if (emocApp.Extend_Require_to_extend__c) {
                    emocApp.Status_Common_Report__c = 'MS04';
                } else {
                    emocApp.Status_Common_Report__c = (emocApp.Diff_VP_APU__c) ? 'MS02-D' : 'MS02';
                }
            } else if (emocApp.Status_Common_Workflow__c == 'VP Approval') {
                if (emocApp.Extend_Require_to_extend__c) {
                    emocApp.Status_Common_Report__c = 'MS04';
                } else {
                    emocApp.Status_Common_Report__c = (emocApp.Diff_Implementation_VP__c) ? 'MS02-D' : 'MS02';
                }
            } else if (emocApp.Status_Common_Workflow__c == 'Implementation') {
                if (emocApp.Extend_Require_to_extend__c) {
                    emocApp.Status_Common_Report__c = 'MS04';
                } else {
                    emocApp.Status_Common_Report__c = (emocApp.Diff_Trigger_Implement__c || emocApp.Diff_Read_Implement__c) ? 'MS03-D' : 'MS03';
                }
            } else if (emocApp.Status_Common_Workflow__c == 'Readiness Review') {
                if (emocApp.Extend_Require_to_extend__c) {
                    emocApp.Status_Common_Report__c = 'MS04';
                } else {
                    emocApp.Status_Common_Report__c = (emocApp.Diff_Readiness_PSSR_Select__c || emocApp.Diff_Readiness_PSSR_review__c || emocApp.Diff_Readiness_PSSR_approve__c) ? 'MS03-D' : 'MS03';
                }
            } else if (emocApp.Status_Common_Workflow__c == 'Monitoring') {
                if (emocApp.Extend_Require_to_extend__c) {
                    emocApp.Status_Common_Report__c = 'MS04';
                } else {
                    emocApp.Status_Common_Report__c = (emocApp.Not_Extend_Require_to_extend__c) ? 'MS06' : 'MS03';
                }
            } else if (emocApp.Status_Common_Workflow__c == 'Close Out') {
                if (emocApp.Diff_ADOE_Verify__c || emocApp.Diff_MOC_verify__c || emocApp.Diff_closed__c) {
                    emocApp.Status_Common_Report__c = 'MS05-D';
                } else {
                    emocApp.Status_Common_Report__c = (emocApp.Diff_Mainorder_closed__c) ? 'MS03-D' : 'MS05';
                }
            } else if (emocApp.Status_Common_Workflow__c == 'Lesson Learn') {
                emocApp.Status_Common_Report__c = 'MS07';
            } else if (emocApp.Status_Common_Workflow__c == 'Closed') {
                emocApp.Status_Common_Report__c = 'MS07';
            } else if (emocApp.Status_Common_Workflow__c == 'Cancelled') {
                emocApp.Status_Common_Report__c = 'MS08';
            } else if (emocApp.Status_Common_Workflow__c == 'Rejected') {
                emocApp.Status_Common_Report__c = 'MS09';
            }
            if (emocApp.End_date__c != null && (emocApp.Status_Common_Workflow__c == 'Detailed Design/Study' || emocApp.Status_Common_Workflow__c == 'Hazard Screening' || emocApp.Status_Common_Workflow__c == 'Technical Review' || emocApp.Status_Common_Workflow__c == 'APU Approval' || emocApp.Status_Common_Workflow__c == 'VP Approval' || emocApp.Status_Common_Workflow__c == 'Implementation' || emocApp.Status_Common_Workflow__c == 'Readiness Review' || emocApp.Status_Common_Workflow__c == 'Monitoring')) {
                Datetime CurrentDate = system.now();
                Datetime endDate = emocApp.End_date__c;
                Integer noOfDays = endDate.Date().daysBetween(CurrentDate.Date());
                if (noOfDays > 0) {
                    emocApp.Status_Common_Report__c = 'MS10';
                }
            }
            // EMOC_BeforeUpdateStatusFnTrigger
            if (emocApp.Status_Functional_Override__c == 'Approval #3 (VP)' && oldEmocApp.Status_Functional_Override__c == 'Approval #3 (APU)') {
                emocApp.VP_Date__c = System.now();
            }
            if (emocApp.Not_Extend_Require_to_extend__c == true && oldEmocApp.Not_Extend_Require_to_extend__c == false && emocApp.E_MOC_Type__c == 'Functional Override') {
                emocApp.Status_Functional_Override__c = 'Return to normal condition';
            }
            if (emocApp.Extend_Require_to_extend__c == true && oldEmocApp.Extend_Require_to_extend__c == false && emocApp.Status_Functional_Override__c == 'Implementation#2' && emocApp.E_MOC_Type__c == 'Functional Override') {
                emocApp.Status_Functional_Override__c = 'Risk assessment';
            }
            if (emocApp.TA_Selection_confirmed__c == true && oldEmocApp.TA_Selection_confirmed__c == false && emocApp.Status_Functional_Override__c == 'Technical review' && emocApp.E_MOC_Type__c == 'Functional Override') {
                EMOC_EmocFuncOverController.ApprovalProcess(emocApp.Id);
            }
            if (emocApp.Status_Functional_Override__c == 'Create') {
                emocApp.Status_FN_Report__c = 'MS01';
            } else if (emocApp.Status_Functional_Override__c == 'Approval #1') {
                emocApp.Status_FN_Report__c = 'MS01';
            } else if (emocApp.Status_Functional_Override__c == 'Implementation#1') {
                emocApp.Status_FN_Report__c = 'MS01';
            } else if (emocApp.Status_Functional_Override__c == 'Approval #2') {
                emocApp.Status_FN_Report__c = (emocApp.Diff_Approval_2__c) ? 'MS10' : 'MS02';
            } else if (emocApp.Status_Functional_Override__c == 'Risk assessment') {
                emocApp.Status_FN_Report__c = (emocApp.Diff_risk_assessment_end_date__c) ? 'MS10' : 'MS02';
            } else if (emocApp.Status_Functional_Override__c == 'Technical review') {
                emocApp.Status_FN_Report__c = (emocApp.Diff_technical_review_end_date__c) ? 'MS10' : 'MS02';
            } else if (emocApp.Status_Functional_Override__c == 'Approval #3 (APU)') {
                emocApp.Status_FN_Report__c = (emocApp.Diff_APU_TA_FN__c) ? 'MS10' : 'MS02';
            } else if (emocApp.Status_Functional_Override__c == 'Approval #3 (VP)') {
                emocApp.Status_FN_Report__c = (emocApp.Diff_VP_APU_FN__c) ? 'MS10' : 'MS02';
            } else if (emocApp.Status_Functional_Override__c == 'Implementation#2') {
                if (emocApp.Extend_Require_to_extend__c) {
                    emocApp.Status_FN_Report__c = 'MS04';
                } else {
                    emocApp.Status_FN_Report__c = (emocApp.Diff_Implementation_end_date__c) ? 'MS10' : 'MS03';
                }
            } else if (emocApp.Status_Functional_Override__c == 'Return to normal condition') {
                emocApp.Status_FN_Report__c = 'MS05';
            } else if (emocApp.Status_Functional_Override__c == 'Close out') {
                emocApp.Status_FN_Report__c = 'MS07';
            } else if (emocApp.Status_Functional_Override__c == 'Cancelled') {
                emocApp.Status_FN_Report__c = 'MS08';
            } else if (emocApp.Status_Functional_Override__c == 'Rejected') {
                emocApp.Status_FN_Report__c = 'MS09';
            }
        }
    } 
    public static void onBeforeUpdateEmocAppTask(List<E_MOC_Application__c> emocAppList, Map<Id,E_MOC_Application__c> oldEmoc){
        List<sObject> recordsToUpdate = new List<sObject>();
        for (E_MOC_Application__c emocApp : emocAppList) {
            E_MOC_Application__c oldEmocApp = oldEmoc.get(emocApp.Id);
			
            if ((oldEmocApp.Status_Common_Workflow__c == 'Concept Approval' && emocApp.Status_Common_Workflow__c == 'Budget Registration') 
				|| (oldEmocApp.Status_Common_Workflow__c == 'Budget Registration' && emocApp.Status_Common_Workflow__c == 'Detailed Design/Study')
				|| (oldEmocApp.Status_Common_Workflow__c == 'Hazard Screening' && emocApp.Status_Common_Workflow__c == 'Technical Review')
                || (oldEmocApp.Status_Common_Workflow__c == 'APU Approval' && emocApp.Status_Common_Workflow__c == 'VP Approval')
                || (oldEmocApp.Status_Common_Workflow__c == 'VP Approval' && emocApp.Status_Common_Workflow__c == 'Implementation')
                || (oldEmocApp.Status_Common_Workflow__c == 'Readiness Review' && (emocApp.Status_Common_Workflow__c == 'Close Out' || emocApp.Status_Common_Workflow__c == 'Monitoring'))
                || (oldEmocApp.Status_Common_Workflow__c == 'Close Out' && emocApp.Status_Common_Workflow__c == 'Closed')
                || (oldEmocApp.Status_Common_Workflow__c == 'Detailed Design/Study' && emocApp.Status_Common_Workflow__c == 'Hazard Screening')
				|| (oldEmocApp.Status_Common_Workflow__c == 'Technical Review' && emocApp.Status_Common_Workflow__c == 'APU Approval')
				|| (oldEmocApp.Status_Common_Workflow__c == 'Implementation' && emocApp.Status_Common_Workflow__c == 'Readiness Review')
                || (emocApp.Status_Functional_Override__c == 'Implementation#1' && oldEmocApp.Status_Functional_Override__c == 'Approval #1')
                || ((emocApp.Status_Functional_Override__c == 'Risk assessment' || emocApp.Status_Functional_Override__c == 'Implementation#2') && oldEmocApp.Status_Functional_Override__c == 'Approval #2')
                || (emocApp.Status_Functional_Override__c == 'Close out' && oldEmocApp.Status_Functional_Override__c == 'Return to normal condition')) {

                    String oldStatusCommon = oldEmocApp.Status_Common_Workflow__c;
                    String newStatusCommon = emocApp.Status_Common_Workflow__c;
                    String newStatusFunctional = emocApp.Status_Functional_Override__c;
                    String oldStatusFunctional = oldEmocApp.Status_Functional_Override__c;
                    Id emocId = emocApp.Id;
                    EMOC_CreateEmocController.callAutomationTask(oldStatusCommon, newStatusCommon, emocId, newStatusFunctional, oldStatusFunctional);
             }
            if (emocApp.Status_Common_Workflow__c == 'Technical Review' && oldEmocApp.Status_Common_Workflow__c == 'Hazard Screening' && emocApp.Change_Type__c == 'Temporary' && (emocApp.Extend_Require_to_extend__c == true || emocApp.Extend_Require_to_extend_to_prevent__c == true)) {
                emocApp.I_have_incorporated_comments__c = false;
                for(E_MOC_TA_Mandatory_Mapping__c taMandatoryMappingList: [SELECT Id, TA2_s_review_has_been_completed__c, Action_by_TA2__c FROM E_MOC_TA_Mandatory_Mapping__c where E_MOC_Application__c = :emocApp.Id]){
                    taMandatoryMappingList.TA2_s_review_has_been_completed__c = false;
                    taMandatoryMappingList.Action_by_TA2__c = null;
                    recordsToUpdate.add(taMandatoryMappingList);
                }
            }
        }
        update recordsToUpdate;
    }
    
    public static void onAfterUpdateEmocApp(List<E_MOC_Application__c> emocAppList, Map<Id,E_MOC_Application__c> oldEmoc){
        List<E_MOC_TA_Mandatory_Mapping__c> emocTaManMappingList = new List<E_MOC_TA_Mandatory_Mapping__c>();
        List<E_MOC_Attachment_Risk_analysis__c> listInsAttRiskAnalysis = new List<E_MOC_Attachment_Risk_analysis__c>();
        List<E_MOC_Attachment_Risk_analysis__c> listDelAttRiskAnalysis = new List<E_MOC_Attachment_Risk_analysis__c>();
        for (E_MOC_Application__c emocApp : emocAppList) {
            E_MOC_Application__c oldEmocApp = oldEmoc.get(emocApp.Id);

            if (emocApp.Status_Common_Workflow__c == 'Hazard Screening' && oldEmocApp.Status_Common_Workflow__c == 'Detailed Design/Study') {
                emocTaManMappingList = EMOC_CreateEmocController.generateTaMappingList(emocApp, 'Require');
            }
            // EMOC_FuncOverAfterGenTaMappingTrigger
            if ((emocApp.Status_Functional_Override__c == 'Risk assessment' && oldEmocApp.Status_Functional_Override__c == 'Approval #2') && (emocApp.MOS_for_maintenance__c == true || emocApp.Safeguarding_force_signal__c == true)) {
                emocTaManMappingList = EMOC_EmocFuncOverController.generateTaMappingList(emocApp, 'Require');
            }

            if (emocApp.HAZOP__c == true && oldEmocApp.HAZOP__c == false) {
                E_MOC_Attachment_Risk_analysis__c attRiskAnalysis = new E_MOC_Attachment_Risk_analysis__c();
                attRiskAnalysis.E_MOC_Application__c = emocApp.ID;
                attRiskAnalysis.E_MOC_Checklist_type__c = 'HAZOP Checklist';
                attRiskAnalysis.E_MOC_Doc_Type__c = 'Risk analysis';
                listInsAttRiskAnalysis.add(attRiskAnalysis);
            }
            if (emocApp.HRA__c == true && oldEmocApp.HRA__c == false) {
                E_MOC_Attachment_Risk_analysis__c attRiskAnalysis = new E_MOC_Attachment_Risk_analysis__c();
                attRiskAnalysis.E_MOC_Application__c = emocApp.ID;
                attRiskAnalysis.E_MOC_Checklist_type__c = 'HRA Checklist';
                attRiskAnalysis.E_MOC_Doc_Type__c = 'Risk analysis';
                listInsAttRiskAnalysis.add(attRiskAnalysis);
            }
            if (emocApp.Environmental_Impact__c == true && oldEmocApp.Environmental_Impact__c == false) {
                E_MOC_Attachment_Risk_analysis__c attRiskAnalysis = new E_MOC_Attachment_Risk_analysis__c();
                attRiskAnalysis.E_MOC_Application__c = emocApp.ID;
                attRiskAnalysis.E_MOC_Checklist_type__c = 'ENVI Impact Checklist';
                attRiskAnalysis.E_MOC_Doc_Type__c = 'Risk analysis';
                listInsAttRiskAnalysis.add(attRiskAnalysis);
            }
            if (emocApp.Reliability_Checklist__c == true && oldEmocApp.Reliability_Checklist__c == false) {
                E_MOC_Attachment_Risk_analysis__c attRiskAnalysis = new E_MOC_Attachment_Risk_analysis__c();
                attRiskAnalysis.E_MOC_Application__c = emocApp.ID;
                attRiskAnalysis.E_MOC_Checklist_type__c = 'Reliability Checklist';
                attRiskAnalysis.E_MOC_Doc_Type__c = 'Risk analysis';
                listInsAttRiskAnalysis.add(attRiskAnalysis);
            }
            
            if (emocApp.HAZOP__c == false && oldEmocApp.HAZOP__c == true) {
                List<E_MOC_Attachment_Risk_analysis__c> attRiskAnalysis = [SELECT Id FROM E_MOC_Attachment_Risk_analysis__c WHERE E_MOC_Application__c = :emocApp.ID AND E_MOC_Checklist_type__c = 'HAZOP Checklist' LIMIT 1];
                if (attRiskAnalysis.size() > 0) {
                    listDelAttRiskAnalysis.add(attRiskAnalysis[0]);
                }
            }
            if (emocApp.HRA__c == false && oldEmocApp.HRA__c == true) {
                List<E_MOC_Attachment_Risk_analysis__c> attRiskAnalysis = [SELECT Id FROM E_MOC_Attachment_Risk_analysis__c WHERE E_MOC_Application__c = :emocApp.ID AND E_MOC_Checklist_type__c = 'HRA Checklist' LIMIT 1];
                if (attRiskAnalysis.size() > 0) {
                    listDelAttRiskAnalysis.add(attRiskAnalysis[0]);
                }
            }
            if (emocApp.Environmental_Impact__c == false && oldEmocApp.Environmental_Impact__c == true) {
                List<E_MOC_Attachment_Risk_analysis__c> attRiskAnalysis = [SELECT Id FROM E_MOC_Attachment_Risk_analysis__c WHERE E_MOC_Application__c = :emocApp.ID AND E_MOC_Checklist_type__c = 'ENVI Impact Checklist' LIMIT 1];
                if (attRiskAnalysis.size() > 0) {
                    listDelAttRiskAnalysis.add(attRiskAnalysis[0]);
                }
            }
            if (emocApp.Reliability_Checklist__c == false && oldEmocApp.Reliability_Checklist__c == true) {
                List<E_MOC_Attachment_Risk_analysis__c> attRiskAnalysis = [SELECT Id FROM E_MOC_Attachment_Risk_analysis__c WHERE E_MOC_Application__c = :emocApp.ID AND E_MOC_Checklist_type__c = 'Reliability Checklist' LIMIT 1];
                if (attRiskAnalysis.size() > 0) {
                    listDelAttRiskAnalysis.add(attRiskAnalysis[0]);
                }
            }

            // EMOC_NotificationTrigger
            if (emocApp.Status_Common_Workflow__c == 'Implementation' && emocApp.MOC_Type__c == 'Normal' && emocApp.Notification__c == null) {
                if (emocApp.Status_Common_Workflow__c != oldEmocApp.Status_Common_Workflow__c) {
                    Map<String, Object> returnData = EMOC_NotificationController.submitNotification(emocApp.Id);
                }
            } else if (emocApp.Status_Common_Workflow__c == 'Concept Approval' && emocApp.MOC_Type__c == 'Emergency' && emocApp.Notification__c == null) {
                if (emocApp.Status_Common_Workflow__c != oldEmocApp.Status_Common_Workflow__c) {
                    Map<String, Object> returnData = EMOC_NotificationController.submitNotification(emocApp.Id);
                }
            } else if (emocApp.status_functional_override__c == 'Implementation#1' && emocApp.functional_override__c == true && emocApp.Notification__c == null) {
                system.debug('auto create 1' + emocApp.status_functional_override__c + ' | ' + oldEmocApp.status_functional_override__c);
                if (emocApp.status_functional_override__c != oldEmocApp.status_functional_override__c) {
                    system.debug('auto create 2');
                    Map<String, Object> returnData = EMOC_NotificationController.submitNotification(emocApp.Id);
                }
            } else if (emocApp.status_functional_override__c == 'Close out' && emocApp.functional_override__c == true && emocApp.Notification__c != null) {
                if (emocApp.status_functional_override__c != oldEmocApp.status_functional_override__c) {
                    Map<String, String> paramSave = new Map<String, String>();
                    paramSave.put('Id', emocApp.Notification__c);
                    paramSave.put('Notification_Status__c', 'Closed');
                    paramSave.put('Integration_Status__c', 'In Progress');
                    paramSave.put('E_MOC_Application_No__c', emocApp.Id); 
                    EMOC_NotificationController.putNotification(paramSave);
                }
            } else if ((emocApp.Status_Common_Workflow__c == 'Closed' || emocApp.Status_Common_Workflow__c == 'Cancelled') && emocApp.Common_Workflow__c == true && emocApp.Notification__c != null) {
                if (emocApp.Status_Common_Workflow__c != oldEmocApp.Status_Common_Workflow__c) {
                    Map<String, String> paramSave = new Map<String, String>();
                    paramSave.put('Id', emocApp.Notification__c);
                    paramSave.put('Notification_Status__c', 'Closed');
                    paramSave.put('Integration_Status__c', 'In Progress');
                    paramSave.put('E_MOC_Application_No__c', emocApp.Id); 
                    EMOC_NotificationController.putNotification(paramSave);
                }
            }
        }
        
        insert emocTaManMappingList;
        insert listInsAttRiskAnalysis;
        delete listDelAttRiskAnalysis;
    }
}