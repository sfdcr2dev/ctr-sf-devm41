public class C360_AccountController {
	@AuraEnabled
    public static Account getAccountLocation(string accountId){
        return [Select Id,Name,Location__Latitude__s,Location__Longitude__s from Account where Id =: accountId];
    }
}