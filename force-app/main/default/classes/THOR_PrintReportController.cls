public without sharing class THOR_PrintReportController {

    @AuraEnabled
    public static  EQCC_Step__c getPrintRecordId(String recordId)
    {
        
            try {
                system.debug('recordId='+ recordId);
                List<EQCC_Step__c> eqccStepList = [SELECT Id, Form_Code__c, Header_Sheet__r.Name
                                        FROM EQCC_Step__c 
                                        WHERE Id =: recordId LIMIT 1];
                system.debug('eqccStep'+ eqccStepList);
                
                if (eqccStepList.size() >= 1){
                    return eqccStepList[0];
                } 
                else {
                    return null;
                } 
                

            }
            catch (Exception e) {
                system.debug(e.getLineNumber() + e.getMessage());
                throw new AuraHandledException(e.getMessage());
            }
    }
    /*
    @AuraEnabled
    public static String getPrintStepId(String stepId)
    {
        
            List<ProcessInstanceStep> processSteps = [
            SELECT
            Id,
            ActorId,
            Comments,
            StepStatus,
            ProcessInstance.Status,
            ProcessInstance.TargetObjectId,
            CreatedDate
            FROM ProcessInstanceStep
            WHERE Id = :stepId
            ORDER BY CreatedDate DESC LIMIT 1];

    return processSteps[0].ProcessInstance.TargetObjectId;
    //          catch (Exception e) {
    //             system.debug(e.getLineNumber() + e.getMessage());
    //             throw new AuraHandledException(e.getMessage());
    //         }
     }
*/
}