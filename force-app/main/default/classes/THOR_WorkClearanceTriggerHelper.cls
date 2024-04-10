public class THOR_WorkClearanceTriggerHelper {
    private static String convertDateTimeToDateString(DateTime dt) {
        String output = '';
        if (dt != null) {
            String strDate = String.valueOf(dt.day()).leftPad(2, '0');
            String strMonth = String.valueOf(dt.month()).leftPad(2, '0');
            String strYear = String.valueOf(dt.yearGMT()).leftPad(4, '0');
            output = strDate + '.' + strMonth + '.' + strYear;
        }
        return output;
    }
    private static String convertDateToString(Date dt) {
        String output = '';
        if (dt != null) {
            String strDate = String.valueOf(dt.day()).leftPad(2, '0');
            String strMonth = String.valueOf(dt.month()).leftPad(2, '0');
            String strYear = String.valueOf(dt.year()).leftPad(4, '0');
            output = strDate + '.' + strMonth + '.' + strYear;
        }
        return output;
    }
    private static String convertTimeToString(Time tm) {
        String output = '';
        if (tm != null) {
            String strHour = String.valueOf(tm.hour()).leftPad(2, '0');
            String strMinute = String.valueOf(tm.minute()).leftPad(2, '0');
            String strSecond = String.valueOf(tm.second()).leftPad(2, '0');
            output = strHour + ':' + strMinute + ':' + strSecond;
        }
        return output;
    }
    private static THOR_Work_Clearance_Historical__c makeWorkClearanceHistory(Work_Clearance__c wc) {
        THOR_Work_Clearance_Historical__c wch = new THOR_Work_Clearance_Historical__c();
        Map<String, Schema.SObjectField> mapFieldWch = Schema.SObjectType.THOR_Work_Clearance_Historical__c.fields.getMap();
        Map<String, Schema.SObjectField> mapFieldWc = Schema.SObjectType.Work_Clearance__c.fields.getMap();
        Set<String> setFieldWch = mapFieldWch.keySet();
        Set<String> setFieldWc = mapFieldWc.keySet();
        Set<String> setField = new Set<String>();
        Set<String> setFieldExclude = new Set<String>{ 'id', 'ownerid', 'isdeleted', 'createddate', 'createdbyid', 'lastmodifieddate', 'lastmodifiedbyid', 'systemmodstamp', 'lastactivitydate', 'lastvieweddate', 'lastreferenceddate', 'external_key__c', 'extend_time_flag_formula__c', 'priority_map__c', 'sign_off_flag_formula__c', 'functional_location__c', 'work_clearance_status__c', 'maintenance_plant__c', 'location__c' };
        for (String field : setFieldWch) {
            if (setFieldWc.contains(field) && !setFieldExclude.contains(field)) setField.add(field);
        }
        
        for (String field : setField) {
            wch.put(field, wc.get(field));
        }
        return wch;
    }
    private static void updateLookupFieldToTextField(List<Work_Clearance__c> newWCs, Map<Id, Work_Clearance__c> oldWcs) {
        System.debug('updateLookupFieldToTextField');
        List<Id> bearerIdList = new List<Id>();
        List<Id> pisIdList = new List<Id>();
        List<Id> permitIdList = new List<Id>();
        Set<Id> orderIdsSet = new Set<Id>();
        for (Work_Clearance__c newWC : newWCs) {
            bearerIdList.add(newWC.applicant_or_bearer_ui__c);
            bearerIdList.add(newWC.bearer1_ui__c);
            bearerIdList.add(newWC.bearer2_ui__c);
            bearerIdList.add(newWC.bearer3_ui__c);
            bearerIdList.add(newWC.bearer4_ui__c);
            permitIdList.add(newWC.safety_permit1_ui__c);
            permitIdList.add(newWC.safety_permit2_ui__c);
            permitIdList.add(newWC.safety_permit3_ui__c);            
            if (newWC.Order__c != null) orderIdsSet.add(newWC.Order__c);
        }
        Map<Id, THOR_Applicant_Bearer__c> bearerMap = new Map<Id, THOR_Applicant_Bearer__c>( [SELECT Id, Name, Description__c FROM THOR_Applicant_Bearer__c WHERE Id IN :bearerIdList] );
        Map<Id, Safety_Permit__c> permitMap = new Map<Id, Safety_Permit__c>( [SELECT Id, Name FROM Safety_Permit__c WHERE Id IN :permitIdList] );
        Map<Id, Order__c> orderMap = new Map<Id, Order__c>( [SELECT Id, Finished_Date__c FROM Order__c WHERE Id IN :orderIdsSet] );        
        for (Work_Clearance__c newWC : newWCs) {
            Work_Clearance__c oldWc = new Work_Clearance__c();
            if(oldWcs.get(newWC.Id )!= null) oldWc = oldWcs.get(newWC.Id);  
            if (bearerMap.containsKey(newWC.applicant_or_bearer_ui__c)) newWC.applicant_or_bearer__c = bearerMap.get(newWC.applicant_or_bearer_ui__c).Description__c;
            if (bearerMap.containsKey(newWC.bearer1_ui__c)) newWC.bearer1__c = bearerMap.get(newWC.bearer1_ui__c).Description__c;
            if (bearerMap.containsKey(newWC.bearer2_ui__c)) newWC.bearer2__c = bearerMap.get(newWC.bearer2_ui__c).Description__c;
            if (bearerMap.containsKey(newWC.bearer3_ui__c)) newWC.bearer3__c = bearerMap.get(newWC.bearer3_ui__c).Description__c;
            if (bearerMap.containsKey(newWC.bearer4_ui__c)) newWC.bearer4__c = bearerMap.get(newWC.bearer4_ui__c).Description__c;
            if (permitMap.containsKey(newWC.safety_permit1_ui__c)) newWC.safety_permit1__c = permitMap.get(newWC.safety_permit1_ui__c).Name;
            if (permitMap.containsKey(newWC.safety_permit2_ui__c)) newWC.safety_permit2__c = permitMap.get(newWC.safety_permit2_ui__c).Name;
            if (permitMap.containsKey(newWC.safety_permit3_ui__c)) newWC.safety_permit3__c = permitMap.get(newWC.safety_permit3_ui__c).Name;
            if (newWC.extend_time_to_ui__c != null) newWC.extend_time_to__c = String.valueOf(newWC.extend_time_to_ui__c.hour()).leftPad(2, '0') + ':' + String.valueOf(newWC.extend_time_to_ui__c.minute()).leftPad(2, '0') + ':' + String.valueOf(newWC.extend_time_to_ui__c.second()).leftPad(2, '0');
            if (newWC.start_date__c == null) {
                DateTime dt = DateTime.now();
                newWC.start_date__c = convertDateTimeToDateString(DateTime.now());
            }
            if (newWC.Order__c != null) {
                Order__c orders = orderMap.get(newWC.Order__c);
                DateTime dt = DateTime.now() > orders.Finished_Date__c ? orders.Finished_Date__c : DateTime.now();
                newWC.start_date__c = convertDateTimeToDateString(DateTime.now());
            }
            /**
            * @description Improvement host id or home id for pis user
            */

            if (!THOR_iRPAIntegration.ISADMIN || true) {
                Map<String, List<String>> lookupFields = new Map<String, List<String>>{ 'Thaioil_Supervisor_Indicator_UI__c' => new List<String>{ 'TOPGroupApplicantorBearer_PISUser_Text__c', 'Thaioil_Supervisor_Indicator__c' }, 'Requester_UI__c' => new List<String>{ 'Requester__c' }, 'Authorized_Indicator_UI__c' => new List<String>{ 'Authorized_Indicator__c' }, 'Authorized_Signature_UI__c' => new List<String>{ 'Authorized_Signature__c' }, 'Authorized_Signatory_UI__c' => new List<String>{ 'Authorized_Signatory__c' }, 'Extend_Applicant_or_Bearer_UI__c' => new List<String>{ 'ExtendApplicantOrBearer_PISUser_Text__c', 'Extend_Applicant_or_Bearer__c' }, 'Extend_Authorized_Sign_UI__c' => new List<String>{ 'Extend_Authorized_Sign__c' }, 'Close_Applicant_or_Bearer_UI__c' => new List<String>{ 'CloseApplicantorBearer_PISUser_Text__c', 'Close_Applicant_or_Bearer__c' }, 'Close_Authorized_Sign_Off_UI__c' => new List<String>{ 'Close_Authorized_Sign_Off__c' }, 'AGT_UI__c' => new List<String>{ 'AGT__c' } };
                    for (String uiFieldName : lookupFields.keySet()) {
                        String newUiValue = (String) newWC.get(uiFieldName);
                        String oldUiValue = '';
                        if(oldWc != null) oldUiValue = (String) oldWc.get(uiFieldName);
                        Boolean isUiChanged = (newUiValue != oldUiValue);
                        if (!isUiChanged) continue;
                        String hostId = THOR_IRPAIntegration.pisUserMap.get(newUiValue)?.HOST_ID__c;
                        String homeId = THOR_IRPAIntegration.pisUserMap.get(newUiValue)?.HOME_ID__c;
                        List<String> listTextField = lookupFields.get(uiFieldName);
                        for (String field : listTextField) {
                            String oldTextValue = null;
                            if(oldWc != null) oldTextValue = (String) oldWc.get(field);
                            if (oldTextValue == null || (hostId != oldTextValue && homeId != oldTextValue)) {
                                String value = (hostId != null) ? hostId : homeId;
                                newWC.put(field, value);
                            }
                        }
                    }
            }
            newWc.Authorized_Date__c = convertDateToString(newWc.Authorized_Date_UI__c);
            newWc.Authorized_Time__c = convertTimeToString(newWc.Authorized_Time_UI__c);
            newWc.Check_Date__c = convertDateToString(newWc.Check_Date_UI__c);
            newWc.Check_Time__c = convertTimeToString(newWc.Check_Time_UI__c);
            newWc.Flamable_gas__c = !String.isBlank(newWc.Flamable_amt__c) ? 'X' : '';
            newWc.Oxygen__c = !String.isBlank(newWc.Oxygen_amt__c) ? 'X' : '';
            newWc.Toxic__c = !String.isBlank(newWc.Toxic_Type__c) || !String.isBlank(newWc.Toxic_PPM__c) ? 'X' : '';
            newWc.Permit_flag__c = !String.isBlank(newWc.Safety_Permit1__c) || !String.isBlank(newWc.Safety_Permit2__c) || !String.isBlank(newWc.Safety_Permit3__c) ? 'X' : '';
            newWc.PPE_Flag__c = !String.isBlank(newWc.PPE1__c) || !String.isBlank(newWc.PPE2__c) || !String.isBlank(newWc.PPE3__c) ? 'X' : '';
            newWc.Extend_Time_Flag__c = !String.isBlank(newWc.Extend_Time_To__c) ? 'X' : '';
            newWc.Sign_off_Flag__c = (newWc.Work_Clearance_Status__c == 'Closed') ? 'X' : '';
        }
    }
    public static void createOrUpdateWorkClearanceHistorical(List<Work_Clearance__c> newWCs) {
        createOrUpdateWorkClearanceHistorical(newWCs, null);
    }
    public static void createOrUpdateWorkClearanceHistorical( List<Work_Clearance__c> newWCs, List<Work_Clearance__c> oldWCs ) {
        updateLookupFieldToTextField(newWCs, oldWCs != null ? new Map<Id, Work_Clearance__c>(oldWCs) : new Map<Id, Work_Clearance__c>());
        if (newWCs != null && newWCs.size() > 0) {
            Map<Id, THOR_Work_Clearance_Historical__c> createWCHistoricals = new Map<Id, THOR_Work_Clearance_Historical__c>();
            for (Work_Clearance__c newWC : newWCs) {
                if (!String.isEmpty(newWC.Name)) {
                    newWC.Work_Clearance__c = newWC.Name;
                    THOR_Work_Clearance_Historical__c wch = makeWorkClearanceHistory(newWC);
                    wch.External_Key__c = (String.isEmpty(newWC.Extend_No__c))?newWC.Name:newWC.Name + '/' + newWC.Extend_No__c;
                    createWCHistoricals.put(newWC.Id, wch);
                }
            }
            upsert createWCHistoricals.values() External_Key__c;
            for (Work_Clearance__c wc : newWCs) {
                if (createWCHistoricals.containsKey(wc.Id)) wc.Work_Clearance_Historical__c = createWCHistoricals.get(wc.Id).Id;
            }
        }
        for (Work_Clearance__c newWC : newWCs) {
            newWC.Last_User_Action_Status__c = 'Completed';
        }
    }
    public static void updateWorkClearanceHistoricalParentId(Map<Id, SObject> newItems) {
        Map<Id, Work_Clearance__c> newWCs = new Map<Id, Work_Clearance__c>((List<Work_Clearance__c>) newItems.values());
        Map<Id, THOR_Work_Clearance_Historical__c> updateWCHisticals = new Map<Id, THOR_Work_Clearance_Historical__c>();
        for (Id key : newWCs.keySet()) {
            Work_Clearance__c newWC = newWCs.get(key);
            THOR_Work_Clearance_Historical__c wch = new THOR_Work_Clearance_Historical__c(
                External_Key__c = (String.isEmpty(newWC.Extend_No__c)) ? newWC.Name:newWC.Name + '/' + newWC.Extend_No__c,
                WorkClearanceId__c = newWC.Id
            );
            updateWCHisticals.put(key, wch);
        }
        upsert updateWCHisticals.values() External_Key__c;
    }
}

