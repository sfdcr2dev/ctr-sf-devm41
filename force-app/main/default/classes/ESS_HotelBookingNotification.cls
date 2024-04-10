public with sharing class ESS_HotelBookingNotification {

    private static string environment = [select environment__c from ess_config__c].environment__c; 
    private static string orgId = UserInfo.getOrganizationId();
    
    //HS-01 - (กรณี On Behalf of) ส่งอีเมลไปยังพนักงาน หลัง Employee Admin ทำการ Submit ขอจองโรงแรม
    public static void SendToEmployeeWhenRequesterSubmitOnBehalf(ESS_Hotel_Booking__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Hotel_Booking_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_01'
        ];
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                    }
                    else if(count == 2) {
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!RequesterName}', model.Requester_Name_EN__c);

        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c);
        htmlBody = htmlBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        
        htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
        htmlBody = htmlBody.replace('{!CheckInDate}', checkInDate);
        htmlBody = htmlBody.replace('{!CheckOutDate}', checkOutDate);
        //Room 1
        htmlBody = htmlBody.replace('{!GuestRoom1}', guestRoom1);
        htmlBody = htmlBody.replace('{!RoomType1}', roomType1);
        htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            htmlBody = htmlBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            htmlBody = htmlBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL, model.Document_No__c));

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c);
        plainBody = plainBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
        plainBody = plainBody.replace('{!CheckInDate}', checkInDate);
        plainBody = plainBody.replace('{!CheckOutDate}', checkOutDate);
        //Room 1
        plainBody = plainBody.replace('{!GuestRoom1}', guestRoom1);
        plainBody = plainBody.replace('{!RoomType1}', roomType1);
        plainBody = plainBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            plainBody = plainBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            plainBody = plainBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ model.On_Behalf_Of_Email__c };
        message.setToAddresses(message.toAddresses);
            
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Email to Employee Admin (requester)
        ccAddresses.add(model.Requester_Email__c);
        
        //CC Hotel Admin
        Set<string> ccAdminEmails = sendEmailForAdminHotel();
        ccAddresses.addAll(ccAdminEmails);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails();
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
               
        if(ccAddresses.size() > 0) {
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
            
    //HS-03 - แจ้งผู้ที่เกี่ยวข้องว่ามีการยกเลิกการจองโรงแรม
    public static void SendToUserWhenHotelCancelled(ESS_Hotel_Booking__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Hotel_Booking_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_03'
        ];
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';
        
        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string chargeEmployee1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        string chargeEmployee2 = '';
        boolean moreThanOneRoom = false;
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee1 = String.ValueOf(room.chargeEmployee.format());
                    }
                    else if(count == 2) {
                        moreThanOneRoom = true;
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee2 = String.ValueOf(room.chargeEmployee.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        string roomNight = '';
        if(!moreThanOneRoom) {
            roomNight = model.Room__c + ' Room ';
        }
        else {
            roomNight = model.Room__c + ' Rooms ';
        }
        if(model.Night__c == 1) {
            roomNight += model.Night__c + ' Night ';
        }
        else {
            roomNight += model.Night__c + ' Nights ';
        }
        
        string cancelComment = '';
        if(model.Cancel_Comment__c != null) {
            cancelComment = model.Cancel_Comment__c;
        }
        string employeeId = '';
        if(model.On_Behalf_Of_Flow__c) {
            if(string.isNotEmpty(model.On_Behalf_Of_Employee_Id__c)) {
                employeeId = ' (' + model.On_Behalf_Of_Employee_Id__c + ')';
            }
        }
        else {
            if(string.isNotEmpty(model.Requester_Employee_Id__c)) {
                employeeId = ' (' + model.Requester_Employee_Id__c + ')';
            }
        }
        
        //Send Email Requester / OBH
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!CancelledBy}', model.Cancelled_By__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        if(model.On_Behalf_Of_Flow__c) {
            htmlBody = htmlBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c + employeeId);
        }
        else {
            htmlBody = htmlBody.replace('{!ReceiverName}', model.Requester_Name_EN__c + employeeId);
        }
        htmlBody = htmlBody.replace('{!CancelledBy}', model.Cancelled_By__c);
        htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
        htmlBody = htmlBody.replace('{!CheckInDate}', checkInDate);
        htmlBody = htmlBody.replace('{!CheckOutDate}', checkOutDate);
        htmlBody = htmlBody.replace('{!RoomNight}', roomNight);
        //Room 1
        htmlBody = htmlBody.replace('{!GuestRoom1}', guestRoom1);
        htmlBody = htmlBody.replace('{!RoomType1}', roomType1);
        htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Contract Rate (1)
        htmlBody = htmlBody.replace('{!ContractRate1}', string.valueOf(chargeEmployee1));
        
        //Room 2
        if(moreThanOneRoom) {
            string room2 = '<br/><b>Room 2</b><br/>' +
                'Guest : ' + guestRoom2 + ' <br/>' +
                'Room Type : ' + roomType2 + '<br/>' +
                'Special Request : ' + specialRequestRoom2 + '<br/>' +
                'Total Charge Employee : ' + chargeEmployee2 + ' THB <br/>';
            htmlBody = htmlBody.replace('{!Room2}', string.valueOf(room2));
        }
        else {
            htmlBody = htmlBody.replace('{!Room2}', '');
        }
        htmlBody = htmlBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!Comment}', cancelComment);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        if(model.On_Behalf_Of_Flow__c) {
            plainBody = plainBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c + employeeId);
        }
        else {
            plainBody = plainBody.replace('{!ReceiverName}', model.Requester_Name_EN__c + employeeId);
        }
        plainBody = plainBody.replace('{!CancelledBy}', model.Cancelled_By__c);
        plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
        plainBody = plainBody.replace('{!CheckInDate}', checkInDate);
        plainBody = plainBody.replace('{!CheckOutDate}', checkOutDate);
        plainBody = plainBody.replace('{!RoomNight}', roomNight);
        //Room 1
        plainBody = plainBody.replace('{!GuestRoom1}', guestRoom1);
        plainBody = plainBody.replace('{!RoomType1}', roomType1);
        plainBody = plainBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Contract Rate (1)
        plainBody = plainBody.replace('{!ContractRate1}', string.valueOf(chargeEmployee1));
        
        //Room 2
        if(moreThanOneRoom) {
            string room2 = '<br/><b>Room 2</b><br/>' +
                'Guest : ' + guestRoom2 + ' <br/>' +
                'Room Type : ' + roomType2 + '<br/>' +
                'Special Request : ' + specialRequestRoom2 + '<br/>' +
                'Total Charge Employee : ' + chargeEmployee2 + ' THB <br/>';
            plainBody = htmlBody.replace('{!Room2}', string.valueOf(room2));
        }
        else {
            plainBody = htmlBody.replace('{!Room2}', '');
        }
        plainBody = plainBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!Comment}', cancelComment);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        message.toAddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Of_Flow__c) {
            message.toAddresses.add(model.On_Behalf_Of_Email__c);
        }
            
        List<string> ccAddresses = new List<string>();
        
        //CC Hotel Admin
        Set<string> ccAdminEmails = sendEmailForAdminHotel();
        ccAddresses.addAll(ccAdminEmails);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails();
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        message.setCcAddresses(ccAddresses);    
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }           
        
        sendEmails.add(message);
        
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //HS-04 - (กรณี On Behalf of) ส่งอีเมลแจ้งผลไปยัง Employee Admin หลัง Employee ทำการ Reject
    public static void SendToEmployeeAdminWhenEmployeeRejectOnBehalf(ESS_Hotel_Booking__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Hotel_Booking_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_04'
        ];
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';
        string onBehalfOfFlow = 'on behalf of {!OnBehalfOfName}';

        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                    }
                    else if(count == 2) {
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                        
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        string rejectComment = '';
        if(model.Reject_Comment__c != null) {
            rejectComment = model.Reject_Comment__c;
        }
        
        //Send email to Requester
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!ReceiverName}', model.Requester_Name_EN__c);
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
        htmlBody = htmlBody.replace('{!CheckInDate}', checkInDate);
        htmlBody = htmlBody.replace('{!CheckOutDate}', checkOutDate);
        //Room 1
        htmlBody = htmlBody.replace('{!GuestRoom1}', guestRoom1);
        htmlBody = htmlBody.replace('{!RoomType1}', roomType1);
        htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            htmlBody = htmlBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            htmlBody = htmlBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfFlow}', onBehalfOfFlow);
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace('{!OnBehalfOfFlow}', '');
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!Comment}', rejectComment);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ReceiverName}', model.Requester_Name_EN__c);
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
        plainBody = plainBody.replace('{!CheckInDate}', checkInDate);
        plainBody = plainBody.replace('{!CheckOutDate}', checkOutDate);
        //Room 1
        plainBody = plainBody.replace('{!GuestRoom1}', guestRoom1);
        plainBody = plainBody.replace('{!RoomType1}', roomType1);
        plainBody = plainBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            plainBody = plainBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            plainBody = plainBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfFlow}', onBehalfOfFlow);
            plainBody = plainBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
            plainBody = plainBody.replace('{!OnBehalfOfFlow}', '');
        }
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!Comment}', rejectComment);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setWhatId(model.Id);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ model.Requester_Email__c };
        message.setToAddresses(message.toAddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Verifier
        ccAddresses.add(model.On_Behalf_Of_Email__c);
        //CC Hotel Admin
        Set<string> ccAdminEmails = sendEmailForAdminHotel();
        ccAddresses.addAll(ccAdminEmails);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails();
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }
    }
    
    //HS-05 - (กรณี On Behalf of) ส่งอีเมลแจ้งผลไปยัง Employee Admin หลัง Employee ทำการ Verify (ยกเลิกการใช้งาน)
    public static void SendToEmployeeAdminWhenEmployeeVerifyOnBehalf(ESS_Hotel_Booking__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Hotel_Booking_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_05'
        ];
        
        PISUsers__c receiver;
        PISUsers__c requester;
        PISUsers__c onBehalf;
        
        boolean isPRTRRequester = model.Is_PRTR_Requester__c;
        boolean isSecretaryRequester = model.Is_Secretary_Requester__c;
        User requestByUser = new User();
        
        if (model.On_Behalf_Flow__c) {
            receiver = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            onBehalf = ESS_Global.assignToPISUser(
            model.On_Behalf_Of_Id__c
            );
            
            if(isPRTRRequester) {
                requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
            }
            else {
                if(isSecretaryRequester) {
                    boolean isPRTRUser = ESS_Global.checkPRTRUser(model.Requester_Id__c);
                    if(isPRTRUser) {
                        requestByUser = ESS_Global.assignToUser(
                            model.Requester_Id__c
                        );
                    }
                    else {
                        requester = ESS_Global.assignToPISUser(
                        model.Requester_Id__c
                        );
                    }
                }
                else {
                    requester = ESS_Global.assignToPISUser(
                    model.Requester_Id__c
                    );
                }
            }
        }
        else {
            if(isPRTRRequester) {
                requestByUser = ESS_Global.assignToUser(
                model.Requester_Id__c
                );
            }
            else {
                receiver = ESS_Global.assignToPISUser(
                model.Requester_Id__c
                );
            }
        }
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';
        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                    }
                    else if(count == 2) {
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);

        string htmlBody = emailTemplate.HtmlValue;
        if(isPRTRRequester) {
            htmlBody = htmlBody.replace('{!ReceiverName}', requestByUser.FirstName + ' ' + requestByUser.LastName);
        }
        else {
            htmlBody = htmlBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        }
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
        htmlBody = htmlBody.replace('{!CheckInDate}', checkInDate);
        htmlBody = htmlBody.replace('{!CheckOutDate}', checkOutDate);
        //Room 1
        htmlBody = htmlBody.replace('{!GuestRoom1}', guestRoom1);
        htmlBody = htmlBody.replace('{!RoomType1}', roomType1);
        htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            htmlBody = htmlBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            htmlBody = htmlBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        String plainBody = emailTemplate.Body;
        if(isPRTRRequester) {
            plainBody = plainBody.replace('{!ReceiverName}', requestByUser.FirstName + ' ' + requestByUser.LastName);
        }
        else {
            plainBody = plainBody.replace('{!ReceiverName}', receiver.EN_Fullname__c);
        }
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
        plainBody = plainBody.replace('{!CheckInDate}', checkInDate);
        plainBody = plainBody.replace('{!CheckOutDate}', checkOutDate);
        //Room 1
        plainBody = plainBody.replace('{!GuestRoom1}', guestRoom1);
        plainBody = plainBody.replace('{!RoomType1}', roomType1);
        plainBody = plainBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            plainBody = plainBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            plainBody = plainBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));

        message.setWhatId(model.Id);
        message.toAddresses = new List<String>();
        if(isPRTRRequester) {
            message.toAddresses.add(requestByUser.Email);
        }
        else {
            message.toAddresses.add(receiver.Email__c);
        }
        message.setToAddresses(message.toaddresses);
        message.setTemplateID(emailTemplate.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);

        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> ccAddresses = ccEmails();
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
              OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
              message.setOrgWideEmailAddressId(owea[0].Id);
          }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    //HS-06 - ส่งอีเมลแจ้งไปยัง Admin PMSV ว่ามีการขอจองโรงแรม
    public static void SendToAdminPMSVWhenRequested(ESS_Hotel_Booking__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Hotel_Booking_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Find Admin PMSV
        /* Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        List<PISUsers__c> AdminPMSVs = ESS_Global.assignToESSPMSVHotelPISUser();
        if(AdminPMSVs.size() > 0) {
            for(PISUsers__c AdminPMSV : AdminPMSVs) {
                PISUsers.add(AdminPMSV);
            }
        } */
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_06'
        ];
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';

        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                    }
                    else if(count == 2) {
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        if(model.On_Behalf_Of_Flow__c) {
            subject = subject.replace('{!RequesterName}', model.On_Behalf_Of_EN__c);
        }
        else {
            subject = subject.replace('{!RequesterName}', model.Requester_Name_EN__c);
        }
        
        string htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
        htmlBody = htmlBody.replace('{!CheckInDate}', checkInDate);
        htmlBody = htmlBody.replace('{!CheckOutDate}', CheckOutDate);
        //Room 1
        htmlBody = htmlBody.replace('{!GuestRoom1}', guestRoom1);
        htmlBody = htmlBody.replace('{!RoomType1}', roomType1);
        htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            htmlBody = htmlBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            htmlBody = htmlBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!RequesterName}', model.Requester_Name_EN__c);
        plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
        plainBody = plainBody.replace('{!CheckInDate}', checkInDate);
        plainBody = plainBody.replace('{!CheckOutDate}', CheckOutDate);
        //Room 1
        plainBody = plainBody.replace('{!GuestRoom1}', guestRoom1);
        plainBody = plainBody.replace('{!RoomType1}', roomType1);
        plainBody = plainBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            plainBody = plainBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            plainBody = plainBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
            
        //Send Email to Admin PMSV
        Set<string> adminEmails = sendEmailForAdminHotel();
        if(adminEmails.size() > 0) {
            for(string email : adminEmails) {
                message.toAddresses.add(email);
            }
            message.setToAddresses(message.toaddresses);
        }
            
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Email to Employee Admin , Employee
        ccEmails.add(model.Requester_Email__c);
        if(model.On_Behalf_Flow__c) {
            ccEmails.add(model.On_Behalf_Of_Email__c);
        }
        
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails();
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }

    //HS-07_1 - ส่งอีเมลแจ้งผลไปยัง Employee/Employee Admin ว่ามีการปิดใบงานเรียบร้อยแล้ว
    public static void SendToEmployeeAndEmployeeAdminWhenCompleted(ESS_Hotel_Booking__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Hotel_Booking_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Find Admin PMSV
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_07_1'
        ];
        
        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string chargeEmployee1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        string chargeEmployee2 = '';
        boolean moreThanOneRoom = false;
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee1 = String.ValueOf(room.chargeEmployee.format());
                    }
                    else if(count == 2) {
                        moreThanOneRoom = true;
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee2 = String.ValueOf(room.chargeEmployee.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        string roomNight = '';
        if(!moreThanOneRoom) {
            roomNight = model.Room__c + ' Room ';
        }
        else {
            roomNight = model.Room__c + ' Rooms ';
        }
        if(model.Night__c == 1) {
            roomNight += model.Night__c + ' Night ';
        }
        else {
            roomNight += model.Night__c + ' Nights ';
        }
        
        //Send Email to Requester / OBH
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        string employeeId = '';
        if(string.isNotEmpty(model.Requester_Employee_Id__c)) {
            employeeId = model.Requester_Employee_Id__c;
        }
        
        if(model.On_Behalf_Of_Flow__c) {
            htmlBody = htmlBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c + ' (' + model.On_Behalf_Of_Employee_Id__c + ')' );
        }
        else {
            htmlBody = htmlBody.replace('{!ReceiverName}', model.Requester_Name_EN__c + ' (' + employeeId + ')' );
        }
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
        htmlBody = htmlBody.replace('{!CheckInDate}', checkInDate);
        htmlBody = htmlBody.replace('{!CheckOutDate}', checkOutDate);
        htmlBody = htmlBody.replace('{!RoomNight}', roomNight);
        
        //Room Detail (1)
        htmlBody = htmlBody.replace('{!GuestRoom1}', string.valueOf(guestRoom1));
        htmlBody = htmlBody.replace('{!RoomType1}', string.valueOf(roomType1));
        htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', string.valueOf(specialRequestRoom1));
        //Contract Rate (1)
        htmlBody = htmlBody.replace('{!ContractRate1}', string.valueOf(chargeEmployee1));
        
        if(moreThanOneRoom) {
            string room2 = '<br/><b>Room 2</b><br/>' +
                'Guest : ' + guestRoom2 + ' <br/>' +
                'Room Type : ' + roomType2 + '<br/>' +
                'Special Request : ' + specialRequestRoom2 + '<br/>' +
                'Total Charge Employee : ' + chargeEmployee2 + ' THB <br/>';
            htmlBody = htmlBody.replace('{!Room2}', string.valueOf(room2));
        }
        else {
            
            htmlBody = htmlBody.replace('{!Room2}', '');
        }
        htmlBody = htmlBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        if(model.On_Behalf_Of_Flow__c) {
            plainBody = plainBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c + ' (' + model.On_Behalf_Of_Employee_Id__c + ')' );
        }
        else {
            plainBody = plainBody.replace('{!ReceiverName}', model.Requester_Name_EN__c + ' (' + employeeId + ')' );
        }
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
        plainBody = plainBody.replace('{!CheckInDate}', checkInDate);
        plainBody = plainBody.replace('{!CheckOutDate}', checkOutDate);
        plainBody = plainBody.replace('{!RoomNight}', roomNight);
        
        //Room Detail (1)
        plainBody = plainBody.replace('{!GuestRoom1}', string.valueOf(guestRoom1));
        plainBody = plainBody.replace('{!RoomType1}', string.valueOf(roomType1));
        plainBody = plainBody.replace('{!SpecialRequestRoom1}', string.valueOf(specialRequestRoom1));
        //Contract Rate (1)
        plainBody = plainBody.replace('{!ContractRate1}', string.valueOf(chargeEmployee1));
        
        if(moreThanOneRoom) {
            string room2 = '<br/><b>Room 2</b><br/>' +
                'Guest : ' + guestRoom2 + ' <br/>' +
                'Room Type : ' + roomType2 + '<br/>' +
                'Special Request : ' + specialRequestRoom2 + '<br/>' +
                'Total Charge Employee : ' + chargeEmployee2 + ' THB<br/>';
            plainBody = plainBody.replace('{!Room2}', string.valueOf(room2));
        }
        else {
            plainBody = plainBody.replace('{!Room2}', '');
        }
        plainBody = plainBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>();
        message.toaddresses.add(model.Requester_Email__c);
        if(model.On_Behalf_Of_Flow__c) {
            message.toaddresses.add(model.On_Behalf_Of_Email__c);        
        }
        message.setToAddresses(message.toAddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Hotel Admin
        Set<string> ccAdminEmails = sendEmailForAdminHotel();
        ccAddresses.addAll(ccAdminEmails);
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails();
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            message.setCcAddresses(ccAddresses);
        }
        
        List<ESS_Hotel_Booking__c> Hotels = [SELECT Id, Attachment_Files__c, (SELECT Id FROM Attachments) FROM ESS_Hotel_Booking__c WHERE Id = :model.Id];
        if (!Hotels.isEmpty()) {
            
            //Set<Id> attachmentIds = (new Map<Id, SObject>(Hotels)).keySet();
            List<Id> attachmentIds = new List<Id>();
            if(Hotels[0].Attachment_Files__c != null) {
                List<string> fileIds = Hotels[0].Attachment_Files__c.split(',');
                attachmentIds = fileIds;
            }
            List<Attachment> files = [SELECT Name, Body, ContentType FROM Attachment WHERE Id IN :attachmentIds];
            
            //Attach Files to email
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            for (Attachment file: files) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(file.Name);
                efa.setBody(file.Body);
                efa.setContentType(file.ContentType);
                attachments.add(efa);
            }
            message.setFileAttachments(attachments);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //HS-08 - ส่งอีเมลแจ้งผลไปยัง Employee/Employee Admin ว่ามีการ Reject การขอจองโรงแรมโดย Admin PMSV
    public static void SendToEmployeeAndEmployeeAdminWhenPMSVReject(ESS_Hotel_Booking__c model) {
        
        string link = '/one/one.app#/alohaRedirect/apex/ESS_Hotel_Booking_Detail?parent=HOME&recordId=' + model.Id;
        string URL = ESS_Global.emailURL(link);
        
        //Find Admin PMSV
        Set<PISUsers__c> PISUsers = new Set<PISUsers__c>();
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_08'
        ];
        
        string createdDate;
        if (model.CreatedDate != null) {
            createdDate = model.CreatedDate.format('dd/MM/yyyy');
        }
        
        string submittedDate;
        if (model.Submitted_Date__c != null) {
            submittedDate = formatDate(model.Submitted_Date__c);
        }

        Map<string, string> statuses = GetAllStatuses();
        
        String htmlBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}<br/>';
        String plainBodyOnBehalf = 'On Behalf of: {!OnBehalfOfID} - {!OnBehalfOfName}\r\n';
        
        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                    }
                    else if(count == 2) {
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');

        string rejectComment = '';
        if(model.Reject_Comment__c != null) {
            rejectComment = model.Reject_Comment__c;
        }
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSaveAsActivity(false);
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!DocumentNo}', model.Document_No__c);
        subject = subject.replace('{!RejectedBy}', model.Rejected_By__c);
        
        string htmlBody = emailTemplate.HtmlValue;
        if(model.On_Behalf_Flow__c) {
            htmlBody = htmlBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c);   
        }
        else {
            htmlBody = htmlBody.replace('{!ReceiverName}', model.Requester_Name_EN__c);
        }
        htmlBody = htmlBody.replace('{!DocumentNo}', model.Document_No__c);
        htmlBody = htmlBody.replace('{!RejectedBy}', model.Rejected_By__c);
        htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
        htmlBody = htmlBody.replace('{!CheckInDate}', checkInDate);
        htmlBody = htmlBody.replace('{!CheckOutDate}', CheckOutDate);
        //Room 1
        htmlBody = htmlBody.replace('{!GuestRoom1}', guestRoom1);
        htmlBody = htmlBody.replace('{!RoomType1}', roomType1);
        htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            htmlBody = htmlBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            htmlBody = htmlBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            htmlBody = htmlBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            htmlBody = htmlBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            htmlBody = htmlBody.replace(htmlBodyOnBehalf, '');
        }
        htmlBody = htmlBody.replace('{!SubmittedDate}', submittedDate);
        htmlBody = htmlBody.replace('{!Comment}', rejectComment);
        htmlBody = htmlBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        htmlBody = htmlBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        String plainBody = emailTemplate.Body;
        if(model.On_Behalf_Flow__c) {
            plainBody = plainBody.replace('{!ReceiverName}', model.On_Behalf_Of_EN__c);   
        }
        else {
            plainBody = plainBody.replace('{!ReceiverName}', model.Requester_Name_EN__c);
        }
        plainBody = plainBody.replace('{!DocumentNo}', model.Document_No__c);
        plainBody = plainBody.replace('{!RejectedBy}', model.Rejected_By__c);
        plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
        plainBody = plainBody.replace('{!CheckInDate}', checkInDate);
        plainBody = plainBody.replace('{!CheckOutDate}', CheckOutDate);
        //Room 1
        plainBody = plainBody.replace('{!GuestRoom1}', guestRoom1);
        plainBody = plainBody.replace('{!RoomType1}', roomType1);
        plainBody = plainBody.replace('{!SpecialRequestRoom1}', specialRequestRoom1);
        //Room 2
        if(totalRoom == 2) {
            string roomDetail2 =  'Room 2 : ' + guestRoom2 + ' / Room Type : ' + roomType2 + ' / Special Request : ' + specialRequestRoom2;
            plainBody = plainBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
        }
        else {
            plainBody = plainBody.replace('{!RoomDetail2}', '');
        }
        if (model.On_Behalf_Flow__c)
        {
            plainBody = plainBody.replace('{!OnBehalfOfID}', model.On_Behalf_Of_Employee_Id__c);
            plainBody = plainBody.replace('{!OnBehalfOfName}', model.On_Behalf_Of_EN__c);
        }else{
            plainBody = plainBody.replace(plainBodyOnBehalf, '');
        }
        plainBody = plainBody.replace('{!SubmittedDate}', submittedDate);
        plainBody = plainBody.replace('{!Comment}', rejectComment);
        plainBody = plainBody.replace('{!CurrentStatus}', statuses.get(model.Status__c));
        plainBody = plainBody.replace('{!DocumentURL}', LinkURL(URL,model.Document_No__c));
        
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(model.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        message.toAddresses = new List<String>{ model.Requester_Email__c };
        message.setToAddresses(message.toaddresses);
        
        List<string> ccAddresses = new List<string>();
        Set<string> ccEmails = new Set<string>();
        
        //CC Email to Employee Admin , Employee
        if(model.On_Behalf_Flow__c) {
            ccEmails.add(model.On_Behalf_Of_Email__c);
        }
        
        //CC Hotel Admin
        Set<string> ccAdminEmails = sendEmailForAdminHotel();
        ccEmails.addAll(ccAdminEmails);
        
        if(ccEmails.size() > 0) {
            for(string ccEmail : ccEmails) {
                ccAddresses.add(ccEmail);
            }
        }
        
        //Test ccEmail (Only in DEV,QAS)
        if(environment != ESS_Enum.Environment.PROD.name()) {
            List<string> testCCEmails = ccEmails();
            for(string testCCEmail : testCCEmails) {
                ccAddresses.add(testCCEmail);
            }
        }
        
        if(ccAddresses.size() > 0) {
            message.setCcAddresses(ccAddresses);
        }
        
        if(environment != ESS_Enum.Environment.PROD.name()) {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
            message.setOrgWideEmailAddressId(owea[0].Id);
        }
        else {
            message.setSenderDisplayName('i-Link+');
        }
        
        sendEmails.add(message);
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //HS-09 - ส่ง Email ไปหาโรงแรมเพื่อทำการจอง
    public static void SendToHotelForReservation(ESS_Hotel_Booking__c model) {
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_09'
        ];
        
        List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO> contactPersons = new List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>();
        ESS_Master_Hotel_Booking__c Master = [select id, Contact_JSON__c from ESS_Master_Hotel_Booking__c where id = :model.Master_Hotel_Id__c];
        
        if(Master.Contact_JSON__c != null) {
            contactPersons = (List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>)JSON.deserialize(Master.Contact_JSON__c, List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>.class);
        }
        
        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string chargeEmployee1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        string chargeEmployee2 = '';
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee1 = String.ValueOf(room.chargeEmployee.format());
                    }
                    else if(count == 2) {
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee2 = String.ValueOf(room.chargeEmployee.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        string requesterName = '';
        string employeeId = '';
        string employeeAdminEmail = '';
        string employeeEmail = '';
        if(model.On_Behalf_Flow__c) {
            requesterName = model.On_Behalf_Of_EN__c;
            employeeId = model.On_Behalf_Of_Employee_Id__c;
            employeeEmail = model.On_Behalf_Of_Email__c;
        }
        else {
            requesterName = model.Requester_Name_EN__c;
            if(model.Requester_Employee_Id__c != null) {
                employeeId = model.Requester_Employee_Id__c;
            }
        }
        
        employeeAdminEmail = model.Requester_Email__c;
        
        //Send Email to Hotel Contact Person
        if(contactPersons.size() > 0) {
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSaveAsActivity(false);
            string subject = emailTemplate.Subject;
            subject = subject.replace('{!DocumentNo}', model.Document_No__c);
            subject = subject.replace('{!CheckInDate}', checkInDate);
            subject = subject.replace('{!CheckOutDate}', checkOutDate);
            subject = subject.replace('{!RequesterName}', requesterName);
            subject = subject.replace('{!EmployeeId}', employeeId);
            
            string pmsvComment = '';
            if(model.PMSV_Comment__c != null) {
                pmsvComment = model.PMSV_Comment__c;
            }
            
            string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
            htmlBody = htmlBody.replace('{!RequesterName}', requesterName);
            htmlBody = htmlBody.replace('{!EmployeeId}', employeeId);
            htmlBody = htmlBody.replace('{!CheckInDate}', CheckInDate);
            htmlBody = htmlBody.replace('{!CheckOutDate}', checkOutDate);
            htmlBody = htmlBody.replace('{!Night}', string.valueOf(model.Night__c));
            if(model.Night__c > 1) {
                htmlBody = htmlBody.replace('{!NightWording}', 'Nights');
            }
            else {
                htmlBody = htmlBody.replace('{!NightWording}', 'Night');
            }
            htmlBody = htmlBody.replace('{!Room}', string.valueOf(model.Room__c));
            if(model.Room__c > 1) {
                htmlBody = htmlBody.replace('{!RoomWording}', 'Rooms');
            }
            else {
                htmlBody = htmlBody.replace('{!RoomWording}', 'Room');
            }
            //Room Detail (1)
            htmlBody = htmlBody.replace('{!GuestRoom1}', string.valueOf(guestRoom1));
            htmlBody = htmlBody.replace('{!RoomType1}', string.valueOf(roomType1));
            htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', string.valueOf(specialRequestRoom1));
            //Contract Rate (1)
            htmlBody = htmlBody.replace('{!ContractRate1}', string.valueOf(contractRate1));
            //Room Detail (2)
            if(totalRoom == 2) {
                string roomDetail2 =  'Guest ' + guestRoom2 + ' / Room Type : ' + roomType2 + '<br/> Special Request : <span style="color:red">' + specialRequestRoom2 + '</span>';
                htmlBody = htmlBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
                //Contract Rate (2)
                htmlBody = htmlBody.replace('{!ContractRate2}', string.valueOf(contractRate2) + ' THB per room per night');
            }
            else {
                htmlBody = htmlBody.replace('{!RoomDetail2}', '-');
                htmlBody = htmlBody.replace('{!ContractRate2}', '-');
            }
            
            htmlBody = htmlBody.replace('{!Total}', string.valueOf(model.Total__c.format()));
            htmlBody = htmlBody.replace('{!ThaiOilAmount}', string.valueOf(model.Total_Charge_Company__c.format()));
            htmlBody = htmlBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
            htmlBody = htmlBody.replace('{!Remark}', pmsvComment);
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
            plainBody = plainBody.replace('{!RequesterName}', requesterName);
            plainBody = plainBody.replace('{!EmployeeId}', employeeId);
            plainBody = plainBody.replace('{!CheckInDate}', CheckInDate);
            plainBody = plainBody.replace('{!CheckOutDate}', checkOutDate);
            plainBody = plainBody.replace('{!Night}', string.valueOf(model.Night__c));
            if(model.Night__c > 1) {
                plainBody = plainBody.replace('{!NightWording}', 'Nights');
            }
            else {
                plainBody = plainBody.replace('{!NightWording}', 'Night');
            }
            plainBody = plainBody.replace('{!Room}', string.valueOf(model.Room__c));
            if(model.Room__c > 1) {
                plainBody = plainBody.replace('{!RoomWording}', 'Rooms');
            }
            else {
                plainBody = plainBody.replace('{!RoomWording}', 'Room');
            }
            //Room Detail (1)
            plainBody = plainBody.replace('{!GuestRoom1}', string.valueOf(guestRoom1));
            plainBody = plainBody.replace('{!RoomType1}', string.valueOf(roomType1));
            plainBody = plainBody.replace('{!SpecialRequestRoom1}', string.valueOf(specialRequestRoom1));
            //Room Detail (2)
            if(totalRoom == 2) {
                string roomDetail2 =  'Guest ' + guestRoom1 + ' / Room Type : ' + roomType2 + '<br/> Special Request : <span style="color:red">' + specialRequestRoom1 + '</span>';
                plainBody = plainBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
            }                    
            plainBody = plainBody.replace('{!Total}', string.valueOf(model.Total__c));
            plainBody = plainBody.replace('{!ThaiOilAmount}', string.valueOf(model.Total_Charge_Company__c.format()));
            plainBody = plainBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
            plainBody = plainBody.replace('{!Remark}', pmsvComment);
            
            message.setTemplateID(emailTemplate.Id);
            message.setWhatId(model.Id);
            message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
            message.toAddresses = new List<String>();
            
            for(ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO contact : contactPersons) {
                message.toAddresses.add(contact.contactEmail);
            }
            
            message.setToAddresses(message.toaddresses);
            
            //CC to Admin only
            List<string> ccAddresses = new List<string>();
            Set<string> ccEmails = new Set<string>();
            
            //CC Hotel Admin
            Set<string> ccAdminEmails = sendEmailForAdminHotel();
            ccAddresses.addAll(ccAdminEmails);
            
            //Test ccEmail (Only in DEV,QAS)
            if(environment != ESS_Enum.Environment.PROD.name()) {
                List<string> testCCEmails = ccEmails();
                for(string testCCEmail : testCCEmails) {
                    ccAddresses.add(testCCEmail);
                }
            }
            
            if(ccAddresses.size() > 0) {
                message.setCcAddresses(ccAddresses);
            }
            
            if(environment != ESS_Enum.Environment.PROD.name()) {
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
                message.setOrgWideEmailAddressId(owea[0].Id);
            }
            else {
                message.setSenderDisplayName('i-Link+');
            }
            
            sendEmails.add(message);
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    //HS-10 - ส่ง Email ไปหาโรงแรมเมื่อมีการยกเลิกการจอง
    public static void SendToHotelForCancelReservation(ESS_Hotel_Booking__c model) {
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [
        SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
        FROM EmailTemplate
        WHERE developername = 'Hotel_HS_10'
        ];
        
        List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO> contactPersons = new List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>();
        ESS_Master_Hotel_Booking__c Master = [select id, Contact_JSON__c from ESS_Master_Hotel_Booking__c where id = :model.Master_Hotel_Id__c];
        
        if(Master.Contact_JSON__c != null) {
            contactPersons = (List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>)JSON.deserialize(Master.Contact_JSON__c, List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>.class);
        }
        
        //Create Room Detail
        string roomDetail;
        integer totalRoom = 0;
        
        string guestRoom1;
        string roomType1;
        string specialRequestRoom1 = '';
        string contractRate1 = '';
        string chargeEmployee1 = '';
        string guestRoom2;
        string roomType2;
        string specialRequestRoom2 = '';
        string contractRate2 = '';
        string chargeEmployee2 = '';
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        if(model.Room_JSON__c != null) {
            rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
        
            if(rooms.size() > 0) {
                integer count = 1;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO room : rooms) {
                    if(count == 1) {
                        guestRoom1 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType1 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom1 = room.specialRequest;
                        }
                        if (room.total != null) contractRate1 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee1 = String.ValueOf(room.chargeEmployee.format());
                    }
                    else if(count == 2) {
                        guestRoom2 = String.ValueOf(room.guestNo) + ' ' + (room.guestNo > 1 ? 'Adults' : 'Adult');
                        roomType2 = room.roomType.value;
                        if(room.specialRequest != null) {
                            specialRequestRoom2 = room.specialRequest;
                        }
                        if (room.total != null) contractRate2 = String.ValueOf(room.total.format());
                        if (room.chargeEmployee != null) chargeEmployee2 = String.ValueOf(room.chargeEmployee.format());
                    }
                    count++;
                    totalRoom++;
                }
            }
        }
        
        datetime checkInDateTime = datetime.newInstance(model.Check_In__c.year(), model.Check_In__c.month(), model.Check_In__c.day());
        string checkInDate = checkInDateTime.day() + ' ' + checkInDateTime.format('MMMM') + ' ' + checkInDateTime.format('yyyy');
        datetime checkOutDateTime = datetime.newInstance(model.Check_Out__c.year(), model.Check_Out__c.month(), model.Check_Out__c.day());
        string checkOutDate = checkOutDateTime.day() + ' ' + checkOutDateTime.format('MMMM') + ' ' + checkOutDateTime.format('yyyy');
        
        string requesterName = '';
        string employeeId = '';
        string employeeAdminEmail = '';
        string employeeEmail = '';
        if(model.On_Behalf_Flow__c) {
            requesterName = model.On_Behalf_Of_EN__c;
            employeeId = model.On_Behalf_Of_Employee_Id__c;
            employeeEmail = model.On_Behalf_Of_Email__c;
        }
        else {
            requesterName = model.Requester_Name_EN__c;
            if(model.Requester_Employee_Id__c != null) {
                employeeId = model.Requester_Employee_Id__c;
            }
        }
        
        employeeAdminEmail = model.Requester_Email__c;
        
        //Find attachment
        List<ESS_Hotel_Booking__c> Hotels = [SELECT Id, Attachment_Files__c, (SELECT Id FROM Attachments) FROM ESS_Hotel_Booking__c WHERE Id = :model.Id];
        //Attach Files to email
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        if (!Hotels.isEmpty()) {
            
            //Set<Id> attachmentIds = (new Map<Id, SObject>(Hotels)).keySet();
            List<Id> attachmentIds = new List<Id>();
            if(Hotels[0].Attachment_Files__c != null) {
                List<string> fileIds = Hotels[0].Attachment_Files__c.split(',');
                attachmentIds = fileIds;
            }
            List<Attachment> files = [SELECT Name, Body, ContentType FROM Attachment WHERE Id IN :attachmentIds];
            
            for (Attachment file: files) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(file.Name);
                efa.setBody(file.Body);
                efa.setContentType(file.ContentType);
                attachments.add(efa);
            }
        }
        
        //Send Email to Hotel Contact Person
        if(contactPersons.size() > 0) {
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSaveAsActivity(false);
            string subject = emailTemplate.Subject;
            subject = subject.replace('{!DocumentNo}', model.Document_No__c);
            subject = subject.replace('{!CheckInDate}', checkInDate);
            subject = subject.replace('{!CheckOutDate}', checkOutDate);
            subject = subject.replace('{!RequesterName}', requesterName);
            subject = subject.replace('{!EmployeeId}', employeeId);
            
            string pmsvComment = '';
            if(model.PMSV_Comment__c != null) {
                pmsvComment = model.PMSV_Comment__c;
            }
            
            string htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!HotelName}', model.Hotel_Name__c);
            htmlBody = htmlBody.replace('{!RequesterName}', requesterName);
            htmlBody = htmlBody.replace('{!EmployeeId}', employeeId);
            htmlBody = htmlBody.replace('{!CheckInDate}', CheckInDate);
            htmlBody = htmlBody.replace('{!CheckOutDate}', checkOutDate);
            htmlBody = htmlBody.replace('{!Night}', string.valueOf(model.Night__c));
            if(model.Night__c > 1) {
                htmlBody = htmlBody.replace('{!NightWording}', 'Nights');
            }
            else {
                htmlBody = htmlBody.replace('{!NightWording}', 'Night');
            }
            htmlBody = htmlBody.replace('{!Room}', string.valueOf(model.Room__c));
            if(model.Room__c > 1) {
                htmlBody = htmlBody.replace('{!RoomWording}', 'Rooms');
            }
            else {
                htmlBody = htmlBody.replace('{!RoomWording}', 'Room');
            }
            //Room Detail (1)
            htmlBody = htmlBody.replace('{!GuestRoom1}', string.valueOf(guestRoom1));
            htmlBody = htmlBody.replace('{!RoomType1}', string.valueOf(roomType1));
            htmlBody = htmlBody.replace('{!SpecialRequestRoom1}', string.valueOf(specialRequestRoom1));
            //Contract Rate (1)
            htmlBody = htmlBody.replace('{!ContractRate1}', string.valueOf(contractRate1));
            //Room Detail (2)
            if(totalRoom == 2) {
                string roomDetail2 =  'Guest ' + guestRoom2 + ' / Room Type : ' + roomType2 + '<br/> Special Request : <span style="color:red">' + specialRequestRoom2 + '</span>';
                htmlBody = htmlBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
                //Contract Rate (2)
                htmlBody = htmlBody.replace('{!ContractRate2}', string.valueOf(contractRate2) + ' THB per room per night');
            }
            else {
                htmlBody = htmlBody.replace('{!RoomDetail2}', '-');
                htmlBody = htmlBody.replace('{!ContractRate2}', '-');
            }
            
            htmlBody = htmlBody.replace('{!Total}', string.valueOf(model.Total__c.format()));
            htmlBody = htmlBody.replace('{!ThaiOilAmount}', string.valueOf(model.Total_Charge_Company__c.format()));
            htmlBody = htmlBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
            htmlBody = htmlBody.replace('{!Remark}', pmsvComment);
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!HotelName}', model.Hotel_Name__c);
            plainBody = plainBody.replace('{!RequesterName}', requesterName);
            plainBody = plainBody.replace('{!EmployeeId}', employeeId);
            plainBody = plainBody.replace('{!CheckInDate}', CheckInDate);
            plainBody = plainBody.replace('{!CheckOutDate}', checkOutDate);
            plainBody = plainBody.replace('{!Night}', string.valueOf(model.Night__c));
            if(model.Night__c > 1) {
                plainBody = plainBody.replace('{!NightWording}', 'Nights');
            }
            else {
                plainBody = plainBody.replace('{!NightWording}', 'Night');
            }
            plainBody = plainBody.replace('{!Room}', string.valueOf(model.Room__c));
            if(model.Room__c > 1) {
                plainBody = plainBody.replace('{!RoomWording}', 'Rooms');
            }
            else {
                plainBody = plainBody.replace('{!RoomWording}', 'Room');
            }
            //Room Detail (1)
            plainBody = plainBody.replace('{!GuestRoom1}', string.valueOf(guestRoom1));
            plainBody = plainBody.replace('{!RoomType1}', string.valueOf(roomType1));
            plainBody = plainBody.replace('{!SpecialRequestRoom1}', string.valueOf(specialRequestRoom1));
            //Room Detail (2)
            if(totalRoom == 2) {
                string roomDetail2 =  'Guest ' + guestRoom1 + ' / Room Type : ' + roomType2 + '<br/> Special Request : <span style="color:red">' + specialRequestRoom1 + '</span>';
                plainBody = plainBody.replace('{!RoomDetail2}', string.valueOf(roomDetail2));
            }                    
            plainBody = plainBody.replace('{!Total}', string.valueOf(model.Total__c));
            plainBody = plainBody.replace('{!ThaiOilAmount}', string.valueOf(model.Total_Charge_Company__c.format()));
            plainBody = plainBody.replace('{!GuestAmount}', string.valueOf(model.Total_Charge_Employee__c.format()));
            plainBody = plainBody.replace('{!Remark}', pmsvComment);
            
            message.setTemplateID(emailTemplate.Id);
            message.setWhatId(model.Id);
            message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
            message.toAddresses = new List<String>();
            
            for(ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO contact : contactPersons) {
                message.toAddresses.add(contact.contactEmail);
            }
            
            message.setToAddresses(message.toaddresses);
            
            //CC to Admin only
            List<string> ccAddresses = new List<string>();
            Set<string> ccEmails = new Set<string>();
            
            //CC Hotel Admin
            Set<string> ccAdminEmails = sendEmailForAdminHotel();
            ccAddresses.addAll(ccAdminEmails);
            
            //Test ccEmail (Only in DEV,QAS)
            if(environment != ESS_Enum.Environment.PROD.name()) {
                List<string> testCCEmails = ccEmails();
                for(string testCCEmail : testCCEmails) {
                    ccAddresses.add(testCCEmail);
                }
            }
            
            if(ccAddresses.size() > 0) {
                message.setCcAddresses(ccAddresses);
            }
            
            if(environment != ESS_Enum.Environment.PROD.name()) {
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
                message.setOrgWideEmailAddressId(owea[0].Id);
            }
            else {
                message.setSenderDisplayName('i-Link+');
            }
            
            //Add attach file
            if(attachments.size() > 0) {
                message.setFileAttachments(attachments);
            }
            
            sendEmails.add(message);
            
            
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }  
    }
    
    private static Map<string, string> GetAllStatuses()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Hotel_Booking__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getValue(), objPickList.getLabel());
        }
        return statuses;
    }

    public static string formatDate(Datetime d) {
        DateTime newDT = system.Datetime.newInstance(d.year(), d.month(), d.day());
        string convertedDate = newDT.format('dd/MM/yyyy');
        return convertedDate;
    }
    
    public static List<string> ccEmails() {
        List<string> ccAddresses = new List<string>();
        ccAddresses.add('suphattra@thaioilgroup.com');
        ccAddresses.add('pirapornw@thaioilgroup.com');
        ccAddresses.add('zsirinnantha@thaioilgroup.com');
        ccAddresses.add('sarocha@softever.co.th');
        ccAddresses.add('sinlapat@softever.co.th');
        ccAddresses.add('atittaya@softever.co.th');
        ccAddresses.add('puttipat@softever.co.th');
        return ccAddresses;
    }
        
    public static string LinkURL(string URL, string documentNo) {
        string returnURL = '<a href=\'' + URL + '\'>' + documentNo + '</a>';
        return returnURL;
    }
    
    public static Set<string> sendEmailForAdminHotel() {
        
        Set<string> ccEmails = new Set<string>();
        
        //Find Admin PMSV
        Set<User> AdminUsers = new Set<User>();
        Set<PISUsers__c> AdminPISUsers = new Set<PISUsers__c>();
        
        List<User> AdminPMSVUsers = ESS_Global.assignToESSPMSVHotelUser();
        AdminUsers.addAll(AdminPMSVUsers);
        List<PISUsers__c> AdminPMSVs = ESS_Global.assignToESSPMSVHotelPISUser();
        AdminPISUsers.addAll(AdminPMSVs);
        
        if(AdminPISUsers.size() > 0) {
            for(PISUsers__c PISUser : AdminPISUsers) {
                ccEmails.add(PISUser.EMAIL__c);
            }
        }
        if(AdminUsers.size() > 0) {
            for(User User : AdminUsers) {
                ccEmails.add(User.Email);
            }
        }
        
        return ccEmails;
    }
}