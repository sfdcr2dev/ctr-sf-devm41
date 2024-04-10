@RestResource(urlMapping='/ODM_REST_IN_FLStatus/*')

global class ODM_REST_IN_FLStatus {
    
    global class FLStatusInputWrapper {
        String tagId;
        String tagName;
        string groupName;
        String description;
        String flId;
        String mainWorkCenter;
        String value;
        String engUnit;
        String timestamp;
        String status;
    }

    global virtual class ResponseDescription {
		global Boolean success {
			get {
				return success != null ? success : false;
			}
			set;
		}
		global String message {
			get {
				return String.isNotEmpty(message) ? message : '';
			}
			set;
		}
		global String linkurl { get; set; }
	}

    global class ResponseWrapper {
        ResponseDescription description = null;
        List<String> recordIds = null;
    }

    /*
    private static Set<String> mwc;
    public static Set<String> SAPMainWCs {
        get {
            if (mwc == null) {
                mwc = getSAPMainWCPicklist();
            }
            return mwc;
        }
    }
    */

    @HttpPost
    global static ResponseWrapper doPost() {
		RestRequest request = RestContext.request;
        Map<String, OPS_FLStatus__c> flStatusList = new Map<String, OPS_FLStatus__c>();
        //Map<String, Functional_Location__c> upsertFl = new Map<String, Functional_Location__c>();

        Map<String, Object> requestBody;
        Map<String, Object> body;
        try {
            requestBody = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
            body = (Map<String, Object>) JSON.deserializeUntyped(requestBody.get('body').toString());
        } catch(Exception ex) {
            Application_Log__c applog = new Application_Log__c(
                External_ID__c = Uuid.randomUUID(),
                Integration_Name__c = 'OPS_Update_FLStatus',
                Method__c = 'Upsert',
                Request_Body__c = request.requestBody.toString().left(131072),
                Error_Message__c = ex.getMessage(),
			    Message_Type__c = 'Fail'
            );
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                        'success' => false,
                        'message' => 'No tags field was found.',
                        'linkurl' => applog.External_ID__c
                    },
                    'recordIds' => new List<String>()
                }
            );
			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
        
            return (ResponseWrapper) JSON.deserialize(applog.Response_Body__c, ResponseWrapper.class);
        }
        
        Application_Log__c applog = new Application_Log__c(
			External_ID__c = Uuid.randomUUID(),
			Integration_Name__c = 'OPS_Update_FLStatus',
			Method__c = 'Upsert',
			Request_Body__c = JSON.serialize(body).left(131072)
		);

        if (!body.containsKey('tags')) {
            applog.Error_Message__c = 'No tags field was found.';
			applog.Message_Type__c = 'Fail';
			applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                        'success' => false,
                        'message' => 'No tags field was found.',
                        'linkurl' => applog.External_ID__c
                    },
                    'recordIds' => new List<String>()
                }
            );
			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
        
            return (ResponseWrapper) JSON.deserialize(applog.Response_Body__c, ResponseWrapper.class);
        }

        List<Object> tags = (List<Object>) body.get('tags');
        List<String> flNameList = new List<String>();
        List<FLStatusInputWrapper> inputs = new List<FLStatusInputWrapper>();
        for (Object oItem : tags) {
            FLStatusInputWrapper tag = (FLStatusInputWrapper) JSON.deserialize(
                JSON.serialize(oItem), FLStatusInputWrapper.class);
            inputs.add(tag);

            if (String.isNotBlank(tag.flId)) {
                flNameList.add(tag.flId);
            }
        }

        Map<String, Functional_Location__c> flList = new Map<String, Functional_Location__c>();
        if (flNameList.size() > 0) {
            for (Functional_Location__c fl : [SELECT Id, Name FROM Functional_Location__c WHERE Name IN :flNameList]) {
                flList.put(fl.Name, fl);
            }
        }

        for (FLStatusInputWrapper tag : inputs) {
            OPS_FLStatus__c flStatus = new OPS_FLStatus__c();

            flStatus.Tag_ID__c = tag.tagId;
            flStatus.Tag_Name__c = tag.tagName;
            flStatus.Group_Name__c = tag.groupName;
            flStatus.Description__c = tag.description;
            flStatus.Functional_Location_Text__c = tag.flId;
            flStatus.SAP_MainWC_Text__c = tag.mainWorkCenter;
            flStatus.Values__c = tag.value;
            flStatus.Engineering_Unit__c = tag.engUnit;
            flStatus.Time_Stamp_Text__c = tag.timestamp;
            flStatus.Status__c = tag.status;

            if (String.isNotBlank(tag.flId)) {
            //    flStatus.Functional_Location__r = new Functional_Location__c(Name = tag.flId);
            //    upsertFl.put(tag.flId, new Functional_Location__c(Name = tag.flId));
                flStatus.Functional_Location__c = flList.get(tag.flId).Id;
            }
            //if (isSAPMainWCFieldPicklist()) {
            //    if (SAPMainWCs.contains(tag.mainWorkCenter)) {
            //        flStatus.SAP_MainWC__c = tag.mainWorkCenter;
            //    }
            //} else {
                flStatus.SAP_MainWC__c = tag.mainWorkCenter;
            //}
            flStatus.Time_Stamp__c = tryParseDatetime(tag.timestamp);

            if (flStatus.Status__c == '1') {
                flStatus.Values__c = null;
            }

            if (flStatusList.containsKey(flStatus.Tag_ID__c)) {
                if (flStatus.Time_Stamp__c > flStatusList.get(flStatus.Tag_ID__c).Time_Stamp__c) {
                    flStatusList.put(flStatus.Tag_ID__c, flStatus);
                }
            } else {
                flStatusList.put(flStatus.Tag_ID__c, flStatus);
            }
        }
        
        //upsert upsertFL.values() Name;
        Database.upsert(flStatusList.values(), OPS_FLStatus__c.Tag_ID__c, false);

        List<String> recordIds = new List<String>();
        for (OPS_FLStatus__c flStatus : flStatusList.values()) {
            recordIds.add(flStatus.Id);
        }
        
        applog.Error_Message__c = '';
        applog.Message_Type__c = 'Success';
        applog.Response_Body__c = JSON.serialize(
            new Map<String, Object>{
                'description' => new Map<String, Object>{
                    'success' => true,
                    'message' => 'FL Status have been update successfully.',
                    'linkurl' => applog.External_ID__c
                },
                'recordIds' => recordIds
            }
        );
        ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
    
        return (ResponseWrapper) JSON.deserialize(applog.Response_Body__c, ResponseWrapper.class);
    }

    /*
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
    */

    public static Datetime tryParseDatetime(String dateTimeString) {
        if (String.isBlank(dateTimeString)) {
            return null;
        }

        List<String> parts = dateTimeString.split(' ');
        /*
        String amOrPm = parts[parts.size() - 1];
        if (amOrPm == 'AM' || amOrPm == 'PM') {
            List<String> datePart = parts[0].split('/');
            List<String> timePart = parts[1].split(':');

            Integer year = Integer.valueOf(datePart[2]);
            Integer month = Integer.valueOf(datePart[0]);
            Integer day = Integer.valueOf(datePart[1]);

            Integer hour = Integer.valueOf(timePart[0]);
            Integer minute = Integer.valueOf(timePart[1]);
            Integer second = Integer.valueOf(timePart[2]);

            if (amOrPm == 'AM' && hour == 12) {
                hour = 0;
            }

            return Datetime.newInstance(year, month, day, hour, minute, second);
        }
        */

        List<String> datePart = parts[0].split('-');
        List<String> timePart = parts[1].split(':');

        Integer year = Integer.valueOf(datePart[0]);
        Integer month = Integer.valueOf(datePart[1]);
        Integer day = Integer.valueOf(datePart[2]);

        Integer hour = Integer.valueOf(timePart[0]);
        Integer minute = Integer.valueOf(timePart[1]);
        Integer second = Integer.valueOf(timePart[2]);

        return Datetime.newInstance(year, month, day, hour, minute, second);
    }

    public static Boolean isSAPMainWCFieldPicklist() {
        Schema.DisplayType mainWorkCenter = OPS_FLStatus__c.SAP_MainWC__c.getDescribe().getType();
        return mainWorkCenter.name().equalsIgnoreCase('PICKLIST');
    }

    /*
    public static Set<String> getSAPMainWCPicklist() {
        Schema.DescribeFieldResult fieldResult = OPS_FLStatus__c.SAP_MainWC__c.getDescribe();
        List<Schema.PicklistEntry> picklists = fieldResult.getPicklistValues();

        Set<String> sapMainWCs = new Set<String>();
        for (Schema.PicklistEntry picklist : picklists) {
            sapMainWCs.add(picklist.getValue());
        }

        return sapMainWCs;
    }
    */
}