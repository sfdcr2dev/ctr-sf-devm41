@isTest
public with sharing class CTRApprovalDetailControllerTest {

    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        insert acc;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name ='R2 Solutions. Co.,Ltd.';
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.Email__c = 'testmockemail@gmail.com';
        insert reqItem;

        CTRConfig__c customSetting = new CTRConfig__c();
        customSetting.CreditRating__c ='https://thor-api.thaioilgroup.com/openxml-credit-score/api/CreditRating';
        insert customSetting;
    }

    @IsTest 
    public static void CTRDownloadExcelTemplateTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());
        CTRApprovalDetailController.CTRDownloadExcelTemplate(record.Id);
        Test.stopTest();
    }

    @IsTest 
    public static void getRequestFormItemTest(){
        CTRRequestFormItem__c recordId = [SELECT Id FROM CTRRequestFormItem__c WHERE Email__c='testmockemail@gmail.com'];
        Test.startTest();
        CTRApprovalDetailController.getRequestFormItem(recordId.Id);
        Test.stopTest();
    }

    @IsTest 
    public static void getResultsTest(){
        String ObjectName = 'CTRRequestFormItem__c';
        String fieldName = 'Email__c'; 
        String value ='testmockemail@gmail.com';
        Test.startTest();
        CTRApprovalDetailController.getResults(ObjectName, fieldName, value);
        Test.stopTest();
    }
}