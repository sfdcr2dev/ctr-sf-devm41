/**
 * @author Oktana
 * @description test class for HeaderSheetHandler
 */
@isTest
public with sharing class HeaderSheetHandlerTest {
    @testSetup
    static void setup() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName
            FROM Checked_Sheet_Pointer__mdt
            WHERE DeveloperName = 'Tank_Gauge_Level_Maintenance_Record'
            LIMIT 1
        ];

        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>();

        Order__c order = new Order__c();
        insert order;
        List<EQCC_Header__c> headersWithOrder = new List<EQCC_Header__c>();
        for (Integer i = 0; i < 5; i++) {
            headersWithOrder.add(new EQCC_Header__c(Order__c = order.Id));
        }
        insert headersWithOrder;

        List<EQCC_Checked_Sheet__c> sheets = new List<EQCC_Checked_Sheet__c>();
        for (Integer i = 0; i < 5; i++) {
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Status__c = Constants.CHECKED_SHEETS.STATUS_DRAFT,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'CODE'
                )
            );
        }
        insert sheets;

        Integer i = 0;
        for (EQCC_Header__c header : headersWithOrder) {
            headerSheets.add(new Header_Sheet__c(Header__c = headersWithOrder.get(i).Id, Sheet__c = sheets.get(i).Id));
            i++;
        }
        insert headerSheets;

        List<EQCC_Header__c> headers = new List<EQCC_Header__c>();

        for (i = 0; i < 5; i++) {
            headers.add(new EQCC_Header__c());
        }
        insert headers;

        List<EQCC_Checked_Sheet__c> draftSheets = new List<EQCC_Checked_Sheet__c>();
        for (i = 0; i < 5; i++) {
            draftSheets.add(
                new EQCC_Checked_Sheet__c(
                    Status__c = Constants.CHECKED_SHEETS.STATUS_DRAFT,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'CODE'
                )
            );
        }
        insert draftSheets;

        i = 0;
        for (EQCC_Header__c header : headers) {
            headerSheets.add(
                new Header_Sheet__c(
                    Header__c = header.Id,
                    Sheet__c = draftSheets.get(i).Id,
                    isManuallyCreated__c = true
                )
            );
            i++;
        }
        upsert headerSheets;
        
        
    }
    @isTest
    static void testManuallyCreatedEQCCCountFilter() {
       HeaderSheetHandler.getManuallyCreatedEQCCCountFilter(new Map<String, String>{
                'Notification_Number__c' => 'Notification_Number__c',
                'Notification_Type__c' => 'Notification_Type__c',
                'Functional_Location__c' => 'Functional_Location__c',
                'Create_Date_From__c' => '2021-07-29',
                'Create_Date_To__c' => '2021-07-29',
                'Description__c' => 'Description__c',
                'Priority__c' => 'Priority__c',
                'Main_Work_Center__c' => 'Main_Work_Center__c',
                'Location__c' => 'Location__c',
                'Plant_Section__c' => 'Plant_Section__c',
                'Maintenance_Plant__c' => 'Maintenance_Plant__c',
                'Requester__c' => 'Requester__c',
                'User__c' => UserInfo.getUserId()
            });
    }
    
    @isTest
    static void testgetInProgressEQCCCountFilter() {
       HeaderSheetHandler.getInProgressEQCCCountFilter(new Map<String, String>{
                'Notification_Number__c' => 'Notification_Number__c',
                'Notification_Type__c' => 'Notification_Type__c',
                'Functional_Location__c' => 'Functional_Location__c',
                'Create_Date_From__c' => '2021-07-29',
                'Create_Date_To__c' => '2021-07-29',
                'Description__c' => 'Description__c',
                'Priority__c' => 'Priority__c',
                'Main_Work_Center__c' => 'Main_Work_Center__c',
                'Location__c' => 'Location__c',
                'Plant_Section__c' => 'Plant_Section__c',
                'Maintenance_Plant__c' => 'Maintenance_Plant__c',
                'Requester__c' => 'Requester__c',
                'User__c' => UserInfo.getUserId()
            });
    }

	@isTest
    static void testManuallyCreatedEQCCFilter() {
       HeaderSheetHandler.getManuallyCreatedEQCCFilter(new Map<String, String>{
                'Notification_Number__c' => 'Notification_Number__c',
                'Notification_Type__c' => 'Notification_Type__c',
                'Functional_Location__c' => 'Functional_Location__c',
                'Create_Date_From__c' => '2021-07-29',
                'Create_Date_To__c' => '2021-07-29',
                'Description__c' => 'Description__c',
                'Priority__c' => 'Priority__c',
                'Main_Work_Center__c' => 'Main_Work_Center__c',
                'Location__c' => 'Location__c',
                'Plant_Section__c' => 'Plant_Section__c',
                'Maintenance_Plant__c' => 'Maintenance_Plant__c',
                'Requester__c' => 'Requester__c',
                'User__c' => UserInfo.getUserId()
            });
    }
    @isTest
    static void testgetInProgressHeaderSheetsFilter() {
       HeaderSheetHandler.getInProgressEQCCFilter(new Map<String, String>{
                'Notification_Number__c' => 'Notification_Number__c',
                'Notification_Type__c' => 'Notification_Type__c',
                'Functional_Location__c' => 'Functional_Location__c',
                'Create_Date_From__c' => '2021-07-29',
                'Create_Date_To__c' => '2021-07-29',
                'Description__c' => 'Description__c',
                'Priority__c' => 'Priority__c',
                'Main_Work_Center__c' => 'Main_Work_Center__c',
                'Location__c' => 'Location__c',
                'Plant_Section__c' => 'Plant_Section__c',
                'Maintenance_Plant__c' => 'Maintenance_Plant__c',
                'Requester__c' => 'Requester__c',
                'User__c' => UserInfo.getUserId()
            });
    }
    /**
     * @given manually create EQCC
     * @when service to retrieve manually create EQCC is invoked
     * @then all EQCC are returned
     */
   // @isTest
    //static void testManuallyCreatedEQCC() {
      //  Test.startTest();
       // List<HeaderSheetWrapper> eqcc = HeaderSheetHandler.getManuallyCreatedEQCC(0);
       // Test.stopTest();

      //  System.assertEquals(5, eqcc.size(), 'All manually created EQCC should have been returned');
   // }
		
    /**
     * @given manually create EQCC
     * @when service to retrieve manually create EQCC count is invoked
     * @then the full list size of eqcc manually created is retrieved
     */
   // @isTest
    //static void testManuallyCreatedEQCCCount() {
       // List<HeaderSheetWrapper> eqcc = HeaderSheetHandler.getManuallyCreatedEQCC(0);
       // Test.startTest();
       // Integer count = HeaderSheetHandler.getManuallyCreatedEQCCCount();
       // Test.stopTest();

