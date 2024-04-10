/**
 * @author Oktana
 * @description test class for CauseHandler
 */
@isTest
public with sharing class CauseHandlerTest {
    /**
     * @given a new Cause
     * @when the Cause is inserted
     * @then Cause_No__c and ItemCause__c should be autopopulated
     */
    @isTest
    static void testPopulateCauseNoAndItemCause() {
        Notification__c notification = new Notification__c(Name = '12345678');
        insert notification;
        Item__c item = new Item__c(Notification__c = notification.Id, Item_No__c = '1');
        insert item;

        Cause__c cause = new Cause__c(Notification__c = notification.Id, Item__c = item.Id, Text__c = 'Cause');
        Test.startTest();
        insert cause;
        Test.stopTest();

        Cause__c updatedCause = getCauseById(cause.Id);

        System.assertEquals('1', updatedCause.Cause_No__c, 'Cause_No__c should have been autopopulated');

        System.assertEquals(
            notification.Id +
            item.Item_No__c +
            '1',
            updatedCause.Notification__c +
            updatedCause.Item__r.Item_No__c +
            updatedCause.Cause_No__c,
            'ItemCause__c should have been autopopulated'
        );
    }

    /**
     * @given existing Causes
     * @when a new Cause is inserted
     * @then Cause_No__c and ItemCause__c should be autopopulated
     */
    @isTest
    static void testPopulateCauseNoAndItemCauseWithExistingCauses() {
        Notification__c notification = new Notification__c(Name = '12345678');
        insert notification;
        Item__c item = new Item__c(Notification__c = notification.Id, Item_No__c = '1');
        insert item;

        List<Cause__c> causes = new List<Cause__c>();
        for (Integer i = 0; i < 5; i++) {
            causes.add(new Cause__c(Notification__c = notification.Id, Item__c = item.Id, Text__c = 'Cause' + i));
        }
        insert causes;

        Cause__c cause = new Cause__c(Notification__c = notification.Id, Item__c = item.Id, Text__c = 'Cause');
        Test.startTest();
        insert cause;
        Test.stopTest();

        Cause__c updatedCause = getCauseById(cause.Id);

        System.assertEquals('6', updatedCause.Cause_No__c, 'Cause_No__c should have been autopopulated');

        System.assertEquals(
            notification.Id +
            item.Item_No__c +
            '6',
            updatedCause.Notification__c +
            updatedCause.Item__r.Item_No__c +
            updatedCause.Cause_No__c,
            'ItemCause__c should have been autopopulated'
        );
    }

    private static Cause__c getCauseById(Id causeId) {
        return [
            SELECT Id, Notification__c, Item__r.Item_No__c, Cause_No__c, ItemCause__c
            FROM Cause__c
            WHERE Id = :causeId
        ];
    }
}