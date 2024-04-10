@isTest
public class THOR_Replication_SafetyPermitTest {

    @TestSetup
    static void makeData(){
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        List<Master_Map__c> masterMaps = new List<Master_Map__c>();

        Master_Map__c plant = new Master_Map__c();
        plant.Code__c = '1200';
        plant.Name = '1200';
        plant.Type__c = 'Plant';
        plant.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c area = new Master_Map__c();
        area.Code__c = 'P1';
        area.Name = 'P1';
        area.Description__c = 'PROCESS1';
        area.Type__c = 'Plant Section';
        area.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c codeGroupOfFaultCode = new Master_Map__c();
        codeGroupOfFaultCode.Code__c = 'IEF-028';
        codeGroupOfFaultCode.Name = 'IEF-028';
        codeGroupOfFaultCode.Type__c = 'Code Group';
        codeGroupOfFaultCode.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c objectPart = new Master_Map__c();
        objectPart.Code__c = 'B';
        objectPart.Name = 'B';
        objectPart.Type__c = 'Object Part';
        objectPart.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c mainWorkCenter = new Master_Map__c();
        mainWorkCenter.Code__c = 'ENMA-I';
        mainWorkCenter.Name = 'ENMA-I';
        mainWorkCenter.Type__c = 'Main Work Center';
        mainWorkCenter.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c faultCode = new Master_Map__c();
        faultCode.Code__c = 'E02';
        faultCode.Name = 'E02';
        faultCode.Type__c = 'FaultCode';
        faultCode.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c pmActivity = new Master_Map__c();
        pmActivity.Code__c = 'M01';
        pmActivity.Name = 'M01';
        pmActivity.Type__c = 'MaintActivityType';
        pmActivity.Master_Map_Set__c = masterMapSet.Id;
/** 
        Master_Map__c plantsection = new Master_Map__c();
        plantsection.Code__c = 'UT';
        plantsection.Name = 'UT';
        plantsection.Type__c = 'plantsection';
        plantsection.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c workdetail = new Master_Map__c();
        workdetail.Code__c = '';
        workdetail.Name = '';
        workdetail.Type__c = 'workdetail';
        workdetail.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c permitdescription = new Master_Map__c();
        permitdescription.Code__c = 'Threading machine';
        permitdescription.Name = 'Threading machine';
        permitdescription.Type__c = 'permitdescription';
        permitdescription.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c bearer1 = new Master_Map__c();
        bearer1.Code__c = 'B-190012';
        bearer1.Name = 'B-190012';
        bearer1.Type__c = 'bearer1';
        bearer1.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c bearer2 = new Master_Map__c();
        bearer2.Code__c = 'B-190011';
        bearer2.Name = 'B-190011';
        bearer2.Type__c = 'bearer2';
        bearer2.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c noncereq = new Master_Map__c();
        // noncereq.Code__c = true;
        // noncereq.Name = true;
        noncereq.Type__c = 'noncereq';
        noncereq.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c externalae = new Master_Map__c();
        externalae.Code__c = '';
        externalae.Name = '';
        externalae.Type__c = 'externalae';
        externalae.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c ae1 = new Master_Map__c();
        ae1.Code__c = '807';
        ae1.Name = '807';
        ae1.Type__c = 'ae1';
        ae1.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c ae2 = new Master_Map__c();
        ae2.Code__c = '807';
        ae2.Name = '807';
        ae2.Type__c = 'ae2';
        ae2.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c agsi1 = new Master_Map__c();
        agsi1.Code__c = '531';
        agsi1.Name = '531';
        agsi1.Type__c = 'agsi1';
        agsi1.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c agsi2 = new Master_Map__c();
        agsi2.Code__c = '1512';
        agsi2.Name = '1512';
        agsi2.Type__c = 'agsi2';
        agsi2.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c ram = new Master_Map__c();
        ram.Code__c = 'M';
        ram.Name = 'M';
        ram.Type__c = 'ram';
        ram.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c extendcertificate = new Master_Map__c();
        extendcertificate.Code__c = '2';
        extendcertificate.Name = '2';
        extendcertificate.Type__c = 'extendcertificate';
        extendcertificate.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c permittoworkdate = new Master_Map__c();
        permittoworkdate.Code__c = '2020-07-08';
        permittoworkdate.Name = '2020-07-08';
        permittoworkdate.Type__c = 'permittoworkdate';
        permittoworkdate.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c expireddate1 = new Master_Map__c();
        expireddate1.Code__c = '0000-00-00';
        expireddate1.Name = '0000-00-00';
        expireddate1.Type__c = 'permittoworkdate';
        expireddate1.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c expireddate2 = new Master_Map__c();
        expireddate2.Code__c = '0000-00-00';
        expireddate2.Name = '0000-00-00';
        expireddate2.Type__c = 'expireddate2';
        expireddate2.Master_Map_Set__c = masterMapSet.Id;

        Master_Map__c expireddate3 = new Master_Map__c();
        expireddate3.Code__c = '0000-00-00';
        expireddate3.Name = '0000-00-00';
        expireddate3.Type__c = 'expireddate3';
        expireddate3.Master_Map_Set__c = masterMapSet.Id;
*/
        masterMaps.add(plant);
        masterMaps.add(area);
        masterMaps.add(codeGroupOfFaultCode);
        masterMaps.add(objectPart);
        masterMaps.add(mainWorkCenter);
        masterMaps.add(faultCode);
        masterMaps.add(pmActivity);
        // masterMaps.add(plantsection);
        // masterMaps.add(workdetail);
        // masterMaps.add(permitdescription);
        // masterMaps.add(bearer1);
        // masterMaps.add(bearer2);
        // masterMaps.add(noncereq);
        // masterMaps.add(externalae);
        // masterMaps.add(ae1);
        // masterMaps.add(ae2);
        // masterMaps.add(agsi1);
        // masterMaps.add(agsi2);
        // masterMaps.add(ram);
        // masterMaps.add(extendcertificate);
        // masterMaps.add(permittoworkdate);
        // masterMaps.add(expireddate1);
        // masterMaps.add(expireddate2);
        // masterMaps.add(expireddate3);
        insert masterMaps;

        Functional_Location__c fl = new Functional_Location__c();
        fl.Name = 'TPX-76-LG-033B';
        fl.MainWorkCenter__c = mainWorkCenter.Id;
        fl.mainWorkCenterPlant__c = plant.Id;
        insert fl;

        Equipment__c equipment = new Equipment__c();
        equipment.Name = '10009516';
        insert equipment;

        PISUsers__c pisuser = new PISUsers__c();
        pisuser.User__c = UserInfo.getUserId();
        pisuser.Name = 'Integration R2';
        pisuser.ENFIRSTNAME__c = 'Integration';
        pisuser.ENLASTNAME__c = 'R2';
        pisuser.THFIRSTNAME__c = 'Integration';
        pisuser.THLASTNAME__c = 'R2';
        pisuser.EMPLOYEEID__c = 'R2-00001';
        pisuser.DEPARTMENT__c = '001';
        pisuser.ORGID__c = '';
        // pisuser.HOST_ID__c = '00000489';
        // pisuser.HOME_ID__c = '00000489';
        insert pisuser;

        THOR_Applicant_Bearer__c applicantBearer = new THOR_Applicant_Bearer__c();
        applicantBearer.Name = 'Dummy Bearer 001';
        applicantBearer.Code__c = 'B-180214';
        applicantBearer.Applicant_ID__c = '10004011';
        applicantBearer.Description__c = 'Dummy Bearer 001';
        applicantBearer.Main_Work_Center_Plant__c = plant.id;
        applicantBearer.Person_Responsible__c = '001';
        insert applicantBearer;
    }

