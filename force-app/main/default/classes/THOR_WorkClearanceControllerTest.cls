@isTest
public class THOR_WorkClearanceControllerTest {

    @TestSetup
    static void makeData(){

        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        List<Master_Map__c> masterMaps = new List<Master_Map__c>();

        Master_Map__c plant = new Master_Map__c();
        plant.Code__c = '1200';
        plant.Name = '1200';
        plant.Type__c = 'Plant';
        plant.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c area = new Master_Map__c();
        area.Code__c = 'P1';
        area.Name = 'P1';
        area.Description__c = 'PROCESS1';
        area.Type__c = 'Plant Section';
        area.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c codeGroupOfFaultCode = new Master_Map__c();
        codeGroupOfFaultCode.Code__c = 'IEF-028';
        codeGroupOfFaultCode.Name = 'IEF-028';
        codeGroupOfFaultCode.Type__c = 'Code Group';
        codeGroupOfFaultCode.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c objectPart = new Master_Map__c();
        objectPart.Code__c = 'B';
        objectPart.Name = 'B';
        objectPart.Type__c = 'Object Part';
        objectPart.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c mainWorkCenter = new Master_Map__c();
        mainWorkCenter.Code__c = 'ENMA-I';
        mainWorkCenter.Name = 'ENMA-I';
        mainWorkCenter.Type__c = 'Main Work Center';
        mainWorkCenter.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c faultCode = new Master_Map__c();
        faultCode.Code__c = 'E02';
        faultCode.Name = 'E02';
        faultCode.Type__c = 'FaultCode';
        faultCode.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c pmActivity = new Master_Map__c();
        pmActivity.Code__c = 'M01';
        pmActivity.Name = 'M01';
        pmActivity.Type__c = 'MaintActivityType';
        pmActivity.Master_Map_Set__c = masterMapSet.Id;

        masterMaps.add(plant);
        masterMaps.add(area);
        masterMaps.add(codeGroupOfFaultCode);
        masterMaps.add(objectPart);
        masterMaps.add(mainWorkCenter);
        masterMaps.add(faultCode);
        masterMaps.add(pmActivity);
        insert masterMaps;

        Functional_Location__c fl = new Functional_Location__c();
        fl.Name = 'TPX-76-LG-033B';
        insert fl;

        Equipment__c equipment = new Equipment__c();
        equipment.Name = '10009516';
        insert equipment;

        PISUsers__c pisuser = new PISUsers__c();
        pisuser.User__c = UserInfo.getUserId();
        pisuser.Name = 'Integration R2';
        pisuser.ENFIRSTNAME__c = 'Integration';
        pisuser.ENLASTNAME__c = 'R2';
        pisuser.THFIRSTNAME__c = 'Integration';
        pisuser.THLASTNAME__c = 'R2';
        pisuser.EMPLOYEEID__c = 'R2-00001';
        pisuser.DEPARTMENT__c = '001';
        pisuser.HOME_ID__c = '';
        pisuser.HOST_ID__c = '00000001';
        pisuser.ORGID__c = '';
        insert pisuser;

        THOR_Applicant_Bearer__c bearer = new THOR_Applicant_Bearer__c();
        bearer.Name = 'B-180001';
        bearer.Code__c = 'B-180001';
        bearer.Applicant_ID__c = '10004001';
        bearer.Description__c = 'B-180001, ADPE';
        insert bearer;

        Safety_Permit__c safety = new Safety_Permit__c();
        safety.Name = '300024001';
        insert safety;

        Notification__c noti = new Notification__c();
        noti.Name = '10728301';
        insert noti;

        Order__c ord = new Order__c();
        ord.Name = '101001001';
        ord.Order_Type__c = 'PM01';
        ord.Functional_Location__c = fl.Id;
        ord.Equipment__c = equipment.Id;
        ord.Description__c = 'Description';
        ord.Notification__c = noti.Id;
        ord.PM_Activity_Type__c = pmActivity.Id;
        ord.System_Status_Text__c = 'CRED ANIN';
        ord.Main_Work_Center__c = mainWorkCenter.Id;
        ord.Requested_Date__c = System.today();
        ord.Priority__c = 'Normal';
        ord.Start_Date__c = System.today();
        ord.Finished_Date__c = System.today();
        ord.Responsible_person__c  = UserInfo.getUserId();
        ord.Planning_Plant__c = plant.Id;
        insert ord;

        Work_Clearance__c wc1 = new Work_Clearance__c();
        wc1.Name = '900444001';
        wc1.Notification__c = noti.Id;
        wc1.Order__c = ord.Id;
        wc1.Requester_UI__c = pisuser.Id;
        wc1.Thaioil_Supervisor_Indicator_UI__c = pisuser.Id;
        wc1.Applicant_or_Bearer_UI__c = bearer.Id;
        wc1.Close_Applicant_or_Bearer_UI__c = pisuser.Id;
        wc1.Extend_Applicant_or_Bearer_UI__c = pisuser.Id;
        wc1.Bearer1_UI__c = bearer.Id;
        wc1.Bearer2_UI__c = bearer.Id;
        wc1.Bearer3_UI__c = bearer.Id;
        wc1.Bearer4_UI__c = bearer.Id;
        wc1.Bearer4_UI__c = bearer.Id;
        wc1.Safety_Permit1_UI__c = safety.Id;
        wc1.Safety_Permit2_UI__c = safety.Id;
        wc1.Safety_Permit3_UI__c = safety.Id;
        wc1.System_Status__c = 'CRTE';
        wc1.Work_Detail__c = '1. Work Detail 1\n2. Work Detail 2\n3. Work Detail 3\n4. Work Detail 4';
        wc1.isIRPA__c = true;
        insert wc1;

        Work_Clearance__c wc2 = new Work_Clearance__c();
        wc2.Name = '900444002';
        wc2.Requester_UI__c = pisuser.Id;
        wc2.Requester__c = 'Integration R2';
        wc2.System_Status__c = 'CRTE';
        wc1.isIRPA__c = true;
        insert wc2;
        
        List<PTW_Header__c>ptwheaderList = new List<PTW_Header__c>();
		PTW_Header__c ptwheader = new PTW_Header__c();
        ptwheader.FormName__c = 'Inspection';
        ptwheader.Work_Clearance__c = wc2.id;
        ptwheader.Key__c = 'test';
        ptwheaderList.add(ptwheader);
        
        PTW_Header__c ptwheader2 = new PTW_Header__c();
        ptwheader2.FormName__c = 'Verification';
        ptwheader2.Work_Clearance__c = wc2.id;
        ptwheader2.Key__c = 'test2';
        ptwheaderList.add(ptwheader2);
        insert ptwheaderList;
        
        PTW_Header__c header = [ SELECT Id, Name, Key__c, FormName__c, Work_Clearance__c, User__c, Version__c, Status__c 
                                   FROM PTW_Header__c 
                                   WHERE FormName__c = 'Verification' AND Work_Clearance__c = :wc2.id ORDER BY CreatedDate];
        PTW_Answer__c ans1 = new PTW_Answer__c();
        ans1.PTW_Header__c =header.id;
        ans1.Answer__c = 'Disagree';
        ans1.Key__c = 'ans1';
        insert ans1;
    }
    @IsTest
    static void testCheckInspectionStatus() {
		
        
        Work_Clearance__c wc = [SELECT Id,Verification_Status__c FROM Work_Clearance__c WHERE Name = '900444002' LIMIT 1];
		wc.Verification_Status__c = 'Agree';
        update wc;
		Test.startTest();
        String ptw = THOR_WorkClearanceController.checkInspectionStatus(wc.Id);
        Test.stopTest();
       
    }
 	@IsTest
    static void testCheckAbleVerify() {
		
        
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE Name = '900444001' LIMIT 1];

