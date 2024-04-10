public class C360_IRPAIntegration_FinancialInfo{
	class FinancialInfoToSAP{
		String gateway_id;
		String KUNNR;
		String BUKRS;
		String KKBER;
	}
	public static void GetAllNot2000(){
		try{
			list<string> salesOrg = new List<String>();
			list<AggregateResult> salesOrgQuery = [SELECT SalesOrganization__c from C360_SalesArea__c where SalesOrganization__c !='2000' group by SalesOrganization__c];
			for(AggregateResult i : salesOrgQuery){
				salesOrg.add(String.valueOf(i.get('SalesOrganization__c')));
			}
			for(Integer i = 0; i < salesOrg.size(); i++){
				String uuid = Uuid.randomUUID();
				String json = '{"input": {"input": {"gateway_id": "'+uuid+'","BUKRS": "'+salesOrg[i]+'","KKBER": "","KUNNR": ""}}}';
				C360_IRPAIntegration_FinancialInfo.calloutToIRPA_FinancialInfo(json,uuid);
			}
		}catch(Exception e){}
	}
	public static void Get2000(){
		try{
			String uuid = Uuid.randomUUID();
			String json = '{"input": {"input": {"gateway_id": "'+uuid+'","BUKRS": "'+'2000'+'","KKBER": "","KUNNR": ""}}}';
			C360_IRPAIntegration_FinancialInfo.calloutToIRPA_FinancialInfo(json,uuid);
		}catch (Exception e){}
	}
	@AuraEnabled
	public static void GetSalesOrg(String AccId){
		try{
			Account Acc = [select id,AccountNumber__c from Account where id =:AccId Limit 1];
			List<C360_SalesArea__c> ListSalesArea = [SELECT Id ,SalesOrganization__c,AccountNumber__r.AccountNumber__c from C360_SalesArea__c  where AccountNumber__r.AccountNumber__c =: Acc.AccountNumber__c];
			List<C360_SalesArea__c> ListSalesAreaNotDup =  new List<C360_SalesArea__c>();
			Map<String, string> salesOrgCheck = new Map<String, string>();
			for(C360_SalesArea__c iSalesArea : ListSalesArea){
				if(salesOrgCheck.get(iSalesArea.SalesOrganization__c) == 'check'){
				}else{
					salesOrgCheck.put(iSalesArea.SalesOrganization__c,'check');
					ListSalesAreaNotDup.add(iSalesArea);
				}
			}
			for(C360_SalesArea__c iSalesArea : ListSalesAreaNotDup){
				String uuid = Uuid.randomUUID();
				String json = '{"input": {"input": {"gateway_id": "'+uuid+'","BUKRS": "'+iSalesArea.SalesOrganization__c+'","KKBER": "","KUNNR": "'+iSalesArea.AccountNumber__r.AccountNumber__c+'"}}}';
				C360_IRPAIntegration_FinancialInfo.calloutToIRPA_FinancialInfo(json,uuid);
			}
		}catch (Exception e){}
	}
	@future(callout=true)
	public static void calloutToIRPA_FinancialInfo(String bodyJson, String externalid){
		C360Integration__c CS = C360Integration__c.getInstance();
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = externalid,
			Message_Type__c = 'In Progress',
			Integration_Name__c = 'calloutToIRPA_FinancialInfo',
			Method__c = 'Create',
			Request_Body__c = bodyJson
		);
		try{
			String reqbody = 'grant_type=client_credentials&client_id=' + CS.iRPA_Client_Id__c + '&client_secret=' + CS.iRPA_Client_Secret_Id__c;
			Http h = new Http();
			HttpRequest req = new HttpRequest();
			req.setBody(reqbody);
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Token_Endpoint__c);
			HttpResponse res = h.send(req);
			String token = res.getBody();//system.debug(res.getBody());
			Map<String,Object> result = (Map<String,Object>) JSON.deserializeUntyped(token);
			String access_token = result.containsKey('access_token') ? (String) result.get('access_token') : '';
			Http http = new Http();
			HttpRequest httpReq = new HttpRequest();
			httpReq.setBody(bodyJson);
			httpReq.setMethod('POST');
			httpReq.setEndpoint(CS.iRPA_FinancialInfo_Endpoint__c);
			httpReq.setHeader('Content-Type','application/json');
			httpReq.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
			httpReq.setHeader('Authorization', 'Bearer ' + access_token);
			httpReq.setTimeout(60 * 1000);
			HttpResponse httpRes = http.send(httpReq);
			Map<String,Object> resultV = (Map<String,Object>) JSON.deserializeUntyped(
				httpRes?.getBody() != null ? httpRes.getBody() : '{}'
			);
			applog.Response_Body__c = httpRes.getBody();
			//if(resultV.isEmpty() || (resultV.containsKey('severity') && String.valueOf(resultV.get('severity')).equalsIgnoreCase('ERROR'))){}
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_FinancialInfo_Endpoint__c,applog);
		}catch(Exception e){
			applog.Integration_Name__c = 'calloutToIRPA_FinancialInfo';
			applog.Method__c = 'Create';
			applog.Message_Type__c = 'In Progress';
			applog.Request_Body__c = bodyJson;
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_FinancialInfo_Endpoint__c,applog);
		}
	}
}