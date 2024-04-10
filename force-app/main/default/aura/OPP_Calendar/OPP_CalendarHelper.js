({
    showCalendar : function(component, event, helper, month, year, events) {
        var monthDefault = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        component.set("v.monthAndYear", monthDefault[month] + ' ' + year)
        var today = new Date();
        var firstDay = ( new Date( year, month ) ).getDay();
        var calendars = [];
        var date = 1;
        for ( var i = 0; i < 6; i++ ) {
            var dates  = [];
            var calendar = new Object();
            for ( var j = 0; j < 7; j++ ) {
                var d = new Object();
                if ( i === 0 && j < firstDay ) {
                    // dates.push("");
                    d.date = "";
                    dates.push(d);
                } else if (date > helper.daysInMonth(month, year)) {
                    break;
                } else {
                    if ( date === today.getDate() && year === today.getFullYear() && month === today.getMonth() ) {
                        calendar.today = date;
                    }
                    events.forEach(function (item, index) {
                        if(item.charAt(0) == '0' && item.charAt(1) == date) {
                            d.event = date;
                        }
                        else if(item == date) {
                            d.event = date;   
                        }
                    });
                    // dates.push(date); 
                    d.date = date;
                    dates.push(d);      
                    date++;
                }
            }
            calendar.dates = dates;
            calendars.push(calendar);
        }
        component.set("v.calendars", calendars);
        if(today.getMonth() == month) {
            helper.getEvents(component, event, helper);
        }
        else {
            component.set("v.events", null);
        }
    },
    daysInMonth : function(iMonth, iYear) {
        return 32 - new Date(iYear, iMonth, 32).getDate();
    },
    getEvents : function(component, event, helper) {
        var action = component.get("c.getTodayEvents");
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
    getDefaultMonthEvents : function(component, event, helper) {
        var action = component.get("c.getDefaultMonthEvents");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
                var events = [];
                var values = response.getReturnValue();
                for ( var key in values ) {
                    events.push(key);
                }
                var today = new Date();
                var currentMonth = today.getMonth();
                var currentYear = today.getFullYear();
                component.set("v.currentMonth", currentMonth);
                component.set("v.currentYear", currentYear);
                helper.showCalendar(component, event, helper, currentMonth, currentYear, events);
			}
		});
		$A.enqueueAction(action);
    },
    getMonthEvent : function(component, event, helper, month, year) {
        var action = component.get("c.getMonthEvent");
        action.setParams({
            month: month+1,
            year: year
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var events = [];
                var values = response.getReturnValue();
                console.log(values)
                for ( var key in values ) {
                    events.push(key);
                }
                var currentMonth = month;
                var currentYear = year;
                component.set("v.currentMonth", currentMonth);
                component.set("v.currentYear", currentYear);
                helper.showCalendar(component, event, helper, currentMonth, currentYear, events);
            }
        });
        $A.enqueueAction(action);
    },
})