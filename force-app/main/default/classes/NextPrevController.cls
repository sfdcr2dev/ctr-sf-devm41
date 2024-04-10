/* Class for NextPrev Button */
public with sharing class NextPrevController {

    @auraEnabled
    public static string getNextStep(Id ProjectId, Integer StepNo) {
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        string userTheme = UserInfo.getUiTheme();
        
        Integer nextStepNo = StepNo + 1;
        
        boolean IsDisable1011 = false;
        boolean IsDisable1819 = false;
        
        Project_Charter__c S1 = [select id, Project__c, No__c from Project_Charter__c where Project__c =: ProjectId];
        Project_Organization__c S2 = [select id, Project__c, No__c from Project_Organization__c where Project__c =: ProjectId];
        Lesson_Learnt_Review__c S3 = [select id, Project__c, No__c from Lesson_Learnt_Review__c where Project__c =: ProjectId];
        Project_Execution_Plan__c S4 = [select id, Project__c, No__c, Service_Requisition__c from Project_Execution_Plan__c where Project__c =: ProjectId];
        Project_Procurement_Plan__c S5 = [select id, Project__c, No__c from Project_Procurement_Plan__c where Project__c =: ProjectId];
        WBS_CBS__c S6 = [select id, Project__c, No__c from WBS_CBS__c where Project__c =: ProjectId];
        Schedule__c S7 = [select id, Project__c, No__c from Schedule__c where Project__c =: ProjectId];
        Project_Status_Control__c S8 = [select id, Project__c, No__c from Project_Status_Control__c where Project__c =: ProjectId];
        Budget_Phasing__c S9 = [select id, Project__c, No__c from Budget_Phasing__c where Project__c =: ProjectId];
        ITB_Standard__c S10 = [select id, Project__c, No__c from ITB_Standard__c where Project__c =: ProjectId];
        CCE_Approval_Process__c S11 = [select id, Project__c, No__c from CCE_Approval_Process__c where Project__c =: ProjectId];
        Engineering_Standard__c S12 = [select id, Project__c, No__c from Engineering_Standard__c where Project__c =: ProjectId];
        Deliverable_List__c S13 = [select id, Project__c, No__c from Deliverable_List__c where Project__c =: ProjectId];
        Document_Distribution_Matrix__c S14 = [select id, Project__c, No__c from Document_Distribution_Matrix__c where Project__c =: ProjectId];
        Design_Safety_Standard__c S15 = [select id, Project__c, No__c from Design_Safety_Standard__c where Project__c =: ProjectId];
        Cost_Estimate__c S16 = [select id, Project__c, No__c from Cost_Estimate__c where Project__c =: ProjectId];
        Engineering_Data_Book_and_3D_Model__c S17 = [select id, Project__c, No__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: ProjectId];
        ITB_Standard_18__c S18 = [select id, Project__c, No__c from ITB_Standard_18__c where Project__c =: ProjectId];
        CCE_Approval_Process_19__c S19 = [select id, Project__c, No__c from CCE_Approval_Process_19__c where Project__c =: ProjectId];
        Project_Procurement_Contract_Mgmt__c S20 = [select id, Project__c, No__c from Project_Procurement_Contract_Mgmt__c where Project__c =: ProjectId];
        Vendor_Data_Management__c S21 = [select id, Project__c, No__c from Vendor_Data_Management__c where Project__c =: ProjectId];
        Material_Inspection_FAT_SAT__c S22 = [select id, Project__c, No__c from Material_Inspection_FAT_SAT__c where Project__c =: ProjectId];
        Surplus_Spar_part_Management__c S23 = [select id, Project__c, No__c from Surplus_Spar_part_Management__c where Project__c =: ProjectId];
        Construction_Management__c S24 = [select id, Project__c, No__c from Construction_Management__c where Project__c =: ProjectId];
        Budget_Change_Control__c S25 = [select id, Project__c, No__c from Budget_Change_Control__c where Project__c =: ProjectId];
        System_Test_Pack_Identification__c S26 = [select id, Project__c, No__c from System_Test_Pack_Identification__c where Project__c =: ProjectId];
        Punch_List_Management_System__c S27 = [select id, Project__c, No__c from Punch_List_Management_System__c where Project__c =: ProjectId];
        MC_RSFU__c S28 = [select id, Project__c, No__c from MC_RSFU__c where Project__c =: ProjectId];
        MCA__c S29 = [select id, Project__c, No__c from MCA__c where Project__c =: ProjectId];
        Close_Out_Report_Lesson_Learnt__c S30 = [select id, Project__c, No__c from Close_Out_Report_Lesson_Learnt__c where Project__c =: ProjectId];
        Close_Out_Database__c S31 = [select id, Project__c, No__c from Close_Out_Database__c where Project__c =: ProjectId];
        CR_Completion_Report__c S32 = [select id, Project__c, No__c from CR_Completion_Report__c where Project__c =: ProjectId];
        Project_Risk_Assessment__c S00 = [select id, Project__c, No__c from Project_Risk_Assessment__c where Project__c =: ProjectId];
        
        string completeUrl = '';
        string recordId = '';
        
        if(nextStepNo == 2) {
        	completeUrl = 'lightning/r/' + S2.Id + '/view';
            recordId = S2.Id;
        }
        else if(nextStepNo == 3) {
        	completeUrl = 'lightning/r/' + S3.Id + '/view';
            recordId = S3.Id;
        }
        else if(nextStepNo == 4) {
        	completeUrl = 'lightning/r/' + S4.Id + '/view';
            recordId = S4.Id;
        }
        else if(nextStepNo == 5) {
        	completeUrl = 'lightning/r/' + S5.Id + '/view';
            recordId = S5.Id;
        }
        else if(nextStepNo == 6) {
        	completeUrl = 'lightning/r/' + S6.Id + '/view';
            recordId = S6.Id;
        }
        else if(nextStepNo == 7) {
        	completeUrl = 'lightning/r/' + S7.Id + '/view';
            recordId = S7.Id;
        }
        else if(nextStepNo == 8) {
        	completeUrl = 'lightning/r/' + S8.Id + '/view';
            recordId = S8.Id;
        }
        else if(nextStepNo == 9) {
        	completeUrl = 'lightning/r/' + S9.Id + '/view';
            recordId = S9.Id;
        }
        else if(nextStepNo == 10) {
            
            if(S4.Service_Requisition__c == 'EP (Owner)') {
                
                IsDisable1011 = true;
                IsDisable1819 = false;
                
                completeUrl = 'lightning/r/' + S12.Id + '/view';
            	recordId = S12.Id;
                
            }
            else {
                completeUrl = 'lightning/r/' + S10.Id + '/view';
            	recordId = S10.Id;
            }
        	
        }
        else if(nextStepNo == 11) {
        	completeUrl = 'lightning/r/' + S11.Id + '/view';
            recordId = S11.Id;
        }
        else if(nextStepNo == 12) {
        	completeUrl = 'lightning/r/' + S12.Id + '/view';
            recordId = S12.Id;
        }
        else if(nextStepNo == 13) {
        	completeUrl = 'lightning/r/' + S13.Id + '/view';
            recordId = S13.Id;
        }
        else if(nextStepNo == 14) {
        	completeUrl = 'lightning/r/' + S14.Id + '/view';
            recordId = S14.Id;
        }
        else if(nextStepNo == 15) {
        	completeUrl = 'lightning/r/' + S15.Id + '/view';
            recordId = S15.Id;
        }
        else if(nextStepNo == 16) {
        	completeUrl = 'lightning/r/' + S16.Id + '/view';
            recordId = S16.Id;
        }
        else if(nextStepNo == 17) {
        	completeUrl = 'lightning/r/' + S17.Id + '/view';
            recordId = S17.Id;
        }
        else if(nextStepNo == 18) {
            
            if(S4.Service_Requisition__c == 'EPC') {
                IsDisable1819 = true;
                IsDisable1011 = false;
                completeUrl = 'lightning/r/' + S20.Id + '/view';
            	recordId = S20.Id;
            }
            else {
                completeUrl = 'lightning/r/' + S18.Id + '/view';
            	recordId = S18.Id;
            }
            
        }
        else if(nextStepNo == 19) {
        	completeUrl = 'lightning/r/' + S19.Id + '/view';
            recordId = S19.Id;
        }
        else if(nextStepNo == 20) {
        	completeUrl = 'lightning/r/' + S20.Id + '/view';
            recordId = S20.Id;
        }
        else if(nextStepNo == 21) {
        	completeUrl = 'lightning/r/' + S21.Id + '/view';
            recordId = S21.Id;
        }
        else if(nextStepNo == 22) {
        	completeUrl = 'lightning/r/' + S22.Id + '/view';
            recordId = S22.Id;
        }
        else if(nextStepNo == 23) {
        	completeUrl = 'lightning/r/' + S23.Id + '/view';
            recordId = S23.Id;
        }
        else if(nextStepNo == 24) {
        	completeUrl = 'lightning/r/' + S24.Id + '/view';
            recordId = S24.Id;
        }
        else if(nextStepNo == 25) {
        	completeUrl = 'lightning/r/' + S25.Id + '/view';
            recordId = S25.Id;
        }
        else if(nextStepNo == 26) {
        	completeUrl = 'lightning/r/' + S26.Id + '/view';
            recordId = S26.Id;
        }
        else if(nextStepNo == 27) {
        	completeUrl = 'lightning/r/' + S27.Id + '/view';
            recordId = S27.Id;
        }
        else if(nextStepNo == 28) {
        	completeUrl = 'lightning/r/' + S28.Id + '/view';
            recordId = S28.Id;
        }
        else if(nextStepNo == 29) {
        	completeUrl = 'lightning/r/' + S29.Id + '/view';
            recordId = S29.Id;
        }
        else if(nextStepNo == 30) {
        	completeUrl = 'lightning/r/' + S30.Id + '/view';
            recordId = S30.Id;
        }
        else if(nextStepNo == 31) {
        	completeUrl = 'lightning/r/' + S31.Id + '/view';
            recordId = S31.Id;
        }
        else if(nextStepNo == 32) {
        	completeUrl = 'lightning/r/' + S32.Id + '/view';
            recordId = S32.Id;
        }
        
        if(userTheme == 'Theme4d') {
            completeUrl = baseUrl + completeUrl;
        }
        else if(userTheme == 'Theme4t') {
            completeUrl = recordId;
        }
        
        return completeUrl;
        
    }
    
    @auraEnabled
    public static string getPrevStep(Id ProjectId, Integer StepNo) {
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        string userTheme = UserInfo.getUiTheme();
        
        Integer prevStepNo = StepNo - 1;
        
        boolean IsDisable1011 = false;
        boolean IsDisable1819 = false;
        
        Project_Charter__c S1 = [select id, Project__c, No__c from Project_Charter__c where Project__c =: ProjectId];
        Project_Organization__c S2 = [select id, Project__c, No__c from Project_Organization__c where Project__c =: ProjectId];
        Lesson_Learnt_Review__c S3 = [select id, Project__c, No__c from Lesson_Learnt_Review__c where Project__c =: ProjectId];
        Project_Execution_Plan__c S4 = [select id, Project__c, No__c, Service_Requisition__c from Project_Execution_Plan__c where Project__c =: ProjectId];
        Project_Procurement_Plan__c S5 = [select id, Project__c, No__c from Project_Procurement_Plan__c where Project__c =: ProjectId];
        WBS_CBS__c S6 = [select id, Project__c, No__c from WBS_CBS__c where Project__c =: ProjectId];
        Schedule__c S7 = [select id, Project__c, No__c from Schedule__c where Project__c =: ProjectId];
        Project_Status_Control__c S8 = [select id, Project__c, No__c from Project_Status_Control__c where Project__c =: ProjectId];
        Budget_Phasing__c S9 = [select id, Project__c, No__c from Budget_Phasing__c where Project__c =: ProjectId];
        ITB_Standard__c S10 = [select id, Project__c, No__c from ITB_Standard__c where Project__c =: ProjectId];
        CCE_Approval_Process__c S11 = [select id, Project__c, No__c from CCE_Approval_Process__c where Project__c =: ProjectId];
        Engineering_Standard__c S12 = [select id, Project__c, No__c from Engineering_Standard__c where Project__c =: ProjectId];
        Deliverable_List__c S13 = [select id, Project__c, No__c from Deliverable_List__c where Project__c =: ProjectId];
        Document_Distribution_Matrix__c S14 = [select id, Project__c, No__c from Document_Distribution_Matrix__c where Project__c =: ProjectId];
        Design_Safety_Standard__c S15 = [select id, Project__c, No__c from Design_Safety_Standard__c where Project__c =: ProjectId];
        Cost_Estimate__c S16 = [select id, Project__c, No__c from Cost_Estimate__c where Project__c =: ProjectId];
        Engineering_Data_Book_and_3D_Model__c S17 = [select id, Project__c, No__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: ProjectId];
        ITB_Standard_18__c S18 = [select id, Project__c, No__c from ITB_Standard_18__c where Project__c =: ProjectId];
        CCE_Approval_Process_19__c S19 = [select id, Project__c, No__c from CCE_Approval_Process_19__c where Project__c =: ProjectId];
        Project_Procurement_Contract_Mgmt__c S20 = [select id, Project__c, No__c from Project_Procurement_Contract_Mgmt__c where Project__c =: ProjectId];
        Vendor_Data_Management__c S21 = [select id, Project__c, No__c from Vendor_Data_Management__c where Project__c =: ProjectId];
        Material_Inspection_FAT_SAT__c S22 = [select id, Project__c, No__c from Material_Inspection_FAT_SAT__c where Project__c =: ProjectId];
        Surplus_Spar_part_Management__c S23 = [select id, Project__c, No__c from Surplus_Spar_part_Management__c where Project__c =: ProjectId];
        Construction_Management__c S24 = [select id, Project__c, No__c from Construction_Management__c where Project__c =: ProjectId];
        Budget_Change_Control__c S25 = [select id, Project__c, No__c from Budget_Change_Control__c where Project__c =: ProjectId];
        System_Test_Pack_Identification__c S26 = [select id, Project__c, No__c from System_Test_Pack_Identification__c where Project__c =: ProjectId];
        Punch_List_Management_System__c S27 = [select id, Project__c, No__c from Punch_List_Management_System__c where Project__c =: ProjectId];
        MC_RSFU__c S28 = [select id, Project__c, No__c from MC_RSFU__c where Project__c =: ProjectId];
        MCA__c S29 = [select id, Project__c, No__c from MCA__c where Project__c =: ProjectId];
        Close_Out_Report_Lesson_Learnt__c S30 = [select id, Project__c, No__c from Close_Out_Report_Lesson_Learnt__c where Project__c =: ProjectId];
        Close_Out_Database__c S31 = [select id, Project__c, No__c from Close_Out_Database__c where Project__c =: ProjectId];
        CR_Completion_Report__c S32 = [select id, Project__c, No__c from CR_Completion_Report__c where Project__c =: ProjectId];
        Project_Risk_Assessment__c S00 = [select id, Project__c, No__c from Project_Risk_Assessment__c where Project__c =: ProjectId];
        
        string completeUrl = '';
        string recordId = '';
        
        if(prevStepNo == 1) {
        	completeUrl = 'lightning/r/' + S1.Id + '/view';
            recordId = S1.Id;
        }
        else if(prevStepNo == 2) {
        	completeUrl = 'lightning/r/' + S2.Id + '/view';
            recordId = S2.Id;
        }
        else if(prevStepNo == 3) {
        	completeUrl = 'lightning/r/' + S3.Id + '/view';
            recordId = S3.Id;
        }
        else if(prevStepNo == 4) {
        	completeUrl = 'lightning/r/' + S4.Id + '/view';
            recordId = S4.Id;
        }
        else if(prevStepNo == 5) {
        	completeUrl = 'lightning/r/' + S5.Id + '/view';
            recordId = S5.Id;
        }
        else if(prevStepNo == 6) {
        	completeUrl = 'lightning/r/' + S6.Id + '/view';
            recordId = S6.Id;
        }
        else if(prevStepNo == 7) {
        	completeUrl = 'lightning/r/' + S7.Id + '/view';
            recordId = S7.Id;
        }
        else if(prevStepNo == 8) {
        	completeUrl = 'lightning/r/' + S8.Id + '/view';
            recordId = S8.Id;
        }
        else if(prevStepNo == 9) {
        	completeUrl = 'lightning/r/' + S9.Id + '/view';
            recordId = S9.Id;
        }
        else if(prevStepNo == 10) {
        	completeUrl = 'lightning/r/' + S10.Id + '/view';
            recordId = S10.Id;
        }
        else if(prevStepNo == 11) {
            if(S4.Service_Requisition__c == 'EP (Owner)') {
                
                IsDisable1011 = true;
                IsDisable1819 = false;
                
                completeUrl = 'lightning/r/' + S9.Id + '/view';
            	recordId = S9.Id;
                
            }
            else {
                completeUrl = 'lightning/r/' + S11.Id + '/view';
            	recordId = S11.Id;
            }
            
        }
        else if(prevStepNo == 12) {
        	completeUrl = 'lightning/r/' + S12.Id + '/view';
            recordId = S12.Id;
        }
        else if(prevStepNo == 13) {
        	completeUrl = 'lightning/r/' + S13.Id + '/view';
            recordId = S13.Id;
        }
        else if(prevStepNo == 14) {
        	completeUrl = 'lightning/r/' + S14.Id + '/view';
            recordId = S14.Id;
        }
        else if(prevStepNo == 15) {
        	completeUrl = 'lightning/r/' + S15.Id + '/view';
            recordId = S15.Id;
        }
        else if(prevStepNo == 16) {
        	completeUrl = 'lightning/r/' + S16.Id + '/view';
            recordId = S16.Id;
        }
        else if(prevStepNo == 17) {
        	completeUrl = 'lightning/r/' + S17.Id + '/view';
            recordId = S17.Id;
        }
        else if(prevStepNo == 18) {
        	completeUrl = 'lightning/r/' + S18.Id + '/view';
            recordId = S18.Id;
        }
        else if(prevStepNo == 19) {
            if(S4.Service_Requisition__c == 'EPC') {
                IsDisable1819 = true;
                IsDisable1011 = false;
                completeUrl = 'lightning/r/' + S17.Id + '/view';
            	recordId = S17.Id;
            }
            else {
                completeUrl = 'lightning/r/' + S19.Id + '/view';
            	recordId = S19.Id;
            }
            
        }
        else if(prevStepNo == 20) {
        	completeUrl = 'lightning/r/' + S20.Id + '/view';
            recordId = S20.Id;
        }
        else if(prevStepNo == 21) {
        	completeUrl = 'lightning/r/' + S21.Id + '/view';
            recordId = S21.Id;
        }
        else if(prevStepNo == 22) {
        	completeUrl = 'lightning/r/' + S22.Id + '/view';
            recordId = S22.Id;
        }
        else if(prevStepNo == 23) {
        	completeUrl = 'lightning/r/' + S23.Id + '/view';
            recordId = S23.Id;
        }
        else if(prevStepNo == 24) {
        	completeUrl = 'lightning/r/' + S24.Id + '/view';
            recordId = S24.Id;
        }
        else if(prevStepNo == 25) {
        	completeUrl = 'lightning/r/' + S25.Id + '/view';
            recordId = S25.Id;
        }
        else if(prevStepNo == 26) {
        	completeUrl = 'lightning/r/' + S26.Id + '/view';
            recordId = S26.Id;
        }
        else if(prevStepNo == 27) {
        	completeUrl = 'lightning/r/' + S27.Id + '/view';
            recordId = S27.Id;
        }
        else if(prevStepNo == 28) {
        	completeUrl = 'lightning/r/' + S28.Id + '/view';
            recordId = S28.Id;
        }
        else if(prevStepNo == 29) {
        	completeUrl = 'lightning/r/' + S29.Id + '/view';
            recordId = S29.Id;
        }
        else if(prevStepNo == 30) {
        	completeUrl = 'lightning/r/' + S30.Id + '/view';
            recordId = S30.Id;
        }
        else if(prevStepNo == 31) {
        	completeUrl = 'lightning/r/' + S31.Id + '/view';
            recordId = S31.Id;
        }
        
        if(userTheme == 'Theme4d') {
            completeUrl = baseUrl + completeUrl;
        }
        else if(userTheme == 'Theme4t') {
            completeUrl = recordId;
        }
        
        return completeUrl;
        
    }
    
}