public class C360_ReportBuyingDailySummary {
 	public static void sumBuyingDailyMonthYear(){
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
 //1.create Mapping ContractLineItem Summary by:sum(ContractVolume__c) ============================================================================= =============== =============== 
        List<string> SelectItemMonthYear = new List<string>(); 
        SelectItemMonthYear.add('Contract__r.SalesOrganization__c');
        SelectItemMonthYear.add('Contract__r.DistributionChannel__c');
        SelectItemMonthYear.add('Contract__r.SoldTo__r.AccountNumber__c');
        SelectItemMonthYear.add('Product__c');
        SelectItemMonthYear.add('Product__r.MaterialCode__c');
        SelectItemMonthYear.add('calendar_month(Contract__r.ContractStartDate__c) StartMonth');
        SelectItemMonthYear.add('calendar_year(Contract__r.ContractStartDate__c) StartYear');
        SelectItemMonthYear.add('sum(ContractVolume__c) ContractVolume');
        SelectItemMonthYear.add('ContractVolumeUOM__c');
        String WhereConditionMonthYear ='Where Contract__r.SalesOrganization__c in(\'1300\' ,\'1700\') and Contract__r.DistributionChannel__c <>\'\' and Product__c<>null and Contract__r.ContractStartDate__c<>null and calendar_month(Contract__r.ContractStartDate__c)='+whMonth+' and calendar_year(Contract__r.ContractStartDate__c)='+whYear; 
        String groupbyMonthYear =' group by Contract__r.SalesOrganization__c, Contract__r.DistributionChannel__c,Contract__r.SoldTo__r.AccountNumber__c,Product__c,Product__r.MaterialCode__c,ContractVolumeUOM__c,calendar_month(Contract__r.ContractStartDate__c),calendar_year(Contract__r.ContractStartDate__c)';
        String queryMonthYear ='Select '+ string.join(SelectItemMonthYear,',') +' From C360_ContractLineItem__c '+WhereConditionMonthYear + groupbyMonthYear;    
        List<sObject> sobjcontractItemSummaryListMonthYear = Database.query(queryMonthYear);
        string contractStartDate ='';
        string KeyMap ='';
        map<String,decimal>contractVolumeMap = new map<String,decimal>();
        if(sobjcontractItemSummaryListMonthYear.size()>0){        
            for(sObject conItemMY : sobjcontractItemSummaryListMonthYear){ 
                KeyMap =String.valueOf(conItemMY.get('SalesOrganization__c'))+'_'+String.valueOf(conItemMY.get('DistributionChannel__c'))+'_'+String.valueOf(conItemMY.get('AccountNumber__c'))+'_'+String.valueOf(conItemMY.get('MaterialCode__c'))+'_'+String.valueOf(conItemMY.get('ContractVolumeUOM__c'))+'_'+String.valueOf(conItemMY.get('StartYear'))+'-'+String.valueOf(conItemMY.get('StartMonth')); 
                if(String.isNotBlank(String.valueOf(conItemMY.get('ContractVolume')))){
                    contractVolumeMap.put(KeyMap, decimal.valueof(String.valueOf(conItemMY.get('ContractVolume'))));
                }
            }
        }     
//2.Summary BuyingPerformanceDaily แล้วเอาไป  upsert muj object contractLineItemReport โดยจะ mapping เอาค่า sum(contract volume ) จากข้อ1มาinsertด้วย=============================================================================    
       	List<string> SelectItem = new List<string>(); 
         SelectItem.add('SalesOrganization__c');
         SelectItem.add('DistributionChannel__c');
         SelectItem.add('Customer__c');
         SelectItem.add('Customer__r.AccountNumber__c');
         SelectItem.add('Product__c');
         SelectItem.add('Product__r.MaterialCode__c');
         SelectItem.add('calendar_month(BillingDate__c) BillingStartMonth');
         SelectItem.add('calendar_year(BillingDate__c) BillingStartYear');
         SelectItem.add('Salesunit__c');
         SelectItem.add('sum(QuantityMT__c) sumQuantityMT ');
        String groupBy =' group by SalesOrganization__c, DistributionChannel__c,Customer__c,Customer__r.AccountNumber__c,calendar_month(BillingDate__c),calendar_year(BillingDate__c),Product__c,Product__r.MaterialCode__c,Salesunit__c';
  		String whereCon ='where  calendar_month(BillingDate__c)='+whMonth+' and calendar_year(BillingDate__c)='+whYear+' and SalesOrganization__c in(\'1300\',\'1700\') and BillingType__c<>\'Z2C1\' and BillingType__c<>\'Z6C1\' and BillingDate__c <> null and Customer__c <> null and Product__c<> null and Salesunit__c <> null';
       	String query ='Select '+ string.join(SelectItem,',') +' from C360_BuyingPerformanceDailyTOP__c ' + whereCon + groupBy;
         List<C360_ContractLineItemReport__c>upsertContractLineItemReport = new List<C360_ContractLineItemReport__c>();
         List<sObject> objBuyingDailyList = Database.query(query);
         if(objBuyingDailyList.size()>0){
            for(sObject obdaily : objBuyingDailyList){
                C360_ContractLineItemReport__c objContItemRpt = new C360_ContractLineItemReport__c();
                String KeyRecord ='';
                KeyRecord = String.valueOf(obdaily.get('SalesOrganization__c'))+'_'+String.valueOf(obdaily.get('DistributionChannel__c'))+'_'+String.valueOf(obdaily.get('AccountNumber__c'))+'_'+String.valueOf(obdaily.get('MaterialCode__c'))+'_'+String.valueOf(obdaily.get('Salesunit__c'))+'_'+String.valueOf(obdaily.get('BillingStartYear')) +'-'+String.valueOf(obdaily.get('BillingStartMonth'));
                objContItemRpt.Key__c =	KeyRecord;
                objContItemRpt.BillingYearMonth__c = String.valueOf(obdaily.get('BillingStartMonth'))=='10'||String.valueOf(obdaily.get('BillingStartMonth'))=='11'|| String.valueOf(obdaily.get('BillingStartMonth'))=='12'? String.valueOf(obdaily.get('BillingStartYear')) +'-'+String.valueOf(obdaily.get('BillingStartMonth')) : String.valueOf(obdaily.get('BillingStartYear')) +'-0'+String.valueOf(obdaily.get('BillingStartMonth'));    
                objContItemRpt.BillingDateMonthYearReport__c = date.valueOf(String.valueOf(obdaily.get('BillingStartYear')) +'-'+String.valueOf(obdaily.get('BillingStartMonth'))+'-1');
                objContItemRpt.SalesOrganization__c =  String.isNotBlank(String.valueOf(obdaily.get('SalesOrganization__c')))? String.valueOf(obdaily.get('SalesOrganization__c')) : '';
                objContItemRpt.DistributionChannel__c = String.isNotBlank(String.valueOf(obdaily.get('DistributionChannel__c')))? String.valueOf(obdaily.get('DistributionChannel__c')) : '';
                objContItemRpt.SoldTo__c =String.isNotBlank(String.valueOf(obdaily.get('Customer__c')))? String.valueOf(obdaily.get('Customer__c')) : '';
                objContItemRpt.Product__c = String.isNotBlank(String.valueOf(obdaily.get('Product__c')))? String.valueOf(obdaily.get('Product__c')) : '';
                objContItemRpt.VolumeLiftingMTReport__c = String.isNotBlank(String.valueOf(obdaily.get('sumQuantityMT')))? decimal.valueOf(String.valueOf(obdaily.get('sumQuantityMT'))) : 0 ;
                objContItemRpt.ContractVolumeUOM__c= String.isNotBlank(String.valueOf(obdaily.get('Salesunit__c')))? String.valueOf(obdaily.get('Salesunit__c')) : '';
                if(String.isNotBlank(String.valueOf(contractVolumeMap.get(KeyRecord)))){
                    objContItemRpt.ContractVolume__c = contractVolumeMap.get(KeyRecord);
                }else{
                    objContItemRpt.ContractVolume__c = 0;
                    objContItemRpt.VolumeAllocationMTConversion__c = 0;
                }	
              upsertContractLineItemReport.add(objContItemRpt);
            }  
         } 
         List <Database.upsertResult>acc_resultList = new List<Database.upsertResult>(); 
        if(upsertContractLineItemReport.size()> 0){         
            Schema.SObjectField ContractLineItemReportKey = C360_ContractLineItemReport__c.Fields.Key__c;
            acc_resultList= Database.upsert(upsertContractLineItemReport, ContractLineItemReportKey, false); 
            if(acc_resultList.size() > 0)
            {
                List<String>accIdList_suc = new List<String>();
                List<String>acc_errorMsg_List = new List<String>();
                map<String,List<String>>acc_errorMap = new map<String,List<String>>();
                
                for (Integer idx = 0; idx < acc_resultList.size(); idx++) 
                {
                    if (acc_resultList[idx].isSuccess()){
                        accIdList_suc.add(acc_resultList[idx].getId()); 
                    }else{
                        acc_errorMsg_List = new List<String>();
                        for(Database.Error err : acc_resultList[idx].getErrors()){
                            acc_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                        }
                        acc_errorMap.put(acc_resultList[idx].getId(),acc_errorMsg_List);
                    }
                }
                if(acc_errorMsg_List.size() > 0){
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'Replicated ContractLineItemReport';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    log.OwnerId = UserInfo.getUserId();
                }else{
                    //3.จะMapping ContractLineItemRepor with Perfomance daily = และ update BuyingPerfomancedaily object next step========================================================================
                    //====ถ้า Insert  จะมา  update Perfomance daily next step============================================================================================================                      
                    List<String> KeyReportList = new List<String>();
                    map<String,String>BuyingDailyMapIDcontract = getConcractID();
                    string keyConcractID = '';
                    List<C360_BuyingPerformanceDailyTOP__c>updateBuyingDailyList = new List<C360_BuyingPerformanceDailyTOP__c>();
                    list<C360_BuyingPerformanceDailyTOP__c>selectBuyingDailyList = [select id,KeyReport__c,BillingDate__c from C360_BuyingPerformanceDailyTOP__c                                                        where  SalesOrganization__c in('1300','1700') and BillingDate__c <> null and ContractLineItemReport__c = null  and calendar_year(BillingDate__c)=:whYear and calendar_month(BillingDate__c)=:whMonth ];
                    for(C360_BuyingPerformanceDailyTOP__c BuyingDailyItem :selectBuyingDailyList){
                        keyConcractID = BuyingDailyItem.KeyReport__c +'_'+ String.valueOf(BuyingDailyItem.BillingDate__c).substring(0,4)+'-'+BuyingDailyItem.BillingDate__c.month();
                        KeyReportList.add(BuyingDailyItem.KeyReport__c);
                        C360_BuyingPerformanceDailyTOP__c objBuyingPerformanceDaily = new C360_BuyingPerformanceDailyTOP__c();
                        objBuyingPerformanceDaily.BillingYearMonth__c= String.valueOf(BuyingDailyItem.BillingDate__c.month())=='10'||String.valueOf(BuyingDailyItem.BillingDate__c.month())=='11'||String.valueOf(BuyingDailyItem.BillingDate__c.month())=='12'? String.valueOf(BuyingDailyItem.BillingDate__c).substring(0,4)+'-'+BuyingDailyItem.BillingDate__c.month() : String.valueOf(BuyingDailyItem.BillingDate__c).substring(0,4)+'-0'+BuyingDailyItem.BillingDate__c.month();
                        objBuyingPerformanceDaily.ContractLineItemReport__c = String.isNotBlank(String.valueOf(BuyingDailyMapIDcontract.get(keyConcractID)))? BuyingDailyMapIDcontract.get(keyConcractID) : '';  
                        objBuyingPerformanceDaily.id = BuyingDailyItem.id;//BuyingDailyMapID.get(String.valueOf(sobjcontractRpt.get('KeyReport__c')));
                        updateBuyingDailyList.add(objBuyingPerformanceDaily); 
                    }
                    if(updateBuyingDailyList.size() > 0){  
                        update updateBuyingDailyList;
                    } /**/
                    //====ถ้า Insert  จะมา  update Perfomance daily next step============================================================================================================ 
                }
            }
        }
     }   
    
    public static Map<string,string> getConcractID(){
        string ConcractID = '';  
        map<String,String>ConcractIDMap = new map<String,String>();
        List<C360_ContractLineItemReport__c> queryContractRtp =[Select id, Key__c,KeyReport__c From C360_ContractLineItemReport__c]; 
        for(C360_ContractLineItemReport__c sobjcontractRpt :queryContractRtp){
            ConcractIDMap.put(sobjcontractRpt.Key__c , sobjcontractRpt.id);
        } 
        return ConcractIDMap;
    }  
}