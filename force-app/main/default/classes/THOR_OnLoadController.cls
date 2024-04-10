public class THOR_OnLoadController {
    
    @AuraEnabled
    public static boolean isRedirected(){
        try  {
            Profile userProfile = [SELECT Name FROM Profile WHERE id =: UserInfo.getProfileId()];
            List<THOR_Global_Search_Profile__mdt>profileList = [SELECT MasterLabel FROM THOR_Global_Search_Profile__mdt];
            boolean isChecked = false;
            
            system.debug('userProfile.Name--'+userProfile.Name);
            for(THOR_Global_Search_Profile__mdt p : profileList)
            {
                system.debug('p.MasterLabel--'+p.MasterLabel);
                if(p.MasterLabel == userProfile.Name)
                {
                    isChecked = true;
                    break;
                }
            }
            return isChecked;
        } 
        catch (Exception e) 
        {
            System.debug('THOR_OnLoadController---' + e.getMessage() + e.getLineNumber());
            return false;
        }
    }

    @AuraEnabled
    public static Object redirectToRecordDisplay(){
        try  {
            Profile userProfile = [
                SELECT 
                    Name 
                FROM Profile 
                WHERE id =: UserInfo.getProfileId()
            ];

            List<THOR_Global_Search_Profile__mdt> profileList = [
                SELECT 
                    MasterLabel, 
                    Notification_Record_Display__c, 
                    Order_Record_Display__c, 
                    Work_Clearance_Record_Display__c 
                FROM THOR_Global_Search_Profile__mdt
            ];

            Map<String, String> redirectUrl = null;
            for(THOR_Global_Search_Profile__mdt p : profileList) {
                if(p.MasterLabel == userProfile.Name) {
                    redirectUrl = new Map<String, String>();
                    redirectUrl.put('Notification_Record_Display__c', p.Notification_Record_Display__c);
                    redirectUrl.put('Order_Record_Display__c', p.Order_Record_Display__c);
                    redirectUrl.put('Work_Clearance_Record_Display__c', p.Work_Clearance_Record_Display__c);
                    break;
                }
            }
            return redirectUrl;
        } 
        catch (Exception e)  {
            System.debug('THOR_OnLoadController---' + e.getMessage() + e.getLineNumber());
            return null;
        }
    }

    @AuraEnabled
    public static String checkNotiOrder(String recordId){
        String linkk;
        try {
            boolean ischeck = isRedirected();
            if(ischeck) {
                Work_Clearance__c wc = [
                SELECT Notification__c, Order__c
                FROM Work_Clearance__c 
                WHERE Id =: recordId 
                LIMIT 1
            ];
            system.debug('----'+wc);
            if (wc.Notification__c != Null){
                linkk = '/lightning/cmp/c__THOR_NotificationRecordDisplay?c__recordId='+ wc.Notification__c + '&c__backToTabIndex=1' + '&c__tab=WorkClearance';
            }else if (wc.Order__c != Null){
                linkk = '/lightning/cmp/c__THOR_OrderRecordDisplay?c__recordId='+ wc.Order__c + '&c__backToTabIndex=1' + '&c__tab=WorkClearance';
            }
            }
            return linkk;
        } catch (Exception e) {
            System.debug('THOR_OnLoadController---' + e.getMessage() + e.getLineNumber());
            return null;
        }
    }
}