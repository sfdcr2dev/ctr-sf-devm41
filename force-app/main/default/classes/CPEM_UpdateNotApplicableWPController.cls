/* Class to UpdateNotApplicable Work Process from Trigger */
public with sharing class CPEM_UpdateNotApplicableWPController {

    public static void UpdateWorkProcess10(ITB_with_Sub_Contract__c oldWP, ITB_with_Sub_Contract__c currentWP) {
        
        boolean CheckITB10 = oldWP.Not_Applicable__c;
        
        if(currentWP.Not_Applicable__c == true && currentWP.Not_Applicable__c != CheckITB10) {
            
            ITB_with_Sub_Contract_18__c  ITB18 = [select id, Not_Applicable__c, BE_ITB_Subcontract_10_ID__c from ITB_with_Sub_Contract_18__c where BE_ITB_Subcontract_10_ID__c =: currentWP.Id];
            
            if(ITB18 != null) {
                
                ITB18.ITB_Engineering_Not_Applicable__c = true;
                update(ITB18);
                
            }
            
        }
        else if(currentWP.Not_Applicable__c == false && currentWP.Not_Applicable__c != CheckITB10) {
            
            ITB_with_Sub_Contract_18__c  ITB18 = [select id, Not_Applicable__c, BE_ITB_Subcontract_10_ID__c from ITB_with_Sub_Contract_18__c where BE_ITB_Subcontract_10_ID__c =: currentWP.Id];
            
            if(ITB18 != null) {
                
                ITB18.ITB_Engineering_Not_Applicable__c = false;
                update(ITB18);
                
            }
            
        }
    }
    
    public static void UpdateWorkProcess11(CCE_with_Sub_Contract__c oldWP, CCE_with_Sub_Contract__c currentWP) {
        
        boolean CheckITB11 = oldWP.Not_Applicable__c;
        
        if(currentWP.Not_Applicable__c == true && currentWP.Not_Applicable__c != CheckITB11) {
            
            CCE_with_Sub_Contract_19__c ITB19 = [select id, Not_Applicable__c, BE_Sub_Contract_11_ID__c from CCE_with_Sub_Contract_19__c where BE_Sub_Contract_11_ID__c =: currentWP.Id];
            
            if(ITB19 != null) {
                
                ITB19.CCE_Engineering_Not_Applicable__c = true;
                update(ITB19);
                
            }
            
        }
        else if(currentWP.Not_Applicable__c == false && currentWP.Not_Applicable__c != CheckITB11) {
            
            CCE_with_Sub_Contract_19__c ITB19 = [select id, Not_Applicable__c, BE_Sub_Contract_11_ID__c from CCE_with_Sub_Contract_19__c where BE_Sub_Contract_11_ID__c =: currentWP.Id];
            
            if(ITB19 != null) {
                
                ITB19.CCE_Engineering_Not_Applicable__c = false;
                update(ITB19);
                
            }
            
        }
    }
    
    public static void UpdateWorkProcess18(ITB_with_Sub_Contract_18__c oldWP, ITB_with_Sub_Contract_18__c currentWP) {
        
        boolean CheckITB18 = oldWP.Not_Applicable__c;
        
        if(currentWP.Not_Applicable__c == true && currentWP.Not_Applicable__c != CheckITB18) {
            
            ITB_with_Sub_Contract__c  ITB10 = [select id, Not_Applicable__c, BE_ITB_Subcontract_18_ID__c from ITB_with_Sub_Contract__c where BE_ITB_Subcontract_18_ID__c =: currentWP.Id];
            
            if(ITB10 != null) {
                
                ITB10.ITB_Construction_Not_Applicable__c = true;
                update(ITB10);
                
            }
            
        }
        else if(currentWP.Not_Applicable__c == false && currentWP.Not_Applicable__c != CheckITB18) {
            
            ITB_with_Sub_Contract__c  ITB10 = [select id, Not_Applicable__c, BE_ITB_Subcontract_18_ID__c from ITB_with_Sub_Contract__c where BE_ITB_Subcontract_18_ID__c =: currentWP.Id];
            
            if(ITB10 != null) {
                
                ITB10.ITB_Construction_Not_Applicable__c = false;
                update(ITB10);
                
            }
            
        }
    }
    
    public static void UpdateWorkProcess19(CCE_with_Sub_Contract_19__c oldWP, CCE_with_Sub_Contract_19__c currentWP) {
        
        boolean CheckITB19 = oldWP.Not_Applicable__c;
        
        if(currentWP.Not_Applicable__c == true && currentWP.Not_Applicable__c != CheckITB19) {
            
            CCE_with_Sub_Contract__c ITB11 = [select id, Not_Applicable__c, BE_Sub_Contract_19_ID__c from CCE_with_Sub_Contract__c where BE_Sub_Contract_19_ID__c =: currentWP.Id];
            
            if(ITB11 != null) {
                
                ITB11.CCE_Construction_Not_Applicable__c = true;
                update(ITB11);
                
            }
            
        }
        else if(currentWP.Not_Applicable__c == false && currentWP.Not_Applicable__c != CheckITB19) {
            
            CCE_with_Sub_Contract__c ITB11 = [select id, Not_Applicable__c, BE_Sub_Contract_19_ID__c from CCE_with_Sub_Contract__c where BE_Sub_Contract_19_ID__c =: currentWP.Id];
            
            if(ITB11 != null) {
                
                ITB11.CCE_Construction_Not_Applicable__c = false;
                update(ITB11);
                
            }
            
        }
            
    }
    
}