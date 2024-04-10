@isTest
public class C360_ReplicatedSAP_OverdueTest {
    
    @testSetup
    public static void setupdate()
    {
        Account acc = new Account();
        acc.Name = 'test';
        acc.AccountNumber__c = '1';
        	insert acc;
    }
    
    
    @IsTest
	static void testWebService() {
		Test.startTest();
		C360_ReplicatedSAP_Overdue.dto_response dto = new C360_ReplicatedSAP_Overdue.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/overdue';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"ODLIST\":[{\"CUSTOMERCODE\":\"1\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"100.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"100.00\",\"OVERDUEDAY\":\"297\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"70.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"70.00\",\"OVERDUEDAY\":\"322\"},{\"CUSTOMERCODE\":\"9191919191\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"14485.87\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"14485.87\",\"OVERDUEDAY\":\"391\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"15000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"15000.00\",\"OVERDUEDAY\":\"445\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"1000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"1000.00\",\"OVERDUEDAY\":\"483\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"100.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"100.00\",\"OVERDUEDAY\":\"662\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"14815143.73\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"14815143.73\",\"OVERDUEDAY\":\"738\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"7392523.46\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"7392523.46\",\"OVERDUEDAY\":\"740\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"41000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"41000.00\",\"OVERDUEDAY\":\"832\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"2579956.80\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"2579956.80\",\"OVERDUEDAY\":\"884\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"1202001.41\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"1202001.41\",\"OVERDUEDAY\":\"895\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"130209.26\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"130209.26\",\"OVERDUEDAY\":\"916\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"130209.26\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"130209.26\",\"OVERDUEDAY\":\"917\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"181997.26\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"181997.26\",\"OVERDUEDAY\":\"930\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"5310000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"5310000.00\",\"OVERDUEDAY\":\"955\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"3721568.18\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"3721568.18\",\"OVERDUEDAY\":\"988\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"4500.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"4500.00\",\"OVERDUEDAY\":\"995\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"50000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"50000000.00\",\"OVERDUEDAY\":\"1021\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"50000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"50000000.00\",\"OVERDUEDAY\":\"1031\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"2088734.68\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"2088734.68\",\"OVERDUEDAY\":\"1088\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"20000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"20000000.00\",\"OVERDUEDAY\":\"1110\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"1000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"1000000.00\",\"OVERDUEDAY\":\"1176\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"157076000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"157076000.00\",\"OVERDUEDAY\":\"1190\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"31250300.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"31250300.00\",\"OVERDUEDAY\":\"1193\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;
		date thisdate = C360_ReplicatedSAP_Overdue.StringToDate('20220101');
		C360_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
    
    @IsTest
	static void testWebServiceMissingCustomer() {
		Test.startTest();
		C360_ReplicatedSAP_Overdue.dto_response dto = new C360_ReplicatedSAP_Overdue.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/overdue';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"ODLIST\":[{\"CUSTOMERCODE\":\"2\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"100.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"100.00\",\"OVERDUEDAY\":\"297\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"70.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"70.00\",\"OVERDUEDAY\":\"322\"},{\"CUSTOMERCODE\":\"9191919191\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"14485.87\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"14485.87\",\"OVERDUEDAY\":\"391\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"15000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"15000.00\",\"OVERDUEDAY\":\"445\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"1000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"1000.00\",\"OVERDUEDAY\":\"483\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"100.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"100.00\",\"OVERDUEDAY\":\"662\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"14815143.73\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"14815143.73\",\"OVERDUEDAY\":\"738\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"7392523.46\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"7392523.46\",\"OVERDUEDAY\":\"740\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"41000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"41000.00\",\"OVERDUEDAY\":\"832\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"2579956.80\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"2579956.80\",\"OVERDUEDAY\":\"884\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"1202001.41\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"1202001.41\",\"OVERDUEDAY\":\"895\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"130209.26\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"130209.26\",\"OVERDUEDAY\":\"916\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"130209.26\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"130209.26\",\"OVERDUEDAY\":\"917\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"181997.26\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"181997.26\",\"OVERDUEDAY\":\"930\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"5310000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"5310000.00\",\"OVERDUEDAY\":\"955\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"3721568.18\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"3721568.18\",\"OVERDUEDAY\":\"988\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"4500.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"4500.00\",\"OVERDUEDAY\":\"995\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"50000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"50000000.00\",\"OVERDUEDAY\":\"1021\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"50000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"50000000.00\",\"OVERDUEDAY\":\"1031\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"2088734.68\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"2088734.68\",\"OVERDUEDAY\":\"1088\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"20000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"20000000.00\",\"OVERDUEDAY\":\"1110\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"1000000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"1000000.00\",\"OVERDUEDAY\":\"1176\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"157076000.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"157076000.00\",\"OVERDUEDAY\":\"1190\"},{\"CUSTOMERCODE\":\"43\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"31250300.00\",\"DOCCURRENCY\":\"THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"31250300.00\",\"OVERDUEDAY\":\"1193\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;
		date thisdate = C360_ReplicatedSAP_Overdue.StringToDate('20220101');
		C360_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
    
     @IsTest
	static void testWebServiceFail() {
		Test.startTest();
		C360_ReplicatedSAP_Overdue.dto_response dto = new C360_ReplicatedSAP_Overdue.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/overdue';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"ODLIST\":[{\"CUSTOMERCODE\":\"1\",\"COMPANYCODE\":\"1100\",\"AMOUNTINDOCCURRENCY\":\"100.00\",\"DOCCURRENCY\":\"1THB\",\"FISCALYEAR\":\"\",\"DOCUMENTNUMBER\":\"\",\"AMOUNTINLOCALCURRENCY\":\"100.00\",\"OVERDUEDAY\":\"297\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		C360_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
    @IsTest
	static void testWebServiceFail2() {
		Test.startTest();
		C360_ReplicatedSAP_Overdue.dto_response dto = new C360_ReplicatedSAP_Overdue.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/overdue1';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '(test)'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		C360_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
}