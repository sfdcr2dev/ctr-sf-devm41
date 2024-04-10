/**
 * ORTLActionTest used to test each method in ORTLActionCtrl
 * By the way Set up data or make some data like a real case
 * then call each method to test, if any method must have a parameter
 * you can query record and pass to those parameter,but they have to same type
 */
@isTest
public class ORTLActionTest {

	public static String CRON_EXP = '02 0 0 31 12 ? 2024';

	/**Set up data that like a real case */
	@Testsetup
	public static void setupData(){

		System.debug('--setupData--');

		/**User Object */
		User u = [SELECT id,Name,Email FROM User WHERE id =: userInfo.getUserId()];
		System.debug('User=>'+u);

		/**Contact Object */
		Contact cnt = new Contact();
		cnt.FirstName = 'lastnameTest';
		cnt.LastName = 'firstnameTest';
		cnt.Phone = '0000000000';
		cnt.Email = 'setUpData@gmail.com';
		insert cnt;

		/**Functional Location Object */
		Functional_Location__c fl = new Functional_Location__c();
		fl.Name = 'Test FL';
		insert fl;
		System.debug('fl=>'+fl);
		Functional_Location__c flRecords = [ SELECT
													Id,
													Name,
													Description__c,
													Planning_Plant__c,
													MainWorkCenter__c,
													mainWorkCenterPlant__c,
													mainWorkCenterPlant__r.Name,
													MainWorkCenter__r.Name,
													MainWorkCenter__r.Code__c,
													Location__c,
													PlantSection__c
												FROM Functional_Location__c
												WHERE Name = 'Test FL'
												LIMIT 1
											];

		/** Risk Object*/
		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		insert risk;

		ORTLRisk__c riskRecord = [SELECT Id FROM ORTLRisk__c LIMIT 1];

		/**Action Object */
		ORTLAction__c action = new ORTLAction__c();
		//action.TaskDescription__c = 'Test';
		action.TaskType__c = 'Assessment';
		action.TagNo__c = flRecords.Id;
		action.Risk__c = riskRecord.Id;
		action.TaskStatus__c = 'In Progress';
		action.DueDate__c = Date.today() + 1;
		insert action;
		System.debug('action=>'+action);

		/**Action Object */
		ORTLAction__c action2 = new ORTLAction__c();
		//action2.TaskDescription__c = 'action2';
		action2.TaskType__c = 'Assessment';
		action2.TagNo__c = flRecords.Id;
		action2.Risk__c = riskRecord.Id;
		action2.TaskStatus__c = 'In Progress';
		action2.DueDate__c = Date.today() + 7;
		insert action2;

		/**Relavant User Object */
		List<ORTLRelevantUser__c> relavantUserList = new List<ORTLRelevantUser__c>();
		ORTLRelevantUser__c relavantUser = new ORTLRelevantUser__c();
		relavantUser.RelevantUser__c = u.Id;
		relavantUser.ActionNumber__c = action2.Id;
		relavantUserList.add(relavantUser);
		insert relavantUserList;
		System.debug('relavantUserList=>'+relavantUserList);
	}

	/**testSendEmailCreateAction Method used to test sendEmailActionCreated method on ORTLActionCtrl */
	@isTest
	public static void testSendEmailCreateAction(){
		ORTLAction__c action = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, TaskType__c, Notification__c, Risk__c, ReduceLLH__c, TagNo__c, MitigateCons__c, Plant__c, APU__c, TaskStatus__c,/* RiskScenario__c,*/ TaskOwner__c, TaskInitiator__c, InitialDate__c, DueDate__c, CloseDate__c, TaskCopyOwner__c, IsOwner__c, CancelReason__c, Objective__c, PlantSection__c, Section__c, txtTagNo__c FROM ORTLAction__c LIMIT 1];

