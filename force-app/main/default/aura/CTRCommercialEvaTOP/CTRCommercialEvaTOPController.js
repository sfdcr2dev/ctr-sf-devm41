({
	doInit : function(component, event, helper) {
        console.log('---doInit---');
        var recordId = component.get("v.recordId");
        helper.validateUserProfile(component);
        helper.getBUInformation(component,event, recordId);
        //helper.loadPicklistValue(component,event);
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
    CommercialhandleClick : function(component, event, helper) {
        
        console.log('---CommercialhandleClick---');
        component.set('v.IsDisable',false);
        var Country = component.get("v.Country");
        var googleLink = component.get("v.GoogleLink");
        if(Country == 'TH')
        {
            component.set("v.IsDomesticDisabled",false);
            component.set("v.IsInterDisabled",true);
        }
        else
        {
            component.set("v.IsDomesticDisabled",true);
            component.set("v.IsInterDisabled",false);
        }
    },
    handlePercentCalculate: function(component, event, helper) {
        //helper.handleCalculate(component,event, recordId);
        var buInfo = component.get("v.BUInfo"); 
        var SalesOrg = component.get("v.SalesOrg"); 
        var Country = component.get("v.Country"); 
        console.log('---buInfo.BusinessUnit__c---'+buInfo.BusinessUnit__c);
        let num = 0;
        if(buInfo.BusinessUnit__c == 'TOP' && SalesOrg == '1100' && Country == 'TH')
        {
            console.log('test--2-'+component.find("NumberRegistrationMinistryEnergy__c"));
            if(component.find("NumberRegistrationMinistryEnergy__c") != undefined && component.find("NumberRegistrationMinistryEnergy__c").get("v.value") != null && component.find("NumberRegistrationMinistryEnergy__c").get("v.value") != '') {
                if(!isNaN(component.find("NumberRegistrationMinistryEnergy__c").get("v.value"))) {
                    console.log('test--3-'+component.find("NumberRegistrationMinistryEnergy__c"));
                    num += (parseInt(component.find("NumberRegistrationMinistryEnergy__c").get("v.value"))*15/4); //15%
                }
            }else{
                num += 0;
            }
            console.log('test--4-'+component.find("Thelevelofreputation__c").get("v.value"));
            if(component.find("Thelevelofreputation__c") != undefined && component.find("Thelevelofreputation__c").get("v.value") != null && component.find("Thelevelofreputation__c").get("v.value") != '') {
                if(!isNaN(component.find("Thelevelofreputation__c").get("v.value"))) {
                    
                    num += (parseInt(component.find("Thelevelofreputation__c").get("v.value"))*15/4); //15%
                }
            }else{
                num += 0;
            }
            if(component.find("TheDestinationCountry__c") != undefined && component.find("TheDestinationCountry__c").get("v.value") != null && component.find("TheDestinationCountry__c").get("v.value") != '') {
                if(!isNaN(component.find("TheDestinationCountry__c").get("v.value"))) {
                    console.log('test--5-'+component.find("TheDestinationCountry__c").get("v.value"));
                    num += (parseInt(component.find("TheDestinationCountry__c").get("v.value"))*15/4);//15%
                }
            }else{
                num += 0;
            }
            if(component.find("DomesticOfficeLocation__c") != undefined && component.find("DomesticOfficeLocation__c").get("v.value") != null && component.find("DomesticOfficeLocation__c").get("v.value") != '') {
                console.log('test---'+component.find("DomesticOfficeLocation__c").get("v.value"));
                if(!isNaN(component.find("DomesticOfficeLocation__c").get("v.value"))) {
                    console.log('test--6-'+component.find("DomesticOfficeLocation__c").get("v.value"));
                    num += (parseInt(component.find("DomesticOfficeLocation__c").get("v.value"))*15/4);   //Top - 15%
                }
            }else{
                num += 0;
            }
            
            
            if(component.find("TheLevelOfExperience__c") != undefined && component.find("TheLevelOfExperience__c").get("v.value") != null && component.find("TheLevelOfExperience__c").get("v.value") != '') {
                if(!isNaN(component.find("TheLevelOfExperience__c").get("v.value"))) {
                    console.log('test--8-'+component.find("TheLevelOfExperience__c").get("v.value"));
                    num += (parseInt(component.find("TheLevelOfExperience__c").get("v.value"))*20/4); //Top - 20%
                }
            }else{
                num += 0;
            }
            if(component.find("TheEfficiencyLevelOfFacility__c") != undefined && component.find("TheEfficiencyLevelOfFacility__c").get("v.value") != null && component.find("TheEfficiencyLevelOfFacility__c").get("v.value") != '') {
                if(!isNaN(component.find("TheEfficiencyLevelOfFacility__c").get("v.value"))) {
                    console.log('test--9-'+component.find("TheEfficiencyLevelOfFacility__c").get("v.value"));
                    num += (parseInt(component.find("TheEfficiencyLevelOfFacility__c").get("v.value"))*20/4); //Top - 20%
                }
            }else{
                num += 0;
            }
        }
        else
        {
            
            console.log('test--4-'+component.find("Thelevelofreputation__c").get("v.value"));
            if(component.find("Thelevelofreputation__c") != undefined && component.find("Thelevelofreputation__c").get("v.value") != null && component.find("Thelevelofreputation__c").get("v.value") != '') {
                if(!isNaN(component.find("Thelevelofreputation__c").get("v.value"))) {
                    
                    num += (parseInt(component.find("Thelevelofreputation__c").get("v.value"))*20/4); //20%
                }
            }else{
                num += 0;
            }
            if(component.find("TheDestinationCountry__c") != undefined && component.find("TheDestinationCountry__c").get("v.value") != null && component.find("TheDestinationCountry__c").get("v.value") != '') {
                if(!isNaN(component.find("TheDestinationCountry__c").get("v.value"))) {
                    console.log('test--5-'+component.find("TheDestinationCountry__c").get("v.value"));
                    num += (parseInt(component.find("TheDestinationCountry__c").get("v.value"))*20/4);//20%
                }
            }else{
                num += 0;
            }
            if(component.find("DomesticOfficeLocation__c") != undefined && component.find("DomesticOfficeLocation__c").get("v.value") != null && component.find("DomesticOfficeLocation__c").get("v.value") != '') {
                console.log('test---'+component.find("DomesticOfficeLocation__c").get("v.value"));
                if(!isNaN(component.find("DomesticOfficeLocation__c").get("v.value"))) {
                    console.log('test--6-'+component.find("DomesticOfficeLocation__c").get("v.value"));
                    num += (parseInt(component.find("DomesticOfficeLocation__c").get("v.value"))*20/4);   //Top - 20%
                }
            }else{
                num += 0;
            }
            if(component.find("InternationalOfficeLocation__c") != undefined && component.find("InternationalOfficeLocation__c").get("v.value") != null && component.find("InternationalOfficeLocation__c").get("v.value") != '') {
                if(!isNaN(component.find("InternationalOfficeLocation__c").get("v.value"))) {
                    console.log('test--7-'+component.find("InternationalOfficeLocation__c").get("v.value"));
                    num += (parseInt(component.find("InternationalOfficeLocation__c").get("v.value"))*20/4);  // 20%
                }
            }else{
                num += 0;
            }
            
            if(component.find("TheLevelOfExperience__c") != undefined && component.find("TheLevelOfExperience__c").get("v.value") != null && component.find("TheLevelOfExperience__c").get("v.value") != '') {
                if(!isNaN(component.find("TheLevelOfExperience__c").get("v.value"))) {
                    console.log('test--8-'+component.find("TheLevelOfExperience__c").get("v.value"));
                    num += (parseInt(component.find("TheLevelOfExperience__c").get("v.value"))*20/4); //Top - 20%
                }
            }else{
                num += 0;
            }
            if(component.find("TheEfficiencyLevelOfFacility__c") != undefined && component.find("TheEfficiencyLevelOfFacility__c").get("v.value") != null && component.find("TheEfficiencyLevelOfFacility__c").get("v.value") != '') {
                if(!isNaN(component.find("TheEfficiencyLevelOfFacility__c").get("v.value"))) {
                    console.log('test--9-'+component.find("TheEfficiencyLevelOfFacility__c").get("v.value"));
                    num += (parseInt(component.find("TheEfficiencyLevelOfFacility__c").get("v.value"))*20/4); //Top - 20%
                }
            }else{
                num += 0;
            }
        }
        
        console.log('num -----', num);
        let percent2 = parseFloat(num).toFixed(2);
        console.log('percent2 -----', percent2);
        component.find("CommercialScoringResult__c").set("v.value", percent2); 
    },
    handleCancelCommercial : function(component, event, helper) {
        component.set('v.IsDisable',true);
        component.set("v.IsDomesticDisabled",true);
        component.set("v.IsInterDisabled",true);
    },
    handleSubmit : function(component, event, helper) {
        try
        {
            console.log('---handleSaveCommercial---');
            const fields = event.getParam('fields');
            var today = new Date();
            fields.CommercialScoringDate__c = today.toISOString();
            fields.CommercialScoringBy__c = $A.get("$SObjectType.CurrentUser.Id");
            component.find('recordEditForm').submit(fields);
            component.set('v.IsDisable',true);
            component.set('v.IsDomesticDisabled',true);
            component.set('v.IsInterDisabled',true);
        }
        catch(ex)
        {
            console.error('ex---'+ex.message);            
        }
    },
    handleSuccess: function(component, event, helper) {
        console.log('---handleSuccess--');
    }
})