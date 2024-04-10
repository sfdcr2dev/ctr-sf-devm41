/* 
 * Author Softever
 */

public with sharing class CG_NotiController {

    public static void SendBellNoti(CG_DTO.BellNotiDTO BellNoti) {
        
        //Send Bell Noti
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName =: BellNoti.NotificationName];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = BellNoti.Title;
        string body = BellNoti.Body;
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
        
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        //customNoti.setTargetId(BellNoti.RecordId);
        customNoti.setTargetPageRef(BellNoti.PageRef);
              
        Set<String> receivers = new Set<String>();
        
        //Owner
        //receivers.add(CGReport.OwnerId);
        receivers = BellNoti.Receivers;
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    } 
    
    public static void SendBellNoti(CG_DTO.BellNotiDTO BellNoti, CustomNotificationType notificationType) {
        
        //Send Bell Noti
        //CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
        //                       			 			WHERE DeveloperName =: BellNoti.NotificationName];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = BellNoti.Title;
        string body = BellNoti.Body;
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
        
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        //customNoti.setTargetId(BellNoti.RecordId);
        customNoti.setTargetPageRef(BellNoti.PageRef);
              
        Set<String> receivers = new Set<String>();
        
        //Owner
        //receivers.add(CGReport.OwnerId);
        receivers = BellNoti.Receivers;
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    } 
    
    public static void SendOppNoti(CG_DTO.OppNotiDTO OppNoti) {
        
        //Send to Opp Notification
        OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];
        
        Opp_Notification__c CGOpp = new Opp_Notification__c();
        CGOpp.Application__c = CGApp.Id;
        CGOpp.User__c = OppNoti.ApproverId;
        CGOpp.Subject__c = OppNoti.Subject;
        CGOpp.Description__c = OppNoti.Description;
        CGOpp.Requester__c = OppNoti.RequesterName;
        CGOpp.Status__c = OppNoti.Status;
        CGOpp.URL__c = OppNoti.URL;
        CGOpp.ReferenceID__c = OppNoti.ReferenceId;
        insert(CGOpp);
        
        /* CGOpp.Application__c = TOPPMPApp.Id;
        CGOpp.User__c = approveUserId;
        CGOpp.Subject__c = 'Following Step ' + stepName + ' for Project ' + projectName + ' has submitted for approve.';
        CGOpp.Description__c = '';
        CGOpp.Requester__c = requesterName;
        CGOpp.Status__c = 'New';
        CGOpp.URL__c = baseUrl + '/lightning/r/' + recordId + '/view';
        CGOpp.ReferenceID__c = recordId;
        insert(CGApp); */
        
    }
    
    public static Opp_Notification__c SaveOppNoti(CG_DTO.OppNotiDTO OppNoti) {
        
        Opp_Notification__c CGOpp = new Opp_Notification__c();
        CGOpp.Application__c = OppNoti.ApplicationId;
        CGOpp.User__c = OppNoti.ApproverId;
        CGOpp.Subject__c = OppNoti.Subject;
        CGOpp.Description__c = OppNoti.Description;
        CGOpp.Requester__c = OppNoti.RequesterName;
        CGOpp.Status__c = OppNoti.Status;
        CGOpp.URL__c = OppNoti.URL;
        CGOpp.ReferenceID__c = OppNoti.ReferenceId;
        
        return CGOpp;
    }
    
    public static void UpdateOppNoti(Id recordId) {
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        List<Opp_Notification__c> CGApps = [select id, name, ReferenceID__c from Opp_Notification__c where ReferenceID__c =: recordId];
        
        if(CGApps.size() > 0) {
            for(Opp_Notification__c OppNoti : CGApps) {
                OppNoti.Status__c = 'Approved';
        		update(OppNoti);
            }
        }
        
    }
    
    public static void UpdateOppNotiWhenUserAction(Id recordId, Id userId, string status) {
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        List<Opp_Notification__c> CGApps = [select id, name, ReferenceID__c, User__c, Status__c from Opp_Notification__c where ReferenceID__c =: recordId AND User__c = :userId];
        
        if(CGApps.size() > 0) {
            for(Opp_Notification__c OppNoti : CGApps) {
                OppNoti.Status__c = status;
        		database.update(OppNoti, true);
            }
        }
        
    }
}