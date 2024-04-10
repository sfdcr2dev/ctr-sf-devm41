/**
 * ORTL Risk Controller used to send emails to notify related users
 * for the following events: risk created (Risk Registered), risk completed
 * and risk closed. This class provides function to find recipients
 * and merge an email from template to risk record.
 */
public class ORTLRiskCtrl {

	// The static property for storing relevant users (CC) related to specific action records.
	// The property initialize before perform tasks to reduce query limit.
	private static Map<Id, List<ORTLRelevantUser__c>> RelevantUsers;

	public static GroupMemberHelper Helper {
		get {
			if (Helper == null) {
				Helper = new GroupMemberHelper();
			}
			return Helper;
		}
		set;
	}

	public static final Map<Id, User> Users {
		get {
			// if property not initialize then get user datas and caching to reduce query.
			if (Users == null) {
				Users = new Map<Id, User>();
				for (User user : [SELECT Id, Name, Email, UserRole.DeveloperName FROM User]) {
					Users.put(user.Id, user);
				}
			}
			return Users;
		}
		set;
	}

	// private static final Map<String, List<User>> UsersByRoleName {
	// 	get {
	// 		// if property not initialize then get user datas and caching to reduce query.
	// 		if (UsersByRoleName == null) {
	// 			UsersByRoleName = new Map<String, List<User>>();
	// 			for (User user : [SELECT Id, Name, Email, UserRole.DeveloperName FROM User]) {
	// 				if (UsersByRoleName.containsKey(user.UserRole.DeveloperName)) {
	// 					List<User> userInRoleName = UsersByRoleName.get(user.UserRole.DeveloperName);
	// 					userInRoleName.add(user);
	// 				} else {
	// 					List<User> userInRoleName = new List<User>();
	// 					userInRoleName.add(user);
	// 					UsersByRoleName.put(user.UserRole.DeveloperName, userInRoleName);
	// 				}
	// 			}
	// 		}
	// 		return UsersByRoleName;
	// 	}
	// 	set;
	// }

	// // The static property for storing all user roles in org.
	// private static final List<UserRole> UserRoles {
	// 	get {
	// 		// if property not initialize then get user role datas and caching to reduce query.
	// 		if (UserRoles == null) {
	// 			UserRoles = new List<UserRole>();
	// 			for (UserRole role : [SELECT Id, ParentRoleId FROM UserRole]) {
	// 				UserRoles.add(role);
	// 			}
	// 		}
	// 		return UserRoles;
	// 	}
	// 	set;
	// }

	// // The static property for storing all group type 'Role' in org.
	// private static final List<Group> Groups {
	// 	get {
	// 		// if property not initialize then get group datas and caching to reduce query.
	// 		if (Groups == null) {
	// 			Groups = new List<Group>();
	// 			for (Group grp : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Role']) {
	// 				Groups.add(grp);
	// 			}
	// 		}
	// 		return Groups;
	// 	}
	// 	set;
	// }

	// // The static property for storing all group member of public group 'ORTL' in org.
	// private static final Map<String, List<GroupMember>> GroupMembers {
	// 	get {
	// 		// if property not initialize then get group member datas and caching to reduce query.
	// 		if (GroupMembers == null) {
	// 			GroupMembers = new Map<String, List<GroupMember>>();
	// 			for (GroupMember gMember : [
	// 				SELECT
	// 					Id,
	// 					GroupId,
	// 					Group.DeveloperName,
	// 					UserOrGroupId
	// 				FROM GroupMember
	// 				WHERE Group.DeveloperName LIKE 'ORTL%'
	// 			]) {
	// 				if (GroupMembers.containsKey(gMember.Group.DeveloperName)) {
	// 					List<GroupMember> gMembers = GroupMembers.get(gMember.Group.DeveloperName);
	// 					gMembers.add(gMember);
	// 				} else {
	// 					List<GroupMember> gMembers = new List<GroupMember>();
	// 					gMembers.add(gMember);
	// 					GroupMembers.put(gMember.Group.DeveloperName, gMembers);
	// 				}
	// 			}
	// 		}
	// 		return GroupMembers;
	// 	}
	// 	set;
	// }

