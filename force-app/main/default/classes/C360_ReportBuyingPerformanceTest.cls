@isTest
public class C360_ReportBuyingPerformanceTest {
	 @TestSetup
    static void setup() {
        C360Integration__c Integrate = new C360Integration__c();
        Integrate.DeletedDays__c= 1;
        Integrate.DeletedBatchSize__c = 200;
        insert Integrate;
        
   
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;
          
        List<Account> accList = new List<Account>();
        Account a1 = new Account(AccountNumber__c='302', Name='A', RecordTypeId = accRecordTypeId);
        Account a2 = new Account(AccountNumber__c='1', Name='A1', RecordTypeId = accRecordTypeId, TOPSOLVENTTH__c=true);
        Account a3 = new Account(AccountNumber__c='2', Name='A2', RecordTypeId = accRecordTypeId, TOPSOLVENTVN__c=true);
        accList.add(a1);
        accList.add(a2);
        accList.add(a3);
        insert accList;
    //========================Sales Area=========================================================================================================================================================================================
  
    List<C360_SalesArea__c> areaList = new List<C360_SalesArea__c>();
 			
               C360_SalesArea__c SalesArea1 = new C360_SalesArea__c(
                AccountNumber__c  = accList[0].id,
                SalesGroup__c='TD1',
                SalesOrganization__c='2000');
       		 areaList.add(SalesArea1);
        C360_SalesArea__c SalesArea2 = new C360_SalesArea__c(
                AccountNumber__c  = accList[0].id,
                SalesGroup__c='TD1',
                SalesOrganization__c='9100');
            
			areaList.add(SalesArea2);    
        insert  areaList;
     //===================End=====Sales Area=========================================================================================================================================================================================
                  
        List<C360_Product__c> productMasterList = new List<C360_Product__c>();
        C360_Product__c pdm1 = new C360_Product__c(MaterialCode__c ='m001', Name ='product name1');
        productMasterList.add(pdm1);
        
        insert productMasterList;
        
        DateTime yesterday;
        
        Id RecordTypeId = [select id from RecordType where DeveloperName = 'TXDailyPerformance'].Id;
        Id RecordTypeIdDailyPer = [select id from RecordType where DeveloperName = 'DailyPerformance'].Id;
       
        List<C360_BuyingPerformanceDailyTOP__c > BuyingPerformanceList = new List<C360_BuyingPerformanceDailyTOP__c >();
        for (Integer i=0;i<20;i++) {
            yesterday = System.Today().addDays(-i);
            if(i<=7){
                C360_BuyingPerformanceDailyTOP__c BuyingPerformance = new C360_BuyingPerformanceDailyTOP__c(
                RecordTypeId = RecordTypeId,
                Key__c = 'by-'+i,
                Customer__c  = accList[0].id,
                Product__c= productMasterList[0].id,
                BillingDate__c =Date.valueOf(yesterday),
                SalesOrganization__c='1300',
                DistributionChannel__c='10',
                BilledQuantity__c=10,
        		QuantityL30__c=10,
                TotalTHB__c =10,
                TotalUSD__c =10,
                Salesunit__c='BBL',
                QuantityMT__c=30);
                BuyingPerformanceList.add(BuyingPerformance);
                
            }else if(i>7 && i< 15){
                C360_BuyingPerformanceDailyTOP__c BuyingPer1300 = new C360_BuyingPerformanceDailyTOP__c(
                RecordTypeId = RecordTypeIdDailyPer,
                Key__c = 'by-'+i,
                Customer__c  = accList[0].id,
                Product__c= productMasterList[0].id,
                BillingDate__c =Date.valueOf(yesterday),
                SalesOrganization__c='1300',
                DistributionChannel__c='10',
                BilledQuantity__c=10,
        		QuantityL30__c=10,
                TotalTHB__c =10,
                TotalUSD__c =10,
                Salesunit__c='BBL',
                QuantityMT__c=30);
                BuyingPerformanceList.add(BuyingPer1300);
              }else if(i>= 15){
                C360_BuyingPerformanceDailyTOP__c BuyingPer1700 = new C360_BuyingPerformanceDailyTOP__c(
                RecordTypeId = RecordTypeIdDailyPer,
                Key__c = 'by-'+i,
                Customer__c  = accList[0].id,
                Product__c= productMasterList[0].id,
                BillingDate__c =Date.valueOf(yesterday),
                SalesOrganization__c='1700',
                DistributionChannel__c='10',
                Salesunit__c='BBL',
                BilledQuantity__c=10,
        		QuantityL30__c=10,
                TotalTHB__c =10,
                TotalUSD__c =10,
                QuantityMT__c=30);
                BuyingPerformanceList.add(BuyingPer1700);
            }
        }
        insert BuyingPerformanceList;
  //========================Buying Monthhly=========================================================================================================================================================================================
    Id RecordTypeIdTx = [select id from RecordType where DeveloperName = 'TXMonthlyPerformance'].Id;    
     
    List<C360_BuyingPerformanceMonthlyTOP__c > BuyingMonthList = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        for (Integer i=0;i<12;i++) {
          
               C360_BuyingPerformanceMonthlyTOP__c BuyingMonthlyTOP = new C360_BuyingPerformanceMonthlyTOP__c(
                RecordTypeId = RecordTypeIdTx,
                Key__c = 'by-'+i,
                Customer__c  = accList[0].id,
                Product__c= productMasterList[0].id,
                BusinessUnit__c='BBL',
                Year__c='2022',
                Month__c='2',
                SalesGroup__c='TD1',
                SalesOrganization__c='2000',
                DistributionChannel__c='10',
                CPtargetNetProfitUSD__c =0,
                NetProfitUSD__c =0,
                LastYearQuantity__c =0,
                CPtargetVolume__c =0,
                Volume__c =0,
                LastYearPocketmarginUSD__c =0,
                CPtargetPocketMarginUSD__c =0,
                PocketmarginUSD__c =0,
                CumLYNetProfitUSD__c =0,
                CumCPtargetNetProfitUSD__c =0,
                CumNetProfitUSD__c =0,
                CumLastYearVolume__c =0,
                CumCPTargetVolume__c =0,
                CumVolume__c =0,
                CumLYPocketmarginUSD__c =0,
                CumCPtargetPocketMarginUSD__c =0,
                CumPocketmarginUSD__c =0,
      		    LastYearMonthlyPocketmarginLocal__c =0,
			    LastYearMonthlyPocketmarginUSD__c=30
               );
              BuyingMonthList.add(BuyingMonthlyTOP);
            
            if(i>10){
                 C360_BuyingPerformanceMonthlyTOP__c BuyingMonthlyTOPNull = new C360_BuyingPerformanceMonthlyTOP__c(
                RecordTypeId = RecordTypeIdTx,
                Key__c = 'bynull-'+i,
                Customer__c  = accList[0].id,
                Product__c= productMasterList[0].id,
                BusinessUnit__c='BBL',
                Year__c='2022',
                Month__c=''+i,
                SalesGroup__c='TD1',
                SalesOrganization__c='9100',
                DistributionChannel__c='16'
               );
              BuyingMonthList.add(BuyingMonthlyTOPNull);
                
            }
        }
          insert BuyingMonthList;
         List<C360_BuyingPerformanceMonthlyTOP__c > BuyingMonthTargerList = new List<C360_BuyingPerformanceMonthlyTOP__c>();
       Id RecordTypeIdTarget = [select id from RecordType where DeveloperName = 'TXTargetMonthlyPerformance'].Id; 
       for (Integer n=0;n<12;n++) {
           if(n>10){
               C360_BuyingPerformanceMonthlyTOP__c BuyingMonthlyTaregt = new C360_BuyingPerformanceMonthlyTOP__c(
                RecordTypeId = RecordTypeIdTarget,
                Key__c = 'byTG-'+n,
                Customer__c  = accList[0].id,
                Product__c= productMasterList[0].id,
                BusinessUnit__c='BBL',
                Year__c='2022',
                Month__c= String.valueOf(n),
                SalesGroup__c='TD1',
                SalesOrganization__c='2000',
                DistributionChannel__c='10',
                CPtargetNetProfitUSD__c=10,
               
                CumCPtargetNetProfitUSD__c=10,
                CumCPTargetVolume__c=10,
                CumCPtargetPocketMarginUSD__c=10
               );
              BuyingMonthTargerList.add(BuyingMonthlyTaregt);
           }else{
               
              C360_BuyingPerformanceMonthlyTOP__c BuyingMonthlyTaregt = new C360_BuyingPerformanceMonthlyTOP__c(
                RecordTypeId = RecordTypeIdTarget,
                Key__c = 'byTG-'+n,
                Customer__c  = accList[0].id,
                Product__c= productMasterList[0].id,
                BusinessUnit__c='BBL',
                Year__c='2022',
                Month__c= String.valueOf(n),
                SalesGroup__c='TD1',
                SalesOrganization__c='2000',
                DistributionChannel__c='10',
                CPtargetNetProfitUSD__c=10,
                CPtargetVolume__c=10,
                CPtargetPocketMarginUSD__c=10,
                CumCPtargetNetProfitUSD__c=10,
                CumCPTargetVolume__c=10,
                CumCPtargetPocketMarginUSD__c=10
               );
              BuyingMonthTargerList.add(BuyingMonthlyTaregt); 
           }
        }
        insert BuyingMonthTargerList;
        
         yesterday = System.Today();
         List<C360_Contract__c> contractHeadList = new List<C360_Contract__c >();
         C360_Contract__c contractHead = new C360_Contract__c(
             SoldTo__c  = accList[0].id,
             ContractStartDate__c =Date.valueOf(yesterday),
             ContractEndDate__c =Date.valueOf(yesterday),
             SalesOrganization__c='1300',
             DistributionChannel__c='10');
        contractHeadList.add(contractHead);
        
        insert contractHeadList;
        /* Product__c= productMasterList[0].id,
                BillingDate__c =Date.valueOf(yesterday),
                SalesOrganization__c='1300',
                DistributionChannel__c='10',
                BilledQuantity__c=10,
        		QuantityL30__c=10,
                TotalTHB__c =10,
                TotalUSD__c =10,
                Salesunit__c='BBL',

TEXT(SalesOrganization__c) &"_"&
TEXT(DistributionChannel__c) &"_"&
Customer__r.AccountNumber__c &"_"&
Product__r.MaterialCode__c &"_"&
TEXT(Salesunit__c),
null) 302_m001_BBL*/
         List<C360_ContractLineItem__c > contractItemList = new List<C360_ContractLineItem__c >();
        for (Integer i=0;i<2;i++) {
           //s yesterday = System.Today().addDays(-i);
            if(i < 1){
            	C360_ContractLineItem__c contrItem = new C360_ContractLineItem__c(
                    Key__c = '1300_10_302_m001_BBL',
                    Contract__c  = contractHeadList[0].id,
                     Product__c= productMasterList[0].id,
                    ContractVolumeUOM__c='BBL',
                    ContractVolume__c=30);
                  contractItemList.add(contrItem);
                }else{
                     C360_ContractLineItem__c contrItem = new C360_ContractLineItem__c(
                    Key__c = '1300_10_302_m001_MT',
                    Contract__c  = contractHeadList[0].id,
                    Product__c= productMasterList[0].id,
                    ContractVolumeUOM__c='MT',
                    ContractVolume__c=30);
                   contractItemList.add(contrItem);
                }
          
        }

        insert contractItemList;
    }
    
