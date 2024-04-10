public class C360_TOPBuyingPerformanceMonthlyList 
{
    public class TOPBuyingPerformanceMonthlyWrapper
    {       
        @AuraEnabled public string VolumeLifting;
        @AuraEnabled public String NetValueLocal;
        @AuraEnabled public String count;
        @AuraEnabled public Integer itemsize;
        @AuraEnabled public List<ItemWrapper> itemList;
    }
    class ItemWrapper
    {
        @AuraEnabled public String MonthlyBuyingPerformanceNumber;
        @AuraEnabled public String YearMonth;
        @AuraEnabled public String SalesOrganization;
        @AuraEnabled public String DistributionChannel;
        @AuraEnabled public String ShippingPoint;
        @AuraEnabled public String Product;
        @AuraEnabled public String CurrencyLocal;
        @AuraEnabled public String VolumeLiftingUnit;
        @AuraEnabled public Integer index;
        @AuraEnabled public String itemId;
    }
    
    @AuraEnabled(cacheable=false)
    public static List<TOPBuyingPerformanceMonthlyWrapper> getTableDetails(String customerID,String status)
    {
        List<TOPBuyingPerformanceMonthlyWrapper>returnList = new List<TOPBuyingPerformanceMonthlyWrapper>();
        try { 
            map<String,Decimal>VolumeLiftingMap = new map<String,Decimal>();
            map<String,Decimal>NetValueLocalMap = new map<String,Decimal>();
            AggregateResult[] result  = [SELECT Year__c,Month__c,SalesOrganization__c,DistributionChannel__c,Product__r.MaterialCode__c,Product__r.Name,CurrencyLocal__c,ShippingPoint__c,VolumeLiftingUnit__c,SUM(VolumeLifting__c) VolumeLifting, SUM(NetValueLocal__c) NetValueLocal from C360_BuyingPerformanceMonthlyTOP__c where Customer__c =: customerID and recordtype.developername = 'Lifting' group by Year__c,SalesOrganization__c ,DistributionChannel__c,Month__c,Product__r.MaterialCode__c,Product__r.Name,CurrencyLocal__c,ShippingPoint__c,VolumeLiftingUnit__c ];
            C360_BuyingPerformanceMonthlyTOP__c[] sfBuyingList  = [SELECT Id,YearMonth__c,Year__c,Month__c,Name,SalesOrganization__c,DistributionChannel__c,Product__r.MaterialCode__c,Product__r.Name,CurrencyLocal__c,ShippingPoint__c,VolumeLiftingUnit__c,Customer__c from C360_BuyingPerformanceMonthlyTOP__c where Customer__c =: customerID and recordtype.developername ='Lifting' order by name desc];
            if(!result.isempty())
            {
                for (AggregateResult ar : result)  
                {
                    String key = String.valueof(ar.get('Year__c'))+String.valueof(ar.get('Month__c'))+String.valueof(ar.get('SalesOrganization__c'))+String.valueof(ar.get('DistributionChannel__c'))+String.valueof(ar.get('MaterialCode__c'))+String.valueof(ar.get('Name'))+String.valueof(ar.get('CurrencyLocal__c'))+String.valueof(ar.get('ShippingPoint__c'))+String.valueof(ar.get('VolumeLiftingUnit__c'));
                    VolumeLiftingMap.put(key,(Decimal)ar.get('VolumeLifting'));
                    NetValueLocalMap.put(key,(Decimal)ar.get('NetValueLocal'));
                }
            }
            List<String> args = new String[]{'0','number','###,###,##0.00'};
            Integer count = 0;
            Map<String,List<C360_BuyingPerformanceMonthlyTOP__c>> TOPbuyingItemMap = new Map<String,List<C360_BuyingPerformanceMonthlyTOP__c>>();
            if(!sfBuyingList.isempty())
            {
                for(C360_BuyingPerformanceMonthlyTOP__c item : sfBuyingList)
                {
                    String key2 = item.Year__c+item.Month__c+item.SalesOrganization__c+item.DistributionChannel__c+item.Product__r.MaterialCode__c+item.Product__r.Name+item.CurrencyLocal__c+item.ShippingPoint__c+item.VolumeLiftingUnit__c;
                    if(TOPbuyingItemMap.containskey(key2))
                    {
                        List<C360_BuyingPerformanceMonthlyTOP__c>temp =  TOPbuyingItemMap.get(key2);
                        temp.add(item);
                        TOPbuyingItemMap.put(key2,temp);
                    }
                    else
                    {
                        List<C360_BuyingPerformanceMonthlyTOP__c>temp = new List<C360_BuyingPerformanceMonthlyTOP__c>();
                        temp.add(item);
                        TOPbuyingItemMap.put(key2,temp);
                    }
                }
            }
            for(String key3 : VolumeLiftingMap.keyset())
            {
                TOPBuyingPerformanceMonthlyWrapper item = new TOPBuyingPerformanceMonthlyWrapper();
                if(VolumeLiftingMap.containskey(key3))
                {
                    item.VolumeLifting  = '0';
                    item.NetValueLocal  = '0';
                    if(VolumeLiftingMap.get(key3) != null)
                    {
                        Decimal volume = VolumeLiftingMap.get(key3).setScale(2);
                        
                        item.VolumeLifting  =String.format(volume.format(), args);
                    }
                    if(NetValueLocalMap.get(key3) != null)
                    {
                        Decimal netlocal = NetValueLocalMap.get(key3).setScale(2);
                        item.NetValueLocal  = String.format(netlocal.format(), args);
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
                
                Schema.DescribeFieldResult VolumeLiftingResult = C360_BuyingPerformanceMonthlyTOP__c.VolumeLiftingUnit__c.getDescribe();
                List<Schema.PicklistEntry> VolumeLiftingpicklistValues = VolumeLiftingResult.getPickListValues();
                Map<String, String> VolumeLiftingPicklistMap = new Map<String, String>();
                for(Schema.PicklistEntry plVal : VolumeLiftingpicklistValues) {
                    VolumeLiftingPicklistMap.put(plVal.getValue() ,plVal.getLabel());
                }
                
                Schema.DescribeFieldResult shippingResult = C360_BuyingPerformanceDailyTOP__c.ShippingPoint__c.getDescribe();
                List<Schema.PicklistEntry> shippingpicklistValues = shippingResult.getPickListValues();
                Map<String, String> shippingMap = new Map<String, String>();
                for(Schema.PicklistEntry plVal : shippingpicklistValues) {
                    shippingMap.put(plVal.getValue() ,plVal.getLabel());
                }
                
                if(TOPbuyingItemMap.containskey(key3))
                {
                    if(TOPbuyingItemMap.get(key3).size() > 0)
                    {
                        item.count = String.valueof(TOPbuyingItemMap.get(key3).size());
                        List<ItemWrapper>tempList = new List<ItemWrapper>();
                        Integer idx = 0;
                        for(C360_BuyingPerformanceMonthlyTOP__c buyingItem : TOPbuyingItemMap.get(key3))
                        {
                            ItemWrapper temp = new ItemWrapper();
                            temp.CurrencyLocal = buyingItem.CurrencyLocal__c;
                            temp.Product = buyingItem.Product__r.Name;//MaterialCode__c
                            temp.DistributionChannel = channelMap.get(buyingItem.DistributionChannel__c);
                            temp.SalesOrganization = salesorgMap.get(buyingItem.SalesOrganization__c);
                            temp.VolumeLiftingUnit = VolumeLiftingPicklistMap.get(buyingItem.VolumeLiftingUnit__c);
                            temp.YearMonth = buyingItem.YearMonth__c;
                            temp.MonthlyBuyingPerformanceNumber = buyingItem.Name;
                            temp.itemId = buyingItem.Id;
                            temp.index = idx;
                            temp.ShippingPoint = shippingMap.get(buyingItem.ShippingPoint__c);
                            
                            tempList.add(temp);
                            idx = idx +1;
                        }
                        item.itemList = tempList;
                        count = count + tempList.size();
                    }
                }
                returnList.add(item);
            }
            List<TOPBuyingPerformanceMonthlyWrapper> tempList = new List<TOPBuyingPerformanceMonthlyWrapper>();
            Integer itemsize = 0;
            Integer lastitemsize = 0;
            if(status == 'Loading' && returnList.size() > 0)
            {
                itemsize = returnList[0].itemList.size();
                for(TOPBuyingPerformanceMonthlyWrapper item : returnList)
                {
                    TOPBuyingPerformanceMonthlyWrapper temp = new TOPBuyingPerformanceMonthlyWrapper();
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
            
            TOPBuyingPerformanceMonthlyWrapper addItemSize = new TOPBuyingPerformanceMonthlyWrapper();
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
        //return null;
    }
    
}