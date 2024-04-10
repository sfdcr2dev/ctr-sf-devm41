({
    hardWare: function (component, event, helper) {
        component.set("v.hardWareModal", true);
    },
    softWare: function (component, event, helper) {
        component.set("v.softWareModal", true);
    },
    other: function (component, event, helper) {
        component.set("v.otherModal", true);
    },
    project: function (component, event, helper) {
        component.set("v.projectModal", true);
    },
    hardWare2: function (component, event, helper) {
        component.set("v.hardWare2Modal", true);
    },
    incident: function (component, event, helper) {
        component.set("v.incidentModal", true);
    },
    stationery: function (component, event, helper) {
        component.set("v.stationeryModal", true);
    },
    authorization: function (component, event, helper) {
        component.set("v.authorizationModal", true);
    },
    navigateToITRequest: function (component, event, helper) {
        // component.set(`v.${event.target.name}`, true);
        event.preventDefault();
        var cmptarget = event.getSource();
        var cmpName = cmptarget.get('v.name');
        if (cmpName) {
            var navService = component.find("navService");
            navService.navigate({
                type: "standard__webPage",
                attributes: {
                    url: `/one/one.app#${btoa(JSON.stringify({
                        componentDef: `c:${cmpName}`,
                        attributes: {
                            uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                                let r = Math.random() * 16 | 0,
                                    v = c == 'x' ? r : (r & 0x3 | 0x8);
                                return v.toString(16);
                            })
                        }
                    }))}`
                }
            }, false);
        }
    },
    handleComponentEvent: function (component, event, helper) {
        var hardWareModal = event.getParam("hardWareModalOpen");
        var softWareModal = event.getParam("softWareModalOpen");
        var otherModal = event.getParam("otherModalOpen");
        var projectModal = event.getParam("projectModalOpen");
        var hardWare2Modal = event.getParam("hardWare2ModalOpen");
        var incidentModal = event.getParam("incidentModalOpen");
        var stationeryModal = event.getParam("stationeryModalOpen");
        var authorizationModal = event.getParam("authorizationModalOpen");


        if (!$A.util.isUndefinedOrNull(hardWareModal)) {
            component.set("v.hardWareModal", hardWareModal)
        }
        else if (!$A.util.isUndefinedOrNull(softWareModal)) {
            component.set("v.softWareModal", softWareModal)
        }
        else if (!$A.util.isUndefinedOrNull(otherModal)) {
            component.set("v.otherModal", otherModal)
        }
        else if (!$A.util.isUndefinedOrNull(projectModal)) {
            component.set("v.projectModal", projectModal)
        }
        else if (!$A.util.isUndefinedOrNull(hardWare2Modal)) {
            component.set("v.hardWare2Modal", hardWare2Modal)
        }
        else if (!$A.util.isUndefinedOrNull(incidentModal)) {
            component.set("v.incidentModal", incidentModal)
        }
        else if (!$A.util.isUndefinedOrNull(stationeryModal)) {
            component.set("v.stationeryModal", stationeryModal)
        }
        else if (!$A.util.isUndefinedOrNull(authorizationModal)) {
            component.set("v.authorizationModal", authorizationModal)
        }
    },
        
    refreshListview: function(component, event, helper) {
        //helper.createAllAccountListListView(component, event, helper);
        window.setTimeout(
            $A.getCallback(function() {
				helper.createAllAccountListListView(component, event, helper);
            }), 2000
        );
    },
})