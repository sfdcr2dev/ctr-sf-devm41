({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId") == undefined ? '' : component.get("v.recordId");
        // Get RecordType Id
        //console.log('pageReference state--', component.get("v.pageReference").state.inContextOfRef);
        
        var pageReference = component.get("v.pageReference");
        if (pageReference) {
            console.log('have page ref --');
            console.log('Page Reference:', JSON.stringify(pageReference, null, 2));
            
            if (pageReference.state) {
                console.log('have page ref state --'+ pageReference.state);
                // Decode the base64-encoded string
                var decodedInContextOfRef = window.atob(pageReference.state.inContextOfRef.substring(2));
                // Convert the decoded string to UTF-8
                var utf8InContextOfRef = decodeURIComponent(escape(decodedInContextOfRef));
                // Parse the UTF-8 encoded string as JSON
                var inContextOfRefJson = JSON.parse(utf8InContextOfRef);
                // Extract the recordTypeId from the parsed JSON
                var recordTypeId = inContextOfRefJson ? inContextOfRefJson.attributes.recordTypeId : null;
                
                console.log('Decoded inContextOfRef:', decodedInContextOfRef);
                console.log('UTF-8 encoded inContextOfRef:', utf8InContextOfRef);
                console.log('Extracted recordTypeId:', recordTypeId);
            }
        }
        ///////////////////////////////////////////////////
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        console.log('recordTypeId--'+recordTypeId);
        component.set('v.recordTypeId',recordTypeId);
        //if(recordTypeId == null || recordTypeId == 'undefined'){
        console.log('recordTypeId--undefined?' + recordTypeId);
        if(recordTypeId == undefined)
        {
            helper.getTOPType(component);
        }
        else
        {
            helper.RestOfCode(component);
        }
        
        //}
        /*
        // recordId == null && recordTypeId != null(value Id)
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
                        var recordTypeName = data.getReturnValue().Name;
                        
                        if(recordTypeName == 'Tx Customer'){
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
                                }
                            }
                                else
                                {     
                                    var navigateToURL;
                                    navigateToURL = "/lightning/o/Lead/new?count=5&nooverride=1&useRecordTypeCheck=1&navigationLocation=LIST_VIEW&uid=170256557989470381&recordTypeId="+recordTypeId;
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
                    var recordTypeName = data.getReturnValue().RecordType.Name;
                    component.set("v.recordTypeId",data.getReturnValue().RecordTypeId);
                    var modalBody;
                    var modalFooter;
                    if(recordTypeName == 'Tx Customer'){
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
            
        }*/
        
    },
    onPageReferenceChanged: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    
})