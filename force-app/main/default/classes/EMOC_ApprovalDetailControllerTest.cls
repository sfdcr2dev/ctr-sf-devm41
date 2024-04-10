@isTest
public class EMOC_ApprovalDetailControllerTest {
	@testSetup static void Data() {
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
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Status_Common_Workflow__c = 'Emergency Approval';
        emoc.Common_Workflow__c = true;
        emoc.Functional_Location__c = func.Id;
        emoc.RecordTypeId = recordtype.Id;
        emoc.Change_Type__c = 'Permanent';
        emoc.RAM_Total__c = 'M';
        emoc.Next_Reminder_Date__c = Date.today();
        emoc.Emergency__c = true;
        insert emoc; 
        
        E_MOC_Timeline__c etl = new E_MOC_Timeline__c();
        etl.Status__c = 'Close Out';
        etl.Change_Type__c = 'Permanent';
        etl.RAM_Level__c = 'M';
        etl.Area__c = 'A';
        etl.Day__c = 2;
        insert etl;

    }
    
    static testmethod void testData() {       
        Test.startTest();

        E_MOC_Application__c emoc = [select Id from E_MOC_Application__c limit 1];
        MAP<String, String> searchParam = new MAP<String, String>();

        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('test');
        req.setObjectId(emoc.Id);
        Approval.ProcessResult result = Approval.process(req);
   
        ProcessInstanceWorkitem pItem = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                         FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc.Id LIMIT 1];
        
        searchParam.put('Id', pItem.Id);
        searchParam.put('sobjecttype', 'ProcessInstanceWorkitem');
        EMOC_ApprovalDetailController.getDetailApproval(searchParam);
        
        ProcessInstanceStep ptStep = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc.Id LIMIT 1];
        searchParam.put('Id', ptStep.Id);
        searchParam.put('sobjecttype', 'ProcessInstanceStep');
       	EMOC_ApprovalDetailController.getDetailApproval(searchParam);
        
        Test.stopTest();
    }
}