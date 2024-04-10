/* 
 * Author Softever 
 * Schedule Class to check COI Annual when there is new employee
 */

global class CG_COIAnnualSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_COIAnnualBatchable CGCOIAnnual = new CG_COIAnnualBatchable(); 
      Database.executeBatch(CGCOIAnnual);
   }
}