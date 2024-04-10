({
	/**
     * Initialize Function used to Fetch the value as soon as the component is started.
     * connect apex controller and call method named fetchUser
     */
	doInit: function (component, event, helper) {
		// if (component.get('v.isRedirectPage')) {
			var action = component.get("c.fetchUser");
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var storeResponse = response.getReturnValue();
					console.log('storeResponse.Name=>',storeResponse.Id);
					component.set("v.formData.RiskInitiator__c", storeResponse.Id);
				}
			});
			$A.enqueueAction(action);

			component.set('v.formData', {
				RiskStatus__c: 'New',
				InitiativeDate__c: $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD')
			});

			helper
				.getPISUserDefault(component, event, helper)
				.then(function (value) {
                    console.log('--doInit-- in helper');
					let formData = component.get('v.formData');
					component.set('v.formData', formData);
				})
				.catch(function (error) {
					console.log(error);
				})
		// }
	},

    /** Event Handler for Get Risk Initiator value from user input */
	handlePISUser: function (component, event, helper) {
		var PISUserId = component.get('v.formData.RiskInitiator__c'); // function PISUserId
		PISUserId = Array.isArray(PISUserId) ? PISUserId[0] : PISUserId;
	},

    /** Set value to display when other value changed */
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.formData.${params.fieldName}`, params.value);

		if (params.fieldName === 'RiskInitiator__c') {
			$A.enqueueAction(component.get('c.handlePISUser'));
		}
	},

    /** Get value from Query related field */
	handleFunctionLocationForTAGNo: function (component, event, helper) {
		var funcLocationId = event.getSource().get('v.value'); // function location id
		funcLocationId = Array.isArray(funcLocationId) ? funcLocationId[0] : funcLocationId;
		helper.getFunctionLocationDetail(component, funcLocationId);
        component.set('v.isFillTagNo',true)
	},

	/** Get value from Query related field */
	handleFunctionLocation: function (component, event, helper) {
		var funcLocationId = event.getSource().get('v.value'); // function location id
		funcLocationId = Array.isArray(funcLocationId) ? funcLocationId[0] : funcLocationId;
		helper.getFunctionLocationDetail(component, funcLocationId);
		component.set('v.isFillTagNo',true)
	},

	/** Get value ConsEff,if is 'Other' then enable inputfield */
	handleConsEff: function (component, event, helper) {
		var consEff = event.getSource().get('v.value');
		console.log('consEff =>',consEff);
		if(consEff == 'Other'){
			component.set('v.otherConsEffect',false);
		}else{
			component.set('v.otherConsEffect',true);
		}
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

	/** Set isModalOpen attribute is true when click 'Preview RAM Matrix' button */
	openModel: function(component, event, helper) {
		component.set("v.isModalOpen", true);
	},

	/** Set isModalOpen attribute is false when click close modal icon */
	closeModel: function(component, event, helper) {
		component.set("v.isModalOpen", false);
	},

	/** Navigate or Redirect to previous back page and clear value all in form */
	redirectBack: function (component, event, helper) {

		//reset form
		helper.clearValueForm(component, event, helper);

		//refresh view
		// $A.get('e.force:refreshView').fire();

		//navigate to page
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: '/apex/previous_back'
				}
			},
			true
		);
	},

    /** Set attributes after click save form and call  submit_click to save form */
	onClickSubmit: function (component, event, helper) {
		console.log('--Clicked Save Btn--');
		component.set('v.pressSave',true);
		component.set('v.pressSaveandNew',false);
		component.set('v.pressKey', {
			enter: false,
			click: true
		});
		helper.debounce('onClickSubmit', $A.getCallback(function () {
			component.find('utilityLwcButton').submit_click();
			console.log('v.pressSave=>',component.get('v.pressSave'));
		}), 1000).apply(this);
	},

    /** Set attributes after click save&new form and call  submit_click to save form */
    onClickSubmitAndNew: function (component, event, helper) {
		console.log('--Clicked Save & New Btn--');
		component.set('v.pressSaveandNew',true);
		component.set('v.pressSave',false);
		component.set('v.pressKey', {
			enter: false,
			click: true
		});
		helper.debounce('onClickSubmit', $A.getCallback(function () {
			component.find('utilityLwcButton').submit_click();
			console.log('v.pressSaveandNew=>',component.get('v.pressSaveandNew'));
        }), 1000).apply(this);
	},

    /** Show loading when form are recordingv*/
	handleLoad: function (component, event, helper) {
		helper.stopLoading(component);
		console.log('--handle loading--');
		var recordUi = event.getParam('recordUi');
		const {
			objectInfo: { fields }
		} = recordUi;
		component.set('v.objectInfoFields', fields);
	},

    /**
	 * Save all value in form after user click Save/Save&New Button
	 * pass Tag Number child list to apex for make new record
	 * after save all, show message popup and clear value in form
	 * redirect to detail record page depend on button clicked
	 */
	handleSubmit: function (component, event, helper) {
		event.preventDefault();

		console.log('--Save Value from InputField--');
		var fields = event.getParam('fields');
		fields.TagNo__c = component.get('v.formData.TagNo__c');

		var loop = JSON.parse(JSON.stringify((component.get('v.loop'))));
		console.log('loop=>',loop);

		let list = [];
		for (let i = 0; i < loop.length; i++) {
			if(loop[i].tagNo != null && loop[i].tagNo != ''){
				list.push(loop[i].tagNo);
			}
			// list.push(loop[i].tagNo);
		}
		console.log('list=>',list);

		setTimeout(
			$A.getCallback(() => {
					helper.startLoading(component);
					var action = component.get('c.createRisk');
					//var action = component.get('c.createRisk3');
					console.log('fields.TagNo__c=>',fields.TagNo__c);

					(String(fields.IntConsEffect__c).toLowerCase() != 'other') && (fields.IniOtherConsEff__c = '');
                	(String(fields.DEM__c).toLowerCase() != 'yes') && (fields.DEMNo__c = '');

                    action.setParams({
                		risk : fields,
						tagNoList : list
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === 'SUCCESS') {
                            var result = response.getReturnValue();
                            component.set('v.formData.Name',result.Name);

							helper.handleSuccessToast(component, event, helper);
							helper.clearValueForm(component, event, helper);
							if(component.get('v.pressSave')){
								/**SaveBtn */
								helper.handleNavigateToRecordPage(component, event, helper,result.Id);
							}
							else if(component.get('v.pressSaveandNew')){
								/**Save&NewBtn */
								helper.handleNavigateToCreateRiskPage(component, event, helper);
							}
                        }
						else {
							let errors = response.getError();
							console.error(errors);
						}
                    });
            		$A.enqueueAction(action);
			}),
			150
		);
	},

    /** Event Handler for Navigate or Redirect to all risk list view page when risk created */
	handleSuccess: function (component, event, helper) {
		var params = event.getParams();
		const {
			response: { id }
		} = params;

		if (id) {
			new Promise(
				$A.getCallback((resolve, reject) => {
					if (component.get('v.formFactor') === 'DESKTOP') {
						resolve();
					}

					component.set('v.isToggleModal', !component.get('v.isToggleModal'));
					setTimeout(
						$A.getCallback(() => {
							resolve();
						}),
						300
					);
				})
			).then(() => {
                //reset
                helper.handleSuccessToast(component, event, helper);
				var navService = component.find('navService');
				navService.navigate(
                    {
						type: 'standard__recordPage',
						attributes: {
							actionName    : 'view',
                            objectApiName : 'ORTLRisk__c',
                            recordId      : id
						},
						state: {
							c__recordId: id
						}
					},
					true
				);

			});
        }
        else {
			// todos something...
			helper.stopLoading(component);
		}
	} ,

    /**Show message popup and stop loading when error */
	handleError: function (component, event, helper) {
		var error = event.getParams();
		console.error(helper.parseObject(error));
		if (error.error.body.errorCode == 'INSUFFICIENT_ACCESS') {
			component.find('notifLib').showToast({
				"variant":"error",
				"title": "Error",
				"message": $A.get("$Label.c.ORTLRskCrUnAuthEr")

			});
		} else {
			helper.handleErrorToast(component, event, helper);
		}
		helper.stopLoading(component);
	},

    /** Event Handler Touch Move*/
	handleTouchMove: function (component, event, helper) {
		event.stopPropagation();
	},

    /** Add Input to form when user clicked plus button */
    handleAddInputBox: function(component, event, helper){
		console.log('--Clicked Add Tag No. InputFiled--');
		console.log('loop before push=>',component.get('v.loop'));
        let loop = component.get('v.loop');
        loop.push({tagNo: ''})
        component.set('v.loop',loop);
		component.set('v.isSelectedAddBox',true)
		component.set('v.lastestIndex',component.get('v.lastestIndex')+1);
		console.log('lastestIndex after push=>',component.get('v.lastestIndex'));
		console.log('loop after push=>',loop);
    },

    /** Remove Input out from form when user clicked plus button */
    handleRemoveInputBox: function(component, event, helper){
		console.log('--Clicked Delete Tag No. InputFiled--');
		let index = event.getSource().get('v.value');
        let loop = component.get('v.loop');
        loop.splice(index, 1);
		component.set('v.lastestIndex',component.get('v.lastestIndex')-1);
		console.log('lastestIndex after remove=>',component.get('v.lastestIndex'));
        component.set('v.loop',loop);
    },

    /** Get value from check box for condition check */
    onCheck: function(component, event, helper) {
        // console.log('--Checkbox clicked--');

        // var cmpSource = event.getSource();
        // console.log('cmpSource',cmpSource,' and applicable >',component.get('v.formData.ApptootherEQP__c'));
        // component.set('v.formData.ApptootherEQP__c',!component.get('v.formData.ApptootherEQP__c'));
        // component.set('v.isSelectedCheckbox',component.get('v.formData.ApptootherEQP__c'));
		// console.log('v.formData.ApptootherEQP__c=>',component.get('v.formData.ApptootherEQP__c'));

        // $A.util.toggleClass(cmpSource, "done");
		let cmp = event.getSource();
		component.set('v.formData.ApptootherEQP__c',cmp.get('v.checked'));
		component.set('v.isSelectedCheckbox',cmp.get('v.checked'));

    },

});