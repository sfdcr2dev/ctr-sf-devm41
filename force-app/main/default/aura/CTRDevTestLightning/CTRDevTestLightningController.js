({
	doInit : function(component, event, helper) 
	{
        component.set('v.showLoading', true);
		if(component.get('v.historyType') == 'Initial')
		{
			component.set('v.HeaderCard', 'Edit Counterparty');
			component.set('v.HeaderOriginal', 'Trader Value');
			component.set('v.HeaderLatest', 'TRCR Value');
		}
		else if(component.get('v.historyType') == 'Shareholder')
		{
			component.set('v.HeaderCard', 'Edit Shareholder');
			component.set('v.HeaderOriginal', 'Name');
			component.set('v.HeaderLatest', 'Percentage');
			component.set('v.RelatedObj', true);
			
		}
		else if(component.get('v.historyType') == 'DestinationCountry')
		{
			component.set('v.HeaderCard', 'Edit Destination Country');
			component.set('v.HeaderOriginal', 'Country');
			component.set('v.HeaderLatest', 'Type');
			component.set('v.RelatedObj', true);

		}
		else if (component.get('v.historyType') == 'Edit')
		{
			component.set('v.isEditRecordType', true);
		}

		component.set('v.HeaderFieldHeaderList',[{label: 'Source name', fieldName: 'mSource', type: 'text'},
		{label: 'Field name', fieldName: 'mLabel', type: 'text', wrapText: true},
		{label: 'Current value', fieldName: 'mOldValue', type: 'text'},
		{label: 'Lateste value', fieldName: 'mLatestValue', type: 'text'},
		{label: 'User', fieldName: 'mUser', type: 'text'}]);
		// var action = component.get("c.onload");
		// // set param to method  
		//   action.setParams({
		// 	  'mRecordId': component.get('v.recordId')
		// 	});
			  var action = component.get("c.onloadv3");
			  // set param to method  
				action.setParams({
					'mRecordId': component.get('v.recordId')
					,'mHistoryType': component.get('v.historyType')
				  });
			  // set a callBack   
				action.setCallback(this, function(response) 
				{
				  //$A.util.removeClass(component.find("mySpinner"), "slds-show");
					var state = response.getState();
                    console.log(state);
					if (state === "SUCCESS") 
                    {
						var result = response.getReturnValue();
                        console.log('result: '+result);
						if(result)
						{
							if(!component.get('v.RelatedObj'))
							{
								result.mAllEditList.sort(function (a, b) {
									if (a.mSource < b.mSource) {
									  return -1;
									}
									if (a.mSource > b.mSource) {
									  return 1;
									}
									return 0;
								  });
								component.set('v.ItemFieldChanged', result.mItemEditList);
								component.set('v.HeaderFieldChanged', result.mHeaderEditList);
								component.set('v.FieldChanged', result.mAllEditList);
								component.set('v.FieldChangedObj', result.mAllEditList);
								if(result.mItemEditList)
								{
									console.log('ItemFieldChanged'+component.get('v.ItemFieldChanged'))
									component.set('v.ItemChangedFound', true);
								}
								if(result.mHeaderEditList)
								{
									component.set('v.HeaderChangedFound', true);
								}
								if(result.mAllEditList)
								{
									component.set('v.ChangedFound', true);
								}
							}
							else
							{
								component.set('v.FieldChanged', result.mRelatedEditList);
								if(result.mRelatedEditList)
								{
									component.set('v.ChangedFound', true);
								}
							}
                            

						}
						else
						{
							
						}
					}
					else
					{
					  let errors = response.getError();
					  let message = 'Unknown error';
					  if (errors && Array.isArray(errors) && errors.length > 0) 
					  {
						message = errors[0].message;
					  }
					  alert('APEX Error: '+message);
					}
                    component.set('v.showLoading', false);
				});
			  // enqueue the Action  
				$A.enqueueAction(action);
	}
})