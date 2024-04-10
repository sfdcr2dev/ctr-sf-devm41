global class WP28ScheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      WP28NotificationController WP28Schedule = new WP28NotificationController(); 
      Database.executeBatch(WP28Schedule);
   }
}