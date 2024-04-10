public with sharing class THOR_NotificationsController {
    
	@AuraEnabled
	public static void setNotificationStatus(String notificationId) {
		Notification__c n = [
			SELECT id, name, System_Status_Text__c, Notification_Status__c
			FROM Notification__c
			WHERE Id = :notificationId
			WITH SECURITY_ENFORCED
		];

		n.System_Status_Text__c = 'NOCO';
		// n.Notification_Status__c = 'Closed';
		n.Integration_Status__c = 'In Progress';

		try {
			if (Schema.sObjectType.Notification__c.isUpdateable()) {
				update n;
			}
		} catch (Exception ex) {
			throw new AuraHandledException('Something happened...');
		}
	}

	@AuraEnabled
	public static Boolean hasWriteAccess(String notificationId) {
		List<UserRecordAccess> access = [
			SELECT RecordId
			FROM UserRecordAccess
			WHERE HasEditAccess = TRUE AND RecordId = :notificationId AND UserId = :UserInfo.getUserId()
		];

		return !access.isEmpty();
	}
    
	@AuraEnabled
	public static Map<String, PISUsers__c> getPISUserList(List<String> pisuserIds) {
		List<PISUsers__c> pisusers = [
			SELECT
				Id,
				Name,
				EMPLOYEEID__c,
				HOST_ID__c,
				HOME_ID__c,
				ENFIRSTNAME__c,
				ENLASTNAME__c,
				ORGID__c
			FROM PISUsers__c
			WHERE Id IN :pisuserIds
		];
		Map<String, PISUsers__c> mapPisUsers = new Map<String, PISUsers__c>();
		if (pisusers.size() > 0) {
			for (PISUsers__c pisuser : pisusers) {
				mapPisUsers.put(pisuser.Id, pisuser);
			}
			return mapPisUsers;
		}
		return null;
	}
    
    @AuraEnabled
	public static Map<String, Functional_Location__c> getFunctionalLocationList(List<String> flIds) {
		List<Functional_Location__c> fls = [
			SELECT
				Id,
				Name,
            	Description__c
			FROM Functional_Location__c
			WHERE Id IN :flIds
		];
		Map<String, Functional_Location__c> mapFls = new Map<String, Functional_Location__c>();
		if (fls.size() > 0) {
			for (Functional_Location__c fl : fls) {
				mapFls.put(fl.Id, fl);
			}
			return mapFls;
		}
		return null;
	}
}