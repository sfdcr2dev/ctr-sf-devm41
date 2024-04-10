@isTest
public class THOR_UserTest {

    @TestSetup
    static void makeData() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
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
            Form_Questions__c = 1
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
        User workingTeam = new User(
            FirstName = 'test',
            LastName = 'user',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' LIMIT 1].Id
        );
        insert workingTeam;
        
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
        
        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        User teamLeadI = new User(
            FirstName = 'testI',
            LastName = 'userI',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
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
        
        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        User teamLeadE = new User(
            FirstName = 'testE',
            LastName = 'userE',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
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
        
        User discipline = new User(
            FirstName = 'testD',
            LastName = 'userD',
            Email = uniqueName + 'CoENTS@test' + orgId + '.org',
            Username = uniqueName + 'CoENTS@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = 'E'+uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%ENTS Working Team-ENTS%' LIMIT 1]
            .Id
        );
        insert discipline;
    }
        
    
    @isTest
    public static void testPositive() {
        EQCC_Step__c step = getMockStep('submit');
        createUser();
        User teamLeadM = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadI = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-I/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        User teamLeadE = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' 
                          AND isActive = TRUE LIMIT 1];
        
        User discipline = [SELECT Id FROM User
            			  WHERE UserRole.Name LIKE '%ENTS Working Team-ENTS%' 
                          AND isActive = TRUE LIMIT 1];
        Test.startTest();
        	//THOR_UserController.getRoleName();
            System.runAs(teamLeadM) {
                THOR_UserController.getRoleName();
                THOR_UserController.findRecords('testM');
            }
        	System.runAs(teamLeadI) {
                THOR_UserController.getRoleName();
                THOR_UserController.findRecords('testI');
            }
        	System.runAs(teamLeadE) {
                THOR_UserController.getRoleName();
                THOR_UserController.findRecords('testE');
            }
        	System.runAs(discipline) {
                THOR_UserController.getRoleName();
                THOR_UserController.findRecords('testD');
            }
        	THOR_UserController.isSubmited(step.Id);
        Test.stopTest();
    }
    
    private static EQCC_Step__c getMockStep(String name) {
        return [SELECT Id FROM EQCC_Step__c WHERE Name = :name LIMIT 1];
    }
}