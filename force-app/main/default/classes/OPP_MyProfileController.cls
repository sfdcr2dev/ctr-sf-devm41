public with sharing class OPP_MyProfileController {
    
    @AuraEnabled
    public static User getUser() {
        User user = [SELECT Id, Name, UserRole.Name, FullPhotoUrl, CommunityNickname, CompanyName, Employee_Id__c, Profile.Name, Section__c,
                     Function__c, Phone, Department, Division, Tel__c, Unit__c, Address, Email, Position__c, OPP_Total_Coin__c, FirstName_TH__c,
                     LastName_TH__c, Company_Code__c, FirstName_EN__c, LastName_EN__c, FirstName
                     FROM User WHERE Id =: userInfo.getUserId()];
        return user;
    }

    /*@AuraEnabled
    public static String getUrl(Id Id){
        try {
            String url = [SELECT Id, Url__c FROM OPP_Notification__c WHERE Id =: Id].Url__c;
            return url;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled
    public static Decimal getCoinBalance(){
        //OPP_CoinController.UpdateCoin();
        Id userId = UserInfo.getUserId();
        Decimal coinBalance = 0;

        User user = [SELECT Id, OPP_Total_Coin__c FROM User WHERE Id = :userId LIMIT 1];
        if (user != null && user.OPP_Total_Coin__c != null) {
            coinBalance = Decimal.valueOf(user.OPP_Total_Coin__c);
        }

        return coinBalance;
    }
}