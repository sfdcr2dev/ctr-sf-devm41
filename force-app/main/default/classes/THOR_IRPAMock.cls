@isTest
global class THOR_IRPAMock implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse response = new HttpResponse();
        response.setBody('{"access_token":"test123"}');
        response.setStatusCode(200);
        return response;
    }

}