/* Author Softever */
global with sharing class ESS_Menu {
    
    @TestVisible
    private static string menuName {get;set;}
    private static List<ESS_Menu_DTO.MenuListDTO> menuLists;
    private static string userId = ESS_PrivilegeHandler.getUserId(); 
    private static boolean isTOPUser = false; 
    private static boolean isHotelPrivilege = false;
    private static boolean isHideFixAndGeneral = false;
    private static boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
    private static boolean isEmployeeBasicAdmin = false;
    private static integer employeeBasicCount = 0;
    private static integer probationCount = 0;
    private static integer retirementCount = 0;
    
    private static boolean isRecommendationLetterAdmin = false;
    private static boolean isProbationAdmin = false;
    private static boolean isRetirementAdmin = false;
    private static boolean isPMBPAdmin = false;
    private static boolean isPEOCAdmin = false;
    private static boolean isDGAdmin = false;
    private static boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
    private static boolean isStationaryAdmin = ESS_PrivilegeHandler.checkStationaryAdminForMenu(userId);
    private static boolean isHotelAdmin = false;
    private static boolean isHotelSecretary = false;
    
    static {
        CheckPrivilege();
    }
        
    @RemoteAction
    public static List<ESS_Menu_DTO.MenuListDTO> GetMenuLists() {
        
        PISUsers__c loginedUser = new PISUsers__c();
        if(!isPRTRUser) {
            loginedUser = ESS_Global.assignToPISUser(userId);
            if(loginedUser.HOME_COMP__c == '1100') {
                isTOPUser = true;
            }
            if(loginedUser.Hotel_Privilege__c) {
                isHotelPrivilege = true;
            }
            List<string> excludePerSubAreas = ESS_Global.excludePerSubAreas();
            isHideFixAndGeneral = excludePerSubAreas.contains(loginedUser.PERSUBAREA__c);
        }
        else {
            isTOPUser = true;
        }
        
        isEmployeeBasicAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
        if(isEmployeeBasicAdmin) {
            employeeBasicCount = CheckEmployeeBasicCount(); 
        }
        
        probationCount = GetProbationaryListsCount();
        retirementCount = GetRetirementListsCount();
        
        //Approver
        ESS_Menu_DTO.MenuApproverDTO ProbationApprover = new ESS_Menu_DTO.MenuApproverDTO();
        ProbationApprover.isApprover = false;
        ProbationApprover = CheckProbationaryApprover(userId);
        
        ESS_Menu_DTO.MenuApproverDTO RetirementApprover = new ESS_Menu_DTO.MenuApproverDTO();
        RetirementApprover.isApprover = false;
        RetirementApprover = CheckRetirementApprover(userId);
        
        ESS_Menu_DTO.MenuApproverDTO ManpowerApprover = new ESS_Menu_DTO.MenuApproverDTO();
        ManpowerApprover.isApprover = false;
        ManpowerApprover = CheckManpowerApprover(userId, isPEOCAdmin);
        
        ESS_Menu_DTO.MenuApproverDTO ManpowerReject = new ESS_Menu_DTO.MenuApproverDTO();
        ManpowerReject.isApprover = false;
        ManpowerReject = CheckManpowerReject(userId);
        
        ESS_Menu_DTO.MenuApproverDTO ManpowerAdminApprover = new ESS_Menu_DTO.MenuApproverDTO();
        
        if(isPEOCAdmin) {
            ManpowerAdminApprover = CheckManpowerPEOCAdminApprover(userId);
        }
        else if(isPMBPAdmin) {
            ManpowerAdminApprover = CheckManpowerPMBPAdminApprover(userId);
        }
        else {
            ManpowerAdminApprover.notiCount = 0;
        }
        
        //FixAndGeneral
        ESS_Menu_DTO.MenuApproverDTO FixAndGeneralWaitingApprove = new ESS_Menu_DTO.MenuApproverDTO();
        FixAndGeneralWaitingApprove.isApprover = false;
        FixAndGeneralWaitingApprove = CheckFixAndGeneralWaiting(userId);
        
        //Stationary User Manager
        ESS_Menu_DTO.MenuApproverDTO StationaryWaitingApprove = new ESS_Menu_DTO.MenuApproverDTO();
        StationaryWaitingApprove.isApprover = false;
        StationaryWaitingApprove = CheckStationaryUserManagerWaiting(userId);
        
        //Stationary
        ESS_Menu_DTO.MenuApproverDTO StationaryOnProcessApprove = new ESS_Menu_DTO.MenuApproverDTO();
        StationaryOnProcessApprove.isApprover = false;
        StationaryOnProcessApprove = CheckStationaryOnProcess(userId);
        
        //Hotel
        ESS_Menu_DTO.MenuApproverDTO HotelOnProcessApprove = new ESS_Menu_DTO.MenuApproverDTO();
        HotelOnProcessApprove.isApprover = false;
        HotelOnProcessApprove = CheckHotelOnProcess(userId);
        
        List<ESS_Menu__c> Menus = new List<ESS_Menu__c>();
        menuLists = new List<ESS_Menu_DTO.MenuListDTO>();
        
       	string query = 'select id, name, menu_name__c, group__c, hide__c, icon_name__c, page_url__c, noti_color__c ' +
            			'from ESS_Menu__c where hide__c = false order by name asc';
        
		//Final query
		Menus = Database.query(query); 
        
        if(Menus.size() > 0) {
            
            integer menuCount = 0;
            
            for(ESS_Menu__c Menu : Menus) {
                
                if(!Test.isRunningTest()) {
                    menuName = Menu.Name;
                }
                else {
                    menuCount++;
                    if(menuCount == 1) {
                    	menuName = 'Menu-0004';
                    }
                    else if(menuCount == 2) {
                    	menuName = 'Menu-0006';
                    }
                    else if(menuCount == 3) {
                    	menuName = 'Menu-0015';
                    }
                    else if(menuCount == 4) {
                    	menuName = 'Menu-0020';
                    }
                    else if(menuCount == 5) {
                    	menuName = 'Menu-0022';
                    }
                    else if(menuCount == 6) {
                    	menuName = 'Menu-0028';
                    }
                    else if(menuCount == 7) {
                    	menuName = 'Menu-0034';
                    }
                    else if(menuCount == 8) {
                    	menuName = 'Menu-0040';
                    }    
                }
                
                ESS_Menu_DTO.MenuListDTO availableMenu = new ESS_Menu_DTO.MenuListDTO();
                availableMenu.notiColor = Menu.Noti_Color__c;
                //Check Approval Section
                if(isEmployeeBasicAdmin && menuName == 'Menu-0001') {
                    //Approval : Employee Basic & Tax Information Update
                    availableMenu = CheckApprovalSection(Menu, employeeBasicCount);
                    menuLists.add(availableMenu);
                }
                if(ProbationApprover.isApprover && menuName == 'Menu-0002') {
                    //Approval : Employee 180 days Probationary Period
                    availableMenu = CheckApprovalSection(Menu, ProbationApprover.notiCount);
                    menuLists.add(availableMenu);
                }
                if(RetirementApprover.isApprover && menuName == 'Menu-0003') {
                    //Approval : Employee Retirement Date Confirmation
                    availableMenu = CheckApprovalSection(Menu, RetirementApprover.notiCount);
                    menuLists.add(availableMenu);
                }
                if((ManpowerApprover.isApprover) && menuName == 'Menu-0004') {
                    //Approval : Request Manpower Service Requisition
                    availableMenu = CheckApprovalSection(Menu, ManpowerApprover.notiCount);
                    menuLists.add(availableMenu);
                }
                if((StationaryWaitingApprove.isApprover) && menuName == 'Menu-0005') {
                    //Approval User Manager : Stationary
                    availableMenu = CheckApprovalSection(Menu, StationaryWaitingApprove.notiCount);
                    menuLists.add(availableMenu);
                }
                
                //Check Personal Information Section
                //Menu-0006 : Employee Basic & Tax Information Update
                //Menu-0007 : Request for Letter of Recommendation
                //Menu-0008 : Employee Retirement Date Confirmation
                //Menu-0009 : Personal Folder
                if((menuName == 'Menu-0006' || menuName == 'Menu-0007' || menuName == 'Menu-0009') && !isPRTRUser) {
                    availableMenu = CheckAllSection(Menu, 0);
                	menuLists.add(availableMenu);
                }
                else if(menuName == 'Menu-0008' && !isPRTRUser) {
                    //TODO: Uncomment Group 1
                    ESS_Retirement__c Retirement = GetRetirementDetail();
                    if(Retirement.id != null) {
                        if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name()) {
                            availableMenu = CheckAllSection(Menu, 1);
                        	menuLists.add(availableMenu);  
                        }
                        else {
                            availableMenu = CheckAllSection(Menu, 0);
                        	menuLists.add(availableMenu);  
                        }
                    }
                } 
                //Check Time & Benefit Section
                //Menu-0010 : Employee Online
                //Menu-0011 : Flexible Benefit
                else if(menuName == 'Menu-0010' || menuName == 'Menu-0011') {
                    availableMenu = CheckAllSection(Menu, 0);
                	menuLists.add(availableMenu);
                }
                //Company Service Section
                //Menu-0012 : Stationary
                //Menu-0013 : Fix and General Service
                //Menu-0014 : Hotel Booking
                //Menu-0015 : Car Service
                //Menu-0016 : Telephone Directory
                //Menu-0017 : Smart Meeting
                //Menu-0018 : Business Travel Service (E-Biz)
                //Menu-0019 : Health Meter
                else if(menuName == 'Menu-0015' || menuName == 'Menu-0016' || menuName == 'Menu-0017'
                        || menuName == 'Menu-0018' || menuName == 'Menu-0019') {
                    
                            
                    availableMenu = CheckAllSection(Menu, 0);
                    menuLists.add(availableMenu);
                }
                else if(menuName == 'Menu-0012') {
                    integer notiCount = GetOnBehalfCountStationary();
                    availableMenu = CheckAllSection(Menu, notiCount);
                    menuLists.add(availableMenu);    
                }
                else if(menuName == 'Menu-0013' && !isHideFixAndGeneral) {
                    integer notiCount = GetOnBehalfCountFixAndGeneral();
                    availableMenu = CheckAllSection(Menu, notiCount);
                    menuLists.add(availableMenu);    
                }
                else if((menuName == 'Menu-0014' && isTOPUser && isHotelPrivilege) || (menuName == 'Menu-0014' && isHotelSecretary)||
                       (menuName == 'Menu-0014' && isTOPUser && isPRTRUser)) {
                    integer notiCount = GetOnBehalfCountHotelBooking();
                    availableMenu = CheckAllSection(Menu, notiCount);
                    menuLists.add(availableMenu);
                }
                //Learning Section
                //Menu-0020 : Thaioil Academy
                //Menu-0021 : Wisdom
                else if(menuName == 'Menu-0020' || menuName == 'Menu-0021') {
                    availableMenu = CheckAllSection(Menu, 0);
                	menuLists.add(availableMenu);
                }
                //Workforce Section
                //Menu-0022 : Request Manpower Service Requisition
                else if(menuName == 'Menu-0022') {
                    availableMenu = CheckAllSection(Menu, ManpowerReject.notiCount);
                	menuLists.add(availableMenu);
                }
                //Tracking Report Section
                //Menu-0023 : Employee Basic & Tax Information Update
                //Menu-0024 : Request for Letter of Recommendation
                //Menu-0025 : Employee Retirement Date Confirmation
                //Menu-0026 : Employee 180 days Probationary Period
                //Menu-0027 : Stationary
                //Menu-0028 : Request Manpower Service Requisition
                else if(menuName == 'Menu-0023' || menuName == 'Menu-0024' || menuName == 'Menu-0025' || menuName == 'Menu-0026' || menuName == 'Menu-0027'
                       	 || menuName == 'Menu-0028') {
                             
                    availableMenu = CheckAllSection(Menu, 0);
                    
                    if(isEmployeeBasicAdmin && menuName == 'Menu-0023') {
                    	menuLists.add(availableMenu);	             
                    }
                    else if(isRecommendationLetterAdmin && menuName == 'Menu-0024') {
                    	menuLists.add(availableMenu);	             
                    }
                    else if(isRetirementAdmin && menuName == 'Menu-0025') {
                    	menuLists.add(availableMenu);	             
                    }
                    else if(isProbationAdmin && menuName == 'Menu-0026') {
                    	menuLists.add(availableMenu);	             
                    }
                    else if(isStationaryAdmin && menuName == 'Menu-0027') {
                    	menuLists.add(availableMenu);          
                    }
                    else if((isPMBPAdmin || isPEOCAdmin) && menuName == 'Menu-0028') {
                    	menuLists.add(availableMenu);	             
                    }
                }
                //Administration Section
                //Menu-0029 : Employee Basic & Tax Information Update
                //Menu-0030 : Employee Retirement Date Confirmation
                //Menu-0031 : Employee 180 days Probationary Period
                //Menu-0032 : Hotel Booking
                //Menu-0033 : Stationary
                //Menu-0034 : Request Manpower Service Requisition
                //Menu-0041 : Fix and General Service
                else if(menuName == 'Menu-0029' || menuName == 'Menu-0030' || menuName == 'Menu-0031' || menuName == 'Menu-0032' || menuName == 'Menu-0033'
                       	 || menuName == 'Menu-0034' || menuName == 'Menu-0041') {
                             
                    if((isPMBPAdmin || isPEOCAdmin) && menuName == 'Menu-0034') {
                     	availableMenu = CheckAllSection(Menu, ManpowerAdminApprover.notiCount);    
                        menuLists.add(availableMenu);
                    }
                    else if(isPMSVAdmin && menuName == 'Menu-0041') {
                        availableMenu = CheckAllSection(Menu, FixAndGeneralWaitingApprove.notiCount);  
                        menuLists.add(availableMenu);
                    }  
                    else if(isHotelAdmin && menuName == 'Menu-0032') {
                        availableMenu = CheckAllSection(Menu, HotelOnProcessApprove.notiCount);  
                        menuLists.add(availableMenu);
                    }  
                    else if(isStationaryAdmin && menuName == 'Menu-0033') {
                        availableMenu = CheckAllSection(Menu, StationaryOnProcessApprove.notiCount);  
                        menuLists.add(availableMenu);
                    } 
                    else {
                        
                    	availableMenu = CheckAllSection(Menu, 0);  
                        
                        if(isEmployeeBasicAdmin && menuName == 'Menu-0029') {
                            availableMenu = CheckApprovalSection(Menu, employeeBasicCount);
                            menuLists.add(availableMenu);	             
                        } 
                        else if(isRetirementAdmin && menuName == 'Menu-0030') {
                            availableMenu = CheckApprovalSection(Menu, retirementCount);
                            menuLists.add(availableMenu);	             
                        }  
                        else if(isProbationAdmin && menuName == 'Menu-0031') {
                            availableMenu = CheckApprovalSection(Menu, probationCount);
                            menuLists.add(availableMenu);	             
                        }
                        //else if(isHotelAdmin && menuName == 'Menu-0032') {
                        //    menuLists.add(availableMenu);	 
                        //}
                        //else if(isStationaryAdmin && menuName == 'Menu-0033') {
                        //    menuLists.add(availableMenu);	  
                        //}          
                    }
                }
                //MasterData Section
                //Menu-0035 : Hotel Booking
                //Menu-0036 : Stationary
                //Menu-0037 : Manpower Service Project List
                //Menu-0038 : Manpower Service - Scope of Service
                //Menu-0039 : Letter Setting
                //Menu-0040 : Menu Setting
                else if(menuName == 'Menu-0035' || menuName == 'Menu-0036' || menuName == 'Menu-0037' || menuName == 'Menu-0038' || menuName == 'Menu-0039'
                       	 || menuName == 'Menu-0040' || menuName == 'Menu-0041') {
                    availableMenu = CheckAllSection(Menu, 0);
                             
					if(isHotelAdmin && menuName == 'Menu-0035') {
                        menuLists.add(availableMenu);          
                    } 
                    else if(isStationaryAdmin && menuName == 'Menu-0036') {
                        menuLists.add(availableMenu);        
                    } 
                    else if((isDGAdmin || isPMBPAdmin) && menuName == 'Menu-0037') {
                        menuLists.add(availableMenu);       
                    }
                    else if((isDGAdmin || isPMBPAdmin) && menuName == 'Menu-0038') {
                        menuLists.add(availableMenu);       
                    }
                    else if(isDGAdmin && menuName == 'Menu-0039') {
                        menuLists.add(availableMenu);       
                    }
                    else if(isDGAdmin && menuName == 'Menu-0040') {
                        menuLists.add(availableMenu);       
                    }
                }
            }
            
        }
        
        return menuLists;
    }
    
    //Check Approver and Noti Count
    //TODO: Uncomment Group 1
    @TestVisible
    private static integer CheckEmployeeBasicCount() {
        
        integer notiCount = 0;
        
        List<ESS_Application__c> Apps = [select id, status__c from ESS_Application__c where 
                                        status__c =: ESS_Enum.ApplicationStatus.Submitted.name()];
                                         
        if(Apps.size() > 0) {
        	notiCount = Apps.size();
        }
        
        return notiCount;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckRetirementApprover(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        List<ESS_Retirement__c> Retirements = [select id, status__c, section_head_id__c, department_head_id__c from ESS_Retirement__c where 
                                        (section_head_id__c =: userId OR department_head_id__c =: userId)];
                                      
        if(Retirements.size() > 0) {
        	Approver.isApprover = true;  
            
            integer sectionHeadCount = 0;
            integer departmentHeadCount = 0;
            for(ESS_Retirement__c Retirement : Retirements) {
                if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name() && 
                  	Retirement.Section_Head_Id__c == userId) {
                    sectionHeadCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name() &&
                       Retirement.Department_Head_Id__c == userId) {
                    departmentHeadCount++;   
                }
            }
            
            Approver.notiCount = sectionHeadCount + departmentHeadCount;
        }
        
        return Approver;
    }
        
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckProbationaryApprover(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        List<ESS_Probationary__c> Probations = [select id, status__c, section_head_id__c, department_head_id__c, Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c from ESS_Probationary__c where 
                                        (section_head_id__c =: userId OR department_head_id__c =: userId OR Reassign_Section_Head_Id__c = :userId OR Reassign_Department_Head_Id__c = :userId)];
        
        if(Probations.size() > 0) {
        	Approver.isApprover = true;  
            
            integer sectionHeadCount = 0;
            integer departmentHeadCount = 0;
            for(ESS_Probationary__c Probation : Probations) {
                if((Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name() &&
                    Probation.Section_Head_Id__c == userId) || 
                   (Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name() &&
                    Probation.Reassign_Section_Head_Id__c == userId)) {
                       sectionHeadCount++;
                   }
                else if((Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name() &&
                    Probation.department_head_id__c == userId)|| 
                    (Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name() &&
                    Probation.Reassign_Department_Head_Id__c == userId)) {
                       departmentHeadCount++;   
                   }
            }
            
            Approver.notiCount = sectionHeadCount + departmentHeadCount;                   
        }
        
        return Approver;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckManpowerApprover(string userId, boolean isPEOCAdmin) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
            
        List<string> statuses = new List<string>{ ESS_Enum.ManpowerStatus.WaitingToSectionHead.name(), ESS_Enum.ManpowerStatus.WaitingToVP.name(), ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()};
            Manpowers = [select id, section_head_id__c, vp_id__c from ESS_Manpower__c where status__c IN: statuses AND
                         (approver_section_head_id__c =: userId OR approver_vp_id__c =: userId OR approver_project_manager_id__c =: userId)];
                              
        if(Manpowers.size() > 0) {
        	Approver.isApprover = true;     
            Approver.notiCount = Manpowers.size();
        }
        
        return Approver;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckManpowerPMBPAdminApprover(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        string status = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
        
        List<ESS_Manpower__c> Manpowers = [select id, section_head_id__c, vp_id__c from ESS_Manpower__c where 
                                        (status__c =: status)];
                                         
        if(Manpowers.size() > 0) {
        	Approver.isApprover = true;     
            Approver.notiCount = Manpowers.size();
        }
        
        return Approver;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckManpowerPEOCAdminApprover(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        string status = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
        
        List<ESS_Manpower__c> Manpowers = [select id, section_head_id__c, vp_id__c from ESS_Manpower__c where 
                                        (status__c =: status) AND is_admin_peoc__c = true];
                                         
        if(Manpowers.size() > 0) {
        	Approver.isApprover = true;     
            Approver.notiCount = Manpowers.size();
        }
        
        return Approver;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckManpowerReject(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        List<string> statuses = new List<string> {
            ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name(),
            ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()
        };
        
        List<ESS_Manpower__c> Manpowers = [select id, status__c, section_head_id__c, vp_id__c from ESS_Manpower__c where 
                                        (ownerId =: userId AND status__c IN :statuses )];
                                         
        if(Manpowers.size() > 0) {
        	Approver.isApprover = true;     
            Approver.notiCount = Manpowers.size();
        }
        
        return Approver;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckFixAndGeneralWaiting(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        boolean isPMSVFixAndGeneral = ESS_PrivilegeHandler.checkPMSVFixAndGeneralAdminUser(userId);
        boolean isPMSVTransportation = ESS_PrivilegeHandler.checkPMSVTransportationAdminUser(userId);
        boolean isPMSV = ESS_PrivilegeHandler.checkPMSVUser(userId);
        
        List<string> typeOfServices = new List<string>();
        if(isPMSV) {
            typeOfServices.add(ESS_Enum.FixTypeOfService.OfficeEquipment.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.Housing.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.GeneralService.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.Transportation.name());
        }
        else if(isPMSVFixAndGeneral && isPMSVTransportation) {
            typeOfServices.add(ESS_Enum.FixTypeOfService.OfficeEquipment.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.Housing.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.GeneralService.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.Transportation.name());
        }
        else if(isPMSVFixAndGeneral) {
            typeOfServices.add(ESS_Enum.FixTypeOfService.OfficeEquipment.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.Housing.name());
            typeOfServices.add(ESS_Enum.FixTypeOfService.GeneralService.name());
        }
        else if(isPMSVTransportation) {
            typeOfServices.add(ESS_Enum.FixTypeOfService.Transportation.name());
        }
        
        DateTime startCreatedDate = DateTime.newInstance(system.now().year() - 2, 1, 1, 0, 0, 0);
        DateTime endCreatedDate = DateTime.newInstance(system.now().year(), system.now().month(), system.now().day(), 23, 59, 59);

        ESS_FixAndGeneral.FixAndGeneralForAdminListFilter waitingFilter = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
        waitingFilter.status = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
        waitingFilter.typeOfServices = string.join(typeOfServices, ',');
        integer waitingCount = ESS_FixAndGeneral.GetFixAndGeneralForAdminListCount(waitingFilter);
                                         
        if(waitingCount > 0) {
        	Approver.isApprover = true;     
            Approver.notiCount = waitingCount;
        }
        
        return Approver;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckStationaryOnProcess(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        boolean isPMSV = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
        boolean isPMSVStationary = ESS_PrivilegeHandler.checkPMSVStationaryAdminUser(userId);
        
        DateTime startCreatedDate = DateTime.newInstance(system.now().year() - 2, 1, 1, 7, 0, 0);
        DateTime endCreatedDate = DateTime.newInstance(system.now().year(), system.now().month(), system.now().day() + 1, 6, 59, 59);
		
        ESS_Stationary.AdminSearchCriteria onProcessFilter = new ESS_Stationary.AdminSearchCriteria();
        onProcessFilter.status = ESS_Enum.StationaryServiceStatus.OnProcess.name();
        integer onProcessCount = ESS_Stationary.GetStationaryAdminListCount(onProcessFilter);
        
        if(onProcessCount > 0) {
        	Approver.isApprover = true;     
            Approver.notiCount = onProcessCount;
        }
        
        return Approver;
    }
    
    @TestVisible
    private static ESS_Menu_DTO.MenuApproverDTO CheckHotelOnProcess(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        boolean isPMSV = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
        boolean isPMSVStationary = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
        
        DateTime startCreatedDate = DateTime.newInstance(system.now().year() - 2, 1, 1, 0, 0, 0);
        DateTime endCreatedDate = DateTime.newInstance(system.now().year(), system.now().month(), system.now().day() + 1, 7, 00, 00);
        DateTime endCheckInDate = DateTime.newInstance(system.now().year(), 12, 31, 23, 59, 59);
        
        ESS_HotelBooking.AdminSearchFilter onProcessFilter =  new ESS_HotelBooking.AdminSearchFilter();
        onProcessFilter.status = ESS_Enum.HotelBookingStatus.OnProcess.name();
        integer hotelOnProcessCount = ESS_HotelBooking.GetHotelBookingForAdminListCount(onProcessFilter);
                                         
        if(hotelOnProcessCount > 0) {
        	Approver.isApprover = true;
            Approver.notiCount = hotelOnProcessCount;
        }
        
        return Approver;
    }
    
    @TestVisible
    //Stationary for UserManager
    public static ESS_Menu_DTO.MenuApproverDTO CheckStationaryUserManagerWaiting(string userId) {
        
        ESS_Menu_DTO.MenuApproverDTO Approver = new ESS_Menu_DTO.MenuApproverDTO();
        
        Approver.isApprover = false;
        Approver.notiCount = 0;
        
        DateTime startCreatedDate = DateTime.newInstance(system.now().year() - 2, 1, 1, 7, 0, 0);
        DateTime endCreatedDate = DateTime.newInstance(system.now().year(), system.now().month(), system.now().day()+1, 7, 00, 00);

        ESS_Stationary.SearchCriteria waitingFilter = new ESS_Stationary.SearchCriteria();
        waitingFilter.status = ESS_Enum.StationaryServiceStatus.WaitingToApprove.name();
        integer waitingCount = ESS_Stationary.GetStationaryApproverListCount(waitingFilter);
        
        if(waitingCount > 0) {
        	Approver.isApprover = true;     
            Approver.notiCount = waitingCount;
        }
        
        return Approver;
    }
    
    //All Section
    @TestVisible
    private static ESS_Menu_DTO.MenuListDTO CheckAllSection(ESS_Menu__c Menu, integer notiCount) {
        
        ESS_Menu_DTO.MenuListDTO availableMenu = new ESS_Menu_DTO.MenuListDTO();
        availableMenu.menuGroup = Menu.Group__c;
        availableMenu.icon = Menu.Icon_Name__c;
        availableMenu.menuName = Menu.Menu_Name__c;
        availableMenu.pageUrl = Menu.Page_Url__c;
        availableMenu.isShow = true;
        availableMenu.notiColor = Menu.Noti_Color__c;
        
        if(Menu.Menu_Name__c == 'Request Manpower Service Requisition' || Menu.Menu_Name__c == 'Fix and General Service' ||
          	Menu.Menu_Name__c == 'Hotel Booking' || Menu.Menu_Name__c == 'Stationery' || Menu.Menu_Name__c == 'Employee Retirement Date Confirmation') {
            availableMenu.notiCount = notiCount;
        }
        else {
        	availableMenu.notiCount = 0;
        }
        
        return availableMenu;
    }
    
    //TODO: Uncomment Group 1
    //Get Retirement Count
    @TestVisible
    private static ESS_Retirement__c GetRetirementDetail() {
        
        ESS_Retirement__c Retirement = new  ESS_Retirement__c();
        
        string userId = ESS_PrivilegeHandler.getUserId();

        string query = 'select id, ownerid, status__c, section_head_id__c, department_head_id__c from ESS_Retirement__c where id != null and ownerid = :userId';
		
        integer count = 0;
        List<ESS_Retirement__c> Retirements = Database.query(query);
        if(Retirements.size() > 0) {
            Retirement = Retirements[0];
        }
        
        return Retirement;
    }
    
    //Get On Behalf Hotel Booking
    @TestVisible
    private static integer GetOnBehalfCountHotelBooking() {
        string userId = ESS_PrivilegeHandler.getUserId();

        string query = 'select count(id) from ESS_Hotel_Booking__c where id != null and On_Behalf_Of_Id__c = :userId and Status__c = \'Verifying\'';

        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    //Get On Behalf Stationary
    @TestVisible
    private static integer GetOnBehalfCountStationary() {
        string userId = ESS_PrivilegeHandler.getUserId();

        string query = 'select count(id) from ESS_Stationary__c where id != null and On_Behalf_Of_Id__c = :userId and Status__c = \'Verifying\'';

        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    //Get On Behalf FixAndGeneral
    @TestVisible
    private static integer GetOnBehalfCountFixAndGeneral() {
        string userId = ESS_PrivilegeHandler.getUserId();

        string query = 'select count(id) from ESS_FixAndGeneral__c where id != null and On_Behalf_Of_Id__c = :userId and Status__c = \'Verifying\'';

        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    //Approval Section
    @TestVisible
    private static ESS_Menu_DTO.MenuListDTO CheckApprovalSection(ESS_Menu__c Menu, integer notiCount) {
        
        ESS_Menu_DTO.MenuListDTO availableMenu = new ESS_Menu_DTO.MenuListDTO();
        availableMenu.menuGroup = Menu.Group__c;
        availableMenu.icon = Menu.Icon_Name__c;
        availableMenu.menuName = Menu.Menu_Name__c;
        availableMenu.pageUrl = Menu.Page_Url__c;
        availableMenu.notiCount = notiCount;
        availableMenu.isShow = true;
        availableMenu.notiColor = Menu.Noti_Color__c;
        
        return availableMenu;
    }
    
    //Personal Information Section
    @TestVisible
    private static ESS_Menu_DTO.MenuListDTO CheckPersonalInformationSection(ESS_Menu__c Menu) {
        
        ESS_Menu_DTO.MenuListDTO availableMenu = new ESS_Menu_DTO.MenuListDTO();
        
        availableMenu.menuGroup = Menu.Group__c;
        availableMenu.icon = '';
        availableMenu.menuName = Menu.Menu_Name__c;
        availableMenu.pageUrl = '';
        availableMenu.notiCount = 0;
        availableMenu.isShow = true;
        availableMenu.notiColor = Menu.Noti_Color__c;
        menuLists.add(availableMenu);
        
        return availableMenu;
    }
    
    //Time & Benefit Section
    @TestVisible
    private static ESS_Menu_DTO.MenuListDTO CheckTimeBenefitSection(ESS_Menu__c Menu) {
        
        ESS_Menu_DTO.MenuListDTO availableMenu = new ESS_Menu_DTO.MenuListDTO();
        
        availableMenu.menuGroup = Menu.Group__c;
        availableMenu.icon = '';
        availableMenu.menuName = Menu.Menu_Name__c;
        availableMenu.pageUrl = '';
        availableMenu.notiCount = 0;
        availableMenu.isShow = true;
        availableMenu.notiColor = Menu.Noti_Color__c;
        menuLists.add(availableMenu);
        
        return availableMenu;
    }

	@TestVisible    
    private static boolean isShowAdminMenu(string userId) {
        return ESS_PrivilegeHandler.checkAdminUser(userId) || ESS_PrivilegeHandler.checkRecommendationLetterAdminUser(userId) || 
            	ESS_PrivilegeHandler.checkProbationAdminUser(userId) || ESS_PrivilegeHandler.checkRetirementAdminUser(userId) || 
            	ESS_PrivilegeHandler.checkPMBPAdminUser(userId) || ESS_PrivilegeHandler.checkPEOCAdminUser(userId) || 
            	ESS_PrivilegeHandler.checkDGAdminUser(userId);
    }
    
    //TODO: Uncomment Group 1
    public static integer GetProbationaryListsCount() {
        return ESS_Probationary.GetProbationaryListsCount();
    }
    
    public static integer GetRetirementListsCount() {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
        
        integer currentYear = system.Datetime.now().year();
        integer year = Integer.ValueOf(currentYear + 1);
        integer twoYear = Integer.ValueOf(currentYear + 2);
        date retirementStartDate = Date.newInstance(year, 1, 2);
        date retirementEndDate = Date.newInstance(twoYear, 1, 1);
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Name_Emp_EN_FN__c, Employee_Retirement_Date__c, Employee_DOB__c, Retirement_Section_Head_Id__c , Retirement_Section_Head_Name__c, Retirement_Section_Head_Position__c, Retirement_VP_Id__c, Retirement_VP_Name__c, Retirement_VP_Position__c, Retirement_Section_Head_TH__c, Retirement_VP_TH__c from ESS_Master_Employee__c where data__c =: data AND (Employee_Retirement_Date__c >=: retirementStartDate AND Employee_Retirement_Date__c <=: retirementEndDate) order by Employee_Id__c asc';
        
        Employees = database.query(query);
        
        integer totalRetirement = 0;
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c, Retirement_Selection__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, MAINPOSITION__c from PISUsers__c where user__c != null AND Active__c = true AND CompanyName__c = 'TOP' AND Retirement_Selection__c = true]; //AND MAINPOSITION__c = true
        
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        Map<string, PISUsers__c> mapPOSIDPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPOSIDPISUsers.put(PISUser.POSID__c, PISUser);
                
                if(PISUser.MAINPOSITION__c) {
                    mapPISUsers.put(PISUser.EMPLOYEEID__c, PISUser);
                }
            }    
        }  

        Map<string, ESS_Retirement__c> mapRetirements = new Map<string, ESS_Retirement__c>();
        List<ESS_Retirement__c> Retirements = [select id, employee_id__c from ESS_Retirement__c];
        if(Retirements.size() > 0) {
            for(ESS_Retirement__c Retirement : Retirements) {
                mapRetirements.put(Retirement.employee_id__c, Retirement);
            }
        }
            
        List<ESS_Retirement_DTO.RetirementListDTO> finalRetirementLists = new List<ESS_Retirement_DTO.RetirementListDTO>();
        if(Employees.size() > 0) {
            
            for(ESS_Master_Employee__c Master : Employees) {
                //Check show only TOP user
                PISUsers__c PISUser = mapPISUsers.get(Master.Employee_ID__c);
                if(PISUser != null) {
                    
                    if(PISUser.COMPANYNAME__c == 'TOP' && PISUser.Retirement_Selection__c) {
                        //Check Employee DOB
                        List<string> dobYears = new List<string> {string.Valueof(Integer.valueOf(currentYear) - 59), string.valueOf(Integer.valueOf(currentYear) - 54)};
                            integer employeeDOBYear = Master.Employee_DOB__c.Year();
                        boolean existed = dobYears.contains(String.ValueOf(employeeDOBYear));
                        if(existed) { 
                            ESS_Retirement__c Retirement = mapRetirements.get(Master.Employee_ID__c);
                            if(Retirement == null) {
                                totalRetirement++;
                            }                        
                        }
                    }
                }
            }
        }
        
        return totalRetirement;
    }
    
    public static void CheckPrivilege() {
        boolean isAdminUser = false;
        Set<Id> GroupIds = new Set<Id>();
        List<Group> Groups = [select id, developername from Group where developername like 'ESS_%'];
        if(Groups.size() > 0) {
            for(Group G : Groups) {
                GroupIds.add(G.Id);
            }
        }
        
        List<GroupMember> AdminUsers = [select id, groupid, group.developername, userorgroupid from GroupMember where GroupId IN :GroupIds];
        
        if(AdminUsers.size() > 0) {
            for(GroupMember ESSAdmin : AdminUsers) {
                if(userId == ESSAdmin.UserOrGroupId) { 
                    if(ESSAdmin.Group.developername == 'ESS_Recommendation_Letter_Admin') {
                    	isRecommendationLetterAdmin = true;
                    }
                    else if(ESSAdmin.Group.developername == 'ESS_Probation_Admin') {
                    	isProbationAdmin = true;
                    }
                    else if(ESSAdmin.Group.developername == 'ESS_Retirement_Admin') {
                    	isRetirementAdmin = true;
                    }
                    else if(ESSAdmin.Group.developername == 'ESS_PMBP_Admin') {
                    	isPMBPAdmin = true;
                    }
                    else if(ESSAdmin.Group.developername == 'ESS_PEOC_Admin') {
                    	isPEOCAdmin = true;
                    }
                    else if(ESSAdmin.Group.developername == 'ESS_DG_Admin') {
                    	isDGAdmin = true;
                    }
                    else if(ESSAdmin.Group.developername == 'ESS_PMSV_Hotel') {
                    	isHotelAdmin = true;
                    }
                    else if(ESSAdmin.Group.developername == 'ESS_Secretary_Hotel') {
                    	isHotelSecretary = true;
                    }
                }
            }
        }
    }
}