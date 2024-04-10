({
    validateUserProfile : function(component) {
        component.set('v.isLoaded', false);
        var action = component.get("c.validateUserProfile");
        action.setParams({
            "userId": $A.get("$SObjectType.CurrentUser.Id"),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                var result = response.getReturnValue();
                if(result)
                {
                    if(result.BusinessUnit__c == 'TX')
                    {
                        component.set('v.isTX', true);
                    }
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[validateUserProfile] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[validateUserProfile] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },
    
    loadPicklistValue : function(component, event) {
        console.log('---loadPicklistValue---');
        var buInfo = component.get("v.BUInfo"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        var action = component.get("c.getReqItemInfo");
        action.setParams({
            "itemId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                try
                {
                    var result = response.getReturnValue();
                    var NoOfRegistrationMinistryEnergy = result.CTRRequestFormHeader__r.NoOfRegistrationMinistryEnergy__c;
                    var Yearofexperience = result.CTRRequestFormHeader__r.Yearofexperience__c;
                    var ReputationInTheMarket = result.ReputationInTheMarket__c;
                    var TypeOfBusiness = result.CTRRequestFormHeader__r.TypeOfBusinessCommercialEvaluation__c;
                    var LegalEntityCommercialEvaluation = result.CTRRequestFormHeader__r.LegalEntity__c;
                    var Country = result.CTRRequestFormHeader__r.Country__r.Code__c;
                    var SalesOrgTOP = result.SalesOrganizationTOP__c;
                    var SalesOrgTX = result.SalesOrganizationTX__c;
                    var googleLink = result.CTRRequestFormHeader__r.LocationInGoogleMapsLinks__c;
                    var storage = '';
                    var transportation = '';
                    var recordtypeName = result.RecordType.DeveloperName;
                    var scoreby = result.CommercialScoringBy__c;
                    var OwnerId = result.OwnerId;
                    var currentUser = $A.get("$SObjectType.CurrentUser.Id");
                    var status = result.Status__c; 
                    
                    
                    //Check recortype = New Supplier / Extend Supplier
                    if((recordtypeName.includes("SupplierInitial") || recordtypeName.includes("SupplierExtend") || recordtypeName.includes("SupplierEditInfo")) && buInfo.BusinessUnit__c == 'TX')
                    {
                        component.set("v.IsShowPage",false);
                        component.set("v.NotShowText",'This function isn\'t required in this request.');
                        
                    }
                    else
                    {
                        component.set("v.IsShowPage",true);
                        if(OwnerId == currentUser && status == 'Pre Screen')
                        {
                            component.set("v.IsShowedButton",true);
                        }
                        else
                        {
                            component.set("v.IsShowedButton",false);
                        }
                        
                        if(recordtypeName.includes("Customer"))
                        {
                            storage = result.CTRRequestFormHeader__r.CustomersFacilityTankAndStorage__c;
                            transportation = result.CTRRequestFormHeader__r.CustomersFacilityTransportation__c;
                        }
                        else
                        {
                            storage = result.CTRRequestFormHeader__r.SuppliersFacilityTankAndStorage__c;
                            transportation = result.CTRRequestFormHeader__r.SuppliersFacilityTransportation__c;
                            SalesOrgTOP = result.CompanyCodeTOP__c;
                            SalesOrgTX = result.CompanyCodeTX__c;
                        }
                        console.log('---recordtypeName---'+recordtypeName);
                        console.log('---result.NoOfRegistrationMinistryEnergy__c---'+result.CTRRequestFormHeader__r.NoOfRegistrationMinistryEnergy__c);
                        console.log('---result.Yearofexperience__c---'+result.CTRRequestFormHeader__r.Yearofexperience__c);
                        console.log('---result.ReputationInTheMarket__c---'+result.ReputationInTheMarket__c);
                        console.log('---result.TypeOfBusiness__c---'+result.CTRRequestFormHeader__r.TypeOfBusinessCommercialEvaluation__c);
                        console.log('---result.LegalEntityCommercialEvaluation__c---'+result.CTRRequestFormHeader__r.LegalEntity__c);
                        console.log('---result.SalesOrganizationTOP__c---'+result.SalesOrganizationTOP__c);
                        console.log('---result.SalesOrganizationTX__c---'+result.SalesOrganizationTX__c);
                        console.log('---result.googleLink---'+result.CTRRequestFormHeader__r.LocationInGoogleMapsLinks__c);
                        console.log('---result.Country---'+Country);
                        console.log('---storage---'+storage);
                        console.log('---transportation---'+transportation);
                        console.log('---scoreby---'+scoreby);
                        component.set("v.Country",Country);  
                        component.set("v.GoogleLink",googleLink); 
                        if(result)
                        {
                            if(buInfo.BusinessUnit__c == 'TOP' || buInfo.BusinessUnit__c == 'LABIX')
                            {
                                component.set("v.SalesOrg",SalesOrgTOP);     
                            }
                            else
                            {
                                component.set("v.SalesOrg",SalesOrgTX);     
                            }
                            //check if have exisiting score, no need to default
                            if(scoreby == null || scoreby == undefined)
                            {
                                component.find("CommercialScoringBy__c").set("v.value", $A.get("$SObjectType.CurrentUser.Id"));
                                //NumberRegistrationMinistryEnergy
                                if(buInfo.BusinessUnit__c == 'TOP'){
                                    
                                    //default 1.
                                    if(Country == 'TH' && SalesOrgTOP == '1100')
                                    {
                                        if(NoOfRegistrationMinistryEnergy == 'Yes'){
                                            component.find("NumberRegistrationMinistryEnergy__c").set("v.value", '4'); 
                                        }else if(NoOfRegistrationMinistryEnergy == 'No') {
                                            component.find("NumberRegistrationMinistryEnergy__c").set("v.value", '1');
                                        }
                                    }
                                    
                                }
                                
                                
                                //default 4.1,4.2
                                if(Country == 'TH')
                                {
                                    if(googleLink != '' && googleLink != null)
                                    {
                                        component.find("DomesticOfficeLocation__c").set("v.value", '4');
                                    }
                                    else
                                    {
                                        component.find("DomesticOfficeLocation__c").set("v.value", '1');
                                    }
                                    component.find("InternationalOfficeLocation__c").set("v.value", '');
                                }
                                else
                                {
                                    if(googleLink != '' && googleLink != null)
                                    {
                                        component.find("InternationalOfficeLocation__c").set("v.value", '4');
                                    }
                                    else
                                    {
                                        component.find("InternationalOfficeLocation__c").set("v.value", '1');
                                    }
                                    component.find("DomesticOfficeLocation__c").set("v.value", '');
                                }
                                
                                
                                //default 2.
                                // Reputation in the market\
                                console.log('TypeOfBusiness---'+TypeOfBusiness);
                                if(TypeOfBusiness == 'National Oil Company'){
                                    if(LegalEntityCommercialEvaluation == 'Public Limited Company'){
                                        component.find("Thelevelofreputation__c").set("v.value", '4'); 
                                    } 
                                    else
                                    {
                                        component.find("Thelevelofreputation__c").set("v.value", ''); 
                                    }
                                }else if(TypeOfBusiness == 'Major Oil Company'){
                                    if(LegalEntityCommercialEvaluation == 'Subsidiary Company Of Public Limited Company' ||LegalEntityCommercialEvaluation == 'Private Limited Company'){
                                        component.find("Thelevelofreputation__c").set("v.value", '4'); 
                                    }
                                    else
                                    {
                                        component.find("Thelevelofreputation__c").set("v.value", ''); 
                                    }
                                }else if(TypeOfBusiness == 'Trading Firm' || TypeOfBusiness == 'End User' || TypeOfBusiness == 'Manufacturer' || TypeOfBusiness == 'Supplier'){
                                    if(LegalEntityCommercialEvaluation == 'Public Limited Company'){
                                        component.find("Thelevelofreputation__c").set("v.value", '4'); 
                                    }else if(LegalEntityCommercialEvaluation == 'Subsidiary Company Of Public Limited Company'){
                                        component.find("Thelevelofreputation__c").set("v.value", '3'); 
                                    }else if(LegalEntityCommercialEvaluation == 'Private Limited Company'){
                                        component.find("Thelevelofreputation__c").set("v.value", '2'); 
                                    }else if(LegalEntityCommercialEvaluation == 'Private Individual Or Sole Proprietorship'){
                                        component.find("Thelevelofreputation__c").set("v.value", '1'); 
                                    }
                                        else
                                        {
                                            component.find("Thelevelofreputation__c").set("v.value", ''); 
                                        }
                                }else if(TypeOfBusiness == 'Refinery'){
                                    if(LegalEntityCommercialEvaluation == 'Public Limited Company' || LegalEntityCommercialEvaluation == 'Subsidiary Company Of Public Limited Company' ||LegalEntityCommercialEvaluation == 'Private Limited Company'){
                                        component.find("Thelevelofreputation__c").set("v.value", '4'); 
                                    }
                                    else
                                    {
                                        component.find("Thelevelofreputation__c").set("v.value", ''); 
                                    }
                                }
                                    else
                                    {
                                        component.find("Thelevelofreputation__c").set("v.value", ''); 
                                    }
                                
                                //Yearofexperience default 5
                                if(Yearofexperience <  2){
                                    component.find("TheLevelOfExperience__c").set("v.value", '1'); 
                                }else if (Yearofexperience >= 2 && Yearofexperience <= 4){
                                    component.find("TheLevelOfExperience__c").set("v.value", '2'); 
                                }else if (Yearofexperience > 4 && Yearofexperience <= 6){
                                    component.find("TheLevelOfExperience__c").set("v.value", '3'); 
                                }else if (Yearofexperience > 6){
                                    component.find("TheLevelOfExperience__c").set("v.value", '4'); 
                                }
                                    else
                                    {
                                        component.find("TheLevelOfExperience__c").set("v.value", ''); 
                                    }
                                
                                
                                if(storage == 'Own storage facility' || transportation == 'Own transportation')
                                {
                                    component.find("TheEfficiencyLevelOfFacility__c").set("v.value", '4'); 
                                }
                                else if(storage == 'Rent storage facility for one-year contract or more' || transportation == 'Rent transportation for one-year contract or more')
                                {
                                    component.find("TheEfficiencyLevelOfFacility__c").set("v.value", '3'); 
                                }
                                    else if(storage == 'Rent storage facility less than one-year contract' || transportation == 'Rent transportation less than one-year contract')
                                    {
                                        component.find("TheEfficiencyLevelOfFacility__c").set("v.value", '2'); 
                                    }    
                                        else if(storage == 'No storage facility' || transportation == 'No transportation')
                                        {
                                            component.find("TheEfficiencyLevelOfFacility__c").set("v.value", '1'); 
                                        }
                                            else
                                            {
                                                component.find("TheEfficiencyLevelOfFacility__c").set("v.value", '');
                                            }
                                
                                //Destination Country default 3
                                var action1 = component.get("c.getRiskCountry");
                                action1.setParams({
                                    "recordId" : component.get("v.recordId")
                                });
                                action1.setCallback(this, function(response) {
                                    var state = response.getState();
                                    var result = response.getReturnValue();
                                    if(state === "SUCCESS") {
                                        console.log('---result---'+result);
                                        if(result == 'Risk')
                                            component.find("TheDestinationCountry__c").set("v.value", '1'); 
                                        else(result == 'Not Risk')
                                        component.find("TheDestinationCountry__c").set("v.value", '4'); 
                                        
                                        //Re-Calculate
                                        let calPercent = component.get('c.handlePercentCalculate');
                                        $A.enqueueAction(calPercent); 
                                        
                                    }else{
                                        console.log('[validateUserProfile] error -----', errors[0].message);
                                        this.showToast('Error', 'error', errors[0].message);
                                    }
                                });
                                $A.enqueueAction(action1);
                            }
                            else 
                            {
                                if(Country == 'TH')
                                {
                                    component.find("InternationalOfficeLocation__c").set("v.value", '');
                                    
                                }
                                else
                                {
                                    component.find("DomesticOfficeLocation__c").set("v.value", '');
                                    
                                }
                            }
                            
                        }
                    }
                }
                catch(ex)
                {
                    console.error(ex);
                }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[validateUserProfile] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[validateUserProfile] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
            
        });
        $A.enqueueAction(action);
    },
    
    getBUInformation : function(component, event, recordId){
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
                    
                    //this.getRequestItems(component,event, recordId);
                    this.loadPicklistValue(component,event);
                }else{
                    console.log('[validateUserProfile] error -----', errors[0].message);
                    this.showToast('Error', 'error', errors[0].message);
                }
                
                
                
            }
                              );
            $A.enqueueAction(action);
        }
        catch(ex)
        {
            console.log('---ex---'+JSON.stringtify(ex));
        }
        
    },
    
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
})