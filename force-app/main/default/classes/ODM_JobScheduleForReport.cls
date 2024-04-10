public class ODM_JobScheduleForReport implements Schedulable  {
     //public class ODM_JobScheduleForReport   {
    
        public void execute(SchedulableContext ctx) {
         //public void execute() {

            /** Delete Record before query */
            delete [SELECT id FROM PTW_Inspection_Report__c WHERE CreatedDate = THIS_YEAR];
            
            /** Daily sum Work_Clearance__c + Main_Work_Center__c*/
            AggregateResult[] groupedResultsWC = [

                SELECT COUNT(Id), 
                Authorized_Signature_UI__r.User__r.Main_Work_Center__c mainwork, 
                CALENDAR_YEAR(CreatedDate) Year, 
                CALENDAR_MONTH(CreatedDate) Month
                FROM Work_Clearance__c 
                WHERE CreatedDate = THIS_YEAR AND Work_Clearance_Status__c != 'Created' AND Authorized_Signature__c != null
                GROUP BY CALENDAR_YEAR(CreatedDate), CALENDAR_MONTH(CreatedDate), Authorized_Signature_UI__r.User__r.Main_Work_Center__c
                ORDER BY CALENDAR_YEAR(CreatedDate), CALENDAR_MONTH(CreatedDate)
            ]; 
            //list report wc
            List<PTW_Inspection_Report__c> listReport = new List<PTW_Inspection_Report__c>();
            Integer totalNumberOfWC = 0;
            for (AggregateResult ar : groupedResultsWC)  {
                Integer numberOfWC = 0;

                /** Setup format date */
                Integer year = Integer.valueOf(ar.get('Year'));
                Integer month = Integer.valueOf(ar.get('Month'));
                Integer day = 1;
                Date dt = Date.newInstance(year, month, day);
// String dateStr = dt.format('dd/MM/yyyy');
// System.debug('COUNT(Id)' + ar.get('expr0'));
// System.debug('Main_Work_Center__c ' + ar.get('mainwork'));
    
                PTW_Inspection_Report__c report = new PTW_Inspection_Report__c();
                numberOfWC = Integer.valueOf(ar.get('expr0'));
                totalNumberOfWC += numberOfWC;
//WC Created Date on the same date as CreatedDate //report.WC_Created_Date__c =  Date.today().addDays(-1);
                report.WC_Created_Date__c = Date.valueOf(dt); /** Date.valueOf(ar.get('WC_Created_Date__c')).addDays(-1);*/
                report.Main_Work_Center_Work_Clearances__c = String.valueof(ar.get('mainwork'));
                report.Number_of_Work_Clearances__c =  Integer.valueOf(ar.get('expr0'));
                
                listReport.add(report);
            }
            
/** Daily sum PTW_Header__c Inspection + Daily sum PTW_Header__c Verification + Main_Work_Center__c + status of ptw type=inpec + section(PISUser)*/
            AggregateResult[] groupedResultsPTW = [

                SELECT COUNT(Id), 
                RecordType.Name recordTypeName, 
                Auditor_Name__r.User__r.Main_Work_Center__c mainwork, 
                Status__c status, Auditor_Name__r.SECTIONS__c section,
                CALENDAR_YEAR(CreatedDate) Year, 
                CALENDAR_MONTH(CreatedDate) Month
                FROM PTW_Header__c
                GROUP BY CALENDAR_YEAR(CreatedDate), 
                CALENDAR_MONTH(CreatedDate), 
                Auditor_Name__r.User__r.Main_Work_Center__c, 
                RecordType.Name, Status__c, 
                Auditor_Name__r.SECTIONS__c
                ORDER BY CALENDAR_YEAR(CreatedDate), CALENDAR_MONTH(CreatedDate)

            ];
            Integer count = 0;
            Integer countToStampNoWC = 0;
            Integer monthNew = 0;
            Integer monthOld = 0;
            //list report inspec
            List<PTW_Inspection_Report__c> listReportInspec = new List<PTW_Inspection_Report__c>();
            for (AggregateResult ar : groupedResultsPTW)  {

                /** Setup format date */
                Integer year = Integer.valueOf(ar.get('Year'));
                Integer month = Integer.valueOf(ar.get('Month'));
                Integer day = 1;
                Date dt = Date.newInstance(year, month, day);
// String dateStr = dt.format('dd/MM/yyyy');

                PTW_Inspection_Report__c reportptw = new PTW_Inspection_Report__c();
/** //WC Created Date on the same date as CreatedDate //reportptw.WC_Created_Date__c =  Date.today().addDays(-1);*/ 
                reportptw.WC_Created_Date__c = Date.valueOf(dt);
                reportptw.Main_Work_Center_Permit_to_work__c = String.valueof(ar.get('mainwork'));
                reportptw.Type_of_Permit_to_Work__c =  String.valueof(ar.get('recordTypeName'));    
                reportptw.Status_of_Permit_to_Work__c = String.valueof(ar.get('status'));   
                reportptw.Section__c = String.valueof(ar.get('section'));                  
                reportptw.Number_of_Permit_to_Work__c =  String.valueOf(ar.get('expr0'));
                //reportptw.Number_of_Work_Clearances__c = totalNumberOfWC;
                if(String.valueof(ar.get('recordTypeName')) == 'Verification'){
                    countToStampNoWC++;
                    if(countToStampNoWC == 1){
                        reportptw.Number_of_Work_Clearances__c = totalNumberOfWC;
                    }
                }
                monthNew = month;
/** Fixed Value*/
                PTW_Inspection_Report__c reportptwFixedValue = new PTW_Inspection_Report__c();
                if( (String.valueof(ar.get('recordTypeName')) == 'Inspection')){
                    count++;

                    if(monthNew != monthOld /** count == 1*/ ){
                        reportptwFixedValue.WC_Created_Date__c = Date.valueOf(dt);                          /*WC created date*/ 
                        reportptwFixedValue.Main_Work_Center_Permit_to_work__c = 'OPS-TOC3';                          /*OPS-TOC3*/
                        reportptwFixedValue.Type_of_Permit_to_Work__c =  String.valueof(ar.get('recordTypeName'));    /*inspection*/
                        reportptwFixedValue.Status_of_Permit_to_Work__c = 'หยุดงานถาวร';                               /*หยุดงานถาวร*/
                        reportptwFixedValue.Section__c = 'MFOP';                                                      /*MFOP*/
                        // reportptwFixedValue.Number_of_Work_Clearances__c = totalNumberOfWC;                           /*4*/   
                        // reportptw.Number_of_Permit_to_Work__c =  String.valueOf(ar.get('expr0'));

                        listReportInspec.add(reportptwFixedValue); // listReport.add(reportptwFixedValue);
                        monthOld = month;
                    }
                }
    
                listReportInspec.add(reportptw); //listReport.add(reportptw);
            }

            /** Debug All Report */
            Integer i = 0;
            for(PTW_Inspection_Report__c report : listReport){
                i++;
            }
            Integer i2 = 0;
            for(PTW_Inspection_Report__c report : listReportInspec){
                i2++;
            }
            // listReport[1].Number_of_Work_Clearances__c = totalNumberOfWC;    /*4*/

            /** Merge */
            List<PTW_Inspection_Report__c> listReportMerge = new List<PTW_Inspection_Report__c>();
            Map<String, PTW_Inspection_Report__c> mapReportWcNew = new Map<String, PTW_Inspection_Report__c>();
            Map<String, PTW_Inspection_Report__c> mapReportInspecNew = new Map<String, PTW_Inspection_Report__c>();
            Map<String, PTW_Inspection_Report__c> listStatusOfPtw= new Map<String, PTW_Inspection_Report__c>();
            String complexKeyWc;
            String complexKeyIns;
            
            listReportMerge = listReportInspec;
            for (PTW_Inspection_Report__c reportIns : listReportMerge) {
                //for (PTW_Inspection_Report__c reportWc : listReport) {
                for (Integer index = listReport.size() - 1; index >= 0; index--) {
                    PTW_Inspection_Report__c reportWc = listReport[index];
                    if (
                        reportIns.Main_Work_Center_Permit_to_work__c == reportWc.Main_Work_Center_Work_Clearances__c
                        && reportIns.WC_Created_Date__c.isSameDay(reportWc.WC_Created_Date__c)
                    ) {
                        reportIns.Number_of_Work_Clearances__c = reportWc.Number_of_Work_Clearances__c;
                        listReport.remove(index);
                    }
                }
            }
            // for (PTW_Inspection_Report__c reportIns : listReportMerge) {
            //     //for (PTW_Inspection_Report__c reportWc : listReport) {
            //     for (Integer index = listReport.size() - 1; index >= 0; index--) {
            //         PTW_Inspection_Report__c reportWc = listReport[index];
            //         if (
            //             reportIns.Main_Work_Center_Permit_to_work__c == reportWc.Main_Work_Center_Work_Clearances__c
            //             && reportIns.WC_Created_Date__c.isSameDay(reportWc.WC_Created_Date__c)
            //         ) {
            //             listReport.remove(index);
            //         }
            //     }
            // }
            for (PTW_Inspection_Report__c reportWc : listReport) {
                reportWc.Type_of_Permit_to_Work__c = 'Inspection';
                reportWc.Status_of_Permit_to_Work__c = 'หยุดงานถาวร';
                reportWc.Section__c = 'MFOP';
            }
            listReportMerge.addAll(listReport);

            Integer i3 = 0;
            for(PTW_Inspection_Report__c report : listReportMerge){
                i3++;
            }

            /** Save to database */
            List<Database.SaveResult> srList = Database.insert(listReportMerge, false);

            /** Iterate through each returned result*/ 
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                }
                else {
                    // Operation failed, so get all errors                
                    /*for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }*/
                }
            }
        }
    }