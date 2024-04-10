@isTest
public with sharing class CTRLeadOverideNewControllerTest {
    @TestSetup
    static void makeData(){
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'Lead' AND DeveloperName = 'TOP' limit 1];
        Lead newLead = new Lead();
        newLead.RecordTypeId = rt.Id;
        newLead.Status = 'New Lead';
        newLead.FirstName = 'Test FirstName';
        newLead.LastName = 'Test LastName';
        newLead.Company = 'Test Company';
        newLead.RegisteredasCustomer__c = true;
        insert newLead;
    }
    
    @IsTest 
    static void getRecordTypeNameTest(){
        Test.startTest();
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'Lead' AND DeveloperName = 'TOP' limit 1];
        CTRLeadOverideNewController.getRecordTypeName(rt.Id);
        Test.stopTest();
    }    
    @IsTest 
    static void getRecordTypeNameByRecordId(){
        Lead dataLead = [SELECT Id FROM Lead WHERE FirstName = 'Test FirstName'];
        Test.startTest();
        CTRLeadOverideNewController.getRecordTypeNameByRecordId(dataLead.Id);
        Test.stopTest();
    }
    @IsTest 
    static void getTOPTypeTest(){
        Test.startTest();
        CTRLeadOverideNewController.getTOPType();
        Test.stopTest();
    }

    @IsTest 
    static void testViewDuplicate(){
        Test.startTest();
        List<Lead> leadList = CTRLeadOverideNewController.viewDuplicate('firstName','company','','');
        Test.stopTest();
    }
}