public class THOR_ReplicatedSAP_FunctionalLocation extends MethodUtils implements Database.Batchable<Object>, Database.Stateful {
	// public class ParseException extends Exception {
	// }

	public class dto_response extends WebserviceExtend.dto_response {
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	// public class FLFromSAP {
	// 	public String fl { get; set; }
	// 	public String description { get; set; }
	// 	public String subFL { get; set; }
	// 	public String objectType { get; set; }
	// 	public String plannerGroup { get; set; }
	// 	public String planningPlant { get; set; }
	// 	public String authorizeGroup { get; set; }
	// 	public String companyCode { get; set; }
	// 	public String plantSection { get; set; }
	// 	public String location { get; set; }
	// 	public String mainWorkCenter { get; set; }
	// 	public String maintenancePlant { get; set; }
	// 	public String systemStatus { get; set; }
	// 	public String userStatus { get; set; }
	// 	public String costCenter { get; set; }
	// 	public String wbsElement { get; set; }
	// 	public String catelogProfile { get; set; }
	// 	public String mainWorkCenterPlant { get; set; }
	// }

	private static final Map<String, Map<String, Master_Map__c>> MasterMaps {
		get {
			if (MasterMaps == null) {
				MasterMaps = new Map<String, Map<String, Master_Map__c>>();
				for (Master_Map__c master : [
					SELECT Id, Name, Type__c
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
		Database.executeBatch(new THOR_ReplicatedSAP_FunctionalLocation(request.requestURI, body), 1000);

		return dto_response.parse(
			JSON.serialize(
				new Map<String, Object>{
					'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => '' },
					'recordIds' => null
				}
			)
		);
		//		Application_Log__c applog = new Application_Log__c(
		//			External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
		//			Integration_Name__c = 'THOR_ReplicatedSAP_FunctionalLocation',
		//			Method__c = 'Upsert',
		//			Message_Type__c = 'Success',
		//			Request_Body__c = JSON.serialize(requestBody).left(131071)
		//		);

		//		try {

		//		} catch (Exception ex) {
		//			applog.Error_Message__c = ex.getMessage();
		//			applog.Message_Type__c = 'Fail';
		//			applog.Response_Body__c = JSON.serialize(
		//				new Map<String, Object>{
		//					'description' => new Map<String, Object>{
		//						'success' => false,
		//						'message' => 'Unknown string format, cannot parse body data. Please try JSON format.',
		//						'linkurl' => applog.External_ID__c
		//					}
		//				}
		//			);
		//			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		//			return dto_response.parse(applog.Response_Body__c);

		//			return dto_response.parse(null);
		//		}

		//		if (flList == null || flList.size() == 0) {
		//			applog.Response_Body__c = JSON.serialize(
		//				new Map<String, Object>{
		//					'description' => new Map<String, Object>{
		//						'success' => false,
		//						'message' => 'Not found Functional Location Information',
		//						'linkurl' => applog.External_ID__c
		//					}
		//				}
		//			);
		//			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		//			return dto_response.parse(applog.Response_Body__c);
		//			return dto_response.parse(null);
		//		}

		//        Database.executeBatch(new THOR_ReplicatedSAP_FunctionalLocation(request.requestURI, flList));

		//		applog.Response_Body__c = JSON.serialize(
		//			new Map<String, Object>{
		//				'description' => new Map<String, Object>{
		//					'success' => true,
		//					'message' => '',
		//					'linkurl' => applog.External_ID__c
		//				},
		//				'recordIds' => (new Map<Id, Functional_Location__c>()).keySet()
		//			}
		//		);
		//		ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		//
		//		return dto_response.parse(applog.Response_Body__c);
	}

	// private static List<FLFromSAP> parseJSONInputs(String body) {
	// 	Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
	// 	List<Object> flList = (List<Object>) MethodUtils.getResult('FLLIST', parsedBody);

	// 	List<FLFromSAP> inputs = new List<FLFromSAP>();
	// 	for (Object rawInput : flList) {
	// 		FLFromSAP fl = createFLFromSAP(rawInput);
	// 		inputs.add(fl);
	// 	}

	// 	return inputs;
	// }

	// public static FLFromSAP createFLFromSAP(Object json) {
	// 	FLFromSAP fl = new FLFromSAP();

	// 	fl.fl = (String) MethodUtils.getResult('FL', json);
	// 	fl.description = (String) MethodUtils.getResult('DESCRIPTION', json);
	// 	fl.subFL = (String) MethodUtils.getResult('SUBFL', json);
	// 	fl.objectType = (String) MethodUtils.getResult('OBJECTTYPE', json);
	// 	fl.plannerGroup = (String) MethodUtils.getResult('PLANNERGROUP', json);
	// 	fl.planningPlant = (String) MethodUtils.getResult('PLANNINGPLANT', json);
	// 	fl.authorizeGroup = (String) MethodUtils.getResult('AUTHORIZEGROUP', json);
	// 	fl.companyCode = (String) MethodUtils.getResult('COMPANYCODE', json);
	// 	fl.plantSection = (String) MethodUtils.getResult('PLANTSECTION', json);
	// 	fl.location = (String) MethodUtils.getResult('LOCATION', json);
	// 	fl.mainWorkCenter = (String) MethodUtils.getResult('MAINWORKCENTER', json);
	// 	fl.maintenancePlant = (String) MethodUtils.getResult('MAINTENANCEPLANT', json);
	// 	fl.systemStatus = (String) MethodUtils.getResult('SYSTEMSTATUS', json);
	// 	fl.userStatus = (String) MethodUtils.getResult('USERSTATUS', json);
	// 	fl.costCenter = (String) MethodUtils.getResult('COSTCENTER', json);
	// 	fl.wbsElement = (String) MethodUtils.getResult('WBSELEMENT', json);
	// 	fl.catelogProfile = (String) MethodUtils.getResult('CATELOGPROFILE', json);
	// 	fl.mainWorkCenterPlant = (String) MethodUtils.getResult('MAINWORKCENTERPLANT', json);

	// 	return fl;
	// }

	private static String getValueResult(String key, Object obj) {
		return ((String) getResult(key, obj))?.trim();
	}

	public static List<Functional_Location__c> saveFunctionalLocation(
		List<Object> flList,
		Map<String, List<String>> errors
	) {
		//System.debug(System.LoggingLevel.DEBUG, JSON.serializePretty(flList));
		List<Functional_Location__c> upsertedFL = new List<Functional_Location__c>();

		for (Object iFL : flList) {
			Functional_Location__c fl = new Functional_Location__c();
			fl.Name = getValueResult('FL', iFL);
			fl.Description__c = getValueResult('DESCRIPTION', iFL);
			fl.Object_Type__c = getValueResult('OBJECTTYPE', iFL);
			fl.Parent_Functional_Location_Text__c = getValueResult('SUBFL', iFL);

			String PLANNERGROUP = getValueResult('PLANNERGROUP', iFL);
			fl.PlannerGroup__c = String.isNotEmpty(PLANNERGROUP)
				? MasterMaps.get('PlannerGroup')?.get(PLANNERGROUP)?.Id
				: null;

			String PLANNINGPLANT = getValueResult('PLANNINGPLANT', iFL);
			fl.Planning_Plant__c = String.isNotEmpty(PLANNINGPLANT)
				? MasterMaps.get('Plant')?.get(PLANNINGPLANT)?.Id
				: null;

			String COMPANYCODE = getValueResult('COMPANYCODE', iFL);
			fl.Company_Code__c = String.isNotEmpty(COMPANYCODE)
				? MasterMaps.get('CompanyCode')?.get(COMPANYCODE)?.Id
				: null;

			String MAINWORKCENTER = getValueResult('MAINWORKCENTER', iFL);
			fl.MainWorkCenter__c = String.isNotEmpty(MAINWORKCENTER)
				? MasterMaps.get('Main Work Center')?.get(MAINWORKCENTER)?.Id
				: null;

			String MAINTENANCEPLANT = getValueResult('MAINTENANCEPLANT', iFL);
			fl.Maintenance_Plant__c = String.isNotEmpty(MAINTENANCEPLANT)
				? MasterMaps.get('Plant')?.get(MAINTENANCEPLANT)?.Id
				: null;

			String CATELOGPROFILE = getValueResult('CATELOGPROFILE', iFL);
			fl.CatelogProfile__c = String.isNotEmpty(CATELOGPROFILE)
				? MasterMaps.get('CatelogProfile')?.get(CATELOGPROFILE)?.Id
				: null;

			String MAINWORKCENTERPLANT = getValueResult('MAINWORKCENTERPLANT', iFL);
			fl.mainWorkCenterPlant__c = String.isNotEmpty(MAINWORKCENTERPLANT)
				? MasterMaps.get('Plant')?.get(MAINWORKCENTERPLANT)?.Id
				: null;

			fl.PlantSection__c = getValueResult('PLANTSECTION', iFL);
			fl.Location__c = getValueResult('LOCATION', iFL);
			fl.System_Status__c = getValueResult('SYSTEMSTATUS', iFL);
			fl.User_Status__c = getValueResult('USERSTATUS', iFL);
			fl.CostCenter__c = getValueResult('COSTCENTER', iFL);
			fl.wbsElement__c = getValueResult('WBSELEMENT', iFL);
			fl.Authorize_Group__c = getValueResult('AUTHORIZEGROUP', iFL);
			fl.Latitude__c = getValueResult('ZLATITUDE', iFL);
			fl.Longitude__c = getValueResult('ZLONGITUDE', iFL);

			upsertedFL.add(fl);
		}

		if (upsertedFL.size() > 0) {
			//upsert upsertedFL Name;
			List<Database.UpsertResult> upsertResults = Database.upsert(
				upsertedFL,
				Functional_Location__c.Field.Name,
				false
			);
			THOR_ReplicatedSAP_CatelogProfile.addErrorToList(upsertResults, errors);
		}

		return upsertedFL;
	}

	// private List<Object> flList;
	private String inputs;
	private String requestURI;
	private Map<String, List<String>> errors;

	public THOR_ReplicatedSAP_FunctionalLocation(String uri, String inputs) {
		this.inputs = inputs;

		requestURI = uri;
		errors = new Map<String, List<String>>();
	}

	public Iterable<Object> start(Database.BatchableContext BC) {
		Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(inputs);
		return (List<Object>) parsedBody.get('FLLIST');
	}

	public void execute(Database.BatchableContext BC, List<Object> scope) {
		List<Functional_Location__c> upsertedFL = saveFunctionalLocation(scope, errors);

		Application_Log__c applog = new Application_Log__c(
			External_ID__c = Uuid.randomUUID(),
			Integration_Name__c = 'THOR_ReplicatedSAP_FunctionalLocation',
			Method__c = 'Upsert',
			Message_Type__c = 'Success',
			Request_Body__c = System.JSON.serializePretty(scope).left(121071),
			Response_Body__c = ''
			//JSON.serialize(
			//    new Map<String, Object>{
			//        'errors' => JSON.serialize(errors),
			//        'success' => (new Map<Id, Functional_Location__c>(upsertedFL)).keySet()
			//    }
			//).left(131071)
		);

		ApplicationLogUtils.saveLogInbound(requestURI, applog);
	}

	public void finish(Database.BatchableContext BC) {
	}
}

/*
public class THOR_ReplicatedSAP_FunctionalLocation extends MethodUtils implements Database.Batchable<Object>, Database.Stateful {
	// public class ParseException extends Exception {
	// }

	public class dto_response extends WebserviceExtend.dto_response {
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	// public class FLFromSAP {
	// 	public String fl { get; set; }
	// 	public String description { get; set; }
	// 	public String subFL { get; set; }
	// 	public String objectType { get; set; }
	// 	public String plannerGroup { get; set; }
	// 	public String planningPlant { get; set; }
	// 	public String authorizeGroup { get; set; }
	// 	public String companyCode { get; set; }
	// 	public String plantSection { get; set; }
	// 	public String location { get; set; }
	// 	public String mainWorkCenter { get; set; }
	// 	public String maintenancePlant { get; set; }
	// 	public String systemStatus { get; set; }
	// 	public String userStatus { get; set; }
	// 	public String costCenter { get; set; }
	// 	public String wbsElement { get; set; }
	// 	public String catelogProfile { get; set; }
	// 	public String mainWorkCenterPlant { get; set; }
	// }

	private static final Map<String, Map<String, Master_Map__c>> MasterMaps {
		get {
			if (MasterMaps == null) {
				MasterMaps = new Map<String, Map<String, Master_Map__c>>();
				for (Master_Map__c master : [
					SELECT Id, Name, Type__c
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
		Database.executeBatch(new THOR_ReplicatedSAP_FunctionalLocation(request.requestURI, body), 1000);

		return dto_response.parse(
			JSON.serialize(
				new Map<String, Object>{
					'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => '' },
					'recordIds' => null
				}
			)
		);
		//		Application_Log__c applog = new Application_Log__c(
		//			External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
		//			Integration_Name__c = 'THOR_ReplicatedSAP_FunctionalLocation',
		//			Method__c = 'Upsert',
		//			Message_Type__c = 'Success',
		//			Request_Body__c = JSON.serialize(requestBody).left(131071)
		//		);

		//		try {

		//		} catch (Exception ex) {
		//			applog.Error_Message__c = ex.getMessage();
		//			applog.Message_Type__c = 'Fail';
		//			applog.Response_Body__c = JSON.serialize(
		//				new Map<String, Object>{
		//					'description' => new Map<String, Object>{
		//						'success' => false,
		//						'message' => 'Unknown string format, cannot parse body data. Please try JSON format.',
		//						'linkurl' => applog.External_ID__c
		//					}
		//				}
		//			);
		//			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		//			return dto_response.parse(applog.Response_Body__c);

		//			return dto_response.parse(null);
		//		}

		//		if (flList == null || flList.size() == 0) {
		//			applog.Response_Body__c = JSON.serialize(
		//				new Map<String, Object>{
		//					'description' => new Map<String, Object>{
		//						'success' => false,
		//						'message' => 'Not found Functional Location Information',
		//						'linkurl' => applog.External_ID__c
		//					}
		//				}
		//			);
		//			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		//			return dto_response.parse(applog.Response_Body__c);
		//			return dto_response.parse(null);
		//		}

		//        Database.executeBatch(new THOR_ReplicatedSAP_FunctionalLocation(request.requestURI, flList));

		//		applog.Response_Body__c = JSON.serialize(
		//			new Map<String, Object>{
		//				'description' => new Map<String, Object>{
		//					'success' => true,
		//					'message' => '',
		//					'linkurl' => applog.External_ID__c
		//				},
		//				'recordIds' => (new Map<Id, Functional_Location__c>()).keySet()
		//			}
		//		);
		//		ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		//
		//		return dto_response.parse(applog.Response_Body__c);
	}

	// private static List<FLFromSAP> parseJSONInputs(String body) {
	// 	Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
	// 	List<Object> flList = (List<Object>) MethodUtils.getResult('FLLIST', parsedBody);

	// 	List<FLFromSAP> inputs = new List<FLFromSAP>();
	// 	for (Object rawInput : flList) {
	// 		FLFromSAP fl = createFLFromSAP(rawInput);
	// 		inputs.add(fl);
	// 	}

	// 	return inputs;
	// }

	// public static FLFromSAP createFLFromSAP(Object json) {
	// 	FLFromSAP fl = new FLFromSAP();

	// 	fl.fl = (String) MethodUtils.getResult('FL', json);
	// 	fl.description = (String) MethodUtils.getResult('DESCRIPTION', json);
	// 	fl.subFL = (String) MethodUtils.getResult('SUBFL', json);
	// 	fl.objectType = (String) MethodUtils.getResult('OBJECTTYPE', json);
	// 	fl.plannerGroup = (String) MethodUtils.getResult('PLANNERGROUP', json);
	// 	fl.planningPlant = (String) MethodUtils.getResult('PLANNINGPLANT', json);
	// 	fl.authorizeGroup = (String) MethodUtils.getResult('AUTHORIZEGROUP', json);
	// 	fl.companyCode = (String) MethodUtils.getResult('COMPANYCODE', json);
	// 	fl.plantSection = (String) MethodUtils.getResult('PLANTSECTION', json);
	// 	fl.location = (String) MethodUtils.getResult('LOCATION', json);
	// 	fl.mainWorkCenter = (String) MethodUtils.getResult('MAINWORKCENTER', json);
	// 	fl.maintenancePlant = (String) MethodUtils.getResult('MAINTENANCEPLANT', json);
	// 	fl.systemStatus = (String) MethodUtils.getResult('SYSTEMSTATUS', json);
	// 	fl.userStatus = (String) MethodUtils.getResult('USERSTATUS', json);
	// 	fl.costCenter = (String) MethodUtils.getResult('COSTCENTER', json);
	// 	fl.wbsElement = (String) MethodUtils.getResult('WBSELEMENT', json);
	// 	fl.catelogProfile = (String) MethodUtils.getResult('CATELOGPROFILE', json);
	// 	fl.mainWorkCenterPlant = (String) MethodUtils.getResult('MAINWORKCENTERPLANT', json);

	// 	return fl;
	// }

	private static String getValueResult(String key, Object obj) {
		return ((String) getResult(key, obj))?.trim();
	}

	public static List<Functional_Location__c> saveFunctionalLocation(
		List<Object> flList,
		Map<String, List<String>> errors
	) {
		//System.debug(System.LoggingLevel.DEBUG, JSON.serializePretty(flList));
		List<Functional_Location__c> upsertedFL = new List<Functional_Location__c>();

		for (Object iFL : flList) {
			Functional_Location__c fl = new Functional_Location__c();
			fl.Name = getValueResult('FL', iFL);
			fl.Description__c = getValueResult('DESCRIPTION', iFL);
			fl.Object_Type__c = getValueResult('OBJECTTYPE', iFL);
			fl.Parent_Functional_Location_Text__c = getValueResult('SUBFL', iFL);

			String PLANNERGROUP = getValueResult('PLANNERGROUP', iFL);
			fl.PlannerGroup__c = String.isNotEmpty(PLANNERGROUP)
				? MasterMaps.get('PlannerGroup')?.get(PLANNERGROUP)?.Id
				: null;

			String PLANNINGPLANT = getValueResult('PLANNINGPLANT', iFL);
			fl.Planning_Plant__c = String.isNotEmpty(PLANNINGPLANT)
				? MasterMaps.get('Plant')?.get(PLANNINGPLANT)?.Id
				: null;

			String COMPANYCODE = getValueResult('COMPANYCODE', iFL);
			fl.Company_Code__c = String.isNotEmpty(COMPANYCODE)
				? MasterMaps.get('CompanyCode')?.get(COMPANYCODE)?.Id
				: null;

			String MAINWORKCENTER = getValueResult('MAINWORKCENTER', iFL);
			fl.MainWorkCenter__c = String.isNotEmpty(MAINWORKCENTER)
				? MasterMaps.get('Main Work Center')?.get(MAINWORKCENTER)?.Id
				: null;

			String MAINTENANCEPLANT = getValueResult('MAINTENANCEPLANT', iFL);
			fl.Maintenance_Plant__c = String.isNotEmpty(MAINTENANCEPLANT)
				? MasterMaps.get('Plant')?.get(MAINTENANCEPLANT)?.Id
				: null;

			String CATELOGPROFILE = getValueResult('CATELOGPROFILE', iFL);
			fl.CatelogProfile__c = String.isNotEmpty(CATELOGPROFILE)
				? MasterMaps.get('CatelogProfile')?.get(CATELOGPROFILE)?.Id
				: null;

			String MAINWORKCENTERPLANT = getValueResult('MAINWORKCENTERPLANT', iFL);
			fl.mainWorkCenterPlant__c = String.isNotEmpty(MAINWORKCENTERPLANT)
				? MasterMaps.get('Plant')?.get(MAINWORKCENTERPLANT)?.Id
				: null;

			fl.PlantSection__c = getValueResult('PLANTSECTION', iFL);
			fl.Location__c = getValueResult('LOCATION', iFL);
			fl.System_Status__c = getValueResult('SYSTEMSTATUS', iFL);
			fl.User_Status__c = getValueResult('USERSTATUS', iFL);
			fl.CostCenter__c = getValueResult('COSTCENTER', iFL);
			fl.wbsElement__c = getValueResult('WBSELEMENT', iFL);
			fl.Authorize_Group__c = getValueResult('AUTHORIZEGROUP', iFL);

			upsertedFL.add(fl);
		}

		if (upsertedFL.size() > 0) {
			//upsert upsertedFL Name;
			List<Database.UpsertResult> upsertResults = Database.upsert(
				upsertedFL,
				Functional_Location__c.Field.Name,
				false
			);
			THOR_ReplicatedSAP_CatelogProfile.addErrorToList(upsertResults, errors);
		}

		return upsertedFL;
	}

	// private List<Object> flList;
	private String inputs;
	private String requestURI;
	private Map<String, List<String>> errors;

	public THOR_ReplicatedSAP_FunctionalLocation(String uri, String inputs) {
		this.inputs = inputs;

		requestURI = uri;
		errors = new Map<String, List<String>>();
	}

	public Iterable<Object> start(Database.BatchableContext BC) {
		Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(inputs);
		return (List<Object>) parsedBody.get('FLLIST');
	}

	public void execute(Database.BatchableContext BC, List<Object> scope) {
		List<Functional_Location__c> upsertedFL = saveFunctionalLocation(scope, errors);

		Application_Log__c applog = new Application_Log__c(
			External_ID__c = Uuid.randomUUID(),
			Integration_Name__c = 'THOR_ReplicatedSAP_FunctionalLocation',
			Method__c = 'Upsert',
			Message_Type__c = 'Success',
			Request_Body__c = '', //JSON.serialize(scope).left(131071),
			Response_Body__c = ''
			//JSON.serialize(
			//    new Map<String, Object>{
			//        'errors' => JSON.serialize(errors),
			//        'success' => (new Map<Id, Functional_Location__c>(upsertedFL)).keySet()
			//    }
			//).left(131071)
		);

		ApplicationLogUtils.saveLogInbound(requestURI, applog);
	}

	public void finish(Database.BatchableContext BC) {
	}
}
*/