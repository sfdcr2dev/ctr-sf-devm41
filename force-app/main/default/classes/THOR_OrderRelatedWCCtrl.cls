public class THOR_OrderRelatedWCCtrl {

    @AuraEnabled
    public static Object getFunctionLocationDetail(Id funcLocationId) {
        return THOR_WorkClearanceController.getFunctionalLocationDetailById(funcLocationId);
    }

    @AuraEnabled
    public static List<THOR_WorkClearanceController.WorkClearanceWrapper> getRelatedWorkClearances(String orderIdentifier) {
        return THOR_WorkClearanceController.getRelatedWorkClearancesByOrder(orderIdentifier);
    }

    @AuraEnabled
    public static Object getWorkClearance(String workclearanceIdentifier) {
        return THOR_WorkClearanceController.getWorkClearanceById(workclearanceIdentifier);
    }

    @AuraEnabled
	public static Order__c getOrderDetailById(Id orderId) {
        return THOR_WorkClearanceController.getOrderDetailById(orderId);
    }

    @AuraEnabled
    public static Boolean hasWriteAccess(String recordId) {
        return THOR_WorkClearanceController.getUserRecordEditAccess(recordId);
    }

    @AuraEnabled
    public static List<sObject> getPISRequester(String searchText) {
        return THOR_WorkClearanceController.getPISRequester(searchText);
    }

    @AuraEnabled
    public static List<sObject> getApplicantOrBearer(String searchText) {
        return THOR_WorkClearanceController.getApplicantOrBearer(searchText);
    }

    @AuraEnabled
	public static List<sObject> getSafetyPermit(String searchText) {
		return THOR_WorkClearanceController.getSafetyPermit(searchText);
	}
    
    @AuraEnabled
    public static List<Master_Map__c> getAreas() {
        return THOR_WorkClearanceController.getAreas();
    }

}