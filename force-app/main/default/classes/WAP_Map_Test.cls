@isTest
public with sharing class WAP_Map_Test {

    public static testMethod void GetWapMapAllFilter() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //Created
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WC';
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.Area__c = 'Test';
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            update(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = true;
            filter.clearanceCertificateNo = '000001';
            filter.areas = new List<string> {'TLB'};
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
                
            WAP_Map.GetWorkCount(filter);
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkMaps(filter);
            WAP_Map.GetWorkDetail('000001');
            WAP_Map.UpdateWorkClearanceMapLatLong(WorkMap.Id, '13.111560', '100.881583');
            List<PTW_Header__c> PTWHeaders = new List<PTW_Header__c>();
            WAP_Map.CheckPTWHeader(WorkMap.Id, PTWHeaders);
            WAP_Global.allPISUsers();
            WAP_Global.assignToAllPISUsers();
            WAP_Global.assignToAllPTWHeaders();
            WAP_Global.convertDateTimeFilter(system.Datetime.now());
            
            WAP_Global.PageParam PageParam = new WAP_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            WAP_Global.SortByParam SortByParam = new WAP_Global.SortByParam();
            SortByParam.ascending = true;
            SortByParam.sortBy = 'test';
        }
        
        Test.stopTest();
    }
    
    public static testMethod void GetWapMapSomeFilter() {
        
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
        
        System.runAs(testUser) {
            
        	Test.startTest();
        
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WC';
            WorkMap.High_Risk_Work__c = '1'; //General
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.Area__c = 'Test';
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
        	Test.stopTest();
                        
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = false;
            filter.inProgressStatus = false;
            filter.createdStatus = true;
            
            //filter.clearanceCertificateNo = '000001';
            filter.areas = new List<string> {'TLB'};
            
            WAP_Map.GetWorkCount(filter);
            WAP_Map.GetWorkMaps(filter);
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
            WAP_Map.GetAreas(filter);
        }
        
    }
    
    public static testMethod void GetWapMapConfinedSpace() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '2'; //ConfinedSpace
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
            WAP_Global.assignToPISUser(testUser.Id);
        }
        
        Test.stopTest();
    }
    
    public static testMethod void GetWapMapCrane() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '3'; //Crane
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
        }
        
        Test.stopTest();
    }
    
    public static testMethod void GetWapMapRadiation() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '4'; //Radiation
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
        }
        
        Test.stopTest();
    }
    
    public static testMethod void GetWapMapJackHammer() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '5'; //JackHammer
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
        }
        
        Test.stopTest();
    }
    
    public static testMethod void GetWapMapHighPressureWaterJet() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '6'; //HighPressureWaterJet
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
        }
        
        Test.stopTest();
    }
    
    public static testMethod void GetWapMapDigging() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '7'; //Digging
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
        }
        
        Test.stopTest();
    }

    public static testMethod void GetWapMapWorkAtHigh() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '8'; //WorkAtHigh
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
        }
        
        Test.stopTest();
    }
      
    public static testMethod void GetWapMapOnlineStopLeak() {
        
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
            
            WAP_Config__c WAPConfig = new WAP_Config__c();
            WAPConfig.Google_API_Key__c = 'abcdefg';
            insert(WAPConfig);
            
            Functional_Location__c FL = new Functional_Location__c ();
            FL.Longitude__c = '13.111784435798539';
            FL.Latitude__c= '100.91411586612624';
            FL.Key__c = '01-LG-003';
            //insert(FL);
            
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
            WorkMap.System_Status__c = 'PREP'; //In Progress
            WorkMap.FunctionalLocation__c = FL.Id;
            WorkMap.User_Status__c = 'WCCL';
            WorkMap.High_Risk_Work__c = '9'; //OnlineStopLeak
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
            //WorkMap.Close_Authorized_Sign_off_UI__c = thaninthon.Id; //PISUser
            WorkMap.MaintenancePlantText__c = '4200';
            WorkMap.Area_Code__c = '';
            insert(WorkMap);
            
            WAP_Map.MapSearchCriteria filter = new WAP_Map.MapSearchCriteria();
            filter.allTypeOfWork = false;
            filter.generalWork = true;
            filter.hotWork = true;
            filter.confinedSpace = true;
            filter.craneLifting = true;
            filter.radiation = true;
            filter.jackHammer = true;
            filter.highPressureWaterJet = true;
            filter.digging = true;
            filter.workAtHeight = true;
            filter.onlineStopLeak = true;
            filter.nonTypeOfWork = true;
            filter.allStatus = true;
            filter.createdStatus = true;
            filter.inProgressStatus = true;
            
            WAP_Map.GetAllWorkCount(filter);
            WAP_Map.GetWorkDetail('000001');
        }
        
        Test.stopTest();
    }
      
}