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
                        console.log('---Get BU Name---');
                        //Get BU Name
                        var actionBU = component.get("c.getBUInfo");
                        actionBU.setParams({
                            "recordId": recordId
                        });
                        actionBU.setCallback(this, function(response){
                            var state1 = response.getState();
                            console.log('---state1---'+state1);
                            if (state1 === "SUCCESS") 
                            {
                                //ADMIN TEST
                                //component.set("v.BUInfo.BusinessUnit__c",'TOP');
                                //BUName = 'TOP';
                                //console.log('---BUName-2--'+BUName);
                                
                                var recordtypeName = requestList[0].RecordTypeName__c;
                                var ExcelTemplate = requestList[0].ExcelTemplate__c;
                                var ImportExcelSummary = requestList[0].ImportExcelSummary__c;
                                var InternalCreditRating = requestList[0].ChangeCreditInternalCreditRating__c;
                                var RequestToChangeCredit =  requestList[0].RequestToChangeCredit__c;
        						var SubTypeCondition = requestList[0].SubTypeCondition__c;
        						var SubTypeCondition2 = requestList[0].SubTypeCondition2__c;
                                var ChangeCreditAmount = requestList[0].ChangeCreditAmount__c;
                                var EffectiveDateForm = requestList[0].EffectiveDateForm__c;
                                var EffectiveDateTo = requestList[0].EffectiveDateTo__c;
                                var CreditCondition = requestList[0].ChangeCreditCreditCondition__c;
                                var CreditLimit = requestList[0].ChangeCreditCreditLimit__c;
                                var CreditLimitCurrency = requestList[0].ChangeCreditCreditLimitCurrency__c;
                                var TradeCreditInsurance = requestList[0].ChangeCreditTradeCreditInsurance__c;
                                var TradeCreditInsuranceCurrency = requestList[0].ChangeCreditTradeCreditInsuranceCurrency__c;
                                var email = requestList[0].CTRRequestFormHeader__r.Email__c;
                                var fname = requestList[0].CTRRequestFormHeader__r.FirstName__c;
                                var lname = requestList[0].CTRRequestFormHeader__r.LastName__c;
                                var mobile = requestList[0].CTRRequestFormHeader__r.MobilePhone__c;
                                var approvalStep = requestList[0].Approval_Step__c;
                                var TRCR = requestList[0].CreditOwner__c;
                                var isTRCR = requestList[0].isTRCR__c;
                                var accountId = requestList[0].Customer__c;
                                var finKey = requestList[0].FinancialKey__c;
                                
                                
                                /*if(TRCR != null && TRCR != '')
                                {
                                    console.log('---1--');
                                    component.set("v.CreditOwnerId",TRCR); 
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
                                console.log('---CurrentStepUserId--'+TRCR);
                                component.set('v.CurrentStepUserId',TRCR); */
                                
                                /*
                                var CashOnDelivery = requestList[0].CashOnDelivery__c;
                                var HavingCollateral = requestList[0].HavingCollateral__c;
                                var BuyTradeEndorsement = requestList[0].BuyTradeEndorsement__c;
                                var BuyTradeDCLCondition = requestList[0].BuyTradeDCLCondition__c;
                                var HavingOpenedCredit = requestList[0].HavingOpenedCredit__c;
                                var Total =	requestList[0].TotalSecuredAmount__c;
                                var isTRCR = requestList[0].isTRCR__c;
                                var WaiveRequest = requestList[0].WaiveRequest__c;
                                var TypeOfBusiness = requestList[0].TypeOfBusiness__c;
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
                                var PerformanceBond = requestList[0].PerformanceBond__c;
                                var HavingCreditTerm = requestList[0].HavingCreditTermorLetter__c;
                                var TRCR = requestList[0].CreditOwner__c;
                                var TraderCreditCondition = requestList[0].ApprovalTrader_CreditCondition__c;*/
                                
                                //set recordtype & BU
                                if(recordtypeName.includes("Customer")){
                                    recordtypeName = "Customer";
                                }else if(recordtypeName.includes("Supplier")){
                                    recordtypeName = "Supplier";
                                }
                                var BUInfo = component.get("v.BUInfo");
                                console.log('---BUInfo---'+BUInfo);
                                var BUName = BUInfo.BusinessUnit__c;
                                console.log('---BUName---'+BUName);
                                
                                
                                console.log('---email--'+email);
                                console.log('---fname--'+fname);
                                console.log('---mobile--'+mobile);
                                
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
                                component.set('v.ApprovalStep',approvalStep);
                                
                                
                                //assign approver step
                                /*if(ApproverStep == '' || ApproverStep == null ||  ApproverStep == undefined)
                                    ApproverStep = 'TRCR';
                                component.set("v.ApproverStepVal",ApproverStep);
                                console.log('---approvalstep--'+component.get("v.ApproverStepVal")); */
                                
                                
                                
                                //Default value
                                /*if(BUName == "TX")
                                { 
                                    console.log('---TXTXTXTXTXTXTX---'+BUName);
                                    //set number format
                                    var parts = Total.toFixed(2).split(".");
                                    var num = parts[0].replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + (parts[1] ? "." + parts[1] : "");
                                
                                    component.set("v.TotalAmount",num);
                                    component.set("v.CurrencyDisable",true);
                                }*/
                                component.set("v.SharePointLink",ImportExcelSummary);
                                component.set("v.RecordTypeName",recordtypeName);
                                //component.set("v.ApproverStepVal",ApproverStep);
                                //console.log('---TypeOfBusiness---'+TypeOfBusiness);
                                //component.set("v.TypeOfBusiness",TypeOfBusiness);
                                console.log('-----InternalCreditRating-----'+InternalCreditRating);
                                if(InternalCreditRating == '' || InternalCreditRating == undefined)
                                	InternalCreditRating = 'N/A';
                                
                                if(CreditCondition == '' || CreditCondition == undefined)
                                    CreditCondition = 'Open Account';
                                
                                if(CreditLimitCurrency == '' || CreditLimitCurrency == undefined)
                                    CreditLimitCurrency = 'THB';
                                
                                if(TradeCreditInsuranceCurrency == '' || TradeCreditInsuranceCurrency == undefined)
                                    TradeCreditInsuranceCurrency = 'THB';
                                
                                //Render picklist
                                component.find("SubTypeCondition").set("v.value",SubTypeCondition);
                                component.find("SubTypeCondition2").set("v.value",SubTypeCondition2);
                                component.find("ChangeCreditAmount").set("v.value",ChangeCreditAmount);
                                component.find("EffectiveDateForm").set("v.value",EffectiveDateForm);
                                component.find("EffectiveDateTo").set("v.value",EffectiveDateTo);
                                component.find("ChangeCreditCreditCondition").set("v.value",CreditCondition);
                                component.find("ChangeCreditInternalCreditRating").set("v.value",InternalCreditRating);
                                component.find("ChangeCreditCreditLimitCurrency").set("v.value",CreditLimitCurrency);
                                component.find("ChangeCreditTradeCreditInsuranceCurrency").set("v.value",TradeCreditInsuranceCurrency);
                                var action = component.get('c.handleRenderCreditConditionFields');
                                $A.enqueueAction(action);
                                
                                
                                //Set value in Exising section
                                var actionExsiting = component.get("c.getExtingFinancialInfo");
                                actionExsiting.setParams({
                                    "key": finKey,
                                    "accountId": accountId,
                                });
                                actionExsiting.setCallback(this, function(responseExisting) {
                                    var stateExisting = responseExisting.getState();
                                    if (stateExisting === "SUCCESS") 
                                    {
                                        try
                                        {
                                            var finList = responseExisting.getReturnValue();
                                            var CreditCondition = finList[0].Credit_Condition__c;
                                            var CreditLimit = finList[0].CreditLimit__c;
                                            var IntenalCreditRating = finList[0].InternalCreditRating__c;
                                            var PaymentCondition = finList[0].PaymentCondition__c;
                                            
                                            if(CreditCondition != undefined && CreditCondition != '')
                                            {
                                                component.set('v.CreditCondition',CreditCondition);
                                            }
                                            if(CreditLimit != undefined && CreditLimit != '')
                                            {
                                                component.set('v.CreditLimit',CreditLimit);
                                            }
                                            if(IntenalCreditRating != undefined && IntenalCreditRating != '')
                                            {
                                                component.set('v.IntenalCreditRating',IntenalCreditRating);
                                            }
                                            if(PaymentCondition != undefined && PaymentCondition != '')
                                            {
                                                component.set('v.PaymentCondition',PaymentCondition);
                                            }
                                        }
                                        catch(ex2)
                                        {
                                            console.error('----ERROR---'+ex2.message);
                                        }
                                        
                                    }
                                });
                            	$A.enqueueAction(actionExsiting);
                                
                                console.log('---Done---');
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