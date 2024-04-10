({
    doInit: function (component, event, helper) {
        component.set('v.isLoaded', false);

        var recordId = component.get("v.recordId");
        var onPageRecordID = component.get("v.recordId");
        console.log('recordId--initial--' + recordId);
        console.log(component.get("v.reqitemId"));
        console.log('onPageRecordID--' + component.get("v.onPageRecordID"));
        //case create initial account
        if (onPageRecordID == null || onPageRecordID == '') {
            //var recordTypeId = component.get("v.pageReference").state.recordTypeId;
            //console.log('recordTypeId---'+recordTypeId);
            //component.set('v.recordTypeId',recordTypeId);

            //if(recordTypeId == '0121m00000225RqAAI')
            //{
            component.set('v.isInitial', true);
            helper.createObjectData(component, event);
            helper.createObjectDataDestination(component, event);
            helper.getLocationType(component, event);
            helper.getShippingCountry(component, event);
            helper.getFacilityTransportation(component, event);
            helper.getFacilityTankAndStorage(component, event);

            console.log('isInitial-2-' + component.get("v.isInitial"));
            component.set('v.isLoaded', true);

            //}
            /*else
            {
                var createAcountEvent = $A.get("e.force:createRecord");
                createAcountEvent.setParams({
                    "entityApiName": "Account",
                    "defaultFieldValues": {
                        'recordTypeId': recordTypeId
                    }
                });
                createAcountEvent.fire();
            }*/
        }
        else {
            try {
                console.log('onPageRecordID-editcase-' + component.get("v.onPageRecordID"));
                console.log('ObjectType-editcase-' + component.get("v.ObjectType"));

                var recordId = component.get("v.onPageRecordID");

                var action = component.get("c.getHeaderInfomation");
                console.log('recordIdc-2-' + recordId);
                action.setParams({
                    "recordId": recordId
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state----' + state);
                    if (state === "SUCCESS") {
                        component.set('v.isAccount', false);
                        var accInfo = response.getReturnValue();
                        console.log('accInfo----' + JSON.stringify(accInfo));

                        //component.set('v.isInitial',true);
                        //component.set("v.onPageRecordID",recordId);
                        component.set("v.typeOfBusiness", accInfo.TypeOfBusiness__c);
                        component.set("v.accId", accInfo.Customer__c);
                        //fields.TypeOfBusiness__c = TypeOfBusiness;
                        //fields.recordtypeid = recTypeID;
                        // console.log('accInfo.PaymentOverTheAmountOfUSD__c----'+accInfo.PaymentOverTheAmountOfUSD__c);
                        //console.log('component.find("Yes-3").getElement().checkedc----'+component.find("Yes-3").getElement());
                        //component.find("Yes3").getElements().checked = true;
                        //console.log('component.find("Yes3").getElement().checkedc----'+component.find("Yes3"));
                        // if(accInfo.PaymentOverTheAmountOfUSD__c == 'Yes')
                        // {
                        //     component.set("v.YesPaymentOverTheAmountOfUSD",true);
                        // }
                        // else if(accInfo.PaymentOverTheAmountOfUSD__c == 'No')
                        // {
                        //     component.set("v.NoPaymentOverTheAmountOfUSD",true);
                        // }
                        // //console.log('component.find("Yes-3").getElement().checkedc--2--'+component.find("Yes-3").getElement().checked);

                        // if(accInfo.ViolatingAntiMoneyLaunderingLaws__c == 'Yes')
                        // {
                        //     component.set("v.yes4",true);
                        // }
                        // else if(accInfo.ViolatingAntiMoneyLaunderingLaws__c == 'No')
                        // {
                        //     component.set("v.no4",true);
                        // }

                        // if(accInfo.EnvironmentPolicy__c == 'Yes')
                        // {
                        //     component.set("v.YesEnvironmentPolicy",true);
                        // }
                        // else if(accInfo.EnvironmentPolicy__c == 'No')
                        // {
                        //     component.set("v.NoEnvironmentPolicy",true);
                        // }

                        // if(accInfo.OccupationalHealthAndSafetyPolicy__c == 'Yes')
                        // {
                        //     component.set("v.YesOccupationalHealthAndSafetyPolicy",true);
                        // }
                        // else if(accInfo.OccupationalHealthAndSafetyPolicy__c == 'No')
                        // {
                        //     component.set("v.NoOccupationalHealthAndSafetyPolicy",true);
                        // }

                        // if(accInfo.CorporateGovernancePolicy__c == 'Yes')
                        // {
                        //     component.set("v.YesCorporateGovernancePolicy",true);
                        // }
                        // else if(accInfo.CorporateGovernancePolicy__c == 'No')
                        // {
                        //     component.set("v.NoCorporateGovernancePolicy",true);
                        // }
                        // console.log('SocialResponsibilityPolicy__c: '+accInfo.SocialResponsibilityPolicy__c);
                        // if(accInfo.SocialResponsibilityPolicy__c == 'Yes')
                        // {
                        //     component.set("v.YesSocialResponsibilityPolicy",true);
                        // }
                        // else if(accInfo.SocialResponsibilityPolicy__c == 'No')
                        // {
                        //     component.set("v.NoSocialResponsibilityPolicy", true);
                        // }
                        // if(accInfo.HumanRightsPolicy__c == 'Yes')
                        if (accInfo.PaymentOverTheAmountOfUSD__c == 'Yes') {
                            component.set('v.DisplayReasonPaymentOverTheAmountOfUSD', true);
                            // component.set("v.YesPaymentOverTheAmountOfUSD",true);
                        }
                        // else if(accInfo.PaymentOverTheAmountOfUSD__c == 'No')
                        // {
                        //     component.set('v.DisplayReasonPaymentOverTheAmountOfUSD',true);
                        //     component.set("v.NoPaymentOverTheAmountOfUSD",true);
                        // }
                        if (accInfo.HasIssuesDuringThePast5Years__c == 'Yes') {
                            component.set('v.DisplayReasonHasIssuesDuringThePast5Years', true);
                            //component.set("v.YesHasIssuesDuringThePast5Years",true);
                        }
                        // else if(accInfo.HasIssuesDuringThePast5Years__c == 'No')
                        // {
                        //     component.set('v.DisplayReasonHasIssuesDuringThePast5Years', true);
                        //     component.set("v.NoHasIssuesDuringThePast5Years",true);
                        // }
                        if (accInfo.HasFailedSupplyInLast3Years__c == 'Yes') {
                            component.set('v.DisplayHasFailedSupplyInLast3Years', true);

                            //     component.set("v.YesHasFailedSupplyInLast3Years",true);
                        }
                        // else if(accInfo.HasFailedSupplyInLast3Years__c == 'No')
                        // {
                        //     component.set('v.DisplayHasFailedSupplyInLast3Years', true);
                        //     component.set("v.NoHasFailedSupplyInLast3Years",true);
                        // }
                        if (accInfo.HasSanctionedTarget__c == 'Yes') {
                            component.set('v.DisplayReasonHasSanctionedTarget', true);
                            //     component.set("v.YesHasSanctionedTarget",true);
                        }
                        //     component.set("v.YesHumanRightsPolicy",true);
                        // }
                        // else if(accInfo.HumanRightsPolicy__c == 'No')
                        // {
                        //     component.set("v.NoHumanRightsPolicy",true);
                        // }
                        // if(accInfo.HasIssuesDuringThePast5Years__c == 'Yes')
                        // {
                        //     component.set("v.YesHasIssuesDuringThePast5Years",true);
                        // }
                        // else if(accInfo.HasIssuesDuringThePast5Years__c == 'No')
                        // {
                        //     component.set("v.NoHasIssuesDuringThePast5Years",true);
                        // }
                        // if(accInfo.HasFailedSupplyInLast3Years__c == 'Yes')
                        // {
                        //     component.set("v.YesHasFailedSupplyInLast3Years",true);
                        // }
                        // else if(accInfo.HasFailedSupplyInLast3Years__c == 'No')
                        // {
                        //     component.set("v.NoHasFailedSupplyInLast3Years",true);
                        // }
                        // if(accInfo.HasSanctionedTarget__c == 'Yes')
                        // {
                        //     component.set("v.YesHasSanctionedTarget",true);
                        // }
                        // else if(accInfo.HasSanctionedTarget__c == 'No')
                        // {
                        //     component.set("v.NoHasSanctionedTarget",true);
                        // }

                        // if(accInfo.CustomersFacilityTankAndStorage__c)
                        // {
                        //     var CustomerTankAndStorageValue = accInfo.CustomersFacilityTankAndStorage__c.split(";");
                        //     component.set("v.CustomerTankAndStorageValue",CustomerTankAndStorageValue);
                        // }
                        // if(accInfo.CustomersFacilityTransportation__c)
                        // {
                        //     var CustomerTransportationValue = accInfo.CustomersFacilityTransportation__c.split(";");
                        //     component.set("v.CustomerTransportationValue",CustomerTransportationValue);
                        // }
                        // if(accInfo.SuppliersFacilityTankAndStorage__c)
                        // {
                        //     var SupplierTankAndStorageValue = accInfo.SuppliersFacilityTankAndStorage__c.split(";");
                        //     component.set("v.SupplierTankAndStorageValue",SupplierTankAndStorageValue);
                        // }
                        // if(accInfo.SuppliersFacilityTransportation__c)
                        // {
                        //     var SupplierTransportationValue = accInfo.SuppliersFacilityTransportation__c.split(";");
                        //     component.set("v.SupplierTransportationValue",SupplierTransportationValue);
                        // }
                        console.log('AccountNumber : ' + accInfo.Customer__r.AccountNumber__c);
                        if (accInfo.SameRegisteredAddress__c) {
                            component.set('v.isSameAddress', true);
                        }
                        console.log('RecordType.DeveloperName : ' + accInfo.RecordTypeId);
                        component.set('v.recordTypeName', accInfo.RecordType.DeveloperName);
                        //helper.getFacilityTransportation(component, event);
                        //helper.getFacilityTankAndStorage(component, event);
                        console.log('AccountNumber : ' + accInfo.Customer__r.AccountNumber__c);
                        if (accInfo.InterestedProductTypeAsCustomerTX__c) {
                            component.set('v.isCustomerProductSelected', true);
                            component.set('v.isNoCustomerProducts', false);
                            component.set('v.isNoCustomerProductsSAPSync', false);
                        }
                        if (accInfo.InterestedProductTypeAsSupplierTX__c) {
                            component.set('v.isSupplierProductSelected', true);
                        }

                        if (accInfo.Customer__r.AccountNumber__c || accInfo.Customer__r.SupplierNumber__c) {
                            component.set("v.SAPSync", true);
                            component.set('v.isSameAddress', true);
                            if (component.get("v.isCustomerType")) 
                            {
                                component.set('v.isNoCustomerProducts', true);
                                component.set('v.isNoCustomerProductsSAPSync', true);
                                if(accInfo.Customer__r.AccountNumber__c)
                                {
                                    component.set("v.SAPSyncCustomer", true);
                                }
                            }
                            if (component.get("v.isSupplierType"))
                            {
                                if(accInfo.Customer__r.SupplierNumber__c)
                                {
                                    component.set("v.SAPSyncSupplier", true);
                                }
                            }
                        }
                        console.log(component.get("v.SAPSync"), accInfo.Customer__r.AccountNumber__c || accInfo.Customer__r.SupplierNumber__c);

                        // console.log('AccountNumber : ' + accInfo.Customer__r.AccountNumber__c);
                        // if (component.get("v.isSupplierType")) {
                        //     if (accInfo.Customer__r.SupplierNumber__c) {
                        //         component.set("v.SAPSync", true);
                        //         component.set('v.isSameAddress', true);
                        //     }
                        // }

                        if (accInfo.RecordType.DeveloperName.includes('Edit')) {
                            component.set("v.SAPSync", false);
                            component.set("v.SAPSyncCustomer", false);
                            component.set("v.SAPSyncSupplier", false);
                        }
                        if (accInfo.InternalEditField__c) {
                            var mListFieldChanged = JSON.parse(accInfo.InternalEditField__c);
                            component.set("v.ChangedFieldForEDIT", mListFieldChanged);
                        }
                        
                        helper.getLocationType(component, event);
                        helper.getShippingCountry(component, event);
                        var actionSH = component.get("c.getShareHolderInfo");
                        console.log('accInfo-2-' + accInfo.Customer__c);
                        actionSH.setParams({
                            "recordId": recordId
                        });
                        actionSH.setCallback(this, function (responseSH) {
                            var state = responseSH.getState();
                            console.log('state----' + state);
                            if (state === "SUCCESS") {
                                var shareholderList = responseSH.getReturnValue();
                                console.log('shareholderList----' + JSON.stringify(shareholderList));
                                if (shareholderList.length == 0) {
                                    helper.createObjectData(component, event);
                                }
                                else {
                                    console.log('reqitemId----' + component.get("v.reqitemId"));
                                    component.set("v.shareholderList", shareholderList);
                                }

                                var actiongetShipping = component.get("c.getShippingCountryInfo");

                                actiongetShipping.setParams({
                                    "recordId": component.get("v.reqitemId")
                                });
                                actiongetShipping.setCallback(this, function (responsegetShipping) {
                                    var state3 = responsegetShipping.getState();
                                    console.log('shippingList--state3--' + state3);
                                    if (state3 === "SUCCESS") {
                                        var shippingList = responsegetShipping.getReturnValue();
                                        if (shippingList.length == 0) {
                                            helper.createObjectDataDestination(component, event);
                                        }
                                        else {
                                            console.log('shippingList----' + JSON.stringify(shippingList));
                                            component.set("v.shippingList", shippingList);
                                        }

                                    }
                                }
                                );
                                $A.enqueueAction(actiongetShipping);
                            }
                        });
                        $A.enqueueAction(actionSH);
                        component.set('v.isLoaded', true);
                        component.set('v.isInitial', true);
                    }
                });
                $A.enqueueAction(action);

            }
            catch (ex) {
                console.log('ex----' + ex.message);
            }

            helper.getRequetItem(component, event);

            /*
            try
            {
                var action = component.get("c.getReqItemInfo");
                var recordId = component.get("v.recordId");
                console.log('recordIdc-2-'+recordId);
                action.setParams({
                    "itemId": recordId
                });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") 
                    {
                        var item = response.getReturnValue();
                        console.log('item.Customer__c--'+item.Customer__c);
                        console.log('item--'+JSON.stringify(item));
                        component.set("v.accountId",item.Customer__c);
                        
                        var recordTypeName = item.RecordType.DeveloperName;
                        console.log('recordTypeNamec--'+recordTypeName);
                        if(recordTypeName == 'CustomerInitial' || recordTypeName == 'SupplierInitial')
                        {
                            component.set("v.onPageRecordID",item.Customer__c);
                        }
                        else
                        {
                            component.set("v.onPageRecordID",recordId);
                        }
                        console.log('recordTypeNamec--'+component.get("v.onPageRecordID"));
                        
                        var actiongetObjectAPIFromId = component.get("c.getObjectAPIFromId");
                        
                        actiongetObjectAPIFromId.setParams({
                            "recordId": component.get("v.onPageRecordID")
                        });
                        
                        actiongetObjectAPIFromId.setCallback(this, function(responsegetObjectAPIFromId) {
                            var state = responsegetObjectAPIFromId.getState();
                            
                            if (state === "SUCCESS") 
                            {
                                var ObjectType = responsegetObjectAPIFromId.getReturnValue();
                                component.set("v.ObjectType",ObjectType);
                                console.log('ObjectType----'+ObjectType);
                            }
                        }
                                                            );
                        $A.enqueueAction(actiongetObjectAPIFromId);
                        
                    }
                }
                                  );
                $A.enqueueAction(action);
            }
            catch(ex)
            {
                console.log('ex----'+ex.message());
            }
            
            */


        }





    },

    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        // -1 open/close section
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
    addNewRow: function (component, event, helper) {
        // call the command "createObjectData" helper method for add new Object Row to List
        helper.createObjectData(component, event);
    },
    removeDeletedRow: function (component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method
        console.log('parent --- ' + index);
        var itemList = component.get("v.shareholderList");
        itemList.splice(index, 1);

        component.set("v.shareholderList", itemList);
    },
    addNewRowDestination: function (component, event, helper) {
        // call the command "createObjectData" helper method for add new Object Row to List
        helper.createObjectDataDestination(component, event);
    },
    removeDeletedRowDestination: function (component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method
        var itemList = component.get("v.shippingList");
        itemList.splice(index, 1);

        component.set("v.shippingList", itemList);
    },

    handleError: function (component, event, helper) {
        component.set("v.isLoaded", true);
        helper.showToast('Error', 'error', event.getParam("detail"));
    },

    handleSubmit: function (component, event, helper) {

        try {
            component.set('v.isLoaded', false);
            event.preventDefault();
            const formData = event.getParam('fields');
            if (component.get('v.isNoCustomerProducts') == false) {
                var shippingList = component.get('v.shippingList');
                console.log('shippingList:' + JSON.stringify(shippingList));
                if (shippingList.length == 0) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "error!",
                        "message": "Destination country is Required. Please add Destination country at least 1 record.",
                        "type": "error"
                    });
                    toastEvent.fire();
                    component.set('v.isLoaded', true);
                    return;
                }
            }
            const today = (new Date()).setHours(0, 0, 0, 0);
            if (formData.IncoperationDate__c) {
                const IncoperationDate__c = (new Date(formData.IncoperationDate__c)).setHours(0, 0, 0, 0);
                if (IncoperationDate__c > today) {
                    const toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "Incorporation Date must be lesser than today",
                        "type": "error"
                    });
                    toastEvent.fire();
                    component.set('v.isLoaded', true);
                    return;
                }
            }
            if (formData.StartTradingDate__c) {
                const StartTradingDate__c = (new Date(formData.StartTradingDate__c)).setHours(0, 0, 0, 0);
                if (StartTradingDate__c < today) {
                    const toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "Tentative Starting Date must be greater than today",
                        "type": "error"
                    });
                    toastEvent.fire();
                    component.set('v.isLoaded', true);
                    return;
                }
            }

            var shareHolderList = component.get("v.shareholderList");
            var validateShareHolder = false;

            for (var shareholder of shareHolderList) {
                console.log('shareholder.of_Shareholder__c:' + shareholder.of_Shareholder__c);
                if (shareholder.of_Shareholder__c < 10) {
                    validateShareHolder = true;
                }
            }
            if(!component.get('v.isEdit'))
            {
                if (shareHolderList.length == 0) {
                    validateShareHolder = true;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "error!",
                        "message": "Shareholder is Required. Please add sharedholder at least 1 record.",
                        "type": "error"
                    });
                    toastEvent.fire();
                    component.set('v.isLoaded', true);
                    return;
                }
            }
            
            if (validateShareHolder) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "message": "Please make sure shareholder is greater than 10%",
                    "type": "error"
                });
                toastEvent.fire();
                component.set('v.isLoaded', true);
                return;
            }
            else {


                var recTypeID = component.get("v.recordTypeId");
                console.log('==========recTypeID==============---' + recTypeID);
                var isCustomer = component.get('v.isCustomerType');
                var isSupplier = component.get('v.isSupplierType');
                var TypeOfBusiness = component.get("v.typeOfBusiness");
                console.log('TypeOfBusiness-2--' + TypeOfBusiness);

                const fields = event.getParam('fields');
                fields.Name = fields.CompanyNameENF__c;
                fields.TypeOfBusiness__c = TypeOfBusiness;
                fields.recordtypeid = recTypeID;
                console.log('TypeOfBusiness 4---' + TypeOfBusiness);

                if (fields.SameRegisteredAddress__c) {
                    fields.MailingHousenoLocal__c = fields.HousenoLocal__c;
                    fields.MailingRoom__c = fields.RoomLocal__c;
                    fields.MailingBuildingCode__c = fields.BuildingCodeLocal__c;
                    fields.MailingCoName__c = fields.CoName__c;
                    fields.MailingFloor__c = fields.FloorLocal__c;
                    fields.MailingCity__c = fields.CityStateLocal__c;
                    fields.MailingDistrict__c = fields.DistrictLocalText__c;
                    fields.MailingPostalCode__c = fields.PostalCodeLocalText__c;
                    fields.MailingStreet__c = fields.StreetLocal__c;
                    fields.MailingSubDistrict__c = fields.SubDistrictLocalText__c;

                }
                if (!component.get('v.DisplayReasonHasIssuesDuringThePast5Years')) {
                    fields.SpecifyIssuesDuringThePast5Years__c = '';
                }
                if (!component.get('v.DisplayReasonPaymentOverTheAmountOfUSD')) {
                    fields.ReasonOfTheDefault__c = '';
                }
                if (!component.get('v.DisplayHasFailedSupplyInLast3Years')) {
                    fields.SpecifyFailedSupplyInLast3Years__c = '';
                }
                if (!component.get('v.DisplayReasonHasSanctionedTarget')) {
                    fields.SpecifySanctionedTarget__c = '';
                }

                // var EnvironmentPolicy = helper.ConvertedRadioYesNoToText(component, component.find("YesEnvironmentPolicy").getElement().checked, component.find("NoEnvironmentPolicy").getElement().checked);
                // if(EnvironmentPolicy)
                // {
                //     fields.EnvironmentPolicy__c = EnvironmentPolicy;
                // }

                // var SocialResponsibilityPolicy = helper.ConvertedRadioYesNoToText(component, component.find("YesSocialResponsibilityPolicy").getElement().checked, component.find("NoSocialResponsibilityPolicy").getElement().checked);
                // if(SocialResponsibilityPolicy)
                // {
                //     fields.SocialResponsibilityPolicy__c = SocialResponsibilityPolicy;
                // }

                // var OccupationalHealthAndSafetyPolicy = helper.ConvertedRadioYesNoToText(component, component.find("YesOccupationalHealthAndSafetyPolicy").getElement().checked, component.find("NoOccupationalHealthAndSafetyPolicy").getElement().checked);
                // if(OccupationalHealthAndSafetyPolicy)
                // {
                //     fields.OccupationalHealthAndSafetyPolicy__c = OccupationalHealthAndSafetyPolicy;
                // }

                // var CorporateGovernancePolicy = helper.ConvertedRadioYesNoToText(component, component.find("YesCorporateGovernancePolicy").getElement().checked, component.find("NoCorporateGovernancePolicy").getElement().checked);
                // if(CorporateGovernancePolicy)
                // {
                //     fields.CorporateGovernancePolicy__c = CorporateGovernancePolicy;
                // }
                // var HumanRightsPolicy = helper.ConvertedRadioYesNoToText(component, component.find("YesHumanRightsPolicy").getElement().checked, component.find("NoHumanRightsPolicy").getElement().checked);
                // if(HumanRightsPolicy)
                // {
                //     fields.HumanRightsPolicy__c = HumanRightsPolicy;
                // }
                // console.log('TypeOfBusiness-9--'+TypeOfBusiness);

                // var HasSanctionedTarget = helper.ConvertedRadioYesNoToText(component, component.find("YesHasSanctionedTarget").getElement().checked, component.find("NoHasSanctionedTarget").getElement().checked);
                // if(HasSanctionedTarget)
                // {
                //     fields.HasSanctionedTarget__c = HasSanctionedTarget;
                // }
                // console.log('TypeOfBusiness-10--'+TypeOfBusiness);

                // if(isCustomer)
                // {
                //     var PaymentOverTheAmountOfUSD = helper.ConvertedRadioYesNoToText(component, component.find("YesPaymentOverTheAmountOfUSD").getElement().checked, component.find("NoPaymentOverTheAmountOfUSD").getElement().checked);
                //     if(PaymentOverTheAmountOfUSD)
                //     {
                //         fields.PaymentOverTheAmountOfUSD__c = PaymentOverTheAmountOfUSD;
                //     }
                //     var HasIssuesDuringThePast5Years = helper.ConvertedRadioYesNoToText(component, component.find("YesHasIssuesDuringThePast5Years").getElement().checked, component.find("NoHasIssuesDuringThePast5Years").getElement().checked);
                //     if(HasIssuesDuringThePast5Years)
                //     {
                //         fields.HasIssuesDuringThePast5Years__c = HasIssuesDuringThePast5Years;
                //     }

                //     var CustomerTankAndStorageValue = helper.getMultipicklistValueFromList(component, component.get("v.CustomerTankAndStorageValue"));
                //     var CustomerTransportationValue = helper.getMultipicklistValueFromList(component, component.get("v.CustomerTransportationValue"));
                //     fields.CustomersFacilityTankAndStorage__c = CustomerTankAndStorageValue;
                //     fields.CustomersFacilityTransportation__c = CustomerTransportationValue;
                // }
                // if(isSupplier)
                // {

                //     var HasFailedSupplyInLast3Years = helper.ConvertedRadioYesNoToText(component, component.find("YesHasFailedSupplyInLast3Years").getElement().checked, component.find("NoHasFailedSupplyInLast3Years").getElement().checked);
                //     if(HasFailedSupplyInLast3Years)
                //     {
                //         fields.HasFailedSupplyInLast3Years__c = HasFailedSupplyInLast3Years;
                //     }


                //     var SupplierTankAndStorageValue = helper.getMultipicklistValueFromList(component, component.get("v.SupplierTankAndStorageValue"));
                //     var SupplierTransportationValue = helper.getMultipicklistValueFromList(component, component.get("v.SupplierTransportationValue"));


                //     fields.SuppliersFacilityTankAndStorage__c = SupplierTankAndStorageValue;
                //     fields.SuppliersFacilityTransportation__c = SupplierTransportationValue;
                // }

                /*var Yes4_yes = component.find("Yes-4").getElement().checked;
                var Yes4_No = component.find("No-4").getElement().checked;
                if(Yes4_yes)
                {
                    fields.ViolatingAntiMoneyLaunderingLaws__c = 'Yes';
                }
                if(Yes4_No)
                {
                    fields.ViolatingAntiMoneyLaunderingLaws__c = 'No';
                }*/




                console.log('fields----' + JSON.stringify(fields));

                if (component.get("v.ObjectType") == 'CTRRequestFormHeader__c') {
                    fields.ChangedCounterParty__c = true;

                    var jsonChanged = JSON.stringify(component.get('v.ChangedFieldForEDIT'));
                    fields.InternalEditField__c = jsonChanged;
                    component.find('recordEditForm').submit(fields);
                    component.set('v.isLoaded', true);
                }
                else {
                    var custproduct = component.find("InterestedProductTypeCustomer__c").get("v.value");
                    var supplproduct = component.find("InterestedProductTypeSupplier__c").get("v.value");
                    if (custproduct || supplproduct) {
                        var action = component.get("c.checkDupAccount");

                        action.setParams({
                            "jsonData": JSON.stringify(fields),
                            "shareholderList": component.get("v.shareholderList"),
                            "shippingList": component.get("v.shippingList")
                        });

                        action.setCallback(this, function (response) {
                            var state = response.getState();

                            if (state === "SUCCESS") {
                                var listofvalue = response.getReturnValue();
                                console.log('listofvalue---' + JSON.stringify(listofvalue));
                                console.log('isDuplicate---' + listofvalue.isDuplicate);
                                console.log('newRequestHeaderId---' + listofvalue.newRequestHeaderId);
                                console.log('AccountId==' + listofvalue.AccountId)
                                component.set("v.reqitemId", listofvalue.newRequestHeaderId);
                                if (listofvalue.isDuplicate) {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Warning!",
                                        "message": "Cannot create!! Duplicate counterparty, Redirect to Existing counterparty",
                                        "type": "error"
                                    });
                                    toastEvent.fire();
                                }
                                else {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Success!",
                                        "message": "Counterparty is created successfully",
                                        "type": "success"
                                    });
                                    toastEvent.fire();
                                }
                                window.parent.location = '/' + listofvalue.AccountId;
                                //window.parent.location = '/' + listofvalue.newRequestHeaderId;
                            }
                            else if (state === "ERROR") {
                                var errors = response.getError();
                                if (errors) {
                                    if (errors[0] && errors[0].message) {
                                        // log the error passed in to AuraHandledException
                                        console.log("Error message: " +
                                            errors[0].message);
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Error!",
                                            "message": errors[0].message,
                                            "type": "error"
                                        });
                                        toastEvent.fire();
                                    }
                                }
                            }
                            component.set('v.isLoaded', true);

                        }
                        );
                        $A.enqueueAction(action);
                    }
                    else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "error!",
                            "message": "Please add Interested Product before save",
                            "type": "error"
                        });
                        toastEvent.fire();
                        component.set('v.isLoaded', true);

                    }

                }
            }

        }
        catch (ex) {
            console.log('ex---' + ex.message());
            component.set('v.isLoaded', true);

        }

    },
    handleSuccess: function (component, event, helper) {
        // Return to the contact page and
        // display the new case under the case related list
        component.set('v.isLoaded', false);

        event.preventDefault();
        var payload = event.getParams().response;
        console.log('onsuccess--' + payload.id);
        console.log('shareholderlist--' + JSON.stringify(component.get("v.shareholderList")));
        console.log('shippingList--' + JSON.stringify(component.get("v.shippingList")));
        console.log('accId--' + component.get("v.accId"));

        var action = component.get("c.createShareHolderAndDestination");

        action.setParams({
            "shareholderList": component.get("v.shareholderList"),
            "shippingList": component.get("v.shippingList"),
            "itemId": component.get("v.reqitemId"),
            "headerId": component.get("v.onPageRecordID"),
            "accId": component.get("v.accId"),
            "isAccountCreate": component.get('v.isAccount'),
            "isTRCR": component.get('v.isTRCR')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var reqItem = response.getReturnValue();
                console.log('success', reqItem);
                //$A.get('e.force:refreshView').fire();
                if (component.get('v.ObjectType') == 'CTRRequestFormHeader__c') {
                    if (reqItem && reqItem.RecordTypeName__c.includes('Edit') && reqItem.Sensitive__c) {
                        component.set('v.reqItemNumber', reqItem.Name);
                        component.set('v.isModalSensitiveOpen', true);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Counterparty is update successfully",
                            "type": "success"
                        });
                        toastEvent.fire();
                        component.set('v.IsPageDisable', true);
                        window.location.reload();
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }
                else {
                    console.log('newRequestHeaderId==' + component.get("v.reqitemId"))

                    window.parent.location = '/' + component.get("v.reqitemId");
                }

                /*
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": payload.id,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "lightning/r/Account/"+payload.id+"/view"
                });
                urlEvent.fire();*/
            }
            $A.get('e.force:refreshView').fire();
            component.set('v.isLoaded', true);

        }
        );
        $A.enqueueAction(action);

        /*
        var navService = component.find("navService");        
        var pageReference = {
            "type": 'standard__recordPage',         
            "attributes": {              
                "recordId": payload.id,
                "actionName": "view",               
                "objectApiName":"Account"              
            }        
        };
       
        component.set("v.pageReference", pageReference);
        
        var pageReference = component.get("v.pageReference");
        navService.navigate(pageReference); 
        $A.get('e.force:refreshView').fire();*/

    },
    handleTypeOfBusiness: function (component, event, helper) {
        var typeOfBusiness = event.getParam("value");
        console.log('typeOfBusiness---' + typeOfBusiness)
        component.set('v.typeOfBusiness', typeOfBusiness);
    },
    handleInterestProductCustomerChange: function (component, event, helper) {
        var custproduct = component.find("InterestedProductTypeCustomer__c").get("v.value");
        if (custproduct) {
            if (custproduct.includes("Lube Base product")) {
                component.set('v.isLube', true);
            }
            else {
                component.set('v.isLube', false);
            }
            if (custproduct.includes("LABIX Product")) {
                component.set('v.isLABIX', true);
            }
            else {
                component.set('v.isLABIX', false);
            }
            if (custproduct.includes("Other Products")) {
                component.set('v.isCustomerOtherProducts', true);
            }
            else {
                component.set('v.isCustomerOtherProducts', false);
            }
            component.set('v.isCustomerProductSelected', true);
            component.set('v.isNoCustomerProducts', false);
            component.set('v.isNoCustomerProductsSAPSync', false);

        }
        else {
            component.set('v.isNoCustomerProducts', true);

            component.set('v.isCustomerProductSelected', false);
        }
        helper.addFieldChangeToJson(component, event);

    },
    handleInterestProductSupplierChange: function (component, event, helper) {
        var supplproduct = component.find("InterestedProductTypeSupplier__c").get("v.value");
        if (supplproduct.includes("Petroleum")) {
            component.set('v.isPetroleum', true);
        }
        else {
            component.set('v.isPetroleum', false);
        }
        if (supplproduct.includes("Other Products")) {
            component.set('v.isSupplierOtherProducts', true);
        }
        else {
            supplproduct.set('v.isSupplierOtherProducts', false);
        }
    },
    handleSameRegisteredAddress: function (component, event, helper) {
        var isame = component.find("SameRegisteredAddress__c").get("v.value");
        console.log('handleSameRegisteredAddress---' + isame);
        if (isame) {
            component.set('v.isSameAddress', true);
        }
        else {
            component.set('v.isSameAddress', false);
        }
    },
    handleTypeofBussinessChange: function (component, event, helper) {
        var typeofbussiness = component.find("TypeOfBusinessCommercialEvaluation__c").get("v.value");
        if (typeofbussiness) {
            if (typeofbussiness.includes("Other")) {
                component.set('v.isOtherTypeofBussiness', true);
            }
            else {
                component.set('v.isOtherTypeofBussiness', false);
            }
        }
        helper.addFieldChangeToJson(component, event);
    },
    handleisOtherLegalEntityChange: function (component, event, helper) {
        var legalentity = component.find("LegalEntity__c").get("v.value");
        if (legalentity) {
            if (legalentity.includes("Other")) {
                component.set('v.isOtherLegalEntity', true);
            }
            else {
                component.set('v.isOtherLegalEntity', false);
            }
        }
        helper.addFieldChangeToJson(component, event);
    },
    handleCancel: function (component, event, helper) {
        if (component.get("v.onPageRecordID") == null || component.get("v.onPageRecordID") == '') {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/lightning/o/Account/list?filterName=Recent"
            });
            urlEvent.fire();
        }
        if (component.get('v.ObjectType') == 'CTRRequestFormHeader__c') {
            component.set('v.IsPageDisable', true);
            $A.get("e.force:closeQuickAction").fire();
        }


    },
    onPageReferenceChanged: function (cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    handleChangeCheckboxGroup: function (component, event, helper) {
        console.log('event:' + event.getParam('value'));
        console.log('CustomerTankAndStorageValue: ' + component.get("v.CustomerTankAndStorageValue"));
        console.log('SupplierTankAndStorageValue: ' + component.get("v.SupplierTankAndStorageValue"));

        console.log('CustomerTransportationValue: ' + component.get("v.CustomerTransportationValue"));
        console.log('SupplierTransportationValue: ' + component.get("v.SupplierTransportationValue"));

    },
    handleChangeYesNo: function (component, event, helper) {
        var value = event.getParam("value")[0];
        var fieldName = event.getSource().get('v.fieldName');
        console.log('yes no: value is ' + value);
        console.log('fieldName: value is ' + fieldName);
        var mBoolean = false;
        if (value) {
            if (value == 'Y') {
                mBoolean = true;
            }
        }
        if (fieldName == 'HasIssuesDuringThePast5Years__c') {
            component.set('v.DisplayReasonHasIssuesDuringThePast5Years', mBoolean);
        }
        if (fieldName == 'PaymentOverTheAmountOfUSD__c') {
            component.set('v.DisplayReasonPaymentOverTheAmountOfUSD', mBoolean);
        }
        if (fieldName == 'HasFailedSupplyInLast3Years__c') {
            component.set('v.DisplayHasFailedSupplyInLast3Years', mBoolean);
        }
        if (fieldName == 'HasSanctionedTarget__c') {
            component.set('v.DisplayReasonHasSanctionedTarget', mBoolean);
        }
    },
    handleLoad: function (component, event, helper) {
        $A.util.addClass(component.find("spinner"), "slds-hide");
    },
    handleAddJson: function (component, event, helper) {
        helper.addFieldChangeToJson(component, event);
    },
    handleisOtherMainProductChange: function (component, event, helper) {
        var legalentity = component.find("MainProduct__c").get("v.value");
        console.log("Legal entity selected for Other Main Product: " + legalentity);
        if (legalentity) {
            if (legalentity.includes("Other")) {
                component.set('v.isOtherMainProduct', true);
            }
            else {
                component.set('v.isOtherMainProduct', false);
            }
        }
        helper.addFieldChangeToJson(component, event);
    },

    handleisOtherMainServiceChange: function (component, event, helper) {
        var legalentity = component.find("MainService__c").get("v.value");
        console.log("Legal entity selected for Other Main Service: " + legalentity);
        if (legalentity) {
            if (legalentity.includes("Other")) {
                component.set('v.isOtherMainService', true);
            }
            else {
                component.set('v.isOtherMainService', false);
            }
        }
        helper.addFieldChangeToJson(component, event);
    },

    handleisAccountGroupChange: function (component, event, helper) {
        var accountGroups = component.find("AccountGroup__c");
        for (var i = 0; i < accountGroups.length; i++) {
            var legalentity = accountGroups[i].get("v.value");
            if (legalentity) {
                if (legalentity.includes("TOPG")) {
                    component.set('v.isAccountGroup', true);
                } else {
                    component.set('v.isAccountGroup', false);
                }
            }
            console.log("Account Group selected for: " + legalentity);
        }
        helper.addFieldChangeToJson(component, event);
    },

    closeModel: function (component, event, helper) {
        component.set("v.isModalSensitiveOpen", false);
        component.set('v.IsPageDisable', true);
        window.location.reload();
    },
})