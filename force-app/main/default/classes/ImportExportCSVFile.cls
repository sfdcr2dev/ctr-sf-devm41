/* Class for ImportExportCSVFile VF Page */
public with sharing class ImportExportCSVFile {

    public string currentWPId {get;set;}
    public string currentProjectNo {get;set;}
    public string Filename{get;set;}
    public integer TotalRecords {get;set;}
    public Id WP27Id {get;set;}
    public boolean existedWP27 {get;set;}
    public Punch_List_Management_System__c WP27 {get;set;}
    public boolean isError {get;set;}
    public boolean isFileEmpty {get;set;}
    public Blob FileContent{get;set;}
    String[] filelines = new String[]{};
    
    public string ProjectName {get;set;}
    public string ProjectNo {get;set;}
    public List<Handover__c> HandoversExport {get;set;}
    public Date TodayDate {get;set;}
    public boolean isRequire {get;set;}
    
    List<Handover__c> handoversUpload = new List<Handover__c>();
    
    
    public ImportExportCSVFile() {
    
        HandoversExport = new List<Handover__c>();
        ExportHandover();
        
    }
    public ImportExportCSVFile(ApexPages.StandardController controller) {
        TotalRecords = 0;
        existedWP27 = false;
        isError = false;
        isFileEmpty = false;
        
        Punch_List_Management_System__c currentWP27 = (Punch_List_Management_System__c)controller.getRecord();
        
        currentWPId = currentWP27.Id;
        
    }

    public Pagereference ReadFile()
    {   
        TotalRecords = 0;
        isRequire = false;
        
        if(FileContent != null) {
            
            try {
                Filename = FileContent.toString();
            }
            catch(Exception e)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please upload a valid CSV document');
                ApexPages.addMessage(myMsg); 
            }
            
            filelines = Filename.split('\n');
            
            Set<string> tempProjectNo = new Set<string>();
            
            //Check Work Process
            WP27 = [select id, Project__r.Project_Number__c, Work_Process_Status__c from Punch_List_Management_System__c where Id =: currentWPId];
            currentProjectNo = WP27.Project__r.Project_Number__c;
            
            List<Project__c> Projects = [select id, name, Project_Number__c, Status__c from Project__c where Project_Number__c =: currentProjectNo];
            
            for (Integer i=1;i<filelines.size();i++)
            {
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                
                string ProjectNo = inputvalues[0];
                tempProjectNo.add(ProjectNo);
                
                if(ProjectNo != currentProjectNo) {
                    isError = true;
                    ApexPages.Message errormsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Project No : ' + ProjectNo + ' in the Handover file is incorrect. Please check your Project No.');
                    ApexPages.addMessage(errormsg1);
                }
                else {
                    WP27Id = WP27.Id;
                
                    if(Projects.size() > 0) {
                        
                        Id ProjectId = Projects[0].Id;
                        ProjectName = Projects[0].Name;
                    
                        Handover__c Handover = new Handover__c();
                        Handover.Punch_List_Management_System__c = WP27Id;
                        
                        if(String.IsBlank(inputvalues[1])) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Item is a require field, cannot be empty.');
                            ApexPages.addMessage(errormsg);
                        }
                        else {
                            Handover.Item__c = inputvalues[1];
                        }
                        
                        if(String.IsBlank(inputvalues[2])) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Name is a require field, cannot be empty.');
                            ApexPages.addMessage(errormsg);
                        }
                        else {
                            Handover.Name = inputvalues[2];
                        }
                        
                        if(String.IsBlank(inputvalues[3])) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Contractor is a require field, cannot be empty.');
                            ApexPages.addMessage(errormsg);
                        }
                        else {
                            Handover.Contractor__c = inputvalues[3];
                        }
                        
                        if(String.IsBlank(inputvalues[4])) {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'P ID is a require field, cannot be empty.');
                            ApexPages.addMessage(errormsg);
                        }
                        else {
                            Handover.P_ID__c = inputvalues[4];
                        }
                        
                        if(!String.IsBlank(inputvalues[5])) {
                            Handover.Tag_and_Datasheet__c = Double.ValueOf(inputvalues[5]);
                        }
                        
                        if(!String.IsBlank(inputvalues[6])) {
                            Handover.SAP_Data__c = Double.ValueOf(inputvalues[6]);
                        }
                        
                        if(!String.IsBlank(inputvalues[7])) {
                            Handover.Operating_Manal__c = Double.ValueOf(inputvalues[7]);
                        }
                        
                        if(!String.IsBlank(inputvalues[8])) {
                            Handover.Spare_Parts_List__c = Double.ValueOf(inputvalues[8]);
                        }
                        
                        if(!String.IsBlank(inputvalues[9])) {
                            Handover.Concerned_Equipment_Installation__c = Double.ValueOf(inputvalues[9]);
                        }
                        
                        if(!String.IsBlank(inputvalues[10])) {
                            Handover.Punch_A_Complete__c = Double.ValueOf(inputvalues[10]);
                        }
                        
                        if(!String.IsBlank(inputvalues[11])) {
                            Handover.Red_Mark__c = Double.ValueOf(inputvalues[11]);
                        }
                        
                        if(!String.IsBlank(inputvalues[12])) {
                            Handover.Test_Pack__c = Double.ValueOf(inputvalues[12]);
                        }
                        
                        if(!String.IsBlank(inputvalues[13])) {
                            Handover.Piping_ReInstatement__c = Double.ValueOf(inputvalues[13]);
                        }
                        
                        if(!String.IsBlank(inputvalues[14])) {
                            Handover.E_and_I_Work_Election__c = Double.ValueOf(inputvalues[14]);
                        }
                        
                        if(!String.IsBlank(inputvalues[15])) {
                            Handover.MC_P__c = Date.ValueOf(inputvalues[15]);
                        }
                        
                        if(!String.IsBlank(inputvalues[16])) {
                            Handover.MC__c = Date.ValueOf(inputvalues[16]);
                        }
                        
                        if(!String.IsBlank(inputvalues[17])) {
                            Handover.Punch_B__c = Double.ValueOf(inputvalues[17]);
                        }
                        
                        if(!String.IsBlank(inputvalues[18])) {
                            Handover.Loop_Testing__c = Double.ValueOf(inputvalues[18]);
                        }
                        
                        if(!String.IsBlank(inputvalues[19])) {
                            Handover.Function_Testing__c = Double.ValueOf(inputvalues[19]);
                        }
                        
                        if(!String.IsBlank(inputvalues[20])) {
                            Handover.MCC__c = Double.ValueOf(inputvalues[20]);
                        }
                        
                        if(!String.IsBlank(inputvalues[21])) {
                            Handover.As_Built_P_ID__c = Double.ValueOf(inputvalues[21]);
                        }
                        
                        if(!String.IsBlank(inputvalues[22])) {
                            Handover.PSSR__c = Date.ValueOf(inputvalues[22]);
                        }
                        
                        if(!String.IsBlank(inputvalues[23])) {
                            Handover.HOC__c = Double.ValueOf(inputvalues[23]);
                        }
                        
                        if(!String.IsBlank(inputvalues[24])) {
                            Handover.RSFU_P__c = Date.ValueOf(inputvalues[24]);
                        }
                        
                        if(!String.IsBlank(inputvalues[25])) {
                            Handover.RSFU__c = Date.ValueOf(inputvalues[25]);
                        }
                        
                        if(!String.IsBlank(inputvalues[26])) {
                            Handover.As_Built__c = Double.ValueOf(inputvalues[26]);
                        }
                        
                        if(!String.IsBlank(inputvalues[27])) {
                            Handover.COD__c = Date.ValueOf(inputvalues[27]);
                        }
                        
                        if(!String.IsBlank(inputvalues[28])) {
                            Handover.Punch_C__c = Double.ValueOf(inputvalues[28]);
                        }
                        
                        handoversUpload.add(Handover);
                        
                    }
                    else {
                    
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Project No cannot be found. Please check Project No in your file.');
                        ApexPages.addMessage(errormsg);
                        
                        handoversUpload = new List<Handover__c>();
                        
                    }
                }
                
            }
            
            try{
            
                if(tempProjectNo.size() > 1) {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please check Project No data in your file.');
                    ApexPages.addMessage(errormsg);
                    handoversUpload = new List<Handover__c>();
                }
                else {
                    if(handoversUpload.size() > 0) {
                
                        TotalRecords = handoversUpload.size();
                    }
                }
                    
                
            }
            catch (Exception e)
            {
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.FATAL,'An error has occured. Please check the template or try again later');
                ApexPages.addMessage(errormsg);
                handoversUpload = new List<Handover__c>();
            }
        }
        else {
            isFileEmpty = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please select file before upload.');
            ApexPages.addMessage(myMsg); 
        }
        
        return null;
    }
    
    public void ExportHandover() {
        
        TodayDate = system.today();
        
        string WP27Id = ApexPages.currentPage().getParameters().get('WP27Id');
        Punch_List_Management_System__c WP27 = [select id, Project__c, Project__r.Project_Number__c, Project__r.Name from Punch_List_Management_System__c where Id =: WP27Id];
        
        ProjectName = WP27.Project__r.Name;
        ProjectNo = WP27.Project__r.Project_Number__c;
        
        HandoversExport = [select id, name, Punch_List_Management_System__c, Contractor__c, P_ID__c, Tag_and_Datasheet__c, SAP_Data__c, Operating_Manal__c, Spare_Parts_List__c, Concerned_Equipment_Installation__c, Punch_A_Complete__c,
                          Red_Mark__c, Test_Pack__c, Piping_ReInstatement__c, E_and_I_Work_Election__c, MC_P__c, MC__c, Punch_B__c, Loop_Testing__c, Function_Testing__c, MCC__c, As_Built_P_ID__c, PSSR__c, HOC__c,
                          RSFU__c, RSFU_P__c, As_Built__c, COD__c, Punch_C__c from Handover__c where Punch_List_Management_System__c =: WP27Id];
        
    }
    
    public PageReference ConfirmUpload() {
        
        
        //Delete Existing Handover if existed
        ClearExistingHandover(WP27Id);
        insert handoversUpload;
        
        //Update Work Process 27 Status
        WP27.Work_Process_Status__c = 'In Progress';
        update(WP27);
    
        String url = '/'+ WP27Id;
        
        PageReference PageRefBack = new PageReference(url);
    
        return PageRefBack;
        
    }
    
    public PageReference CancelUpload() {
        
        String url = '/'+ WP27Id;
        
        PageReference PageRefBack = new PageReference(url);
    
        return PageRefBack;
        
    }
    
    public void ClearExistingHandover(Id WP27Id) {
        
        List<Handover__c> existingHandovers = [select id, Punch_List_Management_System__c from Handover__c where Punch_List_Management_System__c =: WP27Id];
        
        if(existingHandovers.size() > 0) {
            delete(existingHandovers);
        }
        
    }
    
    public List<Handover__c> getuploadedHandovers() {
        if (handoversUpload!= NULL)
            if (handoversUpload.size() > 0)
        return handoversUpload;
        else
        return null;
        else
        return null;
    }
    
    public void ReloadPage() {
        
        isError = false;
        
    }
    
}