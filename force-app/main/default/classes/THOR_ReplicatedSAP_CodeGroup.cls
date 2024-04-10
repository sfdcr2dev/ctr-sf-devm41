global class THOR_ReplicatedSAP_CodeGroup implements Database.Batchable<CodeGroupWithCodeFromSAP> {

    public class ParseException extends Exception {}

    global class dto_response extends WebserviceExtend.dto_response {}

    public static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }

    global class CodeGroupWithCodeFromSAP {
        public String codeGroup { get; set; }
        public String code { get; set; }
        public String description { get; set; }
        public String catelog { get; set; }
        public String codeGroupDescription { get; set; }
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';

        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'THOR_ReplicatedSAP_CodeGroup',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody).left(131071)
        );

        List<CodeGroupWithCodeFromSAP> cgList;
        try {
            cgList = parseJSONInputs(body);
            applog.Request_Body__c = JSON.serialize(MethodUtils.setResultByKeypath('body', JSON.deserializeUntyped(body), requestBody));
        } catch (Exception ex) {
            applog.Error_Message__c = ex.getMessage();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => false, 'message' => 'Unknown string format, cannot parse body data. Please try JSON format.', 'linkurl' => applog.External_ID__c } } );
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
            return dto_response.parse(applog.Response_Body__c);
        }

        Database.executeBatch(new THOR_ReplicatedSAP_CodeGroup(request.requestURI, cgList));

        applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => applog.External_ID__c }, 'recordIds' => (new Map<Id, Master_Map__c>()).keySet() } );
        ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

        return dto_response.parse(applog.Response_Body__c);
    }

    public static List<CodeGroupWithCodeFromSAP> parseJSONInputs(String body) {
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> cgList = (List<Object>) parsedBody.get('CGLIST');

        List<CodeGroupWithCodeFromSAP> inputs = new List<CodeGroupWithCodeFromSAP>();
        for (Object rawInput : cgList) {
            CodeGroupWithCodeFromSAP codeGroup = createCodeGroupWithCodeFromSAP(rawInput);
            inputs.add(codeGroup);
        }

        return inputs;
    }

    public static CodeGroupWithCodeFromSAP createCodeGroupWithCodeFromSAP(Object json) {
        Map<String, Object> codeGroupMap = (Map<String, Object>) json;
        CodeGroupWithCodeFromSAP codeGroup = new CodeGroupWithCodeFromSAP();

        codeGroup.codeGroup = String.valueOf(codeGroupMap.get('CODEGROUP'));
        codeGroup.code = String.valueOf(codeGroupMap.get('CODE'));
        codeGroup.description = String.valueOf(codeGroupMap.get('DESCRIPTION'));
        codeGroup.catelog = String.valueOf(codeGroupMap.get('CATALOG'));
        codeGroup.codeGroupDescription = String.valueOf(codeGroupMap.get('CODEGROUPDESC'));

        return codeGroup;
    }

    public static List<Master_Map__c> saveCodeGroupWithCode(List<CodeGroupWithCodeFromSAP> cgList, Map<String, List<String>> errors) {
        List<Master_Map__c> insertedMasterMapList = new List<Master_Map__c>();
        List<Master_Map__c> updatedMasterMapList = new List<Master_Map__c>();
        List<Master_Map_Set__c> masterMapSet = [SELECT id FROM Master_Map_Set__c LIMIT 1];
        List<Master_Map__c> masterMapList = [ SELECT id, Name, type__c, Description__c, RelatedMasterMap1__c, RelatedMasterMap1__r.Name, RelatedMasterMap2__c, RelatedMasterMap2__r.Name FROM master_map__c WHERE type__c = 'Code Group' OR type__c = 'CatelogFaultCode' OR type__c = 'CatelogActivity' OR type__c = 'CatelogCause' OR type__c = 'CatelogDamage' OR type__c = 'CatelogObjectPart' OR type__c = 'FaultCode' OR type__c = 'Activity' OR type__c = 'Cause' OR type__c = 'Damage' OR type__c = 'Object Part' ];
        set<String> catfaultCodeKeySet = new Set<String>();
        map<String, String> catfaultCodeKeyMap = new Map<String, String>();
        set<String> catactivityKeySet = new Set<String>();
        map<String, String> catactivityKeyMap = new Map<String, String>();
        set<String> catcauseKeySet = new Set<String>();
        map<String, String> catcauseKeyMap = new Map<String, String>();
        set<String> catobjectPartKeySet = new Set<String>();
        map<String, String> catobjectPartKeyMap = new Map<String, String>();
        set<String> catdamageKeySet = new Set<String>();
        map<String, String> catdamageKeyMap = new Map<String, String>();
        Map<String, Master_Map__c> codeMap = new Map<String, Master_Map__c>();
        Map<String, Master_Map__c> updatedCodeMap = new Map<String, Master_Map__c>();
        Map<String, Master_Map__c> codeGroupMap = new Map<String, Master_Map__c>();
        Map<String, Master_Map__c> codeGroupMapForInsert = new Map<String, Master_Map__c>();
        Map<String, Master_Map__c> codeGroupMapForUpdate = new Map<String, Master_Map__c>();
        Map<String, String> upsertedcodeGroupMap = new Map<String, String>();
        Map<String, String> codeGroupMapSFMap = new Map<String, String>();
        Map<String, String> faultCodeMapSFMap = new Map<String, String>();
        Map<String, String> objectPartMapSFMap = new Map<String, String>();
        Map<String, String> activityMapSFMap = new Map<String, String>();
        Map<String, String> damageMapSFMap = new Map<String, String>();
        Map<String, String> causeMapSFMap = new Map<String, String>();
        for (Master_Map__c master : masterMapList) {
            if (master.type__c == 'CatelogFaultCode') {
                String key = 'FaultCode' + master.RelatedMasterMap1__r.Name + master.RelatedMasterMap2__r.Name;
                catfaultCodeKeySet.add(key);
                catfaultCodeKeyMap.put(key, master.Id);
            }
            if (master.type__c == 'CatelogActivity') {
                String key = 'Activity' + master.RelatedMasterMap1__r.Name + master.RelatedMasterMap2__r.Name;
                catactivityKeySet.add(key);
                catactivityKeyMap.put(key, master.Id);
            }
            if (master.type__c == 'CatelogCause') {
                String key = 'Cause' + master.RelatedMasterMap1__r.Name + master.RelatedMasterMap2__r.Name;
                catcauseKeySet.add(key);
                catcauseKeyMap.put(key, master.Id);
            }
            if (master.type__c == 'CatelogDamage') {
                String key = 'Damage' + master.RelatedMasterMap1__r.Name + master.RelatedMasterMap2__r.Name;
                catdamageKeySet.add(key);
                catdamageKeyMap.put(key, master.Id);
            }
            if (master.type__c == 'CatelogObjectPart') {
                String key = 'Object Part' + master.RelatedMasterMap1__r.Name + master.RelatedMasterMap2__r.Name;
                catobjectPartKeySet.add(key);
                catobjectPartKeyMap.put(key, master.Id);
            }
            if (master.type__c == 'Code Group') {
                codeGroupMapSFMap.put(master.Name, master.id);
            }
            if (master.type__c == 'FaultCode') {
                faultCodeMapSFMap.put(master.Name, master.id);
            }
            if (master.type__c == 'Activity') {
                activityMapSFMap.put(master.Name, master.id);
            }
            if (master.type__c == 'Cause') {
                causeMapSFMap.put(master.Name, master.id);
            }
            if (master.type__c == 'Damage') {
                damageMapSFMap.put(master.Name, master.id);
            }
            if (master.type__c == 'Object Part') {
                objectPartMapSFMap.put(master.Name, master.id);
            }
        }
        for (CodeGroupWithCodeFromSAP catelogSAP : cgList) {
            if (catelogSAP.codeGroup != null) {
                Master_Map__c codeGroup = new Master_Map__c();
                codeGroup.Name = catelogSAP.codeGroup;
                codeGroup.Code__c = catelogSAP.codeGroup;
                codeGroup.Type__c = 'Code Group';
                codeGroup.Description__c = catelogSAP.codeGroupDescription;
                codeGroup.Master_Map_Set__c = masterMapSet[0].Id;
                if (codeGroupMapSFMap.containsKey(catelogSAP.codeGroup)) {
                    codeGroup.Id = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                    codeGroupMapForUpdate.put(catelogSAP.codeGroup, codeGroup);
                } else {
                    codeGroupMapForInsert.put(catelogSAP.codeGroup, codeGroup);
                }

            }
            if (catelogSAP.catelog != null) {
                if (catelogSAP.catelog == 'A') {
                    if (!activityMapSFMap.containsKey(catelogSAP.code)) {
                        Master_Map__c activity = new Master_Map__c();
                        activity.Name = catelogSAP.code;
                        activity.Code__c = catelogSAP.code;
                        activity.Type__c = 'Activity';
                        activity.Description__c = catelogSAP.description;
                        activity.Master_Map_Set__c = masterMapSet[0].Id;
                        codeMap.put(catelogSAP.code + catelogSAP.catelog, activity);
                    } else {
                        Master_Map__c activity = new Master_Map__c();
                        activity.Id = activityMapSFMap.get(catelogSAP.code);
                        activity.Name = catelogSAP.code;
                        activity.Code__c = catelogSAP.code;
                        activity.Type__c = 'Activity';
                        activity.Description__c = catelogSAP.description;
                        updatedCodeMap.put(catelogSAP.code + catelogSAP.catelog, activity);
                    }
                }
                if (catelogSAP.catelog == 'B') {
                    if (!objectPartMapSFMap.containsKey(catelogSAP.code)) {
                        Master_Map__c objectPart = new Master_Map__c();
                        objectPart.Name = catelogSAP.code;
                        objectPart.Code__c = catelogSAP.code;
                        objectPart.Type__c = 'Object Part';
                        objectPart.Description__c = catelogSAP.description;
                        objectPart.Master_Map_Set__c = masterMapSet[0].Id;
                        codeMap.put(catelogSAP.code + catelogSAP.catelog, objectPart);
                    } else {
                        Master_Map__c objectPart = new Master_Map__c();
                        objectPart.Id = objectPartMapSFMap.get(catelogSAP.code);
                        objectPart.Name = catelogSAP.code;
                        objectPart.Code__c = catelogSAP.code;
                        objectPart.Type__c = 'Object Part';
                        objectPart.Description__c = catelogSAP.description;
                        updatedCodeMap.put(catelogSAP.code + catelogSAP.catelog, objectPart);
                    }
                }
                if (catelogSAP.catelog == 'C') {
                    if (!damageMapSFMap.containsKey(catelogSAP.code)) {
                        Master_Map__c damage = new Master_Map__c();
                        damage.Name = catelogSAP.code;
                        damage.Code__c = catelogSAP.code;
                        damage.Type__c = 'Damage';
                        damage.Master_Map_Set__c = masterMapSet[0].Id;
                        codeMap.put(catelogSAP.code + catelogSAP.catelog, damage);
                    } else {
                        Master_Map__c damage = new Master_Map__c();
                        damage.Id = damageMapSFMap.get(catelogSAP.code);
                        damage.Name = catelogSAP.code;
                        damage.Code__c = catelogSAP.code;
                        damage.Type__c = 'Damage';
                        damage.Description__c = catelogSAP.description;
                        updatedCodeMap.put(catelogSAP.code + catelogSAP.catelog, damage);
                    }
                }
                if (catelogSAP.catelog == 'D') {
                    if (!faultCodeMapSFMap.containsKey(catelogSAP.code)) {
                        Master_Map__c faultCode = new Master_Map__c();
                        faultCode.Name = catelogSAP.code;
                        faultCode.Code__c = catelogSAP.code;
                        faultCode.Type__c = 'FaultCode';
                        faultCode.Master_Map_Set__c = masterMapSet[0].Id;
                        codeMap.put(catelogSAP.code + catelogSAP.catelog, faultCode);
                    } else {
                        Master_Map__c faultCode = new Master_Map__c();
                        faultCode.Id = faultCodeMapSFMap.get(catelogSAP.code);
                        faultCode.Name = catelogSAP.code;
                        faultCode.Code__c = catelogSAP.code;
                        faultCode.Type__c = 'FaultCode';
                        faultCode.Description__c = catelogSAP.description;
                        updatedCodeMap.put(catelogSAP.code + catelogSAP.catelog, faultCode);
                    }
                }
                if (catelogSAP.catelog == '5') {
                    if (!causeMapSFMap.containsKey(catelogSAP.code)) {
                        Master_Map__c cause = new Master_Map__c();
                        cause.Name = catelogSAP.code;
                        cause.Code__c = catelogSAP.code;
                        cause.Type__c = 'Cause';
                        cause.Master_Map_Set__c = masterMapSet[0].Id;
                        codeMap.put(catelogSAP.code + catelogSAP.catelog, cause);
                    } else {
                        Master_Map__c cause = new Master_Map__c();
                        cause.Id = causeMapSFMap.get(catelogSAP.code);
                        cause.Name = catelogSAP.code;
                        cause.Code__c = catelogSAP.code;
                        cause.Type__c = 'Cause';
                        cause.Description__c = catelogSAP.description;
                        updatedCodeMap.put(catelogSAP.code + catelogSAP.catelog, cause);
                    }
                }
            }
        }
        if (codeGroupMapForInsert.values().size() > 0) {
//insert codeGroupMapForInsert.values();
            List<Database.SaveResult> saveResults = Database.insert(codeGroupMapForInsert.values(), false);
            THOR_ReplicatedSAP_CatelogProfile.addErrorToList(saveResults, errors);

            for (Master_Map__c upsertedCodeGroup : codeGroupMapForInsert.values()) {
                codeGroupMapSFMap.put(upsertedCodeGroup.Name, upsertedCodeGroup.id);
            }
        }
        if (codeGroupMapForUpdate.values().size() > 0) {
//update codeGroupMapForUpdate.values();
            List<Database.SaveResult> saveResults = Database.update(codeGroupMapForUpdate.values(), false);
            THOR_ReplicatedSAP_CatelogProfile.addErrorToList(saveResults, errors);

            for (Master_Map__c upsertedCodeGroup : codeGroupMapForUpdate.values()) {
                codeGroupMapSFMap.put(upsertedCodeGroup.Name, upsertedCodeGroup.id);
            }
        }
        if (codeMap.values().size() > 0) {
//insert codeMap.values();
            List<Database.SaveResult> saveResults = Database.insert(codeMap.values(), false);
            THOR_ReplicatedSAP_CatelogProfile.addErrorToList(saveResults, errors);

            for (Master_Map__c insertedCode : codeMap.values()) {
                if (insertedCode.type__c == 'FaultCode') {
                    faultCodeMapSFMap.put(insertedCode.Name, insertedCode.id);
                }
                if (insertedCode.type__c == 'Activity') {
                    activityMapSFMap.put(insertedCode.Name, insertedCode.id);
                }
                if (insertedCode.type__c == 'Cause') {
                    causeMapSFMap.put(insertedCode.Name, insertedCode.id);
                }
                if (insertedCode.type__c == 'Damage') {
                    damageMapSFMap.put(insertedCode.Name, insertedCode.id);
                }
                if (insertedCode.type__c == 'Object Part') {
                    objectPartMapSFMap.put(insertedCode.Name, insertedCode.id);
                }
            }
        }
        if (updatedCodeMap.values().size() > 0) {
//insert codeMap.values();
            List<Database.SaveResult> saveResults = Database.update(updatedCodeMap.values(), false);
            THOR_ReplicatedSAP_CatelogProfile.addErrorToList(saveResults, errors);

            for (Master_Map__c updatedCode : updatedCodeMap.values()) {
                if (updatedCode.type__c == 'FaultCode') {
                    faultCodeMapSFMap.put(updatedCode.Name, updatedCode.id);
                }
                if (updatedCode.type__c == 'Activity') {
                    activityMapSFMap.put(updatedCode.Name, updatedCode.id);
                }
                if (updatedCode.type__c == 'Cause') {
                    causeMapSFMap.put(updatedCode.Name, updatedCode.id);
                }
                if (updatedCode.type__c == 'Damage') {
                    damageMapSFMap.put(updatedCode.Name, updatedCode.id);
                }
                if (updatedCode.type__c == 'Object Part') {
                    objectPartMapSFMap.put(updatedCode.Name, updatedCode.id);
                }
            }
        }
        for (CodeGroupWithCodeFromSAP catelogSAP : cgList) {
            String catelog = '';
            catelog = catelogSAP.catelog == 'A' ? 'Activity' : catelogSAP.catelog == 'B' ? 'Object Part' : catelogSAP.catelog == 'C' ? 'Damage' : catelogSAP.catelog == 'D' ? 'FaultCode' : 'Cause' ;
            String catelogName = catelogSAP.codeGroup + '-' + catelogSAP.code;
            String key = catelog + catelogSAP.codeGroup + catelogSAP.code;

            if (catelog == 'Activity') {
                if (catactivityKeySet != null) {
                    if (!catactivityKeySet.contains(key)) {
                        Master_Map__c insertedCatelog = new Master_Map__c();
                        insertedCatelog.Name = catelogName;
                        insertedCatelog.Code__c = catelogName;
                        insertedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        insertedCatelog.RelatedMasterMap2__c = activityMapSFMap.get(catelogSAP.code);
                        insertedCatelog.Type__c = 'CatelogActivity';
                        insertedCatelog.Description__c = catelogSAP.description;
                        insertedCatelog.Master_Map_Set__c = masterMapSet[0].Id;
                        insertedMasterMapList.add(insertedCatelog);
                    } else {
                        Master_Map__c updatedCatelog = new Master_Map__c(id = catactivityKeyMap.get(key));
                        updatedCatelog.Name = catelogName;
                        updatedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        updatedCatelog.RelatedMasterMap2__c = activityMapSFMap.get(catelogSAP.code);
                        updatedCatelog.Type__c = 'CatelogActivity';
                        updatedCatelog.Description__c = catelogSAP.description;
                        updatedMasterMapList.add(updatedCatelog);
                    }
                }
            }
            if (catelog == 'Object Part') {
                if (catObjectPartKeySet != null) {
                    if (!catObjectPartKeySet.contains(key)) {
                        Master_Map__c insertedCatelog = new Master_Map__c();
                        insertedCatelog.Name = catelogName;
                        insertedCatelog.Code__c = catelogName;
                        insertedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        insertedCatelog.RelatedMasterMap2__c = objectPartMapSFMap.get(catelogSAP.code);
                        insertedCatelog.Type__c = 'CatelogObjectPart';
                        insertedCatelog.Description__c = catelogSAP.description;
                        insertedCatelog.Master_Map_Set__c = masterMapSet[0].Id;
                        insertedMasterMapList.add(insertedCatelog);
                    } else {
                        Master_Map__c updatedCatelog = new Master_Map__c(id = catObjectPartKeyMap.get(key));
                        updatedCatelog.Name = catelogName;
                        updatedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        updatedCatelog.RelatedMasterMap2__c = objectPartMapSFMap.get(catelogSAP.code);
                        updatedCatelog.Type__c = 'CatelogObjectPart';
                        updatedCatelog.Description__c = catelogSAP.description;
                        updatedMasterMapList.add(updatedCatelog);
                    }
                }
            }
            if (catelog == 'Damage') {
                if (catdamageKeySet != null) {
                    if (!catdamageKeySet.contains(key)) {
                        Master_Map__c insertedCatelog = new Master_Map__c();
                        insertedCatelog.Name = catelogName;
                        insertedCatelog.Code__c = catelogName;
                        insertedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        insertedCatelog.RelatedMasterMap2__c = damageMapSFMap.get(catelogSAP.code);
                        insertedCatelog.Type__c = 'CatelogDamage';
                        insertedCatelog.Description__c = catelogSAP.description;
                        insertedCatelog.Master_Map_Set__c = masterMapSet[0].Id;
                        insertedMasterMapList.add(insertedCatelog);
                    } else {
                        Master_Map__c updatedCatelog = new Master_Map__c(id = catdamageKeyMap.get(key));
                        updatedCatelog.Name = catelogName;
                        updatedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        updatedCatelog.RelatedMasterMap2__c = damageMapSFMap.get(catelogSAP.code);
                        updatedCatelog.Type__c = 'CatelogDamage';
                        updatedCatelog.Description__c = catelogSAP.description;
                        updatedMasterMapList.add(updatedCatelog);
                    }
                }
            }
            if (catelog == 'FaultCode') {
                if (catfaultcodeKeySet != null) {
                    if (!catfaultcodeKeySet.contains(key)) {
                        Master_Map__c insertedCatelog = new Master_Map__c();
                        insertedCatelog.Name = catelogName;
                        insertedCatelog.Code__c = catelogName;
                        insertedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        insertedCatelog.RelatedMasterMap2__c = faultCodeMapSFMap.get(catelogSAP.code);
                        insertedCatelog.Type__c = 'CatelogFaultCode';
                        insertedCatelog.Description__c = catelogSAP.description;
                        insertedCatelog.Master_Map_Set__c = masterMapSet[0].Id;
                        insertedMasterMapList.add(insertedCatelog);
                    } else {
                        Master_Map__c updatedCatelog = new Master_Map__c(id = catfaultcodeKeyMap.get(key));
                        updatedCatelog.Name = catelogName;
                        updatedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        updatedCatelog.RelatedMasterMap2__c = faultCodeMapSFMap.get(catelogSAP.code);
                        updatedCatelog.Type__c = 'CatelogFaultCode';
                        updatedCatelog.Description__c = catelogSAP.description;
                        updatedMasterMapList.add(updatedCatelog);
                    }
                }
            }
            if (catelog == 'Cause') {
                if (catcauseKeySet != null) {
                    if (!catcauseKeySet.contains(key)) {
                        Master_Map__c insertedCatelog = new Master_Map__c();
                        insertedCatelog.Name = catelogName;
                        insertedCatelog.Code__c = catelogName;
                        insertedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        insertedCatelog.RelatedMasterMap2__c = causeMapSFMap.get(catelogSAP.code);
                        insertedCatelog.Type__c = 'CatelogCause';
                        insertedCatelog.Description__c = catelogSAP.description;
                        insertedCatelog.Master_Map_Set__c = masterMapSet[0].Id;
                        insertedMasterMapList.add(insertedCatelog);
                    } else {
                        Master_Map__c updatedCatelog = new Master_Map__c(id = catcauseKeyMap.get(key));
                        updatedCatelog.Name = catelogName;
                        updatedCatelog.RelatedMasterMap1__c = codeGroupMapSFMap.get(catelogSAP.codeGroup);
                        updatedCatelog.RelatedMasterMap2__c = causeMapSFMap.get(catelogSAP.code);
                        updatedCatelog.Type__c = 'CatelogCause';
                        updatedCatelog.Description__c = catelogSAP.description;
                        updatedMasterMapList.add(updatedCatelog);
                    }
                }
            }
        }
        if (insertedMasterMapList.size() > 0) {
            List<Database.SaveResult> saveResults = Database.insert(insertedMasterMapList, false);
            THOR_ReplicatedSAP_CatelogProfile.addErrorToList(saveResults, errors);
        }
        if (updatedMasterMapList.size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(updatedMasterMapList, false);
            THOR_ReplicatedSAP_CatelogProfile.addErrorToList(saveResults, errors);
        }

        List<Master_Map__c> result = new List<Master_Map__c>();
        result.addAll(codeGroupMapForInsert.values());
        result.addAll(codeGroupMapForUpdate.values());
        result.addAll(insertedMasterMapList);
        result.addAll(updatedMasterMapList);

        return result;
    }

    private List<CodeGroupWithCodeFromSAP> codeGroups;
    private String requestURI;
    private Map<String, List<String>> errors;

    public THOR_ReplicatedSAP_CodeGroup(String uri, List<CodeGroupWithCodeFromSAP> rawCodeGroups) {
        codeGroups = rawCodeGroups;
        requestURI = uri;
        errors = new Map<String, List<String>>();
    }

    public Iterable<CodeGroupWithCodeFromSAP> start(Database.BatchableContext BC) {
        return codeGroups;
    }

    public void execute(Database.BatchableContext BC, List<CodeGroupWithCodeFromSAP> scope) {
        List<Master_Map__c> updatedMasterMapList = saveCodeGroupWithCode(scope, errors);

//        Application_Log__c applog = new Application_Log__c(
//            External_ID__c = Uuid.randomUUID(),
//            Integration_Name__c = 'THOR_ReplicatedSAP_CodeGroup',
//            Method__c = 'Upsert',
//            Message_Type__c = 'Success',
//            Request_Body__c = JSON.serialize(scope).left(131071),
//            Response_Body__c = JSON.serialize(
//                new Map<String, Object>{
//                    'errors' => JSON.serialize(errors),
//                    'success' => (new Map<Id, Master_Map__c>(updatedMasterMapList)).keySet()
//                }
//            ).left(131071)
//        );
//
//        ApplicationLogUtils.saveLogInbound(requestURI, applog);
    }

    public void finish(Database.BatchableContext BC) {
    }
}