/* 
 * Author Softever 
 * Batchable Class to control ESS Retirement Admin Reminder
 */

global class ESS_RetirementAdminReminderBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_RetirementAdminReminderController RetirementReminderEmail = new ESS_RetirementAdminReminderController(); 
      Database.executeBatch(RetirementReminderEmail);
   }
}