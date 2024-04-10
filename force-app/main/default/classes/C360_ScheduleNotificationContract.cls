global class C360_ScheduleNotificationContract implements Schedulable {
    global void execute(SchedulableContext sc) {
        //noti
        C360_NotificationBellController.expireContractTop();
        C360_NotificationBellController.expireContractSolvent();
    }
}