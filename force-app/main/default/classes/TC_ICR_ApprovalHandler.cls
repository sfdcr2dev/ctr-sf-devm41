/* Author Softever */ 
/* Test class for ICR ApprovalHandler Class */
@isTest
public class TC_ICR_ApprovalHandler {

    public static testMethod void ICR_ApprovalHandler() {
        
        //Requester
        User ThaninthonUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'thaninthon',
            Email = 'thaninthon@thaioilgroup.com',
            Username = 'thaninthon@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ThaninthonUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = 'vatchara@thaioilgroup.com',
            Username = 'vatchara@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = 'chaiyar@thaioilgroup.com',
            Username = 'chaiyar@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = 'narongsak@thaioilgroup.com',
            Username = 'narongsak@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = 'rungnapa@thaioilgroup.com',
            Username = 'rungnapa@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'THANINTHON';
        thaninthon.LEVEL__c = 'Junior';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Thaninthon';
        thaninthon.ENLASTNAME__c = 'On-Sri';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'thaninthon@thaioilgroup.com';
        thaninthon.User__c = ThaninthonUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'vatchara@thaioilgroup.com';
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        vatchara.Active__c = true;
        vatchara.MAINPOSITION__c = true;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        chaiyar.Active__c = true;
        chaiyar.MAINPOSITION__c = true;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        narongsak.Active__c = true;
        narongsak.MAINPOSITION__c = true;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        rungnapa.Active__c = true;
        rungnapa.MAINPOSITION__c = true;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
        
        System.runAs(ThaninthonUser) {
            
            ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
            ICR.EmployeeID = '08000288';
            ICR.AllReportToID();
            
            ICR_Config__c ICRConfig = new ICR_Config__c();
            ICRConfig.Document_No_Year__c = '2022';
            ICRConfig.Expire_Committee_Reminder__c = 90;
            ICRConfig.Document_No_Running__c = '001';
            insert(ICRConfig);
            
            ICR_Approval__c InsertICR = new ICR_Approval__c();
            InsertICR.Request_Reason__c = 'Test Reason';
            InsertICR.Start_Date__c = date.today();
            InsertICR.Committee_Title__c = 'Test Committee Title';
            InsertICR.End_Date__c = date.today();
            insert(InsertICR);
            
            update(InsertICR);
            
        }
        
    }
    
    public static testMethod void ICR_ApprovalHandlerFindingEVP() {
        
        //Requester
        User ThaninthonUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'thaninthon',
            Email = 'thaninthon@thaioilgroup.com',
            Username = 'thaninthon@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ThaninthonUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = 'vatchara@thaioilgroup.com',
            Username = 'vatchara@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = 'chaiyar@thaioilgroup.com',
            Username = 'chaiyar@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = 'narongsak@thaioilgroup.com',
            Username = 'narongsak@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = 'rungnapa@thaioilgroup.com',
            Username = 'rungnapa@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'THANINTHON';
        thaninthon.LEVEL__c = 'Junior';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Thaninthon';
        thaninthon.ENLASTNAME__c = 'On-Sri';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'thaninthon@thaioilgroup.com';
        thaninthon.User__c = ThaninthonUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'vatchara@thaioilgroup.com';
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        vatchara.Active__c = true;
        vatchara.MAINPOSITION__c = true;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        chaiyar.Active__c = true;
        chaiyar.MAINPOSITION__c = true;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        narongsak.Active__c = true;
        narongsak.MAINPOSITION__c = true;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        rungnapa.Active__c = true;
        rungnapa.MAINPOSITION__c = true;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
        
        System.runAs(ThaninthonUser) {
            
            ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
            ICR.EmployeeID = '08000288';
            ICR.AllReportToID();
            
            ICR_Config__c ICRConfig = new ICR_Config__c();
            ICRConfig.Document_No_Year__c = '2022';
            ICRConfig.Expire_Committee_Reminder__c = 90;
            ICRConfig.Document_No_Running__c = '001';
            insert(ICRConfig);
            
            ICR_Approval__c InsertICR = new ICR_Approval__c();
            InsertICR.Request_Reason__c = 'Test Reason';
            InsertICR.Start_Date__c = date.today();
            InsertICR.Committee_Title__c = 'Test Committee Title';
            InsertICR.End_Date__c = date.today();
            insert(InsertICR);
            
            InsertICR.Status__c = 'Waiting Requester Update Result';
            update(InsertICR);
            
        }
        
    }
    
