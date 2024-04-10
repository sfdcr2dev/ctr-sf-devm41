({
	   getAccount : function(component, event){
        var action = component.get("c.getAccountList");
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var result =response.getReturnValue();
             //  alert('test---'+result)
               var accountList = [];
                for(var key in result){
                   
                   // if(result[key]['AccountNumber__c']){  
                    	var accountNumber = result[key]['AccountNumber__c']; 
                        var accountName = result[key]['CompanyNameEN__c'];
                    	var accountNameTh = result[key]['Name'];
                   // }
                    if(result[key]['CompanyNameEN__c']==='' || result[key]['CompanyNameEN__c']===null || result[key]['CompanyNameEN__c']=== undefined){
                         var accountDesc = accountNumber + '-' + accountNameTh;
                    }else{
                       var accountDesc = accountNumber + '-' + accountName;  
                    }
                       
                        accountList.push({
                            key: accountNumber, 
                            value: accountDesc}); 
                    }
                    //n = n+1;
               // }
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
    
     getSalesOrg: function(component, event){
        var action = component.get("c.getAccountList");
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var returnValue =response.getReturnValue();
               //alert('test---'+returnValue)
 	     		 component.set("v.SalesOgr", returnValue);
               //alert('test--2-'+component.get("v.isManager"))
           }
        });
            $A.enqueueAction(action);
  	  },
    
        getSalesGroup: function(component, event){
        var action = component.get("c.getSalesGroup");
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") { 
               var returnValue =response.getReturnValue();
 	     		 component.set("v.salesGrouplist", returnValue);
           }
        });
            $A.enqueueAction(action);
  	  },
    
      getBu: function(component, event){
        var action = component.get("c.getBu");
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var returnValue =response.getReturnValue();
               //alert('test---'+JSON.stringify(returnValue));
 	     		 component.set("v.Bu", returnValue);
               //alert('test--2-'+component.get("v.isManager"))
           }
        });
            $A.enqueueAction(action);
  	  },
    
      getYear: function(component, event){
        var action = component.get("c.getYear");
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var returnValue =response.getReturnValue();
 	     		 component.set("v.Yearlist", returnValue);
           }
        });
            $A.enqueueAction(action);
  	  },
    
      getSalesSummary: function(component, event){
        var action = component.get("c.getSalesSummaryMonth");
        action.setCallback(this, function(response) { 
              var state = response.getState();
           if (state === "SUCCESS") {
               
               var result =response.getReturnValue();
               //alert('test---'+returnValue)
 	     		var SalesSummarys = [];
               
                 for(var key in result){
                       SalesSummarys.push({key});  
                  }
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