/* 
 * Author Softever 
 * Schedule Class to send email to Supervisor and GLVP for Mass Acknowledge
 */

global class CG_COIMassAcknowledgeSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_COIMassAcknowledgeBatchable CGMassAcknowledge = new CG_COIMassAcknowledgeBatchable(); 
      Database.executeBatch(CGMassAcknowledge);
   }
}