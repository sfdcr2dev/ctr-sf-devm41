@isTest
public class CG_Report_Test {
    
    public static testMethod void COIReportTest() {
        
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
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.LineManagerUser__c = testUser.Id;
        thaninthon.FUNCTION__c = 'EVPC';
        thaninthon.DEPARTMENT__c = 'EVPO';
        thaninthon.SECTIONS__c = 'SCSE';
        thaninthon.UNITS__c = 'ABCD';
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
            
        //SD_Company__c Company = InsertCompany();
        
        Test.startTest();  
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today().addDays(-1);
            CGReporting.End_Duration__c = date.today().addDays(1);
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            CGReporting.Reported_By_Company_EN__c = 'TOP';
            CGReporting.Submitted_Date__c = date.today();
            insert(CGReporting);
            CGReports.add(CGReporting);
            
            CG_COI_Reporting.GetIncidentReportCount();
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'name';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            DateTime startDT = DateTime.now().addDays(-3);
            DateTime endDT = DateTime.now().addDays(3);
            
            CG_COI_Reporting.ReportCOISearchCriteria ReportCOISearchCriteria = new CG_COI_Reporting.ReportCOISearchCriteria();
            ReportCOISearchCriteria.startDate = DateTime.now().addDays(-3);
            ReportCOISearchCriteria.endDate = DateTime.now().addDays(3);
            ReportCOISearchCriteria.reportType = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            ReportCOISearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            ReportCOISearchCriteria.companyId = 'TOP|TES';
            ReportCOISearchCriteria.coiAnswer = 'Yes';
            ReportCOISearchCriteria.function = 'EVPC';
            ReportCOISearchCriteria.department = 'EVPO';
            ReportCOISearchCriteria.section = 'SCSE';
            ReportCOISearchCriteria.unit = 'ABCD';
            CG_Report.GetReportCOISummaryCount(ReportCOISearchCriteria);
            CG_Report.ExportCOIAllExcel(ReportCOISearchCriteria);
            CG_Report.ExportCOITableExcel(ReportCOISearchCriteria);
            CG_Report.GetReportCOIAnswerChart(ReportCOISearchCriteria);
            CG_Report.GetReportCOITypeRadialChart(ReportCOISearchCriteria);
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Company');
            CG_Report.CGAcknowledgeForm(CGReporting.Id);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            update(CGReporting);
            ReportCOISearchCriteria.status = CGReporting.Status__c;
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Company');
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            update(CGReporting);
            ReportCOISearchCriteria.status = CGReporting.Status__c;
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Company');
            
            //Function
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Function');
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            update(CGReporting);
            ReportCOISearchCriteria.status = CGReporting.Status__c;
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Function');
            
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Department');
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Section');
            CG_Report.GetReportCOIStatusSeriesChart(ReportCOISearchCriteria, 'Unit');
            
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = false;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = true;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = false;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = true;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = false;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerOrgFunction';
            SortByParam.ascending = true;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerOrgFunction';
            SortByParam.ascending = false;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = false;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = false;
            CG_Report.GetReportCOIInfoList(ReportCOISearchCriteria, SortByParam, PageParam);
            
            CG_Report.GetReportCOIStatistics(ReportCOISearchCriteria);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            update(CGReporting);
            ReportCOISearchCriteria.status = CGReporting.Status__c;
            CG_Report.GetReportCOIStatistics(ReportCOISearchCriteria);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            update(CGReporting);
            ReportCOISearchCriteria.status = CGReporting.Status__c;
            CG_Report.GetReportCOIStatistics(ReportCOISearchCriteria);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            update(CGReporting);
            ReportCOISearchCriteria.status = CGReporting.Status__c;
            CG_Report.GetReportCOIStatistics(ReportCOISearchCriteria);
            
            CG_Report.GetReportWorkflow(CGReporting.Id);
            
            //CG
        	CG_Reporting__c CGNewEmployee = new CG_Reporting__c();
            CGNewEmployee.Running_No__c = 'CG-2022-01-0001';
            CGNewEmployee.User__c = testUser.Id;
            CGNewEmployee.OwnerId = testUser.Id;
            CGNewEmployee.Start_Duration__c = date.today().addDays(-1);
            CGNewEmployee.End_Duration__c = date.today().addDays(1);
            CGNewEmployee.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGNewEmployee);
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGNewEmployee.GenerateFromBatch__c = true;
            CGNewEmployee.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGNewEmployee.Owner_Function__c = 'EVPC';
            CGNewEmployee.Owner_Department__c = 'EVPO';
            CGNewEmployee.Owner_Section__c = 'SCSE';
            CGNewEmployee.Owner_Unit__c = 'ABCD';
            insert(CGNewEmployee);
            CGReports.add(CGNewEmployee);
            
