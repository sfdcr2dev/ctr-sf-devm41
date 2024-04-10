({
	handleOpenClose: function (component, event, helper) {
		if (component.get('v.isDropable')) {
			if (component.get('v.isOpen')) {
				component.set('v.isOpen', false);
			} else {
				component.set('v.isOpen', true);
			}
		} else {
			helper.navigateToRecord(component, event, helper);
		}
	},

	delete: function (component, event, helper) {
		event.preventDefault();
		event.stopPropagation();

		component.set('v.isDeleted', true);
		component.set('v.isOpen', false);

		let oktanaCard = component.find('card');

		$A.util.addClass(oktanaCard, 'oktana-delete');
		setTimeout(function () {
			$A.util.addClass(oktanaCard, 'slds-hide');
		}, 500);
	},
	handleSlide: function (component, event) {
		component.set('v.isActionsDisplayed', !component.get('v.isActionsDisplayed'));
		event.stopPropagation();
		event.preventDefault();
		component.find('chevron').blur();
	},

	handleSelect: function (component) {
		component.set('v.isSelected', !component.get('v.isSelected'));
	},

	navigateToRecord: function (component, event, helper) {
		helper.navigateToRecord(component, event, helper);
	}
});