/**
 * @author Sebastian Bucalo
 * @description helper for SetWCToNotification Trigger
 */
public with sharing class SetWCToNotificationHelper{
	/**
	 * @description updates the notification with the newest Work_Clearance__c object
	 * @param wcList
	 */
	public static void updateNotification(List<Work_Clearance__c> wcList){

		Notification__c notification = null;
		boolean upd = false;
		if (wcList != null && wcList.size() > 0){
			if (wcList[0].Notification__c != null){
				Work_Clearance__c wc = wcList[0];
				notification = [Select id, Name, Work_Clearance__r.id, Work_Clearance__r.Name, Work_Clearance__r.createdDate
				                                From Notification__c
				                                Where id = :wcList[0].Notification__c][0];

				if (notification.Work_Clearance__r.id == null || wc.createdDate > notification.Work_Clearance__r.createdDate){
					notification.Work_Clearance__c = wc.id;

					upd = true;
				}
			}
		}

		if (upd && Schema.sObjectType.Notification__c.isUpdateable()){
			update notification;
		}
	}
}