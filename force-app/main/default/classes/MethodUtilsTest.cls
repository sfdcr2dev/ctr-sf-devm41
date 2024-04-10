@isTest
public class MethodUtilsTest {
	@IsTest
	static void testMethodUtils() {
		Test.startTest();

		MethodUtils.isNotEmpty('');
		MethodUtils.isNotEmpty(new List<Object>());
		MethodUtils.isNotEmpty(JSON.deserializeUntyped('{}'));
		MethodUtils.isNotEmpty(new Map<String, Object>(), 'key');

		MethodUtils.deserializeObject(JSON.deserializeUntyped('{}'));
		MethodUtils.serializePrettyString('{}');
		MethodUtils.serializePrettyString('{');

		MethodUtils.getAllFieldBySObject('Account');

		String data = JSON.serialize(
			new Map<String, Object>{
				'key' => new List<Object>{
					JSON.deserializeUntyped(JSON.serialize(new Map<String, String>{ 'a' => 'value' }))
				}
			}
		);
		MethodUtils.getResult('key.0.a', JSON.deserializeUntyped(data));
		MethodUtils.getValuesWithRegex(data);
		MethodUtils.getParentRoleId(new Set<Id>{ UserInfo.getUserRoleId() });

		Test.stopTest();
	}

	@IsTest
	static void testSObjectAccess() {
		Test.startTest();
		//User userRunAs = [SELECT Id FROM User WHERE UserRole.Name = 'TOP THOR APU-A Team Lead-ENMA-E/TOC-1' LIMIT 1];
		User userRunAs = [SELECT Id FROM User WHERE UserRole.Name = 'TOP THOR APU-A Working Team-ENMA-E/TOC-1' LIMIT 1];
        
		System.runAs(userRunAs) {
			MethodUtils.getMysObjectEditAcess('Notification__c');
            MethodUtils.getMysObjectEditAcess('Notification__c', new List<Id>());
		}
		Test.stopTest();
	}
}