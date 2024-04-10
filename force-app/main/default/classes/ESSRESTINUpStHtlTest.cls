@isTest
public class ESSRESTINUpStHtlTest {
    @Testsetup
    public static void setupData()
    {
        List<ESS_Hotel_SAP__c> idhtlSapList = new List<ESS_Hotel_SAP__c>();
        List<ESS_Hotel_SAP__c> htlSapList = new List<ESS_Hotel_SAP__c>();

        ESS_Hotel_SAP__c idhtlsap1 = new ESS_Hotel_SAP__c();
        ESS_Hotel_SAP__c idhtlsap2 = new ESS_Hotel_SAP__c();
        ESS_Hotel_SAP__c idhtlsap3 = new ESS_Hotel_SAP__c();
        ESS_Hotel_SAP__c idhtlsap4 = new ESS_Hotel_SAP__c();

        idhtlSapList.add(idhtlsap1);
        idhtlSapList.add(idhtlsap2);
        idhtlSapList.add(idhtlsap3);
        idhtlSapList.add(idhtlsap4);
        insert idhtlSapList;

        ESS_Hotel_SAP__c htlsp1 = new ESS_Hotel_SAP__c();
        htlsp1.PersonnelNo__c = '0000000001';
        htlsp1.HotelKey__c = 'Livotel'; 
        htlsp1.CIDate__c = Date.today(); 
        htlsp1.CODate__c = Date.today()+1; 
        htlsp1.HotelType__c = ''; 
        htlsp1.RoomNo__c = '10'; 
        htlsp1.Status__c = 'SendingToSap'; 
        htlsp1.SAP_Message__c = ''; 
        htlsp1.Id = idhtlsap1.Id; 

        ESS_Hotel_SAP__c htlsp2 = new ESS_Hotel_SAP__c();
        htlsp2.PersonnelNo__c = '00000002';
        htlsp2.HotelKey__c = 'Livotel'; 
        htlsp2.CIDate__c = Date.today(); 
        htlsp2.CODate__c = Date.valueof('2023-02-19'); 
        htlsp2.HotelType__c = ''; 
        htlsp2.RoomNo__c = '05'; 
        htlsp2.Status__c = 'E'; 
        htlsp2.SAP_Message__c = ''; 
        htlsp2.Id = idhtlsap2.Id; 

        
        ESS_Hotel_SAP__c htlsp3 = new ESS_Hotel_SAP__c();
        htlsp3.PersonnelNo__c = '25425425';
        htlsp3.HotelKey__c = ''; 
        htlsp3.CIDate__c = null; 
        htlsp3.CODate__c = null; 
        htlsp3.HotelType__c = ''; 
        htlsp3.RoomNo__c = '234'; 
        htlsp3.Status__c = 'a'; 
        htlsp3.SAP_Message__c = null; 
        htlsp3.Id = idhtlsap3.Id; 

        ESS_Hotel_SAP__c htlsp4 = new ESS_Hotel_SAP__c();
        htlsp4.PersonnelNo__c = null;
        htlsp4.HotelKey__c = null; 
        htlsp4.CIDate__c = null; 
        htlsp4.CODate__c = null; 
        htlsp4.HotelType__c = null; 
        htlsp4.RoomNo__c = null; 
        htlsp4.Status__c = null; 
        htlsp4.SAP_Message__c = null; 
        htlsp4.Id = idhtlsap4.Id; 

        htlSapList.add(htlsp1);
        htlSapList.add(htlsp2);
        htlSapList.add(htlsp3);
        htlSapList.add(htlsp4);
        upsert htlSapList ; 
    }

