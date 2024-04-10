/**
* @author Alejandro Lugo
* @description Data Transfer Object used to transfer data to THOR_OrderListRelated.cmp
*/
public class THOR_OrderListRelatedDTO {

    /**
     * @description List of related Notifications
     */
    @AuraEnabled
    public List<Notification__c> relatedNotifications {get; set;}

    /**
     * @description List of related Sub Orders
     */
    @AuraEnabled
    public List<Order__c> relatedSubOrders {get; set;}

    /**
     * @description List of related Operations
     */
    @AuraEnabled
    public List<Order_Operation__c> relatedOperations {get; set;}
}