/**
 * @author Sebastian Vera
 * @description Maps Objectos to DTOS
 */
public with sharing class THOR_DTOMapper {
    public static THOR_ObjectCardDTO[] mapNotifications(Notification__c[] notifications) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Notification__c n : notifications) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.status = n.Notification_Status__c;
            dto.isNew = true;
            dto.isDeletable = false;
            dto.title = n.Notification_Number__c;
            dto.titleLabel = 'Notification number';
            dto.recordId = n.Id;
            Map<String, String> dropableBody = getNotificationDropableBody(n);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapFunctionalLocationNotifications(Notification__c[] notifications) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Notification__c n : notifications) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.status = n.Notification_Status__c;
            dto.isNew = true;
            dto.isDeletable = false;
            dto.title = n.Notification_Number__c;
            dto.titleLabel = 'Notification number';
            dto.recordId = n.Id;
            dto.name = n.Functional_Location__r.Name;
            Map<String, String> dropableBody = getFunctionalLocationNotificationDropableBody(n);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapOrders(Order__c[] orders) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Order__c o : orders) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.status = o.Order_Status__c;
            dto.isNew = true;
            dto.isDeletable = false;
            dto.title = o.Order_Number__c;
            dto.titleLabel = 'Order Number';
            dto.recordId = o.Id;
            Map<String, String> dropableBody = getOrderDropableBody(o);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapOperations(Order_Operation__c[] orderOperations) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Order_Operation__c orderOperation : orderOperations) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.isDeletable = false;
            dto.title = orderOperation.Operation_Text__c;
            dto.titleLabel = 'Operation Number';
            dto.recordId = orderOperation.Id;
            Map<String, String> dropableBody = getOperationDropableBody(orderOperation);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapItems(Item__c[] items) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Item__c i : items) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.isNew = true;
            dto.isDeletable = false;
            dto.notification = i.Notification__c;
            dto.recordId = i.Id;
            Map<String, String> dropableBody = getItemDropableBody(i);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapActivities(Activity__c[] activities) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Activity__c a : activities) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.isNew = true;
            dto.isDeletable = false;
            dto.titleLabel = 'Activity Number';
            dto.recordId = a.Id;
            Map<String, String> dropableBody = getActivityDropableBody(a);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapCauses(Cause__c[] causes) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Cause__c c : causes) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.isNew = true;
            dto.isDeletable = false;
            dto.titleLabel = 'Cause Number';
            dto.recordId = c.Id;
            Map<String, String> dropableBody = getCauseDropableBody(c);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapComponentsRequests(Spare_Part_Request__c[] requests) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Spare_Part_Request__c r : requests) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.isNew = true;
            dto.isDeletable = false;
            dto.title = ''; //r.name;
            dto.titleLabel = '';
            dto.recordId = r.Id;
            Map<String, String> dropableBody = getSparePartRequestDropableBody(r);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapProcessInstanceStep( ProcessInstanceStep[] processInstanceSteps, EQCC_Step__c eqccStep ) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (ProcessInstanceStep p : processInstanceSteps) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.isNew = true;
            dto.isDeletable = false;
            dto.title = '';
            dto.titleLabel = '';
            dto.recordId = p.ProcessInstance.TargetObjectId;
            Map<String, String> dropableBody = getDropableBodyProcessInstanceStep(p, eqccStep);
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    public static THOR_ObjectCardDTO[] mapProcessInstanceStepsForApprove( Map<Id, EQCC_Step__c> eqccStepsMap, Map<Id, Datetime> submittedDatesMap ) {
        THOR_ObjectCardDTO[] dtos = new List<THOR_ObjectCardDTO>{};
        for (Id p : eqccStepsMap.KeySet()) {
            THOR_ObjectCardDTO dto = new THOR_ObjectCardDTO();
            dto.isNew = true;
            dto.isDeletable = false;
            dto.title = '';
            dto.titleLabel = '';
            dto.recordId = p;
            EQCC_Step__c eqccStep = eqccStepsMap.get(p);
            dto.formGroup = eqccStep.Header_Sheet__r.Sheet__r.Group__c;
            Datetime submittedDate = submittedDatesMap.get(p);
            Map<String, String> dropableBody = getDropableBodyProcessInstanceStepForApproval( p, eqccStepsMap.get(p), submittedDate );
            dto.setDropableBody(dropableBody);
            dtos.add(dto);
        }
        return dtos;
    }
    private static Map<String, String> getNotificationDropableBody(Notification__c n) {
        Map<String, String> dropableBody = new Map<String, String>();
        try {
            dropableBody.put('Notification type', n.Type__c);
            dropableBody.put('FL', n.Functional_Location__r.Name);
            dropableBody.put('Priority', n.Priority__c);
            DateTime dt = n.CreatedDate;
            Date d = date.newinstance(dt.year(), dt.month(), dt.day());
            String dateStr = d.format();
            dropableBody.put('Create on', dateStr);
            dropableBody.put('Description', n.Description__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }
    private static Map<String, String> getFunctionalLocationNotificationDropableBody(Notification__c n) {
        Map<String, String> dropableBody = new Map<String, String>();
        try {
            dropableBody.put('Notification type', n.Type__c);
            dropableBody.put('Priority', n.Priority__c);
            DateTime dt = n.CreatedDate;
            Date d = date.newinstance(dt.year(), dt.month(), dt.day());
            String dateStr = d.format();
            dropableBody.put('Create on', dateStr);
            dropableBody.put('Description', n.Description__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }
    private static Map<String, String> getOrderDropableBody(Order__c o) {
        Map<String, String> dropableBody = new Map<String, String>();

        try {
            dropableBody.put('Order Type', o.Order_Type__c);
            dropableBody.put('FL', o.Functional_location__r.Name);
            dropableBody.put('Priority', o.Priority__c);
            DateTime dt = o.CreatedDate;
            Date d = date.newinstance(dt.year(), dt.month(), dt.day());
            String dateStr = d.format();
            dropableBody.put('Create on', dateStr);
            dropableBody.put('Description', o.Description__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }
    private static Map<String, String> getOperationDropableBody(Order_Operation__c orderOperation) {
        Map<String, String> dropableBody = new Map<String, String>();

        try {
            dropableBody.put('Sub Operation', orderOperation.SubOperation__c);
            dropableBody.put('Main Work Center', orderOperation.Main_Work_Center__r.Name);
            dropableBody.put('Operation Short Text', orderOperation.Operation_Shot_Text__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }

    /**
     * @description used to solve the 'cognitive complexity of 15'
     * @return Map<String, String>
     * @param i
     */
    private static Map<String, String> getItemDropableBody(Item__c i) {
        Map<String, String> dropableBody = new Map<String, String>();
        try {
            dropableBody.put('Object Part Code group', i.Object_Part_Code_Group__r.Name);
            dropableBody.put('Object Part Code text', i.Object_Part_Code_Text__c);
            dropableBody.put('Integration Status', i.Integration_Status__c);
            String dateStr = i.CreatedDate.day() + '/' + i.CreatedDate.month() + '/' + i.CreatedDate.year();
            dropableBody.put('Items Create on', dateStr);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }

    /**
     * @description used to solve the 'cognitive complexity of 15'
     * @return Map<String, String>
     * @param a
     */
    private static Map<String, String> getActivityDropableBody(Activity__c a) {
        Map<String, String> dropableBody = new Map<String, String>();

        try {
            dropableBody.put('Code Group', a.Code_Group__r.Name);
            dropableBody.put('Code', a.Code_in_Text_Form__c);
            dropableBody.put('Code Text', a.Text_of_Code__c);
            dropableBody.put('Text', a.Text__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }

    /**
     * @description used to solve the 'cognitive complexity of 15'
     * @return Map<String, String>
     * @param c
     */
    private static Map<String, String> getCauseDropableBody(Cause__c c) {
        Map<String, String> dropableBody = new Map<String, String>();

        try {
            dropableBody.put('Code Group', c.Code_Group__r.Name);
            dropableBody.put('Code', c.Code_in_Text_Form__c);
            dropableBody.put('Code Text', c.Code_Text__c);
            dropableBody.put('Text', c.Text__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }
    private static Map<String, String> getSparePartRequestDropableBody(Spare_Part_Request__c r) {
        Map<String, String> dropableBody = new Map<String, String>();
        try {
            dropableBody.put('Material no.', r.Spare_Part__r.Material_Number__c);
            dropableBody.put('Order no.', r.Order__r.Order_Number__c);
            dropableBody.put('Material Description', r.Spare_Part__r.Material_Description__c);
            dropableBody.put('Request Material Qty (ReqMt Qty)', String.valueOf(r.Request_Material_Quantity__c));
            dropableBody.put('Available Qty', String.valueOf(r.Spare_Part_Stock__r.Available_Quantity__c));
            dropableBody.put('UM', r.Spare_Part_Stock__r.Spare_Part__r.Base_Unit__c);
            dropableBody.put('Status', r.Request_Status__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }
    public static Map<String, String> getDropableBodyProcessInstanceStep(ProcessInstanceStep p, EQCC_Step__c eqccStep) {
        Map<String, String> dropableBody = new Map<String, String>();
        try {
            dropableBody.put('Name', eqccStep.Form_Code__c);
            dropableBody.put('Title', eqccStep.Header_Sheet__r.Header__r.Name);
            dropableBody.put('Functional Location', eqccStep.Header_Sheet__r.Header__r.Functional_Location__c);
            dropableBody.put('Equipment', eqccStep.Header_Sheet__r.Header__r.Equipment__r.Name);
            dropableBody.put('Operation', eqccStep.Header_Sheet__r.Header__r.Operation__r.Name);
            dropableBody.put('Status', p.ProcessInstance.Status);
            dropableBody.put('Owner', eqccStep.Header_Sheet__r.Header__r.Owner.Name);
            dropableBody.put('Create on', eqccStep.Header_Sheet__r.Sheet__r.Createdby.Name);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        try {
            Datetime createdDT = eqccStep.Header_Sheet__r.Sheet__r.CreatedDate;
            String createdTime = createdDT.hour() < 10 ? '0' + String.valueOf(createdDT.hour()) : String.valueOf(createdDT.hour());
            createdTime += ':';
            createdTime += createdDT.minute() < 10 ? '0' + String.valueOf(createdDT.minute()) : String.valueOf(createdDT.minute());
            String dateStr = createdDT.day() + '/' + createdDT.month() + '/' + createdDT.year() + ' ' + createdTime;
            dropableBody.put('Create date', dateStr);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        try {
            Datetime modifiedDT = eqccStep.Header_Sheet__r.Sheet__r.LastModifiedDate;
            String modifiedTime = modifiedDT.hour() < 10 ? '0' + String.valueOf(modifiedDT.hour()) : String.valueOf(modifiedDT.hour());
            modifiedTime += ':';
            modifiedTime += modifiedDT.minute() < 10 ? '0' + String.valueOf(modifiedDT.minute()) : String.valueOf(modifiedDT.minute());
            String dateStr = modifiedDT.day() + '/' + modifiedDT.month() + '/' + modifiedDT.year() + ' ' + modifiedTime;
            dropableBody.put('Last modified date', dateStr);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }
    public static Map<String, String> getDropableBodyProcessInstanceStepForApproval( Id p, EQCC_Step__c eqccStep, Datetime submittedDate ) {
        Map<String, String> dropableBody = new Map<String, String>();
        try {
            dropableBody.put('Header Sheet Name', eqccStep.Header_Sheet__r.Name);
            dropableBody.put('Check Sheet Code', eqccStep.Form_Code__c);
            dropableBody.put('Notification Number', eqccStep.Header_Sheet__r.Header__r.Notification__r.Notification_Number__c);
            dropableBody.put('Order Number', eqccStep.Header_Sheet__r.Header__r.Order__r.Order_Number__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        try {
            String description;
            description = (eqccStep.Header_Sheet__r.Header__r.Notification__c != null)?eqccStep.Header_Sheet__r.Header__r.Notification__r.Description__c:eqccStep.Header_Sheet__r.Header__r.Order__r.Description__c;
            dropableBody.put('Description', description);
            dropableBody.put('Requester', eqccStep.Header_Sheet__r.Requester__c);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        try {
            Datetime createdDT = submittedDate;
            String createdTime = createdDT.hour() < 10 ? '0' + String.valueOf(createdDT.hour()) : String.valueOf(createdDT.hour());
            createdTime += ':';
            createdTime += createdDT.minute() < 10 ? '0' + String.valueOf(createdDT.minute()) : String.valueOf(createdDT.minute());
            String dateStr = createdDT.day() + '/' + createdDT.month() + '/' + createdDT.year() + ' ' + createdTime;
            dropableBody.put('Date submitted', dateStr);
        } catch (Exception e) { system.debug(LoggingLevel.WARN, e); }
        return dropableBody;
    }
}