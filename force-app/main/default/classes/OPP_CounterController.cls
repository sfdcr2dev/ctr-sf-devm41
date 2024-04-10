public class OPP_CounterController {
    
    @AuraEnabled
	public static void addCounter(String page) {
        
        Id userId = UserInfo.getUserId();
        OPP_Counter__c oppCounter = new OPP_Counter__c();
        
        oppCounter.Page__c = page;
        oppCounter.User__c = userId;
        
        insert oppCounter;
    }
}