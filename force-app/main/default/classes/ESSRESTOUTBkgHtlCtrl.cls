/**
 * ESS_Hotel_SAP__c Obj.
 * Conditon: SAP_Status__c = SendingToSap OR F
 */
@RestResource(urlMapping='/ESSMSS_BookingHotel/*')

global class ESSRESTOUTBkgHtlCtrl {

    public class BookingHotelWrapper{
        String externalId;  // ID Salesforce Generated
        String recordID;    // RecordId__c
        String personnelNo; // PersonnelNo__c
        String hotelKey;    // HotelKey__c
        String ciDate;      // CIDate__c
        String coDate;      // CODate__c
        String hotelType;   // HotelType__c
        String roomNo;      // RoomNo__c
    }

    global class ResponseWrapper{
        List<BookingHotelWrapper> bkgHtlResWrpList;
        String messagetype = '';
        String messagetext = '';
    }

    @HttpPost
    global static ResponseWrapper bookingHotelPost()
    {
        /*try {*/
            /** SOQL query and conditiion */ 
            String selection = 'SELECT Id,RecordId__c,PersonnelNo__c,HotelKey__c,CIDate__c,CODate__c,HotelType__c,RoomNo__c FROM ESS_Hotel_SAP__c WHERE Status__c = \'SendingToSAP\' OR Status__c = \'E\' ORDER BY LastModifiedDate ASC '; 
            /** query database */
            List<ESS_Hotel_SAP__c> queryHtlSapList = Database.query(selection);
            /** assign to variable */
            List<BookingHotelWrapper> bkgHtlWrpList = new List<BookingHotelWrapper>();
            for (ESS_Hotel_SAP__c htlSap : queryHtlSapList) {
                BookingHotelWrapper bkgHtlWrp = new BookingHotelWrapper();
                // externalId = Id Salesforce Generated a2J9D000000PYlwUAG	
                bkgHtlWrp.externalId = (htlSap.Id != null ) ? htlSap.Id : '';
                bkgHtlWrp.recordID = (htlSap.RecordId__c!= null && htlSap.RecordId__c != '') ? htlSap.RecordId__c : '';
                bkgHtlWrp.personnelNo = (htlSap.PersonnelNo__c!= null && htlSap.PersonnelNo__c != '') ? htlSap.PersonnelNo__c : '';
                bkgHtlWrp.hotelKey = (htlSap.HotelKey__c!= null && htlSap.HotelKey__c != '') ? htlSap.HotelKey__c : '';
                bkgHtlWrp.ciDate = (htlSap.CIDate__c != null) ? String.valueof(htlSap.CIDate__c) : '';
                bkgHtlWrp.coDate = (htlSap.CODate__c != null) ? String.valueof(htlSap.CODate__c) : '';
                bkgHtlWrp.hotelType = (htlSap.HotelType__c	!= null && htlSap.HotelType__c	 != '') ? htlSap.HotelType__c : '';
                bkgHtlWrp.roomNo = (htlSap.RoomNo__c	!= null && htlSap.RoomNo__c	 != '') ? htlSap.RoomNo__c : '';
                
                bkgHtlWrpList.add(bkgHtlWrp);
            }

            List<Application_Log__c> appLogList = new List<Application_Log__c>();
            /** Response */
            ResponseWrapper response = new ResponseWrapper();
            response.bkgHtlResWrpList = bkgHtlWrpList;
            response.messagetype = 'Success';
            response.messagetext = 'ESSMSS_BookingHotel integration success ';
            /** App Log */
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Update';
            log.Integration_Name__c = 'ESSMSS_BookingHotel';
            log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
            log.Message_Type__c = 'Success';
            // log.Request_Body__c =  JSON.serialize().left(131072);
            String responseBodySubStr = JSON.serialize(response);  // String responseBodySubStr = JSON.serialize(dbSCCList);
            log.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
            log.OwnerId = UserInfo.getUserId();
            appLogList.add(log);

            insert appLogList;
            return response;

        /*} catch (Exception e) {

            ResponseWrapper error = new ResponseWrapper();
            error.messagetype = 'ERROR';
            error.messagetext = e.getMessage() + ' line :'+e.getLineNumber();

            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Update';
            log.Integration_Name__c = 'ESSMSS_BookingHotel';
            log.Log_Type__c = 'Inbound from SAP - Salesforce generate.';
            // log.Request_Body__c =  JSON.serialize().left(131072);
            log.Response_Body__c = JSON.serialize(error).left(131072);
            log.Message_Type__c = 'Fail';
            log.OwnerId = UserInfo.getUserId();

            insert log;
            return error;
        }*/
    }
}