global class THOR_Replication_SafetyPermit {

    public class ParseException extends Exception {}

    public class InputItem {
        public String safetypermitnumber { get; set; }
        public String approvalstatus { get; set; }
        public String planningplant { get; set; }
        public String typeofwcmobject { get; set; }
        public String functionallocation { get; set; }
        public String partner { get; set; }
        public String plannergroup { get; set; }
        public String mainworkcenter { get; set; }
        public String mainworkcenterplant { get; set; }

        public String plantsection { get; set; }
        public String workdetail { get; set; } 
        public String permitdescription { get; set; } 
        public String bearer1 { get; set; }//lookup
        public String bearer2 { get; set; }//lookup
        public String noncereq { get; set; }//Boolean
        public String externalae { get; set; }//lookup
        public String ae1 { get; set; }//lookup
        public String ae2 { get; set; }//lookup
        public String agsi1 { get; set; }//lookup
        public String agsi2 { get; set; }//lookup
        public String ram { get; set; } 
        public String extendcertificate { get; set; } 
        public String permittoworkdate { get; set; } //date
        public String extendedfromdate1 {get; set; }//date
        public String extendedfromdate2 {get; set; }//date
        public String extendedfromdate3 {get; set; }//date
        public String expireddate1 { get; set; }//date
        public String expireddate2 { get; set; }//date
        public String expireddate3 { get; set; }//date
    }

    public class OutputItem {
        public String gateway_id { get; set; }
        public String sfid { get; set; }
        public String documentnumber { get; set; }
        public String messagetype { get; set; }
		public String messagetext { get; set; }
    }

    global class dto_response extends WebServiceExtend.dto_response {
        global List<OutputItem> returnvalue { get; set; }
    }

    global static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }

