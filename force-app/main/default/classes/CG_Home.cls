public with sharing class CG_Home {
    
    private static CG_DTO.HomeMenuDTO homeDTO;
    private static void InitializeData() {
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        List<CG_Reporting__c> CGReports = [select id, name, status__c, type_of_report__c, user__c, generatefrombatch__c, ownerId from CG_Reporting__c];
        
        integer COICount = 0;
        integer CGCount = 0;
        integer GiftCount = 0;
        integer SupervisorCount = 0;
        integer GLVPCount = 0;
        integer GLGCCount = 0;
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.GenerateFromBatch__c == true && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) && CGReport.OwnerId == userId) {
                    
                    if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual) 
                                          || CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) ) {
                    
                        COICount += 1;  
                    }
                    else if(CGReport.GenerateFromBatch__c == true && CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual) 
                                              || CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual) 
                                              || CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) ) {
                        CGCount += 1;
                    }
                }
                else if(CGReport.GenerateFromBatch__c == true && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected) && CGReport.OwnerId == userId) {
                    if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual) 
                                          || CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) ) {
                    
                        COICount += 1;  
                    }
                    else if(CGReport.GenerateFromBatch__c == true && CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual) 
                                              || CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual) 
                                              || CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) ) {
                        CGCount += 1;
                    }
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor) && CGReport.User__c == userId &&
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual) ||
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident) ||
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) ||
                       (CGReport.Type_of_Report__c == 'GiftRegistration'))))) {
                    SupervisorCount += 1;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) &&
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual) ||
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident) ||
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) ||
                       (CGReport.Type_of_Report__c == 'GiftRegistration'))))) {
                    GLVPCount += 1;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC) &&
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual) ||
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident) ||
                       (CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) ||
                       (CGReport.Type_of_Report__c == 'GiftRegistration'))))) {
                    GLGCCount += 1;
                }
            }
        }
        
        homeDTO = new CG_DTO.HomeMenuDTO();
        string userProfile = CG_PrivilegeHandler.getUserProfile();
                                           
        homeDTO.coiReporting = true;
        homeDTO.coiReportingBadge = COICount;
        //homeDTO.cgManualList = true;
        homeDTO.cgManualReporting = true;
        homeDTO.cgManualReportingBadge = CGCount;
        //homeDTO.giftRegistrationList = true;        
        homeDTO.giftRegistrationReporting = true;
        homeDTO.giftRegistrationReportingBadge = GiftCount;
        homeDTO.cgReportHistory = true;

        if(userProfile == 'Approver') {
            homeDTO.supervisorMassAcknowledge = true;
            homeDTO.supervisorMassAcknowledgeBadge = SupervisorCount;
            homeDTO.glvpMassAcknowledge = true;
            homeDTO.glvpMassAcknowledgeBadge = GLVPCount;
        }
        else if(userProfile == 'GLVP') {
            homeDTO.supervisorMassAcknowledge = true;
            homeDTO.supervisorMassAcknowledgeBadge = SupervisorCount;
            homeDTO.glvpMassAcknowledge = true;
            homeDTO.glvpMassAcknowledgeBadge = GLVPCount;
        }
        else if(userProfile == 'Supervisor') {
            homeDTO.glvpMassAcknowledge = false;
            homeDTO.glvpMassAcknowledgeBadge = 0;
            homeDTO.supervisorMassAcknowledge = true;
            homeDTO.supervisorMassAcknowledgeBadge = SupervisorCount;
        }
        else if(userProfile == 'GLGC') {
            homeDTO.glgcAdminMassAcknowledge = true;
            homeDTO.glgcAdminMassAcknowledgeBadge = GLGCCount;
            homeDTO.coiList = true;
            homeDTO.cgManualList = true;
            homeDTO.giftRegistrationList = true;
            homeDTO.report = true;
            homeDTO.reportSetting = true;
        }
        else if(userProfile == 'Admin') {
            homeDTO.glgcAdminMassAcknowledge = true;
            homeDTO.glgcAdminMassAcknowledgeBadge = GLGCCount;
            homeDTO.report = true;
            homeDTO.reportSetting = true;
            homeDTO.coiList = true;
            homeDTO.cgManualList = true;
            homeDTO.giftRegistrationList = true;
        }
        else if(userProfile == 'SuperAdmin') {
            homeDTO.supervisorMassAcknowledge = true;
            homeDTO.supervisorMassAcknowledgeBadge = SupervisorCount;
            homeDTO.glvpMassAcknowledge = true;
            homeDTO.glvpMassAcknowledgeBadge = GLVPCount;
            homeDTO.glgcAdminMassAcknowledge = true;
            homeDTO.glgcAdminMassAcknowledgeBadge = GLGCCount;
            homeDTO.report = true;
            homeDTO.reportSetting = true;
            homeDTO.coiList = true;
            homeDTO.cgManualList = true;
            homeDTO.giftRegistrationList = true;
        }
        system.debug('userProfile : ' + userProfile);
    }
    
    static {
        CG_Home.InitializeData();
    }
    
    @RemoteAction
    public static CG_DTO.HomeMenuDTO GetHomeMenu(){
        return homeDTO;
    }
    
    public static integer COIReport(string reportType, List<CG_Reporting__c> CGReports) {
        integer reportCount = 0;
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                    if(reportType == 'COI' && (CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)
                                          || CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)
                                          || CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee))) {
                    
                        reportCount += 1;                          
                    }
                    else if(reportType == 'CG' && (CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)
                                              || CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)
                                              || CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee))) {
                        
                        reportCount += 1;
                    }
                    else if(reportType == 'GiftRegistration' && CGReport.Type_Of_Report__c == 'GiftRegistration') {
                        
                    	reportCount += 1;
                    }
                }
                
            }
        }
        
        return reportCount;
    }

    
}