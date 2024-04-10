/* 
 * Author : Softever
*/
@isTest
public with sharing class CG_UploadFileController_Test {

    public static testMethod void CGUploadFile() {
        
        RecordType RT = [select id, developername from RecordType where developername = 'CG_Manual' AND sobjectType = 'CG_Setting__c'];
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = system.today();
        CGSetting.End_Date__c = system.today();
        CGSetting.Type__c = 'New CG Manual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        PageReference pageRef = Page.CG_Setting_Import_File;
        pageRef.getParameters().put('Id',CGSetting.Id);        
        Test.setCurrentPage(PageRef);
        
        test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(CGSetting);                         
        CG_UploadFileController CGUploadFile = new CG_UploadFileController(sc); 
        
        Attachment attach = new Attachment();       
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = CGSetting.id;
        insert attach;
        
        CGUploadFile.cgSettingId = CGSetting.Id;
        CGUploadFile.SaveAttachments();
        CGUploadFile.FileCount = '1';
        CGUploadFile.ChangeCount();
        CGUploadFile.fileId = attach.Id;
        CGUploadFile.DeleteFile();
        
        test.stopTest();
    }
    
}