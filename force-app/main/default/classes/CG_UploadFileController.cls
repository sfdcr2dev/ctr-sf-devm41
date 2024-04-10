/* 
 * Author : Softever
*/
public with sharing class CG_UploadFileController
{   
    //Picklist of tnteger values to hold file count
    public List<SelectOption> filesCountList {get; set;}
    //Selected count
    public String FileCount {get; set;}
    public integer MaximumUploadFile {get;set;}
    
    public List<Attachment> existingFiles {get;set;}
    public List<Attachment> allFileList {get; set;}
    public integer UploadedSize {get;set;}
    public integer MaxUploadFile {get;set;}
    public string cgSettingId {get;set;}
    public boolean isUploadEnable {get;set;}
    public string fileId {get;set;}
    public boolean isShowGuide {get;set;}
    public string fileURL {get;set;}
    public List<AttachmentWrapper> AWs {get;set;}
    
    public class AttachmentWrapper {
        public string id {get;set;}
        public string name {get;set;}
        public datetime createddate {get;set;}
        public string link {get;set;}
    }
    
    public CG_UploadFileController(ApexPages.StandardController controller)
    {
        //Initialize  
        filesCountList = new List<SelectOption>() ;
        FileCount = '' ;
        allFileList = new List<Attachment>() ;
        AWs = new List<AttachmentWrapper>();
        
        cgSettingId = controller.getId(); //System.currentPagereference().getParameters().get('id');
        isUploadEnable = true;
        isShowGuide = false;
        MaxUploadFile = 4;
        
        fileURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        CG_Setting__c CGSetting = [select id, type__c from CG_Setting__c where Id =: cgSettingId];
        if(CGSetting.type__c == 'CGManual' || CGSetting.type__c == 'CG Manual') {
            MaxUploadFile = 6;
            
            isShowGuide = true;
        }
        
        MaximumUploadFile = MaxUploadFile;
        
        //Find uploaded file
        existingFiles = AllFiles(cgSettingId);
        
        UploadedSize = 0;
        if(existingFiles.size() > 0) {
            UploadedSize = existingFiles.size();
            
            if(UploadedSize > MaxUploadFile) {
                isUploadEnable = false;
            }
            else {
                MaxUploadFile = MaxUploadFile - UploadedSize;
                
                //Adding values count list - you can change this according to your need
                for(Integer i = 1 ; i <= MaxUploadFile ; i++)
                    filesCountList.add(new SelectOption(''+i , ''+i)) ;
                    
            }
        }
        else {
            //Adding values count list - you can change this according to your need
                for(Integer i = 1 ; i <= MaxUploadFile ; i++)
                    filesCountList.add(new SelectOption(''+i , ''+i)) ;
        }
        
    }
    
    public List<Attachment> AllFiles(string cgSettingId) {
        existingFiles = [select id, parentId, name, createddate from Attachment where ParentId =: cgSettingId];
        if(existingFiles.size() > 0) {
            AWs = new List<AttachmentWrapper>();
            for(Attachment att : existingFiles) {
                AttachmentWrapper AW = new AttachmentWrapper();
                AW.id = att.id;
                AW.name = att.name;
                AW.createddate = att.createddate;
                AW.link = fileURL + '/servlet/servlet.FileDownload?file=' + att.Id;
                AWs.add(AW);
            }
        }
        
        return existingFiles;
    }
    
    public Pagereference SaveAttachments()
    {
        cgSettingId = System.currentPagereference().getParameters().get('id');
        if(cgSettingId == null || cgSettingId == '')
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'No record is associated. Please pass record Id in parameter.'));
        if(FileCount == null || FileCount == '')
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select how many files you want to upload.'));

        List<Attachment> listToInsert = new List<Attachment>() ;
        
        boolean isSameFileName = false;
        
        //Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);
        for(Attachment a: allFileList)
        {
            string sameFileName = '';
            
            //Check whether file with same name exist or not
            if(AWs.size() > 0) {
                for(AttachmentWrapper AW : AWs) {
                    if(AW.name == a.name) {
                        isSameFileName = true;
                        sameFileName = a.name;
                    }
                }
            }
            
            
            if(!isSameFileName) {
                if(a.name != '' && a.name != '' && a.body != null) {
                    listToInsert.add(new Attachment(parentId = cgSettingId, name = a.name, body = a.body)) ;
                }
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Cannot upload same file name ' + sameFileName + '.'));
            }
        }
        
        
        allFileList.clear();
        
        //Inserting attachments
        if(!isSameFileName && listToInsert.size() > 0) {
            insert listToInsert ;
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, listToInsert.size() + ' file(s) are uploaded successfully'));
            FileCount = '' ;
        }
        else if(!isSameFileName && listToInsert.size() == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select at-least one file'));
        }
        
            
        //Check existing Files
        existingFiles = AllFiles(cgSettingId);
        UploadedSize = existingFiles.size();
        
        CG_Setting__c CGSetting = [select id, type__c from CG_Setting__c where Id =: cgSettingId];
        
        if(CGSetting.type__c == 'CGManual') {
            MaxUploadFile = 6;
        }
        
        System.debug('UploadedSize : ' + UploadedSize);
        System.debug('MaxUploadFile : ' + MaxUploadFile);
        
        if(MaxUploadFile < UploadedSize) {
            MaxUploadFile = MaximumUploadFile;
        }
        
        MaxUploadFile = MaxUploadFile - UploadedSize;
        System.debug('MaxUploadFile : ' + MaxUploadFile);
        filesCountList = new List<SelectOption>() ;
        
        for(Integer i = 1 ; i <= MaxUploadFile ; i++)
                    filesCountList.add(new SelectOption(''+i , ''+i)) ;
            
        PageReference PageRef = new PageReference('/'+cgSettingId);
        
        return null;
    }
    
    public PageReference DeleteFile() {
    
        cgSettingId = System.currentPagereference().getParameters().get('id');
        
        Attachment file = [select id from Attachment where Id =: fileId];
        delete(file);
        
        PageReference PageRef = new PageReference('/'+cgSettingId);
        PageRef.setRedirect(true);
        return PageRef;
    }
    
    public PageReference ChangeCount()
    {
        allFileList.clear() ;
        //Adding multiple attachments instance
        
        if(FileCount == null) {
            FileCount = '';
        }
        
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)
            allFileList.add(new Attachment()) ;
        return null ;
    }
}