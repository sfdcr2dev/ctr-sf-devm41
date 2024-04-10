/* 
 * Author Softever 
 * Batchable Class to control ESS Probation Admin Reminder
 */

global class ESS_ProbationAdminReminderBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_ProbationAdminReminderController ProbationReminderEmail = new ESS_ProbationAdminReminderController(); 
      Database.executeBatch(ProbationReminderEmail);
   }
}