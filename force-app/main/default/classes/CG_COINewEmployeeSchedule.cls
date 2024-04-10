/* 
 * Author Softever 
 * Schedule Class to check COI New Employee when there is new employee
 */

global class CG_COINewEmployeeSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CG_COINewEmployeeBatchable CGCOINewEmployee = new CG_COINewEmployeeBatchable(); 
      Database.executeBatch(CGCOINewEmployee);
   }
}