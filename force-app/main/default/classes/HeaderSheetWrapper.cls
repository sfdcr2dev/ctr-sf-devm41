/**
 * @author Oktana Team
 * @description Wrapper class to handle Header_Sheet__c
 */
public class HeaderSheetWrapper {
    @AuraEnabled
    public EQCC_Header__c header { get; set; }
    @AuraEnabled
    public List<CheckedSheetWrapper> sheets { get; set; }
    @AuraEnabled
    public Boolean isOwnerOrAdmin { get; set; }

    public HeaderSheetWrapper(EQCC_Header__c header, List<CheckedSheetWrapper> sheets) {
        this.header = header;
        this.sheets = sheets;
    }

    public HeaderSheetWrapper(EQCC_Header__c header, List<CheckedSheetWrapper> sheets, Boolean isOwnerOrAdmin) {
        this.header = header;
        this.sheets = sheets;
        this.isOwnerOrAdmin = isOwnerOrAdmin;
    }
}