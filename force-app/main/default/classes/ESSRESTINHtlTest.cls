@isTest
public class ESSRESTINHtlTest {
    @Testsetup
    public static void setupData()
    {
        List<ESS_Master_Employee__c> empList = new List<ESS_Master_Employee__c>();
        List<ESS_Application__c> appList = new List<ESS_Application__c>();
        List<ESS_Retirement__c> retirementList = new List<ESS_Retirement__c>();

        ESS_Application__c  essApp = new ESS_Application__c ( 
            Status__c = 'SendingToSAP',
            Completed_Date__c = null
        );
        appList.add(essApp);
        
        insert appList;
        
        /** re-check ExternalId__c again, 
         * if reponse from SAP has return externalId__c fields(Employee_ID__c + Application_Id__c)
         */
        ESS_Master_Employee__c essEmp = new ESS_Master_Employee__c( 
            Employee_ID__c = '00000001',
            Available_Room__c = null,
            ExternalId__c = null
        ); 
        empList.add(essEmp);
        
        ESS_Master_Employee__c essEmp2 = new ESS_Master_Employee__c( 
            Employee_ID__c = '00000002',
            Available_Room__c = null,
            ExternalId__c = null
        ); 
        empList.add(essEmp2);

        ESS_Master_Employee__c essEmp3 = new ESS_Master_Employee__c( 
            Employee_ID__c = '00000003',
            Available_Room__c = null,
            ExternalId__c = null
        ); 
        empList.add(essEmp3);

        ESS_Master_Employee__c essEmp4 = new ESS_Master_Employee__c( 
            Employee_ID__c = '12345678',
            Available_Room__c = null,
            ExternalId__c = null
        ); 
        empList.add(essEmp4);

        insert empList;
    }

    @isTest
    public static void testUpdateHotelPostSuccess(){
        String jsonSTR = '{'+
                            '"UpdateHotelWrapperList": ['
                                +'{'
                                    +'"employeeId": "00000001",'
                                    +'"checkOutDate": "2023-02-09",'
                                    +'"availableRoom": "58"'
                                +'},'
                                +'{'
                                    +'"employeeId": "00000002",'
                                    +'"checkOutDate": "2023-02-09",'
                                    +'"availableRoom": "66"'
                                +'},'
                                +'{'
                                    +'"employeeId": "12345678",'
                                    +'"checkOutDate": "2023-02-19",'
                                    +'"availableRoom": "4"'
                                +'},'
                                +'{'
                                    +'"employeeId": "00000003",'
                                    +'"checkOutDate": "2023-02-18",'
                                    +'"availableRoom": 33'
                                +'},'
                                +'{'
                                    +'"employeeId": "12345678",'
                                    +'"checkOutDate": "2023-02-11",'
                                    +'"availableRoom": "5"'
                                +'},'
                                +'{'
                                    +'"employeeId": "12345678",'
                                    +'"checkOutDate": "2023-02-20",'
                                    +'"availableRoom": "0"'
                                +'}'
                            +']'
                        +'}';

        Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String essJson= JSON.serialize(responseValue.get('UpdateHotelWrapperList')) ;
        List<ESSRESTINHtlCtrl.UpdateHotelWrapper>  updWrapperList = (List<ESSRESTINHtlCtrl.UpdateHotelWrapper>)JSON.deserialize(essJson, List<ESSRESTINHtlCtrl.UpdateHotelWrapper>.class);
        
        Test.startTest(); 
        ESSRESTINHtlCtrl.updateHotelPost(updWrapperList);
        Test.stopTest();
    }

    @isTest
    public static void testUpdateHotelPostFail(){

        String jsonSTR = '{'+
                        '"UpdateHotelWrapperList": ['
                        +'{'
                            +'"employeeId": "00000001",'
                            +'"checkOutDate": "2023-02-09",'
                            +'"availableRoom": "58"'
                        +'},'
                        +'{'
                            +'"employeeId": "00000002",'
                            +'"checkOutDate": "2023-02-09",'
                            +'"availableRoom": "66"'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-12",'
                            +'"availableRoom": "55555555555555"'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-21",'
                            +'"availableRoom": "55555555555555"'
                        +'},'
                        +'{'
                            +'"employeeId": "00000003",'
                            +'"checkOutDate": "2023-02-18",'
                            +'"availableRoom": 33'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-11",'
                            +'"availableRoom": "5"'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-20",'
                            +'"availableRoom": "0"'
                            +'}'
                        +']'
                    +'}';

        Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String essJson= JSON.serialize(responseValue.get('UpdateHotelWrapperList')) ;
        List<ESSRESTINHtlCtrl.UpdateHotelWrapper>  updWrapperList = (List<ESSRESTINHtlCtrl.UpdateHotelWrapper>)JSON.deserialize(essJson, List<ESSRESTINHtlCtrl.UpdateHotelWrapper>.class);
        
        Test.startTest(); 
        ESSRESTINHtlCtrl.updateHotelPost(updWrapperList);
        Test.stopTest();
    }

    @isTest
    public static void testUpdateHotelPostERR(){

        String jsonSTR = '{'+
                        '"UpdateHotelWrapperList": ['
                        +'{'
                            +'"employeeId": "00000001",'
                            +'"checkOutDate": "2023-02-09",'
                            +'"availableRoom": "58gjdyjtdjtdjtjfyjuyky"'
                        +'},'
                        +'{'
                            +'"employeeId": "00000002",'
                            +'"checkOutDate": "2023-02-09",'
                            +'"availableRoom": "66"'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-12",'
                            +'"availableRoom": "55555555555555"'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-21",'
                            +'"availableRoom": "hillhioloiygugiuygiyg"'
                        +'},'
                        +'{'
                            +'"employeeId": "00000003",'
                            +'"checkOutDate": "2023-02-18",'
                            +'"availableRoom": 33'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-11",'
                            +'"availableRoom": "5"'
                        +'},'
                        +'{'
                            +'"employeeId": "12345678",'
                            +'"checkOutDate": "2023-02-20",'
                            +'"availableRoom": "0"'
                            +'}'
                        +']'
                    +'}';

        Map<String, Object> responseValue = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        String essJson= JSON.serialize(responseValue.get('UpdateHotelWrapperList')) ;
        List<ESSRESTINHtlCtrl.UpdateHotelWrapper>  updWrapperList = (List<ESSRESTINHtlCtrl.UpdateHotelWrapper>)JSON.deserialize(essJson, List<ESSRESTINHtlCtrl.UpdateHotelWrapper>.class);
        
        Test.startTest(); 
        ESSRESTINHtlCtrl.updateHotelPost(updWrapperList);
        Test.stopTest();
    }
}