/* Author Softever */
global with sharing class ESS_MasterStationary {

    @RemoteAction
    public static integer GetMasterStationaryListCount(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
		string query = 'select id, minimum_stock__c, stock_on_hand__c from ESS_Master_Stationary__c where id != null AND stationary_name__c != null';
        
        //From Privilege
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        if(loginAs.size() > 0) {
            query += ' and Service_For__c IN :loginAs';
        }
        
        if (filter != null) {
            if (string.isNotBlank(filter.id)) {
                string id = '%' + filter.id + '%';
                query += ' and (name like :id or stationary_name__c like :id)';
            }
            
            //Active Filter
            boolean allActive = filter.allActive;
            if(allActive) {
                query += ' and active__c IN (TRUE,FALSE)';
            }
            else {
                boolean active = filter.active;
                query += ' and active__c = :active';
            }
            
            if(filter.showOnlyLowerStock) {
                query += ' and IsLowerMinimumStock__c = true';
            }
            
        }
        
        List<ESS_Master_Stationary__c> Stationaries = new List<ESS_Master_Stationary__c>();
        Stationaries = database.query(query);
        return Stationaries.size();
        
    }
    
    @RemoteAction
    public static List<ESS_MasterStationary_DTO.MasterStationaryListDTO> GetMasterStationaryList(SearchCriteria filter,
        //stationaryId,type,stationaryName,unit,minimumStock,stockOnHand,dueStock,availableStock,price,supplier,lastUpdatedDate,lastUpdatedBy                                                                                         
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {
          
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        string query = getMasterStationaryQuery();
        
        query += ' where stationary_name__c != null';
        
        //From Privilege
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        if(loginAs.size() > 0) {
            query += ' and Service_For__c IN :loginAs';
        }
        
        //Filter
        if (filter != null) {
            if (string.isNotBlank(filter.id)) {
                string id = '%' + filter.id + '%';
                query += ' and (name like :id or stationary_name__c like :id)';
            }
            
            //Active Filter
            boolean allActive = filter.allActive;
            if(allActive) {
                query += ' and active__c IN (TRUE,FALSE)';
            }
            else {
                boolean active = filter.active;
                query += ' and active__c = :active';
            }
            
            if(filter.showOnlyLowerStock) {
                query += ' and IsLowerMinimumStock__c = true';
            }
        }
        
        //Add Sort by logic
        //query += ' order by CreatedDate desc';
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
             string sortByQuery = ' order by';
             //string sortByQuery = '';
             if(sortByParam.sortBy == 'stationaryId') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' name asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' name desc';
                 }
             }
             else if(sortByParam.sortBy == 'type') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' type__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' type__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'stationaryName') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' stationary_name__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' stationary_name__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'unit') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' unit__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' unit__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'minimumStock') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' minimum_stock__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' minimum_stock__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'stockOnHand') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' stock_on_hand__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' stock_on_hand__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'dueStock') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' due_stock__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' due_stock__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'availableStock') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' available_stock__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' available_stock__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'price') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' price__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' price__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'supplier') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' supplier__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' supplier__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'lastUpdatedDate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' last_updated_date__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' last_updated_date__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'lastUpdatedBy') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' last_updated_by__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' last_updated_by__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'active') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' active__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' active__c desc';
                 }
             }
            
             query += sortByQuery;
         }
        
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
        
        List<ESS_Master_Stationary__c> models = Database.query(query);
        List<ESS_MasterStationary_DTO.MasterStationaryListDTO> results = new List<ESS_MasterStationary_DTO.MasterStationaryListDTO>();
        for (ESS_Master_Stationary__c model : models) {
            results.add(assignToMasterStationaryListDTO(model));
        }
        
        return results;
        
    }
    
    @RemoteAction
    public static ESS_MasterStationary_DTO.MasterStationaryDetailDTO GetMasterStationaryDetail(ESS_MasterStationary_DTO.SearchDTO search) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        ESS_MasterStationary_DTO.MasterStationaryDetailDTO result;
        
        if(string.isBlank(search.recordId)) {
            result = new ESS_MasterStationary_DTO.MasterStationaryDetailDTO();
            //Insert empty record
            ESS_Master_Stationary__c empty = new ESS_Master_Stationary__c();
            database.insert(empty);
            
            result.recordId = empty.id;
            
            Map<string, string> serviceFors = GetServiceFors();
            List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
            if(loginAs.size() > 0) {
                if(loginAs.size() == 1) {
                    result.isEditServiceFor = false;
                    
                    result.serviceFor = new ESS_Global.EnumValue('StationaryServiceFor');
                    if(loginAs[0] == ESS_Enum.StationaryPrivilege.TSR.name()) {
                        string serviceFor = ESS_Enum.StationaryWithdrawFrom.TSR.name();
                        result.serviceFor.key = serviceFor;
                        result.serviceFor.value = serviceFors.get(serviceFor);
                    }
                    else if(loginAs[0] == ESS_Enum.StationaryPrivilege.TBK.name()) {
                        string serviceFor = ESS_Enum.StationaryWithdrawFrom.TBK.name();
                        result.serviceFor.key = serviceFor;
                        result.serviceFor.value = serviceFors.get(serviceFor);
                    }
                }
                else {
                    result.isEditServiceFor = true;
                }
            }
            
        }
        else {
            ESS_Master_Stationary__c model = queryMasterStationaryById(search.recordId);
        	result = assignToMasterStationaryDTO(model);
        }
        
        return result;
        
    }
    
    @RemoteAction
    public static ESS_MasterStationary_DTO.MasterStationaryDetailDTO SaveMasterStationary(ESS_MasterStationary_DTO.MasterStationaryDetailDTO input) {
        ESS_MasterStationary_DTO.MasterStationaryDetailDTO masterHotel = new ESS_MasterStationary_DTO.MasterStationaryDetailDTO();
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isCreateNew = false;
        ESS_Master_Stationary__c model;
        
        if (string.isNotBlank(input.recordId)){
            model = queryMasterStationaryById(input.recordId);
        } else {
            isCreateNew = true;
            model = new ESS_Master_Stationary__c();
            model.OwnerId = userId;
        }
    
        if (input.attachmentFiles != null) {
            List<string> attachmentIds = new List<string>();
            for (ESS_DTO.FileDTO file : input.attachmentFiles) {
                attachmentIds.add(file.id);
            }
            model.Attachment_Files__c = String.join(attachmentIds, ',');
        }  
        
        if(input.active == null) {
            model.Active__c = false;
        }
        else {
            model.Active__c = input.active;
        }
        
        model.Due_Stock__c = input.dueStock;
        model.Name = input.stationaryId;
        model.Minimum_Stock__c = input.minimumStock;
        model.Other_Supplier__c = input.otherSupplier;
        model.Price__c = input.price;
        model.Stationary_Name__c = input.stationaryName;
        //model.Stock_History__c = 
        model.Stock_on_Hand__c = input.stockOnHand;
        model.Supplier__c = input.supplier.key;
        model.Type__c = input.type.key;
        model.Unit__c = input.unit;
        model.Available_Stock__c = input.availableStock;
        model.Service_For__c = input.serviceFor.key;
        
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        	model.Last_Updated_By_User__c = User.FirstName + ' ' + User.LastName;
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        	model.Last_Updated_By_User__c = PISUser.EN_Fullname__c;
        }
        
        model.Last_Updated_Date_User__c = date.today();
        
        if(isCreateNew){
            database.insert(model, true);
            
            //Get Empty record
            ESS_Master_Stationary__c empty = queryMasterStationaryById(input.recordId);
            //Manage file and change parent id
            ChangeUploadFileParentId(empty.Id, model.Id);
        }else{
            database.update(model, true);
        }
            
        ESS_MasterStationary_DTO.SearchDTO search = new ESS_MasterStationary_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_MasterStationary_DTO.MasterStationaryDetailDTO result = GetMasterStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static boolean DeleteMasterStationary(ESS_MasterStationary_DTO.SearchDTO search) {
        ESS_Master_Stationary__c model = queryMasterStationaryById(search.recordId);
        database.delete(model, true);
        return true;
    }
    
    @RemoteAction
    public static string UploadFile(ESS_MasterStationary_DTO.UploadFileDTO UploadFile) {
        
        string fileData = UploadFile.fileData;
        String base64 = fileData.substring(fileData.indexOf(',')+1);
        Blob actualdata = EncodingUtil.base64Decode(base64);

        string documentId = '';
        Attachment attch = new Attachment();
        attch.name = UploadFile.filename;
        attch.parentId  = UploadFile.recordId;
        attch.body = actualdata;
        // database.insert(attch, false);
        insert attch;
        documentId = attch.Id;
        return documentId;
    }
    
    @RemoteAction
    public static boolean CheckMasterStationaryID(string stationaryId) {
        string query = 'select count(name) from ESS_Master_Stationary__c where name = :stationaryId';
        
        AggregateResult result = Database.query(query);
        integer count = (Integer) result.get('expr0');
        if(count == 0) {
            return false;
        }
        else {
            return true;
        }
    }
    
    @RemoteAction
    public static string ExportMasterStationaryExcel(SearchCriteria filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_MasterStationary_Excel?';
        
        string id = filter.id;
        boolean allActive = filter.allActive;
        boolean active = filter.active;
        boolean showOnlyLowerStock = filter.showOnlyLowerStock;
        
        URL = URL + 'stationaryId=' + id + 
            		'&allActive=' + allActive + 
            		'&active=' + active + 
            		'&showOnlyLowerStock=' + showOnlyLowerStock;
        
        return URL;
    }
    
    public static string getMasterStationaryQuery()
    {
        return 
        'SELECT Active__c,Attachment_Files__c,Available_Stock__c,CreatedDate,Due_Stock__c,Id,LastModifiedById,' +
        'LastModifiedDate,Last_Updated_By__c,Last_Updated_Date__c,Minimum_Stock__c,Name,Other_Supplier__c,OwnerId,' +
        'Price__c,Service_For__c,Stationary_Name__c,Stock_History__c,Stock_on_Hand__c,Supplier__c,Type__c,Unit__c,Image_Url__c,IsLowerMinimumStock__c,' +
        'Last_Updated_By_User__c,Last_Updated_Date_User__c' +
        ' from ESS_Master_Stationary__c';
    }

	public static ESS_Master_Stationary__c queryMasterStationaryById(string recordId){
        string query = getMasterStationaryQuery();
        query +=  ' where Id = :recordId';
        ESS_Master_Stationary__c model = Database.query(query);
        return model;
    }
    
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
        result.availableStock = 0;
        if(result.stockOnHand > result.dueStock) {
            result.availableStock = result.stockOnHand - result.dueStock;
        }        
        result.price = model.Price__c;
        result.supplier = new ESS_Global.EnumValue('StationarySupplier');
        if(model.Supplier__c == ESS_Enum.StationarySupplier.Maneerak.name()) {
            result.supplier.key = ESS_Enum.StationarySupplier.Maneerak.name();
        	result.supplier.value = getSuppliers(model.Supplier__c);
        }
        else if(model.Supplier__c == ESS_Enum.StationarySupplier.OfficeMate.name()) {
            result.supplier.key = ESS_Enum.StationarySupplier.OfficeMate.name();
        	result.supplier.value = getSuppliers(model.Supplier__c);
        }
        else if(model.Supplier__c == ESS_Enum.StationarySupplier.Cooperative.name()) {
            result.supplier.key = ESS_Enum.StationarySupplier.Cooperative.name();
        	result.supplier.value = getSuppliers(model.Supplier__c);
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
    
    private static ESS_MasterStationary_DTO.MasterStationaryDetailDTO assignToMasterStationaryDTO(ESS_Master_Stationary__c model) {
        ESS_MasterStationary_DTO.MasterStationaryDetailDTO result = new ESS_MasterStationary_DTO.MasterStationaryDetailDTO();
        result.recordId = model.Id;
        
        Map<string, string> serviceFors = GetServiceFors();
        result.serviceFor = new ESS_Global.EnumValue('StationaryServiceFor');
        result.serviceFor.key = model.Service_For__c;
        result.serviceFor.value = serviceFors.get(model.Service_For__c);
        
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        if(loginAs.size() > 0) {
            if(loginAs.size() == 1) {
                result.isEditServiceFor = false;
            }
            else {
                result.isEditServiceFor = true;
            }
        }
        
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
        result.stationaryId = model.name;
        result.type = new ESS_Global.EnumValue('StationaryType');
        result.type.key = model.Type__c;
        result.type.value = model.Type__c;
        result.stationaryName = model.Stationary_Name__c;
        result.unit = model.unit__c;
        result.price = model.Price__c;
        result.stockOnHand = Integer.ValueOf(model.Stock_on_Hand__c);
        result.minimumStock = Integer.ValueOf(model.Minimum_Stock__c);
        result.supplier = new ESS_Global.EnumValue('StationarySupplier');
        result.supplier.key = model.Supplier__c;
        result.supplier.value = model.Supplier__c;
        result.otherSupplier = model.Other_Supplier__c;
        result.active = model.Active__c;
        
        return result;
    }
    
    public static string generateDocumentUrl(string fileId) {
        
        string finalURL;
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        finalURL = URL + '/servlet/servlet.FileDownload?file=' + fileId + '&operationContext=S1';
        return finalURL;
        
    }
    
    @TestVisible
    private static void ChangeUploadFileParentId(string oldParentId, string newParentId) {
        List<Attachment> Attachs = new List<Attachment>();
        List<Attachment> newAttachs = new List<Attachment>();
        
        Attachs = [select id, parentId, name, body from Attachment where parentId =: oldParentId];
        if(Attachs.size() > 0) {
            for(Attachment attach : Attachs) {
                Attachment newAttach = new Attachment();
                newAttach.name = attach.name;
                newAttach.parentId  = newParentId;
                newAttach.body = attach.body;
                newAttachs.add(newAttach);
            }
            
            //Insert into new record
            if(newAttachs.size() > 0) {
                database.insert(newAttachs, true);
            }
            //Delete attachment from old record
            //database.delete(attachs, true);
        }
    }
    
    private static Map<string, string> GetServiceFors()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Master_Stationary__c.Service_For__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getValue(), objPickList.getLabel());
        }
        return statuses;
    }
    
    @RemoteAction
    public static List<string> GetAvailableServiceFors() {
        
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        List<string> labels = new List<string>();
        
        Schema.DescribeFieldResult objFieldDescribe = ESS_Master_Stationary__c.Service_For__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            for(string serviceFor : loginAs) {
                if(serviceFor == objPickList.getValue()) {
                    labels.add(objPickList.getLabel());
                }
            }
        }
        return labels;
    }
    
    public static string getSuppliers(string value) {
        string label;
        Schema.DescribeFieldResult objFieldDescribe = ESS_Master_Stationary__c.Supplier__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(value == objPickList.getValue()) {
                label = objPickList.getLabel();
            }
        }
        return label;
    }
    
    public class SearchCriteria {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public boolean allActive {get;set;}
        @RemoteAction
        public boolean active {get;set;}
        @RemoteAction
        public boolean showOnlyLowerStock {get;set;}
    }
    
}