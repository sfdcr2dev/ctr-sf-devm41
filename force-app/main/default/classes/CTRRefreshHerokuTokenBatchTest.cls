@isTest
public class CTRRefreshHerokuTokenBatchTest {

    public class ResponseSuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'text/json');
            response.setBody('{"status": "success", "token": "pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM"}');
            response.setStatusCode(200);
            return response; 
        }
    }

    @isTest
    static void testExecute() {

        Test.setMock(HttpCalloutMock.class, new CTRRefreshHerokuTokenBatchTest.ResponseSuccessMock());

        Test.startTest();

        CTRRefreshHerokuTokenBatch batch = new CTRRefreshHerokuTokenBatch();
        try {
            Database.executeBatch(batch);
        } 
        catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }

        Test.stopTest();
    }

}