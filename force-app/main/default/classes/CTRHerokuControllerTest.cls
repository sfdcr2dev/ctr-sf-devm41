@isTest
public class CTRHerokuControllerTest {
    
    public class ResponseSuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'text/json');
            response.setBody('{"status": "success", "token": "pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM"}');
            response.setStatusCode(200);
            return response; 
        }
    }

    public class ResponseFailedMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'text/json');
            response.setBody('{"status": "error", "token": null}');
            response.setStatusCode(400);
            return response; 
        }
    }

    @isTest
    static void testGetToken_Success() {

        Test.setMock(HttpCalloutMock.class, new CTRHerokuControllerTest.ResponseSuccessMock());

        CTRConfig__c config = new CTRConfig__c(
            RemindDate__c = 3
        );
        insert config;

        Test.startTest();

        CTRHerokuController.TokenResultWrapper result = CTRHerokuController.getToken();

        Test.stopTest();

        System.assertEquals('Success get Token', result.mResult);
        System.assertEquals('pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM', result.mToken);
    }

    @isTest
    static void testGetToken_Fail() {

        try {
            CTRHerokuController.TokenResultWrapper result = CTRHerokuController.getToken();
        }
        catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }

        Test.setMock(HttpCalloutMock.class, new CTRHerokuControllerTest.ResponseFailedMock());

        CTRConfig__c config = new CTRConfig__c(
            RemindDate__c = 3
        );
        insert config;

        Test.startTest();

        CTRHerokuController.TokenResultWrapper result = CTRHerokuController.getToken();

        Test.stopTest();

        System.assertEquals('Request Error: Not able to Recieved Token', result.mResult);
        System.assertEquals('', result.mToken);
    }
}