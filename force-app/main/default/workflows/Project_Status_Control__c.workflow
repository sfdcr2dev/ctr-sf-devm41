<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CPEM_Step_8_Submit_Status_Approved</fullName>
        <field>Submit_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CPEM : Step 8 : Submit Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPEM_Step_8_Submit_Status_Pending</fullName>
        <field>Submit_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>CPEM : Step 8 : Submit Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPEM_Step_8_Submit_Status_Rejected</fullName>
        <field>Submit_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>CPEM : Step 8 : Submit Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_8_Update_After_Submit_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Step_8_After_Submit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Step 8 : Update After Submit RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_8_Update_Before_Submit_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Step_8_Before_Submit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Step 8 : Update Before Submit RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_8_Update_Completed_Work_Process</fullName>
        <field>Work_Process_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Step 8 : Update Completed Work Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_8_Update_In_Progress_WP</fullName>
        <field>Work_Process_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Step 8 : Update In Progress WP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
