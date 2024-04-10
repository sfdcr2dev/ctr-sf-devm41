public with sharing class CTRLeadOverideNewController {
    @AuraEnabled
    public static RecordType getRecordTypeName(String recordTypeId){
        List<RecordType> recordTypeName =[SELECT DeveloperName,Name FROM RecordType WHERE Id=: recordTypeId];
        return recordTypeName[0];
    }

    @AuraEnabled
    public static Lead getRecordTypeNameByRecordId(String recordId){
        List<Lead> recordTypeName =[SELECT Id,RecordType.Name,RecordType.DeveloperName FROM Lead WHERE Id=: recordId];
        return recordTypeName[0];
    }
    
    @AuraEnabled
    public static List<string> getTOPType(){
        String TypeName = CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(),null).BusinessUnit__c;
        List<RecordType> recordType =[SELECT id,Name,DeveloperName FROM RecordType WHERE Name=: TypeName];
        list <string> returnThis = new list<string>();
        if(TypeName == 'TOP'){
            returnThis.add('TOP');
            returnThis.add(recordType[0].id);
        }
       return returnThis;
    }
    
    @AuraEnabled
    public static  List<Lead> viewDuplicate(String firstName, String company, String formerNameofCompany, String isArchive){
        List<Lead> duplicationItems = new List<Lead>();
        List<Lead> verifyItems = new List<Lead>();
        Lead l = new Lead();
        l.firstname = firstname;
        l.Company = company;
        l.FormerNameofCompany__c = formerNameofCompany;
        l.isArchive__c = isArchive;
        verifyItems.add(l);
        System.debug(verifyItems);

        List<Datacloud.FindDuplicatesResult> findDuplicatesResults = Datacloud.FindDuplicates.findDuplicates(verifyItems);

        if(findDuplicatesResults.size() == 0) {
            return duplicationItems;
        }
        List<Id> posibleLeadIds = new List<Id>();

        for (Datacloud.FindDuplicatesResult findDupeResult : findDuplicatesResults) {
            for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                    for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                        if(!posibleLeadIds.contains(matchRecord.record.Id)) {
                            posibleLeadIds.add(matchRecord.record.Id);
                        }
                    }
                }
            }
        }
        if(posibleLeadIds.size() > 0) {
            duplicationItems = [SELECT Id, Name, LeadNo__c, InterestedProductTypeasCustomer__c, InterestedProductTypeAsCustomerTX__c, Company, RegisteredAs__c, Email, SectionofLeadOwner__c, Status, CreatedDate  FROM Lead WHERE Id IN: posibleLeadIds];
        }
        
        return duplicationItems;
    }
}