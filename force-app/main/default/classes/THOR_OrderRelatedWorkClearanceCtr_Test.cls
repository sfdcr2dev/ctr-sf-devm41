@isTest
public class THOR_OrderRelatedWorkClearanceCtr_Test {
    @isTest
    static void testRelatedWorkClearances() {
        Order__c exampleOrder = new Order__c();
        exampleOrder.Name = 'Example Order Name';
        insert exampleOrder;

        Work_Clearance__c clearance = new Work_Clearance__c();
        clearance.Name = 'Example';
        clearance.Work_Clearance__c = 'Example';
        clearance.Description__c = 'Example Description';
        clearance.Priority__c = '5';
        clearance.order__c = exampleOrder.Id;
        insert clearance;

        Test.startTest();
        /*Map<Id, THOR_RelatedWorkClearanceDTO> result = THOR_OrderRelatedWorkClearanceCtr.getRelatedObjects(
            exampleOrder.Id
        );*/
        Work_Clearance__c result = THOR_OrderRelatedWorkClearanceCtr.getRelatedObjects(
            exampleOrder.Id
        );
        Test.stopTest();

        //System.assertEquals(1, result.size());
    }
}