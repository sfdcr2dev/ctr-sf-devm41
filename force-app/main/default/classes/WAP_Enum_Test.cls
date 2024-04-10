@isTest
public with sharing class WAP_Enum_Test {

    @isTest
    public static void EnumTest() {
        WAP_Enum.getMaintenancePlant(WAP_Enum.Areas.TLB.name());
        WAP_Enum.getMaintenancePlant(WAP_Enum.Areas.TPX.name());
        WAP_Enum.getMaintenancePlant(WAP_Enum.Areas.LABIX.name());
        WAP_Enum.getMaintenancePlant(WAP_Enum.Areas.SPP.name());
        WAP_Enum.getMaintenancePlant(WAP_Enum.Areas.TOC1.name());
        
        WAP_Enum.getAreaCode(WAP_Enum.Areas.TOC1.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.TOC2.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.TOC3.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.TOC4.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.TOC5.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.UTILITY.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.MOVEMENT.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.OFFSITE.name());
        WAP_Enum.getAreaCode(WAP_Enum.Areas.CFP.name());
    }
}