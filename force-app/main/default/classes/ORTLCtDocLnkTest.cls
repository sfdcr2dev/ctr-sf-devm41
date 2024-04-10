/**
 * ORTLCtDocLnkTest used to test each method in ORTLCtDocLnkCtrl class,
 * ContentDocumentLinkTriggerHandler class and ContentDocumentLink trigger.
 * Test class trigger event upload and delete files in order to verify
 * an upload attachments on risk/action records.
 */
@isTest
public class ORTLCtDocLnkTest {

	/**
	 * Inititial data before run each test method.
	 * Create sameple risk and action records that are required for testing.
	 */
	@Testsetup
	public static void setupData() {

		// Create a account record.
		Account accA = new Account(Name = 'nameTest');
		insert accA;

		// Create a contact record.
		Contact conA = new Contact(LastName = 'lastnameTest',Phone = '0980980987');
		insert conA;

		// Get an user.
		User u = [SELECT id,Name FROM User WHERE id =: userInfo.getUserId()];

		// Create a functional location record.
		Functional_Location__c fl = new Functional_Location__c();
		fl.Name = 'Test FL';
		insert fl;

		// Create a risk record.
		ORTLRisk__c risk1 = new ORTLRisk__c();
		risk1.TagNo__c = fl.Id;
		risk1.RiskStatus__c = 'New';
		risk1.RiskInitiator__c = u.id;
		risk1.InitiativeDate__c = Date.today();
		risk1.AssessmentType__c = 'RRA (Reactive Risk Assessment)';
		risk1.OriginalRisk__c = null;
		//risk1.RiskScenario__c = 'TEST';
		//risk1.RiskScenarioDes__c = 'TEST';
		risk1.EnRiskMgt__c = 'Yes';
		risk1.DEM__c = 'Yes';
		risk1.ApptootherEQP__c = true;
		risk1.Causeoffailure__c = 'TEST';
		risk1.OwnerId = u.id;
		risk1.Threat__c = 'Equipment Frequent Failures';
		risk1.IntConsEffect__c = '"Bad Actor" Incident';
		insert risk1;

		// Create an action record.
		ORTLAction__c action = new ORTLAction__c(Name = 'Test', Risk__c = risk1.Id, TaskType__c  = 'Implementation', TagNo__c = risk1.TagNo__c);
		insert action;

		// Perform upload file to the action record.
		// Create a content version record.
		ContentVersion version = new ContentVersion();
		version.Title = 'vscode';
		version.PathOnClient = version.Title;
		version.VersionData = Blob.valueOf('Unit Test ContentVersion Body');
		version.origin = 'C';
		insert version;

		// Perform upload file to the action record.
		// Create a content document link record to link to the action.
		ContentDocumentLink contentlink = new ContentDocumentLink();
		contentlink.LinkedEntityId = action.id;
		contentlink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: version.Id].ContentDocumentId;
		contentlink.ShareType = 'V';
		contentlink.Visibility = 'AllUsers';
		insert contentlink;
	}

	/**
	 * Testing for delete action attachments.
	 */
	@isTest
	static void testDeleteContentDocumentLink(){
		Test.startTest();
		ORTLAction__c action = [SELECT Id FROM ORTLAction__c WHERE Name = 'Test'];
		ContentDocumentLink contentLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :action.Id];

		delete contentLink;
		delete [SELECT Id FROM ContentDocument WHERE Id = :contentLink.ContentDocumentId];
		Test.stopTest();
	}

	/**
	 * Test method perform update an ContentDocumentLink record.
	 * This event does not related to ORTL but requires for the other project conditions.
	 */
	@isTest
	static void testUpdateContentDocumentLink(){
		Test.startTest();
		ORTLAction__c action = [SELECT Id FROM ORTLAction__c WHERE Name = 'Test'];
		ContentDocumentLink contentLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :action.Id];

		contentLink.Visibility  = 'AllUsers';
		update contentLink;
		Test.stopTest();
	}
}