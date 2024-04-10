({
    fireApproveReviseEvent: function (component) {
        debugger
        var comments = component.find("comments");
        comments = comments.get("v.value");

        var approveReviseEvent = component.getEvent('approveReviseEvent');
        approveReviseEvent.setParams({
            "target": "ApproveRevise",
            "key": comments,
        });
        approveReviseEvent.fire();
    }
})