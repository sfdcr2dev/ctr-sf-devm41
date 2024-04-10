public without sharing class OPP_CaseController {
    @AuraEnabled
    public static void deleteDGRequestCaseById(Id recordId){
        try {
            Case caseToDelete = new Case(Id = recordId);
            delete caseToDelete;
        } catch (Exception e) {
            throw new AuraHandledException(String.format(recordId + ': {0}\r\n{1}', new List<Object>{
                e.getMessage(),
                e.getStackTraceString()
            }));
        }
    }

    @AuraEnabled
    public static Boolean isEmployee(){
        return [SELECT User_Type__c FROM User Where Id =:UserInfo.getUserId()]?.User_Type__c=='employee';
    }
    
    @AuraEnabled
    public static PISUsers__c requesterType(Id recordId){
        return[SELECT User_Type__c FROM PISUsers__c WHERE User__c =:recordId AND Active__c =True AND MAINPOSITION__c = True Limit 1];
    }

    @AuraEnabled
    public static Case getHardwareCase(){
        return new Case(
            Status = 'Draft',
            Requester__c = isEmployee() ? UserInfo.getUserId() : null,
            Request_Type__c = '',
            Hardware_Type__c = ''
        );
    }

    @AuraEnabled
    public static Case getSoftwareCase(){
        return new Case(
            Status = 'Draft',
            Requester__c = isEmployee() ? UserInfo.getUserId() : null,
            // RecordTypeId = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Software').getRecordTypeId(),
            Request_Type__c = ''
        );
    }
    
    @AuraEnabled
    public static Case getProjectCase(){
        Case c = new Case();
        //c.RecordTypeId = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Project_Request').getRecordTypeId();
        c.Requester__c = isEmployee() ? UserInfo.getUserId() : null;
        c.Status = 'Draft';
        //insert c;
        return c;
    }

    @AuraEnabled
    public static Case getIncidentCase(){
        return new Case(
            RecordTypeId = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Incident').getRecordTypeId(),
            Requester__c = isEmployee() ? UserInfo.getUserId() : null,
            Status = 'Draft'
        );
    }

    @AuraEnabled
    public static Case getOtherCase(){
        Case c = new Case();
        c.RecordTypeId = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Others').getRecordTypeId();
        c.Requester__c = isEmployee() ? UserInfo.getUserId() : null;
        c.Status = 'Draft';
        //insert c;
        return c;
    }

    @AuraEnabled
    public static Case getITStationeryCase(){
        return new Case(
            Status = 'Draft',
            Requester__c = isEmployee() ? UserInfo.getUserId() : null,
            Request_Type__c = ''
        );
    }
    
    @AuraEnabled
    public static Case getAuthorizationCase(){
        return new Case(
            Status = 'Draft',
            Requester__c = isEmployee() ? UserInfo.getUserId() : null,
            // RecordTypeId = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('IT_Stationery').getRecordTypeId(),
            Request_Type__c = ''
        );
    }

    @AuraEnabled
    public static Case getCaseById(Id recordId){
        return[SELECT Id,RecordTypeId,RecordType.DeveloperName,Software_Type__c,Request_Type__c,Authorization_Category__c FROM Case WHERE Id = :recordId];
    }

    @AuraEnabled
    public static List<OPP_Case_Line_Items__c> getCaseLineItemByCaseId(Id recordId){
        return[ SELECT Id, New_WinNo__c,New_WinNo__r.Name,Is_Summited_PMAsset__c FROM OPP_Case_Line_Items__c WHERE Case__c = :recordId AND Case__c <> null];
    }
    // Case - hardware recordtype (catalog/ non catalog)
    @AuraEnabled
    public static void saveCaseLineItem(List<OPP_Case_Line_Items__c> records, Id caseId){
        try {
            // List<OPP_Case_Line_Items__c> oppCaseLineItems = new List<OPP_Case_Line_Items__c>();
            String recordName = [SELECT RecordType.DeveloperName FROM Case WHERE Id = :caseId]?.RecordType?.DeveloperName;
            Map<String, Schema.RecordTypeInfo> caseLineItemRecordTypes = OPP_Case_Line_Items__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            //System.debug('recordName>>'+recordName);
            //System.debug('caseLineItemRecordTypes>>'+caseLineItemRecordTypes);
            for(OPP_Case_Line_Items__c record : records) {
                record.Case__c = caseId;
                record.RecordTypeId = caseLineItemRecordTypes.get(recordName)?.getRecordTypeId();
            }
            insert records;
        } catch (Exception e) {
            //System.debug(System.LoggingLevel.ERROR, e.getmessage());
            //System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Object getCaseRecordTpyeInfoes(){
        Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
        return JSON.deserializeUntyped(JSON.serialize(R.getRecordTypeInfosByDeveloperName()));
    }
    @AuraEnabled(cacheable=true)
    public static Object getCaseLineItemRecordTpyeInfoes(){
        Schema.DescribeSObjectResult R = OPP_Case_Line_Items__c.SObjectType.getDescribe();
        return JSON.deserializeUntyped(JSON.serialize(R.getRecordTypeInfosByDeveloperName()));
    }
    
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        return OPP_FileUploaderHelper.uploadFile(base64, filename, recordId);
    }

    @AuraEnabled 
    public static Map<String, String> getCasePicklistValues(String sobjectName, String fieldName) {
        try {
            Map<String, String> options = new Map<String, String>();
            // Schema.DescribeFieldResult fieldResult = Case.Request_Type__c.getDescribe();
            Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe()
                                                        .get(sobjectName.toLowerCase())
                                                        .getDescribe().fields
                                                        .getMap()
                                                        .get(fieldName)
                                                        .getDescribe();
            List<Schema.PicklistEntry> pValues = fieldResult?.getPicklistValues();
            for (Schema.PicklistEntry p: pValues) {
                options.put(p.getValue(), p.getLabel());
            }
            return options;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OPP_IT_Asset__c> getPicklistValuesITAsset(String requesterId){
        if(String.isEmpty(requesterId)){
            return new List<OPP_IT_Asset__c>();
        }
        List<OPP_IT_Asset__c> OPP_ITAsset=[SELECT Id,name,Asset_Type__c,User__c,User__r.name FROM OPP_IT_Asset__c WHERE User__c = :requesterId];
        return OPP_ITAsset; 
    }

    @AuraEnabled
    public static List<OPP_Software_Asset__c> getPicklistValuesSoftwareAsset(){
        return [SELECT Id, name, ManuFacturer__c, Master_Software_Code__c, Master_Software_Name__c, License_Type__c, LASTESTUNITPRICE__c, LASTESTUNITPRICECURR__c
            FROM OPP_Software_Asset__c WHERE IsDelete_By_PM_Asset__c = false AND Is_Parent_Software__c = true ORDER BY Master_Software_Name__c ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Object getDescribeFieldResult(String sObjectName, List<String> fields) {
        Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get(sObjectName.toLowerCase()).getDescribe().fields.getMap();
        Map<String, Object> fieldDescribe = new Map<String, Object>();
        for (String f : fields) {
            f = f.contains('.') ? f.substringBeforeLast('.').replace('__r', '__c') : f;
            if(sObjectField.containsKey(f)) {
                Schema.DescribeFieldResult dfr = sObjectField.get(f).getDescribe();
                fieldDescribe.put(f, new Map<String, Object> {
                    'name' => dfr.getName(),
                    'label' => dfr.getLabel(),
                    'type' => dfr.getType(),
                    'inlineHelpText' => dfr.getInlineHelpText() != null ? dfr.getInlineHelpText() : '',
                    'isAccessible' => dfr.isAccessible()
                });
            }
        }
        return JSON.deserializeUntyped(JSON.serialize(fieldDescribe));
    }  
    
    @AuraEnabled
    public static String calloutUpdateDataAsset(String recordId){
        Map<Id, OPP_Case_Line_Items__c> caseLineItemsMap = new Map<Id, OPP_Case_Line_Items__c>([
            SELECT Id,Asset_Owner__c,Asset_Owner__r.Email,New_WinNo__r.Name,New_WinNo__c,New_WinNo__r.WinNo_Reference_key__c,OPP_IT_Asset__r.WinNo_Reference_key__c,
            Is_Summited_PMAsset__c,IsForceChange__c,Case__r.Borrow_Period_Start_date__c,Case__r.Borrow_Period_End_date__c FROM OPP_Case_Line_Items__c WHERE Case__c = :recordId AND Is_Summited_PMAsset__c = false
        ]);
        Set<Id> assetOwners = new Set<Id>();
        for(OPP_Case_Line_Items__c caselineItems : caseLineItemsMap.values()) assetOwners.add(caselineItems.Asset_Owner__c);
        Map<Id, PISUsers__c> pisUserMap = new Map<Id, PISUsers__c>();
        for(PISUsers__c pisuser : [SELECT Id, User__c, EMAIL__c FROM PISUsers__c WHERE User__c IN :assetOwners AND Active__c = True AND MAINPOSITION__c = True]){
            pisUserMap.put(pisuser.User__c, pisuser);
        }
        try {
            List<OPP_Case_Line_Items__c> caselineItemsUpdate = new List<OPP_Case_Line_Items__c>();
            List<OPP_IT_Asset__c> itAssetListUpdate = new List<OPP_IT_Asset__c>();
            Boolean isSuccess = true;
            List<String> messages = new List<String>();

            for(OPP_Case_Line_Items__c caselineItems : caseLineItemsMap.values()) {
                Map<String, Object> result = OPP_CalloutPMAssetService.calloutUpdateDataAsset(pisUserMap.get(caselineItems.Asset_Owner__c), caselineItems);
                System.debug(System.LoggingLevel.DEBUG, JSON.serializePretty(result));
                caselineItemsUpdate.add(new OPP_Case_Line_Items__c(
                    Id = (Id)MethodUtils.getResult('ReponseBody.Result.CaseLineItemID', result),
                    Is_Summited_PMAsset__c = (Boolean)MethodUtils.getResult('ReponseBody.Result.IsSuccess', result),
                    Response_PM_Asset__c = MethodUtils.serializePrettyString(JSON.serialize(result))
                ));

                if((Boolean)MethodUtils.getResult('ReponseBody.Result.IsSuccess', result)) {
                    itAssetListUpdate.add(new OPP_IT_Asset__c(
                        Id = caselineItems.New_WinNo__c,
                        IsPoolUser__c = false
                    ));
                }

                isSuccess = isSuccess && (Boolean)MethodUtils.getResult('ReponseBody.Result.IsSuccess', result);
                String msg = (String)MethodUtils.getResult('ReponseBody.Result.Message', result);
                if(msg != null) {
                    messages.add(String.format('{0}: {1}', new List<String>{
                        caselineItems.New_WinNo__r.Name,
                        msg
                    }));
                }
            }
            update caselineItemsUpdate;
            update itAssetListUpdate;
            return isSuccess ? 'Success' : String.join(messages, '\r\n');
        } catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, e.getmessage());
            System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
            return e.getMessage();
        }
    }
    
}