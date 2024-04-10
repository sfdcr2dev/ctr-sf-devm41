@RestResource(urlMapping='/CG_Home_API/*')
global with sharing class CG_Home_API {

    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'GetHomeMenu' { return GetHomeMenu(); }
            when else {  return null; }
        }
    }
    
    public static string GetHomeMenu(){
        
        CG_DTO.HomeMenuDTO results = CG_Home.GetHomeMenu();
            
        string actualResult = JSON.serialize(results);
        return actualResult;

    }
   
}