({
	/** This fuction used to parse object*/
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},

	/**This fuction used to set isLoading attribue*/
	startLoading: function (component) {
		component.set('v.isLoading', true);
	},

	/** This fuction used to set isLoading attribue*/
	stopLoading: function (component) {
		component.set('v.isLoading', false);
	},

	// Debounce function to prevent double sumitting.
    debounce: function (funcname, func, wait) {
        let DEBOUNCE = this.debounce;
        return $A.getCallback(function () {
            if (!DEBOUNCE.timer) {
                DEBOUNCE.timer = {};
            }

            let context = this;
            let args = arguments;
            clearTimeout(DEBOUNCE.timer[funcname]);
            DEBOUNCE.timer[funcname] = setTimeout(function () {
                //DEBOUNCE.timer[funcname] = null;
                func.apply(context, args);
            }, wait);
        });
    },

	/**
	 * Get value related from TagNo. Field
	 * pass value to fields related with TagNo
	 */
	getFunctionLocationDetail: function (component, funcLocationId) {
		console.log('--Helper getFunctionLocationDetail--');
		var action = component.get('c.getFunctionLocationDetail');
		action.setParams({
			funcLocationId: funcLocationId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				console.log('result=>',result);
				component.set('v.apu', result.APU__c);
				component.set('v.unit', result.Unit__c);
				component.set('v.plantsection', result.PlantSection__c);
				component.set('v.discipline', result.Discipline__c);
				component.set('v.planningplant', result.Planning_Plant_Text__c);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (funcLocationId) $A.enqueueAction(action);
		else {
			component.set('v.APU__c', null);
			component.set('v.formData.Main_Work_Center__c', null);
			component.set('v.formData.mainWorkCenterPlant__c', null);
		}
	},

	/** Default User log in as to display in new risk's form */
	getPISUserDefault: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
			let action = component.get('c.getPISUserDefault');
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					resolve(response.getReturnValue());
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(action);
		});
	},

	/** Default User log in as to display in new risk's form */
	getUserInfo: function (component, event, helper) {
        let action = component.get('c.getUserInfo');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let results = response.getReturnValue();
                    component.set('v.formData.RiskInitiator__c', results);
                    console.log('UserInfo=>', component.get('v.formData.RiskInitiator__c'));
            }
			else {
                let errors = response.getError();
                console.error(errors);
            }
        });
        //$A.enqueueAction(action);
    },

	/**
	 * Call Method to set new record with data from form
	 * and set risk's name
	 */
	getAddNewRisk: function (component, event, helper) {
		var action = component.get('c.getAddNewRisk');
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.formData.Name',result);
			}else {
                let errors = response.getError();
                console.error(errors);
            }
		});
	},

	/**
	 * Show message after created redcord success
	 * Risk "(Risk's Name)" was created.
	 */
	handleSuccessToast : function(component, event, helper) {
		console.log('Inside Handle Toast');
        var dynamicLabel = $A.get("$Label.c.ORTLRskCreatedSc");
        console.log('dynamicLabel=>',dynamicLabel);
		let riskName = component.get('v.formData.Name');
		component.find('notifLib').showToast({
			"variant":"success",
			//"title": "Risk \" "+riskName+" \" was created.",
			//"The record has been created successfully.",
            "title": String($A.get("$Label.c.ORTLRskCreatedHSc")).replace(/{!\s*ORTLRisk__c.Name\s*}/, riskName),
			"message": $A.get("$Label.c.ORTLRskCreatedSc"),

		});
	},

	/** Show message popup after created redcord error */
	handleErrorToast : function(component, event, helper) {
		console.log('Inside Handle Toast');
		let riskName = component.get('v.formData.Name');
		component.find('notifLib').showToast({
			"variant":"error",
			"title": "Risk \" "+riskName+" \" was not created.",
			//"message": "The record not created."
			"message": $A.get("$Label.c.ORTLRskCreatedEr")

		});
	},

	/** Navigate or redirect to Risk's all list view page */
	handleNavigateToRecordPage : function(component, event, helper, id){
		//$A.get('e.force:refreshView').fire();
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
	},

	/** Navigate or redirect to New Risk page */
	handleNavigateToCreateRiskPage : function(component, event, helper){
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__ORTLCreateRiskPage'
				}
			},
			true
		);
	},

	/** Clear value in form to empty and set attribute to default when method called */
	clearValueForm : function(component, event, helper){
		console.log('--Clear Values in Form--');
		var action = component.get("c.fetchUser");
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var storeResponse = response.getReturnValue();
					console.log('storeResponse.Name=>',storeResponse.Id);
					component.set("v.formData.RiskInitiator__c", storeResponse.Id);
					//component.set("v.formData.OwnerId", storeResponse.Id);
				}
				else {
					let errors = response.getError();
					console.error(errors);
				}
			});
			$A.enqueueAction(action);
		// reset each field
		component.set('v.formData.TagNo__c',"");
		component.set('v.formData.Name',"");
		component.set('v.apu',"");
		component.set('v.unit',"");
		component.set('v.plantsection',"");
		component.set('v.formData.AssessmentType__c',"");
		component.set('v.formData.ParentRisk__c',"");
		component.set('v.formData.OriginalRisk__c',"");
		component.set('v.formData.Threat__c',"");
		component.set('v.formData.IntConsEffect__c',"");
		component.set('v.formData.RiskScenario__c',"");
		component.set('v.formData.RiskScenarioDes__c',"");
		component.set('v.formData.EnRiskMgt__c', 'No');
		component.set('v.formData.DEM__c','No');
		component.set('v.formData.Causeoffailure__c',"");
		component.set('v.formData.IntRiskCons__c',"");
		component.set('v.formData.IniOtherConsEff__c',"");
		component.set('v.formData.DEMNo__c',"");

		//reset loop empty array
		component.set('v.otherConsEffect',true);
		component.set('v.isFillTagNo',false);
        component.set('v.loop',[{'tagNo':''}]);
		component.set('v.formData.ApptootherEQP__c',false);
		component.set('v.isSelectedCheckbox',false);
		component.set('v.isLoading', false);
		component.set('v.lastestIndex',0);
		console.log('resetValueForm loop',component.get('v.loop'));
		console.log('ApptootherEQP__c',component.get('v.formData.ApptootherEQP__c'));
		//clear properties Applicable to other equ
		component.find('checkbox').set('v.checked',false);
	},

	/** Clear value in form to empty and set attribute to default when method called */
	resetValueForm : function(component, event, helper){
		component.find('inputField').forEach(function(f) {
             f.reset();
        });

		//reset loop empty array
        component.set('v.loop',[{'tagNo':''}]);
		component.set('v.formData.ApptootherEQP__c',false);
		component.set('v.isSelectedCheckbox',false);
		console.log('resetValueForm loop',component.get('v.loop'));
	},

});