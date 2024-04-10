<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>OutstandingReach80PercentOfCreditBalance</fullName>
        <ccEmails>an.t@roundtwosolutions.com</ccEmails>
        <ccEmails>sfdc.r2@roundtwosolutions.com</ccEmails>
        <ccEmails>pathompong.k@round2solutions.com</ccEmails>
        <description>Notify email when Outstanding reach 80% of Credit Balance</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>C360EmailTemplate/Financial_Info_Outstanding_Alert</template>
    </alerts>
</Workflow>
