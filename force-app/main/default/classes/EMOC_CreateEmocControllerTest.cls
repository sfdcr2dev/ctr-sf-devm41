@isTest
public class EMOC_CreateEmocControllerTest {
    @testSetup static void Data() {
        Functional_Location__c funcLoc = new Functional_Location__c();
        funcLoc.Name = 'Test Functional Location';
        insert funcLoc;
        
        User currentuser = [Select Id,Name, Department,Email from User where Id = :userinfo.getuserId()];
        currentuser.Department = 'EMOC';
        currentuser.Email = 'EMOC@gmail.com';
        update currentuser;
        
        E_MOC_Question__c emocQuestion = new E_MOC_Question__c();
        emocQuestion.Type__c = 'E_MOC_Question__c';
        emocQuestion.Document__c = 'Document Require Checklist';
        insert emocQuestion;
        
        E_MOC_Question__c emocQuestion2 = new E_MOC_Question__c();
        emocQuestion2.Type__c = 'Stationary Equipment and Piping Discipline Checklist';
        emocQuestion2.Document__c = 'TA Checklist';
        insert emocQuestion2;
        
        E_MOC_TA_Mandatory_Master__c taManMaster1 = new E_MOC_TA_Mandatory_Master__c();
        taManMaster1.Position__c = 'MROC';
        taManMaster1.Require__c = 'Require';
        taManMaster1.TA_Level__c = '2';
        taManMaster1.Category_Type__c = 'Mechanical';
        taManMaster1.Sub_Category_Type__c = 'Air Cooled Exchangers';
        insert taManMaster1;
        
        E_MOC_TA_Mandatory_Master__c taManMaster2 = new E_MOC_TA_Mandatory_Master__c();
        taManMaster2.Position__c = 'MPOE';
        taManMaster2.Require__c = 'Require';
        taManMaster2.TA_Level__c = '2';
        taManMaster2.Category_Type__c = 'Instrument';
        taManMaster2.Sub_Category_Type__c = 'Alarm';
        insert taManMaster2;
        
        E_MOC_TA_Mandatory_Master__c taManMaster3 = new E_MOC_TA_Mandatory_Master__c();
        taManMaster3.Position__c = 'QMOS';
        taManMaster3.Require__c = 'Optional';
        taManMaster3.TA_Level__c = '2';
        taManMaster3.Category_Type__c = 'Mechanical';
        taManMaster3.Sub_Category_Type__c = 'Air Cooled Exchangers';
        insert taManMaster3;
        
        E_MOC_TA3_Mandatory_Master__c ta3ManMaster3 = new E_MOC_TA3_Mandatory_Master__c();
        ta3ManMaster3.TA3_Name__c = currentuser.Id;
        ta3ManMaster3.Section__c = 'MFOP';
        ta3ManMaster3.Indicator__c = currentuser.Id;
        insert ta3ManMaster3;
        
        E_MOC_TA_Mapping_Checklist__c taMapChecklist1 = new E_MOC_TA_Mapping_Checklist__c();
        taMapChecklist1.Type__c = 'Stationary Equipment and Piping Discipline Checklist';
        taMapChecklist1.Position__c = 'MROA';
        insert taMapChecklist1;
        
        E_MOC_TA_Mapping_Checklist__c taMapChecklist2 = new E_MOC_TA_Mapping_Checklist__c();
        taMapChecklist2.Type__c = 'Rotating Discipline Checklist';
        taMapChecklist2.Position__c = 'MROB';
        insert taMapChecklist2;
        
        E_MOC_TA_Mapping_Checklist__c taMapChecklist3 = new E_MOC_TA_Mapping_Checklist__c();
        taMapChecklist3.Type__c = 'Instrument Engineering Discipline Checklist';
        taMapChecklist3.Position__c = 'MROC';
        insert taMapChecklist3;
        
        E_MOC_Timeline__c emocTimeline = new E_MOC_Timeline__c();
        emocTimeline.Status__c = 'Technical review';
        emocTimeline.Step__c = 'Technical review';
        emocTimeline.RAM_Level__c = 'H';
        emocTimeline.Change_Type__c = 'Permanent';
        emocTimeline.Day__c = 3;
        insert emocTimeline;
        
        E_MOC_TA_Checklist_Require__c emocTaChklistReq = new E_MOC_TA_Checklist_Require__c();
        emocTaChklistReq.Type__c = 'Stationary Equipment and Piping Discipline Checklist';
        emocTaChklistReq.Notification_Sub_Type__c = 'Air Cooled Exchangers';
        insert emocTaChklistReq;
        
        E_MOC_Application__c emocApp2 = new E_MOC_Application__c();
        emocApp2.Status_Common_Workflow__c = 'E-MOC Register';//E-MOC Register
        insert emocApp2; 
        
        emocApp2.Status_Common_Workflow__c = 'Concept Approval';
        update emocApp2;
        emocApp2.Status_Common_Workflow__c = 'Emergency Approval';
        update emocApp2; 
        emocApp2.Status_Common_Workflow__c = 'Budget Registration';
        update emocApp2; 
        emocApp2.Status_Common_Workflow__c = 'Technical Review';
        update emocApp2;
        emocApp2.Status_Common_Workflow__c = 'APU Approval';
        update emocApp2;       
        
        emocApp2.Status_Common_Workflow__c = 'Cancelled';
        update emocApp2; 
        
        E_MOC_Application__c emocApp3 = new E_MOC_Application__c();
        emocApp3.Status_Common_Workflow__c = 'E-MOC Register';
        insert emocApp3; 
        
        emocApp3.Status_Common_Workflow__c = 'VP Approval';
        update emocApp3; 
        
        emocApp3.Status_Common_Workflow__c = 'Implementation';
        update emocApp3; 
        
        emocApp3.Status_Common_Workflow__c = 'Readiness Review';
        update emocApp3; 
        
        emocApp3.Status_Common_Workflow__c = 'Rejected';
        update emocApp3;
        
        Map<String, String> paramLookup2 = new Map<String, String>();
        paramLookup2.put('recordType', 'Functional Override');
        paramLookup2.put('searchParam', 'Test');
        EMOC_CreateEmocController.getLookupFncLocationFilter(paramLookup2);
    }
    static testmethod void testData() {
        Test.startTest();
        
        User currentuser = [Select Id,Name, Department from User where Id = :userinfo.getuserId()];
        Functional_Location__c functionalLocation = [Select Id from Functional_Location__c LIMIT 1];
        
        String paramInsertEmoc = '{"emocApp": {"OPM_OPEX__c": "true","Area__c":"E","Mechanical_change__c":"true",' +
            '"Air_Cooled_Exchangers__c":"true","Status_Common_Workflow__c":"Detailed Design/Study",' +
            '"RAM_Total__c":"H","Step__c":"Technical review","Change_Type__c":"Temporary","Extend_Require_to_extend__c":"true",' +
            '"Instrument_change__c":"true","Alarm__c":"true", "Start_date__c": "2022-08-02", "End_date__c": "2022-08-02"},' +
            '"ta2Man": [],"fncLocaAss": [],"potentialRisk": [],"potentialConsequence": [],"mitigationPrecaution": []}';
        EMOC_CreateEmocController.getLookupFncLocation('Functional');
        EMOC_CreateEmocController.getLookupUser(currentuser.Name);
        EMOC_CreateEmocController.getLookupFocalPoint(currentuser.Name);
        EMOC_CreateEmocController.getLookupTa3(currentuser.Id);
        EMOC_CreateEmocController.getPotentialRiskList();
        EMOC_CreateEmocController.getPotentialConsequenceList();
        EMOC_CreateEmocController.getMitigationPrecautionList();
        EMOC_CreateEmocController.saveCreateEmoc(paramInsertEmoc);
        E_MOC_Application__c emocApp = [SELECT Id, Name, Status_Common_Workflow__c,
                                        Extend_Require_to_extend__c,Yes_Require_to_demolish__c,
                                        HAZOP__c,HRA__c,Environmental_Impact__c,Reliability_Checklist__c
                                        FROM E_MOC_Application__c LIMIT 1];
        String paramUpdateEmoc = '{"emocApp": {"Id": "' + emocApp.Id + '","OPM_OPEX__c":"true","Mechanical_change__c":"true","Air_Cooled_Exchangers__c":"true",' +
            '"Instrument_change__c":"true","Alarm__c":"true","Electrical_change__c":"true","Electrical_equipment_system__c":"true",' +
            '"Civil_change__c":"true","Buildling_and_Road__c":"true","Catalyst_Chemical__c":"true","Design_limit_IOW_change__c":"true",' +
            '"Tank_change_service__c":"true","Idled_Retired_Assets_equipment__c":"true","Demolition__c":"true","Type_A_Maintenance_budget__c":"true",' +
            '"HAZOP__c":"true","HRA__c":"true","Environmental_Impact__c":"true","Reliability_Checklist__c":"true","CATEGORY_1__c":"true","MOC_Focal_Point_Name__c":"' + currentuser.Id + '",' +
            '"Status_Common_Workflow__c":"Hazard Screening"},"ta2Man":[{"E_MOC_Application__c":"' + emocApp.Id + '","Position__c":"MROA",' +
            '"Require__c":"Optional","Compliance_Standard__c":"true","Deviate_Standard__c":"false","N_A__c":"false","Change_Type__c":"Temporary"}],' +
            '"fncLocaAss": [{"Id":"","E_MOC_Application__c":"' + emocApp.Id + '","Functional_Location__c":"' + functionalLocation.Id + '","Functional_Location__r":{"Name":"FL01"},"Functional_Location_Description__c":"des1","Main_Work_Center__c":"mc-1","Plant_of_Main_Work_Center__c":"mcp-1"}],' +
            '"potentialRisk":[{"Topic__c":"เมื่อทำการ Override จะไม่มีตัวช่วย Trip หรือ Shutdown process","Comment__c":"xxx","Type__c":"Potential Risk"}],' +
            '"potentialConsequence":[{"Id":null,"flgDelete":false,"E_MOC_Application__c":"' + emocApp.Id + '","Topic__c":"มีโอกาส Equipment upset หรือ Shutdown ได้","Comment__c":"yyy","Type__c":"Potential Consequence"}],' +
            '"mitigationPrecaution":[{"Id":null,"flgDelete":false,"E_MOC_Application__c":"' + emocApp.Id + '","Topic__c":"รักษา Process condition ให้ Steady โดยไม่ทำการ Adjust process condition หรือเปลี่ยนแปลงกำลังการผลิต ที่ไม่จำเป็น และทำการ Record ตามความถี่ที่เหมาะสม","Comment__c":"zzz","Type__c":"Mitigation/Precaution"}]}';
        Map<String, String> paramTest = new Map<String, String>();
        paramTest.put('emocApplicationId', emocApp.Id);
        Map<String, String> paramGetDocReqChecklist1 = new Map<String, String>{'Id' => emocApp.Id, 'DocType' => 'Document Require Checklist'};
            String paramSaveDocReq1 = '[{"E_MOC_Application__c":"' + emocApp.Id + '","Sequence__c":1,"Type__c":"Common document","Document__c":"Document Require Checklist","Question_No__c":2,"Question__c":"General Equipment Arrangements & Elevations","Yes__c":true,"No__c":false,"N_A__c":false,"Remark__c":"Remark","Version__c":1}]';
        String paramSaveDocReq2 = '[{"E_MOC_Application__c":"' + emocApp.Id + '","Sequence__c":1,"Type__c":"Common document","Document__c":"TA Checklist","Question_No__c":2,"Question__c":"General Equipment Arrangements & Elevations","Yes__c":true,"No__c":false,"N_A__c":false,"Remark__c":"Remark","Version__c":"1","Position__c":"MMLF"}]';
        
        EMOC_CreateEmocController.getMitigationPrecaution(paramTest);
        EMOC_CreateEmocController.getPotentialConsequence(paramTest);
        EMOC_CreateEmocController.getConsolidateComment(paramTest);
        
        E_MOC_TA3_Mandatory_Master__c ta3ManMaster3 = [SELECT Id, TA3_Name__c FROM E_MOC_TA3_Mandatory_Master__c limit 1];
        E_MOC_TA_Mandatory_Mapping__c taManMap = new E_MOC_TA_Mandatory_Mapping__c();
        taManMap.E_MOC_Application__c = emocApp.Id;
        taManMap.Position__c = 'MROA';
        taManMap.Require__c = 'Require';
        taManMap.Compliance_Standard__c = false;
        taManMap.Compliance_Standard_Remark__c = 'test';
        taManMap.Deviate_Standard__c = false;
        taManMap.Deviate_Standard_Remark__c = 'test';
        taManMap.N_A__c = false;
        taManMap.N_A_Remark__c = '';
        taManMap.TA3_Name_c__c = ta3ManMaster3.TA3_Name__c;
        taManMap.TA3_Id__c = ta3ManMaster3.Id;
        taManMap.TA3_Position_c__c = 'ENTS';
        taManMap.TA_Level__c = '2';
        insert taManMap;
        
        EMOC_CreateEmocController.getEmocApplication(paramTest);
        EMOC_CreateEmocController.saveCreateEmoc(paramUpdateEmoc);
        EMOC_CreateEmocController.getEmocApplication(paramTest);
        EMOC_CreateEmocController.getDocReqChecklist(paramGetDocReqChecklist1);
        EMOC_CreateEmocController.saveDocReqChecklist(paramSaveDocReq1);
        EMOC_CreateEmocController.getTaManMaster(emocApp.Id);
        EMOC_CreateEmocController.getTaManMapping(emocApp.Id);
        MAP<String, String> paramGenTaChkList = new Map<String, String>{'Id' => emocApp.Id, 'Position__c' => 'MROA'};
            EMOC_CreateEmocController.generateTaChecklist(paramGenTaChkList);
        paramGenTaChkList.put('Position__c', 'MROB');
        EMOC_CreateEmocController.generateTaChecklist(paramGenTaChkList);
        paramGenTaChkList.put('Position__c', 'MROC');
        EMOC_CreateEmocController.generateTaChecklist(paramGenTaChkList);
        
        E_MOC_Prelim_Risk__c PrelimRisk = new E_MOC_Prelim_Risk__c();
        PrelimRisk.E_MOC_Application__c = emocApp.Id;
        PrelimRisk.Topic__c = 'เมื่อทำการ Disable Alarm จะไม่มี Alarm เตือน';
        PrelimRisk.Comment__c = 'test 1';
        PrelimRisk.Type__c = 'Potential Risk';
        insert PrelimRisk;
        
        E_MOC_Prelim_Risk__c PrelimRisk2 = new E_MOC_Prelim_Risk__c();
        PrelimRisk2.E_MOC_Application__c = emocApp.Id;
        PrelimRisk2.Topic__c = 'มีโอกาส Process upset หรือ Shutdown ได้';
        PrelimRisk2.Comment__c = 'test 2';
        PrelimRisk2.Type__c = 'Potential Consequence';
        insert PrelimRisk2;
        
        E_MOC_Prelim_Risk__c PrelimRisk3 = new E_MOC_Prelim_Risk__c();
        PrelimRisk3.E_MOC_Application__c = emocApp.Id;
        PrelimRisk3.Topic__c = 'ไม่ต้องมีมาตรการเพิ่มเติมเนื่องจาก Equipment shutdown';
        PrelimRisk3.Comment__c = 'test 3';
        PrelimRisk3.Type__c = 'Mitigation/Precaution';
        insert PrelimRisk3;
        
        EMOC_CreateEmocController.getPotentialConsequence(paramTest);
        EMOC_CreateEmocController.getMitigationPrecaution(paramTest);
        
        MAP<String, String> paramSendBack = new Map<String, String>{'emocAppId' => emocApp.Id, 'TA_Sendback_Comment__c' => 'MROA', 'Status_Common_Workflow__c' => 'Detailed Design/Study'};
            EMOC_CreateEmocController.saveTaSendBack(paramSendBack);
       
        MAP<String, String> paramHold = new Map<String, String>{'emocAppId' => emocApp.Id, 'Position__c' => 'MROA', 'remarkHold' => 'MROA'};
            EMOC_CreateEmocController.saveTaHold(paramHold);
        
        emocApp.Status_Common_Workflow__c = 'Technical review';
        update emocApp;
        
        emocApp.Status_Common_Workflow__c = 'Monitoring';
        update emocApp;
        
        emocApp.Status_Common_Workflow__c = 'Lesson Learn';
        update emocApp;
        
        emocApp.Status_Common_Workflow__c = 'Close Out';
        emocApp.Extend_Require_to_extend__c = false;
        emocApp.Yes_Require_to_demolish__c = false;
        emocApp.HAZOP__c = false;
        emocApp.HRA__c = false;
        emocApp.Environmental_Impact__c = false;
        emocApp.Reliability_Checklist__c = false;
        update emocApp;
        
       /* emocApp.Status_Common_Workflow__c = 'Closed';
        emocApp.Extend_Require_to_extend__c = true;
        emocApp.Yes_Require_to_demolish__c = true;
        update emocApp;*/
        
        MAP<String, String> paramTa3Man = new Map<String, String>{'Indicator' => '', 'Section' => 'MROA'};
            EMOC_CreateEmocController.getTa3ManMaster(paramTa3Man);
        
        Map<String, String> paramTestFlow = new Map<String, String>();
        paramTestFlow.put('emocAppId', emocApp.Id);
        
        EMOC_CreateEmocController.callFlowReturnToReviewStepConcernedTA(paramTestFlow);
       /* Map<String, String> paramLookup = new Map<String, String>();
        paramLookup.put('searchParam', 'Test');
        paramLookup.put('recordType', '');
        EMOC_CreateEmocController.getLookupFncLocationFilter(paramLookup);
        EMOC_CreateEmocController.dateFormatMonddyyyy('2022-12-02');
        EMOC_CreateEmocController.getLookupClearanceNumber('');*/
        Test.stopTest();
    }
    
