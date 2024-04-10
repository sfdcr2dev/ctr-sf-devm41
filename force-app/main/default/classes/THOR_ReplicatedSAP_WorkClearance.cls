public class THOR_ReplicatedSAP_WorkClearance extends MethodUtils implements Database.Batchable<Object>, Database.Stateful {

	private static final Map<String, Map<String, PISUsers__c>> PISUSERMAPEMP {
		get {
			if (PISUSERMAPEMP == null) {
				PISUSERMAPEMP = new Map<String, Map<String, PISUsers__c>>{ 'HOST_ID__c' => new Map<String, PISUsers__c>(), 'HOME_ID__c' => new Map<String, PISUsers__c>(), 'Name' => new Map<String, PISUsers__c>() };
				for (PISUsers__c pisuser : [ SELECT Id, Name, EMPLOYEEID__c, HOST_ID__c, HOME_ID__c FROM PISUsers__c ORDER BY CreatedDate DESC, EMPLOYEEID__c ]) {
					if (!PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisuser.HOST_ID__c)) {
						PISUSERMAPEMP.get('HOST_ID__c').put(pisuser.HOST_ID__c, pisuser);
					}
					if (!PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisuser.HOME_ID__c)) {
						PISUSERMAPEMP.get('HOME_ID__c').put(pisuser.HOME_ID__c, pisuser);
					}
					if (!PISUSERMAPEMP.get('Name').containsKey(pisuser.Name)) {
						PISUSERMAPEMP.get('Name').put(pisuser.Name?.toUpperCase().trim(), pisuser);
					}
				}
			}
			return PISUSERMAPEMP;
		}
		set;
	}

	public class dto_response extends WebServiceExtend.dto_response {}

	public class WorkClearanceFromSAP {
		public String workClearanceNumber;
		public String FL;
		public String mainWorkCenter;
		public String notification;
		public String order;
		public String description;
		public String planningPlant;
		public String systemStatus;
		public String userStatus;
		public String startDate;
		public String authorizedDate;
		public String attachedfileBase64;
		public String extendNo;
		public String priority;
		public String requester;
		public String area;
		public String maintenanceUnit;
		public String problem;
		public String workDetail;
		public String wbs;
		public String thaioilSupervisorIndicator;
		public String topSupervisorTelephone;
		public String applicantOrBearer;
		public String applicantOrBearerTelephone;
		public String bearer1;
		public String bearer2;
		public String bearer3;
		public String bearer4;
		public String canGoWrong1;
		public String canGoWrong2;
		public String CanGoWrong3;
		public String canGoWrong4;
		public String canGoWrong5;
		public String canGoWrong6;
		public String cause1;
		public String cause2;
		public String cause3;
		public String cause4;
		public String cause5;
		public String cause6;
		public String prevent1;
		public String prevent2;
		public String prevent3;
		public String prevent4;
		public String prevent5;
		public String prevent6;
		public String authorizedSignature;
		public String authorizedIndicator;
		public String authorizedSignatory;
		public String authorizedTime;
		public String extendTimeFlag;
		public String extendTimeTo;
		public String extendApplicantOrBearer;
		public String extendAuthorizedSign;
		public String signOffFlag;
		public String closeApplicantOrBearer;
		public String closeAuthorizedSignOff;
		public String closeAuthorizedSignIndc;
		public String safetyPermit1;
		public String safetyPermit2;
		public String safetyPermit3;
		public String extendAuthorizedSignIndc;
		public String reducePressure;
		public String blockGas;
		public String blockValv;
		public String spadeOff;
		public String ventilation;
		public String stopMachine;
		public String ppeFlag;
		public String ppe1;
		public String ppe2;
		public String ppe3;
		public String tagOut;
		public String isolateElec;
		public String isolateBreaker;
		public String lockOffRCU;
		public String permitFlag;
		public String operationStandBy;
		public String fireWatchStandBy;
		public String flamableGas;
		public String flamableAmt;
		public String oxygen;
		public String oxygenAmt;
		public String toxic;
		public String toxicType;
		public String toxicPpm;
		public String agt;
		public String checkDate;
		public String checkTime;
		public String wcDescription;
		public String extendDate;
		public String extendTime;
		public String highRisk;
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
		String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
		String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')) : '';

		if (body.length() > 5000) {
			Database.executeBatch(new THOR_ReplicatedSAP_WorkClearance(request.requestURI, body), 50);

			Application_Log__c applog = new Application_Log__c( External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_WorkClearance', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = JSON.serialize(requestBody).left(121071), Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => '' }, 'recordIds' => null } ) );
			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

			return dto_response.parse(applog.Response_Body__c);
		} else {
			Application_Log__c applog = new Application_Log__c( External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_WorkClearance', Method__c = 'Upsert', Message_Type__c = 'Success' );

			List<Work_Clearance__c> savedWorkClearanceList;
			try {
				Object parsedBodyObj = System.JSON.deserializeUntyped(body);
				Map<String, Object> parsedBody = (Map<String, Object>) parsedBodyObj;
				Map<String, List<String>> errors = new Map<String, List<String>>();

				applog.Request_Body__c = JSON.serialize(MethodUtils.setResultByKeypath('body', parsedBodyObj, requestBody)).left(121071);

				savedWorkClearanceList = saveWorkClearance((List<Object>) parsedBody.get('WCLIST'), errors);
			} catch (Exception ex) {
				applog.Error_Message__c = ex.getMessage();
				applog.Message_Type__c = 'Fail';
				applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => false, 'message' => ex.getMessage(), 'linkurl' => applog.External_ID__c } } );
				ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
				return dto_response.parse(applog.Response_Body__c);
			}

			applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => savedWorkClearanceList.size() > 0, 'message' => savedWorkClearanceList.size() > 0 ? '' : 'Not found Work Clearance Information', 'linkurl' => applog.External_ID__c }, 'recordIds' => (new Map<Id, Work_Clearance__c>(savedWorkClearanceList)).keySet() } );
			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

			return dto_response.parse(applog.Response_Body__c);
		}
	}

	public static List<WorkClearanceFromSAP> parseJSONInputs(List<Object> wcList) {
		List<WorkClearanceFromSAP> inputs = new List<WorkClearanceFromSAP>();
		for (Object rawInput : wcList) {
			Map<String, Object> input = (Map<String, Object>) rawInput;

			WorkClearanceFromSAP wc = new WorkClearanceFromSAP();
			wc.workClearanceNumber = String.valueOf(input.get('WCNUM'));
			wc.FL = String.valueOf(input.get('FUNCLOC'));
			wc.mainWorkCenter = String.valueOf(input.get('MAINWC'));
			wc.notification = String.valueOf(input.get('NOTFNUM'));
			wc.order = String.valueOf(input.get('ORDERNUM'));
			wc.description = String.valueOf(input.get('NOTIFDESC')).unescapeHtml4();
			wc.planningPlant = String.valueOf(input.get('PPLANT'));
			wc.systemStatus = String.valueOf(input.get('SYSSTATUS'));
			wc.userStatus = String.valueOf(input.get('USERSTATUS'));
			wc.startDate = String.valueOf(input.get('BSCSTART'));
			wc.authorizedDate = String.valueOf(input.get('AUTHDATE'));
			wc.attachedfileBase64 = String.valueOf(input.get('WCFORM'));
			wc.extendNo = String.valueOf(input.get('EXTENDNO'));
			wc.priority = String.valueOf(input.get('PRIORITY'));
			wc.requester = String.valueOf(input.get('REQUESTER'));
			wc.area = String.valueOf(input.get('AREA'));
			wc.maintenanceUnit = String.valueOf(input.get('UNIT'));
			wc.problem = String.valueOf(input.get('PROBLEM')).unescapeHtml4();
			wc.workDetail =String.valueOf(input.get('STXT')).unescapeHtml4()+' '+  String.valueOf(input.get('WORK')).unescapeHtml4();
			wc.wbs = String.valueOf(input.get('WBS'));
			wc.thaioilSupervisorIndicator = String.valueOf(input.get('TOPSUP'));
			wc.topSupervisorTelephone = String.valueOf(input.get('TOPTEL'));
			wc.applicantOrBearer = String.valueOf(input.get('APPLICANT'));
			wc.applicantOrBearerTelephone = String.valueOf(input.get('APPTEL'));
			wc.bearer1 = String.valueOf(input.get('BEARER1'));
			wc.bearer2 = String.valueOf(input.get('BEARER2'));
			wc.bearer3 = String.valueOf(input.get('BEARER3'));
			wc.bearer4 = String.valueOf(input.get('BEARER4'));
			wc.canGoWrong1 = String.valueOf(input.get('WRONG1'));
			wc.canGoWrong2 = String.valueOf(input.get('WRONG2'));
			wc.CanGoWrong3 = String.valueOf(input.get('WRONG3'));
			wc.canGoWrong4 = String.valueOf(input.get('WRONG4'));
			wc.canGoWrong5 = String.valueOf(input.get('WRONG5'));
			wc.canGoWrong6 = String.valueOf(input.get('WRONG6'));
			wc.cause1 = String.valueOf(input.get('CAUSE1'));
			wc.cause2 = String.valueOf(input.get('CAUSE2'));
			wc.cause3 = String.valueOf(input.get('CAUSE3'));
			wc.cause4 = String.valueOf(input.get('CAUSE4'));
			wc.cause5 = String.valueOf(input.get('CAUSE5'));
			wc.cause6 = String.valueOf(input.get('CAUSE6'));
			wc.prevent1 = String.valueOf(input.get('PREVENT1'));
			wc.prevent2 = String.valueOf(input.get('PREVENT2'));
			wc.prevent3 = String.valueOf(input.get('PREVENT3'));
			wc.prevent4 = String.valueOf(input.get('PREVENT4'));
			wc.prevent5 = String.valueOf(input.get('PREVENT5'));
			wc.prevent6 = String.valueOf(input.get('PREVENT6'));
			wc.authorizedSignature = String.valueOf(input.get('AUTH_SIGN'));
			wc.authorizedIndicator = String.valueOf(input.get('AUTH_INDCT'));
			wc.authorizedSignatory = String.valueOf(input.get('PERNR_AUTH'));
			wc.authorizedTime = String.valueOf(input.get('AUTH_TIME'));
			wc.extendTimeFlag = String.valueOf(input.get('EXTENDFLAG'));
			wc.extendTimeTo = String.valueOf(input.get('EXT_TIM_TO'));
			wc.extendApplicantOrBearer = String.valueOf(input.get('PERNR_EXT'));
			wc.extendAuthorizedSign = String.valueOf(input.get('PERNR_EXTAUTH'));
			wc.signOffFlag = String.valueOf(input.get('SIGNFLAG'));
			wc.closeApplicantOrBearer = String.valueOf(input.get('PERNR_BEARER'));
			wc.closeAuthorizedSignOff = String.valueOf(input.get('PERNR_SIGNOFF'));
			wc.closeAuthorizedSignIndc = String.valueOf(input.get('PERNR_SIGNOFF_INDC'));
			wc.safetyPermit1 = String.valueOf(input.get('PERMIT1'));
			wc.safetyPermit2 = String.valueOf(input.get('PERMIT2'));
			wc.safetyPermit3 = String.valueOf(input.get('PERMIT3'));
			wc.extendAuthorizedSignIndc = String.valueOf(input.get('PERNR_EXTAUTH_INDC'));
			wc.reducePressure = String.valueOf(input.get('REDPRESSURE'));
			wc.blockGas = String.valueOf(input.get('BLKGLQU'));
			wc.blockValv = String.valueOf(input.get('BLKVALV'));
			wc.spadeOff = String.valueOf(input.get('BLKSPBL'));
			wc.ventilation = String.valueOf(input.get('VNTILAT'));
			wc.stopMachine = String.valueOf(input.get('STPMACH'));
			wc.ppeFlag = String.valueOf(input.get('SPPRTCT'));
			wc.ppe1 = String.valueOf(input.get('SPPRTCT1'));
			wc.ppe2 = String.valueOf(input.get('SPPRTCT2'));
			wc.ppe3 = String.valueOf(input.get('SPPRTCT3'));
			wc.tagOut = String.valueOf(input.get('TAGOUT'));
			wc.isolateElec = String.valueOf(input.get('ISOELCT'));
			wc.isolateBreaker = String.valueOf(input.get('ISOBRAK'));
			wc.lockOffRCU = String.valueOf(input.get('LCKRCU'));
			wc.permitFlag = String.valueOf(input.get('SFTPER'));
			wc.operationStandBy = String.valueOf(input.get('OPSTBY'));
			wc.fireWatchStandBy = String.valueOf(input.get('FWSTBY'));
			wc.flamableGas = String.valueOf(input.get('ZZFLM_GAS'));
			wc.flamableAmt = String.valueOf(input.get('ZZFLG_AMT'));
			wc.oxygen = String.valueOf(input.get('ZZOXYGEN'));
			wc.oxygenAmt = String.valueOf(input.get('ZZOXYGEN_AMT'));
			wc.toxic = String.valueOf(input.get('ZZTOX_GAS'));
			wc.toxicType = String.valueOf(input.get('ZZTOX_AMT'));
			wc.toxicPpm = String.valueOf(input.get('ZZTOX_PPM'));
			wc.agt = String.valueOf(input.get('ZZPERNR_GAS'));
			wc.checkDate = String.valueOf(input.get('ZZCHK_DAT'));
			wc.checkTime = String.valueOf(input.get('ZZCHK_TIM'));
			wc.extendDate = String.valueOf(input.get('EXT_DATE'));
			wc.extendTime = String.valueOf(input.get('EXT_TIM'));
			wc.wcDescription = String.valueOf(input.get('STXT')).unescapeHtml4();
			wc.highRisk = String.valueOf(input.get('ZHRISKTYPE'));

			inputs.add(wc);
		}

		return inputs;
	}

	private static Id getPISUsersId(String hostOrHomeId) {
		hostOrHomeId = hostOrHomeId?.trim();

		String findId = hostOrHomeId;
		findId = String.isNotEmpty(findId) && findId.length() < 8 ? hostOrHomeId?.trim().leftPad(8, '0') : hostOrHomeId;

		Id idPISUsers = null;
		idPISUsers = PISUSERMAPEMP.get('HOST_ID__c').containsKey(findId) ? PISUSERMAPEMP.get('HOST_ID__c').get(findId)?.Id : PISUSERMAPEMP.get('HOME_ID__c').containsKey(findId) ? PISUSERMAPEMP.get('HOME_ID__c').get(findId)?.Id : PISUSERMAPEMP.get('Name').containsKey(hostOrHomeId) ? PISUSERMAPEMP.get('Name').get(hostOrHomeId)?.Id : null;
		return  idPISUsers;
	}

	private static Map<String, Functional_Location__c> getMapFunctionalLocation(List<WorkClearanceFromSAP> wcList) {
		List<String> flstrList = new List<String>();
		for (WorkClearanceFromSAP item : wcList) {
			if (item.FL != null) {
				String FLStr = item.FL.normalizeSpace();
				if (FLStr != '') {
					flstrList.add(FLStr);
				}
			}
		}

		Map<String, Functional_Location__c> flMap = new Map<String, Functional_Location__c>();
		for (Functional_Location__c fl : [ SELECT Id, Name, MainWorkCenter__c, MainWorkCenter__r.Name, Latitude__c, Longitude__c FROM Functional_Location__c WHERE NAME IN :flstrList ]) {
			flMap.put(fl.name, fl);
		}

		return flMap;
	}

	private static Map<String, String> getMapApplicantOrBearer(List<WorkClearanceFromSAP> wcList) {
		List<String> applicantorbearerstrList = new List<String>();
		for (WorkClearanceFromSAP item : wcList) {
			if (item.applicantOrBearer != null) {
				String ApplicantOrBearerStr = item.applicantOrBearer.normalizeSpace();
				if (ApplicantOrBearerStr != '') {
					applicantorbearerstrList.add(ApplicantOrBearerStr);
				}
			}
			if (item.bearer1 != null) {
				String Bearer1Str = item.bearer1.normalizeSpace();
				if (Bearer1Str != '') {
					applicantorbearerstrList.add(Bearer1Str);
				}
			}
			if (item.bearer2 != null) {
				String Bearer2Str = item.bearer2.normalizeSpace();
				if (Bearer2Str != '') {
					applicantorbearerstrList.add(Bearer2Str);
				}
			}
			if (item.bearer3 != null) {
				String Bearer3Str = item.bearer3.normalizeSpace();
				if (Bearer3Str != '') {
					applicantorbearerstrList.add(Bearer3Str);
				}
			}
			if (item.bearer4 != null) {
				String Bearer4Str = item.bearer4.normalizeSpace();
				if (Bearer4Str != '') {
					applicantorbearerstrList.add(Bearer4Str);
				}
			}
		}

		Map<String, String> applicantorbearerMap = new Map<String, String>();
		for (THOR_Applicant_Bearer__c bearer : [ SELECT Id, Name, Code__c FROM THOR_Applicant_Bearer__c WHERE Code__c IN :applicantorbearerstrList ]) {
			applicantorbearerMap.put(bearer.Code__c, bearer.Id);
		}

		return applicantorbearerMap;
	}

	private static Map<String, String> getMapSaftyPermit(List<WorkClearanceFromSAP> wcList) {
		List<String> safetypermitstrList = new List<String>();
		for (WorkClearanceFromSAP item : wcList) {
			if (item.safetyPermit1 != null) {
				String SafetyPermit1Str = item.safetyPermit1.normalizeSpace();
				if (SafetyPermit1Str != '') {
					safetypermitstrList.add(SafetyPermit1Str);
				}
			}
			if (item.safetyPermit2 != null) {
				String SafetyPermit2Str = item.safetyPermit2.normalizeSpace();
				if (SafetyPermit2Str != '') {
					safetypermitstrList.add(SafetyPermit2Str);
				}
			}
			if (item.safetyPermit3 != null) {
				String SafetyPermit3Str = item.safetyPermit3.normalizeSpace();
				if (SafetyPermit3Str != '') {
					safetypermitstrList.add(SafetyPermit3Str);
				}
			}
		}

		Map<String, String> safetypermitMap = new Map<String, String>();
		for (Safety_Permit__c permit : [ SELECT Id, Name FROM Safety_Permit__c WHERE NAME IN :safetypermitstrList ]) {
			safetypermitMap.put(permit.Name, permit.Id);
		}

		return safetypermitMap;
	}

	private static Map<String, Master_Map__c> getMapPlant() {
		Map<String, Master_Map__c> plantMap = new Map<String, Master_Map__c>();
		for (Master_Map__c plant : [ SELECT Id, Name FROM Master_Map__c WHERE Type__c = 'Plant' ]) {
			plantMap.put(plant.Name, plant);
		}

		return plantMap;
	}
	
	private static Map<String, Master_Map__c> getMapPlantSection() {
		Map<String, Master_Map__c> plantSectionMap = new Map<String, Master_Map__c>();
		for (Master_Map__c plantSection : [ SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant Section' ]) {
			plantSectionMap.put(plantSection.Name, plantSection);
		}

		return plantSectionMap;
	}

	private static Map<String, Master_Map__c> getMapMainWorkCenter() {
		Map<String, Master_Map__c> mainWorkCenterMap = new Map<String, Master_Map__c>();
		for (Master_Map__c mainWorkCenter : [ SELECT Id, Name FROM Master_Map__c WHERE Type__c = 'Main Work Center' ]) {
			mainWorkCenterMap.put(mainWorkCenter.Name, mainWorkCenter);
		}

		return mainWorkCenterMap;
	}

	public static List<Work_Clearance__c> saveWorkClearance(
		List<Object> sapWcList,
		Map<String, List<String>> errors
	) {
		List<WorkClearanceFromSAP> wcList = parseJSONInputs(sapWcList);

		Map<String, Functional_Location__c> flMap = getMapFunctionalLocation(wcList);
		Map<String, String> applicantorbearerMap = getMapApplicantOrBearer(wcList);
		Map<String, String> safetypermitMap = getMapSaftyPermit(wcList);
		Map<String, Master_Map__c> areaMap = getMapPlantSection();
		Map<String, Master_Map__c> plantMap = getMapPlant();
		Map<String, Master_Map__c> mainWorkCenterMap = getMapMainWorkCenter();

		List<Work_Clearance__c> wcListSF = new List<Work_Clearance__c>();
		Map<String, String> wcFileMap = new Map<String, String>();
		if (wcList.size() > 0) {
			Map<String, Notification__c> notificationMap = new Map<String, Notification__c>();
			for (WorkClearanceFromSAP item : wcList) {
				if (item.notification != null && item.notification.normalizeSpace() != '') {
					Notification__c iNoti = new Notification__c();
					iNoti.Name = item.notification.normalizeSpace();
					iNoti.Notification_Number__c = item.notification.normalizeSpace();
					if (item.FL != null) {
						String functionalLocation = item.FL.normalizeSpace();
						 iNoti.Functional_Location__c = flMap.containsKey(functionalLocation) ? flMap.get(functionalLocation).Id : null;
					}
					notificationMap.put(iNoti.Name, iNoti);
				}
			}
			upsert notificationMap.values() Name;

			Map<String, Order__c> orderMap = new Map<String, Order__c>();
			for (WorkClearanceFromSAP item : wcList) {
				if (item.order != null && item.order.normalizeSpace() != '') {
					Order__c iOrder = new Order__c();
					iOrder.Name = item.order;
					iOrder.Order_Number__c = item.order;
					orderMap.put(iOrder.Name, iOrder);
				}
			}
			upsert orderMap.values() Name;

			for (WorkClearanceFromSAP item : wcList) {
				Work_Clearance__c wc = new Work_Clearance__c();
				wc.Name = item.workClearanceNumber;
				wc.Work_Clearance__c = item.workClearanceNumber;
				wc.Description__c = item.description;
				wc.User_Status__c = item.userStatus;
				wc.System_Status__c = item.systemStatus;
				wc.Extend_No__c = item.extendNo;
				wc.Priority__c = item.priority;
				wc.Requester__c = (String.isNotEmpty(item.requester)) ? item.requester?.trim().leftPad(8, '0') : '';
				wc.Area_Code__c = item.area;
				wc.Maintenance_Unit__c = item.maintenanceUnit;
				wc.Problem__c = item.problem;
				wc.Work_Detail__c = item.workDetail;
				wc.WBS__c = item.wbs;
				wc.Thaioil_Supervisor_Indicator__c = (String.isNotEmpty(item.thaioilSupervisorIndicator)) ? item.thaioilSupervisorIndicator?.trim().leftPad(8, '0') : '';
				wc.TOP_Supervisor_Telephone__c = item.topSupervisorTelephone;
				wc.Applicant_or_Bearer__c = item.applicantOrBearer;
				wc.Applicant_or_Bearer_Telephone__c = item.applicantOrBearerTelephone;
				wc.Bearer1__c = item.bearer1;
				wc.Bearer2__c = item.bearer2;
				wc.Bearer3__c = item.bearer3;
				wc.Bearer4__c = item.bearer4;
				wc.Can_go_wrong1__c = item.canGowrong1;
				wc.Can_go_wrong2__c = item.canGowrong2;
				wc.Can_go_wrong3__c = item.canGowrong3;
				wc.Can_go_wrong4__c = item.canGowrong4;
				wc.Can_go_wrong5__c = item.canGowrong5;
				wc.Can_go_wrong6__c = item.canGowrong6;
				wc.Cause1__c = item.cause1;
				wc.Cause2__c = item.cause2;
				wc.Cause3__c = item.cause3;
				wc.Cause4__c = item.cause4;
				wc.Cause5__c = item.cause5;
				wc.Cause6__c = item.cause6;
				wc.Prevent1__c = item.prevent1;
				wc.Prevent2__c = item.prevent2;
				wc.Prevent3__c = item.prevent3;
				wc.Prevent4__c = item.prevent4;
				wc.Prevent5__c = item.prevent5;
				wc.Prevent6__c = item.prevent6;
				wc.Authorized_Signature__c = (String.isNotEmpty(item.authorizedSignature)) ? item.authorizedSignature?.trim().leftPad(8, '0') : '';
				wc.Authorized_Indicator__c = (String.isNotEmpty(item.authorizedIndicator)) ? item.authorizedIndicator?.trim().leftPad(8, '0') : '';
				wc.Authorized_Signatory__c = (String.isNotEmpty(item.authorizedSignatory)) ? item.authorizedSignatory?.trim().leftPad(8, '0') : '';
				wc.Extend_Time_Flag__c = item.extendTimeFlag;
				wc.Extend_Time_To__c = item.extendTimeTo;
				wc.Extend_Applicant_or_Bearer__c = (String.isNotEmpty(item.extendApplicantOrBearer)) ? item.extendApplicantOrBearer?.trim().leftPad(8, '0') : '';
				wc.Extend_Authorized_Sign__c = (String.isNotEmpty(item.extendAuthorizedSign)) ? item.extendAuthorizedSign?.trim().leftPad(8, '0') : '';
				wc.Sign_off_Flag__c = item.signOffFlag;
				wc.Close_Applicant_or_Bearer__c = (String.isNotEmpty(item.closeApplicantOrBearer)) ? item.closeApplicantOrBearer?.trim().leftPad(8, '0') : '';
				wc.Close_Authorized_Sign_off__c = (String.isNotEmpty(item.closeAuthorizedSignOff)) ? item.closeAuthorizedSignOff?.trim().leftPad(8, '0') : '';
				wc.Close_Authorized_Sign_Indc__c = item.closeAuthorizedSignIndc;
				wc.Safety_Permit1__c = item.safetyPermit1;
				wc.Safety_Permit2__c = item.safetyPermit2;
				wc.Safety_Permit3__c = item.safetyPermit3;
				wc.Extend_Authorized_Sign_Indc__c = item.extendAuthorizedSignIndc;
				wc.Reduce_Pressure__c = item.reducePressure;
				wc.Block_gas__c = item.blockGas;
				wc.Block_Valv__c = item.blockValv;
				wc.Spade_off__c = item.spadeOff;
				wc.Ventilation__c = item.ventilation;
				wc.Stop_machine__c = item.stopMachine;
				wc.PPE_Flag__c = item.ppeFlag;
				wc.PPE1__c = item.ppe1;
				wc.PPE2__c = item.ppe2;
				wc.PPE3__c = item.ppe3;
				wc.Tag_Out__c = item.tagOut;
				wc.Isolate_Elec__c = item.isolateElec;
				wc.Isolate_Breaker__c = item.isolateBreaker;
				wc.Lock_off_RCU__c = item.lockOffRcu;
				wc.Permit_flag__c = item.permitFlag;
				wc.Operation_Stand_by__c = item.operationStandBy;
				wc.Fire_Watch_Stand_By__c = item.fireWatchStandBy;
				wc.Flamable_gas__c = item.flamableGas;
				wc.Flamable_amt__c = item.flamableAmt;
				wc.Oxygen__c = item.oxygen;
				wc.Oxygen_amt__c = item.oxygenAmt;
				wc.Toxic__c = item.toxic;
				wc.Toxic_Type__c = item.toxictype;
				wc.Toxic_PPM__c = item.toxicPpm;
				wc.AGT__c = item.agt;
				wc.Integration_Status__c = 'Success';
				wc.Start_Date__c = item.startDate;
				wc.Check_Date__c = item.checkDate;
				wc.Check_Time__c = item.checkTime;
				wc.Authorized_Date__c = item.authorizedDate;
				wc.Authorized_Time__c = item.authorizedTime;
				wc.Requester_UI__c = getPISUsersId(item.requester);
				wc.Thaioil_Supervisor_Indicator_UI__c = getPISUsersId(item.thaioilSupervisorIndicator);
				wc.Close_Applicant_or_Bearer_UI__c = getPISUsersId(item.closeApplicantOrBearer);
				wc.Extend_Applicant_or_Bearer_UI__c = getPISUsersId(item.extendApplicantOrBearer);
				wc.Authorized_Signatory_UI__c = getPISUsersId(item.authorizedSignatory);
				wc.Extend_Authorized_Sign_UI__c = getPISUsersId(item.extendAuthorizedSign);
				wc.Close_Authorized_Sign_off_UI__c = getPISUsersId(item.closeAuthorizedSignOff);
				wc.Authorized_Signature_UI__c = getPISUsersId(item.authorizedSignature);
				wc.Authorized_Indicator_UI__c = getPISUsersId(item.authorizedIndicator);
				wc.AGT_UI__c = getPISUsersId(item.agt.toUpperCase());
				wc.Work_Clearance_Description__c = item.wcDescription;
				wc.High_risk_work__c = item.highRisk;

				if (String.isNotEmpty(item.extendDate)) {
					try {
						wc.Extend_Date__c = Date.valueOf(item.extendDate);
					} catch(Exception ex) {
						Integer year = Integer.valueOf(item.extendDate.substring(0, 4));
						Integer month = Integer.valueOf(item.extendDate.substring(4, 6));
						Integer day = Integer.valueOf(item.extendDate.substring(6, 8));
						wc.Extend_Date__c = Date.newInstance(year, month, day);
					}
				} else {
					wc.Extend_Date__c = null;
				}

				if (String.isNotEmpty(item.extendTime)) {
					try {
						List<String> lstTime = item.extendTime.split(':');
						Integer hour = Integer.valueOf(lstTime[0]);
						Integer minute = Integer.valueOf(lstTime[1]);
						Integer second = Integer.valueOf(lstTime[2]);

						wc.Extend_Time__c = Time.newInstance(hour, minute, second, 0);
					} catch (Exception ex) {
						Integer hour = Integer.valueOf(item.extendTime.substring(0, 2));
						Integer minute = Integer.valueOf(item.extendTime.substring(2, 4));
						Integer second = Integer.valueOf(item.extendTime.substring(4, 6));

						wc.Extend_Time__c = Time.newInstance(hour, minute, second, 0);
					}
				} else {
					wc.Extend_Time__c = null;
				}

				//New fields 15/6/2020
				//Authorized_Date_UI__c
				if (String.isNotEmpty(item.authorizedDate)) {
					try {
						wc.Authorized_Date_UI__c = Date.valueOf(item.authorizedDate);
					} catch(Exception ex) {
						Integer year = Integer.valueOf(item.authorizedDate.substring(0, 4));
						Integer month = Integer.valueOf(item.authorizedDate.substring(4, 6));
						Integer day = Integer.valueOf(item.authorizedDate.substring(6, 8));
						wc.Authorized_Date_UI__c = Date.newInstance(year, month, day);
					}
				} else {
					wc.Authorized_Date_UI__c = null;
				}

				//Authorized_Time_UI__c
				if (String.isNotEmpty(item.authorizedTime)) {
					try {
						List<String> lstTime = item.authorizedTime.split(':');
						Integer hour = Integer.valueOf(lstTime[0]);
						Integer minute = Integer.valueOf(lstTime[1]);
						Integer second = Integer.valueOf(lstTime[2]);

						wc.Authorized_Time_UI__c = Time.newInstance(hour, minute, second, 0);
					} catch (Exception ex) {
						Integer hour = Integer.valueOf(item.authorizedTime.substring(0, 2));
						Integer minute = Integer.valueOf(item.authorizedTime.substring(2, 4));
						Integer second = Integer.valueOf(item.authorizedTime.substring(4, 6));

						wc.Authorized_Time_UI__c = Time.newInstance(hour, minute, second, 0);
					}
				} else {
					wc.Authorized_Time_UI__c = null;
				}

				 //Check_Date_UI__c
				 if (String.isNotEmpty(item.checkDate)) {
					try {
						wc.Check_Date_UI__c = Date.valueOf(item.checkDate);
					} catch(Exception ex) {
						Integer year = Integer.valueOf(item.checkDate.substring(0, 4));
						Integer month = Integer.valueOf(item.checkDate.substring(4, 6));
						Integer day = Integer.valueOf(item.checkDate.substring(6, 8));
						wc.Check_Date_UI__c = Date.newInstance(year, month, day);
					}
				} else {
					wc.Check_Date_UI__c = null;
				}

				//Check_Time_UI__c
				if (String.isNotEmpty(item.checkTime)) {
					try {
						List<String> lstTime = item.checkTime.split(':');
						Integer hour = Integer.valueOf(lstTime[0]);
						Integer minute = Integer.valueOf(lstTime[1]);
						Integer second = Integer.valueOf(lstTime[2]);

						wc.Check_Time_UI__c = Time.newInstance(hour, minute, second, 0);
					} catch (Exception ex) {
						Integer hour = Integer.valueOf(item.checkTime.substring(0, 2));
						Integer minute = Integer.valueOf(item.checkTime.substring(2, 4));
						Integer second = Integer.valueOf(item.checkTime.substring(4, 6));

						wc.Check_Time_UI__c = Time.newInstance(hour, minute, second, 0);
					}
				} else {
					wc.Check_Time_UI__c = null;
				}

				//Extend_Time_To_UI__c
				if (String.isNotEmpty(item.extendTimeTo)) {
					try {
						List<String> lstTime = item.extendTimeTo.split(':');
						if (lstTime.size() == 3) {
							Integer hour = Integer.valueOf(lstTime[0]);
							Integer minute = Integer.valueOf(lstTime[1]);
							Integer second = Integer.valueOf(lstTime[2]);
	
							wc.Extend_Time_To_UI__c = Time.newInstance(hour, minute, second, 0);
						} else {
							wc.Extend_Time_To_UI__c = null;
						}
					} catch (Exception ex) {
						Integer hour = Integer.valueOf(item.extendTimeTo.substring(0, 2));
						Integer minute = Integer.valueOf(item.extendTimeTo.substring(2, 4));
						Integer second = Integer.valueOf(item.extendTimeTo.substring(4, 6));

						wc.Extend_Time_To_UI__c = Time.newInstance(hour, minute, second, 0);
					}
				} else {
					wc.Extend_Time_To_UI__c = null;
				}

				String FLStr = (item.FL != null) ? item.FL.normalizeSpace() : '';
				if (flMap.containskey(FLStr)) {
					wc.FunctionalLocation__c = flMap.get(FLStr).Id;
					wc.Main_Work_Center__c = flMap.get(FLStr).MainWorkCenter__c;
					wc.Maintenance_Unit__c = (wc.Maintenance_Unit__c == null) ? flMap.get(FLStr).MainWorkCenter__r?.Name : item.maintenanceUnit;
				}

				String area = (item.area != null) ? item.area.normalizeSpace() : '';
				wc.Area__c = areaMap.containskey(area) ? areaMap.get(area).Description__c : null;
				String ApplicantOrBearerStr = (item.applicantOrBearer != null) ? item.applicantOrBearer.normalizeSpace() : '';
				wc.Applicant_or_Bearer_UI__c = applicantorbearerMap.containskey(ApplicantOrBearerStr) ? applicantorbearerMap.get(ApplicantOrBearerStr) : null;
				String Bearer1Str = (item.bearer1 != null) ? item.bearer1.normalizeSpace() : '';
				wc.Bearer1_UI__c = applicantorbearerMap.containskey(Bearer1Str) ? applicantorbearerMap.get(Bearer1Str) : null;
				String Bearer2Str = (item.bearer2 != null) ? item.bearer2.normalizeSpace() : '';
				wc.Bearer2_UI__c = applicantorbearerMap.containskey(Bearer2Str) ? applicantorbearerMap.get(Bearer2Str) : null;
				String Bearer3Str = (item.bearer3 != null) ? item.bearer3.normalizeSpace() : '';
				wc.Bearer3_UI__c = applicantorbearerMap.containskey(Bearer3Str) ? applicantorbearerMap.get(Bearer3Str) : null;
				String Bearer4Str = (item.bearer4 != null) ? item.bearer4.normalizeSpace() : '';
				wc.Bearer4_UI__c = applicantorbearerMap.containskey(Bearer4Str) ? applicantorbearerMap.get(Bearer4Str) :null;
				String SafetyPermit1Str = (item.safetyPermit1 != null) ? item.safetyPermit1.normalizeSpace() : '';
				wc.Safety_Permit1_UI__c = safetypermitMap.containskey(SafetyPermit1Str) ? safetypermitMap.get(SafetyPermit1Str) : null;
				String SafetyPermit2Str = (item.safetyPermit2 != null) ? item.safetyPermit2.normalizeSpace() : '';
				wc.Safety_Permit2_UI__c = safetypermitMap.containskey(SafetyPermit2Str) ? safetypermitMap.get(SafetyPermit2Str) : null;
				String SafetyPermit3Str = (item.safetyPermit3 != null) ? item.safetyPermit3.normalizeSpace() : '';
				wc.Safety_Permit3_UI__c = safetypermitMap.containskey(SafetyPermit3Str) ? safetypermitMap.get(SafetyPermit3Str) : null;

				if (item.mainWorkCenter != null) {
					String mainWorkCenter = item.mainWorkCenter.normalizeSpace();
					wc.Main_Work_Center__c = mainWorkCenterMap.containsKey(mainWorkCenter) ? mainWorkCenterMap.get(mainWorkCenter).Id : null;
				}

				if (item.planningPlant != null) {
					String planningPlant = item.planningPlant.normalizeSpace();
					wc.Planning_Plant__c = plantMap.containsKey(planningPlant) ? plantMap.get(planningPlant).Id : null;
				}

				if (item.notification != null) {
					String notificationNumber = item.notification.normalizeSpace();
					wc.Notification__c = notificationMap.containsKey(notificationNumber) ? notificationMap.get(notificationNumber).Id : null;
				}

				if (item.order != null) {
					String orderNumber = item.order.normalizeSpace();
					wc.Order__c = orderMap.containsKey(orderNumber) ? orderMap.get(orderNumber).Id : null;
				}

				// isCheckingGas
				// => true (ไม่ต้องตรวจวัดก๊าซ)
				// => false (ต้องตรวจวัดก๊าซ)
				// The isCheckingGase is "true" when AGT field (AGT__c) has value and all other gas measurement fields
				// (Flamable_amt__c, Oxygen_amt__c, Toxic_Type__c, Toxic_PPM__c) are empty.
				// Other else isCheckingGas is "false"
				if (wc.AGT_UI__c != null
					&& String.isEmpty(wc.Flamable_amt__c?.normalizeSpace())
					&& String.isEmpty(wc.Oxygen_amt__c?.normalizeSpace())
					&& String.isEmpty(wc.Toxic_Type__c?.normalizeSpace())
					&& String.isEmpty(wc.Toxic_PPM__c?.normalizeSpace()))
				{
					wc.IsCheckingGas__c = true;
				} else {
					wc.IsCheckingGas__c = false;
				}

				wcListSF.add(wc);
				wcFileMap.put(item.workClearanceNumber, item.attachedfileBase64);
			}
		}

		if (wcListSF.size() > 0) {
			upsert wcListSF Work_Clearance__c;
		}

		return wcListSF;
	}

	private String inputs;
	private String requestURI;
	private Map<String, List<String>> errors;

	public THOR_ReplicatedSAP_WorkClearance(String uri, String inputs) {
		this.inputs = inputs;
		this.requestURI = uri;
		this.errors = new Map<String, List<String>>();
	}

	public Iterable<Object> start(Database.BatchableContext BC) {
		Map<String, Object> parsedBody = (Map<String, Object>) System.JSON.deserializeUntyped(inputs);
		return (List<Object>) parsedBody.get('WCLIST');
	}

	public void execute(Database.BatchableContext BC, List<Object> scope) {
		try {
			List<Work_Clearance__c> upsertedFL = saveWorkClearance(scope, errors);

			Application_Log__c applog = new Application_Log__c( External_ID__c = Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_WorkClearance', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = System.JSON.serialize(scope).left(121071), Response_Body__c = '' );

			ApplicationLogUtils.saveLogInbound(requestURI, applog);
		} catch (System.DmlException ex) {
			Application_Log__c applog = new Application_Log__c( External_ID__c = Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_WorkClearance', Method__c = 'Upsert', Message_Type__c = 'Fail', Error_Message__c = ex.getMessage(), Request_Body__c = JSON.serialize(scope).left(121071), Response_Body__c = '' );

			ApplicationLogUtils.saveLogInbound(requestURI, applog);
		}
	}

	public void finish(Database.BatchableContext BC) {
	}
}