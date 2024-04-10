@RestResource(urlMapping='/EQCC_Step__c/*')
global with sharing class THOR_RESTEQCC {

    @HttpPost
    global static List<EQCC_Step__c> doPost(String startDate, String endDate) {
        Date start = Date.valueOf(startDate);
        Date endd = Date.valueOf(endDate);


        List<EQCC_Step__c> results = [SELECT Id, OwnerId, Name, IsDeleted__c, Form_Code__c,
                       Is_Current__c, Status__c, Step_Number__c, jsonString__c,
                       Header_Sheet__c, Percentage__c FROM EQCC_Step__c
                       WHERE LastModifiedDate  >=: start  AND LastModifiedDate <=: endd];
        /*
        List<EQCC_Wrapper> wraps = new List<EQCC_Wrapper>();
        for (EQCC_Step__c result: results)
        {
            EQCC_Wrapper eqccwrapper = new EQCC_Wrapper();
            eqccwrapper.OwnerId = result.OwnerId;
            eqccwrapper.Name = result.Name;
            eqccwrapper.IsDeleted =  String.valueOf(result.IsDeleted__c);
            eqccwrapper.Form_Code = String.valueOf(result.Form_Code__c);
            eqccwrapper.Is_Current =  String.valueOf(result.Is_Current__c);
            eqccwrapper.Status = result.Status__c;
            eqccwrapper.Step_Number =  String.valueOf(result.Step_Number__c);
            eqccwrapper.jsonString = result.jsonString__c;
            eqccwrapper.Header_Sheet = result.Header_Sheet__c;
            eqccwrapper.Percentage =  String.valueOf(result.Percentage__c);
            wraps.add(eqccwrapper);
        }*/
        return results;
    }
    /*
    global class EQCC_Wrapper {
         String OwnerId;
         String Name;
         String IsDeleted;
         String Form_Code;
         String Is_Current;
         String Status;
         String Step_Number;
         String jsonString;
         String Header_Sheet;
         String Percentage;
    }*/
}