/**
 * @author Oktana
 * @description controller for Checked Sheet related actions
 */
public with sharing class THOR_CheckedSheetController {
    /**
     * @description retrieves Checked Sheets based on selected Equipment or Functional Location
     * @param equipmentId
     * @param funcLocationId
     */
    @AuraEnabled
    public static List<EQCC_Checked_Sheet__c> retrieveCheckedSheets(Id equipmentId, Id funcLocationId) {
        if (equipmentId != null) return retrieveCheckedSheetsByEquipment(equipmentId);
        return retrieveCheckedSheetsByFunctionalLocation(funcLocationId);
    }
    @AuraEnabled
    public static List<EQCC_Checked_Sheet__c> retrieveCheckedSheetsFromOrderOperation(Id orderOperationId) {
        return retrieveCheckedSheetsFromOrderOperation(orderOperationId, true);
    }

    public static List<EQCC_Checked_Sheet__c> retrieveCheckedSheetsFromOrderOperation( Id orderOperationId, Boolean allObjectType ) {
        List<EQCC_Checked_Sheet__c> checkedSheetsByOrderOp = retrieveCheckedSheetsByOrderOperation( new Set<Id>{ orderOperationId }, allObjectType );
        return checkedSheetsByOrderOp;
    }
    @AuraEnabled
    public static Notification__c retrieveEQCCNotification(Id notificationId) {
        return getNotificationById(notificationId);
    }
    @AuraEnabled
    public static Order__c retrieveEQCCOrder(Id orderId) {
        return getOrderById(orderId);
    }
    @AuraEnabled
    public static List<Order_Operation__c> retrieveOrderOperations(Id orderId) {
        return getOrderOperationsByOrderId(orderId);
    }
    @AuraEnabled
    public static Order_Operation__c retrieveOrderOperation(Id orderOperationId) {
        return getOrderOperationById(orderOperationId);
    }
    @AuraEnabled
    public static List<Notification__c> retrieveNotifications(Id equipmentId, Id funcLocationId) {
        String query = 'SELECT Id, Name, Notification_Number__c FROM Notification__c WHERE';
        query += (equipmentId != null && funcLocationId != null)? ' Functional_Location__c = \'' + funcLocationId + '\'' + ' AND Equipment__c = \'' + equipmentId + '\'' :(funcLocationId != null)?' Functional_Location__c = \'' + funcLocationId + '\'' :' Equipment__c = \'' + equipmentId + '\'';
        return Database.query(query);
    }
    @AuraEnabled
    public static List<Order__c> retrieveOrders(Id equipmentId, Id funcLocationId) {
        String query = 'SELECT Id, Name, Order_Number__c FROM Order__c WHERE';
        query += (equipmentId != null && funcLocationId != null)?' Functional_Location__c = \'' + funcLocationId + '\'' + ' AND Equipment__c = \'' + equipmentId + '\'':(funcLocationId != null)?' Functional_Location__c = \'' + funcLocationId + '\'':' Equipment__c = \'' + equipmentId + '\'';
        
        return Database.query(query);
    }
    @AuraEnabled
    public static Equipment__c retrieveFunctionalLocationFromEquipment(Id equipmentId) {
        return [SELECT Id, FL__c FROM Equipment__c WHERE Id = :equipmentId WITH SECURITY_ENFORCED LIMIT 1];
    }
    @AuraEnabled
    public static Boolean isOwnerOrAdmin(String headerId) {
        List<EQCC_Header__c> isOwner = [ SELECT Id, OwnerId FROM EQCC_Header__c WHERE Id = :headerId AND OwnerId = :UserInfo.getUserId() ];
        List<Profile> isAdmin = [ SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name = 'System Administrator' ];
        return !isOwner.isEmpty() || !isAdmin.isEmpty();
    }
    @AuraEnabled
    public static List<Equipment__c> retrieveEquipmentsFromFunctionalLocation(Id funcLocationId) {
        Functional_Location__c funcLocation = getFunctionalLocationById(funcLocationId);
        List<Equipment__c> equipments = [SELECT Id, Name, FL__c FROM Equipment__c WHERE FL__c = :funcLocationId];
        List<Equipment__c> sortEquipments = new List<Equipment__c>();
        for (Equipment__c equipment : equipments) {
            if (equipment.Id == funcLocation.First_Related_Equipment__c) {
                sortEquipments.add(equipment);
                break;
            }
        }
        for (Equipment__c equipment : equipments) {
            if (equipment.Id != funcLocation.First_Related_Equipment__c) sortEquipments.add(equipment);
        }
        return sortEquipments;
    }
    @AuraEnabled
    public static Id updateEQCCHeader(List<String> sheetIds, String headerId, Map<String, Object> sheetHeader, List<String> duplicatedCheckedSheets) {
        try {
            if (!willPopulateMWC(sheetHeader)) return null;
            EQCC_Header__c headerRecord = [ SELECT Id, FunctionalLocation__c, FunctionalLocation__r.MainWorkCenter__c FROM EQCC_Header__c WHERE Id = :headerId WITH SECURITY_ENFORCED LIMIT 1 ];
            associateCheckedSheetsToHeader(headerRecord, sheetIds);
            duplicateCheckedSheetsForHeader(headerRecord, duplicatedCheckedSheets);
            return headerId;
        } catch (Exception e) { throw new AuraHandledException('Error Exception happend' + e.getMessage()); }
    }

    @AuraEnabled
    public static Boolean hasMainWorkCenter(Id funcLocation) {
        Functional_Location__c fLocation = getFunctionalLocationById(funcLocation);
        return fLocation.MainWorkCenter__c != null;
    }
    private static List<EQCC_Checked_Sheet__c> retrieveCheckedSheetsByEquipment(Id equipmentId) {
        Equipment__c equipment = getEquipmentById(equipmentId);
        List<Sheet_Mapping__c> sheetMappings = getSheetMappingByObjectType(equipment.Object_Type__c);
        Set<String> sheetCodes = getSheetCodesFromSheetMappings(sheetMappings);
        return getCheckedSheetsBySheetCodes(sheetCodes);
    }
    private static List<EQCC_Checked_Sheet__c> retrieveCheckedSheetsByFunctionalLocation(Id funcLocationId) {
        Functional_Location__c funcLocation = getFunctionalLocationById(funcLocationId);
        List<Sheet_Mapping__c> sheetMappings = getSheetMappingByObjectType(funcLocation.Object_Type__c);
        Set<String> sheetCodes = getSheetCodesFromSheetMappings(sheetMappings);
        return getCheckedSheetsBySheetCodes(sheetCodes);
    }
    @AuraEnabled
    public static Id createEQCCHeaderWithSheets( Map<String, Object> sheetHeader, List<String> sheetIds, String orderOperationId ) {
        // can't create an EQCC Header without Main Work Center
        if (!willPopulateMWC(sheetHeader)) return null;

        EQCC_Header__c header = new EQCC_Header__c( Equipment__c = (String.isNotEmpty((String) sheetHeader.get('Equipment__c'))) ? (Id) sheetHeader.get('Equipment__c') : null, Order__c = (String.isNotEmpty((String) sheetHeader.get('Order__c'))) ? (Id) sheetHeader.get('Order__c') : null, FunctionalLocation__c = (String.isNotEmpty((String) sheetHeader.get('FunctionalLocation__c'))) ? (Id) sheetHeader.get('FunctionalLocation__c') : null, Notification__c = (String.isNotEmpty((String) sheetHeader.get('Notification__c'))) ? (Id) sheetHeader.get('Notification__c') : null, Order_Operation__c = (String.isNotEmpty(orderOperationId)) ? orderOperationId : null, Form_Name_Text__c = (String) sheetHeader.get('Form_Name_Text__c') );
        if (Schema.sObjectType.EQCC_Header__c.isCreateable()) {
            insert header;
            associateCheckedSheetsToHeader(header, sheetIds);
            return header.Id;
        }
        return null;
    }
    private static Boolean willPopulateMWC(Map<String, Object> sheetHeader) {
        if (sheetHeader == null) return true;
        if ((String.isNotEmpty((String) sheetHeader.get('Order__c')))) {
            Id orderId = (Id) sheetHeader.get('Order__c');
            Order__c order = getOrderById(orderId);
            if (order.Main_Work_Center__c != null) return true;
        }
        if ((String.isNotEmpty((String) sheetHeader.get('Notification__c')))) {
            Id notificationId = (Id) sheetHeader.get('Notification__c');
            Notification__c notification = getNotificationById(notificationId);
            if (notification.Main_Work_Center__c != null) return true;
        }
        if ((String.isNotEmpty((String) sheetHeader.get('Equipment__c')))) {
            Id equipmentId = (Id) sheetHeader.get('Equipment__c');
            Equipment__c equipment = getEquipmentById(equipmentId);
            if (equipment.MainWorkCenter__c != null) return true;
        }
        if ((String.isNotEmpty((String) sheetHeader.get('FunctionalLocation__c')))) {
            Id fLocationId = (Id) sheetHeader.get('FunctionalLocation__c');
            Functional_Location__c fLocation = getFunctionalLocationById(fLocationId);
            if (fLocation.MainWorkCenter__c != null) return true;
        }
        return false;
    }

    private static void associateCheckedSheetsToHeader(EQCC_Header__c header, List<String> sheetIds) {
        Set<Id> headerSheets = getSheetsByHeader(header.Id);
        List<EQCC_Checked_Sheet__c> sheets = getNewCheckedSheetsForHeader(sheetIds, headerSheets);
        List<Header_Sheet__c> newHeaderSheets = new List<Header_Sheet__c>();

        for (EQCC_Checked_Sheet__c sheet : sheets) {
            newHeaderSheets.add( new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheet.Id, isManuallyCreated__c = true) );
        }
        if (Schema.sObjectType.Header_Sheet__c.isCreateable()) insert newHeaderSheets;
        handleMarkingHeaderSheetsAsDeleted(header.Id, headerSheets, sheetIds);
        handleMarkingStepsAsDeleted(header.Id, headerSheets, sheetIds);
    }
    
    private static void duplicateCheckedSheetsForHeader(EQCC_Header__c header, List<String> sheetIds) {
        List<Header_Sheet__c> newHeaderSheets = new List<Header_Sheet__c>();
        for (String sheetId : sheetIds) {
            newHeaderSheets.add( new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheetId, isManuallyCreated__c = true) );
        }
        if (Schema.sObjectType.Header_Sheet__c.isCreateable()) insert newHeaderSheets;
    }
    private static List<EQCC_Checked_Sheet__c> getNewCheckedSheetsForHeader( List<String> sheetIds, Set<Id> headerSheets ) {
        return [ SELECT Id FROM EQCC_Checked_Sheet__c WHERE Id IN :sheetIds AND Id NOT IN :headerSheets WITH SECURITY_ENFORCED ];
    }
    private static Equipment__c getEquipmentById(Id equipmentId) {
        return [ SELECT Id, Object_Type__c, MainWorkCenter__c FROM Equipment__c WHERE Id = :equipmentId WITH SECURITY_ENFORCED ];
    }
    private static Functional_Location__c getFunctionalLocationById(Id funcLocationId) {
        return [ SELECT Id, Object_Type__c, MainWorkCenter__c, First_Related_Equipment__c FROM Functional_Location__c WHERE Id = :funcLocationId WITH SECURITY_ENFORCED ];
    }
    private static Notification__c getNotificationById(Id notificationId) {
        return [ SELECT Id, Functional_Location__c, Equipment__c, Main_Work_Center__c FROM Notification__c WHERE Id = :notificationId WITH SECURITY_ENFORCED ];
    }
    private static Order__c getOrderById(Id orderId) {
        return [ SELECT Id, Functional_Location__c, Equipment__c, grouptask__c, groupcount__c, Main_Work_Center__c FROM Order__c WHERE Id = :orderId WITH SECURITY_ENFORCED ];
    }
    private static List<Order_Operation__c> getOrderOperationsByOrderId(Id orderId) {
        List<Order_Operation__c> orderOperations = [ SELECT Id, Order__c, Operation_Text__c, Operation_Shot_Text__c FROM Order_Operation__c WHERE Order__c = :orderId WITH SECURITY_ENFORCED ];
        return orderOperations;
    }
    private static Order_Operation__c getOrderOperationById(Id orderOperationId) {
        return [ SELECT Id, Order__c, Operation_Text__c, Operation_Shot_Text__c FROM Order_Operation__c WHERE Id = :orderOperationId WITH SECURITY_ENFORCED LIMIT 1 ];
    }
    private static List<EQCC_Checked_Sheet__c> retrieveCheckedSheetsByOrderOperation( Set<Id> orderOperationIds, Boolean allObjectType ) {
        List<Order_Operation__c> orderOperations = [ SELECT Id, Order__c, Order__r.grouptask__c, Order__r.groupcount__c, Operation_Text__c, Operation_Shot_Text__c FROM Order_Operation__c WHERE Id IN :orderOperationIds WITH SECURITY_ENFORCED ];
        List<Sheet_Mapping__c> sheetMappings = getSheetMappings();
        Set<String> sheetCodes = new Set<String>();
        for (Order_Operation__c orderOperation : orderOperations) {
            for (Sheet_Mapping__c sheetMapping : sheetMappings) {
                if ( orderOperation.Operation_Text__c == sheetMapping.Operation_Text__c && orderOperation.Order__r.groupcount__c == sheetMapping.Group_Count__c && orderOperation.Order__r.grouptask__c == sheetMapping.Group_Task__c ) sheetCodes.add(sheetMapping.Form_Code__c);
            }
        }
        List<EQCC_Checked_Sheet__c> checkedSheets = getCheckedSheetsBySheetCodes(sheetCodes, allObjectType);
        return checkedSheets;
    }
    private static List<Sheet_Mapping__c> getSheetMappingByObjectType(String objectType) {
        return [ SELECT Id, Form_Code__c FROM Sheet_Mapping__c WHERE Object_Type__c = :objectType WITH SECURITY_ENFORCED ];
    }
    private static Set<String> getSheetCodesFromSheetMappings(List<Sheet_Mapping__c> sheetMappings) {
        Set<String> sheetCodes = new Set<String>();
        for (Sheet_Mapping__c sheetMapping : sheetMappings) {
            sheetCodes.add(sheetMapping.Form_Code__c);
        }
        return sheetCodes;
    }
    private static List<Sheet_Mapping__c> sheetMappingList;
    private static List<Sheet_Mapping__c> getSheetMappings() {
        if (sheetMappingList == null) sheetMappingList = [SELECT Id, Group_Task__c, Group_Count__c, Operation_Text__c, Form_Code__c FROM Sheet_Mapping__c];
        return sheetMappingList;
    }
    private static List<EQCC_Checked_Sheet__c> getCheckedSheetsBySheetCodes(Set<String> sheetCodes) {
        return getCheckedSheetsBySheetCodes(sheetCodes, true);
    }
    private static List<EQCC_Checked_Sheet__c> getCheckedSheetsBySheetCodes( Set<String> sheetCodes, Boolean allObjectType ) {
        Set<Id> groupId = new Set<Id>();
        Set<String> newSheetCodes = new Set<String>();
        User user = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        List<Group> groups = [Select Id, Name, DeveloperName From Group where RelatedId =: user.UserRoleId];
        for(Group g : groups) {
            groupId.add(g.Id);
        }
        List<GroupMember> groupMembers = [Select Id, Group.Name, Group.DeveloperName, Group.Type, UserOrGroupId From GroupMember WHERE Group.Name =: sheetCodes AND UserOrGroupId IN: groupId];
        for(GroupMember groupMember : groupMembers) {
            newSheetCodes.add(groupMember.Group.Name);
        }
        if (allObjectType) {
            return [ SELECT Id, Name, Form_Type__c, Form_Name__c, Group_Task__c, Group_Count__c, Operation__c, Sheet_Code__c FROM EQCC_Checked_Sheet__c WHERE Sheet_Code__c IN :newSheetCodes OR AllObjectType__c = TRUE WITH SECURITY_ENFORCED ];
        }
        return [ SELECT Id, Name, Form_Type__c, Form_Name__c, Group_Task__c, Group_Count__c, Operation__c, Sheet_Code__c FROM EQCC_Checked_Sheet__c WHERE Sheet_Code__c IN :sheetCodes WITH SECURITY_ENFORCED ];
    }
    private static Set<Id> getSheetsByHeader(Id headerId) {
        List<Header_Sheet__c> headerSheets = [ SELECT Id, Sheet__c FROM Header_Sheet__c WHERE Header__c = :headerId AND IsDeleted__c = FALSE ];
        Set<Id> sheetIds = new Set<Id>();
        for (Header_Sheet__c headerSheet : headerSheets) {
            sheetIds.add(headerSheet.Sheet__c);
        }
        return sheetIds;
    }
    private static void handleMarkingHeaderSheetsAsDeleted(Id headerId, Set<Id> headerSheets, List<String> sheetIds) {
        List<Header_Sheet__c> headerSheetsToDelete = [ SELECT Id FROM Header_Sheet__c WHERE Header__c = :headerId AND Sheet__c IN :headerSheets AND Sheet__c NOT IN :sheetIds AND isManuallyCreated__c = TRUE WITH SECURITY_ENFORCED ];
        markHeaderSheetsAsDeleted(headerSheetsToDelete);
    }
    private static void markHeaderSheetsAsDeleted(List<Header_Sheet__c> headerSheets) {
        for (Header_Sheet__c headerSheet : headerSheets) {
            headerSheet.IsDeleted__c = true;
        }
        if (Schema.SObjectType.Header_Sheet__c.isUpdateable()) update headerSheets;
    }
    private static void handleMarkingStepsAsDeleted(Id headerId, Set<Id> headerSheets, List<String> sheetIds) {
        Map<Id, Header_Sheet__c> headerSheetsById = new Map<Id, Header_Sheet__c>( [ SELECT Id FROM Header_Sheet__c WHERE Header__c = :headerId AND Sheet__c IN :headerSheets AND Sheet__c NOT IN :sheetIds AND isManuallyCreated__c = TRUE AND isDeleted__c = TRUE WITH SECURITY_ENFORCED ] );
        List<EQCC_Step__c> stepsToDelete = [ SELECT Id, IsDeleted__c FROM EQCC_Step__c WHERE Header_Sheet__c IN :headerSheetsById.keySet() ];
        markStepsAsDeleted(stepsToDelete);
    }
    private static void markStepsAsDeleted(List<EQCC_Step__c> steps) {
        for (EQCC_Step__c step : steps) {
            step.IsDeleted__c = true;
        }
        if (Schema.SObjectType.EQCC_Step__c.isUpdateable()) update steps;
    }
}