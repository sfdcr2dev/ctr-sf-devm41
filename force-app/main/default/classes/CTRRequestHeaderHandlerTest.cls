@isTest
public class CTRRequestHeaderHandlerTest {

    @isTest
    static void testOnChangeJsonForEditAfterUpdate(){
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rt.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Lebel":"TEST"}]'
        );
        insert reqHeader;

        Map<Id, CTRRequestFormHeader__c> mRequestHeaderOldMap = new Map<Id, CTRRequestFormHeader__c>();
        mRequestHeaderOldMap.put(reqHeader.Id,reqHeader);

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


        CTRRequestFormHeader__c reqHeaderNew = new CTRRequestFormHeader__c(
            Id = reqHeader.Id,
            Status__c = 'New',
            RecordTypeId = rt.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );
    
        Map<Id, CTRRequestFormHeader__c> mRequestHeaderNewMap = new Map<Id, CTRRequestFormHeader__c>();
        mRequestHeaderNewMap.put(reqHeader.Id,reqHeaderNew);


        /*Test.startTest();
        CTRRequestHeaderHandler.onChangeJsonForEditAfterUpdate(mRequestHeaderOldMap, mRequestHeaderNewMap);
        Test.stopTest();*/
    }
    
    @isTest
    static void testAddJsonEditInfoBeforeUpdate(){
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
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
            Name = 'Test',
            RecordTypeId = rt.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'", "Source":""},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'", "Source":""},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'", "Source":""}]'
        );
        insert reqHeader;
        Id mID = reqHeader.Id;
        List<String> mRequestHeaderFields = new List<String>(CTRRequestFormHeader__c.SObjectType.getDescribe().fields.getMap().keySet());            
        String soqlHeader = ''
            + ' SELECT ' + String.join(mRequestHeaderFields, ',')
            + ' FROM CTRRequestFormHeader__c'
            + ' WHERE Id = :mID LIMIT 1';
        CTRRequestFormHeader__c reqHeaderQ1 = Database.query(soqlHeader);
        

        Map<Id, CTRRequestFormHeader__c> mRequestHeaderOldMap = new Map<Id, CTRRequestFormHeader__c>();
        mRequestHeaderOldMap.put(reqHeader.Id,reqHeaderQ1);

        
        CTRRequestFormHeader__c reqHeaderNew2 = new CTRRequestFormHeader__c(
            Name = 'Edit Test2',
            Status__c = 'New',
            RecordTypeId = rt.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'", "Source":""},{"Label":"Transportation Zone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'", "Source":""}]'
        );
        
        // insert reqHeaderNew2;
        reqHeaderQ1.Name = 'Edit test';
        Map<Id, CTRRequestFormHeader__c> mRequestHeaderNewMap = new Map<Id, CTRRequestFormHeader__c>();
        mRequestHeaderNewMap.put(reqHeader.Id,reqHeaderQ1);
        
        Test.startTest();
         	reqHeaderQ1.Name = 'Edit test';
        	update reqHeaderQ1;
        //CTRRequestHeaderHandler.AddJsonEditInfoBeforeUpdate(mRequestHeaderOldMap, mRequestHeaderNewMap);
        Test.stopTest();
    }


    @isTest
    static void testAddJsonEditInfoBeforeUpdate2()
    {
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];

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
            Name = 'Test',
            RecordTypeId = rt.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'", "Source":""},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'", "Source":""},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'", "Source":""}]'
        );
        insert reqHeader;
        
        Map<Id, CTRRequestFormHeader__c> mRequestHeaderOldMap = new Map<Id, CTRRequestFormHeader__c>();
        mRequestHeaderOldMap.put(reqHeader.Id, reqHeader);

        CTRRequestFormHeader__c reqHeaderNew = new CTRRequestFormHeader__c(
            Id = reqHeader.Id,
            Name = 'Edit Test2',
            Status__c = 'New',
            RecordTypeId = rt.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube',  
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'", "Source":""},{"Label":"Transportation Zone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'", "Source":""}]'
        );

        Test.startTest();
        // Simulate changes in the header fields
        reqHeaderNew.Name = 'Edit test';
        Map<Id, CTRRequestFormHeader__c> mRequestHeaderNewMap = new Map<Id, CTRRequestFormHeader__c>();
        mRequestHeaderNewMap.put(reqHeader.Id, reqHeaderNew);

        // Call the method you want to test
        CTRRequestHeaderHandler.AddJsonEditInfoBeforeUpdate(mRequestHeaderOldMap, mRequestHeaderNewMap);
        Test.stopTest();

        // Add assertions if needed
    }


}