@isTest
public class ESSRESTOUTEmpHtlTest {
    @Testsetup
    public static void setupData(){

        List<ESS_Master_Employee__c> empList = new List<ESS_Master_Employee__c>();
        List<ESS_Retirement__c> rtmList = new List<ESS_Retirement__c>();
        List<ESS_Application__c> appList = new List<ESS_Application__c>();

        ESS_Application__c  essApp1 = new ESS_Application__c();
        essApp1.Status__c = 'Verified';
        essApp1.Completed_Date__c = null;
        appList.add(essApp1);

        ESS_Application__c  essApp2 = new ESS_Application__c();
        essApp2.Status__c = 'Verified';
        essApp2.Completed_Date__c = null;
        appList.add(essApp2);

        insert appList;

        ESS_Retirement__c rtm1 = new ESS_Retirement__c();
        rtm1.Employee_ID__c = '08000284';
        rtm1.Retirement_Date__c = Date.today();
        rtm1.Status__c = 'SendingToSAP';
        rtmList.add(rtm1);
        insert rtmList; 

        ESS_Master_Employee__c employee1 = new ESS_Master_Employee__c();
        employee1.Employee_ID__c = '00000001';
        employee1.Available_Room__c = 9; 
       	empList.add(employee1);
        
        ESS_Master_Employee__c employee2 = new ESS_Master_Employee__c();
        employee2.Employee_ID__c = '12345678';
        employee2.Available_Room__c = 44; 
        empList.add(employee2);

        ESS_Master_Employee__c employee3 = new ESS_Master_Employee__c();
        employee3.Employee_ID__c = '';
        employee3.Available_Room__c = 3; 
        empList.add(employee3);

        ESS_Master_Employee__c employee4 = new ESS_Master_Employee__c();
        employee4.Employee_ID__c = null;
        employee4.Available_Room__c = 3; 
        empList.add(employee4);

        ESS_Master_Employee__c employee5 = new ESS_Master_Employee__c();
        employee5.Employee_ID__c = '00000001';
        employee5.Available_Room__c = 3; 
        empList.add(employee5);
        

        insert empList; 
    }
    
    @isTest
    public static void testEmployeeHotelPostSuccess(){
        Test.startTest();
        ESSRESTOUTEmpHtlCtrl.ResponseWrapper result = ESSRESTOUTEmpHtlCtrl.EmployeeHotelPost();
        Test.stopTest();       
        System.assert(result != null,'List no data'); 
    }  
    
}