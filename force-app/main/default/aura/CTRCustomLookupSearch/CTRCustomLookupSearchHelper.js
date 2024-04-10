({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
    console.log('where:'+ component.get("v.whereCondition"));
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'objectName' : component.get("v.objectAPIName"),
            'whereCondition' : component.get("v.whereCondition")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }else{
              let errors = response.getError();
              let message = 'Unknown error';
              if (errors && Array.isArray(errors) && errors.length > 0) {
                message = errors[0].message;
              }
              alert('APEX Error: '+message);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
  fireEventChangeValuewithAPI : function(component) 
  {
    if(component.get('v.FieldName'))
    {
      var compEvents = component.getEvent("OnChangeLookup");
      compEvents.setParams({ "Index" : component.get('v.Index'),
                                "Label" : component.get('v.label'),
                                "Api" : component.get('v.FieldName'),
                                "Value" : component.get('v.selectedRecordId')
                               });
          compEvents.fire();
    }

  }
})