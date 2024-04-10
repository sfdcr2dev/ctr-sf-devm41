@isTest
public class CG_MassAcknowledge_Test {

    //COI
    public static testMethod void GetCOIMassAcknowledgeTest() {
        
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
            
        InsertUserToGroup(testUser.Id);
        
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
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            CG_MassAcknowledge.GetCOIMassAcknowledgeCount(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor));
            
            CGReporting.COI_Disclosure__c = 'No';
            update(CGReporting);
            CG_MassAcknowledge.GetCOIMassAcknowledgeCount(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor));
            
            CGReporting.COI_Disclosure__c = 'NotSure';
            update(CGReporting);
            CG_MassAcknowledge.GetCOIMassAcknowledgeCount(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor));
            
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'disclosureReport';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerName';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerPosition';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerSection';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportType';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetCOIMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), 'NotSure', SortByParam, PageParam);
            
            CG_MassAcknowledge.GetCOIReportWorkflow(CGReporting.Id);
            CG_MassAcknowledge.COIMassApproveReports(CGReporting.Id);
            CG_MassAcknowledge.COIMassApproveReports(COIAnnual.Id);
            CG_MassAcknowledge.COIMassApproveReports(COIIncident.Id);
            
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CG_MassAcknowledge.assignToCOIMassAcknowledgeListDTO(COIIncident, testUser);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_MassAcknowledge.assignToCOIMassAcknowledgeListDTO(COIIncident, testUser);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CG_MassAcknowledge.assignToCOIMassAcknowledgeListDTO(COIIncident, testUser);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_MassAcknowledge.assignToCOIMassAcknowledgeListDTO(COIIncident, testUser);
            
        	CG_MassAcknowledge.assignGLVPWhenSupervisorSubmit('Acknowledged', '', testUser.id, '{"status":{"value":"Success","key":"Success","enumName":"ReportStatus"},"reportId":"a231y000000KhMlAAK","historyWorkflows":[{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"WaitingSupervisor","key":"WaitingSupervisor","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLGC","key":"GLGC","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000i3PoFAAU","fullName":"Manassada Choothesa","email":"manassada@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:10:13.264Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLVP","key":"GLVP","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000i3GLHAA2","fullName":"Sarayut Jitprasertngam","email":"sarayutj@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:12:40.349Z"}]}],"currentWorkflow":{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"WaitingSupervisor","key":"WaitingSupervisor","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"}]}}');
        	CG_MassAcknowledge.assignGLVPWhenSupervisorSubmit('Rejected', '', testUser.id, '{"status":{"value":"Success","key":"Success","enumName":"ReportStatus"},"reportId":"a231y000000KhMlAAK","historyWorkflows":[{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLGC","key":"GLGC","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000i3PoFAAU","fullName":"Manassada Choothesa","email":"manassada@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:10:13.264Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLVP","key":"GLVP","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000i3GLHAA2","fullName":"Sarayut Jitprasertngam","email":"sarayutj@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:12:40.349Z"}]}],"currentWorkflow":{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLGC","key":"GLGC","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000i3PoFAAU","fullName":"Manassada Choothesa","email":"manassada@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:10:13.264Z"},{"status":{"value":"WaitingGLVP","key":"WaitingGLVP","enumName":"ApproverStatus"},"role":{"value":"GLVP","key":"GLVP","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000i3GLHAA2","fullName":"Sarayut Jitprasertngam","email":"sarayutj@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:12:40.349Z"}]}}');
        	
            CG_MassAcknowledge.assignSuccessWhenGLVPSubmit('Acknowledged', testUser.id, '{"status":{"value":"Success","key":"Success","enumName":"ReportStatus"},"reportId":"a231y000000KhMlAAK","historyWorkflows":[{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLGC","key":"GLGC","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000i3PoFAAU","fullName":"Manassada Choothesa","email":"manassada@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:10:13.264Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLVP","key":"GLVP","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000i3GLHAA2","fullName":"Sarayut Jitprasertngam","email":"sarayutj@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:12:40.349Z"}]}],"currentWorkflow":{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLGC","key":"GLGC","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000i3PoFAAU","fullName":"Manassada Choothesa","email":"manassada@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:10:13.264Z"},{"status":{"value":"WaitingGLVP","key":"WaitingGLVP","enumName":"ApproverStatus"},"role":{"value":"GLVP","key":"GLVP","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000i3GLHAA2","fullName":"Sarayut Jitprasertngam","email":"sarayutj@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:12:40.349Z"}]}}');
        	
        }
                    
        Test.stopTest();
        
    }
    
    //Gift
    public static testMethod void GetGiftMassAcknowledgeTest() {
        
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
            
        InsertUserToGroup(testUser.Id);
        
        Test.startTest();  
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'Gift-2022-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = 'GiftRegistration';
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            insert(CGReporting);
            
            CGReports.add(CGReporting);
            
            CG_MassAcknowledge.GetGiftMassAcknowledgeCount(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor));
            
            //SortByParam
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            
            //PageParam
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;           
            
            CG_MassAcknowledge.GetGiftMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerName';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetGiftMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerPosition';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetGiftMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'ownerSection';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetGiftMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetGiftMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetGiftMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), SortByParam, PageParam);
            
            SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            CG_MassAcknowledge.GetGiftMassAcknowledgeList(String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor), SortByParam, PageParam);
            
            //CG_MassAcknowledge.GetGiftReportWorkflow(CGReporting.Id);
            CG_MassAcknowledge.GiftMassApproveReports(CGReporting.Id);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CG_MassAcknowledge.assignToGiftMassAcknowledgeListDTO(CGReporting, testUser);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CG_MassAcknowledge.assignToGiftMassAcknowledgeListDTO(CGReporting, testUser);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
            CG_MassAcknowledge.assignToGiftMassAcknowledgeListDTO(CGReporting, testUser);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
            CG_MassAcknowledge.assignToGiftMassAcknowledgeListDTO(CGReporting, testUser);
            
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CG_MassAcknowledge.assignToGiftMassAcknowledgeListDTO(CGReporting, testUser);
            
            CG_MassAcknowledge.assignGLVPWhenGLGCSubmit('Acknowledged', '', testUser.id, '{"status":{"value":"Success","key":"Success","enumName":"ReportStatus"},"reportId":"a231y000000KhMlAAK","historyWorkflows":[{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"},{"status":{"value":"WaitingGLGC","key":"WaitingGLGC","enumName":"ApproverStatus"},"role":{"value":"GLGC","key":"GLGC","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000i3PoFAAU","fullName":"Manassada Choothesa","email":"manassada@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:10:13.264Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"GLVP","key":"GLVP","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000i3GLHAA2","fullName":"Sarayut Jitprasertngam","email":"sarayutj@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:12:40.349Z"}]}],"currentWorkflow":{"submittedDate":"2022-10-06T05:08:45.841Z","createdDate":"2022-10-06T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000iTBtBAAW","fullName":"Ramon Supharattananon","email":"ramon@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:08:45.841Z"},{"status":{"value":"Acknowledged","key":"Acknowledged","enumName":"ApproverStatus"},"role":{"value":"Supervisor","key":"Supervisor","enumName":"ApproverRole"},"isShow":true,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000iT2LpAAK","fullName":"Duangporn Teerapabpaisit","email":"duangporn@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:09:19.120Z"},{"status":{"value":"WaitingGLGC","key":"WaitingGLGC","enumName":"ApproverStatus"},"role":{"value":"GLGC","key":"GLGC","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":"test","approver":{"id":"0052v00000i3PoFAAU","fullName":"Manassada Choothesa","email":"manassada@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:10:13.264Z"},{"status":{"value":"WaitingGLVP","key":"WaitingGLVP","enumName":"ApproverStatus"},"role":{"value":"GLVP","key":"GLVP","enumName":"ApproverRole"},"isShow":false,"isCurrent":false,"comment":null,"approver":{"id":"0052v00000i3GLHAA2","fullName":"Sarayut Jitprasertngam","email":"sarayutj@thaioilgroup.com.invalid"},"actionDate":"2022-10-06T05:12:40.349Z"}]}}');
        
        	
            List<CG_DTO.GiftItemDTO> GiftItems = new List<CG_DTO.GiftItemDTO>();
            CG_DTO.GiftItemDTO GiftItem = new CG_DTO.GiftItemDTO();
            GiftItem.name = 'Test';
            GiftItem.receivedFrom = 'Test';
            GiftItem.giftValue = 1000;
            GiftItem.submittedDate = date.today();
            GiftItem.giftStatus = new CG_Global.EnumValue('GiftStatus');
            GiftItem.giftStatus.key = CG_Enum.GiftStatus.InStock.name();
            GiftItem.giftStatus.value = 'In Stock';
            GiftItems.add(GiftItem);
            
            GiftItem = new CG_DTO.GiftItemDTO();
            GiftItem.name = 'Test';
            GiftItem.receivedFrom = 'Test';
            GiftItem.giftValue = 1000;
            GiftItem.submittedDate = date.today();
            GiftItem.giftStatus = new CG_Global.EnumValue('GiftStatus');
            GiftItem.giftStatus.key = CG_Enum.GiftStatus.Donated.name();
            GiftItem.giftStatus.value = 'Donated';
            GiftItems.add(GiftItem);
            
            CG_MassAcknowledge.DeserializeGiftItems(JSON.serialize(GiftItems));
            CG_MassAcknowledge.SerializeGiftItems(GiftItems, 'InStock');
            CG_MassAcknowledge.GetGiftStatus(GiftItems);
                
        }
                    
        Test.stopTest();
        
    }
    
    @future
    private static void InsertUserToGroup(string userId)
    {
        //CG Admin
        Group approverAdminGroup = [select id from Group where developername = 'CG_Admin'];
        GroupMember memberAdmin = new GroupMember();
        memberAdmin.UserOrGroupId = userId;
        memberAdmin.GroupId = approverAdminGroup.Id;
        insert(memberAdmin);
        
        //CG GLVP
        Group approverGLVPGroup = [select id from Group where developername = 'CG_GLVP'];
        GroupMember memberGLVP = new GroupMember();
        memberGLVP.UserOrGroupId = userId;
        memberGLVP.GroupId = approverGLVPGroup.Id;
        insert(memberGLVP);
        
        //CG GLGC
        Group approverGLGCGroup = [select id from Group where developername = 'CG_GLGC'];
        GroupMember memberGLGC = new GroupMember();
        memberGLGC.UserOrGroupId = userId;
        memberGLGC.GroupId = approverGLGCGroup.Id;
        insert(memberGLGC);
    }
    
    
}