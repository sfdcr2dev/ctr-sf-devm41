/* 
 * Author Softever
 */

@RestResource(urlMapping='/WAP_Map_API/*')
global class WAP_Map_API {
    
    @HttpPost global static string doPost(string param) {

        Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'GetWorkCount' { return String.ValueOf(GetWorkCount(mapObject.get('filter').toString()));}
            when 'GetAllWorkCount' { return String.ValueOf(GetAllWorkCount(mapObject.get('filter').toString()));}
            when 'GetWorkMaps' { return String.ValueOf(GetWorkMaps(mapObject.get('filter').toString()));}
            when 'GetWorkDetail' { return GetWorkDetail(mapObject.get('clearanceNo').toString());}
            when 'UpdateWorkClearanceMapLatLong' { return UpdateWorkClearanceMapLatLong(mapObject.get('recordId').toString(), mapObject.get('latitude').toString(), mapObject.get('longitude').toString());}
            when 'GetAreas' { return GetAreas();}
            when else {  return null; }
        }
        
    }

    //Count all Work
    public static string GetWorkCount(string filter) {
        
        WAP_Map.MapSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Map.MapSearchCriteria)JSON.deserialize(filter, WAP_Map.MapSearchCriteria.class);
        } 
        
        WAP_DTO.HeaderMapDTO results = WAP_Map.GetWorkCount(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    //Count all Work count
    public static string GetAllWorkCount(string filter) {
        
        WAP_Map.MapSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Map.MapSearchCriteria)JSON.deserialize(filter, WAP_Map.MapSearchCriteria.class);
        } 
        
        WAP_DTO.TypeOfWorkCountDTO results = WAP_Map.GetAllWorkCount(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    //Get all Work
    public static string GetWorkMaps(string filter) {
        
        WAP_Map.MapSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Map.MapSearchCriteria)JSON.deserialize(filter, WAP_Map.MapSearchCriteria.class);
        } 
        
        List<WAP_DTO.WorkMapDTO> results = WAP_Map.GetWorkMaps(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    //Get currentWork
    public static string GetWorkDetail(string clearanceNo) {
        
        WAP_DTO.WorkMapDTO result = WAP_Map.GetWorkDetail(clearanceNo);
        
        string actualResult = JSON.serialize(result);
        
        return actualResult;
    }
    
    public static string UpdateWorkClearanceMapLatLong(string recordId, string latitude, string longitude) {
        
        WAP_DTO.WorkMapDTO result = WAP_Map.UpdateWorkClearanceMapLatLong(recordId, latitude, longitude);
        
        string actualResult = JSON.serialize(result);
        
        return actualResult;
    }
    
    //Get Areas
    public static string GetAreas() {
        
        Set<string> areas = WAP_Map.GetAreas();
        
        string result = JSON.serialize(areas);
        return result;
        
    }
    
}