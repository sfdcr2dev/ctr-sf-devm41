/* 
 * Author Softever 
 * Schedule Class to check COICG Annual
 */

global class CG_COICGAnnualSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_COICGAnnualBatchable COICGAnnual = new CG_COICGAnnualBatchable(); 
      Database.executeBatch(COICGAnnual);
   }
}