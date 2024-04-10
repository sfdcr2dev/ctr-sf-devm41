({
	retrieveRelated: function (component) {
		let idRecievedByURLParameter = component.get('v.pageReference').state.c__notificationId;
		component.set('v.notificationId', idRecievedByURLParameter);
		let action = component.get('c.getRelatedObjects');
		action.setParams({
			notificationIdentifier: component.get('v.notificationId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnValue = response.getReturnValue();
				// console.log(returnValue);
				try {
					component.set('v.hasEditAccess', returnValue.hasEditAccess || false);
					component.set(
						'v.filesRelated',
						returnValue.files.map((file) => {
							let found = returnValue.notification_files.find((f) => f.File_Id__c === file.document.ContentDocumentId);
							let isMoreFiveMinutes =
								Date.now() >= new Date(new Date(found.LastModifiedDate).getTime() + 5 * 60000).getTime();
							file.Integration_Status__c = found ? found.Integration_Status__c : 'Failed';
							file.Integration_Status__c =
								isMoreFiveMinutes && file.Integration_Status__c == 'In Progress'
									? 'Failed'
									: file.Integration_Status__c;
							file.isLoading = false;
							file.CreatedDate = new Date(found.LastModifiedDate);
							file.isCanResend = file.Integration_Status__c != 'Success' && isMoreFiveMinutes;
							return file;
						})
					);
					// console.log(JSON.parse(JSON.stringify(component.get('v.filesRelated'))));
				} catch (error) {
					console.log(JSON.parse(JSON.stringify(returnValue)));
					console.error(error);
				}
			} else if (state === 'ERROR') {
				let errors = response.getError();

				console.error(JSON.parse(JSON.stringify(errors)));
			}
			component.set('v.isLoading', false);
			if (!component.get('v.finishedLoading')) {
				component.set('v.finishedLoading', true);
			}
		});

		if (component.get('v.filesRelated.length')) {
			component.set(
				'v.filesRelated',
				component.get('v.filesRelated').map((m) => {
					if (m.Integration_Status__c === 'In Progress') m.isLoading = true;
					return m;
				})
			);
		}
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},
	calloutNotiFile: function (component, params) {
		var helper = this;
		const { attactmentId, flag } = params;
		var action = component.get('c.resendIntegrationNotificationFile');
		action.setParams({
			fileId: attactmentId,
			flag
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'ERROR') {
				const errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});
		if (component.get('v.hasEditAccess')) $A.enqueueAction(action);

		setTimeout(
			$A.getCallback(() => {
				// helper.retrieveRelated(component);
				helper.handleSetInterval(component);
			}),
			5000
		);
	},
	handleSetInterval: function (component) {
		var helper = this;

		if (!component.get('v.interval')) {
			component.set(
				'v.interval',
				setInterval(
					$A.getCallback(() => {
						if (
							component.get('v.filesRelated') &&
							component
								.get('v.filesRelated')
								.some((s) => s.Integration_Status__c && s.Integration_Status__c == 'In Progress')
						) {
							helper.retrieveRelated(component);
						} else if (component.get('v.interval')) {
							console.warn('clearInterval');
							clearInterval(component.get('v.interval'));
							component.set('v.interval', null);
						}
					}),
					5000
				)
			);
		}
	}
});