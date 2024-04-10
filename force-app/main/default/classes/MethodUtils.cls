/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 03-31-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
**/
public without sharing abstract class MethodUtils {
	public static Boolean isNotEmpty(String value) {
		return value != null && String.isNotEmpty(value);
	}

	public static Boolean isNotEmpty(Object value) {
		return value != null;
	}

	public static Boolean isNotEmpty(List<Object> value) {
		return value != null && value.size() > 0;
	}

	public static Boolean isNotEmpty(Map<String, Object> value, String key) {
		return value.containsKey(key) && value.get(key) != null && String.isNotEmpty(((String) value.get(key)).trim());
	}

	public static Object deserializeObject(Object obj) {
		return obj != null ? JSON.deserializeUntyped(JSON.serialize(obj)) : null;
	}

	public static String serializePrettyString(String jsonString) {
		try {
			return isNotEmpty(jsonString) ? JSON.serializePretty(JSON.deserializeUntyped(jsonString)) : jsonString;
		} catch (Exception e) {
			return isNotEmpty(jsonString) ? jsonString.unescapeJava() : jsonString;
		}
	}

	public static Map<String, SObjectField> getAllFieldBySObject(String sObjectName) {
		return Schema.getGlobalDescribe().get(sObjectName.toLowerCase()).getDescribe().fields.getMap();
	}

	public static Object getResult(String path, Object obj) {
		String key = path.substringBefore('.');
		if (obj == null)
			return null;
		if (path.contains('.')) {
			return Pattern.matches('([0-9]+)', key)
				? getResult(path.substringAfter('.'), ((List<Object>) deserializeObject(obj)).get(Integer.valueOf(key)))
				: getResult(path.substringAfter('.'), ((Map<String, Object>) deserializeObject(obj)).get(key));
		}
		return Pattern.matches('([0-9]+)', key)
			? ((List<Object>) deserializeObject(obj)).get(Integer.valueOf(key))
			: ((Map<String, Object>) deserializeObject(obj)).get(key);
	}

	/**
	* @description
	* @author narathip.s@roundtwosolutions.com | 03-31-2022
	* @param path
	* @param objInput
	* @param obj
	* @return Object
	**/
	public static Object setResultByKeypath(String path, Object objInput, Object obj) {
        String key = path.substringAfterLast('.');
        if(path.contains('.')) {
            Map<String, Object> tempObj = (Map<String, Object>)getResult(path.substringBeforeLast('.'), obj);
            if(isNotEmpty(tempObj)) {
                tempObj.put(key, objInput);
                return setResultByKeypath(path.substringBeforeLast('.'), tempObj, obj);
            }
            else {
                return setResultByKeypath(path.substringBeforeLast('.'), new Map<String, Object>{ key => objInput }, obj);
            }
        }
        else {
            Map<String, Object> tempObj = (Map<String, Object>)obj;
            tempObj.put(path, objInput);
            return tempObj;
        }
    }

	public static Map<String, String> getValuesWithRegex(String body) {
		return getValuesWithRegex(body, new List<String>{ '.*?' });
	}

	public static Map<String, String> getValuesWithRegex(String body, List<String> keys) {
		Map<String, String> valuesMap = new Map<String, String>();
		String regEx = String.format('\"({0})"\\s*[:]\\s*"(.*?)\"', new List<String>{ String.join(keys, '|') });
		Matcher m = Pattern.compile(regEx).matcher(body);
		while (m.find()) {
			String keyTemp = m.group(1);
			String valueTemp = m.group(2);
			if (String.isNotEmpty(valueTemp)) {
				valuesMap.put(keyTemp, valueTemp);
			}
		}
		return valuesMap;
	}

	// public static final Boolean ISADMINISTER {
	// 	get {
	// 		if (ISADMINISTER == null) {
	// 			User userDetail = [
	// 				SELECT UserRoleId, UserRole.Name, UserRole.ParentRoleId, Profile.Name
	// 				FROM User
	// 				WHERE Id = :UserInfo.getUserId()
	// 			];
	// 			ISADMINISTER =
	// 				userDetail?.UserRole.Name.containsIgnoreCase('Admin') ||
	// 				userDetail?.Profile.Name.containsIgnoreCase('System Administrator');
	// 		}
	// 		return ISADMINISTER;
	// 	}
	// 	set;
	// }

	public static List<String> getMysObjectEditAcess(String sObjectName) {
		String sObjectNameShare = String.valueOf(Schema.getGlobalDescribe().get(sObjectName.toLowerCase()))
			?.replace('__c', '__Share');

		// If you are administer
		User userRecordInfo = [
			SELECT UserRoleId, UserRole.Name, UserRole.ParentRoleId
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];
		String userRoleId = userRecordInfo.UserRole.ParentRoleId != null
			? (userRecordInfo.UserRole.Name?.containsIgnoreCase('Manager') ||
					userRecordInfo.UserRole.Name?.containsIgnoreCase('Co-Ordinator')
					? userRecordInfo.UserRoleId
					: userRecordInfo.UserRole.ParentRoleId)
			: null;
		System.debug('userRoleId: ' + userRoleId);
		if (userRoleId == null || sObjectNameShare == null) {
			return new List<String>();
		}

		Set<Id> roleIdSet = new Set<Id>(MethodUtils.getAllSubRoleIds(new Set<Id>{ userRoleId }));
		Map<Id, Group> myGroupsMap = new Map<Id, Group>(
			[SELECT Id, RelatedId FROM Group WHERE RelatedId IN :roleIdSet AND Type = 'Role']
		);

		Set<Id> memberIdSet = new Set<Id>{ UserInfo.getUserId() };
		for (GroupMember member : [SELECT GroupId FROM GroupMember WHERE UserOrGroupId IN :myGroupsMap.keySet()]) {
			memberIdSet.add(member.GroupId);
		}
		List<Object> shareLst = Database.query(
			String.format(
				'SELECT ParentId FROM {0} {1} ORDER BY LastModifiedDate DESC LIMIT 2000',
				new List<String>{
					sObjectNameShare,
					'WHERE UserOrGroupId IN :memberIdSet AND RowCause IN (\'Rule\', \'Owner\')'
				}
			)
		);

		List<String> shareIds = new List<String>();
		for (Object obj : shareLst) {
			shareIds.add(String.valueOf(MethodUtils.getResult('ParentId', obj)));
		}
		return shareIds;
	}

	// To get all sub roles.
	public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
		Set<ID> currentRoleIds = new Set<ID>();

		// get all of the roles underneath the passed roles
		for (UserRole userRole : [SELECT Id FROM UserRole WHERE ParentRoleId IN :roleIds AND ParentRoleID != NULL]) {
			currentRoleIds.add(userRole.Id);
		}

		// go fetch some more rolls!
		if (currentRoleIds.size() > 0) {
			currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
		}

		return currentRoleIds;
	}

	// To get all Parent Roles.
	public static Set<ID> getParentRoleId(Set<ID> roleIds) {
		Set<ID> currentRoleIds = new Set<ID>();

		// get all of the parent roles.
		for (UserRole ur : [SELECT Id, ParentRoleId FROM UserRole WHERE Id IN :roleIds]) {
			currentRoleIds.add(ur.ParentRoleId);
		}

		// go fetch some more rolls!
		if (currentRoleIds.size() > 0) {
			currentRoleIds.addAll(getParentRoleId(currentRoleIds));
		}

		return currentRoleIds;
	}

	public static List<String> getMysObjectEditAcess(String sObjectName, List<Id> IdList) {
		String sObjectNameShare = String.valueOf(Schema.getGlobalDescribe().get(sObjectName.toLowerCase()))
			?.replace('__c', '__Share');
	  
		// If you are administer
		User userRecordInfo = [
			SELECT UserRoleId, UserRole.Name, UserRole.ParentRoleId
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];

		String userRoleId = userRecordInfo.UserRole.ParentRoleId != null
			? (userRecordInfo.UserRole.Name?.containsIgnoreCase('Manager') ||
			userRecordInfo.UserRole.Name?.containsIgnoreCase('Co-Ordinator')
				? userRecordInfo.UserRole.ParentRoleId
				: userRecordInfo.UserRoleId)
			: null;

		System.debug('userRoleId: ' + userRoleId);
		if (userRoleId == null || sObjectNameShare == null) {
			return new List<String>();
		}
	  
		//Set<Id> roleIdSet = new Set<Id>(MethodUtils.getAllSubRoleIds(new Set<Id>{ userRoleId }));
		Set<Id> roleIdSet = new Set<Id>{ userRoleId };
		roleIdSet.addAll(MethodUtils.getAllSubRoleIds(roleIdSet));
		Map<Id, Group> myGroupsMap = new Map<Id, Group>(
			[SELECT Id, RelatedId FROM Group WHERE RelatedId IN :roleIdSet AND Type = 'Role']
		);
	  
		Set<Id> memberIdSet = new Set<Id>{ UserInfo.getUserId() };
		for (GroupMember member : [SELECT GroupId FROM GroupMember WHERE UserOrGroupId IN :myGroupsMap.keySet()]) {
			memberIdSet.add(member.GroupId);
		}
		List<Object> shareLst = Database.query(
			String.format(
				'SELECT ParentId FROM {0} {1} ORDER BY LastModifiedDate DESC LIMIT 10000',
				new List<String>{
					sObjectNameShare,
					'WHERE UserOrGroupId IN :memberIdSet AND RowCause IN (\'Rule\', \'Owner\') AND ParentId IN :IdList'
				}
			)
		);
	  
		List<String> shareIds = new List<String>();
		for (Object obj : shareLst) {
			shareIds.add(String.valueOf(MethodUtils.getResult('ParentId', obj)));
		}
		return shareIds;
	}
}