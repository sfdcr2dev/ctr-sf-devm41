({
    /**
     * Initialize Function used to Fetch the value as soon as the component is started.
     * get value record detail and set default value to attribute after component render.
     */
    doInit: function (component, event, helper) {
        let pageref = component.get('v.pageReference');
        if (pageref && !component.get('v.recordId')) {
            let { c__recordId } = pageref.state;
            component.set('v.recordId', c__recordId);
        }

        if (component.get('v.isLoaded')) {
            $A.get('e.force:refreshView').fire();
            component.set('v.isLoaded', false);
        }

        component.set('v.loop', [{ 'tagNo': '' }]);

        helper.canEditRisk(component, event, helper);
    },

    /**
     * handler to get each value to display.
     * this function recieve value from call helper function and set to form to display.
     */
    handleLoad: function (component, event, helper) {
        if (!component.get('v.isLoaded')) {
            let recordUi = event.getParam('recordUi');
            helper.getFunctionLocationDetail(component, event, helper, recordUi.record.fields.TagNo__c.value);
            helper.getRelatedRisk(component, event, helper);
            helper.canEditOwner(component, event, helper);

            [
                'TagNo__c',
                'Name',
                'RiskStatus__c',
                'InitiativeDate__c',
                'OwnerId',
                'RiskInitiator__c',
                'OriginalRisk__c',
                'AssessmentType__c',
                'IntRiskCons__c',
                'Threat__c',
                'IntConsEffect__c',
                'RiskScenario__c',
                'RiskScenarioDes__c',
                'EnRiskMgt__c',
                'DEM__c',
                'DEMNo__c',
                'ApptootherEQP__c',
                'Causeoffailure__c',
            ].forEach((fieldName) => {
                component.set(`v.formData.${fieldName}`, recordUi.record.fields[fieldName].value);
            });
            component.set('v.formData.Id', component.get('v.recordId'));
            component.set('v.formData.RiskInitiator__c', (component.get('v.formData.RiskInitiator__c')) ? component.get('v.formData.RiskInitiator__c') : component.get('v.formData.OwnerId'));

            let ApptootherEQP__c = component.get('v.formData.ApptootherEQP__c');
            component.set('v.isSelectedCheckbox', ApptootherEQP__c);
            component.set('v.formData.canEditApptootherEQP__c', !Boolean(ApptootherEQP__c));
        }
        component.set('v.isLoaded', true);
    },

    /**
     * handler save action in save button
     * used to connect apex controller to save or update record to database
     * response after updated, will show message popup and navigate/redirect to record page
     */
    handleSubmit: function (component, event, helper) {
        event.preventDefault();

        let risk = component.get('v.formData');
        let loop = component.get('v.loop');
        let list = [];
        for (let i = 0; i < loop.length; i++) {
            if (loop[i].tagNo != null && loop[i].tagNo != '') {
                list.push(loop[i].tagNo);
            }
        }

        /**connect apex controller */
        setTimeout(
            $A.getCallback(() => {
                var action = component.get('c.updateRisk');

                (String(risk.IntConsEffect__c).toLowerCase() != 'other') && (risk.IniOtherConsEff__c = '');
                (String(risk.DEM__c).toLowerCase() != 'yes') && (risk.DEMNo__c = '');

                action.setParams({
                    risk: risk,
                    tagNoList: list
                });
                action.setCallback(this, function (response) {
                    component.set('v.isLoading', false);

                    var state = response.getState();
                    if (state === 'SUCCESS') {
                        helper.handleSuccessToast(component, event, helper);
                        helper.navigateToPage(component, event, helper)
                    }
                });
                $A.enqueueAction(action);
            }),
            150
        );
    },

    /**
     * handler change event of Consequence Effect
     * check require field on IniOtherConsEff__c.
     */
    handleChangeConsequenceEffect: function (component, event, helper) {
        let cmpIniOtherConsEff__c = component.find('IniOtherConsEff__c');
        setTimeout(function(){
            cmpIniOtherConsEff__c.reportValidity();
        }, 100);
    },

    /**
     * handler change event of Consequence Effect
     * check require field on DEMNo__c.
     */
    handleChangeDEM: function (component, event, helper) {
        let cmpDEMNo__c = component.find('DEMNo__c');
        setTimeout(function(){
            cmpDEMNo__c.reportValidity();
        }, 100);
    },

    /**
     * handler to get each value to display.
     * this function recieve value from call helper function and set to form to display.
     */
    handleFunctionLocation: function (component, event, helper) {
        let funcLocationId = event.getSource().get('v.value'); // function location id
        funcLocationId = Array.isArray(funcLocationId) ? funcLocationId[0] : funcLocationId;
        helper.getFunctionLocationDetail(component, event, helper, funcLocationId);
        component.set('v.isFillTagNo', true);
        //component.set('v.isFillTagNo', !$A.util.isEmpty(funcLocationId));
    },

    /** Add Input to form when user clicked plus button */
    handleAddInputBox: function (component, event, helper) {
        let loop = component.get('v.loop');
        loop.push({ tagNo: '' })
        component.set('v.loop', loop);
    },

    /** Remove Input out form when user clicked plus button */
    handleRemoveInputBox: function (component, event, helper) {
        let index = event.getSource().get('v.value');
        let loop = component.get('v.loop');
        loop.splice(index, 1);
        component.set('v.loop', loop);
    },


    /** Get value from checkbox that is user's input */
    onCheck: function (component, event, helper) {
        //component.set('v.formData.ApptootherEQP__c', !component.get('v.formData.ApptootherEQP__c'));
        //component.set('v.isSelectedCheckbox', component.get('v.formData.ApptootherEQP__c'));

        if (component.get('v.formData.canEditApptootherEQP__c')) {
            let cmp = event.getSource();
            //component.set('v.formData.ApptootherEQP__c',cmp.get('v.checked'));
            component.set('v.isSelectedCheckbox', !cmp.get('v.checked'));
        }
    },

    /** Set value to default attribute*/
    openModel: function (component, event, helper) {
        component.set("v.isModalOpen", true);
    },

    /** Set value to default attribute*/
    closeModel: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },

    /** Action after user click sace button, save and update record */
    onClickSubmit: function (component, event, helper) {
        component.set('v.isLoading', true);
        helper.debounce('onClickSubmit', $A.getCallback(function () {
            component.find('utilityLwcButton').submit_click();
        }), 1000).apply(this);
    },

    /** For navigate to specific page after call this function*/
    redirectBack: function (component, event, helper) {
        helper.navigateToPage(component);
    },
})