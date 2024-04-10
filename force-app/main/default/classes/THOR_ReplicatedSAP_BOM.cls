/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 04-04-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
 **/
public with sharing class THOR_ReplicatedSAP_BOM extends MethodUtils implements Database.Batchable<Object>, Database.Stateful {
	public class ParseException extends Exception {
	}
	public class dto_response extends WebServiceExtend.dto_response {
		public List<String> recordIds { get; set; }
		public Map<Integer, String> errors { get; set; }
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
		// String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : null;
		String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')) : null;
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = Uuid.randomUUID(),
			Integration_Name__c = 'THOR_ReplicatedSAP_BOM',
			Method__c = 'Upsert',
			Message_Type__c = 'Success'
		);

		try {
			// below converts blob to hexadecimal representation; four ones and zeros
			// from blob will get converted to single hexadecimal character
			String hexString = EncodingUtil.convertToHex(Blob.valueOf(body));

			// One byte consists of eight ones and zeros so, one byte consists of two
			// hex characters, hence the number of bytes would be
			Integer numberOfMB = hexString.length() / (2 * 8 * 1024 * 1024); // (bit * byte * KB * MB)
			if (numberOfMB >= 6) {
				throw new ParseException(
					'The "Apex heap size too large" error occurs when too much data is being stored in memory during processing'
				);
			}
			// applog.Request_Body__c = JSON.serialize(MethodUtils.setResultByKeypath('body', parsedBody, requestBody));
		} catch (System.JSONException ex) {
			applog.Error_Message__c = ex.getMessage();
			applog.Message_Type__c = 'Fail';
			applog.Response_Body__c = JSON.serialize(
				new Map<String, Object>{
					'description' => new Map<String, Object>{
						'success' => false,
						'message' => 'Unknown string format, cannot parse body data. Please try JSON format.',
						'linkurl' => applog.External_ID__c
					}
				}
			);
			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
			return dto_response.parse(applog.Response_Body__c);
		}

		applog.Response_Body__c = JSON.serialize(
			new Map<String, Object>{
				'description' => new Map<String, Object>{
					'success' => true,
					'message' => 'Process is starting run batch execution.',
					'linkurl' => applog.External_ID__c
				},
				'recordIds' => new List<Object>()
			}
		);
		Id applicationLogId = ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

		Database.executeBatch(new THOR_ReplicatedSAP_BOM(applicationLogId, applog.External_ID__c, body), 2000);
		return dto_response.parse(applog.Response_Body__c);
	}

	private static String getValueResult(String key, Object obj) {
		return ((String) getResult(key, obj))?.trim();
	}

	private Id applicationLogId;
	private String uuid;
	private String inputs;
	private Map<String, Master_Map__c> masterMapPlantMap;

	private Integer numberOfList = 0;
	private Map<Integer, String> errors = new Map<Integer, String>();
	private List<BOM__c> resultData = new List<BOM__c>();

	public THOR_ReplicatedSAP_BOM(Id applicationLogId, String uuid, String inputs) {
		this.applicationLogId = applicationLogId;
		this.uuid = uuid;
		this.inputs = inputs;
		this.masterMapPlantMap = new Map<String, Master_Map__c>();
		for (Master_Map__c mm : [SELECT Id, Name, Type__c FROM Master_Map__c WHERE Type__c = 'Plant']) {
			masterMapPlantMap.put(mm.Name, mm);
		}
	}

	public Iterable<Object> start(Database.BatchableContext BC) {
		return (List<Object>) getResult('BOMLIST', JSON.deserializeUntyped(inputs));
	}

	public void execute(Database.BatchableContext BC, List<Object> scope) {
		Map<String, Equipment__c> upsertedEQ = new Map<String, Equipment__c>();
		List<BOM__c> upsertedBOM = new List<BOM__c>();

		String errorMessage;
		try {
			/**
				 * @description - data mock up
				 {
					"BOMLIST": [
						{
							"BOMNO": "00000060",
							"EQUIPMENT": "20000005          ",
							"PLANT": "1200",
							"BOMUSAGE": "4",
							"ALTERNATEBOM": "1 ",
							"BOMCATEGORY": "E"
						},
						{
							"BOMNO": "00000060",
							"EQUIPMENT": "20000005          ",
							"PLANT": "2200",
							"BOMUSAGE": "4",
							"ALTERNATEBOM": "1 ",
							"BOMCATEGORY": "E"
						}
					]
				}
			*/
			for (Object bom : scope) {
				String equipment = ((String) getResult('EQUIPMENT', bom)).trim();
				if (String.isNotEmpty(equipment)) {
					upsertedEQ.put(equipment, new Equipment__c(Name = equipment));
				}

				String plant = getValueResult('PLANT', bom);
				upsertedBOM.add(
					new BOM__c(
						Name = getValueResult('BOMNO', bom),
						Equipment__r = new Equipment__c(Name = equipment),
						BOMUsage__c = getValueResult('BOMUSAGE', bom),
						alternateBOM__c = getValueResult('ALTERNATEBOM', bom),
						BOMCategory__c = getValueResult('BOMCATEGORY', bom),
						plant__c = masterMapPlantMap.get(plant)?.Id
					)
				);
			}
			if (upsertedEQ.values().size() > 0) {
				upsert upsertedEQ.values() Name;
			}

			if (upsertedBOM.size() > 0) {
				// upsert upsertedBOM Name;
				for (Database.UpsertResult ur : Database.upsert(upsertedBOM, BOM__c.fields.Name, false)) {
					if (!ur.isSuccess()) {
						for (Database.Error de : ur.getErrors()) {
							errors.put(errors.size(), de.getMessage());
						}
					} else {
						numberOfList += 1;
					}
				}
				resultData.addAll(upsertedBOM);
			}
		} catch (Exception ex) {
			errors.put(errors.size(), dto_response.getErrorMessageException(ex));
		}
	}

	public void finish(Database.BatchableContext BC) {
		ApplicationLogUtils.saveLog(
			new Application_Log__c(
				Id = applicationLogId,
				Response_Body__c = JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{
							'success' => true,
							'message' => String.format(
								'{0} Success Records - {1} Error Records',
								new List<Object>{ numberOfList.format(), errors.size() }
							),
							'linkurl' => uuid
						},
						'errors' => errors
					}
				)
			)
		);
	}
}