public with sharing class THOR_NotificationCreationCtrl {
	@AuraEnabled
	public static Object getEquipmentByFL(Id funcLocationId) {
		return FunctionalLocationController.retrieveEquipmentsByFunctionalLocation(funcLocationId);
	}

	@AuraEnabled
	public static Object getFunctionLocationDetail(Id funcLocationId) {
		return FunctionalLocationController.retrieveFunctionalLocationById(funcLocationId);
	}

	@AuraEnabled
	public static Object getMainWorkCenterPlants(String mainWorkCenterId) {
		if (String.isEmpty(mainWorkCenterId)) {
			return FunctionalLocationController.getALlMainWorkCenterPlants();
		}

		String mainWorkCenterCode = [
				SELECT RelatedMasterMap1__r.Code__c
				FROM Master_Map__c
				WHERE RelatedMasterMap1__c = :mainWorkCenterId
				LIMIT 1
			]
			?.RelatedMasterMap1__r
			?.Code__c;
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
	public static Object getMainWorkCenters(Id mainWorkCenterPlantsId) {
		return FunctionalLocationController.getMainWorkCenters(mainWorkCenterPlantsId);
	}

	@AuraEnabled
	public static string getDepartmentResp(Id PISUserId) {
		return [SELECT ORGID__c FROM PISUsers__c WHERE Id = :PISUserId]?.ORGID__c;
	}

	private static String queryLike(String fieldName, String searchText) {
		return THOR_NotificationListPagingCtrl.conditionQuery(fieldName, 'LIKE', searchText);
	}

	@AuraEnabled
	public static List<sObject> getPISRequester(String searchText) {
		List<String> recentlyPISUserIds = new List<String>();
		if (String.isEmpty(searchText)) {
			for (RecentlyViewed variable : [
				SELECT Id, Name
				FROM RecentlyViewed
				WHERE Type = 'PISUsers__c'
				ORDER BY LastViewedDate DESC
			]) {
				recentlyPISUserIds.add(String.format('{0}', new List<String>{ '\'' + variable.Id + '\'' }));
			}
		}

		String query = String.format(
			'SELECT Id, Name, ENFIRSTNAME__c, ENLASTNAME__c, THFIRSTNAME__c, THLASTNAME__c, EMPLOYEEID__c, DEPARTMENT__c, User__c, User__r.Name, HOME_ID__c, HOST_ID__c FROM PISUsers__c WHERE {0} ORDER BY EMPLOYEEID__c LIMIT 7',
			new List<String>{
				String.isNotEmpty(searchText)
					? String.join(
							new List<String>{
								queryLike('HOME_ID__c', searchText),
								queryLike('HOST_ID__c', searchText),
								queryLike('THFIRSTNAME__c', searchText),
								queryLike('THLASTNAME__c', searchText),
								queryLike('ENFIRSTNAME__c', searchText),
								queryLike('ENLASTNAME__c', searchText),
								queryLike('DEPARTMENT__c', searchText),
								queryLike('EMPLOYEEID__c', searchText)
							},
							' OR '
					  )
					: String.format('Id IN ({0})', new List<String>{ String.join(recentlyPISUserIds, ',') })
			}
		);
		try {
			return Database.query(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Object getOrdersDetailById(Id orderId) {
		try {
			Order__c orderDetail = [
				SELECT
					Id,
					Order_Type__c,
					Functional_Location__c,
					Equipment__c,
					Description__c,
					Main_Work_Center__c,
					mainWorkCenterPlant__c,
					Start_Date__c,
					Priority__c
				FROM Order__c
				WHERE Id = :orderId
				WITH SECURITY_ENFORCED
			];

			return new Notification__c(
				Order__c = orderId,
				Type__c = orderDetail.Order_Type__c?.left(2),
				Functional_Location__c = orderDetail.Functional_Location__c,
				Equipment__c = orderDetail.Equipment__c,
				Description__c = orderDetail.Description__c,
				Main_Work_Center__c = orderDetail.Main_Work_Center__c,
				mainWorkCenterPlant__c = orderDetail.mainWorkCenterPlant__c,
				Required_Start__c = orderDetail.Start_Date__c,
				Priority__c = orderDetail.Priority__c
			);
		} catch (Exception e) {
			throw new AuraHandledException(
				String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() })
			);
		}
	}

	@AuraEnabled
	public static Object getPlannerGroupList(Id planningPlantId) {
		try {
			if (planningPlantId == null) {
				return [SELECT Id, Name, Type__c, Description__c FROM Master_Map__c WHERE Type__c = 'PlannerGroup'];
			}

			Map<Id, Master_Map__c> plannerGroup = new Map<Id, Master_Map__c>();
			for (Master_Map__c master : [
				SELECT
					RelatedMasterMap1__c,
					RelatedMasterMap1__r.Name,
					RelatedMasterMap1__r.Type__c,
					RelatedMasterMap1__r.Description__c
				FROM Master_Map__c
				WHERE Type__c = 'PlannerGroupWithPlantOrder' AND RelatedMasterMap2__c = :planningPlantId
			]) {
				if (!plannerGroup.containsKey(master.RelatedMasterMap1__c)) {
					plannerGroup.put(
						master.RelatedMasterMap1__c,
						new Master_Map__c(
							Id = master.RelatedMasterMap1__c,
							Name = master.RelatedMasterMap1__r.Name,
							Type__c = master.RelatedMasterMap1__r.Type__c,
							Description__c = master.RelatedMasterMap1__r.Description__c
						)
					);
				}
			}

			return plannerGroup.values();
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Object getPlanningPlantList(Id plannerGroupId) {
		try {
			if (plannerGroupId == null) {
				return [SELECT Id, Name, Type__c, Description__c FROM Master_Map__c WHERE Type__c = 'Plant'];
			}

			Map<Id, Master_Map__c> planningPlant = new Map<Id, Master_Map__c>();
			for (Master_Map__c master : [
				SELECT
					RelatedMasterMap2__c,
					RelatedMasterMap2__r.Name,
					RelatedMasterMap2__r.Type__c,
					RelatedMasterMap2__r.Description__c
				FROM Master_Map__c
				WHERE Type__c = 'PlannerGroupWithPlantOrder' AND RelatedMasterMap1__c = :plannerGroupId
			]) {
				if (!planningPlant.containsKey(master.RelatedMasterMap2__c)) {
					planningPlant.put(
						master.RelatedMasterMap2__c,
						new Master_Map__c(
							Id = master.RelatedMasterMap2__c,
							Name = master.RelatedMasterMap2__r.Name,
							Type__c = master.RelatedMasterMap2__r.Type__c,
							Description__c = master.RelatedMasterMap2__r.Description__c
						)
					);
				}
			}

			return planningPlant.values();
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
    
    @AuraEnabled
	public static Notification__c getNotificationById(String notificationId) {
		return [
			SELECT
				Id,
				Name,
				Fault_Code__c,
				Main_Work_Center__c,
				mainWorkCenterPlant__c,
            	Functional_Location__r.Description__c,
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
	public static String getUserName() {
		return UserInfo.getUserName();
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
}