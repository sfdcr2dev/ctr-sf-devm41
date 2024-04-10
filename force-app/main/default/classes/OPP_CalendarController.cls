public with sharing class OPP_CalendarController{
    @AuraEnabled
    public static List<Event> getTodayEvents(){
            List<Event> events = [SELECT Id,Subject,Location,ActivityDate,Description,AccountId,OwnerId,Type,StartDateTime,EndDateTime,IsAllDayEvent FROM Event where OwnerId =: UserInfo.getUserId() AND ActivityDate = today ORDER BY StartDateTime ASC];
            if(events.size() > 0) {
                return events;
            }
            return new List<Event>();
    }

    @AuraEnabled
    public static Map<String, Boolean> getDefaultMonthEvents(){
            Map<String, Boolean> eventMap = new Map<String, Boolean>();
            List<Event> events = [SELECT Id,Subject,Location,ActivityDate,Description,AccountId,OwnerId,Type,StartDateTime,EndDateTime FROM Event where OwnerId =:UserInfo.getUserId() AND ActivityDate =THIS_MONTH];
            if(events.size() > 0) {
                for(Event event : events) {
                    String d = String.valueOf(event.ActivityDate);
                    String day = d.split('-')[2];
                    eventMap.put(day, true);
                }
            }
            return eventMap;
    }

    @AuraEnabled
    public static Map<String, Boolean> getMonthEvent(Integer month, Integer year){
            Map<String, Boolean> eventMap = new Map<String, Boolean>();
            Date first = Date.newInstance(year, month, 1);
            Date last = first.addMonths(1);
            List<Event> events = [SELECT Id,Subject,Location,ActivityDate,Description,AccountId,OwnerId,Type,StartDateTime,EndDateTime FROM Event where OwnerId =:UserInfo.getUserId() AND ActivityDate >:first AND ActivityDate <:last];
            if(events.size() > 0) {
                for(Event event : events) {
                    String d = String.valueOf(event.ActivityDate);
                    String day = d.split('-')[2];
                    eventMap.put(day, true);
                }
            }
            return eventMap;
    }

    @AuraEnabled
    public static List<Event> getEvents(String activityDate){
            Date d = Date.valueOf(activityDate);
            List<Event> events = [SELECT Id, Subject, Location,ActivityDate,IsAllDayEvent,Description,AccountId,OwnerId,Type,StartDateTime,EndDateTime FROM Event where OwnerId =:UserInfo.getUserId() AND ActivityDate =:d ORDER BY StartDateTime ASC];
            return events;
    }
}