            CG_Manual_Reporting.ReportCGSearchCriteria ReportCGSearchCriteria = new CG_Manual_Reporting.ReportCGSearchCriteria();
            ReportCGSearchCriteria.startDate = DateTime.now().addDays(-3);
            ReportCGSearchCriteria.endDate = DateTime.now().addDays(3);
            ReportCGSearchCriteria.reportType = 'CGNewEmployee';
            ReportCGSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            ReportCGSearchCriteria.function = 'EVPC';
            ReportCGSearchCriteria.department = 'EVPO';
            ReportCGSearchCriteria.section = 'SCSE';
            ReportCGSearchCriteria.unit = 'ABCD';
            CG_Report.GetReportCGSummaryCount(ReportCGSearchCriteria);
            CG_Report.GetReportCGTypeRadialChart(ReportCGSearchCriteria);
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerOrgFunction';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            CG_Report.GetReportCGStatistics(ReportCGSearchCriteria);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            update(CGNewEmployee);
            ReportCGSearchCriteria.status = CGNewEmployee.Status__c;
            CG_Report.GetReportCGStatistics(ReportCGSearchCriteria);
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Company');
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            update(CGNewEmployee);
            ReportCGSearchCriteria.status = CGNewEmployee.Status__c;
            CG_Report.GetReportCGStatistics(ReportCGSearchCriteria);
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Company');
            
            CG_Report.ExportCGAllExcel(ReportCGSearchCriteria);
            CG_Report.ExportCGTableExcel(ReportCGSearchCriteria);
            
