public class C360_CapacityCheckDuplicateClass {
    public static void validateCapacityKey(C360_Capacity__c newTrigger){
        String salesOrg = newTrigger.SalesOrganization__c;
        String DistributionChannel = newTrigger.DistributionChannel__c;
        String Customer = newTrigger.Customer__c;
        String Product = newTrigger.Products__c;
        List<C360_Capacity__c> capList = [Select id from C360_Capacity__c where SalesOrganization__c =: salesOrg and DistributionChannel__c =: DistributionChannel and Customer__c =: Customer  and Products__c =: Product];
        if(!capList.isEmpty() && capList.size()>0)
        newTrigger.addError('Duplicated : Cannot save record, please check SalesOrganization, DistributionChannel, Customer and Product.');
    }
}