@IsTest
public class CTRRequestEditLogFieldControllerTest {
    
    @TestSetup
    static void makeData(){

        List<Master_Map__c> Master = new List<Master_Map__c>();
        Master_Map__c m1 = new Master_Map__c(Code__c='ZTH0245', Type__c='Transportation Zone');
        Master.add(m1);
        Master_Map__c m2 = new Master_Map__c(Code__c='TH', Type__c='Country');
        Master.add(m2);
        Master_Map__c m3 = new Master_Map__c(Code__c='TH-Bangkok', Name ='TH-Bangkok',  Type__c='Province');
        Master.add(m3);
        Master_Map__c m4 = new Master_Map__c(Code__c='mg1', Type__c='Material Group');
        Master.add(m4);
        Master_Map__c m5 = new Master_Map__c(Code__c='ZA00001', Type__c ='Payment Term');   
        Master.add(m5);
        
        insert Master;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'", "Source":"source"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'", "Source":"source"},{"Label":"CityLocal","Api":"CompanyNameLocal__c","Value":"'+ Master[2].Id +'", "Source":"source"}]',
            InternalOriginalField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'", "Source":"source"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'", "Source":"source"},{"Label":"CityLocal","Api":"CompanyNameLocal__c","Value":"'+ Master[2].Id +'", "Source":"source"}]'
        );
        insert reqHeader;

        Account newAcc = new Account();
        newAcc.Name = 'Test Acc';
        newAcc.AccountNumber = '0001';
        newAcc.AccountNumber__c = '0001';
        newAcc.CompanyNameENF__c = 'Test Acc';
        insert newAcc;

