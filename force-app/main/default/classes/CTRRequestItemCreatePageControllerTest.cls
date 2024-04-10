@isTest
public class CTRRequestItemCreatePageControllerTest {
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

    @isTest
    public static void testGetAllRecordTypeList(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        insert acc;

        Test.startTest();
        CTRRequestItemCreatePageController.resultOnLoadRecordTypePage result = CTRRequestItemCreatePageController.getAllRecordTypeList(acc.Id,'TX');
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    public static void testGetRequestItemRecordType(){
        Test.startTest();
        CTRRequestItemCreatePageController.getRequestItemRecordType();
        Test.stopTest();
    }
}