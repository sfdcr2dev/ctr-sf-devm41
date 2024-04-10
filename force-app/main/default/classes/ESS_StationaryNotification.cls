public with sharing class ESS_StationaryNotification {

    private static string environment = [select environment__c from ess_config__c].environment__c; 
    private static string orgId = UserInfo.getOrganizationId();
    private static Map<string, EmailTemplate> mapEmailTemplates;
    private static Map<string, Group> mapPublicGroups;
    private static List<string> publicGroupIds;
    private static Map<string, PISUsers__c> mapPISUsers;
    private static Map<string, User> mapUsers;
    private static Map<string, List<GroupMember>> mapGroupMembers;    
    static {
        ESS_StationaryNotification.AllEmailTemplates();
        ESS_StationaryNotification.AllPublicGroups();
        ESS_StationaryNotification.AllPISUsers();
        ESS_StationaryNotification.AllUsers();
        ESS_StationaryNotification.AllPublicGroupMembers();
    }
    
    private static void AllEmailTemplates() {
        mapEmailTemplates = new Map<string, EmailTemplate>();
        Id folderId = [SELECT Id, name, developername FROM Folder where developername = 'ESS_Template'].Id;
        string developerName = '%Stationary%';
        List<EmailTemplate> emailTemplates = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate where FolderId = :folderId AND developername like :developerName];
        if(emailTemplates.size() > 0) {
            for(EmailTemplate ET : emailTemplates) {
                mapEmailTemplates.put(ET.DeveloperName, ET);
            }
        }
    }
    
    private static void AllPublicGroups() {
        publicGroupIds = new List<string>();
        mapPublicGroups = new Map<string, Group>();
        List<string> essPublicGroups = new List<string> {'ESS_PMSV_Stationary','ESS_GSBO_Stationary'};
        List<Group> publicGroups = [select id, developername from Group where developername IN :essPublicGroups];
        if(publicGroups.size() > 0) {
            for(Group G : publicGroups) {
                mapPublicGroups.put(G.DeveloperName, G);
                publicGroupIds.add(G.Id);
            }
        }
    }
    
    private static void AllPISUsers() {
        mapPISUsers = new Map<string, PISUsers__c>();
        List<PISUsers__c> PISUsers = [select id, User__c, HOME_COMP__c, Email__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPISUsers.put(PISUser.User__c, PISUser);
            }
        }
    }
    
    private static void AllPublicGroupMembers() {
        mapGroupMembers = new Map<string, List<GroupMember>>();
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId IN :publicGroupIds];
        if(Members.size() > 0) {
            for(GroupMember Member : Members) {
                if(mapGroupMembers.containsKey(Member.GroupId))
                {
                    mapGroupMembers.get(Member.GroupId).add(Member);
                }
                else {
                    mapGroupMembers.put(Member.GroupId, new  List<GroupMember> { Member });
                }
            } 
        }
    }
    
    private static void AllUsers() {
        mapUsers = new Map<string, User>();
        List<User> Users = [select id, email, firstname, lastname from User where isActive = true];
        if(Users.size() > 0) {
            for(User U : Users) {
                mapUsers.put(U.Id, U);
            }
        }
    }
    
    //SS-01 - (กรณี On Behalf of) ส่งอีเมลไปยังพนักงาน หลัง Employee Admin ทำการ Submit ขอเบิกอุปกรณ์ (with CC)
    public static void SendToEmployeeWhenRequesterSubmitOnBehalf(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_01');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_01');
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!RequesterName}', model.Requester_Name_EN__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ model.On_Behalf_Of_Email__c };
        message.setToAddresses(message.toAddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Email to Employee Admin (requester)
        ccEmails.add(model.Requester_Email__c);
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //If not User Manager Flow CC ReportToUser
        if(!model.User_Manager_Flow__c) {
            if(string.isNotEmpty(model.CC_Email__c)) {
                ccAddresses.add(model.CC_Email__c);
            }
        }
        
        //CC Admin Group
        if(!isGSBO) {
            Set<string> ccAdminEmails = sendEmailForAdminPMSV();
            ccAddresses.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = sendEmailForAdminGSBO();
            ccAddresses.addAll(ccAdminEmails);
        }

        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
           
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    //SS-02 - ส่งอีเมลไปยังพนักงานเพื่อแจ้งว่าได้ทำการ Submit การขอเบิกอุปกรณ์แล้ว
    public static void SendToEmployeeWhenSubmit(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_02');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_02');
        }
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User receiveByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            receiver = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            
            if(isPRTRRequester) {
                receiveByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
            }
            else {
                receiver = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
            }
        }
        else {
            if(isPRTRRequester) {
                receiveByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
            }
            else {
                receiver = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
            }
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        if(isPRTRRequester) {
            htmlBody = htmlBody.replace('{!ReceiverName}', receiveByUser.FirstName + ' ' + receiveByUser.LastName);
        }
        else {
            htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        }
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        if(isPRTRRequester) {
            plainBody = plainBody.replace('{!ReceiverName}', receiveByUser.FirstName + ' ' + receiveByUser.LastName);
        }
        else {
            plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        }
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        if(isPRTRRequester) {
            message.toAddresses.add(receiveByUser.Email);
        }
        else {
            message.toAddresses.add(receiver.Email__c);
        }
        
        message.setToAddresses(message.toAddresses);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);

        List<string> ccAddresses = new List<string>();
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        //If not User Manager Flow CC ReportToUser
        if(!model.User_Manager_Flow__c) {
            if(string.isNotEmpty(model.CC_Email__c)) {
                ccAddresses.add(model.CC_Email__c);
            }
        }
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    //SS-03 - (กรณี On Behalf of) ส่งอีเมลแจ้งผลไปยัง Employee Admin หลัง Employee ทำการ Reject
    public static void SendToEmployeeAdminWhenEmployeeRejectOnBehalf(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Employee Admin And Employee
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_03');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_03');
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        string rejectComment = '';
        if(string.isNotEmpty(model.Reject_Comment__c)) {
            rejectComment = model.Reject_Comment__c;
        }
        
        //Send email to Requester and CC Admin Stationary, Verifier
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', model.Requester_Name_EN__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!RejectComment}', rejectComment);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', model.Requester_Name_EN__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!RejectComment}', rejectComment);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ model.Requester_Email__c };
        message.setToAddresses(message.toAddresses);
            
        List<string> ccAddresses = new List<string>();
        ccAddresses.add(model.On_Behalf_Of_Email__c);
        
        //CC Admin Group
        if(!isGSBO) {
            Set<string> ccAdminEmails = sendEmailForAdminPMSV();
            ccAddresses.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = sendEmailForAdminGSBO();
            ccAddresses.addAll(ccAdminEmails);
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        //If not User Manager Flow CC ReportToUser
        if(!model.User_Manager_Flow__c) {
            if(string.isNotEmpty(model.CC_Email__c)) {
                ccAddresses.add(model.CC_Email__c);
            }
        }
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
         
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
        
    }
    
    //SS-04 - (กรณี On Behalf of) ส่งอีเมลแจ้งผลไปยัง Employee Admin หลัง Employee ทำการ Verify (ยกเลิกไม่ใช้งาน)
    public static void SendToEmployeeAdminWhenEmployeeVerifyOnBehalf(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_04');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_04');
        }
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User receiveByUser = new User();
        User requestByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            if(isPRTRRequester) {
                receiveByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
                requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
            }
            else {
                receiver = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
            }
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        if(isPRTRRequester) {
            htmlBody = htmlBody.replace('{!ReceiverName}', receiveByUser.FirstName + ' ' + receiveByUser.LastName);
        }
        else {
            htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        }
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', onBehalf.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', onBehalf.EN_Fullname__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        if(isPRTRRequester) {
            plainBody = plainBody.replace('{!ReceiverName}', receiveByUser.FirstName + ' ' + receiveByUser.LastName);
        }
        else {
            plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        }
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', onBehalf.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', onBehalf.EN_Fullname__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.toAddresses = new List<String> { model.Requester_Email__c };
        message.setToAddresses(message.toAddresses);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        
        List<string> ccAddresses = new List<string>();
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        //If not User Manager Flow CC ReportToUser
        if(!model.User_Manager_Flow__c) {
            if(string.isNotEmpty(model.CC_Email__c)) {
                ccAddresses.add(model.CC_Email__c);
            }
        }
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    //SS-05 - ส่งอีเมลไปยัง User Manager (Report to) 
    public static void SendToUserManagerWhenEmployeeSubmit(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_05');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_05');
        }
        
        PISUsers__c receiver; //UserManager
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User receiveByUser = new User();
        User requestByUser = new User();
        
        receiver = ESS_Global.assignToPISUser(
            model.User_Manager_Id__c
        );
        
        if(isPRTRRequester) {
            requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
            );
        }
        else {
            requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
            );
        }
        
        if (model.On_Behalf_Flow__c) {
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toAddresses);
        List<string> ccAddresses = new List<string>();
        
        //CC Requester, OBH and Report to (if any)
        ccAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Of_Flow__c) {
            ccAddresses.add(model.On_Behalf_Of_Email__c);
        }
        if(string.isNotBlank(model.CC_Email__c)) {
            ccAddresses.add(model.CC_Email__c);
        }
        
        //CC Admin Group
        if(!isGSBO) {
            Set<string> ccAdminEmails = sendEmailForAdminPMSV();
            ccAddresses.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = sendEmailForAdminGSBO();
            ccAddresses.addAll(ccAdminEmails);
        }
                
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        //If Level under Section Head CC ReportToUser
        if(model.User_Manager_Flow__c) {
            if(model.CC_Level__c != null && (model.CC_Level__c == 'Junior' || model.CC_Level__c == 'Senior' || model.CC_Level__c == 'Supervisor')) {
                ccAddresses.add(model.CC_Email__c);
            }
        }
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
          
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    //SS-06 - ส่งอีเมลแจ้งไปยัง Admin PMSV ว่ามีการขอเบิกอุปกรณ์ (with CC)
    public static void SendToAdminPMSVWhenRequested(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Find Admin PMSV
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        Set<User> Users = new Set<User>();
        List<string> withdrawFroms = model.Withdraw_From__c.split(',');
        for(string withdrawFrom : withdrawFroms) {
            if(withdrawFrom == ESS_Enum.StationaryPrivilege.TSR.name()) {
                List<PISUsers__c> AdminPMSVs = ESS_Global.assignToESSPMSVStationaryPISUser();
                if(AdminPMSVs.size() > 0) {
                    for(PISUsers__c AdminPMSV : AdminPMSVs) {
                        PISUsers.add(AdminPMSV);
                    }
                }
                List<User> AdminPMSVPRTRs = ESS_Global.assignToESSPMSVStationaryPRTR();
                if(AdminPMSVPRTRs.size() > 0) {
                    for(User AdminPMSV : AdminPMSVPRTRs) {
                        Users.add(AdminPMSV);
                    }
                }
            }
            else if(withdrawFrom == ESS_Enum.StationaryPrivilege.TBK.name()) {
                List<PISUsers__c> AdminGSBOs = ESS_Global.assignToESSGSBOStationaryPISUser();
                if(AdminGSBOs.size() > 0) {
                    for(PISUsers__c AdminGSBO : AdminGSBOs) {
                        PISUsers.add(AdminGSBO);
                    }
                }
                List<User> AdminPMSVPRTRs = ESS_Global.assignToESSGSBOStationaryPRTR();
                if(AdminPMSVPRTRs.size() > 0) {
                    for(User AdminPMSV : AdminPMSVPRTRs) {
                        Users.add(AdminPMSV);
                    }
                }
            }
        }
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_06');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_06');
        }
        
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User receiveByUser = new User();
        User requestByUser = new User();
        
        if(isPRTRRequester) {
            requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
            );
        }
        else {
            requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
            );
        }
        
        if (model.On_Behalf_Flow__c) {
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        if(model.On_Behalf_Flow__c) {
            subject = subject.replace('{!RequesterName}', model.On_Behalf_Of_EN__c);
        }
        else {
            subject = subject.replace('{!RequesterName}', model.Requester_Name_EN__c);
        }
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!RequesterName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        }
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!RequesterName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        }
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
            
        //Send Email to Admin PMSV
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                message.toAddresses.add(PISUser.Email__c);
            }
        }
        if(Users.size() > 0) {
            for(User User : Users) {
                message.toAddresses.add(User.Email);
            }
        }
        message.setToAddresses(message.toAddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Email to Employee Admin , Employee, Report To (if any)
        ccEmails.add(model.Requester_Email__c);       
        if(model.On_Behalf_Flow__c) {
            ccEmails.add(model.On_Behalf_Of_Email__c);
        }
        if(string.isNotBlank(model.CC_Email__c)) {
            ccEmails.add(model.CC_Email__c);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //If not User Manager Flow CC ReportToUser
        if(!model.User_Manager_Flow__c) {
            if(string.isNotEmpty(model.CC_Email__c)) {
                ccAddresses.add(model.CC_Email__c);
            }
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //SS-07 - ส่งอีเมลแจ้งผลไปยัง Employee/Employee Admin ว่ามีการปิดใบงานเรียบร้อยแล้ว
    public static void SendToEmployeeAndEmployeeAdminWhenCompleted(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Find Admin PMSV
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_07');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_07');
        }
        
        PISUsers__c onBehalf;
        
        if (model.On_Behalf_Flow__c) {
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            PISUsers.add(onBehalf);
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }
        string staffComment = '';
        if(string.isNotEmpty(model.Staff_Comment__c)) {
            staffComment = model.Staff_Comment__c;
        }
        string employeeId = '';
        if(string.isNotEmpty(model.Requester_Employee_Id__c)) {
            employeeId = model.Requester_Employee_Id__c;
        }

        Map<string, string> statuses = GetAllStatuses();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!PMSVComment}', staffComment);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!PMSVComment}', staffComment);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        message.toAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            message.toAddresses.add(model.On_Behalf_Of_Email__c);
        }
        message.setToAddresses(message.toaddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Admin Group
        if(!isGSBO) {
            Set<string> ccAdminEmails = sendEmailForAdminPMSV();
            ccAddresses.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = sendEmailForAdminGSBO();
            ccAddresses.addAll(ccAdminEmails);
        }
        
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //If not User Manager Flow CC ReportToUser
        if(!model.User_Manager_Flow__c) {
            if(string.isNotEmpty(model.CC_Email__c)) {
                ccAddresses.add(model.CC_Email__c);
            }
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //SS-08 - กรณี ของนอกคลัง ส่งอีเมลแจ้งผลไปยัง Stationary Admin ว่ามีการปิดใบงานเรียบร้อยแล้ว
    public static void SendToEmployeeAndEmployeeAdminWhenUserManagerApprove(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Find Admin PMSV
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        Set<User> Users = new Set<User>();
        List<string> withdrawFroms = model.Withdraw_From__c.split(',');
        for(string withdrawFrom : withdrawFroms) {
            if(withdrawFrom == ESS_Enum.StationaryPrivilege.TSR.name()) {
                List<PISUsers__c> AdminPMSVs = ESS_Global.assignToESSPMSVStationaryPISUser();
                if(AdminPMSVs.size() > 0) {
                    for(PISUsers__c AdminPMSV : AdminPMSVs) {
                        PISUsers.add(AdminPMSV);
                    }
                }
                List<User> AdminPMSVPRTRs = ESS_Global.assignToESSPMSVStationaryPRTR();
                if(AdminPMSVPRTRs.size() > 0) {
                    for(User AdminPMSV : AdminPMSVPRTRs) {
                        Users.add(AdminPMSV);
                    }
                }
            }
            else if(withdrawFrom == ESS_Enum.StationaryPrivilege.TBK.name()) {
                List<PISUsers__c> AdminGSBOs = ESS_Global.assignToESSGSBOStationaryPISUser();
                if(AdminGSBOs.size() > 0) {
                    for(PISUsers__c AdminGSBO : AdminGSBOs) {
                        PISUsers.add(AdminGSBO);
                    }
                }
                List<User> AdminPMSVPRTRs = ESS_Global.assignToESSGSBOStationaryPRTR();
                if(AdminPMSVPRTRs.size() > 0) {
                    for(User AdminPMSV : AdminPMSVPRTRs) {
                        Users.add(AdminPMSV);
                    }
                }
            }
        }
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_08');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_08');
        }
        
        PISUsers__c requester;
        PISUsers__c onBehalf;
        PISUsers__c userManager;
        
        userManager = ESS_Global.assignToPISUser(
            model.User_Manager_Id__c
        );
        
        if (model.On_Behalf_Flow__c) {
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
            
        //Send Email to Admin PMSV
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                message.toAddresses.add(PISUser.Email__c);
            }
        }
        if(Users.size() > 0) {
            for(User User : Users) {
                message.toAddresses.add(User.Email);
            }
        }
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Requester, OnBehalfOf, UserManager
        ccAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            ccAddresses.add(model.On_Behalf_Of_Email__c);
        }
        if(model.User_Manager_Flow__c) {
            ccAddresses.add(userManager.EMAIL__c);
        }
        if(string.isNotEmpty(model.CC_Email__c)) {
            ccAddresses.add(model.CC_Email__c);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }

        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //SS-09 - กรณี ของนอกคลัง ส่งอีเมลแจ้งผลไปยัง Employee/Employee Admin ว่ามีการ Reject ใบงาน
    public static void SendToEmployeeAndEmployeeAdminWhenUserManagerRejected(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_09');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_09');
        }
        
        PISUsers__c requester;
        PISUsers__c onBehalf;
        PISUsers__c userManager;
        
        userManager = ESS_Global.assignToPISUser(
            model.User_Manager_Id__c
        );
        
        if (model.On_Behalf_Flow__c) {
            onBehalf = ESS_Global.assignToPISUser(
                model.On_Behalf_Of_Id__c
            );
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }
        string rejectComment;
        if (string.isNotEmpty(model.Reject_Comment__c)) {
            rejectComment = model.Reject_Comment__c;
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!ApprovalName}', userManager.EN_Fullname__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        htmlBody = htmlBody.replace('{!ApprovalName}', userManager.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!RejectComment}', rejectComment);
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        plainBody = plainBody.replace('{!ApprovalName}', userManager.EN_Fullname__c);
        plainBody = plainBody.replace('{!RejectComment}', rejectComment);
        
        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        message.toAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            message.toAddresses.add(model.On_Behalf_Of_Email__c);
        }
        message.setToAddresses(message.toaddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Admin Group
        if(!isGSBO) {
            Set<string> ccAdminEmails = sendEmailForAdminPMSV();
            ccAddresses.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = sendEmailForAdminGSBO();
            ccAddresses.addAll(ccAdminEmails);
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
        	List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
    	}
        
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //SS-10 - กรณี Accept ใบงาน
    public static void SendToEmployeeAndEmployeeAdminWhenAccepted(ESS_Stationary__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Stationary_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        PISUsers__c userManager;
        if(model.User_Manager_Flow__c) {
            userManager = ESS_Global.assignToPISUser(
                model.User_Manager_Id__c
            );
        }
        
        EmailTemplate emailTemplate = new EmailTemplate();
        boolean isGSBO = false;
        if(model.Withdraw_From__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            emailTemplate = GetEmailTemplate('Stationary_SS_GSBO_10');
            isGSBO = true;
        }
        else {
            emailTemplate = GetEmailTemplate('Stationary_SS_10');
        }
        
        string deliveryDate = '';
        if (model.Delivery_Date__c != null) {
            deliveryDate = formatDate(model.Delivery_Date__c);
        }
        string acceptedComment = '';
        if (string.isNotEmpty(model.Accepted_Comment__c)) {
            acceptedComment = model.Accepted_Comment__c;
        }

        Map<string, string> statuses = GetAllStatuses();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!DeliveryDate}', deliveryDate);
        htmlBody = htmlBody.replace('{!AcceptedComment}', acceptedComment);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!DeliveryDate}', deliveryDate);
        plainBody = plainBody.replace('{!AcceptedComment}', acceptedComment);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        message.toAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            message.toAddresses.add(model.On_Behalf_Of_Email__c);
        }
        message.setToAddresses(message.toaddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        if(model.User_Manager_Flow__c) {
            ccAddresses.add(userManager.EMAIL__c);
        }
        
        //CC Admin Group
        if(!isGSBO) {
            Set<string> ccAdminEmails = sendEmailForAdminPMSV();
            ccAddresses.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = sendEmailForAdminGSBO();
            ccAddresses.addAll(ccAdminEmails);
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails(isGSBO);
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            boolean isCCAddressNull = ccAddresses.contains(null);
            if(isCCAddressNull) {
                string errorMessage = ErrorMessage(1);
                throw new ESS_Exception(errorMessage);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    private static Map<string, string> GetAllStatuses()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Stationary__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getValue(), objPickList.getLabel());
        }
        return statuses;
    }

    public static string formatDate(Datetime d) {
        DateTime newDT = system.Datetime.newInstance(d.year(), d.month(), d.day());
        string convertedDate = newDT.format('dd/MM/yyyy');
        return convertedDate;
    }
    
    public static List<string> ccEmails(boolean isGSBO) {
        List<string> ccAddresses = new List<string>();
        ccAddresses.add('pirapornw@thaioilgroup.com');
        ccAddresses.add('suphattra@thaioilgroup.com');
        ccAddresses.add('sarocha@softever.co.th');
        ccAddresses.add('atittaya@softever.co.th');
        ccAddresses.add('sinlapat@softever.co.th');
        ccAddresses.add('puttipat@softever.co.th');
        ccAddresses.add('pipat@thaioilgroup.com');
        ccAddresses.add('thanida@thaioilgroup.com');
        ccAddresses.add('kanlayat@thaioilgroup.com');
        if(isGSBO) {
            ccAddresses.add('kanokwan@thaioilgroup.com');
            ccAddresses.add('kawinthida@thaioilgroup.com');
            ccAddresses.add('chanikan@thaioilgroup.com');
            ccAddresses.add('zjirapornv@thaioilgroup.com');
        }
        return ccAddresses;
    }
    
    public static string LinkURL(string URL, string documentNo) {
        string returnURL = '<a href=\'' + URL + '\'>' + documentNo + '</a>';
        return returnURL;
    }
    
    public static string ErrorMessage(integer no) {
        string errorMessage = '';
        if(no == 1) {
            errorMessage = '[MyError]พบ CC Email เป็น null กรุณาตรวจสอบเรื่อง CC Email';
        }
        return errorMessage;
    }
    
    public static EmailTemplate GetEmailTemplate(string emailTemplateName) {
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate = [
            SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
            FROM EmailTemplate
            WHERE developername = :emailTemplateName
            ];
        return emailTemplate;        
    }
    
    public static List<User> assignToESSPMSVUser(string publicGroupName) {
        List<User> Users = new List<User>();
        //Find from Group ESS PMSV Admin
        Group AdminGroup = mapPublicGroups.get(publicGroupName);
        List<GroupMember> Members = mapGroupMembers.get(AdminGroup.Id);
        if(Members.size() > 0) {
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    User User = mapUsers.get(MemberUserId);
                    Users.add(User);
                }
            }
        }
        return Users;
    }
    
    public static List<PISUsers__c> assignToESSPMSVPISUser(string publicGroupName) {
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        //Find from Group ESS Admin
        Group AdminGroup = mapPublicGroups.get(publicGroupName);
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        if(Members.size() > 0) {
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = ESS_Global.PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
        }
        return PISUsers;
    }
    
    public static Set<string> sendEmailForAdminPMSV() {
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = assignToESSPMSVUser('ESS_PMSV_Stationary');
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = assignToESSPMSVPISUser('ESS_PMSV_Stationary');
        AdminPISUsers.addAll(AdminPMSVs);
        
        if(AdminPISUsers.size() > 0) {
            for(PISUsers__c PISUser : AdminPISUsers) {
                ccEmails.add(PISUser.EMAIL__c);
            }
        }
        if(AdminUsers.size() > 0) {
            for(User User : AdminUsers) {
                ccEmails.add(User.Email);
            }
        }
        
        return ccEmails;
    }
    
    public static Set<string> sendEmailForAdminGSBO() {
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = assignToESSPMSVUser('ESS_GSBO_Stationary');
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = assignToESSPMSVPISUser('ESS_GSBO_Stationary');
        AdminPISUsers.addAll(AdminPMSVs);
        
        if(AdminPISUsers.size() > 0) {
            for(PISUsers__c PISUser : AdminPISUsers) {
                ccEmails.add(PISUser.EMAIL__c);
            }
        }
        if(AdminUsers.size() > 0) {
            for(User User : AdminUsers) {
                ccEmails.add(User.Email);
            }
        }
        
        return ccEmails;
    }
    
}