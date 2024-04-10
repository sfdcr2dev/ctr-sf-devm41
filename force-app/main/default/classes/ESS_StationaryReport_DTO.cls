public class ESS_StationaryReport_DTO {

    public class RemainingStockDTO {
        @RemoteAction
        public string stationaryId {get;set;}
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public decimal price {get;set;}
        @RemoteAction
        public integer stockOnHand {get;set;}
        @RemoteAction
        public integer stockOverdue {get;set;}
    }
    
    public class OutOfStockDTO {
        @RemoteAction
        public string stationaryId {get;set;}
        @RemoteAction
        public string name  {get;set;}
        @RemoteAction
        public decimal price {get;set;}
        @RemoteAction
        public integer stockOnHand {get;set;}
        @RemoteAction
        public integer stockOverdue {get;set;}
        @RemoteAction
        public integer stockMinimum {get;set;}
    }
    
    public class DailyWithdrawDTO {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string location {get;set;}
        @RemoteAction
        public string serviceFor {get;set;}
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string stationaryId {get;set;}
        @RemoteAction
        public string stationaryName {get;set;}
        @RemoteAction
        public integer quantity {get;set;}
        @RemoteAction
        public decimal price {get;set;}
        @RemoteAction
        public string supplier {get;set;}
        @RemoteAction
        public integer stockOnHand {get;set;}
        @RemoteAction
        public integer withdrawQuantity {get;set;} //จำนวนที่เบิก
        @RemoteAction
        public integer actualQuantity {get;set;} //จ่ายจริง
        @RemoteAction
        public integer overdueQuantity {get;set;} //จำนวนค้างจ่าย
        @RemoteAction
        public decimal totalPrice {get;set;}
        @RemoteAction
        public datetime createdDate {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public string requesterName {get;set;}
        @RemoteAction
        public string completedBy {get;set;}
        @RemoteAction
        public datetime completedDate {get;set;}
        @RemoteAction
        public string currentStatus {get;set;}
    }
    
    public class DailyWithdrawHeaderDTO {
        @RemoteAction
        public TaxDTO TaxInfo {get;set;}
        @RemoteAction
        public List<DailyWithdrawItemDTO> DailyWithdrawItems {get;set;}
    }
    
    public class TaxDTO {
        public string ServiceFor {get;set;}
        public string Name {get;set;}
        public string TaxID {get;set;}
        public string BranchNo {get;set;}
        public string ShowAs {get;set;}
        public string Address {get;set;}
    }
    
    public static string STATIONARYID_SORT = 'StationaryID';
    public static string STATIONARYNAME_SORT = 'StationaryName';
    public static string SORT_BY = STATIONARYID_SORT;
    public class DailyWithdrawItemDTO implements Comparable {
        
        @RemoteAction
        public string orderNo {get;set;}
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string stationaryId {get;set;}
        @RemoteAction
        public string stationaryName {get;set;}
        @RemoteAction
        public integer quantity {get;set;} //จำนวน
        @RemoteAction
        public decimal pricePerUnit {get;set;} //ราคาหน่วยละ 
        @RemoteAction
        public decimal totalPrice {get;set;} //จำนวนเงิน
        
        public DailyWithdrawItemDTO() { }
        
        //Sort By
        public DailyWithdrawItemDTO(string stationaryId, string stationaryName) {
            this.stationaryId = stationaryId;
            this.stationaryName = stationaryName;
        }
        
        //stationaryId Sort
        public integer sortByStationaryId(DailyWithdrawItemDTO item) {
            if(this.stationaryId > item.stationaryId) {
                return 1;
            }
            if(this.stationaryId == item.stationaryId) {
                return 0;
            }
            return -1;
        }
        
        //stationaryName Sort
        public integer sortByStationaryName(DailyWithdrawItemDTO item) {
            if(this.stationaryName > item.stationaryName) {
                return 1;
            }
            if(this.stationaryName == item.stationaryName) {
                return 0;
            }
            return -1;
        }
        
        public Integer compareTo(Object obj) {
            DailyWithdrawItemDTO Item = (DailyWithdrawItemDTO)(obj);

            if (SORT_BY == STATIONARYID_SORT) {
                return sortByStationaryId(Item);
            }
            else if (SORT_BY == STATIONARYNAME_SORT) {
                return sortByStationaryName(Item);
            }
            
            return 0;
        }
    }
    
    public static void sortByStationaryId(List<DailyWithdrawItemDTO> itemSortLists) {
        ESS_StationaryReport_DTO.SORT_BY = ESS_StationaryReport_DTO.STATIONARYID_SORT;
        itemSortLists.sort();
    }
    
    public static void sortByStationaryName(List<DailyWithdrawItemDTO> itemSortLists) {
        ESS_StationaryReport_DTO.SORT_BY = ESS_StationaryReport_DTO.STATIONARYNAME_SORT;
        itemSortLists.sort();
    }
    
    public class DailyWithdrawRequestDTO {
        @RemoteAction
        public string orderNo {get;set;}
        @RemoteAction
        public datetime withdrawDate {get;set;}
        @RemoteAction
        public string withdrawFrom {get;set;} //บริษัทผู้ให้บริการ
        @RemoteAction
        public string serviceFor {get;set;} //ใช้ในบริษัท
        @RemoteAction
        public integer total {get;set;} //จำนวนรายการ
    }
    
}