        CTRShareholder__c shareHolder = new CTRShareholder__c();
        shareHolder.Name = 'Test';
        shareHolder.of_Shareholder__c = 10;
        shareHolder.Customer__c = newAcc.Id;
        shareHolder.CTRRequestFormHeader__c = reqHeader.Id;
        insert shareHolder;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            SummarizeReportSubject__c = 'subject',
            SummarizeReportMessage__c = 'message',
            SummarizeReportEmailTo__c = 'testuser@test.com',
            SummarizeReportEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id
        );
        insert reqItem;

        CTRShippingCountry__c shipping = new CTRShippingCountry__c();
        shipping.CTRRequestFormItem__c = reqItem.id;
        shipping.ShippingCountry__c = 'TH';
        shipping.LocationType__c = 'Local';
        insert shipping;
        
    }

    @isTest
    static void testOnload(){
        CTRRequestFormItem__c reqFromItem = [SELECT ID,OriginalDestinationCountry__c FROM CTRRequestFormItem__c LIMIT 1];
        List<CTRFieldEditLog__mdt> mCounterPartyFieldLogList = [SELECT Id, Source__c, FieldList__c, Object__c FROM CTRFieldEditLog__mdt WHERE Source__c = 'Counter party' AND Object__c = 'CTRRequestFormHeader__c'];
        Map<String, String> mFieldListMap = new Map<String, String>();
        for(CTRFieldEditLog__mdt mEditLog: mCounterPartyFieldLogList)
        {
            mFieldListMap.put(mEditLog.Object__c, mEditLog.FieldList__c);
        }
        Set<Id> mItemSetId = new Set<Id>();
        mItemSetId.add(reqFromItem.Id);

        List<SObject> mDestinationCountryList = new List<SObject>();
        mDestinationCountryList.add(reqFromItem);
        String mDestinationCountryObjName = 'CTRRequestFormItem__c';

        List<String> mCountryFieldList = CTRRequestEditLogFieldController.getFieldListFromJson(mFieldListMap.get(mDestinationCountryObjName), mDestinationCountryObjName);
        Map<String, String> mCountryJsonMap = new Map<String, String>();
        mCountryJsonMap = CTRRequestEditLogFieldController.manageRelatedObjectToJson(
            mDestinationCountryList,
            mCountryFieldList,
            mItemSetId,
            mDestinationCountryObjName
        );

        if(mCountryJsonMap != null){
            reqFromItem.OriginalDestinationCountry__c = mCountryJsonMap.get(reqFromItem.Id);
            update reqFromItem;
        }

        Map<Id,CTRRequestFormHeader__c> mHeaderNewMap = new Map<Id,CTRRequestFormHeader__c>([SELECT ID,InternalEditField__c FROM CTRRequestFormHeader__c]);

        Map<String, String> mChangeDataJsonMap = new Map<String, String>();
        for(CTRRequestFormHeader__c mNewHeader: mHeaderNewMap.values())
        {
            if(mNewHeader.InternalEditField__c != null)
            {
                mChangeDataJsonMap.put(mNewHeader.Id, mNewHeader.InternalEditField__c);
            }
        }

        Test.startTest();
        CTRRequestEditLogFieldController.editLevelWrapper result = new CTRRequestEditLogFieldController.editLevelWrapper();
        result = CTRRequestEditLogFieldController.onloadv3(reqFromItem.Id,'Edit');
        result = CTRRequestEditLogFieldController.onloadv3(reqFromItem.Id,'Shareholder');
        result = CTRRequestEditLogFieldController.onloadv3(reqFromItem.Id,'DestinationCountry');

        Map<String,String> result2 = CTRRequestEditLogFieldController.modifyChangeDataJsonIdToLabel(mChangeDataJsonMap,'CTRRequestFormHeader__c');
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testManageRelatedForTable(){

        // List<SObject> shareHolder = [SELECT ID FROM CTRShareholder__c];
        // List<SObject> shippingHolder = [SELECT ID FROM CTRShippingCountry__c];
        Map<String,CTRShareholder__c> shareHolder = new Map<String,CTRShareholder__c>([SELECT ID FROM CTRShareholder__c]);
        Map<String,CTRShippingCountry__c> shippingHolder = new Map<String,CTRShippingCountry__c>([SELECT ID FROM CTRShippingCountry__c]);

        Map<String, CTRRequestEditLogFieldController.RelatedTableChangeFieldWrapper> result1 = new Map<String, CTRRequestEditLogFieldController.RelatedTableChangeFieldWrapper>();
        Map<String, CTRRequestEditLogFieldController.RelatedTableChangeFieldWrapper> result2 = new Map<String, CTRRequestEditLogFieldController.RelatedTableChangeFieldWrapper>();
        
        List<Map<String,Object>> mShareObjList = new List<Map<String,Object>>();
        mShareObjList.add(shareHolder);

        List<Map<String,Object>> mShippingObjList = new List<Map<String,Object>>();
        mShippingObjList.add(shareHolder);
        
        Test.startTest();
        result1 = CTRRequestEditLogFieldController.manageRelatedForTable(mShareObjList,'CTRShareholder__c');
        result2 = CTRRequestEditLogFieldController.manageRelatedForTable(mShippingObjList,'CTRShippingCountry__c');
        Test.stopTest();
    }

    @isTest
    static void testGetFieldListFromJson(){
        String mDestinationCountryObjName = 'CTRRequestFormItem__c';
        List<CTRFieldEditLog__mdt> mCounterPartyFieldLogList = [SELECT Id, Source__c, FieldList__c, Object__c FROM CTRFieldEditLog__mdt WHERE Source__c = 'Counter party' AND Object__c = 'CTRRequestFormHeader__c'];
        Map<String, String> mFieldListMap = new Map<String, String>();
        for(CTRFieldEditLog__mdt mEditLog: mCounterPartyFieldLogList)
        {
            mFieldListMap.put(mEditLog.Object__c, mEditLog.FieldList__c);
        }

        List<Map<String, String>> mapList = new List<Map<String,String>>();
        mapList.add(mFieldListMap);

        List<String> results = CTRRequestEditLogFieldController.getFieldListFromJson(JSON.serialize(mapList),mDestinationCountryObjName);
    }

    @isTest
    static void testSavePointValueRecordToJson(){
        CTRRequestFormItem__c reqFromItem = [SELECT ID,OriginalDestinationCountry__c,CTRRequestFormHeader__c FROM CTRRequestFormItem__c LIMIT 1];
        List<CTRFieldEditLog__mdt> mCounterPartyFieldLogList = [SELECT Id, Source__c, FieldList__c, Object__c FROM CTRFieldEditLog__mdt WHERE Source__c = 'Counter party' AND Object__c = 'CTRRequestFormHeader__c'];
        Map<String, String> mFieldListMap = new Map<String, String>();
        for(CTRFieldEditLog__mdt mEditLog: mCounterPartyFieldLogList)
        {
            mFieldListMap.put(mEditLog.Object__c, mEditLog.FieldList__c);
        }
        Set<Id> mHeaderSetId = new Set<Id>();
        mHeaderSetId.add(reqFromItem.CTRRequestFormHeader__c);

        List<SObject> mDestinationCountryList = new List<SObject>();
        mDestinationCountryList.add(reqFromItem);

        String mHeaderObjectName = 'CTRRequestFormHeader__c';
        List<String> mHeaderFieldNameList = CTRRequestEditLogFieldController.getFieldListFromJson(mFieldListMap.get(mHeaderObjectName), mHeaderObjectName);
        List<SObject> mHeaderFilteredList = new List<SObject>();
        String mHeadersoql = '';
        mHeadersoql+= ' SELECT ' + String.join(mHeaderFieldNameList, ',');
        mHeadersoql+= ' FROM ' + mHeaderObjectName;
        mHeadersoql+= ' WHERE Id IN :mHeaderSetId ';
        mHeaderFilteredList = Database.query(mHeadersoql);

        Test.startTest();
        Map<Id, String> result = CTRRequestEditLogFieldController.SavePointValueRecordToJson(mHeaderFilteredList, mHeaderFieldNameList, mHeaderObjectName);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }
}