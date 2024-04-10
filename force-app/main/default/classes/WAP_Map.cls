/* 
 * Author Softever
 */

global with sharing class WAP_Map {

    private static WAP_DTO.HeaderMapDTO workMapHeader;
    private static WAP_DTO.TypeOfWorkCountDTO typeOfWorkCount;
    private static WAP_DTO.WorkMapDTO workMap;
    private static List<WAP_DTO.WorkMapDTO> workMaps;
    public static string googleAPIKey {get;set;}
    
    static {
    	getGoogleAPIKey();
    }
    
    public static void getGoogleAPIKey() {
        
        //Get google api key
        WAP_Config__c WAPConfig = [select google_api_key__c from WAP_Config__c];
        googleAPIKey = WAPConfig.google_api_key__c;
        
    }
    
    //Count all work
    @RemoteAction
    public static WAP_DTO.HeaderMapDTO GetWorkCount(MapSearchCriteria filter) {
        
        workMapHeader = new WAP_DTO.HeaderMapDTO();
        workMapHeader.totalClearanceCertificate = 0;
        workMapHeader.totalHighRiskWork = 0;
        workMapHeader.totalHotWork = 0;
        workMapHeader.totalSimop = 0;
        
        Date todayDate = system.today();
        Date startDate = system.today().addDays(-1);
		Time currentTime = datetime.now().time();
        
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        List<string> statuses = new List<string> { 'In Progress', 'Created' };
        string createdStatus = 'Created';
        string inProgressStatus = 'In Progress';
        
        string query = getWorkClearanceQuery();
        query += ' where Id != null';
        
        string userStatusWCCL = '%WCCL%';
        string userStatusWIP1 = '%WIP1%';
        
        if(filter.allStatus) {
            //Create status
            query += ' AND ((Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
            
            //In Progress status
            query += ' OR (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null)))';
        }
        else {
            if(filter.createdStatus) {
                //Create status
                query += ' AND (Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
            }
            if(filter.inProgressStatus) {
                //In Progress status
                query += ' AND (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null))';
            }
            if(!filter.createdStatus && !filter.inProgressStatus) {
                return workMapHeader;
			}
        }
        
        //filter.clearanceCertificateNo
        if(string.isNotEmpty(filter.clearanceCertificateNo)) {
            string clearanceNo = filter.clearanceCertificateNo;
            query += ' AND name =: clearanceNo';
        }
        
        //filter.areas
        if(filter.areas != null && filter.areas.size() > 0) {
            List<string> areas = new List<string>();
            areas = filter.areas;
            if(areas.size() > 0) {
                if(!Test.isRunningTest()) {
                    query += ' AND MPAC__c IN :areas';
                }
            }
        }
        else {
            return workMapHeader;
        }
        
        //filter.allTypeOfWork
        List<string> typeOfWorks = new List<string>();
        if(filter.allTypeOfWork) {
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); //General
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork)));  //Hot Work
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); //Confined Space
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); //Crane/Lifting
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); //Radiation
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); //Jack Hammer
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); // High Pressure Water Jet
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); //Digging
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh)));  //Work at High
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); //Online Stop Leak
            typeOfWorks.add(''); //Non Type Of Work
        }
        else {
            if(filter.generalWork) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); 
            }
            if(filter.hotWork) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork))); 
            }
            if(filter.confinedSpace) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); 
            }
            if(filter.craneLifting) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); 
            }
            if(filter.radiation) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); 
            }
            if(filter.jackHammer) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); 
            }
            if(filter.highPressureWaterJet) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); 
            }
            if(filter.digging) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); 
            }
            if(filter.workAtHeight) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh))); 
            }
            if(filter.onlineStopLeak) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); 
            }
            if(filter.nonTypeOfWork) {
                typeOfWorks.add(''); 
            }
        }
        
        query += ' AND High_Risk_Work__c IN: typeOfWorks order by name asc';
        WorkClearances = database.query(query);
        if(WorkClearances.size() > 0) {
            
            workMapHeader.totalClearanceCertificate = WorkClearances.size();
            
            for(Work_Clearance__c Work : WorkClearances) {
                
                if(string.isEmpty(Work.High_Risk_Work__c)) {
                    Work.High_Risk_Work__c = '10';
                }
                
                if(Work.High_Risk_Work__c != '0' && Work.High_Risk_Work__c != '10') {
                    workMapHeader.totalHighRiskWork += 1;
                }
                
                if(Work.High_Risk_Work__c == '1') {
        			workMapHeader.totalHotWork += 1;
                }
                
            }
                        
            string groupBy = 'select count(id) totalCount, latitude__c, longitude__c from Work_Clearance__c ' + 
                			'where Id != null';
               
            if(filter.allStatus) {
                //Create status
                groupBy += ' AND ((Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
                
                //In Progress status
                groupBy += ' OR (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null)))';
            }
            else {
                if(filter.createdStatus) {
                    //Create status
                    groupBy += ' AND (Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
                }
                if(filter.inProgressStatus) {
                    //In Progress status
                    groupBy += ' AND (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null))';
                }
            }
            
            //filter.clearanceCertificateNo
            if(string.isNotEmpty(filter.clearanceCertificateNo)) {
                string clearanceNo = filter.clearanceCertificateNo;
                groupBy += ' AND name =: clearanceNo';
            }
            
            //filter.areas
            if(filter.areas != null && filter.areas.size() > 0) {
                List<string> areas = new List<string>();
                areas = filter.areas;
                if(areas.size() > 0) {
                    if(!Test.isRunningTest()) {
                        groupBy += ' AND MPAC__c IN :areas';
                    }
                }
            }
            
            typeOfWorks = new List<string>();
            if(filter.allTypeOfWork) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); //General
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork)));  //Hot Work
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); //Confined Space
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); //Crane/Lifting
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); //Radiation
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); //Jack Hammer
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); // High Pressure Water Jet
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); //Digging
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh)));  //Work at High
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); //Online Stop Leak
                typeOfWorks.add(''); //Non Type Of Work
            }
            else {
                if(filter.generalWork) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); 
                }
                if(filter.hotWork) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork))); 
                }
                if(filter.confinedSpace) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); 
                }
                if(filter.craneLifting) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); 
                }
                if(filter.radiation) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); 
                }
                if(filter.jackHammer) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); 
                }
                if(filter.highPressureWaterJet) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); 
                }
                if(filter.digging) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); 
                }
                if(filter.workAtHeight) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh))); 
                }
                if(filter.onlineStopLeak) {
                    typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); 
                }
                if(filter.nonTypeOfWork) {
                    typeOfWorks.add(''); 
                }
            }
            
            groupBy += ' AND High_Risk_Work__c IN: typeOfWorks';
            groupBy += ' group by latitude__c, longitude__c';
            
            List<AggregateResult> GroupByARs = new List<AggregateResult>();
            GroupByARs = database.query(groupBy);
            if(GroupByARs.size() > 0) {
                for(AggregateResult AR : GroupByARs) {
                    integer arCount = Integer.ValueOf(AR.get('totalCount'));
                    if(arCount > 1) {
                        workMapHeader.totalSimop += arCount;
                    }
                }
            }
        }
        
        return workMapHeader;
        
    }
    
    //Count all work
    @RemoteAction
    public static WAP_DTO.TypeOfWorkCountDTO GetAllWorkCount(MapSearchCriteria filter) {
        
        Date todayDate = system.today();
        Date startDate = system.today().addDays(-1);
		Time currentTime = datetime.now().time();
        
        typeOfWorkCount = new WAP_DTO.TypeOfWorkCountDTO();
        typeOfWorkCount.allCount = 0;
        typeOfWorkCount.generalCount = 0;
        typeOfWorkCount.hotWorkCount = 0;
        typeOfWorkCount.confinedSpaceCount = 0;
        typeOfWorkCount.craneCount = 0;
        typeOfWorkCount.radiationCount = 0;
        typeOfWorkCount.jackHammerCount = 0;
        typeOfWorkCount.highPressureWaterJetCount = 0;
        typeOfWorkCount.diggingCount = 0;
        typeOfWorkCount.workAtHeightCount = 0;
        typeOfWorkCount.onlineStopLeakCount = 0;
        typeOfWorkCount.nonTypeOfWorkCount = 0;
        
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        List<string> statuses = new List<string> { 'In Progress', 'Created' };
        string createdStatus = 'Created';
        string inProgressStatus = 'In Progress';
        
        string query = getWorkClearanceQuery();
        query += ' where Id != null';
           
        string userStatusWCCL = '%WCCL%';
        string userStatusWIP1 = '%WIP1%';
        
        if(filter.allStatus) {
            //Create status
            query += ' AND ((Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
            
            //In Progress status
            query += ' OR (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null)))';
        }
        else {
            if(filter.createdStatus) {
                //Create status
                query += ' AND (Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
            }
            if(filter.inProgressStatus) {
                //In Progress status
                query += ' AND (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null))';
            }
            if(!filter.createdStatus && !filter.inProgressStatus) {
                return typeOfWorkCount;
			}
        }
        
        //filter.clearanceCertificateNo
        if(string.isNotEmpty(filter.clearanceCertificateNo)) {
            string clearanceNo = filter.clearanceCertificateNo;
            query = query + ' AND name =: clearanceNo';
        }
        
        //filter.areas
        if(filter.areas != null && filter.areas.size() > 0) {
            List<string> areas = new List<string>();
            areas = filter.areas;
            if(areas.size() > 0) {
                if(!Test.isRunningTest()) {
                    query += ' AND MPAC__c IN :areas';
                }
            }
        }
        else {
            return typeOfWorkCount;
        }

        //filter.allTypeOfWork
        List<string> typeOfWorks = new List<string>();
        if(filter.allTypeOfWork) {
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); //General
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork)));  //Hot Work
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); //Confined Space
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); //Crane/Lifting
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); //Radiation
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); //Jack Hammer
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); // High Pressure Water Jet
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); //Digging
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh)));  //Work at High
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); //Online Stop Leak
            typeOfWorks.add(''); //Non Type Of Work
        }
        else {
            if(filter.generalWork) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); 
            }
            if(filter.hotWork) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork))); 
            }
            if(filter.confinedSpace) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); 
            }
            if(filter.craneLifting) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); 
            }
            if(filter.radiation) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); 
            }
            if(filter.jackHammer) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); 
            }
            if(filter.highPressureWaterJet) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); 
            }
            if(filter.digging) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); 
            }
            if(filter.workAtHeight) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh))); 
            }
            if(filter.onlineStopLeak) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); 
            }
            if(filter.nonTypeOfWork) {
                typeOfWorks.add(''); 
            }
        }
        
        query = query + ' AND High_Risk_Work__c IN: typeOfWorks order by name asc';
        
        WorkClearances = database.query(query);
        
        if(WorkClearances.size() > 0) {
            
            for(Work_Clearance__c Work : WorkClearances) {
                
                if(string.isEmpty(Work.High_Risk_Work__c)) {
                    //Work.High_Risk_Work__c = '10';
                    typeOfWorkCount.nonTypeOfWorkCount += 1;
                }
                
                if(Work.High_Risk_Work__c == '0') {
                    typeOfWorkCount.generalCount += 1;
                }
                else if(Work.High_Risk_Work__c == '1') {
        			typeOfWorkCount.hotWorkCount += 1;
                }
                else if(Work.High_Risk_Work__c == '2') {
        			typeOfWorkCount.confinedSpaceCount += 1;
                }
                else if(Work.High_Risk_Work__c == '3') {
        			typeOfWorkCount.craneCount += 1;
                }
                else if(Work.High_Risk_Work__c == '4') {
        			typeOfWorkCount.radiationCount += 1;
                }
                else if(Work.High_Risk_Work__c == '5') {
        			typeOfWorkCount.jackHammerCount += 1;
                }
                else if(Work.High_Risk_Work__c == '6') {
        			typeOfWorkCount.highPressureWaterJetCount += 1;
                }
                else if(Work.High_Risk_Work__c == '7') {
        			typeOfWorkCount.diggingCount += 1;
                }
                else if(Work.High_Risk_Work__c == '8') {
        			typeOfWorkCount.workAtHeightCount += 1;
                }
                else if(Work.High_Risk_Work__c == '9') {
        			typeOfWorkCount.onlineStopLeakCount += 1;
                }
                
            }
            
        }
        
        typeOfWorkCount.allCount = typeOfWorkCount.nonTypeOfWorkCount + typeOfWorkCount.generalCount + typeOfWorkCount.hotWorkCount + 
            						typeOfWorkCount.confinedSpaceCount + typeOfWorkCount.craneCount + typeOfWorkCount.radiationCount +
            						typeOfWorkCount.jackHammerCount + typeOfWorkCount.highPressureWaterJetCount + typeOfWorkCount.diggingCount + 
            						typeOfWorkCount.workAtHeightCount + typeOfWorkCount.onlineStopLeakCount;
        
        return typeOfWorkCount;
        
    }
    
    //Query All Map Work
    @RemoteAction
    public static List<WAP_DTO.WorkMapDTO> GetWorkMaps(MapSearchCriteria filter) {

        Date todayDate = system.today();
        Date startDate = system.today().addDays(-1);
		Time currentTime = datetime.now().time();
        
        workMaps = new List<WAP_DTO.WorkMapDTO>();
        
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        List<string> statuses = new List<string> { 'In Progress', 'Created' };
        string createdStatus = 'Created';
        string inProgressStatus = 'In Progress';
        
        string query = getWorkClearanceQuery();
        query += ' where Id != null';
            
        string userStatusWCCL = '%WCCL%';
        string userStatusWIP1 = '%WIP1%';
        
        if(filter.allStatus) {
            //Create status
            query += ' AND ((Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
            
            //In Progress status
            query += ' OR (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null)))';
        }
        else {
            if(filter.createdStatus) {
                //Create status
            	query += ' AND (Work_Clearance_Status__c = :createdStatus AND (DAY_ONLY(LastModifiedDate) >= :startDate AND DAY_ONLY(LastModifiedDate) <= :todayDate))';
            }
            if(filter.inProgressStatus) {
                //In Progress status
                query += ' AND (Work_Clearance_Status__c = :inProgressStatus AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime AND (Close_Applicant_or_Bearer_UI__c = null OR Close_Authorized_Sign_off_UI__c = null))';
            }
            if(!filter.createdStatus && !filter.inProgressStatus) {
                return workMaps;
			}
        }
        
        //filter.clearanceCertificateNo
        if(string.isNotEmpty(filter.clearanceCertificateNo)) {
            string clearanceNo = filter.clearanceCertificateNo;
            query = query + ' AND name =: clearanceNo';
        }
        
        //filter.areas
        if(filter.areas != null && filter.areas.size() > 0) {
            List<string> areas = new List<string>();
            areas = filter.areas;
            if(areas.size() > 0) {
                if(!Test.isRunningTest()) {
                    query += ' AND MPAC__c IN :areas';
                }
            }
        }
        else {
            return workMaps;
        }

        //filter.allTypeOfWork
        List<string> typeOfWorks = new List<string>();
        if(filter.allTypeOfWork) {
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); //General
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork)));  //Hot Work
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); //Confined Space
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); //Crane/Lifting
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); //Radiation
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); //Jack Hammer
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); // High Pressure Water Jet
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); //Digging
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh)));  //Work at High
            typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); //Online Stop Leak
            typeOfWorks.add(''); //Non Type Of Work
        }
        else {
            if(filter.generalWork) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.General))); 
            }
            if(filter.hotWork) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork))); 
            }
            if(filter.confinedSpace) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace))); 
            }
            if(filter.craneLifting) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Crane))); 
            }
            if(filter.radiation) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation))); 
            }
            if(filter.jackHammer) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer))); 
            }
            if(filter.highPressureWaterJet) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet))); 
            }
            if(filter.digging) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.Digging))); 
            }
            if(filter.workAtHeight) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh))); 
            }
            if(filter.onlineStopLeak) {
                typeOfWorks.add(assignHighRiskWorkType(String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak))); 
            }
            if(filter.nonTypeOfWork) {
                typeOfWorks.add(''); 
            }
        }
        
        query = query + ' AND High_Risk_Work__c IN: typeOfWorks order by name asc';
        
        WorkClearances = database.query(query);
        if(WorkClearances.size() > 0) {
            
        	Map<Id, PTW_Header__c> mapPTWHeaders = WAP_Global.assignToAllPTWHeaders();
            Map<Id, PISUsers__c> mapPISUsers = WAP_Global.assignToAllPISUsers();
            
            for(Work_Clearance__c Work : WorkClearances) {
                workMaps.add(assignToWorkMapDTO(Work, mapPTWHeaders, mapPISUsers));
            }
            
        }
        
        return workMaps;
        
        
    }
    
    @RemoteAction
    public static WAP_DTO.WorkMapDTO UpdateWorkClearanceMapLatLong(string recordId, string latitude, string longitude) {
        
        workMap = new WAP_DTO.WorkMapDTO();
        Work_Clearance__c WC = new Work_Clearance__c();
        
        string query = getWorkClearanceQuery();
        query += ' where Id =: recordId';
            
        WC = database.query(query);
        
        WC.Longitude__c = longitude;
        WC.Latitude__c = latitude;
        database.update(WC, true);
        
        Map<Id, PTW_Header__c> mapPTWHeaders = new Map<Id, PTW_Header__c>();
        Map<Id, PISUsers__c> mapPISUsers = WAP_Global.assignToAllPISUsers();
        workMap = assignToWorkMapDTO(WC, mapPTWHeaders, mapPISUsers);
        
        return workMap;
    }
    
    //Get Work
    @RemoteAction
    public static WAP_DTO.WorkMapDTO GetWorkDetail(string clearanceNo) {
        
        Date todayDate = system.today();
		Time currentTime = datetime.now().time();
        
        workMap = new WAP_DTO.WorkMapDTO();
        
        List<Work_Clearance__c> WCs = new List<Work_Clearance__c>();
        
        string query = getWorkClearanceQuery();
        query += ' where name =: clearanceNo AND Authorized_Date_UI__c =: todayDate AND Authorized_Time_UI__c <=: currentTime';
        
        WCs = database.query(query);
        
        if(WCs.size() > 0) {
            Map<Id, PTW_Header__c> mapPTWHeaders = new Map<Id, PTW_Header__c>();
        	Map<Id, PISUsers__c> mapPISUsers = WAP_Global.assignToAllPISUsers();
            workMap = assignToWorkMapDTO(WCs[0], mapPTWHeaders, mapPISUsers);
        }
        
        return workMap;
    }
    
    //Get All Areas
    @RemoteAction
    public static Set<string> GetAreas(MapSearchCriteria filter) {
        
        Set<string> Areas = new Set<string>();
        
        Areas.add(WAP_Enum.Areas.TLB.name());
        Areas.add(WAP_Enum.Areas.TPX.name());
        Areas.add(WAP_Enum.Areas.LABIX.name());
        Areas.add(WAP_Enum.Areas.SPP.name());
        Areas.add(WAP_Enum.Areas.TOC1.name());
        Areas.add(WAP_Enum.Areas.TOC2.name());
        Areas.add(WAP_Enum.Areas.TOC3.name());
        Areas.add(WAP_Enum.Areas.TOC4.name());
        Areas.add(WAP_Enum.Areas.TOC5.name());
        Areas.add(WAP_Enum.Areas.UTILITY.name());
        Areas.add(WAP_Enum.Areas.MOVEMENT.name());
        Areas.add(WAP_Enum.Areas.OFFSITE.name());
        Areas.add(WAP_Enum.Areas.CFP.name());
        
        return Areas;
        
    }
    
    //assign DTO
    private static WAP_DTO.WorkMapDTO assignToWorkMapDTO(Work_Clearance__c WC, Map<Id, PTW_Header__c> PTWHeaders, Map<Id, PISUsers__c> mapPISUsers) {
        
        WAP_DTO.WorkMapDTO WorkMap = new WAP_DTO.WorkMapDTO();
        WorkMap.id = WC.Id;
        
        WorkMap.name = WC.Name;
        
        if(string.isNotEmpty(WC.Extend_No__c)) {
            WorkMap.name += '/' + WC.Extend_No__c;
        }
        
        WorkMap.link = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/cmp/c__ODM_WorkClearanceRecordDisplay?c__recordId=' + WC.Id;
        
        if(string.isNotEmpty(WC.Latitude__c)) {
            WorkMap.latitude = WC.Latitude__c;
            WorkMap.longitude = WC.Longitude__c;
        	WorkMap.description = WC.FunctionalLocation__r.Description__c;
            
            if(string.isEmpty(WC.Latitude__c)) {
                WorkMap.latitude = '13.111560';
                WorkMap.longitude = '100.881583';
                WorkMap.description = '';
            }
            
        }
        else {
            
            //Default Latitude Longitude for non FunctionalLocation
            WorkMap.latitude = '13.111560';
            WorkMap.longitude = '100.881583';
            WorkMap.description = '';
            
        }
        
        WorkMap.workClearanceStatus = new WAP_Global.EnumValue('WorkClearanceStatus');
        if(WC.Work_Clearance_Status__c == 'Created') {
            WorkMap.workClearanceStatus.key = String.ValueOf(WAP_Enum.WorkClearanceStatus.Created);
        	WorkMap.workClearanceStatus.value = WC.Work_Clearance_Status__c;
        }
        else if(WC.Work_Clearance_Status__c == 'In Progress') {
            WorkMap.workClearanceStatus.key = String.ValueOf(WAP_Enum.WorkClearanceStatus.InProgress);
        	WorkMap.workClearanceStatus.value = WC.Work_Clearance_Status__c;
        }
        
        //Check from PTW Header
        //PTW_Header__c PTWHeader = CheckPTWHeader(WC.Id, PTWHeaders);
        if(PTWHeaders.size() > 0) {
            PTW_Header__c PTWHeader = PTWHeaders.get(WC.Id);
            if(PTWHeader != null && string.isNotEmpty(PTWHeader.Status__c)) {
                if(PTWHeader.Status__c == 'หยุดงานชั่วคราว') {
                    WorkMap.workClearanceStatus.key = String.ValueOf(WAP_Enum.WorkClearanceStatus.Suspend);
                    WorkMap.workClearanceStatus.value = String.ValueOf(WAP_Enum.WorkClearanceStatus.Suspend);
                    if(string.isEmpty(WorkMap.latitude)) {
                        //WorkMap.latitude = '13.111560';
                        //WorkMap.longitude = '100.898288';
                    }
                }
            }
        }
        
        WorkMap.userStatus = new WAP_Global.EnumValue('UserStatus');
        WorkMap.userStatus.key = WC.User_Status__c;
        WorkMap.userStatus.value = WC.User_Status__c;
        
        WorkMap.highRiskWork = new WAP_Global.EnumValue('HighRiskWorkType');
        if(WC.High_Risk_Work__c == '0') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.General);
            WorkMap.highRiskWork.value = 'General';
        }
        else if(WC.High_Risk_Work__c == '1') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork);
            WorkMap.highRiskWork.value = 'Hot Work';
        }
        else if(WC.High_Risk_Work__c == '2') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace);
            WorkMap.highRiskWork.value = 'Confined Space';
        }
        else if(WC.High_Risk_Work__c == '3') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.Crane);
            WorkMap.highRiskWork.value = 'Crane';
        }
        else if(WC.High_Risk_Work__c == '4') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation);
            WorkMap.highRiskWork.value = 'Radiation';
        }
        else if(WC.High_Risk_Work__c == '5') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer);
            WorkMap.highRiskWork.value = 'Jack Hammer';
        }
        else if(WC.High_Risk_Work__c == '6') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet);
            WorkMap.highRiskWork.value = 'High Pressure Water Jet';
        }
        else if(WC.High_Risk_Work__c == '7') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.Digging);
            WorkMap.highRiskWork.value = 'Digging';
        }        
        else if(WC.High_Risk_Work__c == '8') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh);
            WorkMap.highRiskWork.value = 'Work At High';
        }
        else if(WC.High_Risk_Work__c == '9') {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak);
            WorkMap.highRiskWork.value = 'Online Stop Leak';
        }
        else if(WC.High_Risk_Work__c == '' || WC.High_Risk_Work__c == null) {
            WorkMap.highRiskWork.key = String.ValueOf(WAP_Enum.HighRiskWorkType.NonTypeOfWork);
            WorkMap.highRiskWork.value = 'Non Type Of Work';
        }
        
        WorkMap.mainWorkCenterText = '';
        if(string.isNotEmpty(WC.Area__c)) {
        	WorkMap.mainWorkCenterText = WC.Area__c;
        }
        
        WorkMap.workDetail = '';
        if(string.isNotEmpty(WC.Work_Detail__c)) {
            WorkMap.workDetail = WC.Work_Detail__c;
        }
        
        WorkMap.safetyPermit1 = '';
        WorkMap.safetyPermit2 = '';
        WorkMap.safetyPermit3 = '';
        
        if(string.isNotEmpty(WC.Safety_Permit1_UI__c)) {
            WorkMap.safetyPermit1 = WC.Safety_Permit1_UI__r.Name;
        }
        if(string.isNotEmpty(WC.Safety_Permit2_UI__c)) {
            WorkMap.safetyPermit2 = WC.Safety_Permit2_UI__r.Name;
        }
        if(string.isNotEmpty(WC.Safety_Permit3_UI__c)) {
            WorkMap.safetyPermit3 = WC.Safety_Permit3_UI__r.Name;
        }
        
        WorkMap.isCheckingGas = WC.IsCheckingGas__c;
        
        if(string.isNotEmpty(WC.Flamable_amt__c)) {
            WorkMap.flamableAmt = Decimal.ValueOf(WC.Flamable_amt__c);
        }
        if(string.isNotEmpty(WC.Oxygen_amt__c)) {
       		WorkMap.oxygenAmt = Decimal.ValueOf(WC.Oxygen_amt__c);
        }
        if(string.isNotEmpty(WC.Toxic_PPM__c)) {
        	WorkMap.toxicPPM = Decimal.ValueOf(WC.Toxic_PPM__c);
        }
        
        WorkMap.agtUI = '';
        if(string.isNotEmpty(WC.AGT_UI__c)) {
            PISUsers__c AGTUI = new PISUsers__c();            
            if(mapPISUsers.size() > 0) {
                if(WC.AGT_UI__c != null) {
                    AGTUI = mapPISUsers.get(WC.AGT_UI__c);
                    if(AGTUI != null) {
                        WorkMap.agtUI = AGTUI.EN_Fullname__c;  
                    }                	
                }
            }
        }
        
        WorkMap.checkDateUI = WC.Check_Date_UI__c;
        WorkMap.checkTimeUI = WC.Check_Time_UI__c;
        
        WorkMap.authorizedSignatoryUI = '';
        if(string.isNotEmpty(WC.Authorized_Signatory_UI__c)) {
            PISUsers__c authorizedSignatory = new PISUsers__c();            
            if(mapPISUsers.size() > 0) {
                if(WC.Authorized_Signatory_UI__c != null) {
                    authorizedSignatory = mapPISUsers.get(WC.Authorized_Signatory_UI__c);
                    if(authorizedSignatory != null) {
                        WorkMap.authorizedSignatoryUI = authorizedSignatory.EN_Fullname__c; 
                    }
                }
            }
        }
        
        WorkMap.authorizedDateUI = WC.Authorized_Date_UI__c;
        WorkMap.authorizedTimeUI = WC.Authorized_Time_UI__c;
        
        WorkMap.extendTimeFlagFormula = WC.Extend_Time_Flag_Formula__c;
        WorkMap.extendDate = WC.Extend_Date__c;
        WorkMap.extendTime = WC.Extend_Time__c;
        WorkMap.extendTimeToUI = WC.Extend_Time_To_UI__c;
        
        WorkMap.extendApplicantOrBearerUI = '';
        if(string.isNotEmpty(WC.Extend_Applicant_or_Bearer_UI__c)) {
            PISUsers__c ExtendApplicantOrBearerUI = new PISUsers__c();            
            if(mapPISUsers.size() > 0) {
                if(WC.Extend_Applicant_or_Bearer_UI__c != null) {
                    ExtendApplicantOrBearerUI = mapPISUsers.get(WC.Extend_Applicant_or_Bearer_UI__c);
                    if(ExtendApplicantOrBearerUI != null) {
                        WorkMap.extendApplicantOrBearerUI = ExtendApplicantOrBearerUI.EN_Fullname__c;
                    }
                }
            }
        }
        
        WorkMap.extendAuthorizedSignUI = '';
        if(string.isNotEmpty(WC.Extend_Authorized_Sign_UI__c)) {
            PISUsers__c ExtendAuthorizedSignUI = new PISUsers__c();            
            if(mapPISUsers.size() > 0) {
                if(WC.Extend_Authorized_Sign_UI__c != null) {
                    ExtendAuthorizedSignUI = mapPISUsers.get(WC.Extend_Authorized_Sign_UI__c);
                    if(ExtendAuthorizedSignUI != null) {
                        WorkMap.extendAuthorizedSignUI = ExtendAuthorizedSignUI.EN_Fullname__c;
                    }
                }
            }
        }
        
        WorkMap.closeApplicantOrBearerUI = '';
        if(string.isNotEmpty(WC.Close_Applicant_or_Bearer_UI__c)) {
            WorkMap.closeApplicantOrBearerUI = WC.Close_Applicant_or_Bearer_UI__c;
            PISUsers__c CloseApplicantOrBearerUI = new PISUsers__c();            
            if(mapPISUsers.size() > 0) {
                CloseApplicantOrBearerUI = mapPISUsers.get(WC.Close_Applicant_or_Bearer_UI__c);
                if(CloseApplicantOrBearerUI != null) {
                    WorkMap.closeApplicantOrBearerUI = CloseApplicantOrBearerUI.EN_Fullname__c;
                }
            }
        }
        
        WorkMap.closeAuthorizedSignOffUI = '';
        if(string.isNotEmpty(WC.Close_Authorized_Sign_off_UI__c)) {
            PISUsers__c CloseAuthorizedSignOffUI = new PISUsers__c();            
            if(mapPISUsers.size() > 0) {
                CloseAuthorizedSignOffUI = mapPISUsers.get(WC.Close_Authorized_Sign_off_UI__c);
                if(CloseAuthorizedSignOffUI != null) {
                    WorkMap.closeAuthorizedSignOffUI = CloseAuthorizedSignOffUI.EN_Fullname__c;
                }
            }
        }
        
        return WorkMap;
        
    }
    
    public static PTW_Header__c CheckPTWHeader(string workClearanceId, List<PTW_Header__c> PTWHeaders) {
        
        PTW_Header__c existPTWHeader = new PTW_Header__c();
        if(PTWHeaders.size() > 0) {
            for(PTW_Header__c PTW : PTWHeaders) {
                if(PTW.Work_Clearance__c == workClearanceId) {
                    existPTWHeader = PTW;
                    break;
                }
            }
        }
        
        return existPTWHeader;
    }
    
    public static string assignHighRiskWorkType(string workType) {
        
        string workTypeNo = '0';
        
        if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.General)) {
            workTypeNo = '0';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.HotWork)) {
            workTypeNo = '1';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.ConfinedSpace)) {
            workTypeNo = '2';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.Crane)) {
            workTypeNo = '3';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.Radiation)) {
            workTypeNo = '4';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.JackHammer)) {
            workTypeNo = '5';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.HighPressureWaterJet)) {
            workTypeNo = '6';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.Digging)) {
            workTypeNo = '7';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.WorkAtHigh)) {
            workTypeNo = '8';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.OnlineStopLeak)) {
            workTypeNo = '9';
        }
        else if(workType == String.ValueOf(WAP_Enum.HighRiskWorkType.NonTypeOfWork)) {
            workTypeNo = '10';
        }
        
        return workTypeNo;
        
    }
    
    public static string getWorkClearanceQuery() {
    	string query = 'select id, name, Area__c, Functional_Location__c, FunctionalLocation__c, FunctionalLocation__r.Latitude__c, FunctionalLocation__r.Longitude__c, ' + 
            			'FunctionalLocation__r.Description__c, User_Status__c, High_Risk_Work__c, Main_Work_Center_Text__c, Work_Detail__c, Latitude__c, Longitude__c, ' +
            			'Safety_Permit1__c, Safety_Permit1_UI__c, Safety_Permit1_UI__r.Name, Safety_Permit2__c, Safety_Permit2_UI__c, Safety_Permit2_UI__r.Name, Safety_Permit3__c, Safety_Permit3_UI__c, Safety_Permit3_UI__r.Name, IsCheckingGas__c, Flamable_amt__c, Oxygen_amt__c, Toxic_PPM__c, ' +
            			'AGT_UI__c, Check_Date_UI__c, Check_Time_UI__c, Authorized_Signatory_UI__c, Authorized_Date_UI__c, Authorized_Time_UI__c, ' + 
            			'Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, Extend_Time_To_UI__c, Extend_Applicant_or_Bearer_UI__c, MaintenancePlantText__c, Area_Code__c, MPAC__c,' +
            			'Extend_Authorized_Sign_UI__c, Close_Applicant_or_Bearer_UI__c, Close_Authorized_Sign_off_UI__c, Work_Clearance_Status__c, Plant_Section__c, Extend_No__c, Close_Applicant_or_Bearer__c ' +
            			'from Work_Clearance__c'; 
        return query;
    }
    
    public class MapSearchCriteria {
        @RemoteAction
        public string clearanceCertificateNo {get;set;}
        @RemoteAction
        public List<string> areas {get;set;}
        @RemoteAction
        public boolean allTypeOfWork {get;set;}
        @RemoteAction
        public boolean generalWork {get;set;}
        @RemoteAction
        public boolean hotWork {get;set;}
        @RemoteAction
        public boolean confinedSpace {get;set;}
        @RemoteAction
        public boolean craneLifting {get;set;}
        @RemoteAction
        public boolean radiation {get;set;}
        @RemoteAction
        public boolean jackHammer {get;set;}
        @RemoteAction
        public boolean highPressureWaterJet {get;set;}
        @RemoteAction
        public boolean digging {get;set;}
        @RemoteAction
        public boolean workAtHeight {get;set;}
        @RemoteAction
        public boolean onlineStopLeak {get;set;}
        @RemoteAction
        public boolean nonTypeOfWork {get;set;}
        @RemoteAction
        public boolean allStatus {get;set;}
        @RemoteAction
        public boolean createdStatus {get;set;}
        @RemoteAction
        public boolean inProgressStatus {get;set;}
    }
}