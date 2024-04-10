trigger ApplicationLog on Application_Log__c(before insert, before update, after insert, after update) {
	TriggerDispatcher.run(new ApplicationLogUtils());
}