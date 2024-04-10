@isTest
public with sharing class WAP_Dashboard_API_Test {

    public static testMethod void DailyClearanceCertificateChartSeries() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/DailyClearanceCertificateChartSeries';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-11-01\\\", \\\"endDate\\\" : \\\"2022-11-30\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Dashboard_API.doPost(postData);
        
        Test.stopTest();
        
    }

    public static testMethod void DetailReportByAreaChartSeries() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/DetailReportByAreaChartSeries';       
        req.httpMethod = 'POST';
        //string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\" }\", \"sortByParam\":\"{}\",\"pageParam\":\"{\\\"pageNo\\\":1,\\\"pageSize\\\":10}\"}"';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-11-01\\\", \\\"endDate\\\" : \\\"2022-11-30\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Dashboard_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void ClearanceCertificateYearChartSeries() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/ClearanceCertificateYearChartSeries';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-11-01\\\", \\\"endDate\\\" : \\\"2022-11-30\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_SafetyPermitReport_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void DashboardHRWPieChartSeries() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/DashboardHRWPieChartSeries';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-11-01\\\", \\\"endDate\\\" : \\\"2022-11-30\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Dashboard_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void DashboardHRWChartSeries() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/DashboardHRWChartSeries';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-11-01\\\", \\\"endDate\\\" : \\\"2022-11-30\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Dashboard_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void DashboardTopFiveChartSeries() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/DashboardTopFiveChartSeries';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-11-01\\\", \\\"endDate\\\" : \\\"2022-11-30\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Dashboard_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    public static testMethod void ExportHighRiskWorkExcel() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/ExportHighRiskWorkExcel';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\", \\\"startDate\\\" : \\\"2022-11-01\\\", \\\"endDate\\\" : \\\"2022-11-30\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Dashboard_API.doPost(postData);
        
        Test.stopTest();
        
    }
        
    public static testMethod void allAreas() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/WAP_Dashboard_API/doPost/allAreas';       
        req.httpMethod = 'POST';
        string postData = '{\"filter\" : \"{ \\\"year\\\" : \\\"2022\\\" }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        WAP_Dashboard_API.doPost(postData);
        
        Test.stopTest();
        
    }
    
    
}