//System.assertEquals(eqcc.size(), count, 'The retrieved count is different than the full list size');
    //}

    /**
     * @given In Progres EQCC
     * @when service to retrieve In Progress EQCC is invoked
     * @then all EQCC are returned
     */
    //@isTest
    //static void testInProgressEQCC() {
       // Test.startTest();
        //List<HeaderSheetWrapper> eqcc = HeaderSheetHandler.getInProgressEQCC(0);
       // Test.stopTest();

//        System.assertEquals(5, eqcc.size(), 'All In Progress EQCC should have been returned');
   // }

    /**
     * @given In Progres EQCC
     * @when service to retrieve In Progress EQCC count is invoked
     * @then the full list size of eqcc in progress is retrieved
     */
   // @isTest
    //static void testInProgressEQCCCount() {
       // List<HeaderSheetWrapper> eqcc = HeaderSheetHandler.getInProgressEQCC(0);
        //Test.startTest();
       // Integer count = HeaderSheetHandler.getInProgressEQCCCount();
       // Test.stopTest();

       // System.assertEquals(eqcc.size(), count, 'The retrieved count is different than the full list size');
    //}

    /**
     * @given an EQCC Step related to a Header Sheet an a service to update the Step percentage
     * @when the service is invoked
     * @then the Step percentage is updated
     */
    @isTest
    static void testUpdateStepPercentage() {
        Header_Sheet__c headerSheet = getHeaderSheet();
        EQCC_Step__c step = new EQCC_Step__c(
            Header_Sheet__c = headerSheet.Id,
            Step_Number__c = 1,
            Is_Current__c = true,
            Form_Code__c = 'ENIM-QFR-401'
        );
        insert step;

        Test.startTest();
        HeaderSheetHandler.updateStepPercentage(step.Id, '50');
        Test.stopTest();

        EQCC_Step__c updatedStep = getStepById(step.Id);

        //System.assertEquals(50, updatedStep.Percentage__c, 'Step percentage should have been updated');
    }

    /**
     * @given an EQCC Step related to a Header Sheet an a service to update the Header Sheet Requester
     * @when the service is invoked
     * @then the Header Sheet Requester is updated
     */
    @isTest
    static void testUpdateHeaderSheetRequester() {
        Header_Sheet__c headerSheet = getHeaderSheet();
        EQCC_Step__c step = new EQCC_Step__c(
            Header_Sheet__c = headerSheet.Id,
            Step_Number__c = 1,
            Is_Current__c = true,
            Form_Code__c = 'ENIM-QFR-401'
        );
        insert step;

        Test.startTest();
        HeaderSheetHandler.updateHeaderSheetRequester(step.Id);
        Test.stopTest();

        Header_Sheet__c updatedHeaderSheet = getHeaderSheetById(headerSheet.Id);

        //System.assertEquals(
            //UserInfo.getName(),
           // updatedHeaderSheet.Requester__c,
            //Header Sheet Requester should have been updated'
       // );
        //System.assertEquals(
            //UserInfo.getUserId(),
           // updatedHeaderSheet.RequesterId__c,
            //'Header Sheet Requester should have been updated'
        //);
    }

    /**
     * @given an existing Header Sheet
     * @when the Status is updated to Approved
     * @then the Header Sheet Closed Date is updated
     */
    @isTest
    static void testHandleStatusUpdatedApproved() {
        Header_Sheet__c headerSheet = getHeaderSheet();
        headerSheet.Status__c = Constants.CHECKED_SHEETS.STATUS_APPROVED;

        Test.startTest();
        update headerSheet;
        Test.stopTest();

        Header_Sheet__c updatedHeaderSheet = getHeaderSheetById(headerSheet.Id);
        System.assertEquals(
            System.today(),
            updatedHeaderSheet.Closed_Date__c, 
            'Header Sheet Closed Date should have been updated'
        );
    }

    /**
     * @given an existing Header Sheet
     * @when the Status is updated to Rejected
     * @then the Header Sheet Closed Date is updated
     */
    @isTest
    static void testHandleStatusUpdatedRejected() {
        Header_Sheet__c headerSheet = getHeaderSheet();
        headerSheet.Status__c = Constants.CHECKED_SHEETS.STATUS_REJECTED;

        Test.startTest();
        update headerSheet;
        Test.stopTest();

        Header_Sheet__c updatedHeaderSheet = getHeaderSheetById(headerSheet.Id);
        System.assertEquals(
            System.today(),
            updatedHeaderSheet.Closed_Date__c,
            'Header Sheet Closed Date should have been updated'
        );
    }

    /**
     * @given an existing Header Sheet
     * @when the Status is updated to a different value that Approved or Rejected
     * @then the Header Sheet Closed Date is not updated
     */
    @isTest
    static void testHandleStatusUpdatedNotApprovedOrRejected() {
        Header_Sheet__c headerSheet = getHeaderSheet();
        headerSheet.Status__c = Constants.CHECKED_SHEETS.STATUS_DRAFT;

        Test.startTest();
        update headerSheet;
        Test.stopTest();

        Header_Sheet__c updatedHeaderSheet = getHeaderSheetById(headerSheet.Id);
        System.assertEquals(
            null,
            updatedHeaderSheet.Closed_Date__c,
            'Header Sheet Closed Date should not have been updated'
        );
    }

    /**
     * @given an EQCC Step related to a Header Sheet an a service to update the Header Sheet percentage
     * @when the service is invoked
     * @then the Header Sheet percentage is updated
     */
    @isTest
    static void testRejectStepAndHeaderSheet() {
        Header_Sheet__c headerSheet = getHeaderSheet();
        EQCC_Step__c step = new EQCC_Step__c(
            Header_Sheet__c = headerSheet.Id,
            Step_Number__c = 1,
            Is_Current__c = true,
            Form_Code__c = 'ENIM-QFR-401'
        );
        insert step;

        Test.startTest();
        HeaderSheetHandler.rejectStepAndHeaderSheet(step.Id, 'Needs Revision');
        Test.stopTest();

        EQCC_Step__c updatedStep = getStepById(step.Id);
        Header_Sheet__c updatedHeaderSheet = getHeaderSheetById(headerSheet.Id);

        System.assertEquals(
            Constants.CHECKED_SHEETS.STATUS_REJECTED,
            updatedStep.Status__c,
            'Step should have been rejected'
        );

        System.assertEquals(
            Constants.CHECKED_SHEETS.STATUS_REJECTED,
            updatedHeaderSheet.Status__c,
            'Header Sheet should have been rejected'
        );

        System.assertEquals(
            'Needs Revision',
            updatedHeaderSheet.Rejection_Reason__c,
            'Rejection Reason should have been populated'
        );
    }

    private static List<Header_Sheet__c> getManuallyCreatedEQCC() {
        return [
            SELECT Id, Header__c, Sheet__c, isManuallyCreated__c
            FROM Header_Sheet__c
            WHERE isManuallyCreated__c = TRUE AND Header__r.Notification__c = NULL AND Header__r.Order__c = NULL
            WITH SECURITY_ENFORCED
        ];
    }

    private static List<Header_Sheet__c> getInProgressEQCC() {
        return [
            SELECT Id, Header__c, Sheet__c, isManuallyCreated__c
            FROM Header_Sheet__c
            WHERE
                Sheet__r.Status__c != :Constants.CHECKED_SHEETS.STATUS_APPROVED
                AND Sheet__r.Status__c != :Constants.CHECKED_SHEETS.STATUS_REJECTED
            WITH SECURITY_ENFORCED
        ];
    }

    private static Header_Sheet__c getHeaderSheet() {
        return [SELECT Id, Percentage__c FROM Header_Sheet__c WITH SECURITY_ENFORCED LIMIT 1];
    }

    private static Header_Sheet__c getHeaderSheetById(Id headerSheetId) {
        return [
            SELECT Id, Percentage__c, Closed_Date__c, Status__c, Rejection_Reason__c, Requester__c, RequesterId__c
            FROM Header_Sheet__c
            WHERE Id = :headerSheetId
            WITH SECURITY_ENFORCED
        ];
    }

    private static EQCC_Step__c getStepById(Id stepId) {
        return [SELECT Id, Status__c, Percentage__c FROM EQCC_Step__c WHERE Id = :stepId WITH SECURITY_ENFORCED];
    }
}