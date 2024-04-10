/* 
 * Author Softever
 */

public with sharing class WAP_Enum {
	
    public enum UserStatus {
        EXTD,
        EXTH,
        WCCL,
        WIP1
    }
    
    public enum WorkClearanceStatus {
        Created,
        InProgress,
        Inactive,
        Closed,
        Rejected,
        DeleteFlag,
        Suspend
    } 
    
    public enum HighRiskWorkType {
        General, //0
        HotWork, //1
        ConfinedSpace, //2
        Crane, //3
        Radiation, //4
        JackHammer, //5
        HighPressureWaterJet, //6
        Digging, //7
        WorkAtHigh, //8
        OnlineStopLeak, //9
        NonTypeOfWork //10
    }
    
    public enum Areas {
        TLB, //4200
        TPX, //3200
        LABIX, //7200
        SPP, //8200
        TOC1, //1200 T
        TOC2, //1200 T2
        TOC3, //1200 T3
        TOC4, //1200 T4
        TOC5, //1200 T5
        UTILITY, //1200 UT,UT2
        MOVEMENT, //1200 MO
        OFFSITE, //1200 OF
        CFP //1200 OC1,OC3
    }
    
    public static string getMaintenancePlant(string data)
    {
        if(data == WAP_Enum.Areas.TLB.name()) {
            return '4200';
        }
        else if (data == WAP_Enum.Areas.TPX.name()) {
            return '3200';
        }
        else if (data == WAP_Enum.Areas.LABIX.name()) {
            return '7200';
        }
        else if (data == WAP_Enum.Areas.SPP.name()) {
            return '8200';
        }
        else if (data == WAP_Enum.Areas.TOC1.name() || data == WAP_Enum.Areas.TOC2.name() ||
                	data == WAP_Enum.Areas.TOC3.name() || data == WAP_Enum.Areas.TOC4.name() || data == WAP_Enum.Areas.TOC5.name() ||
                	data == WAP_Enum.Areas.UTILITY.name() || data == WAP_Enum.Areas.MOVEMENT.name() || data == WAP_Enum.Areas.OFFSITE.name() ||
                	data == WAP_Enum.Areas.CFP.name()) {
            return '1200';
        }
        
        return '';
    }
    
    public static string getAreaCode(string data)
    {
        if(data == WAP_Enum.Areas.TOC1.name()) {
            return 'T1';
        }
        else if(data == WAP_Enum.Areas.TOC2.name()) {
            return 'T2';
        }
        else if(data == WAP_Enum.Areas.TOC3.name()) {
            return 'T3';
        }
        else if(data == WAP_Enum.Areas.TOC4.name()) {
            return 'T4';
        }
        else if(data == WAP_Enum.Areas.TOC5.name()) {
            return 'T5';
        }
        else if(data == WAP_Enum.Areas.UTILITY.name()) {
            return 'UT,UT2';
        }
        else if(data == WAP_Enum.Areas.MOVEMENT.name()) {
            return 'MO';
        }
        else if(data == WAP_Enum.Areas.OFFSITE.name()) {
            return 'OF';
        }
        else if(data == WAP_Enum.Areas.CFP.name()) {
            return 'OC1,OC3';
        }
        
        return '';
    }
}