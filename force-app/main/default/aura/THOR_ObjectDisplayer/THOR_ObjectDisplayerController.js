({
    setIndex: function(component, event, helper) {
        component.set("v.selected", parseInt(event.target.dataset.index));
        if(event.target.dataset.title == 'Detail') {
            //$A.get("e.force:refreshView").fire();
        }
    },

    doInit: function(component, event, helper) {
        var cmpTarget = component.find('tabs');
        $A.util.removeClass(cmpTarget, 'slds-tabs_default');
        var values = [];
        // var childComponent = component.find("THOR_FormData");
        // var message = childComponent.childMessageMethod();
        // childComponent = component.find("THOR_NotificationListRelated");
        // message = childComponent.childMessageMethod();
        // values.push(message);
        let tabs = component.get("v.tabs");
        tabs.forEach(tab => {
            let title = tab.get("v.tabTitle");
            if(title == "DetailEqcc"){
                title = "Detail"
                component.set("v.forEqcc", true);
            }
            values.push(title);
        });
        component.set("v.titles", values);
        helper.tabChanged(component);
    }, 

    tabChanged : function(component, event, helper) {
       helper.tabChanged(component);
    }

   

    
})