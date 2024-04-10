/* Author Softever */
@RestResource(urlMapping='/ESS_Menu_API/*')
global class ESS_Menu_API {

    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'GetMenuLists' { return GetMenuLists();}
            when else {  return null; }
        }
    
    }
    
	public static string GetMenuLists() {
        
        List<ESS_Menu_DTO.MenuListDTO> results = ESS_Menu.GetMenuLists();
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    
}