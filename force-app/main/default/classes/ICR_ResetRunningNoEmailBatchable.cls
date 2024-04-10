/* 
 * Author Softever 
 * Batchable Class to control Committee Expire Email 
 */

global class ICR_ResetRunningNoEmailBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ICR_ResetRunningNoController ResetRunningNoEmail = new ICR_ResetRunningNoController(); 
      Database.executeBatch(ResetRunningNoEmail);
   }
}