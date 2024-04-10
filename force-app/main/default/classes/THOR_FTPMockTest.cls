@isTest
global class THOR_FTPMockTest implements HttpCalloutMock 
{
    
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse response = new HttpResponse();
		response.setBody('000000000000000001|1200|Demister, OD 2400x200x150 mm. for V-9721|ZPRO|SET||0.000|0.000|0.000|747717.80\n000000000000000002|1200|Demister, OD 1320x200x150 mm. for V-9722|ZPRO|SET||0.000|0.000|0.000|242150.94');
        response.setStatusCode(200);
        return response;
    }
    
}