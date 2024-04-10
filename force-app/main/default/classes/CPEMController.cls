public class CPEMController {

    public string GetWorkProcessName(Integer WPNo) {
        
        Master_Data__c MD = [select id, name from Master_Data__c where Name =: 'SME and Guideline'];
        
        if(MD != null) {
            
            List<Master_Data_Detail__c> MDDetails = [select id, Master_Data__c, Work_Process_No__c, Name from Master_Data_Detail__c where Master_Data__c =: MD.Id];
            
            if(MDDetails.size() > 0) {
                
                for(Master_Data_Detail__c MDDetail : MDDetails) {
                    
                    if(MDDetail.Work_Process_No__c == WPNo) {
                        
                        return MDDetail.Name;
                        
                    }
                    
                }
                
            }
            
        }
        
        return null;
        
    }
    
    public void UpdateProjectCompletedStatus(Id ProjectId) {
        
        Project__c existProject = [select id, Status__c from Project__c where Id =: ProjectId];
        
        existProject.Status__c = 'Completed';
        update(existProject);
        
    }
    
    public void UpdateActualStartDateWP1(Id ProjectId) {
        
        //Actual Start Date
        Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c, Actual_Start_Date__c from Project_Charter__c where Project__c =: ProjectId];
        
        if(WP1.Actual_Start_Date__c == null) {
            DateTime todayDT = System.Datetime.now();
            Date todayDate = date.newinstance(todayDT.year(), todayDT.month(), todayDT.day());
            WP1.Actual_Start_Date__c = todayDate;
            update(WP1);
        }
        
    }
    
    public void UpdateActualEndDateWP1(Id ProjectId) {
        
        //Actual End Date
        Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c, Actual_End_Date__c from Project_Charter__c where Project__c =: ProjectId];
        
        if(WP1.Actual_End_Date__c == null) {
            DateTime todayDT = System.Datetime.now();
            Date todayDate = date.newinstance(todayDT.year(), todayDT.month(), todayDT.day());
            WP1.Actual_End_Date__c = todayDate;
            update(WP1);
        }
        
    }
    
    public void UpdateSMEForWorkProcess(Integer WPNo, Id SMEId) {
        
        if(WPNo == 0) {
            
            List<Project_Risk_Assessment__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Project_Risk_Assessment__c 
                                                    where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Project_Risk_Assessment__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 1) {
            
            List<Project_Charter__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Project_Charter__c
                                            where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Project_Charter__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 2) {
            
            List<Project_Organization__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Project_Organization__c
                                                    where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Project_Organization__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 3) {
            
            List<Lesson_Learnt_Review__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Lesson_Learnt_Review__c
                                                    where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Lesson_Learnt_Review__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 4) {
            
            List<Project_Execution_Plan__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Project_Execution_Plan__c
                                                    where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Project_Execution_Plan__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 5) {
            
            List<Project_Procurement_Plan__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Project_Procurement_Plan__c
                                                    where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Project_Procurement_Plan__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 6) {
            
            List<WBS_CBS__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from WBS_CBS__c
                                    where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(WBS_CBS__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 7) {
            
            List<Schedule__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Schedule__c
                                     where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Schedule__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 8) {
            
            List<Project_Status_Control__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Project_Status_Control__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Project_Status_Control__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 9) {
            
            List<Budget_Phasing__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Budget_Phasing__c
                                           where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Budget_Phasing__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 10) {
            
            List<ITB_Standard__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from ITB_Standard__c
                                         where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(ITB_Standard__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 11) {
            
            List<CCE_Approval_Process__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from CCE_Approval_Process__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(CCE_Approval_Process__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 12) {
            
            List<Engineering_Standard__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Engineering_Standard__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Engineering_Standard__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 13) {
            
            List<Deliverable_List__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Deliverable_List__c 
                                             where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Deliverable_List__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 14) {
            
            List<Document_Distribution_Matrix__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Document_Distribution_Matrix__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Document_Distribution_Matrix__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 15) {
            
            List<Design_Safety_Standard__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Design_Safety_Standard__c 
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            
            if(WPs.size() > 0) {
                for(Design_Safety_Standard__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 16) {
            
            List<Cost_Estimate__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Cost_Estimate__c
                                          where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Cost_Estimate__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 17) {
            
            List<Engineering_Data_Book_and_3D_Model__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Engineering_Data_Book_and_3D_Model__c 
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Engineering_Data_Book_and_3D_Model__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 18) {
            
            List<ITB_Standard_18__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from ITB_Standard_18__c
                                            where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(ITB_Standard_18__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 19) {
            
            List<CCE_Approval_Process_19__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from CCE_Approval_Process_19__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(CCE_Approval_Process_19__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 20) {
            
            List<Project_Procurement_Contract_Mgmt__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Project_Procurement_Contract_Mgmt__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Project_Procurement_Contract_Mgmt__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 21) {
            
            List<Vendor_Data_Management__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Vendor_Data_Management__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Vendor_Data_Management__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 22) {
            
            List<Material_Inspection_FAT_SAT__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Material_Inspection_FAT_SAT__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Material_Inspection_FAT_SAT__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 23) {
            
            List<Surplus_Spar_part_Management__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Surplus_Spar_part_Management__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Surplus_Spar_part_Management__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 24) {
            
            List<Construction_Management__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Construction_Management__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Construction_Management__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 25) {
            
            List<Budget_Change_Control__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Budget_Change_Control__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Budget_Change_Control__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 26) {
            
            List<System_Test_Pack_Identification__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from System_Test_Pack_Identification__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(System_Test_Pack_Identification__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 27) {
            
            List<Punch_List_Management_System__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Punch_List_Management_System__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Punch_List_Management_System__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 28) {
            
            List<MC_RSFU__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from MC_RSFU__c
                                    where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(MC_RSFU__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 29) {
            
            List<MCA__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from MCA__c
                                where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(MCA__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 30) {
            
            List<Close_Out_Report_Lesson_Learnt__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Close_Out_Report_Lesson_Learnt__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Close_Out_Report_Lesson_Learnt__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 31) {
            
            List<Close_Out_Database__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from Close_Out_Database__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(Close_Out_Database__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        else if(WPNo == 32) {
            
            List<CR_Completion_Report__c> WPs = [select id, SME__c, No__c, Project__r.Status__c from CR_Completion_Report__c
                                     				where No__c =: WPNo AND (Project__r.Status__c = 'New' OR Project__r.Status__c = 'Ongoing')];
            if(WPs.size() > 0) {
                for(CR_Completion_Report__c WP : WPs) {
                    WP.SME__c = SMEId;
                }    
                
                update(WPs);
            }
            
        }
        
    }
    
    public void SendMailToAssignUser(string WPId, Integer WPNo, Id NewAssignedUserId, string WPName) {
        
        string baseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        string WPURL = baseURL + 'lightning/r/' + WPId + '/view';
        
        if(Test.isRunningTest()){
            System.debug('No email send out.');
        }
        else{
            
            //Find Assigned User
            Assigned_User__c AU = [select id, BE_Work_Process_ID__c, BE_Work_Process_Name__c, User__c from Assigned_User__c where Id =: NewAssignedUserId];
            AU.BE_Work_Process_ID__c = WPId;
            AU.BE_Work_Process_Name__c = WPNo + ' - ' + WPName;
            AU.BE_Work_Process_URL__c = WPURL;            
            update(AU);
            
            //Find User
            User assignedUser = [select id, Email from User where Id =: AU.User__c];
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            //message.setReplyTo(‘no-reply@company.com’);
            //message.setUseSignature(false); 
            //message.setBccSender(false); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Reassign Notification'];
            
            message.setTargetObjectId(AU.User__c); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(AU.Id);
            message.toAddresses = new String[] { assignedUser.email};
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
        
        
    }
}