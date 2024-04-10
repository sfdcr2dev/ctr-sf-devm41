/* Author Softever */
global with sharing class ESS_RecommendationLetterReport {

    private static List<ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO> recommendationLetterTables;
    private static ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphDTO recommendationLetterGraph;
    
    static {
    }
    
    //RecommendationLetter
    @RemoteAction
    public static string UserViewPrivilege() {
        
        string privilege = '';
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkRecommendationLetterAdminUser(userId);
        boolean isTOPAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTOPAdminUser(userId);
        boolean isTESAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTESAdminUser(userId);
        
        if(isAdmin) {
            privilege = 'All';
        }
        else if(isTOPAdmin) {
            privilege = 'TOP';
        }
        else if(isTESAdmin) {
            privilege = 'TES';
        }
        
        return privilege;
    }
    
    @RemoteAction
    public static ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphDTO GetRecommendationLetterGraph(RecommendationLetterSearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkRecommendationLetterAdminUser(userId);
        boolean isTOPAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTOPAdminUser(userId);
        boolean isTESAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTESAdminUser(userId);
        
        recommendationLetterGraph = new ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphDTO();
        
        List<ESS_Letter_of_Recommendation__c> Letters = new List<ESS_Letter_of_Recommendation__c>();
            
        string query = 'select id, document_no__c, company_name__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, company_name__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where OwnerId != null';
        } 
        else if(isTOPAdmin || isTESAdmin) {
            string companyName = '';
            if(isTOPAdmin) {
                companyName = 'TOP';
            }
            else if(isTESAdmin) {
                companyName = 'TES';
            }
            query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where company_name__c = :companyName';
        }
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }
            
        //filter.companyName
        if(string.isNotEmpty(filter.companyName) && filter.companyName.toLowerCase() != 'all') {
        	string companyName = filter.companyName;
            query = query + ' AND company_name__c =: companyName';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
        }
            
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        }
           
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.RecommendationLetterStatus.Created.name());
            statuses.add(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name());
            isCheckStatus = true;
        }
        else {
            //filter.statusCreated
            if(filter.statusCreated) {
            	statuses.add(ESS_Enum.RecommendationLetterStatus.Created.name());
            	isCheckStatus = true;
            }
            //filter.statusGeneratedToPDF
            if(filter.statusGeneratedToPDF) {
            	statuses.add(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name());
            	isCheckStatus = true;
            }
        } 
        
        if(isCheckStatus) {
        	query = query + ' AND current_status__c IN: statuses';  
        } 
        
        //filter.letterTypeAll
        List<string> letterTypes = new List<string>();
        boolean isCheckLetterType = false;
        if(filter.letterTypeAll) {
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.GrantedLetter.name());
            isCheckLetterType = true;
        }
        else {
            //filter.letterTypeSalaryLetterForFinancial
            if(filter.letterTypeSalaryLetterForFinancial) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeSalaryLetterWithLeaveForVisa
            if(filter.letterTypeSalaryLetterWithLeaveForVisa) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeSalaryLetterWithoutLeaveForVisa
            if(filter.letterTypeSalaryLetterWithoutLeaveForVisa) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeWorkLetterWithoutSalary
            if(filter.letterTypeWorkLetterWithoutSalary) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeGrantedLetter
            if(filter.letterTypeGrantedLetter) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.GrantedLetter.name());
                isCheckLetterType = true;
            }
        }
        
        if(isCheckLetterType) {
        	query = query + ' AND letter_type__c IN: letterTypes';
        }
            
        //filter.startCreatedDate
        datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
        query = query + ' AND ((createddate >=: startCreatedDate';
        //filter.endCreatedDate
        datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        query = query + ' AND createddate <=: endCreatedDate)';
            
        //filter.startGeneratedPDFDate
        date startGeneratedPDFDate = filter.startGeneratedPDFDate;
        query = query + ' OR (generate_pdf_date__c >=: startGeneratedPDFDate';
        //filter.endGeneratedPDFDate
        date endGeneratedPDFDate = filter.endGeneratedPDFDate;
        query = query + ' AND generate_pdf_date__c <=: endGeneratedPDFDate))';
        
		//Final query
		Letters = Database.query(query);
        
        if(Letters.size() > 0) {
            
            recommendationLetterGraph.categories = new List<string>();
            recommendationLetterGraph.categories.add('จดหมายรับรองเงินเดือน (สำหรับทำธุรกรรมทางการเงิน)');
            recommendationLetterGraph.categories.add('จดหมายรับรองเงินเดือน แบบระบุวันเวลา (สำหรับยื่นขอ Visa)');
            recommendationLetterGraph.categories.add('จดหมายรับรองเงินเดือน แบบไม่ระบุวันเวลา (สำหรับยื่นขอ Visa)');
            recommendationLetterGraph.categories.add('จดหมายรับรองการทำงาน ไม่ระบุเงินเดือน');
            recommendationLetterGraph.categories.add('จดหมายผ่านสิทธิ์ (สำหรับทำธุรกรรมกับธนาคาร ธอส.)');
            
            recommendationLetterGraph.series = new List<ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphSeriesDTO>();
            
            decimal percentTOPSalaryLetterForFinancial = 0;
            integer totalTOPSalaryLetterForFinancial = 0;
            decimal percentTOPSalaryLetterWithLeaveForVisa = 0;
            integer totalTOPSalaryLetterWithLeaveForVisa = 0;
            decimal percentTOPSalaryLetterWithoutLeaveForVisa = 0;
            integer totalTOPSalaryLetterWithoutLeaveForVisa = 0;
            decimal percentTOPWorkLetterWithoutSalary = 0;
            integer totalTOPWorkLetterWithoutSalary = 0;
            decimal percentTOPGrantedLetter = 0;
            integer totalTOPGrantedLetter = 0;
            
            decimal percentTESSalaryLetterForFinancial = 0;
            integer totalTESSalaryLetterForFinancial = 0;
            decimal percentTESSalaryLetterWithLeaveForVisa = 0;
            integer totalTESSalaryLetterWithLeaveForVisa = 0;
            decimal percentTESSalaryLetterWithoutLeaveForVisa = 0;
            integer totalTESSalaryLetterWithoutLeaveForVisa = 0;
            decimal percentTESWorkLetterWithoutSalary = 0;
            integer totalTESWorkLetterWithoutSalary = 0;
            decimal percentTESGrantedLetter = 0;
            integer totalTESGrantedLetter = 0;
            
            integer total = 0;
            
            ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphSeriesDTO topSerie = new ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphSeriesDTO();
            topSerie.type = 'column';
            topSerie.name = 'TOP';
            topSerie.data = new List<integer>();
            topSerie.color = '#e99bd2';
            topSerie.custom = new List<decimal>();
            
            ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphSeriesDTO tesSerie = new ESS_RecommendationLetterReport_DTO.RecommendationLetterGraphSeriesDTO();
            tesSerie.type = 'column';
            tesSerie.name = 'TES';
            tesSerie.data = new List<integer>();
            tesSerie.color = '#79a0fc';
            tesSerie.custom = new List<decimal>();
            
            total = Letters.size();
            
            for(ESS_Letter_of_Recommendation__c Letter : Letters) {
                
                if(Letter.Company_Name__c == 'TOP') {
                    
                    if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name()) {
                        totalTOPSalaryLetterForFinancial++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name()) {
                        totalTOPSalaryLetterWithLeaveForVisa++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name()) {
                        totalTOPSalaryLetterWithoutLeaveForVisa++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name()) {
                        totalTOPWorkLetterWithoutSalary++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.GrantedLetter.name()) {
                        totalTOPGrantedLetter++;
                    }

                }
                else if(Letter.Company_Name__c == 'TES') {
                    if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name()) {
                        totalTESSalaryLetterForFinancial++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name()) {
                        totalTESSalaryLetterWithLeaveForVisa++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name()) {
                        totalTESSalaryLetterWithoutLeaveForVisa++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name()) {
                        totalTESWorkLetterWithoutSalary++;
                    }
                    else if(Letter.Letter_Type__c == ESS_Enum.RecommendationLetterType.GrantedLetter.name()) {
                        totalTESGrantedLetter++;
                    }
                }
                
            }
            
            if(total > 0) {
                percentTOPSalaryLetterForFinancial = ((Decimal.ValueOf(totalTOPSalaryLetterForFinancial) * 100) / total).setScale(2);
                percentTESSalaryLetterForFinancial = ((Decimal.ValueOf(totalTESSalaryLetterForFinancial) * 100) / total).setScale(2);
                percentTOPSalaryLetterWithLeaveForVisa = ((Decimal.ValueOf(totalTOPSalaryLetterWithLeaveForVisa) * 100) / total).setScale(2);
                percentTESSalaryLetterWithLeaveForVisa = ((Decimal.ValueOf(totalTESSalaryLetterWithLeaveForVisa) * 100) / total).setScale(2);
                percentTOPSalaryLetterWithoutLeaveForVisa = ((Decimal.ValueOf(totalTOPSalaryLetterWithoutLeaveForVisa) * 100) / total).setScale(2);
                percentTESSalaryLetterWithoutLeaveForVisa = ((Decimal.ValueOf(totalTESSalaryLetterWithoutLeaveForVisa) * 100) / total).setScale(2);
                percentTOPWorkLetterWithoutSalary = ((Decimal.ValueOf(totalTOPWorkLetterWithoutSalary) * 100) / total).setScale(2);
                percentTESWorkLetterWithoutSalary = ((Decimal.ValueOf(totalTESWorkLetterWithoutSalary) * 100) / total).setScale(2);
                percentTOPGrantedLetter = ((Decimal.ValueOf(totalTOPGrantedLetter) * 100) / total).setScale(2);
                percentTESGrantedLetter = ((Decimal.ValueOf(totalTESGrantedLetter) * 100) / total).setScale(2);
            }
            
            //TOP
            topSerie.data.add(totalTOPSalaryLetterForFinancial);
            topSerie.custom.add(percentTOPSalaryLetterForFinancial);
            topSerie.data.add(totalTOPSalaryLetterWithLeaveForVisa);
            topSerie.custom.add(percentTOPSalaryLetterWithLeaveForVisa);
            topSerie.data.add(totalTOPSalaryLetterWithoutLeaveForVisa);
            topSerie.custom.add(percentTOPSalaryLetterWithoutLeaveForVisa);
            topSerie.data.add(totalTOPWorkLetterWithoutSalary);
            topSerie.custom.add(percentTOPWorkLetterWithoutSalary);
            topSerie.data.add(totalTOPGrantedLetter);
            topSerie.custom.add(percentTOPGrantedLetter);
            
            //TES
            tesSerie.data.add(totalTESSalaryLetterForFinancial);
            tesSerie.custom.add(percentTESSalaryLetterForFinancial);
            tesSerie.data.add(totalTESSalaryLetterWithLeaveForVisa);
            tesSerie.custom.add(percentTESSalaryLetterWithLeaveForVisa);
            tesSerie.data.add(totalTESSalaryLetterWithoutLeaveForVisa);
            tesSerie.custom.add(percentTESSalaryLetterWithoutLeaveForVisa);
            tesSerie.data.add(totalTESWorkLetterWithoutSalary);
            tesSerie.custom.add(percentTESWorkLetterWithoutSalary);
            tesSerie.data.add(totalTESGrantedLetter);
            tesSerie.custom.add(percentTESGrantedLetter);
            
            recommendationLetterGraph.series.add(topSerie);
            recommendationLetterGraph.series.add(tesSerie);
            
        }
        
        return recommendationLetterGraph;
        
    }
    
    @RemoteAction
    public static integer GetRecommendationLetterTableCount(RecommendationLetterSearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkRecommendationLetterAdminUser(userId);
        boolean isTOPAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTOPAdminUser(userId);
        boolean isTESAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTESAdminUser(userId);
        
        recommendationLetterTables = new List<ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO>();
            
        List<ESS_Letter_of_Recommendation__c> Letters = new List<ESS_Letter_of_Recommendation__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where OwnerId != null';
        } 
        else if(isTOPAdmin || isTESAdmin) {
            string companyName = '';
            if(isTOPAdmin) {
                companyName = 'TOP';
            }
            else if(isTESAdmin) {
                companyName = 'TES';
            }
            query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where company_name__c = :companyName';
        }
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }
            
        //filter.companyName
        if(string.isNotEmpty(filter.companyName) && filter.companyName.toLowerCase() != 'all') {
        	string companyName = filter.companyName;
            query = query + ' AND company_name__c =: companyName';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
        }
            
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        }
           
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.RecommendationLetterStatus.Created.name());
            statuses.add(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name());
            isCheckStatus = true;
        }
        else {
            //filter.statusCreated
            if(filter.statusCreated) {
            	statuses.add(ESS_Enum.RecommendationLetterStatus.Created.name());
            	isCheckStatus = true;
            }
            //filter.statusGeneratedToPDF
            if(filter.statusGeneratedToPDF) {
            	statuses.add(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name());
            	isCheckStatus = true;
            }
        } 
        
        if(isCheckStatus) {
        	query = query + ' AND current_status__c IN: statuses';  
        } 
        
        //filter.letterTypeAll
        List<string> letterTypes = new List<string>();
        boolean isCheckLetterType = false;
        if(filter.letterTypeAll) {
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.GrantedLetter.name());
            isCheckLetterType = true;
        }
        else {
            //filter.letterTypeSalaryLetterForFinancial
            if(filter.letterTypeSalaryLetterForFinancial) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeSalaryLetterWithLeaveForVisa
            if(filter.letterTypeSalaryLetterWithLeaveForVisa) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeSalaryLetterWithoutLeaveForVisa
            if(filter.letterTypeSalaryLetterWithoutLeaveForVisa) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeWorkLetterWithoutSalary
            if(filter.letterTypeWorkLetterWithoutSalary) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeGrantedLetter
            if(filter.letterTypeGrantedLetter) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.GrantedLetter.name());
                isCheckLetterType = true;
            }
        }
        
        if(isCheckLetterType) {
        	query = query + ' AND letter_type__c IN: letterTypes';
        }
        
        //filter.startCreatedDate
        datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
        query = query + ' AND ((createddate >=: startCreatedDate';
        //filter.endCreatedDate
        datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        query = query + ' AND createddate <=: endCreatedDate)';
            
        //filter.startGeneratedPDFDate
        date startGeneratedPDFDate = filter.startGeneratedPDFDate;
        query = query + ' OR (generate_pdf_date__c >=: startGeneratedPDFDate';
        //filter.endGeneratedPDFDate
        date endGeneratedPDFDate = filter.endGeneratedPDFDate;
        query = query + ' AND generate_pdf_date__c <=: endGeneratedPDFDate))';
        
		//Final query
		Letters = Database.query(query); 
        
        integer totalSize = 0;

        if(Letters.size() > 0) {
            for(ESS_Letter_of_Recommendation__c Letter : Letters) {
                ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO LetterTable = new ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO();
                LetterTable = assignToRecommendationLetterTableDTO(Letter);
                if(string.isNotEmpty(LetterTable.documentNo)) {
                    totalSize++;
                }
            }
        }

        return totalSize;
        
    }
    
    @RemoteAction
    public static List<ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO> GetRecommendationLetterTables(RecommendationLetterSearchCriteria filter, 
        //documentNo, employeeId, employeeName, position, letterType, language, purpose, toOrganization, createdDate, generatedDate, function, department, section, unit
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkRecommendationLetterAdminUser(userId);
        boolean isTOPAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTOPAdminUser(userId);
        boolean isTESAdmin = ESS_PrivilegeHandler.checkRecommendationLetterTESAdminUser(userId);
                    
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        recommendationLetterTables = new List<ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO>();
            
        List<ESS_Letter_of_Recommendation__c> Letters = new List<ESS_Letter_of_Recommendation__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where OwnerId != null';
        } 
        else if(isTOPAdmin || isTESAdmin) {
            string companyName = '';
            if(isTOPAdmin) {
                companyName = 'TOP';
            }
            else if(isTESAdmin) {
                companyName = 'TES';
            }
            query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
            			'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
            			'from ESS_Letter_of_Recommendation__c where company_name__c = :companyName';
        }
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }
            
        //filter.companyName
        if(string.isNotEmpty(filter.companyName) && filter.companyName.toLowerCase() != 'all') {
        	string companyName = filter.companyName;
            query = query + ' AND company_name__c =: companyName';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
        }
            
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        }
            
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.RecommendationLetterStatus.Created.name());
            statuses.add(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name());
            isCheckStatus = true;
        }
        else {
            //filter.statusCreated
            if(filter.statusCreated) {
            	statuses.add(ESS_Enum.RecommendationLetterStatus.Created.name());
            	isCheckStatus = true;
            }
            //filter.statusGeneratedToPDF
            if(filter.statusGeneratedToPDF) {
            	statuses.add(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name());
            	isCheckStatus = true;
            }
        } 
        
        if(isCheckStatus) {
        	query = query + ' AND current_status__c IN: statuses';  
        } 
        
        //filter.letterTypeAll
        List<string> letterTypes = new List<string>();
        boolean isCheckLetterType = false;
        if(filter.letterTypeAll) {
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
            letterTypes.add(ESS_Enum.RecommendationLetterType.GrantedLetter.name());
            isCheckLetterType = true;
        }
        else {
            //filter.letterTypeSalaryLetterForFinancial
            if(filter.letterTypeSalaryLetterForFinancial) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeSalaryLetterWithLeaveForVisa
            if(filter.letterTypeSalaryLetterWithLeaveForVisa) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeSalaryLetterWithoutLeaveForVisa
            if(filter.letterTypeSalaryLetterWithoutLeaveForVisa) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeWorkLetterWithoutSalary
            if(filter.letterTypeWorkLetterWithoutSalary) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
                isCheckLetterType = true;
            }
            //filter.letterTypeGrantedLetter
            if(filter.letterTypeGrantedLetter) {
            	letterTypes.add(ESS_Enum.RecommendationLetterType.GrantedLetter.name());
                isCheckLetterType = true;
            }
        }
        
        if(isCheckLetterType) {
        	query = query + ' AND letter_type__c IN: letterTypes';
        }
        
        //filter.startCreatedDate
        datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
        query = query + ' AND ((createddate >=: startCreatedDate';
        //filter.endCreatedDate
        datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        query = query + ' AND createddate <=: endCreatedDate)';
            
        //filter.startGeneratedPDFDate
        date startGeneratedPDFDate = filter.startGeneratedPDFDate;
        query = query + ' OR (generate_pdf_date__c >=: startGeneratedPDFDate';
        //filter.endGeneratedPDFDate
        date endGeneratedPDFDate = filter.endGeneratedPDFDate;
        query = query + ' AND generate_pdf_date__c <=: endGeneratedPDFDate))';
        
        //Sort By    
        if(sortByParam.sortBy == 'documentNo') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by document_no__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by document_no__c desc');
            }
        }
        else if(sortByParam.sortBy == 'employeeId') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by employee_id__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by employee_id__c desc');
            }
        }
        else if(sortByParam.sortBy == 'employeeName') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by employee_name__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by employee_name__c desc');
            }
        }
        else if(sortByParam.sortBy == 'position') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by position__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by position__c desc');
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
        else if(sortByParam.sortBy == 'generatedPDF') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by generate_pdf_date__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by generate_pdf_date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'function') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by function__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by function__c desc');
            }
        }
        else if(sortByParam.sortBy == 'department') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by department__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by department__c desc');
            }
        }
        else if(sortByParam.sortBy == 'section') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by section__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by section__c desc');
            }
        }
        else if(sortByParam.sortBy == 'unit') {
        	if(sortByParam.ascending) {
       	    	Letters = database.query(query + ' order by unit__c asc');
            }
            else if(!sortByParam.ascending) {
                Letters = database.query(query + ' order by unit__c desc');
            }
        }
        else {
            Letters = database.query(query + ' order by document_no__c desc');
        }
        
        Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        integer totalSize = Letters.size() - startIndex;
        for (Integer i = 0; i < pageParam.pageSize; i++ ) {
            if (i < totalSize) {
                ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO LetterTable = new ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO();
                LetterTable = assignToRecommendationLetterTableDTO(Letters[startIndex + i]);
                if(string.isNotEmpty(LetterTable.documentNo)) {
                    recommendationLetterTables.add(LetterTable);
                }
            }else{
                break;
            }
        }
        
        return recommendationLetterTables;
                                                                                     
    }
    
    @RemoteAction
    public static string ExportRecommendationLetterExcel(RecommendationLetterSearchCriteria filter) {
        
        //TODO
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_RecommendationLetterReport_Excel?';
        
        string trackingReportType = 'Letter';
        string employeeId = filter.employeeId;
        string companyName = filter.companyName;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string unit = filter.unit;
        boolean statusAll = filter.statusAll;
        boolean statusCreated = filter.statusCreated;
        boolean statusGeneratedToPDF = filter.statusGeneratedToPDF;
        boolean letterTypeAll = filter.letterTypeAll;
        boolean letterTypeSalaryLetterForFinancial = filter.letterTypeSalaryLetterForFinancial;
        boolean letterTypeSalaryLetterWithLeaveForVisa = filter.letterTypeSalaryLetterWithLeaveForVisa;
        boolean letterTypeSalaryLetterWithoutLeaveForVisa = filter.letterTypeSalaryLetterWithoutLeaveForVisa;
        boolean letterTypeWorkLetterWithoutSalary = filter.letterTypeWorkLetterWithoutSalary;
        boolean letterTypeGrantedLetter = filter.letterTypeGrantedLetter;
        date startCreatedDate = filter.startCreatedDate;
        date endCreatedDate = filter.endCreatedDate;
        date startGeneratedPDFDate = filter.startGeneratedPDFDate;
        date endGeneratedPDFDate = filter.endGeneratedPDFDate;
        
        URL = URL + 'trackingReportType=' + trackingReportType + 
            		'&employeeId=' + employeeId + 
            		'&companyName=' + companyName + 
            		'&function=' + function + 
            		'&department=' + department + 
            		'&section=' + section + 
            		'&unit=' + unit + 
            		'&statusAll=' + statusAll + 
            		'&statusCreated=' + statusCreated + 
            		'&statusGeneratedToPDF=' + statusGeneratedToPDF + 
            		'&letterTypeAll=' + letterTypeAll + 
            		'&letterTypeSalaryLetterForFinancial=' + letterTypeSalaryLetterForFinancial + 
            		'&letterTypeSalaryLetterWithLeaveForVisa=' + letterTypeSalaryLetterWithLeaveForVisa + 
            		'&letterTypeSalaryLetterWithoutLeaveForVisa=' + letterTypeSalaryLetterWithoutLeaveForVisa + 
            		'&letterTypeWorkLetterWithoutSalary=' + letterTypeWorkLetterWithoutSalary + 
            		'&letterTypeGrantedLetter=' + letterTypeGrantedLetter + 
            		'&startCreatedDate=' + startCreatedDate + 
            		'&endCreatedDate=' + endCreatedDate + 
            		'&startGeneratedPDFDate=' + startGeneratedPDFDate + 
            		'&endGeneratedPDFDate=' + endGeneratedPDFDate;
        
        return URL;
    }
    
    //Assign to DTO section
    public static ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO assignToRecommendationLetterTableDTO(ESS_Letter_of_Recommendation__c Letter) {
        
        ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO LetterTable = new ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO();
        LetterTable.recordId = Letter.Id;
        LetterTable.documentNo = Letter.Document_No__c;
        LetterTable.employeeId = Letter.Employee_ID__c;
        LetterTable.employeeName = Letter.Employee_Name__c;
        LetterTable.position = Letter.Position__c;
        
        LetterTable.letterType = new ESS_Global.EnumValue('RecommendationLetterType');
        if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial)) {
            LetterTable.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
        	LetterTable.letterType.value = 'จดหมายรับรองเงินเดือน (สำหรับทำธุรกรรมทางการเงิน)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa)) {
            LetterTable.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name();
        	LetterTable.letterType.value = 'จดหมายรับรองเงินเดือน แบบระบุวันเวลา (สำหรับยื่นขอ Visa)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa)) {
            LetterTable.letterType.key = ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name();
        	LetterTable.letterType.value = 'จดหมายรับรองเงินเดือน แบบไม่ระบุวันเวลา (สำหรับยื่นขอ Visa)';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary)) {
            LetterTable.letterType.key = ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name();
        	LetterTable.letterType.value = 'จดหมายรับรองการทำงาน ไม่ระบุเงินเดือน';
        }
        else if(Letter.Letter_Type__c == String.ValueOf(ESS_Enum.RecommendationLetterType.GrantedLetter)) {
            LetterTable.letterType.key = ESS_Enum.RecommendationLetterType.GrantedLetter.name();
        	LetterTable.letterType.value = 'จดหมายผ่านสิทธิ์ (สำหรับทำธุรกรรมกับธนาคาร ธอส.)';
        }
        
        LetterTable.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
        if(Letter.Language__c == String.ValueOf(ESS_Enum.RecommendationLetterLanguage.Thai)) {
            LetterTable.language.key = ESS_Enum.RecommendationLetterLanguage.Thai.name();
        	LetterTable.language.value = 'ภาษาไทย';
        }
        else if(Letter.Language__c == String.ValueOf(ESS_Enum.RecommendationLetterLanguage.English)) {
            LetterTable.language.key = ESS_Enum.RecommendationLetterLanguage.English.name();
        	LetterTable.language.value = 'ภาษาอังกฤษ';
        }
        
        string purpose = '';
        if(string.isNotEmpty(Letter.letter_purpose__c)) {
        	LetterTable.purpose = Letter.letter_purpose__c;
        }
        else {
            LetterTable.purpose = purpose;
        }
        
        string toOrganization = '';
        if(string.isNotEmpty(Letter.To_Organization__c)) {
        	LetterTable.toOrganization = Letter.To_Organization__c;
        }
        else {
            LetterTable.toOrganization = toOrganization;
        }
        LetterTable.createdDate = Date.ValueOf(Letter.CreatedDate);
        LetterTable.generatedDate = Letter.Generate_PDF_Date__c;
        
        LetterTable.status = new ESS_Global.EnumValue('RecommendationLetterStatus');
        if(Letter.Current_Status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.Created)) {
            LetterTable.status.key = ESS_Enum.RecommendationLetterStatus.Created.name();
        	LetterTable.status.value = 'Created';
        }
        else if(Letter.Current_Status__c == String.ValueOf(ESS_Enum.RecommendationLetterStatus.GeneratedToPDF)) {
            LetterTable.status.key = ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name();
        	LetterTable.status.value = 'Generated To PDF';
        }
        
        LetterTable.function = Letter.Function__c;
        LetterTable.department = Letter.Department__c;
        LetterTable.section = Letter.Section__c;
        LetterTable.unit = Letter.Unit__c;
        
        return LetterTable;
        
    }
    
    @RemoteAction
    public static List<string> ESSGlobal_GetLevels() {
        List<string> Levels = ESS_Global.GetLevels();
        return Levels;
    }
    
    @RemoteAction
    public static List<string> ESSGlobal_GetFunctions() {
        List<string> Functions = ESS_Global.GetFunctions(null);
        return Functions;
    }
    
    @RemoteAction
    public static List<string> ESSGlobal_GetDepartments(string function) {
        List<string> Departments = ESS_Global.GetDepartments(function);
        return Departments;
    }  
    
    @RemoteAction
    public static List<string> ESSGlobal_GetSections(string department) {
        List<string> Sections = ESS_Global.GetSections(department);
        return Sections;
    }  
    
    @RemoteAction
    public static List<string> ESSGlobal_GetUnits(string section) {
        List<string> Units = ESS_Global.GetUnits(section);
        return Units;
    }  
    
    public class RecommendationLetterSearchCriteria {
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string companyName {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
        @RemoteAction
        public boolean statusAll {get;set;}
        @RemoteAction
        public boolean statusCreated {get;set;}
        @RemoteAction
        public boolean statusGeneratedToPDF {get;set;}
        @RemoteAction
        public boolean letterTypeAll {get;set;}
        @RemoteAction
        public boolean letterTypeSalaryLetterForFinancial {get;set;}
        @RemoteAction
        public boolean letterTypeSalaryLetterWithLeaveForVisa {get;set;}
        @RemoteAction
        public boolean letterTypeSalaryLetterWithoutLeaveForVisa {get;set;}
        @RemoteAction
        public boolean letterTypeWorkLetterWithoutSalary {get;set;}
        @RemoteAction
        public boolean letterTypeGrantedLetter {get;set;}
        @RemoteAction
        public date startCreatedDate {get;set;}
        @RemoteAction
        public date endCreatedDate {get;set;}
        @RemoteAction
        public date startGeneratedPDFDate {get;set;}
        @RemoteAction
        public date endGeneratedPDFDate {get;set;}
    }
    
}