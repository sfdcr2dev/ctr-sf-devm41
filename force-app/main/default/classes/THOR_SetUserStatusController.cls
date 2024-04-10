/**
 * @author Oktana
 * @description controller for THOR_SetUserStatus Component
 */
public with sharing class THOR_SetUserStatusController {
    /**
     * @description retrieves availabel user status for notifications
     * @return List<UserStatusDTO>
     */
    @AuraEnabled
    public static List<UserStatusDTO> retrieveUserStatusForNotification(String notificationType) {
        List<UserStatusDTO> res = new List<UserStatusDTO>();

        Master_Map__c mmTemp = null;

        List<Master_Map__c> masterMapListTemp = [
            SELECT Id, RelatedMasterMap2__r.Name
            FROM Master_Map__c
            WHERE Type__c = 'NotificationTypewithStatusProfile' AND RelatedMasterMap1__r.Name = :notificationType
            LIMIT 1
        ];

        if (masterMapListTemp.size() > 0) {
            mmTemp = masterMapListTemp[0];

            masterMapListTemp = [
                SELECT
                    Id,
                    RelatedMasterMap2__r.Name,
                    RelatedMasterMap2__r.Description__c,
                    RelatedMasterMap2__r.Type__c
                FROM Master_Map__c
                WHERE
                    Type__c = 'NotificationStatusProfileWithUserStatus'
                    AND RelatedMasterMap1__r.Name = :mmTemp.RelatedMasterMap2__r.Name
            ];

            for (Master_Map__c mm : masterMapListTemp) {
                if (mm.RelatedMasterMap2__r.Type__c.equals('NotificationUserStatus')) {
                    UserStatusDTO userStatusDTO = new UserStatusDTO();
                    userStatusDTO.name = mm.RelatedMasterMap2__r.Name;
                    userStatusDTO.description = mm.RelatedMasterMap2__r.Description__c;

                    res.add(userStatusDTO);
                }
            }
        }

        return res;
    }

    /**
     * @description retrieves availabel user status for orders
     * @return List<UserStatusDTO>
     */
    @AuraEnabled
    public static List<UserStatusDTO> retrieveUserStatusForOrder(String orderType) {
        List<UserStatusDTO> res = new List<UserStatusDTO>();

        Master_Map__c mmTemp = null;

        List<Master_Map__c> masterMapListTemp = [
            SELECT Id, RelatedMasterMap2__r.Name
            FROM Master_Map__c
            WHERE Type__c = 'OrderTypewithStatusProfile' AND RelatedMasterMap1__r.Name = :orderType
            LIMIT 1
        ];

        System.debug('masterMapListTemp1');
        System.debug(masterMapListTemp);

        if (masterMapListTemp.size() > 0) {
            mmTemp = masterMapListTemp[0];

            masterMapListTemp = [
                SELECT Id, RelatedMasterMap2__r.Name, RelatedMasterMap2__r.Description__c, RelatedMasterMap2__r.Type__c
                FROM Master_Map__c
                WHERE
                    Type__c = 'OrderStatusProfileWithUserStatus'
                    AND RelatedMasterMap1__r.Name = :mmTemp.RelatedMasterMap2__r.Name
                    AND Status_Number__c = ''
            ];

            System.debug('masterMapListTemp2');
            System.debug(masterMapListTemp);

            for (Master_Map__c mm : masterMapListTemp) {
                System.debug('mm');
                System.debug(mm);
                if (mm.RelatedMasterMap2__r.Type__c.equals('OrderUserStatus')) {
                    UserStatusDTO userStatusDTO = new UserStatusDTO();
                    userStatusDTO.name = mm.RelatedMasterMap2__r.Name;
                    userStatusDTO.description = mm.RelatedMasterMap2__r.Description__c;

                    res.add(userStatusDTO);
                }
            }
        }
        return res;
    }

    /**
     * @author Oktana
     * @description user status name and description DTO
     */
    public class UserStatusDTO {
        @AuraEnabled
        public String name { get; set; }

        @AuraEnabled
        public String description { get; set; }
    }
}