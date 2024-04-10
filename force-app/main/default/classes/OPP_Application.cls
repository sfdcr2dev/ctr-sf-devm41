@RestResource(urlMapping='/OPP_Application/*')
global with sharing class OPP_Application {

    global class Input {
        public String application_name;
        public String icon;
        public String url;
        public String salesforce_id;
        public Input() {

        }
        public Input(Input rowInput) {
            this.application_name = rowInput.application_name;
            this.icon = rowInput.icon;
            this.url = rowInput.url;
            this.salesforce_id = rowInput.salesforce_id;
        }
    }

    global class Output {
        public List<SaveResult> applications;
        public Output() {
            this.applications = new List<SaveResult>();
        }
    }

    class SaveResult {
        public Boolean isCompleted;
        public List<ErrorResult> errors;
        public Input refObject;
        public SaveResult() {
            this.errors = new List<ErrorResult>();
        }
    }

    class ErrorResult {
        public String code;
        public String message;
    }

    @HttpPost
    global static Output doPost(List<Input> applications) {
        List<OPP_Application__c> insertList = new List<OPP_Application__c>();
        Output output = new Output();
        for (Input rowInput : applications) {
            SaveResult saveResult = new SaveResult();
            OPP_Application__c oppApplication = new OPP_Application__c();
            oppApplication.Name = rowInput.application_name;
            oppApplication.Icon__c = rowInput.icon;
            oppApplication.URL_Web__c = rowInput.url;
            oppApplication.Notification__c = true;
            insertList.add(oppApplication);
            saveResult.refObject = rowInput;
            output.applications.add(saveResult);
        }
        List<Database.SaveResult> saveResults = Database.insert(insertList, false);
        for (Integer i = 0; i < saveResults.size(); i++) {
            Database.SaveResult saveResult = saveResults[i];
            for(Database.Error err : saveResult.getErrors()) {
                ErrorResult errorResult = new ErrorResult();
                errorResult.code = String.valueOf(err.getStatusCode());
                errorResult.message = err.getMessage();
                output.applications[i].errors.add(errorResult);
            }
            output.applications[i].refObject.salesforce_id = saveResult.getId();
            output.applications[i].isCompleted = output.applications[i].errors.size() > 0 ? false : true ;
        }
        return output;
    }

    @HttpPatch
    global static Output doPatch(List<Input> applications) {
        Set<Id> salesforceIdSet = new Set<Id>();
        for (Input rowInput : applications) {
            salesforceIdSet.add(rowInput.salesforce_id);
        }
        List<OPP_Application__c> oppApplications =[SELECT Id,Name,Icon__c,URL_Web__c FROM OPP_Application__c WHERE Id IN :salesforceIdSet];
        Output output = new Output();
        List<OPP_Application__c> updateList = new List<OPP_Application__c>();
        for (Input rowInput : applications){
            SaveResult saveResult = new SaveResult();
            Boolean recordNotFound = true;
            for(OPP_Application__c oppApplication : oppApplications){
                if(rowInput.salesforce_id == oppApplication.Id){
                    oppApplication.Name = rowInput.application_name;
                    oppApplication.Icon__c = rowInput.icon;
                    oppApplication.URL_Web__c = rowInput.url;
                    saveResult.refObject = rowInput;
                    updateList.add(oppApplication);
                    recordNotFound = false;
                    break;
                }
            }
            if(recordNotFound){
                ErrorResult errorResult = new ErrorResult();
                errorResult.code = 'RECORD_NOT_FOUND';
                errorResult.message = 'Record not found';
                saveResult.errors.add(errorResult);
                saveResult.refObject = rowInput;
            }
            output.applications.add(saveResult);
        }
        List<Database.SaveResult> saveResults = Database.update(updateList, false);
        Map<Id, List<Database.Error>> errors = new Map<Id, List<Database.Error>>();
        for(Integer i = 0; i < saveResults.size(); i++){
            Database.SaveResult saveResult = saveResults[i];
            errors.put(updateList[i].Id, saveResult.getErrors());
        }
        for (SaveResult saveResult : output.applications){
            if (String.isNotBlank(saveResult.refObject.salesforce_id) && errors.containsKey(saveResult.refObject.salesforce_id)){
                for(Database.Error err : errors.get(saveResult.refObject.salesforce_id)){
                    ErrorResult errorResult = new ErrorResult();
                    errorResult.code = String.valueOf(err.getStatusCode());
                    errorResult.message = err.getMessage();
                    saveResult.errors.add(errorResult);
                }
            }
			saveResult.isCompleted = saveResult.errors.size() > 0 ? false : true;
        }
        return output;
    }
}