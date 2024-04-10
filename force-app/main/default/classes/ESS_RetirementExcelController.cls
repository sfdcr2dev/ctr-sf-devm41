/* Author Softever */
public with sharing class ESS_RetirementExcelController {

    public date todayDate {get;set;}
    public List<ESS_Retirement_DTO.RetirementListDTO> results {get;set;}
    public integer resultSize {get;set;}

    public ESS_RetirementExcelController() {
    
        todayDate = system.Date.today();
        resultSize = 0;
    
        results = new List<ESS_Retirement_DTO.RetirementListDTO>();
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
    
        integer currentYear = system.Datetime.now().year();
        integer year = Integer.ValueOf(currentYear + 1);
        integer twoYear = Integer.ValueOf(currentYear + 2);
        date retirementStartDate = Date.newInstance(year, 1, 2);
        date retirementEndDate = Date.newInstance(twoYear, 1, 1);
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Name_Emp_EN_FN__c, Employee_Retirement_Date__c, Employee_DOB__c, Retirement_Section_Head_Skip__c, Retirement_Section_Head_Id__c , Retirement_Section_Head_Name__c, Retirement_VP_Id__c, Retirement_VP_Name__c, Retirement_Section_Head_TH__c,Retirement_Section_Head_Position__c , Retirement_VP_TH__c , Retirement_VP_Position__c  from ESS_Master_Employee__c where data__c =: data AND (Employee_Retirement_Date__c >=: retirementStartDate AND Employee_Retirement_Date__c <=: retirementEndDate) order by Employee_Id__c asc';
        
        Employees = database.query(query);
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, MAINPOSITION__c, Retirement_Selection__c from PISUsers__c where Active__c = true AND User__c != null];
        
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
        
        List<ESS_Retirement__c> allRetirements = allRetirements();
            
        if(Employees.size() > 0) {
            
            for(ESS_Master_Employee__c Employee : Employees) {
                ESS_Retirement_DTO.RetirementListDTO assign = new ESS_Retirement_DTO.RetirementListDTO();
                assign = assignToRetirementListDTO(Employee, mapPOSIDPISUsers, mapPISUsers, allRetirements);
                if(string.isNotEmpty(assign.employeeid)) {
                    //Check show only TOP user
                    PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
                    if(PISUser.COMPANYNAME__c == 'TOP' && PISUser.Retirement_Selection__c) {
                                //Check Employee DOB
                        List<string> dobYears = new List<string> {string.Valueof(Integer.valueOf(currentYear) - 59), string.valueOf(Integer.valueOf(currentYear) - 54)};
                        integer employeeDOBYear = Employee.Employee_DOB__c.Year();
                                boolean existed = dobYears.contains(String.ValueOf(employeeDOBYear));
                        if(existed) {
                                results.add(assign);                            
                        }
                    }
                }
            }
            
        }
        
        resultSize = results.size();
            
    }
    
    //Assign to DTO section
    private static ESS_Retirement_DTO.RetirementListDTO assignToRetirementListDTO(ESS_Master_Employee__c Employee, Map<string, PISUsers__c> mapPOSIDPISUsers, Map<string, PISUsers__c> mapPISUsers, List<ESS_Retirement__c> Retirements) {
    
        string employeeId = '';
        string employeeName = '';
        string employeeNameTH = '';
        string function = '';
        string department = '';
        string section = '';
        string position = '';
        string level = '';
        string sectionHead = '';
        string departmentHead = '';
        string userId = '';
        string sectionHeadName = '';
        string sectionHeadNameTH = '';
        string departmentHeadName = '';
        string departmentHeadNameTH = '';
        string sectionHeadPosition = '';
        string departmentHeadPosition = '';
        
        ESS_Retirement_DTO.RetirementListDTO RetirementList = new ESS_Retirement_DTO.RetirementListDTO();
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
                position = PISUser.OBJENFULLNAME__c;
                level = PISUser.LEVEL__c;
                
                ESS_Retirement_DTO.RetirementApproverDTO RetirementApprover = new ESS_Retirement_DTO.RetirementApproverDTO();
                RetirementApprover = ESS_Global.GetSectionHeadDepartmentHead(PISUser, mapPOSIDPISUsers);
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Id__c)) {
                    sectionHead = Employee.Retirement_Section_Head_Id__c;
                }
                else {
                    sectionHead = RetirementApprover.sectionHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Name__c)) {
                    sectionHeadName = Employee.Retirement_Section_Head_Name__c;
                }
                else {
                    sectionHeadName = RetirementApprover.sectionHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_TH__c)) {
                    sectionHeadNameTH = Employee.Retirement_Section_Head_TH__c;
                }
                else {
                    sectionHeadNameTH = RetirementApprover.sectionHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Position__c)) {
                    sectionHeadPosition = Employee.Retirement_Section_Head_Position__c;
                }
                else {
                    sectionHeadPosition = RetirementApprover.sectionHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Id__c)) {
                    departmentHead = Employee.Retirement_VP_Id__c;
                }
                else {
                    departmentHead = RetirementApprover.departmentHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Name__c)) {
                    departmentHeadName = Employee.Retirement_VP_Name__c;
                }
                else {
                    departmentHeadName = RetirementApprover.departmentHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_TH__c)) {
                    departmentHeadNameTH = Employee.Retirement_VP_TH__c;
                }
                else {
                    departmentHeadNameTH = RetirementApprover.departmentHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Position__c)) {
                    departmentHeadPosition = Employee.Retirement_VP_Position__c;
                }
                else {
                    departmentHeadPosition = RetirementApprover.departmentHeadPosition;
                }
                
                isMap = true;
                
                //break;
            }
        }
        
        RetirementList.userId = userId;
        RetirementList.employeeId = employeeId;
        RetirementList.employeeName = employeeName;
        RetirementList.employeeNameTH = employeeNameTH;
        RetirementList.birthDate = Employee.Employee_DOB__c;
        
        RetirementList.age = '';
        
        if(Employee.Employee_DOB__c != null) {
            RetirementList.age = findAge(Date.ValueOf(Employee.Employee_DOB__c), date.today());
        }
        
        RetirementList.function = function;
        RetirementList.department = department;
        RetirementList.section = section;
        RetirementList.position = position;
        RetirementList.level = level;
        RetirementList.sectionHead = sectionHead;
        RetirementList.sectionHeadTH = sectionHeadNameTH;
        if(string.isnotempty(sectionHeadName)) {
            RetirementList.sectionHeadEmployeeId = sectionHeadName.split(' - ')[0];
            RetirementList.sectionHeadName = sectionHeadName.split(' - ')[1];
        }
        RetirementList.sectionHeadPosition = sectionHeadPosition;
        if(Employee.Retirement_Section_Head_Skip__c) {
            RetirementList.sectionHead = '';
            RetirementList.sectionHeadTH = '';
            RetirementList.sectionHeadName = '';
            RetirementList.sectionHeadPosition = '';
        }
        RetirementList.departmentHead = departmentHead;
        RetirementList.departmentHeadTH = departmentHeadNameTH;
        if(string.isnotempty(departmentHeadName)) {
            RetirementList.departmentHeadEmployeeId = departmentHeadName.split(' - ')[0];
            RetirementList.departmentHeadname = departmentHeadName.split(' - ')[1];
        }
        RetirementList.departmentHeadPosition = departmentHeadPosition;
        if(!isMap) {
            //RetirementList.employeeId = Employee.Employee_ID__c;
        }
        
        RetirementList.isDisable = false;
        //Check isDisable
        if(Retirements.size() > 0) {
            for(ESS_Retirement__c Retirement : Retirements) {
                if(Retirement.Employee_ID__c == employeeId) {
                    RetirementList.isDisable = true;
                    break;
                }
            }
        }
        
        return RetirementList;
    
    }
    
    private static string findAge(date birthDate, date todayDate) {
        
        string age = '';
        
        integer diffDay = birthDate.daysBetween(todayDate);
        decimal remainDay = Decimal.ValueOf(diffDay)/365;
        
        string year = String.ValueOf(Integer.ValueOf(remainDay));
        String month = String.ValueOf(remainDay.setScale(1)).substringAfter('.');
        
        age = year + 'ปี ' + month + 'เดือน';
        
        return age;
        
    }
    
    private static List<ESS_Retirement__c> allRetirements() {
        List<ESS_Retirement__c> Retirements = [select id, employee_id__c from ESS_Retirement__c];
        return Retirements;
    }
    
    public string LanguageThai {
        get {
            return EncodingUtil.base64decode('77u/').toString();
        }
    }

}