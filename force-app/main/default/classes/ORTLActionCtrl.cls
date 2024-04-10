/**
 * ORTL Action Controller Class,
 *
 */
public class ORTLActionCtrl {

	// The static property for storing relevant users (CC) related to specific action records.
	// The property initialize before perform tasks to reduce query limit.
	private static Map<Id, List<ORTLRelevantUser__c>> RelevantUsers;

	/**
	 * Return a specific action record with the field 'Name'.
	 */
	@AuraEnabled
	public static ORTLAction__c getActionName(Id actionId) {
		return [
			SELECT
				Id,
				Name
			FROM ORTLAction__c
			WHERE Id = :actionId
			WITH SECURITY_ENFORCED
		];
	}

	/**
	 * When user perform cancel action by click cancel action button in action record page.
	 * The task status will be set to 'Canceled' and requires a cancel reason.
	 */
	@AuraEnabled
	public static String cancelAction(Id actionId, String reason) {
		ORTLAction__c ortlAction = new  ORTLAction__c(Id = actionId, TaskStatus__c = 'Canceled', CancelReason__c = reason);
		update ortlAction;
		System.debug('--cancelAction--'+ ortlAction);
		return ortlAction.Id;
	}

	/**
	 * Method to get relavant users (CC) related to specific action records.
	 */
	@AuraEnabled
	public static List<ORTLRelevantUser__c> getRelevantUsers(Id actionId) {
		return [
			SELECT
				Id,
				RelevantUser__c,
				ActionNumber__r.OwnerId
			FROM ORTLRelevantUser__c
			WHERE ActionNumber__c = :actionId
			ORDER BY LastModifiedDate ASC
		];
	}

	/**
	 * Method to get Action Owner Id.
	 */
	@AuraEnabled
	public static String getActionOwner(Id actionId) {
		List<ORTLAction__c> actions =  [ SELECT OwnerId FROM ORTLAction__c WHERE Id = :actionId ];
		return (actions.size() > 0 ? actions[0].OwnerId : '');
	}

	/**
	 * Method to manipulate relavants users (CC) when user perform add/edit/delete relavant users in action record page.
	 */
	@AuraEnabled
	public static List<ORTLRelevantUser__c> updateRelevantUsers(Id actionId, List<ORTLRelevantUser__c> relevantUsers, List<ORTLRelevantUser__c> deleteRelevantUsers){
		List<ORTLRelevantUser__c> insertList = new List<ORTLRelevantUser__c>();
		List<ORTLRelevantUser__c> updateList = new List<ORTLRelevantUser__c>();
		for (ORTLRelevantUser__c relevantUser : relevantUsers) {
			if (String.isBlank(relevantUser.RelevantUser__c)) {
				continue;
			}
			if (String.isBlank(relevantUser.Id)) {
				relevantUser.ActionNumber__c = actionId;
				insertList.add(relevantUser);
			} else {
				updateList.add(relevantUser);
			}
		}
		insert insertList;
		update updateList;
		delete deleteRelevantUsers;

		return getRelevantUsers(actionId);
	}

	/**
	 * If task status is set to 'In Progress', the action workflow will startover and cancel reason will be cleared.
	 */
	public static void checkAction_beforeTrigger(List<SObject> newItems, Map<Id, SObject> oldItems){
		System.debug(newItems);
		for(Object ac : newItems){
			ORTLAction__c newac = (ORTLAction__c) ac;

			System.debug('newac=>'+newac.TaskStatus__c);
			System.debug('newac=>'+newac.CancelReason__c);

			if(newac.TaskStatus__c == 'In Progress'){
				newac.CancelReason__c = null;
			}
			System.debug('newac upate=>'+newac.CancelReason__c);
		}
	}

	/**
	 * sendEmailActionDueDateChanged Method used to send notification email when Action Initiative date is changed.
	 * by way to check that the Action's status is not Done and Due Date must have a new date selected.
	 * After that, enter the values ​​that must be used as components for sending an Email.
	 */
	public static void sendEmailActionDueDateChanged(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		/**Call Email Template that must config in sf */
		EmailTemplate et = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLActionChangedDue'
			LIMIT 1
		];

