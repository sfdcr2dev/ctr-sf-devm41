({
    handleViewAll: function (component) {
        var handleViewEvent = component.getEvent("viewAllEvent");

        var target = component.get("v.target");

        handleViewEvent.setParams({
            "viewAll": !component.get('v.viewingAll'),
            "target": target,
            "key": "viewAll"
        });
        handleViewEvent.fire();
    }
})