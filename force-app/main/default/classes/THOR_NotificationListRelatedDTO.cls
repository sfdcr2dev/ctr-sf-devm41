/**
 * @author Sebastian Vera
 * @description Data Transfer Object used to Transfer Data to THOR_NotificationListRelated.cmp
 */
public class THOR_NotificationListRelatedDTO {
	/**
	 *@description notification id
	 */
	@AuraEnabled
	public String orderId { get; set; }

	/**
	 * @description all related Item__c
	 */
	@AuraEnabled
	public List<THOR_ObjectCardDTO> relatedItems { get; set; }

	/**
	 * @description all related sub Orders
	 */
	@AuraEnabled
	public List<Order__c> relatedSubOrders { get; set; }

	/**
	 * @description List of files
	 */
	@AuraEnabled
	public List<DocumentWrapper> files { get; set; }

	/**
	 * @description Notification List of files
	 */
	@AuraEnabled
	public List<Notification_File__c> notification_files { get; set; }

	/**
	 * @description Notification List of files
	 */
	@AuraEnabled
	public Notification__c notificationObj { get; set; }

	/**
	 * @description Notification List of files
	 */
	@AuraEnabled
	public Boolean hasEditAccess {
		get {
			return hasEditAccess != null ? hasEditAccess : false;
		}
		set;
	}
}