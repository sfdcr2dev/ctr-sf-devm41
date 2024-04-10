public with sharing class ESS_ManpowerNotification {

    private static string orgId = UserInfo.getOrganizationId();
    
    //LC1-01 - ส่งหา Employee ตอน Employee Admin Submit
    public static void SendToEmployeeWhenRequesterSubmitOnBehalf(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_01'
        ];

        boolean isPRTR = model.Is_PRTR__c;
        User user = new User();
        PISUsers__c requester = new PISUsers__c();
        
        PISUsers__c receiver = ESS_Global.assignToPISUser(
        model.On_Behalf_Of_Id__c
        );

        if(!isPRTR) {
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );    
        }
        else {
            User = ESS_Global.assignToUser(model.Requester_Id__c);
        }
        
        string createdDate;

        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        if(!isPRTR) {
            htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        else {
            htmlBody = htmlBody.replace('{!RequesterID}', user.Employee_Id__c);
            htmlBody = htmlBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
        }
        htmlBody = htmlBody.replace('{!OnBehalfOfID}', receiver.EMPLOYEEID__c);
        htmlBody = htmlBody.replace('{!OnBehalfOfName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
        htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', createdDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        if(!isPRTR) {
            plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        else {
            plainBody = plainBody.replace('{!RequesterID}', user.Employee_Id__c);
            plainBody = plainBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
        }
        plainBody = plainBody.replace('{!OnBehalfOfID}', receiver.EMPLOYEEID__c);
        plainBody = plainBody.replace('{!OnBehalfOfName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
        plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
        plainBody = plainBody.replace('{!SubmittedDate}', createdDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        List<string> testCCEmails = ccEmails();
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        } 
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        } */
        
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

    //LC1-02 - ส่งหา Section Head ตอน Employee Submit (หรือ Approve On behalf)
    public static void SendToSectionHeadWhenSubmit(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_02'
        ];
        
        boolean isPRTR = model.Is_PRTR__c;
        User user = new User();
        
        PISUsers__c receiver = ESS_Global.assignToPISUser(
            model.Section_Head_Id__c
            );
        PISUsers__c requester;
        PISUsers__c onbehalf;
        
        if (model.On_Behalf_Of_Flow__c) {
            onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            if(!isPRTR) {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );    
            }
            else {
                User = ESS_Global.assignToUser(model.Requester_Id__c);
            }
        }else{
            if(!isPRTR) {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
            }
            else {
                User = ESS_Global.assignToUser(model.Requester_Id__c);
            }
        }

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        if(!isPRTR) {
            htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        else {
            htmlBody = htmlBody.replace('{!RequesterID}', user.Employee_Id__c);
            htmlBody = htmlBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
        }
        if (model.On_Behalf_Of_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
        htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        if(!isPRTR) {
            plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        else {
            plainBody = plainBody.replace('{!RequesterID}', user.Employee_Id__c);
            plainBody = plainBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
        }
        if (model.On_Behalf_Of_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
        plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        List<string> testCCEmails = ccEmails();
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        } */
        
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

    //LC1-03 - ส่งหา VP หรือ Project Manager ตอน Secion Head Approve แล้ว
    public static void SendToVPOrProjectManagerWhenSectionHeadApprove(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_03'
        ];

        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onbehalf;

        if (model.On_Behalf_Of_Flow__c) {
            onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
        }else{
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
        }

        if (model.Type_of_Service__c == ESS_Enum.ManpowerTypeOfService.Temporary.name()) {
            receiver = ESS_Global.assignToPISUser(
            model.VP_Id__c
            );
        }else if (model.Type_of_Service__c == ESS_Enum.ManpowerTypeOfService.ProjectBase.name()) {
            receiver = ESS_Global.assignToPISUser(
            model.Project_Manager_Id__c
            );
        }

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
        htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
        plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);

        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        List<string> testCCEmails = ccEmails();
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        } */
        
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

    //LC1-04 ตัดออกเพราะซ้ำกับ LC1-03

    //LC1-05 - ส่งให้ Admin เมื่อต้องการ Acknowledge
    public static void SendToAdminWhenApprove(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
            
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_05'
        ];

        List<PISUsers__c> receivers = ESS_Global.assignToPMBPAdminPISUser();

        if (model.Objective__c == ESS_Enum.ManpowerObjective.AddNewPosition.name() || model.Objective__c == ESS_Enum.ManpowerObjective.KHReview.name()) {
            List<PISUsers__c> peocReceivers = ESS_Global.assignToPEOCAdminPISUser();
            for(PISUsers__c receiver : peocReceivers) {
                receivers.add(receiver);
            }
        }

        boolean isPRTR = model.Is_PRTR__c;
        User user = new User();
        
        PISUsers__c requester;
        PISUsers__c onbehalf;

        if (model.On_Behalf_Of_Flow__c) {
            onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            if(!isPRTR) {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );    
            }
            else {
                User = ESS_Global.assignToUser(model.Requester_Id__c);
            }
        }else{
            if(!isPRTR) {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );    
            }
            else {
                User = ESS_Global.assignToUser(model.Requester_Id__c);
            }
        }

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        if(receivers.size() > 0) {
            
            for(PISUsers__c receiver : receivers) {
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false);
                string subject = emailTemplate.Subject;
                subject = subject.replace('{!DocumentNo}', model.Document_No__c);

                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
                htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
                if(!isPRTR) {
                    htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
                    htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
                }
                else {
                    htmlBody = htmlBody.replace('{!RequesterID}', user.Employee_Id__c);
                    htmlBody = htmlBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
                }
                if (model.On_Behalf_Of_Flow__c)
                {
                    htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
                    htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
                }else{
                    htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
                }
                htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
                htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
                htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
                htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
                htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
                htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
                plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
                if(!isPRTR) {
                    plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
                    plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
                }
                else {
                    plainBody = plainBody.replace('{!RequesterID}', user.Employee_Id__c);
                    plainBody = plainBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
                }
                if (model.On_Behalf_Of_Flow__c)
                {
                    plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
                    plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
                }else{
                    plainBody = plainBody.replace(plainBodyOnBehalf, '');
                }
                plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
                plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
                plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
                plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
                plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
                plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

                message.setTemplateID(emailTemplate.Id);
                message.setWhatId(model.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new List<String>{ receiver.Email__c };
                message.setToAddresses(message.toaddresses);
                
                //Test ccEmail (To be remove when GO LIVE)
                /* List<string> ccAddresses = new List<string>();
                Set<string> ccEmails = new Set<string>();
                List<string> testCCEmails = ccEmails();
                for(string testCCEmail : testCCEmails) {
                    ccEmails.add(testCCEmail);
                }
                if(ccEmails.size() > 0) {
                    for(string ccEmail : ccEmails) {
                        ccAddresses.add(ccEmail);
                    }
                    message.setCcAddresses(ccAddresses);
                } */
                
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

    //LC1-06 - ส่งให้ Employee หลังจากมีการ Acknowledge แล้ว
    public static void SendToEmployeeWhenAcknowledge(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_06'
        ];
        
        boolean isPRTR = model.Is_PRTR__c;
        User user = new User();
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onbehalf;

        if (model.On_Behalf_Of_Flow__c) {
            onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            if(!isPRTR) {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                ); 
                receiver = onbehalf;   
            }
            else {
                User = ESS_Global.assignToUser(model.Requester_Id__c);
            }
        }else{
            if(!isPRTR) {
                requester = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );    
                receiver = requester;
            }
            else {
                User = ESS_Global.assignToUser(model.Requester_Id__c);
            }
        }

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        string completedDate;

        if (model.Completed_Date__c != null) {
            completedDate = formatDate(model.Completed_Date__c);
        }
        
        Set<PISUsers__c> Admins = new Set<PISUsers__c>();
        List<PISUsers__c> PMBPAdmins = ESS_Global.assignToPMBPAdminPISUser();
        
        if(PMBPAdmins.size() > 0) {
            for(PISUsers__c PMBP : PMBPAdmins) {
                Admins.add(PMBP);
            }
        }
        
        List<PISUsers__c> PEOCAdmins = new List<PISUsers__c>();
        
        if(model.Objective__c == ESS_Enum.ManpowerObjective.AddNewPosition.name() ||
            model.Objective__c == ESS_Enum.ManpowerObjective.KHReview.name()) {
                
            PEOCAdmins = ESS_Global.assignToPEOCAdminPISUser();
                
            if(PEOCAdmins.size() > 0) {
                for(PISUsers__c PEOC : PEOCAdmins) {
                    Admins.add(PEOC);
                }
            }
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        if(!isPRTR) {
            htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
            htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        else {
            htmlBody = htmlBody.replace('{!ReceiverName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
            htmlBody = htmlBody.replace('{!RequesterID}', user.Employee_Id__c);
            htmlBody = htmlBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
        }
        if (model.On_Behalf_Of_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
        htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!CompletedDate}', completedDate);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        if(!isPRTR) {
            plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
            plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        }
        else {
            plainBody = plainBody.replace('{!ReceiverName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
            plainBody = plainBody.replace('{!RequesterID}', user.Employee_Id__c);
            plainBody = plainBody.replace('{!RequesterName}', user.FirstName_EN__c + ' ' + user.LastName_EN__c);
        }
        if (model.On_Behalf_Of_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
        plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!CompletedDate}', completedDate);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setWhatId(model.Id);   
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        if(!isPRTR) {
            message.toAddresses.add(receiver.Email__c);
        }
        else {
            message.toAddresses.add(User.Email);
        }
        message.setToAddresses(message.toaddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> testCCEmails = ccEmails();
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        } */
        
        //CC Email to Admin PMBP and Admin PEOC
        if(Admins.size() > 0) {
            for(PISUsers__c Admin : Admins) {
                ccEmails.add(Admin.Email__c);
            }
            
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            
            if(ccAddresses.size() > 0) {
                message.setCcAddresses(ccAddresses);
            }
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

    //LC1-07 - ส่งให้ Employee Admin เมื่อ Employee Reject
    public static void SendToEmployeeAdminWhenEmployeeReject(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_07'
        ];

        PISUsers__c receiver = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
        PISUsers__c requester = receiver;
        PISUsers__c onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
        htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!Comment}', model.Comment__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
        plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!Comment}', model.Comment__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);

        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        List<string> testCCEmails = ccEmails();
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        } */
        
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

    //LC1-08 - แจ้งผู้ดำเนินการก่อนหน้าว่ามีการ Reject (กรณีผู้กด Reject เป็น VP/Project Manager)
    public static void SendToSectionHeadWhenVPOrProjectManagerReject(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_08'
        ];

        PISUsers__c receiver = ESS_Global.assignToPISUser(
            model.Section_Head_Id__c
            );
        PISUsers__c requester;
        PISUsers__c onbehalf;

        if (model.On_Behalf_Of_Flow__c) {
            onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
        }else{
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
        }

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
        htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!Comment}', model.Comment__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
        plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!Comment}', model.Comment__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        List<string> testCCEmails = ccEmails();
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        } */
        
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

    //LC1-09 - แจ้งผู้ดำเนินการก่อนหน้าว่ามีการ Reject (กรณีผู้กด Reject เป็น Section Head/Admin)
    public static void SendToEmployeeWhenSectionHeadOrAdminReject(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_09'
        ];

        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onbehalf;

        if (model.On_Behalf_Of_Flow__c) {
            onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
            receiver = onbehalf;
        }else{
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
            receiver = requester;
        }

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
        htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!Comment}', model.Comment__c);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
        if (model.On_Behalf_Of_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
        plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
        plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!Comment}', model.Comment__c);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (To be remove when GO LIVE)
        /* List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        List<string> testCCEmails = ccEmails();
        for(string testCCEmail : testCCEmails) {
            ccEmails.add(testCCEmail);
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
            message.setCcAddresses(ccAddresses);
        } */
        
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

    //LC1-10 - ตัดออก (ซ้ำกับ LC1-07)

    //LC1-11 - แจ้งพนักงานและ Admin ว่าการขออนุมัติได้ถูกยกเลิก เมื่อมีผู้กด Cancel Request 
    public static void SendToEmployeeWhenCancel(ESS_Manpower__c model) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Manpower_Detail?parent=ESS_Manpower_List&manpowerId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Manpower_LC1_11'
        ];

        List<PISUsers__c> receivers = new List<PISUsers__c>();
        PISUsers__c requester;
        PISUsers__c onbehalf;
        PISUsers__c cancelledBy = ESS_Global.assignToPISUser(
            model.Cancelled_By_Id__c
            );

        if (model.On_Behalf_Of_Flow__c) {
            onbehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
            receivers.add(onbehalf);
        }else{
            requester = ESS_Global.assignToPISUser(
            model.Requester_Id__c
            );
            receivers.add(requester);
        }

        string submittedDate;

        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        Map<string, string> services = GetAllTypeOfServices();
        Map<string, string> objectives = GetAllObjectives();

        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        if(receivers.size() > 0) {
            
            for(PISUsers__c receiver : receivers) {
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false);
                string subject = emailTemplate.Subject;
                subject = subject.replace('{!DocumentNo}', model.Document_No__c);

                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
                htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
                htmlBody = htmlBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
                htmlBody = htmlBody.replace('{!RequesterName}', requester.EN_Fullname__c);
                if (model.On_Behalf_Of_Flow__c)
                {
                    htmlBody = htmlBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
                    htmlBody = htmlBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
                }else{
                    htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
                }
                htmlBody = htmlBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
                htmlBody = htmlBody.replace('{!Objective}', objectives.get(model.Objective__c));
                htmlBody = htmlBody.replace('{!JobTitle}', model.Job__c);
                htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
                htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
                htmlBody = htmlBody.replace('{!Comment}', model.Comment__c);
                htmlBody = htmlBody.replace('{!CancelledBy}', cancelledBy.EN_Fullname__c);
                htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
                plainBody = plainBody.replace('{!RequesterName}', requester.EN_Fullname__c);
                plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
                plainBody = plainBody.replace('{!RequesterID}', requester.EMPLOYEEID__c);
                if (model.On_Behalf_Of_Flow__c)
                {
                    plainBody = plainBody.replace('{!OnBehalfOfID}', onbehalf.EMPLOYEEID__c);
                    plainBody = plainBody.replace('{!OnBehalfOfName}', onbehalf.EN_Fullname__c);
                }else{
                    plainBody = plainBody.replace(plainBodyOnBehalf, '');
                }
                plainBody = plainBody.replace('{!TypeofService}', services.get(model.Type_of_Service__c));
                plainBody = plainBody.replace('{!Objective}', objectives.get(model.Objective__c));
                plainBody = plainBody.replace('{!JobTitle}', model.Job__c);
                plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
                plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
                plainBody = plainBody.replace('{!Comment}', model.Comment__c);
                plainBody = plainBody.replace('{!CancelledBy}', cancelledBy.EN_Fullname__c);
                plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

                message.setTemplateID(emailTemplate.Id);
                message.setWhatId(model.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new List<String>{ receiver.Email__c };
                message.setToAddresses(message.toaddresses);

                //Test ccEmail (To be remove when GO LIVE)
                /* List<string> ccAddresses = new List<string>();
                Set<string> ccEmails = new Set<string>();
                List<string> testCCEmails = ccEmails();
                for(string testCCEmail : testCCEmails) {
                    ccEmails.add(testCCEmail);
                }
                if(ccEmails.size() > 0) {
                    for(string ccEmail : ccEmails) {
                        ccAddresses.add(ccEmail);
                    }
                    message.setCcAddresses(ccAddresses);
                } */
                
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
        Schema.DescribeFieldResult objFieldDescribe = ESS_Manpower__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getValue(), objPickList.getLabel());
        }
        return statuses;
    }
    
    private static Map<string, string> GetAllTypeOfServices()
    {
        Map<string, string> services = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Manpower__c.Type_Of_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            services.put(objPickList.getValue(), objPickList.getLabel());
        }
        return services;
    }
    
    private static Map<string, string> GetAllObjectives()
    {
        Map<string, string> objectives = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Manpower__c.Objective__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            objectives.put(objPickList.getValue(), objPickList.getLabel());
        }
        return objectives;
    }

    public static string formatDate(Date d) {
        return d.day() + '/' + d.month() + '/' + d.year();
    }
    
    public static string LinkURL(string URL, string documentNo) {
        string returnURL = '<a href=\'' + URL + '\'>' + documentNo + '</a>';
        return returnURL;
    }
    
    /* public static List<string> ccEmails() {
        List<string> ccAddresses = new List<string>();
        ccAddresses.add('sarocha@softever.co.th');
        ccAddresses.add('atittaya@softever.co.th');
        ccAddresses.add('sinlapat@softever.co.th');
        ccAddresses.add('puttipat@softever.co.th');
        return ccAddresses;
    } */
    
}