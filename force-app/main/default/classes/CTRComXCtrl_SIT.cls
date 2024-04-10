public class CTRComXCtrl_SIT {
// public static void calloutBI(string endPoint){
//         // Create test data for CTRRequestFormItem__c, Account, and RecordType objects
//         List<CTRRequestFormItem__c> requestItems = new List<CTRRequestFormItem__c>();
        
//         // Populate requestItems with test data
//         CTRRequestFormItem__c newItem = new CTRRequestFormItem__c();
//         newItem.Name = 'Test SoapApi 1-1';
//         newItem.RecordTypeId = '012H4000000VReEIAW'; // Assuming you have a valid RecordType Id
//         newItem.SAPStatus__c = 'SAP Confirmed General View';
//         newItem.Customer__c = '001H4000004cuJqIAI'; // Assuming you have a valid Account Id
        
//         // Add the test record to the list
//         requestItems.add(newItem);
        
//         // Insert the test data
//         insert requestItems;
        
//         // Now, you need to construct the oldRequestItemMap and newRequestItemMap
//         Map<Id, CTRRequestFormItem__c> oldRequestItemMap = new Map<Id, CTRRequestFormItem__c>();
//         Map<Id, CTRRequestFormItem__c> newRequestItemMap = new Map<Id, CTRRequestFormItem__c>();
        
//         // Populate oldRequestItemMap and newRequestItemMap with appropriate data
        
//         CTRRequestFormItem__c newItem1 = new CTRRequestFormItem__c(
//             Name = 'Test SoapApi 1-2',
//             RecordTypeId = '012H4000000VReEIAW', // Assuming you have a valid RecordType Id
//             SAPStatus__c = 'SAP Confirmed Sales/Purchasing View'
//             //Customer__c = ' 001H4000004cuJlIAI' // Assuming you have a valid Account Id
//         );
        
//         // Assuming newItem has been modified and is to be placed in newRequestItemMap
//         newRequestItemMap.put(newItem1.Id, newItem1);
        
//         // Call the method pickOutData with the created maps
//         CTRCalloutComXCtrl.pickOutData(oldRequestItemMap, newRequestItemMap);
//     }
    
//     public static void callRestApiCreate(){
//         CTRRequestFormItem__c lRequestItem =[SELECT RecordTypeId,Id, Approval_TRCRSubmitDate__c,ApproveDueDiligenceBy__r.Name, Customer__r.SFCode__c,SalesOrganization__c ,
//                                                         CTRRequestFormHeader__r.CompanyNameLocal__c,CTRRequestFormHeader__r.CompanyNameENF__c, CTRRequestFormHeader__r.Country__r.Description__c, 
//                                                         CTRRequestFormHeader__r.DistrictLocal__r.Description__c,CTRRequestFormHeader__r.PostalCodeLocalText__c, CTRRequestFormHeader__r.StreetLocal__c,
//                                                         CTRRequestFormHeader__r.HousenoLocal__c,CTRRequestFormHeader__r.Country__r.Code__c,CTRRequestFormHeader__r.Phone__c,CTRRequestFormHeader__r.TaxCode1__c,
//                                                         CTRRequestFormHeader__r.AccountGroup__c, Approval_TraderSubmitDate__c,CreatedBy.Name
//                                                         FROM CTRRequestFormItem__c 
//                                                         LIMIT 1];
//         CTRCalloutComXCtrl.organizeData(lRequestItem.Id);
//     }
}