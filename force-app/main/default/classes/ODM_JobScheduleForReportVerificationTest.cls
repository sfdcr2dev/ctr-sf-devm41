@isTest
public class ODM_JobScheduleForReportVerificationTest {

    public static String CRON_EXP = '0 0 0 31 12 ? 2024';

    @testSetup
    static void makeData(){
        Id RecordTypeIdVeri = Schema.SObjectType.PTW_Header__c.getRecordTypeInfosByName().get('Verification').getRecordTypeId();
        Id RecordTypeIdIns = Schema.SObjectType.PTW_Header__c.getRecordTypeInfosByName().get('Inspection').getRecordTypeId();
        // Id idReport = [SELECT Id FROM RecordType WHERE sObjectType='Report__c '].Id;

        Datetime yesterday = Datetime.now().addDays(-1);

        //User
        User user1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'thaninthon',
            Email = 'thaninthon@thaioilgroup.com',
            Username = 'thaninthon@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Main_Work_Center__c = 'OPS-TOC5'
        );
        insert user1;

        //PISUsers
        PISUsers__c pisUser1 = new PISUsers__c(
            User__c = user1.id,
            SECTIONS__c = 'MFOC'
        );
        insert pisUser1;
        
        //User
        User user2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'thaninthonnn',
            Email = 'thaninthonnn@thaioilgroup.com',
            Username = 'thaninthonnn@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Main_Work_Center__c = 'OPS-TOC3'
        );
        insert user2;

        //PISUsers
        PISUsers__c pisUser2 = new PISUsers__c(
            User__c = user2.id,
            SECTIONS__c = 'MFOP'
        );
        insert pisUser2;

        Work_Clearance__c wc1 = new Work_Clearance__c(
            Name = '9012341234',
            Integration_Status__c = 'Success',
            System_Status__c = 'CRTE',
            User_Status__c = 'WCCL',
            Area__c = 'P1',
            Work_Detail__c = 'Test',
            Safety_Permit1__c = 'Test',
            Safety_Permit2__c = 'Test',
            Safety_Permit3__c = 'Test',
            High_risk_work__c = '1',
            Authorized_Signature_UI__c = pisUser1.id,
            Authorized_Signature__c = '00001185' //Authorized_Signature__c
            // Work_Clearance_Status__c = 'Created;In Progress'
            // CreatedDate = TODAY
        );
        insert wc1;
        // Test.setCreatedDate(wc1.Id, yesterday);

        Work_Clearance__c wc2 = new Work_Clearance__c(
            Name = '9012341236',
            Integration_Status__c = 'Success',
            System_Status__c = 'PREP',
            User_Status__c = 'WCCL',
            Area__c = 'P1',
            Work_Detail__c = 'Test',
            Safety_Permit1__c = 'Test',
            Safety_Permit2__c = 'Test',
            Safety_Permit3__c = 'Test',
            High_risk_work__c = '1',
            Authorized_Signature_UI__c = pisUser2.id,
            Authorized_Signature__c = '00001186'
        );
        insert wc2;
        // Test.setCreatedDate(wc2.Id, yesterday);

        PTW_Question_Master__c ptwMaster = new PTW_Question_Master__c(
            FormName__c = 'Verification',
            Version__c = '1',
            Question__c = 'Status',
            Section__c = '1',
            Order_Question__c = 1,
            Answer_type__c = 'Text',
            Value__c = '',
            Description__c = 'Test',
            IsActive_Report__c = true
        );
        insert ptwMaster;

        // PTW_Header__c ptwHeader = new PTW_Header__c(
        //  FormName__c = 'Verification',
        //     Version__c = '1',
        //     Key__c = 'Key',
        //     Work_Clearance__c = wc1.id,
        //     Status__c = 'Agree   '
        // );
        // insert ptwHeader;

        PTW_Header__c ptwHeader2 = new PTW_Header__c(
            RecordTypeId = RecordTypeIdVeri,
            FormName__c = 'Verification',
            Version__c = '1',
            Key__c = 'Key',
            Work_Clearance__c = wc2.id,
            Status__c = 'Agree'
            // Verification_Name__c= pisUser2.id
        );
        insert ptwHeader2;

    }


    static testmethod void testScheduledJob() {


        Test.startTest();
        String jobId = System.schedule('ODM_JobScheduleForReportVerification',CRON_EXP,new ODM_JobScheduleForReportVerification());
        System.assert(jobId != '', 'Tasks exist before job has run');
        Test.stopTest();
    }
}