    @isTest
    static void testHttpPost_Replication_NotFoundEndPoint() {
        RestRequest req = new RestRequest();

        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/THOR_Replicated/NotFoundEndpoint';
        req.requestBody = Blob.valueof(
            JSON.serialize(
                new Map<String, Object>{
                    'gateway_id' => '1',
                    // 'body' => '{ \"SAFETYPEMITS\": [ { \"SAFETYPERMITNUMBER\": \"300024001\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, { \"SAFETYPERMITNUMBER\": \"300024002\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, { \"SAFETYPERMITNUMBER\": \"300024003\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1201\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, { \"SAFETYPERMITNUMBER\": \"300024004\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"UNKNOWN\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, { \"SAFETYPERMITNUMBER\": \"300024005\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00002\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" } ] }'
                    'body' => '{ \"SAFETYPEMITS\": [ { \"SAFETYPERMITNUMBER\": \"300024001\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"L\", \"EXTTYP\": \"1\", \"PERMITTOWORK\": \"20220908\", \"EXT_1T\": \"20220908\", \"EXT_2T\": \"20220908\", \"EXT_3T\": \"20220908\" }'
                                                    +',{ \"SAFETYPERMITNUMBER\": \"300024002\", \"APPROVALSTATUS\": 1, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"\", \"PARTNER\": \"489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"M\", \"EXTTYP\": \"2\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"2022-09-08\" }'
                                                    +',{ \"SAFETYPERMITNUMBER\": \"300024003\", \"APPROVALSTATUS\": 1, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"\", \"PARTNER\": \"489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"t\", \"EXTAE\": \"Testttttttttt\", \"AE1\": \"Testtttttttttttttt\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": 1, \"RAM\": \"M\", \"EXTTYP\": \"2\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"2022-09-08\" } ] }'
                }
            )
        );
        RestContext.request = req;

        RestResponse res = new RestResponse();
        res.responseBody = Blob.valueOf('{ \"description\": { \"success\": false, \"message\": \"\", \"linkurl\": null }, \"returnvalue\": [ { \"sfid\": \"a1l9D000001F2K8QAK\", \"messagetype\": \"S\", \"messagetext\": \"success\", \"gateway_id\": \"1\", \"documentnumber\": \"300024001\" }, { \"sfid\": \"a1l9D000001F2K9QAK\", \"messagetype\": \"S\", \"messagetext\": \"success\", \"gateway_id\": \"1\", \"documentnumber\": \"300024002\" }, { \"sfid\": \"a1l9D000001F2K9QAL\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Planning Plan not found not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024003\" }, { \"sfid\": \"a1l9D000001F2K9QAM\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Functional Location not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024004\" }, { \"sfid\": \"a1l9D000001F2K9QAN\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Partner not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024005\" } ] }');
        RestContext.response = res;

        Test.startTest();
        THOR_ReplicationWebServices.httpPostWebservice();
        Test.stopTest();
    }

