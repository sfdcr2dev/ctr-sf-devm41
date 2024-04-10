public class C360_ReplicatedSAP_BuyingDaily{
    public class ParseException extends Exception{}
    public class dto_response extends WebserviceExtend.dto_response{}
    public static dto_response parse(String json){
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }
    public static dto_response execute(Map<String, Object> requestBody, RestRequest request){
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';
        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'C360 Replicated SAP BuyingDaily',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody).abbreviate(131000)
        );
        try{
            parseJSONInputs(body);
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                    'success' => true,
                    'message' => 'Integration Success, please review application log for the detail',
                    'linkurl' => applog.External_ID__c},
                    'recordIds' => ''
                }
            );
        }catch(Exception ex){
            applog.Error_Message__c = ex.getMessage()+ex.getLineNumber();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                    'success' => false,
                    'message' => ex.getMessage()+ex.getLineNumber(),
                    'linkurl' => applog.External_ID__c}
                }
            );
            ApplicationLogUtils.saveLogInbound(request.requestURI,applog);
        }
        return dto_response.parse(applog.Response_Body__c);
    }
    @future
    public static void parseJSONInputs(String body){
        Map<String,Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> buyingDailyList = (List<Object>)parsedBody.get('DLIST');
        string MissingSoldTo = 'MissingSoldTo = [';
        string MissingShipTo = 'MissingShipTo = [';
        List<C360_BuyingPerformanceDailyTOP__c> OverdueList = new List<C360_BuyingPerformanceDailyTOP__c>();
        List<Account> accountList = new List<Account>();
        list<string> customerList = new List<string>();
        list<string> productList = new List<string>();
        List<C360_Product__c> sf_productList = new List<C360_Product__c>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_BuyingPerformanceDailyTOP__c> upsertedBuyingDaily = new List<C360_BuyingPerformanceDailyTOP__c>();
        for(Object rawInput : buyingDailyList){ 
            Map<String, Object> input = (Map<String, Object>) rawInput;
            if(input.get('SHIP_TO') != null){
                if(String.valueOf(input.get('SHIP_TO')) != ''){
                    customerList.add(String.valueOf(input.get('SHIP_TO')));
                }
            }
            if(input.get('SOLD_TO_PARTY') != null){
                if(String.valueOf(input.get('SOLD_TO_PARTY')) != ''){
                    customerList.add(String.valueOf(Decimal.valueof(String.valueOf(input.get('SOLD_TO_PARTY')))));
                }
            }
            if(input.get('MATERIAL') != null){
                if(String.valueOf(input.get('MATERIAL')) != ''){
                    productList.add(String.valueOf(input.get('MATERIAL')));
                }
            }
        }
        Map<String, String> accNumMap = new Map<String, String>();
        if(customerList.size() > 0){
            accountList = [SELECT Id, Name,AccountNumber__c FROM Account where Name in :customerList OR AccountNumber__c IN: customerList];
            for(Account thisAcc : accountList){
                accNumMap.put(thisAcc.AccountNumber__c, thisAcc.Id);
            }
        }
        Map<String, String> productMap = new Map<String, String>();
        if(productList.size() > 0){
            sf_productList = [SELECT Id, MaterialCode__c FROM C360_Product__c where MaterialCode__c in :productList];
            for(C360_Product__c prd : sf_productList){
                productMap.put(prd.MaterialCode__c, prd.Id);
            }
        }
        Id RecordTypeId = [select id from RecordType where DeveloperName = 'DailyPerformance'].Id;
        for(Object rawInput : buyingDailyList){
            Map<String, Object> input = (Map<String, Object>) rawInput;
            C360_BuyingPerformanceDailyTOP__c buyingDailySF = new C360_BuyingPerformanceDailyTOP__c();
            buyingDailySF.RecordTypeId = RecordTypeId;
            buyingDailySF.AmountBFVatUSD__c = (input.get('AMOUNT_VAT_THB_USD') !=null && String.valueOf(input.get('AMOUNT_VAT_THB_USD')) != '') ? Decimal.valueof(String.valueOf(input.get('AMOUNT_VAT_THB_USD'))) : null;
            buyingDailySF.ExciseDutyZEX1__c = (input.get('EXCISE_DUTY_ZEX1') !=null && String.valueOf(input.get('EXCISE_DUTY_ZEX1')) != '') ? Decimal.valueof(String.valueOf(input.get('EXCISE_DUTY_ZEX1'))) : null;
            buyingDailySF.ExciseDutyZEX2__c = (input.get('EXCISE_DUTY_ZEX2') !=null && String.valueOf(input.get('EXCISE_DUTY_ZEX2')) != '') ? Decimal.valueof(String.valueOf(input.get('EXCISE_DUTY_ZEX2'))) : null;
            buyingDailySF.AmountBFVatLocal__c = (input.get('AMOUNT_BF_VAT') !=null && String.valueOf(input.get('AMOUNT_BF_VAT')) != '') ? Decimal.valueof(String.valueOf(input.get('AMOUNT_BF_VAT'))) : null;
            buyingDailySF.Taxamount__c = (input.get('TAX_AMOUNT') !=null && String.valueOf(input.get('TAX_AMOUNT')) != '') ? Decimal.valueof(String.valueOf(input.get('TAX_AMOUNT'))) : null;
            buyingDailySF.Total__c = (input.get('TOTAL') !=null && String.valueOf(input.get('TOTAL')) != '') ? Decimal.valueof(String.valueOf(input.get('TOTAL'))) : null;
            buyingDailySF.PONumber__c = String.valueOf(input.get('PO_INTERCOMPANY'));
            buyingDailySF.AddqtyLitre__c = (input.get('ADDITIONAL_QUANTITY_LITRE') !=null && String.valueOf(input.get('ADDITIONAL_QUANTITY_LITRE')) != '') ? Decimal.valueof(String.valueOf(input.get('ADDITIONAL_QUANTITY_LITRE'))) : null;
            if(input.get('SHIP_TO') != null && String.valueOf(input.get('SHIP_TO')) != ''){
                if(accNumMap.containsKey(String.valueOf(input.get('SHIP_TO')))){
                    buyingDailySF.ShipTo__c = accNumMap.get(String.valueOf(input.get('SHIP_TO')));
                }else{
                    buyingDailySF.ShipTo__c = null;
                    MissingShipTo = MissingShipTo + String.valueOf(input.get('SHIP_TO')) +',';
                }
            }else{
                buyingDailySF.ShipTo__c = null;
            }
            buyingDailySF.DONumber__c = String.valueOf(input.get('DELIVERY_ORDER_NO'));
            buyingDailySF.ShiptoName__c = String.valueOf(input.get('SHIP_TO_NAME'));
            buyingDailySF.Shiptocountry__c = String.valueOf(input.get('SHIP_TO_COUNTRY'));
            buyingDailySF.ExportInvoiceNo__c = String.valueOf(input.get('EXPORT_INVOICE_NO'));
            buyingDailySF.VesselName__c = String.valueOf(input.get('VESSEL_NAME'));
            buyingDailySF.MaterialGroup2__c = String.valueOf(input.get('MATERIAL_GROUP_2'));
            buyingDailySF.TaxamountUSD__c = (input.get('TAX_AMOUNT_THB_USD') !=null && String.valueOf(input.get('TAX_AMOUNT_THB_USD')) != '') ? Decimal.valueof(String.valueOf(input.get('TAX_AMOUNT_THB_USD'))) : null;
            buyingDailySF.TotalUSD__c = (input.get('TOTAL_THX_USD') !=null && String.valueOf(input.get('TOTAL_THX_USD')) != '') ? Decimal.valueof(String.valueOf(input.get('TOTAL_THX_USD'))) : null;
            buyingDailySF.Exchangerate__c = (input.get('EXCHANGE_RATE') !=null && String.valueOf(input.get('EXCHANGE_RATE')) != '') ? Decimal.valueof(String.valueOf(input.get('EXCHANGE_RATE'))) : null;
            buyingDailySF.FreightChargeTHB__c = (input.get('FREIGHT_USD_THB') !=null && String.valueOf(input.get('FREIGHT_USD_THB')) != '') ? Decimal.valueof(String.valueOf(input.get('FREIGHT_USD_THB'))) : null;
            buyingDailySF.SalesPriceCurrZPR1__c = String.valueOf(input.get('WAERS_ZPR1'));
            buyingDailySF.SalesPriceCurrZPR2__c = String.valueOf(input.get('WAERS_ZPR2'));
            buyingDailySF.ExciseDutyCurrZEX1__c = String.valueof(input.get('EXCISE_DUTY_CURR_ZEX1'));
            buyingDailySF.ExciseDutyCurrZEX2__c = String.valueOf(input.get('EXCISE_DUTY_CURR_ZEX2'));
            buyingDailySF.SalesOrganization__c=String.valueOf(input.get('SALES_ORGANIZATION'));
            buyingDailySF.DistributionChannel__c=String.valueOf(input.get('DISTRIBUTION_CHANNEL'));buyingDailySF.BillingDate__c = (String.valueOf(input.get('BILLING_DATE')) != '') ? StringToDate(String.valueOf(input.get('BILLING_DATE'))) : null;
            buyingDailySF.Pricingdate__c = StringToDate(String.valueOf(input.get('PRICING_DATE')));
            buyingDailySF.BillingType__c = String.valueOf(input.get('BILLING_TYPE'));
            buyingDailySF.BillingDocument__c=String.valueOf(input.get('BILLING_DOCUMENT'));
            buyingDailySF.ItemNumber__c = String.valueOf(input.get('ITEM'));
            buyingDailySF.InvoiceTaxInv__c = String.valueOf(input.get('INVOICE_NO'));
            if(input.get('SOLD_TO_PARTY') != null && String.valueOf(input.get('SOLD_TO_PARTY')) != ''){
                if(accNumMap.containsKey(String.valueOf(Decimal.valueof(String.valueOf(input.get('SOLD_TO_PARTY')))))){ 
                    buyingDailySF.Customer__c = accNumMap.get(String.valueOf(Decimal.valueof(String.valueOf(input.get('SOLD_TO_PARTY')))));
                }else{
                    buyingDailySF.Customer__c = null;
                    MissingSoldTo = MissingSoldTo + String.valueOf(input.get('SOLD_TO_PARTY')) +',';
                }
            }else{
                buyingDailySF.Customer__c = null;
            }
            buyingDailySF.SearchTerm__c = String.valueOf(input.get('SEARCH_TERM'));
            buyingDailySF.ShippingPoint__c = String.valueOf(input.get('SHIPPING_POINT'));
            buyingDailySF.Cancelled__c=String.valueOf(input.get('CANCELLED'));
            if(input.get('MATERIAL') != null && String.valueOf(input.get('MATERIAL')) != ''){
                if(productMap.containsKey(String.valueOf(input.get('MATERIAL')))){
                    buyingDailySF.Product__c = productMap.get(String.valueOf(input.get('MATERIAL')));
                }else{
                    buyingDailySF.Product__c = null;
                }
            }else{
                buyingDailySF.Product__c = null;
            }
            buyingDailySF.ProductNameText__c = String.valueOf(input.get('MATERIAL_DESCRIPTION'));
            buyingDailySF.Plant__c = String.valueOf(input.get('PLANT'));
            buyingDailySF.PlantName__c = String.valueOf(input.get('PLANT_NAME'));
            buyingDailySF.BilledQuantity__c = (input.get('BILLED_QUANTITY')!= null && String.valueOf(input.get('BILLED_QUANTITY')) != '') ? Decimal.valueof(String.valueOf(input.get('BILLED_QUANTITY'))) : null;
            buyingDailySF.Salesunit__c = String.valueOf(input.get('SALES_UNIT'));
            buyingDailySF.SalesPriceZPR1__c = (input.get('SALES_PRICE_ZPR1') != null && String.valueOf(input.get('SALES_PRICE_ZPR1')) != '') ? Decimal.valueof(String.valueOf(input.get('SALES_PRICE_ZPR1'))) : null;
            buyingDailySF.SalesPriceZPR2__c = (input.get('SALES_PRICE_ZPR2') != null && String.valueOf(input.get('SALES_PRICE_ZPR2')) != '') ? Decimal.valueof(String.valueOf(input.get('SALES_PRICE_ZPR2'))) : null;
            buyingDailySF.UnitPriceUSD__c = (input.get('UNIT_PRICE') != null && String.valueOf(input.get('UNIT_PRICE')) != '') ? Decimal.valueof(String.valueOf(input.get('UNIT_PRICE'))) : null;
            buyingDailySF.FreightChargeUSD__c = (input.get('FREIGHT_USD') != null && String.valueOf(input.get('FREIGHT_USD')) != '') ? Decimal.valueof(String.valueOf(input.get('FREIGHT_USD'))) : null;
            if(input.get('MTON') != null && String.valueOf(input.get('MTON')) != ''){
                buyingDailySF.AddqtyMT__c  = Decimal.valueof(String.valueOf(input.get('MTON')));
                buyingDailySF.QuantityMT__c  = Decimal.valueof(String.valueOf(input.get('MTON')));
            }else{
                buyingDailySF.AddqtyMT__c = null;
                buyingDailySF.QuantityMT__c = null;
            }
            buyingDailySF.QuantityBBL15__c = (input.get('BBL_15') != null && String.valueOf(input.get('BBL_15')) != '') ? Decimal.valueof(String.valueOf(input.get('BBL_15'))) : null;
            if(input.get('LITRE_30') != null && String.valueOf(input.get('LITRE_30')) != ''){
                buyingDailySF.AddqtyL30__c  = Decimal.valueof(String.valueOf(input.get('LITRE_30')));
                buyingDailySF.QuantityL30__c  = Decimal.valueof(String.valueOf(input.get('LITRE_30')));
            }else{
                buyingDailySF.AddqtyL30__c = null;
                buyingDailySF.QuantityL30__c = null;
            }
            buyingDailySF.AmountBFVatTHB__c = (input.get('AMOUNT_BF_VAT_USD_TO_THB') != null && String.valueOf(input.get('AMOUNT_BF_VAT_USD_TO_THB')) != '') ? Decimal.valueof(String.valueOf(input.get('AMOUNT_BF_VAT_USD_TO_THB'))) : null;
            buyingDailySF.TaxamountTHB__c = (input.get('TAX_AMOUNT_USD_TO_THB') != null && String.valueOf(input.get('TAX_AMOUNT_USD_TO_THB')) != '') ? Decimal.valueof(String.valueOf(input.get('TAX_AMOUNT_USD_TO_THB'))) : null;
            buyingDailySF.TotalTHB__c = (input.get('TOTAL_USD_TO_THB') != null && String.valueOf(input.get('TOTAL_USD_TO_THB')) != '') ? Decimal.valueof(String.valueOf(input.get('TOTAL_USD_TO_THB'))) : null;
            buyingDailySF.SalesPriceCurrZPR1__c = String.valueOf(input.get('SALE_PRICE_CURR_ZPR1'));//SALE_PRICE_CURR_ZPR1
            buyingDailySF.SalesPriceCurrZPR2__c = String.valueOf(input.get('SALE_PRICE_CURR_ZPR2'));//SALE_PRICE_CURR_ZPR2
            buyingDailySF.Key__c = buyingDailySF.BillingDocument__c + buyingDailySF.ItemNumber__c;
            upsertedBuyingDaily.add(buyingDailySF);
        }
        if(upsertedBuyingDaily.size() > 0){
            Schema.SObjectField buyingDailyKey = C360_BuyingPerformanceDailyTOP__c.Fields.Key__c;
            List<Database.upsertResult> BuyingDailytList = Database.upsert(upsertedBuyingDaily,buyingDailyKey,false);
            if(BuyingDailytList.size() > 0){
                List<String>BuyingAct_errorMsg_List = new List<String>();
                Map<String,List<String>> BuyingAct_errorMap = new Map<String,List<String>>();
                for (Integer idx = 0; idx < BuyingDailytList.size(); idx++){
                    if (!BuyingDailytList[idx].isSuccess()){
                        BuyingAct_errorMsg_List = new List<String>();
                        for(Database.Error err : BuyingDailytList[idx].getErrors()){
                            BuyingAct_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                        }
                        BuyingAct_errorMap.put(BuyingDailytList[idx].getId(),BuyingAct_errorMsg_List);
                    }
                }
                if(BuyingAct_errorMsg_List.size() > 0){
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'C360 Replicated SAP BuyingDaily';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    log.Response_Body__c = JSON.serialize(buyingDailyList).abbreviate(131000);
                    log.Error_Message__c = ' C360 BuyingDaily - '+BuyingAct_errorMap.keyset()+' : '+BuyingAct_errorMap.values() + ' | ' + MissingSoldTo + ' | ' + MissingShipTo;
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;}
                }else{
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'C360 Replicated SAP BuyingDaily';
                    log.Log_Type__c = 'Success';
                    log.Message_Type__c = 'Success';
                    log.Response_Body__c = JSON.serialize(buyingDailyList).abbreviate(131000);
                    log.Error_Message__c =  MissingSoldTo + ' | ' + MissingShipTo;
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;}
                }
            }
        }
    }
    private static Date StringToDate(String dateString){
        Date output;
        output = Date.valueOf(dateString);
        return output;
    }
}