@isTest
public class OPP_NewsJobScheduleTest {

    @isTest
    static void testNewsJobSchedule() {
        Date today = Date.today();
        Id oppNews1Id;
        Id oppNews2Id;
        Id oppNews3Id;

        OPP_News__c oppNews1 = new OPP_News__c();
        oppNews1.Title__c = 'News 1';
        oppNews1.Category__c = 'Corporate';
        oppNews1.Coin__c = 1;
        oppNews1.Coin_Type__c = 'Read';
        oppNews1.Content__c = 'News 1 Content';
        oppNews1.Highlight__c = true;
        oppNews1.Publish_Date__c = today.addDays(-45);
        oppNews1.Expire_Date__c = today.addDays(-15);
        oppNews1.Thumbnail__c = '';
        oppNews1.View__c = 10;
        oppNews1.Status__c = 'Published';
        insert oppNews1;
        oppNews1Id = oppNews1.Id;

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
        oppNews2.View__c = 20;
        oppNews2.Status__c = 'Published';
        insert oppNews2;
        oppNews2Id = oppNews2.Id;

        OPP_News__c oppNews3 = new OPP_News__c();
        oppNews3.Title__c = 'News 3';
        oppNews3.Category__c = 'Corporate';
        oppNews3.Coin__c = 1;
        oppNews3.Coin_Type__c = 'Read';
        oppNews3.Content__c = 'News 3 Content';
        oppNews3.Highlight__c = true;
        oppNews3.Publish_Date__c = today.addDays(-5);
        oppNews3.Expire_Date__c = today.addDays(25);
        oppNews3.Thumbnail__c = '';
        oppNews3.View__c = 30;
        oppNews3.Status__c = 'Draft';
        insert oppNews3;
        oppNews3Id = oppNews3.Id;

        Test.startTest();
        String CRON_EXP = '0 0 0 1 1 ?';
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new OPP_NewsJobSchedule());
        Test.stopTest();

        OPP_News__c oppNews1_After = [SELECT Id, Status__c FROM OPP_News__c WHERE Id = :oppNews1Id];
        OPP_News__c oppNews2_After = [SELECT Id, Status__c FROM OPP_News__c WHERE Id = :oppNews2Id];
        OPP_News__c oppNews3_After = [SELECT Id, Status__c FROM OPP_News__c WHERE Id = :oppNews3Id];

        System.assertEquals('Expired', oppNews1_After.Status__c);
        System.assertEquals('Published', oppNews2_After.Status__c);
        System.assertEquals('Published', oppNews3_After.Status__c);
    }
}