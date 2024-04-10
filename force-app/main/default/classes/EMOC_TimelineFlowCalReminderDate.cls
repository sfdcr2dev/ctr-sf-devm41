global class EMOC_TimelineFlowCalReminderDate {
    @InvocableMethod
    public static List<Date> calReminderDate(List<Date> reminderDate) {
        Date paraReminderDate = reminderDate[0];
        Set<Date> holidaysSet = new Set<Date>();  
         
        for(Holiday currHoliday : [Select ActivityDate from Holiday])  
        {  
            holidaysSet.add(currHoliday.ActivityDate);  
        }  
         
        Integer cntHoliday = 0;
        Date currentDate = System.today();
        Integer lengthDate = currentDate.daysBetween(paraReminderDate);
        for(integer i = 0; i <= lengthDate; i++) {
            Date dt = currentDate + i;  
            DateTime forDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
            String todayDay = forDate.format('EEEE');
            if(todayDay == 'Friday' || todayDay == 'Saturday' || (holidaysSet.contains(dt))) {
                cntHoliday = cntHoliday + 1;
            }
        }
        List<Date> returnDate = new List<Date>();
        for (integer i = 0; i < reminderDate.size(); i++) {
            returnDate.add(paraReminderDate + cntHoliday);
        }
        return returnDate;
    }
}