public class FunctionalLocationtHandler {

	public static void handleFunctionalLocationt(List<Functional_Location__c> fls) {
		Set<String> flText = new Set<String>();
		for (Functional_Location__c fl : fls) {
			if (fl.Parent_Functional_Location_Text__c != null) {
				flText.add(fl.Parent_Functional_Location_Text__c);
			}
		}

		Map<String, Id> flMap = new Map<String, Id>();
		for (Functional_Location__c fl : [
			SELECT Id, Name, Parent_Functional_Location_Text__c
			FROM Functional_Location__c
			WHERE Name IN :flText
		]) {
			flMap.put(fl.Name, fl.Id);
		}

		Map<String, String> mwcTypeMap = new Map<String, String>();
		for (Master_Map__c mwcType : [SELECT Id, RelatedMasterMap1__r.Name FROM Master_Map__c WHERE Type__c = 'Main Work Center']) {
			mwcTypeMap.put(mwcType.Id, mwcType.RelatedMasterMap1__r?.Name);
		}

		for (Functional_Location__c fl : fls) {
			fl.Key__c = fl.Name;
			fl.MainWorkcenter_type__c = mwcTypeMap.get(fl.MainWorkCenter__c);
			if (
				fl.Parent_Functional_Location_Text__c != null &&
				flMap.containskey(fl.Parent_Functional_Location_Text__c) &&
				flMap.get(fl.Parent_Functional_Location_Text__c) != null &&
				flMap.get(fl.Parent_Functional_Location_Text__c) != fl.Id
			) {
				fl.Parent_Functional_Location__c = flMap.get(fl.Parent_Functional_Location_Text__c);
			}
		}
	}
}