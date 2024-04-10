({
    getRequestItems : function(component, event, recordId) 
    {
        var action = component.get("c.getRequestFormItem");
        action.setParams({
            "recID": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                try
                {
                    var requestList = response.getReturnValue();
                    console.log('---requestList---'+requestList);
                    if(requestList != null)
                    {	
                        
                        //Get BU Name
                        var actionBU = component.get("c.getBUInfo");
                        actionBU.setParams({
                            "recordId": recordId
                        });
                        actionBU.setCallback(this, function(response){
                            var state1 = response.getState();
                            if (state1 === "SUCCESS") 
                            {
                                var BUInfo = component.get("v.BUInfo");
                                console.log('---BUInfo---'+BUInfo);
                                var BUName = BUInfo.BusinessUnit__c;
                                console.log('---BUName---'+BUName);
                                
                                
                                //ADMIN TEST
                                //component.set("v.BUInfo.BusinessUnit__c",'TOP');
                                //BUName = 'TOP';
                                //console.log('---BUName-2--'+BUName);
                                
                                var isTRCR = requestList[0].isTRCR__c;
                                var ExcelTemplate = requestList[0].ExcelTemplate__c;
                                var ImportExcelSummary = requestList[0].ImportExcelSummary__c;
                                var TypeOfBusiness = requestList[0].TypeOfBusiness__c;
                                var CashOnDelivery = requestList[0].CashOnDelivery__c;
                                var HavingCollateral = requestList[0].HavingCollateral__c;
                                var BuyTradeEndorsement = requestList[0].BuyTradeEndorsement__c;
                                var BuyTradeDCLCondition = requestList[0].BuyTradeDCLCondition__c;
                                var HavingOpenedCredit = requestList[0].HavingOpenedCredit__c;
                                var InternalCreditRating = requestList[0].InternalCreditRating__c;
                                var Total =	requestList[0].TotalSecuredAmount__c;
                                var CreditCondition = requestList[0].Credit_Condition__c;
                                var CreditLimit = requestList[0].CreditLimit__c;
                                var CreditLimitCurrency = requestList[0].CreditLimitCurrency__c;
                                var TradeCreditInsurance = requestList[0].Trade_Credit_Insurance__c;
                                var TradeCreditInsuranceCurrency = requestList[0].TradeCreditInsuranceCurrency__c;
                                var WaiveRequest = requestList[0].WaiveRequest__c;
                                var TraderRemark = requestList[0].TraderRemark__c;
                                var ApproverStep = requestList[0].ApproverStep__c;
                                var TraderWaiveRequest = requestList[0].TraderWaive__c;
                                var TraderCreditRating = requestList[0].ApprovalTrader_CreditRating__c;
                                var SHAgree = requestList[0].Approval_SHAgree__c;
                                var VPAgree = requestList[0].Approval_VPAgree__c;
                                var PaymentTerm = requestList[0].PaymentTerm__c;
                                var PaymentCondition = requestList[0].PaymentCondition__c;
                                var IsTraderSaved = requestList[0].IsTraderSaved__c;
                                var ApproverHeadId = requestList[0].OwnersSectionHead__c;
                                var ApproverVPId = requestList[0].OwnersCMVP__c;
                                var ApproverTraderId = requestList[0].OwnerId;
                                var recordtypeName = requestList[0].RecordTypeName__c;
                                var PerformanceBond = requestList[0].PerformanceBond__c;
                                var HavingCreditTerm = requestList[0].HavingCreditTermorLetter__c;
                                var TRCR = requestList[0].CreditOwner__c;
                                var TraderCreditCondition = requestList[0].ApprovalTrader_CreditCondition__c;
                                var email = requestList[0].CTRRequestFormHeader__r.Email__c;
                                var fname = requestList[0].CTRRequestFormHeader__r.FirstName__c;
                                var lname = requestList[0].CTRRequestFormHeader__r.LastName__c;
                                var mobile = requestList[0].CTRRequestFormHeader__r.MobilePhone__c;
                                var approvalStep = requestList[0].Approval_Step__c;
                                var InterestedProductSupplier = requestList[0].InterestedProductTypeAsSupplierTOP__c;
                                
                                console.log('---recordtypeName---'+recordtypeName);
                                console.log('---BUName---'+BUName);
                                console.log('---InterestedProductSupplier---'+InterestedProductSupplier);
                                
                            console.log('---00---');
                            //Check recortype = New Supplier / Extend Supplier
                            if((recordtypeName.includes("SupplierInitial") || recordtypeName.includes("SupplierExtend")))
                            {
                                if(BUName == 'TX')
                                {
                                    console.log('---0---');
                                	component.set("v.IsShowPage",false);
                                	component.set("v.NotShowText",'This function isn\'t required in this request.');
                                }
                                else if(BUName == 'TOP' || BUName == 'LABIX')
                                {
                                    console.log('---1---');
                                    if(!InterestedProductSupplier.includes('Crude'))
                                    {
                                        console.log('---2---');
                                        component.set("v.IsShowPage",false);
                                		component.set("v.NotShowText",'This function isn\'t required in this request.');
                                    }
                                    else
                                    {
                                        console.log('---3---');
                                        component.set("v.IsShowPage",true);
                                    }
                                    console.log('---4---');
                                }
                            }
                            else
                            {
                                console.log('---5---');
                                component.set("v.IsShowPage",true);
                                
                            
                        	}
                                component.set('v.ApprovalStep',approvalStep);
                                console.log('---Total---'+Total);
                                
                                if(TraderWaiveRequest == 'No' || TraderWaiveRequest == '')
                                {
                                    component.set('v.IsTDWaiveRequest',false);
                                    
                                }
                                else
                                {
                                    component.set('v.IsTDWaiveRequest',true);
                                }
                                
                                if(SHAgree == 'No')
                                {
                                    component.set('v.IsSHAgree',false);
                                    
                                }
                                else
                                {
                                    component.set('v.IsSHAgree',true);
                                }
                                if(email == null || email == '')
                                    email = '';
                                if(fname == undefined || fname == null || fname == '')
                                    fname = '';
                                if(lname == undefined || lname == null || lname == '')
                                    lname = '';
                                if(mobile == null || mobile == '')
                                    mobile = '';
                                
                                component.set("v.EmailStr",email); 
                                component.set("v.ContactStr",fname+' '+lname); 
                                component.set("v.TelephoneStr",mobile); 
                                
                                //set number format
                                var parts = Total.toFixed(2).split(".");
                                var num = parts[0].replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + 
                                    (parts[1] ? "." + parts[1] : "");
                                
                                //assign approver step
                                if(ApproverStep == '' || ApproverStep == null ||  ApproverStep == undefined)
                                    ApproverStep = 'TRCR';
                                component.set("v.ApproverStepVal",ApproverStep);
                                console.log('---approvalstep--'+component.get("v.ApproverStepVal"));
                                //Set OwnerID
                                if(TRCR != null && TRCR != '')
                                {
                                    console.log('---1--');
                                    component.set("v.CreditOwnerId",TRCR); 
                                    component.set("v.TRCRId",TRCR);
                                }
                                else
                                {
                                    console.log('---2--'+isTRCR);
                                    if(isTRCR != null && isTRCR != undefined && isTRCR != '')
                                    {
                                        if(isTRCR.includes($A.get("$SObjectType.CurrentUser.Id")))
                                        {
                                            TRCR = $A.get("$SObjectType.CurrentUser.Id");
                                            component.set("v.TRCRId",$A.get("$SObjectType.CurrentUser.Id")); 
                                        }
                                    }
                                    
                                }
                                
                                //set current user incase no value in database
                                if(isTRCR != null && isTRCR != '' && isTRCR != undefined)
                                {
                                    console.log('---isTRCR----'+isTRCR);
                                    console.log('---$A.get("$SObjectType.CurrentUser.Id")----'+$A.get("$SObjectType.CurrentUser.Id"));
                                    var where = 'AND Id IN '+isTRCR;
                                    component.set("v.TRCROwnerWhereCondition",where); 
                                    console.log('---isTRCR--WHERE--'+where);
                                    
                                }
                                
                                //set recordtype
                                if(recordtypeName.includes("Customer")){
                                    recordtypeName = "Customer";
                                }else if(recordtypeName.includes("Supplier")){
                                    recordtypeName = "Supplier";
                                }
                                
                                //Assign valiable for component
                                console.log('---recordtypeName-2---'+recordtypeName);
                                console.log('---ApproverHeadId---'+ApproverHeadId);
                                console.log('---ApproverVPId---'+ApproverVPId);
                                component.set("v.TemplateLink",ExcelTemplate);
                                component.set("v.SharePointLink",ImportExcelSummary);
                                component.set("v.RecordTypeName",recordtypeName);
                                component.set("v.ApproverStepVal",ApproverStep);
                                console.log('---TypeOfBusiness---'+TypeOfBusiness);
                                component.set("v.TypeOfBusiness",TypeOfBusiness);
                                component.set("v.TraderId",ApproverTraderId);
                                component.set("v.SectionHeadId",ApproverHeadId);
                                component.set("v.VPId",ApproverVPId);
                                component.set('v.IsRequired',false);
                                
                                //Setup button name default
                                component.set("v.ButtonName", "Evaluate Credit");
                                component.set("v.FirstSectionName", "Excel Summary");
                                
                                if(BUName == "TOP" || BUName == "LABIX")
                                {  
                                    if(BUName == "LABIX")
                                    {
                                        component.set("v.ReassignSectionName", "FALB Reassign Task");
                                    }
                                    else if(BUName == "TOP")
                                    {
                                        component.set("v.ReassignSectionName", "TRCR Reassign Task");
                                    }
                                    
                                    
                                    if(ApproverStep == "TRCR" )
                                    {
                                        //Disable Section
                                        component.set("v.IsSectionTraderDisable", true);
                                        component.set("v.IsSectionSHDisable", true);
                                        component.set("v.IsSectionVPDisable", true);
                                        component.set('v.CurrentStepUserId',TRCR);
                                        
                                        //Default value
                                        console.log('-----InternalCreditRating-----'+InternalCreditRating);
                                        if(InternalCreditRating == '' || InternalCreditRating == undefined)
                                            InternalCreditRating = 'N/A';
                                        component.find("InternalCreditRatingTOP").set("v.value",InternalCreditRating);
                                        
                                        if(CreditCondition == '' || CreditCondition == undefined)
                                            CreditCondition = 'Open Account';
                                        component.find("Credit_Condition").set("v.value",CreditCondition);
                                        
                                        if(CreditLimitCurrency == '' || CreditLimitCurrency == undefined)
                                            CreditLimitCurrency = 'THB';
                                        component.find("CreditLimitCurrency").set("v.value",CreditLimitCurrency);
                                    }
                                    
                                    if(ApproverStep == "Trader" || ApproverStep == 'SH' || ApproverStep == 'VP' || ApproverStep == "Done" )
                                    {
                                        //setup button & section name
                                        if(BUName == "TOP")
                                        {
                                            
                                            if(recordtypeName == 'Customer')
                                            {
                                                //Setup button name
                                                component.set("v.ButtonName", "Verify Condition");
                                                
                                                //set section name
                                                component.set("v.FirstSectionName", "Credit Condition by TRCR");
                                                component.set("v.TDSectionName", "Credit Condition by Trader");
                                                component.set("v.SHSectionName", "Credit Condition by Section Head");
                                                component.set("v.VPSectionName", "Credit Condition by VP");
                                                
                                            }
                                            else if (recordtypeName == 'Supplier')
                                            {
                                                //Setup button name
                                                component.set("v.ButtonName", "Verify Bond");
                                                
                                                //set section name
                                                component.set("v.FirstSectionName", "Performance Bond by TRCR");
                                                component.set("v.TDSectionName", "Performance Bond by Trader");
                                                component.set("v.SHSectionName", "Performance Bond by Section Head");
                                                component.set("v.VPSectionName", "Performance Bond by VP");
                                            }
                                            
                                        }  
                                        else if (BUName == "LABIX")
                                        {
                                            //Setup button name
                                            component.set("v.ButtonName", "Verify Condition");
                                            
                                            //set section name
                                            component.set("v.FirstSectionName", "Credit Condition by FALB");
                                            component.set("v.TDSectionName", "Credit Condition by Trader");
                                            component.set("v.SHSectionName", "Credit Condition by Section Head");
                                            component.set("v.VPSectionName", "Credit Condition by DMD");
                                        }
                                        
                                        console.log('--1-ApproverStep == "Trader" -----'+ApproverStep);
                                        if(ApproverStep != "Done"){
                                            //Disable Section
                                            component.set("v.IsSectionTraderDisable", false);
                                            component.set("v.IsSectionSHDisable", true);
                                            component.set("v.IsSectionVPDisable", true);
                                            component.set('v.CurrentStepUserId',ApproverTraderId);
                                            
                                            //default trct's value to trader field in first time
                                            console.log('-----IsTraderSaved-----'+IsTraderSaved);
                                            if(!IsTraderSaved)
                                            {
                                                if(recordtypeName == 'Customer' || (recordtypeName == 'Supplier' && BUName == "LABIX"))
                                                {
                                                    console.log('-----0-TraderCreditCondition----'+TraderCreditCondition);
                                                    console.log('-----1-----'+PaymentTerm);
                                                    TraderCreditCondition = CreditCondition;
                                                    component.find("ApprovalTrader_CreditRating").set("v.value",InternalCreditRating);
                                                    component.find("ApprovalTrader_CreditCondition__c").set("v.value",CreditCondition);
                                                    component.find("ApprovalTrader_CreditLimit__c").set("v.value",CreditLimit);
                                                    component.find("ApprovalTrader_CreditLimitCurrency__c").set("v.value",CreditLimitCurrency);
                                                    component.find("ApprovalTrader_TradeCreditInsurance__c").set("v.value",TradeCreditInsurance);
                                                    component.find("ApprovalTrader_TradeCreditCurrency__c").set("v.value",TradeCreditInsuranceCurrency);
                                                    component.find("ApprovalTrader_PaymentTerm__c").set("v.value",PaymentTerm);
                                                    component.find("ApprovalTrader_PaymentCondition__c").set("v.value",PaymentCondition);
                                                    console.log('-----2-----');
                                                }
                                                
                                                if(recordtypeName == 'Supplier' && BUName == "TOP")
                                                {
                                                    component.find("TDPerformanceBond__c").set("v.value",PerformanceBond);
                                                }
                                            }
                                        } 
                                        
                                        
                                        //Render Trade Credit
                                        console.log('---TraderCreditCondition-1---'+TraderCreditCondition);
                                        if(TraderCreditCondition == 'Open Account')
                                        {
                                            component.set("v.IsTDCreditLimitDisable", true);
                                            component.set("v.IsTDTradeCreditDisable", false);
                                            console.log('---Render Trade Credit-2---');
                                            
                                        }
                                        else if(TraderCreditCondition == 'Open Account With Collateral' || TraderCreditCondition == 'L/C' || TraderCreditCondition == 'Domestic L/C' )
                                        {
                                            component.set("v.IsTDCreditLimitDisable", true);
                                            component.set("v.IsTDTradeCreditDisable", true);
                                        } 
                                            else if(TraderCreditCondition == 'Cash in Advance' || TraderCreditCondition == 'Others')
                                            {
                                                component.set("v.IsTDCreditLimitDisable", false);
                                                component.set("v.IsTDTradeCreditDisable", false);
                                            } 
                                    }
                                    
                                    if (ApproverStep == 'SH' || ApproverStep == 'VP'|| ApproverStep == "Done")
                                    {
                                        if(ApproverStep != "Done")
                                        {
                                            //Disable Section
                                            component.set("v.IsSectionTraderDisable", false);
                                            component.set("v.IsSectionSHDisable", false);
                                            component.set("v.IsSectionVPDisable", true);
                                            component.set('v.CurrentStepUserId',ApproverHeadId);
                                        }
                                        
                                        //Render SH Agree
                                        /*console.log('---SHAgree---'+SHAgree);
                                        if(SHAgree == "Yes")
                                            component.find("SHYes").getElement().checked = true;
                                        else if(SHAgree == "No")
                                            component.find("SHNo").getElement().checked = true;
                                        */
                                }
                                
                                if (ApproverStep == 'VP' || ApproverStep == "Done")
                                {
                                    if(ApproverStep == "VP")
                                    {
                                        //Disable Section
                                        component.set("v.IsSectionTraderDisable", false);
                                        component.set("v.IsSectionSHDisable", false);
                                        component.set("v.IsSectionVPDisable", false);
                                        component.set('v.CurrentStepUserId',ApproverVPId);
                                    }else
                                    {
                                        //hide VP section when SH not approved
                                        if(SHAgree == 'No')
                                            component.set("v.IsSectionVPDisable", true);
                                    }
                                    
                                    //Render VP Agree
                                    /*console.log('---VPAgree---'+VPAgree);
                                        if(VPAgree != '')
                                        {
                                            if(VPAgree == 'Yes')
                                                component.find("VPYes").getElement().checked = true;
                                            else if(VPAgree == 'No')
                                                component.find("VPNo").getElement().checked = true;
                                        }*/
                                }
                                
                                console.log('---Render Trade Credit-3---');
                                
                                //Render Trade Credit
                                if(CreditCondition == 'Open Account'){
                                    console.log('---Render Trade Credit-1---'+CreditCondition);
                                    component.set("v.IsCreditLimitDisable", true);
                                    component.set("v.IsTradeCreditDisable", false);
                                    console.log('---Render Trade Credit-2---');
                                    
                                }else if(CreditCondition == 'Open Account With Collateral' || CreditCondition == 'L/C' || CreditCondition == 'Domestic L/C' ){
                                    component.set("v.IsTradeCreditDisable", true);
                                    component.set("v.IsCreditLimitDisable", true);
                                    
                                }else if(CreditCondition == 'Cash in Advance' || CreditCondition == 'Others'){
                                    component.set("v.IsTradeCreditDisable", false);
                                    component.set("v.IsCreditLimitDisable", false);
                                    
                                } 
                                
                            }
                            
                            if(BUName == "TX")
                            { 
                                console.log('---TXTXTXTXTXTXTX---'+BUName);
                                component.set("v.ReassignSectionName", "FA Reassign Task");
                                //component.set('v.CurrentStepUserId',ApproverTraderId);
                                component.set('v.CurrentStepUserId',component.get("v.CreditOwnerId"));
                                component.set("v.TotalAmount",num);
                                component.set("v.CurrencyDisable",true);
                                //component.set('v.IsRequired',true);
                            }
                            
                            component.set("v.LoadDone",true);
                            console.log('---Done---');
                                
                            /*
                             if((recordtypeName.includes("SupplierInitial") || recordtypeName.includes("SupplierExtend")) && (BUName == 'TOP'||BUName == 'LABIX') && !InterestedProductTypeAsSupplier.includes("Crude"))	 //     (!InterestedProductSupplier.contains('Crude'))
                            {
                                console.log('---0---');
                                component.set("v.IsShowPage",false);
                                component.set("v.NotShowText",'This function isn\'t required in this request.');
                                
                            }
                            else if((recordtypeName.includes("SupplierInitial") || recordtypeName.includes("SupplierExtend")) && BUName == 'TX')
                            {
                                console.log('---1---');
                                component.set("v.IsShowPage",false);
                                component.set("v.NotShowText",'This function isn\'t required in this request.');
                            }
                             */
                        }
                    });
                    $A.enqueueAction(actionBU);
                }
                }
                catch(ex)
                {
                    console.error('----ERROR---'+ex.message);
                }
                
            }
        });
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
    
    getBUInformation : function(component, event, recordId) 
    {
        try
        {
            console.log('---getBUInfo---');
            var action = component.get("c.getBUInfo");
            action.setParams({
                "recordId": recordId
            });
            action.setCallback(this, function(response){
                
                var state = response.getState();
                console.log('---state---'+state);
                
                if (state == "SUCCESS") {
                    var uInfo = response.getReturnValue();
                    component.set("v.BUInfo",uInfo);
                    component.set("v.LogInUserId",$A.get("$SObjectType.CurrentUser.Id"));
                    console.log('---v.LogInUserId---'+component.get('v.LogInUserId'));
                    
                    this.getRequestItems(component,event, recordId);
                }
                
                
            }
                              );
            $A.enqueueAction(action);
        }
        catch(ex)
        {
            console.log('---ex---'+JSON.stringtify(ex));
        }
        
    }
})