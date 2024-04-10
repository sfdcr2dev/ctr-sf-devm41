/* 
 * Author Softever
*/

public with sharing class CG_ReportingHandler {

    //Check CG Setting Duration
    public static boolean CGSettingDuration(string settingName) {
        
        boolean isInDuration = false;        
        datetime todayDT = system.datetime.now();
        
        CG_Setting__c CGSetting = [select id, start_date__c, end_date__c, duration_json__c, type__c, recordtype.name from CG_Setting__c where recordtype.name =: settingName];
        
        if(CGSetting.RecordType.Name == 'Resend Annual' || CGSetting.RecordType.Name == 'COI Mass') {
            List<CG_Setting_Items__c> CGSettingItems = [select id, CG_Setting__c, Start_Date__c from CG_Setting_Items__c where CG_Setting__c =: CGSetting.Id order by start_date__c asc];
            
            if(CGSettingItems.size() > 0) {
                for(CG_Setting_Items__c CGSettingItem : CGSettingItems) {
                    if(todayDT >= CGSettingItem.Start_Date__c) {
                        isInDuration = true;
                    }
                }
            }
            
        }
        else {
            if(todayDT >= CGSetting.Start_Date__c) {
                isInDuration = true;
            }
        }
        
        //Check whether it has been generated or not
        if(!string.isBlank(CGSetting.Duration_JSON__c)) {
        	boolean isGenerated = CG_ReportingHandler.CheckDurationJson(CGSetting.Duration_JSON__c, datetime.now());
            
            if(isGenerated) {
                isInDuration = false;
            }
             
        }
        
        return isInDuration;
    }
    
    //Get CG Setting current duration
    public static void CGSettingSaveDuration(string settingName) {
        
        List<CG_DTO.DurationDTO> DurationDTOs = new List<CG_DTO.DurationDTO>();
        CG_DTO.DurationDTO DurationDTO = new CG_DTO.DurationDTO();
        
        CG_Setting__c CGSetting = [select id, start_date__c, end_date__c, Duration_JSON__c,recordtype.name from CG_Setting__c where recordtype.name =: settingName];
        
        if(CGSetting.RecordType.Name == 'Resend Annual' || CGSetting.RecordType.Name == 'COI Mass') {
            List<CG_Setting_Items__c> CGSettingItems = [select id, CG_Setting__c, Start_Date__c from CG_Setting_Items__c where CG_Setting__c =: CGSetting.Id order by start_date__c desc];
            
            if(CGSettingItems.size() > 0) {
                DurationDTO.startDate = CGSettingItems[0].Start_Date__c.addHours(7);
        		//DurationDTO.endDate = CGSettingItems[0].End_Date__c.addHours(7);
            }
        }
        else {
            DurationDTO.startDate = CGSetting.Start_Date__c.addHours(7);
            DurationDTO.endDate = CGSetting.End_Date__c.addHours(7);
        }
        
        DurationDTOs.add(DurationDTO);
        
        if(string.isBlank(CGSetting.Duration_JSON__c)) {
            CGSetting.Duration_JSON__c = JSON.serialize(DurationDTOs);
        }
        else {
            List<CG_DTO.DurationDTO> existDurationDTOs = (List<CG_DTO.DurationDTO>)(JSON.deserialize(CGSetting.Duration_JSON__c, List<CG_DTO.DurationDTO>.class));
        	
            existDurationDTOs.add(DurationDTO);
            
            CGSetting.Duration_JSON__c = JSON.serialize(existDurationDTOs);
        }
        
        update(CGSetting);
    }
    
    //Create new COI New Employee From Batch
    public static CG_DTO.BatchDTO COI_New_Employee(PISUsers__c PISUser, string COINewEmployeeRTId, EmailTemplate emailTemplate, List<User> allUsers, string runningNo, CustomNotificationType notificationType, OPP_Application__c CGApp) {
        
        Date todayDate = date.today();
        Date nextDate = todayDate.addDays(14);
        
        //COI New Employee
        CG_Reporting__c COINewEmployee = new CG_Reporting__c();
        COINewEmployee.OwnerId = PISUser.User__c;
        COINewEmployee.User__c = CG_Global.AssignSupervisor(PISUser);
        COINewEmployee.RecordTypeId = COINewEmployeeRTId;
        COINewEmployee.GenerateFromBatch__c = true;
        COINewEmployee.Start_Duration__c = todayDate;
        COINewEmployee.End_Duration__c = nextDate;
        COINewEmployee.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
        COINewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);        
        COINewEmployee.Status_JSON__c = InitialStatusJson(COINewEmployee.Id, PISUser);
        COINewEmployee.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        COINewEmployee.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        COINewEmployee.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        COINewEmployee.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        COINewEmployee.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        COINewEmployee.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        COINewEmployee.Reported_Date__c = todayDate;
        COINewEmployee.Owner_Function__c = PISUser.FUNCTION__c;
        COINewEmployee.Owner_Department__c = PISUser.DEPARTMENT__c;
        COINewEmployee.Owner_Section__c = PISUser.SECTIONS__c;
        COINewEmployee.Owner_Unit__c = PISUser.UNITS__c;
        
        //CGConfig = CG_ReportingHandler.GenerateRunningNo('COI New Employee', CGConfig);
        string year = GetCurrentYear();
        
        COINewEmployee.Running_No__c = 'COI-' + year + '-02-' + runningNo; //CGConfig.COI_New_User_Running_No__c;
        insert(COINewEmployee);
        
        CG_DTO.BatchDTO batchDTO = new CG_DTO.BatchDTO();
        
        //Send email to user
        Messaging.SingleEmailMessage sendEmail = COINewEmployeeEmail(COINewEmployee.OwnerId, COINewEmployee, emailTemplate, allUsers);
        
        //Send Bell Noti to User
        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
        BellNoti.NotificationName = 'CG_Notification';
        BellNoti.Title = 'Please report COI for New Employee';
        BellNoti.Body = 'Please report your Conflict of Interest for New Employee : ' + COINewEmployee.Running_No__c;
        BellNoti.Receivers = new Set<string>();
        BellNoti.Receivers.add(COINewEmployee.OwnerId);
        BellNoti.RecordId = COINewEmployee.Id;
        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + COINewEmployee.Id + '&parent=coiReporting\'}}';
        //CG_NotiController.SendBellNoti(BellNoti, notificationType);
        
        //Send Opp Noti
        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
        OppNoti.ApplicationId = CGApp.Id;
        OppNoti.ApproverId = COINewEmployee.OwnerId;
        OppNoti.Subject = 'Please report COI for New Employee';
        OppNoti.Description = 'Please report your Conflict of Interest for New Employee : ' + COINewEmployee.Running_No__c;
        OppNoti.RequesterName = COINewEmployee.Reported_By_EN__c;
        OppNoti.Status = 'New';
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + COINewEmployee.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        
        OppNoti.URL = URL;
        OppNoti.ReferenceId = COINewEmployee.Id;

        //CG_NotiController.SendOppNoti(OppNoti, CGApp);
        
        batchDTO.sendEmail = sendEmail;
        batchDTO.bellNoti = BellNoti;
        batchDTO.oppNoti = OppNoti;
        
        return batchDTO;
    }
    
    //Create New COI Annual From Batch
    public static Messaging.SingleEmailMessage COI_Annual(PISUsers__c PISUser, string COIAnnualRTId, EmailTemplate emailTemplate, CG_Setting__c CGSetting, List<User> allUsers, string runningNo) {
        
        Date todayDate = date.today();
        
        //COI Annual
        CG_Reporting__c COIAnnual = new CG_Reporting__c();
        COIAnnual.OwnerId = PISUser.User__c;
        COIAnnual.User__c = CG_Global.AssignSupervisor(PISUser);
        COIAnnual.RecordTypeId = COIAnnualRTId;
        COIAnnual.GenerateFromBatch__c = true;
        COIAnnual.Start_Duration__c = Date.ValueOf(CGSetting.Start_Date__c);
        COIAnnual.End_Duration__c = Date.ValueOf(CGSetting.End_Date__c);
        COIAnnual.Type_of_Report__c = 'COIAnnual';
        COIAnnual.Status__c = 'WaitingForSubmit';       
        COIAnnual.Status_JSON__c = InitialStatusJson(COIAnnual.Id, PISUser);
        COIAnnual.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        COIAnnual.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        COIAnnual.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        COIAnnual.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        COIAnnual.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        COIAnnual.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        COIAnnual.Reported_Date__c = todayDate;
        COIAnnual.Owner_Function__c = PISUser.FUNCTION__c;
        COIAnnual.Owner_Department__c = PISUser.DEPARTMENT__c;
        COIAnnual.Owner_Section__c = PISUser.SECTIONS__c;
        COIAnnual.Owner_Unit__c = PISUser.UNITS__c;
        
        //string runningNo = CG_ReportingHandler.GenerateRunningNo('COI Annual', CGConfig);
        //CGConfig = CG_ReportingHandler.GenerateRunningNo('COIAnnual', CGConfig);
        string year = GetCurrentYear();
        
        COIAnnual.Running_No__c = 'COI-' + year + '-03-' + runningNo;
        insert(COIAnnual);
        
        //Send email to user
        Messaging.SingleEmailMessage sendEmail = COIAnnualEmail(PISUser, COIAnnual, emailTemplate, allUsers);
        return sendEmail;
    }
    
    //Create new CG Manual New Employee From Batch
    public static CG_DTO.BatchDTO CG_Manual_New_Employee(PISUsers__c PISUser, string ManualNewEmployeeRTId, EmailTemplate emailTemplate, CG_Setting__c CGSetting, List<User> allUsers, string runningNo, CustomNotificationType notificationType, OPP_Application__c CGApp) {
        
        Date todayDate = date.today();
        Date nextDate = todayDate.addDays(14);
        
        //Manual New Employee
        CG_Reporting__c ManualNewEmployee = new CG_Reporting__c();
        ManualNewEmployee.OwnerId = PISUser.User__c;
        ManualNewEmployee.User__c = CG_Global.AssignSupervisor(PISUser);
        ManualNewEmployee.RecordTypeId = ManualNewEmployeeRTId;
        ManualNewEmployee.GenerateFromBatch__c = true;
        ManualNewEmployee.Start_Duration__c = todayDate;
        ManualNewEmployee.End_Duration__c = nextDate;
        ManualNewEmployee.Type_of_Report__c = 'CGNewEmployee';
        ManualNewEmployee.Status__c = 'WaitingForSubmit';           
        ManualNewEmployee.Status_JSON__c = InitialStatusJson(ManualNewEmployee.Id, PISUser);
        ManualNewEmployee.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        ManualNewEmployee.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        ManualNewEmployee.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        ManualNewEmployee.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        ManualNewEmployee.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        ManualNewEmployee.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        ManualNewEmployee.Reported_Date__c = todayDate;
        ManualNewEmployee.Owner_Function__c = PISUser.FUNCTION__c;
        ManualNewEmployee.Owner_Department__c = PISUser.DEPARTMENT__c;
        ManualNewEmployee.Owner_Section__c = PISUser.SECTIONS__c;
        ManualNewEmployee.Owner_Unit__c = PISUser.UNITS__c;
        
        //string runningNo = CG_ReportingHandler.GenerateRunningNo('CG New Employee', CGConfig);
        //CGConfig = CG_ReportingHandler.GenerateRunningNo('CG New Employee', CGConfig);
        string year = GetCurrentYear();
        
        ManualNewEmployee.Running_No__c = 'CG-' + year + '-01-' + runningNo;
        insert(ManualNewEmployee);
        
        CG_DTO.BatchDTO batchDTO = new CG_DTO.BatchDTO();
        
        //Send email to user
        Messaging.SingleEmailMessage sendEmail = CGNewEmployeeEmail(ManualNewEmployee.OwnerId, ManualNewEmployee, emailTemplate, allUsers);
        
        //Send Bell Noti to User
        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
        BellNoti.NotificationName = 'CG_Notification';
        BellNoti.Title = 'Please acknowledge your CG Manual for New Employee';
        BellNoti.Body = 'Please acknowledge your CG Manual for New Employee : ' + ManualNewEmployee.Running_No__c;
        BellNoti.Receivers = new Set<string>();
        BellNoti.Receivers.add(ManualNewEmployee.OwnerId);
        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + ManualNewEmployee.Id + '&parent=cgManualReporting\'}}';
        //CG_NotiController.SendBellNoti(BellNoti, notificationType);
        
        //Send Opp Noti
        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
        OppNoti.ApplicationId = CGApp.Id;
        OppNoti.ApproverId = ManualNewEmployee.OwnerId;
        OppNoti.Subject = 'Please acknowledge your CG Manual for New Employee';
        OppNoti.Description = 'Please acknowledge your CG Manual for New Employee : ' + ManualNewEmployee.Running_No__c;
        OppNoti.RequesterName = ManualNewEmployee.Reported_By_EN__c;
        OppNoti.Status = 'New';
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + ManualNewEmployee.Id + '&parent=cgManualReporting';
        string URL = emailURL(link); 
        
        OppNoti.URL = URL;
        OppNoti.ReferenceId = ManualNewEmployee.Id;

        //CG_NotiController.SendOppNoti(OppNoti, CGApp);
                
        batchDTO.sendEmail = sendEmail;
        batchDTO.bellNoti = BellNoti;
        batchDTO.oppNoti = OppNoti;
        
        return batchDTO;
    }

    //Create New CG Manual Annual From Batch
    public static Messaging.SingleEmailMessage CG_Manual_Annual(PISUsers__c PISUser, string ManualAnnualRTId, EmailTemplate emailTemplate, CG_Setting__c CGSetting, List<User> allUsers, string runningNo) {
        
        Date todayDate = date.today();
        
        //COI Manual Annual
        CG_Reporting__c COIManualAnnual = new CG_Reporting__c();
        COIManualAnnual.OwnerId = PISUser.User__c;
        COIManualAnnual.User__c = CG_Global.AssignSupervisor(PISUser);
        COIManualAnnual.RecordTypeId = ManualAnnualRTId;
        COIManualAnnual.GenerateFromBatch__c = true;
        COIManualAnnual.Start_Duration__c = Date.ValueOf(CGSetting.Start_Date__c);
        COIManualAnnual.End_Duration__c = Date.ValueOf(CGSetting.End_Date__c);
        COIManualAnnual.Type_of_Report__c = 'CGAnnual';
        COIManualAnnual.Status__c = 'WaitingForSubmit';            
        COIManualAnnual.Status_JSON__c = InitialStatusJson(COIManualAnnual.Id, PISUser);
        COIManualAnnual.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        COIManualAnnual.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        COIManualAnnual.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        COIManualAnnual.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        COIManualAnnual.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        COIManualAnnual.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        COIManualAnnual.Reported_Date__c = todayDate;
        COIManualAnnual.Owner_Function__c = PISUser.FUNCTION__c;
        COIManualAnnual.Owner_Department__c = PISUser.DEPARTMENT__c;
        COIManualAnnual.Owner_Section__c = PISUser.SECTIONS__c;
        COIManualAnnual.Owner_Unit__c = PISUser.UNITS__c;
        
        //string runningNo = CG_ReportingHandler.GenerateRunningNo('CG Annual', CGConfig);
        //CGConfig = CG_ReportingHandler.GenerateRunningNo('CG Annual', CGConfig);
        string year = GetCurrentYear();
        
        COIManualAnnual.Running_No__c = 'CG-' + year + '-02-' + runningNo;
        insert(COIManualAnnual);
        
        //Send email to user
        Messaging.SingleEmailMessage sendEmail = CGAnnualEmail(PISUser, COIManualAnnual, emailTemplate, allUsers);
        return sendEmail;
        
    }

    //Create New CG Manual From Batch
    public static CG_DTO.BatchDTO CG_Manual(PISUsers__c PISUser, string ManualRTId, EmailTemplate emailTemplate, CG_Setting__c CGSetting, List<User> allUsers, string runningNo, CustomNotificationType notificationType, OPP_Application__c CGApp) {
        
        Date todayDate = date.today();
        
        //COI Manual Annual
        CG_Reporting__c COIManual = new CG_Reporting__c();
        COIManual.OwnerId = PISUser.User__c;
        COIManual.User__c = CG_Global.AssignSupervisor(PISUser);
        COIManual.RecordTypeId = ManualRTId;
        COIManual.GenerateFromBatch__c = true;
        COIManual.Start_Duration__c = Date.ValueOf(CGSetting.Start_Date__c);
        COIManual.End_Duration__c = Date.ValueOf(CGSetting.End_Date__c);
        COIManual.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGManual);
        COIManual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);            
        COIManual.Status_JSON__c = InitialStatusJson(COIManual.Id, PISUser);
        COIManual.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        COIManual.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        COIManual.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        COIManual.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        COIManual.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        COIManual.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        COIManual.Reported_Date__c = todayDate;
        COIManual.Owner_Function__c = PISUser.FUNCTION__c;
        COIManual.Owner_Department__c = PISUser.DEPARTMENT__c;
        COIManual.Owner_Section__c = PISUser.SECTIONS__c;
        COIManual.Owner_Unit__c = PISUser.UNITS__c;
        
        //string runningNo = CG_ReportingHandler.GenerateRunningNo('CG Manual', CGConfig);
        //CGConfig = CG_ReportingHandler.GenerateRunningNo('CG Manual', CGConfig);
        string year = GetCurrentYear();
        
        COIManual.Running_No__c = 'CG-' + year + '-03-' + runningNo;
        insert(COIManual);
        
        CG_DTO.BatchDTO batchDTO = new CG_DTO.BatchDTO();
        
        //Send Bell Noti to User
        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
        BellNoti.NotificationName = 'CG_Notification';
        BellNoti.Title = 'Please acknowledge New CG Manual';
        BellNoti.Body = 'Please submit your CG Manual (New CG Manual) : ' + COIManual.Running_No__c;
        BellNoti.Receivers = new Set<string>();
        BellNoti.Receivers.add(COIManual.OwnerId);
        BellNoti.RecordId = COIManual.Id;
        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + COIManual.Id + '&parent=cgManualReporting\'}}';
        //CG_NotiController.SendBellNoti(BellNoti, notificationType);
        
        //Send Opp Noti
        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
        OppNoti.ApplicationId = CGApp.Id;
        OppNoti.ApproverId = COIManual.OwnerId;
        OppNoti.Subject = 'Please acknowledge New CG Manual';
        OppNoti.Description = 'Please submit your CG Manual (New CG Manual) : ' + COIManual.Running_No__c;
        OppNoti.RequesterName = COIManual.Reported_By_EN__c;
        OppNoti.Status = 'New';
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + COIManual.Id + '&parent=cgManualReporting';
        string URL = emailURL(link); 
        
        OppNoti.URL = URL;
        OppNoti.ReferenceId = COIManual.Id;

        //CG_NotiController.SendOppNoti(OppNoti, CGApp);
        
        //Send email to user
        Messaging.SingleEmailMessage sendEmail = CGManualEmail(COIManual.OwnerId, COIManual, emailTemplate, allUsers);
        
        batchDTO.sendEmail = sendEmail;
        batchDTO.bellNoti = BellNoti;
        batchDTO.oppNoti = OppNoti;
        
        return batchDTO;
        
    }

    public static CG_Reporting__c InsertCGReporting(PISUsers__c PISUser, string RTId, string TypeOfReport, CG_Setting__c CGSetting, string RunningNo) {
        
        Date todayDate = date.today();
        
        //CGReport
        CG_Reporting__c CGReport = new CG_Reporting__c();
        CGReport.OwnerId = PISUser.User__c;
        CGReport.User__c = CG_Global.AssignSupervisor(PISUser);
        CGReport.RecordTypeId = RTId;
        CGReport.GenerateFromBatch__c = true;
        CGReport.Start_Duration__c = Date.ValueOf(CGSetting.Start_Date__c);
        CGReport.End_Duration__c = Date.ValueOf(CGSetting.End_Date__c);
        CGReport.Type_of_Report__c = TypeOfReport; //COIAnnual
        CGReport.Status__c = 'WaitingForSubmit';       
        CGReport.Status_JSON__c = InitialStatusJson(CGReport.Id, PISUser);
        CGReport.Reported_By_Employee_Id__c = PISUser.EMPLOYEEID__c;
        CGReport.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        CGReport.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        CGReport.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        CGReport.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        CGReport.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        CGReport.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        CGReport.Reported_Date__c = todayDate;
        CGReport.Owner_Function__c = PISUser.FUNCTION__c;
        CGReport.Owner_Department__c = PISUser.DEPARTMENT__c;
        CGReport.Owner_Section__c = PISUser.SECTIONS__c;
        CGReport.Owner_Unit__c = PISUser.UNITS__c;
        
        //string runningNo = CG_ReportingHandler.GenerateRunningNo(TypeOfReport, CGConfig);
        //CGConfig = CG_ReportingHandler.GenerateRunningNo(TypeOfReport, CGConfig);
        string year = GetCurrentYear();
        
        if(TypeOfReport == 'COIAnnual') {
        	CGReport.Running_No__c = 'COI-' + year + '-03-' + RunningNo;
        }
        else if(TypeOfReport == 'CGAnnual') {
        	CGReport.Running_No__c = 'CG-' + year + '-02-' + RunningNo;
        }
        
        //insert(CGReport);
        return CGReport;
    }
    
    //Generate BellNoti
    public static CG_DTO.BellNotiDTO GenerateBellNoti(CG_Reporting__c CGReport, string Title, string Body, string PageRef) {
        //Send Bell Noti to User
        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
        BellNoti.NotificationName = 'CG_Notification';
        BellNoti.Title = Title;
        BellNoti.Body = Body;
        BellNoti.Receivers = new Set<string>();
        BellNoti.Receivers.add(CGReport.OwnerId);
        BellNoti.RecordId = CGReport.Id;
        BellNoti.PageRef = PageRef; 
        return BellNoti;
    }
    
    //Generate OppNoti
    public static CG_DTO.OppNotiDTO GenerateOppNoti(CG_Reporting__c CGReport, OPP_Application__c CGApp, string Subject, string Description, string URL) {
        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
        OppNoti.ApplicationId = CGApp.Id;
        OppNoti.ApproverId = CGReport.OwnerId;
        OppNoti.Subject = Subject;
        OppNoti.Description = Description;
        OppNoti.RequesterName = CGReport.Reported_By_EN__c;
        OppNoti.Status = 'New';
        OppNoti.URL = URL;
        OppNoti.ReferenceId = CGReport.Id;
        return OppNoti;
    }
    
    //Create New COI Annual, CG Annual From Batch
    public static CG_DTO.BatchDTO Annual(PISUsers__c PISUser, string COIAnnualRTId, string CGAnnualRTId, EmailTemplate emailTemplate, CG_Setting__c CGSetting, List<User> allUsers, CG_Config__c CGConfig, CustomNotificationType notificationType, OPP_Application__c CGApp) {
        
        Date todayDate = date.today();
        
        //COI Annual
        CG_Reporting__c COIAnnual = new CG_Reporting__c();
        COIAnnual.OwnerId = PISUser.User__c;
        COIAnnual.User__c = CG_Global.AssignSupervisor(PISUser);
        COIAnnual.RecordTypeId = COIAnnualRTId;
        COIAnnual.GenerateFromBatch__c = true;
        COIAnnual.Start_Duration__c = Date.ValueOf(CGSetting.Start_Date__c);
        COIAnnual.End_Duration__c = Date.ValueOf(CGSetting.End_Date__c);
        COIAnnual.Type_of_Report__c = 'COIAnnual';
        COIAnnual.Status__c = 'WaitingForSubmit';       
        COIAnnual.Status_JSON__c = InitialStatusJson(COIAnnual.Id, PISUser);
        COIAnnual.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        COIAnnual.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        COIAnnual.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        COIAnnual.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        COIAnnual.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        COIAnnual.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        COIAnnual.Reported_Date__c = todayDate;
        COIAnnual.Owner_Function__c = PISUser.FUNCTION__c;
        COIAnnual.Owner_Department__c = PISUser.DEPARTMENT__c;
        COIAnnual.Owner_Section__c = PISUser.SECTIONS__c;
        COIAnnual.Owner_Unit__c = PISUser.UNITS__c;
        
        //string runningNo = CG_ReportingHandler.GenerateRunningNo('COI Annual', CGConfig);
        CGConfig = CG_ReportingHandler.GenerateRunningNo('COI Annual', CGConfig);
        string year = GetCurrentYear();
        
        COIAnnual.Running_No__c = 'COI-' + year + '-03-' + CGConfig.COI_Annual_Running_No__c;
        insert(COIAnnual);
        
        CG_DTO.BatchDTO batchDTO = new CG_DTO.BatchDTO();
        
        //Send Bell Noti to User
        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
        BellNoti.NotificationName = 'CG_Notification';
        BellNoti.Title = 'Please report COI Annual Report';
        BellNoti.Body = 'Please submit your Conflict of Interest (Annual) : ' + COIAnnual.Running_No__c;
        BellNoti.Receivers = new Set<string>();
        BellNoti.Receivers.add(COIAnnual.OwnerId);
        BellNoti.RecordId = COIAnnual.Id;
        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + COIAnnual.Id + '&parent=coiReporting\'}}';
        //CG_NotiController.SendBellNoti(BellNoti, notificationType);
        
        //Send Opp Noti
        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
        OppNoti.ApplicationId = CGApp.Id;
        OppNoti.ApproverId = COIAnnual.OwnerId;
        OppNoti.Subject = 'Please report COI Annual report';
        OppNoti.Description = 'Please submit your Conflict of Interest (Annual) : ' + COIAnnual.Running_No__c;
        OppNoti.RequesterName = COIAnnual.Reported_By_EN__c;
        OppNoti.Status = 'New';
        
        string COIURL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_Detial?reportId=' + COIAnnual.Id + '&parent=coiReporting';
        
        OppNoti.URL = COIURL;
        OppNoti.ReferenceId = COIAnnual.Id;

        //CG_NotiController.SendOppNoti(OppNoti, CGApp);
        
        //CG Manual Annual
        CG_Reporting__c CGAnnual = new CG_Reporting__c();
        CGAnnual.OwnerId = PISUser.User__c;
        CGAnnual.User__c = CG_Global.AssignSupervisor(PISUser);
        CGAnnual.RecordTypeId = CGAnnualRTId;
        CGAnnual.GenerateFromBatch__c = true;
        CGAnnual.Start_Duration__c = Date.ValueOf(CGSetting.Start_Date__c);
        CGAnnual.End_Duration__c = Date.ValueOf(CGSetting.End_Date__c);
        CGAnnual.Type_of_Report__c = 'CGAnnual';
        CGAnnual.Status__c = 'WaitingForSubmit';            
        CGAnnual.Status_JSON__c = InitialStatusJson(CGAnnual.Id, PISUser);
        CGAnnual.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        CGAnnual.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        CGAnnual.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        CGAnnual.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        CGAnnual.Reported_Date__c = todayDate;
        //CGAnnual.Reported_By_Position_TH__c = ;
        //CGAnnual.Reported_By_Position_EN__c = ;
        CGAnnual.Owner_Function__c = PISUser.FUNCTION__c;
        CGAnnual.Owner_Department__c = PISUser.DEPARTMENT__c;
        CGAnnual.Owner_Section__c = PISUser.SECTIONS__c;
        CGAnnual.Owner_Unit__c = PISUser.UNITS__c;
        
        //string cgRunningNo = CG_ReportingHandler.GenerateRunningNo('CG Annual', CGConfig);
        CGConfig = CG_ReportingHandler.GenerateRunningNo('CG Annual', CGConfig);
        
        CGAnnual.Running_No__c = 'CG-' + year + '-02-' + CGConfig.CG_Annual_Running_No__c;
        insert(CGAnnual);
        
        //Send Bell Noti to User
        CG_DTO.BellNotiDTO BellNotiCGAnnual = new CG_DTO.BellNotiDTO();
        BellNotiCGAnnual.NotificationName = 'CG_Notification';
        BellNotiCGAnnual.Title = 'Please acknowledge CG Annual';
        BellNotiCGAnnual.Body = 'Please submit your annual report for CG Manual Acknowledgement : ' + CGAnnual.Running_No__c;
        BellNotiCGAnnual.Receivers = new Set<string>();
        BellNotiCGAnnual.Receivers.add(CGAnnual.OwnerId);
        BellNotiCGAnnual.RecordId = CGAnnual.Id;
        BellNotiCGAnnual.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGAnnual.Id + '&parent=cgManualReporting\'}}';
        //CG_NotiController.SendBellNoti(BellNotiCGAnnual, notificationType);
        
        //Send Opp Noti
        CG_DTO.OppNotiDTO OppNotiCGAnnual = new CG_DTO.OppNotiDTO();
        OppNotiCGAnnual.ApplicationId = CGApp.Id;
        OppNotiCGAnnual.ApproverId = CGAnnual.OwnerId;
        OppNotiCGAnnual.Subject = 'Please acknowledge CG Annual';
        OppNotiCGAnnual.Description = 'Please submit your annual report for CG Manual Acknowledgement : ' + CGAnnual.Running_No__c;
        OppNotiCGAnnual.RequesterName = CGAnnual.Reported_By_EN__c;
        OppNotiCGAnnual.Status = 'New';
        
        string CGURL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGAnnual.Id + '&parent=cgManualReporting';
        
        OppNotiCGAnnual.URL = CGURL;
        OppNotiCGAnnual.ReferenceId = CGAnnual.Id;
        
        //CG_NotiController.SendOppNoti(OppNotiCGAnnual, CGApp);
        
        //Send email to user
        Messaging.SingleEmailMessage sendEmail = AnnualEmail(PISUser, COIAnnual, CGAnnual, emailTemplate, allUsers);
        
        batchDTO.sendEmail = sendEmail;
        batchDTO.bellNoti = BellNoti;
        batchDTO.oppNoti = OppNoti;
        batchDTO.bellNoti2 = BellNotiCGAnnual;
        batchDTO.oppNoti2 = OppNotiCGAnnual;
        
        return batchDTO;
    }
    
    //Create new COI New Employee From Screen
    public static void COI_Incident(PISUsers__c PISUser, CG_Reporting__c CGReporting) {
        
        Date todayDate = date.today();
        Date nextDate = todayDate.addDays(14);
        
        Id COIIncidentRTId = [select id, name from RecordType where name = 'CG COI Incident' AND sobjecttype = 'CG_Reporting__c'].Id;
        
        //COI Incident
        CG_Reporting__c COIIncident = new CG_Reporting__c();
        COIIncident.User__c = PISUser.User__c;
        COIIncident.User__c = CG_Global.AssignSupervisor(PISUser);
        COIIncident.RecordTypeId = COIIncidentRTId;
        COIIncident.GenerateFromBatch__c = false;
        COIIncident.Start_Duration__c = todayDate;
        COIIncident.End_Duration__c = nextDate;
        COIIncident.Type_of_Report__c = 'COIIncident';
        COIIncident.Status__c = 'WaitingForSubmit';              
        COIIncident.Status_JSON__c = InitialStatusJson(COIIncident.Id, PISUser);
        COIIncident.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        COIIncident.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        COIIncident.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        COIIncident.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        COIIncident.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        COIIncident.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        COIIncident.Reported_Date__c = todayDate;
        COIIncident.Owner_Function__c = PISUser.FUNCTION__c;
        COIIncident.Owner_Department__c = PISUser.DEPARTMENT__c;
        COIIncident.Owner_Section__c = PISUser.SECTIONS__c;
        COIIncident.Owner_Unit__c = PISUser.UNITS__c;
        
        string runningNo = CG_ReportingHandler.GenerateRunningNo('COI Incident');
        string year = GetCurrentYear();
        
        COIIncident.Running_No__c = 'COI-' + year + '-01-' + runningNo;
        insert(COIIncident);
        
    }
    
    //Create New Gift Registration From Screen
    public static void GiftRegistration(PISUsers__c PISUser, CG_Reporting__c CGReporting) {
        
        Date todayDate = date.today();
        
        Id GiftRTId = [select id, name from RecordType where name = 'Gift Registration' AND sobjecttype = 'CG_Reporting__c'].Id;
        
        //Gift Registration
        CG_Reporting__c GR = new CG_Reporting__c();
        GR.User__c = PISUser.User__c;
        GR.OwnerId = PISUser.User__c;
        GR.RecordTypeId = GiftRTId;
        GR.GenerateFromBatch__c = false;
        GR.Type_of_Report__c = 'GiftRegistration';
        GR.Status__c = 'WaitingForSubmit';              
        GR.Status_JSON__c = InitialStatusJson(GR.Id, PISUser);
        GR.Reported_By_TH__c = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
        GR.Reported_By_EN__c = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
        GR.Reported_By_Position_TH__c = PISUser.OBJTHFULLNAME__c;
        GR.Reported_By_Position_EN__c = PISUser.OBJENFULLNAME__c;
        GR.Reported_By_Company_TH__c = PISUser.COMPANYNAME_HOST__c;
        GR.Reported_By_Company_EN__c = PISUser.COMPANYNAME_HOST__c;
        GR.Reported_Date__c = todayDate;
        GR.Owner_Function__c = PISUser.FUNCTION__c;
        GR.Owner_Department__c = PISUser.DEPARTMENT__c;
        GR.Owner_Section__c = PISUser.SECTIONS__c;
        GR.Owner_Unit__c = PISUser.UNITS__c;
        
        string runningNo = CG_ReportingHandler.GenerateRunningNo('Gift Registration');
        string year = GetCurrentYear();
        
        GR.Running_No__c = 'GIFT-' + year + '-' + runningNo;
        insert(GR);
        
    }
    
	//Generate Running No
    public static CG_Config__c GenerateRunningNo(string type, CG_Config__c CGConfig) {
        
        string genratedRN = '';
        
        Date todayDate = date.today();
        String userLocale = UserInfo.getLocale();
        integer currentYear = 0;
        
        boolean isThaiLocale = userLocale.contains('th');
        if(isThaiLocale && todayDate.year() > 2500) {
            currentYear = todayDate.year() - 543;
        }
        else {
            currentYear = todayDate.year();
        }
        
        //CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
		//								CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
        if(string.valueOf(currentYear) != CGConfig.Year__c) {
            CGConfig.Year__c = string.valueOf(currentYear);
            CGConfig.COI_New_User_Running_No__c = '0';
            CGConfig.COI_Incident_Running_No__c = '0';
            CGConfig.COI_Annual_Running_No__c = '0';
            CGConfig.CG_New_User_Running_No__c = '0';
            CGConfig.CG_Manual_Running_No__c = '0';
            CGConfig.CG_Annual_Running_No__c = '0';
            CGConfig.Gift_Running_No__c = '0';
        }
        
        if(type == 'COIIncident') {
            integer runningNo = integer.valueOf(CGConfig.COI_Incident_Running_No__c) + 1;
            CGConfig.COI_Incident_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.COI_Incident_Running_No__c;
        }
        else if(type == 'COINewEmployee') {
            integer runningNo = integer.valueOf(CGConfig.COI_New_User_Running_No__c) + 1;
            CGConfig.COI_New_User_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.COI_New_User_Running_No__c;
        }
        else if(type == 'COIAnnual') {
            integer runningNo = integer.valueOf(CGConfig.COI_Annual_Running_No__c) + 1;
            CGConfig.COI_Annual_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.COI_Annual_Running_No__c;
        }
        else if(type == 'CGNewEmployee') {
            integer runningNo = integer.valueOf(CGConfig.CG_New_User_Running_No__c) + 1;
            CGConfig.CG_New_User_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.CG_New_User_Running_No__c;
        }
        else if(type == 'CGAnnual') {
            integer runningNo = integer.valueOf(CGConfig.CG_Annual_Running_No__c) + 1;
            CGConfig.CG_Annual_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.CG_Annual_Running_No__c;
        }
        else if(type == 'CGManual') {
            integer runningNo = integer.valueOf(CGConfig.CG_Manual_Running_No__c) + 1;
            CGConfig.CG_Manual_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.CG_Manual_Running_No__c;
        }
        else if(type == 'GiftRegistration') {
            integer runningNo = integer.valueOf(CGConfig.Gift_Running_No__c) + 1;
            CGConfig.Gift_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.Gift_Running_No__c;
        }
        
        //update(CGConfig);
        //return genratedRN;
        return CGConfig;
    }
    
    public static string GenerateRunningNo(string type) {
        
        string genratedRN = '';
        
        Date todayDate = date.today();
        String userLocale = UserInfo.getLocale();
        integer currentYear = 0;
        
        boolean isThaiLocale = userLocale.contains('th');
        if(isThaiLocale && todayDate.year() > 2500) {
            currentYear = todayDate.year() - 543;
        }
        else {
            currentYear = todayDate.year();
        }
        
        CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
										CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
        if(string.valueOf(currentYear) != CGConfig.Year__c) {
            CGConfig.Year__c = string.valueOf(currentYear);
            CGConfig.COI_New_User_Running_No__c = '0';
            CGConfig.COI_Incident_Running_No__c = '0';
            CGConfig.COI_Annual_Running_No__c = '0';
            CGConfig.CG_New_User_Running_No__c = '0';
            CGConfig.CG_Manual_Running_No__c = '0';
            CGConfig.CG_Annual_Running_No__c = '0';
            CGConfig.Gift_Running_No__c = '0';
        }
        
        if(type == 'COI Incident') {
            integer runningNo = integer.valueOf(CGConfig.COI_Incident_Running_No__c) + 1;
            CGConfig.COI_Incident_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.COI_Incident_Running_No__c;
        }
        else if(type == 'COI New Employee') {
            integer runningNo = integer.valueOf(CGConfig.COI_New_User_Running_No__c) + 1;
            CGConfig.COI_New_User_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.COI_New_User_Running_No__c;
        }
        else if(type == 'COI Annual') {
            integer runningNo = integer.valueOf(CGConfig.COI_Annual_Running_No__c) + 1;
            CGConfig.COI_Annual_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.COI_Annual_Running_No__c;
        }
        else if(type == 'CG New Employee') {
            integer runningNo = integer.valueOf(CGConfig.CG_New_User_Running_No__c) + 1;
            CGConfig.CG_New_User_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.CG_New_User_Running_No__c;
        }
        else if(type == 'CG Annual') {
            integer runningNo = integer.valueOf(CGConfig.CG_Annual_Running_No__c) + 1;
            CGConfig.CG_Annual_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.CG_Annual_Running_No__c;
        }
        else if(type == 'CG Manual') {
            integer runningNo = integer.valueOf(CGConfig.CG_Manual_Running_No__c) + 1;
            CGConfig.CG_Manual_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.CG_Manual_Running_No__c;
        }
        else if(type == 'Gift Registration') {
            integer runningNo = integer.valueOf(CGConfig.Gift_Running_No__c) + 1;
            CGConfig.Gift_Running_No__c = CG_ReportingHandler.ActualRunningNo(runningNo);
            genratedRN = CGConfig.Gift_Running_No__c;
        }
        
        update(CGConfig);
        
        return genratedRN;
        
    }
    
    public static string ActualRunningNo(integer runningNo) {
        string actualNo = '';
        if(runningNo > 0 && runningNo < 10) {
            actualNo = '000' + runningNo;
        }
        else if(runningNo >= 10 && runningNo < 100) {
            actualNo = '00' + runningNo;
        }
        else if(runningNo >= 100 && runningNo < 1000) {
            actualNo = '0' + runningNo;
        }
        else {
            actualNo = string.valueOf(runningNo);
        }
        return actualNo;
    }
    
    public static string GetCurrentYear() {
        
        Date todayDate = date.today();
        String userLocale = UserInfo.getLocale();
        integer currentYear = 0;
        
        boolean isThaiLocale = userLocale.contains('th');
        if(isThaiLocale && todayDate.year() > 2500) {
            currentYear = todayDate.year() - 543;
        }
        else {
            currentYear = todayDate.year();
        }
        
        return String.ValueOf(currentYear);
    }
    
    //Send COI New Employee Email
    public static Messaging.SingleEmailMessage COINewEmployeeEmail(string userId, CG_Reporting__c CGReport, EmailTemplate emailTemplate, List<User> allUsers) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { userId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = new User();
            
            if(allUsers.size() > 0) {
                for(User U : allUsers) {
                    if(U.Id == receiverId) {
                    	Receiver = U;
                    }
                }
            }
            
            //User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            /* Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
                
            return messages[0];
        }
        
        return null;
    }
    
    //Send COI Email (Reminder) for user
    public static void COIReminderEmail(string userId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { userId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_New_Employee_User']; //COI_User_Reminder
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            //htmlBody = htmlBody.replace('{!CG_Reporting__c.Start_Duration__c}', CGReport.Start_Duration__c.format());
            //htmlBody = htmlBody.replace('{!CG_Reporting__c.End_Duration__c}', CGReport.End_Duration__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            //plainBody = plainBody.replace('{!CG_Reporting__c.Start_Duration__c}', CGReport.Start_Duration__c.format());
            //plainBody = plainBody.replace('{!CG_Reporting__c.End_Duration__c}', CGReport.End_Duration__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
        
    }
    
    //Send COI Annual Email (Reminder) for user
    public static void COIAnnualReminderEmail(string userId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { userId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Annual'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!COILink}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!COILink}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
        
    }
    
    //Send COI New Employee Supervisor Email
    public static void COINewEmployeeSupervisorEmail(string supervisorId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { supervisorId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            User Requester = [select id, email, firstname, lastname from User where Id =: CGReport.OwnerId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_New_Employee_Supervisor'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send COI Incident Supervisor Email
    public static void COIIncidentSupervisorEmail(string supervisorId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { supervisorId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            User Requester = [select id, email, firstname, lastname from User where Id =: CGReport.OwnerId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Incident_Supervisor'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send COI Annual Supervisor Email
    public static void COIAnnualSupervisorEmail(string supervisorId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { supervisorId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            User Requester = [select id, email, firstname, lastname from User where Id =: CGReport.OwnerId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Annual_Supervisor'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send COI Rejected Email after Supervisor rejected
    public static void COIUserRejectedEmail(string ownerId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { ownerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Rejected_Supervisor'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
            string coiType = '';
            if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                coiType = 'New Employee';
            }
            else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                coiType = 'Annual';
            }
            else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                coiType = 'Incident';
            }
            
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!COIType}', coiType);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!COIType}', coiType);
            plainBody = plainBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email, 'puttipat@softever.co.th', 'sarocha@softever.co.th' };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send COI Mass Acknowledge Supervisor AND GLVP Email
    public static Messaging.SingleEmailMessage COIMassAcknowledgeEmail(string approverRole, EmailTemplate emailTemplate, string userId, integer recordCount) {
        
        string Link = '';
        //string SFURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        if(approverRole == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
            string url = '/one/one.app#/alohaRedirect/apex/CG_Supervisor_Mass_Acknowledge';
            Link = emailURL(url); 
        }
        else if(approverRole == String.ValueOf(CG_Enum.ApproverRole.GLVP)) {
            string url = '/one/one.app#/alohaRedirect/apex/CG_GLVP_Mass_Acknowledge';
            Link = emailURL(url); 
        }
        
        string[] receiverIds = new string[] { userId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            string subject = emailTemplate.Subject;
            
            string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ReportCount}', String.ValueOf(recordCount));
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', Link);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ReportCount}', String.ValueOf(recordCount));
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', Link);
            plainBody = plainBody.replace(']]>', '');
            
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
            message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
            
            message.toAddresses = new String[] { receiver.email };
                
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                
            return messages[0];
        }
        
        return null;
            
    }

    //Send COI New Employee GLVP Email
    public static void COIGLVPEmail(string glvpId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { glvpId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            User Requester = [select id, email, firstname, lastname from User where Id =: CGReport.OwnerId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            string cgType = '';
            if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                cgType = 'New Employee';
            }
            else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                cgType = 'Incident';
            }
            else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                cgType = 'Annual';
            }
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_GLVP'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CGType}', cgType);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CGType}', cgType);
            plainBody = plainBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send COI Annual Email
    public static Messaging.SingleEmailMessage COIAnnualEmail(PISUSers__c PISUser, CG_Reporting__c CGReport, EmailTemplate emailTemplate, List<User> allUsers) {
        
        system.debug(PISUser);
        string link = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { PISUser.User__c };
        for(string receiverId : receiverIds) {
            
            /* User Receiver = new User();
            
            if(allUsers.size() > 0) {
                for(User U : allUsers) {
                    if(U.Id == receiverId) {
                    	Receiver = U;
                    }
                }
            } */
            
            //User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            //EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Annual'];
            
        	string subject = emailTemplate.Subject;
        	//subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c);
            htmlBody = htmlBody.replace('{!COILink}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c);
            plainBody = plainBody.replace('{!COILink}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(PISUser.User__c); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(PISUser.User__c);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { PISUser.EMAIL__c };
                
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage> {message};
            
            /* Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
                
            return messages[0];
        }
        
        return null;
    }
        
    //Send CG New Employee Email
    public static Messaging.SingleEmailMessage CGNewEmployeeEmail(string userId, CG_Reporting__c CGReport, EmailTemplate emailTemplate, List<User> allUsers) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Manual_detail?reportId=' + CGReport.Id + '&parent=cgManualReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { userId};
        
        for(string receiverId : receiverIds) {
            
            User Receiver = new User();
            
            if(allUsers.size() > 0) {
                for(User U : allUsers) {
                    if(U.Id == receiverId) {
                    	Receiver = U;
                    }
                }
            }
            
            //User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Start_Duration__c}', String.ValueOf(CGReport.Start_Duration__c));
            htmlBody = htmlBody.replace('{!CG_Reporting__c.End_Duration__c}', String.ValueOf(CGReport.End_Duration__c));
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Start_Duration__c}', String.ValueOf(CGReport.Start_Duration__c));
            plainBody = plainBody.replace('{!CG_Reporting__c.End_Duration__c}', String.ValueOf(CGReport.End_Duration__c));
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            
            /* Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
                
            
                
            return messages[0];
        }
        
        return null;
    }

    //Send CG Email (Reminder)
    public static void CGReminderEmail(string userId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Manual_detail?reportId=' + CGReport.Id + '&parent=cgManualReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { userId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_User_Reminder'];
            
            string cgType = '';
            string acknowledgeSubject = '';
            string detail = '';
            if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
                cgType = 'New Employee';
                acknowledgeSubject = 'Please acknowledge your CG Manual for New Employee';
                detail = 'Please acknowledge your CG Manual for New Employee in this following item.';
            }
            else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
                cgType = 'Annual';
                acknowledgeSubject = 'Please acknowledge CG Annual';
                detail = 'Please acknowledge your CG Manual(Annual) for the following item.';
            }
            else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
                cgType = 'Manual';
                acknowledgeSubject = 'Please acknowledge New CG Manual';
                detail = 'Please acknowledge your CG Manual(New CG Manual) for the following item.';
            }
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	subject = subject.replace('{!AcknowledgeSubject}', acknowledgeSubject);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
        	htmlBody = htmlBody.replace('{!Detail}', detail);
        	htmlBody = htmlBody.replace('{!CGType}', cgType);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Start_Duration__c}', CGReport.Start_Duration__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.End_Duration__c}', CGReport.End_Duration__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
        	plainBody = plainBody.replace('{!Detail}', detail);
        	plainBody = plainBody.replace('{!CGType}', cgType);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Start_Duration__c}', CGReport.Start_Duration__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.End_Duration__c}', CGReport.End_Duration__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
        
    }
    
    //Send CG Annual Email
    public static Messaging.SingleEmailMessage CGAnnualEmail(PISUsers__c PISUser, CG_Reporting__c CGReport, EmailTemplate emailTemplate, List<User> allUsers) {
        
        system.debug(PISUser);
        string link = '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting';
        string URL = emailURL(link); 
        
        string[] receiverIds = new string[] { PISUser.User__c };
        
        for(string receiverId : receiverIds) {
            
            /* User Receiver = new User();
            
            if(allUsers.size() > 0) {
                for(User U : allUsers) {
                    if(U.Id == receiverId) {
                    	Receiver = U;
                    }
                }
            } */
            
            //User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
        	string subject = emailTemplate.Subject;
        	//subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c);
            htmlBody = htmlBody.replace('{!CGLink}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c);
            plainBody = plainBody.replace('{!CGLink}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(PISUser.User__c); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(PISUser.User__c);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { PISUser.EMAIL__c };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            /* Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
                
            return messages[0];
        }
        
        return null;
    }
    
    //Send CG Manual Email
    public static Messaging.SingleEmailMessage CGManualEmail(string userId, CG_Reporting__c CGReport, EmailTemplate emailTemplate, List<User> allUsers) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { userId};
        
        for(string receiverId : receiverIds) {
            
            User Receiver = new User();
            
            if(allUsers.size() > 0) {
                for(User U : allUsers) {
                    if(U.Id == receiverId) {
                    	Receiver = U;
                    }
                }
            }
            
            //User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            /* Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
                
            return messages[0];
        }
        
        return null;
    }
    
    //Send COI Annual and CG Annual Email
    public static Messaging.SingleEmailMessage AnnualEmail(PISUsers__c PISUser, CG_Reporting__c COIAnnual, CG_Reporting__c CGAnnual, EmailTemplate emailTemplate, List<User> allUsers) {
        
        system.debug(PISUser);
        string coiLink = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + COIAnnual.Id + '&parent=coiReporting';
        string coiURL = emailURL(coiLink); 
        string cgLink = '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGAnnual.Id + '&parent=cgManualReporting';
        string cgURL = emailURL(cgLink); 
        string[] receiverIds = new string[] { PISUser.User__c };
        
        for(string receiverId : receiverIds) {
            
            /* User Receiver = new User();
            
            if(allUsers.size() > 0) {
                for(User U : allUsers) {
                    if(U.Id == receiverId) {
                    	Receiver = U;
                    }
                }
            } */
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            string actualSubject = '[COI and CG Manual Report] - Please submit your annual reports';
            string actualDetail = 'Please submit your annual reports for Conflict of Interest and CG Manual Acknowledgement by click this link below to access your report.';
            string actualLink = '1. Conflict of Interest (Annual) URL :  <br/> ' + coiURL + '<br/> 2. CG Manual Acknowledgement (Annual) URL : <br/>' + cgURL;
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!Subject}', actualSubject);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', PISUser.ENFIRSTNAME__c + PISUser.ENLASTNAME__c);
            htmlBody = htmlBody.replace('{!Detail}', actualDetail);
            htmlBody = htmlBody.replace('{!Link}', actualLink);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', PISUser.ENFIRSTNAME__c + PISUser.ENLASTNAME__c);
            plainBody = plainBody.replace('{!Detail}', actualDetail);
            plainBody = plainBody.replace('{!Link}', actualLink);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(PISUser.User__c); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(PISUser.User__c);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { PISUser.EMAIL__c }; 
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            /* Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
                
            return messages[0];
        }
        
        return null;
    }
    
    //Send Annual Reminder Email
    public static Messaging.SingleEmailMessage AnnualReminderEmail(string ownerId, boolean isCOIAnnualReminder, boolean isCGAnnualReminder, CG_Reporting__c COIAnnual, CG_Reporting__c CGAnnual, EmailTemplate emailTemplate, List<User> allUsers) {
        
        string coiLink = '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + COIAnnual.Id + '&parent=coiReporting';
        string coiURL = emailURL(coiLink); 
        string cgLink = '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGAnnual.Id + '&parent=cgManualReporting';
        string cgURL = emailURL(cgLink); 
        
        string[] receiverIds = new string[] { ownerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = new User();
            
            if(allUsers.size() > 0) {
                for(User U : allUsers) {
                    if(U.Id == receiverId) {
                    	Receiver = U;
                    }
                }
            }
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            string actualSubject = '';
            string actualDetail = '';
            string actualLink = '';
            
            if(isCOIAnnualReminder && isCGAnnualReminder) {
                actualSubject = 'CG Manual Acknowledgement and Conflict of Interest Report - Please submit your annual report';
                actualDetail = 'Please submit your annual CG Manual Acknowledgement and Conflict of Interest Report by click this link below to access your report.';
            	actualLink = '1. Conflict of Interest (Annual) URL :  <br/> ' + coiURL + '<br/> 2. CG Manual Acknowledgement (Annual) URL : <br/>' + cgURL;
            }
            else if(isCOIAnnualReminder && !isCGAnnualReminder) {
                actualSubject = 'Conflict of Interest Report - Please submit your annual report';
                actualDetail = 'Please submit your annual Conflict of Interest Report by click this link below to access your report.';
            	actualLink = 'Conflict of Interest (Annual) URL :  <br/> ' + coiURL + '<br/>';
            }
            else if(!isCOIAnnualReminder && isCGAnnualReminder) {
                actualSubject = 'CG Manual Acknowledgement - Please submit your annual report';
                actualDetail = 'Please submit your annual CG Manual Acknowledgement Report by click this link below to access your report.';
            	actualLink = '2. CG Manual Acknowledgement (Annual) URL : <br/>' + cgURL + '<br/>';
            }
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!Subject}', actualSubject);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!Detail}', actualDetail);
            htmlBody = htmlBody.replace('{!Link}', actualLink);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!Detail}', actualDetail);
            plainBody = plainBody.replace('{!Link}', actualLink);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            /* Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
                
            return messages[0];
        }
        
        return null;
    }
    
    //Send GiftRegistration to Supervisor Email
    public static void GiftRegistrationSupervisorEmail(string supervisorId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { supervisorId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            User Requester = [select id, email, firstname, lastname from User where Id =: CGReport.OwnerId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Gift_Registration_Supervisor'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Submitted_Date__c}', CGReport.Submitted_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send GiftRegistration to GLGC Email
    public static void GiftRegistrationGLGCEmail(string glgcId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { glgcId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            User Requester = [select id, email, firstname, lastname from User where Id =: CGReport.OwnerId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Gift_Registration_GLGC'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send GiftRegistration to GLVP Email
    public static void GiftRegistrationGLVPEmail(string glvpId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { glvpId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            User Requester = [select id, email, firstname, lastname from User where Id =: CGReport.OwnerId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Gift_Registration_GLVP_From_GLGC'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.GLGC_Action_Date__c}', CGReport.GLGC_Action_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!RequesterName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.GLGC_Action_Date__c}', CGReport.GLGC_Action_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send GiftRegistration to User when GLVP Acknowledged
    public static void GiftRegistrationUserEmailGLVPAcknowledged(string ownerId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { ownerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Gift_Registration_User_From_GLVP'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.GLVP_Action_Date__c}', CGReport.GLVP_Action_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.GLVP_Action_Date__c}', CGReport.GLVP_Action_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send GiftRegistration Acknowledged Email after Supervisor Acknowledged
    public static void GiftRegistrationUserAcknowledgedEmail(string ownerId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { ownerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Gift_Rejected_Supervisor'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	subject = subject.replace('{!SubjectDecision}', 'Acknowledge');
             
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!Decision}', CGReport.Supervisor_Approver_Status__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!Decision}', CGReport.Supervisor_Approver_Status__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email, 'puttipat@softever.co.th', 'sarocha@softever.co.th' };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send GiftRegistration Rejected Email after Supervisor rejected
    public static void GiftRegistrationUserRejectedEmail(string ownerId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { ownerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Gift_Rejected_Supervisor'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	subject = subject.replace('{!SubjectDecision}', 'Reject');
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!Decision}', CGReport.Supervisor_Approver_Status__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!Decision}', CGReport.Supervisor_Approver_Status__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Supervisor_Action_Date__c}', CGReport.Supervisor_Action_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email, 'puttipat@softever.co.th', 'sarocha@softever.co.th' };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }

    //Send GiftRegistration Email (Reminder) for user
    public static void GiftRegistrationReminderEmail(string userId, CG_Reporting__c CGReport) {
        
        string link = '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
        string URL = emailURL(link); 
        string[] receiverIds = new string[] { userId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Gift_User_Reminder'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
        	
        	string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Submit_Within_Date__c}', CGReport.Submit_Within_Date__c.format());
            htmlBody = htmlBody.replace('{!CG_Reporting__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!ReceiverName}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!CG_Reporting__c.Running_No__c}', CGReport.Running_No__c);
            plainBody = plainBody.replace('{!CG_Reporting__c.Submit_Within_Date__c}', CGReport.Submit_Within_Date__c.format());
            plainBody = plainBody.replace('{!CG_Reporting__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
        
    }
    
    public static string InitialStatusJson(string reportId, PISUsers__c PISUser) {
        
        string workflowStatus = '';
        
        List<CG_DTO.WorkflowHistoryDTO> WorkflowHistories = new List<CG_DTO.WorkflowHistoryDTO>();
        CG_DTO.WorkflowHistoryDTO WorkflowHistory = new CG_DTO.WorkflowHistoryDTO();
        
        CG_DTO.WorkflowDTO workflow = new CG_DTO.WorkflowDTO();
        workflow.createdDate = system.today();
        workflow.approvers = new List<CG_DTO.WorkflowApproverDTO>();
        CG_DTO.WorkflowApproverDTO approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.Employee.name();
        approver.role.value = CG_Enum.ApproverRole.Employee.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingForSubmit.name();
        approver.status.value = 'Waiting for Submit';
        approver.isCurrent = true;
        approver.approver = new CG_DTO.UserDTO();
        approver.approver.id = PISUser.User__c;
        approver.approver.fullName = PISUser.EN_Fullname__c ;
        approver.approver.email = PISUser.Email__c;
        workflow.approvers.add(approver);
        approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.Supervisor.name();
        approver.role.value = CG_Enum.ApproverRole.Supervisor.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingSupervisor.name();
        approver.status.value = 'Waiting Supervisor';
        approver.approver = new CG_DTO.UserDTO();
        approver.approver.id = '';
        approver.approver.fullName = '' ;
        approver.approver.email = '';
        workflow.approvers.add(approver);
        approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.GLVP.name();
        approver.role.value = CG_Enum.ApproverRole.GLVP.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingGLVP.name();
        approver.status.value = 'Waiting GLVP';
        approver.approver = new CG_DTO.UserDTO();
        approver.approver.id = '';
        approver.approver.fullName = '' ;
        approver.approver.email = '';
        workflow.approvers.add(approver);
        
        CG_Global.EnumValue status = new CG_Global.EnumValue('WaitingForSubmit');
        status.enumName = 'WaitingForSubmit';
        status.key = 'WaitingForSubmit';
        status.value = 'Waiting For Submit';
        
        WorkflowHistory.status = status;
        WorkflowHistory.currentWorkflow = Workflow;
        WorkflowHistory.reportId = reportId;
        WorkflowHistory.historyWorkflows = null;
        
        //WorkflowHistories.add(WorkflowHistory);
        
        workflowStatus = JSON.serialize(WorkflowHistory);
        
        return workflowStatus;
        
    }
    
    public static string InitialGiftStatusJson(string reportId, PISUsers__c PISUser) {
        
        string workflowStatus = '';
        
        List<CG_DTO.WorkflowHistoryDTO> WorkflowHistories = new List<CG_DTO.WorkflowHistoryDTO>();
        CG_DTO.WorkflowHistoryDTO WorkflowHistory = new CG_DTO.WorkflowHistoryDTO();
        
        CG_DTO.WorkflowDTO workflow = new CG_DTO.WorkflowDTO();
        workflow.createdDate = system.today();
        workflow.approvers = new List<CG_DTO.WorkflowApproverDTO>();
        CG_DTO.WorkflowApproverDTO approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.Employee.name();
        approver.role.value = CG_Enum.ApproverRole.Employee.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingForSubmit.name();
        approver.status.value = 'Waiting for Submit';
        approver.isCurrent = true;
        approver.isShow = true;
        approver.approver = new CG_DTO.UserDTO();
        approver.approver.id = PISUser.User__c;
        approver.approver.fullName = PISUser.EN_Fullname__c ;
        approver.approver.email = PISUser.Email__c;
        workflow.approvers.add(approver);
        approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.Supervisor.name();
        approver.role.value = CG_Enum.ApproverRole.Supervisor.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingSupervisor.name();
        approver.status.value = 'Waiting Supervisor';
        approver.approver = new CG_DTO.UserDTO();
        approver.approver.id = '';
        approver.approver.fullName = '' ;
        approver.approver.email = '';
        approver.isCurrent = false;
        approver.isShow = true;
        workflow.approvers.add(approver);
        approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.GLGC.name();
        approver.role.value = CG_Enum.ApproverRole.GLGC.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingGLGC.name();
        approver.status.value = 'Waiting GLGC';
        approver.approver = new CG_DTO.UserDTO();
        approver.approver.id = '';
        approver.approver.fullName = '' ;
        approver.approver.email = '';
        approver.isCurrent = false;
        approver.isShow = false;
        workflow.approvers.add(approver);
        approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.GLVP.name();
        approver.role.value = CG_Enum.ApproverRole.GLVP.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingGLVP.name();
        approver.status.value = 'Waiting GLVP';
        approver.approver = new CG_DTO.UserDTO();
        approver.approver.id = '';
        approver.approver.fullName = '' ;
        approver.approver.email = '';
        approver.isCurrent = false;
        approver.isShow = false;
        workflow.approvers.add(approver);
        
        CG_Global.EnumValue status = new CG_Global.EnumValue('WaitingForSubmit');
        status.enumName = 'WaitingForSubmit';
        status.key = 'WaitingForSubmit';
        status.value = 'Waiting For Submit';
        
        WorkflowHistory.status = status;
        WorkflowHistory.currentWorkflow = Workflow;
        WorkflowHistory.reportId = reportId;
        WorkflowHistory.historyWorkflows = null;
        
        //WorkflowHistories.add(WorkflowHistory);
        
        workflowStatus = JSON.serialize(WorkflowHistory);
        
        return workflowStatus;
        
    }
    
    public static boolean CheckDurationJson(string duration, datetime generatedReportDT) {
        
        boolean isGenerated = false;
        
        List<CG_DTO.DurationDTO> DurationDTOs = (List<CG_DTO.DurationDTO>)JSON.deserialize(duration, List<CG_DTO.DurationDTO>.class);
        
        generatedReportDT = CG_ReportingHandler.ConvertToCurrentTimeZoneDateTime(generatedReportDT);
        
        System.debug(DurationDTOs.size());
        if(DurationDTOs.size() > 0) {
            
            for(CG_DTO.DurationDTO existDuration : DurationDTOs) {
                if(generatedReportDT > existDuration.startDate && generatedReportDT < existDuration.endDate) {
                    isGenerated = true;
                }
            }
        }
        
        return isGenerated;
        
    }
    
    public static DateTime ConvertToCurrentTimeZoneDateTime(DateTime currentDatetTime) {
        
        TimeZone tz = UserInfo.getTimeZone();
        currentDatetTime = currentDatetTime.addSeconds((tz.getOffset(currentDatetTime)/1000));
        return currentDatetTime;
        
    }
    
    @auraEnabled
    public static List<String> CGReportingStatuses(){
       List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = CG_Reporting__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getValue());
		}     
		return pickListValuesList;
    }
    
    @auraEnabled
    public static List<String> CGReportingTypes(){
       List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = CG_Reporting__c.Type_of_Report__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getValue());
		}     
		return pickListValuesList;
    }
    
    @auraEnabled
    public static List<String> CGReportingCOIDisclosure(){
       List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = CG_Reporting__c.COI_Disclosure__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getValue());
		}     
		return pickListValuesList;
    }
    
    public static string emailURL(string link) {
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/?ec=302&startURL=';
        string encodedURL = EncodingUtil.urlEncode(link,'UTF-8');
        URL += encodedURL;
        return URL;
    }
    
}