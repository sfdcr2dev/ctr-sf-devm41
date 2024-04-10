public with sharing class CG_Enum {
    public enum ApproverRole {
        Employee,
        Supervisor,
        GLVP,
        GLGC,
        SuperAdmin
    }
    public enum ApproverStatus {
        WaitingForSubmit,
        WaitingSupervisor,
        WaitingGLVP,
        WaitingGLGC,
        Submitted,
        Acknowledged,
        Rejected
    }
    public enum ReportStatus {
        WaitingForSubmit,
        WaitingSupervisor,
        WaitingGLVP,
        WaitingGLGC,
        Rejected,
        Success,
        Cancel,
        Expired
    }

    public enum COIReportType {
        COIAnnual,
        COIIncident,
        COINewEmployee
    }

    public enum COIDisclosure {
        Yes,
        No,
        NotSure
    }

    public enum CGReportType {
        CGNewEmployee,
        CGAnnual,
        CGManual
    }
    
    public enum GiftStatus {
        InStock,
        Donated
    }
}