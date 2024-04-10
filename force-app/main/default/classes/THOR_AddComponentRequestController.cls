public with sharing class THOR_AddComponentRequestController {
	@AuraEnabled
	public static List<Spare_Part__c> getComponents(
		String functionalLocation,
		String equipment,
		String material,
		String orderId
	) {
		Order__c opp = [
			SELECT mainWorkCenterPlant__r.Code__c, Planning_Plant__r.name
			FROM Order__c
			WHERE Id = :orderId
			LIMIT 1
		];
		String searchKey = material?.replace('*', '%');
		if (searchKey != null && !searchKey?.contains('%')) {
			searchKey = '%' + searchKey + '%';
		}

		List<Spare_Part__c> components = new List<Spare_Part__c>();
		Set<Id> BOMS = new Set<Id>();
		Set<Id> Mats = new Set<Id>();
		Set<Id> MatsResult = new Set<Id>();
		Map<Id, String> partPlantMap = new Map<Id, String>();

		if (String.isEmpty(functionalLocation) && String.isEmpty(equipment) && String.isNotEmpty(material)) {
			components.addAll(
				[
					SELECT
						Id,
						Material_Number__c,
						Material_Description__c,
						Base_Unit__c,
						(
							SELECT Id, Available_Quantity__c, Plant__r.Code__c
							FROM Spare_Part_Stocks__r
							WHERE Plant__c = :opp.Planning_Plant__c
						)
					FROM Spare_Part__c
					WHERE
						(Material_Number__c LIKE :searchKey
						OR Material_Description__c LIKE :searchKey)
						AND Id IN (
							SELECT Spare_Part__c
							FROM Spare_Part_Stock__c
							WHERE Plant__c = :opp.Planning_Plant__c
						)
					ORDER BY Material_Number__c
					LIMIT 2000
				]
			);
			return components;
		}

		if (String.isNotEmpty(functionalLocation)) {
			if (String.isNotEmpty(equipment)) {
				for (BOM__c e : [
					SELECT Id
					FROM BOM__c
					WHERE
						Equipment__c = :equipment
						AND Equipment__r.FL__c = :functionalLocation
						AND plant__c = :opp.Planning_Plant__c
				]) {
					BOMS.add(e.Id);
				}
			} else {
				for (BOM__c e : [
					SELECT Id
					FROM BOM__c
					WHERE
						plant__c = :opp.Planning_Plant__c
						AND Equipment__c IN :([SELECT Id FROM Equipment__c WHERE FL__c = :functionalLocation])
				]) {
					BOMS.add(e.Id);
				}
			}

			for (BOM_with_Spare_Part__c b : [
				SELECT sparePartNo__c, BOMNo__r.Equipment__r.PlanningPlant__c
				FROM BOM_with_Spare_Part__c
				WHERE BOMNo__c IN :BOMS
			]) {
				//partPlantMap.put(b.sparePartNo__c, b.BOMNo__r.Equipment__r.PlanningPlant__c);
				Mats.add(b.sparePartNo__c);
			}
		} else if (String.isNotEmpty(equipment)) {
			for (BOM_with_Spare_Part__c b : [
				SELECT sparePartNo__c, BOMNo__r.Equipment__r.PlanningPlant__c
				FROM BOM_with_Spare_Part__c
				WHERE
					BOMNo__c IN :([
						SELECT Id
						FROM BOM__c
						WHERE Equipment__c = :equipment AND plant__c = :opp.Planning_Plant__c
					])
			]) {
				//partPlantMap.put(b.sparePartNo__c, b.BOMNo__r.Equipment__r.PlanningPlant__c);
				Mats.add(b.sparePartNo__c);
			}
		}

		if (String.isNotEmpty(material)) {
			for (BOM_with_Spare_Part__c c : [
				SELECT sparePartNo__c, BOMNo__r.Equipment__r.PlanningPlant__c
				FROM BOM_with_Spare_Part__c
				WHERE
					BOMNo__r.Equipment__r.PlanningPlant__c = :opp.Planning_Plant__c AND
					sparePartNo__c IN :([
						SELECT Id
						FROM Spare_Part__c
						WHERE
							(Material_Number__c LIKE :searchKey
							OR Material_Description__c LIKE :searchKey)
							AND Id = :Mats
					])
			]) {
				partPlantMap.put(c.sparePartNo__c, c.BOMNo__r.Equipment__r.PlanningPlant__c);
			}
		} else {
			for (BOM_with_Spare_Part__c c : [
				SELECT sparePartNo__c, BOMNo__r.Equipment__r.PlanningPlant__c
				FROM BOM_with_Spare_Part__c
				WHERE
					BOMNo__r.Equipment__r.PlanningPlant__c = :opp.Planning_Plant__c AND
					sparePartNo__c IN :([
						SELECT Id
						FROM Spare_Part__c
						WHERE Id = :Mats
					])
			]) {
				partPlantMap.put(c.sparePartNo__c, c.BOMNo__r.Equipment__r.PlanningPlant__c);
			}
		}
        
        System.debug(partPlantMap);
		//  else {
		// 	partPlantMap.put(b.sparePartNo__c, b.BOMNo__r.Equipment__r.PlanningPlant__c);
		// }

		for (Spare_Part__c sp : [
			SELECT
				Id,
				Material_Number__c,
				Material_Description__c,
				Base_Unit__c,
				(
					SELECT Id, Available_Quantity__c, Plant__r.Code__c
					FROM Spare_Part_Stocks__r
					WHERE Plant__c = :opp.Planning_Plant__c
				)
			FROM Spare_Part__c
			WHERE Id IN :partPlantMap.keySet()
		]) {
			for (Spare_Part_Stock__c sps : sp.Spare_Part_Stocks__r) {
				//if (partPlantMap.get(sp.Id) == sps.Plant__c) {
					components.add(sp);
				//}
			}
		}
		return components;
	}

	@AuraEnabled
	public static Order__c getFunctionalLocationEquipment(Id orderId) {
		Order__c fle = [
			SELECT Functional_Location__c, Functional_Location__r.Name, Equipment__c, Equipment__r.Name
			FROM Order__c
			WHERE Id = :orderId
			LIMIT 1
		];
		return fle;
	}

	@AuraEnabled
	public static List<Spare_Part_Request__c> getExistingCart(Id orderId) {
		return [
			SELECT Spare_Part__c
			FROM Spare_Part_Request__c
			WHERE Order__c = :orderId AND Request_Status__c = 'Draft' AND Deleted__c = FALSE
		];
	}

	@AuraEnabled
	public static void createOrUpdateCart(Id orderId, List<Spare_Part__c> items, List<Spare_Part_Stock__c> stocks) {
		List<Spare_Part_Request__c> cart = new List<Spare_Part_Request__c>();
		Set<Id> itemIds = (new Map<Id, Spare_Part__c>(items)).keySet();
		Integer index = 0;
		for (Spare_Part__c sp : items) {
			Spare_Part_Stock__c stock = stocks[index];
			cart.add(
				new Spare_Part_Request__c(
					Order__c = orderId,
					Spare_Part_Stock__c = stock.Id,
					Available_Quantity__c = stock.Available_Quantity__c,
					Plant__c = stock.Plant__c,
					UM__c = sp.Base_Unit__c,
					Spare_Part__c = sp.Id,
					Request_Material_Quantity__c = 1,
					Request_Status__c = 'Draft'
				)
			);
			index++;
		}
		for (Spare_Part_Request__c spr : [
			SELECT Id, Spare_Part__c, Order__r.Planning_Plant__c
			FROM Spare_Part_Request__c
			WHERE Order__c = :orderId AND Deleted__c = FALSE AND Request_Status__c = 'Draft'
		]) {
			for (Spare_Part_Request__c cartItem : cart) {
				if (cartItem.Spare_Part__c == spr.Spare_Part__c) {
					cartItem.Id = spr.Id;
				}
			}
		}
		upsert cart;
	}
}