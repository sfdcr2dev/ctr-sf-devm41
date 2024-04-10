/* 
 * Author Softever 
 * Batchable Class to change ESS Retirement status when no section head or department head approve
 */

global class ESS_RetirementAutoChangeStatusBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_RetirementAutoChangeStatusController RetirementAutoChangeStatus = new ESS_RetirementAutoChangeStatusController(); 
      Database.executeBatch(RetirementAutoChangeStatus);
   }
}