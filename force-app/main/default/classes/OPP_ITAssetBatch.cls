public without sharing class OPP_ITAssetBatch extends MethodUtils implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful {
    private Map<String /* Email Key */, PISUsers__c> pisUsersMap {
        get {
            if (pisUsersMap == null) {
                pisUsersMap = new Map<String, PISUsers__c>();
                for (PISUsers__c pisUser :[SELECT Name,User__c,ReportToUser__c,SectHeadUpUser__c,COMPANYCODE__c,CONTRACT__c,DEPARTMENT__c, EMAIL__c, EMPLOYEEID__c FROM PISUsers__c]){
                    if(pisUser.EMAIL__c != null) {
                        pisUsersMap.put(pisUser.EMAIL__c.toLowercase(), pisUser);
                    }
                }
            }
            return pisUsersMap;
        }
        set;
    }

    public OPP_ITAssetBatch() {

    }

    public Iterable<Object> start(Database.BatchableContext BC) {
        Map<String, Object> result = OPP_CalloutPMAssetService.calloutITAsset();
        List<Object> itAssetList = (List<Object>)getResult('Data.Data', result);
        return isNotEmpty(itAssetList) ? itAssetList : new List<Object>();
    }
    
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<OPP_IT_Asset__c> itAssetList = new List<OPP_IT_Asset__c>();
        for (Object obj : scope) {
            String email = ((String)getResult('EMAIL', obj))?.toLowercase();
            itAssetList.add(new OPP_IT_Asset__c(
                Name = (String)getResult('WINNO', obj),
                WinNo_Reference_key__c = (String)getResult('WINNO', obj),
                Asset_Category__c = (String)getResult('ASSETCATEGOTY', obj),
                Asset_Type__c = (String)getResult('ASSETTYPE', obj),
                Asset_Status__c = (String)getResult('AssetStatus', obj),
                IsDelete_By_PM_Asset__c = (Boolean)getResult('IsDelete', obj),
                IsPoolUser__c = (Boolean)getResult('IsPoolUser', obj),
                Email__c = email,
                User__c = pisUsersMap.get(email)?.User__c
            ));          
        }
        Database.upsert(itAssetList, OPP_IT_Asset__c.Fields.WinNo_Reference_key__c, false);
    }

    public void finish(Database.BatchableContext BC) {
        List<OPP_IT_Asset__c> itAssetList = [SELECT Id FROM OPP_IT_Asset__c WHERE IsDelete_By_PM_Asset__c = true];
        Database.DeleteResult[]  lsr = Database.delete(itAssetList, false);
    }
}