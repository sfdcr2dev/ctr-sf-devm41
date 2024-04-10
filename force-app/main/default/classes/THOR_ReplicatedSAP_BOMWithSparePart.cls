/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 04-04-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
 **/
public with sharing class THOR_ReplicatedSAP_BOMWithSparePart extends MethodUtils implements Database.Batchable<Object>, Database.Stateful {
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
		String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : null;
		String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')) : null;

		Application_Log__c applog = new Application_Log__c(
			External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
			Integration_Name__c = 'THOR_ReplicatedSAP_BOMWithSparePart',
			Method__c = 'Upsert',
			Message_Type__c = 'Success'
			// Request_Body__c = JSON.serialize(requestBody)
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
		} catch (System.JSONException ex) {
			// throw new ParseException('Unknown string format, cannot parse body data. Please try XML or JSON format');
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

		Database.executeBatch(
			new THOR_ReplicatedSAP_BOMWithSparePart(applicationLogId, applog.External_ID__c, body),
			2000
		);
		return dto_response.parse(applog.Response_Body__c);
	}

	private static String getValueResult(String key, Object obj) {
		return ((String) getResult(key, obj))?.trim();
	}

	private Id applicationLogId;
	private String uuid;
	private String inputs;

	private Integer numberOfList = 0;
	private Map<Integer, String> errors = new Map<Integer, String>();
	private List<BOM_with_Spare_Part__c> resultData = new List<BOM_with_Spare_Part__c>();

	public THOR_ReplicatedSAP_BOMWithSparePart(Id applicationLogId, String uuid, String inputs) {
		this.applicationLogId = applicationLogId;
		this.uuid = uuid;
		this.inputs = inputs;
	}

	public Iterable<Object> start(Database.BatchableContext BC) {
		return (List<Object>) getResult('BOMSPLIST', JSON.deserializeUntyped(inputs));
	}

	public void execute(Database.BatchableContext BC, List<Object> scope) {
		Application_Log__c applog = new Application_Log__c(Id = applicationLogId);

		// Map<String, BOM__c> bomMap = new Map<String, BOM__c>();
		Map<String, Spare_Part__c> spMap = new Map<String, Spare_Part__c>();
		List<BOM_with_Spare_Part__c> bspList = new List<BOM_with_Spare_Part__c>();

		/**
		 * @description - data mockup
		{
			"BOMSPLIST": [
				{
					"BOMNO": "00000060",
					"VALIDFROM": "2020-11-12",
					"SPAREPARTNO": "2517400913",
					"ITEM": "0010",
					"UNIT": "PC",
					"QUANTITY": "1.000 "
				},
				{
					"BOMNO": "00000060",
					"VALIDFROM": "2020-11-12",
					"SPAREPARTNO": "2517400913",
					"ITEM": "0010",
					"UNIT": "PC",
					"QUANTITY": "1.000 "
				}
			]
		}
		 */

		String errorMessage;
		try {
			for (Object obj : scope) {
				String bomNo = getValueResult('BOMNO', obj);
				String sparePartNo = getValueResult('SPAREPARTNO', obj);
				String quantity = getValueResult('QUANTITY', obj);
				String item = getValueResult('ITEM', obj);
				String unit = getValueResult('UNIT', obj);
				String validFrom = getValueResult('VALIDFROM', obj);

				// if (String.isNotEmpty(bomNo)) {
				// 	bomMap.put(bomNo, new BOM__c(Name = bomNo));
				// }
				if (String.isNotEmpty(sparePartNo)) {
					spMap.put(sparePartNo, new Spare_Part__c(Name = sparePartNo, Material_Number__c = sparePartNo));
				}

				// if (String.isNotEmpty(validFrom)) {
				// 	List<String> tempDate = validFrom.trim().split('/');
				// 	validFrom = String.format(
				// 		'{0}-{1}-{2}',
				// 		new List<String>{ tempDate.get(2), tempDate.get(1), tempDate.get(0) }
				// 	);
				// }
				bspList.add(
					new BOM_with_Spare_Part__c(
						BOMNo__r = new BOM__c(Name = bomNo),
						sparePartNo__r = new Spare_Part__c(Name = sparePartNo),
						validFrom__c = validFrom != null ? Date.valueOf(validFrom) : null,
						item__c = item,
						unit__c = unit,
						quantity__c = quantity != null ? Double.valueOf(quantity) : null,
						bomWithSparePartKey__c = bomNo + item
					)
				);
			}

			// if (bomMap.size() > 0) {
			// 	upsert bomMap.values() Name;
			// }
			if (spMap.size() > 0) {
				upsert spMap.values() Name;
			}
			if (bspList.size() > 0) {
				// upsert bspList bomWithSparePartKey__c;
				for (
					Database.UpsertResult ur : Database.upsert(
						bspList,
						BOM_with_Spare_Part__c.fields.bomWithSparePartKey__c,
						false
					)
				) {
					if (!ur.isSuccess()) {
						for (Database.Error de : ur.getErrors()) {
							errors.put(errors.size(), de.getMessage());
						}
					} else {
						numberOfList += 1;
					}
				}
				resultData.addAll(bspList);
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