//new method for PisUser lookup
    private static final Map<String, Map<String, PISUsers__c>> PISUSERMAPEMP {
		get {
			if (PISUSERMAPEMP == null) {
				PISUSERMAPEMP = new Map<String, Map<String, PISUsers__c>>{'HOST_ID__c' => new Map<String, PISUsers__c>(),'HOME_ID__c' => new Map<String, PISUsers__c>()};
				for (PISUsers__c pisuser : [SELECT Id, EMPLOYEEID__c, HOST_ID__c, HOME_ID__c FROM PISUsers__c ORDER BY CreatedDate DESC, EMPLOYEEID__c]) {
					if (!PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisuser.HOST_ID__c)) {
						PISUSERMAPEMP.get('HOST_ID__c').put(pisuser.HOST_ID__c, pisuser);
					}
					if (!PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisuser.HOME_ID__c)) {
						PISUSERMAPEMP.get('HOME_ID__c').put(pisuser.HOME_ID__c, pisuser);
					}
				}
			}
			return PISUSERMAPEMP;
		}
		set;
	}

    private static Id getPISUsersId(String hostOrHomeId) {
        String findId = hostOrHomeId.trim();
        if (String.isNotEmpty(findId) && findId.length() < 8) {
            findId = hostOrHomeId?.trim().leftPad(8, '0');
        }
        Id idPISUsers = null;
        idPISUsers = PISUSERMAPEMP.get('HOST_ID__c').containsKey(findId) ? PISUSERMAPEMP.get('HOST_ID__c').get(findId)?.Id : PISUSERMAPEMP.get('HOME_ID__c').containsKey(findId) ? PISUSERMAPEMP.get('HOME_ID__c').get(findId)?.Id : null;
        return  idPISUsers;
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = String.valueOf(requestBody.get('gateway_id'));
        List<InputItem> inputItems;

        try {
            inputItems = tryParseInputItems(String.valueOf(requestBody.get('body')));
        } catch (Exception ex) {
            Application_Log__c applog = new Application_Log__c(External_ID__c = Uuid.randomUUID());
            applog.Integration_Name__c = 'replication_SafetyPermit';
            applog.Method__c = 'Update';
            applog.Error_Message__c = ex.getMessage();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => false, 'message' => ex.getMessage()+' line:'+ex.getLineNumber(), 'linkurl' => applog.External_ID__c } } );
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
            return dto_response.parse(applog.Response_Body__c);
        }

        List<String> planningplans = new List<String>();
        List<String> functionallocations = new List<String>();
        List<String> partners = new List<String>();
        List<String> bearer1List = new List<String>();
        List<String> bearer2List = new List<String>();
        List<String> externalaeList = new List<String>();
        List<String> ae1List = new List<String>();
        List<String> ae2List = new List<String>();
        List<String> agsi1List = new List<String>();
        List<String> agsi2List = new List<String>();

        for (InputItem inputItem : inputItems) {
            planningplans.add(inputItem.planningplant);
            functionallocations.add(inputItem.functionallocation);
            partners.add(inputItem.partner);
            bearer1List.add(inputItem.bearer1);
            bearer2List.add(inputItem.bearer2);
            externalaeList.add(inputItem.externalae);
            ae1List.add(inputItem.ae1);
            ae2List.add(inputItem.ae2);
            agsi1List.add(inputItem.agsi1);
            agsi2List.add(inputItem.agsi2);
        }

        Map<String, Master_Map__c> planningPlantLookup = new Map<String, Master_Map__c>();
        for (Master_Map__c item : [SELECT Id, Name, Code__c FROM Master_Map__c WHERE Type__c = 'Plant' AND Code__c IN :planningplans]) {
            planningPlantLookup.put(item.Code__c, item);
        }
        Map<String, Functional_Location__c> functionLocationLookup = new Map<String, Functional_Location__c>();
        for (Functional_Location__c item : [SELECT Id, Name, MainWorkCenter__c, mainWorkCenterPlant__c FROM Functional_Location__c WHERE Name IN :functionallocations]) {
            functionLocationLookup.put(item.Name, item);
        }
        Map<String, THOR_Applicant_Bearer__c> bearer1Lookup = new Map<String, THOR_Applicant_Bearer__c>();
        for (THOR_Applicant_Bearer__c item : [SELECT Id, Name, Code__c FROM THOR_Applicant_Bearer__c WHERE Code__c IN :bearer1List]) {
            bearer1Lookup.put(item.Code__c, item);
        }
        Map<String, THOR_Applicant_Bearer__c> bearer2Lookup = new Map<String, THOR_Applicant_Bearer__c>();
        for (THOR_Applicant_Bearer__c item : [SELECT Id, Name, Code__c FROM THOR_Applicant_Bearer__c WHERE Code__c IN :bearer2List]) {
            bearer2Lookup.put(item.Code__c, item);
        }
//Lookup (User)
        Map<String, User> externalaeLookup = new Map<String, User>();
        for (User item : [SELECT Id, Name FROM User WHERE Name IN :externalaeList]) {
            externalaeLookup.put(item.Name, item);
        }