// public class THOR_WorkClearanceTriggerHelper {
//     private static String convertDateTimeToDateString(DateTime dt) {
//         String output = '';
//         if (dt != null) {
//             String strDate = String.valueOf(dt.day()).leftPad(2, '0');
//             String strMonth = String.valueOf(dt.month()).leftPad(2, '0');
//             String strYear = String.valueOf(dt.yearGMT()).leftPad(4, '0');
//             output = strDate + '.' + strMonth + '.' + strYear;
//         }
//         return output;
//     }
//     private static String convertDateToString(Date dt) {
//         String output = '';
//         if (dt != null) {
//             String strDate = String.valueOf(dt.day()).leftPad(2, '0');
//             String strMonth = String.valueOf(dt.month()).leftPad(2, '0');
//             String strYear = String.valueOf(dt.year()).leftPad(4, '0');
//             output = strDate + '.' + strMonth + '.' + strYear;
//         }
//         return output;
//     }
//     private static String convertTimeToString(Time tm) {
//         String output = '';
//         if (tm != null) {
//             String strHour = String.valueOf(tm.hour()).leftPad(2, '0');
//             String strMinute = String.valueOf(tm.minute()).leftPad(2, '0');
//             String strSecond = String.valueOf(tm.second()).leftPad(2, '0');
//             output = strHour + ':' + strMinute + ':' + strSecond;
//         }
//         return output;
//     }
//     private static THOR_Work_Clearance_Historical__c makeWorkClearanceHistory(Work_Clearance__c wc) {
//         THOR_Work_Clearance_Historical__c wch = new THOR_Work_Clearance_Historical__c();
//         Map<String, Schema.SObjectField> mapFieldWch = Schema.SObjectType.THOR_Work_Clearance_Historical__c.fields.getMap();
//         Map<String, Schema.SObjectField> mapFieldWc = Schema.SObjectType.Work_Clearance__c.fields.getMap();
//         Set<String> setFieldWch = mapFieldWch.keySet();
//         Set<String> setFieldWc = mapFieldWc.keySet();
//         Set<String> setField = new Set<String>();
//         Set<String> setFieldExclude = new Set<String>{ 'id', 'ownerid', 'isdeleted', 'createddate', 'createdbyid', 'lastmodifieddate', 'lastmodifiedbyid', 'systemmodstamp', 'lastactivitydate', 'lastvieweddate', 'lastreferenceddate', 'external_key__c', 'extend_time_flag_formula__c', 'priority_map__c', 'sign_off_flag_formula__c', 'functional_location__c' };
//             for (String field : setFieldWch) {
//                 if (setFieldWc.contains(field) && !setFieldExclude.contains(field)) setField.add(field);
//             }
//         
//         for (String field : setField) {
//             wch.put(field, wc.get(field));
//         }
//         return wch;
//     }
//     private static void updateLookupFieldToTextField(List<Work_Clearance__c> newWCs, Map<Id, Work_Clearance__c> oldWcs) {
//         System.debug('updateLookupFieldToTextField');
//         List<Id> bearerIdList = new List<Id>();
//         List<Id> pisIdList = new List<Id>();
//         List<Id> permitIdList = new List<Id>();
//         Set<Id> orderIdsSet = new Set<Id>();
//         for (Work_Clearance__c newWC : newWCs) {
//             bearerIdList.add(newWC.applicant_or_bearer_ui__c);
//             bearerIdList.add(newWC.bearer1_ui__c);
//             bearerIdList.add(newWC.bearer2_ui__c);
//             bearerIdList.add(newWC.bearer3_ui__c);
//             bearerIdList.add(newWC.bearer4_ui__c);
//             permitIdList.add(newWC.safety_permit1_ui__c);
//             permitIdList.add(newWC.safety_permit2_ui__c);
//             permitIdList.add(newWC.safety_permit3_ui__c);            
//             if (newWC.Order__c != null) orderIdsSet.add(newWC.Order__c);
//         }
//         Map<Id, THOR_Applicant_Bearer__c> bearerMap = new Map<Id, THOR_Applicant_Bearer__c>( [SELECT Id, Name, Description__c FROM THOR_Applicant_Bearer__c WHERE Id IN :bearerIdList] );
//         Map<Id, Safety_Permit__c> permitMap = new Map<Id, Safety_Permit__c>( [SELECT Id, Name FROM Safety_Permit__c WHERE Id IN :permitIdList] );
//         Map<Id, Order__c> orderMap = new Map<Id, Order__c>( [SELECT Id, Finished_Date__c FROM Order__c WHERE Id IN :orderIdsSet] );        
//         for (Work_Clearance__c newWC : newWCs) {
//             Work_Clearance__c oldWc = new Work_Clearance__c();
//             if(oldWcs.get(newWC.Id )!= null) oldWc = oldWcs.get(newWC.Id);  
//             if (bearerMap.containsKey(newWC.applicant_or_bearer_ui__c)) newWC.applicant_or_bearer__c = bearerMap.get(newWC.applicant_or_bearer_ui__c).Description__c;
//             if (bearerMap.containsKey(newWC.bearer1_ui__c)) newWC.bearer1__c = bearerMap.get(newWC.bearer1_ui__c).Description__c;
//             if (bearerMap.containsKey(newWC.bearer2_ui__c)) newWC.bearer2__c = bearerMap.get(newWC.bearer2_ui__c).Description__c;
//             if (bearerMap.containsKey(newWC.bearer3_ui__c)) newWC.bearer3__c = bearerMap.get(newWC.bearer3_ui__c).Description__c;
//             if (bearerMap.containsKey(newWC.bearer4_ui__c)) newWC.bearer4__c = bearerMap.get(newWC.bearer4_ui__c).Description__c;
// //if (bearerMap.containsKey(newWC.close_applicant_or_bearer_ui__c)) {
// //newWC.close_applicant_or_bearer__c = bearerMap.get(newWC.close_applicant_or_bearer_ui__c).Description__c;
// //}
// //if (pisMap.containsKey(newWC.close_applicant_or_bearer_ui__c)) {
// //	newWC.close_applicant_or_bearer__c = pisMap.get(newWC.close_applicant_or_bearer_ui__c).Name;
// //}
// //if (bearerMap.containsKey(newWC.extend_applicant_or_bearer_ui__c)) {
// //newWC.extend_applicant_or_bearer__c = bearerMap.get(newWC.extend_applicant_or_bearer_ui__c).Description__c;
// //}
// //if (pisMap.containsKey(newWC.extend_applicant_or_bearer_ui__c)) {
// //	newWC.extend_applicant_or_bearer__c = pisMap.get(newWC.extend_applicant_or_bearer_ui__c).Name;
// //}
// //if (pisMap.containsKey(newWC.thaioil_supervisor_indicator_ui__c)) {
// //	newWC.thaioil_supervisor_indicator__c = pisMap.get(newWC.thaioil_supervisor_indicator_ui__c).Name;
// //}
// //if (pisMap.containsKey(newWC.requester_ui__c)) {
// //	newWC.requester__c = pisMap.get(newWC.requester_ui__c).Name;
// //}
//             if (permitMap.containsKey(newWC.safety_permit1_ui__c)) newWC.safety_permit1__c = permitMap.get(newWC.safety_permit1_ui__c).Name;
//             if (permitMap.containsKey(newWC.safety_permit2_ui__c)) newWC.safety_permit2__c = permitMap.get(newWC.safety_permit2_ui__c).Name;
//             if (permitMap.containsKey(newWC.safety_permit3_ui__c)) newWC.safety_permit3__c = permitMap.get(newWC.safety_permit3_ui__c).Name;
//             if (newWC.extend_time_to_ui__c != null) newWC.extend_time_to__c = String.valueOf(newWC.extend_time_to_ui__c.hour()).leftPad(2, '0') + ':' + String.valueOf(newWC.extend_time_to_ui__c.minute()).leftPad(2, '0') + ':' + String.valueOf(newWC.extend_time_to_ui__c.second()).leftPad(2, '0');
//             if (newWC.start_date__c == null) {
//                 DateTime dt = DateTime.now();
//                 newWC.start_date__c = convertDateTimeToDateString(DateTime.now());
//             }
//             if (newWC.Order__c != null) {
//                 Order__c orders = orderMap.get(newWC.Order__c);
//                 DateTime dt = DateTime.now() > orders.Finished_Date__c ? orders.Finished_Date__c : DateTime.now();
//                 newWC.start_date__c = convertDateTimeToDateString(DateTime.now());
//             }
//             /**
// * @description Improvement host id or home id for pis user
// */
// 
//             if (!THOR_iRPAIntegration.ISADMIN || true) {
//                 Map<String, List<String>> lookupFields = new Map<String, List<String>>{ 'Thaioil_Supervisor_Indicator_UI__c' => new List<String>{ 'TOPGroupApplicantorBearer_PISUser_Text__c', 'Thaioil_Supervisor_Indicator__c' }, 'Requester_UI__c' => new List<String>{ 'Requester__c' }, 'Authorized_Indicator_UI__c' => new List<String>{ 'Authorized_Indicator__c' }, 'Authorized_Signature_UI__c' => new List<String>{ 'Authorized_Signature__c' }, 'Authorized_Signatory_UI__c' => new List<String>{ 'Authorized_Signatory__c' }, 'Extend_Applicant_or_Bearer_UI__c' => new List<String>{ 'ExtendApplicantOrBearer_PISUser_Text__c', 'Extend_Applicant_or_Bearer__c' }, 'Extend_Authorized_Sign_UI__c' => new List<String>{ 'Extend_Authorized_Sign__c' }, 'Close_Applicant_or_Bearer_UI__c' => new List<String>{ 'CloseApplicantorBearer_PISUser_Text__c', 'Close_Applicant_or_Bearer__c' }, 'Close_Authorized_Sign_Off_UI__c' => new List<String>{ 'Close_Authorized_Sign_Off__c' }, 'AGT_UI__c' => new List<String>{ 'AGT__c' } };
//                     for (String uiFieldName : lookupFields.keySet()) {
//                         String newUiValue = (String) newWC.get(uiFieldName);
//                         String oldUiValue = '';
//                         if(oldWc != null) oldUiValue = (String) oldWc.get(uiFieldName);
//                         Boolean isUiChanged = (newUiValue != oldUiValue);
//                         if (!isUiChanged) continue;
//                         String hostId = THOR_IRPAIntegration.pisUserMap.get(newUiValue)?.HOST_ID__c;
//                         String homeId = THOR_IRPAIntegration.pisUserMap.get(newUiValue)?.HOME_ID__c;
//                         List<String> listTextField = lookupFields.get(uiFieldName);
//                         for (String field : listTextField) {
//                             String oldTextValue = null;
//                             if(oldWc != null) oldTextValue = (String) oldWc.get(field);
//                             if (oldTextValue == null || (hostId != oldTextValue && homeId != oldTextValue)) {
//                                 String value = (hostId != null) ? hostId : homeId;
//                                 newWC.put(field, value);
//                             }
//                         }
//                     }
//             }
//             newWc.Authorized_Date__c = convertDateToString(newWc.Authorized_Date_UI__c);
//             newWc.Authorized_Time__c = convertTimeToString(newWc.Authorized_Time_UI__c);
//             newWc.Check_Date__c = convertDateToString(newWc.Check_Date_UI__c);
//             newWc.Check_Time__c = convertTimeToString(newWc.Check_Time_UI__c);
//             newWc.Flamable_gas__c = !String.isBlank(newWc.Flamable_amt__c) ? 'X' : '';
//             newWc.Oxygen__c = !String.isBlank(newWc.Oxygen_amt__c) ? 'X' : '';
//             newWc.Toxic__c = !String.isBlank(newWc.Toxic_Type__c) || !String.isBlank(newWc.Toxic_PPM__c) ? 'X' : '';
//             newWc.Permit_flag__c = !String.isBlank(newWc.Safety_Permit1__c) || !String.isBlank(newWc.Safety_Permit2__c) || !String.isBlank(newWc.Safety_Permit3__c) ? 'X' : '';
//             newWc.PPE_Flag__c = !String.isBlank(newWc.PPE1__c) || !String.isBlank(newWc.PPE2__c) || !String.isBlank(newWc.PPE3__c) ? 'X' : '';
//             newWc.Extend_Time_Flag__c = !String.isBlank(newWc.Extend_Time_To__c) ? 'X' : '';
//             newWc.Sign_off_Flag__c = (newWc.Work_Clearance_Status__c == 'Closed') ? 'X' : '';
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Thaioil_Supervisor_Indicator_UI__c != oldWc?.Thaioil_Supervisor_Indicator_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Thaioil_Supervisor_Indicator_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Thaioil_Supervisor_Indicator_UI__c)?.HOME_ID__c;
// // 	newWC.TOPGroupApplicantorBearer_PISUser_Text__c = hostId != null ? hostId : homeId;
// // 	newWC.thaioil_supervisor_indicator__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Extend_Applicant_or_Bearer_UI__c != oldWc?.Extend_Applicant_or_Bearer_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Extend_Applicant_or_Bearer_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Extend_Applicant_or_Bearer_UI__c)?.HOME_ID__c;
// // 	newWC.ExtendApplicantOrBearer_PISUser_Text__c = hostId != null ? hostId : homeId;
// // 	newWC.extend_applicant_or_bearer__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Close_Applicant_or_Bearer_UI__c != oldWc?.Close_Applicant_or_Bearer_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Close_Applicant_or_Bearer_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Close_Applicant_or_Bearer_UI__c)?.HOME_ID__c;
// // 	newWC.CloseApplicantorBearer_PISUser_Text__c = hostId != null ? hostId : homeId;
// // 	newWC.close_applicant_or_bearer__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Requester_UI__c != oldWc?.Requester_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Requester_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Requester_UI__c)?.HOME_ID__c;
// // 	newWC.Requester__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Authorized_Signatory_UI__c != oldWc?.Authorized_Signatory_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Authorized_Signatory_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Authorized_Signatory_UI__c)?.HOME_ID__c;
// // 	newWC.Authorized_Signatory__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Authorized_Indicator_UI__c != oldWc?.Authorized_Indicator_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Authorized_Indicator_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Authorized_Indicator_UI__c)?.HOME_ID__c;
// // 	newWC.Authorized_Indicator__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Authorized_Signature_UI__c != oldWc?.Authorized_Signature_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Authorized_Signature_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Authorized_Signature_UI__c)?.HOME_ID__c;
// // 	newWC.Authorized_Signature__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Extend_Authorized_Sign_UI__c != oldWc?.Extend_Authorized_Sign_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Extend_Authorized_Sign_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Extend_Authorized_Sign_UI__c)?.HOME_ID__c;
// // 	newWC.Extend_Authorized_Sign__c = hostId != null ? hostId : homeId;
// // }
// // if (!THOR_iRPAIntegration.ISADMIN && newWC.Close_Authorized_Sign_off_UI__c != oldWc?.Close_Authorized_Sign_off_UI__c) {
// // 	String hostId = THOR_IRPAIntegration.pisUserMap.get(newWC.Close_Authorized_Sign_off_UI__c)?.HOST_ID__c;
// // 	String homeId = THOR_IRPAIntegration.pisUserMap.get(newWC.Close_Authorized_Sign_off_UI__c)?.HOME_ID__c;
// // 	newWC.Close_Authorized_Sign_off__c = hostId != null ? hostId : homeId;
// // }
//         }
//     }
//     public static void createOrUpdateWorkClearanceHistorical(List<Work_Clearance__c> newWCs) {
//         createOrUpdateWorkClearanceHistorical(newWCs, null);
//     }
//     //    public static void createOrUpdateWorkClearanceHistorical(List<Work_Clearance__c> newWCs, List<Work_Clearance__c> oldWCs) {
// //        updateLookupFieldToTextField(newWCs);
// //        if (newWCs != null && newWCs.size() > 0) {
// //            Map<Id, THOR_Work_Clearance_Historical__c> createWCHistoricals = new Map<Id, THOR_Work_Clearance_Historical__c>();
// //            for (Work_Clearance__c newWC : newWCs) {
// //                System.debug('Action => ' + newWC.Last_User_Action__c);
// //                System.debug('BAPI => ' + newWC.isBAPI__c);
// //                if ((newWC.Last_User_Action__c == 'Create'
// //                    || newWC.Last_User_Action__c == 'Will be Continue Next Day'
// //                    || newWC.Last_User_Action__c == 'Extend from Normal Hours'
// //                    || newWC.Last_User_Action__c == 'Extend Other Day')
// //                    && newWC.isBAPI__c == true)
// //                {
// //                    newWC.Work_Clearance__c = newWC.Name;
// //                    newWC.isBAPI__c = false;
// //
// //                    //THOR_Work_Clearance_Historical__c wch = new THOR_Work_Clearance_Historical__c();
// //                    //wch.Name = newWC.Work_Clearance__c;
// //                    //if (String.isNotBlank(newWC.Extend_No__c)) {
// //                    //    wch.Name = String.format('{0}/{1}', new List<String>{ newWC.Work_Clearance__c, newWC.Extend_No__c });
// //                    //}
// //                    //wch.Work_Clearance__c = newWC.Work_Clearance__c;
// //                    //wch.Description__c = newWC.Description__c;
// //                    //createWCHistoricals.put(newWC.Id, wch);
// //
// //                    THOR_Work_Clearance_Historical__c wch = makeWorkClearanceHistory(newWC);
// //                    createWCHistoricals.put(newWC.Id, wch);
// //                }
// //            }
// //            System.debug('createWCHistoricals => ' + createWCHistoricals);
// //            insert createWCHistoricals.values();
// //
// //            for (Work_Clearance__c wc : newWCs) {
// //                if (createWCHistoricals.containsKey(wc.Id)) {
// //                    wc.Work_Clearance_Historical__c = createWCHistoricals.get(wc.Id).Id;
// //                }
// //            }
// //        }
// //
// //        if (newWCs != null && newWCs.size() > 0 && oldWCs != null && oldWCs.size() > 0 && newWCs.size() == oldWCs.size()) {
// //            Map<Id, THOR_Work_Clearance_Historical__c> updateWCHistoricals = new Map<Id, THOR_Work_Clearance_Historical__c>();
// //            Integer count = oldWcs.size();
// //            for (Integer i = 0; i < count; i++) {
// //                Work_Clearance__c oldWC = oldWCs[i];
// //                Work_Clearance__c newWC = newWCs[i];
// //
// //                System.debug('Last User Action => ' + newWC.Last_User_Action__c);
// //                System.debug('Last User Action Status => ' + newWC.Last_User_Action_Status__c);
// //                System.debug('Last User Action Status => ' + oldWC.Last_User_Action_Status__c);
// //                if ((newWC.Last_User_Action__c == 'Edit'
// //                    || newWC.Last_User_Action__c == 'Continue')
// //                    && newWC.isBAPI__c == true)
// //                {
// //                    newWC.isBAPI__c = false;
// //
// //                    THOR_Work_Clearance_Historical__c wch = new THOR_Work_Clearance_Historical__c();
// //                    System.debug('Work Clearance Historical => ' + oldWC.Work_Clearance_Historical__c);
// //                    wch.Id = oldWC.Work_Clearance_Historical__c;
// //                    wch.Name = newWC.Work_Clearance__c;
// //                    if (String.isNotBlank(newWC.Extend_No__c)) {
// //                        wch.Name = String.format('{0}/{1}', new List<String>{ newWC.Work_Clearance__c, newWC.Extend_No__c });
// //                    }
// //                    wch.Description__c = newWC.Description__c;
// //                    updateWCHistoricals.put(newWC.Id, wch);
// //                }
// //            }
// //            update updateWCHistoricals.values();
// //        }
// //
// //        for (Work_Clearance__c newWC : newWCs) {
// //            newWC.Last_User_Action_Status__c = 'Completed';
// //        }
// //    }
//     public static void createOrUpdateWorkClearanceHistorical( List<Work_Clearance__c> newWCs, List<Work_Clearance__c> oldWCs ) {
//         updateLookupFieldToTextField(newWCs, oldWCs != null ? new Map<Id, Work_Clearance__c>(oldWCs) : new Map<Id, Work_Clearance__c>());
//         if (newWCs != null && newWCs.size() > 0) {
//             Map<Id, THOR_Work_Clearance_Historical__c> createWCHistoricals = new Map<Id, THOR_Work_Clearance_Historical__c>();
//             for (Work_Clearance__c newWC : newWCs) {
//                 if (!String.isEmpty(newWC.Name)) {
//                     newWC.Work_Clearance__c = newWC.Name;
//                     THOR_Work_Clearance_Historical__c wch = makeWorkClearanceHistory(newWC);
//                     wch.External_Key__c = (String.isEmpty(newWC.Extend_No__c))?newWC.Name:newWC.Name + '/' + newWC.Extend_No__c;
//                     createWCHistoricals.put(newWC.Id, wch);
//                 }
//             }
//             upsert createWCHistoricals.values() External_Key__c;
//             for (Work_Clearance__c wc : newWCs) {
//                 if (createWCHistoricals.containsKey(wc.Id)) wc.Work_Clearance_Historical__c = createWCHistoricals.get(wc.Id).Id;
//             }
//         }
//         for (Work_Clearance__c newWC : newWCs) {
//             newWC.Last_User_Action_Status__c = 'Completed';
//         }
//     }
// }