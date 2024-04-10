@istest
public class EMOC_ApprovalHistoryControllerTest {
    @isTest static void testGetData(){
        Test.startTest();
        
        Master_Map__c mapMas1 = new Master_Map__c();
        mapMas1.Name = 'CR01';
        insert mapMas1;

        Master_Map__c mapMas2 = new Master_Map__c();
        mapMas2.Name = 'CR02';
        insert mapMas2;
        
        Functional_Location__c func = new Functional_Location__c();
        func.Name = 'Test Functional Location';
        func.Description__c = 'TEST';
       	func.MainWorkCenter__c = mapMas1.Id;
        func.mainWorkCenterPlant__c = mapMas1.Id;
        func.Mainworkcenter_type__c = 'MECH';
        insert func;
        
        RecordType recordtype = [SELECT Id FROM RecordType WHERE Name='Common Workflow'];
        RecordType recordtype2 = [SELECT Id, Name FROM RecordType WHERE Name='Functional Override'];
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Status_Common_Workflow__c = 'Concept Approval';
        emoc.Common_Workflow__c = true;
        emoc.Functional_Location__c = func.Id;
        emoc.Change_Type__c = 'Permanent';
        emoc.RAM_Total__c = 'M';
        emoc.Next_Reminder_Date__c = Date.today();
        emoc.Emergency__c = true;
        emoc.Functional_Location__c = func.Id;
        emoc.Step__c = 'Concept Approval';
        emoc.RecordTypeId = recordtype.Id;
        insert emoc; 
        
        E_MOC_Application__c emoc4 = new E_MOC_Application__c();
        emoc4.Status_Functional_Override__c = 'Technical review';
        emoc4.Status_Common_Workflow__c = 'Emergency Approval';
        emoc4.Functional_Override__c = true;
        emoc4.Functional_Location__c = func.Id;
        emoc4.RecordTypeId = recordtype2.Id;
        emoc4.Change_Type__c = 'Permanent';
        emoc4.RAM_Total__c = 'M';
        emoc4.Next_Reminder_Date__c = Date.today();
        emoc4.Emergency__c = true;
        insert emoc4; 
        
        E_MOC_Timeline__c et4 = new E_MOC_Timeline__c();
        et4.Status__c = 'Technical review';
        et4.Change_Type__c = 'Permanent';
        et4.RAM_Level__c = 'M';
        et4.Area__c = 'A';
        et4.Day__c = 1;
        insert et4;
        
        E_MOC_Application__c emoc2 = new E_MOC_Application__c();
        emoc2.Common_Workflow__c = true;
        emoc2.Status_Common_Workflow__c = 'APU Approval';
        emoc2.Functional_Location__c = func.Id;
        insert emoc2;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('test');
        req.setObjectId(emoc.Id);
        Approval.ProcessResult result = Approval.process(req);
        
        Approval.ProcessSubmitRequest req4 = new Approval.ProcessSubmitRequest();
        req4.setComments('test4');
        req4.setObjectId(emoc4.Id);
        Approval.ProcessResult result4 = Approval.process(req4);
        
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setComments('test2');
        req2.setObjectId(emoc2.Id);
        Approval.ProcessResult result2 = Approval.process(req2);
        
        EMOC_ApprovalHistoryController.getOpportunityApprovalHistory(emoc2.Id);
        
        EMOC_ApprovalHistoryController.getOpportunityApprovalHistory(emoc.Id);
		EMOC_ApprovalHistoryController.getOpportunityApprovalHistory(emoc4.Id);
        Test.stopTest();
    }
}