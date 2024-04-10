@isTest
public with sharing class ESS_Enum_Test {

    @isTest
    public static void EnumTest() {
        
        ESS_Enum.getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService.OfficeEquipment);
        ESS_Enum.getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService.Housing);
        ESS_Enum.getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService.Transportation);
        ESS_Enum.getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService.GeneralService);
        
        ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.ElectricalAndLightingSystem);
        ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.PlumbingSystem);
        ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.SewageSystem);
        ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.HvacSystem);
        ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.LiftSystem);
        ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.GasSystem);
        ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.Other);
        
        ESS_Enum.getHousingTypeOfServiceValue(ESS_Enum.HousingTypeOfService.Other);
        
        ESS_Enum.getHousingType(ESS_Enum.HousingType.SiteHouse);
        ESS_Enum.getHousingType(ESS_Enum.HousingType.AHouse);
        ESS_Enum.getHousingType(ESS_Enum.HousingType.BUpgrade);
        ESS_Enum.getHousingType(ESS_Enum.HousingType.BHouse);
        ESS_Enum.getHousingType(ESS_Enum.HousingType.CUpgrade);
        ESS_Enum.getHousingType(ESS_Enum.HousingType.CHouse);
        
        ESS_Enum.getTransportationTypeOfServiceValue(ESS_Enum.TransportationTypeOfService.ChangeTire);
        ESS_Enum.getTransportationTypeOfServiceValue(ESS_Enum.TransportationTypeOfService.ChangeChain);
        ESS_Enum.getTransportationTypeOfServiceValue(ESS_Enum.TransportationTypeOfService.ChangeSeat);
        ESS_Enum.getTransportationTypeOfServiceValue(ESS_Enum.TransportationTypeOfService.Other);
        ESS_Enum.getTransportationTypeValue(ESS_Enum.TransportationType.Bicycle);
        ESS_Enum.getTransportationTypeValue(ESS_Enum.TransportationType.Car);
        
        ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.MovingService);
        ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.EventAndConferencePlanning);
        ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.FurnitureAndOfficeEquipmentArrangement);
        ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.ElectricalAppliancesArrangement);
        ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.Landscaping);
        ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.CleaningService);
        ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.Other);
        
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TOPTSR);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TOPTBK);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TLB);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TPX);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TTC);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TX);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TES);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.LABIX);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.TOPSPP);
        ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.OTHER);
        
        ESS_Enum.getStationaryWithdrawFromValue(ESS_Enum.StationaryWithdrawFrom.TSR);
        ESS_Enum.getStationaryWithdrawFromValue(ESS_Enum.StationaryWithdrawFrom.TBK);
    }
}