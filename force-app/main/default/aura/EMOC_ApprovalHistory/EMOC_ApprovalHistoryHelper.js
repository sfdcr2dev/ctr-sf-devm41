({
    COLUMNS: [
        { label: 'Step Name', fieldName: 'StepPath', type: 'url', typeAttributes:{label: { fieldName: 'StepName' }}},
        { label: 'Approver', fieldName: 'OriginalActorId' },
        { label: 'Comments', fieldName: 'Comments' },
        { label: 'Status', fieldName: 'StepStatus' },
        {
            label: 'Date',
            fieldName: 'CreatedDate',
            type: 'datetime',
            sortable: true,
            cellAttributes: { alignment: 'left' }
        },
        { label: 'Actual Approver', fieldName: 'ActorId' }
    ],
    setColumns: function(cmp) {
        cmp.set('v.columns', this.COLUMNS);
        this.setData(cmp)
    },
    setData: function(cmp)   {
        var action = cmp.get("c.getOpportunityApprovalHistory");
     	action.setParams({
            "recordId": cmp.get("v.recordId")
     	});
     	action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.opportunityApproversHistory", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
	sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.opportunityApproversHistory");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.opportunityApproversHistory", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})