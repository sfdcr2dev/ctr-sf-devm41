({
	handleSelect2Loaded: function (component, event, helper) {
        setTimeout(function() {
            let fieldName = component.get('v.fieldName');
            let value = component.get('v.value');

			$('#' + fieldName).select2({
				placeholder: ' Select Multiple value'
			}).on('change', function(evt) {
                try {
                    let value = $(this).val();
                    if (value && value.length > 0) {
                        value = value.join(',');
                    }
                    component.set('v.value', value);

                    let evt = component.getEvent('valueChangeEvent')
                    evt.setParams({
                        fieldName: component.get('v.fieldName'),
                        value: component.get('v.value'),
                        oldValue: component.get('v.oldValue'),
                        questionId: component.get('v.questionId'),
                    })
                    evt.fire()
                    component.set('v.oldValue', component.get('v.value'))
                } catch (ex) {
                    console.error(ex)
                }
            })

            if (value && value.length > 0) {
                value = value.split(',');
            } else {
                value = (value) ? [ value ] : [];
            }
            $('#' + fieldName).val(value).trigger('change');
		}, 100)
	},
    doInit: function (component, event, helper) {
        try {
            component.set('v.constants', helper.constants)
            component.set('v.oldValue', component.get('v.value'))
            //$A.enqueueAction(component.get('c.handleSuggestLookupChanged'));
        } catch (ex) {
            console.error(JSON.parse(JSON.stringify(ex)))
        }
    },
    handleChanged: function (component, event, helper) {
        try {
            let evt = component.getEvent('valueChangeEvent')
            evt.setParams({
                fieldName: component.get('v.fieldName'),
                value: component.get('v.value'),
                oldValue: component.get('v.oldValue'),
                questionId: component.get('v.questionId'),
            })
            evt.fire()
            component.set('v.oldValue', component.get('v.value'))
        } catch (ex) {
            console.error(ex)
        }
    },
    handleSuggestLookupChanged: function (component, event, helper) {
        try {
            if (event) {
            	const { value, displayValue } = event.getParams();
                if (displayValue) {
                    component.set('v.value', displayValue);
                }
            }
            // console.log('v.value :',component.get('v.value'));
            // console.log('displayValue :',displayValue);

            console.log('fieldName :',component.get('v.fieldName'));
            console.log('oldValue :',component.get('v.oldValue'));
            console.log('questionId :',component.get('v.questionId'));

            let evt = component.getEvent('valueChangeEvent')
            evt.setParams({
                fieldName: component.get('v.fieldName'),
                value: component.get('v.value'),
                oldValue: component.get('v.oldValue'),
                questionId: component.get('v.questionId'),
            })
            evt.fire()
            component.set('v.oldValue', component.get('v.value'))
        } catch (ex) {
            console.error(ex)
        }
    },
})