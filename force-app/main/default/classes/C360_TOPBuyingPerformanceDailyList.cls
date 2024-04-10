public class C360_TOPBuyingPerformanceDailyList 
{
	public class TOPBuyingPerformanceDailyWrapper
    {       
        @AuraEnabled public string QuantityMT;
        @AuraEnabled public String QuantityL30;
        @AuraEnabled public String Total;
        @AuraEnabled public String count;
        @AuraEnabled public Integer itemsize;
        @AuraEnabled public List<ItemWrapper> itemList;
    }
    class ItemWrapper
    {
        @AuraEnabled public String DailyBuyingPerformanceNumber;
        @AuraEnabled public String BillingDate;
        @AuraEnabled public String SalesOrganization;
        @AuraEnabled public String DistributionChannel;
        @AuraEnabled public String ShippingPoint;
        @AuraEnabled public String Product;
        @AuraEnabled public Integer index;
        @AuraEnabled public String itemId;
    }
    
    @AuraEnabled(cacheable=false)
    public static List<TOPBuyingPerformanceDailyWrapper> getTableDetails(String customerID,String status)
    {
        List<TOPBuyingPerformanceDailyWrapper>returnList = new List<TOPBuyingPerformanceDailyWrapper>();
        try {
            map<String,Decimal>quantityMTMap = new map<String,Decimal>();
            map<String,Decimal>quantityL30Map = new map<String,Decimal>();
            map<String,Decimal>totalMap = new map<String,Decimal>();
            AggregateResult[] result  = [SELECT BillingDate__c,SalesOrganization__c ,DistributionChannel__c,Product__r.MaterialCode__c,Product__r.Name,ShippingPoint__c,SUM(QuantityMT__c) quantityMT,SUM(QuantityL30__c) quantityL30,SUM(Total__c) total from C360_BuyingPerformanceDailyTOP__c where Customer__c =: customerID and recordtype.developername = 'DailyPerformance' group by BillingDate__c,SalesOrganization__c ,DistributionChannel__c,Product__r.MaterialCode__c,Product__r.Name,ShippingPoint__c ];
            C360_BuyingPerformanceDailyTOP__c[] sfBuyingList  = [SELECT Id,Name,BillingDate__c,SalesOrganization__c ,DistributionChannel__c,Product__r.MaterialCode__c,Product__r.Name,ShippingPoint__c from C360_BuyingPerformanceDailyTOP__c where Customer__c =: customerID 	and recordtype.developername = 'DailyPerformance' order by name desc];

            if(!result.isempty())
            {
                for (AggregateResult ar : result)  
                {
                    String key = String.valueof(ar.get('BillingDate__c'))+String.valueof(ar.get('SalesOrganization__c'))+String.valueof(ar.get('DistributionChannel__c'))+String.valueof(ar.get('MaterialCode__c'))+String.valueof(ar.get('Name'))+String.valueof(ar.get('ShippingPoint__c'));
                    quantityMTMap.put(key,(Decimal)ar.get('quantityMT'));
                    quantityL30Map.put(key,(Decimal)ar.get('quantityL30'));
                    totalMap.put(key,(Decimal)ar.get('total'));
                }
            }
            List<String> args = new String[]{'0','number','###,###,##0.00'};
            Integer count = 0;
            Map<String,List<C360_BuyingPerformanceDailyTOP__c>> TOPbuyingItemMap = new Map<String,List<C360_BuyingPerformanceDailyTOP__c>>();
            if(!sfBuyingList.isempty())
            {
                for(C360_BuyingPerformanceDailyTOP__c item : sfBuyingList)
                {
                    String key2 = item.BillingDate__c+item.SalesOrganization__c+item.DistributionChannel__c+item.Product__r.MaterialCode__c+item.Product__r.Name+item.ShippingPoint__c;
                    if(TOPbuyingItemMap.containskey(key2))
                    {
                        List<C360_BuyingPerformanceDailyTOP__c>temp =  TOPbuyingItemMap.get(key2);
                        temp.add(item);
                        TOPbuyingItemMap.put(key2,temp);
                    }
                    else
                    {
                        List<C360_BuyingPerformanceDailyTOP__c>temp = new List<C360_BuyingPerformanceDailyTOP__c>();
                        temp.add(item);
                        TOPbuyingItemMap.put(key2,temp);
                    }
                    
                }
            }
            for(String key3 : quantityMTMap.keyset())
            {
                TOPBuyingPerformanceDailyWrapper item = new TOPBuyingPerformanceDailyWrapper();
                if(quantityMTMap.containskey(key3))
                {
                    item.QuantityMT  = '0';
                    item.QuantityL30  = '0';
                    item.Total  = '0';
                    if(quantityMTMap.get(key3) != null)
                    {
                        Decimal quantityMT = quantityMTMap.get(key3).setScale(2);  
                        item.QuantityMT  =String.format(quantityMT.format(), args);
                    }
                    if(quantityL30Map.get(key3) != null)
                    {
                        Decimal quantityL30 = quantityL30Map.get(key3).setScale(2);
                        item.QuantityL30  = String.format(quantityL30.format(), args);
                    }
                    if(totalMap.get(key3) != null)
                    {
                        Decimal total = totalMap.get(key3).setScale(2);
                        item.Total  = String.format(total.format(), args);
                    }
                }
                
                Schema.DescribeFieldResult salesorgResult = C360_BuyingPerformanceDailyTOP__c.SalesOrganization__c.getDescribe();
                List<Schema.PicklistEntry> salesorgpicklistValues = salesorgResult.getPickListValues();
                Map<String, String> salesorgMap = new Map<String, String>();
                for(Schema.PicklistEntry plVal : salesorgpicklistValues) {
                    salesorgMap.put(plVal.getValue() ,plVal.getLabel());
                }
                
                Schema.DescribeFieldResult channelResult = C360_BuyingPerformanceDailyTOP__c.DistributionChannel__c.getDescribe();
                List<Schema.PicklistEntry> channelpicklistValues = channelResult.getPickListValues();
                Map<String, String> channelMap = new Map<String, String>();
                for(Schema.PicklistEntry plVal : channelpicklistValues) {
                    channelMap.put(plVal.getValue() ,plVal.getLabel());
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
                        for(C360_BuyingPerformanceDailyTOP__c buyingItem : TOPbuyingItemMap.get(key3))
                        {
                            ItemWrapper temp = new ItemWrapper();
                            temp.Product = buyingItem.Product__r.Name;//MaterialCode__c
                            temp.DistributionChannel = channelMap.get(buyingItem.DistributionChannel__c);
                            temp.SalesOrganization = salesorgMap.get(buyingItem.SalesOrganization__c);
							temp.BillingDate = String.valueof(buyingItem.BillingDate__c);
                            temp.DailyBuyingPerformanceNumber = buyingItem.Name;
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
            List<TOPBuyingPerformanceDailyWrapper> tempList = new List<TOPBuyingPerformanceDailyWrapper>();
            Integer itemsize = 0;
            Integer lastitemsize = 0;
            if(status == 'Loading' && returnList.size() > 0)
            {
                itemsize = returnList[0].itemList.size();
                for(TOPBuyingPerformanceDailyWrapper item : returnList)
                {
                    TOPBuyingPerformanceDailyWrapper temp = new TOPBuyingPerformanceDailyWrapper();
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
            TOPBuyingPerformanceDailyWrapper addItemSize = new TOPBuyingPerformanceDailyWrapper();
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