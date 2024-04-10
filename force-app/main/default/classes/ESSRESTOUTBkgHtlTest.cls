@isTest
public class ESSRESTOUTBkgHtlTest {
    @Testsetup
    public static void setupData(){

        List<ESS_Hotel_SAP__c> idhtlSapList = new List<ESS_Hotel_SAP__c>();
        List<ESS_Hotel_SAP__c> htlSapList = new List<ESS_Hotel_SAP__c>();

        ESS_Hotel_SAP__c idhtlsap1 = new ESS_Hotel_SAP__c();
        ESS_Hotel_SAP__c idhtlsap2 = new ESS_Hotel_SAP__c();
        ESS_Hotel_SAP__c idhtlsap3 = new ESS_Hotel_SAP__c();

        idhtlSapList.add(idhtlsap1);
        idhtlSapList.add(idhtlsap2);
        idhtlSapList.add(idhtlsap3);
        insert idhtlSapList;

        ESS_Hotel_SAP__c htlsp1 = new ESS_Hotel_SAP__c();
        htlsp1.PersonnelNo__c = '0000000001';
        htlsp1.HotelKey__c = 'Livotel'; 
        htlsp1.CIDate__c = Date.today(); 
        htlsp1.CODate__c = Date.today()+1; 
        htlsp1.HotelType__c = ''; 
        htlsp1.RoomNo__c = '2'; 
        htlsp1.Status__c = 'SendingToSap'; 
        htlsp1.SAP_Message__c = ''; 
        htlsp1.Id = idhtlsap1.Id; 

        ESS_Hotel_SAP__c htlsp2 = new ESS_Hotel_SAP__c();
        htlsp2.PersonnelNo__c = '00000002';
        htlsp2.HotelKey__c = 'Livotel'; 
        htlsp2.CIDate__c = Date.today(); 
        htlsp2.CODate__c = Date.valueof('2023-02-19'); 
        htlsp2.HotelType__c = ''; 
        htlsp2.RoomNo__c = '2'; 
        htlsp2.Status__c = 'A'; 
        htlsp2.SAP_Message__c = ''; 
        htlsp2.Id = idhtlsap2.Id; 

        ESS_Hotel_SAP__c htlsp3 = new ESS_Hotel_SAP__c();
        htlsp3.PersonnelNo__c = null;
        htlsp3.HotelKey__c = null; 
        htlsp3.CIDate__c = null; 
        htlsp3.CODate__c = null; 
        htlsp3.HotelType__c = null; 
        htlsp3.RoomNo__c = null; 
        htlsp3.Status__c = null; 
        htlsp3.SAP_Message__c = null; 
        htlsp3.Id = idhtlsap3.Id; 

        htlSapList.add(htlsp1);
        htlSapList.add(htlsp2);
        htlSapList.add(htlsp3);
        upsert htlSapList ; 
       	// empList.add(htlsp);
        // insert empList; 
    }
    
    @isTest
    public static void testBookingHotelPost(){
        Test.startTest();
        ESSRESTOUTBkgHtlCtrl.ResponseWrapper result = ESSRESTOUTBkgHtlCtrl.bookingHotelPost();
        Test.stopTest();       
        System.assert(result != null,'List no data'); 
    }  
    
}