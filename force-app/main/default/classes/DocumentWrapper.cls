/**
 * @author Oktana Team
 * @description Wrapper class to add as many fields as needed to Attachments
 */
public class DocumentWrapper {
    @AuraEnabled public String sequentialNumber { get; set; }
    @AuraEnabled public ContentDocumentLink document { get; set; }
    
    public DocumentWrapper(String sequentialNumber, ContentDocumentLink document) {
        this.sequentialNumber = sequentialNumber;
        this.document = document;
    }
}