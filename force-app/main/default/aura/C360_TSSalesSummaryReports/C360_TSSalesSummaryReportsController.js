({
	doInit : function(component, event, helper) {
        
        helper.getAccount(component, event);
        helper.getYear(component, event);
        helper.getBu(component, event);
        helper.getSalesGroup(component, event);
       
        var today = new Date();
        component.set("v.currentYear", today.getFullYear());
         component.set("v.currentMonth", String(today.getMonth() + 1));
    	},
    nextAction : function(component, event, helper) {
       		var selectedMonth = component.get("v.selectedMonth");
        	var selectedYear = component.get("v.selectedYear");
        	var selectedSalesOrg = component.get("v.selectedSalesOrg");
        	var selectedSalesGroup = component.get("v.selectedSalesGroup");
        	var selectedAccountNumber = component.get("v.selectedAccount");
        	var selectedDistributionChannel = component.get("v.selectedDistributionChannel");
        	var selectedBu = component.get("v.selectedBu");
        
       // alert(' selectedMonth '+selectedMonth + ' selectedYear ' +selectedYear + ' selectedSalesOrg ' +selectedSalesOrg + ' selectedSalesGroup ' + selectedSalesGroup + ' selectedAccount ' + selectedAccountNumber + ' selectedBu ' + selectedBu);
        
        if(selectedMonth == null || selectedMonth == '' ||selectedYear == null || selectedYear == '' ){
            var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "message": 'Please review your picklist value',
                            "type":"Error"
                        });
                        toastEvent.fire();
        }else{
            //var action = component.get("c.getDataInTable");
           var action = component.get("c.getDataQuery");
        	action.setParams({
            "selectedMonth": selectedMonth,
            "selectedYear": selectedYear,
            "selectedSalesOrg": selectedSalesOrg,
            "selectedSalesGroup": selectedSalesGroup,
            "selectedAccount": selectedAccountNumber,
            "selectedDistributionChannel": selectedDistributionChannel,
            "selectedBu": selectedBu
        });
        	action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var returnValue =response.getReturnValue();
 	     		 component.set("v.Info", returnValue);
               //alert('test---'+JSON.stringify(returnValue));
               //alert('1');
               var forColor1 = ( returnValue.NetProfitUSD__c/returnValue.LastYearNetProfitUSD__c)*100;
               var forColor2 = ( returnValue.NetProfitUSD__c/returnValue.CPtargetNetProfitUSD__c)*100;
               var forColor3 = ( returnValue.Volume__c/returnValue.LastYearQuantity__c)*100;
               var forColor4 = ( returnValue.Volume__c/returnValue.CPtargetVolume__c)*100;
               var forColor5 = ( returnValue.PocketmarginUSD__c/returnValue.LastYearMonthlyPocketmarginUSD__c)*100;
               var forColor6 = ( returnValue.PocketmarginUSD__c/returnValue.CPtargetPocketMarginUSD__c)*100;
               var forColor7 = ( returnValue.CumNetProfitUSD__c/returnValue.CumLYNetProfitUSD__c)*100;
               var forColor8 = ( returnValue.CumNetProfitUSD__c/returnValue.CumCPtargetNetProfitUSD__c)*100;
               var forColor9 = ( returnValue.CumVolume__c/returnValue.CumLastYearVolume__c)*100;
               var forColor10 = ( returnValue.CumVolume__c/returnValue.CumCPTargetVolume__c)*100;
			   var forColor11 = ( returnValue.CumPocketmarginUSD__c/returnValue.CumLYPocketmarginUSD__c)*100;
               var forColor12 = ( returnValue.CumPocketmarginUSD__c/returnValue.CumCPtargetPocketMarginUSD__c)*100;
               //alert('2');
               var listColor = [];
               var listClolorUse = [];
               listColor.push(forColor1);listColor.push(forColor2);
               listColor.push(forColor3);listColor.push(forColor4);
               listColor.push(forColor5);listColor.push(forColor6);
               listColor.push(forColor7);listColor.push(forColor8);
               listColor.push(forColor9);listColor.push(forColor10);
               listColor.push(forColor11);listColor.push(forColor12);
               //alert('3');
               for(let i=0; i<listColor.length; i++){
                   if(listColor[i]<80){
                       //alert(listColor[i]+ ' red');    #F68D7D #ea001e
                       listClolorUse.push('background-color:#FD3F19');  
                   }else if(listColor[i]>=80 && listColor[i]<100){
                       //alert(listColor[i]+ ' yellow'); #FFCE55
                       listClolorUse.push('background-color:#FDEF19');
                   }else if(listColor[i]>=100){
                       //alert(listColor[i]+ ' green');  #8AD879
                       listClolorUse.push('background-color:#50E74B');
                   }else{
                       //alert(listColor[i]+ ' white');
                       listClolorUse.push('background-color:White');
                   }
			   }
               //alert(listClolorUse);
               component.set("v.ColorList", listClolorUse);
           }
        });
            $A.enqueueAction(action);
            
        }
    	},
    
    loadJquery : function(component, event, helper) {
      
        var dropdown = '[name="AccNumPicklist"]';
     
        $(dropdown).select2({
         
            dropdownAutoWidth : true,
            width: '100%'
             }).on("change", function () {
            component.set("v.selectedAccount", $(this).val());
           // alert('selectedAccount '+$(this).val());
        });
      
    },
    
    getSalesGroupWhenSelectedSalesOrg :function(component, event, helper) {
         var selectedSalesOrg = component.get("v.selectedSalesOrg");
         var action = component.get("c.getSalesGroup");
        	action.setParams({
            "selectedSalesOrg": selectedSalesOrg,
         });
         action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") { 
               var returnValue =response.getReturnValue();
 	     		 component.set("v.salesGrouplist", returnValue);
           }
        });
         $A.enqueueAction(action);
        /*
         var action = component.get("c.getAccountList");
        	action.setParams({
            "selectedSalesOrg": selectedSalesOrg,
         });
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var result =response.getReturnValue();
             //  alert('test---'+result)
               var accountList = [];
                for(var key in result){

                    	var accountNumber = result[key]['AccountNumber__c']; 
                        var accountName = result[key]['CompanyNameEN__c'];
                    	var accountNameTh = result[key]['Name'];
                    if(result[key]['CompanyNameEN__c']==='' || result[key]['CompanyNameEN__c']===null || result[key]['CompanyNameEN__c']=== undefined){
                         var accountDesc = accountNumber + '-' + accountNameTh;
                    }else{
                       var accountDesc = accountNumber + '-' + accountName;  
                    }
                       
                        accountList.push({
                            key: accountNumber, 
                            value: accountDesc}); 
                    }

               	component.set("v.AccountObject", result);
                component.set("v.AccountMap", accountList);
           }
             else if(state == "ERROR"){
                var errors = response.getError();                       
                    component.set("v.showErrors",true);
                    component.set("v.errorMessage",errors[0].message);
                alert(errors);
            }
        });
            $A.enqueueAction(action);*/
    },
    
    getSalesGroupWhenSelectedChannel :function(component, event, helper) {
         var selectedSalesOrg = component.get("v.selectedSalesOrg");
         var selectedDistributionChannel = component.get("v.selectedDistributionChannel");
         var action = component.get("c.getSalesGroup");
        	action.setParams({
            "selectedSalesOrg": selectedSalesOrg,
            "selectedDistributionChannel": selectedDistributionChannel,
         });
         action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") { 
               var returnValue =response.getReturnValue();
 	     		 component.set("v.salesGrouplist", returnValue);
           }
        });
         $A.enqueueAction(action);
        /*
         var action = component.get("c.getAccountList");
        	action.setParams({
            "selectedSalesOrg": selectedSalesOrg,
         });
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var result =response.getReturnValue();
             //  alert('test---'+result)
               var accountList = [];
                for(var key in result){

                    	var accountNumber = result[key]['AccountNumber__c']; 
                        var accountName = result[key]['CompanyNameEN__c'];
                    	var accountNameTh = result[key]['Name'];
                    if(result[key]['CompanyNameEN__c']==='' || result[key]['CompanyNameEN__c']===null || result[key]['CompanyNameEN__c']=== undefined){
                         var accountDesc = accountNumber + '-' + accountNameTh;
                    }else{
                       var accountDesc = accountNumber + '-' + accountName;  
                    }
                       
                        accountList.push({
                            key: accountNumber, 
                            value: accountDesc}); 
                    }

               	component.set("v.AccountObject", result);
                component.set("v.AccountMap", accountList);
           }
             else if(state == "ERROR"){
                var errors = response.getError();                       
                    component.set("v.showErrors",true);
                    component.set("v.errorMessage",errors[0].message);
                alert(errors);
            }
        });
            $A.enqueueAction(action);*/
    },
     getAccWhenSelectedSalesGp :function(component, event, helper) {
       var selectedSalesOrg = component.get("v.selectedSalesOrg");
       var selectedSalesGroup = component.get("v.selectedSalesGroup");
         var action = component.get("c.getAccountList");
        	action.setParams({
            "selectedSalesOrg": selectedSalesOrg,
            "selectedSalesGroup": selectedSalesGroup
         });
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var result =response.getReturnValue();
             //  alert('test---'+result)
               var accountList = [];
                for(var key in result){

                    	var accountNumber = result[key]['AccountNumber__c']; 
                        var accountName = result[key]['CompanyNameEN__c'];
                    	var accountNameTh = result[key]['Name'];
                    if(result[key]['CompanyNameEN__c']==='' || result[key]['CompanyNameEN__c']===null || result[key]['CompanyNameEN__c']=== undefined){
                         var accountDesc = accountNumber + '-' + accountNameTh;
                    }else{
                       var accountDesc = accountNumber + '-' + accountName;  
                    }
                       
                        accountList.push({
                            key: accountNumber, 
                            value: accountDesc}); 
                    }

               	component.set("v.AccountObject", result);
                component.set("v.AccountMap", accountList);
           }
             else if(state == "ERROR"){
                var errors = response.getError();                       
                    component.set("v.showErrors",true);
                    component.set("v.errorMessage",errors[0].message);
                alert(errors);
            }
        });
            $A.enqueueAction(action);
    },
})