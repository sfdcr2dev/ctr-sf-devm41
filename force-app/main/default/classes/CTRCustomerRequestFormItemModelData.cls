public with sharing class CTRCustomerRequestFormItemModelData 
{
    public CTRCustomerRequestFormItemModelChild input { get; set; }

    public class CTRCustomerRequestFormItemModelChild
    {
        public CTRCustomerRequestFormItemModelSubChild input{ get; set; }
    } 

    public class CTRCustomerRequestFormItemModelSubChild {
        public String AccountNumber{ get; set; }
        public String CompanyCode{ get; set; }
        public String SalesOrganization{ get; set; }
        public String DistributionChannel{ get; set; }
        public String Division{ get; set; }
        public String Id{ get; set; }
        public String GatewayId{ get; set; }
        public String ReferenceId{ get; set; }
        public String RecordType{ get; set; }
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
        public String Incoterms{ get; set; }
        public String Incoterms2{ get; set; }
        public String Currencies{ get; set; } 

        public String AccountAssignmentGroup{ get; set; }
        public String TermofPayment{ get; set; }
        public String CustomerPayment{ get; set; }
        public String CreditControlArea{ get; set; }
        //public String TaxClassification{ get; set; }

        public String SalesDistrict{ get; set; }
        public String SalesOffice{ get; set; }
        public String SalesGroup{ get; set; }
        public String OrderProbability{ get; set; }
        public String ExchRateType{ get; set; }
        public String CustPricingProcedure{ get; set; }
        public String CustStatisticsGroup{ get; set; }
        public String DeliveryPriority{ get; set; }
        public String ShippingConditions{ get; set; }
        public String DeliveryPlant{ get; set; }
        public String OrderCombination{ get; set; }
        public String PartialDelivery{ get; set; }
        public String MaxPartialDeliveries{ get; set; }
        public String UnderDeliveryTole{ get; set; }
        public String OverDeliveryTole{ get; set; }
        public String Rebate{ get; set; }
        public String PriceDetermin{ get; set; }
        
        //public String Application{ get; set; }
        //public String InterGroup{ get; set; }
        //public String CustomerType{ get; set; }
        //public String CustomerGroup{ get; set; }
        //public String Industry{ get; set; }
        //public String SubIndustry{ get; set; }
        public String Block{ get; set; }
        
        public String PriceGroup{ get; set; }
        //public String RiskCategory{ get; set; }//ไม่มีใน BAPI
        //public String CreditLimitAccount{ get; set; }//ไม่มีใน BAPI

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
        public String TermofPayment{ get; set; }
        public String PlanningGroup{ get; set; }//CashManagementGroup__c
        public String PaymentHistoryRecord{ get; set; }
        //public String AuthorizationGroup{ get; set; }
    }

    public static CTRCustomerRequestFormItemModelData SetupJsonForCustomerDataModel (CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mViewName, String mBusinessUnit, String mGatewayId)
    {
        String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRCustomerRequestFormItemModelData ctrData = new CTRCustomerRequestFormItemModelData();
        CTRCustomerRequestFormItemModelChild inputModel = new CTRCustomerRequestFormItemModelChild();
        CTRCustomerRequestFormItemModelSubChild subInputModel = new CTRCustomerRequestFormItemModelSubChild();
        
        List<CentralDataModel> centralDataModelList = new List<CentralDataModel>();
        List<AddressModel> addressGenModelList = new List<AddressModel>();
        List<AddressIntModel> addressIntModelList = new List<AddressIntModel>();
        List<SalesDataModel> salesDataModelList = new List<SalesDataModel>();
        List<TaxClassificationModel> taxClassificationModelList = new List<TaxClassificationModel>();
        List<CompanyCodeViewModel> companyCodeViewModelList = new List<CompanyCodeViewModel>();
        
        subInputModel.AccountNumber = mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: ''; //TODO Null value in google sheet
        subInputModel.SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
        subInputModel.DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
        subInputModel.Division = mRequestItem.Division__c !=null ? mRequestItem.Division__c: '';
        subInputModel.Id = mRequestHeader.Customer__c;
        subInputModel.GatewayId = uuid;
        subInputModel.ReferenceId = mRequestItem.Id;
        subInputModel.RecordType = 'SoldTo';
        subInputModel.Flag = 'U';

        if(mViewName == 'General')
        {
            if(mRequestItem.RecordType.DeveloperName.contains('Initial'))
            {
                subInputModel.Flag = 'I';
                subInputModel.SalesOrganization = '';
                subInputModel.DistributionChannel = '';
                subInputModel.Division = '';
            }
            // CentralDataModel
            CentralDataModel centralDataModel = new CentralDataModel();
            centralDataModel.AccountGroup = mRequestHeader.AccountGroup__c !=null ? mRequestHeader.AccountGroup__c: '';
            centralDataModel.Country = '';// mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: ''; //Country__c Map แล้ว Error
            centralDataModel.TaxCode1 = (mRequestHeader.TaxCode1__c !=null && mRequestHeader.TaxCode1__c.length() <= 16) ? mRequestHeader.TaxCode1__c: '';
            centralDataModel.TaxCode5 = mRequestHeader.TaxCode1__c !=null ? mRequestHeader.TaxCode1__c: '';
            centralDataModel.TypeofBusiness = mRequestHeader.TypeOfBusinessBranch__c !=null ? mRequestHeader.TypeOfBusinessBranch__c: '';//'00001';
            centralDataModel.Block = '';
            centralDataModel.TradingPartner = mRequestHeader.TradingPartner__r.Code__c !=null ? mRequestHeader.TradingPartner__r.Code__c: '';
            centralDataModel.Industry = mRequestHeader.Industry__c !=null ? mRequestHeader.Industry__c: '';//'NP000';
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
            
            //addressGenModel.SubDistrictText = mRequestHeader.SubDistrictLocalText__c !=null ? mRequestHeader.SubDistrictLocalText__c: ''; //ไม่ใช้ตอน Integration
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
            
            addressGenModel.TransportationZone = mRequestHeader.TransportationZone__r.Code__c !=null ? mRequestHeader.TransportationZone__r.Code__c: '';//'';	

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
                    //addressIntModel.SubDistrictText = mRequestHeader.SubDistrictLocalText__c != null? mRequestHeader.SubDistrictLocalText__c: ''; //TODO ในชีส ไม่มี field map
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
                    //addressIntModel.SubDistrictText = mRequestHeader.SubDistrictLocalText__c != null?  mRequestHeader.SubDistrictLocalText__c: '';
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
            TaxClassificationModel taxClassificationModel = new TaxClassificationModel();
            taxClassificationModel.Task = 'I';
            taxClassificationModel.CountryCode = 'TH';//CountryCode ใส่ TH เสมอ
            taxClassificationModel.TaxCategory = 'MWST';//ใช้ MWST เสมอ
            taxClassificationModel.TaxClassification = mRequestHeader.TaxClassification__c !=null ? mRequestHeader.TaxClassification__c: '';//ส่ง0,1 : domestic 1 , inter 0
            taxClassificationModelList.add(taxClassificationModel);
        }
        else if(mViewName == 'Sale')
        {
            // SalesDataModel
            SalesDataModel salesDataModel = new SalesDataModel();
            
            salesDataModel.Task = 'I';
            salesDataModel.Incoterms = mRequestItem.Incoterms__c !=null ? mRequestItem.Incoterms__c: '';
            salesDataModel.Incoterms2 = mRequestItem.Incoterms2__c !=null ? mRequestItem.Incoterms2__c: '-';//header ใช้ Incoterms2Port__c ลบออก//ใส่ขีดให้
            salesDataModel.Currencies = mRequestItem.Currency__c !=null ? mRequestItem.Currency__c: ''; 
            salesDataModel.AccountAssignmentGroup = mRequestItem.AccountAssignmentGroup__c !=null ? mRequestItem.AccountAssignmentGroup__c: '';
            salesDataModel.TermofPayment = mRequestItem.TermofPayment__r.Code__c !=null ? mRequestItem.TermofPayment__r.Code__c: ''; //! value เป็น lookup ห้ามเป็นค่า '' ,เราส่งค่า nall ออกไปฝั่ง SAP เขาโยน Error กลับมา
            salesDataModel.CustomerPayment = mRequestItem.PaymentGuaranteeProcedure__c !=null ? mRequestItem.PaymentGuaranteeProcedure__c: '';//Payment Guarantee Procedure
            
            salesDataModel.CreditControlArea = mRequestItem.CreditControlArea__c !=null ? mRequestItem.CreditControlArea__c: '';
            if(mBusinessUnit == 'TOP')
            {
                salesDataModel.PriceGroup = mRequestItem.PriceGroup__c !=null ? mRequestItem.PriceGroup__c:'';
                salesDataModel.MaxPartialDeliveries = mRequestItem.MaxPartialDeliveries__c !=null ? String.valueOf(mRequestItem.MaxPartialDeliveries__c):'0';// String.valueOf(mRequestItem.MaxPartialDeliveries__c);//ต้องลบออก
                salesDataModel.UnderDeliveryTole = mRequestItem.UnderdeliveryTolerance__c !=null ? String.valueOf(mRequestItem.UnderdeliveryTolerance__c):'0';//String.valueOf(mRequestItem.UnderdeliveryTolerance__c);//ต้องลบออก
                salesDataModel.OverDeliveryTole =  mRequestItem.OverdeliveryTolerance__c !=null ? String.valueOf(mRequestItem.OverdeliveryTolerance__c):'0'; //String.valueOf(mRequestItem.OverdeliveryTolerance__c);//ต้องลบออก
            }
            if(mBusinessUnit == 'TX')
            {
                salesDataModel.SalesDistrict = mRequestItem.SalesDistrict__c !=null ? mRequestItem.SalesDistrict__c:'';
                salesDataModel.SalesOffice = mRequestItem.SalesOffice__c !=null ? mRequestItem.SalesOffice__c:'';
                salesDataModel.SalesGroup = mRequestItem.SalesGroup__c !=null ? mRequestItem.SalesGroup__c:'';
                salesDataModel.OrderProbability = String.valueOf(mRequestItem.OrderProbability__c);
                salesDataModel.ExchRateType = mRequestItem.ExchangeRateType__c !=null ? mRequestItem.ExchangeRateType__c:'';
                salesDataModel.CustPricingProcedure = String.valueOf(mRequestItem.CustPriceProc__c) !=null ? String.valueOf(mRequestItem.CustPriceProc__c):'';
                salesDataModel.CustStatisticsGroup = String.valueOf(mRequestItem.CustStatGroup__c);
                salesDataModel.DeliveryPriority = mRequestItem.DeliveryPriority__c !=null ? mRequestItem.DeliveryPriority__c:'';
                salesDataModel.ShippingConditions = mRequestItem.ShippingConditions__c !=null ? mRequestItem.ShippingConditions__c:'';
                salesDataModel.DeliveryPlant = mRequestItem.DeliveryPlant__c !=null ? mRequestItem.DeliveryPlant__c:'';
                salesDataModel.OrderCombination = mRequestItem.OrderCombination__c == true ? 'X':'';//String.valueOf(mRequestItem.OrderCombination__c);
                salesDataModel.PartialDelivery = mRequestItem.PartialDeliveriesperitem__c !=null ? mRequestItem.PartialDeliveriesperitem__c:'';
                salesDataModel.MaxPartialDeliveries = String.valueOf(mRequestItem.MaxPartialDeliveries__c);
                salesDataModel.UnderDeliveryTole =  String.valueOf(mRequestItem.UnderdeliveryTolerance__c);
                salesDataModel.OverDeliveryTole =  String.valueOf(mRequestItem.OverdeliveryTolerance__c);
                salesDataModel.Rebate = mRequestItem.Rebate__c == true ? 'X':'';//เช็คว่า field ไหน
                salesDataModel.PriceDetermin = mRequestItem.IsPriceDetermin__c == true ? 'X':'';
            }
            salesDataModel.Block = ''; 
            salesDataModel.Flag = 'I';
            salesDataModelList.add(salesDataModel);
            
            

            if(mBusinessUnit == 'TX')
            {
                subInputModel.CompanyCode = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
                // CompanyCodeViewModel
                CompanyCodeViewModel companyCodeViewModel = new CompanyCodeViewModel();
                companyCodeViewModel.Task = 'I';
                companyCodeViewModel.SortKey = mRequestItem.SortKey__c !=null ? mRequestItem.SortKey__c: '';
                companyCodeViewModel.ReconciliationAccount = mRequestItem.ReconAccount__c !=null ? mRequestItem.ReconAccount__c: '';
                //companyCodeViewModel.PaymentMethods = ''; //TODO ในชีส ไม่มี field map
                companyCodeViewModel.TermofPayment = mRequestItem.TermofPayment__r.Code__c !=null ? mRequestItem.TermofPayment__r.Code__c: '';
                companyCodeViewModel.PlanningGroup = mRequestItem.CashManagementGroup__c !=null ? mRequestItem.CashManagementGroup__c: '';
                companyCodeViewModel.PaymentHistoryRecord = mRequestItem.PaymentHistoryRecord__c == true ? 'X':'';
                //companyCodeViewModel.AuthorizationGroup = mRequestItem.Authorization__c !=null ? mRequestItem.Authorization__c: '';
                companyCodeViewModelList.add(companyCodeViewModel);
            }
        }

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