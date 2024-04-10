@isTest
global class THOR_RESTEQCCTest {

    @testSetUp
    global static void testSetupdate()
    {
        EQCC_Header__c head = new EQCC_Header__c();
        insert head;

        EQCC_Checked_Sheet__c sheet = new EQCC_Checked_Sheet__c();
        sheet.Name = 'EQCC-ENMM-002';
        sheet.Form_Type__c = 'Overhung_pump_Horizontal';
        insert sheet;

        Header_Sheet__c hSheet = new Header_Sheet__c();
   		hSheet.Sheet__c = sheet.Id;
        hSheet.Header__c = head.Id;
        insert hSheet;

        List<EQCC_Step__c> EQCCList = new List<EQCC_Step__c>();
        EQCC_Step__c item = new EQCC_Step__c();
        item.Step_Number__c = 1.00;
        item.Form_Code__c = hSheet.Sheet__c;
        item.Header_Sheet__c = hSheet.id;
        item.isDeleted__c = False;
        //item.OwnerId = 'abcdfghijk';
        item.Name = 'a0E9D000001hTl0';
        item.Is_Current__c = True;
        item.Percentage__c = 55.00;
        //item.LastModifiedDate = '1/1/2021';

        EQCCList.add(item);
        insert EQCCList;
    }

	@isTest
    global static void testDoPost(){


        Date todayDate = system.today();

        String dateString = String.valueOf(todayDate);

        //system.debug('today date :'+dateString);

        //String[] dmy = dateString.split('-');

        //String dateStringformat = dmy[2] +'/'+dmy[1]+'/'+dmy[0];

        //system.debug('dateStringformat :'+dateStringformat);

        Test.startTest();
        List<EQCC_Step__c> displayEQCCList = THOR_RESTEQCC.doPost(dateString, dateString);
        Test.stopTest();


        System.assert(displayEQCCList != null);
    }
}