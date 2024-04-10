@RestResource(urlMapping='/ODM_REST_IN_Nofication/*')

global class ODM_REST_IN_Nofication 
{
    global class NotificationInputWrapper
    {
        String WNStartDateTime = '';
        String WNEndDateTime = '';
        String Mainworkcenter = '';
        String FunctionalLocation = '';
        String WNType = '';
        String WNDescription = '';
        String SystemStatus = '';
    }
    global class NotificationWrapper
    {
        
        String WNDateTime = '';
        String WNNumber = ''; //15 or 18
        String WNType = '';
        String WNDescription = '';
        String FunctionalLocation = '';
        String FLDescription = '';
        String Mainworkcenter = '';
        String Plant = '';
        String RequiredStartdate= '';
        String LastModifiedDate= '';
        String SystemStatus = '';
    }
    global class ResponseWrapper
    {
        List<NotificationWrapper> notiWrapperList;
        String messagetype = '';
        String messagetext = '';
    }
    
    @HttpPost
    global static ResponseWrapper NotiPost(NotificationInputWrapper SAPNoti) 
    {
        try
        {
            List<String> wherefield = new List<String>();
            Date startdate;
            Date enddate;
            DateTime startdatetime;
            DateTime enddatetime;
            String Mainworkcenter = '';
            String FunctionalLocation = '';
            String WNType = '';
            String WNDescription = '';
            String SystemStatus = '';
            boolean checkAND = false;
            if(SAPNoti.WNStartDateTime!= null && SAPNoti.WNStartDateTime != '')
            {
                startdate = Date.parse(SAPNoti.WNStartDateTime);
                startdatetime = DateTime.newInstance(startdate.year(), startdate.month(), startdate.day(), 00, 00, 00);
				wherefield.add('LastModifiedDate >=:startdatetime');
               
            }  
            if(SAPNoti.WNEndDateTime!= null && SAPNoti.WNEndDateTime != ''  )
            {
                enddate = Date.parse(SAPNoti.WNEndDateTime);
                enddatetime = DateTime.newInstance(enddate.year(), enddate.month(), enddate.day(), 23, 59, 59);
                wherefield.add('LastModifiedDate <=:enddatetime');
            } 
            if(SAPNoti.Mainworkcenter != null && SAPNoti.Mainworkcenter != '')
            {
                String mainworkcenterString = SAPNoti.Mainworkcenter;
                wherefield.add('Main_Work_Center_Text__c =:mainworkcenterString');
            }
            if(SAPNoti.FunctionalLocation != null && SAPNoti.FunctionalLocation != '')
            {
                String FLString = SAPNoti.FunctionalLocation ;
                wherefield.add('Functional_Location_Text__c =:FLString');
            }
            if(SAPNoti.WNType != null && SAPNoti.WNType != '')
            {
                String WNTypeString = SAPNoti.WNType ;
                wherefield.add('Type__c =:WNTypeString');
            }
            if(SAPNoti.WNDescription != null && SAPNoti.WNDescription != '')
            {
                String WNDescriptionString = SAPNoti.WNDescription ;
                wherefield.add('Description__c =:WNDescriptionString');
            }
            if(SAPNoti.SystemStatus != null && SAPNoti.SystemStatus != '')
            {
                String SystemStatusString = SAPNoti.SystemStatus ;
                wherefield.add('System_Status_Text__c =:SystemStatusString');
            }
            String whereclause = String.join(wherefield, ' AND ');
            String selection = 'SELECT id, LastModifiedDate,Notification_Number__c,Type__c, Description__c, Functional_Location_Text__c, Functional_Location__r.Description__c,mainWorkCenterPlantText__c,Required_Start__c, System_Status_Text__c ,Main_Work_Center_Text__c FROM Notification__c WHERE ';
            String query = selection + whereclause;
            system.debug('query--'+query);
            List<Notification__c>notificationList = Database.query(query);
            System.Debug('notificationList>> '+notificationList);
            /*
            List<Notification__c>notificationList = [SELECT id, LastModifiedDate,Notification_Number__c,  
                                                     Type__c, Description__c, Functional_Location_Text__c, Functional_Location__r.Description__c,  
                                                     mainWorkCenterPlantText__c,Required_Start__c, System_Status_Text__c ,Main_Work_Center_Text__c 
                                                     FROM Notification__c WHERE  LastModifiedDate >=:startdatetime AND LastModifiedDate <=: enddatetime AND Type__c ='OP'];
            system.debug('notificationList:'+ notificationList);
            system.debug('startdatetime:'+ startdatetime);
            system.debug('enddatetime:'+ enddatetime);
            */
            List<NotificationWrapper> notiWrapList = new List<NotificationWrapper>();
            for (Notification__c noti: notificationList) {
                
                NotificationWrapper notiWrapper = new NotificationWrapper();
                
                if(noti.LastModifiedDate!= null)
                {
                    notiWrapper.WNDateTime = String.valueof(noti.LastModifiedDate);
                    notiWrapper.LastModifiedDate = String.valueof(noti.LastModifiedDate);
                }    
                notiWrapper.WNType = noti.Type__c!= null && noti.Type__c != '' ? noti.Type__c :'';
                notiWrapper.WNNumber = noti.Notification_Number__c!= null && noti.Notification_Number__c != '' ? noti.Notification_Number__c : '';
                notiWrapper.WNDescription = noti.Description__c!= null && noti.Description__c != '' ? noti.Description__c : '';
                notiWrapper.FunctionalLocation = noti.Functional_Location_Text__c!= null && noti.Functional_Location_Text__c != '' ? noti.Functional_Location_Text__c : '';
                notiWrapper.FLDescription = noti.Functional_Location__r.Description__c!= null && noti.Functional_Location__r.Description__c != '' ? noti.Functional_Location__r.Description__c : '';
                notiWrapper.Plant = noti.mainWorkCenterPlantText__c!= null && noti.mainWorkCenterPlantText__c != '' ? noti.mainWorkCenterPlantText__c : '';
                notiWrapper.Mainworkcenter = noti.Main_Work_Center_Text__c != null && noti.Main_Work_Center_Text__c != '' ? noti.Main_Work_Center_Text__c : '';
                notiWrapper.SystemStatus = noti.System_Status_Text__c != null && noti.System_Status_Text__c != '' ? noti.System_Status_Text__c : '';
                notiWrapper.RequiredStartdate = noti.Required_Start__c!= null ? String.valueOf(noti.Required_Start__c) : null;

                if (notiWrapper.WNNumber.length() != 15 && notiWrapper.WNNumber.length() != 18 ){
                    notiWrapList.add(notiWrapper);
                }
                
            }
            
            ResponseWrapper success = new ResponseWrapper();
            success.notiWrapperList = notiWrapList;
            success.messagetype = 'Success';
            success.messagetext = 'Success';
            
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Return';
            log.Integration_Name__c = 'ODM_REST_IN_Nofication';
            log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
            log.Message_Type__c = 'Success';
            log.Request_Body__c =  JSON.serialize(SAPNoti).left(131072);
            log.Response_Body__c = JSON.serialize(success).left(131072);
            log.OwnerId = UserInfo.getUserId();
            insert log;
            
            return success;
            /*
else{ //fail in case not send startDate & endDate

ResponseWrapper error = new ResponseWrapper();
error.messagetype = 'ERROR';
error.messagetext = 'Missing startDate or endDate';

Application_Log__c log = new Application_Log__c();
log.Method__c = 'Return';
log.Integration_Name__c = 'ODM_REST_IN_Nofication ';
log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
log.Request_Body__c =  JSON.serialize(SAPNoti);
log.Response_Body__c = JSON.serialize(error);
log.Message_Type__c = 'Fail';
log.OwnerId = UserInfo.getUserId();
insert log;


return error;
}*/
        }
        catch (Exception e){
            
            ResponseWrapper error = new ResponseWrapper();
            error.messagetype = 'ERROR';
            error.messagetext = e.getMessage() + ' line :'+e.getLineNumber();
            
            
//            system.debug('ODM_REST_IN_Nofication----'+e.getMessage() + 'Line : '+e.getLineNumber());
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Return';
            log.Integration_Name__c = 'ODM_REST_IN_Nofication';
            log.Log_Type__c = 'Inbound from SAP - Salesforce generate.';
            log.Request_Body__c =  JSON.serialize(SAPNoti).left(131072);
            log.Response_Body__c = JSON.serialize(error).left(131072);
            log.Message_Type__c = 'Fail';
            
            log.OwnerId = UserInfo.getUserId();
            insert log;
            
            
            return error;
        }
    }
}