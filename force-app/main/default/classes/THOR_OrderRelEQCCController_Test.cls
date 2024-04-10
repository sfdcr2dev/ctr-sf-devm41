@isTest
public class THOR_OrderRelEQCCController_Test {
    @TestSetup
    static void makeData() {
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given a Order record Id
     * @when getting a list related EQCC_Header and EQCC_Checked_Sheets
     * @then List of EQCC_Headers and related EQCC_Checked_Sheets are returned
     */
    @isTest
    public static void testGetRelatedEQCCs() {
        Order__c relatedOrder = getMockOrder();
        Test.startTest();
        List<HeaderSheetWrapper> actual = THOR_OrderRelatedEQCCController.getRelatedEQCCs(Id.valueOf(relatedOrder.Id));
        Test.stopTest();

        System.assertEquals(1, actual.size(), 'Return should only be one since we inserted only one in the test setup');
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
                List<HeaderSheetWrapper> actual = THOR_OrderRelatedEQCCController.getRelatedEQCCs('');
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
     * @given EQCC Header record Id to delete
     * @when deleteing headers from notification related EQCC
     * @then delete record
     */
    @isTest
    public static void testDeleteEQCCHeader(){
        EQCC_Header__c headerToDelete = getMockHeader();
        Id mockHeaderId = headerToDelete.Id;

        Test.startTest();
            Boolean actual = THOR_OrderRelatedEQCCController.deleteEQCCHeader(String.valueOf(mockHeaderId));
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
            Boolean actual = THOR_OrderRelatedEQCCController.deleteEQCCHeader(String.valueOf('BigFakeRecordId'));
        Test.stopTest();

        System.assertEquals(false, actual, 'Returns false on Exception: record not found or DML error');
    }

    /**
     * @given EQCC Header record Id to delete
     * @when checking if any record was not created manually
     * @then delete record
     */
    @isTest
    public static void testCheckIfManuallyCreated(){
        EQCC_Header__c headerIsGenerated = getMockGeneratedHeader();
        EQCC_Header__c headerIsNotGenerated = getMockHeader();
        Id mockHeaderGeneratedId = headerIsGenerated.Id;
        Id mockHeaderId = headerIsNotGenerated.Id;

        Test.startTest();
            Boolean actualGenerated = THOR_OrderRelatedEQCCController.checkIfManuallyCreated(String.valueOf(mockHeaderGeneratedId));

            Boolean actualNotGenerated = THOR_OrderRelatedEQCCController.checkIfManuallyCreated(String.valueOf(mockHeaderId));
        Test.stopTest();

        System.assertEquals(true, actualNotGenerated, 'Returns true if all was manually created');
        System.assertEquals(false, actualGenerated, 'Returns false if contains a record that was not manually created');
    }


    private static EQCC_Header__c getMockGeneratedHeader(){
        Order__c mockTestOrder = getMockGeneratedOrder();
        return [SELECT Id FROM EQCC_Header__c WHERE Order__c = :mockTestOrder.Id LIMIT 1];
    }

    private static Order__c getMockOrder() {
        return [SELECT Id FROM Order__c WHERE Name = 'Test Order' LIMIT 1];
    }

    private static Order__c getMockGeneratedOrder() {
        return [SELECT Id FROM Order__c WHERE Name = 'Child Test Order' LIMIT 1];
    }

    private static User getMockUser() {
        return [SELECT Id, Email, ProfileId FROM User WHERE Email = 'ReadOnlyUser@testorg.com'];
    }

    private static EQCC_Header__c getMockHeader() {
        Order__c mockTestOrder = getMockOrder();
        return [SELECT Id FROM EQCC_Header__c WHERE Order__c = :mockTestOrder.Id LIMIT 1];
    }
}