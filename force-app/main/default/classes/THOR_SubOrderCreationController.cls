public with sharing class THOR_SubOrderCreationController {
	@AuraEnabled
	public static Order__c getParentOrder(String recordId) {
		List<String> fields = new List<String>(MethodUtils.getAllFieldBySObject('Order__c').keySet());
		fields.addAll(
			new List<String>{
				'Functional_Location__r.Planning_Plant__c',
				'Functional_Location__r.MainWorkCenter__c',
				'Functional_Location__r.MainWorkCenter__r.Name',
				'Functional_Location__r.mainWorkCenterPlant__c',
				'Requester_PISUser__r.User__c',
				'Responsible_person_PISUser__r.User__c'
			}
		);
		return (Order__c) Database.query(
			String.format('SELECT {0} FROM Order__c WHERE Id = :recordId LIMIT 1', new List<String>{ String.join(fields, ', ') })
		);
	}

	@AuraEnabled
	public static Order__c changeOrderNumberToName(String recordId) {
		Order__c orderToChange = [SELECT Order_Number__c, Name FROM Order__c WHERE Id = :recordId WITH SECURITY_ENFORCED LIMIT 1];
		orderToChange.Order_Number__C = orderToChange.Name;
		// update orderToChange;

		return orderToChange;
	}

	/**
	 * @description retrieves Equipments based on the FL selected
	 * @param funcLocationId
	 */
	@AuraEnabled
	public static List<Equipment__c> retrieveEquipmentsByFunctionalLocation(Id funcLocationId) {
		return FunctionalLocationController.retrieveEquipmentsByFunctionalLocation(funcLocationId);
	}

	@AuraEnabled
	public static Functional_Location__c retrieveFunctionalLocationById(String flId) {
		return [
			SELECT Id, Name, Planning_Plant__c, MainWorkCenter__c, mainWorkCenterPlant__c, MainWorkCenter__r.Name
			FROM Functional_Location__c
			WHERE Id = :flId
			WITH SECURITY_ENFORCED
		];
	}

	@AuraEnabled
	public static List<Master_Map__c> getPMActivityType(String orderType) {
		List<Master_Map__c> firstFilter;
		Set<Id> masterMapIds = new Set<Id>();

		if (orderType != null) {
			firstFilter = [
				SELECT Id, Name, RelatedMasterMap1__c
				FROM Master_Map__c
				WHERE Type__c = 'MaintActivityTypeAndOrderType' AND RelatedMasterMap2__r.Name = :orderType
				WITH SECURITY_ENFORCED
			];

			for (Master_Map__c m : firstFilter) {
				masterMapIds.add(m.RelatedMasterMap1__c);
			}

			return getMasterMapsById(masterMapIds);
		} else {
			return null;
		}
	}

	//MAIN WORK CENTER
	// @AuraEnabled
	// public static List<Master_Map__c> getMainWorkCenters(Id mainWorkCenterPlantId) {
	// 	return [
	// 		SELECT Id, RelatedMasterMap1__r.Name, RelatedMasterMap1__r.Description__c
	// 		FROM Master_Map__c
	// 		WHERE Type__c = 'CategoryWithMainWorkCenterWithPlant' AND RelatedMasterMap2__c = :mainWorkCenterPlantId
	// 		WITH SECURITY_ENFORCED
	// 	];
	// }

	@AuraEnabled
	public static List<Master_Map__c> getMainWorkCenters(Id mainWorkCenterPlantId) {
		// if(mainWorkCenterPlantId != null) {
		// 	return [
		// 		SELECT Id, RelatedMasterMap1__r.Name, RelatedMasterMap1__r.Description__c
		// 		FROM Master_Map__c
		// 		WHERE Type__c = 'CategoryWithMainWorkCenterWithPlant' AND RelatedMasterMap2__c = :mainWorkCenterPlantId
		// 		WITH SECURITY_ENFORCED
		// 	];
		// }
		// else {
		// 	return [
		// 		SELECT Id, RelatedMasterMap1__r.Name, RelatedMasterMap1__r.Description__c
		// 		FROM Master_Map__c
		// 		WHERE Type__c = 'CategoryWithMainWorkCenterWithPlant'
		// 	];
		// }
		return FunctionalLocationController.getMainWorkCenters(mainWorkCenterPlantId);
	}

	@AuraEnabled
	public static Order__c getOrderById(Id orderId) {
		return [SELECT Id, name, Order_Type__c, PM_Activity_Type__c FROM Order__c WHERE Id = :orderId WITH SECURITY_ENFORCED];
	}

	private static List<Master_Map__c> getMasterMapsById(Set<Id> ids) {
		return [SELECT Id, Name, Code__c, Description__c FROM Master_Map__c WHERE Id IN :ids WITH SECURITY_ENFORCED];
	}

	@AuraEnabled
	public static List<Master_Map__c> searchPMActivityTypeByNameAndDescription(String searchText, List<Master_Map__c> pmActivityTypes) {
		List<Master_Map__c> master = new List<Master_Map__c>();
		for (Master_Map__c m : pmActivityTypes) {
			if (m.Description__c.toUpperCase().contains(searchText.toUpperCase()) || m.Name.toUpperCase().contains(searchText.toUpperCase())) {
				master.add(m);
			}
		}
		return master;
	}

	@AuraEnabled
	public static List<Master_Map__c> searchMainWorkCenterByNameAndDescription(String searchText, List<Master_Map__c> mainWorkCenters) {
		List<Master_Map__c> master = new List<Master_Map__c>();
		for (Master_Map__c m : mainWorkCenters) {
			if (
				m.RelatedMasterMap1__r.Description__c.toUpperCase().contains(searchText.toUpperCase()) ||
				m.RelatedMasterMap1__r.Name.toUpperCase().contains(searchText.toUpperCase())
			) {
				master.add(m);
			}
		}
		return master;
	}

	//MAIN WORK CENTER PLANT
	// @AuraEnabled
	// public static List<Master_Map__c> getMainWorkCenterPlants() {
	// 	return [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant' WITH SECURITY_ENFORCED];
	// }

	@AuraEnabled
	public static List<Master_Map__c> getAllMainWorkCenterPlants() {
		return [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant' WITH SECURITY_ENFORCED];
	}

	@AuraEnabled
	public static Object getMainWorkCenterPlants(String mainWorkCenterId) {
		return FunctionalLocationController.getMainWorkCenterPlants(mainWorkCenterId);
	}

	@AuraEnabled
	public static List<Master_Map__c> searchMainWorkCenterPlantByNameAndDescription(String searchText, List<Master_Map__c> mainWorkCenterPlants) {
		List<Master_Map__c> master = new List<Master_Map__c>();
		for (Master_Map__c m : mainWorkCenterPlants) {
			if (m.Description__c.toUpperCase().contains(searchText.toUpperCase()) || m.Name.toUpperCase().contains(searchText.toUpperCase())) {
				master.add(m);
			}
		}
		return master;
	}

	@AuraEnabled
	public static List<sObject> getPISRequester(String searchText) {
		return THOR_NotificationCreationCtrl.getPISRequester(searchText);
	}
}