public with sharing class THOR_UserLookupController {
    @AuraEnabled
    public static List<User> searchUsers(String searchText){
        List<User> retVal = new List<User>();

        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

        String query = 'SELECT Id, Name ' +
            			' FROM User ' +
            				' WHERE Name LIKE '+searchText+
            			' LIMIT 10';

        retVal = Database.query(query);

        return retVal;
    }
}