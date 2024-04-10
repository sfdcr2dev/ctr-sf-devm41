@isTest
public class EMOC_TimelineFlowCalReminderDateTest {
	static testmethod void testData() {
        List<Date> paramDate = new List<Date>{System.today() + 10};
        EMOC_TimelineFlowCalReminderDate.calReminderDate(paramDate);
    }
}