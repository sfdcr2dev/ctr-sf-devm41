public with sharing class OPP_AribaController {

    public class Token{
        public String timeUpdated;
        public String access_token;
        public String refresh_token;
        public String token_type;
        public String scope;
        public String expires_in;
    }

    public class Approvable{
        public String uniqueName;
        public String documentType;
        public String description;
        public String assignedDate;
        public String approver;
        public String email;
        public String fullURL;
        public String[] attachments;
        public Boolean hasNotification;

        public Boolean isEqualToOPPNotification(OPP_Notification__c oppNotification){
            return this.isEqualToOPPNotification(oppNotification, false);
        }

        public Boolean isEqualToOPPNotification(OPP_Notification__c oppNotification, Boolean disableCheckEmailComparison){
            if(disableCheckEmailComparison){
                return (this.uniqueName.trim() == oppNotification.ReferenceID__c.trim());
            }else{
                return (this.uniqueName.trim() == oppNotification.ReferenceID__c.trim())
                    && (this.email.trim().toLowerCase() == oppNotification.Username__c.trim().toLowerCase());
            }
        }
    }

    private static String aribaApplicationName = '';
    private static String aribaSalesforceId = '';
    private static String aribaPasswordAdapter = '';
    private static String authorizationEndpoint = '';
    private static String pendingApprovablesEndpoint = '';
    private static String realm = '';
    private static String applicationKey = '';
    private static String clientId = '';
    private static String clientSecret = '';
    private static String accessToken = '';
    private static String grantType = '';
    private static Boolean disableCheckEmailComparison = false;
    //private static String documentType = '';
    //private static String limitRow = '';
    //private static String offset = '';
    private static Http http = null;

    @AuraEnabled
    public static void getMyPendingApprovables(){
        syncNotifications();
    }

    @AuraEnabled
    public static void syncNotifications(){
        try {
            Id userId = UserInfo.getUserId();
            String aribaUser = getAribaUser(userId);

            if (String.isBlank(aribaUser)){
                return;
            }

            initialize();

            String[] params = new List<String>();
            if (String.isNotBlank(aribaUser)) {
                params.add('user=' + EncodingUtil.urlEncode(aribaUser.toLowerCase(), 'UTF-8'));
            }
           // System.debug('aribaUser: ' + aribaUser);
            //params.add('user=phongsan');
            if (String.isNotBlank(aribaPasswordAdapter)) {
                params.add('passwordAdapter=' + EncodingUtil.urlEncode(aribaPasswordAdapter, 'UTF-8'));
            }
            //if (String.isNotBlank(documentType)) {
            //    params.add('documentType=' + EncodingUtil.urlEncode(documentType, 'UTF-8'));
            //}
            //if (String.isNotBlank(limitRow)) {
            //    params.add('limit=' + EncodingUtil.urlEncode(limitRow, 'UTF-8'));
            //}
            //if (String.isNotBlank(offset)) {
            //    params.add('offset=' + EncodingUtil.urlEncode(offset, 'UTF-8'));
            //}

            HttpRequest requestPendingApprovables = new HttpRequest();
            requestPendingApprovables.setEndpoint(pendingApprovablesEndpoint + '?realm=' + realm + '&' + String.join(params, '&'));
            requestPendingApprovables.setHeader('Accept', '*/*');
            requestPendingApprovables.setHeader('Content-Type', 'application/json');
            requestPendingApprovables.setHeader('apiKey', applicationKey);
            requestPendingApprovables.setHeader('Authorization', 'Bearer ' + accessToken);
            requestPendingApprovables.setMethod('GET');
            HttpResponse responsePendingApprovables = http.send(requestPendingApprovables);

            List<Approvable> approvables = (List<Approvable>)JSON.deserialize(responsePendingApprovables.getBody(), List<Approvable>.class);
            List<OPP_Notification__c> oppNotifications = getNotifications(userId);
            Map<String, Id> users = getMapUserEmailToId(approvables);
            List<OPP_Notification__c> insertList = new List<OPP_Notification__c>();
            List<OPP_Notification__c> updateList = new List<OPP_Notification__c>();
            List<OPP_Notification__c> deleteList = new List<OPP_Notification__c>();
            List<Approvable> errorList = new List<Approvable>();

            for (Approvable approvable : approvables) {

                approvable.hasNotification = false;
                for (OPP_Notification__c oppNotification : oppNotifications) {
                    if (approvable.isEqualToOPPNotification(oppNotification, disableCheckEmailComparison)) {
                        oppNotification.Subject__c = approvable.description;
                        //oppNotification.Description__c = approvable.description;
                        oppNotification.URL__c = approvable.fullURL;
                        updateList.add(oppNotification);
                        approvable.hasNotification = true;
                        break;
                    }
                }

                if (!approvable.hasNotification) {
                    if (disableCheckEmailComparison || users.containsKey(approvable.email.trim().toLowerCase())) {
                        OPP_Notification__c oppNotification = new OPP_Notification__c();
                        oppNotification.ApplicationName__c = aribaApplicationName;
                        oppNotification.Application__c = aribaSalesforceId;
                        oppNotification.Subject__c = approvable.description;
                        //oppNotification.Description__c = approvable.description;
                        oppNotification.UserName__c = approvable.email;
                        //oppNotification.User__c = users.get(approvable.email.trim().toLowerCase());
                        oppNotification.User__c = userId;
                        oppNotification.ReferenceID__c = approvable.uniqueName;
                        oppNotification.URL__c = approvable.fullURL;
                        oppNotification.Status__c = 'New';

                        insertList.add(oppNotification);
                    } else {
                        errorList.add(approvable);
                    }
                }
            }

            for(OPP_Notification__c oppNotification : oppNotifications){
                Boolean hasApprovables = false;
                for (Approvable approvable : approvables) {
                    if (approvable.isEqualToOPPNotification(oppNotification)){
                        hasApprovables = true;
                        break;
                    }
                }
                if (!hasApprovables) {
                    oppNotification.Status__c = 'Done';
                    deleteList.add(oppNotification);
                }
            }
          //  System.debug(insertList);
          //  System.debug(updateList);
          //  System.debug(deleteList);
          //  System.debug(errorList);
            insert insertList;
            //update updateList;
            update deleteList;
        } catch(Exception e) {
            System.debug(e);
        }
    }

    @AuraEnabled
    public static List<Approvable> fetchPendingApprovables(String aribaUser) {
        try {
            initialize();

            String[] params = new List<String>();
            if (String.isNotBlank(aribaUser)){
                params.add('user=' + EncodingUtil.urlEncode(aribaUser.toLowerCase(), 'UTF-8'));
            }
            if (String.isNotBlank(aribaPasswordAdapter)) {
                params.add('passwordAdapter=' + EncodingUtil.urlEncode(aribaPasswordAdapter, 'UTF-8'));
            }

            HttpRequest requestPendingApprovables = new HttpRequest();
            requestPendingApprovables.setEndpoint(pendingApprovablesEndpoint + '?realm=' + realm + '&' + String.join(params, '&'));
            requestPendingApprovables.setHeader('Accept', '*/*');
            requestPendingApprovables.setHeader('Content-Type', 'application/json');
            requestPendingApprovables.setHeader('apiKey', applicationKey);
            requestPendingApprovables.setHeader('Authorization', 'Bearer ' + accessToken);
            requestPendingApprovables.setMethod('GET');
            HttpResponse responsePendingApprovables = http.send(requestPendingApprovables);
            List<Approvable> approvables = (List<Approvable>)JSON.deserialize(responsePendingApprovables.getBody(), List<Approvable>.class);
            return approvables;
        } catch(Exception e) {
            //System.debug(e);
            return new List<Approvable>();
        }
    }

    private static void initialize() {
        OPPIntegration__c oppIntegration = OPPIntegration__c.getInstance();
        aribaApplicationName = oppIntegration.Ariba_Application_Name__c;
        aribaSalesforceId = getAribaSalesforceId(oppIntegration.Ariba_Application_Name__c);
        aribaPasswordAdapter = oppIntegration.Ariba_Password_Adapter__c;
        authorizationEndpoint = oppIntegration.Ariba_Authorization_Endpoint__c;
        pendingApprovablesEndpoint = oppIntegration.Ariba_Pending_Approvables_Endpoint__c;
        realm = oppIntegration.Ariba_Realm__c;
        applicationKey = oppIntegration.Ariba_Application_Key__c;
        clientId = oppIntegration.Ariba_Client_Id__c;
        clientSecret = oppIntegration.Ariba_Client_Secret__c;
        grantType = oppIntegration.Ariba_Grant_Type__c;
        disableCheckEmailComparison = oppIntegration.Ariba_Disable_Check_Email_Comparison__c;
        http = new Http();
        accessToken = getAccessToken();
    }

    private static String getAccessToken() {
        HttpRequest requestAccessToken = new HttpRequest();
        requestAccessToken.setEndpoint(authorizationEndpoint);
        requestAccessToken.setHeader('Accept', '*/*');
        requestAccessToken.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret)));
        requestAccessToken.setMethod('POST');
        requestAccessToken.setBody('grant_type=' + grantType);
        HttpResponse responseAccessToken = http.send(requestAccessToken);
        Token token = (Token)JSON.deserialize(responseAccessToken.getBody(), Token.class);
        return token.access_token;
    }

    private static List<OPP_Notification__c> getNotifications(Id userId){
        return [SELECT Id, Username__c,ReferenceID__c,Status__c FROM OPP_Notification__c WHERE Application__c = :aribaSalesforceId AND User__c = :userId AND Status__c = 'New'];
    }

    private static Id getAribaSalesforceId(String name){
        OPP_Application__c oppApplication = [SELECT Id FROM OPP_Application__c WHERE Name = :name LIMIT 1];
        return oppApplication.Id;
    }

    private static String getAribaUser(Id userId){
        String aribaUser = '';
        User user = [SELECT Id, Username, FederationIdentifier FROM User WHERE Id = :userId LIMIT 1];
        if(user != null){
            if(!String.isBlank(user.FederationIdentifier)){
                aribaUser = user.FederationIdentifier.substring(0, user.FederationIdentifier.indexOf('@'));
            }else{
            	aribaUser = user.Username.substring(0, user.Username.indexOf('@'));
            }
        }
        return aribaUser;
        // END FOR_PRODUCTION
    }

    private static Map<String, Id> getMapUserEmailToId(List<Approvable> approvables){
        Set<String> emailSet = new Set<String>();
        for(Approvable approvable : approvables){
            emailSet.add(approvable.email.trim().toLowerCase());
        }

        Map<String, Id> users = new Map<String, Id>();
        for (User user : [SELECT Id, Username FROM User WHERE Username = :emailSet]){
            users.put(user.Username.trim().toLowerCase(), user.Id);
        }
        return users;
    }
}