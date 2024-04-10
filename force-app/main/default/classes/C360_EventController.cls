public class C360_EventController {
	@AuraEnabled
    public static String getParentId(string eventId){
        List <Event> events = [Select Parent__c from Event where Id =:eventId Limit 1];
        if(events.size() != 0){
            return events[0].Parent__c;
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static Event getParent(string eventId){
        return [Select Parent__c from Event where Id =:eventId Limit 1];
    }
}