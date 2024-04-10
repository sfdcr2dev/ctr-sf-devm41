public with sharing class CTRBlockRequestFormItemModelData 
{
    public CTRBlockRequestFormItemModelChild input { get; set; }

    public class CTRBlockRequestFormItemModelChild
    {
        public CTRBlockRequestFormItemModelSubChild input{ get; set; }
    } 

    public class CTRBlockRequestFormItemModelSubChild {
        public String AccountNumber{ get; set; }
        public String CompanyCode{ get; set; }
        public String SalesOrganization{ get; set; }
        public String DistributionChannel{ get; set; }
        public String Division{ get; set; }
        public String Id{ get; set; }
        public String GatewayId{ get; set; }
        public String Flag{ get; set; }
        public String RecordType{ get; set; }
        

        public List<CentralDataModel> CentralData{ get; set; }
        public List<AddressModel> AddressGen{ get; set; }
        public List<AddressIntModel> AddressInt{ get; set; }
        public List<SalesDataModel> SalesData{ get; set; }
        public List<TaxClassificationModel> TaxClassification{ get; set; }
        public List<CompanyCodeViewModel> CompanyCodeView{ get; set; }
    }

    public class CentralDataModel {}

    public class AddressModel{}
    
    public class AddressIntModel{}

    public class SalesDataModel
    {
        public String Task{ get; set; }
        public String CreditControlArea{ get; set; }
        public String Block{ get; set; }
        public String Flag{ get; set; }
    }

    public class TaxClassificationModel{}

    public class CompanyCodeViewModel{}

    public static CTRBlockRequestFormItemModelData SetupJsonForBlockDataModel (CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mRecordType, String mBusinessUni,String mGatewayId)
    {
        String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRBlockRequestFormItemModelData ctrData = new CTRBlockRequestFormItemModelData();
        CTRBlockRequestFormItemModelChild inputModel = new CTRBlockRequestFormItemModelChild();
        CTRBlockRequestFormItemModelSubChild subInputModel = new CTRBlockRequestFormItemModelSubChild();
        
        List<CentralDataModel> centralDataModelList = new List<CentralDataModel>();
        List<AddressModel> addressGenModelList = new List<AddressModel>();
        List<AddressIntModel> addressIntModelList = new List<AddressIntModel>();
        List<SalesDataModel> salesDataModelList = new List<SalesDataModel>();
        List<TaxClassificationModel> taxClassificationModelList = new List<TaxClassificationModel>();
        List<CompanyCodeViewModel> companyCodeViewModelList = new List<CompanyCodeViewModel>();
        
        // SalesDataModel
        SalesDataModel salesDataModel = new SalesDataModel();
        salesDataModel.Task = 'U';
        salesDataModel.CreditControlArea = mRequestItem.CreditControlArea__c !=null ? mRequestItem.CreditControlArea__c: '';
        salesDataModel.Block = mRequestItem.OrderBlock__c !=null ? mRequestItem.OrderBlock__c: '';
        salesDataModel.Flag = 'U';
        salesDataModelList.add(salesDataModel);
        
        subInputModel.AccountNumber = mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: ''; //TODO Null value in google sheet
        subInputModel.CompanyCode = '';
        subInputModel.SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
        subInputModel.DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
        subInputModel.Division = mRequestItem.Division__c !=null ? mRequestItem.Division__c: '';
        subInputModel.Id = mRequestHeader.Customer__c;
        subInputModel.GatewayId = uuid;
        subInputModel.RecordType = mRecordType; //only Customer: Sold To
        subInputModel.CentralData = centralDataModelList;
        subInputModel.AddressGen = addressGenModelList;
        subInputModel.AddressInt = addressIntModelList;
        subInputModel.SalesData = salesDataModelList;
        subInputModel.TaxClassification = taxClassificationModelList;
        subInputModel.CompanyCodeView = companyCodeViewModelList;
        subInputModel.Flag = 'U';
        
        inputModel.input =subInputModel;

        ctrData.input =inputModel;
   
        system.debug('json--'+JSON.serialize(ctrData));
        return ctrData;
    }

    public static String SetupJsonForBlockDataModelCustomer (C360_SalesArea__c mSalesArea)
    {
        String uuid = Uuid.randomUUID();//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRBlockRequestFormItemModelData ctrData = new CTRBlockRequestFormItemModelData();
        CTRBlockRequestFormItemModelChild inputModel = new CTRBlockRequestFormItemModelChild();
        CTRBlockRequestFormItemModelSubChild subInputModel = new CTRBlockRequestFormItemModelSubChild();
        
        List<CentralDataModel> centralDataModelList = new List<CentralDataModel>();
        List<AddressModel> addressGenModelList = new List<AddressModel>();
        List<AddressIntModel> addressIntModelList = new List<AddressIntModel>();
        List<SalesDataModel> salesDataModelList = new List<SalesDataModel>();
        List<TaxClassificationModel> taxClassificationModelList = new List<TaxClassificationModel>();
        List<CompanyCodeViewModel> companyCodeViewModelList = new List<CompanyCodeViewModel>();
        
        // SalesDataModel
        SalesDataModel salesDataModel = new SalesDataModel();
        salesDataModel.Task = 'U';
        salesDataModel.CreditControlArea = mSalesArea.CreditControlArea__c !=null ? mSalesArea.CreditControlArea__c: '';
        salesDataModel.Block = 'T1';
        salesDataModel.Flag = 'U';
        salesDataModelList.add(salesDataModel);
        
        subInputModel.AccountNumber = mSalesArea.AccountNumber__r.AccountNumber__c !=null ? mSalesArea.AccountNumber__r.AccountNumber__c: '';
        subInputModel.CompanyCode = '';
        subInputModel.SalesOrganization = mSalesArea.SalesOrganization__c !=null ? mSalesArea.SalesOrganization__c: '';
        subInputModel.DistributionChannel = mSalesArea.DistributionChannel__c !=null ? mSalesArea.DistributionChannel__c: '';
        subInputModel.Division = mSalesArea.Division__c !=null ? mSalesArea.Division__c: '';
        subInputModel.Id = mSalesArea.AccountNumber__c;
        subInputModel.GatewayId = uuid;
        subInputModel.RecordType = 'SoldTo'; //only Customer: Sold To
        subInputModel.CentralData = centralDataModelList;
        subInputModel.AddressGen = addressGenModelList;
        subInputModel.AddressInt = addressIntModelList;
        subInputModel.SalesData = salesDataModelList;
        subInputModel.TaxClassification = taxClassificationModelList;
        subInputModel.CompanyCodeView = companyCodeViewModelList;
        subInputModel.Flag = 'U';
        
        inputModel.input = subInputModel;

        ctrData.input = inputModel;
   
        system.debug('json--'+JSON.serialize(ctrData));
        String mJson = JSON.serialize(ctrData);
        return mJson;
    }
}