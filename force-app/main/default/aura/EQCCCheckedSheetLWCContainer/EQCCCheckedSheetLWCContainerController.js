({
    doInit: function (cmp) {
        let pageref = cmp.get("v.pageReference");
        let recordId = pageref.state.c__recordId;
        if (recordId) {
            cmp.set("v.recordId", recordId);
        }
    },
    reInit: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
    }
});