/* 
 * Author Softever 
 * Batchable Class to Expire ICR when End Date reach
 */

global class ICR_ExpireICRBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ICR_ExpireICRController AutoExpireICR = new ICR_ExpireICRController(); 
      Database.executeBatch(AutoExpireICR);
   }
}