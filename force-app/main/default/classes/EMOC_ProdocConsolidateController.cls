public class EMOC_ProdocConsolidateController {
    
    private static final List<String> sObjList = new List<String> {'E_MOC_Attachment_Doc_require__c', 
        														   'E_MOC_Attachment_Detail_design__c', 
        														   'E_MOC_Attachment_Deviate_form__c', 
        														   'E_MOC_Attachment_PSSR_category__c', 
        														   'E_MOC_Attachment_Risk_analysis__c'};
    
    @AuraEnabled
    public static List<Map<String, Object>> getOptions(String recordId) {
        List<Map<String, Object>> options = new List<Map<String, Object>>();
        // count child records
        E_MOC_Application__c eMocApp = [SELECT Id, Name, 
                                                  (SELECT Id FROM E_MOC_Attachment_Doc_require__r), 
                                                  (SELECT Id FROM E_MOC_Attachment_Detail_design__r), 
                                                  (SELECT Id FROM E_MOC_Attachment_Deviate_form__r), 
                                                  (SELECT Id FROM E_MOC_Attachment_PSSR_category__r), 
                                                  (SELECT Id FROM E_MOC_Attachment_Risk_analysis__r) FROM E_MOC_Application__c WHERE Id = :recordId];
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for(String sObj : sObjList) {
            Integer count = 0;
            String iconName = 'custom:custom21';
            String iconTitle = '';
            switch on sObj {
                when 'E_MOC_Attachment_Doc_require__c' {
                    count = eMocApp.E_MOC_Attachment_Doc_require__r.size();
                }
                when 'E_MOC_Attachment_Detail_design__c' {
                    count = eMocApp.E_MOC_Attachment_Detail_design__r.size();
                }
                when 'E_MOC_Attachment_Deviate_form__c' {
                    count = eMocApp.E_MOC_Attachment_Deviate_form__r.size();
                }
                when 'E_MOC_Attachment_PSSR_category__c' {
                    count = eMocApp.E_MOC_Attachment_PSSR_category__r.size();
                }
                when 'E_MOC_Attachment_Risk_analysis__c' {
                    count = eMocApp.E_MOC_Attachment_Risk_analysis__r.size();
                }
            }
            
            Schema.DescribeSObjectResult d = gd.get(sObj).getDescribe();
            options.add(new Map<String, Object> {
                'label' => d.getLabel() + ' (' + count + ')',
                'value' => sObj,
                'iconName' => iconName,
                'iconTitle' => d.getLabel(),
                'isSelected' => false
            });
            
        }
        return options;
    }
    
    @AuraEnabled
    public static Map<String, Object> retrieveData(String selectedOption, String recordId) {
        List<sObject> dataList = Database.query('SELECT Id, Name, E_MOC_Doc_Type__c, E_MOC_Checklist_type__c, CreatedById, CreatedBy.Name, CreatedBy.Username, E_MOC_Application__c, E_MOC_Application__r.Name FROM ' + selectedOption + ' WHERE E_MOC_Application__c = :recordId');
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult d = gd.get(selectedOption).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = d.fields.getMap();
        List<Map<String, String>> columnList = new List<Map<String, String>>();
        columnList.add(new Map<String, String> {
            'label' => fieldMap.get('Name').getDescribe().getLabel(),
            'fieldName' => 'Name',
            'type' => 'text'
        });
        columnList.add(new Map<String, String> {
            'label' => fieldMap.get('E_MOC_Doc_Type__c').getDescribe().getLabel(),
            'fieldName' => 'E_MOC_Doc_Type__c',
            'type' => 'text'
        });
        columnList.add(new Map<String, String> {
            'label' => fieldMap.get('E_MOC_Checklist_type__c').getDescribe().getLabel(),
            'fieldName' => 'E_MOC_Checklist_type__c',
            'type' => 'text'
        });
        return new Map<String, Object> {
            'data' => dataList,
            'columns' => columnList
        };
    }
    
    @AuraEnabled
    public static Map<String, Object> prepareToConsolidate(String selectedData, String recordId) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            if(selectedData != null) {
                Map<String, Object> dataMap = new Map<String, Object>();
                Map<String, Object> selectedDataMap = new Map<String, Object>();
                Set<String> setSelectedIds = new Set<String>();
                List<Object> selectedDataList = (List<Object>) JSON.deserializeUntyped(selectedData);
                for(Object obj : selectedDataList) {
                    Map<String, Object> rawData = (Map<String, Object>) obj;
                    String rawDataId = (String) rawData.get('Id');
                    setSelectedIds.add(rawDataId);
                    
                    selectedDataMap.put(rawDataId, rawData);
                }
                
                List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.ContentSize, ContentDocument.FileType, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId = :setSelectedIds];
                Set<Id> setContentDocumentLinkIds = new Set<Id>();
                if(!cdlList.isEmpty()) {
                    for(ContentDocumentLink cdl : cdlList) {
                        setContentDocumentLinkIds.add(cdl.ContentDocumentId);
                        Map<String, Object> rawData = new Map<String, Object>();
                        rawData.putAll((Map<String, Object>) selectedDataMap.get(cdl.LinkedEntityId));
                        rawData.put('ContentDocumentId', cdl.ContentDocumentId);
                        dataMap.put(cdl.ContentDocumentId, rawData);
                    }
                }
                
                if(!setContentDocumentLinkIds.isEmpty()) {
                    List<ContentVersion> cvList = [SELECT Id, IsLatest, VersionData, ContentDocumentId, ContentDocument.Title, OwnerId, Owner.Username, CreatedById, CreatedBy.Username FROM ContentVersion WHERE ContentDocumentId = :setContentDocumentLinkIds AND IsLatest = TRUE];
                    if(!cvList.isEmpty()) {
                        for(ContentVersion cv : cvList) {
                            Map<String, Object> rawData = (Map<String, Object>) dataMap.get(cv.ContentDocumentId);
                            rawData.put('VersionData', cv.VersionData);
                            rawData.put('OwnerUserName', cv.CreatedBy.Username);
                            rawData.put('ContentDocumentId', cv.ContentDocumentId);
                            rawData.put('ContentDocumentTitle', cv.ContentDocument.Title);
                            dataMap.put(cv.ContentDocumentId, rawData);
                        }
                    }
                }
                
                if(dataMap != null && !dataMap.isEmpty()) {
                    Map<String, Object> response = EMOC_ProdocConsolidateCallout.generateData(dataMap);
                    Map<String, E_MOC_Attachment_Consolidate__c> consolidateMap = new Map<String, E_MOC_Attachment_Consolidate__c>();
                    Map<String, ContentVersion> cvMap = new Map<String, ContentVersion>();
                    if(response.get('isCalloutSuccess') == true) {
                        if(response.containsKey('ListEmocReq')) {
                            Integer consoCount = 0;
                            for(EMOC_ProdocConsolidateCallout.ConsoResponseData consoRes : (List<EMOC_ProdocConsolidateCallout.ConsoResponseData>) response.get('ListEmocReq')) {
                                System.debug('consoRes -----' + consoRes);
                                // consoCount++;
                                E_MOC_Attachment_Consolidate__c conso = new E_MOC_Attachment_Consolidate__c();
                                conso.E_MOC_Checklist_type__c = consoRes.EmocCheckListType;
                                conso.E_MOC_Doc_Type__c = consoRes.EmocDocType;
                                conso.E_MOC_Application__c = recordId; // consoRes.Emoc_SFDCID;
                                
                                if(!String.isBlank(consoRes.ConsoRawFile) && !String.isBlank(consoRes.ConsoFileName)) {
                                    consoCount++;
                                    E_MOC_Attachment_Consolidate__c consoFile = conso.clone();
                                    consoFile.Description__c = consoRes.ConsoFileName;
                                    consolidateMap.put('conso-' + consoCount, consoFile);
                                    
                                    Blob rawFileBlob = EncodingUtil.base64Decode(consoRes.ConsoRawFile);
                                    ContentVersion cv = new ContentVersion();
                                    cv.Title = consoRes.ConsoFileName.split('\\.')[0];
                                    cv.PathOnClient = consoRes.ConsoFileName;
                                    cv.VersionData = rawFileBlob;
                                    cv.IsMajorVersion = true;
                                    cvMap.put('conso-' + consoCount, cv);
                                }
                                if(!String.isBlank(consoRes.ExcelCommentRawFile) && !String.isBlank(consoRes.ExcelCommentFileName)) {
                                    consoCount++;
                                    E_MOC_Attachment_Consolidate__c consoExcel = conso.clone();
                                    consoExcel.Description__c = consoRes.ExcelCommentFileName;
                                    consolidateMap.put('conso-' + consoCount, consoExcel);
                                    
                                    Blob rawFileBlob = EncodingUtil.base64Decode(consoRes.ExcelCommentRawFile);
                                    ContentVersion cv = new ContentVersion();
                                    cv.Title = consoRes.ExcelCommentFileName.split('\\.')[0];
                                    cv.PathOnClient = consoRes.ExcelCommentFileName;
                                    cv.VersionData = rawFileBlob;
                                    cv.IsMajorVersion = true;
                                    cvMap.put('conso-' + consoCount, cv);
                                }
                            }
                            if(consolidateMap != null && !consolidateMap.isEmpty()) insert consolidateMap.values();
                            System.debug('consolidateMap -----' + consolidateMap);
                            if(cvMap != null && !cvMap.isEmpty()) {
                                insert cvMap.values();
                                
                                Set<Id> setCvIds = new Set<Id>();
                                for(ContentVersion cv : cvMap.values()) {
                                    setCvIds.add(cv.Id);
                                }
                                Map<Id, ContentVersion> insertedCvMap = new Map<Id, ContentVersion>([SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :setCvIds]);
                                List<ContentDocumentLink> newCdlList = new List<ContentDocumentLink>();
                                for(String key : cvMap.keySet()) {
                                    E_MOC_Attachment_Consolidate__c conso = consolidateMap.get(key);
                                    ContentVersion cv = cvMap.get(key);
                                    ContentDocumentLink cdl = new ContentDocumentLink();
                                    cdl.LinkedEntityId = conso.Id;
                                    cdl.ContentDocumentId = insertedCvMap.get(cv.Id).ContentDocumentId;
                                    cdl.ShareType = 'V';
                                    newCdlList.add(cdl);
                                }
                                if(!newCdlList.isEmpty()) insert newCdlList;
                            }
                        }
                        if(response.containsKey('ListErrorFile')) {
                            List<Map<String, String>> listErrorColumnList = new List<Map<String, String>>();
                            listErrorColumnList.add(new Map<String, String> {
                                'label' => 'Error File Name',
                                'fieldName' => 'ErrorFileName',
                                'type' => 'text'
                            });
                            listErrorColumnList.add(new Map<String, String> {
                                'label' => 'Error Status',
                                'fieldName' => 'ErrorStatus',
                                'type' => 'text'
                            });
                            
                            List<Map<String, String>> listErrorFile = new List<Map<String, String>>();
                            for(EMOC_ProdocConsolidateCallout.EMOCErrorFileData error : (List<EMOC_ProdocConsolidateCallout.EMOCErrorFileData>) response.get('ListErrorFile')) {
                                listErrorFile.add(new Map<String, String> {
                                    'ErrorFileName' => error.ErrorFileName,
                                    'ErrorStatus' => error.ErrorStatus
                                });
                            }
                            result.put('ListErrorFile', listErrorFile);
                            result.put('ListErrorColumn', listErrorColumnList);
                        }
                    }
                    result.put('isCalloutSuccess', response.get('isCalloutSuccess'));
                    result.put('StatusMsg', response.get('StatusMsg'));
                }
            }
        } catch(Exception ex) {
            System.debug('Exception ex ------' + ex.getStackTraceString() + '\n' + ex.getMessage());
            throw new AuraHandledException(ex.getStackTraceString() + '\n' + ex.getMessage());
        }
        return result;
    }
}