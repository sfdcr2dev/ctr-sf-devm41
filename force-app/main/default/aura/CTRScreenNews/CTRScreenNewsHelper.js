({
    dynamicSort : function (component, property) {
        var sortOrder = 1;
        if(property[0] === "-") {
            sortOrder = -1;
            property = property.substr(1);
        }
        return function (a,b) {
            /* next line works with strings and numbers, 
             * and you may want to customize it to your needs
             */
            var result = (a[property] > b[property]) ? -1 : (a[property] < b[property]) ? 1 : 0;
            return result * sortOrder;
        }
    },
    
    setData : function(component) {
        console.log('[setData] sObjectName -----', component.get('v.sObjectName'));
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
                    component.set('v.selectedComplianceNews', 'Yes');
                }else{
                    component.set('v.ComplianceNewsNo', true);
                    component.set('v.selectedComplianceNews', 'No');
                }
                component.set('v.inputRadio', result);
            }else{
                console.log('ERROR: ',data.message);
            }
        });
        $A.enqueueAction(action);
    },

    viewmoreAction : function(component,index) {
        var myList = [];
        let tableDataAll = JSON.parse(JSON.stringify(component.get('v.tableDataAll')));
        let tableData = JSON.parse(JSON.stringify(component.get('v.tableData')));
        
        if(tableDataAll[index].ctrNewsModel.length != tableData[index].ctrNewsModel.length){
            
            for (let i = 0; i < tableDataAll[index].ctrNewsModel.length; i++) {
                if(i < tableData[index].ctrNewsModel.length + 5){
                    myList.push(tableDataAll[index].ctrNewsModel[i]);
                }else{
                    break;
                }
            }
        tableData[index].ctrNewsModel = myList;
        component.set('v.tableData',tableData);
        }else if(tableDataAll[index].ctrNewsModel.length == tableData[index].ctrNewsModel.length){
            this.toastEvent('Error','There are no records to view more.','error');
        }
    },

    saveNews : function(component) {
        component.set('v.isLoaded', false);
        var tableDataAll = JSON.parse(JSON.stringify(component.get('v.tableDataAll')));
        var inputRadio = component.get('v.inputRadio');
        component.set('v.showLoading',true);
        var action = component.get('c.saveCTRNewsItem');
        action.setParams({
            recordId: component.get('v.recordId'),
            ctrNewsList: tableDataAll,
            complianceRiskNews: inputRadio,
            sObjectName: component.get('v.sObjectName')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.showLoading', false);
                this.toastEvent('Success', 'Save News success', 'success');
                this.closeModal(component);
                
                // Refresh the record page
            	$A.get('e.force:refreshView').fire();
            }else{
                component.set('v.showLoading',false);
                this.toastEvent('Error', data.message, 'error');
                this.closeModal(component);
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },

    toastEvent : function(Title, Message, Type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": Title,
            "message": Message,
            "type": Type
        });
        toastEvent.fire();
    },

    closeModal : function (component) {
        if(component.get('v.isChildModal')) {
            component.set("v.openModal", false);
        } else {
            $A.get("e.force:closeQuickAction").fire();
        }
    },

})