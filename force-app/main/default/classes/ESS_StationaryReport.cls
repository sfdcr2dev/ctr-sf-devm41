global with sharing class ESS_StationaryReport {
    
    @RemoteAction
    public static List<string> LoginUserServiceFor() {
        List<string> serviceFors = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        return serviceFors;
    }
    
    //รายงานสรุปจำนวนสินค้าคงคลัง
    @RemoteAction
    public static integer RemainingStockReportCount(ReportFilter filter) {
        
        string query = 'select count(id) from ESS_Master_Stationary__c where id != null AND name != null AND active__c = true';
        
        if (filter != null) {
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
        }
        
        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    @RemoteAction
    public static List<ESS_StationaryReport_DTO.RemainingStockDTO> RemainingStockReport(ReportFilter filter, 
        ESS_Global.PageParam pageParam) {
        
        List<ESS_StationaryReport_DTO.RemainingStockDTO> stocks = new List<ESS_StationaryReport_DTO.RemainingStockDTO>();
        
        string query = 'select name, stationary_name__c, price__c, stock_on_hand__c, due_stock__c from ESS_Master_Stationary__c where id != null and name != null and active__c = true';
        
        if (filter != null) {
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
        }
        
        query += ' order by name asc';
        
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
        
        List<ESS_Master_Stationary__c> Masters = database.query(query);
        
        if(Masters.size() > 0) {
            for(ESS_Master_Stationary__c Master : Masters) {
                ESS_StationaryReport_DTO.RemainingStockDTO Stock = new ESS_StationaryReport_DTO.RemainingStockDTO();
                Stock.stationaryId = Master.name;
                Stock.name = Master.stationary_name__c;
                Stock.price = Master.price__c;
                Stock.stockOnHand = integer.valueOf(Master.stock_on_hand__c);
                Stock.stockOverdue = integer.valueOf(Master.due_stock__c);
                stocks.add(Stock);
            }
        }
        
        return stocks;
    }
    
    //รายงานเตือนสินค้าใกล้หมด
    @RemoteAction
    public static integer OutOfStockReportCount(ReportFilter filter) {
        integer count = 0;
        string query = 'select count(id) from ESS_Master_Stationary__c where id != null AND name != null AND active__c = true AND IsLowerMinimumStock__c = true';
        
        if (filter != null) {
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
        }
        
        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    @RemoteAction
    public static List<ESS_StationaryReport_DTO.OutOfStockDTO> OutOfStockReport(ReportFilter filter, 
        ESS_Global.PageParam pageParam) {
        List<ESS_StationaryReport_DTO.OutOfStockDTO> stocks = new List<ESS_StationaryReport_DTO.OutOfStockDTO>();
        
        string query = 'select name, stationary_name__c, price__c, minimum_stock__c, stock_on_hand__c, due_stock__c from ESS_Master_Stationary__c where id != null AND name != null AND active__c = true AND IsLowerMinimumStock__c = true';
        if (filter != null) {
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
        }
        
        query += ' order by createddate asc';
        
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
        
        List<ESS_Master_Stationary__c> Masters = database.query(query);
        if(Masters.size() > 0) {
            for(ESS_Master_Stationary__c Master : Masters) {
                ESS_StationaryReport_DTO.OutOfStockDTO Stock = new ESS_StationaryReport_DTO.OutOfStockDTO();
                Stock.stationaryId = Master.name;
                Stock.name = Master.stationary_name__c;
                Stock.price = Master.price__c;
                Stock.stockOnHand = integer.valueOf(Master.stock_on_hand__c);
                Stock.stockOverdue = integer.valueOf(Master.due_stock__c);
                Stock.stockMinimum = integer.valueOf(Master.minimum_stock__c);
                stocks.add(Stock);
            }
        }
        
        return stocks;
    }
    
    //รายงานสรุปยอดการเบิกสินค้าแต่ละวันสามารถออกใบกำกับภาษีได้
    @RemoteAction
    public static integer DailyWithdrawTaxReportCount(ReportFilter filter) {
        integer count = 0;
        string query = 'select name, withdraw_from_stock__c, withdraw_other__c from ESS_Stationary__c where document_no__c != null AND completed_date__c != null';
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        List<ESS_Stationary__c> Stationaries = database.query(query);
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawStocks.size();
                }
                if(string.isNotBlank(Stationary.Withdraw_Other__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawOthers.size();
                }
            }
        }
        return count;
    }
    
    @RemoteAction
    public static List<ESS_StationaryReport_DTO.DailyWithdrawDTO> DailyWithdrawTaxReport(ReportFilter filter) {
        
        List<ESS_StationaryReport_DTO.DailyWithdrawDTO> withdraws = new List<ESS_StationaryReport_DTO.DailyWithdrawDTO>();
        List<ESS_StationaryReport_DTO.DailyWithdrawDTO> finalWithdraws = new List<ESS_StationaryReport_DTO.DailyWithdrawDTO>();
        
        integer totalRecord = DailyWithdrawTaxReportCount(filter);
        
        string query = getStationaryDetailQuery();
        query += ' where document_no__c != null AND completed_date__c != null';
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        query += ' order by createddate desc';
        
        integer countRecord = 0;
        List<ESS_Stationary__c> Stationaries = database.query(query);
        
        ESS_StationaryReport_DTO.DailyWithdrawDTO Withdraw = new ESS_StationaryReport_DTO.DailyWithdrawDTO();
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                countRecord++;
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawStocks.size() > 0) {
                        for(integer j=0; j < withdrawStocks.size(); j++) {
                            Withdraw = new ESS_StationaryReport_DTO.DailyWithdrawDTO();
                            Withdraw.documentNo = Stationary.document_no__c;
                            Withdraw.location = Stationary.withdraw_from__c;
                            Withdraw.serviceFor = Stationary.service_for__c;
                            if(Stationary.on_behalf_of_flow__c) {
                                Withdraw.name = Stationary.on_behalf_of_en__c;
                                Withdraw.department = Stationary.on_behalf_of_department__c;
                                Withdraw.section = Stationary.On_Behalf_Of_Section__c;
                                Withdraw.employeeId = Stationary.On_Behalf_Of_Employee_Id__c;
                            }
                            else {
                                Withdraw.name = Stationary.requester_name_en__c;
                                Withdraw.department = Stationary.requester_department__c;
                                Withdraw.section = Stationary.Requester_Section__c;
                                Withdraw.employeeId = Stationary.Requester_Employee_Id__c;
                            }
                            Withdraw.stationaryId = withdrawStocks[j].stationaryId;
                            Withdraw.stationaryName = withdrawStocks[j].name;
                            Withdraw.quantity = withdrawStocks[j].quantity;
                            Withdraw.actualQuantity = integer.valueOf(withdrawStocks[j].actualWithdraw);
                            Withdraw.price = withdrawStocks[j].pricePerUnit;
                            Withdraw.totalPrice = withdrawStocks[j].totalPrice;
                            Withdraw.createdDate = Stationary.createddate;
                            Withdraw.submittedDate = Stationary.submitted_date__c;
                            Withdraw.requesterName = Stationary.requester_name_en__c;
                            Withdraw.completedBy = '-';
                            boolean pmsvNull = Stationary.pmsv__c.contains('null');
                            if(pmsvNull) {
                                Withdraw.completedBy = '-';
                            }
                            else {
                                Withdraw.completedBy = Stationary.pmsv__c;
                            }
                            Withdraw.completedDate = Stationary.completed_date__c;
                            Withdraw.currentStatus = Stationary.status__c;
                            withdraws.add(Withdraw);
                        }
                    }
                }
                 
                if(string.isNotBlank(Stationary.Withdraw_Other__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawOthers.size() > 0) {
                        for(integer j=0; j < withdrawOthers.size(); j++) {
                            Withdraw = new ESS_StationaryReport_DTO.DailyWithdrawDTO();
                            Withdraw.documentNo = Stationary.document_no__c;
                            Withdraw.location = Stationary.withdraw_from__c;
                            Withdraw.serviceFor = Stationary.service_for__c;
                            if(Stationary.on_behalf_of_flow__c) {
                                Withdraw.name = Stationary.on_behalf_of_en__c;
                                Withdraw.department = Stationary.on_behalf_of_department__c;
                                Withdraw.section = Stationary.On_Behalf_Of_Section__c;
                                Withdraw.employeeId = Stationary.On_Behalf_Of_Employee_Id__c;
                            }
                            else {
                                Withdraw.name = Stationary.requester_name_en__c;
                                Withdraw.department = Stationary.requester_department__c;
                                Withdraw.section = Stationary.Requester_Section__c;
                                Withdraw.employeeId = Stationary.Requester_Employee_Id__c;
                            }
                            Withdraw.stationaryId = withdrawOthers[j].stationaryId;
                            Withdraw.stationaryName = withdrawOthers[j].name;
                            Withdraw.quantity = withdrawOthers[j].quantity;
                            Withdraw.price = withdrawOthers[j].pricePerUnit;
                            Withdraw.actualQuantity = integer.valueOf(withdrawOthers[j].actualWithdraw);
                            Withdraw.totalPrice = withdrawOthers[j].totalPrice;
                            Withdraw.createdDate = Stationary.createddate;
                            Withdraw.submittedDate = Stationary.submitted_date__c;
                            Withdraw.requesterName = Stationary.requester_name_en__c;
                            Withdraw.completedBy = '-';
                            boolean pmsvNull = Stationary.pmsv__c.contains('null');
                            if(pmsvNull) {
                                Withdraw.completedBy = '-';
                            }
                            else {
                                Withdraw.completedBy = Stationary.pmsv__c;
                            }
                            Withdraw.completedDate = Stationary.completed_date__c;
                            Withdraw.currentStatus = Stationary.status__c;
                            withdraws.add(Withdraw);
                        }
                    }
                }   
            }
        }
        
        return withdraws;
    }
    
    //ใบกำกับภาษี (Invoice)
    @RemoteAction
    public static ESS_StationaryReport_DTO.DailyWithdrawHeaderDTO DailyWithdrawTaxInvoiceReport(ReportFilter filter) {
        
        ESS_StationaryReport_DTO.DailyWithdrawHeaderDTO result = new ESS_StationaryReport_DTO.DailyWithdrawHeaderDTO();
        ESS_Setting__c Config = [select id, TOPTBK_Tax__c, TOPTSR_Tax__c, TLB_Tax__c, TPX_Tax__c, TTC_Tax__c, TX_Tax__c, TES_Tax__c, 
                                LABIX_Tax__c, Other_Tax__c, TOP_SPP_Tax__c from ESS_Setting__c];
        
        ESS_StationaryReport_DTO.TaxDTO Tax = new ESS_StationaryReport_DTO.TaxDTO();
        
        //TOPTBK
        if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TOPTBK.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TOPTBK_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        }
        //TOPTSR
        if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TOPTSR.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TOPTSR_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        }
        //TLB
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TLB.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TLB_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        }
        //TPX
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TPX.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TPX_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        }
        //TTC
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TTC.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TTC_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        }
        //TX
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TX.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TX_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        }
        //TES
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TES.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TES_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        }
        //LABIX
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.LABIX.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.LABIX_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        } 
        //OTHER
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.OTHER.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.Other_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        } 
        //TOPSPP
        else if(filter.serviceFor == ESS_Enum.StationaryServiceFor.TOPSPP.name()) {
            Tax = (ESS_StationaryReport_DTO.TaxDTO)JSON.deserialize(Config.TOP_SPP_Tax__c, ESS_StationaryReport_DTO.TaxDTO.class);
        } 
        
        result.TaxInfo = Tax;
        result.DailyWithdrawItems = new List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        
        //Detail
        List<ESS_StationaryReport_DTO.DailyWithdrawDTO> withdraws = new List<ESS_StationaryReport_DTO.DailyWithdrawDTO>();
        string query = getStationaryDetailQuery();
        query += ' where document_no__c != null AND completed_date__c != null';
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        query += ' order by createddate desc';
        
        integer countRecord = 0;
        List<ESS_Stationary__c> Stationaries = database.query(query);
        
        Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO> mapWithdraws = new Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        ESS_StationaryReport_DTO.DailyWithdrawItemDTO WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
        
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                countRecord++;
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawStocks.size() > 0) {
                        for(integer j=0; j < withdrawStocks.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawStocks[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawStocks[j].name;
                            WithdrawItem.quantity = withdrawStocks[j].quantity;
                            WithdrawItem.pricePerUnit = withdrawStocks[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawStocks[j].totalPrice;
                            
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.stationaryName);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.stationaryName);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.stationaryName, WithdrawItem);
                            }
                            
                        }
                    }
                }
                 
                if(string.isNotBlank(Stationary.Withdraw_Other__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawOthers.size() > 0) {
                        for(integer j=0; j < withdrawOthers.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawOthers[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawOthers[j].name;
                            WithdrawItem.quantity = withdrawOthers[j].quantity;
                            WithdrawItem.pricePerUnit = withdrawOthers[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawOthers[j].totalPrice;
                            
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.stationaryName);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.stationaryName);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.stationaryName, WithdrawItem);
                            }
                        }
                    }
                }   
            }
            
            if(mapWithdraws.size() > 0) {
                for (string key : mapWithdraws.keySet()) {
                    ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw = mapWithdraws.get(key);
                    result.DailyWithdrawItems.add(withdraw);
                }   
                
                if(result.DailyWithdrawItems.size() > 0) {
                    //Sort by Stationary Id
            		ESS_StationaryReport_DTO.sortByStationaryId(result.DailyWithdrawItems);
                    integer count = 0;
                    for(ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw : result.DailyWithdrawItems) {
                        count++;
                        withdraw.orderNo = string.valueof(count);
                    } 
                }
            } 
        }
            
        return result;
    }
    
    //ใบเสนอราคา (PO)
    @RemoteAction
    public static ESS_StationaryReport_DTO.DailyWithdrawHeaderDTO DailyWithdrawTaxPOReport(ReportFilter filter) {
        
        ESS_StationaryReport_DTO.DailyWithdrawHeaderDTO result = new ESS_StationaryReport_DTO.DailyWithdrawHeaderDTO();
        
        result.TaxInfo = null;
        result.DailyWithdrawItems = new List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        
        //Detail
        List<ESS_StationaryReport_DTO.DailyWithdrawDTO> withdraws = new List<ESS_StationaryReport_DTO.DailyWithdrawDTO>();
        string query = getStationaryDetailQuery();
        query += ' where document_no__c != null AND completed_date__c != null';
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        query += ' order by createddate desc';
        
        integer countRecord = 0;
        List<ESS_Stationary__c> Stationaries = database.query(query);
        
        Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO> mapWithdraws = new Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        ESS_StationaryReport_DTO.DailyWithdrawItemDTO WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
        
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                countRecord++;
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawStocks.size() > 0) {
                        for(integer j=0; j < withdrawStocks.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawStocks[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawStocks[j].name;
                            WithdrawItem.quantity = withdrawStocks[j].quantity;
                            WithdrawItem.pricePerUnit = withdrawStocks[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawStocks[j].totalPrice;
                            
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.stationaryName);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.stationaryName);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.stationaryName, WithdrawItem);
                            }
                        }
                    }
                }
                 
                if(string.isNotBlank(Stationary.Withdraw_Other__c)) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawOthers.size() > 0) {
                        for(integer j=0; j < withdrawOthers.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawOthers[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawOthers[j].name;
                            WithdrawItem.quantity = withdrawOthers[j].quantity;
                            WithdrawItem.pricePerUnit = withdrawOthers[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawOthers[j].totalPrice;
                            
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.stationaryName);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.stationaryName);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.stationaryName, WithdrawItem);
                            }
                        }
                    }
                }   
            }
            
            if(mapWithdraws.size() > 0) {
                for (string key : mapWithdraws.keySet()) {
                    ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw = mapWithdraws.get(key);
                    result.DailyWithdrawItems.add(withdraw);
                }   
                
                if(result.DailyWithdrawItems.size() > 0) {
                   //Sort by Stationary Id
                    ESS_StationaryReport_DTO.sortByStationaryId(result.DailyWithdrawItems);
                    integer count = 0;
                    for(ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw : result.DailyWithdrawItems) {
                        count++;
                        withdraw.orderNo = string.valueof(count);
                    } 
                }
            }
        }
            
        return result;
    }
    
    //รายงานสรุปคำขอเบิกสินค้าในแต่ละวัน
    @RemoteAction
    public static integer DailyWithdrawReportCount(ReportFilter filter) {
        integer count = 0;
        string query = 'select name, withdraw_from_stock__c, withdraw_other__c from ESS_Stationary__c where document_no__c != null AND completed_date__c != null';
        
        boolean isGeneralProduct = false;
        boolean isOtherProduct = false;
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.productType)) {
                string productType = filter.productType.toLowerCase();
                if(productType == 'all') {
                    isGeneralProduct = true;
                    isOtherProduct = true;
                }
                else if(productType == ESS_Enum.StationaryType.General.name().toLowerCase()) {
                    isGeneralProduct = true;
                    isOtherProduct = false;
                }
                else if(productType == ESS_Enum.StationaryType.Other.name().toLowerCase()) {
                    isGeneralProduct = false;
                    isOtherProduct = true;
                }
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        List<ESS_Stationary__c> Stationaries = database.query(query);
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c) && isGeneralProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawStocks.size();
                }
                if(string.isNotBlank(Stationary.Withdraw_Other__c) && isOtherProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawOthers.size();
                }
            }
        }
        return count;
    }
    
    @RemoteAction
    public static List<ESS_StationaryReport_DTO.DailyWithdrawRequestDTO> DailyWithdrawReport(ReportFilter filter) {
            
        List<ESS_StationaryReport_DTO.DailyWithdrawRequestDTO> withdraws = new List<ESS_StationaryReport_DTO.DailyWithdrawRequestDTO>();
        
        integer totalRecord = DailyWithdrawReportCount(filter);
        
        string query = getStationaryDetailQuery();
        query += ' where (document_no__c != null AND completed_date__c != null)';
        
        boolean isGeneralProduct = false;
        boolean isOtherProduct = false;
        string withdrawFrom = '';
        string serviceFor = '';
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.productType)) {
                string productType = filter.productType.toLowerCase();
                if(productType == 'all') {
                    isGeneralProduct = true;
                    isOtherProduct = true;
                }
                else if(productType == ESS_Enum.StationaryType.General.name().toLowerCase()) {
                    isGeneralProduct = true;
                    isOtherProduct = false;
                }
                else if(productType == ESS_Enum.StationaryType.Other.name().toLowerCase()) {
                    isGeneralProduct = false;
                    isOtherProduct = true;
                }
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        query += ' order by completed_date__c asc';
        
        integer countRecord = 0;
        List<ESS_Stationary__c> Stationaries = database.query(query);
        system.debug('Stationaries : ' + Stationaries.size());
        Map<DateTime, ESS_StationaryReport_DTO.DailyWithdrawRequestDTO> mapWithdraws = new Map<DateTime, ESS_StationaryReport_DTO.DailyWithdrawRequestDTO>();
        ESS_StationaryReport_DTO.DailyWithdrawRequestDTO Withdraw = new ESS_StationaryReport_DTO.DailyWithdrawRequestDTO();
        
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                countRecord++;
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c) && isGeneralProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawStocks.size() > 0) {
                        for(integer j=0; j < withdrawStocks.size(); j++) {
                            Withdraw = new ESS_StationaryReport_DTO.DailyWithdrawRequestDTO();
                            Withdraw.withdrawDate = DateTime.newInstanceGmt(Stationary.Completed_Date__c.year(), Stationary.Completed_Date__c.month(), Stationary.Completed_Date__c.day());
                            Withdraw.withdrawFrom = withdrawFrom;
                            Withdraw.serviceFor = serviceFor;
                            Withdraw.total = Integer.ValueOf(withdrawStocks[j].actualWithdraw);
                            
                            boolean isContain = mapWithdraws.containsKey(Withdraw.withdrawDate);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawRequestDTO item = mapWithdraws.get(Withdraw.withdrawDate);
                                item.total += Integer.ValueOf(withdrawStocks[j].actualWithdraw);
                            }
                            else {
                                mapWithdraws.put(Withdraw.withdrawDate, Withdraw);
                            }
                        }
                    }
                }
                 
                if(string.isNotBlank(Stationary.Withdraw_Other__c) && isOtherProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawOthers.size() > 0) {
                        for(integer j=0; j < withdrawOthers.size(); j++) {
                            Withdraw = new ESS_StationaryReport_DTO.DailyWithdrawRequestDTO();
                            Withdraw.withdrawDate = DateTime.newInstanceGmt(Stationary.Completed_Date__c.year(), Stationary.Completed_Date__c.month(), Stationary.Completed_Date__c.day());
                            Withdraw.withdrawFrom = withdrawFrom;
                            Withdraw.serviceFor = serviceFor;
                            Withdraw.total = Integer.ValueOf(withdrawOthers[j].actualWithdraw);
                            
                            boolean isContain = mapWithdraws.containsKey(Withdraw.withdrawDate);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawRequestDTO item = mapWithdraws.get(Withdraw.withdrawDate);
                                item.total += Integer.ValueOf(withdrawOthers[j].actualWithdraw);
                            }
                            else {
                                mapWithdraws.put(Withdraw.withdrawDate, Withdraw);
                            }
                        }
                    }
                }    
            }
            
            if(mapWithdraws.size() > 0) {
                integer count = 0;
                for (datetime key : mapWithdraws.keySet()) {
                    ESS_StationaryReport_DTO.DailyWithdrawRequestDTO item = mapWithdraws.get(key);
                    count++;
                    item.orderNo = string.valueof(count);
                    withdraws.add(item);
                }   
            }
        }
        
        return withdraws;
    }
    
    //รายงานสรุปยอดการเบิกสินค้าโดยระบุชื่อตำแหน่งพนักงาน
    @RemoteAction
    public static integer RequesterWithdrawReportCount(ReportFilter filter) {
        integer count = 0;
        string query = 'select name, withdraw_from_stock__c, withdraw_other__c from ESS_Stationary__c where document_no__c != null AND completed_date__c != null';
        
        boolean isGeneralProduct = false;
        boolean isOtherProduct = false;
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.section)) {
                string section = filter.section;
                query += ' AND ((requester_section__c = :section AND on_behalf_of_flow__c = false) OR (on_behalf_of_section__c = :section AND on_behalf_of_flow__c = true))';
            }
            if (string.isNotBlank(filter.userId)) {
                string userId = filter.userId;
                query += ' AND ((requester_id__c = :userId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c = :userId AND on_behalf_of_flow__c = true))';
            }
            if (string.isNotBlank(filter.productType)) {
                string productType = filter.productType.toLowerCase();
                if(productType == 'all') {
                    isGeneralProduct = true;
                    isOtherProduct = true;
                }
                else if(productType == ESS_Enum.StationaryType.General.name().toLowerCase()) {
                    isGeneralProduct = true;
                    isOtherProduct = false;
                }
                else if(productType == ESS_Enum.StationaryType.Other.name().toLowerCase()) {
                    isGeneralProduct = false;
                    isOtherProduct = true;
                }
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        List<ESS_Stationary__c> Stationaries = database.query(query);
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c) && isGeneralProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawStocks.size();
                }
                if(string.isNotBlank(Stationary.Withdraw_Other__c) && isOtherProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawOthers.size();
                }
            }
        }
        return count;
    }
    
    @RemoteAction
    public static List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO> RequesterWithdrawReport(ReportFilter filter) {
        
        List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO> withdraws = new List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        
        Map<string,string> mapMasters = GetStationaryMasters();
        integer totalRecord = RequesterWithdrawReportCount(filter);
        
        string query = getStationaryDetailQuery();
        query += ' where document_no__c != null AND completed_date__c != null';
        
        boolean isGeneralProduct = false;
        boolean isOtherProduct = false;
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.section)) {
                string section = filter.section;
                query += ' AND ((requester_section__c = :section AND on_behalf_of_flow__c = false) OR (on_behalf_of_section__c = :section AND on_behalf_of_flow__c = true))';
            }
            if (string.isNotBlank(filter.userId)) {
                string userId = filter.userId;
                query += ' AND ((requester_id__c = :userId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c = :userId AND on_behalf_of_flow__c = true))';
            }
            if (string.isNotBlank(filter.productType)) {
                string productType = filter.productType.toLowerCase();
                if(productType == 'all') {
                    isGeneralProduct = true;
                    isOtherProduct = true;
                }
                else if(productType == ESS_Enum.StationaryType.General.name().toLowerCase()) {
                    isGeneralProduct = true;
                    isOtherProduct = false;
                }
                else if(productType == ESS_Enum.StationaryType.Other.name().toLowerCase()) {
                    isGeneralProduct = false;
                    isOtherProduct = true;
                }
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        query += ' order by createddate desc';
        
        integer countRecord = 0;
        List<ESS_Stationary__c> Stationaries = database.query(query);
        
        Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO> mapWithdraws = new Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        ESS_StationaryReport_DTO.DailyWithdrawItemDTO WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
        
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                countRecord++;
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c) && isGeneralProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawStocks.size() > 0) {
                        for(integer j=0; j < withdrawStocks.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawStocks[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawStocks[j].name;
                            WithdrawItem.quantity = Integer.ValueOf(withdrawStocks[j].actualWithdraw);
                            WithdrawItem.pricePerUnit = withdrawStocks[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawStocks[j].totalPrice;
                            
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.stationaryName);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.stationaryName);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.stationaryName, WithdrawItem);
                            }
                        }
                    }
                }
                 
                if(string.isNotBlank(Stationary.Withdraw_Other__c) && isOtherProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawOthers.size() > 0) {
                        for(integer j=0; j < withdrawOthers.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawOthers[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawOthers[j].name;
                            WithdrawItem.quantity = Integer.ValueOf(withdrawOthers[j].actualWithdraw);
                            WithdrawItem.pricePerUnit = withdrawOthers[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawOthers[j].totalPrice;
                            
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.stationaryName);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.stationaryName);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.stationaryName, WithdrawItem);
                            }
                        }
                    }
                }   
            }
            
            if(mapWithdraws.size() > 0) {
                for (string key : mapWithdraws.keySet()) {
                    ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw = mapWithdraws.get(key);
                    withdraws.add(withdraw);
                }   
                
                if(withdraws.size() > 0) {
                   //Sort by Stationary Id
                    ESS_StationaryReport_DTO.sortByStationaryId(withdraws);
                    integer count = 0;
                    for(ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw : withdraws) {
                        count++;
                        withdraw.orderNo = string.valueof(count);
                    } 
                }
            }
        }
         
        return withdraws;
    }
    
    //รายงานการเบิกจ่ายวัสดุของสินค้าแต่ละชนิด
    @RemoteAction
    public static integer WithdrawItemReportCount(ReportFilter filter) {
        
        integer count = 0;
        string query = 'select name, withdraw_from_stock__c, withdraw_other__c from ESS_Stationary__c where document_no__c != null AND completed_date__c != null';
        
        boolean isGeneralProduct = false;
        boolean isOtherProduct = false;
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.productType)) {
                string productType = filter.productType.toLowerCase();
                if(productType == 'all') {
                    isGeneralProduct = true;
                    isOtherProduct = true;
                }
                else if(productType == ESS_Enum.StationaryType.General.name().toLowerCase()) {
                    isGeneralProduct = true;
                    isOtherProduct = false;
                }
                else if(productType == ESS_Enum.StationaryType.Other.name().toLowerCase()) {
                    isGeneralProduct = false;
                    isOtherProduct = true;
                }
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        List<ESS_Stationary__c> Stationaries = database.query(query);
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c) && isGeneralProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawStocks.size();
                }
                if(string.isNotBlank(Stationary.Withdraw_Other__c) && isOtherProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    count += withdrawOthers.size();
                }
            }
        }
        return count;
    }
    
    @RemoteAction
    public static List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO> WithdrawItemReport(ReportFilter filter) {
        
        List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO> withdraws = new List<ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        
        Map<string,string> mapMasters = GetStationaryMasters();
        integer totalRecord = WithdrawItemReportCount(filter);
        
        string query = getStationaryDetailQuery();
        query += ' where document_no__c != null AND completed_date__c != null';
        
        boolean isGeneralProduct = false;
        boolean isOtherProduct = false;
        
        if (filter != null) {
            if (string.isNotBlank(filter.withdrawFrom)) {
                string withdrawFrom = filter.withdrawFrom;
                query += ' AND withdraw_from__c = :withdrawFrom';
            }
            if (string.isNotBlank(filter.serviceFor)) {
                string serviceFor = filter.serviceFor;
                query += ' AND service_for__c = :serviceFor';
            }
            if (string.isNotBlank(filter.productType)) {
                string productType = filter.productType.toLowerCase();
                if(productType == 'all') {
                    isGeneralProduct = true;
                    isOtherProduct = true;
                }
                else if(productType == ESS_Enum.StationaryType.General.name().toLowerCase()) {
                    isGeneralProduct = true;
                    isOtherProduct = false;
                }
                else if(productType == ESS_Enum.StationaryType.Other.name().toLowerCase()) {
                    isGeneralProduct = false;
                    isOtherProduct = true;
                }
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        query += ' order by createddate desc';
        
        integer countRecord = 0;
        List<ESS_Stationary__c> Stationaries = database.query(query);
        Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO> mapWithdraws = new Map<string, ESS_StationaryReport_DTO.DailyWithdrawItemDTO>();
        ESS_StationaryReport_DTO.DailyWithdrawItemDTO WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
        
        if(Stationaries.size() > 0) {
            for(ESS_Stationary__c Stationary : Stationaries) {
                countRecord++;
                if(string.isNotBlank(Stationary.Withdraw_From_Stock__c) && isGeneralProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawStocks.size() > 0) {
                        for(integer j=0; j < withdrawStocks.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawStocks[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawStocks[j].name;
                            WithdrawItem.quantity = Integer.ValueOf(withdrawStocks[j].actualWithdraw);
                            WithdrawItem.pricePerUnit = withdrawStocks[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawStocks[j].totalPrice;
                            if(string.isEmpty(WithdrawItem.stationaryId)) {
                                WithdrawItem.id = '-' + ':' + WithdrawItem.stationaryName + ':' + WithdrawItem.pricePerUnit;
                            }
                            else {
                                WithdrawItem.id = WithdrawItem.stationaryId + ':' + WithdrawItem.stationaryName + ':' + WithdrawItem.pricePerUnit;
                            }
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.id);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.id);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.id, WithdrawItem);
                            }
                        }
                    }
                }
                 
                if(string.isNotBlank(Stationary.Withdraw_Other__c) && isOtherProduct) {
                    List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(Stationary.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                    if(withdrawOthers.size() > 0) {
                        for(integer j=0; j < withdrawOthers.size(); j++) {
                            WithdrawItem = new ESS_StationaryReport_DTO.DailyWithdrawItemDTO();
                            WithdrawItem.stationaryId = withdrawOthers[j].stationaryId;
                            WithdrawItem.stationaryName = withdrawOthers[j].name;
                            WithdrawItem.quantity = Integer.ValueOf(withdrawOthers[j].actualWithdraw);
                            WithdrawItem.pricePerUnit = withdrawOthers[j].pricePerUnit;
                            WithdrawItem.totalPrice = withdrawOthers[j].totalPrice;
                            if(string.isEmpty(WithdrawItem.stationaryId)) {
                                WithdrawItem.id = '-' + ':' + WithdrawItem.stationaryName + ':' + WithdrawItem.pricePerUnit;
                            }
                            else {
                                WithdrawItem.id = WithdrawItem.stationaryId + ':' + WithdrawItem.stationaryName + ':' + WithdrawItem.pricePerUnit;
                            }
                            boolean isContain = mapWithdraws.containsKey(WithdrawItem.id);
                            if(isContain) {
                                ESS_StationaryReport_DTO.DailyWithdrawItemDTO item = mapWithdraws.get(WithdrawItem.id);
                                item.quantity += WithdrawItem.quantity;
                                item.totalPrice += WithdrawItem.totalPrice;
                            }
                            else {
                                mapWithdraws.put(WithdrawItem.id, WithdrawItem);
                            }
                        }
                    }
                }   
            }
            
            if(mapWithdraws.size() > 0) {
                for (string key : mapWithdraws.keySet()) {
                    ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw = mapWithdraws.get(key);
                    withdraws.add(withdraw);
                }   
                
                if(withdraws.size() > 0) {
                   //Sort by Stationary Id
                    ESS_StationaryReport_DTO.sortByStationaryId(withdraws);
                    integer count = 0;
                    for(ESS_StationaryReport_DTO.DailyWithdrawItemDTO withdraw : withdraws) {
                        count++;
                        withdraw.orderNo = string.valueof(count);
                    } 
                }
            }
        }
            
        return withdraws;
    }
    
    @RemoteAction
    public static List<string> AllSections(ESS_Stationary_DTO.SearchDTO search) {
        string searchSection = '%' + search.search + '%';
        List<string> sections = new List<string>();
        List<AggregateResult> PISUsers = [select sections__c from pisusers__c where active__c = true AND mainposition__c = true AND sections__c like :searchSection group by sections__c order by sections__c asc];
        if(PISUsers.size() > 0) {
        	for(AggregateResult  ar : PISUsers){  
                if(ar.get('sections__c') != null) {
                    sections.add(ar.get('sections__c').tostring());
                }
                else {
                    sections.add('');
                }
        	}
        }
        return sections;
    }
    
    @RemoteAction
    public static List<ESS_Stationary_DTO.SearchUserDTO> SearchUsers(ESS_Stationary_DTO.SearchDTO search) {
        string searchName = '%' + search.search + '%';
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //PISUsers
        string queryPIS = 'select id, user__c, employeeid__c, email__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c, EN_Fullname__c, OBJENFULLNAME__c, TH_Fullname__c, units__c, sections__c, DEPARTMENT__c, FUNCTION__c, ReportToUser__c, ReportToName__c, Level__c from PISUsers__c';
        queryPIS += ' where (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true';
        
        if(string.isNotEmpty(search.section)) {
            string section = search.section;
            queryPIS += ' AND sections__c = :section';
        }
        
        queryPIS += ' limit 100';
        
        PISUsers = database.query(queryPIS);
        
        List<ESS_Stationary_DTO.SearchUserDTO> SearchUsers = new List<ESS_Stationary_DTO.SearchUserDTO>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_Stationary_DTO.SearchUserDTO SearchUser = new ESS_Stationary_DTO.SearchUserDTO();
                SearchUser.userId = PISUser.User__c;
                SearchUser.displayName = PISUser.EMPLOYEEID__c + ' - ' + PISuser.EN_Fullname__c;
                SearchUser.employeeId = PISUser.EMPLOYEEID__c;
                SearchUser.employeeName = PISuser.EN_Fullname__c;
                SearchUser.employeeNameTH = PISUser.TH_Fullname__c;
                SearchUser.email = PISUser.EMAIL__c;
                SearchUser.position = PISUser.OBJENFULLNAME__c;
                SearchUser.unit = PISUser.UNITS__c;
                SearchUser.section = PISUser.SECTIONS__c;
                SearchUser.department = PISUser.DEPARTMENT__c;
                SearchUser.function = PISUser.FUNCTION__c;
                SearchUser.level = PISUser.LEVEL__c;
                SearchUser.userManagerId = PISUser.ReportToUser__c;
                SearchUser.userManagerName = PISUser.ReportToName__c;
                SearchUsers.add(SearchUser);
            }
        }
        
        return SearchUsers;
    }
    
    public class ReportFilter {
        @RemoteAction
        public string reportName {get;set;}
        @RemoteAction
        public string withdrawFrom {get;set;} //คลัง
        @RemoteAction
        public string serviceFor {get;set;} //เพื่อใช้ในบริษัท
        @RemoteAction
        public datetime startSubmittedDate {get;set;}
        @RemoteAction
        public datetime endSubmittedDate {get;set;}
        @RemoteAction
        public datetime startCompletedDate {get;set;}
        @RemoteAction
        public datetime endCompletedDate {get;set;}
        @RemoteAction
        public string no {get;set;} //เลขที่
        @RemoteAction
        public string poNo {get;set;} //PO Number
        @RemoteAction
        public string contractNo {get;set;} //Contract No
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string productType {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string userId {get;set;}
    }
    
    public static string getStationaryDetailQuery()
    {
        return 
        'SELECT Accepted_Date__c,Administrator_Email__c,Administrator_Name__c,Approved_Date__c,Attachment_Files__c,Attentiveness_Rating__c,' +
        'Comment__c,Completed_Date__c,CreatedDate,Document_No__c,Expertise_Rating__c,Fast_Rating__c,Id,Internal_No__c,LastActivityDate,' +
        'LastModifiedById,LastModifiedDate,Last_Updated_By__c,Last_Updated_Date__c,Location__c,Mobile_No__c,Name,On_Behalf_Flow__c,On_Behalf_Of_Department__c,' +
        'On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,On_Behalf_Of_Flow__c,On_Behalf_Of_Function__c,On_Behalf_Of_Id__c,On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,' +
        'On_Behalf_Of_Unit__c,On_Behalf_Of_Verifying__c,On_Behalf_Of__c,OwnerId,PMSV_Department__c,PMSV_Email__c,PMSV_Employee_Id__c,PMSV_Function__c,PMSV_Id__c,PMSV_Position__c,' +
        'PMSV_Section__c,PMSV_Unit__c,PMSV__c,Punctuality_Rating__c,Rating_Date__c,Rating_Score__c,Rejected_Date__c,Reject_Comment__c,Requester_Department__c,Requester_Email__c, Requester_Position__c,' +
        'Requester_Employee_Id__c,Requester_Function__c,Requester_Id__c,Requester_Name__c,Requester_Section__c,Requester_Tel_Mobile__c,Requester_Tel_Office__c,Requester_Unit__c,' +
        'Service_For__c,Status__c,Submitted_Date__c,Total_Other__c,Total_Stock__c,Total__c,Verified_Date__c,Withdraw_From_Stock__c,Withdraw_From__c,Withdraw_Other__c,Cancelled_Date__c,Cancel_Comment__c,' +
        'User_Manager_Id__c,User_Manager__c,User_Manager_Flow__c, PMSV_Comment__c, CC__c, CC_Email__c, Requester_Level__c, On_Behalf_Of_Level__c, CC_Level__c,Need_Date__c,Is_PRTR_Requester__c,' +
        'Attentiveness_Rating_2__c, Expertise_Rating_2__c, Fast_Rating_2__c, Punctuality_Rating_2__c, Rating_Date_2__c, Rating_Score_2__c,Verify_Comment__c,Approved_Comment__c,Requester_Name_EN__c,On_Behalf_Of_EN__c, Rejected_By__c,Approved_By__c,' +
        'Staff_Comment__c,User_Manager_EN__c, Verified_By__c, Cancelled_By__c, Accepted_By__c' +
        ' from ESS_Stationary__c';
    }
    
    @RemoteAction
    public static string ExportStationaryTrackingExcel(ReportFilter filter) {
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_Stationary_Tracking_Excel?';
        
        string reportName = filter.reportName;
        string serviceFor = filter.serviceFor;
        string withdrawFrom = filter.withdrawFrom;
        datetime startSubmittedDate = filter.startSubmittedDate;
        datetime endSubmittedDate = filter.endSubmittedDate;
        datetime startCompletedDate = filter.startCompletedDate;
        datetime endCompletedDate = filter.endCompletedDate;
                
        URL = URL + 'reportName=' + reportName + 
                    '&serviceFor=' + serviceFor;
        
        if(reportName == ESS_Enum.StationaryReport.DailyWithdrawTaxReport.name() || reportName == ESS_Enum.StationaryReport.WithdrawItemReport.name()) {
            URL +=  '&startCompletedDate=' + startCompletedDate + 
                    '&endCompletedDate=' + endCompletedDate;
        }
        else if(reportName == ESS_Enum.StationaryReport.DailyWithdrawReport.name() || reportName == ESS_Enum.StationaryReport.RequesterWithdrawReport.name()) {
            URL +=  '&startSubmittedDate=' + startSubmittedDate + 
                    '&endSubmittedDate=' + endSubmittedDate;
        }     
        
        return URL;
    }
    
    public static Map<string,string> GetStationaryMasters() {
        Map<string,string> mapMasters = new Map<string,string>();
        string query = 'select id, supplier__c from ESS_Master_Stationary__c where name != null';
        List<ESS_Master_Stationary__c> Masters = database.query(query);
        if(Masters.size() > 0) {
            for(ESS_Master_Stationary__c Master : Masters) {
                mapMasters.put(Master.Id, Master.supplier__c);
            }
        }
        return mapMasters;
    }
    
}