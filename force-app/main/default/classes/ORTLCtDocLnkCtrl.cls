/**
 * ORTL ContentDocumentLink Controller used to perform upload/delete file
 * attachments of action records. When upload files attach to action records,
 * files will display in risks. In the other hands, if delete files
 * in risk, files will be deleted if files related to action records.
 */
public class ORTLCtDocLnkCtrl {

    // contentDocumentLinks for storing ContentDocumentLink records when upload/delete files event occur.
    private List<ContentDocumentLink> contentDocumentLinks;


    // ortlActions for storing action records form ContentDocumentLink records.
    private List<ORTLAction__c> ortlActions;

    /**
     * Initialize two instance property to perform upload/delete attachments.
     */
    public ORTLCtDocLnkCtrl(List<ContentDocumentLink> newItems) {
        this.contentDocumentLinks = newItems;
        this.ortlActions = getOrtlActions();
    }

    /**
     * Static method to handle action attachments delete event will be called by trigger handler class.
     */
    public static void handleContentDocumentLinkDeleted(Map<Id, SObject> oldItems) {
        ORTLCtDocLnkCtrl ortlConDoc = new ORTLCtDocLnkCtrl((List<ContentDocumentLink>) oldItems.values());
        List<ContentDocumentLink> delOrtlActionDocLinks = ortlConDoc.getOrtlActionContentDocumentLink();
        if (delOrtlActionDocLinks.size() > 0) {
            delete delOrtlActionDocLinks;
        }
        // List<ContentDocumentLink> delOrtlRiskDocLinks = ortlConDoc.getOrtlActionContentDocumentLink();
        // if (delOrtlRiskDocLinks.size() > 0) {
        //     delete delOrtlRiskDocLinks;
        // }
    }

    /**
     * Static method to handle action attachments upload event will be called by trigger handler class.
     */
    public static void handleUploadContentDocumentLink(List<SObject> newItems) {
        ORTLCtDocLnkCtrl ortlConDoc = new ORTLCtDocLnkCtrl((List<ContentDocumentLink>) newItems);
        List<ContentDocumentLink> copyDocLinks = ortlConDoc.copyOrtlActionContentDocumentLink();
        if (copyDocLinks.size() > 0) {
            ContentDocumentLinkTriggerHandler.TriggerDisabled = true;
            insert copyDocLinks;
        }
    }

    /**
     * Copy the action attachments to the risk attachments,
     * find only action ContentDocumentLink records and create
     * ContentDocumentLink for risks which related to the actions.
     */
    public List<ContentDocumentLink> copyOrtlActionContentDocumentLink() {
        Map<Id, ORTLAction__c> mOrtlActions = new Map<Id, ORTLAction__c>(this.ortlActions);

        List<ContentDocumentLink> copyDocLinks = new List<ContentDocumentLink>();
        for (ContentDocumentLink docLink : this.contentDocumentLinks) {
            String recIdPrefix = String.valueOf(docLink.LinkedEntityId).substring(0,3);
            String prefixOrtlAction = Schema.SObjectType.ORTLAction__c.getKeyPrefix();

            if (recIdPrefix == null || recIdPrefix != prefixOrtlAction) {
                continue;
            }

            if (mOrtlActions.containsKey(docLink.LinkedEntityId)) {
                ContentDocumentLink copyDocLink = new ContentDocumentLink();
                copyDocLink.LinkedEntityId = mOrtlActions.get(docLink.LinkedEntityId).Risk__c;
                copyDocLink.ContentDocumentId = docLink.ContentDocumentId;
                copyDocLinks.add(copyDocLink);
            }
        }

        return copyDocLinks;
    }

    /**
     * When delete action attachments event occur, this method filter
     * only action records and find all risk attachments related
     * to the actions. Then return risk attachments to perform deletion.
     */
    public List<ContentDocumentLink> getOrtlActionContentDocumentLink() {
        List<String> ortlRiskIds = new List<String>();
        List<String> ortlActionIds = new List<String>();

        List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();
        for (ContentDocumentLink docLink : this.contentDocumentLinks) {
            String recIdPrefix = String.valueOf(docLink.LinkedEntityId).substring(0,3);
            String prefixOrtlAction = Schema.SObjectType.ORTLAction__c.getKeyPrefix();

            if (recIdPrefix == null || recIdPrefix != prefixOrtlAction) {
                continue;
            }

            ortlActionIds.add(docLink.LinkedEntityId);
        }

        for (ORTLAction__c ortlAction : [SELECT Id, Risk__c FROM ORTLAction__c WHERE Id IN :ortlActionIds]) {
            ortlRiskIds.add(ortlAction.Risk__c);
        }

        return (ortlRiskIds.size() > 0) ? [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId IN :ortlRiskIds] : new List<ContentDocumentLink>();
    }

    /**
     * Find action records from ContentDocumentLink trigger.
     */
    private List<ORTLAction__c> getOrtlActions() {
        List<String> ortlActionIds = new List<String>();

        for (ContentDocumentLink docLink : this.contentDocumentLinks) {
            String recIdPrefix = String.valueOf(docLink.LinkedEntityId).substring(0,3);
            String prefixOrtlAction = Schema.SObjectType.ORTLAction__c.getKeyPrefix();

            if (recIdPrefix != null && recIdPrefix == prefixOrtlAction) {
                ortlActionIds.add(String.valueOf(docLink.LinkedEntityId));
            }
        }

        return [SELECT Id, Risk__c FROM ORTLAction__c WHERE Id IN :ortlActionIds];
    }
}