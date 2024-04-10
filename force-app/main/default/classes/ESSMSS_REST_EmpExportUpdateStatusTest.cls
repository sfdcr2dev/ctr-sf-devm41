@isTest
public class ESSMSS_REST_EmpExportUpdateStatusTest {
    @Testsetup
    public static void setupData()
    {
        List<ESS_Master_Employee__c> empList = new List<ESS_Master_Employee__c>();
        List<ESS_Application__c> appList = new List<ESS_Application__c>();
        List<ESS_Retirement__c> retirementList = new List<ESS_Retirement__c>();

        ESS_Application__c  essApp = new ESS_Application__c ( 
            Status__c = 'SendingToSAP',
            Completed_Date__c = null
        );
        appList.add(essApp);
        
        ESS_Application__c  essApp2 = new ESS_Application__c ( 
            Status__c = 'SendingToSAP',
            Completed_Date__c = null
        );
        appList.add(essApp2);

        // ESS_Application__c  essApp3 = new ESS_Application__c ( 
        //     Status__c = 'SendingToSAP',
        //     Completed_Date__c = null
        // );
        // appList.add(essApp3);
        insert appList;
        
        ESS_Master_Employee__c essEmp = new ESS_Master_Employee__c( 
            Employee_ID__c = '99999990',
            Status__c = 'SendingToSAP',
            Completed_Date__c = null,
            SAP_JSON__c = null,
            ExternalId__c = '99999990'+essApp.Id
        ); 
        empList.add(essEmp);
        
        ESS_Master_Employee__c essEmp2 = new ESS_Master_Employee__c( 
            Employee_ID__c = '99999991',
            Status__c = 'SendingToSAP',
            Completed_Date__c = null,
            SAP_JSON__c = null,
            ExternalId__c = '99999991'+essApp.Id
        ); 
        empList.add(essEmp2);

        ESS_Master_Employee__c essEmp3 = new ESS_Master_Employee__c( 
            Employee_ID__c = '99999992',
            Status__c = 'SendingToSAP',
            Completed_Date__c = null,
            SAP_JSON__c = null,
            ExternalId__c = '99999992'+essApp.Id
        ); 
        empList.add(essEmp3);

        ESS_Master_Employee__c essEmp4= new ESS_Master_Employee__c( 
            Employee_ID__c = '99999993',
            Status__c = 'SendingToSAP',
            Completed_Date__c = null,
            SAP_JSON__c = null,
            ExternalId__c = '99999993'+essApp2.Id
        ); 
        empList.add(essEmp4);

        insert empList;

        ESS_Retirement__c rtm1 = new ESS_Retirement__c(
            Employee_ID__c = '99999990',
            Status__c = 'SendingToSAP',
            Completed_Date__c = null,
            SAP_JSON__c = null,
            Sending_To_SAP_Date__c = Date.today()
        );
        retirementList.add(rtm1);

        ESS_Retirement__c rtm2 = new ESS_Retirement__c(
            Employee_ID__c = '99999991',
            Status__c = 'SendingToSAP',
            Completed_Date__c = null,
            SAP_JSON__c = null,
            Sending_To_SAP_Date__c = Date.today()
        );
        retirementList.add(rtm2);
    
        insert retirementList;

        // System.debug(empList);
    }
    
    @isTest
    public static void EmployeeExportUpdateStatusTestSuccess()
    {
        
        //Query id แทนการ fixed แล้วจัด JSON
        List<ESS_Application__c> appId = [SELECT Id,Completed_Date__c FROM ESS_Application__c];
        // System.debug('appId > '+appId+'appId[2] > '+appId[2]);
        String jsonSTR = '{"SAPUpdateStatusList": ['+
                            '{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999990","Applicaion_Id": "'+ appId[0].Id +'"}'
                            +',{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999993","Applicaion_Id": "'+ appId[1].Id +'"}'
                            +',{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999990","Applicaion_Id": null}'
                        +']}';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String SAPESSJSON = JSON.serialize(response_value.get('SAPUpdateStatusList')) ;
        List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>  sapo = (List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>)JSON.deserialize(SAPESSJSON, List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>.class);
        
        Test.startTest(); 
        ESSMSS_REST_EmpExportUpdateStatusCtrl.employeeExportUpdateStatusPost(sapo);
        Test.stopTest();
        System.debug(sapo);
        List<ESS_Master_Employee__c> upsertedDO = [select id from ESS_Master_Employee__c];
        System.assert(upsertedDO.size() > 0);
    }
    
