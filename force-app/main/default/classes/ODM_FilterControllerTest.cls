/**
 * @author R2
 * @description test class for
 * ODM_FilterController
 */
@isTest
public with sharing class ODM_FilterControllerTest {

    @TestSetup
    static void makeData() {
        List<UserRole> roles = new List<UserRole>();

        UserRole operatorRole = new UserRole(
            DeveloperName = 'TestOperatorRole',
            Name = 'TOP THOR APU-A Operator-ENMA'
        );
        UserRole teamLeadRole = new UserRole(
            DeveloperName = 'TestTeamLeadRole',
            Name = 'TOP THOR APU-A Team Lead-ENMA-E/TOC-1'
        );
        UserRole dTeamLeadRole = new UserRole(
            DeveloperName = 'TestDTeamLeadRole',
            Name = 'TOP THOR APU-A D-Team Lead-ENMA-E/TOC-1'
        );

        roles.add(operatorRole);
        roles.add(teamLeadRole);
        roles.add(dTeamLeadRole);

        insert roles;

        List<User> users = new List<User>();

        User operator = new User(
            Alias = 'operator',
            Email = 'testUser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testUser' + DateTime.now().getTime() + '@testorg.com',
            UserRoleId = operatorRole.Id
        );

        User teamLead = new User(
            Alias = 'teamLead',
            Email = 'testUser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testUser' + DateTime.now().getTime() + '@testorg.com',
            UserRoleId = teamLeadRole.Id
        );

        User dTeamLead = new User(
            Alias = 'dTL',
            Email = 'testUser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testUser' + DateTime.now().getTime() + '@testorg.com',
            UserRoleId = dTeamLeadRole.Id
        );

        users.add(operator);
        users.add(teamLead);
        users.add(dTeamLead);

        insert users;
    }

    @isTest
    public static void givenUserWithRoleOperatorReturnsUserFilter() {
        User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'operator'][0];

        System.runAs(userTest) {
            String excludedFilter = ODM_FilterController.getExcludedFilter();

            System.assertEquals('userFilter', excludedFilter, 'Excluded filter name does not match');
        }
    }

    @isTest
    public static void givenUserWithRoleTeamLeadReturnsMWC() {
        User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'teamLead'][0];

        System.runAs(userTest) {
            String excludedFilter = ODM_FilterController.getExcludedFilter();

            System.assertEquals('mwcFilter', excludedFilter, 'Excluded filter name does not match');
        }
    }

    @isTest
    public static void givenUserWithRoleDTeamLeadReturnsEmpty() {
        User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'dTL'][0];

        System.runAs(userTest) {
            String excludedFilter = ODM_FilterController.getExcludedFilter();

            System.assertEquals('', excludedFilter, 'Excluded filter name does not match');
        }
    }

	@isTest
    public static void testSetMyFilters() {
        THOR_Filter__c filter = new THOR_Filter__c();

        Test.startTest();
        // Create and Set Filter
        ODM_FilterController.setMyFilter('ODM Notification','ODM_NotificationFilter',filter);
        // Update Filter
        ODM_FilterController.setMyFilter('ODM Notification','ODM_NotificationFilter',filter);
        Test.stopTest();
	}

	@isTest
	public static void testFilterMethods() {
		Test.startTest();
		ODM_FilterController.getExcludedFilter();
		ODM_FilterController.getMyFilter('ODM Notification', 'ODM_NotificationFilter');
		ODM_FilterController.getDescribeFieldResult('Filter_type__c', 'THOR_Filter__c');
		ODM_FilterController.getMasterMapByTpye('Filter', 'Test');
		ODM_FilterController.getMasterMapReversed('%', 'Test');
		ODM_FilterController.fetchRecordsRecently(
			'Notification__c',
			'Test',
			new List<String>{ 'Notification_Number__c', 'Priority__c' }
		);

		try {
			Order__c orderObj = new Order__c(
				Name = '12344321',
				Order_Number__c = '12344321',
				Order_Status__c = 'New'
			);
			insert orderObj;
			ODM_FilterController.getRecordInfo(orderObj.Id);
		} catch (Exception e) {
		}

		try {
			ODM_FilterController.getMyFilter('HomeNotification', null);
		} catch (Exception e) {
		}
		Test.stopTest();
	}
}