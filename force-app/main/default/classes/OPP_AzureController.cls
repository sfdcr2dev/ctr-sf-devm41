public class OPP_AzureController {
    private static String azureLoginEndpoint = '';
    private static String azureClientId = '';
    private static String azureClientSecret = '';
    private static String accessToken = '';
    private static String pendingApprovablesEndpoint = '';
    private static String env = '';
    private static String groupType = 'Private';
    private static Http http = null;
    public static void initialize() {
        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
        azureLoginEndpoint = oppIntegration.Azure_Login_Endpoint__c;
        azureClientId = oppIntegration.Azure_Client_Id__c;
        azureClientSecret = oppIntegration.Azure_Client_Secret__c;
        env = oppIntegration.Azure_Member_Environment__c;
        if(env == null){env = '';}
        http = new Http(); 
        accessToken = getAccessToken();
    }
    
    private static String getAccessToken() {
        HttpRequest requestAccessToken = new HttpRequest();
        requestAccessToken.setEndpoint(azureLoginEndpoint);
        requestAccessToken.setHeader('Accept', '*/*');
        requestAccessToken.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        requestAccessToken.setMethod('POST');
        requestAccessToken.setBody('client_id='+azureClientId+'&grant_type=client_credentials&client_secret='+azureClientSecret+'&scope=https://graph.microsoft.com/.default');
        HttpResponse responseAccessToken = http.send(requestAccessToken);
        Map<String, Object> tokenResults = (Map<String, Object>) JSON.deserializeUntyped(responseAccessToken.getBody());
        accessToken = (String)tokenResults.get('access_token');
        return accessToken;
    }
    
    @future(callout=true)
    public static void CreateMainGroup(){
        initialize();
        /////////// Get Endpoint ///////////
        List<String> apiCallouts = new List<String>();
        String endpoint;
        Set<String> mainGroups = new Set<String>();
        for(OPP_Azure_master_group__mdt obj : [SELECT Label FROM OPP_Azure_master_group__mdt]){
            mainGroups.add(obj.Label);
        }
        for(String mainGroup : mainGroups){
            String groupName = mainGroup; 
            groupName = groupName.replace(' ','%20');
            endpoint = 'https://graph.microsoft.com/v1.0/groups?$filter=displayName%20eq%20%27'+groupName+'%27&$top=999';
            apiCallouts.add(endpoint);
        }
        /////////// Get Endpoint ///////////
        /////////// Callouts ///////////
        List<CollaborationGroup> groupRecord = new List<CollaborationGroup>();
        for(String apiCallout : apiCallouts){
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiCallout);//B
            request.setHeader('Authorization', 'Bearer '+ accessToken);
            request.setHeader('Accept', '*/*');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> groups = (List<Object>)results.get('value');
            for(Object groupp: groups){
                String g = JSON.serialize(groupp);
                Map<String, Object> row = (Map<String, Object>) JSON.deserializeUntyped(g);
                String idGroup = JSON.serialize(row.get('id')); idGroup = idGroup.replace('"','');
                String displayName = JSON.serialize(row.get('displayName')); displayName = displayName.replace('"','');
                String mail = JSON.serialize(row.get('mail')); mail = mail.replace('"','');
                String mailNickname = JSON.serialize(row.get('mailNickname')); mailNickname = mailNickname.replace('"','');
                if (displayName.length() > 40){
                    displayName = displayName.substring(0,40);}
                if (mail.length() > 40){
                    mail = mail.substring(0,40);}
                if (mailNickname.length() > 30){
                    mailNickname = mailNickname.substring(0,30);}
                CollaborationGroup myGroup = new CollaborationGroup();
                myGroup.Name = displayName;//idGroup
                myGroup.Description = 'Main Group';//displayName;
                myGroup.InformationTitle = mailNickname;
                myGroup.InformationBody = idGroup;// + '/' + idg;
                myGroup.CollaborationType = groupType; //can be 'Public' or 'Private'    
                groupRecord.add(myGroup);
            }
        }
        /////////// Callouts ///////////
        /////////// Create Group ///////////
        List<CollaborationGroup> groupRecords = new List<CollaborationGroup>();
        List<CollaborationGroup> allGroups = [SELECT ID, Name FROM CollaborationGroup];
        Set<String> mapGroup = new Set<String>();
        for(CollaborationGroup groupp : allGroups){
            mapGroup.add(groupp.Name);
        }
        for(CollaborationGroup groupp : groupRecord){
            if(!mapGroup.contains(groupp.Name)){
                groupRecords.add(groupp);
                Insert groupRecords;
                groupRecords = new List<CollaborationGroup>();
            }    
        }
        /////////// Create Group ///////////
    }    
    @future(callout=true)
    public static void CreateSubGroup(){
        initialize();
        ////// List Main Group ////////
        List<String> apiCallouts = new List<String>();
        String endpoint;
        Set<String> mdtGroups = new Set<String>();
        for(OPP_Azure_master_group__mdt obj : [SELECT Label FROM OPP_Azure_master_group__mdt]){// WHERE Group_Type__c = 'Operation'
            mdtGroups.add(obj.Label);
        }
        List<CollaborationGroup> mainGroups = [SELECT Id, Name, InformationBody FROM CollaborationGroup WHERE Name IN :mdtGroups];//Description = 'Main Group'
        List<CollaborationGroup> groupRecord = new List<CollaborationGroup>();
        ////// List Main Group ////////
        List<CollaborationGroupMember> memberMainGroups = new List<CollaborationGroupMember>();
        for(CollaborationGroup mainGroup : mainGroups){
            endpoint = 'https://graph.microsoft.com/v1.0/groups/'+mainGroup.InformationBody+'/members/microsoft.graph.group/?$top=999';
            apiCallouts.add(endpoint);
            for(String api : apiCallouts){
                HttpRequest request = new HttpRequest();
                request.setEndpoint(api);//B
                request.setHeader('Authorization', 'Bearer '+ accessToken);
                request.setHeader('Accept', '*/*');
                request.setMethod('GET');
                HttpResponse response = http.send(request);
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> groups = (List<Object>)results.get('value');
                for(Object groupp: groups){
                    String g = JSON.serialize(groupp);
                    Map<String, Object> row = (Map<String, Object>) JSON.deserializeUntyped(g);
                    String idGroup = JSON.serialize(row.get('id')); idGroup = idGroup.replace('"','');	
                    String mail = JSON.serialize(row.get('mail')); mail = mail.replace('"','').toLowerCase();
                    String displayName = JSON.serialize(row.get('displayName')); displayName = displayName.replace('"','');
                    String mailNickname = JSON.serialize(row.get('mailNickname')); mailNickname = mailNickname.replace('"','');
                    CollaborationGroup myGroup = new CollaborationGroup();
                    myGroup.Name = displayName;
                    myGroup.Description = mainGroup.name;//Main Group;
                    myGroup.InformationTitle = mailNickname;
                    myGroup.InformationBody = idGroup;
                    myGroup.CollaborationType = groupType; //can be 'Public' or 'Private'    
                    groupRecord.add(myGroup);
                }
            }
            apiCallouts = new List<String>();
        }
        
        List<CollaborationGroup> groupRecords = new List<CollaborationGroup>();
        List<CollaborationGroup> allGroups = [SELECT ID, Name, Description FROM CollaborationGroup];
        Set<String> mapGroup = new Set<String>();
        for(CollaborationGroup groupp : allGroups){
            mapGroup.add(groupp.Name);
        }
        for(CollaborationGroup groupp : groupRecord){
            if(!mapGroup.contains(groupp.Name)){
                groupRecords.add(groupp);
                Insert groupRecords;
                groupRecords = new List<CollaborationGroup>();
            }
        }
    }
    
    @future(callout=true)
    public static void CreateMemberGroup(String type){
        initialize();
        ////////// List Main Groups //////////
        Set<String> mainGroups = new Set<String>();
        for(OPP_Azure_master_group__mdt obj : [SELECT Label FROM OPP_Azure_master_group__mdt]){
            mainGroups.add(obj.Label);
        }
        ////////// List Main Groups //////////
        ////// List User Salesforce ////////
        Map<String, Id> users = new Map<String, Id>();
        for (User user : [SELECT Id, Username FROM User where IsActive = TRUE]) {
            users.put(user.Username.toLowerCase(), user.Id);
        }
        Map<Id, Set<Id>> membersInGroup = new Map<Id,Set<Id>>();
        for (CollaborationGroupMember memberInGroup : [SELECT MemberId , CollaborationGroupId  
                                                       FROM CollaborationGroupMember]) {
                                                           if (membersInGroup.containsKey(memberInGroup.MemberId)) {
                                                               Set<Id> s = membersInGroup.get(memberInGroup.MemberId);
                                                               s.add(memberInGroup.CollaborationGroupId);
                                                           } else {
                                                               Set<Id> s = new Set<Id>();
                                                               s.add(memberInGroup.CollaborationGroupId);
                                                               membersInGroup.put(memberInGroup.MemberId, s);
                                                           }
                                                       }
        ////// List User Salesforce ////////
        ////// List Group ////////
        List<CollaborationGroup> groups = new List<CollaborationGroup>();
        if(type == 'Main'){
            groups = new List<CollaborationGroup>([SELECT Id, Name, InformationBody FROM CollaborationGroup WHERE Name in: mainGroups]);
        }else if(type == 'Sub'){
        	groups = new List<CollaborationGroup>([SELECT Id, Name, InformationBody FROM CollaborationGroup WHERE Description in: mainGroups LIMIT 95]);
        }  
        List<CollaborationGroupMember> memberRecord = new List<CollaborationGroupMember>();
        for(CollaborationGroup groupp : groups){
        	List<String> apiCallouts = new List<String>();
            Set<Id> setMember = new Set<Id>();
            String endpoint = 'https://graph.microsoft.com/v1.0/groups/'+groupp.InformationBody+'/members/microsoft.graph.user/?$select=id,displayName,mail&$count=true&$top=999';
            apiCallouts.add(endpoint);
            //Integer i = 0;
            for(String api : apiCallouts){
                HttpRequest request = new HttpRequest();
                request.setEndpoint(api);//B
                request.setHeader('Authorization', 'Bearer '+ accessToken);
                request.setHeader('Accept', '*/*');
                request.setMethod('GET');
                HttpResponse response = http.send(request);
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> members = (List<Object>)results.get('value');
                for(Object member: members){
                    String g = JSON.serialize(member);
                    Map<String, Object> row = (Map<String, Object>) JSON.deserializeUntyped(g);
                    String mail = JSON.serialize(row.get('mail')); mail = mail.replace('"','').toLowerCase();
                    mail = mail + env;
                    Set<String> mapMember = new Set<String>();
                    //if(type == '#microsoft.graph.user'){
                    if (users.containsKey(mail)) {
                        Set<Id> setGroup = membersInGroup.get(users.get(mail));
                        if(setGroup == null || !setGroup.contains(groupp.Id)){    
                            setMember.add(users.get(mail));
                        }
                    }
                }
            }
            for(Id memberGroup : setMember){
                //setMember.add(member.MemberId);
                CollaborationGroupMember memberr = new CollaborationGroupMember();
                memberr.CollaborationGroupId = groupp.Id;
                memberr.MemberId = memberGroup;
                memberRecord.add(memberr);
            }
        }
        Insert memberRecord;
    }
    public static void CreateMemberGroup(List<Id> groupId){
        initialize();
        ////////// List Main Groups //////////
        Set<String> mainGroups = new Set<String>();
        for(OPP_Azure_master_group__mdt obj : [SELECT Label FROM OPP_Azure_master_group__mdt]){
            mainGroups.add(obj.Label);
        }
        ////////// List Main Groups //////////
        ////// List User Salesforce ////////
        Map<String, Id> users = new Map<String, Id>();
        for (User user : [SELECT Id,Username FROM User where IsActive = TRUE]) {
            users.put(user.Username.toLowerCase(), user.Id);
        }
   
        Map<Id, Set<Id>> membersInGroup = new Map<Id,Set<Id>>();
        for (CollaborationGroupMember memberInGroup:[SELECT MemberId,CollaborationGroupId FROM CollaborationGroupMember]) {
            if (membersInGroup.containsKey(memberInGroup.MemberId)) {
                Set<Id> s = membersInGroup.get(memberInGroup.MemberId);
                s.add(memberInGroup.CollaborationGroupId);
            } else {
                Set<Id> s = new Set<Id>();
                s.add(memberInGroup.CollaborationGroupId);
                membersInGroup.put(memberInGroup.MemberId, s);
            }
        }
        ////// List User Salesforce ////////
        ////// List Group ////////
        List<CollaborationGroup> groups = new List<CollaborationGroup>();
        groups = new List<CollaborationGroup>([SELECT Id, Name, InformationBody FROM CollaborationGroup WHERE Id in: groupId]);
        List<CollaborationGroupMember> memberRecord = new List<CollaborationGroupMember>();
        for(CollaborationGroup groupp : groups){
            if(groupp.InformationBody != null){
        	List<String> apiCallouts = new List<String>();
            Set<Id> setMember = new Set<Id>();
            String endpoint = 'https://graph.microsoft.com/v1.0/groups/'+groupp.InformationBody+'/members/microsoft.graph.user/?$select=id,displayName,mail&$count=true&$top=999';
            apiCallouts.add(endpoint);
            for(String api : apiCallouts){
                HttpRequest request = new HttpRequest();
                request.setEndpoint(api);//B
                request.setHeader('Authorization', 'Bearer '+ accessToken);
                request.setHeader('Accept', '*/*');
                request.setMethod('GET');
                HttpResponse response = http.send(request);
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> members = (List<Object>)results.get('value');
                if (members.size() > 0){
                for(Object member: members){
                    String g = JSON.serialize(member);
                    Map<String, Object> row = (Map<String, Object>) JSON.deserializeUntyped(g);
                    String mail = JSON.serialize(row.get('mail')); mail = mail.replace('"','').toLowerCase();
                    mail = mail + env;
                    Set<String> mapMember = new Set<String>();
                    if (users.containsKey(mail)) {
                        Set<Id> setGroup = membersInGroup.get(users.get(mail));
                        if(setGroup == null || !setGroup.contains(groupp.Id)){     
                            setMember.add(users.get(mail));
                        }
                    }
                }
             }
           }
            for(Id memberGroup : setMember){
                CollaborationGroupMember memberr = new CollaborationGroupMember();
                memberr.CollaborationGroupId = groupp.Id;
                memberr.MemberId = memberGroup;
                memberRecord.add(memberr);
            }
           }
        }
        Insert memberRecord;
    }
    public static void UpdateMemberMainGroup(){
        Set<String> mainGroups = new Set<String>();
        for(OPP_Azure_master_group__mdt obj : [SELECT Label FROM OPP_Azure_master_group__mdt]){
            mainGroups.add(obj.Label);
        }
        List<CollaborationGroupMember> recordMembers = new List<CollaborationGroupMember>();
        Map<String, Id> mapGroup = new Map<String, Id>();
        for(CollaborationGroup Groups : [SELECT Name , Id FROM CollaborationGroup where Description = 'Main Group']){
            mapGroup.put(Groups.Name, Groups.Id);
        }
        Map<String, Set<Id>> membersGroup = new Map<String,Set<Id>>();
        for(CollaborationGroupMember memberInGroup:[SELECT MemberId,CollaborationGroupId,CollaborationGroup.Name,CollaborationGroup.Description FROM CollaborationGroupMember WHERE CollaborationGroup.Name IN:mainGroups]){
            if(membersGroup.containsKey(memberInGroup.CollaborationGroup.Name)){
                Set<Id> s = membersGroup.get(memberInGroup.CollaborationGroup.Name);
                s.add(memberInGroup.MemberId);
            }else{
                Set<Id> s = new Set<Id>();
                s.add(memberInGroup.MemberId);
                membersGroup.put(memberInGroup.CollaborationGroup.Name, s);
            }
          }
        Map<String, Set<Id>> membersSubGroup = new Map<String, Set<Id>>();
        for(CollaborationGroupMember memberInGroup:[SELECT MemberId,CollaborationGroupId,CollaborationGroup.Name,CollaborationGroup.Description FROM CollaborationGroupMember WHERE CollaborationGroup.Description IN: mainGroups]){
            if(membersSubGroup.containsKey(memberInGroup.CollaborationGroup.Description)){
                Set<Id> s = membersSubGroup.get(memberInGroup.CollaborationGroup.Description);
                s.add(memberInGroup.MemberId);
            }else{
                Set<Id> s = new Set<Id>();
                s.add(memberInGroup.MemberId);
                membersSubGroup.put(memberInGroup.CollaborationGroup.Description, s);
            }
        }
        for(String mainGroup : membersSubGroup.keySet()){
            if(membersGroup.containsKey(mainGroup)){
                Set<Id> memberSub = membersSubGroup.get(mainGroup);
            	Set<Id> memberMain = membersGroup.get(mainGroup);
                memberSub.removeAll(memberMain);
            }
        }
		for(String maingroup : membersSubGroup.keySet()){
            Set<Id> members = membersSubGroup.get(maingroup);
            Id idGroup = mapGroup.get(maingroup);
            for(Id member : members){
            	CollaborationGroupMember newMember = new CollaborationGroupMember();
                if(idGroup!=null){
                    newMember.CollaborationGroupId = idGroup;
                    newMember.MemberId = member;
                    recordMembers.add(newMember);
                }
            }
        }
        Insert recordMembers;
    }
}