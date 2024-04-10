global class C360_ScheduleNotificationBG implements Schedulable {
    global void execute(SchedulableContext sc) {
        //noti
        C360_NotificationBellController.expireBG();
        
        //email
        C360_NotificationController.BGRemainingDaysSolvent();
        C360_NotificationController.BGRemainingDaysTop();
    }
}