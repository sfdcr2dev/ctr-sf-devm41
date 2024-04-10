public with sharing class THOR_BApiItemHelper {
	public class Result {
	}

	public class dto_response extends WebServiceExtend.dto_response {
		public Result result { get; set; }
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	// Integrate the Response Item
	public static dto_response execute(String endpoint, Map<String, Object> result) {
        /*
		dto_response responseDTO = new dto_response();
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = String.valueOf(result.get('uuid')),
			// Integration_Name__c = '',
			Method__c = 'Create',
			SAP_Response_Body__c = JSON.serialize(result)
		);

		try {
			Item__c iItem = (Item__c) JSON.deserialize(JSON.serialize(MethodUtils.getResult('Item__c', result)), Item__c.class);
			System.debug(iItem);
			if (iItem != null) {
				// update iItem;
				applog.Message_Type__c = iItem.Item_No__c != null ? 'Success' : 'Fail';
				ApplicationLogUtils.saveLogInbound(endpoint, applog);
			}

			String linkurl = iItem != null
				? String.format(
						'{0}/{1}',
						new List<String>{ URL.getSalesforceBaseUrl().toExternalForm(), 'lightning/cmp/c__THOR_ItemRecordDisplay?c__recordId=' + iItem.Id }
				  )
				: '';

			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{
							'success' => iItem != null,
							'message' => iItem != null ? '' : 'Not found Item Information',
							'linkurl' => linkurl
						},
						'result' => new Map<String, Object>{}
					}
				)
			);
		} catch (DmlException e) {
			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{ 'success' => false, 'message' => e.getDmlMessage(0) },
						'result' => new Map<String, Object>{ 'data' => new List<Object>() }
					}
				)
			);
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = e.getDmlMessage(0);
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		}

		return responseDTO;
		*/
        
        dto_response responseDTO = new dto_response();
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = String.valueOf(result.get('uuid')),
			// Integration_Name__c = '',
			Method__c = 'Create',
			SAP_Response_Body__c = JSON.serialize(result)
		);

		try {
			Map<String, Item__c> resItemMap = new Map<String, Item__c>();
			Map<String, Cause__c> resCauseMap = new Map<String, Cause__c>();
			Map<String, Activity__c> resActivityMap = new Map<String, Activity__c>();
			List<Object> response_batch = (List<Object>) result.get('items');

			for (Object obj : response_batch) {
				String itemId = (String) MethodUtils.getResult('Id', obj);
				String itemNo = (String) MethodUtils.getResult('Item_No__c', obj);
				List<Object> causes = (List<Object>) MethodUtils.getResult('Cause__c', obj);
				List<Object> activities = (List<Object>) MethodUtils.getResult('Activity__c', obj);
				String integrationStatus = (String) MethodUtils.getResult('Integration_Status__c', obj);
				String integrationMessage = (String) MethodUtils.getResult('Integration_Message__c', obj);

				Item__c item = new Item__c(
					Item_No__c = String.valueOf(Decimal.valueOf(itemNo)),
					Integration_Status__c = integrationStatus,
					Integration_Message__c = integrationMessage
				);

				resItemMap.put(itemId, item);

				for (Object causeObj : causes) {
                    String causeId = (String) MethodUtils.getResult('Id', causeObj);
					String sortNo = (String) MethodUtils.getResult('Sort_No__c', causeObj);
					String causeNo = (String) MethodUtils.getResult('Cause_No__c', causeObj);
					String causeIntegrationStatus = (String) MethodUtils.getResult('Integration_Status__c', causeObj);
					String causeIntegrationMessage = (String) MethodUtils.getResult('Integration_Message__c', causeObj);

					Cause__c cause = new Cause__c(
						Cause_No__c = String.valueOf(Decimal.valueOf(causeNo)),
						Integration_Status__c = causeIntegrationStatus,
						Integration_Message__c = causeIntegrationMessage
					);

                    //String keyText = String.format('{0}-{1}', new List<String>{ itemNo, causeNo } );
					//String keyText = String.format( '{0}-{1}', new List<String>{ itemId, String.valueOf(Decimal.valueOf(sortNo))} );
					String keyText = causeId;
					resCauseMap.put(keyText, cause);
				}

				for (Object activityObj : activities) {
                    String activityId = (String) MethodUtils.getResult('Id', activityObj);
					String sortNo = (String) MethodUtils.getResult('Sort_No__c', activityObj);
					String activityNo = (String) MethodUtils.getResult('Activity_No__c', activityObj);
					String activityIntegrationStatus = (String) MethodUtils.getResult('Integration_Status__c', activityObj);
					String activityIntegrationMessage = (String) MethodUtils.getResult('Integration_Message__c', activityObj);

					Activity__c activity = new Activity__c(
						Activity_No__c = String.valueOf(Decimal.valueOf(activityNo)),
						Integration_Status__c = activityIntegrationStatus,
						Integration_Message__c = activityIntegrationMessage
					);

					//String keyText = String.format('{0}-{1}', new List<String>{ itemNo, activityNo } );
					//String keyText = String.format( '{0}-{1}', new List<String>{ itemId, String.valueOf(Decimal.valueOf(sortNo))} );
					String keyText = activityId;
					resActivityMap.put(keyText, activity);
				}
			}

			System.debug('resItemMap: ' + resItemMap);
			System.debug('resCauseMap: ' + resCauseMap);
			System.debug('resActivityMap: ' + resActivityMap);

			List<String> itemIdList = new List<String>(resItemMap.keySet());
			List<Item__c> itemList = [SELECT Id, Notification__c, Integration_Status__c, Integration_Message__c FROM Item__c WHERE Id IN :itemIdList];
			for (Item__c item : itemList) {
				item.Item_No__c = String.valueOf(Decimal.valueOf(resItemMap.get(item.Id).Item_No__c));
				item.NotiItem__c = String.valueOf(item.Notification__c) + String.valueOf(Decimal.valueOf(resItemMap.get(item.Id).Item_No__c));
				item.Integration_Status__c = resItemMap.get(item.Id).Integration_Status__c;
				item.Integration_Message__c = resItemMap.get(item.Id).Integration_Message__c;
			}

			List<Cause__c> causeList = [SELECT Id, Cause_No__c, Sort_No__c, Item__c, Item__r.Notification__c, Item__r.Item_No__c, Integration_Status__c, Integration_Message__c FROM Cause__c WHERE Item__c IN :itemIdList];
			List<Cause__c> updateCauseList = new List<Cause__c>();
			for (Cause__c cause : causeList) {
				//String keyText = String.format( '{0}-{1}', new List<String>{ cause.Item__c, cause.Sort_No__c} );
				String keyText = cause.Id;
				System.debug('Cause KeyText: ' + keyText);
				if (resCauseMap.containsKey(keyText)) {
					cause.Cause_No__c = String.valueOf(Decimal.valueOf(resCauseMap.get(keyText).Cause_No__c));
					cause.ItemCause__c = String.valueOf(cause.Item__r.Notification__c) + String.valueOf(Decimal.valueOf(resItemMap.get(cause.Item__c).Item_No__c)) + String.valueOf(Decimal.valueOf(resCauseMap.get(keyText).Cause_No__c));
					cause.Integration_Status__c = resCauseMap.get(keyText).Integration_Status__c;
					cause.Integration_Message__c = resCauseMap.get(keyText).Integration_Message__c;
					updateCauseList.add(cause);
				}
			}

			List<Activity__c> activityList = [SELECT Id, Activity_No__c, Sort_No__c, Item__c, Item__r.Notification__c, Item__r.Item_No__c, Integration_Status__c, Integration_Message__c FROM Activity__c WHERE Item__c IN :itemIdList];
			List<Activity__c> updateActivityList = new List<Activity__c>();
			for (Activity__c activity : activityList) {
				//String keyText = String.format( '{0}-{1}', new List<String>{ activity.Item__c, activity.Sort_No__c} );
				String keyText = activity.Id;
				System.debug('Cause KeyText: ' + keyText);
				if (resActivityMap.containsKey(keyText)) {
					activity.Activity_No__c = String.valueOf(Decimal.valueOf(resActivityMap.get(keyText).Activity_No__c));
					activity.ItemActivity__c = String.valueOf(activity.Item__r.Notification__c) + String.valueOf(Decimal.valueOf(resItemMap.get(activity.Item__c).Item_No__c)) + String.valueOf(Decimal.valueOf(resActivityMap.get(keyText).Activity_No__c));
					activity.Integration_Status__c = resActivityMap.get(keyText).Integration_Status__c;
					activity.Integration_Message__c = resActivityMap.get(keyText).Integration_Message__c;
					updateActivityList.add(activity);
				}
			}

			System.debug('itemList: ' + itemList);
			System.debug('causeList: ' + causeList);
			System.debug('updateCauseList: ' + updateCauseList);
			System.debug('activityList: ' + activityList);
			System.debug('updateActivityList: ' + updateActivityList);

			Boolean isSuccess = true;
			try {
				update itemList;
				update updateCauseList;
				update updateActivityList;
			} catch (Exception e) {
				isSuccess = false;
				System.debug(System.LoggingLevel.ERROR, String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() }));
			}

			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{ 'success' => isSuccess, 'message' => isSuccess ? '' : 'Some component are failed' },
						'result' => new Map<String, Object>{
							//'linkurl' => String.format('{0}/{1}', new List<Object>{ URL.getSalesforceBaseUrl().toExternalForm(), itemList.get(0).Id })
							'linkurl' => ''
						}
					}
				)
			);
			applog.Message_Type__c = isSuccess ? 'Success' : 'Failed';
			applog.Error_Message__c = isSuccess ? '' : 'Some component are failed';
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		} catch(Exception e) {
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