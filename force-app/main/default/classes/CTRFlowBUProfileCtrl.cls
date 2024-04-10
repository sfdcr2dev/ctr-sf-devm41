public class CTRFlowBUProfileCtrl {
    @InvocableMethod(label='CheckBusinessUnit' )
    public static List<String> CheckBusinessUnit(List<FlowInputs> mData) 
    {   

        List<String> mBussinessUnitList = new List<String>();
        String mBussinessUnit = 'TOP';
        Id mUserId = mData[0].mUserId;
        system.debug('mBussinessUnit'+mUserId);

        String mSalesOrg = mData[0].mSalesOrg;
        System.debug('mSalesOrg:'+mSalesOrg);
        User mUser = [SELECT Id, ProfileId, Profile.Name FROM User WHERE Id = :mUserId LIMIT 1];
        
        List<CTRBuProfile__mdt> mBuProfileList = [SELECT Id, MasterLabel, DeveloperName, BusinessUnit__c , VPSectionName__c, Language__c,Edit_Button_Name__c,	Section_Credit_Condition__c
                                                  FROM CTRBuProfile__mdt WHERE MasterLabel = :mUser.Profile.Name 
                                                  ORDER BY SystemModstamp DESC LIMIT 1];

        mBussinessUnit = (mBuProfileList.size()>0)?mBuProfileList[0].BusinessUnit__c: null;

        if(mBuProfileList.size()>0 != null)
        {
            if(mBussinessUnit == 'All' && String.isNotBlank(mSalesOrg)) 
            {

                String mPurchasingOrg = CTRBuProfileController.mapPurchasingOrgWithCompanyCode().get(mSalesOrg);
                mSalesOrg = (mPurchasingOrg != null)? mPurchasingOrg: mSalesOrg; 
                Map<String, String> mSalesOrgBUMap = CTRBuProfileController.mapSalesOrgWithBU();
                for(String mKey: mSalesOrgBUMap.keySet())
                {
                    if(mSalesOrg.contains(mKey))
                    { 
                        mBussinessUnit = mSalesOrgBUMap.get(mKey);
                    }
                }
            }
        }
        system.debug('mBussinessUnit');
        //mBussinessUnit = (mBussinessUnit != null)?mBussinessUnit:'TOP';
        mBussinessUnitList.add(mBussinessUnit);
        return mBussinessUnitList;
    }

    //input details that comes to apex from flow
    public class FlowInputs{
    
        @InvocableVariable
        public String mUserId;

        @InvocableVariable
        public String mSalesOrg;
        
    }
  }