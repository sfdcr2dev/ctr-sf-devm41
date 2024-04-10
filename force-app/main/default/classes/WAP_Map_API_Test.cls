@isTest
public with sharing class WAP_Map_API_Test {

    public static testMethod void GetWAPMapGetWorkCountAPIPost() {
        
        Test.startTest();

        WAP_Config__c WAPConfig = new WAP_Config__c();
        WAPConfig.Google_API_Key__c = 'abcdefg';
        insert(WAPConfig);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Map_API/doPost/GetWorkCount';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"allTypeOfWork\\\" : false, ' +
            				'\\\"generalWork\\\" : true, '+
            				'\\\"hotWork\\\" : true, '+
            				'\\\"confinedSpace\\\" : true, '+
            				'\\\"craneLifting\\\" : true, '+
            				'\\\"radiation\\\" : true, '+
            				'\\\"jackHammer\\\" : true, '+
            				'\\\"highPressureWaterJet\\\" : true, '+
            				'\\\"digging\\\" : true, '+
            				'\\\"workAtHeight\\\" : true, '+
            				'\\\"onlineStopLeak\\\" : true, '+
            				'\\\"nonTypeOfWork\\\" : true }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Map_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void GetWAPMapGetAllWorkCountAPIPost() {
        
        Test.startTest();

        WAP_Config__c WAPConfig = new WAP_Config__c();
        WAPConfig.Google_API_Key__c = 'abcdefg';
        insert(WAPConfig);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Map_API/doPost/GetAllWorkCount';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"allTypeOfWork\\\" : false, ' +
            				'\\\"generalWork\\\" : true, '+
            				'\\\"hotWork\\\" : true, '+
            				'\\\"confinedSpace\\\" : true, '+
            				'\\\"craneLifting\\\" : true, '+
            				'\\\"radiation\\\" : true, '+
            				'\\\"jackHammer\\\" : true, '+
            				'\\\"highPressureWaterJet\\\" : true, '+
            				'\\\"digging\\\" : true, '+
            				'\\\"workAtHeight\\\" : true, '+
            				'\\\"onlineStopLeak\\\" : true, '+
            				'\\\"nonTypeOfWork\\\" : true }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Map_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void GetWAPMapGetWorkMapsAPIPost() {
        
        Test.startTest();

        WAP_Config__c WAPConfig = new WAP_Config__c();
        WAPConfig.Google_API_Key__c = 'abcdefg';
        insert(WAPConfig);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Map_API/doPost/GetWorkMaps';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"allTypeOfWork\\\" : false, ' +
            				'\\\"generalWork\\\" : true, '+
            				'\\\"hotWork\\\" : true, '+
            				'\\\"confinedSpace\\\" : true, '+
            				'\\\"craneLifting\\\" : true, '+
            				'\\\"radiation\\\" : true, '+
            				'\\\"jackHammer\\\" : true, '+
            				'\\\"highPressureWaterJet\\\" : true, '+
            				'\\\"digging\\\" : true, '+
            				'\\\"workAtHeight\\\" : true, '+
            				'\\\"onlineStopLeak\\\" : true, '+
            				'\\\"nonTypeOfWork\\\" : true }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Map_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void GetWAPMapGetWorkDetailAPIPost() {
        
        Test.startTest();

        WAP_Config__c WAPConfig = new WAP_Config__c();
        WAPConfig.Google_API_Key__c = 'abcdefg';
        insert(WAPConfig);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Map_API/doPost/GetWorkDetail';       
        req.httpMethod = 'POST';
        String postData = '{\"clearanceNo\" : \"000001\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Map_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void GetWAPMapGetAreasAPIPost() {
        
        Test.startTest();

        WAP_Config__c WAPConfig = new WAP_Config__c();
        WAPConfig.Google_API_Key__c = 'abcdefg';
        insert(WAPConfig);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Map_API/doPost/GetAreas';       
        req.httpMethod = 'POST';
        String postData = '{\"clearanceNo\" : \"000001\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Map_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
}