		Map<Id, ORTLRisk__c> risk = getRisks(newItems);
		RelevantUsers = getRelevantUsersForSendEmail(newItems);

		/**Check Condition Before set value and Send Email */
		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		for (Id recordId : newItems.keySet()) {
			ORTLAction__c action = (ORTLAction__c) newItems.get(recordId);
			if (action.TaskStatus__c == 'Done') {
				continue;
			}
			ORTLAction__c oAction = (ORTLAction__c) oldItems.get(recordId);
			if (action.DueDate__c == oAction.DueDate__c) {
				continue;
			}

			Set<String> toAddress = new Set<String>();
			toAddress.add(ORTLRiskCtrl.getEmailOwner(action.OwnerId));
			toAddress.add(ORTLRiskCtrl.getEmailOwner(risk.get(action.Risk__c).OwnerId));
			//toAddress.AddAll(ORTLRiskCtrl.getEmailRiskTeam(risk.get(action.Risk__c).APU__c, risk.get(action.Risk__c).PlantSection__c));
			toAddress.AddAll(ORTLRiskCtrl.getRecipientRiskTeam(risk.get(action.Risk__c).APU__c, action.OwnerId));
			Set<String> ccAddress = new Set<String>();
			ccAddress.AddAll(getEmailCC(action.Id));

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setTemplateId(et.Id);
			mail.setToAddresses(new List<String>(toAddress));
			mail.setCcAddresses(new List<String>(ccAddress));
			mail.setSubject(et.Subject);
			mail.setTargetObjectId(cnt.Id);
			mail.setWhatId(recordId);
			mail.setSaveAsActivity(false);
			mail.setTreatTargetObjectAsRecipient(false);
			mail.setTreatBodiesAsTemplate(true);

			String htmlBody = et.HtmlValue;
			htmlBody = htmlBody.replace('{!ORTLAction__c.OldDueDate__c}', oAction.DueDate__c?.format());
			mail.setHtmlBody(htmlBody);
			allMsg.add(mail);
		}

		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);

		/**Result put to Application Log */
		for (Integer i = 0; i < results.size(); i++) {
			if (results[i].success)  {
				System.debug('The email was sent successfully.');
				String message = 'Status: Success'
					+ '\nTo: ' + ((allMsg[i].getToAddresses() != null) ? String.join(allMsg[i].getToAddresses(), ',') : '')
					+ '\nCc: ' + ((allMsg[i].getCcAddresses() != null) ? String.join(allMsg[i].getCcAddresses(), ',') : '')
					+ '\nSubject: ' + allMsg[i].getSubject()
					+ '\nBody: ' + allMsg[i].getHtmlBody();
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionChangedDue',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			} else {
				System.debug('The email failed to send: ' + results[i].errors[i].message);
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionChangedDue',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			}
		}
	}

	/** getRisks Method used to get risk record  */
	public static Map<Id, ORTLRisk__c> getRisks(Map<Id, SObject> newItems) {
		List<String> riskIds = new List<String>();
		for (SObject item : newItems.values()) {
			ORTLAction__c act = (ORTLAction__c) item;
			riskIds.add(act.Risk__c);
		}
		return new Map<Id, ORTLRisk__c>( [SELECT Id, OwnerId, APU__c, PlantSection__c FROM ORTLRisk__c WHERE Id IN :riskIds] );
	}

	/**
	 * sendEmailActionClosed Method used to send notification email when Action Task Status is Done or Complete Action
	 * by way to check that the New Action's status is Done and Old Action's status is not Done.
	 * After that, enter the values ​​that must be used as components for sending an Email.
	 */
	public static void sendEmailActionClosed(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {

		//test
		System.debug('--sendEmailActionClosed--');

		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		EmailTemplate et = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLActionClosed'
			LIMIT 1
		];

		RelevantUsers = getRelevantUsersForSendEmail(newItems);
		System.debug('RelevantUsers =>'+RelevantUsers);

		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		for (Id recordId : newItems.keySet()) {
			ORTLAction__c action = (ORTLAction__c) newItems.get(recordId);
			ORTLAction__c oAction = (ORTLAction__c) oldItems.get(recordId);
			if (action.TaskStatus__c == 'Done' && oAction.TaskStatus__c != 'Done') {
				Set<String> toAddress = new Set<String>();
				toAddress.add(ORTLRiskCtrl.getEmailOwner(action.OwnerId));
				Set<String> ccAddress = new Set<String>();
				ccAddress.AddAll(getEmailCC(action.Id));

				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setTemplateId(et.Id);
				mail.setToAddresses(new List<String>(toAddress));
				mail.setCcAddresses(new List<String>(ccAddress));
				mail.setSubject(et.Subject);
				mail.setTargetObjectId(cnt.Id);
				mail.setWhatId(recordId);
				mail.setSaveAsActivity(false);
				mail.setTreatTargetObjectAsRecipient(false);
				mail.setTreatBodiesAsTemplate(true);
				mail.setHtmlBody(et.HtmlValue);
				allMsg.add(mail);
			}
		}

		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);
		/** Result send email in Apllication Log */
		for (Integer i = 0; i < results.size(); i++) {
			if (results[i].success)  {
				System.debug('The email was sent successfully.');
				String message = 'Status: Success'
					+ '\nTo: ' + ((allMsg[i].getToAddresses() != null) ? String.join(allMsg[i].getToAddresses(), ',') : '')
					+ '\nCc: ' + ((allMsg[i].getCcAddresses() != null) ? String.join(allMsg[i].getCcAddresses(), ',') : '')
					+ '\nSubject: ' + allMsg[i].getSubject()
					+ '\nBody: ' + allMsg[i].getHtmlBody();
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionClosed',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			} else {
				System.debug('The email failed to send: ' + results[i].errors[i].message);
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionClosed',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			}
		}
	}

	/**
	 * sendEmailActionCanceled Method used to send notification email when Action Task Status is Cancel Or Click Cancel and Submit reason
	 * by way to check that the New Action's status is Cancel and Old Action's status is not Cancel.
	 * After that, enter the values ​​that must be used as components for sending an Email.
	 */
	public static void sendEmailActionCanceled(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {

		System.debug('--sendEmailActionCanceled--');

		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		EmailTemplate et = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLActionCanceled'
			LIMIT 1
		];

		RelevantUsers = getRelevantUsersForSendEmail(newItems);
		System.debug('RelevantUsers =>'+RelevantUsers);

		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		for (Id recordId : newItems.keySet()) {
			ORTLAction__c action = (ORTLAction__c) newItems.get(recordId);
			ORTLAction__c oAction = (ORTLAction__c) oldItems.get(recordId);
			if (action.TaskStatus__c == 'Canceled' && oAction.TaskStatus__c != 'Canceled') {
				Set<String> toAddress = new Set<String>();
				toAddress.add(ORTLRiskCtrl.getEmailOwner(action.OwnerId));
				//toAddress.AddAll(getEmailRiskTeam(risk.APU__c, risk.PlantSection__c));
				Set<String> ccAddress = new Set<String>();
				ccAddress.AddAll(getEmailCC(action.Id));

				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setTemplateId(et.Id);
				mail.setToAddresses(new List<String>(toAddress));
				mail.setCcAddresses(new List<String>(ccAddress));
				mail.setSubject(et.Subject);
				mail.setTargetObjectId(cnt.Id);
				mail.setWhatId(recordId);
				mail.setSaveAsActivity(false);
				mail.setTreatTargetObjectAsRecipient(false);
				mail.setTreatBodiesAsTemplate(true);
				mail.setHtmlBody(et.HtmlValue);
				allMsg.add(mail);
			}
		}

		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);
		/** Result send email in Apllication Log */
		for (Integer i = 0; i < results.size(); i++) {
			if (results[i].success)  {
				System.debug('The email was sent successfully.');
				String message = 'Status: Success'
					+ '\nTo: ' + ((allMsg[i].getToAddresses() != null) ? String.join(allMsg[i].getToAddresses(), ',') : '')
					+ '\nCc: ' + ((allMsg[i].getCcAddresses() != null) ? String.join(allMsg[i].getCcAddresses(), ',') : '')
					+ '\nSubject: ' + allMsg[i].getSubject()
					+ '\nBody: ' + allMsg[i].getHtmlBody();
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionCanceled',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			} else {
				System.debug('The email failed to send: ' + results[i].errors[i].message);
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionCanceled',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			}
		}
	}

	/**
	 * sendEmailActionAboutDueDate Method used to send notification email when Action Task Status is In Progress
	 * and has 1 or 7 due date left to remind their pending actions.
	 */
	public static void sendEmailActionAboutDueDate(SchedulableContext ctx) {
		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		EmailTemplate et1d = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLActionDueIn1Day'
			LIMIT 1
		];

		EmailTemplate et7d = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLActionDueIn7Days'
			LIMIT 1
		];

		Date today = Date.today();

		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		for (ORTLAction__c action : [SELECT Id, Risk__r.Name, OwnerId, Owner.Email, DueDate__c, (SELECT Id, RelevantUser__r.Email FROM RelevantUser__r) FROM ORTLAction__c WHERE TaskStatus__c = 'In Progress' ORDER BY CreatedDate]) {

			if (action.DueDate__c == null) {
				continue;
			}

			Integer dayLeft = today.daysBetween(action.DueDate__c);
			System.debug(action.Risk__r.Name + ':' + action.DueDate__c + ':' + dayLeft);
			if (dayLeft == 1) {
				List<String> toAddress = new List<String>();
				toAddress.add(ORTLRiskCtrl.getEmailOwner(action.OwnerId));

				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setTemplateId(et1d.Id);
				mail.setSubject(et1d.Subject);
				mail.setHtmlBody(et1d.HtmlValue);
				mail.setTargetObjectId(cnt.Id);
				mail.setWhatId(action.Id);
				mail.setSaveAsActivity(false);
				mail.setTreatTargetObjectAsRecipient(false);
				mail.setTreatBodiesAsTemplate(true);
				mail.setToAddresses(toAddress);
				if (action.RelevantUser__r.size() > 0) {
					List<String> ccAddress = new List<String>();
					for (ORTLRelevantUser__c relevant : action.RelevantUser__r) {
						ccAddress.add(relevant.RelevantUser__r.Email);
					}
					mail.setCcAddresses(new List<String>(ccAddress));
				}
				allMsg.add(mail);
			}
			if (dayLeft == 7) {
				List<String> toAddress = new List<String>();
				toAddress.add(ORTLRiskCtrl.getEmailOwner(action.OwnerId));

				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setTemplateId(et7d.Id);
				mail.setSubject(et7d.Subject);
				mail.setHtmlBody(et7d.HtmlValue);
				mail.setTargetObjectId(cnt.Id);
				mail.setWhatId(action.Id);
				mail.setSaveAsActivity(false);
				mail.setTreatTargetObjectAsRecipient(false);
				mail.setTreatBodiesAsTemplate(true);
				mail.setToAddresses(toAddress);
				if (action.RelevantUser__r.size() > 0) {
					List<String> ccAddress = new List<String>();
					for (ORTLRelevantUser__c relevant : action.RelevantUser__r) {
						ccAddress.add(relevant.RelevantUser__r.Email);
					}
					mail.setCcAddresses(new List<String>(ccAddress));
				}
				allMsg.add(mail);
			}
		}

		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);
		/** Result send email in Apllication Log */
		for (Integer i = 0; i < results.size(); i++) {
			if (results[i].success)  {
				String message = 'Status: Success'
					+ '\nTo: ' + ((allMsg[i].getToAddresses() != null) ? String.join(allMsg[i].getToAddresses(), ',') : '')
					+ '\nCc: ' + ((allMsg[i].getCcAddresses() != null) ? String.join(allMsg[i].getCcAddresses(), ',') : '')
					+ '\nSubject: ' + allMsg[i].getSubject()
					+ '\nBody: ' + allMsg[i].getHtmlBody();
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionAboutDueDate',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			} else {
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionAboutDueDate',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			}
		}
	}

	/**getRelevantUsersForSendEmail Method used to get relavant user is who recieve cc email*/
	public static Map<Id, List<ORTLRelevantUser__c>> getRelevantUsersForSendEmail(Map<Id, SObject> newItems) {
		System.debug('--getRelevantUsersForSendEmail--');
		Set<Id> actionIds = new Set<Id>();
		for (Id recordId : newItems.keySet()) {
			ORTLAction__c  ac = (ORTLAction__c ) newItems.get(recordId);
			actionIds.add(ac.Id);
		}
		System.debug('actionIds =>'+actionIds);

		Map<Id, List<ORTLRelevantUser__c>> relUsers = new Map<Id, List<ORTLRelevantUser__c>>();
		for (ORTLRelevantUser__c relevantUser : [
			SELECT Id, ActionNumber__c, ActionNumber__r.Risk__c, RelevantUser__r.Email
			FROM ORTLRelevantUser__c
			WHERE ActionNumber__c IN :actionIds
		]) {
			if (relUsers.containsKey(relevantUser.ActionNumber__c)) {
				List<ORTLRelevantUser__c> temp = relUsers.get(relevantUser.ActionNumber__c);
				temp.add(relevantUser);
			} else {
				List<ORTLRelevantUser__c> temp = new List<ORTLRelevantUser__c>();
				temp.add(relevantUser);
				relUsers.put(relevantUser.ActionNumber__c, temp);
			}
		}
		System.debug('relUsers =>'+relUsers);
		return relUsers;
	}

	/** getEmailCC Method used to get user's email */
	public static List<String> getEmailCC(String recordId) {
		System.debug('--getEmailCC--');
		List<String> emailCCs = new List<String>();
		if (RelevantUsers.containsKey(recordId)) {
			for (ORTLRelevantUser__c relUser : RelevantUsers.get(recordId)) {
				emailCCs.add(relUser.RelevantUser__r.Email);
			}
		}
		System.debug('emailCCs =>'+emailCCs);
		return emailCCs;
	}

	/**
	 * This method find APU and Plant Section from Main Work Center in
	 * Functional Location and update APU when record are created/updated.
	 */
	public static void updateAPUPlantSection(List<ORTLAction__c> newItems) {
		List<String> flIds = new List<String>();
		for (ORTLAction__c action : newItems) {
			flIds.add(action.TagNo__c);
		}

		Map<String, Functional_Location__c> fls = new Map<String, Functional_Location__c>([SELECT Id, Name, MainWorkCenter__r.Name, PlantSection__c, Planning_Plant_Text__c, Area__c FROM Functional_Location__c WHERE Id IN :flIds]);
		for (ORTLAction__c action : newItems) {
			action.txtTagNo__c = fls.get(action.TagNo__c)?.Name;
			action.txtPlanningPlant__c = fls.get(action.TagNo__c)?.Planning_Plant_Text__c;
			action.APU__c = fls.get(action.TagNo__c)?.Area__c;

			String mwc = fls.get(action.TagNo__c)?.MainWorkCenter__r?.Name;
			if (String.isBlank(mwc)) {
				continue;
			}
			if (mwc.left(3).equalsIgnoreCase('ENM')) {
				action.APU__c = mwc.substring(3, 4);
			}
		}

		Map<String, Master_Map__c> plntSecs = new Map<String, Master_Map__c>();
		for (Master_Map__c masterMap : [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant Section']) {
			plntSecs.put(masterMap.Name, masterMap);
		}
		for (ORTLAction__c action : newItems) {
			String plntSec = fls.get(action.TagNo__c)?.PlantSection__c;
			action.PlantSection__c = plntSecs.get(plntSec)?.Description__c;
		}
	}

	/**
	 * This method find Relevant User Name by Lookup to Name in User Object
	 * then update in text field ORTLRelevantUser__c.txtRelevantUser__c.
	 */
	public static void updateRelevantUserName(List<ORTLRelevantUser__c> newItems) {
		List<String> userIds = new List<String>();
		for (ORTLRelevantUser__c relUser : newItems) {
			userIds.add(relUser.RelevantUser__c);
		}

		Map<String, User> users = new Map<String, User>([SELECT Id, Name FROM User WHERE Id IN :userIds]);
		for (ORTLRelevantUser__c relUser : newItems) {
			relUser.txtRelevantUser__c = users.get(relUser.RelevantUser__c)?.Name;
		}
	}

	/**
	 * sendEmailActionCreated Method used to send notification email when Action is created and assigned to responsible person.
	 */
	@InvocableMethod
	public static void sendEmailActionCreated(List<ORTLAction__c> actions) {
		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		EmailTemplate et = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLActionAssigned'
			LIMIT 1
		];

		Map<Id, ORTLRisk__c> risk = getRisks(new Map<Id, ORTLAction__c>(actions));
		RelevantUsers = getRelevantUsersForSendEmail(new Map<Id, SObject>(actions));

		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		for (ORTLAction__c action : actions) {
			Set<String> toAddress = new Set<String>();
			toAddress.add(ORTLRiskCtrl.getEmailOwner(action.OwnerId));
			toAddress.add(ORTLRiskCtrl.getEmailOwner(risk.get(action.Risk__c).OwnerId));
			//toAddress.AddAll(getEmailRiskTeam(risk.APU__c, risk.PlantSection__c));
			Set<String> ccAddress = new Set<String>();
			ccAddress.AddAll(getEmailCC(action.Id));

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setTemplateId(et.Id);
			mail.setToAddresses(new List<String>(toAddress));
			mail.setCcAddresses(new List<String>(ccAddress));
			mail.setSubject(et.Subject);
			mail.setTargetObjectId(cnt.Id);
			mail.setWhatId(action.Id);
			mail.setSaveAsActivity(false);
			mail.setTreatTargetObjectAsRecipient(false);
			mail.setTreatBodiesAsTemplate(true);
			mail.setHtmlBody(et.HtmlValue);
			allMsg.add(mail);
		}

		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);
		/** Result send email in Apllication Log */
		for (Integer i = 0; i < results.size(); i++) {
			if (results[i].success)  {
				System.debug('The email was sent successfully.');
				String message = 'Status: Success'
					+ '\nTo: ' + ((allMsg[i].getToAddresses() != null) ? String.join(allMsg[i].getToAddresses(), ',') : '')
					+ '\nCc: ' + ((allMsg[i].getCcAddresses() != null) ? String.join(allMsg[i].getCcAddresses(), ',') : '')
					+ '\nSubject: ' + allMsg[i].getSubject()
					+ '\nBody: ' + allMsg[i].getHtmlBody();
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionAssigned',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			} else {
				System.debug('The email failed to send: ' + results[i].errors[i].message);
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLAction_ORTLActionAssigned',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLActionCtrl', applog);
			}
		}
	}

	@AuraEnabled
	public static Boolean canCancelOwner(ORTLAction__c action) {
		Boolean isOwner = false;
		List<ORTLAction__c> risks = [SELECT Id FROM ORTLAction__c WHERE Id = :action.Id AND OwnerId = :UserInfo.getUserId()];
		if (risks.size() > 0) {
			isOwner = true;
		}

		Boolean isORTLAdmin = false;
		List<PermissionSetAssignment> permSetAssigns = [ SELECT Id, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'ORTLAdmin' AND AssigneeId = :UserInfo.getUserId() ];
		if (permSetAssigns.size() >  0) {
			isORTLAdmin = true;
		}

		return isOwner || isORTLAdmin;
	}



	/**
	 * user can edit action if they has permission to edit record
	 * */
	@AuraEnabled
	public static Boolean canEditAction(ORTLAction__c action) {
		Boolean isOwner = false;
		List<ORTLAction__c> risks = [SELECT Id FROM ORTLAction__c WHERE Id = :action.Id AND OwnerId = :UserInfo.getUserId()];
		if (risks.size() > 0) {
			isOwner = true;
		}

		Boolean isORTLAdmin = false;
		List<PermissionSetAssignment> permSetAssigns = [ SELECT Id, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'ORTLAdmin' AND AssigneeId = :UserInfo.getUserId() ];
		if (permSetAssigns.size() >  0) {
			isORTLAdmin = true;
		}

		return isOwner || isORTLAdmin;
	}

}