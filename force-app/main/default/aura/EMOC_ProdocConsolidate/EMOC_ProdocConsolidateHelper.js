({
	getOptions : function(component) {
        component.set('v.isLoaded', false);
        var action = component.get('c.getOptions');
        action.setParams({
            'recordId': component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                component.set('v.options', response.getReturnValue());
                console.log('options -----', component.get('v.options'));
            }
            component.set('v.isLoaded', true);
        });
		$A.enqueueAction(action);
	},
    retrieveData : function(component) {
        component.set('v.isRetrieving', true);
        component.set('v.showTable', false);
        var action = component.get('c.retrieveData');
        action.setParams({
            'selectedOption': component.get('v.selectedOption'),
            'recordId': component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') { 
                var response = response.getReturnValue();
                console.log('response -----', response);
                var data = response.data;
                var columns = response.columns;
                component.set('v.data', data);
                component.set('v.columns', columns);
            }
            component.set('v.isRetrieving', false);
            component.set('v.showTable', true);
        });
		$A.enqueueAction(action);
    },
    validateData : function(component) {
        component.set('v.isRetrieving', true);
        var allowToConsolidate = true;
        var checkListTypeList = [];
        var selectedRows = component.get('v.selectedRows');
        if(selectedRows) {
            for(var i=0; i<selectedRows.length; i++) {
                console.log('selectedRows[' + i + '] -----', selectedRows[i]);
                checkListTypeList.push(!$A.util.isEmpty(selectedRows[i].E_MOC_Checklist_type__c) ? selectedRows[i].E_MOC_Checklist_type__c : 'BLANK');
            }
            let uniqueCheckListTypeList = [...new Set(checkListTypeList)];
            console.log('uniqueCheckListTypeList -----' + uniqueCheckListTypeList);
            if(uniqueCheckListTypeList.length > 1) allowToConsolidate = false;
            if(!allowToConsolidate) this.showToast(component, 'Warning', 'Multiple Checklist types are not allowed.', 'warning');
        } else allowToConsolidate = false;
        
        component.set('v.allowToConsolidate', allowToConsolidate);
        component.set('v.isRetrieving', false);
    },
    prepareToConsolidate : function(component) {
        component.set('v.isRetrieving', true);
        component.set('v.showErrorTable', false);
        var action = component.get('c.prepareToConsolidate');
        action.setParams({
            'selectedData': JSON.stringify(component.get('v.selectedRows')),
            'recordId': component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') { 
                var response = response.getReturnValue();
                console.log('response -----', response);
                if(response.isCalloutSuccess) {
                    if(!$A.util.isEmpty(response.ListErrorFile)) {
                        component.set('v.errorColumns', response.ListErrorColumn);
                        component.set('v.errorData', response.ListErrorFile);
                        component.set('v.statusMsg', response.StatusMsg);
                        component.set('v.showErrorTable', true);
                    } else {
                        this.showToast(component, 'Success', response.StatusMsg, 'success');
                        $A.get('e.force:closeQuickAction').fire();
                    }
                } else {
                    this.showToast(component, 'Warning', response.StatusMsg, 'warning');
                }
            } else if(state === 'ERROR') {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        this.showToast(component, 'Error', errors[0].message, 'error');
                    }
                }
            }
            component.set('v.isRetrieving', false);
        });
		$A.enqueueAction(action);
    },
    showToast : function(component, title, message, type) {
        var toastEvt = $A.get('e.force:showToast');
        toastEvt.setParams({
            'title': title,
            'message': message,
            'type': type
        });
        toastEvt.fire();
    },
})