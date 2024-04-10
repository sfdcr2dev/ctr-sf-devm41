public without sharing class OPP_NewsController {

    @AuraEnabled
    public static List<String> getCategoryPicklist() {
        Schema.DescribeFieldResult fieldResult = OPP_News__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> picklists = fieldResult.getPicklistValues();
        List<String> categories = new List<String>{'All'};
        for (Schema.PicklistEntry picklist : picklists) {
            if (picklist.getLabel() != 'TOP Shop' && picklist.getLabel() != 'Special Issues') {
                categories.add(picklist.getLabel());
            }
        }
        return categories;
    }

    @AuraEnabled
    public static List<OPP_News__c> getAllNews() {
        Id userId = UserInfo.getUserId();
        return [SELECT Id,Name,Title__c,Subtitle__c,Thumbnail__c,Highlight__c,Category__c,Sub_Category__c,Coin__c,Coin_Type__c,Publish_Date__c,View__c,Status__c,
                (SELECT Id FROM OPP_News_Coin__r WHERE Action__c ='Read' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg','png') ORDER BY SystemModstamp DESC)
            FROM OPP_News__c WHERE Category__c NOT IN ('TOP Shop','Special Issues') ORDER BY Publish_Date__c DESC, LastModifiedDate DESC];
    }

    @AuraEnabled
    public static List<OPP_News__c> getAllPublishedNews() {
        Id userId = UserInfo.getUserId();
        return [ SELECT Id,Name,Title__c, Subtitle__c,Thumbnail__c,Highlight__c,Category__c,Sub_Category__c,Coin__c,Coin_Type__c,Publish_Date__c,View__c,Status__c,
                (SELECT Id FROM OPP_News_Coin__r WHERE Action__c ='Read' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg','png') ORDER BY SystemModstamp DESC)
            FROM OPP_News__c WHERE Status__c ='Published' AND Category__c NOT IN ('TOP Shop','Special Issues') ORDER BY Publish_Date__c DESC, LastModifiedDate DESC];
    }

    @AuraEnabled
    public static List<OPP_News__c> getPublishedNewsByCategory(String category) {
        Id userId = UserInfo.getUserId();
        If (category == 'All') {
            return getAllPublishedNews();
        }

        if (category == 'Highlight') {
            return [SELECT Id, Name,Title__c,Subtitle__c,Thumbnail__c,Highlight__c,Category__c,Sub_Category__c,Coin__c,Coin_Type__c,Publish_Date__c,View__c,Status__c,
                    (SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Read' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg','png') ORDER BY SystemModstamp DESC)
                FROM OPP_News__c WHERE Status__c = 'Published' AND Highlight__c = true AND Category__c NOT IN ('TOP Shop','Special Issues')ORDER BY Publish_Date__c DESC, LastModifiedDate DESC ];
        }

        return [SELECT Id, Name, Title__c,Subtitle__c,Thumbnail__c,Highlight__c,Category__c,Sub_Category__c,Coin__c,Coin_Type__c,Publish_Date__c, View__c,Status__c,
                (SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Read' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg','png') ORDER BY SystemModstamp DESC)
            FROM OPP_News__c WHERE Status__c ='Published' AND Category__c =:category AND Category__c NOT IN ('TOP Shop','Special Issues') ORDER BY Publish_Date__c DESC, LastModifiedDate DESC];
    }

    @AuraEnabled
    public static List<OPP_News__c> getPublishedHighlightNewsByCategory(String category){
        Id userId = UserInfo.getUserId();
        If(category == 'All'){
            return [SELECT Id, Name,Title__c,Subtitle__c,Thumbnail__c,Highlight__c,Category__c,Sub_Category__c,Coin__c,Coin_Type__c,Publish_Date__c,View__c,Status__c,
                    (SELECT Id FROM OPP_News_Coin__r WHERE Action__c ='Read' AND User__c =:userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg','png') ORDER BY SystemModstamp DESC)
                FROM OPP_News__c WHERE Status__c ='Published' AND Highlight__c = true AND Category__c NOT IN ('TOP Shop','Special Issues')ORDER BY Publish_Date__c DESC];
        }else{
            return [SELECT Id, Name, Title__c, Subtitle__c, Thumbnail__c, Highlight__c, Category__c, Sub_Category__c, Coin__c, Coin_Type__c, Publish_Date__c, View__c, Status__c, Content__c,
                    (SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Read' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg', 'png') ORDER BY SystemModstamp DESC)
                FROM OPP_News__c WHERE Status__c = 'Published' AND Highlight__c = true AND Category__c = :category AND Category__c NOT IN ('TOP Shop', 'Special Issues') ORDER BY Publish_Date__c DESC
            ];
        }
    }

    @AuraEnabled
    public static List<OPP_News__c> getPublishedMostViewNews(Integer limitResult){
        Id userId = UserInfo.getUserId();
        return [SELECT Id, Name, Title__c,Subtitle__c,Thumbnail__c,Highlight__c,Category__c,Sub_Category__c, Coin__c, Coin_Type__c, Publish_Date__c, View__c, Status__c,
                (SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Read' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg', 'png') ORDER BY SystemModstamp DESC)
            FROM OPP_News__c WHERE Status__c = 'Published'AND Category__c NOT IN ('TOP Shop', 'Special Issues') AND View__c != null ORDER BY View__c DESC LIMIT :limitResult];
    }

    @AuraEnabled
    public static List<OPP_News__c> getPublishedShopNews(Integer limitResult){
        Id userId = UserInfo.getUserId();
        return[SELECT Id, Name, Title__c,Subtitle__c,Thumbnail__c, Highlight__c,Category__c,Sub_Category__c,Coin__c,Coin_Type__c,Publish_Date__c,View__c,Status__c,
                (SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Read' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg', 'png') ORDER BY SystemModstamp DESC)
            FROM OPP_News__c
            WHERE Status__c = 'Published'
                AND Category__c IN ('TOP Shop')
            ORDER BY Publish_Date__c DESC
            LIMIT :limitResult
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<OPP_News__c> getPublishedNewsById(Id newsId) {
        Id userId = UserInfo.getUserId();
        return [
            SELECT Id, Name, Title__c, Subtitle__c, Content__c, Thumbnail__c, Highlight__c, Category__c, Sub_Category__c, Coin__c, Coin_Type__c, Publish_Date__c, View__c, Status__c,
                (SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Like' AND User__c = :userId),
                (SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg', 'png') ORDER BY SystemModstamp DESC)
            FROM OPP_News__c WHERE Status__c = 'Published' AND Id = :newsId AND Category__c NOT IN ('TOP Shop') LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<OPP_News__c> getNewsById(Id newsId) {
        Id userId = UserInfo.getUserId();
        return [SELECT Id, Name, Title__c, Subtitle__c, Content__c, Thumbnail__c, Highlight__c, File_Attachment__c, Category__c, Sub_Category__c, Coin__c, Coin_Type__c, Publish_Date__c, View__c, Status__c, Link__c, Video_Link__c,
                (SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Like' AND User__c = :userId),(SELECT ContentDocumentId, SystemModstamp, ContentDocument.Title, ContentDocument.FileType, ContentDocument.FileExtension, ContentDocument.Description FROM ContentDocumentLinks WHERE ContentDocument.FileExtension IN ('jpg', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pttx') ORDER BY SystemModstamp DESC)
            FROM OPP_News__c WHERE Id = :newsId AND Category__c NOT IN ('TOP Shop')LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<OPP_News__c> getSpecialIssuesNews(){
        Id userId = UserInfo.getUserId();
        return[ SELECT Id, Name,Title__c,Subtitle__c,Content__c,Thumbnail__c,Highlight__c,Category__c,Sub_Category__c,Coin__c,Coin_Type__c,Publish_Date__c,View__c,Status__c,Link__c,Video_Link__c,
                (SELECT ContentDocumentId, SystemModstamp FROM ContentDocumentLinks ORDER BY SystemModstamp DESC) FROM OPP_News__c WHERE Status__c ='Published' AND Category__c IN ('Special Issues') ORDER BY SystemModstamp DESC LIMIT 1];
    }

    @AuraEnabled
    public static Decimal getCoinBalance(){
        //OPP_NewsController.voteNews();
        OPP_CoinController.UpdateCoin();
        Id userId = UserInfo.getUserId();
        Decimal coinBalance = 0;
        User user = [SELECT Id, OPP_Total_Coin__c FROM User WHERE Id = :userId LIMIT 1];
        if(user != null && user.OPP_Total_Coin__c != null){
            coinBalance = Decimal.valueOf(user.OPP_Total_Coin__c);
        }
        return coinBalance;
    }

    @AuraEnabled
    public static void likeNewsById(Id newsId){
        if (newsId != null){
            Id userId = UserInfo.getUserId();
            OPP_News__c oppNews =[SELECT Coin__c FROM OPP_News__c WHERE Id = :newsId LIMIT 1];
            if (oppNews != null){
                if (!isUserLikedNewsById(newsId, userId)){
                    OPP_News_Coin__c oppNewsCoin = new OPP_News_Coin__c();
                    oppNewsCoin.OPP_News__c = newsId;
                    oppNewsCoin.Action__c = 'Like';
                    oppNewsCoin.User__c = userId;
                    oppNewsCoin.Coin__c = 0;

                    insert oppNewsCoin;
                }
            }
        }
    }

    @AuraEnabled
    public static void unlikeNewsById(Id newsId) {
        Id userId = UserInfo.getUserId();
        List<OPP_News_Coin__c> oppNewsCoin =[SELECT Id FROM OPP_News_Coin__c WHERE OPP_News__c = :newsId AND User__c = :userId];
        delete oppNewsCoin;
    }

    @AuraEnabled
    public static void markNewsAsReadById(Id newsId){
        if (newsId != null) {
            Id userId = UserInfo.getUserId();
            OPP_News__c oppNews =[SELECT Coin_Type__c,Coin__c,View__c FROM OPP_News__c WHERE Id = :newsId LIMIT 1];
            if (oppNews != null){
                if(!isUserReadNewsById(newsId, userId)){
                    OPP_News_Coin__c oppNewsCoin = new OPP_News_Coin__c();
                    oppNewsCoin.OPP_News__c = newsId;
                    oppNewsCoin.Action__c = 'Read';
                    oppNewsCoin.User__c = userId;
                    if (oppNews.Coin_Type__c == 'Read') {
                        oppNewsCoin.Coin__c = oppNews.Coin__c;
                        HttpResponse response = OPP_CoinController.addCoin(String.valueOf(userId)+'.'+String.valueOf(newsId), oppNews.Coin__c);
                        if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
                            insert oppNewsCoin;
                        }
                    }else{
                        oppNewsCoin.Coin__c = 0;
                        insert oppNewsCoin;
                    }
                    if (oppNews.View__c == null) {
                    	oppNews.View__c = 0;
                    }
                    oppNews.View__c = oppNews.View__c + 1;
                    update oppNews;
                }
            }
        }
    }
	@AuraEnabled
    public static void voteNews(){
        Id userId = UserInfo.getUserId();
        List<OPP_News__c> oppNewsList =[SELECT Id,Coin__c,(SELECT Id FROM OPP_News_Coin__r WHERE Action__c = 'Vote' AND User__c =:userId) FROM OPP_News__c WHERE Coin_Type__c ='Vote' AND Status__c ='Published'];
        Map<Id, OPP_News__c> mapNewsNotAdded = new Map<Id, OPP_News__c>();
        for (OPP_News__c oppNews : oppNewsList) {
            if (oppNews.OPP_News_Coin__r.size() == 0) {
                mapNewsNotAdded.put(oppNews.Id, oppNews);
            }
        }
        Map<Id, OPP_News__Feed> polls = new Map<Id, OPP_News__Feed>([SELECT Id, Body, ParentId, Type FROM OPP_News__Feed WHERE Type = 'PollPost' AND ParentId IN :mapNewsNotAdded.keySet()]);
        List<FeedPollVote> votes =[SELECT Id,FeedItemId FROM FeedPollVote WHERE FeedItemId IN :polls.keySet() AND CreatedById = :userId];
        if (votes.size() > 0) {
            Set<Id> setNewsIdMustAddCoin = new Set<Id>();
            for(FeedPollVote vote : votes){
                setNewsIdMustAddCoin.add(polls.get(vote.FeedItemId).ParentId);
            }
            List<OPP_News_Coin__c> oppNewsCoinList = new List<OPP_News_Coin__c>();
            for(Id newsId : setNewsIdMustAddCoin){
                OPP_News_Coin__c oppNewsCoin = new OPP_News_Coin__c();
                oppNewsCoin.OPP_News__c = newsId;
                oppNewsCoin.User__c = userId;
                oppNewsCoin.Coin__c = mapNewsNotAdded.get(newsId).Coin__c;
                oppNewsCoin.Action__c = 'Vote';
                HttpResponse response = OPP_CoinController.addCoin(String.valueOf(userId)+'.' +String.valueOf(newsId), oppNewsCoin.Coin__c);
                if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
                    oppNewsCoinList.add(oppNewsCoin);
                }
            }
            insert oppNewsCoinList;
        }
    }

    @AuraEnabled
    public static Boolean isLikedNewsById(Id newsId) {
        Id userId = UserInfo.getUserId();
        return isUserLikedNewsById(newsId, userId);
    }

    @AuraEnabled
    public static Boolean isReadNewsById(Id newsId) {
        Id userId = UserInfo.getUserId();
        return isUserReadNewsById(newsId, userId);
    }

    private static Boolean isUserLikedNewsById(Id newsId, Id userId){
        List<OPP_News_Coin__c> oppNewsCoins =[SELECT Id FROM OPP_News_Coin__c WHERE OPP_News__c = :newsId AND User__c =:userId AND Action__c ='Like'];
        return (oppNewsCoins.Size() > 0);
    }

    private static Boolean isUserReadNewsById(Id newsId, Id userId){
        List<OPP_News_Coin__c> oppNewsCoins=[SELECT Id FROM OPP_News_Coin__c WHERE OPP_News__c = :newsId AND User__c =:userId AND Action__c ='Read'];
        return (oppNewsCoins.Size() > 0);
    }

}