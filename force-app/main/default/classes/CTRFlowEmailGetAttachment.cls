public class CTRFlowEmailGetAttachment {
    
    @InvocableMethod(label='Get Attachment to Send Email')
    public static List<ResultsGetAttachment> getAttachmentToSendEmail(List<FlowInputGetAttachment> mData) 
    {   
        List<String> attachmentNameList = mData[0].mFileName;
        String fileConditionStr = '';
        Boolean isFirst = true;
        for(String fileName : attachmentNameList) {
            if(!isFirst) {
                fileConditionStr += ' OR ';
            }
            fileConditionStr += ' Name Like \''+fileName+'%\' '; // to ignore file extension
            isFirst = false;
        }

        String customerId = mData[0].mCustomerId;
        String getFileAttachmentSQL = 'SELECT Id, LastModifiedDate, Name, ParentId FROM Attachment WHERE ParentId = :customerId AND ('+fileConditionStr+') ORDER BY LastModifiedDate DESC';
        List<Attachment> mAttachment = Database.query(getFileAttachmentSQL);
        Map<String,Id> mapAttachmentIds = new Map<String,Id>();
        for(Attachment file : mAttachment) {
            String fileName = file.name.contains('.') ? file.name.substringBefore('.') : file.name;
            if(!mapAttachmentIds.containsKey(fileName)) { // file is not duplicated
                mapAttachmentIds.put(fileName,file.Id);
            }
        }
        ResultsGetAttachment resultAttachment = new ResultsGetAttachment();
        resultAttachment.attachmentIds = mapAttachmentIds.values();

        List<ResultsGetAttachment> results = new List<ResultsGetAttachment>();
        results.add(resultAttachment);
        return results;
    }

    public class FlowInputGetAttachment
    {
        @InvocableVariable
        public String mCustomerId;
        
        @InvocableVariable
        public List<String> mFileName;
    }

    public class ResultsGetAttachment {
        @InvocableVariable(label='AttachmentId List Output' required=true)
        public List<String> attachmentIds;
      }
}