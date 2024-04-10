public class ESS_PrivilegeHandler {

    public static string getUserId() {
        return UserInfo.getUserId();
    }
    
    public static boolean checkAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        //Find from Group ESS Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_Personel_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }
    
    public static boolean checkRecommendationLetterAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        //Find from Group ESS Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_Recommendation_Letter_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }
    
    public static boolean checkRecommendationLetterTOPAdminUser(string userId) {
        boolean adminTOP = false;
        ESS_Setting__c Setting = [select id, Letter_TOP_HR_Name__c from ESS_Setting__c];
        PISUsers__c TOPPISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(!isPRTRUser) {
            TOPPISUser = ESS_Global.assignToPISUser(userId);
            if(TOPPISUser.User__c == Setting.Letter_TOP_HR_Name__c) {
                adminTOP = true;
            }
        }
        return adminTOP;
    }
    
    public static boolean checkRecommendationLetterTESAdminUser(string userId) {
        boolean adminTES = false;
        ESS_Setting__c Setting = [select id, Letter_TES_HR_Name__c from ESS_Setting__c];
        
        PISUsers__c TESPISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(!isPRTRUser) {
            TESPISUser = ESS_Global.assignToPISUser(userId);
            if(TESPISUser.User__c == Setting.Letter_TES_HR_Name__c) {
                adminTES = true;
            }
        }
        
        return adminTES;
    }
    
    public static boolean checkProbationAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        //Find from Group ESS Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_Probation_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }
    
    public static boolean checkRetirementAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        //Find from Group ESS Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_Retirement_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }
    
    public static boolean checkPMBPAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        //Find from Group ESS PMBP Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_PMBP_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }
    
    public static boolean checkPEOCAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        //Find from Group ESS PEOC Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_PEOC_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkDGAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        //Find from Group ESS DG Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_DG_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkPMSVHotelAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Hotel'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkPMSVHotelSecretaryUser(string userId) {
        
        boolean isSecretaryUser = false;
        
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_Secretary_Hotel'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                if(userId == ESSAdmin.UserOrGroupId) {
                    isSecretaryUser = true;
                }
            }
        }
        
        return isSecretaryUser;
        
    }

    public static boolean checkHotelAdminSecretaryForMenu(string userId) {
        return checkPMSVHotelAdminUser(userId) || checkPMSVHotelSecretaryUser(userId);
    }
    
    public static boolean checkPMSVHotelPrivilege(string userId) {
        
        boolean canOnlyOnBehalf = false;
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        
        if(isPRTRUser) {
            canOnlyOnBehalf = true;
        }
        else {
            List<PISUsers__c> PISUser = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                       OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c, Hotel_Privilege__c from PISUsers__c 
                                       where User__c =: userId AND Active__c = true AND Mainposition__c = true];
                
            if(PISUser.size() > 0) {
                if(PISUser[0].COMPANYNAME__c == 'TOP') {
                    canOnlyOnBehalf = false;
                    
                    if(!PISUser[0].Hotel_Privilege__c) {
                        canOnlyOnBehalf = true;
                    }
                }
                else {
                    canOnlyOnBehalf = true;
                }
            }
        }
        return canOnlyOnBehalf;
    }

    public static boolean checkPMSVStationaryAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Stationary'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkGSBOStationaryAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_GSBO_Stationary'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkStationaryAdminForMenu(string userId) {
        return checkPMSVStationaryAdminUser(userId) || checkGSBOStationaryAdminUser(userId);
    }
    
    public static boolean checkPMSVFixAndGeneralAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_FixAndGeneral'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkPMSVTransportationAdminUser(string userId) {
        
        boolean isAdminUser = false;
        
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Transportation'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkPMSVUser(string userId) {
        
        boolean isAdminUser = false;
        
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                
                if(userId == ESSAdmin.UserOrGroupId) {
                    isAdminUser = true;
                }
            }
        }
        
        return isAdminUser;
        
    }

    public static boolean checkPMSVAdminUser(string userId) {
        return checkPMSVFixAndGeneralAdminUser(userId) || checkPMSVTransportationAdminUser(userId) || checkPMSVUser(userId);
    }
    
    public static List<string> StationaryLoginPrivilege() {
        List<string> loginAs = new List<string>();
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isGSBOAdmin = ESS_PrivilegeHandler.checkGSBOStationaryAdminUser(userId);
        boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVStationaryAdminUser(userId);
        
        if(isGSBOAdmin) {
            loginAs.add(ESS_Enum.StationaryPrivilege.TBK.name());
        }
        if(isPMSVAdmin) {
            loginAs.add(ESS_Enum.StationaryPrivilege.TSR.name());
        }
        
        return loginAs;
    }
           
}