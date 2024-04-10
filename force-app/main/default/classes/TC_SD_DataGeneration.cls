global class TC_SD_DataGeneration {

    public static SD_Company__c CreateCompany() {
        
        SD_Company__c Company = new SD_Company__c();
        Company.Name = 'TOP';
        Company.Company_Full_Name__c = 'Thai Oil Group';
        Company.Security_Level__c = '1';
        insert(Company);
        
        return Company;
        
    }
    
    public static SD_Area__c CreateArea() {
        
        SD_Area__c Area = new SD_Area__c();
        Area.Name = 'Other';
        insert(Area);
        
        return Area;
        
    }
    
    public static SD_Sub_Area__c CreateSubArea() {
        
        SD_Company__c Company = CreateCompany();
        SD_Area__c Area = CreateArea();
        
        SD_Sub_Area__c SubArea = new SD_Sub_Area__c();
        SubArea.Name = 'Other';
        SubArea.SD_Company__c = Company.Id;
        SubArea.SD_Area__c = Area.Id;
        insert(SubArea);
        
        return SubArea;
        
    }
    
    public static SD_Zone__c CreateZone() {
        
        SD_Company__c Company = CreateCompany();
        SD_Zone__c Zone = new SD_Zone__c();
        Zone.Name = 'Other';
        Zone.SD_Company__c = Company.Id;
        Zone.Zone_Type__c = 'Project';
        insert(Zone);
        
        return Zone;
        
    }
    
    public static SD_Contractor__c CreateContractor() {
        
        SD_Contractor__c Contractor = new SD_Contractor__c();
        Contractor.Name = 'Softever';
        insert(Contractor);
        
        return Contractor;
    }
    
    public static SD_Contractor_Zone__c CreateContractorZone() {
        
        SD_Contractor__c Contractor = CreateContractor();
        SD_Zone__c Zone = CreateZone();
        
        SD_Contractor_Zone__c ContractorZone = new SD_Contractor_Zone__c();
        ContractorZone.SD_Zone__c = Zone.Id;
        ContractorZone.SD_Contractor__c = Contractor.Id;
        insert(ContractorZone);
        
        return ContractorZone;
        
    }
    
}