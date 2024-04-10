({
	retrieveRelated: function (component) {
		//let idRecievedByURLParameter = component.get('v.pageReference').state.c__recordId;
		//console.log('v.pageReference >>>>>',idRecievedByURLParameter);
		//component.set('v.recordId', idRecievedByURLParameter);
		let action = component.get('c.getRelatedObjects');
		action.setParams({
			recordIdentifier: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnValue = response.getReturnValue();
				// console.log(returnValue);
				try {
					//component.set('v.hasEditAccess', returnValue.hasEditAccess || false);
					component.set(
						'v.filesRelated',returnValue.files);
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
    
    retrieveHeaderId: function (component) {
		
		let action = component.get('c.getPTWHeader');
		action.setParams({
			wcId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                
				component.set('v.headerId', returnValue);
				
			} else if (state === 'ERROR') {
				let errors = response.getError();

				console.error(JSON.parse(JSON.stringify(errors)));
			}
			
		});

		$A.enqueueAction(action);
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