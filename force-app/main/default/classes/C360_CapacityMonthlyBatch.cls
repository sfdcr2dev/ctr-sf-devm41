public class C360_CapacityMonthlyBatch implements Database.Batchable<C360_Capacity__c>{
    public Iterable<C360_Capacity__c> start(Database.BatchableContext BC){
        List<C360_Capacity__c> capacityList = [SELECT Id,SalesOrganization__c,DistributionChannel__c,Customer__c,Products__c,Products__r.MaterialCode__c,TotalRequirement__c,Unit_Conversion__r.AlternativeUOM__c,Period__c from C360_Capacity__c where SalesOrganization__c != '' and DistributionChannel__c != '' and Customer__c != '' and Products__r.MaterialCode__c != ''];
        //system.debug('===capacityList.size===' + capacityList.size()); system.debug('===capacityList===' + capacityList);
        return capacityList;
    }
    public void execute(Database.BatchableContext BC, List<C360_Capacity__c> capacityList){
        //system.debug('===capacityList===' + capacityList);
        List<C360_CapacityVersusActual__c> capacityVersusActualList = new List<C360_CapacityVersusActual__c>();
        Date lastMonth = System.today().toStartOfMonth().addMonths(-1);
        Date thisMonth = System.today().toStartOfMonth();
        if(!capacityList.isempty()){
            for(integer i=0; i<capacityList.size(); i++){
                C360_Capacity__c capRec = capacityList.get(i);
                C360_CapacityVersusActual__c newRec = new C360_CapacityVersusActual__c();
                newRec.BillingDate__c = thisMonth;
                newRec.SalesOrganization__c = capRec.SalesOrganization__c;
                newRec.CompanyName__c = capRec.Customer__c;
                newRec.DistributionChannel__c = capRec.DistributionChannel__c;
                newRec.Product__c = capRec.Products__c;
                if(capRec.Period__c == 'Per year'){
                    newRec.CapacityVolume__c = convertTotalMT(capRec.TotalRequirement__c ,capRec.Products__c ,capRec.Unit_Conversion__r.AlternativeUOM__c) / 12;
                }else{
                    newRec.CapacityVolume__c = convertTotalMT(capRec.TotalRequirement__c ,capRec.Products__c ,capRec.Unit_Conversion__r.AlternativeUOM__c);
                }
                newRec.Capacity__c = capRec.id;
                newRec.ActualVolume__c = 0;
                newRec.ExternalID__c = Date.today().month()-1 + capRec.SalesOrganization__c + capRec.DistributionChannel__c + capRec.Customer__c + capRec.Products__r.MaterialCode__c;
                capacityVersusActualList.add(newRec);
            }
        }//system.debug('===capacityVersusActualList.size===' + capacityVersusActualList.size()); system.debug('===capacityVersusActualList===' + capacityVersusActualList);
        if(!capacityVersusActualList.isempty()){
            upsert capacityVersusActualList ExternalID__c;
        }
    }
    public void finish(Database.BatchableContext BC){
        C360_BuyingPerformanceMonthlyBatch b = new C360_BuyingPerformanceMonthlyBatch();
        Id batchId = Database.executeBatch(b, 500);
    }
    private static Decimal convertTotalMT(Decimal total ,Id product ,String unit){
        Decimal a_x;
        Decimal a_y;
        Decimal b_x;
        Decimal b_y;
        C360_UnitConversion__c[] RecordA = [SELECT Id,DenominatorUOM__c, NumeratorUOM__c from C360_UnitConversion__c where Product__c =:product and AlternativeUOM__c =:unit limit 1];
        if(RecordA.size() > 0){
            a_x = RecordA[0].DenominatorUOM__c;
            a_y = RecordA[0].NumeratorUOM__c;
        }
        C360_UnitConversion__c[] RecordB = RecordA;
        if(RecordB.size() > 0){
            b_x = RecordB[0].DenominatorUOM__c;
            b_y = RecordB[0].NumeratorUOM__c;
        }
        if(RecordB.size() > 0 && RecordB.size() > 0){
            Decimal a = (a_y / a_x) * total;
            Decimal b = (b_x / b_y);
            return a * b;
        }else{
            return 0;
        }
    }
}