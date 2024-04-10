public class THOR_BApiWorkClearanceHelper {

    public class Result {
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
			Integration_Name__c = 'ZPM_CREATE_CC_NOTIF',
			Method__c = 'Create',
			// Log_Type__c = 'Inbound from ' + endpoint,
			// Message_Type__c =
			// Error_Message__c
			// Request_Body__c
			SAP_Response_Body__c = JSON.serialize(result)
		);

		try {
			Work_Clearance__c wc = (Work_Clearance__c) JSON.deserialize(
				JSON.serialize(MethodUtils.getResult('Work_Clearance__c', result)),
				Work_Clearance__c.class
			);

			if (wc != null) {
				//wc.isBAPI__c = true;
				List<Work_Clearance__c> works = [SELECT Id, Name, Extend_No__c, Integration_Status__c, Integration_Message__c, User_Status__c, System_Status__c FROM Work_Clearance__c WHERE Id = :wc.Id];
				System.debug('work => ' + works);
				if (works.size() > 0) {
					Work_Clearance__c work = works[0];
					if (!String.isEmpty(wc.Name)) {
						work.Name = wc.Name;
					}
					if (!String.isEmpty(wc.Extend_No__c)) {
						work.Extend_No__c = wc.Extend_No__c;
					}
					if (!String.isEmpty(wc.Integration_Status__c)) {
						work.Integration_Status__c = wc.Integration_Status__c;
					} else {
						work.Integration_Status__c = 'Failed';
					}
					if (!String.isEmpty(wc.Integration_Message__c)) {
						work.Integration_Message__c = wc.Integration_Message__c;
					}
					if (!String.isEmpty(wc.System_Status__c)) {
						work.System_Status__c = wc.System_Status__c;
					}
					if (!String.isEmpty(wc.User_Status__c)) {
						work.User_Status__c = wc.User_Status__c;
//						List<String> statusOldList = String.valueOf(work.User_Status__c)?.split(' ');
//						List<String> statusNewList = String.valueOf(wc.User_Status__c)?.split(' ');
//						if (statusOldList.size() > 0) {
//							Set<String> statusSet = new Set<String>();
//							for (String status : statusOldList) {
//								statusSet.add(status);
//							}
//							for (String status : statusNewList) {
//								statusSet.add(status);
//							}
//							List<String> statusList = new List<String>(statusSet);
//							statusList.sort();
//							work.User_Status__c = String.join(statusList, ' ');
//						} else {
//							work.User_Status__c = wc.User_Status__c;
//						}
					}
					update work;
				}
				//update wc;
				System.debug('WC -> ' + wc);
				applog.Message_Type__c = wc.Integration_Status__c?.equalsIgnoreCase('Success') ? 'Success' : 'Fail';
				ApplicationLogUtils.saveLogInbound(endpoint, applog);

				pushNotificationIntegrationSAP(new List<Work_Clearance__c>{wc});
			}

			String linkurl = wc != null
				? String.format(
						'{0}/{1}',
						new List<String>{ URL.getSalesforceBaseUrl().toExternalForm(), 'lightning/cmp/c__THOR_WorkClearanceRecordDisplay?c__recordId=' + wc.Id }
				  )
				: '';

			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{
							'success' => wc != null,
							'message' => wc != null ? '' : 'Not found Work Clearance Information'
						},
						'result' => new Map<String, Object>{ 'linkurl' => linkurl }
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
    }

	public static void pushNotificationIntegrationSAP(List<Work_Clearance__c> workclearances) {
		Id customNotiTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'THOR_Push_Notification']?.Id;
		// Integration failed : Please contact system admin
		// Work Clearance : (Salesforce ID)
		try {
			Set<String> idSet = new Set<String>();
			for (Work_Clearance__c w : workclearances) {
				idSet.add(w.Id);
			}

			List<Work_Clearance__c> workclearanceList = [SELECT Id, Name, Work_Clearance__c, FunctionalLocation__r.Name, Integration_Status__c, Integration_Message__c, CreatedById FROM Work_Clearance__c WHERE Id IN :idSet];
			for (Work_Clearance__c work : workclearanceList) {
				if (work.Integration_Status__c != null && !work.Integration_Status__c?.equalsIgnoreCase('In Progress')) {
					CustomNotificationHelper.sendAlert(
						CustomNotificationHelper.buildAlert(
							customNotiTypeId,
							JSON.serialize(
								new Map<String, Object>{
									'type' => 'standard__component',
									'attributes' => new Map<String, Object>{ 'componentName' => 'c__THOR_WorkClearanceRecordDisplay' },
									'state' => new Map<String, Object>{ 'c__recordId' => work.Id }
								}
							),
							String.format(
								'Work Clearance : {1}\r\n{2}\r\n{0}',
								new List<String>{
									work.Integration_Status__c?.equalsIgnoreCase('Success') ? '' : 'Please contact system admin\r\n',
									work.Integration_Status__c?.equalsIgnoreCase('Success') ? work.Work_Clearance__c : work.Name,
									String.format('FL : {0}', new List<String>{ work.FunctionalLocation__r.Name })
								}
							),
							String.format(
								'{0}',
								new List<String>{ work.Integration_Status__c?.equalsIgnoreCase('Success') ? 'Integration Success :' : 'Integration Failed :' }
							)
						),
						new Set<String>{ work.CreatedById }
					);
				}
			}
		} catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() }));
		}
	}
}