	// // The static property for storing all group member of public group 'ORTL' in org.
	// private static final Map<String, List<Id>> GroupMemberIdsByName {
	// 	get {
	// 		// if property not initialize then get group member datas and caching to reduce query.
	// 		if (GroupMemberIdsByName == null) {
	// 			GroupMemberIdsByName = new Map<String, List<Id>>();
	// 			for (GroupMember gMember : [
	// 				SELECT
	// 					Id,
	// 					GroupId,
	// 					Group.DeveloperName,
	// 					UserOrGroupId
	// 				FROM GroupMember
	// 				WHERE Group.DeveloperName LIKE 'ORTL%'
	// 			]) {
	// 				if (GroupMemberIdsByName.containsKey(gMember.Group.DeveloperName)) {
	// 					List<Id> gMembers = GroupMemberIdsByName.get(gMember.Group.DeveloperName);
	// 					gMembers.add(gMember.UserOrGroupId);
	// 				} else {
	// 					List<Id> gMembers = new List<Id>();
	// 					gMembers.add(gMember.UserOrGroupId);
	// 					GroupMemberIdsByName.put(gMember.Group.DeveloperName, gMembers);
	// 				}
	// 			}
	// 		}
	// 		return GroupMemberIdsByName;
	// 	}
	// 	set;
	// }

	/**
	 * This method is used to send emails to notify relateusers (initiator)
	 * when risks are created.
	 */
	public static void sendEmailRiskRegistered(Map<Id, SObject> newItems) {
		// Require contact for using an email template and setting whatId.
		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		// Get email template 'ORTLRiskNewRegisted'.
		EmailTemplate et = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLRiskNewRegisted'
			LIMIT 1
		];

		// Get relevant users that related to risks used to set CC.
		RelevantUsers = getRelevantUsers(newItems);

		// For storing all objects of email message to deliver.
		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		// Perform constructing objects of email message on each risk records that met criteria.
		for (Id recordId : newItems.keySet()) {
			// Cast record to ORTLRisk__c
			ORTLRisk__c risk = (ORTLRisk__c) newItems.get(recordId);

			// For storing 'To Addresses'
			List<String> toAddress = new List<String>();
			// Add owner to 'To Addresses'
			toAddress.add(getEmailOwner(risk.OwnerId));
			// Add risk team to 'To Addresses'
			//toAddress.AddAll(getEmailRiskTeam(risk.APU__c, risk.PlantSection__c));
			toAddress.AddAll(getRecipientRiskTeam(risk.APU__c, risk.OwnerId));
			// For storing 'CC Addresses'
			//List<String> ccAddress = new List<String>();
			// Add relevant users to 'CC Addresses'
			//ccAddress.AddAll(getEmailCC(risk.Id));

			// Instantiate SingleEmailMessage for sending email.
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			// Set following: email template, to addresses, cc addresses,
			// Subject, target object id, what id, save as activity (false),
			// Treat target object as recipient (false),
			// Treat body as templates (true), html body
			mail.setTemplateId(et.Id);
			mail.setToAddresses(toAddress);
			//mail.setCcAddresses(ccAddress);
			mail.setSubject(et.Subject);
			mail.setTargetObjectId(cnt.Id);
			mail.setWhatId(recordId);
			mail.setSaveAsActivity(false);
			mail.setTreatTargetObjectAsRecipient(false);
			mail.setTreatBodiesAsTemplate(true);
			mail.setHtmlBody(et.HtmlValue);

			// Add constructed SingleEmailMessage to list.
			allMsg.add(mail);
			System.debug(toAddress);
		}

