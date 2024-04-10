public with sharing class CTRHerokuController 
{
    public class TokenResultWrapper
    {
        @AuraEnabled public String mResult{get;set;}
        @AuraEnabled public String mToken{get;set;}
    }
    public static TokenResultWrapper getToken()
    {
        try
        {
            String mToken = '';
            String mResult = 'Error: Cannot found Endpoint Please Re-check on Custom Meta data type : CTRIntegrationList GetToken';

                List<CTRUser__c> mAdminUser = [SELECT ID, Username__c, Password__c FROM CTRUser__c WHERE RecordType.Name = 'Administrator' AND Name = 'SF Integration' LIMIT 1]; //TO DO: Change to Custom Setting later
                String mUsername = (mAdminUser.size()>0)?mAdminUser[0].UserName__c:'moke.k@roundtwosolutions.com';
                //String mUsername = 'moke.k@roundtwosolutions.com';
                String mPassword = (mAdminUser.size()>0)?mAdminUser[0].Password__c:'Test12345';
                //String mPassword = 'Test12345';
        
                String jsonString = '{"username": "'+mUsername+'", "password": "'+mPassword+'"}';
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');  
                request.setHeader('Content-Type', 'application/json');
                request.setBody(jsonString);
                request.setTimeout(12000);
                request.setEndpoint('callout:Heroku_Login');
                //request.setEndpoint(mCTRConfig.Heroku_Authen_Endpoint__c);
                //request.setEndpoint(mIntegrationList[0].Path__c);
                // Make the HTTP request
                Http http = new Http();
                HttpResponse response = http.send(request);
                
                Map<String, Object> parsedResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                //Add
                System.debug('--request--'+request);
                System.debug('--request.setBody--'+jsonString);
                System.debug('response'+response);
        
                // Parse and handle the response
                if (response.getStatusCode() == 200) 
                {
                    String accessToken = (String)parsedResponse.get('token');
                    System.debug('Response: ' + response.getBody());
                    System.debug('accessToken::'+accessToken);
                    mToken = accessToken;
                    mResult = 'Success get Token';
                } 
                else 
                {
                    System.debug('HTTP error: ' + response.getStatusCode() + ' || body: ' + response.getBody());
                    mResult = 'Request Error: Not able to Recieved Token';
                }
            
            TokenResultWrapper mResultWrap = new TokenResultWrapper();
            mResultWrap.mResult = mResult;
            mResultWrap.mToken = mToken;
            return mResultWrap;
        }
        catch(exception e)
        {
            System.debug('Error from CTRHerokuController.getToken Line:'+e.getLineNumber()+' || Message: '+e.getMessage());
            TokenResultWrapper mResultWrap = new TokenResultWrapper();
            mResultWrap.mResult = 'Internal Salesforce Error durring get Token';
            mResultWrap.mToken = '';
            return mResultWrap;
        }

    }   
}