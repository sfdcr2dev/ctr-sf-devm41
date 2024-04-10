@isTest
private class C360_CalloutNonSAPServiceTest {
    public class MockSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            System.debug(request.getEndpoint());
            if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0001_SRV/ZCCP_V05_Q0001(')){
                //Sold-to
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"d":{"results":[{"A0SOLD_TO":"A0001IDR","A4ZCCP_V05ZNAME1_L":"Agricon,PT","A4ZCCP_V05ZNAME2_L":"","A4ZCCP_V05ZNAME3_L":"","ZNAME5":"","ZRMNUM2":"","ZBUILDIN2":"","ZFLOOR2":"","ZHONUM2":"","ZSTREET4":"","ZSTREET3":"","ZNAME":"Agricon,PT","ZNAME2":"","ZNAME3":"","ZNAME4":"","ZBUILDING":"Jl.SiliwangiNo.68","ZRMNUM":"","ZFLOOR":"","ZHONUM":"","ZSTREET":"","ZSTREET2":"","ZCITY2":"","ZCITY":"Bangkok","ZPOST_CD":"","ZFAXEXT":"","A0TIME_ZONE":"UTC+7","ZPHONE":"0251-8313070","ZPHEXT":"","ZMPHONE":"","ZFAXNUM":"","ZVENEMAIL":"","A0TAX_NUMB":"01.131.227.9-431","A0TAX_NUMB2":"","A0ACCNT_GRP":"TRDF","ZCUSSLA":"","ZDELFLAG":"X","A0CURRENCY":"","A0CITY":"","A0COUNTRY":"TH","A4ZCCP_V05DIST_L":"","A4ZCCP_V05DIST_I":"","A4ZCCP_V05POST_L":"","A4ZCCP_V05CITY_I":"","A4ZCCP_V05WEBSITE":"","AECUVA7JRJ25QMVPVUBZ9AMNV":"1","AECUVA7JRJ25QMVPVUBZ9AMNV_F":"1"}]}}');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0002_SRV/ZCCP_V05_Q0002(')){
                //Ship-to
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"d":{"results":[{"A0SOLD_TO":"A0001IDR","A4ZCCP_V05ZNAME1_L":"Agricon,PT","A4ZCCP_V05ZNAME2_L":"","A4ZCCP_V05ZNAME3_L":"","ZNAME5":"","ZRMNUM2":"","ZBUILDIN2":"","ZFLOOR2":"","ZHONUM2":"","ZSTREET4":"","ZSTREET3":"","ZNAME":"Agricon,PT","ZNAME2":"","ZNAME3":"","ZNAME4":"","ZBUILDING":"Jl.SiliwangiNo.68","ZRMNUM":"","ZFLOOR":"","ZHONUM":"","ZSTREET":"","ZSTREET2":"","ZCITY2":"","ZCITY":"Bangkok","ZPOST_CD":"","ZFAXEXT":"","A0TIME_ZONE":"UTC+7","ZPHONE":"0251-8313070","ZPHEXT":"","ZMPHONE":"","ZFAXNUM":"","ZVENEMAIL":"","A0TAX_NUMB":"01.131.227.9-431","A0TAX_NUMB2":"","A0ACCNT_GRP":"TRDF","ZCUSSLA":"","ZDELFLAG":"X","A0CURRENCY":"","A0CITY":"","A0COUNTRY":"TH","A4ZCCP_V05DIST_L":"","A4ZCCP_V05DIST_I":"","A4ZCCP_V05POST_L":"","A4ZCCP_V05CITY_I":"","A4ZCCP_V05WEBSITE":"","AECUVA7JRJ25QMVPVUBZ9AMNV":"1","AECUVA7JRJ25QMVPVUBZ9AMNV_F":"1"}]}}');
                response.setStatusCode(200);
                return response;
                
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qassapbwplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0003_SRV/ZCCP_V05_Q0003(')){
                //SalesArea TS
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ { "ZCUSTMR":"302","A0SALESORG":"9200","A0DISTR_CHAN":"16","ZTSCUSTT":"CT003","ZTSCUST_T":"RETAIL","ZTSAPP":"","ZTSAPP_T":"Not assigned","ZTSINDUST":"IN002","ZTSINDUST_T":"AGROCHEMICAL","ZTSSINDUS":"","ZTSSINDUS_T":"Not assigned","ZSLDSTRCT":"ZID002","ZTSSGRP":"ID6","A0CURRENCY":"","A4ZCCP_V05CUSTOMERGUAR":"ZB01","A0C_CTR_AREA":"9300","A0PMNTTRMS":"Z098","A0INCOTERMS":"DDP","ZKTGRM":"","ZTSCUSGRP":"CG005","ZDELFLAG":"X","AECUVA7JRJ240D2VPO0ATXVJW":"1","AECUVA7JRJ240D2VPO0ATXVJW_F":"1" },'+
                                 '{ "ZCUSTMR":"302","A0SALESORG":"9300","A0DISTR_CHAN":"16","ZTSCUSTT":"CT003","ZTSAPP_T":"Not assigned","ZTSINDUST":"IN002","ZTSSINDUS_T":"Not assigned","ZSLDSTRCT":"ZID002","ZTSSGRP":"ID6","A4ZCCP_V05CUSTOMERGUAR":"ZB01","A0C_CTR_AREA":"9300","A0PMNTTRMS":"Z098","A0INCOTERMS":"DDP","ZTSCUSGRP":"CG005","ZDELFLAG":"X","AECUVA7JRJ240D2VPO0ATXVJW":"1" },'+
                                 '{ "ZCUSTMR":"302","A0SALESORG":"9400","A0DISTR_CHAN":"16","ZTSCUSTT":"CT003","ZTSAPP_T":"Not assigned","ZTSINDUST":"IN002","ZTSSINDUS_T":"Not assigned","ZSLDSTRCT":"ZID002","ZTSSGRP":"ID6","A4ZCCP_V05CUSTOMERGUAR":"ZB01","A0C_CTR_AREA":"9300","A0PMNTTRMS":"Z098","A0INCOTERMS":"DDP","ZTSCUSGRP":"CG005","ZDELFLAG":"X","AECUVA7JRJ240D2VPO0ATXVJW":"1" }]}}}');
                response.setStatusCode(200);
                return response;
                
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V02_Q0007_SRV/ZCCP_V02_Q0007(')){
                //Material
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ { "ZMATERIL":"R47000008","ZMATERIL_T":"BC (BUTYL CELLOSOLVE)/ BULK/ KGM","ZMATERIL_0BASE_UOM":"KG","ZBU_UNIT":"Solvents & Chemical","ZDELFLAG":"","A0DIVISION":"52","A0MATL_GROUP":"ZA00021","A0SIZE_DIM":"","AECUVA7JRJ25QMTQC24GZII44":"1","AECUVA7JRJ25QMTQC24GZII44_F":"1" },'+
                                 '{ "ZMATERIL":"R47000009","ZMATERIL_T":"BC ","ZMATERIL_0BASE_UOM":"KG","ZBU_UNIT":"Solvents & Chemical","ZDELFLAG":"x","A0DIVISION":"52","A0MATL_GROUP":"","A0SIZE_DIM":"","AECUVA7JRJ25QMTQC24GZII44":"1","AECUVA7JRJ25QMTQC24GZII44_F":"1" }]}}');
                response.setStatusCode(200);
                return response;  
                
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V02_Q0008_SRV/ZCCP_V02_Q0008(')){
                //MaterialUnit
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ {"ZMATERIL":"R57000173","ZMATERIL_0BASE_UOM":"KG","A0UNIT":"MT","AECUVA7JRJ25QMTRD4LP0PYRF":"1","AECUVA7JRJ25QMTRD4LP0PYRF_F":"1","AECUVA7JRJ25QMTRD4LP0Q52Z":"1000.000","AECUVA7JRJ25QMTRD4LP0Q52Z_F":"1.000,000","AECUVA7JRJ25QMTRD4LP0QBEJ":"1.000","AECUVA7JRJ25QMTRD4LP0QBEJ_F":"1,000"}]}}');
                response.setStatusCode(200);
                return response;
                
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qassapbwplatform.thaioilgroup.com/sap/opu/odata/sap/ZTNX_V40_Q022_SRV/ZTNX_V40_Q022(')){
                //Finacial
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ {"A0CALYEAR":"2022","A0CALYEAR_T":"2022","A0SALESORG":"9200","A0SOLD_TO":"302","AECUVA7JRJ25QO2R3DU2LRF02":"9134.04","AECUVA7JRJ25QO2R3DU2LRF02_E":"USD","AECUVA7JRJ25QO2R3DU2LQPPU":"8547.04","AECUVA7JRJ25QO2R3DU2LQPPU_E":"USD","AECUVA7JRJ25QO2R3DU2LQW1E":"8547.04","AECUVA7JRJ25QO2R3DU2LQW1E_E":"USD","AECUVA7JRJ25QO2R3DU2LR2CY":"587.00","AECUVA7JRJ25QO2R3DU2LR2CY_E":"USD","AECUVA7JRJ25QO2R3DU2LR8OI":"587.00","AECUVA7JRJ25QO2R3DU2LR8OI_E":"USD"}]}}');
                response.setStatusCode(200);
                return response;
                
            } else {
                System.assert(false, 'unexpected endpoint ' + request.getEndpoint());
                return null;
            }
        }
    }
    
    public class MockError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            System.debug(request.getEndpoint());
            if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0001_SRV/ZCCP_V05_Q0001(')){
                //Sold-to
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"d":{"results":[{"A0SOLD_TO":"","A4ZCCP_V05ZNAME1_L":"Agricon,PT","A4ZCCP_V05ZNAME2_L":"","A4ZCCP_V05ZNAME3_L":"","ZNAME5":"","ZRMNUM2":"","ZBUILDIN2":"","ZFLOOR2":"","ZHONUM2":"","ZSTREET4":"","ZSTREET3":"","ZNAME":"Agricon,PT","ZNAME2":"","ZNAME3":"","ZNAME4":"","ZBUILDING":"Jl.SiliwangiNo.68","ZRMNUM":"","ZFLOOR":"","ZHONUM":"","ZSTREET":"","ZSTREET2":"","ZCITY2":"","ZCITY":"Bangkok1","ZPOST_CD":"","ZFAXEXT":"","A0TIME_ZONE":"UTC+7","ZPHONE":"0251-8313070","ZPHEXT":"","ZMPHONE":"","ZFAXNUM":"","ZVENEMAIL":"","A0TAX_NUMB":"01.131.227.9-431","A0TAX_NUMB2":"","A0ACCNT_GRP":"TRDF","ZCUSSLA":"","ZDELFLAG":"X","A0CURRENCY":"","A0CITY":"","A0COUNTRY":"TH1","A4ZCCP_V05DIST_L":"","A4ZCCP_V05DIST_I":"","A4ZCCP_V05POST_L":"","A4ZCCP_V05CITY_I":"","A4ZCCP_V05WEBSITE":"","AECUVA7JRJ25QMVPVUBZ9AMNV":"1","AECUVA7JRJ25QMVPVUBZ9AMNV_F":"1"}]}}');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0002_SRV/ZCCP_V05_Q0002(')){
                //Ship-to
                HTTPResponse response = new HTTPResponse();
                response.setBody('{"d":{"results":[{"A0SOLD_TO":"","A4ZCCP_V05ZNAME1_L":"Agricon,PT","A4ZCCP_V05ZNAME2_L":"","A4ZCCP_V05ZNAME3_L":"","ZNAME5":"","ZRMNUM2":"","ZBUILDIN2":"","ZFLOOR2":"","ZHONUM2":"","ZSTREET4":"","ZSTREET3":"","ZNAME":"Agricon,PT","ZNAME2":"","ZNAME3":"","ZNAME4":"","ZBUILDING":"Jl.SiliwangiNo.68","ZRMNUM":"","ZFLOOR":"","ZHONUM":"","ZSTREET":"","ZSTREET2":"","ZCITY2":"","ZCITY":"Bangkok1","ZPOST_CD":"","ZFAXEXT":"","A0TIME_ZONE":"UTC+7","ZPHONE":"0251-8313070","ZPHEXT":"","ZMPHONE":"","ZFAXNUM":"","ZVENEMAIL":"","A0TAX_NUMB":"01.131.227.9-431","A0TAX_NUMB2":"","A0ACCNT_GRP":"TRDF","ZCUSSLA":"","ZDELFLAG":"X","A0CURRENCY":"","A0CITY":"","A0COUNTRY":"TH1","A4ZCCP_V05DIST_L":"","A4ZCCP_V05DIST_I":"","A4ZCCP_V05POST_L":"","A4ZCCP_V05CITY_I":"","A4ZCCP_V05WEBSITE":"","AECUVA7JRJ25QMVPVUBZ9AMNV":"1","AECUVA7JRJ25QMVPVUBZ9AMNV_F":"1"}]}}');
                response.setStatusCode(200);
                return response;
                
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qassapbwplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0003_SRV/ZCCP_V05_Q0003(')){
                //SalesArea TS
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ { "ZCUSTMR":"3021","A0SALESORG":"92001","A0DISTR_CHAN":"16","ZTSCUSTT":"CT003","ZTSCUST_T":"RETAIL","ZTSAPP":"","ZTSAPP_T":"Not assigned","ZTSINDUST":"IN002","ZTSINDUST_T":"AGROCHEMICAL","ZTSSINDUS":"","ZTSSINDUS_T":"Not assigned","ZSLDSTRCT":"ZID002","ZTSSGRP":"ID6","A0CURRENCY":"","A4ZCCP_V05CUSTOMERGUAR":"ZB01","A0C_CTR_AREA":"9300","A0PMNTTRMS":"Z098","A0INCOTERMS":"DDP","ZKTGRM":"","ZTSCUSGRP":"CG005","ZDELFLAG":"X","AECUVA7JRJ240D2VPO0ATXVJW":"1","AECUVA7JRJ240D2VPO0ATXVJW_F":"1" },{ "ZCUSTMR":"302","A0SALESORG":"92001","A0DISTR_CHAN":"16","ZTSCUSTT":"CT003","ZTSCUST_T":"RETAIL","ZTSAPP":"","ZTSAPP_T":"Not assigned","ZTSINDUST":"IN002","ZTSINDUST_T":"AGROCHEMICAL","ZTSSINDUS":"","ZTSSINDUS_T":"Not assigned","ZSLDSTRCT":"ZID002","ZTSSGRP":"ID6","A0CURRENCY":"","A4ZCCP_V05CUSTOMERGUAR":"ZB01","A0C_CTR_AREA":"9300","A0PMNTTRMS":"Z098","A0INCOTERMS":"DDP","ZKTGRM":"","ZTSCUSGRP":"CG005","ZDELFLAG":"X","AECUVA7JRJ240D2VPO0ATXVJW":"1","AECUVA7JRJ240D2VPO0ATXVJW_F":"1" }]}}}');
                response.setStatusCode(200);
                return response;
                
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V02_Q0007_SRV/ZCCP_V02_Q0007(')){
                //Material
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ { "ZMATERIL":"R47000008","ZMATERIL_T":"BC (BUTYL CELLOSOLVE)/ BULK/ KGM","ZMATERIL_0BASE_UOM":"KG","ZBU_UNIT":"Solvents & Chemical","ZDELFLAG":"","A0DIVISION":"52","A0MATL_GROUP":"ZA00021","A0SIZE_DIM":"","AECUVA7JRJ25QMTQC24GZII44":"1","AECUVA7JRJ25QMTQC24GZII44_F":"1" },'+
                                 '{ "ZMATERIL":"R47000019","ZMATERIL_T":"BC ","ZMATERIL_0BASE_UOM":"KG","ZBU_UNIT":"Solvents & Chemical","ZDELFLAG":"","A0DIVISION":"52a","A0MATL_GROUP":"asd","A0SIZE_DIM":"","AECUVA7JRJ25QMTQC24GZII44":"1","AECUVA7JRJ25QMTQC24GZII44_F":"1" }]}}');
                response.setStatusCode(200);
                return response;  
                   
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V02_Q0008_SRV/ZCCP_V02_Q0008(')){
                //MaterialUnit
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ {"ZMATERIL":"R57000173","ZMATERIL_0BASE_UOM":"KGa","A0UNIT":"MT","AECUVA7JRJ25QMTRD4LP0PYRF":"1","AECUVA7JRJ25QMTRD4LP0Q52Z":"1000.000","AECUVA7JRJ25QMTRD4LP0QBEJ":"1.000"},'+
                                 '{"ZMATERIL":"R57000179","ZMATERIL_0BASE_UOM":"KGa","A0UNIT":"MT","AECUVA7JRJ25QMTRD4LP0PYRF":"1","AECUVA7JRJ25QMTRD4LP0Q52Z":"1000.000","AECUVA7JRJ25QMTRD4LP0QBEJ":"1.000"}]}}');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().startsWithIgnoreCase('https://qassapbwplatform.thaioilgroup.com/sap/opu/odata/sap/ZTNX_V40_Q022_SRV/ZTNX_V40_Q022(')){
                //Finacial
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "d":{ "results":[ {"A0CALYEAR":"2022","A0SALESORG":"9200","A0SOLD_TO":"2","AECUVA7JRJ25QO2R3DU2LRF02":"9134.04","AECUVA7JRJ25QO2R3DU2LRF02_E":"USD","AECUVA7JRJ25QO2R3DU2LQPPU":"8547.04","AECUVA7JRJ25QO2R3DU2LQPPU_E":"USD","AECUVA7JRJ25QO2R3DU2LQW1E":"8547.04","AECUVA7JRJ25QO2R3DU2LQW1E_E":"USD","AECUVA7JRJ25QO2R3DU2LR2CY":"587.00","AECUVA7JRJ25QO2R3DU2LR2CY_E":"USD","AECUVA7JRJ25QO2R3DU2LR8OI":"587.00","AECUVA7JRJ25QO2R3DU2LR8OI_E":"USD"},'
                                 +'{"A0CALYEAR":"2022","A0SALESORG":"9200","A0SOLD_TO":"302","AECUVA7JRJ25QO2R3DU2LRF02":"9134.04","AECUVA7JRJ25QO2R3DU2LRF02_E":"USDa","AECUVA7JRJ25QO2R3DU2LQPPU":"8547.04","AECUVA7JRJ25QO2R3DU2LQPPU_E":"USD","AECUVA7JRJ25QO2R3DU2LQW1E":"8547.04","AECUVA7JRJ25QO2R3DU2LQW1E_E":"USD","AECUVA7JRJ25QO2R3DU2LR2CY":"587.00","AECUVA7JRJ25QO2R3DU2LR2CY_E":"USD","AECUVA7JRJ25QO2R3DU2LR8OI":"587.00","AECUVA7JRJ25QO2R3DU2LR8OI_E":"USD"}]}}');
                response.setStatusCode(200);
                return response;
                
            } else {
                System.assert(false, 'unexpected endpoint ' + request.getEndpoint());
                return null;
            }
        }
    }
    
    @TestSetup
    static void setup() {
        C360Integration__c Integrate = new C360Integration__c();
        Integrate.NonSAP_EndpointCustomerSoldto__c = 'https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0001_SRV/ZCCP_V05_Q0001(';
        Integrate.NonSAP_EndpointCustomerShipto__c = 'https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0002_SRV/ZCCP_V05_Q0002(';
        Integrate.NonSAP_EndpointCustomerSalesAreaTS__c = 'https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V05_Q0003_SRV/ZCCP_V05_Q0003(';
        Integrate.NonSAP_EndpointProductMaster__c = 'https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V02_Q0007_SRV/ZCCP_V02_Q0007(';
        Integrate.NonSAP_EndpointProductUnitConversion__c = 'https://qasSAPBWplatform.thaioilgroup.com/sap/opu/odata/sap/ZCCP_V02_Q0008_SRV/ZCCP_V02_Q0008(';
        Integrate.NonSAP_EndpointFinancial__c = 'https://qassapbwplatform.thaioilgroup.com/sap/opu/odata/sap/ZTNX_V40_Q022_SRV/ZTNX_V40_Q022(';
        
        
        Integrate.Yesterday__c = System.Today().addDays(-180);
       
        insert Integrate;
        
        List<Master_Map__c> Master = new List<Master_Map__c>();
        Master_Map__c m1 = new Master_Map__c(Code__c='ZTH0245', Type__c='Transportation Zone');
        Master.add(m1);
        Master_Map__c m2 = new Master_Map__c(Code__c='TH', Type__c='Country');
        Master.add(m2);
        Master_Map__c m3 = new Master_Map__c(Code__c='TH-Bangkok', Name ='TH-Bangkok',  Type__c='Province');
        Master.add(m3);
        Master_Map__c m4 = new Master_Map__c(Code__c='ZA00021', Type__c='Material Group');
        Master.add(m4);
        Master_Map__c m5 = new Master_Map__c(Code__c='Z098', Type__c ='Payment Term');   
        Master.add(m5);
        
        insert Master;
        
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;
        
        List<Account> accList = new List<Account>();
        Account a1 = new Account(AccountNumber__c='302', Name='A', RecordTypeId = accRecordTypeId);
        accList.add(a1);
        Account a2 = new Account(AccountNumber__c='1', Name='A2' , RecordTypeId = accRecordTypeId);
        accList.add(a2);
        
        insert accList;
        
        List<C360_Product__c> productMasterList = new List<C360_Product__c>();
        C360_Product__c pdm1 = new C360_Product__c(MaterialCode__c ='R57000173', Name ='product name1');
        productMasterList.add(pdm1);
        
        insert productMasterList;
        
    }
    
    @isTest
    static void testSuccess() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new C360_CalloutNonSAPServiceTest.MockSuccess());
        Id batchJob1 = Database.executeBatch(new C360_NonSAPAccountSoldtoBatch(), 10);
        Id batchJob2 = Database.executeBatch(new C360_NonSAPAccountShiptoBatch(), 10);
        Id batchJob3 = Database.executeBatch(new C360_NonSAPSalesAreaTSBatch(), 10);
        Id batchJob4 = Database.executeBatch(new C360_NonSAPProductBatch(), 10);
        Id batchJob5 = Database.executeBatch(new C360_NonSAPProductUnitBatch(), 10);
        Id batchJob6 = Database.executeBatch(new C360_NonSAPFinancialBatch(), 10);
        
        Test.stopTest();
    }

    @isTest
    static void testError() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new C360_CalloutNonSAPServiceTest.MockError());
        Id batchJob1 = Database.executeBatch(new C360_NonSAPAccountSoldtoBatch(), 10);
        Id batchJob2 = Database.executeBatch(new C360_NonSAPAccountShiptoBatch(), 10);
        Id batchJob3 = Database.executeBatch(new C360_NonSAPSalesAreaTSBatch(), 10);
        Id batchJob4 = Database.executeBatch(new C360_NonSAPProductBatch(), 10);
        Id batchJob5 = Database.executeBatch(new C360_NonSAPProductUnitBatch(), 10);
        Id batchJob6 = Database.executeBatch(new C360_NonSAPFinancialBatch(), 10);
        
        Test.stopTest();
    }
    
    @isTest
    static void testC360_ScheduleNonSAP() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new C360_CalloutNonSAPServiceTest.MockSuccess());
        String jobId1 = System.schedule('C360_ScheduleNonSAPAccount',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduleNonSAPAccount());
        String jobId2 = System.schedule('C360_ScheduleNonSAPSalesAreaTS',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduleNonSAPSalesAreaTS());
        String jobId3 = System.schedule('C360_ScheduleNonSAPProduct',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduleNonSAPProduct());
        String jobId4 = System.schedule('C360_ScheduleNonSAPProductUnit',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduleNonSAPProductUnit());
        String jobId5 = System.schedule('C360_ScheduleNonSAPFinancial',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduleNonSAPFinancial());
        Test.stopTest();
    }
}