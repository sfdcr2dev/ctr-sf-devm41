({
	doInit: function (component, event, helper) {
		helper.loadWindowsStorage(component);
		
	},
	scriptsLoaded: function (component, event, helper) {
		$('.select2Class').select2({
			placeholder: ' Select Multiple value'
		});
	},
	setState: function (component, event, helper) {
		component.set('v.whichState', event.getSource().get('v.name'));
		helper.setWindowsStorage(component);
	}
});