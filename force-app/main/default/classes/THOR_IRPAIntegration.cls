public class THOR_IRPAIntegration {
	public static final Boolean ISADMIN = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()]
		?.Name.containsIgnoreCase('Admin');

	public static final Map<Id, PISUsers__c> pisUserMap {
		get {
			if (pisUserMap == null) {
				pisUserMap = new Map<Id, PISUsers__c>(
					[
						SELECT Id, HOST_ID__c, HOME_ID__c, User__c, User__r.Name, User__r.IsActive
						FROM PISUsers__c
						WHERE HOST_ID__c != NULL OR HOME_ID__c != NULL
					]
				);
				return pisUserMap;
			}
			return pisUserMap;
		}
		set;
	}

	public static final Map<String, String> categoryWithMainWorkCenterWithPlant {
		get {
			if (categoryWithMainWorkCenterWithPlant == null) {
				categoryWithMainWorkCenterWithPlant = new Map<String, String>();
				for (Master_Map__c master : [
					SELECT Id, Code__c, Type__c, RelatedMasterMap1__r.Code__c, RelatedMasterMap2__r.Code__c
					FROM Master_Map__c
					WHERE Type__c = 'CategoryWithMainWorkCenterWithPlant'
				]) {
					categoryWithMainWorkCenterWithPlant.put(
						master.RelatedMasterMap1__r.Code__c + master.RelatedMasterMap2__r.Code__c,
						String.valueOf(master.Code__c)
					);
				}
			}
			return categoryWithMainWorkCenterWithPlant;
		}
		set;
	}

	public static final Map<String, String> catelogFaultCode {
		get {
			if (catelogFaultCode == null) {
				catelogFaultCode = new Map<String, String>();
				for (Master_Map__c master : [
					SELECT Id, RelatedMasterMap1__c, RelatedMasterMap2__c
					FROM Master_Map__c
					WHERE Type__c = 'CatelogFaultCode'
				]) {
					catelogFaultCode.put(master.RelatedMasterMap2__c, master.RelatedMasterMap1__c);
				}
			}
			return catelogFaultCode;
		}
		set;
	}
}