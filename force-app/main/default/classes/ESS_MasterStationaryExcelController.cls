public with sharing class ESS_MasterStationaryExcelController {

    public integer masterStationarySize {get;set;}
    public date todayDate {get;set;}
    public string stationaryId {get;set;}
    public boolean allActive {get;set;}
    public boolean active {get;set;}
    public boolean showOnlyLowerStock {get;set;}
    public integer year {get;set;}
    public string stationaryFrom {get;set;}
    
    public List<ESS_MasterStationary_DTO.MasterStationaryListDTO> stationaryTables {get;set;}

    public void OnloadExcel() {
        todayDate = date.today();
        year = date.today().year();
        string userId = ESS_PrivilegeHandler.getUserId();
        masterStationarySize = 0;
        stationaryFrom = '';
        stationaryId = ApexPages.currentPage().getParameters().get('StationaryId');
        allActive = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('allActive'));
        active = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('active'));
        showOnlyLowerStock = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('showOnlyLowerStock'));
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        string query = ESS_MasterStationary.getMasterStationaryQuery();
        
        query += ' where stationary_name__c != null';
        
        //From Privilege
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        if(loginAs.size() > 0) {
            query += ' and Service_For__c IN :loginAs';
            
            if(loginAs.size() == 1) {
                stationaryFrom = loginAs.tostring().replace('(','').replace(')','');
                if(stationaryFrom == ESS_Enum.StationaryWithdrawFrom.TSR.name()) {
                    stationaryFrom = 'PMSV';
                }
                else if(stationaryFrom == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
                    stationaryFrom = 'GSBO';
                }
            }
            else if(loginAs.size() > 1) {
                stationaryFrom = 'ALL';
            }
        }
        
        //Filter
        if (string.isNotBlank(stationaryId) && stationaryId.toLowerCase() != 'all') {
            string id = '%' + stationaryId + '%';
            query += ' and (name like :id or stationary_name__c like :id)';
        }
        //Active Filter
        if(allActive) {
            query += ' and active__c IN (TRUE,FALSE)';
        }
        else {
            query += ' and active__c = :active';
        }
        
        if(showOnlyLowerStock) {
            query += ' and IsLowerMinimumStock__c = true';
        }
        
        query += ' order by name asc';
        
        List<ESS_Master_Stationary__c> models = Database.query(query);
        stationaryTables = new List<ESS_MasterStationary_DTO.MasterStationaryListDTO>();
        for (ESS_Master_Stationary__c model : models) {
            stationaryTables.add(assignToMasterStationaryListDTO(model));
        }
        
        masterStationarySize = stationaryTables.size();
        
    }
    
    @TestVisible
    private static ESS_MasterStationary_DTO.MasterStationaryListDTO assignToMasterStationaryListDTO(ESS_Master_Stationary__c model) {
        ESS_MasterStationary_DTO.MasterStationaryListDTO result = new ESS_MasterStationary_DTO.MasterStationaryListDTO();
        result.recordId = model.Id;
        result.stationaryId = model.name;
        if (string.isNotBlank(model.Attachment_Files__c)){
            List<string> attachmentFileIds = model.Attachment_Files__c.split(',');
            result.attachmentFiles = new List<ESS_DTO.FileDTO>();
            for (string fileId : attachmentFileIds) {
                ESS_DTO.FileDTO fileDTO = new ESS_DTO.FileDTO();
                fileDTO.id = fileId;
                fileDTO.url = generateDocumentUrl(fileId);
                result.attachmentFiles.add(fileDTO);
            }
        }
        result.type = new ESS_Global.EnumValue('StationaryType');
        result.isLowerMinimumStock = model.IsLowerMinimumStock__c;
        if(model.Type__c == ESS_Enum.StationaryType.General.name()) {
            result.type.key = ESS_Enum.StationaryType.General.name();
            result.type.value = 'General';
        }
        result.stationaryName = model.Stationary_Name__c;
        result.unit = model.Unit__c;
        result.minimumStock = Integer.ValueOf(model.Minimum_Stock__c);
        if(model.Stock_on_Hand__c != null) {
            result.stockOnHand = Integer.ValueOf(model.Stock_on_Hand__c);
        }
        else {
            result.stockOnHand = 0;
        }
        if(model.Due_Stock__c != null) {
            result.dueStock = Integer.ValueOf(model.Due_Stock__c);
        }
        else {
            result.dueStock = 0;
        }
        
        result.isDueStockMore = false;
        if(result.stockOnHand < result.dueStock) {
            result.isDueStockMore = true;
        }
        result.availableStock = result.stockOnHand - result.dueStock;
        if(result.availableStock < 0) {
            result.availableStock = 0;
        }
        result.price = model.Price__c;
        result.supplier = new ESS_Global.EnumValue('StationarySupplier');
        if(model.Supplier__c == ESS_Enum.StationarySupplier.Maneerak.name()) {
            result.supplier.key = ESS_Enum.StationarySupplier.Maneerak.name();
            result.supplier.value = ESS_MasterStationary.getSuppliers(model.Supplier__c);
        }
        else if(model.Supplier__c == ESS_Enum.StationarySupplier.OfficeMate.name()) {
            result.supplier.key = ESS_Enum.StationarySupplier.OfficeMate.name();
            result.supplier.value = ESS_MasterStationary.getSuppliers(model.Supplier__c);
        }
        else if(model.Supplier__c == ESS_Enum.StationarySupplier.Other.name()) {
            result.supplier.key = ESS_Enum.StationarySupplier.Other.name();
            result.supplier.value = model.Other_Supplier__c;
        }
        result.lastUpdatedDate = model.Last_Updated_Date_User__c;
        result.lastUpdatedBy = model.Last_Updated_By_User__c;
        result.active = model.Active__c;
        result.serviceFor = new ESS_Global.EnumValue('StationaryServiceFor');
        if(model.Service_For__c == ESS_Enum.StationaryWithdrawFrom.TSR.name()) {
            result.serviceFor.key = ESS_Enum.StationaryWithdrawFrom.TSR.name();
            result.serviceFor.value = 'TOP-TSR (ศรีราชา)';
        }
        else if(model.Service_For__c == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            result.serviceFor.key = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            result.serviceFor.value = 'TOP-TBK (กรุงเทพ)';
        }
        
        if(model.Active__c) {
            result.canDelete = false;
        }
        else {
            result.canDelete = true;
        }
        
        return result;
    }
    
    public static string generateDocumentUrl(string fileId) {
        
        string finalURL;
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        finalURL = URL + '/servlet/servlet.FileDownload?file=' + fileId + '&operationContext=S1';
        return finalURL;
        
    }
    
}