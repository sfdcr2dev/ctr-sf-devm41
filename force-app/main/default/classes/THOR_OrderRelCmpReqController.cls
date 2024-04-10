/**
 * @author Sebastian Bucalo
 * @description Controller class for THOR_OrderRelatedComponentRequest aura component
 */
public with sharing class THOR_OrderRelCmpReqController {
    /**
     * @description retrieves the order component request for a specific order
     * @return Related components requests
     * @param orderId
     */
    @AuraEnabled
    public static List<THOR_ObjectCardDTO> retrieveComponentsRequests(Id orderId) {
        try {
            return THOR_DTOMapper.mapComponentsRequests(
                [
                    SELECT
                        Id,
                        Name,
                        Order__c,
                        Order__r.Order_Number__c,
                        Request_Material_Quantity__c,
                        Request_Status__c,
                        Spare_Part_Stock__r.Available_Quantity__c,
                        Spare_Part_Stock__r.Spare_Part__r.Material_Number__c,
                        Spare_Part_Stock__r.Spare_Part__r.Material_Description__c,
                        Spare_Part_Stock__r.Spare_Part__r.Base_Unit__c,
                    	Spare_Part__r.Material_Number__c,
                    	Spare_Part__r.Material_Description__c
                    FROM Spare_Part_Request__c
                    WHERE
                        Order__c = :orderId
                        AND Deleted__c = FALSE
                        AND Request_Status__c IN ('Pending for Approval', 'Approved', 'Rejected')
                    WITH SECURITY_ENFORCED
                ]
            );
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }
    /**
     * @description retrieves the cart count for a specific order
     * @return Related components cart count
     * @param orderId
     */
    @AuraEnabled
    public static Integer getCartCount(String orderId) {
        try {
            return [
                SELECT COUNT()
                FROM Spare_Part_Request__c
                WHERE Order__c = :orderId AND Request_Status__c = 'Draft' AND Deleted__c = FALSE
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}