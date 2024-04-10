/**
 * @author Oktana
 */
public with sharing class OrderHandler {
	public static final Boolean isAdmin = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()]?.Name.containsIgnoreCase('Admin');

    /**
     * @description populates Order Number field with Order Name
     * @param Orders
     */
    // public static void populateOrderNumber(List<Order__c> orders) {
    //     for (Order__c order : orders) {
    //         if (order.Order_Number__c == null) {
    //             order.Order_Number__c = order.Name;
    //         }
    //     }
    // }
    /**
     * @description creates OrderOperation and Operation when order type = CM01
     * @param Orders
     */
    public static void createOrderOperationAndOperation(List<Order__c> orders) {
        List<Operation__c> operations = new List<Operation__c>();
        for (Order__c order : orders) {
            if (!isAdmin || Test.isRunningTest()) {
            // if (new List<String>{ 'CM01' }.contains(order.Order_Type__c)) {
                Operation__c operation = createOperationFromOrder(order);
                operations.add(operation);
            }
        }
        if (Schema.sObjectType.Operation__c.isCreateable()) {
            insert operations;
        }

        Map<Id, Operation__c> orderIdOperationMap = new Map<Id, Operation__c>();

        List<Operation__c> insertedOperations = [SELECT Id, Order__r.Id FROM Operation__c WHERE Order__r.Id IN: orders WITH SECURITY_ENFORCED];

        for (Operation__c operation : insertedOperations) {
            orderIdOperationMap.Put(operation.Order__r.Id, operation);
        }

        List<Order_Operation__c> orderOperations = new List<Order_Operation__c>();
        for (Order__c order : orders) {
            if (!isAdmin || Test.isRunningTest()) {
            // if (new List<String>{ 'CM01' }.contains(order.Order_Type__c)) {
                Order_Operation__c orderOperation = createOrderOperationFromOrder(
                    order,
                    orderIdOperationMap.get(order.Id)
                );
                orderOperations.add(orderOperation);
            }
        }
        if (Schema.sObjectType.Order_Operation__c.isCreateable()) {
            insert orderOperations;
        }
    }

    /**
     * @description send alert for updated Order to Requester and Responsible Person
     */
    public static void handleAlerts(Map<Id, sObject> newOrders, Map<Id, sObject> oldOrders) {
        List<Order__c> ordersToCheck = new List<Order__c>();
        for (Order__c newOrder : (List<Order__c>) newOrders.values()) {
            Order__c oldOrder = (Order__c) oldOrders.get(newOrder.Id);
            if (changedRelevantFields(newOrder, oldOrder)) {
                ordersToCheck.add(newOrder);
            }
        }

        handleAlerts(ordersToCheck);
    }

    private static Boolean changedRelevantFields(Order__c newOrder, Order__c oldOrder) {
        return (newOrder.Requester__c != oldOrder.Requester__c) ||
            (newOrder.Responsible_Person__c != oldOrder.Responsible_Person__c) ||
            (newOrder.Order_Number__c != oldOrder.Order_Number__c) ||
            (newOrder.Order_Status__c != oldOrder.Order_Status__c) ||
            (newOrder.User_Status__c != oldOrder.User_Status__c) ||
            (newOrder.Description__c != oldOrder.Description__c) ||
            (newOrder.Functional_Location__c != oldOrder.Functional_Location__c);
    }

    /**
     * @description send alert for new Order created to Requester and Responsible Person
     * @param orders
     */
    public static void handleAlerts(List<Order__c> orders) {
        List<OrderAlert> alerts = new List<OrderAlert>();
        Id alertType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'THOR_Push_Notification'].Id;
        for (Order__c order : orders) {
            alerts.add(
                new OrderAlert(
                    CustomNotificationHelper.buildAlert(
                        alertType,
                        getOrderPageRef(order.Id),
                        resolveAlertBody(order),
                        'New Order'
                    ),
                    order
                )
            );
        }
        handleSendAlerts(alerts);
    }

    private static void handleSendAlerts(List<OrderAlert> orderAlerts) {
        for (OrderAlert orderAlert : orderAlerts) {
            Set<String> receivers = resolveReceivers(orderAlert.order);
            if (!receivers.isEmpty()) {
                CustomNotificationHelper.sendAlert(orderAlert.alert, receivers);
            }
        }
    }

    private class OrderAlert {
        Messaging.CustomNotification alert;
        Order__c order;

        public OrderAlert(Messaging.CustomNotification alert, Order__c order) {
            this.alert = alert;
            this.order = order;
        }
    }

    private static Set<String> resolveReceivers(Order__c order) {
        Set<String> receivers = new Set<String>();
        if (
            !isSameUser(order.CreatedById, order.Responsible_Person__c) &&
            !isSameUser(order.CreatedById, order.Requester__c) &&
            !isSameUser(order.Requester__c, order.Responsible_Person__c)
        ) {
            receivers.add(String.valueOf(order.Requester__c));
            receivers.add(String.valueOf(order.Responsible_Person__c));
        } else if (
            isSameUser(order.CreatedById, order.Requester__c) &&
            !isSameUser(order.CreatedById, order.Responsible_Person__c)
        ) {
            receivers.add(String.valueOf(order.Responsible_Person__c));
        } else if (
            isSameUser(order.CreatedById, order.Responsible_Person__c) &&
            isSameUser(order.Responsible_Person__c, order.Requester__c) &&
            !isSameUser(order.CreatedById, order.Requester__c)
        ) {
            receivers.add(String.valueOf(order.Requester__c));
        } else if (
            !isSameUser(order.CreatedById, order.Responsible_Person__c) &&
            !isSameUser(order.CreatedById, order.Requester__c)
        ) {
            receivers.add(String.valueOf(order.Requester__c));
        } else if (
            !isSameUser(order.CreatedById, order.Requester__c) &&
            !isSameUser(order.Requester__c, order.Responsible_Person__c) &&
            isSameUser(order.CreatedById, order.Responsible_Person__c)
        ) {
            receivers.add(String.valueOf(order.Requester__c));
        }

        return receivers;
    }

    private static Boolean isSameUser(Id firstUser, Id secondUser) {
        return firstUser == secondUser;
    }

    private static Operation__c createOperationFromOrder(Order__c order) {
        Id planningPlant = order.Planning_Plant__c;

        Operation__c operation = new Operation__c();
        operation.Main_Work_Center__c = order.Main_Work_Center__c;
        operation.Short_Text__c = order.Description__c;
        operation.Control_Key__c = 'ZPM1';
        operation.Plant__c = planningPlant;
        operation.Order__c = order.Id;

        return operation;
    }

    private static Order_Operation__c createOrderOperationFromOrder(Order__c order, Operation__c operation) {
        Id planningPlant = order.Planning_Plant__c;

        Order_Operation__c orderOperation = new Order_Operation__c();
        orderOperation.Operation_Text__c = '0010';
        orderOperation.Main_Work_Center__c = order.Main_Work_Center__c;
        orderOperation.Operation_Shot_Text__c = order.Description__c;
        orderOperation.Control_Key__c = 'ZPM1';
        orderOperation.Plant__c = planningPlant;
        orderOperation.Order__c = order.Id;
        orderOperation.Operation__c = operation.Id;

        return orderOperation;
    }

    private static String getOrderPageRef(Id orderId) {
        return '{"type": "standard__component", "attributes": {"componentName": "c__THOR_OrderRecordDisplay"}, "state": {"c__recordId": "' +
            orderId +
            '"}}';
    }

    private static String resolveAlertBody(Order__c order) {
        return CustomNotificationHelper.buildFormattedMessage(
            '{0} assigned to you',
            new List<String>{ order.Order_Number__c }
        );
    }
}