/**
 * ORTL Risk Controller, the apex controller class for the following aura components:
 * 1. ORTLInitRisk (Initial Risk Assessment Modal)
 * 2. ORTLFinalRisk (Final Risk Assessment Modal)
 * 3. ORTLInitRiskLv (Initial Risk UI (Record Page))
 * 4. ORTLFinalRiskLv (Final Risk UI (Record Page))
 * 5. ORTLRiskAssmnt (Risk Table Modal)
 */
public class ORTLRiskAssmntCtrl {

	/**
	 * This method return all picklist values of all risk fields in a single request.
	 * The picklist values used to make a Risk Table Header such as Consequece, Severity and Likelihood.
	 */
	@AuraEnabled
	public static Map<String, List<Map<String, String>>> getRiskAssessmentSelectOptions() {
		// For Storing all picklist values to return.
		map<String, List<Map<String, String>>> picklist = new Map<String, List<Map<String, String>>>();

		// Get picklist values of field IntRiskCons__c (Initial Consequence) of ORTLRisk__c (Risk).
		List<Map<String, String>> initialConsequences = new List<Map<String, String>>();
		List<Schema.PicklistEntry> initialConsequencePicklist = ORTLRisk__c.IntRiskCons__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : initialConsequencePicklist) {
			initialConsequences.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}
		// Get picklist values of field IntConsEffect__c (Initial Consequence Effect) of ORTLRisk__c (Risk).
		List<Map<String, String>> initialConsequenceEffects = new List<Map<String, String>>();
		List<Schema.PicklistEntry> initialConsequenceEffectPicklist = ORTLRisk__c.IntConsEffect__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : initialConsequenceEffectPicklist) {
			initialConsequenceEffects.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}
		// Get picklist values of field InitialSeverity__c (Initial Severity) of ORTLRisk__c (Risk).
		List<Map<String, String>> initialSeverities = new List<Map<String, String>>();
		List<Schema.PicklistEntry> initialSeverityPicklist = ORTLRisk__c.InitialSeverity__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : initialSeverityPicklist) {
			initialSeverities.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}
		// Get picklist values of field IntlLikelihood__c (Initial Likelihood) of ORTLRisk__c (Risk).
		List<Map<String, String>> initialLikelihoods = new List<Map<String, String>>();
		List<Schema.PicklistEntry> initialLikelihoodPicklist = ORTLRisk__c.IntlLikelihood__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : initialLikelihoodPicklist) {
			initialLikelihoods.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}

		// Put all picklist values to result list.
		picklist.put('InitialRiskConsequence', initialConsequences);
		picklist.put('InitialRiskConsequenceEffect', initialConsequenceEffects);
		picklist.put('InitialSeverity', initialSeverities);
		picklist.put('InitialLikelihood', initialLikelihoods);

		// Get picklist values of field FinRiskCons__c (Final Consequence) of ORTLRisk__c (Risk).
		List<Map<String, String>> finalConsequences = new List<Map<String, String>>();
		List<Schema.PicklistEntry> finalConsequencePicklist = ORTLRisk__c.FinRiskCons__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : finalConsequencePicklist) {
			finalConsequences.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}
		// Get picklist values of field FinConsEffect__c (Final Consequence Effect) of ORTLRisk__c (Risk).
		List<Map<String, String>> finalConsequenceEffects = new List<Map<String, String>>();
		List<Schema.PicklistEntry> finalConsequenceEffectPicklist = ORTLRisk__c.FinConsEffect__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : finalConsequenceEffectPicklist) {
			finalConsequenceEffects.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}
		// Get picklist values of field FinalSeverity__c (Final Severity) of ORTLRisk__c (Risk).
		List<Map<String, String>> finalSeverities = new List<Map<String, String>>();
		List<Schema.PicklistEntry> finalSeverityPicklist = ORTLRisk__c.FinalSeverity__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : finalSeverityPicklist) {
			finalSeverities.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}
		// Get picklist values of field FinalLikelihood__c (Final Likelihood) of ORTLRisk__c (Risk).
		List<Map<String, String>> finalLikelihoods = new List<Map<String, String>>();
		List<Schema.PicklistEntry> finalLikelihoodPicklist = ORTLRisk__c.FinalLikelihood__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : finalLikelihoodPicklist) {
			finalLikelihoods.add(new Map<String, String>{ 'value' => entry.getValue(), 'label' => entry.getLabel() });
		}

		// Put all picklist values to result list.
		picklist.put('FinalRiskConsequence', finalConsequences);
		picklist.put('FinalRiskConsequenceEffect', finalConsequenceEffects);
		picklist.put('FinalSeverity', finalSeverities);
		picklist.put('FinalLikelihood', finalLikelihoods);

		// Return results.
		return picklist;
	}

	/**
	 * This method return all custom metadata types in a single request.
	 * The custom metadata types used to make a Risk Table Header such as Consequece Description,
	 * Risk Level, Likelihood Caption and Estimated Value.
	 */
	@AuraEnabled
	public static Map<String, List<Object>> getRiskAssessmentCustomMetadata() {
		// For Storing all metadata to return.
		Map<String, List<Object>> meta = new Map<String, List<Object>>();

		// Get custom metadata type ORTLConseqDesc__mdt (Consequece Description).
		List<ORTLConseqDesc__mdt> consequenceDescriptions = [
			SELECT Id, DeveloperName, MasterLabel, Label, Consequence__c, Severity__c, ConsequenceDesc__c
			FROM ORTLConseqDesc__mdt
		];
		// Get custom metadata type ORTLRiskLevel__mdt (Risk Level).
		List<ORTLRiskLevel__mdt> risk = [
			SELECT Id, DeveloperName, MasterLabel, Label, Likelihood__c, Severity__c, RiskLevel__c, EstValueUSD__c, EstValueTHB__c
			FROM ORTLRiskLevel__mdt
		];
		// Get custom metadata type ORTLLikelihood__mdt (Likelihood Caption).
		List<ORTLLikelihood__mdt> likelihoodCaptions = [
			SELECT Id, DeveloperName, MasterLabel, Label, Caption1__c, Caption2__c, Caption3__c, Caption4__c
			FROM ORTLLikelihood__mdt
		];

		// Put all custom metadata types to result list.
		meta.put('ConsequenceDescription', consequenceDescriptions);
		meta.put('RiskLevel', risk);
		meta.put('LikelihoodCaption', likelihoodCaptions);

		// Return results.
		return meta;
	}

	/**
	 * For update an initial risk assessment execution value to database include list of attendees.
	 * This method recieve a request from aura component when user click save initial risk assessment
	 * to perform the task.
	 */
	@AuraEnabled
	public static ORTLRisk__c updateInitialRiskAssessment(ORTLRisk__c ortl, List<ORTLAttendee__c> attendees, List<ORTLAttendee__c> deleteAttendees){
		// Execute update risk.
		update ortl;

		// For storing attendees to insert.
		List<ORTLAttendee__c> insertList = new List<ORTLAttendee__c>();
		// For storing attendees to update.
		List<ORTLAttendee__c> updateList = new List<ORTLAttendee__c>();
		// Classify group of attendees to insert/update for each attendee records.
		for (ORTLAttendee__c attendee : attendees) {
			// Skip when attendee is blank.
			if  (String.isBlank(attendee.AttendeeName__c)) {
				continue;
			}
			// If has record id add to update list
			// If not add to insert list
			if (String.isBlank(attendee.Id)) {
				attendee.Risk__c = ortl.Id;
				insertList.add(attendee);
			} else {
				updateList.add(attendee);
			}
		}

		// Execute insert attendees.
		insert insertList;
		// Execute update attendees.
		update updateList;
		// Execute delete attendees.
		delete deleteAttendees;

		// Return results
		return ortl;
	}

	/**
	 * For update an final risk assessment execution value to database include list of attendees.
	 * This method recieve a request from aura component when user click save final risk assessment
	 * to perform the task.
	 */
	@AuraEnabled
	public static ORTLRisk__c updateFinalRiskAssessment(ORTLRisk__c ortl, List<ORTLAttendee__c> attendees, List<ORTLAttendee__c> deleteAttendees){
		// Execute update risk.
		update ortl;

		// For storing attendees to insert.
		List<ORTLAttendee__c> insertList = new List<ORTLAttendee__c>();
		// For storing attendees to update.
		List<ORTLAttendee__c> updateList = new List<ORTLAttendee__c>();
		// Classify group of attendees to insert/update for each attendee records.
		for (ORTLAttendee__c attendee : attendees) {
			// Skip when attendee is blank.
			if  (String.isBlank(attendee.AttendeeName__c)) {
				continue;
			}
			// If has record id add to update list
			// If not add to insert list
			if (String.isBlank(attendee.Id)) {
				attendee.Risk__c = ortl.Id;
				insertList.add(attendee);
			} else {
				updateList.add(attendee);
			}
		}

		// Execute insert attendees.
		insert insertList;
		// Execute update attendees.
		update updateList;
		// Execute delete attendees.
		delete deleteAttendees;

		// Return results
		return ortl;
	}

	/**
	 * This method return list of risk attachments record to current risk record.
	 * And display in Files tab of Initial Risk Assessment Modal
	 */
	@AuraEnabled
	public static List<ContentDocumentLink> getContentDocumentLinks(ORTLRisk__c ortl) {
		return [
			SELECT
				ContentDocumentId,
				SystemModstamp,
				ContentDocument.Title,
				ContentDocument.FileType,
				ContentDocument.FileExtension,
				ContentDocument.Description
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :ortl.Id
			ORDER BY SystemModstamp DESC
		];
	}

	/**
	 * This method return list of ORTL admin user in permission set named ORTLAdmin.
	 * And used to default as attendee when perform initial risk assessment if threat
	 * is set to 'Frequent Violation of PTM limits'
	 */
	@AuraEnabled
	public static List<PermissionSetAssignment> getOrtlAdmins() {
		return [
			SELECT
				Id,
				AssigneeId,
				Assignee.Name
			FROM PermissionSetAssignment
			WHERE PermissionSet.Name = 'ORTLAdmin'
		];
	}

	/**
	 * This method return list of action owner user in all actions related to current
	 * risk record. And used to default as attendee when perform final risk assessment.
	 */
	@AuraEnabled
	public static List<ORTLAction__c> getActions(ORTLRisk__c ortl) {
		return [
			SELECT
				Id,
				Owner.Name
			FROM ORTLAction__c
			WHERE Risk__c = :ortl.Id
			ORDER BY LastModifiedDate DESC
		];
	}

	/**
	 * This method return list of attendees related to current risk record.
	 * And list of attendees display when editing initial/final risk assessment.
	 */
	@AuraEnabled
	public static List<ORTLAttendee__c> getAttendees(ORTLRisk__c ortl) {
		return [
			SELECT
				Id,
				Type__c,
				AttendeeName__c
			FROM ORTLAttendee__c
			WHERE Risk__c = :ortl.Id
			ORDER BY LastModifiedDate ASC
		];
	}

	/**
	 * This method rename risk attachments to the following format
	 * 1. [Risk No.]_Initial_[XX] for initial risk attachments
	 * 2. [Risk No.]_Final_[XX] for final risk attachments
	 * And return all attachments to render UI
	 */
	@AuraEnabled
	public static List<ContentDocumentLink> renameUploadedFile(ORTLRisk__c ortl, String documentId, String title) {
		// Get content document record to update to new name.
		List<ContentDocument> documents = [
			SELECT Id, Title
			FROM ContentDocument
			WHERE Id = :documentId
		];

		if (documents.size() > 0) {
			// Set new name.
			documents[0].Title = title;
			try {
				// Execute update.
				update documents;
			} catch (DMLException e) {
				// Throw errors.
				throw new AuraHandledException('Error occured while renaming document');
			}
		}

		// Return all attachments to rerender.
		return getContentDocumentLinks(ortl);
	}

	/**
	 * This method return all risks related to original risk.
	 * When editing risk will display risks that related to current risk records
	 * if Applicable to Other Equipment is checked.
	 */
	@AuraEnabled
	public static List<ORTLRisk__c> getRelatedRisk(ORTLRisk__c ortl) {
		return [
			SELECT
				Id,
				Name,
				TagNo__c,
				TagNo__r.Name
			FROM ORTLRisk__c
			WHERE OriginalRisk__c = :ortl.Id
				AND CheckApplicable__c = true
		];
	}

	/**
	 * This method return detail information of specific functional location.
	 */
	@AuraEnabled
	public static Object getFunctionLocationDetail(Id funcLocationId) {
		// Call to original implementation.
		return ORTLCreateRiskCtrl.getFunctionLocationDetail(funcLocationId);
	}

	/**
	 * queryRiskRecords Method used to Find matching records with predetermined name
	 * predetermined name is unique name of each record and specific name is 'RA-YYYY-000'
	 */
	public static List<ORTLRisk__c> queryRiskRecords(){
		// Call to original implementation.
		return ORTLCreateRiskCtrl.queryRiskRecords();
	}

	/**
	 * getAddNewRisk Method used to Find matching records with predetermined name
	 * specific name is 'RA-YYYY-000'
	 * every new year, number will start counting 1 again
	 * This method is called from createRisk Method
	 */
	@AuraEnabled
	public static String getAddNewRisk( List<ORTLRisk__c> risks ) {
		// Call to original implementation.
		return ORTLCreateRiskCtrl.getAddNewRisk(risks);
	}

	/**
	 * updateRisk Method used to update parent and child risk when user perform edit risk
	 * child risk will recieve some field as same as prarent risk
	 * and OwnerId will changed if user choose another owner
	 * the child risk generated number must be checked to ensure that there is no duplicate with the lastest number.
	 * */
	@AuraEnabled
	public static ORTLRisk__c updateRisk( ORTLRisk__c risk, List<String> tagNoList) {
		// Set owner from UI.
		risk.OwnerId = risk.RiskInitiator__c;
		// Execute update risk.
		update risk;


		List<ORTLRisk__c> risks = new List<ORTLRisk__c>();
		List<ORTLRisk__c> riskAll = queryRiskRecords();
		Integer currentYear = Integer.valueof(DateTime.now().format('YYYY'));
		Integer count = 1;
		String runNo = getAddNewRisk(riskAll);

		/**
		 * the child risk generated number must be checked to ensure that there is no duplicate with the lastest number.
		 */
		for(String tagNo  : tagNoList) {
			ORTLRisk__c r1 = new ORTLRisk__c();
			r1.TagNo__c = tagNo;
			/** if true for fist item in list /next item in list will be else condition and generated number */
			if(count == 1) {
				r1.Name = runNo;
			} else {
				List<String> riskNoPart = String.valueOf(runNo).split('-');
				Integer lastestRunningNumber = Integer.valueOf(riskNopart[riskNopart.size()-1]);
				String runningNumber = String.valueof(lastestRunningNumber + (count-1)); //5+1
				r1.Name = 'RA-'+currentYear+'-'+runningNumber.leftPad(3, '0'); //risk.Name;
			}
			r1.RiskStatus__c = 'New';
			r1.RiskInitiator__c = risk.RiskInitiator__c;
			r1.InitiativeDate__c = risk.InitiativeDate__c;
			r1.AssessmentType__c = 'PRA (Potential Risk Assessment)';//risk.AssessmentType__c;
			r1.OriginalRisk__c = risk.Id;
			r1.RiskScenario__c = risk.RiskScenario__c;
			//r1.RiskScenarioDes__c = risk.RiskScenarioDes__c;
			//r1.EnRiskMgt__c = risk.EnRiskMgt__c;
			//r1.DEM__c = risk.DEM__c;
			//r1.ApptootherEQP__c = risk.ApptootherEQP__c;
			//r1.Causeoffailure__c = risk.Causeoffailure__c;
			r1.OwnerId = risk.RiskInitiator__c;
			r1.Threat__c = risk.Threat__c;
			r1.IntRiskCons__c = risk.IntRiskCons__c;
			r1.IntConsEffect__c = risk.IntConsEffect__c;
			r1.IniOtherConsEff__c = risk.IniOtherConsEff__c;
			r1.CheckApplicable__c = risk.ApptootherEQP__c;

			risks.add(r1);
			count += 1;
		}
		insert risks;

		return risk;
	}

	/**
	 * user can edit owner if they are owner of record or
	 * has permission set ortl admin
	 * */
	@AuraEnabled
	public static Boolean canEditOwner(ORTLRisk__c ortl) {
		Boolean isCreator = false;
		Boolean isOwner = false;
		List<ORTLRisk__c> risks = [SELECT Id, OwnerId, CreatedById FROM ORTLRisk__c WHERE Id = :ortl.Id];
		if (risks.size() > 0) {
			if (risks[0].OwnerId == UserInfo.getUserId()) {
				isOwner = true;
			}
			if (risks[0].CreatedById == UserInfo.getUserId()) {
				isCreator = true;
			}
		}

		Boolean isORTLAdmin = false;
		List<PermissionSetAssignment> permSetAssigns = [ SELECT Id, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'ORTLAdmin' AND AssigneeId = :UserInfo.getUserId() ];
		if (permSetAssigns.size() >  0) {
			isORTLAdmin = true;
		}

		return isCreator || isOwner || isORTLAdmin;
	}

	/**
	 * user can edit risk if they has permission to edit record
	 * */
	@AuraEnabled
	public static Boolean canEditRisk(ORTLRisk__c ortl) {
		Boolean canEditRisk = false;
		List<ORTLRisk__c> risks = [SELECT UserRecordAccess.HasEditAccess FROM ORTLRisk__c WHERE Id = :ortl.Id];
		if (risks.size() > 0) {
			canEditRisk = risks[0].UserRecordAccess.HasEditAccess;
		}
		return canEditRisk;
	}
}