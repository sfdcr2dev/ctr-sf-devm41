public class OPP_NewsTriggerHelper {
    public static void disableHighlight(List<OPP_News__c> newItems){
        Set<String> categories = new Set<String>();
        for (OPP_News__c oppNews : newItems){
            if(oppNews.Highlight__c == true && oppNews.Status__c == 'Published'){
                if (categories.contains(oppNews.Category__c)){
                    oppNews.Highlight__c = false;
                }
                categories.add(oppNews.Category__c);
            }
        }
        categories.remove('Operation');
        List<OPP_News__c> updateNewsList =[SELECT Id, Highlight__c FROM OPP_News__c WHERE Status__c = 'Published' AND Highlight__c = true AND Category__c IN :categories];
        for(OPP_News__c oppNews : updateNewsList){
            oppNews.Highlight__c = false;
        }
        update updateNewsList;
    }

    public static void disableHighlight(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        Set<Id> ids = new Set<Id>();
        Set<String> categories = new Set<String>();
        List<OPP_News__c> items = newItems.values();
        for(OPP_News__c oppNews : items){
            ids.add(oppNews.Id);
            if(oppNews.Highlight__c == true && oppNews.Status__c =='Published'){
                if(categories.contains(oppNews.Category__c)){
                    oppNews.Highlight__c = false;
                }
                categories.add(oppNews.Category__c);
            }
        }
        categories.remove('Operation');
        List<OPP_News__c> updateNewsList =[SELECT Id, Highlight__c FROM OPP_News__c WHERE Status__c ='Published' AND Highlight__c =true AND Category__c IN:categories AND Id NOT IN:ids];
        for(OPP_News__c oppNews : updateNewsList){
            oppNews.Highlight__c = false;
        }
        update updateNewsList;
    }

    public static void createFirstChatterPost(Map<Id, SObject> newItems){
        List<OPP_News__c> items = newItems.values();
        List<FeedItem> feedItems = new List<FeedItem>();
        for(OPP_News__c oppNews : items){
            FeedItem post = new FeedItem();
            post.ParentId = oppNews.Id;
            post.Body = oppNews.Title__c;
            feedItems.add(post);
        }
        insert feedItems;
    }
}