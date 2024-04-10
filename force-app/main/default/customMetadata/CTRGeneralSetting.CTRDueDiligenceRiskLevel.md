<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CTRDueDiligenceRiskLevel</label>
    <protected>false</protected>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Check Due Diligence Risk Level</value>
    </values>
    <values>
        <field>LongValue__c</field>
        <value xsi:type="xsd:string">{
    &quot;TOP&quot;: {
        &quot;RiskLevelbySystem__c&quot;: {
            &quot;disabled&quot;: true
        },
        &quot;RiskLevelbyTRCR__c&quot;: {
            &quot;actorStep&quot;: &quot;Credit&quot;
        },
        &quot;RiskLevelbyCPXX__c&quot;: {
            &quot;actorStep&quot;: &quot;CPCE&quot;
        }
    },
    &quot;TX&quot;: {
        &quot;RiskLevelbySystem__c&quot;: {
            &quot;disabled&quot;: true
        },
        &quot;RiskLevelbyTRCR__c&quot;: {
            &quot;label&quot;: &quot;Risk Level by TXFA&quot;,
            &quot;actorStep&quot;: &quot;Credit&quot;
        },
        &quot;RiskLevelbyCPXX__c&quot;: {
            &quot;actorStep&quot;: &quot;CPCE&quot;
        }
    },
    &quot;LABIX&quot;: {
        &quot;RiskLevelbySystem__c&quot;: {
            &quot;disabled&quot;: true
        },
        &quot;RiskLevelbyTRCR__c&quot;: {
            &quot;label&quot;: &quot;Risk Level by FALB&quot;,
            &quot;actorStep&quot;: &quot;Credit&quot;
        },
        &quot;RiskLevelbyCPXX__c&quot;: {
            &quot;actorStep&quot;: &quot;CPCE&quot;
        }
    }
}</value>
    </values>
    <values>
        <field>Value__c</field>
        <value xsi:type="xsd:string">RiskLevelbySystem__c;RiskLevelbyTRCR__c;RiskLevelbyCPXX__c</value>
    </values>
</CustomMetadata>
