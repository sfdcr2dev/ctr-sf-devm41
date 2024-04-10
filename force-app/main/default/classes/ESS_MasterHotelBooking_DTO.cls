/* Author Softever */
public class ESS_MasterHotelBooking_DTO {
    
	public class MasterHotelBookingDTO {
		@RemoteAction
        public string recordId {get;set;}

        //Hotel ID
        @RemoteAction
        public string hotelId {get;set;}
         
        @RemoteAction
        public decimal guest1ChargeEmployee {get;set;}
         
        @RemoteAction
        public decimal guest1ContractRate {get;set;}
         
        @RemoteAction
        public decimal guest2ChargeEmployee {get;set;}
         
        @RemoteAction
        public decimal guest2ContractRate {get;set;}
         
        @RemoteAction
        public decimal twinBedChargeEmployee {get;set;}
        @RemoteAction
        public decimal twinBedContractRate {get;set;}
         
        @RemoteAction
        public string hotelName {get;set;}
         
        @RemoteAction
        public string hotelWebsite {get;set;}
         
        @RemoteAction
        public string linkMap {get;set;}
         
        @RemoteAction
        public string location {get;set;}
        
        @RemoteAction
        public boolean canDelete {get;set;}
        
        @RemoteAction
        public boolean active {get;set;}
         
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
        
        @RemoteAction
        public List<MasterHotelBookingContactDTO> masterHotelBookingContacts {get;set;}
         
    }
    
    public class MasterHotelBookingContactDTO {

        @RemoteAction
        public string contactName {get;set;}
         
        @RemoteAction
        public string contactEmail {get;set;}
         
        @RemoteAction
        public string contactTelephone {get;set;}
         
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