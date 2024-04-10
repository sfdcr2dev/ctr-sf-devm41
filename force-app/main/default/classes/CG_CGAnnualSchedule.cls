/* 
 * Author Softever 
 * Schedule Class to check CG Annual when there is new employee
 */

global class CG_CGAnnualSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_CGAnnualBatchable CGAnnual = new CG_CGAnnualBatchable(); 
      Database.executeBatch(CGAnnual);
   }
}