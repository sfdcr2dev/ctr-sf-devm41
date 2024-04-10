({
    setRequestType: function(requestItem) {
        if (!$A.util.isEmpty(requestItem.RecordTypeId)) {
            const recordType = requestItem.RecordType.Name.toLowerCase();
            if (recordType.includes("new")) {
                return this.component.set("v.requestType", "Initial");
            } else if (recordType.includes("extend")) {
                return this.component.set("v.requestType", "Extend");
            } else if (recordType.includes("change") && recordType.includes("credit")) {
                return this.component.set("v.requestType", "ChangeCredit");
            } else if (recordType.includes("block")) {
                return this.component.set("v.requestType", "Block");
            }
        }
        return this.component.set("v.requestType", "");;
    },

    getRequestItem: function () {
        const _THIS_ = this;
        return new Promise($A.getCallback(function (resolve, reject) {
            const action = _THIS_.component.get("c.getRequestItem");
            action.setParams({
                "recordId": _THIS_.component.get("v.recordId")
            });
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const returnValue = response.getReturnValue();
                    resolve(returnValue);
                } else {
                    reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        }));
    },
})