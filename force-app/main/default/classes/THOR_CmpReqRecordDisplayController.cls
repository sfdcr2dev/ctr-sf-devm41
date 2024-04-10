/**
 * @author Sebastian Bucalo
 * @description controller for THOR_ComponentRequestRecordDisplay component
 */
public with sharing class THOR_CmpReqRecordDisplayController {
    /**
     * @description retrieves component request filtered by id
     * @param status
     * @return List<THOR_ObjectCardDTO>
     */
    @AuraEnabled
    public static Spare_Part_Request__c retrieveComponentRequest(Id componentRequestId) {
        try {
            return [
                SELECT
                    Id,
                    Spare_Part_Stock__r.Spare_Part__r.Material_Number__c,
                	Spare_Part__r.Material_Number__c,
                    Order__r.Order_Number__c,
                    Spare_Part_Stock__r.Spare_Part__r.Material_Description__c,
                	Spare_Part__r.Material_Description__c,
                    Order_Operation__r.Operation_Text__c,
                    Order_Operation__r.Operation_Shot_Text__c,
                    Request_Material_Quantity__c,
                    Spare_Part_Stock__r.Available_Quantity__c,
                    IC__c,
                    Spare_Part_Stock__r.Spare_Part__r.Base_Unit__c,
                    Spare_Part__r.Base_Unit__c,
                    Request_Status__c,
                    Plant__r.Code__c
                FROM Spare_Part_Request__c
                WHERE Id = :componentRequestId
            ][0];
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }
}