@IsTest
public with sharing class CTRSapInformationControllerTest {
    @TestSetup
    static void makeData(){
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Name = 'Test Item';
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.RecordTypeId = rt.Id;
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Petroleum Products';

        insert reqItem;
    }

    @isTest
    static void testGetSAPInfoData() {
        
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        CTRSapInformationController.SAPInfoData result = CTRSapInformationController.getSAPInfoData(reqItem.Id);

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testSaveReqFormItemAndReqFormHeader() {
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        CTRRequestFormHeader__c reqFormHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        
        Test.startTest();
        CTRSapInformationController.saveReqFormItemAndReqFormHeader(reqItem.Id, reqFormHeader, reqItem);
        Test.stopTest();

        CTRRequestFormItem__c updatedFormItem = [SELECT Id, ChangedSAPInformation__c FROM CTRRequestFormItem__c WHERE Id = :reqItem.Id];
        System.assertEquals(true, updatedFormItem.ChangedSAPInformation__c);
    }

    @isTest
    public static void testConvertedDropdownToOptions() {
        String obj ='CTRRequestFormItem__c';
        String str ='SalesDistrict__c';
        Test.startTest();
        CTRSapInformationController.convertedDropdownToOptions(obj, str);
        Test.stopTest();
    }

    @isTest
    static void testGetSAPInfoDatav2() {
        
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        CTRSapInformationController.SAPInfoData result = CTRSapInformationController.getSAPInfoDatav2(reqItem.Id);

        System.assertNotEquals(null, result);
    }

    /*
    Not found DependentPicklist field
    @isTest
    public static void testGetDependentPicklistValues() {
        String obj ='CTRRequestFormItem__c';
        String controllingField ='SalesDistrict__c';
        String dependentField = '';
        Test.startTest();
        CTRSapInformationController.getDependentPicklistValues(obj, controllingField, dependentField;
        Test.stopTest();
    }
    */

    // @isTest
    // public static void getUserProfileTest() {
    //     Test.startTest();
    //     CTRSapInformationController.getUserProfile();
    //     Test.stopTest();
    // }

    // @isTest
    // public static void getRecordTypeNameTest() {
    //     CTRRequestFormItem__c reqformItem = [SELECT Id FROM CTRRequestFormItem__c WHERE Name ='Test Item'];
    //     Test.startTest();
    //     CTRSapInformationController.getRecordTypeName(reqformItem.Id);
    //     Test.stopTest();
    // }

    // @isTest
    // public static void getIdFormHeaderTest() {
    //     CTRRequestFormItem__c reqformItem = [SELECT Id FROM CTRRequestFormItem__c WHERE Name ='Test Item'];
    //     Test.startTest();
    //     CTRSapInformationController.getIdFormHeader(reqformItem.Id);
    //     Test.stopTest();
    // }

    // @isTest
    // public static void saveReqFormItemAndReqFormHeaderTest() {
    //     CTRRequestFormItem__c reqformItem = [SELECT Id,Name FROM CTRRequestFormItem__c WHERE Name ='Test Item'];
    //     CTRRequestFormHeader__c reqformHeader = [SELECT Id,Name FROM CTRRequestFormHeader__c WHERE Name ='Test Header'];
    //     Test.startTest();
    //     CTRSapInformationController.saveReqFormItemAndReqFormHeader(reqformItem.Id, reqformHeader, reqformItem);
    //     Test.stopTest();
    // }

    // @isTest
    // public static void getCustomerSalesTabTest() {
    //     CTRRequestFormItem__c reqformItem = [SELECT Id,Name FROM CTRRequestFormItem__c WHERE Name ='Test Item'];
    //     Test.startTest();
    //     CTRSapInformationController.getCustomerSalesTab(reqformItem.Id);
    //     Test.stopTest();
    // }

    // @isTest
    // public static void getRequiredHeaderTOPTest() {
    //     CTRRequestFormItem__c reqformItem = [SELECT Id,Name FROM CTRRequestFormItem__c WHERE Name ='Test Item'];
    //     Test.startTest();
    //     CTRSapInformationController.getRequiredHeaderTOP(reqformItem.Id);
    //     Test.stopTest();
    // }

    // @isTest
    // public static void getRequiredHeaderTXTest() {
    //     CTRRequestFormItem__c reqformItem = [SELECT Id,Name FROM CTRRequestFormItem__c WHERE Name ='Test Item'];
    //     Test.startTest();
    //     CTRSapInformationController.getRequiredHeaderTX(reqformItem.Id);
    //     Test.stopTest();
    // }
    
}