/* Author Softever */
public with sharing class ESS_Enum {
    
    public enum ApplicationStatus {
        Draft,
        Submitted, //WaitingForVerify
        Verified,
        SendingToSAP,
        Completed, //UpdatedInSAP
        Cancelled,
        Error
    }
    
    public enum MarriedEarnIncome {
        MarriedEarnIncome, //คู่สมรสมีเงินได้ = ไม่ลดหย่อนคู่สมรส (2)
        MarriedNotEarnIncome //คู่สมรสไม่มีเงินได้ = ลดหย่อนคู่สมรส (1)
    }
    
    public enum MarriedStatus {
        Single, //0
        Married, //1
        Widow, //2
        Divorced, //3
        Seperate //4    
    }
    
    public enum GenderStatus {
        Male, //1
        Female //2
    }
    
    public enum ChildStatus {
        Child,
        Protege
    }
    
    public enum DeathPerson {
        Married,
        Child,
        Father,
        Mother
    }
    
    public enum Title {
        Mr, //1
        Mrs, //2
        Miss, //3
        Ms, //4
        Dr //5
    }
    
    public enum LicenseType {
        Citizen,
        Professional
    }
    
    public enum AddressType {
        HouseRegistration,
        Current
    }
    
    //Recommendation Letter
    public enum RecommendationLetterType {
        SalaryLetterForFinancial, //จดหมายรับรองเงินเดือน (สำหรับทำธุรกรรมทางการเงิน) LR1
        SalaryLetterWithLeaveForVisa, //จดหมายรับรองเงินเดือน แบบระบุวันเวลา (สำหรับยื่นขอ Visa) LR2
        SalaryLetterWithoutLeaveForVisa, //จดหมายรับรองเงินเดือน แบบไม่ระบุวันเวลา (สำหรับยื่นขอ Visa) LR3
        WorkLetterWithoutSalary, //จดหมายรับรองการทำงาน ไม่ระบุเงินเดือน LR4
        GrantedLetter //จดหมายผ่านสิทธิ์ (สำหรับทำธุรกรรมกับธนาคาร ธอส.) LR5
    }
    
    public enum RecommendationLetterStatus {
        Created,
        GeneratedToPDF
    }
    
    public enum RecommendationLetterLanguage {
        Thai,
        English
    }
    
    
    //Probationary
    public enum ProbationApproveStatus {
        Draft,
        Reassigned,
        Rejected,
        WaitingForApprovalSectionHead,
        WaitingForReassignedSectionHead,
        WaitingForApprovalDepartmentHead,
        WaitingForReassignedDepartmentHead,
        UploadingToPersonalFolder,
        Submitted,
        Completed,
        UploadFailed
    }
    
    public enum ProbationStatus {
        ConfirmedToRegularEmployee,
        TerminateEmployee
    }
    
    public enum ProbationSectionHeadQuantity {
        Learn, //Learn slowly and quantity of work is below expection
        Meet, //Meet required standard
        Better //Better than expectation
    }
    
    public enum ProbationSectionHeadQuality {
        Below, //Below required standard
        Meet, //Meet required standard
        Better //Better than expectation
    }
    
    public enum ProbationSectionHeadSafety {
        Below, //Below required standard
        Meet, //Meet required standard
        Better //Better than expectation
    }
    
    public enum ProbationSectionHeadKnowledge {
        Insufficient, //Insufficient knowledge/skills to carry out work up to the required standard
        Sufficient, //Sufficient knowledge/skills to carry out work up to the required standard
        SufficientBetter //Sufficient knowledge/skills to carry out work better than the required standard
    }
    
    public enum ProbationSectionHeadReliability {
        NeedSupervision, //Need close supervision
        OccasionalSupervision, //Work well and need only occasional supervision
        WithoutSupervision //Work independently without supervision
    }
    
    public enum ProbationSectionHeadAttitude {
        LackDescipline, //Lack discipline and always create problems 
        NeatAndObey, //Neat and obey supervisor's order
        WorkWell //Work well with colleague and strictly adhere to Company regulations
    }
    
    public enum ProbationSectionHeadEngineering {
        AlreadyPossessed, //The incumbent has already possessed the valid license
        NotYetPossessed, //The incumbent has not yet possessed the valid license
        NotRequire
    }
    
    public enum ProbationSectionHeadRecommendation {
        Confirm, //To confirm as regular employee of the Company
        Terminate //To terminate employment for the following reason
    }
    
    public enum ProbationDepartmentHeadConfirmation {
        Confirm, //To confirm as regular employee of the Company
        Terminate //To terminate employment for the following reason
    }
    
    public enum ProbationDepartmentHeadCEP {
        Confirm, //To confirm CEP
        Propose //To propose new CEP
    }
    
    //Retirement
    public enum ApproverRole {
        Employee,
        SectionHead,
        DepartmentHead
    }
    
    public enum RetirementStatus {
        WaitingEmployeeSubmit,
        WaitingForApprovalSectionHead, //Waiting for Approval by Immediate Line/Section Head
        WaitingForApprovalDepartmentHead, //Waiting for Approval by Department Head
        UploadingToPersonalFolder, //Uploading to personal foler
        SendingToSAP, //Sending to SAP
        Completed,
        DefaultFromSystem, //Default from System
        UploadFailed
    }
    
    public enum RetirementApprovalStatus {
        Submitted,
        Approved,
        Rejected
    }
    
    public enum RetirementChoice {
        ExactDateFor55Years, //ในวันครบอายุ 55 ปีบริบูรณ์
        ExactDateFor60Years, //ในวันครบอายุ 60 ปีบริบูรณ์
        EndOfMonth,  //ในวันสุดท้ายของเดือนที่ครบอายุเกษียณ
        EndOfYear //ในวันสิ้นปีที่ครบอายุเกษียณ
    }
    
    public enum EducationalQualification {
        EducationalQualification, //วุฒิการศึกษา
        OtherQualification //วุฒิการศึกษาอื่นๆ
    }
    
    //Manpower
    public enum ManpowerTypeOfService {
        Permanent,
        Temporary,
        ProjectBase
    }
    
    public enum ManpowerObjective {
        ReplaceOldPosition, //ทดแทนตำแหน่งงานเดิม
        AddOldPosition, //เพิ่มจำนวนในตำแหน่งงานเดิม
        AddNewPosition, //เพิ่มในตำแหน่งใหม่
        KHReview, //เปลี่ยนแปลงขอบข่ายงาน (KH Review)
        ExtendFirstContract //ต่อสัญญาครั้งที่ 1
    }
    
    public enum ManpowerStatus {
        Draft,
        WaitingToEmployeeApproved,
        WaitingToSectionHead,
        WaitingToVP,
        WaitingToProjectManager,
        WaitingToAcknowledge,
        Completed,
        WaitingToEmployeeRevise,
        WaitingToAdminEmployeeRevise,
        Cancelled
    }
    
    public enum ManpowerServiceFor {
        TOP,
        TES,
        TLB,
        TPX,
        LABIX,
        TET,
        TOPSPP,
        TOPNEXT,
        TTC
    }
    
    public enum ManpowerWorkLocation {
        Bangkok,
        Sriracha
    }
    
    public enum ManpowerApprovalStatus {
        Submitted,
        Approved,
        Rejected,
        Cancelled,
        Acknowledged,
        Pending,
        Blank,
        AutoApproved
    }
    
    public enum ManpowerApproverRole {
        Employee,
        EmployeeAdmin,
        SectionHead,
        VP,
        AdminPMBP,
        ProjectManager,
        AdminPEOC
    }
    
    public enum ManpowerWorkflowType {
        Permanent1,
        Permanent2, 
        Permanent3,
        Permanent4,
        Temporary1,   
        Temporary2,
        Temporary3,
        Temporary4,
        Temporary5,
        Temporary6,
        ProjectBase1,
        ProjectBase2,
        ProjectBase3,
        ProjectBase4,
        ProjectBase5,
        ProjectBase6
    }

    public enum FixTypeOfService {
        OfficeEquipment, //งานซ่อมอุปกรณ์สำนักงาน/ส่วนอาคาร
        Housing, //งานแจ้งซ่อมบ้านพัก
        Transportation, //งานซ่อมยานพาหนะ
        GeneralService //อื่นๆ
    }

    public static string getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService data)
    {
        if (data == ESS_Enum.FixTypeOfService.OfficeEquipment) {
            return 'งานซ่อมอุปกรณ์สำนักงาน/ส่วนอาคาร';
        }else if (data == ESS_Enum.FixTypeOfService.Housing) {
            return 'งานแจ้งซ่อมบ้านพัก';
        }else if (data == ESS_Enum.FixTypeOfService.Transportation) {
            return 'งานซ่อมยานพาหนะ';
        }else if (data == ESS_Enum.FixTypeOfService.GeneralService) {
            return 'งานบริการอื่นๆ';
        }
        return '';
    }

    public enum FixAndGeneralDocumentStatus {
        Draft,
        Verifying,
        Waiting,
        OnProcess,
        Completed,
        Rejected,
        Cancelled
    }

    public enum OfficeTypeOfService {
        ElectricalAndLightingSystem, //ระบบไฟฟ้าและแสงสว่าง
        PlumbingSystem, //ระบบน้ำประปา
        SewageSystem, //ระบบน้ำทิ้ง
        HvacSystem, //ระบบเครื่องปรับอากาศ
        LiftSystem, //ระบบลิฟท์
        GasSystem, //ระบบแก๊ส
        FireAlarmSystem, //ระบบ​ Fire Alarm - Smoke Detector, Gas Detector, เสียงสัญญาณเตือน
        CctvSystem, //ระบบ CCTV 
        ElectricalAppliances, //เครื่องใช้ไฟฟ้า
        BathroomFixturesAndEquipment, //อุปกรณ์สุขภัณฑ์
        FurnitureAndOfficeEquipment, //เฟอร์นิเจอร์และอุปกรณ์สำนักงาน
        BuildingStructure, //โครงสร้างอาคาร
        Other //อื่นๆ
    }

    public static String getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService data)
    {
        if (data == ESS_Enum.OfficeTypeOfService.ElectricalAndLightingSystem) {
            return 'ระบบไฟฟ้าและแสงสว่าง';
        }else if (data == ESS_Enum.OfficeTypeOfService.PlumbingSystem) {
            return 'ระบบน้ำประปา';
        }else if (data == ESS_Enum.OfficeTypeOfService.SewageSystem) {
            return 'ระบบน้ำทิ้ง';
        }else if (data == ESS_Enum.OfficeTypeOfService.HvacSystem) {
            return 'ระบบเครื่องปรับอากาศ';
        }else if (data == ESS_Enum.OfficeTypeOfService.LiftSystem) {
            return 'ระบบลิฟท์';
        }else if (data == ESS_Enum.OfficeTypeOfService.GasSystem) {
            return 'ระบบแก๊ส';
        }else if (data == ESS_Enum.OfficeTypeOfService.FireAlarmSystem) {
            return 'ระบบ​ Fire Alarm - Smoke Detector, Gas Detector, เสียงสัญญาณเตือน';
        }else if (data == ESS_Enum.OfficeTypeOfService.CctvSystem) {
            return 'ระบบ CCTV';
        }else if (data == ESS_Enum.OfficeTypeOfService.ElectricalAppliances) {
            return 'เครื่องใช้ไฟฟ้า';
        }else if (data == ESS_Enum.OfficeTypeOfService.BathroomFixturesAndEquipment) {
            return 'อุปกรณ์สุขภัณฑ์';
        }else if (data == ESS_Enum.OfficeTypeOfService.FurnitureAndOfficeEquipment) {
            return 'เฟอร์นิเจอร์และอุปกรณ์สำนักงาน';
        }else if (data == ESS_Enum.OfficeTypeOfService.BuildingStructure) {
            return 'โครงสร้างอาคาร';
        }else if (data == ESS_Enum.OfficeTypeOfService.Other) {
            return 'อื่นๆ';
        }
        return '';
    }
    
    public enum HousingTypeOfService {
        ElectricalAndLightingSystem, //ระบบไฟฟ้าและแสงสว่าง
        PlumbingSystem, //ระบบน้ำประปา
        SewageSystem, //ระบบน้ำทิ้ง
        HvacSystem, //ระบบเครื่องปรับอากาศ
        GasSystem, //ระบบแก๊ส
        CctvSystem, //ระบบ CCTV 
        ElectricalAppliances, //เครื่องใช้ไฟฟ้า
        BathroomFixturesAndEquipment, //อุปกรณ์สุขภัณฑ์
        FurnitureAndOfficeEquipment, //เฟอร์นิเจอร์และอุปกรณ์สำนักงาน
        BuildingStructure, //โครงสร้างอาคาร
        Other //อื่นๆ
    }

    public static String getHousingTypeOfServiceValue(ESS_Enum.HousingTypeOfService data)
    {
        if (data == ESS_Enum.HousingTypeOfService.ElectricalAndLightingSystem) {
            return 'ระบบไฟฟ้าและแสงสว่าง';
        }else if (data == ESS_Enum.HousingTypeOfService.PlumbingSystem) {
            return 'ระบบน้ำประปา';
        }else if (data == ESS_Enum.HousingTypeOfService.SewageSystem) {
            return 'ระบบน้ำทิ้ง';
        }else if (data == ESS_Enum.HousingTypeOfService.HvacSystem) {
            return 'ระบบเครื่องปรับอากาศ';
        }else if (data == ESS_Enum.HousingTypeOfService.GasSystem) {
            return 'ระบบแก๊ส';
        }else if (data == ESS_Enum.HousingTypeOfService.CctvSystem) {
            return 'ระบบ CCTV';
        }else if (data == ESS_Enum.HousingTypeOfService.ElectricalAppliances) {
            return 'เครื่องใช้ไฟฟ้า';
        }else if (data == ESS_Enum.HousingTypeOfService.BathroomFixturesAndEquipment) {
            return 'อุปกรณ์สุขภัณฑ์';
        }else if (data == ESS_Enum.HousingTypeOfService.FurnitureAndOfficeEquipment) {
            return 'เฟอร์นิเจอร์และอุปกรณ์สำนักงาน';
        }else if (data == ESS_Enum.HousingTypeOfService.BuildingStructure) {
            return 'โครงสร้างอาคาร';
        }else if (data == ESS_Enum.HousingTypeOfService.Other) {
            return 'อื่นๆ';
        }
        return '';
    }

    public enum HousingPeriod {
        A, B, C, D, Daywork
    }

    public enum HousingType {
        SiteHouse,
        AHouse,
        BUpgrade,
        BHouse,
        CUpgrade,
        CHouse
    }
    public static String getHousingType(ESS_Enum.HousingType data)
    {
        if (data == ESS_Enum.HousingType.SiteHouse) {
            return 'Site House';
        }else if (data == ESS_Enum.HousingType.AHouse) {
            return 'A-House';
        }else if (data == ESS_Enum.HousingType.BUpgrade) {
            return 'B-Upgrade';
        }else if (data == ESS_Enum.HousingType.BHouse) {
            return 'B-House';
        }else if (data == ESS_Enum.HousingType.CUpgrade) {
            return 'C-Upgrade';
        }else if (data == ESS_Enum.HousingType.CHouse) {
            return 'C-House';
        }
        return '';
    }

    public enum TransportationTypeOfService {
        ChangeTire, //เปลี่ยนยาง
        ChangeChain, //เปลี่ยนโซ่
        ChangeSeat, //เปลี่ยนเบาะ
        Other //อื่นๆ
    }

    public static string getTransportationTypeOfServiceValue(ESS_Enum.TransportationTypeOfService data)
    {
        if (data == ESS_Enum.TransportationTypeOfService.ChangeTire) {
            return 'เปลี่ยนยาง';
        }else if (data == ESS_Enum.TransportationTypeOfService.ChangeChain) {
            return 'เปลี่ยนโซ่';
        }else if (data == ESS_Enum.TransportationTypeOfService.ChangeSeat) {
            return 'เปลี่ยนเบาะ';
        }else if (data == ESS_Enum.TransportationTypeOfService.Other) {
            return 'อื่นๆ';
        }
        return '';
    }

    public enum TransportationType {
        Bicycle,
        Car
    }

    public static string getTransportationTypeValue(ESS_Enum.TransportationType data)
    {
        if (data == ESS_Enum.TransportationType.Bicycle) {
            return 'จักรยาน';
        }else if (data == ESS_Enum.TransportationType.Car) {
            return 'รถยนต์';
        }
        return '';
    }

    public enum GeneralTypeOfService {
        MovingService, //งานขนย้าย
        EventAndConferencePlanning, //งานจัดสถานที่/ห้องประชุม
        FurnitureAndOfficeEquipmentArrangement, //งานจัดเฟอร์นิเจอร์และอุปกรณ์สำนักงาน
        ElectricalAppliancesArrangement, //งานจัดเครื่องใช้ไฟฟ้า
        Landscaping, //งานภูมิทัศน์
        CleaningService, //งานทำความสะอาด
        Other //อื่นๆ
    }

    public static String getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService data)
    {
        if (data == ESS_Enum.GeneralTypeOfService.MovingService) {
            return 'งานขนย้าย';
        }else if (data == ESS_Enum.GeneralTypeOfService.EventAndConferencePlanning) {
            return 'งานจัดสถานที่/ห้องประชุม';
        }else if (data == ESS_Enum.GeneralTypeOfService.FurnitureAndOfficeEquipmentArrangement) {
            return 'งานจัดเฟอร์นิเจอร์และอุปกรณ์สำนักงาน';
        }else if (data == ESS_Enum.GeneralTypeOfService.ElectricalAppliancesArrangement) {
            return 'งานจัดเครื่องใช้ไฟฟ้า';
        }else if (data == ESS_Enum.GeneralTypeOfService.Landscaping) {
            return 'งานภูมิทัศน์';
        }else if (data == ESS_Enum.GeneralTypeOfService.CleaningService) {
            return 'งานทำความสะอาด';
        }else if (data == ESS_Enum.GeneralTypeOfService.Other) {
            return 'อื่นๆ';
        }
        return '';
    }

    public enum PMSVAdminType {
        PMSVFixAndGeneral,
        PMSVTransportation,
        PMSV
    }
    
    //Hotel
    public enum HotelBookingStatus
    {
        Draft, OnProcess, Verifying, Completed, Cancel, Rejected
    }
    
    public enum HotelBedType 
    {
        //01,02,03 SAP Value
    	StandardSingle,StandardDouble,StandardTwins   
    }
    
    public enum HotelRoomType 
    {
    	KingBed,TwinBed  
    }
    
    //Stationary
    public enum StationarySupplier
    {
        Maneerak, OfficeMate, Other, Cooperative
    }
    
    public enum StationaryType
    {
        General,Other
    }
        
    public enum StationaryServiceFor
    {
        TOPTSR,TOPTBK,TLB,TPX,TTC,TX,TES,TET,LABIX,Other,TOPSPP
    }
    
    public static String getStationaryServiceForValue(ESS_Enum.StationaryServiceFor data)
    {
        if (data == ESS_Enum.StationaryServiceFor.TOPTSR) {
            return 'TOPTSR';
        }else if (data == ESS_Enum.StationaryServiceFor.TOPTBK) {
            return 'TOPTBK';
        }else if (data == ESS_Enum.StationaryServiceFor.TLB) {
            return 'TLB';
        }else if (data == ESS_Enum.StationaryServiceFor.TPX) {
            return 'TPX';
        }else if (data == ESS_Enum.StationaryServiceFor.TTC) {
            return 'TTC';
        }else if (data == ESS_Enum.StationaryServiceFor.TX) {
            return 'TX';
        }else if (data == ESS_Enum.StationaryServiceFor.TES) {
            return 'TES';
        }else if (data == ESS_Enum.StationaryServiceFor.LABIX) {
            return 'LABIX';
        }else if (data == ESS_Enum.StationaryServiceFor.TOPSPP) {
            return 'TOPSPP';
        }else if (data == ESS_Enum.StationaryServiceFor.Other) {
            return 'อื่นๆ';
        }
        
        return '';
    }
        
    public enum StationaryServiceStatus
    {
        Draft, WaitingToApprove, OnProcess, Verifying, Completed, Rejected, Cancelled, Waiting
    }
        
    public enum StationaryWithdrawFrom
    {
        TSR, TBK
    }
        
    public enum StationaryPrivilege
    {
        TSR,TBK
    }
    
    public static String getStationaryWithdrawFromValue(ESS_Enum.StationaryWithdrawFrom data)
    {
        if (data == ESS_Enum.StationaryWithdrawFrom.TSR) {
            return 'TOP-TSR';
        }else if (data == ESS_Enum.StationaryWithdrawFrom.TBK) {
            return 'TOP-TBK';
        }
        return '';
    }
    
    public enum StationaryReport {
        RemainingStockReport, //รายงานสรุปจำนวนสินค้าคงคลัง
        OutOfStockReport, //รายงานเตือนสินค้าใกล้หมด
        DailyWithdrawTaxReport, //รายงานสรุปยอดการเบิกสินค้าแต่ละวันสามารถออกใบกำกับภาษีได้
        DailyWithdrawReport, //รายงานสรุปคำขอเบิกสินค้าในแต่ละวัน
        RequesterWithdrawReport, //รายงานสรุปยอดการเบิกสินค้าโดยระบุชื่อตำแหน่งพนักงาน
        WithdrawItemReport //รายงานการเบิกจ่ายวัสดุของสินค้าแต่ละชนิด
    }
    
    public enum Environment {
        DEV,QAS,PROD
    }
}