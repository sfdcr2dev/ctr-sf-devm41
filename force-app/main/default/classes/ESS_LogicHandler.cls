/* 
 * Author Softever
*/

public class ESS_LogicHandler {

	//Generate Running No
    public static string GenerateRunningNo(string type) {
        
        string genratedRN = '';
        
        Date todayDate = date.today();
        String userLocale = UserInfo.getLocale();
        integer currentYear = 0;
        
        boolean isThaiLocale = userLocale.contains('th');
        if(isThaiLocale && todayDate.year() > 2500) {
            currentYear = todayDate.year() - 543;
        }
        else {
            currentYear = todayDate.year();
        }
        
        ESS_Config__c ESSConfig = [select Year__c, Application_Running_No__c, Retirement_Running_No__c, Probationary_Running_No__c,
                                    Letter_LR1_Running_No__c, Letter_LR2_Running_No__c, Letter_LR3_Running_No__c, Letter_LR4_Running_No__c,
                                    Letter_LR5_Running_No__c, Manpower_Running_No__c, FixAndGeneral_Running_No__c,
                                    HotelBooking_Running_No__c, Stationary_Running_No__c from ESS_Config__c];
 
        if(string.valueOf(currentYear) != ESSConfig.Year__c) {
            ESSConfig.Year__c = string.valueOf(currentYear);
            ESSConfig.Application_Running_No__c = '0';
            ESSConfig.Letter_LR1_Running_No__c = '0';
            ESSConfig.Letter_LR2_Running_No__c = '0';
            ESSConfig.Letter_LR3_Running_No__c = '0';
            ESSConfig.Letter_LR4_Running_No__c = '0';
            ESSConfig.Letter_LR5_Running_No__c = '0';
            ESSConfig.Retirement_Running_No__c = '0';
            ESSConfig.Probationary_Running_No__c = '0';
            ESSConfig.Manpower_Running_No__c = '0';
            ESSConfig.FixAndGeneral_Running_No__c = '0';
            ESSConfig.HotelBooking_Running_No__c = '0';
            ESSConfig.Stationary_Running_No__c = '0';
        }
        
        if(type == 'Application') {
            integer runningNo = integer.valueOf(ESSConfig.Application_Running_No__c) + 1;
            ESSConfig.Application_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Application_Running_No__c;
        }
        else if(type == 'Letter LR1') {
            integer runningNo = integer.valueOf(ESSConfig.Letter_LR1_Running_No__c) + 1;
            ESSConfig.Letter_LR1_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Letter_LR1_Running_No__c;
        }
        else if(type == 'Letter LR2') {
            integer runningNo = integer.valueOf(ESSConfig.Letter_LR2_Running_No__c) + 1;
            ESSConfig.Letter_LR2_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Letter_LR2_Running_No__c;
        }
        else if(type == 'Letter LR3') {
            integer runningNo = integer.valueOf(ESSConfig.Letter_LR3_Running_No__c) + 1;
            ESSConfig.Letter_LR3_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Letter_LR3_Running_No__c;
        }
        else if(type == 'Letter LR4') {
            integer runningNo = integer.valueOf(ESSConfig.Letter_LR4_Running_No__c) + 1;
            ESSConfig.Letter_LR4_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Letter_LR4_Running_No__c;
        }
        else if(type == 'Letter LR5') {
            integer runningNo = integer.valueOf(ESSConfig.Letter_LR5_Running_No__c) + 1;
            ESSConfig.Letter_LR5_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Letter_LR5_Running_No__c;
        }
        else if(type == 'Retirement') {
            integer runningNo = integer.valueOf(ESSConfig.Retirement_Running_No__c) + 1;
            ESSConfig.Retirement_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Retirement_Running_No__c;
        }
        else if(type == 'Probationary') {
            integer runningNo = integer.valueOf(ESSConfig.Probationary_Running_No__c) + 1;
            ESSConfig.Probationary_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Probationary_Running_No__c;
        }
        else if(type == 'Manpower') {
            integer runningNo = integer.valueOf(ESSConfig.Manpower_Running_No__c) + 1;
            ESSConfig.Manpower_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Manpower_Running_No__c;
        }
        else if(type == 'FixAndGeneral') {
            integer runningNo = integer.valueOf(ESSConfig.FixAndGeneral_Running_No__c) + 1;
            ESSConfig.FixAndGeneral_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.FixAndGeneral_Running_No__c;
        }
        else if(type == 'HotelBooking') {
            integer runningNo = integer.valueOf(ESSConfig.HotelBooking_Running_No__c) + 1;
            ESSConfig.HotelBooking_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.HotelBooking_Running_No__c;
        }
        else if(type == 'Stationary') {
            integer runningNo = integer.valueOf(ESSConfig.Stationary_Running_No__c) + 1;
            ESSConfig.Stationary_Running_No__c = ESS_LogicHandler.ActualRunningNo(runningNo);
            genratedRN = ESSConfig.Stationary_Running_No__c;
        }
        
        update(ESSConfig);
        
        return genratedRN;
        
    }
    
    public static string ActualRunningNo(integer runningNo) {
        string actualNo = '';
        if(runningNo > 0 && runningNo < 10) {
            actualNo = '000' + runningNo;
        }
        else if(runningNo >= 10 && runningNo < 100) {
            actualNo = '00' + runningNo;
        }
        else if(runningNo >= 100 && runningNo < 1000) {
            actualNo = '0' + runningNo;
        }
        else {
            actualNo = string.valueOf(runningNo);
        }
        return actualNo;
    }
    
    public static string GetCurrentYear() {
        
        Date todayDate = date.today();
        String userLocale = UserInfo.getLocale();
        integer currentYear = 0;
        
        boolean isThaiLocale = userLocale.contains('th');
        if(isThaiLocale && todayDate.year() > 2500) {
            currentYear = todayDate.year() - 543;
        }
        else {
            currentYear = todayDate.year();
        }
        
        return String.ValueOf(currentYear);
    }
    
    public static string GetCurrentMonth() {
        
        Date todayDate = date.today();
        integer month = todayDate.month(); 
        string currentMonth = '';
        
        if(month < 10) {
            currentMonth = '0' + month;
        }
        else{
            currentMonth = String.ValueOf(month);
        }
        
        return currentMonth;
    }
    
}