/**
 * ORTLRiskTest used to test all methods in ORTLRiskCtrl and ORTLRiskAssmntCtrl
 * class. These class used to perform create/edit risk, initial/final risk
 * and sending email to notify related users.
 */
@isTest
public class ORTLRiskTest {

	/**
	 * Inititial data before run each test method.
	 * Create sameple risk records that are required for testing.
	 */
	@Testsetup
	public static void setupData() {

		// Create user
		String uniqueUserName1 = 'standarduser' + DateTime.now().getTime() + '@thaioilgroup.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		User u1 = new User(
			Alias = 'standt1',
			Email = 'standarduser1@thaioilgroup.com',
			LastName = 'Testing',
			ProfileId = p.Id,
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'Asia/Bangkok',
			Username = uniqueUserName1
		);
		insert u1;

		// Create user
		String uniqueUserName2 = 'standarduser' + DateTime.now().getTime() + '@thaioilgroup.com';
		User u2 = new User(
			Alias = 'standt2',
			Email = 'standarduser2@thaioilgroup.com',
			LastName = 'Testing',
			ProfileId = p.Id,
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'Asia/Bangkok',
			Username = uniqueUserName2
		);
		insert u2;

		// Get user
		User u = [SELECT id,Name FROM User WHERE id =: userInfo.getUserId()];

		// Create Contact
		Contact c = new Contact();
		c.FirstName = 'lastnameTest';
		c.LastName = 'firstnameTest';
		c.Phone = '0000000000';
		insert c;
		//c.Email = 'moke.k@roundtwosolutions.com	'

		// Main Work Center
		Master_Map__c mwc1 = new Master_Map__c();
		mwc1.Name = 'ENMA-I';
		insert mwc1;

		Master_Map__c mwc2 = new Master_Map__c();
		mwc2.Name = 'MECH-OP';
		insert mwc2;

		Master_Map__c plantSection = new Master_Map__c();
		plantSection.Name = 'T1';
		plantSection.Type__c = 'Plant Section';
		insert plantSection;

		// Create Functional Location
		Functional_Location__c fl = new Functional_Location__c();
		fl.Name = 'Test FL';
		fl.MainWorkCenter__c = mwc1.Id;
		insert fl;

		Functional_Location__c fl2 = new Functional_Location__c();
		fl2.Name = 'Test FL 2';
		fl2.MainWorkCenter__c = mwc2.Id;
		insert fl2;

		// Get Functional Location
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

		/** Create ORTLRisk__c*/
		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		risk.APU__c = 'A';
		insert risk;
		ORTLRisk__c riskRecord = [SELECT Id FROM ORTLRisk__c LIMIT 1];

		/** Create ORTLAction__c */
		//List<ORTLAction__c> actionList = new List<ORTLAction__c>();
		ORTLAction__c action = new ORTLAction__c();
		//action.TaskDescription__c = 'Test';
		action.TaskType__c = 'Assessment';
		action.TagNo__c = flRecords.Id;
		action.Risk__c = riskRecord.Id;
		action.TaskStatus__c = 'In Progress';
		action.DueDate__c = Date.today();
		//actionList.add(action);

		// Insert Action List;
		insert action;
		//System.debug('actionList=>'+actionList);

