public without sharing class OPP_CalloutPMAssetService extends MethodUtils{
    public static Map<String, Object> calloutITAsset(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OPP_ITAsset');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setTimeout(120 * 1000);
        HttpResponse response;
        try{ 
            response = http.send(request);
            if(response == null)  return new Map<String, Object>();
            return (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }catch (Exception e){
            System.debug(System.LoggingLevel.ERROR, e.getmessage());
        }
        return new Map<String, Object>();
    }
       
    public static Map<String, Object> calloutSoftwareAsset(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OPP_SoftwareAsset');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setTimeout(120 * 1000);
        HttpResponse response;
        try{ 
            response = http.send(request);
            if(response == null)  return new Map<String, Object>();
            return (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }catch (Exception e){
            System.debug(System.LoggingLevel.ERROR, e.getmessage());
        }
        return new Map<String, Object>();
    }

    public static Map<String, Object> calloutUpdateDataAsset(PISUsers__c pisUser, OPP_Case_Line_Items__c caseLineItem){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OPP_UpdateDataAsset');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setTimeout(120 * 1000);
        request.setBody(JSON.serializePretty(new Map<String, Object>{
            'email' => pisUser.Email__c,
            'WinNo' => caseLineItem.New_WinNo__r.WinNo_Reference_key__c,
            'OldWinNo' => caseLineItem.OPP_IT_Asset__r.WinNo_Reference_key__c,
            'IsForceChange' => caseLineItem.IsForceChange__c,
            'CaseLineItemID' => caseLineItem.Id,
            'StartDate' => caseLineItem.Case__r.Borrow_Period_Start_date__c != null 
                ? Datetime.newInstance(
                    caseLineItem.Case__r.Borrow_Period_Start_date__c.year(), 
                    caseLineItem.Case__r.Borrow_Period_Start_date__c.month(), 
                    caseLineItem.Case__r.Borrow_Period_Start_date__c.day()).format('dd/MM/yyyy')
                : null, // Borrow Start Date
            'EndDate' => caseLineItem.Case__r.Borrow_Period_End_date__c != null
                ? Datetime.newInstance(
                    caseLineItem.Case__r.Borrow_Period_End_date__c.year(), 
                    caseLineItem.Case__r.Borrow_Period_End_date__c.month(), 
                    caseLineItem.Case__r.Borrow_Period_End_date__c.day()).format('dd/MM/yyyy')
                : null// Borrow End Date
            }));
        // System.debug(System.LoggingLevel.ERROR, request.getBody());
        HttpResponse response;
        try { 
            response = http.send(request);
            Map<String, Object> result = new Map<String, Object>{
                'RequestBody' => (Map<String, Object>)JSON.deserializeUntyped(request.getBody())
            };
            if(response != null && response?.getStatusCode() == 200){
                result.put('ReponseBody', (Map<String, Object>)JSON.deserializeUntyped(response.getBody()));
            }
            return result;
        }catch (Exception e){
            System.debug(System.LoggingLevel.ERROR, e.getmessage());
        }
        return new Map<String, Object>();
    }
}