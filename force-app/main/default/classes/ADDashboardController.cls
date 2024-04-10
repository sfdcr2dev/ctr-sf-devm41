/* Class for ADDashboard VF Page */
public with sharing class ADDashboardController {

    public string BaseUrl {get;set;}
    public integer TotalProject {get;set;}
    public integer TotalOnGoingProject {get;set;}
    public integer TotalCompletedProject {get;set;}
    public string ChooseYear {get;set;}
    public integer YearNewProject {get;set;}
    public integer YearCompletedProject {get;set;}
    public Set<string> ProjectManagerNames {get;set;}
    public integer TotalPM {get;set;}
    public Set<Id> OngoingProjectIds {get;set;}
    public Set<Id> CompletedProjectIds {get;set;}
    public Set<SelectOption> YearList {get;set;}
    public Set<Integer> LastThreeYearList {get;set;}
    public boolean IsDisable1011 {get;set;}
    public boolean IsDisable1819 {get;set;}
    
    public List<Master_Data_Detail__c> MDDetails {get;set;}
    public boolean IsMasterDataAvailable {get;set;}
    
    public List<ProjectByPMWrapper> PMWrappers {get;set;}
    public List<SearchProjectWrapper> SearchWrappers {get;set;}
    public List<OngoingProjectWrapper> OngoingProjectWrappers {get;set;}
    public List<CompletedProjectWrapper> CompletedProjectWrappers {get;set;}
    
    public string EnteredProject {get;set;}
    
    public List<Project_Risk_Assessment__c> AllWP00s {get;set;}
    public List<Project_Charter__c> AllWP1s {get;set;}
    public List<Project_Organization__c> AllWP2s {get;set;}
    public List<Lesson_Learnt_Review__c> AllWP3s {get;set;}
    public List<Project_Execution_Plan__c> AllWP4s {get;set;}
    public List<Project_Procurement_Plan__c> AllWP5s {get;set;}
    public List<WBS_CBS__c> AllWP6s {get;set;}
    public List<Schedule__c> AllWP7s {get;set;}
    public List<Project_Status_Control__c> AllWP8s {get;set;}
    public List<Budget_Phasing__c> AllWP9s {get;set;}
    public List<ITB_Standard__c> AllWP10s {get;set;}
    public List<CCE_Approval_Process__c> AllWP11s {get;set;}
    public List<Engineering_Standard__c> AllWP12s {get;set;}
    public List<Deliverable_List__c> AllWP13s {get;set;}
    public List<Document_Distribution_Matrix__c> AllWP14s {get;set;}
    public List<Design_Safety_Standard__c> AllWP15s {get;set;}
    public List<Cost_Estimate__c> AllWP16s {get;set;}
    public List<Engineering_Data_Book_and_3D_Model__c> AllWP17s {get;set;}
    public List<ITB_Standard_18__c> AllWP18s {get;set;}
    public List<CCE_Approval_Process_19__c> AllWP19s {get;set;}
    public List<Project_Procurement_Contract_Mgmt__c> AllWP20s {get;set;}
    public List<Vendor_Data_Management__c> AllWP21s {get;set;}
    public List<Material_Inspection_FAT_SAT__c> AllWP22s {get;set;}
    public List<Surplus_Spar_part_Management__c> AllWP23s {get;set;}
    public List<Construction_Management__c> AllWP24s {get;set;}
    public List<Budget_Change_Control__c> AllWP25s {get;set;}
    public List<System_Test_Pack_Identification__c> AllWP26s {get;set;}
    public List<Punch_List_Management_System__c> AllWP27s {get;set;}
    public List<MC_RSFU__c> AllWP28s {get;set;}
    public List<MCA__c> AllWP29s {get;set;}
    public List<Close_Out_Report_Lesson_Learnt__c> AllWP30s {get;set;}
    public List<Close_Out_Database__c> AllWP31s {get;set;}
    public List<CR_Completion_Report__c> AllWP32s {get;set;}
    
    public static string TOTALPROJECT_SORT = 'TotalProject';
    public static string SORT_BY = TOTALPROJECT_SORT;
    
    public class ProjectByPMWrapper implements Comparable {
        public string PMName {get;set;}
        public integer OnGoingProject {get;set;}
        public integer CompletedProject {get;set;}
        public integer TotalProject {get;set;}
        public decimal CompletedProjectPercent {get;set;}
        public string OngoingWidthPercent {get;set;}
        public string CompletedWidthPercent {get;set;}
        
        public ProjectByPMWrapper() { }
        
        public ProjectByPMWrapper(integer TotalProject) {
            this.TotalProject = TotalProject;
        }
        
        public Integer sortByTotalProject(ProjectByPMWrapper project) {
            if (this.TotalProject < project.TotalProject) {
                return 1;
            }

            if (this.TotalProject == project.TotalProject) {
                return 0;
            }

            return -1;
        }
        
        public Integer compareTo(Object obj) {
            
            ProjectByPMWrapper PW = (ProjectByPMWrapper)(obj);
            
            if (SORT_BY == TOTALPROJECT_SORT) {
                return sortByTotalProject(PW);
            }
            
            // If we don't have a know sort by, let's just return that they are all equal
            return 0;
        }
    }
    
    public void sortByTotalProject() {
        
        ADDashboardController.SORT_BY = ADDashboardController.TOTALPROJECT_SORT;
        this.PMWrappers.sort();
        
    }
    
    public class SearchProjectWrapper {
        public string PMName {get;set;}
        public string ProjectName {get;set;}
        public integer ProjectNo {get;set;}
        public string ProjectUrl {get;set;}
        public string CurrentStep {get;set;}
        public string CurrentStepUrl {get;set;}
        public integer CompletedWorkProcess {get;set;}
    }
    
    public class WorkProcessWrapper {
        public integer ProjectNo {get;set;}
        public string CurrentStep {get;set;}
        public string CurrentStepUrl {get;set;}
        public integer CompletedWorkProcess {get;set;}
    }
    
    public class OngoingProjectWrapper {
        public string ProjectName {get;set;}
        public string PMName {get;set;}
        public string PlanStartDate {get;set;}
        public string PlanEndDate {get;set;}
        public string ActualStartDate {get;set;}
        public integer CompletedWP {get;set;}
        public boolean IsDisable1011 {get;set;}
        public boolean IsDisable1819 {get;set;}
    }
    
    public class CompletedProjectWrapper {
        public string ProjectName {get;set;}
        public string PMName {get;set;}
        public string PlanStartDate {get;set;}
        public string PlanEndDate {get;set;}
        public string ActualStartDate {get;set;}
        public string ActualEndDate {get;set;}
    }
   
    public ADDashboardController() {
    
        BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        //Master Data
        Master_Data__c MD = [select id, name from Master_Data__c where Name =: 'SME and Guideline'];
        IsMasterDataAvailable = false;
        
        if(MD != null) {
            
            MDDetails = [select id, Master_Data__c, Work_Process_No__c, Name from Master_Data_Detail__c where Master_Data__c =: MD.Id];
            
            if(MDDetails.size() > 0) {
                IsMasterDataAvailable = true;
            }
            
        }
        
        EnteredProject = '';
        TotalProject = 0;
        TotalOnGoingProject = 0;
        TotalCompletedProject = 0;
        YearNewProject = 0;
        YearCompletedProject = 0;
        ProjectManagerNames = new Set<string>();
        OngoingProjectIds = new Set<Id>();
        CompletedProjectIds = new Set<Id>();
        IsDisable1011 = false;
        IsDisable1819 = false;
        LastThreeYearList = new Set<Integer>();
        
        ChooseYear = string.ValueOf(System.Today().Year());
        
        List<Project__c> Projects = [select id, name, Status__c, Project_Manager__r.Name, CreatedDate from Project__c];
        
        //Load All Work Processes 
        AllWPs();
        
        //Year Picklist
        this.YearList = new Set<SelectOption>();
        
        if(Projects.size() > 0) {
            for(Project__c proj : Projects) {
                LastThreeYearList.add(Integer.ValueOf(proj.CreatedDate.Year()));
            }
        }
        
        if(Projects.size() > 0) {
        
            TotalProject = Projects.size();
        
            for(Project__c proj : Projects) {
            
                ProjectManagerNames.add(proj.Project_Manager__r.Name);
                
                if(proj.Status__c == 'New' || proj.Status__c == 'Ongoing') {
                    OngoingProjectIds.add(proj.Id);
                    TotalOnGoingProject = TotalOnGoingProject + 1;
                }
                else if(proj.Status__c == 'Completed') {
                    CompletedProjectIds.add(proj.Id);
                    TotalCompletedProject = TotalCompletedProject + 1;
                }
                
                integer year = proj.CreatedDate.Year();
                
                if(year == Integer.ValueOf(ChooseYear)) {
                    if(proj.Status__c == 'New' || proj.Status__c == 'Ongoing') {
                        YearNewProject = YearNewProject + 1;
                    }
                    
                    if(proj.Status__c == 'Completed') {
                        YearCompletedProject = YearCompletedProject + 1;
                    }
                }
                
            }
            
            //Project Status by PM
            ProjectStatusByPMs(Projects);
            sortByTotalProject();
               
            SearchProjectByName();
            
            //Ongoing Project
            OngoingProjects(OngoingProjectIds);
            TotalPM = ProjectManagerNames.size();
            
            //Completed Project
            CompletedProjects(CompletedProjectIds);
            
        }
    
    }
    
    public List<ProjectByPMWrapper> ProjectStatusByPMs(List<Project__c> Projects) {
        
        PMWrappers = new List<ProjectByPMWrapper>();
        
        if(ProjectManagerNames.size() > 0) {
        
            for(string PMName : ProjectManagerNames) {
            
                integer ongoing = 0;
                integer completed = 0;
                integer totalProject = 0;
                
                ProjectByPMWrapper PM = new ProjectByPMWrapper();
                PM.PMName = PMName;
            
                for(Project__c Project : Projects) {
                
                    if(Project.Project_Manager__r.Name == PMName) {
                        
                        if(Project.Status__c == 'New' || Project.Status__c == 'Ongoing') {
                            ongoing = ongoing + 1;
                        }
                        
                        if(Project.Status__c == 'Completed') {
                            completed = completed + 1;
                        }
                        
                        totalProject = totalProject + 1;
                        
                    }
                }
                
                integer totalOngingCompleted = ongoing + completed;
                
                if(totalOngingCompleted != 0) {
                    PM.OngoingWidthPercent = String.ValueOf((ongoing * 100) / totalOngingCompleted);
                    PM.CompletedWidthPercent = String.ValueOf((completed * 100) / totalOngingCompleted);
                }
                
                
                PM.OnGoingProject = ongoing;
                PM.CompletedProject = completed;
                PM.TotalProject = totalProject;
                
                if(PM.TotalProject == null) {
                    PM.TotalProject = 0;
                }
                
                if(PM.CompletedProject != 0) {
                    PM.CompletedProjectPercent = (PM.CompletedProject * 100) / PM.TotalProject;
                }
                else {
                    PM.CompletedProjectPercent = 0;
                }
                
                System.debug(PM);
                PMWrappers.add(PM);
            }
        }
        
        return PMWrappers;
    }
    
    public void SearchProjectByName() {
    
        SearchWrappers = new List<SearchProjectWrapper>();
        
        string enteredProject = '%'+ EnteredProject + '%';
        List<Project__c> Projects = new List<Project__c>();
        
        if(enteredProject == '') {
            Projects = [select id, name, Project_Number__c, Status__c, Project_Manager__r.Name from Project__c];
        } else if(enteredProject != '') {
            Projects = [select id, name, Project_Number__c, Status__c, Project_Manager__r.Name from Project__c where (Project_Manager__r.Name LIKE :enteredProject OR Name LIKE :enteredProject OR Project_Number__c LIKE :enteredProject)];
        }
        
        if(ProjectManagerNames.size() > 0) {
        
            for(Project__c Project : Projects) {
                
                SearchProjectWrapper PM = new SearchProjectWrapper();
            
                PM.PMName = Project.Project_Manager__r.Name;
                string ProjectName = Project.Project_Number__c + ' - ' + Project.Name;
                
                PM.ProjectName = ProjectName;
                PM.ProjectUrl = BaseUrl + 'lightning/r/' + Project.Id + '/view';
                WorkProcessWrapper WPW = FindCompletedWorkProcess(Project.Id);
                
                PM.ProjectNo = WPW.ProjectNo;
                PM.CurrentStep = WPW.CurrentStep;
                PM.CurrentStepUrl = WPW.CurrentStepUrl;
                
                SearchWrappers.add(PM);
            }
            
        }
        
    }
    
    public void OngoingProjects(Set<Id> OngoingProjectIds) {
        
        OngoingProjectWrappers = new List<OngoingProjectWrapper>();
        
        List<Project_Charter__c> WP1s = [select Id, Start_Plan__c, End_Plan__c, Actual_Start_Date__c, Actual_End_Date__c, Project__c, Project__r.Name, Project__r.Project_Manager__r.Name from Project_Charter__c where Project__c IN: OngoingProjectIds];
        
        List<Project_Execution_Plan__c> WP4s = [select Id, Service_Requisition__c, Project__c from Project_Execution_Plan__c where Project__c IN: OngoingProjectIds];
        
        if(WP1s.size() > 0) {
            for(Project_Charter__c WP1 : WP1s) {
            
                OngoingProjectWrapper OPW = new OngoingProjectWrapper();
                OPW.ProjectName = WP1.Project__r.Name;
                OPW.PMName = WP1.Project__r.Project_Manager__r.Name;
                
                if(WP1.Start_Plan__c != null) {
                    OPW.PlanStartDate = String.ValueOf(WP1.Start_Plan__c.Day()) + '/' + String.ValueOf(WP1.Start_Plan__c.Month()) + '/' + String.ValueOf(WP1.Start_Plan__c.Year());
                }
                if(WP1.End_Plan__c != null) {
                    OPW.PlanEndDate = String.ValueOf(WP1.End_Plan__c.Day()) + '/' + String.ValueOf(WP1.End_Plan__c.Month()) + '/' + String.ValueOf(WP1.End_Plan__c.Year());
                }
                if(WP1.Actual_Start_Date__c != null) {
                    OPW.ActualStartDate = String.ValueOf(WP1.Actual_Start_Date__c.Day()) + '/' + String.ValueOf(WP1.Actual_Start_Date__c.Month()) + '/' + String.ValueOf(WP1.Actual_Start_Date__c.Year());
                }
                
                WorkProcessWrapper WPW = FindCompletedWorkProcess(WP1.Project__c);
                OPW.CompletedWP = WPW.CompletedWorkProcess;
                
                if(WP4s.size() > 0) {
                    
                    for(Project_Execution_Plan__c WP4 : WP4s) {
                        if(WP4.Project__c == WP1.Project__c) {
                            if(WP4.Service_Requisition__c == 'EP (Owner)') {
                                OPW.IsDisable1011 = true;
                                OPW.IsDisable1819 = false;
                            }
                            else if(WP4.Service_Requisition__c == 'EPC') {
                                OPW.IsDisable1819 = true;
                                OPW.IsDisable1011 = false;
                            }
                            else {
                                OPW.IsDisable1011 = false;
                                OPW.IsDisable1819 = false;
                            }
                            
                            break;
                        }
                    }
                    
                }
                
                OngoingProjectWrappers.add(OPW);
                
            }
        }
    }
    
    public void CompletedProjects(Set<Id> CompletedProjectIds) {
        
        CompletedProjectWrappers = new List<CompletedProjectWrapper>();
        
        List<Project_Charter__c> WP1s = [select Id, Start_Plan__c, End_Plan__c, Actual_Start_Date__c, Actual_End_Date__c, Project__c, Project__r.Name, Project__r.Project_Manager__r.Name from Project_Charter__c where Project__c IN: CompletedProjectIds];
        
        if(WP1s.size() > 0) {
            for(Project_Charter__c WP1 : WP1s) {
            
                CompletedProjectWrapper CPW = new CompletedProjectWrapper();
                CPW.ProjectName = WP1.Project__r.Name;
                CPW.PMName = WP1.Project__r.Project_Manager__r.Name;
                
                if(WP1.Start_Plan__c != null) {
                    CPW.PlanStartDate = String.ValueOf(WP1.Start_Plan__c.Day()) + '/' + String.ValueOf(WP1.Start_Plan__c.Month()) + '/' + String.ValueOf(WP1.Start_Plan__c.Year());
                }
                if(WP1.End_Plan__c != null) {
                    CPW.PlanEndDate = String.ValueOf(WP1.End_Plan__c.Day()) + '/' + String.ValueOf(WP1.End_Plan__c.Month()) + '/' + String.ValueOf(WP1.End_Plan__c.Year());
                }
                if(WP1.Actual_Start_Date__c != null) {
                    CPW.ActualStartDate = String.ValueOf(WP1.Actual_Start_Date__c.Day()) + '/' + String.ValueOf(WP1.Actual_Start_Date__c.Month()) + '/' + String.ValueOf(WP1.Actual_Start_Date__c.Year());
                }
                if(WP1.Actual_End_Date__c != null) {
                    CPW.ActualEndDate = String.ValueOf(WP1.Actual_End_Date__c.Day()) + '/' + String.ValueOf(WP1.Actual_End_Date__c.Month()) + '/' + String.ValueOf(WP1.Actual_End_Date__c.Year());
                }
                
                CompletedProjectWrappers.add(CPW);
                
            }
        }
        
    }
    
    public WorkProcessWrapper FindCompletedWorkProcess(string ProjectId) {
        
        integer completedWP = 0;
        integer lastCompletedWP = 0;
        IsDisable1011 = false;
        IsDisable1819 = false;
        
        WorkProcessWrapper SPW = new WorkProcessWrapper();
        
        if(AllWP1s.size() > 0) {
            for(Project_Charter__c WP1 : AllWP1s) {  
                if(WP1.Project__c == ProjectId && WP1.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP1.Project__c == ProjectId && (WP1.Work_Process_Status__c == 'Not Start' || WP1.Work_Process_Status__c == 'In Progress')) {
                    lastCompletedWP = Integer.ValueOf(WP1.No__c);
                    SPW.ProjectNo = Integer.ValueOf(WP1.No__c);
                    SPW.CurrentStep = lastCompletedWP + '. Project Charter';
                    SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP1.Id + '/view';
                    break;
                }
            }
        }
        
        if(AllWP2s.size() > 0) {
            for(Project_Organization__c WP2 : AllWP2s) {
                if(WP2.Project__c == ProjectId && WP2.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP2.Project__c == ProjectId && (WP2.Work_Process_Status__c == 'Not Start' || WP2.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 1) {
                        lastCompletedWP = Integer.ValueOf(WP2.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP2.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP2.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(AllWP3s.size() > 0) {
            for(Lesson_Learnt_Review__c WP3 : AllWP3s) {
                if(WP3.Project__c == ProjectId && WP3.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP3.Project__c == ProjectId && (WP3.Work_Process_Status__c == 'Not Start' || WP3.Work_Process_Status__c == 'In Progress')) {
                
                    if(completedWP == 2) {
                        lastCompletedWP = Integer.ValueOf(WP3.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP3.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP3.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP4s.size() > 0) {
            for(Project_Execution_Plan__c WP4 : AllWP4s) {
            
                if(WP4.Project__c == ProjectId) {
                    if(WP4.Service_Requisition__c == 'EP (Owner)') {
                        IsDisable1011 = true;
                        IsDisable1819 = false;
                    }
                    else if(WP4.Service_Requisition__c == 'EPC') {
                        IsDisable1819 = true;
                        IsDisable1011 = false;
                    }
                    else {
                        IsDisable1011 = false;
                        IsDisable1819 = false;
                    }
                    
                    if(WP4.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        break;
                    }
                    else if(WP4.Work_Process_Status__c == 'Not Start' || WP4.Work_Process_Status__c == 'In Progress') {
                        if(completedWP == 3) {
                            lastCompletedWP = Integer.ValueOf(WP4.No__c);
                            SPW.ProjectNo = Integer.ValueOf(WP4.No__c);
                            SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                            SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP4.Id + '/view';
                            break;
                        }
                    }
                }
            }
        }
        
        if(AllWP5s.size() > 0) {
            for(Project_Procurement_Plan__c WP5 : AllWP5s) {
                if(WP5.Project__c == ProjectId && WP5.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP5.Project__c == ProjectId && (WP5.Work_Process_Status__c == 'Not Start' || WP5.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 4) {
                        lastCompletedWP = Integer.ValueOf(WP5.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP5.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP5.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(AllWP6s.size() > 0) {
            for(WBS_CBS__c WP6 : AllWP6s) {
                if(WP6.Project__c == ProjectId && WP6.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP6.Project__c == ProjectId && (WP6.Work_Process_Status__c == 'Not Start' || WP6.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 5) {
                        lastCompletedWP = Integer.ValueOf(WP6.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP6.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP6.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP7s.size() > 0) {
            for(Schedule__c WP7 : AllWP7s) {
                if(WP7.Project__c == ProjectId && WP7.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP7.Project__c == ProjectId && (WP7.Work_Process_Status__c == 'Not Start' || WP7.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 6) {
                        lastCompletedWP = Integer.ValueOf(WP7.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP7.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP7.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(AllWP8s.size() > 0) {
            for(Project_Status_Control__c WP8 : AllWP8s) {
                if(WP8.Project__c == ProjectId && WP8.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP8.Project__c == ProjectId && (WP8.Work_Process_Status__c == 'Not Start' || WP8.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 7) {
                        lastCompletedWP = Integer.ValueOf(WP8.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP8.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP8.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP9s.size() > 0) {
            for(Budget_Phasing__c WP9 : AllWP9s) {
                if(WP9.Project__c == ProjectId && WP9.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP9.Project__c == ProjectId && (WP9.Work_Process_Status__c == 'Not Start' || WP9.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 8) {
                        lastCompletedWP = Integer.ValueOf(WP9.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP9.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP9.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(!IsDisable1011) {
        
            if(AllWP10s.size() > 0) {
                for(ITB_Standard__c WP10 : AllWP10s) {
                    if(WP10.Project__c == ProjectId && WP10.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        
                        break;
                    }
                    else if(WP10.Project__c == ProjectId && (WP10.Work_Process_Status__c == 'Not Start' || WP10.Work_Process_Status__c == 'In Progress')) {
                        
                        if(completedWP == 9) {
                            lastCompletedWP = Integer.ValueOf(WP10.No__c);
                            SPW.ProjectNo = Integer.ValueOf(WP10.No__c);
                            SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                            SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP10.Id + '/view';
                            break;
                        }
                    }
                }
            }
            
            if(AllWP11s.size() > 0) {
                for(CCE_Approval_Process__c WP11 : AllWP11s) {
                    if(WP11.Project__c == ProjectId && WP11.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        break;
                    }
                    else if(WP11.Project__c == ProjectId && (WP11.Work_Process_Status__c == 'Not Start' || WP11.Work_Process_Status__c == 'In Progress')) {
                        
                        if(completedWP == 10) {
                            lastCompletedWP = Integer.ValueOf(WP11.No__c);
                            SPW.ProjectNo = Integer.ValueOf(WP11.No__c);
                            SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                            SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP11.Id + '/view';
                            break;
                        }
                    }
                }
            }
        }
        
        if(AllWP12s.size() > 0) {
            for(Engineering_Standard__c WP12 : AllWP12s) {
                if(WP12.Project__c == ProjectId && WP12.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP12.Project__c == ProjectId && (WP12.Work_Process_Status__c == 'Not Start' || WP12.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 11 || completedWP == 9) {
                        lastCompletedWP = Integer.ValueOf(WP12.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP12.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP12.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(AllWP13s.size() > 0) {
            for(Deliverable_List__c WP13 : AllWP13s) {
                if(WP13.Project__c == ProjectId && WP13.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP13.Project__c == ProjectId && (WP13.Work_Process_Status__c == 'Not Start' || WP13.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 12) {
                        lastCompletedWP = Integer.ValueOf(WP13.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP13.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP13.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(AllWP14s.size() > 0) {
            for(Document_Distribution_Matrix__c WP14 : AllWP14s) {
                if(WP14.Project__c == ProjectId && WP14.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP14.Project__c == ProjectId && (WP14.Work_Process_Status__c == 'Not Start' || WP14.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 13) {
                        lastCompletedWP = Integer.ValueOf(WP14.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP14.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP14.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(AllWP15s.size() > 0) {
            for(Design_Safety_Standard__c WP15 : AllWP15s) {
                if(WP15.Project__c == ProjectId && WP15.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP15.Project__c == ProjectId && (WP15.Work_Process_Status__c == 'Not Start' || WP15.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 14) {
                        lastCompletedWP = Integer.ValueOf(WP15.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP15.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP15.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(AllWP16s.size() > 0) {
            for(Cost_Estimate__c WP16 : AllWP16s) {
                if(WP16.Project__c == ProjectId && WP16.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP16.Project__c == ProjectId && (WP16.Work_Process_Status__c == 'Not Start' || WP16.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 15) {
                        lastCompletedWP = Integer.ValueOf(WP16.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP16.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP16.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP17s.size() > 0) {
            for(Engineering_Data_Book_and_3D_Model__c WP17 : AllWP17s) {
                if(WP17.Project__c == ProjectId && WP17.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP17.Project__c == ProjectId && (WP17.Work_Process_Status__c == 'Not Start' || WP17.Work_Process_Status__c == 'In Progress')) {
                    if(completedWP == 16) {
                        lastCompletedWP = Integer.ValueOf(WP17.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP17.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP17.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(!IsDisable1819) {
        
            if(AllWP18s.size() > 0) {
                for(ITB_Standard_18__c WP18 : AllWP18s) {
                    if(WP18.Project__c == ProjectId && WP18.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        break;
                    }
                    else if(WP18.Project__c == ProjectId && (WP18.Work_Process_Status__c == 'Not Start' || WP18.Work_Process_Status__c == 'In Progress')) {
                        
                        if(completedWP == 17) {
                            lastCompletedWP = Integer.ValueOf(WP18.No__c);
                            SPW.ProjectNo = Integer.ValueOf(WP18.No__c);
                            SPW.CurrentStep = lastCompletedWP+ '. ITB Standard';
                            SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP18.Id + '/view';
                            break;
                        }
                    }
                }
            }
            
            if(AllWP19s.size() > 0) {
                for(CCE_Approval_Process_19__c WP19 : AllWP19s) {
                    if(WP19.Project__c == ProjectId && WP19.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        break;
                    }
                    else if(WP19.Project__c == ProjectId && (WP19.Work_Process_Status__c == 'Not Start' || WP19.Work_Process_Status__c == 'In Progress')) {
                        
                        if(completedWP == 18) {
                            lastCompletedWP = Integer.ValueOf(WP19.No__c);
                            SPW.ProjectNo = Integer.ValueOf(WP19.No__c);
                            SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                            SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP19.Id + '/view';
                            break;
                        }
                        
                    }
                }
            }
        }
        
        if(AllWP20s.size() > 0) {
            for(Project_Procurement_Contract_Mgmt__c WP20 : AllWP20s) {
                if(WP20.Project__c == ProjectId && WP20.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP20.Project__c == ProjectId && (WP20.Work_Process_Status__c == 'Not Start' || WP20.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 19 || completedWP == 17) {
                        lastCompletedWP = Integer.ValueOf(WP20.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP20.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP20.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP21s.size() > 0) {
            for(Vendor_Data_Management__c WP21 : AllWP21s) {
                if(WP21.Project__c == ProjectId && WP21.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP21.Project__c == ProjectId && (WP21.Work_Process_Status__c == 'Not Start' || WP21.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 20) {
                        lastCompletedWP = Integer.ValueOf(WP21.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP21.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP21.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP22s.size() > 0) {
            for(Material_Inspection_FAT_SAT__c WP22 : AllWP22s) {
                if(WP22.Project__c == ProjectId && WP22.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    
                    break;
                }
                else if(WP22.Project__c == ProjectId && (WP22.Work_Process_Status__c == 'Not Start' || WP22.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 21) {
                        lastCompletedWP = Integer.ValueOf(WP22.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP22.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP22.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP23s.size() > 0) {
            for(Surplus_Spar_part_Management__c WP23 : AllWP23s) {
                if(WP23.Project__c == ProjectId && WP23.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP23.Project__c == ProjectId && (WP23.Work_Process_Status__c == 'Not Start' || WP23.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 22) {
                        lastCompletedWP = Integer.ValueOf(WP23.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP23.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP23.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP24s.size() > 0) {
            for(Construction_Management__c WP24 : AllWP24s) {
                if(WP24.Project__c == ProjectId && WP24.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP24.Project__c == ProjectId && (WP24.Work_Process_Status__c == 'Not Start' || WP24.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 23) {
                        lastCompletedWP = Integer.ValueOf(WP24.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP24.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP24.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP25s.size() > 0) {
            for(Budget_Change_Control__c WP25 : AllWP25s) {
                if(WP25.Project__c == ProjectId && WP25.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP25.Project__c == ProjectId && (WP25.Work_Process_Status__c == 'Not Start' || WP25.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 24) {
                        lastCompletedWP = Integer.ValueOf(WP25.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP25.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP25.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP26s.size() > 0) {
            for(System_Test_Pack_Identification__c WP26 : AllWP26s) {
                if(WP26.Project__c == ProjectId && WP26.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP26.Project__c == ProjectId && (WP26.Work_Process_Status__c == 'Not Start' || WP26.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 25) {
                        lastCompletedWP = Integer.ValueOf(WP26.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP26.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP26.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP27s.size() > 0) {
            for(Punch_List_Management_System__c WP27 : AllWP27s) {
                if(WP27.Project__c == ProjectId && WP27.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP27.Project__c == ProjectId && (WP27.Work_Process_Status__c == 'Not Start' || WP27.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 26) {
                        lastCompletedWP = Integer.ValueOf(WP27.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP27.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP27.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP28s.size() > 0) {
            for(MC_RSFU__c WP28 : AllWP28s) {
                if(WP28.Project__c == ProjectId && WP28.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP28.Project__c == ProjectId && (WP28.Work_Process_Status__c == 'Not Start' || WP28.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 27) {
                        lastCompletedWP = Integer.ValueOf(WP28.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP28.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP28.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP29s.size() > 0) {
            for(MCA__c WP29 : AllWP29s) {
                if(WP29.Project__c == ProjectId && WP29.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP29.Project__c == ProjectId && (WP29.Work_Process_Status__c == 'Not Start' || WP29.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 28) {
                        lastCompletedWP = Integer.ValueOf(WP29.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP29.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP29.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP30s.size() > 0) {
            for(Close_Out_Report_Lesson_Learnt__c WP30 : AllWP30s) {
                if(WP30.Project__c == ProjectId && WP30.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP30.Project__c == ProjectId && (WP30.Work_Process_Status__c == 'Not Start' || WP30.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 29) {
                        lastCompletedWP = Integer.ValueOf(WP30.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP30.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP30.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP31s.size() > 0) {
            for(Close_Out_Database__c WP31 : AllWP31s) {
                if(WP31.Project__c == ProjectId && WP31.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP31.Project__c == ProjectId && (WP31.Work_Process_Status__c == 'Not Start' || WP31.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 30) {
                        lastCompletedWP = Integer.ValueOf(WP31.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP31.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP31.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP32s.size() > 0) {
            for(CR_Completion_Report__c WP32 : AllWP32s) {
                if(WP32.Project__c == ProjectId && WP32.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    SPW.ProjectNo = Integer.ValueOf(WP32.No__c);
                    SPW.CurrentStep = '32. CR Completion Report';
                    SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP32.Id + '/view';
                    break;
                }
                else if(WP32.Project__c == ProjectId && (WP32.Work_Process_Status__c == 'Not Start' || WP32.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 31) {
                        lastCompletedWP = Integer.ValueOf(WP32.No__c);
                        SPW.ProjectNo = Integer.ValueOf(WP32.No__c);
                        SPW.CurrentStep = lastCompletedWP + '. ' + GetWorkProcessName(lastCompletedWP);
                        SPW.CurrentStepUrl = BaseUrl + 'lightning/r/' + WP32.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        SPW.CompletedWorkProcess = completedWP;
        
        return SPW;
    }
    
    public void AllWPs() {
        
        //WP00
        AllWP00s = new List<Project_Risk_Assessment__c>();
        AllWP00s = [select id, Project__c, Work_Process_Status__c, No__c from Project_Risk_Assessment__c];
        
        //WP1
        AllWP1s = new List<Project_Charter__c>();
        AllWP1s = [select id, Project__c, Work_Process_Status__c, No__c from Project_Charter__c];
        
        //WP2
        AllWP2s = new List<Project_Organization__c>();
        AllWP2s = [select id, Project__c, Work_Process_Status__c, No__c from Project_Organization__c];
        
        //WP3
        AllWP3s = new List<Lesson_Learnt_Review__c>();
        AllWP3s = [select id, Project__c, Work_Process_Status__c, No__c from Lesson_Learnt_Review__c];
        
        //WP4
        AllWP4s = new List<Project_Execution_Plan__c>();
        AllWP4s = [select id, Project__c, Work_Process_Status__c, No__c, Service_Requisition__c from Project_Execution_Plan__c];
        
        //WP5
        AllWP5s = new List<Project_Procurement_Plan__c>();
        AllWP5s = [select id, Project__c, Work_Process_Status__c, No__c from Project_Procurement_Plan__c];
        
        //WP6
        AllWP6s = new List<WBS_CBS__c>();
        AllWP6s = [select id, Project__c, Work_Process_Status__c, No__c from WBS_CBS__c];
        
        //WP7
        AllWP7s = new List<Schedule__c>();
        AllWP7s = [select id, Project__c, Work_Process_Status__c, No__c from Schedule__c];
        
        //WP8
        AllWP8s = new List<Project_Status_Control__c>();
        AllWP8s = [select id, Project__c, Work_Process_Status__c, No__c from Project_Status_Control__c];
        
        //WP9
        AllWP9s = new List<Budget_Phasing__c>();
        AllWP9s = [select id, Project__c, Work_Process_Status__c, No__c from Budget_Phasing__c];
        
        //WP10
        AllWP10s = new List<ITB_Standard__c>();
        AllWP10s = [select id, Project__c, Work_Process_Status__c, No__c from ITB_Standard__c];
        
        //WP11
        AllWP11s = new List<CCE_Approval_Process__c>();
        AllWP11s = [select id, Project__c, Work_Process_Status__c, No__c from CCE_Approval_Process__c];
        
        //WP12
        AllWP12s = new List<Engineering_Standard__c>();
        AllWP12s = [select id, Project__c, Work_Process_Status__c, No__c from Engineering_Standard__c];
        
        //WP13
        AllWP13s = new List<Deliverable_List__c>();
        AllWP13s = [select id, Project__c, Work_Process_Status__c, No__c from Deliverable_List__c];
        
        //WP14
        AllWP14s = new List<Document_Distribution_Matrix__c>();
        AllWP14s = [select id, Project__c, Work_Process_Status__c, No__c from Document_Distribution_Matrix__c];
        
        //WP15
        AllWP15s = new List<Design_Safety_Standard__c>();
        AllWP15s = [select id, Project__c, Work_Process_Status__c, No__c from Design_Safety_Standard__c];
        
        //WP16
        AllWP16s = new List<Cost_Estimate__c>();
        AllWP16s = [select id, Project__c, Work_Process_Status__c, No__c from Cost_Estimate__c];
        
        //WP17
        AllWP17s = new List<Engineering_Data_Book_and_3D_Model__c>();
        AllWP17s = [select id, Project__c, Work_Process_Status__c, No__c from Engineering_Data_Book_and_3D_Model__c];
        
        //WP18
        AllWP18s = new List<ITB_Standard_18__c>();
        AllWP18s = [select id, Project__c, Work_Process_Status__c, No__c from ITB_Standard_18__c];
        
        //WP19
        AllWP19s = new List<CCE_Approval_Process_19__c>();
        AllWP19s = [select id, Project__c, Work_Process_Status__c, No__c from CCE_Approval_Process_19__c];
        
        //WP20
        AllWP20s = new List<Project_Procurement_Contract_Mgmt__c>();
        AllWP20s = [select id, Project__c, Work_Process_Status__c, No__c from Project_Procurement_Contract_Mgmt__c];
        
        //WP21
        AllWP21s = new List<Vendor_Data_Management__c>();
        AllWP21s = [select id, Project__c, Work_Process_Status__c, No__c from Vendor_Data_Management__c];
        
        //WP21
        AllWP21s = new List<Vendor_Data_Management__c>();
        AllWP21s = [select id, Project__c, Work_Process_Status__c, No__c from Vendor_Data_Management__c];
        
        //WP22
        AllWP22s = new List<Material_Inspection_FAT_SAT__c>();
        AllWP22s = [select id, Project__c, Work_Process_Status__c, No__c from Material_Inspection_FAT_SAT__c];
        
        //WP23
        AllWP23s = new List<Surplus_Spar_part_Management__c>();
        AllWP23s = [select id, Project__c, Work_Process_Status__c, No__c from Surplus_Spar_part_Management__c];
        
        //WP24
        AllWP24s = new List<Construction_Management__c>();
        AllWP24s = [select id, Project__c, Work_Process_Status__c, No__c from Construction_Management__c];
        
        //WP25
        AllWP25s = new List<Budget_Change_Control__c>();
        AllWP25s = [select id, Project__c, Work_Process_Status__c, No__c from Budget_Change_Control__c];
        
        //WP26
        AllWP26s = new List<System_Test_Pack_Identification__c>();
        AllWP26s = [select id, Project__c, Work_Process_Status__c, No__c from System_Test_Pack_Identification__c];
        
        //WP27
        AllWP27s = new List<Punch_List_Management_System__c>();
        AllWP27s = [select id, Project__c, Work_Process_Status__c, No__c from Punch_List_Management_System__c];
        
        //WP28
        AllWP28s = new List<MC_RSFU__c>();
        AllWP28s = [select id, Project__c, Work_Process_Status__c, No__c from MC_RSFU__c];
        
        //WP29
        AllWP29s = new List<MCA__c>();
        AllWP29s = [select id, Project__c, Work_Process_Status__c, No__c from MCA__c];
        
        //WP30
        AllWP30s = new List<Close_Out_Report_Lesson_Learnt__c>();
        AllWP30s = [select id, Project__c, Work_Process_Status__c, No__c from Close_Out_Report_Lesson_Learnt__c];
        
        //WP31
        AllWP31s = new List<Close_Out_Database__c>();
        AllWP31s = [select id, Project__c, Work_Process_Status__c, No__c from Close_Out_Database__c];
        
        //WP32
        AllWP32s = new List<CR_Completion_Report__c>();
        AllWP32s = [select id, Project__c, Work_Process_Status__c, No__c from CR_Completion_Report__c];
        
        
    }
    
    public void SearchProjectByYear() {
        
        YearNewProject = 0;
        YearCompletedProject = 0;
        
        List<Project__c> YearProjects = [select id, Status__c, CreatedDate from Project__c];
        
        if(YearProjects.size() > 0) {
            for(Project__c yearProject : YearProjects) {
                if(yearProject.CreatedDate.Year() == Integer.ValueOf(ChooseYear)) {
                    if(yearProject.Status__c == 'New' || yearProject.Status__c == 'Ongoing') {
                        YearNewProject = YearNewProject + 1;
                    }
                    else if(yearProject.Status__c == 'Completed') {
                        YearCompletedProject = YearCompletedProject + 1;
                    }
                }
            }
        }
        
    }
    
    public string GetWorkProcessName(Integer WPNo) {
        
        if(MDDetails.size() > 0) {
            
            for(Master_Data_Detail__c MDDetail : MDDetails) {
                
                if(MDDetail.Work_Process_No__c == WPNo) {
                    
                    return MDDetail.Name;
                    
                }    
            }
        }
        else {
            return null;
        }
        
        return null;
    }

    public string LanguageThai {
        get {
            return EncodingUtil.base64decode('77u/').toString();
        }
    }
}