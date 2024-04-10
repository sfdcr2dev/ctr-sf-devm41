trigger CTRRequestHeaderTrigger on CTRRequestFormHeader__c (before insert, before update, before delete, after insert, after update, after delete) 
{
    TriggerDispatcher.run(new CTRRequestHeaderTriggerHandler());
}