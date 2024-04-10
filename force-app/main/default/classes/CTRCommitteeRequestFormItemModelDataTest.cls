@isTest
public class CTRCommitteeRequestFormItemModelDataTest {
    @isTest
    static void testCTRCommitteeRequestFormItemModelData() {
        CTRCommitteeRequestFormItemModelData.CTRCommitteeRequestFormItemModelChild child = new CTRCommitteeRequestFormItemModelData.CTRCommitteeRequestFormItemModelChild();
        CTRCommitteeRequestFormItemModelData.CTRCommitteeRequestFormItemModelSubChild subChild = new CTRCommitteeRequestFormItemModelData.CTRCommitteeRequestFormItemModelSubChild();
        subChild.AccountNumber = 'Test Account Number';
        subChild.SalesOrganization = 'Test Sales Organization';
        subChild.DistributionChannel = 'Test Distribution Channel';
        subChild.Division = 'Test Division';
        subChild.Id = 'Test Id';
        subChild.GatewayId = 'Test Gateway Id';
        subChild.Flag = 'Test Flag';

        CTRCommitteeRequestFormItemModelData.CentralDataModel centralData = new CTRCommitteeRequestFormItemModelData.CentralDataModel();
        centralData.AccountGroup = 'Test Account Group';
        centralData.Country = 'Test Country';
        centralData.TaxCode1 = 'Test Tax Code 1';
        centralData.TypeofBusiness = 'Test Type of Business';

        subChild.CentralData = new List<CTRCommitteeRequestFormItemModelData.CentralDataModel>{centralData};

        CTRCommitteeRequestFormItemModelData.AddressModel address = new CTRCommitteeRequestFormItemModelData.AddressModel();
        
        address.Type = 'Test Type';
        address.CoName = 'Test CoName';
        address.CustomerName1 = 'Test Customer Name 1';
        address.CustomerName2 = 'Test Customer Name 2';
        address.CustomerName3 = 'Test Customer Name 3';
        address.CustomerName4 = 'Test Customer Name 4';
        address.CityStateText = 'Test CityState Text';
        address.SubDistrictText = 'Test SubDistrict Text';
        address.DistrictText = 'Test District Text';
        address.PostalCodeText = 'Test PostalCode Text';
        address.PO = 'Test PO';
        address.BuildingCode = 'Test Building Code';
        address.Room = 'Test Room';
        address.Floor = 'Test Floor';
        address.Street = 'Test Street';
        address.Houseno = 'Test Houseno';
        address.Street2 = 'Test Street2';
        address.Street3 = 'Test Street3';
        address.Street4 = 'Test Street4';
        address.Street5 = 'Test Street5';
        address.Country = 'Test Country';
        address.Language = 'Test Language';
        address.Region = 'Test Region';
        address.TimeZone = 'Test TimeZone';
        address.SearchTerm = 'Test SearchTerm';
        address.TransportationZone = 'Test TransportationZone';
        address.Location = 'Test Location';
        address.PhoneCountryCode = 'Test PhoneCountryCode';
        address.Phone = 'Test Phone';
        address.PhoneExtension = 'Test PhoneExtension';
        address.FaxCountryCode = 'Test FaxCountryCode';
        address.Fax = 'Test Fax';
        address.FaxExtension = 'Test FaxExtension';
        address.Email = 'test@test.com';        
        address.Flag = 'Test Flag';

        subChild.AddressGen = new List<CTRCommitteeRequestFormItemModelData.AddressModel>{address};
        subChild.AddressInt = new List<CTRCommitteeRequestFormItemModelData.AddressModel>{address};

        CTRCommitteeRequestFormItemModelData.SalesDataModel salesData = new CTRCommitteeRequestFormItemModelData.SalesDataModel();
        
        salesData.Incoterms = 'IncotermsA';
        salesData.Incoterms2 = 'IncotermsB';
        salesData.Currency1 = 'USD';
        salesData.AccountAssignmentGroup = 'GroupA';
        salesData.TermofPayment = 'Net 30';
        salesData.CustomerPayment = 'PaymentA';
        salesData.CreditControlArea = 'ControlAreaA';
        salesData.TaxClassification = 'TaxClassA';
        salesData.Currencies = 'CurrencyA';
        salesData.SalesDistrict = 'DistrictA';
        salesData.SalesOffice = 'OfficeA';
        salesData.SalesGroup = 'GroupB';
        salesData.OrderProbability = 'High';
        salesData.ExchRateType = 'TypeA';
        salesData.CustPricingProcedure = 'ProcedureA';
        salesData.CustStatisticsGroup = 'StatisticsA';
        salesData.DeliveryPriority = 'PriorityA';
        salesData.ShippingConditions = 'ConditionsA';
        salesData.DeliveryPlant = 'PlantA';
        salesData.OrderCombination = 'CombinationA';
        salesData.PartialDelivery = 'PartialA';
        salesData.MaxPartialDeliveries = '5';
        salesData.UnderDeliveryTole = '10%';
        salesData.OverDeliveryTole = '5%';
        salesData.Rebate = 'RebateA';
        salesData.PriceDetermin = 'DeterminA';
        salesData.PurchasingOrg = 'OrgA';
        salesData.Flag = 'Active';

        subChild.PurchasingView = new List<CTRCommitteeRequestFormItemModelData.SalesDataModel>{salesData};
        subChild.SalesData = new List<CTRCommitteeRequestFormItemModelData.SalesDataModel>{salesData};

        CTRCommitteeRequestFormItemModelData.TaxClassificationModel taxModel = new CTRCommitteeRequestFormItemModelData.TaxClassificationModel();
        taxModel.Task = 'Some task';
        taxModel.CountryCode = 'US';
        taxModel.TaxCategory = 'Category';
        taxModel.TaxClassification = 'Classification';

        subChild.TaxClassification = new List<CTRCommitteeRequestFormItemModelData.TaxClassificationModel>{taxModel};

        CTRCommitteeRequestFormItemModelData.CompanyCodeViewModel companyModel = new CTRCommitteeRequestFormItemModelData.CompanyCodeViewModel();
        companyModel.Task = 'Another task';
        companyModel.CompanyCode = 'ABC';
        companyModel.ReconciliationAccount = 'Reconciliation';
        companyModel.PaymentMethods = 'Methods';
        companyModel.TermofPayment = 'Terms';
        companyModel.PlanningGroup = 'Planning';
        companyModel.CashManagementGroup = 'Cash Management';
        companyModel.PaymentHistoryRecord = 'Payment History';
        companyModel.AccountClerk = 'Clerk';
        companyModel.ShippingConditions = 'Conditions';
        companyModel.CheckDoubleInv = 'Double Inv';
        companyModel.InvVerify = 'Verify';
        subChild.CompanyCodeView = new List<CTRCommitteeRequestFormItemModelData.CompanyCodeViewModel>{companyModel};

        CTRCommitteeRequestFormItemModelData.WithHoldingTax tax = new CTRCommitteeRequestFormItemModelData.WithHoldingTax();
        tax.Task = 'Some task';
        tax.TaxType = 'TypeA';
        tax.Subject = 'SubjectA';
        tax.TypeOfRecipient = 'RecipientTypeA';
        subChild.WithHoldingTax = new List<CTRCommitteeRequestFormItemModelData.WithHoldingTax>{tax};

        child.input = subChild;
        
        CTRCommitteeRequestFormItemModelData modelData = new CTRCommitteeRequestFormItemModelData();
        modelData.input = child;
    }
}