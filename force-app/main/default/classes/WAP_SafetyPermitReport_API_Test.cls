@isTest
public with sharing class WAP_SafetyPermitReport_API_Test {

    public static testMethod void GetWAPMapGetWorkCountAPIPost() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_SafetyPermitReport_API/doPost/GetSummaryPermitGraph';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-01-01\\\", \\\"endDate\\\" : \\\"2022-12-31\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_SafetyPermitReport_API.doPost(postData);
        
        Test.stopTest();
        
    }

    public static testMethod void GetSummaryPermitTable() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_SafetyPermitReport_API/doPost/GetSummaryPermitTable';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-01-01\\\", \\\"endDate\\\" : \\\"2022-12-31\\\" }\", \"sortByParam\":\"{}\",\"pageParam\":\"{\\\"pageNo\\\":1,\\\"pageSize\\\":10}\"}"';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_SafetyPermitReport_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void GetSummaryPermitTableCount() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_SafetyPermitReport_API/doPost/GetSummaryPermitTableCount';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-01-01\\\", \\\"endDate\\\" : \\\"2022-12-31\\\" }\", \"sortByParam\":\"{}\",\"pageParam\":\"{\\\"pageNo\\\":1,\\\"pageSize\\\":10}\"}"';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_SafetyPermitReport_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void ExportExcel() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_SafetyPermitReport_API/doPost/ExportExcel';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-01-01\\\", \\\"endDate\\\" : \\\"2022-12-31\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_SafetyPermitReport_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void allAreas() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_SafetyPermitReport_API/doPost/allAreas';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-01-01\\\", \\\"endDate\\\" : \\\"2022-12-31\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_SafetyPermitReport_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    
}