@isTest
public class ESSMSS_REST_EmployeeImportTest {
    @Testsetup
    public static void setupData()
    {
        ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper empInpWrap = new ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper();

        List<ESS_Master_Employee__c> empList = new List<ESS_Master_Employee__c>();
        List<ESS_Application__c> appList = new List<ESS_Application__c>();
        List<ESS_Retirement__c> retirementList = new List<ESS_Retirement__c>();

        ESS_Application__c  essApp = new ESS_Application__c ( 
            Status__c = 'SendingToSAP',
            Completed_Date__c = null
        );
        appList.add(essApp);
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
    }

    @isTest
    public static void testEmployeeImportPost()
    {
        List<ESS_Application__c> appId = [SELECT Id,Completed_Date__c FROM ESS_Application__c];

        String jsonSTR = '{ "SAPEmployeeList": [ { "Employee_ID":"99999990", "Applicaion_Id":"'+ appId[0].Id +'"'
                            +',"Status_Divorce_EN_FN":"TEST","Status_Divorce_EN_LN":"TEST","Status_Divorce_TH_FN":"TEST","Status_Divorce_TH_LN":"TEST","Status_Marriage_TH_FN":"TEST","Status_Marriage_TH_LN":"TEST","Status_Widow_EN_FN":"TEST","Status_Widow_EN_LN":"TEST","Status_Widow_TH_FN":"TEST","Status_Widow_TH_LN":"TEST"'
                            +',"Name_Marriage_TH_Title":"TEST","Name_Mother_TH_Title":"TEST","Position":"TEST","Name_Child_Count":"2", "Employee_DOB":"2022-12-06", "Retirement_Date":"2022-12-09", "Employee_Date_Joined":"", "Employee_Retirement_Date":"2022-12-06", "Status":"0", "Address_EN_Current_House_No":"NAME210", "Address_EN_House_No":"NAME210", "Address_TH_Current_House_No":"NAME210", "Address_TH_House_No":"NAME210", "Address_EN_Current_Moo_Village_Soi_Road":"STRAS10", "Address_EN_Moo_Village_Soi_Road":"STRAS10", "Address_TH_Current_Moo_Village_Soi_Road":"STRAS10", "Address_TH_Moo_Village_Soi_Road":"STRAS10", "Address_EN_Current_Postal_Code":"PST_5", "Address_EN_Postal_Code":"PST_5", "Address_TH_Current_Postal_Code":"PST_5", "Address_TH_Postal_Code":"PST_5", "Address_EN_Current_Province":"ORT01_25", "Address_EN_Province":"ORT01_25", "Address_TH_Current_Province":"ORT01_25", "Address_TH_Province":"ORT01_25", "Address_EN_Current_SubDistrict_District":"LOCAT 255", "Address_EN_SubDistrict_District":"LOCAT 255", "Address_TH_Current_SubDistrict_District":"LOCAT 255", "Address_TH_SubDistrict_District":"LOCAT 255", "Address_EN_Current_Telephone_No":"TELNRZS99", "Address_EN_Telephone_No":"TELNRZS99", "Address_TH_Current_Telephone_No":"TELNRZS99", "Address_TH_Telephone_No":"TELNRZS99", "Child_JSON":"TELNRZS99", "Contact_Person_JSON":"TELNRZS99", "Death_Child_JSON":"TELNRZS99", "Death_Father_FN":"FAVORZS99", "Death_Marriage_FN":"FAVORZS99", "Death_Mother_FN":"FAVORZS99", "Name_Father_EN_FN":"FAVORZS99", "Name_Father_TH_FN":"FAVORZS99", "Name_Marriage_EN_FN":"FAVORZS99", "Name_Marriage_TH_FN":"FAVORZS99", "Name_Mother_EN_FN":"FAVORZS99", "Name_Mother_TH_FN":"FAVORZS99", "Death_Father_LN":"FANAMZS99", "Death_Marriage_LN":"FANAMZS99", "Death_Mother_LN":"FANAMZS99", "Name_Father_EN_LN":"FANAMZS99", "Name_Father_TH_LN":"FANAMZS99", "Name_Marriage_EN_LN":"FANAMZS99", "Name_Marriage_TH_LN":"FANAMZS99", "Name_Mother_EN_LN":"FANAMZS99", "Name_Mother_TH_LN":"FANAMZS99", "Education_JSON":"FANAMZS99", "License_Citizen_Expire_Date":"2022-12-06", "License_Professional_Doc_Expire_Date":"2022-12-06", "License_Citizen_Issue_Date":"2022-12-06", "License_Professional_Doc_Issue_Date":"2022-12-06", "License_Citizen_Issue_Province":"EXPID", "License_Professional_Engineer":"EXPID", "License_Professional_Doc_Level":"ICNUM", "License_Professional_Doc_No":"ICNUM", "Name_Child_JSON":"ICNUM", "License_Citizen_Id":"ICNUM", "Status_Marriage_Doc_Issue_Date":"2022-12-06", "Name_Emp_EN_FN":"TestEmpFN", "Status_Marriage_EN_FN":"TestEmpFN", "Name_Emp_EN_LN":"TestEmpLN", "Status_Marriage_EN_LN":"TestEmpLN", "Name_Emp_EN_Title":"TestEmpLN", "Name_Emp_TH_Title_FN_LN":"TestEmpLN", "Status_Marriage_Status": "0", "Tax_Marriage_Status":"0", "Tax_Annuity_Interest_Amount": 1.10, "Tax_Child_Count": 1.2, "Tax_Donation_For_Charity_Amount":1.10, "Tax_Donation_For_Education_Amount":1.10, "Tax_First_House_Exclude_Tax_Amount":1.10, "Tax_Income_From_RMF_Amount":1.10, "Tax_Income_From_SSF_Amount":1.10, "Tax_Interest_On_Loan_For_House_Amount":1.10, "Tax_Marriage_Person_Earn_Income":1.10, "Tax_Married_Deduction_Father_Amount":1.10, "Tax_Married_Deduction_Mother_Amount":1.10, "Tax_Married_Father_Insurance_Paid_Amount":1.10, "Tax_Married_Life_Insurance_Paid_Amount":1.10, "Tax_Married_Mother_Insurance_Paid_Amount":1.10, "Tax_Pregnancy_Care_Amount":1.10, "Tax_Self_Deduction_Father_Amount":1.10, "Tax_Self_Deduction_Mother_Amount":1.10, "Tax_Self_Father_Insurance_Paid_Amount":1.10, "Tax_Self_Life_Insurance_Paid_Amount":1.10, "Tax_Self_Mother_Insurance_Paid_Amount":1.10, "Tax_Sponsor_Amount":1.10, "Tax_Total_Child_Count":1.10 } ] }';

		Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR); 
        String convertResp = JSON.serialize(responseValue.get('SAPEmployeeList')) ;
        List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>  sapo = (List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>)JSON.deserialize(convertResp, List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>.class);

