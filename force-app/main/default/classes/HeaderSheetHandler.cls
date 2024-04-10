public with sharing class HeaderSheetHandler {
    private static String conditionQuery(
		String apiField,
		String operator,
		String val
	)
    {if(operator.equalsIgnoreCase('LIKE')) {
            val = String.valueOf(val).replace('*', '%');
            if(!val.contains('%')) val = '%' + val + '%';
        }
		return String.format(
			'{0} {1} {2}',
			new List<String>{ apiField, operator, '\'' + val + '\'' }
		);
	}
    public static void createSteps(List<Header_Sheet__c> headerSheets) {
        Map<Id, EQCC_Checked_Sheet__c> sheets = getSheetsFromHeaderSheets(headerSheets, new Set<Id>());

        List<EQCC_Step__c> steps = new List<EQCC_Step__c>();
        List<Checked_Sheet_Pointer__mdt> forms = [
            SELECT DeveloperName, Step_Count__c, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
        ];
        for (Header_Sheet__c headerSheet : headerSheets) {
            Checked_Sheet_Pointer__mdt form;
            for (Checked_Sheet_Pointer__mdt f : forms) {
                if (sheets.get(headerSheet.Sheet__c).Form_Type__c == f.DeveloperName) {
                    form = f;
                }
            }

            for (Integer i = 1; i <= form.Step_Count__c; i++) {
                if (i == 1) {
                    steps.add(
                        new EQCC_Step__c(
                            Header_Sheet__c = headerSheet.Id,
                            Step_Number__c = i,
                            Is_Current__c = true,
                            Form_Code__c = form.Form_Code__c
                        )
                    );
                } else {
                    steps.add(
                        new EQCC_Step__c(
                            Header_Sheet__c = headerSheet.Id,
                            Step_Number__c = i,
                            Is_Current__c = false,
                            Form_Code__c = form.Form_Code__c,
                            Status__c = 'In progress'
                        )
                    );
                }
            }
        }

        insert steps;
    }

    /**
     * @description retrieves manually create EQCCs not related to Notification or Order
     */
    // @AuraEnabled
    // public static List<HeaderSheetWrapper> getManuallyCreatedEQCC(Integer loadLimit) {
    //     List<Header_Sheet__c> headerSheets = getManuallyCreatedHeaderSheets();
    //     Map<Id, EQCC_Header__c> headers = getHeadersFromHeaderSheets(headerSheets, loadLimit);
    //     Map<Id, EQCC_Checked_Sheet__c> sheets = getSheetsFromHeaderSheets(headerSheets, headers.keySet());

    //     Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(
    //         headers,
    //         headerSheets,
    //         sheets
    //     );

    //     return createHeaderSheetWrapper(sheetsByHeader);
    // }
   //@Overwrite filter EQCCs not related to Notification or Order
    @AuraEnabled
    public static List<HeaderSheetWrapper> getManuallyCreatedEQCCFilter(Map<String,String> filterMap) {
        List<Header_Sheet__c> headerSheets = getManuallyCreatedHeaderSheetsFilter(50000, filterMap);
        for (Header_Sheet__c variable : headerSheets) {
            system.debug('HEADERSheets:=' + variable);
        }

        Map<Id, EQCC_Header__c> headers = getHeadersFromHeaderSheets(headerSheets);
        Map<Id, EQCC_Checked_Sheet__c> sheets = getSheetsFromHeaderSheets(headerSheets, headers.keySet());

        Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(
            headers,
            headerSheets,
            sheets
        );

        return createHeaderSheetWrapper(sheetsByHeader);
    }
    /**
     * @description retrieves number of manually create EQCCs not related to Notificatiืนะon or Order
     */
    // @AuraEnabled
    // public static Integer getManuallyCreatedEQCCCount() {
    //     Integer res = 0;

    //     List<Header_Sheet__c> headerSheets = getManuallyCreatedHeaderSheets();

    //     Set<Id> headerIds = new Set<Id>();
    //     for (Header_Sheet__c headerSheet : headerSheets) {
    //         headerIds.add(headerSheet.Header__c);
    //     }

    //     return headerIds.size();
    // }

    @AuraEnabled
    public static Integer getManuallyCreatedEQCCCountFilter(Map<String,String> filterMap) {
        Integer res = 0;

        List<Header_Sheet__c> headerSheets = getManuallyCreatedHeaderSheetsFilter(50000, filterMap);

        Set<Id> headerIds = new Set<Id>();
        for (Header_Sheet__c headerSheet : headerSheets) {
            headerIds.add(headerSheet.Header__c);
        }

        return headerIds.size();
    }

    /**
     * @description retrieves EQCC not Approved or Rejected
     */
    // @AuraEnabled
    // public static List<HeaderSheetWrapper> getInProgressEQCC(Integer loadLimit) {
    //     List<Header_Sheet__c> headerSheets = getInProgressHeaderSheets();
    //     Map<Id, EQCC_Header__c> headers = getHeadersFromHeaderSheets(headerSheets, loadLimit);
    //     Map<Id, EQCC_Checked_Sheet__c> sheets = getSheetsFromHeaderSheets(headerSheets, headers.keySet());

    //     Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(
    //         headers,
    //         headerSheets,
    //         sheets
    //     );

    //     return createHeaderSheetWrapper(sheetsByHeader);
    // }

    //@Overwrite filter retrieves EQCC not Approved or Rejected
    @AuraEnabled
    public static List<HeaderSheetWrapper> getInProgressEQCCFilter(Map<String,String> filterMap) {

        List<Header_Sheet__c> headerSheets = getInProgressHeaderSheetsFilter(filterMap);
        for (Header_Sheet__c variable : headerSheets) {
            system.debug('HEADERSheetsInProgress:=' + variable);
        }

        Map<Id, EQCC_Header__c> headers = getHeadersFromHeaderSheets(headerSheets);
        Map<Id, EQCC_Checked_Sheet__c> sheets = getSheetsFromHeaderSheets(headerSheets, headers.keySet());

        Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(
            headers,
            headerSheets,
            sheets
        );

        return createHeaderSheetWrapper(sheetsByHeader);
    }

    /**
     * @description retrieves the number of EQCC not Approved or Rejected
     */
    // @AuraEnabled
    // public static Integer getInProgressEQCCCount() {
    //     Integer res = 0;

    //     List<Header_Sheet__c> headerSheets = getInProgressHeaderSheets();

    //     Set<Id> headerIds = new Set<Id>();
    //     for (Header_Sheet__c headerSheet : headerSheets) {
    //         headerIds.add(headerSheet.Header__c);
    //     }

    //     return headerIds.size();
    // }

    @AuraEnabled
    public static Integer getInProgressEQCCCountFilter(Map<String, String> filterMap) {
        Integer res = 0;

        List<Header_Sheet__c> headerSheets = getInProgressHeaderSheetsFilter(filterMap);

        Set<Id> headerIds = new Set<Id>();
        for (Header_Sheet__c headerSheet : headerSheets) {
            headerIds.add(headerSheet.Header__c);
        }

        return headerIds.size();
    }


    @AuraEnabled
    public static void updateStepPercentage(String stepId, String percentage) {
        EQCC_Step__c step = getStepById(stepId);

        step.Percentage__c = Integer.valueOf(percentage);
        if (Schema.SObjectType.EQCC_Step__c.isUpdateable()) {
            update step;
        }
    }

    @AuraEnabled
    public static void updateHeaderSheetPercentages(String stepId, String percentages) {
        try {
            EQCC_Step__c step = getStepById(stepId);
            Header_Sheet__c headerSheet = getHeaderSheetById(step.Header_Sheet__c);
            Map<String, Object> percentagesByStep = (Map<String, Object>) JSON.deserializeUntyped(percentages);

            headerSheet.Percentage_by_Step__c = percentages;
            //Step_Percentage__c
            String stepsPercentage = '';
            Integer percent = 0;
            for (String key : percentagesByStep.keySet()) {
                if (stepsPercentage != '') {
                    stepsPercentage += ', ';
                }
                stepsPercentage += 'Step ' + key + ': ' + percentagesByStep.get(key) + '%';
                percent += Integer.valueOf(percentagesByStep.get(key));
            }
            headerSheet.Step_Percentage__c = stepsPercentage;
            headerSheet.Percentage__c = percent;

            SObjectAccessDecision decision = Security.stripInaccessible(
                AccessType.UPDATABLE,
                new List<Header_Sheet__c>{headerSheet}
            );
            update decision.getRecords();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description rejects Header Sheet
     */
    @AuraEnabled
    public static void rejectStepAndHeaderSheet(String stepId, String reason) {
        EQCC_Step__c step = getStepById(stepId);
        step.Status__c = Constants.CHECKED_SHEETS.STATUS_REJECTED;

        if (Schema.SObjectType.EQCC_Step__c.isUpdateable()) {
            update step;

            Header_Sheet__c headerSheet = getHeaderSheetById(step.Header_Sheet__c);
            headerSheet.Rejection_Reason__c = reason;
            Datetime current = System.now();
            Date currentDate = current.dateGmt();
            Time currentTime = current.timeGmt();
            Datetime local = datetime.newinstance(currentDate, currentTime);

            headerSheet.Rejection_Datetime__c = getDateFromDatetime(Datetime.now());

            if (Schema.SObjectType.Header_Sheet__c.isUpdateable()) {
                update headerSheet;
            }
        } else {
            throw new AuraHandledException('Insufficient permissions');
        }
    }

    private static String getDateFromDatetime(Datetime mDatetime) {
        return mDatetime.format('dd/MM/yyyy HH:mm:ss', UserInfo.getTimeZone().toString());
    }

    public static void handleStatusUpdated(Map<Id, sObject> newItems, Map<Id, sObject> oldItems) {
        for (Header_Sheet__c headerSheet : (List<Header_Sheet__c>) newItems.values()) {
            Header_Sheet__c oldHeaderSheet = (Header_Sheet__c) oldItems.get(headerSheet.Id);
            if (isHeaderSheetPolluted(headerSheet, oldHeaderSheet)) {
                headerSheet.isPolluted__c = true;
            }
            if (isStatusUpdatedAndClosed(headerSheet, oldHeaderSheet)) {
                headerSheet.Closed_Date__c = System.today();
                if (headerSheet.Status__c != Constants.CHECKED_SHEETS.STATUS_APPROVED) {
                    headerSheet.Requester__c = UserInfo.getName();
                    headerSheet.RequesterId__c = UserInfo.getUserId();
                }
            }
        }
    }

    @AuraEnabled
    public static void updateHeaderSheetRequester(Id stepId) {
        EQCC_Step__c step = getStepById(stepId);
        Header_Sheet__c headerSheet = getHeaderSheetById(step.Header_Sheet__c);

        headerSheet.Requester__c = UserInfo.getName();
        headerSheet.RequesterId__c = UserInfo.getUserId();
        if (Schema.SObjectType.Header_Sheet__c.isUpdateable()) {
            update headerSheet;
        }
    }

    private static Boolean isHeaderSheetPolluted(Header_Sheet__c newHeaderSheet, Header_Sheet__c oldHeaderSheet) {
        return (newHeaderSheet.Status__c != oldHeaderSheet.Status__c) &&
                newHeaderSheet.Status__c != Constants.CHECKED_SHEETS.STATUS_DRAFT;
    }

    private static Boolean isStatusUpdatedAndClosed(Header_Sheet__c newHeaderSheet, Header_Sheet__c oldHeaderSheet) {
        return (newHeaderSheet.Status__c != oldHeaderSheet.Status__c) &&
            (newHeaderSheet.Status__c == Constants.CHECKED_SHEETS.STATUS_APPROVED ||
            newHeaderSheet.Status__c == Constants.CHECKED_SHEETS.STATUS_REJECTED);
    }

    /**
     * @description get sheets from junction object
     * @param headerSheets
     */
    private static Map<Id, EQCC_Checked_Sheet__c> getSheetsFromHeaderSheets(
        List<Header_Sheet__c> headerSheets,
        Set<Id> headersIds
    ) {
        Set<Id> sheetIds = new Set<Id>();
        for (Header_Sheet__c headerSheet : headerSheets) {
            if (headersIds.isEmpty() || headersIds.contains(headerSheet.Header__c)) {
                sheetIds.add(headerSheet.Sheet__c);
            }
        }

        Map<Id, EQCC_Checked_Sheet__c> sheets = new Map<Id, EQCC_Checked_Sheet__c>(
            [
                SELECT Id, Form_Type__c, Sheet_Code__c, Name, Status__c, CreatedDate, Group__c
                FROM EQCC_Checked_Sheet__c
                WHERE Id IN :sheetIds
                ORDER BY CreatedDate DESC
            ]
        );

        return sheets;
    }

    /**
     * @description get headers from junction object
     * @param headerSheets
     */
    private static Map<Id, EQCC_Header__c> getHeadersFromHeaderSheets(
        List<Header_Sheet__c> headerSheets
        // Integer loadLimit
    ) {
        // if (loadLimit == 0) {
        //     loadLimit = Constants.SOQL.SOQL_LIMIT;
        // }

        Set<Id> headerIds = new Set<Id>();
        for (Header_Sheet__c headerSheet : headerSheets) {
            headerIds.add(headerSheet.Header__c);
        }

        Map<Id, EQCC_Header__c> sheets = new Map<Id, EQCC_Header__c>(
            [
                SELECT
                    Id,
                    FunctionalLocation__r.Name,
                    Equipment__r.Name,
                    Name,
                    Notification__r.Notification_Number__c,
                    Notification__r.Description__c,
                    Order__r.Order_Number__c,
                    Order__r.Description__c,
                    CreatedDate
                FROM EQCC_Header__c
                WHERE Id IN :headerIds AND IsDeleted__c = FALSE
                WITH SECURITY_ENFORCED
                ORDER BY CreatedDate DESC
                // LIMIT :loadLimit
            ]
        );

        return sheets;
    }

    // private static List<Header_Sheet__c> getManuallyCreatedHeaderSheets() {
    //     return [
    //         SELECT Id, Header__c, Sheet__c, isManuallyCreated__c, Status__c, CreatedDate, Requester__c, isPolluted__c
    //         FROM Header_Sheet__c
    //         WHERE
    //             isManuallyCreated__c = TRUE
    //             AND Header__r.Notification__c = NULL
    //             AND Header__r.Order__c = NULL
    //             AND IsDeleted__c = FALSE
    //         WITH SECURITY_ENFORCED
    //         ORDER BY CreatedDate DESC
    //     ];
    // }

    private static List<Header_Sheet__c> getManuallyCreatedHeaderSheetsFilter(
        Integer loadLimit,
    Map<String,String> filterMap
    )
    {
        system.debug('filter='+ filterMap);
        List<String> filterCondition = new List<String>();


        if(filterMap.containsKey('Create_Date_From__c')) {
            filterCondition.add('CreatedDate >= ' + THOR_NotificationListPagingCtrl.datetimeGmtString(String.valueOf(filterMap.get('Create_Date_From__c')), false));
        }
        if(filterMap.containsKey('Create_Date_To__c')) {
            filterCondition.add('CreatedDate <= ' + THOR_NotificationListPagingCtrl.datetimeGmtString(String.valueOf(filterMap.get('Create_Date_To__c')), true));
        }

        if (filterMap.containsKey('Check_Sheet_Code__c')) filterMap.put('Sheet__r.Sheet_Code__c', filterMap.remove('Check_Sheet_Code__c'));
        if (filterMap.containsKey('Check_Sheet_Name__c')) filterMap.put('Sheet__r.Form_Name__c', filterMap.remove('Check_Sheet_Name__c'));
        if (filterMap.containsKey('Equipment__c')) filterMap.put('Header__r.Equipment__r.Name', filterMap.remove('Equipment__c'));
        if (filterMap.containsKey('Notification_Number__c')) filterMap.put('Header__r.Notification__r.Notification_Number__c', filterMap.remove('Notification_Number__c'));
        if (filterMap.containsKey('Functional_Location__c')) filterMap.put('Header__r.FunctionalLocation__r.Name', filterMap.remove('Functional_Location__c'));
        if (filterMap.containsKey('Order_Number__c')) filterMap.put('Header__r.Order__r.Order_Number__c', filterMap.remove('Order_Number__c'));
        if (filterMap.containsKey('Maintenance_Plant__c')) filterMap.put('Header__r.Maintenance_PlantText__c', filterMap.remove('Maintenance_Plant__c'));
        if (filterMap.containsKey('Location__c')) filterMap.put('Header__r.LocationText__c', filterMap.remove('Location__c'));
        if (filterMap.containsKey('Plant_Section__c')) filterMap.put('Header__r.Plant_SectionText__c', filterMap.remove('Plant_Section__c'));
        if (filterMap.containsKey('Main_Work_Center__c')) filterMap.put('Header__r.Main_Work_CenterText__c', filterMap.remove('Main_Work_Center__c'));

        if (filterMap.containsKey('Requester__c')){
            String Requester =  filterMap.remove('Requester__c'); // Employee Id or Fullname
            Boolean haveStar= Requester.contains('*');


                Requester = String.valueOf(Requester).replace('*', '%');
                if(!Requester.contains('%')) {
                    Requester = '%' + Requester + '%';
                }
                String employeeId = Requester;

                // val = String.valueOf(val).replace('*', '%');
                List<String> users = new List<String>();
                for (User u : [SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :employeeId LIMIT 10]) {
                    users.add('\'' + u.Name + '\'');
                }

                if (users.size() > 0) {
                    filterCondition.add(String.format('({0} OR Requester__c IN ({1}))', new List<String>{
                        conditionQuery('Requester__c', 'LIKE', Requester), String.join(users, ',')
                    }));
                } else {
                    filterCondition.add(String.format('({0})', new List<String>{
                        conditionQuery('Requester__c', 'LIKE', Requester)
                    }));
                }


        }




        // if (filterMap.containsKey('Requester__c')){

        //     String Requester =  filterMap.get('Requester__c');

        //     List<User> userByName = [SELECT Id, Name FROM User WHERE Name=: Requester LIMIT 1];

        //     if (userByName.size() == 0)
        //     {
        //         List<User> userByEmp = [SELECT Id, Employee_Id__c, Name FROM User WHERE Employee_Id__c=: Requester LIMIT 1];
        //         if (userByEmp.size() == 1){
        //             filterMap.put('Requester__c', userByEmp[0].Name);
        //         }

        //     }
        // }


         // if (filterMap.containsKey('Requester__c')) filterMap.put('Header__r.Requester__c', filterMap.remove('Requester__c'));
        // if (filterMap.containsKey('Requester__c')) {
        //     String val = String.valueOf(filterMap.remove('Requester__c'));
        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
        //         conditionQuery('Header__r.Order__r.Requester__r.Employee_Id__c', 'LIKE', val),
        //         conditionQuery('Requester__c', 'LIKE', val)
        //     }));
        // }


        // if(filterMap.containsKey('Main_Work_Center__c')) {
        //     String val = String.valueOf(filterMap.remove('Main_Work_Center__c'))?.replace('*', '%'); // no value to be null
        //     val = val.startsWith('%') ? val : '%' + val;
        //     val = val.endsWith('%') ? val : val + '%';
        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
        //         conditionQuery('Header__r.Notification__r.Main_Work_Center__r.Code__c', 'LIKE', val),
        //         conditionQuery('Header__r.Order__r.Main_Work_Center__r.Code__c ', 'LIKE', val)
        //     }));
        // }
        // if(filterMap.containsKey('Maintenance_Plant__c')) {
        //     String val = String.valueOf(filterMap.remove('Maintenance_Plant__c'))?.replace('*', '%'); // no value to be null
        //     val = val.startsWith('%') ? val : '%' + val;
        //     val = val.endsWith('%') ? val : val + '%';
        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
        //         conditionQuery('Header__r.Notification__r.mainWorkCenterPlant__r.Code__c', 'LIKE', val),
        //         conditionQuery('Header__r.Order__r.mainWorkCenterPlant__r.Code__c ', 'LIKE', val)
        //     }));
        // }
        // if(filterMap.containsKey('Location__c')) {
        //     String val = String.valueOf(filterMap.remove('Location__c'))?.replace('*', '%'); // no value to be null
        //     val = val.startsWith('%') ? val : '%' + val;
        //     val = val.endsWith('%') ? val : val + '%';
        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
        //         conditionQuery('Header__r.Notification__r.Location__c', 'LIKE', val),
        //         conditionQuery('Header__r.Order__r.Location__c ', 'LIKE', val)
        //     }));
        // }
        // if(filterMap.containsKey('Plant_Section__c')) {
        //     String val = String.valueOf(filterMap.remove('Plant_Section__c'))?.replace('*', '%'); // no value to be null
        //     val = val.startsWith('%') ? val : '%' + val;
        //     val = val.endsWith('%') ? val : val + '%';
        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
        //         conditionQuery('Header__r.Notification__r.Plant_Section__c', 'LIKE', val),
        //         conditionQuery('Header__r.Order__r.Plant_Section__c', 'LIKE', val)
        //     }));
        // }


            System.debug('filterMapKK=:'+ filterMap);

            Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe()
                .get('Header_Sheet__c'.toLowerCase())
                .getDescribe()
                .fields
                .getMap();
            system.debug('sObjectField:='+ sObjectField);
            for (String f : filterMap.keySet()) {
                if (!sObjectField.containsKey(f) && !f.contains('__r')) {

                    filterMap.remove(f);
                }
            }
            System.debug('filterMap=:'+ filterMap);

            for(String keyApiName : filterMap.keySet()) {
                Object value = filterMap.get(keyApiName);
                if(value == null) continue;


                if(sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
                    filterCondition.add(String.format('{0} {1} {2}', new List<Object>{ keyApiName, '=' , (Boolean)value }));
                }
                else if(sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
                    filterCondition.add(conditionQuery(keyApiName, '=', String.valueOf(value)));
                }
                else {
                    // String val = String.valueOf(value).replace('*', '%');
                    // val = val.startsWith('%') ? val : '%' + val;
                    // val = val.endsWith('%') ? val : val + '%';
                    filterCondition.add(conditionQuery(keyApiName, 'LIKE', String.valueOf(value)));
                }

            }
            for (String item : filterCondition){
                system.debug('filterItemCondition: ' + item);
            }


            String query = String.format(
                'SELECT {0} FROM Header_Sheet__c ' +
                'WHERE isManuallyCreated__c = TRUE AND Header__r.Notification__c = NULL AND Header__r.Order__c = NULL AND IsDeleted__c = FALSE {1} ' +
                'ORDER BY CreatedDate DESC LIMIT ' + loadLimit,
                new List<String> {
                    String.join(new List<String>{
                        'Id',
                        'Name',
                        'Sheet__c',
                        // 'Equipment__r.Name',
                        'Status__c',
                        'Requester__c',
                        'Header__c',
                        'isManuallyCreated__c',
                        'CreatedDate',
                        'isPolluted__c'

                    }, ','),
                filterCondition.size() > 0 ? String.format('AND {0}', new List<String>{ // condition optional
                        String.join(filterCondition, ' AND ')
                    }) : ''
                }
            );

        System.debug('SQL => ' + query);


            Map<Id, Header_Sheet__c> sheets = new Map<Id, Header_Sheet__c>((List<Header_Sheet__c>)Database.query(query));
            System.debug('SHEETs'+ sheets);
            List<Header_Sheet__c> newHeaderList = new List<Header_Sheet__c>();
            for (Id key : sheets.Keyset()){
                newHeaderList.add(sheets.get(key));
            }

            return newHeaderList;
        }

    // private static List<Header_Sheet__c> getInProgressHeaderSheets() {
    //     return [
    //         SELECT Id, Header__c, Sheet__c, isManuallyCreated__c, Status__c, CreatedDate, Requester__c, isPolluted__c
    //         FROM Header_Sheet__c
    //         WHERE
    //             Status__c != :Constants.CHECKED_SHEETS.STATUS_APPROVED
    //             AND Status__c != :Constants.CHECKED_SHEETS.STATUS_REJECTED
    //             AND (Header__r.Notification__c != NULL
    //             OR Header__r.Order__c != NULL)
    //             AND IsDeleted__c = FALSE
    //         WITH SECURITY_ENFORCED
    //         ORDER BY CreatedDate DESC
    //     ];
    // }


    private static List<Header_Sheet__c> getInProgressHeaderSheetsFilter(
    //Integer loadLimit,
    Map<String,String> filterMap)
    {
        List<String> filterCondition = new List<String>();
        if(filterMap.containsKey('Create_Date_From__c')) {
            filterCondition.add('CreatedDate >= ' + THOR_NotificationListPagingCtrl.datetimeGmtString(String.valueOf(filterMap.get('Create_Date_From__c')), false));
        }
        if(filterMap.containsKey('Create_Date_To__c')) {
            filterCondition.add('CreatedDate <= ' + THOR_NotificationListPagingCtrl.datetimeGmtString(String.valueOf(filterMap.get('Create_Date_To__c')), true));
        }

        if (filterMap.containsKey('Check_Sheet_Code__c')) filterMap.put('Sheet__r.Sheet_Code__c', filterMap.remove('Check_Sheet_Code__c'));
        if (filterMap.containsKey('Check_Sheet_Name__c')) filterMap.put('Sheet__r.Form_Name__c', filterMap.remove('Check_Sheet_Name__c'));
        if (filterMap.containsKey('Equipment__c')) filterMap.put('Header__r.Equipment__r.Name', filterMap.remove('Equipment__c'));
        if (filterMap.containsKey('Notification_Number__c')) filterMap.put('Header__r.Notification__r.Notification_Number__c', filterMap.remove('Notification_Number__c'));
        if (filterMap.containsKey('Functional_Location__c')) filterMap.put('Header__r.FunctionalLocation__r.Name', filterMap.remove('Functional_Location__c'));
        if (filterMap.containsKey('Order_Number__c')) filterMap.put('Header__r.Order__r.Order_Number__c', filterMap.remove('Order_Number__c'));
        if (filterMap.containsKey('Maintenance_Plant__c')) filterMap.put('Header__r.Maintenance_PlantText__c', filterMap.remove('Maintenance_Plant__c'));
        if (filterMap.containsKey('Location__c')) filterMap.put('Header__r.LocationText__c', filterMap.remove('Location__c'));
        if (filterMap.containsKey('Plant_Section__c')) filterMap.put('Header__r.Plant_SectionText__c', filterMap.remove('Plant_Section__c'));
        if (filterMap.containsKey('Main_Work_Center__c')) filterMap.put('Header__r.Main_Work_CenterText__c', filterMap.remove('Main_Work_Center__c'));

        if (filterMap.containsKey('Requester__c')){
            String Requester =  filterMap.remove('Requester__c'); // Employee Id or Fullname
            Boolean haveStar= Requester.contains('*');


                Requester = String.valueOf(Requester).replace('*', '%');
                if(!Requester.contains('%')) {
                    Requester = '%' + Requester + '%';
                }
                String employeeId = Requester;

                // val = String.valueOf(val).replace('*', '%');
                List<String> users = new List<String>();
                for (User u : [SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :employeeId LIMIT 10]) {
                    users.add('\'' + u.Name + '\'');
                }

                if (users.size() > 0) {
                    filterCondition.add(String.format('({0} OR Requester__c IN ({1}))', new List<String>{
                        conditionQuery('Requester__c', 'LIKE', Requester), String.join(users, ',')
                    }));
                } else {
                    filterCondition.add(String.format('({0})', new List<String>{
                        conditionQuery('Requester__c', 'LIKE', Requester)
                    }));
                }


        }

        Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe()
            .get('Header_Sheet__c'.toLowerCase())
            .getDescribe()
            .fields
            .getMap();
        for (String f : filterMap.keySet()) {
            if (!sObjectField.containsKey(f) && !f.contains('__r')) {
                filterMap.remove(f);
            }
        }

        for(String keyApiName : filterMap.keySet()) {
            Object value = filterMap.get(keyApiName);
            if(value == null) continue;
            System.debug('Value='+ value);
            System.debug('keyApiName='+ keyApiName);

            if(sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
                filterCondition.add(String.format('{0} {1} {2}', new List<Object>{ keyApiName, '=' , (Boolean)value }));
            }
            else if(sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
                filterCondition.add(conditionQuery(keyApiName, '=', String.valueOf(value)));
            }
            else {
                // String val = String.valueOf(value).replace('*', '%');
                // val = val.startsWith('%') ? val : '%' + val;
                // val = val.endsWith('%') ? val : val + '%';
                filterCondition.add(conditionQuery(keyApiName, 'LIKE', String.valueOf(value)));
            }
        }

        system.debug('filterMapInprogress'+ filterMap);
        for (String item : filterCondition){
            system.debug('filterItemCondition: ' + item);
        }

        String query = String.format(
            'SELECT {0} FROM Header_Sheet__c ' +
            // 'WHERE  Status__c != :Constants.CHECKED_SHEETS.STATUS_APPROVED AND Status__c != :Constants.CHECKED_SHEETS.STATUS_REJECTED AND (Header__r.Notification__c != NULL OR Header__r.Order__c != NULL)  AND IsDeleted__c = FALSE' ,
            'WHERE (Header__r.Notification__c != NULL OR Header__r.Order__c != NULL) AND IsDeleted__c = FALSE {1}' +
            'ORDER BY CreatedDate DESC LIMIT 50000',
            new List<String> {
                String.join(new List<String>{
                    'Id',
                    'Name',
                    'Sheet__c',
                    // 'Equipment__r.Name',
                    'Status__c',
                    'Requester__c',
                    'Header__c',
                    'isManuallyCreated__c',
                    'CreatedDate',
                    'isPolluted__c'
                    // 'Sheet__r.Form_Name__c'

                }, ','),
            filterCondition.size() > 0 ? String.format('AND {0}', new List<String>{ // condition optional
                    String.join(filterCondition, ' AND ')
                }) : ''
            }
        );

        System.debug('INPROGRESSQUERY:=' + query);
        Map<Id, Header_Sheet__c> sheets = new Map<Id, Header_Sheet__c>((List<Header_Sheet__c>)Database.query(query));

        List<Header_Sheet__c> newInprogressHeaderList = new List<Header_Sheet__c>();
        for (Id key : sheets.Keyset()){
            newInprogressHeaderList.add(sheets.get(key));
        }

        return newInprogressHeaderList;
    }

    private static Map<EQCC_Header__c, Set<CheckedSheetWrapper>> buildSheetsByHeader(
        Map<Id, EQCC_Header__c> headers,
        List<Header_Sheet__c> headerSheets,
        Map<Id, EQCC_Checked_Sheet__c> sheets
    ) {
        Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = new Map<EQCC_Header__c, Set<CheckedSheetWrapper>>();

        for (Header_Sheet__c headerSheet : headerSheets) {
            if (headers.keySet().contains(headerSheet.Header__c)) {
                if (!sheetsByHeader.containsKey(headers.get(headerSheet.Header__c))) {
                    sheetsByHeader.put(
                        headers.get(headerSheet.Header__c),
                        new Set<CheckedSheetWrapper>{
                            new CheckedSheetWrapper(
                                sheets.get(headerSheet.Sheet__c),
                                headerSheet.Status__c,
                                headerSheet.Requester__c,
                                Date.valueOf(headerSheet.CreatedDate),
                                headerSheet.isManuallyCreated__c,
                                headerSheet.Id,
                                headerSheet.isPolluted__c,
                                headerSheet.Name
                            )
                        }
                    );
                } else {
                    sheetsByHeader.get(headers.get(headerSheet.Header__c))
                        .add(
                            new CheckedSheetWrapper(
                                sheets.get(headerSheet.Sheet__c),
                                headerSheet.Status__c,
                                headerSheet.Requester__c,
                                Date.valueOf(headerSheet.CreatedDate),
                                headerSheet.isManuallyCreated__c,
                                headerSheet.Id,
                                headerSheet.isPolluted__c,
                                headerSheet.Name
                            )
                        );
                }
            }
        }
        for (Id headerId : headers.keySet()) {
            if (!sheetsByHeader.containsKey(headers.get(headerId))) {
                sheetsByHeader.put(headers.get(headerId), new Set<CheckedSheetWrapper>());
            }
        }
        return sheetsByHeader;
    }

    private static List<HeaderSheetWrapper> createHeaderSheetWrapper(
        Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader
    ) {
        List<HeaderSheetWrapper> wrappers = new List<HeaderSheetWrapper>();
        for (EQCC_Header__c header : sheetsByHeader.keySet()) {
            wrappers.add(new HeaderSheetWrapper(header, new List<CheckedSheetWrapper>(sheetsByHeader.get(header))));
        }

        return wrappers;
    }

    private static EQCC_Step__c getStepById(Id stepId) {
        return [
            SELECT Id, Status__c, Header_Sheet__c, Percentage__c
            FROM EQCC_Step__c
            WHERE Id = :stepId
            WITH SECURITY_ENFORCED
        ];
    }

    private static Header_Sheet__c getHeaderSheetById(Id headerSheetId) {
        return [
            SELECT Id, Status__c, Rejection_Reason__c, Percentage__c, Requester__c, isPolluted__c
            FROM Header_Sheet__c
            WHERE Id = :headerSheetId
            WITH SECURITY_ENFORCED
        ];
    }
}