    @isTest
    static void testHttpPost_Replication_SafetyPermitJSON() {
        RestRequest req = new RestRequest();

        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/THOR_Replicated/SafetyPermit';
        req.requestBody = Blob.valueof(
            JSON.serialize(
                new Map<String, Object>{
                    'gateway_id' => '1',
                    // 'body' => '{ \"SAFETYPEMITS\": [ { \"SAFETYPERMITNUMBER\": \"300024001\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, 
                                                        //{ \"SAFETYPERMITNUMBER\": \"300024002\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, 
                                                        //{ \"SAFETYPERMITNUMBER\": \"300024003\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1201\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, 
                                                        //{ \"SAFETYPERMITNUMBER\": \"300024004\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"UNKNOWN\", \"PARTNER\": \"R2-00001\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" }, 
                                                        //{ \"SAFETYPERMITNUMBER\": \"300024005\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"R2-00002\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" } 
                                                        //] }'

                    
                    'body' => '{ \"SAFETYPEMITS\": [ { \"SAFETYPERMITNUMBER\": \"300024001\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"L\", \"EXTTYP\": \"1\", \"PERMITTOWORK\": \"20220908\", \"EXT_1T\": \"20220908\", \"EXT_2T\": \"20220908\", \"EXT_3T\": \"20220908\" }'
                                                    +',{ \"SAFETYPERMITNUMBER\": \"300024002\", \"APPROVALSTATUS\": 1, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"\", \"PARTNER\": \"489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"M\", \"EXTTYP\": \"2\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"2022-09-08\" }'
                                                    +',{ \"SAFETYPERMITNUMBER\": \"300024003\", \"APPROVALSTATUS\": 1, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"\", \"PARTNER\": \"489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": 1, \"NONCEREQ\": \"t\", \"EXTAE\": \"Testttttttttt\", \"AE1\": \"Testtttttttttttttt\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": 1, \"RAM\": \"M\", \"EXTTYP\": \"2\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"2022-09-08\" } ] }'


                }
            )
        );
        RestContext.request = req;
		system.debug('req---'+JSON.serialize(
                new Map<String, Object>{
                    'gateway_id' => '1',
                    'body' => '{ \"SAFETYPEMITS\": [ { \"SAFETYPERMITNUMBER\": \"300024001\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"00000489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"L\", \"EXTTYP\": \"1\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"\"}'
                                                    +', { \"SAFETYPERMITNUMBER\": \"300024002\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"00000489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"L\", \"EXTTYP\": \"1\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"\"}'
                                                    +', { \"SAFETYPERMITNUMBER\": \"300024003\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1201\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"00000489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"L\", \"EXTTYP\": \"1\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"\"}'
                                                    +', { \"SAFETYPERMITNUMBER\": \"300024004\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"UNKNOWN\", \"PARTNER\": \"00000489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\" , \"PLANTSECTION\": \"\", \"WORKDETAIL\": \"\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"\", \"BEARER2\": \"\", \"NONCEREQ\": \"\", \"EXTAE\": \"\", \"AE1\": \"\", \"AEAPU\": \"\", \"AGSI\": \"\", \"AGSI2\": \"\", \"\": \"\", \"EXTTYP\": \"\", \"PERMITTOWORK\": \"\", \"EXT_1T\": \"\", \"EXT_2T\": \"\", \"EXT_3T\": \"\"}'
                                                    +', { \"SAFETYPERMITNUMBER\": \"300024005\", \"APPROVALSTATUS\": 0, \"PLANNINGPLANT\": \"1200\", \"TYPEOFWCMOBJECT\": \"2\", \"FUNCTIONALLOCATION\": \"TPX-76-LG-033B\", \"PARTNER\": \"00000489\", \"PLANNERGROUP\": \"\", \"MAINWORKCENTER\": \"\", \"MAINWORKCENTERPLANT\": \"\", \"PLANTSECTION\": \"Tes\", \"WORKDETAIL\": \"Test\", \"PERMITDESC\": \"Test\",\"BEARER1\": \"Test\", \"BEARER2\": \"Test\", \"NONCEREQ\": \"true\", \"EXTAE\": \"Test\", \"AE1\": \"Test\", \"AEAPU\": \"Test\", \"AGSI\": \"Test\", \"AGSI2\": \"Test\", \"RAM\": \"L\", \"EXTTYP\": \"1\", \"PERMITTOWORK\": \"2022-09-08\", \"EXT_1T\": \"2022-09-08\", \"EXT_2T\": \"2022-09-08\", \"EXT_3T\": \"\"} ] }'
                }
            ));
        RestResponse res = new RestResponse();
        res.responseBody = Blob.valueOf('{ \"description\": { \"success\": false, \"message\": \"\", \"linkurl\": null }, \"returnvalue\": [ { \"sfid\": \"a1l9D000001F2K8QAK\", \"messagetype\": \"S\", \"messagetext\": \"success\", \"gateway_id\": \"1\", \"documentnumber\": \"300024001\" }, { \"sfid\": \"a1l9D000001F2K9QAK\", \"messagetype\": \"S\", \"messagetext\": \"success\", \"gateway_id\": \"1\", \"documentnumber\": \"300024002\" }, { \"sfid\": \"a1l9D000001F2K9QAL\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Planning Plan not found not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024003\" }, { \"sfid\": \"a1l9D000001F2K9QAM\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Functional Location not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024004\" }, { \"sfid\": \"a1l9D000001F2K9QAN\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Partner not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024005\" } ] }');
        RestContext.response = res;

        Test.startTest();
        THOR_ReplicationWebServices.httpPostWebservice();
        Test.stopTest();
    }
    