//Lookup(PIS User)
/*Map<String, PISUsers__c> ae1Lookup = new Map<String, PISUsers__c>();
        Map<String, PISUsers__c> ae2Lookup = new Map<String, PISUsers__c>();
        Map<String, PISUsers__c> agsi1Lookup = new Map<String, PISUsers__c>();
        Map<String, PISUsers__c> agsi2Lookup = new Map<String, PISUsers__c>();
        for (PISUsers__c item : [
            SELECT Id, EN_Fullname__c, HOST_ID__c, HOME_ID__c FROM PISUsers__c 
            WHERE EN_Fullname__c IN :ae1List 
            OR EN_Fullname__c IN :ae2List 
            OR EN_Fullname__c IN :agsi1List
            OR EN_Fullname__c IN :agsi2List]) {
            ae1Lookup.put(item.EN_Fullname__c, item);
            ae2Lookup.put(item.EN_Fullname__c, item);
            agsi1Lookup.put(item.EN_Fullname__c, item);
            agsi2Lookup.put(item.EN_Fullname__c, item);
        }*/

        Map<String, Safety_Permit__c> safetyPermits = new Map<String, Safety_Permit__c>();
        Map<String, OutputItem> outputItems = new Map<String, OutputItem>();
        for (InputItem inputItem : inputItems) {
            if (!String.isBlank(inputItem.safetypermitnumber)) {
                if (!String.isBlank(inputItem.planningplant) && !planningPlantLookup.containsKey(inputItem.planningplant)) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: Planning Plan not found not found in Salesforce. Planning Plant: ' + inputItem.planningplant;
                    outputItems.put(outputItem.documentnumber, outputItem);
                } else if (!String.isBlank(inputItem.functionallocation) && !functionLocationLookup.containsKey(inputItem.functionallocation)) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: Functional Location not found in Salesforce. FL: ' + inputItem.functionallocation;
                    outputItems.put(outputItem.documentnumber, outputItem);
                } else if (!String.isBlank(inputItem.partner) && getPISUsersId(inputItem.partner)==null) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: Partner not found in Salesforce. Partner: ' + inputItem.partner?.trim().leftPad(8, '0');
                    outputItems.put(outputItem.documentnumber, outputItem);
                } // new field
                else if (!String.isBlank(inputItem.bearer1) && !bearer1Lookup.containsKey(inputItem.bearer1)) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: Bearer1 not found in Salesforce. Bearer1: ' + inputItem.bearer1;
                    outputItems.put(outputItem.documentnumber, outputItem);
                } else if (!String.isBlank(inputItem.bearer2) && !bearer2Lookup.containsKey(inputItem.bearer2)) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: Bearer2 not found in Salesforce. Bearer2: ' + inputItem.bearer2;
                    outputItems.put(outputItem.documentnumber, outputItem);
                } 
                 else if (!String.isBlank(inputItem.ae1) && getPISUsersId(inputItem.ae1)==null) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: AE1 not found in Salesforce. AE1: ' + inputItem.ae1?.trim().leftPad(8, '0');
                    outputItems.put(outputItem.documentnumber, outputItem);
                } else if (!String.isBlank(inputItem.ae2) && getPISUsersId(inputItem.ae2)==null) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: AE2 not found in Salesforce. AE2: ' + inputItem.ae2?.trim().leftPad(8, '0');
                    outputItems.put(outputItem.documentnumber, outputItem);
                } else if (!String.isBlank(inputItem.agsi1) && getPISUsersId(inputItem.agsi1)==null) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: AGASI1 not found in Salesforce. AGASI1: ' + inputItem.agsi1?.trim().leftPad(8, '0');
                    outputItems.put(outputItem.documentnumber, outputItem);
                } else if (!String.isBlank(inputItem.agsi2) && getPISUsersId(inputItem.agsi2)==null) {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'F';
                    outputItem.messagetext = 'Safety Permit Number: ' + inputItem.safetypermitnumber + ', Invalid Reference Value: AGASI2 not found in Salesforce. AGASI2: ' + inputItem.agsi2?.trim().leftPad(8, '0');
                    outputItems.put(outputItem.documentnumber, outputItem);
                } else {
                    OutputItem outputItem = new OutputItem();
                    outputItem.gateway_id = gatewayId;
                    outputItem.documentnumber = inputItem.safetypermitnumber;
                    outputItem.messagetype = 'S';
                    outputItem.messagetext = 'success';
                    outputItems.put(outputItem.documentnumber, outputItem);
                }

                Safety_Permit__c safetyPermit = new Safety_Permit__c();
                safetyPermit.Name = inputItem.safetypermitnumber;
                safetyPermit.External_Key__c = inputItem.safetypermitnumber;
                safetyPermit.Approval_Status__c = inputItem.approvalstatus;
                safetyPermit.Planning_Plant__c = (planningPlantLookup.containsKey(inputItem.planningplant)) ? planningPlantLookup.get(inputItem.planningplant).Id : null;
                safetyPermit.Planning_Plant_Text__c = inputItem.planningplant;
                safetyPermit.Type_of_WCM_object__c = inputItem.typeofwcmobject;
                safetyPermit.Functional_Location__c = (functionLocationLookup.containsKey(inputItem.functionallocation)) ? functionLocationLookup.get(inputItem.functionallocation).Id : null;
                safetyPermit.Functional_Location_Text__c = inputItem.functionallocation;
                safetyPermit.Applicant_TOP_Group__c = getPISUsersId(inputItem.partner);
                safetyPermit.Applicant_TOP_Group_Text__c = inputItem.partner;
                safetyPermit.Planner_group__c = inputItem.plannergroup;
                safetyPermit.Main_Work_Center__c = (functionLocationLookup.containsKey(inputItem.functionallocation)) ? functionLocationLookup.get(inputItem.functionallocation).MainWorkCenter__c : null;
                safetyPermit.Main_Work_Center_Text__c = inputItem.mainworkcenter;
                safetyPermit.Main_Work_Center_Plant__c = (functionLocationLookup.containsKey(inputItem.functionallocation)) ? functionLocationLookup.get(inputItem.functionallocation).mainWorkCenterPlant__c : null;
                safetyPermit.Main_Work_Center_Plant_Text__c = inputItem.mainworkcenterplant;

