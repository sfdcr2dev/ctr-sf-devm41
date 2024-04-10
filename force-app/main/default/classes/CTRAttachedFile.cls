/**
 * Demo attached file to sharepoint
 * PIC : chuntika.b@roundtwosolutions.com
 * Lastmodifieddate : 10Jan2024
 */
public with sharing class CTRAttachedFile {

    // @future(callout=true)
    public static void attachedFile(List<String> titleList) {
        //loopmakes format >> ('7.5mb','6mb','4.4mb','2-4.4mb','3-4.4mb') iterate files name
        //....
        System.debug('files: '+titleList);

        List<String> stringList = new List<String>();

        // Convert integers to strings and add single quotes
        for (String title : titleList) {
            stringList.add('\'' + title + '\'');
        }

        // Display the result
        System.debug('stringList : '+stringList);

        String formattedString = '(' + String.join(stringList, ', ') + ')';
        System.debug(formattedString);

        // // List<ContentVersion> mVersion = [SELECT Id, ContentDocumentId, VersionData,ContentDocument.Title FROM ContentVersion 
        // // WHERE ContentDocument.Title = '7.5mb' OR ContentDocument.Title = '6mb' OR ContentDocument.Title = '4.4mb' OR ContentDocument.Title = '2-4.4mb' OR ContentDocument.Title = '3-4.4mb'];
        // //SELECT Id, ContentDocumentId, VersionData,ContentDocument.Title FROM ContentVersion WHERE ContentDocument.Title IN ('7.5mb','6mb','4.4mb','2-4.4mb','3-4.4mb')
        // List<ContentVersion> mVersion = [SELECT Id, ContentDocumentId, VersionData,ContentDocument.Title FROM ContentVersion WHERE ContentDocument.Title IN ('6mb','T033')];
        // System.debug('--mVersion--'+mVersion);

        // Set<Id> mIdList = new Set<Id>();
        // System.debug('--mIdList--'+mIdList);

        // for(ContentVersion mVer: mVersion)
        // {
        //     mIdList.add(mVer.ContentDocumentId);
        //     System.debug('--for--mIdList--'+mVer.ContentDocumentId);
        // }
        //  CTRSharPointFileController.UploadFileToSharePoint('',mIdList);
    }

    @AuraEnabled
    public static String uploadFiles(List<Object> fileList) {
        // Implement logic to process the attached files
        // You can use ContentVersion or other objects to handle file attachments

        // Example: Print file titles
        for (Object file : fileList) {
            System.debug('File Title: ' + ((Map<String, Object>)file).get('Title'));
        }

        // Implement your logic and return a response if necessary
        return 'Files uploaded successfully';
    }

    @AuraEnabled
    public static String processFiles(List<ContentVersion> files, String title) {
        for (ContentVersion file : files) {
            System.debug('File : ' + file);
        }

        // Return a response if needed
        return 'Files processed successfully!';
    }
}