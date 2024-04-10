public with sharing class CTRSharepointUploadQueueable implements Queueable{
    
    String mFolder;
    String mPath;
    String mTitle;
    Blob mBlob;
    String mToken;

    public CTRSharepointUploadQueueable(String inputFolder, String inputPath, string inputTitle, Blob mInputBlob ,String accessToken)
    {
        this.mFolder = inputFolder;
        this.mPath = inputPath;
        this.mTitle = inputTitle;
        this.mBlob = mInputBlob;
        this.mToken = accessToken;
        System.debug('token++'+mToken);
    }
    
    public void execute(QueueableContext context) {
        C360Integration__c mSetting = C360Integration__c.getInstance();
        CTRIntegraionList__mdt tokenMdt = CTRIntegraionList__mdt.getInstance('CTRUploadFileSharepoint');
        CTRSharPointFileController.sendFileToHeroku(mFolder, mPath,mSetting.HerokuIntegrationDomain__c+tokenMdt.Path__c, mTitle, mBlob, mToken); 
    }
}