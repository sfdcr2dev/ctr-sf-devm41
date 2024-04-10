/**
*   @author: Oktana
*   @description The class must contain public constant values
*                The constants must be grouped by objects through inner classes
*                Named convention: OBJECT_FIELD_VALUE
*                Example: CASE_STATUS_OPEN
*/

public with sharing class Constants {
    public static final ApprovalProcessConstants PROCESS = new ApprovalProcessConstants();
    public static final CheckedSheetConstants CHECKED_SHEETS = new CheckedSheetConstants();
    public static final OrderConstants ORDERS = new OrderConstants();
    public static final NotificationConstants NOTIFICATIONS = new NotificationConstants();
    public static final SOQLConstants SOQL = new SOQLConstants();

    public class ApprovalProcessConstants {
        public final String STATUS_APPROVED { get { return 'Approved'; } }
        public final String STATUS_REJECTED { get { return 'Rejected'; } }
        public final String STATUS_PENDING { get { return 'Pending'; } }
        public final String STATUS_PENDING_APPROVAL { get { return 'Pending for approval'; } }
        public final String ACTION_APPROVE { get { return 'Approve'; } }
    }

    public class CheckedSheetConstants {
        public final String STATUS_APPROVED { get { return 'Approved'; } }
        public final String STATUS_REJECTED { get { return 'Rejected'; } }
        public final String STATUS_PENDING_APPROVAL { get { return 'Pending for approval'; } }
        public final String STATUS_NEEDS_REVISION { get { return 'Needs Revision'; } }
        public final String STATUS_DRAFT { get { return 'Draft'; } }
    }

    public class OrderConstants {
        public final String TYPE_SH { get { return 'SH01'; } }
        public final String TYPE_PM { get { return 'PM01'; } }
        public final String TYPE_CM { get { return 'CM01'; } }

        public final String SYSTEM_STATUS_CRTD { get { return 'CRTD'; } }
        public final String SYSTEM_STATUS_REL { get { return 'REL'; } }
        public final String SYSTEM_STATUS_TECO { get { return 'TECO'; } }

        public final String STATUS_NEW { get { return 'New'; } }
        public final String STATUS_IN_PROGRESS { get { return 'In Progress'; } }
        public final String STATUS_CLOSED { get { return 'Closed'; } }
    }

    public class NotificationConstants {
        public final String SYSTEM_STATUS_OSNO { get { return 'OSNO'; } }
        public final String SYSTEM_STATUS_NOPR { get { return 'NOPR'; } }
        public final String SYSTEM_STATUS_NOCO { get { return 'NOCO'; } }

        public final String STATUS_NEW { get { return 'New'; } }
        public final String STATUS_IN_PROGRESS { get { return 'In Progress'; } }
        public final String STATUS_CLOSED { get { return 'Closed'; } }
    }

    public class SOQLConstants {
        public final Integer SOQL_LIMIT { get { return 50000; } }
    }
}