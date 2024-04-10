global class C360_BuyingDailyJobClearData implements Database.Batchable<SObject>,Database.Stateful{
    global string str_SOQL, dateString, check;
    global Date dateStart, dateEnd;
    global integer delDays, delDaysM, batchSize;
    global Datetime d, dateStartTime, dateEndTime;
    public C360_BuyingDailyJobClearData(){
        str_SOQL = ' ';
        dateString = ' ';
        dateStart = null;
        dateEnd = null;
        check = ' ';
        delDays = null;
        delDaysM = null;
        batchSize = null;
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        C360Integration__c delCustomSetting = C360Integration__c.getInstance();
        delDays = Integer.valueOf(delCustomSetting.DeletedDays__c);
        batchSize = Integer.valueOf(delCustomSetting.DeletedBatchSize__c);
        check = string.valueOf(delDays);
        if(check != null)
        {
            delDaysM = delDays * -1;
            d =Date.today().addDays(delDaysM);
            dateString = d.format('yyyy-MM-dd');
            dateEnd = Date.valueOf(dateString);
            //system.debug('minus date : ' + d);
            //system.debug('dateString : ' + dateString);
            //system.debug('dateStart : ' + dateStart);
            //system.debug('dateEnd : ' + dateEnd);
            //system.debug('Inside The Start Method');
        }
        return database.getQueryLocator([SELECT Id, BillingDate__c FROM C360_BuyingPerformanceDailyTOP__c where BillingDate__c <: dateEnd and RecordType.DeveloperName='TXDailyPerformance']);
    }
    global void execute(Database.BatchableContext BC, List<SObject> sObjectsFromStart){
        List<C360_BuyingPerformanceDailyTOP__c> ListOfBuyingPerformanceDailyToBeDeleted = new List<C360_BuyingPerformanceDailyTOP__c>();
        for(sObject tempSObject : sObjectsFromStart){
            C360_BuyingPerformanceDailyTOP__c LoaderData = new C360_BuyingPerformanceDailyTOP__c(Id = tempSObject.ID);
            ListOfBuyingPerformanceDailyToBeDeleted.add(LoaderData);
        }
        if(!ListOfBuyingPerformanceDailyToBeDeleted.isEmpty()){
            delete ListOfBuyingPerformanceDailyToBeDeleted;
        }
        //system.debug('Inside The Execute Method');
    }
    global void finish(Database.BatchableContext BC){}
}