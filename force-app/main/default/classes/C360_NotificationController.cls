public class C360_NotificationController{
    public static void overOutstandingSolvent(){
        Map<String,Set<String>> MapEmailList = GetEmailSaleGroup();
        List<C360_FinancialInfo__c> fiList = [SELECT Id,Outstanding__c,CreditBalance__c,CompanyCode__c,notified__c,CompanyName__r.AccountNumber__c from C360_FinancialInfo__c Where OutstandingAlert__c = true and CompanyCode__c in ('2000','9100','9200','9300')];
        string contactTargetId = [SELECT Id from contact limit 1].id;
        string emailTemplateId =[Select Id from EmailTemplate where DeveloperName ='Financial_Info_Outstanding_Alert'].id;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<C360_FinancialInfo__c> updateListFi = new List<C360_FinancialInfo__c>();
        for(C360_FinancialInfo__c FiItem : fiList){
            C360_FinancialInfo__c updateFi = new C360_FinancialInfo__c();
            List<string> emailList = new List<string>();
            if(MapEmailList.containskey(FiItem.CompanyCode__c + FiItem.CompanyName__r.AccountNumber__c)){
                emailList.addAll(MapEmailList.get(FiItem.CompanyCode__c + FiItem.CompanyName__r.AccountNumber__c));
            }
            mails.add(sendNotification(FiItem.Id,emailList,contactTargetId,emailTemplateId));
            updateFi.id = FiItem.id;
            updateFi.notified__c = True;
            updateListFi.add(updateFi);
        }
        if(updateListFi.size()>0 && mails.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }
    }
    public static void overOutstandingTop(){
        Map<String,Set<String>> MapEmailList = GetEmailSaleGroup();
        List<C360_FinancialInfo__c> fiList = [SELECT Id,Outstanding__c,CreditBalance__c,CompanyCode__c,notified__c,CompanyName__r.AccountNumber__c from C360_FinancialInfo__c Where OutstandingAlert__c = true and CompanyCode__c in ('1100','1300','1400','1700')];
        string contactTargetId = [SELECT Id from contact limit 1].id;
        string emailTemplateId = [Select Id from EmailTemplate where DeveloperName ='Financial_Info_Outstanding_Alert'].id;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Map<String,List<String>> MapGroup = GetUserFromGroup();
        List<C360_FinancialInfo__c> updateListFi = new List<C360_FinancialInfo__c>();
        for(C360_FinancialInfo__c FiItem : fiList){
            C360_FinancialInfo__c updateFi = new C360_FinancialInfo__c();
            mails.add(sendNotification(FiItem.Id,MapGroup.get(FiItem.CompanyCode__c),contactTargetId,emailTemplateId));
            updateFi.id = FiItem.id;
            updateFi.notified__c = True;
            updateListFi.add(updateFi);
        }
        if(updateListFi.size()>0 && mails.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }
    }
    public static void BGRemainingDaysSolvent(){
        List<C360_BankGuarantee__c> bgList = [SELECT Id,RemainingDays__c,CompanyCode__c,Customer__r.AccountNumber__c from C360_BankGuarantee__c Where RemainingDays__c <= 60 and RemainingDays__c != null and CompanyCode__c in ('2000','9100','9200','9300')];
        string contactTargetId = [SELECT Id from contact limit 1].id;
        string emailTemplateId =[Select Id from EmailTemplate where DeveloperName ='BankGuaranteeNotification'].id;
        Map<String,Set<String>> MapEmailList = GetEmailSaleGroup();
        Map<String,Set<String>> MapEmailListFinance = GetUserFinance();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(C360_BankGuarantee__c BgItem : bgList){
            if(BgItem.RemainingDays__c <= 60){
                List<string> emailList = new List<string>();
                if(MapEmailList.containskey(BgItem.CompanyCode__c+BgItem.Customer__r.AccountNumber__c)){
                    emailList.addAll(MapEmailList.get(BgItem.CompanyCode__c+BgItem.Customer__r.AccountNumber__c));
                }
                if(MapEmailListFinance.containskey(BgItem.CompanyCode__c)){
                    emailList.addAll(MapEmailListFinance.get(BgItem.CompanyCode__c));
                }
                mails.add(sendNotification(BgItem.Id,emailList,contactTargetId,emailTemplateId));
            }
        }
        if(mails.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }
    }
    public static void BGRemainingDaysTop(){
        List<C360_BankGuarantee__c> bgList = [SELECT Id,RemainingDays__c,CompanyCode__c,Customer__r.AccountNumber__c from C360_BankGuarantee__c Where RemainingDays__c <= 60 and RemainingDays__c != null and CompanyCode__c in ('1100','1300','1400','1700')];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        string contactTargetId = [SELECT Id from contact limit 1].id;
        string emailTemplateId =[Select Id from EmailTemplate where DeveloperName ='BankGuaranteeNotification'].id;
        Map<String,List<String>> MapGroup = GetUserFromGroup();
        Map<String,Set<String>> MapEmailListFinance = GetUserFinance();
        for(C360_BankGuarantee__c BgItem : bgList){
            if(BgItem.RemainingDays__c == 30||BgItem.RemainingDays__c == 60){
                list<string>emailList = new list<string>();
                if(MapEmailListFinance.containskey(BgItem.CompanyCode__c)){
                    emailList.addAll(MapEmailListFinance.get(BgItem.CompanyCode__c));
                }
                emailList.addAll(MapGroup.get(BgItem.CompanyCode__c));
                mails.add(sendNotification(BgItem.Id,emailList,contactTargetId,emailTemplateId));
            }
        }
        if(mails.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }
    }
    public static void exciseQuotaSolvent(){
        List<C360_ExciseQuota__c> eqList = [SELECT Id,RemainingDays__c,SalesOrganization__c,CompanyName__r.AccountNumber__c from C360_ExciseQuota__c Where RemainingDays__c <= 60 and RemainingDays__c != null and SalesOrganization__c in ('2000','9100','9200','9300')];
        string contactTargetId = [SELECT Id from contact limit 1].id;
        string emailTemplateId =[Select Id from EmailTemplate  where DeveloperName ='ExciseQuotaNotification'].id;
        Map<String,Set<String>> MapEmailList = GetEmailSaleGroup();
        Map<String,List<String>> MapGroup = GetUserFromGroup();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(C360_ExciseQuota__c EqItem : eqList){
            if(EqItem.RemainingDays__c == 60 ||EqItem.RemainingDays__c == 30){
                list<string>emailList = new list<string>();
                if(MapEmailList.containskey(EqItem.SalesOrganization__c+EqItem.CompanyName__r.AccountNumber__c)){
                    emailList.addAll(MapEmailList.get(EqItem.SalesOrganization__c+EqItem.CompanyName__r.AccountNumber__c));
                }
                emailList.addall(MapGroup.get(EqItem.SalesOrganization__c));
                mails.add(sendNotification(EqItem.Id,emailList,contactTargetId,emailTemplateId));
            }
        }
        if(mails.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }
    }
    public static Messaging.SingleEmailMessage sendNotification(Id recordId,List<string> MapGroup,string contactTargetId,string emailTemplateId){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(contactTargetId);
        message.setWhatId(recordId);
        message.setTemplateID(emailTemplateId);
        message.toAddresses = MapGroup;
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        return message;
    }
    public static Map<String,List<String>> GetUserFromGroup(){
        Map<String,List<String>> MapGroup = new Map<String,List<String>>();
        List<string> groupName = new List<String>{'C360_Sales_Rep_1100','C360_Sales_Rep_1300','C360_Sales_Rep_1400','C360_Sales_Rep_1700','C360_Customer_Service_TRDF_2000','C360_Customer_Service_TRDL_2000','C360_Customer_Service_9100','C360_Customer_Service_9200','C360_Customer_Service_9300'};
            for(string i :groupName){
                if(MapGroup.containskey(i.right(4))){
                    list<string>UserEmailList = MapGroup.get(i.right(4));
                    UserEmailList.addAll(GetUserEmailsFromGroup(i));
                }else{
                    list<string>UserEmailList = new List<String>();
                    UserEmailList = GetUserEmailsFromGroup(i);
                    MapGroup.put(i.right(4),UserEmailList);
                }
                
            }
        return MapGroup;
    }
    public static List<String> GetUserEmailsFromGroup(String groupName){
        Set<String> result=new Set<String>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<Id> groupIdProxys = new Set<Id>();
        for(GroupMember m : [Select Id, UserOrGroupId, Group.Type, Group.RelatedId From GroupMember Where Group.DeveloperName =:groupName]){
            if(((String)m.UserOrGroupId).startsWith(userType)){
                result.add(m.UserOrGroupId);
            }else if (((String)m.UserOrGroupId).startsWith(groupType)){
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
        List<String> users = new List<String>();
        User[] usr = [SELECT email FROM user WHERE id IN :result];
        for(User u : usr) {
            users.add(u.email);
        }
        return users;
    }
    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds){
        Set<ID> currentRoleIds = new Set<ID>();
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null limit 40000])// get all of the roles underneath the passed roles
            currentRoleIds.add(userRole.Id);
        if(currentRoleIds.size() > 0)// go fetch some more rolls!
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        return currentRoleIds;
    }
    public static Map<String,Set<String>> GetEmailSaleGroup(){
        Map<String,Set<String>> MapGroup = new Map<String,Set<String>>();
        List<Master_Map__c> MasterList = new list<Master_Map__c>();
        Map<String,String> saleGroupMap = new Map<String,String>();
        MasterList = [SELECT Id, Sales_Group__c, Sales_Rep__c,Sales_Rep__r.Email from Master_Map__c where Type__c = 'SalesMapwithSalesGroup'];
        for(Master_Map__c i : MasterList){
            saleGroupMap.put(i.Sales_Group__c, i.Sales_Rep__r.Email);
        }
        List<C360_SalesArea__c> salesAreaList = [SELECT Id,AccountNumber__r.AccountNumber__c,SalesOrganization__c,SalesGroup__c from C360_SalesArea__c Where SalesGroup__c != null];
        for(C360_SalesArea__c i : salesAreaList){
            if(MapGroup.containskey(i.SalesOrganization__c + i.AccountNumber__r.AccountNumber__c) ){
                Set<string> UserEmailList = MapGroup.get(i.SalesOrganization__c + i.AccountNumber__r.AccountNumber__c);
                if(saleGroupMap.containskey(i.SalesGroup__c)){
                    UserEmailList.add(saleGroupMap.get(i.SalesGroup__c));
                }
            }else{
                Set<string>UserEmailList = new Set<String>();
                if(saleGroupMap.containskey(i.SalesGroup__c)){
                    UserEmailList.add(saleGroupMap.get(i.SalesGroup__c));
                }
                MapGroup.put(i.SalesOrganization__c + i.AccountNumber__r.AccountNumber__c,UserEmailList);
            }
        }
        return MapGroup;
    }
    public static Map<String,Set<String>> GetUserFinance(){
        Map<String,Set<String>> MapGroup = new Map<String,Set<String>>();
        List<C360_NotificationEmail__mdt> emailList = [Select SalesOrganization__c,Email__c from C360_NotificationEmail__mdt Where Type__c = 'finance'];
        for(C360_NotificationEmail__mdt i :emailList){
            if(MapGroup.containskey(i.SalesOrganization__c)){
                Set<string> UserEmailList = MapGroup.get(i.SalesOrganization__c);
                UserEmailList.add(i.Email__c);
            }else{
                Set<string>UserEmailList = new Set<String>();
                UserEmailList.add(i.Email__c);
                MapGroup.put(i.SalesOrganization__c,UserEmailList);
            }
        }
        return MapGroup;
    }
}