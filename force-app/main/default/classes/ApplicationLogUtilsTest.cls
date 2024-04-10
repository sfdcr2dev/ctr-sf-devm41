@isTest
public class ApplicationLogUtilsTest {
	// @TestSetup
	// static void makeData() {
	// }

	@isTest
	static void testMethodUtils() {
		Test.startTest();
		MethodUtils.isNotEmpty('value');
		MethodUtils.isNotEmpty(JSON.deserializeUntyped('{}'));
		MethodUtils.isNotEmpty(new List<Object>());
		MethodUtils.deserializeObject(JSON.deserializeUntyped('{"Data":""}'));
		MethodUtils.serializePrettyString('{"Data":"serializePrettyString"}');
		MethodUtils.getResult(
			'Data.0.Name',
			new Map<String, Object>{ 'Data' => new List<Object>{ new Map<String, Object>{ 'Name' => 'TestMethod' } } }
		);
		MethodUtils.getValuesWithRegex(
			JSON.serialize(
				new Map<String, Object>{
					'Data' => new List<Object>{ new Map<String, Object>{ 'Name' => 'TestMethod' } }
				}
			)
		);
		MethodUtils.getAllFieldBySObject('Account');
		Test.stopTest();
	}

	@isTest
	static void testSharingEditAccess() {
		Test.startTest();
		User userRunTest = [
			SELECT Id, UserRoleId, UserRole.DeveloperName
			FROM User
			WHERE IsActive = true
			LIMIT 1
		];
		System.runAs(userRunTest) {
			MethodUtils.getParentRoleId(new Set<Id>{ userRunTest.UserRoleId });
			MethodUtils.getMysObjectEditAcess('Notification__c');
		}
		Test.stopTest();
	}

	@isTest
	static void testSaveApplicationLog() {
		Test.startTest();

		String uuid = Uuid.randomUUID();
		ApplicationLogUtils.saveLogInbound(
			'source',
			new Application_Log__c(
				External_ID__c = uuid,
				Reference_ID__c = '1234567890',
				Request_Body__c = JSON.serialize(new Map<String, String>{ 'data' => 'no data', 'status' => 'success' }),
				Response_Body__c = JSON.serialize(
					new Map<String, String>{ 'data' => 'no data', 'status' => 'success' }
				),
				SAP_Response_Body__c = JSON.serialize(
					new Map<String, String>{ 'data' => 'no data', 'status' => 'success' }
				)
			)
		);

		ApplicationLogUtils.saveLogOutbound(
			'destination',
			new Application_Log__c(
				External_ID__c = uuid,
				Reference_ID__c = '1234567890',
				Response_Body__c = JSON.serialize(
					new Map<String, String>{ 'data' => 'no data', 'status' => 'success' }
				),
				iRPA_Response_Body__c = JSON.serialize(
					new Map<String, String>{ 'data' => 'no data', 'status' => 'success' }
				),
				SAP_Response_Body__c = JSON.serialize(
					new Map<String, String>{ 'data' => 'no data', 'status' => 'success' }
				)
			)
		);

		Test.stopTest();
	}
}