    @isTest static void testGetData(){
        
        Test.startTest();
        
        Notification__c noti = new Notification__c();
        noti.Name = 'testNoti';
        insert noti;
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.Status_Common_Workflow__c = 'Closed';
        insert emoc; 
        
        emoc.Status_Common_Workflow__c = 'E-MOC Register';
        update emoc;
        
        emoc.Status_Common_Workflow__c = 'Closed';
        emoc.Notification__c = noti.Id;
        emoc.Common_Workflow__c = true;
        update emoc;
        
        emoc.Status_Functional_Override__c = 'Close out';
        emoc.functional_override__c = true;
        update emoc;
        
        emoc.Status_Functional_Override__c = 'Implementation#1';
        emoc.Notification__c = null;
        update emoc;
        
        emoc.Status_Common_Workflow__c = 'Detailed Design/Study';
        update emoc;
        
        emoc.Status_Common_Workflow__c = 'Hazard Screening';
        update emoc;
        
       /* emoc.Status_Common_Workflow__c = 'Implementation';
        emoc.MOC_Type__c = 'Normal';
        update emoc;*/
        
        emoc.Status_Common_Workflow__c = 'Concept Approval';
        update emoc;
        
        Test.stopTest();  
    }
    
    @isTest static void testGetData3(){
        
        Test.startTest();
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        
        emoc.Status_Functional_Override__c = 'Approval #2';
        insert emoc;
        
        emoc.Status_Functional_Override__c = 'Risk assessment';
        emoc.MOS_for_maintenance__c = true;
        update emoc;
        
        emoc.Status_Functional_Override__c = 'Approval #1';
        update emoc;
        
        emoc.Status_Functional_Override__c = 'Implementation#1';
        update emoc;

        emoc.Status_Common_Workflow__c = 'Concept Approval';
        emoc.MOS_for_maintenance__c = true;
        update emoc;

        emoc.Status_Common_Workflow__c = 'Budget Registration';
        update emoc;
        
        emoc.Status_Common_Workflow__c = 'Detailed Design/Study';
        update emoc;
        
        emoc.Status_Common_Workflow__c = 'Readiness Review';
        emoc.MOS_for_maintenance__c = true;
        update emoc;

        emoc.Status_Common_Workflow__c = 'Close out';
        update emoc;
        
        
        emoc.Status_Common_Workflow__c = 'Closed';
        update emoc; 
        
        Map<String, String> paramLookup = new Map<String, String>();
        paramLookup.put('searchParam', 'Test');
        paramLookup.put('recordType', '');
        EMOC_CreateEmocController.getLookupFncLocationFilter(paramLookup);
        EMOC_CreateEmocController.dateFormatMonddyyyy('2022-12-02');
        EMOC_CreateEmocController.getLookupClearanceNumber('');
        
        Test.stopTest();  
    }
}