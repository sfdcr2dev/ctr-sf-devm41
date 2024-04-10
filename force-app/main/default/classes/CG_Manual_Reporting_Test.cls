@isTest
public class CG_Manual_Reporting_Test {

    public static testMethod void GetCGManualReportingTest() {
        
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
            LocaleSidKey = 'en_US',
            Employee_Id__c = '08000288',
            FirstName_TH__c = 'Test',
            LastName_TH__c = 'Test',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test'
            );
        insert(testUser);
        
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.FUNCTION__c = 'EVPC';
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
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        InsertUserToGroup(testUser.Id);
                
        RecordType RT = [select id, developername from RecordType where developername = 'CG_Manual' AND sobjectType = 'CG_Setting__c'];
        
        Test.startTest();  
        
        System.runAs(testUser) {
            
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            CG_Setting__c CGSetting = new CG_Setting__c();
            CGSetting.Start_Date__c = system.today();
            CGSetting.End_Date__c = system.today();
            CGSetting.Type__c = 'CG Manual';
            CGSetting.RecordTypeId = RT.Id;
            insert(CGSetting);
            
            SD_Company__c Company = new SD_Company__c();
            Company.Name = 'TOP';
            Company.Company_Full_Name__c = 'TOP';
            insert(Company);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'CG-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGManual);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.CG_Agree_to_Study__c = true;
            CGReporting.CG_Received_Manual__c = true;
            CGReporting.CG_Download_Manual__c = true;
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            insert(CGReporting);
            
            CG_Reporting__c CGNewEmployee = new CG_Reporting__c();
            CGNewEmployee.Running_No__c = 'CG-2022-02-0001';
            CGNewEmployee.User__c = testUser.Id;
            CGNewEmployee.OwnerId = testUser.Id;
            CGNewEmployee.Start_Duration__c = date.today();
            CGNewEmployee.End_Duration__c = date.today();
            CGNewEmployee.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGNewEmployee);
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGNewEmployee.GenerateFromBatch__c = true;
            CGNewEmployee.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGNewEmployee.CG_Agree_to_Study__c = true;
            CGNewEmployee.CG_Received_Manual__c = true;
            CGNewEmployee.CG_Download_Manual__c = true;
            CGNewEmployee.Owner_Function__c = 'EVPC';
            CGNewEmployee.Owner_Department__c = 'EVPO';
            CGNewEmployee.Owner_Section__c = 'SCSE';
            CGNewEmployee.Owner_Unit__c = 'ABCD';
            insert(CGNewEmployee);
            
