({
    recordType: {
        'TOP': [
            'HedgingInitial',
            'CustomerExtend',
            'SupplierExtend',
            'CustomerEditInfo',
            'SupplierEditInfo',
            'HedgingEditInfo',
            'ShipToCheckCountry',
            'CustomerChangeCrCond',
            'SupplierChangeCrCond',
            'HedgingChangeCrCond',
            'MasterChangeAnnualReview',
        ],
        'LABIX': [
            'HedgingInitial',
            'CustomerExtend',
            'SupplierExtend',
            'CustomerEditInfo',
            'SupplierEditInfo',
            'HedgingEditInfo',
            'ShipToCheckCountry',
            'CustomerChangeCrCond',
            'SupplierChangeCrCond',
            'HedgingChangeCrCond',
            'MasterChangeAnnualReview',
        ],
        'TX': [
            'CustomerExtend',
            'SupplierExtend',
            'CustomerEditInfo',
            'SupplierEditInfo',
            'ShipToCreate',
            'ShipToEdit',
            'CustomerChangeCrCond',
            'SupplierChangeCrCond',
            'CustomerBlock',
            'SupplierBlock',
            'MasterChangeAnnualReview',
            'MasterChangeMassUpdate'
        ]
    },

    closeModal: function (component) {
        component.set('v.isModalOpen', false);
        $A.get("e.force:closeQuickAction").fire();
    },

    toastEvent: function (Title, Message, Type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": Title,
            "message": Message,
            "type": Type
        });
        toastEvent.fire();
    },

    createComponent: function(component) {
        const isTOP = component.get('v.isTOP');
        const isLABIX = component.get('v.isLABIX');
        const isTX = component.get('v.isTX');
        const selectedBU = component.get('v.selectedBU');

        const selectRecordTypeId = component.get('v.selectRecordTypeId');
        const recordTypeList = component.get('v.recordTypeList');
        const recordType = recordTypeList.find(function(recordType) {
            return recordType.mId === selectRecordTypeId;
        });
        console.log('recordType -----', recordType.mDeveloperName);
        var componentConfig;
        switch (recordType.mDeveloperName) {
            case 'CustomerExtend':
                if(isTOP || isLABIX) {
                    componentConfig = 'c:CTRExtendCustomerTOP';
                } else if(isTX) {
                    componentConfig = 'c:CTRExtendCustomerTX';
                }
                break;
            case 'SupplierExtend':
                if(isTOP || isLABIX) {
                    componentConfig = 'c:CTRExtendCustomerTOP';
                } else if(isTX) {
                    componentConfig = 'c:CTRExtendCustomerTX';
                }
                break;
            case 'CustomerEditInfo':
                componentConfig = 'c:CTRRequestFormEditType';
                break;
            case 'SupplierEditInfo':
                componentConfig = 'c:CTRRequestFormEditType';
                break;
            case 'CustomerChangeCrCond':
                componentConfig = 'c:CTRRequestChangeCreditCondition';
                break;
            case 'ShipToCreate':
                componentConfig = 'c:CTRRequestShipTo';
                break;
            case 'ShipToEdit':
                componentConfig = 'c:CTRRequestShipTo';
                break;
            case 'CustomerBlock':
                componentConfig = 'c:CTRRequestBlock';
                break;
            case 'SupplierBlock':
                componentConfig = 'c:CTRRequestBlock';
                break;
            default:
                this.toastEvent('success','Landing page In Progress development - Select RecordType page done:' + selectRecordTypeId, 'success');
		        this.closeModal(component);
                break;
        }
        if(!$A.util.isEmpty(componentConfig)) {
            console.log('componentConfig -----', componentConfig);
            this.createComponentByName(component, recordType.mName, componentConfig, { customerId: component.get('v.recordId'), recordTypeId: selectRecordTypeId, bu: selectedBU, requestType: recordType.mName });
        }
    },

    createComponentByName: function(component, title, componentName, params) {
        console.log('[createComponentByName] -----');
        const _THIS_ = this;
		$A.createComponent(
			componentName, params,
			$A.getCallback(function (newRequestComponent, status, errorMessage) {
				if (status === 'SUCCESS') {
                    const body = component.get('v.body');
					body.push(newRequestComponent);
					component.set('v.isModalOpen', false);
					component.set('v.isNewRequestModalOpen', true);
					component.set('v.newRequestModalTitle', title);
					component.set('v.newRequestModalBody', body);
                    _THIS_.newRequestComponent = newRequestComponent;
				} else if (status === 'INCOMPLETE') {
					_THIS_.toastEvent('error', errorMessage, 'error');
				} else if (status === 'ERROR') {
					_THIS_.toastEvent('error', errorMessage, 'error');
				}
			})
		);
    },

    getAllRecordTypeList: function(component) {
        component.set("v.showLoading", true);
        var action = component.get('c.getAllRecordTypeList');
		action.setParams({ 
            'recordId': component.get('v.recordId'),
            'selectedBU': component.get('v.selectedBU')
        });
		action.setCallback(this, function (res) {
			var state = res.getState();
			if (state === 'SUCCESS') {
				var result = res.getReturnValue();
				console.log(result);
				if (result) {
					if (result.mResultMessage == 'Success') {
						component.set('v.recordTypeName', result.mAccount.RecordType.DevloperName);
                        component.set('v.recordTypeList', result.mRecordTypeList);
						console.log('recordTypeList -----', component.get('v.recordTypeList'));
						component.set('v.isModalOpen', true);
					}
					else {
						this.toastEvent('Error', 'Couldn\'t get record type', 'error');
						this.closeModal(component);
					}
				}
				else {
					this.toastEvent('Error', 'Couldn\'t get record type', 'error');
					this.closeModal(component);
				}
				component.set("v.showLoading", false);
			}
		});
		$A.enqueueAction(action);
    },
})