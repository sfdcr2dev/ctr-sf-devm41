@isTest
public  class CTRApiJsonDataHelperTest {
    
    @isTest
    public static void testCTRApiJsonDataHelper(){
        Test.startTest();
        CTRApiJsonDataHelper jsonData = new CTRApiJsonDataHelper();
        Map<String,Object> tmp = new Map<String,Object>();
        jsonData.add(tmp);

        List<Map<String,Object>> result = jsonData.getList();
        Test.stopTest();

        System.assertEquals(1, result.size());
    }
}