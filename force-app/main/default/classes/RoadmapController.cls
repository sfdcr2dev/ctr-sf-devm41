/* Class for Roadmap VF Page */
public with sharing class RoadmapController {

    public string ProjectId {get;set;}
    public ProjectWrapper PW {get;set;}
    public string BaseUrl {get;set;}
    public boolean IsDisable1011 {get;set;}
    public boolean IsDisable1819 {get;set;}
    
    public integer CurrentStep {get;set;}
    public integer CurrentStep00 {get;set;}
    
    public class ProjectWrapper {
        public string ProjectName {get;set;}
        public string ProjectNo {get;set;}
        public string ProjectUrl {get;set;}
        public List<ProjectWorkProcess> WorkProcesses {get;set;}
    }
    
    public class ProjectWorkProcess {
        public string Name {get;set;}
        public string Status {get;set;}
        public decimal No {get;set;}
        public string WPURL {get;set;}
    }
    
    public RoadmapController() {
        
        ProjectId = ApexPages.currentPage().getParameters().get('ProjectId');
        BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        IsDisable1011 = false;
        IsDisable1819 = false;
        PW = new ProjectWrapper();
        
        Project__c Project = [select id, name, Project_Number__c from Project__c where Id =: ProjectId];
        
        if(Project != null) {
            PW.ProjectName = Project.Name;
            PW.ProjectNo = Project.Project_Number__c;
            PW.ProjectUrl = baseUrl + 'lightning/r/' + Project.Id + '/view';
        }
        
        AllWorkProcessStatus();
        
    }
    
    public void AllWorkProcessStatus() {
    
        integer lastCompletedWP = 0;
        CurrentStep = 1;
        
        PW.WorkProcesses = new List<ProjectWorkProcess>();
    
        Project_Charter__c S1 = [select id, name, Project__c, No__c, Work_Process_Status__c from Project_Charter__c where Project__c =: ProjectId];
        
        if(S1 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S1.Name;
            WP.Status = S1.Work_Process_Status__c;
            WP.No = S1.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S1.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed') {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
            
        }
        
        Project_Organization__c S2 = [select id, name, Project__c, No__c, Work_Process_Status__c from Project_Organization__c where Project__c =: ProjectId];
        
        if(S2 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S2.Name;
            WP.Status = S2.Work_Process_Status__c;
            WP.No = S2.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S2.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 1) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
            
        }
        
        Lesson_Learnt_Review__c S3 = [select id, name, Project__c, No__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: ProjectId];
        
        if(S3 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S3.Name;
            WP.Status = S3.Work_Process_Status__c;
            WP.No = S3.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S3.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 2) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Project_Execution_Plan__c S4 = [select id, name, Project__c, No__c, Work_Process_Status__c, Service_Requisition__c from Project_Execution_Plan__c where Project__c =: ProjectId];
        
        if(S4 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S4.Name;
            WP.Status = S4.Work_Process_Status__c;
            WP.No = S4.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S4.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 3) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
            
            if(S4.Service_Requisition__c == 'EP (Owner)') {
                IsDisable1011 = true;
                IsDisable1819 = false;
            }
            else if(S4.Service_Requisition__c == 'EPC') {
                IsDisable1819 = true;
                IsDisable1011 = false;
            }
            else {
                IsDisable1011 = false;
                IsDisable1819 = false;
            }
        }
        
        Project_Procurement_Plan__c S5 = [select id, name, Project__c, No__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: ProjectId];
        
        if(S5 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S5.Name;
            WP.Status = S5.Work_Process_Status__c;
            WP.No = S5.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S5.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 4) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        WBS_CBS__c S6 = [select id, name, Project__c, No__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: ProjectId];
        
        if(S6 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S6.Name;
            WP.Status = S6.Work_Process_Status__c;
            WP.No = S6.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S6.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 5) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Schedule__c S7 = [select id, name, Project__c, No__c, Work_Process_Status__c from Schedule__c where Project__c =: ProjectId];
        
        if(S7 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S7.Name;
            WP.Status = S7.Work_Process_Status__c;
            WP.No = S7.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S7.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 6) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Project_Status_Control__c S8 = [select id, name, Project__c, No__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: ProjectId];
        
        if(S8 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S8.Name;
            WP.Status = S8.Work_Process_Status__c;
            WP.No = S8.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S8.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 7) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Budget_Phasing__c S9 = [select id, name, Project__c, No__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: ProjectId];
        
        if(S9 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S9.Name;
            WP.Status = S9.Work_Process_Status__c;
            WP.No = S9.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S9.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 8) {
                
                if(IsDisable1011) {
                    lastCompletedWP = lastCompletedWP + 3;
                }
                else {
                    lastCompletedWP++;
                }
                
                CurrentStep = Integer.ValueOf(WP.No + 1);
                
            }
        }
        
        ITB_Standard__c S10 = [select id, name, Project__c, No__c, Work_Process_Status__c from ITB_Standard__c where Project__c =: ProjectId];
        
        if(S10 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S10.Name;
            WP.Status = S10.Work_Process_Status__c;
            WP.No = S10.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S10.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 9) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        CCE_Approval_Process__c S11 = [select id, name, Project__c, No__c, Work_Process_Status__c from CCE_Approval_Process__c where Project__c =: ProjectId];
        
        if(S11 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S11.Name;
            WP.Status = S11.Work_Process_Status__c;
            WP.No = S11.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S11.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 10) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Engineering_Standard__c S12 = [select id, name, Project__c, No__c, Work_Process_Status__c from Engineering_Standard__c where Project__c =: ProjectId];
        
        if(S12 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S12.Name;
            WP.Status = S12.Work_Process_Status__c;
            WP.No = S12.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S12.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 11) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Deliverable_List__c S13 = [select id, name, Project__c, No__c, Work_Process_Status__c from Deliverable_List__c where Project__c =: ProjectId];
        
        if(S13 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S13.Name;
            WP.Status = S13.Work_Process_Status__c;
            WP.No = S13.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S13.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 12) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Document_Distribution_Matrix__c S14 = [select id, name, Project__c, No__c, Work_Process_Status__c from Document_Distribution_Matrix__c where Project__c =: ProjectId];
        
        if(S14 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S14.Name;
            WP.Status = S14.Work_Process_Status__c;
            WP.No = S14.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S14.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 13) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Design_Safety_Standard__c S15 = [select id, name, Project__c, No__c, Work_Process_Status__c from Design_Safety_Standard__c where Project__c =: ProjectId];
        
        if(S15 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S15.Name;
            WP.Status = S15.Work_Process_Status__c;
            WP.No = S15.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S15.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 14) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Cost_Estimate__c S16 = [select id, name, Project__c, No__c, Work_Process_Status__c from Cost_Estimate__c where Project__c =: ProjectId];
        
        if(S16 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S16.Name;
            WP.Status = S16.Work_Process_Status__c;
            WP.No = S16.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S16.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 15) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Engineering_Data_Book_and_3D_Model__c S17 = [select id, name, Project__c, No__c, Work_Process_Status__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: ProjectId];
        
        if(S17 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S17.Name;
            WP.Status = S17.Work_Process_Status__c;
            WP.No = S17.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S17.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 16) {
                
                if(IsDisable1819) {
                    lastCompletedWP = lastCompletedWP + 3;
                }
                else {
                    lastCompletedWP++;
                }
                
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        ITB_Standard_18__c S18 = [select id, name, Project__c, No__c, Work_Process_Status__c from ITB_Standard_18__c where Project__c =: ProjectId];
        
        if(S18 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S18.Name;
            WP.Status = S18.Work_Process_Status__c;
            WP.No = S18.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S18.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 17) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        CCE_Approval_Process_19__c S19 = [select id, name, Project__c, No__c, Work_Process_Status__c from CCE_Approval_Process_19__c where Project__c =: ProjectId];
        
        if(S19 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S19.Name;
            WP.Status = S19.Work_Process_Status__c;
            WP.No = S19.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S19.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 18) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        
        
        Project_Procurement_Contract_Mgmt__c S20 = [select id, name, Project__c, No__c, Work_Process_Status__c from Project_Procurement_Contract_Mgmt__c where Project__c =: ProjectId];
        
        if(S20 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S20.Name;
            WP.Status = S20.Work_Process_Status__c;
            WP.No = S20.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S20.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 19) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Vendor_Data_Management__c S21 = [select id, name, Project__c, No__c, Work_Process_Status__c from Vendor_Data_Management__c where Project__c =: ProjectId];
        
        if(S21 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S21.Name;
            WP.Status = S21.Work_Process_Status__c;
            WP.No = S21.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S21.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 20) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Material_Inspection_FAT_SAT__c S22 = [select id, name, Project__c, No__c, Work_Process_Status__c from Material_Inspection_FAT_SAT__c where Project__c =: ProjectId];
        
        if(S22 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S22.Name;
            WP.Status = S22.Work_Process_Status__c;
            WP.No = S22.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S22.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 21) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Surplus_Spar_part_Management__c S23 = [select id, name, Project__c, No__c, Work_Process_Status__c from Surplus_Spar_part_Management__c where Project__c =: ProjectId];
        
        if(S23 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S23.Name;
            WP.Status = S23.Work_Process_Status__c;
            WP.No = S23.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S23.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 22) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Construction_Management__c S24 = [select id, name, Project__c, No__c, Work_Process_Status__c from Construction_Management__c where Project__c =: ProjectId];
        
        if(S24 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S24.Name;
            WP.Status = S24.Work_Process_Status__c;
            WP.No = S24.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S24.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 23) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Budget_Change_Control__c S25 = [select id, name, Project__c, No__c, Work_Process_Status__c from Budget_Change_Control__c where Project__c =: ProjectId];
        
        if(S25 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S25.Name;
            WP.Status = S25.Work_Process_Status__c;
            WP.No = S25.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S25.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 24) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        System_Test_Pack_Identification__c S26 = [select id, name, Project__c, No__c, Work_Process_Status__c from System_Test_Pack_Identification__c where Project__c =: ProjectId];
        
        if(S26 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S26.Name;
            WP.Status = S26.Work_Process_Status__c;
            WP.No = S26.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S26.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 25) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Punch_List_Management_System__c S27 = [select id, name, Project__c, No__c, Work_Process_Status__c from Punch_List_Management_System__c where Project__c =: ProjectId];
        
        if(S27 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S27.Name;
            WP.Status = S27.Work_Process_Status__c;
            WP.No = S27.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S27.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 26) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        MC_RSFU__c S28 = [select id, name, Project__c, No__c, Work_Process_Status__c from MC_RSFU__c where Project__c =: ProjectId];
        
        if(S28 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S28.Name;
            WP.Status = S28.Work_Process_Status__c;
            WP.No = S28.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S28.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 27) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        MCA__c S29 = [select id, name, Project__c, No__c, Work_Process_Status__c from MCA__c where Project__c =: ProjectId];
        
        if(S29 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S29.Name;
            WP.Status = S29.Work_Process_Status__c;
            WP.No = S29.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S29.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 28) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Close_Out_Report_Lesson_Learnt__c S30 = [select id, name, Project__c, No__c, Work_Process_Status__c from Close_Out_Report_Lesson_Learnt__c where Project__c =: ProjectId];
        
        if(S30 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S30.Name;
            WP.Status = S30.Work_Process_Status__c;
            WP.No = S30.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S30.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 29) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Close_Out_Database__c S31 = [select id, name, Project__c, No__c, Work_Process_Status__c from Close_Out_Database__c where Project__c =: ProjectId];
        
        if(S31 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S31.Name;
            WP.Status = S31.Work_Process_Status__c;
            WP.No = S31.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S31.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 30) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        CR_Completion_Report__c S32 = [select id, name, Project__c, No__c, Work_Process_Status__c from CR_Completion_Report__c where Project__c =: ProjectId];
        
        if(S32 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S32.Name;
            WP.Status = S32.Work_Process_Status__c;
            WP.No = S32.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S32.Id + '/view';
            PW.WorkProcesses.add(WP);
            
            if(WP.Status == 'Completed' && lastCompletedWP == 31) {
                lastCompletedWP++;
                CurrentStep = Integer.ValueOf(WP.No + 1);
            }
        }
        
        Project_Risk_Assessment__c S00 = [select id, name, Project__c, No__c, Work_Process_Status__c from Project_Risk_Assessment__c where Project__c =: ProjectId];
        
        if(S00 != null) {
            ProjectWorkProcess WP = new ProjectWorkProcess();
            WP.Name = S00.Name;
            WP.Status = S00.Work_Process_Status__c;
            WP.No = S00.No__c;
            WP.WPURL = baseUrl + 'lightning/r/' + S00.Id + '/view';
            PW.WorkProcesses.add(WP);
        }
    }

    public string LanguageThai {
        get {
            return EncodingUtil.base64decode('77u/').toString();
        }
    }

}