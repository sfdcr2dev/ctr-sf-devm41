/* Class for SubContractorBidding to create ITB SubContractor, CCE Approval Process, Cost Estimate  */
public with sharing class CPEM_SubContractorForTriggerController {

    public static void CreateSubContractorBidding(Subcontractor_Bidding__c SB) {
        
        Id ProjectId;
        Id PPPlanId;
        Id CCEId;
        string SubContractorName;
        
        SubContractorName = SB.Name;
        
        PPPlanId = SB.Project_Procurement_Plan__c;
        
        Project_Procurement_Plan__c PPP = [select id, Project__c from Project_Procurement_Plan__c where Id =: PPPlanId];
        
        ProjectId = PPP.Project__c;
        
        //Auto create in Work Process 7
        Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: ProjectId];
        
        Schedule_WBS__c SWBS = new Schedule_WBS__c ();
        SWBS.Schedule__c = WP7.Id;  
        SWBS.BE_WBS_Detail_ID__c = SB.Id;
        SWBS.WBS_CBS_Name__c = SubContractorName;
        insert(SWBS);
        
        //Auto create in Work Process 10
        ITB_Standard__c ITB = [select id, Project__c from ITB_Standard__c where Project__c =: ProjectId];
        
        //Create ITB With SubContractor from Subcontractor Bidding
        ITB_with_Sub_Contract__c ITBSC = new ITB_with_Sub_Contract__c();
        ITBSC.Name = SubContractorName;
        ITBSC.ITB_Standard__c = ITB.Id;
        insert(ITBSC);
        
        //Auto create in Work Process 11
        CCE_Approval_Process__c CCE = [select id, Project__c from CCE_Approval_Process__c where Project__c =: ProjectId];
        
        //Create CCE With Sub Contract from SubContractor Bidding
        CCE_with_Sub_Contract__c CCESC = new CCE_with_Sub_Contract__c();
        CCESC.Name = SubContractorName;
        CCESC.CCE_Approval_Process__c = CCE.Id;
        insert(CCESC);
        
        //Auto create in Work Process 16
        Cost_Estimate__c CE = [select id, Project__c from Cost_Estimate__c where Project__c =: ProjectId];
        
        //Create Cost Estimate With MTO BOQ
        Cost_Estimate_With_MTO_BOQ__c CEWMB = new Cost_Estimate_With_MTO_BOQ__c();
        CEWMB.Name = SubContractorName;
        CEWMB.Cost_Estimate__c = CE.Id;
        insert(CEWMB);
        
        //Auto create in Work Process 18
        ITB_Standard_18__c ITB18 = [select id, Project__c from ITB_Standard_18__c where Project__c =: ProjectId];
        
        //Update Work Process Status
        ITB18.Work_Process_Status__c = 'In Progress';
        update(ITB18);
        
        //Create ITB Sub Contract
        ITB_with_Sub_Contract_18__c ITBSC18 = new ITB_with_Sub_Contract_18__c();
        ITBSC18.Name = SubContractorName;
        ITBSC18.ITB_Standard__c = ITB18.Id;
        ITBSC18.BE_ITB_Subcontract_10_ID__c = ITBSC.Id;
        insert(ITBSC18);
        
        ITBSC.BE_ITB_Subcontract_18_ID__c = ITBSC18.Id;
        update(ITBSC);
        
        //Auto create in Work Process 19
        CCE_Approval_Process_19__c CCE19 = [select id, Project__c from CCE_Approval_Process_19__c where Project__c =: ProjectId];
        
        //Update Work Process Status
        CCE19.Work_Process_Status__c = 'In Progress';
        update(CCE19);
        
        //Create CCE With SubContract
        CCE_with_Sub_Contract_19__c CCESC19 = new CCE_with_Sub_Contract_19__c();
        CCESC19.Name = SubContractorName;
        CCESC19.CCE_Approval_Process__c = CCE19.Id;
        CCESC19.BE_Sub_Contract_11_ID__c = CCESC.Id;
        insert(CCESC19);
        
        CCESC.BE_Sub_Contract_19_ID__c = CCESC19.Id;
        update(CCESC);
           
    }
    
}