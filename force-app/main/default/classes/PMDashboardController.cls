/* Class for PMDashboard */
public with sharing class PMDashboardController {

    public CPEMController CPEM {get;set;}
    public string searchProject {get;set;}
    public string baseUrl {get;set;}
    
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
   
    public List<ProjectWrapper> PWs {get;set;}
    
    public integer FirstRecord {get;set;}
    public integer PageRecords {get;set;}
    public integer TotalRecords {get;set;}
    public integer totalRecs { get;set; } 
    public integer OffsetSize { get;set; } 
    public integer LimitSize { get;set; } 
    public integer TotalPages {get;set;}
    public integer TempNextPage {get;set;}
    public integer TempTotalPage {get;set;}
    public boolean isNext {get;set;}
    public boolean isPrev {get;set;}
    public boolean sortByProjectNoDesc {get;set;}
    public boolean sortByProjectNameDesc {get;set;}
    public boolean sortByProjectStatusDesc {get;set;}
    public boolean sortByProjectCompletedDesc {get;set;}
    public boolean sortByProjectStepDesc {get;set;}

    public static string PROJECTNO_SORT = 'ProjectNo';
    public static string SORT_BY = PROJECTNO_SORT;
    public static string PROJECTNAME_SORT = 'ProjectName';
    public static string PROJECTSTATUS_SORT = 'ProjectStatus';
    public static string COMPLETED_SORT = 'CompletedWorkProcess';
    public static string STEP_SORT = 'CurrentStep';
    
    public static string PROJECTNO_SORT_DESC = 'ProjectNoDesc';
    public static string PROJECTNAME_SORT_DESC = 'ProjectNameDec';
    public static string PROJECTSTATUS_SORT_DESC = 'ProjectStatusDesc';
    public static string COMPLETED_SORT_DESC = 'CompletedWorkProcessDesc';
    public static string STEP_SORT_DESC = 'CurrentStepDesc';
    
    public class ProjectWrapper implements Comparable {
        public string ProjectNo {get;set;}
        public string ProjectName {get;set;}
        public string ProjectStatus {get;set;}
        public integer CompletedWorkProcess {get;set;}
        public string ProjectUrl {get;set;}
        public Integer CurrentStepNo {get;set;}
        public string CurrentStep {get;set;}
        public string CurrentStepUrl {get;set;}
        public string RoadmapUrl {get;set;}
        public string GroupUrl {get;set;}
        public ProjectDetailWrapper PDWrapper {get;set;}
        public boolean IsDisable1011 {get;set;}
        public boolean IsDisable1819 {get;set;}
        
        public ProjectWrapper() { }
        
        public ProjectWrapper(string ProjectNo, string ProjectName, string ProjectStatus, integer Completed, integer CurrentStepNo) {
            this.ProjectNo = ProjectNo;
            this.ProjectName = ProjectName;
            this.ProjectStatus = ProjectStatus;
            this.CompletedWorkProcess = Completed;
            this.CurrentStepNo = CurrentStepNo;
        }
        
        public Integer sortByProjectNo(ProjectWrapper project) {
            if (this.ProjectNo > project.ProjectNo) {
                return 1;
            }

            if (this.ProjectNo == project.ProjectNo) {
                return 0;
            }

            return -1;
        }
        public Integer sortByProjectNoDesc(ProjectWrapper project) {
            if (this.ProjectNo < project.ProjectNo) {
                return 1;
            }

            if (this.ProjectNo == project.ProjectNo) {
                return 0;
            }

            return -1;
        }
        
        public Integer sortByProjectName(ProjectWrapper project) {
            if (this.ProjectName > project.ProjectName) {
                return 1;
            }

            if (this.ProjectName == project.ProjectName) {
                return 0;
            }

            return -1;
            
        }
        public Integer sortByProjectNameDesc(ProjectWrapper project) {
            if (this.ProjectName < project.ProjectName) {
                return 1;
            }

            if (this.ProjectName == project.ProjectName) {
                return 0;
            }

            return -1;
            
        }
        
        public Integer sortByStatus(ProjectWrapper project) {
            if (this.ProjectStatus > project.ProjectStatus) {
                return 1;
            }

            if (this.ProjectStatus == project.ProjectStatus) {
                return 0;
            }

            return -1;
        }
        public Integer sortByStatusDesc(ProjectWrapper project) {
            if (this.ProjectStatus < project.ProjectStatus) {
                return 1;
            }

            if (this.ProjectStatus == project.ProjectStatus) {
                return 0;
            }

            return -1;
        }
        
        public Integer sortByCompleted(ProjectWrapper project) {
            if (this.CompletedWorkProcess > project.CompletedWorkProcess) {
                return 1;
            }

            if (this.CompletedWorkProcess == project.CompletedWorkProcess) {
                return 0;
            }

            return -1;
        }
        public Integer sortByCompletedDesc(ProjectWrapper project) {
            if (this.CompletedWorkProcess < project.CompletedWorkProcess) {
                return 1;
            }

            if (this.CompletedWorkProcess == project.CompletedWorkProcess) {
                return 0;
            }

            return -1;
        }
        
        public Integer sortByStep(ProjectWrapper project) {
            if (this.CurrentStepNo > project.CurrentStepNo) {
                return 1;
            }

            if (this.CurrentStepNo == project.CurrentStepNo) {
                return 0;
            }

            return -1;
        }
        public Integer sortByStepDesc(ProjectWrapper project) {
            if (this.CurrentStepNo < project.CurrentStepNo) {
                return 1;
            }

            if (this.CurrentStepNo == project.CurrentStepNo) {
                return 0;
            }

            return -1;
        }
        
        public Integer compareTo(Object obj) {
            ProjectWrapper PW = (ProjectWrapper)(obj);

            if (SORT_BY == PROJECTNO_SORT) {
                return sortByProjectNo(PW);
            }
            else if (SORT_BY == PROJECTNAME_SORT) {
                return sortByProjectName(PW);
            }
            else if (SORT_BY == PROJECTSTATUS_SORT) {
                return sortByStatus(PW);
            }
            else if (SORT_BY == COMPLETED_SORT) {
                return sortByCompleted(PW);
            }
            else if (SORT_BY == STEP_SORT) {
                return sortByStep(PW);
            }
            else if (SORT_BY == PROJECTNO_SORT_DESC) {
                return sortByProjectNoDesc(PW);
            }
            else if (SORT_BY == PROJECTNAME_SORT_DESC) {
                return sortByProjectNameDesc(PW);
            }
            else if (SORT_BY == PROJECTSTATUS_SORT_DESC) {
                return sortByStatusDesc(PW);
            }
            else if (SORT_BY == COMPLETED_SORT_DESC) {
                return sortByCompletedDesc(PW);
            }
            else if (SORT_BY == STEP_SORT_DESC) {
                return sortByStepDesc(PW);
            }

            // If we don't have a know sort by, let's just return that they are all equal
            return 0;
        }
    }
    
    public class ProjectDetailWrapper {
        public integer CompletedWorkProcess {get;set;}
        public integer CurrentStepNo {get;set;}
        public string CurrentStep {get;set;}
        public string CurrentStepUrl {get;set;}
        public boolean IsDisable1011 {get;set;}
        public boolean IsDisable1819 {get;set;}
    }

    public PMDashboardController() {
    
        FirstRecord = 1;
        PageRecords = 0;
        TotalRecords = 0;
        totalRecs = 0;
        OffsetSize = 0;
        LimitSize = 10;
        TotalPages = 0;
        TempNextPage = 0;
        TempTotalPage = 0;
        searchProject = '';
        isNext = false;
        isPrev = false;
        
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectCompletedDesc = false;
        sortByProjectStepDesc = false;
        
        //ProjectId = ApexPages.currentPage().getParameters().get('ProjectId');
        
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        //Load All Project
        ShowAllProject();
    }
    
    public void ShowAllProject() {
        
        Id UserId = UserInfo.getUserId();
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id =: profileId].Name;
        
        List<Project__c> Projects = new List<Project__c>();
        List<Project__c> TotalProjects = new List<Project__c>();
        
        CPEM = new CPEMController();
        
        string searchProj = '%'+ searchProject + '%';
        
        if(profileName == 'PM') {
        
            if(searchProject == '') {
            
                if(!isNext && !isPrev) {
                    FirstRecord = 1;
                    PageRecords = 0;
                    TotalRecords = 0;
                    totalRecs = 0;
                    OffsetSize = 0;
                    LimitSize = 10;
                    TotalPages = 0;
                    TempNextPage = 0;
                    TempTotalPage = 0;
                }
        
                TotalProjects = [select id, name, Project_Number__c, Status__c from Project__c where Project_Manager__c =: UserId AND (Status__c = 'New' OR Status__c = 'Ongoing')];
                TotalRecords = TotalProjects.size();   
                
                Projects = [select id, name, Project_Number__c, Status__c from Project__c where (Project_Manager__c =: UserId AND (Status__c = 'New' OR Status__c = 'Ongoing')) order by CreatedDate desc LIMIT :LimitSize OFFSET :OffsetSize ];
                PageRecords += Projects.size();
                totalRecs = Projects.size();
            }
            else if(searchProject != '') {
                
                if(!isNext && !isPrev) {
                    PageRecords = 0;
                }
            
                TotalProjects = [select id, name, Project_Number__c, Status__c from Project__c where (Project_Manager__c =: UserId AND (Name LIKE :searchProj OR Project_Number__c LIKE :searchProj) AND (Status__c = 'New' OR Status__c = 'Ongoing'))];
                TotalRecords = TotalProjects.size();   
                
                Projects = [select id, name, Project_Number__c, Status__c from Project__c where (Project_Manager__c =: UserId AND (Name LIKE :searchProj OR Project_Number__c LIKE :searchProj) AND (Status__c = 'New' OR Status__c = 'Ongoing')) order by CreatedDate desc LIMIT :LimitSize OFFSET :OffsetSize];
                
                PageRecords += Projects.size();
                totalRecs = Projects.size();
            }
        
        }
        else {
        
            if(searchProject == '') {
            
                if(!isNext && !isPrev) {
                    FirstRecord = 1;
                    PageRecords = 0;
                    TotalRecords = 0;
                    totalRecs = 0;
                    OffsetSize = 0;
                    LimitSize = 10;
                    TotalPages = 0;
                    TempNextPage = 0;
                    TempTotalPage = 0;
                }
        
                TotalProjects = [select id, name, Project_Number__c, Status__c from Project__c where (Status__c = 'New' OR Status__c = 'Ongoing')];
                TotalRecords = TotalProjects.size();   
                
                Projects = [select id, name, Project_Number__c, Status__c from Project__c where (Status__c = 'New' OR Status__c = 'Ongoing') order by CreatedDate desc LIMIT :LimitSize OFFSET :OffsetSize];
                PageRecords += Projects.size();
                totalRecs = Projects.size();
            }
            else if(searchProject != '') {
                
                if(!isNext && !isPrev) {
                    PageRecords = 0;
                }
                
                TotalProjects = [select id, name, Project_Number__c, Status__c from Project__c where ((Name LIKE :searchProj OR Project_Number__c LIKE :searchProj) AND (Status__c = 'New' OR Status__c = 'Ongoing'))];
                TotalRecords = TotalProjects.size();   
            
                Projects = [select id, name, Project_Number__c, Status__c from Project__c where ((Name LIKE :searchProj OR Project_Number__c LIKE :searchProj) AND (Status__c = 'New' OR Status__c = 'Ongoing')) order by CreatedDate desc LIMIT :LimitSize OFFSET :OffsetSize];
                PageRecords += Projects.size();
                totalRecs = Projects.size();
            }
            
        }
        
        
        if(Projects.size() > 0) {
        
            //Query all Work Processes
            AllWPs();
            
            PWs = new List<ProjectWrapper>();
            
            for(Project__c Project : Projects) {
                
                ProjectWrapper PW = new ProjectWrapper();
                PW.ProjectNo = Project.Project_Number__c;
                PW.ProjectName = Project.Name;
                PW.ProjectStatus = Project.Status__c;
                PW.RoadmapUrl = baseUrl + 'apex/ProjectRoadmap_VFPage?ProjectId=' + Project.Id;
                PW.GroupUrl = baseUrl + 'apex/WorkProcessGroup_VFPage?ProjectId=' + Project.Id;
                
                ProjectDetailWrapper PWD = new ProjectDetailWrapper();
                PWD = FindCompletedWorkProcess(Project.Id);
                PW.IsDisable1011 = PWD.IsDisable1011;
                PW.IsDisable1819 = PWD.IsDisable1819;
                
                PW.CompletedWorkProcess = PWD.CompletedWorkProcess;
                
                Project_Charter__c S1 = [select id, Project__c, No__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Project.Id];
                //PW.ProjectUrl = baseUrl + 'lightning/r/' + Project.Id + '/view';
                PW.ProjectUrl = baseUrl + 'lightning/r/' + S1.Id + '/view';
                
                if(Project.Status__c == 'New' && PW.CompletedWorkProcess == 00) {
                    PW.CurrentStep = '1. ' + CPEM.GetWorkProcessName(1); //'1. Project Charter';
                    PW.CurrentStepUrl = baseUrl + 'lightning/r/' + S1.Id + '/view';
                    PW.CurrentStepNo = 1;
                }
                else {
                    PW.CurrentStepNo = PWD.CurrentStepNo;
                    PW.CurrentStep = PWD.CurrentStep;
                    PW.CurrentStepUrl = PWD.CurrentStepUrl;
                }
                
                PWs.add(PW);
                
            }
        }
    }
    
    public void SearchProject() {
       
        Id UserId = UserInfo.getUserId();
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id =: profileId].Name;
        
        string enteredProject = '%'+ searchProject + '%';
        
        List<Project__c> Projects = new List<Project__c>();
        List<Project__c> TotalProjects = new List<Project__c>();
       
        if(profileName == 'PM') {
            TotalProjects = [select id, name, Project_Number__c, Status__c from Project__c where Project_Manager__c =: UserId AND (Name like: enteredProject OR Project_Number__c like: enteredProject) AND (Status__c = 'New' OR Status__c = 'Ongoing')];
            TotalRecords = TotalProjects.size();   
            
            Projects = [select id, name, Project_Number__c, Status__c from Project__c where Project_Manager__c =: UserId AND (Name like: enteredProject OR Project_Number__c like: enteredProject) AND (Status__c = 'New' OR Status__c = 'Ongoing') order by CreatedDate desc LIMIT :LimitSize OFFSET :OffsetSize];
            PageRecords += Projects.size();
            totalRecs = Projects.size();
        }
        else {
            TotalProjects = [select id, name, Project_Number__c, Status__c from Project__c where (Name like: enteredProject OR Project_Number__c like: enteredProject) AND (Status__c = 'New' OR Status__c = 'Ongoing')];
            TotalRecords = TotalProjects.size();   
            
            Projects = [select id, name, Project_Number__c, Status__c from Project__c where (Name like: enteredProject OR Project_Number__c like: enteredProject) AND (Status__c = 'New' OR Status__c = 'Ongoing') order by CreatedDate desc LIMIT :LimitSize OFFSET :OffsetSize];
            PageRecords += Projects.size();
            totalRecs = Projects.size();
        }
       
        PWs = new List<ProjectWrapper>();
        
        if(Projects.size() > 0) {
        
            for(Project__c Project : Projects) {
                
                ProjectWrapper PW = new ProjectWrapper();
                PW.ProjectNo = Project.Project_Number__c;
                PW.ProjectName = Project.Name;
                PW.ProjectStatus = Project.Status__c;
                PW.RoadmapUrl = baseUrl + 'apex/ProjectRoadmap_VFPage?ProjectId=' + Project.Id;
                PW.GroupUrl = baseUrl + 'apex/WorkProcessGroup_VFPage?ProjectId=' + Project.Id;
                
                ProjectDetailWrapper PWD = new ProjectDetailWrapper();
                PWD = FindCompletedWorkProcess(Project.Id);
                PW.CompletedWorkProcess = PWD.CompletedWorkProcess;
                
                if(AllWP1s.size() > 0) {
                    for(Project_Charter__c WP1 : AllWP1s) {
                        if(WP1.Project__c == Project.Id) {
                            
                            PW.ProjectUrl = baseUrl + 'lightning/r/' + WP1.Id + '/view';
                
                            if(Project.Status__c == 'New') {
                                PW.CurrentStep = '1. Project Charter';
                                PW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP1.Id + '/view';
                            }
                            PWs.add(PW);
                            break;
                        }
                    }
                }
                
                /* Project_Charter__c S1 = [select id, Project__c, No__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Project.Id];
                PW.ProjectUrl = baseUrl + 'lightning/r/' + S1.Id + '/view';
                
                if(Project.Status__c == 'New') {
                    PW.CurrentStep = '1. Project Charter';
                    PW.CurrentStepUrl = baseUrl + 'lightning/r/' + S1.Id + '/view';
                }
                PWs.add(PW); */
                
            }
            
        }
        
    }

    public ProjectDetailWrapper FindCompletedWorkProcess(string ProjectId) {
        
        integer completedWP = 0;
        integer lastCompletedWP = 0;
        
        ProjectDetailWrapper PDW = new ProjectDetailWrapper();
        PDW.IsDisable1011 = false;
        PDW.IsDisable1819 = false;
        
        if(AllWP1s.size() > 0) {
            for(Project_Charter__c WP1 : AllWP1s) {  
                if(WP1.Project__c == ProjectId && WP1.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
                else if(WP1.Project__c == ProjectId && (WP1.Work_Process_Status__c == 'Not Start' || WP1.Work_Process_Status__c == 'In Progress')) {
                    lastCompletedWP = Integer.ValueOf(WP1.No__c);
                    PDW.CurrentStepNo = lastCompletedWP;
                    PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                    PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP1.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP2.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP3.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP4s.size() > 0) {
            for(Project_Execution_Plan__c WP4 : AllWP4s) {
            
                if(WP4.Project__c == ProjectId) {
                    if(WP4.Service_Requisition__c == 'EP (Owner)') {
                        PDW.IsDisable1011 = true;
                        PDW.IsDisable1819 = false;
                    }
                    else if(WP4.Service_Requisition__c == 'EPC') {
                        PDW.IsDisable1819 = true;
                        PDW.IsDisable1011 = false;
                    }
                    else {
                        PDW.IsDisable1011 = false;
                        PDW.IsDisable1819 = false;
                    }
                    
                    if(WP4.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        break;
                    }
                    else if(WP4.Work_Process_Status__c == 'Not Start' || WP4.Work_Process_Status__c == 'In Progress') {
                        if(completedWP == 3) {
                            lastCompletedWP = Integer.ValueOf(WP4.No__c);
                            PDW.CurrentStepNo = lastCompletedWP;
                            PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                            PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP4.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP5.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP6.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP7.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP8.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP9.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(!PDW.IsDisable1011) {
        
            if(AllWP10s.size() > 0) {
                for(ITB_Standard__c WP10 : AllWP10s) {
                    if(WP10.Project__c == ProjectId && WP10.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        break;
                    }
                    else if(WP10.Project__c == ProjectId && (WP10.Work_Process_Status__c == 'Not Start' || WP10.Work_Process_Status__c == 'In Progress')) {
                        
                        if(completedWP == 9) {
                            lastCompletedWP = Integer.ValueOf(WP10.No__c);
                            PDW.CurrentStepNo = lastCompletedWP;
                            PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                            PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP10.Id + '/view';
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
                            PDW.CurrentStepNo = lastCompletedWP;
                            PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                            PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP11.Id + '/view';
                            break;
                        }
                    }
                }
            }
        }
        else if(completedWP == 9) {
            completedWP = 11;
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP12.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP13.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP14.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP15.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP16.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP17.Id + '/view';
                        break;
                    }
                }
            }
        }
        
        if(!PDW.IsDisable1819) {
        
            if(AllWP18s.size() > 0) {
                for(ITB_Standard_18__c WP18 : AllWP18s) {
                    if(WP18.Project__c == ProjectId && WP18.Work_Process_Status__c == 'Completed') {
                        completedWP++;
                        break;
                    }
                    else if(WP18.Project__c == ProjectId && (WP18.Work_Process_Status__c == 'Not Start' || WP18.Work_Process_Status__c == 'In Progress')) {
                        
                        if(completedWP == 17) {
                            lastCompletedWP = Integer.ValueOf(WP18.No__c);
                            PDW.CurrentStepNo = lastCompletedWP;
                            PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                            PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP18.Id + '/view';
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
                            PDW.CurrentStepNo = lastCompletedWP;
                            PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                            PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP19.Id + '/view';
                            break;
                        }
                        
                    }
                }
            }
        }
        else if(completedWP == 17) {
            completedWP = 19;
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP20.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP21.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP22.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP23.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP24.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP25.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP26.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP27.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP28.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP29.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP30.Id + '/view';
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
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP31.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        if(AllWP32s.size() > 0) {
            for(CR_Completion_Report__c WP32 : AllWP32s) {
                if(WP32.Project__c == ProjectId && WP32.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    PDW.CurrentStepNo = 32;
                    PDW.CurrentStep = '32. ' + CPEM.GetWorkProcessName(PDW.CurrentStepNo);
                    PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP32.Id + '/view';
                    
                    break;
                }
                else if(WP32.Project__c == ProjectId && (WP32.Work_Process_Status__c == 'Not Start' || WP32.Work_Process_Status__c == 'In Progress')) {
                    
                    if(completedWP == 31) {
                        lastCompletedWP = Integer.ValueOf(WP32.No__c);
                        PDW.CurrentStepNo = lastCompletedWP;
                        PDW.CurrentStep = lastCompletedWP + '. ' + CPEM.GetWorkProcessName(lastCompletedWP);
                        PDW.CurrentStepUrl = baseUrl + 'lightning/r/' + WP32.Id + '/view';
                        break;
                    }
                    
                }
            }
        }
        
        /* if(AllWP00s.size() > 0) {
            for(Project_Risk_Assessment__c WP00 : AllWP00s) {
                if(WP00.Project__c == ProjectId && WP00.Work_Process_Status__c == 'Completed') {
                    completedWP++;
                    break;
                }
            }
        } */
        
        PDW.CompletedWorkProcess = completedWP;
        
        return PDW;
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
    
    public void sortByProjectNo() {
    
        PMDashboardController.SORT_BY = PMDashboardController.PROJECTNO_SORT;
        this.PWs.sort();
        
        sortByProjectNoDesc = true;
        sortByProjectNameDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectCompletedDesc = false;
        sortByProjectStepDesc = false;
    }
    public void sortByDescProjectNo() {
    
        PMDashboardController.SORT_BY = PMDashboardController.PROJECTNO_SORT_DESC;
        this.PWs.sort();
        
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectCompletedDesc = false;
        sortByProjectStepDesc = false;
        
    }
    
    public void sortByProjectName() {
    
        PMDashboardController.SORT_BY = PMDashboardController.PROJECTNAME_SORT;
        this.PWs.sort();
        
        sortByProjectNameDesc = true;
        sortByProjectNoDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectCompletedDesc = false;
        sortByProjectStepDesc = false;
        
    }
    public void sortByDescProjectName() {
    
        PMDashboardController.SORT_BY = PMDashboardController.PROJECTNAME_SORT_DESC;
        this.PWs.sort();
        
        sortByProjectNameDesc = false;
        sortByProjectNoDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectCompletedDesc = false;
        sortByProjectStepDesc = false;
        
    }
    
    public void sortByProjectStatus() {
    
        PMDashboardController.SORT_BY = PMDashboardController.PROJECTSTATUS_SORT;
        this.PWs.sort();
        
        sortByProjectStatusDesc = true;
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectCompletedDesc = false;
        sortByProjectStepDesc = false;
        
    }
    public void sortByDescProjectStatus() {
    
        PMDashboardController.SORT_BY = PMDashboardController.PROJECTSTATUS_SORT_DESC;
        this.PWs.sort();
        
        sortByProjectStatusDesc = false;
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectCompletedDesc = false;
        sortByProjectStepDesc = false;
        
    }
    
    public void sortByCompleted() {
    
        PMDashboardController.SORT_BY = PMDashboardController.COMPLETED_SORT;
        this.PWs.sort();
        
        sortByProjectCompletedDesc = true;
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectStepDesc = false;
        
    }
    public void sortByDescCompleted() {
    
        PMDashboardController.SORT_BY = PMDashboardController.COMPLETED_SORT_DESC;
        this.PWs.sort();
        
        sortByProjectCompletedDesc = false;
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectStepDesc = false;
        
    }
    
    public void sortByCurrentStep() {
    
        PMDashboardController.SORT_BY = PMDashboardController.STEP_SORT;
        this.PWs.sort();
        
        sortByProjectStepDesc = true;
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectCompletedDesc = false;
        
    }
    public void sortByDescCurrentStep() {
    
        PMDashboardController.SORT_BY = PMDashboardController.STEP_SORT_DESC;
        this.PWs.sort();
        
        sortByProjectStepDesc = false;
        sortByProjectNoDesc = false;
        sortByProjectNameDesc = false;
        sortByProjectStatusDesc = false;
        sortByProjectCompletedDesc = false;
        
    }
    
    public void FirstPage(){        
        isPrev = true; 
        OffsetSize = 0;        
        
        if(Test.isRunningTest()) {
            System.debug('Running Test');
        }
        else {
            ShowAllProject();  
        }
        
        FirstRecord = 1;
        PageRecords = LimitSize;       
        isPrev = false;   
    }
    
    public void previous(){       
        isPrev = true;
        OffsetSize = (OffsetSize-LimitSize);  
        
        if(Test.isRunningTest()) {
            System.debug('Running Test');
        }
        else {
            ShowAllProject();  
        }     
        
        FirstRecord = FirstRecord - totalRecs;   
        
        PageRecords = TempNextPage;
        TempNextPage = OffsetSize;    
        isPrev = false;   
    }
    
    public void next(){    
        isNext = true;
        TempNextPage = PageRecords;       
        OffsetSize = OffsetSize + LimitSize;  
        FirstRecord += totalRecs; 
        
        if(Test.isRunningTest()) {
            System.debug('Running Test');
        }
        else {
            ShowAllProject();  
        }
        
        isNext = false;       
    }
    
    public void LastPage(){       
        isNext = true;
        OffsetSize = TotalRecords - math.mod(TotalRecords,LimitSize);        
        
        if(Test.isRunningTest()) {
            System.debug('Running Test');
        }
        else {
            ShowAllProject();  
        }
        
        FirstRecord = OffsetSize + 1;
        PageRecords = TotalRecords;    
        isNext = false;
    }
    
    public boolean getprev(){        
        if(OffsetSize == 0){         
            return true;          
        }        
        else {      
            return false;         
        }        
    }
    
    public boolean getnxt(){        
        if((OffsetSize + LimitSize) > TotalRecords){            
            return true;           
        }        
        else { 
            return false;            
        }        
    } 
    
    public string LanguageThai {
        get {
            return EncodingUtil.base64decode('77u/').toString();
        }
    }
    

}