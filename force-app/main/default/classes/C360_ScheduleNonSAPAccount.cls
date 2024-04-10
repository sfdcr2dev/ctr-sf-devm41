global class C360_ScheduleNonSAPAccount implements Schedulable
{
	global void execute(SchedulableContext sc) {
        C360_NonSAPAccountSoldtoBatch a = new C360_NonSAPAccountSoldtoBatch(); 
        database.executebatch(a,200);
        C360_NonSAPAccountShiptoBatch b = new C360_NonSAPAccountShiptoBatch(); 
        database.executebatch(b,200);
    }
}