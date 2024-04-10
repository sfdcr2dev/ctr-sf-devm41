/* Author Softever */
global with sharing class ESS_RecommendationLetter {

    private static string userId = ESS_PrivilegeHandler.getUserId();
    private static boolean isAdmin = ESS_PrivilegeHandler.checkRecommendationLetterAdminUser(userId);
    private static ESS_RecommendationLetter_DTO.RecommendationLetterCountDTO recommendationLetterCount;
    private static List<ESS_RecommendationLetter_DTO.RecommendationLetterListDTO> recommendationLetterLists;
    private static ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO recommendationLetter;

    @RemoteAction
    public static integer GetRecommendationLetterListsCount(RecommendationLetterSearchCriteria filter) {
        
        
        List<ESS_Letter_of_Recommendation__c> Letters = new List<ESS_Letter_of_Recommendation__c>();
        List<ESS_Letter_of_Recommendation__c> finalLetters = new List<ESS_Letter_of_Recommendation__c>();
        
        string query = 'select id, document_no__c, current_status__c, letter_type__c, to_organization__c, createddate, Generate_PDF_Date__c from ESS_Letter_of_Recommendation__c where OwnerId =: userId';
        
        //filter.letterType
        if(!string.isEmpty(filter.letterType) && !string.isBlank(filter.letterType) && filter.letterType.toLowerCase() != 'all') {
            string letterType = filter.letterType;
            query = query + ' AND letter_type__c =: letterType';
        }
        //filter.organization
        if(!string.isEmpty(filter.organization) && !string.isBlank(filter.organization) && filter.organization.toLowerCase() != 'all') {
            string organization = filter.organization;
            query = query + ' AND to_organization__c =: organization';
        }
        //filter.letterStatus
        if(!string.isEmpty(filter.letterStatus) && !string.isBlank(filter.letterStatus) && filter.letterStatus.toLowerCase() != 'all') {
            string letterStatus = filter.letterStatus;
            query = query + ' AND current_status__c =: letterStatus';
        }
        
        //filter.startCreatedDate
        datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
        query = query + ' AND ((createddate >=: startCreatedDate';
        //filter.endCreatedDate
        datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        query = query + ' AND createddate <=: endCreatedDate)';
        
        //filter.startGeneratedToPDF
        date startGeneratedToPDF = Date.ValueOf(filter.startGeneratedToPDF);
        query = query + ' OR (generate_pdf_date__c >=: startGeneratedToPDF';
        //filter.endGeneratedToPDF
        date endGeneratedToPDF = Date.ValueOf(filter.endGeneratedToPDF);
        query = query + ' AND generate_pdf_date__c <=: endGeneratedToPDF))';
        
        Letters = Database.query(query);
        integer letterCount = letters.size();
        return letterCount;
    }
    
    @RemoteAction
    public static ESS_RecommendationLetter_DTO.RecommendationLetterCountDTO GetRecommendationLetterCount(RecommendationLetterSearchCriteria filter) {
        
        recommendationLetterCount = new ESS_RecommendationLetter_DTO.RecommendationLetterCountDTO();
        recommendationLetterCount.total = 0;
        recommendationLetterCount.requested = 0;
        recommendationLetterCount.remaining = 0;
        
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        
        recommendationLetterCount.companyName = PISUser.COMPANYNAME__c;
        
        List<ESS_Letter_of_Recommendation__c> Letters = new List<ESS_Letter_of_Recommendation__c>();
        
        string query = 'select id, document_no__c, current_status__c, letter_type__c, to_organization__c, createddate, Generate_PDF_Date__c from ESS_Letter_of_Recommendation__c where OwnerId =: userId';
        
        //filter.letterType
        if(!string.isEmpty(filter.letterType) && !string.isBlank(filter.letterType) && filter.letterType.toLowerCase() != 'all') {
            string letterType = filter.letterType;
            query = query + ' AND letter_type__c =: letterType';
        }
        //filter.organization
        if(!string.isEmpty(filter.organization) && !string.isBlank(filter.organization) && filter.organization.toLowerCase() != 'all') {
            string organization = filter.organization;
            query = query + ' AND to_organization__c =: organization';
        }
        //filter.letterStatus
        if(!string.isEmpty(filter.letterStatus) && !string.isBlank(filter.letterStatus) && filter.letterStatus.toLowerCase() != 'all') {
            string letterStatus = filter.letterStatus;
            query = query + ' AND current_status__c =: letterStatus';
        }
        
        //filter.startCreatedDate
        datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
        query = query + ' AND ((createddate >=: startCreatedDate';
        //filter.endCreatedDate
        datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        query = query + ' AND createddate <=: endCreatedDate)';
        
        //filter.startGeneratedToPDF
        date startGeneratedToPDF = Date.ValueOf(filter.startGeneratedToPDF);
        query = query + ' OR (generate_pdf_date__c >=: startGeneratedToPDF';
        //filter.endGeneratedToPDF
        date endGeneratedToPDF = Date.ValueOf(filter.endGeneratedToPDF);
        query = query + ' AND generate_pdf_date__c <=: endGeneratedToPDF))';
        
        Letters = Database.query(query);
        
        //Total Setting for Letter
        ESS_Setting__c Setting = GetESSSetting();
        
        if(PISUser.COMPANYNAME__c == 'TOP') {
            recommendationLetterCount.total = Integer.ValueOf(Setting.Letter_TOP_Request__c);
        }
        else if(PISUser.COMPANYNAME__c == 'TES') {
            recommendationLetterCount.total = Integer.ValueOf(Setting.Letter_TES_Request__c);
        }
        
        if(Letters.size() > 0) {
            
            integer currentMonth = date.today().month();
            
            for(ESS_Letter_of_Recommendation__c Letter : Letters) {
                
                //Check Total only for current month
                if(currentMonth == Letter.createddate.month()) {
                    if(Letter.current_status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF)) {
                        recommendationLetterCount.requested++;
                    }
                }
            }
            
            recommendationLetterCount.remaining = recommendationLetterCount.total - recommendationLetterCount.requested;
        }
        else {
            recommendationLetterCount.remaining = recommendationLetterCount.total;
        }
        
        if(recommendationLetterCount.remaining < 0) {
            recommendationLetterCount.remaining = 0;
        }
        
        recommendationLetterCount.canCreate = true;
        if(recommendationLetterCount.requested == recommendationLetterCount.total) {
            recommendationLetterCount.canCreate = false;
        }
         
        return recommendationLetterCount;
    }
    
    @RemoteAction
    public static List<ESS_RecommendationLetter_DTO.RecommendationLetterListDTO> GetRecommendationLetterLists(RecommendationLetterSearchCriteria filter,
        //documentNo, letterType, language, purpose, toOrganization, createdDate, generatedDate, currentStatus
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        List<ESS_RecommendationLetter_DTO.RecommendationLetterListDTO> results = new List<ESS_RecommendationLetter_DTO.RecommendationLetterListDTO>();
        List<ESS_Letter_of_Recommendation__c> Letters = new List<ESS_Letter_of_Recommendation__c>();
        List<ESS_Letter_of_Recommendation__c> existLetters = new List<ESS_Letter_of_Recommendation__c>();
        
        string query = 'select id, document_no__c, current_status__c, language__c, letter_purpose__c, letter_type__c, to_organization__c, createddate, Generate_PDF_Date__c from ESS_Letter_of_Recommendation__c where OwnerId =: userId';
        
        /* if(isAdmin) {
        	query = 'select id, document_no__c, current_status__c, language__c, letter_purpose__c, letter_type__c, to_organization__c, createddate, Generate_PDF_Date__c from ESS_Letter_of_Recommendation__c where OwnerId != null';
        } */
        
        //filter.letterType
        if(!string.isEmpty(filter.letterType) && !string.isBlank(filter.letterType) && filter.letterType.toLowerCase() != 'all') {
            string letterType = filter.letterType;
            query = query + ' AND letter_type__c =: letterType';
        }
        //filter.organization
        if(!string.isEmpty(filter.organization) && !string.isBlank(filter.organization) && filter.organization.toLowerCase() != 'all') {
            string organization = filter.organization;
            query = query + ' AND to_organization__c =: organization';
        }
        //filter.letterStatus
        if(!string.isEmpty(filter.letterStatus) && !string.isBlank(filter.letterStatus) && filter.letterStatus.toLowerCase() != 'all') {
            string letterStatus = filter.letterStatus;
            query = query + ' AND current_status__c =: letterStatus';
        }
        
        //filter.startCreatedDate
        datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
        query = query + ' AND ((createddate >=: startCreatedDate';
        //filter.endCreatedDate
        datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        query = query + ' AND createddate <=: endCreatedDate)';
        
        //filter.startGeneratedToPDF
        date startGeneratedToPDF = Date.ValueOf(filter.startGeneratedToPDF);
        query = query + ' OR (generate_pdf_date__c >=: startGeneratedToPDF';
        //filter.endGeneratedToPDF
        date endGeneratedToPDF = Date.ValueOf(filter.endGeneratedToPDF);
        query = query + ' AND generate_pdf_date__c <=: endGeneratedToPDF))';
        
        //Sort By    
        if(sortByParam.sortBy == 'documentNo') {
        	if(sortByParam.ascending) {
                Letters = database.query(query + ' order by document_no__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Letters = database.query(query + ' order by document_no__c desc');
            }
        }
        else if(sortByParam.sortBy == 'letterType') {
            if(sortByParam.ascending) {
                Letters = database.query(query + ' order by letter_type__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by letter_type__c desc');
            }
        }
        else if(sortByParam.sortBy == 'language') {
            if(sortByParam.ascending) {
                Letters = database.query(query + ' order by language__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by language__c desc');
            }
        }
        else if(sortByParam.sortBy == 'purpose') {
            if(sortByParam.ascending) {
                Letters = database.query(query + ' order by letter_purpose__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by letter_purpose__c desc');
            }
        }
        else if(sortByParam.sortBy == 'toOrganization') {
            if(sortByParam.ascending) {
                Letters = database.query(query + ' order by to_organization__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by to_organization__c desc');
            }
        }
        else if(sortByParam.sortBy == 'createdDate') {
            if(sortByParam.ascending) {
                Letters = database.query(query + ' order by createddate asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by createddate desc');
            }
        }
        else if(sortByParam.sortBy == 'generatedDate') {
            if(sortByParam.ascending) {
                Letters = database.query(query + ' order by Generate_PDF_Date__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by Generate_PDF_Date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'currentStatus') {
            if(sortByParam.ascending) {
                Letters = database.query(query + ' order by current_status__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by current_status__c desc');
            }
        }
        else {
            Letters = database.query(query + ' order by document_no__c desc');
        }
            
        if(Letters.size() > 0) {
            
            for(ESS_Letter_of_Recommendation__c Letter : Letters) {
                
                boolean isInDateRange = false;
                
                if(Letter.Generate_PDF_Date__c != null && (Letter.Generate_PDF_Date__c >= startGeneratedToPDF && Letter.Generate_PDF_Date__c <= endGeneratedToPDF)) {
                    isInDateRange = true;
                }
                
                existLetters.add(Letter);
            }
        }
            
        Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        Integer totalSize = Letters.size() - startIndex;
        for (Integer i = 0; i < pageParam.pageSize; i++ ) {
            if (i < totalSize){
                results.add(assignToRecommendationLetterListDTO(Letters[startIndex + i]));
            }else{
                break;
            }
        }
            
        return results;
            
    }
    
    @RemoteAction
    public static ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO GetRecommendationLetterDetail(string letterId, string letterType) {
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        recommendationLetter = new ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO();
        
        //Total Setting for Letter
        ESS_Setting__c Setting = GetESSSetting();
        
        integer currentMonth = date.today().Month();
        integer requestedCount = 0;
        
        List<ESS_Letter_of_Recommendation__c> Letters = [select id, Current_Status__c, CreatedDate from ESS_Letter_of_Recommendation__c where OwnerId =: userId];
        if(Letters.size() > 0) {
            for(ESS_Letter_of_Recommendation__c Letter : Letters) {
                if(Letter.CreatedDate.month() == currentMonth && Letter.Current_Status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF)) {
                    requestedCount++;
                }
            }
        }
        
        if(letterId == null || letterId == 'null') {
            
            if(PISUser.COMPANYNAME__c == 'TOP') {
                recommendationLetter.letterLogo = Setting.Letter_TOP_Logo__c;
                recommendationLetter.letterHRPosition = Setting.Letter_TOP_HR_Position__c;
                recommendationLetter.letterHRPositionTH = Setting.Letter_TOP_HR_Position_TH__c;
                recommendationLetter.letterHRNameTH = Setting.Letter_TOP_HR_Name_TH__c;
                recommendationLetter.letterHRNameEN = Setting.Letter_TOP_HR_Name_EN__c;
                recommendationLetter.letterHRSignatureTH = Setting.Letter_TOP_HR_Signature_TH__c;
                recommendationLetter.letterHRSignatureEN = Setting.Letter_TOP_HR_Signature_EN__c;
                recommendationLetter.letterStamp = Setting.Letter_TOP_HR_Stamp__c;
            }
            else if(PISUser.COMPANYNAME__c == 'TES') {
                recommendationLetter.letterLogo = Setting.Letter_TES_Logo__c;
                recommendationLetter.letterHRPosition = Setting.Letter_TES_HR_Position__c;
                recommendationLetter.letterHRPositionTH = Setting.Letter_TES_HR_Position_TH__c;
                recommendationLetter.letterHRNameTH = Setting.Letter_TES_HR_Name_TH__c;
                recommendationLetter.letterHRNameEN = Setting.Letter_TES_HR_Name_EN__c;
                recommendationLetter.letterHRSignatureTH = Setting.Letter_TES_HR_Signature_TH__c;
                recommendationLetter.letterHRSignatureEN = Setting.Letter_TES_HR_Signature_EN__c;
                recommendationLetter.letterStamp = Setting.Letter_TES_HR_Stamp__c;
            }
            
            ESS_Master_Employee__c Master = [select id, employee_id__c, Name_Emp_TH_Title_FN_LN__c, Name_Emp_EN_Title__c, Name_Emp_EN_FN__c, Name_Emp_EN_LN__c, Position__c, Unit__c, employee_date_joined__c from ESS_Master_Employee__c where employee_id__c =: PISUser.EMPLOYEEID__c AND Data__c = 'IN'];
            
            recommendationLetter.employeeId = Master.Employee_ID__c;
            
            recommendationLetter.gender = getGender(Master.Name_Emp_EN_Title__c);
            
            string title = assignSFTitle(Master.Name_Emp_EN_Title__c);
            if(title == 'Ms') {
                title = 'Miss';
            }
            else if(title != 'Miss') {
                title += '.';
            }
            recommendationLetter.employeeName = title + ' ' + Master.Name_Emp_EN_FN__c + ' ' + Master.Name_Emp_EN_LN__c;
            
            string thName = '';
            if(PISUser.THTITLE__c == 'นาย' || PISUser.THTITLE__c == 'นาง') {
                thName = PISUser.THTITLE__c + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            }
            else if(PISUser.THTITLE__c == 'น.ส.') {
                thName = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            }
            
            recommendationLetter.employeeNameTH = thName;
            recommendationLetter.companyName = PISUser.COMPANYNAME__c;
            recommendationLetter.position = PISUser.OBJENFULLNAME__c;
            recommendationLetter.positionTH = PISUser.OBJTHFULLNAME__c;
            recommendationLetter.function = PISUser.FUNCTION__c;
            recommendationLetter.department = PISUser.DEPARTMENT__c;
            if(string.isNotEmpty(PISUser.DEPTFULLTH__c)) {
                recommendationLetter.departmentFullTH = PISUser.DEPTFULLTH__c;
            }
            else {
                recommendationLetter.departmentFullTH = ' ';
            }
            if(string.isNotEmpty(PISUser.DEPTFULLEN__c)) {
                recommendationLetter.departmentFullEN = PISUser.DEPTFULLEN__c;
            }
            else {
                recommendationLetter.departmentFullEN = ' ';
            }
            recommendationLetter.section = PISUser.SECTIONS__c;
            recommendationLetter.unit = PISUser.UNITS__c;
            recommendationLetter.dateJoinedCompany = Master.Employee_Date_Joined__c;
            
            recommendationLetter.canCreate = true;
            if(recommendationLetter.companyName == 'TOP') {
                if(requestedCount >= Setting.Letter_TOP_Request__c) {
                    recommendationLetter.canCreate = false;
                }
                recommendationLetter.remaining = Integer.ValueOf(Setting.Letter_TOP_Request__c - requestedCount);
            }
            else if(recommendationLetter.companyName == 'TES') {
                if(requestedCount >= Setting.Letter_TES_Request__c) {
                    recommendationLetter.canCreate = false;
                }
                recommendationLetter.remaining = Integer.ValueOf(Setting.Letter_TES_Request__c - requestedCount);
            }
            
            string enLetterType;
            
            recommendationLetter.letterType = new ESS_Global.EnumValue('RecommendationLetterType');
            if(letterType == ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name()) {
                recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
                recommendationLetter.letterType.value = 'จดหมายรับรองเงินเดือน (สำหรับทำธุรกรรมทางการเงิน)';
            }
            else if(letterType == ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name()) {
                recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name();
                recommendationLetter.letterType.value = 'จดหมายรับรองเงินเดือน แบบระบุวันลา (สำหรับยื่นขอ Visa)';
            }
            else if(letterType == ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name()) {
                recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name();
                recommendationLetter.letterType.value = 'จดหมายรับรองเงินเดือน แบบไม่ระบุวันลา (สำหรับยื่นขอ Visa)';
               
                recommendationLetter.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
                recommendationLetter.language.key = ESS_Enum.RecommendationLetterLanguage.English.name();
                recommendationLetter.language.value = 'ภาษาอังกฤษ';
            }
            else if(letterType == ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name()) {
                recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name();
                recommendationLetter.letterType.value = 'จดหมายรับรองการทำงาน ไม่ระบุเงินเดือน';
            }
            else if(letterType == ESS_Enum.RecommendationLetterType.GrantedLetter.name()) {
                recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.GrantedLetter.name();
                recommendationLetter.letterType.value = 'จดหมายผ่านสิทธิ์ (สำหรับทำธุรกรรมกับธนาคาร ธอส.)';
            }
            
        }
        else if(letterId != null || letterId != 'null') {
            
        	ESS_Letter_of_Recommendation__c Letter = [select id, document_no__c, employee_id__c, Employee_Name_TH__c, Position_TH__c, position__c, unit__c, employee_name__c, current_status__c, language__c, other_organization__c,
                                                      letter_purpose__c, letter_type__c, to_organization__c, createddate, Generate_PDF_Date__c, date_joined_company__c, leave_start__c, leave_end__c, gender__c, company_name__c,
                                                      department_full_th__c, department_full_en__c from ESS_Letter_of_Recommendation__c where Id =: letterId];
            
            recommendationLetter = assignToRecommendationLetterDetailDTO(Letter);
            
            if(isAdmin) {
                if(Letter.Company_Name__c == 'TOP') {
                    recommendationLetter.letterLogo = Setting.Letter_TOP_Logo__c;
                    recommendationLetter.letterHRPosition = Setting.Letter_TOP_HR_Position__c;
                    recommendationLetter.letterHRPositionTH = Setting.Letter_TOP_HR_Position_TH__c;
                    recommendationLetter.letterHRNameTH = Setting.Letter_TOP_HR_Name_TH__c;
                    recommendationLetter.letterHRNameEN = Setting.Letter_TOP_HR_Name_EN__c;
                    recommendationLetter.letterHRSignatureTH = Setting.Letter_TOP_HR_Signature_TH__c;
                    recommendationLetter.letterHRSignatureEN = Setting.Letter_TOP_HR_Signature_EN__c;
                    recommendationLetter.letterStamp = Setting.Letter_TOP_HR_Stamp__c;
                }
                else if(Letter.Company_Name__c == 'TES') {
                    recommendationLetter.letterLogo = Setting.Letter_TES_Logo__c;
                    recommendationLetter.letterHRPosition = Setting.Letter_TES_HR_Position__c;
                    recommendationLetter.letterHRPositionTH = Setting.Letter_TES_HR_Position_TH__c;
                    recommendationLetter.letterHRNameTH = Setting.Letter_TES_HR_Name_TH__c;
                    recommendationLetter.letterHRNameEN = Setting.Letter_TES_HR_Name_EN__c;
                    recommendationLetter.letterHRSignatureTH = Setting.Letter_TES_HR_Signature_TH__c;
                    recommendationLetter.letterHRSignatureEN = Setting.Letter_TES_HR_Signature_EN__c;
                    recommendationLetter.letterStamp = Setting.Letter_TES_HR_Stamp__c;
                }
            }
            else {
                if(PISUser.COMPANYNAME__c == 'TOP') {
                    recommendationLetter.letterLogo = Setting.Letter_TOP_Logo__c;
                    recommendationLetter.letterHRPosition = Setting.Letter_TOP_HR_Position__c;
                    recommendationLetter.letterHRPositionTH = Setting.Letter_TOP_HR_Position_TH__c;
                    recommendationLetter.letterHRNameTH = Setting.Letter_TOP_HR_Name_TH__c;
                    recommendationLetter.letterHRNameEN = Setting.Letter_TOP_HR_Name_EN__c;
                    recommendationLetter.letterHRSignatureTH = Setting.Letter_TOP_HR_Signature_TH__c;
                    recommendationLetter.letterHRSignatureEN = Setting.Letter_TOP_HR_Signature_EN__c;
                    recommendationLetter.letterStamp = Setting.Letter_TOP_HR_Stamp__c;
                }
                else if(PISUser.COMPANYNAME__c == 'TES') {
                    recommendationLetter.letterLogo = Setting.Letter_TES_Logo__c;
                    recommendationLetter.letterHRPosition = Setting.Letter_TES_HR_Position__c;
                    recommendationLetter.letterHRPositionTH = Setting.Letter_TES_HR_Position_TH__c;
                    recommendationLetter.letterHRNameTH = Setting.Letter_TES_HR_Name_TH__c;
                    recommendationLetter.letterHRNameEN = Setting.Letter_TES_HR_Name_EN__c;
                    recommendationLetter.letterHRSignatureTH = Setting.Letter_TES_HR_Signature_TH__c;
                    recommendationLetter.letterHRSignatureEN = Setting.Letter_TES_HR_Signature_EN__c;
                    recommendationLetter.letterStamp = Setting.Letter_TES_HR_Stamp__c;
                }
            }
            
            recommendationLetter.canCreate = true;
            if(recommendationLetter.companyName == 'TOP') {
                if(requestedCount >= Setting.Letter_TOP_Request__c) {
                    recommendationLetter.canCreate = false;
                }
                recommendationLetter.remaining = Integer.ValueOf(Setting.Letter_TOP_Request__c - requestedCount);
            }
            else if(recommendationLetter.companyName == 'TES') {
                if(requestedCount >= Setting.Letter_TES_Request__c) {
                    recommendationLetter.canCreate = false;
                }
                recommendationLetter.remaining = Integer.ValueOf(Setting.Letter_TES_Request__c - requestedCount);
            }
            
        }
        
        return recommendationLetter;
    }
    
    @RemoteAction
    public static ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO SaveRecommendationLetter(ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO letter) {
        
        try {
            
            if(letter.letterId == null || letter.letterId == 'null') {
                
                letter.letterStatus = new ESS_Global.EnumValue('RecommendationLetterStatus');
                letter.letterStatus.key = ESS_Enum.RecommendationLetterStatus.Created.name();
                letter.letterStatus.value = 'Created';
                
                string year = ESS_LogicHandler.GetCurrentYear();
                string month = ESS_LogicHandler.GetCurrentMonth();
                
                if(letter.letterType.key == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial)) {
                    string runningNo = ESS_LogicHandler.GenerateRunningNo('Letter LR1');
                    letter.documentNo = 'LR1-' + year + '-' + month + '-' + runningNo;
                }
                else if(letter.letterType.key == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa)) {
                    string runningNo = ESS_LogicHandler.GenerateRunningNo('Letter LR2');
                    letter.documentNo = 'LR2-' + year + '-' + month + '-' + runningNo;
                }
                else if(letter.letterType.key == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa)) {
                    string runningNo = ESS_LogicHandler.GenerateRunningNo('Letter LR3');
                    letter.documentNo = 'LR3-' + year + '-' + month + '-' + runningNo;
                }
                else if(letter.letterType.key == String.ValueOf(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary)) {
                    string runningNo = ESS_LogicHandler.GenerateRunningNo('Letter LR4');
                    letter.documentNo = 'LR4-' + year + '-' + month + '-' + runningNo;
                }
                else if(letter.letterType.key == String.ValueOf(ESS_Enum.RecommendationLetterType.GrantedLetter)) {
                    string runningNo = ESS_LogicHandler.GenerateRunningNo('Letter LR5');
                    letter.documentNo = 'LR5-' + year + '-' + month + '-' + runningNo;
                }
                
                ESS_Letter_of_Recommendation__c SaveLetter = new ESS_Letter_of_Recommendation__c();
                SaveLetter.Gender__c = letter.gender;
                SaveLetter.Employee_ID__c = letter.employeeId;
                SaveLetter.Employee_Name__c = letter.employeeName;
                SaveLetter.Employee_Name_TH__c = letter.employeeNameTH;
                SaveLetter.Company_Name__c = letter.companyName;
                SaveLetter.Position__c = letter.position;
                SaveLetter.Position_TH__c = letter.positionTH;
                SaveLetter.Function__c = letter.function;
                SaveLetter.Department__c = letter.department;
                SaveLetter.Department_Full_TH__c = letter.departmentFullTH;
                SaveLetter.Department_Full_EN__c = letter.departmentFullEN;
                SaveLetter.Section__c = letter.section;
                SaveLetter.Unit__c = letter.unit;
                SaveLetter.Date_Joined_Company__c = letter.dateJoinedCompany;
                SaveLetter.Document_No__c = letter.documentNo;
                SaveLetter.Letter_Type__c = String.ValueOf(letter.letterType.key);
                SaveLetter.Current_Status__c = String.ValueOf(letter.letterStatus.key);
                SaveLetter.Language__c = String.ValueOf(letter.language.key);
                SaveLetter.letter_purpose__c = letter.purpose;
                SaveLetter.To_Organization__c = letter.organization;
                SaveLetter.Other_Organization__c = letter.otherOrganization;
                SaveLetter.Leave_Start__c = letter.startLeaveDate;
                SaveLetter.Leave_End__c = letter.endLeaveDate;
                SaveLetter.OwnerId = userId;
                insert(SaveLetter);
                
                letter.letterId = SaveLetter.Id;
                
            }
            else if(letter.letterId != null || letter.letterId != 'null') {
                
                ESS_Letter_of_Recommendation__c SaveLetter = [select id, document_no__c, current_status__c, language__c, letter_purpose__c, letter_type__c, to_organization__c, createddate, 
                                                              Generate_PDF_Date__c, Function__c, Department__c, Section__c, Unit__c, Department_Full_TH__c, Department_Full_EN__c from ESS_Letter_of_Recommendation__c where Id =: letter.letterId];
        		
                SaveLetter.Employee_ID__c = Letter.employeeId;
                SaveLetter.Gender__c = letter.gender;
                SaveLetter.Employee_Name__c = Letter.employeeName;
                SaveLetter.Employee_Name_TH__c = Letter.employeeNameTH;
                SaveLetter.Company_Name__c = Letter.companyName;
                SaveLetter.Position__c = Letter.position;
                SaveLetter.Position_TH__c = Letter.positionTH;
                SaveLetter.Function__c = Letter.function;
                SaveLetter.Department__c = Letter.department;
                SaveLetter.Department_Full_TH__c = letter.departmentFullTH;
                SaveLetter.Department_Full_EN__c = letter.departmentFullEN;
                SaveLetter.Section__c = Letter.section;
                SaveLetter.Unit__c = Letter.unit;
                SaveLetter.Letter_Type__c = String.ValueOf(letter.letterType.key);
                SaveLetter.Current_Status__c = String.ValueOf(letter.letterStatus.key);
                SaveLetter.Language__c = String.ValueOf(letter.language.key);
                SaveLetter.letter_purpose__c = letter.purpose;
                SaveLetter.To_Organization__c = letter.organization;
                SaveLetter.Other_Organization__c = letter.otherOrganization;
                SaveLetter.Leave_Start__c = letter.startLeaveDate;
                SaveLetter.Leave_End__c = letter.endLeaveDate;
                SaveLetter.Date_Joined_Company__c = Letter.dateJoinedCompany;
                
                update(SaveLetter);
            }
        }
        catch(DmlException e) {
            System.debug('Save Letter exception has occurred: ' + e.getMessage());
        }
        
        return letter;
    }
    
    @RemoteAction
    public static void DeleteRecommendationLetter(string letterId) {
        
        ESS_Letter_of_Recommendation__c Letter = [select id from ESS_Letter_of_Recommendation__c where Id =: letterId];
        delete(Letter);
        
    }
    
    @RemoteAction
    public static void GenerateRecommendationLetter(string letterId, string letterType) {
        
        ESS_Letter_of_Recommendation__c Letter = [select id from ESS_Letter_of_Recommendation__c where Id =: letterId];
        Letter.Current_Status__c = String.ValueOf(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF);
        Letter.Generate_PDF_Date__c = date.today();
        update(Letter);
        
    }
    
    @RemoteAction
    public static ESS_Service.MonthlyDTO MonthlyIncome(string employeeId) {
        ESS_Service.MonthlyDTO MW = new ESS_Service.MonthlyDTO();
        MW = ESS_Service.MonthlyIncomeSOAPAPI(employeeId);
        return MW;
    }
    
    //Assign to DTO section
    @TestVisible
    private static ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO assignToRecommendationLetterDetailDTO(ESS_Letter_of_Recommendation__c Letter) {
        
        ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO recommendationLetter = new ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO();
        
        recommendationLetter.letterId = Letter.Id;
        recommendationLetter.gender = Letter.Gender__c;
        recommendationLetter.companyName = Letter.Company_Name__c;
        recommendationLetter.employeeId = Letter.Employee_ID__c;
        recommendationLetter.employeeName = Letter.Employee_Name__c;
        recommendationLetter.employeeNameTH = Letter.Employee_Name_TH__c;
        recommendationLetter.position = Letter.Position__c;
        recommendationLetter.positionTH = Letter.Position_TH__c;
        if(string.isNotEmpty(Letter.Department_Full_TH__c)) {
            recommendationLetter.departmentFullTH = Letter.Department_Full_TH__c;
        }
        else {
            recommendationLetter.departmentFullTH = '' ;
        }
		if(string.isNotEmpty(Letter.Department_Full_EN__c)) {
            recommendationLetter.departmentFullEN = Letter.Department_Full_EN__c;
        }
        else {
            recommendationLetter.departmentFullEN = '' ;
        }          
        recommendationLetter.unit = Letter.Unit__c;
        recommendationLetter.dateJoinedCompany = Letter.Date_Joined_Company__c;
        recommendationLetter.documentNo = Letter.Document_No__c;
        
        if(Letter.CreatedDate == null) {
            recommendationLetter.createdDate = date.today();
        }
        else {
            recommendationLetter.createdDate = Letter.CreatedDate.date();
        }
        
        recommendationLetter.generatedDate = Letter.Generate_PDF_Date__c;
        
        recommendationLetter.letterStatus = new ESS_Global.EnumValue('RecommendationLetterStatus');
        if(Letter.Current_Status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.Created)) {
            recommendationLetter.letterStatus.key = ESS_Enum.RecommendationLetterStatus.Created.name();
            recommendationLetter.letterStatus.value = 'Created';
        }
        else if(Letter.Current_Status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF)) {
            recommendationLetter.letterStatus.key = ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name();
            recommendationLetter.letterStatus.value = 'Generated To PDF';
        }
        
        recommendationLetter.letterType = new ESS_Global.EnumValue('RecommendationLetterType');
        if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial)) {
            recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
            recommendationLetter.letterType.value = 'จดหมายรับรองเงินเดือน (สำหรับทำธุรกรรมทางการเงิน)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa)) {
            recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name();
            recommendationLetter.letterType.value = 'จดหมายรับรองเงินเดือน แบบระบุวันลา (สำหรับยื่นขอ Visa)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa)) {
            recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name();
            recommendationLetter.letterType.value = 'จดหมายรับรองเงินเดือน แบบไม่ระบุวันลา (สำหรับยื่นขอ Visa)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary)) {
            recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name();
            recommendationLetter.letterType.value = 'จดหมายรับรองการทำงาน ไม่ระบุเงินเดือน';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.GrantedLetter)) {
            recommendationLetter.letterType.key = ESS_Enum.RecommendationLetterType.GrantedLetter.name();
            recommendationLetter.letterType.value = 'จดหมายผ่านสิทธิ์ (สำหรับทำธุรกรรมกับธนาคาร ธอส.)';
        }
        
        recommendationLetter.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
        if(Letter.Language__c == String.ValueOf(ESS_Enum.RecommendationLetterLanguage.Thai)) {
            recommendationLetter.language.key = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            recommendationLetter.language.value = 'ภาษาไทย';
        }
        else if(Letter.Language__c == String.ValueOf(ESS_Enum.RecommendationLetterLanguage.English)) {
            recommendationLetter.language.key = ESS_Enum.RecommendationLetterLanguage.English.name();
            recommendationLetter.language.value = 'ภาษาอังกฤษ';
        }
        
        recommendationLetter.purpose = Letter.letter_purpose__c;
        recommendationLetter.organization = Letter.to_organization__c;
        recommendationLetter.otherOrganization = Letter.other_organization__c;
        
        if(Letter.Leave_Start__c != null) {
        	recommendationLetter.startLeaveDate = Letter.Leave_Start__c;
        }
        if(Letter.Leave_End__c != null) {
        	recommendationLetter.endLeaveDate = Letter.Leave_End__c;
        }
        
        if(Letter.to_organization__c == 'Other') {
            recommendationLetter.isShowOtherOrganization = true;
        }
        
        return recommendationLetter;
    }
    
    @TestVisible
    private static ESS_RecommendationLetter_DTO.RecommendationLetterListDTO assignToRecommendationLetterListDTO(ESS_Letter_of_Recommendation__c Letter) {
    
        ESS_RecommendationLetter_DTO.RecommendationLetterListDTO RecommendLetter = new ESS_RecommendationLetter_DTO.RecommendationLetterListDTO();
        
        RecommendLetter.letterId = Letter.Id;
        RecommendLetter.documentNo = Letter.Document_No__c;
        
        RecommendLetter.letterType = new ESS_Global.EnumValue('RecommendationLetterType');
        if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial)) {
            RecommendLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
            RecommendLetter.letterType.value = 'จดหมายรับรองเงินเดือน (สำหรับทำธุรกรรมทางการเงิน)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa)) {
            RecommendLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name();
            RecommendLetter.letterType.value = 'จดหมายรับรองเงินเดือน แบบระบุวันลา (สำหรับยื่นขอ Visa)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa)) {
            RecommendLetter.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name();
            RecommendLetter.letterType.value = 'จดหมายรับรองเงินเดือน แบบไม่ระบุวันลา (สำหรับยื่นขอ Visa)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary)) {
            RecommendLetter.letterType.key = ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name();
            RecommendLetter.letterType.value = 'จดหมายรับรองการทำงาน ไม่ระบุเงินเดือน';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.GrantedLetter)) {
            RecommendLetter.letterType.key = ESS_Enum.RecommendationLetterType.GrantedLetter.name();
            RecommendLetter.letterType.value = 'จดหมายผ่านสิทธิ์ (สำหรับทำธุรกรรมกับธนาคาร ธอส.)';
        }
        
        RecommendLetter.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
        if(Letter.Language__c == String.ValueOf(ESS_Enum.RecommendationLetterLanguage.Thai)) {
            RecommendLetter.language.key = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            RecommendLetter.language.value = 'ภาษาไทย';
        }
        else if(Letter.Language__c == String.ValueOf(ESS_Enum.RecommendationLetterLanguage.English)) {
            RecommendLetter.language.key = ESS_Enum.RecommendationLetterLanguage.English.name();
            RecommendLetter.language.value = 'ภาษาอังกฤษ';
        }
        
		RecommendLetter.purpose = Letter.Letter_Purpose__c;
        RecommendLetter.toOrganization = Letter.To_Organization__c;
        RecommendLetter.createdDate = Letter.CreatedDate;
        RecommendLetter.generatedDate = Letter.Generate_PDF_Date__c;
        
        RecommendLetter.letterStatus = new ESS_Global.EnumValue('RecommendationLetterStatus');
        if(Letter.Current_Status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.Created)) {
            RecommendLetter.letterStatus.key = ESS_Enum.RecommendationLetterStatus.Created.name();
            RecommendLetter.letterStatus.value = 'Created';
        }
        else if(Letter.Current_Status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF)) {
            RecommendLetter.letterStatus.key = ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name();
            RecommendLetter.letterStatus.value = 'Generated To PDF';
        }
        
        RecommendLetter.canDelete = true;
        
        return RecommendLetter;
    
    }
    
    private static ESS_Setting__c GetESSSetting() {
        
        ESS_Setting__c Setting = [select id, letter_top_logo__c, letter_tes_logo__c, letter_top_hr_name__c, letter_tes_hr_name__c,
                                  letter_top_hr_name_th__c, letter_tes_hr_name_th__c, letter_top_hr_name_en__c, letter_tes_hr_name_en__c, letter_top_hr_signature_th__c, letter_tes_hr_signature_th__c, 
                                  letter_top_hr_signature_en__c, letter_tes_hr_signature_en__c, letter_top_hr_stamp__c, letter_tes_hr_stamp__c, letter_top_request__c, letter_tes_request__c,
                                  letter_top_hr_position__c, letter_top_hr_position_th__c, letter_tes_hr_position__c, letter_tes_hr_position_th__c from ESS_Setting__c]; 
        
        return Setting;
        
    }
    
    private static string assignSFTitle(string title) {
        string sfTitle;
        
        if(title == '1') {
            sfTitle = 'Mr';
        } 
        else if(title == '2') {
            sfTitle = 'Mrs';
        }
        else if(title == '3') {
            sfTitle = 'Ms';
        }  
        else if(title == '4') {
            sfTitle = 'Miss';
        } 
        else if(title == '5') {
            sfTitle = 'Dr';
        }
        
        return sfTitle;
    }
    
    private static string getGender(string title) {
        string gender;
        
        if(title == '1') {
            gender = 'Male';
        } 
        else if(title == '2') {
            gender = 'Female';
        }
        else if(title == '3') {
            gender = 'Female';
        }  
        else if(title == '4') {
            gender = 'Female';
        } 
        
        return gender;
    }
    
    @RemoteAction
    public static List<string> GetLetterTypes() {
        
        List<string> letterTypes = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Letter_of_Recommendation__c.Letter_Type__c .getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            letterTypes.add(objPickList.getLabel());
            System.debug('Value = ' +objPickList.getValue() +' , Label = ' +objPickList.getLabel());
        }
        System.debug(letterTypes);
        return letterTypes;
    }
    
    @RemoteAction
    public static List<string> GetOrganizations(string letterType) {
        
        List<string> organizations = new List<string>();
        Map<String, List<String>> getAllOrganizations = getDependentPicklistValues();
        
        if(getAllOrganizations.size() > 0) {
             
            for(string letter : getAllOrganizations.keyset())
            {
                if(letter == letterType) {
                    for(string org : getAllOrganizations.get(letter)) { 
                        organizations.add(org);
                    }
                }
            }
        }
        
        return organizations;
    }
    
    @RemoteAction
    public static List<string> GetENOrganizations(string letterType) {
        
        List<string> organizations = new List<string>();
        Map<String, List<String>> getAllOrganizations = getDependentPicklistENValues();
        
        if(getAllOrganizations.size() > 0) {
             
            for(string letter : getAllOrganizations.keyset())
            {
                if(letter == letterType) {
                    for(string org : getAllOrganizations.get(letter)) { 
                        organizations.add(org);
                        system.debug(org);
                    }
                }
            }
        }
        
        return organizations;
    }
    
    public static Map<String, List<String>> getDependentPicklistValues() {
        
        Schema.DescribeFieldResult depend = ESS_Letter_of_Recommendation__c.To_Organization__c.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        
        return dependentPicklistValues;
    }
    
    public static Map<String, List<String>> getDependentPicklistENValues() {
        
        Schema.DescribeFieldResult depend = ESS_Letter_of_Recommendation__c.To_Organization_EN__c.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        
        return dependentPicklistValues;
    }
    
    public class RecommendationLetterSearchCriteria {
        //enum RecommendationLetterType
        @RemoteAction
        public string letterType {get;set;}
        @RemoteAction
        public string organization {get;set;}
        //enum RecommendationLetterType
        @RemoteAction
        public string letterStatus {get;set;}
        @RemoteAction
        public datetime startCreatedDate {get;set;}
        @RemoteAction
        public datetime endCreatedDate {get;set;}
        @RemoteAction
        public datetime startGeneratedToPDF {get;set;}
        @RemoteAction
        public datetime endGeneratedToPDF {get;set;}
    }
    
    
}