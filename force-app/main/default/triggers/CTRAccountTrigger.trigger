trigger CTRAccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete) 
{
    TriggerDispatcher.run(new CTRAccountTriggerHandler());

}