@isTest
public class OPP_NotificationTest {
    
    @TestSetup
    static void setup(){
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Application 1';
        insert oppApplication1;
        
        OPP_Notification__c oppNoti1 = new OPP_Notification__c();
        oppNoti1.Application__c = oppApplication1.Id;
        oppNoti1.Subject__c = 'Application 1: Notification 1';
        oppNoti1.Description__c = 'Application 1: Notification 1 Description';
        oppNoti1.Requester__c = 'Application 1: Requester 1';
        //oppNoti1.User__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNoti1.URL__c = 'https://login.salesforce.com';
        oppNoti1.Event__c = 'Action';
        oppNoti1.ReferenceID__c = 'APP1-00001';
        oppNoti1.Status__c = 'New';
        insert oppNoti1;

        OPP_Notification__c oppNoti2 = new OPP_Notification__c();
        oppNoti2.Application__c = oppApplication1.Id;
        oppNoti2.Subject__c = 'Application 2: Notification 2';
        oppNoti2.Description__c = 'Application 1: Notification 1 Description';
        oppNoti2.Requester__c = 'Application 1: Requester 1';
        //oppNoti2.User__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNoti2.URL__c = 'https://login.salesforce.com';
        oppNoti2.Event__c = 'Action';
        oppNoti2.ReferenceID__c = 'APP1-00001';
        oppNoti2.Status__c = 'New';
        insert oppNoti2;

    }

