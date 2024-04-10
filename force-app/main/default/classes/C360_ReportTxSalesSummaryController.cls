public class C360_ReportTxSalesSummaryController{
   @AuraEnabled
    public static List<Account> getAccountList(string selectedSalesOrg,string selectedSalesGroup){
        map<String,String>GrpMapRev = new map<String,String>(); 
        Schema.DescribeFieldResult fieldResult = C360_SalesArea__c.SalesGroup__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        String result;
        for( Schema.PicklistEntry v : values) {
            if (v.getValue() == 'public') {
                result = v.getLabel();
            }
            GrpMapRev.put(v.getLabel(),v.getValue());
        } 
        string wheGrp ='';
        List<String> accList= new List<String>();  
        if(String.isNotBlank(selectedSalesGroup)){
            wheGrp ='and id in (Select AccountNumber__c  from C360_SalesArea__c  where  AccountNumber__r.RecordType.DeveloperName=\'SoldTo\' and SalesGroup__c = \''+ GrpMapRev.GET(selectedSalesGroup) +'\')';
        }
       string wheTop = selectedSalesOrg=='2000'? ' and TOPSOLVENTTH__c=true': selectedSalesOrg=='9100'? ' and TOPSOLVENTTH__c=true' :'and ( TOPSOLVENTTH__c=true or  TOPSOLVENTVN__c =true)';
       String query = 'Select Id,AccountNumber__c,CompanyNameEN__c,Name from Account where RecordType.Name in (\'Sold To\') ' + wheTop +' '+ wheGrp +' order by AccountNumber__c,CompanyNameEN__c asc '; 
        List<sObject> accountList =Database.query(query);
        return accountList;
    }
    
    @AuraEnabled
    public static List<string> getSalesGroup(string selectedSalesOrg,string selectedDistributionChannel){
		map<String,String>SalesGroupMap = new map<String,String>(); 
        Schema.DescribeFieldResult fieldResult = C360_SalesArea__c.SalesGroup__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        String result;
        for( Schema.PicklistEntry v : values) {
            if (v.getValue() == 'public') {
                result = v.getLabel();
            }
            SalesGroupMap.put(v.getValue(),v.getLabel());
        }
        list<string>salesGrpListReturn = new list<string>();
        String WheOrg = String.isNotBlank(selectedSalesOrg)? ' And SalesOrganization__c =\' '+ selectedSalesOrg +' \'' : ' And SalesOrganization__c IN (\'2000\',\'9100\') ';
        String WheDistCh = String.isNotBlank(selectedDistributionChannel)?  ' And DistributionChannel__c =\' '+ selectedDistributionChannel +' \'' :'';
        String queryGrp = 'Select SalesGroup__c from C360_SalesArea__c WHERE SalesGroup__c !=\'\' '+ WheOrg + ' '+ WheDistCh + ' GROUP BY  SalesGroup__c order by SalesGroup__c asc '; 
        List<sObject> SalesGroupList =Database.query(queryGrp);
            if(SalesGroupList.size() > 0){
               for(sObject i : SalesGroupList){
                     salesGrpListReturn.add(SalesGroupMap.get((string)i.get('SalesGroup__c')));
               }
            }
        return salesGrpListReturn;
    }
    
   @AuraEnabled
    public static List<string> getYear(){
        List<AggregateResult> yearList=[Select Year__c from C360_BuyingPerformanceMonthlyTOP__c Where RecordType.DeveloperName in ('TXMonthlyPerformance') and DistributionChannel__c in ('17', '25') GROUP BY  Year__c order by Year__c desc ];
        list<string>yearListReturn = new list<string>();
        for(AggregateResult i :yearList){
            yearListReturn.add((string)i.get('Year__c'));
        }
        return yearListReturn;
    }
    
   @AuraEnabled
    public static List<string> getBu(){
       List<AggregateResult> BuList=[Select BusinessUnit__c from C360_Product__c GROUP BY  BusinessUnit__c];
       list<string>BuListReturn = new list<string>();
       for(AggregateResult i :BuList){
           BuListReturn.add((string)i.get('BusinessUnit__c'));
       }
        return BuListReturn;
    }
      
  @AuraEnabled
 public static C360_BuyingPerformanceMonthlyTOP__c getDataQuery(string selectedMonth,string selectedYear,string selectedSalesOrg,string selectedSalesGroup, string selectedAccount,string selectedDistributionChannel, string selectedBu){
 try {
         map<String,String>SalesGroupMapRev = new map<String,String>(); 
         Schema.DescribeFieldResult fieldResult = C360_SalesArea__c.SalesGroup__c.getDescribe();
         List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
         String result;
         for( Schema.PicklistEntry v : values) {
             if (v.getValue() == 'public') {
                 result = v.getLabel();
             }
             SalesGroupMapRev.put(v.getLabel(),v.getValue());
         }
         C360_BuyingPerformanceMonthlyTOP__c SumRec = new C360_BuyingPerformanceMonthlyTOP__c();
                 SumRec.LastYearNetProfitUSD__c =0;
                 SumRec.CPtargetNetProfitUSD__c =0;
                 SumRec.NetProfitUSD__c =0;
                 SumRec.LastYearQuantity__c =0;
                 SumRec.CPtargetVolume__c =0;
                 SumRec.Volume__c =0;
                 SumRec.LastYearPocketmarginUSD__c =0;
                 SumRec.CPtargetPocketMarginUSD__c =0;
                 SumRec.PocketmarginUSD__c =0;
                 SumRec.CumLYNetProfitUSD__c =0;
                 SumRec.CumCPtargetNetProfitUSD__c =0;
                 SumRec.CumNetProfitUSD__c =0;
                 SumRec.CumLastYearVolume__c =0;
                 SumRec.CumCPTargetVolume__c =0;
                 SumRec.CumVolume__c =0;
                 SumRec.CumLYPocketmarginUSD__c =0;
                 SumRec.CumCPtargetPocketMarginUSD__c =0;
                 SumRec.CumPocketmarginUSD__c =0;
                 SumRec.LastYearMonthlyPocketmarginLocal__c =0;
                 SumRec.LastYearMonthlyPocketmarginUSD__c =0;      		
          //1.Check filter not blank
          string WhereSelected ='';
          string WhereTargetSelected ='';
          List<string> WhereFilter = new List<string>();
          List<string> WhereFilterTarget = new List<string>();
          List<string> WhereFilterTargetBU = new List<string>();
          List<string> GroupFilter = new List<string>();
          List<string> GroupFilterTarget = new List<string>();
          List<string> SelectSum = new List<string>(); 
          List<string> SelectTarget = new List<string>(); 
          list<string>prdNameListReturn = new list<string>();
             set<string>prdNameListSet= new set<string>();
             if(String.isNotBlank(selectedMonth) && selectedMonth != 'All'){ 
                 WhereFilter.add('Month__c = \'' + selectedMonth + '\'');
                 WhereFilterTarget.add('Month__c = \'' + selectedMonth + '\'');
                 GroupFilter.add('Month__c');
                 GroupFilterTarget.add('Month__c');
             }
             if(String.isNotBlank(selectedYear) && selectedYear != 'All'){  
                 WhereFilter.add('Year__c = \'' + selectedYear + '\'');
                 WhereFilterTarget.add('Year__c = \'' + selectedYear + '\'');
                 GroupFilter.add('Year__c');
                 GroupFilterTarget.add('Year__c');
             }
             if(String.isNotBlank(selectedSalesOrg)){
                 WhereFilter.add('SalesOrganization__c = \'' + selectedSalesOrg + '\'');
                 WhereFilterTarget.add('SalesOrganization__c = \'' + selectedSalesOrg + '\'');
                 GroupFilter.add('SalesOrganization__c');
                 GroupFilterTarget.add('SalesOrganization__c');
             }
             if(String.isNotBlank(selectedDistributionChannel)){
                 WhereFilter.add('DistributionChannel__c = \'' + selectedDistributionChannel + '\'');
                 WhereFilterTarget.add('DistributionChannel__c = \'' + selectedDistributionChannel + '\'');
                 GroupFilter.add('DistributionChannel__c'); 
                 GroupFilterTarget.add('DistributionChannel__c');
             }
             if(String.isNotBlank(selectedSalesGroup)){
                 WhereFilter.add('SalesGroup__c = \'' +  SalesGroupMapRev.get(selectedSalesGroup) + '\'');
                 WhereFilterTarget.add('SalesGroup__c = \'' +  SalesGroupMapRev.get(selectedSalesGroup) + '\'');
                 GroupFilter.add('SalesGroup__c');
                 GroupFilterTarget.add('SalesGroup__c');
             }
             if(String.isNotBlank(selectedAccount)){ 
                 WhereFilter.add('Customer__r.AccountNumber__c = \'' +  selectedAccount+ '\'');
                 WhereFilterTarget.add('Customer__r.AccountNumber__c = \'' + selectedAccount + '\'');
                 GroupFilter.add('Customer__c');
                 GroupFilterTarget.add('Customer__c');
             }
             if(String.isNotBlank(selectedBu)){ 
                 WhereFilter.add('BusinessUnit__c = \'' + selectedBu + '\'');
                 GroupFilter.add('BusinessUnit__c');
                 set<string> setBu= new set<string>(); 
                 setBu.add(selectedBu);
                 List<AggregateResult> prdNameList=[Select ProductNameText__c from C360_Product__c Where BusinessUnit__c in:setBu  GROUP BY ProductNameText__c order by ProductNameText__c asc  Limit 200 ];
                 list<string>yearListReturn = new list<string>();
                 for(AggregateResult i :prdNameList){
                     prdNameListReturn.add('\''+(string)i.get('ProductNameText__c')+'\'');
                 }
                 WhereFilterTarget.add(' ProductNameText__c in ('+ string.join(prdNameListReturn,',') +') ');
             }
             if(WhereFilter.size()> 0){
                 WhereSelected =  ' and ' +string.join(WhereFilter,' and ');
             }else{
                 GroupFilter.add('Month__c');
                 GroupFilter.add('Year__c');
                 GroupFilter.add('SalesOrganization__c');
                 GroupFilter.add('SalesGroup__c');
                 GroupFilter.add('Customer__c');
                 GroupFilter.add('BusinessUnit__c');
             }
    
             SelectSum.add('sum(LastYearNetProfitUSD__c) LastYearNetProfitUSD');
             SelectSum.add('sum(CPtargetNetProfitUSD__c) CPtargetNetProfitUSD');
             SelectSum.add('sum(NetProfitUSD__c) NetProfitUSD');
             SelectSum.add('sum(LastYearQuantity__c) LastYearQuantity');
             SelectSum.add('sum(CPtargetVolume__c) CPtargetVolume');
             SelectSum.add('sum(Volume__c) Volume');
             SelectSum.add('sum(LastYearPocketmarginUSD__c) LastYearPocketmarginUSD');
             SelectSum.add('sum(CPtargetPocketMarginUSD__c) CPtargetPocketMarginUSD');
             SelectSum.add('sum(PocketmarginUSD__c) PocketmarginUSD');
             SelectSum.add('sum(CumLYNetProfitUSD__c) CumLYNetProfitUSD');
             SelectSum.add('sum(CumCPtargetNetProfitUSD__c) CumCPtargetNetProfitUSD');
             SelectSum.add('sum(CumNetProfitUSD__c) CumNetProfitUSD');
             SelectSum.add('sum(CumLastYearVolume__c) CumLastYearVolume');
             SelectSum.add('sum(CumCPTargetVolume__c) CumCPTargetVolume');
             SelectSum.add('sum(CumVolume__c) CumVolume');
             SelectSum.add('sum(CumLYPocketmarginUSD__c) CumLYPocketmarginUSD');
             SelectSum.add('sum(CumCPtargetPocketMarginUSD__c) CumCPtargetPocketMarginUSD');
             SelectSum.add('sum(CumPocketmarginUSD__c) CumPocketmarginUSD');
             SelectSum.add('sum(LastYearMonthlyPocketmarginLocal__c) LastYearMonthlyPocketmarginLocal');
             SelectSum.add('sum(LastYearMonthlyPocketmarginUSD__c) LastYearMonthlyPocketmarginUSD');
            //return SumRec;
            String query = 'Select '+ string.join(SelectSum,',') +' From C360_BuyingPerformanceMonthlyTOP__c Where RecordType.DeveloperName in (\'TXMonthlyPerformance\') ' + WhereSelected + ' Group by '+ string.join(GroupFilter,',') + ' Limit 1 '; 
            List<sObject> SalesSummaryList =Database.query(query);
            if(SalesSummaryList.size() > 0){
               for(sObject SalesSummary : SalesSummaryList){
                    SumRec.LastYearNetProfitUSD__c = String.isNotBlank(String.valueOf(SalesSummary.get('LastYearNetProfitUSD')))?  Decimal.valueOf(String.valueOf(SalesSummary.get('LastYearNetProfitUSD'))) : 0 ;
                    SumRec.NetProfitUSD__c = String.isNotBlank(String.valueOf(SalesSummary.get('NetProfitUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('NetProfitUSD'))) : 0;
                    SumRec.LastYearQuantity__c = String.isNotBlank(String.valueOf(SalesSummary.get('LastYearQuantity')))? Decimal.valueOf(String.valueOf(SalesSummary.get('LastYearQuantity'))) : 0 ; 
                    SumRec.Volume__c =String.isNotBlank(String.valueOf(SalesSummary.get('Volume')))? Decimal.valueOf(String.valueOf(SalesSummary.get('Volume'))) : 0;
                    SumRec.LastYearPocketmarginUSD__c = String.isNotBlank(String.valueOf(SalesSummary.get('LastYearPocketmarginUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('LastYearPocketmarginUSD'))) :0;
                    SumRec.PocketmarginUSD__c = String.isNotBlank(String.valueOf(SalesSummary.get('PocketmarginUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('PocketmarginUSD'))): 0;  
                    SumRec.CumLYNetProfitUSD__c =String.isNotBlank(String.valueOf(SalesSummary.get('CumLYNetProfitUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('CumLYNetProfitUSD'))): 0;
                    SumRec.CumNetProfitUSD__c =String.isNotBlank(String.valueOf(SalesSummary.get('CumNetProfitUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('CumNetProfitUSD'))) : 0;
                    SumRec.CumLastYearVolume__c =String.isNotBlank(String.valueOf(SalesSummary.get('CumLastYearVolume')))? Decimal.valueOf(String.valueOf(SalesSummary.get('CumLastYearVolume'))): 0;
                    SumRec.CumVolume__c = String.isNotBlank(String.valueOf(SalesSummary.get('CumVolume')))? Decimal.valueOf(String.valueOf(SalesSummary.get('CumVolume'))): 0;
                    SumRec.CumLYPocketmarginUSD__c = String.isNotBlank(String.valueOf(SalesSummary.get('CumLYPocketmarginUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('CumLYPocketmarginUSD'))): 0;
                    SumRec.CumPocketmarginUSD__c = String.isNotBlank(String.valueOf(SalesSummary.get('CumPocketmarginUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('CumPocketmarginUSD'))) : 0;
                    SumRec.LastYearMonthlyPocketmarginLocal__c = String.isNotBlank(String.valueOf(SalesSummary.get('LastYearMonthlyPocketmarginLocal')))? Decimal.valueOf(String.valueOf(SalesSummary.get('LastYearMonthlyPocketmarginLocal'))) : 0;
                    SumRec.LastYearMonthlyPocketmarginUSD__c = String.isNotBlank(String.valueOf(SalesSummary.get('LastYearMonthlyPocketmarginUSD')))? Decimal.valueOf(String.valueOf(SalesSummary.get('LastYearMonthlyPocketmarginUSD'))): 0; 
               }
          }
          //====Select===Target====================================================================================================
             SelectTarget.add('sum(CPtargetNetProfitUSD__c) CPtargetNetProfitUSD');
             SelectTarget.add('sum(CPtargetVolume__c) CPtargetVolume');
             SelectTarget.add('sum(CPtargetPocketMarginUSD__c) CPtargetPocketMarginUSD');
             SelectTarget.add('sum(CumCPtargetNetProfitUSD__c) CumCPtargetNetProfitUSD');
             SelectTarget.add('sum(CumCPTargetVolume__c) CumCPTargetVolume');
             SelectTarget.add('sum(CumCPtargetPocketMarginUSD__c) CumCPtargetPocketMarginUSD'); 
             if(WhereFilterTarget.size()> 0){
                 WhereTargetSelected =  ' and ' +string.join(WhereFilterTarget,' and ');
             }else{
                 GroupFilterTarget.add('Month__c');
                 GroupFilterTarget.add('Year__c');
                 GroupFilterTarget.add('SalesOrganization__c');
                 GroupFilterTarget.add('SalesGroup__c');
                 GroupFilterTarget.add('Customer__c');
              }
              //return SumTarget;
              String queryTarget = 'Select '+ string.join(SelectTarget,',') +' From C360_BuyingPerformanceMonthlyTOP__c Where RecordType.DeveloperName in (\'TXTargetMonthlyPerformance\') ' + WhereTargetSelected + ' Group by  '+ string.join(GroupFilterTarget,',')+' Limit 1'; 
              List<sObject> SalesSummaryTargetList =Database.query(queryTarget);
              if(SalesSummaryTargetList.size() > 0){
                   for(sObject SalesSummaryTarget : SalesSummaryTargetList){
                       SumRec.CPtargetNetProfitUSD__c = String.isNotBlank(String.valueOf(SalesSummaryTarget.get('CPtargetNetProfitUSD')))? Decimal.valueOf(String.valueOf(SalesSummaryTarget.get('CPtargetNetProfitUSD'))): 0;
                       SumRec.CPtargetVolume__c = String.isNotBlank(String.valueOf(SalesSummaryTarget.get('CPtargetVolume')))? Decimal.valueOf(String.valueOf(SalesSummaryTarget.get('CPtargetVolume'))) : 0;
                       SumRec.CPtargetPocketMarginUSD__c = String.isNotBlank(String.valueOf(SalesSummaryTarget.get('CPtargetPocketMarginUSD')))? Decimal.valueOf(String.valueOf(SalesSummaryTarget.get('CPtargetPocketMarginUSD'))): 0;
                       SumRec.CumCPtargetNetProfitUSD__c = String.isNotBlank(String.valueOf(SalesSummaryTarget.get('CumCPtargetNetProfitUSD')))? Decimal.valueOf(String.valueOf(SalesSummaryTarget.get('CumCPtargetNetProfitUSD'))): 0;
                       SumRec.CumCPTargetVolume__c = String.isNotBlank(String.valueOf(SalesSummaryTarget.get('CumCPTargetVolume')))? Decimal.valueOf(String.valueOf(SalesSummaryTarget.get('CumCPTargetVolume'))): 0;
                       SumRec.CumCPtargetPocketMarginUSD__c = String.isNotBlank(String.valueOf(SalesSummaryTarget.get('CumCPtargetPocketMarginUSD')))? Decimal.valueOf(String.valueOf(SalesSummaryTarget.get('CumCPtargetPocketMarginUSD'))): 0;
                   }
                 }else{
                      SumRec.CPtargetNetProfitUSD__c = 0;
                      SumRec.CPtargetVolume__c = 0;
                      SumRec.CPtargetPocketMarginUSD__c = 0;
                      SumRec.CumCPtargetNetProfitUSD__c = 0;
                      SumRec.CumCPTargetVolume__c = 0;
                      SumRec.CumCPtargetPocketMarginUSD__c = 0;
                 }
            return SumRec;
       }catch (Exception e) {
            C360_BuyingPerformanceMonthlyTOP__c SumRec = new C360_BuyingPerformanceMonthlyTOP__c();
                SumRec.LastYearNetProfitUSD__c =0;
                SumRec.CPtargetNetProfitUSD__c =0;
                SumRec.NetProfitUSD__c =0;
                SumRec.LastYearQuantity__c =0;
                SumRec.CPtargetVolume__c =0;
                SumRec.Volume__c =0;
                SumRec.LastYearPocketmarginUSD__c =0;
                SumRec.CPtargetPocketMarginUSD__c =0;
                SumRec.PocketmarginUSD__c =0;
                SumRec.CumLYNetProfitUSD__c =0;
                SumRec.CumCPtargetNetProfitUSD__c =0;
                SumRec.CumNetProfitUSD__c =0;
                SumRec.CumLastYearVolume__c =0;
                SumRec.CumCPTargetVolume__c =0;
                SumRec.CumVolume__c =0;
                SumRec.CumLYPocketmarginUSD__c =0;
                SumRec.CumCPtargetPocketMarginUSD__c =0;
                SumRec.CumPocketmarginUSD__c =0;
                SumRec.LastYearMonthlyPocketmarginLocal__c =0;
                SumRec.LastYearMonthlyPocketmarginUSD__c =0;
            return SumRec;
        }
 	}
}