//new fields - platsection, workdetail, permitdescription
                safetyPermit.Plant_Section__c   = (inputItem.plantsection != null && inputItem.plantsection !='') ? inputItem.plantsection : null;
                safetyPermit.Work_Detail__c     = (inputItem.workdetail != null && inputItem.workdetail !='') ? inputItem.workdetail : null;
                safetyPermit.Permit_Description__c = (inputItem.permitdescription != null && inputItem.permitdescription !='') ? inputItem.permitdescription : null;
//bearer1
                safetyPermit.Bearer1__c    = (bearer1Lookup.containsKey(inputItem.bearer1)) ? bearer1Lookup.get(inputItem.bearer1).Id : null;
                safetyPermit.Bearer1_UI__c = (inputItem.bearer1 != null && inputItem.bearer1 !='') ? inputItem.bearer1 : null;
//bearer2
                safetyPermit.Bearer2__c     = (bearer2Lookup.containsKey(inputItem.bearer2)) ? bearer2Lookup.get(inputItem.bearer2).Id : null;
                safetyPermit.Bearer2_UI__c  = (inputItem.bearer2 != null && inputItem.bearer2 !='') ? inputItem.bearer2 : null;
//non-cereq
                safetyPermit.Non_CEREQ__c   = (inputItem.noncereq != null) ? Boolean.valueof(inputItem.noncereq) : false;
//externalAe
                safetyPermit.External_AE__c      = (externalaeLookup.containsKey(inputItem.externalae)) ? externalaeLookup.get(inputItem.externalae).Id : null;
                safetyPermit.External_AE_UI__c	 = (inputItem.externalae != null && inputItem.externalae !='') ? inputItem.externalae : null;
//ae1
                safetyPermit.AE1__c      = getPISUsersId(inputItem.ae1);
                safetyPermit.AE1_UI__c	 = (inputItem.ae1 != null && inputItem.ae1 !='') ? inputItem.ae1 : null;
//ae2
                safetyPermit.AE2__c      = getPISUsersId(inputItem.ae2);
                safetyPermit.AE2_UI__c	 = (inputItem.ae2 != null && inputItem.ae2 !='') ? inputItem.ae2 : null;
//agsi1
                safetyPermit.AGSI__c     = getPISUsersId(inputItem.agsi1);
                safetyPermit.AGSI_UI__c	 = (inputItem.agsi1 != null && inputItem.agsi1 !='') ? inputItem.agsi1 : null;
//agsi2
                safetyPermit.AGSI2__c       = getPISUsersId(inputItem.agsi2);
                safetyPermit.AGSI2_UI__c    = (inputItem.agsi2 != null && inputItem.agsi2 !='') ? inputItem.agsi2 : null;
