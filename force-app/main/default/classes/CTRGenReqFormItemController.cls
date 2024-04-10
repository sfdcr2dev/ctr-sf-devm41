public class CTRGenReqFormItemController 
{
    @InvocableMethod
    public static void genReqItem(List<String> ReqId)
    {
        CTRRequestFormHeader__c req = [select InterestedProductCustomer__c,InterestedProductSupplier__c from CTRRequestFormHeader__c where id =: ReqId[0]];
        try
        {
			List<String>productCusList = new List<String>();
            List<String>productSupList = new List<String>();
            List<CTRRequestFormItem__c>reqItemList = new List<CTRRequestFormItem__c>();
            if(req.InterestedProductCustomer__c != '')
            {
                productCusList = req.InterestedProductCustomer__c.split(';');
                for(String pro : productCusList)
                {
                    CTRRequestFormItem__c temp = new CTRRequestFormItem__c();
                    temp.Name = pro;
                    temp.CTRRequestFormHeader__c = ReqId[0];
                    reqItemList.add(temp);
                }
            }
            if(req.InterestedProductSupplier__c != '')
            {
                productSupList = req.InterestedProductSupplier__c.split(';');
                for(String pro : productSupList)
                {
                    CTRRequestFormItem__c temp = new CTRRequestFormItem__c();
                    temp.Name = pro;
                    temp.CTRRequestFormHeader__c = ReqId[0];
                    reqItemList.add(temp);
                }
            }
            if(reqItemList.size() > 0)
            {
                System.debug('CTRGenReqFormItemController insert item '+reqItemList.size());
                Integer retry = 3;
                for(Integer i = 0; i < retry; i++) { // retry 3 times if failed
                    try {
                        insert reqItemList;
                        break;
                    } catch(Exception e)  {
                        System.debug('Retry# '+String.valueOf(i)+': Error occurred when insert item on account trigger: ' + e.getMessage());
                        if(!(e.getMessage() != null && e.getMessage().contains('duplicate value found: UniqueRunningNumber__c'))) {
                            break; // if another error -> break
                        }
                        System.debug('Duplicate unique running number -> Retry');
                        // if error message is duplicate unique number -> continue retry
                    }
                }
            }
           	
        }
        catch(Exception e)
        {
            system.debug('CTRLeadConvert2----'+e.getmessage()+' line:'+e.getLineNumber());
        }
    }
}