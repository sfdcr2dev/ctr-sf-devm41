public class CTRFlowEmailCTR 
{
	@InvocableMethod(label='Send Email via Apex')
    public static void sendEmail(List<FlowInputs> mData) 
    {   
        String mRecordId = mData[0].mRecordId;
        String mTemplateId = mData[0].mTemplateId;
        String mSubject = mData[0].mSubject;
        String mBody = mData[0].mBody;

        List<String> mEmailTo = mData[0].mEmailToList;
        List<String> mEmailcc = (mData[0].mEmailCCList!=null && !mData[0].mEmailCCList.isEmpty())? mData[0].mEmailCCList :new List<String>();
        List<String> mAttachmentIdList = (mData[0].mAttachmentIdList!=null)? mData[0].mAttachmentIdList :new List<String>();
        
        List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Commercial Team' LIMIT 1];
        List<String> mEmailToSent = new List<String>();
        List<String> mEmailccSent = new List<String>();

        if(mEmailTo.size()>0)
        {
            for(String mEmail: mEmailTo)
            {
                if(String.isNotBlank(mEmail))
                {
                    mEmailToSent.add(mEmail);
                }
            }
        }
        if(mEmailcc.size()>0)
        {
            for(String mEmail: mEmailcc)
            {
                if(String.isNotBlank(mEmail))
                {
                    mEmailccSent.add(mEmail);
                }
            }
        }

        List<Contact> mContactList = [SELECT Id FROM Contact LIMIT 1];

        // Create an Email Message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setToAddresses(mEmailToSent);
        System.debug('mEmailcc:'+mEmailcc);
        System.debug('mEmailcc:'+mEmailccSent.size());
        if(mEmailccSent.size()>0)
        {
            email.setCcAddresses(mEmailccSent);
        } 
        email.setWhatId(mRecordId);
        if(String.isNotBlank(mTemplateId))
        {
            email.setTargetObjectId(mContactList[0].Id);
        	email.setTemplateId(mTemplateId);
        }
        else
        {
            email.setSubject(mSubject);
            email.setHtmlBody(mBody);
        }
        if(mAttachmentIdList.size()>0)
        {
            email.setEntityAttachments(mAttachmentIdList);
        }
        email.setTreatTargetObjectAsRecipient(false);
        email.setCharset('UTF-8');
        email.setSaveAsActivity(false);
        if ( owea.size() > 0 ) {
    		email.setOrgWideEmailAddressId(owea.get(0).Id);
		}
        

        // Send the email
        //List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(new List<Messaging.Email> { mailToSend });
        if(mEmailToSent.size()>0)
        {
            try
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
                System.debug(results[0]);
            }
            catch(exception e)
            {
                System.debug('send email error flow');
            }
            
        }
        
    }


    //input details that comes to apex from flow
    public class FlowInputs
    {
        @InvocableVariable
        public String mRecordId;
        
        @InvocableVariable
        public String mTemplateId;
        
        @InvocableVariable
        public String mSubject;
        
        @InvocableVariable
        public String mBody;
        
        @InvocableVariable
        public List<String> mEmailToList;
        
        @InvocableVariable
        public List<String> mEmailCCList;

        @InvocableVariable
        public List<String> mAttachmentIdList;
    }
}