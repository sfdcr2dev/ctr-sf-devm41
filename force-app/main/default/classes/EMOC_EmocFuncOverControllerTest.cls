@isTest
public class EMOC_EmocFuncOverControllerTest {
    @testSetup static void Data() {
        Master_Map__c mapMas = new Master_Map__c();
        mapMas.Name = 'ENMA-I';
        insert mapMas;
        
        Functional_Location__c funcLoc = new Functional_Location__c();
        funcLoc.Name = 'Test Functional Location';
        insert funcLoc;

        User currentuser = [Select Id,Name, Department from User where Id = :userinfo.getuserId()];
        currentuser.Department = 'EMOC';
        update currentuser;
        
		Notification__c noti = new Notification__c();
      	noti.Functional_Location__c = funcLoc.Id;
      	noti.Main_Work_Center__c = mapMas.Id;
      	noti.Description__c = '';
      	noti.Department_Resp__c = 'ENVP';
      	noti.Integration_Status__c = 'In Progress';
      	noti.Integration_Message__c = '';
      	noti.Notification_Status__c = '';
      	noti.User_Status__c = '';
        insert noti;
        
        RecordType recordtype = [SELECT Id FROM RecordType WHERE Name='Functional Override'];
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Functional_Override__c = true;
        emoc.Functional_Location__c = funcLoc.Id;
        emoc.RecordTypeId = recordtype.Id;
        emoc.Change_Type__c = 'Permanent';
        emoc.RAM_Total__c = 'M';
        emoc.Next_Reminder_Date__c = Date.today();
        emoc.Emergency__c = true;
        emoc.OPM_OPEX__c = true;
        emoc.Mechanical_change__c = true;
        emoc.Air_Cooled_Exchangers__c = true;
        emoc.Status_Functional_Override__c = 'Create';
        emoc.Instrument_change__c = true;
        emoc.Alarm__c = true;
        emoc.Start_date__c = Date.today();
        emoc.End_date__c = Date.today();
        emoc.MOS_for_maintenance__c  = true;
        emoc.Safeguarding_force_signal__c = false;
        emoc.Potential_Risk_c__c = 'เมื่อทำการ Disable Alarm จะไม่มี Alarm เตือน';
        emoc.Potential_Consequence_c__c = 'มีโอกาส Process upset หรือ Shutdown ได้';
        emoc.Mitigation_Precaution_1__c = 'ไม่ต้องมีมาตรการเพิ่มเติมเนื่องจาก Equipment shutdown';
        emoc.Notification__c = noti.Id;
        insert emoc; 

        E_MOC_TA_Mandatory_Master__c taManMaster1 = new E_MOC_TA_Mandatory_Master__c();
        taManMaster1.Position__c = 'MROC';
        taManMaster1.Require__c = 'Require';
        taManMaster1.Area__c = '';
        taManMaster1.TA_Level__c = '2';
        taManMaster1.Category_Type__c = 'Functional Override';
        taManMaster1.Sub_Category_Type__c = 'MOS for maintenance';
        taManMaster1.Indicator__c = currentuser.Id;
        insert taManMaster1;

        E_MOC_TA_Mandatory_Master__c taManMaster22 = new E_MOC_TA_Mandatory_Master__c();
        taManMaster22.Position__c = 'MPOE';
        taManMaster22.Require__c = 'Require';
        taManMaster22.Area__c = '';
        taManMaster22.TA_Level__c = '2';
        taManMaster22.Category_Type__c = 'Functional Override';
        taManMaster22.Sub_Category_Type__c = 'Safeguarding force signal';
        taManMaster22.Indicator__c = currentuser.Id;
        insert taManMaster22;
        
        E_MOC_TA3_Mandatory_Master__c ta3ManMaster3 = new E_MOC_TA3_Mandatory_Master__c();
        ta3ManMaster3.TA3_Name__c = currentuser.Id;
        insert ta3ManMaster3;
        
                
        THOR_Work_Clearance_Historical__c ClearanceHis = new THOR_Work_Clearance_Historical__c();
        ClearanceHis.Work_Clearance__c = '123456789';
        insert ClearanceHis;
     
    }
    static testmethod void testData() {
        Test.startTest();

        User currentuser = [Select Id,Name, Department from User where Id = :userinfo.getuserId()];

        EMOC_EmocFuncOverController.getLookupFncLocation('Functional');
        EMOC_EmocFuncOverController.getLookupUser(currentuser.Name);
        EMOC_EmocFuncOverController.getLookupTa3(currentuser.Id);
        EMOC_EmocFuncOverController.getLookupClearanceNumber('123456789');
		
        
        E_MOC_Application__c emocApp = [SELECT Id, Name FROM E_MOC_Application__c LIMIT 1];
        Map<String, String> paramTest = new Map<String, String>();
        paramTest.put('emocApplicationId', emocApp.Id);
        
        EMOC_EmocFuncOverController.getPotentialConsequence(paramTest);
        EMOC_EmocFuncOverController.getMitigationPrecaution(paramTest);
        
        emocApp.Status_Functional_Override__c = 'Approval #1';
        update emocApp;
        
        emocApp.Status_Functional_Override__c = 'Implementation#1';
        update emocApp;

        emocApp.Status_Functional_Override__c = 'Approval #2';
        emocApp.MOS_for_maintenance__c = true;
        update emocApp;
        
        emocApp.Status_Functional_Override__c = 'Risk assessment';
        update emocApp;

        String paramUpdateEmoc = '{"emocApp": {"Id": "' + emocApp.Id + '","OPM_OPEX__c":"true","Mechanical_change__c":"true","Air_Cooled_Exchangers__c":"true",' +
                                '"Instrument_change__c":"true","Alarm__c":"true","Electrical_change__c":"true","Electrical_equipment_system__c":"true",' +
                                '"Civil_change__c":"true","Buildling_and_Road__c":"true","Catalyst_Chemical__c":"true","Design_limit_IOW_change__c":"true",' +
                                '"Tank_change_service__c":"true","Idled_Retired_Assets_equipment__c":"true","Demolition__c":"true","Area__c":"E",' +
                                '"Status_Functional_Override__c":"Approval #2","TA_Selection_confirmed__c":"false"},"ta2Man":[{"E_MOC_Application__c":"' + emocApp.Id + '","Position__c":"MROA",' +
                                '"Require__c":"Optional","Compliance_Standard__c":"false","Deviate_Standard__c":"false","N_A__c":"false"}],' +
           						'"potentialRisk":[{"E_MOC_Application__c":"' + emocApp.Id + '","Topic__c":"อื่นๆ","Comment__c":"","Type__c":"Potential Risk"}],' +
           						'"potentialConsequence":[{"E_MOC_Application__c":"' + emocApp.Id + '","Topic__c":"อื่นๆ","Comment__c":"","Type__c":"Potential Consequence"}],' +
           						'"mitigationPrecaution":[{"E_MOC_Application__c":"' + emocApp.Id + '","Topic__c":"อื่นๆ","Comment__c":"","Type__c":"Mitigation/Precaution"}],' +
          					    '"emocTemporaryHistory":{"E_MOC_Application__c":"' + emocApp.Id + '","Action_by__c":"อื่นๆ","Yes__c":"true","Type__c":"Extend FN"}}';

        
        String paramUpdateEmoc2 = '{"emocApp": {"Id": "' + emocApp.Id + '","Fired_Heaters_Fire_Boiler__c":"true","Mechanical_change__c":"true","Air_Cooled_Exchangers__c":"true",' +
                                '"Status_Functional_Override__c":"Technical review","Safeguarding_force_signal__c":"true","MOS_for_maintenance__c":"false","Extend_Require_to_extend__c":"false","TA_Selection_confirmed__c":"true"},' +
           						'"ta2Man":[],' +
            					'"potentialRisk":[],"potentialConsequence":[],"mitigationPrecaution":[],' +
          					    '"emocTemporaryHistory":{"E_MOC_Application__c":"' + emocApp.Id + '","Action_by__c":"อื่นๆ","Yes__c":"false","Type__c":"Extend FN"}}';
		
        String paramUpdateEmoc4 = '{"emocApp": {"Id": "' + emocApp.Id + '","Fired_Heaters_Fire_Boiler__c":"true","Mechanical_change__c":"true","Air_Cooled_Exchangers__c":"true",' +
                                '"Status_Functional_Override__c":"Implementation#2","Safeguarding_force_signal__c":"true","MOS_for_maintenance__c":"false","Extend_Require_to_extend__c":"true"},' +
           						'"ta2Man":[],' +
            					'"potentialRisk":[],"potentialConsequence":[],"mitigationPrecaution":[],"emocTemporaryHistory":{}}';
        
        String paramInsertEmoc3 = '{"emocApp": {"Fired_Heaters_Fire_Boiler__c":"true","Mechanical_change__c":"true","Air_Cooled_Exchangers__c":"true",' +
                                '"Status_Functional_Override__c":"Create","Area__c":"E","Safeguarding_force_signal__c":"true","MOS_for_maintenance__c":"false","TA_Selection_confirmed__c":"true"},' +
            					'"ta2Man":[],"potentialRisk":[],"potentialConsequence":[],"mitigationPrecaution":[],"emocTemporaryHistory":{}}';

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
            
        EMOC_EmocFuncOverController.getEmocApplication(paramTest);
        EMOC_EmocFuncOverController.saveCreateEmoc(paramUpdateEmoc);
        EMOC_EmocFuncOverController.getEmocApplication(paramTest);
        EMOC_EmocFuncOverController.getTaManMaster(emocApp.Id);
        EMOC_EmocFuncOverController.getTaManMapping(emocApp.Id);
        EMOC_EmocFuncOverController.saveCreateEmoc(paramUpdateEmoc2);
        EMOC_EmocFuncOverController.getEmocApplication(paramTest);
        EMOC_EmocFuncOverController.getTaManMaster(emocApp.Id);
        EMOC_EmocFuncOverController.getTaManMapping(emocApp.Id);
        
        EMOC_EmocFuncOverController.getPotentialRiskList();
        EMOC_EmocFuncOverController.getPotentialConsequenceList();
        EMOC_EmocFuncOverController.getMitigationPrecautionList();
        EMOC_EmocFuncOverController.saveCreateEmoc(paramInsertEmoc3);
      
        EMOC_EmocFuncOverController.saveCreateEmoc(paramUpdateEmoc4);
        E_MOC_Prelim_Risk__c PrelimRisk = new E_MOC_Prelim_Risk__c();
        PrelimRisk.E_MOC_Application__c = emocApp.id;
        PrelimRisk.Topic__c = 'เมื่อทำการ Disable Alarm จะไม่มี Alarm เตือน';
        PrelimRisk.Comment__c = 'test 1';
        PrelimRisk.Type__c = 'Potential Risk';
        insert PrelimRisk;
        
        E_MOC_Prelim_Risk__c PrelimRisk2 = new E_MOC_Prelim_Risk__c();
        PrelimRisk2.E_MOC_Application__c = emocApp.id;
        PrelimRisk2.Topic__c = 'มีโอกาส Process upset หรือ Shutdown ได้';
        PrelimRisk2.Comment__c = 'test 2';
        PrelimRisk2.Type__c = 'Potential Consequence';
        insert PrelimRisk2;
        
        E_MOC_Prelim_Risk__c PrelimRisk3 = new E_MOC_Prelim_Risk__c();
        PrelimRisk3.E_MOC_Application__c = emocApp.id;
        PrelimRisk3.Topic__c = 'ไม่ต้องมีมาตรการเพิ่มเติมเนื่องจาก Equipment shutdown';
        PrelimRisk3.Comment__c = 'test 3';
        PrelimRisk3.Type__c = 'Mitigation/Precaution';
        insert PrelimRisk3;
        
        emocApp.Status_Functional_Override__c = 'Approval #3 (APU)';
        update emocApp;    
        emocApp.Status_Functional_Override__c = 'Approval #3 (VP)';
        update emocApp; 
        emocApp.Status_Functional_Override__c = 'Implementation#2';
        update emocApp; 
        emocApp.Status_Functional_Override__c = 'Return to normal condition';
        update emocApp; 
        emocApp.Status_Functional_Override__c = 'Close out';
        update emocApp;
        emocApp.Status_Functional_Override__c = 'Cancelled';
        update emocApp;

        EMOC_EmocFuncOverController.getPotentialConsequence(paramTest);
        EMOC_EmocFuncOverController.getMitigationPrecaution(paramTest);
        MAP<String, String> paramTa3Man = new Map<String, String>{'Indicator' => '', 'Section' => 'MROA'};
        EMOC_EmocFuncOverController.getTa3ManMaster(paramTa3Man);

        Test.stopTest();
    }
}