            CG_Report.CGGlobal_GetCompanies();
            CG_Report.CGGlobal_GetFunctions('Test');
            CG_Report.CGGlobal_GetDepartments('Test');
            CG_Report.CGGlobal_GetSections('Test');
            CG_Report.CGGlobal_GetUnits('Test');
        }
                    
        Test.stopTest();
        
    }
    
    public static testMethod void CGReportTest() {
        
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
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.LineManagerUser__c = testUser.Id;
        thaninthon.FUNCTION__c = 'EVPC';
        thaninthon.DEPARTMENT__c = 'EVPO';
        thaninthon.SECTIONS__c = 'SCSE';
        thaninthon.UNITS__c = 'ABCD';
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
            
        //SD_Company__c Company = InsertCompany();
        
        Test.startTest();  
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'name';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            DateTime startDT = DateTime.now().addDays(-3);
            DateTime endDT = DateTime.now().addDays(3);
            
            //CG
        	CG_Reporting__c CGNewEmployee = new CG_Reporting__c();
            CGNewEmployee.Running_No__c = 'CG-2022-01-0001';
            CGNewEmployee.User__c = testUser.Id;
            CGNewEmployee.OwnerId = testUser.Id;
            CGNewEmployee.Start_Duration__c = date.today().addDays(-1);
            CGNewEmployee.End_Duration__c = date.today().addDays(1);
            CGNewEmployee.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGNewEmployee);
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGNewEmployee.GenerateFromBatch__c = true;
            CGNewEmployee.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGNewEmployee.Owner_Function__c = 'EVPC';
            CGNewEmployee.Owner_Department__c = 'EVPO';
            CGNewEmployee.Owner_Section__c = 'SCSE';
            CGNewEmployee.Owner_Unit__c = 'ABCD';
            insert(CGNewEmployee);
            CGReports.add(CGNewEmployee);
            
            CG_Manual_Reporting.ReportCGSearchCriteria ReportCGSearchCriteria = new CG_Manual_Reporting.ReportCGSearchCriteria();
            ReportCGSearchCriteria.startDate = DateTime.now().addDays(-3);
            ReportCGSearchCriteria.endDate = DateTime.now().addDays(3);
            ReportCGSearchCriteria.reportType = 'CGNewEmployee';
            ReportCGSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            ReportCGSearchCriteria.function = 'EVPC';
            ReportCGSearchCriteria.department = 'EVPO';
            ReportCGSearchCriteria.section = 'SCSE';
            ReportCGSearchCriteria.unit = 'ABCD';
            CG_Report.GetReportCGSummaryCount(ReportCGSearchCriteria);
            CG_Report.GetReportCGTypeRadialChart(ReportCGSearchCriteria);
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerOrgFunction';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerOrgFunction';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = false;
            CG_Report.GetReportCGInfoList(ReportCGSearchCriteria, SortByParam, PageParam);
            
            CG_Report.GetReportCGStatistics(ReportCGSearchCriteria);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            update(CGNewEmployee);
            ReportCGSearchCriteria.status = CGNewEmployee.Status__c;
            CG_Report.GetReportCGStatistics(ReportCGSearchCriteria);
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Company');
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Function');
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Department');
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Unit');
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            update(CGNewEmployee);
            ReportCGSearchCriteria.status = CGNewEmployee.Status__c;
            CG_Report.GetReportCGStatistics(ReportCGSearchCriteria);
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Company');
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Function');
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Department');
            CG_Report.GetReportCGStatusSeriesChart(ReportCGSearchCriteria, 'Unit');
            
            CG_Report.ExportCGAllExcel(ReportCGSearchCriteria);
            CG_Report.ExportCGTableExcel(ReportCGSearchCriteria);
            
            CG_Report.CGGlobal_GetCompanies();
            CG_Report.CGGlobal_GetFunctions('Test');
            CG_Report.CGGlobal_GetDepartments('Test');
            CG_Report.CGGlobal_GetSections('Test');
            CG_Report.CGGlobal_GetUnits('Test');
        }
                    
        Test.stopTest();
        
    }
    
    public static testMethod void GiftReportTest() {
        
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
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.LineManagerUser__c = testUser.Id;
        thaninthon.FUNCTION__c = 'EVPC';
        thaninthon.DEPARTMENT__c = 'EVPO';
        thaninthon.SECTIONS__c = 'SCSE';
        thaninthon.UNITS__c = 'ABCD';
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
            
        //SD_Company__c Company = InsertCompany();
        
        Test.startTest();  
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'name';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            DateTime startDT = DateTime.now().addDays(-3);
            DateTime endDT = DateTime.now().addDays(3);
            
            //Gift
            CG_Reporting__c Gift = new CG_Reporting__c();
            Gift.Running_No__c = 'GIFT-2022-0001';
            Gift.OwnerId = testUser.Id;
            Gift.User__c = testUser.Id;
            Gift.Start_Duration__c = date.today().addDays(-1);
            Gift.End_Duration__c = date.today().addDays(1);
            Gift.Type_of_Report__c = 'GiftRegistration';
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            Gift.GenerateFromBatch__c = true;
            Gift.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            Gift.Supervisor_Approver_Status__c = 'Acknowledged';
            Gift.Submit_Within_Date__c = date.today();
            Gift.Gift_Item__c = '[{"submittedDate":"2022-10-06T00:00:00.000Z","receivedFrom":"Test","name":"Item","giftValue":10000,"giftStatus":null,"giftDonatedComment":null}]';
            Gift.Owner_Function__c = 'EVPC';
            Gift.Owner_Department__c = 'EVPO';
            Gift.Owner_Section__c = 'SCSE';
            Gift.Owner_Unit__c = 'ABCD';
            insert(Gift);
            
            CG_Gift_Reporting.ReportGiftSearchCriteria ReportGiftSearchCriteria = new CG_Gift_Reporting.ReportGiftSearchCriteria();
            ReportGiftSearchCriteria.startDate = DateTime.now().addDays(-3);
            ReportGiftSearchCriteria.endDate = DateTime.now().addDays(3);
            //ReportGiftSearchCriteria.giftStatus = 'InStock';
            ReportGiftSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            ReportGiftSearchCriteria.function = 'EVPC';
            ReportGiftSearchCriteria.department = 'EVPO';
            ReportGiftSearchCriteria.section = 'SCSE';
            
            CG_Report.GetReportGiftSummaryCount(ReportGiftSearchCriteria);
            CG_Report.GetReportGiftStatusSeriesChart(ReportGiftSearchCriteria, 'Company');
            CG_Report.GetReportGiftStatusSeriesChart(ReportGiftSearchCriteria, 'Function');
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
            update(Gift);
            ReportGiftSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
            CG_Report.GetReportGiftStatusSeriesChart(ReportGiftSearchCriteria, 'Company');
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            update(Gift);
            ReportGiftSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_Report.GetReportGiftStatusSeriesChart(ReportGiftSearchCriteria, 'Company');
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            update(Gift);
            ReportGiftSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Report.GetReportGiftStatusSeriesChart(ReportGiftSearchCriteria, 'Company');
            CG_Report.GetReportGiftStatusChart(ReportGiftSearchCriteria);
            
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = false;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = true;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'owner';
            SortByParam.ascending = false;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerOrgFunction';
            SortByParam.ascending = true;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerOrgFunction';
            SortByParam.ascending = false;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'supervisorDecision';
            SortByParam.ascending = true;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'supervisorDecision';
            SortByParam.ascending = false;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = false;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = false;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'giftStatus';
            SortByParam.ascending = true;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'giftStatus';
            SortByParam.ascending = false;
            CG_Report.GetReportGiftInfoList(ReportGiftSearchCriteria, SortByParam, PageParam);
            
            CG_Report.GetReportGiftStatistics(ReportGiftSearchCriteria);
            CG_Report.ExportGiftAllExcel(ReportGiftSearchCriteria);
            CG_Report.ExportGiftTableExcel(ReportGiftSearchCriteria);
            
        }
                    
        Test.stopTest();
        
    }
    
    public static testMethod void PrivateMethod() {
        
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
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.LineManagerUser__c = testUser.Id;
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
            
        //SD_Company__c Company = InsertCompany();
        
        Test.startTest();  
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGReporting);
            CGReports.add(CGReporting);
            
        	CG_Reporting__c COIAnnual = new CG_Reporting__c();
            COIAnnual.Running_No__c = 'COI-2022-02-0001';
            COIAnnual.OwnerId = testUser.Id;
            COIAnnual.User__c = testUser.Id;
            COIAnnual.Start_Duration__c = date.today();
            COIAnnual.End_Duration__c = date.today();
            COIAnnual.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIAnnual);
            COIAnnual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            COIAnnual.GenerateFromBatch__c = true;
            COIAnnual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COIAnnual.COI_Detail__c = 'Test Detail';
            COIAnnual.COI_Action__c = 'Test Action';
            COIAnnual.COI_Disclosure__c = 'Yes';
            COIAnnual.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COIAnnual);
            CGReports.add(COIAnnual);
            
        	CG_Reporting__c COIIncident = new CG_Reporting__c();
            COIIncident.Running_No__c = 'COI-2022-03-0001';
            COIIncident.OwnerId = testUser.Id;
            COIIncident.User__c = testUser.Id;
            COIIncident.Start_Duration__c = date.today();
            COIIncident.End_Duration__c = date.today();
            COIIncident.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            COIIncident.GenerateFromBatch__c = true;
            COIIncident.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COIIncident.COI_Detail__c = 'Test Detail';
            COIIncident.COI_Action__c = 'Test Action';
            COIIncident.COI_Disclosure__c = 'Yes';
            COIIncident.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COIIncident);
            CGReports.add(COIIncident);
            
            CG_COI_Reporting.GetIncidentReportCount();
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'name';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            CG_Report.assignToReportCOIInfoDTO(CGReporting, null);
            CG_Report.assignToReportCOIInfoDTO(COIAnnual, null);
            CG_Report.assignToReportCOIInfoDTO(COIIncident, null);
            
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_Report.assignToReportCOIInfoDTO(COIIncident, null);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CG_Report.assignToReportCOIInfoDTO(COIIncident, null);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Report.assignToReportCOIInfoDTO(COIIncident, null);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
            CG_Report.assignToReportCOIInfoDTO(COIIncident, null);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.Cancel);
            CG_Report.assignToReportCOIInfoDTO(COIIncident, null);
            
            //CG
            CG_Reporting__c CGManual = new CG_Reporting__c();
            CGManual.Running_No__c = 'CG-2022-01-0001';
            CGManual.User__c = testUser.Id;
            CGManual.OwnerId = testUser.Id;
            CGManual.Start_Duration__c = date.today();
            CGManual.End_Duration__c = date.today();
            CGManual.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGManual);
            CGManual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGManual.GenerateFromBatch__c = true;
            CGManual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGManual.CG_Agree_to_Study__c = true;
            CGManual.CG_Received_Manual__c = true;
            CGManual.CG_Download_Manual__c = true;
            CGManual.Owner_Function__c = 'EVPC';
            CGManual.Owner_Department__c = 'EVPO';
            CGManual.Owner_Section__c = 'SCSE';
            CGManual.Owner_Unit__c = 'ABCD';
            insert(CGManual);
            
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
            
            CG_Report.assignToReportCGInfoDTO(CGAnnual, null);
            CG_Report.assignToReportCGInfoDTO(CGManual, null);
            CG_Report.assignToReportCGInfoDTO(CGNewEmployee, null);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CG_Report.assignToReportCGInfoDTO(CGNewEmployee, null);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_Report.assignToReportCGInfoDTO(CGNewEmployee, null);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CG_Report.assignToReportCGInfoDTO(CGNewEmployee, null);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Report.assignToReportCGInfoDTO(CGNewEmployee, null);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Cancel);
            CG_Report.assignToReportCGInfoDTO(CGNewEmployee, null);
            
            //Gift
            CG_Reporting__c Gift = new CG_Reporting__c();
            Gift.Running_No__c = 'GIFT-2022-0001';
            Gift.OwnerId = testUser.Id;
            Gift.User__c = testUser.Id;
            Gift.Start_Duration__c = date.today();
            Gift.End_Duration__c = date.today();
            Gift.Type_of_Report__c = 'GiftRegistration';
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            Gift.GenerateFromBatch__c = true;
            Gift.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            Gift.Supervisor_Approver_Status__c = 'Acknowledged';
            Gift.Submit_Within_Date__c = date.today();
            Gift.Gift_Item__c = '[{"submittedDate":"2022-10-06T00:00:00.000Z","receivedFrom":"Test","name":"Item","giftValue":10000,"giftStatus":null,"giftDonatedComment":null}]';
            insert(Gift);
            
            CG_Report.assignToReportGiftInfoDTO(Gift, null);
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CG_Report.assignToReportGiftInfoDTO(Gift, null);
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_Report.assignToReportGiftInfoDTO(Gift, null);
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
            CG_Report.assignToReportGiftInfoDTO(Gift, null);
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CG_Report.assignToReportGiftInfoDTO(Gift, null);
            
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Report.assignToReportGiftInfoDTO(Gift, null);
            
        }
        
    }
}