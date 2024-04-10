public with sharing class CTRShipToRequestFormItemModelData 
{
    public CTRShipToRequestFormItemModelChild input { get; set; }

    public class CTRShipToRequestFormItemModelChild
    {
        public CTRShipToRequestFormItemModelSubChild input{ get; set; }
    } 

    public class CTRShipToRequestFormItemModelSubChild {
        public String AccountNumber{ get; set; }
        public String CompanyCode{ get; set; }
        public String SalesOrganization{ get; set; }
        public String DistributionChannel{ get; set; }
        public String Division{ get; set; }
        public String Id{ get; set; }
        public String GatewayId{ get; set; }
        public String Partner{ get; set; }
        public String RecordType{ get; set; }
        //public String ReferenceId{ get; set; }
        public String Flag{ get; set; }

        public List<CentralDataModel> CentralData{ get; set; }
        public List<AddressModel> AddressGen{ get; set; }
        public List<AddressIntModel> AddressInt{ get; set; }
        public List<SalesDataModel> SalesData{ get; set; }
        public List<TaxClassificationModel> TaxClassification{ get; set; }
        public List<CompanyCodeViewModel> CompanyCodeView{ get; set; }
    }

    public class CentralDataModel {
        public String AccountGroup{ get; set; }
        public String Country{ get; set; }
        public String TaxCode1{ get; set; }
        public String TaxCode5{ get; set; }
        public String TypeofBusiness{ get; set; }
        public String Block{ get; set; }
        public String TradingPartner{ get; set; }
        public String Industry{ get; set; }
        public String CustomerType{ get; set; }
    }

    public class AddressModel{ 
        public String Type{ get; set; }
        
        public String CoName{ get; set; }
        public String CustomerName1{ get; set; }
        public String CustomerName2{ get; set; }
        public String CustomerName3{ get; set; }
        public String CustomerName4{ get; set; }

        public String CityStateText{ get; set; }
        public String SubDistrictText{ get; set; }
        public String DistrictText{ get; set; }
        public String PostalCodeText{ get; set; }
        
        public String BuildingCode{ get; set; }
        public String Room{ get; set; }
        public String Floor{ get; set; }

        public String Street{ get; set; }
        public String Houseno{ get; set; }
        public String Street2{ get; set; }
        public String Street3{ get; set; }
        public String Street4{ get; set; }
        public String Street5{ get; set; }

        public String Country{ get; set; }
        public String Language{ get; set; }
        public String Region{ get; set; }
        public String TimeZone{ get; set; }

        public String SearchTerm{ get; set; }
        public String SearchTermEN{ get; set; }

        //public String Location{ get; set; }
        public String PhoneCountryCode{ get; set; }
        public String Phone{ get; set; }
        public String PhoneExtension{ get; set; }
        public String FaxCountryCode{ get; set; }
        public String Fax{ get; set; }
        public String FaxExtension{ get; set; }
        public String Email{ get; set; }
        public String MobileCountryCode{ get; set; }
        public String MobilePhone{ get; set; }
        public string TransportationZone{ get; set; }

        public String Flag{ get; set; }
    }
    
    public class AddressIntModel{ 
        public String Type{ get; set; }
        
        public String CoName{ get; set; }
        public String CustomerName1{ get; set; }
        public String CustomerName2{ get; set; }
        public String CustomerName3{ get; set; }
        public String CustomerName4{ get; set; }

        public String CityStateText{ get; set; }
        public String SubDistrictText{ get; set; }
        public String DistrictText{ get; set; }
        
        public String BuildingCode{ get; set; }
        public String Room{ get; set; }
        public String Floor{ get; set; }

        public String Street{ get; set; }
        public String Houseno{ get; set; }
        public String Street2{ get; set; }
        public String Street3{ get; set; }
        public String Street4{ get; set; }
        public String Street5{ get; set; }
        public String Country{ get; set; }

        public String SearchTerm{ get; set; }
        public String SearchTermEN{ get; set; }
        public String Flag{ get; set; }

        
    }

    public class SalesDataModel
    {
        public String Task{ get; set; }
        public String ShippingConditions{ get; set; }
        public String AccountAssignmentGroup{ get; set; }
        public String Flag{ get; set; }
    }

    public class TaxClassificationModel{
        public String Task{ get; set; }
        public String CountryCode{ get; set; }
        public String TaxCategory{ get; set; }
        public String TaxClassification{ get; set; }
    }

    public class CompanyCodeViewModel{
        public String Task{ get; set; }
        public String SortKey{ get; set; }
        public String ReconciliationAccount{ get; set; }
        public String PaymentMethods{ get; set; }
        public String PlanningGroup{ get; set; }//CashManagementGroup__c
        public String PaymentHistoryRecord{ get; set; }
        public String AuthorizationGroup{ get; set; }
    }

    public static CTRShipToRequestFormItemModelData SetupJsonForShipToDataModel (CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mViewName, String mBusinessUnit, String mGatewayId)
    {
        String uuid = mGatewayId; //(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRShipToRequestFormItemModelData ctrData = new CTRShipToRequestFormItemModelData();
        CTRShipToRequestFormItemModelChild inputModel = new CTRShipToRequestFormItemModelChild();
        CTRShipToRequestFormItemModelSubChild subInputModel = new CTRShipToRequestFormItemModelSubChild();
        
        List<CentralDataModel> centralDataModelList = new List<CentralDataModel>();
        List<AddressModel> addressGenModelList = new List<AddressModel>();
        List<AddressIntModel> addressIntModelList = new List<AddressIntModel>();
        List<SalesDataModel> salesDataModelList = new List<SalesDataModel>();
        List<TaxClassificationModel> taxClassificationModelList = new List<TaxClassificationModel>();
        List<CompanyCodeViewModel> companyCodeViewModelList = new List<CompanyCodeViewModel>();
        
        subInputModel.AccountNumber = mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: ''; //TODO Null value in google sheet
        subInputModel.CompanyCode = '';//mRequestItem.Customer__r.CompanyCode__c !=null ? mRequestItem.Customer__r.CompanyCode__c: '';
        subInputModel.SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
        subInputModel.DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
        subInputModel.Division = mRequestItem.Division__c !=null ? mRequestItem.Division__c: '';
        subInputModel.Id = mRequestHeader.Customer__c;
        subInputModel.GatewayId = uuid;
        subInputModel.Partner = mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: '';
        subInputModel.RecordType = mRequestItem.RecordType.DeveloperName;
        subInputModel.Flag = 'I';
        
            // CentralDataModel
            CentralDataModel centralDataModel = new CentralDataModel();
            centralDataModel.AccountGroup = mRequestHeader.AccountGroup__c !=null ? mRequestHeader.AccountGroup__c: '';
            centralDataModel.Country = '';// mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: ''; //Country__c Map แล้ว Error
            centralDataModel.TaxCode1 = (mRequestHeader.TaxCode1__c !=null && mRequestHeader.TaxCode1__c.length() <= 16) ? mRequestHeader.TaxCode1__c: '';
            centralDataModel.TaxCode5 = mRequestHeader.TaxCode1__c !=null ? mRequestHeader.TaxCode1__c: '';
            centralDataModel.TypeofBusiness = mRequestHeader.TypeOfBusinessBranch__c !=null ? mRequestHeader.TypeOfBusinessBranch__c: '';//'00001'
            centralDataModel.Block = '';//ยังไม่มี
            centralDataModel.TradingPartner = mRequestHeader.TradingPartner__r.Code__c !=null ? mRequestHeader.TradingPartner__r.Code__c: '';
            centralDataModel.Industry = mRequestHeader.Industry__c !=null ? mRequestHeader.Industry__c: '';
            centralDataModel.CustomerType = mRequestHeader.CustomerTypeSAP__c !=null ? mRequestHeader.CustomerTypeSAP__c: '';
            centralDataModelList.add(centralDataModel);

            // AddressGenModel
            AddressModel addressGenModel = new AddressModel();
            addressGenModel.Type ='I';
            addressGenModel.CoName = mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '';
            addressGenModel.CustomerName1 = mRequestHeader.CustomerNameLocal1__c !=null ? mRequestHeader.CustomerNameLocal1__c: '';
            addressGenModel.CustomerName2 = mRequestHeader.CustomerNameLocal2__c !=null ? mRequestHeader.CustomerNameLocal2__c: '';
            addressGenModel.CustomerName3 = ''; //No field in SF yet.
            addressGenModel.CustomerName4 = '';//No field in SF yet.

            addressGenModel.CityStateText =  mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '';//mRequestHeader.CityStateLocal__r.Description__c !=null ? mRequestHeader.CityStateLocal__r.Description__c: '';  //CityStateLocalText__c
            
            addressGenModel.SubDistrictText = mRequestHeader.SubDistrictLocalText__c !=null ? mRequestHeader.SubDistrictLocalText__c: ''; //ไม่ใช้ตอน Integration
            addressGenModel.DistrictText = mRequestHeader.DistrictLocalText__c != null?  mRequestHeader.DistrictLocalText__c: ''; ////SubDistrictLocalText__c + DistrictLocalText__c
            addressGenModel.PostalCodeText =  mRequestHeader.PostalCodeLocalText__c !=null ? mRequestHeader.PostalCodeLocalText__c: '';
 
            addressGenModel.BuildingCode = mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '';
            addressGenModel.Room = mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '';
            addressGenModel.Floor = mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '';

            addressGenModel.Street = mRequestHeader.StreetLocal__c !=null ? mRequestHeader.StreetLocal__c: '';
            addressGenModel.Houseno = mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '';
            addressGenModel.Street2 = mRequestHeader.Street2Local__c !=null ? mRequestHeader.Street2Local__c: '';
            addressGenModel.Street3 = mRequestHeader.Street3Local__c !=null ? mRequestHeader.Street3Local__c: '';
            addressGenModel.Street4 = mRequestHeader.Street4Local__c !=null ? mRequestHeader.Street4Local__c: '';
            addressGenModel.Street5 = mRequestHeader.Street5Local__c !=null ? mRequestHeader.Street5Local__c: '';
            addressGenModel.Country = mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '';//Country__r.code__c
            addressGenModel.Language = mRequestHeader.Language__c !=null ? mRequestHeader.Language__c: '';//ดู value ภาษาไทย = 2 //อังกฤษ = E
            addressGenModel.Region = mRequestHeader.RegionSAP__c !=null ? mRequestHeader.RegionSAP__c: '';//lookup depend on Country ขอ Data จาก sap
            addressGenModel.TimeZone = mRequestHeader.TimeZone__c !=null ? mRequestHeader.TimeZone__c: '';
            addressGenModel.SearchTerm = mRequestHeader.CustomerSearchTermLocal__c !=null ? mRequestHeader.CustomerSearchTermLocal__c: '';
            addressGenModel.SearchTermEN = mRequestHeader.CustomerSearchTermEN__c !=null ? mRequestHeader.CustomerSearchTermEN__c: '';
            
            //addressGenModel.TransportationZone = '';

            addressGenModel.PhoneCountryCode = mRequestHeader.PhoneCountryCode__c !=null ? mRequestHeader.PhoneCountryCode__c: '';
            addressGenModel.Phone = mRequestHeader.Phone__c !=null ? mRequestHeader.Phone__c: '';
            addressGenModel.PhoneExtension = mRequestHeader.PhoneExtension__c !=null ? mRequestHeader.PhoneExtension__c: '';
            addressGenModel.FaxCountryCode = mRequestHeader.FaxCountryCode__c !=null ? mRequestHeader.FaxCountryCode__c: '';
            addressGenModel.Fax = mRequestHeader.Fax__c  !=null ? mRequestHeader.Fax__c: '';
            addressGenModel.FaxExtension = mRequestHeader.FaxExtension__c !=null ? mRequestHeader.FaxExtension__c: '';
            addressGenModel.Email = mRequestHeader.Email__c !=null ? mRequestHeader.Email__c: '';
            addressGenModel.MobileCountryCode = mRequestHeader.MobileCountryCode__c !=null ? mRequestHeader.MobileCountryCode__c: '';
            addressGenModel.MobilePhone = mRequestHeader.MobilePhone__c  !=null ? mRequestHeader.MobilePhone__c: '';
            addressGenModel.Flag ='I';
            addressGenModelList.add(addressGenModel);

            // AddressIntModel addressIntModel.Type a = {I,T}
            List<String> typeListAddressInt = new List<String>{'I','T'};
            for(String typeAddressInt: typeListAddressInt)
            {
                AddressIntModel addressIntModel = new AddressIntModel();
                addressIntModel.Type = typeAddressInt;
                if(typeAddressInt == 'I')
                {
                    addressIntModel.CoName = mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '';
                    addressIntModel.CustomerName1 = mRequestHeader.CustomerNameEN1__c !=null ? mRequestHeader.CustomerNameEN1__c: '';
                    addressIntModel.CustomerName2 = mRequestHeader.CustomerNameEN2__c !=null ? mRequestHeader.CustomerNameEN2__c: '';
                    addressIntModel.CustomerName3 = '';//No field in SF yet.
                    addressIntModel.CustomerName4 = '';//No field in SF yet.
                    addressIntModel.CityStateText = mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '';//TODO ใน google sheet มี 2 fields 2 values ให้เอา value ต่อกันเลยไหมครับ? 
                    addressIntModel.SubDistrictText = mRequestHeader.SubDistrictLocalText__c != null? mRequestHeader.SubDistrictLocalText__c: ''; //TODO ในชีส ไม่มี field map
                    addressIntModel.DistrictText = mRequestHeader.DistrictENText__c != null?  mRequestHeader.DistrictENText__c: ''; //TODO ใน google sheet มี 2 fields 2 values ให้เอา value ต่อกันเลยไหมครับ? 
                    
                    addressIntModel.BuildingCode = mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '';
                    addressIntModel.Room = mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '';
                    addressIntModel.Floor = mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '';
                    
                    addressIntModel.Street = mRequestHeader.StreetEN__c !=null ? mRequestHeader.StreetEN__c: '';
                    addressIntModel.Houseno = mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '';
                    addressIntModel.Street2 = mRequestHeader.Street2EN__c !=null ? mRequestHeader.Street2EN__c: '';
                    addressIntModel.Street3 = mRequestHeader.Street3EN__c !=null ? mRequestHeader.Street3EN__c: '';
                    addressIntModel.Street4 = mRequestHeader.Street4EN__c !=null ? mRequestHeader.Street4EN__c: '';
                    addressIntModel.Street5 = mRequestHeader.Street5EN__c !=null ? mRequestHeader.Street5EN__c: '';
                    addressIntModel.Country = mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '';
                    addressIntModel.SearchTerm = mRequestHeader.CustomerSearchTermLocal__c !=null ? mRequestHeader.CustomerSearchTermLocal__c: '';
                    addressIntModel.SearchTermEN = mRequestHeader.CustomerSearchTermEN__c !=null ? mRequestHeader.CustomerSearchTermEN__c: '';
                }
                else if(typeAddressInt == 'T')
                {
                    addressIntModel.CoName = mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '';
                    addressIntModel.CustomerName1 = mRequestHeader.CustomerNameLocal1__c !=null ? mRequestHeader.CustomerNameLocal1__c: '';
                    addressIntModel.CustomerName2 = mRequestHeader.CustomerNameLocal2__c !=null ? mRequestHeader.CustomerNameLocal2__c: '';
                    addressIntModel.CustomerName3 = '';//No field in SF yet.
                    addressIntModel.CustomerName4 = '';//No field in SF yet.
                    addressIntModel.CityStateText = mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '';//TODO ใน google sheet มี 2 fields 2 values ให้เอา value ต่อกันเลยไหมครับ? 
                    addressIntModel.SubDistrictText = mRequestHeader.SubDistrictLocalText__c != null?  mRequestHeader.SubDistrictLocalText__c: '';
                    addressIntModel.DistrictText = mRequestHeader.DistrictLocalText__c != null?  mRequestHeader.DistrictLocalText__c: ''; //TODO ใน google sheet มี 2 fields 2 values ให้เอา value ต่อกันเลยไหมครับ? 
                    
                    addressIntModel.BuildingCode = mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '';
                    addressIntModel.Room = mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '';
                    addressIntModel.Floor = mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '';
                    
                    addressIntModel.Street = mRequestHeader.StreetLocal__c !=null ? mRequestHeader.StreetLocal__c: '';
                    addressIntModel.Houseno = mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '';
                    addressIntModel.Street2 = mRequestHeader.Street2Local__c !=null ? mRequestHeader.Street2Local__c: '';
                    addressIntModel.Street3 = mRequestHeader.Street3Local__c !=null ? mRequestHeader.Street3Local__c: '';
                    addressIntModel.Street4 = mRequestHeader.Street4Local__c !=null ? mRequestHeader.Street4Local__c: '';
                    addressIntModel.Street5 = mRequestHeader.Street5Local__c !=null ? mRequestHeader.Street5Local__c: '';
                    addressIntModel.Country = mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '';
                    addressIntModel.SearchTerm = mRequestHeader.CustomerSearchTermLocal__c !=null ? mRequestHeader.CustomerSearchTermLocal__c: '';
                    addressIntModel.SearchTermEN = mRequestHeader.CustomerSearchTermEN__c !=null ? mRequestHeader.CustomerSearchTermEN__c: '';
                }
                addressIntModel.Flag ='I';
                addressIntModelList.add(addressIntModel);
            }
            
            // TaxClassificationModel
            

            // SalesDataModel
            SalesDataModel salesDataModel = new SalesDataModel();
            
            salesDataModel.Task = 'I';
            salesDataModel.ShippingConditions = mRequestItem.ShippingConditions__c !=null ? mRequestItem.ShippingConditions__c:''; 
            salesDataModel.AccountAssignmentGroup = mRequestItem.AccountAssignmentGroup__c !=null ? mRequestItem.AccountAssignmentGroup__c: '';
            salesDataModel.Flag = 'I';
            
            salesDataModelList.add(salesDataModel);

        

        subInputModel.centralData = centralDataModelList;
        subInputModel.addressGen = addressGenModelList;
        subInputModel.addressInt = addressIntModelList;
        subInputModel.taxClassification = taxClassificationModelList;
        subInputModel.salesData = salesDataModelList;
        subInputModel.companyCodeView = companyCodeViewModelList;        
        inputModel.input =subInputModel;

        ctrData.input =inputModel;
        return ctrData;
    }
}