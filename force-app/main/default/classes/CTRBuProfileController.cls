public class CTRBuProfileController 
{
    public static CTRBuProfile__mdt checkBusinessUnitFromProfile(Id mUserId, Id mRecordId)
    {
        try 
        {   
            List<CTRBuProfile__mdt> mBuProfileList = new List<CTRBuProfile__mdt> ();
            User mUser = [SELECT Id, ProfileId, Profile.Name FROM User WHERE Id = :mUserId LIMIT 1];
            if(mRecordId != null)
            {
                String sObjName = mRecordId.getSObjectType().getDescribe().getName();
                if(sObjName == 'CTRRequestFormItem__c')
                {
                    List<CTRRequestFormItem__c> mItem = [SELECT Id, BusinessUnit__c FROM CTRRequestFormItem__c WHERE Id =:mRecordId];
    
                    mBuProfileList = [SELECT Id, MasterLabel, DeveloperName, BusinessUnit__c ,ReassignTask_Section_Name__c, VPSectionName__c, Language__c,Edit_Button_Name__c, Section_Credit_Condition__c
                    FROM CTRBuProfile__mdt WHERE MasterLabel = :mItem[0].BusinessUnit__c
                    ORDER BY SystemModstamp DESC LIMIT 1];
    
                }
                else
                {
                    mBuProfileList = [SELECT Id, MasterLabel, DeveloperName, BusinessUnit__c ,ReassignTask_Section_Name__c, VPSectionName__c, Language__c,Edit_Button_Name__c, Section_Credit_Condition__c
                    FROM CTRBuProfile__mdt WHERE MasterLabel = :mUser.Profile.Name ORDER BY SystemModstamp DESC LIMIT 1];
                }
            }
            else
                {
                    mBuProfileList = [SELECT Id, MasterLabel, DeveloperName, BusinessUnit__c ,ReassignTask_Section_Name__c, VPSectionName__c, Language__c,Edit_Button_Name__c, Section_Credit_Condition__c
                    FROM CTRBuProfile__mdt WHERE MasterLabel = :mUser.Profile.Name ORDER BY SystemModstamp DESC LIMIT 1];
                }


            CTRBuProfile__mdt mBU = (mBuProfileList.size()>0)?mBuProfileList[0]: coverScenarioBuProfile();

            /*if(mBU != null)
            {
                if(mBU.BusinessUnit__c == 'All' || Test.isRunningTest())
                {
                    String mSalesOrg = '';
                    Boolean mFoundSalesOrgBU = false;
                    if(mRecordId != null)
                    {
                        String sObjName = mRecordId.getSObjectType().getDescribe().getName();
                        if(sObjName == 'CTRRequestFormItem__c')
                        {
                            String mSQL = 'SELECT Id, SalesOrganization__c, PurchasingOrganization__c, RecordTypeId FROM '+sObjName+' WHERE ID = :mRecordId LIMIT 1';
                            List<sObject> mObjList = Database.query(mSQL);
                            System.debug('mObjList:'+mObjList[0].get('SalesOrganization__c'));

                            mSalesOrg = (mObjList[0].get('SalesOrganization__c') != null)?(String)mObjList[0].get('SalesOrganization__c'):'';
                            String mRecordTypeId = (mObjList[0].get('RecordTypeId') != null)?(String)mObjList[0].get('RecordTypeId'):'';
                            String mRecordTypeName = '';
                            if(mRecordTypeId != '')
                            {
                                mRecordTypeName = [SELECT Id,Name FROM RecordType WHERE ID = :mRecordTypeId AND sObjectType = :sObjName LIMIT 1].Name;
                            }
                            
                            if(sObjName != 'Lead' && mRecordTypeName.contains('Supplier'))
                            {
                                String mPurchasingOrg = (String)mObjList[0].get('PurchasingOrganization__c');
                                mSalesOrg = mapPurchasingOrgWithCompanyCode().get(mPurchasingOrg);
                            }

                        
                            Map<String, String> mSalesOrgBUMap = mapSalesOrgWithBU();
                            for(String mKey: mSalesOrgBUMap.keySet())
                            {
                                if(mSalesOrg.contains(mKey))
                                {
                                    mBU.BusinessUnit__c = mSalesOrgBUMap.get(mKey);
                                    mFoundSalesOrgBU = true;
                                }
                            }
                        }
                        
                    }
                    if(!mFoundSalesOrgBU || String.isEmpty(mSalesOrg) || String.isEmpty((String)mRecordId)) 
                    {
                        mBU.Label = 'Default BU';
                        mBU.BusinessUnit__c = 'TOP';
                    }

                }
            }*/
            System.debug('mBU.BusinessUnit__c: '+mBU);
            return mBU;
        } 
        catch (Exception e) 
        {
            String mErrorMessage = 'Error: CTRBuProfileController.checkBusinessUnitFromProfile Line '+e.getLineNumber()+' || Message: '+e.getmessage();
            System.debug(mErrorMessage);
            return null;
        }
    }
    
    public static PISUsers__c getReportToPIS(Id mUserId)
    {
        try 
        {   
            PISUsers__c currUser = [select ReportToID__c, ReportToPOS__c from PISUsers__c where User__c  =: mUserId limit 1];
            PISUsers__c reportTo = [select Name,EMAIL__c,User__c from PISUsers__c where EMPLOYEEID__c  =: currUser.ReportToID__c AND POSID__c  =: currUser.ReportToPOS__c limit 1];
			system.debug('reportTo----'+reportTo);            
            return reportTo;
        } 
        catch (Exception e) 
        {
            String mErrorMessage = 'Error: CTRBuProfileController.checkBusinessUnitFromProfile Line '+e.getLineNumber()+' || Message: '+e.getmessage();
            System.debug(mErrorMessage);
            return null;
        }
    }

    // Map Sales Organization With Interested Product
    public static Map<String, String> mapPurchasingOrgWithCompanyCode() 
    {
        return new Map<String, String>
        {
            '1100' => '1100',
            'A000' => '2000',
            'H100' => '9100',
            'I100' => '9200',
            'S100' => '9300',
            'N100' => '9400'
        };
    }

    // Map Sales Organization With Interested Product
    public static Map<String, String> mapSalesOrgWithBU() 
    {
        return new Map<String, String>
        {
            '1100' => 'TOP',
            '1300' => 'TOP',
            '1400' => 'TOP',
            '1700' => 'LABIX',
            '2000' => 'TX',
            '9100' => 'TX',
            '9200' => 'TX',
            '9300' => 'TX',
            '9400' => 'TX'
        };
    }
    
    public static CTRBuProfile__mdt coverScenarioBuProfile()
    {
        CTRBuProfile__mdt mBuProfile = new CTRBuProfile__mdt();
        mBuProfile.Id = null;
        mBuProfile.MasterLabel = 'No Profile Match';
        mBuProfile.DeveloperName = 'No_Profile_Match';
        mBuProfile.BusinessUnit__c ='TOP';
        mBuProfile.VPSectionName__c = '';
        mBuProfile.Language__c = '';
        mBuProfile.Edit_Button_Name__c = '';
        mBuProfile.Section_Credit_Condition__c = '';
        return mBuProfile;
    }
    
    
}