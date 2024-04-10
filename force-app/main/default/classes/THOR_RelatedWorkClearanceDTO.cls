/**
* @author Alejandro Lugo
* @description Data Transfer Object used to transfer data to THOR_NotificationRelatedWorkClearance.cmp
*/
public with sharing class THOR_RelatedWorkClearanceDTO {

    /**
     *@description id of the Work Clearance
     */
    @AuraEnabled
    public Id workClearanceId {get;set;}

    /**
     *@description name of the Work Clearance
     */
    @AuraEnabled
    public String workClearanceName {get;set;}

    /**
     *@description external Id of the Work Clearance
     */
    @AuraEnabled
    public String workClearance {get;set;}

    /**
     *@description name of the Functional Location
     */
    @AuraEnabled
    public String workClearanceFunctionalLocation {get;set;}

    /**
     *@description description of the Work Clearance
     */
    @AuraEnabled
    public String workClearanceDescription {get;set;}

    /**
     *@description priority of the Work Clearance
     */
    @AuraEnabled
    public String workClearancePriority {get;set;}

    /**
     *@description name of the Main Work Center related to the Work Clearance
     */
    @AuraEnabled
    public String workClearanceMainWorkCenter {get;set;}
    
    /**
     * @description related Files to the Work Clearance
     */
    @AuraEnabled
    public List<ContentDocumentLink> workClearanceFiles {get; set;}

    /**
     * @description Future work clearance files to show
     */

    public THOR_RelatedWorkClearanceDTO(){
        workClearanceFiles = new List<ContentDocumentLink>();
    }
}