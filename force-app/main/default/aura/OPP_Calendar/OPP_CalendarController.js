({
    doInit : function(component, event, helper) {
        helper.getEvents(component, event, helper);
        helper.getDefaultMonthEvents(component, event, helper);
    },
    next : function(component, event, helper) {
        var currentMonth = component.get("v.currentMonth");
        var currentYear = component.get("v.currentYear");
        currentYear = (currentMonth === 11) ? currentYear + 1 : currentYear;
        currentMonth = (currentMonth + 1) % 12;
        helper.getMonthEvent(component, event, helper, currentMonth, currentYear);
        component.set("v.currentMonth", currentMonth);
        component.set("v.currentYear", currentYear);
        component.set("v.next", true);
        component.set("v.previous", false);
    },
    previous : function(component, event, helper) {
        var events = [];
        var currentMonth = component.get("v.currentMonth");
        var currentYear = component.get("v.currentYear");
        currentYear = (currentMonth === 0) ? currentYear - 1 : currentYear;
        currentMonth = (currentMonth === 0) ? 11 : currentMonth - 1;
        helper.getMonthEvent(component, event, helper, currentMonth, currentYear);
        component.set("v.currentMonth", currentMonth);
        component.set("v.currentYear", currentYear);
        component.set("v.next", false);
        component.set("v.previous", true);
    },
    showEvents : function(component, event, helper) {
        var activeDate = component.get("v.activeDate");
        var day = event.currentTarget.id;
        // var elementDay = document.getElementById(day);
        // var nameDay = elementDay.className;
        
        
        if(day != activeDate) {
            document.getElementById(day).style.color = 'red';
            if(activeDate != 0) {
                var elementActiveDay = document.getElementById(activeDate);
                var nameActiveDay = elementActiveDay.className;
                if(nameActiveDay == "date") {
                    document.getElementById(activeDate).style.color = '#195ea4';
                } 
                else if(nameActiveDay == 'font-style') {
                    document.getElementById(activeDate).style.color = '#ffffff';
                }
                else {
                    document.getElementById(activeDate).style.color = 'black';
                }
            }
            component.set("v.activeDate", day);
        }
        
        var month = component.get("v.currentMonth") + 1;
        var year = component.get("v.currentYear");
        var activityDate = year + '-' + month + '-' + day;
        var action = component.get("c.getEvents");
        action.setParams({
            activityDate: activityDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var values = response.getReturnValue();
            var events = [];
			if(state === "SUCCESS") {
                values.forEach(function (item, index) {
                    console.log(index+1)
                    var event = new Object();
                    event.Id = item.Id;
                    event.Subject = item.Subject;
                    event.StartDateTime = item.StartDateTime;
                    event.EndDateTime = item.EndDateTime;
                    event.Location = item.Location;
                    event.IsAllDayEvent = item.IsAllDayEvent;
                    if(values.length == (index+1)) {
                        event.Last = true;
                    }
                    events.push(event);
                });
				component.set("v.events", events);
			}
        });
        $A.enqueueAction(action);
    },
    goToEvent : function(component, event, helper) {
        var id = event.target.id;
        var evt = $A.get("e.force:navigateToURL");
        evt.setParams({
            url: "/lightning/r/Event/" + id + "/view"
        });
        evt.fire(); 
    },
    goToCalendar : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToURL");
		evt.setParams({
			url: "/lightning/o/Event/home"
		});
		evt.fire();
    }
})