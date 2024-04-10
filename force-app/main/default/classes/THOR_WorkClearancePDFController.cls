public with sharing class THOR_WorkClearancePDFController {
    public Id wcId { get; set; }
    public String urlImg { get; set; }
    public Work_Clearance__c wc { get; set; }
    public THOR_WorkClearancePDFController() {
        wcId = apexpages.currentpage().getparameters().get('id');
        wc = [
                SELECT
                    Id,
                    Name,
                    Work_Clearance__c,
                    Functional_Location__c,
                    Description__c,
                    Priority__c,
                    Main_Work_Center__r.Name,
                    Requester__c,
                    Notification__r.Name,
                    Area__c,
                    Maintenance_Unit__c,
                    Problem__c,
                    Work_Detail__c,
                    Thaioil_Supervisor_Indicator__c,
                    Telephone_No__c,
                    Applicant_or_Bearer__c,
                    Telephone_No_2__c,
                    Bearer1__c,
                    Bearer2__c,
                    Bearer3__c,
                    Can_go_wrong1__c,
                    Can_go_wrong2__c,
                    Can_go_wrong3__c,
                    Can_go_wrong4__c,
                    Cause1__c,
                    Cause2__c,
                    Cause3__c,
                    Cause4__c,
                    Prevent1__c,
                    Prevent2__c,
                    Prevent3__c,
                    Prevent4__c,
                    Authorized_Signature__c,
                    Check_Date__c,
                    Check_Time__c,
                    Extend_Time_To__c,
                    Close_Applicant_or_Bearer__c,
                    Extend_Applicant_or_Bearer__c,
                    Extend_Authorized_Sign__c,
                    Close_Authorized_Sign_off__c,
                    Sign_off_Flag__c,
            		Priority_Map__c,
            		Extend_Time_Flag__c,
                    Extend_Time_Flag_Formula__c,
                    Sign_off_Flag_Formula__c,
                    Authorized_Indicator__c
                FROM Work_Clearance__c
                WHERE Id = :wcId
                ORDER BY LastModifiedDate DESC LIMIT 1
            ];
        urlImg = 'https://www.webarcode.com/barcode/image.php?code=' 
                 + wc.Name + 
                 '&amp;type=C128B&xres=3&amp;font=3&amp;output=png&amp;style=68';
        String myGeneratedFileName = wc.Name + '.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename); 
    }
}