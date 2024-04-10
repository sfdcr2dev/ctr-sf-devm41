global class C360_ScheduleNotificationExciseQuota implements Schedulable {
    global void execute(SchedulableContext sc) {
        //noti
        C360_NotificationBellController.expireExciseSolvent();
        
        //email
        C360_NotificationController.exciseQuotaSolvent();
    }
	
}