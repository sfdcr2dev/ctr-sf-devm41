/**
 * @author Oktana
 * @description handles Item related actions
 */
public with sharing class THOR_ItemController {
    /**
     * @description retrieves causes filered by Item
     * @param item
     * @return List<THOR_ObjectCardDTO>
     */
    @AuraEnabled
    public static List<THOR_ObjectCardDTO> retrieveItemCauses(Id itemId) {
        try {
            return THOR_DTOMapper.mapCauses( [ SELECT Code_Group__r.Name, Code_in_Text_Form__c, Code_Text__c, Text__c FROM Cause__c WHERE Item__c = :itemId AND isDeleted__c = FALSE ] );
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static List<THOR_ObjectCardDTO> retrieveItemActivities(Id itemId) {
        try {
            return THOR_DTOMapper.mapActivities( [ SELECT Id, Name, Code_Group__r.Name, Code__r.Name, Text__c, Code_in_Text_Form__c, Text_of_Code__c FROM Activity__c WHERE Item__c = :itemId AND isDeleted__c = FALSE ] );
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }
    @AuraEnabled
    public static void markItemAsDeleted(Id itemId) {
        Item__c itemToMark = [SELECT Id, IsDeleted__c, Integration_Flag__c, Integration_Status__c FROM Item__c WHERE Id = :itemId LIMIT 1];
        itemToMark.IsDeleted__c = true;
        if (!(itemToMark.Integration_Flag__c == 'Created' && (itemToMark.Integration_Status__c == null || itemToMark.Integration_Status__c == 'Failed'))) {
            itemToMark.Integration_Flag__c = 'Deleted';
            itemToMark.Integration_Status__c = '';
        }
        List<Cause__c> itemCauses = markItemCausesAsDeleted(itemId);
        List<Activity__c> itemActivities = markItemActivitiesAsDeleted(itemId);
        try {
            if (Schema.sObjectType.Item__c.isUpdateable()) update itemtoMark;
            if (Schema.sObjectType.Cause__c.isUpdateable()) update itemCauses;
            if (Schema.sObjectType.Activity__c.isUpdateable()) update itemActivities;
        } catch (Exception ex) {
            throw new AuraHandledException('Something happened while deleting Item');
        }
    }
    @AuraEnabled
    public static List<THOR_ObjectCardDTO> getNotificationFromItem(Id itemId) {
        return THOR_DTOMapper.mapItems([SELECT Id, Name, Notification__c FROM Item__c WHERE Id = :itemId]);
    }
    @AuraEnabled
    public static List<Master_Map__c> getCauseCodeGroupsFiltered(String NotiId) {
        return FilterCauseCodeGroupMasterMapByEquipment(NotiId);
    }
    @AuraEnabled
    public static List<Master_Map__c> FilterCauseCodeGroupMasterMapByEquipment(String NotiId) {
        try {
            List<Master_Map__c> masters = new List<Master_Map__c>();
            masters = null;            
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];
            Master_Map__c catTypes = new Master_Map__c();
            Master_Map__c relatedMap2 = new Master_Map__c();
            List<Master_Map__c> maps = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Equipment__r.catelogProfile__c AND Type__c = 'CatalogType' AND Description__c = 'Cause' ];
            
            if (maps.isEmpty()) return FilterCauseCodeGroupMasterMapByFunctionalLocation(NotiId);

            Set<String> masterMapIds = new Set<String>();
            for (Master_Map__c m : maps) {
                masterMapIds.add(m.Id);
            }
            catTypes = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds LIMIT 1 ];
            relatedMap2 = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id = :catTypes.RelatedMasterMap2__c ];
            masters = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Code__c = :relatedMap2.Code__c AND Type__c = 'Code Group' ];           
            return ((masters != null) ? masters : FilterCauseCodeGroupMasterMapByFunctionalLocation(NotiId));
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }
    @AuraEnabled
    public static List<Master_Map__c> FilterCauseCodeGroupMasterMapByFunctionalLocation(String NotiId) {
        try {
            List<Master_Map__c> masters = new List<Master_Map__c>();
            masters = null;
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];

            Master_Map__c catTypes = new Master_Map__c();
            Master_Map__c relatedMap2 = new Master_Map__c();

            List<Master_Map__c> maps = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Functional_Location__r.catelogProfile__c AND Type__c = 'CatalogType' AND Description__c = 'Cause' ];
            if (maps.isEmpty()) return FilterCauseCodeGroupMasterMapByNothing(NotiId);

            Set<String> masterMapIds = new Set<String>();
            for (Master_Map__c m : maps) {
                masterMapIds.add(m.Id);
            }
            catTypes = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds LIMIT 1 ];
            relatedMap2 = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id = :catTypes.RelatedMasterMap2__c ];
            masters = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Code__c = :relatedMap2.Code__c AND Type__c = 'Code Group' ];
            return ((masters != null) ? masters : FilterCauseCodeGroupMasterMapByNothing(NotiId));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Master_Map__c> FilterCauseCodeGroupMasterMapByNothing(String NotiId) {
        try {
            List<Master_Map__c> masters = new List<Master_Map__c>();
            masters = null;
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];

            Master_Map__c catTypes = new Master_Map__c();
            Master_Map__c relatedMap2 = new Master_Map__c();
            List<Master_Map__c> maps = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Type__c = 'CatalogType' AND Description__c = 'Cause' ];
            
            Set<String> masterMapIds = new Set<String>();
            for (Master_Map__c m : maps) {
                masterMapIds.add(m.RelatedMasterMap2__c);
            }
            masters = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap1__c, RelatedMasterMap2__c FROM Master_Map__c WHERE Id IN :masterMapIds ];
            return masters;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Master_Map__c> getActivityCodeGroupsFiltered(String NotiId) {
        return FilterActivityCodeGroupMasterMapByEquipment(NotiId);
    }

    @AuraEnabled
    public static List<Master_Map__c> FilterActivityCodeGroupMasterMapByEquipment(String NotiId) {
        try {
            List<Master_Map__c> masters = new List<Master_Map__c>();
            masters = null;
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];
            Master_Map__c catTypes = new Master_Map__c();
            Master_Map__c relatedMap2 = new Master_Map__c();
            List<Master_Map__c> maps = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Equipment__r.catelogProfile__c AND Type__c = 'CatalogType' AND Description__c = 'Activity' ];
            if (maps.isEmpty()) return FilterActivityCodeGroupMasterMapByFunctionalLocation(NotiId);

            Set<String> masterMapIds = new Set<String>();
            for (Master_Map__c m : maps) {
                masterMapIds.add(m.Id);
            }

            catTypes = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds LIMIT 1 ];
            relatedMap2 = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id = :catTypes.RelatedMasterMap2__c ];
            masters = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Code__c = :relatedMap2.Code__c AND Type__c = 'Code Group' ];
            return ((masters != null) ? masters : FilterCauseCodeGroupMasterMapByFunctionalLocation(NotiId));
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static List<Master_Map__c> FilterActivityCodeGroupMasterMapByFunctionalLocation(String NotiId) {
        try {
            List<Master_Map__c> masters = new List<Master_Map__c>();
            masters = null;
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];

            Master_Map__c catTypes = new Master_Map__c();
            Master_Map__c relatedMap2 = new Master_Map__c();

            List<Master_Map__c> maps = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Functional_Location__r.catelogProfile__c AND Type__c = 'CatalogType' AND Description__c = 'Activity' ];
            if (maps.isEmpty()) {
                return FilterActivityCodeGroupMasterMapByNothing(NotiId);
            }

            Set<String> masterMapIds = new Set<String>();
            for (Master_Map__c m : maps) {
                masterMapIds.add(m.Id);
            }
            catTypes = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds LIMIT 1 ];
            relatedMap2 = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id = :catTypes.RelatedMasterMap2__c ];
            masters = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Code__c = :relatedMap2.Code__c AND Type__c = 'Code Group' ];
            return ((masters != null) ? masters : FilterCauseCodeGroupMasterMapByNothing(NotiId));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Master_Map__c> FilterActivityCodeGroupMasterMapByNothing(String NotiId) {
        try {
            List<Master_Map__c> masters = new List<Master_Map__c>();
            masters = null;
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];
            List<Master_Map__c> maps = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Type__c = 'Catalogtype' AND Description__c = 'Activity' ];
            Set<String> masterMapIds = new Set<String>();
            for (Master_Map__c m : maps) {
                masterMapIds.add(m.RelatedMasterMap2__c);
            }
            masters = [ SELECT Id, Name, Code__c, Description__c, Type__c, RelatedMasterMap1__c, RelatedMasterMap2__c FROM Master_Map__c WHERE Id IN :masterMapIds ];
            return masters;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteCause(String CauseId) {
        try {
            Cause__c c = [SELECT Id, IsDeleted__c, Integration_Flag__c, Integration_Status__c FROM Cause__c WHERE Id = :CauseId];
            if (c.Integration_Flag__c == 'Created' && (c.Integration_Status__c == null || c.Integration_Status__c == 'Failed')) {
                delete c;
            } else {
                c.IsDeleted__c = true;
                c.Integration_Flag__c = 'Deleted';
                c.Integration_Status__c = '';
                update c;
            }
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static void deleteActivity(String ActivityId) {
        try {
            Activity__c c = [SELECT Id, IsDeleted__c, Integration_Flag__c, Integration_Status__c FROM Activity__c WHERE Id = :ActivityId];
            if (c.Integration_Flag__c == 'Created' && (c.Integration_Status__c == null || c.Integration_Status__c == 'Failed')) {
                delete c;
            } else {
                c.IsDeleted__c = true;
                c.Integration_Flag__c = 'Deleted';
                c.Integration_Status__c = '';
                update c;
            }
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static List<Master_Map__c> getCausesFiltered(String NotiId, String codeGroupId) {
        try {
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];

            List<Master_Map__c> masters = new List<Master_Map__c>();
            List<Master_Map__c> Causemap = new List<Master_Map__c>();
            if (relatedNotification.Equipment__r.catelogProfile__c != null) {
                List<Master_Map__c> maps = [ SELECT Id, Name, Description__c, Type__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Equipment__r.catelogProfile__c ]; 
                Set<Id> masterMapIds = new Set<Id>();
                for (Master_Map__c m : maps) {
                    masterMapIds.add(m.Id);
                }
                Causemap = [ SELECT Id, Code__c, Type__c, Description__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds AND Description__c = 'Cause' ];
                
                if (!Causemap.isEmpty()) {
                    masters = [ SELECT Name, Type__c, Description__c, RelatedMasterMap1__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name FROM Master_Map__c WHERE RelatedMasterMap1__c = :Causemap.get(0).RelatedMasterMap2__c ];
                }
            } else if ( relatedNotification.Equipment__r.catelogProfile__c == null && relatedNotification.Functional_Location__r.catelogProfile__c != null ) {
                List<Master_Map__c> maps = [ SELECT Id, Name, Description__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Functional_Location__r.catelogProfile__c ];
                Set<Id> masterMapIds = new Set<Id>();
                for (Master_Map__c m : maps) {
                    masterMapIds.add(m.Id);
                }
                Causemap = [ SELECT Id, Code__c, Description__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds AND Description__c = 'Cause' ];
                if (!Causemap.isEmpty()) {
                masters = [ SELECT Name, Type__c, Description__c, RelatedMasterMap1__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name FROM Master_Map__c WHERE RelatedMasterMap1__c = :Causemap.get(0).RelatedMasterMap2__c ];
                }
            }
            if (!(masters.size() > 0)) {
                masters = [ SELECT Name, Type__c, Description__c, RelatedMasterMap1__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name FROM Master_Map__c WHERE RelatedMasterMap1__c = :codeGroupId ];
            }
            return masters;
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static List<Master_Map__c> getActivitiesFiltered(String NotiId, String codeGroupId) {
        try {
            Notification__c relatedNotification = [ SELECT Equipment__c, Equipment__r.catelogProfile__c, Functional_Location__c, Functional_Location__r.catelogProfile__c FROM Notification__c WHERE Notification__c.Id = :NotiId ];

            List<Master_Map__c> masters = new List<Master_Map__c>();
            List<Master_Map__c> Causemap = new List<Master_Map__c>();

            if (relatedNotification.Equipment__r.catelogProfile__c != null) {
                List<Master_Map__c> maps = [ SELECT Id, Name, Description__c, Type__c, Code__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Equipment__r.catelogProfile__c ];

                Set<Id> masterMapIds = new Set<Id>();
                for (Master_Map__c m : maps) {
                    masterMapIds.add(m.Id);
                }
                Causemap = [ SELECT Id, Name, Description__c, Type__c, Code__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds AND Description__c = 'Activity' ];
                if (!Causemap.isEmpty()) masters = [ SELECT Id, Name, Description__c, Type__c, Code__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :Causemap.get(0).RelatedMasterMap2__c ];
            } else if ( relatedNotification.Equipment__r.catelogProfile__c == null && relatedNotification.Functional_Location__r.catelogProfile__c != null ) {
                List<Master_Map__c> maps = [ SELECT Id, Name, Description__c, RelatedMasterMap2__c, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :relatedNotification.Functional_Location__r.catelogProfile__c ];
                Set<Id> masterMapIds = new Set<Id>();
                for (Master_Map__c m : maps) {
                    masterMapIds.add(m.Id);
                }
                Causemap = [ SELECT Id, Name, Description__c, Type__c, Code__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name, RelatedMasterMap1__c FROM Master_Map__c WHERE Id IN :masterMapIds AND Description__c = 'Activity' ];
                if (!Causemap.isEmpty()) masters = [ SELECT Id, Name, Description__c, Type__c, Code__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name, RelatedMasterMap1__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :Causemap.get(0).RelatedMasterMap2__c ];
            }
            if (!(masters.size() > 0))  masters = [ SELECT Name, Type__c, Description__c, RelatedMasterMap1__c, RelatedMasterMap2__c, RelatedMasterMap2__r.Name FROM Master_Map__c WHERE RelatedMasterMap1__c = :codeGroupId ]; 
            return masters;
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static List<Cause__c> getCausesRelatedToItem(String itemId) {
        try {
            return [ SELECT Id, Name, Code_Text__c, Code_in_Text_Form__c, Code_Group__r.Name, Code__c, Text__c FROM Cause__c WHERE Item__c = :itemId AND isDeleted__c = false ];
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static List<Activity__c> getActivitiesRelatedToItem(String itemId) {
        try {
            return [ SELECT Id, Name, Code_Text__c, Code_in_Text_Form__c, Code_Group__r.Name, Text_of_Code__c, Code__c, Text__c FROM Activity__c WHERE Item__c = :itemId AND isDeleted__c = false ];
        } catch (Exception ex) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static Boolean hasWriteAccess(String itemId) {
        List<Item__c> items = [SELECT Id, Name, Notification__c FROM Item__c WHERE Id = :itemId];
        if (!items.isEmpty()) {
            List<UserRecordAccess> access = [ SELECT RecordId FROM UserRecordAccess WHERE HasEditAccess = true AND RecordId = :items.get(0).Notification__c AND UserId = :UserInfo.getUserId() ];
            return !access.isEmpty();
        }
        return false;
    }

    private static List<Cause__c> markItemCausesAsDeleted(Id itemId) {
        List<Cause__c> causes = getCausesByItemId(itemId);
        for (Cause__c cause : causes) {
            cause.isDeleted__c = true;
            cause.Integration_Flag__c = 'Deleted';
            cause.Integration_Status__c = '';
        }
        return causes;
    }

    private static List<Activity__c> markItemActivitiesAsDeleted(Id itemId) {
        List<Activity__c> activities = getActivitiesByItemId(itemId);
        for (Activity__c activity : activities) {
            activity.isDeleted__c = true;
            activity.Integration_Flag__c = 'Deleted';
            activity.Integration_Status__c = '';
        }
        return activities;
    }
    private static List<Cause__c> getCausesByItemId(Id itemId) {
        return [SELECT Id, isDeleted__c, Integration_Flag__c, Integration_Status__c FROM Cause__c WHERE Item__c = :itemId AND isDeleted__c = FALSE];
    }

    private static List<Activity__c> getActivitiesByItemId(Id itemId) {
        return [SELECT Id, isDeleted__c, Integration_Flag__c, Integration_Status__c FROM Activity__c WHERE Item__c = :itemId AND isDeleted__c = FALSE];
    }

    @AuraEnabled
    public static List<Master_Map__c> searchCodeGroups(String searchText, List<Master_Map__c> codeGroups) {
        List<Master_Map__c> master = new List<Master_Map__c>();
        for (Master_Map__c m : codeGroups) {
            if ( m.Description__c.toUpperCase().contains(searchText.toUpperCase()) || m.Code__c.toUpperCase().contains(searchText.toUpperCase()) ) {
                master.add(m);
            }
        }
        return master;
    }

    @AuraEnabled
    public static List<Master_Map__c> searchCodeGroupsByNameAndDescription( String searchText, List<Master_Map__c> codeGroups ) {
        List<Master_Map__c> master = new List<Master_Map__c>();
        for (Master_Map__c m : codeGroups) {
            if ( m.Description__c.toUpperCase().contains(searchText.toUpperCase()) || m.Name.toUpperCase().contains(searchText.toUpperCase()) ) {
                master.add(m);
            }
        }
        return master;
    }

    @AuraEnabled
    public static List<Master_Map__c> searchCodeGroupsByNameAndDescriptionModified( String searchText, List<Master_Map__c> codeGroups ) {
        List<Master_Map__c> master = new List<Master_Map__c>();
        for (Master_Map__c m : codeGroups) {
            if ( m.Description__c.toUpperCase().contains(searchText.toUpperCase()) || m.RelatedMasterMap2__r.Name.toUpperCase().contains(searchText.toUpperCase()) ) {
                master.add(m);
            }
        }
        return master;
    }

    @AuraEnabled
    public static List<Master_Map__c> searchCauses(String searchText, List<Master_Map__c> filteredCauses) {
        List<Master_Map__c> master = new List<Master_Map__c>();
        for (Master_Map__c c : filteredCauses) {
            if ( c.Description__c.toUpperCase().contains(searchText.toUpperCase()) || c.RelatedMasterMap2__r.Name.toUpperCase().contains(searchText.toUpperCase()) ) {
                master.add(c);
            }
        }
        return master;
    }

    @AuraEnabled
    public static List<Master_Map__c> searchActivities(String searchText, List<Master_Map__c> filteredActivities) {
        List<Master_Map__c> master = new List<Master_Map__c>();
        for (Master_Map__c a : filteredActivities) {
            if ( a.Description__c.toUpperCase().contains(searchText.toUpperCase()) || a.RelatedMasterMap2__r.Name.toUpperCase().contains(searchText.toUpperCase()) ) {
                master.add(a);
            }
        }
        return master;
    }
    
    @AuraEnabled
    public static List<Master_Map__c> getObjectPartCodeGroup(Id notificationId) {
        Notification__c n = getNotificationById(notificationId);
        Master_Map__c catelogProfile;
        Equipment__c equipment;
        Functional_Location__c functionalLocation;
        Master_Map__c firstFilter;
        List<Master_Map__c> lst;

        if (n.Equipment__c != null) {
            equipment = [SELECT CatelogProfile__c FROM Equipment__c WHERE id = :n.Equipment__c WITH SECURITY_ENFORCED];
            if (equipment.CatelogProfile__c != null) {
                catelogProfile = getCatelogProfile(equipment.CatelogProfile__c);
                firstFilter = getMasterMapFirstFilterOP(catelogProfile);
                if (firstFilter != null && getMasterMapById(firstFilter) != null) {
                    return getMasterMapById(firstFilter);
                } else {
                    if (n.Functional_Location__c != null) {
                        functionalLocation = [ SELECT CatelogProfile__c FROM Functional_Location__c WHERE id = :n.Functional_Location__c WITH SECURITY_ENFORCED ];
                        if (functionalLocation.CatelogProfile__c != null) {
                            catelogProfile = getCatelogProfile(functionalLocation.CatelogProfile__c);
                            firstFilter = getMasterMapFirstFilterOP(catelogProfile);
                            if (firstFilter != null && getMasterMapById(firstFilter) != null) {
                                return getMasterMapById(firstFilter);
                            } else { return noDataFilterFlowOP(); }
                        } else { return noDataFilterFlowOP(); }
                    } else { return noDataFilterFlowOP(); }
                }
            } else {
                if (n.Functional_Location__c != null) {
                    functionalLocation = [ SELECT CatelogProfile__c FROM Functional_Location__c WHERE id = :n.Functional_Location__c WITH SECURITY_ENFORCED ];
                    if (functionalLocation.CatelogProfile__c != null) {
                        catelogProfile = getCatelogProfile(functionalLocation.CatelogProfile__c);
                        firstFilter = getMasterMapFirstFilterOP(catelogProfile);
                        return (firstFilter != null && getMasterMapById(firstFilter) != null)?getMasterMapById(firstFilter):noDataFilterFlowOP();
                    } else { return noDataFilterFlowOP(); }
                } else { return noDataFilterFlowOP(); }
            }
        } else {
            if (n.Functional_Location__c != null) {
                functionalLocation = [ SELECT CatelogProfile__c FROM Functional_Location__c WHERE id = :n.Functional_Location__c WITH SECURITY_ENFORCED ];
                if (functionalLocation.CatelogProfile__c != null) {
                    catelogProfile = getCatelogProfile(functionalLocation.CatelogProfile__c);
                    firstFilter = getMasterMapFirstFilterOP(catelogProfile);
                    return (firstFilter != null && getMasterMapById(firstFilter) != null)?getMasterMapById(firstFilter):noDataFilterFlowOP();
                } else { return noDataFilterFlowOP(); }
            } else { return noDataFilterFlowOP(); }
        }
    }
    private static List<Master_Map__c> noDataFilterFlowOP() {
        List<Master_Map__c> noDataFilter;
        Set<Id> noDataIds = new Set<Id>();
        noDataFilter = getNoDataFilter1();
        for (Master_Map__c m : noDataFilter) {
            noDataIds.add(m.RelatedMasterMap2__c);
        }
        return getMasterMapsBySetIds(noDataIds);
    }
    private static Master_Map__c getCatelogProfile(Id id) {
        return [SELECT Id, Name FROM Master_Map__c WHERE Id = :id WITH SECURITY_ENFORCED];
    }
    private static Notification__c getNotificationById(Id notificationId) {
        return [ SELECT id, name, Equipment__c, Functional_Location__c FROM Notification__c WHERE Id = :notificationId WITH SECURITY_ENFORCED ];
    }
    private static Master_Map__c getMasterMapFirstFilterOP(Master_Map__c catelogProfile) {
        List<Master_Map__c> lst;
        lst = [ SELECT Id, Name, RelatedMasterMap2__c FROM Master_Map__c WHERE Description__c = :'ObjectPart' AND RelatedMasterMap1__c = :catelogProfile.id WITH SECURITY_ENFORCED ];
		return (lst.size() > 0)? lst[0]:null;
    }

    private static List<Master_Map__c> getMasterMapById(Master_Map__c mm) {
        List<Master_Map__c> lst = [ SELECT Id, Name, Description__c, Code__c FROM Master_Map__c WHERE Id = :mm.RelatedMasterMap2__c WITH SECURITY_ENFORCED ];
		return (lst.size() > 0)? lst:null;
    }
    private static List<Master_Map__c> getNoDataFilter1() {
        return [ SELECT Id, Name, RelatedMasterMap2__c FROM Master_Map__c WHERE Type__c = :'CatalogType' AND Description__c = 'ObjectPart' WITH SECURITY_ENFORCED ];
    }
    private static List<Master_Map__c> getMasterMapsBySetIds(Set<Id> ids) {
        return [SELECT Id, Name, Description__c, Code__c FROM Master_Map__c WHERE Id IN :ids WITH SECURITY_ENFORCED];
    }
    @AuraEnabled
    public static List<Master_Map__c> getObjectPartCode(Id objectPartCodeGroupId) {
        List<Master_Map__c> firstFilter;
        firstFilter = getObjectPartCodeFirstFilter(objectPartCodeGroupId);
        List<Master_Map__c> firstFilterType = new List<Master_Map__c>();
        for (Master_Map__c objectPartCode : firstFilter) {
            if (objectPartCode.Type__c == 'CatelogObjectPart') {
                firstFilterType.add(objectPartCode);
            }
        }
        return firstFilterType;
    }
    public static List<Master_Map__c> getObjectPartCodeFirstFilter(Id objectPartCodeGroupId) {
        return [ SELECT Id, Name, RelatedMasterMap2__c, RelatedMasterMap2__r.Name, RelatedMasterMap2__r.Code__c, Description__c, Type__c FROM Master_Map__c WHERE RelatedMasterMap1__c = :objectPartCodeGroupId WITH SECURITY_ENFORCED ];
    }
    @AuraEnabled
    public static List<Master_Map__c> getDamageCodeGroup(Id notificationId) {
        Notification__c n = getNotificationById(notificationId);
        Master_Map__c catelogProfile;
        Equipment__c equipment;
        Functional_Location__c functionalLocation;
        Master_Map__c firstFilter;
        if (n.Equipment__c != null) {
            equipment = [SELECT CatelogProfile__c FROM Equipment__c WHERE id = :n.Equipment__c WITH SECURITY_ENFORCED];
            if (equipment.CatelogProfile__c != null) {
                catelogProfile = getCatelogProfile(equipment.CatelogProfile__c);
                firstFilter = getMasterMapFirstFilterDMG(catelogProfile);
                if (firstFilter != null && getMasterMapById(firstFilter) != null) {
                    return getMasterMapById(firstFilter);
                } else {
                    if (n.Functional_Location__c != null) {
                        functionalLocation = [ SELECT CatelogProfile__c FROM Functional_Location__c WHERE id = :n.Functional_Location__c WITH SECURITY_ENFORCED ];
                        if (functionalLocation.CatelogProfile__c != null) {
                            catelogProfile = getCatelogProfile(functionalLocation.CatelogProfile__c);
                            firstFilter = getMasterMapFirstFilterDMG(catelogProfile);
                            return (firstFilter != null && getMasterMapById(firstFilter) != null)?getMasterMapById(firstFilter):noDataFilterFlowDMG();
                        } else { return noDataFilterFlowDMG(); }
                    } else { return noDataFilterFlowDMG(); }
                }
            } else {
                if (n.Functional_Location__c != null) {
                    functionalLocation = [ SELECT CatelogProfile__c FROM Functional_Location__c WHERE id = :n.Functional_Location__c WITH SECURITY_ENFORCED ];
                    if (functionalLocation.CatelogProfile__c != null) {
                        catelogProfile = getCatelogProfile(functionalLocation.CatelogProfile__c);
                        firstFilter = getMasterMapFirstFilterDMG(catelogProfile);
                        return (firstFilter != null && getMasterMapById(firstFilter) != null)?getMasterMapById(firstFilter):noDataFilterFlowDMG();                    
                    } else { return noDataFilterFlowDMG(); }
                } else { return noDataFilterFlowDMG(); }
            }
        } else {
            if (n.Functional_Location__c != null) {
                functionalLocation = [ SELECT CatelogProfile__c FROM Functional_Location__c WHERE id = :n.Functional_Location__c WITH SECURITY_ENFORCED ];
                if (functionalLocation.CatelogProfile__c != null) {
                    catelogProfile = getCatelogProfile(functionalLocation.CatelogProfile__c);
                    firstFilter = getMasterMapFirstFilterDMG(catelogProfile);
                    return (firstFilter != null && getMasterMapById(firstFilter) != null)?getMasterMapById(firstFilter): noDataFilterFlowDMG();
                } else { return noDataFilterFlowDMG(); }
            } else { return noDataFilterFlowDMG(); }
        }
    }

    private static Master_Map__c getMasterMapFirstFilterDMG(Master_Map__c catelogProfile) {
        List<Master_Map__c> lst= [ SELECT Id, Name, RelatedMasterMap2__c FROM Master_Map__c WHERE Description__c = :'Damage' AND RelatedMasterMap1__c = :catelogProfile.id WITH SECURITY_ENFORCED ];
        return (lst.size() > 0)?lst[0]:null;
    }

    private static List<Master_Map__c> noDataFilterFlowDMG() {
        List<Master_Map__c> noDataFilter;
        Set<Id> noDataIds = new Set<Id>();
        noDataFilter = getNoDataFilter2();
        for (Master_Map__c m : noDataFilter) {
            noDataIds.add(m.RelatedMasterMap2__c);
        }
        return getMasterMapsBySetIds(noDataIds);
    }
    private static List<Master_Map__c> getNoDataFilter2() {
        return [ SELECT Id, Name, RelatedMasterMap2__c FROM Master_Map__c WHERE Type__c = :'CatalogType' AND Description__c = 'Damage' WITH SECURITY_ENFORCED ];
    }
    @AuraEnabled
    public static List<Master_Map__c> getDamageCode(Id damageCodeGroupId) {
        List<Master_Map__c> firstFilter;
        firstFilter = getObjectPartCodeFirstFilter(damageCodeGroupId);
        List<Master_Map__c> firstFilterType = new List<Master_Map__c>();
        for (Master_Map__c objectPartCode : firstFilter) {
            if (objectPartCode.Type__c == 'CatelogDamage') firstFilterType.add(objectPartCode);
        }
        return firstFilterType;
    }
    @AuraEnabled
    public static Item__c getItemById(string itemId) {
        return [ SELECT Id, Name, Object_Part_Code_Group__c, Object_Part_Code_Group__r.Description__c, Object_Part__c, Object_Part_Code_Text__c, Damage_Code_Group__c, Damage_Code_Group__r.Description__c, Damage__c, DamageText__c, Text__c, Integration_Flag__c, Integration_Status__c FROM Item__c WHERE Id = :itemId ];
    }
    @AuraEnabled
    public static Cause__c getCauseById(string causeId) {
        return [ SELECT Id, Name, Integration_Flag__c, Integration_Status__c FROM Cause__c WHERE Id = :causeId ];
    }
    @AuraEnabled
    public static Activity__c getActivityById(string activityId) {
        return [ SELECT Id, Name, Integration_Flag__c, Integration_Status__c FROM Activity__c WHERE Id = :activityId ];
    }

    @AuraEnabled
    public static void sendToSAP(Id itemId) {
        try {
            List<Item__c> items = [SELECT Id, Integration_Status__c FROM Item__c WHERE Id = :itemId LIMIT 1];
            for (Item__c item : items) {
                item.Integration_Status__c = 'In Progress';
            }
            update items;

            List<Cause__c> causes = [SELECT Id, Integration_Status__c FROM Cause__c WHERE Item__c = :itemId AND (Integration_Status__c = null OR Integration_Status__c = 'Failed')];
            if (causes.size() > 0) {
                for (Cause__c cause : causes) {
                    cause.Integration_Status__c = 'In Progress';
                }
                update causes;
            }

            List<Activity__c> activities = [SELECT Id, Integration_Status__c FROM Activity__c WHERE Item__c = :itemId AND (Integration_Status__c = null OR Integration_Status__c = 'Failed')];
            if (activities.size() > 0) {
                for (Activity__c activity : activities) {
                    activity.Integration_Status__c = 'In Progress';
                }
                update activities;
            }
            THOR_IRPAIntegration_Item.sendItemToSAP(items, '');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Cause__c> getCauses(Id itemId) {
        try {
            return [ SELECT Code_Group__r.Name, Code_in_Text_Form__c, Code_Text__c, Text__c, Integration_Flag__c, Integration_Status__c, Integration_Message__c FROM Cause__c WHERE Item__c = :itemId AND isDeleted__c = FALSE ];
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }
    @AuraEnabled
    public static List<Activity__c> getActivities(Id itemId) {
        try {
            return [ SELECT Id, Name, Code_Group__r.Name, Code__r.Name, Text__c, Code_in_Text_Form__c, Text_of_Code__c, Integration_Flag__c, Integration_Status__c, Integration_Message__c FROM Activity__c WHERE Item__c = :itemId AND isDeleted__c = FALSE ];
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }
}