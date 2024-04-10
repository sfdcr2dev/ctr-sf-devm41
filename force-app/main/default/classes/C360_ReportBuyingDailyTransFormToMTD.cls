public class C360_ReportBuyingDailyTransFormToMTD {
	public static void sumBuyingDaily(){
        integer whMonth;
        integer whYear;
        DateTime yesterday;
        C360Integration__c c360Integration = C360Integration__c.getInstance();
        yesterday = (c360Integration.Yesterday__c != null)? c360Integration.Yesterday__c : System.Today().addDays(-1);
        if(c360Integration.Yesterday__c != null){
            whMonth = yesterday.month();
            whYear = yesterday.Year();
        }else{    
            whMonth =Date.Today().Month();
            whYear = Date.Today().Year();
        }         
    //====Select===Field===daily=================================================================================================
        List<string> SelectItem = new List<string>();
        List<string> WhereSelected = new List<string>();
        List<string> GroupFilter = new List<string>();
        SelectItem.add('BillingDate__c');
        SelectItem.add('SalesOrganization__c');
        SelectItem.add('DistributionChannel__c');
        // SelectItem.add('BillingType__c');
        SelectItem.add('Customer__c');
        SelectItem.add('ShippingPoint__c');
        SelectItem.add('Product__c');
        SelectItem.add('ProductNameText__c');
        SelectItem.add('Plant__c');
        SelectItem.add('Salesunit__c');
        SelectItem.add('ShipTo__c');
        SelectItem.add('Shiptocountry__c');
        SelectItem.add('sum(BilledQuantity__c) BilledQuantity');
        SelectItem.add('sum(QuantityL30__c) QuantityL30');
        SelectItem.add('sum(QuantityMT__c) QuantityMT');
        SelectItem.add('sum(TotalTHB__c) TotalTHB');
        SelectItem.add('sum(TotalUSD__c) TotalUSD');
        GroupFilter.add('BillingDate__c');
        GroupFilter.add('SalesOrganization__c');
        GroupFilter.add('DistributionChannel__c');
        GroupFilter.add('Customer__c');
        GroupFilter.add('ShippingPoint__c');
        GroupFilter.add('Product__c');
        GroupFilter.add('ProductNameText__c');
        GroupFilter.add('Plant__c');
        GroupFilter.add('Salesunit__c');
        GroupFilter.add('ShipTo__c');
        GroupFilter.add('Shiptocountry__c');
      //return SumTarget;
        String query1300 = 'Select '+ string.join(SelectItem,',') +' From C360_BuyingPerformanceDailyTOP__c  where calendar_month(BillingDate__c)='+whMonth+' and calendar_year(BillingDate__c)='+whYear+' and RecordType.DeveloperName in(\'DailyPerformance\') and BillingType__c <>\'Z2C1\' and BillingType__c <>\'Z6C1\' and  SalesOrganization__c in(\'1300\') Group by  '+ string.join(GroupFilter,','); 
        String query1700 = 'Select '+ string.join(SelectItem,',') +' From C360_BuyingPerformanceDailyTOP__c  where  calendar_month(BillingDate__c)='+whMonth+' and calendar_year(BillingDate__c)='+whYear+'and RecordType.DeveloperName in(\'DailyPerformance\') and BillingType__c <>\'Z2C1\' and BillingType__c <>\'Z6C1\' and  SalesOrganization__c in(\'1700\') Group by  '+ string.join(GroupFilter,','); 
        List<sObject> SalesSummaryList =Database.query(query1300);
        List<C360_BuyingPerformanceMonthlyTOP__c>upsertBuyingPerformanceMonthly = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        Id RecordTypeId = [select id from RecordType where DeveloperName = 'MonthlyBuyingPerformance'].Id;
      if(SalesSummaryList.size() > 0){
           for(sObject SalesSummary : SalesSummaryList){
               C360_BuyingPerformanceMonthlyTOP__c objBuyMonthly = new C360_BuyingPerformanceMonthlyTOP__c();
    			objBuyMonthly.Key__c =String.valueOf(SalesSummary.get('BillingDate__c'))+String.valueOf(SalesSummary.get('SalesOrganization__c'))+String.valueOf(SalesSummary.get('DistributionChannel__c'))+String.valueOf(SalesSummary.get('Customer__c'))+String.valueOf(SalesSummary.get('ShippingPoint__c'))+String.valueOf(SalesSummary.get('Product__c'))+String.valueOf(SalesSummary.get('ProductNameText__c'))+String.valueOf(SalesSummary.get('Plant__c'))+String.valueOf(SalesSummary.get('Salesunit__c'))+String.valueOf(SalesSummary.get('ShipTo__c'))+String.valueOf(SalesSummary.get('Shiptocountry__c'));
                objBuyMonthly.Date__c = date.valueOf(String.valueOf(SalesSummary.get('BillingDate__c')));
                objBuyMonthly.SalesOrganization__c = String.valueOf(SalesSummary.get('SalesOrganization__c'));
                objBuyMonthly.DistributionChannel__c= String.valueOf(SalesSummary.get('DistributionChannel__c'));
                objBuyMonthly.Customer__c = String.valueOf(SalesSummary.get('Customer__c'));
                objBuyMonthly.ShippingPoint__c	= String.valueOf(SalesSummary.get('ShippingPoint__c'));
               	objBuyMonthly.Product__c = String.valueOf(SalesSummary.get('Product__c')) <> Null ? String.valueOf(SalesSummary.get('Product__c')) : Null;
                objBuyMonthly.ProductNameText__c =String.valueOf(SalesSummary.get('ProductNameText__c'));
                objBuyMonthly.Plant__c	=String.valueOf(SalesSummary.get('Plant__c'));
                objBuyMonthly.VolumeLifting__c= Decimal.valueOf(String.valueOf(SalesSummary.get('BilledQuantity')));
                objBuyMonthly.Volume__c= Decimal.valueOf(String.valueOf(SalesSummary.get('BilledQuantity')));
                objBuyMonthly.VolumeLiftingUnit__c = String.valueOf(SalesSummary.get('Salesunit__c'));
                objBuyMonthly.VolumeLTS30__c= Decimal.valueOf(String.valueOf(SalesSummary.get('QuantityL30')));
                objBuyMonthly.VolumeMTON__c	= Decimal.valueOf(String.valueOf(SalesSummary.get('QuantityMT')));
                objBuyMonthly.Shipto__c	= String.valueOf(SalesSummary.get('ShipTo__c'));
                objBuyMonthly.ShiptocountryText__c	= String.valueOf(SalesSummary.get('Shiptocountry__c'));
                objBuyMonthly.NetValueLocal__c	= Decimal.valueOf(String.valueOf(SalesSummary.get('TotalTHB')));
                objBuyMonthly.NetValueUSD__c= Decimal.valueOf(String.valueOf(SalesSummary.get('TotalUSD')));
                objBuyMonthly.RecordTypeId = RecordTypeId;
				upsertBuyingPerformanceMonthly.add(objBuyMonthly);
           }
      }
        List<sObject> SalesSummary1700List =Database.query(query1700);
        if(SalesSummary1700List.size() > 0){
           for(sObject SalesSummary1700 : SalesSummary1700List){
               C360_BuyingPerformanceMonthlyTOP__c objBuyMonthly1700 = new C360_BuyingPerformanceMonthlyTOP__c();
     			objBuyMonthly1700.Key__c =String.valueOf(SalesSummary1700.get('BillingDate__c'))+String.valueOf(SalesSummary1700.get('SalesOrganization__c'))+String.valueOf(SalesSummary1700.get('DistributionChannel__c'))+String.valueOf(SalesSummary1700.get('Customer__c'))+String.valueOf(SalesSummary1700.get('ShippingPoint__c'))+String.valueOf(SalesSummary1700.get('Product__c'))+String.valueOf(SalesSummary1700.get('ProductNameText__c'))+String.valueOf(SalesSummary1700.get('Plant__c'))+String.valueOf(SalesSummary1700.get('Salesunit__c'))+String.valueOf(SalesSummary1700.get('ShipTo__c'))+String.valueOf(SalesSummary1700.get('Shiptocountry__c'));
                objBuyMonthly1700.Date__c = date.valueOf(String.valueOf(SalesSummary1700.get('BillingDate__c')));
                objBuyMonthly1700.SalesOrganization__c = String.valueOf(SalesSummary1700.get('SalesOrganization__c'));
                objBuyMonthly1700.DistributionChannel__c= String.valueOf(SalesSummary1700.get('DistributionChannel__c'));
                objBuyMonthly1700.Customer__c = String.valueOf(SalesSummary1700.get('Customer__c'));
                objBuyMonthly1700.ShippingPoint__c	= String.valueOf(SalesSummary1700.get('ShippingPoint__c'));
               objBuyMonthly1700.Product__c	= String.valueOf(SalesSummary1700.get('Product__c')) <> Null? String.valueOf(SalesSummary1700.get('Product__c')) : Null;
                objBuyMonthly1700.ProductNameText__c =String.valueOf(SalesSummary1700.get('ProductNameText__c'));
                objBuyMonthly1700.Plant__c	=String.valueOf(SalesSummary1700.get('Plant__c'));
                objBuyMonthly1700.VolumeLifting__c= Decimal.valueOf(String.valueOf(SalesSummary1700.get('BilledQuantity')));
                objBuyMonthly1700.Volume__c= Decimal.valueOf(String.valueOf(SalesSummary1700.get('BilledQuantity')));
                objBuyMonthly1700.VolumeLiftingUnit__c = String.valueOf(SalesSummary1700.get('Salesunit__c'));
                objBuyMonthly1700.VolumeLTS30__c= Decimal.valueOf(String.valueOf(SalesSummary1700.get('QuantityL30')));
                objBuyMonthly1700.VolumeMTON__c	= Decimal.valueOf(String.valueOf(SalesSummary1700.get('QuantityMT')));
                objBuyMonthly1700.Shipto__c	= String.valueOf(SalesSummary1700.get('ShipTo__c'));
                objBuyMonthly1700.ShiptocountryText__c	= String.valueOf(SalesSummary1700.get('Shiptocountry__c'));
                objBuyMonthly1700.NetValueLocal__c	= Decimal.valueOf(String.valueOf(SalesSummary1700.get('TotalTHB')));
                objBuyMonthly1700.NetValueUSD__c= Decimal.valueOf(String.valueOf(SalesSummary1700.get('TotalUSD')));
                objBuyMonthly1700.RecordTypeId = RecordTypeId;
			
				upsertBuyingPerformanceMonthly.add(objBuyMonthly1700);
           }
      }
        
         List <Database.upsertResult>resultList = new List<Database.upsertResult>(); 
        if(upsertBuyingPerformanceMonthly.size()>0){
           // insert upsertBuyingPerformanceMonthly;
           Schema.SObjectField monthlyKey = C360_BuyingPerformanceMonthlyTOP__c.Fields.Key__c;
         	resultList= Database.upsert(upsertBuyingPerformanceMonthly, monthlyKey, false); 
        }
        
    }
}