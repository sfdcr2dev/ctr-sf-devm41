@isTest
public class DocumentWrapper_Test {
    @TestSetup
    static void makeData(){
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given Sequiental Number and ContentDocumentLink
     * @when calling new DocumentWrapper
     * @then set class properties in construct
     */
    @isTest
    public static void testConstructor(){
        ContentDocumentLink mockCDL = getContentDocumentLink();
        Test.startTest();
            DocumentWrapper actual = new DocumentWrapper('42', mockCDL);
        Test.stopTest();

        System.assertEquals(
            '42',
            actual.sequentialNumber,
            'sequentialNumber should match the one we passed to the constructor'
        );
    }

    private static ContentDocumentLink getContentDocumentLink(){
        ContentDocument document = [SELECT Id FROM ContentDocument WHERE Title='Penguins'];

        return [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId=:document.Id LIMIT 1];
    }
}