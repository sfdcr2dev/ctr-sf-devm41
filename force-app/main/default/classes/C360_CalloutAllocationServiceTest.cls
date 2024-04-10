@isTest
public class C360_CalloutAllocationServiceTest {
    public class MockSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            System.debug(request.getEndpoint());
            if (request.getEndpoint().startsWithIgnoreCase('https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/AllocationLifting/get?')){
                //01 Allocation Endpoint Lifting Monthly
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"saleDataLists":[{"Key":"q","Year":"2022","Month":"1","SalesOrganization":"1100","DistributionChannel":"21","AccountNumber":"1","ShipTo":"1","Division":" ","CustomerGroup":"custGroup","ProductCode":"YUG95NA","ProductGroup":"UG95","ExRefineryPrice":"22.06","WholesalePrice":"22.09","NetValue_Local_Inc_Vat":"471989.51","QuantityLTS":"19973","ACTUAL_LOADING_KG":"14351","ACTUAL_LOADING_L30":"19973","ACTUAL_LOADING_MTON":"14.35","NetValueLocal":"441111.69","CurrencyLocal":"TH4","NetValueUSD":"","VolumeLifting":"19973","VolumeLiftingUnitADD":"L30","DeliveryModeShippingpoint":"12LO","Plant":"1200","ShipTo_Country":"TH","Allocation_Monthly_Volume":"0","Allocation_Customer_Group":"BCP","Allocation_Product_Group":"UG 95"}]}');
                response.setStatusCode(200);
                return response;
            }else if (request.getEndpoint().startsWithIgnoreCase('https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/VSAllocationLifting/get?')){
                //02 Allocation Endpoint Allocation Monthly
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"AllocationVsLiftings":[{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"19.6840","CustomerGroup":"Hanwa","SaleType":"Spot Export","ProductCode":"m001","VolumeUnit":"MT","DC":"EXPORT","TOPUP_INJECT":"N/A"},{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"54.1180","CustomerGroup":"Petro Plus","SaleType":"Domestic","ProductCode":"Y150SN","VolumeUnit":"MT","DC":"DOMESTIC","TOPUP_INJECT":"N/A"}],"message":"Success"}');
                response.setStatusCode(200);
                return response;
                
            }else if (request.getEndpoint().startsWithIgnoreCase('https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/VSAllocationLiftingTLB/get?')){
                //03 Allocation Endpoint Allocation Month TLB
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"AllocationVsLiftingTBL":[{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"19.6840","CustomerGroup":"Hanwa","SaleType":"Spot Export","ProductCode":"m001","VolumeUnit":"MT","DC":"EXPORT","TOPUP_INJECT":"N/A"},{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"54.1180","CustomerGroup":"Petro Plus","SaleType":"Domestic","ProductCode":"Y150SN","VolumeUnit":"MT","DC":"DOMESTIC","TOPUP_INJECT":"N/A"}],"message":"Success"}');
                response.setStatusCode(200);
                return response;
                
            }else {
                System.assert(false, 'unexpected endpoint ' + request.getEndpoint());
                return null;
            }
        }
    }
    
    public class MockError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            System.debug(request.getEndpoint());
            if (request.getEndpoint().startsWithIgnoreCase('https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/AllocationLifting/get?')){
                //01 Allocation Endpoint Lifting Monthly
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"saleDataLists":[{"Key":"q","Year":"2022","Month":"1","SalesOrganization":"1100","DistributionChannel":"21","AccountNumber":"2","ShipTo":"2","Division":" ","CustomerGroup":"custGroup","ProductCode":"YUG95NA","ProductGroup":"UG95","ExRefineryPrice":"22.06","WholesalePrice":"22.09","NetValue_Local_Inc_Vat":"471989.51","QuantityLTS":"19973","ACTUAL_LOADING_KG":"14351","ACTUAL_LOADING_L30":"19973","ACTUAL_LOADING_MTON":"14.35","NetValueLocal":"441111.69","CurrencyLocal":"TH4R","NetValueUSD":"","VolumeLifting":"19973","VolumeLiftingUnitADD":"L30","DeliveryModeShippingpoint":"12LO","Plant":"1200","ShipTo_Country":"TH","Allocation_Monthly_Volume":"0","Allocation_Customer_Group":"BCP","Allocation_Product_Group":"UG 95"}]}');
                response.setStatusCode(200);
                return response;
            }else if (request.getEndpoint().startsWithIgnoreCase('https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/VSAllocationLifting/get?')){
                //02 Allocation Endpoint Allocation Monthly
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"AllocationVsLiftings":[{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"19.6840","CustomerGroup":"Hanwa","SaleType":"Spot Export","ProductCode":"m002","VolumeUnit":"MTA","DC":"EXPORT","TOPUP_INJECT":"N/A"},{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"54.1180","CustomerGroup":"Petro Plus","SaleType":"Domestic","ProductCode":"Y150SN","VolumeUnit":"MT","DC":"DOMESTIC","TOPUP_INJECT":"N/A"}],"message":"Success"}');
                response.setStatusCode(200);
                return response;
                
            }else if (request.getEndpoint().startsWithIgnoreCase('https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/VSAllocationLiftingTLB/get?')){
                //03 Allocation Endpoint Allocation Month TLB
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"AllocationVsLiftingTBL":[{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"19.6840","CustomerGroup":"Hanwa","SaleType":"Spot Export","ProductCode":"m002","VolumeUnit":"MTA","DC":"EXPORT","TOPUP_INJECT":"N/A"},{"Year":"2022","Month":"1","SalesOrganization":"1400","VolumeMonthlyAllocation":"0","VolumeMTDAllocation":"0","VolumeMTDLifting":"54.1180","CustomerGroup":"Petro Plus","SaleType":"Domestic","ProductCode":"Y150SN","VolumeUnit":"MT","DC":"DOMESTIC","TOPUP_INJECT":"N/A"}],"message":"Success"}');
                response.setStatusCode(200);
                return response;
                
            }else {
                System.assert(false, 'unexpected endpoint ' + request.getEndpoint());
                return null;
            }
        }
    }
    
    @TestSetup
    static void setup() {
        C360Integration__c Integrate = new C360Integration__c();
        Integrate.Allocation_AuthorizeUsername__c = 'TEST';
        Integrate.Allocation_AuthorizePassword__c = 'TEST';
        Integrate.Yesterday__c = DateTime.newInstance(2022, 01, 02);
        Integrate.Allocation_EndpointLiftingMonthly__c = 'https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/AllocationLifting/get?';
        Integrate.Allocation_EndpointAllocationMonthly__c = 'https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/VSAllocationLifting/get?';
        Integrate.AllocationEndpointAllocation_MonthlyTLB__c = 'https://thor-api.thaioilgroup.com/API_ALLOCATION_TO_SALESFORCE/VSAllocationLiftingTLB/get?';
        insert Integrate;
        
        
        List<Account> accList = new List<Account>();
        Account a1 = new Account(AccountNumber__c='1', Name='A');
        accList.add(a1);
        Account a2 = new Account(AccountNumber__c='2', Name='B');
        accList.add(a2);
        insert accList;
        
        List<C360_Product__c> productMasterList = new List<C360_Product__c>();
        C360_Product__c pdm1 = new C360_Product__c(MaterialCode__c ='m001', Name ='product name1');
        productMasterList.add(pdm1);
        insert productMasterList;
        
        
    }
    @isTest
    static void testAllocationSuccess() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSuccess());
        C360_CalloutAllocationService.syncLifting('1100');
        C360_CalloutAllocationService.syncAllocation('TOP');
        C360_CalloutAllocationService.syncAllocation('TLB');
        Test.stopTest();
    }
    @isTest
    static void testAllocationError() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockError());
        C360_CalloutAllocationService.syncLifting('1100');
        C360_CalloutAllocationService.syncAllocation('TOP');
        C360_CalloutAllocationService.syncAllocation('TLB');
        Test.stopTest();
    }
    
    @isTest
    static void testC360_ScheduleAllocation()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockSuccess());
        String jobId = System.schedule('C360_ScheduleReplicateAllocation',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduleReplicateAllocation());
        Test.stopTest();
    }
}