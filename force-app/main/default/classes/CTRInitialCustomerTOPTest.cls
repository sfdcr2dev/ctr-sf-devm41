@isTest
public class CTRInitialCustomerTOPTest {
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

	@TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        insert acc;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name ='R2 Solutions. Co.,Ltd.';
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.Email__c = 'testmockemail@gmail.com';
        insert reqItem;
        
        CTRShippingCountry__c shipping = new CTRShippingCountry__c();
        shipping.CTRRequestFormItem__c = reqItem.id;
        shipping.ShippingCountry__c = 'TH';
        insert shipping;
        
        CTR_RiskCountry__c risk = new CTR_RiskCountry__c();
        risk.Version__c = 'Jan2567';
        risk.CountryCode__c = 'TH';
        insert risk;
        
        CTRShareholder__c shareholder = new CTRShareholder__c();
        shareholder.name = 'Test';
        insert shareholder;
            
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

    }
    
    @IsTest 
    public static void checkDupAccountTest(){
		List<CTRShareholder__c> ShareholderList =[SELECT Id FROM CTRShareholder__c limit 1];
		List<CTRShippingCountry__c> shippingList =[SELECT Id FROM CTRShippingCountry__c limit 1];
        Test.startTest();
        	CTRInitialCustomerTOP.checkDupAccount('',ShareholderList,shippingList);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getAccInfomationTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getAccInfomation(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getHeaderInfomationTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getHeaderInfomation(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getShareHolderInfoTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getShareHolderInfo(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getShippingCountryInfoTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getShippingCountryInfo(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getUserInfomationTest(){
        Test.startTest();
        	CTRInitialCustomerTOP.getUserInfomation();
        Test.stopTest();
    }
    
    @IsTest 
    public static void getObjectAPIFromIdTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getObjectAPIFromId(record.Id);
        Test.stopTest();
    }

    @IsTest 
    public static void getReqItemInfoTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getReqItemInfo(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getItemEachStageTest(){
        Account record =[SELECT Id FROM Account limit 1];
        Test.startTest();
        	CTRInitialCustomerTOP.getItemEachStage(record.Id,'InReview');
       	 	CTRInitialCustomerTOP.getItemEachStage(record.Id,'Initial');
        Test.stopTest();
    }

    @IsTest 
    public static void testUpdateAccount(){
        Account acc =[SELECT Id FROM Account limit 1];
        acc.Name = 'Edit Name';
        update acc;

        acc =[SELECT Id,Name FROM Account limit 1];
        System.assertEquals('Edit Name', acc.Name);
    }

    @IsTest 
    public static void testDeleteAccount(){
        Account acc =[SELECT Id FROM Account limit 1];
        delete acc;

        List<Account> accList = [SELECT Id,Name FROM Account];
        System.assertEquals(0, accList.size());
    }
    
    @IsTest 
    public static void getBUInfoTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getBUInfo(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getAccountRecordTypeInitialTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getAccountRecordTypeInitial(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getRiskCountryTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRInitialCustomerTOP.getRiskCountry(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getPicklistValueTest(){
        Test.startTest();
        	CTRInitialCustomerTOP.getPicklistValue(	'ReputationInTheMarket__c','CTRRequestFormItem__c');
        Test.stopTest();
    }
    
    @IsTest 
    public static void createShareHolderAndDestinationTest(){
        List<CTRShareholder__c> recordList =[SELECT Id FROM CTRShareholder__c limit 1];
        List<CTRShippingCountry__c> shippingList =[SELECT Id FROM CTRShippingCountry__c limit 1];
        Account accList =[SELECT Id FROM Account limit 1];
        CTRRequestFormItem__c itemList =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        CTRRequestFormHeader__c headerList =[SELECT Id FROM CTRRequestFormHeader__c limit 1];
        
        Test.startTest();
        	CTRInitialCustomerTOP.createShareHolderAndDestination(recordList,shippingList,accList.Id,itemList.Id,headerList.Id,true,true);
            CTRInitialCustomerTOP.createShareHolderAndDestination(recordList,shippingList,accList.Id,itemList.Id,headerList.Id,true,false);
        	CTRInitialCustomerTOP.createShareHolderAndDestination(recordList,shippingList,accList.Id,itemList.Id,headerList.Id,false,true);
        	CTRInitialCustomerTOP.createShareHolderAndDestination(recordList,shippingList,accList.Id,itemList.Id,headerList.Id,false,false);
        Test.stopTest();
    }
}