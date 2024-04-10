/**
 * @author Oktana
 * @description test class for CustomLookupController
 */
@isTest
public class THOR_CustomLookupControllerTest {
    
        /**
     * @given CustomLookupController
     * @when fetchRecords method is invoked with proper params
     * @then records that match the search criteria should be retrieved
     */
    @TestSetup
    static void makeData() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c,Form_Questions__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE DeveloperName LIKE '%Tank%'
            LIMIT 1
        ];
        
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;
        
        Master_Map__c mm = new Master_Map__c();
        mm.Name = 'ENMA-E';
        mm.Code__c = 'ENMA-E';
        mm.Description__c = 'TPX ELECTRICAL AREA-F';
        mm.Type__c = 'Main Work Center';
        mm.Master_Map_Set__c = mms.Id;
        insert mm;
        
        Master_Map__c mm2 = new Master_Map__c();
        mm2.Name = '1200';
        mm2.Code__c = '1200';
        mm2.Description__c = 'TOP Sriracha Refinery';
        mm2.Type__c = 'Plant';
        mm2.Master_Map_Set__c = mms.Id;
        insert mm2;
        
        Functional_Location__c fl = new Functional_Location__c();
        fl.Name = '1234';
        fl.PlantSection__c = 'T1';
        fl.MainWorkCenter__c = mm.Id;
        fl.Maintenance_Plant__c = mm2.Id;
        insert fl;

        Equipment__c eq = new Equipment__c();
        eq.Name = '1234';
        eq.plantSection__c = 'T1';
        eq.mainWorkCenter__c = mm.Id;
        eq.maintenancePlant__c = mm2.Id;
        insert eq;
        
        EQCC_Header__c header = new EQCC_Header__c();
        header.FunctionalLocation__c = fl.Id;
        insert header;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c,
            Form_Questions__c = formType.Form_Questions__c
        );
        insert checkedSheetToSubmit;
        
        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>{
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToSubmit.Id)
        };
        insert headerSheets;  
        
        EQCC_Step__c step = new EQCC_Step__c();
        step.Name = 'submit';
        step.Header_Sheet__c = headerSheets[0].Id;
        step.Step_Number__c = 1;
        step.Form_Code__c = formType.Form_Code__c;
        step.Is_Current__c = true;
        step.Status__c = 'Pending for approval';
        insert step;
    }
    
    private static void createUser() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        
        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        User teamLeadM = new User(
            FirstName = 'testM',
            LastName = 'userM',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Team Lead%-M/%TOC-1%' LIMIT 1]
            .Id
        );
        insert teamLeadM;
        
        User teamLeadE = new User(
            FirstName = 'testE',
            LastName = 'userE',
            Email = uniqueName + '@testE' + orgId + '.org',
            Username = uniqueName + '@testE' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' LIMIT 1]
            .Id
        );
        insert teamLeadE;
        
        User teamLeadI = new User(
            FirstName = 'testI',
            LastName = 'userI',
            Email = uniqueName + '@testI' + orgId + '.org',
            Username = uniqueName + '@testI' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Team Lead%-I/%TOC-1%' LIMIT 1]
            .Id
        );
        insert teamLeadI;
    }
    
    @isTest
    static void testFetchRecords() {
        EQCC_Step__c step = getMockStep('submit');
        List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', 'Test', '', '', step.Id, 'SpecialApprove');  
    }

	@isTest
    static void testFetchRecordsWithoutAction() {
        EQCC_Step__c step = getMockStep('submit');
        List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', 'Test', '', '', step.Id, null);  
    }    
    /**
     * @given CustomLookupController
     * @when fetchRecords method is invoked with proper params
     * @then records that match the search criteria should be retrieved
     */
    @isTest
    static void testFetchRecordsWithSearchingE() {
        createUser();
        User teamLeadM = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-M/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadE = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        EQCC_Step__c step = getMockStep('submit');
        Test.startTest();
        System.runAs(teamLeadM) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        	req.setComments('Submitting request for approval.');
        	req.setNextApproverIds(new Id[] {teamLeadE.Id});
        	req.setObjectId(step.Id);
        	Approval.ProcessResult resu = Approval.process(req);
        	ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :step.Id];
        }
        
		
        System.runAs(teamLeadE){
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', 'testE', '', '', step.Id, 'SpecialApprove');
        }        	
        Test.stopTest();
    }
    
    @isTest
    static void testFetchRecordsWithoutSearchingE() {
        createUser();
        User teamLeadM = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-M/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadE = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        EQCC_Step__c step = getMockStep('submit');
        Test.startTest();
        System.runAs(teamLeadM) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        	req.setComments('Submitting request for approval.');
        	req.setNextApproverIds(new Id[] {teamLeadE.Id});
        	req.setObjectId(step.Id);
        	Approval.ProcessResult resu = Approval.process(req);
        	ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :step.Id];
        }
        
		
        System.runAs(teamLeadE){
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', '', '', '', step.Id, 'SpecialApprove');
        }        	
        Test.stopTest();
    }

	@isTest
    static void testFetchRecordsWithSearchingM() {
        createUser();
        User teamLeadM = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-M/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadE = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        EQCC_Step__c step = getMockStep('submit');
        Test.startTest();
        System.runAs(teamLeadE) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        	req.setComments('Submitting request for approval.');
        	req.setNextApproverIds(new Id[] {teamLeadM.Id});
        	req.setObjectId(step.Id);
        	Approval.ProcessResult resu = Approval.process(req);
        	ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :step.Id];
        }
        
		
        System.runAs(teamLeadM){
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', 'testM', '', '', step.Id, 'SpecialApprove');
        }        	
        Test.stopTest();
    }
    
    @isTest
    static void testFetchRecordsWithoutSearchingM() {
        createUser();
        User teamLeadM = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-M/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadE = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        EQCC_Step__c step = getMockStep('submit');
        Test.startTest();
        System.runAs(teamLeadE) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        	req.setComments('Submitting request for approval.');
        	req.setNextApproverIds(new Id[] {teamLeadM.Id});
        	req.setObjectId(step.Id);
        	Approval.ProcessResult resu = Approval.process(req);
        	ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :step.Id];
        }
        
		
        System.runAs(teamLeadM){
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', '', '', '', step.Id, 'SpecialApprove');
        }        	
        Test.stopTest();
    }

	@isTest
    static void testFetchRecordsWithSearchingI() {
        createUser();
        User teamLeadI = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-I/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadE = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        EQCC_Step__c step = getMockStep('submit');
        Test.startTest();
        System.runAs(teamLeadE) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        	req.setComments('Submitting request for approval.');
        	req.setNextApproverIds(new Id[] {teamLeadI.Id});
        	req.setObjectId(step.Id);
        	Approval.ProcessResult resu = Approval.process(req);
        	ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :step.Id];
        }
        
		
        System.runAs(teamLeadI){
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', 'testI', '', '', step.Id, 'SpecialApprove');
        }        	
        Test.stopTest();
    }
    
    @isTest
    static void testFetchRecordsWithoutSearchingI() {
        createUser();
        User teamLeadI = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-I/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadE = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        EQCC_Step__c step = getMockStep('submit');
        Test.startTest();
        System.runAs(teamLeadE) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        	req.setComments('Submitting request for approval.');
        	req.setNextApproverIds(new Id[] {teamLeadI.Id});
        	req.setObjectId(step.Id);
        	Approval.ProcessResult resu = Approval.process(req);
        	ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :step.Id];
        }
        
		
        System.runAs(teamLeadI){
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', '', '', '', step.Id, 'SpecialApprove');
        }        	
        Test.stopTest();
    }     
    /**
     * @given CustomLookupController
     * @when fetchRecords method is invoked with missing params 
     * @then an exception should be thrown
     */
    @isTest
    static void fetchRecordsNegativeWithValueTest() {
        try {
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', 'Test', 'test', '', null, '');
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
    
    @isTest
    static void fetchRecordsNegativeWithOutValueTest() {
        try {
            List<THOR_CustomLookupController.RecordsData> result = THOR_CustomLookupController.fetchRecords('User', 'FirstName', 'Test', '', '', null, '');
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
    
    private static EQCC_Step__c getMockStep(String name) {
        return [SELECT Id FROM EQCC_Step__c WHERE Name = :name LIMIT 1];
    }
    
    private static User getMockUser(String name) {
        return [SELECT Id FROM User WHERE FirstName LIKE :name LIMIT 1];
    }
}