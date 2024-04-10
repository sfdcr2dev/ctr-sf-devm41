public with sharing class CTRSupplierRequestFormItemModelData 
{
    public CTRSupplierRequestFormItemModelChild input { get; set; }
    
    public class CTRSupplierRequestFormItemModelChild
    {
        public CTRSupplierRequestFormItemModelSubChild input{ get; set; }
    } 
    
    public class CTRSupplierRequestFormItemModelSubChild {
        public String AccountNumber{ get; set; }
        public String Id{ get; set; }
        public String GatewayId{ get; set; }
        public String ReferenceId{ get; set; }
        public String Flag{ get; set; }
        
        public List<CentralDataModel> CentralData{ get; set; }
        public List<AddressModel> AddressGen{ get; set; }
        public List<AddressModel> AddressInt{ get; set; }
        public List<SalesDataModel> PurchasingView{ get; set; }
        public List<CompanyCodeViewModel> CompanyCodeView{ get; set; }
        public List<WithHoldingTax> WithHoldingTax{ get; set; }
    }
    
    public class CentralDataModel {
        public String AccountGroup{ get; set; }
        public String TaxCode1{ get; set; }
        public String TaxCode5{ get; set; }
        //public String VATRegNo { get; set; }
        public String GroupKey { get; set; }
        public String TypeofBusiness{ get; set; }
        public String Block{ get; set; }
        public String TradingPartner{ get; set; }
    }
    
    public class AddressModel  { 
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
        
        public String PhoneCountryCode{ get; set; }
        public String Phone{ get; set; }
        public String PhoneExtension{ get; set; }
        public String FaxCountryCode{ get; set; }
        public String Fax{ get; set; }
        public String FaxExtension{ get; set; }
        public String Email{ get; set; }
        public String MobileCountryCode{ get; set; }
        public String MobilePhone{ get; set; }
        public String Flag{ get; set; }
    }
    
    public class SalesDataModel{
        public String PurchasingOrg{ get; set; }
        public String Incoterms{ get; set; }
        public String Incoterms2{ get; set; }
        public String Currencies{ get; set; } 
        public String VendorContact{ get; set; }
        public String VendorPhone{ get; set; }
        public String TermofPayment{ get; set; }
        public String ShippingConditions{ get; set; }
        public String InvoiceVerify{ get; set; }
        public String Block{ get; set; }
        public String AutomaticPurchaseOrder{ get; set; }
        public String Task{ get; set; }
    }
    
    public class CompanyCodeViewModel{
        public String Task{ get; set; }
        public String CompanyCode{ get; set; }
        public String ReconciliationAccount{ get; set; }
        public String PaymentMethod{ get; set; }
        public String TermofPayment{ get; set; }
        public String CashManagementGroup{ get; set; }
        public String AccountClerk{ get; set; }
        public String SortKey{ get; set; }
        public String CheckDoubleInv{ get; set; }
        public String WithHoldingCountry{ get; set; }
        
    }
    public class WithHoldingTax{
        public String Task{ get; set; }
        public String TaxType{ get; set; }
        public String Subject{ get; set; }
        public String TypeOfRecipient{ get; set; }
    }
    
    public static CTRSupplierRequestFormItemModelData SetupJsonForSupplierDataModel (CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mSendType, String mBusinessUnit, String mGatewayId)
    {
        String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRSupplierRequestFormItemModelData ctrData = new CTRSupplierRequestFormItemModelData();
        CTRSupplierRequestFormItemModelChild inputModel = new CTRSupplierRequestFormItemModelChild();
        CTRSupplierRequestFormItemModelSubChild subInputModel = new CTRSupplierRequestFormItemModelSubChild();
        
        List<CentralDataModel> centralDataModelList = new List<CentralDataModel>();
        List<AddressModel> addressGenModelList = new List<AddressModel>();
        List<AddressModel> addressIntModelList = new List<AddressModel>();
        List<CompanyCodeViewModel> companyCodeViewModelList = new List<CompanyCodeViewModel>(); 
        List<WithHoldingTax> WithHoldingTaxList = new List<WithHoldingTax>();
        List<SalesDataModel> PurchasingviewList = new List<SalesDataModel>();
        
        subInputModel.AccountNumber = mRequestItem.Customer__r.SupplierNumber__c !=null ? mRequestItem.Customer__r.SupplierNumber__c: ''; //TODO Null value in google sheet
        subInputModel.Id = mRequestHeader.Customer__c;
        subInputModel.GatewayId =uuid;
        subInputModel.ReferenceId = mRequestItem.Id;
        subInputModel.Flag = 'U';
        
        if(mSendType == 'General')
        {
            // CentralDataModel
            CentralDataModel centralDataModel = new CentralDataModel();
            centralDataModel.AccountGroup = mRequestHeader.AccountGroup__c !=null ? mRequestHeader.AccountGroup__c: '';
            //centralDataModel.VATRegNo = mRequestHeader.VATRegno__c !=null ? mRequestHeader.VATRegno__c: '';
            CentralDataModel.GroupKey = mRequestHeader.GroupKeyAccountKeyofBank__c !=null ? mRequestHeader.GroupKeyAccountKeyofBank__c: '';
            centralDataModel.TaxCode1 = (mRequestHeader.TaxCode1__c !=null && mRequestHeader.TaxCode1__c.length() <= 16) ? mRequestHeader.TaxCode1__c: '';
            centralDataModel.TaxCode5 = mRequestHeader.TaxCode1__c !=null ? mRequestHeader.TaxCode1__c: '';
            //centralDataModel.TypeofBusiness = mRequestHeader.TypeOfBusinessBranch__c !=null ? mRequestHeader.TypeOfBusinessBranch__c: '';
            //centralDataModel.Block = ''; //เพิ่มฟีลด์
            centralDataModel.TradingPartner = mRequestHeader.TradingPartner__c !=null ? mRequestHeader.TradingPartner__r.Code__c: '';
            centralDataModelList.add(centralDataModel);
            
            subInputModel.Flag = 'I';
            // AddressGenModel
            AddressModel addressGenModel = new AddressModel();
            addressGenModel.Type ='I';
            addressGenModel.CoName = mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '';
            addressGenModel.CustomerName1 = mRequestHeader.CustomerNameLocal1__c !=null ? mRequestHeader.CustomerNameLocal1__c: '';
            addressGenModel.CustomerName2 = mRequestHeader.CustomerNameLocal2__c !=null ? mRequestHeader.CustomerNameLocal2__c: '';
            //addressGenModel.CustomerName3 = ''; //No field in SF yet.
            //addressGenModel.CustomerName4 = '';//No field in SF yet.
            addressGenModel.CityStateText =  mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '';//mRequestHeader.CityStateLocal__r.Description__c !=null ? mRequestHeader.CityStateLocal__r.Description__c: '';  //CityStateLocalText__c
            
            addressGenModel.SubDistrictText = mRequestHeader.DistrictLocalText__c != null?  mRequestHeader.DistrictLocalText__c: '';  //TODO ในชีส ไม่มี field map
            addressGenModel.DistrictText = mRequestHeader.DistrictLocalText__c != null?  mRequestHeader.DistrictLocalText__c: ''; 
            addressGenModel.PostalCodeText =  mRequestHeader.PostalCodeLocalText__c !=null ? mRequestHeader.PostalCodeLocalText__c: '';
            
            addressGenModel.BuildingCode = mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '';
            addressGenModel.Room = mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '';
            addressGenModel.Floor = mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '';
            
            addressGenModel.Houseno = mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '';
            addressGenModel.Street = mRequestHeader.StreetLocal__c !=null ? mRequestHeader.StreetLocal__c: '';
            addressGenModel.Street2 = mRequestHeader.Street2Local__c !=null ? mRequestHeader.Street2Local__c: '';
            addressGenModel.Street3 = mRequestHeader.Street3Local__c !=null ? mRequestHeader.Street3Local__c: '';
            addressGenModel.Street4 = mRequestHeader.Street4Local__c !=null ? mRequestHeader.Street4Local__c: '';
            addressGenModel.Street5 = mRequestHeader.Street5Local__c !=null ? mRequestHeader.Street5Local__c: '';
            
            addressGenModel.Country = mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '';//Country__r.code__c
            addressGenModel.Language = mRequestHeader.Language__c !=null ? mRequestHeader.Language__c: '';//ดู value ภาษาไทย = 2 //อังกฤษ = E
            addressGenModel.SearchTerm = mRequestHeader.SupplierSearchTermLocal__c !=null ? mRequestHeader.SupplierSearchTermLocal__c: '';
            addressGenModel.SearchTermEN = mRequestHeader.SupplierSearchTermEN__c !=null ? mRequestHeader.SupplierSearchTermEN__c: '';
            //addressGenModel.TimeZone = mRequestHeader.TimeZone__c !=null ? mRequestHeader.TimeZone__c: '';//ไม่ส่ง
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
            
            List<String> typeListAddressInt = new List<String>{'I','T'};
                for(String typeAddressInt: typeListAddressInt)
            {
                AddressModel addressIntModel = new AddressModel();
                addressIntModel.Type = typeAddressInt;
                if(typeAddressInt == 'I')
                {
                    addressIntModel.CoName = mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '';
                    addressIntModel.CustomerName1 = mRequestHeader.CustomerNameEN1__c !=null ? mRequestHeader.CustomerNameEN1__c: '';
                    addressIntModel.CustomerName2 = mRequestHeader.CustomerNameEN2__c !=null ? mRequestHeader.CustomerNameEN2__c: '';
                    //addressIntModel.CustomerName3 = '';//No field in SF yet.
                    //addressIntModel.CustomerName4 = '';//No field in SF yet.
                    addressIntModel.CityStateText =  mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '';//mRequestHeader.CityStateLocal__r.Description__c !=null ? mRequestHeader.CityStateLocal__r.Description__c: '';  //CityStateLocalText__c
                    
                    addressIntModel.SubDistrictText = mRequestHeader.DistrictENText__c != null?  mRequestHeader.DistrictENText__c: ''; //TODO ในชีส ไม่มี field map
                    addressIntModel.DistrictText = mRequestHeader.DistrictENText__c != null?  mRequestHeader.DistrictENText__c: ''; 
                    addressIntModel.PostalCodeText =  mRequestHeader.PostalCodeLocalText__c !=null ? mRequestHeader.PostalCodeLocalText__c: '';
                    
                    addressIntModel.BuildingCode = mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '';
                    addressIntModel.Room = mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '';
                    addressIntModel.Floor = mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '';
                    
                    addressIntModel.Houseno = mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '';
                    addressIntModel.Street = mRequestHeader.StreetEN__c !=null ? mRequestHeader.StreetEN__c: '';
                    addressIntModel.Street2 = mRequestHeader.Street2EN__c !=null ? mRequestHeader.Street2EN__c: '';
                    addressIntModel.Street3 = mRequestHeader.Street3EN__c !=null ? mRequestHeader.Street3EN__c: '';
                    addressIntModel.Street4 = mRequestHeader.Street4EN__c !=null ? mRequestHeader.Street4EN__c: '';
                    addressIntModel.Street5 = mRequestHeader.Street5EN__c !=null ? mRequestHeader.Street5EN__c: '';
                    
                    addressIntModel.Country = mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '';//Country__r.code__c
                    //addressIntModel.Language = mRequestHeader.Language__c !=null ? mRequestHeader.Language__c: '';//ดู value ภาษาไทย = 2 //อังกฤษ = E
                    addressIntModel.SearchTerm = mRequestHeader.SupplierSearchTermLocal__c !=null ? mRequestHeader.SupplierSearchTermLocal__c: '';
                    addressIntModel.SearchTermEN = mRequestHeader.SupplierSearchTermEN__c !=null ? mRequestHeader.SupplierSearchTermEN__c: '';

                }
                else if(typeAddressInt == 'T')
                {
                    addressIntModel.CoName = mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '';
                    addressIntModel.CustomerName1 = mRequestHeader.CustomerNameLocal1__c !=null ? mRequestHeader.CustomerNameLocal1__c: '';
                    addressIntModel.CustomerName2 = mRequestHeader.CustomerNameLocal2__c !=null ? mRequestHeader.CustomerNameLocal2__c: '';
                    //addressIntModel.CustomerName3 = '';//No field in SF yet.
                    //addressIntModel.CustomerName4 = '';//No field in SF yet.
                    addressIntModel.CityStateText =  mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '';//mRequestHeader.CityStateLocal__r.Description__c !=null ? mRequestHeader.CityStateLocal__r.Description__c: '';  //CityStateLocalText__c
                    
                    addressIntModel.SubDistrictText = mRequestHeader.DistrictENText__c != null?  mRequestHeader.DistrictENText__c: ''; //TODO ในชีส ไม่มี field map
                    addressIntModel.DistrictText = mRequestHeader.DistrictENText__c != null?  mRequestHeader.DistrictENText__c: ''; 
                    addressIntModel.PostalCodeText =  mRequestHeader.PostalCodeLocalText__c !=null ? mRequestHeader.PostalCodeLocalText__c: '';
                    
                    addressIntModel.BuildingCode = mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '';
                    addressIntModel.Room = mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '';
                    addressIntModel.Floor = mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '';
                    
                    addressIntModel.Houseno = mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '';
                    addressIntModel.Street = mRequestHeader.StreetLocal__c !=null ? mRequestHeader.StreetLocal__c: '';
                    addressIntModel.Street2 = mRequestHeader.Street2Local__c !=null ? mRequestHeader.Street2Local__c: '';
                    addressIntModel.Street3 = mRequestHeader.Street3Local__c !=null ? mRequestHeader.Street3Local__c: '';
                    addressIntModel.Street4 = mRequestHeader.Street4Local__c !=null ? mRequestHeader.Street4Local__c: '';
                    addressIntModel.Street5 = mRequestHeader.Street5Local__c !=null ? mRequestHeader.Street5Local__c: '';
                    
                    addressIntModel.Country = mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '';//Country__r.code__c
                    addressIntModel.Language = mRequestHeader.Language__c !=null ? mRequestHeader.Language__c: '';//ดู value ภาษาไทย = 2 //อังกฤษ = E
                    addressIntModel.SearchTerm = mRequestHeader.SupplierSearchTermLocal__c !=null ? mRequestHeader.SupplierSearchTermLocal__c: '';
                    addressIntModel.SearchTermEN = mRequestHeader.SupplierSearchTermEN__c !=null ? mRequestHeader.SupplierSearchTermEN__c: '';
                }
                
                addressIntModel.Flag ='I';
                addressIntModelList.add(addressIntModel);
            }   
        }
        
        // SalesDataModel
        SalesDataModel salesDataModel = new SalesDataModel();
        salesDataModel.Task = 'I'; // New Field update mapping
        salesDataModel.PurchasingOrg = mRequestItem.PurchasingOrganization__c !=null ? mRequestItem.PurchasingOrganization__c: '';
        salesDataModel.Incoterms = mRequestItem.Incoterms__c !=null ? mRequestItem.Incoterms__c: '';
        salesDataModel.Incoterms2 = mRequestItem.Incoterms2__c !=null ? mRequestItem.Incoterms2__c: '';
        salesDataModel.Currencies = mRequestItem.Currency__c !=null ? mRequestItem.Currency__c: '';
        salesDataModel.TermofPayment = mRequestItem.TermOfPayment__r.Code__c !=null ? mRequestItem.TermOfPayment__r.Code__c: '';//require
        salesDataModel.InvoiceVerify = mRequestItem.GRBasedInvVerif__c == true ? 'X':'';
        salesDataModel.VendorContact = mRequestItem.VendorName__c !=null ? mRequestItem.VendorName__c: '';
        salesDataModel.VendorPhone = mRequestItem.VendorPhone__c !=null ? mRequestItem.VendorPhone__c: '';
        salesDataModel.ShippingConditions = mRequestItem.ShippingConditions__c !=null ? mRequestItem.ShippingConditions__c: '';
        //salesDataModel.Block = '';//ไม่ใช้ initial
        //salesDataModel.Flag = 'I';
        PurchasingviewList.add(salesDataModel);
        salesDataModel.AutomaticPurchaseOrder = 'X';
        subInputModel.purchasingView = PurchasingviewList;
        
         if(mBusinessUnit == 'TX')
         {
            // CompanyCodeViewModel
            CompanyCodeViewModel companyCodeViewModel = new CompanyCodeViewModel();
            companyCodeViewModel.Task = 'I';
            companyCodeViewModel.CompanyCode = mRequestItem.CompanyCodeTX__c !=null ? mRequestItem.CompanyCodeTX__c: '';//ใช้ SalesOrg ไปก่อน
            companyCodeViewModel.ReconciliationAccount = mRequestItem.ReconAccount__c !=null ? mRequestItem.ReconAccount__c: '';
            companyCodeViewModel.PaymentMethod = mRequestItem.PaymentMethod__c !=null ? mRequestItem.PaymentMethod__c: '';
            companyCodeViewModel.TermofPayment = mRequestItem.TermOfPayment__r.Code__c !=null ? mRequestItem.TermOfPayment__r.Code__c: '';  //require
            companyCodeViewModel.AccountClerk = mRequestItem.AccigClerk__c !=null ? mRequestItem.AccigClerk__c: '';
            companyCodeViewModel.CashManagementGroup = mRequestItem.CashManagementGroup__c !=null ? mRequestItem.CashManagementGroup__c: '';
            companyCodeViewModel.SortKey = mRequestItem.SortKey__c !=null ? mRequestItem.SortKey__c: '';
            companyCodeViewModel.WithHoldingCountry = (mRequestHeader.Country__r.Code__c == 'TH') !=null ? mRequestHeader.Country__r.Code__c: '';
            companyCodeViewModel.CheckDoubleInv = mRequestItem.Chkdoubleinv__c == true ? 'X':'';
            companyCodeViewModelList.add(companyCodeViewModel);
            
            if(mRequestHeader.Country__r.Code__c == 'TH')
            {
                WithHoldingTax mWithHoldingTaxJ1 = new WithHoldingTax();
                mWithHoldingTaxJ1.Task = 'I';
                mWithHoldingTaxJ1.TaxType ='J1';//Wthttype1__c
                mWithHoldingTaxJ1.Subject ='X';//Liable1__c
                mWithHoldingTaxJ1.TypeOfRecipient = mRequestItem.Recty1__c !=null ? mRequestItem.Recty1__c: '';
                WithHoldingTaxList.add(mWithHoldingTaxJ1);
                                    
                WithHoldingTax mWithHoldingTaxJ2 = new WithHoldingTax();
                mWithHoldingTaxJ2.Task = 'I';
                mWithHoldingTaxJ2.TaxType ='J2';//Wthttype2__c
                mWithHoldingTaxJ2.Subject ='X';//Liable1__c
                mWithHoldingTaxJ2.TypeOfRecipient = mRequestItem.Recty2__c !=null ? mRequestItem.Recty2__c: '';
                WithHoldingTaxList.add(mWithHoldingTaxJ2);
            }

         }
        subInputModel.centralData = centralDataModelList;
        subInputModel.addressGen = addressGenModelList;
        subInputModel.addressInt = addressIntModelList;
        subInputModel.purchasingview = PurchasingviewList;
        subInputModel.companyCodeView = companyCodeViewModelList;
        subInputModel.WithHoldingTax = WithHoldingTaxList;
        inputModel.input = subInputModel;
        
        ctrData.input =inputModel;
        System.debug('ctrData: '+ctrData.input.input.GatewayId);
        return ctrData;
    }
}