   @isTest
   static void test_ReportBuyingDailySummary()
     {
        
      Test.startTest(); 
        C360_ReportBuyingDailySummary.sumBuyingDailyMonthYear();
      Test.stopTest();
 
     }
	
  @isTest
   static void test_C360_ReportContractLineItemSummary()
     {
        
      Test.startTest();
        C360_ReportContractLineItemSummary.sumContractItemMonthYear();
      Test.stopTest();
 
     }
      @isTest
   static void test_C360_ReportBuyingDailyTransFormToMTD()
     {
        
      Test.startTest();
       C360_ReportBuyingDailyTransFormToMTD.sumBuyingDaily();
      Test.stopTest();
 
     }
  @isTest
   static void test_ReportTxSalesSummaryControlleGetYear()
     {  
      Test.startTest();
       C360_ReportTxSalesSummaryController.getYear();
      Test.stopTest();
 
     }
   @isTest
   static void test_ReportTxSalesSummaryControlleGetBu()
     {  
      Test.startTest();
       C360_ReportTxSalesSummaryController.getBu();
      Test.stopTest();
 
     }  
   
    @isTest
   static void test_ReportTxSalesSummaryControlleGetSales()
     {  
       string selectedSalesOrg = '2000';
       string selectedDistributionChannel = '10'; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getSalesGroup(selectedSalesOrg,selectedDistributionChannel);
      Test.stopTest();
 
     }  
    
