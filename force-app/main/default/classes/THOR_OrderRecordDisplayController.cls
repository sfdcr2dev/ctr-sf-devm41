/**
 * @author Oktana
 * @description controller class for THOR_OrderRecordDisplay component
 */
public with sharing class THOR_OrderRecordDisplayController {
	@AuraEnabled
	public static Boolean hasWriteAccess(String recordId) {
		List<UserRecordAccess> access = [
			SELECT RecordId
			FROM UserRecordAccess
			WHERE HasEditAccess = TRUE AND RecordId = :recordId AND UserId = :UserInfo.getUserId()
		];
		return !access.isEmpty();
	}

	/**
	 * @description checks if order can be closed, if so, closes it. Returns message and status
	 * @param orderId
	 * @return CloseOrderStatus
	 */
	@AuraEnabled
	public static CloseOrderStatus getCloseOrderStatus(Id orderId) {
		CloseOrderStatus closeOrderStatus = null;
		Boolean disableButton = true;
		Boolean canClose = true;

		Order__c order = [
			SELECT
				Id,
				Name,
				(SELECT Id, Name, System_Status_Text__c FROM Orders__r),
				(SELECT Id, Name, Fault_Code__c FROM Notifications__r),
				(SELECT Id, Name FROM Spare_Part_Requests__r),
				(SELECT Id, Name FROM Work_Clearances__r),
				Work_Clearance__c,
				System_Status_Text__c
			FROM Order__c
			WHERE Id = :orderId
			WITH SECURITY_ENFORCED
		];
		//look if has sub orders, notifications or component requests
		//if size > 0 for any then can't click the button
		if (
			order.Orders__r.size() > 0 ||
			order.Notifications__r.size() > 0 ||
			order.Spare_Part_Requests__r.size() > 0
		) {
			//look if order system status does not contain WOCO when order has workclearance
			//if does not contain WOCO can't close
			if (order.Work_Clearances__r.size() > 0) {
				if (order.System_Status_Text__c == null || !order.System_Status_Text__c.contains('WOCO')) {
					closeOrderStatus = new closeOrderStatus(
						!disableButton,
						!canClose,
						'Order status does not contain WOCO'
					);
				}
			}

			//look for order status without TECO
			//if any does not contain TECO then can't close
			if (closeOrderStatus == null) {
				closeOrderStatus = checkSubOrders(order, disableButton, canClose);
			}

			//look for notification without fault code
			//if any is null then can't close
			if (closeOrderStatus == null) {
				closeOrderStatus = checkNotifications(order, disableButton, canClose);
			}
		}

		//if all checks are ok then can close
		if (closeOrderStatus == null) {
			closeOrderHelper(order);
			closeOrderStatus = new closeOrderStatus(disableButton, canClose, 'The order was closed');
		}

		return closeOrderStatus;
	}

	/**
	 * @description helper method that closes an order
	 * @param order
	 * @return Boolean
	 */
	private static Boolean closeOrderHelper(Order__c order) {
		Boolean closed = false;
		try {
			// order.System_Status_Text__c = order.System_Status_Text__c + ' TECO';
			// order.Order_Status__c = 'Closed';
			order.Close_Date__c = Date.today();
			order.Request_Close__c = true;
			/**
				@Project Thor2 - Integration and Improvement
				@Description Callout service to close Order
			 */
			order.Integration_Status__c = 'In Progress';

			if (Schema.sObjectType.Order__c.isUpdateable()) {
				update order;
				closed = true;
			}
		} catch (Exception ex) {
			throw new AuraHandledException('Something went wrong...');
		}

		return closed;
	}

	/**
	 * @description helper method that checks if at least one sub order has status TECO
	 * @param order, disableButton, canClose
	 * @return CloseOrderStatus
	 */
	private static CloseOrderStatus checkSubOrders(Order__c order, Boolean disableButton, Boolean canClose) {
		CloseOrderStatus closeOrderStatus = null;
		for (Order__c o : order.Orders__r) {
			if (o.System_Status_Text__c == null || !o.System_Status_Text__c.contains('TECO')) {
				closeOrderStatus = new closeOrderStatus(
					!disableButton,
					!canClose,
					'At least one suborder has not status TECO'
				);
				break;
			}
		}
		return closeOrderStatus;
	}

	/**
	 * @description helper method that checks if at least one notification has not fault code
	 * @param order, disableButton, canClose
	 * @return CloseOrderStatus
	 */
	private static CloseOrderStatus checkNotifications(Order__c order, Boolean disableButton, Boolean canClose) {
		CloseOrderStatus closeOrderStatus = null;
		for (Notification__c n : order.Notifications__r) {
			if (n.Fault_Code__c == null) {
				closeOrderStatus = new closeOrderStatus(
					!disableButton,
					!canClose,
					'At least one notification has not fault code'
				);
				break;
			}
		}
		return closeOrderStatus;
	}

	public class CloseOrderStatus {
		CloseOrderStatus(boolean disableButton, boolean canClose, String message) {
			this.disableButton = disableButton;
			this.canClose = canClose;
			this.message = message;
		}

		@AuraEnabled
		public boolean disableButton { get; set; }

		@AuraEnabled
		public boolean canClose { get; set; }

		@AuraEnabled
		public String message { get; set; }
	}

	@AuraEnabled
	public static void setTimeoutOrder(String orderId) {
		try {
			update new Order__c(Id = orderId, Integration_Status__c = 'Failed', Integration_Message__c = '');
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<Order__c> getSubOrdersListRelatedByStatus(String recordId, Map<String, String> filter) {
		List<String> conditions = new List<String>();
		for (String varKey : filter.keySet()) {
			if (String.isNotEmpty(filter.get(varKey))) {
				conditions.add(filter.get(varKey));
			}
		}
		String query = String.format(
			'SELECT {0} FROM Order__c WHERE Super_Order__c = :recordId AND Super_Order__c != NULL {1}',
			new List<Object>{
				String.join(
					new List<String>{
						'Id',
						'Name',
						'Order_Number__c',
						'Order_Status__c',
						'Order_Type__c',
						'Functional_Location__r.Name',
						'Priority__c',
						'CreatedDate',
						'Description__c'
					},
					', '
				),
				conditions.size() > 0 ? 'AND ' + String.join(conditions, ' AND ') : ''
			}
		);
		System.debug(query);
		return (List<Order__c>) Database.query(query);
	}

	@AuraEnabled
	public static List<Notification__c> getNotificationRelatedByStatus(String recordId, Map<String, String> filter) {
		List<String> conditions = new List<String>();
		for (String varKey : filter.keySet()) {
			if (String.isNotEmpty(filter.get(varKey))) {
				conditions.add(filter.get(varKey));
			}
		}
		String query = String.format(
			'SELECT {0} FROM Notification__c WHERE Order__c = :recordId AND Order__c != NULL {1}',
			new List<Object>{
				String.join(
					new List<String>{
						'Id',
						'Name',
						'Notification_Number__c',
						'Notification_Status__c',
						'Type__c',
						'Functional_Location__r.Name',
						'Priority__c',
						'Requested_Date__c',
						'Description__c'
					},
					', '
				),
				conditions.size() > 0 ? 'AND ' + String.join(conditions, ' AND ') : ''
			}
		);
		System.debug(query);
		return (List<Notification__c>) Database.query(query);
	}

	@AuraEnabled
	public static List<Order_Operation__c> getOrderOperationRelated(String recordId) {
		String query = String.format(
			'SELECT {0} FROM Order_Operation__c WHERE Order__c = :recordId AND Order__c != NULL',
			new List<Object>{
				String.join(
					new List<String>{
						'Id',
						'Name',
						'Operation__r.Name',
						'SubOperation__c',
						'Main_Work_Center_Text__c',
						'Operation_Shot_Text__c'
					},
					', '
				)
			}
		);
		System.debug(query);
		return (List<Order_Operation__c>) Database.query(query);
	}
}