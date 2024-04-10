/* Author Softever */
public class ESS_MasterStationary_DTO {
    
    public class MasterStationaryListDTO {
		@RemoteAction
        public string recordId {get;set;}
        
        @RemoteAction
        public boolean active {get;set;}
         
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
         
        @RemoteAction
        public integer dueStock {get;set;}
         
        @RemoteAction
        public string stationaryId {get;set;}
         
        @RemoteAction
        public integer minimumStock {get;set;}
         
        @RemoteAction
        public string otherSupplier {get;set;}
         
        @RemoteAction
        public decimal price {get;set;}
         
        @RemoteAction
        public string stationaryName {get;set;}
         
        @RemoteAction
        public string stockHistory {get;set;}
         
        @RemoteAction
        public integer stockOnHand {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue supplier {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue type {get;set;}
         
        @RemoteAction
        public string unit {get;set;}
         
        @RemoteAction
        public integer availableStock {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue serviceFor {get;set;}
         
        @RemoteAction
        public date lastUpdatedDate {get;set;}
         
        @RemoteAction
        public string lastUpdatedBy {get;set;}
        
        @RemoteAction
        public boolean canDelete {get;set;}
        @RemoteAction
        public boolean isLowerMinimumStock {get;set;}
        @RemoteAction
        public boolean isDueStockMore {get;set;}
         
    }
    
    public class MasterStationaryDetailDTO {
		@RemoteAction
        public string recordId {get;set;}

        @RemoteAction
        public boolean active {get;set;}
         
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
         
        @RemoteAction
        public integer dueStock {get;set;}
         
        @RemoteAction
        public string stationaryId {get;set;}
         
        @RemoteAction
        public integer minimumStock {get;set;}
         
        @RemoteAction
        public string otherSupplier {get;set;}
         
        @RemoteAction
        public decimal price {get;set;}
         
        @RemoteAction
        public string stationaryName {get;set;}
         
        @RemoteAction
        public string stockHistory {get;set;}
         
        @RemoteAction
        public integer stockOnHand {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue supplier {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue type {get;set;}
         
        @RemoteAction
        public string unit {get;set;}
         
        @RemoteAction
        public integer availableStock {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue serviceFor {get;set;}
         
        @RemoteAction
        public date lastUpdatedDate {get;set;}
         
        @RemoteAction
        public string lastUpdatedBy {get;set;}
        
        @RemoteAction
        public boolean isEditServiceFor {get;set;}
         
    }
    
    public class MasterStationaryRequestDTO {

        @RemoteAction
        public string recordId {get;set;}
         
    }
    
    public class MasterStationaryResponseDTO {

        @RemoteAction
        public string response {get;set;}
         
    }
    
    public class SearchDTO {

        @RemoteAction
        public string recordId {get;set;}
         
        @RemoteAction
        public string search {get;set;}
         
    }
    
    public class UploadFileDTO {

        @RemoteAction
        public string fileName {get;set;}
         
        @RemoteAction
        public string fileData {get;set;}
         
        @RemoteAction
        public string recordId {get;set;}
         
    }
}