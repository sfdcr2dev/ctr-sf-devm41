public class THOR_BApiOrderHelper {
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
		dto_response responseDTO = new dto_response();
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = String.valueOf(result.get('uuid')),
			Integration_Name__c = 'ZPI_BAPI_ALM_ORDER_CREATE',
			Method__c = 'Create',
			Message_Type__c = 'Success',
			SAP_Response_Body__c = JSON.serialize(result)
		);

		try {
			String notiId = result.containsKey('noti_id') ? (String) result.get('noti_id') : null;
			Order__c iOrder = (Order__c) JSON.deserialize(JSON.serialize(MethodUtils.getResult('Order__c', result)), Order__c.class);
			System.debug(iOrder);

			Map<String, Object> iOrderTemp = new Map<String, Object>(iOrder.getPopulatedFieldsAsMap());
			if (iOrderTemp.containsKey('System_Status_Text__c') && String.isEmpty((String) iOrderTemp.get('System_Status_Text__c'))) {
				iOrderTemp.remove('System_Status_Text__c');
			}
			if (iOrderTemp.containsKey('User_Status__c') && String.isEmpty((String) iOrderTemp.get('User_Status__c'))) {
				iOrderTemp.remove('User_Status__c');
			}
			iOrder = (Order__c) JSON.deserialize(JSON.serialize(iOrderTemp), Order__c.class);
			if (iOrder != null) {
				if (String.isNotEmpty(iOrder.System_Status_Text__c)) {
					if (iOrder.System_Status_Text__c?.containsIgnoreCase('TECO')) {
						iOrder.Order_Status__c = 'Closed';
					} else if (iOrder.System_Status_Text__c?.containsIgnoreCase('CRTD')) {
						iOrder.Order_Status__c = 'New';
					}
				}
				if (iOrder.Integration_Status__c?.equalsIgnoreCase('Success')) {
					iOrder.Order_Number__c = iOrder.Order_Number__c?.replaceFirst('^0+', '');
					iOrder.Name = iOrder.Order_Number__c;
				} else {
					iOrder.Integration_Status__c = 'Failed';
				}
				iOrder.isIRPA__c = false;
				update iOrder;

				if (String.isNotEmpty(notiId) && iOrder.Integration_Status__c == 'Success') {
					update new Notification__c(Id = notiId, Order__c = iOrder.Id, isIRPA__c = false);
				}
			}

			ApplicationLogUtils.saveLogInbound(endpoint, applog);
			String linkurl = iOrder != null
				? String.format(
						'{0}/{1}',
						new List<String>{ URL.getSalesforceBaseUrl().toExternalForm(), 'lightning/cmp/c__THOR_OrderRecordDisplay?c__recordId=' + iOrder.Id }
				  )
				: '';

			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{
							'success' => iOrder != null,
							'message' => iOrder != null ? iOrder.Integration_Message__c : 'Not found Order Information'
						},
						'result' => new Map<String, Object>{ 'linkurl' => linkurl }
					}
				)
			);
		} catch (Exception e) {
			String msg = String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{ 'success' => false, 'message' => e.getMessage() },
						'result' => new Map<String, Object>{ 'data' => new List<Object>() }
					}
				)
			);
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = msg;
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		}

		return responseDTO;
	}
}