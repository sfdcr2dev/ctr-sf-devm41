@IsTest
public class ODM_PermitToWorkVerificationTest {
 @TestSetup
    static void makeData(){
         Work_Clearance__c wc = new Work_Clearance__c(
        	Name = '9012341234',
			Integration_Status__c = 'Success',
			System_Status__c = 'PREP',
			User_Status__c = 'WCCL',
            Area__c = 'P1',
            Work_Detail__c = 'Test',
            Safety_Permit1__c = 'Test',
            Safety_Permit2__c = 'Test',
            Safety_Permit3__c = 'Test',
            High_risk_work__c = '1'
        );
        insert wc;
		PTW_Question_Master__c ptwMaster = new PTW_Question_Master__c(
        	FormName__c = 'Verification',
            Version__c = '1',
            Question__c = '1',
            Section__c = '1',
            Order_Question__c = 1,
            Answer_type__c = 'Text',
            Value__c = 'Area ของ Work Clearance',
 			Description__c = 'Test',
            IsActive_Report__c = true
        );
        insert ptwMaster;

        PTW_Header__c ptwHeader = new PTW_Header__c(
        	FormName__c = 'Verification',
            Version__c = '1',
            Key__c = 'Key',
            Work_Clearance__c = wc.id,
            Status__c = 'Agree'
        );
        insert ptwHeader;
        
       
        insert new PTW_Answer__c(
            PTW_Header__c = ptwHeader.id,
            Key__c = 'Key',
            Question_Text__c = 'Area'
        );

        /*
        insert new PTW_Question_Master__c(
            FormName__c = 'Verification',
            Version__c = '1',
            Question__c = '1',
            Section__c = '1',
            Order_Question__c = 1,
            Answer_type__c = 'Text',
            Value__c = 'Area ของ Work Clearance',
 			Description__c = 'Test',
            IsActive_Report__c = true

        );
        insert new PTW_Header__c(
            FormName__c = 'Verification',
            Version__c = '1',
            Key__c = 'Key'
            
        );
        
        insert new PTW_Answer__c(
            PTW_Header__c = ptwHeader.id,
            Key__c = 'Key',
            Question_Text__c = 'Area'
        );
 		insert new Work_Clearance__c(
			Name = '9012341234',
			Integration_Status__c = 'Success',
			System_Status__c = 'PREP',
			User_Status__c = 'WCCL',
            Area__c = 'P1',
            Work_Clearance__c  = 'Test',
            Work_Detail__c = 'Test',
            Safety_Permit1__c = 'Test',
            Safety_Permit2__c = 'Test',
            Safety_Permit3__c = 'Test',
            High_risk_work__c = 'Hot Work'
		);
        */
        
    }
    
 	@IsTest
    static void testGetFormQuestions() {
		Test.startTest();
        
        List<Object> ptw = ODM_PermitToWorkVerification.getFormQuestions('1');
        List<Object> ptw2 = ODM_PermitToWorkVerification.getFormQuestions('');
        
        
        Test.stopTest();

    }
    @IsTest
    static void testGetFormAnswers() {
        
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE System_Status__c = 'PREP'LIMIT 1];
        System.debug('wc' + wc);

		Test.startTest();
        List<Object> ptwAnswer = ODM_PermitToWorkVerification.getFormAnswers(String.valueOf(wc.Id));
		System.debug('ptwAnswer' + ptwAnswer);

