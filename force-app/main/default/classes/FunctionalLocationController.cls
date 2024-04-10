/**
 * @author Oktana
 */
public with sharing class FunctionalLocationController {
	public class MasterMapWrapper {
		@AuraEnabled
		public String id { get; set; }
		@AuraEnabled
		public String name { get; set; }
		@AuraEnabled
		public String description { get; set; }

		public MasterMapWrapper() {
		}

		public MasterMapWrapper(String id, String name, String description) {
			this.id = id;
			this.name = name;
			this.description = description;
		}
	}

	/**
	 * @description retrieves Equipments based on the FL selected
	 * @param funcLocationId
	 */
	@AuraEnabled
	public static List<Equipment__c> retrieveEquipmentsByFunctionalLocation(Id funcLocationId) {
		Functional_Location__c funcLocation = getFuncLocationById(funcLocationId);
		List<Equipment__c> equipments = [SELECT Id, Name, FL__c FROM Equipment__c WHERE FL__c = :funcLocationId];

		List<Equipment__c> sortEquipments = new List<Equipment__c>();
		for (Equipment__c equipment : equipments) {
			if (equipment.Id == funcLocation.First_Related_Equipment__c) {
				sortEquipments.add(equipment);
				break;
			}
		}

		for (Equipment__c equipment : equipments) {
			if (equipment.Id != funcLocation.First_Related_Equipment__c) {
				sortEquipments.add(equipment);
			}
		}

		return sortEquipments;
	}

	private static Functional_Location__c getFuncLocationById(Id funcLocationId) {
		return [SELECT Id, First_Related_Equipment__c FROM Functional_Location__c WHERE Id = :funcLocationId];
	}

	@AuraEnabled
	public static List<Master_Map__c> getMainWorkCenter() {
		return [SELECT Id, Name, Description__c, Type__c FROM Master_Map__c WHERE Type__c = 'Main Work Center'];
		// try {
		// } catch (Exception e) {
		// 	throw new AuraHandledException(e.getMessage());
		// }
	}

	@AuraEnabled
	public static List<Master_Map__c> retrieveCodeGroup(String catalogProfileId) {
		Map<Id, Master_Map__c> codeGroupMap = new Map<Id, Master_Map__c>();

		String faultCodeDesc = 'FaultCode';
		for (
			Master_Map__c masterMap : (List<Master_Map__c>) Database.query(
				String.format(
					'SELECT {0} FROM Master_Map__c WHERE Description__c = :faultCodeDesc AND RelatedMasterMap2__c != NULL {1} ORDER BY RelatedMasterMap1__r.Code__c',
					new List<Object>{
						String.join(
							new List<String>{
								'Code__c',
								'Description__c',
								'RelatedMasterMap1__c',
								'RelatedMasterMap1__r.Code__c',
								'RelatedMasterMap2__c',
								'RelatedMasterMap2__r.Code__c',
								'RelatedMasterMap2__r.Type__c',
								'RelatedMasterMap2__r.Description__c'
							},
							', '
						),
						catalogProfileId != null ? 'AND RelatedMasterMap1__r.Name = :catalogProfileId' : ''
					}
				)
			)
		) {
			codeGroupMap.put(
				masterMap.RelatedMasterMap2__c,
				new Master_Map__c(
					Id = masterMap.RelatedMasterMap2__c,
					Code__c = masterMap.RelatedMasterMap2__r.Code__c,
					Description__c = masterMap.RelatedMasterMap2__r.Description__c
				)
			);
		}
		/**
		 * @Description
		 * If has catalog profile but no list return.
		 * It will recursive get code group with out catalog profile id (default catalogProfileId = null)
		 */
		return codeGroupMap.size() > 0 ? codeGroupMap.values() : retrieveCodeGroup(null);
	}

	@AuraEnabled
	public static String hasCatelogProfileByEquipIdOrFuncId(Id equipIdOrFuncId) {
		if (equipIdOrFuncId == null) {
			return null;
		}

		String catelogProfileName = [
			SELECT Id, CatelogProfile__c, CatelogProfile__r.Name
			FROM Equipment__c
			WHERE Id = :equipIdOrFuncId
			WITH SECURITY_ENFORCED
		]
		?.CatelogProfile__r.Name;
		catelogProfileName = catelogProfileName != null
			? catelogProfileName
			: [
					SELECT Id, CatelogProfile__c, CatelogProfile__r.Name
					FROM Functional_Location__c
					WHERE Id = :equipIdOrFuncId
					WITH SECURITY_ENFORCED
			  ]
			  ?.CatelogProfile__r.Name;

		return catelogProfileName;
	}

	@AuraEnabled
	public static List<MasterMapWrapper> retrieveFaultCodes(Id equipmentId, Id funcLocationId, Id codeGroupId) {
		String catelogProfileName = equipmentId != null
			? [SELECT CatelogProfile__c FROM Equipment__c WHERE Id = :equipmentId WITH SECURITY_ENFORCED]
			  ?.CatelogProfile__c
			: [SELECT CatelogProfile__c FROM Functional_Location__c WHERE Id = :funcLocationId WITH SECURITY_ENFORCED]
			  ?.CatelogProfile__c;

		List<MasterMapWrapper> faultCodeLst = catelogProfileName != null
			? getByCatelogProfile(getCatelogProfile(catelogProfileName))
			: null;
		if (faultCodeLst == null) {
			// return getMasterMapNoDataFilter();
			faultCodeLst = new List<MasterMapWrapper>();
			for (Master_Map__c masterMap : [
				SELECT
					RelatedMasterMap1__c,
					RelatedMasterMap2__c,
					RelatedMasterMap2__r.Code__c,
					Description__c,
					RelatedMasterMap2__r.Type__c
				FROM Master_Map__c
				WHERE
					Type__c = 'CatelogFaultCode'
					AND RelatedMasterMap1__c = :codeGroupId
					AND RelatedMasterMap1__c != NULL
				ORDER BY Code__c
			]) {
				faultCodeLst.add(
					new MasterMapWrapper(
						masterMap.RelatedMasterMap2__c,
						masterMap.RelatedMasterMap2__r.Code__c,
						masterMap.Description__c
					)
				);
			}
		}
		return faultCodeLst;
	}

	private static List<MasterMapWrapper> getByCatelogProfile(Master_Map__c catelogProfile) {
		Set<Id> allFaultCodes = new Set<Id>();
		Master_Map__c firstFilter;
		List<Master_Map__c> secondFilter;
		List<Master_Map__c> thirdFilter;
		List<MasterMapWrapper> mmw = new List<MasterMapWrapper>();

		firstFilter = getMasterMapByTypeAndRelatedMM(catelogProfile);
		secondFilter = getSecondFilter(firstFilter);
		if (secondFilter != null) {
			for (Master_Map__c m : secondFilter) {
				allFaultCodes.add(m.RelatedMasterMap2__c);
				MasterMapWrapper item = new MasterMapWrapper();
				item.description = m.Description__c;
				mmw.add(item);
			}

			thirdFilter = getMasterMapsByIds(allFaultCodes);

			for (Integer i = 0; i < thirdFilter.size(); i++) {
				mmw[i].id = thirdFilter[i].Id;
				mmw[i].name = thirdFilter[i].Name;
			}

			return mmw;
		}

		return null;
	}

	private static List<Master_Map__c> getMasterMapsByIds(Set<Id> ids) {
		return [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Id IN :ids WITH SECURITY_ENFORCED ORDER BY Id];
	}

	private static Master_Map__c getCatelogProfile(Id id) {
		return [SELECT Id, Name FROM Master_Map__c WHERE Id = :id WITH SECURITY_ENFORCED];
	}

	private static Master_Map__c getMasterMapByTypeAndRelatedMM(Master_Map__c catelogProfile) {
		List<Master_Map__c> returnValue;
		returnValue = [
			SELECT Id, Name, RelatedMasterMap2__r.Name
			FROM Master_Map__c
			WHERE
				Type__c = :'CatalogType'
				AND Description__c = :'FaultCode'
				AND RelatedMasterMap1__r.Name = :catelogProfile.Name
			WITH SECURITY_ENFORCED
		];

		if (returnValue.size() > 0) {
			return returnValue[0];
		} else {
			return null;
		}
	}

	private static List<Master_Map__c> getSecondFilter(Master_Map__c firstFilter) {
		if (firstFilter != null) {
			return [
				SELECT Id, Name, RelatedMasterMap2__c, RelatedMasterMap2__r.Name, Description__c
				FROM Master_Map__c
				WHERE
					Type__c = :'CatelogFaultCode'
					AND RelatedMasterMap1__r.Name = :firstFilter.RelatedMasterMap2__r.Name
				WITH SECURITY_ENFORCED
				ORDER BY RelatedMasterMap2__c
			];
		} else {
			return null;
		}
	}

	// private static List<Master_Map__c> getMasterMapByTypeAndDescription() {
	// 	return [
	// 		SELECT Id, Name, RelatedMasterMap2__r.Name, Description__c
	// 		FROM Master_Map__c
	// 		WHERE Type__c = :'CatalogType' AND Description__c = 'FaultCode'
	// 		WITH SECURITY_ENFORCED
	// 	];
	// }

	// private static List<MasterMapWrapper> getMasterMapNoDataFilter() {
	// 	List<Master_Map__c> lst = [
	// 		SELECT Id, Name, Description__c
	// 		FROM Master_Map__c
	// 		WHERE Type__c = :'FaultCode'
	// 		WITH SECURITY_ENFORCED
	// 	];
	// 	List<MasterMapWrapper> mmw = new List<MasterMapWrapper>();

	// 	for (Master_Map__c m : lst) {
	// 		MasterMapWrapper item = new MasterMapWrapper();
	// 		item.id = m.Id;
	// 		item.name = m.Name;
	// 		item.description = m.Description__c;
	// 		mmw.add(item);
	// 	}

	// 	return mmw;
	// }

	@AuraEnabled
	public static Notification__c getNotificationById(String notificationId) {
		return [
			SELECT
				Id,
				Name,
				Fault_Code__c,
				Main_Work_Center__c,
				mainWorkCenterPlant__c,
				Functional_Location__r.MainWorkCenter__c,
				Functional_Location__r.MainWorkCenter__r.Name,
				Functional_Location__c,
				Functional_Location__r.mainWorkCenterPlant__c,
				Functional_Location__r.mainWorkCenterPlant__r.Name
			FROM Notification__c
			WHERE Id = :notificationId
			WITH SECURITY_ENFORCED
		];
	}

	@AuraEnabled
	public static Functional_Location__c retrieveFunctionalLocationById(String flId) {
		return [
			SELECT
				Id,
				Name,
            	Description__c,
				Planning_Plant__c,
				MainWorkCenter__c,
				mainWorkCenterPlant__c,
				mainWorkCenterPlant__r.Name,
				MainWorkCenter__r.Name
			FROM Functional_Location__c
			WHERE Id = :flId
			WITH SECURITY_ENFORCED
		];
	}

	@AuraEnabled
	public static Notification__c getParentNotification(String recordId) {
		List<String> fields = new List<String>(MethodUtils.getAllFieldBySObject('Notification__c').keySet());
		fields.addAll(
			new List<String>{
				'Functional_Location__r.mainWorkCenterPlant__c',
				'Functional_Location__r.Planning_Plant__c',
				'Functional_Location__r.MainWorkCenter__c',
				'Functional_Location__r.MainWorkCenter__r.Name',
				'Requester_PISUser__r.User__c'
			}
		);
		return (Notification__c) Database.query(
			String.format(
				'SELECT {0} FROM Notification__c WHERE Id = :recordId LIMIT 1',
				new List<String>{ String.join(fields, ', ') }
			)
		);
		// return [
		// 	SELECT
		// 		Id,
		// 		Name,
		// 		Equipment__c,
		// 		Functional_Location__c,
		// 		Planning_Plant__c,
		// 		Type__c,
		// 		Required_Start__c,
		// 		mainWorkCenterPlant__c,
		// 		Main_Work_Center__c,
		// 		Functional_Location__r.mainWorkCenterPlant__c,
		// 		Functional_Location__r.Planning_Plant__c,
		// 		Functional_Location__r.MainWorkCenter__c,
		// 		Functional_Location__r.MainWorkCenter__r.Name
		// 	FROM Notification__c
		// 	WHERE Id = :recordId
		// 	WITH SECURITY_ENFORCED
		// 	LIMIT 1
		// ];
	}

	//PM Activity Type
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

	@AuraEnabled
	public static Order__c getOrderById(Id orderId) {
		return [
			SELECT
				Id,
				name,
				Order_Type__c,
				PM_Activity_Type__c,
				Functional_Location__r.MainWorkCenter__c,
				Functional_Location__r.MainWorkCenter__r.Name,
				Main_Work_Center__c,
				mainWorkCenterPlant__c
			FROM Order__c
			WHERE Id = :orderId
			WITH SECURITY_ENFORCED
		];
	}

	private static List<Master_Map__c> getMasterMapsById(Set<Id> ids) {
		return [SELECT Id, Name, Code__c, Description__c FROM Master_Map__c WHERE Id IN :ids WITH SECURITY_ENFORCED];
	}

	@AuraEnabled
	public static List<MasterMapWrapper> searchFaultCodeByNameAndDescription(
		String searchText,
		List<MasterMapWrapper> faultCodes
	) {
		List<MasterMapWrapper> master = new List<MasterMapWrapper>();
		for (MasterMapWrapper m : faultCodes) {
			if (
				m.description.toUpperCase().contains(searchText.toUpperCase()) ||
				m.name.toUpperCase().contains(searchText.toUpperCase())
			) {
				master.add(m);
			}
		}
		return master;
	}

	@AuraEnabled
	public static List<Master_Map__c> searchPMActivityTypeByNameAndDescription(
		String searchText,
		List<Master_Map__c> pmActivityTypes
	) {
		List<Master_Map__c> master = new List<Master_Map__c>();
		for (Master_Map__c m : pmActivityTypes) {
			if (
				m.Description__c.toUpperCase().contains(searchText.toUpperCase()) ||
				m.Name.toUpperCase().contains(searchText.toUpperCase())
			) {
				master.add(m);
			}
		}
		return master;
	}

	@AuraEnabled
	public static String getUserName() {
		return UserInfo.getUserName();
	}

	//MAIN WORK CENTER
	@AuraEnabled
	public static List<Master_Map__c> getMainWorkCenters(Id mainWorkCenterPlantId) {
		Map<Id, Master_Map__c> mwcMasterMap = new Map<Id, Master_Map__c>();
		// if(mainWorkCenterPlantId != null) {
		// 	return [
		// 		SELECT Id, RelatedMasterMap1__r.Name, RelatedMasterMap1__r.Description__c
		// 		FROM Master_Map__c
		// 		WHERE Type__c = 'CategoryWithMainWorkCenterWithPlant' AND RelatedMasterMap2__c = :mainWorkCenterPlantId
		// 		WITH SECURITY_ENFORCED
		// 	];
		// }

		String query = String.format(
			'SELECT {0} FROM Master_Map__c WHERE Type__c = {1} {2}',
			new List<String>{
				String.join(
					new List<String>{
						'Id',
						'RelatedMasterMap1__c',
						'RelatedMasterMap1__r.Name',
						'RelatedMasterMap1__r.Description__c',
						'RelatedMasterMap2__c'
					},
					', '
				),
				'\'CategoryWithMainWorkCenterWithPlant\'',
				mainWorkCenterPlantId != null ? 'AND RelatedMasterMap2__c = \'' + mainWorkCenterPlantId + '\'' : ''
			}
		);
		List<Master_Map__c> masterMapQry = (List<Master_Map__c>) Database.query(query);
		for (Master_Map__c mwc : masterMapQry) {
			if (!mwcMasterMap.containsKey(mwc.RelatedMasterMap1__c)) {
				mwcMasterMap.put(mwc.RelatedMasterMap1__c, mwc);
			}
		}
		return mwcMasterMap.values();
	}

	//MAIN WORK CENTER PLANT
	@AuraEnabled
	public static List<Master_Map__c> getAllMainWorkCenterPlants() {
		return [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant' WITH SECURITY_ENFORCED];
	}
	@AuraEnabled
	public static Object getMainWorkCenterPlants(String mainWorkCenterId) {
		//return [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant' WITH SECURITY_ENFORCED];
		if (String.isEmpty(mainWorkCenterId)) {
			System.debug('432 >>> ' + mainWorkCenterId);
			return getAllMainWorkCenterPlants();
		}

		String mainWorkCenterCode = [
				SELECT RelatedMasterMap1__r.Code__c
				FROM Master_Map__c
				WHERE RelatedMasterMap1__c = :mainWorkCenterId
				LIMIT 1
			]
			?.RelatedMasterMap1__r
			?.Code__c;
		System.debug('mainWorkCenterCode >>> ' + mainWorkCenterCode);
		List<Object> result = new List<Object>();
		for (Master_Map__c variable : [
			SELECT
				Id,
				Name,
				Description__c,
				RelatedMasterMap1__r.Code__c,
				RelatedMasterMap2__c,
				RelatedMasterMap2__r.Name,
				RelatedMasterMap2__r.Description__c,
				RelatedMasterMap2__r.Code__c
			FROM Master_Map__c
			WHERE
				Type__c = 'CategoryWithMainWorkCenterWithPlant'
				AND RelatedMasterMap1__r.Code__c = :mainWorkCenterCode
				AND RelatedMasterMap1__r.Code__c != NULL
		]) {
			result.add(
				new Map<String, String>{
					'Id' => variable.RelatedMasterMap2__c,
					'Name' => variable.RelatedMasterMap2__r?.Name,
					'Description__c' => variable.RelatedMasterMap2__r?.Description__c,
					'Code__c' => variable.RelatedMasterMap2__r?.Code__c
				}
			);
		}
		return result;
	}

	@AuraEnabled
	public static List<Master_Map__c> searchMainWorkCenterByNameAndDescription(
		String searchText,
		List<Master_Map__c> mainWorkCenters
	) {
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

	@AuraEnabled
	public static List<Master_Map__c> searchMainWorkCenterPlantByNameAndDescription(
		String searchText,
		List<Master_Map__c> mainWorkCenterPlants
	) {
		List<Master_Map__c> master = new List<Master_Map__c>();
		for (Master_Map__c m : mainWorkCenterPlants) {
			if (
				m.Description__c.toUpperCase().contains(searchText.toUpperCase()) ||
				m.Name.toUpperCase().contains(searchText.toUpperCase())
			) {
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