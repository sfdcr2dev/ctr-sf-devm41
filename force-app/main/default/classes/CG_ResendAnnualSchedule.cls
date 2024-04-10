/* 
 * Author Softever 
 * Schedule Class to check Resend Annual according to schedule.
 */

global class CG_ResendAnnualSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_ResendAnnualBatchable ResendAnnual = new CG_ResendAnnualBatchable(); 
      Database.executeBatch(ResendAnnual);
   }
}