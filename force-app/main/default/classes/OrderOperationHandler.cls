/**
 * @author Oktana
 */
public with sharing class OrderOperationHandler {
    /**
     * @description creates Autogenerated EQCC from Order Operations
     * @param orderOperations
     */
    public static void handleAutogenerateEQCC(Map<Id, sObject> orderOperations) {
//        Map<EQCC_Header__c, List<EQCC_Checked_Sheet__c>> checkedSheetsByHeader = new Map<EQCC_Header__c, List<EQCC_Checked_Sheet__c>>();
//        List<Order_Operation__c> fullOrderOperations = getFullOrderOperations(orderOperations.values());
//
//        for (Order_Operation__c orderOperation : fullOrderOperations) {
//            if (
//                (orderOperation.Order__r.Order_Type__c == Constants.ORDERS.TYPE_SH ||
//                orderOperation.Order__r.Order_Type__c == Constants.ORDERS.TYPE_PM) &&
//                orderOperation.SubOperation__c == null
//            ) {
//                checkedSheetsByHeader.put(
//                    getHeaderFromOrderOperation(orderOperation),
//                    getCheckedSheetsFromOrderOperation(orderOperation.Id)
//                );
//            }
//        }
//
//        createHeaderSheets(checkedSheetsByHeader);
    }

    /**
     * @description populates external Id OrderOperation__c before the order is created
     * @param orderOperations
     */
    public static void populateExternalId(List<Order_Operation__c> orderOperations) {
        Map<Id, Order__c> ordersMap = getOrdersRelatedMap(orderOperations);

        for (Order_Operation__c orderOperation : orderOperations) {
            String subOperation;
            Id orderRelatedId = orderOperation.Order__c;
            if (orderOperation.subOperation__c == null) {
                subOperation = '';
            } else {
                subOperation = orderOperation.subOperation__c;
            }

            orderOperation.OrderOperation__c =
                ordersMap.get(orderRelatedId).Name +
                orderOperation.Operation_Text__c +
                subOperation;
        }
    }

//    private static void createHeaderSheets(Map<EQCC_Header__c, List<EQCC_Checked_Sheet__c>> checkedSheetsByHeader) {
//        try {
//            if (Schema.SObjectType.EQCC_Header__c.isCreateable()) {
//                insert new List<EQCC_Header__c>(checkedSheetsByHeader.keySet());
//
//                //needed since checkedSheetsByHeader keys are updated with header Ids after inserting
//                Map<EQCC_Header__c, List<EQCC_Checked_Sheet__c>> updatedMap = checkedSheetsByHeader.clone();
//
//                List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>();
//                List<EQCC_Header__c> headersToDelete = new List<EQCC_Header__c>();
//                //TES-463 Checked Sheets should only be autogenerated once
//                Set<String> sheetCodes = new Set<String>();
//                Boolean hasCheckedSheets = false;
//                for (EQCC_Header__c header : updatedMap.keySet()) {
//                    List<EQCC_Checked_Sheet__c> sheets = updatedMap.get(header);
//                    for (EQCC_Checked_Sheet__c sheet : sheets) {
//                        if (!sheetCodes.contains(sheet.Sheet_Code__c)) {
//                            headerSheets.add(new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheet.Id));
//                            hasCheckedSheets = true;
//                            sheetCodes.add(sheet.Sheet_Code__c);
//                        }
//                    }
//                    if (!hasCheckedSheets) {
//                        headersToDelete.add(header);
//                    }
//                    hasCheckedSheets = false;
//                }
//                
//				System.debug('START>>>>'+Schema.SObjectType.EQCC_Checked_Sheet__c.isCreateable());
//                if (Schema.SObjectType.EQCC_Checked_Sheet__c.isCreateable()) {
//                    insert headerSheets;
//                    List<EQCC_Header__c> updateEqccHeaders = new List<EQCC_Header__c>();
//                    Set<EQCC_Header__c> eqccHeaders = updatedMap.keySet();
//                    Map<Id, List<Header_Sheet__c>> eqccHeaderMap = new Map<Id, List<Header_Sheet__c>>();
//                    Set<Id> eqccHeaderIdSet = new Set<Id>();
//                    for (EQCC_Header__c eqccHeader : eqccHeaders){
//                        eqccHeaderIdSet.add(eqccHeader.Id);
//                    }
//
//                    for(EQCC_Header__c eqccHeader : [SELECT Id, (SELECT Id, Sheet__r.Form_Name__c FROM Header_Sheets__r) FROM EQCC_Header__c WHERE Id IN: eqccHeaderIdSet]) {
//                        eqccHeaderMap.put(eqccHeader.Id, eqccHeader.Header_Sheets__r);
//                    }
//
//                    for(EQCC_Header__c eqccHeader : eqccHeaders) {
//                        if(eqccHeaderMap.containsKey(eqccHeader.Id)) {
//                            List<Header_Sheet__c> headerSheetMaps = eqccHeaderMap.get(eqccHeader.Id);
//                            String str = '';
//                            for(Header_Sheet__c headerSheet : headerSheetMaps) {
//                                str += headerSheet.Sheet__r.Form_Name__c + ',';
//                            }
//                            eqccHeader.Form_Name_Text__c = str;
//                            updateEqccHeaders.add(eqccHeader);
//                        }
//                    }
//                    update updateEqccHeaders;
//                }
//                if (Schema.SObjectType.EQCC_Header__c.isDeletable()) {
//                    delete headersToDelete;
//                }
//            }
//        } catch (Exception ex) {
//            // TODO handle exception
//            System.debug('catch>>>>'+ex.getMessage());
//        }
//    }

//    private static EQCC_Header__c getHeaderFromOrderOperation(Order_Operation__c orderOperation) {
//        return new EQCC_Header__c(
//            Order__c = orderOperation.Order__c,
//            Equipment__c = orderOperation.Order__r.Equipment__c,
//            FunctionalLocation__c = orderOperation.Order__r.Functional_Location__c,
//            Order_Operation__c = orderOperation.Id
//        );
//    }

//    private static List<EQCC_Checked_Sheet__c> getCheckedSheetsFromOrderOperation(Id orderOperationId) {
//        return THOR_CheckedSheetController.retrieveCheckedSheetsFromOrderOperation(orderOperationId, false);
//    }

//    private static List<Order_Operation__c> getFullOrderOperations(List<Order_Operation__c> orderOperations) {
//        Set<Id> orderOperationIds = new Set<Id>();
//        for (Order_Operation__c orderOperation : orderOperations) {
//            orderOperationIds.add(orderOperation.Id);
//        }
//
//        return [
//            SELECT
//                Id,
//                Order__r.Order_Type__c,
//                SubOperation__c,
//                Control_Key__c,
//                Main_Work_Center__c,
//                Operation_Shot_Text__c,
//                Operation_Text__c,
//                Order__r.Notification__c,
//                Order__c,
//                Name,
//                OrderOperation__c,
//                Plant__c,
//                Order__r.Equipment__c,
//                Order__r.Functional_Location__c
//            FROM Order_Operation__c
//            WHERE Id IN :orderOperationIds
//        ];
//    }

    private static Map<Id, Order__c> getOrdersRelatedMap(List<Order_Operation__c> orderOperations) {
        Map<Id, Order__c> orderMap = new Map<Id, Order__c>();

        Set<Id> orderIds = new Set<Id>();
        for (Order_Operation__c orderOperation : orderOperations) {
            orderIds.add(orderOperation.Order__c);
        }

        List<Order__c> orders = [SELECT Id, Name FROM Order__c WHERE Id IN :orderIds WITH SECURITY_ENFORCED];

        for (Order__c order : orders) {
            orderMap.put(order.Id, order);
        }

        return orderMap;
    }
}