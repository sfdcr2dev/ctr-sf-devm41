({
	doInit : function(component, event, helper) 
	{
        component.set('v.showLoading', true);
		if(component.get('v.historyType') == 'Initial' || component.get('v.historyType') == 'Edit')
		{
			
			var mPreviousValueHeader = '';
			var mNewValueHeader = '';
			if(component.get('v.historyType') == 'Initial')
			{
				component.set('v.HeaderCard', 'Edit Counterparty');
				mPreviousValueHeader = 'Trader Value';
				mNewValueHeader = 'TRCR Value';
				component.set('v.HeaderOriginal', mPreviousValueHeader);
				component.set('v.HeaderLatest', mNewValueHeader);
			}
			else if (component.get('v.historyType') == 'Edit')
			{
				component.set('v.HeaderCard', 'Edit Log');
				mPreviousValueHeader = 'Current Value';
				mNewValueHeader = 'Latest Value';
				component.set('v.HeaderOriginal', mPreviousValueHeader);
				component.set('v.HeaderLatest', mNewValueHeader);
			}
			
			component.set('v.HeaderFieldHeaderList',[{label: 'Source name', fieldName: 'mSource', type: 'text'},
			{label: 'Field name', fieldName: 'mLabel', type: 'text', wrapText: true},
			{label: mPreviousValueHeader, fieldName: 'mOldValue', type: 'text'},
			{label: mNewValueHeader, fieldName: 'mLatestValue', type: 'text'},
			{label: 'User', fieldName: 'mUser', type: 'text'}]);
		}
		else if(component.get('v.historyType') == 'Shareholder')
		{
			component.set('v.HeaderCard', 'Edit Shareholder');
			component.set('v.HeaderOriginal', 'Name');
			component.set('v.HeaderLatest', 'Percentage');
			
			component.set('v.RelatedObj', true);

			component.set('v.HeaderFieldHeaderList',[{label: 'Name', fieldName: 'mCol1', type: 'text'},
			{label: 'Percentage', fieldName: 'mCol2', type: 'text', wrapText: true},
			{label: 'Status', fieldName: 'mStatus', type: 'text'}]);
			
		}
		else if(component.get('v.historyType') == 'DestinationCountry')
		{
			component.set('v.HeaderCard', 'Edit Destination Country');
			component.set('v.HeaderOriginal', 'Country');
			component.set('v.HeaderLatest', 'Type');
			component.set('v.RelatedObj', true);
			component.set('v.HeaderFieldHeaderList',[{label: 'Country', fieldName: 'mCol1', type: 'text'},
			{label: 'Type', fieldName: 'mCol2', type: 'text', wrapText: true},
			{label: 'Status', fieldName: 'mStatus', type: 'text'}]);

		}
		else if (component.get('v.historyType') == 'Edit')
		{
			component.set('v.isEditRecordType', true);
			
		}
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

								if(result.mAllEditList.length >0)
								{
									component.set('v.ChangedFound', true);
								}
							}
							else
							{
								component.set('v.FieldChanged', result.mRelatedEditList);
								if(result.mRelatedEditList.length >0)
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