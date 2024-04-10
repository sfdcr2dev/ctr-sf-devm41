@isTest
public class THOR_PrintReportControllerTest {
@Testsetup
    public static void SetupData()
    {
             
    
        
    }
    @isTest
    static void testGetPrintRecordId() {
          EQCC_Step__c eqccstep = new EQCC_Step__c();
        eqccstep.Form_Code__c = 'EQCC-ENRM-002';
        eqccstep.Step_Number__c = 1;
        //eqccstep.Header_Sheet__r.Name = 'HS-11257';
        insert eqccstep;

        Test.startTest();
       EQCC_Step__c result = THOR_PrintReportController.getPrintRecordId(eqccstep.Id);
        system.assert(result != null);
        Test.stopTest();
    }
    @isTest
    static void testGetPrintRecordNull() {
 //       EQCC_Step__c eq = [SELECT Id FROM EQCC_Step__c LIMIT 1];
        Test.startTest();
       EQCC_Step__c result = THOR_PrintReportController.getPrintRecordId('2');
        system.assert(result == null);
        Test.stopTest();
    }
   
}