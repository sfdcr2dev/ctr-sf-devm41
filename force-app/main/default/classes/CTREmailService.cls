public with sharing class CTREmailService implements Messaging.inboundEmailHandler{
    //https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_email_inbound_using.htm
    //https://www.forcetalks.com/salesforce-topic/what-are-the-custom-email-handler-in-salesforce/
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                           Messaging.InboundEnvelope env ) {
                                                               
                                                               
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        system.debug('env.fromAddress----'+env.fromAddress);
        system.debug('email.subject----'+email.subject);
        //email.subject.toLowerCase();
        String inputText = email.subject;

        Integer startIndex = inputText.indexOf('[RecordId:');
        if (startIndex != -1) {
            startIndex += '[RecordId:'.length();
            Integer endIndex = startIndex + 18;

            if (endIndex != -1) {
                String extractedSubstring = inputText.substring(startIndex, endIndex);
                System.debug(extractedSubstring);
                
                CTRRequestFormItem__c rq = [select id,Message__c,CCEmail__c,ReplyToTRCRHistory__c from CTRRequestFormItem__c where id=:extractedSubstring limit 1];
        
                //please create new field
                rq.ReplyToTRCRHistory__c = email.htmlBody;//rq.CCEmail__c + '[Email subject : ' + email.subject +'] [Email Message : '+ email.plainHTMLBody +']';
                //rq.Message__c =  email.htmlBody;
                update rq;
                /*
                CTRShippingCountry__c c = new CTRShippingCountry__c();
                c.CTRRequestFormItem__c =rq.id;
                insert c;*/
                
                
            } else {
                System.debug('No closing bracket found');
            }
        } else {
            System.debug('[RecordId: not found');
        }
        
        
        
        result.success = true;
        return result;
    }   
}