/**
 * @author Oktana
 * @description handles lookup records retrieval
 */
public without sharing class THOR_CustomLookupController {
    /**
     * @description
     * @param objectName sObject to retrieve from
     * @param filterField field to search on
     * @param searchString filter value
     * @param value recordId
     * @param additionalConstraint any additional constraints
     */
    @AuraEnabled
    public static List<RecordsData> fetchRecords(
        String objectName,
        String filterField,
        String searchString,
        String value,
        String additionalConstraint, 
        String stepIds,
        String action
    ) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM ' + objectName;
            // special approve case
            if(stepIds != null) {
                if(action == 'SpecialApprove') {
                    List<ProcessInstance> approvalSteps = [ SELECT Id, Status, CreatedDate, CompletedDate, TargetObjectId, SubmittedBy.Name, ( SELECT Id, StepStatus, Actor.Id, OriginalActor.Name, ElapsedTimeInDays, ElapsedTimeInMinutes, CreatedDate, ProcessNodeId, ProcessNode.Name, Comments FROM StepsAndWorkitems ORDER BY StepStatus DESC ) FROM ProcessInstance WHERE TargetObjectId = :stepIds ORDER BY CreatedDate DESC, Status DESC ];

                Discipline_Mapping__mdt discipline = new Discipline_Mapping__mdt();
                EQCC_Step__c step = [SELECT Id, Step_Number__c, Form_Code__c, Owner.Name, Header_Sheet__r.Header__c FROM EQCC_Step__c WHERE Id = :stepIds];
                EQCC_Header__c header = [SELECT Id, FunctionalLocation__c, Equipment__c FROM EQCC_Header__c WHERE Id =: step.Header_Sheet__r.Header__c];
                if(header.Equipment__c != null) {
                    Equipment__c eq = [SELECT Id, maintenancePlant__r.Name, plantSection__c FROM Equipment__c WHERE Id =: header.Equipment__c];
                    discipline = [SELECT Id, Area__c, Plant_Section_Description__c FROM Discipline_Mapping__mdt WHERE Maintenance_Plant__c =: eq.maintenancePlant__r.Name AND Plant_Section__c =: eq.plantSection__c];
                }
                else {
                    Functional_Location__c fl = [SELECT Id, Maintenance_Plant__r.Name, PlantSection__c FROM Functional_Location__c WHERE Id =: header.FunctionalLocation__c];
                    discipline = [SELECT Id, Area__c, Plant_Section_Description__c FROM Discipline_Mapping__mdt WHERE Maintenance_Plant__c =: fl.Maintenance_Plant__r.Name AND Plant_Section__c =: fl.PlantSection__c];
                }

                User user = [SELECT Id, UserRole.Name From User WHERE Id =: UserInfo.getUserId()];
                String roleName = user.UserRole.Name;
                for (ProcessInstance approvalStep : approvalSteps) {
                    for (ProcessInstanceHistory pi : approvalStep.StepsAndWorkitems) {
                        String status = pi.StepStatus == 'Rejected' ? 'Revision' : pi.StepStatus;
                        if (status == 'Pending') {
                            String teamLeadM = 'APU-' + discipline.Area__c + ' Team Lead-ENM' + discipline.Area__c + '-M/' + discipline.Plant_Section_Description__c;
                            String teamLeadE = 'APU-' + discipline.Area__c + ' Team Lead-ENM' + discipline.Area__c + '-E/' + discipline.Plant_Section_Description__c;
                            String teamLeadI = 'APU-' + discipline.Area__c + ' Team Lead-ENM' + discipline.Area__c + '-I/' + discipline.Plant_Section_Description__c;
                            String teamLeadENRM = 'ENRM Team Lead-ENRM';
                            String coOrENRM = 'ENRM Co-Ordinator-ENRM';
                            String managerENRM = 'ENRM Manager';
                            if(roleName.contains(teamLeadM)) {
                                if(searchString == '') {
                                    query += ' WHERE ' + ' ( UserRole.Name LIKE ' + '\'%' + teamLeadE + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadI + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + coOrENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + managerENRM + '%\'' + ' )';
                                    query += ' LIMIT 25';
                                }
                                else {
                                    query += ' WHERE ' + filterField + ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' + ' AND ( UserRole.Name LIKE ' + '\'%' + teamLeadE + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadI + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + coOrENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + managerENRM + '%\'' + ' )';
                                    query += ' LIMIT 25';
                                }
                            }
                            else if(roleName.contains(teamLeadE)) {
                                if(searchString == '') {
                                    query += ' WHERE ' + ' ( UserRole.Name LIKE ' + '\'%' + teamLeadM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadI + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + coOrENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + managerENRM + '%\'' + ' )'; query += ' LIMIT 25';
                                }
                                else {
                                    query += ' WHERE ' + filterField + ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' + ' AND ( UserRole.Name LIKE ' + '\'%' + teamLeadM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadI + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + coOrENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + managerENRM + '%\'' + ' )';
                                    query += ' LIMIT 25';
                                }
                            }
                            else if(roleName.contains(teamLeadI)) {
                                if(searchString == '') {
                                    query += ' WHERE ' + ' ( UserRole.Name LIKE ' + '\'%' + teamLeadE + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadE + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + coOrENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + managerENRM + '%\'' + ' )';
                                    query += ' LIMIT 25';
                                }
                                else {
                                    query += ' WHERE ' + filterField + ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' + ' AND ( UserRole.Name LIKE ' + '\'%' + teamLeadM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadE + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + teamLeadENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + coOrENRM + '%\'' + ' OR UserRole.Name LIKE ' + '\'%' + managerENRM + '%\'' + ' )';
                                    query += ' LIMIT 25';
                                }
                            }
                        }
                    }
                } 
                }
                else {
                    if (String.isNotBlank(value)) {
                        query += ' WHERE Id = \'' + value + '\'';
                        if (String.isNotBlank(additionalConstraint)) {
                            query += ' ' + additionalConstraint;
                        }
                        query += ' LIMIT 25';
                    } else {
                        query += ' WHERE ' + filterField + ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                        if (String.isNotBlank(additionalConstraint)) {
                            query += ' ' + additionalConstraint;
                        }
                        query += ' LIMIT 25';
                    }
                }     
            }
            else {
                if (String.isNotBlank(value)) {
                    query += ' WHERE Id = \'' + value + '\'';
                    if (String.isNotBlank(additionalConstraint)) {
                        query += ' ' + additionalConstraint;
                    }
                    query += ' LIMIT 25';
                } else {
                    query += ' WHERE ' + filterField + ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                    if (String.isNotBlank(additionalConstraint)) {
                        query += ' ' + additionalConstraint;
                    }
                    query += ' LIMIT 25';
                }
            }

            for (SObject s : Database.query(query)) {
                recordsDataList.add(new RecordsData((String) s.get(filterField), (String) s.get('id')));
            }
            return recordsDataList;
        } catch (Exception err) {
            if (String.isNotBlank(err.getMessage()) && err.getMessage().contains('error:')) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }

    public class RecordsData {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}