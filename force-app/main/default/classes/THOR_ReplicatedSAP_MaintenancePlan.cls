public class THOR_ReplicatedSAP_MaintenancePlan {

    public class ParseException extends Exception {}

    public class dto_response extends WebserviceExtend.dto_response {}

    public static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }

    public class MaintenancePlanFromSAP {
        public String category;
        public String maintenancePlantNo;
        public String description;
        public String strategy;
        public String factory;
        public String autorizeGroup;
        public String noItem;
        public String callNumber;
        public String scheduledPreriod;
        public String scheduledUnit;
        public String systemStatus;
        public String cycleStart;
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';

        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'THOR_ReplicatedSAP_MaintenancePlan',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody)
        );

        List<MaintenancePlanFromSAP> mpList;
        try {
            mpList = parseJSONInputs(body);
        } catch (Exception ex) {
            applog.Error_Message__c = ex.getMessage();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                        'success' => false,
                        'message' => 'Unknown string format, cannot parse body data. Please try JSON format.',
                        'linkurl' => applog.External_ID__c
                    }
                }
            );
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
            return dto_response.parse(applog.Response_Body__c);
        }

        List<THOR_Maintenance_Plan__c> savedList = saveMaintenancePlan(mpList);

        applog.Response_Body__c = JSON.serialize(
            new Map<String, Object>{
                'description' => new Map<String, Object>{
                    'success' => savedList.size() > 0,
                    'message' => savedList.size() > 0 ? '' : 'Not found Maintenance Plan Information',
                    'linkurl' => applog.External_ID__c
                },
                'recordIds' => (new Map<Id, THOR_Maintenance_Plan__c>(savedList)).keySet()
            }
        );
        ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

        return dto_response.parse(applog.Response_Body__c);
    }

    public static List<MaintenancePlanFROMSAP> parseJSONInputs(String body) {
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> mpList = (List<Object>)parsedBody.get('MPLIST');

        List<MaintenancePlanFROMSAP> inputs = new List<MaintenancePlanFROMSAP>();
        for (Object rawInput : mpList) {
            Map<String, Object> input = (Map<String, Object>) rawInput;
            MaintenancePlanFROMSAP maintenancePlan = new MaintenancePlanFROMSAP();
            maintenancePlan.category = String.valueOf(input.get('CATEGORY'));
            maintenancePlan.maintenancePlantNo = String.valueOf(input.get('MAINTENANCEPLANTNO'));
            maintenancePlan.description = String.valueOf(input.get('DESCRIPTION'));
            maintenancePlan.strategy = String.valueOf(input.get('STRATEGY'));
            maintenancePlan.factory = String.valueOf(input.get('FACTORY'));
            maintenancePlan.autorizeGroup = String.valueOf(input.get('AUTHORIZEGROUP'));
            maintenancePlan.noItem = String.valueOf(input.get('NOITEM'));
            maintenancePlan.callNumber = String.valueOf(input.get('CALLNUMBER'));
            maintenancePlan.scheduledPreriod = String.valueOf(input.get('SCHEDULEDPERIOD'));
            maintenancePlan.scheduledUnit = String.valueOf(input.get('SCHEDULEDUNIT'));
            maintenancePlan.systemStatus = String.valueOf(input.get('SYSTEMSTATUS'));
            maintenancePlan.cycleStart = String.valueOf(input.get('CYCLESTART'));
            inputs.add(maintenancePlan);
        }

        return inputs;
    }

    public static List<THOR_Maintenance_Plan__c> saveMaintenancePlan(List<MaintenancePlanFromSAP> mpList) {
        List<THOR_Maintenance_Plan__c> maintenancePlanList = new List<THOR_Maintenance_Plan__c>();

        for (MaintenancePlanFromSAP mpSAP : mpList) {
            THOR_Maintenance_Plan__c mpSF = new THOR_Maintenance_Plan__c();
            mpSF.Name = mpSAP.maintenancePlantNo;
            mpSF.category__c = mpSAP.category;
            mpSF.description__c = mpSAP.description;
            mpSF.strategy__c = mpSAP.strategy;
            mpSF.factory__c = mpSAP.factory;
            mpSF.autorizeGroup__c = mpSAP.autorizeGroup;
            mpSF.noItem__c = mpSAP.noItem;
            mpSF.callNumber__c = mpSAP.callNumber;
            mpSF.scheduledPreriod__c = mpSAP.scheduledPreriod;
            mpSF.scheduledUnit__c = mpSAP.scheduledUnit;
            mpSF.systemStatus__c = mpSAP.systemStatus;

            if (mpSAP.cycleStart != null) {
                if (mpSAP.cycleStart.trim() != '') {
//                    String day = mpSAP.cycleStart.substring(0, 2);
//                    String month = mpSAP.cycleStart.substring(3, 5);
//                    String year = mpSAP.cycleStart.substring(
//                        mpSAP.cycleStart.length() - 4,
//                        mpSAP.cycleStart.length()
//                    );
//
//                    system.debug('day---+' + day);
//                    system.debug('month---+' + month);
//                    system.debug('year---+' + year);
//
//                    String dateStr = year + '-' + month + '-' + day;
//
//                    mpSF.cycleStart__c = Date.valueOf(dateStr);

                    mpSF.cycleStart__c = Date.valueOf(mpSAP.cycleStart);
                }
            }
            maintenancePlanList.add(mpSF);
        }

        if (maintenancePlanList.size() > 0) {
            upsert maintenancePlanList Name;
        }
        system.debug('success');
        return maintenancePlanList;
    }

}