public with sharing class CTRRequestItemIntegrationController 
{
    public class mapLv1
    {
        mapLv2 input{get; set;}
    }

    public class mapLv2
    {
        Map<String,Object> input{get; set;}
    }

    // public static void test()
    // {
    //     String uuid = Uuid.randomUUID();
    //     mapLv1 ctrData = new mapLv1();
    //     mapLv2 inputModel = new mapLv2();
    //     Map<String,Object> subInputModel = new Map<String,Object>();

    //     List<Map<String,String>> centralDataModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> addressGenModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> addressIntModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> salesDataModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> taxClassificationModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> companyCodeViewModelList = new List<Map<String,String>>();

    //     //input data
    //     subInputModel.put('AccountNumber', '');
 

    //     Map<String,String> centralDataModel = new Map<String,String>();
    //     Map<String,String> addressGenModel = new Map<String,String>();
    //     Map<String,String> addressIntModel = new Map<String,String>();
    //     Map<String,String> salesDataModel = new Map<String,String>();
    //     Map<String,String> taxClassificationModel = new Map<String,String>();
    //     Map<String,String> companyCodeViewModel = new Map<String,String>();
        
        
    //     centralDataModel.put('CustomerType', 'M0');
    //     centralDataModelList.add(centralDataModel);
        
    //     addressGenModel.put('Flag','I');
    //     addressGenModelList.add(addressGenModel);
        
    //     addressIntModel.put('Flag','I');
    //     addressIntModelList.add(addressIntModel);
        
    //     taxClassificationModel.put('TaxClassification', '');//ส่ง0,1 : domestic 1 , inter 0
    //         taxClassificationModelList.add(taxClassificationModel);
        
    //     salesDataModel.put('Flag', 'I');
    //         salesDataModelList.add(salesDataModel);
        
    //     companyCodeViewModel.put('AuthorizationGroup', '');
    //             companyCodeViewModelList.add(companyCodeViewModel);
        
    //     subInputModel.put('centralData', centralDataModelList);
    //     subInputModel.put('addressGen', addressGenModelList);
    //     subInputModel.put('addressInt', addressIntModelList);
    //     subInputModel.put('taxClassification', taxClassificationModelList);
    //     subInputModel.put('salesData', salesDataModelList);
    //     subInputModel.put('companyCodeView', companyCodeViewModelList);
        
                
    //     inputModel.input = subInputModel;
    //     ctrData.input = inputModel;
    //     String str = JSON.serialize(ctrData);
    //     system.debug('json:'+str);
    // }

    public static void SetupJsonForCTRDataModel (CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, 
                                                     String mSendProcess, String mBusinessUnit, String mGatewayId)
    {
        String mRecordTypeName = mRequestItem.RecordType.DeveloperName;
        String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        String mMainFlag = 'U';
        String SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
        String DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
        String Division = mRequestItem.Division__c !=null ? mRequestItem.Division__c: '';


        mapLv1 ctrData = new mapLv1();
        mapLv2 inputModel = new mapLv2();
        Map<String,Object> subInputModel = new Map<String,Object>();

        List<Map<String,String>> centralDataModelList = new List<Map<String,String>>();
        List<Map<String,String>> addressGenModelList = new List<Map<String,String>>();
        List<Map<String,String>> addressIntModelList = new List<Map<String,String>>();
        List<Map<String,String>> salesDataModelList = new List<Map<String,String>>();
        List<Map<String,String>> taxClassificationModelList = new List<Map<String,String>>();
        List<Map<String,String>> companyCodeViewModelList = new List<Map<String,String>>();
        List<Map<String,String>> withHoldingTaxViewModelList = new List<Map<String,String>>();

        Map<String,String> withHoldingTax1ViewModel = new Map<String,String>();
        Map<String,String> withHoldingTax2ViewModel = new Map<String,String>();

        Map<String,String> centralDataModel = new Map<String,String>();
        Map<String,String> addressGenModel = new Map<String,String>();
       
        Map<String,String> salesDataModel = new Map<String,String>();
        Map<String,String> taxClassificationModel = new Map<String,String>();
        Map<String,String> companyCodeViewModel = new Map<String,String>();

        //Central Data
        centralDataModel.put('AccountGroup', (mRequestHeader.AccountGroup__c) !=null ? mRequestHeader.AccountGroup__c: '');
        centralDataModel.put('Country', '');
        centralDataModel.put('TaxCode1', (mRequestHeader.TaxCode1__c !=null && mRequestHeader.TaxCode1__c.length() <= 16) ? mRequestHeader.TaxCode1__c: '');
        centralDataModel.put('TaxCode5', mRequestHeader.TaxCode1__c !=null ? mRequestHeader.TaxCode1__c: '');

        centralDataModel.put('TypeofBusiness', '00001');
        centralDataModel.put('Block', '');
        centralDataModel.put('TradingPartner',mRequestHeader.TradingPartner__r.Code__c !=null ? mRequestHeader.TradingPartner__r.Code__c: '');
        centralDataModel.put('Industry', 'NP000');
        centralDataModel.put('CustomerType', 'M0');
        centralDataModelList.add(centralDataModel);

        if(mSendProcess == 'General')
        {
            if(mRecordTypeName.contains('Initial'))
            {
                mMainFlag = 'I';
                SalesOrganization = '';
                DistributionChannel = '';
                Division = '';
            }
            
            //Address Gen
            addressGenModel.put('Type','I');
            addressGenModel.put('CoName',mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '');
            addressGenModel.put('CustomerName1',mRequestHeader.CustomerNameLocal1__c !=null ? mRequestHeader.CustomerNameLocal1__c: '');
            addressGenModel.put('CustomerName2',mRequestHeader.CustomerNameLocal2__c !=null ? mRequestHeader.CustomerNameLocal2__c: '');
            addressGenModel.put('CustomerName3',''); //No field in SF yet.
            addressGenModel.put('CustomerName4',''); //No field in SF yet.
            addressGenModel.put('CityStateText',mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: ''); 
            //addressGenModel.put('SubDistrictText',mRequestHeader.SubDistrictLocalText__c !=null ? mRequestHeader.SubDistrictLocalText__c: ''); //ไม่ใช้ตอน Integration
            addressGenModel.put('DistrictText',mRequestHeader.DistrictLocalText__c != null?  mRequestHeader.DistrictLocalText__c: '');
            addressGenModel.put('PostalCodeText',mRequestHeader.PostalCodeLocalText__c !=null ? mRequestHeader.PostalCodeLocalText__c: '');
            addressGenModel.put('BuildingCode',mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '');
            addressGenModel.put('Room',mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '');
            addressGenModel.put('Floor',mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '');
            addressGenModel.put('Street',mRequestHeader.StreetLocal__c !=null ? mRequestHeader.StreetLocal__c: '');
            addressGenModel.put('Houseno',mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '');
            addressGenModel.put('Street2',mRequestHeader.Street2Local__c !=null ? mRequestHeader.Street2Local__c: '');
            addressGenModel.put('Street3',mRequestHeader.Street3Local__c !=null ? mRequestHeader.Street3Local__c: '');
            addressGenModel.put('Street4',mRequestHeader.Street4Local__c !=null ? mRequestHeader.Street4Local__c: '');
            addressGenModel.put('Street5',mRequestHeader.Street5Local__c !=null ? mRequestHeader.Street5Local__c: '');
            addressGenModel.put('Country',mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '');
            addressGenModel.put('Language',mRequestHeader.Language__c !=null ? mRequestHeader.Language__c: '');
            addressGenModel.put('Region',mRequestHeader.RegionSAP__c !=null ? mRequestHeader.RegionSAP__c: '');
            addressGenModel.put('TimeZone',mRequestHeader.TimeZone__c !=null ? mRequestHeader.TimeZone__c: '');
            addressGenModel.put('SearchTerm',mRequestHeader.CustomerSearchTermLocal__c !=null ? mRequestHeader.CustomerSearchTermLocal__c: '');
            addressGenModel.put('SearchTermEN',mRequestHeader.CustomerSearchTermEN__c !=null ? mRequestHeader.CustomerSearchTermEN__c: '');
            addressGenModel.put('TransportationZone','');
            addressGenModel.put('PhoneCountryCode',mRequestHeader.PhoneCountryCode__c !=null ? mRequestHeader.PhoneCountryCode__c: '');
            addressGenModel.put('Phone',mRequestHeader.Phone__c !=null ? mRequestHeader.Phone__c: '');
            addressGenModel.put('PhoneExtension',mRequestHeader.PhoneExtension__c !=null ? mRequestHeader.PhoneExtension__c: '');
            addressGenModel.put('FaxCountryCode',mRequestHeader.FaxCountryCode__c !=null ? mRequestHeader.FaxCountryCode__c: '');
            addressGenModel.put('Fax',mRequestHeader.Fax__c  !=null ? mRequestHeader.Fax__c: '');
            addressGenModel.put('FaxExtension',mRequestHeader.FaxExtension__c !=null ? mRequestHeader.FaxExtension__c: '');
            addressGenModel.put('Email',mRequestHeader.Email__c !=null ? mRequestHeader.Email__c: '');
            addressGenModel.put('MobileCountryCode',mRequestHeader.MobileCountryCode__c !=null ? mRequestHeader.MobileCountryCode__c: '');
            addressGenModel.put('MobilePhone',mRequestHeader.MobilePhone__c  !=null ? mRequestHeader.MobilePhone__c: '');
            addressGenModel.put('Flag','I');
            addressGenModelList.add(addressGenModel);

            //Address Int
            List<String> typeListAddressInt = new List<String>{'I','T'};
            for(String typeAddressInt: typeListAddressInt)
            {
                Map<String,String> addressIntModel = new Map<String,String>();
                addressIntModel.put('Type','I');
                if(typeAddressInt == 'I')
                {
                    addressIntModel.put('CoName',mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '');
                    addressIntModel.put('CustomerName1',mRequestHeader.CustomerNameEN1__c !=null ? mRequestHeader.CustomerNameEN1__c: '');
                    addressIntModel.put('CustomerName2',mRequestHeader.CustomerNameEN2__c !=null ? mRequestHeader.CustomerNameEN2__c: '');
                    addressIntModel.put('CustomerName3','');//No field in SF yet.
                    addressIntModel.put('CustomerName4','');//No field in SF yet.
                    addressIntModel.put('CityStateText',mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '');
                    //addressIntModel.put('SubDistrictText',mRequestHeader.SubDistrictLocalText__c != null? mRequestHeader.SubDistrictLocalText__c: '');//TODO ในชีส ไม่มี field map
                    addressIntModel.put('DistrictText',mRequestHeader.DistrictENText__c != null?  mRequestHeader.DistrictENText__c: ''); //TODO ใน google sheet มี 2 fields 2 values ให้เอา value ต่อกันเลยไหมครับ?
                    addressIntModel.put('BuildingCode',mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '');
                    addressIntModel.put('Room',mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '');
                    addressIntModel.put('Floor',mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '');
                    addressIntModel.put('Street',mRequestHeader.StreetEN__c !=null ? mRequestHeader.StreetEN__c: '');
                    addressIntModel.put('Houseno',mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '');
                    addressIntModel.put('Street2',mRequestHeader.Street2EN__c !=null ? mRequestHeader.Street2EN__c: '');
                    addressIntModel.put('Street3',mRequestHeader.Street3EN__c !=null ? mRequestHeader.Street3EN__c: '');
                    addressIntModel.put('Street4',mRequestHeader.Street4EN__c !=null ? mRequestHeader.Street4EN__c: '');
                    addressIntModel.put('Street5',mRequestHeader.Street5EN__c !=null ? mRequestHeader.Street5EN__c: '');
                    addressIntModel.put('Country',mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '');
                    addressIntModel.put('SearchTerm',mRequestHeader.CustomerSearchTermLocal__c !=null ? mRequestHeader.CustomerSearchTermLocal__c: '');
                    addressIntModel.put('SearchTermEN',mRequestHeader.CustomerSearchTermEN__c !=null ? mRequestHeader.CustomerSearchTermEN__c: '');
                }
                else if(typeAddressInt == 'T')
                {
                    addressIntModel.put('CoName',mRequestHeader.CoName__c !=null ? mRequestHeader.CoName__c: '');
                    addressIntModel.put('CustomerName1',mRequestHeader.CustomerNameLocal1__c !=null ? mRequestHeader.CustomerNameLocal1__c: '');
                    addressIntModel.put('CustomerName2',mRequestHeader.CustomerNameLocal2__c !=null ? mRequestHeader.CustomerNameLocal2__c: '');
                    addressIntModel.put('CustomerName3','');//No field in SF yet.
                    addressIntModel.put('CustomerName4','');//No field in SF yet.
                    addressIntModel.put('CityStateText',mRequestHeader.CityStateLocal__r.Description__c != null?  mRequestHeader.CityStateLocal__r.Description__c: '');//TODO ใน google sheet มี 2 fields 2 values ให้เอา value ต่อกันเลยไหมครับ?
                    //addressIntModel.put('SubDistrictText',mRequestHeader.SubDistrictLocalText__c != null?  mRequestHeader.SubDistrictLocalText__c: '');//TODO ในชีส ไม่มี field map
                    addressIntModel.put('DistrictText',mRequestHeader.DistrictLocalText__c != null?  mRequestHeader.DistrictLocalText__c: ''); //TODO ใน google sheet มี 2 fields 2 values ให้เอา value ต่อกันเลยไหมครับ?
                    addressIntModel.put('BuildingCode',mRequestHeader.BuildingCodeLocal__c !=null ? mRequestHeader.BuildingCodeLocal__c: '');
                    addressIntModel.put('Room',mRequestHeader.RoomLocal__c !=null ? mRequestHeader.RoomLocal__c: '');
                    addressIntModel.put('Floor',mRequestHeader.FloorLocal__c !=null ? mRequestHeader.FloorLocal__c: '');
                    addressIntModel.put('Street',mRequestHeader.StreetLocal__c !=null ? mRequestHeader.StreetLocal__c: '');
                    addressIntModel.put('Houseno',mRequestHeader.HousenoLocal__c !=null ? mRequestHeader.HousenoLocal__c: '');
                    addressIntModel.put('Street2',mRequestHeader.Street2Local__c !=null ? mRequestHeader.Street2Local__c: '');
                    addressIntModel.put('Street3',mRequestHeader.Street3Local__c !=null ? mRequestHeader.Street3Local__c: '');
                    addressIntModel.put('Street4',mRequestHeader.Street4Local__c !=null ? mRequestHeader.Street4Local__c: '');
                    addressIntModel.put('Street5',mRequestHeader.Street5Local__c !=null ? mRequestHeader.Street5Local__c: '');
                    addressIntModel.put('Country',mRequestHeader.Country__r.Code__c !=null ? mRequestHeader.Country__r.Code__c: '');
                    addressIntModel.put('SearchTerm',mRequestHeader.CustomerSearchTermLocal__c !=null ? mRequestHeader.CustomerSearchTermLocal__c: '');
                    addressIntModel.put('SearchTermEN',mRequestHeader.CustomerSearchTermEN__c !=null ? mRequestHeader.CustomerSearchTermEN__c: '');
                }
                addressIntModel.put('Flag','I');
                addressIntModelList.add(addressIntModel);
            }

            // TaxClassificationModel
            taxClassificationModel.put('Task', 'I');
            taxClassificationModel.put('CountryCode', 'TH');
            taxClassificationModel.put('TaxCategory', 'MWST');
            taxClassificationModel.put('TaxClassification', mRequestHeader.TaxClassification__c !=null ? mRequestHeader.TaxClassification__c: '');//ส่ง0,1 : domestic 1 , inter 0
            taxClassificationModelList.add(taxClassificationModel);
        }

        else if(mSendProcess == 'Sale')
        {
            salesDataModel.put('Task', 'I');
            salesDataModel.put('Flag', 'I');
            salesDataModel.put('Incoterms', mRequestItem.Incoterms__c !=null ? mRequestItem.Incoterms__c: '');
            salesDataModel.put('Incoterms2', mRequestItem.Incoterms2__c !=null ? mRequestItem.Incoterms2__c: '-'); //header ใช้ Incoterms2Port__c ลบออก//ใส่ขีดให้
            salesDataModel.put('Currencies', mRequestItem.Currency__c !=null ? mRequestItem.Currency__c: '');
            salesDataModel.put('TermofPayment', mRequestItem.TermofPayment__r.Code__c !=null ? mRequestItem.TermofPayment__r.Code__c: '');
            salesDataModel.put('ShippingConditions', mRequestItem.ShippingConditions__c !=null ? mRequestItem.ShippingConditions__c:'');

            if(mRecordTypeName.contains('Customer') || mRecordTypeName.contains('ShipTo'))
            {
                // SalesDataModel
                salesDataModel.put('AccountAssignmentGroup', mRequestItem.AccountAssignmentGroup__c !=null ? mRequestItem.AccountAssignmentGroup__c: '');
                salesDataModel.put('CustomerPayment', mRequestItem.PaymentGuaranteeProcedure__c !=null ? mRequestItem.PaymentGuaranteeProcedure__c: '');
                salesDataModel.put('CreditControlArea', mRequestItem.CreditControlArea__c !=null ? mRequestItem.CreditControlArea__c: '');
                salesDataModel.put('SalesDistrict', mRequestItem.SalesDistrict__c !=null ? mRequestItem.SalesDistrict__c:'');
                salesDataModel.put('SalesOffice', mRequestItem.SalesOffice__c !=null ? mRequestItem.SalesOffice__c:'');
                salesDataModel.put('SalesGroup', mRequestItem.SalesGroup__c !=null ? mRequestItem.SalesGroup__c:'');
                salesDataModel.put('OrderProbability', String.valueOf(mRequestItem.OrderProbability__c));
                salesDataModel.put('ExchRateType', mRequestItem.ExchangeRateType__c !=null ? mRequestItem.ExchangeRateType__c:'');
                salesDataModel.put('CustPricingProcedure', String.valueOf(mRequestItem.CustPriceProc__c) !=null ? String.valueOf(mRequestItem.CustPriceProc__c):'');
                salesDataModel.put('CustStatisticsGroup', String.valueOf(mRequestItem.CustStatGroup__c));
                salesDataModel.put('DeliveryPriority', mRequestItem.DeliveryPriority__c !=null ? mRequestItem.DeliveryPriority__c:'');
                salesDataModel.put('DeliveryPlant', mRequestItem.DeliveryPlant__c !=null ? mRequestItem.DeliveryPlant__c:'');
                salesDataModel.put('OrderCombination', mRequestItem.OrderCombination__c == true ? 'X':''); //String.valueOf(mRequestItem.OrderCombination__c);
                salesDataModel.put('PartialDelivery', mRequestItem.PartialDeliveriesperitem__c !=null ? mRequestItem.PartialDeliveriesperitem__c:'');
                salesDataModel.put('MaxPartialDeliveries', String.valueOf(mRequestItem.MaxPartialDeliveries__c));
                salesDataModel.put('UnderDeliveryTole', String.valueOf(mRequestItem.UnderdeliveryTolerance__c));
                salesDataModel.put('OverDeliveryTole', String.valueOf(mRequestItem.OverdeliveryTolerance__c));
                salesDataModel.put('Rebate', mRequestItem.Rebate__c == true ? 'X':'');
                salesDataModel.put('PriceDetermin', mRequestItem.IsPriceDetermin__c == true ? 'X':'');
                salesDataModel.put('PriceGroup', mRequestItem.PriceGroup__c !=null ? mRequestItem.PriceGroup__c:'');
                //salesDataModel.put('RiskCategory', 'I');
                //salesDataModel.put('CreditLimitAccount', 'I'); //ต้องแยก BAPI
                salesDataModel.put('Block', ''); // คุยทีหลังเนื่องจากมีหลาย Value
                
                salesDataModelList.add(salesDataModel);

                if(mBusinessUnit == 'TX')
                {
                    // CompanyCodeViewModel
                    companyCodeViewModel.put('Task', 'I');
                    companyCodeViewModel.put('SortKey', mRequestHeader.SortKey__c !=null ? mRequestHeader.SortKey__c: '');
                    companyCodeViewModel.put('ReconciliationAccount', mRequestHeader.ReconAccount__c !=null ? mRequestHeader.ReconAccount__c: '');
                    //companyCodeViewModel.put('PaymentMethods', 'I'); //TODO ในชีส ไม่มี field map
                    //companyCodeViewModel.put('TermofPayment', 'I'); //อยู่บน Sales
                    companyCodeViewModel.put('PlanningGroup', mRequestHeader.CashManagementGroup__c !=null ? mRequestHeader.CashManagementGroup__c: '');
                    companyCodeViewModel.put('PaymentHistoryRecord', mRequestItem.PaymentHistoryRecord__c == true ? 'X':'');
                    companyCodeViewModel.put('AuthorizationGroup', mRequestHeader.Authorization__c !=null ? mRequestHeader.Authorization__c: '');
                    companyCodeViewModelList.add(companyCodeViewModel);

                    //WithHolding Tax
                    withHoldingTax1ViewModel.put('TaxType','J1');
                    withHoldingTax1ViewModel.put('Subject','X');
                    withHoldingTax1ViewModel.put('TypeOfRecipient','54');
                    withHoldingTax1ViewModel.put('Task','U');
                    withHoldingTaxViewModelList.add(withHoldingTax1ViewModel);

                    withHoldingTax2ViewModel.put('TaxType','J2');
                    withHoldingTax2ViewModel.put('Subject','UX');
                    withHoldingTax2ViewModel.put('TypeOfRecipient','54');
                    withHoldingTax2ViewModel.put('Task','U');
                    withHoldingTaxViewModelList.add(withHoldingTax2ViewModel);
                }
            }
            else if(mRecordTypeName.contains('Supplier'))
            {
                //Purchasing data
                salesDataModel.put('PurchasingOrg',mRequestItem.PurchasingOrganization__c !=null ? mRequestItem.PurchasingOrganization__c: '');
                salesDataModel.put('InvoiceVerify',mRequestItem.GRBasedInvVerif__c == true ? 'X':'');
                salesDataModel.put('VendorContact',mRequestItem.VendorName__c !=null ? mRequestItem.VendorName__c: '');
                salesDataModel.put('VendorPhone',mRequestItem.VendorPhone__c !=null ? mRequestItem.VendorPhone__c: '');
                salesDataModelList.add(salesDataModel);

                if(mBusinessUnit == 'TX')
                {
                    // CompanyCodeViewModel
                    companyCodeViewModel.put('Task', 'I');
                    companyCodeViewModel.put('CompanyCode', mRequestHeader.SortKey__c !=null ? mRequestHeader.SortKey__c: '');
                    companyCodeViewModel.put('ReconciliationAccount', mRequestHeader.ReconAccount__c !=null ? mRequestHeader.ReconAccount__c: '');
                    companyCodeViewModel.put('PaymentMethods', mRequestItem.PaymentMethod__c !=null ? mRequestItem.PaymentMethod__c: ''); //TODO ในชีส ไม่มี field map
                    companyCodeViewModel.put('TermofPayment', mRequestItem.TermOfPayment__r.Code__c !=null ? mRequestItem.TermOfPayment__r.Code__c: ''); //อยู่บน Sales
                    companyCodeViewModel.put('AccountClerk', mRequestItem.AccigClerk__c !=null ? mRequestItem.AccigClerk__c: '');
                    companyCodeViewModel.put('CashManagementGroup', mRequestItem.CashManagementGroup__c !=null ? mRequestItem.CashManagementGroup__c: '');
                    companyCodeViewModel.put('SortKey', mRequestHeader.SortKey__c !=null ? mRequestHeader.SortKey__c: '');
                    companyCodeViewModel.put('WithHoldingCountry', mRequestItem.WHTaxCountry__c !=null ? mRequestItem.WHTaxCountry__c: '');
                    companyCodeViewModel.put('CheckDoubleInv', mRequestItem.Chkdoubleinv__c == true ? 'X':'');
                    companyCodeViewModelList.add(companyCodeViewModel);

                    //WithHolding Tax
                    withHoldingTax1ViewModel.put('TaxType','J1');
                    withHoldingTax1ViewModel.put('Subject','X');
                    withHoldingTax1ViewModel.put('TypeOfRecipient','54');
                    withHoldingTax1ViewModel.put('Task','U');
                    withHoldingTaxViewModelList.add(withHoldingTax1ViewModel);

                    withHoldingTax2ViewModel.put('TaxType','J2');
                    withHoldingTax2ViewModel.put('Subject','UX');
                    withHoldingTax2ViewModel.put('TypeOfRecipient','54');
                    withHoldingTax2ViewModel.put('Task','U');
                    withHoldingTaxViewModelList.add(withHoldingTax2ViewModel);
                }
            }
        }

        String mAccountId = mRequestItem.Customer__c;
        if(mRequestItem.RecordType.DeveloperName.contains('ShipToCreate'))
        {
            mAccountId = mRequestItem.Partner__c;
            subInputModel.put('Partner', mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: '');
        }

        //input data
        subInputModel.put('AccountNumber',  mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: ''); 
        subInputModel.put('SalesOrganization',  SalesOrganization); 
        subInputModel.put('CompanyCode',  SalesOrganization); 
        subInputModel.put('DistributionChannel', DistributionChannel); 
        subInputModel.put('Division',  Division); 
        subInputModel.put('Id',  mAccountId !=null ? mAccountId: ''); 
        subInputModel.put('GatewayId', uuid);
        subInputModel.put('ReferenceId', mRequestItem.Id);
        subInputModel.put('Flag', mMainFlag);
        
        //input ListData
        subInputModel.put('CentralData', centralDataModelList);
        subInputModel.put('AddressGen', addressGenModelList);
        subInputModel.put('AddressInt', addressIntModelList);
        subInputModel.put('TaxClassification', taxClassificationModelList);
        subInputModel.put('CompanyCodeView', companyCodeViewModelList);
        if(mRecordTypeName.contains('Customer'))
        {
            subInputModel.put('SalesData', salesDataModelList);
        }
        else if(mRecordTypeName.contains('Supplier'))
        {
            subInputModel.put('PurchasingView', salesDataModelList);
            subInputModel.put('WithHoldingTax', withHoldingTaxViewModelList);
        }
        inputModel.input = subInputModel;
        ctrData.input = inputModel;
        
        String str = JSON.serialize(ctrData);
        system.debug('json:'+str);

    }
}