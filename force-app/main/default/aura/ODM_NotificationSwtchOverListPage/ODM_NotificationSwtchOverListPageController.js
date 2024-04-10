({
	doInit: function (component, event, helper) {
		// component.set('v.notification_list', [
		// 	{
		// 		Name: 10872383,
		// 		info: ['New', 'OP', 'V-2461A', '10/05/2022'].join(' . '),
		// 		description: 'Please change the filter'
		// 	}
		// ]);
		// component.set('v.notification_display', component.get('v.notification_list').slice(0, 20));
		window.setTimeout(
			$A.getCallback(function () {
				if (component.get('v.notification_list.length') === 0) {
					helper.getNotificationList(component, event, helper);
				}
			}),
			500
		);
	},
	handleFilter: function (component, event, helper) {
		console.warn('fitlerEnhanceEvent received!');
		var params = event.getParams();
		var filter = component.find('ODM_FilterEnhance').getFilterList();

		component.set('v.currentpage', 1);
		component.set('v.offset', 0);
		component.set(
			'v.filter',
			Object.keys(filter).reduce(
				(acc, key) => {
					acc[key] = filter[key];
					return acc;
				},
				{
					Notification_Status__c: 'New;In Progress'
				}
			)
		);

		helper.getNotificationList(component, event, helper);
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
			helper.getNotificationList(component, event, helper);
		}
	},
	navigateToDisplay: function (component, event, helper) {
		const recordId = event.currentTarget.getAttribute('data-record-id');
		component.find('navService').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_NotificationRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	}
});