@isTest
public class CTRBlockRequestFormItemModelDataTest {

    @isTest
    static void testSetupJsonForBlockDataModel() {
        Account customer = new Account(
            Name='test',
            AccountNumber__c='510001'
        );
        insert customer;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            CustomerSubject__c = '',
            CustomerMessage__c = '',
            CustomerEmailTo__c = 'testuser@test.com',
            CustomerEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id,
            Customer__c = customer.Id
        );
        insert reqItem;

        String viewName = 'Sample View Name';
        String businessUnit = 'TOP';
        String gatewayId = 'Gateway ID';

        Test.startTest();
        
        CTRBlockRequestFormItemModelData result = CTRBlockRequestFormItemModelData.SetupJsonForBlockDataModel(reqHeader, reqItem, viewName, businessUnit, gatewayId);
        
        System.assertEquals(result.input.input.GatewayId, 'Gateway ID');
        Test.stopTest();
    }
}