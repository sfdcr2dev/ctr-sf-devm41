/**
 * @author Oktana
 * @description test class for PB 'Update Manually Created EQCC'
 */
@isTest
public with sharing class UpdateManuallyCreatedEQCCTest {
    @testSetup
    static void setup() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName
            FROM Checked_Sheet_Pointer__mdt
            WHERE DeveloperName = 'Tank_Gauge_Level_Maintenance_Record'
            LIMIT 1
        ];
        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>();

        List<EQCC_Header__c> headers = new List<EQCC_Header__c>();
        for (Integer i = 0; i < 5; i++) {
            headers.add(new EQCC_Header__c());
        }
        insert headers;

        List<EQCC_Checked_Sheet__c> sheets = new List<EQCC_Checked_Sheet__c>();
        for (Integer i = 0; i < 5; i++) {
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Status__c = Constants.CHECKED_SHEETS.STATUS_APPROVED,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'CODE'
                )
            );
        }
        insert sheets;

        Integer i = 0;
        for (EQCC_Header__c header : headers) {
            headerSheets.add(
                new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheets.get(i).Id, isManuallyCreated__c = true)
            );
            i++;
        }
        insert headerSheets;
    }

    /**
     * @given Manually Created EQCC
     * @when Header is related to an Order
     * @then all EQCC related to the Header should be marked as not Manually Created
     */
    @isTest
    static void testUpdateManuallyCreatedEQCCWhenRelatedToAnOrder() {
        EQCC_Header__c header = getHeader();
        List<Header_Sheet__c> initialManuallyCreated = getManuallyCreatedEQCCFromHeader(header);

        System.assert(!initialManuallyCreated.isEmpty(), 'There should Manually Created EQCC associated to the Header');

        Order__c order = new Order__c(Name = 'Test Order');
        insert order;

        header.Order__c = order.Id;
        Test.startTest();
        update header;
        Test.stopTest();

        List<Header_Sheet__c> finalManuallyCreated = getManuallyCreatedEQCCFromHeader(header);
        System.assert(finalManuallyCreated.isEmpty(), 'No Manually Created EQCC should be related to the Header');
    }

    /**
     * @given Manually Created EQCC
     * @when Header is related to an Notification
     * @then all EQCC related to the Header should be marked as not Manually Created
     */
    @isTest
    static void testUpdateManuallyCreatedEQCCWhenRelatedToAnNotification() {
        EQCC_Header__c header = getHeader();
        List<Header_Sheet__c> initialManuallyCreated = getManuallyCreatedEQCCFromHeader(header);

        System.assert(!initialManuallyCreated.isEmpty(), 'There should Manually Created EQCC associated to the Header');

        Notification__c notification = new Notification__c(Name = 'Test Order');
        insert notification;

        header.Notification__c = notification.Id;
        Test.startTest();
        update header;
        Test.stopTest();

        List<Header_Sheet__c> finalManuallyCreated = getManuallyCreatedEQCCFromHeader(header);
        System.assert(finalManuallyCreated.isEmpty(), 'No Manually Created EQCC should be related to the Header');
    }

    private static EQCC_Header__c getHeader() {
        return [SELECT Id FROM EQCC_Header__c LIMIT 1];
    }

    private static List<Header_Sheet__c> getManuallyCreatedEQCCFromHeader(EQCC_Header__c header) {
        return [
            SELECT Id, Header__c, Sheet__c, isManuallyCreated__c
            FROM Header_Sheet__c
            WHERE
                isManuallyCreated__c = TRUE
                AND Header__r.Notification__c = NULL
                AND Header__r.Order__c = NULL
                AND Header__c = :header.Id
        ];
    }
}