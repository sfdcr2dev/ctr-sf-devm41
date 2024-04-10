@istest
public class EMOC_ApprovalControllerTest {
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
        
        RecordType recordtype2 = [SELECT Id, Name FROM RecordType WHERE Name='Functional Override'];
        
        E_MOC_Application__c emoc2 = new E_MOC_Application__c();
        emoc2.Status_Functional_Override__c = 'Approval #3 (VP)';
        emoc2.Status_Common_Workflow__c = 'Emergency Approval';
        emoc2.Functional_Override__c = true;
        emoc2.Functional_Location__c = func.Id;
        emoc2.RecordTypeId = recordtype2.Id;
        emoc2.Change_Type__c = 'Permanent';
        emoc2.RAM_Total__c = 'M';
        emoc2.Next_Reminder_Date__c = Date.today();
        emoc2.Emergency__c = true;
        insert emoc2; 
        
        E_MOC_Timeline__c etl2 = new E_MOC_Timeline__c();
        etl2.Status__c = 'Concept Approval';
        etl2.Change_Type__c = 'Permanent';
        etl2.RAM_Level__c = 'M';
        etl2.Area__c = 'A';
        etl2.Day__c = 1;
        etl2.Step__c = emoc2.Status_Functional_Override__c;
        insert etl2; 
        
        E_MOC_Application__c emoc3 = new E_MOC_Application__c();
        emoc3.Status_Functional_Override__c = 'Risk assessment';
        emoc3.Status_Common_Workflow__c = 'Emergency Approval';
        emoc3.Functional_Override__c = true;
        emoc3.Functional_Location__c = func.Id;
        emoc3.RecordTypeId = recordtype2.Id;
        emoc3.Change_Type__c = 'Permanent';
        emoc3.RAM_Total__c = 'M';
        emoc3.Next_Reminder_Date__c = Date.today();
        emoc3.Emergency__c = true;
        insert emoc3; 
        
        E_MOC_Timeline__c etl3 = new E_MOC_Timeline__c();
        etl3.Status__c = 'Risk assessment';
        etl3.Change_Type__c = 'Permanent';
        etl3.RAM_Level__c = 'M';
        etl3.Area__c = 'A';
        etl3.Day__c = 1;
        //   etl3.Step__c = emoc3.Status_Functional_Override__c;
        insert etl3;
        
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
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('test');
        req.setObjectId(emoc.Id);
        Approval.ProcessResult result = Approval.process(req);
        