//ram, extendcertificate
                safetyPermit.RAM__c                = (inputItem.ram != null && inputItem.ram !='') ? inputItem.ram : null;
                safetyPermit.Extend_Certificate__c = (inputItem.extendcertificate != null && inputItem.extendcertificate !='') ? inputItem.extendcertificate : null;
//permittoworkdate, expireddate1,expireddate2,expireddate3,extendedfromdate1,extendedfromdate2,extendedfromdate3
                safetyPermit.Permit_to_Work_Date__c = tryParseDate(inputItem.permittoworkdate);
                safetyPermit.Expired_Date_1__c = tryParseDate(inputItem.expireddate1);
                safetyPermit.Expired_Date_2__c = tryParseDate(inputItem.expireddate2);
                safetyPermit.Expired_Date_3__c = tryParseDate(inputItem.expireddate3);
                safetyPermit.Extended_From_Date_1__c = tryParseDate(inputItem.extendedfromdate1);
                safetyPermit.Extended_From_Date_2__c = tryParseDate(inputItem.extendedfromdate2);
                safetyPermit.Extended_From_Date_3__c = tryParseDate(inputItem.extendedfromdate3);
/*
                //if (String.isNotEmpty(inputItem.permittoworkdate) && inputItem.permittoworkdate != '0000-00-00') {
                //    try {
                //        safetyPermit.Permit_to_Work_Date__c = Date.valueOf(inputItem.permittoworkdate);
                //    } catch(Exception ex) {
                //        Integer year = Integer.valueOf(inputItem.permittoworkdate.substring(0, 4));
                //        Integer month = Integer.valueOf(inputItem.permittoworkdate.substring(4, 6));
                //        Integer day = Integer.valueOf(inputItem.permittoworkdate.substring(6, 8));
                //        safetyPermit.Permit_to_Work_Date__c = Date.newInstance(year, month, day);
                //    }
                //} 
                //else 
                //{ 
                //    safetyPermit.Permit_to_Work_Date__c = null;
                //}
                //if (String.isNotEmpty(inputItem.expireddate1) && inputItem.expireddate1 != '0000-00-00') {
                //    try {
                //        safetyPermit.Expired_Date_1__c = Date.valueOf(inputItem.expireddate1);
                //    } catch(Exception ex) {
                //        Integer year = Integer.valueOf(inputItem.expireddate1.substring(0, 4));
                //        Integer month = Integer.valueOf(inputItem.expireddate1.substring(4, 6));
                //        Integer day = Integer.valueOf(inputItem.expireddate1.substring(6, 8));
                //        safetyPermit.Expired_Date_1__c = Date.newInstance(year, month, day);
                //    }
                //}
                //else 
                //{ 
                //    safetyPermit.Expired_Date_1__c = null;
                //}
                //if (String.isNotEmpty(inputItem.expireddate2) && inputItem.expireddate2 != '0000-00-00') {
                //    try {
                //        safetyPermit.Expired_Date_2__c = Date.valueOf(inputItem.expireddate2);
                //    } catch(Exception ex) {
                //        Integer year = Integer.valueOf(inputItem.expireddate2.substring(0, 4));
                //        Integer month = Integer.valueOf(inputItem.expireddate2.substring(4, 6));
                //        Integer day = Integer.valueOf(inputItem.expireddate2.substring(6, 8));
                //        safetyPermit.Expired_Date_2__c = Date.newInstance(year, month, day);
                //    }
                //}
                //else 
                //{ 
                //    safetyPermit.Expired_Date_2__c = null;
                //}
                //if (String.isNotEmpty(inputItem.expireddate3) && inputItem.expireddate3 != '0000-00-00') {
                //    try {
                //        safetyPermit.Expired_Date_3__c = Date.valueOf(inputItem.expireddate3);
                //    } catch(Exception ex) {
                //        Integer year = Integer.valueOf(inputItem.expireddate3.substring(0, 4));
                //        Integer month = Integer.valueOf(inputItem.expireddate3.substring(4, 6));
                //        Integer day = Integer.valueOf(inputItem.expireddate3.substring(6, 8));
                //        safetyPermit.Expired_Date_3__c = Date.newInstance(year, month, day);
                //    }
                //}
                //else 
                //{ 
                //    safetyPermit.Expired_Date_3__c = null;
                //}
*/
                safetyPermits.put(safetyPermit.Name, safetyPermit);

            } else {
                OutputItem outputItem = new OutputItem();
                outputItem.gateway_id = gatewayId;
                outputItem.documentnumber = '[BLANK]';
                outputItem.messagetype = 'F';
                outputItem.messagetext = 'failed';
                outputItems.put(outputItem.documentnumber, outputItem);
            }
        }

        upsert safetyPermits.values() External_Key__c;

        List<Safety_Permit__c> listSafetyPermit = safetyPermits.values();
        List<Database.UpsertResult> upsertResults = Database.upsert(listSafetyPermit, Schema.Safety_Permit__c.External_Key__c, false);

        Map<Id, List<Database.Error>> errors = new Map<Id, List<Database.Error>>();
        for (Integer i = 0; i < upsertResults.size(); i++) {
            Database.UpsertResult upsertResult = upsertResults[i];

            if (outputItems.containsKey(listSafetyPermit[i].Name)) {
                OutputItem item = outputItems.get(listSafetyPermit[i].Name);
                item.sfid = listSafetyPermit[i].Id;
            }
        }

        dto_response result = new dto_response();
        result.returnvalue = outputItems.values();

        List<String> errorMessage = new List<String>();
        for (OutputItem outputItem : outputItems.values()) {
            if (outputItem.messagetype == 'F') {
                errorMessage.add(outputItem.messagetext);
            }
        }

        if (errorMessage.size() > 0) {
            Application_Log__c applog = new Application_Log__c(External_ID__c = Uuid.randomUUID());
            applog.Integration_Name__c = 'replication_SafetyPermit';
            applog.Method__c = 'Update';
            applog.Message_Type__c = 'Success';
            String requestBodySubStr = JSON.serializePretty(requestBody);
            applog.Request_Body__c = (requestBodySubStr.length() > 120000) ? requestBodySubStr.substring(0, 120000) : requestBodySubStr;
            String errorMessageSubStr = String.join(errorMessage, '\n');
            applog.Error_Message__c = (errorMessageSubStr.length() > 120000) ? errorMessageSubStr.substring(0, 120000) : errorMessageSubStr;
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
        }

        return dto_response.parse(JSON.serialize(
            new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => '' }, 'recordIds' => (new Map<Id, Safety_Permit__c>()).keySet() } ));
    }

    public static Date tryParseDate(String dateString) {
        if (String.isBlank(dateString) || dateString == '0000-00-00') {
            return null;
        }

        Date output;
        try {
            output = Date.valueOf(dateString);
        } catch(Exception ex) {
            Integer year = Integer.valueOf(dateString.substring(0, 4));
            Integer month = Integer.valueOf(dateString.substring(4, 6));
            Integer day = Integer.valueOf(dateString.substring(6, 8));
            output = Date.newInstance(year, month, day);
        }
        return output;
    }

    public static List<InputItem> tryParseInputItems(String body) {
        List<InputItem> inputItems = new List<InputItem>();
        Boolean canParseInputItem = false;
		String text = '';
        if (!canParseInputItem) {
            try {
                Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
                List<Object> rawInputs = (List<Object>)parsedBody.get('SAFETYPEMITS');
                for (Object rawInputSafetyPermit : rawInputs) {
                    Map<String, Object> inputSafetyPermit = (Map<String, Object>) rawInputSafetyPermit;
                    InputItem inputItem = new InputItem();
                    inputItem.safetypermitnumber = String.valueOf(inputSafetyPermit.get('SAFETYPERMITNUMBER'));
                    inputItem.approvalstatus = String.valueOf(inputSafetyPermit.get('APPROVALSTATUS'));
                    inputItem.planningplant = String.valueOf(inputSafetyPermit.get('PLANNINGPLANT'));
                    inputItem.typeofwcmobject = String.valueOf(inputSafetyPermit.get('TYPEOFWCMOBJECT'));
                    inputItem.functionallocation = String.valueOf(inputSafetyPermit.get('FUNCTIONALLOCATION'));
                    inputItem.partner = String.valueOf(inputSafetyPermit.get('PARTNER')).leftPad(8, '0');
                    inputItem.plannergroup = String.valueOf(inputSafetyPermit.get('PLANNERGROUP'));
                    inputItem.mainworkcenter = String.valueOf(inputSafetyPermit.get('MAINWORKCENTER'));
                    inputItem.mainworkcenterplant = String.valueOf(inputSafetyPermit.get('MAINWORKCENTERPLANT'));
                    inputItem.plantsection = String.valueOf(inputSafetyPermit.get('PLANTSECTION'));
                    inputItem.workdetail = String.valueOf(inputSafetyPermit.get('WORKDETAIL'));
                    inputItem.permitdescription = String.valueOf(inputSafetyPermit.get('PERMITDESC'));
                    inputItem.bearer1 = String.valueOf(inputSafetyPermit.get('BEARER1'));
                    inputItem.bearer2 = String.valueOf(inputSafetyPermit.get('BEARER2'));
                    inputItem.noncereq = String.valueOf(inputSafetyPermit.get('NONCEREQ')); //Boolean.valueOf(inputSafetyPermit.get('NONCEREQ'))
                    inputItem.externalae = String.valueOf(inputSafetyPermit.get('EXTAE'));
                    inputItem.ae1 = String.valueOf(inputSafetyPermit.get('AE1'));
                    inputItem.ae2 = String.valueOf(inputSafetyPermit.get('AEAPU'));
                    inputItem.agsi1 = String.valueOf(inputSafetyPermit.get('AGSI'));
                    inputItem.agsi2 = String.valueOf(inputSafetyPermit.get('AGSI2'));
                    inputItem.ram = String.valueOf(inputSafetyPermit.get('RAM'));
                    inputItem.extendcertificate = String.valueOf(inputSafetyPermit.get('EXTTYP'));
                    inputItem.permittoworkdate = String.valueOf(inputSafetyPermit.get('PERMITTOWORK'));
                    inputItem.extendedfromdate1 = String.valueOf(inputSafetyPermit.get('EXT_1F'));
                    inputItem.extendedfromdate2 = String.valueOf(inputSafetyPermit.get('EXT_2F'));
                    inputItem.extendedfromdate3 = String.valueOf(inputSafetyPermit.get('EXT_3F'));
                    inputItem.expireddate1 = String.valueOf(inputSafetyPermit.get('EXT_1T'));
                    inputItem.expireddate2 = String.valueOf(inputSafetyPermit.get('EXT_2T'));
                    inputItem.expireddate3 = String.valueOf(inputSafetyPermit.get('EXT_3T'));

                    inputItems.add(inputItem);
                }

                canParseInputItem = true;
            } catch (System.JSONException ex) {
                text = 'ex-----'+ex.getMessage()+' line:'+ex.getLineNumber();
                canParseInputItem = false;
            }
        }

        if (!canParseInputItem) {
            try {
                XmlStreamReader reader = new XmlStreamReader(body);

                Boolean isSafeToGetNextXmlElement = true;
                InputItem inputItem;
                while (isSafeToGetNextXmlElement) {
                    String localName = reader.getLocalName();
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        switch on localName  {
                            when 'safetypermit' {inputItem = new InputItem();}
                            when 'safetypermitnumber' {inputItem.safetypermitnumber = parseValue(reader, 'safetypermitnumber');}
                            when 'approvalstatus' {inputItem.approvalstatus = parseValue(reader, 'approvalstatus');}
                            when 'planningplant' {inputItem.planningplant = parseValue(reader, 'planningplant');}
                            when 'typeofwcmobject' {inputItem.typeofwcmobject = parseValue(reader, 'typeofwcmobject');}
                            when 'functionallocation' {inputItem.functionallocation = parseValue(reader, 'functionallocation');}
                            when 'partner' {inputItem.partner = parseValue(reader, 'partner');}
                            when 'plannergroup' {inputItem.plannergroup = parseValue(reader, 'plannergroup');}
                            when 'mainworkcenter' {inputItem.mainworkcenter = parseValue(reader, 'mainworkcenter');}
                            when 'mainworkcenterplant' {inputItem.mainworkcenterplant = parseValue(reader, 'mainworkcenterplant');}
                            when 'plantsection' {inputItem.plantsection = parseValue(reader, 'plantsection');}
                            when 'workdetail' {inputItem.workdetail = parseValue(reader, 'workdetail');}
                            when 'permitdescription' {inputItem.permitdescription = parseValue(reader, 'permitdescription');}
                            when 'bearer1' {inputItem.bearer1 = parseValue(reader, 'bearer1');}
                            when 'bearer2' {inputItem.bearer2 = parseValue(reader, 'bearer2');}
                            when 'noncereq' {inputItem.noncereq = parseValue(reader, 'noncereq');} //Boolean.valueOf(parseValue(reader, 'noncereq'));
                            when 'externalae' {inputItem.externalae = parseValue(reader, 'externalae');}
                            when 'ae1' {inputItem.ae1 = parseValue(reader, 'ae1');}
                            when 'ae2' {inputItem.ae2 = parseValue(reader, 'ae2');}
                            when 'agsi1' {inputItem.agsi1 = parseValue(reader, 'agsi1');}
                            when 'agsi2' {inputItem.agsi2 = parseValue(reader, 'agsi2');}
                            when 'ram' {inputItem.ram = parseValue(reader, 'ram');}
                            when 'extendcertificate' {inputItem.extendcertificate = parseValue(reader, 'extendcertificate');}
                            when 'permittoworkdate' {inputItem.permittoworkdate = parseValue(reader, 'permittoworkdate');}
                            when 'extendedfromdate1' {inputItem.extendedfromdate1 = parseValue(reader, 'extendedfromdate1');}
                            when 'extendedfromdate2' {inputItem.extendedfromdate2 = parseValue(reader, 'extendedfromdate2');}
                            when 'extendedfromdate3' {inputItem.extendedfromdate3 = parseValue(reader, 'extendedfromdate3');}
                            when 'expireddate1' {inputItem.expireddate1 = parseValue(reader, 'expireddate1');}
                            when 'expireddate2' {inputItem.expireddate2 = parseValue(reader, 'expireddate2');}
                            when 'expireddate3' {inputItem.expireddate3 = parseValue(reader, 'expireddate3');}
                        }
                    }

                    if (reader.getEventType() == XmlTag.END_ELEMENT) {
                        switch on localName {
                            when 'safetypermit' {inputItems.add(inputItem);}
                        }
                    }

                    if (reader.hasNext()) {
                        reader.next();
                    } else {
                        isSafeToGetNextXmlElement = false;
                        break;
                    }
                }

                canParseInputItem = true;
            } catch (System.JSONException ex) {
                canParseInputItem = false;
                text = 'ex-----'+ex.getMessage()+' line:'+ex.getLineNumber();
            }
        }

        if (!canParseInputItem) {
            throw new ParseException('Unknown string format, cannot parse body data. Please try XML or JSON format');
        }

        return inputItems;
    }

    public static String parseValue(XmlStreamReader reader, String fieldName) {
        String value = '';
        Boolean isSafeToGetNextXmlElement = true;
        while (isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                value = reader.getText();
            }

            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return value;
    }

}