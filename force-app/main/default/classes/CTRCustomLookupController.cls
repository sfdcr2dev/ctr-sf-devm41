public without sharing class CTRCustomLookupController {

    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String objectName, String whereCondition) 
    {
        try {
            /*String searchKey = '';
            String searchAllKey = '';
            List<String> SplitsearchKeyWord = searchKeyWord.split(' ');
            decimal count = 0;
            if(SplitsearchKeyWord.size() > 0 ){
                for(String keyword : SplitsearchKeyWord){
                    searchKey = searchKey + 'Name LIKE ' + '\'%' + keyword + '%\'';
                    searchAllKey = searchAllKey + 'Name LIKE ' + '\'%' + keyword + '%\'';
                    
                    count = count + 1;
                    if(count < SplitsearchKeyWord.size()){
                        searchKey = searchKey + ' AND ';
                        searchAllKey = searchAllKey + ' AND ';
                    }
                }
                
                
            }
            else{
                searchKey = 'Name LIKE ' + '\'%' + searchKey + '%\'';
                searchAllKey = 'Name LIKE ' + '\'%' + searchKey + '%\'';
            }*/
            
            String searchKey = '%'+searchKeyWord + '%';
            String searchAllKey = '%'+searchKeyWord+'%';
            String andWhere = whereCondition;         
            System.debug('objectName : '+objectName);
            List < sObject > returnList = new List < sObject > ();
            String sQuery = 'select id, Name, Description from ' +objectName + ' where Name LIKE: searchKey ' + andWhere + ' order by createdDate DESC limit 5';
            // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
            
                sQuery =  'select Id, Name from ' +objectName + ' where Name LIKE: searchKey ' + andWhere + ' order by createdDate DESC limit 5';
            
            system.debug('searchKey : ' + searchKey);
            system.debug('sQuery : ' + sQuery);
            
            List < sObject > lstOfRecords = Database.query(sQuery);
            
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
            return returnList;
        } catch (Exception e) 
        {
            String mError = 'error customlookup line:'+e.getLineNumber()+'|| message:'+e.getMessage();
            System.debug(mError);
            throw new AuraHandledException(mError);
        }
    }
    
    @AuraEnabled
    public static List<SObject> searchRecords(String objectName, String fieldName, String conditionString) {
        String objectApiName = objectName.toLowerCase();
        String soqlQuery = '';
        List<SObject> records = new List<SObject>();
        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        if (objDescribe.isSearchable()) {
            if (String.isNotBlank(conditionString)) {
                soqlQuery = 'SELECT Id, ' + fieldName + ' FROM ' + objectApiName + ' WHERE ' + conditionString;
            } else {
                soqlQuery = 'SELECT Id, ' + fieldName + ' FROM ' + objectApiName;
            }
            records.addAll(Database.query(soqlQuery));
        }
        return records;
    }

    @AuraEnabled
    public static List<SObject> getLookupValue(String objectName, String lookupId){
        String objectApiName = objectName.toLowerCase();
        List<SObject> records = new List<SObject>();
        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        if (objDescribe.isSearchable()) {
            String soqlQuery = 'SELECT Id, Name FROM ' + objectApiName + ' WHERE Id = \'' + lookupId + '\'';
            records.add(Database.query(soqlQuery));
        }
        return records;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getEmailUsers() {
        List<Map<String, String>> userList = new List<Map<String, String>>();

        // Add custom user
        Map<String, String> customEntry = new Map<String, String>();
        customEntry.put('label', 'Wuttisak Testing, aunwuttisak@gmail.com');
        customEntry.put('value', 'aunwuttisak@gmail.com');
        userList.add(customEntry);

        Map<String, String> customEntry2 = new Map<String, String>();
        customEntry2.put('label', 'Wuttisak Kuchita, wuttisak.kct@gmail.com');
        customEntry2.put('value', 'wuttisak.kct@gmail.com');
        userList.add(customEntry2);
        
        Map<String, String> customEntry3 = new Map<String, String>();
        customEntry3.put('label', 'Email Service');
        customEntry3.put('value', 'ccemailcommitteetestuser@278tumlkpac10g9kik3znxpnfa13iz7hj9w1rudnbh2cj8m2pw.1m-2nh5eam.cs117.apex.sandbox.salesforce.com');
        userList.add(customEntry3);
        
        //test user
        Map<String, String> customEntry4 = new Map<String, String>();
        customEntry4.put('label', 'test Email Service');
        customEntry4.put('value', 'an.t@roundtwosolutions.com');
        userList.add(customEntry4);
        
        for (User user : [SELECT Id, Name, Email, IsActive from User  WHERE IsActive = true]) {
            Map<String, String> userData = new Map<String, String>();
            userData.put('label', user.Name + ', ' + user.Email);
            userData.put('value', user.Email);
            userList.add(userData);
        }

        // Add entries from the query
        /*for (PISUsers__c user : [SELECT Name, EMAIL__c FROM PISUsers__c WHERE Active__c = true]) {
            Map<String, String> userData = new Map<String, String>();
            userData.put('label', user.Name + ', ' + user.EMAIL__c);
            userData.put('value', user.EMAIL__c);
            userList.add(userData);
        }*/
        

        return userList;
    }
}