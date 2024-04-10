/* Class for AssignUser VF Page */
public with sharing class AssignUserController {
    
    public CPEMController CPEM {get;set;}
    public Id UserId {get;set;}
    public string BaseUrl {get;set;}
    public Integer AUWrapperSize {get;set;}
    public List<AssignUserWrapper> AUWrappers {get;set;}
    
    public class AssignUserWrapper {
        public string ProjectNo {get;set;}
        public string ProjectName {get;set;}
        public string WorkProcessURL {get;set;}
        public Integer CurrentStepNo {get;set;}
        public string CurrentStep {get;set;}
    }
    
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
    
    public Id profileId {get;set;}
    public string profileName {get;set;}

    public AssignUserController() {
    
        UserId = UserInfo.getUserId();
        profileId = userinfo.getProfileId();
        profileName = [Select Id,Name from Profile where Id =: profileId].Name;
        
        BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        CPEM = new CPEMController();
        
        AUWrappers = new List<AssignUserWrapper>();
        FirstRecord = 1;
        PageRecords = 0;
        TotalRecords = 0;
        totalRecs = 0;
        OffsetSize = 0;
        LimitSize = 25;
        TotalPages = 0;
        TempNextPage = 0;
        TempTotalPage = 0;
        isNext = false;
        isPrev = false;
        AUWrapperSize = 0;
        
        System.debug('profileName : ' + profileName);
        
        AllWPs(UserId);
        
    } 
    
    public void AllWPs(Id UserId) {
        
            //WP00
            List<Project_Risk_Assessment__c> AllWP00s = new List<Project_Risk_Assessment__c>();
            AllWP00s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Project_Risk_Assessment__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP00s.size() > 0) {
                
                for(Project_Risk_Assessment__c WP : AllWP00s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP1
            List<Project_Charter__c> AllWP1s = new List<Project_Charter__c>();
            AllWP1s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Project_Charter__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP1s.size() > 0) {
                
                for(Project_Charter__c WP : AllWP1s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP2
            List<Project_Organization__c> AllWP2s = new List<Project_Organization__c>();
            AllWP2s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Project_Organization__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP2s.size() > 0) {
                
                for(Project_Organization__c WP : AllWP2s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP3
            List<Lesson_Learnt_Review__c> AllWP3s = new List<Lesson_Learnt_Review__c>();
            AllWP3s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Lesson_Learnt_Review__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP3s.size() > 0) {
                
                for(Lesson_Learnt_Review__c WP : AllWP3s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP4
            List<Project_Execution_Plan__c> AllWP4s = new List<Project_Execution_Plan__c>();
            AllWP4s = [select id, Project__c, Work_Process_Status__c, No__c, Service_Requisition__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Project_Execution_Plan__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP4s.size() > 0) {
                
                for(Project_Execution_Plan__c WP : AllWP4s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP5
            List<Project_Procurement_Plan__c> AllWP5s = new List<Project_Procurement_Plan__c>();
            AllWP5s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Project_Procurement_Plan__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP5s.size() > 0) {
                
                for(Project_Procurement_Plan__c WP : AllWP5s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP6
            List<WBS_CBS__c> AllWP6s = new List<WBS_CBS__c>();
            AllWP6s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from WBS_CBS__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP6s.size() > 0) {
                
                for(WBS_CBS__c WP : AllWP6s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP7
            List<Schedule__c> AllWP7s = new List<Schedule__c>();
            AllWP7s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Schedule__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP7s.size() > 0) {
                
                for(Schedule__c WP : AllWP7s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP8
            List<Project_Status_Control__c> AllWP8s = new List<Project_Status_Control__c>();
            AllWP8s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c,  Project__r.Project_Number__c, Project__r.Name from Project_Status_Control__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP8s.size() > 0) {
                
                for(Project_Status_Control__c WP : AllWP8s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP9
            List<Budget_Phasing__c> AllWP9s = new List<Budget_Phasing__c>();
            AllWP9s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Budget_Phasing__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP9s.size() > 0) {
                
                for(Budget_Phasing__c WP : AllWP9s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP10
            List<ITB_Standard__c> AllWP10s = new List<ITB_Standard__c>();
            AllWP10s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from ITB_Standard__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP10s.size() > 0) {
                
                for(ITB_Standard__c WP : AllWP10s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP11
            List<CCE_Approval_Process__c> AllWP11s = new List<CCE_Approval_Process__c>();
            AllWP11s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from CCE_Approval_Process__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP11s.size() > 0) {
                
                for(CCE_Approval_Process__c WP : AllWP11s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP12
            LIst<Engineering_Standard__c> AllWP12s = new List<Engineering_Standard__c>();
            AllWP12s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Engineering_Standard__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP12s.size() > 0) {
                
                for(Engineering_Standard__c WP : AllWP12s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP13
            List<Deliverable_List__c> AllWP13s = new List<Deliverable_List__c>();
            AllWP13s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Deliverable_List__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP13s.size() > 0) {
                
                for(Deliverable_List__c WP : AllWP13s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP14
            List<Document_Distribution_Matrix__c> AllWP14s = new List<Document_Distribution_Matrix__c>();
            AllWP14s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Document_Distribution_Matrix__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP14s.size() > 0) {
                
                for(Document_Distribution_Matrix__c WP : AllWP14s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP15
            List<Design_Safety_Standard__c> AllWP15s = new List<Design_Safety_Standard__c>();
            AllWP15s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Design_Safety_Standard__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP15s.size() > 0) {
                
                for(Design_Safety_Standard__c WP : AllWP15s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP16
            LIst<Cost_Estimate__c> AllWP16s = new List<Cost_Estimate__c>();
            AllWP16s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Cost_Estimate__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP16s.size() > 0) {
                
                for(Cost_Estimate__c WP : AllWP16s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP17
            List<Engineering_Data_Book_and_3D_Model__c> AllWP17s = new List<Engineering_Data_Book_and_3D_Model__c>();
            AllWP17s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Engineering_Data_Book_and_3D_Model__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP17s.size() > 0) {
                
                for(Engineering_Data_Book_and_3D_Model__c WP : AllWP17s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP18
            List<ITB_Standard_18__c> AllWP18s = new List<ITB_Standard_18__c>();
            AllWP18s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from ITB_Standard_18__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP18s.size() > 0) {
                
                for(ITB_Standard_18__c WP : AllWP18s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP19
            List<CCE_Approval_Process_19__c> AllWP19s = new List<CCE_Approval_Process_19__c>();
            AllWP19s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from CCE_Approval_Process_19__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP19s.size() > 0) {
                
                for(CCE_Approval_Process_19__c WP : AllWP19s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP20
            List<Project_Procurement_Contract_Mgmt__c> AllWP20s = new List<Project_Procurement_Contract_Mgmt__c>();
            AllWP20s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Project_Procurement_Contract_Mgmt__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP20s.size() > 0) {
                
                for(Project_Procurement_Contract_Mgmt__c WP : AllWP20s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP21
            LIst<Vendor_Data_Management__c> AllWP21s = new List<Vendor_Data_Management__c>();
            AllWP21s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Vendor_Data_Management__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP21s.size() > 0) {
                
                for(Vendor_Data_Management__c WP : AllWP21s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP22
            List<Material_Inspection_FAT_SAT__c> AllWP22s = new List<Material_Inspection_FAT_SAT__c>();
            AllWP22s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Material_Inspection_FAT_SAT__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP22s.size() > 0) {
                
                for(Material_Inspection_FAT_SAT__c WP : AllWP22s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP23
            List<Surplus_Spar_part_Management__c> AllWP23s = new List<Surplus_Spar_part_Management__c>();
            AllWP23s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Surplus_Spar_part_Management__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP23s.size() > 0) {
                
                for(Surplus_Spar_part_Management__c WP : AllWP23s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP24
            List<Construction_Management__c> AllWP24s = new List<Construction_Management__c>();
            AllWP24s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Construction_Management__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP24s.size() > 0) {
                
                for(Construction_Management__c WP : AllWP24s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP25
            List<Budget_Change_Control__c> AllWP25s = new List<Budget_Change_Control__c>();
            AllWP25s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Budget_Change_Control__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP25s.size() > 0) {
                
                for(Budget_Change_Control__c WP : AllWP25s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP26
            List<System_Test_Pack_Identification__c> AllWP26s = new List<System_Test_Pack_Identification__c>();
            AllWP26s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from System_Test_Pack_Identification__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP26s.size() > 0) {
                
                for(System_Test_Pack_Identification__c WP : AllWP26s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP27
            List<Punch_List_Management_System__c> AllWP27s = new List<Punch_List_Management_System__c>();
            AllWP27s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Punch_List_Management_System__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP27s.size() > 0) {
                
                for(Punch_List_Management_System__c WP : AllWP27s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP28
            List<MC_RSFU__c> AllWP28s = new List<MC_RSFU__c>();
            AllWP28s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from MC_RSFU__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP28s.size() > 0) {
                
                for(MC_RSFU__c WP : AllWP28s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP29
            List<MCA__c> AllWP29s = new List<MCA__c>();
            AllWP29s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from MCA__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP29s.size() > 0) {
                
                for(MCA__c WP : AllWP29s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP30
            List<Close_Out_Report_Lesson_Learnt__c> AllWP30s = new List<Close_Out_Report_Lesson_Learnt__c>();
            AllWP30s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Close_Out_Report_Lesson_Learnt__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP30s.size() > 0) {
                
                for(Close_Out_Report_Lesson_Learnt__c WP : AllWP30s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP31
            List<Close_Out_Database__c> AllWP31s = new List<Close_Out_Database__c>();
            AllWP31s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from Close_Out_Database__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP31s.size() > 0) {
                
                for(Close_Out_Database__c WP : AllWP31s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
            //WP32
            LIst<CR_Completion_Report__c> AllWP32s = new List<CR_Completion_Report__c>();
            AllWP32s = [select id, Project__c, Work_Process_Status__c, No__c, Assigned_User__c, Assigned_User__r.User__c, Project__r.Project_Number__c, Project__r.Name from CR_Completion_Report__c where Assigned_User__r.User__c =: UserId AND Project__c != null];
            
            if(AllWP32s.size() > 0) {
                
                for(CR_Completion_Report__c WP : AllWP32s) {
                    
                    AssignUserWrapper AU = new AssignUserWrapper();
                    AU.ProjectNo = WP.Project__r.Project_Number__c;
                    AU.ProjectName = WP.Project__r.Name;
                    AU.WorkProcessURL = BaseUrl + 'lightning/r/' + WP.Id + '/view';
                    AU.CurrentStepNo = Integer.ValueOf(WP.No__c);
                    AU.CurrentStep = WP.No__c + '. ' + CPEM.GetWorkProcessName(Integer.ValueOf(WP.No__c));
                    AUWrappers.add(AU);
                    
                }
                
            }
            
        
        
        AUWrapperSize = AUWrappers.size();
    }
    
    public void FirstPage(){        
        isPrev = true; 
        OffsetSize = 0;   
        
        if(Test.isRunningTest()){
            System.debug('No need to query in test class.');
        }
        else{
            AllWPs(UserId);  
        }
        
        FirstRecord = 1;
        PageRecords = LimitSize;       
        isPrev = false;   
    }
    
    public void previous(){       
        isPrev = true;
        OffsetSize = (OffsetSize-LimitSize);     
        
        if(Test.isRunningTest()){
            System.debug('No need to query in test class.');
        }
        else{
            AllWPs(UserId);  
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
        
        if(Test.isRunningTest()){
            System.debug('No need to query in test class.');
        }
        else{
            AllWPs(UserId);  
        }
        
        isNext = false;       
    }
    
    public void LastPage(){       
        isNext = true;
        OffsetSize = TotalRecords - math.mod(TotalRecords,LimitSize);        
        
        if(Test.isRunningTest()){
            System.debug('No need to query in test class.');
        }
        else{
            AllWPs(UserId);  
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