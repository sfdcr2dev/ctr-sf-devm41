public with sharing class ODM_PermitToWorkVerification {

    @AuraEnabled
    public static List<Object> getFormQuestions(String version) {
        if (String.isNotBlank(version)) {
            return [SELECT Id,Name,FormName__c,Question_API__c,Question__c,Section__c,Order_Question__c,Answer_type__c,
                    Value__c,Version__c,IsActive_Report__c,Description__c FROM PTW_Question_Master__c
                    WHERE FormName__c = 'Verification' AND Version__c = :version ORDER BY Version__c, Order_Question__c, Answer_type__c];

        } else {
            return [SELECT Id,Name,FormName__c,Question_API__c,Question__c,Section__c,Order_Question__c,Answer_type__c,Value__c,
                    Version__c,IsActive_Report__c,Description__c FROM PTW_Question_Master__c
                    WHERE FormName__c = 'Verification' ORDER BY Version__c, Order_Question__c, Answer_type__c];
        }
    }

    @AuraEnabled
    public static List<Object> getFormAnswers(String workClearanceId){
        return [SELECT Id,Name,Key__c,FormName__c,Work_Clearance__c,User__c,Version__c,Status__c,
            (SELECT Id, Name, PTW_Header__c, Question__c, Answer__c, Question_Text__c, Key__c FROM PTW_Answer__r)
            FROM PTW_Header__c WHERE  FormName__c = 'Verification' AND Work_Clearance__c = :workClearanceId
            ORDER BY CreatedDate];
    }

    @AuraEnabled
    public static List<String> getWorkClearanceDetail(String workClearanceId)
    {
        Work_Clearance__c wc = [select id,Area__c,Work_Clearance__c,Work_Detail__c,Safety_Permit1__c,Safety_Permit2__c,Safety_Permit3__c,toLabel(High_risk_work__c), Verification_Status__c
                                from Work_Clearance__c where id =: workclearanceId];
        List<String>returnText = new List<String>();
        if(wc.Area__c != null && wc.Area__c != '')
        {
            returnText.add(wc.Area__c);
        }
        else
        {
            returnText.add(' ');
        }
        if(wc.Work_Clearance__c != null && wc.Work_Clearance__c != '')
        {
            returnText.add(wc.Work_Clearance__c);
        }
        else
        {
            returnText.add(' ');
        }
        if(wc.Work_Detail__c != null && wc.Work_Detail__c != '')
        {
            returnText.add(wc.Work_Detail__c);
        }
        else
        {
            returnText.add(' ');
        }
        String concatText = '';

        if(wc.Safety_Permit1__c != null && wc.Safety_Permit1__c != '')
        {
            concatText = wc.Safety_Permit1__c;
        }

        if(wc.Safety_Permit2__c != null && wc.Safety_Permit2__c != '')
        {
            if (concatText == '') {
                concatText = wc.Safety_Permit2__c ;
            }
            else {
                concatText = concatText + ',' + wc.Safety_Permit2__c;
            }
        }
        if(wc.Safety_Permit3__c != null && wc.Safety_Permit3__c != '')
        {
            if (concatText == '') {
                concatText = wc.Safety_Permit3__c ;
            }
            else {
                concatText = concatText + ',' + wc.Safety_Permit3__c ;
            }
        }
        returnText.add(concatText);

        if(wc.High_risk_work__c != null && wc.High_risk_work__c != '')
        {
            returnText.add(wc.High_risk_work__c);
        }
        else
        {
            returnText.add(' ');
        }

        if(wc.Verification_Status__c != null && wc.Verification_Status__c != '')
        {

            returnText.add(wc.Verification_Status__c);
        }
        else
        {
            returnText.add(' ');
        }
        return returnText;
    }
    @AuraEnabled
    public static String savePermitToWork(String jsonAnswer){
        Map<String, Object> mapJsonAnswer = (Map<String, Object>) JSON.deserializeUntyped(jsonAnswer);
        String headerId = (String) mapJsonAnswer.get('HeaderId');
        String workClearanceId = (String) mapJsonAnswer.get('WorkClearanceId');
        String version = (String) mapJsonAnswer.get('Version');
        String status = (String) mapJsonAnswer.get('Status');
        String formName = (String) mapJsonAnswer.get('FormName');
        String userId = (String) UserInfo.getUserId();
        // String runningNo = getNextRunningNo(workClearanceId, userId);
        try {
            List<Object> lstAnswer = (List<Object>) mapJsonAnswer.get('Verification');
            List<PTW_Answer__c> lstPtwAnswer = new List<PTW_Answer__c>();

            if (String.isBlank(headerId)) {
                PTW_Header__c ptwHeader = new PTW_Header__c(
                    Work_Clearance__c = workClearanceId,
                    FormName__c = formName,
                    Version__c = version,
                    Status__c = status,
                    User__c = userId,
                    RecordTypeId = getRecordTypeId(),
                    Key__c = String.format('{0}{1}{2}{3}', new List<String>{
                        'Verification',
                            workClearanceId,
                            userId,
                            version
                            })
                );

                upsert ptwHeader Key__c;

                Work_Clearance__c wc = new Work_Clearance__c(Id= workClearanceId);
                wc.Verification_Status__c = status;
                update wc;
                headerId = (String) ptwHeader.Id;
            } else {
                PTW_Header__c ptwHeader = new PTW_Header__c(
                    Id = headerId,
                    Status__c = status
                );

                upsert ptwHeader;

                Work_Clearance__c wc = new Work_Clearance__c(Id= workClearanceId);
                wc.Verification_Status__c = status;
                update wc;
            }
            String author = '';
            for (Object item: lstAnswer) {
                Map<String, Object> mapAnswer = (Map<String, Object>) item;
                String answerType = (String) mapAnswer.get('Answer_type__c');
                if (String.isNotBlank(answerType)) {
                    PTW_Answer__c ptwAnswer = new PTW_Answer__c(
                        Question__c = (String) mapAnswer.get('Id'),
                        Question_Text__c = (String) mapAnswer.get('Question__c'),
                        PTW_Header__c = headerId,
                        Answer__c = (String) mapAnswer.get('Answer__c'),
                        Key__c = String.format('{0}.{1}', new List<String>{
                            headerId,
                                (String) mapAnswer.get('Id')
                                })
                    );
                    if((String) mapAnswer.get('Question__c') == 'Name')
                    {
                        author = String.valueOf(mapAnswer.get('Answer__c'));
                    }
                    lstPtwAnswer.add(ptwAnswer);
                }
            }
            upsert lstPtwAnswer Key__c;

            if(author != '')
            {
                List<PISUsers__c> auditorList = [select id from PISUsers__c where EN_Fullname__c =: author];
                if(auditorList.size() > 0)
                {
                    PTW_Header__c updatedHeader = new PTW_Header__c(id = headerId);
                    updatedHeader.Verification_Name__c = auditorList[0].id;
                    update updatedHeader;
                }

            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        return headerId;
    }
    @AuraEnabled
    public static String submitPermitToWork(String jsonAnswer){
        Map<String, Object> mapJsonAnswer = (Map<String, Object>) JSON.deserializeUntyped(jsonAnswer);
        String headerId = (String) mapJsonAnswer.get('HeaderId');
        String workClearanceId = (String) mapJsonAnswer.get('WorkClearanceId');
        String version = (String) mapJsonAnswer.get('Version');
        String status = (String) mapJsonAnswer.get('Status');
        String formName = (String) mapJsonAnswer.get('FormName');
        String userId = (String) UserInfo.getUserId();
        // String runningNo = getNextRunningNo(workClearanceId, userId);
        try {
            List<Object> lstAnswer = (List<Object>) mapJsonAnswer.get('Verification');
            List<PTW_Answer__c> lstPtwAnswer = new List<PTW_Answer__c>();

            if (String.isBlank(headerId)) {
                PTW_Header__c ptwHeader = new PTW_Header__c(
                    Work_Clearance__c = workClearanceId,
                    FormName__c = formName,
                    Version__c = version,
                    Status__c = 'Draft',
                    User__c = userId,
                    RecordTypeId = getRecordTypeId(),
                    Key__c = String.format('{0}{1}{2}{3}', new List<String>{
                        'Verification',
                            workClearanceId,
                            userId,
                            version
                            })
                );
                upsert ptwHeader Key__c;

                Work_Clearance__c wc = new Work_Clearance__c(Id= workClearanceId);
                wc.Verification_Status__c = 'Draft';
                update wc;
                headerId = (String) ptwHeader.Id;
            } else {
                PTW_Header__c ptwHeader = new PTW_Header__c(
                    Id = headerId,
                    Status__c = 'Draft'
                );

                upsert ptwHeader;

                Work_Clearance__c wc = new Work_Clearance__c(Id= workClearanceId);
                wc.Verification_Status__c = 'Draft';
                update wc;
            }

            String author;
            for (Object item: lstAnswer) {
                Map<String, Object> mapAnswer = (Map<String, Object>) item;
                String answerType = (String) mapAnswer.get('Answer_type__c');
                if (String.isNotBlank(answerType)) {
                    PTW_Answer__c ptwAnswer = new PTW_Answer__c(
                        Question__c = (String) mapAnswer.get('Id'),
                        Question_Text__c = (String) mapAnswer.get('Question__c'),
                        PTW_Header__c = headerId,
                        Answer__c = (String) mapAnswer.get('Answer__c'),
                        Key__c = String.format('{0}.{1}', new List<String>{
                            headerId,
                                (String) mapAnswer.get('Id')
                                })
                    );
                    if((String) mapAnswer.get('Question__c') == 'Name')
                    {
                        author = String.valueOf(mapAnswer.get('Answer__c'));
                    }
                    lstPtwAnswer.add(ptwAnswer);
                }
            }

            if(author != '')
            {
                List<PISUsers__c> auditorList = [select id from PISUsers__c where EN_Fullname__c =: author];
                if(auditorList.size() > 0)
                {
                    PTW_Header__c updatedHeader = new PTW_Header__c(id = headerId);
                    updatedHeader.Verification_Name__c = auditorList[0].id;
                    update updatedHeader;
                }

            }
            upsert lstPtwAnswer Key__c;
        }
        catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        return headerId;
    }

    private static String getRecordTypeId() {
        String recordTypeId = '';
        List<RecordType> recordTypes = [
            SELECT Id FROM RecordType WHERE SObjectType = 'PTW_HEADER__c' AND DeveloperName = 'Verification'];
        if (recordTypes.size() > 0) {
            recordTypeId = recordTypes[0].Id;
        }
        return recordTypeId;
    }

    @AuraEnabled
    public static List<Object> getPISUser(){
        //PISUser
        String UserId = UserInfo.getUserId();
        List<PISUsers__c> pisusers = [
			SELECT Id,Name,EMPLOYEEID__c,HOST_ID__c,HOME_ID__c,ENFIRSTNAME__c,ENLASTNAME__c,ORGID__c,EN_Fullname__c
			FROM PISUsers__c WHERE User__c = :UserId ];
        return pisusers;
    }

    // /** Function : Validate User login as can edit work clearance or not */
    // @AuraEnabled
    // public static Boolean getUserRecordEditAccess(String recordId){
    //   return [SELECT Id, UserRecordAccess.HasEditAccess FROM Work_Clearance__c WHERE Id = :recordId]?.UserRecordAccess.HasEditAccess;
    // }

    // /** Function : Validate User login as can edit work clearance or not */
    // @AuraEnabled
    // public static Boolean hasWriteAccess(String workclearanceId){
    //     return getUserRecordEditAccess(workclearanceId);
    // }

    /** Function : Validate User login as can edit work clearance or not */
    @AuraEnabled
    public static Boolean canEditOrSubmit(String workclearanceId){

        String userId = UserInfo.getUserId();
        String userProfileId = UserInfo.getProfileId();

        List<String> allGroupIDs = new List<String>();
        List<GroupMember> gmList = [SELECT Id, group.id, group.name, group.type FROM GroupMember WHERE (UserOrGroupId = :UserInfo.getUserId() AND group.name = 'QMOS STAFF') 
                                OR (UserOrGroupId = :UserInfo.getUserId() AND group.name = 'QMOS PROJECT')];
        for (GroupMember gm : gmList){
            allGroupIDs.add(gm.group.id);
        }
        
        return (gmList.size() == 0) ;
    }
}