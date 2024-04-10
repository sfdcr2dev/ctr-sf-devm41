@isTest
public class C360_TOPBuyingPerformanceDailyListTest 
{
    static Id RecordTypeId = Schema.SObjectType.C360_BuyingPerformanceDailyTOP__c.getRecordTypeInfosByDeveloperName().get('DailyPerformance').getRecordTypeId();

    @testSetup
    public static void setupDate()
    {
        Account acc = new Account();
        acc.Name = 'Test Acc';
        insert acc;
        
        C360_Product__c cproduct = new C360_Product__c();
        cproduct.MaterialCode__c = 'P001';
        insert cproduct;
        
        List<C360_BuyingPerformanceDailyTOP__c>buyingList = new List<C360_BuyingPerformanceDailyTOP__c>();
        for(Integer i = 0 ; i < 15 ; i++)
        {
            C360_BuyingPerformanceDailyTOP__c buying = new C360_BuyingPerformanceDailyTOP__c();
            buying.BillingDate__c =  system.today();
            buying.SalesOrganization__c =  '1100';
            buying.DistributionChannel__c =  '16';
            buying.Product__c =  cproduct.id;
            buying.ShippingPoint__c =  '1200';
            buying.QuantityMT__c =  1000;
            buying.QuantityL30__c =  2000;
            buying.Total__c =  3000;
            buying.Key__c = String.valueOf(i);
            buying.RecordTypeId = RecordTypeId;
            buying.Customer__c = acc.id;
            buyingList.add(buying);
        }
        
        insert buyingList;                                                      
                                                        
    }
    
    @isTest
    public static void testGetTableDetails()
    {
        String customerId = [select id from account limit 1].id;
        Test.startTest();
        List<C360_TOPBuyingPerformanceDailyList.TOPBuyingPerformanceDailyWrapper>wrapperList = C360_TOPBuyingPerformanceDailyList.getTableDetails(customerId, 'Loading');
        Test.stopTest();
        
        System.assert(wrapperList.size() > 0);
    }

}