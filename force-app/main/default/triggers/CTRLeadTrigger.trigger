trigger CTRLeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete) 
{
    TriggerDispatcher.run(new CTRLeadTriggerHandler());

}