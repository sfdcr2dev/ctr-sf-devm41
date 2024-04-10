global class THOR_ReplicatedSAP_CatelogProfile implements Database.Batchable<CatelogProfileWithCodeGroupFromSAP> {

    public class ParseException extends Exception {}

    global class dto_response extends WebserviceExtend.dto_response {}

    public static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }

    global class CatelogProfileWithCodeGroupFromSAP {
        public String catelogProfile;
        public String codeGroup;
        public String catelog;
        public String description;
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';

        Application_Log__c applog = new Application_Log__c( External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_CatelogProfile', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = JSON.serialize(requestBody).left(131071) );

        List<CatelogProfileWithCodeGroupFromSAP> cpList;
        try {
            cpList = parseJSONInputs(body);
        } catch (Exception ex) {
            applog.Error_Message__c = ex.getMessage();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => false, 'message' => 'Unknown string format, cannot parse body data. Please try JSON format.', 'linkurl' => applog.External_ID__c } } );
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
            return dto_response.parse(applog.Response_Body__c);
        }

        Database.executeBatch(new THOR_ReplicatedSAP_CatelogProfile(request.requestURI, cpList));

        applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => applog.External_ID__c }, 'recordIds' => (new Map<Id, Master_Map__c>()).keySet() } );

        ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

        return dto_response.parse(applog.Response_Body__c);
    }

    public static List<CatelogProfileWithCodeGroupFromSAP> parseJSONInputs(String body) {
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> cpList = (List<Object>)parsedBody.get('CPLIST');

        List<CatelogProfileWithCodeGroupFromSAP> inputs = new List<CatelogProfileWithCodeGroupFromSAP>();
        for (Object rawInput : cpList) {
            Map<String, Object> input = (Map<String, Object>) rawInput;
            CatelogProfileWithCodeGroupFromSAP catelogProfile = new CatelogProfileWithCodeGroupFromSAP();
            catelogProfile.catelogProfile = String.valueOf(input.get('CATALOGPROFILE'));
            catelogProfile.codeGroup = String.valueOf(input.get('CODEGROUP'));
            catelogProfile.catelog = String.valueOf(input.get('CATALOG'));
            catelogProfile.description = String.valueOf(input.get('CATALOGDESC'));
            inputs.add(catelogProfile);
        }

        return inputs;
    }

    public static List<Master_Map__c> saveCatelogProfileWithCodeGroup(List<CatelogProfileWithCodeGroupFromSAP> cpList, Map<String, List<String>> errors) {
        List<Master_Map__c> insertedMasterMapList = new List<Master_Map__c>();
        List<Master_Map__c> updatedMasterMapList = new List<Master_Map__c>();
        List<Master_Map_Set__c> masterMapSet = [SELECT id FROM Master_Map_Set__c LIMIT 1];
        List<Master_Map__c> masterMapList = [ SELECT id, Name, type__c, Description__c, RelatedMasterMap1__c, RelatedMasterMap1__r.Name, RelatedMasterMap2__c, RelatedMasterMap2__r.Name FROM master_map__c WHERE type__c = 'CatalogType' OR type__c = 'Code Group' OR type__c = 'CatelogProfile' ];

        set<String> mastermapKeySet = new Set<String>();
        Map<String, Master_Map__c> catelogProfileMap = new Map<String, Master_Map__c>();
        Map<String, Master_Map__c> updateCatelogProfileMap = new Map<String, Master_Map__c>();
        Map<String, Master_Map__c> codeGroupMap = new Map<String, Master_Map__c>();
        Map<String, Master_Map__c> updateCodeGroupMap = new Map<String, Master_Map__c>();
        Map<String, String> codeGroupMapSFMap = new Map<String, String>();
        Map<String, String> catelogProfileMapSFMap = new Map<String, String>();
        map<String, String> catelogprofilecodegroupKeyMap = new Map<String, String>();

        for (Master_Map__c master : masterMapList) {
            if (master.type__c == 'CatalogType') {
                String key =master.RelatedMasterMap1__r.Name +master.RelatedMasterMap2__r.Name +master.Description__c;
                mastermapKeySet.add(key);

                catelogprofilecodegroupKeyMap.put(key, master.Id);
            }
            if (master.type__c == 'Code Group') {
                codeGroupMapSFMap.put(master.Name, master.id);
            }
            if (master.type__c == 'CatelogProfile') {
                catelogProfileMapSFMap.put(master.Name, master.id);
            }
        }

        for (CatelogProfileWithCodeGroupFromSAP catTypeSAP : cpList) {
            if (catTypeSAP.catelogProfile != null) {
                if (catelogProfileMapSFMap.containsKey(catTypeSAP.catelogProfile)) {
                    Master_Map__c catProfile = new Master_Map__c();
                    catProfile.Id = catelogProfileMapSFMap.get(catTypeSAP.catelogProfile);
                    catProfile.Name = catTypeSAP.catelogProfile;
                    catProfile.Code__c = catTypeSAP.catelogProfile;
                    catProfile.Description__c = catTypeSAP.description;
                    updateCatelogProfileMap.put(catTypeSAP.catelogProfile, catProfile);
                } else {
                    Master_Map__c catProfile = new Master_Map__c();
                    catProfile.Name = catTypeSAP.catelogProfile;
                    catProfile.Code__c = catTypeSAP.catelogProfile;
                    catProfile.Description__c = catTypeSAP.description;
                    catProfile.Type__c = 'CatelogProfile';
                    catProfile.Master_Map_Set__c = masterMapSet[0].Id;
                    catelogProfileMap.put(catTypeSAP.catelogProfile, catProfile);
                }
            }
            if (catTypeSAP.codeGroup != null) {
                if (codeGroupMapSFMap.containsKey(catTypeSAP.codeGroup)) {
                    Master_Map__c codeGroup = new Master_Map__c();
                    codeGroup.Id = codeGroupMapSFMap.get(catTypeSAP.codeGroup);
                    codeGroup.Name = catTypeSAP.codeGroup;
                    codeGroup.Code__c = catTypeSAP.codeGroup;
                    codeGroup.Description__c = catTypeSAP.description;
                    updateCodeGroupMap.put(catTypeSAP.codeGroup, codeGroup);
                } else {
                    Master_Map__c codeGroup = new Master_Map__c();
                    codeGroup.Name = catTypeSAP.codeGroup;
                    codeGroup.Code__c = catTypeSAP.codeGroup;
                    codeGroup.Type__c = 'Code Group';
                    codeGroup.Description__c = catTypeSAP.description;
                    codeGroup.Master_Map_Set__c = masterMapSet[0].Id;
                    codeGroupMap.put(catTypeSAP.codeGroup, codeGroup);
                }
            }
        }

        if (codeGroupMap.values().size() > 0) {
            List<Database.SaveResult> saveResults = Database.insert(codeGroupMap.values(), false);

            for (Master_Map__c upsertedCodeGroup : codeGroupMap.values()) {
                codeGroupMapSFMap.put(upsertedCodeGroup.Name, upsertedCodeGroup.id);
            }

            addErrorToList(saveResults, errors);
        }

        if (updateCodeGroupMap.values().size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(updateCodeGroupMap.values(), false);

            for (Master_Map__c upsertedCodeGroup : updateCodeGroupMap.values()) {
                codeGroupMapSFMap.put(upsertedCodeGroup.Name, upsertedCodeGroup.id);
            }

            addErrorToList(saveResults, errors);
        }

        if (catelogProfileMap.values().size() > 0) {
            List<Database.SaveResult> saveResults = Database.insert(catelogProfileMap.values(), false);

            for (Master_Map__c upsertedCatelogProfile : catelogProfileMap.values()) {
                catelogProfileMapSFMap.put(upsertedCatelogProfile.Name, upsertedCatelogProfile.id);
            }

            addErrorToList(saveResults, errors);
        }

        if (updateCatelogProfileMap.values().size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(updateCatelogProfileMap.values(), false);

            for (Master_Map__c upsertedCatelogProfile : updateCatelogProfileMap.values()) {
                catelogProfileMapSFMap.put(upsertedCatelogProfile.Name, upsertedCatelogProfile.id);
            }

            addErrorToList(saveResults, errors);
        }

        for (CatelogProfileWithCodeGroupFromSAP catTypeSAP : cpList) {
            String catelog = '';
			catelog = catTypeSAP.catelog == 'A' ? 'Activity' : catTypeSAP.catelog == 'B' ? 'ObjectPart' : catTypeSAP.catelog == 'C' ? 'Damage' : catTypeSAP.catelog == 'D' ? 'FaultCode' : 'Cause';

            String catelogProfileName = catTypeSAP.catelogProfile + '-' + catTypeSAP.codeGroup;
            String key = catTypeSAP.catelogProfile + catTypeSAP.codeGroup + catelog;

            if (mastermapKeySet != null) {
                if (mastermapKeySet.contains(key)) {
                    Master_Map__c updatedCatelogType = new Master_Map__c();
                    updatedCatelogType.Name = catelogProfileName;
                    updatedCatelogType.Id = catelogprofilecodegroupKeyMap.get(key);
                    updatedCatelogType.RelatedMasterMap1__c = catelogProfileMapSFMap.get(catTypeSAP.catelogProfile);
                    updatedCatelogType.RelatedMasterMap2__c = codeGroupMapSFMap.get(catTypeSAP.codeGroup);
                    updatedCatelogType.Description__c = catelog;
                    updatedMasterMapList.add(updatedCatelogType);
                } else {
                    Master_Map__c insertedCatelogType = new Master_Map__c();
                    insertedCatelogType.Name = catelogProfileName;
                    insertedCatelogType.Code__c = catelogProfileName;
                    insertedCatelogType.RelatedMasterMap1__c = catelogProfileMapSFMap.get(catTypeSAP.catelogProfile);
                    insertedCatelogType.RelatedMasterMap2__c = codeGroupMapSFMap.get(catTypeSAP.codeGroup);
                    insertedCatelogType.Type__c = 'CatalogType';
                    insertedCatelogType.Description__c = catelog;
                    insertedCatelogType.Master_Map_Set__c = masterMapSet[0].Id;
                    insertedMasterMapList.add(insertedCatelogType);
                }
            }
        }
        if (insertedMasterMapList.size() > 0) {
            List<Database.SaveResult> saveResults = Database.insert(insertedMasterMapList, false);
            addErrorToList(saveResults, errors);
        }
        if (updatedMasterMapList.size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(updatedMasterMapList, false);
            addErrorToList(saveResults, errors);
        }

        List<Master_Map__c> result = new List<Master_Map__c>();
        result.addAll(codeGroupMap.values());
        result.addAll(catelogProfileMap.values());
        result.addAll(insertedMasterMapList);
        result.addAll(updateCodeGroupMap.values());
        result.addAll(updateCatelogProfileMap.values());
        result.addAll(updatedMasterMapList);

        return result;
    }

    public static void addErrorToList(List<Database.SaveResult> saveResults, Map<String, List<String>> errors) {
        if (saveResults.size() > 0) {
            List<String> errorMessages = new List<String>();
            for (Integer idx = 0; idx < saveResults.size(); idx++) {
                if (!saveResults[idx].isSuccess()) {
                    errorMessages = new List<String>();
                    for(Database.Error err : saveResults[idx].getErrors()) {
                        errorMessages.add('Field: ' + err.getFields() + ': ' + err.getMessage());
                    }
                }
                errors.put(saveResults[idx].getId(), errorMessages);
            }
        }
    }

    public static void addErrorToList(List<Database.UpsertResult> upsertResults, Map<String, List<String>> errors) {
        if (upsertResults.size() > 0) {
            List<String> errorMessages = new List<String>();
            for (Integer idx = 0; idx < upsertResults.size(); idx++) {
                if (!upsertResults[idx].isSuccess()) {
                    errorMessages = new List<String>();
                    for(Database.Error err : upsertResults[idx].getErrors()) {
                        errorMessages.add('Field: ' + err.getFields() + ': ' + err.getMessage());
                    }
                }
                errors.put(upsertResults[idx].getId(), errorMessages);
            }
        }
    }

    private List<CatelogProfileWithCodeGroupFromSAP> catelogProfiles;
    private String requestURI;
    private Map<String, List<String>> errors;

    public THOR_ReplicatedSAP_CatelogProfile(String uri, List<CatelogProfileWithCodeGroupFromSAP> rawCatelogProfiles) {
        catelogProfiles = rawCatelogProfiles;
        requestURI = uri;
        errors = new Map<String, List<String>>();
    }

    public Iterable<CatelogProfileWithCodeGroupFromSAP> start(Database.BatchableContext BC) {
        return catelogProfiles;
    }

    public void execute(Database.BatchableContext BC, List<CatelogProfileWithCodeGroupFromSAP> scope) {
        List<Master_Map__c> updatedMasterMapList = saveCatelogProfileWithCodeGroup(scope, errors);
        Application_Log__c applog = new Application_Log__c( External_ID__c = Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_CatelogProfile', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = JSON.serialize(scope).left(131071), Response_Body__c = JSON.serialize( new Map<String, Object>{ 'errors' => JSON.serialize(errors), 'success' => (new Map<Id, Master_Map__c>(updatedMasterMapList)).keySet() } ).left(131071) );
        ApplicationLogUtils.saveLogInbound(requestURI, applog);
    }

    public void finish(Database.BatchableContext BC) {
    }
}