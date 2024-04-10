@istest
public class EMOC_StatusPathFnOvrControllerTest {
    @isTest static void testGetData(){
        RecordType recordtype = [SELECT Id FROM RecordType WHERE Name='Functional Override'];
        
        E_MOC_Application__c emoc1 = new E_MOC_Application__c();
        emoc1.RecordTypeId = recordtype.Id;
        emoc1.Status_Functional_Override__c = 'Approval # 1';
        emoc1.OOS__c = true;
        emoc1.MOS_for_ops_purpose__c = false;
        emoc1.Inhibit_for_process_or_Equipment_S_D__c = false;
        emoc1.Inhibit_alarm_for_maintenance__c = false;
        emoc1.Disable_Alarm_by_Ops_for_HW__c= false;
        emoc1.Inhibit_Alarm_request_for_FOX__c= false;
        emoc1.MOS_for_maintenance__c = false; 
        emoc1.Safeguarding_force_signal__c = false;
        insert emoc1;
        
        E_MOC_Application__c emoc2 = new E_MOC_Application__c();
        emoc2.RecordTypeId = recordtype.Id;
        emoc2.Status_Functional_Override__c = 'Create';
        emoc2.OOS__c = false;
        emoc2.MOS_for_ops_purpose__c = false;
        emoc2.Inhibit_for_process_or_Equipment_S_D__c = false;
        emoc2.Inhibit_alarm_for_maintenance__c = false;
        emoc2.Disable_Alarm_by_Ops_for_HW__c= true;
        emoc2.Inhibit_Alarm_request_for_FOX__c= false;
        emoc2.MOS_for_maintenance__c = false; 
        emoc2.Safeguarding_force_signal__c = false;
        insert emoc2;
        
        E_MOC_Application__c emoc3 = new E_MOC_Application__c();
        emoc3.RecordTypeId = recordtype.Id;
        emoc3.Status_Functional_Override__c = 'Rejected';
        emoc3.OOS__c = false;
        emoc3.MOS_for_ops_purpose__c = false;
        emoc3.Inhibit_for_process_or_Equipment_S_D__c = false;
        emoc3.Inhibit_alarm_for_maintenance__c = false;
        emoc3.Disable_Alarm_by_Ops_for_HW__c= false;
        emoc3.Inhibit_Alarm_request_for_FOX__c= false;
        emoc3.MOS_for_maintenance__c = false; 
        emoc3.Safeguarding_force_signal__c = true;
        insert emoc3;
        
        E_MOC_Application__c emoc4 = new E_MOC_Application__c();
        emoc4.RecordTypeId = recordtype.Id;
        emoc4.Status_Functional_Override__c = 'Rejected';
        emoc4.OOS__c = false;
        emoc4.MOS_for_ops_purpose__c = true;
        emoc4.Inhibit_for_process_or_Equipment_S_D__c = false;
        emoc4.Inhibit_alarm_for_maintenance__c = false;
        emoc4.Disable_Alarm_by_Ops_for_HW__c= false;
        emoc4.Inhibit_Alarm_request_for_FOX__c= false;
        emoc4.MOS_for_maintenance__c = false; 
        emoc4.Safeguarding_force_signal__c = false;
        insert emoc4;
        
        Test.startTest();
        
        EMOC_StatusPathFnOvrController.getStageNamePath(emoc3.Id);
        EMOC_StatusPathFnOvrController.getStageNamePath(emoc4.Id);
        EMOC_StatusPathFnOvrController.getStageNamePath(emoc1.Id);
        EMOC_StatusPathFnOvrController.getStageNamePath(emoc2.Id);
        
        Test.stopTest();
    }
}