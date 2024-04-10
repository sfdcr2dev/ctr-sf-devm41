public class THOR_ReplicatedSAP_TaskList {

    public class ParseException extends Exception {}

    public class dto_response extends WebserviceExtend.dto_response {}

    public static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }

    public class TaskListFromSAP {
        public String taskListType;
        public String tGroup;
        public String groupCount;
        public String description;
        public String FL;
        public String workCenter;
        public String plant;
        public String plannerGroup;
        public String strategy;
        public String usage;
        public String status;
        public String changeOn;
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';

        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'THOR_ReplicatedSAP_TaskList',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody)
        );

        List<TaskListFromSAP> tlList;
        try {
            tlList = parseJSONInputs(body);
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

        List<THOR_Task_List__c> savedList = saveTaskList(tlList);

        applog.Response_Body__c = JSON.serialize(
            new Map<String, Object>{
                'description' => new Map<String, Object>{
                    'success' => savedList.size() > 0,
                    'message' => savedList.size() > 0 ? '' : 'Not found Task List Information',
                    'linkurl' => applog.External_ID__c
                },
                'recordIds' => (new Map<Id, THOR_Task_List__c>(savedList)).keySet()
            }
        );
        ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

        return dto_response.parse(applog.Response_Body__c);
    }

    public static List<TaskListFROMSAP> parseJSONInputs(String body) {
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> tlList = (List<Object>)parsedBody.get('TLLIST');

        List<TaskListFROMSAP> inputs = new List<TaskListFROMSAP>();
        for (Object rawInput : tlList) {
            Map<String, Object> input = (Map<String, Object>) rawInput;
            TaskListFROMSAP taskList = new TaskListFROMSAP();
            taskList.taskListType = String.valueOf(input.get('TASKLISTTYPE'));
            taskList.tGroup = String.valueOf(input.get('TGROUP'));
            taskList.groupCount = String.valueOf(input.get('GROUPCOUNT'));
            taskList.description = String.valueOf(input.get('DESCRIPTION'));
            taskList.FL = String.valueOf(input.get('FL'));
            taskList.workCenter = String.valueOf(input.get('WORKCENTER'));
            taskList.plant = String.valueOf(input.get('PLANT'));
            taskList.plannerGroup = String.valueOf(input.get('PLANNERGROUP'));
            taskList.strategy = String.valueOf(input.get('STRATEGY'));
            taskList.usage = String.valueOf(input.get('USAGE'));
            taskList.status = String.valueOf(input.get('STATUS'));
            taskList.changeOn = String.valueOf(input.get('CHANGEON'));
            inputs.add(taskList);
        }

        return inputs;
    }

    public static List<THOR_Task_List__c> saveTaskList(List<TaskListFromSAP> tlList) {
        List<Master_Map__c> MasterList = [
            SELECT Id, Name, Type__c
            FROM Master_Map__c
            WHERE Type__c = 'Plant' OR Type__c = 'Main Work Center' OR Type__c = 'PlannerGroup'
        ];

        List<THOR_Task_List__c> upsertedTaskListList = new List<THOR_Task_List__c>();

        Map<String, Functional_Location__c> flMap = new Map<String, Functional_Location__c>();
        Map<String, String> upsertedFLMap = new Map<String, String>();

        for (TaskListFromSAP tasklistSAP : tlList) {
            if (tasklistSAP.FL != null && tasklistSAP.FL != '') {
                Functional_Location__c fl = new Functional_Location__c();
                fl.Name = tasklistSAP.FL;
                flMap.put(tasklistSAP.FL, fl);
            }
        }

        if (flMap.values().size() > 0) {
            upsert flMap.values() Name;

            for (Functional_Location__c upsertedFL : flMap.values()) {
                upsertedFLMap.put(upsertedFL.Name, upsertedFL.Id);
            }
        }

        for (TaskListFromSAP tasklistSAP : tlList) {
            THOR_Task_List__c taskListSF = new THOR_Task_List__c();
            taskListSF.Name = tasklistSAP.taskListType + ' ' + tasklistSAP.tGroup + ' ' + tasklistSAP.groupCount;
            taskListSF.taskListType__c = tasklistSAP.taskListType;
            taskListSF.tGroup__c = tasklistSAP.tGroup;
            taskListSF.groupCount__c = tasklistSAP.groupCount;
            taskListSF.description__c = tasklistSAP.description;
            taskListSF.strategy__c = tasklistSAP.strategy;
            taskListSF.usage__c = tasklistSAP.usage;
            taskListSF.status__c = tasklistSAP.status;

            if (tasklistSAP.changeOn != null) {
                if (tasklistSAP.changeOn != '') {
//                    String day = tasklistSAP.changeOn.substring(0, 2);
//                    String month = tasklistSAP.changeOn.substring(3, 5);
//                    String year = tasklistSAP.changeOn.substring(
//                        tasklistSAP.changeOn.length() - 4,
//                        tasklistSAP.changeOn.length()
//                    );
//
//                    system.debug('day---+' + day);
//                    system.debug('month---+' + month);
//                    system.debug('year---+' + year);
//
//                    String dateStr = year + '-' + month + '-' + day;
//                    taskListSF.changeOn__c = Date.valueOf(dateStr);

                    taskListSF.changeOn__c = Date.valueOf(tasklistSAP.changeOn);
                }
            }

            for (Master_Map__c iMaster : MasterList) {
                if (iMaster.Name == tasklistSAP.workCenter) {
                    taskListSF.workCenter__c = iMaster.Id;
                }
                if (iMaster.Name == tasklistSAP.plant && iMaster.Type__c == 'Plant') {
                    taskListSF.plant__c = iMaster.Id;
                }

                if (iMaster.Name == tasklistSAP.plannerGroup) {
                    taskListSF.plannerGroup__c = iMaster.Id;
                }
            }
            if (tasklistSAP.FL != null && tasklistSAP.FL != '') {
                taskListSF.FL__c = upsertedFLMap.get(tasklistSAP.FL);
            }

            upsertedTaskListList.add(taskListSF);
        }

        if (upsertedTaskListList.size() > 0) {
            upsert upsertedTaskListList Name;
        }
        system.debug('success');
        return upsertedTaskListList;
    }   
}