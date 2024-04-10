/* Class for Common Class for All Work Process that use in trigger */
public with sharing class CPEM_AllWorkProcessForTriggerController {

    //Send OPP Noti
    public static void SendOPPNotification(Id recordId, string projectName, string stepName, Id approveUserId, Id requesterId) {
        
        System.debug('projectName : ' + projectName);
        System.debug('stepName : ' + stepName);
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        string requesterName = [select id, name from User where Id =: requesterId].name;
        
        OPP_Application__c TOPPMPApp = [select id, name from OPP_Application__c where Name =: 'TOPPMP-AI'];
        
        Opp_Notification__c TOPPMPOpp = new Opp_Notification__c();
        TOPPMPOpp.Application__c = TOPPMPApp.Id;
        TOPPMPOpp.User__c = approveUserId;
        TOPPMPOpp.Subject__c = 'Following Step ' + stepName + ' for Project ' + projectName + ' has submitted for approve.';
        TOPPMPOpp.Description__c = '';
        TOPPMPOpp.Requester__c = requesterName;
        TOPPMPOpp.Status__c = 'New';
        TOPPMPOpp.URL__c = baseUrl + '/lightning/r/' + recordId + '/view';
        TOPPMPOpp.ReferenceID__c = recordId;
        insert(TOPPMPOpp);
        
    }
    
    public static void UpdateOPPNotification(Id recordId) {
        
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        List<Opp_Notification__c> TOPPMPApps = [select id, name, ReferenceID__c from Opp_Notification__c where ReferenceID__c =: recordId];
        
        if(TOPPMPApps.size() > 0) {
            for(Opp_Notification__c OppNoti : TOPPMPApps) {
                OppNoti.Status__c = 'Approved';
        		update(OppNoti);
            }
        }
        
    }
    
    public static void UpdateActualStartDateWP1(Id OldSME, Id NewSME, Project_Charter__c WP1) {
        
        if(OldSME == NewSME) {
            DateTime todayDT = System.Datetime.now();
            Date todayDate = date.newinstance(todayDT.year(), todayDT.month(), todayDT.day());
            WP1.Actual_Start_Date__c = todayDate;
        }
    }
    
    public static void UpdateActualEndDateWP1(CR_Completion_Report__c currentWP) {
        
        if(currentWP.Work_Process_Status__c == 'Completed') {
            
        	CPEMController CPEM = new CPEMController();
            
            //Custom Controller 
            CPEM.UpdateActualEndDateWP1(currentWP.Project__c);
            
        }
        
    }
    
    public static void UpdateProjectCompletedStatus(CR_Completion_Report__c currentWP) {
        
        if(currentWP.Work_Process_Status__c == 'Completed') {
            
        	CPEMController CPEM = new CPEMController();
            
            //Update Project Status
            CPEM.UpdateProjectCompletedStatus(currentWP.Project__c);
        }
        
    }
    
    public static void UpdateActualStartDateWP1FromOtherWP(Id OldSME, Id NewSME, Id ProjectId, boolean IsWaitingForPreviousStep) {
        
        if(OldSME == NewSME) {
            
            if(!IsWaitingForPreviousStep) {
                //Custom Controller
                CPEMController CPEM = new CPEMController();
                CPEM.UpdateActualStartDateWP1(ProjectId);
                
            }
        }
    }
    
    public static void UpdateFromServiceRequisition(Id OldSME, Id NewSME, Id ProjectId, Project_Execution_Plan__c currentWP) {
        
        if(OldSME == NewSME) {
            
            //Check for Service Requisition
            if(currentWP.Service_Requisition__c != null) {
                
                if(currentWP.Service_Requisition__c == 'EP (Owner)') {
                    
                    ITB_Standard__c WP10 = [select id, IsDisable__c, Project__c from ITB_Standard__c where Project__c =: ProjectId];
                    WP10.IsDisable__c = true;
                    update(WP10);
                    
                    CCE_Approval_Process__c WP11 = [select id, IsDisable__c, Project__c from CCE_Approval_Process__c where Project__c =: ProjectId];
                    WP11.IsDisable__c = true;
                    update(WP11);
                    
                }
                
                if(currentWP.Service_Requisition__c == 'EPC') {
                    
                    ITB_Standard_18__c WP18 = [select id, IsDisable__c, Project__c from ITB_Standard_18__c where Project__c =: ProjectId];
                    WP18.IsDisable__c = true;
                    update(WP18);
                    
                    CCE_Approval_Process_19__c WP19 = [select id, IsDisable__c, Project__c from CCE_Approval_Process_19__c where Project__c =: ProjectId];
                    WP19.IsDisable__c = true;
                    update(WP19);
                    
                }
                
            }
        }
    }
    
    public static void SendMailToAssignUser(Id OldAssignedUser, Id NewAssignedUser, Id WPId, Integer WPNo, string WPName) {
        
        boolean isSameAssigendUser = false;
        
        if(OldAssignedUser == NewAssignedUser) {
            isSameAssigendUser = true;
        }
        
        if(!isSameAssigendUser && NewAssignedUser != null) {
            
            CPEMController CPEM = new CPEMController();
            CPEM.SendMailToAssignUser(WPId, WPNo, NewAssignedUser, WPName);
            
        }
        
    }
    
    public static void UpdateWorkProcess2Status(Id OldSME, Id NewSME, Id ProjectId, Project_Organization__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Project_Charter__c previousWP = [select id, Project__c, Work_Process_Status__c, Actual_Start_Date__c from Project_Charter__c where Project__c =: ProjectId];
                
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }   
            }
        }
    }
    
    public static void UpdateWorkProcess3Status(Id OldSME, Id NewSME, Id ProjectId, Lesson_Learnt_Review__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Project_Organization__c previousWP = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess4Status(Id OldSME, Id NewSME, Id ProjectId, Project_Execution_Plan__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Lesson_Learnt_Review__c previousWP = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess5Status(Id OldSME, Id NewSME, Id ProjectId, Project_Procurement_Plan__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Project_Execution_Plan__c previousWP = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess6Status(Id OldSME, Id NewSME, Id ProjectId, WBS_CBS__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Project_Procurement_Plan__c previousWP = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess7Status(Id OldSME, Id NewSME, Id ProjectId, Schedule__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                WBS_CBS__c previousWP = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess8Status(Id OldSME, Id NewSME, Id ProjectId, Project_Status_Control__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Schedule__c previousWP = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess9Status(Id OldSME, Id NewSME, Id ProjectId, Budget_Phasing__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Project_Status_Control__c previousWP = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess10Status(Id OldSME, Id NewSME, Id ProjectId, ITB_Standard__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Budget_Phasing__c previousWP = [select id, Project__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess11Status(Id OldSME, Id NewSME, Id ProjectId, CCE_Approval_Process__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                ITB_Standard__c previousWP = [select id, Project__c, Work_Process_Status__c from ITB_Standard__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess12Status(Id OldSME, Id NewSME, Id ProjectId, Engineering_Standard__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                CCE_Approval_Process__c previousWP = [select id, Project__c, Work_Process_Status__c from CCE_Approval_Process__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess13Status(Id OldSME, Id NewSME, Id ProjectId, Deliverable_List__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Engineering_Standard__c previousWP = [select id, Project__c, Work_Process_Status__c from Engineering_Standard__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess14Status(Id OldSME, Id NewSME, Id ProjectId, Document_Distribution_Matrix__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Deliverable_List__c previousWP = [select id, Project__c, Work_Process_Status__c from Deliverable_List__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess15Status(Id OldSME, Id NewSME, Id ProjectId, Design_Safety_Standard__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Document_Distribution_Matrix__c previousWP = [select id, Project__c, Work_Process_Status__c from Document_Distribution_Matrix__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess16Status(Id OldSME, Id NewSME, Id ProjectId, Cost_Estimate__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Design_Safety_Standard__c  previousWP = [select id, Project__c, Work_Process_Status__c  from Design_Safety_Standard__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess17Status(Id OldSME, Id NewSME, Id ProjectId, Engineering_Data_Book_and_3D_Model__c oldWP, Engineering_Data_Book_and_3D_Model__c currentWP) {
        
    	boolean isCheckFrom3D = false;
    
        if(OldSME == NewSME) {
            
            if(oldWP.IFC_Link__c != currentWP.IFC_Link__c) {
                isCheckFrom3D = true;
            }
            else if(oldWP.IFC_Status__c != currentWP.IFC_Status__c) {
                isCheckFrom3D = true;
            }
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Cost_Estimate__c  previousWP = [select id, Project__c, Work_Process_Status__c  from Cost_Estimate__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess18Status(Id OldSME, Id NewSME, Id ProjectId, ITB_Standard_18__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Engineering_Data_Book_and_3D_Model__c  previousWP = [select id, Project__c, Work_Process_Status__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess19Status(Id OldSME, Id NewSME, Id ProjectId, CCE_Approval_Process_19__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                ITB_Standard_18__c  previousWP = [select id, Project__c, Work_Process_Status__c from ITB_Standard_18__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess20Status(Id OldSME, Id NewSME, Id ProjectId, Project_Procurement_Contract_Mgmt__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                CCE_Approval_Process_19__c previousWP = [select id, Project__c, Work_Process_Status__c, IsDisable__c from CCE_Approval_Process_19__c where Project__c =: ProjectId];
                
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.IsDisable__c == false) {
                    if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                        currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                        currentWP.IsWaitingForPreviousStep__c = true;
                    }
                }
                else {
                    
                    Engineering_Data_Book_and_3D_Model__c previousWP17 = [select id, Project__c, Work_Process_Status__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: ProjectId];
                    
                    if(previousWP17.Work_Process_Status__c != 'Completed' && isRecordLock) {
                        currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                        currentWP.IsWaitingForPreviousStep__c = true;
                    }
                }
            }
        }
    }
    
    public static void UpdateWorkProcess21Status(Id OldSME, Id NewSME, Id ProjectId, Vendor_Data_Management__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Project_Procurement_Contract_Mgmt__c previousWP = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Contract_Mgmt__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess22Status(Id OldSME, Id NewSME, Id ProjectId, Material_Inspection_FAT_SAT__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Vendor_Data_Management__c previousWP = [select id, Project__c, Work_Process_Status__c from Vendor_Data_Management__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess23Status(Id OldSME, Id NewSME, Id ProjectId, Surplus_Spar_part_Management__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Material_Inspection_FAT_SAT__c previousWP = [select id, Project__c, Work_Process_Status__c from Material_Inspection_FAT_SAT__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess24Status(Id OldSME, Id NewSME, Id ProjectId, Construction_Management__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Surplus_Spar_part_Management__c previousWP = [select id, Project__c, Work_Process_Status__c from Surplus_Spar_part_Management__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess25Status(Id OldSME, Id NewSME, Id ProjectId, Budget_Change_Control__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Construction_Management__c previousWP = [select id, Project__c, Work_Process_Status__c from Construction_Management__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess26Status(Id OldSME, Id NewSME, Id ProjectId, System_Test_Pack_Identification__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Budget_Change_Control__c previousWP = [select id, Project__c, Work_Process_Status__c from Budget_Change_Control__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess27Status(Id OldSME, Id NewSME, Id ProjectId, Punch_List_Management_System__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                System_Test_Pack_Identification__c previousWP = [select id, Project__c, Work_Process_Status__c from System_Test_Pack_Identification__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess28Status(Id OldSME, Id NewSME, Id ProjectId, MC_RSFU__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Punch_List_Management_System__c previousWP = [select id, Project__c, Work_Process_Status__c from Punch_List_Management_System__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess29Status(Id OldSME, Id NewSME, Id ProjectId, MCA__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                MC_RSFU__c previousWP = [select id, Project__c, Work_Process_Status__c from MC_RSFU__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess30Status(Id OldSME, Id NewSME, Id ProjectId, Close_Out_Report_Lesson_Learnt__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                MCA__c previousWP = [select id, Project__c, Work_Process_Status__c from MCA__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess31Status(Id OldSME, Id NewSME, Id ProjectId, Close_Out_Database__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Close_Out_Report_Lesson_Learnt__c previousWP = [select id, Project__c, Work_Process_Status__c from Close_Out_Report_Lesson_Learnt__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
    public static void UpdateWorkProcess32Status(Id OldSME, Id NewSME, Id ProjectId, CR_Completion_Report__c currentWP) {
        
        if(OldSME == NewSME) {
            
            if(!currentWP.IsWaitingForPreviousStep__c) {
                
                Close_Out_Database__c previousWP = [select id, Project__c, Work_Process_Status__c from Close_Out_Database__c where Project__c =: ProjectId];
                    
                boolean isRecordLock = Approval.isLocked(currentWP.Id);
                
                if(previousWP.Work_Process_Status__c != 'Completed' && isRecordLock) {
                    currentWP.Work_Process_Status__c = 'Waiting for Previous Step';
                    currentWP.IsWaitingForPreviousStep__c = true;
                }    
            }
        }
    }
    
}