            CG_Reporting__c CGAnnual = new CG_Reporting__c();
            CGAnnual.Running_No__c = 'CG-2022-03-0001';
            CGAnnual.User__c = testUser.Id;
            CGAnnual.OwnerId = testUser.Id;
            CGAnnual.Start_Duration__c = date.today();
            CGAnnual.End_Duration__c = date.today();
            CGAnnual.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGAnnual);
            CGAnnual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGAnnual.GenerateFromBatch__c = true;
            CGAnnual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGAnnual.CG_Agree_to_Study__c = true;
            CGAnnual.CG_Received_Manual__c = true;
            CGAnnual.CG_Download_Manual__c = true;
            CGAnnual.Owner_Function__c = 'EVPC';
            CGAnnual.Owner_Department__c = 'EVPO';
            CGAnnual.Owner_Section__c = 'SCSE';
            CGAnnual.Owner_Unit__c = 'ABCD';
            insert(CGAnnual);
            
            CGReports.add(CGReporting);
            
            CG_Manual_Reporting.GetNewCGManualReportCount();
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            CG_Manual_Reporting.CheckAccessPrivilege(CGReporting.Id);
            CG_Manual_Reporting.GetNewEmployeeReport();
            CG_Manual_Reporting.GetAnnualReport();
            //CG_Manual_Reporting.GetReportDetail(CGReporting.Id);
            
            CG_Manual_Reporting.GetNewCGManualReports(SortByParam, null);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'supervisorName';
            SortByParam.ascending = true;
            CG_Manual_Reporting.GetNewCGManualReports(SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_Manual_Reporting.GetNewCGManualReports(SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'duration';
            SortByParam.ascending = true;
            CG_Manual_Reporting.GetNewCGManualReports(SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Manual_Reporting.GetNewCGManualReports(SortByParam, PageParam);
            
            CG_Manual_Reporting.GetNewEmployeeReport();
            //CG_DTO.CGManualReportDetailDTO CGManualReportDetailDTO = CG_Manual_Reporting.assignToCGManualReportDetailDTO(CGReporting);
        
        	CG_Manual_Reporting.GetAdminCGReportListCount('Test', '08000288', null, 'EVPC', 'EVPO', 'SCSE', 'ABCD');
        	CG_Manual_Reporting.GetAdminCGReportList('Test', '08000288', null, 'EVPC', 'EVPO', 'SCSE', 'ABCD', SortByParam, PageParam);
        	CG_Manual_Reporting.AdminResendReport(CGReporting.Id);
            CG_Manual_Reporting.AdminResendReport(CGNewEmployee.Id);
            CG_Manual_Reporting.AdminResendReport(CGAnnual.Id);
            CG_Manual_Reporting.AdminCancelReport(CGReporting.Id);
            CG_Manual_Reporting.assignToAdminCGReportListDTO(CGAnnual);
            CG_Manual_Reporting.assignToAdminCGReportListDTO(CGNewEmployee);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
            CG_Manual_Reporting.assignToAdminCGReportListDTO(CGNewEmployee);
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Manual_Reporting.assignToAdminCGReportListDTO(CGNewEmployee);
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Cancel);
            CG_Manual_Reporting.assignToAdminCGReportListDTO(CGNewEmployee);
            
            CG_Manual_Reporting.checkCanSubmit(String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit));
            CG_Manual_Reporting.checkCanSubmit(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor));
            CG_Manual_Reporting.checkCanSubmit(String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP));
            CG_Manual_Reporting.checkCanSubmit(String.ValueOf(CG_Enum.ReportStatus.Rejected));
            
            CG_Manual_Reporting.CGAcknowledgeForm(CGReporting.Id);
            CG_Manual_Reporting.CGGlobal_GetCompanies();
            CG_Manual_Reporting.CGGlobal_GetFunctions(null);
            CG_Manual_Reporting.CGGlobal_GetDepartments(null);
            CG_Manual_Reporting.CGGlobal_GetSections(null);
            CG_Manual_Reporting.CGGlobal_GetUnits(null);
            
            Attachment attach = new Attachment();       
            attach.Name = 'Unit Test Attachment';
            Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
            attach.body = bodyBlob;
            attach.parentId = CGSetting.id;
            insert attach;
            
            CG_Manual_Reporting.getCGSettingDetail(CGSetting.Id);
            CG_Manual_Reporting.getAttachmentIds(CGSetting.Id);
        }
                    
        Test.stopTest();
        
    }
    
    public static testMethod void GetReportDetailTest() {
        
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
            LocaleSidKey = 'en_US',
            Employee_Id__c = '08000288',
            FirstName_TH__c = 'Test',
            LastName_TH__c = 'Test',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test'
            );
        insert(testUser);
        
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.FUNCTION__c = 'EVPC';
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
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        InsertUserToGroup(testUser.Id);
                
        string CGManualId;
        string CGAnnualId;
        string CGNewEmployeeId;
        List<RecordType> CGSettingRTs = [select id, developername from RecordType where sobjectType = 'CG_Setting__c'];
        
        for(RecordType CGSettingRT : CGSettingRTs) {
            if(CGSettingRT.DeveloperName == 'CG_Manual') {
                CGManualId = CGSettingRT.Id;
            }
            else if(CGSettingRT.DeveloperName == 'CG_Annual') {
                CGAnnualId = CGSettingRT.Id;
            }
            else if(CGSettingRT.DeveloperName == 'CG_New_Employee') {
                CGNewEmployeeId = CGSettingRT.Id;
            }
        }
        
        CG_Setting__c CGManualSetting = new CG_Setting__c();
        CGManualSetting.Start_Date__c = system.today();
        CGManualSetting.End_Date__c = system.today();
        CGManualSetting.Type__c = 'CGManual';
        CGManualSetting.RecordTypeId = CGManualId;
        insert(CGManualSetting);
        
        Attachment attach = new Attachment();       
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob1;
        attach.parentId = CGManualSetting.id;
        insert attach;
            
        CG_Setting__c CGAnnualSetting = new CG_Setting__c();
        CGAnnualSetting.Start_Date__c = system.today();
        CGAnnualSetting.End_Date__c = system.today();
        CGAnnualSetting.Type__c = 'CGAnnual';
        CGAnnualSetting.RecordTypeId = CGAnnualId;
        insert(CGAnnualSetting);
        
        attach = new Attachment();       
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob2 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob2;
        attach.parentId = CGAnnualSetting.id;
        insert attach;
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = system.today();
        CGSetting.End_Date__c = system.today();
        CGSetting.Type__c = 'CGNewEmployee';
        CGSetting.RecordTypeId = CGNewEmployeeId;
        insert(CGSetting);
        
        attach = new Attachment();       
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob3 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob3;
        attach.parentId = CGSetting.id;
        insert attach;
            
        Test.startTest();  
        
        System.runAs(testUser) {
            
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            SD_Company__c Company = new SD_Company__c();
            Company.Name = 'TOP';
            Company.Company_Full_Name__c = 'TOP';
            insert(Company);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'CG-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGManual);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.CG_Agree_to_Study__c = true;
            CGReporting.CG_Received_Manual__c = true;
            CGReporting.CG_Download_Manual__c = true;
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            insert(CGReporting);
            
            CG_Manual_Reporting.GetReportDetail(CGReporting.Id);
            
        	CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'CG-2022-02-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGAnnual);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.CG_Agree_to_Study__c = true;
            CGReporting.CG_Received_Manual__c = true;
            CGReporting.CG_Download_Manual__c = true;
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            insert(CGReporting);
            
            CG_Manual_Reporting.GetReportDetail(CGReporting.Id);
            
        	CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'CG-2022-03-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGNewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.CG_Agree_to_Study__c = true;
            CGReporting.CG_Received_Manual__c = true;
            CGReporting.CG_Download_Manual__c = true;
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            insert(CGReporting);
            
            CG_Manual_Reporting.GetReportDetail(CGReporting.Id);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CG_Manual_Reporting.assignToCGManualReportListDTO(CGReporting);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
            CG_Manual_Reporting.assignToCGManualReportListDTO(CGReporting);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Manual_Reporting.assignToCGManualReportListDTO(CGReporting);
            
            CG_Manual_Reporting.ReportCGSearchCriteria Search = new CG_Manual_Reporting.ReportCGSearchCriteria();
            Search.reportType = '';
            Search.companyId = '';
            Search.startDate = date.today();
            Search.endDate = date.today();
            Search.function = '';
            Search.department = '';
            Search.section = '';
            Search.unit = '';
            Search.status = '';
        }
        
    }
    
    @future
    private static void InsertUserToGroup(string userId)
    {
        //CG Admin
        Group approverAdminGroup = [select id from Group where Name = 'CG : Admin'];
        GroupMember memberAdmin = new GroupMember();
        memberAdmin.UserOrGroupId = userId;
        memberAdmin.GroupId = approverAdminGroup.Id;
        insert(memberAdmin);
        
        //CG GLVP
        Group approverGLVPGroup = [select id from Group where Name = 'CG : GLVP'];
        GroupMember memberGLVP = new GroupMember();
        memberGLVP.UserOrGroupId = userId;
        memberGLVP.GroupId = approverGLVPGroup.Id;
        insert(memberGLVP);
        
        //CG GLGC
        Group approverGLGCGroup = [select id from Group where Name = 'CG : GLGC'];
        GroupMember memberGLGC = new GroupMember();
        memberGLGC.UserOrGroupId = userId;
        memberGLGC.GroupId = approverGLGCGroup.Id;
        insert(memberGLGC);
    }
    
    @future
    private static void InsertCompany()
    {
    	SD_Company__c Company = new SD_Company__c();
        Company.Name = 'TOP';
        Company.Company_Full_Name__c = 'TOP';
        insert(Company);
        
        //return Company;
    }
    
}