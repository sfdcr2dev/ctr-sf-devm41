({
	handleSetTimeout: function (component) {
		var timeout = window.setTimeout(
			$A.getCallback(() => {
				console.warn('Timeout');
				if (
					component.get('v.notificationRecord.Integration_Status__c') === 'In Progress' &&
					component.find('recordTimeoutForm')
				) {
					component.find('recordTimeoutForm').submit();
				}
			}),
			60 * 1000
		);
		component.set('v.timeout', timeout);
	},
	handleSetInterval: function (component) {
		var intervalGetInfo = window.setInterval(
			$A.getCallback(() => {
				if (
					component.find('recordLoader') &&
					component.get('v.notificationRecord.Integration_Status__c') &&
					component.get('v.notificationRecord.Integration_Status__c') === 'In Progress'
				) {
					component.find('recordLoader').reloadRecord(true);
				} else if (
					component.get('v.interval') &&
					component.find('recordLoader') &&
					component.get('v.notificationRecord.Integration_Status__c') !== 'In Progress'
				) {
					console.warn('clearInterval');
					window.clearInterval(component.get('v.interval'));
					component.set('v.interval', null);
					window.clearTimeout(component.get('v.timeout'));
					component.set('v.timeout', null);
				}
			}),
			5000
		);
		component.set('v.interval', intervalGetInfo);
	},
	truncHistoryDetail: function (component) {
		let notificationRecord = component.get('v.notificationRecord');
		if (notificationRecord) {
			let historyDetail = notificationRecord.History_Detail__c;
			let userStatus = notificationRecord.User_Status__c;
			let type = notificationRecord.Type__c;

			component.set('v.historyDetail', historyDetail);
			component.set('v.userStatus', userStatus);
			component.set('v.type', type);

			if (historyDetail) {
				historyDetail = historyDetail.replace(/\n/g, '<br />');
			}

			component.set('v.allText', historyDetail);

			if (historyDetail && historyDetail.length > 200) {
				let truncatedText = historyDetail.slice(0, 200);
				component.set('v.showViewMore', true);
				component.set('v.showViewLess', true);
				component.set('v.truncatedText', truncatedText);
			}
		}
	}
});