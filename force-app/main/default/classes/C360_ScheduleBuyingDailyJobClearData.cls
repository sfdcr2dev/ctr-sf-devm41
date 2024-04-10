global class C360_ScheduleBuyingDailyJobClearData implements Schedulable
{ 
    global void execute(SchedulableContext contextSchedule){
        //Method to get data from C360_BuyingDailyJobClearData Object
        C360_BuyingDailyJobClearData deleteBuyingDailyJobClearData = new C360_BuyingDailyJobClearData();
        //Get batch size from Custom Setting
        C360Integration__c  delCustomSet = C360Integration__c.getInstance();
        Integer batchSize = Integer.valueOf(delCustomSet.DeletedBatchSize__c);
        String check = String.valueOf(batchSize);      
        if(check == null)  
        {
            system.debug('Batch Size Null');
        }else{
            // Method to delete Application Log 
            database.executeBatch(deleteBuyingDailyJobClearData,batchSize);
        } 
     }
}