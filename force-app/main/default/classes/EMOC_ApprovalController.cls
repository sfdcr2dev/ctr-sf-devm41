public class EMOC_ApprovalController {
   @AuraEnabled
    public static Map<String, Object> getDetailApproval (String Id, String sobjecttype) {
        sobjecttype = String.escapeSingleQuotes(sobjecttype);
        String UserId = userInfo.getUserId();
        Id currentUserProfileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id =: currentUserProfileId].Name;

        Map<String, Object> detailApproval = new Map<String, Object>();
        detailApproval.put('Id', ''); 
        detailApproval.put('OriginalActorId', ''); 
        detailApproval.put('AssignedTo', ''); 
        detailApproval.put('DateSubmited', ''); 
        detailApproval.put('ActorId', ''); 
        detailApproval.put('ActualApprover', ''); 
        detailApproval.put('CreatedById', ''); 
        detailApproval.put('Submitter', ''); 
        detailApproval.put('status', ''); 
        detailApproval.put('objectName', ''); 
        detailApproval.put('subjectName', ''); 
        detailApproval.put('MOCType', ''); 
        detailApproval.put('checkBtnHold', false);
        detailApproval.put('checkBtnReject', false);
        detailApproval.put('checkBtnSendback', false);
        detailApproval.put('checkSequence', false);
        detailApproval.put('labelApprove', 'Approve');
        detailApproval.put('StatusCommonWorkflow', ''); 
        detailApproval.put('StatusFunctionalOverride', ''); 
		detailApproval.put('RecordTypeName', ''); 
        
        if (sobjecttype == 'ProcessInstanceStep') {
            ProcessInstanceStep[] piStep = [SELECT Id, OriginalActorId,OriginalActor.Name, CreatedDate, ActorId, Actor.Name, CreatedById, CreatedBy.Name, StepStatus, ProcessInstance.ProcessDefinition.TableEnumOrId, ProcessInstance.TargetObjectId 
                                            FROM ProcessInstanceStep WHERE Id=:Id ];
  
            Map<String, SObjectType> sObjects = Schema.getGlobalDescribe();  
            if (piStep.size() > 0) {
                DateTime CreatedDate = piStep[0].CreatedDate;
                String NameTableEnumOrId = piStep[0].ProcessInstance.ProcessDefinition.TableEnumOrId; // = E_MOC_Application__c
           
                detailApproval.put('Id', piStep[0].Id);
                detailApproval.put('OriginalActorId', piStep[0].OriginalActorId);
                detailApproval.put('AssignedTo', piStep[0].OriginalActor.Name);
                detailApproval.put('DateSubmited', String.valueOf(CreatedDate.date()));
                detailApproval.put('ActorId', piStep[0].ActorId);
                detailApproval.put('ActualApprover', piStep[0].Actor.Name);
                detailApproval.put('CreatedById', piStep[0].CreatedById);
                detailApproval.put('Submitter', piStep[0].CreatedBy.Name);
                detailApproval.put('status', piStep[0].StepStatus);
                detailApproval.put('objectName', sObjects.get(NameTableEnumOrId).getDescribe().getLabel());
                detailApproval.put('subjectName', 'Process Instance Step'); 
                
                GroupMember[] GroupMember = [SELECT UserOrGroupId,GroupId from GroupMember where GroupId = :piStep[0].OriginalActorId and UserOrGroupId = :UserId ];
              /*  if ((GroupMember.size() > 0 || profileName == 'System Administrator' || profileName == 'Working Team' || profileName == 'E-MOC User' || profileName == 'E-MOC Users' || profileName == 'E-MOC Test') && piStep[0].StepStatus == 'Pending') {
                    detailApproval.put('checkSequence', true);
                }*/
                if (piStep[0].StepStatus == 'Pending') {
                   detailApproval.put('checkSequence', true); 
                }
                    
                E_MOC_Application__c[] emocApp = [SELECT Id, MOC_Type__c, Name, Status_Common_Workflow__c,Status_Functional_Override__c ,Step__c, RecordType.Name,Extend_Require_to_extend__c,Extend_Require_to_extend_to_prevent__c,No_Correct_the_problem__c
                                                  FROM E_MOC_Application__c WHERE Id = :piStep[0].ProcessInstance.TargetObjectId Limit 1];

                if (emocApp.size() > 0) {
                    detailApproval.put('RecordTypeName', emocApp[0].RecordType.Name);
                    detailApproval.put('MOCType', emocApp[0].MOC_Type__c);
                    detailApproval.put('StatusCommonWorkflow', emocApp[0].Status_Common_Workflow__c);
                    detailApproval.put('StatusFunctionalOverride', emocApp[0].Status_Functional_Override__c);

                    E_MOC_Hold_History__c[] emocHold = [SELECT Id, E_MOC_Application__c  FROM E_MOC_Hold_History__c 
                                                        WHERE   E_MOC_Application__c = :emocApp[0].Id
                                                        AND Step__c     = :emocApp[0].Step__c 
                                                        AND CreatedById = :UserId
                                                        AND (Status__c  = :emocApp[0].Status_Common_Workflow__c
                                                        OR Status__c    = :emocApp[0].Status_Functional_Override__c)
                                                        Limit 1];
                    
                    if (emocApp[0].RecordType.Name  == 'Common Workflow') {
                        if (emocHold.size() > 0 || emocApp[0].Status_Common_Workflow__c == 'Budget Registration' || emocApp[0].Status_Common_Workflow__c == 'Concept Approval' || emocApp[0].Status_Common_Workflow__c == 'Readiness Review') {
                            detailApproval.put('checkBtnHold', true);
                            if (emocApp[0].Status_Common_Workflow__c == 'Readiness Review') {
                              detailApproval.put('checkBtnReject', true);
                            }
                        }
                        if (emocApp[0].Status_Common_Workflow__c == 'Close Out') {
                            detailApproval.put('labelApprove', 'Verify');
                            detailApproval.put('checkBtnReject', true);
                            detailApproval.put('checkBtnHold', true);
                        } else if (emocApp[0].Status_Common_Workflow__c == 'Closed') {
                            detailApproval.put('labelApprove', 'Acknowledge');
                            detailApproval.put('checkBtnSendback', true);
                            detailApproval.put('checkBtnReject', true);
                            detailApproval.put('checkBtnHold', true);
                        } else if ((emocApp[0].Status_Common_Workflow__c == 'Hazard Screening' || emocApp[0].Status_Common_Workflow__c == 'Technical Review' || emocApp[0].Status_Common_Workflow__c == 'APU Approval' || emocApp[0].Status_Common_Workflow__c == 'VP Approval') && (emocApp[0].Extend_Require_to_extend__c == true || emocApp[0].Extend_Require_to_extend_to_prevent__c == true || emocApp[0].No_Correct_the_problem__c == true)) {
                            detailApproval.put('checkBtnReject', true);
                        }
                    } else if (emocApp[0].RecordType.Name  == 'Functional Override') {
                        if (emocHold.size() > 0 || emocApp[0].Status_Functional_Override__c == 'Approval #1') {   
                            detailApproval.put('checkBtnHold', true);
                            detailApproval.put('checkBtnSendback', true);
                        } else if (emocApp[0].Status_Functional_Override__c == 'Risk assessment') {
                            detailApproval.put('checkBtnHold', true);
                            detailApproval.put('checkBtnReject', true);
                        } else if (emocApp[0].Status_Functional_Override__c == 'Technical review' || emocApp[0].Status_Functional_Override__c == 'Approval #3 (APU)' || emocApp[0].Status_Functional_Override__c == 'Approval #3 (VP)') {
                            detailApproval.put('checkBtnReject', true);
                        } else if (emocApp[0].Status_Functional_Override__c == 'Approval #2') {
                            detailApproval.put('checkBtnHold', true);
                            detailApproval.put('checkBtnSendback', true);
                            detailApproval.put('checkBtnReject', true);
                        }
                    }
                } else {
                    detailApproval.put('RecordTypeName', 'Standard');
                }
            }
            
        } else {
            ProcessInstanceWorkItem[] piStep = [SELECT Id, OriginalActorId,OriginalActor.Name, CreatedDate, ActorId, Actor.Name, CreatedById, CreatedBy.Name, 
                                        ProcessInstance.Status, ProcessInstance.ProcessDefinition.TableEnumOrId , ProcessInstance.TargetObjectId 
                                        FROM ProcessInstanceWorkItem where Id = :Id];

            Map<String, SObjectType> sObjects = Schema.getGlobalDescribe();  
            if (piStep.size() > 0) {
                DateTime CreatedDate = piStep[0].CreatedDate;
                String NameTableEnumOrId = piStep[0].ProcessInstance.ProcessDefinition.TableEnumOrId; // = E_MOC_Application__c
           
                detailApproval.put('Id', piStep[0].Id);
                detailApproval.put('OriginalActorId', piStep[0].OriginalActorId);
                detailApproval.put('AssignedTo', piStep[0].OriginalActor.Name);
                detailApproval.put('DateSubmited', String.valueOf(CreatedDate.date()));
                detailApproval.put('ActorId', piStep[0].ActorId);
                detailApproval.put('ActualApprover', piStep[0].Actor.Name);
                detailApproval.put('CreatedById', piStep[0].CreatedById);
                detailApproval.put('Submitter', piStep[0].CreatedBy.Name);
                detailApproval.put('status', piStep[0].ProcessInstance.Status);
                detailApproval.put('objectName', sObjects.get(NameTableEnumOrId).getDescribe().getLabel());
                detailApproval.put('subjectName', 'Approval Request'); 
                
                GroupMember[] GroupMember = [SELECT UserOrGroupId,GroupId from GroupMember where GroupId = :piStep[0].OriginalActorId and UserOrGroupId = :UserId ];
              /*  if ((GroupMember.size() > 0 || profileName == 'System Administrator' || profileName == 'Working Team' || profileName == 'E-MOC User' || profileName == 'E-MOC Users' || profileName == 'E-MOC Test') && piStep[0].ProcessInstance.Status == 'Pending') {
                    detailApproval.put('checkSequence', true);
                }*/
                if (piStep[0].ProcessInstance.Status == 'Pending') {
                    detailApproval.put('checkSequence', true);
                }
                    
                E_MOC_Application__c[] emocApp = [SELECT Id, MOC_Type__c, Name, Status_Common_Workflow__c,Status_Functional_Override__c ,Step__c, 
                                                  RecordType.Name, Extend_Require_to_extend__c,Extend_Require_to_extend_to_prevent__c,No_Correct_the_problem__c
                                                  FROM E_MOC_Application__c WHERE Id = :piStep[0].ProcessInstance.TargetObjectId Limit 1];

                if (emocApp.size() > 0) {
                    detailApproval.put('RecordTypeName', emocApp[0].RecordType.Name);
                    detailApproval.put('MOCType', emocApp[0].MOC_Type__c);
                    detailApproval.put('StatusCommonWorkflow', emocApp[0].Status_Common_Workflow__c);
                    detailApproval.put('StatusFunctionalOverride', emocApp[0].Status_Functional_Override__c);

                    E_MOC_Hold_History__c[] emocHold = [SELECT Id, E_MOC_Application__c  FROM E_MOC_Hold_History__c 
                                                        WHERE   E_MOC_Application__c = :emocApp[0].Id
                                                        AND Step__c     = :emocApp[0].Step__c 
                                                        AND CreatedById = :UserId
                                                        AND (Status__c  = :emocApp[0].Status_Common_Workflow__c
                                                        OR Status__c    = :emocApp[0].Status_Functional_Override__c)
                                                        Limit 1];
                    if (emocApp[0].RecordType.Name  == 'Common Workflow') {
                        if (emocHold.size() > 0 || emocApp[0].Status_Common_Workflow__c == 'Budget Registration' || emocApp[0].Status_Common_Workflow__c == 'Concept Approval' || emocApp[0].Status_Common_Workflow__c == 'Readiness Review') {
                            detailApproval.put('checkBtnHold', true);
                            if (emocApp[0].Status_Common_Workflow__c == 'Readiness Review') {
                              detailApproval.put('checkBtnReject', true);
                            }
                        }
                        if (emocApp[0].Status_Common_Workflow__c == 'Close Out') {
                            detailApproval.put('labelApprove', 'Verify');
                            detailApproval.put('checkBtnReject', true);
                            detailApproval.put('checkBtnHold', true);
                        } else if (emocApp[0].Status_Common_Workflow__c == 'Closed') {
                            detailApproval.put('labelApprove', 'Acknowledge');
                            detailApproval.put('checkBtnSendback', true);
                            detailApproval.put('checkBtnReject', true);
                            detailApproval.put('checkBtnHold', true);
                        } else if ((emocApp[0].Status_Common_Workflow__c == 'Hazard Screening' || emocApp[0].Status_Common_Workflow__c == 'Technical Review' || emocApp[0].Status_Common_Workflow__c == 'APU Approval' || emocApp[0].Status_Common_Workflow__c == 'VP Approval') && (emocApp[0].Extend_Require_to_extend__c == true || emocApp[0].Extend_Require_to_extend_to_prevent__c == true || emocApp[0].No_Correct_the_problem__c == true)) {
                            detailApproval.put('checkBtnReject', true);
                        }
                    } else if (emocApp[0].RecordType.Name  == 'Functional Override') {
                        if (emocHold.size() > 0 || emocApp[0].Status_Functional_Override__c == 'Approval #1') {   
                            detailApproval.put('checkBtnHold', true);
                            detailApproval.put('checkBtnSendback', true);
                        } else if (emocApp[0].Status_Functional_Override__c == 'Risk assessment') {
                            detailApproval.put('checkBtnHold', true);
                            detailApproval.put('checkBtnReject', true);
                        } else if (emocApp[0].Status_Functional_Override__c == 'Technical review' || emocApp[0].Status_Functional_Override__c == 'Approval #3 (APU)' || emocApp[0].Status_Functional_Override__c == 'Approval #3 (VP)') {
                            detailApproval.put('checkBtnReject', true);
                        } else if (emocApp[0].Status_Functional_Override__c == 'Approval #2') {
                            detailApproval.put('checkBtnHold', true);
                            detailApproval.put('checkBtnSendback', true);
                            detailApproval.put('checkBtnReject', true);
                        }
                    }
                } else {
                    detailApproval.put('RecordTypeName', 'Standard');
                }
        
            }
        }

        return detailApproval;
    } 
    
    @AuraEnabled
    public static Id  callApprovedOrRejectProcess(String recordId, String comment,String State,String sobjecttype) {
        recordId = String.escapeSingleQuotes(recordId);
        state = String.escapeSingleQuotes(State);
        comment = String.escapeSingleQuotes(comment);
        sobjecttype = String.escapeSingleQuotes(sobjecttype);
        String idInstance = '';
        String stepId = '';
        String statusPath = '';
        String stepStatus = '';
        Integer dayEmocTimeline = 0;

        Map<String, Object> Params = new Map<String, Object>();
		Map<String, String> paramAutomationTask = new Map<String, String>();
        if (state == 'Hold') {
            if (sobjecttype == 'ProcessInstanceStep') {
                ProcessInstanceStep step = [SELECT Id, ProcessInstance.TargetObjectId  FROM ProcessInstanceStep WHERE Id = :recordId];
                idInstance = step.ProcessInstance.TargetObjectId; 
            } else {
                ProcessInstanceWorkItem processItem = [SELECT Id,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkItem WHERE Id = :recordId];
                idInstance = processItem.ProcessInstance.TargetObjectId; 
            }
            
            E_MOC_Application__c  emocApp = [SELECT Id, Status_Common_Workflow__c, Status_Functional_Override__c, Next_Reminder_Date__c, RecordType.Name, Change_Type__c, RAM_Total__c , Step__c
                                             FROM E_MOC_Application__c WHERE Id = :idInstance ];  
 
            E_MOC_Timeline__c[]  emocTimeline = [SELECT Id, Change_Type__c , Status__c, RAM_Level__c,Day__c, Step__c  FROM E_MOC_Timeline__c  
                                               WHERE  Change_Type__c   = :emocApp.Change_Type__c
                                               AND RAM_Level__c     = :emocApp.RAM_Total__c
                                               AND Step__c          = :emocApp.Step__c
                                               AND (Status__c       = :emocApp.Status_Common_Workflow__c
                                               OR Status__c         = :emocApp.Status_Functional_Override__c )];  
            
            if (emocTimeline.size() > 0) {
                if (emocTimeline[0].Day__c != null) {
                    Integer day =  Integer.valueof(emocTimeline[0].Day__c);
                    Date dueDate = emocApp.Next_Reminder_Date__c.addDays(day);
                    
                    emocApp.Next_Reminder_Date__c   = dueDate;
                    update emocApp;
                    dayEmocTimeline = Integer.valueof(emocTimeline[0].Day__c);
                }
                statusPath = emocTimeline[0].Status__c;
                stepStatus = emocTimeline[0].Step__c;
            }
            
            E_MOC_Hold_History__c  EMOCHold = new E_MOC_Hold_History__c (
                Comment__c              = comment,
                E_MOC_Application__c    = emocApp.Id,
                Status__c               = statusPath,
                Step__c                 = stepStatus,
                Day__c                  = dayEmocTimeline,
                Next_Reminder_Date__c   = emocApp.Next_Reminder_Date__c
            );
            insert EMOCHold;
            
            stepId = recordId;
            return stepId;
        } else {
            if (sobjecttype == 'ProcessInstanceStep') {
                ProcessInstanceStep step = [SELECT Id, ProcessInstance.TargetObjectId, OriginalActorId,ActorId FROM ProcessInstanceStep WHERE Id = :recordId];
                E_MOC_Application__c  emocApp = [SELECT Id,Functional_Override__c, Status_Common_Workflow__c, Status_Functional_Override__c, TA_Sendback_Comment__c, E_MOC_Type__c FROM E_MOC_Application__c WHERE Id = :step.ProcessInstance.TargetObjectId ];  
				
                paramAutomationTask.put('emocId', emocApp.Id);
                paramAutomationTask.put('statusCommonWorkflow', emocApp.Status_Common_Workflow__c);
                paramAutomationTask.put('statusFunctionalOverride', emocApp.Status_Functional_Override__c); 
                paramAutomationTask.put('originalActorId', step.OriginalActorId); 
            
                paramAutomationTask.put('actorId', step.ActorId); 
                
                if (emocApp.Functional_Override__c == true && emocApp.Status_Functional_Override__c == 'Technical review') {
                    List<ProcessInstanceStep> processInstancePending = [SELECT Id, ProcessInstanceId, ActorId ,ProcessInstance.TargetObjectId 
                                                                        FROM ProcessInstanceStep 
                                                                        WHERE ProcessInstance.TargetObjectId = :step.ProcessInstance.TargetObjectId
                                                                        AND ProcessInstance.Status = 'Pending' ]; 
                    if (state == 'Removed') {
                        for(ProcessInstanceStep p : processInstancePending) {                            
                            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest () ;
                            req.setAction('Removed');
                            req.setComments(comment);
                            req.setWorkitemId(p.Id); 
                            Approval.ProcessResult result = Approval.process(req); 
                        }
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_FN_TA_send_back_to_Risk_assessment flow1 = new Flow.Interview.E_MOC_FN_TA_send_back_to_Risk_assessment(Params); 
                        flow1.start();
                        stepId = step.Id;
                    } else if (state == 'Approve') {
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest () ;
                        req.setAction(state);
                        req.setComments(comment);
                        req.setWorkitemId(step.Id);
                        Approval.ProcessResult result = Approval.process(req);
                        stepId = step.Id;
                        if (processInstancePending.size() == 1) {
                            emocApp.Status_Functional_Override__c = 'Approval #3 (APU)';
                            update emocApp;
                        }
                    }
                    callAutomationTask(paramAutomationTask); 
                } else {
                    if (state == 'Removed' && emocApp.Status_Common_Workflow__c == 'VP Approval') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_VP_Approval_send_back flow1 = new Flow.Interview.E_MOC_VP_Approval_send_back(Params); 
                        flow1.start();
                    } 
                    if (state == 'Removed' && emocApp.Status_Functional_Override__c == 'Approval #3 (VP)') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_FN_VP_Approval_send_back flow1 = new Flow.Interview.E_MOC_FN_VP_Approval_send_back(Params); 
                        if (!Test.isRunningTest()) {
                        flow1.start();
                        }
                    } 
                    if (state == 'Removed' && emocApp.Status_Functional_Override__c == 'Approval #3 (APU)') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_Send_email_to_TA flow1 = new Flow.Interview.E_MOC_Send_email_to_TA(Params); 
                        if (!Test.isRunningTest()) {
                            flow1.start();
                        }
                        emocApp.TA_Sendback_Comment__c = comment;
                    }
                    if (state == 'Removed' && emocApp.Status_Functional_Override__c == 'Risk assessment') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_FN_Risk_assessment_Approver_send_back flow1 = new Flow.Interview.E_MOC_FN_Risk_assessment_Approver_send_back(Params); 
                        flow1.start();
                    }

                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest () ;
                    req.setAction(state);
                    req.setComments(comment);
                    req.setWorkitemId(step.Id);
                    if (!Test.isRunningTest()) {
                    	Approval.ProcessResult result = Approval.process(req);
                    }
                    stepId = step.Id;
                    callAutomationTask(paramAutomationTask); 
                }

            } else {
                ProcessInstanceWorkItem processItem = [SELECT Id, ProcessInstanceId,ActorId ,ProcessInstance.TargetObjectId, OriginalActorId FROM ProcessInstanceWorkItem WHERE Id = :recordId];
                
                E_MOC_Application__c  emocApp = [SELECT Id,Functional_Override__c, Status_Common_Workflow__c, Status_Functional_Override__c, TA_Sendback_Comment__c,E_MOC_Type__c FROM E_MOC_Application__c WHERE Id = :processItem.ProcessInstance.TargetObjectId ];  
                
                paramAutomationTask.put('emocId', emocApp.Id);
                paramAutomationTask.put('statusCommonWorkflow', emocApp.Status_Common_Workflow__c);
                paramAutomationTask.put('statusFunctionalOverride', emocApp.Status_Functional_Override__c);
                paramAutomationTask.put('originalActorId', processItem.OriginalActorId); 
                
                paramAutomationTask.put('actorId', processItem.ActorId); 

                if (emocApp.Functional_Override__c == true && emocApp.Status_Functional_Override__c == 'Technical review') {
                    List<ProcessInstanceWorkItem> processItemPending = [SELECT Id, ProcessInstanceId, ActorId ,ProcessInstance.TargetObjectId 
                                                                        FROM ProcessInstanceWorkItem 
                                                                        WHERE ProcessInstance.TargetObjectId = :processItem.ProcessInstance.TargetObjectId
                                                                        AND ProcessInstance.Status = 'Pending' ]; 
                    if (state == 'Removed') {
                        for(ProcessInstanceWorkItem p : processItemPending) {
                            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest () ;
                            req.setAction('Removed');
                            req.setComments(comment);
                            req.setWorkitemId(p.Id); 
                            Approval.ProcessResult result = Approval.process(req); 
                        }
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_FN_TA_send_back_to_Risk_assessment flow1 = new Flow.Interview.E_MOC_FN_TA_send_back_to_Risk_assessment(Params); 
                        flow1.start();
                        ProcessInstanceStep step = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstanceId = :processItem.ProcessInstanceId limit 1];
                        stepId = step.Id;
                    } else if (state == 'Approve') {
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest () ;
                        req.setAction(state);
                        req.setComments(comment);
                        req.setWorkitemId(processItem.Id);
                        Approval.ProcessResult result = Approval.process(req);
                        ProcessInstanceStep step = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstanceId = :processItem.ProcessInstanceId limit 1];
                        stepId = step.Id;
                        if (processItemPending.size() == 1) {
                            emocApp.Status_Functional_Override__c = 'Approval #3 (APU)';
                            update emocApp;
                        }
                    }
                    callAutomationTask(paramAutomationTask);
                } else {
                    if (state == 'Removed' && emocApp.Status_Common_Workflow__c == 'VP Approval') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_VP_Approval_send_back flow1 = new Flow.Interview.E_MOC_VP_Approval_send_back(Params); 
                        flow1.start();
                    }
                    if (state == 'Removed' && emocApp.Status_Functional_Override__c == 'Approval #3 (VP)') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_FN_VP_Approval_send_back flow1 = new Flow.Interview.E_MOC_FN_VP_Approval_send_back(Params); 
                        flow1.start();
                    }
                    if (state == 'Removed' && emocApp.Status_Functional_Override__c == 'Approval #3 (APU)') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_Send_email_to_TA flow1 = new Flow.Interview.E_MOC_Send_email_to_TA(Params); 
                        if (!Test.isRunningTest()) {
                            flow1.start();
                        }
                        emocApp.TA_Sendback_Comment__c = comment;
                    }
                    if (state == 'Removed' && emocApp.Status_Functional_Override__c == 'Risk assessment') {
                        Params.put('recordId', emocApp.Id);
                        Flow.Interview.E_MOC_FN_Risk_assessment_Approver_send_back flow1 = new Flow.Interview.E_MOC_FN_Risk_assessment_Approver_send_back(Params); 
                        flow1.start();
                    }
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest () ;
                    req.setAction(state);
                    req.setComments(comment);
                    req.setWorkitemId(processItem.Id);
                    
                    Approval.ProcessResult result = Approval.process(req);

                    ProcessInstanceStep step = [SELECT Id FROM ProcessInstanceStep WHERE ProcessInstanceId = :processItem.ProcessInstanceId limit 1];
                    stepId = step.Id;
                    
                    callAutomationTask(paramAutomationTask); 
                }
            }
            return stepId;
        }
    }
    
    public static Map<String, String> callAutomationTask (MAP<String, String> paramAutomationTask) {
        Map<String, String> responseStatus= new Map<String, String>();
        
        String emocId = paramAutomationTask.get('emocId');
        String statusCommonWorkflow = paramAutomationTask.get('statusCommonWorkflow');
        String statusFunctionalOverride = paramAutomationTask.get('statusFunctionalOverride'); 
        String originalActorId = paramAutomationTask.get('originalActorId');
        String actorId = paramAutomationTask.get('actorId');
        string query = 'SELECT Id, Subject, Status  FROM Task WHERE WhatId = \'' + emocId + '\' AND Status = \'Open\' AND  OwnerId = \'' + originalActorId + '\' ';
        
      // Common Workflow
        if (statusCommonWorkflow == 'Concept Approval') {
            query += ' AND (Subject = \'Concept Approval-1-Line Manager\' OR Subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMA\' OR Subject = \'Approval #2 SM\' OR Subject = \'Approval #2 POM\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMB\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMC\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMD\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENME\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-ENMF\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPA\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPB\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPC\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPD\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNPE\' '+ 
                ' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNFX\' OR subject = \'Select MOC Focal Point & Concept Approval-2-APUs-TNFL\' '+
                ' OR subject = \'Concept Approval-2-APUs-SCSC\' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMA\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMB\' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMC\' '+ 
                ' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMD\' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENME\' '+
                ' OR subject = \'Select MOC Focal Point & Concept Approval-3-APUs-ENMF\' OR subject = \'Concept Approval-2-APUs\' OR subject = \'Concept Approval-3-APUs\' )';
        } else if (statusCommonWorkflow == 'Budget Registration') {
            query += ' AND Subject = \'Budget Approval\' ';
        } else if (statusCommonWorkflow == 'Hazard Screening') {
            query += ' AND Subject = \'Risk Approval\' ';
        } else if (statusCommonWorkflow == 'APU Approval') {
            query += ' AND Subject = \'APU Approval\' ';
        } else if (statusCommonWorkflow == 'VP Approval') {
            query += ' AND Subject = \'VP Approval\' ';
        } else if (statusCommonWorkflow == 'Readiness Review') {
            query += ' AND Subject = \'SOF/SU Approval\' ';
        } else if (statusCommonWorkflow == 'Close Out') {
            query += ' AND (Subject = \'Verify whether all documents/drawing is updated\' OR Subject = \'Ensure all requirement is met objectives\' )';
        } else if (statusCommonWorkflow == 'Closed') {
            query += ' AND Subject = \'Approve lesson learned\' ';
        }
		// Functional Override
        else if (statusFunctionalOverride == 'Approval #1') { 
            query += ' AND (Subject = \'Approval #1 ASM\' OR Subject = \'Approval #1 SM or POM\' OR Subject = \'Approval #1 Mechanical Duty Engineer\' OR Subject = \'Approval #1 ENMx or Duty Engineer\' OR Subject = \'Approval #1 POM\' OR Subject = \'Approval #1 SM\' )';
        } else if (statusFunctionalOverride == 'Approval #2') {
            query += ' AND (Subject = \'Approval #2 ASM\' OR Subject = \'Approval #2 SM or POM\' OR Subject = \'Approval #2 SM\' OR Subject = \'Approval #2 POM\' )';
        } else if (statusFunctionalOverride == 'Risk assessment') {
            query += ' AND Subject = \'Risk Approval\' ';
        } else if (statusFunctionalOverride == 'Technical review') {
            for(GroupMember gmList: [SELECT Id,Group.Name,GroupId,UserOrGroupId from GroupMember where GroupId  = :actorId]){
                List<Task> TaskList = [SELECT Id, Subject, Status  FROM Task WHERE WhatId = :emocId AND Status = 'Open' 
                                       AND (Subject = 'TA Review' OR Subject = 'TA 3 Review') 
                                       AND OwnerId = :gmList.UserOrGroupId  Limit 1]; 
                if (TaskList.size() > 0) {
                    TaskList[0].Status = 'Completed';
                    update TaskList;
                }
            }
        } else if (statusFunctionalOverride == 'Approval #3 (APU)') {
            query += ' AND (Subject = \'APU Approval\' OR Subject = \'Approval #3 (APU)\' )';
        } else if (statusFunctionalOverride == 'Approval #3 (VP)') {
            query += ' AND (Subject = \'VP Approval\' OR Subject = \'Approval #3 (VP)\' )';
        }

        if (statusFunctionalOverride != 'Technical review') {
            List<Task> TaskList = new List<Task>();
        	TaskList = Database.query(query);

            if (TaskList.size() > 0) {
                TaskList[0].Status = 'Completed';
                update TaskList;
            }
        }
        return responseStatus;
    }
}