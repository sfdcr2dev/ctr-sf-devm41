/**
 * @author Oktana
 * @description trigger for ContentDocumentLink
 */
trigger ContentDocumentLinkTrigger on ContentDocumentLink(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new ContentDocumentLinkTriggerHandler());
}