    @isTest
    static void testDoPost() {
        User user = [SELECT Username FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Application 1';
        insert oppApplication1;

        OPP_Application__c oppApplication2 = new OPP_Application__c();
        oppApplication2.Name = 'Application 2';
        insert oppApplication2;

        List<OPP_Notification.Input> notifications = new List<OPP_Notification.Input>();
        OPP_Notification.Input input1 = new OPP_Notification.Input();
        input1.api_id = '1';
        input1.application_id = oppApplication1.Id;
        input1.subject = 'Application 1: Notification 1';
        input1.description = 'Application 1: Notification 1 Description';
        input1.requester = 'Application 1: Requester 1';
        input1.users = user.Username;
        input1.url = 'https://login.salesforce.com';
        input1.event_code = 'Action';
        input1.reference_id = 'APP1-00001';
        input1.status = 'New';
        notifications.add(input1);

        OPP_Notification.Input input2 = new OPP_Notification.Input();
        input2.api_id = '1';
        input2.application_id = oppApplication2.Id;
        input2.subject = 'Application 2: Notification 1';
        input2.description = 'Application 2: Notification 1 Description';
        input2.requester = 'Application 2: Requester 1';
        input2.users = user.Username;
        input2.url = 'https://login.salesforce.com';
        input2.event_code = 'Action';
        input2.reference_id = 'APP2-00001';
        input2.status = 'New';
        notifications.add(input2);

        OPP_Notification.Input input3 = new OPP_Notification.Input();
        input3.api_id = '2';
        input3.application_id = oppApplication2.Id;
        input3.subject = 'Application 2: Notification 2';
        input3.description = 'Application 2: Notification 2 Description';
        input3.requester = 'Application 2: Requester 1';
        input3.users = user.Username;
        input3.url = 'https://login.salesforce.com';
        input3.event_code = 'Action';
        input3.reference_id = 'APP2-00002';
        input3.status = 'New';
        notifications.add(input3);

        OPP_Notification.Input input4 = new OPP_Notification.Input();
        input4.api_id = '1';
        input4.application_id = 'a1U1s000000aCJZEA2';
        input4.subject = 'Application 3: Notification 1';
        input4.description = 'Application 3: Notification 1 Description';
        input4.requester = 'Application 3: Requester 1';
        input4.users = user.Username;
        input4.url = 'https://login.salesforce.com';
        input4.event_code = 'Action';
        input4.reference_id = 'APP3-00001';
        input4.status = 'New';
        notifications.add(input4);

        OPP_Notification.Input input5 = new OPP_Notification.Input();
        input5.api_id = '1';
        input5.application_id = oppApplication1.Id;
        input5.subject = 'Application 1: Notification 2';
        input5.description = 'Application 1: Notification 2 Description';
        input5.requester = 'Application 1: Requester 1';
        input5.users = 'nobody-sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        input5.url = 'https://login.salesforce.com';
        input5.event_code = 'Action';
        input5.reference_id = 'APP1-00002';
        input5.status = 'New';
        notifications.add(input5);

        OPP_Notification.Input input6 = new OPP_Notification.Input();
        input6.api_id = '1';
        input6.application_id = oppApplication1.Id;
        input6.subject = 'Application 1: Notification 3 Too Long Subject .............................................................................................................................................................................................................................................................';
        input6.description = 'Application 1: Notification 3 Description';
        input6.requester = 'Application 1: Requester 1';
        input6.users = user.Username;
        input6.url = 'https://login.salesforce.com';
        input6.event_code = 'Action';
        input6.reference_id = 'APP1-00003';
        input6.status = 'New';
        notifications.add(input6);
        
        

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Notification';
        restRequest.httpMethod = 'POST';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Notification.Output output = OPP_Notification.doPost(notifications);

        System.assertEquals(true, output.notifications[0].isCompleted);
        System.assertEquals('APP1-00001', output.notifications[0].refObject.reference_id);
        System.assertEquals(true, output.notifications[1].isCompleted);
        System.assertEquals('APP2-00001', output.notifications[1].refObject.reference_id);
        System.assertEquals(true, output.notifications[2].isCompleted);
        System.assertEquals('APP2-00002', output.notifications[2].refObject.reference_id);
        System.assertEquals(false, output.notifications[3].isCompleted);
        System.assertEquals('APP3-00001', output.notifications[3].refObject.reference_id);
        System.assertEquals('APPLICATION_NOT_FOUND', output.notifications[3].errors[0].code);
        System.assertEquals(false, output.notifications[4].isCompleted);
        System.assertEquals('APP1-00002', output.notifications[4].refObject.reference_id);
        System.assertEquals('USER_NOT_FOUND', output.notifications[4].errors[0].code);
        System.assertEquals(false, output.notifications[5].isCompleted);
        System.assertEquals('APP1-00003', output.notifications[5].refObject.reference_id);
        System.assertEquals('STRING_TOO_LONG', output.notifications[5].errors[0].code);
    }

    @isTest
    static void testDoPost_DuplicateInSF() {
        User user = [SELECT Username FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Application 1';
        insert oppApplication1;

        List<OPP_Notification.Input> notifications = new List<OPP_Notification.Input>();
        OPP_Notification.Input input1 = new OPP_Notification.Input();
        input1.api_id = '1';
        input1.application_id = oppApplication1.Id;
        input1.subject = 'Application 1: Notification 1';
        input1.description = 'Application 1: Notification 1 Description';
        input1.requester = 'Application 1: Requester 1';
        input1.users = user.Username;
        input1.url = 'https://login.salesforce.com';
        input1.event_code = 'Action';
        input1.reference_id = 'APP1-00001';
        input1.status = 'New';
        notifications.add(input1);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Notification';
        restRequest.httpMethod = 'POST';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Notification.Output output;
        output = OPP_Notification.doPost(notifications);

        System.assertEquals(true, output.notifications[0].isCompleted);
        System.assertEquals('APP1-00001', output.notifications[0].refObject.reference_id);

        output = OPP_Notification.doPost(notifications);

        System.assertEquals(false, output.notifications[0].isCompleted);
        System.assertEquals('DUPLICATE_RECORD_FOUND', output.notifications[0].errors[0].code);
    }

    @isTest
    static void testDoPost_DuplicateInList() {
        User user = [SELECT Username FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Application 1';
        insert oppApplication1;

        List<OPP_Notification.Input> notifications = new List<OPP_Notification.Input>();
        OPP_Notification.Input input1 = new OPP_Notification.Input();
        input1.api_id = '1';
        input1.application_id = oppApplication1.Id;
        input1.subject = 'Application 1: Notification 1';
        input1.description = 'Application 1: Notification 1 Description';
        input1.requester = 'Application 1: Requester 1';
        input1.users = user.Username;
        input1.url = 'https://login.salesforce.com';
        input1.event_code = 'Action';
        input1.reference_id = 'APP1-00001';
        input1.status = 'New';
        notifications.add(input1);

        OPP_Notification.Input input2 = new OPP_Notification.Input();
        input2.api_id = '1';
        input2.application_id = oppApplication1.Id;
        input2.subject = 'Application 1: Notification 1';
        input2.description = 'Application 1: Notification 1 Description';
        input2.requester = 'Application 1: Requester 1';
        input2.users = user.Username;
        input2.url = 'https://login.salesforce.com';
        input2.event_code = 'Action';
        input2.reference_id = 'APP1-00001';
        input2.status = 'New';
        notifications.add(input2);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Notification';
        restRequest.httpMethod = 'POST';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Notification.Output output;
        output = OPP_Notification.doPost(notifications);

        System.assertEquals(true, output.notifications[0].isCompleted);
        System.assertEquals('APP1-00001', output.notifications[0].refObject.reference_id);
        System.assertEquals(false, output.notifications[1].isCompleted);
        System.assertEquals('DUPLICATE_RECORD_FOUND', output.notifications[1].errors[0].code);
    }

    @isTest
    static void testDoPatch() {
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Application 1';
        insert oppApplication1;

        OPP_Application__c oppApplication2 = new OPP_Application__c();
        oppApplication2.Name = 'Application 2';
        insert oppApplication2;

        OPP_Notification__c oppNotification1 = new OPP_Notification__c();
        oppNotification1.ApiID__c = '1';
        oppNotification1.Application__c = oppApplication1.Id;
        oppNotification1.Subject__c = 'Application 1: Notification 1';
        oppNotification1.Description__c = 'Application 1: Notification 1 Description';
        oppNotification1.Requester__c = 'Application 1: Requester 1';
        oppNotification1.User__c = UserInfo.getUserId();
        oppNotification1.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification1.URL__c = 'https://login.salesforce.com';
        oppNotification1.Event__c = 'Action';
        oppNotification1.ReferenceID__c = 'APP1-00001';
        oppNotification1.Status__c = 'New';
        insert oppNotification1;

        OPP_Notification__c oppNotification2 = new OPP_Notification__c();
        oppNotification2.ApiID__c = '1';
        oppNotification2.Application__c = oppApplication2.Id;
        oppNotification2.Subject__c = 'Application 2: Notification 1';
        oppNotification2.Description__c = 'Application 2: Notification 1 Description';
        oppNotification2.Requester__c = 'Application 2: Requester 1';
        oppNotification2.User__c = UserInfo.getUserId();
        oppNotification2.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification2.URL__c = 'https://login.salesforce.com';
        oppNotification2.Event__c = 'Action';
        oppNotification2.ReferenceID__c = 'APP2-00001';
        oppNotification2.Status__c = 'New';
        insert oppNotification2;

        OPP_Notification__c oppNotification3 = new OPP_Notification__c();
        oppNotification3.ApiID__c = '2';
        oppNotification3.Application__c = oppApplication2.Id;
        oppNotification3.Subject__c = 'Application 2: Notification 2';
        oppNotification3.Description__c = 'Application 2: Notification 2 Description';
        oppNotification3.Requester__c = 'Application 2: Requester 1';
        oppNotification3.User__c = UserInfo.getUserId();
        oppNotification3.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification3.URL__c = 'https://login.salesforce.com';
        oppNotification3.Event__c = 'Action';
        oppNotification3.ReferenceID__c = 'APP2-00002';
        oppNotification3.Status__c = 'New';
        insert oppNotification3;

        OPP_Notification__c oppNotification4 = new OPP_Notification__c();
        oppNotification4.ApiID__c = '1';
        oppNotification4.Application__c = oppApplication1.Id;
        oppNotification4.Subject__c = 'Application 1: Notification 2';
        oppNotification4.Description__c = 'Application 1: Notification 2 Description';
        oppNotification4.Requester__c = 'Application 1: Requester 1';
        oppNotification4.User__c = UserInfo.getUserId();
        oppNotification4.UserName__c = 'nobody-sfdc-thaioil.r2@roundtwosolutions.com.dev4';
        oppNotification4.URL__c = 'https://login.salesforce.com';
        oppNotification4.Event__c = 'Action';
        oppNotification4.ReferenceID__c = 'APP1-00002';
        oppNotification4.Status__c = 'New';
        insert oppNotification4;

        OPP_Notification__c oppNotification5 = new OPP_Notification__c();
        oppNotification5.ApiID__c = '1';
        oppNotification5.Application__c = oppApplication1.Id;
        oppNotification5.Subject__c = 'Application 1: Notification 3';
        oppNotification5.Description__c = 'Application 1: Notification 3 Description';
        oppNotification5.Requester__c = 'Application 1: Requester 1';
        oppNotification5.User__c = UserInfo.getUserId();
        oppNotification5.UserName__c = 'nobody-sfdc-thaioil.r2@roundtwosolutions.com.dev4';
        oppNotification5.URL__c = 'https://login.salesforce.com';
        oppNotification5.Event__c = 'Action';
        oppNotification5.ReferenceID__c = 'APP1-00003';
        oppNotification5.Status__c = 'New';
        insert oppNotification5;

        List<OPP_Notification.Input> notifications = new List<OPP_Notification.Input>();
        OPP_Notification.Input input1 = new OPP_Notification.Input();
        input1.application_id = oppApplication1.Id;
        input1.reference_id = 'APP1-00001';
        input1.status = 'Approved';
        notifications.add(input1);

        OPP_Notification.Input input2 = new OPP_Notification.Input();
        input2.application_id = oppApplication2.Id;
        input2.reference_id = 'APP2-00001';
        input2.status = 'Rejected';
        notifications.add(input2);

        OPP_Notification.Input input3 = new OPP_Notification.Input();
        input3.application_id = oppApplication2.Id;
        input3.reference_id = 'APP2-00002';
        input3.status = 'Reassigned';
        notifications.add(input3);

        OPP_Notification.Input input4 = new OPP_Notification.Input();
        input4.application_id = oppApplication1.Id;
        input4.reference_id = 'APP1-00002';
        input4.status = 'Approved';
        notifications.add(input4);

        OPP_Notification.Input input5 = new OPP_Notification.Input();
        input5.application_id = 'a1U1s000000aCJZEA2';
        input5.reference_id = 'APP3-00001';
        input5.status = 'Approved';
        notifications.add(input5);

//        // Cannot change subject if notification is created
//        OPP_Notification.Input input6 = new OPP_Notification.Input();
//        input6.application_id = oppApplication1.Id;
//        input6.subject = 'Application 1: Notification 3 Too Long Subject .............................................................................................................................................................................................................................................................';
//        input6.reference_id = 'APP1-00003';
//        input6.status = 'Approved';
//        notifications.add(input6);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Notification';
        restRequest.httpMethod = 'PATCH';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Notification.Output output = OPP_Notification.doPatch(notifications);

        OPP_Notification__c oppNotification = [SELECT Status__c FROM OPP_Notification__c WHERE ReferenceID__c = 'APP1-00002' LIMIT 1];
        System.assertEquals('Approved', oppNotification.Status__c);

        System.assertEquals(true, output.notifications[0].isCompleted);
        System.assertEquals('APP1-00001', output.notifications[0].refObject.reference_id);
        System.assertEquals(true, output.notifications[1].isCompleted);
        System.assertEquals('APP2-00001', output.notifications[1].refObject.reference_id);
        System.assertEquals(true, output.notifications[2].isCompleted);
        System.assertEquals('APP2-00002', output.notifications[2].refObject.reference_id);
        System.assertEquals(true, output.notifications[3].isCompleted);
        System.assertEquals('APP1-00002', output.notifications[3].refObject.reference_id);
        System.assertEquals(false, output.notifications[4].isCompleted);
        System.assertEquals('APP3-00001', output.notifications[4].refObject.reference_id);
        System.assertEquals('RECORD_NOT_FOUND', output.notifications[4].errors[0].code);
//        System.assertEquals('STRING_TOO_LONG', output.notifications[5].errors[0].code);
    }

    @isTest
    static void testDoPatch_SameReferenceId() {
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Application 1';
        insert oppApplication1;

        OPP_Notification__c oppNotification1 = new OPP_Notification__c();
        oppNotification1.ApiID__c = '1';
        oppNotification1.Application__c = oppApplication1.Id;
        oppNotification1.Subject__c = 'Application 1: Notification 1';
        oppNotification1.Description__c = 'Application 1: Notification 1 Description';
        oppNotification1.Requester__c = 'Application 1: Requester 1';
        oppNotification1.User__c = UserInfo.getUserId();
        oppNotification1.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        oppNotification1.URL__c = 'https://login.salesforce.com';
        oppNotification1.Event__c = 'Action';
        oppNotification1.ReferenceID__c = 'APP1-00001';
        oppNotification1.Status__c = 'New';
        insert oppNotification1;

       OPP_Notification__c oppNotification2 = new OPP_Notification__c();
        oppNotification2.ApiID__c = '1';
        oppNotification2.Application__c = oppApplication1.Id;
        oppNotification2.Subject__c = 'Application 1: Notification 1';
        oppNotification2.Description__c = 'Application 1: Notification 1 Description';
        oppNotification2.Requester__c = 'Application 1: Requester 1';
        oppNotification2.User__c = UserInfo.getUserId();
        oppNotification2.UserName__c = 'sfdc-thaioil.r2@roundtwosolutions.com.dev4';
        oppNotification2.URL__c = 'https://login.salesforce.com';
        oppNotification2.Event__c = 'Action';
        oppNotification2.ReferenceID__c = 'APP1-00001';
        oppNotification2.Status__c = 'New';
        insert oppNotification2;

        List<OPP_Notification.Input> notifications = new List<OPP_Notification.Input>();
        OPP_Notification.Input input1 = new OPP_Notification.Input();
        input1.application_id = oppApplication1.Id;
        input1.reference_id = 'APP1-00001';
        input1.status = 'Approved';
        notifications.add(input1);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Notification';
        restRequest.httpMethod = 'PATCH';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Notification.Output output = OPP_Notification.doPatch(notifications);

        List<OPP_Notification__c> oppNotification = [SELECT Status__c FROM OPP_Notification__c WHERE Application__c = :oppApplication1.Id AND ReferenceID__c = 'APP1-00001' LIMIT 2];
        System.assertEquals('Approved', oppNotification[0].Status__c);
        System.assertEquals('Approved', oppNotification[1].Status__c);
    }

    @isTest
    static void testCloneInput() {
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Application 1';
        insert oppApplication1;

        OPP_Notification.Input input1 = new OPP_Notification.Input();
        input1.api_id = '1';
        input1.application_id = oppApplication1.Id;
        input1.subject = 'Application 1: Notification 1';
        input1.description = 'Application 1: Notification 1 Description';
        input1.requester = 'Application 1: Requester 1';
        input1.users = 'sfdc-thaioil.r2@roundtwosolutions.com.dev5';
        input1.url = 'https://login.salesforce.com';
        input1.event_code = 'Action';
        input1.reference_id = 'APP1-00001';
        input1.status = 'New';

        OPP_Notification.Input input2 = new OPP_Notification.Input(input1);

        System.assertEquals(input1.api_id, input2.api_id);
        System.assertEquals(input1.application_id, input2.application_id);
        System.assertEquals(input1.subject, input2.subject);
        System.assertEquals(input1.description, input2.description);
        System.assertEquals(input1.requester, input2.requester);
        System.assertEquals(input1.users, input2.users);
        System.assertEquals(input1.url, input2.url);
        System.assertEquals(input1.event_code, input2.event_code);
        System.assertEquals(input1.reference_id, input2.reference_id);
        System.assertEquals(input1.status, input2.status);
    }
    
    @isTest
    static void testUpdateNoti() {
        OPP_Notification__c oppNoti1_Before = [SELECT Id, Subject__c, Status__c FROM OPP_Notification__c WHERE Subject__c = 'Application 1: Notification 1' LIMIT 1];
        OPP_Notification__c oppNoti2_Before = [SELECT Id, Subject__c, Status__c FROM OPP_Notification__c WHERE Subject__c = 'Application 2: Notification 2' LIMIT 1];
        List<OPP_Notification__c> updateList = new List<OPP_Notification__c>();

        Test.startTest();
        oppNoti1_Before.Status__c = 'Approved';
        oppNoti2_Before.Status__c = 'Approved';
        updateList.add(oppNoti1_Before);
        updateList.add(oppNoti2_Before);
        update updateList;
        Test.stopTest();

        //OPP_News__c oppNews2_After = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 2' LIMIT 1];
        //OPP_News__c oppNews3_After = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 3' LIMIT 1];

        //System.assertEquals(true, oppNews2_After.Highlight__c);
        //System.assertEquals(false, oppNews3_After.Highlight__c);
    }
    
    @isTest
    static void testDeleteNoti() {
        OPP_Notification__c oppNoti1 = [SELECT Id, Subject__c, Status__c FROM OPP_Notification__c WHERE Subject__c = 'Application 1: Notification 1' LIMIT 1];
        List<OPP_Notification__c> deleteList = new List<OPP_Notification__c>();

        Test.startTest();
        deleteList.add(oppNoti1);
        delete deleteList;
        Test.stopTest();

        //OPP_News__c oppNews2_After = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 2' LIMIT 1];
        //OPP_News__c oppNews3_After = [SELECT Id, Highlight__c FROM OPP_News__c WHERE Title__c = 'News 3' LIMIT 1];

        //System.assertEquals(true, oppNews2_After.Highlight__c);
        //System.assertEquals(false, oppNews3_After.Highlight__c);
    }
}