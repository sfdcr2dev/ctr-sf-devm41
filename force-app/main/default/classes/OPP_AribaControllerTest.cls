@isTest
public class OPP_AribaControllerTest {

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            if (request.getEndpoint().startsWithIgnoreCase('https://api.ariba.com/v2/oauth/token')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "timeUpdated": 1622965950895, "access_token": "45a0ffd4-af29-4baa-8efa-027d896cf4ae", "refresh_token": "4e7feed3-f7a1-4252-8202-5c6a45344ab2", "token_type": "bearer", "scope": null, "expires_in": 1440 }');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().startsWithIgnoreCase('https://openapi.ariba.com/api/approval/v1/prod/pendingApprovables')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('[ { "uniqueName": "PR9101", "documentType": "ariba.purchasing.core.Requisition", "description": "Test PR 1", "assignedDate": "2021-05-25", "approver": "phongsan", "email": "sfdc-thaioil.r2@roundtwosolutions.com.dev5", "fullURL": "http://thaioil-T.procurement.ariba.com/ad/webjumper?itemID=ADeWAOVDxskLrLn&awcharset=UTF-8", "attachments": [] }, { "uniqueName": "PR9103", "documentType": "ariba.purchasing.core.Requisition", "description": "Test PR 3", "assignedDate": "2021-05-20", "approver": "phongsan", "email": "sfdc-thaioil.r2@roundtwosolutions.com.dev5", "fullURL": "http://thaioil-T.procurement.ariba.com/ad/webjumper?itemID=ADeWAOVDxuwoCtM&awcharset=UTF-8", "attachments": [] }, { "uniqueName": "PR9104", "documentType": "ariba.purchasing.core.Requisition", "description": "Test PR 4", "assignedDate": "2021-05-20", "approver": "phongsan", "email": "nobody-sfdc-thaioil.r2@roundtwosolutions.com.dev5", "fullURL": "http://thaioil-T.procurement.ariba.com/ad/webjumper?itemID=ADeWAOVDxlD3Hkc&awcharset=UTF-8", "attachments": [] } ]');
                response.setStatusCode(200);
                return response;
            } else {
                System.assert(false, 'unexpected endpoint ' + request.getEndpoint());
                return null;
            }
        }
    }

    @TestSetup
    static void setup() {
        OPP_Application__c oppApplication = new OPP_Application__c();
        oppApplication.Name = 'e-Procurement (Ariba)';
        insert oppApplication;

        OPPIntegration__c oppIntegration = new OPPIntegration__c();
        oppIntegration.Ariba_Application_Name__c = 'e-Procurement (Ariba)';
        oppIntegration.Ariba_Password_Adapter__c = 'PasswordAdapter';
        oppIntegration.Ariba_Authorization_Endpoint__c = 'https://api.ariba.com/v2/oauth/token';
        oppIntegration.Ariba_Pending_Approvables_Endpoint__c = 'https://openapi.ariba.com/api/approval/v1/prod/pendingApprovables';
        oppIntegration.Ariba_Realm__c = 'thaioil-t';
        oppIntegration.Ariba_Application_Key__c = '0QcCPTXD91RM2zydv5gW9pr9ETHUrbZd';
        oppIntegration.Ariba_Client_Id__c = '1423fc65-7339-498c-904d-e8f846e40b5c';
        oppIntegration.Ariba_Client_Secret__c = 'g3vt48OJ4sYbkrKNNUUfYx8aAdJcpwH4';
        oppIntegration.Ariba_Grant_Type__c = 'openapi_2lo';
        insert oppIntegration;
    }

    @isTest
    static void testSyncNotification() {

        List<OPP_Notification__c> insertList = new List<OPP_Notification__c>();
        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
        OPP_Application__c oppApplication = [SELECT Id FROM OPP_Application__c WHERE Name = :oppIntegration.Ariba_Application_Name__c LIMIT 1];

        OPP_Notification__c oppNotification1_Init = new OPP_Notification__c();
        oppNotification1_Init.ApplicationName__c = 'e-Procurement (Ariba)';
        oppNotification1_Init.Application__c = oppApplication.Id;
        oppNotification1_Init.Subject__c = 'Test PR 1';
        oppNotification1_Init.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification1_Init.User__c = UserInfo.getUserId();
        oppNotification1_Init.ReferenceID__c = 'PR9101';
        oppNotification1_Init.Status__c = 'New';
        insertList.add(oppNotification1_Init);

        OPP_Notification__c oppNotification2_Init = new OPP_Notification__c();
        oppNotification2_Init.ApplicationName__c = 'e-Procurement (Ariba)';
        oppNotification2_Init.Application__c = oppApplication.Id;
        oppNotification2_Init.Subject__c = 'Test PR 2';
        oppNotification2_Init.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification2_Init.User__c = UserInfo.getUserId();
        oppNotification2_Init.ReferenceID__c = 'PR9102';
        oppNotification2_Init.Status__c = 'New';
        insertList.add(oppNotification2_Init);

        insert insertList;

        //User currentUser = [SELECT Id, Title FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        //currentUser.Title = 'phongsan';
        //update currentUser;

        Test.setMock(HttpCalloutMock.class, new OPP_AribaControllerTest.Mock());

        Test.startTest();
        OPP_AribaController.syncNotifications();
        Test.stopTest();

        List<OPP_Notification__c> oppNotifications = [
            SELECT
                Id,
                Subject__c,
                Username__c,
                ReferenceID__c,
                Status__c
            FROM OPP_Notification__c
            WHERE
                Application__c = :oppApplication.Id
                AND User__c = :UserInfo.getUserId()
        ];

        OPP_Notification__c oppNotification1 = null;
        OPP_Notification__c oppNotification2 = null;
        OPP_Notification__c oppNotification3 = null;
        OPP_Notification__c oppNotification4 = null;
        for (OPP_Notification__c oppNotification : oppNotifications) {
            if (oppNotification.Subject__c == 'Test PR 1') {
                oppNotification1 = oppNotification;
            }
            if (oppNotification.Subject__c == 'Test PR 2') {
                oppNotification2 = oppNotification;
            }
            if (oppNotification.Subject__c == 'Test PR 3') {
                oppNotification3 = oppNotification;
            }
            if (oppNotification.Subject__c == 'Test PR 4') {
                oppNotification4 = oppNotification;
            }
        }

        /*System.assertNotEquals(null, oppNotification1);
        System.assertEquals('New', oppNotification1.Status__c);
        System.assertNotEquals(null, oppNotification2);
        System.assertEquals('Done', oppNotification2.Status__c);
        System.assertNotEquals(null, oppNotification3);
        System.assertEquals('New', oppNotification3.Status__c);
        System.assertEquals(null, oppNotification4);*/
    }