        Test.stopTest();

    }

    @IsTest
    static void testGetWorkClearanceDetail() {
		
        
        Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE System_Status__c = 'PREP'LIMIT 1];

		Test.startTest();
        List<Object> ptw = ODM_PermitToWorkVerification.getWorkClearanceDetail(String.valueOf(wc.Id));
        Test.stopTest();
       
    }
    
    @IsTest
    static void testGetSavePermitToWork() {
		Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE System_Status__c = 'PREP'LIMIT 1];
        PTW_Header__c ptwh = [SELECT Id FROM PTW_Header__c WHERE FormName__c = 'Verification' LIMIT 1];
		
        Test.startTest();
        
        String jsonAnswer = '';
 		String ptw = ODM_PermitToWorkVerification.savePermitToWork('{"HeaderId":"'+ptwh.id+'","WorkClearanceId":"'+wc.id+'","Version":"1","FormName":"Verification","Status":"Agree","Verification":[{"Id":"a1zN0000002QkpRIAS","Name":"PTWQ-0141","FormName__c":"Verification","Question__c":"Area (พื้นที่ปฏิบัติการ)","Section__c":"Permit to Work Verification","Order_Question__c":1,"Answer_type__c":"Text","Value__c":"Area ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpSIAS","Name":"PTWQ-0142","FormName__c":"Verification","Question__c":"Clearance No.","Section__c":"Permit to Work Verification","Order_Question__c":2,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test Status"},{"Id":"a1zN0000002QkpTIAS","Name":"PTWQ-0143","FormName__c":"Verification","Question__c":"Work detail (รายละเอียดการปฏิบัติงาน)","Section__c":"Permit to Work Verification","Order_Question__c":3,"Answer_type__c":"Text Area","Value__c":"Work Detail ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpUIAS","Name":"PTWQ-0144","FormName__c":"Verification","Question__c":"Safety Permit No.","Section__c":"Permit to Work Verification","Order_Question__c":4,"Answer_type__c":"Text","Value__c":"Safety permit ของ Work Clearance (กรณีมีมากกว่า 1 ใช้ Concatenate ด้วย)","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"1150,1112"},{"Id":"a1zN0000002QkpVIAS","Name":"PTWQ-0145","FormName__c":"Verification","Question__c":"High Risk Work Type","Section__c":"Permit to Work Verification","Order_Question__c":5,"Answer_type__c":"Picklist","Value__c":"Hot work, nConfined Space, nCrane, nRadiation, nJack Hammer, nHigh Pressure Water Jet, nDigging, nWork at High, nOnline Stop Leak","Version__c":"1","IsActive_Report__c":true,"Picklist":["Hot work"," nConfined Space"," nCrane"," nRadiation"," nJack Hammer"," nHigh Pressure Water Jet"," nDigging"," nWork at High"," nOnline Stop Leak"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Hot work"},{"Id":"a1zN0000002QkpWIAS","Name":"PTWQ-0146","FormName__c":"Verification","Question__c":"Working Area verification","Section__c":"Permit to Work Verification","Order_Question__c":6,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpXIAS","Name":"PTWQ-0147","FormName__c":"Verification","Question__c":"Equipment verification","Section__c":"Permit to Work Verification","Order_Question__c":7,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpYIAS","Name":"PTWQ-0148","FormName__c":"Verification","Question__c":"Person verification","Section__c":"Permit to Work Verification","Order_Question__c":8,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpZIAS","Name":"PTWQ-0149","FormName__c":"Verification","Question__c":"Name","Section__c":"Permit to Work Verification","Order_Question__c":9,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test name"},{"Id":"a1zN0000002QkpaIAC","Name":"PTWQ-0150","FormName__c":"Verification","Question__c":"Status","Section__c":"Permit to Work Verification","Order_Question__c":10,"Answer_type__c":"Picklist","Value__c":"Draft,Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Draft","Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpbIAC","Name":"PTWQ-0151","FormName__c":"Verification","Question__c":"Reason for Not Verified","Section__c":"Permit to Work Verification","Order_Question__c":11,"Answer_type__c":"Text Area","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":""}]}');
 		
        String ptw2 = ODM_PermitToWorkVerification.savePermitToWork('{"HeaderId":"","WorkClearanceId":"'+wc.id+'","Version":"1","FormName":"Verification","Status":"Agree","Verification":[{"Id":"a1zN0000002QkpRIAS","Name":"PTWQ-0141","FormName__c":"Verification","Question__c":"Area (พื้นที่ปฏิบัติการ)","Section__c":"Permit to Work Verification","Order_Question__c":1,"Answer_type__c":"Text","Value__c":"Area ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpSIAS","Name":"PTWQ-0142","FormName__c":"Verification","Question__c":"Clearance No.","Section__c":"Permit to Work Verification","Order_Question__c":2,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test Status"},{"Id":"a1zN0000002QkpTIAS","Name":"PTWQ-0143","FormName__c":"Verification","Question__c":"Work detail (รายละเอียดการปฏิบัติงาน)","Section__c":"Permit to Work Verification","Order_Question__c":3,"Answer_type__c":"Text Area","Value__c":"Work Detail ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpUIAS","Name":"PTWQ-0144","FormName__c":"Verification","Question__c":"Safety Permit No.","Section__c":"Permit to Work Verification","Order_Question__c":4,"Answer_type__c":"Text","Value__c":"Safety permit ของ Work Clearance (กรณีมีมากกว่า 1 ใช้ Concatenate ด้วย)","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"1150,1112"},{"Id":"a1zN0000002QkpVIAS","Name":"PTWQ-0145","FormName__c":"Verification","Question__c":"High Risk Work Type","Section__c":"Permit to Work Verification","Order_Question__c":5,"Answer_type__c":"Picklist","Value__c":"Hot work, nConfined Space, nCrane, nRadiation, nJack Hammer, nHigh Pressure Water Jet, nDigging, nWork at High, nOnline Stop Leak","Version__c":"1","IsActive_Report__c":true,"Picklist":["Hot work"," nConfined Space"," nCrane"," nRadiation"," nJack Hammer"," nHigh Pressure Water Jet"," nDigging"," nWork at High"," nOnline Stop Leak"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Hot work"},{"Id":"a1zN0000002QkpWIAS","Name":"PTWQ-0146","FormName__c":"Verification","Question__c":"Working Area verification","Section__c":"Permit to Work Verification","Order_Question__c":6,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpXIAS","Name":"PTWQ-0147","FormName__c":"Verification","Question__c":"Equipment verification","Section__c":"Permit to Work Verification","Order_Question__c":7,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpYIAS","Name":"PTWQ-0148","FormName__c":"Verification","Question__c":"Person verification","Section__c":"Permit to Work Verification","Order_Question__c":8,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpZIAS","Name":"PTWQ-0149","FormName__c":"Verification","Question__c":"Name","Section__c":"Permit to Work Verification","Order_Question__c":9,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test name"},{"Id":"a1zN0000002QkpaIAC","Name":"PTWQ-0150","FormName__c":"Verification","Question__c":"Status","Section__c":"Permit to Work Verification","Order_Question__c":10,"Answer_type__c":"Picklist","Value__c":"Draft,Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Draft","Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpbIAC","Name":"PTWQ-0151","FormName__c":"Verification","Question__c":"Reason for Not Verified","Section__c":"Permit to Work Verification","Order_Question__c":11,"Answer_type__c":"Text Area","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":""}]}');

        Test.stopTest();
    }
    
     @IsTest
    static void testGetSubmitPermitToWork() {
		Work_Clearance__c wc = [SELECT Id FROM Work_Clearance__c WHERE System_Status__c = 'PREP'LIMIT 1];
        PTW_Header__c ptwh = [SELECT Id FROM PTW_Header__c WHERE FormName__c = 'Verification' LIMIT 1];
            
		Test.startTest();
 		String ptw = ODM_PermitToWorkVerification.submitPermitToWork('{"HeaderId":"'+ptwh.id+'","WorkClearanceId":"'+wc.id+'","Version":"1","FormName":"Verification","Status":"Agree","Verification":[{"Id":"a1zN0000002QkpRIAS","Name":"PTWQ-0141","FormName__c":"Verification","Question__c":"Area (พื้นที่ปฏิบัติการ)","Section__c":"Permit to Work Verification","Order_Question__c":1,"Answer_type__c":"Text","Value__c":"Area ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpSIAS","Name":"PTWQ-0142","FormName__c":"Verification","Question__c":"Clearance No.","Section__c":"Permit to Work Verification","Order_Question__c":2,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test Status"},{"Id":"a1zN0000002QkpTIAS","Name":"PTWQ-0143","FormName__c":"Verification","Question__c":"Work detail (รายละเอียดการปฏิบัติงาน)","Section__c":"Permit to Work Verification","Order_Question__c":3,"Answer_type__c":"Text Area","Value__c":"Work Detail ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpUIAS","Name":"PTWQ-0144","FormName__c":"Verification","Question__c":"Safety Permit No.","Section__c":"Permit to Work Verification","Order_Question__c":4,"Answer_type__c":"Text","Value__c":"Safety permit ของ Work Clearance (กรณีมีมากกว่า 1 ใช้ Concatenate ด้วย)","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"1150,1112"},{"Id":"a1zN0000002QkpVIAS","Name":"PTWQ-0145","FormName__c":"Verification","Question__c":"High Risk Work Type","Section__c":"Permit to Work Verification","Order_Question__c":5,"Answer_type__c":"Picklist","Value__c":"Hot work, nConfined Space, nCrane, nRadiation, nJack Hammer, nHigh Pressure Water Jet, nDigging, nWork at High, nOnline Stop Leak","Version__c":"1","IsActive_Report__c":true,"Picklist":["Hot work"," nConfined Space"," nCrane"," nRadiation"," nJack Hammer"," nHigh Pressure Water Jet"," nDigging"," nWork at High"," nOnline Stop Leak"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Hot work"},{"Id":"a1zN0000002QkpWIAS","Name":"PTWQ-0146","FormName__c":"Verification","Question__c":"Working Area verification","Section__c":"Permit to Work Verification","Order_Question__c":6,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpXIAS","Name":"PTWQ-0147","FormName__c":"Verification","Question__c":"Equipment verification","Section__c":"Permit to Work Verification","Order_Question__c":7,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpYIAS","Name":"PTWQ-0148","FormName__c":"Verification","Question__c":"Person verification","Section__c":"Permit to Work Verification","Order_Question__c":8,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpZIAS","Name":"PTWQ-0149","FormName__c":"Verification","Question__c":"Name","Section__c":"Permit to Work Verification","Order_Question__c":9,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test name"},{"Id":"a1zN0000002QkpaIAC","Name":"PTWQ-0150","FormName__c":"Verification","Question__c":"Status","Section__c":"Permit to Work Verification","Order_Question__c":10,"Answer_type__c":"Picklist","Value__c":"Draft,Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Draft","Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpbIAC","Name":"PTWQ-0151","FormName__c":"Verification","Question__c":"Reason for Not Verified","Section__c":"Permit to Work Verification","Order_Question__c":11,"Answer_type__c":"Text Area","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":""}]}');
        String ptw2 = ODM_PermitToWorkVerification.submitPermitToWork('{"HeaderId":"","WorkClearanceId":"'+wc.id+'","Version":"1","FormName":"Verification","Status":"Agree","Verification":[{"Id":"a1zN0000002QkpRIAS","Name":"PTWQ-0141","FormName__c":"Verification","Question__c":"Area (พื้นที่ปฏิบัติการ)","Section__c":"Permit to Work Verification","Order_Question__c":1,"Answer_type__c":"Text","Value__c":"Area ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpSIAS","Name":"PTWQ-0142","FormName__c":"Verification","Question__c":"Clearance No.","Section__c":"Permit to Work Verification","Order_Question__c":2,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test Status"},{"Id":"a1zN0000002QkpTIAS","Name":"PTWQ-0143","FormName__c":"Verification","Question__c":"Work detail (รายละเอียดการปฏิบัติงาน)","Section__c":"Permit to Work Verification","Order_Question__c":3,"Answer_type__c":"Text Area","Value__c":"Work Detail ของ Work Clearance","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":" "},{"Id":"a1zN0000002QkpUIAS","Name":"PTWQ-0144","FormName__c":"Verification","Question__c":"Safety Permit No.","Section__c":"Permit to Work Verification","Order_Question__c":4,"Answer_type__c":"Text","Value__c":"Safety permit ของ Work Clearance (กรณีมีมากกว่า 1 ใช้ Concatenate ด้วย)","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"1150,1112"},{"Id":"a1zN0000002QkpVIAS","Name":"PTWQ-0145","FormName__c":"Verification","Question__c":"High Risk Work Type","Section__c":"Permit to Work Verification","Order_Question__c":5,"Answer_type__c":"Picklist","Value__c":"Hot work, nConfined Space, nCrane, nRadiation, nJack Hammer, nHigh Pressure Water Jet, nDigging, nWork at High, nOnline Stop Leak","Version__c":"1","IsActive_Report__c":true,"Picklist":["Hot work"," nConfined Space"," nCrane"," nRadiation"," nJack Hammer"," nHigh Pressure Water Jet"," nDigging"," nWork at High"," nOnline Stop Leak"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Hot work"},{"Id":"a1zN0000002QkpWIAS","Name":"PTWQ-0146","FormName__c":"Verification","Question__c":"Working Area verification","Section__c":"Permit to Work Verification","Order_Question__c":6,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpXIAS","Name":"PTWQ-0147","FormName__c":"Verification","Question__c":"Equipment verification","Section__c":"Permit to Work Verification","Order_Question__c":7,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpYIAS","Name":"PTWQ-0148","FormName__c":"Verification","Question__c":"Person verification","Section__c":"Permit to Work Verification","Order_Question__c":8,"Answer_type__c":"Picklist","Value__c":"Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpZIAS","Name":"PTWQ-0149","FormName__c":"Verification","Question__c":"Name","Section__c":"Permit to Work Verification","Order_Question__c":9,"Answer_type__c":"Text","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Test name"},{"Id":"a1zN0000002QkpaIAC","Name":"PTWQ-0150","FormName__c":"Verification","Question__c":"Status","Section__c":"Permit to Work Verification","Order_Question__c":10,"Answer_type__c":"Picklist","Value__c":"Draft,Agree,Disagree","Version__c":"1","IsActive_Report__c":true,"Picklist":["Draft","Agree","Disagree"],"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":"Agree"},{"Id":"a1zN0000002QkpbIAC","Name":"PTWQ-0151","FormName__c":"Verification","Question__c":"Reason for Not Verified","Section__c":"Permit to Work Verification","Order_Question__c":11,"Answer_type__c":"Text Area","Version__c":"1","IsActive_Report__c":true,"PTW_Header__c":"a20N0000002WIakIAG","Answer__c":""}]}');

        Test.stopTest();
    }
}