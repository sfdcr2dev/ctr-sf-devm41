@istest
public class EMOC_RecordReportPdfTest {
    @isTest static void testGetData(){
        Test.startTest();
        
        Master_Map__c mapMas1 = new Master_Map__c();
        mapMas1.Name = 'CR01';
        insert mapMas1;

        Master_Map__c mapMas2 = new Master_Map__c();
        mapMas2.Name = 'CR02';
        insert mapMas2;
        
        Functional_Location__c func = new Functional_Location__c();
        func.Name = 'Test Functional Location';
        func.Description__c = 'TEST';
       	func.MainWorkCenter__c = mapMas1.Id;
        func.mainWorkCenterPlant__c = mapMas1.Id;
        func.Mainworkcenter_type__c = 'MECH';
        insert func;
        
        RecordType recordtype = [SELECT Id FROM RecordType WHERE Name='Common Workflow'];
        RecordType recordtype2 = [SELECT Id, Name FROM RecordType WHERE Name='Functional Override'];
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Status_Common_Workflow__c = 'Concept Approval';
        emoc.Common_Workflow__c = true;
        emoc.Functional_Location__c = func.Id;
        emoc.Change_Type__c = 'Permanent';
        emoc.RAM_Total__c = 'M';
        emoc.Next_Reminder_Date__c = Date.today();
        emoc.Emergency__c = true;
        emoc.Functional_Location__c = func.Id;
        emoc.Step__c = 'Concept Approval';
        emoc.RecordTypeId = recordtype.Id;
        insert emoc; 
        
        E_MOC_Application__c emoc3 = new E_MOC_Application__c();
        emoc3.Status_Functional_Override__c = 'Technical review';
        emoc3.Status_Common_Workflow__c = 'Emergency Approval';
        emoc3.Functional_Override__c = true;
        emoc3.Functional_Location__c = func.Id;
        emoc3.RecordTypeId = recordtype2.Id;
        emoc3.Change_Type__c = 'Permanent';
        emoc3.RAM_Total__c = 'M';
        emoc3.Next_Reminder_Date__c = Date.today();
        emoc3.Emergency__c = true;
        insert emoc3; 
        
        E_MOC_Application__c emoc4 = new E_MOC_Application__c();
        emoc4.MOC_Type__c = 'Emergency';
        emoc4.Functional_Override__c = true;
        emoc4.Functional_Location__c = func.Id;
        emoc4.RecordTypeId = recordtype.Id;
        emoc4.Change_Type__c = 'Permanent';
        emoc4.RAM_Total__c = 'M';
        emoc4.Next_Reminder_Date__c = Date.today();
        emoc4.Emergency__c = true;
        emoc4.OPM_OPEX__c = true;
        emoc4.Mechanical_change__c = true;
        emoc4.Air_Cooled_Exchangers__c = true;
        emoc4.Status_Functional_Override__c = 'Create';
        emoc4.Instrument_change__c = true;
        emoc4.Alarm__c = true;
        emoc4.Start_date__c = Date.today();
        emoc4.End_date__c = Date.today();
        emoc4.MOS_for_maintenance__c  = true;
        emoc4.Safeguarding_force_signal__c = false;
        emoc4.Potential_Risk_c__c = 'เมื่อทำการ Disable Alarm จะไม่มี Alarm เตือน';
        emoc4.Potential_Consequence_c__c = 'มีโอกาส Process upset หรือ Shutdown ได้';
        emoc4.Mitigation_Precaution_1__c = 'ไม่ต้องมีมาตรการเพิ่มเติมเนื่องจาก Equipment shutdown';
        insert emoc4; 
        
        E_MOC_Timeline__c et4 = new E_MOC_Timeline__c();
        et4.Status__c = 'Technical review';
        et4.Change_Type__c = 'Permanent';
        et4.RAM_Level__c = 'M';
        et4.Area__c = 'A';
        et4.Day__c = 1;
        insert et4;
        
        E_MOC_Prelim_Risk__c PrelimRisk = new E_MOC_Prelim_Risk__c();
        PrelimRisk.E_MOC_Application__c = emoc4.id;
        PrelimRisk.Topic__c = 'เมื่อทำการ Disable Alarm จะไม่มี Alarm เตือน';
        PrelimRisk.Comment__c = 'test 1';
        PrelimRisk.Type__c = 'Potential Risk';
        insert PrelimRisk;
        
        E_MOC_Prelim_Risk__c PrelimRisk2 = new E_MOC_Prelim_Risk__c();
        PrelimRisk2.E_MOC_Application__c = emoc4.id;
        PrelimRisk2.Topic__c = 'มีโอกาส Process upset หรือ Shutdown ได้';
        PrelimRisk2.Comment__c = 'test 2';
        PrelimRisk2.Type__c = 'Potential Consequence';
        insert PrelimRisk2;
        
        E_MOC_Prelim_Risk__c PrelimRisk3 = new E_MOC_Prelim_Risk__c();
        PrelimRisk3.E_MOC_Application__c = emoc4.id;
        PrelimRisk3.Topic__c = 'ไม่ต้องมีมาตรการเพิ่มเติมเนื่องจาก Equipment shutdown';
        PrelimRisk3.Comment__c = 'test 3';
        PrelimRisk3.Type__c = 'Mitigation/Precaution';
        insert PrelimRisk3;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('test');
        req.setObjectId(emoc.Id);
        Approval.ProcessResult result = Approval.process(req);
        
        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
        req3.setComments('test3');
        req3.setObjectId(emoc3.Id);
        Approval.ProcessResult result3 = Approval.process(req3);
        
        Approval.ProcessSubmitRequest req4 = new Approval.ProcessSubmitRequest();
        req4.setComments('test4');
        req4.setObjectId(emoc4.Id);
        Approval.ProcessResult result4 = Approval.process(req4);

   
        ApexPages.currentPage().getParameters().put('id',emoc.id);
        EMOC_RecordReportPdf testreport = new EMOC_RecordReportPdf();
        
        ApexPages.currentPage().getParameters().put('id',emoc3.id);
        EMOC_RecordReportPdf testreport2 = new EMOC_RecordReportPdf();
        
        ApexPages.currentPage().getParameters().put('id',emoc4.id);
        EMOC_RecordReportFNPdf testreport3 = new EMOC_RecordReportFNPdf();
        
        ApexPages.currentPage().getParameters().put('id',emoc3.id);
        EMOC_RecordReportFNPdf testreport4 = new EMOC_RecordReportFNPdf();
        
        Test.stopTest();
    }
}