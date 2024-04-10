@IsTest
global class CTRApprovalDetailControllerHttpMock  implements HttpCalloutMock{
    public CTRApprovalDetailControllerHttpMock() {

    }
    global HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"base64": "test="}');
        return res;
    }

}