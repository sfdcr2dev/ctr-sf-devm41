public class EMOC_ProdocConsolidateCallout {
    
    private static final PRODOCIntegration__c setting = PRODOCIntegration__c.getOrgDefaults();
    
    // request
	public class EMOCRequest {
        public List<ReviewRequestData> ListEmocReq {get;set;}
    }
    
    public class ReviewRequestData {
        public String EmocFileName {get;set;}
        public String EmocRawFile {get;set;}
        public String EmocDocType {get;set;}
        public String EmocCheckListType {get;set;}
        public String EmocUserName {get;set;}
        public String EmocNumber {get;set;}
        public String Emoc_SFDCID {get;set;}
        public String DocNumber {get;set;}
        public String Doc_SFDCID {get;set;}
    }
    
    // response
    public class EMOCResponse {
        public String StatusCode {get;set;}
        public String StatusMsg {get;set;}
        public List<ConsoResponseData> ListEmocReq {get;set;}
        public List<EMOCErrorFileData> ListErrorFile {get;set;}
    }
    
    public class ConsoResponseData {
        public String ConsoFileName {get;set;}
        public String ConsoRawFile {get;set;}
        public String ExcelCommentFileName {get;set;}
        public String ExcelCommentRawFile {get;set;}
        public String EmocCheckListType {get;set;}
        public String EmocDocType {get;set;}
        public String EmocNumber {get;set;}
        public String Emoc_SFDCID {get;set;}
    }
    
    public class EMOCErrorFileData {
        public String ErrorFileName {get;set;}
        public String ErrorStatus {get;set;}
    }
    
    public static Map<String, Object> generateData(Map<String, Object> dataMap) {
        Map<String, Object> result = new Map<String, Object>();
        Boolean reachHeapLimit = false;
        EMOCRequest requestData = new EMOCRequest();
        List<ReviewRequestData> listEmocReq = new List<ReviewRequestData>();
        for(Object obj : dataMap.values()) {
            if(Limits.getHeapSize() > setting.Heap_Limit__c) {
                reachHeapLimit = true;
                break;
            } else {
                Map<String, Object> rawData = (Map<String, Object>) obj;
                ReviewRequestData data = new ReviewRequestData();
                data.EmocFileName = rawData.get('Name') + '_' + rawData.get('ContentDocumentTitle'); // Fixed on 01/11/2022
                Blob versionDataBlob = (Blob) rawData.get('VersionData');
                String base64 = EncodingUtil.base64Encode(versionDataBlob);
                data.EmocRawFile = base64;
                data.EmocDocType = (String) rawData.get('E_MOC_Doc_Type__c');
                data.EmocCheckListType = (String) rawData.get('E_MOC_Checklist_type__c');
                data.EmocUserName = (String) rawData.get('OwnerUserName');
                Map<String, Object> eMocApp = (Map<String, Object>) rawData.get('E_MOC_Application__r');
                data.EmocNumber = (String) eMocApp.get('Name');
                data.Emoc_SFDCID = (String) rawData.get('E_MOC_Application__c');
                data.DocNumber = (String) rawData.get('ContentDocumentTitle');
                data.Doc_SFDCID = (String) rawData.get('ContentDocumentId');
                listEmocReq.add(data);
            }
        }
        
        Boolean isCalloutSuccess = false;
        String statusMsg = '';
        if(!reachHeapLimit) {
            requestData.ListEmocReq = listEmocReq;
            try {
                EMOCResponse responseData = calloutProdoc(requestData);
                isCalloutSuccess = true;
                statusMsg = responseData.StatusMsg;
                if(responseData.ListEmocReq != null) result.put('ListEmocReq', responseData.ListEmocReq);
                if(responseData.ListErrorFile != null) result.put('ListErrorFile', responseData.ListErrorFile);
            } catch(Exception ex) {
                statusMsg = ex.getStackTraceString() + '\n' + ex.getMessage();
            }
        } else {
            statusMsg = 'File size limit!!';
        }
        result.put('isCalloutSuccess', isCalloutSuccess);
        result.put('StatusMsg', statusMsg);
        return result;
    }
    
    public static EMOCResponse calloutProdoc(EMOCRequest requestData) {
        Map<String, Object> result = new Map<String, Object>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(setting.Endpoint__c);
        request.setMethod(setting.Method__c);
        request.setHeader('APIKey', setting.API_Key__c);
        request.setHeader('Content-Type', setting.Content_Type__c);
        request.setTimeout(Integer.valueOf(setting.Callout_Timeout__c));
        System.debug('json -----' + JSON.serialize(requestData));
        request.setBody(JSON.serialize(requestData));
        HttpResponse response = Http.send(request);
        System.debug('responseBody -----' + response.getBody());
        EMOCResponse responseData = (EMOCResponse) JSON.deserialize(response.getBody().trim().replace('\uFEFF', ''), EMOCResponse.class);
        return responseData;
    }
}