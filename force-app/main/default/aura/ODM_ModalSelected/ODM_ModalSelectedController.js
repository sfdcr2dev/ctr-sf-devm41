({
	doInit: function (component, event, helper) {
		component.set(
			'v.modalFactor',
			{
				empty: '',
				small: 'slds-modal_small',
				medium: 'slds-modal_medium',
				large: 'slds-modal_large'
			}[component.get('v.size') || 'small']
		);
	},
	handleToggleModal: function (component, event, helper) {
		component.set('v.isToggle', !component.get('v.isToggle'));
	}
});