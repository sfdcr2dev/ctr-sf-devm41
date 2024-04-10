public class C360_BuyingPerformanceMonthlyBatch implements Database.batchable<C360_BuyingPerformanceMonthlyTOP__c>{
    Decimal lastmonth = Date.Today().Month()-1;
    String lastmonthSTR = String.valueOf(lastmonth);
    public Iterable<C360_BuyingPerformanceMonthlyTOP__c> start(Database.BatchableContext BC){
        List<C360_BuyingPerformanceMonthlyTOP__c>buyingList = [SELECT Id,Year__c,Month__c,SalesOrganization__c,DistributionChannel__c,Customer__c,CompanyCode__c,ProductCode__c,Volume__c,VolumeMTON__c,RecordType.Name From C360_BuyingPerformanceMonthlyTOP__c where RecordType.DeveloperName in ('MonthlyBuyingPerformance','TXMonthlyPerformance','Lifting') AND Month__c =: lastmonthSTR AND VolumeMTON__c != null];
        return buyingList;
    }
    public void execute(Database.BatchableContext BC, List<C360_BuyingPerformanceMonthlyTOP__c> buyingList){
        try{
            map<String,Decimal>buyingactualMap = new map<String,Decimal>();
            for(C360_BuyingPerformanceMonthlyTOP__c iBuying : buyingList){
                String key = lastmonthSTR+iBuying.SalesOrganization__c + iBuying.DistributionChannel__c + iBuying.Customer__c + iBuying.ProductCode__c;
                //system.debug('key--1--'+key);
                if(buyingactualMap.containsKey(key)){
                    Decimal temp = buyingactualMap.get(key);
                    temp = temp + iBuying.VolumeMTON__c;
                    buyingactualMap.put(key,temp);
                }else{
                    buyingactualMap.put(key,iBuying.VolumeMTON__c);
                }
            }
            List<C360_CapacityVersusActual__c>vsList = [select id,ExternalID__c,ActualVolume__c from C360_CapacityVersusActual__c where ExternalID__c IN: buyingactualMap.keyset() AND ActualVolume__c != null];
            for(C360_CapacityVersusActual__c vs : vsList){
                //system.debug('key--2--'+vs.ExternalID__c);
                Decimal temp = 0;
                if(vs.ActualVolume__c != null){
                    temp = vs.ActualVolume__c;//system.debug('temp--'+temp);
                }
                vs.ActualVolume__c = temp + buyingactualMap.get(vs.ExternalID__c);//system.debug('ActualVolume__c--'+vs.ActualVolume__c);
            }//system.debug('vsList.size()--'+vsList.size());
            if(vsList.size() > 0){
                update vsList;
            }
        }catch(Exception e) {
            //System.debug(e);
        }
    }
    public void finish(Database.BatchableContext BC){}
}