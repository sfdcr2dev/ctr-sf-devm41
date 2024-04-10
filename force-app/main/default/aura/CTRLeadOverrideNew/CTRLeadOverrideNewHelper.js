({
    getTOPType: function (component, event, helper) {
        var action = component.get("c.getTOPType");
        console.log('getTOPType--');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getTOPType--s');
                var response = response.getReturnValue()
                if(response[0] == 'TOP'){
                    console.log('response--s' +response[0] +' '+ response[1]);
                    component.set('v.recordTypeId',response[1]);
                }
                this.RestOfCode(component);
                
            } else {
                console.error("Error Get Type");
            }
        });
        
        $A.enqueueAction(action);
        
    },
    RestOfCode: function (component, event, helper) {
        console.log('All--');
        console.log('component.get("v.ObjectType")--' +component.get("v.ObjectType"));
        
        var recordId = component.get("v.recordId") == undefined ? '' : component.get("v.recordId");
        var recordTypeId= component.get('v.recordTypeId');
        
        if(recordId == null || recordId == '' || recordId == undefined){
            
            if(recordTypeId != undefined && recordTypeId != '')
            {
                // Get RecordType Name
                var actionGetRecordTypeName = component.get("c.getRecordTypeName");
                actionGetRecordTypeName.setParams({
                    recordTypeId: component.get('v.recordTypeId')
                });
                actionGetRecordTypeName.setCallback(this, function (data) {
                    if (data.getState() === 'SUCCESS') {
                        var recordTypeName = data.getReturnValue().DeveloperName;
                        
                        if(recordTypeName == 'TxCustomer'){
                            try{
                                var modalBody;
                                var modalFooter;
                                $A.createComponents([ 
                                    [('c:CTRLeadCustomerTX'),{isInitial:true 
                                                              ,recordTypeId:component.get("v.recordTypeId")
                                                              ,ObjectType:component.get("v.ObjectType")
                                                              ,onPageRecordID : component.get("v.recordId")
                                                              ,recordId : component.get("v.recordId")}]
                                ],
                                                    function(components, status){
                                                        if (status === 'SUCCESS') {
                                                            modalBody = components[0];
                                                            component.find('overlayLib').showCustomModal({
                                                                header: 'New Lead CustomerTX',
                                                                body: modalBody,
                                                                footer: modalFooter,
                                                                showCloseButton: false,
                                                                cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                                closeCallback: function() {
                                                                    // helper.closedTeb(component);
                                                                }
                                                            });
                                                        }
                                                    });
                                
                            }
                            catch(ex)
                            {
                                console.log('ex--'+ex.message());
                            }
                            
                        }
                        else if(recordTypeName == 'TxSupplier'){
                            try{
                                var modalBody;
                                var modalFooter;
                                $A.createComponents([
                                    [('c:CTRLeadSupplierTX'),{isInitial:true 
                                                              ,recordTypeId:component.get("v.recordTypeId")
                                                              ,ObjectType:component.get("v.ObjectType")
                                                              ,onPageRecordID : component.get("v.recordId")
                                                              ,recordId : component.get("v.recordId")}]
                                ],
                                                    function(components, status){
                                                        if (status === 'SUCCESS') {
                                                            modalBody = components[0];
                                                            component.find('overlayLib').showCustomModal({
                                                                header: 'New Lead SupplierTX',
                                                                body: modalBody,
                                                                footer: modalFooter,
                                                                showCloseButton: false,
                                                                cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                                closeCallback: function() {
                                                                    // helper.closedTeb(component);
                                                                }
                                                            });
                                                        }
                                                    });
                            }
                            catch(ex)
                            {
                                console.log('ex--'+ex.message());
                            }
                        }
                            else if(recordTypeName == 'TOP'){
                                /*
                                try{
                                    var modalBody;
                                    var modalFooter;
                                    $A.createComponents([ 
                                        [('c:CTRLeadTOP'),{isInitial:true 
                                                           ,recordTypeId:component.get("v.recordTypeId")
                                                           ,ObjectType:component.get("v.ObjectType")
                                                           ,onPageRecordID : component.get("v.recordId")
                                                           ,recordId : component.get("v.recordId")}]
                                    ],
                                                        function(components, status){
                                                            if (status === 'SUCCESS') {
                                                                modalBody = components[0];
                                                                component.find('overlayLib').showCustomModal({
                                                                    header: 'New Lead TOP',
                                                                    body: modalBody,
                                                                    footer: modalFooter,
                                                                    showCloseButton: false,
                                                                    cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                                    closeCallback: function() {
                                                                        // helper.closedTeb(component);
                                                                    }
                                                                });
                                                            }
                                                        });
                                }
                                catch(ex)
                                {
                                    console.log('ex--'+ex.message());
                                }*/
                                /*
                                var navigateToURL;
                                navigateToURL = "/lightning/o/Lead/new?count=5&nooverride=1&useRecordTypeCheck=1&navigationLocation=LIST_VIEW&uid=170256557989470381&recordTypeId="+recordTypeId;
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": navigateToURL
                                });
                                urlEvent.fire();*/
                                
                                
                                var navigateToURL;
                                    console.log('recordTypeId-2--'+recordTypeId);
                                    //navigateToURL = "/lightning/o/Account/new?&defaultFieldValues=recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                                    navigateToURL = "/lightning/o/Lead/new?&recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FLead%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                                    var urlEvent = $A.get("e.force:navigateToURL");
                                    urlEvent.setParams({
                                        "url": navigateToURL
                                    });
                                    urlEvent.fire();
                            }
                                else
                                {     
                                    var navigateToURL;
                                    console.log('recordTypeId-2--'+recordTypeId);
                                    //navigateToURL = "/lightning/o/Account/new?&defaultFieldValues=recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                                    navigateToURL = "/lightning/o/Lead/new?&recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FLead%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                                    var urlEvent = $A.get("e.force:navigateToURL");
                                    urlEvent.setParams({
                                        "url": navigateToURL
                                    });
                                    urlEvent.fire();
                                    
                                }
                    }
                });
                $A.enqueueAction(actionGetRecordTypeName);
            }
            
            
        }
        else if(recordId != null || recordId != '' || recordId != undefined ){
            
            // Get RecordType Name
            var actionGetRecordTypeName = component.get("c.getRecordTypeNameByRecordId");
            actionGetRecordTypeName.setParams({
                "recordId": recordId
            });
            actionGetRecordTypeName.setCallback(this, function (data) {
                if (data.getState() === 'SUCCESS') {
                    var recordTypeName = data.getReturnValue().RecordType.DeveloperName;
                    component.set("v.recordTypeId",data.getReturnValue().RecordTypeId);
                    var modalBody;
                    var modalFooter;
                    if(recordTypeName == 'TxCustomer'){
                        $A.createComponents([ //CTRLeadCustomerTX //CTRLeadSupplierTX //CTRLeaddTOP
                            [('c:CTRLeadCustomerTX'),{isInitial:true 
                                                      ,recordTypeId:component.get("v.recordTypeId")
                                                      ,ObjectType:component.get("v.ObjectType")
                                                      ,onPageRecordID : component.get("v.recordId")
                                                      ,recordId : component.get("v.recordId")
                                                      ,editRecord : true
                                                     }]],
                                            function(components, status){
                                                if (status === 'SUCCESS') {
                                                    modalBody = components[0];
                                                    component.find('overlayLib').showCustomModal({
                                                        header: 'Edit Lead CustomerTX',
                                                        body: modalBody,
                                                        footer: modalFooter,
                                                        showCloseButton: false,
                                                        cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                        closeCallback: function() {
                                                            // helper.closedTeb(component);
                                                        }
                                                    });
                                                }
                                            });
                    }
                    else if(recordTypeName == 'TxSupplier'){
                        $A.createComponents([ //CTRLeadCustomerTX //CTRLeadSupplierTX //CTRLeaddTOP
                            [('c:CTRLeadSupplierTX'),{isInitial:true 
                                                      ,recordTypeId:component.get("v.recordTypeId")
                                                      ,ObjectType:component.get("v.ObjectType")
                                                      ,onPageRecordID : component.get("v.recordId")
                                                      ,recordId : component.get("v.recordId")
                                                      ,editRecord : true
                                                     }]],
                                            function(components, status){
                                                if (status === 'SUCCESS') {
                                                    modalBody = components[0];
                                                    component.find('overlayLib').showCustomModal({
                                                        header: 'Edit Lead TxSupplier',
                                                        body: modalBody,
                                                        footer: modalFooter,
                                                        showCloseButton: false,
                                                        cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                        closeCallback: function() {
                                                            // helper.closedTeb(component);
                                                        }
                                                    });
                                                }
                                            });
                    }
                        else if(recordTypeName == 'TOP'){
                            $A.createComponents([ //CTRLeadCustomerTX //CTRLeadSupplierTX //CTRLeaddTOP
                                [('c:CTRLeadTOP'),{isInitial:true 
                                                   ,recordTypeId:component.get("v.recordTypeId")
                                                   ,ObjectType:component.get("v.ObjectType")
                                                   ,onPageRecordID : component.get("v.recordId")
                                                   ,recordId : component.get("v.recordId")
                                                   ,editRecord : true
                                                  }]],
                                                function(components, status){
                                                    if (status === 'SUCCESS') {
                                                        modalBody = components[0];
                                                        component.find('overlayLib').showCustomModal({
                                                            header: 'Edit Lead TOP',
                                                            body: modalBody,
                                                            footer: modalFooter,
                                                            showCloseButton: false,
                                                            cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                            closeCallback: function() {
                                                                // helper.closedTeb(component);
                                                            }
                                                        });
                                                    }
                                                });
                        }                    
                }
            });
            $A.enqueueAction(actionGetRecordTypeName);
            
        }
        
    },
    
    //
    
    //
})