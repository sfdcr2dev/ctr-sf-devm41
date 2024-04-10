({
	doInit: function (component, event, helper) {
		// Default values for authorization item
		component.set('v.records_authority', [{}]);
		// component.set('v.records_network', [{}])

		helper.getCaseInfo(component, event, helper);
		helper.getIsEmployee(component);
		helper.getCaseRecordTpyeInfoes(component, event, helper);
		helper.getCaseLineItemRecordTpyeInfoes(component, event, helper);
		helper.getDescribeFieldResult(component, 'Case', ['Creator_Email__c', 'User_Type__c', 'Authorization_Category__c']);
		helper.getDescribeFieldResult(component, 'OPP_Case_Line_Items__c', ['Authority_Request__c', 'Detail__c', 'Full_Name__c', 'Department__c']);
		helper.getPicklistValuesMap(component, 'Case', 'User_Type__c');
		helper.getPicklistValuesMap(component, 'Case', 'Authorization_Category__c');
		// helper.getPicklistValuesMap(component, 'OPP_Case_Line_Items__c', 'Authority_Request__c');
	},
	closeModal: function (component, event, helper) {
		event.preventDefault();
		if (component.get('v.formFactor') === 'PHONE') {
			var navService = component.find('navService');
			navService.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: '/apex/previous_back'
					}
				},
				true
			);
		} else {
			var navigateToURL = $A.get('e.force:navigateToURL');
			navigateToURL.setParams({
				isredirect: true,
				url: '/lightning/n/DG_Service'
			});
			navigateToURL.fire();
		}
	},
	handleChangeCase: function (component, event, helper) {
		var params = event.getParams();
		const { expression, index, oldValue, value } = params;
		const { Requester__c, Authorization_Category__c } = component.get('v.case');
		const pisUserType = component.get('v.pisUserType');

		if (pisUserType && Authorization_Category__c) {
			const authorType = component.get(`v.authorizationCategoryType.${Authorization_Category__c}`);
			const recordTypeDevelopName = `${pisUserType.replace('Section Head', 'SectHead').trim()}_${authorType}`;
			// console.log(
			// 	{ recordTypeDevelopName },
			// 	component.get(`v.recordTypeIdsMap.Case.${recordTypeDevelopName}.recordTypeId`),
			// 	component.get(`v.recordTypeIdsMap.OPP_Case_Line_Items__c.${recordTypeDevelopName}.recordTypeId`)
			// );
			component.set('v.case.RecordTypeId', component.get(`v.recordTypeIdsMap.Case.${recordTypeDevelopName}.recordTypeId`));
			component.set('v.caselineitemRecordType', component.get(`v.recordTypeIdsMap.OPP_Case_Line_Items__c.${recordTypeDevelopName}.recordTypeId`));
		} else if (!pisUserType) {
			component.set('v.case.RecordTypeId', null);
			component.set('v.caselineitemRecordType', null);
		}
	},
	handleRequester: function (component, event, helper) {
		var value = event.getSource().get('v.value');
		var onBehalfOf = Array.isArray(value) ? value[0] : value;
		helper.getRequesterType(component, onBehalfOf);

		if (!onBehalfOf) {
			component.set('v.case.RecordTypeId', null);
			component.set('v.caselineitemRecordType', null);
		}
	},
	handleAuthorityType: function (component, event, helper) {
		var value = event.getSource().get('v.value');
		var type = component.get(`v.authorizationCategoryType.${value}`);

		if (!type) {
			component.set('v.case.RecordTypeId', null);
			component.set('v.caselineitemRecordType', null);
		}
		component.set(
			'v.records_authority',
			component.get('v.records_authority').map((m) => {
				m.Authority_Request__c = null;
				return m;
			})
		);                
                var recordType = component.get('v.case.RecordTypeId');
                console.log('RecordTypeId >>'+recordType);
	},
	handleUploadFinished: function (component, event, helper) {
		// Get the list of uploaded files
		var uploadedFiles = event.getParam('files');
		// Get the file name
		uploadedFiles.forEach((file) => console.log(file));
		component.set('v.uploadedFiles', uploadedFiles);
	},
	handleRemoveFile: function (component, event, helper) {
		event.preventDefault();
		var index = event.getSource().get('v.name');
		if (index || index == 0) {
			component.get(`v.uploadedFiles`).splice(index, 1);
			component.set(`v.uploadedFiles`, component.get(`v.uploadedFiles`));
		}

		if (index === 0) {
			var cmpUploadFile = helper.findCmp(component, 'authorized_item', 'attachment');
			if (cmpUploadFile) cmpUploadFile.set('v.value', null);
		}
	},
	handleUploadFile: function (component, event, helper) {
		event.preventDefault();
		var target = event.getSource();
		var files = target.get('v.files');

		Promise.all(
			Array.prototype.slice.call(files).map((file) => {
				var reader = new FileReader();
				return new Promise(function (resolve, reject) {
					reader.onload = function (event) {
						// console.log(file, event.target.result)
						var base64 = event.target.result.split(',')[1];
						var fileData = {
							filename: file.name,
							type: file.type,
							base64: base64,
							recordId: ''
						};
						resolve(fileData);
					};
					reader.readAsDataURL(file);
				});
			})
		).then((result) => {
			var cmpUploadFiles = helper.findCmp(component, 'authorized_item', 'attachment');
			cmpUploadFiles.setCustomValidity('');
			cmpUploadFiles.reportValidity();

			component.set('v.uploadedFiles', component.get('v.uploadedFiles').concat(result));
		});
	},
	preventBlock: function (component, event, helper) {
		event.preventDefault();
	},
	handleAdd: function (component, event, helper) {
		var name = event.getSource().get('v.name');
		component.set(`v.records_${name}`, [...component.get(`v.records_${name}`), {}]);
	},
	handleRemove: function (component, event, helper) {
		var name = event.target.dataset.name;
		var index = event.target.dataset.index;
		if (name && component.get(`v.records_${name}.length`) > 1) {
			component.get(`v.records_${name}`).splice(index, 1);
			component.set(`v.records_${name}`, component.get(`v.records_${name}`));
		}
	},
	handleAutoApproval: function (component, event, helper) {
		component.set('v.autoApproval', true);
		component.find('utilityLwcButton').submit_click();
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		var isValid = true;
		var fields = event.getParam('fields');
		fields.Auto_Submit__c = component.get('v.autoApproval');
		component.set('v.autoApproval', false);
		// delete fields.Authority_Request__c
		// delete fields.Department__c

		var authorized_item = component.find('authorized_item');
		if (authorized_item) {
			authorized_item = Array.isArray(authorized_item) ? authorized_item : [authorized_item];
			authorized_item.reduce((isValid, item) => {
				item.showHelpMessageIfInvalid();
				item.focus();
				return isValid && item.checkValidity();
			}, isValid);
		}

		// Upload files valdiate
		var cmpUploadFiles = helper.findCmp(component, 'authorized_item', 'attachment');
		if (cmpUploadFiles) {
			if (!cmpUploadFiles.get('v.value')) {
				cmpUploadFiles.setCustomValidity('Complete this field.');
			} else {
				cmpUploadFiles.setCustomValidity('');
			}
		}

		isValid = isValid && (cmpUploadFiles ? cmpUploadFiles.get('v.value') : true);
		if (!isValid) return;

		component.set('v.isLoading', true);
		component.find('recordEditForm').submit(fields);
	},
	handleSuccess: function (component, event, helper) {
		helper.uploadFile(component, event, helper);
		helper.createCaseLineItem(component, event, helper);
		// component.set("v.isLoading", false)
	},
	handleError: function (component, event, helper) {
		component.set('v.isLoading', false);
	}
});