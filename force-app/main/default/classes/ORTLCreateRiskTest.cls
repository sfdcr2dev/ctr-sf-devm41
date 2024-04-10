/**
 * ORTLCreateRiskTest used to test each method in ORTLCreateRiskCtrl
 * By the way Set up data or make some data like a real case
 * then call each method to test, if any method must have a parameter
 * you can query record and pass to those parameter,but they have to same type
 */
@isTest
public class ORTLCreateRiskTest {

    /**Set up data that like a real case */
    @Testsetup
    public static void setupData(){

        System.debug('--setupData--');

        /**User Object */
        User u = [SELECT id,Name FROM User WHERE id =: userInfo.getUserId()];
		System.debug('User=>'+u);

        /**Contact Object */
        Contact c = new Contact();
        c.FirstName = 'lastnameTest';
        c.LastName = 'firstnameTest';
        c.Phone = '0000000000';
        insert c;

        /**Functional Location Object */
        Functional_Location__c fl = new Functional_Location__c();
		fl.Name = 'Test FL';
		insert fl;

        /**Risk Object */
        ORTLRisk__c risk1 = new ORTLRisk__c();
        risk1.TagNo__c = fl.Id;
        risk1.RiskStatus__c = 'New';
        risk1.RiskInitiator__c = u.id;
        risk1.InitiativeDate__c = Date.today();
        risk1.AssessmentType__c = 'RRA (Reactive Risk Assessment)';
        risk1.OriginalRisk__c = null;
        //risk1.RiskScenario__c = 'TEST';
        //risk1.RiskScenarioDes__c = 'TEST';
        risk1.EnRiskMgt__c = 'Yes';
        risk1.DEM__c = 'Yes';
        risk1.ApptootherEQP__c = true;
        risk1.Causeoffailure__c = 'TEST';
        risk1.OwnerId = u.id;
        risk1.Threat__c = 'Equipment Frequent Failures';
        risk1.IntConsEffect__c = '"Bad Actor" Incident';
        insert risk1;
        System.debug('risk1 id =>'+ risk1.Id);
    }

    /**testRetrieveFL Method used to test retrieveFunctionalLocationById method on ORTLRiskCtrl */
    @isTest
    public static void testRetrieveFL(){
        ORTLRisk__c rs = [SELECT TagNo__c,TagNo__r.Name,APU__c,Discipline__c,Unit__c,PlantSection__c FROM ORTLRisk__c LIMIT 1];
        Test.startTest();
        Object rsfl1 = (Object) ORTLCreateRiskCtrl.getFunctionLocationDetail(rs.TagNo__c);
        Object rsfl2 = (Object) ORTLCreateRiskCtrl.retrieveFunctionalLocationById(rs.TagNo__c);
        Test.stopTest();
        System.assert(rsfl1 != null,'Not Expected Data');
        System.assert(rsfl2 != null,'Not Expected Data');
    }

    /**testCreateRisk Method used to test createRisk/getAddNewRisk/queryRiskRecords method on ORTLRiskCtrl */
    @isTest
    public static void testCreateRisk(){

        User u = [SELECT id,Name FROM User WHERE id =: userInfo.getUserId()];
        Functional_Location__c flRecords = [ SELECT Id,Name,Description__c,Planning_Plant__c,MainWorkCenter__c,mainWorkCenterPlant__c,mainWorkCenterPlant__r.Name,
                                            MainWorkCenter__r.Name,MainWorkCenter__r.Code__c,Location__c,PlantSection__c
                                            FROM Functional_Location__c
                                            WHERE Name = 'Test FL' LIMIT 1];

        ORTLRisk__c rs = [SELECT TagNo__r.Name,APU__c,Discipline__c,Unit__c,PlantSection__c FROM ORTLRisk__c];

        List<ORTLRisk__c> riskList = new List<ORTLRisk__c>();
        ORTLRisk__c risk1 = new ORTLRisk__c();
        risk1.TagNo__c = flRecords.Id;
        risk1.RiskStatus__c = 'New';
        risk1.RiskInitiator__c = u.id;
        risk1.InitiativeDate__c = Date.today();
        risk1.AssessmentType__c = 'RRA (Reactive Risk Assessment)';
        risk1.OriginalRisk__c = null;//riskRecords[0].Id;
        //risk1.RiskScenario__c = 'TEST';
        //risk1.RiskScenarioDes__c = 'TEST';
        risk1.EnRiskMgt__c = 'Yes';
        risk1.DEM__c = 'Yes';
        risk1.ApptootherEQP__c = true;
        risk1.Causeoffailure__c = 'TEST';
        risk1.OwnerId = u.id;
        risk1.Threat__c = 'Equipment Frequent Failures';
        risk1.IntConsEffect__c = '"Bad Actor" Incident';

        ORTLRisk__c risk2 = new ORTLRisk__c();
        risk2.TagNo__c = flRecords.Id;
        risk2.RiskStatus__c = 'New';
        risk2.RiskInitiator__c = u.id;
        risk2.InitiativeDate__c = Date.today();
        risk2.AssessmentType__c = 'RRA (Reactive Risk Assessment)';
        risk2.OriginalRisk__c = null;
        //risk2.RiskScenario__c = 'TEST';
        //risk2.RiskScenarioDes__c = 'TEST';
        risk2.EnRiskMgt__c = 'Yes';
        risk2.DEM__c = 'Yes';
        risk2.ApptootherEQP__c = true;
        risk2.Causeoffailure__c = 'TEST';
        risk2.OwnerId = u.id;
        risk2.Threat__c = 'Equipment Frequent Failures';
        risk2.IntConsEffect__c = null;
        riskList.add(risk2);

        List<String> tagNoList = new List<String>();
        tagNoList.add(risk1.TagNo__c);
        tagNoList.add(risk2.TagNo__c);
        Test.startTest();
        ORTLRisk__c newRisk = (ORTLRisk__c) ORTLCreateRiskCtrl.createRisk(risk1,tagNoList);
        Test.stopTest();
        System.assert(newRisk != null,'Not Expected Data');
    }
}