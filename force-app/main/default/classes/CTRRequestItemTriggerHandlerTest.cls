@isTest
public class CTRRequestItemTriggerHandlerTest {

    @isTest
    static void testBeforeUpdate() {
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

        Test.startTest();
        
        CTRRequestItemTriggerHandler handler = new CTRRequestItemTriggerHandler();
        Map<Id, CTRRequestFormItem__c> oldItemsMap = new Map<Id, CTRRequestFormItem__c>();
        oldItemsMap.put(reqItem.Id, reqItem);
        Map<Id, CTRRequestFormItem__c> newItemsMap = new Map<Id, CTRRequestFormItem__c>();
        newItemsMap.put(reqItem.Id, reqItem);
        handler.beforeUpdate(newItemsMap, oldItemsMap);
        Test.stopTest();

    }

    @isTest
    static void testAfterUpdate() {
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
        Test.startTest();
        
        CTRRequestItemTriggerHandler handler = new CTRRequestItemTriggerHandler();
        Map<Id, CTRRequestFormItem__c> oldItemsMap = new Map<Id, CTRRequestFormItem__c>();
        oldItemsMap.put(reqItem.Id, reqItem);
        Map<Id, CTRRequestFormItem__c> newItemsMap = new Map<Id, CTRRequestFormItem__c>();
        newItemsMap.put(reqItem.Id, reqItem);
        handler.afterUpdate(newItemsMap, oldItemsMap);
        Test.stopTest();

    }
}