/* Class for MasterData */
public with sharing class MasterDataController {

    public string WorkProcessNo {get;set;}
    public string Guideline {get;set;}
    
    public MasterDataController() {
        
        WorkProcessNo = ApexPages.currentPage().getParameters().get('WorkProcessNo'); 
        
        Master_Data__c MD = [select id, name from Master_Data__c where Name = 'SME and Guideline'];
        
        Master_Data_Detail__c MDDetail = [select Id, Name, Work_Process_No__c, Guideline__c, Master_Data__c from Master_Data_Detail__c 
                    where Master_Data__c =: MD.Id AND Work_Process_No__c =: Integer.ValueOf(WorkProcessNo)];
        
        Guideline = MDDetail.Guideline__c;
        
    }
    
    @auraEnabled
    public static string getUserTheme() {
        
        string userTheme = UserInfo.getUiTheme();
        
        if(userTheme == 'Theme4d') {
            return 'desktop';
        }
        else if(userTheme == 'Theme4t') {
            return 'app';
        }
        else {
            return null;
        }
    }
    
    @auraEnabled
    public static string getGuidelineForWorkProcess(Integer workProcessNo) {
        
        Master_Data__c MD = [select id, name from Master_Data__c where Name = 'SME and Guideline'];
        
        Master_Data_Detail__c MDDetail = [select Id, Name, Work_Process_No__c, Guideline__c, Master_Data__c from Master_Data_Detail__c 
                    where Master_Data__c =: MD.Id AND Work_Process_No__c =: Integer.ValueOf(WorkProcessNo)];
        
        string Guideline = MDDetail.Guideline__c;
        
        return Guideline;
    }
    
    @auraEnabled
    public static string getProcedureForWorkProcess(Integer workProcessNo) {
        
        string BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        string theme = getUserTheme();
        
        Master_Data__c MD = [select id, name from Master_Data__c where Name = 'SME and Guideline'];
        
        Master_Data_Detail__c MDDetail = [select Id, Name, Work_Process_No__c, Guideline__c, Master_Data__c from Master_Data_Detail__c 
                    where Master_Data__c =: MD.Id AND Work_Process_No__c =: Integer.ValueOf(WorkProcessNo)];
        
        if(theme == 'desktop') {
            string procedureLink = BaseUrl + 'lightning/r/' + MDDetail.Id + '/related/AttachedContentDocuments/view';
            return procedureLink;
        }
        else if(theme == 'app') {
            string recordId = MDDetail.Id;
            return recordId;
        }
        else {
            return null;
        }
        
    }
    
    @auraEnabled
    public static string getWorkProcessName(Integer workProcessNo) {
        
        Master_Data__c MD = [select id, name from Master_Data__c where Name = 'SME and Guideline'];
        
        Master_Data_Detail__c MDDetail = [select Id, Name, Work_Process_No__c, Guideline__c, Master_Data__c from Master_Data_Detail__c 
                    where Master_Data__c =: MD.Id AND Work_Process_No__c =: Integer.ValueOf(WorkProcessNo)];
        
        string name = MDDetail.Name;
        
        return name;
    }
    
    public string LanguageThai {
        get {
            return EncodingUtil.base64decode('77u/').toString();
        }
    }

}