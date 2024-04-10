@isTest
public class EMOC_TimelineFlowValidateWorkingHourTest {
	static testmethod void testData() {
        List<DateTime> paramDate = new List<DateTime>{System.now()};
        EMOC_TimelineFlowValidateWorkingHour.validateWorkingHour(paramDate);
        
        List<DateTime> paramDate4 = new List<DateTime>{System.today() + 2};
        EMOC_TimelineFlowValidateWorkingHour.validateWorkingHour(paramDate4);
        
        List<DateTime> paramDate2 = new List<DateTime>{System.today() + 5};
        EMOC_TimelineFlowValidateWorkingHour.validateWorkingHour(paramDate2);
        
        List<DateTime> paramDate3 = new List<DateTime>{System.today() + 10};
        EMOC_TimelineFlowValidateWorkingHour.validateWorkingHour(paramDate3);
    }
}