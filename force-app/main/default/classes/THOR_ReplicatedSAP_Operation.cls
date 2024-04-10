public class THOR_ReplicatedSAP_Operation {

    public class ParseException extends Exception {}

    public class dto_response extends WebserviceExtend.dto_response {}

    public static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }

    public class OperationFromSAP {
        public String taskListType;
        public String tGroup;
        public String groupCount;
        public String superiorOpNode;
        public String operation;
        public String description;
        public String controlKey;
        public String workCenter;
        public String plant;
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';

        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'THOR_ReplicatedSAP_Operation',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody)
        );

        List<OperationFromSAP> opList;
        try {
            opList = parseJSONInputs(body);
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

        List<Operation__c> savedList = saveOperation(opList);

        applog.Response_Body__c = JSON.serialize(
            new Map<String, Object>{
                'description' => new Map<String, Object>{
                    'success' => savedList.size() > 0,
                    'message' => savedList.size() > 0 ? '' : 'Not found Operation Information',
                    'linkurl' => applog.External_ID__c
                },
                'recordIds' => (new Map<Id, Operation__c>(savedList)).keySet()
            }
        );
        ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

        return dto_response.parse(applog.Response_Body__c);
    }

    public static List<OperationFROMSAP> parseJSONInputs(String body) {
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> opList = (List<Object>)parsedBody.get('OPLIST');

        System.debug(opList);

        List<OperationFROMSAP> inputs = new List<OperationFROMSAP>();
        for (Object rawInput : opList) {
            Map<String, Object> input = (Map<String, Object>) rawInput;
            OperationFROMSAP operation = new OperationFROMSAP();
            operation.taskListType = String.valueOf(input.get('TASKLISTTYPE'));
            operation.tGroup = String.valueOf(input.get('TGROUP'));
            operation.groupCount = String.valueOf(input.get('GROUPCOUNT'));
            operation.superiorOpNode = String.valueOf(input.get('SUPERIOROPNODE'));
            operation.operation = String.valueOf(input.get('OPERATION'));
            operation.description = String.valueOf(input.get('DESCRIPTION'));
            operation.controlKey = String.valueOf(input.get('CONTROLKEY'));
            operation.workCenter = String.valueOf(input.get('WORKCENTER'));
            operation.plant = String.valueOf(input.get('PLANT'));
            inputs.add(operation);
        }

        return inputs;
    }

    public static List<Operation__c> saveOperation(List<OperationFromSAP> opList) {
        List<Master_Map__c> MasterList;

        MasterList = [
            SELECT Id, Name, Type__c
            FROM Master_Map__c
            WHERE Type__c = 'Plant' OR Type__c = 'Main Work Center'
        ];

        List<Operation__c> upsertedOperation = new List<Operation__c>();

        for (OperationFromSAP opSAP : opList) {
            Operation__c opSF = new Operation__c();
            opSF.taskListType__c = opSAP.taskListType;
            opSF.tGroup__c = opSAP.tGroup;
            opSF.groupCount__c = opSAP.groupCount;
            opSF.superiorOpNode__c = opSAP.superiorOpNode;
            opSF.operation__c = opSAP.operation;
            opSF.description__c = opSAP.description;
            opSF.Control_Key__c = opSAP.controlKey;
            opSF.OperationKey__c = opSAP.taskListType + opSAP.tGroup + opSAP.groupCount + opSAP.operation;

            for (Master_Map__c iMaster : MasterList) {
                if (iMaster.Name == opSAP.workCenter) {
                    opSF.Main_Work_Center__c = iMaster.Id;
                }
                if (iMaster.Name == opSAP.plant && iMaster.Type__c == 'Plant') {
                    opSF.plant__c = iMaster.Id;
                }
            }

            upsertedOperation.add(opSF);
        }
        if (upsertedOperation.size() > 0) {
            upsert upsertedOperation OperationKey__c;
        }
        return upsertedOperation;
    }
}