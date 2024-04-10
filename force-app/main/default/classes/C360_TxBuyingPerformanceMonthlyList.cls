public class C360_TxBuyingPerformanceMonthlyList 
{
    public class BuyingPerformanceMonthlyWrapper
    {       
        @AuraEnabled public string VolumeMT;
        @AuraEnabled public String NetValueLocal;
        @AuraEnabled public String NetProfitLocal;    
        @AuraEnabled public String count;
        @AuraEnabled public Integer itemsize;
        @AuraEnabled public List<ItemWrapper> itemList;
    }
    class ItemWrapper
    {
        @AuraEnabled public String MonthlyBuyingPerformanceNumber;
        @AuraEnabled public String CurrencyLocal;
        @AuraEnabled public String Product;
        @AuraEnabled public String DistributionChannel;    
        @AuraEnabled public String SalesOrganization;
        @AuraEnabled public String Year;
        @AuraEnabled public String Month;
        @AuraEnabled public Integer index;
        @AuraEnabled public String itemId;
    }
    
    @AuraEnabled(cacheable=false)
    public static List<BuyingPerformanceMonthlyWrapper> getTableDetails(String customerID,String status)
    {
        List<BuyingPerformanceMonthlyWrapper>returnList = new List<BuyingPerformanceMonthlyWrapper>();
        try {   
            map<String,Decimal>VolumeMTONMap = new map<String,Decimal>();
            map<String,Decimal>NetValueLocalMap = new map<String,Decimal>();
            map<String,Decimal>NetProfitLocalMap = new map<String,Decimal>();
            AggregateResult[] result  = [SELECT Year__c,Month__c,SalesOrganization__c,DistributionChannel__c,Product__r.MaterialCode__c,Product__r.Name,CurrencyLocal__c,SUM(Volume__c) VolumeMTON,SUM(NetValueLocal__c) NetValueLocal,SUM(NetProfitLocal__c) NetProfitLocal from C360_BuyingPerformanceMonthlyTOP__c where Customer__c =: customerID and recordtype.developername = 'TXMonthlyPerformance' group by Year__c,SalesOrganization__c ,DistributionChannel__c,Month__c,Product__r.MaterialCode__c,Product__r.Name,CurrencyLocal__c];
            C360_BuyingPerformanceMonthlyTOP__c[] sfBuyingList =[SELECT Id,Year__c,Name,SalesOrganization__c,DistributionChannel__c,Month__c,Product__r.MaterialCode__c,Product__r.Name,CurrencyLocal__c from C360_BuyingPerformanceMonthlyTOP__c where Customer__c =: customerID and recordtype.developername ='TXMonthlyPerformance' order by name desc];
            if(!result.isempty())
            {
                for (AggregateResult ar : result)  {
                    String key = String.valueof(ar.get('Year__c'))+String.valueof(ar.get('Month__c'))+String.valueof(ar.get('SalesOrganization__c'))+String.valueof(ar.get('DistributionChannel__c'))+String.valueof(ar.get('MaterialCode__c'))+String.valueof(ar.get('Name'))+String.valueof(ar.get('CurrencyLocal__c'));
                    VolumeMTONMap.put(key,(Decimal)ar.get('VolumeMTON'));
                    NetValueLocalMap.put(key,(Decimal)ar.get('NetValueLocal'));
                    NetProfitLocalMap.put(key,(Decimal)ar.get('NetProfitLocal'));
                }
            }
            List<String> args = new String[]{'0','number','###,###,##0.00'};
            Integer count = 0;
            Map<String,List<C360_BuyingPerformanceMonthlyTOP__c>>buyingItemMap = new Map<String,List<C360_BuyingPerformanceMonthlyTOP__c>>();
            if(!sfBuyingList.isempty())
            {
                for(C360_BuyingPerformanceMonthlyTOP__c item : sfBuyingList)
                {
                    String key = item.Year__c+item.Month__c+item.SalesOrganization__c+item.DistributionChannel__c+item.Product__r.MaterialCode__c+item.Product__r.Name+item.CurrencyLocal__c;
                    if(buyingItemMap.containskey(key))
                    {
                        List<C360_BuyingPerformanceMonthlyTOP__c>temp =  buyingItemMap.get(key);
                        temp.add(item);
                        buyingItemMap.put(key,temp);
                    }
                    else
                    {
                        List<C360_BuyingPerformanceMonthlyTOP__c>temp = new List<C360_BuyingPerformanceMonthlyTOP__c>();
                        temp.add(item);
                        buyingItemMap.put(key,temp);
                    }  
                }
            }
            for(String key : VolumeMTONMap.keyset())
            {
                BuyingPerformanceMonthlyWrapper item = new BuyingPerformanceMonthlyWrapper();
                if(VolumeMTONMap.containskey(key))
                {
                    item.VolumeMT  = '0';
                    item.NetValueLocal  = '0';
                    item.NetProfitLocal  = '0';
                    if(VolumeMTONMap.get(key) != null)
                    {
                        Decimal volume = VolumeMTONMap.get(key).setScale(2);
                        
                        item.VolumeMT  =String.format(volume.format(), args);
                    }
                    if(NetValueLocalMap.get(key) != null)
                    {
                        Decimal netlocal = NetValueLocalMap.get(key).setScale(2);
                        item.NetValueLocal  = String.format(netlocal.format(), args);
                    }
                    if(NetProfitLocalMap.get(key) != null)
                    {
                        Decimal profitlocal = NetProfitLocalMap.get(key).setScale(2);
                        item.NetProfitLocal  = String.format(profitlocal.format(), args);
                    }  
                }
                
                Schema.DescribeFieldResult salesorgResult = C360_BuyingPerformanceMonthlyTOP__c.SalesOrganization__c.getDescribe();
                List<Schema.PicklistEntry> salesorgpicklistValues = salesorgResult.getPickListValues();
                Map<String, String> salesorgMap = new Map<String, String>();
                for(Schema.PicklistEntry plVal : salesorgpicklistValues) {
                    salesorgMap.put(plVal.getValue() ,plVal.getLabel());
                }
                
                Schema.DescribeFieldResult channelResult = C360_BuyingPerformanceMonthlyTOP__c.DistributionChannel__c.getDescribe();
                List<Schema.PicklistEntry> channelpicklistValues = channelResult.getPickListValues();
                Map<String, String> channelMap = new Map<String, String>();
                for(Schema.PicklistEntry plVal : channelpicklistValues) {
                    channelMap.put(plVal.getValue() ,plVal.getLabel());
                }
                
                if(buyingItemMap.containskey(key))
                {
                    if(buyingItemMap.get(key).size() > 0)
                    {
                        item.count = String.valueof(buyingItemMap.get(key).size());
                        List<ItemWrapper>tempList = new List<ItemWrapper>();
                        Integer idx = 0;
                        for(C360_BuyingPerformanceMonthlyTOP__c buyingItem : buyingItemMap.get(key))
                        {
                            ItemWrapper temp = new ItemWrapper();
                            temp.CurrencyLocal = buyingItem.CurrencyLocal__c;
                            temp.Product = buyingItem.Product__r.Name;//MaterialCode__c
                            temp.DistributionChannel = channelMap.get(buyingItem.DistributionChannel__c);
                            temp.SalesOrganization = salesorgMap.get(buyingItem.SalesOrganization__c);
                            temp.Year = buyingItem.Year__c;
                            temp.Month = buyingItem.Month__c;
                            temp.MonthlyBuyingPerformanceNumber = buyingItem.Name;
                            temp.itemId = buyingItem.Id;
                            temp.index = idx;
                            tempList.add(temp);
                            idx = idx +1;
                        }
                        item.itemList = tempList;
                        count = count + tempList.size();
                    }
                }   
                returnList.add(item);
            }
            List<BuyingPerformanceMonthlyWrapper>tempList = new List<BuyingPerformanceMonthlyWrapper>();
            Integer itemsize = 0;
            Integer lastitemsize = 0;
            if(status == 'Loading' && returnList.size() > 0)
            {   
                itemsize = returnList[0].itemList.size();
                for(BuyingPerformanceMonthlyWrapper item : returnList)
                {
                    BuyingPerformanceMonthlyWrapper temp = new BuyingPerformanceMonthlyWrapper();
                    temp = item;
                    if(itemsize > 10)
                    {
                        Integer diff = 10 - lastitemsize; 
                        List<ItemWrapper>itemwrapperList = new List<ItemWrapper>();
                        for(Integer i = 0 ; i < diff ; i++)
                        {
                            itemwrapperList.add(item.itemList[i]);
                        }
                        temp.itemList = itemwrapperList;
                        tempList.add(temp);
                        break;
                    }
                    else
                    {
                        tempList.add(temp);
                    }
                    lastitemsize = itemsize;
                    itemsize = itemsize + item.itemList.size();    
                }
            }
            
            BuyingPerformanceMonthlyWrapper addItemSize = new BuyingPerformanceMonthlyWrapper();
            addItemSize.itemsize = count;
            if(tempList.size() > 0)
            {
                tempList.add(addItemSize);
                return tempList;
            }
            else
            {
                returnList.add(addItemSize);
                return returnList; 
            }   
        }
        catch (Exception e) 
        {
            system.debug(e.getLineNumber() + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }   
}