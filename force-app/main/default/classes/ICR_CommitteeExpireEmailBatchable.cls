/* 
 * Author Softever 
 * Batchable Class to control Committee Expire Email 
 */

global class ICR_CommitteeExpireEmailBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ICR_CommitteeExpireEmailController ExpireReminderEmail = new ICR_CommitteeExpireEmailController(); 
      Database.executeBatch(ExpireReminderEmail);
   }
}