<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CPEM_Step_0_Submit_Status_Approved</fullName>
        <field>Submit_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CPEM : Step 0 : Submit Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPEM_Step_0_Submit_Status_Pending</fullName>
        <field>Submit_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>CPEM : Step 0 : Submit Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPEM_Step_0_Submit_Status_Rejected</fullName>
        <field>Submit_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>CPEM : Step 0 : Submit Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_00_Update_After_Submit_RT</fullName>
        <field>Work_Process_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Step 00 : Update After Submit RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_00_Update_Before_Submit_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Step_00_Before_Submit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Step 00 : Update Before Submit RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_00_Update_Completed_Work_Process</fullName>
        <field>Work_Process_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Step 00 : Update Completed Work Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_00_Update_In_Progres_Work_Process</fullName>
        <field>Work_Process_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Step 00 : Update In Progres Work Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
