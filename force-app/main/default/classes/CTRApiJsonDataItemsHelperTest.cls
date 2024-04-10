@isTest
public  class CTRApiJsonDataItemsHelperTest {
    
    @isTest
    public static void testCTRApiJsonDataItemsHelper(){
        Test.startTest();
        CTRApiJsonDataItemsHelper jsonData = new CTRApiJsonDataItemsHelper();
        Map<String,String> tmp = new Map<String,String>();
        jsonData.add(tmp);

        List<Map<String,String>> result = jsonData.getList();
        Integer size = jsonData.size();
        Test.stopTest();

        System.assertEquals(1, result.size());
    }
}