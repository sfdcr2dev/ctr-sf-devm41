@isTest
public with sharing class THOR_DTOMapper_Test 
{
    @isTest
    public static void givenNotificationWhenCalledMapNotificationsExpectedTHORObjectCardDTOArray()
    {
        Notification__c n = new Notification__c(Notification_Status__c = 'New', Type__c = 'PM');
        Order__c o = new Order__c(Name = 'New');
        Order_Operation__c oo = new Order_Operation__c();
        Item__c item = new Item__c();
        Activity__c activity = new Activity__c();
        Cause__c cause = new Cause__c();
        Spare_Part_Request__c sp = new Spare_Part_Request__c(Name = 'New');
        EQCC_Step__c es = new EQCC_Step__c();
        ProcessInstanceStep ps = new ProcessInstanceStep();
        Map<Id, EQCC_Step__c> eqccStepsMap = new Map<Id, EQCC_Step__c>();
        eqccStepsMap.put(es.Id, es);
        Map<Id, DateTime> submittedDatesMap = new Map<Id, DateTime>();
        Datetime myDateTime = Datetime.newInstance(1960, 2, 17);
        submittedDatesMap.put(es.Id, myDateTime);
        THOR_ObjectCardDTO[] dtos = THOR_DTOMapper.mapNotifications(new Notification__c[]{n});
        THOR_ObjectCardDTO[] dtosFL = THOR_DTOMapper.mapFunctionalLocationNotifications(new Notification__c[]{n});
        THOR_ObjectCardDTO[] dtosOrder = THOR_DTOMapper.mapOrders(new Order__c[]{o});
        THOR_ObjectCardDTO[] dtosOrderOperation = THOR_DTOMapper.mapOperations(new Order_Operation__c[]{oo});
        THOR_ObjectCardDTO[] dtosItem = THOR_DTOMapper.mapItems(new Item__c[]{item});
        THOR_ObjectCardDTO[] dtosActivity = THOR_DTOMapper.mapActivities(new Activity__c[]{activity});
        THOR_ObjectCardDTO[] dtosCause = THOR_DTOMapper.mapCauses(new Cause__c[]{cause});
        THOR_ObjectCardDTO[] dtosSP = THOR_DTOMapper.mapComponentsRequests(new Spare_Part_Request__c[]{sp});
        THOR_ObjectCardDTO[] dtosPS = THOR_DTOMapper.mapProcessInstanceStep(new ProcessInstanceStep[]{ps}, new EQCC_Step__c());
        THOR_ObjectCardDTO[] dtosPApprove = THOR_DTOMapper.mapProcessInstanceStepsForApprove(new Map<Id, EQCC_Step__c>(eqccStepsMap), new Map<Id, DateTime>(submittedDatesMap));

        System.assert(dtos.size() > 0, 'Mapper did not returned elements');
        System.assertEquals(n.Notification_Status__c, dtos[0].status, 'Status does n, ot match');
        System.assertEquals('PM', dtos[0].dropableBody[0].value, 'Does not match');
    }
}