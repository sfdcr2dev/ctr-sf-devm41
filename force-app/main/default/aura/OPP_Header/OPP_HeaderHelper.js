({
    getCoinBalance : function(component, event, helper) {
        var action = component.get("c.getCoinBalance");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.coinBalance", response.getReturnValue());
            } else if (state === "INCOMPLETE") {
                console.log("loadCategories: INCOMPLETE");
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
    getInfoUser : function(component, event, helper) {
        var action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.user", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    setCoinExpiryDate: function(component, event, helper) {
        var lastDateOfThisYear = new Date();
        lastDateOfThisYear.setHours(0);
        lastDateOfThisYear.setMinutes(0);
        lastDateOfThisYear.setSeconds(0);
        lastDateOfThisYear.setMilliseconds(0);
        lastDateOfThisYear.setMonth(11);
        lastDateOfThisYear.setDate(31);
        
        var thMonth = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
        
        var year = String(lastDateOfThisYear.getFullYear() + 543).substr(-2);
        var month = thMonth[lastDateOfThisYear.getMonth()];
        var date = lastDateOfThisYear.getDate();

        var thDate = date + ' ' + month + ' ' + year;

        component.set('v.coinExpiryDate', thDate);
    }
})