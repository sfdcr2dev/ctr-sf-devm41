/**
 * @author Oktana
 * @description test class for THOR_FilterController
 */
@isTest
public with sharing class THOR_FilterControllerTest {
    @TestSetup
    static void makeData() {
        List<UserRole> roles = new List<UserRole>();

        UserRole operatorRole = new UserRole(DeveloperName = 'TestOperatorRole', Name = 'TOP THOR APU-A Operator-ENMA');
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
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator']
            .Id,
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
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator']
            .Id,
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
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator']
            .Id,
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
            String excludedFilter = THOR_FilterController.getExcludedFilter();

            System.assertEquals('userFilter', excludedFilter, 'Excluded filter name does not match');
        }
    }

    @isTest
    public static void givenUserWithRoleTeamLeadReturnsMWC() {
        User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'teamLead'][0];

        System.runAs(userTest) {
            String excludedFilter = THOR_FilterController.getExcludedFilter();

            System.assertEquals('mwcFilter', excludedFilter, 'Excluded filter name does not match');
        }
    }

    @isTest
    public static void givenUserWithRoleDTeamLeadReturnsEmpty() {
        User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'dTL'][0];

        System.runAs(userTest) {
            String excludedFilter = THOR_FilterController.getExcludedFilter();

            System.assertEquals('', excludedFilter, 'Excluded filter name does not match');
        }
    }
}