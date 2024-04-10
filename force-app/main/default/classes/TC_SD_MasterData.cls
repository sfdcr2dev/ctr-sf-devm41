@isTest /* Test class SafetyDashboard Master */
public class TC_SD_MasterData {

    public static testMethod void TestCompany() {
        
        SD_Company__c Company = TC_SD_DataGeneration.CreateCompany(); 
        Company.Company_Full_Name__c = 'Thai Oil Group';
        update(Company);
        
    }
    
    public static testMethod void TestZone() {
        
        SD_Zone__c Zone = TC_SD_DataGeneration.CreateZone(); 
        update(Zone);
        
    }
    
    public static testMethod void TestContractorZone() {
        
        SD_Contractor_Zone__c ContractorZone = TC_SD_DataGeneration.CreateContractorZone();
        update(ContractorZone);
    }
    
    public static testMethod void TestSubArea() {
        
        SD_Sub_Area__c SubArea = TC_SD_DataGeneration.CreateSubArea();
        update(SubArea);
    }
    
    public static testMethod void TestInitData() {
        
        SD_Company__c Company = TC_SD_DataGeneration.CreateCompany(); 
        SD_Sub_Area__c SubArea = TC_SD_DataGeneration.CreateSubArea();
        SD_Zone__c Zone = TC_SD_DataGeneration.CreateZone();
        
        SD_GenerateInitialDataController InitData = new SD_GenerateInitialDataController();
        
        test.startTest();
        
        SD_Company__c Com = new SD_Company__c();
        Com.Name = 'TOP GROUP';
        Com.Company_Full_Name__c = 'TOP';
        COM.Security_Level__c = '1';
        insert(Com);
        
        string currentYear = InitData.CurrentYear();
        
        InitData.CompanyName = 'TOP';
        InitData.GenerateInitialDataManHours(currentYear);
        InitData.GenerateInitialDataContractorManHours(currentYear);
        InitData.GenerateInitialDataIncidents(currentYear);
        InitData.GenerateInitialDataContractorIncidents(currentYear);
        InitData.GenerateInitialDataPIRs(currentYear);
        InitData.GenerateInitialDataContractorPIRs(currentYear);
        
        Test.stopTest();
    }
    
}