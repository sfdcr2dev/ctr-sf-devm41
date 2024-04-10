public class OPP_WeatherController {
    
    private static String weatherEndpoint = '';
    private static String weatherToken = '';
    private static Http http = null;
    
    public static void initialize() {
        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
        weatherEndpoint = oppIntegration.Weather_Endpoint__c;
        weatherToken = oppIntegration.Weather_Token__c;
        http = new Http();
    }
    
    @AuraEnabled
    public static String getWeather(String lat , String lon) {
        initialize();
        String endPoint = weatherEndpoint + '&appid='+ weatherToken +'&units=metric&lat='+lat+'&lon='+lon;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        
        HttpResponse res = Http.send(req);
        String temp;
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Map<String, Object> main = (Map<String, Object>)results.get('main');
        System.debug(main.get('temp'));
        temp = String.valueOf(main.get('temp'));
        return temp;
    }
    
    
}