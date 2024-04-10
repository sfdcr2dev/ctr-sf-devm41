({
	doInit: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		if (pageref && pageref.state) {
			let { c__listPage } = pageref.state;
			if (c__listPage) {
				component.set('v.listPage', c__listPage);
			} else {
				component.set('v.listPage', 'WorkClearance');
			}
		} else {
			component.set('v.listPage', 'WorkClearance');
		}
		helper.getUser(component, event, helper);
	},
	handleFilter: function (component, event, helper) {
		console.warn('fitlerEnhanceEvent received!');
		var params = event.getParams();

		if (params.filterPage == 'ODM_WorkClearanceVerificationFilter') {
			var filter = component.find('ODM_WorkClearanceVerificationFilter').getFilterList();
			component.set('v.veri_currentpage', 1);
			component.set('v.veri_offset', 0);
			component.set(
				'v.veri_filter',
				Object.keys(filter).reduce(
					(acc, key) => {
						acc[key] = filter[key];
						return acc;
					}, {
						Work_Clearance_Status__c: 'Created;In Progress'
					}
				)
			);
			if (helper.filterVerifiedCheckbox) {
				helper.getWcVerificationAllList(component, event, helper);
			} else {
				helper.getWcVerificationList(component, event, helper);
			}
		} else if (params.filterPage == 'ODM_WorkClearanceInspectionFilter') {
			var filter = component.find('ODM_WorkClearanceInspectionFilter').getFilterList();
			component.set('v.inspect_currentpage', 1);
			component.set('v.inspect_offset', 0);
			component.set(
				'v.inspect_filter',
				Object.keys(filter).reduce(
					(acc, key) => {
						acc[key] = filter[key];
						return acc;
					}, {
						Work_Clearance_Status__c: 'Created;In Progress'
					}
				)
			);
			if (helper.filterInspectedCheckbox) {
				helper.getWcInspectionDoneList(component, event, helper);
			} else {
				helper.getWcInspectionList(component, event, helper);
			}
		} else if (params.filterPage == 'ODM_WorkClearanceFilter') {
			var filter = component.find('ODM_WorkClearanceFilter').getFilterList();
			component.set('v.currentpage', 1);
			component.set('v.offset', 0);
			component.set(
				'v.filter',
				Object.keys(filter).reduce(
					(acc, key) => {
						acc[key] = filter[key];
						return acc;
					}, {
						Work_Clearance_Status__c: 'Created;In Progress'
					}
				)
			);
			helper.getWcList(component, event, helper);
		}
	},
	navigateToPaging: function (component, event, helper) {
		const target = event.getSource();
		// console.log(target.get('v.name'));
		switch (target.get('v.name')) {
			case 'first':
				component.set('v.currentpage', 1);
				break;
			case 'previous':
				component.set('v.currentpage', component.get('v.currentpage') - 1);
				break;
			case 'next':
				component.set('v.currentpage', component.get('v.currentpage') + 1);
				break;
			case 'last':
				component.set('v.currentpage', component.get('v.totalpage'));
				break;
			default:
				component.set('v.currentpage', Number(target.get('v.name')));
				break;
		}
		component.set(
			'v.offset',
			(component.get('v.currentpage') - 1) * component.get('v.rowlimit') <= 2000
				? (component.get('v.currentpage') - 1) * component.get('v.rowlimit')
				: 2001 // validate for more than 2000
		);
		if (component.get('v.offset') >= 2000) {
			component.find('notifLib').showNotice({
				variant: 'warning',
				header: 'แจ้งเตือน!',
				message: `ระบบจะแสดงผลลัพธ์ได้จำนวน ${Math.ceil(
					2000 / component.get('v.rowlimit')
				)} หน้า หากไม่พบข้อมูลที่ต้องการ กรุณาระบุเงื่อนไขการค้นหาเพิ่มเติม`,
				closeCallback: $A.getCallback(function () {
					component.set('v.currentpage', 2000 / component.get('v.rowlimit'));
				})
			});
			helper.calculatePaignation(component);
		} else {
			helper.getWcList(component, event, helper);
		}
	},
	navigateToPagingVerification: function (component, event, helper) {
		const target = event.getSource();
		// console.log(target.get('v.name'));
		switch (target.get('v.name')) {
			case 'first':
				component.set('v.veri_currentpage', 1);
				break;
			case 'previous':
				component.set('v.veri_currentpage', component.get('v.veri_currentpage') - 1);
				break;
			case 'next':
				component.set('v.veri_currentpage', component.get('v.veri_currentpage') + 1);
				break;
			case 'last':
				component.set('v.veri_currentpage', component.get('v.veri_totalpage'));
				break;
			default:
				component.set('v.veri_currentpage', Number(target.get('v.name')));
				break;
		}
		component.set(
			'v.veri_offset',
			(component.get('v.veri_currentpage') - 1) * component.get('v.veri_rowlimit') <= 2000
				? (component.get('v.veri_currentpage') - 1) * component.get('v.veri_rowlimit')
				: 2001 // validate for more than 2000
		);
		if (component.get('v.veri_offset') >= 2000) {
			component.find('notifLib').showNotice({
				variant: 'warning',
				header: 'แจ้งเตือน!',
				message: `ระบบจะแสดงผลลัพธ์ได้จำนวน ${Math.ceil(
					2000 / component.get('v.veri_rowlimit')
				)} หน้า หากไม่พบข้อมูลที่ต้องการ กรุณาระบุเงื่อนไขการค้นหาเพิ่มเติม`,
				closeCallback: $A.getCallback(function () {
					component.set('v.veri_currentpage', 2000 / component.get('v.veri_rowlimit'));
				})
			});
			helper.calculateVerificationPaignation(component);
		} else {
			if (helper.filterVerifiedCheckbox) {
				helper.getWcVerificationAllList(component, event, helper);
			} else {
				helper.getWcVerificationList(component, event, helper);
			}
		}
	},
	navigateToPagingInspection: function (component, event, helper) {
		const target = event.getSource();
		// console.log(target.get('v.name'));
		switch (target.get('v.name')) {
			case 'first':
				component.set('v.inspect_currentpage', 1);
				break;
			case 'previous':
				component.set('v.inspect_currentpage', component.get('v.inspect_currentpage') - 1);
				break;
			case 'next':
				component.set('v.inspect_currentpage', component.get('v.inspect_currentpage') + 1);
				break;
			case 'last':
				component.set('v.inspect_currentpage', component.get('v.inspect_totalpage'));
				break;
			default:
				component.set('v.inspect_currentpage', Number(target.get('v.name')));
				break;
		}
		component.set(
			'v.inspect_offset',
			(component.get('v.inspect_currentpage') - 1) * component.get('v.inspect_rowlimit') <= 2000
				? (component.get('v.inspect_currentpage') - 1) * component.get('v.inspect_rowlimit')
				: 2001 // validate for more than 2000
		);
		if (component.get('v.inspect_offset') >= 2000) {
			component.find('notifLib').showNotice({
				variant: 'warning',
				header: 'แจ้งเตือน!',
				message: `ระบบจะแสดงผลลัพธ์ได้จำนวน ${Math.ceil(
					2000 / component.get('v.inspect_rowlimit')
				)} หน้า หากไม่พบข้อมูลที่ต้องการ กรุณาระบุเงื่อนไขการค้นหาเพิ่มเติม`,
				closeCallback: $A.getCallback(function () {
					component.set('v.inspect_currentpage', 2000 / component.get('v.inspect_rowlimit'));
				})
			});
			helper.calculateInspectionPaignation(component);
		} else {
			if (helper.filterInspectedCheckbox) {
				helper.getWcInspectionDoneList(component, event, helper);
			} else {
				helper.getWcInspectionList(component, event, helper);
			}
		}
	},
	navigateToDisplay: function (component, event, helper) {
		const recordId = event.currentTarget.getAttribute('data-record-id');
		if (component.get('v.listPage') == 'Verification') {
			component.find('navService').navigate({
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_WorkClearanceRecordDisplay'
				},
				state: {
					c__recordId: recordId,
					c__tabName: 'verification'
				}
			}, false);
		} else if (component.get('v.listPage') == 'Inspection') {
			component.find('navService').navigate({
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_WorkClearanceRecordDisplay'
				},
				state: {
					c__recordId: recordId,
					c__tabName: 'Inspection'
				}
			}, false);
		} else {
			component.find('navService').navigate({
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_WorkClearanceRecordDisplay'
				},
				state: {
					c__recordId: recordId
				},
			}, false);
		}
	},
	handleShowOrHideInspected: function (component, event, helper) {
		helper.filterInspectedCheckbox = event.target.checked;
		if (event.target.checked) {
			helper.getWcInspectionDoneList(component, event, helper);
		} else {
			helper.getWcInspectionList(component, event, helper);
		}
	},
	handleShowOrHideAllVerification: function (component, event, helper) {
		helper.filterVerifiedCheckbox = event.target.checked;
		if (event.target.checked) {
			helper.getWcVerificationAllList(component, event, helper);
		} else {
			helper.getWcVerificationList(component, event, helper);
		}
	},
});