		Test.startTest();
        String ptw = THOR_WorkClearanceController.checkAbleVerify(wc.Id);
        Test.stopTest();
       
    }
     @IsTest
    static void testCheckAgreeDisagree() {
		
        
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE Name = '900444002' LIMIT 1];

		Test.startTest();
        Boolean ptw = THOR_WorkClearanceController.checkAgreeDisagree(wc.Id);
        Test.stopTest();
        
        //System.assertEquals(true, checkAbleInspec);

    }
    @IsTest
    static void testCheckAbleInspec() {
		
        
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE Name = '900444001' LIMIT 1];

		Test.startTest();
        Boolean ptw = THOR_WorkClearanceController.checkAbleInspec(wc.Id);
        Test.stopTest();
        
        //System.assertEquals(true, checkAbleInspec);

    }
    @isTest
    static void testDatetimeGmtString() {
        Datetime today = Datetime.now();

        Test.startTest();
        String todaystart = THOR_WorkClearanceController.datetimeGmtString(today.format('yyyy-MM-dd'), true);
        String todayend = THOR_WorkClearanceController.datetimeGmtString(today.format('yyyy-MM-dd'), false);
        Test.stopTest();

        System.assertEquals(today.format('yyyy-MM-dd') + 'T00:00:00.000+0700', todaystart);
        System.assertEquals(today.format('yyyy-MM-dd') + 'T23:59:59.000+0700', todayend);
    }

    @isTest
    static void testGetUserRecordEditAccess() {
        Test.startTest();
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE Name = '900444001'];

        Boolean hasEditAccess = THOR_WorkClearanceController.getUserRecordEditAccess(wc.Id);
        Boolean hasWriteAccess = THOR_WorkClearanceController.hasWriteAccess(wc.Id);
        Test.stopTest();

        System.assertEquals(true, hasEditAccess);
    }

    @isTest
    static void testGetAreaDescriptionByCode() {
        Test.startTest();
        Master_Map__c area = THOR_WorkClearanceController.getAreaDescriptionByCode('P1');
        Test.stopTest();

        System.assertEquals('PROCESS1', area.Description__c);
    }

    @isTest
    static void testGetFunctionalLocationDetailById() {
        Test.startTest();
        Functional_Location__c fl = [SELECT Id, Name FROM Functional_Location__c WHERE Name = 'TPX-76-LG-033B' LIMIT 1];

        Functional_Location__c result = THOR_WorkClearanceController.getFunctionalLocationDetailById(fl.Id);
        Test.stopTest();

        System.assertEquals(fl.Name, result.Name);
    }

    @isTest
    static void testGetWorkClearanceById() {
        Test.startTest();
        Work_Clearance__c wc = [SELECT Id, Name FROM Work_Clearance__c WHERE Name = '900444001' LIMIT 1];

        Object obj = THOR_WorkClearanceController.getWorkClearanceById(wc.Id);
        Work_Clearance__c work = (Work_Clearance__c) obj;
        Test.stopTest();

        System.assertEquals(wc.Name, work.Name);
    }

    @isTest
    static void test_Noti_GetFunctionalLocationDetailById() {
        Test.startTest();
        Functional_Location__c fl = [SELECT Id, Name FROM Functional_Location__c WHERE Name = 'TPX-76-LG-033B' LIMIT 1];

        Functional_Location__c result = (Functional_Location__c) THOR_NotificationRelatedWcCreationCtrl.getFunctionLocationDetail(fl.Id);
        Test.stopTest();

        System.assertEquals(fl.Name, result.Name);
    }

    @isTest
    static void test_Noti_GetRelatedWorkClearancesByNotification() {
        Test.startTest();
        Notification__c noti = [SELECT Id, Name FROM Notification__c WHERE Name = '10728301' LIMIT 1];

        List<THOR_WorkClearanceController.WorkClearanceWrapper> related = THOR_NotificationRelatedWcCreationCtrl.getRelatedWorkClearances(noti.Id);
        Test.stopTest();

        System.assertEquals(1, related.size());
        System.assertEquals('900444001', related[0].WorkClearance.Name);
    }

    @isTest
    static void test_Noti_GetNotificationDetailById() {
        Test.startTest();
        Notification__c noti = [SELECT Id, Name FROM Notification__c WHERE Name = '10728301' LIMIT 1];

        Notification__c result = THOR_NotificationRelatedWcCreationCtrl.getNotificationDetailById(noti.Id);
        Test.stopTest();

        System.assertEquals(noti.Name, result.Name);
    }

    @isTest
    public static void test_Noti_GetPISRequester() {
        Test.startTest();
        List<SObject> pisusers = THOR_NotificationRelatedWcCreationCtrl.getPISRequester('Integration R2');
        Test.stopTest();

        System.assertEquals(1, pisusers.size());
        System.assertEquals(UserInfo.getUserId(), ((PISUsers__c) pisusers[0]).User__c);
    }

    @isTest
    public static void test_Noti_GetApplicantOrBearer() {
        Test.startTest();
        List<SObject> bearers = THOR_NotificationRelatedWcCreationCtrl.getApplicantOrBearer('B-180001');
        Test.stopTest();

        System.assertEquals(1, bearers.size());
        System.assertEquals('B-180001', ((THOR_Applicant_Bearer__c) bearers[0]).Name);
    }

    @isTest
    public static void test_Noti_GetSafetyPermit() {
        Test.startTest();
        List<SObject> safeties = THOR_NotificationRelatedWcCreationCtrl.getSafetyPermit('300024001');
        Test.stopTest();

        System.assertEquals(1, safeties.size());
        System.assertEquals('300024001', ((Safety_Permit__c) safeties[0]).Name);
    }

    @isTest
    static void test_Noti_HasWriteAccess() {
        Test.startTest();
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE Name = '900444001'];

        Boolean hasEditAccess = THOR_NotificationRelatedWcCreationCtrl.hasWriteAccess(wc.Id);
        Test.stopTest();

        System.assertEquals(true, hasEditAccess);
    }

    @isTest
    static void test_Order_GetFunctionalLocationDetailById() {
        Test.startTest();
        Functional_Location__c fl = [SELECT Id, Name FROM Functional_Location__c WHERE Name = 'TPX-76-LG-033B' LIMIT 1];

        Functional_Location__c result = (Functional_Location__c) THOR_OrderRelatedWCCtrl.getFunctionLocationDetail(fl.Id);
        Test.stopTest();

        System.assertEquals(fl.Name, result.Name);
    }

    @isTest
    static void test_Order_GetRelatedWorkClearancesByOrder() {
        Test.startTest();
        Order__c ord = [SELECT Id, Name FROM Order__c WHERE Name = '101001001' LIMIT 1];

        //List<THOR_WorkClearanceController.WorkClearanceWrapper> related = THOR_WorkClearanceController.getRelatedWorkClearancesByOrder(ord.Id);
        List<THOR_WorkClearanceController.WorkClearanceWrapper> related = THOR_OrderRelatedWCCtrl.getRelatedWorkClearances(ord.Id);
        Test.stopTest();

        System.assertEquals(1, related.size());
        System.assertEquals('900444001', related[0].WorkClearance.Name);
    }

    @isTest
    static void test_Order_GetOrderDetailById() {
        Test.startTest();
        Order__c ord = [SELECT Id, Name FROM Order__c WHERE Name = '101001001' LIMIT 1];

        //Order__c result = THOR_WorkClearanceController.getOrderDetailById(ord.Id);
        Order__c result = THOR_OrderRelatedWCCtrl.getOrderDetailById(ord.Id);
        Test.stopTest();

        System.assertEquals(ord.Name, result.Name);
    }
    
    @isTest
    static void test_Order_GetWorkClearanceById() {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        Test.startTest();
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_WorkClearance_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/fea37188-6d8e-41b6-8754-c4c346591e1c/runs';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;

        Work_Clearance__c wc = [SELECT Id, Name FROM Work_Clearance__c WHERE Name = '900444001' LIMIT 1];
        wc.System_Status__c = 'PREP';
        wc.Integration_Status__c = '';
        wc.isIRPA__c = true;
        update wc;

        Object obj = THOR_OrderRelatedWCCtrl.getWorkClearance(wc.Id);
        Work_Clearance__c work = (Work_Clearance__c) obj;
        Test.stopTest();

        System.assertEquals(wc.Name, work.Name);
        //System.assertEquals('00000001', work.Requester__c);
    }

    @isTest
    public static void test_Order_GetPISRequester() {
        Test.startTest();
        List<SObject> pisusers = THOR_OrderRelatedWCCtrl.getPISRequester('Integration R2');
        Test.stopTest();

        System.assertEquals(1, pisusers.size());
        System.assertEquals(UserInfo.getUserId(), ((PISUsers__c) pisusers[0]).User__c);
    }

    @isTest
    public static void test_Order_GetApplicantOrBearer() {
        Test.startTest();
        List<SObject> bearers = THOR_OrderRelatedWCCtrl.getApplicantOrBearer('B-180001');
        Test.stopTest();

        System.assertEquals(1, bearers.size());
        System.assertEquals('B-180001', ((THOR_Applicant_Bearer__c) bearers[0]).Name);
    }

    @isTest
    public static void test_Order_GetSafetyPermit() {
        Test.startTest();
        List<SObject> safeties = THOR_OrderRelatedWCCtrl.getSafetyPermit('300024001');
        Test.stopTest();

        System.assertEquals(1, safeties.size());
        System.assertEquals('300024001', ((Safety_Permit__c) safeties[0]).Name);
    }

    @isTest
    static void test_Order_HasWriteAccess() {
        Test.startTest();
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE Name = '900444001'];

        Boolean hasEditAccess = THOR_OrderRelatedWCCtrl.hasWriteAccess(wc.Id);
        Test.stopTest();

        System.assertEquals(true, hasEditAccess);
    }

    @isTest
    static void testGetWithoutNotiAndOrderWorkClearancesByFilter() {
        Map<String, Object> filter = new Map<String, Object>{
            'Clearance_Number__c' => '900444002',
            'Requester__c' => 'Integration'
        };

        Test.startTest();
        List<Work_Clearance__c> results = THOR_WorkClearanceController.getWithoutNotiAndOrderWorkClearancesByFilter(filter, 0, 20);
        Test.stopTest();

        System.assertEquals(1, results.size());
    }

    @isTest
    static void testGetInProgressWorkClearancesByFilter() {
        Map<String, Object> filter = new Map<String, Object>();

        Test.startTest();
        List<Work_Clearance__c> results = THOR_WorkClearanceController.getInProgressWorkClearancesByFilter(filter, 0, 20);
        Test.stopTest();

        System.assertEquals(1, results.size());
    }

    @isTest
    static void testGetCountWithoutNotiAndOrderWorkClearancesByFilter() {
        Map<String, Object> filter = new Map<String, Object>();

        Test.startTest();
        Integer result = THOR_WorkClearanceController.getCountWithoutNotiAndOrderWorkClearancesByFilter(filter);
        Test.stopTest();

        System.assertEquals(1, result);
    }

    @isTest
    static void testGetCountInProgressWorkClearancesByFilter() {
        Map<String, Object> filter = new Map<String, Object>();

        Test.startTest();
        Integer result = THOR_WorkClearanceController.getCountInProgressWorkClearancesByFilter(filter);
        Test.stopTest();

        System.assertEquals(1, result);
    }

    @isTest
    public static void testGetPISRequester() {
        Test.startTest();
        List<SObject> pisusers = THOR_WorkClearanceController.getPISRequester('Integration R2');
        Test.stopTest();

        System.assertEquals(1, pisusers.size());
        System.assertEquals(UserInfo.getUserId(), ((PISUsers__c) pisusers[0]).User__c);
    }

    @isTest
    public static void testGetApplicantOrBearer() {
        Test.startTest();
        List<SObject> bearers = THOR_WorkClearanceController.getApplicantOrBearer('B-180001');
        Test.stopTest();

        System.assertEquals(1, bearers.size());
        System.assertEquals('B-180001', ((THOR_Applicant_Bearer__c) bearers[0]).Name);
    }

    @isTest
    public static void testGetSafetyPermit() {
        Test.startTest();
        List<SObject> safeties = THOR_WorkClearanceController.getSafetyPermit('300024001');
        Test.stopTest();

        System.assertEquals(1, safeties.size());
        System.assertEquals('300024001', ((Safety_Permit__c) safeties[0]).Name);
    }

    @isTest
    public static void testGetCurrentPISUser() {
        Test.startTest();
        PISUsers__c pisuser = THOR_WorkClearanceController.getCurrentPISUser();
        Test.stopTest();

        System.assertEquals('Integration R2', pisuser.Name);
    }

    @isTest
    public static void testGetUserName() {
        Test.startTest();
        String username = THOR_WorkClearanceController.getUserName();
        Test.stopTest();
    }
    
    @isTest
    public static void testCanApproveOrReject() {
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE Name = '900444001' LIMIT 1];
        Boolean canApproveOrReject = THOR_WorkClearanceController.canApproveOrReject(wc.Id);

        System.assertEquals(true, canApproveOrReject);
    }
    
    @isTest
    public static void testGetPISUsers() {
        Map<String, PISUsers__c> pisusersTest = THOR_WorkClearanceController.getPISUsers(new List<String>{ '00000001' });
        List<PISUsers__c> pisusers = [SELECT Id FROM PISUsers__c WHERE HOST_ID__c = '00000001'];

        System.assertEquals(pisusers[0].Id, pisusersTest.get('00000001').Id);
    }
    
    @isTest
    public static void testPISUserList() {
        List<PISUsers__c> pisusers = [SELECT Id FROM PISUsers__c WHERE HOST_ID__c = '00000001'];
        Map<String, PISUsers__c> pisusersTest = THOR_WorkClearanceController.getPISUserList(new List<String>{ pisusers[0].Id });

        System.assertEquals(pisusers[0].Id, pisusersTest.get(pisusers[0].Id).Id);
    }
    
    @isTest
    public static void testGetApplicantOrBearerList() {
        List<THOR_Applicant_Bearer__c> bearers = [SELECT Id FROM THOR_Applicant_Bearer__c WHERE Code__c = 'B-180001'];
        Map<String, THOR_Applicant_Bearer__c> bearersTest = THOR_WorkClearanceController.getApplicantOrBearerList(new List<String>{ bearers[0].Id });

        System.assertEquals(bearers[0].Id, bearersTest.get(bearers[0].Id).Id);
    }
}