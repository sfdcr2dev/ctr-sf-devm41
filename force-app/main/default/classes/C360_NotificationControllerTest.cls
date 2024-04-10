@isTest
public class C360_NotificationControllerTest {
	@testSetup
    public static void setupDate()
    {
        Date Expiry60 = System.Today().addDays(60);
        Date Expiry30 = System.Today().addDays(30);
        Date Expiry7 = System.Today().addDays(7);
        
        //Id idAdmin = UserInfo.getUserId();
        //system.runAs(idAdmin){
        //}
        
        Master_Map__c m = new Master_Map__c(); 
        m.Sales_Rep__c = UserInfo.getUserId();
        m.Sales_Group__c = 'TD1';
        m.type__c = 'SalesMapwithSalesGroup';
        insert m;
        
        Master_Map__c m1 = new Master_Map__c();
        m1.type__c = 'Sales Document Type';
        m1.Name = 'Type1';
        m1.Code__c = 'Type1';
        insert m1;
        
        Master_Map__c m2 = new Master_Map__c();
        m2.type__c = 'Payment Term';
        m2.Name = 'Pay1';
        m2.Code__c = 'Pay1';
        insert m2;
        
        Id art1 = [select id from RecordType where DeveloperName = 'SoldTo'].Id;
        Account acc1 = new Account();
        acc1.Name = 'Acc1';
        acc1.AccountNumber__c = '1';
        acc1.RecordTypeId = art1;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name = 'Acc2';
        acc2.AccountNumber__c = '2';
        acc1.RecordTypeId = art1;
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name = 'Acc3';
        acc3.AccountNumber__c = '3';
        acc3.RecordTypeId = art1;
        insert acc3;
        
        Contact c1 = new Contact();
        c1.Lastname = 'Lastname';
        c1.AccountId = acc1.Id;
        c1.Email = 'mail@mail.com';
        insert c1;
        
        
        C360_SalesArea__c s1 = new C360_SalesArea__c();
        s1.AccountNumber__c = acc1.id;
        s1.SalesOrganization__c = '2000';
        s1.SalesGroup__c = 'TD1';
        s1.Key__c = 's1';
        insert s1;
        
        
        C360_SalesArea__c s2 = new C360_SalesArea__c();
        s2.AccountNumber__c = acc2.id;
        s2.SalesOrganization__c = '9100';
        s2.SalesGroup__c = 'TD1';
        s2.Key__c = 's2';
        insert s2;
        
        
        C360_SalesArea__c s3 = new C360_SalesArea__c();
        s3.AccountNumber__c = acc3.id;
        s3.SalesOrganization__c = '2000';
        s3.SalesGroup__c = 'TD2';
        s3.Key__c = 's3';
        insert s3;
        
        C360_BankGuarantee__c bg1 = new C360_BankGuarantee__c();
        bg1.CompanyCode__c = '1100';
        bg1.Customer__c = acc1.id;
        bg1.ExpiryDate__c = Expiry60;
        bg1.Key__c = '1';
        insert bg1;
        
        C360_BankGuarantee__c bg2 = new C360_BankGuarantee__c();
        bg2.CompanyCode__c = '2000';
        bg2.Customer__c = acc1.id;
        bg2.ExpiryDate__c = Expiry60;
        bg2.Key__c = '2';
        insert bg2;
        
        C360_Contract__c ct1 = new C360_Contract__c();
        ct1.SalesOrganization__c = '1100';
        ct1.SoldTo__c = acc1.id;
        ct1.ContractEndDate__c = Expiry30;
        ct1.DocumentNumber__c = '1';
        ct1.SalesDocumentType__c = m1.Id;
        ct1.PaymentTerm__c = m2.Id;
        insert ct1;
        
        C360_Contract__c ct2 = new C360_Contract__c();
        ct2.SalesOrganization__c = '2000';
        ct2.SoldTo__c = acc1.id;
        ct2.ContractEndDate__c = Expiry30;
        ct2.DocumentNumber__c = '2';
        ct2.SalesDocumentType__c = m1.Id;
        ct2.PaymentTerm__c = m2.Id;
        insert ct2;
        
        C360_Contract__c ct3 = new C360_Contract__c();
        ct3.SalesOrganization__c = '2000';
        ct3.SoldTo__c = acc1.id;
        ct3.ContractEndDate__c = Expiry7;
        ct3.DocumentNumber__c = '3';
        ct3.SalesDocumentType__c = m1.Id;
        ct3.PaymentTerm__c = m2.Id;
        //insert ct3;
        
        C360_Contract__c ct4 = new C360_Contract__c();
        ct4.SalesOrganization__c = '2000';
        ct4.SoldTo__c = acc3.id;
        ct4.ContractEndDate__c = Expiry7;
        ct4.DocumentNumber__c = '4';
        ct4.SalesDocumentType__c = m1.Id;
        ct4.PaymentTerm__c = m2.Id;
        insert ct4;
        
        C360_ExciseQuota__c ex1 = new C360_ExciseQuota__c();
        ex1.SalesOrganization__c = '2000';
        ex1.ExpiryDate__c = Expiry60;
        ex1.CompanyName__c = acc1.id;
        ex1.Key__c = 'ex1';
        insert ex1;
        
        C360_ExciseQuota__c ex2 = new C360_ExciseQuota__c();
        ex2.SalesOrganization__c = '9100';
        ex2.ExpiryDate__c = Expiry60;
        ex2.CompanyName__c = acc2.id;
        ex2.Key__c = 'ex2';
        insert ex2;
        
        C360_FinancialInfo__c o1 = new C360_FinancialInfo__c();
        o1.CompanyCode__c = '1100';
        o1.CompanyName__c = acc1.id;
        o1.Outstanding__c = 100;
        o1.CreditLimit__c = 10;
        o1.notified__c = false;
        o1.Key__c = 'o1';
        insert o1;
        
        C360_FinancialInfo__c o2 = new C360_FinancialInfo__c();
        o2.CompanyCode__c = '9100';
        o2.CompanyName__c = acc2.id;
        o2.Outstanding__c = 100;
        o2.CreditLimit__c = 10;
        o2.notified__c = false;
        o2.Key__c = 'o2';
        insert o2;
        
        Id u1 = [select id from user where UserRole.DeveloperName = 'C360_TSVBDDomesticExport' limit 1].Id;
        Id u2 = [select id from user where UserRole.DeveloperName = 'C360_TSVBDManagerDomesticExport' limit 1].Id;
        //System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        Master_Map__c m3 = new Master_Map__c(); 
        m3.Sales_Rep__c = u1;
        m3.Sales_Group__c = 'TD2';
        m3.type__c = 'SalesMapwithSalesGroup';
        insert m3;
        
        Master_Map__c m4 = new Master_Map__c(); 
        m4.Sales_Rep__c = u2;
        m4.Sales_Group__c = 'TD3';
        m4.type__c = 'TSVBDManagerDomesticExport';
        insert m4;
        //}
    }
    