        ProcessInstanceWorkitem pItem = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                         FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc.Id LIMIT 1];
        
        EMOC_ApprovalController.getDetailApproval(pItem.Id,'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem.Id, 'test', 'Hold', 'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem.Id, 'test', 'Approve', 'ProcessInstanceWorkItem');
        
        ProcessInstanceStep ptStep = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc.Id LIMIT 1];
        EMOC_ApprovalController.getDetailApproval(ptStep.Id,'ProcessInstanceStep');
        
        /*4*/
        
        Approval.ProcessSubmitRequest req4 = new Approval.ProcessSubmitRequest();
        req4.setComments('test4');
        req4.setObjectId(emoc4.Id);
        Approval.ProcessResult result4 = Approval.process(req4);
        
        ProcessInstanceWorkitem pItem4 = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                          FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc4.Id LIMIT 1];
        
        EMOC_ApprovalController.getDetailApproval(pItem4.Id,'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem4.Id, 'test4', 'Hold', 'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem4.Id, 'test4', 'Removed', 'ProcessInstanceWorkItem');
        
        ProcessInstanceStep ptStep4 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc4.Id LIMIT 1];
        EMOC_ApprovalController.getDetailApproval(ptStep4.Id,'ProcessInstanceStep');
        
        
        Test.stopTest();
    }
    
    @isTest static void testGetData2(){
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
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Status_Common_Workflow__c = 'Close Out';
        emoc.Common_Workflow__c = true;
        emoc.Functional_Location__c = func.Id;
        emoc.RecordTypeId = recordtype.Id;
        emoc.Change_Type__c = 'Permanent';
        emoc.RAM_Total__c = 'M';
        emoc.Next_Reminder_Date__c = Date.today();
        emoc.Emergency__c = true;
        emoc.Step__c = 'Concept Approval';
        insert emoc; 
        
        E_MOC_Timeline__c etl = new E_MOC_Timeline__c();
        etl.Status__c = 'Close Out';
        etl.Change_Type__c = 'Permanent';
        etl.RAM_Level__c = 'M';
        etl.Area__c = 'A';
        etl.Day__c = 2;
        etl.Step__c = 'Concept Approval';
        insert etl;
        
        RecordType recordtype2 = [SELECT Id, Name FROM RecordType WHERE Name='Functional Override'];
        
        E_MOC_Application__c emoc2 = new E_MOC_Application__c();
        emoc2.Status_Functional_Override__c = 'Approval #3 (VP)';
        emoc2.Functional_Override__c = true;
        emoc2.Functional_Location__c = func.Id;
        emoc2.RecordTypeId = recordtype2.Id;
        emoc2.Change_Type__c = 'Permanent';
        emoc2.RAM_Total__c = 'M';
        emoc2.Next_Reminder_Date__c = Date.today();
        emoc2.Emergency__c = true;
        insert emoc2; 
        
        E_MOC_Application__c emoc3 = new E_MOC_Application__c();
        emoc3.Status_Functional_Override__c = 'Risk assessment';
        emoc3.Status_Common_Workflow__c = 'Emergency Approval';
        emoc3.Functional_Override__c = true;
        emoc3.Functional_Location__c = func.Id;
        emoc3.RecordTypeId = recordtype2.Id;
        emoc3.Change_Type__c = 'Permanent';
        emoc3.RAM_Total__c = 'M';
        emoc3.Next_Reminder_Date__c = Date.today();
        emoc3.Emergency__c = true;
        insert emoc3; 
        
        E_MOC_Application__c emoc5 = new E_MOC_Application__c();
        emoc5.Status_Functional_Override__c = 'Technical review';
        emoc5.Status_Common_Workflow__c = 'Emergency Approval';
        emoc5.Functional_Override__c = true;
        emoc5.Functional_Location__c = func.Id;
        emoc5.RecordTypeId = recordtype2.Id;
        emoc5.Change_Type__c = 'Permanent';
        emoc5.RAM_Total__c = 'M';
        emoc5.Next_Reminder_Date__c = Date.today();
        emoc5.Emergency__c = true;
        insert emoc5; 
        
        E_MOC_Application__c emoc6 = new E_MOC_Application__c();
        emoc6.Status_Functional_Override__c = 'Approval #2';
        emoc6.Status_Common_Workflow__c = 'Emergency Approval';
        emoc6.Functional_Override__c = true;
        emoc6.Functional_Location__c = func.Id;
        emoc6.RecordTypeId = recordtype2.Id;
        emoc6.Change_Type__c = 'Permanent';
        emoc6.RAM_Total__c = 'M';
        emoc6.Next_Reminder_Date__c = Date.today();
        emoc6.Emergency__c = true;
        insert emoc6;
        
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setComments('test2');
        req2.setObjectId(emoc2.Id);
        Approval.ProcessResult result2 = Approval.process(req2);
        
        List<ProcessInstanceWorkitem> workItem = [SELECT Id,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem];
        
        ProcessInstanceStep ptStep2 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc2.Id LIMIT 1];
        EMOC_ApprovalController.getDetailApproval(ptStep2.Id,'ProcessInstanceStep');
        
        /*3*/
        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
        req3.setComments('test3');
        req3.setObjectId(emoc3.Id);
        Approval.ProcessResult result3 = Approval.process(req3);
        
        ProcessInstanceWorkitem pItem3 = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                          FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc3.Id LIMIT 1];
        
        EMOC_ApprovalController.getDetailApproval(pItem3.Id,'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem3.Id, 'test3', 'Hold', 'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem3.Id, 'test3', 'Removed', 'ProcessInstanceWorkItem');
        
        ProcessInstanceStep ptStep3 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc3.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(ptStep3.Id, 'test3', 'Removed', 'ProcessInstanceStep');
        EMOC_ApprovalController.getDetailApproval(ptStep3.Id,'ProcessInstanceStep');
        
        /*5*/
        Approval.ProcessSubmitRequest req5 = new Approval.ProcessSubmitRequest();
        req5.setComments('test5');
        req5.setObjectId(emoc5.Id);
        Approval.ProcessResult result5 = Approval.process(req5);
        
        ProcessInstanceWorkitem pItem5 = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                          FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc5.Id LIMIT 1];
        
        EMOC_ApprovalController.getDetailApproval(pItem5.Id,'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem5.Id, 'test5', 'Hold', 'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem5.Id, 'test5', 'Approve', 'ProcessInstanceWorkItem');
        
        ProcessInstanceStep ptStep5 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc5.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(ptStep5.Id, 'test5', 'Approve', 'ProcessInstanceStep');
        EMOC_ApprovalController.getDetailApproval(ptStep5.Id,'ProcessInstanceStep');
        
        /*6*/
        Approval.ProcessSubmitRequest req6 = new Approval.ProcessSubmitRequest();
        req6.setComments('test6');
        req6.setObjectId(emoc6.Id);
        Approval.ProcessResult result6 = Approval.process(req6);
        
        ProcessInstanceWorkitem pItem6 = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                          FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc6.Id LIMIT 1];
        
        EMOC_ApprovalController.getDetailApproval(pItem6.Id,'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem6.Id, 'test6', 'Hold', 'ProcessInstanceWorkItem');
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem6.Id, 'test6', 'Approve', 'ProcessInstanceWorkItem');
        
        ProcessInstanceStep ptStep6 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc6.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(ptStep6.Id, 'test6', 'Approve', 'ProcessInstanceStep');
        EMOC_ApprovalController.getDetailApproval(ptStep6.Id,'ProcessInstanceStep');
        
        
        Test.stopTest();
    }
    
    @isTest static void testGetData3(){
        
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
        
        RecordType recordtype2 = [SELECT Id, Name FROM RecordType WHERE Name='Functional Override'];
        
        E_MOC_Application__c emoc7 = new E_MOC_Application__c();
        emoc7.Status_Functional_Override__c = 'Technical review';
        emoc7.Status_Common_Workflow__c = 'Emergency Approval';
        emoc7.Functional_Override__c = true;
        emoc7.Functional_Location__c = func.Id;
        emoc7.RecordTypeId = recordtype2.Id;
        emoc7.Change_Type__c = 'Permanent';
        emoc7.RAM_Total__c = 'M';
        emoc7.Next_Reminder_Date__c = Date.today();
        emoc7.Emergency__c = true;
        insert emoc7; 
        
        E_MOC_Application__c emoc8 = new E_MOC_Application__c();
        emoc8.Status_Functional_Override__c = 'Approval #3 (APU)';
        emoc8.Status_Common_Workflow__c = 'Emergency Approval';
        emoc8.Functional_Override__c = true;
        emoc8.Functional_Location__c = func.Id;
        emoc8.RecordTypeId = recordtype2.Id;
        emoc8.Change_Type__c = 'Permanent';
        emoc8.RAM_Total__c = 'M';
        emoc8.Next_Reminder_Date__c = Date.today();
        emoc8.Emergency__c = true;
        insert emoc8; 
        
        E_MOC_Application__c emoc9 = new E_MOC_Application__c();
        emoc9.Status_Functional_Override__c = 'Approval #3 (VP)';
        emoc9.Status_Common_Workflow__c = 'Emergency Approval';
        emoc9.Functional_Override__c = true;
        emoc9.Functional_Location__c = func.Id;
        emoc9.RecordTypeId = recordtype2.Id;
        emoc9.Change_Type__c = 'Permanent';
        emoc9.RAM_Total__c = 'M';
        emoc9.Next_Reminder_Date__c = Date.today();
        emoc9.Emergency__c = true;
        insert emoc9; 
        
        Approval.ProcessSubmitRequest req7 = new Approval.ProcessSubmitRequest();
        req7.setComments('test7');
        req7.setObjectId(emoc7.Id);
        Approval.ProcessResult result7 = Approval.process(req7);
        
        ProcessInstanceWorkitem pItem7 = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                          FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc7.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem7.Id, 'test7', 'Removed', 'ProcessInstanceWorkItem');
        
        ProcessInstanceStep ptStep7 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc7.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(ptStep7.Id, 'test7', 'Removed', 'ProcessInstanceStep');
        
        Approval.ProcessSubmitRequest req8 = new Approval.ProcessSubmitRequest();
        req8.setComments('test8');
        req8.setObjectId(emoc8.Id);
        Approval.ProcessResult result8 = Approval.process(req8);
        
        ProcessInstanceWorkitem pItem8 = [SELECT Id,ActorId,Actor.Name,ElapsedTimeInHours, ProcessInstance.TargetObjectId,ProcessInstance.TargetObject.Name 
                                          FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: emoc8.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(pItem8.Id, 'test8', 'Removed', 'ProcessInstanceWorkItem');
        
        ProcessInstanceStep ptStep8 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc8.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(ptStep8.Id, 'test8', 'Removed', 'ProcessInstanceStep');
        
        Approval.ProcessSubmitRequest req9 = new Approval.ProcessSubmitRequest();
        req9.setComments('test9');
        req9.setObjectId(emoc9.Id);
        Approval.ProcessResult result9 = Approval.process(req9);
                
        ProcessInstanceStep ptStep9 = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId  =:emoc9.Id LIMIT 1];
        
        EMOC_ApprovalController.callApprovedOrRejectProcess(ptStep9.Id, 'test9', 'Removed', 'ProcessInstanceStep');
        
        MAP<String, String> paramAutomationTask = new MAP<String, String>();
        paramAutomationTask.put('emocId', String.valueOf(emoc9.Id));
        paramAutomationTask.put('statusCommonWorkflow', 'Concept Approval');
        paramAutomationTask.put('originalActorId',String.valueOf(UserInfo.getUserId()));
        
        EMOC_ApprovalController.callAutomationTask(paramAutomationTask);
        
        MAP<String, String> paramAutomationTask2 = new MAP<String, String>();
        paramAutomationTask2.put('emocId', String.valueOf(emoc8.Id));
        paramAutomationTask2.put('statusCommonWorkflow', 'Budget Registration');
        paramAutomationTask2.put('originalActorId',String.valueOf(UserInfo.getUserId()));
        
        EMOC_ApprovalController.callAutomationTask(paramAutomationTask2);
        
        Test.stopTest();
    }
    
}