    public static testMethod void ICR_ApprovalHandlerFindingSubCordinate() {
        
        //Requester
        User ThaninthonUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'thaninthon',
            Email = 'thaninthon@thaioilgroup.com',
            Username = 'thaninthon@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ThaninthonUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = 'vatchara@thaioilgroup.com',
            Username = 'vatchara@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = 'chaiyar@thaioilgroup.com',
            Username = 'chaiyar@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = 'narongsak@thaioilgroup.com',
            Username = 'narongsak@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = 'rungnapa@thaioilgroup.com',
            Username = 'rungnapa@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'THANINTHON';
        thaninthon.LEVEL__c = 'Junior';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Thaninthon';
        thaninthon.ENLASTNAME__c = 'On-Sri';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'thaninthon@thaioilgroup.com';
        thaninthon.User__c = ThaninthonUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'vatchara@thaioilgroup.com';
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        vatchara.Active__c = true;
        vatchara.MAINPOSITION__c = true;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        chaiyar.Active__c = true;
        chaiyar.MAINPOSITION__c = true;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        narongsak.Active__c = true;
        narongsak.MAINPOSITION__c = true;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.POSID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        rungnapa.Active__c = true;
        rungnapa.MAINPOSITION__c = true;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
        
        System.runAs(ThaninthonUser) {
            
            ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
            ICR.EmployeeID = '00001365';
            ICR.FindingAllSubCordinate(ThaninthonUser.Id);
            ICR.AllCordinate();
            ICR.LockICRRecord();
            
            ICR_Config__c ICRConfig = new ICR_Config__c();
            ICRConfig.Document_No_Year__c = '2022';
            ICRConfig.Expire_Committee_Reminder__c = 90;
            ICRConfig.Document_No_Running__c = '001';
            insert(ICRConfig);
            
            ICR_Approval__c InsertICR = new ICR_Approval__c();
            InsertICR.Request_Reason__c = 'Test Reason';
            InsertICR.Start_Date__c = date.today();
            InsertICR.Committee_Title__c = 'Test Committee Title';
            InsertICR.End_Date__c = date.today();
            insert(InsertICR);
            
            ICR.UnlockICRRecordById(InsertICR.Id);
            
            update(InsertICR);
            
        }
        
    }
    
    public static testMethod void ICR_ApprovalHandlerCreateTask() {
        
        //Requester
        User ThaninthonUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'thaninthon',
            FirstName = 'thaninthon',
            Email = 'thaninthon@thaioilgroup.com',
            Username = 'thaninthon@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ThaninthonUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = 'vatchara@thaioilgroup.com',
            Username = 'vatchara@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = 'chaiyar@thaioilgroup.com',
            Username = 'chaiyar@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = 'narongsak@thaioilgroup.com',
            Username = 'narongsak@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = 'rungnapa@thaioilgroup.com',
            Username = 'rungnapa@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'THANINTHON';
        thaninthon.LEVEL__c = 'Junior';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Thaninthon';
        thaninthon.ENLASTNAME__c = 'On-Sri';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'thaninthon@thaioilgroup.com';
        thaninthon.User__c = ThaninthonUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'vatchara@thaioilgroup.com';
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        vatchara.Active__c = true;
        vatchara.MAINPOSITION__c = true;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        chaiyar.Active__c = true;
        chaiyar.MAINPOSITION__c = true;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        narongsak.Active__c = true;
        narongsak.MAINPOSITION__c = true;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        rungnapa.Active__c = true;
        rungnapa.MAINPOSITION__c = true;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
        
        System.runAs(ThaninthonUser) {
            
            ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
            ICR.EmployeeID = '08000288';
            ICR.AllReportToID();
            
            ICR_Config__c ICRConfig = new ICR_Config__c();
            ICRConfig.Document_No_Year__c = '2022';
            ICRConfig.Expire_Committee_Reminder__c = 90;
            ICRConfig.Document_No_Running__c = '001';
            insert(ICRConfig);
            
            ICR_Approval__c InsertICR = new ICR_Approval__c();
            InsertICR.Request_Reason__c = 'Test Reason';
            InsertICR.Start_Date__c = date.today();
            InsertICR.Committee_Title__c = 'Test Committee Title';
            InsertICR.End_Date__c = date.today();
            InsertICR.Status__c = 'Not Submit';
            InsertICR.Approver__c = ThaninthonUser.Id;
            InsertICR.BE_Line_Manager_ID__c = ThaninthonUser.Id;
            InsertICR.BE_EVP_ID__c = ThaninthonUser.Id;
            InsertICR.BE_GSCS_ID__c = ThaninthonUser.Id;
            InsertICR.BE_GSCS_Staff_ID__c = ThaninthonUser.Id;
            InsertICR.BE_GSVP_ID__c = ThaninthonUser.Id;
            InsertICR.BE_PMSV_ID__c = ThaninthonUser.Id;
            insert(InsertICR);
            
            InsertICR.Request_Date__c = date.today();
            InsertICR.Status__c = 'Waiting Line Manager Approval';
            update(InsertICR);
            
            InsertICR.Status__c = 'Waiting Submit Approval Type';
            update(InsertICR);
            
            InsertICR.Status__c = 'Waiting GSCS Approval';
            update(InsertICR);
            
            InsertICR.Status__c = 'Waiting Requester Update Result';
            update(InsertICR);
            
        }
        
    }
    