		// Execute sending emails.
		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);

		// Extract sending email results for each record.
		// Create application log whether success or failed.
		for (Integer i = 0; i < results.size(); i++) {
			if (results[i].success)  {
				System.debug('The email was sent successfully.');
				String message = 'Status: Success'
					+ '\nTo: ' + ((allMsg[i].getToAddresses() != null) ? String.join(allMsg[i].getToAddresses(), ',') : '')
					//+ '\nCc: ' + ((allMsg[i].getCcAddresses() != null) ? String.join(allMsg[i].getCcAddresses(), ',') : '')
					+ '\nSubject: ' + allMsg[i].getSubject()
					+ '\nBody: ' + allMsg[i].getHtmlBody();
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLRisk_ORTLRiskNewRegisted',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLRiskCtrl', applog);
			} else {
				System.debug('The email failed to send: ' + results[i].errors[i].message);
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLRisk_ORTLRiskNewRegisted',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLRiskCtrl', applog);
			}
		}
	}

	/**
	 * This method is used to send emails to notify related users (initiator,
	 * all relevant users (CC) in all actions relatedto risks) when risk are completed.
	 */
	public static void sendEmailRiskCompleted(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		// Require contact for using an email template and setting whatId.
		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		// Get email template 'ORTLRiskCompleted'.
		EmailTemplate et = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLRiskAwaitFinAssess'
			LIMIT 1
		];

		// Get relevant users that related to risks used to set CC.
		RelevantUsers = getRelevantUsers(newItems);

		// For storing all objects of email message to deliver.
		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		// Perform constructing objects of email message on each risk records that met criteria.
		for (Id recordId : newItems.keySet()) {
			// Cast record to ORTLRisk__c

			// Criteria: risk status change from any to Awaiting Final Assessment
			// New Value
			// - risk status = Awaiting Final Assessment
			// Old Value
			// - risk status != Awaiting Final Assessment
			ORTLRisk__c risk = (ORTLRisk__c) newItems.get(recordId);
			if (risk.RiskStatus__c != 'Awaiting Final Assessment') {
				continue;
			}
			ORTLRisk__c oRisk = (ORTLRisk__c) oldItems.get(recordId);
			if (oRisk.RiskStatus__c == 'Awaiting Final Assessment') {
				continue;
			}

			// For storing 'To Addresses'
			List<String> toAddress = new List<String>();
			// Add owner to 'To Addresses'
			toAddress.add(getEmailOwner(risk.OwnerId));
			// Add risk team to 'To Addresses'
			//toAddress.AddAll(getEmailRiskTeam(risk.APU__c, risk.PlantSection__c));
			toAddress.AddAll(getRecipientRiskTeam(risk.APU__c, risk.OwnerId));
			// For storing 'CC Addresses'
			List<String> ccAddress = new List<String>();
			// Add relevant users to 'CC Addresses'
			ccAddress.AddAll(getEmailCC(risk.Id));

			// Instantiate SingleEmailMessage for sending email.
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			// Set following: email template, to addresses, cc addresses,
			// Subject, target object id, what id, save as activity (false),
			// Treat target object as recipient (false),
			// Treat body as templates (true), html body
			mail.setTemplateId(et.Id);
			mail.setToAddresses(toAddress);
			mail.setCcAddresses(ccAddress);
			mail.setSubject(et.Subject);
			mail.setTargetObjectId(cnt.Id);
			mail.setWhatId(recordId);
			mail.setSaveAsActivity(false);
			mail.setTreatTargetObjectAsRecipient(false);
			mail.setTreatBodiesAsTemplate(true);
			mail.setHtmlBody(et.HtmlValue);

			// Add constructed SingleEmailMessage to list.
			allMsg.add(mail);
		}

		// Execute sending emails.
		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);

		// Extract sending email results for each record.
		// Create application log whether success or failed.
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
					Integration_Name__c = 'ORTLRisk_ORTLRiskAwaitFinAssess',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLRiskCtrl', applog);
			} else {
				System.debug('The email failed to send: ' + results[i].errors[i].message);
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLRisk_ORTLRiskAwaitFinAssess',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLRiskCtrl', applog);
			}
		}
	}

	/**
	 * This method is used to send emails to notify related users (initiator,
	 * all relevant users (CC) in all actions relatedto risks) when risk are closed.
	 */
	public static void sendEmailRiskClosed(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		// Require contact for using an email template and setting whatId.
		Contact cnt = [SELECT Id FROM Contact LIMIT 1];

		// Get email template 'ORTLRiskClosed'.
		EmailTemplate et = [
			SELECT
				Id,
				Subject,
				HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'ORTLRiskClosed'
			LIMIT 1
		];

		// Get relevant users that related to risks used to set CC.
		RelevantUsers = getRelevantUsers(newItems);

		// For storing all objects of email message to deliver.
		List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
		// Perform constructing objects of email message on each risk records that met criteria.
		for (Id recordId : newItems.keySet()) {
			// Cast record to ORTLRisk__c

			// Criteria: risk status change from any to Closed
			// New Value
			// - risk status = Closed
			// Old Value
			// - risk status != Closed
			ORTLRisk__c risk = (ORTLRisk__c) newItems.get(recordId);
			if (risk.RiskStatus__c != 'Closed') {
				continue;
			}
			ORTLRisk__c oRisk = (ORTLRisk__c) oldItems.get(recordId);
			if (oRisk.RiskStatus__c == 'Closed') {
				continue;
			}

			// For storing 'To Addresses'
			List<String> toAddress = new List<String>();
			// Add owner to 'To Addresses'
			toAddress.add(getEmailOwner(risk.OwnerId));
			// Add risk team to 'To Addresses'
			//toAddress.AddAll(getEmailRiskTeam(risk.APU__c, risk.PlantSection__c));
			toAddress.AddAll(getRecipientRiskTeam(risk.APU__c, risk.OwnerId));
			// For storing 'CC Addresses'
			List<String> ccAddress = new List<String>();
			// Add relevant users to 'CC Addresses'
			ccAddress.AddAll(getEmailCC(risk.Id));

			// Instantiate SingleEmailMessage for sending email.
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			// Set following: email template, to addresses, cc addresses,
			// Subject, target object id, what id, save as activity (false),
			// Treat target object as recipient (false),
			// Treat body as templates (true), html body
			mail.setTemplateId(et.Id);
			mail.setToAddresses(toAddress);
			mail.setCcAddresses(ccAddress);
			mail.setSubject(et.Subject);
			mail.setTargetObjectId(cnt.Id);
			mail.setWhatId(recordId);
			mail.setSaveAsActivity(false);
			mail.setTreatTargetObjectAsRecipient(false);
			mail.setTreatBodiesAsTemplate(true);
			mail.setHtmlBody(et.HtmlValue);

			// Add constructed SingleEmailMessage to list.
			allMsg.add(mail);
		}

		// Execute sending emails.
		Messaging.SendEmailResult[] results = Messaging.sendEmail(allMsg);

		// Extract sending email results for each record.
		// Create application log whether success or failed.
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
					Integration_Name__c = 'ORTLRisk_ORTLRiskClosed',
					Method__c = 'Insert',
					Message_Type__c = 'Success',
					Request_Body__c = message,
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLRiskCtrl', applog);
			} else {
				System.debug('The email failed to send: ' + results[i].errors[i].message);
				Application_Log__c applog = new Application_Log__c(
					External_ID__c = Uuid.randomUUID(),
					Integration_Name__c = 'ORTLRisk_ORTLRiskClosed',
					Method__c = 'Insert',
					Message_Type__c = 'Failed',
					Error_Message__c = results[i].errors[i].message,
					Request_Body__c = '',
					Response_Body__c = ''
				);

				ApplicationLogUtils.saveLogOutbound('ORTLRiskCtrl', applog);
			}
		}
	}

	/**
	 * This method return Email address for specific user id.
	 */
	public static String getEmailOwner(String userId) {
		// String email = '';
		// for (User u : Users) {
		// 	if (u.Id == userId) {
		// 		email = u.Email;
		// 	}
		// }
		// return email;
		return Users.containsKey(userId) ? Users.get(userId).Email : '';
	}

	/**
	 * This method return all Email addresses of risk team for specific APU and plant section
	 */
	public static List<String> getRecipientRiskTeam(String apu, String ownerId) {
		Map<String, List<String>> parents = Helper.getParentChildRelations();
		Map<String, List<String>> childs = Helper.getChildParentRelations();
		Map<String, List<String>> userGroups = Helper.getUserGroups();
		Map<String, String> names = Helper.getGroupNames();
		Map<String, List<GroupMember>> members = Helper.getGroupMembers();
		List<String> emails = new List<String>();

		List<String> ownerGroups = new List<String>();
		if (userGroups.containsKey(ownerId)) {
			for (String groupId : userGroups.get(ownerId)) {
				ownerGroups.add(groupId);
				if (childs.containsKey(groupId)) {
					ownerGroups.addAll(childs.get(groupId));
				}
			}
		}

		if (!String.isBlank(apu)) {
			String publicGroup = 'ORTL-' + apu;
			String publicGroupTagNo = names.get(publicGroup);

			List<String> tagNoGroups = new List<String>();
			tagNoGroups.add(publicGroupTagNo);
			tagNoGroups.addAll((parents.get(publicGroupTagNo) != null) ? parents.get(publicGroupTagNo) : new List<String>());

			if (ownerGroups.indexOf(publicGroup) > -1) {
				List<String> tmp = new List<String>();
				for (String s1 : tagNoGroups) {
					if (ownerGroups.contains(s1)) {
						tmp.add(s1);
					}
				}

				if (tmp.size() > 1) {
					for (String groupId : tmp) {
						if (members.containsKey(groupId)) {
							for (GroupMember gMem : members.get(groupId)) {
								emails.add(Users.get(gMem.UserOrGroupId).Email);
							}
						}
					}
				} else {
					for (String groupId : tagNoGroups) {
						if (members.containsKey(groupId)) {
							for (GroupMember gMem : members.get(groupId)) {
								emails.add(Users.get(gMem.UserOrGroupId).Email);
							}
						}
					}
				}
			} else {
				for (String groupId : tagNoGroups) {
					if (members.containsKey(groupId)) {
						for (GroupMember gMem : members.get(groupId)) {
							emails.add(Users.get(gMem.UserOrGroupId).Email);
						}
					}
				}
			}
		} else {
			for (String groupId : ownerGroups) {
				if (members.containsKey(groupId)) {
					for (GroupMember gMem : members.get(groupId)) {
						emails.add(Users.get(gMem.UserOrGroupId).Email);
					}
				}
			}
		}

		List<String> results = new List<String>();
		results.addAll(new Set<String>(emails));
		return results;
	}

	// /**
	//  * This method return all Email addresses of risk team for specific APU and plant section
	//  */
	// public static List<String> getEmailRiskTeam(String apu, String plantSection) {
	// 	// Public group name pattern ORTLAPU[?]PlantSection[?].
	// 	String publicGroupName = 'ORTLAPU' + apu + 'PlantSection' + plantSection;
	// 	// For storing emails.
	// 	List<String> emails = new List<String>();
	// 	// Find users by public group name.
	// 	for (User u : getUserPublicGroupName(publicGroupName)) {
	// 		// Extract email and add to list.
	// 		emails.add(u.Email);
	// 	}
	// 	System.debug(emails);
	// 	// Return emails.
	// 	return emails;
	// }

	// /**
	//  * This method return group member for specific public group name.
	//  */
	// public static List<User> getUserPublicGroupName(String publicGroupName) {
	// 	// // For storing group ids to find sub roles.
	// 	// Set<Id> roleGroupIds = new Set<Id>();
	// 	// // Find group ids from public group name.
	// 	// for (GroupMember member : GroupMembers) {
	// 	// 	if (member.Group.DeveloperName == publicGroupName) {
	// 	// 		System.debug(member.Group.DeveloperName);
	// 	// 		roleGroupIds.add(member.UserOrGroupId);
	// 	// 	}
	// 	// }
	// 	// // Get all group role ids (include sub roles).
	// 	// Set<Id> allRoleGroupIds = getAllSubRoleIds(roleGroupIds);
	// 	// allRoleGroupIds.addAll(roleGroupIds);

	// 	// // Find all users from group role ids (include sub roles).
	// 	// return getAllUserRoleIds(allRoleGroupIds);

	// 	// For storing group ids to find sub roles.
	// 	Set<Id> roleGroupIds = (GroupMemberIdsByName.containsKey(publicGroupName)) ? new Set<Id>(GroupMemberIdsByName.get(publicGroupName)) : new Set<Id>();
	// 	// Get all group role ids (include sub roles).
	// 	Set<Id> allRoleGroupIds = getAllSubRoleIds(roleGroupIds);
	// 	allRoleGroupIds.addAll(roleGroupIds);

	// 	// Find all users from group role ids (include sub roles).
	// 	return getAllUserRoleIds(allRoleGroupIds);
	// }

	// /**
	//  * This method return sub role ids for specific parent role id.
	//  */
	// public static Set<Id> getAllSubRoleIds(Set<Id> roleIds) {
	// 	Set<Id> currentRoleIds = new Set<Id>();

	// 	// Get all of the roles underneath the passed roles
	// 	for (UserRole userRole : UserRoles) {
	// 		if (roleIds.contains(userRole.ParentRoleId)) {
	// 			currentRoleIds.add(userRole.Id);
	// 		}
	// 	}

	// 	// Fetch more roles, recursively.
	// 	if (currentRoleIds.size() > 0) {
	// 		currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
	// 	}

	// 	return currentRoleIds;
	// }

	// /**
	//  * This method return all users for specfic set of role ids.
	//  */
	// public static List<User> getAllUserRoleIds(Set<Id> roleIds) {
	// 	// // For storing all role names to find users.
	// 	// Set<String> roleNames = new Set<String>();
	// 	// // Get role names from role ids.
	// 	// for (Group g : Groups) {
	// 	// 	if (roleIds.contains(g.Id)) {
	// 	// 		roleNames.add(g.DeveloperName);
	// 	// 	}
	// 	// }

	// 	// // For string all users.
	// 	// List<User> usrs = new List<User>();
	// 	// // Get all users from role names.
	// 	// for (User u : Users.values()) {
	// 	// 	if (roleNames.contains(u.UserRole.DeveloperName)) {
	// 	// 		usrs.add(u);
	// 	// 	}
	// 	// }

	// 	// // Return all users.
	// 	// return usrs;

	// 	// For storing all role names to find users.
	// 	Set<String> roleNames = new Set<String>();
	// 	// Get role names from role ids.
	// 	for (Group g : Groups) {
	// 		if (roleIds.contains(g.Id)) {
	// 			roleNames.add(g.DeveloperName);
	// 		}
	// 	}

	// 	// For store all users.
	// 	List<User> usrs = new List<User>();
	// 	// Get all users from role names.
	// 	for (String roleName : roleNames) {
	// 		if (UsersByRoleName.containsKey(roleName)) {
	// 			usrs.addAll(UsersByRoleName.get(roleName));
	// 		}
	// 	}

	// 	// Return all users.
	// 	return usrs;

	// }

	/**
	 * Method to get relavant users (CC) related to specific action records.
	 */
	public static Map<Id, List<ORTLRelevantUser__c>> getRelevantUsers(Map<Id, SObject> newItems) {
		// Get all risk ids from triggered records
		Set<Id> riskIds = new Set<Id>();
		for (Id recordId : newItems.keySet()) {
			ORTLRisk__c risk = (ORTLRisk__c) newItems.get(recordId);
			riskIds.add(risk.Id);
		}

		// Get all relevant users from risk ids. include all relevant users in all actions related to risks.
		Map<Id, List<ORTLRelevantUser__c>> relUsers = new Map<Id, List<ORTLRelevantUser__c>>();
		for (ORTLRelevantUser__c relevantUser : [
			SELECT Id, ActionNumber__c, ActionNumber__r.Risk__c, RelevantUser__r.Email
			FROM ORTLRelevantUser__c
			WHERE ActionNumber__r.Risk__c IN :riskIds
		]) {
			// Get all relevant users from risks.
			if (relUsers.containsKey(relevantUser.ActionNumber__r.Risk__c)) {
				List<ORTLRelevantUser__c> temp = relUsers.get(relevantUser.ActionNumber__r.Risk__c);
				temp.add(relevantUser);
			} else {
				List<ORTLRelevantUser__c> temp = new List<ORTLRelevantUser__c>();
				temp.add(relevantUser);
				relUsers.put(relevantUser.ActionNumber__r.Risk__c, temp);
			}

			// Get all relevant user from actions.
			if (relUsers.containsKey(relevantUser.ActionNumber__c)) {
				List<ORTLRelevantUser__c> temp = relUsers.get(relevantUser.ActionNumber__c);
				temp.add(relevantUser);
			} else {
				List<ORTLRelevantUser__c> temp = new List<ORTLRelevantUser__c>();
				temp.add(relevantUser);
				relUsers.put(relevantUser.ActionNumber__c, temp);
			}
		}

		// Return all relevant users.
		return relUsers;
	}

	/**
	 * This method return all relevant user emails for specific risk/action id.
	 */
	public static List<String> getEmailCC(String recordId) {
		List<String> emailCCs = new List<String>();
		if (RelevantUsers.containsKey(recordId)) {
			for (ORTLRelevantUser__c relUser : RelevantUsers.get(recordId)) {
				emailCCs.add(relUser.RelevantUser__r.Email);
			}
		}
		return emailCCs;
	}

	/**
	 * This method find APU, Plant Section and Discipline from Main Work Center in
	 * Functional Location and update APU when record are created/updated.
	 */
	public static void updateAPUPlantSectionDiscipline(List<ORTLRisk__c> newItems) {
		List<String> flIds = new List<String>();
		for (ORTLRisk__c risk : newItems) {
			flIds.add(risk.TagNo__c);
		}

		Map<String, Functional_Location__c> fls = new Map<String, Functional_Location__c>([SELECT Id, Name, MainWorkCenter__r.Name, PlantSection__c, Planning_Plant_Text__c, Area__c FROM Functional_Location__c WHERE Id IN :flIds]);
		for (ORTLRisk__c risk : newItems) {
			risk.txtTagNo__c = fls.get(risk.TagNo__c)?.Name;
			risk.txtPlanningPlant__c = fls.get(risk.TagNo__c)?.Planning_Plant_Text__c;
			risk.APU__c = fls.get(risk.TagNo__c)?.Area__c;

			String mwc = fls.get(risk.TagNo__c)?.MainWorkCenter__r?.Name;
			if (String.isBlank(mwc)) {
				continue;
			}
			if (mwc.left(3).equalsIgnoreCase('ENM')) {
				risk.APU__c = mwc.substring(3, 4);
				//String[] parts = mwc.split('-');
				//Map<String, String> disciplines = new Map<String, String>{ 'I' => 'INST', 'E' => 'ELEC', 'M' => 'MECH' };
				//risk.Discipline__c = (parts.size() > 1) ? disciplines.get(parts[1]) : '';
			} else {
				String[] parts = mwc.split('-');
				risk.Discipline__c = (parts.size() > 0) ? parts[0] : '';
			}
		}

		Map<String, Master_Map__c> plntSecs = new Map<String, Master_Map__c>();
		for (Master_Map__c masterMap : [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant Section']) {
			plntSecs.put(masterMap.Name, masterMap);
		}
		for (ORTLRisk__c risk : newItems) {
			String plntSec = fls.get(risk.TagNo__c)?.PlantSection__c;
			risk.PlantSection__c = plntSecs.get(plntSec)?.Description__c;
		}
	}

	public class GroupMemberHelper {
		private Map<String, List<String>> users;
		private Map<String, String> groupNames;
		private Map<String, List<GroupMember>> groupMembers;
		private Map<String, List<String>> parentToChilds;
		private Map<String, List<String>> childToParents;

		private Map<String, List<String>> tmpParentToChilds;
		private Map<String, List<String>> tmpChildToParents;

		public GroupMemberHelper() {
			groupNames = new Map<String, String>();
			groupMembers = new Map<String, List<GroupMember>>();
			parentToChilds = new Map<String, List<String>>();
			childToParents = new Map<String, List<String>>();
			tmpParentToChilds = new Map<String, List<String>>();
			tmpChildToParents = new Map<String, List<String>>();
			users = new Map<String, List<String>>();
			for (GroupMember gMem : [SELECT Id, UserOrGroupId, GroupId, Group.Name FROM GroupMember WHERE Group.Name LIKE 'ORTL-_' OR Group.Name LIKE 'ORTL-_-%']) {
				List<GroupMember> mems;
				List<String> userGroups;
				List<String> relParentToChilds;
				List<String> relChildToParents;

				if (String.valueOf(gMem.UserOrGroupId).left(3) == '00G') {
					if (tmpParentToChilds.containsKey(gMem.GroupId)) {
						relParentToChilds = tmpParentToChilds.get(gMem.GroupId);
					} else {
						relParentToChilds = new List<String>();
						tmpParentToChilds.put(gMem.GroupId, relParentToChilds);
					}
					relParentToChilds.add(gMem.UserOrGroupId);

					if (tmpChildToParents.containsKey(gMem.UserOrGroupId)) {
						relChildToParents = tmpChildToParents.get(gMem.UserOrGroupId);
					} else {
						relChildToParents = new List<String>();
						tmpChildToParents.put(gMem.UserOrGroupId, relChildToParents);
					}
					relChildToParents.add(gMem.GroupId);
				} else {
					if (groupMembers.containsKey(gMem.GroupId)) {
						mems = groupMembers.get(gMem.GroupId);
					} else {
						mems = new List<GroupMember>();
						groupMembers.put(gMem.GroupId, mems);
					}
					mems.add(gMem);

					if (users.containsKey(gMem.UserOrGroupId)) {
						userGroups = users.get(gMem.UserOrGroupId);
					} else {
						userGroups = new List<String>();
						users.put(gMem.UserOrGroupId, userGroups);
					}
					userGroups.add(gMem.GroupId);
				}
			}

			for (String key : tmpChildToParents.keySet()) {
				childToParents.put(key, getParentGroupMembers(key));
			}
			for (String key : tmpParentToChilds.keySet()) {
				parentToChilds.put(key, getSubGroupMembers(key));
			}

			for (Group grb : [SELECT Id, Name FROM Group WHERE Name LIKE 'ORTL-_' OR Group.Name LIKE 'ORTL-_-%']) {
				if (!groupNames.containsKey(grb.Id)) {
					groupNames.put(grb.Id, grb.Name);
					groupNames.put(grb.Name, grb.Id);
				}
			}
		}

		public Map<String, List<String>> getParentChildRelations() {
			return parentToChilds;
		}

		public Map<String, List<String>> getChildParentRelations() {
			return childToParents;
		}

		public Map<String, List<GroupMember>> getGroupMembers() {
			return groupMembers;
		}

		public Map<String, String> getGroupNames() {
			return groupNames;
		}

		public Map<String, List<String>> getUserGroups() {
			return users;
		}

		public List<String> getSubGroupMembers(String groupId) {
			if (tmpParentToChilds.containsKey(groupId)) {
				List<String> out = new List<String>();
				List<String> rels = tmpParentToChilds.get(groupId);
				for (String rel : rels) {
					out.add(rel);
					List<String> tmp = getSubGroupMembers(rel);
					if (tmp != null) {
						out.addAll(tmp);
					}
				}
				return out;
			} else {
				return null;
			}
		}

		public List<String> getParentGroupMembers(String groupId) {
			if (tmpChildToParents.containsKey(groupId)) {
				List<String> out = new List<String>();
				List<String> rels = tmpChildToParents.get(groupId);
				for (String rel : rels) {
					out.add(rel);
					List<String> tmp = getParentGroupMembers(rel);
					if (tmp != null) {
						out.addAll(tmp);
					}
				}
				return out;
			} else {
				return null;
			}
		}
	}
}