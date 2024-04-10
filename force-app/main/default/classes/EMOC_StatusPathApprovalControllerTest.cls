@istest
public class EMOC_StatusPathApprovalControllerTest {
    @isTest static void testGetData(){
        E_MOC_Application__c emoc1 = new E_MOC_Application__c();
        emoc1.Status_Common_Workflow__c = 'E-MOC Register';
        emoc1.Temporary__c = true;
        emoc1.Emergency__c = false;
        insert emoc1;
        
        E_MOC_Application__c emoc5 = new E_MOC_Application__c();
        emoc5.Status_Common_Workflow__c = 'Cancelled';
        emoc5.Temporary__c = true;
        emoc5.Emergency__c = false;
        insert emoc5;
        
        E_MOC_Application__c emoc2 = new E_MOC_Application__c();
        emoc2.Status_Common_Workflow__c = 'Rejected';
        emoc2.Temporary__c = false;
        emoc2.Emergency__c = false;
        insert emoc2;
        
        E_MOC_Application__c emoc3 = new E_MOC_Application__c();
        emoc3.Status_Common_Workflow__c = 'Monitoring';
        emoc3.Temporary__c = true;
        emoc3.Emergency__c = true;
        insert emoc3;
        
        E_MOC_Application__c emoc4 = new E_MOC_Application__c();
        emoc4.Status_Common_Workflow__c = 'Emergency Approval';
        emoc4.Temporary__c = false;
        emoc4.Emergency__c = true;
        insert emoc4;

        Test.startTest();

        EMOC_StatusPathApprovalController.getStageNamePath(emoc2.Id);
        EMOC_StatusPathApprovalController.getStageNamePath(emoc1.Id);
        EMOC_StatusPathApprovalController.getStageNamePath(emoc3.Id);
        EMOC_StatusPathApprovalController.getStageNamePath(emoc4.Id);
        EMOC_StatusPathApprovalController.getStageNamePath(emoc5.Id);
        Test.stopTest();
    }
}