/*
* CTRComplianceCheck.cmp
* CTRComplianceCheckResult.cmp
* CTRRejectRequestForm.cmp
*/
public with sharing class CTRComplianceCheckController {

    private static final String CLASSNAME = CTRComplianceCheckController.class.getName();

    @AuraEnabled
    public static List<Map<String, String>> getPicklistValue(String fieldAPI, String sObjAPI) {
        return CTRInitialCustomerTOP.getPicklistValue(fieldAPI, sObjAPI);
    }

    @AuraEnabled
    public static String createRelatedShiptoAndShareholder(String shiptoJSON, String shareholderJSON) {
        String result = 'success';
        try {
            System.debug(CLASSNAME + '.createRelatedShiptoAndShareholder shiptoJSON -----' + shiptoJSON);
            System.debug(CLASSNAME + '.createRelatedShiptoAndShareholder shareholderJSON -----' + shareholderJSON);
            if(!String.isBlank(shiptoJSON)) {
                List<CTRShippingCountry__c> shiptoList = (List<CTRShippingCountry__c>) JSON.deserialize(shiptoJSON, Type.forName('List<Schema.CTRShippingCountry__c>'));
                System.debug(CLASSNAME + '.createRelatedShiptoAndShareholder shiptoList -----' + shiptoList);
                if(shiptoList != null && !shiptoList.isEmpty()) {
                    insert shiptoList;
                }
            }

            if(!String.isBlank(shareholderJSON)) {
                List<CTRShareHolder__c> shareholderList = (List<CTRShareHolder__c>) JSON.deserialize(shareholderJSON, Type.forName('List<Schema.CTRShareHolder__c>'));
                System.debug(CLASSNAME + '.createRelatedShiptoAndShareholder shareholderList -----' + shareholderList);
                if(shareholderList != null && !shareholderList.isEmpty()) {
                    insert shareholderList;
                }
            }
        } catch (Exception ex) {
            result = 'failed';
            throw new AuraHandledException(ex.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static String rejectRequestForm(String recordId) {
        String result = 'success';
        try {
            CTRRequestFormItem__c record = new CTRRequestFormItem__c();
            record.Id = recordId;
            record.Status__c = 'Rejected';
            update record;
        } catch (Exception ex) {
            result = 'failed';
            throw new AuraHandledException(ex.getMessage());
        }
        return result;
    }
}