public class THOR_iRPAIntegration_WorkClearance {

	private static THOR_iRPAIntegration_WorkClearance instance;
	private Map<Object, Boolean> WorkClearances { get; set; }
	private THOR_iRPAIntegration_WorkClearance() {
		this.WorkClearances = new Map<Object, Boolean>();
	}
	class WorkClearanceToSAP {
		String sf_id;
		String name;
		String workclearancenumber;
		String description;
		String wcdescription;
		String authorizedtime;
		String extendtimeto;
		String extenddate;
		String extendtime;
		String applicantorbearer;
		String authorizedsignatory;
		String authorizedsignature;
		String bearer1;
		String bearer2;
		String bearer3;
		String bearer4;
		String cangowrong1;
		String cangowrong2;
		String cangowrong3;
		String cangowrong4;
		String cangowrong5;
		String cangowrong6;
		String cause1;
		String cause2;
		String cause3;
		String cause4;
		String cause5;
		String cause6;
		String closeapplicantorbearer;
		String extendapplicantorbearer;
		String maintenanceunit;
		String prevent1;
		String prevent2;
		String prevent3;
		String prevent4;
		String prevent5;
		String prevent6;
		String thaioilsupervisorindicator;
		String authorizeddate;
		String checkdate;
		String problem;
		String requester;
		String startdate;
		String systemstatus;
		String userstatus;
		String applicantorbearertelephone;
		String checktime;
		String topsupervisortelephone;
		String extendno;
		String functionallocation;
		String area;
		String safetypermit1;
		String safetypermit2;
		String safetypermit3;
		String extendtimeflag;
		String priority;
		String mainworkcenter;
		String planningplant;
		String order;
		String notification;
		String flag;
		String action;
		String  reducepressure;
		String	blockgas;
		String	blockvalv;
		String	spadeoff;
		String	ventilation;
		String	stopmachine;
		String	ppeflag;
		String	ppe1;
		String	ppe2;
		String	ppe3;
		String	tagout;
		String	isolatebreaker;
		String	Isolateelec;
		String	lockoffrcu;
		String	permitflag;
		String	operationstandby;
		String	firewatchstandby;
		String	zflameablegas;
		String	zflameableamt;
		String	zoxygen;
		String	zoxygenamt;
		String	ztoxic;
		String	ztoxictype;
		String	ztoxicppm;
		String	zagt;
		String	zchecktime;
		String	zcheckdate;
		String	zauthorizedsignatory;
		String	zauthorizeddate;
		String	zauthorizedtime;
		String	zextendauthorizedsign;
		String	zcloseauthorizedsignoff;
		String	flameablegas;
		String	flameableamt;
		String	oxygen;
		String	oxygenamt;
		String	toxic;
		String	toxictype;
		String	toxicppm;
		String	agt;
		String	rejectreason;
		String	extendauthorizedsign;
		String	closeauthorizedsignoff;
		String	highrisktypework;
		List<WorkDetailToSAP> workdetail;
	}
	class WorkDetailToSAP {
		String lineno;
		String detail;
	}
	class WorkClearanceRequestWrapper {
		String invocationContext;
		InputWrapper input;
	}
	class InputWrapper {
		WorkClearanceDataWrapper WCData;
	}
	class WorkClearanceDataWrapper {
		List<WorkClearanceToSAP> workclearance;
		String uuid;
	}
	public static THOR_iRPAIntegration_WorkClearance getInstance() {
		if (instance == null) {
			instance = new THOR_iRPAIntegration_WorkClearance();
		}
		return instance;
	}
	public void checkIsIRPA(List<sObject> newItems, List<sObject> oldItems) {
		if (oldItems.size() > 0) {
			for (Object item : newItems) {
				Work_Clearance__c wc = (Work_Clearance__c) item;
				if (String.isBlank(wc.Integration_Status__c) && wc.isIRPA__c == true) {
					wc.Integration_Status__c = 'In Progress';
					wc.isIRPA__c = false;
					this.WorkClearances.put(wc, true);
				}
			}
		} else {
			for (Object item : newItems) {
				Work_Clearance__c wc = (Work_Clearance__c) item;
				if (String.isBlank(wc.Integration_Status__c) && wc.isIRPA__c == true) {
					wc.Integration_Status__c = 'In Progress';
					wc.isIRPA__c = false;
					this.WorkClearances.put(wc, true);
				}
			}
		}
	}
    public void checkWorkClearance_afterCreate(Map<Id, SObject> newItems) {
		List<Work_Clearance__c> wcList = new List<Work_Clearance__c>();
		for (Object obj : WorkClearances.keySet()) {
			Work_Clearance__c wc = (Work_Clearance__c) obj;
			wcList.add(wc);
		}
		THOR_iRPAIntegration_WorkClearance.sendWorkClearanceToSAP(wcList, 'Created');
	}
    public void checkWorkClearance_afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		List<Work_Clearance__c> wcList = new List<Work_Clearance__c>();
		for (Object obj : WorkClearances.keySet()) {
			Work_Clearance__c wc = (Work_Clearance__c) obj;
			wcList.add(wc);
		}
		THOR_iRPAIntegration_WorkClearance.sendWorkClearanceToSAP(wcList, 'Updated');
    }
    private static void sendWorkClearanceToSAP(List<Work_Clearance__c> wcList, String flag) {
		List<WorkClearanceToSAP> wcToSAPList = new List<WorkClearanceToSAP>();
		for (Work_Clearance__c wc : wcList) {
            if (wc != null && wc.Last_User_Action__c != null && wc.Last_User_Action__c.startsWith('OP')) flag = 'OP' + flag;
			wcToSAPList.add(makeWorkClearanceToSAPObject(wc, flag));
		}
		WorkClearanceDataWrapper wcWrapper = new WorkClearanceDataWrapper();
		wcWrapper.workclearance = wcToSAPList;
		wcWrapper.uuid = Uuid.randomUUID();
		InputWrapper inputWrapper = new InputWrapper();
		inputWrapper.WCData = wcWrapper;
		WorkClearanceRequestWrapper request = new WorkClearanceRequestWrapper();
		request.invocationContext = '${invocation_context}';
		request.input = inputWrapper;
		String requestJSON = JSON.serialize(request);
		
		if (wcList.size() > 0) THOR_iRPAIntegration_WorkClearance.calloutToIRPA_WorkClearance(wcList.size() > 0 ? (Id) wcList.get(0).Id : null, wcWrapper.uuid, requestJSON);
    }
	private static WorkClearanceToSAP makeWorkClearanceToSAPObject(Work_Clearance__c wc, String flag) {
		List<Work_Clearance__c> works = [SELECT Id, Name, Work_Clearance__c, Work_Detail__c, Description__c, Work_Clearance_Description__c, Authorized_Time__c, Extend_Time_To__c, Extend_Time_To_UI__c, Extend_Date__c, Extend_Time__c, Request_Extend_Date__c, Request_Extend_Time__c, Applicant_or_Bearer__c, Applicant_or_Bearer_UI__r.Code__c, Authorized_Signatory__c, Authorized_Signature__c, Bearer1__c, Bearer1_UI__r.Code__c, Bearer2__c, Bearer2_UI__r.Code__c, Bearer3__c, Bearer3_UI__r.Code__c, Bearer4__c, Bearer4_UI__r.Code__c, Can_go_wrong1__c, Can_go_wrong2__c, Can_go_wrong3__c, Can_go_wrong4__c, Can_go_wrong5__c, Can_go_wrong6__c, Cause1__c, Cause2__c, Cause3__c, Cause4__c, Cause5__c, Cause6__c, Close_Applicant_or_Bearer__c, Close_Applicant_or_Bearer_UI__r.EmployeeID__c, Extend_Applicant_or_Bearer__c, Extend_Applicant_or_Bearer_UI__r.EmployeeID__c, Maintenance_Unit__c, Prevent1__c, Prevent2__c, Prevent3__c, Prevent4__c, Prevent5__c, Prevent6__c, Thaioil_Supervisor_Indicator__c, Thaioil_Supervisor_Indicator_UI__r.EmployeeID__c, Authorized_Date__c, Check_Date__c, Problem__c, Requester__c, Requester_UI__r.EMPLOYEEID__c, Start_Date__c, System_Status__c, User_Status__c, Applicant_or_Bearer_Telephone__c, Check_Time__c, TOP_Supervisor_Telephone__c, Extend_No__c, Functional_Location__c, FunctionalLocation__c, FunctionalLocation__r.Name, Area__c, Safety_Permit1__c, Safety_Permit1_UI__r.Name, Safety_Permit2__c, Safety_Permit2_UI__r.Name, Safety_Permit3__c, Safety_Permit3_UI__r.Name, Extend_Time_Flag__c, Priority__c, Main_Work_Center__r.Name, Planning_Plant__r.Name, Order__r.Name, Notification__r.Name, Last_User_Action__c, Integration_Status__c, Reduce_Pressure__c, Block_gas__c, Block_Valv__c, Spade_off__c, Ventilation__c, Stop_machine__c, PPE_Flag__c, PPE1__c, PPE2__c, PPE3__c, Tag_Out__c, Isolate_Breaker__c, Isolate_Elec__c, Lock_off_RCU__c, Permit_flag__c, Operation_Stand_by__c, Fire_Watch_Stand_By__c, Flamable_gas__c, Flamable_amt__c, Oxygen__c, Oxygen_amt__c, Toxic__c, Toxic_Type__c, Toxic_PPM__c, AGT__c, Extend_Authorized_Sign__c, Close_Authorized_Sign_off__c, Reject_Reason__c, High_risk_work__c FROM Work_Clearance__c WHERE Id = :wc.Id];
		if (works.size() > 0) {
			Work_Clearance__c work = works[0];
			String extenddate = '';
			if (String.valueOf(work.Request_Extend_Date__c) != null) extenddate = String.valueOf(work.Request_Extend_Date__c.day()).leftPad(2, '0') + '.' + String.valueOf(work.Request_Extend_Date__c.month()).leftPad(2, '0') + '.' + String.valueOf(work.Request_Extend_Date__c.year()).leftPad(4, '0');
			String extendtime = '';
			if (String.valueOf(work.Request_Extend_Time__c) != null) extendtime = String.valueOf(work.Request_Extend_Time__c.hour()).leftPad(2, '0') + ':' + String.valueOf(work.Request_Extend_Time__c.minute()).leftPad(2, '0') + ':' + String.valueOf(work.Request_Extend_Time__c.second()).leftPad(2, '0');
			String extendtimeto = '';
			if (String.valueOf(work.Extend_Time_To_UI__c) != null) extendtimeto = String.valueOf(work.Extend_Time_To_UI__c.hour()).leftPad(2, '0') + ':' + String.valueOf(work.Extend_Time_To_UI__c.minute()).leftPad(2, '0') + ':' + String.valueOf(work.Extend_Time_To_UI__c.second()).leftPad(2, '0');

			WorkClearanceToSAP wcSAP = new WorkClearanceToSAP();
			wcSAP.sf_id = (work.Id != null) ? work.Id : '';
			wcSAP.name = (work.Name != null) ? work.Name : '';
			wcSAP.workclearancenumber = (work.Work_Clearance__c != null) ? work.Work_Clearance__c : '';
			wcSAP.description = (work.Description__c != null) ? work.Description__c : '';
			wcSAP.wcdescription = (work.Work_Clearance_Description__c != null) ? work.Work_Clearance_Description__c : '';
			wcSAP.authorizedtime = (work.Authorized_Time__c != null) ? work.Authorized_Time__c : '';
			wcSAP.extendtimeto = (extendtimeto != null) ? extendtimeto : '';
			wcSAP.extenddate = (extenddate != null) ? extenddate : '';
			wcSAP.extendtime = (extendtime != null) ? extendtime : '';
			wcSAP.applicantorbearer = (work.Applicant_or_Bearer_UI__r.Code__c != null) ? work.Applicant_or_Bearer_UI__r.Code__c : '';
			wcSAP.authorizedsignatory = (work.Authorized_Signatory__c != null) ? work.Authorized_Signatory__c : '';
			wcSAP.authorizedsignature = (work.Authorized_Signature__c != null) ? work.Authorized_Signature__c : '';
			wcSAP.bearer1 = (work.Bearer1_UI__r.Code__c != null) ? work.Bearer1_UI__r.Code__c : '';
			wcSAP.bearer2 = (work.Bearer2_UI__r.Code__c != null) ? work.Bearer2_UI__r.Code__c : '';
			wcSAP.bearer3 = (work.Bearer3_UI__r.Code__c != null) ? work.Bearer3_UI__r.Code__c : '';
			wcSAP.bearer4 = (work.Bearer4_UI__r.Code__c != null) ? work.Bearer4_UI__r.Code__c : '';
			wcSAP.cangowrong1 = (work.Can_go_wrong1__c != null) ? work.Can_go_wrong1__c : '';
			wcSAP.cangowrong2 = (work.Can_go_wrong2__c != null) ? work.Can_go_wrong2__c : '';
			wcSAP.cangowrong3 = (work.Can_go_wrong3__c != null) ? work.Can_go_wrong3__c : '';
			wcSAP.cangowrong4 = (work.Can_go_wrong4__c != null) ? work.Can_go_wrong4__c : '';
			wcSAP.cangowrong5 = (work.Can_go_wrong5__c != null) ? work.Can_go_wrong5__c : '';
			wcSAP.cangowrong6 = (work.Can_go_wrong6__c != null) ? work.Can_go_wrong6__c : '';
			wcSAP.cause1 = (work.Cause1__c != null) ? work.Cause1__c : '';
			wcSAP.cause2 = (work.Cause2__c != null) ? work.Cause2__c : '';
			wcSAP.cause3 = (work.Cause3__c != null) ? work.Cause3__c : '';
			wcSAP.cause4 = (work.Cause4__c != null) ? work.Cause4__c : '';
			wcSAP.cause5 = (work.Cause5__c != null) ? work.Cause5__c : '';
            wcSAP.cause6 = (work.Cause6__c != null) ? work.Cause6__c : '';
            wcSAP.closeapplicantorbearer = (wc.CloseApplicantorBearer_PISUser_Text__c != null) ? wc.CloseApplicantorBearer_PISUser_Text__c : '';
            wcSAP.extendapplicantorbearer = (wc.ExtendApplicantOrBearer_PISUser_Text__c != null) ? wc.ExtendApplicantOrBearer_PISUser_Text__c : '';
            wcSAP.thaioilsupervisorindicator = (wc.TOPGroupApplicantorBearer_PISUser_Text__c != null) ? wc.TOPGroupApplicantorBearer_PISUser_Text__c : '';
			wcSAP.maintenanceunit = (work.Maintenance_Unit__c != null) ? work.Maintenance_Unit__c : '';
			wcSAP.prevent1 = (work.Prevent1__c != null) ? work.Prevent1__c : '';
			wcSAP.prevent2 = (work.Prevent2__c != null) ? work.Prevent2__c : '';
			wcSAP.prevent3 = (work.Prevent3__c != null) ? work.Prevent3__c : '';
			wcSAP.prevent4 = (work.Prevent4__c != null) ? work.Prevent4__c : '';
			wcSAP.prevent5 = (work.Prevent5__c != null) ? work.Prevent5__c : '';
			wcSAP.prevent6 = (work.Prevent6__c != null) ? work.Prevent6__c : '';
			wcSAP.authorizeddate = (work.Authorized_Date__c != null) ? work.Authorized_Date__c : '';
			wcSAP.checkdate = (work.Check_Date__c != null) ? work.Check_Date__c : '';
			wcSAP.problem = (work.Problem__c != null) ? work.Problem__c : '';
			wcSAP.requester = (work.Requester_UI__r.EmployeeID__c != null) ? work.Requester_UI__r.EmployeeID__c : '';
			wcSAP.startdate = (work.Start_Date__c != null) ? work.Start_Date__c : '';
			wcSAP.systemstatus = (work.System_Status__c != null) ? work.System_Status__c : '';
			wcSAP.userstatus = (work.User_Status__c != null) ? work.User_Status__c : '';
			wcSAP.applicantorbearertelephone = (work.Applicant_or_Bearer_Telephone__c != null) ? work.Applicant_or_Bearer_Telephone__c : '';
			wcSAP.checktime = (work.Check_Time__c != null) ? work.Check_Time__c : '';
			wcSAP.topsupervisortelephone = (work.TOP_Supervisor_Telephone__c != null) ? work.TOP_Supervisor_Telephone__c : '';
			wcSAP.extendno = (work.Extend_No__c != null) ? work.Extend_No__c : '';
			wcSAP.functionallocation = (work.FunctionalLocation__r.Name != null) ? work.FunctionalLocation__r.Name : '';
			wcSAP.area = (work.Area__c != null) ? work.Area__c : '';
			wcSAP.safetypermit1 = (work.Safety_Permit1_UI__r != null) ? work.Safety_Permit1_UI__r.Name : '';
			wcSAP.safetypermit2 = (work.Safety_Permit2_UI__r != null) ? work.Safety_Permit2_UI__r.Name : '';
			wcSAP.safetypermit3 = (work.Safety_Permit3_UI__r != null) ? work.Safety_Permit3_UI__r.Name : '';
			wcSAP.extendtimeflag = (work.Extend_Time_Flag__c != null) ? work.Extend_Time_Flag__c : '';
			wcSAP.priority = (work.Priority__c != null) ? work.Priority__c : '';
			wcSAP.mainworkcenter = (work.Main_Work_Center__r.Name != null) ? work.Main_Work_Center__r.Name : '';
			wcSAP.planningplant = (work.Planning_Plant__r.Name != null) ? work.Planning_Plant__r.Name : '';
			wcSAP.order = (work.Order__r.Name != null) ? work.Order__r.Name : '';
			wcSAP.notification = (work.Notification__r.Name != null) ? work.Notification__r.Name : '';
			wcSAP.flag = (flag != null) ? flag : '';
			wcSAP.reducepressure = (work.Reduce_Pressure__c != null) ? work.Reduce_Pressure__c : '';
			wcSAP.blockgas = (work.Block_gas__c != null) ? work.Block_gas__c : '';
			wcSAP.blockvalv = (work.Block_Valv__c != null) ? work.Block_Valv__c : '';
			wcSAP.spadeoff = (work.Spade_off__c != null) ? work.Spade_off__c : '';
			wcSAP.ventilation = (work.Ventilation__c != null) ? work.Ventilation__c : '';
			wcSAP.stopmachine = (work.Stop_machine__c != null) ? work.Stop_machine__c : '';
			wcSAP.ppeflag = (work.PPE_Flag__c != null) ? work.PPE_Flag__c : '';
			wcSAP.ppe1 = (work.PPE1__c != null) ? work.PPE1__c : '';
			wcSAP.ppe2 = (work.PPE2__c != null) ? work.PPE2__c : '';
			wcSAP.ppe3 = (work.PPE3__c != null) ? work.PPE3__c : '';
			wcSAP.tagout = (work.Tag_Out__c != null) ? work.Tag_Out__c : '';
			wcSAP.isolatebreaker = (work.Isolate_Breaker__c != null) ? work.Isolate_Breaker__c : '';
			wcSAP.Isolateelec = (work.Isolate_Elec__c != null) ? work.Isolate_Elec__c : '';
			wcSAP.lockoffrcu = (work.Lock_off_RCU__c != null) ? work.Lock_off_RCU__c : '';
			wcSAP.permitflag = (work.Permit_flag__c != null) ? work.Permit_flag__c : '';
			wcSAP.operationstandby = (work.Operation_Stand_by__c != null) ? work.Operation_Stand_by__c : '';
			wcSAP.firewatchstandby = (work.Fire_Watch_Stand_By__c != null) ? work.Fire_Watch_Stand_By__c : '';
			wcSAP.zflameablegas = (work.Flamable_gas__c != null) ? work.Flamable_gas__c : '';
			wcSAP.zflameableamt = (work.Flamable_amt__c != null) ? work.Flamable_amt__c : '';
			wcSAP.zoxygen = (work.Oxygen__c != null) ? work.Oxygen__c : '';
			wcSAP.zoxygenamt = (work.Oxygen_amt__c != null) ? work.Oxygen_amt__c : '';
			wcSAP.ztoxic = (work.Toxic__c != null) ? work.Toxic__c : '';
			wcSAP.ztoxictype = (work.Toxic_Type__c != null) ? work.Toxic_Type__c : '';
			wcSAP.ztoxicppm = (work.Toxic_PPM__c != null) ? work.Toxic_PPM__c : '';
			wcSAP.zagt = (work.AGT__c != null) ? work.AGT__c : '';
			wcSAP.zchecktime = (work.Check_Time__c != null) ? work.Check_Time__c : '';
			wcSAP.zcheckdate = (work.Check_Date__c != null) ? work.Check_Date__c : '';
			wcSAP.zauthorizedsignatory = (work.Authorized_Signatory__c != null) ? work.Authorized_Signatory__c : '';
			wcSAP.zauthorizeddate = (work.Authorized_Date__c != null) ? work.Authorized_Date__c : '';
			wcSAP.zauthorizedtime = (work.Authorized_Time__c != null) ? work.Authorized_Time__c : '';
			wcSAP.zextendauthorizedsign = (work.Extend_Authorized_Sign__c != null) ? work.Extend_Authorized_Sign__c : '';
			wcSAP.zcloseauthorizedsignoff = (work.Close_Authorized_Sign_off__c != null) ? work.Close_Authorized_Sign_off__c : '';
			wcSAP.flameablegas = (work.Flamable_gas__c != null) ? work.Flamable_gas__c : '';
			wcSAP.flameableamt = (work.Flamable_amt__c != null) ? work.Flamable_amt__c : '';
			wcSAP.oxygen = (work.Oxygen__c != null) ? work.Oxygen__c : '';
			wcSAP.oxygenamt = (work.Oxygen_amt__c != null) ? work.Oxygen_amt__c : '';
			wcSAP.toxic = (work.Toxic__c != null) ? work.Toxic__c : ''; 
            wcSAP.toxictype = (work.Toxic_Type__c != null) ? work.Toxic_Type__c : '';
			wcSAP.toxicppm = (work.Toxic_PPM__c != null) ? work.Toxic_PPM__c : '';
			wcSAP.agt = (work.AGT__c != null) ? work.AGT__c : '';
			wcSAP.checktime = (work.Check_Time__c != null) ? work.Check_Time__c : '';
			wcSAP.checkdate = (work.Check_Date__c != null) ? work.Check_Date__c : '';
			wcSAP.authorizedsignatory = (work.Authorized_Signatory__c != null) ? work.Authorized_Signatory__c : '';
			wcSAP.authorizeddate = (work.Authorized_Date__c != null) ? work.Authorized_Date__c : '';
			wcSAP.authorizedtime = (work.Authorized_Time__c != null) ? work.Authorized_Time__c : '';
			wcSAP.extendauthorizedsign = (work.Extend_Authorized_Sign__c != null) ? work.Extend_Authorized_Sign__c : '';
			wcSAP.closeauthorizedsignoff = (work.Close_Authorized_Sign_off__c != null) ? work.Close_Authorized_Sign_off__c : '';
			wcSAP.rejectreason = (work.Reject_Reason__c != null) ? work.Reject_Reason__c : '';
            wcSAP.highrisktypework = (work.High_Risk_Work__c != null) ? work.High_Risk_Work__c : '';
            List<String> lastUserAction = String.valueOf(work.Last_User_Action__c)?.split(' ');
            Integer lastIndex = (lastUserAction != null) ? lastUserAction.size() - 1 : -1;
            wcSAP.action = (lastIndex > -1)?lastUserAction[lastIndex]:'';

// Resend When Creation Failed
			if (flag == 'Updated' && work.Last_User_Action__c == 'CRTE') {
				wcSAP.flag = 'Created';
				wcSAP.action = '';
			}
// //1.Operator approved Work Clearance(PREP)
// if(wcSAP.systemstatus.contains('PREP') && wcSAP.authorizedsignatory != null){
// 	wcSAP.action = 'OPEXTD';
// }
// //2.Approved extend from normal hours
// if(wcSAP.systemstatus.contains('PREP') && wcSAP.userstatus.contains('EXTH') && wcSAP.Extend_Authorized_Sign_UI__c != null){
// 	wcSAP.action = 'OPEXTH';
// }
// //3.Approved Return Work Clearance
// if(wcSAP.systemstatus.contains('PREP') && wcSAP.userstatus.contains('WIP1') && wcSAP.AuthorizedSignoff != null){
// 	wcSAP.action = 'OPWIP1';
// }
// //4.Approved extend next day
// if(wcSAP.systemstatus.contains('PREP') && wcSAP.userstatus.contains('EXTD')){
// 	wcSAP.action = 'OPEXOT';
// }
// //5.Approved Close Work Clearance
// if(wcSAP.systemstatus.contains('PREP') || wcSAP.systemstatus.contains('CLSD') && wcSAP.userstatus.contains('WCCL')){
// 	wcSAP.action = 'OPWCCL';
// }
			List<WorkDetailToSAP> workDetail = new List<WorkDetailToSAP>();
			if (String.isNotEmpty(work.Work_Detail__c)) {
				List<String> lineList = work.Work_Detail__c.split('\n');
				Integer indx = 0;
				for (String line : lineList) {
					String detailText = line.trim();
					if (String.isNotEmpty(detailText)) {
						Integer len = (detailText.length() / 70) + 1;
						for (Integer j = 0; j < len; j++) {
							String trucDetailText = detailText.mid((j * 70), 70);
							WorkDetailToSAP detail = new WorkDetailToSAP();
							detail.lineno = String.valueOf(++indx);
							detail.detail = trucDetailText.replace('*', '').trim();
							workDetail.add(detail);
						}
					}
				}
			}
			wcSAP.workdetail = workDetail;
			return wcSAP;
		}
		return null;
	}
    @future(callout=true)
	private static void calloutToIRPA_WorkClearance(String workclearanceId, String externalId, String bodyJson) {
		Application_Log__c applog = new Application_Log__c(External_ID__c = externalId);
		THORIntegration__c CS = THORIntegration__c.getInstance();
		Work_Clearance__c wc = new Work_Clearance__c(Id = workclearanceId);
		try {
			Http http = new Http();
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Token_Endpoint__c);
			req.setBody('grant_type=client_credentials&client_id=' + CS.iRPA_Client_Id__c + '&client_secret=' + CS.iRPA_Client_Secret_Id__c);
			HttpResponse res = http.send(req);
			Map<String, Object> tokenMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
			System.debug(System.LoggingLevel.DEBUG, JSON.serializePretty(JSON.deserializeUntyped(bodyJson)));
			req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_WorkClearance_Endpoint__c);
			req.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
			req.setHeader('Content-Type', 'application/json');
			req.setHeader( 'Authorization', String.format('Bearer {0}', new List<String>{ tokenMap.containsKey('access_token') ? (String) tokenMap.get('access_token') : '' }) );
			req.setTimeout(120 * 1000);
			req.setBody(bodyJson);
			applog.Integration_Name__c = 'calloutToIRPA_WorkClearance';
			applog.Method__c = 'Create';
			applog.Message_Type__c = 'In Progress';
			applog.Request_Body__c = bodyJson;
			res = http.send(req);
			Map<String, Object> result = res != null ? (Map<String, Object>) JSON.deserializeUntyped(res?.getBody()) : new Map<String, Object>();
			if (!result.containsKey('jobUid')) {
				wc.Integration_Status__c = 'Failed';
				wc.Integration_Message__c = res.getStatus();
				update wc;
			}
			applog.Reference_ID__c = workclearanceId;
			applog.Response_Body__c = res.getBody();
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Notification_Endpoint__c, applog);
		} catch (Exception e) {
			String msg = String.format('calloutToIRPA_WorkClearance: {0} \r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
			wc.Integration_Status__c = 'Failed';
			wc.Integration_Message__c = e.getMessage();
			update wc;
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = msg;
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Notification_Endpoint__c, applog);
		}
    }
}