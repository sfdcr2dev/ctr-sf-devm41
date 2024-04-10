<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_email_for_Authorization_Team_Lead</fullName>
        <description>Approval email for Authorization Team Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_Authorization</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_DGIS</fullName>
        <description>Approval email for DGIS</description>
        <protected>false</protected>
        <recipients>
            <field>DGIS__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DGIS</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_DGVP</fullName>
        <description>Approval email for DGVP</description>
        <protected>false</protected>
        <recipients>
            <field>DGVP__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DGVP</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_Focal_Point</fullName>
        <description>Approval email for Focal Point</description>
        <protected>false</protected>
        <recipients>
            <recipient>OPP_Focal_Point</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Focal_Point</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_Hardware_Team_Lead</fullName>
        <description>Approval email for Hardware Team Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_Hardware</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_IT_Stationery_Team_Lead</fullName>
        <description>Approval email for IT Stationery Team Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_IT_Stationery</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_Project_Request_team_lead</fullName>
        <description>Approval email for Project team lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_Project</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_Software_Team_Lead</fullName>
        <description>Approval email for Software Team Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_Software</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_VP</fullName>
        <description>Approval email for VP</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_VP__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_VP</template>
    </alerts>
    <alerts>
        <fullName>Approval_email_for_manager</fullName>
        <description>Approval email for manager</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Manager</template>
    </alerts>
    <alerts>
        <fullName>DG_Service_Notify_Approved_Request_to_Creator</fullName>
        <description>DG Service: Notify Approved Request to Creator</description>
        <protected>false</protected>
        <recipients>
            <field>Creator_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Creator_Approved</template>
    </alerts>
    <alerts>
        <fullName>DG_Service_Notify_Approved_Request_to_Requester</fullName>
        <description>DG Service: Notify Approved Request to Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Requester_Approved</template>
    </alerts>
    <alerts>
        <fullName>DG_Service_Notify_Finished_Request_to_Creator</fullName>
        <description>DG Service: Notify Finished Request to Creator</description>
        <protected>false</protected>
        <recipients>
            <field>Creator_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Creator_Finished</template>
    </alerts>
    <alerts>
        <fullName>DG_Service_Notify_Finished_Request_to_Requester</fullName>
        <description>DG Service: Notify Finished Request to Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Requester_Finished</template>
    </alerts>
    <alerts>
        <fullName>DG_Service_Notify_Rejected_Request_to_Creator</fullName>
        <description>DG Service: Notify Rejected Request to Creator</description>
        <protected>false</protected>
        <recipients>
            <field>Creator_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Creator_Rejected</template>
    </alerts>
    <alerts>
        <fullName>DG_Service_Notify_Rejected_Request_to_Requester</fullName>
        <description>DG Service: Notify Rejected Request to Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_Requester_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_email_for_Hardware_Team_Lead_for_Price_Checking</fullName>
        <description>Notify email for Hardware Team Lead for Price Checking</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_Hardware</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead_to_Check_Price</template>
    </alerts>
    <alerts>
        <fullName>Notify_email_for_Software_Team_Lead_for_Price_Checking</fullName>
        <description>Notify email for Software Team Lead for Price Checking</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_Software</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead_to_Check_Price</template>
    </alerts>
    <alerts>
        <fullName>Notify_email_for_Stationery_Team_Lead_for_Price_Checking</fullName>
        <description>Notify email for Stationery Team Lead for Price Checking</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Lead_IT_Stationery</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OPP_DG_Service/DG_Notify_DG_Team_Lead_to_Check_Price</template>
    </alerts>
    <fieldUpdates>
        <fullName>Authorization_Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>DG_Admin_Authorization</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Authorization: Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hardware_Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>DG_Admin_Hardware</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Hardware: Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Project_Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>DG_Admin_Project_Request</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Project: Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Software_Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>DG_Admin_Software</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Software: Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stationary_Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>DG_Admin_IT_Stationery</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Stationary: Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Already_Approved</fullName>
        <field>Current_Approver__c</field>
        <formula>(&quot;Already Approved&quot;)</formula>
        <name>Update Already Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Status</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Update Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DGIS</fullName>
        <field>Current_Approver__c</field>
        <formula>(&quot;DGIS&quot;)</formula>
        <name>Update DGIS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DGVP</fullName>
        <field>Current_Approver__c</field>
        <formula>(&quot;DGVP&quot;)</formula>
        <name>Update DGVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DG_Team_Lead</fullName>
        <field>Current_Approver__c</field>
        <formula>(&quot;DG Team Lead&quot;)</formula>
        <name>Update DG Team Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Focal_Point_and_BPF</fullName>
        <field>Current_Approver__c</field>
        <formula>(&quot;Focal Point&quot;)</formula>
        <name>Update Focal Point and BPF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected</fullName>
        <field>Current_Approver__c</field>
        <name>Update Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Status</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Update Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_VP_name</fullName>
        <field>Current_Approver__c</field>
        <formula>Requester_VP__r.FirstName +&quot; &quot;+ Requester_VP__r.LastName</formula>
        <name>Update VP name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_approved_checkbox</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update approved checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_approved_checkbox_for_others</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update approved checkbox for others</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_approved_date_time</fullName>
        <field>Approved_Date_Time__c</field>
        <formula>(NOW())</formula>
        <name>Update approved date/time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_manager_name</fullName>
        <field>Current_Approver__c</field>
        <formula>Requester_Manager__r.FirstName + &quot; &quot; + Requester_Manager__r.LastName</formula>
        <name>Update manager name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_rejected_checkbox</fullName>
        <field>Rejected__c</field>
        <literalValue>1</literalValue>
        <name>Update rejected checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_DGIS</fullName>
        <field>Status</field>
        <literalValue>Waiting for DGIS Approval</literalValue>
        <name>Waiting for DGIS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_DGVP</fullName>
        <field>Status</field>
        <literalValue>Waiting for DGVP Approval</literalValue>
        <name>Waiting for DGVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_DG_Check_Price</fullName>
        <field>Status</field>
        <literalValue>DG Check Price</literalValue>
        <name>Waiting for DG Check Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_DG_Team_Lead</fullName>
        <field>Status</field>
        <literalValue>Waiting for DG Approval</literalValue>
        <name>Waiting for DG Team Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Focal_Point</fullName>
        <field>Status</field>
        <literalValue>Waiting for Auth Focal Point Approval</literalValue>
        <name>Waiting for Focal Point</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Manager</fullName>
        <field>Status</field>
        <literalValue>Waiting for Manager Approval</literalValue>
        <name>Waiting for Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_VP</fullName>
        <field>Status</field>
        <literalValue>Waiting for VP Approval</literalValue>
        <name>Waiting for VP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
