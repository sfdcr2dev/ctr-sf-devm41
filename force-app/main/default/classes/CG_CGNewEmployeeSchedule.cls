/* 
 * Author Softever 
 * Schedule Class to check CG New Employee when there is new employee and according to schedule.
 */

global class CG_CGNewEmployeeSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_CGNewEmployeeBatchable CGNewEmployee = new CG_CGNewEmployeeBatchable(); 
      Database.executeBatch(CGNewEmployee);
   }
}