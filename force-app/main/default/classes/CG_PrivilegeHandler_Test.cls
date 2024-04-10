@isTest
public class CG_PrivilegeHandler_Test {

    public static testMethod void CGPrivilegeHandlerTest() {
        
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
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'VP';
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
            insert(CGReporting);
            CGReports.add(CGReporting);
            
            CG_PrivilegeHandler.getUserId();
            CG_PrivilegeHandler.getUserProfile();
            CG_PrivilegeHandler.checkAccessPrivilege(CGReporting.Id);
            CG_PrivilegeHandler.findLineManager(testUser.Id);
        }
        
        
    }
    
}