({
	doInit: function (component, event, helper) {
		try {
			window.setTimeout(
				$A.getCallback(function () {
					component.find('inputField').forEach((e) => {
						if (component.get(`v.form.${e.get('v.fieldName')}`)) {
							e.set('v.value', component.get(`v.form.${e.get('v.fieldName')}`));
						}
					});
				}), 1000);
		} catch (e) {
			console.error(e);
		}
	},
	getFields: function (component, event, helper) {
		return component.find('inputField').reduce((acc, e) => {
			acc.push(e.get('v.fieldName'));
			return acc;
		}, []);
	},
	reset: function (component, event, helper) {
		component.find('inputField').forEach((cmp) => cmp.set('v.value', null));
	},
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);

		if (params.fieldName == 'Area__c') {
			let plantSection = {
				'ID1': 'DCS/PLC SYSTEM',
				'MO': 'MOVEMENT',
				'OF': 'OFFSITE',
				'T1': 'TOC1',
				'T2': 'TOC2',
				'T3': 'TOC3',
				'T4': 'TOC4',
				'T5': 'TOC5',
				'UT': 'UTILITY',
				'WS': 'WORKSHOP',
				'UT2': 'UTILITY TP',
				'BU': 'BUILDING',
				'CO': 'COMMON AREA',
				'P1': 'PROCESS1',
				'AN': 'ANCILLARY',
				'BU': 'BUILDINGS',
				'HE': 'HEAD OFFICE',
				'L1': 'PROCESS1',
				'B1': 'Process1-LABIX',
				'P1': 'PROCESS1 (TPX)'
			}

			component.set(`v.form.${params.fieldName}`, plantSection[params.value]);
		}
	}
});