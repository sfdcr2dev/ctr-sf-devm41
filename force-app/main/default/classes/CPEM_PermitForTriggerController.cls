/* Class for Permit from Trigger */
public class CPEM_PermitForTriggerController {

    public static void CreatePermit(Permit__c Permit) {
        
        List<Permit__c> existPermits = [select id, name, Permit_Topic__c from Permit__c where Permit_Topic__c =: Permit.Permit_Topic__c];
            
        if(existPermits.size() > 0) {
            
            Permit.addError('กรุณาเช็ค ' + '**เรื่องที่ขออนุญาติ**' + ' เนื่องจากไม่อนุญาติให้ใข้ ชื่อเรื่องที่ขออนุญาติ ซ้ำกันได้');
            
        }
        
    }
    
    public static void UpdatePermit(Permit__c oldPermit, Permit__c currentPermit) {
        
        string oldPermitName = oldPermit.Permit_Topic__c;
        string newPermitName = currentPermit.Permit_Topic__c;
        
        List<Permit__c> existPermits = [select id, name, Permit_Topic__c from Permit__c where Permit_Topic__c =: currentPermit.Permit_Topic__c];
        
        System.debug('oldPermitName : ' + oldPermitName);
        System.debug('newPermitName : ' + newPermitName);
        
        if(oldPermitName == newPermitName) {
            
            if(existPermits.size() > 0) {
                
                currentPermit.addError('กรุณาเช็ค ' + '**เรื่องที่ขออนุญาติ**' + ' เนื่องจากไม่อนุญาติให้ใข้ ชื่อเรื่องที่ขออนุญาติ ซ้ำกันได้');
                
            }
        }
    }
    
}