//    @isTest
//    static void testSyncNotification_IsNotAribaUser() {
//        //User currentUser = [SELECT Id, Title FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
//        //currentUser.Title = '';
//        //update currentUser;
//
//        Test.setMock(HttpCalloutMock.class, new OPP_AribaControllerTest.Mock());
//
//        Test.startTest();
//        OPP_AribaController.syncNotifications();
//        Test.stopTest();
//
//        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
//        OPP_Application__c oppApplication = [SELECT Id FROM OPP_Application__c WHERE Name = :oppIntegration.Ariba_Application_Name__c LIMIT 1];
//        List<OPP_Notification__c> oppNotifications = [
//            SELECT
//                Id,
//                Subject__c,
//                Username__c,
//                ReferenceID__c,
//                Status__c
//            FROM OPP_Notification__c
//            WHERE
//                Application__c = :oppApplication.Id
//                AND User__c = :UserInfo.getUserId()
//        ];
//
//        System.assertEquals(0, oppNotifications.size());
//    }

    @isTest
    static void testSyncNotification_WithOptionDisableCheckEmailComparison() {

        List<OPP_Notification__c> insertList = new List<OPP_Notification__c>();
        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
        oppIntegration.Ariba_Disable_Check_Email_Comparison__c = true;
        insert oppIntegration;

        OPP_Application__c oppApplication = [SELECT Id FROM OPP_Application__c WHERE Name = :oppIntegration.Ariba_Application_Name__c LIMIT 1];

        OPP_Notification__c oppNotification1_Init = new OPP_Notification__c();
        oppNotification1_Init.ApplicationName__c = 'e-Procurement (Ariba)';
        oppNotification1_Init.Application__c = oppApplication.Id;
        oppNotification1_Init.Subject__c = 'Test PR 1';
        oppNotification1_Init.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification1_Init.User__c = UserInfo.getUserId();
        oppNotification1_Init.ReferenceID__c = 'PR9101';
        oppNotification1_Init.Status__c = 'New';
        insertList.add(oppNotification1_Init);

        OPP_Notification__c oppNotification2_Init = new OPP_Notification__c();
        oppNotification2_Init.ApplicationName__c = 'e-Procurement (Ariba)';
        oppNotification2_Init.Application__c = oppApplication.Id;
        oppNotification2_Init.Subject__c = 'Test PR 2';
        oppNotification2_Init.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification2_Init.User__c = UserInfo.getUserId();
        oppNotification2_Init.ReferenceID__c = 'PR9102';
        oppNotification2_Init.Status__c = 'New';
        insertList.add(oppNotification2_Init);

        insert insertList;

        User currentUser = [SELECT Id, Title FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        currentUser.Title = 'phongsan';
        update currentUser;

        Test.setMock(HttpCalloutMock.class, new OPP_AribaControllerTest.Mock());

        Test.startTest();
        OPP_AribaController.syncNotifications();
        Test.stopTest();

        List<OPP_Notification__c> oppNotifications = [
            SELECT
                Id,
                Subject__c,
                Username__c,
                ReferenceID__c,
                Status__c
            FROM OPP_Notification__c
            WHERE
                Application__c = :oppApplication.Id
                AND User__c = :UserInfo.getUserId()
        ];

        OPP_Notification__c oppNotification1 = null;
        OPP_Notification__c oppNotification2 = null;
        OPP_Notification__c oppNotification3 = null;
        OPP_Notification__c oppNotification4 = null;
        for (OPP_Notification__c oppNotification : oppNotifications) {
            if (oppNotification.Subject__c == 'Test PR 1') {
                oppNotification1 = oppNotification;
            }
            if (oppNotification.Subject__c == 'Test PR 2') {
                oppNotification2 = oppNotification;
            }
            if (oppNotification.Subject__c == 'Test PR 3') {
                oppNotification3 = oppNotification;
            }
            if (oppNotification.Subject__c == 'Test PR 4') {
                oppNotification4 = oppNotification;
            }
        }

        System.assertNotEquals(null, oppNotification1);
        System.assertEquals('New', oppNotification1.Status__c);
        System.assertNotEquals(null, oppNotification2);
        System.assertEquals('Done', oppNotification2.Status__c);
        System.assertNotEquals(null, oppNotification3);
        System.assertEquals('New', oppNotification3.Status__c);
        System.assertNotEquals(null, oppNotification4);
        System.assertEquals('New', oppNotification4.Status__c);
    }

    @isTest
    static void testFetchPendingApprovables() {
        List<OPP_Notification__c> insertList = new List<OPP_Notification__c>();
        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
        oppIntegration.Ariba_Disable_Check_Email_Comparison__c = true;
        insert oppIntegration;

        OPP_Application__c oppApplication = [SELECT Id FROM OPP_Application__c WHERE Name = :oppIntegration.Ariba_Application_Name__c LIMIT 1];

        OPP_Notification__c oppNotification1_Init = new OPP_Notification__c();
        oppNotification1_Init.ApplicationName__c = 'e-Procurement (Ariba)';
        oppNotification1_Init.Application__c = oppApplication.Id;
        oppNotification1_Init.Subject__c = 'Test PR 1';
        oppNotification1_Init.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification1_Init.User__c = UserInfo.getUserId();
        oppNotification1_Init.ReferenceID__c = 'PR9101';
        oppNotification1_Init.Status__c = 'New';
        insertList.add(oppNotification1_Init);

        OPP_Notification__c oppNotification2_Init = new OPP_Notification__c();
        oppNotification2_Init.ApplicationName__c = 'e-Procurement (Ariba)';
        oppNotification2_Init.Application__c = oppApplication.Id;
        oppNotification2_Init.Subject__c = 'Test PR 2';
        oppNotification2_Init.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification2_Init.User__c = UserInfo.getUserId();
        oppNotification2_Init.ReferenceID__c = 'PR9102';
        oppNotification2_Init.Status__c = 'New';
        insertList.add(oppNotification2_Init);

        insert insertList;

        User currentUser = [SELECT Id, Title FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        currentUser.Title = 'phongsan';
        update currentUser;

        Test.setMock(HttpCalloutMock.class, new OPP_AribaControllerTest.Mock());

        Test.startTest();
        List<OPP_AribaController.Approvable> approvables = OPP_AribaController.fetchPendingApprovables('phongsan');
        Test.stopTest();

        System.assertEquals('PR9101', approvables[0].uniqueName);
        System.assertEquals('PR9103', approvables[1].uniqueName);
        System.assertEquals('PR9104', approvables[2].uniqueName);
    }
}