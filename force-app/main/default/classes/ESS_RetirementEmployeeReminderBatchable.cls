/* 
 * Author Softever 
 * Batchable Class ESS Retirement to send email to employee for reminder
 */

global class ESS_RetirementEmployeeReminderBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_RetirementEmployeeReminderController RetirementReminder = new ESS_RetirementEmployeeReminderController(); 
      Database.executeBatch(RetirementReminder);
   }
}