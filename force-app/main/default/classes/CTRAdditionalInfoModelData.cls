public class CTRAdditionalInfoModelData 
{
	public CTRAdditionalInfoModelChild input { get; set; }

    public class CTRAdditionalInfoModelChild
    {
        public CTRAdditionalInfoModelSubChild input{ get; set; }
    } 

    public class CTRAdditionalInfoModelSubChild {
        public String GatewayId{ get; set; }
        public String Id{ get; set; }
        public String AccountNumber{ get; set; }
        public String SalesOrganization{ get; set; }
        public String DistributionChannel{ get; set; }
        public String CustomerType{ get; set; }
        public String CustomerGroup{ get; set; }
        public String Industry{ get; set; }
        public String SubIndustry{ get; set; }
        public String Application{ get; set; }
        public String InterGroup{ get; set; }
        public String DeletionFlag{ get; set; }
    }


    public static CTRAdditionalInfoModelData SetupJsonForAdditionalInfoDataModel (CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mViewName, String mBusinessUnit, String mGatewayId)
    {
        String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
        CTRAdditionalInfoModelData ctrData = new CTRAdditionalInfoModelData();
        CTRAdditionalInfoModelChild inputModel = new CTRAdditionalInfoModelChild();
        CTRAdditionalInfoModelSubChild subInputModel = new CTRAdditionalInfoModelSubChild();
        
        subInputModel.GatewayId = uuid;
        subInputModel.Id = mRequestHeader.Customer__c;
        subInputModel.AccountNumber = mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: ''; //TODO Null value in google sheet
        subInputModel.SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
        subInputModel.DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
        subInputModel.CustomerType = mRequestItem.CustomerType__r.Code__c !=null ? mRequestItem.CustomerType__r.Code__c: '';// = 'CT001';
        subInputModel.CustomerGroup = mRequestItem.CustomerGroup__r.Code__c !=null ? mRequestItem.CustomerGroup__r.Code__c: '';// = 'CG005';
        subInputModel.Industry = mRequestItem.Industry__r.Code__c !=null ? mRequestItem.Industry__r.Code__c: '';// = 'IN006';
        subInputModel.SubIndustry = mRequestItem.SubIndustry__r.Code__c !=null ? mRequestItem.SubIndustry__r.Code__c: '';// = 'SI048';
        subInputModel.Application = mRequestItem.Application__r.Code__c !=null ? mRequestItem.Application__r.Code__c: '';// = 'AP047';
        subInputModel.InterGroup = mRequestItem.InterGroup__r.Code__c !=null ? mRequestItem.InterGroup__r.Code__c: '';// = 'IG001';
        subInputModel.DeletionFlag = '';
               
        inputModel.input =subInputModel;

        ctrData.input =inputModel;
        system.debug('json--'+JSON.serialize(ctrData));
        return ctrData;
    }
}