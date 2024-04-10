public without sharing class OPP_SoftwareAssetBatch extends MethodUtils implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful {
    private Map<String, OPP_Software_Asset__c> softwareAssetParentMap;

    public OPP_SoftwareAssetBatch(){
        softwareAssetParentMap = new Map<String, OPP_Software_Asset__c>();
    }
    
    public Iterable<Object> start(Database.BatchableContext BC) {
        Map<String, Object> result = OPP_CalloutPMAssetService.calloutSoftwareAsset();
        List<Object> itAssetList = (List<Object>)getResult('Data.Data', result);
        return isNotEmpty(itAssetList) ? itAssetList : new List<Object>();
    }
    
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<OPP_Software_Asset__c>  softwareAssetList = new List<OPP_Software_Asset__c>();
        for (Object obj : scope){
            String ReferenceID = (String)getResult('ReferenceID', obj);
            String PARENTREFERENCEID = (String)getResult('PARENTREFERENCEID', obj);
            if(!softwareAssetParentMap.containsKey(PARENTREFERENCEID)){
                softwareAssetParentMap.put(PARENTREFERENCEID, new OPP_Software_Asset__c(
                    ReferenceID__c = PARENTREFERENCEID,
                    Name = (String)getResult('PARENTSOFTWARENAME', obj),
                    Master_Software_Name__c = (String)getResult('PARENTSOFTWARENAME', obj),
                    Count_License__c = (Integer)getResult('ParentLicenseAmt', obj),
                    License_Type__c = (String)getResult('LICENSETYPE', obj), 
                    //2022-05-10 DG Service issue #86
                    LASTESTUNITPRICE__c = Decimal.valueOf((String)getResult('LASTESTUNITPRICE', obj)),
                    LASTESTUNITPRICECURR__c = (String)getResult('LASTESTUNITPRICECURR', obj),
                    //2022-05-10 DG Service issue #86
                    IsDelete_By_PM_Asset__c = (Boolean)getResult('IsDelete', obj)
                ));
            }

            if(ReferenceID.contains('_')) {
                String CHILDSOFTWARENAME = (String)getResult('CHILDSOFTWARENAME', obj);
                String CHILDSOFTWAREVERSION = (String)getResult('CHILDSOFTWAREVERSION', obj);
                softwareAssetList.add(new OPP_Software_Asset__c(
                    Parent_Software__r = new OPP_Software_Asset__c(
                        ReferenceID__c = softwareAssetParentMap.get(PARENTREFERENCEID).ReferenceID__c
                    ),
                    Name = String.format('{0} {1}', new List<String>{ 
                        CHILDSOFTWARENAME,
                        isNotEmpty(CHILDSOFTWARENAME) && isNotEmpty(CHILDSOFTWAREVERSION) &&
                        CHILDSOFTWARENAME?.contains(CHILDSOFTWAREVERSION) ? '' : (isNotEmpty(CHILDSOFTWAREVERSION) ? CHILDSOFTWAREVERSION : '')
                    }),
                    Count_License__c = (Decimal)getResult('ParentLicenseAmt', obj),
                    License_Type__c = (String)getResult('LICENSETYPE', obj),
                    License_Total__c = null,
                    License_Using__c = null,
                    ManuFacturer__c = null,
                    Master_Software_Code__c = (String)getResult('PARENTSOFTWARECODE', obj),
                    Master_Software_Name__c = (String)getResult('PARENTSOFTWARENAME', obj),
                    CHILDSOFTWARENAME__c = CHILDSOFTWARENAME,
                    CHILDSOFTWAREVERSION__c = CHILDSOFTWAREVERSION,
                    //2022-05-10 DG Service issue #86
                    //LASTESTUNITPRICE__c = Decimal.valueOf((String)getResult('LASTESTUNITPRICE', obj)),
                    //LASTESTUNITPRICECURR__c = (String)getResult('LASTESTUNITPRICECURR', obj),
                    LASTESTUNITPRICE__c = null,
                    LASTESTUNITPRICECURR__c = null,
                    //2022-05-10 DG Service issue #86
                    ReferenceID__c = (String)getResult('ReferenceID', obj),
                    IsDelete_By_PM_Asset__c = (Boolean)getResult('IsDelete', obj),
                    Status__c = null
                ));
            }
        }

        List<OPP_Software_Asset__c> upsertParentData = new List<OPP_Software_Asset__c>();
        for (OPP_Software_Asset__c parentSoftwareAsset : softwareAssetParentMap.values()) {
            if(parentSoftwareAsset.Id == null) {
                upsertParentData.add(parentSoftwareAsset);
            }
        }
        
        if(upsertParentData.size() > 0) Database.upsert(upsertParentData, OPP_Software_Asset__c.Fields.ReferenceID__c, false);
        if(softwareAssetList.size() > 0) {
            List<Database.upsertResult> results = Database.upsert(softwareAssetList, OPP_Software_Asset__c.Fields.ReferenceID__c, false);
            for (Database.upsertResult sr : results) {
                if (!sr.isSuccess()) {
                    System.debug(System.LoggingLevel.ERROR, String.format('{0}: {1}', new List<Object>{sr.getId(),sr.getErrors()}));
                }
            }
        }
    }

    public void finish(Database.BatchableContext BC) {
        List<OPP_Software_Asset__c> softwareAssetList = [SELECT Id FROM OPP_Software_Asset__c];
    }
}