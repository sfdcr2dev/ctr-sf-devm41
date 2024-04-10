/**
 * @author Oktana
 * @description trigger for ContentDocument
 */
trigger ContentDocumentTrigger on ContentDocument(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new ContentDocumentTriggerHandler());
    
    if (Trigger.isAfter) {

        List<ContentDocument> contentdocIds = new List<ContentDocument>();

            for (ContentDocument content : Trigger.isInsert ? Trigger.new : Trigger.old) {
                contentdocIds.add(content);
            }

            System.debug('contentdocIds----: ' + contentdocIds);

            if (!contentdocIds.isEmpty()) {
                if (Trigger.isInsert) {
                    // CTRContentDocHandler.getTitleFile(contentdocIds);
                    System.debug('contentdocIds : '+contentdocIds);
                } 
            }
    }
}