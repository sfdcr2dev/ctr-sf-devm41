({
    doInit : function(component, event, helper) {
        helper.setData(component);
        helper.getComplianceNews(component);
        component.set('v.openModal', true);
        component.set('v.isLoaded', true);
    },
    
    viewMore : function(component, event, helper){
        var index = event.currentTarget.getAttribute("data-auraid");
        helper.viewmoreAction(component,index);
    },

    toggleCheckbox : function(component, event, helper) {
        var indexId = event.currentTarget.getAttribute("value");
        var indexkeyword = event.currentTarget.getAttribute("data-auraid");
        // Start~~ Action flag true or false
        var tableData = JSON.parse(JSON.stringify(component.get('v.tableData')));
        tableData.forEach((dataSection) => {
            if(dataSection.keyword.includes(indexkeyword)){
                dataSection.ctrNewsModel.forEach((dataNews) => {
                    if(dataNews.id == indexId){
                        dataNews.flag = !dataNews.flag;
                    }
                });
            }
        });
        component.set('v.tableData',tableData);
        // End~~ 

        var tableDataAll = JSON.parse(JSON.stringify(component.get('v.tableDataAll')));
        //Start~~  loopSET tableData push value flag in tableDataAll.
        tableDataAll.forEach((dataAll) => {
            dataAll.ctrNewsModel.forEach((dataAllNews) => {
                // loop tableData
                tableData.forEach((data) => {
                    data.ctrNewsModel.forEach((dataNews) => {
                        if(dataNews.id == dataAllNews.id){
                            /* SET flag in tableDataAll */
                            dataAllNews.flag = dataNews.flag;
                        }
                    });
                });
            });

        });
        component.set('v.tableDataAll',tableDataAll);
        //End~~

        // Start~~ loop sort flag true after action IN TableData
        var tableDataSort = JSON.parse(JSON.stringify(component.get('v.tableData')));
        tableDataSort.forEach((data) => {
            data.ctrNewsModel.sort(helper.dynamicSort(component, "flag"));
        });
        component.set('v.tableData', tableDataSort);
        //END~~

        // Start~~ loop sort flag true after action IN TableDataAll
        var tableDataAllSortFlag = JSON.parse(JSON.stringify(component.get('v.tableDataAll')));
        tableDataAllSortFlag.forEach((data) => {
            data.ctrNewsModel.sort(helper.dynamicSort(component, "flag"));
        });
        component.set('v.tableDataAll', tableDataAllSortFlag);
        //END~~
    },

    handleToggleSection : function(component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute("data-auraid");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        // -1 open/close section
        if(sectionState == -1) {
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section'); // slds-is-close 
        }
    },

    radioOnGroup : function(component, event) {
        console.log('[radioOnGroup] -----', component.get('v.selectedComplianceNews'));
        //var selected = event.currentTarget.getAttribute("value");
        var selected = component.get('v.selectedComplianceNews');
        console.log('[selected] -----', selected);
        component.set('v.inputRadio', selected);
    },

    saveNews : function(component, event, helper) {
        if(component.get('v.inputRadio')) {
            helper.saveNews(component);
        }else if(!component.get('v.inputRadio')) {
            helper.toastEvent('Error','Please fill in: Compliance risk news','error');
        }
    },

    handleClose : function(component, event, helper) {
        helper.closeModal(component);
    } 
})