@isTest
public class CG_Home_Test {
    
    public static testMethod void GetHomeMenu() {
        
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
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGReporting);
            CGReports.add(CGReporting);
            
        	CG_Reporting__c COINewEmployeeWS = new CG_Reporting__c();
            COINewEmployeeWS.Running_No__c = 'COI-2022-01-0001';
            COINewEmployeeWS.OwnerId = testUser.Id;
            COINewEmployeeWS.User__c = testUser.Id;
            COINewEmployeeWS.Start_Duration__c = date.today();
            COINewEmployeeWS.End_Duration__c = date.today();
            COINewEmployeeWS.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            COINewEmployeeWS.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            COINewEmployeeWS.GenerateFromBatch__c = true;
            COINewEmployeeWS.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COINewEmployeeWS.COI_Detail__c = 'Test Detail';
            COINewEmployeeWS.COI_Action__c = 'Test Action';
            COINewEmployeeWS.COI_Disclosure__c = 'Yes';
            COINewEmployeeWS.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COINewEmployeeWS);
            CGReports.add(COINewEmployeeWS);
            
        	CG_Reporting__c COINewEmployeeGLVP = new CG_Reporting__c();
            COINewEmployeeGLVP.Running_No__c = 'COI-2022-01-0001';
            COINewEmployeeGLVP.OwnerId = testUser.Id;
            COINewEmployeeGLVP.User__c = testUser.Id;
            COINewEmployeeGLVP.Start_Duration__c = date.today();
            COINewEmployeeGLVP.End_Duration__c = date.today();
            COINewEmployeeGLVP.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            COINewEmployeeGLVP.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            COINewEmployeeGLVP.GenerateFromBatch__c = true;
            COINewEmployeeGLVP.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COINewEmployeeGLVP.COI_Detail__c = 'Test Detail';
            COINewEmployeeGLVP.COI_Action__c = 'Test Action';
            COINewEmployeeGLVP.COI_Disclosure__c = 'Yes';
            COINewEmployeeGLVP.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COINewEmployeeGLVP);
            CGReports.add(COINewEmployeeGLVP);
            
        	CG_Reporting__c COINewEmployeeGLGC = new CG_Reporting__c();
            COINewEmployeeGLGC.Running_No__c = 'COI-2022-01-0001';
            COINewEmployeeGLGC.OwnerId = testUser.Id;
            COINewEmployeeGLGC.User__c = testUser.Id;
            COINewEmployeeGLGC.Start_Duration__c = date.today();
            COINewEmployeeGLGC.End_Duration__c = date.today();
            COINewEmployeeGLGC.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            COINewEmployeeGLGC.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
            COINewEmployeeGLGC.GenerateFromBatch__c = true;
            COINewEmployeeGLGC.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COINewEmployeeGLGC.COI_Detail__c = 'Test Detail';
            COINewEmployeeGLGC.COI_Action__c = 'Test Action';
            COINewEmployeeGLGC.COI_Disclosure__c = 'Yes';
            COINewEmployeeGLGC.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COINewEmployeeGLGC);
            CGReports.add(COINewEmployeeGLGC);
            
        	CG_Reporting__c COIAnnualRejected = new CG_Reporting__c();
            COIAnnualRejected.Running_No__c = 'COI-2022-02-0001';
            COIAnnualRejected.OwnerId = testUser.Id;
            COIAnnualRejected.User__c = testUser.Id;
            COIAnnualRejected.Start_Duration__c = date.today();
            COIAnnualRejected.End_Duration__c = date.today();
            COIAnnualRejected.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIAnnual);
            COIAnnualRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            COIAnnualRejected.GenerateFromBatch__c = true;
            COIAnnualRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COIAnnualRejected.COI_Detail__c = 'Test Detail';
            COIAnnualRejected.COI_Action__c = 'Test Action';
            COIAnnualRejected.COI_Disclosure__c = 'Yes';
            COIAnnualRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COIAnnualRejected);
            CGReports.add(COIAnnualRejected);
            
        	CG_Reporting__c CGAnnual = new CG_Reporting__c();
            CGAnnual.Running_No__c = 'COI-2022-02-0001';
            CGAnnual.OwnerId = testUser.Id;
            CGAnnual.User__c = testUser.Id;
            CGAnnual.Start_Duration__c = date.today();
            CGAnnual.End_Duration__c = date.today();
            CGAnnual.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGAnnual);
            CGAnnual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGAnnual.GenerateFromBatch__c = true;
            CGAnnual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGAnnual.COI_Detail__c = 'Test Detail';
            CGAnnual.COI_Action__c = 'Test Action';
            CGAnnual.COI_Disclosure__c = 'Yes';
            CGAnnual.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGAnnual);
            CGReports.add(CGAnnual);
            
        	CG_Reporting__c CGAnnualRejected = new CG_Reporting__c();
            CGAnnualRejected.Running_No__c = 'COI-2022-02-0001';
            CGAnnualRejected.OwnerId = testUser.Id;
            CGAnnual.User__c = testUser.Id;
            CGAnnualRejected.Start_Duration__c = date.today();
            CGAnnualRejected.End_Duration__c = date.today();
            CGAnnualRejected.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGAnnual);
            CGAnnualRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CGAnnualRejected.GenerateFromBatch__c = true;
            CGAnnualRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGAnnualRejected.COI_Detail__c = 'Test Detail';
            CGAnnualRejected.COI_Action__c = 'Test Action';
            CGAnnualRejected.COI_Disclosure__c = 'Yes';
            CGAnnualRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGAnnualRejected);
            CGReports.add(CGAnnualRejected);
            
        	CG_Reporting__c CGManualRejected = new CG_Reporting__c();
            CGManualRejected.Running_No__c = 'COI-2022-03-0001';
            CGManualRejected.OwnerId = testUser.Id;
            CGManualRejected.User__c = testUser.Id;
            CGManualRejected.Start_Duration__c = date.today();
            CGManualRejected.End_Duration__c = date.today();
            CGManualRejected.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGManual);
            CGManualRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CGManualRejected.GenerateFromBatch__c = true;
            CGManualRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGManualRejected.COI_Detail__c = 'Test Detail';
            CGManualRejected.COI_Action__c = 'Test Action';
            CGManualRejected.COI_Disclosure__c = 'Yes';
            CGManualRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGManualRejected);
            CGReports.add(CGManualRejected);
            
        	CG_Reporting__c CGNewEmployeeRejected = new CG_Reporting__c();
            CGNewEmployeeRejected.Running_No__c = 'COI-2022-03-0001';
            CGNewEmployeeRejected.OwnerId = testUser.Id;
            CGNewEmployeeRejected.User__c = testUser.Id;
            CGNewEmployeeRejected.Start_Duration__c = date.today();
            CGNewEmployeeRejected.End_Duration__c = date.today();
            CGNewEmployeeRejected.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGNewEmployee);
            CGNewEmployeeRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CGNewEmployeeRejected.GenerateFromBatch__c = true;
            CGNewEmployeeRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGNewEmployeeRejected.COI_Detail__c = 'Test Detail';
            CGNewEmployeeRejected.COI_Action__c = 'Test Action';
            CGNewEmployeeRejected.COI_Disclosure__c = 'Yes';
            CGNewEmployeeRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGNewEmployeeRejected);
            CGReports.add(CGNewEmployeeRejected);
            
            CG_Home.GetHomeMenu();
            CG_Home.COIReport('COI', CGReports);
            CG_Home.COIReport('CG', CGReports);
            CG_Home.COIReport('GiftRegistration', CGReports);
    
            Test.stopTest();
        }
        
    }
    
    public static testMethod void GetHomeMenuSuperAdmin() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
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
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGReporting);
            CGReports.add(CGReporting);
            
        	CG_Reporting__c COINewEmployeeWS = new CG_Reporting__c();
            COINewEmployeeWS.Running_No__c = 'COI-2022-01-0001';
            COINewEmployeeWS.OwnerId = testUser.Id;
            COINewEmployeeWS.User__c = testUser.Id;
            COINewEmployeeWS.Start_Duration__c = date.today();
            COINewEmployeeWS.End_Duration__c = date.today();
            COINewEmployeeWS.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            COINewEmployeeWS.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            COINewEmployeeWS.GenerateFromBatch__c = true;
            COINewEmployeeWS.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COINewEmployeeWS.COI_Detail__c = 'Test Detail';
            COINewEmployeeWS.COI_Action__c = 'Test Action';
            COINewEmployeeWS.COI_Disclosure__c = 'Yes';
            COINewEmployeeWS.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COINewEmployeeWS);
            CGReports.add(COINewEmployeeWS);
            
        	CG_Reporting__c COINewEmployeeGLVP = new CG_Reporting__c();
            COINewEmployeeGLVP.Running_No__c = 'COI-2022-01-0001';
            COINewEmployeeGLVP.OwnerId = testUser.Id;
            COINewEmployeeGLVP.User__c = testUser.Id;
            COINewEmployeeGLVP.Start_Duration__c = date.today();
            COINewEmployeeGLVP.End_Duration__c = date.today();
            COINewEmployeeGLVP.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            COINewEmployeeGLVP.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            COINewEmployeeGLVP.GenerateFromBatch__c = true;
            COINewEmployeeGLVP.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COINewEmployeeGLVP.COI_Detail__c = 'Test Detail';
            COINewEmployeeGLVP.COI_Action__c = 'Test Action';
            COINewEmployeeGLVP.COI_Disclosure__c = 'Yes';
            COINewEmployeeGLVP.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COINewEmployeeGLVP);
            CGReports.add(COINewEmployeeGLVP);
            
        	CG_Reporting__c COINewEmployeeGLGC = new CG_Reporting__c();
            COINewEmployeeGLGC.Running_No__c = 'COI-2022-01-0001';
            COINewEmployeeGLGC.OwnerId = testUser.Id;
            COINewEmployeeGLGC.User__c = testUser.Id;
            COINewEmployeeGLGC.Start_Duration__c = date.today();
            COINewEmployeeGLGC.End_Duration__c = date.today();
            COINewEmployeeGLGC.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            COINewEmployeeGLGC.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
            COINewEmployeeGLGC.GenerateFromBatch__c = true;
            COINewEmployeeGLGC.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COINewEmployeeGLGC.COI_Detail__c = 'Test Detail';
            COINewEmployeeGLGC.COI_Action__c = 'Test Action';
            COINewEmployeeGLGC.COI_Disclosure__c = 'Yes';
            COINewEmployeeGLGC.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COINewEmployeeGLGC);
            CGReports.add(COINewEmployeeGLGC);
            
        	CG_Reporting__c COIAnnualRejected = new CG_Reporting__c();
            COIAnnualRejected.Running_No__c = 'COI-2022-02-0001';
            COIAnnualRejected.OwnerId = testUser.Id;
            COIAnnualRejected.User__c = testUser.Id;
            COIAnnualRejected.Start_Duration__c = date.today();
            COIAnnualRejected.End_Duration__c = date.today();
            COIAnnualRejected.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIAnnual);
            COIAnnualRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            COIAnnualRejected.GenerateFromBatch__c = true;
            COIAnnualRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COIAnnualRejected.COI_Detail__c = 'Test Detail';
            COIAnnualRejected.COI_Action__c = 'Test Action';
            COIAnnualRejected.COI_Disclosure__c = 'Yes';
            COIAnnualRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(COIAnnualRejected);
            CGReports.add(COIAnnualRejected);
            
        	CG_Reporting__c CGAnnual = new CG_Reporting__c();
            CGAnnual.Running_No__c = 'COI-2022-02-0001';
            CGAnnual.OwnerId = testUser.Id;
            CGAnnual.User__c = testUser.Id;
            CGAnnual.Start_Duration__c = date.today();
            CGAnnual.End_Duration__c = date.today();
            CGAnnual.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGAnnual);
            CGAnnual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGAnnual.GenerateFromBatch__c = true;
            CGAnnual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGAnnual.COI_Detail__c = 'Test Detail';
            CGAnnual.COI_Action__c = 'Test Action';
            CGAnnual.COI_Disclosure__c = 'Yes';
            CGAnnual.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGAnnual);
            CGReports.add(CGAnnual);
            
        	CG_Reporting__c CGAnnualRejected = new CG_Reporting__c();
            CGAnnualRejected.Running_No__c = 'COI-2022-02-0001';
            CGAnnualRejected.OwnerId = testUser.Id;
            CGAnnual.User__c = testUser.Id;
            CGAnnualRejected.Start_Duration__c = date.today();
            CGAnnualRejected.End_Duration__c = date.today();
            CGAnnualRejected.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGAnnual);
            CGAnnualRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CGAnnualRejected.GenerateFromBatch__c = true;
            CGAnnualRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGAnnualRejected.COI_Detail__c = 'Test Detail';
            CGAnnualRejected.COI_Action__c = 'Test Action';
            CGAnnualRejected.COI_Disclosure__c = 'Yes';
            CGAnnualRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGAnnualRejected);
            CGReports.add(CGAnnualRejected);
            
        	CG_Reporting__c CGManualRejected = new CG_Reporting__c();
            CGManualRejected.Running_No__c = 'COI-2022-03-0001';
            CGManualRejected.OwnerId = testUser.Id;
            CGManualRejected.User__c = testUser.Id;
            CGManualRejected.Start_Duration__c = date.today();
            CGManualRejected.End_Duration__c = date.today();
            CGManualRejected.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGManual);
            CGManualRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CGManualRejected.GenerateFromBatch__c = true;
            CGManualRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGManualRejected.COI_Detail__c = 'Test Detail';
            CGManualRejected.COI_Action__c = 'Test Action';
            CGManualRejected.COI_Disclosure__c = 'Yes';
            CGManualRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGManualRejected);
            CGReports.add(CGManualRejected);
            
        	CG_Reporting__c CGNewEmployeeRejected = new CG_Reporting__c();
            CGNewEmployeeRejected.Running_No__c = 'COI-2022-03-0001';
            CGNewEmployeeRejected.OwnerId = testUser.Id;
            CGNewEmployeeRejected.User__c = testUser.Id;
            CGNewEmployeeRejected.Start_Duration__c = date.today();
            CGNewEmployeeRejected.End_Duration__c = date.today();
            CGNewEmployeeRejected.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGNewEmployee);
            CGNewEmployeeRejected.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CGNewEmployeeRejected.GenerateFromBatch__c = true;
            CGNewEmployeeRejected.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGNewEmployeeRejected.COI_Detail__c = 'Test Detail';
            CGNewEmployeeRejected.COI_Action__c = 'Test Action';
            CGNewEmployeeRejected.COI_Disclosure__c = 'Yes';
            CGNewEmployeeRejected.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGNewEmployeeRejected);
            CGReports.add(CGNewEmployeeRejected);
            
            CG_Home.GetHomeMenu();
            CG_Home.COIReport('COI', CGReports);
            CG_Home.COIReport('CG', CGReports);
            CG_Home.COIReport('GiftRegistration', CGReports);
    
            Test.stopTest();
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
    
}