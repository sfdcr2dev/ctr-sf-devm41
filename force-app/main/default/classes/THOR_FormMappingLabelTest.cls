@isTest
public class THOR_FormMappingLabelTest {

    @TestSetup
    static void makeData() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE DeveloperName LIKE '%Tank%'
            LIMIT 1
        ];
        
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;
        
        Master_Map__c mm = new Master_Map__c();
        mm.Name = 'ENMA-E';
        mm.Code__c = 'ENMA-E';
        mm.Description__c = 'TPX ELECTRICAL AREA-F';
        mm.Type__c = 'Main Work Center';
        mm.Master_Map_Set__c = mms.Id;
        insert mm;
        
        Master_Map__c mm2 = new Master_Map__c();
        mm2.Name = '1200';
        mm2.Code__c = '1200';
        mm2.Description__c = 'TOP Sriracha Refinery';
        mm2.Type__c = 'Plant';
        mm2.Master_Map_Set__c = mms.Id;
        insert mm2;
        
        Functional_Location__c fl = new Functional_Location__c();
        fl.Name = '1234';
        fl.PlantSection__c = 'T1';
        fl.MainWorkCenter__c = mm.Id;
        fl.Maintenance_Plant__c = mm2.Id;
        insert fl;

        Equipment__c eq = new Equipment__c();
        eq.Name = '1234';
        eq.plantSection__c = 'T1';
        eq.mainWorkCenter__c = mm.Id;
        eq.maintenancePlant__c = mm2.Id;
        insert eq;
        
        EQCC_Header__c header = new EQCC_Header__c();
        header.FunctionalLocation__c = fl.Id;
        insert header;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c
        );
        insert checkedSheetToSubmit;
        
        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>{
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToSubmit.Id)
        };
        insert headerSheets;  
        
        EQCC_Step__c step = new EQCC_Step__c();
        step.Name = 'submit';
        step.Header_Sheet__c = headerSheets[0].Id;
        step.Step_Number__c = 1;
        step.Form_Code__c = formType.Form_Code__c;
        step.Is_Current__c = true;
        step.Status__c = 'Pending for approval';
        insert step;
        
        THOR_Form_Mapping__c form = new THOR_Form_Mapping__c();
        form.Eqcc_Step_Id__c = step.Id;
        insert form;
    }
    
    @isTest
    public static void testPositive() {
        EQCC_Step__c step = getMockStep('submit');
        Test.startTest();
        	THOR_FormMappingLabelController.updateFormMapping('test', '1234', step.Id, '1');
        	THOR_FormMappingLabelController.getCount(step.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testNegative() {
        Test.startTest();
        	THOR_FormMappingLabelController.updateFormMapping('test', '1234', null, '1');
        	THOR_FormMappingLabelController.getCount(null);
        Test.stopTest();
    }
    
    private static EQCC_Step__c getMockStep(String name) {
        return [SELECT Id FROM EQCC_Step__c WHERE Name =:name LIMIT 1];
    }
}