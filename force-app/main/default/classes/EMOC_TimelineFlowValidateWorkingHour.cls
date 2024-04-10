public class EMOC_TimelineFlowValidateWorkingHour {
	@InvocableMethod
    public static List<Boolean> validateWorkingHour(List<DateTime> currentDateTime) {
        DateTime paraDateTime = currentDateTime[0];
        String todayDay = paraDateTime.format('EEEE');
        List<Boolean> flgWorkingHour = new List<Boolean>();
        if (todayDay == 'Saturday' || todayDay =='Sunday') {
            for (integer i = 0; i < currentDateTime.size(); i++) {
                flgWorkingHour.add(false);
            }
        } else {
            Date currentDate = Date.newInstance(paraDateTime.year(), paraDateTime.month(), paraDateTime.day());
            for(Holiday forHoliday : [Select ActivityDate from Holiday]) {
                if (forHoliday.ActivityDate == currentDate) {
                    for (integer i = 0; i < currentDateTime.size(); i++) {
                        flgWorkingHour.add(false);
                    }
                }
            }
        }
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
        if (flgWorkingHour.size() == 0) {
            for (integer i = 0; i < currentDateTime.size(); i++) {
                flgWorkingHour.add(BusinessHours.isWithin(bh.id, paraDateTime));
            }
        }
        return flgWorkingHour;
    }
}