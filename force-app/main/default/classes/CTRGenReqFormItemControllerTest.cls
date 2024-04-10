@isTest
public with sharing class CTRGenReqFormItemControllerTest {
    @TestSetup
    static void makeData(){
		CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            InterestedProductCustomer__c = 'Petroleum Products;Lube Base Products;LABIX Products',
            InterestedProductSupplier__c = 'LABIX Products',
            Name = 'TEST'
        );
        insert reqHeader;
    }
    
    @isTest
    public static void testGenReqItem(){
        Test.startTest();
        CTRRequestFormHeader__c recIdRecord =  [SELECT Id FROM CTRRequestFormHeader__c WHERE Name='Test' LIMIT 1];
		List<String> recIds = new List<String>{recIdRecord.Id};
        CTRGenReqFormItemController.genReqItem(recIds);
        Test.stopTest();
    }
}