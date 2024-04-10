public with sharing class CTRScreenNewsController {

    private static final String CLASSNAME = CTRScreenNewsController.class.getName();
    private static final String LEADFIELD = 'Lead__c';
    private static final String CTRREQUESTFORMITEMFIELD = 'CTRRequestFormItem__c';
    private static final String CUSTOMERFIELD = 'Customer__c';
    private static final String REQUESTFORMHEADERFIELD = 'RequestFormHeader__c';
    private static final String SPACE = ' ';

    public class NewsGroup {
        @AuraEnabled
        public String keyword { get; set; }
        @AuraEnabled
        public List<CTRNewsModel> ctrNewsModel { get; set; }
    }

    public class CTRNewsModel {
        @AuraEnabled
        public Id id { get; set; }
        @AuraEnabled   
        public String headline { get; set; }
        @AuraEnabled   
        public String sourceURL { get; set; }
        @AuraEnabled   
        public String dateSource { get; set; }
        @AuraEnabled   
        public String keyword { get; set; }
        @AuraEnabled   
        public Boolean flag { get; set; }
        @AuraEnabled
        public String newsItemId { get; set; }
        @AuraEnabled
        public String newsHeaderId { get; set; }
        @AuraEnabled
        public Date dtDateSource { get; set; }
        @AuraEnabled
        public String content { get; set; }
    }

    @AuraEnabled
    public static List<NewsGroup> getCTRNews(String recordId, String sObjectName) {
        List<NewsGroup> newsGroupList = new List<NewsGroup>();
        try {
            Set<String> customerNames = new Set<String>();
            if(sObjectName.equals('Lead')) {
                // List<Lead> leadList = [SELECT Id, Name, Company FROM Lead WHERE Id =: recordId LIMIT 1];
                // if(!leadList.isEmpty()) {
                //     if(!String.isBlank(leadList[0].Name)) {
                //         customerNames.add(leadList[0].Name);
                //     }
                //     if(!String.isBlank(leadList[0].Company)) {
                //         customerNames.add(leadList[0].Company);
                //     }
                // }
                customerNames.add(recordId);
            } else {
                List<CTRRequestFormItem__c> reqItemList = [SELECT Id, Customer__c, Customer__r.Name, CTRRequestformHeader__c FROM CTRRequestFormItem__c WHERE Id =: recordId LIMIT 1];
                if(!reqItemList.isEmpty()) {
                    // customerNames.add(reqItemList[0].Customer__c);
                    customerNames.add(reqItemList[0].CTRRequestformHeader__c);
                }
            }
            if(!customerNames.isEmpty()) {
                Date lastNMonth = System.today().addMonths(-3);
                System.debug('customerNames -----' + customerNames);
                System.debug('lastNMonth -----' + lastNMonth);
                //List<CTRNews__c> newsMasterList = [SELECT Id, Headline__c, Keyword__c, SourceURL__c, Date__c, Source__c FROM CTRNews__c WHERE (Customer__c =: customerNames OR Customer__r.Name =: customerNames) AND Date__c >=: lastNMonth ORDER BY Keyword__c, Date__c];
                String newsQuery = 'SELECT Id, Headline__c, Keyword__c, SourceURL__c, Date__c, Source__c, Content__c FROM CTRNews__c WHERE Date__c >=: lastNMonth AND ' + (sObjectName.equals('Lead') ? LEADFIELD : REQUESTFORMHEADERFIELD) + SPACE + '=: customerNames ORDER BY Keyword__c, Date__c';
                System.debug(CLASSNAME + '.getCTRNews newsQuery -----' + newsQuery);
                List<CTRNews__c> newsMasterList = Database.query(newsQuery);
                // if(sObjectName.equals('Lead'))
                // {
                //     newsMasterList = [SELECT Id, Headline__c, Keyword__c, SourceURL__c, Date__c, Source__c FROM CTRNews__c WHERE Lead__c =:customerNames  AND Date__c >=: lastNMonth ORDER BY Keyword__c, Date__c];
                // }
                // else
                // {
                //     newsMasterList = [SELECT Id, Headline__c, Keyword__c, SourceURL__c, Date__c, Source__c FROM CTRNews__c WHERE (Customer__c =: customerNames) AND Date__c >=: lastNMonth ORDER BY Keyword__c, Date__c];
                // }
                System.debug('newsMasterList -----' + newsMasterList);

                String newsItemQuery = 'SELECT Id, Flag__c, CTRNews__c, CTRNewsHeader__c, CTRNewsHeader__r.Keyword__c FROM CTRNewsItem__c WHERE CTRNewsHeader__r.' + (sObjectName.equals('Lead') ? LEADFIELD : CTRREQUESTFORMITEMFIELD) + SPACE + '=: recordId';
                System.debug(CLASSNAME + '.getCTRNews newsItemQuery -----' + newsItemQuery);
                List<CTRNewsItem__c> newsItemList = Database.query(newsItemQuery);
                Map<String, CTRNewsItem__c> newsItemMap = new Map<String, CTRNewsItem__c>();
                Map<String, String> newsHeaderKeywordMap = new Map<String, String>();
                if(!newsItemList.isEmpty()) {
                    for(CTRNewsItem__c newsItem : newsItemList) {
                        newsItemMap.put(newsItem.CTRNews__c, newsItem);
                        if(newsHeaderKeywordMap == null || newsHeaderKeywordMap.isEmpty() || (newsHeaderKeywordMap != null && !newsHeaderKeywordMap.isEmpty() && !newsHeaderKeywordMap.containsKey(newsItem.CTRNewsHeader__r.Keyword__c))) {
                            newsHeaderKeywordMap.put(newsItem.CTRNewsHeader__r.Keyword__c, newsItem.CTRNewsHeader__c);
                        }
                    }
                }
                // Map<String, List<CTRScreenNewsController.CTRNewsModel>> ctrNewsMap = new Map<String, List<CTRScreenNewsController.CTRNewsModel>>();
                Map<String, List<DateCompare>> ctrNewsMap = new Map<String, List<DateCompare>>();
                if(!newsMasterList.isEmpty()) {
                    for(CTRNews__c news : newsMasterList) {
                        String parentKey = news.Keyword__c;
                        CTRScreenNewsController.CTRNewsModel ctrNews = new CTRScreenNewsController.CTRNewsModel();
                        ctrNews.id = news.Id;
                        ctrNews.headline = news.Headline__c;
                        ctrNews.sourceURL = news.SourceURL__c;
                        ctrNews.dateSource = Datetime.newInstance(news.Date__c, Time.newInstance(0, 0, 0, 0)).format('dd/MM/yyyy');
                        ctrNews.dtDateSource = news.Date__c;
                        ctrNews.keyword = parentKey;
                        ctrNews.content = news.Content__c;
                        if(newsItemMap != null && !newsItemMap.isEmpty() && newsItemMap.containsKey(news.Id)) {
                            ctrNews.flag = newsItemMap.get(news.Id).Flag__c;
                            ctrNews.newsItemId = newsItemMap.get(news.Id).Id;
                            ctrNews.newsHeaderId = (newsHeaderKeywordMap != null && !newsHeaderKeywordMap.isEmpty() && newsHeaderKeywordMap.containsKey(parentKey) ? newsHeaderKeywordMap.get(parentKey) : null);
                        } else {
                            ctrNews.flag = false;
                        }
                        if(ctrNewsMap == null || ctrNewsMap.isEmpty() || (ctrNewsMap != null && !ctrNewsMap.isEmpty() && !ctrNewsMap.containsKey(parentKey))) {
                            ctrNewsMap.put(parentKey, new List<DateCompare>());
                        }
                        ctrNewsMap.get(parentKey).add(new DateCompare(ctrNews));
                    }

                    if(ctrNewsMap != null && !ctrNewsMap.isEmpty()) {
                        // for(String key : ctrNewsMap.keySet()) {
                        //     NewsGroup newsGroup = new NewsGroup();
                        //     newsGroup.keyword = key;
                        //     newsGroup.ctrNewsModel = ctrNewsMap.get(key);
                        //     newsGroupList.add(newsGroup);
                        // }
                        List<CTRNewsKeyword__mdt> keywordList = [SELECT KeywordTH__c, KeywordEng__c FROM CTRNewsKeyword__mdt]; // retrieve master keyword
                        if(!keywordList.isEmpty()) {
                            for(CTRNewsKeyword__mdt keyword : keywordList) {
                                NewsGroup newsGroup = new NewsGroup();
                                newsGroup.keyword = keyword.KeywordTH__c + ' - ' + keyword.KeywordEng__c;
                                List<DateCompare> compareList = new List<DateCompare>();
                                if(ctrNewsMap.containsKey(keyword.KeywordTH__c)) {
                                    compareList.addAll(ctrNewsMap.get(keyword.KeywordTH__c));
                                }
                                if(ctrNewsMap.containsKey(keyword.KeywordEng__c)) {
                                    compareList.addAll(ctrNewsMap.get(keyword.KeywordEng__c));
                                }
                                List<CTRScreenNewsController.CTRNewsModel> newsList = new List<CTRScreenNewsController.CTRNewsModel>();
                                if(!compareList.isEmpty()) {
                                    compareList.sort();
                                    for(DateCompare compareDt : compareList) {
                                        newsList.add(compareDt.record);
                                    }
                                }
                                newsGroup.ctrNewsModel = newsList;
                                newsGroupList.add(newsGroup);
                            }
                        }
                    }
                }
            }
        } catch(Exception e) {
            System.debug(e.getMessage() + ' line:'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage() + ' line:'+e.getLineNumber());
        }
        System.debug('newsGroupList -----' + newsGroupList);
        return newsGroupList;
    }

    @AuraEnabled
    public static void saveCTRNewsItem(String recordId, List<NewsGroup> ctrNewsList, String complianceRiskNews, String sObjectName) {
        try {
            Map<String, CTRNewsHeader__c> newsHeaderToCreate = new Map<String, CTRNewsHeader__c>();
            Map<String, CTRNewsHeader__c> newsHeaderToDelete = new Map<String, CTRNewsHeader__c>();
            Map<String, List<CTRNewsItem__c>> newsItemToUpdate = new Map<String, List<CTRNewsItem__c>>();
            List<CTRNewsItem__c> newsItemToDeleteList = new List<CTRNewsItem__c>();
            for(NewsGroup ctrNewsGroup : ctrNewsList) {
                system.debug('ctrNewsGroup.ctrNewsModel---'+ctrNewsGroup.ctrNewsModel);
                for(CTRNewsModel ctrNews : ctrNewsGroup.ctrNewsModel) {
                    if(ctrNews.flag) {
                        CTRNewsItem__c newsItem = new CTRNewsItem__c();
                        newsItem.CTRNews__c = ctrNews.id;
                        newsItem.Flag__c = ctrNews.flag;
                        if(!String.isBlank(ctrNews.newsHeaderId)) {
                            newsItem.CTRNewsHeader__c = ctrNews.newsHeaderId;
                        } else {
                            if(newsHeaderToCreate == null || newsHeaderToCreate.isEmpty() || (newsHeaderToCreate != null && !newsHeaderToCreate.isEmpty() && !newsHeaderToCreate.containsKey(ctrNews.keyword))) {
                                CTRNewsHeader__c newsHeader = new CTRNewsHeader__c();
                                if(sObjectName.equals('Lead')) {
                                    newsHeader.Lead__c = recordId;
                                } else {
                                    newsHeader.CTRRequestFormItem__c = recordId;
                                }
                                newsHeader.Keyword__c = ctrNews.keyword;
                                newsHeaderToCreate.put(ctrNews.keyword, newsHeader);
                            }
                        }
                        if(!String.isBlank(ctrNews.newsItemId)) {
                            newsItem.Id = ctrNews.newsItemId;
                        }
                        if(newsItemToUpdate == null || newsItemToUpdate.isEmpty() || (newsItemToUpdate != null && !newsItemToUpdate.isEmpty() && !newsItemToUpdate.containsKey(ctrNews.keyword))) {
                            newsItemToUpdate.put(ctrNews.keyword, new List<CTRNewsItem__c>());
                        }
                        newsItemToUpdate.get(ctrNews.keyword).add(newsItem);
                    } else {
                        if(!String.isBlank(ctrNews.newsItemId)) {
                            newsItemToDeleteList.add(new CTRNewsItem__c(Id = ctrNews.newsItemId));
                            if(!String.isBlank(ctrNews.newsHeaderId)) {
                                newsHeaderToDelete.put(ctrNews.keyword, new CTRNewsHeader__c(Id = ctrNews.newsHeaderId));
                            }
                        }
                    }
                }
            }
            System.debug(CLASSNAME + '.saveCTRNewsItem newsItemToUpdate -----' + newsItemToUpdate);
            System.debug(CLASSNAME + '.saveCTRNewsItem newsItemToDeleteList -----' + newsItemToDeleteList);
            System.debug(CLASSNAME + '.saveCTRNewsItem newsHeaderToCreate -----' + newsHeaderToCreate);
            System.debug(CLASSNAME + '.saveCTRNewsItem newsHeaderToDelete -----' + newsHeaderToDelete);
            
            if(newsHeaderToCreate != null && !newsHeaderToCreate.isEmpty()) {
                insert newsHeaderToCreate.values();
            }

            List<CTRNewsItem__c> newsItemToUpdateList = new List<CTRNewsItem__c>();
            if(newsItemToUpdate != null && !newsItemToUpdate.isEmpty()) {
                for(String key : newsItemToUpdate.keySet()) {
                    if(newsHeaderToCreate != null && !newsHeaderToCreate.isEmpty() && newsHeaderToCreate.containsKey(key)) {
                        for(CTRNewsItem__c newsItem : newsItemToUpdate.get(key)) {
                            newsItem.CTRNewsHeader__c = newsHeaderToCreate.get(key).Id;
                        }
                    }
                    newsItemToUpdateList.addAll(newsItemToUpdate.get(key));
                    if(newsHeaderToDelete != null && !newsHeaderToDelete.isEmpty() && newsHeaderToDelete.containsKey(key)) {
                        newsHeaderToDelete.remove(key);
                    }
                }
            }

            if(newsItemToUpdateList != null && !newsItemToUpdateList.isEmpty()) {
                upsert newsItemToUpdateList;
            }

            if(newsItemToDeleteList != null && !newsItemToDeleteList.isEmpty()) {
                delete newsItemToDeleteList;
            }
            
            if(newsHeaderToDelete != null && !newsHeaderToDelete.isEmpty()) {
                delete newsHeaderToDelete.values();
            }

            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
            sObject sObjToUpdate = sObjectType.newSObject();
            sObjToUpdate.put('Id', recordId);
            sObjToUpdate.put('Compliancerisknews__c', complianceRiskNews);
            sObjToUpdate.put('ScreenNewsBy__c', UserInfo.getUserId());
            update sObjToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getComplianceNews(String recordId, String sObjectName) {
        // CTRRequestFormItem__c reqItem = [SELECT Compliancerisknews__c FROM CTRRequestFormItem__c WHERE Id =: recordId];
        String complianceRiskNews = 'No';
        if(!String.isBlank(recordId) && !String.isBlank(sObjectName)) {
            String query = 'SELECT Compliancerisknews__c FROM ' + sObjectName + ' WHERE Id =: recordId';
            List<sObject> sObjList = Database.query(query);
            if(!sObjList.isEmpty()) {
                complianceRiskNews = (sObjList[0].get('Compliancerisknews__c') != null ? (String) sObjList[0].get('Compliancerisknews__c') : complianceRiskNews);
            }
        }
        return complianceRiskNews;
    }

    public class DateCompare implements Comparable {
        public CTRNewsModel record;
        public DateCompare(CTRNewsModel record) { this.record = record; }
        public Integer compareTo(Object compareTo) {
            DateCompare compareToMap = (DateCompare) compareTo;
            Date dtRecord = record.dtDateSource;
            Date dtCompare = compareToMap.record.dtDateSource;
            if(dtCompare < dtRecord) return +1;
            if(dtCompare > dtRecord) return -1;
            return 0;
        }
    }
}