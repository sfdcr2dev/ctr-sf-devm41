/* Author Softever */
global with sharing class ESS_NotiAndEmailController {

    private static string orgId = UserInfo.getOrganizationId();
    private static string environment = [select environment__c from ess_config__c].environment__c; 
    
    //E1-01
    public static void ApplicationSendToPersonelAdminWhenUserSubmitted(ESS_Application__c Application) {
           
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c User = ESS_Global.assignToPISUser(Application.OwnerId);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_01'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
        string createdDate;
        string submittedDate;
        if(Application.CreatedDate != null) {
            createdDate = Application.CreatedDate.format('dd/MM/yyyy');
        }
        else {
            createdDate = system.Datetime.now().format('dd/MM/yyyy');
        }
        if(Application.Submitted_Date__c != null) {
            submittedDate = formatDate(Application.Submitted_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Application.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Application.Document_No__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!EmployeeId}', Application.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        plainBody = plainBody.replace('{!DocumentNo}', Application.Document_No__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Application.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        
        //Send Email to Admin
        Set<string> adminEmails = sendEmailForAdminApplication();
        if(adminEmails.size() > 0) {
            for(string email : adminEmails) {
                message.toAddresses.add(email);
            }
            message.setToAddresses(message.toaddresses);
        }
        
        message.setToAddresses(message.toaddresses);
        
        //cc employee
        List<string> ccAddresses = new List<string>();
        ccAddresses.add(User.EMAIL__c);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCAddresses = ccEmails();
            if(testCCAddresses.size() > 0) {
                for(string ccEmail : testCCAddresses) {
                    ccAddresses.add(ccEmail);
                }
            }
        }
        message.setCcAddresses(ccAddresses);
        
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
    
    //E1-02
    public static Messaging.SingleEmailMessage ApplicationSendToOwnerWhenCompletedInSAP(EmailTemplate emailTemplate, Map<string, PISUsers__c> mapPISUsers, ESS_Application__c Application) {
         
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c PISUser = mapPISUsers.get(Application.OwnerId);
        
        string createdDate;
        string submittedDate;
        string verifyDate;
        string completedDate;
        
        if(Application.CreatedDate != null) {
            createdDate = Application.CreatedDate.format('dd/MM/yyyy');
        }
        if(Test.isRunningTest()) {
            createdDate = system.Datetime.now().format('dd/MM/yyyy');
        }
        if(Application.Submitted_Date__c != null) {
            submittedDate = formatDate(Application.Submitted_Date__c);
        }
        if(Application.Verified_Date__c != null) {
            verifyDate = formatDate(Application.Verified_Date__c);
        }
        if(Application.Completed_Date__c != null) {
            completedDate = formatDate(Application.Completed_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Application.Document_No__c);
            
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Application.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!VerifyDate}', verifyDate);
        htmlBody = htmlBody.replace('{!CompletedDate}', completedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Application.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!VerifyDate}', verifyDate);
        plainBody = plainBody.replace('{!CompletedDate}', completedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Application.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { PISUser.Email__c };
        message.setToAddresses(message.toaddresses);
              
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        return message;
    }
        
    //E1-03
    public static void ApplicationSendToOwnerWhenCancelled(ESS_Application__c Application) {
            
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c PISUser = ESS_Global.assignToPISUser(Application.OwnerId);
        
        string createdDate;
        string submittedDate;
        
        if(Application.CreatedDate != null) {
            createdDate = Application.CreatedDate.format('dd/MM/yyyy');
        }
        if(Test.isRunningTest()) {
            createdDate = system.Datetime.now().format('dd/MM/yyyy');
        }
        if(Application.Submitted_Date__c != null) {
            submittedDate = formatDate(Application.Submitted_Date__c);
        }
        else {
            submittedDate = '-';
        }
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_03'];
             
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Application.Document_No__c);
            
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Application.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Application.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Application.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { PISUser.Email__c };
        message.setToAddresses(message.toaddresses);
        
        Set<string> ccEmails = new Set<string>();
        List<string> ccAddresses = new List<string>();
        
        //CC Admin
        Set<string> ccAdminEmails = sendEmailForAdminApplication();
        ccEmails.addAll(ccAdminEmails);
        
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCAddresses = ccEmails();
            for(string ccAddress : testCCAddresses) {
                ccAddresses.add(ccAddress);
            }
        }
        
        message.setCcAddresses(ccAddresses);
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }
        
    }
      
    //E1-04
    public static void ApplicationSendToRelatedWhenEmployeeUpdated(ESS_Application__c Application) {
           
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        List<PISUsers__c> Relateds = ESS_Global.assignToRelatedPISUser();
        List<User> RelatedUsers = ESS_Global.assignToRelatedUser();
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_04'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        if(Relateds.size() > 0) {
            for(PISUsers__c Related : Relateds) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.EN_Fullname__c);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace('{!OldTitleFNLNTH}', Application.Name_Emp_TH_Old_Title_FN_LN__c);
                htmlBody = htmlBody.replace('{!OldTitleEN}', Application.Name_Emp_EN_Old_Title__c);
                htmlBody = htmlBody.replace('{!OldFNEN}', Application.Name_Emp_EN_Old_FN__c);
                htmlBody = htmlBody.replace('{!OldLNEN}', Application.Name_Emp_EN_Old_LN__c);
                htmlBody = htmlBody.replace('{!NewTitleTH}', Application.Name_Emp_TH_New_Title__c);
                htmlBody = htmlBody.replace('{!NewFNTH}', Application.Name_Emp_TH_New_FN__c);
                htmlBody = htmlBody.replace('{!NewLNTH}', Application.Name_Emp_TH_New_LN__c);
                htmlBody = htmlBody.replace('{!NewTitleEN}', Application.Name_Emp_EN_New_Title__c);
                htmlBody = htmlBody.replace('{!NewFNEN}', Application.Name_Emp_EN_New_FN__c);
                htmlBody = htmlBody.replace('{!NewLNEN}', Application.Name_Emp_EN_New_LN__c);
                htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', Related.EN_Fullname__c);
                plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                plainBody = plainBody.replace('{!OldTitleFNLNTH}', Application.Name_Emp_TH_Old_Title_FN_LN__c);
                plainBody = plainBody.replace('{!OldTitleEN}', Application.Name_Emp_EN_Old_Title__c);
                plainBody = plainBody.replace('{!OldFNEN}', Application.Name_Emp_EN_Old_FN__c);
                plainBody = plainBody.replace('{!OldLNEN}', Application.Name_Emp_EN_Old_LN__c);
                plainBody = plainBody.replace('{!NewTitleTH}', Application.Name_Emp_TH_New_Title__c);
                plainBody = plainBody.replace('{!NewFNTH}', Application.Name_Emp_TH_New_FN__c);
                plainBody = plainBody.replace('{!NewLNTH}', Application.Name_Emp_TH_New_LN__c);
                plainBody = plainBody.replace('{!NewTitleEN}', Application.Name_Emp_EN_New_Title__c);
                plainBody = plainBody.replace('{!NewFNEN}', Application.Name_Emp_EN_New_FN__c);
                plainBody = plainBody.replace('{!NewLNEN}', Application.Name_Emp_EN_New_LN__c);
                plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Application.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);                
                message.toAddresses = new String[] { Related.Email__c };
                message.setToAddresses(message.toaddresses);
                  
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
            }
        }
        
        if(RelatedUsers.size() > 0) {
            for(User Related : RelatedUsers) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace('{!OldTitleFNLNTH}', Application.Name_Emp_TH_Old_Title_FN_LN__c);
                htmlBody = htmlBody.replace('{!OldTitleEN}', Application.Name_Emp_EN_Old_Title__c);
                htmlBody = htmlBody.replace('{!OldFNEN}', Application.Name_Emp_EN_Old_FN__c);
                htmlBody = htmlBody.replace('{!OldLNEN}', Application.Name_Emp_EN_Old_LN__c);
                htmlBody = htmlBody.replace('{!NewTitleTH}', Application.Name_Emp_TH_New_Title__c);
                htmlBody = htmlBody.replace('{!NewFNTH}', Application.Name_Emp_TH_New_FN__c);
                htmlBody = htmlBody.replace('{!NewLNTH}', Application.Name_Emp_TH_New_LN__c);
                htmlBody = htmlBody.replace('{!NewTitleEN}', Application.Name_Emp_EN_New_Title__c);
                htmlBody = htmlBody.replace('{!NewFNEN}', Application.Name_Emp_EN_New_FN__c);
                htmlBody = htmlBody.replace('{!NewLNEN}', Application.Name_Emp_EN_New_LN__c);
                htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                plainBody = plainBody.replace('{!OldTitleFNLNTH}', Application.Name_Emp_TH_Old_Title_FN_LN__c);
                plainBody = plainBody.replace('{!OldTitleEN}', Application.Name_Emp_EN_Old_Title__c);
                plainBody = plainBody.replace('{!OldFNEN}', Application.Name_Emp_EN_Old_FN__c);
                plainBody = plainBody.replace('{!OldLNEN}', Application.Name_Emp_EN_Old_LN__c);
                plainBody = plainBody.replace('{!NewTitleTH}', Application.Name_Emp_TH_New_Title__c);
                plainBody = plainBody.replace('{!NewFNTH}', Application.Name_Emp_TH_New_FN__c);
                plainBody = plainBody.replace('{!NewLNTH}', Application.Name_Emp_TH_New_LN__c);
                plainBody = plainBody.replace('{!NewTitleEN}', Application.Name_Emp_EN_New_Title__c);
                plainBody = plainBody.replace('{!NewFNEN}', Application.Name_Emp_EN_New_FN__c);
                plainBody = plainBody.replace('{!NewLNEN}', Application.Name_Emp_EN_New_LN__c);
                plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Application.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);                
                message.toAddresses = new String[] { Related.Email };
                message.setToAddresses(message.toaddresses);
                  
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
            }
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }   
        
    }
    
    //E1-05
    public static void ApplicationSendToRelatedWhenFamilyUpdated(ESS_Application__c Application) {
       
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        List<PISUsers__c> Relateds = ESS_Global.assignToRelatedPISUser();
        List<User> RelatedUsers = ESS_Global.assignToRelatedUser();
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_05'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        string finalInformation = '';
        
        boolean isUpdateMarriage = false;
        string changeMarriage = '';
        boolean isUpdateMother = false;
        string changeMother = '';
        boolean isUpdateFather = false;
        string changeFather = '';
        boolean isUpdateChild = false;
        List<string> changeChilds = new List<string>();
        
        //Changes Information
        if(Application.Is_Update_Name__c) {
            //Marriage
            if(string.isnotempty(Application.Name_Marriage_TH_New_FN__c)) {
                isUpdateMarriage = true;
                
                changeMarriage = 'คู่สมรส (ถ้ามี) <br/>';
                changeMarriage = changeMarriage + 'Old Information <br/>';
                changeMarriage = changeMarriage + 'ภาษาไทย : ' + assignSFTitleToTHTitle(Application.Name_Marriage_TH_Old_Title__c) + ' ' + Application.Name_Marriage_TH_Old_FN__c + ' ' + Application.Name_Marriage_TH_Old_LN__c + '<br/>';
                changeMarriage = changeMarriage + 'ภาษาอังกฤษ : ' + assignSFTitleToENTitle(Application.Name_Marriage_EN_Old_Title__c) + ' '  + Application.Name_Marriage_EN_Old_FN__c + ' ' + Application.Name_Marriage_EN_Old_LN__c + '<br/>';
                changeMarriage = changeMarriage + '<br/>';
                changeMarriage = changeMarriage + 'New Information <br/>';
                changeMarriage = changeMarriage + 'ภาษาไทย : ' + assignSFTitleToTHTitle(Application.Name_Marriage_TH_New_Title__c) + ' ' + Application.Name_Marriage_TH_New_FN__c + ' ' + Application.Name_Marriage_TH_New_LN__c + '<br/>';
                changeMarriage = changeMarriage + 'ภาษาอังกฤษ : ' + assignSFTitleToENTitle(Application.Name_Marriage_EN_New_Title__c) + ' ' + Application.Name_Marriage_EN_New_FN__c + ' ' + Application.Name_Marriage_EN_New_LN__c + '<br/>';
                
            }
            //Mother
            if(string.isNotEmpty(Application.Name_Mother_TH_New_FN__c)) {
                isUpdateMother = true;
                
                changeMother = 'มารดา (ถ้ามี) <br/>';
                changeMother = changeMother + 'Old Information <br/>';
                changeMother = changeMother + 'ภาษาไทย : ' + assignSFTitleToTHTitle(Application.Name_Mother_TH_Old_Title__c) + ' ' + Application.Name_Mother_TH_Old_FN__c + ' ' + Application.Name_Mother_TH_Old_LN__c + '<br/>';
                changeMother = changeMother + 'ภาษาอังกฤษ : ' + assignSFTitleToENTitle(Application.Name_Mother_EN_Old_Title__c) + ' '  + Application.Name_Mother_EN_Old_FN__c + ' ' + Application.Name_Mother_EN_Old_LN__c + '<br/>';
                changeMother = changeMother + '<br/>';
                changeMother = changeMother + 'New Information <br/>';
                changeMother = changeMother + 'ภาษาไทย : ' + assignSFTitleToTHTitle(Application.Name_Mother_TH_New_Title__c) + ' ' + Application.Name_Mother_TH_New_FN__c + ' ' + Application.Name_Mother_TH_New_LN__c + '<br/>';
                changeMother = changeMother + 'ภาษาอังกฤษ : ' + assignSFTitleToENTitle(Application.Name_Mother_EN_New_Title__c) + ' ' + Application.Name_Mother_EN_New_FN__c + ' ' + Application.Name_Mother_EN_New_LN__c + '<br/>';
                
            }
            //Father
            if(string.isNotEmpty(Application.Name_Father_TH_New_FN__c)) {
                isUpdateFather = true;
                
                changeFather = 'บิดา (ถ้ามี) <br/>';
                changeFather = changeFather + 'Old Information <br/>';
                changeFather = changeFather + 'ภาษาไทย : ' + assignSFTitleToTHTitle(Application.Name_Father_TH_Old_Title__c) + ' ' + Application.Name_Father_TH_Old_FN__c + ' ' + Application.Name_Father_TH_Old_LN__c + '<br/>';
                changeFather = changeFather + 'ภาษาอังกฤษ : ' + assignSFTitleToENTitle(Application.Name_Father_EN_Old_Title__c) + ' '  + Application.Name_Father_EN_Old_FN__c + ' ' + Application.Name_Father_EN_Old_LN__c + '<br/>';
                changeFather = changeFather + '<br/>';
                changeFather = changeFather + 'New Information <br/>';
                changeFather = changeFather + 'ภาษาไทย : ' + assignSFTitleToTHTitle(Application.Name_Father_TH_New_Title__c) + ' ' + Application.Name_Father_TH_New_FN__c + ' ' + Application.Name_Father_TH_New_LN__c + '<br/>';
                changeFather = changeFather + 'ภาษาอังกฤษ : ' + assignSFTitleToENTitle(Application.Name_Father_EN_New_Title__c) + ' ' + Application.Name_Father_EN_New_FN__c + ' ' + Application.Name_Father_EN_New_LN__c + '<br/>';
                
            }
            //Child
            if(string.isNotEmpty(Application.Name_Child_JSON__c)) {
                List<ESS_EmployeeBasic_DTO.ChildInfoDTO> childs = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
                childs = DeserializeChildJSON(Application.Name_Child_JSON__c);
                
                if(childs.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO child : childs) {
                        if(child.status == 'Edit') {
                            isUpdateChild = true;
                            
                            string changeChild = '';
                            
                            changeChild = 'บุตร (ถ้ามี) <br/>';
                            changeChild = changeChild + 'Old Information <br/>';
                            changeChild = changeChild + 'ภาษาไทย : ' + child.thFirstName + ' ' + child.thLastName + '<br/>';
                            changeChild = changeChild + 'ภาษาอังกฤษ : ' + child.enFirstName + ' ' + child.enLastName + '<br/>';
                            changeChild = changeChild + '<br/>';
                            changeChild = changeChild + 'New Information <br/>';
                            changeChild = changeChild + 'ภาษาไทย : ' + child.newTHFirstName + ' ' + child.newTHLastName + '<br/>';
                            changeChild = changeChild + 'ภาษาอังกฤษ : ' + child.newENFirstName + child.newENLastName + '<br/>';
                            changeChild = '<br/>';
                            
                            changeChilds.add(changeChild);
                        }
                    }
                }
            }
        }
        
        if(Relateds.size() > 0) {
            for(PISUsers__c Related : Relateds) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.EN_Fullname__c);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace('{!Information}', finalInformation);
                htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', Related.EN_Fullname__c);
                plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                plainBody = plainBody.replace('{!Information}', finalInformation);
                plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Application.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new String[] { Related.Email__c };
                message.setToAddresses(message.toaddresses);
                 
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
                
            }
        }
        
        if(RelatedUsers.size() > 0) {
            for(User Related : RelatedUsers) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace('{!Information}', finalInformation);
                htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                plainBody = plainBody.replace('{!Information}', finalInformation);
                plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Application.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new String[] { Related.Email };
                message.setToAddresses(message.toaddresses);
                 
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
                
            }
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }   
        
    }
    
    //E1-06
    public static void ApplicationSendToRelatedWhenMarriedStatusUpdated(ESS_Application__c Application) {
          
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        List<PISUsers__c> Relateds = ESS_Global.assignToRelatedPISUser();
        List<User> RelatedUsers = ESS_Global.assignToRelatedUser();
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_06'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
              
        if(Relateds.size() > 0) {
            for(PISUsers__c Related : Relateds) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                //TODO
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.EN_Fullname__c);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace('{!OldMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                htmlBody = htmlBody.replace('{!NewMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', Related.EN_Fullname__c);
                plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                plainBody = plainBody.replace('{!OldMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                plainBody = plainBody.replace('{!NewMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Application.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new String[] { Related.Email__c };
                message.setToAddresses(message.toaddresses);
                    
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
            }
        }
          
        if(RelatedUsers.size() > 0) {
            for(User Related : RelatedUsers) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                //TODO
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace('{!OldMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                htmlBody = htmlBody.replace('{!NewMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                plainBody = plainBody.replace('{!OldMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                plainBody = plainBody.replace('{!NewMarriedStatusTH}', assignSFMarriageStatusToTHTitle(Application.Status_Marriage_Status__c));
                plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Application.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new String[] { Related.Email };
                message.setToAddresses(message.toaddresses);
                    
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
            }
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }   
        
    }
    
    //E1-07
    public static void ApplicationSendToRelatedWhenChildUpdated(ESS_Application__c Application) {
         
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        List<PISUsers__c> Relateds = ESS_Global.assignToRelatedPISUser();
        List<User> RelatedUsers = ESS_Global.assignToRelatedUser();
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_07'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
    
        List<string> changeChilds = new List<string>();
        
        if(string.isNotEmpty(Application.Child_JSON__c)) {
            List<ESS_EmployeeBasic_DTO.ChildInfoDTO> childs = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
            childs = DeserializeChildJSON(Application.Name_Child_JSON__c);
                
            if(childs.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO child : childs) {
                    if(child.status == 'Edit') {
                        
                        string changeChild = '';
                        
                        changeChild = 'บุตร ลำดับที่ ' + child.thNo + '<br/>';
                        changeChild = changeChild + 'ภาษาไทย : ' + child.newTHFirstName + ' ' + child.newTHLastName + '<br/>';
                        changeChild = changeChild + 'ภาษาอังกฤษ : ' + child.newENFirstName + child.newENLastName + '<br/>';
                        changeChild = changeChild + '<br/><br/>';
                        changeChild = changeChild + 'เพศ : ' + assignSFGenderToTHGender(child.gender.key) + '<br/>';
                        changeChild = changeChild + 'เลขบัตรประชาชน : ' + child.citizenId + '<br/>';
                        changeChild = changeChild + 'วัน/เดือน/ปี เกิด : ' + formatDate(child.birthDate.date()) + '<br/>';
                        changeChild = changeChild + 'ประเภทบุตร : ' + assignSFChildToTHChild(child.child.key) + '<br/>';
                        changeChild = '<br/>';
                        
                        changeChilds.add(changeChild);
                    }
                }
            }
        }
        
        if(Relateds.size() > 0) {
            for(PISUsers__c Related : Relateds) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.EN_Fullname__c);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Related.User__c);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new String[] { Related.Email__c };
                message.setToAddresses(message.toaddresses);
                
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
            }
        }
        
        if(RelatedUsers.size() > 0) {
            for(User Related : RelatedUsers) {
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ReceiverName}', Related.FirstName + ' ' + Related.LastName);
                plainBody = plainBody.replace('{!EmployeeID}', Application.Employee_ID__c);
                plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
                plainBody = plainBody.replace(']]>', '');
                
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Application.Id);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                message.toAddresses = new String[] { Related.Email };
                message.setToAddresses(message.toaddresses);
                
                //Test ccEmail (Only in DEV,QAS)
                if(environment != ESS_Enum.Environment.PROD.name()) {
                    List<string> ccAddresses = ccEmails();
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
            }
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }   
        
    }
    
    //E1-08
    public static void ApplicationSendToPersonelAdminWhenUserSubmittedTax(ESS_Application__c Application) {
           
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        //List<PISUsers__c> PISUsers = ESS_Global.assignToPersonelAdminPISUser();
        PISUsers__c User = ESS_Global.assignToPISUser(Application.OwnerId);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_08'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        string createdDate;
        string submittedDate;
        if(Application.CreatedDate != null) {
            createdDate = Application.CreatedDate.format('dd/MM/yyyy');
        }
        else {
            createdDate = system.Datetime.now().format('dd/MM/yyyy');
        }
        if(Application.Submitted_Date__c != null) {
            submittedDate = formatDate(Application.Submitted_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Application.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Application.Document_No__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!EmployeeId}', Application.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        plainBody = plainBody.replace('{!DocumentNo}', Application.Document_No__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Application.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<string>();
        
        //Send Email to Admin
        Set<string> adminEmails = sendEmailForAdminApplication();
        if(adminEmails.size() > 0) {
            for(string email : adminEmails) {
                message.toAddresses.add(email);
            }
            message.setToAddresses(message.toaddresses);
        }
        
        //cc employee
        List<string> ccAddresses = new List<string>();
        ccAddresses.add(User.EMAIL__c);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCAddresses = ccEmails();
            if(testCCAddresses.size() > 0) {
                for(string ccEmail : testCCAddresses) {
                    ccAddresses.add(ccEmail);
                }
            }
        }
        message.setCcAddresses(ccAddresses);
        
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
    
    //E1-09
    public static void ApplicationSendToPersonelAdminWhenUserSubmittedContactPerson(ESS_Application__c Application) {
           
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic_Name?applicationId=' + Application.Id + '&parent=ESS_Employee_Basic';
        string URL = ESS_Global.emailURL(link);
        
        //List<PISUsers__c> PISUsers = ESS_Global.assignToPersonelAdminPISUser();
        PISUsers__c User = ESS_Global.assignToPISUser(Application.OwnerId);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_09'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        string createdDate;
        string submittedDate;
        if(Application.CreatedDate != null) {
            createdDate = Application.CreatedDate.format('dd/MM/yyyy');
        }
        else {
            createdDate = system.Datetime.now().format('dd/MM/yyyy');
        }
        if(Application.Submitted_Date__c != null) {
            submittedDate = formatDate(Application.Submitted_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Application.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!EmployeeID}', Application.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Application.Document_No__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!EmployeeId}', Application.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Application.Employee_Name__c);
        plainBody = plainBody.replace('{!DocumentNo}', Application.Document_No__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Application.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(APplication.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<string>();
        
        //Send Email to Admin
        Set<string> adminEmails = sendEmailForAdminApplication();
        if(adminEmails.size() > 0) {
            for(string email : adminEmails) {
                message.toAddresses.add(email);
            }
            message.setToAddresses(message.toaddresses);
        }
        
        //cc employee
        List<string> ccAddresses = new List<string>();
        ccAddresses.add(User.EMAIL__c);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCAddresses = ccEmails();
            if(testCCAddresses.size() > 0) {
                for(string ccEmail : testCCAddresses) {
                    ccAddresses.add(ccEmail);
                }
            }
        }
        message.setCcAddresses(ccAddresses);
        
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
    
    //Application Tax
    public static Messaging.SingleEmailMessage ApplicationTax(EmailTemplate emailTemplate, Map<string, PISUsers__c> mapPISUsers, ESS_Master_Employee__c Master) {
           
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Employee_Basic?parent=HOME';
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c PISUser = mapPISUsers.get(Master.Employee_Id__c);
        if(PISUser != null) {
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSaveAsActivity(false); 
            
            string subject = emailTemplate.Subject;
            
            string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!EmployeeName}', Master.Name_Emp_EN_FN__c + ' ' + Master.Name_Emp_EN_LN__c);
            htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, 'Employee Basic & Tax Information Update'));
            htmlBody = htmlBody.replace(']]>', '');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!EmployeeName}', Master.Name_Emp_EN_FN__c + ' ' + Master.Name_Emp_EN_LN__c);
            plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, 'Employee Basic & Tax Information Update'));
            plainBody = plainBody.replace(']]>', '');
            
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Master.Id);
            message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
            message.toAddresses = new String[] { PISUser.Email__c };
            message.setToAddresses(message.toaddresses);
                  
            //Test ccEmail (Only in DEV,QAS)
            if(environment != ESS_Enum.Environment.PROD.name()) {
                List<string> ccAddresses = ccEmails();
                message.setCcAddresses(ccAddresses);
            }
            
            if(environment != ESS_Enum.Environment.PROD.name()) {
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
                message.setOrgWideEmailAddressId(owea[0].Id);
            }
            else {
                message.setSenderDisplayName('i-Link+');
            }
            
            return message;
        }
        
        return null;
    }
    
    //Retirement
    //E2-01
    public static void RetirementSendToEmployeeWhenCreate(ESS_Retirement__c Retirement) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c PISUser = ESS_Global.assignToPISUser(Retirement.OwnerId);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_01'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string currentYear = datetime.now().format('yyyy');
        
        string createdDate;
        string submittedDate;
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        else {
            createdDate = Datetime.now().format('dd/MM/yyyy');
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CurrentYear}', currentYear);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CurrentYear}', currentYear);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { PISUser.EMAIL__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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
    
    //E2-02
    public static void RetirementSendToEmployeeWhenSubmit(ESS_Retirement__c Retirement) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c PISUser = ESS_Global.assignToPISUser(Retirement.OwnerId);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_02'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string createdDate;
        string submittedDate;
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        else {
            createdDate = String.ValueOf(date.today());
        }
        if(Retirement.Submitted_Date__c != null) {
            submittedDate = formatDate(Retirement.Submitted_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { PISUser.EMAIL__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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
    
    //E2-03
    public static void RetirementSendToSectionHead(ESS_Retirement__c Retirement) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c PISUser = ESS_Global.assignToPISUser(Retirement.Section_Head_Id__c);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_03'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string createdDate = '';
        string submittedDate = '';
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        if(Retirement.Submitted_Date__c != null) {
            submittedDate = formatDate(Retirement.Submitted_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        subject = subject.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { PISUser.EMAIL__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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
    
    //E2-03
    public static void RetirementSendToDepartmentHead(ESS_Retirement__c Retirement) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c PISUser = ESS_Global.assignToPISUser(Retirement.Department_Head_Id__c);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_03'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string createdDate = '';
        string submittedDate = '';
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        if(Retirement.Submitted_Date__c != null) {
            submittedDate = formatDate(Retirement.Submitted_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        subject = subject.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', PISUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { PISUser.EMAIL__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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
    
    //E2-04
    public static void RetirementSendToEmployeeWhenSectionHeadApproved(ESS_Retirement__c Retirement) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c OwnerUser = ESS_Global.assignToPISUser(Retirement.OwnerId);
        PISUsers__c ApproverUser = ESS_Global.assignToPISUser(Retirement.Section_Head_Id__c);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_04'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string createdDate = '';
        string submittedDate = '';
        string sectionHeadApprovedDate = '';
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        if(Retirement.Submitted_Date__c != null) {
            submittedDate = formatDate(Retirement.Submitted_Date__c);
        }
        if(Retirement.Section_Head_Approve_Date__c != null) {
            sectionHeadApprovedDate = formatDate(Retirement.Section_Head_Approve_Date__c);
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        subject = subject.replace('{!ApproverName}', ApproverUser.EN_Fullname__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', OwnerUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!ApproverName}', ApproverUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!SectionHeadApprovedDate}', sectionHeadApprovedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', OwnerUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!ApproverName}', ApproverUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!SectionHeadApprovedDate}', sectionHeadApprovedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { OwnerUser.EMAIL__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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
    
    //E2-05
    public static void RetirementSendToEmployeeWhenSectionHeadRejected(ESS_Retirement__c Retirement, string rejectedComment) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c OwnerUser = ESS_Global.assignToPISUser(Retirement.OwnerId);
        PISUsers__c ApproverUser = ESS_Global.assignToPISUser(Retirement.Section_Head_Id__c);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_05'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string createdDate = '';
        string submittedDate = '';
        string sectionHeadRejectedDate = '';
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        if(Retirement.Submitted_Date__c != null) {
            submittedDate = formatDate(Retirement.Submitted_Date__c);
        }
        if(Retirement.Reject_Date__c != null) {
            sectionHeadRejectedDate = formatDate(Retirement.Reject_Date__c);
        }
        else {
            sectionHeadRejectedDate = formatDate(date.today());
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        subject = subject.replace('{!ApproverName}', ApproverUser.EN_Fullname__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', OwnerUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!ApproverName}', ApproverUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!SectionHeadRejectedDate}', sectionHeadRejectedDate);
        htmlBody = htmlBody.replace('{!Comment}', rejectedComment);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', OwnerUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!ApproverName}', ApproverUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!SectionHeadRejectedDate}', sectionHeadRejectedDate);
        plainBody = plainBody.replace('{!Comment}', rejectedComment);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { OwnerUser.EMAIL__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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
    
    //E2-06
    public static void RetirementSendToPersonelAdminWhenDepartmentHeadApproved(ESS_Retirement__c Retirement) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        //List<PISUsers__c> PersonelAdmins = ESS_Global.assignToRetirementAdminPISUser();
        
        PISUsers__c OwnerUser = ESS_Global.assignToPISUser(Retirement.OwnerId);
        
        string sectionHeadEmail = '';
        PISUsers__c SectionHeadUser = new PISUsers__c();
        if(string.isNotBlank(Retirement.Section_Head_Id__c)) {
            SectionHeadUser = ESS_Global.assignToPISUser(Retirement.Section_Head_Id__c);
            sectionHeadEmail = SectionHeadUser.EMAIL__c;
        }
        
        PISUsers__c DepartmentHeadUser = ESS_Global.assignToPISUser(Retirement.Department_Head_Id__c);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_06'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string createdDate = '';
        string submittedDate = '';
        string departmentHeadApprovedDate = '';
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        if(Retirement.Submitted_Date__c != null) {
            submittedDate = formatDate(Retirement.Submitted_Date__c);
        }
        if(Retirement.Department_Head_Approve_Date__c != null) {
            departmentHeadApprovedDate = formatDate(Retirement.Department_Head_Approve_Date__c);
        }
        
        //Send to Employee
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        subject = subject.replace('{!ApproverName}', DepartmentHeadUser.EN_Fullname__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', OwnerUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!ApproverName}', DepartmentHeadUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DepartmentHeadApproveDate}', departmentHeadApprovedDate);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', OwnerUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!ApproverName}', DepartmentHeadUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DepartmentHeadApproveDate}', departmentHeadApprovedDate);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { OwnerUser.EMAIL__c };
        message.setToAddresses(message.toaddresses);
            
        Set<string> ccEmails = new Set<string>();
        List<string> ccAddresses = new List<string>();
        
        //CC Admin
        Set<string> ccAdminEmails = sendEmailForAdminRetirement();
        ccEmails.addAll(ccAdminEmails);

        //CC Section Head if exist
        if(string.isNotBlank(Retirement.Section_Head_Id__c)) {
            ccEmails.add(SectionHeadUser.EMAIL__c); 
        }
        //CC Department Head if exist
        if(string.isNotBlank(Retirement.Department_Head_Id__c)) {
            ccEmails.add(DepartmentHeadUser.EMAIL__c); 
        }
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
             
            //Test ccEmail (Only in DEV,QAS)
            if(environment != ESS_Enum.Environment.PROD.name()) {
                List<string> testCCAddresses = ccEmails();
                for(string ccAddress : testCCAddresses) {
                    ccAddresses.add(ccAddress);
                }
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
    
    //E2-07
    public static void RetirementSendToSectionHeadWhenDepartmentHeadRejected(ESS_Retirement__c Retirement, string rejectedComment) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Retirement_Detail?parent=ESS_Employee_Retirement&retirementId=' + Retirement.Id;
        string URL = ESS_Global.emailURL(link);
        
        PISUsers__c OwnerUser = ESS_Global.assignToPISUser(Retirement.OwnerId);
        
        string sectionHeadUserFullName = '';
        string sectionHeadUserEmail = '';
        boolean isSameOwnerAndSectionHead = false;
        
        PISUsers__c SectionHeadUser = new PISUsers__c();
        if(string.isNotEmpty(Retirement.Section_Head_Id__c)) {
            SectionHeadUser = ESS_Global.assignToPISUser(Retirement.Section_Head_Id__c);
            sectionHeadUserFullName = SectionHeadUser.EN_Fullname__c;
            sectionHeadUserEmail = SectionHeadUser.EMAIL__c;
        }
        else {
            sectionHeadUserFullName = OwnerUser.EN_Fullname__c;
            sectionHeadUserEmail = OwnerUser.EMAIL__c;
            isSameOwnerAndSectionHead = true;
        }
        
        PISUsers__c DepartmentHeadUser = ESS_Global.assignToPISUser(Retirement.Department_Head_Id__c);
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_E2_07'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        string createdDate = '';
        string submittedDate = '';
        string departmentHeadRejectedDate = '';
        
        if(Retirement.CreatedDate != null) {
            createdDate = Retirement.CreatedDate.format('dd/MM/yyyy');
        }
        if(Retirement.Submitted_Date__c != null) {
            submittedDate = formatDate(Retirement.Submitted_Date__c);
        }
        if(Retirement.Reject_Date__c != null) {
            departmentHeadRejectedDate = formatDate(Retirement.Reject_Date__c);
        }
        else {
            departmentHeadRejectedDate = formatDate(date.today());
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', Retirement.Document_No__c);
        subject = subject.replace('{!ApproverName}', DepartmentHeadUser.EN_Fullname__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', sectionHeadUserFullName);
        htmlBody = htmlBody.replace('{!ApproverOnlyName}', DepartmentHeadUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!ApproverName}', DepartmentHeadUser.EMPLOYEEID__c + ' - ' + DepartmentHeadUser.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!DepartmentHeadRejectedDate}', departmentHeadRejectedDate);
        htmlBody = htmlBody.replace('{!Comment}', rejectedComment);
        htmlBody = htmlBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', sectionHeadUserFullName);
        plainBody = plainBody.replace('{!ApproverOnlyName}', DepartmentHeadUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!ApproverName}', DepartmentHeadUser.EMPLOYEEID__c + ' - ' + DepartmentHeadUser.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', Retirement.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeId}', Retirement.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', Retirement.Employee_Name__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!DepartmentHeadRejectedDate}', departmentHeadRejectedDate);
        plainBody = plainBody.replace('{!Comment}', rejectedComment);
        plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, Retirement.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(Retirement.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new String[] { sectionHeadUserEmail };
        message.setToAddresses(message.toaddresses);
                
        Set<string> ccEmails = new Set<string>();
        List<string> ccAddresses = new List<string>();
        if(!isSameOwnerAndSectionHead) {
            ccEmails.add(OwnerUser.EMAIL__c);
            ccEmails.add(sectionHeadUserEmail);
        }
        else {
            ccEmails.add(sectionHeadUserEmail);
        }
        
        for(string ccEmail : ccEmails) {
            ccAddresses.add(ccEmail);
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCAddresses = ccEmails();
            for(string ccAddress : testCCAddresses) {
                ccAddresses.add(ccAddress);
            }
        }
        
        if(ccAddresses.size() > 0) {
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
    
    //Probation
    //E3-01
    public static Messaging.SingleEmailMessage ProbationSendToSectionHeadWhenCreated(ESS_Probationary__c probation, Map<string, PISUsers__c> mapPISUsers) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Probationary_Detail?parent=ESS_Probationary_Approve_List&probationId=' + probation.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Probation_E3_01'
        ];

        PISUsers__c receiver = mapPISUsers.get(probation.Section_Head_Id__c);
        PISUsers__c departmentHeadUser = mapPISUsers.get(probation.Department_Head_Id__c);
        
        string createdDate;

        if (probation.CreatedDate != null) {
            createdDate = probation.CreatedDate.format('dd/MM/yyyy');
        }
        else {
            createdDate = formatDate(date.today());
        }

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', probation.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!SectionHeadName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', probation.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!SectionHeadName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', probation.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        plainBody = plainBody.replace(']]>', '');

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(probation.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);
            
        List<string> ccEmails = new List<string>();
        ccEmails.add(departmentHeadUser.EMAIL__c);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCAddresses = ccEmails();
            for(string ccAddress : testCCAddresses) {
                ccEmails.add(ccAddress);
            }
        }
            
        message.setCcAddresses(ccEmails);
          
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        return message;
        
    }
    
    //E3-02
    public static Messaging.SingleEmailMessage ProbationSendToDepartmentHeadWhenSectionHeadSubmitted(ESS_Probationary__c probation, Map<string, PISUsers__c> mapPISUsers) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Probationary_Detail?parent=ESS_Probationary_Approve_List&probationId=' + probation.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Probation_E3_02'
        ];

        PISUsers__c receiver = mapPISUsers.get(probation.Department_Head_Id__c);
        PISUsers__c sectionHead = new PISUsers__c();
        
        string sectionHeadFullName = '';
        if(string.isNotEmpty(probation.Section_Head_Id__c)) {
            sectionHead = ESS_Global.assignToPISUser(
            probation.Section_Head_Id__c
            );
            
            sectionHeadFullName = sectionHead.EMPLOYEEID__c + ' - ' + sectionHead.EN_Fullname__c;
        }
        
        string createdDate;
        if (probation.CreatedDate != null) {
            createdDate = probation.CreatedDate.format('dd/MM/yyyy');
        }
        else {
            createdDate = formatDate(date.today());
        }

        string sectionHeadSubmittedDate;
        if (probation.Section_Head_Approve_Date__c != null) {
            sectionHeadSubmittedDate = formatDate(probation.Section_Head_Approve_Date__c);
        }
        else {
            sectionHeadSubmittedDate = formatDate(date.today());
        }

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', probation.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DepartmentHeadName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', probation.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SectionHeadName}', sectionHeadFullName);
        htmlBody = htmlBody.replace('{!SectionHeadSubmittedDate}', sectionHeadSubmittedDate);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DepartmentHeadName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', probation.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SectionHeadName}', sectionHeadFullName);
        plainBody = plainBody.replace('{!SectionHeadSubmittedDate}', sectionHeadSubmittedDate);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        plainBody = plainBody.replace(']]>', '');

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(probation.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);

        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        return message;
        
    }

    //E3-03
    public static void ProbationSendToSectionHeadWhenDepartmentHeadRejected(ESS_Probationary__c probation) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Probationary_Detail?parent=ESS_Probationary_Approve_List&probationId=' + probation.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Probation_E3_03'
        ];

        PISUsers__c receiver = ESS_Global.assignToPISUser(
        probation.Section_Head_Id__c
        );
        PISUsers__c departmentHead = ESS_Global.assignToPISUser(
        probation.Department_Head_Id__c
        );

        string createdDate = '';
        if (probation.CreatedDate != null) {
            createdDate = probation.CreatedDate.format('dd/MM/yyyy');
        }

        string departmentHeadRejectedDate;
        if (probation.Department_Head_Reject_Date__c != null) {
            departmentHeadRejectedDate = formatDate(probation.Department_Head_Reject_Date__c);
        }
        else {
            departmentHeadRejectedDate = formatDate(date.today());
        }

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', probation.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!SectionHeadName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', probation.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!DepartmentHeadName}', departmentHead.EMPLOYEEID__c + ' - ' + departmentHead.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DepartmentHeadRejectedDate}', departmentHeadRejectedDate);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!SectionHeadName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', probation.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!DepartmentHeadName}', departmentHead.EMPLOYEEID__c + ' - ' + departmentHead.EN_Fullname__c);
        plainBody = plainBody.replace('{!DepartmentHeadRejectedDate}', departmentHeadRejectedDate);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        plainBody = plainBody.replace(']]>', '');

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(probation.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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

    //E3-04
    public static void ProbationSendToPersonelAdminWhenDepartmentHeadApproved(ESS_Probationary__c probation) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Probationary_Detail?parent=ESS_Probationary_Approve_List&probationId=' + probation.Id;
        string URL = ESS_Global.emailURL(link);
        
        //List<PISUsers__c> PISUsers = ESS_Global.assignToProbationAdminPISUser();

        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Probation_E3_04'
        ];

        PISUsers__c sectionHead = new PISUsers__c();
        
        string sectionHeadName = '';
        if(string.isNotEmpty(probation.Section_Head_Id__c)) {
            sectionHead = ESS_Global.assignToPISUser(
            probation.Section_Head_Id__c
            );
            
            sectionHeadName = sectionHead.EMPLOYEEID__c + ' - ' + sectionHead.EN_Fullname__c;
        }
        else {
            sectionHead = ESS_Global.assignToPISUser(
            probation.OwnerId
            );
            
            sectionHeadName = sectionHead.EMPLOYEEID__c + ' - ' + sectionHead.EN_Fullname__c;
        }
        
        PISUsers__c departmentHead = ESS_Global.assignToPISUser(
        probation.Department_Head_Id__c
        );

        string sectionHeadSubmittedDate;
        if (probation.Section_Head_Approve_Date__c != null) {
            sectionHeadSubmittedDate = formatDate(probation.Section_Head_Approve_Date__c);
        }
        else {
            if(probation.CreatedDate != null) {
                sectionHeadSubmittedDate = formatDate(probation.CreatedDate.date());
            }
        }

        string departmentHeadSubmittedDate;
        if (probation.Department_Head_Approve_Date__c != null) {
            departmentHeadSubmittedDate = formatDate(probation.Department_Head_Approve_Date__c);
        }

        string probationStatus;
        if(probation.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm.name()) {
            probationStatus = 'Confirmed';
        }
        else if(probation.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Terminate.name()) {
            probationStatus = 'Terminated';
        }
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        string createdDate = '';
        string submittedDate = '';
        
        if(probation.CreatedDate != null) {
            createdDate = formatDate(probation.CreatedDate.date());
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false); 
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', probation.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ProbationStatus}', probationStatus);
        htmlBody = htmlBody.replace('{!DocumentNo}', probation.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!SectionHeadName}', sectionHeadName);
        htmlBody = htmlBody.replace('{!SectionHeadSubmittedDate}', sectionHeadSubmittedDate);
        htmlBody = htmlBody.replace('{!DepartmentHeadName}', departmentHead.EMPLOYEEID__c + ' - ' + departmentHead.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DepartmentHeadSubmittedDate}', departmentHeadSubmittedDate);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ProbationStatus}', probationStatus);
        plainBody = plainBody.replace('{!DocumentNo}', probation.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!SectionHeadName}', sectionHeadName);
        plainBody = plainBody.replace('{!SectionHeadSubmittedDate}', sectionHeadSubmittedDate);
        plainBody = plainBody.replace('{!DepartmentHeadName}', departmentHead.EMPLOYEEID__c + ' - ' + departmentHead.EN_Fullname__c);
        plainBody = plainBody.replace('{!DepartmentHeadSubmittedDate}', departmentHeadSubmittedDate);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        plainBody = plainBody.replace(']]>', '');
        
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(probation.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        
        //Send Email to Admin
        Set<string> adminEmails = sendEmailForAdminProbation();
        if(adminEmails.size() > 0) {
            for(string email : adminEmails) {
                message.toAddresses.add(email);
            }
            message.setToAddresses(message.toaddresses);
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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

    //E3-05
    public static void ProbationSendToReAssignUserWhenReAssigned(ESS_Probationary__c probation) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Probationary_Detail?parent=ESS_Probationary_Approve_List&probationId=' + probation.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Probation_E3_05'
        ];

        ESS_Probationary_DTO.ReassignDTO reassignDTO;
        ESS_Probationary_DTO.ReassignDTO reassignByDTO;
        PISUsers__c reassignBy;
        string comment = '';
        
        if(probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
        
            List<ESS_Probationary_DTO.ReassignDTO> reassignList = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(probation.Reassign_Section_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            reassignDTO = reassignList.get(reassignList.size() - 1);
            reassignBy = ESS_Global.assignToPISUser(
                probation.Section_Head_Id__c
            );
        	
            reassignByDTO = reassignList.get(reassignList.size() - 2);
            comment = reassignByDTO.comment;
        }
        else if(probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name())
        {
            List<ESS_Probationary_DTO.ReassignDTO> reassignList = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(probation.Reassign_Department_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            reassignDTO = reassignList.get(reassignList.size() - 1);
            reassignBy = ESS_Global.assignToPISUser(
                probation.Department_Head_Id__c
            );
            
            reassignByDTO = reassignList.get(reassignList.size() - 2);
            comment = reassignByDTO.comment;
        }

        PISUsers__c receiver = ESS_Global.assignToPISUser(
            reassignDTO.userId
        );

        string createdDate = '';

        if (probation.CreatedDate != null) {
            createdDate = probation.CreatedDate.format('dd/MM/yyyy');
        }

        string reassignedDate = '';

        if (reassignDTO.reassignedDate != null)
        {
            reassignedDate = formatDate(reassignDTO.reassignedDate);
        }

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', probation.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReassignedName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', probation.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!ReassignBy}', reassignBy.EMPLOYEEID__c + ' - ' + reassignBy.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!ReassignedDate}', reassignedDate);
        htmlBody = htmlBody.replace('{!Comment}', comment);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReassignedName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', probation.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!ReassignBy}', reassignBy.EMPLOYEEID__c + ' - ' + reassignBy.EN_Fullname__c);
        plainBody = plainBody.replace('{!ReassignedDate}', reassignedDate);
        plainBody = plainBody.replace('{!Comment}', comment);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        plainBody = plainBody.replace(']]>', '');

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(probation.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);

        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
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
    
    //E3-05 (Reminder)
    public static Messaging.SingleEmailMessage ProbationSendToReAssignUserWhenReAssigned(ESS_Probationary__c probation, Map<string, PISUsers__c> mapPISUsers) 
    {
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Probationary_Detail?parent=ESS_Probationary_Approve_List&probationId=' + probation.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Probation_E3_05'
        ];

        ESS_Probationary_DTO.ReassignDTO reassignDTO;
        ESS_Probationary_DTO.ReassignDTO reassignByDTO;
        PISUsers__c reassignBy;
        string comment = '';
        
        if(probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
        
            List<ESS_Probationary_DTO.ReassignDTO> reassignList = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(probation.Reassign_Section_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            reassignDTO = reassignList.get(reassignList.size() - 1);
            reassignBy = ESS_Global.assignToPISUser(
                probation.Section_Head_Id__c
            );
        	
            reassignByDTO = reassignList.get(reassignList.size() - 2);
            comment = reassignByDTO.comment;
        }
        else if(probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name())
        {
            List<ESS_Probationary_DTO.ReassignDTO> reassignList = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(probation.Reassign_Department_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            reassignDTO = reassignList.get(reassignList.size() - 1);
            reassignBy = ESS_Global.assignToPISUser(
                probation.Department_Head_Id__c
            );
            
            reassignByDTO = reassignList.get(reassignList.size() - 2);
            comment = reassignByDTO.comment;
        }

        PISUsers__c receiver = ESS_Global.assignToPISUser(
            reassignDTO.userId
        );

        string createdDate = '';

        if (probation.CreatedDate != null) {
            createdDate = probation.CreatedDate.format('dd/MM/yyyy');
        }

        string reassignedDate = '';

        if (reassignDTO.reassignedDate != null)
        {
            reassignedDate = formatDate(reassignDTO.reassignedDate);
        }

        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', probation.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReassignedName}', receiver.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', probation.Document_No__c);
        htmlBody = htmlBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        htmlBody = htmlBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        htmlBody = htmlBody.replace('{!CreatedDate}', createdDate);
        htmlBody = htmlBody.replace('{!ReassignBy}', reassignBy.EMPLOYEEID__c + ' - ' + reassignBy.EN_Fullname__c);
        htmlBody = htmlBody.replace('{!ReassignedDate}', reassignedDate);
        htmlBody = htmlBody.replace('{!Comment}', comment);
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        htmlBody = htmlBody.replace(']]>', '');

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReassignedName}', receiver.EN_Fullname__c);
        plainBody = plainBody.replace('{!DocumentNo}', probation.Document_No__c);
        plainBody = plainBody.replace('{!EmployeeID}', probation.Employee_ID__c);
        plainBody = plainBody.replace('{!EmployeeName}', probation.Employee_Name_EN__c);
        plainBody = plainBody.replace('{!CreatedDate}', createdDate);
        plainBody = plainBody.replace('{!ReassignBy}', reassignBy.EMPLOYEEID__c + ' - ' + reassignBy.EN_Fullname__c);
        plainBody = plainBody.replace('{!ReassignedDate}', reassignedDate);
        plainBody = plainBody.replace('{!Comment}', comment);
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL, probation.Document_No__c));
        plainBody = plainBody.replace(']]>', '');

        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(probation.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ receiver.Email__c };
        message.setToAddresses(message.toaddresses);

        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        return message;
    }
    
    private static List<ESS_EmployeeBasic_DTO.ChildInfoDTO> DeserializeChildJSON(string childJSON) {
        List<ESS_EmployeeBasic_DTO.ChildInfoDTO> childDTOs = (List<ESS_EmployeeBasic_DTO.ChildInfoDTO>)JSON.deserialize(childJSON, List<ESS_EmployeeBasic_DTO.ChildInfoDTO>.class);
        return childDTOs;
    }

    public static string formatDate(Date d) {
        DateTime newDT = system.Datetime.newInstance(d.year(), d.month(), d.day());
        string convertedDate = newDT.format('dd/MM/yyyy'); 
        return convertedDate;
    }
    
    @TestVisible
    private static string assignSFTitleToTHTitle(string title) {
        string sfTitle;
        
        if(title == '1') {
            sfTitle = 'นาย';
        } 
        else if(title == '2') {
            sfTitle = 'นาง';
        }
        else if(title == '3') {
            sfTitle = 'นางสาว';
        }  
        else if(title == '4') {
            sfTitle = 'นางสาว';
        } 
        else if(title == '5') {
            sfTitle = 'ดร';
        }
        
        return sfTitle;
    }
    
    @TestVisible
    private static string assignSFTitleToENTitle(string title) {
        string sfTitle;
        
        if(title == '1') {
            sfTitle = 'Mr';
        } 
        else if(title == '2') {
            sfTitle = 'Mrs';
        }
        else if(title == '3') {
            sfTitle = 'Ms';
        }  
        else if(title == '4') {
            sfTitle = 'Miss';
        } 
        else if(title == '5') {
            sfTitle = 'Dr';
        }
        
        return sfTitle;
    }
    
    @TestVisible
    private static string assignSFMarriageStatusToTHTitle(string marriageStatus) {
        string sfStatus;
        
        if(marriageStatus == '1') {
            sfStatus = 'สมรส';
        } 
        else if(marriageStatus == '2') {
            sfStatus = 'หย่าร้าง';
        }
        else if(marriageStatus == '3') {
            sfStatus = 'หม้าย';
        }  
        else if(marriageStatus == '4') {
            sfStatus = 'โสด';
        } 
        else if(marriageStatus == '5') {
            sfStatus = 'แยกทาง';
        }
        
        return sfStatus;
    }
    
    @TestVisible
    private static string assignSFGenderToTHGender(string gender) {
        string sfGender;
        
        if(gender == 'Male') {
            sfGender = 'ชาย';
        } 
        else if(gender == 'Female') {
            sfGender = 'หญิง';
        }        
        
        return sfGender;
    }
   
    @TestVisible
    private static string assignSFChildToTHChild(string type) {
        string sfType;
        
        if(type == 'Child') {
            sfType = 'บุตร';
        } 
        else if(type == 'Protege') {
            sfType = 'บุตรบุญธรรม';
        }        
        
        return sfType;
    }
    
    public static List<string> ccEmails() {
        List<string> ccAddresses = new List<string>();
        ccAddresses.add('PATTAMA@THAIOILGROUP.COM');
        ccAddresses.add('JARIYAS@THAIOILGROUP.COM');
        ccAddresses.add('BOONTHO@THAIOILGROUP.COM');
        ccAddresses.add('SUMANA@THAIOILGROUP.COM');
        ccAddresses.add('THANIDA@THAIOILGROUP.COM');
        ccAddresses.add('pipat@thaioilgroup.com');
        ccAddresses.add('atittaya@softever.co.th');
        ccAddresses.add('sarocha@softever.co.th');
        ccAddresses.add('sinlapat@softever.co.th');
        ccAddresses.add('puttipat@softever.co.th');
        return ccAddresses;
    }
    
    public static string LinkURL(string URL, string documentNo) {
        string returnURL = '<a href=\'' + URL + '\'>' + documentNo + '</a>';
        return returnURL;
    }
    
    public static Set<string> sendEmailForAdminApplication() {
        
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = ESS_Global.assignToPersonelAdminUser();
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = ESS_Global.assignToPersonelAdminPISUser();
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
    
    public static Set<string> sendEmailForAdminRetirement() {
        
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = ESS_Global.assignToRetirementAdminUser();
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = ESS_Global.assignToRetirementAdminPISUser();
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
    
    public static Set<string> sendEmailForAdminProbation() {
        
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = ESS_Global.assignToProbationAdminUser();
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = ESS_Global.assignToProbationAdminPISUser();
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