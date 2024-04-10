public class THOR_ReplicatedSAP_MaintenanceItem {

    public class ParseException extends Exception {}

    public class dto_response extends WebserviceExtend.dto_response {}

    public static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }

    public class MaintenanceItemFromSAP {
        public String maintenancePlant;
        public String itemNo;
        public String maintenanceItem;
        public String text;
        public String strategy;
        public String FL;
        public String equipment;
        public String planningPlant;
        public String orderType;
        public String plannerGroup;
        public String maintenanceActivityType;
        public String mainWorkCenter;
        public String taskListType;
        public String tGroup;
        public String groupCount;
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';

        Application_Log__c applog = new Application_Log__c( External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_MaintenanceItem', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = JSON.serialize(requestBody).left(130000) );

        List<MaintenanceItemFromSAP> miList;
        try {
            miList = parseJSONInputs(body);
        } catch (Exception ex) {
            applog.Error_Message__c = ex.getMessage();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => false, 'message' => 'Unknown string format, cannot parse body data. Please try JSON format.', 'linkurl' => applog.External_ID__c } } );
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
            return dto_response.parse(applog.Response_Body__c);
        }

        List<THOR_Maintenance_Item__c> savedList = saveMaintenanceItem(miList);

        applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => savedList.size() > 0, 'message' => savedList.size() > 0 ? '' : 'Not found Maintenance Item Information', 'linkurl' => applog.External_ID__c }, 'recordIds' => (new Map<Id, THOR_Maintenance_Item__c>(savedList)).keySet() } );
        ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

        return dto_response.parse(applog.Response_Body__c);
    }

    public static List<MaintenanceItemFROMSAP> parseJSONInputs(String body) {
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> miList = (List<Object>)parsedBody.get('MILIST');

        List<MaintenanceItemFROMSAP> inputs = new List<MaintenanceItemFROMSAP>();
        for (Object rawInput : miList) {
            Map<String, Object> input = (Map<String, Object>) rawInput;
            MaintenanceItemFROMSAP maintenanceItem = new MaintenanceItemFROMSAP();
            maintenanceItem.maintenancePlant = String.valueOf(input.get('MAINTENANCEPLANT'));
            maintenanceItem.itemNo = String.valueOf(input.get('ITEMNO'));
            maintenanceItem.maintenanceItem = String.valueOf(input.get('MAINTENANCEITEM'));
            maintenanceItem.text = String.valueOf(input.get('TEXT'));
            maintenanceItem.strategy = String.valueOf(input.get('STRATEGY'));
            maintenanceItem.FL = String.valueOf(input.get('FL'));
            maintenanceItem.equipment = String.valueOf(input.get('EQUIPMENT'));
            maintenanceItem.planningPlant = String.valueOf(input.get('PLANNINGPLANT'));
            maintenanceItem.orderType = String.valueOf(input.get('ORDERTYPE'));
            maintenanceItem.plannerGroup = String.valueOf(input.get('PLANNERGROUP'));
            maintenanceItem.maintenanceActivityType = String.valueOf(input.get('MAINTENANCEACTIVITYTYPE'));
            maintenanceItem.mainWorkCenter = String.valueOf(input.get('MAINWORKCENTER'));
            maintenanceItem.taskListType = String.valueOf(input.get('TASKLISTTYPE'));
            maintenanceItem.tGroup = String.valueOf(input.get('TGROUP'));
            maintenanceItem.groupCount = String.valueOf(input.get('GROUPCOUNT'));
            inputs.add(maintenanceItem);
        }

        return inputs;
    }

    public static List<THOR_Maintenance_Item__c> saveMaintenanceItem(List<MaintenanceItemFromSAP> miList) {
        Map<String, Functional_Location__c> flMap = new Map<String, Functional_Location__c>();
        Map<String, String> upsertedFLMap = new Map<String, String>();
        Map<String, Equipment__c> eqMap = new Map<String, Equipment__c>();
        Map<String, String> upsertedEqMap = new Map<String, String>();
        Set<String> maintenancePlan = new Set<String>();
        List<Master_Map__c> MasterList = [ SELECT Id, Name, Type__c FROM Master_Map__c WHERE Type__c = 'Plant' OR Type__c = 'Main Work Center' OR Type__c = 'PlannerGroup' OR Type__c = 'MaintActivityType' ];
        List<THOR_Maintenance_Item__c> upsertedMainItem = new List<THOR_Maintenance_Item__c>();
        for (MaintenanceItemFromSAP mainItemSAP : miList) {
            if (mainItemSAP.FL != null) {
                Functional_Location__c upsertedFL = new Functional_Location__c();
                upsertedFL.Name = mainItemSAP.FL;
                flMap.put(upsertedFL.Name, upsertedFL);
            }
            if (String.IsNotEmpty(mainItemSAP.equipment)) {
                Equipment__c upsertedEQ = new Equipment__c();
                upsertedEQ.Name = mainItemSAP.equipment;
                eqMap.put(upsertedEQ.Name, upsertedEQ);
            }
            if (mainItemSAP.maintenancePlant != null && mainItemSAP.maintenancePlant != '') {
                maintenancePlan.add(mainItemSAP.maintenancePlant.trim());
            }
        }

        List<THOR_Maintenance_Plan__c> mainPlanList = [ SELECT Id, Name FROM THOR_Maintenance_Plan__c WHERE Name IN :maintenancePlan ];
        Map<String, String> mainPlanMap = new Map<String, String>();
        if (mainPlanList.size() > 0) {
            for (THOR_Maintenance_Plan__c mpSP : mainPlanList) {
                mainPlanMap.put(mpSP.Name, mpSP.Id);
            }
        }
        if (flMap.values().size() > 0) {
            upsert flMap.values() Name;
            for (Functional_Location__c fl : flMap.values()) {
                upsertedFlMap.put(fl.Name, fl.id);
            }
        }
        if (eqMap.values().size() > 0) {
            upsert eqMap.values() Name;
            for (Equipment__c eq : eqMap.values()) {
                upsertedEqMap.put(eq.Name, eq.id);
            }
        }
        for (MaintenanceItemFromSAP mainItemSAP : miList) {
            THOR_Maintenance_Item__c mainItemSF = new THOR_Maintenance_Item__c();
            mainItemSF.Name = mainItemSAP.maintenanceItem;
            if (mainItemSAP.maintenancePlant != null) {
                String maintenancePlanName = mainItemSAP.maintenancePlant.trim();
                if (mainPlanMap.get(maintenancePlanName) != null && mainPlanMap.get(maintenancePlanName) != '') {
                    mainItemSF.maintenancePlant__c = mainPlanMap.get(maintenancePlanName);
                }
            }

            mainItemSF.itemNo__c = mainItemSAP.itemNo;
            mainItemSF.text__c = mainItemSAP.text;
            mainItemSF.strategy__c = mainItemSAP.strategy;
            mainItemSF.orderType__c = mainItemSAP.orderType;
            mainItemSF.taskListType__c = mainItemSAP.taskListType;
            mainItemSF.tGroup__c = mainItemSAP.tGroup;
            mainItemSF.groupCount__c = mainItemSAP.groupCount;
			mainItemSF.FL__c = mainItemSAP.FL != null ? upsertedFlMap.get(mainItemSAP.FL) : null;
			mainItemSF.equipment__c = mainItemSAP.equipment != null ? upsertedEqMap.get(mainItemSAP.equipment) : null;
            
            for (Master_Map__c iMaster : MasterList) {
				mainItemSF.mainWorkCenter__c = iMaster.Name == mainItemSAP.mainWorkCenter && iMaster.Type__c == 'Main Work Center' ? iMaster.Id : null;
				mainItemSF.planningPlant__c = iMaster.Name == mainItemSAP.planningPlant && iMaster.Type__c == 'Plant' ? iMaster.Id : null;
				mainItemSF.plannerGroup__c = iMaster.Name == mainItemSAP.plannerGroup && iMaster.Type__c == 'PlannerGroup' ? iMaster.Id : null;
				mainItemSF.maintenanceActivityType__c = iMaster.Name == mainItemSAP.maintenanceActivityType && iMaster.Type__c == 'MaintActivityType' ? iMaster.Id : null;
            }
            upsertedMainItem.add(mainItemSF);
        }
        if (upsertedMainItem.size() > 0) {
            upsert upsertedMainItem Name;
        }
        return upsertedMainItem;
    }
}