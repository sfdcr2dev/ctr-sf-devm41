/* 
 * Author Softever 
 * Batchable Class to control ESS Clear Data Controler
 */

global class ESS_ClearDataBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ESS_ClearDataController ClearData = new ESS_ClearDataController(); 
      Database.executeBatch(ClearData);
   }
}