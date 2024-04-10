@isTest
public with sharing class CTRSharPointFileControllerTest {
    
    @TestSetup
    public static void setUp(){
        Notification__c notification = new Notification__c(Name = '12345678', Notification_Number__c = '12345678');

        insert notification;

        ContentVersion content = new ContentVersion(
            Title = 'TestFile',
            PathOnClient = '/TestFile.jpg',
            VersionData = Blob.valueOf('Unit Test ContentVersion Body'),
            origin = 'H'
        );

        insert content;

        content = [SELECT Id, ContentDocumentId FROM ContentVersion];

        ContentDocumentLink documentLink = new ContentDocumentLink(
            LinkedEntityId = notification.Id,
            ContentDocumentId = content.ContentDocumentId,
            ShareType = 'V'
        );

        insert documentLink;
        
        CTRRequestFormHeader__c reqFormHeader = new CTRRequestFormHeader__c();
        reqFormHeader.Name ='Test Header';
        insert reqFormHeader;
        
 	    CTRRequestFormItem__c  reqFormItem = new CTRRequestFormItem__c();
        reqFormItem.Name ='Test';
        reqFormItem.CTRRequestFormHeader__c = reqFormHeader.Id;
        insert reqFormItem;
    }

    @isTest
    public static void testUploadFileToSharePoint(){
        ContentDocument document =  [SELECT Id, Title FROM ContentDocument WITH SECURITY_ENFORCED LIMIT 1];
        System.Debug('document ---->'+ document);
        ContentVersion content = [SELECT ID FROM ContentVersion LIMIT 1];
        
        Set<Id> mContentDocumentListId = new Set<Id>();
        mContentDocumentListId.add(document.id);

        Test.startTest();
        CTRSharPointFileController.UploadFileToSharePoint('', mContentDocumentListId);
        Test.stopTest();
    }

    @isTest
    public static void testDeleteFileSalesforce(){
        Test.startTest();
        CTRSharPointFileController.deleteFileSalesforce('', '');
        Test.stopTest();
    }

    @isTest
    public static void testDownloadSharePoint(){
        Test.startTest();
        CTRSharPointFileController.DownloadSharePoint('', 'fileName');
        Test.stopTest();
    }

    @isTest
    public static void testDownloadMultipleSharePoint(){
        Test.startTest();
        CTRSharPointFileController.DownloadMultipleSharePoint('', new List<String>{'fileName'});
        Test.stopTest();
    }

    @isTest
    public static void testdeleteSalesforceAttachment(){
        List<Attachment> attmtList = [SELECT Id FROM Attachment LIMIT 1];
        System.Debug('document ---->'+ attmtList);
        
        Test.startTest();
        CTRSharPointFileController.deleteSalesforceAttachment(attmtList);
        Test.stopTest();
    }
    
    @isTest
    public static void testSharepointMetadata(){
        CTRRequestFormItem__c recIdRecord =  [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        
        CTRRequestFormItem__c testRec =  [SELECT name,id FROM CTRRequestFormItem__c LIMIT 1];
        System.debug('testRecord : ');
        System.debug(testRec);
        
        
        Test.startTest();
        CTRSharPointFileController.sharepointMetadata(recIdRecord.Id, new Set<Id>(), '', '');
        Test.stopTest();
    }
    
}