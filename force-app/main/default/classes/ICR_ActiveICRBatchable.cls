/* 
 * Author Softever 
 * Batchable Class to Active ICR when Start Date reach
 */

global class ICR_ActiveICRBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ICR_ActiveICRController AutoActiveICR = new ICR_ActiveICRController(); 
      Database.executeBatch(AutoActiveICR);
   }
}