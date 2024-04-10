({
	setData : function(component) {
        var myList = [];
        var numberListView = component.get('v.viewMore');
        var action = component.get('c.getCTRNews');
        action.setParams({
            recordId: component.get('v.recordId'),
            sObjectName: component.get('v.sObjectName')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                console.log('[setData] result -----', result);
                result.forEach((data) => {
                    data.ctrNewsModel.sort(this.dynamicSort(component,"flag"));
                });
                component.set('v.tableDataAll',result);
                component.set('v.tableData',JSON.parse(JSON.stringify(result)));

                var tableData = component.get('v.tableData');
                tableData.forEach((dataAll) => {
                    for (let i = 0; i < dataAll.ctrNewsModel.length; i++) {
                        if(i < numberListView){
                            myList.push(dataAll.ctrNewsModel[i]);
                        }else{
                            break;
                        }
                    }
                    dataAll.ctrNewsModel = myList;
                    myList = [];
                });
                component.set('v.tableData',tableData);
            }
        });
        $A.enqueueAction(action);
    },
                    
    getComplianceNews : function(component) {
        var recordId =  component.get('v.recordId');
        var action = component.get('c.getComplianceNews');
        action.setParams({
            recordId: recordId,
            sObjectName: component.get('v.sObjectName')
        });
        action.setCallback(this, function (response) {
            var data = response.getState();
            if(data =="SUCCESS"){
                var result = response.getReturnValue();
                if(result == 'Yes') {
                    component.set('v.ComplianceNewsYes', true);
                }else{
                    component.set('v.ComplianceNewsNo', true);
                }
                component.set('v.inputRadio', result);
            }else{
                console.log('ERROR: ',data.message);
            }
        });
        $A.enqueueAction(action);
    },
                    
    closeModal : function (component) {
        if(component.get('v.isChildModal')) {
            component.set("v.openModal", false);
        } else {
            $A.get("e.force:closeQuickAction").fire();
        }
    },
})