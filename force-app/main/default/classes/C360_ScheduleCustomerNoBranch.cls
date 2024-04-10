global class  C360_ScheduleCustomerNoBranch implements Schedulable
{
	global void execute(SchedulableContext sc) {
        	C360_CustomerNoBranch.AccountList();
    }
}