/**
 * @author kaimook
 * @description test class for CaseTriggerHandler
 */
@isTest
public with sharing class CaseTriggerHandlerTest {
   
    @isTest
    static void testOPP_stampPISUerRequester() 
    {
        List<case> lst_c = [SELECT fields(standard) FROM Case Limit 2];
        Test.startTest();
        CaseTriggerHandler.OPP_stampPISUerRequester(lst_c);
        Test.stopTest();
    }
}