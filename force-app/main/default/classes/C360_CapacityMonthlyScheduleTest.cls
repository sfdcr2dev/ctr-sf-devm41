@isTest
public class C360_CapacityMonthlyScheduleTest 
{
    @testSetup
    public static void setupData()
    {
        Id recordTypeId = Schema.SObjectType.C360_BuyingPerformanceMonthlyTOP__c.getRecordTypeInfosByName().get('Monthly Buying Performance').getRecordTypeId();

        user u =  [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() Limit 1];
        u.SalesOrganization__c = '1100';
        update u;
        
        Account iAccount = new Account();
        iAccount.Name = 'Test Account';
        iAccount.AccountNumber__c = '10001';
        insert iAccount;
        
        C360_SalesArea__c  isa =  new C360_SalesArea__c();
        isa.AccountNumber__c = iAccount.id;
        isa.SalesOrganization__c = '1100';
        insert isa;
        
        C360_Product__c cProduct = new C360_Product__c();
        cProduct.Name = 'Test Product';
        cProduct.MaterialCode__c = '10001';
        cProduct.SalesOrganization__c = '1100'; 
        insert cProduct;
        
        C360_UnitConversion__c iUnit = new C360_UnitConversion__c();
        iUnit.Name = 'YBG91-L30-BBL';
        iUnit.BaseUOM__c = 'L30';
        iUnit.NumeratorUOM__c = 87602.00;
        iUnit.DenominatorUOM__c = 551.00;
        iUnit.Product__c = cProduct.Id;
        iUnit.AlternativeUOM__c = 'BBL';
        iUnit.key__c = 'YBG91L30BBL';
        insert iUnit;
        
        C360_Capacity__c capRec = new C360_Capacity__c();
        capRec.SalesOrganization__c = '1100'; 
        capRec.DistributionChannel__c  = '10'; 
        capRec.Customer__c = iAccount.Id;  
        capRec.Products__c = cProduct.Id; 
        capRec.TotalRequirement__c = 500;
        capRec.Unit_Conversion__c = iUnit.id;
        insert capRec;
        
        
        C360_BuyingPerformanceMonthlyTOP__c buyingMonthly = new C360_BuyingPerformanceMonthlyTOP__c();
        buyingMonthly.Month__c = String.valueof(system.today().month() - 1);
        buyingMonthly.SalesOrganization__c = '1100';
        buyingMonthly.DistributionChannel__c = '10';
        buyingMonthly.Customer__c = iAccount.Id;
        buyingMonthly.Product__c = cProduct.Id;
        buyingMonthly.Volume__c = 100;
        buyingMonthly.VolumeMTON__c = 100;
        buyingMonthly.RecordTypeId = recordTypeId;
        insert buyingMonthly;
        
        Date lastMonth = System.today().toStartOfMonth().addMonths(-1);
        C360_CapacityVersusActual__c newRec = new C360_CapacityVersusActual__c();
        newRec.BillingDate__c = lastMonth;
        newRec.SalesOrganization__c = '1100';
        newRec.CompanyName__c = iAccount.Id;
        newRec.DistributionChannel__c = '10';
        newRec.Product__c = cProduct.Id;
        newRec.CapacityVolume__c = 100;
        newRec.Capacity__c = capRec.id;
        newRec.ActualVolume__c = 0;
        newRec.ExternalID__c = Date.today().month()-1 + capRec.SalesOrganization__c + capRec.DistributionChannel__c + capRec.Customer__c + '10001';
        insert newRec;
        
    }
    
    
    @isTest
    public static void testCapacityVSActual()
    {
        SchedulableContext sc = null;
        C360_ScheduleCapacityVSActual tsc = new C360_ScheduleCapacityVSActual();
        tsc.execute(sc);
    }

}