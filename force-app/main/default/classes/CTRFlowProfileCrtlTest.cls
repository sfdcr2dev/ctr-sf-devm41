@isTest
public without sharing class CTRFlowProfileCrtlTest {
    
    @isTest
    public static void Testfunction(){
        Test.startTest();
 	        CTRFlowProfileCrtl.FlowInputs fi = new CTRFlowProfileCrtl.FlowInputs();
    	    fi.mProfileName = 'System Administrator';
            CTRFlowProfileCrtl.function(new List<CTRFlowProfileCrtl.FlowInputs>{fi});
        Test.stopTest();
    }
}