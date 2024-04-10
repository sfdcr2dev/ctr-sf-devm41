@isTest
public class CG_Reporting_History_Test {
    
    public static testMethod void CGReportingHistoryTest() {
        
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
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today().addDays(-1);
            CGReporting.End_Duration__c = date.today().addDays(1);
            CGReporting.Submitted_Date__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGReporting);
            
            CG_Reporting__c COIAnnual = new CG_Reporting__c();
            COIAnnual.Running_No__c = 'COI-2022-02-0001';
            COIAnnual.User__c = testUser.Id;
            COIAnnual.OwnerId = testUser.Id;
            COIAnnual.Start_Duration__c = date.today().addDays(-1);
            COIAnnual.End_Duration__c = date.today().addDays(1);
            COIAnnual.Submitted_Date__c = date.today();
            COIAnnual.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIAnnual);
            COIAnnual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            COIAnnual.GenerateFromBatch__c = true;
            COIAnnual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            COIAnnual.COI_Detail__c = 'Test Detail';
            COIAnnual.COI_Action__c = 'Test Action';
            COIAnnual.COI_Disclosure__c = 'Yes';
            COIAnnual.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COIAnnual);
            
            CG_Reporting__c COIIncident = new CG_Reporting__c();
            COIIncident.Running_No__c = 'COI-2022-03-0001';
            COIIncident.User__c = testUser.Id;
            COIIncident.OwnerId = testUser.Id;
            COIIncident.Start_Duration__c = date.today().addDays(-1);
            COIIncident.End_Duration__c = date.today().addDays(1);
            COIIncident.Submitted_Date__c = date.today();
            COIIncident.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            COIIncident.GenerateFromBatch__c = true;
            COIIncident.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            COIIncident.COI_Detail__c = 'Test Detail';
            COIIncident.COI_Action__c = 'Test Action';
            COIIncident.COI_Disclosure__c = 'Yes';
            COIIncident.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COIIncident);
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            DateTime startDT = DateTime.now().addDays(-3);
            DateTime endDT = DateTime.now().addDays(3);
            
            //COI
            CG_Reporting_History.GetCOIHistoryCount(startDT, endDT);
            CG_Reporting_History.GetCOIHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCOIHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'disclosureReport';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCOIHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'supervisorName';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCOIHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCOIHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCOIHistoryList(startDT, endDT, SortByParam, PageParam);
            
            CG_Reporting_History.assignToCOIReportListDTO(CGReporting);
            CG_Reporting_History.assignToCOIReportListDTO(COIAnnual);
            CG_Reporting_History.assignToCOIReportListDTO(COIIncident);
            CG_Reporting_History.assignToCOIReportHistoryListDTO(CGReporting);
            
            CGReporting.COI_Disclosure__c = 'No';
            CG_Reporting_History.assignToCOIReportHistoryListDTO(CGReporting);
            
            CGReporting.COI_Disclosure__c = 'NotSure';
            CG_Reporting_History.assignToCOIReportHistoryListDTO(CGReporting);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CG_Reporting_History.assignToCOIReportHistoryListDTO(CGReporting);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_Reporting_History.assignToCOIReportHistoryListDTO(CGReporting);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CG_Reporting_History.assignToCOIReportHistoryListDTO(CGReporting);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Reporting_History.assignToCOIReportHistoryListDTO(CGReporting);
            
            CG_Reporting_History.assignToCOIReportHistoryListDTO(COIAnnual);
            CG_Reporting_History.assignToCOIReportHistoryListDTO(COIIncident);
            
            //CG
            CG_Reporting__c CGManual = new CG_Reporting__c();
            CGManual.Running_No__c = 'CG-2022-01-0001';
            CGManual.User__c = testUser.Id;
            CGManual.OwnerId = testUser.Id;
            CGManual.Start_Duration__c = date.today().addDays(-1);
            CGManual.End_Duration__c = date.today().addDays(1);
            CGManual.Submitted_Date__c = date.today();
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
            
            CG_Reporting__c CGAnnual = new CG_Reporting__c();
            CGAnnual.Running_No__c = 'CG-2022-02-0001';
            CGAnnual.User__c = testUser.Id;
            CGAnnual.OwnerId = testUser.Id;
            CGAnnual.Start_Duration__c = date.today().addDays(-1);
            CGAnnual.End_Duration__c = date.today().addDays(1);
            CGAnnual.Submitted_Date__c = date.today();
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
            
            CG_Reporting__c CGNewEmployee = new CG_Reporting__c();
            CGNewEmployee.Running_No__c = 'CG-2022-02-0003';
            CGNewEmployee.User__c = testUser.Id;
            CGNewEmployee.OwnerId = testUser.Id;
            CGNewEmployee.Start_Duration__c = date.today().addDays(-1);
            CGNewEmployee.End_Duration__c = date.today().addDays(1);
            CGNewEmployee.Submitted_Date__c = date.today();
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
            
            CG_Reporting_History.GetCGHistoryCount(startDT, endDT);
            CG_Reporting_History.GetCGHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCGHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCGHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCGHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_Reporting_History.GetCGHistoryList(startDT, endDT, SortByParam, PageParam);
            
            CG_Reporting_History.GetCGReportWorkflow(CGReporting.Id);
            CG_Reporting_History.assignToCGManualReportListDTO(CGManual);
            CG_Reporting_History.assignToCGManualReportListDTO(CGAnnual);
            CG_Reporting_History.assignToCGManualReportListDTO(CGNewEmployee);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_Reporting_History.assignToCGManualReportListDTO(CGNewEmployee);
            
            CG_Reporting_History.assignToCGReportHistoryListDTO(CGManual);
            CG_Reporting_History.assignToCGReportHistoryListDTO(CGAnnual);
            CG_Reporting_History.assignToCGReportHistoryListDTO(CGNewEmployee);
            
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CG_Reporting_History.assignToCGReportHistoryListDTO(CGNewEmployee);
            
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.Employee));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.Supervisor));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.GLVP));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.GLGC));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Supervisor), String.ValueOf(CG_Enum.ApproverRole.Supervisor));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.GLGC), null);
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.GLVP), null);
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.SuperAdmin), null);
            
        }
                    
        Test.stopTest();
        
    }

    public static testMethod void GiftReportingHistoryTest() {
        
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
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            DateTime startDT = DateTime.now().addDays(-3);
            DateTime endDT = DateTime.now().addDays(3);
            
            //GiftRegistration
            CG_Reporting__c GiftReporting = new CG_Reporting__c();
            GiftReporting.Running_No__c = 'GIFT-2022-0001';
            GiftReporting.OwnerId = testUser.Id;
            GiftReporting.User__c = testUser.Id;
            GiftReporting.Start_Duration__c = date.today().AddDays(-1);
            GiftReporting.End_Duration__c = date.today().AddDays(1);
            GiftReporting.Submitted_Date__c = date.today();
            GiftReporting.Type_of_Report__c = 'GiftRegistration';
            GiftReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            GiftReporting.GenerateFromBatch__c = true;
            GiftReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            GiftReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            GiftReporting.Submit_Within_Date__c = date.today();
            GiftReporting.Gift_Item__c = '[{"submittedDate":"2022-10-06T00:00:00.000Z","receivedFrom":"Test","name":"Item","giftValue":10000,"giftStatus":null,"giftDonatedComment":null}]';
            insert(GiftReporting);
            
            CG_Reporting_History.GetGiftHistoryCount(startDT, endDT);
            CG_Reporting_History.GetGiftHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'supervisorName';
            SortByParam.ascending = true;
            CG_Reporting_History.GetGiftHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_Reporting_History.GetGiftHistoryList(startDT, endDT, SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_Reporting_History.GetGiftHistoryList(startDT, endDT, SortByParam, PageParam);
            
            CG_Reporting_History.GetGiftReportWorkflow(GiftReporting.Id);
            CG_Reporting_History.assignToGiftReportHistoryListDTO(GiftReporting);
            
            GiftReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CG_Reporting_History.assignToGiftReportHistoryListDTO(GiftReporting);
            
            GiftReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
            CG_Reporting_History.assignToGiftReportHistoryListDTO(GiftReporting);
            
            GiftReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_Reporting_History.assignToGiftReportHistoryListDTO(GiftReporting);
            
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.Employee));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.Supervisor));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.GLVP));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Employee), String.ValueOf(CG_Enum.ApproverRole.GLGC));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.Supervisor), String.ValueOf(CG_Enum.ApproverRole.Supervisor));
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.GLGC), null);
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.GLVP), null);
            CG_Reporting_History.isShowStatusInHistory(String.ValueOf(CG_Enum.ApproverRole.SuperAdmin), null);
            
        }
                    
        Test.stopTest();
        
    }
    
}