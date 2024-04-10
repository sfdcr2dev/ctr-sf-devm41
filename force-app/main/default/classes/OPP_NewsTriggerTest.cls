@isTest
public with sharing class OPP_NewsTriggerTest {

    @TestSetup
    static void setup(){
        Date today = Date.today();

        OPP_News__c oppNews1 = new OPP_News__c();
        oppNews1.Title__c = 'News 1';
        oppNews1.Category__c = 'Corporate';
        oppNews1.Coin__c = 1;
        oppNews1.Coin_Type__c = 'Read';
        oppNews1.Content__c = 'News 1 Content';
        oppNews1.Highlight__c = true;
        oppNews1.Publish_Date__c = today.addDays(-15);
        oppNews1.Expire_Date__c = today.addDays(15);
        oppNews1.Thumbnail__c = '';
        oppNews1.View__c = 10;
        oppNews1.Status__c = 'Published';
        insert oppNews1;

        OPP_News__c oppNews2 = new OPP_News__c();
        oppNews2.Title__c = 'News 2';
        oppNews2.Category__c = 'Corporate';
        oppNews2.Coin__c = 1;
        oppNews2.Coin_Type__c = 'Read';
        oppNews2.Content__c = 'News 2 Content';
        oppNews2.Highlight__c = false;
        oppNews2.Publish_Date__c = today.addDays(-15);
        oppNews2.Expire_Date__c = today.addDays(15);
        oppNews2.Thumbnail__c = '';
        oppNews2.View__c = 10;
        oppNews2.Status__c = 'Published';
        insert oppNews2;

        OPP_News__c oppNews3 = new OPP_News__c();
        oppNews3.Title__c = 'News 3';
        oppNews3.Category__c = 'Corporate';
        oppNews3.Coin__c = 1;
        oppNews3.Coin_Type__c = 'Read';
        oppNews3.Content__c = 'News 3 Content';
        oppNews3.Highlight__c = false;
        oppNews3.Publish_Date__c = today.addDays(-15);
        oppNews3.Expire_Date__c = today.addDays(15);
        oppNews3.Thumbnail__c = '';
        oppNews3.View__c = 10;
        oppNews3.Status__c = 'Published';
        insert oppNews3;
    }

    @isTest
    static void testInsertNews() {
        Date today = Date.today();

        List<OPP_News__c> oppNewsList = new List<OPP_News__c>();
        OPP_News__c oppNews10 = new OPP_News__c();
        oppNews10.Title__c = 'News 10';
        oppNews10.Category__c = 'Corporate';
        oppNews10.Coin__c = 1;
        oppNews10.Coin_Type__c = 'Read';
        oppNews10.Content__c = 'News 10 Content';
        oppNews10.Highlight__c = true;
        oppNews10.Publish_Date__c = today.addDays(-15);
        oppNews10.Expire_Date__c = today.addDays(15);
        oppNews10.Thumbnail__c = '';
        oppNews10.View__c = 10;
        oppNews10.Status__c = 'Published';
        oppNewsList.add(oppNews10);

        OPP_News__c oppNews20 = new OPP_News__c();
        oppNews20.Title__c = 'News 20';
        oppNews20.Category__c = 'Corporate';
        oppNews20.Coin__c = 1;
        oppNews20.Coin_Type__c = 'Read';
        oppNews20.Content__c = 'News 20 Content';
        oppNews20.Highlight__c = true;
        oppNews20.Publish_Date__c = today.addDays(-15);
        oppNews20.Expire_Date__c = today.addDays(15);
        oppNews20.Thumbnail__c = '';
        oppNews20.View__c = 10;
        oppNews20.Status__c = 'Published';
        oppNewsList.add(oppNews20);

        Test.startTest();
        insert oppNewsList;
        Test.stopTest();

        System.assertNotEquals(null, oppNews10.Id);
        System.assertNotEquals(null, oppNews20.Id);
    }

    @isTest
    static void testUpdateNews() {
        OPP_News__c oppNews2_Before = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 2' LIMIT 1];
        OPP_News__c oppNews3_Before = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 3' LIMIT 1];
        List<OPP_News__c> updateList = new List<OPP_News__c>();

        Test.startTest();
        oppNews2_Before.Highlight__c = true;
        oppNews3_Before.Highlight__c = true;
        updateList.add(oppNews2_Before);
        updateList.add(oppNews3_Before);
        update updateList;
        Test.stopTest();

        OPP_News__c oppNews2_After = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 2' LIMIT 1];
        OPP_News__c oppNews3_After = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 3' LIMIT 1];

        System.assertEquals(true, oppNews2_After.Highlight__c);
        System.assertEquals(false, oppNews3_After.Highlight__c);
    }

    @isTest
    static void testDelete(){
        Test.startTest();
		OPP_News__c news = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 3' LIMIT 1];
		delete news;
		List<OPP_News__c> afterDeleted = [SELECT Id,Name FROM OPP_News__c WHERE Title__c = 'News 3'];
		System.assertEquals(0, afterDeleted.size());
		Test.stopTest();
    }
}