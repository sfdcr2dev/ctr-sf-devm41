({
	doInit: function (component, event, helper) {
		let initCalled = component.get('v.initCalled');
		if (!initCalled) {
			let sessionHistory = JSON.parse(window.sessionStorage.getItem('THOR_sessionHistory'));
			let currentPath = window.location.href;
			let currentFullPath;

			let currentRecordId = helper.getParameterByName(component, event, 'c__recordId');
			let listType1 = helper.getParameterByName(component, event, 'c__ListType1');
			let listType2 = helper.getParameterByName(component, event, 'c__ListType2');

			// check if on mobile app
			if (currentPath.includes('/native/bridge.app')) {
				if (currentPath.includes('#')) {
					currentPath = currentPath.split('#');
				}
				currentPath = currentPath[currentPath.length - 1];

				if (listType1 !== null && listType1 !== '') {
					currentFullPath = currentPath + '&c__ListType1=' + listType1 + '&c__ListType2=' + listType2;
				} else {
					currentFullPath = currentPath;
				}
			} else {
				// if on desktop, we can use .pathname instead of href
				currentPath = window.location.pathname;
				if (listType1 !== null && listType1 !== '') {
					currentFullPath =
						currentPath +
						'?c__recordId=' +
						currentRecordId +
						'&c__ListType1=' +
						listType1 +
						'&c__ListType2=' +
						listType2;
				} else {
					currentFullPath = currentPath + '?c__recordId=' + currentRecordId;
				}
			}

			// no sessionHistory stack so create it
			if (!sessionHistory) {
				window.sessionStorage.setItem('THOR_sessionHistory', JSON.stringify([currentFullPath]));
			} else {
				if (sessionHistory[sessionHistory.length - 1] !== currentFullPath) {
					sessionHistory.push(currentFullPath);
					window.sessionStorage.setItem('THOR_sessionHistory', JSON.stringify(sessionHistory));
				}
			}

			component.set('v.initCalled', true);
		}
	},

	handleClick: function (component, event, helper) {
		let sessionHistory = JSON.parse(window.sessionStorage.getItem('THOR_sessionHistory'));
		let goToPage;
		let currentPage;
		let pageRef;
		let navType;
		let navWhere;
		let navLink = component.find('navLink');

		if (sessionHistory.length > 0) {
			if (sessionHistory.length >= 2) {
				// there is no forward nav, so we remove the page we're on from the session history stack
				currentPage = sessionHistory.pop();

				// this is the actaul page we want
				goToPage = sessionHistory.pop();
			} else if (sessionHistory.length == 1) {
				goToPage = sessionHistory.pop();
			}

			// split path up so we can get recordId and where nav should go
			let goToParts = goToPage.split('/');
			navType = goToParts[2];
			navWhere = goToParts[goToParts.length - 1].split('?')[0];
			let recordId = helper.getParameterByName(component, event, 'c__recordId', goToPage);
			let listType1 = helper.getParameterByName(component, event, 'c__ListType1', goToPage);
			let listType2 = helper.getParameterByName(component, event, 'c__ListType2', goToPage);

			// save new sessionHistory stack
			window.sessionStorage.setItem('THOR_sessionHistory', JSON.stringify(sessionHistory));

			// we're going to a component like Order or Notification detail page
			if (navType === 'cmp') {
				if (listType1 !== null && listType1 !== '') {
					pageRef = {
						type: 'standard__component',
						attributes: {
							componentName: navWhere
						},
						state: {
							c__recordId: recordId,
							c__ListType1: listType1,
							c__ListType2: listType2
						}
					};
				} else {
					pageRef = {
						type: 'standard__component',
						attributes: {
							componentName: navWhere
						},
						state: {
							c__recordId: recordId,
							c__backToTabIndex: component.get('v.backToTabIndex')
						}
					};
				}
				// we're going to a custom tab
			} else {
				pageRef = {
					type: 'standard__navItemPage',
					attributes: {
						apiName: navWhere
					}
				};
			}
		} else {
			// no pages other than current to nav to, so we go home and reset sessionHistory stack
			pageRef = {
				type: 'standard__navItemPage',
				attributes: {
					apiName: 'Home'
				}
			};
			window.sessionStorage.setItem('THOR_sessionHistory', JSON.stringify([]));
		}

		navLink.navigate(pageRef, false);
	},
	handleRedirectBack: function (component, event, helper) {
		window.history.back(true);
	}
});