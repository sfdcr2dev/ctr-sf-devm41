global class C360_ScheduleSalesareaTs implements Schedulable
{
	  global void execute(SchedulableContext sc) {
        C360_SalesareaTsBatch b = new C360_SalesareaTsBatch(); 
        database.executebatch(b,200);
    }
}