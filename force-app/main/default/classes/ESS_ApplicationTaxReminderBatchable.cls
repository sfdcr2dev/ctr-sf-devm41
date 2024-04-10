/* 
 * Author Softever 
 * Batchable Class to control ESS Application Tax Reminder Controler
 */

global class ESS_ApplicationTaxReminderBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_ApplicationTaxReminderController ApplicationTax = new ESS_ApplicationTaxReminderController(); 
      Database.executeBatch(ApplicationTax);
   }
}