    @isTest
    public static void EmployeeExportUpdateStatusTestFail()
    {
        List<ESS_Application__c> appId = [SELECT Id FROM ESS_Application__c];

        System.debug(appId);
        // String jsonSTR = '{"SAPUpdateStatusList": [{"Status": "Waiting","Completed_Date" : "2022-11-15","SAP_JSON": "","Employee_Id": null,"Applicaion_Id": "'+appId[0].Id+'"},'+
        //     '{"Status": "Waiting","Completed_Date" : "2022-11-18","SAP_JSON": "","Employee_Id": "080001790000000000000000000000","Applicaion_Id": "'+appId[1].Id+'"} ]}';
        String jsonSTR = '{"SAPUpdateStatusList": ['+
                            '{"Status": "VerifiedSSSSSSSS","Completed_Date" : "2022-12-07","SAP_JSON": null,"Employee_Id": "99999990","Applicaion_Id": "'+ appId[0].Id +'"}'+
                            // '{"Status": "Waiting","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": null,"Applicaion_Id": "'+ appId[0].Id +'"},'+
                            ',{"Status": "Waiting","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999990","Applicaion_Id": null}'+
                            // +',{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": null,"Applicaion_Id": null}'+
                        ']}';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String SAPESSJSON = JSON.serialize(response_value.get('SAPUpdateStatusList')) ;
        List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>  sapo = (List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>)JSON.deserialize(SAPESSJSON, List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>.class);
        
        Test.startTest(); 
        ESSMSS_REST_EmpExportUpdateStatusCtrl.employeeExportUpdateStatusPost(sapo);
        Test.stopTest();
        System.debug(sapo);
        List<ESS_Master_Employee__c> upsertedDO = [select id from ESS_Master_Employee__c];
        System.assert(upsertedDO.size() > 0);
    }
    
    @isTest
    public static void EmployeeExportUpdateStatusTestFailSomeRecord()
    {
        List<ESS_Application__c> appId = [SELECT Id FROM ESS_Application__c];
        System.debug(appId);
        // String jsonSTR = '{"SAPUpdateStatusList": [{"Status": "Completed","Completed_Date" : "2022-11-15","SAP_JSON": "","Employee_Id": null,"Applicaion_Id": "'+appId[0].Id+'"},'+
        //     '{"Status": "Waiting","Completed_Date" : "2022-11-18","SAP_JSON": "","Employee_Id": "08000086","Applicaion_Id": "'+appId[1].Id+'"} ]}';
        String jsonSTR = '{"SAPUpdateStatusList": ['+
                            // '{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999990","Applicaion_Id": "'+ appId[0].Id +'"},'+
                            // '{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999991","Applicaion_Id": "'+ appId[0].Id +'"}'
                            // +',{"Status": "Verified","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999990","Applicaion_Id": null}'+

                            '{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999990","Applicaion_Id": "'+ appId[0].Id +'"}'
                            // +',{"Status": "Wait","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999991","Applicaion_Id": "'+ appId[0].Id +'"}'
                            +',{"Status": "Verified","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999990","Applicaion_Id": "'+ appId[0].Id +'"}'+
                            +',{"Status": "Completed","Completed_Date" : "2022-12-07","SAP_JSON": "","Employee_Id": "99999991","Applicaion_Id": null}'
                        +']}';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String SAPESSJSON = JSON.serialize(response_value.get('SAPUpdateStatusList')) ;
        List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>  sapo = (List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>)JSON.deserialize(SAPESSJSON, List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>.class);
        
        Test.startTest(); 
        ESSMSS_REST_EmpExportUpdateStatusCtrl.employeeExportUpdateStatusPost(sapo);
        Test.stopTest();
        System.debug(sapo);
        List<ESS_Master_Employee__c> upsertedDO = [select id from ESS_Master_Employee__c];
        System.assert(upsertedDO.size() > 0);
    }
    
    @isTest
    public static void EmployeeExportUpdateStatusTestERROR()
    {
        List<ESS_Application__c> appId = [SELECT Id FROM ESS_Application__c];
        System.debug(appId);
        String jsonSTR = '{"SAPUpdateStatusList": [{"Status": "Error","Completed_Date" : "14-11-2022","SAP_JSON": "","Employee_Id": "080001790000000000000000000000","Applicaion_Id": "'+appId[0].Id+'"}]}';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String SAPESSJSON = JSON.serialize(response_value.get('SAPUpdateStatusList')) ;
        List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>  sapo = (List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>)JSON.deserialize(SAPESSJSON, List<ESSMSS_REST_EmpExportUpdateStatusCtrl.EmployeeExportUpdateStatusWrapper>.class);
        
        Test.startTest(); 
        ESSMSS_REST_EmpExportUpdateStatusCtrl.employeeExportUpdateStatusPost(sapo);
        Test.stopTest();
        System.debug(sapo);
        List<ESS_Master_Employee__c> upsertedDO = [select id from ESS_Master_Employee__c];
        System.assert(upsertedDO.size() > 0);
    }
    
    
}