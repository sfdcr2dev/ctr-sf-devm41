@isTest
public class EQCCCheckedSheetNavigateController_Test {
    @IsTest
    static void getStepFromNumber() {
        EQCC_Header__c header = new EQCC_Header__c();
        insert header;

        EQCC_Checked_Sheet__c sheet = new EQCC_Checked_Sheet__c();
        sheet.Name = 'something';
        sheet.Form_Type__c = 'Tank_Gauge_Level_Maintenance_Record';
        insert sheet;

        Header_Sheet__c headerSheet = new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheet.Id);
        insert headerSheet;

        EQCC_Step__c step = [SELECT Id, Step_Number__c FROM EQCC_Step__c LIMIT 1];

        Test.startTest();
        EQCC_Step__c me = EQCCCheckedSheetNavigationController.getStepFromNumber(step.Id, ((Integer) step.Step_Number__c));
        Test.stopTest();

        System.assert(me != null);
    }

    @IsTest
    static void getIdOfCurrentStep() {
        EQCC_Header__c header = new EQCC_Header__c();
        insert header;

        EQCC_Checked_Sheet__c sheet = new EQCC_Checked_Sheet__c();
        sheet.Name = 'something';
        sheet.Form_Type__c = 'Tank_Gauge_Level_Maintenance_Record';
        insert sheet;

        Header_Sheet__c headerSheet = new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheet.Id);
        insert headerSheet;

        Test.startTest();
        Id me = EQCCCheckedSheetNavigationController.getIdOfCurrentStep(headerSheet.Id);
        Test.stopTest();

        System.assert(me != null);
    }

    /**
     * @given an EQCC Header
     * @when EQCC Checked Sheet is related to the Header
     * @then a new Header_Sheet__c is created
     */
    @isTest
    static void testCreateEQCCCheckedSheetWithHeader() {
        EQCC_Header__c header = new EQCC_Header__c();
        insert header;
        
        EQCC_Checked_Sheet__c sheet = new EQCC_Checked_Sheet__c(
            Form_Type__c = 'Tank_Gauge_Level_Maintenance_Record',
            Sheet_Code__c = 'CODE'
        );
        
        insert sheet;

        List<Header_Sheet__c> initialHeaderSheets = getHeaderSheets();

        Test.startTest();
        EQCCCheckedSheetNavigationController.associateCheckedSheetToHeader(sheet.Id, header.Id);
        Test.stopTest();

        List<Header_Sheet__c> finalHeaderSheets = getHeaderSheets();

        System.assertEquals(
            initialHeaderSheets.size() + 1,
            finalHeaderSheets.size(),
            'A new Header_Sheet__c should have been created'
        );
    }

    /**
     * @given an EQCC Header
     * @when EQCC Checked Sheet is related to the Header and user has no the right permissions
     * @then no new Header_Sheet__c is created and an exception is thrown
     */
    @isTest
    static void testCreateEQCCCheckedSheetWithHeaderNoPermission() {
        EQCC_Header__c header = new EQCC_Header__c();
        insert header;

        EQCC_Checked_Sheet__c sheet = new EQCC_Checked_Sheet__c(
            Form_Type__c = 'Tank_Gauge_Level_Maintenance_Record',
            Sheet_Code__c = 'CODE'
        );
        
        insert sheet;

        List<Header_Sheet__c> initialHeaderSheets = getHeaderSheets();

        Test.startTest();
        try {
            System.runAs(getReadOnlyUser()) {
                EQCCCheckedSheetNavigationController.associateCheckedSheetToHeader(sheet.Id, header.Id);
                System.assert(false, 'An exception should have been thrown');
            }
        } catch (Exception ex) {
            System.assertEquals(
                'System.AuraHandledException',
                ex.getTypeName(),
                'An exception should have prevented relating the EQCC Checked Sheet to the Header'
            );
        }
        Test.stopTest();

        List<Header_Sheet__c> finalHeaderSheets = getHeaderSheets();

        System.assertEquals(
            initialHeaderSheets.size(),
            finalHeaderSheets.size(),
            'No new Header_Sheet__c should have been created'
        );
    }
    
    /**
     * @given a Header with Equipment and Functional Location and a service to suggest Checked Sheets
     * @when service is invoked
     * @then all suggested Checked Sheets should be retrieved
     */
    @isTest
    static void testSuggestCheckedSheetsFromHeader() {
        createTestData();
        EQCC_Header__c header = new EQCC_Header__c(
            Equipment__c = getEquipmentFromName('Equipment 1').Id,
            FunctionalLocation__c = getFunctionalLocationFromName('funcLocation 1').Id
        );
        insert header;
        
        Test.startTest();
        List<EQCC_Checked_Sheet__c> suggestedSheets = EQCCCheckedSheetNavigationController.retrieveSuggestedCheckedSheets(
            header.Id
        );
        Test.stopTest();
        
        /*System.assertEquals(
            2,
            suggestedSheets.size(),
            'All suggested Checked Sheets should have been returned'
        );*/
    }

    private static List<Header_Sheet__c> getHeaderSheets() {
        return [SELECT Id FROM Header_Sheet__c];
    }

    private static User getReadOnlyUser() {
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Read Only'];
        User readOnlyUser = new User(
            Alias = 'standt',
            Email = 'ReadOnlyUser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'ReadOnlyUser' + DateTime.now().getTime() + '@testorg.com'
        );
        insert readOnlyUser;

        return readOnlyUser;
    }
    
    private static void createTestData() {
        List<Equipment__c> equipments = new List<Equipment__c>();
        for (Integer i = 0; i < 10; i += 2) {
            equipments.add(new Equipment__c(Name = 'Equipment ' + i, Object_Type__c = 'EquipmentObjectType' + i));
            equipments.add(
                new Equipment__c(Name = 'Equipment ' + (i + 1), Object_Type__c = 'EquipmentObjectType' + (i + 1))
            );
        }
        insert equipments;

        List<Functional_Location__c> funcLocations = new List<Functional_Location__c>();
        for (Integer i = 0; i < 10; i += 2) {
            funcLocations.add(
                new Functional_Location__c(Name = 'funcLocation ' + i, Object_Type__c = 'funcLocationObjectType' + i)
            );
            funcLocations.add(
                new Functional_Location__c(
                    Name = 'funcLocation ' + (i + 1),
                    Object_Type__c = 'funcLocationObjectType' + (i + 1)
                )
            );
        }
        insert funcLocations;

        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName
            FROM Checked_Sheet_Pointer__mdt
            LIMIT 1
        ];

        EQCC_Header__c header = new EQCC_Header__c();
        insert header;

        List<EQCC_Checked_Sheet__c> sheets = new List<EQCC_Checked_Sheet__c>();
        for (Integer i = 0; i < 10; i += 2) {
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet Equipment ' + i,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + i
                )
            );
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet Equipment ' + (i + 1),
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + (i + 1)
                )
            );

            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet FL ' + i,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + i
                )
            );
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet FL ' + i + 1,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + (i + 1)
                )
            );
        }
        insert sheets;

        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>();
        for (EQCC_Checked_Sheet__c sheet : sheets) {
            headerSheets.add(new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheet.Id));
        }
        insert headerSheets;
        
        insert new Sheet_Mapping__c(
            Object_Type__c = 'EquipmentObjectType1',
            Form_Code__c = 'SHEETCODE1',
            Group_Task__c = 'Task1',
            Group_Count__c = 'Count1',
            Operation_Text__c = 'OPERATION1'
        );
    }
    
    private static Equipment__c getEquipmentFromName(String equipment) {
        return [SELECT Id FROM Equipment__c WHERE Name = :equipment];
    }
    
    private static Functional_Location__c getFunctionalLocationFromName(String funcLocation) {
        return [SELECT Id FROM Functional_Location__c WHERE Name = :funcLocation];
    }
}