/**
 * @author Oktana
 * @description controller for THOR_ApprovalSteps component
 */
public with sharing class THOR_ApprovalStepsController {
	/**
	 * @description retrieves a ProcessInstanceStep object as THOR_ObjectCardDTO in a list
	 * @param status
	 * @return THOR_ObjectCardDTO
	 */
	@AuraEnabled
	public static Object retrieveProcessInstanceSteps(Id processInstanceId) {
		String recordId = processInstanceId;
		List<ProcessInstanceStep> processSteps = new List<ProcessInstanceStep>();
		EQCC_Step__c eqccStep = new EQCC_Step__c();

		try {
			if (Schema.sObjectType.ProcessInstanceStep.isAccessible()) {
				processSteps = [
					SELECT Id, ActorId, Comments, StepStatus, ProcessInstance.Status, ProcessInstance.TargetObjectId
					FROM ProcessInstanceStep
					WHERE Id = :processInstanceId
				];
				recordId = processSteps.size() > 0 ? processSteps.get(0).ProcessInstance.TargetObjectId : recordId;
			}
			if (Schema.sObjectType.EQCC_Step__c.isAccessible()) {
				eqccStep = [
					SELECT
						Id,
						Form_Code__c,
						FormNameLWC__c,
						Header_Sheet__r.Sheet__r.Sheet_Code__c,
						Header_Sheet__r.Header__r.Name,
						Header_Sheet__r.Header__r.Functional_Location__c,
						Header_Sheet__r.Header__r.Equipment__r.Name,
						Header_Sheet__r.Header__r.Operation__r.Name,
						Header_Sheet__r.Sheet__r.CreatedDate,
						Header_Sheet__r.Sheet__r.LastModifiedDate,
						Header_Sheet__r.Header__r.Owner.Name,
						Header_Sheet__r.Sheet__r.Createdby.Name
					FROM EQCC_Step__c
					WHERE Id = :recordId
					LIMIT 1
				];
			}
			// return THOR_DTOMapper.mapProcessInstanceStep(processSteps, eqccStep);
			return eqccStep;
		} catch (Exception e) {
			throw new AuraHandledException(
				String.format('{0}: {1}', new List<String>{ 'Something went wrong...', e.getMessage() })
			);
		}
	}

	@AuraEnabled
	public static Boolean checkPrivilege(Id stepId) {
		try {
			EQCC_Step__c eqcc_step = [
				SELECT Id, Form_Code__c, Step_Number__c, Header_Sheet__r.Sheet__r.Group__c, Owner.Name
				FROM EQCC_Step__c
				WHERE Id = :stepId
			];
			Set<Id> groupId = new Set<Id>();
			Set<String> newSheetCodes = new Set<String>();
			User user = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
			List<Group> groups = [SELECT Id, Name, DeveloperName FROM Group WHERE RelatedId = :user.UserRoleId];
			for (Group g : groups) {
				groupId.add(g.Id);
			}
			List<GroupMember> groupMembers = [
				SELECT Id, Group.Name, Group.DeveloperName, Group.Type, UserOrGroupId
				FROM GroupMember
				WHERE Group.Name = :eqcc_step.Form_Code__c AND UserOrGroupId IN :groupId
			];
			if (groupMembers.size() == 0) {
				return false;
			}
			return true;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<EQCC_Step__c> reverseEQCCStepList(String recordId) {
		String sObjName = ((Id) recordId).getSObjectType().getDescribe().getName();
		if (sObjName == 'ProcessInstanceStep') {
			recordId = [
				SELECT Id, ActorId, Comments, StepStatus, ProcessInstance.Status, ProcessInstance.TargetObjectId
				FROM ProcessInstanceStep
				WHERE Id = :recordId
			]
			?.ProcessInstance.TargetObjectId;
		}
		EQCC_Step__c eqccStep = [SELECT Id, Header_Sheet__c FROM EQCC_Step__c WHERE Id = :recordId];
		String headerId = eqccStep?.Header_Sheet__c;
		return new List<EQCC_Step__c>(
			[
				SELECT Id, Step_Number__c, Form_Group__c, Is_Current__c, Percentage__c, Status__c
				FROM EQCC_Step__c
				WHERE Header_Sheet__c = :headerId AND Header_Sheet__c != NULL
			]
		);
	}
}