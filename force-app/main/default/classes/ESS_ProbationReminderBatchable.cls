/* 
 * Author Softever 
 * Batchable Class to control ESS Probation Reminder for Section Head and Department Head
 */

global class ESS_ProbationReminderBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_ProbationReminderController ProbationReminderEmail = new ESS_ProbationReminderController(); 
      Database.executeBatch(ProbationReminderEmail);
   }
}