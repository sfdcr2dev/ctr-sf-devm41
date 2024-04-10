/* 
    ESS_ClearDataBatchable ClearData = new ESS_ClearDataBatchable();
    string cronExp1 = '0 41 15 20 6 ? *'; //0 40 15 20 6 ? *
    system.schedule('ESS - Clear Data', cronExp1, ClearData);
	
	Run on every day
	For Test '0 0 8 * * ? *' 
*/
global class ESS_ClearDataController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public string query = 'select id, document_no__c from ess_stationary__c where document_no__c = null';
         
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ESS_Stationary__c> Stationaries) {
        DeleteStationaryData();
        DeleteHotelBookingData();
        DeleteFixAndGeneralData();
        DeleteManpowerData();
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
    public void DeleteStationaryData() {
        List<ESS_Stationary__c> stationaries = [select id from ess_stationary__c where document_no__c = null];
        if(stationaries.size() > 0) {
            delete(stationaries);
        }
    }
    public void DeleteHotelBookingData() {
        List<ESS_Hotel_Booking__c> hotels = [select id from ess_hotel_booking__c where document_no__c = null];
        if(hotels.size() > 0) {
            delete(hotels);
        }
    }
    public void DeleteFixAndGeneralData() {
        List<ESS_FixAndGeneral__c> fags = [select id from ess_fixandgeneral__c where document_no__c = null];
        if(fags.size() > 0) {
            delete(fags);
        }
    }
    public void DeleteManpowerData() {
        List<ESS_Manpower__c> manpowers = [select id from ess_manpower__c where document_no__c = null];
        if(manpowers.size() > 0) {
            delete(manpowers);
        }
    }

}