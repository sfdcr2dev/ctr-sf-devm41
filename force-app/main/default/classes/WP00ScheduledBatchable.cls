global class WP00ScheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      Step00NotificationController WP00Schedule = new Step00NotificationController(); 
      Database.executeBatch(WP00Schedule);
   }
}