({
	// https://salesforce.stackexchange.com/questions/170025/access-url-parameter-from-lightning-component-lightning
	getParameterByName: function (component, event, name, url) {
		name = name.replace(/[\[\]]/g, '\\$&');
		if (!url) {
			url = window.location.href;
		}
		var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)');
		var results = regex.exec(url);
		if (!results) return null;
		if (!results[2]) return '';
		return decodeURIComponent(results[2].replace(/\+/g, ' '));
	}
});