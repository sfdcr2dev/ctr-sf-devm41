/* Class for Master Data Detail that use in Trigger */
public with sharing class CPEM_MasterDataForTriggerController {

    public static void UpdateSMEFromMasterData(Master_Data_Detail__c MDDetail, Id OldSME) {
        
        integer WPNo = Integer.ValueOf(MDDetail.Work_Process_No__c);
        Id newSME = MDDetail.SME__c;
        
        if(oldSME != newSME) {
            
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(WPNo, newSME);
            
        }
        
    }
    
}