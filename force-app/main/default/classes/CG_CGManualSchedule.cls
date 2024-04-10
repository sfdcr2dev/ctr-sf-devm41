/* 
 * Author Softever 
 * Schedule Class to check CG Manual when there is new employee
 */

global class CG_CGManualSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_CGManualBatchable CGManual = new CG_CGManualBatchable(); 
      Database.executeBatch(CGManual);
   }
}