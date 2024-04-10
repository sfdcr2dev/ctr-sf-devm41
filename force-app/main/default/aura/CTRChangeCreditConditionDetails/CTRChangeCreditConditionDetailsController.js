({
	doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('--doInit-recordId---'+recordId);
        helper.getBUInformation(component,event, recordId);
        //this.handleRenderCreditConditionFields(component,event, recordId);
        

    },
    toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
         
        // -1 open/close section
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close'); 
        }
    },
    handleSaveFunction: function(component, event, helper) {
        try
        {
            console.log('---handleSaveFunction---');
            component.set('v.ButtonLabel','Save');
            
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    handleSubmitFunction: function(component, event, helper) {
        console.log('---handleSubmitFunction---');
        component.set('v.ButtonLabel','Submit');
    },
    handleEditClick: function(component, event, helper) {
        console.log('---handleEditClick---');
        component.set('v.IsPageDisable',false);
        component.set('v.IsButtonDisable',false);
        
        if(buInfo.BusinessUnit__c=="TX")
            {
                //this.handleRenderPicklist
                
                var CashOnDelivery = component.find("CashOnDelivery").get("v.value");
                var HavingCollateral = component.find("HavingCollateral").get("v.value");
                var BuyTradeEndorsement = component.find("BuyTradeEndorsement").get("v.value");
                var BuyTradeDCLCondition = component.find("BuyTradeDCLCondition").get("v.value");
                var HavingOpenedCredit = component.find("HavingOpenedCredit").get("v.value");

                if(RecTypeName == 'Customer')
                {
                    //enable picklist   
                    if(CashOnDelivery == 'No')
                    {
                        component.set('v.HavingCollateralIsDisable',false);
                        component.set('v.BuyTradeEndorsementIsDisable',false); 
                        component.set('v.BuyTradeDCLConditionIsDisable',false);
                        component.set('v.HavingOpenedCreditIsDisable',false);
                        
                        if(HavingCollateral == '' && BuyTradeEndorsement == '' && BuyTradeDCLCondition == '' && HavingOpenedCredit == '')
                        {
                            component.set('v.IsRequired',true);
                            component.set('v.IsShowRequiredMsg',true);
                        }
                        if(HavingCollateral != 'Yes' && BuyTradeEndorsement != 'Yes' && BuyTradeDCLCondition != 'Yes' && HavingOpenedCredit != 'Yes')
                        {
                            component.set('v.IsRequired',true);
                            component.set('v.IsShowRequiredMsg',true);
                        }
                        if(HavingCollateral=='Yes' || BuyTradeEndorsement == 'Yes' || BuyTradeDCLCondition == 'Yes' || HavingOpenedCredit == 'Yes')
                        {
                            component.set('v.IsRequired',false); 
                            component.set('v.IsShowRequiredMsg',false);
                        }
                    }
                    
                    if(HavingCollateral == 'Yes'){
                        component.set('v.HavingCollateralIsDisable',false);
                        component.set('v.AmountBankGuaranteeIsDisable',false);

                    }else 
                        component.set('v.HavingCollateralIsDisable',false);
                    
                    if(BuyTradeEndorsement == 'Yes'){
                        component.set('v.BuyTradeEndorsementIsDisable',false);
                        component.set('v.AmountBuyTradeIsDisable',false);
                    }else 
                        component.set('v.BuyTradeEndorsementIsDisable',false);
                    
                    if(BuyTradeDCLCondition == 'Yes'){
                        component.set('v.BuyTradeDCLConditionIsDisable',false);
                        component.set('v.AmountDCLConditionIsDisable',false);
                    }else 
                        component.set('v.BuyTradeDCLConditionIsDisable',false);
                    
                    if(HavingOpenedCredit == 'Yes'){
                        component.set('v.HavingOpenedCreditIsDisable',false);
                        component.set('v.AmountOpenedCreditIsDisable',false);
                    }else 
                        component.set('v.HavingOpenedCreditIsDisable',false);
                }
                else if(RecTypeName == 'Supplier')
                {
                    var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value");
                    console.log('---HavingCreditTermorLetter--'+HavingCreditTermorLetter);
                    if(CashOnDelivery == 'No')
                    {
                        console.log('---No1--');
                        component.set('v.HavingCollateralIsDisable',false);
                        component.set('v.radioCreditTermIsDisable',false);
                        
                        //enable picklist
                        if(HavingCollateral == 'Yes'){
                            component.set('v.HavingCollateralIsDisable',false);
                            component.set('v.AmountBankGuaranteeIsDisable',false);
    
                        }else 
                            component.set('v.HavingCollateralIsDisable',false);
                        
                        if(HavingCreditTermorLetter == 'Yes'){
                            component.set('v.radioCreditTermIsDisable',false);
                            component.set('v.YesCreditTermIsDisable',false);
                        }else 
                            component.set('v.radioCreditTermIsDisable',false);
                    }else
                    {
                        console.log('---Yes1--');
                        component.set('v.HavingCollateralIsDisable',true);
                        component.set('v.radioCreditTermIsDisable',true);
					}
                }    
            }
    },
    handleSubmit : function(component, event, helper) {
        try
        {
            var ButtonLabel1 = component.get("v.ButtonLabel");
        console.log('---ButtonLabel1---'+ButtonLabel1);
        if(ButtonLabel1 != undefined && ButtonLabel1 != '')
        {
            console.log('---handleSubmit---');
            component.set('v.IsPageDisable',true);
            component.set('v.IsButtonDisable',true);
            event.preventDefault();
            const fields = event.getParam('fields');
            if(ButtonLabel1 == 'Submit')
            {
                fields.Status__c = 'In Review';
                fields.Approval_Step__c = 'Select Committee';
            }
        	component.find('recordEditForm').submit(fields); 
        }
            
        }
        catch(ex)
        {
            console.error('ex---'+ex.message);            
        }

    },
    handleSuccess: function(component, event, helper) {
        console.log('---handleSuccess--');
        var ButtonLabel1 = component.get("v.ButtonLabel");
        console.log('---ButtonLabel1---'+ButtonLabel1);
        if(ButtonLabel1 != undefined && ButtonLabel1 != '')
        {
            window.setTimeout(
                $A.getCallback(function() {
                    window.location.reload();
                    component.set("v.ButtonLabel",'');
                }), 3000
            );
            
        }
    },
    handleRenderCreditConditionFields: function(component, event, helper) { 
		console.log('---RenderCreditConditionFields--');
        var RequestToChangeCredit = component.find("RequestToChangeCredit").get("v.value"); 
        console.log('-0--RequestToChangeCredit---'+RequestToChangeCredit);
        var SubTypeCondition = component.find("SubTypeCondition").get("v.value"); 
        console.log('-1--SubTypeCondition---'+SubTypeCondition);
        var SubTypeCondition2 = component.find("SubTypeCondition2").get("v.value"); 
        console.log('-2--SubTypeCondition2---'+SubTypeCondition2);
        var CreditCondition = component.find("ChangeCreditCreditCondition").get("v.value"); 
        console.log('-3--CreditCondition---'+CreditCondition);
        
        component.set('v.IsDescriptionDisable',false);
        
        if(RequestToChangeCredit == 'Request to Change Credit Condition')
        {
            component.set('v.IsSubTypeConditionDisable',false);
            component.set('v.IsEffectiveDateDisable',false);
            
            if (SubTypeCondition == 'Expand Temporary Credit Line')
            {   
                component.set('v.IsAmountDisable',false);
                
                component.set('v.IsCreditLimitDisable',true);
                component.set('v.IsSubTypeCondition2Disable',true);                
                component.set('v.IsTradeCreditInsuranceDisable',true);
                component.set('v.IsInternalCreditRatingDisable',true);
                
                component.set('v.IsChangeCreditCreditConditionDisable',true);
            }
            if (SubTypeCondition == 'Expand Credit Line')
            {   
                component.set('v.IsCreditLimitDisable',false);
                
                component.set('v.IsSubTypeCondition2Disable',true);
                component.set('v.IsAmountDisable',true);
                component.set('v.IsTradeCreditInsuranceDisable',true);
                component.set('v.IsInternalCreditRatingDisable',true);
                component.set('v.IsChangeCreditCreditConditionDisable',true);
            }
            else if (SubTypeCondition == 'Change Credit Condition')
            {
                CreditCondition = component.find("ChangeCreditCreditCondition").get("v.value"); 
        		console.log('-4--CreditCondition---'+CreditCondition);
                
        		component.set('v.IsChangeCreditCreditConditionDisable',false);
                component.set('v.IsInternalCreditRatingDisable',false);
                component.set('v.IsCreditLimitDisable',false);
                
                component.set('v.IsSubTypeCondition2Disable',true);
                component.set('v.IsAmountDisable',true);
                console.log('---5---');
                
                if(CreditCondition == 'Open Account' )
                {
                    component.set('v.IsTradeCreditInsuranceDisable',true);
                }
                else if(CreditCondition == 'L/C' || CreditCondition == 'Domestic L/C' || CreditCondition == 'Open Account With Collateral')
                {
                    console.log('---6---');
                    component.set('v.IsTradeCreditInsuranceDisable',false);
                    console.log('---7---');
                }
                else if(CreditCondition == 'Cash in Advance' || CreditCondition == 'Others')
                {
                    component.set('v.IsCreditLimitDisable',true);
                    component.set('v.IsTradeCreditInsuranceDisable',true);
                }
                console.log('---8---');
            }
            else if (SubTypeCondition == 'Others')
            {
                component.set('v.IsChangeCreditCreditConditionDisable',true);
                component.set('v.IsInternalCreditRatingDisable',true);
                component.set('v.IsSubTypeCondition2Disable',true);
                component.set('v.IsAmountDisable',true);
            	component.set('v.IsCreditLimitDisable',true);
            	component.set('v.IsTradeCreditInsuranceDisable',true);
                component.set('v.IsDescriptionDisable',true);
            }
            
        }
        else if(RequestToChangeCredit == 'Request to reduce/waive late payment')
        {
            SubTypeCondition = component.find("SubTypeCondition").get("v.value"); 
        	console.log('-1--SubTypeCondition---'+SubTypeCondition);
            SubTypeCondition2 = component.find("SubTypeCondition2").get("v.value"); 
        	console.log('-2--SubTypeCondition2---'+SubTypeCondition2);
            
            component.set('v.IsSubTypeConditionDisable',false);
            if(SubTypeCondition == 'Others' ||SubTypeCondition == 'Early payment for next invoice')
            {
                component.set('v.IsSubTypeCondition2Disable',true);
                component.set('v.IsAmountDisable',true);
                component.set('v.IsCreditLimitDisable',true);
                component.set('v.IsTradeCreditInsuranceDisable',true);
                component.set('v.IsInternalCreditRatingDisable',true);
                component.set('v.IsEffectiveDateDisable',true);
                component.set('v.IsChangeCreditCreditConditionDisable',true);
                if(SubTypeCondition == 'Others')
                    component.set('v.IsDescriptionDisable',true);
            }
            else if(SubTypeCondition == 'Customer False')
            {
                component.set('v.IsSubTypeCondition2Disable',false);
                if(SubTypeCondition2 == 'Others')
                {
                    component.set('v.IsAmountDisable',true);
                    component.set('v.IsCreditLimitDisable',true);
                    component.set('v.IsTradeCreditInsuranceDisable',true);
                    component.set('v.IsInternalCreditRatingDisable',true);
                    component.set('v.IsEffectiveDateDisable',true);
                    component.set('v.IsChangeCreditCreditConditionDisable',true);
                    component.set('v.IsDescriptionDisable',true);
                }
                else if(SubTypeCondition2 == 'Not first time of late payment' || SubTypeCondition2 == 'First time of late payment')
                {
                    component.set('v.IsAmountDisable',false);
                    component.set('v.IsCreditLimitDisable',true);
                    component.set('v.IsTradeCreditInsuranceDisable',true);
                    component.set('v.IsInternalCreditRatingDisable',true);
                    component.set('v.IsEffectiveDateDisable',true);
                    component.set('v.IsChangeCreditCreditConditionDisable',true);
                }
            }
            else if(SubTypeCondition == 'Internal False')
            {
                component.set('v.IsAmountDisable',false);
                
                component.set('v.IsEffectiveDateDisable',true);
                component.set('v.IsSubTypeCondition2Disable',true);
                component.set('v.IsCreditLimitDisable',true);
                component.set('v.IsTradeCreditInsuranceDisable',true);
                component.set('v.IsInternalCreditRatingDisable',true);
                component.set('v.IsChangeCreditCreditConditionDisable',true);
            }
        }
        else if(RequestToChangeCredit == 'Request to set due date of debit/credit note' || RequestToChangeCredit == 'Other requests')
        {
            component.set('v.IsSubTypeConditionDisable',true);
            component.set('v.IsSubTypeCondition2Disable',true);
            component.set('v.IsAmountDisable',true);
            component.set('v.IsCreditLimitDisable',true);
            component.set('v.IsTradeCreditInsuranceDisable',true);
            component.set('v.IsInternalCreditRatingDisable',true);
            component.set('v.IsEffectiveDateDisable',true);
            component.set('v.IsChangeCreditCreditConditionDisable',true);
            component.set('v.IsDescriptionDisable',true);
        }
        
    },
    handleRenderPicklist: function(component, event, helper) {
        var  RecTypeName = component.get("v.RecordTypeName");
        console.log('---RecTypeName--'+RecTypeName);
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        
        var CashOnDelivery = component.find("CashOnDelivery").get("v.value");
        var HavingCollateral = component.find("HavingCollateral").get("v.value");
        
        //1 HavingCollateral
        if(HavingCollateral == 'Yes')
        {
            if(buInfo.BusinessUnit__c != 'TX')
                component.set('v.CurrencyDisable',false);
            
            component.set('v.AmountBankGuaranteeIsDisable',false); 
            component.set('v.Ispass_Excelsummary',true);
            component.set('v.isAmount2Required',true);
        }
        else 
        {
            component.set('v.Ispass_Excelsummary',true);
            component.set('v.isAmount2Required ',false);
            component.set('v.AmountBankGuaranteeIsDisable',true);
            component.find("Amount2").set("v.value",0); 
        }    
        console.log('---1--');
        if(RecTypeName == 'Supplier')
        {
            var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value"); 
            
            if(CashOnDelivery == 'No' && (HavingCollateral == 'Yes' || HavingCreditTermorLetter == 'Yes'))
            {
                component.set('v.IsShowRequiredMsg',false); 
            }
            
            if(CashOnDelivery == 'No' && (HavingCollateral != 'Yes' && HavingCreditTermorLetter != 'Yes'))
            {
                component.set('v.IsShowRequiredMsg',true); 
            }
            
            //2 HavingCreditTermorLetter
            if(HavingCreditTermorLetter == 'Yes')
            {
                component.set('v.YesCreditTermIsDisable',false);
                component.set('v.isAmountCreditTermRequired  ',true);
                if(buInfo.BusinessUnit__c != 'TX')
                    component.set('v.CurrencyDisable',false);
            }
            else 
            {
                component.set('v.YesCreditTermIsDisable',true);
                component.find("AmountCreditTerm").set("v.value",0);
                component.set('v.isAmountCreditTermRequired  ',false);
            } 
        } 
        else
        {
            console.log('---2--');
            var BuyTradeEndorsement = component.find("BuyTradeEndorsement").get("v.value");
        	var BuyTradeDCLCondition = component.find("BuyTradeDCLCondition").get("v.value");
        	var HavingOpenedCredit = component.find("HavingOpenedCredit").get("v.value");
            console.log('---2.1--');
            if(CashOnDelivery == 'No' && (HavingCollateral == 'Yes' || BuyTradeEndorsement == 'Yes' || BuyTradeDCLCondition == 'Yes' || HavingOpenedCredit == 'Yes'))
            {
                console.log('---2.2--');
                component.set('v.IsShowRequiredMsg',false); 
            }
            console.log('---3--');
            if(CashOnDelivery == 'No' && (HavingCollateral != 'Yes' && BuyTradeEndorsement != 'Yes' && BuyTradeDCLCondition != 'Yes' && HavingOpenedCredit != 'Yes'))
            {
                console.log('---3.1--');
                component.set('v.IsShowRequiredMsg',true); 
            }
            console.log('---4--');
            //3 BuyTradeEndorsement
            if(BuyTradeEndorsement == 'Yes')
            {
                component.set('v.AmountBuyTradeIsDisable',false);
                component.set('v.Ispass_Excelsummary',true);
                component.set('v.isAmount3Required ',true);
                if(buInfo.BusinessUnit__c != 'TX')
                    component.set('v.CurrencyDisable',false);
            }
            else 
            {
                component.set('v.AmountDCLConditionIsDisable',true);
                component.set('v.Ispass_Excelsummary',true);
                component.find("Amount3").set("v.value",0);
                component.set('v.isAmount3Required ',false);
            }   
            console.log('---5--');
            //4 BuyTradeDCLCondition
            if(BuyTradeDCLCondition == 'Yes')
            {
                component.set('v.AmountDCLConditionIsDisable',false);
                component.set('v.Ispass_Excelsummary',true);
                component.set('v.isAmount4Required ',true);
                if(buInfo.BusinessUnit__c != 'TX')
                    component.set('v.CurrencyDisable',false);
            }
            else 
            {
                component.set('v.AmountDCLConditionIsDisable',true);
                component.set('v.Ispass_Excelsummary',true);
                component.find("Amount4").set("v.value",0);
                component.set('v.isAmount4Required ',false);
            }  
            console.log('---6--');
            //5 HavingOpenedCredit
            if(HavingOpenedCredit == 'Yes')
            {
                component.set('v.AmountOpenedCreditIsDisable',false);
                component.set('v.Ispass_Excelsummary',true);
                component.set('v.isAmount5Required ',true);
                if(buInfo.BusinessUnit__c != 'TX')
                    component.set('v.CurrencyDisable',false);
                
            }else 
            {
                component.set('v.AmountOpenedCreditIsDisable',true);
                component.set('v.Ispass_Excelsummary',true);
                component.find("Amount5").set("v.value",0);
                component.set('v.isAmount5Required ',false);
                
            }   
            console.log('---7--');
        }
        
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont); 
    },
    handleCashOnDelivery: function(component, event, helper) {
        try
        {
            console.log('---handleCashOnDelivery---');
            var  CashOnDelivery = component.find("CashOnDelivery").get("v.value"); 
            var  HavingCollateral = component.find("HavingCollateral").get("v.value");
            var  RecTypeName = component.get("v.RecordTypeName");
            var buInfo = component.get("v.BUInfo"); 
            console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
            
            if(CashOnDelivery == 'Yes' || CashOnDelivery == '' || CashOnDelivery == undefined)
            {
                component.set('v.Ispass_CashOnDelivery',true);
                component.set('v.HavingCollateralIsDisable',true);
                component.find("Amount2").set("v.value",0);
                component.find("Total_Secured_Currency__c").set("v.value",'');
                component.set('v.CurrencyDisable',true);
                component.set('v.IsRequired',false);
                component.set('v.IsShowRequiredMsg',false);
                
                if(RecTypeName == 'Customer')
                {
                    //Picklist
                    component.set('v.HavingCollateralIsDisable',true);
                    component.set('v.BuyTradeEndorsementIsDisable',true);
                    component.set('v.BuyTradeDCLConditionIsDisable',true);
                    component.set('v.HavingOpenedCreditIsDisable',true);
                    
                    //Amount
                    component.set('v.AmountBankGuaranteeIsDisable',true);
                    component.set('v.AmountBuyTradeIsDisable',true);
                    component.set('v.AmountDCLConditionIsDisable',true);
                    component.set('v.AmountOpenedCreditIsDisable',true);
                    
                    component.find("Amount2").set("v.value",0);
                    component.find("Amount3").set("v.value",0);
                    component.find("Amount4").set("v.value",0);
                    component.find("Amount5").set("v.value",0);
                    
                    //Reset Value
                    component.find("HavingCollateral").set("v.value",'');
                    component.find("BuyTradeEndorsement").set("v.value",'');
                    component.find("BuyTradeDCLCondition").set("v.value",'');
                    component.find("HavingOpenedCredit").set("v.value",'');
                }
                else if(RecTypeName == 'Supplier')
                {
                    var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value");
                    
                    component.set('v.HavingCollateralIsDisable',true);
                    component.set('v.radioCreditTermIsDisable',true);
                    component.set('v.YesCreditTermIsDisable',true);
                    component.set('v.AmountBankGuaranteeIsDisable',true);
                    component.find("Amount2").set("v.value",0);
                    component.find("AmountCreditTerm").set("v.value",0); 
                    component.find("HavingCollateral").set("v.value",'');
                    component.find("HavingCreditTermorLetter").set("v.value",'');

                    component.set('v.HavingCollateralIsDisable',true);
                    component.set('v.radioCreditTermIsDisable',true);
                }
                //document.getElementById('fieldset1').classList.remove('slds-has-error');
                let calTotalAmont = component.get('c.calTotalAmont');
                $A.enqueueAction(calTotalAmont); 
            }
            else if(CashOnDelivery == 'No')
            {
                component.find("Total_Secured_Currency__c").set("v.value",'');
                component.set('v.Ispass_CashOnDelivery',true);
                component.set('v.HavingCollateralIsDisable',false);
                component.set('v.BuyTradeEndorsementIsDisable',false);
                component.set('v.BuyTradeDCLConditionIsDisable',false);
                component.set('v.HavingOpenedCreditIsDisable',false);
                component.set('v.IsRequired',true);
                
                if(RecTypeName == 'Customer')
                {
                    console.log('---1---');
                    if(buInfo.BusinessUnit__c == 'TX')
                    {
                        console.log('---2---');
                        var BuyTradeEndorsement = component.find("BuyTradeEndorsement").get("v.value");
                        var BuyTradeDCLCondition = component.find("BuyTradeDCLCondition").get("v.value");
                        var HavingOpenedCredit = component.find("HavingOpenedCredit").get("v.value");
                        var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value"); 
                        
                        //set required field & err message
                            if(HavingCollateral == '' && BuyTradeEndorsement == '' && BuyTradeDCLCondition == '' && HavingOpenedCredit == '')
                            {
                                console.log('----ERROR- masg --');
                                component.set('v.IsRequired',true);
                                component.set('v.IsShowRequiredMsg',true);
                            }
                            
                            if(HavingCollateral != 'Yes' && BuyTradeEndorsement != 'Yes' && BuyTradeDCLCondition != 'Yes' && HavingOpenedCredit != 'Yes')
                            {
                                console.log('----ERROR- masg --');
                                component.set('v.IsRequired',true);
                                component.set('v.IsShowRequiredMsg',true);
                            }
                        
                    }
                    console.log('---4---');
                }
                else if(RecTypeName == 'Supplier')
                {
                    var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value");
                    console.log('---HavingCreditTermorLetter--'+HavingCreditTermorLetter);
                    
                    //default
                    component.set('v.HavingCollateralIsDisable',false);
                    component.set('v.radioCreditTermIsDisable',false);
                    
                    if(CashOnDelivery == 'No' && (HavingCollateral == 'Yes' || HavingCreditTermorLetter == 'Yes'))
                    {
                        component.set('v.IsShowRequiredMsg',false); 
                    }
                    
                    if(CashOnDelivery == 'No' && (HavingCollateral != 'Yes' && HavingCreditTermorLetter != 'Yes'))
                    {
                        component.set('v.IsShowRequiredMsg',true); 
                    }
                } 
                console.log('---5---');
            } 
            
        }
        catch(ex)
        {
            console.error('---handleCashOnDelivery--erropr-'+ex);
        }
        
    },
    calTotalAmont: function(component, event, helper) {
        var  RecTypeName = component.get("v.RecordTypeName");
        console.log('---RecTypeName--'+RecTypeName);
        
        if(RecTypeName == 'Customer')
        {
            var amount2 = component.find("Amount2").get("v.value");
            console.log('amount2---' + amount2);
            var amount3 = component.find("Amount3").get("v.value");
            console.log('amount3---' + amount3);
            var amount4 = component.find("Amount4").get("v.value");
            console.log('amount4---' + amount4);
            var amount5 = component.find("Amount5").get("v.value");
            console.log('amount5---' + amount5);
            
            var total = 0;
            console.log('button submittest---');
            total = Number(amount2) + Number(amount3) + Number(amount4) + Number(amount5);
            //var n=1234.567
            var parts = total.toFixed(2).split(".");
            var num = parts[0].replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + 
                (parts[1] ? "." + parts[1] : "");
            console.log('button submittest------'+num);
            component.find("Amount6").set("v.value",num);
        }
        else
        {
            var amount2 = component.find("Amount2").get("v.value");
            var AmountCreditTerm = component.find("AmountCreditTerm").get("v.value");
            
            console.log('amount2---' + amount2);
            console.log('AmountCreditTerm---' + AmountCreditTerm);
            
            var total = 0;
            console.log('button submittest---');
            total = Number(amount2) + Number(AmountCreditTerm);
            //var n=1234.567
            var parts = total.toFixed(2).split(".");
            var num = parts[0].replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + 
                (parts[1] ? "." + parts[1] : "");
            console.log('button submittest------'+num);
            component.find("Amount6").set("v.value",num);
        }
    },
    TemplateLink : function(component,event, helper,recordId) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.CTRDownloadExcelTemplate");
        // Set spinner action On!
        component.set("v.showLoading",true);
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const base64 = response.getReturnValue();  // …
                if(!base64.includes('Error'))
                {
                    const link = document.createElement('a');
                    link.href = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,' + base64;
                    link.download = 'Excel-Template.xlsx';
                    link.click();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": 'File is generated',
                        "type" : "success"
                    });
                    toastEvent.fire();
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": base64,
                        "type" : "error"
                    });
                    toastEvent.fire();
                }
                
                // Set spinner action Off!
                component.set("v.showLoading",false);
            } else {
                console.error("Error fetching Blob file");
                component.set("v.showLoading",false);
            }
        });
        
        $A.enqueueAction(action);
    },
    SharePointLink : function(component,event, helper) {
        var urlval = component.get("v.SharePointLink");
        console.log('---urlval---'+urlval);
        window.open(urlval, '_blank');
    },
})