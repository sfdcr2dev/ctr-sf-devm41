public with sharing class CTRContentDocHandler {

    // public static List<ContentDocu  ment> objCDListTemp = new List<ContentDocument>();

    // @future(callout=true)
    public static void getTitleFile(List<ContentDocument> objCDList) {
        try{
            System.debug('objCDList :'+objCDList);
            // objCDListTemp = objCDList;

            Map<String,String> objCDMap = new Map<String,String>();
            List<String> titleList = new List<String>();
            for ( ContentDocument objCD : objCDList ) {
                titleList.add(objCD.Title);
                System.debug('objCD : '+objCD);
            }

            System.debug('titleList : '+titleList);
            CTRAttachedFile.attachedFile(titleList);

        }catch(Exception e) {
            String errormsg = 'Error CTRContentDocHandler : '+e.getMessage()+' line : '+e.getLineNumber();
            System.debug(errormsg);  
            // throw new AuraHandledException(errormsg);
        }
    }
}