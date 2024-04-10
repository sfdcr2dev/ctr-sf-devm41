@isTest
public class THOR_WorkClearancePDFControllerTest {
	@isTest
    static void testWorkClearances() {
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
       	 	PageReference pageRef = ApexPages.currentPage();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', clearance.Id);
        	THOR_WorkClearancePDFController wc = new THOR_WorkClearancePDFController();
        Test.stopTest();
    }
}