@isTest
public class OPP_CoinControllerTest {
	private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            if (request.getEndpoint().startsWithIgnoreCase('https://qasapi-thaioilhub.thaioilgroup.com/api/auth/login')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "token": {"tokenId": 25609,"userId": 1,"hash": "de68f6d8cec319286470518b694de772","expiredDate": 1628654789219,"valid": true,"mark": null,"deviceId": null,"deviceType": null} }');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasapi-thaioilhub.thaioilgroup.com/api/km/getTopCoin')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('100');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasapi-thaioilhub.thaioilgroup.com/api/salesforce/addCoin')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('{  "status": "success",  "message": "Congratulation you got 1 top coin." }');
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
        oppIntegration.Coin_Authorization_Endpoint__c = 'https://qasapi-thaioilhub.thaioilgroup.com/api/auth/login?';
        oppIntegration.Coin_Authorization_Username__c = 'admin';
        oppIntegration.Coin_Authorization_Password__c = '123456';
        oppIntegration.Coin_Get_Endpoint__c = 'https://qasapi-thaioilhub.thaioilgroup.com/api/km/getTopCoin?';
        oppIntegration.Coin_Add_Endpoint__c = 'https://qasapi-thaioilhub.thaioilgroup.com/api/salesforce/addCoin?';
        oppIntegration.Coin_Login_Username__c = 'salesforce';
        oppIntegration.Coin_Login_Password__c = 'Sal3sforc3';
        
        insert oppIntegration;
    }
    
    @isTest
    static void testGetCoin() {
        Test.setMock(HttpCalloutMock.class, new OPP_CoinControllerTest.Mock());
        String endPoint = 'https://qasapi-thaioilhub.thaioilgroup.com/api/km/getTopCoin?name=';
        Test.startTest();
        OPP_CoinController.getCoin(endPoint);
        OPP_CoinController.UpdateCoin();
        Test.stopTest();
    }
    
    @isTest
    static void testAddCoin() {
        Test.setMock(HttpCalloutMock.class, new OPP_CoinControllerTest.Mock());
        Test.startTest();
        OPP_CoinController.addCoin('abc001',2);
        Test.stopTest();
    }
}