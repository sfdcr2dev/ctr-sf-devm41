@RestResource(urlMapping='/OPP_Notification/*')
global with sharing class OPP_Notification{
    global class Input{
        public String api_id;
        public String application_id;
        public String application_name;
        public String subject;
        public String description;
        public String username;
        public String users;
        public String requester;
        public String status;
        public String reference_id;
        public String event_code;
        public String url;
        public String salesforce_id;
        public String step;
        public Input(){

        }

        public Input(Input rowInput){
            this.api_id = rowInput.api_id;
            this.application_id = rowInput.application_id;
            this.application_name = rowInput.application_name;
            this.subject = rowInput.subject;
            this.description = rowInput.description;
            this.username = rowInput.username;
            this.users = rowInput.users;
            this.requester = rowInput.requester;
            this.status = rowInput.status;
            this.reference_id = rowInput.reference_id;
            this.event_code = rowInput.event_code;
            this.url = rowInput.url;
            this.salesforce_id = rowInput.salesforce_id;
            this.step = rowInput.step;
        }
    }

    global class Output{
        public List<SaveResult> notifications;
        public Output(){ this.notifications = new List<SaveResult>();}
    }

    class SaveResult{
        public Boolean isCompleted;
        public List<ErrorResult> errors;
        public Input refObject;
        public SaveResult(){ this.errors = new List<ErrorResult>();}
    }

    class ErrorResult{
        public String code;
        public String message;
    }

    @HttpPost
    global static Output doPost(List<Input> notifications){
        List<Input> prepareInputList = prepare(notifications);
        Set<String> applicationIdSet = new Set<String>();
        Set<String> referenceIdSet = new Set<String>();
        Set<String> userSet = new Set<String>();
        for(Input rowInput : prepareInputList){
            applicationIdSet.add(rowInput.application_id);
            referenceIdSet.add(rowInput.reference_id);
            userSet.add(rowInput.username);
        }
        List<OPP_Notification__c> oppNotifications = [SELECT Id,Subject__c,Application__c,ApplicationName__c,ReferenceID__c,Username__c,Status__c FROM OPP_Notification__c WHERE ReferenceID__c IN :referenceIdSet AND Application__c IN :applicationIdSet AND Username__c IN :userSet AND Status__c IN ('New')];
        Map<String, OPP_Notification__c> mapOppNotifications = new Map<String, OPP_Notification__c>();
        for(OPP_Notification__c oppNotification : oppNotifications){
            String key = oppNotification.Application__c+'.' +oppNotification.ReferenceID__c+'.'+oppNotification.Username__c;
            key = key.toLowerCase();
            mapOppNotifications.put(key, oppNotification);
        }
        //Map<String, Id> applications = getApplicationMap(prepareInputList);
        Map<Id, String> applications = getApplicationIdMap(prepareInputList);
        Map<String, Id> users = getUserMap(prepareInputList);
        Set<String> setKey = new Set<String>();
        List<OPP_Notification__c> insertList = new List<OPP_Notification__c>();
        List<SaveResult> insertSaveResultList = new List<SaveResult>();
        Output output = new Output();
        for(Input rowInput : prepareInputList){
            SaveResult saveResult = new SaveResult();
            Boolean recordNotFound = true;
            String key = rowInput.application_id+'.'+rowInput.reference_id +'.'+rowInput.username;
            key = key.toLowerCase();
            if(setKey.contains(key)){
                recordNotFound = false;
            }else{
                setKey.add(key);
            }

            if(recordNotFound){
                if(mapOppNotifications.containsKey(key)){
                    recordNotFound = false;
                }
            }

            if(recordNotFound){
                OPP_Notification__c oppNotification = new OPP_Notification__c();
                oppNotification.ApiID__c = rowInput.api_id;
                oppNotification.Application__c = rowInput.application_id;
                oppNotification.ApplicationName__c = rowInput.application_name;
                oppNotification.Subject__c = rowInput.subject;
                oppNotification.Description__c = rowInput.description;
                oppNotification.UserName__c = rowInput.username;
                oppNotification.Requester__c = rowInput.requester;
                oppNotification.ReferenceID__c = rowInput.reference_id;
                oppNotification.Step__c = rowInput.step;
 				oppNotification.URL__c = rowInput.url;
                
                if(String.isNotBlank(rowInput.status)){
                    oppNotification.Status__c = rowInput.status;
                }
                if(String.isNotBlank(rowInput.event_code)){
                    oppNotification.Event__c = rowInput.event_code;
                }
                if(applications.containsKey(oppNotification.Application__c)){
                    oppNotification.ApplicationName__c = applications.get(oppNotification.Application__c);
                    rowInput.application_name = oppNotification.ApplicationName__c;
                }else{
                    ErrorResult errorResult = new ErrorResult();
                    errorResult.code = 'APPLICATION_NOT_FOUND';
                    errorResult.message = 'Application not found';
                    saveResult.errors.add(errorResult);
                }
                if(users.containsKey(oppNotification.UserName__c.toLowerCase())){
                    oppNotification.User__c = users.get(oppNotification.UserName__c.toLowerCase());
                }else{
                    ErrorResult errorResult = new ErrorResult();
                    errorResult.code = 'USER_NOT_FOUND';
                    errorResult.message = 'User not found';
                    saveResult.errors.add(errorResult);
                }

                insertList.add(oppNotification);
                saveResult.refObject = rowInput;
                insertSaveResultList.add(saveResult);
            }else{
                ErrorResult errorResult = new ErrorResult();
                errorResult.code = 'DUPLICATE_RECORD_FOUND';
                errorResult.message = 'Duplicate record found';
                saveResult.errors.add(errorResult);
                saveResult.refObject = rowInput;
                saveResult.isCompleted = false;
            }
            output.notifications.add(saveResult);
        }
        List<Database.SaveResult> saveResults = Database.insert(insertList, false);
        for(Integer i = 0; i < saveResults.size(); i++){
            Database.SaveResult saveResult = saveResults[i];

            for(Database.Error err : saveResult.getErrors()){
                ErrorResult errorResult = new ErrorResult();
                errorResult.code = String.valueOf(err.getStatusCode());
                errorResult.message = err.getMessage();
                insertSaveResultList[i].errors.add(errorResult);
            }

            insertSaveResultList[i].refObject.salesforce_id = saveResult.getId();
            if(insertSaveResultList[i].errors.size() > 0){
                insertSaveResultList[i].isCompleted = false;
            }else{
                insertSaveResultList[i].isCompleted = true;
            }
        }
        //System.debug(output);
        return output;
    }
    @HttpPatch
    global static Output doPatch(List<Input> notifications){
        //System.debug(notifications);
        List<Input> prepareInputList = prepare(notifications);
        //Set<String> applicationNameSet = new Set<String>();
        Set<String> applicationIdSet = new Set<String>();
        Set<String> referenceIdSet = new Set<String>();
        Set<String> stepSet = new Set<String>();
        for(Input rowInput : prepareInputList){
            //applicationNameSet.add(rowInput.application_name);
            applicationIdSet.add(rowInput.application_id);
            referenceIdSet.add(rowInput.reference_id);
            stepSet.add(rowInput.step);
        }

        //System.debug(applicationIdSet);
        //System.debug(referenceIdSet);
        //System.debug(stepSet);
        List<OPP_Notification__c> oppNotifications =[SELECT Id,Subject__c,Application__c,ApplicationName__c,ReferenceID__c,Step__c FROM OPP_Notification__c WHERE ReferenceID__c IN:referenceIdSet AND Application__c IN:applicationIdSet AND Status__c IN ('New')];
        Map<String, List<OPP_Notification__c>> mapOppNotifications = new Map<String, List<OPP_Notification__c>>();
        for (OPP_Notification__c oppNotification : oppNotifications) {
            String key = oppNotification.Application__c + '.' + oppNotification.ReferenceID__c;
            key = key.toLowerCase();
            if(mapOppNotifications.containsKey(key)){
                List<OPP_Notification__c> oppNotificationList = mapOppNotifications.get(key);
                oppNotificationList.add(oppNotification);
            }else{
                List<OPP_Notification__c> oppNotificationList = new List<OPP_Notification__c>();
                oppNotificationList.add(oppNotification);
                mapOppNotifications.put(key, oppNotificationList);
            }
        }
        //System.debug(oppNotifications);
        Output output = new Output();
        Map<Id, OPP_Notification__c> mapUpdateList = new Map<Id, OPP_Notification__c>();
        for(Input rowInput : prepareInputList){
            SaveResult saveResult = new SaveResult();
            Boolean recordNotFound = true;
            String key = rowInput.application_id + '.' + rowInput.reference_id;
            key = key.toLowerCase();
            if(mapOppNotifications.containsKey(key)){
                List<OPP_Notification__c> oppNotificationList = mapOppNotifications.get(key);
                for(OPP_Notification__c oppNotification : oppNotificationList){
                    oppNotification.Status__c = rowInput.status;
                    rowInput.salesforce_id = oppNotification.Id;
                    saveResult.refObject = rowInput;
                    mapUpdateList.put(oppNotification.Id, oppNotification);
                }
                recordNotFound = false;
            }
            if(recordNotFound){
                ErrorResult errorResult = new ErrorResult();
                errorResult.code = 'RECORD_NOT_FOUND';
                errorResult.message = 'Record not found';
                saveResult.errors.add(errorResult);
                saveResult.refObject = rowInput;
            }
            output.notifications.add(saveResult);
        }

        List<OPP_Notification__c> updateList = mapUpdateList.values();
        List<Database.SaveResult> saveResults = Database.update(updateList, false);
        Map<Id, List<Database.Error>> errors = new Map<Id, List<Database.Error>>();
        for (Integer i = 0; i < saveResults.size(); i++){
            Database.SaveResult saveResult = saveResults[i];
            errors.put(updateList[i].Id, saveResult.getErrors());
        }
        for(SaveResult saveResult : output.notifications){
            if(String.isNotBlank(saveResult.refObject.salesforce_id) && errors.containsKey(saveResult.refObject.salesforce_id)) {
                for(Database.Error err : errors.get(saveResult.refObject.salesforce_id)){
                    ErrorResult errorResult = new ErrorResult();
                    errorResult.code = String.valueOf(err.getStatusCode());
                    errorResult.message = err.getMessage();
                    saveResult.errors.add(errorResult);
                }
            }
            if(saveResult.errors.size() > 0){
                saveResult.isCompleted = false;
            }else{
                saveResult.isCompleted = true;
            }
        }
        return output;
    }

    private static List<Input> prepare(List<Input> notifications) {
        for(Input rowInput : notifications){
            rowInput.username = rowInput.users;
            if(String.isBlank(rowInput.application_id)){ rowInput.application_id = '';}
            if(String.isBlank(rowInput.reference_id)){ rowInput.reference_id = '';}
            if(String.isBlank(rowInput.username)){ rowInput.username = '';}
        }
        return notifications;
    }
    private static Map<Id, String> getApplicationIdMap(List<Input> notifications) {
        Set<String> applicationIdSet = new Set<String>();
        for(Input rowInput : notifications){
            applicationIdSet.add(rowInput.application_id);
        }
        Map<Id, String> applications = new Map<Id, String>();
        for(OPP_Application__c oppApplication : [SELECT Id, Name FROM OPP_Application__c WHERE Id = :applicationIdSet]){
            applications.put(oppApplication.Id, oppApplication.Name);
        }
        return applications;
    }
    private static Map<String, Id> getUserMap(List<Input> notifications) {
        Set<String> userNameSet = new Set<String>();
        for(Input rowInput : notifications){
            userNameSet.add(rowInput.username);
        }
        Map<String, Id> users = new Map<String, Id>();
        for(User user : [SELECT Id, Username FROM User WHERE Username = :userNameSet]){
            users.put(user.Username.toLowerCase(), user.Id);
        }
        return users;
    }
}