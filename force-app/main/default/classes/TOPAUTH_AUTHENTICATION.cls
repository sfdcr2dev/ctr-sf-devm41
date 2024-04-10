// This class connect to TOPAUTH for authentication 

public with sharing class TOPAUTH_AUTHENTICATION {

    public static integer TestStatus {get;set;}
    
    TOPAUTHIntegration__c TOPAUTH = [SELECT Name, SF_URL__c, TOPAUTH_URL__c, CLIENT_ID__c, CLIENT_SECRET__c, 
                                     TOPAUTH_REDIRECT_URL__c, TOPAUTH_AUTHEN_URL__c FROM TOPAUTHIntegration__c];
    
    string clientId = TOPAUTH.CLIENT_ID__c;
    string clientSecret = TOPAUTH.CLIENT_SECRET__c;
    string sfURL = TOPAUTH.SF_URL__c;
    string topauthURL = TOPAUTH.TOPAUTH_URL__c;
    string topauthRedirectURL = TOPAUTH.TOPAUTH_REDIRECT_URL__c;
    
    public static string errorMessage { get;set; }
    public class topauthAuthenBody {
        public string user_id;
        public string redirectURL;
        public string masterKey;
    }
    
    public static string responseTopauthAuthen {get;set;}
    public static topauthAuthenWrapper TAW {get;set;}
    public class topauthAuthenWrapper {
        public string RedirectURL;
    }
    
    public TOPAUTH_AUTHENTICATION() {
    
    }
    
    public TOPAUTH_AUTHENTICATION(ApexPages.StandardSetController controller) {   
        
    }

    @auraEnabled
    public static string AuthenToTopauth(string redirectURL) {
        
        string userProfile = UserInfo.getProfileId();
        
        List<TOPAUTHIntegration__c> TOPAUTHs = [SELECT Name, SF_URL__c, TOPAUTH_URL__c, CLIENT_ID__c, CLIENT_SECRET__c, 
                                     TOPAUTH_REDIRECT_URL__c, TOPAUTH_AUTHEN_URL__c FROM TOPAUTHIntegration__c];
        
        TOPAUTHIntegration__c TOPAUTH = TOPAUTHs[0];
        
    	string MasterKey = 'nbt33dBjmm64P53wUCj3STEeaw6t8adS';
        string url = '';
        
        //Send request ot get RedirectToken
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        request.setMethod('POST');
        request.setEndPoint(TOPAUTH.TOPAUTH_AUTHEN_URL__c);
        request.setHeader('Content-Type', 'application/json'); 
        request.setTimeout(60000);
        
        string userId = UserInfo.getUserName();
        
        topauthAuthenBody taBody = new topauthAuthenBody();
        taBody.user_id = userId;
        taBody.masterKey = MasterKey;
        taBody.redirectURL = redirectURL;
        
        request.setBody(JSON.serialize(taBody));
        
        System.debug('JSON : ' + JSON.serialize(taBody));
        
        try {
            response = http.send(request);
        }
        catch (Exception e) {
        
            errorMessage = 'Error from Request Redirect Token';
            System.debug(e);
        }
        
        if(Test.isRunningTest())  {
            SetMockResult(response, TestStatus == null ? 200 : TestStatus);    
        }
        
        if(response.getStatusCode() == 200) {
            
            responseTopauthAuthen = String.ValueOf(response.getBody());
            JSONParser parser = JSON.createParser(responseTopauthAuthen);
            
            TAW = (topauthAuthenWrapper)parser.readValueAs(topauthAuthenWrapper.class);
            url = TAW.RedirectURL;
            
            System.debug('url : ' + url);
            return url;
        }
        else {
            url = 'Error';
            return url;
        }
    }
    
    public static void SetMockResult(HttpResponse InputResponse,integer TestStatus){
        
        InputResponse.setStatusCode(TestStatus);
        InputResponse.setHeader('Content-Type', 'application/json');
        String strBody='{'
                                +'"RedirectURL":"https://test.com"'
                                    +'}';
        
        InputResponse.setBody(strBody);
        
    }

}