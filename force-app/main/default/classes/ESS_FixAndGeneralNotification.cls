public with sharing class ESS_FixAndGeneralNotification {
    
    private static string orgId = UserInfo.getOrganizationId();
    private static Map<string, EmailTemplate> mapEmailTemplates;
    private static Map<string, Group> mapPublicGroups;
    private static List<string> publicGroupIds;
    private static Map<string, PISUsers__c> mapPISUsers;
    private static Map<string, User> mapUsers;
    private static Map<string, List<GroupMember>> mapGroupMembers;
    static {
        ESS_FixAndGeneralNotification.AllEmailTemplates();
        ESS_FixAndGeneralNotification.AllPublicGroups();
        ESS_FixAndGeneralNotification.AllPISUsers();
        ESS_FixAndGeneralNotification.AllUsers();
        ESS_FixAndGeneralNotification.AllPublicGroupMembers();
    }
    
    private static void AllEmailTemplates() {
        mapEmailTemplates = new Map<string, EmailTemplate>();
        Id folderId = [SELECT Id, name, developername FROM Folder where developername = 'ESS_Template'].Id;
        string developerName = '%FixAndGeneral%';
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
        List<string> essPublicGroups = new List<string> {'ESS_PMSV','ESS_PMSV_Transportation','ESS_PMSV_FixAndGeneral'};
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
    
    //FIX-01 - ส่งหา Employee ตอน Employee Admin Submit
    public static void SendToEmployeeWhenRequesterSubmitOnBehalf(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_01'
        ];
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            receiver = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            onBehalf = receiver;
            
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
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }
        string dueDate;
        if (model.Expected_Due_Date__c != null) {
            dueDate = formatDate(model.Expected_Due_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        if(isPRTRRequester) {
            subject = subject.replace('{!RequesterName}', requestByUser.FirstName + ' ' + requestByUser.LastName);
        }
        else {
            subject = subject.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        if(isPRTRRequester) {
            htmlBody = htmlBody.replace('{!RequesterName}', requestByUser.FirstName + ' ' + requestByUser.LastName);
        }
        else {
            htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!DueDate}', dueDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        if(isPRTRRequester) {
            plainBody = plainBody.replace('{!RequesterName}', requestByUser.FirstName + ' ' + requestByUser.LastName);
        }
        else {
            plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!DueDate}', dueDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        if(isPRTRRequester) {
            message.toAddresses.add(requestByUser.Email);
        }
        else {
            message.toAddresses.add(receiver.EMAIL__c);
        }
        message.setToAddresses(message.toAddresses);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Email Requester (Employee Admin)
        if(isPRTRRequester) {
            ccEmails.add(requestByUser.Email);
        }
        else {
            ccEmails.add(requester.EMAIL__c);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        
        //CC Admin Group
        if(!isTransportation) {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVFixAndGeneral();
            ccEmails.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVTransportation();
            ccEmails.addAll(ccAdminEmails);
        }
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> testCCEmails = ccEmails(isTransportation);
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        } */
        
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        }
            
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
    
    //FIX-02 - ส่งหา Employee Admin ตอน Employee ทำการ Reject
    public static void SendToEmployeeAdminWhenEmployeeReject(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_02'
        ];
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        User receiveByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            
            if(isPRTRRequester) {
                requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
                receiveByUser = requestByUser;
            }
            else {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
                receiver = requester;
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
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        string rejectComment = '';
        if(string.isNotEmpty(model.Reject_Comment__c)) {
            rejectComment = model.Reject_Comment__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        subject = subject.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);

        string htmlBody = emailTemplate.HtmlValue;
        if(isPRTRRequester) {
            htmlBody = htmlBody.replace('{!RequesterName}', requestByUser.FirstName + ' ' + requestByUser.LastName);
        }
        else {
            htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!Comment}', rejectComment);
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        if(isPRTRRequester) {
            plainBody = plainBody.replace('{!RequesterName}', requestByUser.FirstName + ' ' + requestByUser.LastName);
        }
        else {
            plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!Comment}', rejectComment);
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        if(isPRTRRequester) {
            message.toAddresses.add(requestByUser.Email);
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
        Set<string> ccEmails = new Set<string>();
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        
        //CC Admin Group
        if(!isTransportation) {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVFixAndGeneral();
            ccEmails.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVTransportation();
            ccEmails.addAll(ccAdminEmails);
        }
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> testCCEmails = ccEmails(isTransportation);
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        } */
        
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
    
    //FIX-03 - ส่งหา Employee Admin ตอน Employee ทำการ Verify
    public static void SendToEmployeeAdminWhenEmployeeVerify(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_03'
        ];
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        User receiveByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            
            if(isPRTRRequester) {
                requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
                receiveByUser = requestByUser;
            }
            else {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
                receiver = requester;
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
        string dueDate;
        if (model.Expected_Due_Date__c != null) {
            dueDate = formatDate(model.Expected_Due_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!DueDate}', dueDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!DueDate}', dueDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        if(isPRTRRequester) {
            message.toAddresses.add(requestByUser.Email);
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
        Set<string> ccEmails = new Set<string>();
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        
        //CC Admin Group
        if(!isTransportation) {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVFixAndGeneral();
            ccEmails.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVTransportation();
            ccEmails.addAll(ccAdminEmails);
        }
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> testCCEmails = ccEmails(isTransportation);
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        } */
        
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
    
    //FIX-04 - ส่งหา Admin และ CC Requester / Verifier หลังมีการยกเลิกการแจ้งซ่อม (Requester กดยกเลิก)
    public static void SendToEmployeeAndAdminPMSVWhenCancel(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_04'
        ];
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        User receiveByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            receiver = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            onBehalf = receiver;
            
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
        }
        else {
            if(isPRTRRequester) {
                requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
                receiveByUser = requestByUser;
            }
            else {
                receiver = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
                requester = receiver;
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
        string cancelledDate;
        if (model.Cancelled_Date__c != null) {
            cancelledDate = formatDate(model.Cancelled_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        subject = subject.replace('{!CancelledBy}', model.Cancelled_By__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!CancelledBy}', model.Cancelled_By__c);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!Comment}', model.Cancel_Comment__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!CancelledBy}', model.Cancelled_By__c);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!Comment}', model.Cancel_Comment__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        
        //CC Admin Group
        if(!isTransportation) {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVFixAndGeneral();
            message.toAddresses.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVTransportation();
            message.toAddresses.addAll(ccAdminEmails);
        }
        
        message.setToAddresses(message.toAddresses);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);

        //CC Email for Employee Admin (if On Behalf Of)
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        ccEmails.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            ccEmails.add(model.On_Behalf_Of_Email__c);
        }
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> testCCEmails = ccEmails(isTransportation);
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        } */

        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
    
    //FIX-04 - ส่งหา Requester / Verifier and CC Admin (Admin กดยกเลิก)
    public static void SendToEmployeeAndCCAdminWhenAdminCancel(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_04'
        ];
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        User receiveByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            receiver = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            onBehalf = receiver;
            
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
        }
        else {
            if(isPRTRRequester) {
                requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
                receiveByUser = requestByUser;
            }
            else {
                receiver = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
                requester = receiver;
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
        string cancelledDate;
        if (model.Cancelled_Date__c != null) {
            cancelledDate = formatDate(model.Cancelled_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        subject = subject.replace('{!CancelledBy}', model.Cancelled_By__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!CancelledBy}', model.Cancelled_By__c);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!Comment}', model.Cancel_Comment__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!CancelledBy}', model.Cancelled_By__c);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!Comment}', model.Cancel_Comment__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        message.toAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            message.toAddresses.add(model.On_Behalf_Of_Email__c);
        }
        message.setToAddresses(message.toAddresses);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);

        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        
        //CC Admin Group
        if(!isTransportation) {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVFixAndGeneral();
            ccEmails.addAll(ccAdminEmails);
        }
        else {
            Set<string> ccAdminEmails = ccEmailForAdminPMSVTransportation();
            ccEmails.addAll(ccAdminEmails);
        }
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> testCCEmails = ccEmails(isTransportation);
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        } */

        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        }
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
    
    //FIX-05 - ส่งหา Admin PMSV (PISUser) ว่ามีการแจ้งซ่อม
    public static void SendToAdminPMSVWhenRequested(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        
        //Find Admin PMSV
        Set<PISUsers__c> PISUsers = sendEmailForAdminPMSVPISUser(isTransportation);
        
        //Find Admin PMSV (User)
        Set<User> Users = sendEmailForAdminPMSVUser(isTransportation);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_05'
        ];
        
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            
            onBehalf = ESS_Global.assignToPISUser(
                model.On_Behalf_Of_Id__c
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
        }
        else {
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
            
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }
        string cancelledDate;
        if (model.Cancelled_Date__c != null) {
            cancelledDate = formatDate(model.Cancelled_Date__c);
        }
        string dueDate;
        if (model.Expected_Due_Date__c != null) {
            dueDate = formatDate(model.Expected_Due_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
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
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        subject = subject.replace('{!TypeOfService}', services.get(model.Type_of_Service__c));
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        string employeeId = '';
        if(string.isNotEmpty(model.Requester_Employee_Id__c)) {
            employeeId = model.Requester_Employee_Id__c;
        }
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!RequesterName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        }
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!DueDate}', dueDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        string plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!RequesterName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        }
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!DueDate}', dueDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
            
        //Send Email to Admin PMSV (PIS User)
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                message.toAddresses.add(PISUser.Email__c);
            }
        }
        
        //Send Email to Admin PMSV (User)
        if(Users.size() > 0) {
            for(User User : Users) {
                message.toAddresses.add(User.Email);
            }
        }
        message.setToAddresses(message.toAddresses);
        
        //cc email for requester
        List<string> ccAddresses = new List<string>();
        ccAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            ccAddresses.add(model.On_Behalf_Of_Email__c);
        }
        
        //cc email for test
        //List<string> ccTestEmailAddresses = ccEmails(isTransportation);
        //ccAddresses.addAll(ccTestEmailAddresses);
        message.setCcAddresses(ccAddresses);
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
    
    //FIX-06 - ส่งหา Employee และ Employee Admin ว่าใบงานมีการดำเนินการ หรือ Accepted แล้ว
    public static void SendToAdminPMSVWhenAccepted(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_06'
        ];
        
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        User receiveByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            receiver = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            onBehalf = receiver;
            
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
        }
        else {
            receiver = ESS_Global.assignToPISUser(
                model.Requester_Id__c
            );
            if(isPRTRRequester) {
                requestByUser = ESS_Global.assignToUser(
                    model.Requester_Id__c
                );  
            }
            else {
                requester = receiver;
            }
            
        }
        
        boolean isPRTRAdmin = model.Is_PRTR_Admin__c;
        PISUsers__c acceptBy = new PISUsers__c();
        User acceptByUser = new User();
        
        if(!isPRTRAdmin) {
            acceptBy = ESS_Global.assignToPISUser(
            model.PMSV_Id__c
            );
        }
        else {
            acceptByUser = ESS_Global.assignToUser(
            model.PMSV_Id__c
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
        string acceptedDate;
        if (model.Accepted_Date__c != null) {
            acceptedDate = formatDate(model.Accepted_Date__c);
        }
        string dueDate;
        if (model.Expected_Due_Date__c != null) {
            dueDate = formatDate(model.Expected_Due_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!AdministratorName}', model.PMSV__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!DueDate}', dueDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = htmlBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!DueDate}', dueDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);  
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toAddresses);
            
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        //cc email for test
        //List<string> ccAddresses = ccEmails(isTransportation);
        //message.setCcAddresses(ccAddresses);
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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

    //FIX-07 - ส่งหา Employee และ Employee Admin ว่ามีการแจ้งซ่อมได้ดำเนินการเรียบร้อยแล้ว และให้เข้าไปประเมินการใช้บริการ
    public static void SendToEmployeeAndAdminWhenCompleted(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'FixAndGeneral_FIX_07'
        ];
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        User receiveByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            receiver = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            onBehalf = receiver;
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
        }
        else {
            if(isPRTRRequester) {
                receiveByUser = ESS_Global.assignToUser(
                    model.Requester_Id__c
                );
                requestByUser = receiveByUser;
            }
            else {
                receiver = ESS_Global.assignToPISUser(
                    model.Requester_Id__c
                );
                requester = receiver;
            }
        }
        
        User acceptByUser = new User();
        PISUsers__c acceptBy = new PISUsers__c();
        boolean isPRTRAdmin = ESS_Global.checkPRTRUser(model.PMSV_Id__c);
        if(isPRTRAdmin) {
            acceptByUser = ESS_Global.assignToUser(
                model.PMSV_Id__c
            );
        }
        else {
            acceptBy = ESS_Global.assignToPISUser(
            model.PMSV_Id__c
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
        string acceptedDate;
        if (model.Accepted_Date__c != null) {
            acceptedDate = formatDate(model.Accepted_Date__c);
        }
        string completedDate;
        if (model.Completed_Date__c != null) {
            completedDate = formatDate(model.Completed_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        string internalDetail = '';
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        if(model.Type_of_Service__c == ESS_Enum.FixTypeOfService.OfficeEquipment.name()) {
            if(string.isNotEmpty(model.Office_Detail__c)) {
                internalDetail = model.Office_Detail__c;
            }
        }
        else if(model.Type_of_Service__c == ESS_Enum.FixTypeOfService.Housing.name()) {
            if(string.isNotEmpty(model.Housing_Detail__c)) {
                internalDetail = model.Housing_Detail__c;
            }
        }
        else if(model.Type_of_Service__c == ESS_Enum.FixTypeOfService.Transportation.name()) {
            if(string.isNotEmpty(model.Transportation_Detail__c)) {
                internalDetail = model.Transportation_Detail__c;
            }
        }
        else if(model.Type_of_Service__c == ESS_Enum.FixTypeOfService.GeneralService.name()) {
            if(string.isNotEmpty(model.General_Detail__c)) {
                internalDetail = model.General_Detail__c;
            }
        }
        htmlBody = htmlBody.replace('{!PMSVComment}', internalDetail);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!PMSVComment}', internalDetail);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        if(model.On_Behalf_Flow__c) {
            message.toAddresses.add(receiver.Email__c);
        }
        else {
            if(isPRTRRequester) {
                message.toAddresses.add(receiveByUser.Email);
            }
            else {
                message.toAddresses.add(receiver.Email__c);
            }
        }
        message.setToAddresses(message.toAddresses);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        //cc email for test
        //List<string> ccAddresses = ccEmails(isTransportation);
        //message.setCcAddresses(ccAddresses);
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
       
    //For VerifyMultiple
    public static void SendEmailWhenVerifyMultiple(ESS_FixAndGeneral__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Finding Type of Service
        boolean isTransportation = false;
        isTransportation = isTransportation(model.Type_of_Service__c);
        
        //Find Admin PMSV
        Set<PISUsers__c> PISUsers = sendEmailForAdminPMSVPISUser(isTransportation);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = mapEmailTemplates.get('FixAndGeneral_FIX_05');
        
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        User requestByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            
            onBehalf = ESS_Global.assignToPISUser(
                model.On_Behalf_Of_Id__c
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
        }
        else {
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
            
        }
        
        string createdDate = '';
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        string submittedDate = '';
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }
        string cancelledDate = '';
        if (model.Cancelled_Date__c != null) {
            cancelledDate = formatDate(model.Cancelled_Date__c);
        }
        string dueDate = '';
        if (model.Expected_Due_Date__c != null) {
            dueDate = formatDate(model.Expected_Due_Date__c);
        }
        string detail = '';
        if(string.isNotEmpty(model.Detail__c)) {
            detail = model.Detail__c;
        }
        
        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        
        //Send Email to Admin PMSV (PIS User)
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
        subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        subject = subject.replace('{!TypeOfService}', services.get(model.Type_of_Service__c));
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        htmlBody = htmlBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
        htmlBody = htmlBody.replace('{!Detail}', detail);
        htmlBody = htmlBody.replace('{!DueDate}', dueDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        string plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
        plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
        plainBody = plainBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        plainBody = plainBody.replace('{!Topic}', model.Topic__c);
        plainBody = plainBody.replace('{!Detail}', detail);
        plainBody = plainBody.replace('{!DueDate}', dueDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toaddresses = new List<string>();
            
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                message.toaddresses.add(PISUser.EMAIL__c);  
            }
        }
                
        //Send Email to Admin PMSV (User)
        Set<User> Users = sendEmailForAdminPMSVUser(isTransportation);
        if(Users.size() > 0) {
            for(User User : Users) {
                message.toAddresses.add(User.Email);
            }
        }
        message.setToAddresses(message.toaddresses);
        
        //cc email for requester
        List<string> ccAddresses = new List<string>();
        ccAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            ccAddresses.add(model.On_Behalf_Of_Email__c);
        }
        
        //cc email for test
        //List<string> testCCAddresses = ccEmails(isTransportation);
        //ccAddresses.addAll(testCCAddresses);
        message.setCcAddresses(ccAddresses);
        
        if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
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
    
    //For VerifyMultiple From List
    public static void SendEmailWhenVerifyMultiple(List<ESS_FixAndGeneral__c> models) {
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = mapEmailTemplates.get('FixAndGeneral_FIX_05');
        
        List<PISUsers__c> pmsvPISUsers = new List<PISUsers__c>();
        List<PISUsers__c> pmsvFAGPISUsers = new List<PISUsers__c>();
        List<PISUsers__c> pmsvTransPISUsers = new List<PISUsers__c>();
        List<User> pmsvUsers = new List<User>();
        List<User> pmsvFAGUsers = new List<User>();
        List<User> pmsvTransUsers = new List<User>();
        
        Set<PISUsers__c> pisUsers = new Set<PISUsers__c>();
        Set<User> Users = new Set<User>();
        
        //Find Admin PMSV
        List<PISUsers__c> AdminPMSVs = assignToESSPMSVPISUser('ESS_PMSV');
        if(AdminPMSVs.size() > 0) {
            for(PISUsers__c AdminPMSV : AdminPMSVs) {
                pmsvPISUsers.add(AdminPMSV);
            }
        }
        List<PISUsers__c> AdminPMSVFixAndGenerals = assignToESSPMSVPISUser('ESS_PMSV_FixAndGeneral');
        if(AdminPMSVFixAndGenerals.size() > 0) {
            for(PISUsers__c AdminPMSV : AdminPMSVFixAndGenerals) {
                pmsvFAGPISUsers.add(AdminPMSV);
            }
        }
        List<PISUsers__c> AdminPMSVTransportations = assignToESSPMSVPISUser('ESS_PMSV_Transportation');
        if(AdminPMSVTransportations.size() > 0) {
            for(PISUsers__c AdminPMSV : AdminPMSVTransportations) {
                pmsvTransPISUsers.add(AdminPMSV);
            }
        }
        
        //Find Admin PMSV User
        List<User> AdminPMSVUsers = ESS_Global.assignToESSPMSVUser();
        if(AdminPMSVUsers.size() > 0) {
            for(User AdminPMSV : AdminPMSVUsers) {
                pmsvUsers.add(AdminPMSV);
            }
        }
        List<User> AdminPMSVFAGUsers = ESS_Global.assignToESSPMSVFixAndGeneralUser();
        if(AdminPMSVFAGUsers.size() > 0) {
            for(User AdminPMSV : AdminPMSVFAGUsers) {
                pmsvFAGUsers.add(AdminPMSV);
            }
        }
        List<User> AdminPMSVTransportationUsers = ESS_Global.assignToESSPMSVTransportationUser();
        if(AdminPMSVTransportationUsers.size() > 0) {
            for(User AdminPMSV : AdminPMSVTransportationUsers) {
                pmsvTransUsers.add(AdminPMSV);
            }
        }
        
        if(models.size() > 0) {
            for(ESS_FixAndGeneral__c model : models) {
                
                string link = '/one/one.app#/alohaRedirect/apex/ESS_Fix_General_Detail?parent=HOME&recordId=' + model.Id;
                string URL = ESS_Global.emailURL(link);
                
                //Finding Type of Service
                boolean isTransportation = false;
                isTransportation = isTransportation(model.Type_of_Service__c);
                
                boolean isPRTRRequester = model.Is_PRTR_Requester__c;
                User requestByUser = new User();
                
                string createdDate = '';
                if (model.CreatedDate != null) {
                    createdDate = model.CreatedDate.format('dd/MM/yyyy');
                }
                string submittedDate = '';
                if (model.Submitted_Date__c != null) {
                    submittedDate = formatDate(model.Submitted_Date__c);
                }
                string cancelledDate = '';
                if (model.Cancelled_Date__c != null) {
                    cancelledDate = formatDate(model.Cancelled_Date__c);
                }
                string dueDate = '';
                if (model.Expected_Due_Date__c != null) {
                    dueDate = formatDate(model.Expected_Due_Date__c);
                }
                string detail = '';
                if(string.isNotEmpty(model.Detail__c)) {
                    detail = model.Detail__c;
                }
                
                Map<string, string> statuses = GetAllStatuses();
                Map<string, string> services = GetAllTypeOfServices();
                
                //Send Email to Admin PMSV (PIS User)
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
                subject = subject.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
                
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
                htmlBody = htmlBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
                htmlBody = htmlBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
                htmlBody = htmlBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
                htmlBody = htmlBody.replace('{!Topic}', model.Topic__c);
                htmlBody = htmlBody.replace('{!Detail}', detail);
                htmlBody = htmlBody.replace('{!DueDate}', dueDate);
                htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
                htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
                
                string plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
                plainBody = plainBody.replace('{!ServiceNameCap}', displayServiceName(model.Type_of_Service__c, true));
                plainBody = plainBody.replace('{!ServiceName}', displayServiceName(model.Type_of_Service__c, false));
                plainBody = plainBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
                plainBody = plainBody.replace('{!Topic}', model.Topic__c);
                plainBody = plainBody.replace('{!Detail}', detail);
                plainBody = plainBody.replace('{!DueDate}', dueDate);
                plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
                plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
                
                message.setTemplateID(emailTemplate.Id);
                message.setWhatId(model.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toaddresses = new List<string>();
                    
                //Send Email to Admin PMSV
                //Set<PISUsers__c> PISUsers = sendEmailForAdminPMSVPISUser(isTransportation);
                if(pmsvPISUsers.size() > 0) {
                    for(PISUsers__c PISUser : pmsvPISUsers) {
                        PISUsers.add(PISUser);
                    }
                }
                if(!isTransportation) {
                    if(pmsvFAGPISUsers.size() > 0) {
                        for(PISUsers__c PISUser : pmsvFAGPISUsers) {
                            PISUsers.add(PISUser);
                        }
                    }
                }
                else {
                    if(pmsvTransPISUsers.size() > 0) {
                        for(PISUsers__c PISUser : pmsvTransPISUsers) {
                            PISUsers.add(PISUser);
                        }
                    }
                }
                if(PISUsers.size() > 0) {
                    for(PISUsers__c PISUser : PISUsers) {
                        message.toaddresses.add(PISUser.EMAIL__c);  
                    }
                }
                    
                //Send Email to Admin PMSV (User)
                //Set<User> Users = sendEmailForAdminPMSVUser(isTransportation);
                if(pmsvUsers.size() > 0) {
                    for(User User : pmsvUsers) {
                        Users.add(User);
                    }
                }
                if(!isTransportation) {
                    if(pmsvFAGUsers.size() > 0) {
                        for(User User : pmsvFAGUsers) {
                            Users.add(User);
                        }
                    }
                }
                else {
                    if(pmsvTransUsers.size() > 0) {
                        for(User User : pmsvTransUsers) {
                            Users.add(User);
                        }
                    }
                }
                if(Users.size() > 0) {
                    for(User User : Users) {
                        message.toAddresses.add(User.Email);
                    }
                }
                
                message.setToAddresses(message.toaddresses);
                
                //cc email for requester
                List<string> ccAddresses = new List<string>();
                ccAddresses.add(model.Requester_Email__c);
                if(model.On_Behalf_Flow__c) {
                    ccAddresses.add(model.On_Behalf_Of_Email__c);
                }
                
                //cc email for test
                //List<string> testCCAddresses = ccEmails(isTransportation);
                //ccAddresses.addAll(testCCAddresses);
                message.setCcAddresses(ccAddresses);
                
                if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
                    message.setOrgWideEmailAddressId(owea[0].Id);
                }
                else {
                    message.setSenderDisplayName('i-Link+');
                }
                
                sendEmails.add(message);
                
            }
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    private static Map<string, string> GetAllStatuses()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getValue(), objPickList.getLabel());
        }
        return statuses;
    }
 
    private static Map<string, string> GetAllTypeOfServices()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Type_Of_Service__c.getDescribe();
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
    
    /* public static List<string> ccEmails(boolean isTransportation) {
        List<string> ccAddresses = new List<string>();
        ccAddresses.add('pirapornw@thaioilgroup.com');
        ccAddresses.add('pornthepp@thaioilgroup.com');
        ccAddresses.add('watcharat@thaioilgroup.com');
        ccAddresses.add('sarocha@softever.co.th');
        ccAddresses.add('atittaya@softever.co.th');
        ccAddresses.add('sinlapat@softever.co.th');
        ccAddresses.add('puttipat@softever.co.th');
        ccAddresses.add('pichet@thaioilgroup.com');
        ccAddresses.add('surat@thaioilgroup.com');
        if(isTransportation) {
            ccAddresses.add('chotiphun@thaioilgroup.com');
        }
        return ccAddresses;
    } */
    
    public static string LinkURL(string URL, string documentNo) {
        string returnURL = '<a href=\'' + URL + '\'>' + documentNo + '</a>';
        return returnURL;
    }
    
    public static boolean isTransportation(string typeOfService) {
        boolean isTransportation = false;
        if(typeOfService == ESS_Enum.FixTypeOfService.Transportation.name()) {
            isTransportation = true;
        }
        return isTransportation;
    }
    
    public static Set<PISUsers__c> sendEmailForAdminPMSVPISUser(boolean isTransportation) {
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        List<PISUsers__c> AdminPMSVs = assignToESSPMSVPISUser('ESS_PMSV');
        if(AdminPMSVs.size() > 0) {
            for(PISUsers__c AdminPMSV : AdminPMSVs) {
                PISUsers.add(AdminPMSV);
            }
        }
        if(!isTransportation) {
            List<PISUsers__c> AdminPMSVFixAndGenerals = assignToESSPMSVPISUser('ESS_PMSV_FixAndGeneral');
            if(AdminPMSVFixAndGenerals.size() > 0) {
                for(PISUsers__c AdminPMSV : AdminPMSVFixAndGenerals) {
                    PISUsers.add(AdminPMSV);
                }
            }
        }
        else {
            List<PISUsers__c> AdminPMSVTransportations = assignToESSPMSVPISUser('ESS_PMSV_Transportation');
            if(AdminPMSVTransportations.size() > 0) {
                for(PISUsers__c AdminPMSV : AdminPMSVTransportations) {
                    PISUsers.add(AdminPMSV);
                }
            }
        }
        return PISUsers;
    }
    
    public static Set<User> sendEmailForAdminPMSVUser(boolean isTransportation) {
        Set<User> Users = new Set<User>();
        List<User> AdminPMSVUsers = ESS_Global.assignToESSPMSVUser();
        if(AdminPMSVUsers.size() > 0) {
            for(User AdminPMSV : AdminPMSVUsers) {
                Users.add(AdminPMSV);
            }
        }
        if(!isTransportation) {
            List<User> AdminPMSVFAGUsers = ESS_Global.assignToESSPMSVFixAndGeneralUser();
            if(AdminPMSVFAGUsers.size() > 0) {
                for(User AdminPMSV : AdminPMSVFAGUsers) {
                    Users.add(AdminPMSV);
                }
            }
        }
        else {
            List<User> AdminPMSVTransportationUsers = ESS_Global.assignToESSPMSVTransportationUser();
            if(AdminPMSVTransportationUsers.size() > 0) {
                for(User AdminPMSV : AdminPMSVTransportationUsers) {
                    Users.add(AdminPMSV);
                }
            }
        }
        return Users;
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
    
    public static Set<string> ccEmailForAdminPMSVFixAndGeneral() {
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = assignToESSPMSVUser('ESS_PMSV');
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = assignToESSPMSVPISUser('ESS_PMSV');
        AdminPISUsers.addAll(AdminPMSVs);
        
        List<PISUsers__c> AdminPMSVFixAndGenerals = assignToESSPMSVPISUser('ESS_PMSV_FixAndGeneral');
        AdminPISUsers.addAll(AdminPMSVFixAndGenerals);
        List<User> AdminPMSVFAGUsers = assignToESSPMSVUser('ESS_PMSV_FixAndGeneral');
        AdminUsers.addAll(AdminPMSVFAGUsers);
        
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
    
    public static Set<string> ccEmailForAdminPMSVTransportation() {
        
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = assignToESSPMSVUser('ESS_PMSV');
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = assignToESSPMSVPISUser('ESS_PMSV');
        AdminPISUsers.addAll(AdminPMSVs);
        
        List<PISUsers__c> AdminPMSVTransportations = assignToESSPMSVPISUser('ESS_PMSV_Transportation');
        AdminPISUsers.addAll(AdminPMSVTransportations);
        List<User> AdminPMSVTransportationUsers = assignToESSPMSVUser('ESS_PMSV_Transportation');
        AdminUsers.addAll(AdminPMSVTransportationUsers);
        
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
    
    public static string displayServiceName(string service, boolean isCap) {
        string display = '';
        if(isCap) {
            if(ESS_Enum.FixTypeOfService.OfficeEquipment.name() == service) {
                display = 'Maintainance';
            }
            else if(ESS_Enum.FixTypeOfService.Housing.name() == service) {
                display = 'Housing';
            }
            else if(ESS_Enum.FixTypeOfService.Transportation.name() == service) {
                display = 'Transportation';
            }
            else if(ESS_Enum.FixTypeOfService.GeneralService.name() == service) {
                display = 'General';
            }
        }
        else {
            if(ESS_Enum.FixTypeOfService.OfficeEquipment.name() == service) {
                display = 'maintainance';
            }
            else if(ESS_Enum.FixTypeOfService.Housing.name() == service) {
                display = 'housing';
            }
            else if(ESS_Enum.FixTypeOfService.Transportation.name() == service) {
                display = 'transportation';
            }
            else if(ESS_Enum.FixTypeOfService.GeneralService.name() == service) {
                display = 'general';
            }
        }
        return display;
    }
}