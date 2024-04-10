({
    doInit: function (component, event, helper) {
     // alert('yo' +component.get("v.isLoading"));
        window.setTimeout(
            $A.getCallback(function () {
                if (component.get('v.stepsForApprove.length') === 0) {
                    helper.setMyApprovalFilter(component , event);
                }
            }),
            500
        );

    },
    handleFilter: function (component, event, helper) {
        // alert('filter');
        console.warn('THOR_FilterEnhanceEvent received!');
        var params = event.getParams();
        var filter = component.find('THOR_FilterEnhance').getFilterList();
        component.set("v.filter", filter);
        console.log(helper.parseObject(filter));
        console.log("filter=");
        console.log(filter);
      
        helper.setMyApprovalFilter(component, event);
        
    },


    navigateToRecord: function (component, event, helper) {
        var str = event.currentTarget.id;
        console.log('str---'+str);
        var getId = str.split(',');
        var getFormGroup = getId[1];
        getId = getId[0];
        var processId = getId;
        var pageRef = component.get("v.pageReference");
        let navLink = component.find("navService");

        // pageRef = {
        //     type: "standard__component",
        //     attributes: {
        //         "componentName": "c__THOR_ApprovalSteps"
        //     },
        //     state: {
        //         "c__recordId": processId,
        //         "c__sheetGroup": getFormGroup
        //     },
        // };

        pageRef = {
            type: 'standard__webPage',
            attributes: {
                url: `/one/one.app#${window.btoa(
                    JSON.stringify({
                        componentDef: `c:THOR_ApprovalSteps`,
                        attributes: {
                            recordId: processId,
                            sheetCode: null,
                            sheetGroup: getFormGroup,
                            forApprovals: true,
                            uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                                let r = (Math.random() * 16) | 0,
                                    v = c == 'x' ? r : (r & 0x3) | 0x8;
                                return v.toString(16);
                            })
                        }
                    })
                )}`
            }
        };
        navLink.navigate(pageRef,false); //true);

        
    }
});