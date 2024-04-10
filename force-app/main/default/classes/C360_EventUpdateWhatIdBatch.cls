global without sharing class C360_EventUpdateWhatIdBatch implements Database.Batchable<sObject>,Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,WhoId,WhatId From Event WHERE IsChild = false and WhoId != Null AND WhatId = Null and StartDateTime >= TODAY and IsRecurrence2  = False ');
    }
    global void execute(Database.BatchableContext bc, List<Event> scope){
        List<string> contactId = new List<string>();
        Map<String,Event> mapEventIdWithEvent = new Map<String,Event>();
        for(Event thisEvent : scope){
            contactId.add(thisEvent.WhoId);
            mapEventIdWithEvent.put(thisEvent.id ,thisEvent);
        }
        Map<String,String> mapAccContact = new Map<String, String>(); 
        for(Contact thisContact : [Select id,AccountId From Contact	where id in:contactId]){
            mapAccContact.put(thisContact.id ,thisContact.AccountId);
        }
        list<Event> updateThis = new list<Event>();
        for(Event thisEvent : scope){
            event UpdatethisEvent = new event();
            UpdatethisEvent = mapEventIdWithEvent.get(thisEvent.id);
            UpdatethisEvent.WhatId = mapAccContact.get(thisEvent.WhoId);
            updateThis.add(UpdatethisEvent);
        }
        update updateThis;
    }
    global void finish(Database.BatchableContext bc){}
}