@isTest
public class EMOC_TemporaryControllerTest {
    @testSetup static void Data() {
        Functional_Location__c funcLoc = new Functional_Location__c();
        funcLoc.Name = 'Test Functional Location';
        insert funcLoc;

        User currentuser = [Select Id,Name, Department from User where Id = :userinfo.getuserId()];
        currentuser.Department = 'EMOC';
        update currentuser;
        
        RecordType recordtype = [SELECT Id FROM RecordType WHERE Name='Common Workflow'];
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Functional_Location__c = funcLoc.Id;
        emoc.RecordTypeId = recordtype.Id;
        emoc.Change_Type__c = 'Permanent';
        emoc.RAM_Total__c = 'M';
        emoc.Next_Reminder_Date__c = Date.today();
        emoc.Emergency__c = true;
        emoc.OPM_OPEX__c = true;
        emoc.Mechanical_change__c = true;
        emoc.Air_Cooled_Exchangers__c = true;
        emoc.Status_Common_Workflow__c = 'Detailed Design/Study';
        emoc.Instrument_change__c = true;
        emoc.Alarm__c = true;
        emoc.Start_date__c = Date.today();
        emoc.End_date__c = Date.today();
        emoc.Temporary__c = true;
        emoc.Yes_Monitoring_Program_Requirement__c = true;
        emoc.No_Monitoring_Program_Requirement__c = false;
        emoc.Start_Date_Monitoring_Program__c = Date.today();
        emoc.End_Date_Monitoring_Program__c = Date.today();
        emoc.Remark_Monitoring_Program__c = 'test';
        emoc.Show_Require_to_Extend__c = Date.today();
        emoc.EMOC_Number_for_permanent_MOC__c = emoc.Id;
        emoc.MOC_Focal_Point_Name__c = currentuser.Id;
        insert emoc; 

        E_MOC_Activity__c Activity = new E_MOC_Activity__c();
        Activity.E_MOC_Application__c = emoc.id;
        Activity.Name = 'test';
        Activity.Period_frequency__c = '2 months';
        Activity.Action_by__c = currentuser.Id;
        Activity.Frequency_days__c = 60;
        insert Activity;
        
        E_MOC_Monitoring_Activity__c emocMonitoringActivity = new E_MOC_Monitoring_Activity__c();
        emocMonitoringActivity.E_MOC_Application_No__c = emoc.id;
        emocMonitoringActivity.E_MOC_Activity__c = Activity.id;
        emocMonitoringActivity.Name = 'test';
        emocMonitoringActivity.Date_Monitoring__c = Date.today();
		emocMonitoringActivity.Monitoring_result_Pass__c = false;
        emocMonitoringActivity.Monitoring_result_Not_Pass__c = true;
        emocMonitoringActivity.Monitoring_result_description__c = '';
        emocMonitoringActivity.Remark__c = '';                                              
        insert emocMonitoringActivity;
        
        E_MOC_Temporary_History__c emocTempoHis = new E_MOC_Temporary_History__c();
        emocTempoHis.E_MOC_Application__c = emoc.id;
        emocTempoHis.Yes__c = true;
        emocTempoHis.No__c = false;
        emocTempoHis.Remark__c = 'tttt';
        emocTempoHis.Type__c = 'Correct the problem by using existing solution';
        emocTempoHis.Date__c = Date.today();
        insert emocTempoHis;
        
    }
    static testmethod void testData() {
        Test.startTest();

        User currentuser = [Select Id,Name, Department from User where Id = :userinfo.getuserId()];
        EMOC_TemporaryController.getLookupUser(currentuser.Name);

        E_MOC_Application__c emocApp = [SELECT Id, Name FROM E_MOC_Application__c LIMIT 1];
        E_MOC_Monitoring_Activity__c emocMonitoringActivity = [SELECT Id, Name FROM E_MOC_Monitoring_Activity__c LIMIT 1];
        
        String paramUpdateEmoc = '{"emocApp": {"Id": "' + emocApp.Id + '","OPM_OPEX__c":"true","Mechanical_change__c":"true","Air_Cooled_Exchangers__c":"true",' +
           						'"Yes_Monitoring_Program_Requirement__c":"true","No_Monitoring_Program_Requirement__c":"false","Remark_Monitoring_Program__c":"",' +
            					'"Extend_Require_to_extend__c":"true","Yes_Require_to_demolish__c":"true",' +
                                '"Show_Require_to_Extend__c":"2022-07-02", "Start_Date_Monitoring_Program__c": "2022-08-02", "End_Date_Monitoring_Program__c": "2022-08-02"},' +
           	'"emocActivity":[{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ","Period_frequency__c":"1 month","Action_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ15","Period_frequency__c":"15 days","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ2","Period_frequency__c":"2 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ3","Period_frequency__c":"3 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ4","Period_frequency__c":"4 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ5","Period_frequency__c":"5 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ6","Period_frequency__c":"6 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ7","Period_frequency__c":"7 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ8","Period_frequency__c":"8 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ9","Period_frequency__c":"9 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ10","Period_frequency__c":"10 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"อื่นๆ11","Period_frequency__c":"11 months","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"1 year","Period_frequency__c":"1 year","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"1.5 years","Period_frequency__c":"1.5 years","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"2 years","Period_frequency__c":"2 years","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"3 years","Period_frequency__c":"3 years","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"},' +
            '{"E_MOC_Application__c":"' + emocApp.Id + '","Name":"6 years","Period_frequency__c":"6 years","Action_by__c":"' + currentuser.Id + '","Acknowledge__c":"true","Acknowledge_by__c":"' + currentuser.Id + '"}],' +
            '"emocTemporaryHistory": {"E_MOC_Application__c":"' + emocApp.Id + '","Yes__c": "true","No__c": "false","Remark__c": "test","Type__c": "Correct the problem by using existing solution","Date__c": "2022-07-02"},' +
            '"emocTemporaryHistory2": {"E_MOC_Application__c":"' + emocApp.Id + '","Yes__c": "true","No__c": "false","Remark__c": "test","Type__c": "Correct the problem by using existing solution","Date__c": "2022-07-02"},' +
            '"emocTemporaryHistory3": {"E_MOC_Application__c":"' + emocApp.Id + '","Yes__c": "true","No__c": "false","Remark__c": "test","Type__c": "Correct the problem by using existing solution","Date__c": "2022-07-02"}' +
            '}';

        String paramUpdateEmoc2 = '{"emocApp": {"Id": "' + emocApp.Id + '","Fired_Heaters_Fire_Boiler__c":"true","Mechanical_change__c":"true","Air_Cooled_Exchangers__c":"true","No_Monitoring_Program_Requirement__c":"true",' +
            '"Status_Common_Workflow__c":"Detailed Design/Study"},"emocActivity":[],"emocTemporaryHistory":{},"emocTemporaryHistory2":{},"emocTemporaryHistory3":{}}';
        
        String paramMonitoringResult = '[{"Id": "","E_MOC_Application_No__c": "' + emocApp.Id + '","E_MOC_Activity__c": "' + emocMonitoringActivity.Id + '","Name":"test",' +
            '"Date_Monitoring__c":"2022-09-02","Monitoring_result_Pass__c":"true","Monitoring_result_Not_Pass__c":"false","Remark__c":"false"' +
            '}]';

        Map<String, String> paramTest = new Map<String, String>();
        paramTest.put('emocApplicationId', emocApp.Id);
        paramTest.put('emocActivityId', emocApp.Id);
        paramTest.put('emocActivityName', emocMonitoringActivity.Id);
		
        Map<String, String> paramTest2 = new Map<String, String>();
        paramTest2.put('emocApplicationId', '');
        
        EMOC_TemporaryController.getEmocApplication(paramTest);
        EMOC_TemporaryController.saveCreateEmoc(paramUpdateEmoc);
        EMOC_TemporaryController.getPeriodFrequencyList();
        EMOC_TemporaryController.getEmocActivity(paramTest);
        EMOC_TemporaryController.getEmocActivity(paramTest2);
        EMOC_TemporaryController.saveCreateEmoc(paramUpdateEmoc2);
        EMOC_TemporaryController.saveMonitoringResult(paramMonitoringResult);
        
        EMOC_TemporaryController.getMonitoringResult(paramTest);
		EMOC_TemporaryController.getEmocTemporaryHistory(paramTest);
        EMOC_TemporaryController.getEmocTemporaryHistory2(paramTest);
        EMOC_TemporaryController.getLookupEmocNumber('');
        EMOC_TemporaryController.getLookupNotification('');
        
        EMOC_TemporaryController.getEmocApplication(paramTest);    
        Test.stopTest(); 
    }
}