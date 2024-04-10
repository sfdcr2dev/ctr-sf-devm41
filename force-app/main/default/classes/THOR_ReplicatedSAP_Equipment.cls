public class THOR_ReplicatedSAP_Equipment implements Database.Batchable<Object>, Database.Stateful {

    public class ParseException extends Exception {}

    public class dto_response extends WebserviceExtend.dto_response {}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

    public class EquipmentFromSAP {
		public String equipmentCategory { get; set; }
        public String equipmentNo { get; set; }
		public String description { get; set; }
		public String systemStatus { get; set; }
		public String userStatus { get; set; }
		public String FL { get; set; }
		public String objectType { get; set; }
		public String location { get; set; }
		public String manufacturer { get; set; }
		public String manufacturerNo { get; set; }
		public String modelNo { get; set; }
		public String ABCIndicator { get; set; }
		public String costCenter { get; set; }
		public String mainWorkCenter { get; set; }
		public String maintenancePlant { get; set; }
		public String companyCode { get; set; }
		public String plantSection { get; set; }
		public String plannerGroup { get; set; }
		public String planningPlant { get; set; }
		public String catelogProfile { get; set; }
		public String sortField { get; set; }
		public String asset { get; set; }
		public String subNumber { get; set; }
	}

	private static final Map<String, Map<String, Master_Map__c>> MasterMaps {
		get {
			if (MasterMaps == null) {
				MasterMaps = new Map<String, Map<String, Master_Map__c>>();
				for (Master_Map__c master : [
					SELECT
						Id,
						Name,
						Type__c
					FROM Master_Map__c
					WHERE
						Type__c = 'Plant'
						OR Type__c = 'Main Work Center'
						OR Type__c = 'PlannerGroup'
						OR Type__c = 'CompanyCode'
						OR Type__c = 'CatelogProfile'
				]) {
					if (!MasterMaps.containsKey(master.Type__c)) {
						MasterMaps.put(master.Type__c, new Map<String, Master_Map__c>());
					}
					MasterMaps.get(master.Type__c).put(master.Name, master);
				}
			}
			return MasterMaps;
		}
		set;
	}

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
		String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')) : '';

		Database.executeBatch(new THOR_ReplicatedSAP_Equipment(request.requestURI, body));

		return dto_response.parse(
			JSON.serialize(
				new Map<String, Object>{
					'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => '' },
					'recordIds' => null
				}
			)
		);

		// Application_Log__c applog = new Application_Log__c(
		// 	External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
		// 	Integration_Name__c = 'THOR_ReplicatedSAP_Equipment',
		// 	Method__c = 'Upsert',
		// 	Message_Type__c = 'Success',
		// 	Request_Body__c = JSON.serialize(requestBody)
		// );

		// List<EquipmentFromSAP> eqList;
		// try {
		// 	eqList = parseJSONInputs(body);
		// } catch (Exception ex) {
		// 	applog.Error_Message__c = ex.getMessage();
		// 	applog.Message_Type__c = 'Fail';
		// 	applog.Response_Body__c = JSON.serialize(
		// 		new Map<String, Object>{
		// 			'description' => new Map<String, Object>{
		// 				'success' => false,
		// 				'message' => 'Unknown string format, cannot parse body data. Please try JSON format.',
		// 				'linkurl' => applog.External_ID__c
		// 			}
		// 		}
		// 	);
		// 	ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		// 	return dto_response.parse(applog.Response_Body__c);
		// }

		// if (eqList == null || eqList.size() == 0) {
		// 	applog.Response_Body__c = JSON.serialize(
		// 		new Map<String, Object>{
		// 			'description' => new Map<String, Object>{
		// 				'success' => false,
		// 				'message' => 'Not found Functional Location Information',
		// 				'linkurl' => applog.External_ID__c
		// 			}
		// 		}
		// 	);
		// 	ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		// 	return dto_response.parse(applog.Response_Body__c);
		// }

		// Database.executeBatch(new THOR_ReplicatedSAP_Equipment(request.requestURI, eqList));

        // applog.Response_Body__c = JSON.serialize(
		// 	new Map<String, Object>{
		// 		'description' => new Map<String, Object>{
		// 			'success' => true,
		// 			'message' => '',
		// 			'linkurl' => applog.External_ID__c
		// 		},
		// 		'recordIds' => (new Map<Id, Equipment__c>()).keySet()
		// 	}
		// );
		// ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

		// return dto_response.parse(applog.Response_Body__c);
    }

    private static List<EquipmentFromSAP> parseJSONInputs(String body) {
		Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
		List<Object> eqList = (List<Object>) MethodUtils.getResult('EQLIST', parsedBody);

		List<EquipmentFromSAP> inputs = new List<EquipmentFromSAP>();
		for (Object rawInput : eqList) {
			EquipmentFromSAP equipment = createEquipmentFromSAP(rawInput);
			inputs.add(equipment);
		}

		return inputs;
    }

    public static EquipmentFromSAP createEquipmentFromSAP(Object json) {
		Map<String, Object> eqMap = (Map<String, Object>) json;
		EquipmentFromSAP eq = new EquipmentFromSAP();

		eq.equipmentCategory = (String) MethodUtils.getResult('EQUIPMENTCATEGORY', json);
		eq.equipmentNo = (String) MethodUtils.getResult('EQUIPMENTNO', json);
		eq.description = (String) MethodUtils.getResult('DESCRIPTION', json);
		eq.systemStatus = (String) MethodUtils.getResult('SYSTEMSTATUS', json);
		eq.userStatus = (String) MethodUtils.getResult('USERSTATUS', json);
		eq.FL = (String) MethodUtils.getResult('FL', json);
		eq.objectType = (String) MethodUtils.getResult('OBJECTTYPE', json);
		eq.location = (String) MethodUtils.getResult('LOCATION', json);
		eq.manufacturer = (String) MethodUtils.getResult('MANUFACTURER', json);
		eq.manufacturerNo = (String) MethodUtils.getResult('MANUFACTURERNO', json);
		eq.modelNo = (String) MethodUtils.getResult('MODELNO', json);
		eq.ABCIndicator = (String) MethodUtils.getResult('ABCINDICATOR', json);
		eq.costCenter = (String) MethodUtils.getResult('COSTCENTER', json);
		eq.mainWorkCenter = (String) MethodUtils.getResult('MAINWORKCENTER', json);
		eq.maintenancePlant = (String) MethodUtils.getResult('MAINTENANCEPLANT', json);
		eq.companyCode = (String) MethodUtils.getResult('COMPANYCODE', json);
		eq.plantSection = (String) MethodUtils.getResult('PLANTSECTION', json);
		eq.plannerGroup = (String) MethodUtils.getResult('PLANNERGROUP', json);
		eq.planningPlant = (String) MethodUtils.getResult('PLANNINGPLANT', json);
		eq.catelogProfile = (String) MethodUtils.getResult('CATELOGPROFILE', json);
		eq.sortField = (String) MethodUtils.getResult('SORTFIELD', json);
		eq.asset = (String) MethodUtils.getResult('ASSET', json);
		eq.subNumber = (String) MethodUtils.getResult('SUBNUMBER', json);

		return eq;
	}

	public static List<Equipment__c> saveEquipment(List<Object> eqList, Map<String, List<String>> errors) {
		List<Equipment__c> upsertedEqp = new List<Equipment__c>();

		for (Object eqObj : eqList) {
			EquipmentFromSAP eq = createEquipmentFromSAP(eqObj);
			Equipment__c ieq = new Equipment__c();
			ieq.Name = eq.equipmentNo;
			ieq.equipmentCategory__c = eq.equipmentCategory;
			ieq.description__c = eq.description;
			ieq.systemStatus__c = eq.systemStatus;
			ieq.userStatus__c = eq.userStatus;
			ieq.location__c = eq.location;
			ieq.manufacturer__c = eq.manufacturer;
			ieq.manufacturerNo__c = eq.manufacturerNo;
			ieq.modelNo__c = eq.modelNo;
			ieq.ABCIndicator__c = eq.ABCIndicator;
			ieq.costCenter__c = eq.costCenter;
			ieq.plantSection__c = eq.plantSection;
			ieq.sortField__c = eq.sortField;
			ieq.asset__c = eq.asset;
			ieq.subNumber__c = eq.subNumber;
			ieq.Object_Type__c = eq.objectType;
			ieq.mainWorkCenter__c = MasterMaps.get('Main Work Center')?.get(eq.mainWorkCenter)?.Id;
			ieq.maintenancePlant__c = MasterMaps.get('Plant')?.get(eq.maintenancePlant)?.Id;
			ieq.planningPlant__c = MasterMaps.get('Plant')?.get(eq.maintenancePlant)?.Id;
			ieq.companyCode__c = MasterMaps.get('CompanyCode')?.get(eq.companyCode)?.Id;
			ieq.plannerGroup__c = MasterMaps.get('PlannerGroup')?.get(eq.plannerGroup)?.Id;
			ieq.catelogProfile__c = MasterMaps.get('CatelogProfile')?.get(eq.catelogProfile)?.Id;
			ieq.FL_Text__c = eq.FL;

			upsertedEqp.add(ieq);
		}

		if (upsertedEqp.size() > 0) {
			//upsert upsertedEqp Name;
			List<Database.UpsertResult> upsertResults = Database.upsert(upsertedEqp, Equipment__c.Field.Name, false);
            THOR_ReplicatedSAP_CatelogProfile.addErrorToList(upsertResults, errors);
		}
		
		return upsertedEqp;
	}

    // public static List<Equipment__c> saveEquipment(List<EquipmentFromSAP> eqList, Map<String, List<String>> errors) {
	// 	List<Equipment__c> upsertedEqp = new List<Equipment__c>();

	// 	for (EquipmentFromSAP eq : eqList) {
	// 		Equipment__c ieq = new Equipment__c();
	// 		ieq.Name = eq.equipmentNo;
	// 		ieq.equipmentCategory__c = eq.equipmentCategory;
	// 		ieq.description__c = eq.description;
	// 		ieq.systemStatus__c = eq.systemStatus;
	// 		ieq.userStatus__c = eq.userStatus;
	// 		ieq.location__c = eq.location;
	// 		ieq.manufacturer__c = eq.manufacturer;
	// 		ieq.manufacturerNo__c = eq.manufacturerNo;
	// 		ieq.modelNo__c = eq.modelNo;
	// 		ieq.ABCIndicator__c = eq.ABCIndicator;
	// 		ieq.costCenter__c = eq.costCenter;
	// 		ieq.plantSection__c = eq.plantSection;
	// 		ieq.sortField__c = eq.sortField;
	// 		ieq.asset__c = eq.asset;
	// 		ieq.subNumber__c = eq.subNumber;
	// 		ieq.Object_Type__c = eq.objectType;
	// 		ieq.mainWorkCenter__c = MasterMaps.get('Main Work Center')?.get(eq.mainWorkCenter)?.Id;
	// 		ieq.maintenancePlant__c = MasterMaps.get('Plant')?.get(eq.maintenancePlant)?.Id;
	// 		ieq.planningPlant__c = MasterMaps.get('Plant')?.get(eq.maintenancePlant)?.Id;
	// 		ieq.companyCode__c = MasterMaps.get('CompanyCode')?.get(eq.companyCode)?.Id;
	// 		ieq.plannerGroup__c = MasterMaps.get('PlannerGroup')?.get(eq.plannerGroup)?.Id;
	// 		ieq.catelogProfile__c = MasterMaps.get('CatelogProfile')?.get(eq.catelogProfile)?.Id;
	// 		ieq.FL_Text__c = eq.FL;

	// 		upsertedEqp.add(ieq);
	// 	}

	// 	if (upsertedEqp.size() > 0) {
	// 		//upsert upsertedEqp Name;
	// 		List<Database.UpsertResult> upsertResults = Database.upsert(upsertedEqp, Equipment__c.Field.Name, false);
    //         THOR_ReplicatedSAP_CatelogProfile.addErrorToList(upsertResults, errors);
	// 	}
		
	// 	return upsertedEqp;
	// }

	private String inputs;
	//private List<EquipmentFromSAP> equipments;
    private String requestURI;
    private Map<String, List<String>> errors;

	public THOR_ReplicatedSAP_Equipment(String uri, String inputs) {
		this.inputs = inputs;
		requestURI = uri;
		errors = new Map<String, List<String>>();
	}

    // public THOR_ReplicatedSAP_Equipment(String uri, List<EquipmentFromSAP> rawEquipments) {
        // equipments = rawEquipments;
        // requestURI = uri;
        // errors = new Map<String, List<String>>();
    // }

    public Iterable<Object> start(Database.BatchableContext BC) {
        //return equipments;
		Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(inputs);
		return (List<Object>) parsedBody.get('EQLIST');
    }

    public void execute(Database.BatchableContext BC, List<Object> scope) {
		List<Equipment__c> upsertedEqp = saveEquipment(scope, errors);

        Application_Log__c applog = new Application_Log__c(
            External_ID__c = Uuid.randomUUID(),
            Integration_Name__c = 'THOR_ReplicatedSAP_Equipment',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(scope).left(131071),
            Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'errors' => JSON.serialize(errors),
                    'success' => (new Map<Id, Equipment__c>(upsertedEqp)).keySet()
                }
            ).left(131071)
        );

        ApplicationLogUtils.saveLogInbound(requestURI, applog);
    }

    public void finish(Database.BatchableContext BC) {
    }

}