({
	doInit: function (component, event, helper) {
		helper.checkWriteAccess(component);
	},

	uploadFile: function (component, event, helper) {
		var upload = component.find('uploadModal');
		$A.util.removeClass(upload, 'hide-me');
	},

	handleUploadFinished: function (component, event, helper) {
		// https://sfdclesson.com/2019/06/23/%E2%9A%A1-lightning-file-upload-with-a-title-using-lightningfileupload/
		var uploadedFiles = event.getParam('files');
    	// alert(uploadedFiles.length);
		var documentId = uploadedFiles[0].documentId;
		var fileName = uploadedFiles[0].name;
		fileName = fileName.substring(0, fileName.lastIndexOf('.'));
		console.log(uploadedFiles[0], fileName);

		component.set('v.originalFileName', fileName);

		// set the file name input field before we show the modal
		component.find('changeNameInput').set('v.value', fileName);

		// set the attribute to the document we want to do stuff with
		// so we can get it and use the Id in other fucntions
		component.set('v.currentUploadedDocumentId', documentId);

		// find the file name modal and show it
		var changeNameModal = component.find('changeNameModal');

		$A.util.removeClass(changeNameModal, 'hide-me');
	},

	submitName: function (component, event, helper) {
		console.log('Submit clicked.');
		var target = event.target;
		var isClickCloseBtn = Array.isArray(target.classList) ? target.classList.includes('close-button') : false;

		// get the values we need to pass to apex
		var newFileName = isClickCloseBtn
			? component.get('v.originalFileName')
			: component.find('changeNameInput').get('v.value');
		var documentId = component.get('v.currentUploadedDocumentId');
		component.find('submitName').getElement().disabled = true;

		// send to helper to make the apex calls
		helper.updateDocument(component, documentId, newFileName);
	},

	closeModal: function (component, event, helper) {
		var upload = component.find('uploadModal');
		$A.util.addClass(upload, 'hide-me');
	},

	closeFileNameModal: function (component, event, helper) {
		var nameChange = component.find('changeNameModal');
		$A.util.addClass(nameChange, 'hide-me');
	},

	redirectBack: function (component, event, helper) {
		var navService = component.find('navLink');
		navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: '/apex/previous_back'
				}
			},
			true
		);
	},
	navigateBack: function (component, event, helper) {
		var pageRef = component.get('v.pageReference');
		let navLink = component.find('navLink');

		pageRef = {
			type: 'standard__component',
			attributes: {
				componentName: 'c__THOR_NotificationRecordDisplay'
			},
			state: {
				c__recordId: component.get('v.notificationId')
			}
		};
		navLink.navigate(pageRef, true);
	}
});