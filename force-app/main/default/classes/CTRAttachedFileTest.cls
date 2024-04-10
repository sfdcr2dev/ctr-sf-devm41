@isTest
public class CTRAttachedFileTest {
   
    @isTest
    public static void testAttachedFile(){
        Test.startTest();
        CTRAttachedFile.attachedFile(new List<String>{'Title Test'});
        Test.stopTest();
    }

    @isTest
    public static void testUploadFile(){
        List<Object> fileList = new List<Object>();
        Map<String, Object> file1 = new Map<String, Object>{'Title' => 'File 1'};
        Map<String, Object> file2 = new Map<String, Object>{'Title' => 'File 2'};
        fileList.add(file1);
        fileList.add(file2);

        Test.startTest();
        String result = CTRAttachedFile.uploadFiles(fileList);
        Test.stopTest();

        System.assertEquals('Files uploaded successfully', result);
    }

    @isTest
    public static void testProcessFile(){
        List<ContentVersion> files = new List<ContentVersion>();
        String title = 'Title';

        Test.startTest();
        String result = CTRAttachedFile.processFiles(files,title);
        Test.stopTest();

        System.assertEquals('Files processed successfully!', result);
    }
}