@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        //req.getEndpoint(); RequesToken
        
        String strBody='{'
            			+'"Success": true,'
            			+'"access_token":"test",'
            			+'"token_type":"bearer",'
            			+'"expires_in": 1209599,'
                        +'"userName": "test@softever.co.th",'
                        +'".issued": "Wed, 31 Jan 2023 03:56:02 GMT",'
                        +'".expires": "Wed, 30 Jul 2023 03:56:02 GMT"'
			            +'}';
        
          
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(strBody);
        res.setStatusCode(200);
        return res;
    }
}