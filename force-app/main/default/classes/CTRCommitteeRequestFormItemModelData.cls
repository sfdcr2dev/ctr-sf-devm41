public with sharing class CTRCommitteeRequestFormItemModelData {

    public CTRCommitteeRequestFormItemModelChild input { get; set; }

    public class CTRCommitteeRequestFormItemModelChild {
        public CTRCommitteeRequestFormItemModelSubChild input{ get; set; }
    }
    
    public class CTRCommitteeRequestFormItemModelSubChild {
        public String AccountNumber{ get; set; }
        public String SalesOrganization{ get; set; }
        public String DistributionChannel{ get; set; }
        public String Division{ get; set; }
        public String Id{ get; set; }
        public String GatewayId{ get; set; }

        public String Flag{ get; set; }

        public List<CentralDataModel> CentralData{ get; set; }
        public List<AddressModel> AddressGen{ get; set; }
        public List<AddressModel> AddressInt{ get; set; }
        public List<SalesDataModel> PurchasingView{ get; set; }
        public List<SalesDataModel> SalesData{ get; set; }
        public List<TaxClassificationModel> TaxClassification{ get; set; }
        public List<CompanyCodeViewModel> CompanyCodeView{ get; set; }
        public List<WithHoldingTax> WithHoldingTax{ get; set; }

        // public CentraDatalModel centralData{ get; set; }
        // public AddressGenModel addressGen{ get; set; }
        // public AddressIntModel addressInt{ get; set; }
        // public SalesDataModel salesData{ get; set; }
        // public TaxClassificationModel taxClassification{ get; set; }
        // public CompanyCodeViewModel companyCodeView{ get; set; }
    }

    public class CentralDataModel {
        public String AccountGroup{ get; set; }
        public String Country{ get; set; }
        public String TaxCode1{ get; set; }
        public String TypeofBusiness{ get; set; }
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
        public String PO{ get; set; }
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
        public string TransportationZone{ get; set; }
        //Model changes on 27-11-2023 to use condition on CTR and using Local Variable
        /*public String SearchTermEN{ get; set; }
        public String CustomerNameEN1{ get; set; }
        public String CityStateENText{ get; set; }
        public String DistrictENText{ get; set; }
        public String StreetEN{ get; set; }
        public String Street2EN{ get; set; }
        public String Street3EN{ get; set; }
        public String Street4EN{ get; set; }*/
        public String Location{ get; set; }
        public String PhoneCountryCode{ get; set; }
        public String Phone{ get; set; }
        public String PhoneExtension{ get; set; }
        public String FaxCountryCode{ get; set; }
        public String Fax{ get; set; }
        public String FaxExtension{ get; set; }
        public String Email{ get; set; }        
        public String Flag{ get; set; }
    }

    /*public class AddressIntModel  { 
        public String Type{ get; set; }
        public String CustomerName1{ get; set; }
        public String CustomerName2{ get; set; }
        public String CustomerName3{ get; set; }
        public String CustomerName4{ get; set; }
        public String CityStateText{ get; set; }
        public String SubDistrictText{ get; set; }
        public String DistrictText{ get; set; }
        public String PostalCodeText{ get; set; }
        public String PO{ get; set; }
        public String Street{ get; set; }
        public String Houseno{ get; set; }
        public String Street2{ get; set; }
        public String Street3{ get; set; }
        public String Street4{ get; set; }
        public String Country{ get; set; }
        public String Language{ get; set; }
        public String Region{ get; set; }
        public String TimeZone{ get; set; }
        public String SearchTerm{ get; set; }

        //Model changes on 27-11-2023 to use condition on CTR and using Local Variable
        public String SearchTermEN{ get; set; }
        public String CustomerNameEN1{ get; set; }
        public String CityStateENText{ get; set; }
        public String DistrictENText{ get; set; }
        public String StreetEN{ get; set; }
        public String Street2EN{ get; set; }
        public String Street3EN{ get; set; }
        public String Street4EN{ get; set; }

        public String Location{ get; set; }
        public String PhoneCountryCode{ get; set; }
        public String Phone{ get; set; }
        public String PhoneExtension{ get; set; }
        public String FaxCountryCode{ get; set; }
        public String Fax{ get; set; }
        public String FaxExtension{ get; set; }
        public String Email{ get; set; }
        public String Flag{ get; set; }
    }*/

    public class SalesDataModel{
        public String Incoterms{ get; set; }
        public String Incoterms2{ get; set; }
        // public String Currencies{ get; set; } //! New value because ERROR Case-Sensitive
        public String Currency1{ get; set; } // Mockup field for Test
        public String AccountAssignmentGroup{ get; set; }
        public String TermofPayment{ get; set; }
        public String CustomerPayment{ get; set; }
        public String CreditControlArea{ get; set; }
        public String TaxClassification{ get; set; }
        public String Currencies{ get; set; }

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

        public String PurchasingOrg{ get; set; }

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
        public String CompanyCode{ get; set; }
        public String ReconciliationAccount{ get; set; }
        public String PaymentMethods{ get; set; }
        public String TermofPayment{ get; set; }
        public String PlanningGroup{ get; set; }
        public String CashManagementGroup{ get; set; }
        public String PaymentHistoryRecord{ get; set; }
        
        public String AccountClerk{ get; set; }
        public String ShippingConditions{ get; set; }
        public String CheckDoubleInv{ get; set; }
        public String InvVerify{ get; set; }

        
    }
    public class WithHoldingTax{
        public String Task{ get; set; }
        public String TaxType{ get; set; }
        public String Subject{ get; set; }
        public String TypeOfRecipient{ get; set; }
    }


}