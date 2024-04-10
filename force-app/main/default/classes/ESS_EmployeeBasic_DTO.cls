/* Author Softever */
public class ESS_EmployeeBasic_DTO {

    public class ApplicationListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string subjectType {get;set;}
        //enum ApplicationStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public date verifiedDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        @RemoteAction
        public date cancelledDate {get;set;}
        @RemoteAction
        public boolean canDelete {get;set;}
    }
    
    public class ApplicationDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public boolean isSaveCancel {get;set;}
        @RemoteAction
        public boolean isVerify {get;set;}
        @RemoteAction
        public boolean isCancelRequest {get;set;}
        @RemoteAction
        public boolean isSubmit {get;set;}
        @RemoteAction
        public string verifyBy {get;set;}
        @RemoteAction
        public boolean isProcessingVerify {get;set;}
        @RemoteAction
        public ApplicationHeaderInfoDTO ApplicationHeaderInfo {get;set;}
        @RemoteAction
        public NameInfoDTO NameInfo {get;set;}
        @RemoteAction
        public StatusInfoDTO StatusInfo {get;set;}
        @RemoteAction
        public List<ChildInfoDTO> ChildInfos {get;set;}
        @RemoteAction
        public DeathHeaderDTO DeathInfo {get;set;}
        @RemoteAction
        public List<EducationInfoDTO> EducationInfos {get;set;}
        @RemoteAction
        public List<LicenseInfoDTO> LicenseInfos {get;set;}
        @RemoteAction
        public List<AddressInfoDTO> AddressInfos {get;set;}
        @RemoteAction
        public List<ContactPersonInfoDTO> ContactPersonInfos {get;set;}
        @RemoteAction
        public TaxInfoDTO TaxInfo {get;set;}
    }
    
    public class ApplicationHeaderInfoDTO {
        //Employee Information
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public boolean isTopEmployee {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string unit {get;set;}
        //Document Information
        @RemoteAction
        public string documentNo {get;set;}
        //enum ApplicationStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public date verifiedDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        @RemoteAction
        public date cancelledDate {get;set;}
        @RemoteAction
        public date effectiveDate {get;set;}
    }
    
    public class NameInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean editSelfInfo {get;set;}
        @RemoteAction
        public boolean editMarriedInfo {get;set;}
        @RemoteAction
        public boolean editChildInfo {get;set;}
        @RemoteAction
        public boolean editFatherInfo {get;set;}
        @RemoteAction
        public boolean editMotherInfo {get;set;}
        
        @RemoteAction
        public EmployeeInfoDTO employeeInfo {get;set;}
        @RemoteAction
        public StatusInfoDTO statusInfo {get;set;}
        @RemoteAction
        public List<ChildInfoDTO> childInfos {get;set;}
        @RemoteAction
        public integer childCount {get;set;}
        @RemoteAction
        public FatherInfoDTO fatherInfo {get;set;}
        @RemoteAction
        public MotherInfoDTO motherInfo {get;set;}
    }
    
    public class EmployeeInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        
        //Old Employee FirstName - LastName
        //enum title
        @RemoteAction
        public string oldTHTitleFNLN {get;set;} 
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue oldENTitle {get;set;} 
        @RemoteAction
        public string oldENFirstName {get;set;}
        @RemoteAction
        public string oldENLastName {get;set;}
        
        //New Employee FirstName - LastName
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newTHTitle {get;set;} 
        @RemoteAction
        public string newTHFirstName {get;set;}
        @RemoteAction
        public string newTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newENTitle {get;set;} 
        @RemoteAction
        public string newENFirstName {get;set;}
        @RemoteAction
        public string newENLastName {get;set;}
        
        @RemoteAction
        public string documentChangeNameNo {get;set;}
        @RemoteAction
        public string documentChangeNameLocation {get;set;}
        @RemoteAction
        public string documentChangeNameProvince {get;set;}
        @RemoteAction
        public date documentChangeNameDate {get;set;}
        @RemoteAction
        public string documentUploadedUrl {get;set;}
        @RemoteAction
        public string documentUploadedDisplayUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenDisplayUrl {get;set;}
    }
    
    public class StatusInfoDTO {
        
        @RemoteAction
        public boolean isShowOnlyMarried {get;set;}
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        @RemoteAction
        public boolean oldIsMarriedPersonAsEmployee {get;set;}
        @RemoteAction
        public boolean isMarriedPersonAsEmployee {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public boolean isUpdateMarriedStatus {get;set;}
        
        //enum MarriedStatus
        @RemoteAction
        public ESS_Global.EnumValue marriedStatus {get;set;} 
        
        @RemoteAction
        public boolean isMarriedPersonChangeDetail {get;set;}
		@RemoteAction
        public string marriedEmployeeId {get;set;}        
        //Married Person
        //Old Married FirstName - LastName
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue oldTHTitle {get;set;} 
        @RemoteAction
        public string oldTHFirstName {get;set;}
        @RemoteAction
        public string oldTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue oldENTitle {get;set;} 
        @RemoteAction
        public string oldENFirstName {get;set;}
        @RemoteAction
        public string oldENLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue thTitle {get;set;} 
        @RemoteAction
        public string thFirstName {get;set;}
        @RemoteAction
        public string thLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue enTitle {get;set;} 
        @RemoteAction
        public string enFirstName {get;set;}
        @RemoteAction
        public string enLastName {get;set;}
        
        @RemoteAction
        public string documentChangeNameNo {get;set;}
        @RemoteAction
        public string documentChangeNameLocation {get;set;}
        @RemoteAction
        public string documentChangeNameProvince {get;set;}
        @RemoteAction
        public date documentChangeNameDate {get;set;}
        @RemoteAction
        public string documentUploadedUrl {get;set;}
        @RemoteAction
        public string documentUploadedDisplayUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenDisplayUrl {get;set;}
        
        @RemoteAction
        public string citizenId {get;set;}
        @RemoteAction
        public date dateOfBirth {get;set;}
        @RemoteAction
        public string occupation {get;set;}
        @RemoteAction
        public string marriedDocumentNo {get;set;}
        @RemoteAction
        public string marriedDocumentIssueLocation {get;set;}
        @RemoteAction
        public string marriedDocumentIssueProvince {get;set;}
        @RemoteAction
        public date marriedDocumentIssueDate {get;set;}
        
        //Change Married Title - LastName
        @RemoteAction
        public boolean isChangeTitleAfterMarried {get;set;}
        @RemoteAction
        public boolean isChangeLastNameAfterMarried {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newMarriedTHTitle {get;set;} 
        @RemoteAction
        public string newMarriedTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newMarriedENTitle {get;set;} 
        @RemoteAction
        public string newMarriedENLastName {get;set;}
        
        @RemoteAction
        public string marriedDocumentUrl {get;set;}
        @RemoteAction
        public string marriedDocumentDisplayUrl {get;set;}
        @RemoteAction
        public string employeeTitleLastnameDocumentUrl {get;set;}
        @RemoteAction
        public string employeeTitleLastnameDocumentDisplayUrl {get;set;}
        @RemoteAction
        public string marriedPersonCopyDocumentUrl {get;set;}
        @RemoteAction
        public string marriedPersonCopyDocumentDisplayUrl {get;set;}
        @RemoteAction
        public string changeTitleLastnameCopyDocumentUrl {get;set;}
        @RemoteAction
        public string changeTitleLastnameCopyDocumentDisplayUrl {get;set;}
        
		//Divorced Fields
        //enum thTitle
        @RemoteAction
        public ESS_Global.EnumValue divorcedTHTitle {get;set;} 
        @RemoteAction
        public string divorcedTHFirstName {get;set;}
        @RemoteAction
        public string divorcedTHLastName {get;set;}    
        //enum enTitle
        @RemoteAction
        public ESS_Global.EnumValue divorcedENTitle {get;set;} 
        @RemoteAction
        public string divorcedENFirstName {get;set;}
        @RemoteAction
        public string divorcedENLastName {get;set;}   
        @RemoteAction
        public string divorcedDocumentNo {get;set;} 
        @RemoteAction
        public string divorcedDocumentIssueLocation {get;set;} 
        @RemoteAction
        public string divorcedDocumentIssueProvince {get;set;} 
        @RemoteAction
        public date divorcedDocumentIssueDate {get;set;} 
        
        @RemoteAction
        public boolean isChangeTitleAfterDivorced {get;set;} 
        @RemoteAction
        public boolean isChangeLastNameAfterDivorced {get;set;} 
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newDivorcedTHTitle {get;set;} 
        @RemoteAction
        public string newDivorcedTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newDivorcedENTitle {get;set;} 
        @RemoteAction
        public string newDivorcedENLastName {get;set;}
        @RemoteAction
        public string divorcedDocumentUrl {get;set;}
        @RemoteAction
        public string divorcedDocumentDisplayUrl {get;set;}
        @RemoteAction
        public string divorcedChangeTitleLastNameUrl {get;set;}
        @RemoteAction
        public string divorcedChangeTitleLastNameDisplayUrl {get;set;}
        @RemoteAction
        public string divorcedUseChangeTitleLastNameUrl {get;set;}
        @RemoteAction
        public string divorcedUseChangeTitleLastNameDisplayUrl {get;set;}
        
        //Widow
        //enum thTitle
        @RemoteAction
        public ESS_Global.EnumValue widowTHTitle {get;set;} 
        @RemoteAction
        public string widowTHFirstName {get;set;}
        @RemoteAction
        public string widowTHLastName {get;set;}    
        //enum enTitle
        @RemoteAction
        public ESS_Global.EnumValue widowENTitle {get;set;} 
        @RemoteAction
        public string widowENFirstName {get;set;}
        @RemoteAction
        public string widowENLastName {get;set;}   
        @RemoteAction
        public string widowDocumentNo {get;set;} 
        @RemoteAction
        public string widowDocumentIssueLocation {get;set;} 
        @RemoteAction
        public string widowDocumentIssueProvince {get;set;} 
        @RemoteAction
        public date widowDocumentIssueDate {get;set;} 
        
        @RemoteAction
        public boolean isChangeTitleAfterWidow {get;set;} 
        @RemoteAction
        public boolean isChangeLastNameAfterWidow {get;set;} 
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newWidowTHTitle {get;set;} 
        @RemoteAction
        public string newWidowTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newWidowENTitle {get;set;} 
        @RemoteAction
        public string newWidowENLastName {get;set;}
        @RemoteAction
        public string deathWidowDocumentUrl {get;set;}
        @RemoteAction
        public string deathWidowDocumentDisplayUrl {get;set;}
        @RemoteAction
        public string deathWidowChangeTitleLastNameUrl {get;set;}
        @RemoteAction
        public string deathWidowChangeTitleLastNameDisplayUrl {get;set;}
    }
    
    public class ChildInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isMarriedPersonAsEmployee {get;set;}
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        
        //enum GenderStatus
        @RemoteAction
        public ESS_Global.EnumValue gender {get;set;}
        @RemoteAction
        public string citizenId {get;set;}
        @RemoteAction
        public datetime birthDate {get;set;}
        //enum ChildStatus
        @RemoteAction
        public ESS_Global.EnumValue child {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        
        @RemoteAction
        public string thNo {get;set;}
        @RemoteAction
        public string enNo {get;set;}
        //Child FirstName - LastName
        @RemoteAction
        public string thFirstName {get;set;}
        @RemoteAction
        public string thLastName {get;set;}
        @RemoteAction
        public string enFirstName {get;set;}
        @RemoteAction
        public string enLastName {get;set;}
        @RemoteAction
        public string newTHFirstName {get;set;}
        @RemoteAction
        public string newTHLastName {get;set;}
        @RemoteAction
        public string newENFirstName {get;set;}
        @RemoteAction
        public string newENLastName {get;set;}
        
        @RemoteAction
        public string documentChangeNameNo {get;set;}
        @RemoteAction
        public string documentChangeNameLocation {get;set;}
        @RemoteAction
        public string documentChangeNameProvince {get;set;}
        @RemoteAction
        public datetime documentChangeNameDate {get;set;}
        @RemoteAction
        public string documentChangeFirstNameLastNameUrl {get;set;}
        @RemoteAction
        public string documentChangeFirstNameLastNameDisplayUrl {get;set;}
        @RemoteAction
        public string documentBirthCertificateUrl {get;set;}
        @RemoteAction
        public string documentBirthCertificateDisplayUrl {get;set;}
        @RemoteAction
        public string documentBirthProtegeUrl {get;set;}
        @RemoteAction
        public string documentBirthProtegeDisplayUrl {get;set;}
        @RemoteAction
        public string documentLegitimationUrl {get;set;}
        @RemoteAction
        public string documentLegitimationDisplayUrl {get;set;}
        @RemoteAction
        public string documentLegitimationProtegeUrl {get;set;}
        @RemoteAction
        public string documentLegitimationProtegeDisplayUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenDisplayUrl {get;set;}
        
    }
    
    public class FatherInfoDTO {
        
        @RemoteAction
        public boolean isEditable {get;set;}
        
        //Old FirstName - LastName
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue oldTHTitle {get;set;} 
        @RemoteAction
        public string oldTHFirstName {get;set;}
        @RemoteAction
        public string oldTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue oldENTitle {get;set;} 
        @RemoteAction
        public string oldENFirstName {get;set;}
        @RemoteAction
        public string oldENLastName {get;set;}
        
        //New Employee FirstName - LastName
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newTHTitle {get;set;} 
        @RemoteAction
        public string newTHFirstName {get;set;}
        @RemoteAction
        public string newTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newENTitle {get;set;} 
        @RemoteAction
        public string newENFirstName {get;set;}
        @RemoteAction
        public string newENLastName {get;set;}
        
        @RemoteAction
        public string documentChangeNameNo {get;set;}
        @RemoteAction
        public string documentChangeNameLocation {get;set;}
        @RemoteAction
        public string documentChangeNameProvince {get;set;}
        @RemoteAction
        public date documentChangeNameDate {get;set;}
        @RemoteAction
        public string documentUploadedUrl {get;set;}
        @RemoteAction
        public string documentUploadedDisplayUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenDisplayUrl {get;set;}
        
    }
    
    public class MotherInfoDTO {
        
        @RemoteAction
        public boolean isEditable {get;set;}
        
        //Old FirstName - LastName
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue oldTHTitle {get;set;} 
        @RemoteAction
        public string oldTHFirstName {get;set;}
        @RemoteAction
        public string oldTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue oldENTitle {get;set;} 
        @RemoteAction
        public string oldENFirstName {get;set;}
        @RemoteAction
        public string oldENLastName {get;set;}
        
        //New Employee FirstName - LastName
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newTHTitle {get;set;} 
        @RemoteAction
        public string newTHFirstName {get;set;}
        @RemoteAction
        public string newTHLastName {get;set;}
        //enum title
        @RemoteAction
        public ESS_Global.EnumValue newENTitle {get;set;} 
        @RemoteAction
        public string newENFirstName {get;set;}
        @RemoteAction
        public string newENLastName {get;set;}
        
        @RemoteAction
        public string documentChangeNameNo {get;set;}
        @RemoteAction
        public string documentChangeNameLocation {get;set;}
        @RemoteAction
        public string documentChangeNameProvince {get;set;}
        @RemoteAction
        public date documentChangeNameDate {get;set;}
        @RemoteAction
        public string documentUploadedUrl {get;set;}
        @RemoteAction
        public string documentUploadedDisplayUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenUrl {get;set;}
        @RemoteAction
        public string documentCopyCitizenDisplayUrl {get;set;}
        
    }
    
    public class DeathHeaderDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        
        @RemoteAction
        public boolean isMarriedPersonAsEmployee {get;set;}
        
        @RemoteAction
        public boolean isDeathWife {get;set;}
        @RemoteAction
        public boolean isDeathChild {get;set;}
        @RemoteAction
        public boolean isDeathFather {get;set;}
        @RemoteAction
        public boolean isDeathMother {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public List<DeathInfoDTO> DeathInfos {get;set;}
        
    }
    
    public class DeathInfoDTO {
        
        //enum DeathPerson
        @RemoteAction
        public ESS_Global.EnumValue deathPerson {get;set;} 
        @RemoteAction
        public boolean isEditable {get;set;}
		@RemoteAction
        public string status {get;set;}
        @RemoteAction
        public string thNo {get;set;}
        //enum Title
        @RemoteAction
        public ESS_Global.EnumValue title {get;set;} 
        @RemoteAction
        public string thFirstName {get;set;}
        @RemoteAction
        public string thLastName {get;set;}
        @RemoteAction
        public string deathDetail {get;set;}
        @RemoteAction
        public string deathDocumentNo {get;set;}
        @RemoteAction
        public string deathDocumentIssueLocation {get;set;}
        @RemoteAction
        public string deathDocumentIssueProvince {get;set;}
        @RemoteAction
        public date deathDocumentIssueDate {get;set;}
        @RemoteAction
        public string deathDocumentUrl {get;set;}
        @RemoteAction
        public string deathDocumentDisplayUrl {get;set;}
        
    }
    
    public class EducationInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        @RemoteAction
        public string status {get;set;}
        
        @RemoteAction
        public string no {get;set;}
        @RemoteAction
        //EducationalQualification
        public ESS_Global.EnumValue  qualification {get;set;}
        @RemoteAction
        public string enEducationalName {get;set;}
        @RemoteAction
        public string enEducationalField {get;set;}
        @RemoteAction
        public string enEducationalInstitution {get;set;}
        @RemoteAction
        public string enEducationalCountry {get;set;}
        @RemoteAction
        public string enEducationalLevel {get;set;}
        @RemoteAction
        public datetime startDate {get;set;}
        @RemoteAction
        public datetime graduatedDate {get;set;}
        @RemoteAction
        public string graduatedGrade {get;set;}
        @RemoteAction
        public string transcriptUrl {get;set;}
        @RemoteAction
        public string transcriptDisplayUrl {get;set;}
        @RemoteAction
        public string degreeCertificateUrl {get;set;}
        @RemoteAction
        public string degreeCertificateDisplayUrl {get;set;}
        
    }
    
    public class LicenseInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        
        //enum LicenseType
        @RemoteAction
        public ESS_Global.EnumValue licenseType {get;set;} 
        @RemoteAction
        public string citizenId {get;set;}
        @RemoteAction
        public date issueDate {get;set;}
        @RemoteAction
        public date expireDate {get;set;}
        @RemoteAction
        public string issuedProvince {get;set;}
        @RemoteAction
        public date newIssueDate {get;set;}
        @RemoteAction
        public date newExpireDate {get;set;}
        @RemoteAction
        public string newIssuedProvince {get;set;}
        @RemoteAction
        public string documentCitizenCopyUrl {get;set;}
        @RemoteAction
        public string documentCitizenCopyDisplayUrl {get;set;}
        @RemoteAction
        public string licenseNo {get;set;}
        @RemoteAction
        public string licenseLevel {get;set;}
        @RemoteAction
        public string engineeringBranch {get;set;}
        @RemoteAction
        public string newLicenseNo {get;set;}
        @RemoteAction
        public string newLicenseLevel {get;set;}
        @RemoteAction
        public string newEngineeringBranch {get;set;}
        @RemoteAction
        public string documentProfessionalUrl {get;set;}
        @RemoteAction
        public string documentProfessionalDisplayUrl {get;set;}
        
    }
    
    public class AddressInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        
        //enum AddressType
        @RemoteAction
        public ESS_Global.EnumValue addressType {get;set;} 
        
        //Address
        @RemoteAction
        public string thHouseNo {get;set;}
        @RemoteAction
        public string thMooVillageSoiRoad {get;set;}
        @RemoteAction
        public string thSubDistrictDistrict {get;set;}
        @RemoteAction
        public string thProvince {get;set;}
        @RemoteAction
        public string thPostalCode {get;set;}
        @RemoteAction
        public string thTelephoneNo {get;set;}
        
        @RemoteAction
        public string enHouseNo {get;set;}
        @RemoteAction
        public string enMooVillageSoiRoad {get;set;}
        @RemoteAction
        public string enSubDistrictDistrict {get;set;}
        @RemoteAction
        public string enProvince {get;set;}
        @RemoteAction
        public string enPostalCode {get;set;}
        @RemoteAction
        public string enTelephoneNo {get;set;}
        
        //New Address
        @RemoteAction
        public string newTHHouseNo {get;set;}
        @RemoteAction
        public string newTHMoo {get;set;}
        @RemoteAction
        public string newTHVillageName {get;set;}
        @RemoteAction
        public string newTHSoi {get;set;}
        @RemoteAction
        public string newTHRoad {get;set;}
        @RemoteAction
        public string newTHSubDistrict {get;set;}
        @RemoteAction
        public string newTHDistrict {get;set;}
        @RemoteAction
        public string newTHProvince {get;set;}
        @RemoteAction
        public string newTHPostalCode {get;set;}
        @RemoteAction
        public string newTHTelephoneNo {get;set;}
        
        @RemoteAction
        public string newENHouseNo {get;set;}
        @RemoteAction
        public string newENMoo {get;set;}
        @RemoteAction
        public string newENVillageName {get;set;}
        @RemoteAction
        public string newENSoi {get;set;}
        @RemoteAction
        public string newENRoad {get;set;}
        @RemoteAction
        public string newENSubDistrict {get;set;}
        @RemoteAction
        public string newENDistrict {get;set;}
        @RemoteAction
        public string newENProvince {get;set;}
        @RemoteAction
        public string newENPostalCode {get;set;}
        @RemoteAction
        public string newENTelephoneNo {get;set;}
        @RemoteAction
        public string documentRegistrationCopyUrl {get;set;}
        @RemoteAction
        public string documentRegistrationCopyDisplayUrl {get;set;}
    }
    
    public class ContactPersonInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isCurrent {get;set;}
        @RemoteAction
        public boolean isEdit {get;set;}
        @RemoteAction
        public boolean isDelete {get;set;}
        @RemoteAction
        public string status {get;set;}
        
        @RemoteAction
        public boolean isMainContactTH {get;set;}
        @RemoteAction
        public boolean isMainContactEN {get;set;}
        
        @RemoteAction
        public string thNo {get;set;}
        @RemoteAction
        public string thFirstName {get;set;}
        @RemoteAction
        public string thLastName {get;set;}
        //enum Genderstatus
        @RemoteAction
        public ESS_Global.EnumValue thGenderStatus {get;set;} 
        @RemoteAction
        public string thRelationship {get;set;}
        @RemoteAction
        public string thHouseNo {get;set;}
        @RemoteAction
        public string thMoo {get;set;}
        @RemoteAction
        public string thVillageName {get;set;}
        @RemoteAction
        public string thSoi {get;set;}
        @RemoteAction
        public string thRoad {get;set;}
        @RemoteAction
        public string thSubDistrict {get;set;}
        @RemoteAction
        public string thDistrict {get;set;}
        @RemoteAction
        public string thProvince {get;set;}
        @RemoteAction
        public string thPostalCode {get;set;}
        @RemoteAction
        public string thTelephoneNo {get;set;}
        @RemoteAction
        public string thMooVillageSoiRoad {get;set;}
        @RemoteAction
        public string thDistrictSubDistrict {get;set;}
        
        @RemoteAction
        public string enNo {get;set;}
        @RemoteAction
        public string enFirstName {get;set;}
        @RemoteAction
        public string enLastName {get;set;}
        //enum Genderstatus
        @RemoteAction
        public ESS_Global.EnumValue enGenderStatus {get;set;} 
        @RemoteAction
        public string enRelationship {get;set;}
        @RemoteAction
        public string enHouseNo {get;set;}
        @RemoteAction
        public string enMoo {get;set;}
        @RemoteAction
        public string enVillageName {get;set;}
        @RemoteAction
        public string enSoi {get;set;}
        @RemoteAction
        public string enRoad {get;set;}
        @RemoteAction
        public string enSubDistrict {get;set;}
        @RemoteAction
        public string enDistrict {get;set;}
        @RemoteAction
        public string enProvince {get;set;}
        @RemoteAction
        public string enPostalCode {get;set;}
        @RemoteAction
        public string enTelephoneNo {get;set;}
        @RemoteAction
        public string enMooVillageSoiRoad {get;set;}
        @RemoteAction
        public string enDistrictSubDistrict {get;set;}
        
        //EditInfo
        
        @RemoteAction
        public string newTHFirstName {get;set;}
        @RemoteAction
        public string newTHLastName {get;set;}
        //enum Genderstatus
        @RemoteAction
        public ESS_Global.EnumValue newTHGenderStatus {get;set;} 
        @RemoteAction
        public string newTHRelationship {get;set;}
        @RemoteAction
        public string newTHHouseNo {get;set;}
        @RemoteAction
        public string newTHMoo {get;set;}
        @RemoteAction
        public string newTHVillageName {get;set;}
        @RemoteAction
        public string newTHSoi {get;set;}
        @RemoteAction
        public string newTHRoad {get;set;}
        @RemoteAction
        public string newTHSubDistrict {get;set;}
        @RemoteAction
        public string newTHDistrict {get;set;}
        @RemoteAction
        public string newTHProvince {get;set;}
        @RemoteAction
        public string newTHPostalCode {get;set;}
        @RemoteAction
        public string newTHTelephoneNo {get;set;}
        @RemoteAction
        public string newTHMooVillageSoiRoad {get;set;}
        @RemoteAction
        public string newTHDistrictSubDistrict {get;set;}
        
        @RemoteAction
        public string newENFirstName {get;set;}
        @RemoteAction
        public string newENLastName {get;set;}
        //enum Genderstatus
        @RemoteAction
        public ESS_Global.EnumValue newENGenderStatus {get;set;} 
        @RemoteAction
        public string newENRelationship {get;set;}
        @RemoteAction
        public string newENHouseNo {get;set;}
        @RemoteAction
        public string newENMoo {get;set;}
        @RemoteAction
        public string newENVillageName {get;set;}
        @RemoteAction
        public string newENSoi {get;set;}
        @RemoteAction
        public string newENRoad {get;set;}
        @RemoteAction
        public string newENSubDistrict {get;set;}
        @RemoteAction
        public string newENDistrict {get;set;}
        @RemoteAction
        public string newENProvince {get;set;}
        @RemoteAction
        public string newENPostalCode {get;set;}
        @RemoteAction
        public string newENTelephoneNo {get;set;}
        @RemoteAction
        public string newENMooVillageSoiRoad {get;set;}
        @RemoteAction
        public string newENDistrictSubDistrict {get;set;}
    }
    
    public class TaxInfoDTO {
        
        @RemoteAction
        public boolean isChange {get;set;}
        @RemoteAction
        public boolean isEditable {get;set;}
        
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string citizenId {get;set;}
        //enum MarriedStatus
        @RemoteAction
        public ESS_Global.EnumValue marriedStatus {get;set;} 
        //enum MarriedEarnIncome
        @RemoteAction
        public ESS_Global.EnumValue marriedPersonEarnIncome {get;set;}
        @RemoteAction
        public integer childCount {get;set;}
        @RemoteAction
        public integer childCountTotal {get;set;}
        @RemoteAction
        public decimal selfLifeInsurancePaidAmount {get;set;}
        @RemoteAction
        public decimal marriedLifeInsurancePaidAmount {get;set;}
        @RemoteAction
        public decimal selfFatherHealthInsurancePaidAmount {get;set;}
        @RemoteAction
        public decimal selfMotherHealthInsurancePaidAmount {get;set;}
        @RemoteAction
        public decimal marriedFatherHealthInsurancePaidAmount {get;set;}
        @RemoteAction
        public decimal marriedMotherHealthInsurancePaidAmount {get;set;}
        @RemoteAction
        public decimal interestOnLoanForHouseAmount {get;set;}
        @RemoteAction
        public decimal incomeFromRMFAmount {get;set;}
        @RemoteAction
        public decimal incomeFromSSFAmount {get;set;}
        @RemoteAction
        public decimal selfTaxDeductionFatherAmount {get;set;}
        @RemoteAction
        public decimal selfTaxDeductionMotherAmount {get;set;}
        @RemoteAction
        public decimal marriedTaxDeductionFatherAmount {get;set;}
        @RemoteAction
        public decimal marriedTaxDeductionMotherAmount {get;set;}
        @RemoteAction
        public decimal donationForCharityAmount {get;set;}
        @RemoteAction
        public decimal sponsorAmount {get;set;}
        @RemoteAction
        public decimal donationForEducationAmount {get;set;}
        @RemoteAction
        public decimal annuityInterestAmount {get;set;}
        @RemoteAction
        public decimal firstHouseExcludeTaxAmount {get;set;}
        @RemoteAction
        public decimal pregnancyCareAmount {get;set;} 
        
        
    }
    
    public class SearchNameDTO {
        @RemoteAction
        public string displayName {get;set;}
        @RemoteAction
        public string thTitle {get;set;}
        @RemoteAction
        public string thFirstName {get;set;}
        @RemoteAction
        public string thLastName {get;set;}
        @RemoteAction
        public string enTitle {get;set;}
        @RemoteAction
        public string enFirstName {get;set;}
        @RemoteAction
        public string enLastName {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
    }
    
}