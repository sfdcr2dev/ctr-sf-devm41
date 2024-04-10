public without sharing class C360_CalloutNonSAPService{
    private static String authorizeUsername = '';
    private static String authorizePassword = '';
    private static String soldToEndpoint = '';
    private static String shipToEndpoint = '';
    private static String salesAreaTSEndpoint = '';
    private static String productMasterEndpoint = '';
    private static String productUnitEndpoint = '';
    private static String FinancialEndpoint = '';
    private static DateTime yesterday;
    private static Http http = null;
    private static Blob headerValue;
    private static String authorizationHeader = '';
    private static String apiFormat = '';
    private static String upDateStart;
    private static String upDateEnd;
    public static void initialize(){
        C360Integration__c c360Integration = C360Integration__c.getInstance();
        authorizeUsername = c360Integration.BI_AuthorizeUsername__c;
        authorizePassword = c360Integration.BI_AuthorizePassword__c;
        headerValue = Blob.valueOf(authorizeUsername + ':' + authorizePassword);
        authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        soldToEndpoint = c360Integration.NonSAP_EndpointCustomerSoldto__c;
        shipToEndpoint = c360Integration.NonSAP_EndpointCustomerShipto__c;
        salesAreaTSEndpoint = c360Integration.NonSAP_EndpointCustomerSalesAreaTS__c;
        productMasterEndpoint = c360Integration.NonSAP_EndpointProductMaster__c;
        productUnitEndpoint = c360Integration.NonSAP_EndpointProductUnitConversion__c;
        FinancialEndpoint = c360Integration.NonSAP_EndpointFinancial__c;
        yesterday = (c360Integration.Yesterday__c != null) ? c360Integration.Yesterday__c : System.Today().addDays(-1);
        apiFormat = ')/Results/?$format=json';
        http = new Http();
    }
    public static String callout(string endpoint){
        initialize();
        String url;
        upDateStart = yesterday.addDays(-10).format('yyyy-MM-dd');
        upDateEnd = yesterday.format('yyyy-MM-dd');
        String apiDate = 'ZMIO_0CALDAY_03=datetime\''+ upDateStart +'T00:00:00\','+'ZMIO_0CALDAY_03To=datetime\''+ upDateEnd +'T00:00:00\'' + apiFormat;
        string FinancialUrl = 'ZMSM_0CALYEAR_01=\''+upDateEnd.substring(0,4) +'\',ZMSO_0SALESORG_01=\'\'' + apiFormat;
        HttpRequest request = new HttpRequest();
        if(endpoint == 'SoldTo'){
            url = soldToEndpoint + apiDate;
        }else if(endpoint == 'ShipTo'){
            url = shipToEndpoint + apiDate;
        }else if(endpoint == 'SalesAreaTS'){
            url = salesAreaTSEndpoint + apiDate;
        }else if(endpoint == 'Product'){
            url = productMasterEndpoint + apiDate;
        }else if(endpoint == 'ProductUnit'){
            url = productUnitEndpoint + apiDate;
        }else if(endpoint == 'Financial'){
            url = FinancialEndpoint + FinancialUrl;
        }
        request.setEndpoint(url);
        request.setHeader('Accept', '*/*');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        try{
            response = http.send(request);
            return response.getBody();
        }catch (Exception e){
            return null;
        }
    }
    public class Customer{
        public String A0SOLD_TO;//AccountNumber__c
        public String A4ZCCP_V05ZNAME1_L;//CustomerNameLocal1__c
        public String A4ZCCP_V05ZNAME2_L;//CustomerNameLocal2__c
        public String A4ZCCP_V05ZNAME3_L;//CustomerNameLocal3__c
        public String ZNAME5;//CustomerNameLocal4__c
        public String ZNAME;//CustomerNameEN1__c
        public String ZNAME2;//CustomerNameEN2__c
        public String ZNAME3;//CustomerNameEN3__c
        public String ZNAME4;//CustomerNameEN4__c
        public String A0ACCNT_GRP;//AccountGroup__c
        public String ZCUSSLA;//SLA__c
        public String ZDELFLAG;//StatusDeletionIndicator__c
        public String A0TAX_NUMB;//TaxCode1__c
        public String A0TAX_NUMB2;//TaxCode2__c
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
        public String ZHONUM2;//HousenoLocal__c
        public String ZSTREET4;//StreetLocal__c
        public String ZSTREET3;//SubDistrictLocal__c
        public String A4ZCCP_V05DIST_L;//DistrictLocal__c
        public String A0CITY;//CityStateLocal__c
        public String A4ZCCP_V05POST_L;//PostalCodeLocal__c
        public String A0COUNTRY;//Country__c
        public String ZVENEMAIL;//Email__c
        public String ZFAXNUM;//Fax
        public String ZFAXEXT;//FaxExtension__c
        public String ZPHONE;//Phone
        public String ZPHEXT;//PhoneExtension__c
        public String ZMPHONE;//MobilePhone__c
        public String A0TIME_ZONE;//TimeZone__c
        public String A4ZCCP_V05WEBSITE;//Website
        public String ZRMNUM2;//RoomLocal__c
    }
    public class SalesArea{
        public String ZCUSTMR;//AccountNumber__c
        public String A0SALESORG;//SalesOrganization__c
        public String A0DISTR_CHAN;//DistributionChannel__c
        public String ZTSCUSTT;//CustomerTypeCode__c
        public String ZTSCUST_T;//CustomerTypeDesc__c
        public String ZTSAPP;//ApplicationCode__c
        public String ZTSAPP_T;//ApplicationDesc__c
        public String ZTSINDUST;//IndustryCode__c
        public String ZTSINDUST_T;//IndustryDesc__c
        public String ZTSSINDUS;//SubIndustryCode__c
        public String ZTSSINDUS_T;//SubIndustryDesc__c
        public String ZSLDSTRCT;//SalesDistrict__c
        public String ZTSSGRP;//SalesGroup__c
        public String A0CURRENCY;//Currency__c
        public String A0PMNTTRMS;//TermofPayment__c
        public String A4ZCCP_V05CUSTOMERGUAR;//CustomerPayment__c
        public String A0C_CTR_AREA;//CreditControlArea__c
        public String A0INCOTERMS;//Incoterms__c
        public String ZKTGRM;//AccountAssignmentGroup__c
        public String ZDELFLAG;//Status__c
        public String ZTSCUSGRP;//TOPCustomerGroup__c
    }
    public class Products{
        public String ZMATERIL;//Material
        public String ZMATERIL_T;//Material
        public String ZMATERIL_0BASE_UOM;//Base Unit of Measure
        public String A0MATL_GROUP;//Material Group
        public String ZDELFLAG;//Delete Flag
        public String ZBU_UNIT;//Business Unit
        public String A0SIZE_DIM;//Size/dimensions
        public String A0DIVISION;//Division
    }
    public class productUnitConversion{
        public String ZMATERIL;//Material
        public String ZMATERIL_0BASE_UOM;//Base Unit of Measure
        public String A0UNIT;//Unit of Measure of Material
        public String AECUVA7JRJ25QMTRD4LP0Q52Z;//Numerator(Factor) for Conversion of Sales Quantity Into SKU
        public String AECUVA7JRJ25QMTRD4LP0QBEJ;//Denominator (divisor) for conversion of sales qty. into SKU 
    }
    public class Financial{
        public String A0SOLD_TO;//Customer Code
        public String A0SALESORG;//Sales Organization
        public decimal AECUVA7JRJ25QO2R3DU2LR2CY;//Pocket Margin (Local)
        public String AECUVA7JRJ25QO2R3DU2LRF02_E;//Local Currency
        public decimal AECUVA7JRJ25QO2R3DU2LR8OI;//Pocket Margin (USD)
        public decimal AECUVA7JRJ25QO2R3DU2LQPPU;//Revenue (Local)
        public decimal AECUVA7JRJ25QO2R3DU2LQW1E;//Revenue USD
    }
}