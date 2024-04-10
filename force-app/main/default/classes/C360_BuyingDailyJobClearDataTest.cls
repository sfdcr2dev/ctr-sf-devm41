@isTest
public class C360_BuyingDailyJobClearDataTest {

     @TestSetup
    static void setup() {
        C360Integration__c Integrate = new C360Integration__c();
        Integrate.DeletedDays__c= 1;
        Integrate.DeletedBatchSize__c = 200;
        insert Integrate;
        
   
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;
        
        List<Account> accList = new List<Account>();
        Account a1 = new Account(AccountNumber__c='302', Name='A', RecordTypeId = accRecordTypeId);
        accList.add(a1);
        insert accList;
        
        List<C360_Product__c> productMasterList = new List<C360_Product__c>();
        C360_Product__c pdm1 = new C360_Product__c(MaterialCode__c ='m001', Name ='product name1');
        productMasterList.add(pdm1);
        
        insert productMasterList;
        
        DateTime yesterday;
        
        Id RecordTypeId = [select id from RecordType where DeveloperName = 'TXDailyPerformance'].Id;
        
        List<C360_BuyingPerformanceDailyTOP__c > BuyingPerformanceList = new List<C360_BuyingPerformanceDailyTOP__c >();
        for (Integer i=0;i<10;i++) {
            yesterday = System.Today().addDays(-i);
            C360_BuyingPerformanceDailyTOP__c BuyingPerformance = new C360_BuyingPerformanceDailyTOP__c(
            RecordTypeId = RecordTypeId,
            Key__c = 'by-'+i,
            Customer__c  = accList[0].id,
            Product__c= productMasterList[0].id,
            BillingDate__c =Date.valueOf(yesterday),
            SalesOrganization__c='1300',
            DistributionChannel__c='10',
			Salesunit__c='BBL',
            QuantityMT__c=30);
            BuyingPerformanceList.add(BuyingPerformance);
        }
        
       
        insert BuyingPerformanceList;
        
    }
    
    
    public static testmethod void test()
     {
         C360_ScheduleBuyingDailyJobClearData oclsBuyingDailyDelSchedule = new C360_ScheduleBuyingDailyJobClearData();
         oclsBuyingDailyDelSchedule.execute(null);

         Test.startTest();
         C360_BuyingDailyJobClearData obj = new C360_BuyingDailyJobClearData();
         ID batchId = DataBase.executeBatch(obj);     
         Test.stopTest();
         
     }
  

}