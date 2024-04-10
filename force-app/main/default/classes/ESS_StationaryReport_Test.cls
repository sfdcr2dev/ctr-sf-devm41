@isTest
public class ESS_StationaryReport_Test {

    @testSetup
    public static void setup() {
        
        //Create user here
        User AdminPMSVUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'PASSARAWAN',
            Email = 'testpassarawan@thaioilgroup.com',
            Username = 'testpassarawan@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'PA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(AdminPMSVUser);
        
        User AdminFixAndGeneralUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'KIRANA',
            Email = 'testkirana@thaioilgroup.com',
            Username = 'testkirana@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'KI',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(AdminFixAndGeneralUser);
        
        //Project Base (Employee PM Under Section Head)
        User EmployeeUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'RAMON',
            Email = 'testramon@thaioilgroup.com',
            Username = 'testremon@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'RA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(EmployeeUser);
        
        User SectionHeadUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'DAMRONG',
            Email = 'testdamrong@thaioilgroup.com',
            Username = 'testdamrong@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'DA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test',
            Employee_Id__c = '00000001'
            );
        insert(SectionHeadUser);
        
        //Project Base (Employee PM Under Section Head) (On behalf of)
		User EmployeeUser2 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'RATRI',
            Email = 'testratri@thaioilgroup.com',
            Username = 'testratri@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'RAT',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test',
            Employee_Id__c = '00000002'
            );
        insert(EmployeeUser2);
        
        //Project Base (Employee PM Section Head Upward) (ปกติ)
        User SectionHeadUser2 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'SURAPHAN',
            Email = 'testsuraphan@thaioilgroup.com',
            Username = 'testsuraphan@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'SU',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(SectionHeadUser2);
        
        User VPUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'NARONGSAK',
            Email = 'testnarongsak@thaioilgroup.com',
            Username = 'testnarongsak@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'NA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(VPUser);
        
        //Insert PISUser
        insertPISUsers();
        
        //Insert Public Group
        insertPublicGroup();
        
        //Insert ESS_Config
        ESS_Config__c Config = new ESS_Config__c();
        Config.Stationary_Running_No__c = '0';
        insert(Config);
    }
    
    @future
    public static void insertPISUsers() {
        
        List<User> Users = [select id, alias, FirstName_EN__c, LastName_EN__c from User];
        
        Id RamonId; //Employee
        Id DamrongId; //Section Head
        Id RatriId; //
        Id SuraphanId;
        Id NarongsakId;
        Id UserManagerId;
        
        for(User U : Users) {
            if(U.alias == 'RA') {
                RamonId = U.Id;
            }
            else if(U.alias == 'DA') {
                DamrongId = U.Id;
            }
            else if(U.alias == 'RAT') {
                RatriId = U.Id;
            }
            else if(U.alias == 'SU') {
                SuraphanId = U.Id;
            }
            else if(U.alias == 'NA') {
                NarongsakId = U.Id;
            }
            else if(U.alias == 'KI') {
                UserManagerId = U.Id;
            }
        }
        
        PISUsers__c ramon = new PISUsers__c();
        ramon.Active__c = true;
        ramon.MAINPOSITION__c = true;
        ramon.EMPLOYEEID__c = '00000001';
        ramon.HOME_COMP__c = '1100';
        ramon.Name = 'Test Ramon';
        ramon.LEVEL__c = 'Junior';
        ramon.ORGID__c = '00000001';
        ramon.POSID__c = '00000001';
        ramon.ENFIRSTNAME__c = 'Test';
        ramon.ENLASTNAME__c = 'Test Ramon';
        ramon.HOLDERPOSITION__c = '00000001';
        ramon.EMAIL__c = 'testramon@thaioilgroup.com';
        ramon.User__c = RamonId;
        ramon.FUNCTION__c = 'AAAA';
        ramon.DEPARTMENT__c = 'BBBB';
        ramon.SECTIONS__c = 'CCCC';
        ramon.UNITS__c = 'DDDD';
        ramon.ReportToPOS__c = '00000002';
        ramon.ReportToID__c = '00000002';
        ramon.ReportToEmail__c = 'testdamrong@thaioilgroup.com';
        ramon.ReportToUser__c = DamrongId;
        ramon.SectHeadUpUser__c = DamrongId;
        ramon.SectHeadUpPosID__c = '00000002';
        ramon.Subcordinate__c = '[""]';
        insert(ramon);
        
        PISUsers__c damrong = new PISUsers__c();
        damrong.Active__c = true;
        damrong.MAINPOSITION__c = true;
        damrong.EMPLOYEEID__c = '00000002';
        damrong.HOME_COMP__c = '1600';
        damrong.Name = 'Test Damrong';
        damrong.LEVEL__c = 'Section Head';
        damrong.ORGID__c = '00000002';
        damrong.POSID__c = '00000002';
        damrong.ENFIRSTNAME__c = 'Test';
        damrong.ENLASTNAME__c = 'Test Damrong';
        damrong.HOLDERPOSITION__c = '00000002';
        damrong.EMAIL__c = 'testdamrong@thaioilgroup.com';
        damrong.User__c = DamrongId;
        damrong.ReportToPOS__c = '00000002';
        damrong.ReportToID__c = '00000002';
        damrong.ReportToEmail__c = 'testdamrong@thaioilgroup.com';
        damrong.ReportToUser__c = DamrongId;
        damrong.SectHeadUpUser__c = DamrongId;
        damrong.SectHeadUpPosID__c = '00000002';
        damrong.Subcordinate__c = '[""]';
        insert(damrong);
        
        PISUsers__c ratri = new PISUsers__c();
        ratri.Active__c = true;
        ratri.MAINPOSITION__c = true;
        ratri.EMPLOYEEID__c = '00000003';
        ratri.HOME_COMP__c = '1100';
        ratri.PERSUBAREA__c = 'Other';
        ratri.Name = 'Test Ratri';
        ratri.LEVEL__c = 'Section Head';
        ratri.ORGID__c = '00000003';
        ratri.POSID__c = '00000003';
        ratri.ENFIRSTNAME__c = 'Test';
        ratri.ENLASTNAME__c = 'Test Ratri';
        ratri.HOLDERPOSITION__c = '00000003';
        ratri.EMAIL__c = 'testratri@thaioilgroup.com';
        ratri.User__c = RatriId;
        ratri.ReportToPOS__c = '00000001';
        ratri.ReportToID__c = '00000001';
        ratri.ReportToEmail__c = 'testramon@thaioilgroup.com';
        ratri.ReportToUser__c = RamonId;
        ratri.SectHeadUpUser__c = RamonId;
        ratri.SectHeadUpPosID__c = '00000001';
        ratri.Subcordinate__c = '[""]';
        insert(ratri);
        
        PISUsers__c suraphan = new PISUsers__c();
        suraphan.Active__c = true;
        suraphan.MAINPOSITION__c = true;
        suraphan.EMPLOYEEID__c = '00000004';
        suraphan.HOME_COMP__c = '1100';
        suraphan.Name = 'Test Ratri';
        suraphan.LEVEL__c = 'Section Head';
        suraphan.ORGID__c = '00000004';
        suraphan.POSID__c = '00000004';
        suraphan.ENFIRSTNAME__c = 'Test';
        suraphan.ENLASTNAME__c = 'Test Suraphan';
        suraphan.HOLDERPOSITION__c = '00000004';
        suraphan.EMAIL__c = 'testsuraphan@thaioilgroup.com';
        suraphan.User__c = SuraphanId;
        suraphan.ReportToPOS__c = '00000001';
        suraphan.ReportToID__c = '00000001';
        suraphan.ReportToEmail__c = 'testramon@thaioilgroup.com';
        suraphan.ReportToUser__c = RamonId;
        suraphan.SectHeadUpUser__c = RamonId;
        suraphan.SectHeadUpPosID__c = '00000001';
        suraphan.Subcordinate__c = '[""]';
        insert(suraphan);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.Active__c = true;
        narongsak.MAINPOSITION__c = true;
        narongsak.EMPLOYEEID__c = '00000005';
        narongsak.HOME_COMP__c = '1100';
        narongsak.Name = 'Test Narongsak';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000005';
        narongsak.POSID__c = '00000005';
        narongsak.ENFIRSTNAME__c = 'Test';
        narongsak.ENLASTNAME__c = 'Test Narongsak';
        narongsak.HOLDERPOSITION__c = '00000005';
        narongsak.EMAIL__c = 'testnarongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakId;
        //suraphan.ReportToPOS__c = '00000001';
        //suraphan.ReportToID__c = '00000001';
        //suraphan.ReportToEmail__c = 'testramon@thaioilgroup.com';
        //suraphan.ReportToUser__c = EmployeeUser.Id;
        //suraphan.Subcordinate__c = '[""]';
        insert(narongsak);
        
        PISUsers__c userManager = new PISUsers__c();
        userManager.Active__c = true;
        userManager.MAINPOSITION__c = true;
        userManager.EMPLOYEEID__c = '00000000';
        userManager.HOME_COMP__c = '1100';
        userManager.Name = 'Test UserManager';
        userManager.LEVEL__c = 'Junior';
        userManager.ORGID__c = '00000000';
        userManager.POSID__c = '00000000';
        userManager.ENFIRSTNAME__c = 'Test';
        userManager.ENLASTNAME__c = 'Test UserManager';
        userManager.HOLDERPOSITION__c = '00000000';
        userManager.EMAIL__c = 'adminpeoc@thaioilgroup.com';
        userManager.User__c = userManagerId;
        userManager.ReportToUser__c = NarongsakId;
        insert(userManager);
    }
    
    @future
    public static void insertPublicGroup() {
        
        List<User> Users = [select id, alias from User];
        
        Id AdminPMSVId;
        Id AdminStationaryId;
        
        for(User U : Users) {
            if(U.alias == 'PA') {
                AdminPMSVId = U.Id;
            }
            else if(U.alias == 'KI') {
                AdminStationaryId = U.Id;
            }
        }
        
        //Create PMSVStationary Group
        Group pmsvAdminGroup = [select id from Group where developername = 'ESS_PMSV_Stationary'];
        GroupMember pmsvStationaryAdmin = new GroupMember();
        pmsvStationaryAdmin.UserOrGroupId = AdminStationaryId;
        pmsvStationaryAdmin.GroupId = pmsvAdminGroup.Id;
        insert(pmsvStationaryAdmin);
        //Create GSBOStationary Group
        Group pmsvGSBOAdminGroup = [select id from Group where developername = 'ESS_GSBO_Stationary'];
        GroupMember pmsvGSBOAdmin = new GroupMember();
        pmsvGSBOAdmin.UserOrGroupId = AdminStationaryId;
        pmsvGSBOAdmin.GroupId = pmsvGSBOAdminGroup.Id;
        insert(pmsvGSBOAdmin);
        
    }
    
    public static ESS_Stationary_DTO.StationaryDetailDTO initialStationaryDetail(User runAsUser) {
        
        ESS_Stationary_DTO.StationaryDetailDTO Detail = new ESS_Stationary_DTO.StationaryDetailDTO();
        Detail.onBehalfOfFlow = false;
        Detail.isOnBehalf = false;
        Detail.status = new ESS_Global.EnumValue('StationaryServiceStatus');
        Detail.status.key = ESS_Enum.StationaryServiceStatus.Draft.name();
        Detail.status.value = 'Draft';
        Detail.requesterId = runAsUser.Id;
        Detail.requesterEmployeeId = '00000002';
        Detail.requesterEmployeeName = 'Test';
        Detail.requesterEmployeeNameEN = 'Test';
        Detail.requesterEmail = 'testratri@thaioilgroup.com';
        Detail.requesterPosition = 'Test';
        Detail.requesterFunction = 'AAAA';
        Detail.requesterDepartment = 'BBBB';
        Detail.requesterSection = 'CCCC';
        Detail.requesterUnit = 'DDDD';
        Detail.userManagerId = runAsUser.Id;
        
        string withdrawFromStock = '[{"unit":"ชิ้น","totalPrice":0,"stockOnHand":36,"stationaryId":"A-018","recordId":"a2I9D000001JEgaUAG","quantity":1,"pricePerUnit":755,"no":1,"name":"ตู้เอกสาร 5 ชั้น โครง ขาว-ฟ้าใส ONE","attachmentFiles":[{"url":"https://thaioil--essmss--c.sandbox.vf.force.com/servlet/servlet.FileDownload?file=00P9D000007mY0PUAU&operationContext=S1","id":"00P9D000007mY0PUAU"}],"actualWithdraw":0}]';
        string withdrawOther = '[{"unit":"แพค","totalPrice":0,"stockOnHand":0,"stationaryId":null,"recordId":null,"quantity":2,"pricePerUnit":0,"no":1,"name":"Post it สีสะท้อนแสง","attachmentFiles":[{"url":"https://thaioil--essmss--c.sandbox.vf.force.com/servlet/servlet.FileDownload?file=00P9D00000BLdPQUA1&operationContext=S1","id":"00P9D00000BLdPQUA1"}],"actualWithdraw":0}]';
            
        Detail.withdraws = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(withdrawFromStock, List<ESS_Stationary_DTO.WithdrawDTO>.class);
        Detail.withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(withdrawOther, List<ESS_Stationary_DTO.WithdrawDTO>.class);    
            
        return Detail;
    }
    
    @isTest
    public static void ESSStationaryReport() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            Stationary.Document_No__c = 'SS-2023-06-0001';
            Stationary.Service_For__c = ESS_Enum.StationaryServiceFor.TOPTBK.name();
            Stationary.Withdraw_From__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            Stationary.Completed_Date__c = date.today();
            Stationary.Withdraw_From_Stock__c = '[{"unit":"ชิ้น","totalPrice":0,"stockOnHand":36,"stationaryId":"A-018","recordId":"a2I9D000001JEgaUAG","quantity":1,"pricePerUnit":755,"no":1,"name":"ตู้เอกสาร 5 ชั้น โครง ขาว-ฟ้าใส ONE","attachmentFiles":[{"url":"https://thaioil--essmss--c.sandbox.vf.force.com/servlet/servlet.FileDownload?file=00P9D000007mY0PUAU&operationContext=S1","id":"00P9D000007mY0PUAU"}],"actualWithdraw":0}]';
            Stationary.Withdraw_Other__c = '[{"unit":"แพค","totalPrice":0,"stockOnHand":0,"stationaryId":null,"recordId":null,"quantity":2,"pricePerUnit":0,"no":1,"name":"Post it สีสะท้อนแสง","attachmentFiles":[{"url":"https://thaioil--essmss--c.sandbox.vf.force.com/servlet/servlet.FileDownload?file=00P9D00000BLdPQUA1&operationContext=S1","id":"00P9D00000BLdPQUA1"}],"actualWithdraw":0}]';
            Stationary.PMSV__c = 'null';
            insert(Stationary);
            
            ESS_Master_Stationary__c MS = new ESS_Master_Stationary__c();
            MS.Active__c = true;
            MS.Name = 'Test';
            MS.Stationary_Name__c = 'Test';
            MS.Available_Stock__c = 10;
            MS.Due_Stock__c = 10;
            MS.Minimum_Stock__c = 5;
            MS.Price__c = 1000;
            MS.Stock_on_Hand__c = 3;
            MS.Service_For__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            insert(MS);
            
            ESS_Setting__c Setting = new ESS_Setting__c();
            string toptbkTax = '{"ServiceFor": "TOPTBK","Name": "บริษัท ไทยออยล์ จำกัด (มหาชน)","TaxID": "0107547000711","BranchNo": "สำนักงานใหญ่","ShowAs": "TOP-TBK","Address": "555/1 ศูนย์เอนเนอร์ยี่ คอมเพล็กซ์ อาคารเอ ชั้น11 ถ.วิภาวดีรังสิต แขวงจตุจักร เขตจตุจักร กรุงเทพมหานคร 10900"}';
            Setting.TOPTBK_Tax__c = toptbkTax;
            insert(Setting);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_StationaryReport.LoginUserServiceFor();
            
            ESS_StationaryReport.ReportFilter Filter = new ESS_StationaryReport.ReportFilter();
            Filter.serviceFor = ESS_Enum.StationaryServiceFor.TOPTBK.name();
            Filter.withdrawFrom = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            Filter.serviceFor = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            ESS_StationaryReport.OutOfStockReportCount(Filter);
            ESS_StationaryReport.OutOfStockReport(Filter, PageParam);
            
            Filter.serviceFor = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            Filter.withdrawFrom = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            ESS_StationaryReport.RemainingStockReportCount(Filter);
            
            Filter.serviceFor = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            Filter.withdrawFrom = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            ESS_StationaryReport.RemainingStockReport(Filter, PageParam);
            
            Filter.serviceFor = ESS_Enum.StationaryServiceFor.TOPTBK.name();
            Filter.withdrawFrom = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            ESS_StationaryReport.DailyWithdrawTaxReportCount(Filter);
            ESS_StationaryReport.DailyWithdrawTaxReport(Filter);
            
            Filter.serviceFor = ESS_Enum.StationaryServiceFor.TOPTBK.name();
            Filter.productType = 'all';
            ESS_StationaryReport.DailyWithdrawTaxInvoiceReport(Filter);
            ESS_StationaryReport.DailyWithdrawTaxPOReport(Filter);
            ESS_StationaryReport.DailyWithdrawReportCount(Filter);
            ESS_StationaryReport.DailyWithdrawReport(Filter);
            ESS_StationaryReport.RequesterWithdrawReportCount(Filter);
            ESS_StationaryReport.RequesterWithdrawReport(Filter);
            ESS_StationaryReport.WithdrawItemReportCount(Filter);
            ESS_StationaryReport.WithdrawItemReport(Filter);
            
            ESS_Stationary_DTO.SearchDTO Search = new ESS_Stationary_DTO.SearchDTO();
            Search.search = 'Test';
            ESS_StationaryReport.AllSections(Search);
            
            Search.search = 'Test';
            ESS_StationaryReport.SearchUsers(Search);
            
            ESS_StationaryReport.ExportStationaryTrackingExcel(Filter);
            
            ESS_StationaryReport_DTO.TaxDTO TaxDTO = new ESS_StationaryReport_DTO.TaxDTO();
            TaxDTO.Name = 'Test';
            TaxDTO.TaxID = '1234567890123';
            TaxDTO.ServiceFor = 'TBK';
            TaxDTO.BranchNo = '1';
            TaxDTO.ShowAs = '';
            TaxDTO.Address = '123';
            
            ESS_StationaryReport_DTO.RemainingStockDTO RemainingStockDTO = new ESS_StationaryReport_DTO.RemainingStockDTO();
            RemainingStockDTO.name = 'Test';
            RemainingStockDTO.stationaryId = 'Test';
            RemainingStockDTO.price = 100.00;
            RemainingStockDTO.stockOnHand = 1;
            RemainingStockDTO.stockOverdue = 1;
            
            List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO> DailyDTOs = new List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
            ESS_StationaryReport_DTO.DailyWithdrawItemDTO DailyDTO = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
            DailyDTO.stationaryName = 'Test';
            DailyDTOs.add(DailyDTO);
            ESS_StationaryReport_DTO.sortByStationaryName(DailyDTOs);
            
            DailyDTO.sortByStationaryName(DailyDTO);
        }
        
        Test.stopTest();
        
    }
    
    
}