@isTest
public with sharing class THOR_MakeMockData {
    public static void makeMockData() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName, Form_Questions__c 
            FROM Checked_Sheet_Pointer__mdt
            LIMIT 1
        ];

        Order__c mockOrder = new Order__c(Name = 'Test Order', Order_Number__c = '9123450001');
        insert mockOrder;

        Order__c childMockOrder = new Order__c(
            Name='Child Test Order',
            Super_Order__c = mockOrder.Id,
            Order_Number__c = '1234512345'
        );
        insert childMockOrder;

        Notification__c mockNotification = new Notification__c(Name = 'Test Notification', Order__c = mockOrder.Id);
        insert mockNotification;

        List<EQCC_Header__c> mockHeaders = new List<EQCC_Header__c>{
            new EQCC_Header__c(Order__c = mockOrder.Id, Notification__c = mockNotification.Id),
            new EQCC_Header__c()
        };
        insert mockHeaders;

        List<EQCC_Checked_Sheet__c> mockCheckedSheets = new List<EQCC_Checked_Sheet__c>{
            new EQCC_Checked_Sheet__c(
                Name = 'Test Checked Sheet',
               	Form_Questions__c = 10,
                Form_Type__c = formType.DeveloperName,
                Sheet_Code__c = '34523',
                Status__c = 'Done'
          		
            ),
            new EQCC_Checked_Sheet__c(Name = 'Submit for approval',Form_Questions__c = 10, Form_Type__c = formType.DeveloperName),
            new EQCC_Checked_Sheet__c(Name = 'Approve EQCC',Form_Questions__c = 15, Form_Type__c = formType.DeveloperName),
            new EQCC_Checked_Sheet__c(Name = 'Reject EQCC',Form_Questions__c = 20, Form_Type__c = formType.DeveloperName)
        };
            system.debug('===mockCheckedSheets==>'+mockCheckedSheets);
        insert mockCheckedSheets;



        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>{
            new Header_Sheet__c(isManuallyCreated__c = true, Header__c = mockHeaders[0].Id, Sheet__c = mockCheckedSheets[0].Id),
            new Header_Sheet__c(isManuallyCreated__c = true, Header__c = mockHeaders[1].Id, Sheet__c = mockCheckedSheets[1].Id),
            new Header_Sheet__c(isManuallyCreated__c = true, Header__c = mockHeaders[1].Id, Sheet__c = mockCheckedSheets[2].Id),
            new Header_Sheet__c(isManuallyCreated__c = true, Header__c = mockHeaders[1].Id, Sheet__c = mockCheckedSheets[3].Id),
            new Header_Sheet__c(isManuallyCreated__c = true, Header__c = mockHeaders[1].Id, Sheet__c = mockCheckedSheets[3].Id)
        };
        insert headerSheets;

        EQCC_Step__c mockStep = new EQCC_Step__c(
            Name = 'Test Step',
            Step_Number__c = 1,
            Status__c = 'Draft',
            Header_Sheet__c = headerSheets[0].Id,
            //EQCC_Checked_Sheet__c = mockCheckedSheets[0].Id,
            Form_Code__c = 'EQCC-ENRM-001'
        );
        insert mockStep;

        EQCC_Header__c mockHeaderGenerated = new EQCC_Header__c(
            Order__c=childMockOrder.Id
        );
        insert mockHeaderGenerated;

        Header_Sheet__c mockHeaderJuntionGenerated = new Header_Sheet__c(
            Header__c = mockHeaderGenerated.Id,
            isManuallyCreated__c = false,
            Sheet__c = mockCheckedSheets[0].Id
        );
        insert mockHeaderJuntionGenerated;



        // set up a Read Only user so we can test the try/catch exceptions by restricting our access to records
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_tools_runas.htm
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Read Only'];
        User readOnlyUser = new User(
            Alias = 'standt',
            Email = 'ReadOnlyUser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'ReadOnlyUser' + DateTime.now().getTime() + '@testorg.com'
        );
        insert readOnlyUser;

        Work_Clearance__c mockWorkClearance = new Work_Clearance__c(
            Name = 'Test WC',
            Notification__c = mockNotification.Id,
            Order__c = mockOrder.Id
        );
        insert mockWorkClearance;

        // https://salesforce.stackexchange.com/questions/181963/test-class-for-contentdocumentlink
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = mockNotification.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        ContentVersion contentVersion2 = new ContentVersion(
            Title = 'Tigers',
            PathOnClient = 'Tigers.jpg',
            VersionData = Blob.valueOf('Test Content Tigers'),
            IsMajorVersion = true
        );
        insert contentVersion2;
        List<ContentDocument> documents2 = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl2 = new ContentDocumentLink();
        cdl2.LinkedEntityId = mockWorkClearance.Id;
        cdl2.ContentDocumentId = documents2[1].Id;
        cdl2.shareType = 'V';
        insert cdl2;
    }
}