    public static testMethod void ICR_ApprovalHandlerCreateTaskLMRejected() {
        
        //Requester
        User ThaninthonUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'thaninthon',
            FirstName = 'thaninthon',
            Email = 'thaninthon@thaioilgroup.com',
            Username = 'thaninthon@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ThaninthonUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = 'vatchara@thaioilgroup.com',
            Username = 'vatchara@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = 'chaiyar@thaioilgroup.com',
            Username = 'chaiyar@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = 'narongsak@thaioilgroup.com',
            Username = 'narongsak@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = 'rungnapa@thaioilgroup.com',
            Username = 'rungnapa@thaioilgroup.com.icr',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'THANINTHON';
        thaninthon.LEVEL__c = 'Junior';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Thaninthon';
        thaninthon.ENLASTNAME__c = 'On-Sri';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'thaninthon@thaioilgroup.com';
        thaninthon.User__c = ThaninthonUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'vatchara@thaioilgroup.com';
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        vatchara.Active__c = true;
        vatchara.MAINPOSITION__c = true;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        chaiyar.Active__c = true;
        chaiyar.MAINPOSITION__c = true;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        narongsak.Active__c = true;
        narongsak.MAINPOSITION__c = true;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        rungnapa.Active__c = true;
        rungnapa.MAINPOSITION__c = true;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
        
        System.runAs(ThaninthonUser) {
            
            ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
            ICR.EmployeeID = '08000288';
            ICR.AllReportToID();
            
            ICR_Config__c ICRConfig = new ICR_Config__c();
            ICRConfig.Document_No_Year__c = '2022';
            ICRConfig.Expire_Committee_Reminder__c = 90;
            ICRConfig.Document_No_Running__c = '001';
            insert(ICRConfig);
            
            ICR_Approval__c InsertICR = new ICR_Approval__c();
            InsertICR.Request_Reason__c = 'Test Reason';
            InsertICR.Start_Date__c = date.today();
            InsertICR.Committee_Title__c = 'Test Committee Title';
            InsertICR.End_Date__c = date.today();
            InsertICR.Status__c = 'Not Submit';
            InsertICR.Approver__c = ThaninthonUser.Id;
            InsertICR.BE_Line_Manager_ID__c = ThaninthonUser.Id;
            InsertICR.BE_EVP_ID__c = ThaninthonUser.Id;
            InsertICR.BE_GSCS_ID__c = ThaninthonUser.Id;
            InsertICR.BE_GSCS_Staff_ID__c = ThaninthonUser.Id;
            InsertICR.BE_GSVP_ID__c = ThaninthonUser.Id;
            InsertICR.BE_PMSV_ID__c = ThaninthonUser.Id;
            insert(InsertICR);
            
            InsertICR.Request_Date__c = date.today();
            InsertICR.Status__c = 'Waiting Line Manager Approval';
            update(InsertICR);
            
            InsertICR.Status__c = 'Waiting Requester Revise';
            update(InsertICR);
            
            
        }
        
    }
}