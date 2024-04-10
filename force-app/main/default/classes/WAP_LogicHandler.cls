/* 
 * Author Softever
*/

public class WAP_LogicHandler {

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
    
}