/**
 * Integration Controller
 */
@RestResource(urlMapping='/ESSMSS_EmployeeHotel/*')

global class ESSRESTOUTEmpHtlCtrl {

    global class EmployeeHotelWrapper{
        String employeeId;
    }

    global class ResponseWrapper{
        List<String> employeeHotelResponseWrapperList;
        String messagetype = '';
        String messagetext = '';
    }

    @HttpPost
    global static ResponseWrapper employeeHotelPost()
    {
        /** query and conditiion >> ESS_Master_Employee__c*/
        String selectionMasterEmp = 'SELECT Employee_Id__c  FROM ESS_Master_Employee__c '; 
        /**  query database */
        List<ESS_Master_Employee__c> employeeHotelList = Database.query(selectionMasterEmp);

        Map<String,String> empIdMap = new Map<String,String>();
        List<String> employeeHotelWrapperList = new List<String>();
        
        /** check (1)item are in MAP (2)emp id must not null/empty (3)add to Map<> and get Map<> to List*/
        for(ESS_Master_Employee__c empId : employeeHotelList){
            /*EmployeeHotelWrapper empHtlWrp = new EmployeeHotelWrapper();
            empHtlWrp.employeeId = empId.Employee_Id__c;*/

            if (empId.Employee_Id__c != null && empId.Employee_Id__c != '') {
                empIdMap.put(empId.Employee_Id__c,empId.Employee_Id__c);
            }
        }

        ResponseWrapper success = new ResponseWrapper();
        success.employeeHotelResponseWrapperList = empIdMap.values();
        success.messagetype = 'Success';
        success.messagetext = 'ESSMSS_EmployeeHotel integration success';
        
        Application_Log__c log = new Application_Log__c();
        log.Method__c = 'Update';
        log.Integration_Name__c = 'ESSMSS_EmployeeHotel';
        log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
        log.Message_Type__c = 'Success';
        log.Response_Body__c = JSON.serialize(success).left(100000);
        log.OwnerId = UserInfo.getUserId();
        insert log;

        return success;           
        /*} catch (Exception e) {
            ResponseWrapper error = new ResponseWrapper();
            error.messagetype = 'ERROR';
            error.messagetext = e.getMessage() + ' line :'+e.getLineNumber();

            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Update';
            log.Integration_Name__c = 'ESSMSS_EmployeeHotel';
            log.Log_Type__c = 'Inbound from SAP - Salesforce generate.';
            // log.Request_Body__c =  JSON.serialize().left(131072);
            log.Response_Body__c = JSON.serialize(error).left(131072);
            log.Message_Type__c = 'Fail';
            log.OwnerId = UserInfo.getUserId();
            insert log;
            return error;
        }*/
    }
}