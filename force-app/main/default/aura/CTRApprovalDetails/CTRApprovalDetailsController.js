({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('---recordId---'+recordId);
        helper.getBUInformation(component,event, recordId);
        //helper.getRequestItems(component,event, recordId);        
    },
    toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 open/close section
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close'); 
        }
    },
    handleClick : function(component, event, helper) {
        
        console.log('---handleClick---');
        var buInfo = component.get("v.BUInfo"); 
        var  ApproverStep = component.get("v.ApproverStepVal");
        console.log('---ButtonLabel-Submit--'+ApproverStep);
        var TypeOfBusiness = component.find("TypeOfBusiness").get("v.value"); 
        console.log('---TypeOfBusiness---'+TypeOfBusiness);
        var  RecTypeName = component.get("v.RecordTypeName");
        console.log('---RecTypeName--'+RecTypeName);
        
        component.set('v.IsButtonDisable',false);
        component.set('v.IsEditButtonDisable',true);
        
        if(TypeOfBusiness=="Other"){
            component.set('v.IsTypeOfBusinessOtherDisable',false);
            component.set('v.IsOtherRequired',true);
        }
        
        if(ApproverStep == 'TRCR')
        {
            component.set('v.IsPageDisable',false);
            component.set('v.IsWaiveDisable',false);
            
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
                        component.set('v.radio2IsDisable',false);
                        component.set('v.radio3IsDisable',false); 
                        component.set('v.radio4IsDisable',false);
                        component.set('v.radio5IsDisable',false);
                        
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
                        component.set('v.radio2IsDisable',false);
                        component.set('v.Yes2IsDisable',false);

                    }else 
                        component.set('v.radio2IsDisable',false);
                    
                    if(BuyTradeEndorsement == 'Yes'){
                        component.set('v.radio3IsDisable',false);
                        component.set('v.Yes3IsDisable',false);
                    }else 
                        component.set('v.radio3IsDisable',false);
                    
                    if(BuyTradeDCLCondition == 'Yes'){
                        component.set('v.radio4IsDisable',false);
                        component.set('v.Yes4IsDisable',false);
                    }else 
                        component.set('v.radio4IsDisable',false);
                    
                    if(HavingOpenedCredit == 'Yes'){
                        component.set('v.radio5IsDisable',false);
                        component.set('v.Yes5IsDisable',false);
                    }else 
                        component.set('v.radio5IsDisable',false);
                }
                else if(RecTypeName == 'Supplier')
                {
                    var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value");
                    console.log('---HavingCreditTermorLetter--'+HavingCreditTermorLetter);
                    if(CashOnDelivery == 'No')
                    {
                        console.log('---No1--');
                        component.set('v.radio2IsDisable',false);
                        component.set('v.radioCreditTermIsDisable',false);
                        
                        //enable picklist
                        if(HavingCollateral == 'Yes'){
                            component.set('v.radio2IsDisable',false);
                            component.set('v.Yes2IsDisable',false);
    
                        }else 
                            component.set('v.radio2IsDisable',false);
                        
                        if(HavingCreditTermorLetter == 'Yes'){
                            component.set('v.radioCreditTermIsDisable',false);
                            component.set('v.YesCreditTermIsDisable',false);
                        }else 
                            component.set('v.radioCreditTermIsDisable',false);
                    }else
                    {
                        console.log('---Yes1--');
                        component.set('v.radio2IsDisable',true);
                        component.set('v.radioCreditTermIsDisable',true);
					}
                }    
            }
        } 
        else if(ApproverStep == 'Trader')
        {
            console.log('---Trader--');
            component.set('v.IsTDWaiveDisable',false); 
            component.set('v.IsTypeOfBusinessOtherDisable',true); 
            //this.handleTDNoWaiveRequest(component, event, helper);
            
            var TDNoWaiveRequestAction = component.get('c.handleTDNoWaiveRequest');
            $A.enqueueAction(TDNoWaiveRequestAction); 
            
        }
            else if(ApproverStep == 'SH')
            {
                component.set('v.IsSHDisable',false);
                component.set('v.IsTypeOfBusinessOtherDisable',true); 
            }
                else if(ApproverStep == 'VP')
                {
                    component.set('v.IsVPDisable',false);
                    component.set('v.IsTypeOfBusinessOtherDisable',true); 
                }
        
        
    },
    handleCancel : function(component, event, helper) {
        component.set('v.IsEditButtonDisable',false);
        console.log('button cancel---');
        component.set('v.IsPageDisable',true);
        component.set('v.IsWaiveDisable',true);
        component.set('v.IsButtonDisable',true);
        component.set('v.IsTDFieldsDisable',true);
        component.set('v.IsTDWaiveDisable',true);
        component.set('v.IsSHDisable',true);
        component.set('v.IsVPDisable',true);
        component.set('v.radioCreditTermIsDisable',true);
        component.set('v.YesCreditTermIsDisable',true);
        component.set('v.radio2IsDisable',true);
        component.set('v.Yes2IsDisable',true);
        component.set('v.CurrencyDisable',true);
        component.set('v.radio3IsDisable',true);
        component.set('v.Yes3IsDisable',true);
        
        component.set('v.radio4IsDisable',true);
        component.set('v.Yes4IsDisable',true);
        component.set("v.ButtonLabel",'');
        window.location.reload();
        
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
    handleSubmit : function(component, event, helper) {
        
        console.log('---handleSubmit---');
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        var ButtonLabel1 = component.get("v.ButtonLabel");
        console.log('---ButtonLabel1---'+ButtonLabel1);
        if(ButtonLabel1 != undefined && ButtonLabel1 != '')
        {
            
            var today = new Date();
            console.log('---today.toISOString()---'+today.toISOString());
            var  ApproverStep = component.get("v.ApproverStepVal");
            console.log('---ButtonLabel-Submit--'+ApproverStep);
            var  RecTypeName = component.get("v.RecordTypeName");
            console.log('---RecTypeName--'+RecTypeName);
            //save to DB
            try
            {
                event.preventDefault();
                const fields = event.getParam('fields');
                console.log('---Save--'+buInfo.BusinessUnit__c);
                console.log('---Save-2-'+component.get("v.CreditOwnerId"));
                if(component.get("v.CreditOwnerId") == null)
                {
                    fields.CreditOwner__c = $A.get("$SObjectType.CurrentUser.Id");
                }
                else
                {
                    fields.CreditOwner__c = component.get("v.CreditOwnerId");
                }
                fields.OwnersCMVP__c = component.get("v.VPId");
                fields.OwnersSectionHead__c = component.get("v.SectionHeadId");
                
                console.log('---RecTypeName--'+RecTypeName);
                var checkAmountPass = true;
                if(buInfo.BusinessUnit__c=="TX")
                {
                    var msgErr = 'Amount need to be more than zero';
                    if(RecTypeName == 'Customer') 
                    {
                        var CashOnDelivery1 = component.find("CashOnDelivery").get("v.value");
                        console.log('CashOnDelivery1---' + CashOnDelivery1);
                    
                        var amount2 = component.find("Amount2").get("v.value");
                        var HavingCollateral = component.find("HavingCollateral").get("v.value");
                        console.log('amount2---' + amount2);
                        
                        var amount3 = component.find("Amount3").get("v.value");
                        var BuyTradeEndorsement = component.find("BuyTradeEndorsement").get("v.value");
                        console.log('amount3---' + amount3);
                        
                        var amount4 = component.find("Amount4").get("v.value");
                        var BuyTradeDCLCondition = component.find("BuyTradeDCLCondition").get("v.value");
                        console.log('amount4---' + amount4);
                        
                        var amount5 = component.find("Amount5").get("v.value");
                        var HavingOpenedCredit = component.find("HavingOpenedCredit").get("v.value");
                        console.log('amount5---' + amount5);
                        
                        if((amount2 <= 0 && HavingCollateral == 'Yes') || (amount3 <= 0 && BuyTradeEndorsement == 'Yes') || (amount4 <= 0 && BuyTradeDCLCondition == 'Yes') || (amount5 <= 0 && HavingOpenedCredit == 'Yes'))
                        {
                            checkAmountPass = false;
                            if(amount2 <= 0 && HavingCollateral == 'Yes')
                            	component.set('v.isAmount2Required',true);
                            else if(amount3 <= 0 && BuyTradeEndorsement == 'Yes')
                                component.set('v.isAmount3Required',true);
                            else if(amount4 <= 0 && BuyTradeDCLCondition == 'Yes')
                                component.set('v.isAmount4Required',true);
                            else if(amount5 <= 0 && HavingOpenedCredit == 'Yes')
                                component.set('v.isAmount5Required',true);
                        }
                        
                        if(CashOnDelivery1 == 'Yes')
                        {
                            checkAmountPass = true;
                        }
                        else if(CashOnDelivery1 == 'No')
                        {
                            console.log('----CashOnDelivery1- NO --');
                            if((HavingCollateral == '' && BuyTradeEndorsement == '' && BuyTradeDCLCondition == '' && HavingOpenedCredit == '')||(HavingCollateral == 'Yes' || BuyTradeEndorsement == 'Yes' || BuyTradeDCLCondition == 'Yes' || HavingOpenedCredit == 'Yes'))
                            {
                                console.log('----ERROR- masg --');
                                component.set('v.IsRequired',true);
                                component.set('v.IsShowRequiredMsg',true);
                            }
                        }                    
                    }
                    else
                    {
                        var amount2 = component.find("Amount2").get("v.value");
                        var HavingCollateral = component.find("HavingCollateral").get("v.value");
                        
                        var AmountCreditTerm = component.find("AmountCreditTerm").get("v.value");
                        var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value");
                        
                        console.log('amount2---' + amount2);
                        console.log('AmountCreditTerm---' + AmountCreditTerm);
                        
                        if((amount2 <= 0 && HavingCollateral == 'Yes') || (AmountCreditTerm <= 0 && HavingCreditTermorLetter == 'Yes'))
                        {
                            checkAmountPass = false;
                        }
                        
                        if(HavingCollateral == 'No' && HavingCreditTermorLetter == 'No')
                        {
                            checkAmountPass = false;
                            msgErr = 'Please complete all required fields.';
                            component.set('v.IsShowRequiredMsg',true);
                            //component.set('v.IsRequired',true);
                        }
                            
                    }
                }   
                
                if(checkAmountPass)
                {
                    
                    if(ApproverStep == 'Trader')
                    {
                        console.log('--Save-Trader---');
                        fields.IsTraderSaved__c = true;
                    }
                    
                    if(buInfo.BusinessUnit__c == "TOP" || buInfo.BusinessUnit__c == "LABIX")
                    {
                        fields.InternalCreditRating__c = fields.InternalCreditRatingTOP__c;
                    }
                    
                    
                    //Save Function
                    if(ButtonLabel1 == 'Save')
                    {
                        var msgToast = '';
                        
                        if(ApproverStep == 'TRCR')
                        {
                            var loginuser = component.get("v.LogInUserId");
                            var CreditOwnerId = component.get("v.CreditOwnerId");
                            if(loginuser != CreditOwnerId && CreditOwnerId != null && CreditOwnerId != '' && CreditOwnerId != undefined)
                            {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "message": 'Credit evaluation has been reassigned to delegated person!',
                                    "type" : "success"
                                });
                                toastEvent.fire();
                            }
                            else
                            {
                                var toastEvent = $A.get("e.force:showToast");
                                console.log('--Save---'+msgToast); 
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "message": 'Credit evaluation has been saved!',
                                    "type" : "success"
                                });
                                toastEvent.fire();
                            }
                            
                        }
                        if(ApproverStep == 'Trader')
                        {
                            var toastEvent = $A.get("e.force:showToast");
                                if(RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "TOP")
                                    msgToast = 'Performance Bond exemption has been saved!';
                                else 
                                    msgToast = 'Credit exemption has been saved!';
                                        
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": msgToast,
                                "type" : "success"
                            });
                            toastEvent.fire();
                        }
                        if(ApproverStep == 'SH')
                        {
                            var toastEvent = $A.get("e.force:showToast");
                                if(RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "TOP")
                                    msgToast = 'Performance Bond exemption has been saved';
                                else 
                                    msgToast = 'Credit exemption has been saved!';
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": msgToast,
                                "type" : "success"
                            });
                            toastEvent.fire();
                        }
                        if(ApproverStep == 'VP')
                        {
                            var toastEvent = $A.get("e.force:showToast");
                                if(RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "TOP")
                                    msgToast = 'Performance Bond exemption has been saved';
                                else 
                                    msgToast = 'Credit exemption has been saved!';
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": msgToast,
                                "type" : "success"
                            });
                            toastEvent.fire();
                        }
                    }
                    
                    //Submit Function
                    if(ButtonLabel1 == 'Submit')
                    {
                        //update step
                        if(ApproverStep == 'TRCR')
                        {   
                            //TRCR submitted
                            if (buInfo.BusinessUnit__c == "TX")
                            {
                                fields.ApproverStep__c = 'Done';
                                fields.Approval_Step__c = 'Select Committee';
                                
                                component.set("v.ApproverStepVal",'Done');
                                
                                
                            }
                            else{
                                fields.ApproverStep__c = 'Trader';
                                fields.Approval_Step__c = 'Credit Exemption';
                                component.set("v.ApproverStepVal",'Trader');
                                component.set('v.CurrentStepUserId',component.get("v.TraderId"));
                            }
                            fields.Status__c = 'In Review';
                            
                            //Render msg
                            /*var msgToast = '';
                            if( (RecTypeName == 'Customer') || (RecTypeName == 'Supplier' && (buInfo.BusinessUnit__c == "LABIX" || buInfo.BusinessUnit__c == "TX")) )
                                msgToast = "Credit Evaluation has been completed!";
                            else if(RecTypeName == 'Supplier')
                                msgToast = "Performance Bond Evaluation has been completed!"; */
                            
                            
                            fields.Approval_TRCRSubmitDate__c = today.toISOString();	
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "Credit Evaluation has been completed!",
                                "type" : "success"
                            });
                            toastEvent.fire();
                        }
                        else if(ApproverStep == 'Trader')
                        {
                            var msgToast = '';
                            fields.ApproverStep__c = 'SH';
                            fields.Approval_TraderSubmitDate__c = today.toISOString();
                            
                            component.set("v.ApproverStepVal",'SH');
                            component.set('v.CurrentStepUserId',component.get("v.SectionHeadId"));
                            
                            
                            var NoWaiveRequest = component.find("TraderWaive").get("v.value");
                            if(NoWaiveRequest == 'No')
                            {
                                if(RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "TOP")
                                    msgToast = 'Performance Bond exemption has been completed!';
                                else 
                                    msgToast = 'Credit exemption has been completed!';
                                
                                fields.Approval_Step__c = 'Select Committee';
                                fields.ApproverStep__c = 'Done';
                                component.set("v.ApproverStepVal",'Done');
                            }
                            else
                            {
                                //Render msg
                                if(RecTypeName == 'Customer' || (RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "LABIX"))
                                    msgToast = "Credit exemption has been sent to Section Head!";
                                else if(RecTypeName == 'Supplier')
                                    msgToast = "Performance Bond exemption has been sent to Section Head!";
                            }
                            
                            var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "message": msgToast,
                                    "type" : "success"
                                });
                                toastEvent.fire();
                            
                        }
                            else if(ApproverStep == 'SH')
                            {
                                //Approval_SHAgree
                                var SHAgree = component.find("Approval_SHAgree").get("v.value");
                                console.log('--SHAgree---'+SHAgree);
                                //Render msg
                                var msgToast = '';
                                
                                if(SHAgree == 'Yes')
                                {
                                    fields.ApproverStep__c = 'VP';
                                    fields.Approval_Step__c = 'Credit Exemption';
                                    
                                    if(RecTypeName == 'Customer')
                                    {
                                        if(buInfo.BusinessUnit__c == "TOP")
                                        	msgToast = "Credit exemption has been sent to CMVP or SA09!";
                                    	else if (buInfo.BusinessUnit__c == "LABIX")
                                            msgToast = "Credit exemption has been sent to DMD!";
                                    }
                                    else if(RecTypeName == 'Supplier')
                                    {
                                        if(buInfo.BusinessUnit__c == "TOP")
                                            msgToast = "Performance Bond exemption has been sent to CMVP or SA09!";
                                        else if(buInfo.BusinessUnit__c == "LABIX")
                                            msgToast = "Credit exemption has been sent to DMD!";
                                    }
                                    component.set("v.ApproverStepVal",'VP');
                                    component.set('v.CurrentStepUserId',component.get("v.VPId"));
                                    
                                }
                                else if(SHAgree == 'No')
                                {
                                    fields.ApproverStep__c = 'Done';
                                    fields.Approval_Step__c = 'Select Committee';
                                    if(RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "TOP")
                                        msgToast = "Performance Bond exemption has been completed!";
                                    else 																//if(RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "LABIX")
                                        msgToast = "Credit exemption has been completed!";
                                    
                                    component.set("v.ApproverStepVal",'Done');
                                }
                                //fields.ApproverStep__c = 'VP';
                                fields.Approval_SHSubmitDate__c = today.toISOString();
                                
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Success!",
                                    "message": msgToast,
                                    "type" : "success"
                                });
                                toastEvent.fire();
                            }
                                else if(ApproverStep == 'VP')
                                {
                                    //Render msg
                                    var msgToast = '';
                                    if(RecTypeName == 'Customer' || (RecTypeName == 'Supplier' && buInfo.BusinessUnit__c == "LABIX") )
                                        msgToast = "Credit exemption has been completed!";
                                    else if(RecTypeName == 'Supplier')
                                        msgToast = "Performance Bond exemption has been completed!";
                                    
                                    fields.ApproverStep__c = 'Done';
                                    fields.Approval_VPSubmitDate__c = today.toISOString();
                                    fields.Approval_Step__c = 'Select Committee';
                                    
                                    component.set("v.ApproverStepVal",'Done');
                                    
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Success!",
                                        "message": msgToast,
                                        "type" : "success"
                                    });
                                    toastEvent.fire();
                                }
                    }
                    console.log('---Saved--');
                    
                    
                    
                    
                    component.find('recordEditForm').submit(fields); 
                    //disable fields
                    component.set('v.IsTDFieldsDisable',true);
                    component.set('v.IsTDWaiveDisable',true);
                    component.set('v.IsSHDisable',true);
                    component.set('v.IsVPDisable',true);
                    component.set('v.radio2IsDisable',true);
                    component.set('v.radioCreditTermIsDisable',true);
                    component.set('v.radio3IsDisable',true);
                    component.set('v.radio4IsDisable',true);
                    component.set('v.radio5IsDisable',true);
                    component.set('v.Yes2IsDisable',true);
                    component.set('v.Yes3IsDisable',true);
                    component.set('v.Yes4IsDisable',true);
                    component.set('v.Yes5IsDisable',true);
                    component.set('v.Yes5IsDisable',true);
                    component.set('v.YesCreditTermIsDisable',true);
                    component.set('v.CurrencyDisable',true);
                    component.set('v.IsPageDisable',true); 
                    
                    console.log('---Done--');
                    //window.location.reload();
                    //$A.get('e.force:refreshView').fire();
                    /*
                        
                        component.set('v.IsWaiveDisable',true);  
                        component.set('v.IsButtonDisable',true);
                        component.set('v.IsTypeOfBusinessOtherDisable',true);*/
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": msgErr,
                        "type" : "error"
                    });
                    toastEvent.fire();
                }
                
            }
            catch(ex)
            {
                console.error('ex---'+ex.message);            
            }
            
        }
        
        component.set('v.IsEditButtonDisable',false);
        
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
    handleReassignFunction: function(component, event, helper) {
        try
        {
            console.log('---handleReassignFunction---');
            
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    handleTypeOfBusiness : function(component, event, helper) {
        
        console.log('---handleTypeOfBusiness---');
        var TypeOfBusiness = component.find("TypeOfBusiness").get("v.value"); //component.find("TypeOfBusiness").getElement().value;
        console.log('---TypeOfBusiness---'+TypeOfBusiness);
        if(TypeOfBusiness == 'Other'){
            component.set('v.IsTypeOfBusinessOtherDisable',false);
            component.set('v.IsOtherRequired',true);
            
        }else{
            component.find("TypeOfBusinessOther__c").set("v.value",'');
            component.set('v.IsTypeOfBusinessOtherDisable',true);
            component.set('v.IsOtherRequired',false);
        }    
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
                component.set('v.radio2IsDisable',true);
                component.find("Amount2").set("v.value",0);
                component.find("Total_Secured_Currency__c").set("v.value",'');
                component.set('v.CurrencyDisable',true);
                component.set('v.IsRequired',false);
                component.set('v.IsShowRequiredMsg',false);
                
                if(RecTypeName == 'Customer')
                {
                    //Picklist
                    component.set('v.radio2IsDisable',true);
                    component.set('v.radio3IsDisable',true);
                    component.set('v.radio4IsDisable',true);
                    component.set('v.radio5IsDisable',true);
                    
                    //Amount
                    component.set('v.Yes2IsDisable',true);
                    component.set('v.Yes3IsDisable',true);
                    component.set('v.Yes4IsDisable',true);
                    component.set('v.Yes5IsDisable',true);
                    
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
                    
                    component.set('v.radio2IsDisable',true);
                    component.set('v.radioCreditTermIsDisable',true);
                    component.set('v.YesCreditTermIsDisable',true);
                    component.set('v.Yes2IsDisable',true);
                    component.find("Amount2").set("v.value",0);
                    component.find("AmountCreditTerm").set("v.value",0); 
                    component.find("HavingCollateral").set("v.value",'');
                    component.find("HavingCreditTermorLetter").set("v.value",'');

                    component.set('v.radio2IsDisable',true);
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
                component.set('v.radio2IsDisable',false);
                component.set('v.radio3IsDisable',false);
                component.set('v.radio4IsDisable',false);
                component.set('v.radio5IsDisable',false);
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
                    component.set('v.radio2IsDisable',false);
                    component.set('v.radioCreditTermIsDisable',false);
                    
                    if(CashOnDelivery == 'No' && (HavingCollateral == 'Yes' || HavingCreditTermorLetter == 'Yes'))
                    {
                        component.set('v.IsShowRequiredMsg',false); 
                    }
                    
                    if(CashOnDelivery == 'No' && (HavingCollateral != 'Yes' && HavingCreditTermorLetter != 'Yes'))
                    {
                        component.set('v.IsShowRequiredMsg',true); 
                    }
                    
                        
                    //enable picklist
                    /*    if(HavingCollateral == 'Yes'){
                            component.set('v.radio2IsDisable',false);
                            component.set('v.Yes2IsDisable',false);
    
                        }else 
                            component.set('v.radio2IsDisable',false);
                        
                        if(HavingCreditTermorLetter == 'Yes'){
                            component.set('v.radioCreditTermIsDisable',false);
                            component.set('v.YesCreditTermIsDisable',false);
                        }else 
                            component.set('v.radioCreditTermIsDisable',false);
                    */
                } 
                console.log('---5---');
            } 
            
        }
        catch(ex)
        {
            console.error('---handleCashOnDelivery--erropr-'+ex);
        }
        
    },
    
    /*handleHavingCollateral: function(component, event, helper) {
        
        console.log('---handleHavingCollateral---');
        var HavingCollateral = component.find("HavingCollateral").get("v.value"); //component.find("TypeOfBusiness").getElement().value;
        console.log('---HavingCollateral---'+HavingCollateral);
        var  ApproverStep = component.get("v.ApproverStepVal");
        console.log('---ButtonLabel-Submit--'+ApproverStep);
        var  RecTypeName = component.get("v.RecordTypeName");
        console.log('---RecTypeName--'+RecTypeName);
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        
        if(HavingCollateral == 'Yes')
        {
            if(buInfo.BusinessUnit__c != 'TX')
            {
                component.set('v.CurrencyDisable',false);
            }
            
            component.set('v.Yes2IsDisable',false); 
            component.set('v.Ispass_Excelsummary',true);
        }
        else 
        {
            component.set('v.Ispass_Excelsummary',true);
            component.set('v.Yes2IsDisable',true);
            component.find("Amount2").set("v.value",0); 
        }    
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont); 
        
    },
    handleHavingCreditTermorLetter: function(component, event, helper){
        
        console.log('---handleHavingCreditTermorLetter---');
        var HavingCreditTermorLetter = component.find("HavingCreditTermorLetter").get("v.value"); //component.find("TypeOfBusiness").getElement().value;
        console.log('---HavingCreditTermorLetter---'+HavingCreditTermorLetter);
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        
        if(HavingCreditTermorLetter == 'Yes')
        {
            //component.set('v.IsRequired',false);
            component.set('v.YesCreditTermIsDisable',false);
            if(buInfo.BusinessUnit__c != 'TX')
            {
                component.set('v.CurrencyDisable',false);
            }
        }
        else 
        {
            component.set('v.YesCreditTermIsDisable',true);
            component.find("AmountCreditTerm").set("v.value",0);
        } 
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont); 
    },
    handleBuyTradeEndorsement: function(component, event, helper)
    {
        console.log('---handleBuyTradeEndorsement---');
        var BuyTradeEndorsement = component.find("BuyTradeEndorsement").get("v.value"); //component.find("TypeOfBusiness").getElement().value;
        console.log('---BuyTradeEndorsement---'+BuyTradeEndorsement);
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        
        
        if(BuyTradeEndorsement == 'Yes')
        {
            //component.set('v.IsRequired',false);
            component.set('v.Yes3IsDisable',false);
            component.set('v.Ispass_Excelsummary',true);
            
            if(buInfo.BusinessUnit__c != 'TX')
            {
                component.set('v.CurrencyDisable',false);
            }
        }
        else 
        {
            component.set('v.Yes3IsDisable',true);
            component.set('v.Ispass_Excelsummary',true);
            component.find("Amount3").set("v.value",0);
        }   
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont); 
    },
    handleBuyTradeDCLCondition: function(component, event, helper)
    {
        
        console.log('---handleBuyTradeDCLCondition---');
        var BuyTradeDCLCondition = component.find("BuyTradeDCLCondition").get("v.value"); //component.find("TypeOfBusiness").getElement().value;
        console.log('---BuyTradeDCLCondition---'+BuyTradeDCLCondition);
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        if(BuyTradeDCLCondition == 'Yes'){
            //component.set('v.IsRequired',false);
            component.set('v.Yes4IsDisable',false);
            component.set('v.Ispass_Excelsummary',true);
            if(buInfo.BusinessUnit__c != 'TX')
            {
                component.set('v.CurrencyDisable',false);
            }
        }
        else 
        {
            component.set('v.Yes4IsDisable',true);
            component.set('v.Ispass_Excelsummary',true);
            component.find("Amount4").set("v.value",0);
        }    
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont);  
    },
    handleHavingOpenedCredit: function(component, event, helper){
        
        console.log('---handleHavingOpenedCredit---');
        var HavingOpenedCredit = component.find("HavingOpenedCredit").get("v.value"); //component.find("TypeOfBusiness").getElement().value;
        console.log('---HavingOpenedCredit---'+HavingOpenedCredit);
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        if(HavingOpenedCredit == 'Yes')
        {
            //component.set('v.IsRequired',false);
            component.set('v.Yes5IsDisable',false);
            component.set('v.Ispass_Excelsummary',true);
            
            if(buInfo.BusinessUnit__c != 'TX')
            {
                component.set('v.CurrencyDisable',false);
            }
        }else 
        {
            component.set('v.Yes5IsDisable',true);
            component.set('v.Ispass_Excelsummary',true);
            component.find("Amount5").set("v.value",0);
            
        }   
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont);
    }, */
    handleRenderPicklist: function(component, event, helper) 
    {
        var  ApproverStep = component.get("v.ApproverStepVal");
        console.log('---ButtonLabel-Submit--'+ApproverStep);
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
            
            component.set('v.Yes2IsDisable',false); 
            component.set('v.Ispass_Excelsummary',true);
            component.set('v.isAmount2Required ',true);
        }
        else 
        {
            component.set('v.Ispass_Excelsummary',true);
            component.set('v.isAmount2Required ',false);
            component.set('v.Yes2IsDisable',true);
            component.find("Amount2").set("v.value",0); 
        }    
        
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
            var BuyTradeEndorsement = component.find("BuyTradeEndorsement").get("v.value");
        	var BuyTradeDCLCondition = component.find("BuyTradeDCLCondition").get("v.value");
        	var HavingOpenedCredit = component.find("HavingOpenedCredit").get("v.value");
            
            if(CashOnDelivery == 'No' && (HavingCollateral == 'Yes' || BuyTradeEndorsement == 'Yes' || BuyTradeDCLCondition == 'Yes' || HavingOpenedCredit == 'Yes'))
            {
                component.set('v.IsShowRequiredMsg',false); 
            }
            
            if(CashOnDelivery == 'No' && (HavingCollateral != 'Yes' && BuyTradeEndorsement != 'Yes' && BuyTradeDCLCondition != 'Yes' && HavingOpenedCredit != 'Yes'))
            {
                component.set('v.IsShowRequiredMsg',true); 
            }
            
            //3 BuyTradeEndorsement
            if(BuyTradeEndorsement == 'Yes')
            {
                component.set('v.Yes3IsDisable',false);
                component.set('v.Ispass_Excelsummary',true);
                component.set('v.isAmount3Required ',true);
                if(buInfo.BusinessUnit__c != 'TX')
                    component.set('v.CurrencyDisable',false);
            }
            else 
            {
                component.set('v.Yes3IsDisable',true);
                component.set('v.Ispass_Excelsummary',true);
                component.find("Amount3").set("v.value",0);
                component.set('v.isAmount3Required ',false);
            }   
            
            //4 BuyTradeDCLCondition
            if(BuyTradeDCLCondition == 'Yes')
            {
                component.set('v.Yes4IsDisable',false);
                component.set('v.Ispass_Excelsummary',true);
                component.set('v.isAmount4Required ',true);
                if(buInfo.BusinessUnit__c != 'TX')
                    component.set('v.CurrencyDisable',false);
            }
            else 
            {
                component.set('v.Yes4IsDisable',true);
                component.set('v.Ispass_Excelsummary',true);
                component.find("Amount4").set("v.value",0);
                component.set('v.isAmount4Required ',false);
            }  
            
            //5 HavingOpenedCredit
            if(HavingOpenedCredit == 'Yes')
            {
                component.set('v.Yes5IsDisable',false);
                component.set('v.Ispass_Excelsummary',true);
                component.set('v.isAmount5Required ',true);
                if(buInfo.BusinessUnit__c != 'TX')
                    component.set('v.CurrencyDisable',false);
                
            }else 
            {
                component.set('v.Yes5IsDisable',true);
                component.set('v.Ispass_Excelsummary',true);
                component.find("Amount5").set("v.value",0);
                component.set('v.isAmount5Required ',false);
                
            }   
        }
        
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont); 
        
        
    },
    /*handleRadio17 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("National").getElement().value;
        console.log(doc);
        component.set('v.OtherRadioIsDisable',true);
    },
    handleRadio18 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("EndUser").getElement().value;
        console.log(doc);
        component.set('v.OtherRadioIsDisable',true);
    },
    handleRadio19 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("TraderandDistributor").getElement().value;
        console.log(doc);
        component.set('v.OtherRadioIsDisable',true);
    },
    handleRadio20 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("Other").getElement().value;
        console.log(doc);
        component.set('v.OtherRadioIsDisable',false);
    },
    handleRadioYes1 : function(component, event, helper) {
        
        var  RecTypeName = component.get("v.RecordTypeName");
        console.log('---RecTypeName--'+RecTypeName);
        console.log('button radio---');
        var doc = component.find("Yes-1").getElement().value;
        console.log(doc);
        component.set('v.Yes1IsDisable',false);
            component.set('v.Ispass_CashOnDelivery',true);
            component.set('v.radio2IsDisable',true);
        component.find("Yes-2").getElement().checked = false;
        component.find("No-2").getElement().checked = false;
        component.find("Amount2").set("v.value",0);
        component.set('v.Yes2IsDisable',true);
        if(RecTypeName != 'Supplier')
        {
            
            component.set('v.radio3IsDisable',true);
            component.set('v.radio4IsDisable',true);
            component.set('v.radio5IsDisable',true);
            
            
            component.find("Yes-3").getElement().checked = false;
            component.find("Yes-4").getElement().checked = false;
            component.find("Yes-5").getElement().checked = false;
            
            component.find("No-3").getElement().checked = false;
            component.find("No-4").getElement().checked = false;
            component.find("No-5").getElement().checked = false;
            
            
            component.find("Amount3").set("v.value",0);
            component.find("Amount4").set("v.value",0);
            component.find("Amount5").set("v.value",0);
            
            
            
            component.set('v.Yes3IsDisable',true);
            component.set('v.Yes4IsDisable',true);
            component.set('v.Yes5IsDisable',true);
            //this.calTotalAmont(component, event, helper);
        }
        else
        {
            component.find("Yes-CreditTerm").getElement().checked = false;
            component.find("No-CreditTerm").getElement().checked = false;
            
            component.set('v.radioCreditTermIsDisable',true);
            component.set('v.YesCreditTermIsDisable',true);
            
            component.find("AmountCreditTerm").set("v.value",0);
           // this.calTotalAmont(component, event, helper);
        }
        document.getElementById('fieldset1').classList.remove('slds-has-error');
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont); 
        
    },
    handleRadioNo1 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("No-1").getElement().value;
        console.log(doc);
        component.set('v.Yes1IsDisable',true);
        component.set('v.Ispass_CashOnDelivery',true);
        component.set('v.radio2IsDisable',false);
        component.set('v.radio3IsDisable',true);
        component.set('v.radio4IsDisable',true);
        component.set('v.radio5IsDisable',true);
        document.getElementById('fieldset1').classList.remove('slds-has-error');
        
        component.find("Yes-3").getElement().checked = false;
        component.find("Yes-4").getElement().checked = false;
        component.find("Yes-5").getElement().checked = false;
        component.find("No-3").getElement().checked = false;
        component.find("No-4").getElement().checked = false;
        component.find("No-5").getElement().checked = false;
        component.set('v.Yes3IsDisable',true);
        component.set('v.Yes4IsDisable',true);
        component.set('v.Yes5IsDisable',true);
    },
    handleRadioYes2 : function(component, event, helper) {
        
        console.log('button radio-handleRadioYes2--');
        var  ApproverStep = component.get("v.ApproverStepVal");
        console.log('---ButtonLabel-Submit--'+ApproverStep);
        var  RecTypeName = component.get("v.RecordTypeName");
        console.log('---RecTypeName--'+RecTypeName);
        
        if(RecTypeName == 'Supplier')
        {
            console.log('---radioCreditTermIsDisabl--before')
            component.set('v.radioCreditTermIsDisable',false);
            console.log('---radioCreditTermIsDisable--'+component.get('v.radioCreditTermIsDisable'));
        }
        
        var doc = component.find("Yes-2").getElement().value;
        console.log('---Yes-2--'+doc);
        
        component.set('v.Yes2IsDisable',false);
        component.set('v.Ispass_Excelsummary',true);
        document.getElementById('fieldset2').classList.remove('slds-has-error');
        document.getElementById('fieldset3').classList.remove('slds-has-error');
        document.getElementById('fieldset4').classList.remove('slds-has-error');
        document.getElementById('fieldset5').classList.remove('slds-has-error');
        component.set('v.radio3IsDisable',true);
        component.set('v.radio4IsDisable',true);
        component.set('v.radio5IsDisable',true);
        
        component.find("Yes-3").getElement().checked = false;
        component.find("Yes-4").getElement().checked = false;
        component.find("Yes-5").getElement().checked = false;
        component.find("No-3").getElement().checked = false;
        component.find("No-4").getElement().checked = false;
        component.find("No-5").getElement().checked = false;
        component.set('v.Yes3IsDisable',true);
        component.set('v.Yes4IsDisable',true);
        component.set('v.Yes5IsDisable',true);
        
        
       
    },
    handleRadioNo2 : function(component, event, helper) {
        
        try
        {
            console.log('button radio---');
        var doc = component.find("No-2").getElement().value;
        var  RecTypeName = component.get("v.RecordTypeName");
        console.log('---RecTypeName--'+RecTypeName);
            console.log(doc);
            component.set('v.Yes2IsDisable',true);
            component.set('v.Ispass_Excelsummary',true);
            
            if(RecTypeName == 'Supplier')
            {
                console.log('---radioCreditTermIsDisabl--before')
                component.set('v.radioCreditTermIsDisable',true);
                component.set('v.YesCreditTermIsDisable',true);
                console.log('---radioCreditTermIsDisable--'+component.get('v.radioCreditTermIsDisable'));
                
                component.find("AmountCreditTerm").set("v.value",0);
            }
            else
            {
                document.getElementById('fieldset3').classList.remove('slds-has-error');
                document.getElementById('fieldset4').classList.remove('slds-has-error');
                document.getElementById('fieldset5').classList.remove('slds-has-error');
                
                component.set('v.radio3IsDisable',false);
                component.set('v.radio4IsDisable',true);
                component.set('v.radio5IsDisable',true);
                
                component.find("Yes-4").getElement().checked = false;
                component.find("Yes-5").getElement().checked = false;
                component.find("No-4").getElement().checked = false;
                component.find("No-5").getElement().checked = false;
                component.set('v.Yes4IsDisable',true);
                component.set('v.Yes5IsDisable',true);
                
                component.find("Amount4").set("v.value",0);
                component.find("Amount5").set("v.value",0);
            }
            
            document.getElementById('fieldset2').classList.remove('slds-has-error');
            component.find("Amount2").set("v.value",0);
            
            let calTotalAmont = component.get('c.calTotalAmont');
            $A.enqueueAction(calTotalAmont);  
        }
        catch(ex)
        {
            console.error(ex)
        }
        
    },
    handleRadioYes3 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("Yes-3").getElement().value;
        console.log(doc);
        component.set('v.Yes3IsDisable',false);
        component.set('v.Ispass_Excelsummary',true);
        document.getElementById('fieldset2').classList.remove('slds-has-error');
        document.getElementById('fieldset3').classList.remove('slds-has-error');
        document.getElementById('fieldset4').classList.remove('slds-has-error');
        document.getElementById('fieldset5').classList.remove('slds-has-error');
        
        component.set('v.radio4IsDisable',false);
        component.set('v.radio5IsDisable',true);
        
        component.find("Yes-5").getElement().checked = false;
        component.find("No-5").getElement().checked = false;
        component.set('v.Yes5IsDisable',true);
        
        component.find("Amount5").set("v.value",0);
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont);  
    },
    handleRadioNo3 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("No-3").getElement().value;
        console.log(doc);
        component.set('v.Yes3IsDisable',true);
        component.set('v.Ispass_Excelsummary',true);
        document.getElementById('fieldset2').classList.remove('slds-has-error');
        document.getElementById('fieldset3').classList.remove('slds-has-error');
        document.getElementById('fieldset4').classList.remove('slds-has-error');
        document.getElementById('fieldset5').classList.remove('slds-has-error');
        
        component.set('v.radio4IsDisable',true);
        component.set('v.radio5IsDisable',false);
        
        
        component.find("Yes-4").getElement().checked = false;
        component.find("No-4").getElement().checked = false;
        
        component.set('v.Yes4IsDisable',true);
        
        component.find("Amount3").set("v.value",0);
        component.find("Amount4").set("v.value",0);
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont);  
    },
    handleRadioYes4 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("Yes-4").getElement().value;
        console.log(doc);
        component.set('v.Yes4IsDisable',false);
        component.set('v.Ispass_Excelsummary',true);
        document.getElementById('fieldset2').classList.remove('slds-has-error');
        document.getElementById('fieldset3').classList.remove('slds-has-error');
        document.getElementById('fieldset4').classList.remove('slds-has-error');
        document.getElementById('fieldset5').classList.remove('slds-has-error');
        
        
    },
    handleRadioNo4 : function(component, event, helper) {
        component.set('v.radio5IsDisable',false);
        console.log('button radio---');
        var doc = component.find("No-4").getElement().value;
        console.log(doc);
        component.set('v.Yes4IsDisable',true);
        component.set('v.Ispass_Excelsummary',true);
        document.getElementById('fieldset2').classList.remove('slds-has-error');
        document.getElementById('fieldset3').classList.remove('slds-has-error');
        document.getElementById('fieldset4').classList.remove('slds-has-error');
        document.getElementById('fieldset5').classList.remove('slds-has-error');
        
        component.find("Amount4").set("v.value",0);
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont);  
    },
    handleRadioYes5 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("Yes-5").getElement().value;
        
        console.log(doc);
        component.set('v.Yes5IsDisable',false);
        component.set('v.Ispass_Excelsummary',true);
        
        document.getElementById('fieldset2').classList.remove('slds-has-error');
        document.getElementById('fieldset3').classList.remove('slds-has-error');
        document.getElementById('fieldset4').classList.remove('slds-has-error');
        document.getElementById('fieldset5').classList.remove('slds-has-error');
        
        
        
    },
    handleRadioNo5 : function(component, event, helper) {
        
        console.log('button radio---');
        var doc = component.find("No-5").getElement().value;
        console.log(doc);
        component.set('v.Yes5IsDisable',true);
        component.set('v.Ispass_Excelsummary',true);
        document.getElementById('fieldset2').classList.remove('slds-has-error');
        document.getElementById('fieldset3').classList.remove('slds-has-error');
        document.getElementById('fieldset4').classList.remove('slds-has-error');
        document.getElementById('fieldset5').classList.remove('slds-has-error');
        
        component.find("Amount5").set("v.value",0);
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont);  
    },
    */
    searchField : function(component, event, helper) {
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');
        component.set("v.LoadingText", true);
        if(currentText.length > 0) {
            $A.util.addClass(resultBox, 'slds-is-open');
        }
        else {
            $A.util.removeClass(resultBox, 'slds-is-open');
        }
        var action = component.get("c.getResults");
        action.setParams({
            "ObjectName" : component.get("v.objectName"),
            "fieldName" : component.get("v.fieldName"),
            "value" : currentText
        });
        
        action.setCallback(this, function(response){
            var STATE = response.getState();
            if(STATE === "SUCCESS") {
                component.set("v.searchRecords", response.getReturnValue());
                if(component.get("v.searchRecords").length == 0) {
                    console.log('000000');
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message); 
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.LoadingText", false);
        });
        
        $A.enqueueAction(action);
    },
    
    setSelectedRecord : function(component, event, helper) {
        var currentText = event.currentTarget.id;
        var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
        //component.set("v.selectRecordName", currentText);
        component.set("v.selectRecordName", event.currentTarget.dataset.name);
        component.set("v.selectRecordId", currentText);
        component.find('userinput').set("v.readonly", true);
    }, 
    
    resetData : function(component, event, helper) {
        component.set("v.selectRecordName", "");
        component.set("v.selectRecordId", "");
        component.find('userinput').set("v.readonly", false);
    },
    TemplateLink : function(component,event, helper,recordId) {
        var recordId = component.get("v.recordId");;
        // var urlval = component.get("v.TemplateLink");
        // console.log('---urlval---'+urlval);
        // window.open(urlval, '_blank');
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
    
    handleCreditCondition: function(component, event, helper) {
        console.log('--- handleCreditCondition ---');
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        var  ApproverStep = component.get("v.ApproverStepVal");
        console.log('---ApproverStep--'+ApproverStep);
        try{
            
            //Reset Value
            //component.find("CreditLimit").set("v.value",'');
            //component.find("CreditLimitCurrency").set("v.value",'');
            //component.find("InternalCreditRating").set("v.value",'');
            
            if(buInfo.BusinessUnit__c == 'TOP' || buInfo.BusinessUnit__c == 'LABIX')
            {
                var CreditConditionValue1 = '';
                var CreditConditionValue = '';
                
                if(ApproverStep == 'TRCR')
                {
                    CreditConditionValue = component.find("Credit_Condition").get("v.value");
                    
                    //Reset Value
                    component.find("CreditLimit").set("v.value",'');
                    component.find("CreditLimitCurrency").set("v.value",'');
                    component.find("InternalCreditRatingTOP").set("v.value",'');
                    component.find("PaymentCondition").set("v.value",'');
                    //component.find("TraderRemark__c").set("v.value",'');
                    component.find("Trade_Credit_Insurance__c").set("v.value",'');
                    component.find("TradeCreditInsuranceCurrency__c").set("v.value",'');
                    component.find("PaymentTermTOP").set("v.value",'');
                    
                }
                else if(ApproverStep == 'Trader')
                {
                    CreditConditionValue = component.find("ApprovalTrader_CreditCondition__c").get("v.value"); 
                    
                    //Reset Value
                    component.find("ApprovalTrader_CreditLimit__c").set("v.value",'');
                    component.find("ApprovalTrader_CreditLimitCurrency__c").set("v.value",'');
                    component.find("ApprovalTrader_TradeCreditInsurance__c").set("v.value",'');
                    component.find("ApprovalTrader_TradeCreditCurrency__c").set("v.value",'');
                    //component.find("ApprovalTrader_CreditRating").set("v.value",'');
                    
                    component.find("ApprovalTrader_PaymentTerm__c").set("v.value",'');
                    component.find("ApprovalTrader_PaymentCondition__c").set("v.value",'');
                    component.find("ApprovalTrader_Remark__c").set("v.value",'');
                }
                
                //console.log('--- CreditConditionValue ---'+CreditConditionValue);
                if(CreditConditionValue == 'Open Account' )
                {
                    if(ApproverStep == 'TRCR')
                    {
                        component.set("v.IsCreditLimitDisable", true);
                        component.set("v.IsTradeCreditDisable", false);
                    }else if (ApproverStep == 'Trader')
                    {
                        component.set("v.IsTDCreditLimitDisable", true);
                        component.set("v.IsTDTradeCreditDisable", false);
                    }
                    
                }
                else if(CreditConditionValue == 'Open Account With Collateral' || CreditConditionValue == 'L/C' || CreditConditionValue == 'Domestic L/C' )
                {
                    if(ApproverStep == 'TRCR')
                    {
                        component.set("v.IsTradeCreditDisable", true);
                        component.set("v.IsCreditLimitDisable", true);
                    }else if (ApproverStep == 'Trader')
                    {
                        component.set("v.IsTDCreditLimitDisable", true);
                        component.set("v.IsTDTradeCreditDisable", true);
                    }
                } 
                    else if(CreditConditionValue == 'Cash in Advance' || CreditConditionValue == 'Others')
                    {
                        if(ApproverStep == 'TRCR')
                        {
                            component.set("v.IsTradeCreditDisable", false);
                            component.set("v.IsCreditLimitDisable", false);
                        }else if (ApproverStep == 'Trader')
                        {
                            component.set("v.IsTDCreditLimitDisable", false);
                            component.set("v.IsTDTradeCreditDisable", false);
                        }
                    } 
            }
            else if(buInfo.BusinessUnit__c == 'TX')
            {
                component.find("PaymentTermTX").set("v.value",'');
                component.find("RiskCategoryTX").set("v.value",'');
                
                if(ApproverStep == 'TRCR')
                {
                    component.find("ApprovalTraderPaymentTerm").set("v.value",'');
                    component.find("ApprovalTraderRiskCategory").set("v.value",'');
                }
                
            }
            console.log('---END--');
        }catch(ex)
        {
            console.error('ex---'+ex.message());   
            console.log('ex---'+ex.message());
        }
    },
    /*handleNoWaiveRequest : function(component,event, helper) {
        
        console.log('---handleNoWaiveRequest--');        	
        console.log('---NoWaiveRequestVal---'+component.find("NoWaiveRequest").getElement().checked);
        if(component.find("NoWaiveRequest").getElement().checked)
        { 
            component.set('v.IsPageDisable',true);
            component.set('v.IsWaiveDisable',false);
        }else
        {
            component.set('v.IsPageDisable',false);
            component.set('v.IsWaiveDisable',false);
        } 
        
    },*/
    handleTDNoWaiveRequest : function(component,event, helper) {
        console.log('---handleTDNoWaiveRequest--');
        var TDNoWaiveRequestVal = component.find("TraderWaive").get("v.value");
        console.log('---TDNoWaiveRequestVal---'+TDNoWaiveRequestVal);
        if(TDNoWaiveRequestVal == 'No')
        {
            component.set('v.IsTDWaiveRequest',false);
            
        }
        else
        {
            component.set('v.IsTDWaiveRequest',true);
        }
        if(TDNoWaiveRequestVal == 'No' || TDNoWaiveRequestVal == '' || TDNoWaiveRequestVal == undefined )
        { 
            component.set('v.IsTDFieldsDisable',true);
            component.set('v.IsTDWaiveDisable',false);
        }else
        {
            component.set('v.IsTDFieldsDisable',false);
            component.set('v.IsTDWaiveDisable',false);
        } 
    },
    handleRadioCreditTerm : function(component,event, helper) {
        
        console.log('---handleTDNoWaiveRequest--');
        
        //var TDNoWaiveRequestVal = component.find("TDNoWaiveRequest").get("v.value");
        console.log('---YesCreditTermIsDisable---'+component.find("Yes-CreditTerm").getElement().checked);
        if(component.find("Yes-CreditTerm").getElement().checked)
        { 
            console.log('---YesCreditTermIsDisable-true--')
            component.set('v.YesCreditTermIsDisable',false);
            console.log('---YesCreditTermIsDisable-true--'+component.get('v.YesCreditTermIsDisable'))
        }
        else
        {
            console.log('---YesCreditTermIsDisable-false--')
            component.set('v.YesCreditTermIsDisable',true);
            console.log('---YesCreditTermIsDisable-false--'+component.get('v.YesCreditTermIsDisable'))
            component.find("AmountCreditTerm").set("v.value",0);
        } 
        let calTotalAmont = component.get('c.calTotalAmont');
        $A.enqueueAction(calTotalAmont); 
    },
    handleCreditOwnerIdChange : function(component,event, helper) {
        
        console.log('---handleCreditOwnerIdChange--'+component.get('v.CreditOwnerId'));
        
        
    },
    handleCreditLimitCurrency: function(component,event, helper) {
        console.log('--- handleCreditLimitCurrency ---');
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        if(buInfo.BusinessUnit__c == 'TX')
        {
            var CreditLimitCurrency = component.find("CreditLimitCurrency").get("v.value");
            component.find("Total_Secured_Currency__c").set("v.value",CreditLimitCurrency);
        }
    }
    
    /*,
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    }*/
})