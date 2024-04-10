({
	getData: function (component) {
		let action = component.get('c.getComponents');
		action.setParams({
			functionalLocation: component.get('v.functionalLocation') || '',
			equipment: component.get('v.equipment') || '',
			material: component.get('v.material') || '',
			orderId: component.get('v.recordId')
		});
		// console.log({
		// 	functionalLocation: component.get('v.functionalLocation') || '',
		// 	equipment: component.get('v.equipment') || '',
		// 	material: component.get('v.material') || '',
		// 	orderId: component.get('v.recordId')
		// });
		action.setCallback(this, function (response) {
			let state = response.getState();
			component.set('v.isLoading', false);
			if (state === 'SUCCESS') {
				let tempList = response.getReturnValue();
				// console.log({ tempList });
				if (tempList.length) {
					component.set('v.noResults', false);
					for (let i = 0; i < tempList.length; i++) {
						tempList[i].Index = `${i + 1}`;
						if (tempList[i].Spare_Part_Stocks__r) {
							tempList[i].Available_Quantity__c = tempList[i].Spare_Part_Stocks__r[0].Available_Quantity__c;
							tempList[i].Stock__c = tempList[i].Spare_Part_Stocks__r[0].Id;
							tempList[i].Plant__c = tempList[i].Spare_Part_Stocks__r[0].Plant__r
								? tempList[i].Spare_Part_Stocks__r[0].Plant__r.Code__c
								: '';
						}
					}
				} else {
					component.set('v.noResults', true);
					component.set('v.message', 'No results. Refine your search.');
				}

				component.set('v.components', tempList);
				component.set('v.filteredComponents', tempList);
				component.set('v.displayFilteredComponents', tempList.slice(0, component.get('v.rowPerPage')));
				component.set('v.loadMoreOffset', component.get('v.rowPerPage'));
				component.set('v.enableInfiniteLoading', tempList && tempList.length > 0);
			} else if (state === 'ERROR') {
				component.set('v.noResults', true);
				component.set('v.message', 'Error loading components.');
				var err = response.getError();
				console.error(err);
			}
		});

		if (component.get('v.functionalLocation') || component.get('v.equipment') || component.get('v.material')) {
			component.set('v.isLoading', true);
			$A.enqueueAction(action);
		}
	},
	saveCart: function (component) {
		let action = component.get('c.createOrUpdateCart');
		let cart = component.get('v.cart');
		let cartOfObjects = [];
		let stocks = [];
		try {
			cart.forEach((item) => {
				cartOfObjects.push({
					sobjectType: 'Spare_Part__c',
					Id: item.Id,
					Material_Number__c: item.Material_Number__c,
					Material_Description__c: item.Material_Description__c,
					Base_Unit__c: item.Base_Unit__c
				});
				if (item.Spare_Part_Stocks__r) {
					stocks.push({
						sobjectType: 'Spare_Part_Stock__c',
						Id: item.Spare_Part_Stocks__r[0].Id,
						Available_Quantity__c: item.Spare_Part_Stocks__r[0].Available_Quantity__c,
						Plant__c: item.Spare_Part_Stocks__r[0].Plant__c
					});
				} else {
					stocks.push({
						sobjectType: 'Spare_Part_Stock__c',
						Id: '',
						Available_Quantity__c: 0,
						Plant__c: ''
					});
				}
			});
			action.setParams({
				orderId: component.get('v.recordId'),
				items: cartOfObjects,
				stocks: stocks
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						type: 'success',
						title: 'Added to cart',
						message: 'Components have been added to cart.'
					});
					toastEvent.fire();
				} else {
					console.log(JSON.parse(JSON.stringify(response.getError())));
				}
			});
			$A.enqueueAction(action);
		} catch (e) {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				type: 'error',
				title: 'Added to cart',
				message: 'Spare Part Stock is not available quantiity'
			});
			toastEvent.fire();
		}
	},
	navigateBack: function (component) {
		component.find('navService').navigate({
			type: 'standard__component',
			attributes: {
				componentName: 'c__THOR_OrderRecordDisplay'
			},
			state: {
				c__recordId: component.get('v.recordId')
			}
		});
	},
	getCartSize: function (component) {
		let action = component.get('c.getExistingCart');
		action.setParams({ orderId: component.get('v.recordId') });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let val = response.getReturnValue();
				component.set('v.existingCartSize', val.length);
				component.set('v.existingCart', val);
			}
		});
		$A.enqueueAction(action);
	},

	loadMoreData: function (component, event, helper) {
		var filteredComponents = component.get('v.filteredComponents');
		var displayFilteredComponents = component.get('v.displayFilteredComponents');
		displayFilteredComponents = displayFilteredComponents.concat(
			filteredComponents.slice(
				displayFilteredComponents.length,
				displayFilteredComponents.length + component.get('v.rowPerPage')
			)
		);

		if (
			filteredComponents &&
			displayFilteredComponents &&
			displayFilteredComponents.length < filteredComponents.length
		) {
			component.set('v.enableInfiniteLoading', true);
		} else {
			component.set('v.enableInfiniteLoading', false);
		}
		component.set('v.displayFilteredComponents', displayFilteredComponents);
	}
});