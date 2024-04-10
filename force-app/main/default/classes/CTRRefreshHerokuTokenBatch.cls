public class CTRRefreshHerokuTokenBatch implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    Private Static FINAL String mName = 'CTRGetHerokuToken'; 
    public Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String mType = 'Salesforce'; 
        String query = 'SELECT Id, MasterLabel, DeveloperName, Endpoint__c, Path__c, Type__c';                                                
        query += ' FROM CTRIntegraionList__mdt WHERE Type__c =: mType' ;
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> sObj) 
    {
        CTRHerokuController.TokenResultWrapper mTokenResult = CTRHerokuController.getToken();
        if(!mTokenResult.mResult.contains('error'))
        {
            List<CTRIntegraionList__mdt > mIntegrationList = (List<CTRIntegraionList__mdt>)sObj;

            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            for(CTRIntegraionList__mdt mIntegration: mIntegrationList)
			{
                if(mIntegration.Type__c == 'Salesforce')
                {
                    Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                    metadataRec.fullName = 'CTRIntegraionList__mdt.'+mIntegration.DeveloperName;
                    metadataRec.label = mIntegration.MasterLabel;
                    Metadata.CustomMetadataValue customFieldtoUpdate = new Metadata.CustomMetadataValue();
                    customFieldtoUpdate.field = 'Token__c';
                    customFieldtoUpdate.value = mTokenResult.mToken;
                    metadataRec.values.add(customFieldtoUpdate);
                    mdContainer.addMetadata(metadataRec);
                }

            }
            system.debug('mdContainer**'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            if(!Test.isRunningTest())
            {
                Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                system.debug('jobId***'+jobId);
            }
            

        }
    }
    
    public void finish(Database.BatchableContext BC) {
    }
}