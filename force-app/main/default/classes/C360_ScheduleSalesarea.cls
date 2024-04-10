global class  C360_ScheduleSalesarea implements Schedulable
{
	  global void execute(SchedulableContext sc) {
        C360_SalesareaBatch b = new C360_SalesareaBatch(); 
        database.executebatch(b,200);
    }
}