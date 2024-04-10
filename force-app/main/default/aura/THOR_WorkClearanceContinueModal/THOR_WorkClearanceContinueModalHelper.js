({
	debounce: function (component, func, wait) {
		var timeout = component.get('v.timeout');
		return $A.getCallback(function () {
			var context = this,
				args = arguments;
			clearTimeout(timeout);
			timeout = setTimeout(function () {
				timeout = null;
				func.apply(context, args);
			}, wait);
			component.set('v.timeout', timeout);
		});
	},

    getPISRequester: function (component, searchText, field) {
        var helper = this;
        var action = component.get('c.getPISRequester');
        action.setParams({
            searchText: searchText
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                switch (field) {
                    case 'Thaioil_Supervisor_Indicator_UI__c':
                        component.set(
                            'v.formOption.Thaioil_Supervisor_Indicator_UI__c',
                            result.map((m) => {
                                const { ENFIRSTNAME__c, ENLASTNAME__c, Name } = m;
                                m.ENFIRSTNAME__c = !ENFIRSTNAME__c || !ENLASTNAME__c ? Name : ENFIRSTNAME__c;
                                m.avatar = (ENFIRSTNAME__c ? ENFIRSTNAME__c[0] : '') + (ENLASTNAME__c ? ENLASTNAME__c[0] : '');
                                return m;
                            })
                        );
                        break;
                    case 'Requester_UI__c':
                        component.set(
                            'v.formOption.Requester_UI__c',
                            result.map((m) => {
                                const { ENFIRSTNAME__c, ENLASTNAME__c, Name } = m;
                                m.ENFIRSTNAME__c = !ENFIRSTNAME__c || !ENLASTNAME__c ? Name : ENFIRSTNAME__c;
                                m.avatar = (ENFIRSTNAME__c ? ENFIRSTNAME__c[0] : '') + (ENLASTNAME__c ? ENLASTNAME__c[0] : '');
                                return m;
                            })
                        );
                        break;
					case 'Close_Applicant_or_Bearer_UI__c':
						component.set(
							'v.formOption.Close_Applicant_or_Bearer_UI__c',
							result.map((m) => {
								const { ENFIRSTNAME__c, ENLASTNAME__c, Name } = m;
								m.ENFIRSTNAME__c = !ENFIRSTNAME__c || !ENLASTNAME__c ? Name : ENFIRSTNAME__c;
								m.avatar = (ENFIRSTNAME__c ? ENFIRSTNAME__c[0] : '') + (ENLASTNAME__c ? ENLASTNAME__c[0] : '');
								return m;
							})
						);
						break;
                }
            } else {
                var errors = response.getError();
                console.error(JSON.parse(JSON.stringify(errors)));
            }
        });
        $A.enqueueAction(action);
    },

	getApplicantOrBearer: function (component, searchText, field) {
		var helper = this;
		var action = component.get('c.getApplicantOrBearer');
		action.setParams({
			searchText: searchText
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				switch (field) {
					case 'Applicant_or_Bearer_UI__c':
						component.set(
							'v.formOption.Applicant_or_Bearer_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer1_UI__c':
						component.set(
							'v.formOption.Bearer1_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer2_UI__c':
						component.set(
							'v.formOption.Bearer2_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer3_UI__c':
						component.set(
							'v.formOption.Bearer3_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer4_UI__c':
						component.set(
							'v.formOption.Bearer4_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
				}
			} else {
				var errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});
		$A.enqueueAction(action);
	},

	makeToast: function (type, title, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: message,
			type: type
		});
		toastEvent.fire();
	},

	startLoading: function (component) {
		component.set('v.isLoading', true);
		// this.stopLoading(component);
	},

	stopLoading: function (component) {
		component.set('v.isLoading', false);
	},
})