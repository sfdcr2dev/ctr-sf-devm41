/**
 * @author Oktana Team
 * @description Wrapper class to handle EQCC_Checked_Sheet__c
 */
public class CheckedSheetWrapper {
	@AuraEnabled
	public EQCC_Checked_Sheet__c sheet { get; set; }
	@AuraEnabled
	public String status { get; set; }
	@AuraEnabled
	public String requester { get; set; }
	@AuraEnabled
	public Date createdDate { get; set; }
	@AuraEnabled
	public Datetime createdDatetime { get; set; }
	@AuraEnabled
	public Datetime lastModifiedDatetime { get; set; }
	@AuraEnabled
	public Boolean isManuallyCreated { get; set; }
	@AuraEnabled
	public Id headerSheetId { get; set; }
	@AuraEnabled
	public Boolean isPolluted { get; set; }
	@AuraEnabled
	public String headerSheetName { get; set; }
	@AuraEnabled
	public List<EQCC_Step__c> eqccSteps { get; set; }

	public CheckedSheetWrapper(
		EQCC_Checked_Sheet__c sheet,
		String status,
		String requester,
		Date createdDate,
		Boolean isManuallyCreated,
		Id headerSheetId,
		Boolean isPolluted
	) {
		this.sheet = sheet;
		this.status = status;
		this.requester = requester;
		this.createdDate = createdDate;
		this.isManuallyCreated = isManuallyCreated;
		this.headerSheetId = headerSheetId;
		this.isPolluted = isPolluted;
	}

	public CheckedSheetWrapper(
		EQCC_Checked_Sheet__c sheet,
		String status,
		String requester,
		Date createdDate,
		Boolean isManuallyCreated,
		Id headerSheetId,
		Boolean isPolluted,
		String headerSheetName
	) {
		this.sheet = sheet;
		this.status = status;
		this.requester = requester;
		this.createdDate = createdDate;
		this.isManuallyCreated = isManuallyCreated;
		this.headerSheetId = headerSheetId;
		this.isPolluted = isPolluted;
		this.headerSheetName = headerSheetName;
	}

	public CheckedSheetWrapper(
		EQCC_Checked_Sheet__c sheet,
		String status,
		String requester,
		Datetime createdDatetime,
		Datetime lastModifiedDatetime,
		Boolean isManuallyCreated,
		Id headerSheetId,
		Boolean isPolluted,
		String headerSheetName,
		List<EQCC_Step__c> eqccSteps
	) {
		this.sheet = sheet;
		this.status = status;
		this.requester = requester;
		this.createdDatetime = createdDatetime;
		this.lastModifiedDatetime = lastModifiedDatetime;
		this.isManuallyCreated = isManuallyCreated;
		this.headerSheetId = headerSheetId;
		this.isPolluted = isPolluted;
		this.headerSheetName = headerSheetName;
		this.eqccSteps = eqccSteps != null ? eqccSteps : new List<EQCC_Step__c>();
	}
}