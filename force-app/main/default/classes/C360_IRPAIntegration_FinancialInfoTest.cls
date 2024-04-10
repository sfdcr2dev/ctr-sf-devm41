@isTest
public class C360_IRPAIntegration_FinancialInfoTest {
	@testSetup
    public static void setup()
    {
        Account acc = new Account();
        acc.Name = 'test';
        acc.AccountNumber__c = '12345';
        insert acc;
        
        C360_SalesArea__c TestSalesArea = new C360_SalesArea__c();
        TestSalesArea.SalesOrganization__c = '1100';
        TestSalesArea.AccountNumber__c= acc.id;
        C360_SalesArea__c TestSalesArea2 = new C360_SalesArea__c();
        TestSalesArea.SalesOrganization__c = '1100';
        TestSalesArea.AccountNumber__c= acc.id;
        insert TestSalesArea;
        insert TestSalesArea2;
    }
    @isTest
    public static void testGetSalesOrg()
    {        
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        C360Integration__c cs =new C360Integration__c();
        cs.iRPA_Client_Id__c = 'sb-761730fd-61a8-4d2b-bb32-38a3a87c4937!b392|sapmlirpa--irpa--production--uaa-service-broker!b68';
        cs.iRPA_Client_Secret_Id__c = 'mBfD57T9/SwUen1EAngURpgKEy4=	';
        cs.iRPA_Token_Endpoint__c = 'https://thaioilgroup.authentication.ap10.hana.ondemand.com/oauth/token';
        cs.iRPA_FinancialInfo_Endpoint__c	 = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/4d27c00d-88d0-42b2-903d-635b7f6417e6/runs';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 'TuibUORAfwohHT_FzvhM-6AKB14_GYiW';
        
        insert cs;
        
        List<Account>acc = [select id from Account];
        test.startTest();
        C360_IRPAIntegration_FinancialInfo.GetSalesOrg(acc[0].Id);
        C360_IRPAIntegration_FinancialInfo.GetAllNot2000();
        C360_IRPAIntegration_FinancialInfo.Get2000();
        test.stopTest();     
    }
}