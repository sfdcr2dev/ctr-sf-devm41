({
	setWindowsStorage: function (component) {
		window.sessionStorage.setItem(
			`ODM_HistoricalSearch_State_${component.get('v.userId')}`,
			component.get('v.whichState')
		);
	},
	loadWindowsStorage: function (component) {
		const stateType = window.sessionStorage.getItem(`ODM_HistoricalSearch_State_${component.get('v.userId')}`);
		if (stateType) component.set('v.whichState', stateType);
	}
});