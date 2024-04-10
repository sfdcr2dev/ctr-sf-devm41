({
    doInit : function(component, event, helper) {
        var blankObj = {};
        var selectedRecord = component.get("v.selectedRecord");
        var selectedRecordId = component.get("v.selectedRecordId");
		console.log('selectedRecordId----'+selectedRecordId);
        if(component.get("v.selectedRecord") != null){
            if(selectedRecord.Id ){
                var forclose = component.find("lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                if(component.get('v.disabled'))
                {
                    var forclose = component.find("lookup-box");
                    $A.util.addClass(forclose, 'disableClass');
                }
                
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');

                var lookUpTarget = component.find("lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show'); 
                
            }
        }
        else if(selectedRecordId)
        {
            var action = component.get('c.getLookupValue');
            action.setParams({
                "objectName": component.get('v.objectAPIName'),
                "lookupId": selectedRecordId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var lookupValue = response.getReturnValue();
                    console.log('lookupValue: ' + JSON.stringify(lookupValue));
                    component.set('v.selectedRecord', lookupValue[0]);
                    component.set('v.selectedRecordName', lookupValue[0].Name);
                    component.set('v.selectedRecordId', lookupValue[0].Id);
                    
                    // helper.fireEventToParent(component);
                } else {
                    console.log('get lookup value error: ' + JSON.stringify(response.getError()));
                }
                var forclose = component.find("lookup-pill");
                
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');

                if(component.get('v.disabled'))
                {
                    var forclose = component.find("lookup-box");
                    $A.util.addClass(forclose, 'disableClass');
                }
                
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
                
                var lookUpTarget = component.find("lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show'); 
            });
            $A.enqueueAction(action);
            }
            

    },
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        console.log('key');
    },
    
    // function for clear the Record Selection 
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.selectedRecordId",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );   

        //helper.fireEventChangeValuewithAPI(component);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
        var getSelectObj = component.get("v.objectAPIName");
        //console.log('lol.'+getSelectObj);


        component.set('v.selectedRecordName', selectedAccountGetFromEvent.Name);
        component.set('v.selectedRecordId', selectedAccountGetFromEvent.Id)
        //console.log("Name "+selectedAccountGetFromEvent.Name);
                    
       // console.log(component.get("v.selectedRecord"));
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  

        var compEvents = component.getEvent("OnChangeLookup");
       
        helper.fireEventChangeValuewithAPI(component);
        
    },
    
    OnShow: function(component, event, helper) {
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
    },
    
    handleShowComponent : function(component, event, helper) {
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    }, 
    
    handleChange : function(component, event, helper) 
    {
        if(!component.get('v.selectedRecordId'))
        {
            helper.fireEventChangeValuewithAPI(component);
        }

    },
    handleDisabled : function(component, event, helper) 
    {
        var forclose = component.find("lookup-box");
        if(component.get('v.disabled'))
        {
            
            $A.util.addClass(forclose, 'disableClass');
        }
        else
        {
            $A.util.removeClass(forclose, 'disableClass');
        }
    }
    
})