/* Class for PageLink Button */
public with sharing class PageLinkController {

    @auraEnabled
    public static string gotoProjectRoadmap(Id ProjectId) {
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        string roadmapUrl = '';
        
        string userTheme = UserInfo.getUiTheme();
        
        if(userTheme == 'Theme4d') {
            roadmapUrl = baseUrl + 'one/one.app#/alohaRedirect/apex/ProjectRoadmap_VFPage?ProjectId=' + ProjectId;
        }
        else if(userTheme == 'Theme4t') {
            roadmapUrl = '/apex/ProjectRoadmap_VFPage?ProjectId=' + ProjectId;
        }
        
        return roadmapUrl;
    }
    
    @auraEnabled
    public static string gotoWorkProcessGroup(Id ProjectId) {
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        string workProcessGroupUrl = '';
        
        string userTheme = UserInfo.getUiTheme();
        
        if(userTheme == 'Theme4d') {
            workProcessGroupUrl = baseUrl + 'one/one.app#/alohaRedirect/apex/WorkProcessGroup_VFPage?ProjectId=' + ProjectId;
        }
        else if(userTheme == 'Theme4t') {
            workProcessGroupUrl = '/apex/WorkProcessGroup_VFPage?ProjectId=' + ProjectId;
        }
        
        return workProcessGroupUrl;
    }
    
}