    @isTest
    public static void testUpdateStatusHotelPostSuccess(){

        List<ESS_Hotel_SAP__c> htlSapList = [SELECT Id,RecordId__c,PersonnelNo__c,HotelKey__c,CIDate__c,CODate__c,HotelType__c,RoomNo__c,Status__c,SAP_Message__c FROM ESS_Hotel_SAP__c];
        String jsonSTR = '{'+
                            '"UpdateStatusHotelWrapperList": ['
                            +'{'
                                +'"status": "s",'
                                +'"sapMessage": "htlsp1",'
                                +'"externalId": "' +htlSapList[0].Id+'"'
                            +'},'
                            +'{'
                                +'"status": "S",'
                                +'"sapMessage": "htlsp2",'
                                +'"externalId": "' +htlSapList[1].Id+'"'
                            +'}'
                            +']'
                        +'}';

        Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String essJson= JSON.serialize(responseValue.get('UpdateStatusHotelWrapperList')) ;
        List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>  updWrapperList = (List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>)JSON.deserialize(essJson, List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>.class);
        
        Test.startTest(); 
        ESSRESTINUpStHtlCtrl.updateStatusHotelPost(updWrapperList);
        Test.stopTest();
    }

    @isTest
    public static void testUpdateStatusHotelPostFail(){

        List<ESS_Hotel_SAP__c> htlSapList = [SELECT Id,RecordId__c,PersonnelNo__c,HotelKey__c,CIDate__c,CODate__c,HotelType__c,RoomNo__c,Status__c,SAP_Message__c FROM ESS_Hotel_SAP__c];
        String jsonSTR = '{'+
                            '"UpdateStatusHotelWrapperList": ['
                            +'{'
                                +'"status": "ssssssssss",'
                                +'"sapMessage": "htlsp1",'
                                +'"externalId": "' +htlSapList[0].Id+'"'
                            +'},'
                            +'{'
                                +'"status": "S",'
                                +'"sapMessage": "htlsp2",'
                                +'"externalId": "' +htlSapList[1].Id+'"'
                            +'},'
                            +'{'
                                +'"status": "O",'
                                +'"sapMessage": "Testtttttttttttttt",'
                                +'"externalId": "' +htlSapList[2].Id+'"'
                            +'}'
                            +']'
                        +'}';

        Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String essJson= JSON.serialize(responseValue.get('UpdateStatusHotelWrapperList')) ;
        List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>  updWrapperList = (List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>)JSON.deserialize(essJson, List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>.class);
        
        Test.startTest(); 
        ESSRESTINUpStHtlCtrl.updateStatusHotelPost(updWrapperList);
        Test.stopTest();
    }

    @isTest
    public static void testUpdateStatusHotelPostERR(){

        List<ESS_Hotel_SAP__c> htlSapList = [SELECT Id,RecordId__c,PersonnelNo__c,HotelKey__c,CIDate__c,CODate__c,HotelType__c,RoomNo__c,Status__c,SAP_Message__c FROM ESS_Hotel_SAP__c];
        String jsonSTR = '{'+
                            '"UpdateStatusHotelWrapperList": ['
                            +'{'
                                +'"status": "ssssssssss",'
                                +'"sapMessage": "htlsp1",'
                                +'"externalId": ""'
                            +'},'
                            +'{'
                                +'"status": "S",'
                                +'"sapMessage": "htlsp2",'
                                +'"externalId": "' +htlSapList[0].Id+'"'
                            +'},'
                            +'{'
                                +'"status": "O",'
                                +'"sapMessage": "Testtttttttttttttt",'
                                +'"externalId": "' +htlSapList[1].Id+'"'
                            +'},'
                            +'{'
                                +'"status": "Success",'
                                +'"sapMessage": "Testtttttttttttttt",'
                                +'"externalId": "' +htlSapList[2].Id+'"'
                            +'}'
                            +']'
                        +'}';

        Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String essJson= JSON.serialize(responseValue.get('UpdateStatusHotelWrapperList')) ;
        List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>  updWrapperList = (List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>)JSON.deserialize(essJson, List<ESSRESTINUpStHtlCtrl.UpdateStatusHotelWrapper>.class);
        
        Test.startTest(); 
        ESSRESTINUpStHtlCtrl.updateStatusHotelPost(updWrapperList);
        Test.stopTest();
    }
}