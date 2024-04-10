/* 
 * Author Softever 
 * Batchable Class to change ESS Retirement status when employee not submit on time
 */

global class ESS_RetirementSubmitStatusBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_RetirementSubmitStatusController RetirementSubmitChangeStatus = new ESS_RetirementSubmitStatusController(); 
      Database.executeBatch(RetirementSubmitChangeStatus);
   }
}