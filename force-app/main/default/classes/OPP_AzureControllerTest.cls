@isTest
public class OPP_AzureControllerTest {
	public class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            if (request.getEndpoint().startsWithIgnoreCase('https://login.microsoftonline.com/894f6e4e-e59c-47ff-be1e-b63a852cfb53/oauth2/v2.0/token')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "token_type": "Bearer", "expires_in": 3599, "ext_expires_in": 3599, "access_token": "123"}');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().startsWithIgnoreCase('https://graph.microsoft.com/v1.0/groups?')) {
                if (request.getEndpoint().startsWithIgnoreCase('https://graph.microsoft.com/v1.0/groups?$filter=displayName%20eq%20%27TOP%20GROUP%20R2%27&$top=999')){
                    HTTPResponse response = new HTTPResponse();
                    response.setBody('{ "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#groups(id,displayName,mailNickname,mail,description,visibility)", "value": [ { "id": "m1", "displayName": "TOP GROUP R2", "mailNickname": "TOPGROUPR2", "mail": "TOPGROUPR2@thaioilgroup.com", "description": null, "visibility": null } ] }');
                    response.setStatusCode(200);
                    return response;
                } else {
                    HTTPResponse response = new HTTPResponse();
                    response.setBody('{ "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#groups(id,displayName,mailNickname,mail,description,visibility)", "value": [] }');
                    response.setStatusCode(200);
                    return response;
                }
                
            } else if (request.getEndpoint().startsWithIgnoreCase('https://graph.microsoft.com/v1.0/groups/')) {
                if (request.getEndpoint().startsWithIgnoreCase('https://graph.microsoft.com/v1.0/groups/m1/members/microsoft.graph.group/?$top=999')){
                    HTTPResponse response = new HTTPResponse();
                    response.setBody('{"@odata.context": "https://graph.microsoft.com/v1.0/$metadata#groups",  "value": [ { "id": "s1",  "displayName": "TOP GROUP R2IN",  "mail": "TOPGROUPR2IN@thaioilgroup.com",  "mailNickname": "TOPGROUPR2IN",  "onPremisesNetBiosName": "THAIOILNT", "onPremisesSamAccountName": "TOP GROUP R2IN" } ] }');
                    response.setStatusCode(200);
                    return response;
                
                } else if (request.getEndpoint().startsWithIgnoreCase('https://graph.microsoft.com/v1.0/groups/m1/members/microsoft.graph.user/?$select=id,displayName,mail&$count=true&$top=999')){
                    HTTPResponse response = new HTTPResponse();
                    response.setBody('{"@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users","value": [{"displayName": "TOP DGFA (Sakowrat2)","givenName": "Sakowrat2","mail": "Sakowrat2@thaioilgroup.com","mobilePhone": "081-782-9459","userPrincipalName": "Sakowrat2@thaioilgroup.com","id": "s1" }] }');
                    response.setStatusCode(200);
                    return response;
                
                } else if (request.getEndpoint().startsWithIgnoreCase('https://graph.microsoft.com/v1.0/groups/1234/members/microsoft.graph.user/?$select=id,displayName,mail&$count=true&$top=999')){
                    HTTPResponse response = new HTTPResponse();
                    response.setBody('{"@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users","value": [{"displayName": "TOP DGFA (Sakowrat2)","givenName": "Sakowrat2","mail": "Sakowrat2@thaioilgroup.com","mobilePhone": "081-782-9459","userPrincipalName": "Sakowrat2@thaioilgroup.com","id": "s2" }] }');
                    response.setStatusCode(200);
                    return response;
                
                } else {
                    HTTPResponse response = new HTTPResponse();
                    response.setBody('{ "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#groups(id,displayName,mailNickname,mail,description,visibility)", "value": [] }');
                    response.setStatusCode(200);
                    return response;
                }
            } else {
                System.assert(false, 'unexpected endpoint ' + request.getEndpoint());
                return null;
            }
        }
    }
    //
    @TestSetup
    static void setup() {
        OPPIntegration__c oppIntegration = new OPPIntegration__c();
        oppIntegration.Azure_Login_Endpoint__c = 'https://login.microsoftonline.com/894f6e4e-e59c-47ff-be1e-b63a852cfb53/oauth2/v2.0/token';
        oppIntegration.Azure_Client_Id__c = '3434b981-dce0-4fcd-bd2c-86356881f534';
        oppIntegration.Azure_Client_Secret__c = 'qF4ymdlZY~57Q4B2s1XCkWI0~_SDvFko~J';
        insert oppIntegration;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User user1 = new User();
        user1.UserName = 'Sakowrat2@thaioilgroup.com';
        user1.Email = 'Sakowrat2@thaioilgroup.com';
        user1.EmailEncodingKey = 'UTF-8';
        user1.LanguageLocaleKey = 'en_US';
        user1.LocaleSidKey = 'en_US';
        user1.LastName = 'Sakowrat2';
        user1.Alias = 'Sakowrat';
        user1.TimeZoneSidKey = 'America/New_York';
        user1.ProfileId = p.Id;
        insert user1;
        
        CollaborationGroup group1 = new CollaborationGroup();
        group1.Name = 'Main Group';
        group1.Description = 'Main Group';
        group1.InformationTitle = 'mailNickname';
        group1.InformationBody = '1234';
        group1.CollaborationType = 'Private';   
        insert group1;
        
        CollaborationGroup group2 = new CollaborationGroup();
        group2.Name = 'Main Group2';
        group2.Description = 'Main Group2';
        group2.InformationTitle = 'mailNickname2';
        group2.InformationBody = '1234';
        group2.CollaborationType = 'Private';   
        insert group2;
        
        
        
        CollaborationGroupMember member1 = new CollaborationGroupMember();
        member1.CollaborationGroupId = group1.Id;
        member1.MemberId = user1.Id;
        insert member1;
        
    }
    
    @isTest
    static void testSyncAzure() {
        Test.setMock(HttpCalloutMock.class, new OPP_AzureControllerTest.Mock());
        Test.startTest();
        OPP_AzureController.CreateMainGroup();
        OPP_AzureController.CreateSubGroup();
        OPP_AzureController.CreateMemberGroup('Main');
        OPP_AzureController.CreateMemberGroup('Sub');
        OPP_AzureController.UpdateMemberMainGroup();
        Test.stopTest();
    }
    
    @isTest
    static void testCreateMemberGroup() {
        Test.setMock(HttpCalloutMock.class, new OPP_AzureControllerTest.Mock());
        List<CollaborationGroup> aa = new List<CollaborationGroup>([SELECT Id FROM CollaborationGroup]);
        List<Id> groupId = new List<Id>();
        for(CollaborationGroup record : aa ){
            groupId.add(record.Id);
        }
        Test.startTest();
        OPP_AzureController.CreateMemberGroup(groupId);
        Test.stopTest();
    }
    
    public static String CRON_EXP = '0 0 0 28 '+system.today().month()+' ? '+system.today().year();
	static testmethod void testAzureCreateMainGroup() {
        String jobId = System.schedule('AzureCreateMainGroup',
            CRON_EXP,
            new OPP_AzureCreateMainGroup());
    }
	static testmethod void testAzureCreateSubGroup() {
        String jobId = System.schedule('AzureCreateSubGroup',
            CRON_EXP,
            new OPP_AzureCreateSubGroup());
    }
	static testmethod void testAzureCreateMember() {
        String jobId = System.schedule('AzureCreateMember',
            CRON_EXP,
            new OPP_AzureCreateMember());
    }
	static testmethod void testAzureMemberUpdateMainGroup() {
        String jobId = System.schedule('AzureMemberUpdateMainGroup',
            CRON_EXP,
            new OPP_AzureMemberUpdateMainGroup());
    }

    @isTest static void testRunAs(){ 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OPP_AzureControllerTest.Mock());

        OPP_AzureBatchSync BC=new OPP_AzureBatchSync();
        Database.executeBatch(BC, 1);

        Test.stopTest();      
    }
    
}