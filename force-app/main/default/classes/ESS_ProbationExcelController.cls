public with sharing class ESS_ProbationExcelController {

    public date todayDate {get;set;}
    public List<ESS_Probationary_DTO.ProbationaryListDTO> results {get;set;}
    public integer resultSize {get;set;}

    public ESS_ProbationExcelController() {
    
        todayDate = system.Date.today();
        
        results = new List<ESS_Probationary_DTO.ProbationaryListDTO>();
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
        
        Set<string> employeeIds = new Set<string>();
        List<ESS_Probationary__c> Probationaries = [select id, employee_id__c from ESS_Probationary__c];
        
        if(Probationaries.size() > 0) {
            for(ESS_Probationary__c Probation : Probationaries) {
                employeeIds.add(Probation.Employee_Id__c);
            }
        }
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Employee_Date_Joined__c, Probationary_Date__c, Probation_Section_Head_Skip__c, Probation_Section_Head_Id__c, Probation_Section_Head_Name__c, Probation_Section_Head_Position__c, Probation_VP_Id__c, Probation_VP_Name__c, Probation_VP_Position__c, CEP__c, Probation_Section_Head_TH__c, Probation_VP_TH__c, Probation_Completed__c from ESS_Master_Employee__c where data__c =: data AND Employee_Date_Joined__c != null AND Need_Probation__c = true AND employee_id__c NOT IN: employeeIds AND Probation_Completed__c = false order by employee_id__c asc';
         
        Employees = database.query(query);
        system.debug(Employees.size());
        List<ESS_Probationary__c> allProbations = allProbations();
            
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND User__c != null];
           
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        Map<string, PISUsers__c> mapPOSIDPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPOSIDPISUsers.put(PISUser.POSID__c, PISUser);
                
                if(PISUser.MAINPOSITION__c) {
                    mapPISUsers.put(PISUser.EMPLOYEEID__c, PISUser);
                }
            }    
        }  
        
        if(Employees.size() > 0) {
            for(ESS_Master_Employee__c Employee : Employees) {
                ESS_Probationary_DTO.ProbationaryListDTO assign = new ESS_Probationary_DTO.ProbationaryListDTO();
                assign = assignToProbationaryListDTO(Employee, mapPOSIDPISUsers, mapPISUsers, allProbations);
                if(string.isNotEmpty(assign.employeeid)) {
                    results.add(assign);
                }
            }
        }
        
        resultSize = results.size();
    }
    
    
    //Assign to DTO section
    private static ESS_Probationary_DTO.ProbationaryListDTO assignToProbationaryListDTO(ESS_Master_Employee__c Employee, Map<string, PISUsers__c> mapPOSIDPISUsers, Map<string, PISUsers__c> mapPISUsers, List<ESS_Probationary__c> Probations) {
    
        string employeeId = '';
        string employeeName = '';
        string employeeNameTH = '';
        string function = '';
        string department = '';
        string section = '';
        string unit = '';
        string sectionHead = '';
        string departmentHead = '';
        string level = '';
        string userId = '';
        string sectionHeadName = '';
        string sectionHeadNameTH = '';
        string departmentHeadName = '';
        string departmentHeadNameTH = '';
        string sectionHeadPosition = '';
        string departmentHeadPosition = '';
        string companyName = '';
        string cep = '';
        
        ESS_Probationary_DTO.ProbationaryListDTO ProbationaryList = new ESS_Probationary_DTO.ProbationaryListDTO();
        boolean isMap = false;
        
        if(mapPISUsers.size() > 0) {
            
            PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
            
            if(PISUser != null) {
                userId = PISUser.User__c;
                employeeId = PISUser.EMPLOYEEID__c;
                employeeName = PISUser.EN_Fullname__c;
                employeeNameTH = PISUser.TH_Fullname__c;
                function = PISUser.FUNCTION__c;
                department = PISUser.DEPARTMENT__c;
                section = PISUser.SECTIONS__c;
                
                if(string.isNotEmpty(PISUser.UNITS__c)) {
                    unit = PISUser.UNITS__c;
                }
                
                level = PISUser.Level__c;
                
                if(PISUser.HOME_COMP__c == '1100') {
                    companyName = 'TOP';
                }
                else if(PISUser.HOME_COMP__c == '1600') {
                    companyName = 'TES';
                }
                
                ESS_Probationary_DTO.ProbationaryApproverDTO ProbationApprover = new ESS_Probationary_DTO.ProbationaryApproverDTO();
                ProbationApprover = ESS_Global.GetSectionHeadDepartmentHeadProbation(PISUser, mapPOSIDPISUsers);
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Id__c)) {
                    sectionHead = Employee.Probation_Section_Head_Id__c;
                }
                else {
                    sectionHead = ProbationApprover.sectionHeadId;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Name__c)) {
                    sectionHeadName = Employee.Probation_Section_Head_Name__c;
                }
                else {
                    sectionHeadName = ProbationApprover.sectionHeadName;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_TH__c)) {
                    sectionHeadNameTH = Employee.Probation_Section_Head_TH__c;
                }
                else {
                    sectionHeadNameTH = ProbationApprover.sectionHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Position__c)) {
                    sectionHeadPosition = Employee.Probation_Section_Head_Position__c;
                }
                else {
                    sectionHeadPosition = ProbationApprover.sectionHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Id__c)) {
                    departmentHead = Employee.Probation_VP_Id__c;
                }
                else {
                    departmentHead = ProbationApprover.departmentHeadId;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Name__c)) {
                    departmentHeadName = Employee.Probation_VP_Name__c;
                }
                else {
                    departmentHeadName = ProbationApprover.departmentHeadName;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_TH__c)) {
                    departmentHeadNameTH = Employee.Probation_VP_TH__c;
                }
                else {
                    departmentHeadNameTH = ProbationApprover.departmentHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Position__c)) {
                    departmentHeadPosition = Employee.Probation_VP_Position__c;
                }
                else {
                    departmentHeadPosition = ProbationApprover.departmentHeadPosition;
                }
                
                isMap = true;
            }
        }
        
        ProbationaryList.dateStamp = Employee.Probationary_Date__c;
        ProbationaryList.ownerId = userId;
        ProbationaryList.employeeId = employeeId;
        ProbationaryList.employeeName = employeeNameTH;
        ProbationaryList.companyName = companyName;
        ProbationaryList.dateJoinedCompany = Employee.Employee_Date_Joined__c;
        ProbationaryList.dateCompletedProbation = Employee.Employee_Date_Joined__c.addDays(179);
        ProbationaryList.function = function;
        ProbationaryList.department = department;
        ProbationaryList.section = section;
        ProbationaryList.unit = unit;
        ProbationaryList.level = level;
        ProbationaryList.sectionHead = sectionHead;
        if(string.isnotempty(sectionHeadName)) {
            ProbationaryList.sectionHeadEmployeeId = sectionHeadName.split(' - ')[0];
            ProbationaryList.sectionHeadName = sectionHeadName.split(' - ')[1];
        }
        ProbationaryList.sectionHeadTH = sectionHeadNameTH;
        ProbationaryList.sectionHeadPosition = sectionHeadPosition;
        if(Employee.Probation_Section_Head_Skip__c) {
            ProbationaryList.sectionHead = '';
            ProbationaryList.sectionHeadTH = '';
            ProbationaryList.sectionHeadName = '';
            ProbationaryList.sectionHeadPosition = '';
        }
        ProbationaryList.departmentHead = departmentHead;
        if(string.isnotempty(departmentHeadName)) {
            ProbationaryList.departmentHeadEmployeeId = departmentHeadName.split(' - ')[0];
            ProbationaryList.departmentHeadname = departmentHeadName.split(' - ')[1];
        }
        ProbationaryList.departmentHeadTH = departmentHeadNameTH;
        ProbationaryList.departmentHeadPosition = departmentHeadPosition;
        
        //Decode CEP
        if(string.isNotEmpty(Employee.CEP__c)) {
            Blob blobValue = EncodingUtil.convertFromHex(Employee.CEP__c);
            ProbationaryList.cep = blobValue.toString();
        }
        else {
            ProbationaryList.cep = '';
        }
        
        if(!isMap) {
            //ProbationaryList.employeeId = Employee.Employee_ID__c;
        }
        
        ProbationaryList.isDisable = false;
        //Check isDisable
        if(Probations.size() > 0) {
            for(ESS_Probationary__c Probation : Probations) {
                if(Probation.Employee_ID__c == employeeId) {
                    ProbationaryList.isDisable = true;
                    break;
                }
            }
        }
        return ProbationaryList;
    }
    
    private static List<ESS_Probationary__c> allProbations() {
        List<ESS_Probationary__c> Probations = [select id, employee_id__c from ESS_Probationary__c];
        return Probations;
    }
    
    public string LanguageThai {
        get {
            return EncodingUtil.base64decode('77u/').toString();
        }
    }
    
}