   @isTest
   static void test_ReportTxSalesSummaryControlleGetSales2()
     {  
       string selectedSalesOrg2 = '2000';
       string selectedDistributionChannel2 = ''; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getSalesGroup(selectedSalesOrg2,selectedDistributionChannel2);
      Test.stopTest();
 
     } 
  @isTest
   static void test_ReportTxSalesSummaryControlleGetSales3()
     {  
       string selectedSalesOrg3 = '';
       string selectedDistributionChannel3 = '10'; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getSalesGroup(selectedSalesOrg3,selectedDistributionChannel3);
      Test.stopTest();
 
     } 
  @isTest
   static void test_ReportTxSalesSummaryControlleGetSales4()
     {  
       string selectedSalesOrg4 = '';
       string selectedDistributionChannel4 = ''; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getSalesGroup(selectedSalesOrg4,selectedDistributionChannel4);
      Test.stopTest();
 
     } 
    @isTest
   static void test_ReportTxSalesSummaryControlleGetAcc()
     {  
       string selectedSalesOrg = '2000';
       string selectedSalesGroup = 'TD1'; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getAccountList(selectedSalesOrg, selectedSalesGroup);
      Test.stopTest();
 
     }   
    @isTest
   static void test_ReportTxSalesSummaryControlleGetAcc2()
     {  
       string selectedSalesOrg = '9100';
       string selectedSalesGroup = 'TD1'; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getAccountList(selectedSalesOrg, selectedSalesGroup);
      Test.stopTest();
 
     } 
     @isTest
   static void test_ReportTxSalesSummaryControlleGetAcc3()
     {  
       string selectedSalesOrg = '';
       string selectedSalesGroup = 'TD1'; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getAccountList(selectedSalesOrg, selectedSalesGroup);
      Test.stopTest();
 
     } 
     @isTest
   static void test_ReportTxSalesSummaryControlleGetAcc4()
     {  
       string selectedSalesOrg = '2000';
       string selectedSalesGroup = ''; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getAccountList(selectedSalesOrg, selectedSalesGroup);
      Test.stopTest();
 
     }   
    @isTest
   static void test_ReportTxSalesSummaryControlleGetAcc5()
     {  
       string selectedSalesOrg = '9100';
       string selectedSalesGroup = ''; 
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getAccountList(selectedSalesOrg, selectedSalesGroup);
      Test.stopTest();
 
     } 
     @isTest
   static void test_ReportTxSalesSummaryControlleGetDataQuery()
     {  
      string selectedMonth= '12';
      string selectedYear= '2022';
      string selectedSalesOrg= '9100';
      string selectedSalesGroup  = 'TD1'; 
      string selectedAccount= '';
      string selectedDistributionChannel = '';
      string selectedBu = 'BBL';
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getDataQuery(selectedMonth,selectedYear,selectedSalesOrg,selectedSalesGroup,selectedAccount,selectedDistributionChannel, selectedBu);
      Test.stopTest();
 
     }    
   
