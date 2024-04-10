@RestResource(urlMapping='/ESSMSS_ImportEmployee/*')

global class ESSMSS_REST_EmployeeImportController 
{
    global class EmployeeImportWrapper
    {
        /** NAME2 */
        String Address_EN_Current_House_No = '';
        String Address_EN_House_No = ''; 
        String Address_TH_Current_House_No = ''; 
        String Address_TH_House_No = ''; 
        /** STRAS */
        String Address_EN_Current_Moo_Village_Soi_Road = ''; 
        String Address_EN_Moo_Village_Soi_Road = '';
        String Address_TH_Current_Moo_Village_Soi_Road = '';
        String Address_TH_Moo_Village_Soi_Road = '';
        /** PSTLZ */
        String Address_EN_Current_Postal_Code = '';
        String Address_EN_Postal_Code = '';
        String Address_TH_Current_Postal_Code = '';
        String Address_TH_Postal_Code = '';
        /** ORT01 */
        String Address_EN_Current_Province = '';
        String Address_EN_Province = '';
        String Address_TH_Current_Province = '';
        String Address_TH_Province = '';
        /** LOCAT */
        String Address_EN_Current_SubDistrict_District = '';
        String Address_EN_SubDistrict_District = '';
        String Address_TH_Current_SubDistrict_District = '';
        String Address_TH_SubDistrict_District = '';
        /** TELNR */
        String Address_EN_Current_Telephone_No = '';
        String Address_EN_Telephone_No = '';
        String Address_TH_Current_Telephone_No = '';
        String Address_TH_Telephone_No = '';
        String Child_JSON = '';
        String Contact_Person_JSON = '';
        String Death_Child_JSON = '';
        /** FAVOR */
        String Death_Father_FN = '';
        String Death_Marriage_FN = '';
        String Death_Mother_FN = '';
        String Name_Father_EN_FN = '';
        String Name_Father_TH_FN = '';
        String Name_Marriage_EN_FN = '';
        String Name_Marriage_TH_FN = '';
        String Name_Mother_EN_FN = '';
        String Name_Mother_TH_FN = '';
        /** FANAM */
        String Death_Father_LN = '';
        String Death_Marriage_LN = '';
        String Death_Mother_LN = '';
        String Name_Father_EN_LN = '';
        String Name_Father_TH_LN = '';
        String Name_Marriage_EN_LN = '';
        String Name_Marriage_TH_LN = '';
        String Name_Mother_EN_LN = '';
        String Name_Mother_TH_LN = '';
        String Education_JSON = '';
        String Employee_ID = '';
        /** EXPID */
        String License_Citizen_Expire_Date = '';
        String License_Professional_Doc_Expire_Date = '';
        /** FPDAT */
        String License_Citizen_Issue_Date = '';
        String License_Professional_Doc_Issue_Date = '';
        /** ISSPL */
        String License_Citizen_Issue_Province = '';
        String License_Professional_Engineer = '';
        /** ICNUM */
        String License_Professional_Doc_Level = '';
        String License_Professional_Doc_No = '';
        String Name_Child_JSON = '';
        String License_Citizen_Id;
        /** VORNA */
        String Name_Emp_EN_FN = '';
        String Status_Marriage_EN_FN = '';
        /** NACHN */
        String Name_Emp_EN_LN = '';
        String Status_Marriage_EN_LN = '';
        /** ANRED */
        String Name_Emp_EN_Title = '';
        /** ALNAM */
        String Name_Emp_TH_Title_FN_LN = '';
        /** FAMST */
        String Status_Marriage_Status = ''; //picklish
        String Tax_Marriage_Status = '';
        String Tax_Annuity_Interest_Amount = '';
        String Tax_Child_Count = '';
        String Tax_Donation_For_Charity_Amount = '';
        String Tax_Donation_For_Education_Amount = '';
        String Tax_First_House_Exclude_Tax_Amount = '';
        String Tax_Income_From_RMF_Amount = '';
        String Tax_Income_From_SSF_Amount = '';
        String Tax_Interest_On_Loan_For_House_Amount = '';
        String Tax_Marriage_Person_Earn_Income = '';
        String Tax_Married_Deduction_Father_Amount = '';
        String Tax_Married_Deduction_Mother_Amount = '';
        String Tax_Married_Father_Insurance_Paid_Amount = '';
        String Tax_Married_Life_Insurance_Paid_Amount = '';
        String Tax_Married_Mother_Insurance_Paid_Amount = '';
        String Tax_Pregnancy_Care_Amount = '';
        String Tax_Self_Deduction_Father_Amount = '';
        String Tax_Self_Deduction_Mother_Amount = '';
        String Tax_Self_Father_Insurance_Paid_Amount = '';
        String Tax_Self_Life_Insurance_Paid_Amount = '';
        String Tax_Self_Mother_Insurance_Paid_Amount = '';
        String Tax_Sponsor_Amount = '';
        String Tax_Total_Child_Count = '';
        String Status = '';
        /** FASEX */
        String Name_Father_EN_Title = ''; 
        String Name_Marriage_TH_Title = ''; 
        String Name_Mother_TH_Title = ''; 
        String Position='';
        /** BEGDA */
        String Status_Marriage_Doc_Issue_Date = '';
        /** GBDAT */
        String Employee_DOB = '';
        String Employee_Date_Joined = '';
        /** DARDT */
        String Employee_Retirement_Date = '';
        String Retirement_Date  = '';
        String Name_Child_Count  = '';
        String Applicaion_Id = '';
        /** Datadict Rev9 */
        String Status_Divorce_EN_FN = '';
        String Status_Divorce_EN_LN = '';
        String Status_Divorce_TH_FN = '';
        String Status_Divorce_TH_LN = '';
        String Status_Marriage_TH_FN = '';
        String Status_Marriage_TH_LN = '';
        String Status_Widow_EN_FN = '';
        String Status_Widow_EN_LN = '';
        String Status_Widow_TH_FN = '';
        String Status_Widow_TH_LN = ''; 
        String Unit = '';
        String SAP_JSON = '';
        //String Data = '';
        String Death_Father_Doc_Issue_Date = '';
        String Death_Mother_Doc_Issue_Date = '';
        String Death_Father_Detail = '';
        String Death_Mother_Detail = '';
        
        String CEP = '';
    }
    global class ResponseWrapper
    {
        String messagetype = '';
        String messagetext = '';
    }
    
    @HttpPost
    global static ResponseWrapper  employeeImportPost(List<EmployeeImportWrapper> SAPEmployeeList){
        try 
        {
            List<ESS_Master_Employee__c> essEmployeeList = new List<ESS_Master_Employee__c>();
            List<Database.upsertResult> essEmp_resultList = new List<Database.upsertResult>();
            List<Application_Log__c> appLogList = new List<Application_Log__c>();
            List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
            
            ResponseWrapper success = new ResponseWrapper();
            
            /**Query Employee_ID__c จาก ESS_Employee__c  */
            List<String>  empIdList = new List<String>();
            map<String,String>emprtmMap = new map<String,String>();
            for(EmployeeImportWrapper each_SAPUpdateStatus: SAPEmployeeList){
                empIdList.add(each_SAPUpdateStatus.Employee_ID);
                if(each_SAPUpdateStatus.Employee_Retirement_Date != null && each_SAPUpdateStatus.Employee_Retirement_Date != ''){
                    emprtmMap.put(each_SAPUpdateStatus.Employee_ID,each_SAPUpdateStatus.Employee_Retirement_Date);
                }
            }
			/*comment out 16/06/2023 due to softever confirm that no need to update data from sap
            List<ESS_Retirement__c> rtmIdList = [SELECT Id, Employee_ID__c, Retirement_Date__c FROM ESS_Retirement__c WHERE Employee_ID__c IN :empIdList];            
            for(ESS_Retirement__c rtm: rtmIdList){
                if(emprtmMap.containsKey(rtm.Employee_ID__c)){
                    rtm.Retirement_Date__c = Date.valueof(emprtmMap.get(rtm.Employee_ID__c));
                }else {
                    rtm.Retirement_Date__c = null;
                }
            }*/
                       
            for(EmployeeImportWrapper SAPEMP: SAPEmployeeList)
            {
                ESS_Master_Employee__c essEmployee = new ESS_Master_Employee__c();

                if(SAPEMP.Address_EN_Current_House_No != null && SAPEMP.Address_EN_Current_House_No != ''){essEmployee.Address_EN_Current_House_No__c = SAPEMP.Address_EN_Current_House_No;}
                if(SAPEMP.Address_EN_Current_Moo_Village_Soi_Road!= null && SAPEMP.Address_EN_Current_Moo_Village_Soi_Road != ''){essEmployee.Address_EN_Current_Moo_Village_Soi_Road__c = SAPEMP.Address_EN_Current_Moo_Village_Soi_Road;}
                if(SAPEMP.Address_EN_Current_Postal_Code!= null && SAPEMP.Address_EN_Current_Postal_Code != ''){essEmployee.Address_EN_Current_Postal_Code__c = SAPEMP.Address_EN_Current_Postal_Code;}
                if(SAPEMP.Address_EN_Current_Province != null && SAPEMP.Address_EN_Current_Province != ''){essEmployee.Address_EN_Current_Province__c = SAPEMP.Address_EN_Current_Province;}
                if(SAPEMP.Address_EN_Current_SubDistrict_District!= null && SAPEMP.Address_EN_Current_SubDistrict_District != ''){essEmployee.Address_EN_Current_SubDistrict_District__c = SAPEMP.Address_EN_Current_SubDistrict_District;}
                if(SAPEMP.Address_EN_Current_Telephone_No!= null && SAPEMP.Address_EN_Current_Telephone_No != ''){essEmployee.Address_EN_Current_Telephone_No__c = SAPEMP.Address_EN_Current_Telephone_No;}
                if(SAPEMP.Address_EN_House_No != null && SAPEMP.Address_EN_House_No != '') {essEmployee.Address_EN_House_No__c = SAPEMP.Address_EN_House_No;}                
                if(SAPEMP.Address_EN_Moo_Village_Soi_Road!= null && SAPEMP.Address_EN_Moo_Village_Soi_Road != ''){essEmployee.Address_EN_Moo_Village_Soi_Road__c = SAPEMP.Address_EN_Moo_Village_Soi_Road;}  
                if(SAPEMP.Address_EN_Postal_Code!= null && SAPEMP.Address_EN_Postal_Code != ''){essEmployee.Address_EN_Postal_Code__c = SAPEMP.Address_EN_Postal_Code;} 
                if(SAPEMP.Address_EN_Province != null && SAPEMP.Address_EN_Province != ''){essEmployee.Address_EN_Province__c = SAPEMP.Address_EN_Province;}                
                if(SAPEMP.Address_EN_SubDistrict_District!= null && SAPEMP.Address_EN_SubDistrict_District != ''){essEmployee.Address_EN_SubDistrict_District__c = SAPEMP.Address_EN_SubDistrict_District;}                
                if(SAPEMP.Address_EN_Telephone_No!= null && SAPEMP.Address_EN_Telephone_No != ''){essEmployee.Address_EN_Telephone_No__c = SAPEMP.Address_EN_Telephone_No;}                
                if(SAPEMP.Address_TH_Current_House_No!= null && SAPEMP.Address_TH_Current_House_No != ''){essEmployee.Address_TH_Current_House_No__c = SAPEMP.Address_TH_Current_House_No;}                
                if(SAPEMP.Address_TH_Current_Moo_Village_Soi_Road!= null && SAPEMP.Address_TH_Current_Moo_Village_Soi_Road != ''){essEmployee.Address_TH_Current_Moo_Village_Soi_Road__c = SAPEMP.Address_TH_Current_Moo_Village_Soi_Road;}                
                if(SAPEMP.Address_TH_Current_Postal_Code!= null && SAPEMP.Address_TH_Current_Postal_Code != ''){essEmployee.Address_TH_Current_Postal_Code__c = SAPEMP.Address_TH_Current_Postal_Code;}                
                if(SAPEMP.Address_TH_Current_Province!= null && SAPEMP.Address_TH_Current_Province != ''){essEmployee.Address_TH_Current_Province__c = SAPEMP.Address_TH_Current_Province;}                
                if(SAPEMP.Address_TH_Current_SubDistrict_District!= null && SAPEMP.Address_TH_Current_SubDistrict_District != ''){essEmployee.Address_TH_Current_SubDistrict_District__c = SAPEMP.Address_TH_Current_SubDistrict_District;}                
                if(SAPEMP.Address_TH_Current_Telephone_No!= null && SAPEMP.Address_TH_Current_Telephone_No != ''){essEmployee.Address_TH_Current_Telephone_No__c = SAPEMP.Address_TH_Current_Telephone_No;}                
                if(SAPEMP.Address_TH_House_No!= null && SAPEMP.Address_TH_House_No != ''){essEmployee.Address_TH_House_No__c = SAPEMP.Address_TH_House_No;}
                if(SAPEMP.Address_TH_Moo_Village_Soi_Road!= null && SAPEMP.Address_TH_Moo_Village_Soi_Road != ''){essEmployee.Address_TH_Moo_Village_Soi_Road__c = SAPEMP.Address_TH_Moo_Village_Soi_Road;}                
                if(SAPEMP.Address_TH_Postal_Code!= null && SAPEMP.Address_TH_Postal_Code != ''){essEmployee.Address_TH_Postal_Code__c = SAPEMP.Address_TH_Postal_Code;}                
                if(SAPEMP.Address_TH_Province!= null && SAPEMP.Address_TH_Province != ''){essEmployee.Address_TH_Province__c = SAPEMP.Address_TH_Province;}                
                if(SAPEMP.Address_TH_SubDistrict_District!= null && SAPEMP.Address_TH_SubDistrict_District != ''){essEmployee.Address_TH_SubDistrict_District__c = SAPEMP.Address_TH_SubDistrict_District;}
                if(SAPEMP.Tax_First_House_Exclude_Tax_Amount!= null && SAPEMP.Tax_First_House_Exclude_Tax_Amount != ''){essEmployee.Tax_First_House_Exclude_Tax_Amount__c =  Decimal.valueof(SAPEMP.Tax_First_House_Exclude_Tax_Amount);}                
                if(SAPEMP.Name_Child_Count!= null && SAPEMP.Name_Child_Count != ''){essEmployee.Name_Child_Count__c=  Decimal.valueof(SAPEMP.Name_Child_Count);}                
                if(SAPEMP.Child_JSON!= null && SAPEMP.Child_JSON != ''){essEmployee.Child_JSON__c = SAPEMP.Child_JSON;} else{essEmployee.Child_JSON__c = '';}           
                if(SAPEMP.Contact_Person_JSON!= null && SAPEMP.Contact_Person_JSON != ''){essEmployee.Contact_Person_JSON__c = SAPEMP.Contact_Person_JSON;} else{essEmployee.Contact_Person_JSON__c = '';}  
                if(SAPEMP.Death_Child_JSON!= null && SAPEMP.Death_Child_JSON != ''){essEmployee.Death_Child_JSON__c = SAPEMP.Death_Child_JSON;}else{essEmployee.Death_Child_JSON__c = '';} 
                if(SAPEMP.Education_JSON!= null && SAPEMP.Education_JSON != ''){essEmployee.Education_JSON__c = SAPEMP.Education_JSON;}else{essEmployee.Education_JSON__c = '';}                 
                if(SAPEMP.Name_Child_JSON!= null && SAPEMP.Name_Child_JSON != ''){essEmployee.Name_Child_JSON__c = SAPEMP.Name_Child_JSON;}else{essEmployee.Name_Child_JSON__c = '';}                                  
                if(SAPEMP.Death_Father_FN!= null && SAPEMP.Death_Father_FN != ''){essEmployee.Death_Father_FN__c = SAPEMP.Death_Father_FN;}                
                if(SAPEMP.Death_Father_LN!= null && SAPEMP.Death_Father_LN != ''){essEmployee.Death_Father_LN__c = SAPEMP.Death_Father_LN;}    
                if(SAPEMP.Death_Marriage_FN!= null && SAPEMP.Death_Marriage_FN != ''){essEmployee.Death_Marriage_FN__c = SAPEMP.Death_Marriage_FN;}                
                if(SAPEMP.Death_Marriage_LN!= null && SAPEMP.Death_Marriage_LN != ''){essEmployee.Death_Marriage_LN__c = SAPEMP.Death_Marriage_LN;}                
                if(SAPEMP.Death_Mother_FN!= null && SAPEMP.Death_Mother_FN != ''){essEmployee.Death_Mother_FN__c = SAPEMP.Death_Mother_FN;}                
                if(SAPEMP.Death_Mother_LN!= null && SAPEMP.Death_Mother_LN != ''){essEmployee.Death_Mother_LN__c = SAPEMP.Death_Mother_LN;}                       
                if(SAPEMP.License_Citizen_Expire_Date!= null && SAPEMP.License_Citizen_Expire_Date != ''){essEmployee.License_Citizen_Expire_Date__c = Date.valueof(SAPEMP.License_Citizen_Expire_Date);}                
                if(SAPEMP.License_Citizen_Id!= null && SAPEMP.License_Citizen_Id != ''){essEmployee.License_Citizen_Id__c = SAPEMP.License_Citizen_Id;}                
                if(SAPEMP.License_Citizen_Issue_Date!= null && SAPEMP.License_Citizen_Issue_Date != ''){essEmployee.License_Citizen_Issue_Date__c = Date.valueof(SAPEMP.License_Citizen_Issue_Date);}                
                if(SAPEMP.License_Citizen_Issue_Province!= null && SAPEMP.License_Citizen_Issue_Province != ''){essEmployee.License_Citizen_Issue_Province__c = SAPEMP.License_Citizen_Issue_Province;}                
                if(SAPEMP.License_Professional_Doc_Expire_Date!= null && SAPEMP.License_Professional_Doc_Expire_Date != ''){essEmployee.License_Professional_Doc_Expire_Date__c = Date.valueof(SAPEMP.License_Professional_Doc_Expire_Date);}                
                if(SAPEMP.License_Professional_Doc_Issue_Date!= null && SAPEMP.License_Professional_Doc_Issue_Date != ''){essEmployee.License_Professional_Doc_Issue_Date__c = Date.valueof(SAPEMP.License_Professional_Doc_Issue_Date);}                
                if(SAPEMP.License_Professional_Doc_Level!= null && SAPEMP.License_Professional_Doc_Level != ''){essEmployee.License_Professional_Doc_Level__c = SAPEMP.License_Professional_Doc_Level;}                
                if(SAPEMP.License_Professional_Doc_No!= null && SAPEMP.License_Professional_Doc_No != ''){essEmployee.License_Professional_Doc_No__c = SAPEMP.License_Professional_Doc_No;}                
                if(SAPEMP.License_Professional_Engineer!= null && SAPEMP.License_Professional_Engineer != ''){essEmployee.License_Professional_Engineer__c = SAPEMP.License_Professional_Engineer;}                
                if(SAPEMP.Name_Emp_EN_FN!= null && SAPEMP.Name_Emp_EN_FN != ''){essEmployee.Name_Emp_EN_FN__c = SAPEMP.Name_Emp_EN_FN;}                
                if(SAPEMP.Name_Emp_EN_LN!= null && SAPEMP.Name_Emp_EN_LN != ''){essEmployee.Name_Emp_EN_LN__c = SAPEMP.Name_Emp_EN_LN;}                
                if(SAPEMP.Name_Emp_EN_Title!= null && SAPEMP.Name_Emp_EN_Title != ''){essEmployee.Name_Emp_EN_Title__c = SAPEMP.Name_Emp_EN_Title;}                
                if(SAPEMP.Status_Marriage_Status!= null && SAPEMP.Status_Marriage_Status!= ''){essEmployee.Status_Marriage_Status__c = SAPEMP.Status_Marriage_Status;}                
                if(SAPEMP.Name_Emp_TH_Title_FN_LN!= null && SAPEMP.Name_Emp_TH_Title_FN_LN != ''){essEmployee.Name_Emp_TH_Title_FN_LN__c = SAPEMP.Name_Emp_TH_Title_FN_LN;}                
                if(SAPEMP.Name_Father_EN_FN!= null && SAPEMP.Name_Father_EN_FN != ''){essEmployee.Name_Father_EN_FN__c = SAPEMP.Name_Father_EN_FN;}                
                if(SAPEMP.Name_Father_EN_LN!= null && SAPEMP.Name_Father_EN_LN != ''){essEmployee.Name_Father_EN_LN__c = SAPEMP.Name_Father_EN_LN;}                
                if(SAPEMP.Name_Father_TH_FN!= null && SAPEMP.Name_Father_TH_FN != ''){essEmployee.Name_Father_TH_FN__c = SAPEMP.Name_Father_TH_FN;}                
                if(SAPEMP.Name_Father_TH_LN!= null && SAPEMP.Name_Father_TH_LN != ''){essEmployee.Name_Father_TH_LN__c = SAPEMP.Name_Father_TH_LN;}                
                if(SAPEMP.Name_Marriage_EN_FN!= null && SAPEMP.Name_Marriage_EN_FN != ''){essEmployee.Name_Marriage_EN_FN__c = SAPEMP.Name_Marriage_EN_FN;}                
                if(SAPEMP.Name_Marriage_EN_LN!= null && SAPEMP.Name_Marriage_EN_LN != ''){essEmployee.Name_Marriage_EN_LN__c = SAPEMP.Name_Marriage_EN_LN;}                
                if(SAPEMP.Name_Marriage_TH_FN!= null && SAPEMP.Name_Marriage_TH_FN != ''){essEmployee.Name_Marriage_TH_FN__c = SAPEMP.Name_Marriage_TH_FN;}                
                if(SAPEMP.Name_Marriage_TH_LN!= null && SAPEMP.Name_Marriage_TH_LN != ''){essEmployee.Name_Marriage_TH_LN__c = SAPEMP.Name_Marriage_TH_LN;}                
                if(SAPEMP.Address_TH_Telephone_No!= null && SAPEMP.Address_TH_Telephone_No != ''){essEmployee.Address_TH_Telephone_No__c= SAPEMP.Address_TH_Telephone_No;}                
                if(SAPEMP.Name_Mother_EN_FN!= null && SAPEMP.Name_Mother_EN_FN != ''){essEmployee.Name_Mother_EN_FN__c = SAPEMP.Name_Mother_EN_FN;}                
                if(SAPEMP.Name_Mother_EN_LN!= null && SAPEMP.Name_Mother_EN_LN != ''){essEmployee.Name_Mother_EN_LN__c = SAPEMP.Name_Mother_EN_LN;}                
                if(SAPEMP.Name_Mother_TH_FN!= null && SAPEMP.Name_Mother_TH_FN != ''){essEmployee.Name_Mother_TH_FN__c = SAPEMP.Name_Mother_TH_FN;}                
                if(SAPEMP.Name_Mother_TH_LN!= null && SAPEMP.Name_Mother_TH_LN != ''){essEmployee.Name_Mother_TH_LN__c = SAPEMP.Name_Mother_TH_LN;}                
                if(SAPEMP.Name_Marriage_TH_Title!= null && SAPEMP.Name_Marriage_TH_Title != ''){essEmployee.Name_Marriage_TH_Title__c = SAPEMP.Name_Marriage_TH_Title;}                
                if(SAPEMP.Name_Mother_TH_Title!= null && SAPEMP.Name_Mother_TH_Title != ''){essEmployee.Name_Mother_TH_Title__c = SAPEMP.Name_Mother_TH_Title;}                
                if(SAPEMP.Position!= null && SAPEMP.Position != ''){essEmployee.Position__c = SAPEMP.Position;}                
                if(SAPEMP.Status_Marriage_Doc_Issue_Date!= null && SAPEMP.Status_Marriage_Doc_Issue_Date != ''){essEmployee.Status_Marriage_Doc_Issue_Date__c = Date.valueof(SAPEMP.Status_Marriage_Doc_Issue_Date);}
                if(SAPEMP.Status_Marriage_EN_FN!= null && SAPEMP.Status_Marriage_EN_FN != ''){essEmployee.Status_Marriage_EN_FN__c = SAPEMP.Status_Marriage_EN_FN;}
                if(SAPEMP.Status_Marriage_EN_LN!= null && SAPEMP.Status_Marriage_EN_LN != ''){essEmployee.Status_Marriage_EN_LN__c = SAPEMP.Status_Marriage_EN_LN;}                
                if(SAPEMP.Tax_Annuity_Interest_Amount!= null && SAPEMP.Tax_Annuity_Interest_Amount != ''){essEmployee.Tax_Annuity_Interest_Amount__c = Decimal.valueof(SAPEMP.Tax_Annuity_Interest_Amount);}
                if(SAPEMP.Tax_Child_Count!= null && SAPEMP.Tax_Child_Count != ''){essEmployee.Tax_Child_Count__c = Decimal.valueof(SAPEMP.Tax_Child_Count);}
                if(SAPEMP.Tax_Donation_For_Charity_Amount!= null && SAPEMP.Tax_Donation_For_Charity_Amount != ''){essEmployee.Tax_Donation_For_Charity_Amount__c = Decimal.valueof(SAPEMP.Tax_Donation_For_Charity_Amount);}
                if(SAPEMP.Tax_Donation_For_Education_Amount!= null && SAPEMP.Tax_Donation_For_Education_Amount != ''){essEmployee.Tax_Donation_For_Education_Amount__c = Decimal.valueof(SAPEMP.Tax_Donation_For_Education_Amount);}            
                if(SAPEMP.Tax_Income_From_RMF_Amount!= null && SAPEMP.Tax_Income_From_RMF_Amount != ''){essEmployee.Tax_Income_From_RMF_Amount__c = Decimal.valueof(SAPEMP.Tax_Income_From_RMF_Amount);}
                if(SAPEMP.Tax_Income_From_SSF_Amount!= null && SAPEMP.Tax_Income_From_SSF_Amount != ''){essEmployee.Tax_Income_From_SSF_Amount__c = Decimal.valueof(SAPEMP.Tax_Income_From_SSF_Amount);}
                if(SAPEMP.Tax_Interest_On_Loan_For_House_Amount!= null && SAPEMP.Tax_Interest_On_Loan_For_House_Amount != ''){essEmployee.Tax_Interest_On_Loan_For_House_Amount__c = Decimal.valueof(SAPEMP.Tax_Interest_On_Loan_For_House_Amount);}
                if(SAPEMP.Tax_Marriage_Person_Earn_Income!= null && SAPEMP.Tax_Marriage_Person_Earn_Income != ''){essEmployee.Tax_Marriage_Person_Earn_Income__c = SAPEMP.Tax_Marriage_Person_Earn_Income;}
                if(SAPEMP.Tax_Marriage_Status!= null && SAPEMP.Tax_Marriage_Status != ''){essEmployee.Tax_Marriage_Status__c = SAPEMP.Tax_Marriage_Status;}                
                if(SAPEMP.Tax_Married_Deduction_Father_Amount!= null && SAPEMP.Tax_Married_Deduction_Father_Amount != ''){essEmployee.Tax_Married_Deduction_Father_Amount__c = Decimal.valueof(SAPEMP.Tax_Married_Deduction_Father_Amount);}
                if(SAPEMP.Tax_Married_Deduction_Mother_Amount!= null && SAPEMP.Tax_Married_Deduction_Mother_Amount != ''){essEmployee.Tax_Married_Deduction_Mother_Amount__c = Decimal.valueof(SAPEMP.Tax_Married_Deduction_Mother_Amount);}
                if(SAPEMP.Tax_Married_Father_Insurance_Paid_Amount!= null && SAPEMP.Tax_Married_Father_Insurance_Paid_Amount != ''){essEmployee.Tax_Married_Father_Insurance_Paid_Amount__c = Decimal.valueof(SAPEMP.Tax_Married_Father_Insurance_Paid_Amount);}
                if(SAPEMP.Tax_Married_Life_Insurance_Paid_Amount!= null && SAPEMP.Tax_Married_Life_Insurance_Paid_Amount != ''){essEmployee.Tax_Married_Life_Insurance_Paid_Amount__c = Decimal.valueof(SAPEMP.Tax_Married_Life_Insurance_Paid_Amount);}
                if(SAPEMP.Tax_Married_Mother_Insurance_Paid_Amount!= null && SAPEMP.Tax_Married_Mother_Insurance_Paid_Amount != ''){essEmployee.Tax_Married_Mother_Insurance_Paid_Amount__c = Decimal.valueof(SAPEMP.Tax_Married_Mother_Insurance_Paid_Amount);}
                if(SAPEMP.Tax_Pregnancy_Care_Amount!= null && SAPEMP.Tax_Pregnancy_Care_Amount != ''){essEmployee.Tax_Pregnancy_Care_Amount__c = Decimal.valueof(SAPEMP.Tax_Pregnancy_Care_Amount);}
                if(SAPEMP.Tax_Self_Deduction_Father_Amount!= null && SAPEMP.Tax_Self_Deduction_Father_Amount != ''){essEmployee.Tax_Self_Deduction_Father_Amount__c =Decimal.valueof(SAPEMP.Tax_Self_Deduction_Father_Amount);}
                if(SAPEMP.Tax_Self_Deduction_Mother_Amount!= null && SAPEMP.Tax_Self_Deduction_Mother_Amount != ''){essEmployee.Tax_Self_Deduction_Mother_Amount__c = Decimal.valueof(SAPEMP.Tax_Self_Deduction_Mother_Amount);}
                if(SAPEMP.Tax_Self_Father_Insurance_Paid_Amount!= null && SAPEMP.Tax_Self_Father_Insurance_Paid_Amount != ''){essEmployee.Tax_Self_Father_Insurance_Paid_Amount__c = Decimal.valueof(SAPEMP.Tax_Self_Father_Insurance_Paid_Amount);}
                if(SAPEMP.Tax_Self_Life_Insurance_Paid_Amount!= null && SAPEMP.Tax_Self_Life_Insurance_Paid_Amount != ''){essEmployee.Tax_Self_Life_Insurance_Paid_Amount__c = Decimal.valueof(SAPEMP.Tax_Self_Life_Insurance_Paid_Amount);}
                if(SAPEMP.Tax_Self_Mother_Insurance_Paid_Amount!= null && SAPEMP.Tax_Self_Mother_Insurance_Paid_Amount != ''){essEmployee.Tax_Self_Mother_Insurance_Paid_Amount__c = Decimal.valueof(SAPEMP.Tax_Self_Mother_Insurance_Paid_Amount);}
                if(SAPEMP.Tax_Sponsor_Amount!= null && SAPEMP.Tax_Sponsor_Amount != ''){essEmployee.Tax_Sponsor_Amount__c = Decimal.valueof(SAPEMP.Tax_Sponsor_Amount);}                
                if(SAPEMP.Tax_Total_Child_Count!= null && SAPEMP.Tax_Total_Child_Count != ''){essEmployee.Tax_Total_Child_Count__c = Decimal.valueof(SAPEMP.Tax_Total_Child_Count);}                
                if(SAPEMP.Status!= null && SAPEMP.Status != ''){essEmployee.Status__c = SAPEMP.Status;}                
                if(SAPEMP.Employee_DOB!= null && SAPEMP.Employee_DOB != ''){essEmployee.Employee_DOB__c = Date.valueof(SAPEMP.Employee_DOB);}                
                if(SAPEMP.Employee_Date_Joined!= null && SAPEMP.Employee_Date_Joined != ''){essEmployee.Employee_Date_Joined__c = Date.valueof(SAPEMP.Employee_Date_Joined);}                
                if(SAPEMP.Employee_Retirement_Date!= null && SAPEMP.Employee_Retirement_Date != ''){essEmployee.Employee_Retirement_Date__c = Date.valueof(SAPEMP.Employee_Retirement_Date);}
                if(SAPEMP.Status_Divorce_EN_FN != null && SAPEMP.Status_Divorce_EN_FN != ''){essEmployee.Status_Divorce_EN_FN__c = SAPEMP.Status_Divorce_EN_FN;}
                if(SAPEMP.Status_Divorce_EN_LN != null && SAPEMP.Status_Divorce_EN_LN != ''){essEmployee.Status_Divorce_EN_LN__c = SAPEMP.Status_Divorce_EN_LN;}
                if(SAPEMP.Status_Divorce_TH_FN != null && SAPEMP.Status_Divorce_TH_FN != ''){essEmployee.Status_Divorce_TH_FN__c = SAPEMP.Status_Divorce_TH_FN;}
                if(SAPEMP.Status_Divorce_TH_LN != null && SAPEMP.Status_Divorce_TH_LN != ''){essEmployee.Status_Divorce_TH_LN__c = SAPEMP.Status_Divorce_TH_LN;}
                if(SAPEMP.Status_Marriage_TH_FN != null && SAPEMP.Status_Marriage_TH_FN != ''){essEmployee.Status_Marriage_TH_FN__c = SAPEMP.Status_Marriage_TH_FN;}
                if(SAPEMP.Status_Marriage_TH_LN != null && SAPEMP.Status_Marriage_TH_LN != ''){essEmployee.Status_Marriage_TH_LN__c = SAPEMP.Status_Marriage_TH_LN;}
                if(SAPEMP.Status_Widow_EN_FN != null && SAPEMP.Status_Widow_EN_FN != ''){essEmployee.Status_Widow_EN_FN__c = SAPEMP.Status_Widow_EN_FN;}
                if(SAPEMP.Status_Widow_EN_LN != null && SAPEMP.Status_Widow_EN_LN != ''){essEmployee.Status_Widow_EN_LN__c = SAPEMP.Status_Widow_EN_LN;}
                if(SAPEMP.Status_Widow_TH_FN != null && SAPEMP.Status_Widow_TH_FN != ''){essEmployee.Status_Widow_TH_FN__c = SAPEMP.Status_Widow_TH_FN;}
                if(SAPEMP.Status_Widow_TH_LN != null && SAPEMP.Status_Widow_TH_LN != ''){essEmployee.Status_Widow_TH_LN__c = SAPEMP.Status_Widow_TH_LN;}
                if(SAPEMP.SAP_JSON != null && SAPEMP.SAP_JSON != ''){essEmployee.SAP_JSON__c = SAPEMP.SAP_JSON;}
                if(SAPEMP.Unit != null && SAPEMP.Unit != ''){essEmployee.Unit__c = SAPEMP.Unit;}
                if(SAPEMP.Death_Father_Doc_Issue_Date != null ){essEmployee.Death_Father_Doc_Issue_Date__c = Date.valueof(SAPEMP.Death_Father_Doc_Issue_Date);}
                if(SAPEMP.Death_Mother_Doc_Issue_Date != null ){essEmployee.Death_Mother_Doc_Issue_Date__c = Date.valueof(SAPEMP.Death_Mother_Doc_Issue_Date);}
                if(SAPEMP.Death_Father_Detail != null && SAPEMP.Death_Father_Detail != ''){essEmployee.Death_Father_Detail__c = SAPEMP.Death_Father_Detail;}
                if(SAPEMP.Death_Mother_Detail != null && SAPEMP.Death_Mother_Detail != ''){essEmployee.Death_Mother_Detail__c = SAPEMP.Death_Mother_Detail;}
                if(SAPEMP.CEP != null && SAPEMP.CEP != ''){essEmployee.CEP__c = SAPEMP.CEP;}
                /**--------------- */
                if(SAPEMP.Employee_ID!= null && SAPEMP.Employee_ID != ''){
                    essEmployee.Employee_ID__c = SAPEMP.Employee_ID.leftPad(8, '0');
                    essEmployee.ExternalId__c = SAPEMP.Employee_ID.leftPad(8, '0');
                    essEmployee.Data__c = 'IN';
                }
                essEmployeeList.add(essEmployee);
            }
            
            /** ESS_Retirement__c : Update */
            /*comment out 16/06/2023 due to softever confirm that no need to update data from sap
            Schema.SObjectField retirement_key = ESS_Retirement__c.Fields.Id;
            Database.SaveResult [] retirement_cr = Database.update(rtmIdList, false);
            Map<Id, ESS_Retirement__c> rtmMap = new Map<Id, ESS_Retirement__c>(rtmIdList);
            List<String> successResultList = new List<String>();
            List<String> failResultList = new List<String>();  
            List<String> errorMessage = new List<String>();
            //Map<String,List<Database.Error>>retireErrorMap = new Map<String,List<Database.Error>>();
            for(Database.SaveResult result : retirement_cr){
                if(result.isSuccess()){
                    successResultList.add(rtmMap.get(result.getId())+ ' was updated (Retirement)');
                } else {
                    for (Database.Error err : result.getErrors()){
                        failResultList.add('ERROR > '+ err.getStatusCode() + ' - ID : '+ result.getId() + ' - FIELDS :'+err.getFields() + ' - ERRMESSAGE : ' + err.getMessage() );
                    }
                }
            }*/
            /** ESS_Retirement__c : check result before pass to application log >> (Status__c) Restrict picklist*/
            /*comment out 16/06/2023 due to softever confirm that no need to update data from sap
            if( !successResultList.isEmpty() && failResultList.isEmpty() ){
                Application_Log__c appSuccesLog = new Application_Log__c();
                appSuccesLog.Method__c = 'Update';
                appSuccesLog.Integration_Name__c = 'ESSMSS_REST_EmployeeImport_Retirement';
                appSuccesLog.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                appSuccesLog.Message_Type__c = 'Success';
                String requestBodySubStr = JSON.serialize(SAPEmployeeList);
                appSuccesLog.Request_Body__c = (requestBodySubStr.length() > 131071) ? requestBodySubStr.substring(0, 131071) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(rtmIdList);
                appSuccesLog.Response_Body__c = (responseBodySubStr.length() > 131071) ? responseBodySubStr.substring(0, 131071) : responseBodySubStr;
                appSuccesLog.OwnerId = UserInfo.getUserId();
                appLogList.add(appSuccesLog);
                
                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'SUCCESS';
                response.messagetext = 'ESSMSS_REST_EmployeeImport_Retirement Update Success';
                
                responseWrapperList.add(response);
            }*/
            
            /*ESS Employee*/
            if(essEmployeeList.size()>0)
            {  
                Schema.SObjectField esskey = ESS_Master_Employee__c.Fields.ExternalId__c;
                essEmp_resultList = Database.upsert(essEmployeeList,esskey, false);
                if(essEmp_resultList.size() > 0){
                    List<String>essIdList_suc = new List<String>();
                    Set<String>ess_errorMsg_Set = new Set<String>();
                    for (Integer idx = 0; idx < essEmp_resultList.size(); idx++) {
                        if (essEmp_resultList[idx].isSuccess()) {
                            essIdList_suc.add(essEmp_resultList[idx].getId()); 
                        }else{
                            for(Database.Error err : essEmp_resultList[idx].getErrors()) {
                                ess_errorMsg_Set.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                        }
                    }
                    if(essIdList_suc.size()>0){
                        success.messagetype = 'SUCCESS';
                        success.messagetext =  JSON.serialize(essIdList_suc);

                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'ESSMSS_REST_EmployeeImport';
                        log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                        log.Message_Type__c = 'Success';
                        String requestBodySubStr = JSON.serialize(SAPEmployeeList);
                        log.Request_Body__c = (requestBodySubStr.length() > 131071) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                        String responseBodySubStr = JSON.serialize(success);
                        log.Response_Body__c = (responseBodySubStr.length() > 131071) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                        log.OwnerId = UserInfo.getUserId();
                        appLogList.add(log);
                    }
                    if(ess_errorMsg_Set.size() > 0){
                        List<ESS_Master_Employee__c>successar = [select id,ExternalId__c from ESS_Master_Employee__c where id in: essIdList_suc];
                        List<String>keyList = new List<String>();
                        for(ESS_Master_Employee__c essEmp : successar){
                            keyList.add(essEmp.ExternalId__c);
                        }
                        Set<String>error_essEmpList = new Set<String>();
                        
                        String error_essEmp = '';
                        for (Integer i = 0; i<SAPEmployeeList.size();i++){
                            if(SAPEmployeeList[i].Employee_ID != null && SAPEmployeeList[i].Employee_ID != '') {
                                String key = SAPEmployeeList[i].Employee_ID.leftPad(8, '0');
                                if(!keyList.contains(key)){
                                    error_essEmp = '[EmployeeId:'+SAPEmployeeList[i].Employee_ID+']';
                                    error_essEmpList.add(error_essEmp);
                                }
                            }
                        }
                        
                        List<ResponseWrapper> errorList = new List<ResponseWrapper>();
                        
                        ResponseWrapper error = new ResponseWrapper();
                        error.messagetype = 'ERROR';
                        error.messagetext = 'EmployeeId - '+error_essEmpList+' : '+ess_errorMsg_Set;
                        
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'ESSMSS_REST_EmployeeImport';
                        log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                        log.Message_Type__c = 'Fail';
                        String requestBodySubStr = JSON.serialize(SAPEmployeeList);
                        log.Request_Body__c = (requestBodySubStr.length() > 131071) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                        String responseBodySubStr = JSON.serialize(error);
                        log.Response_Body__c = (responseBodySubStr.length() > 131071) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                        log.OwnerId = UserInfo.getUserId();
                        appLogList.add(log);
                        
                        if(appLogList.size()>0){
                            insert appLogList;
                        }
                        return error;
                    }
                }
            }
            if(appLogList.size()>0){
                insert appLogList;
            }
            return success;
            // return responseWrapperList ;
        }catch (Exception e){
            List<ResponseWrapper> errorList = new List<ResponseWrapper>();
            ResponseWrapper error = new ResponseWrapper();
            
            error.messagetype = 'ERROR';
            error.messagetext = e.getMessage() + ' line :'+e.getLineNumber();
            errorList.add(error);
            
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'ESSMSS_REST_EmployeeImport';
            log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
            log.Message_Type__c = 'Fail';
            String requestBodySubStr = JSON.serialize(SAPEmployeeList);
            log.Request_Body__c = (requestBodySubStr.length() > 131071) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
            String responseBodySubStr = JSON.serialize(error);
            log.Response_Body__c = (responseBodySubStr.length() > 131071) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
            log.OwnerId = UserInfo.getUserId();
            insert log;
            
            return error;
        }
    }
}