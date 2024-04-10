public with sharing class CTRSharPointFileController 
{
    public static FINAL String BOUNDARY = '1ff13444ed8140c7a32fc4e6451aa76d';

    public class FileWrapper 
    {
        public string mTitle{get; set;}
        public string mBodyBase64{get;set;}
        public blob mFileBody{get;set;}
        public string mId{get; set;} //newadd23Jan24

    }

    // @future(callout=true)
    public static void UploadFileToSharePoint(String mPath, Set<Id> mContentDocumentListId)
    {
        try
        {
            mPath = (String.isBlank(mPath)? '/Account/Test':mPath);//mPath = (String.isBlank(mPath)? '/Account/Test':mPath);
            List<ContentVersion> mVersionList = [SELECT Id, ContentDocumentId, VersionData,ContentDocument.Title, FileType, FileExtension, ContentSize FROM ContentVersion WHERE IsLatest=true AND ContentDocumentId IN: mContentDocumentListId];
            
            C360Integration__c mDefault360Data = C360Integration__c.getInstance();
            String mFolderName = mDefault360Data.SharePoint_Document_Folder__c;
            
            //Add
            System.debug('--mFolderName--'+mFolderName);
            System.debug('--mContentDocumentListId--'+mContentDocumentListId);
            System.debug('--mVersionList--'+mVersionList);

            List<FileWrapper> mFileList = new List<FileWrapper>();
            for(ContentVersion mVersion: mVersionList)
            {

                    Blob mFileBody = mVersion.VersionData;
                    FileWrapper mFileData = new FileWrapper();
                    mFileData.mTitle = mVersion.ContentDocument.Title+'.'+mVersion.FileExtension;
                    mFileData.mFileBody = mFileBody;
                    mFileData.mId = mVersion.ContentDocumentId; //newadd23Jan24
                    mFileList.add(mFileData);
                

            }
            
            //getInstance(developerName)
            C360Integration__c mSetting = C360Integration__c.getInstance();
            CTRIntegraionList__mdt tokenMdt = CTRIntegraionList__mdt.getInstance('CTRUploadFileSharepoint');
            // System.debug('--token--'+token);
            // System.debug('--token.Token__c--'+token.Token__c);
            // System.debug(tokenMdt.Token__c != null );

            if(mFileList.size()>0)
            {
                if(tokenMdt.Token__c != null)
                {
                    List<blob> mBlobList = new List<blob>();

                    Integer fileCount = 0;
                    for(FileWrapper mFile: mFileList)
                    {
                        String url = mPath;

                        // Find the index where 'Shared Documents' starts
                        Integer startIndex = url.indexOf('Shared Documents');

                        // Extract the substring from the startIndex to the end of the URL
                        String extractedSubstring = url.substring(startIndex);

                        System.debug('--extractedSubstring--'+extractedSubstring);

                        sendFileToHeroku(mFolderName, extractedSubstring/*mPath*/,mSetting.HerokuIntegrationDomain__c+tokenMdt.Path__c , mFile.mTitle, mFile.mFileBody, tokenMdt.Token__c); 

                        /* RE-TEST
                        // // sendFileToHeroku(mFolderName, mPath, mFile.mTitle, mFile.mFileBody, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImEzWjFtMDAwMDAwUlVZZUVBTyIsInVzZXJuYW1lIjoibW9rZS5rQHJvdW5kdHdvc29sdXRpb25zLmNvbSIsImFjY291bnRzIjpbeyJJZCI6IjAwMTFtMDAwMDBtR1A3OUFBRyJ9XSwiaWF0IjoxNzA1OTE4ODg1LCJleHAiOjE3MDU5MjI0ODV9.zr5pHDyXn8CYxqQqiaWTWzPkJhIVc-3U8youa68RtTQ'); //mTokenResult.mToken); 
                        // fileCount += 1;

                        // if(responsesendfile.contains('Exists: true')){ //if(fileCount == mFileList.size()){
                        //     System.debug('fileCount==>'+fileCount);
                        //     deleteFileSalesforce(mFile.mId, tokenMdt.Token__c); 
                        // }
                        */
                    }


                }
            }

            /*if(mFileList.size()>0)
            {
                CTRHerokuController.TokenResultWrapper mTokenResult = CTRHerokuController.getToken();

                System.debug('--mTokenResult--'+mTokenResult);

                if(!mTokenResult.mResult.contains('Error'))
                {
                    List<blob> mBlobList = new List<blob>();

                    for(FileWrapper mFile: mFileList)
                    {
                        // system.enqueuejob(new CTRSharepointUploadQueueable(mFolderName, mPath, mFile.mTitle, mFile.mFileBody, mTokenResult.mToken));
                        sendFileToHeroku(mFolderName, mPath, mFile.mTitle, mFile.mFileBody, mTokenResult.mToken); 
                        // sendFileToHeroku(mFolderName, mPath, mFile.mTitle, mFile.mFileBody, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImEzWjFtMDAwMDAwUlVZZUVBTyIsInVzZXJuYW1lIjoibW9rZS5rQHJvdW5kdHdvc29sdXRpb25zLmNvbSIsImFjY291bnRzIjpbeyJJZCI6IjAwMTFtMDAwMDBtR1A3OUFBRyJ9XSwiaWF0IjoxNzA1OTE4ODg1LCJleHAiOjE3MDU5MjI0ODV9.zr5pHDyXn8CYxqQqiaWTWzPkJhIVc-3U8youa68RtTQ'); //mTokenResult.mToken); 
                    }
                }
            }*/

        }
        catch(exception e)
        {
            System.debug('Error From: CTRSharPointFileController.UploadFileToSharePoint line ' + e.getLineNumber() + ' || Message: ' + e.getMessage());
        }

    }

    @future(callout = true)
    public static void deleteFileSalesforce(String mFileId, String mToken)
    {
        CTRIntegraionList__mdt tokenMdt = CTRIntegraionList__mdt.getInstance('CTRUploadFileSharepoint');

        String mURL = 'https://ctr-dev-dev-266ee3f00154.herokuapp.com/sharepoint/deletefilesalesforce';
        System.debug('==mFileId=='+mFileId);
        
        String mBodyBase = '{"Id" : "'+mFileId+'"}';
        Http h = new Http();
        System.debug('mURL: ' + mURL);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(mURL);
        request.setHeader('Authorization', 'Bearer '+ +mToken);
        request.setHeader('Accept', '*/*');
        request.setMethod('POST');
        request.setCompressed(true); 
        request.setTimeout(120000); 
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setBody(mBodyBase);
        
        if(!Test.isRunningTest()){
            HttpResponse response = h.send(request);
            System.debug('The response body : ' + response.getBody());
    
            if (response.getStatusCode() == 200) 
            {
                Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                List<String> data = new List<String>();
                for (Object instance : (List<Object>)deserialized.get('responseData'))
                {
                    System.debug(instance);
                    data.add((String)instance);
                }
    
                // //List<String> base64File = (List<String>)parsedResponse.get('responseData');
                // //String messagetype = (String)parsedResponse.get('responseData');
                // //System.debug('Response: ' + base64File);
    
                // System.debug('Response: ' + data);
                // System.debug('base64File::'+data[0]);
    
                // ContentVersion cv = new ContentVersion(); 
                // cv.ContentLocation = 'S';  
                // Blob fileABlob = EncodingUtil.base64Decode(data[0]);   
                // //File is generated but there is nothing in it  
                // cv.VersionData = fileABlob;
                // cv.Title = mFileName;
                // cv.PathOnClient = mFileName; 
                // insert cv; 
                
            } 
            else 
            {
                System.debug('HTTP error: ' + response.getStatusCode() + ' || body: ' + response.getBody());
            }
        }
        
    }
    
    // @future//newadd23Jan24
    @future(callout = true)
    public static void sendFileToHeroku(String mFolderName, String mPath, String mEndPoint, String mFileTitle , Blob mFileData, String mToken)
    {
        System.debug(mFolderName);
        System.debug(mPath);
        System.debug(mEndPoint);
        System.debug(mFileTitle);
        System.debug(mFileData);
        System.debug(mToken);
        string form64 = '';

        form64 += CTRHttpFormBuilder.WriteBoundary();
        form64 += CTRHttpFormBuilder.WriteBodyParameter('namefolder', mPath);
        // form64 += CTRHttpFormBuilder.WriteBodyParameter('namefolder', mFolderName+mPath);
        form64 += CTRHttpFormBuilder.WriteBoundary();

        System.debug('Name:'+mFileTitle);
        System.debug('mFileBody:'+mFileData);

        CTRHttpFormBuilder.WriteFileResult result = CTRHttpFormBuilder.WriteFile('files', mFileTitle, 'multipart/form-data; charset="UTF-8"; boundary="'+BOUNDARY+'"', mFileData);
        form64 += result.Content; 
        form64 += CTRHttpFormBuilder.WriteBoundary(result.EndingType);
        blob mBlob = EncodingUtil.base64Decode(form64);
        System.debug('blob:'+mBlob);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(mEndPoint);

        //request.setEndpoint('https://ctr-dev-dev-266ee3f00154.herokuapp.com/sharepoint/uploadfile');
        request.setHeader('Authorization', 'Bearer '+mToken);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'multipart/form-data; charset="UTF-8"; boundary="'+BOUNDARY+'"');

        request.setBodyAsBlob(mBlob);
        request.setTimeout(120000); 
        System.debug('http: '+request);

        HttpResponse response;
        if(!Test.isRunningTest()){
            response = http.send(request);

            // Parse the JSON response
            System.debug('The status code : ' + response.getStatusCode());
            System.debug('The response body : ' + response.getBody());

        }


        // return response;
    }

    public static void DownloadSharePoint(String mFolder, String mFileName)
    {
        //mFolder = (mFolder==null)?'Shared Documents/Account':mFolder;

        CTRHerokuController.TokenResultWrapper mTokenResult = CTRHerokuController.getToken();
        String mURL = 'https://ctr-dev-dev-266ee3f00154.herokuapp.com/sharepoint/downloadfile';
        
        String mBodyBase = '{"foldername" : "'+mFolder+'", "filename": "'+mFileName+'"}';
        Http h = new Http();
        System.debug('mURL: ' + mURL);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(mURL);
        request.setHeader('Authorization', 'Bearer '+ +mTokenResult.mToken);
        request.setHeader('Accept', '*/*');
        request.setMethod('POST');
        request.setCompressed(true); 
        request.setTimeout(120000); 
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setBody(mBodyBase);

        HttpResponse response;
        if(!Test.isRunningTest()){
            response = h.send(request); 
            System.debug('The response body : ' + response.getBody());
            

            if (response.getStatusCode() == 200) 
            {
                Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                List<String> data = new List<String>();
                for (Object instance : (List<Object>)deserialized.get('responseData'))
                {
                    System.debug(instance);
                    data.add((String)instance);
                }

                //List<String> base64File = (List<String>)parsedResponse.get('responseData');
                //String messagetype = (String)parsedResponse.get('responseData');
                //System.debug('Response: ' + base64File);

                System.debug('Response: ' + data);
                System.debug('base64File::'+data[0]);

                ContentVersion cv = new ContentVersion(); 
                cv.ContentLocation = 'S';  
                Blob fileABlob = EncodingUtil.base64Decode(data[0]);   
                //File is generated but there is nothing in it  
                cv.VersionData = fileABlob;
                cv.Title = mFileName;
                cv.PathOnClient = mFileName; 
                insert cv; 
                
            } 
            else 
            {
                System.debug('HTTP error: ' + response.getStatusCode() + ' || body: ' + response.getBody());
            }
        }
    }

    public static void DownloadMultipleSharePoint(String mFolder, List<String> mFileName)
    {
        //mFolder = (mFolder==null)?'Shared Documents/Account':mFolder;

        CTRHerokuController.TokenResultWrapper mTokenResult = CTRHerokuController.getToken();
        String mURL = 'https://ctr-dev-dev-266ee3f00154.herokuapp.com/sharepoint/downloadfiles';
        String mBodyBase = '';

        for(integer i =0; i<= mFileName.size(); i++)
        {
            mBodyBase += '{"foldername" : "'+mFolder+'", "filename": "'+mFileName+'"}';
            if(i != mFileName.size()-1)
            {mBodyBase += ',';}
        }
        Http h = new Http();
        System.debug('mURL: ' + mURL);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(mURL);
        request.setHeader('Authorization', 'Bearer '+ +mTokenResult.mToken);
        request.setHeader('Accept', '*/*');
        request.setMethod('POST');
        request.setCompressed(true); 
        request.setTimeout(120000); 
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setBody(mBodyBase);

        if(!Test.isRunningTest()){
            HttpResponse response = h.send(request);
            System.debug('The response body : ' + response.getBody());
            
    
            if (response.getStatusCode() == 200) 
            {
                /*Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                List<String> data = new List<String>();
                for (Object instance : (List<Object>)deserialized.get('responseData'))
                {
                    System.debug(instance);
                    data.add((String)instance);
                }
    
                //List<String> base64File = (List<String>)parsedResponse.get('responseData');
                //String messagetype = (String)parsedResponse.get('responseData');
                //System.debug('Response: ' + base64File);
    
                System.debug('Response: ' + data);
                System.debug('base64File::'+data[0]);
    
                ContentVersion cv = new ContentVersion(); 
                cv.ContentLocation = 'S';  
                Blob fileABlob = EncodingUtil.base64Decode(data[0]);   
                //File is generated but there is nothing in it  
                cv.VersionData = fileABlob;
                cv.Title = mFileName;
                cv.PathOnClient = mFileName; 
                insert cv; */
                
            } 
            else 
            {
                System.debug('HTTP error: ' + response.getStatusCode() + ' || body: ' + response.getBody());
            }
        }
    }

    public static void deleteSalesforceAttachment(List<Attachment> mAttachmentList)
    {
        try
        {
            delete mAttachmentList;
        }
        catch (exception e)
        {
            System.debug('Error From: CTRSharPointFileController.deleteSalesforceAttachment line ' + e.getLineNumber() + ' || Message: ' + e.getMessage());
        }
    }

    //Metadata
    public static void sharepointMetadata(Id recordId,Set<Id> mIdList, String main, String btnname) {

        //Query Custom Meta Data
        List<CTRSharePointFolder__mdt> sharepointMdt = [SELECT Id, Main__c , Button_Name__c, Path__c FROM CTRSharePointFolder__mdt];
        Map<String, String> sharepointMdtMap = new Map<String, String>();
        for(CTRSharePointFolder__mdt sharepoint : sharepointMdt){
            sharepointMdtMap.put(sharepoint.Button_Name__c, sharepoint.Path__c);
            // System.debug('sharepointMdtMap: '+sharepointMdtMap);
        }
        System.debug('sharepointMdtMap: '+sharepointMdtMap);

        // //Check Record Type
        String mPath ='';
        if (String.isNotBlank(recordId)) {
            CTRRequestFormItem__c reqFormItem = [SELECT RecordType.Name,Customer__r.SFCode__c  FROM CTRRequestFormItem__c WHERE Id = :recordId];
            // if (reqFormItem.RecordType.Name.contains('New')) { //Account/...
            //     mPath = '/Account/'+reqFormItem.Customer__r.SFCode__c+'/'+sharepointMdtMap.get('Other Registration Files');
            //     System.debug('mPath: '+mPath);
            // }else{ //Account/Other
            //     mPath = '/Account/'+reqFormItem.Customer__r.SFCode__c+'/'+sharepointMdtMap.get('Other Registration Files');
            //     System.debug('mPath: '+mPath);
            // }
            mPath = '/Account/'+reqFormItem.Customer__r.SFCode__c+sharepointMdtMap.get('Other Registration Files');
            System.debug('mPath: '+mPath);
        }

        CTRSharPointFileController.UploadFileToSharePoint(mPath,mIdList);
    }
}