    @isTest
    public static void test_expireBG(){
        Test.startTest();
        C360_NotificationBellController.expireBG();
        C360_NotificationController.BGRemainingDaysSolvent();
        C360_NotificationController.BGRemainingDaysTop();
        Test.stopTest();
    }
    
    @isTest
    public static void test_expireContract(){
        Test.startTest();
        C360_NotificationBellController.expireContractTop();
        C360_NotificationBellController.expireContractSolvent();
        Test.stopTest();
    }
    
    @isTest
    public static void test_expireExciseSolvent(){
        Test.startTest();
        C360_NotificationBellController.expireExciseSolvent();
        C360_NotificationController.exciseQuotaSolvent();
        Test.stopTest();
    }
    
    @isTest
    public static void test_overOutstanding(){
        Test.startTest();
        C360_NotificationController.overOutstandingSolvent();
        C360_NotificationController.overOutstandingTop();
        Test.stopTest();
    }
    
    @isTest
    public static void test_getAllSubRoleIds(){
        Id r1 = [select UserRoleId from User where id =:UserInfo.getUserId()].UserRoleId;
        Set<ID> sr1 = new Set<ID>();
        sr1.add(r1);
        Test.startTest();
        C360_NotificationBellController.getAllSubRoleIds(sr1);
        C360_NotificationController.getAllSubRoleIds(sr1);
        Test.stopTest();
    }
}