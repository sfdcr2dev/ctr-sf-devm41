@isTest
public class THOR_NotifRelatedEQCCController_Test {
    @TestSetup
    static void makeData() {
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given a Notification record Id
     * @when getting a list related EQCC_Header and EQCC_Checked_Sheets
     * @then List of EQCC_Headers and related EQCC_Checked_Sheets are returned
     */
    @isTest
    public static void testGetRelatedEQCCs() {
        Notification__c relatedNotification = getMockNotification();
        Test.startTest();
        List<HeaderSheetWrapper> actual = THOR_NotificationRelatedEQCCController.getRelatedEQCCs(
            Id.valueOf(relatedNotification.Id)
        );
        Test.stopTest();

        System.assert(actual.size() > 0, 'Return should not be 0, it has been inserted');
    }

    /**
     * @given a user who doesn't have record access permission
     * @when getting a list related EQCC_Header and EQCC_Checked_Sheets
     * @then throw Aura Exception
     */
    @isTest
    public static void testGetRelatedEQCCsException() {
        User readOnlyUser = getMockUser();
        System.runAs(readOnlyUser) {
            Test.startTest();
            try {
                List<HeaderSheetWrapper> actual = THOR_NotificationRelatedEQCCController.getRelatedEQCCs('');
            } catch (Exception ex) {
                System.assertEquals(
                    'System.AuraHandledException',
                    ex.getTypeName(),
                    'Aura Exception should be thrown when user access is restricted or bad query'
                );
            }
            Test.stopTest();
        }
    }

    /**
     * @given a EQCC_Header__c Id
     * @when getting a list of EQCC_Checked_Sheet__c related to EQCC_Header_c
     * @then List of EQCC_Checked_Sheet__c are returned
     */
    @isTest
    public static void testGetHeaderRelatedEQCCs() {
        EQCC_Header__c relatedHeader = getMockHeader();
        Test.startTest();
        List<HeaderSheetWrapper> actual = THOR_NotificationRelatedEQCCController.getHeaderRelatedEQCCs(
            Id.valueOf(relatedHeader.Id)
        );
        Test.stopTest();

        System.assert(actual.size() > 0, 'Return should not be 0, it has been inserted');

        System.assertEquals(
            'Test Checked Sheet',
            actual[0].sheets[0].sheet.Name,
            'Should be the name of the mock EQCC_Checked_Sheet__c we inserted in the test setup.'
        );
    }

    /**
     * @given a user who doesn't have record access permission
     * @when getting a list EQCC_Checked_Sheets__c related to EQCC_Header__c
     * @then throw Aura Exception
     */
    @isTest
    public static void testGetHeaderRelatedEQCCsException() {
        EQCC_Header__c relatedHeader = getMockHeader();
        User readOnlyUser = getMockUser();
        System.runAs(readOnlyUser) {
            Test.startTest();
            try {
                List<HeaderSheetWrapper> actual = THOR_NotificationRelatedEQCCController.getHeaderRelatedEQCCs(
                    'null'
                );
            } catch (Exception ex) {
                System.assertEquals(
                    'System.AuraException',
                    ex.getTypeName(),
                    'Aura Exception should be thrown when user access is restricted or bad query'
                );
            }
            Test.stopTest();
        }
    }

    /**
     * @given nothing, this has no args
     * @when getting all list of EQCC_Checked_Sheet__c
     * @then List of all EQCC_Checked_Sheet__c are returned
     */
    @isTest
    public static void testGetEQCCCS() {
        Test.startTest();
        List<EQCC_Checked_Sheet__c> actual = THOR_NotificationRelatedEQCCController.getEQCCCS();
        Test.stopTest();

        System.assert(actual.size() > 0, 'Should not be 0, we have EQCC_Checked_Sheet__c inserted');

        System.assertEquals(
            'Test Checked Sheet',
            actual[0].Name,
            'Mock Checked sheet name should be "Test Checked Sheet"'
        );
    }

    /**
     * @given a user who doesn't have record access permission
     * @when getting a list EQCC_Checked_Sheets__c
     * @then throw Aura Exception
     */
    @isTest
    public static void testGetEQCCCSException() {
        User readOnlyUser = getMockUser();
        System.runAs(readOnlyUser) {
            Test.startTest();
            try {
                List<EQCC_Checked_Sheet__c> actual = THOR_NotificationRelatedEQCCController.getEQCCCS();
            } catch (Exception e) {
                System.assertEquals(
                    'System.AuraHandledException',
                    e.getTypeName(),
                    'Aura Exception should be thrown when user access is restricted or bad query'
                );
            }
            Test.stopTest();
        }
    }

    /**
     * @given Id of checked sheet and id of header
     * @when setting a checked sheets header lookup
     * @then checked sheet header will be set to the header Id we passed
     */
    @isTest
    public static void testSetEQCCHeader() {
        EQCC_Header__c relatedHeader = getMockHeader();
        EQCC_Checked_Sheet__c relatedCheckedSheet = getMockCheckedSheet();
        List<Header_Sheet__c> initialHeaderSheets = getHeaderSheets();

        Test.startTest();
        THOR_NotificationRelatedEQCCController.setEQCCHeader(
            Id.valueOf(relatedCheckedSheet.Id),
            Id.valueOf(relatedHeader.Id)
        );
        Test.stopTest();

        List<Header_Sheet__c> finalHeaderSheets = getHeaderSheets();

        System.assertEquals(
            initialHeaderSheets.size() + 1,
            finalHeaderSheets.size(),
            'A new Header - Checked Sheet should have been created'
        );
    }

    @isTest
    public static void testGetNotificationOrderId(){
        Notification__c mockNotification = getMockNotification();
        Order__c mockOrder = getMockOrder();
        EQCC_Header__c mockHeader = getMockRelatedHeader();

        Test.startTest();
            EQCC_Header__c actual = THOR_NotificationRelatedEQCCController.getNotificationOrderId(String.valueOf(mockHeader.Id));
        Test.stopTest();

        System.assertEquals(mockOrder.Id, actual.Order__c, 'Returned Order ID should match mock Order ID');
        System.assertEquals(mockNotification.Id, actual.Notification__c, 'Returned Notification ID should match mock Notification ID');
    }

    @isTest
    public static void testDeleteManualEQCCHeaderFail(){
        EQCC_Header__c headerToDelete = getMockGeneratedHeader();
        Id mockHeaderId = headerToDelete.Id;

        Test.startTest();
            Boolean actual = THOR_NotificationRelatedEQCCController.deleteManualEQCCHeader(String.valueOf(mockHeaderId));
        Test.stopTest();

        System.assertEquals(false, actual, 'Returns false if contains autogenerated sheets');
    }

    @isTest
    public static void testDeleteManualEQCCHeaderSuccess(){
        EQCC_Header__c headerToDelete = getMockManualHeader();
        Id mockHeaderId = headerToDelete.Id;

        Test.startTest();
            Boolean actual = THOR_NotificationRelatedEQCCController.deleteManualEQCCHeader(String.valueOf(mockHeaderId));
        Test.stopTest();

        System.assertEquals(true, actual, 'Returns true if does not contains autogenerated sheets');
    }

    /**
     * @given a user who doesn't have record access permission
     * @when setting the header lookup on checked sheet
     * @then throw Aura Exception
     */
    @isTest
    public static void testSetEQCCHeaderException() {
        EQCC_Header__c relatedHeader = getMockHeader();
        EQCC_Checked_Sheet__c relatedCheckedSheet = getMockCheckedSheet();
        User readOnlyUser = getMockUser();
        System.runAs(readOnlyUser) {
            Test.startTest();
            try {
                THOR_NotificationRelatedEQCCController.setEQCCHeader('bogusId', 'anotherBogusId');
            } catch (Exception ex) {
                System.assertEquals(
                    'System.AuraHandledException',
                    ex.getTypeName(),
                    'Aura Exception should be thrown when user access is restricted or bad query'
                );
            }
            Test.stopTest();
        }
    }

    /**
     * @given EQCC Header record Id to delete
     * @when deleteing headers from notification related EQCC
     * @then delete record
     */
    @isTest
    public static void testDeleteEQCCHeader(){
        EQCC_Header__c headerToDelete = getMockHeader();
        Id mockHeaderId = headerToDelete.Id;

        Test.startTest();
            Boolean actual = THOR_NotificationRelatedEQCCController.deleteEQCCHeader(String.valueOf(mockHeaderId));
        Test.stopTest();

        System.assertEquals(true, actual, 'Returns true on successful delete');
    }

    /**
     * @given Fake record Id
     * @when deleteing headers from notification related EQCC
     * @then return false to display to user
     */
    @isTest
    public static void testDeleteEQCCHeaderError(){
        Test.startTest();
            Boolean actual = THOR_NotificationRelatedEQCCController.deleteEQCCHeader(String.valueOf('BigFakeRecordId'));
        Test.stopTest();

        System.assertEquals(false, actual, 'Returns false on Exception: record not found or DML error');
    }

    private static Notification__c getMockNotification() {
        return [SELECT Id FROM Notification__c WHERE Name = 'Test Notification' LIMIT 1];
    }

    private static Order__c getMockOrder(){
        return [SELECT Id FROM Order__c WHERE Name = 'Test Order' LIMIT 1];
    }

    private static EQCC_Header__c getMockRelatedHeader(){
        return [SELECT Id FROM EQCC_Header__c WHERE Order__c != null LIMIT 1];
    }

    private static EQCC_Header__c getMockHeader() {
        return [SELECT Id FROM EQCC_Header__c LIMIT 1];
    }

    private static EQCC_Header__c getMockGeneratedHeader(){
        Order__c mockOrder = [SELECT Id FROM Order__c WHERE Name='Child Test Order' LIMIT 1];

        return [SELECT Id FROM EQCC_Header__c WHERE Order__c = :mockOrder.Id];
    }

    private static EQCC_Header__c getMockManualHeader(){
        Order__c mockOrder = getMockOrder();
        return [SELECT Id FROM EQCC_Header__c WHERE Order__c = :mockOrder.Id LIMIT 1];
    }

    private static EQCC_Checked_Sheet__c getMockCheckedSheet() {
        return [SELECT Id FROM EQCC_Checked_Sheet__c WHERE Name = 'Test Checked Sheet' LIMIT 1];
    }

    private static User getMockUser() {
        return [SELECT Id, Email, ProfileId FROM User WHERE Email = 'ReadOnlyUser@testorg.com'];
    }

    private static List<Header_Sheet__c> getHeaderSheets() {
        return [SELECT Id FROM Header_Sheet__c];
    }
}