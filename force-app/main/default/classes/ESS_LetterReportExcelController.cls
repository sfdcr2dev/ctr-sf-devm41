/* Author Softever */
public with sharing class ESS_LetterReportExcelController {

    public string trackingReportType {get;set;}
    public integer letterSize {get;set;}
    public date todayDate {get;set;}
    
    public List<ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO> recommendationLetterTables {get;set;}
    
    public void OnloadExcel() {
        
        todayDate = date.today();
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        letterSize = 0;
        
        recommendationLetterTables = new List<ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO>();
        
        trackingReportType = ApexPages.currentPage().getParameters().get('TrackingReportType');
        
        if(trackingReportType == 'Letter') {
            
            boolean isAdmin = ESS_PrivilegeHandler.checkRecommendationLetterAdminUser(userId);
            
            List<ESS_Letter_of_Recommendation__c> Letters = new List<ESS_Letter_of_Recommendation__c>();
            ESS_RecommendationLetterReport.RecommendationLetterSearchCriteria filter = new ESS_RecommendationLetterReport.RecommendationLetterSearchCriteria();
            
            filter.employeeId = ApexPages.currentPage().getParameters().get('employeeId');
            filter.companyName = ApexPages.currentPage().getParameters().get('companyName');
            filter.function = ApexPages.currentPage().getParameters().get('function');
            filter.department = ApexPages.currentPage().getParameters().get('department');
            filter.section = ApexPages.currentPage().getParameters().get('section');
            filter.unit = ApexPages.currentPage().getParameters().get('unit');
            filter.statusAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusAll'));
            filter.statusCreated = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusCreated'));
            filter.statusGeneratedToPDF = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusGeneratedToPDF'));
            filter.letterTypeAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('letterTypeAll'));
            filter.letterTypeSalaryLetterForFinancial = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('letterTypeSalaryLetterForFinancial'));
            filter.letterTypeSalaryLetterWithLeaveForVisa = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('letterTypeSalaryLetterWithLeaveForVisa'));
            filter.letterTypeSalaryLetterWithoutLeaveForVisa = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('letterTypeSalaryLetterWithoutLeaveForVisa'));
            filter.letterTypeWorkLetterWithoutSalary = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('letterTypeWorkLetterWithoutSalary'));
            filter.letterTypeGrantedLetter = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('letterTypeGrantedLetter'));
            filter.startCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCreatedDate'));
            filter.endCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCreatedDate'));
            filter.endCreatedDate = filter.endCreatedDate.addDays(1);
            filter.startGeneratedPDFDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startGeneratedPDFDate'));
            filter.endGeneratedPDFDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endGeneratedPDFDate'));
            filter.endGeneratedPDFDate = filter.endGeneratedPDFDate.addDays(1);
            
            string query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
                            'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
                            'from ESS_Letter_of_Recommendation__c where OwnerId =: userId';
            
            if(isAdmin) {
                query = 'select id, document_no__c, employee_id__c, employee_name__c, position__c, letter_type__c, language__c, letter_purpose__c, to_organization__c, createddate,  ' +
                            'generate_pdf_date__c, current_status__c, function__c, department__c, section__c, unit__c ' +
                            'from ESS_Letter_of_Recommendation__c where OwnerId != null';
            } 
              
            //filter.employeeId
            if(string.isNotEmpty(filter.employeeId) && filter.employeeId != 'null') {
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
              
            //Final Query
            Letters = database.query(query + ' order by document_no__c desc');
               
            if(Letters.size() > 0) {
                for(ESS_Letter_of_Recommendation__c Letter : Letters) {
                    ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO LetterTable = new ESS_RecommendationLetterReport_DTO.RecommendationLetterTableDTO();
                    LetterTable = assignToRecommendationLetterTableDTO(Letter);
                    if(string.isnotempty(LetterTable.documentNo)) {
                        recommendationLetterTables.add(LetterTable);
                    }
                }
                
            }
            
            letterSize = recommendationLetterTables.size();
        }
        
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
    
    
}