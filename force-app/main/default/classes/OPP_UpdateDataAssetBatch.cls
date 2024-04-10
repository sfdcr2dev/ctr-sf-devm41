public without sharing class OPP_UpdateDataAssetBatch extends MethodUtils implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    transient Database.SaveResult[] srList = new List<Database.SaveResult>();
    private static Map<String, PISUsers__c> pisUserMap{
        get {
            if(pisUserMap == null){
                pisUserMap = new Map<String, PISUsers__c>();
                for (PISUsers__c pisUser : [SELECT Id, User__c, EMAIL__c FROM PISUsers__c]){ pisUserMap.put(pisUser.User__c, pisUser); }
            }
            return pisUserMap;
        }
        set;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Case__c, Case__r.Borrow_Period_Start_date__c,Case__r.Borrow_Period_End_date__c,Asset_Owner__c,Asset_Owner__r.Email,New_WinNo__c, New_WinNo__r.WinNo_Reference_key__c, New_WinNo__r.IsPoolUser__c,OPP_IT_Asset__r.WinNo_Reference_key__c,Is_Summited_PMAsset__c, IsForceChange__c FROM OPP_Case_Line_Items__c WHERE Case__r.RecordType.Name LIKE 'Hardware%' AND Case__r.Status = 'In Progress'AND Is_Summited_PMAsset__c = false AND New_WinNo__c <> null ORDER BY CreatedDate ASC]);
    }
    
    public void execute(Database.BatchableContext BC, List<OPP_Case_Line_Items__c> scope) {
        List<OPP_Case_Line_Items__c> caselineItemsUpdate = new List<OPP_Case_Line_Items__c>();
        List<OPP_IT_Asset__c> itAssetListUpdate = new List<OPP_IT_Asset__c>();
        for(OPP_Case_Line_Items__c caselineItems : (List<OPP_Case_Line_Items__c>)scope) {
            Map<String, Object> result = OPP_CalloutPMAssetService.calloutUpdateDataAsset(pisUserMap.get(caselineItems.Asset_Owner__c), caselineItems);
            Boolean IsSuccess = (Boolean)MethodUtils.getResult('ReponseBody.Result.IsSuccess', result);
            caselineItemsUpdate.add(new OPP_Case_Line_Items__c(
                Id = (Id)MethodUtils.getResult('ReponseBody.Result.CaseLineItemID', result),
                Is_Summited_PMAsset__c = IsSuccess,
                Response_PM_Asset__c = MethodUtils.serializePrettyString(JSON.serialize(result))
            ));
            if(IsSuccess) {
                itAssetListUpdate.add(new OPP_IT_Asset__c(
                    Id = caselineItems.New_WinNo__c,
                    IsPoolUser__c = false
                ));
            }
        }
        srList = Database.update(caselineItemsUpdate, false);
        Database.update(itAssetListUpdate, false);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {             
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }       
    }
    public void finish(Database.BatchableContext BC) {  }
}