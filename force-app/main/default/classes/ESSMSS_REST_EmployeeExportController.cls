@RestResource(urlMapping='/ESSMSS_EmployeeExport/*')

global class ESSMSS_REST_EmployeeExportController 
{
    /** Response */
    global class EmployeeExportWrapper{
        /** NAME2 */
        String Address_EN_Current_House_No = null;
        String Address_EN_House_No = null; 
        String Address_TH_Current_House_No = null; 
        String Address_TH_House_No = null; 
        /** STRAS */
        String Address_EN_Current_Moo_Village_Soi_Road = null; 
        String Address_EN_Moo_Village_Soi_Road = null;
        String Address_TH_Current_Moo_Village_Soi_Road = null;
        String Address_TH_Moo_Village_Soi_Road = null;
        /** PSTLZ */
        String Address_EN_Current_Postal_Code = null;
        String Address_EN_Postal_Code = null;
        String Address_TH_Current_Postal_Code = null;
        String Address_TH_Postal_Code = null;
        /** ORT01 */
        String Address_EN_Current_Province = null;
        String Address_EN_Province = null;
        String Address_TH_Current_Province = null;
        String Address_TH_Province = null;
        /** LOCAT */
        String Address_EN_Current_SubDistrict_District = null;
        String Address_EN_SubDistrict_District = null;
        String Address_TH_Current_SubDistrict_District = null;
        String Address_TH_SubDistrict_District = null;
        /** TELNR */
        String Address_EN_Current_Telephone_No = null;
        String Address_EN_Telephone_No = null;
        String Address_TH_Current_Telephone_No = null;
        String Address_TH_Telephone_No = null;
        String Child_JSON = null;
        String Contact_Person_JSON = null;
        String Death_Child_JSON = null;
        /** FGBNA */
        String Death_Father_Doc_Issue_Date = null;
        String Death_Marriage_Doc_Issue_Date = null;
        String Death_Mother_Doc_Issue_Date = null;
        /** FAVOR */
        String Death_Father_FN = null;
        String Death_Marriage_FN = null;
        String Death_Mother_FN = null;
        String Name_Father_EN_FN = null;
        String Name_Father_TH_FN = null;
        String Name_Marriage_EN_FN = null;
        String Name_Marriage_TH_FN = null;
        String Name_Mother_EN_FN = null;
        String Name_Mother_TH_FN = null;
        /** FANAM */
        String Death_Father_LN = null;
        String Death_Marriage_LN = null;
        String Death_Mother_LN = null;
        String Name_Father_EN_LN = null;
        String Name_Father_TH_LN = null;
        String Name_Marriage_EN_LN = null;
        String Name_Marriage_TH_LN = null;
        String Name_Mother_EN_LN = null;
        String Name_Mother_TH_LN = null;
        String Education_JSON = null;
        String Employee_ID = null;
        /** EXPID */
        String License_Citizen_Expire_Date = null;
        String License_Professional_Doc_Expire_Date = null;
        /** FPDAT */
        String License_Citizen_Issue_Date = null;
        String License_Professional_Doc_Issue_Date = null;
        /** ISSPL */
        String License_Citizen_Issue_Province = null;
        String License_Professional_Engineer = null;
        /** ICNUM */
        String License_Professional_Doc_Level = null;
        String License_Professional_Doc_No = null;
        String Name_Child_JSON = null;
        /** BEGDA */
        String Name_Emp_Change_Doc_Issue_Date = null ;
        String Name_Father_Change_Doc_Issue_Date = null;
        String Name_Marriage_Change_Doc_Issue_Date = null;
        String Name_Mother_Change_Doc_Issue_Date = null;
        String Status_Marriage_Doc_Issue_Date = null;
        /** VORNA */
        String Name_Emp_EN_FN = null;
        String Status_Marriage_EN_FN = null;
        /** NACHN */
        String Name_Emp_EN_LN = null;
        String Status_Marriage_EN_LN = null;
        /** ANRED */
        String Name_Emp_EN_Title = null;
        /** ALNAM */
        String Name_Emp_TH_Title_FN_LN = null;
        /** FAMST */
        String Status_Marriage_Status = null;
        String Tax_Marriage_Status = null;
        String Tax_Annuity_Interest_Amount = null;
        String Tax_Child_Count = null;
        String Tax_Donation_For_Charity_Amount = null;
        String Tax_Donation_For_Education_Amount = null;
        String Tax_First_House_Exclude_Tax_Amount = null;
        String Tax_Income_From_RMF_Amount = null;
        String Tax_Income_From_SSF_Amount = null;
        String Tax_Interest_On_Loan_For_House_Amount = null;
        String Tax_Marriage_Person_Earn_Income = null;
        String Tax_Married_Deduction_Father_Amount = null;
        String Tax_Married_Deduction_Mother_Amount = null;
        String Tax_Married_Father_Insurance_Paid_Amount = null;
        String Tax_Married_Life_Insurance_Paid_Amount = null;
        String Tax_Married_Mother_Insurance_Paid_Amount = null;
        String Tax_Pregnancy_Care_Amount = null;
        String Tax_Self_Deduction_Father_Amount = null;
        String Tax_Self_Deduction_Mother_Amount = null;
        String Tax_Self_Father_Insurance_Paid_Amount = null;
        String Tax_Self_Life_Insurance_Paid_Amount = null;
        String Tax_Self_Mother_Insurance_Paid_Amount = null;
        String Tax_Sponsor_Amount = null;
        String Tax_Total_Child_Count = null;
        String Employee_Retirement_Date = null;
        Boolean Is_Update_Address;
        Boolean Is_Update_Child;
        Boolean Is_Update_ContactPerson;
        Boolean Is_Update_Death;
        Boolean Is_Update_Education;
        Boolean Is_Update_License;
        Boolean Is_Update_Name;
        Boolean Is_Update_Status;
        Boolean Is_Update_Tax;
        String ESS_Application = null; //id ของ ESS_Application__c
        String Name_Child_Count = null;
        Boolean Is_Marriage_As_Employee;
        String Status = null;
        String Status_Divorce_Doc_Issue_Date = null;
        String Status_Divorce_EN_FN = null;
        String Status_Divorce_EN_LN = null;
        String Status_Divorce_EN_New_LN = null;
        String Status_Divorce_EN_New_Title = null;
        String Status_Divorce_TH_FN = null;
        String Status_Divorce_TH_LN = null;
        String Status_Divorce_TH_New_LN = null;
        String Status_Divorce_TH_New_Title = null;
        String Status_Marriage_EN_New_LN = null;
        String Status_Marriage_EN_New_Title = null;
        String Status_Marriage_TH_FN = null;
        String Status_Marriage_TH_LN = null;
        String Status_Marriage_TH_New_LN = null;
        String Status_Marriage_TH_New_Title = null;
        String Status_Widow_EN_FN = null;
        String Status_Widow_EN_LN = null;
        String Status_Widow_EN_New_LN = null;
        String Status_Widow_EN_New_Title = null;
        String Status_Widow_TH_FN = null;
        String Status_Widow_TH_LN = null;
        String Status_Widow_TH_New_LN = null;
        String Status_Widow_TH_New_Title = null;
        String Submitted_Date = null;
        String License_Citizen_Id = null;
        String Status_Widow_Doc_Issue_Date = null;
        String CEP = null;
        String Sending_To_SAP_Date = null;
        String Status_Marriage_DOB = null;
        String Status_Marriage_Gender = null;
        String Name_Emp_Status_EN_Title = null;
        String Name_Emp_Status_EN_FN = null;
        String Name_Emp_Status_EN_LN = null;
        String Name_Emp_Status_TH_Title_FN_LN = null;
        String Effective_Date = null;
    }
    /** Return Response */
    global class ResponseWrapper{
        List<EmployeeExportWrapper> responseEmployeeExportWrapperList;
        String messagetype = '';
        String messagetext = '';
    }

    @HttpPost
    // global static ResponseWrapper EmployeeExportPost(EmployeeRequestWrapper SAPEmployee){
    global static ResponseWrapper EmployeeExportPost()
    {
        try {
            List<String> wherefield = new List<String>();
            /** query and conditiion >> ESS_Master_Employee__c*/
            String selectionMasterEmp = 'SELECT id,Effective_Date__c,ESS_Application__c, Address_EN_Current_House_No__c, Address_EN_Current_Moo_Village_Soi_Road__c, Address_EN_Current_Postal_Code__c, Address_EN_Current_Province__c, Address_EN_Current_SubDistrict_District__c, Address_EN_Current_Telephone_No__c, Address_EN_House_No__c, Address_EN_Moo_Village_Soi_Road__c, Address_EN_Postal_Code__c, Address_EN_Province__c, Address_EN_SubDistrict_District__c, Address_EN_Telephone_No__c, Address_TH_Current_House_No__c, Address_TH_Current_Moo_Village_Soi_Road__c, Address_TH_Current_Postal_Code__c, Address_TH_Current_Province__c, Address_TH_Current_SubDistrict_District__c, Address_TH_Current_Telephone_No__c, Address_TH_House_No__c, Address_TH_Moo_Village_Soi_Road__c, Address_TH_Postal_Code__c, Address_TH_Province__c, Address_TH_SubDistrict_District__c, Address_TH_Telephone_No__c, Child_JSON__c, Contact_Person_JSON__c, Death_Child_JSON__c, Death_Father_Doc_Issue_Date__c, Death_Father_FN__c, Death_Father_LN__c, Death_Marriage_Doc_Issue_Date__c, Death_Marriage_FN__c, Death_Marriage_LN__c, Death_Mother_Doc_Issue_Date__c, Death_Mother_FN__c, Death_Mother_LN__c, Education_JSON__c, Employee_ID__c, Employee_Name__c, License_Citizen_Expire_Date__c, License_Citizen_Issue_Date__c, License_Citizen_Issue_Province__c, License_Professional_Doc_Expire_Date__c, License_Professional_Doc_Issue_Date__c, License_Professional_Doc_Level__c, License_Professional_Doc_No__c, License_Professional_Engineer__c, Name_Child_JSON__c, Name_Emp_Change_Doc_Issue_Date__c, Name_Emp_EN_FN__c, Name_Emp_EN_LN__c, Name_Emp_EN_Title__c, Name_Emp_TH_Title_FN_LN__c, Name_Father_Change_Doc_Issue_Date__c, Name_Father_EN_FN__c, Name_Father_EN_LN__c, Name_Father_EN_Title__c, Name_Father_TH_FN__c, Name_Father_TH_LN__c, Name_Marriage_Change_Doc_Issue_Date__c, Name_Marriage_EN_FN__c, Name_Marriage_EN_LN__c, Name_Marriage_TH_FN__c, Name_Marriage_TH_LN__c, Name_Marriage_TH_Title__c, Name_Mother_Change_Doc_Issue_Date__c, Name_Mother_EN_FN__c, Name_Mother_EN_LN__c, Name_Mother_TH_FN__c, Name_Mother_TH_LN__c, Name_Mother_TH_Title__c, Status_Marriage_Status__c, Status_Marriage_Doc_Issue_Date__c, Status_Marriage_EN_FN__c, Status_Marriage_EN_LN__c, Status_Marriage_EN_Title__c, Tax_Annuity_Interest_Amount__c, Tax_Child_Count__c, Tax_Donation_For_Charity_Amount__c, Tax_Donation_For_Education_Amount__c, Tax_First_House_Exclude_Tax_Amount__c, Tax_Income_From_RMF_Amount__c, Tax_Income_From_SSF_Amount__c, Tax_Interest_On_Loan_For_House_Amount__c, Tax_Marriage_Person_Earn_Income__c, Tax_Marriage_Status__c, Tax_Married_Deduction_Father_Amount__c, Tax_Married_Deduction_Mother_Amount__c, Tax_Married_Father_Insurance_Paid_Amount__c, Tax_Married_Life_Insurance_Paid_Amount__c, Tax_Married_Mother_Insurance_Paid_Amount__c, Tax_Pregnancy_Care_Amount__c, Tax_Self_Deduction_Father_Amount__c, Tax_Self_Deduction_Mother_Amount__c, Tax_Self_Father_Insurance_Paid_Amount__c, Tax_Self_Life_Insurance_Paid_Amount__c, Tax_Self_Mother_Insurance_Paid_Amount__c, Tax_Sponsor_Amount__c, Tax_Total_Child_Count__c,Employee_Retirement_Date__c ,Is_Update_Address__c, Is_Update_Child__c, Is_Update_ContactPerson__c, Is_Update_Death__c,Is_Update_Education__c, Is_Update_License__c, Is_Update_Name__c, Is_Update_Status__c, Is_Update_Tax__c ,Name_Child_Count__c,Employee_DOB__c, Employee_Date_Joined__c ,Is_Marriage_As_Employee__c ,Status__c ,Status_Divorce_Doc_Issue_Date__c ,Status_Divorce_EN_FN__c ,Status_Divorce_EN_LN__c ,Status_Divorce_EN_New_LN__c ,Status_Divorce_EN_New_Title__c ,Status_Divorce_TH_FN__c ,Status_Divorce_TH_LN__c ,Status_Divorce_TH_New_LN__c ,Status_Divorce_TH_New_Title__c ,Status_Marriage_EN_New_LN__c ,Status_Marriage_EN_New_Title__c ,Status_Marriage_TH_FN__c ,Status_Marriage_TH_LN__c ,Status_Marriage_TH_New_LN__c ,Status_Marriage_TH_New_Title__c ,Status_Widow_EN_FN__c ,Status_Widow_EN_LN__c ,Status_Widow_EN_New_LN__c ,Status_Widow_EN_New_Title__c ,Status_Widow_TH_FN__c ,Status_Widow_TH_LN__c ,Status_Widow_TH_New_LN__c ,Status_Widow_TH_New_Title__c ,Submitted_Date__c, License_Citizen_Id__c, Status_Widow_Doc_Issue_Date__c, ESS_Application__r.Status__c,CEP__c,Status_Marriage_DOB__c,Status_Marriage_Gender__c, Name_Emp_Status_EN_Title__c, Name_Emp_Status_EN_FN__c, Name_Emp_Status_EN_LN__c, Name_Emp_Status_TH_Title_FN_LN__c   FROM ESS_Master_Employee__c WHERE ( Is_Update_Address__c = TRUE OR Is_Update_Child__c = TRUE OR Is_Update_ContactPerson__c = TRUE OR Is_Update_Death__c = TRUE OR Is_Update_Education__c = TRUE OR Is_Update_License__c = TRUE OR Is_Update_Name__c = TRUE OR Is_Update_Status__c = TRUE OR Is_Update_Tax__c = TRUE ) AND Data__c = \'OUT\' AND Status__c = \'Verified\' '; /*'WHERE Name = \'ME-17396\' '*/ 
            String queryMasterEmp = selectionMasterEmp ;
            String selectionRetirement = 'SELECT Id, Employee_ID__c, Retirement_Date__c,Status__c,Submitted_Date__c,Sending_To_SAP_Date__c FROM ESS_Retirement__c WHERE Status__c = \'SendingToSAP\' ';/* 'WHERE Name = \'RET-00082\' '*/
            String queryRetirement  = selectionRetirement ;
            /**  query database */
            List<ESS_Master_Employee__c> queryEmployeeList = Database.query(queryMasterEmp);
            List<ESS_Retirement__c> queryRetirementList = Database.query(queryRetirement);
            /** condition for update fields after query from database */
            List<EmployeeExportWrapper> employeeExportWrapperList = new List<EmployeeExportWrapper>();
            for (ESS_Master_Employee__c eachEmployee : queryEmployeeList) {
                EmployeeExportWrapper empexportwrapper = new EmployeeExportWrapper();
                empexportwrapper.Address_EN_Current_House_No = (eachEmployee.Address_EN_Current_House_No__c!= null && eachEmployee.Address_EN_Current_House_No__c != '') ? eachEmployee.Address_EN_Current_House_No__c : null;
                empexportwrapper.Address_EN_Current_Moo_Village_Soi_Road = (eachEmployee.Address_EN_Current_Moo_Village_Soi_Road__c!= null && eachEmployee.Address_EN_Current_Moo_Village_Soi_Road__c != '') ? eachEmployee.Address_EN_Current_Moo_Village_Soi_Road__c : null;
                empexportwrapper.Address_EN_Current_Postal_Code = (eachEmployee.Address_EN_Current_Postal_Code__c!= null && eachEmployee.Address_EN_Current_Postal_Code__c != '') ? eachEmployee.Address_EN_Current_Postal_Code__c : null;
                empexportwrapper.Address_EN_Current_Province = (eachEmployee.Address_EN_Current_Province__c!= null && eachEmployee.Address_EN_Current_Province__c != '') ? eachEmployee.Address_EN_Current_Province__c : null;
                empexportwrapper.Address_EN_Current_SubDistrict_District = (eachEmployee.Address_EN_Current_SubDistrict_District__c!= null && eachEmployee.Address_EN_Current_SubDistrict_District__c != '') ? eachEmployee.Address_EN_Current_SubDistrict_District__c : null;
                empexportwrapper.Address_EN_Current_Telephone_No = (eachEmployee.Address_EN_Current_Telephone_No__c!= null && eachEmployee.Address_EN_Current_Telephone_No__c != '') ? eachEmployee.Address_EN_Current_Telephone_No__c : null;
                empexportwrapper.Address_EN_House_No = (eachEmployee.Address_EN_House_No__c!= null && eachEmployee.Address_EN_House_No__c != '') ? eachEmployee.Address_EN_House_No__c : null;
                empexportwrapper.Address_EN_Moo_Village_Soi_Road = (eachEmployee.Address_EN_Moo_Village_Soi_Road__c!= null && eachEmployee.Address_EN_Moo_Village_Soi_Road__c != '') ? eachEmployee.Address_EN_Moo_Village_Soi_Road__c : null;
                empexportwrapper.Address_EN_Postal_Code = (eachEmployee.Address_EN_Postal_Code__c!= null && eachEmployee.Address_EN_Postal_Code__c != '') ? eachEmployee.Address_EN_Postal_Code__c : null;
                empexportwrapper.Address_EN_Province = (eachEmployee.Address_EN_Province__c!= null && eachEmployee.Address_EN_Province__c != '') ? eachEmployee.Address_EN_Province__c : null;
                empexportwrapper.Address_EN_SubDistrict_District = (eachEmployee.Address_EN_SubDistrict_District__c!= null && eachEmployee.Address_EN_SubDistrict_District__c != '') ? eachEmployee.Address_EN_SubDistrict_District__c : null;
                empexportwrapper.Address_EN_Telephone_No = (eachEmployee.Address_EN_Telephone_No__c!= null && eachEmployee.Address_EN_Telephone_No__c != '') ? eachEmployee.Address_EN_Telephone_No__c : null;
                empexportwrapper.Address_TH_Current_House_No = (eachEmployee.Address_TH_Current_House_No__c!= null && eachEmployee.Address_TH_Current_House_No__c != '') ? eachEmployee.Address_TH_Current_House_No__c : null;
                empexportwrapper.Address_TH_Current_Moo_Village_Soi_Road = (eachEmployee.Address_TH_Current_Moo_Village_Soi_Road__c!= null && eachEmployee.Address_TH_Current_Moo_Village_Soi_Road__c != '') ? eachEmployee.Address_TH_Current_Moo_Village_Soi_Road__c : null;
                empexportwrapper.Address_TH_Current_Postal_Code = (eachEmployee.Address_TH_Current_Postal_Code__c!= null && eachEmployee.Address_TH_Current_Postal_Code__c != '') ? eachEmployee.Address_TH_Current_Postal_Code__c : null;
                empexportwrapper.Address_TH_Current_Province = (eachEmployee.Address_TH_Current_Province__c!= null && eachEmployee.Address_TH_Current_Province__c != '') ? eachEmployee.Address_TH_Current_Province__c : null;
                empexportwrapper.Address_TH_Current_SubDistrict_District = (eachEmployee.Address_TH_Current_SubDistrict_District__c!= null && eachEmployee.Address_TH_Current_SubDistrict_District__c != '') ? eachEmployee.Address_TH_Current_SubDistrict_District__c : null;
                empexportwrapper.Address_TH_Current_Telephone_No = (eachEmployee.Address_TH_Current_Telephone_No__c!= null && eachEmployee.Address_TH_Current_Telephone_No__c != '') ? eachEmployee.Address_TH_Current_Telephone_No__c : null;
                empexportwrapper.Address_TH_House_No = (eachEmployee.Address_TH_House_No__c!= null && eachEmployee.Address_TH_House_No__c != '') ? eachEmployee.Address_TH_House_No__c : null;
                empexportwrapper.Address_TH_Moo_Village_Soi_Road = (eachEmployee.Address_TH_Moo_Village_Soi_Road__c!= null && eachEmployee.Address_TH_Moo_Village_Soi_Road__c != '') ? eachEmployee.Address_TH_Moo_Village_Soi_Road__c : null;
                empexportwrapper.Address_TH_Postal_Code = (eachEmployee.Address_TH_Postal_Code__c!= null && eachEmployee.Address_TH_Postal_Code__c != '') ? eachEmployee.Address_TH_Postal_Code__c : null;
                empexportwrapper.Address_TH_Province = (eachEmployee.Address_TH_Province__c!= null && eachEmployee.Address_TH_Province__c != '') ? eachEmployee.Address_TH_Province__c : null;
                empexportwrapper.Address_TH_SubDistrict_District = (eachEmployee.Address_TH_SubDistrict_District__c!= null && eachEmployee.Address_TH_SubDistrict_District__c != '') ? eachEmployee.Address_TH_SubDistrict_District__c : null;
                empexportwrapper.Address_TH_Telephone_No = (eachEmployee.Address_TH_Telephone_No__c!= null && eachEmployee.Address_TH_Telephone_No__c != '') ? eachEmployee.Address_TH_Telephone_No__c : null;
                empexportwrapper.Child_JSON = (eachEmployee.Child_JSON__c!= null && eachEmployee.Child_JSON__c != '') ? eachEmployee.Child_JSON__c : null;
                empexportwrapper.Contact_Person_JSON = (eachEmployee.Contact_Person_JSON__c!= null && eachEmployee.Contact_Person_JSON__c != '') ? eachEmployee.Contact_Person_JSON__c : null;
                empexportwrapper.Death_Child_JSON = (eachEmployee.Death_Child_JSON__c!= null && eachEmployee.Death_Child_JSON__c != '') ? eachEmployee.Death_Child_JSON__c : null;
                empexportwrapper.Death_Father_Doc_Issue_Date = (eachEmployee.Death_Father_Doc_Issue_Date__c != null) ? String.valueof(eachEmployee.Death_Father_Doc_Issue_Date__c) : null;
                empexportwrapper.Death_Father_FN = (eachEmployee.Death_Father_FN__c!= null && eachEmployee.Death_Father_FN__c != '') ? eachEmployee.Death_Father_FN__c : null;
                empexportwrapper.Death_Father_LN = (eachEmployee.Death_Father_LN__c!= null && eachEmployee.Death_Father_LN__c != '') ? eachEmployee.Death_Father_LN__c : null;
                empexportwrapper.Death_Marriage_Doc_Issue_Date = (eachEmployee.Death_Marriage_Doc_Issue_Date__c != null) ? String.valueof(eachEmployee.Death_Marriage_Doc_Issue_Date__c) : null;
                empexportwrapper.Death_Marriage_FN = (eachEmployee.Death_Marriage_FN__c!= null && eachEmployee.Death_Marriage_FN__c != '') ? eachEmployee.Death_Marriage_FN__c : null;
                empexportwrapper.Death_Marriage_LN = (eachEmployee.Death_Marriage_LN__c!= null && eachEmployee.Death_Marriage_LN__c != '') ? eachEmployee.Death_Marriage_LN__c : null;
                empexportwrapper.Death_Mother_Doc_Issue_Date = (eachEmployee.Death_Mother_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Death_Mother_Doc_Issue_Date__c) : null;
                empexportwrapper.Death_Mother_FN = (eachEmployee.Death_Mother_FN__c!= null && eachEmployee.Death_Mother_FN__c != '') ? eachEmployee.Death_Mother_FN__c : null;
                empexportwrapper.Death_Mother_LN = (eachEmployee.Death_Mother_LN__c!= null && eachEmployee.Death_Mother_LN__c != '') ? eachEmployee.Death_Mother_LN__c : null;
                empexportwrapper.Education_JSON = (eachEmployee.Education_JSON__c!= null && eachEmployee.Education_JSON__c != '') ? eachEmployee.Education_JSON__c : null;
                empexportwrapper.Employee_ID = (eachEmployee.Employee_ID__c!= null && eachEmployee.Employee_ID__c != '') ? eachEmployee.Employee_ID__c : null;
                empexportwrapper.License_Citizen_Expire_Date =  (eachEmployee.License_Citizen_Expire_Date__c!= null) ? String.valueof(eachEmployee.License_Citizen_Expire_Date__c) : null;
                empexportwrapper.License_Citizen_Issue_Date = (eachEmployee.License_Citizen_Issue_Date__c!= null) ? String.valueof(eachEmployee.License_Citizen_Issue_Date__c) : null;
                empexportwrapper.License_Citizen_Issue_Province = (eachEmployee.License_Citizen_Issue_Province__c!= null && eachEmployee.License_Citizen_Issue_Province__c != '') ? eachEmployee.License_Citizen_Issue_Province__c : null;
                empexportwrapper.License_Professional_Doc_Expire_Date = (eachEmployee.License_Professional_Doc_Expire_Date__c!= null) ? String.valueof(eachEmployee.License_Professional_Doc_Expire_Date__c) : null;
                empexportwrapper.License_Professional_Doc_Issue_Date = (eachEmployee.License_Professional_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.License_Professional_Doc_Issue_Date__c) : null;
                empexportwrapper.License_Professional_Doc_Level = (eachEmployee.License_Professional_Doc_Level__c!= null && eachEmployee.License_Professional_Doc_Level__c != '') ? eachEmployee.License_Professional_Doc_Level__c : null;
                empexportwrapper.License_Professional_Doc_No = (eachEmployee.License_Professional_Doc_No__c!= null && eachEmployee.License_Professional_Doc_No__c != '') ? eachEmployee.License_Professional_Doc_No__c : null;
                empexportwrapper.License_Professional_Engineer = (eachEmployee.License_Professional_Engineer__c!= null && eachEmployee.License_Professional_Engineer__c != '') ? eachEmployee.License_Professional_Engineer__c : null;
                empexportwrapper.Name_Child_JSON = (eachEmployee.Name_Child_JSON__c!= null && eachEmployee.Name_Child_JSON__c != '') ? eachEmployee.Name_Child_JSON__c : null;
                empexportwrapper.Name_Emp_Change_Doc_Issue_Date = (eachEmployee.Name_Emp_Change_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Name_Emp_Change_Doc_Issue_Date__c) : null;
                empexportwrapper.Name_Emp_EN_FN = (eachEmployee.Name_Emp_EN_FN__c!= null && eachEmployee.Name_Emp_EN_FN__c != '') ? eachEmployee.Name_Emp_EN_FN__c : null;
                empexportwrapper.Name_Emp_EN_LN = (eachEmployee.Name_Emp_EN_LN__c!= null && eachEmployee.Name_Emp_EN_LN__c != '') ? eachEmployee.Name_Emp_EN_LN__c : null;
                empexportwrapper.Name_Emp_EN_Title = (eachEmployee.Name_Emp_EN_Title__c!= null && eachEmployee.Name_Emp_EN_Title__c != '') ? eachEmployee.Name_Emp_EN_Title__c : null;
                empexportwrapper.Name_Emp_TH_Title_FN_LN = (eachEmployee.Name_Emp_TH_Title_FN_LN__c!= null && eachEmployee.Name_Emp_TH_Title_FN_LN__c != '') ? eachEmployee.Name_Emp_TH_Title_FN_LN__c : null;
                empexportwrapper.Name_Father_Change_Doc_Issue_Date = (eachEmployee.Name_Father_Change_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Name_Father_Change_Doc_Issue_Date__c) : null;
                empexportwrapper.Name_Father_EN_FN = (eachEmployee.Name_Father_EN_FN__c!= null && eachEmployee.Name_Father_EN_FN__c != '') ? eachEmployee.Name_Father_EN_FN__c : null;
                empexportwrapper.Name_Father_EN_LN = (eachEmployee.Name_Father_EN_LN__c!= null && eachEmployee.Name_Father_EN_LN__c != '') ? eachEmployee.Name_Father_EN_LN__c : null;
                empexportwrapper.Name_Father_TH_FN = (eachEmployee.Name_Father_TH_FN__c!= null && eachEmployee.Name_Father_TH_FN__c != '') ? eachEmployee.Name_Father_TH_FN__c : null;
                empexportwrapper.Name_Father_TH_LN = (eachEmployee.Name_Father_TH_LN__c!= null && eachEmployee.Name_Father_TH_LN__c != '') ? eachEmployee.Name_Father_TH_LN__c : null;
                empexportwrapper.Name_Marriage_Change_Doc_Issue_Date = (eachEmployee.Name_Marriage_Change_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Name_Marriage_Change_Doc_Issue_Date__c) : null;
                empexportwrapper.Name_Marriage_EN_FN = (eachEmployee.Name_Marriage_EN_FN__c!= null && eachEmployee.Name_Marriage_EN_FN__c != '') ? eachEmployee.Name_Marriage_EN_FN__c : null;
                empexportwrapper.Name_Marriage_EN_LN = (eachEmployee.Name_Marriage_EN_LN__c!= null && eachEmployee.Name_Marriage_EN_LN__c != '') ? eachEmployee.Name_Marriage_EN_LN__c : null;
                empexportwrapper.Name_Marriage_TH_FN = (eachEmployee.Name_Marriage_TH_FN__c!= null && eachEmployee.Name_Marriage_TH_FN__c != '') ? eachEmployee.Name_Marriage_TH_FN__c : null;
                empexportwrapper.Name_Marriage_TH_LN = (eachEmployee.Name_Marriage_TH_LN__c!= null && eachEmployee.Name_Marriage_TH_LN__c != '') ? eachEmployee.Name_Marriage_TH_LN__c : null;
                empexportwrapper.Name_Mother_Change_Doc_Issue_Date = (eachEmployee.Name_Mother_Change_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Name_Mother_Change_Doc_Issue_Date__c) : null;
                empexportwrapper.Name_Mother_EN_FN = (eachEmployee.Name_Mother_EN_FN__c!= null && eachEmployee.Name_Mother_EN_FN__c != '') ? eachEmployee.Name_Mother_EN_FN__c : null;
                empexportwrapper.Name_Mother_EN_LN = (eachEmployee.Name_Mother_EN_LN__c!= null && eachEmployee.Name_Mother_EN_LN__c != '') ? eachEmployee.Name_Mother_EN_LN__c : null;
                empexportwrapper.Name_Mother_TH_FN = (eachEmployee.Name_Mother_TH_FN__c!= null && eachEmployee.Name_Mother_TH_FN__c != '') ? eachEmployee.Name_Mother_TH_FN__c : null;
                empexportwrapper.Name_Mother_TH_LN = (eachEmployee.Name_Mother_TH_LN__c!= null && eachEmployee.Name_Mother_TH_LN__c != '') ? eachEmployee.Name_Mother_TH_LN__c : null;
                empexportwrapper.Status_Marriage_Status = (eachEmployee.Status_Marriage_Status__c!= null && eachEmployee.Status_Marriage_Status__c != '') ? eachEmployee.Status_Marriage_Status__c : null;
                empexportwrapper.Status_Marriage_Doc_Issue_Date = (eachEmployee.Status_Marriage_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Status_Marriage_Doc_Issue_Date__c) : null;
                empexportwrapper.Status_Marriage_EN_FN = (eachEmployee.Status_Marriage_EN_FN__c!= null && eachEmployee.Status_Marriage_EN_FN__c != '') ? eachEmployee.Status_Marriage_EN_FN__c : null;
                empexportwrapper.Status_Marriage_EN_LN = (eachEmployee.Status_Marriage_EN_LN__c!= null && eachEmployee.Status_Marriage_EN_LN__c != '') ? eachEmployee.Status_Marriage_EN_LN__c : null;
                empexportwrapper.Tax_Annuity_Interest_Amount = (eachEmployee.Tax_Annuity_Interest_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Annuity_Interest_Amount__c) : null;
                empexportwrapper.Tax_Child_Count = (eachEmployee.Tax_Child_Count__c!= null ) ? String.valueof(eachEmployee.Tax_Child_Count__c) : null;
                empexportwrapper.Tax_Donation_For_Charity_Amount = (eachEmployee.Tax_Donation_For_Charity_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Donation_For_Charity_Amount__c) : null;
                empexportwrapper.Tax_Donation_For_Education_Amount = (eachEmployee.Tax_Donation_For_Education_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Donation_For_Education_Amount__c) : null;
                empexportwrapper.Tax_First_House_Exclude_Tax_Amount = (eachEmployee.Tax_First_House_Exclude_Tax_Amount__c!= null) ? String.valueof(eachEmployee.Tax_First_House_Exclude_Tax_Amount__c) : null;
                empexportwrapper.Tax_Income_From_RMF_Amount = (eachEmployee.Tax_Income_From_RMF_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Income_From_RMF_Amount__c) : null;
                empexportwrapper.Tax_Income_From_SSF_Amount = (eachEmployee.Tax_Income_From_SSF_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Income_From_SSF_Amount__c) : null;
                empexportwrapper.Tax_Interest_On_Loan_For_House_Amount = (eachEmployee.Tax_Interest_On_Loan_For_House_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Interest_On_Loan_For_House_Amount__c) : null;
                empexportwrapper.Tax_Marriage_Person_Earn_Income = (eachEmployee.Tax_Marriage_Person_Earn_Income__c!= null ) ? String.valueof(eachEmployee.Tax_Marriage_Person_Earn_Income__c) : null;
                empexportwrapper.Tax_Marriage_Status = (eachEmployee.Tax_Marriage_Status__c!= null && eachEmployee.Tax_Marriage_Status__c != '') ? eachEmployee.Tax_Marriage_Status__c : null;
                empexportwrapper.Tax_Married_Deduction_Father_Amount = (eachEmployee.Tax_Married_Deduction_Father_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Married_Deduction_Father_Amount__c) : null;
                empexportwrapper.Tax_Married_Deduction_Mother_Amount = (eachEmployee.Tax_Married_Deduction_Mother_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Married_Deduction_Mother_Amount__c) : null;
                empexportwrapper.Tax_Married_Father_Insurance_Paid_Amount = (eachEmployee.Tax_Married_Father_Insurance_Paid_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Married_Father_Insurance_Paid_Amount__c) : null;
                empexportwrapper.Tax_Married_Life_Insurance_Paid_Amount = (eachEmployee.Tax_Married_Life_Insurance_Paid_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Married_Life_Insurance_Paid_Amount__c) : null;
                empexportwrapper.Tax_Married_Mother_Insurance_Paid_Amount = (eachEmployee.Tax_Married_Mother_Insurance_Paid_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Married_Mother_Insurance_Paid_Amount__c) : null;
                empexportwrapper.Tax_Pregnancy_Care_Amount = (eachEmployee.Tax_Pregnancy_Care_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Pregnancy_Care_Amount__c) : null;
                empexportwrapper.Tax_Self_Deduction_Father_Amount = (eachEmployee.Tax_Self_Deduction_Father_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Self_Deduction_Father_Amount__c) : null;
                empexportwrapper.Tax_Self_Deduction_Mother_Amount = (eachEmployee.Tax_Self_Deduction_Mother_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Self_Deduction_Mother_Amount__c) : null;
                empexportwrapper.Tax_Self_Father_Insurance_Paid_Amount = (eachEmployee.Tax_Self_Father_Insurance_Paid_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Self_Father_Insurance_Paid_Amount__c) : null;
                empexportwrapper.Tax_Self_Life_Insurance_Paid_Amount = (eachEmployee.Tax_Self_Life_Insurance_Paid_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Self_Life_Insurance_Paid_Amount__c) : null;
                empexportwrapper.Tax_Self_Mother_Insurance_Paid_Amount = (eachEmployee.Tax_Self_Mother_Insurance_Paid_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Self_Mother_Insurance_Paid_Amount__c) : null;
                empexportwrapper.Tax_Sponsor_Amount = (eachEmployee.Tax_Sponsor_Amount__c!= null ) ? String.valueof(eachEmployee.Tax_Sponsor_Amount__c) : null;
                empexportwrapper.Tax_Total_Child_Count = (eachEmployee.Tax_Total_Child_Count__c!= null ) ? String.valueof(eachEmployee.Tax_Total_Child_Count__c) : null;
                empexportwrapper.Employee_Retirement_Date = (eachEmployee.Employee_Retirement_Date__c!= null) ? String.valueof(eachEmployee.Employee_Retirement_Date__c) : null;
                empexportwrapper.Is_Update_Address = (eachEmployee.Is_Update_Address__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_Address__c) : null;
                empexportwrapper.Is_Update_Child = (eachEmployee.Is_Update_Child__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_Child__c) : null;
                empexportwrapper.Is_Update_ContactPerson = (eachEmployee.Is_Update_ContactPerson__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_ContactPerson__c) : null;
                empexportwrapper.Is_Update_Death = (eachEmployee.Is_Update_Death__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_Death__c) : null;
                empexportwrapper.Is_Update_Education = (eachEmployee.Is_Update_Education__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_Education__c) : null;
                empexportwrapper.Is_Update_License = (eachEmployee.Is_Update_License__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_License__c) : null;
                empexportwrapper.Is_Update_Name = (eachEmployee.Is_Update_Name__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_Name__c) : null;
                empexportwrapper.Is_Update_Status = (eachEmployee.Is_Update_Status__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_Status__c) : null;
                empexportwrapper.Is_Update_Tax = (eachEmployee.Is_Update_Tax__c!= null ) ? Boolean.valueof(eachEmployee.Is_Update_Tax__c) : null;
                empexportwrapper.ESS_Application = (eachEmployee.ESS_Application__c!= null ) ? String.valueof(eachEmployee.ESS_Application__c) : null;
                empexportwrapper.Name_Child_Count = (eachEmployee.Name_Child_Count__c!= null ) ? String.valueof(eachEmployee.Name_Child_Count__c) : null;
                empexportwrapper.Is_Marriage_As_Employee = (eachEmployee.Is_Marriage_As_Employee__c!= null ) ? Boolean.valueof(eachEmployee.Is_Marriage_As_Employee__c) : null;
                empexportwrapper.Status = (eachEmployee.Status__c!= null && eachEmployee.Status__c != '') ? eachEmployee.Status__c : null;
                empexportwrapper.Status_Divorce_Doc_Issue_Date = (eachEmployee.Status_Divorce_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Status_Divorce_Doc_Issue_Date__c) : null;
                empexportwrapper.Status_Divorce_EN_FN = (eachEmployee.Status_Divorce_EN_FN__c!= null && eachEmployee.Status_Divorce_EN_FN__c != '') ? eachEmployee.Status_Divorce_EN_FN__c : null;
                empexportwrapper.Status_Divorce_EN_LN = (eachEmployee.Status_Divorce_EN_LN__c!= null && eachEmployee.Status_Divorce_EN_LN__c != '') ? eachEmployee.Status_Divorce_EN_LN__c : null;
                empexportwrapper.Status_Divorce_EN_New_LN = (eachEmployee.Status_Divorce_EN_New_LN__c!= null && eachEmployee.Status_Divorce_EN_New_LN__c != '') ? eachEmployee.Status_Divorce_EN_New_LN__c : null;
                empexportwrapper.Status_Divorce_EN_New_Title = (eachEmployee.Status_Divorce_EN_New_Title__c!= null && eachEmployee.Status_Divorce_EN_New_Title__c != '') ? eachEmployee.Status_Divorce_EN_New_Title__c : null;
                empexportwrapper.Status_Divorce_TH_FN = (eachEmployee.Status_Divorce_TH_FN__c!= null && eachEmployee.Status_Divorce_TH_FN__c != '') ? eachEmployee.Status_Divorce_TH_FN__c : null;
                empexportwrapper.Status_Divorce_TH_LN = (eachEmployee.Status_Divorce_TH_LN__c!= null && eachEmployee.Status_Divorce_TH_LN__c != '') ? eachEmployee.Status_Divorce_TH_LN__c : null;
                empexportwrapper.Status_Divorce_TH_New_LN = (eachEmployee.Status_Divorce_TH_New_LN__c!= null && eachEmployee.Status_Divorce_TH_New_LN__c != '') ? eachEmployee.Status_Divorce_TH_New_LN__c : null;
                empexportwrapper.Status_Divorce_TH_New_Title = (eachEmployee.Status_Divorce_TH_New_Title__c!= null && eachEmployee.Status_Divorce_TH_New_Title__c != '') ? eachEmployee.Status_Divorce_TH_New_Title__c : null;
                empexportwrapper.Status_Marriage_EN_New_LN = (eachEmployee.Status_Marriage_EN_New_LN__c!= null && eachEmployee.Status_Marriage_EN_New_LN__c != '') ? eachEmployee.Status_Marriage_EN_New_LN__c : null;
                empexportwrapper.Status_Marriage_EN_New_Title = (eachEmployee.Status_Marriage_EN_New_Title__c!= null && eachEmployee.Status_Marriage_EN_New_Title__c != '') ? eachEmployee.Status_Marriage_EN_New_Title__c : null;
                empexportwrapper.Status_Marriage_TH_FN = (eachEmployee.Status_Marriage_TH_FN__c!= null && eachEmployee.Status_Marriage_TH_FN__c != '') ? eachEmployee.Status_Marriage_TH_FN__c : null;
                empexportwrapper.Status_Marriage_TH_LN = (eachEmployee.Status_Marriage_TH_LN__c!= null && eachEmployee.Status_Marriage_TH_LN__c != '') ? eachEmployee.Status_Marriage_TH_LN__c : null;
                empexportwrapper.Status_Marriage_TH_New_LN = (eachEmployee.Status_Marriage_TH_New_LN__c!= null && eachEmployee.Status_Marriage_TH_New_LN__c != '') ? eachEmployee.Status_Marriage_TH_New_LN__c : null;
                empexportwrapper.Status_Marriage_TH_New_Title = (eachEmployee.Status_Marriage_TH_New_Title__c!= null && eachEmployee.Status_Marriage_TH_New_Title__c != '') ? eachEmployee.Status_Marriage_TH_New_Title__c : null;
                empexportwrapper.Status_Widow_EN_FN = (eachEmployee.Status_Widow_EN_FN__c!= null && eachEmployee.Status_Widow_EN_FN__c != '') ? eachEmployee.Status_Widow_EN_FN__c : null;
                empexportwrapper.Status_Widow_EN_LN = (eachEmployee.Status_Widow_EN_LN__c!= null && eachEmployee.Status_Widow_EN_LN__c != '') ? eachEmployee.Status_Widow_EN_LN__c : null;
                empexportwrapper.Status_Widow_EN_New_LN = (eachEmployee.Status_Widow_EN_New_LN__c!= null && eachEmployee.Status_Widow_EN_New_LN__c != '') ? eachEmployee.Status_Widow_EN_New_LN__c : null;
                empexportwrapper.Status_Widow_EN_New_Title = (eachEmployee.Status_Widow_EN_New_Title__c!= null && eachEmployee.Status_Widow_EN_New_Title__c != '') ? eachEmployee.Status_Widow_EN_New_Title__c : null;
                empexportwrapper.Status_Widow_TH_FN = (eachEmployee.Status_Widow_TH_FN__c!= null && eachEmployee.Status_Widow_TH_FN__c != '') ? eachEmployee.Status_Widow_TH_FN__c : null;
                empexportwrapper.Status_Widow_TH_LN = (eachEmployee.Status_Widow_TH_LN__c!= null && eachEmployee.Status_Widow_TH_LN__c != '') ? eachEmployee.Status_Widow_TH_LN__c : null;
                empexportwrapper.Status_Widow_TH_New_LN = (eachEmployee.Status_Widow_TH_New_LN__c!= null && eachEmployee.Status_Widow_TH_New_LN__c != '') ? eachEmployee.Status_Widow_TH_New_LN__c : null;
                empexportwrapper.Status_Widow_TH_New_Title = (eachEmployee.Status_Widow_TH_New_Title__c!= null && eachEmployee.Status_Widow_TH_New_Title__c != '') ? eachEmployee.Status_Widow_TH_New_Title__c : null;
                empexportwrapper.Submitted_Date = (eachEmployee.Submitted_Date__c!= null) ? String.valueof(eachEmployee.Submitted_Date__c) : null;
                empexportwrapper.License_Citizen_Id = (eachEmployee.License_Citizen_Id__c!= null && eachEmployee.License_Citizen_Id__c != '') ? eachEmployee.License_Citizen_Id__c : null;
                empexportwrapper.Status_Widow_Doc_Issue_Date = (eachEmployee.Status_Widow_Doc_Issue_Date__c!= null) ? String.valueof(eachEmployee.Status_Widow_Doc_Issue_Date__c) : null;
                empexportwrapper.CEP = (eachEmployee.CEP__c!= null && eachEmployee.CEP__c != '') ? eachEmployee.CEP__c : null;
                empexportwrapper.Status_Marriage_DOB = (eachEmployee.Status_Marriage_DOB__c!= null ) ? String.valueof(eachEmployee.Status_Marriage_DOB__c) : null;
                empexportwrapper.Status_Marriage_Gender = (eachEmployee.Status_Marriage_Gender__c != null ) ? String.valueof(eachEmployee.Status_Marriage_Gender__c) : null;
                empexportwrapper.Name_Emp_Status_EN_Title = (eachEmployee.Name_Emp_Status_EN_Title__c!= null && eachEmployee.Name_Emp_Status_EN_Title__c != '') ? eachEmployee.Name_Emp_Status_EN_Title__c : null;
                empexportwrapper.Name_Emp_Status_EN_FN = (eachEmployee.Name_Emp_Status_EN_FN__c!= null && eachEmployee.Name_Emp_Status_EN_FN__c != '') ? eachEmployee.Name_Emp_Status_EN_FN__c : null;
                empexportwrapper.Name_Emp_Status_EN_LN = (eachEmployee.Name_Emp_Status_EN_LN__c!= null && eachEmployee.Name_Emp_Status_EN_LN__c != '') ? eachEmployee.Name_Emp_Status_EN_LN__c : null;
                empexportwrapper.Name_Emp_Status_TH_Title_FN_LN = (eachEmployee.Name_Emp_Status_TH_Title_FN_LN__c!= null && eachEmployee.Name_Emp_Status_TH_Title_FN_LN__c != '') ? eachEmployee.Name_Emp_Status_TH_Title_FN_LN__c : null;
                empexportwrapper.Effective_Date = (eachEmployee.Effective_Date__c != null) ? String.valueof(eachEmployee.Effective_Date__c) : null;
                
                employeeExportWrapperList.add(empexportwrapper);
            }
            for (ESS_Retirement__c eachRetirement : queryRetirementList) {
                EmployeeExportWrapper empexportwrapper = new EmployeeExportWrapper();
                //Emp id เดิม + rtm เดิม
                empexportwrapper.Employee_ID = (eachRetirement.Employee_ID__c!= null && eachRetirement.Employee_ID__c != '') ? eachRetirement.Employee_ID__c : null;
                empexportwrapper.Employee_Retirement_Date = (eachRetirement.Retirement_Date__c!= null) ? String.valueof(eachRetirement.Retirement_Date__c) : null;
                empexportwrapper.Submitted_Date = (eachRetirement.Submitted_Date__c!= null) ? String.valueof(eachRetirement.Submitted_Date__c) : null;
                //empexportwrapper.Sending_To_SAP_Date = (eachRetirement.Sending_To_SAP_Date__c!= null) ? String.valueof(eachRetirement.Sending_To_SAP_Date__c) : String.valueof(Date.today());

                employeeExportWrapperList.add(empexportwrapper);
            }

            ResponseWrapper success = new ResponseWrapper();
            success.responseEmployeeExportWrapperList = employeeExportWrapperList;
            success.messagetype = 'Success';
            success.messagetext = 'Success';
            
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Update';
            log.Integration_Name__c = 'ESSMSS_EmployeeExport';
            log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
            log.Message_Type__c = 'Success';
            // log.Request_Body__c =  JSON.serialize().left(131072);
            log.Response_Body__c = JSON.serialize(success).left(100000);
            log.OwnerId = UserInfo.getUserId();
            insert log;

            List<ESS_Master_Employee__c> masterEmpList = new List<ESS_Master_Employee__c>();
            List<ESS_Application__c> applicationList = new List<ESS_Application__c>();
            List<ESS_Retirement__c> retirementList = new List<ESS_Retirement__c>();
            /*ESS_Master_Employee__c & ESS_Application__c(Status__c)*/
            for(ESS_Master_Employee__c masterEmp : queryEmployeeList){
                ESS_Application__c application = new ESS_Application__c();
                masterEmp.Status__c = 'SendingToSAP';
                masterEmp.Sending_to_SAP_Date__c = Date.today();
                masterEmpList.add(masterEmp);
                if(masterEmp.ESS_Application__c != null ){
                    application.Id = masterEmp.ESS_Application__c;
                    application.Status__c = 'SendingToSAP' ;
                    application.Sending_to_SAP_Date__c = Date.today();
                    applicationList.add(application);
                }
            }
            /*ESS_Retirement__c*/
            for(ESS_Retirement__c retirement : queryRetirementList){
                retirement.Sending_To_SAP_Date__c = Date.today();
                retirementList.add(retirement);
            }

            Database.SaveResult [] masterEmp_cr = Database.update(masterEmpList, false);
            Database.SaveResult [] application_cr = Database.update(applicationList, false);
            Database.SaveResult [] retirement_cr = Database.update(retirementList, false);

            Map<Id, ESS_Master_Employee__c> masterEmpMap = new Map<Id, ESS_Master_Employee__c>(masterEmpList);
            List<String> masterEmpResultList = new List<String>();
            List<String> masterEmpResultFailList = new List<String>();  
            for(Database.SaveResult result : masterEmp_cr){
                if(result.isSuccess()){
                    masterEmpResultList.add(masterEmpMap.get(result.getId())+ ' was updated');
                } else {
                    for (Database.Error err : result.getErrors()){
                        masterEmpResultFailList.add('ERROR > '+ err.getStatusCode() + ' - ID : '+ result.getId() + ' - FIELDS :'+err.getFields() + ' - ERRMESSAGE : ' + err.getMessage() );
                    }
                }
            }
            Map<Id, ESS_Application__c> appplicationMap = new Map<Id, ESS_Application__c>(applicationList);
            List<String> applicationResultList = new List<String>();
            List<String> applicationResultFailList = new List<String>();  
            for(Database.SaveResult result : application_cr){
                if(result.isSuccess()){
                    applicationResultList.add(appplicationMap.get(result.getId())+ ' was updated');
                } else {
                    for (Database.Error err : result.getErrors()){
                        applicationResultFailList.add('ERROR > '+ err.getStatusCode() + ' - ID : '+ result.getId() + ' - FIELDS :'+err.getFields() + ' - ERRMESSAGE : ' + err.getMessage() );
                    }
                }
            }
            Map<Id, ESS_Retirement__c> retirementMap = new Map<Id, ESS_Retirement__c>(retirementList);
            List<String> rtmResultList = new List<String>();
            List<String> rtmResultFailList = new List<String>();  
            for(Database.SaveResult result : retirement_cr){
                if(result.isSuccess()){
                    rtmResultList.add(retirementMap.get(result.getId())+ ' was updated');
                } else {
                    for (Database.Error err : result.getErrors()){
                        rtmResultFailList.add('ERROR > '+ err.getStatusCode() + ' - ID : '+ result.getId() + ' - FIELDS :'+err.getFields() + ' - ERRMESSAGE : ' + err.getMessage() );
                    }
                }
            }
            return success;
        } catch (Exception e) {
            ResponseWrapper error = new ResponseWrapper();
            error.messagetype = 'ERROR';
            error.messagetext = e.getMessage() + ' line :'+e.getLineNumber();

            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Update';
            log.Integration_Name__c = 'ESSMSS_EmployeeExport';
            log.Log_Type__c = 'Inbound from SAP - Salesforce generate.';
            // log.Request_Body__c =  JSON.serialize().left(131072);
            log.Response_Body__c = JSON.serialize(error).left(100000);
            log.Message_Type__c = 'Fail';
            log.OwnerId = UserInfo.getUserId();
            insert log;
            return error;
        }
    }
}