        Test.startTest(); 
        ESSMSS_REST_EmployeeImportController.employeeImportPost(sapo);
        Test.stopTest();
        List<ESS_Master_Employee__c> upsertedDO = [select id from ESS_Master_Employee__c];
        System.assert(upsertedDO.size() > 0);
        
    }

    @isTest
    public static void testEmployeeImportIsError()
    {
        List<ESS_Application__c> appId = [SELECT Id,Completed_Date__c FROM ESS_Application__c];

        String jsonSTR = '{ "SAPEmployeeList": [ { "Employee_ID":"99999990", "Applicaion_Id":"'+ appId[0].Id +'"'
                            +',"Status_Divorce_EN_FN":"TEST","Status_Divorce_EN_LN":"TEST","Status_Divorce_TH_FN":"TEST","Status_Divorce_TH_LN":"TEST","Status_Marriage_TH_FN":"TEST","Status_Marriage_TH_LN":"TEST","Status_Widow_EN_FN":"TEST","Status_Widow_EN_LN":"TEST","Status_Widow_TH_FN":"TEST","Status_Widow_TH_LN":"TEST"'
                            +',"Name_Marriage_TH_Title":"TEST","Name_Mother_TH_Title":"TEST","Position":"TEST","Name_Child_Count":"2", "Employee_DOB":"2022-12-06", "Retirement_Date":"-09", "Employee_Date_Joined":"", "Employee_Retirement_Date":"-06", "Status":"66", "Address_EN_Current_House_No":"", "Address_EN_House_No":"NAME210", "Address_TH_Current_House_No":"NAME210", "Address_TH_House_No":"NAME210", "Address_EN_Current_Moo_Village_Soi_Road":"STRAS10", "Address_EN_Moo_Village_Soi_Road":"STRAS10", "Address_TH_Current_Moo_Village_Soi_Road":"STRAS10", "Address_TH_Moo_Village_Soi_Road":"STRAS10", "Address_EN_Current_Postal_Code":"PST_5", "Address_EN_Postal_Code":"PST_5", "Address_TH_Current_Postal_Code":"PST_5", "Address_TH_Postal_Code":"PST_5", "Address_EN_Current_Province":"ORT01_25", "Address_EN_Province":"ORT01_25", "Address_TH_Current_Province":"ORT01_25", "Address_TH_Province":"ORT01_25", "Address_EN_Current_SubDistrict_District":"LOCAT 255", "Address_EN_SubDistrict_District":"LOCAT 255", "Address_TH_Current_SubDistrict_District":"LOCAT 255", "Address_TH_SubDistrict_District":"LOCAT 255", "Address_EN_Current_Telephone_No":"TELNRZS99", "Address_EN_Telephone_No":"TELNRZS99", "Address_TH_Current_Telephone_No":"TELNRZS99", "Address_TH_Telephone_No":"TELNRZS99", "Child_JSON":"TELNRZS99", "Contact_Person_JSON":"TELNRZS99", "Death_Child_JSON":"TELNRZS99", "Death_Father_FN":"FAVORZS99", "Death_Marriage_FN":"FAVORZS99", "Death_Mother_FN":"FAVORZS99", "Name_Father_EN_FN":"FAVORZS99", "Name_Father_TH_FN":"FAVORZS99", "Name_Marriage_EN_FN":"FAVORZS99", "Name_Marriage_TH_FN":"FAVORZS99", "Name_Mother_EN_FN":"FAVORZS99", "Name_Mother_TH_FN":"FAVORZS99", "Death_Father_LN":"FANAMZS99", "Death_Marriage_LN":"FANAMZS99", "Death_Mother_LN":"FANAMZS99", "Name_Father_EN_LN":"FANAMZS99", "Name_Father_TH_LN":"FANAMZS99", "Name_Marriage_EN_LN":"FANAMZS99", "Name_Marriage_TH_LN":"FANAMZS99", "Name_Mother_EN_LN":"FANAMZS99", "Name_Mother_TH_LN":"FANAMZS99", "Education_JSON":"FANAMZS99", "License_Citizen_Expire_Date":"2022-12-06", "License_Professional_Doc_Expire_Date":"2022-12-06", "License_Citizen_Issue_Date":"2022-12-06", "License_Professional_Doc_Issue_Date":"2022-12-06", "License_Citizen_Issue_Province":"EXPID", "License_Professional_Engineer":"EXPID", "License_Professional_Doc_Level":"ICNUM", "License_Professional_Doc_No":"ICNUM", "Name_Child_JSON":"ICNUM", "License_Citizen_Id":"ICNUM", "Status_Marriage_Doc_Issue_Date":"2022-12-06", "Name_Emp_EN_FN":"TestEmpFN", "Status_Marriage_EN_FN":"TestEmpFN", "Name_Emp_EN_LN":"TestEmpLN", "Status_Marriage_EN_LN":"TestEmpLN", "Name_Emp_EN_Title":"TestEmpLN", "Name_Emp_TH_Title_FN_LN":"TestEmpLN", "Status_Marriage_Status": "0", "Tax_Marriage_Status":"0", "Tax_Annuity_Interest_Amount": 1.10, "Tax_Child_Count": 1.2, "Tax_Donation_For_Charity_Amount":1.10, "Tax_Donation_For_Education_Amount":1.10, "Tax_First_House_Exclude_Tax_Amount":1.10, "Tax_Income_From_RMF_Amount":1.10, "Tax_Income_From_SSF_Amount":"1.10", "Tax_Interest_On_Loan_For_House_Amount":"Test", "Tax_Marriage_Person_Earn_Income":1.10, "Tax_Married_Deduction_Father_Amount":1.10, "Tax_Married_Deduction_Mother_Amount":1.10, "Tax_Married_Father_Insurance_Paid_Amount":1.10, "Tax_Married_Life_Insurance_Paid_Amount":1.10, "Tax_Married_Mother_Insurance_Paid_Amount":1.10, "Tax_Pregnancy_Care_Amount":1.10, "Tax_Self_Deduction_Father_Amount":1.10, "Tax_Self_Deduction_Mother_Amount":1.10, "Tax_Self_Father_Insurance_Paid_Amount":1.10, "Tax_Self_Life_Insurance_Paid_Amount":1.10, "Tax_Self_Mother_Insurance_Paid_Amount":1.10, "Tax_Sponsor_Amount":1.10, "Tax_Total_Child_Count":1.10 } ] }';

        Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String convertResp = JSON.serialize(responseValue.get('SAPEmployeeList')) ;
        List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>  sapo = (List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>)JSON.deserialize(convertResp, List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>.class);
        
        Test.startTest(); 
        ESSMSS_REST_EmployeeImportController.employeeImportPost(sapo);
        Test.stopTest();
        List<ESS_Master_Employee__c> upsertedDO = [select id from ESS_Master_Employee__c];
        System.assert(upsertedDO.size() > 0);
        
    }

    @isTest
    public static void testEmployeeImportIsNull()
   {
       List<ESS_Application__c> appId = [SELECT Id,Completed_Date__c FROM ESS_Application__c];

       String jsonSTR = '{ "SAPEmployeeList": [ { },{ "Employee_ID":"99999990", "Applicaion_Id":"'+ appId[0].Id +'","Name_Child_Count":"", "Employee_DOB":"2022-12-06", "Retirement_Date":"", "Employee_Date_Joined":"", "Employee_Retirement_Date":"2022-12-06", "Status":"0", "Address_EN_Current_House_No":"NAME210", "Address_EN_House_No":"NAME210", "Address_TH_Current_House_No":"NAME210", "Address_TH_House_No":"NAME210", "Address_EN_Current_Moo_Village_Soi_Road":"STRAS10", "Address_EN_Moo_Village_Soi_Road":"STRAS10", "Address_TH_Current_Moo_Village_Soi_Road":"STRAS10", "Address_TH_Moo_Village_Soi_Road":"STRAS10", "Address_EN_Current_Postal_Code":"PST_5", "Address_EN_Postal_Code":"PST_5", "Address_TH_Current_Postal_Code":"PST_5", "Address_TH_Postal_Code":"PST_5", "Address_EN_Current_Province":"ORT01_25", "Address_EN_Province":"ORT01_25", "Address_TH_Current_Province":"ORT01_25", "Address_TH_Province":"ORT01_25", "Address_EN_Current_SubDistrict_District":"LOCAT 255", "Address_EN_SubDistrict_District":"LOCAT 255", "Address_TH_Current_SubDistrict_District":"LOCAT 255", "Address_TH_SubDistrict_District":"LOCAT 255", "Address_EN_Current_Telephone_No":"TELNRZS99", "Address_EN_Telephone_No":"TELNRZS99", "Address_TH_Current_Telephone_No":"TELNRZS99", "Address_TH_Telephone_No":"TELNRZS99", "Child_JSON":"TELNRZS99", "Contact_Person_JSON":"TELNRZS99", "Death_Child_JSON":"TELNRZS99", "Death_Father_FN":"FAVORZS99", "Death_Marriage_FN":"FAVORZS99", "Death_Mother_FN":"FAVORZS99", "Name_Father_EN_FN":"FAVORZS99", "Name_Father_TH_FN":"FAVORZS99", "Name_Marriage_EN_FN":"FAVORZS99", "Name_Marriage_TH_FN":"FAVORZS99", "Name_Mother_EN_FN":"FAVORZS99", "Name_Mother_TH_FN":"FAVORZS99", "Death_Father_LN":"FANAMZS99", "Death_Marriage_LN":"FANAMZS99", "Death_Mother_LN":"FANAMZS99", "Name_Father_EN_LN":"FANAMZS99", "Name_Father_TH_LN":"FANAMZS99", "Name_Marriage_EN_LN":"FANAMZS99", "Name_Marriage_TH_LN":"FANAMZS99", "Name_Mother_EN_LN":"FANAMZS99", "Name_Mother_TH_LN":"FANAMZS99", "Education_JSON":"FANAMZS99", "License_Citizen_Expire_Date":"2022-12-06", "License_Professional_Doc_Expire_Date":"2022-12-06", "License_Citizen_Issue_Date":"2022-12-06", "License_Professional_Doc_Issue_Date":"2022-12-06", "License_Citizen_Issue_Province":"EXPID", "License_Professional_Engineer":"EXPID", "License_Professional_Doc_Level":"ICNUM", "License_Professional_Doc_No":"ICNUM", "Name_Child_JSON":"ICNUM", "License_Citizen_Id":"ICNUM", "Status_Marriage_Doc_Issue_Date":"2022-12-06", "Name_Emp_EN_FN":"TestEmpFN", "Status_Marriage_EN_FN":"TestEmpFN", "Name_Emp_EN_LN":"TestEmpLN", "Status_Marriage_EN_LN":"TestEmpLN", "Name_Emp_EN_Title":"TestEmpLN", "Name_Emp_TH_Title_FN_LN":"TestEmpLN", "Status_Marriage_Status": "0", "Tax_Marriage_Status":"0", "Tax_Annuity_Interest_Amount": 1.10, "Tax_Child_Count": 1.2, "Tax_Donation_For_Charity_Amount":1.10, "Tax_Donation_For_Education_Amount":1.10, "Tax_First_House_Exclude_Tax_Amount":1.10, "Tax_Income_From_RMF_Amount":1.10, "Tax_Income_From_SSF_Amount":1.10, "Tax_Interest_On_Loan_For_House_Amount":1.10, "Tax_Marriage_Person_Earn_Income":1.10, "Tax_Married_Deduction_Father_Amount":1.10, "Tax_Married_Deduction_Mother_Amount":1.10, "Tax_Married_Father_Insurance_Paid_Amount":1.10, "Tax_Married_Life_Insurance_Paid_Amount":1.10, "Tax_Married_Mother_Insurance_Paid_Amount":1.10, "Tax_Pregnancy_Care_Amount":1.10, "Tax_Self_Deduction_Father_Amount":1.10, "Tax_Self_Deduction_Mother_Amount":1.10, "Tax_Self_Father_Insurance_Paid_Amount":1.10, "Tax_Self_Life_Insurance_Paid_Amount":1.10, "Tax_Self_Mother_Insurance_Paid_Amount":1.10, "Tax_Sponsor_Amount":1.10, "Tax_Total_Child_Count":1.10 } ] }';
       
       Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
       String convertResp = JSON.serialize(responseValue.get('SAPEmployeeList')) ;
       List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>  sapo = (List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>)JSON.deserialize(convertResp, List<ESSMSS_REST_EmployeeImportController.EmployeeImportWrapper>.class);
       
       Test.startTest(); 
       ESSMSS_REST_EmployeeImportController.employeeImportPost(sapo);
       Test.stopTest();
       List<ESS_Master_Employee__c> upsertedDO = [select id from ESS_Master_Employee__c];
       System.assert(upsertedDO.size() > 0);
       
   }

}