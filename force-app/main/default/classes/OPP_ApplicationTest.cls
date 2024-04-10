@isTest
public class OPP_ApplicationTest {

    @isTest
    static void testDoPost() {
        List<OPP_Application.Input> applications = new List<OPP_Application.Input>();
        OPP_Application.Input input1 = new OPP_Application.Input();
        input1.application_name = 'Test Notification Application 1';
        input1.icon = 'https://login.salesforce.com/icon';
        input1.url = 'https://login.salesforce.com/url';
        applications.add(input1);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Application';
        restRequest.httpMethod = 'POST';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Application.Output output = OPP_Application.doPost(applications);

        System.assertEquals(true, output.applications[0].isCompleted);
        System.assertEquals('Test Notification Application 1', output.applications[0].refObject.application_name);
        System.assertEquals('https://login.salesforce.com/icon', output.applications[0].refObject.icon);
        System.assertEquals('https://login.salesforce.com/url', output.applications[0].refObject.url);
        System.assertEquals(false, String.isBlank(output.applications[0].refObject.salesforce_id));
    }

    @isTest
    static void testDoPost_TooLongApplicationName() {
        List<OPP_Application.Input> applications = new List<OPP_Application.Input>();
        OPP_Application.Input input1 = new OPP_Application.Input();
        input1.application_name = 'Test Notification Application 1 Too Long Application Name ..................................................................................................................................................................................................................................................';
        input1.icon = 'https://login.salesforce.com/icon';
        input1.url = 'https://login.salesforce.com/url';
        applications.add(input1);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Application';
        restRequest.httpMethod = 'POST';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Application.Output output = OPP_Application.doPost(applications);

        System.assertEquals(false, output.applications[0].isCompleted);
        System.assertEquals('STRING_TOO_LONG', output.applications[0].errors[0].code);
        System.assertEquals(true, String.isBlank(output.applications[0].refObject.salesforce_id));
    }

    @isTest
    static void testDoPatch() {
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Test Notification Application 1';
        insert oppApplication1;

        List<OPP_Application.Input> applications = new List<OPP_Application.Input>();
        OPP_Application.Input input1 = new OPP_Application.Input();
        input1.salesforce_id = oppApplication1.Id;
        input1.application_name = 'Test Notification Application 1 => Update';
        input1.icon = 'https://login.salesforce.com/icon_update';
        input1.url = 'https://login.salesforce.com/url_update';
        applications.add(input1);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Application';
        restRequest.httpMethod = 'PATCH';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Application.Output output = OPP_Application.doPatch(applications);

        System.assertEquals(true, output.applications[0].isCompleted);
        System.assertEquals('Test Notification Application 1 => Update', output.applications[0].refObject.application_name);
        System.assertEquals('https://login.salesforce.com/icon_update', output.applications[0].refObject.icon);
        System.assertEquals('https://login.salesforce.com/url_update', output.applications[0].refObject.url);
        System.assertEquals(false, String.isBlank(output.applications[0].refObject.salesforce_id));
    }

    @isTest
    static void testDoPatch_TooLongApplicationName() {
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Test Notification Application 1';
        insert oppApplication1;

        List<OPP_Application.Input> applications = new List<OPP_Application.Input>();
        OPP_Application.Input input1 = new OPP_Application.Input();
        input1.salesforce_id = oppApplication1.Id;
        input1.application_name = 'Test Notification Application 1 => Update Too Long Application Name ........................................................................................................................................................................................................................................';
        input1.icon = 'https://login.salesforce.com/icon_update';
        input1.url = 'https://login.salesforce.com/url_update';
        applications.add(input1);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Application';
        restRequest.httpMethod = 'PATCH';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Application.Output output = OPP_Application.doPatch(applications);

        System.assertEquals(false, output.applications[0].isCompleted);
        System.assertEquals('STRING_TOO_LONG', output.applications[0].errors[0].code);
    }

    @isTest
    static void testDoPatch_RecordNotFound() {
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Test Notification Application 1';
        insert oppApplication1;

        List<OPP_Application.Input> applications = new List<OPP_Application.Input>();
        OPP_Application.Input input1 = new OPP_Application.Input();
        input1.salesforce_id = 'a1U1s000000aCJZEA2';
        input1.application_name = 'Test Notification Application 1 => Update';
        input1.icon = 'https://login.salesforce.com/icon_update';
        input1.url = 'https://login.salesforce.com/url_update';
        applications.add(input1);

        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        restRequest.requestURI = '/services/apexrest/OPP_Application';
        restRequest.httpMethod = 'PATCH';
        restRequest.addHeader('Content-Type', 'application/json');
        //restRequest.requestBody = Blob.valueOf('');

        RestContext.request = restRequest;
        RestContext.response = restResponse;
        OPP_Application.Output output = OPP_Application.doPatch(applications);

        System.assertEquals(false, output.applications[0].isCompleted);
        System.assertEquals('RECORD_NOT_FOUND', output.applications[0].errors[0].code);
    }

    @isTest
    static void testCloneInput() {
        OPP_Application__c oppApplication1 = new OPP_Application__c();
        oppApplication1.Name = 'Test Notification Application 1';
        insert oppApplication1;

        OPP_Application.Input input1 = new OPP_Application.Input();
        input1.application_name = 'Test Notification Application 1';
        input1.icon = 'https://login.salesforce.com/icon';
        input1.url = 'https://login.salesforce.com/url';

        OPP_Application.Input input2 = new OPP_Application.Input(input1);

        System.assertEquals(input1.application_name, input2.application_name);
        System.assertEquals(input1.icon, input2.icon);
        System.assertEquals(input1.url, input2.url);
    }
}