@isTest
public class THOR_FTPIntegrationTest 
{
    @isTest 
    static void testCallout() 
    { 
        THORIntegration__c cs =new THORIntegration__c();
        cs.FTP_Endpoint__c = 'http://203.154.216.230:8090/api/SFTP';
        cs.Username__c = 'thor';
        cs.Password__c = 'P#eR9EuB';
        cs.Port__c = '22';
        cs.ftp_host__c = 'sftp.thaioilgroup.com';
        cs.Path__c = '/THOR_Mobility/';
        cs.File__c = '20200526-140623-813_STK_20200430_1.TXT';
        insert cs;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new THOR_FTPMockTest());
        THOR_FTPCallIntegration b = new THOR_FTPCallIntegration();
        Id batchId = Database.executeBatch(b);
        Database.executeBatch(b);
        
        Test.stopTest();
        
        List<Spare_Part_Stock__c>stock = [SELECT id FROM Spare_Part_Stock__c];
        System.assert(stock.size() > 0);
        
    }
}