({
    getResponse: function(component) {
        var action = component.get("c.getNotifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            // are we on mobile?
            var isMobile = component.get("v.isMobile");

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var eventArr = [];
                /*
                    This is the data from the Apex controller.
                    The array is passed to fullcalendar as "events"
                */
                result.forEach(function(key) {
                    eventArr.push({
                        'id': key.Id,
                        'start': key.Required_Start__c,
                        'end': key.Required_End__c,
                        'title': key.Name,
                        'url': "#" // set to nothing, navHelper does this
                    });
                });
                this.loadCalendar(eventArr, component);

            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    loadCalendar :function(data, component){
        var calendarEl = component.find('calendar-id').getElement();

        /*
            https://fullcalendar.io/docs/v4
        */
        var calendar = new FullCalendar.Calendar(calendarEl, {
            plugins: [ 'interaction', 'dayGrid', 'timeGrid' ],
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay,listWeek'
            },
            editable: false,
            navLinks: true,
            weekNumbersWithinDays: true,
            weekNumberCalculation: 'ISO',
            eventLimit: true,
            events: data, // the Notification__c data
            eventClick: function(info) {
                // prevent url click event
                info.jsEvent.preventDefault();
                var navHelper = component.getEvent('navagationHelper');
                // send event to helper and let that do the nav
                navHelper.setParams({
                    "toThisComponent": "c__THOR_NotificationRecordDisplay",
                    "theRecordId": info.event.id,
                });
                navHelper.fire();
            },
        });
        calendar.render();
    },

    getIsMobile: function(component){
        var action = component.get("c.getIsMobile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.isMobile", result);
            }
        });
        $A.enqueueAction(action);
    }
})