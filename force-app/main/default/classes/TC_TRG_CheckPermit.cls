/* Test class for CheckPermit */
@isTest
public class TC_TRG_CheckPermit {

    public static TestMethod void CheckPermit() {
        
        Permit__c Permit = new Permit__c();
        Permit.Permit_Topic__c = 'เทสเรื่องขออนุญาต';
        Permit.Permit_Department__c = 'กรมเจ้าท่า';
        insert(Permit);
        
    }
    
    public static TestMethod void CheckUpdatePermit() {
        
        Permit__c Permit = new Permit__c();
        Permit.Permit_Topic__c = 'วัด';
        Permit.Permit_Department__c = 'กรมเจ้าท่า';
        insert(Permit);
        
        Permit__c existPermit = [select id, Permit_Topic__c from Permit__c where Permit_Topic__c = 'วัด'];

        Test.startTest();
        
        try {
            
            existPermit.Permit_Topic__c = 'วัด';
            existPermit.Permit_Department__c = 'กรมเจ้าท่า';
            
            update(existPermit);
        }
        catch(Exception e) {
        	Boolean expectedExceptionThrown =  e.getMessage().contains('กรุณาเช็ค ' + '**เรื่องที่ขออนุญาติ**' + ' เนื่องจากไม่อนุญาติให้ใข้ ชื่อเรื่องที่ขออนุญาติ ซ้ำกันได') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);        
        }
        
        Test.stopTest();
        
    }
    
}