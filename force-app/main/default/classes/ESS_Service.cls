public with sharing class ESS_Service {

    public static string sharePointURL {get;set;}
    public static string sharePointTokenAPI {get;set;}
    public static string sharePointUploadAPI {get;set;}
    public static string sharePointUsername {get;set;}
    public static string sharePointPassword {get;set;}
    public static string ResponseMessage {get;set;}
    public static string MainStatus {get;set;}
    public static string ResponseBody {get;set;}
    public static ResponseTokenWrapper RTWrapper {get;set;}
    public static string accesstoken {get;set;}
    public static integer responseStatusCode {get;set;}
    
    public class TokenWrapper {
        public string username {get;set;}
        public string password {get;set;}
    }
    
    public class ResponseTokenWrapper {
        public string token {get;set;}
        public string username {get;set;}
    }
    
    //Monthly API
    public static string monthlyUrl {get;set;}
    public static string monthlyPath {get;set;}
    public static string monthlyUsername {get;set;}
    public static string monthlyPassword {get;set;}
    public static MonthlyDTO MW {get;set;}
    
    public class MonthlyDTO {
        @RemoteAction
        public decimal MonthlyIncome {get;set;}
        @RemoteAction
        public decimal NetIncome {get;set;}
        @RemoteAction
        public string EmployeeId {get;set;}
    }
    
    public static ESS_Config__c GetConfig() {
        ESS_Config__c ESSConfig = [select SharePointUrl__c, SharePointTokenPath__c, SharePointUploadPath__c, SharePointUsername__c, SharePointPassword__c,
                                   MonthlyUrl__c, MonthlyPath__c, MonthlyUsername__c, MonthlyPassword__c from ESS_Config__c];
        return ESSConfig;
    }
    
    public static string GetRequestTokenForSharePoint() {
        
        accesstoken = '';
        
        ESS_Config__c ESSConfig = GetConfig();
        sharePointURL = ESSConfig.SharePointUrl__c;
        sharePointTokenAPI = ESSConfig.SharePointTokenPath__c;
        sharePointUploadAPI = ESSConfig.SharePointUploadPath__c;
        sharePointUsername = ESSConfig.SharePointUsername__c;
        sharePointPassword = ESSConfig.SharePointPassword__c;
        
        //To send request for token
        HttpRequest requesttoken = new HttpRequest();
        HttpResponse responsetoken = new HttpResponse();
        Http httptoken = new Http();
        requesttoken.setMethod('POST');
        requesttoken.setEndpoint(sharePointURL + sharePointTokenAPI);  //Dev Test   
        requesttoken.setHeader('Content-Type', 'application/json'); 
        
        TokenWrapper TW = new TokenWrapper();
        TW.username = sharePointUsername;
        TW.password = sharePointPassword;
        
        string jsonToken = JSON.serialize(TW);
        
        requesttoken.setBody(jsonToken);
        
        try{
            responsetoken = httptoken.send(requesttoken);
        }catch(exception e){
            ResponseMessage='Cannot get token. Error message : ( '+e.getMessage()+' )' ;
        }
        
        MainStatus = String.ValueOf(responsetoken.getStatusCode());
        
        //If authentication has been granted
        if(responsetoken.getStatusCode() == 200) {
            
            ResponseBody = String.ValueOf(responsetoken.getBody());
            JSONParser parser = JSON.createParser(ResponseBody);
            
            RTWrapper = new ResponseTokenWrapper();
            RTWrapper = (ResponseTokenWrapper)parser.readValueAs(ResponseTokenWrapper.class);
            
            accesstoken = RTWrapper.token;
        }
        else {
            ResponseBody = String.ValueOf(responsetoken);
        }
        
        return accesstoken;
    }
    
    //Test : 08000127
    public static MonthlyDTO MonthlyIncomeSOAPAPI(string employeeId) {
        
        ESS_Config__c ESSConfig = GetConfig();
        monthlyUrl = ESSConfig.MonthlyUrl__c;
        monthlyPath = ESSConfig.MonthlyPath__c;
        monthlyUsername = ESSConfig.MonthlyUsername__c;
        monthlyPassword = ESSConfig.MonthlyPassword__c;
        
        MW = new MonthlyDTO();
        
        String xmlBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">'+
                        '<soapenv:Header/>'+
                        '<soapenv:Body>'+
                        '<urn:ZTHRPYB004>'+
                        '<IM_PERNR>'+employeeId+'</IM_PERNR>'+
                        '</urn:ZTHRPYB004>'+
                        '</soapenv:Body>'+
                        '</soapenv:Envelope>';
        httpRequest httpRequest = new httpRequest();
        httpRequest.setHeader('Content-type','application/XML');
        Http httpObject = new Http();
        HttpResponse httpResponse;
        String username = monthlyUsername;
        String password = monthlyPassword;
        Blob headerValue = blob.valueOf(username + ':' + password);
        string authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        httpRequest.setHeader('Authorization', authorizationHeader);
        
        httpRequest.setHeader('Content-type', 'text/xml');
        httpRequest.setEndpoint(monthlyUrl + monthlyPath);
        httpRequest.setMethod('POST');
        httpRequest.setTimeout(120000);
        httpRequest.setBody(xmlBody);
        
        if(!Test.isRunningTest()) {
            httpResponse = httpObject.send(httpRequest);
        
            if(httpResponse.getStatusCode() == 200) {
                
                Dom.Document doc = httpResponse.getBodyDocument();
                
                for(Dom.XmlNode node: doc.getRootElement().getChildElements()) {
                    for(Dom.XmlNode childNode: node.getChildElements()) {
                        if(childNode.getName() == 'ZTHRPYB004.Response') {
                            decimal exMTHIN = 0;
                            decimal exNETIN = 0;
                            string exPERNR = '';
                            Dom.XmlNode EX_MTHIN = childNode.getChildElement('EX_MTHIN', null);
                            if (EX_MTHIN != null) {
                                exMTHIN = Decimal.ValueOf(EX_MTHIN.getText());
                            }  
                            Dom.XmlNode EX_NETIN = childNode.getChildElement('EX_NETIN', null);
                            if (EX_NETIN != null) {
                                exNETIN = Decimal.ValueOf(EX_NETIN.getText());
                            } 
                            Dom.XmlNode EX_PERNR = childNode.getChildElement('EX_PERNR', null);
                            if (EX_PERNR != null) {
                                exPERNR = EX_PERNR.getText();
                            } 
                            MW.MonthlyIncome = exMTHIN;
                            MW.NetIncome = exNETIN;
                            MW.EmployeeId = exPERNR;
                        }
                    }
                }
            }else{
                system.debug('Response - ' + httpResponse.getBody());
            }
       
        }
        
        
        return MW;
    }
    
    //Upload File to PersonalFolder
    @future(callout=true)
    public static void FileUploadPersonelFolder(string recordId, string contentDocumentId, string employeeId, string templateFolderCode) 
    {
        if(!Test.isRunningTest()) {
            accesstoken = GetRequestTokenForSharePoint();
        }
        
        ESS_Config__c ESSConfig = GetConfig();
        sharePointURL = ESSConfig.SharePointUrl__c;
        sharePointTokenAPI = ESSConfig.SharePointTokenPath__c;
        sharePointUploadAPI = ESSConfig.SharePointUploadPath__c;
        sharePointUsername = ESSConfig.SharePointUsername__c;
        sharePointPassword = ESSConfig.SharePointPassword__c;
       
        List<attachment> attachments = new List<attachment>();
        attachments = [select id, parentId, name, body from attachment where parentId = :recordId AND id =: contentDocumentId limit 1];
        if(!attachments.isEmpty())   
        {
            string fileName;
            //Probation
            if(templateFolderCode == '1') {
                fileName = employeeId + '-Probation.pdf';
            }
            //Retirement
            else if(templateFolderCode == '2') {
                fileName = employeeId + '-Retirement.pdf';
            }
            
            //callout
            string contentType = EinsteinVision_HttpBodyPart.GetContentType();
            
            //  Compose the form
            string form64 = '';
            //******This was the boundary I was missing****
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBodyParameter('FileName', fileName);
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBodyParameter('EmployeeID', employeeId);
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBodyParameter('TemplateFolderCode', templateFolderCode);
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBlobBodyParameter('File', EncodingUtil.base64Encode(attachments[0].body), fileName);
            
            blob formBlob = EncodingUtil.base64Decode(form64);
            string contentLength = string.valueOf(formBlob.size());
            
            if(formBlob.size()>12000000)
            {
                //this a "public class CustomException extends Exception{}"
                throw new ESS_Exception('File size limit is 12 MBytes');
            }
            else if(string.isNotEmpty(accesstoken))
            {
                
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(sharePointURL + sharePointUploadAPI);
                req.setBodyAsBlob(formBlob);
                req.setHeader('Authorization', 'Bearer ' + accesstoken);
                req.setHeader('Connection', 'keep-alive');
                req.setHeader('Content-Length', contentLength);
                req.setHeader('Content-Type', contentType);
                req.setTimeout(120000);
                Http http =new Http();
                HTTPResponse res = http.send(req);
                
                if(!Test.isRunningTest()) {
                    responseStatusCode = res.getStatusCode(); 
                }
                
                string responseBody = String.valueof(res.getbody()); 
                if(responseStatusCode == 200) {
                     //Probation
                    if(templateFolderCode == '1') {
                        ESS_Probationary__c Probation = [select id, status__c, Completed_Date__c from ESS_Probationary__c where Id = :recordId];
                        Probation.Status__c = ESS_Enum.ProbationApproveStatus.Completed.name();
                        Probation.Completed_Date__c = date.today();
                        database.update(Probation, true);
                    }
                    //Retirement
                    else if(templateFolderCode == '2') {
                        ESS_Retirement__c Retirement = [select id, status__c, Sending_To_SAP_Date__c, Upload_To_Personal_Folder_Date__c from ESS_Retirement__c where Id = :recordId];
                        Retirement.Status__c = ESS_Enum.RetirementStatus.SendingToSAP.name();
                        Retirement.Upload_To_Personal_Folder_Date__c = date.today();
                        Retirement.Sending_To_SAP_Date__c = date.today();
        				database.update(Retirement, true);
                    }
                }
                else if(responseStatusCode != 200) {
                    //Probation
                    if(templateFolderCode == '1') {
                        ESS_Probationary__c Probation = [select id, status__c, Uploaded_Status__c from ESS_Probationary__c where Id = :recordId];
                        Probation.Status__c = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
                        Probation.Uploaded_Status__c = responseBody;
                        if(string.isEmpty(accesstoken)) {
                            Probation.Uploaded_Status__c = '503 - Service unavailable';
                        }
        				database.update(Probation, true);
                    }
                    //Retirement
                    else if(templateFolderCode == '2') {
                    	ESS_Retirement__c Retirement = [select id, status__c, Uploaded_Status__c from ESS_Retirement__c where Id = :recordId];
                        Retirement.Status__c = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
                        Retirement.Uploaded_Status__c = responseBody;
                        if(string.isEmpty(accesstoken)) {
                            Retirement.Uploaded_Status__c = '503 - Service unavailable';
                        }
                        database.update(Retirement);
                    }
                }
            }
            else {
                //Probation
                if(templateFolderCode == '1') {
                    ESS_Probationary__c Probation = [select id, status__c, Uploaded_Status__c from ESS_Probationary__c where Id = :recordId];
                    Probation.Status__c = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
                    Probation.Uploaded_Status__c = '503 - Service unavailable';
                    database.update(Probation, true);
                }
                //Retirement
                else if(templateFolderCode == '2') {
                    ESS_Retirement__c Retirement = [select id, status__c, Uploaded_Status__c from ESS_Retirement__c where Id = :recordId];
                    Retirement.Status__c = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
                    Retirement.Uploaded_Status__c = '503 - Service unavailable';
                    database.update(Retirement);
                }
            }
		}
    }
    
    /* public void TestAPI() {
        
        ESS_Config__c ESSConfig = GetConfig();
        sharePointURL = ESSConfig.SharePointUrl__c;
        sharePointTokenAPI = ESSConfig.SharePointTokenPath__c;
        sharePointUploadAPI = ESSConfig.SharePointUploadPath__c;
        sharePointUsername = ESSConfig.SharePointUsername__c;
        sharePointPassword = ESSConfig.SharePointPassword__c;
        
        //To send request for token
        HttpRequest requesttoken = new HttpRequest();
        HttpResponse responsetoken = new HttpResponse();
        Http httptoken = new Http();
        requesttoken.setMethod('GET');
        requesttoken.setEndpoint('https://dev-onlinedriver.softever.co.th/develop/backend/truck/api/Users/CarrierDropdownList?searchKey=softever');  //Dev Test   
        //requesttoken.setHeader('Content-Type', 'application/json'); 
        
        TokenWrapper TW = new TokenWrapper();
        TW.username = sharePointUsername;
        TW.password = sharePointPassword;
        
        string jsonToken = JSON.serialize(TW);
        
        //requesttoken.setBody(jsonToken);
        
        try{
            responsetoken = httptoken.send(requesttoken);
        }catch(exception e){
            ResponseMessage='Cannot get token. Error message : ( '+e.getMessage()+' )' ;
        }
        
        MainStatus = String.ValueOf(responsetoken.getStatusCode());
        
        //If authentication has been granted
        if(responsetoken.getStatusCode() == 200) {
            
            ResponseBody = String.ValueOf(responsetoken.getBody());
            //JSONParser parser = JSON.createParser(ResponseBody);
            
            //RTWrapper = new ResponseTokenWrapper();
            
            //RTWrapper = (ResponseTokenWrapper)parser.readValueAs(ResponseTokenWrapper.class);
            //string accesstoken = RTWrapper.token;
            //system.debug(accesstoken);
        }
        else {
            ResponseBody = String.ValueOf(responsetoken);
        }
    } */
    
    /* @future(callout=true)
    public static void TestFileUploadPersonelFolder() 
    {
        string accesstoken = GetRequestTokenForSharePoint();
        
        ESS_Config__c ESSConfig = GetConfig();
        sharePointURL = ESSConfig.SharePointUrl__c;
        sharePointTokenAPI = ESSConfig.SharePointTokenPath__c;
        sharePointUploadAPI = ESSConfig.SharePointUploadPath__c;
        sharePointUsername = ESSConfig.SharePointUsername__c;
        sharePointPassword = ESSConfig.SharePointPassword__c;
       
        List<attachment> attachments = new List<attachment>();
        attachments = [select id, parentId, name, body from attachment where parentId = 'a239D000000o2UcQAI' AND id = '00P9D00000AlVdsUAF' limit 1];
        System.debug('Callout Log 1:' + attachments);
        if(!attachments.isEmpty())   
        {
            string fileName;
            //fileName = 'Retirement.pdf';
            fileName = '00000435' + '-Probation.pdf';
            
            System.debug('Callout Log 2:' + fileName);
            
            //callout
            string contentType = EinsteinVision_HttpBodyPart.GetContentType();
            
            //  Compose the form
            string form64 = '';
            //******This was the boundary I was missing****
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBodyParameter('FileName', fileName);
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBodyParameter('EmployeeID', '00000435');
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBodyParameter('TemplateFolderCode', '1');
            system.debug(EncodingUtil.base64Decode(form64).toString());
            
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBlobBodyParameter('File', EncodingUtil.base64Encode(attachments[0].body), fileName);
            
            blob formBlob = EncodingUtil.base64Decode(form64);
            string contentLength = string.valueOf(formBlob.size());
            system.debug(form64);
            System.debug('Callout Log 3:' + formBlob.size());
            
            if(formBlob.size()>12000000)
            {
                //this a "public class CustomException extends Exception{}"
                throw new ESS_Exception('File size limit is 12 MBytes');
            }
            else
            {
                
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(sharePointURL + sharePointUploadAPI);
                req.setBodyAsBlob(formBlob);
                req.setHeader('Authorization', 'Bearer ' + accesstoken);
                req.setHeader('Connection', 'keep-alive');
                req.setHeader('Content-Length', contentLength);
                req.setHeader('Content-Type', contentType);
                req.setTimeout(120000);
                Http http =new Http();
                HTTPResponse res = http.send(req);
                System.debug('Callout Log 4:' + res.getStatusCode());
                System.debug('Callout Log 5:' + String.valueof(res.getbody()));
                
                integer responseStatusCode = res.getStatusCode(); 
                
                string responseBody = String.valueof(res.getbody()); 
                
                if(responseStatusCode == 200) {
                     //Probation
                    
                }
                else if(responseStatusCode != 200) {
                    
                }
            }
		}
    } */
    
}