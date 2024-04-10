public class C360_ReportContractLineItemSummary{
 //1.===Summary  ContractLineItem ไป insert ที่ object=  ContractLineItemReport
 public static void sumContractItemMonthYear(){
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
     List<string> SelectItem = new List<string>(); 
     SelectItem.add('Contract__r.SalesOrganization__c');
     SelectItem.add('Contract__r.DistributionChannel__c');
     SelectItem.add('Contract__r.SoldTo__c');
     SelectItem.add('Contract__r.SoldTo__r.AccountNumber__c');
     SelectItem.add('Product__c');
     SelectItem.add('Product__r.MaterialCode__c');
     SelectItem.add('calendar_month(Contract__r.ContractStartDate__c) StartMonth');
     SelectItem.add('calendar_year(Contract__r.ContractStartDate__c) StartYear');
     SelectItem.add('sum(ContractVolume__c) ContractVolume');
     SelectItem.add('ContractVolumeUOM__c');
     String WhereCondition ='Where (Contract__r.SalesOrganization__c=\'1300\' or Contract__r.SalesOrganization__c=\'1700\') and Contract__r.DistributionChannel__c <>\'\' and RejectStatus__c <>\'C\' and Contract__r.ContractStartDate__c  <>null and Product__c<> null and Contract__r.ContractEndDate__c  <> null and ContractVolumeUOM__c<>null and calendar_month(Contract__r.ContractStartDate__c)='+whMonth+' and calendar_year(Contract__r.ContractStartDate__c)='+whYear; 
     String query ='Select '+ string.join(SelectItem,',') +' From C360_ContractLineItem__c '+WhereCondition +' group by Contract__r.SalesOrganization__c, Contract__r.DistributionChannel__c,Contract__r.SoldTo__c,Contract__r.SoldTo__r.AccountNumber__c,calendar_month(Contract__r.ContractStartDate__c),calendar_year(Contract__r.ContractStartDate__c),Product__c,Product__r.MaterialCode__c,ContractVolumeUOM__c';
     List<sObject> sobjcontractItemSummaryList = Database.query(query);
     List<C360_ContractLineItemReport__c>upsertContractLineItemReport = new List<C360_ContractLineItemReport__c>();
      map<String,decimal>sumQuantityMTMap = MapSumQuantityMTBuyDaily();
        if(sobjcontractItemSummaryList.size()>0){
            string KeyContractReport = '';
            for(sObject contractItemSummary : sobjcontractItemSummaryList){
                C360_ContractLineItemReport__c objContItemRpt = new C360_ContractLineItemReport__c();
                KeyContractReport =String.valueOf(contractItemSummary.get('SalesOrganization__c'))+'_'+String.valueOf(contractItemSummary.get('DistributionChannel__c'))+'_'+String.valueOf(contractItemSummary.get('AccountNumber__c'))+'_'+String.valueOf(contractItemSummary.get('MaterialCode__c'))+'_'+String.valueOf(contractItemSummary.get('ContractVolumeUOM__c'))+'_'+String.valueOf(contractItemSummary.get('StartYear')) +'-'+String.valueOf(contractItemSummary.get('StartMonth'));
                objContItemRpt.Key__c = KeyContractReport; //String.valueOf(contractItemSummary.get('SalesOrganization__c'))+'_'+String.valueOf(contractItemSummary.get('DistributionChannel__c'))+'_'+String.valueOf(contractItemSummary.get('AccountNumber__c'))+'_'+String.valueOf(contractItemSummary.get('MaterialCode__c'))+'_'+String.valueOf(contractItemSummary.get('ContractVolumeUOM__c'))+'_'+String.valueOf(contractItemSummary.get('StartYear')) +'-'+String.valueOf(contractItemSummary.get('StartMonth'));
                String KeyStartDate ='';  
                objContItemRpt.SalesOrganization__c = String.isNotBlank(String.valueOf(contractItemSummary.get('SalesOrganization__c')))? String.valueOf(contractItemSummary.get('SalesOrganization__c')) : '';
                objContItemRpt.DistributionChannel__c = String.isNotBlank(String.valueOf(contractItemSummary.get('DistributionChannel__c')))? String.valueOf(contractItemSummary.get('DistributionChannel__c')): '';
                objContItemRpt.SoldTo__c = String.isNotBlank(String.valueOf(contractItemSummary.get('SoldTo__c')))? String.valueOf(contractItemSummary.get('SoldTo__c')): '';
                objContItemRpt.Product__c = String.isNotBlank(String.valueOf(contractItemSummary.get('Product__c')))? String.valueOf(contractItemSummary.get('Product__c')): '';
                objContItemRpt.ContractVolume__c = String.isNotBlank(String.valueOf(contractItemSummary.get('ContractVolume')))? Decimal.valueOf(String.valueOf(contractItemSummary.get('ContractVolume'))): 0; 
                objContItemRpt.ContractVolumeUOM__c = String.isNotBlank(String.valueOf(contractItemSummary.get('ContractVolumeUOM__c')))? String.valueOf(contractItemSummary.get('ContractVolumeUOM__c')) : '';   
                if(String.valueOf(contractItemSummary.get('ContractVolumeUOM__c')) =='MT'){
                    if(String.isNotBlank(String.valueOf(contractItemSummary.get('ContractVolume')))){
                        objContItemRpt.VolumeAllocationMTConversion__c = Decimal.valueOf(String.valueOf(contractItemSummary.get('ContractVolume')));
                    }
                }
                if(String.isNotBlank(String.valueOf(contractItemSummary.get('StartMonth')))){
                    objContItemRpt.BillingDateMonthYearReport__c = date.valueOf(String.valueOf(contractItemSummary.get('StartYear')) +'-'+String.valueOf(contractItemSummary.get('StartMonth'))+'-1');
                    if(String.valueOf(contractItemSummary.get('StartMonth'))=='10'||String.valueOf(contractItemSummary.get('StartMonth'))=='11'||String.valueOf(contractItemSummary.get('StartMonth'))=='12'){
                        objContItemRpt.ContractStartYearMonth__c = String.valueOf(contractItemSummary.get('StartYear')) +'-'+String.valueOf(contractItemSummary.get('StartMonth'));
                        objContItemRpt.BillingYearMonth__c = String.valueOf(contractItemSummary.get('StartYear')) +'-'+String.valueOf(contractItemSummary.get('StartMonth'));
                    }else{
                        objContItemRpt.ContractStartYearMonth__c = String.valueOf(contractItemSummary.get('StartYear')) +'-0'+String.valueOf(contractItemSummary.get('StartMonth'));
                        objContItemRpt.BillingYearMonth__c = String.valueOf(contractItemSummary.get('StartYear')) +'-0'+String.valueOf(contractItemSummary.get('StartMonth'));
                    }
                }
                objContItemRpt.VolumeLiftingMTReport__c  = String.isNotBlank(String.valueOf(sumQuantityMTMap.get(KeyContractReport)))? sumQuantityMTMap.get(KeyContractReport): 0;
                upsertContractLineItemReport.add(objContItemRpt);
            }
        }
     	List <Database.upsertResult> resultList = new List<Database.upsertResult>(); 
        if(upsertContractLineItemReport.size()> 0){         
         //insert upsertContractLineItemReport;
            Schema.SObjectField ContractLineItemReportKey = C360_ContractLineItemReport__c.Fields.Key__c;
            resultList = Database.upsert(upsertContractLineItemReport, ContractLineItemReportKey, false); 
            if(resultList.size() > 0)
            {
                List<String>accIdList_suc = new List<String>();
                List<String>errorMsg_List = new List<String>();
                map<String,List<String>>errorMap = new map<String,List<String>>();
                for (Integer idx = 0; idx < resultList.size(); idx++) 
                {
                    if (resultList[idx].isSuccess()) 
                    {
                        accIdList_suc.add(resultList[idx].getId()); 
                    }
                    else
                    {
                        errorMsg_List = new List<String>();
                        for(Database.Error err : resultList[idx].getErrors()) 
                        {
                            errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                        }
                        errorMap.put(resultList[idx].getId(),errorMsg_List);
                    }
                }
                if(errorMsg_List.size() > 0)
                {
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'Replicated ContractLineItemReport';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    // log.Response_Body__c = JSON.serialize(customers).abbreviate(131000);
                    // log.Error_Message__c = 'ContractLineItemReport - '+acc_errorMap.keyset()+' : '+acc_errorMap.values();
                    log.OwnerId = UserInfo.getUserId();
                    // insertApplogList.add(log);
                }
                else
                {
                    //2.หลังจาก Mapping contarctItemReport with buyingDail  ต่อไปก็จะเอา VolumeLiftingMTReport, กับ Convert contratc volume ที่มี unit ไม่เท่ากับ MT อีกรอบ   =======================================                                     	
                    List<C360_ContractLineItemReport__c>upContractLineItemReport = new List<C360_ContractLineItemReport__c>();
                    String queryItemReport = 'select id,ContractVolumeUOM__c, ContractVolume__c, VolumeAllocationMTReport__c, Product__c from C360_ContractLineItemReport__c where ContractVolume__c <> null and ContractVolumeUOM__c <> null and Product__c <> null and  VolumeAllocationMTConversion__c=null  ';
                    List<sObject> objctItemReportList = Database.query(queryItemReport);  
                    for(sObject ctItemReport : objctItemReportList){
                        C360_ContractLineItemReport__c objContractLineItemReport = new C360_ContractLineItemReport__c();
                        objContractLineItemReport.id = String.valueOf(ctItemReport.get('id'));
                        objContractLineItemReport.VolumeAllocationMTConversion__c = integer.valueOf(String.valueOf(ctItemReport.get('ContractVolume__c'))) == 0 ? 0 : convertTotalMT(decimal.valueOf(String.valueOf(ctItemReport.get('ContractVolume__c'))) ,String.valueOf(ctItemReport.get('Product__c')) ,String.valueOf(ctItemReport.get('ContractVolumeUOM__c')) );
                        upContractLineItemReport.add(objContractLineItemReport);
                    }
                    if(upContractLineItemReport.size()>0){  
                        update upContractLineItemReport;
                    }
                    //3====เมื่อ Sum Contract lineItem มา up/Inserted ที่ ContractLineItemReport==next step จะMapping ContractLineItemRepor with Perfomance daily = และ update BuyingPerfomance daily next step============================================================================================================  
                    List<String> KeyReportList = new List<String>();
                    map<String,String>BuyingDailyMapIDcontract = getConcractID();
                    string keyConcractID = '';
                    List<C360_BuyingPerformanceDailyTOP__c>updateBuyingDailyList = new List<C360_BuyingPerformanceDailyTOP__c>();
                    list<C360_BuyingPerformanceDailyTOP__c>objBuyingDailyList = [select id,KeyReport__c,BillingDate__c from C360_BuyingPerformanceDailyTOP__c where SalesOrganization__c in('1300','1700') and BillingType__c<>'Z2C1' and BillingType__c<>'Z6C1' and BillingDate__c <> null and Customer__c <> null and Product__c<> null and Salesunit__c <> null and ContractLineItemReport__c = null  and calendar_year(BillingDate__c)=:whYear and calendar_month(BillingDate__c)=:whMonth ];
                    for(C360_BuyingPerformanceDailyTOP__c BuyingDailyItem :objBuyingDailyList){ 
                        keyConcractID = BuyingDailyItem.KeyReport__c +'_'+ String.valueOf(BuyingDailyItem.BillingDate__c).substring(0,4)+'-'+BuyingDailyItem.BillingDate__c.month();
                        KeyReportList.add(BuyingDailyItem.KeyReport__c);
                        C360_BuyingPerformanceDailyTOP__c objBuyingPerformanceDaily = new C360_BuyingPerformanceDailyTOP__c();
                        objBuyingPerformanceDaily.BillingYearMonth__c = String.valueOf(BuyingDailyItem.BillingDate__c).substring(0,4)+'-'+BuyingDailyItem.BillingDate__c.month();
                        if(String.isNotBlank(String.valueOf(BuyingDailyMapIDcontract.get(keyConcractID)))){
                                        objBuyingPerformanceDaily.ContractLineItemReport__c = BuyingDailyMapIDcontract.get(keyConcractID); //String.valueOf(sobjcontractRpt.get('id'));
                         }
                        objBuyingPerformanceDaily.id = BuyingDailyItem.id;//BuyingDailyMapID.get(String.valueOf(sobjcontractRpt.get('KeyReport__c')));
                        updateBuyingDailyList.add(objBuyingPerformanceDaily);
                    }
                    List <Database.SaveResult> updateResultList = new List<Database.SaveResult>();   
                    if(updateBuyingDailyList.size() > 0){  
                        updateResultList = Database.update(updateBuyingDailyList, false);
                        for (Database.SaveResult result : updateResultList) {
                            if(result.isSuccess()){}else{
                                for (Database.Error err : result.getErrors()){ }
                            }
                        } 
                    } // End//====ถ้า Inserted  จะมา  update Perfomance daily next step============================================================================================================    
                }  
            }
        }
    }
   public static Map<string,string> getConcractID(){
       string ConcractID = '';  
       map<String,String>ConcractIDMap = new map<String,String>();
       List<C360_ContractLineItemReport__c> queryContractRtp =[Select id, Key__c ,KeyReport__c From C360_ContractLineItemReport__c]; 
       for(C360_ContractLineItemReport__c sobjcontractRpt :queryContractRtp){
           ConcractIDMap.put(sobjcontractRpt.Key__c , sobjcontractRpt.id);
       }
       return ConcractIDMap;
     }

    public static Map<string,decimal>MapSumQuantityMTBuyDaily(){
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
         map<String,decimal>sumQuantityMTMap = new map<String,decimal>();
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
  		String whereCon ='where SalesOrganization__c in(\'1300\',\'1700\') and BillingType__c<>\'Z2C1\' and BillingType__c<>\'Z6C1\' and BillingDate__c <> null and Customer__c <> null and Product__c<> null and Salesunit__c <> null and calendar_year(BillingDate__c)='+whYear+' and calendar_month(BillingDate__c)='+whMonth;
       	String query ='Select '+ string.join(SelectItem,',') +' from C360_BuyingPerformanceDailyTOP__c ' + whereCon + groupBy;
        List<sObject> objBuyingDailyList = Database.query(query);  
         if(objBuyingDailyList.size()>0){
             string  KeyRecord ='';
             for(sObject obdaily : objBuyingDailyList){
                 KeyRecord = String.valueOf(obdaily.get('SalesOrganization__c'))+'_'+String.valueOf(obdaily.get('DistributionChannel__c'))+'_'+String.valueOf(obdaily.get('AccountNumber__c'))+'_'+String.valueOf(obdaily.get('MaterialCode__c'))+'_'+String.valueOf(obdaily.get('Salesunit__c'))+'_'+String.valueOf(obdaily.get('BillingStartYear')) +'-'+String.valueOf(obdaily.get('BillingStartMonth'));
                 if(String.isNotBlank(String.valueOf(obdaily.get('sumQuantityMT')))){
                     sumQuantityMTMap.put(KeyRecord,decimal.valueOf(String.valueOf(obdaily.get('sumQuantityMT'))));
                 }else{
                     sumQuantityMTMap.put(KeyRecord, 0 );
                 }
             }
         }
        return sumQuantityMTMap;
    }
    private static Decimal convertTotalMT(Decimal total ,Id product ,String unit) {
     try { 
         Decimal a_x;
         Decimal a_y;
         Decimal b_x;
         Decimal b_y;
         C360_UnitConversion__c[] RecordA = [SELECT Id,DenominatorUOM__c,NumeratorUOM__c from C360_UnitConversion__c where Product__c =:product and AlternativeUOM__c =:unit limit 1];
         if (RecordA.size() > 0){
             a_x = RecordA[0].DenominatorUOM__c;
             a_y = RecordA[0].NumeratorUOM__c;
         }
         C360_UnitConversion__c[] RecordB = [SELECT Id,DenominatorUOM__c,NumeratorUOM__c from C360_UnitConversion__c where Product__c =:product and AlternativeUOM__c =:'MT' limit 1];
         if (RecordB.size() > 0){
             b_x = RecordB[0].DenominatorUOM__c;
             b_y = RecordB[0].NumeratorUOM__c;
         }   
         if(RecordB.size() > 0 && RecordB.size() > 0){
             Decimal a = (a_y / a_x) * total;
             Decimal b = (b_x / b_y);
             return b * a;
         }else{
             return 0;
         }
     } catch (Exception e) {
         return 0;
     }
   }
}