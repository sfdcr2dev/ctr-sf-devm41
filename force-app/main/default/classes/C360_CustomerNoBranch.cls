public class C360_CustomerNoBranch{
   public static void AccountList(){ 
      Map<String,integer> ptCountMap = new Map<String,integer>();
      for(AggregateResult cnPartner : [SELECT Account__c,count(id) FROM C360_Relationship__c WHERE RelationshipType__c ='WE' group by Account__c]){
         ptCountMap.put((id)cnPartner.get('Account__c'),(integer)cnPartner.get('expr0'));
      }
      List<Account> upDateAccountList = new List<Account>();
      List<Account> accountList=[Select Id from Account where RecordType.Name in ('Sold To') order by id asc];
      for(Account actItem :accountList){
         Account upDateAccount = new Account();
         upDateAccount.NoofBranch__c = ptCountMap.get(actItem.id);
         upDateAccount.id = actItem.id;
         upDateAccountList.add(upDateAccount);
      }
      if(upDateAccountList.size() > 0){
         Update upDateAccountList;
      }
	}
}