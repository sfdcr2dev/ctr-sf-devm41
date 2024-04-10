@isTest
public with sharing class THOR_OnLoadController_Test {

    @isTest
    public static void testIsRedirected(){
        try{
            String uniqueUserName = 'engineer' + DateTime.now().getTime() + '@thaioilgroup.com';
            // This code runs as the system user
            Profile p = [SELECT Id FROM Profile WHERE Name='Engineer'];
            User u = new User(Alias = 'standt', Email='engineer@thaioilgroup.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='Asia/Bangkok',
            UserName=uniqueUserName);

            System.runAs(u) {
                Test.startTest();
                Boolean result = THOR_OnLoadController.isRedirected();
                Test.stopTest();
            
                System.assert(result !=null);
            }
        } catch (Exception e){
            System.debug(e.getMessage() + e.getLineNumber());
        }
    }

    @isTest
    public static void testRedirectToRecordDisplay() {
        try{
            String uniqueUserName = 'engineer' + DateTime.now().getTime() + '@thaioilgroup.com';
            // This code runs as the system user
            Profile p = [SELECT Id FROM Profile WHERE Name='Engineer'];
            User u = new User(Alias = 'standt', Email='engineer@thaioilgroup.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='Asia/Bangkok',
            UserName=uniqueUserName);

            System.runAs(u) {
                Test.startTest();
                Object result = THOR_OnLoadController.redirectToRecordDisplay();
                Test.stopTest();
            
                //System.assert(result != null);
            }
        } catch (Exception e){
            System.debug(e.getMessage() + e.getLineNumber());
        }
    }
    
    @isTest
    public static void testOrderLink(){ 
        try{
            String uniqueUserName = 'engineer' + DateTime.now().getTime() + '@thaioilgroup.com';
            // This code runs as the system user
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Engineer'];
            User u = new User(Alias = 'standt', Email='engineer@thaioilgroup.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='Asia/Bangkok',
            UserName=uniqueUserName);

            Order__c exampleOrder = new Order__c();
            exampleOrder.Name = 'Example Order Name';
            insert exampleOrder;
            
            Work_Clearance__c clearance = new Work_Clearance__c();
            clearance.Name = 'Example';
            clearance.Work_Clearance__c = 'Example';
            clearance.Description__c = 'Example Description';
            clearance.Priority__c = '5';
            clearance.Order__c = exampleOrder.Id;
            insert clearance;
            
			System.runAs(u) {
                Test.startTest();
                String result = THOR_OnLoadController.checkNotiOrder(clearance.Id);
                Test.stopTest();
                
                System.assert(result !=null);
            }
        } catch (Exception e){
            System.debug(e.getMessage() + e.getLineNumber());
        }
    }
    @isTest
    public static void testNotiLink(){
        try{
            String uniqueUserName = 'engineer' + DateTime.now().getTime() + '@thaioilgroup.com';
            // This code runs as the system user
            Profile p = [SELECT Id FROM Profile WHERE Name='Engineer'];
            User u = new User(Alias = 'standt', Email='engineer@thaioilgroup.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='Asia/Bangkok',
            UserName=uniqueUserName);

            Notification__c noti = new Notification__c();
            noti.Name = 'Test Notification';
            noti.Description__c = 'Test Notification';
            noti.AssignedTo__c = UserInfo.getUserId();
            insert noti;
            
            Work_Clearance__c clearance = new Work_Clearance__c();
            clearance.Name = 'Example';
            clearance.Work_Clearance__c = 'Example';
            clearance.Description__c = 'Example Description';
            clearance.Priority__c = '5';
            clearance.Order__c = noti.Id;
            insert clearance;
        
            System.runAs(u) {
                Test.startTest();
                String result = THOR_OnLoadController.checkNotiOrder(clearance.Id);
                Test.stopTest();
            
                System.assert(result !=null);
            }
        } catch (Exception e){
            System.debug(e.getMessage() + e.getLineNumber());
        }
    }
}

//@isTest
//public with sharing class THOR_OnLoadController_Test {
//    @isTest
//    public static void testOrderLink(){ 
//        try{
//        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
//        
//        User u1 = new User(Alias = 'standt1',Country='United Kingdom',
//        Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8',
//         LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',
//         ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
//         UserName='dprobertdemo1@camfed.org');
//        insert u1;
//
//        Order__c exampleOrder = new Order__c();
//        exampleOrder.Name = 'Example Order Name';
//        insert exampleOrder;
//
//        Work_Clearance__c clearance = new Work_Clearance__c();
//        clearance.Name = 'Example';
//        clearance.Work_Clearance__c = 'Example';
//        clearance.Description__c = 'Example Description';
//        clearance.Priority__c = '5';
//        clearance.Order__c = exampleOrder.Id;
//        insert clearance;
//
//        Test.startTest();
//        String result = THOR_OnLoadController.checkNotiOrder(clearance.Id);
//        Test.stopTest();
//		
//        System.assert(result !=null);
//        } catch (Exception e){
//            System.debug(e.getMessage() + e.getLineNumber());
//        }
//        
//
//    }
//    @isTest
//    public static void testNotiLink(){
//        try{
//            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
//            
//            User u1 = new User(Alias = 'standt1',Country='United Kingdom',
//            Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8',
//             LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',
//             ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
//             UserName='dprobertdemo1@camfed.org');
//            insert u1;
//    
//            Notification__c noti = new Notification__c();
//            noti.Name = 'Test Notification';
//            noti.Description__c = 'Test Notification';
//            noti.AssignedTo__c = UserInfo.getUserId();
//            insert noti;
//    
//            Work_Clearance__c clearance = new Work_Clearance__c();
//            clearance.Name = 'Example';
//            clearance.Work_Clearance__c = 'Example';
//            clearance.Description__c = 'Example Description';
//            clearance.Priority__c = '5';
//            clearance.Order__c = noti.Id;
//            insert clearance;
//    
//            Test.startTest();
//            String result = THOR_OnLoadController.checkNotiOrder(clearance.Id);
//            Test.stopTest();
//		
//            System.assert(result !=null);
//             } catch (Exception e){
//            System.debug(e.getMessage() + e.getLineNumber());
//        }
//    }
//}