		Test.startTest();
		ORTLActionCtrl.sendEmailActionCreated(new List<ORTLAction__c>{ action });
		Test.stopTest();
	}

	/**testCancelAction Method used to test cancelAction and sendEmailActionCanceled method on ORTLActionCtrl */
	@isTest
	public static void testCancelAction(){
		System.debug('--testCancelAction--');
		ORTLAction__c actionId = [SELECT Id,Name FROM ORTLAction__c LIMIT 1 ];

		Test.startTest();
		String actionTest = (String) ORTLActionCtrl.cancelAction(actionId.Id,'Test Reason');
		Test.stopTest();
		System.assert(actionTest != null,'Not Expect Data');
	}

	/** testActionName Method used to test getActionName method on ORTLActionCtrl */
	@isTest
	public static void testActionName(){
		System.debug('--testActionName--');
		ORTLAction__c actionId = [SELECT Id,Name FROM ORTLAction__c LIMIT 1 ];

		Test.startTest();
		ORTLAction__c actionTest = (ORTLAction__c) ORTLActionCtrl.getActionName(actionId.Id);
		Test.stopTest();
		System.assert(actionTest != null,'Not Expect Data');
	}

	/** testActionOwner Method used to test getActionOwner method on ORTLActionCtrl */
	@isTest
	public static void testActionOwner(){
		ORTLAction__c action = [SELECT Id, Name, OwnerId FROM ORTLAction__c LIMIT 1 ];

		Test.startTest();
		String ownerId = ORTLActionCtrl.getActionOwner(action.Id);
		Test.stopTest();
		System.assertEquals(action.OwnerId, ownerId);
	}

	/** testRelevantUsers Method used to test getRelevantUsers method on ORTLActionCtrl */
	@isTest
	public static void testRelevantUsers(){
		System.debug('--testRelevantUsers--');
		ORTLAction__c actionId = [SELECT Id,Name FROM ORTLAction__c LIMIT 1 ];

		Test.startTest();
		List<ORTLRelevantUser__c> actionTest = (List<ORTLRelevantUser__c>) ORTLActionCtrl.getRelevantUsers(actionId.Id);
		Test.stopTest();
		System.assert(actionTest != null,'Not Expect Data');
	}

	/** testUpdateRelevantUsers Method used to test updateRelevantUsers method on ORTLActionCtrl */
	@isTest
	public static void testUpdateRelevantUsers(){
		System.debug('--testUpdateRelevantUsers--');
		ORTLAction__c actionId = [SELECT Id,Name FROM ORTLAction__c LIMIT 1 ];

		List<ORTLRelevantUser__c> relavantUser = [SELECT Id,RelevantUser__c FROM ORTLRelevantUser__c];
		List<ORTLRelevantUser__c> relavantUserId = [SELECT Id FROM ORTLRelevantUser__c];

		Test.startTest();
		List<ORTLRelevantUser__c> actionTestAddRelavantUser = (List<ORTLRelevantUser__c>) ORTLActionCtrl.updateRelevantUsers(actionId.Id,relavantUser,relavantUser);
		Test.stopTest();
		System.assert(actionTestAddRelavantUser != null,'Not Expect Data');
	}

	/** testDueDateChanged Method used to test sendEmailActionDueDateChanged method on ORTLActionCtrl */
	@isTest
	public static void testDueDateChanged(){
		System.debug('--testDueDateChanged--');
		Test.startTest();
		ORTLAction__c actionId = [SELECT Id,Name,Risk__c,TaskStatus__c,TagNo__c,TaskType__c,DueDate__c FROM ORTLAction__c LIMIT 1 ];
		actionId.DueDate__c = Date.today()-1;
		update actionId;
		Test.stopTest();
	}

	/** testStatusIsDone Method used to test sendEmailActionClosed method on ORTLActionCtrl */
	@isTest
	public static void testStatusIsDone(){
		System.debug('--testStatusIsDone--');
		Test.startTest();
		ORTLAction__c actionId = [SELECT Id,Name,Risk__c,TaskStatus__c,TagNo__c,TaskType__c,DueDate__c FROM ORTLAction__c LIMIT 1 ];
		actionId.TaskStatus__c = 'Done';
		update actionId;
		Test.stopTest();
	}

	/** testApplogFailed Method used to test Fail Case */
	@isTest
	public static void testApplogFailed(){
		System.debug('--testStatusIsDoneFailed--');
		Test.startTest();
		ORTLAction__c actionId = [SELECT Id,Name,Risk__c,TaskStatus__c,TagNo__c,TaskType__c,DueDate__c FROM ORTLAction__c LIMIT 1 ];
		actionId.TaskStatus__c = 'Canceled';
		actionId.DueDate__c = Date.today()+5;
		actionId.CancelReason__c = 'test input character more than 255 ';

		update actionId;
		System.debug('actionId =>'+ actionId);
		Test.stopTest();
	}

	/** testDeleteAction Method used to test when delete record */
	@isTest
	public static void testDeleteAction() {
		Test.startTest();
		List<ORTLAction__c> action = [SELECT Id,Name FROM ORTLAction__c];
		delete action;
		List<ORTLAction__c> actionAfterDeleted = [SELECT Id,Name FROM ORTLAction__c];
		System.assertEquals(0, actionAfterDeleted.size());
		Test.stopTest();
	}

	/** testAboutDueDate1DayLeft Method used to test sendEmailActionAboutDueDate 1 day left method on ORTLActionCtrl */
	@isTest
	public static void testAboutDueDate1DayLeft(){
		System.debug('--testAboutDueDate1DayLeft--');
		Test.startTest();
		// ORTLAction__c actionId = [SELECT Id,Name,Risk__c,TaskStatus__c,TagNo__c,TaskType__c,DueDate__c,(SELECT Id, RelevantUser__r.Email FROM RelevantUser__r) FROM ORTLAction__c WHERE TaskDescription__c = 'action2' AND TaskStatus__c = 'In Progress' LIMIT 1 ];
		// actionId.DueDate__c = Date.today()+1;
		// //actionId.RelevantUser__r = 'setUpData@gmail.com';
		// update actionId;

		ORTLActionCtrl.sendEmailActionAboutDueDate(null);
		Test.stopTest();
	}

	// /** testAboutDueDate7DayLeft Method used to test sendEmailActionAboutDueDate 7 day left method on ORTLActionCtrl */
	// @isTest
	// public static void testAboutDueDate7DayLeft(){
	// 	System.debug('--testAboutDueDate7DayLeft--');
	// 	Test.startTest();
	// 	ORTLAction__c actionId = [SELECT Id,Name,Risk__c,TaskStatus__c,TagNo__c,TaskType__c,DueDate__c FROM ORTLAction__c LIMIT 1 ];
	// 	actionId.DueDate__c = Date.today()+7;
	// 	update actionId;

	// 	ORTLActionCtrl.sendEmailActionAboutDueDate(null);
	// 	Test.stopTest();
	// }

	/** testScheduledJob Method used to test when ShceduleJob Run */
	static testmethod void testScheduledJob() {

		Test.startTest();
		String jobId = System.schedule('ORTLActionDueDateJob',CRON_EXP,new ORTLActionDueDateJob());
		System.assert(jobId != '', 'Tasks exist before job has run');
		Test.stopTest();
	}

	/**
	 * Test method used to test canCancelOwner method on ORTLActionCtrl.
	 */
	@isTest
	public static void testCanCancelOwner() {
		Test.startTest();
		ORTLAction__c action = [SELECT Id FROM ORTLAction__c LIMIT 1];
		Boolean canCancelAction = ORTLActionCtrl.canCancelOwner(action);
		System.assertEquals(true, canCancelAction);
		Test.stopTest();
	}

	/**
	 * Test method used to test canEditAction method on ORTLAction.
	 */
	@isTest
	public static void testCanEditAction() {
		Test.startTest();
		ORTLAction__c actionRecord = [SELECT Id FROM ORTLAction__c LIMIT 1];
		Boolean canEditAction = ORTLActionCtrl.canEditAction(actionRecord);
		System.assertEquals(true, canEditAction);
		Test.stopTest();
	}

}