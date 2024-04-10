@isTest
public with sharing class WAP_ClearanceExcelController_Test {

    public static testMethod void Daily() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        Test.startTest();
        
        System.runAs(testUser) {
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            insert(FL);
            
            PISUsers__c thaninthon = new PISUsers__c();
            thaninthon.Active__c = true;
            thaninthon.MAINPOSITION__c = true;
            thaninthon.EMPLOYEEID__c = '08000288';
            thaninthon.Name = 'Test';
            thaninthon.LEVEL__c = 'Junior';
            thaninthon.ORGID__c = '00000818';
            thaninthon.POSID__c = '00000544';
            thaninthon.ENFIRSTNAME__c = 'Test';
            thaninthon.ENLASTNAME__c = 'Test';
            thaninthon.HOLDERPOSITION__c = '00000544';
            thaninthon.EMAIL__c = 'test@thaioilgroup.com';
            thaninthon.User__c = testUser.Id;
            thaninthon.ReportToPOS__c = '00001365';
            thaninthon.ReportToID__c = '00000598';
            thaninthon.ReportToEmail__c = 'test@thaioilgroup.com';
            thaninthon.ReportToUser__c = testUser.Id;
            thaninthon.Subcordinate__c = '["08000288"]';
            insert(thaninthon);
            
            List<Work_Clearance__c> wmList = new List<Work_Clearance__c>();
            Work_Clearance__c WorkMap = new Work_Clearance__c();
            WorkMap.name = '000001';
            WorkMap.Area__c = 'AAA';
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '0'; //General
            WorkMap.Description__c = '';
            WorkMap.Main_Work_Center_Text__c = 'TOC2';
            WorkMap.Work_Detail__c = '';
            WorkMap.Safety_Permit1__c = '';
            WorkMap.Safety_Permit2__c = '';
            WorkMap.Safety_Permit3__c = '';
            WorkMap.IsCheckingGas__c = false;
            WorkMap.Flamable_amt__c = '0';
            WorkMap.Oxygen_amt__c = '0';
            WorkMap.Toxic_PPM__c = '0';
            WorkMap.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap.Check_Date_UI__c = system.now().date();
            WorkMap.Check_Time_UI__c = system.now().time();
            WorkMap.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap.Authorized_Date_UI__c = system.now().date();
            WorkMap.Authorized_Time_UI__c = system.now().time();
            WorkMap.Extend_Date__c = system.now().date();
            WorkMap.Extend_Time__c = system.now().time();
            WorkMap.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap);

            Work_Clearance__c WorkMap10 = new Work_Clearance__c();
            WorkMap10 = new Work_Clearance__c();
            WorkMap10.name = '000001';
            WorkMap10.Area__c = 'AAA';
            WorkMap10.System_Status__c = 'PREP'; //In Progress
            WorkMap10.FunctionalLocation__c = FL.Id;
            WorkMap10.User_Status__c = 'WCCL';
            WorkMap10.High_Risk_Work__c = '10'; //NonTypeOfWork
            WorkMap10.Description__c = '';
            WorkMap10.Main_Work_Center_Text__c = 'TOC2';
            WorkMap10.Work_Detail__c = '';
            WorkMap10.Safety_Permit1__c = '';
            WorkMap10.Safety_Permit2__c = '';
            WorkMap10.Safety_Permit3__c = '';
            WorkMap10.IsCheckingGas__c = false;
            WorkMap10.Flamable_amt__c = '0';
            WorkMap10.Oxygen_amt__c = '0';
            WorkMap10.Toxic_PPM__c = '0';
            WorkMap10.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap10.Check_Date_UI__c = date.today().addDays(-7);
            WorkMap10.Check_Time_UI__c = system.now().time();
            WorkMap10.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap10.Authorized_Date_UI__c = date.today().addDays(-7);
            WorkMap10.Authorized_Time_UI__c = system.now().time();
            WorkMap10.Extend_Date__c = system.now().date();
            WorkMap10.Extend_Time__c = system.now().time();
            WorkMap10.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap10.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap10.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap10.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap10.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap10);

            Work_Clearance__c WorkMap2 = new Work_Clearance__c();
            WorkMap2.name = '000001';
            WorkMap2.Area__c = 'AAA';
            WorkMap2.System_Status__c = 'PREP'; //In Progress
            WorkMap2.FunctionalLocation__c = FL.Id;
            WorkMap2.User_Status__c = 'WCCL';
            WorkMap2.High_Risk_Work__c = '1'; //General
            WorkMap2.Description__c = '';
            WorkMap2.Main_Work_Center_Text__c = 'TOC2';
            WorkMap2.Work_Detail__c = '';
            WorkMap2.Safety_Permit1__c = '';
            WorkMap2.Safety_Permit2__c = '';
            WorkMap2.Safety_Permit3__c = '';
            WorkMap2.IsCheckingGas__c = false;
            WorkMap2.Flamable_amt__c = '0';
            WorkMap2.Oxygen_amt__c = '0';
            WorkMap2.Toxic_PPM__c = '0';
            WorkMap2.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap2.Check_Date_UI__c = system.now().date();
            WorkMap2.Check_Time_UI__c = system.now().time();
            WorkMap2.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap2.Authorized_Date_UI__c = system.now().date();
            WorkMap2.Authorized_Time_UI__c = system.now().time();
            WorkMap2.Extend_Date__c = system.now().date();
            WorkMap2.Extend_Time__c = system.now().time();
            WorkMap2.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap2.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap2.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap2.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap2.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap2);

            Work_Clearance__c WorkMap3 = new Work_Clearance__c();
            WorkMap3.name = '000001';
            WorkMap3.Area__c = 'AAA';
            WorkMap3.System_Status__c = 'PREP'; //In Progress
            WorkMap3.FunctionalLocation__c = FL.Id;
            WorkMap3.User_Status__c = 'WCCL';
            WorkMap3.High_Risk_Work__c = '2'; //General
            WorkMap3.Description__c = '';
            WorkMap3.Main_Work_Center_Text__c = 'TOC2';
            WorkMap3.Work_Detail__c = '';
            WorkMap3.Safety_Permit1__c = '';
            WorkMap3.Safety_Permit2__c = '';
            WorkMap3.Safety_Permit3__c = '';
            WorkMap3.IsCheckingGas__c = false;
            WorkMap3.Flamable_amt__c = '0';
            WorkMap3.Oxygen_amt__c = '0';
            WorkMap3.Toxic_PPM__c = '0';
            WorkMap3.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap3.Check_Date_UI__c = system.now().date();
            WorkMap3.Check_Time_UI__c = system.now().time();
            WorkMap3.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap3.Authorized_Date_UI__c = system.now().date();
            WorkMap3.Authorized_Time_UI__c = system.now().time();
            WorkMap3.Extend_Date__c = system.now().date();
            WorkMap3.Extend_Time__c = system.now().time();
            WorkMap3.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap3.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap3.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap3.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap3.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap3);

            Work_Clearance__c WorkMap4 = new Work_Clearance__c();
            WorkMap4.name = '000001';
            WorkMap4.Area__c = 'AAA';
            WorkMap4.System_Status__c = 'PREP'; //In Progress
            WorkMap4.FunctionalLocation__c = FL.Id;
            WorkMap4.User_Status__c = 'WCCL';
            WorkMap4.High_Risk_Work__c = '3'; //General
            WorkMap4.Description__c = '';
            WorkMap4.Main_Work_Center_Text__c = 'TOC2';
            WorkMap4.Work_Detail__c = '';
            WorkMap4.Safety_Permit1__c = '';
            WorkMap4.Safety_Permit2__c = '';
            WorkMap4.Safety_Permit3__c = '';
            WorkMap4.IsCheckingGas__c = false;
            WorkMap4.Flamable_amt__c = '0';
            WorkMap4.Oxygen_amt__c = '0';
            WorkMap4.Toxic_PPM__c = '0';
            WorkMap4.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap4.Check_Date_UI__c = system.now().date();
            WorkMap4.Check_Time_UI__c = system.now().time();
            WorkMap4.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap4.Authorized_Date_UI__c = system.now().date();
            WorkMap4.Authorized_Time_UI__c = system.now().time();
            WorkMap4.Extend_Date__c = system.now().date();
            WorkMap4.Extend_Time__c = system.now().time();
            WorkMap4.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap4.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap4.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap4.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap4.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap4);

            Work_Clearance__c WorkMap5 = new Work_Clearance__c();
            WorkMap5.name = '000001';
            WorkMap5.Area__c = 'AAA';
            WorkMap5.System_Status__c = 'PREP'; //In Progress
            WorkMap5.FunctionalLocation__c = FL.Id;
            WorkMap5.User_Status__c = 'WCCL';
            WorkMap5.High_Risk_Work__c = '4'; //General
            WorkMap5.Description__c = '';
            WorkMap5.Main_Work_Center_Text__c = 'TOC2';
            WorkMap5.Work_Detail__c = '';
            WorkMap5.Safety_Permit1__c = '';
            WorkMap5.Safety_Permit2__c = '';
            WorkMap5.Safety_Permit3__c = '';
            WorkMap5.IsCheckingGas__c = false;
            WorkMap5.Flamable_amt__c = '0';
            WorkMap5.Oxygen_amt__c = '0';
            WorkMap5.Toxic_PPM__c = '0';
            WorkMap5.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap5.Check_Date_UI__c = system.now().date();
            WorkMap5.Check_Time_UI__c = system.now().time();
            WorkMap5.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap5.Authorized_Date_UI__c = system.now().date();
            WorkMap5.Authorized_Time_UI__c = system.now().time();
            WorkMap5.Extend_Date__c = system.now().date();
            WorkMap5.Extend_Time__c = system.now().time();
            WorkMap5.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap5.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap5.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap5.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap5.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap5);

            Work_Clearance__c WorkMap6 = new Work_Clearance__c();
            WorkMap6.name = '000001';
            WorkMap6.Area__c = 'AAA';
            WorkMap6.System_Status__c = 'PREP'; //In Progress
            WorkMap6.FunctionalLocation__c = FL.Id;
            WorkMap6.User_Status__c = 'WCCL';
            WorkMap6.High_Risk_Work__c = '5'; //General
            WorkMap6.Description__c = '';
            WorkMap6.Main_Work_Center_Text__c = 'TOC2';
            WorkMap6.Work_Detail__c = '';
            WorkMap6.Safety_Permit1__c = '';
            WorkMap6.Safety_Permit2__c = '';
            WorkMap6.Safety_Permit3__c = '';
            WorkMap6.IsCheckingGas__c = false;
            WorkMap6.Flamable_amt__c = '0';
            WorkMap6.Oxygen_amt__c = '0';
            WorkMap6.Toxic_PPM__c = '0';
            WorkMap6.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap6.Check_Date_UI__c = system.now().date();
            WorkMap6.Check_Time_UI__c = system.now().time();
            WorkMap6.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap6.Authorized_Date_UI__c = system.now().date();
            WorkMap6.Authorized_Time_UI__c = system.now().time();
            WorkMap6.Extend_Date__c = system.now().date();
            WorkMap6.Extend_Time__c = system.now().time();
            WorkMap6.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap6.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap6.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap6.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap6.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap6);

            Work_Clearance__c WorkMap7 = new Work_Clearance__c();
            WorkMap7.name = '000001';
            WorkMap7.Area__c = 'AAA';
            WorkMap7.System_Status__c = 'PREP'; //In Progress
            WorkMap7.FunctionalLocation__c = FL.Id;
            WorkMap7.User_Status__c = 'WCCL';
            WorkMap7.High_Risk_Work__c = '6'; //General
            WorkMap7.Description__c = '';
            WorkMap7.Main_Work_Center_Text__c = 'TOC2';
            WorkMap7.Work_Detail__c = '';
            WorkMap7.Safety_Permit1__c = '';
            WorkMap7.Safety_Permit2__c = '';
            WorkMap7.Safety_Permit3__c = '';
            WorkMap7.IsCheckingGas__c = false;
            WorkMap7.Flamable_amt__c = '0';
            WorkMap7.Oxygen_amt__c = '0';
            WorkMap7.Toxic_PPM__c = '0';
            WorkMap7.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap7.Check_Date_UI__c = system.now().date();
            WorkMap7.Check_Time_UI__c = system.now().time();
            WorkMap7.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap7.Authorized_Date_UI__c = system.now().date();
            WorkMap7.Authorized_Time_UI__c = system.now().time();
            WorkMap7.Extend_Date__c = system.now().date();
            WorkMap7.Extend_Time__c = system.now().time();
            WorkMap7.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap7.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap7.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap7.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap7.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            wmList.add(WorkMap7);

            insert(wmList);
            
            WAP_Dashboard.SearchFilter filter = new WAP_Dashboard.SearchFilter();
            filter.year = '2022';
            filter.startDate = date.today().addDays(-7);
            filter.endDate = date.today().addDays(7);
            filter.area = 'AAA';
            
            PageReference ExcelExportVFPage = Page.WAP_ClearanceDashboard_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            WAP_ClearanceDashboardExcelController WAPExcelExport = new WAP_ClearanceDashboardExcelController();
            
            ApexPages.currentPage().getParameters().put('excelName', 'daily');
            ApexPages.currentPage().getParameters().put('year', '2023');
            ApexPages.currentPage().getParameters().put('area', 'AAA');
            ApexPages.currentPage().getParameters().put('startDate', String.valueof(date.today().addDays(-7)));//'2022-11-01');
            ApexPages.currentPage().getParameters().put('endDate', String.valueof(date.today().addDays(7)));//'2022-11-30');
            WAPExcelExport.OnloadExcel();
        }
        
        Test.stopTest();
        
    }
    
    public static testMethod void Detail() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        Test.startTest();
        
        System.runAs(testUser) {
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            insert(FL);
            
            PISUsers__c thaninthon = new PISUsers__c();
            thaninthon.Active__c = true;
            thaninthon.MAINPOSITION__c = true;
            thaninthon.EMPLOYEEID__c = '08000288';
            thaninthon.Name = 'Test';
            thaninthon.LEVEL__c = 'Junior';
            thaninthon.ORGID__c = '00000818';
            thaninthon.POSID__c = '00000544';
            thaninthon.ENFIRSTNAME__c = 'Test';
            thaninthon.ENLASTNAME__c = 'Test';
            thaninthon.HOLDERPOSITION__c = '00000544';
            thaninthon.EMAIL__c = 'test@thaioilgroup.com';
            thaninthon.User__c = testUser.Id;
            thaninthon.ReportToPOS__c = '00001365';
            thaninthon.ReportToID__c = '00000598';
            thaninthon.ReportToEmail__c = 'test@thaioilgroup.com';
            thaninthon.ReportToUser__c = testUser.Id;
            thaninthon.Subcordinate__c = '["08000288"]';
            insert(thaninthon);
            
            Work_Clearance__c WorkMap = new Work_Clearance__c();
            WorkMap.name = '000001';
            WorkMap.Area__c = 'AAA';
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '0'; //General
            WorkMap.Description__c = '';
            WorkMap.Main_Work_Center_Text__c = 'TOC2';
            WorkMap.Work_Detail__c = '';
            WorkMap.Safety_Permit1__c = '';
            WorkMap.Safety_Permit2__c = '';
            WorkMap.Safety_Permit3__c = '';
            WorkMap.IsCheckingGas__c = false;
            WorkMap.Flamable_amt__c = '0';
            WorkMap.Oxygen_amt__c = '0';
            WorkMap.Toxic_PPM__c = '0';
            WorkMap.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap.Check_Date_UI__c = system.now().date();
            WorkMap.Check_Time_UI__c = system.now().time();
            WorkMap.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap.Authorized_Date_UI__c = system.now().date();
            WorkMap.Authorized_Time_UI__c = system.now().time();
            WorkMap.Extend_Date__c = system.now().date();
            WorkMap.Extend_Time__c = system.now().time();
            WorkMap.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            insert(WorkMap);
            
            
            WAP_Dashboard.SearchFilter filter = new WAP_Dashboard.SearchFilter();
            filter.year = '2022';
            filter.startDate = date.today().addDays(-7);
            filter.endDate = date.today().addDays(7);
            filter.area = 'AAA';
            
            PageReference ExcelExportVFPage = Page.WAP_ClearanceDashboard_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            WAP_ClearanceDashboardExcelController WAPExcelExport = new WAP_ClearanceDashboardExcelController();
            
            ApexPages.currentPage().getParameters().put('excelName', 'detail');
            ApexPages.currentPage().getParameters().put('year', '2023');
            ApexPages.currentPage().getParameters().put('area', 'AAA');
            ApexPages.currentPage().getParameters().put('startDate', String.valueof(date.today().addDays(-7)));//'2022-11-01');
            ApexPages.currentPage().getParameters().put('endDate', String.valueof(date.today().addDays(7)));//'2022-11-30');
            WAPExcelExport.OnloadExcel();
        }
        
        Test.stopTest();
        
    }
    
    public static testMethod void Clearance() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        Test.startTest();
        
        System.runAs(testUser) {
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            insert(FL);
            
            PISUsers__c thaninthon = new PISUsers__c();
            thaninthon.Active__c = true;
            thaninthon.MAINPOSITION__c = true;
            thaninthon.EMPLOYEEID__c = '08000288';
            thaninthon.Name = 'Test';
            thaninthon.LEVEL__c = 'Junior';
            thaninthon.ORGID__c = '00000818';
            thaninthon.POSID__c = '00000544';
            thaninthon.ENFIRSTNAME__c = 'Test';
            thaninthon.ENLASTNAME__c = 'Test';
            thaninthon.HOLDERPOSITION__c = '00000544';
            thaninthon.EMAIL__c = 'test@thaioilgroup.com';
            thaninthon.User__c = testUser.Id;
            thaninthon.ReportToPOS__c = '00001365';
            thaninthon.ReportToID__c = '00000598';
            thaninthon.ReportToEmail__c = 'test@thaioilgroup.com';
            thaninthon.ReportToUser__c = testUser.Id;
            thaninthon.Subcordinate__c = '["08000288"]';
            insert(thaninthon);
            
            Work_Clearance__c WorkMap = new Work_Clearance__c();
            WorkMap.name = '000001';
            WorkMap.Area__c = 'AAA';
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '0'; //General
            WorkMap.Description__c = '';
            WorkMap.Main_Work_Center_Text__c = 'TOC2';
            WorkMap.Work_Detail__c = '';
            WorkMap.Safety_Permit1__c = '';
            WorkMap.Safety_Permit2__c = '';
            WorkMap.Safety_Permit3__c = '';
            WorkMap.IsCheckingGas__c = false;
            WorkMap.Flamable_amt__c = '0';
            WorkMap.Oxygen_amt__c = '0';
            WorkMap.Toxic_PPM__c = '0';
            WorkMap.AGT_UI__c = thaninthon.Id; //PISUser
            WorkMap.Check_Date_UI__c = system.now().date();
            WorkMap.Check_Time_UI__c = system.now().time();
            WorkMap.Authorized_Signatory_UI__c = thaninthon.Id; //PISUser
            WorkMap.Authorized_Date_UI__c = system.now().date();
            WorkMap.Authorized_Time_UI__c = system.now().time();
            WorkMap.Extend_Date__c = system.now().date();
            WorkMap.Extend_Time__c = system.now().time();
            WorkMap.Extend_Time_To_UI__c = system.now().time().addHours(1);
            WorkMap.Extend_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap.Extend_Authorized_Sign_UI__c = thaninthon.Id; //PISUser
            WorkMap.Close_Applicant_or_Bearer_UI__c = thaninthon.Id; //PISUser
            WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            insert(WorkMap);
            
            
            WAP_Dashboard.SearchFilter filter = new WAP_Dashboard.SearchFilter();
            filter.year = '2022';
            filter.startDate = date.today().addDays(-7);
            filter.endDate = date.today().addDays(7);
            filter.area = 'AAA';
            
            PageReference ExcelExportVFPage = Page.WAP_ClearanceDashboard_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            WAP_ClearanceDashboardExcelController WAPExcelExport = new WAP_ClearanceDashboardExcelController();
            
            ApexPages.currentPage().getParameters().put('excelName', 'clearance');
            ApexPages.currentPage().getParameters().put('year', '2023');
            ApexPages.currentPage().getParameters().put('area', 'AAA');
            ApexPages.currentPage().getParameters().put('startDate', String.valueof(date.today().addDays(-7)));//'2022-11-01');
            ApexPages.currentPage().getParameters().put('endDate', String.valueof(date.today().addDays(7)));//'2022-11-30');
            WAPExcelExport.OnloadExcel();
        }
        
        Test.stopTest();
        
    }
    
}