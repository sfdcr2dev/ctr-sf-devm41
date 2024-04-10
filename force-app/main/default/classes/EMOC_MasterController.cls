public class EMOC_MasterController {
    public static List<Map<String, String>> getLookupMasterMap(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        List<Master_Map__c> masterMap = [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Main Work Center' AND (Name LIKE :paramLike OR Id = :searchParam) LIMIT 99];

        List<Map<String, String>> returnList = new List<Map<String, String>>();
        for(Master_Map__c objMaster: masterMap) {
            Map<String, String> objList = new Map<String, String>();
            objList.put('Id',objMaster.Id);
            objList.put('Name',objMaster.Name != null ? objMaster.Name : '');
            objList.put('Description__c',objMaster.Description__c != null ? objMaster.Description__c : '');
            returnList.add(objList);
        }
        return returnList;
    }
    
    public static List<Map<String, String>> getLookupPMActivity(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        List<Master_Map__c> masterMap = [SELECT Id, RelatedMasterMap1__c, RelatedMasterMap1__r.Name, Name, Description__c, RelatedMasterMap2__c
                                        FROM Master_Map__c
                                        WHERE RelatedMasterMap2__r.Name = 'CR01'
                                        AND ( RelatedMasterMap1__r.Name LIKE :paramLike OR Id = :searchParam )
                                        AND RelatedMasterMap1__c != null
                                        LIMIT 99];

        List<Map<String, String>> returnList = new List<Map<String, String>>();
        for(Master_Map__c objMaster: masterMap) {
            Map<String, String> objList = new Map<String, String>();
            objList.put('Id',objMaster.RelatedMasterMap1__c);
            objList.put('Name',objMaster.RelatedMasterMap1__r.Name != null ? objMaster.RelatedMasterMap1__r.Name : '');
            returnList.add(objList);
        }
        return returnList;
    } 
    
    public static List<Map<String, String>> getLookupFncLocation(String searchParam, String typeForm) {
        String paramLike = '%' + searchParam + '%';
        List<Functional_Location__c> functionalLocation = [SELECT Id, Name, Description__c, MainWorkCenter__c, MainWorkCenter_Text__c, mainWorkCenterPlant_Text__c, mainWorkCenterPlant__c  FROM Functional_Location__c WHERE Name LIKE :paramLike OR Id = :searchParam LIMIT 99];
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        for(Functional_Location__c objLocation: functionalLocation) {
            Map<String, String> objList = new Map<String, String>();
            objList.put('Id',objLocation.Id);
            objList.put('Name',objLocation.Name != null ? objLocation.Name : '');
            objList.put('Description__c',objLocation.Description__c != null ? objLocation.Description__c : '');
            objList.put('MainWorkCenter__c',objLocation.MainWorkCenter__c != null ? objLocation.MainWorkCenter__c : '');
            objList.put('MainWorkCenter_Text__c',objLocation.MainWorkCenter_Text__c != null ? objLocation.MainWorkCenter_Text__c : '');
          //  if (typeForm == 'Notification') {
            objList.put('mainWorkCenterPlant__c',objLocation.mainWorkCenterPlant__c != null ? objLocation.mainWorkCenterPlant__c : '');   
          //  }
            objList.put('mainWorkCenterPlant_Text__c',objLocation.mainWorkCenterPlant_Text__c != null ? objLocation.mainWorkCenterPlant_Text__c : '');
            returnList.add(objList);
        }
        return returnList;
    }
    
    public static List<Map<String, String>> getLookupUser(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        List<User> userList = [SELECT Id, Username, LastName, FirstName, Employee_Id__c FROM User WHERE IsActive = true AND (Name LIKE :paramLike OR Id = :searchParam)  LIMIT 10];
        List<Map<String, String>> userReturnList = new List<Map<String, String>>();
        for(User objUser: userList) {
            Map<String, String> userReturn = new Map<String, String>();
            userReturn.put('Id',objUser.Id);
            userReturn.put('Username',objUser.Username != null ? objUser.Username : '');
            userReturn.put('LastName',objUser.LastName != null ? objUser.LastName : '');
            userReturn.put('FirstName',objUser.FirstName != null ? objUser.FirstName : '');
            userReturn.put('Employee_Id__c',objUser.Employee_Id__c != null ? objUser.Employee_Id__c : '');
            PISUsers__c[] pisUser = [SELECT Id, ORGID__c,INDICATOR__c FROM PISUsers__c WHERE User__c = :objUser.Id AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
            if (pisUser.size() != 0) {
                userReturn.put('ORGID__c', pisUser[0].ORGID__c);
                userReturn.put('PISUsers__c', pisUser[0].Id);
                userReturn.put('INDICATOR__c', pisUser[0].INDICATOR__c);
            } else {
                userReturn.put('ORGID__c', '');
                userReturn.put('PISUsers__c', '');
                userReturn.put('INDICATOR__c', '');
            }
            userReturnList.add(userReturn);
        }
        return userReturnList;
    }
    
	public static List<Map<String, String>> getLookupMainWorkCenterPlan(String searchParam) {
        String paramLike = '%' + searchParam + '%';
        List<Master_Map__c> masterMap = [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant' AND (Name LIKE :paramLike OR Id = :searchParam) LIMIT 99];

        List<Map<String, String>> returnList = new List<Map<String, String>>();
        for(Master_Map__c objMaster: masterMap) {
            Map<String, String> objList = new Map<String, String>();
            objList.put('Id',objMaster.Id);
            objList.put('Name',objMaster.Name != null ? objMaster.Name : '');
            objList.put('Description__c',objMaster.Description__c != null ? objMaster.Description__c : '');
            returnList.add(objList);
        }
        return returnList;
    }

}