public without sharing class C360_CalloutBIService{
    private static String authorizeUsername = '';
    private static String authorizePassword = '';
    private static String soldToEndpoint = '';
    private static String shipToEndpoint = '';
    private static String exciseEndpoint = '';
    private static String partnerFunctionEndpoint = '';
    private static String salesAreaEndpoint = '';
    private static String salesAreaTSEndpoint = '';
    private static String productMasterEndpoint = '';
    private static String productSalesAreaEndpoint = '';
    private static String productUnitEndpoint = '';
    private static String contractEndpoint = '';
    private static String contractItemEndpoint = '';
    private static String financialEndpoint = '';
    private static String buyingMonthlyActualEndpoint = '';
    private static String buyingMonthlyTargetEndpoint = '';
    private static String buyingDailyActualEndpoint = '';
    private static String buyingDailyTargetEndpoint = '';
    private static Boolean ContractMigration = null;
    private static String apiFormat = '';
    private static DateTime yesterday;
    private static Integer contractRange;
    private static String docDateStart;
    private static String docDateEnd;
    private static String upDateStart;
    private static String upDateEnd;
    private static Http http = null;
    private static Blob headerValue;
    private static String authorizationHeader = '';
    public static void initialize(){
        C360Integration__c c360Integration = C360Integration__c.getInstance();
        authorizeUsername = c360Integration.BI_AuthorizeUsername__c;
        authorizePassword = c360Integration.BI_AuthorizePassword__c;
        headerValue = Blob.valueOf(authorizeUsername + ':' + authorizePassword);
        authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        soldToEndpoint = c360Integration.BI_EndpointCustomerSoldto__c;
        shipToEndpoint = c360Integration.BI_EndpointCustomerShipto__c;
        exciseEndpoint = c360Integration.BI_EndpointExciseQuota__c;
        partnerFunctionEndpoint = c360Integration.BI_EndpointCustomerPartnerFunction__c;
        salesAreaEndpoint = c360Integration.BI_EndpointCustomerSalesArea__c;
        salesAreaTSEndpoint = c360Integration.BI_EndpointCustomerSalesAreaTS__c;
        productMasterEndpoint = c360Integration.BI_EndpointProductMaster__c;
        productSalesAreaEndpoint = c360Integration.BI_EndpointProductSalesArea__c;
        productUnitEndpoint = c360Integration.BI_EndpointProductUnitConversion__c;
        contractEndpoint = c360Integration.BI_EndpointContract__c;
        contractItemEndpoint = c360Integration.BI_EndpointContractItem__c;
        financialEndpoint = c360Integration.BI_EndpointFinancial__c;
        buyingMonthlyActualEndpoint = c360Integration.BI_EndpointBuyingActualMonthly__c;
        buyingMonthlyTargetEndpoint = c360Integration.BI_EndpointBuyingTargetMonthly__c;
        buyingDailyActualEndpoint = c360Integration.BI_EndpointBuyingActualDaily__c;
        buyingDailyTargetEndpoint = c360Integration.BI_EndpointBuyingTargetDaily__c;
        ContractMigration = c360Integration.ContractMigration__c;
        yesterday = (c360Integration.Yesterday__c != null) ? c360Integration.Yesterday__c : System.Today().addDays(-1);
        contractRange = (c360Integration.ContractRange__c != null) ? Integer.valueOf(c360Integration.ContractRange__c) : 30;
        DateTime today = System.Today();
        if(ContractMigration){
            docDateStart = yesterday.format('yyyy-MM-dd');
            docDateEnd = yesterday.addDays(contractRange).format('yyyy-MM-dd');
            upDateStart = yesterday.addMonths(-10).format('yyyy-MM-dd');
            upDateEnd = today.format('yyyy-MM-dd');
        }else{
            docDateStart = yesterday.addMonths(-10).format('yyyy-MM-dd');
            docDateEnd = yesterday.addMonths(+10).format('yyyy-MM-dd');
            upDateStart = yesterday.format('yyyy-MM-dd');
            upDateEnd = yesterday.addDays(contractRange).format('yyyy-MM-dd');
        }
        apiFormat = ')/Results/?$format=json';
        http = new Http();
    }
    public static String calloutBI(string endpoint){
        initialize();
        String url;
        HttpRequest request = new HttpRequest();
        String contractParams = 'ZMIO_0CALDAY_02=datetime\''+ docDateStart +'T00:00:00\','+
        'ZMIO_0CALDAY_02To=datetime\''+ docDateEnd +'T00:00:00\','+
        'ZMIO_0CALDAY_03=datetime\''+ upDateStart +'T00:00:00\','+
        'ZMIO_0CALDAY_03To=datetime\''+ upDateEnd +'T00:00:00\'' + apiFormat;
        if(endpoint == 'SoldTo'){
            url = soldToEndpoint;
        }else if(endpoint == 'ShipTo'){
            url = shipToEndpoint;
        }else if(endpoint == 'Excise'){
            url = exciseEndpoint;
        }else if(endpoint == 'PartnerFunction'){
            url = partnerFunctionEndpoint;
        }else if(endpoint == 'SalesArea'){
            url = salesAreaEndpoint;
        }else if(endpoint == 'SalesAreaTS'){
            url = salesAreaTSEndpoint;
        }else if(endpoint == 'Product'){
            url = productMasterEndpoint;
        }else if(endpoint == 'ProductArea'){
            url = productSalesAreaEndpoint;
        }else if(endpoint == 'ProductUnit'){
            url = productUnitEndpoint;
        }else if(endpoint == 'Contract'){
            url = contractEndpoint+contractParams;
        }else if(endpoint == 'ContractItem'){
            url = contractItemEndpoint +contractParams;
        }
        //System.debug('url> '+url);
        request.setEndpoint(url);
        request.setHeader('Accept', '*/*');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        request.setTimeout(120 * 1000);
        HttpResponse response = http.send(request);
        try{
            response = http.send(request);
            return response.getBody();
        }catch (Exception e){
            return null;//System.debug(System.LoggingLevel.ERROR,e.getmessage());
        }
    }
    public static String calloutBI(String endpoint ,String salesOrg, String custCodeFrom, String custCodeTo,String custYear, String custMonth, String custDate){
        initialize();
        String url;
        String apiSalesOrg = 'ZMSO_0SALESORG_01=\''+ salesOrg + '\',';
        String apiCustRange = 'ZMIM_ZCUSTMR_01=\''+custCodeFrom+'\',ZMIM_ZCUSTMR_01To=\''+custCodeTo+'\',';
        String apiTimeRange = 'ZMSM_0CALYEAR_01=\''+ yesterday.year() +'\',ZMSM_0CALMONTH2_01=\''+ yesterday.month() +'\'';
        String apiYear = 'ZMSM_0CALYEAR_01=\''+ yesterday.year() +'\'';
        String apiDate = 'ZMSM_0CALDAY_01=datetime\''+ upDateStart +'T00:00:00\'';
        HttpRequest request = new HttpRequest();
        
        if(endpoint == 'BuyingActual'){
            url = buyingMonthlyActualEndpoint + apiSalesOrg + apiCustRange + apiTimeRange + apiFormat;
        }else if(endpoint == 'BuyingTarget'){
            url = buyingMonthlyTargetEndpoint + apiSalesOrg + apiCustRange + apiTimeRange + apiFormat;
        }else if(endpoint == 'BuyingDaily'){
            url = buyingDailyActualEndpoint + apiSalesOrg + apiCustRange + apiDate + apiFormat;
        }else if(endpoint == 'BuyingTargetDaily'){
            url = buyingDailyTargetEndpoint + apiSalesOrg  +apiCustRange + apiDate + apiFormat;
        }else if(endpoint == 'Financial'){
            url = financialEndpoint + apiSalesOrg + apiYear + apiFormat;
        }
        //System.debug('url> '+url);
        request.setEndpoint(url);
        request.setHeader('Accept', '*/*');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        request.setTimeout(120 * 1000);
        HttpResponse response = http.send(request);
        try{
            response = http.send(request);
            return response.getBody();
        }catch (Exception e){
            return null;//System.debug(System.LoggingLevel.ERROR, e.getmessage());
        }
    }
    public static Map<String,Id> GetSalesRep(){
        List<Master_Map__c> masterList = new list<Master_Map__c>(); 
        Map<String,Id> MapGroup = new map<String,Id>();
        masterList = [select Id, Sales_Group__c, Sales_Rep__c,Sales_Rep__r.Email from Master_Map__c where Type__c = 'SalesMapwithSalesGroup'];
        for(Master_Map__c i : masterList){
            MapGroup.put(i.Sales_Group__c, i.Sales_Rep__c);}
        return MapGroup;
    }
    
    public class Customer{
        public String A0CUSTOMER;//AccountNumber__c
        public String A0CUSTOMER_0NAME;//CustomerNameLocal1__c
        public String A0CUSTOMER_0NAME2;//CustomerNameLocal2__c
        public String A0CUSTOMER_0NAME3;//CustomerNameLocal3__c
        public String A0CUSTOMER_ZNAME5;//CustomerNameLocal4__c
        public String ZNAME;//CustomerNameEN1__c
        public String ZNAME2;//CustomerNameEN2__c
        public String ZNAME3;//CustomerNameEN3__c
        public String ZNAME4;//CustomerNameEN4__c
        public String A0CUSTOMER_0ACCNT_GRP;//AccountGroup__c
        public String A0CUSTOMER_ZTRANZN;//TransportationZone__c
        public String A0CUSTOMER_0IND_CODE_1;//Industry
        public String ZCUSSLA;//SLA__c
        public String A0CUSTOMER_ZDELFLAG;//StatusDeletionIndicator__c
        public String A0CUSTOMER_0TAX_NUMB;//TaxCode1__c
        public String A0CUSTOMER_0TAX_NUMB2;//TaxCode2__c
        public String ZBUILDING;//BuildingCodeEN__c
        public String ZRMNUM;//RoomEN__c
        public String ZFLOOR;//FloorEN__c
        public String ZHONUM;//HousenoEN__c
        public String ZSTREET;//StreetEN__c
        public String ZSTREET2;//SubDistrictEN__c
        public String ZCITY2;//DistrictEN__c
        public String ZCITY;//ProvinceEN__c
        public String ZPOST_CD;//PostalCodeEN__c
        public String ZBUILDIN2;//BuildingCodeLocal__c
        public String ZFLOOR2;//FloorLocal__c
        public String ZSTREET4;//StreetLocal__c
        public String ZHONUM2;//HousenoLocal__c
        public String ZSTREET3;//SubDistrictLocal__c
        public String A0CUSTOMER_0CITY_2;//DistrictLocal__c
        public String A0CUSTOMER_0CITY;//CityStateLocal__c
        public String A0CUSTOMER_0POSTAL_CD;//PostalCodeLocal__c
        public String A0CUSTOMER_0COUNTRY;//Country__c
        public String ZVENEMAIL;//Email__c
        public String ZFAXNUM;//Fax
        public String ZFAXEXT;//FaxExtension__c
        public String ZPHONE;//Phone
        public String ZPHEXT;//PhoneExtension__c
        public String ZMPHONE;//MobilePhone__c
        public String A0TIME_ZONE;//TimeZone__c
        public String A0CUSTOMER_0ERDAT;//CreateDateinSAP__c
        public String ZAUFSD;//CustomerBlockAll__c
        public String ZTAX5;//TaxCode5__c
    }
    public class ExciseQuota{
        public String A0CUSTOMER;//CompanyName__c
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String A0SHIP_TO;//Shiptoparty__c
        public String A0MATL_GROUP;//MaterialGroup__c
        public String ZEXCISTYP;//UsageIndicator__c
        public String ZEXCIS_NO;//Name
        public String A0DATEFROM;//PeriodFrom__c
        public String A0DATETO;//ExpiryDate__c
        public String ZEXCAPPV;//ApprovedDate__c
        public String AECUVA7JRJ25Q71LLC8O6XSFG;//VolumeinExciseDocument__c
        public String A0BASE_UOM;//VolumeinExciseDocumentUnit__c
        public String ZEXCST;//Status__c
        public String A0ERDAT;//Date__c
    }
    public class Partner{
        public String A0CUSTOMER;//Account__c
        public String ZPARTFN;//RelationshipType__c
        public String ZCUSTBP;//ReverseAccount__c
    }
    public class topSalesarea{
        public String A0CUSTOMER;//AccountNumber__c
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String A0DIVISION;//Division__c
        public String ZTPMNTTRM;//TermofPayment__c__c
        public String A0CUST_GROUP;//CustomerGroup__c
        public String A0SALES_DIST;//SalesDistrict__c
        public String ZPRCGP;//PriceGroup__c
        public String ZPRCLT;//Pricelist__c
        public String A0INCOTERMS;//Incoterms__c
        public String A0INCOTERMS2;//Incoterms2__c
        public String A0SHIP_COND;//ShippingCondition__c
        public String A0CURRENCY;//Currency
        public String ZKTGRM;//AccountAssignmentGroup__c
        public String A0SALES_GRP;//SalesGroup__c
        public String A0SALES_OFF;//SalesOffice__c
        public String A0RATE_TYPE;//ExchangeRateType__c
        public String A0C_CTR_AREA;//CreditControlArea__c
        public String A0CUST_GRP1;//CustomerGroup1__c
        public String A0CUST_GRP2;//CustomerGroup2__c
        public String A0CUST_GRP3;//CustomerGroup3__c
        public String A0CUST_GRP4;//CustomerGroup4__c
        public String A0CUST_GRP5;//CustomerGroup5__c
        public String ZDELFLAG;//Status;
        public String ZPRCP;//PricingProcedure__c
        public String ZCUSPGP;//CustomerPayment__c;
        public String ZAUFSD;//BlockStatus__c;
    }
    public class tsSalesarea{
        public String ZCUSTMR;//AccountNumber__c
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String A0DIVISION;//Division__c
        public String  ZDELFLAG;//Status;
        public String ZCUSTMR_ZTSAPP;//Applications
        public String ZCUSTMR_ZTSAPP_T;//Applications
        public String ZCUSTMR_ZTSCUSTT;//CustomerTypeCode
        public String ZCUSTMR_ZTSCUSTT_T;//CustomerTypeDesc
        public String ZCUSTMR_ZTSINDUST;//IndustryCode
        public String ZCUSTMR_ZTSINDUST_T;//IndustryDesc
        public String ZCUSTMR_ZTSSINDUS;//SubIndustry
        public String ZCUSTMR_ZTSSINDUS_T;//SubIndustryDesc
    }
    public class ProductMaster{
        public String A0MATERIAL;//MaterialCode__c
        public String A0MATERIAL_T;//Name
        public String A0MATERIAL_0BASE_UOM;//BestUnit
        public String A0MATERIAL_0DIVISION;//Division__c
        public String A0MATERIAL_0MATL_GROUP;//MaterialGroup__c
        public String A0MATERIAL_0SIZE_DIM;//SizeDimensions__c
        public String A0DEL_FLAG;//DeletionMark__c
        public String ZBU_UNIT;////BusinessUnit__c
        public String ZAEDAT2;
        public String ZAEDAT2_T;
    }
    public class prdSalesarea{
        public String A0MAT_SALES;//MaterialCode__c
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String A0MAT_SALES_ZDWERK;//Plant
        public String A0DEL_FLAG;//MarkForDelete
    }
    public class productUnitConversion{
        public String A0MATERIAL;//Product
        public String A0MATERIAL_0BASE_UOM;//BaseUOM__c
        public String ZMAT_UNT;//AlternativeUOM__c
        public String ZMAT_UNT_0DENOMINTR;//DenominatorUOM__c
        public String ZMAT_UNT_0NUMERATOR;//NumeratorUOM__c
    }
    public class Contract{
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String A0DIVISION;//Division__c
        public String A0SOLD_TO;//SoldTo__c
        public String A0SHIP_TO;//ShipTo__c
        public String ZPO_NUM;//PONumber__c
        public String ZPODATE;//PODate__c
        public String ZSALDTYPE;//SalesDocumentType__c
        public String A0DOC_NUMBER;//DocumentNumber__c
        public String A0DATEFROM;//ContractStartDate__c
        public String A0DATETO;//ContractEndDate__c
        public String A0PRICE_DATE;//PricingDate__c
        public String A0SHIP_COND;//ShippingCondition__c
        public String A0SALES_GRP;//ContractType__c
        public String ZFORMDT;//Description__c
        public String ZTPMNTTRM;//PaymentTerm__c
        public String ZCXROWID;//ComXID__c
        public String A0HEADER_DEL;//Status__c
    }
    public class ContractItem{
        public String A0MATERIAL;//Product__c
        public String AECUVA7JRJ23ZZS3ZSQTP2STU;//Price__c
        public String ZPRUNT2;//PricingUnit__c
        public String FreeVolume;//FreeVolume__c
        public String FreeVolumeUOM;//FreeVolumeUOM__c
        public String AECUVA7JRJ23ZZS3ZSQTP2Z5E;//MinimumVolume__c
        public String ZTARUNT;//MinimumVolumeUOM__c
        public String MinimumPrice;//MinimumPrice__c
        public String AECUVA7JRJ23ZZ709XOJN5PYR;//ContractVolume__c
        public String A0TARGET_QU;//ContractVolumeUOM__c
        public String AECUVA7JRJ23ZZS5WZ601YNPO;//OrderQuantity__c
        public String A0SALES_UNIT;//SalesUnit__c
        public String A0CURRENCY;//Currency__c
        public String A0SHIP_TO;//ShipTo__c
        public String A0DOC_NUMBER;//Contract__c
        public String A0S_ORD_ITEM;//SalesDocumentItem__c
        public String ZLOADSTRD;//LoadingStartDate__c
        public String ZLOADENDD;//LoadingEndDate__c
        public String A0REJECTN_ST;//RejectStatus__c
        public String A0ITEM_DEL;//Status__c
        public String AECUVA7JRJ23ZZSM8YD1OXN0C;//MaximumVolume__c
        public String ZFORM_NO;//ContractFormNo__c
    }
    public class Financial{
        public String A0SOLD_TO;//ZCUSTMR;//CompanyName__c
        public String A0SALESORG;//CompanyCode__c
        public String AECUVA7JRJ25QARVFK0I5YPJW;//PocketMargin__c
        public String AECUVA7JRJ25QCD7YNTGAAPOA_E;//CurrencyLocal__c
        public String AECUVA7JRJ25QARVFK0I5YVVG;//PocketMarginUSD__c
        public String AECUVA7JRJ25QARVFK0I5YCWS;//Revenue__c
        public String AECUVA7JRJ25QARVFK0I5YJ8C;//RevenueUSD__c
    }
    public class BuyingActual{
        public String ACALDAY;
        public String A0CALYEAR;//YearKey
        public String A0CALMONTH2;//MonthKey
        public String A0SALESORG;//SalesOrganizationKey
        public String A0DISTR_CHAN;//DistributionChannelKey
        public String A0DIVISION;//DivisionKey
        public String ZCUSTMR_ZTSSGRP;//Salesgroup
        public String ZCUSTMR;//AccountNumberKey
        public String ZMATERIL_ZSTPRDN;//ProductNameKey
        public String A0SHIP_POINT;//DeliveryModeey
        public String A0INCOTERMS;//IncotermKey
        public String ZMATERIL;
        public String ZMATERIL_ZTSSUPPRO;//Sub-productname
        public String ZMATERIL_ZSTPRDG;//ProductGroup
        public String AECUVA7JRJ25QBDAHYYVW89JR;//Volume
        public String A0UNIT_OF_WT;//Unit
        public String AECUVA7JRJ25QBDBJ10AWMFD4;//LYVolume
        public String AECUVA7JRJ2400Z40JJI9GUNU;//CumLYVolume
        public String AECUVA7JRJ2400Z4BWXV06LX9;//CumVolume
        public String ZMATERIL_ZBU_UNIT;//BusinessUnit
        public String AECUVA7JRJ2400Z50JCYBQRLE;//NetValueLocal
        public String TCURR;//CurrencyLocal
        public String AECUVA7JRJ2400Z51Q2SADDTJ;//NetValueUSD
        public String AECUVA7JRJ2400Z53KR09QQEY;//NetValueLYLocal
        public String AECUVA7JRJ2400Z53KR09QWQI;//NetValueLYUSD
        public String ZMATERIL_ZSTSALEMO;//SalesMode
        public String AECUVA7JRJ2400Z58DJX1II5N;//COGS
        public String AECUVA7JRJ2400Z58ZRQ9QV72;//FreightCostLocal
        public String AECUVA7JRJ2400Z58ZRQ9R1IM;//FreightCostUSD
        public String AECUVA7JRJ2400Z5B6DUIMIK1;//PocketMarginLocal
        public String AECUVA7JRJ2400Z5B6DUIN7U9;//PocketMarginUSD
        public String AECUVA7JRJ2400Z5B6DUIMV75;//LYPocketMarginLocal
        public String AECUVA7JRJ2400Z5B6DUINKHD;//LYPocketMarginUSD
        public String AECUVA7JRJ2400Z5B6DUIN1IP;//CumLYPocketMarginLocal
        public String AECUVA7JRJ2400Z5B6DUINQSX;//CumLYPocketMarginUSD
        public String AECUVA7JRJ2400Z5B6DUIMOVL;//CumPocketMarginLocal
        public String AECUVA7JRJ2400Z5B6DUINE5T;//CumPocketMarginUSD
        public String AECUVA7JRJ2400Z5BUN4TSZU9;//NetProfitLocal
        public String AECUVA7JRJ2400Z5BUN4TT65T;//NetProfitUSD
        public String AECUVA7JRJ2400Z5I4R37YKYV;//Loss/GainfxLocal
        public String AECUVA7JRJ2400Z5I4R37YRAF;//Loss/GainfxUSD
        public String ZCUSTMR_ZTSINDUST;//Industry
        public String ZCUSTMR_ZTSSINDUS;//Subindustry
        public String ZCUSTMR_ZTSGRP;//InterGroup
        public String ZMATERIL_ZSTPACKT;//PackType
        public String ZMATERIL_ZSTSUPG;//Supplygroup
        public String AECUVA7JRJ2400Z6U7GKSHIBQ;//RevenueLocal
        public String AECUVA7JRJ2400Z6U7GKSI7LY;//RevenueUSD
        public String AECUVA7JRJ2400Z6U7GKSHONA;//CumRevenueLocal
        public String AECUVA7JRJ2400Z6U7GKSIDXI;//CumRevenueUSD
        public String AECUVA7JRJ2400Z6U7GKSHUYU;//YTDRevenueLYLocal
        public String AECUVA7JRJ2400Z6U7GKSIK92;//YTDRevenueLYUSD
        public String AECUVA7JRJ2400Z6U7GKSI1AE;//LYRevenueLocal
        public String AECUVA7JRJ2400Z6U7GKSIQKM;//LYRevenueUSD
        public String AECUVA7JRJ25QCDAL61W5LGRI;//LastYearNetProfitUSD__c
        public String AECUVA7JRJ25QCDAL61W5LN32;//CumLYNetProfitUSD__c
        public String AECUVA7JRJ25QCDAL61W5LAFY;//CumNetProfitUSD__c
        public String AECUVA7JRJ2406UQGA7YX6MXE;//PocketMarginLocalMTDLY
        public String AECUVA7JRJ2406UQGA7YX6T8Y;//PocketMarginUSDMTDLY
        public String AECUVA7JRJ25QCDAL61W5KRHA;
        public String AECUVA7JRJ25QCDAL61W5L44E;
        public String AECUVA7JRJ25QCDAL61W5KXSU;
    }
    public class BuyingTarget{
        public String ACALDAY;
        public String A0CALYEAR;//Year
        public String A0CALMONTH2;//Month
        public String A0CUSTOMER;
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String ZCUSTMR_ZTSSGRP;//SalesGroup
        public String ZCUSTMR;//Account
        public String ZSTPRDN;//Product
        public String ZCUSTMR_ZTSINDUST;//Industry
        public String ZCUSTMR_ZTSSINDUS;//Subindustry
        public String ZCUSTMR_ZTSGRP;//InterGroup
        public String AECUVA7JRJ2401GW2RH6KKP6F;//CPtargetVolume
        public String AECUVA7JRJ2401GW65AITMKXV;//CumCPTargetVolume
        public String AECUVA7JRJ2401GWBUDGR3ETD;//CPtargetPocketMarginLocal
        public String AECUVA7JRJ2401GWBUDGR3L4X;//CPtargetPocketMarginUSD
        public String AECUVA7JRJ2401GWBUDGR3RGH;//CumCPtargetPocketMarginLocal
        public String AECUVA7JRJ2401GWBUDGR3XS1;//CumCPtargetPocketMarginUSD
        public String AECUVA7JRJ2401GWBUDGR443L;
        public String AECUVA7JRJ2401GWBUDGR4AF5;
        public String AECUVA7JRJ2401GWBUDGR4GQP;
        public String AECUVA7JRJ2401GWBUDGR4N29;
        public String A0UNIT_OF_WT;
        public String TCURR;//CurrencyLocal__c
    }
    public class BuyingDaily{
       public String A0CALDAY;//CalendarDay
        public String A0SALESORG;//SalesOrg
        public String A0DISTR_CHAN;//DC
        public String A0DIVISION;//Division
        public String ZCUSTMR_ZTSSGRP;//SaleGroup
        public String ZCUSTMR;//Cutomer
        public String ZMATERIL_ZSTPRDN;//Product
        public String ZMATERIL;//Product
        public String ZMATERIL_ZTSSUPPRO;//SubProduct
        public String ZMATERIL_ZSTPRDG;//ProductGroup
        public String AECUVA7JRJ25QC0XE3G63PIHC;//SaleVolumeMTDMT
        public String AECUVA7JRJ25QC0XRNKG65SG0_E;//Weightunit
        public String ZMATERIL_ZBU_UNIT;//BusinessUnit
        public String AECUVA7JRJ2401ME7YPN33KEU;//NetValueLocal
        public String AECUVA7JRJ2401ME7YPN325UE_E;//Currency
        public String AECUVA7JRJ2401ME7YPN33QQE;//NetValueUSD
        public String A0SHIP_POINT;//ShippingPoint
        public String ZMATERIL_ZSTSALEMO;//SalesMode
        public String AECUVA7JRJ2401ME7YPN36DJQ;//COGs
        public String AECUVA7JRJ2401ME7YPN36Q6U;//FreightCostLocal
        public String AECUVA7JRJ2401ME7YPN36WIE;//FreightCostUSD
        public String AECUVA7JRJ2401ME7YPN372TY;//PocketMarginLocal
        public String AECUVA7JRJ2401ME7YPN37S46;//PocketMarginUSD
        public String AECUVA7JRJ2401ME7YPN38HEE;//NetProfitLocal
        public String AECUVA7JRJ2401ME7YPN396OM;//NetProfitUSD
        public String AECUVA7JRJ2401ME7YPN39VYU;//Fxgain/lossbothRealizedUnrelizedLocal
        public String AECUVA7JRJ2401ME7YPN3A2AE;//Fxgain/lossbothRealizedUnrelizedUSD
        public String A0INCOTERMS;//Incotermspart
        public String ZCUSTMR_ZTSINDUST;//Industry
        public String ZCUSTMR_ZTSSINDUS;//Subindustry
        public String ZCUSTMR_ZTSGRP;//InterGroup
        public String ZMATERIL_ZSTPACKT;//PackType
        public String ZMATERIL_ZSTSUPG;//Supplygroup
        public String AECUVA7JRJ2401ME7YPN34YZA;//RevenueLocal
        public String AECUVA7JRJ25QCGW6Y8F55EU5;//RevenueUSD
    }
    public class BuyingTargetDaily{
        public String A0CALDAY;//BillingDate__c
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String ZCUSTMR_ZTSSGRP;//SalesGroup__c
        public String ZCUSTMR;//Customer__c(AccountNumber__c)
        public String ZSTPRDN;//ProductNameText__c
        public String ZCUSTMR_ZTSINDUST;//Industry__c
        public String ZCUSTMR_ZTSSINDUS;//Subindustry__c
        public String ZCUSTMR_ZTSGRP;//InterGroup__c
        public String AECUVA7JRJ25QC0Z3Y1734IOG;//CPtargetVolume__c
        public String AECUVA7JRJ25QC0YS9KH2TBNT;//CPtargetPocketMarginLocal__c
        public String AECUVA7JRJ25QCGYZPK22J2NZ;//CPtargetPocketMarginUSD__c
        public String AECUVA7JRJ25QC0YS9KH2U0Y1;//CPtargetNetProfitLocal__c
        public String AECUVA7JRJ25QC0YS9KH2UDL5;//CPtargetNetProfitUSD__c
        public String AECUVA7JRJ25QC0Z6U7BLCL36_E;//SU__c
        public String AECUVA7JRJ25QC0YS9KH2UQ89_E;//CurrencyLocal__c
    }
}