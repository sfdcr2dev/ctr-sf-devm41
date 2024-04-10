@isTest
public class OPP_WeatherControllerTest {
	private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            if (request.getEndpoint().startsWithIgnoreCase('https://api.openweathermap.org/data/2.5/weather')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"main": {"temp": 27.58}}');
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
        OPPIntegration__c oppIntegration = new OPPIntegration__c();
        oppIntegration.Weather_Endpoint__c = 'https://api.openweathermap.org/data/2.5/weather?';
        oppIntegration.Weather_Token__c = 'bf21b2e0b4c4ab6ecf801203d28d68f2';
        
        insert oppIntegration;
    }
    
    @isTest
    static void testGetCoin() {
        Test.setMock(HttpCalloutMock.class, new OPP_WeatherControllerTest.Mock());
        //String endPoint = 'https://api.openweathermap.org/data/2.5/weather';
        Test.startTest();
        OPP_WeatherController.getWeather('13','100');
        Test.stopTest();
    }
}