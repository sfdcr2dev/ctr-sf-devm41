public class CTRBlockSupplierRequestFormItemModelData {

    public CTRBlockRequestFormItemModelChild input { get; set; }

    public class CTRBlockRequestFormItemModelChild
    {
        public CTRBlockSupplierRequestFormItemModelSubChild input{ get; set; }
    } 

    public class CTRBlockSupplierRequestFormItemModelSubChild {
        public String AccountNumber{ get; set; }
        //public String CompanyCode{ get; set; }
        //public String SalesOrganization{ get; set; }
        //public String DistributionChannel{ get; set; }
        //public String Division{ get; set; }
        public String Id{ get; set; }
        public String GatewayId{ get; set; }
        public String Flag{ get; set; }
        public String RecordType{ get; set; }

        public List<CentralDataModel> CentralData{ get; set; }
        public List<AddressModel> AddressGen{ get; set; }
        public List<AddressIntModel> AddressInt{ get; set; }
        public List<SalesDataModel> PurchasingView{ get; set; }
        public List<CompanyCodeViewModel> CompanyCodeView{ get; set; }
        public List<WithHoldingTax> WithHoldingTax{ get; set; }
    }

    public class CentralDataModel {}

    public class AddressModel{}
    
    public class AddressIntModel{}

    public class SalesDataModel
    {
        public String Task{ get; set; }
        //public String CreditControlArea{ get; set; }
        public String PurchasingOrg{ get; set; }
        public String Block{ get; set; }
        public String Flag{ get; set; }
    }

    public class CompanyCodeViewModel{}
    
    public class WithHoldingTax{}

    public static CTRBlockSupplierRequestFormItemModelData SetupJsonForBlockDataModel (CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mViewName, String mBusinessUni,String mGatewayId)
    {
        String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRBlockSupplierRequestFormItemModelData ctrData = new CTRBlockSupplierRequestFormItemModelData();
        CTRBlockRequestFormItemModelChild inputModel = new CTRBlockRequestFormItemModelChild();
        CTRBlockSupplierRequestFormItemModelSubChild subInputModel = new CTRBlockSupplierRequestFormItemModelSubChild();
        
        List<CentralDataModel> centralDataModelList = new List<CentralDataModel>();
        List<AddressModel> addressGenModelList = new List<AddressModel>();
        List<AddressIntModel> addressIntModelList = new List<AddressIntModel>();
        List<CompanyCodeViewModel> companyCodeViewModelList = new List<CompanyCodeViewModel>();
        List<SalesDataModel> PurchasingviewList = new List<SalesDataModel>();
        List<WithHoldingTax> WithHoldingTaxList = new List<WithHoldingTax>();
        
        // PurchasingModel
        SalesDataModel salesDataModel = new SalesDataModel();
        salesDataModel.Task = 'U';
        salesDataModel.PurchasingOrg = mRequestItem.PurchasingOrganization__c !=null ? mRequestItem.PurchasingOrganization__c: '';
        salesDataModel.Block = mRequestItem.SelectedPurchasingOrg__c == true ? 'X':'';
        salesDataModel.Flag = 'U';            
        PurchasingviewList.add(salesDataModel);        
        
        subInputModel.AccountNumber = mRequestItem.Customer__r.SupplierNumber__c !=null ? mRequestItem.Customer__r.SupplierNumber__c: '';
        //subInputModel.CompanyCode = '';
        //subInputModel.SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
        //subInputModel.DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
        //subInputModel.Division = mRequestItem.Division__c !=null ? mRequestItem.Division__c: '';
        subInputModel.Id = mRequestHeader.Customer__c;
        subInputModel.GatewayId = uuid;
        subInputModel.RecordType = mViewName;
        subInputModel.CentralData = centralDataModelList;
        subInputModel.AddressGen = addressGenModelList;
        subInputModel.AddressInt = addressIntModelList;
        subInputModel.PurchasingView = PurchasingviewList;
        subInputModel.CompanyCodeView = companyCodeViewModelList;
        subInputModel.WithHoldingTax = WithHoldingTaxList;
        subInputModel.Flag = 'U';
        
        inputModel.input =subInputModel;

        ctrData.input =inputModel;
   
        system.debug('json--'+JSON.serialize(ctrData));
        return ctrData;
    }

    public static String SetupJsonForBlockDataModelSupplier (CTRPurchasingView__c mPurchasing)
    {
        String uuid = Uuid.randomUUID();//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRBlockSupplierRequestFormItemModelData ctrData = new CTRBlockSupplierRequestFormItemModelData();
        CTRBlockRequestFormItemModelChild inputModel = new CTRBlockRequestFormItemModelChild();
        CTRBlockSupplierRequestFormItemModelSubChild subInputModel = new CTRBlockSupplierRequestFormItemModelSubChild();
        
        List<CentralDataModel> centralDataModelList = new List<CentralDataModel>();
        List<AddressModel> addressGenModelList = new List<AddressModel>();
        List<AddressIntModel> addressIntModelList = new List<AddressIntModel>();
        List<CompanyCodeViewModel> companyCodeViewModelList = new List<CompanyCodeViewModel>();
        List<SalesDataModel> PurchasingviewList = new List<SalesDataModel>();
        List<WithHoldingTax> WithHoldingTaxList = new List<WithHoldingTax>();
        
        // PurchasingModel
        SalesDataModel salesDataModel = new SalesDataModel();
        salesDataModel.Task = 'U';
        salesDataModel.PurchasingOrg = mPurchasing.PurchasingOrg__c !=null ? mPurchasing.PurchasingOrg__c: '';
        salesDataModel.Block = 'X';
        salesDataModel.Flag = 'U';            
        PurchasingviewList.add(salesDataModel);        
        
        subInputModel.AccountNumber = mPurchasing.Account__r.SupplierNumber__c !=null ? mPurchasing.Account__r.SupplierNumber__c : '';
        subInputModel.Id = mPurchasing.Account__c ;
        subInputModel.GatewayId = uuid;
        subInputModel.RecordType = '';
        subInputModel.CentralData = centralDataModelList;
        subInputModel.AddressGen = addressGenModelList;
        subInputModel.AddressInt = addressIntModelList;
        subInputModel.PurchasingView = PurchasingviewList;
        subInputModel.CompanyCodeView = companyCodeViewModelList;
        subInputModel.WithHoldingTax = WithHoldingTaxList;
        subInputModel.Flag = 'U';
        
        inputModel.input =subInputModel;

        ctrData.input =inputModel;
   
        system.debug('json--'+JSON.serialize(ctrData));
        String mJson = JSON.serialize(ctrData);
        return mJson;
    }
}