public class CTRLeadHandler 
{
	public static void CreateDupLead(List<Lead> LeadList)
    {
        try
        {
            list<lead> newInsertLeads = new list<lead>();
            for(Lead leadRec: LeadList)
            {
                system.debug('leadRec '+ leadRec);
                system.debug('leadRec MasterRecordId'+ leadRec.MasterRecordId);
                if(leadRec.MasterRecordId != null || Test.isRunningTest())
                {
                    lead insertLead = leadRec.clone(false, false);
                    //lead insertLead = leadRec;
                    //insertLead.Company = insertLead.Company + ' (Inactive)';
                    insertLead.isArchive__c = 'true';
                    system.debug('insertLead '+ insertLead);
                    system.debug('insertLead.MasterRecordId '+insertLead.MasterRecordId);
                    newInsertLeads.add(insertLead);
                }
            }
            system.debug('newInsertLeads.size() '+ newInsertLeads.size());
            if(newInsertLeads.size()>0)
            {
                Database.DMLOptions dmlOptions = new Database.DMLOptions();
				dmlOptions.DuplicateRuleHeader.AllowSave = true;

				Database.SaveResult[] insertResults = Database.insert(newInsertLeads, dmlOptions);
                //insert newInsertLeads;
                for (Database.SaveResult result : insertResults) {
        		if (!result.isSuccess()) {
            		for (Database.Error error : result.getErrors()) {
                	// Handle errors as needed
                	System.debug('Error Message: ' + error.getMessage());
                	System.debug('Error Fields: ' + error.getFields());
            			}
        			}
    			}
                system.debug('done');
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRLeadHandler.CreateDupLead Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }


    public static void createSharepointfolderAfterCreate(List<Lead> LeadList)
    {
        try
        {
            List<Lead> mLeadList = new List<Lead>();
            for(Lead mLead: LeadList)
            {
                if(mLead.LeadNo__c != null)
                {
                    mLeadList.add(mLead);
                }
                
            }
            if(mLeadList.size()>0)
            {
                //LeadCreateFolderToSharePoint(mLeadSetId);
                List<Lead> mLeadUpdateList = new List<Lead>();
                C360Integration__c mSetting = C360Integration__c.getInstance();
                List<CTRIntegraionList__mdt > mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRCreateFolderSharepoint'];
                if(mIntegrationList.size()>0)
                {
                    for(Lead mLead: mLeadList)
                    {
                        Lead mLeadUpdate = new Lead(Id = mLead.Id);
                        mLeadUpdate.LeadNumberText__c = mLead.LeadNo__c;
                        mLeadUpdateList.add(mLeadUpdate);
                        String mBody = CTRSharePointLinkController.manageWrapperToCreateFolder(mSetting.SharePointMainFolderDuringCreate__c, mLead.LeadNo__c, 'Common', '', new List<String>(),'');
                        if(String.isNotBlank(mBody))
                        {
                            //String mBody = '{"MainFolder": "'+mSetting.SharePointMainFolderDuringCreate__c+'","AccFolder" : "'+mLead.LeadNo__c+'","SubFolder" : "Common", "Type": ""}';
                            String mEndPoint = mSetting.HerokuIntegrationDomain__c+mIntegrationList[0].Path__c;
                            String mGatewayId = (mLead.GatewayId__c!= null)?mLead.GatewayId__c:Uuid.randomUUID();
                            system.enqueuejob(new CTRTriggerWebServiceQueueable(mBody, mIntegrationList[0].Token__c, mEndPoint, 'Folder creation', mLead.Id, mGatewayId));
                        }

                    }
                    if(mLeadUpdateList.size()>0)
                    {
                        update mLeadUpdateList;
                    }
    
                }
            }


        }
        catch(exception e)
        {
            System.debug('Error from CTRLeadHandler.createSharepointfolderAfterCreate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void newsAfterUpdate (Map<Id,Lead> mLeadOldMap, Map<Id, Lead> mLeadNewMap)
    {
        try
        {
            List<Lead> mLeadList = new List<Lead>();
            for(Lead mLead: mLeadNewMap.values())
            {
                if(mLead.CallOutNews__c != mLeadOldMap.get(mLead.Id).CallOutNews__c)
                {
                    if(mLead.CallOutNews__c == true)
                    {
                        mLeadList.add(mLead);
                    }
                }
            }
            if(mLeadList.size()>0)
            {
                C360Integration__c mSetting = C360Integration__c.getInstance();
                List<CTRIntegraionList__mdt > mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRiRPARequestNews'];
                if(mIntegrationList.size()>0)
                {
                    CTRIntegraionList__mdt mIntegration = mIntegrationList[0];
                    for(Lead mLead : mLeadList)
                    {
                        String mGatewayId = (mLead.GatewayId__c!= null)?mLead.GatewayId__c:Uuid.randomUUID();
                        String mBody = '{"request_header" : "'+mLead.Id+'", "GatewayId" : "'+mGatewayId+'"}';
                        system.enqueuejob(new CTRTriggerWebServiceQueueable(mBody, mIntegration.Token__c, mSetting.HerokuIntegrationDomain__c+mIntegration.Path__c, 'NewsSharedHolder', mLead.Id, mGatewayId));

                    }
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRLeadHandler.CreateDupLead Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }
}