		// Insert ORTLRelevantUser__c
		List<ORTLRelevantUser__c> relavantUserList = new List<ORTLRelevantUser__c>();
		ORTLRelevantUser__c relavantUser = new ORTLRelevantUser__c();
		relavantUser.RelevantUser__c = u.Id;
		relavantUser.ActionNumber__c = action.Id;
		relavantUserList.add(relavantUser);
		insert relavantUserList;
	}

	/**
	 * Test method used to test getRiskAssessmentSelectOptions method on ORTLRiskAssmntCtrl
	 */
	@isTest
	public static void testGetRiskAssessmentSelectOptions() {
		Test.startTest();
		Map<String, List<Map<String, String>>> selectOptions = ORTLRiskAssmntCtrl.getRiskAssessmentSelectOptions();
		Test.stopTest();

		System.assertEquals(true, selectOptions.containsKey('InitialRiskConsequence'));
		System.assertEquals(true, selectOptions.containsKey('InitialSeverity'));
		System.assertEquals(true, selectOptions.containsKey('InitialLikelihood'));
		System.assertEquals(true, selectOptions.containsKey('FinalRiskConsequence'));
		System.assertEquals(true, selectOptions.containsKey('FinalSeverity'));
		System.assertEquals(true, selectOptions.containsKey('FinalLikelihood'));
	}

	/**
	 * Test method used to test getRiskAssessmentCustomMetadata method on ORTLRiskAssmntCtrl
	 */
	@isTest
	public static void testGetRiskAssessmentCustomMetadata() {
		Test.startTest();
		Map<String, List<Object>> selectOptions = ORTLRiskAssmntCtrl.getRiskAssessmentCustomMetadata();
		Test.stopTest();

		System.assertEquals(true, selectOptions.containsKey('ConsequenceDescription'));
		System.assertEquals(true, selectOptions.containsKey('RiskLevel'));
		System.assertEquals(true, selectOptions.containsKey('LikelihoodCaption'));
	}

	/**
	 * Test method used to test sendEmailRiskRegistered method on ORTLRiskCtrl
	 * And test beforeInsert/afterInsert method on ORTLRiskTriggerHandler
	 */
	@isTest
	public static void testCreateRisk() {
		Test.startTest();
		Functional_Location__c flRecords = [ SELECT Id FROM Functional_Location__c WHERE Name = 'Test FL' LIMIT 1 ];

		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		insert risk;
		Test.stopTest();
		System.assert(risk.Id != null);
	}

	/**
	 * Test method used to test updateRisk method on ORTLRiskAssmntCtrl.
	 * And test beforeUpdate/afterUpdate method on ORTLRiskTriggerHandler.
	 */
	@isTest
	public static void testUpdateRisk() {
		Test.startTest();
		Functional_Location__c flRecords = [ SELECT Id FROM Functional_Location__c WHERE Name = 'Test FL' LIMIT 1 ];

		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.RiskInitiator__c = UserInfo.getUserId();
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		insert risk;

		// Create Functional Location 1
		Functional_Location__c fl1 = new Functional_Location__c();
		fl1.Name = 'Test FL 1';
		insert fl1;

		// Create Functional Location 2
		Functional_Location__c fl2 = new Functional_Location__c();
		fl2.Name = 'Test FL 2';
		insert fl2;

		List<String> tagNoList = new List<String>();
		tagNoList.add(fl1.Id);
		tagNoList.add(fl2.Id);

		//risk.RiskScenario__c = 'Test Update Risk Scenario';
		risk.DEM__c = 'Yes';
		ORTLRiskAssmntCtrl.updateRisk(risk, tagNoList);

		Test.stopTest();
		System.assert(risk.Id != null);
	}

	/**
	 * Test method used to test beforeDelete/afterDelete method on ORTLRiskTriggerHandler.
	 */
	@isTest
	public static void testDeleteRisk() {
		Test.startTest();
		ORTLRisk__c riskRecord = [SELECT Id FROM ORTLRisk__c LIMIT 1];
		delete riskRecord;
		Test.stopTest();
	}

	/**
	 * Test method used to test updateInitialRiskAssessment method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testUpdateInitialRisk() {
		Test.startTest();
		Functional_Location__c flRecords = [ SELECT Id FROM Functional_Location__c WHERE Name = 'Test FL' LIMIT 1 ];

		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		insert risk;

		risk.InitialRisk__c = 'H';
		risk.IntRiskCons__c = 'People';
		risk.Threat__c = 'Process Safety, LOPC';
		risk.IntConsEffect__c = 'Other';
		risk.IntlLikelihood__c = 'C';
		risk.InitialSeverity__c = '5';
		risk.InitialValueUSD__c = 300000;
		risk.RiskStatus__c = 'Awaiting Final Assessment';

		// User
		User u1 = [SELECT id,Name FROM User WHERE Alias = 'standt1'];
		User u2 = [SELECT id,Name FROM User WHERE Alias = 'standt2'];

		// Create Attendees
		ORTLAttendee__c attendee1 = new ORTLAttendee__c();
		attendee1.AttendeeName__c = u1.Id;
		ORTLAttendee__c attendee2 = new ORTLAttendee__c();
		attendee2.AttendeeName__c = u2.Id;
		ORTLAttendee__c attendee3 = new ORTLAttendee__c();
		attendee3.AttendeeName__c = null;

		List<ORTLAttendee__c> attendees1 = new List<ORTLAttendee__c>();
		attendees1.add(attendee1);
		attendees1.add(attendee2);
		attendees1.add(attendee3);

		ORTLRiskAssmntCtrl.updateInitialRiskAssessment(risk, attendees1, new List<ORTLAttendee__c>());

		attendee1.AttendeeName__c = u2.Id;

		List<ORTLAttendee__c> attendees2 = new List<ORTLAttendee__c>();
		attendees2.add(attendee2);
		List<ORTLAttendee__c> delAttendees1 = new List<ORTLAttendee__c>();
		delAttendees1.add(attendee1);

		ORTLRiskAssmntCtrl.updateInitialRiskAssessment(risk, attendees2, delAttendees1);

		Test.stopTest();
		System.assert(risk.Id != null);
	}

	/**
	 * Test method used to test updateFinalRiskAssessment method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testUpdateFinalRisk() {
		Test.startTest();
		Functional_Location__c flRecords = [ SELECT Id FROM Functional_Location__c WHERE Name = 'Test FL' LIMIT 1 ];

		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		insert risk;

		risk.FinalRisk__c = 'H';
		risk.FinRiskCons__c = 'People';
		risk.Threat__c = 'Process Safety, LOPC';
		risk.FinConsEffect__c = 'Other';
		risk.FinalLikelihood__c = 'C';
		risk.FinalSeverity__c = '5';
		risk.FinalValueUSD__c = 300000;
		risk.RiskStatus__c = 'Closed';

		// User
		User u1 = [SELECT id,Name FROM User WHERE Alias = 'standt1'];
		User u2 = [SELECT id,Name FROM User WHERE Alias = 'standt2'];

		// Action
		ORTLAction__c action = new ORTLAction__c();
		//action.TaskDescription__c = 'Test';
		action.TaskType__c = 'Assessment';
		action.TagNo__c = flRecords.Id;
		action.Risk__c = risk.Id;
		action.TaskStatus__c = 'Done';
		action.DueDate__c = Date.today();
		insert action;

		// Action Relevant User
		ORTLRelevantUser__c relUser = new ORTLRelevantUser__c();
		relUser.RelevantUser__c = u1.Id;
		relUser.ActionNumber__c = action.Id;
		List<ORTLRelevantUser__c> relUsers = new List<ORTLRelevantUser__c>();
		relUsers.add(relUser);
		insert relUsers;

		// Create Attendees
		ORTLAttendee__c attendee1 = new ORTLAttendee__c();
		attendee1.AttendeeName__c = u1.Id;
		ORTLAttendee__c attendee2 = new ORTLAttendee__c();
		attendee2.AttendeeName__c = u2.Id;
		ORTLAttendee__c attendee3 = new ORTLAttendee__c();
		attendee3.AttendeeName__c = null;

		List<ORTLAttendee__c> attendees1 = new List<ORTLAttendee__c>();
		attendees1.add(attendee1);
		attendees1.add(attendee2);
		attendees1.add(attendee3);
		ORTLRiskAssmntCtrl.updateFinalRiskAssessment(risk, attendees1, new List<ORTLAttendee__c>());

		attendee1.AttendeeName__c = u2.Id;

		List<ORTLAttendee__c> attendees2 = new List<ORTLAttendee__c>();
		attendees2.add(attendee2);
		List<ORTLAttendee__c> delAttendees1 = new List<ORTLAttendee__c>();
		delAttendees1.add(attendee1);

		ORTLRiskAssmntCtrl.updateFinalRiskAssessment(risk, attendees2, delAttendees1);

		Test.stopTest();
		System.assert(risk.Id != null);
	}

	/**
	 * Test method used to test getAttendees method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testGetAttendees() {
		Test.startTest();
		Functional_Location__c flRecords = [ SELECT Id FROM Functional_Location__c WHERE Name = 'Test FL' LIMIT 1 ];

		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		insert risk;

		risk.FinalRisk__c = 'H';
		risk.FinRiskCons__c = 'People';
		risk.Threat__c = 'Process Safety, LOPC';
		risk.FinConsEffect__c = 'Other';
		risk.FinalLikelihood__c = 'C';
		risk.FinalSeverity__c = '5';
		risk.FinalValueUSD__c = 300000;

		// User
		User u1 = [SELECT id,Name FROM User WHERE Alias = 'standt1'];
		User u2 = [SELECT id,Name FROM User WHERE Alias = 'standt2'];

		// Create Attendees
		ORTLAttendee__c attendee1 = new ORTLAttendee__c();
		attendee1.AttendeeName__c = u1.Id;
		ORTLAttendee__c attendee2 = new ORTLAttendee__c();
		attendee2.AttendeeName__c = u2.Id;

		List<ORTLAttendee__c> attendees = new List<ORTLAttendee__c>();
		attendees.add(attendee1);
		attendees.add(attendee2);

		ORTLRiskAssmntCtrl.updateFinalRiskAssessment(risk, attendees, new List<ORTLAttendee__c>());
		List<ORTLAttendee__c> resultAttendees = ORTLRiskAssmntCtrl.getAttendees(risk);

		Test.stopTest();
		System.assertEquals(2, resultAttendees.size());
	}

	/**
	 * Test method used to test getActions method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testGetActions() {
		Test.startTest();
		ORTLRisk__c risk = [SELECT Id FROM ORTLRisk__c LIMIT 1];
		List<ORTLAction__c> actions = ORTLRiskAssmntCtrl.getActions(risk);

		Test.stopTest();
		System.assertEquals(1, actions.size());
	}

	/**
	 * Test method used to test getOrtlAdmins method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testGetOrtlAdmins() {
		Test.startTest();
		List<PermissionSetAssignment> ortlAdmins = ORTLRiskAssmntCtrl.getOrtlAdmins();
		Test.stopTest();
	}

	/**
	 * Test method used to test getFunctionLocationDetail method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testGetFunctionLocationDetail() {
		Test.startTest();
		Functional_Location__c flRecords = [ SELECT Id FROM Functional_Location__c WHERE Name = 'Test FL' LIMIT 1 ];
		Object fl = ORTLRiskAssmntCtrl.getFunctionLocationDetail(flRecords.Id);
		Test.stopTest();
		System.assert(fl != null);
	}

	/**
	 * Test method used to test getRelatedRisk method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testGetRelatedRisk() {
		Test.startTest();
		ORTLRisk__c riskRecord = [SELECT Id FROM ORTLRisk__c LIMIT 1];

		Functional_Location__c flRecords = [ SELECT Id FROM Functional_Location__c WHERE Name = 'Test FL' LIMIT 1 ];

		ORTLRisk__c risk = new ORTLRisk__c();
		risk.TagNo__c = flRecords.Id;
		risk.AssessmentType__c = 'PRA (Potential Risk Assessment)';
		insert risk;
		risk.OriginalRisk__c = riskRecord.Id;
		risk.CheckApplicable__c = true;
		update risk;

		List<ORTLRisk__c> relatedRisks = ORTLRiskAssmntCtrl.getRelatedRisk(riskRecord);
		Test.stopTest();
		System.assertEquals(1, relatedRisks.size());
	}

	/**
	 * Test method used to test renameUploadedFile method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testUploadFile() {
		Test.startTest();
		ORTLRisk__c riskRecord = [SELECT Id FROM ORTLRisk__c LIMIT 1];

		ContentVersion content = new ContentVersion();
		content.Title = 'vscode';
		content.PathOnClient=content.Title;
		Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body');
		content.VersionData = bodyBlob;
		content.origin = 'C';
		insert content;

		String docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: content.id].ContentDocumentId;
		ContentDocumentLink contentlink = new ContentDocumentLink();
		contentlink.LinkedEntityId = riskRecord.id;
		contentlink.ContentDocumentId = docId;
		contentlink.ShareType = 'V';
		contentlink.Visibility = 'AllUsers';
		insert contentlink;

		ORTLRiskAssmntCtrl.renameUploadedFile(riskRecord, docId, 'RenameUploadFile');
		List<ContentDocumentLink> attachments = ORTLRiskAssmntCtrl.getContentDocumentLinks(riskRecord);

		Test.stopTest();
		System.assertEquals(1, attachments.size());
	}

	/**
	 * Test method used to test canEditOwner method on ORTLRiskAssmntCtrl.
	 */
	@isTest
	public static void testCanEditOwner() {
		Test.startTest();
		ORTLRisk__c riskRecord = [SELECT Id FROM ORTLRisk__c LIMIT 1];
		Boolean canEditOwner = ORTLRiskAssmntCtrl.canEditOwner(riskRecord);
		System.assertEquals(true, canEditOwner);
		Test.stopTest();
	}
}