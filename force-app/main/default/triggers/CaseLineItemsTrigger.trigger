trigger CaseLineItemsTrigger on OPP_Case_Line_Items__c(
  before insert,
  before update,
  before delete,
  after insert,
  after update,
  after delete,
  after undelete
) {
  TriggerDispatcher.run(new CaseLineItemsHandler());
}