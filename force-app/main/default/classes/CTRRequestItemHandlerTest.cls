@isTest
public class CTRRequestItemHandlerTest {
    
    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '12345';
        insert acc;

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
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
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        // CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        // reqHeader.Name ='R2 Solutions. Co.,Ltd.';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Queue CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '2000';
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Crude';
        reqItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem;

        CTRRequestFormItem__c reqItem2 = new CTRRequestFormItem__c();
        //reqItem2.Name = 'Test 2';
        reqItem2.Customer__c = acc.Id;
        reqItem2.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem2.SAPStatus__c = 'Send Sales/Purchasing View To SAP';
        reqItem2.Email__c = 'testmockemail@gmail.com';
        reqItem2.CallOutCDD__c = false;
        reqItem2.RecordTypeId = rt.Id;
        reqItem2.SalesOrganization__c = '2000';
        reqItem2.InterestedProductTypeAsCustomerTOP__c = 'Petroleum Products';
        reqItem2.SAPSubmitTime__c = DateTime.now();
        insert reqItem2;

        RecordType rt2 = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem3 = new CTRRequestFormItem__c();
        //reqItem3.Name = 'TestConditionTrue Item';
        reqItem3.Customer__c = acc.Id;
        reqItem3.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem3.SAPStatus__c = 'Queue CCA';
        reqItem3.Email__c = 'testmockemail@gmail.com';
        reqItem3.CallOutCDD__c = false;
        reqItem3.RecordTypeId = rt2.Id;
        reqItem3.SalesOrganization__c = '2000';
        reqItem3.InterestedProductTypeAsCustomerTOP__c = 'Petrochemical Products';
        reqItem3.SAPSubmitTime__c = DateTime.now();
        reqItem3.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem3;
        
        
    }

    @isTest
    static void testSendSalesView_AfterUpdate(){

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '123456';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Pending CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '2000';
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Crude;Petroleum Products';
        reqItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"},{"Label":"Customer","Api":"Customer__c","Value":"'+ Master[2].Id +'"},{"Label":"TermofPayment","Api":"TermofPayment__c","Value":"'+ Master[2].Id +'"},{"Label":"SubIndustry","Api":"SubIndustry__c","Value":"'+ Master[2].Id +'"},{"Label":"Industry","Api":"Industry__c","Value":"'+ Master[2].Id +'"},{"Label":"CustomerType","Api":"CustomerType__c","Value":"'+ Master[2].Id +'"},{"Label":"InterGroup","Api":"InterGroup__c","Value":"'+ Master[2].Id +'"},{"Label":"Application","Api":"Application__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();

        // CTRRequestFormItem__c request = [SELECT ID,Name,Customer__c,CTRRequestFormHeader__c,SAPStatus__c,CallOutCDD__c,RecordTypeId,RecordTypeName__c FROM CTRRequestFormItem__c WHERE Name = 'Test 1'];
        mRequestItemOldMap.put(reqItem.Id,reqItem);

        CTRRequestFormItem__c updateRequest = reqItem;
        updateRequest.CallOutCDD__c = true;
        updateRequest.SAPStatus__c = 'Send Sales/Purchasing View To SAP';
        updateRequest.InterestedProductTypeAsCustomerTOP__c = 'Petroleum Products'; 
        // updateRequest.InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol';
        // updateRequest.InterestedProductTypeAsCustomerTX__c = 'Lube'; 
        // updateRequest.InterestedProductTypeAsSupplierTX__c = 'LAB';
        update updateRequest;

        mRequestItemNewMap.put(reqItem.Id,updateRequest);
        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());

        Test.startTest();
        CTRRequestItemHandler.SendSalesView_AfterUpdate(mRequestItemOldMap, mRequestItemNewMap);
        CTRRequestItemHandler.CalloutCDDAndNewsAfterUpdate(mRequestItemOldMap, mRequestItemNewMap);
       
        
        CTRRequestFormItem__c reqItem4 = new CTRRequestFormItem__c();
        //reqItem4.Name = 'TestConditionTrue reqItem4';
        reqItem4.Customer__c = acc.Id;
        reqItem4.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem4.SAPStatus__c = 'Queue CCA';
        reqItem4.Email__c = 'testmockemail@gmail.com';
        reqItem4.CallOutCDD__c = false;
        reqItem4.RecordTypeId = rt.Id;
        reqItem4.SalesOrganization__c = '2000';
        reqItem4.InterestedProductTypeAsCustomerTOP__c = 'Petrochemical Products;Petroleum Products';
        reqItem4.SAPSubmitTime__c = DateTime.now();
        reqItem4.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem4;
        
        CTRRequestItemHandler.setQueueToPendingCcaAfterUpdate(mRequestItemOldMap, mRequestItemNewMap);


        CTRRequestItemHandler.validateProductAndAddSalesOrgBeforeUpdate(mRequestItemOldMap, mRequestItemNewMap);
        
        Test.stopTest();
    }

    @isTest
    static void testSendSalesView_AfterUpdateCustomerEditInfo(){

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '12456';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerEditInfo' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = null;
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '2000';
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Crude';
        reqItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"},{"Label":"Customer","Api":"Customer__c","Value":"'+ Master[2].Id +'"},{"Label":"TermofPayment","Api":"TermofPayment__c","Value":"'+ Master[2].Id +'"},{"Label":"SubIndustry","Api":"SubIndustry__c","Value":"'+ Master[2].Id +'"},{"Label":"Industry","Api":"Industry__c","Value":"'+ Master[2].Id +'"},{"Label":"CustomerType","Api":"CustomerType__c","Value":"'+ Master[2].Id +'"},{"Label":"InterGroup","Api":"InterGroup__c","Value":"'+ Master[2].Id +'"},{"Label":"Application","Api":"Application__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();

        // CTRRequestFormItem__c request = [SELECT ID,Name,Customer__c,CTRRequestFormHeader__c,SAPStatus__c,CallOutCDD__c,RecordTypeId,RecordTypeName__c FROM CTRRequestFormItem__c WHERE Name = 'Test 1'];
        mRequestItemOldMap.put(reqItem.Id,reqItem);

        CTRRequestFormItem__c updateRequest = reqItem;
        updateRequest.CallOutCDD__c = true;
        updateRequest.SAPStatus__c = 'Send Sales/Purchasing View To SAP';
        // updateRequest.InterestedProductTypeAsCustomerTOP__c = 'Crude'; 
        // updateRequest.InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol';
        // updateRequest.InterestedProductTypeAsCustomerTX__c = 'Lube'; 
        // updateRequest.InterestedProductTypeAsSupplierTX__c = 'LAB';
        update updateRequest;

        // CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
        //     Id = request[0].Id,
        //     Name = 'TestConditionTrue Item',
        //     Customer__c = request[0].Customer__c,
        //     CTRRequestFormHeader__c = request[0].CTRRequestFormHeader__c,
        //     SAPStatus__c = 'Send Sales/Purchasing View To SAP',
        //     Email__c = 'testmockemail@gmail.com',
        //     CallOutCDD__c = true,
        //     RecordTypeId = request[0].RecordTypeId
        // );

        mRequestItemNewMap.put(reqItem.Id,updateRequest);
        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());

        Test.startTest();
        CTRRequestItemHandler.SendSalesView_AfterUpdate(mRequestItemOldMap, mRequestItemNewMap);
        CTRRequestItemHandler.CalloutCDDAndNewsAfterUpdate(mRequestItemOldMap, mRequestItemNewMap);
        CTRRequestItemHandler.setQueueToPendingCcaAfterUpdate(mRequestItemOldMap, mRequestItemNewMap);


        CTRRequestItemHandler.validateProductAndAddSalesOrgBeforeUpdate(mRequestItemOldMap, mRequestItemNewMap);
        
        Test.stopTest();
    }

    @isTest
    static void testValidateProductAndAddSalesOrgBeforeUpdate(){

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '124567';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Queue CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '2000';
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Lube Base Products';
        reqItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();

        // CTRRequestFormItem__c request = [SELECT ID,Name,Customer__c,CTRRequestFormHeader__c,SAPStatus__c,CallOutCDD__c,RecordTypeId,RecordTypeName__c FROM CTRRequestFormItem__c WHERE Name = 'Test 1'];
        mRequestItemOldMap.put(reqItem.Id,reqItem);

        CTRRequestFormItem__c updateRequest = reqItem;
        updateRequest.CallOutCDD__c = true;
        updateRequest.SAPStatus__c = 'Send Sales/Purchasing View To SAP';
        updateRequest.InterestedProductTypeAsCustomerTOP__c = 'Petroleum Products'; 
        // updateRequest.InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol';
        // updateRequest.InterestedProductTypeAsCustomerTX__c = 'Lube'; 
        // updateRequest.InterestedProductTypeAsSupplierTX__c = 'LAB';
        update updateRequest;

        mRequestItemNewMap.put(reqItem.Id, updateRequest);

        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());

        Test.startTest();
        
        CTRRequestItemHandler.validateProductAndAddSalesOrgBeforeUpdate(mRequestItemOldMap, mRequestItemNewMap);
        
        Test.stopTest();
    }

     @isTest
    static void testQueueCCA(){

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '124567';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Queue CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '1100';
        reqItem.SAPSubmitTime__c = System.now();
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Lube Base Products';
        insert reqItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();

        // CTRRequestFormItem__c request = [SELECT ID,Name,Customer__c,CTRRequestFormHeader__c,SAPStatus__c,CallOutCDD__c,RecordTypeId,RecordTypeName__c FROM CTRRequestFormItem__c WHERE Name = 'Test 1'];
        mRequestItemOldMap.put(reqItem.Id,reqItem);

        CTRRequestFormItem__c newReq = new CTRRequestFormItem__c();
        newReq.CallOutCDD__c = true;
        newReq.Customer__c = acc.Id;
        newReq.CTRRequestFormHeader__c = reqHeader.Id;
        newReq.SAPStatus__c = 'Send Sales/Purchasing View To SAP';
        newReq.InterestedProductTypeAsCustomerTOP__c = 'Petroleum Products'; 
        newReq.SalesOrganization__c = '1100';
        // updateRequest.InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol';
        // updateRequest.InterestedProductTypeAsCustomerTX__c = 'Lube'; 
        // updateRequest.InterestedProductTypeAsSupplierTX__c = 'LAB';
        insert newReq;

        //mRequestItemNewMap.put(reqItem.Id, updateRequest);

        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());

        Test.startTest();
		newReq.SAPStatus__c ='SAP Confirmed Sales/Purchasing View';
        update newReq;
        //CTRRequestItemHandler.validateProductAndAddSalesOrgBeforeUpdate(mRequestItemOldMap, mRequestItemNewMap);
        
        Test.stopTest();
    }

    @isTest
    static void testSendSalesView_AfterUpdate2(){

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '124568';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Queue CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '1100';
        reqItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();

        // List<CTRRequestFormItem__c> request = [SELECT ID,Name,Customer__c,CTRRequestFormHeader__c,SAPStatus__c,CallOutCDD__c,RecordTypeId,RecordTypeName__c FROM CTRRequestFormItem__c WHERE Name = 'Test 2'];

        CTRRequestFormItem__c updateRequest = reqItem;
        updateRequest.SAPStatus__c = 'SAP Confirmed Sales/Purchasing View';
        
        update updateRequest;

        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());
    }

    @isTest
    static void testSendSalesView_AfterUpdate3(){

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '124578';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Queue CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '2000';
        reqItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();

        // List<CTRRequestFormItem__c> request = [SELECT ID,Name,Customer__c,CTRRequestFormHeader__c,SAPStatus__c,CallOutCDD__c,RecordTypeId,RecordTypeName__c FROM CTRRequestFormItem__c WHERE Name ='TestConditionTrue Item'];

        CTRRequestFormItem__c updateRequest = reqItem;
        updateRequest.SAPStatus__c = 'SAP Confirmed Sales/Purchasing View';
        
        update updateRequest;

        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());
    }
    
    
    @isTest
    static void testcheckDuplicateProduct(){
		List<String>ProductFilter = new List<String>();
        ProductFilter.add('Test');
        
        List<String>ProductTrigger = new List<String>();
        ProductTrigger.add('Test');
        

        Test.startTest();
       
        CTRRequestItemHandler.checkDuplicateProduct(ProductFilter,ProductTrigger);
        Test.stopTest();
    }
    
     @isTest
    static void testAddJsonEditInfoBeforeUpdate(){
        
         Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '124567';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Queue CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '2000';
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Lube Base Products';
        reqItem.InternalEditField__c = '[{"Label":"TermOfPayment","Api":"TermOfPayment__c ","Value":"'+ Master[4].Id +'"}}]';
        insert reqItem;
        
        Id mID = reqItem.Id;
        List<String> mRequestItemFields = new List<String>(CTRRequestFormItem__c.SObjectType.getDescribe().fields.getMap().keySet());            
        String soqlItem = ''
            + ' SELECT ' + String.join(mRequestItemFields, ',')
            + ' FROM CTRRequestFormItem__c'
            + ' WHERE Id = :mID LIMIT 1';
        CTRRequestFormItem__c reqItemQ1 = Database.query(soqlItem);
        
        
        Test.startTest();
         	reqItemQ1.Name = 'Edit test';
        	update reqItemQ1;
        //CTRRequestHeaderHandler.AddJsonEditInfoBeforeUpdate(mRequestHeaderOldMap, mRequestHeaderNewMap);
        Test.stopTest();
    }

    @isTest
    static void testUpdateProductToHeaderAfterUpdate(){

        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        acc.AccountNumber__c = '124567';
        insert acc;

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

        RecordType rtHeader = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormHeader__c' AND DeveloperName = 'EditInformation' limit 1];
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            RecordTypeId = rtHeader.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]'
        );

        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        //reqItem.Name = 'Test 1';
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.SAPStatus__c = 'Queue CCA';
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.CallOutCDD__c = false;
        reqItem.RecordTypeId = rt.Id;
        reqItem.SalesOrganization__c = '2000';
        reqItem.InterestedProductTypeAsCustomerTOP__c = 'Lube Base Products';
        reqItem.InterestedProductTypeAsCustomerTX__c = 'Fuel'; 
        reqItem.InterestedProductTypeAsSupplierTOP__c = 'Crude'; 
        reqItem.InterestedProductTypeAsSupplierTX__c = 'Fuel';
        reqItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert reqItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();

        // CTRRequestFormItem__c request = [SELECT ID,Name,Customer__c,CTRRequestFormHeader__c,SAPStatus__c,CallOutCDD__c,RecordTypeId,RecordTypeName__c FROM CTRRequestFormItem__c WHERE Name = 'Test 1'];
        mRequestItemOldMap.put(reqItem.Id,reqItem);

        CTRRequestFormItem__c updateRequest = reqItem.clone(false, false, false);
        updateRequest.Id = reqItem.Id;
        updateRequest.CallOutCDD__c = true;
        updateRequest.SAPStatus__c = 'Send Sales/Purchasing View To SAP';
        updateRequest.InterestedProductTypeAsCustomerTOP__c = 'Petroleum Products'; 
        updateRequest.InterestedProductTypeAsCustomerTX__c = 'Lube'; 
        updateRequest.InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol';
        updateRequest.InterestedProductTypeAsSupplierTX__c = 'Fuel;Lube';

        mRequestItemNewMap.put(updateRequest.Id, updateRequest);

        Test.setMock(HttpCalloutMock.class, new CTRApprovalDetailControllerHttpMock());

        Test.startTest();
        
        CTRRequestItemHandler.updateProductToHeaderAfterUpdate(mRequestItemOldMap, mRequestItemNewMap);
        
        Test.stopTest();
    }

}