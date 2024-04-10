@isTest
public without sharing class CTRFlowEmailReminderTest {

    @testSetup
    public static void setup() {
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            EmailPageSubject__c = 'Test',
            EmailPageMessage__c = 'Test',
            EmailPageEmailTo__c = 'testuser@test.com',
            EmailPageEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id,
            EmailTo__c = 'testuser@test.com',
            EmailCC__c = 'testuser@test.com',
            Subject__c = 'Test Subject',
            Message__c = 'Test message'
        );
        
        insert reqItem;
        CTREmailTemplateMaster__c emailTemp = new CTREmailTemplateMaster__c(
            Subject__c = 'Subject',
            HTMLBody__c = '<p><span style="font-size: 13px;">Dear All,</span></p><p><br></p><p><span style="font-size: 13px;"> We would like to inform that {$AccountName$} was Approved by Commitee-CMVP with the following condition.</span></p><p><span style="font-size: 13px;"> Company Name: {$AccountName$}</span></p><p><span style="font-size: 13px;"> Interested to be: Customer: {$ProductName$}</span></p><p><span style="font-size: 13px;"> Credit Condition: {$Credit_Condition$}: {$PaymentCondition$}</span></p><p><br></p><p><span style="font-size: 13px;"> Please see the details and proceed via this link.</span></p><p><br></p><p><span style="font-size: 13px;">Best Regards,</span></p><p><span style="font-size: 13px;">Conterparties Registration Automated System</span></p><p><span style="font-size: 13px;">This is an automatic generated email. Please do not reply to this address.</span></p>',
            Type__c = 'Request More Document TOP'
        );
        insert emailTemp;

        String base64Data = EncodingUtil.urlDecode('YWJj', 'UTF-8');
        Blob fileBody = EncodingUtil.base64Decode(base64Data);
        ContentVersion contentVersion = new ContentVersion (
            ContentLocation = 'S',
            PathOnClient = 'T006-P4.png',
            Title = 'T006-P4.png',
            VersionData = EncodingUtil.base64Decode(base64Data)
        );
        insert contentVersion;

        ContentVersion queriedContentVersion = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :contentVersion.Id
            LIMIT 1
        ];

        ContentDocumentLink contentLink = new ContentDocumentLink(
            ContentDocumentId = queriedContentVersion.ContentDocumentId,
            LinkedEntityId = reqItem.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert contentLink;
       
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.test',
            Username = 'testuser@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        CTRCommitteeApproval__c comApp = new CTRCommitteeApproval__c(
            ApprovalDate__c =  date.today(),
            ApproverName__c = testUser.id,
            ApprovalResult__c = 'Submit to Committee',
            Remark__c = 'Approved'
        );
        insert comApp;
        
        CTRCommitteeApproval__c comApp2 = new CTRCommitteeApproval__c(
            ApprovalDate__c =  date.today(),
            ApproverName__c = testUser.id,
            ApprovalResult__c = 'Approved',
            Remark__c = 'Approved',
            CTRRequestFormItem__c = reqItem.Id
        );
        insert comApp2;
    }
    
    @isTest
    public static void testSendEmail(){
        Test.startTest();
        CTRRequestFormItem__c recData = [SELECT Id,Name,Subject__c,EmailTo__c,EmailCC__c FROM CTRRequestFormItem__c LIMIT 1];
        CTRRequestFormItem__c reqFormObj = recData;
        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        List<CTRCommitteeApproval__c> newCommApprs = [SELECT Id,ApproverName__c,ApprovalResult__c,ApprovalDate__c,Remark__c,CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE ApprovalResult__c = 'Submit to Committee'];

        String uploadedList = 'T006-P4.png';
        String profile = Json.serialize(testProfile);
        List<String> emailToList = new List<String>{'testuser@test.com'};

        CTRFlowEmailReminder.FlowInputs fi = new CTRFlowEmailReminder.FlowInputs();
        fi.recordId = recData.Id;
        fi.reqFormObj = recData;
        fi.newCommApprs = newCommApprs;
        fi.profile = profile;
        fi.uploadedList = uploadedList;
        fi.templateType = 'Committee TOP';
        
        CTRFlowEmailReminder.sendEmail(new List<CTRFlowEmailReminder.FlowInputs>{fi});

        fi.templateType = 'Committee TX';
        CTRFlowEmailReminder.sendEmail(new List<CTRFlowEmailReminder.FlowInputs>{fi});

        fi.templateType = 'Committee LABIX';
        CTRFlowEmailReminder.sendEmail(new List<CTRFlowEmailReminder.FlowInputs>{fi});
        
        Test.stopTest();
    }
    
    @isTest
    public static void testNotifyUsers(){
        Test.startTest();
        
        CTRRequestFormItem__c recData = [SELECT Id,Name,Subject__c,EmailTo__c,EmailCC__c FROM CTRRequestFormItem__c LIMIT 1];
        CTRRequestFormItem__c reqFormObj = recData;
        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        List<CTRCommitteeApproval__c> newComps = [SELECT Id,ApproverName__c,ApprovalResult__c,ApprovalDate__c,Remark__c FROM CTRCommitteeApproval__c WHERE ApprovalResult__c = 'Approved'];
            
        CTRFlowEmailReminder.notifyUsers(recData,newComps,'TOP');
        CTRFlowEmailReminder.notifyUsers(recData,newComps,'TX');

        Test.stopTest();
    }
}