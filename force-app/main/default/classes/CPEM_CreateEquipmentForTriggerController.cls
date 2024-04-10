/* Create Vendor Data Management, Material Inspection from Equipment */
public class CPEM_CreateEquipmentForTriggerController {

    public static void CreateEquipment(Equipment_Plan__c Eq) {
        
        Id ProjectId;
        string EquipmentName;
        string Discipline;
        Id PPPlanId;
        
        EquipmentName = Eq.Name;
        Discipline = Eq.Discipline__c;
        PPPlanId = Eq.Project_Procurement_Plan__c;
        
        Project_Procurement_Plan__c PPP = [select id, Project__c from Project_Procurement_Plan__c where Id =: PPPlanId];
        
        ProjectId = PPP.Project__c;
        
        //Auto Create Equipment in Vendor Data Management (Step 21)
        Vendor_Data_Management__c  VDM = [select id, Project__c from Vendor_Data_Management__c where Project__c =: ProjectId];
        
        Vendor_Data_Management_with_Equipment__c VendorEquipment = new Vendor_Data_Management_with_Equipment__c ();
        VendorEquipment.Vendor_Data_Management__c = VDM.Id;
        VendorEquipment.Name = EquipmentName;
        VendorEquipment.Discipline__c = Discipline;
        insert(VendorEquipment);
        
        //Auto Create Equipment in Material Inspection (Step 22)
        Material_Inspection_FAT_SAT__c MI = [select id, Project__c from Material_Inspection_FAT_SAT__c where Project__c =: ProjectId];
        
        Material_Inspection_with_Equipment__c MIEquipment = new Material_Inspection_with_Equipment__c();
        MIEquipment.Material_Inspection_FAT_SAT__c = MI.Id;
        MIEquipment.Name = EquipmentName;
        MIEquipment.Discipline__c = Discipline;
        insert(MIEquipment);
    }
    
}