public class C360_NotificationBellController{
    private static Map<String,Set<String>> MapTopGroup = new Map<String,Set<String>>();
    private static CustomNotificationType notificationType;
    public static void initialize(){
        MapTopGroup = GetUserFromTopGroup();
        notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='C360Notification'];
    }
    public static void expireBG(){
        initialize();
        expireBGTop();
        expireBGSolvent();
    }
    public static void expireBGTop(){//TOP
        List<C360_BankGuarantee__c> bgList = [SELECT Id, CompanyCode__c, RemainingDays__c,Customer__r.Name from C360_BankGuarantee__c Where RemainingDays__c <= 60 and RemainingDays__c != null and CompanyCode__c in ('1100','1300','1400','1700')];
        if(bgList.size() > 0){
            for(C360_BankGuarantee__c bgItem : bgList){
                String Title = 'Bank Guarantee Notification';
                String Body = 'Bank Guarantee Information for '+ bgItem.Customer__r.Name + ' will be expired in '+ bgItem.RemainingDays__c +' days, click for more details.';
                if(bgItem.RemainingDays__c <= 60){
                    notifyUsers(MapTopGroup.get(bgItem.CompanyCode__c),bgItem.Id,Title, Body);
                }
            }
        }
    }
    public static void expireBGSolvent(){//TOP
        Map<String,Set<String>> MapUserIdList = GetIdSaleGroup();
        List<C360_BankGuarantee__c> bgList = [SELECT Id, CompanyCode__c, RemainingDays__c,Customer__r.AccountNumber__c,Customer__r.Name FROM C360_BankGuarantee__c WHERE RemainingDays__c <= 60 and RemainingDays__c != null and CompanyCode__c in ('2000','9100','9200','9300')];
        if(bgList.size() > 0){
            for(C360_BankGuarantee__c bgItem : bgList){
                String Title = 'Bank Guarantee Notification';
                String Body = 'Bank Guarantee Information for '+ bgItem.Customer__r.Name + ' will be expired in '+ bgItem.RemainingDays__c +' days, click for more details.';
                if(bgItem.RemainingDays__c <= 60){
                    if(MapUserIdList.ContainsKey(bgItem.CompanyCode__c + bgItem.Customer__r.AccountNumber__c))
                    notifyUsers(MapUserIdList.get(bgItem.CompanyCode__c + bgItem.Customer__r.AccountNumber__c),bgItem.Id,Title, Body);
                }
            }
        }
    }
    public static void expireContractTop(){
        initialize();
        List<C360_Contract__c> contList = [SELECT Id, ContractNumber__c, SalesOrganization__c, RemainingDays__c,SoldTo__r.Name FROM C360_Contract__c WHERE RemainingDays__c != null and RemainingDays__c <= 30 AND SalesOrganization__c in ('1100','1300','1400','1700')];
        if(contList.size() > 0){
            for(C360_Contract__c contItem : contList){
                String Title = 'Contract Notification';
                String Body = '#'+contItem.ContractNumber__c+' will be expired in ' + contItem.RemainingDays__c + ' day(s), click to view more details.';
                if(contItem.RemainingDays__c == 30 || contItem.RemainingDays__c == 15 || contItem.RemainingDays__c == 1){
                    notifyUsers(MapTopGroup.get(contItem.SalesOrganization__c),contItem.Id,Title, Body);
                }
            }
        }
    }
    public static void expireContractSolvent(){
        initialize();
        Map<String,Set<String>> MapUserIdList = GetIdSaleGroup();
        Map<String,Set<String>> MapParentUserIdList = GetIdParentSaleGroup();
        List<C360_Contract__c> contList = [SELECT Id, ContractNumber__c, SalesOrganization__c, RemainingDays__c,SoldTo__r.AccountNumber__c,SoldTo__r.Name from C360_Contract__c Where RemainingDays__c != null and RemainingDays__c <= 60 AND SalesOrganization__c in ('2000','9100','9200','9300')];
        if(contList.size() > 0){
            for(C360_Contract__c contItem : contList){
                String Title = 'Contract Notification';
                String Body = '#'+contItem.ContractNumber__c+' will be expired in ' + contItem.RemainingDays__c + ' day(s), click to view more details.';
                if(contItem.RemainingDays__c == 60 || contItem.RemainingDays__c == 30 || contItem.RemainingDays__c == 14){
                    notifyUsers(MapUserIdList.get(contItem.SalesOrganization__c + contItem.SoldTo__r.AccountNumber__c),contItem.Id,Title, Body);
                }
                if(contItem.RemainingDays__c == 7){
                    Set<string> userId = new Set<string>();
                    if(MapUserIdList.containskey(contItem.SalesOrganization__c + contItem.SoldTo__r.AccountNumber__c))
                        userId.addAll(MapUserIdList.get(contItem.SalesOrganization__c + contItem.SoldTo__r.AccountNumber__c));
                    if(MapParentUserIdList.containskey(contItem.SalesOrganization__c + contItem.SoldTo__r.AccountNumber__c))
                        userId.addAll(MapParentUserIdList.get(contItem.SalesOrganization__c + contItem.SoldTo__r.AccountNumber__c));
                    notifyUsers(userId,contItem.Id,Title, Body);
                }
            }
        }
    }
    public static void expireExciseSolvent(){
        initialize();
        Map<String,Set<String>> MapUserIdList = GetIdSaleGroup();
        Map<String,Set<String>> MapIdList = GetUserFromSolventGroup();
        List<C360_ExciseQuota__c> eqList = [SELECT Id,RemainingDays__c,SalesOrganization__c,CompanyName__r.AccountNumber__c, CompanyName__r.Name from C360_ExciseQuota__c Where RemainingDays__c <= 60 and RemainingDays__c != null  and SalesOrganization__c in ('2000','9100','9200','9300')];
        if(eqList.size() > 0){
            for(C360_ExciseQuota__c item : eqList){
                String Title = 'Excise Quota Notification';
                String Body = 'Excise quota information for '+ item.CompanyName__r.Name + ' will be expired in '+ item.RemainingDays__c +' days, click for more details.';
                if(item.RemainingDays__c == 30 || item.RemainingDays__c == 60){
                    Set<String> idList = new Set<String>();
                    idList.addAll(MapIdList.get(item.SalesOrganization__c));
                    idList.addAll(MapUserIdList.get(item.SalesOrganization__c + item.CompanyName__r.AccountNumber__c));
                    notifyUsers(idList,item.Id,Title, Body);
                }
            }
        }
    }
    public static void notifyUsers(Set<String> recipientsIds, String targetId, String Title, String Body){
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(Title);
        notification.setBody(Body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        try{
            notification.send(recipientsIds);
        }
        catch (Exception e) {}
    }
    public static Map<String,Set<String>> GetIdSaleGroup(){
        Map<String,Set<String>> MapGroup = new Map<String,Set<String>>();
        List<Master_Map__c> MasterList = new list<Master_Map__c>();
        Map<String,String> saleGroupMap = new map<String,String>();
        MasterList = [SELECT Id, Sales_Group__c, Sales_Rep__c,Sales_Rep__r.Email from Master_Map__c where Type__c = 'SalesMapwithSalesGroup'];
        for(Master_Map__c i : MasterList){
            saleGroupMap.put(i.Sales_Group__c, i.Sales_Rep__c);
        }
        List<C360_SalesArea__c> salesAreaList = [SELECT Id,AccountNumber__r.AccountNumber__c,SalesOrganization__c,SalesGroup__c from C360_SalesArea__c Where SalesGroup__c != null];
        for(C360_SalesArea__c i : salesAreaList){
            if(MapGroup.containskey(i.SalesOrganization__c + i.AccountNumber__r.AccountNumber__c)){
                Set<string> UserIdList = MapGroup.get(i.SalesOrganization__c + i.AccountNumber__r.AccountNumber__c);
                if(saleGroupMap.containskey(i.SalesGroup__c)){
                    UserIdList.add(saleGroupMap.get(i.SalesGroup__c));
                }
            }else{
                Set<string>UserIdList = new Set<String>();
                if(saleGroupMap.containskey(i.SalesGroup__c)){
                    UserIdList.add(saleGroupMap.get(i.SalesGroup__c));
                }
                MapGroup.put(i.SalesOrganization__c + i.AccountNumber__r.AccountNumber__c,UserIdList);
            }
        }
        return MapGroup;
    }
    public static Map<String,Set<String>> GetIdParentSaleGroup(){
        Map<String,Set<String>> MapGroup = new Map<String,Set<String>>();
        Map<String,String> saleGroupRoleParentMap = new Map<String,String>();
        List<string> parentId = new List<string>();
        List<Master_Map__c> MasterList = [SELECT Id, Sales_Group__c, Sales_Rep__c,Sales_Rep__r.Email, Sales_Rep__r.UserRoleId, Sales_Rep__r.UserRole.ParentRoleId from Master_Map__c where Type__c = 'SalesMapwithSalesGroup'];
        for(Master_Map__c i : MasterList){
            saleGroupRoleParentMap.put(i.Sales_Group__c, i.Sales_Rep__r.UserRole.ParentRoleId);
            parentId.add(i.Sales_Rep__r.UserRole.ParentRoleId);
        }
        Map<String,Set<String>> parentUserMap = new  Map<String,Set<String>>();
        List<user> parentUser = [Select id ,UserRoleId ,Name from User where UserRoleId in:parentId];
        for(User i : parentUser){
            if(parentUserMap.containskey(i.UserRoleId)){
                Set<string> UserIdList = parentUserMap.get(i.UserRoleId);
                UserIdList.add(i.id);
            }else{
                Set<string> UserIdList = new Set<String>();
                UserIdList.add(i.id);
                parentUserMap.put(i.UserRoleId,UserIdList);
            }
        }
        Map<String,Set<String>> saleGroupParentMap = new Map<String,Set<String>>();
        for(string i : saleGroupRoleParentMap.keySet()){
            saleGroupParentMap.put(i,parentUserMap.get(saleGroupRoleParentMap.get(i)));
        }
        Map<String,String> saleAreaSaleGroupMap = new Map<String,String>();
        List<C360_SalesArea__c > salesAreaList = [SELECT Id,AccountNumber__r.AccountNumber__c,SalesOrganization__c,SalesGroup__c from C360_SalesArea__c Where SalesGroup__c != null];
        for(C360_SalesArea__c i : salesAreaList){
            saleAreaSaleGroupMap.put(i.SalesOrganization__c+i.AccountNumber__r.AccountNumber__c,i.SalesGroup__c);
        }
        for(String i : saleAreaSaleGroupMap.keySet()){
            MapGroup.put(i,saleGroupParentMap.get(saleAreaSaleGroupMap.get(i)));
        }
        return MapGroup;
    }
    public static Map<String,Set<String>> GetUserFromTopGroup(){
        Map<String,Set<String>> MapGroup = new Map<String,Set<String>>();
        list<string>groupName = new List<String>{'C360_Sales_Rep_1100','C360_Sales_Rep_1300','C360_Sales_Rep_1400','C360_Sales_Rep_1700'};
            for(string i :groupName){
                Set<string>UserEmailList = new Set<String>();
                UserEmailList = GetUserIdsFromGroup(i);
                MapGroup.put(i.right(4),UserEmailList);
            }
        return MapGroup;
    }
    public static Map<String,Set<String>> GetUserFromSolventGroup(){
        Map<String,Set<String>>MapGroup = new Map<String,Set<String>>();
        list<string>groupName = new List<String>{'C360_Customer_Service_TRDF_2000','C360_Customer_Service_TRDL_2000','C360_Customer_Service_9100','C360_Customer_Service_9200','C360_Customer_Service_9300'};
            for(string i :groupName){
                if(MapGroup.containskey(i.right(4))){
                    Set<string> UserEmailList = MapGroup.get(i.right(4));
                    UserEmailList.addAll(GetUserIdsFromGroup(i));
                }else{
                    Set<string>UserEmailList = new Set<String>();
                    UserEmailList = GetUserIdsFromGroup(i);
                    MapGroup.put(i.right(4),UserEmailList);
                }
            }
        return MapGroup;
    }
    public static Set<String> GetUserIdsFromGroup(String groupName){
        Set<String> result=new Set<String>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<Id> groupIdProxys = new Set<Id>();
        for(GroupMember m : [Select Id, UserOrGroupId, Group.Type, Group.RelatedId From GroupMember Where Group.DeveloperName =:groupName]){
            if(((String)m.UserOrGroupId).startsWith(userType)){
                result.add(m.UserOrGroupId);
            }
            else if (((String)m.UserOrGroupId).startsWith(groupType)){
                groupIdProxys.add(m.userOrGroupId);
            }
        }
        if(groupIdProxys.size() > 0){
            Set<id> groupId = new set<id>();
            Set<id> roleId = new set<id>();
            Set<id> roleAndSubId = new set<Id>();
            for(Group g2 : [Select Id, Type, relatedId From Group Where Id = :groupIdProxys]){
                if(g2.Type == 'Role'){
                    roleId.add(g2.relatedId);
                }else if(g2.Type== 'RoleAndSubordinates'){
                    roleAndSubId.add(g2.relatedId);
                }else if(g2.Type== 'PRMOrganization'){
                    roleId.add(g2.relatedId);
                }else if(g2.Type== 'Regular'){
                    groupId.add(g2.id);
                }
            }
            if(roleAndSubId.size()>0){
                roleId.addAll(getAllSubRoleIds(roleAndSubId));
            }
            if(roleId.size()>0){
                for(User u: [select id from user where UserRoleId IN: roleId and IsActive = True]){
                    result.add(u.id);
                }
            }
            if(groupId.size()>0){
                for(GroupMember gm : [select id, UserOrGroupId from GroupMember where GroupId IN: groupId]){
                    result.add(gm.UserOrGroupId);
                }
            }
        }
        return result;
    }
    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds){
        Set<ID> currentRoleIds = new Set<ID>();
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null limit 40000])
            currentRoleIds.add(userRole.Id);
        if(currentRoleIds.size() > 0)
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        return currentRoleIds;
    }
}