    @isTest
    static void testHttpPost_Replication_SafetyPermitXML() {
        RestRequest req = new RestRequest();

        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/THOR_Replicated/SafetyPermit';
        req.requestBody = Blob.valueof(
            JSON.serialize(
                new Map<String, Object>{
                    'gateway_id' => '1',
                    // 'body' => '<safetypermits><safetypermit><safetypermitnumber>300024001</safetypermitnumber><approvalstatus>0</approvalstatus><planningplant>1200</planningplant><typeofwcmobject>2</typeofwcmobject><functionallocation>TPX-76-LG-033B</functionallocation><partner>R2-00001</partner><plannergroup></plannergroup><mainworkcenter></mainworkcenter><mainworkcenterplant></mainworkcenterplant></safetypermit><safetypermit><safetypermitnumber>300024002</safetypermitnumber><approvalstatus>0</approvalstatus><planningplant>1200</planningplant><typeofwcmobject>2</typeofwcmobject><functionallocation>TPX-76-LG-033B</functionallocation><partner>R2-00001</partner><plannergroup></plannergroup><mainworkcenter></mainworkcenter><mainworkcenterplant></mainworkcenterplant></safetypermit><safetypermit><safetypermitnumber>300024003</safetypermitnumber><approvalstatus>0</approvalstatus><planningplant>1201</planningplant><typeofwcmobject>2</typeofwcmobject><functionallocation>TPX-76-LG-033B</functionallocation><partner>R2-00001</partner><plannergroup></plannergroup><mainworkcenter></mainworkcenter><mainworkcenterplant></mainworkcenterplant></safetypermit><safetypermit><safetypermitnumber>300024004</safetypermitnumber><approvalstatus>0</approvalstatus><planningplant>1200</planningplant><typeofwcmobject>2</typeofwcmobject><functionallocation>UNKNOWN</functionallocation><partner>R2-00001</partner><plannergroup></plannergroup><mainworkcenter></mainworkcenter><mainworkcenterplant></mainworkcenterplant></safetypermit><safetypermit><safetypermitnumber>300024005</safetypermitnumber><approvalstatus>0</approvalstatus><planningplant>1200</planningplant><typeofwcmobject>2</typeofwcmobject><functionallocation>TPX-76-LG-033B</functionallocation><partner>R2-00002</partner><plannergroup></plannergroup><mainworkcenter></mainworkcenter><mainworkcenterplant></mainworkcenterplant></safetypermit></safetypermits>'
                    'body' => '<safetypermits>'+
                        '<safetypermit>'+
                            '<safetypermitnumber>300024001</safetypermitnumber>'+
                            '<approvalstatus>0</approvalstatus>'+
                            '<planningplant>1200</planningplant>'+
                            '<typeofwcmobject>2</typeofwcmobject>'+
                            '<functionallocation>TPX-76-LG-033B</functionallocation>'+
                            '<partner>489</partner>'+
                            '<plannergroup></plannergroup>'+
                            '<mainworkcenter></mainworkcenter>'+
                            '<mainworkcenterplant></mainworkcenterplant>'+
                            '<plantsection>Tes</plantsection>'+
                            '<workdetail>Test</workdetail>'+
                            '<permitdescription>Test</permitdescription>'+
                            '<bearer1>Test</bearer1>'+
                            '<bearer2>Test</bearer2>'+
                            '<noncereq>true</noncereq>'+
                            '<externalae>Test</externalae>'+
                            '<ae1>Test</ae1>'+
                            '<ae2>Test</ae2>'+
                            '<agsi1>Test</agsi1>'+
                            '<agsi2>Test</agsi2>'+
                            '<ram>L</ram>'+
                            '<extendcertificate>1</extendcertificate>'+
                            '<permittoworkdate></permittoworkdate>'+
                            '<expireddate1>2022-09-08</expireddate1>'+
                            '<expireddate2>2022-09-08</expireddate2>'+
                            '<expireddate3>2022-09-08</expireddate3>'+
                        '</safetypermit>'+
                        '<safetypermit>'+
                            '<safetypermitnumber>300024002</safetypermitnumber>'+
                            '<approvalstatus>0</approvalstatus>'+
                            '<planningplant>1200</planningplant>'+
                            '<typeofwcmobject>2</typeofwcmobject>'+
                            '<functionallocation>TPX-76-LG-033B</functionallocation>'+
                            '<partner>489</partner>'+
                            '<plannergroup></plannergroup>'+
                            '<mainworkcenter></mainworkcenter>'+
                            '<mainworkcenterplant></mainworkcenterplant>'+
                            '<plantsection>111</plantsection>'+
                            '<workdetail>Test</workdetail>'+
                            '<permitdescription>Test</permitdescription>'+
                            '<bearer1>Test</bearer1>'+
                            '<bearer2>Test</bearer2>'+
                            '<noncereq>false</noncereq>'+
                            '<externalae>Test</externalae>'+
                            '<ae1>Test</ae1>'+
                            '<ae2>Test</ae2>'+
                            '<agsi1>Test</agsi1>'+
                            '<agsi2>Test</agsi2>'+
                            '<ram>M</ram>'+
                            '<extendcertificate>2</extendcertificate>'+
                            '<permittoworkdate></permittoworkdate>'+
                            '<expireddate1>2022-09-08</expireddate1>'+
                            '<expireddate2>2022-09-08</expireddate2>'+
                            '<expireddate3>2022-09-08</expireddate3>'+
                        '</safetypermit>'+
                        '<safetypermit>'+
                            '<safetypermitnumber>300024003</safetypermitnumber>'+
                            '<approvalstatus>0</approvalstatus>'+
                            '<planningplant>1201</planningplant>'+
                            '<typeofwcmobject>2</typeofwcmobject>'+
                            '<functionallocation>TPX-76-LG-033B</functionallocation>'+
                            '<partner>489</partner>'+
                            '<plannergroup></plannergroup>'+
                            '<mainworkcenter></mainworkcenter>'+
                            '<mainworkcenterplant></mainworkcenterplant>'+
                            '<plantsection>Tes</plantsection>'+
                            '<workdetail>Test</workdetail>'+
                            '<permitdescription>Test</permitdescription>'+
                            '<bearer1>Test</bearer1>'+
                            '<bearer2>Test</bearer2>'+
                            '<noncereq>true</noncereq>'+
                            '<externalae>Test</externalae>'+
                            '<ae1>Test</ae1>'+
                            '<ae2>Test</ae2>'+
                            '<agsi1>Test</agsi1>'+
                            '<agsi2>Test</agsi2>'+
                            '<ram>H</ram>'+
                            '<extendcertificate>3</extendcertificate>'+
                            '<permittoworkdate></permittoworkdate>'+
                            '<expireddate1>2022-09-08</expireddate1>'+
                            '<expireddate2>2022-09-08</expireddate2>'+
                            '<expireddate3>2022-09-08</expireddate3>'+
                        '</safetypermit>'+
                        '<safetypermit>'+
                            '<safetypermitnumber>300024004</safetypermitnumber>'+
                            '<approvalstatus>0</approvalstatus>'+
                            '<planningplant>1200</planningplant>'+
                            '<typeofwcmobject>2</typeofwcmobject>'+
                            '<functionallocation>UNKNOWN</functionallocation>'+
                            '<partner>489</partner>'+
                            '<plannergroup></plannergroup>'+
                            '<mainworkcenter></mainworkcenter>'+
                            '<mainworkcenterplant></mainworkcenterplant>'+
                            '<plantsection>Tes</plantsection>'+
                            '<workdetail>Test</workdetail>'+
                            '<permitdescription>Test</permitdescription>'+
                            '<bearer1>Test</bearer1>'+
                            '<bearer2>Test</bearer2>'+
                            '<noncereq>true</noncereq>'+
                            '<externalae>Test</externalae>'+
                            '<ae1>Test</ae1>'+
                            '<ae2>Test</ae2>'+
                            '<agsi1>Test</agsi1>'+
                            '<agsi2>Test</agsi2>'+
                            '<ram>L</ram>'+
                            '<extendcertificate>1</extendcertificate>'+
                            '<permittoworkdate></permittoworkdate>'+
                            '<expireddate1>2022-09-08</expireddate1>'+
                            '<expireddate2>2022-09-08</expireddate2>'+
                            '<expireddate3>2022-09-08</expireddate3>'+
                        '</safetypermit>'+
                        '<safetypermit>'+
                            '<safetypermitnumber>300024005</safetypermitnumber>'+
                            '<approvalstatus>0</approvalstatus>'+
                            '<planningplant>1200</planningplant>'+
                            '<typeofwcmobject>2</typeofwcmobject>'+
                            '<functionallocation>TPX-76-LG-033B</functionallocation>'+
                            '<partner>R2-00002</partner>'+
                            '<plannergroup></plannergroup>'+
                            '<mainworkcenter></mainworkcenter>'+
                            '<mainworkcenterplant></mainworkcenterplant>'+
                            '<plantsection>Tes</plantsection>'+
                            '<workdetail>Test</workdetail>'+
                            '<permitdescription>Test</permitdescription>'+
                            '<bearer1>Test</bearer1>'+
                            '<bearer2>Test</bearer2>'+
                            '<noncereq>true</noncereq>'+
                            '<externalae>Test</externalae>'+
                            '<ae1>Test</ae1>'+
                            '<ae2>Test</ae2>'+
                            '<agsi1>Test</agsi1>'+
                            '<agsi2>Test</agsi2>'+
                            '<ram>L</ram>'+
                            '<extendcertificate>1</extendcertificate>'+
                            '<permittoworkdate></permittoworkdate>'+
                            '<expireddate1>2022-09-08</expireddate1>'+
                            '<expireddate2>2022-09-08</expireddate2>'+
                            '<expireddate3>2022-09-08</expireddate3>'+
                        '</safetypermit>'+
                    '</safetypermits>'

                }
            )
        );
        RestContext.request = req;

        RestResponse res = new RestResponse();
        res.responseBody = Blob.valueOf('{ \"description\": { \"success\": false, \"message\": \"\", \"linkurl\": null }, \"returnvalue\": [ { \"sfid\": \"a1l9D000001F2K8QAK\", \"messagetype\": \"S\", \"messagetext\": \"success\", \"gateway_id\": \"1\", \"documentnumber\": \"300024001\" }, { \"sfid\": \"a1l9D000001F2K9QAK\", \"messagetype\": \"S\", \"messagetext\": \"success\", \"gateway_id\": \"1\", \"documentnumber\": \"300024002\" }, { \"sfid\": \"a1l9D000001F2K9QAL\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Planning Plan not found not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024003\" }, { \"sfid\": \"a1l9D000001F2K9QAM\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Functional Location not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024004\" }, { \"sfid\": \"a1l9D000001F2K9QAN\", \"messagetype\": \"F\", \"messagetext\": \"Invalid Reference Value: Partner not found in Salesforce.\", \"gateway_id\": \"1\", \"documentnumber\": \"300024005\" } ] }');
        RestContext.response = res;

        Test.startTest();
        THOR_ReplicationWebServices.httpPostWebservice();
        Test.stopTest();
    }
}