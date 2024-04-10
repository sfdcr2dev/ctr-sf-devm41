public with sharing class ODM_PermitToWorkInspection {

    @AuraEnabled
    public static Boolean hasWriteAccess(String workclearanceId){
        return THOR_WorkClearanceController.hasWriteAccess(workclearanceId);
    }

    @AuraEnabled
    public static List<Object> getWorkClearanceById(String workClearanceId){
        List<Work_Clearance__c> workClearances = [
            SELECT Id,Name,Safety_Permit1_UI__r.Name,Safety_Permit2_UI__r.Name,Safety_Permit3_UI__r.Name,Thaioil_Supervisor_Indicator_UI__r.EN_Fullname__c,
                Thaioil_Supervisor_Indicator_UI__r.SECTIONS__c,FunctionalLocation__r.Name,Problem__c,Description__c,Work_Clearance_Description__c,
                Work_Detail__c,OwnerId FROM Work_Clearance__c WHERE Id = :workClearanceId];
        return workClearances;
    }

    @AuraEnabled
    public static List<Object> getPISUser(){
        //PISUser
        String UserId = UserInfo.getUserId();
        List<PISUsers__c> pisusers = [
			SELECT Id,Name,EMPLOYEEID__c,HOST_ID__c,HOME_ID__c,ENFIRSTNAME__c,ENLASTNAME__c,ORGID__c,EN_Fullname__c,
                SECTIONS__c FROM PISUsers__c WHERE User__c = :UserId ];
        return pisusers;
    }

    @AuraEnabled
    public static List<Object> getFormQuestions(String version) {
        if (String.isNotBlank(version)) {
            return [SELECT Id,Name,FormName__c,Question__c,Question_API__c,Section__c,Order_Question__c,Answer_type__c,
                Value__c,Version__c,IsActive_Report__c,Description__c FROM PTW_Question_Master__c WHERE FormName__c = 'Inspection' AND Version__c = :version
            ORDER BY Version__c, Order_Question__c, Answer_type__c];
        } else {
            return [SELECT Id,Name,FormName__c,Question__c,Question_API__c,Section__c,Order_Question__c,Answer_type__c,Value__c,
                Version__c,IsActive_Report__c,Description__c FROM PTW_Question_Master__c WHERE FormName__c = 'Inspection'
            ORDER BY Version__c, Order_Question__c, Answer_type__c];
        }
    }

    @AuraEnabled
    public static List<Object> getFormAnswers(String workClearanceId, String userId){
        return [
            SELECT Id,Name,CreatedDate,LastModifiedDate,Key__c,FormName__c,Work_Clearance__c,User__c,
                Version__c,Status__c,(SELECT Id, Name, PTW_Header__c, Question__c, Answer__c, Question__r.Question_API__c, Question_Text__c, Key__c, Parent_Answer__c FROM PTW_Answer__r)
                //(SELECT Id, Name, PTW_Header__c, Question__c, Answer__c, Question__r.Question_API__c, Question_Text__c, Key__c, Parent_Answer__c, Parent_Answer__r.Question__r.Question__c FROM PTW_Answer__r)
            FROM PTW_Header__c WHERE  FormName__c = 'Inspection' AND Work_Clearance__c = :workClearanceId ORDER BY CreatedDate DESC];
    }
    // @AuraEnabled
	// public static String getUserId(){
    //     System.debug(
    //             'name: ' +
    //             UserInfo.getUserId());
	// 	return UserInfo.getUserId();
	// }

    @AuraEnabled
    public static List<ContentDocumentLink> getFilesRelated(String workClearanceId, String userId){
        Map<Id, PTW_Answer__c> ptwAnswers = new Map<Id, PTW_Answer__c>([
            SELECT Id FROM PTW_Answer__c WHERE PTW_Header__r.Work_Clearance__c = :workClearanceId]);

        return [
            SELECT LinkedEntityId,ContentDocumentId,ContentDocument.Title,ContentDocument.FileType,ContentDocument.FileExtension,
                ContentDocument.ContentSize,ContentDocument.CreatedDate FROM ContentDocumentLink
            WHERE LinkedEntityId IN :ptwAnswers.keySet() AND LinkedEntity.Type = 'PTW_Answer__c' ORDER BY ContentDocument.CreatedDate ];
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
        String runningNo = getNextRunningNo(workClearanceId, userId);
        List<Object> lstAnswer = (List<Object>) mapJsonAnswer.get('Inspection');
        List<PTW_Answer__c> lstPtwAnswer = new List<PTW_Answer__c>();
        List<PTW_Answer__c> lstPtwAnswerComment = new List<PTW_Answer__c>();
        List<String> lstPtwAnswerCommentDeleteId = new List<String>();

        if (String.isBlank(headerId)) {
            PTW_Header__c ptwHeader = new PTW_Header__c(
                Work_Clearance__c = workClearanceId,
                FormName__c = formName,
                Version__c = version,
                Status__c = status,
                User__c = userId,
                RecordTypeId = getRecordTypeId(),
                Key__c = String.format('{0}.{1}.{2}.{3}#{4}', new List<String>{
                    'Inspection',
                    version,
                    workClearanceId,
                    userId,
                    runningNo
                })
            );
            upsert ptwHeader Key__c;
            headerId = (String) ptwHeader.Id;
        } else {
            PTW_Header__c ptwHeader = new PTW_Header__c(
                Id = headerId,
                Status__c = status
            );
            System.debug(ptwHeader);
            upsert ptwHeader;
        }

        if (lstAnswer != null) {
            String author = '';
            for (Object item: lstAnswer) {
                Map<String, Object> mapAnswer = (Map<String, Object>) item;
                String parentAnswer = (String) mapAnswer.get('Parent_Answer__c');
                String parentAnswerKey = (String) mapAnswer.get('Parent_Answer_Key__c');
                //String answerType = (String) mapAnswer.get('Answer_type__c');
                //if (String.isNotBlank(answerType)) {
                if (String.isBlank(parentAnswerKey)) {
                    PTW_Answer__c ptwAnswer = new PTW_Answer__c(
                        Question__c = (String) mapAnswer.get('Id'),
                        Question_Text__c = (String) mapAnswer.get('Question__c'),
                        PTW_Header__c = headerId,
                        Answer__c = String.valueOf(mapAnswer.get('Answer__c')),
                        Key__c = String.format('{0}.{1}', new List<String>{
                            headerId,
                            (String) mapAnswer.get('Id')
                        })
                    );

                    if((String) mapAnswer.get('Question__c') == '(Auditor) Name:*')
                    {
                        author = String.valueOf(mapAnswer.get('Answer__c'));
                    }
                    lstPtwAnswer.add(ptwAnswer);
                }
                //}
            }
            upsert lstPtwAnswer Key__c;

            if(author != '')
            {
                List<PISUsers__c> auditorList = [select id from PISUsers__c where EN_Fullname__c =: author];
                if(auditorList.size() > 0)
                {
                    PTW_Header__c updatedHeader = new PTW_Header__c(id = headerId);
                    updatedHeader.Auditor_Name__c = auditorList[0].id;
                    update updatedHeader;
                }

            }

            for (Object item: lstAnswer) {
                Map<String, Object> mapAnswer = (Map<String, Object>) item;
                String action = (String) mapAnswer.get('Action');
                String parentAnswer = (String) mapAnswer.get('Parent_Answer__c');
                String parentAnswerKey = (String) mapAnswer.get('Parent_Answer_Key__c');
                if (String.isNotBlank(parentAnswerKey)) {
                    if (action != 'Delete') {
                        PTW_Answer__c ptwAnswerComment = new PTW_Answer__c(
                            Question__c = (String) mapAnswer.get('Question__c'),
                            Question_Text__c = (String) mapAnswer.get('Question_Text__c'),
                            PTW_Header__c = headerId,
                            Answer__c = String.valueOf(mapAnswer.get('Answer__c')),
                            Parent_Answer__r = new PTW_Answer__c(
                                Key__c = String.format('{0}.{1}', new List<String>{
                                    headerId,
                                    (String) mapAnswer.get('Question__c')
                                })
                            ),
                            Key__c = String.format('Comment.{0}.{1}', new List<String>{
                                headerId,
                                (String) mapAnswer.get('Question__c')
                            })
                        );
                        lstPtwAnswerComment.add(ptwAnswerComment);
                    } else {
                        lstPtwAnswerCommentDeleteId.add(String.format('Comment.{0}.{1}', new List<String>{
                            headerId,
                            (String) mapAnswer.get('Question__c')
                        }));
                    }
                }
            }
            upsert lstPtwAnswerComment Key__c;
            delete [SELECT Id FROM PTW_Answer__c WHERE Key__c IN :lstPtwAnswerCommentDeleteId];
        }

        return headerId;
    }

    private static String getNextRunningNo(String workClearanceId, String userId) {
        Integer currentRunningNo = 0;
        for (PTW_Header__c ptwHeader : [SELECT Key__c FROM PTW_Header__c WHERE Work_Clearance__c = :workClearanceId]) {
            String partKey = String.valueOf(ptwHeader.Key__c)?.substringAfterLast('#');
            System.debug('partKey: ' + partKey);
            Integer runningNo = (!String.isBlank(partKey)) ? Integer.valueOf(partKey) : 0;
            currentRunningNo = (runningNo > currentRunningNo) ? runningNo : currentRunningNo;
        }
        return String.valueOf(currentRunningNo + 1);
    }

    private static String getRecordTypeId() {
        String recordTypeId = '';
        List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SObjectType = 'PTW_HEADER__c' AND DeveloperName = 'Inspection'
        ];
        if (recordTypes.size() > 0) {
            recordTypeId = recordTypes[0].Id;
        }
        return recordTypeId;
    }
	@AuraEnabled
	public static void deleteFile(String fileId) {
		try {
			if (Schema.sObjectType.ContentDocument.isDeletable()) {
                delete [SELECT Id FROM ContentDocument WHERE Id = :fileId];
			} else {
				throw new AuraHandledException('Not sufficient permissions');
			}
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

//    @AuraEnabled
//    public static List<Object> getFormAnswers(String workClearanceId, String userId){
//        return [
//            SELECT
//                Id,
//                Name,
//                PTW_Header__c,
//                Question__c,
//                Answer__c
//            FROM PTW_Answer__c
//            WHERE :workClearanceId
//                AND :userId
//        ];
//    }
//
//    @AuraEnabled
//    public static List<Object> getFormAnswers(String headerId){
//        return [
//            SELECT
//                Id,
//                Name,
//                PTW_Header__c,
//                Question__c,
//                Answer__c
//            FROM PTW_Answer__c
//            WHERE :workClearanceId
//                AND :userId
//        ];
//    }
}