   @isTest
   static void test_ReportTxSalesSummaryControlleGetDataQuery2()
     {  
      string selectedMonth= '';
      string selectedYear= '2022';
      string selectedSalesOrg= '';
      string selectedSalesGroup  = ''; 
      string selectedAccount= '';
      string selectedDistributionChannel = '';
      string selectedBu = '';
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getDataQuery(selectedMonth,selectedYear,selectedSalesOrg,selectedSalesGroup,selectedAccount,selectedDistributionChannel, selectedBu);
      Test.stopTest();
     } 
       @isTest
   static void test_ReportTxSalesSummaryControlleGetDataQuery3()
     {  
      string selectedMonth= '2';
      string selectedYear= '2022';
      string selectedSalesOrg= '2000';
      string selectedSalesGroup  = 'TD1'; 
      string selectedAccount= '302';
      string selectedDistributionChannel = '10';
      string selectedBu = 'BBL';
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getDataQuery(selectedMonth,selectedYear,selectedSalesOrg,selectedSalesGroup,selectedAccount,selectedDistributionChannel, selectedBu);
      Test.stopTest();
 
     } 
       @isTest
   static void test_ReportTxSalesSummaryControlleGetDataQuery4()
     {  
      string selectedMonth= '';
      string selectedYear= '';
      string selectedSalesOrg= '';
      string selectedSalesGroup  = ''; 
      string selectedAccount= '';
      string selectedDistributionChannel = '';
      string selectedBu = '';
         
      Test.startTest();
       C360_ReportTxSalesSummaryController.getDataQuery(selectedMonth,selectedYear,selectedSalesOrg,selectedSalesGroup,selectedAccount,selectedDistributionChannel, selectedBu);
      Test.stopTest();
     } 
    
   @isTest
    static void testC360_ScheduteRPTBuyingDailySummary() 
    {
        Test.startTest();
        String jobId = System.schedule('C360_ScheduteRPTBuyingDailySummary',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduteRPTBuyingDailySummary());
        Test.stopTest();
    }
    

    
    @isTest
    static void testC360_ScheduteRPTBuyingDailyToMTD() 
    {
        Test.startTest();
        String jobId = System.schedule('C360_ScheduteRPTBuyingDailyToMTD',
                                       '0 30 3 * * ?', 
                                       new C360_ScheduteRPTBuyingDailyToMTD());
        Test.stopTest();
    }
    
     @isTest
    static void testC360_ScheduteRPTContractLineItemSummary() 
    {
        Test.startTest();
        String jobId = System.schedule('C360_ScheduteRPTContractLineItemSummary',
                                       '0 30 3 * * ?', 
                                       new C360_ScheduteRPTContractLineItemSummary());
        Test.stopTest();
    }
}