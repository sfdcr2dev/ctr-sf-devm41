public with sharing class THOR_NotificationAndOrderCtrl {
	// private static String conditionQuery(String apiField, String operator, String val) {
	// 	if (operator.equalsIgnoreCase('LIKE')) {
	// 		val = String.valueOf(val).replace('*', '%');
	// 		if (!val.contains('%'))
	// 			val = '%' + val + '%';
	// 	}

	// 	return String.format('{0} {1} {2}', new List<String>{ apiField, operator, '\'' + val + '\'' });
	// }

	@AuraEnabled
	public static Object getNotificationsByFilter(Map<String, Object> filter) {
		List<String> shareIds = MethodUtils.getMysObjectEditAcess('Notification__c');
		return new Map<String, Object>{
			'status_new' => new Map<String, Object>{
				'count' => THOR_NotificationListPagingCtrl.getCountNewNotificationsByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					shareIds
				),
				'records' => THOR_NotificationListPagingCtrl.getNewNotificationsByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					0,
					3,
					shareIds
				)
			},
			'status_inprogess' => new Map<String, Object>{
				'count' => THOR_NotificationListPagingCtrl.getCountInProgressNotificationsByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					shareIds
				),
				'records' => THOR_NotificationListPagingCtrl.getInProgressNotificationsByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					0,
					3,
					shareIds
				)
			}
		};
	}

	@AuraEnabled
	public static Object getOrdersByFilter(Map<String, Object> filter) {
		List<String> shareIds = MethodUtils.getMysObjectEditAcess('Order__c');
		return new Map<String, Object>{
			'status_new' => new Map<String, Object>{
				'count' => THOR_NotificationListPagingCtrl.getCountNewOrdersByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					shareIds
				),
				'records' => THOR_NotificationListPagingCtrl.getNewOrdersByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					0,
					3,
					shareIds
				)
			},
			'status_inprogess' => new Map<String, Object>{
				'count' => THOR_NotificationListPagingCtrl.getCountInProgressOrdersByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					shareIds
				),
				'records' => THOR_NotificationListPagingCtrl.getInProgressOrdersByFilter(
					(Map<String, Object>) MethodUtils.deserializeObject(filter),
					0,
					3,
					shareIds
				)
			}
		};
	}
}