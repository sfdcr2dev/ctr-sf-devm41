public class THOR_BApiComponentHelper {
	public class Result {
		// public String linkurl { get; set; }
	}

	public class dto_response extends WebServiceExtend.dto_response {
		public Result result { get; set; }
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	public static dto_response execute(String endpoint, Map<String, Object> result) {
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = String.valueOf(result.get('uuid')),
			Integration_Name__c = 'ZPM_BAPI_COMPONENT',
			Method__c = 'Create',
			Message_Type__c = 'Success',
			SAP_Response_Body__c = JSON.serialize(result)
		);

		dto_response responseDTO = new dto_response();
		try {
			Map<String, Spare_Part_Request__c> resSprMap = new Map<String, Spare_Part_Request__c>();
			List<Object> response_batch = (List<Object>) result.get('sparePartRequests');
			for (Object obj : response_batch) {
				String keyText = String.format(
					'{0}-{1}-{2}',
					new List<String>{
						(String) MethodUtils.getResult('orderNumber', obj),
						(String) MethodUtils.getResult('orderOperation', obj),
						(String) MethodUtils.getResult('itemNo', obj)
					}
				);
				String integrationStatus = (String) MethodUtils.getResult('Integration_Status__c', obj);
				String integrationMessage = (String) MethodUtils.getResult('Integration_Message__c', obj);
				resSprMap.put(
					keyText,
					new Spare_Part_Request__c(
						Request_Status__c = integrationStatus != null && integrationStatus?.equalsIgnoreCase('Success') ? 'Pending for Approval' : 'Draft',
						Integration_Status__c = integrationStatus != null && integrationStatus?.equalsIgnoreCase('Success') ? integrationStatus : 'Failed',
						Integration_Message__c = integrationMessage
					)
				);
			}

			String orderId = (String) result.get('orderId');
			List<Spare_Part_Request__c> updateSrp = new List<Spare_Part_Request__c>();
			for (Spare_Part_Request__c spr : [
				SELECT Id, Order__r.Name, Item_No__c, Order_Operation__r.Operation_Text__c
				FROM Spare_Part_Request__c
				WHERE Order__c = :orderId AND Request_Status__c IN ('Draft') AND Deleted__c = false
			]) {
				String keyText = String.format(
					'{0}-{1}-{2}',
					new List<String>{
						spr.Order__r.Name,
						(spr.Order_Operation__r?.Operation_Text__c != null ? spr.Order_Operation__r?.Operation_Text__c : 'no-operation-text'),
						spr.Item_No__c
					}
				);

				spr.Request_Status__c = resSprMap.containsKey(keyText) ? resSprMap.get(keyText).Request_Status__c : 'Draft';
				spr.Integration_Status__c = resSprMap.containsKey(keyText) ? resSprMap.get(keyText).Integration_Status__c : 'Failed';
				if (resSprMap.containsKey(keyText)) {
					spr.Integration_Message__c = resSprMap.get(keyText).Integration_Message__c;
				}

				updateSrp.add(spr);
			}

			Boolean isSuccess = true;
			System.debug(JSON.serializePretty(updateSrp));
			if (updateSrp.size() > 0) {
				try {
					update updateSrp;
				} catch (Exception e) {
					isSuccess = false;
					System.debug(System.LoggingLevel.ERROR, String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() }));
				}
			}

			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{ 'success' => isSuccess, 'message' => isSuccess ? '' : 'Some component are failed' },
						'result' => new Map<String, Object>{
							'linkurl' => String.format('{0}/{1}', new List<Object>{ URL.getSalesforceBaseUrl().toExternalForm(), orderId })
						}
					}
				)
			);
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		} catch (Exception e) {
			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{ 'success' => false, 'message' => e.getMessage() },
						'result' => new Map<String, Object>{ 'data' => new List<Object>() }
					}
				)
			);
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = String.format('{0}\r\n{1}', new List<Object>{ e.getMessage(), e.getStackTraceString() });
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		}

		return responseDTO;
	}
}