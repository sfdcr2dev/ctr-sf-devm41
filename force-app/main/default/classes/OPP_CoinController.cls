public class OPP_CoinController{ 
    private static String coinAuthorizationEndpoint = '';
    private static String coinAuthorizationUsername = '';
    private static String coinAuthorizationPassword = '';
    private static String coinLoginUsername = '';
    private static String coinLoginPassword = '';
    private static String coinAddEndpoint = '';
    private static String coinGetEndpoint = '';
    private static String accessToken = '';
    private static String coinUser = '';
    private static Http http = null;
    
    public static void initialize(){
        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
        coinAuthorizationEndpoint = oppIntegration.Coin_Authorization_Endpoint__c;
        coinAuthorizationUsername = oppIntegration.Coin_Authorization_Username__c;
        coinAuthorizationPassword = oppIntegration.Coin_Authorization_Password__c;
        coinLoginUsername = oppIntegration.Coin_Login_Username__c;
        coinLoginPassword = oppIntegration.Coin_Login_Password__c;
        coinAddEndpoint = oppIntegration.Coin_Add_Endpoint__c;
        coinGetEndpoint =  oppIntegration.Coin_Get_Endpoint__c;
        List<User> userLogin = [SELECT Id, FederationIdentifier FROM User where Id =:UserInfo.getUserId() Limit 1 ];
        if(userLogin[0].FederationIdentifier != null){
            coinUser = userLogin[0].FederationIdentifier.toLowerCase();
        }else{
            coinUser = UserInfo.getUserName().toLowerCase();
        }
        coinUser = coinUser.substring(0, coinUser.indexOf('@'));	
        http = new Http();
        accessToken = GetToken();
        system.debug(accessToken);
    }
    
    public static String GetToken(){
        String User = coinAuthorizationUsername;
        String Pass = coinAuthorizationPassword;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(coinAuthorizationEndpoint+'username='+User+'&password='+Pass+'&by_pass=true');
        request.setMethod('POST');
        request.setTimeout(120 * 1000);
        HttpResponse response = http.send(request);
        String hash;
        integer statusCode;
        if (response.getStatusCode() == 200){ 
            Map<String, Object> results =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> token =(Map<String, Object>)results.get('token');
            hash = String.valueOf(token.get('hash'));     
        }else{
            statusCode = response.getStatusCode();
            hash = 'error';
        }
        return hash;
    }

    @AuraEnabled
    public static String getCoin(String url){
        initialize();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url+coinUser);
        req.setMethod('GET');
        req.setTimeout(120 * 1000);
        HttpResponse res = Http.send(req);
        return res.getBody();
    }

    public static HttpResponse addCoin(String refId ,Decimal coin){
        initialize();
        string url = coinAddEndpoint;
        string username = 'username='+coinLoginUsername;
        string password = '&password='+coinLoginPassword;
        string user;
        user = '&name='+coinUser;
        refId = '&refId='+refId;
        string coint = '&coin='+coin;
        String endpoint = username+password+user+refId+coint;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setBody(endpoint);
        request.setMethod('POST');
        request.setTimeout(120 * 1000);
        request.setHeader('X-Auth-Token', accessToken);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201){
            System.debug('The status code returned was not expected: ' +response.getStatusCode() + ' ' + response.getStatus());
        }else{
            System.debug(response.getBody());
        }
        return response;
    }
       
    public static void UpdateCoin(){
        initialize();
        String url = coinGetEndpoint;
        String user = 'name='+coinUser;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url+user);
        req.setMethod('GET');
        req.setTimeout(120 * 1000);
        HttpResponse res = Http.send(req);
        if (res.getStatusCode() == 200) {
            update new User(Id = UserInfo.getUserId(), OPP_Total_Coin__c = res.getBody());
        } else {
        	System.debug(res.getBody());
        }
    }
}