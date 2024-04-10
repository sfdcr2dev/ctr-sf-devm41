global class C360_ScheduleNotificationOutstanding implements Schedulable {
    global void execute(SchedulableContext sc) {
        //email
        C360_NotificationController.overOutstandingSolvent();
        C360_NotificationController.overOutstandingTop();
    }
}