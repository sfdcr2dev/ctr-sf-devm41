@isTest
public class OPP_NewsControllerTest {

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            if (request.getEndpoint().containsIgnoreCase('/api/auth/login')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "user": { "userId": 1, "empId": null, "email": "admin@thaioilgroup.com", "profileImagePath": "/images/gallery/5df540554c5ac91e7a6a2887608ae1a3.jpg", "position": "ผู้ดูแลระบบ", "firstName": "Admin", "lastName": "Admin", "firstNameTH": null, "lastNameTH": null, "phoneNumber": "026548856", "point": 105, "wellBeingPoint": 0, "topPoint": 0, "unavailable": false, "isRequirePassword": false, "coverImagePath": null, "departments": [ { "departmentId": 1, "companyId": 1, "departmentName": "ฝ่ายพัฒนาซอฟต์แวร์", "parentDepartmentId": null, "level": "ฝ่าย", "company": { "companyId": 1, "companyName": "บริษัท ไทยออยล์ จำกัด (มหาชน)", "acronym": "TOP", "unavailable": false }, "parentDepartment": null, "unavailable": false } ], "roles": [ { "roleId": 1, "roleName": "Administrator", "accessControlItems": [ { "accessControlItemId": 214, "authority": "_MENU_app.enews_add", "description": null }, { "accessControlItemId": 215, "authority": "_MENU_app.enews_edit", "description": null }, { "accessControlItemId": 216, "authority": "_MENU_app.enews_list", "description": null }, { "accessControlItemId": 217, "authority": "_MENU_app.enews_view", "description": null }, { "accessControlItemId": 137, "authority": "_MENU_app.inbox_bulk", "description": "" }, { "accessControlItemId": 210, "authority": "_MENU_app.inbox_history", "description": "" }, { "accessControlItemId": 136, "authority": "_MENU_app.inbox_send", "description": "" }, { "accessControlItemId": 140, "authority": "EXTERNAL_SYSTEM_CREATE", "description": "" }, { "accessControlItemId": 141, "authority": "EXTERNAL_SYSTEM_DELETE", "description": "" }, { "accessControlItemId": 142, "authority": "EXTERNAL_SYSTEM_EDIT", "description": "" }, { "accessControlItemId": 1, "authority": "COMPANY_CREATE", "description": "desc for COMPANY_CREATE" }, { "accessControlItemId": 2, "authority": "COMPANY_DELETE", "description": "desc for COMPANY_DELETE" }, { "accessControlItemId": 3, "authority": "COMPANY_EDIT", "description": "desc for COMPANY_EDIT" }, { "accessControlItemId": 4, "authority": "COMPANY_LIST", "description": "desc for COMPANY_LIST" }, { "accessControlItemId": 5, "authority": "DEPARTMENT_CREATE", "description": "desc for DEPARTMENT_CREATE" }, { "accessControlItemId": 6, "authority": "DEPARTMENT_DELETE", "description": "desc for DEPARTMENT_DELETE" }, { "accessControlItemId": 7, "authority": "DEPARTMENT_EDIT", "description": "desc for DEPARTMENT_EDIT" }, { "accessControlItemId": 8, "authority": "DEPARTMENT_LIST", "description": "desc for DEPARTMENT_LIST" }, { "accessControlItemId": 9, "authority": "ACI_CREATE", "description": "desc for ACI_CREATE" }, { "accessControlItemId": 10, "authority": "ACI_DELETE", "description": "desc for ACI_DELETE" }, { "accessControlItemId": 11, "authority": "ACI_EDIT", "description": "desc for ACI_EDIT" }, { "accessControlItemId": 12, "authority": "ACI_LIST", "description": "desc for ACI_LIST" }, { "accessControlItemId": 13, "authority": "ROLE_CREATE", "description": "desc for ROLE_CREATE" }, { "accessControlItemId": 14, "authority": "ROLE_DELETE", "description": "desc for ROLE_DELETE" }, { "accessControlItemId": 15, "authority": "ROLE_EDIT", "description": "desc for ROLE_EDIT" }, { "accessControlItemId": 16, "authority": "ROLE_LIST", "description": "desc for ROLE_LIST" }, { "accessControlItemId": 17, "authority": "ACCOUNT_CREATE", "description": "desc for ACCOUNT_CREATE" }, { "accessControlItemId": 18, "authority": "ACCOUNT_DELETE", "description": "desc for ACCOUNT_DELETE" }, { "accessControlItemId": 19, "authority": "ACCOUNT_EDIT", "description": "desc for ACCOUNT_EDIT" }, { "accessControlItemId": 20, "authority": "ACCOUNT_VIEW", "description": "desc for ACCOUNT_VIEW" }, { "accessControlItemId": 21, "authority": "ACCOUNT_LIST", "description": "desc for ACCOUNT_LIST" }, { "accessControlItemId": 22, "authority": "ACCOUNT_ROLE_EDIT", "description": "desc for ACCOUNT_ROLE_EDIT" }, { "accessControlItemId": 23, "authority": "ACCOUNT_POINT_EDIT", "description": "desc for ACCOUNT_POINT_EDIT" }, { "accessControlItemId": 24, "authority": "ALBUM_CREATE", "description": "desc for ALBUM_CREATE" }, { "accessControlItemId": 25, "authority": "ALBUM_DELETE", "description": "desc for ALBUM_DELETE" }, { "accessControlItemId": 26, "authority": "ALBUM_EDIT", "description": "desc for ALBUM_EDIT" }, { "accessControlItemId": 27, "authority": "IMAGE_UPLOAD", "description": "desc for IMAGE_UPLOAD" }, { "accessControlItemId": 28, "authority": "IMAGE_DELETE", "description": "desc for IMAGE_DELETE" }, { "accessControlItemId": 29, "authority": "NEWS_CREATE", "description": "desc for NEWS_CREATE" }, { "accessControlItemId": 30, "authority": "NEWS_DELETE", "description": "desc for NEWS_DELETE" }, { "accessControlItemId": 31, "authority": "NEWS_DELETE_ALL", "description": "desc for NEWS_DELETE_ALL" }, { "accessControlItemId": 32, "authority": "NEWS_EDIT", "description": "desc for NEWS_EDIT" }, { "accessControlItemId": 33, "authority": "NEWS_EDIT_ALL", "description": "desc for NEWS_EDIT_ALL" }, { "accessControlItemId": 34, "authority": "NEWS_LIST", "description": "desc for NEWS_LIST" }, { "accessControlItemId": 35, "authority": "NEWS_READED", "description": "desc for NEWS_READED" }, { "accessControlItemId": 36, "authority": "NEWS_REGISTER", "description": "desc for NEWS_REGISTER" }, { "accessControlItemId": 37, "authority": "NEWS_VOTE", "description": "desc for NEWS_VOTE" }, { "accessControlItemId": 38, "authority": "NEWS_FAVORITE", "description": "desc for NEWS_FAVORITE" }, { "accessControlItemId": 39, "authority": "NEWS_SET_POINT", "description": "desc for NEWS_SET_POINT" }, { "accessControlItemId": 40, "authority": "NEWS_PIN", "description": "desc for NEWS_PIN" }, { "accessControlItemId": 41, "authority": "NEWS_SET_GLOBAL", "description": "desc for NEWS_SET_GLOBAL" }, { "accessControlItemId": 42, "authority": "NEWS_SET_DEPARTMENT", "description": "desc for NEWS_SET_DEPARTMENT" }, { "accessControlItemId": 43, "authority": "NEWS_COMMENT_CREATE", "description": "desc for NEWS_COMMENT_CREATE" }, { "accessControlItemId": 44, "authority": "NEWS_COMMENT_DELETE", "description": "desc for NEWS_COMMENT_DELETE" }, { "accessControlItemId": 45, "authority": "NEWS_COMMENT_EDIT", "description": "desc for NEWS_COMMENT_EDIT" }, { "accessControlItemId": 46, "authority": "NEWS_CATEGORY_CREATE", "description": "desc for NEWS_CATEGORY_CREATE" }, { "accessControlItemId": 47, "authority": "NEWS_CATEGORY_DELETE", "description": "desc for NEWS_CATEGORY_DELETE" }, { "accessControlItemId": 48, "authority": "NEWS_CATEGORY_EDIT", "description": "desc for NEWS_CATEGORY_EDIT" }, { "accessControlItemId": 49, "authority": "FEEDBACK_CATEGORY_CREATE", "description": "desc for FEEDBACK_CATEGORY_CREATE" }, { "accessControlItemId": 50, "authority": "FEEDBACK_CATEGORY_DELETE", "description": "desc for FEEDBACK_CATEGORY_DELETE" }, { "accessControlItemId": 51, "authority": "FEEDBACK_CATEGORY_EDIT", "description": "desc for FEEDBACK_CATEGORY_EDIT" }, { "accessControlItemId": 52, "authority": "FEEDBACK_CREATE", "description": "desc for FEEDBACK_CREATE" }, { "accessControlItemId": 53, "authority": "FEEDBACK_DELETE", "description": "desc for FEEDBACK_DELETE" }, { "accessControlItemId": 54, "authority": "FEEDBACK_EDIT", "description": "desc for FEEDBACK_EDIT" }, { "accessControlItemId": 55, "authority": "FEEDBACK_EXECUTIVE", "description": "desc for FEEDBACK_EXECUTIVE" }, { "accessControlItemId": 56, "authority": "FEEDBACK_COMMENT_CREATE", "description": "desc for FEEDBACK_COMMENT_CREATE" }, { "accessControlItemId": 57, "authority": "FEEDBACK_COMMENT_DELETE", "description": "desc for FEEDBACK_COMMENT_DELETE" }, { "accessControlItemId": 58, "authority": "FEEDBACK_COMMENT_EDIT", "description": "desc for FEEDBACK_COMMENT_EDIT" }, { "accessControlItemId": 59, "authority": "REWARD_CATEGORY_CREATE", "description": "desc for REWARD_CATEGORY_CREATE" }, { "accessControlItemId": 60, "authority": "REWARD_CATEGORY_DELETE", "description": "desc for REWARD_CATEGORY_DELETE" }, { "accessControlItemId": 61, "authority": "REWARD_CATEGORY_EDIT", "description": "desc for REWARD_CATEGORY_EDIT" }, { "accessControlItemId": 62, "authority": "REWARD_CREATE", "description": "desc for REWARD_CREATE" }, { "accessControlItemId": 63, "authority": "REWARD_DELETE", "description": "desc for REWARD_DELETE" }, { "accessControlItemId": 64, "authority": "REWARD_EDIT", "description": "desc for REWARD_EDIT" }, { "accessControlItemId": 143, "authority": "EXTERNAL_SYSTEM_LIST", "description": "" }, { "accessControlItemId": 144, "authority": "EXTERNAL_SYSTEM_VIEW", "description": "" }, { "accessControlItemId": 201, "authority": "_MENU_app.setting", "description": "desc for _MENU_app.setting" }, { "accessControlItemId": 139, "authority": "_MENU_app.system_add", "description": "" }, { "accessControlItemId": 138, "authority": "_MENU_app.system_list", "description": "" }, { "accessControlItemId": 135, "authority": "_MENU_app.report_news_group_log", "description": null }, { "accessControlItemId": 211, "authority": "_MENU_app.report_users_log", "description": "des for _MENU_app.calendar_type_list" }, { "accessControlItemId": 65, "authority": "REQUEST_EDIT", "description": "desc for REQUEST_EDIT" }, { "accessControlItemId": 66, "authority": "REQUEST_LIST", "description": "desc for REQUEST_LIST" }, { "accessControlItemId": 67, "authority": "CONTENT_CREATE", "description": "desc for CONTENT_CREATE" }, { "accessControlItemId": 68, "authority": "CONTENT_DELETE", "description": "desc for CONTENT_DELETE" }, { "accessControlItemId": 69, "authority": "CONTENT_EDIT", "description": "desc for CONTENT_EDIT" }, { "accessControlItemId": 79, "authority": "DATA_IMPORT", "description": "desc for DATA_IMPORT" }, { "accessControlItemId": 80, "authority": "EVENT_CREATE", "description": "desc for EVENT_CREATE" }, { "accessControlItemId": 81, "authority": "EVENT_DELETE", "description": "desc for EVENT_DELETE" }, { "accessControlItemId": 82, "authority": "EVENT_EDIT", "description": "desc for EVENT_EDIT" }, { "accessControlItemId": 83, "authority": "REPORT_VIEW", "description": "desc for REPORT_VIEW" }, { "accessControlItemId": 84, "authority": "_MENU_app.home", "description": "desc for _MENU_app.home" }, { "accessControlItemId": 85, "authority": "_MENU_page.user", "description": "desc for _MENU_page.user" }, { "accessControlItemId": 86, "authority": "_MENU_app.company_list", "description": "desc for _MENU_app.company_list" }, { "accessControlItemId": 87, "authority": "_MENU_app.company_add", "description": "desc for _MENU_app.company_add" }, { "accessControlItemId": 88, "authority": "_MENU_app.user_list", "description": "desc for _MENU_app.user_list" }, { "accessControlItemId": 89, "authority": "_MENU_app.user_add", "description": "desc for _MENU_app.user_add" }, { "accessControlItemId": 90, "authority": "_MENU_app.role", "description": "desc for _MENU_app.role" }, { "accessControlItemId": 91, "authority": "_MENU_app.news_list", "description": "desc for _MENU_app.news_list" }, { "accessControlItemId": 92, "authority": "_MENU_app.news_add", "description": "desc for _MENU_app.news_add" }, { "accessControlItemId": 93, "authority": "_MENU_app.news_category", "description": "desc for _MENU_app.news_category" }, { "accessControlItemId": 94, "authority": "_MENU_app.feedback_category", "description": "desc for _MENU_app.feedback_category" }, { "accessControlItemId": 95, "authority": "_MENU_app.feedback_category_add", "description": "desc for _MENU_app.feedback_category_add" }, { "accessControlItemId": 96, "authority": "_MENU_app.feedback_list", "description": "desc for _MENU_app.feedback_list" }, { "accessControlItemId": 97, "authority": "_MENU_app.album", "description": "desc for _MENU_app.album" }, { "accessControlItemId": 98, "authority": "_MENU_app.reward_category", "description": "desc for _MENU_app.reward_category" }, { "accessControlItemId": 99, "authority": "_MENU_app.reward_category_add", "description": "desc for _MENU_app.reward_category_add" }, { "accessControlItemId": 100, "authority": "_MENU_app.reward_list", "description": "desc for _MENU_app.reward_list" }, { "accessControlItemId": 101, "authority": "_MENU_app.reward_add", "description": "desc for _MENU_app.reward_add" }, { "accessControlItemId": 102, "authority": "_MENU_app.club_add", "description": "desc for _MENU_app.club_add" }, { "accessControlItemId": 103, "authority": "_MENU_app.club_list", "description": "desc for _MENU_app.club_list" }, { "accessControlItemId": 104, "authority": "_MENU_app.lib_list", "description": "desc for _MENU_app.lib_list" }, { "accessControlItemId": 105, "authority": "_MENU_app.lib_add", "description": "desc for _MENU_app.lib_add" }, { "accessControlItemId": 106, "authority": "_MENU_app.pk_list", "description": "desc for _MENU_app.pk_list" }, { "accessControlItemId": 107, "authority": "_MENU_app.pk_add", "description": "desc for _MENU_app.pk_add" }, { "accessControlItemId": 108, "authority": "_MENU_app.km_list", "description": "desc for _MENU_app.km_list" }, { "accessControlItemId": 109, "authority": "_MENU_app.km_add", "description": "desc for _MENU_app.km_add" }, { "accessControlItemId": 110, "authority": "_MENU_app.calendar", "description": "desc for _MENU_app.calendar" }, { "accessControlItemId": 111, "authority": "_MENU_app.calendar_add", "description": "desc for _MENU_app.calendar_add" }, { "accessControlItemId": 112, "authority": "_MENU_app.icons", "description": "desc for _MENU_app.icons" }, { "accessControlItemId": 113, "authority": "_MENU_app.report_news", "description": "desc for _MENU_app.report_news" }, { "accessControlItemId": 114, "authority": "_MENU_app.report_feedback", "description": "desc for _MENU_app.report_feedback" }, { "accessControlItemId": 115, "authority": "_MENU_app.terms", "description": "desc for _MENU_app.terms" }, { "accessControlItemId": 116, "authority": "_MENU_app.user_import", "description": "desc for _MENU_app.user_import" }, { "accessControlItemId": 117, "authority": "_MENU_app.contact", "description": "desc for _MENU_app.contact" }, { "accessControlItemId": 119, "authority": "REQUEST_REWARD", "description": "desc for REQUEST_REWARD" }, { "accessControlItemId": 120, "authority": "_MENU_app.report_news_log", "description": "desc for _MENU_app.report_news_log" }, { "accessControlItemId": 132, "authority": "_MENU_app.news_group_list", "description": null }, { "accessControlItemId": 133, "authority": "_MENU_app.news_group_add", "description": null }, { "accessControlItemId": 134, "authority": "_MENU_app.news_add_to_group", "description": null }, { "accessControlItemId": 128, "authority": "NEWS_GROUP_CREATE", "description": null }, { "accessControlItemId": 129, "authority": "NEWS_GROUP_DELETE", "description": null }, { "accessControlItemId": 130, "authority": "NEWS_GROUP_EDIT", "description": null }, { "accessControlItemId": 131, "authority": "NEWS_GROUP_LIST", "description": null }, { "accessControlItemId": 122, "authority": "_MENU_app.report_reward_log", "description": null }, { "accessControlItemId": 121, "authority": "EMAIL_SEND", "description": null }, { "accessControlItemId": 127, "authority": "GALLERY_IMAGE_UPLOAD", "description": null }, { "accessControlItemId": 204, "authority": "CALENDARTYPE_CREATE", "description": "" }, { "accessControlItemId": 206, "authority": "CALENDARTYPE_DELETE", "description": "" }, { "accessControlItemId": 205, "authority": "CALENDARTYPE_EDIT", "description": "" }, { "accessControlItemId": 207, "authority": "CALENDARTYPE_LIST", "description": "" }, { "accessControlItemId": 203, "authority": "_MENU_app.calendar_type_list", "description": "des for _MENU_app.calendar_type_list" }, { "accessControlItemId": 202, "authority": "_MENU_app.calendar_type_add", "description": "des for _MENU_app.calendar_type_add" }, { "accessControlItemId": 209, "authority": "INBOX_HISTORY", "description": "desc for INBOX_HISTORY" }, { "accessControlItemId": 200, "authority": "CONFIGURATION", "description": "" }, { "accessControlItemId": 218, "authority": "_MENU_app.reports_ga", "description": "desc for _MENU_app.reports_ga" }, { "accessControlItemId": 219, "authority": "WELL_BEING_EVENT_CREATE", "description": "Create Well-Being Event" }, { "accessControlItemId": 220, "authority": "WELL_BEING_EVENT_UPDATE", "description": "Update Well-Being Event" }, { "accessControlItemId": 221, "authority": "WELL_BEING_EVENT_DELETE", "description": "Delete Well-Being Event" }, { "accessControlItemId": 222, "authority": "WELL_BEING_TEAM_CREATE", "description": "Create Well-Being Team" }, { "accessControlItemId": 223, "authority": "WELL_BEING_TEAM_UPDATE", "description": "Update Well-Being Team" }, { "accessControlItemId": 224, "authority": "WELL_BEING_TEAM_DELETE", "description": "Delete Well-Being Team" }, { "accessControlItemId": 225, "authority": "_MENU_app.wellbeing_news_list", "description": null }, { "accessControlItemId": 226, "authority": "_MENU_app.wellbeing_news_add", "description": null }, { "accessControlItemId": 227, "authority": "_MENU_app.wellbeing_event_list", "description": null }, { "accessControlItemId": 228, "authority": "_MENU_app.wellbeing_event_add", "description": null }, { "accessControlItemId": 229, "authority": "_MENU_app.wellbeing_product_list", "description": null }, { "accessControlItemId": 230, "authority": "_MENU_app.wellbeing_product_add", "description": null }, { "accessControlItemId": 231, "authority": "_MENU_app.wellbeing_donation_list", "description": null }, { "accessControlItemId": 232, "authority": "_MENU_app.wellbeing_donation_add", "description": null }, { "accessControlItemId": 233, "authority": "WELL_BEING_NEWS_CREATE", "description": "Create Well-Being News" }, { "accessControlItemId": 234, "authority": "WELL_BEING_NEWS_UPDATE", "description": "Update Well-Being News" }, { "accessControlItemId": 235, "authority": "WELL_BEING_NEWS_DELETE", "description": "Delete Well-Being News" }, { "accessControlItemId": 236, "authority": "WELL_BEING_PRODUCT_CREATE", "description": "Create Well-Being Product" }, { "accessControlItemId": 237, "authority": "WELL_BEING_PRODUCT_UPDATE", "description": "Update Well-Being Product" }, { "accessControlItemId": 238, "authority": "WELL_BEING_PRODUCT_DELETE", "description": "Delete Well-Being Product" }, { "accessControlItemId": 239, "authority": "WELL_BEING_DONATION_CREATE", "description": "Create Well-Being Donation" }, { "accessControlItemId": 240, "authority": "WELL_BEING_DONATION_UPDATE", "description": "Update Well-Being Donation" }, { "accessControlItemId": 241, "authority": "WELL_BEING_DONATION_DELETE", "description": "Delete Well-Being Donation" }, { "accessControlItemId": 242, "authority": "WELL_BEING_HEALTH_TIP_CREATE", "description": "Create Well-Being News" }, { "accessControlItemId": 243, "authority": "WELL_BEING_HEALTH_TIP_UPDATE", "description": "Update Well-Being News" }, { "accessControlItemId": 244, "authority": "WELL_BEING_HEALTH_TIP_DELETE", "description": "Delete Well-Being News" }, { "accessControlItemId": 245, "authority": "_MENU_app.wellbeing_team_list", "description": null }, { "accessControlItemId": 246, "authority": "_MENU_app.wellbeing_health_tips_list", "description": null }, { "accessControlItemId": 247, "authority": "_MENU_app.well_being_team_report", "description": null }, { "accessControlItemId": 248, "authority": "_MENU_app.digital_news_list", "description": null }, { "accessControlItemId": 249, "authority": "_MENU_app.digital_news_odyssey_list", "description": null }, { "accessControlItemId": 250, "authority": "_MENU_app.digital_news_odyssey_list_highlight", "description": null }, { "accessControlItemId": 251, "authority": "_MENU_app.digital_news_list_highlight", "description": null }, { "accessControlItemId": 252, "authority": "_MENU_app.digital_news_product_list", "description": null }, { "accessControlItemId": 253, "authority": "_MENU_app.digital_news_product_list_highlight", "description": null }, { "accessControlItemId": 254, "authority": "_MENU_app.event_calendar_list", "description": null }, { "accessControlItemId": 255, "authority": "_MENU_app.event_catagory_list", "description": null }, { "accessControlItemId": 256, "authority": "_MENU_app.play_event_list", "description": null }, { "accessControlItemId": 259, "authority": "ADMIN_PEOPLE", "description": null }, { "accessControlItemId": 257, "authority": "ADMIN_KM", "description": null }, { "accessControlItemId": 258, "authority": "ADMIN_CORPORATE", "description": null }, { "accessControlItemId": 260, "authority": "ADMIN_DIGITAL", "description": null }, { "accessControlItemId": 261, "authority": "ADMIN_QSHE", "description": null }, { "accessControlItemId": 262, "authority": "ADMIN_CLUB", "description": null }, { "accessControlItemId": 263, "authority": "ADMIN_AKANEE", "description": null }, { "accessControlItemId": 264, "authority": "_MENU_app.bus_station_list", "description": null }, { "accessControlItemId": 265, "authority": "_MENU_app.pool_station_list", "description": null }, { "accessControlItemId": 266, "authority": "_MENU_app.route_list", "description": null }, { "accessControlItemId": 267, "authority": "_MENU_app.pool_route_list", "description": null } ], "unavailable": false } ], "requirePassword": false }, "token": { "tokenId": 23420, "userId": 1, "hash": "b4c58bc752e64657c1c6d68ab7e6734f", "expiredDate": 1625646052645, "valid": true, "mark": null, "deviceId": null, "deviceType": null } }');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().containsIgnoreCase('/api/salesforce/addCoin')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('{ "status": "success", "message": "Congratulation you got 1 top coin." }');
                response.setStatusCode(200);
                return response;
            } else if (request.getEndpoint().containsIgnoreCase('/api/km/getTopCoin')) {
                HTTPResponse response = new HTTPResponse();
                response.setBody('11');
                response.setStatusCode(200);
                return response;
            } else {
                System.assert(false, 'unexpected endpoint ' + request.getEndpoint());
                return null;
            }
        }
    }

    @TestSetup
    static void setup(){
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews1 = new OPP_News__c();
        oppNews1.Title__c = 'News 1';
        oppNews1.Category__c = 'Corporate';
        oppNews1.Coin__c = 1;
        oppNews1.Coin_Type__c = 'Read';
        oppNews1.Content__c = 'News 1 Content';
        oppNews1.Highlight__c = true;
        oppNews1.Publish_Date__c = publishedDate;
        oppNews1.Expire_Date__c = expiryDate;
        oppNews1.Thumbnail__c = '';
        oppNews1.View__c = 10;
        oppNews1.Status__c = 'Published';
        insert oppNews1;

        OPP_News__c oppNews2 = new OPP_News__c();
        oppNews2.Title__c = 'News 2';
        oppNews2.Category__c = 'Corporate';
        oppNews2.Coin__c = 1;
        oppNews2.Coin_Type__c = 'Read';
        oppNews2.Content__c = 'News 2 Content';
        oppNews2.Highlight__c = false;
        oppNews2.Publish_Date__c = publishedDate;
        oppNews2.Expire_Date__c = expiryDate;
        oppNews2.Thumbnail__c = '';
        oppNews2.View__c = 20;
        oppNews2.Status__c = 'Published';
        insert oppNews2;

        OPP_News__c oppNews3 = new OPP_News__c();
        oppNews3.Title__c = 'News 3';
        oppNews3.Category__c = 'Corporate';
        oppNews3.Coin__c = 1;
        oppNews3.Coin_Type__c = 'Read';
        oppNews3.Content__c = 'News 3 Content';
        oppNews3.Highlight__c = false;
        oppNews3.Publish_Date__c = publishedDate;
        oppNews3.Expire_Date__c = expiryDate;
        oppNews3.Thumbnail__c = '';
        oppNews3.View__c = 30;
        oppNews3.Status__c = 'Published';
        insert oppNews3;

        OPP_News__c oppNews4 = new OPP_News__c();
        oppNews4.Title__c = 'News 4';
        oppNews4.Category__c = 'PM4U';
        oppNews4.Coin__c = 1;
        oppNews4.Coin_Type__c = 'Read';
        oppNews4.Content__c = 'News 4 Content';
        oppNews4.Highlight__c = false;
        oppNews4.Publish_Date__c = publishedDate;
        oppNews4.Expire_Date__c = expiryDate;
        oppNews4.Thumbnail__c = '';
        oppNews4.View__c = 40;
        oppNews4.Status__c = 'Published';
        insert oppNews4;

        OPP_News__c oppNews5 = new OPP_News__c();
        oppNews5.Title__c = 'News 5';
        oppNews5.Category__c = 'Corporate';
        oppNews5.Coin__c = 1;
        oppNews5.Coin_Type__c = 'Read';
        oppNews5.Content__c = 'News 5 Content';
        oppNews5.Highlight__c = true;
        oppNews5.Publish_Date__c = publishedDate;
        oppNews5.Expire_Date__c = expiryDate;
        oppNews5.Thumbnail__c = '';
        oppNews5.View__c = 50;
        oppNews5.Status__c = 'Draft';
        insert oppNews5;

//        OPP_News__c oppShopNews1 = new OPP_News__c();
//        oppShopNews1.Title__c = 'Shop News 1';
//        oppShopNews1.Category__c = 'TOP Shop';
//        oppShopNews1.Coin__c = 1;
//        oppShopNews1.Coin_Type__c = 'Read';
//        oppShopNews1.Content__c = 'Shop News 1 Content';
//        oppShopNews1.Highlight__c = true;
//        oppShopNews1.Publish_Date__c = publishedDate;
//        oppShopNews1.Expire_Date__c = expiryDate;
//        oppShopNews1.Thumbnail__c = '';
//        oppShopNews1.View__c = 10;
//        oppShopNews1.Status__c = 'Published';
//        insert oppShopNews1;
//
//        OPP_News__c oppShopNews2 = new OPP_News__c();
//        oppShopNews2.Title__c = 'Shop News 2';
//        oppShopNews2.Category__c = 'TOP Shop';
//        oppShopNews2.Coin__c = 1;
//        oppShopNews2.Coin_Type__c = 'Read';
//        oppShopNews2.Content__c = 'Shop News 2 Content';
//        oppShopNews2.Highlight__c = true;
//        oppShopNews2.Publish_Date__c = publishedDate;
//        oppShopNews2.Expire_Date__c = expiryDate;
//        oppShopNews2.Thumbnail__c = '';
//        oppShopNews2.View__c = 20;
//        oppShopNews2.Status__c = 'Published';
//        insert oppShopNews2;

        OPP_News__c oppShopNews1 = new OPP_News__c();
        oppShopNews1.Title__c = 'Special Issue News 1';
        oppShopNews1.Category__c = 'Special Issues';
        oppShopNews1.Coin__c = 1;
        oppShopNews1.Coin_Type__c = 'Read';
        oppShopNews1.Content__c = 'Special Issue News 1 Content';
        oppShopNews1.Highlight__c = true;
        oppShopNews1.Publish_Date__c = publishedDate;
        oppShopNews1.Expire_Date__c = expiryDate;
        oppShopNews1.Thumbnail__c = '';
        oppShopNews1.View__c = 10;
        oppShopNews1.Status__c = 'Published';
        insert oppShopNews1;

        OPPIntegration__c oppIntegration = new OPPIntegration__c();
        oppIntegration.Coin_Authorization_Endpoint__c = 'https://qasapi-thaioilhub.thaioilgroup.com/api/auth/login?';
        oppIntegration.Coin_Authorization_Username__c = 'admin';
        oppIntegration.Coin_Authorization_Password__c = 'https://api.ariba.com/v2/oauth/token';
        oppIntegration.Coin_Login_Username__c = 'salesforce';
        oppIntegration.Coin_Login_Password__c = '123456';
        oppIntegration.Coin_Add_Endpoint__c = 'https://qasapi-thaioilhub.thaioilgroup.com/api/salesforce/addCoin?';
        oppIntegration.Coin_Get_Endpoint__c = 'https://qasapi-thaioilhub.thaioilgroup.com/api/km/getTopCoin?';
        insert oppIntegration;
    }

    @isTest
    static void testGetCategoryPicklist() {
        Test.startTest();
        List<String> categories = OPP_NewsController.getCategoryPicklist();
        Test.stopTest();

        //System.assertEquals('Home', categories[0]);
    }

    @isTest
    static void testGetAllNews() {
        Test.startTest();
        List<OPP_News__c> news = OPP_NewsController.getAllNews();
        Test.stopTest();

        System.assertEquals(5, news.size());
    }

    @isTest
    static void testGetAllPublishedNews() {
        Test.startTest();
        List<OPP_News__c> news = OPP_NewsController.getAllPublishedNews();
        Test.stopTest();

        System.assertEquals(4, news.size());
        System.assertEquals('Published', news[0].Status__c);
        System.assertEquals('Published', news[1].Status__c);
        System.assertEquals('Published', news[2].Status__c);
        System.assertEquals('Published', news[3].Status__c);
    }

    @isTest
    static void testGetPublishedNewsByCategory() {
        Test.startTest();
        List<OPP_News__c> news1 = OPP_NewsController.getPublishedNewsByCategory('Corporate');
        List<OPP_News__c> news2 = OPP_NewsController.getPublishedNewsByCategory('Home');
        List<OPP_News__c> news3 = OPP_NewsController.getPublishedNewsByCategory('Highlight');
        Test.stopTest();

        System.assertEquals(3, news1.size());
        System.assertEquals('Corporate', news1[0].Category__c);
        System.assertEquals('Published', news1[0].Status__c);
        System.assertEquals('Corporate', news1[1].Category__c);
        System.assertEquals('Published', news1[1].Status__c);
        System.assertEquals('Corporate', news1[2].Category__c);
        System.assertEquals('Published', news1[2].Status__c);

        //System.assertEquals(4, news2.size());
        // System.assertEquals('News 1', news2[0].Title__c);
        // System.assertEquals('Published', news2[0].Status__c);
        // System.assertEquals('News 2', news2[1].Title__c);
        // System.assertEquals('Published', news2[1].Status__c);
        // System.assertEquals('News 3', news2[2].Title__c);
        // System.assertEquals('Published', news2[2].Status__c);
        // System.assertEquals('News 4', news2[3].Title__c);
        // System.assertEquals('Published', news2[3].Status__c);

        // System.assertEquals(1, news3.size());
        // System.assertEquals('News 1', news3[0].Title__c);
        // System.assertEquals('Published', news3[0].Status__c);
        // System.assertEquals(true, news3[0].Highlight__c);
    }

    @isTest
    static void testGetPublishedMostViewNews() {
        Test.startTest();
        List<OPP_News__c> news = OPP_NewsController.getPublishedMostViewNews(5);
        Test.stopTest();

        System.assertEquals(4, news.size());
        System.assertEquals('News 4', news[0].Title__c);
        System.assertEquals('Published', news[0].Status__c);
        System.assertEquals(40, news[0].View__c);
        System.assertEquals('News 3', news[1].Title__c);
        System.assertEquals('Published', news[1].Status__c);
        System.assertEquals(30, news[1].View__c);
        System.assertEquals('News 2', news[2].Title__c);
        System.assertEquals('Published', news[2].Status__c);
        System.assertEquals(20, news[2].View__c);
        System.assertEquals('News 1', news[3].Title__c);
        System.assertEquals('Published', news[3].Status__c);
        System.assertEquals(10, news[3].View__c);
    }

//    @isTest
//    static void testGetPublishedShopNews() {
//        Test.startTest();
//        List<OPP_News__c> shops = OPP_NewsController.getPublishedShopNews(5);
//        Test.stopTest();
//
//        System.assertEquals(2, shops.size());
//        System.assertEquals('Shop News 1', shops[0].Title__c);
//        System.assertEquals('Published', shops[0].Status__c);
//        System.assertEquals('Shop News 2', shops[1].Title__c);
//        System.assertEquals('Published', shops[1].Status__c);
//    }

    @isTest
    static void testGetPublishedHighlightNewsByCategory() {
        Test.startTest();
        List<OPP_News__c> news = OPP_NewsController.getPublishedHighlightNewsByCategory('Corporate');
        Test.stopTest();

        System.assertEquals(1, news.size());
        System.assertEquals('News 1', news[0].Title__c);
        System.assertEquals('Published', news[0].Status__c);
    }

    @isTest
    static void testGetSpecialIssuesNews() {
        Test.startTest();
        List<OPP_News__c> news = OPP_NewsController.getSpecialIssuesNews();
        Test.stopTest();

        System.assertEquals(1, news.size());
        System.assertEquals('Special Issue News 1', news[0].Title__c);
        System.assertEquals('Published', news[0].Status__c);
    }

    @isTest
    static void testGetPublishedNewsById() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 1;
        oppNews.Coin_Type__c = 'Read';
        oppNews.Content__c = 'News Corporate 1 Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Published';
        insert oppNews;

        Test.startTest();
        List<OPP_News__c> news = OPP_NewsController.getPublishedNewsById(oppNews.Id);
        Test.stopTest();

        System.assertEquals('News Corporate 1', news[0].Title__c);
        System.assertEquals('Corporate', news[0].Category__c);
        System.assertEquals('Published', news[0].Status__c);
    }

    @isTest
    static void testGetCoinBalance() {
        Test.setMock(HttpCalloutMock.class, new OPP_NewsControllerTest.Mock());

        Test.startTest();
        Decimal coinBalance = OPP_NewsController.getCoinBalance();
        Test.stopTest();

        System.assertEquals(11, coinBalance);
    }

    @isTest
    static void testLikeNewsById() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 1;
        oppNews.Coin_Type__c = 'Read';
        oppNews.Content__c = 'News Corporate 1 Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Published';
        insert oppNews;

        Test.startTest();
        OPP_NewsController.likeNewsById(oppNews.Id);
        Test.stopTest();

        List<OPP_News_Coin__c> oppNewsCoin = [SELECT Id, Coin__c FROM OPP_News_Coin__c WHERE Action__c = 'Like' AND OPP_News__c = :oppNews.Id AND OwnerId = :UserInfo.getUserId()];

        System.assertEquals(1, oppNewsCoin.size());
    }

    @isTest
    static void testUnlikeNewsById() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 1;
        oppNews.Coin_Type__c = 'Read';
        oppNews.Content__c = 'News Corporate 1 Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Published';
        insert oppNews;

        Test.startTest();
        OPP_NewsController.likeNewsById(oppNews.Id);
        List<OPP_News_Coin__c> oppNewsCoin_Before = [SELECT Id, Coin__c FROM OPP_News_Coin__c WHERE Action__c = 'Like' AND OPP_News__c = :oppNews.Id AND OwnerId = :UserInfo.getUserId()];

        OPP_NewsController.unlikeNewsById(oppNews.Id);
        List<OPP_News_Coin__c> oppNewsCoin_After = [SELECT Id, Coin__c FROM OPP_News_Coin__c WHERE Action__c = 'Like' AND OPP_News__c = :oppNews.Id AND OwnerId = :UserInfo.getUserId()];
        Test.stopTest();

        System.assertEquals(1, oppNewsCoin_Before.size());
        System.assertEquals(0, oppNewsCoin_After.size());
    }

    @isTest
    static void testMarkNewsAsReadById() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 1;
        oppNews.Coin_Type__c = 'Read';
        oppNews.Content__c = 'News Corporate 1 Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Published';
        insert oppNews;

        Test.setMock(HttpCalloutMock.class, new OPP_NewsControllerTest.Mock());

        Test.startTest();
        OPP_NewsController.markNewsAsReadById(oppNews.Id);
        Test.stopTest();

        List<OPP_News_Coin__c> oppNewsCoin = [SELECT Id, Coin__c FROM OPP_News_Coin__c WHERE Action__c = 'Read' AND OPP_News__c = :oppNews.Id AND OwnerId = :UserInfo.getUserId()];

        System.assertEquals(1, oppNewsCoin.size());
        System.assertEquals(1, oppNewsCoin[0].Coin__c);
    }

    @isTest
    static void testVoteNews() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 1;
        oppNews.Coin_Type__c = 'Vote';
        oppNews.Content__c = 'News Corporate 1 Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Published';
        insert oppNews;

        Test.startTest();
        OPP_NewsController.voteNews();
        Test.stopTest();
    }

    @isTest
    static void testIsLikedNewsById() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 1;
        oppNews.Coin_Type__c = 'Read';
        oppNews.Content__c = 'News Corporate 1 Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Published';
        insert oppNews;

        Test.startTest();
        Boolean isLiked_Before = OPP_NewsController.isLikedNewsById(oppNews.Id);
        OPP_NewsController.likeNewsById(oppNews.Id);
        Boolean isLiked_After = OPP_NewsController.isLikedNewsById(oppNews.Id);

        List<OPP_News_Coin__c> oppNewsCoin = [SELECT Id, Coin__c FROM OPP_News_Coin__c WHERE Action__c = 'Like' AND OPP_News__c = :oppNews.Id AND OwnerId = :UserInfo.getUserId()];
        Test.stopTest();

        System.assertEquals(1, oppNewsCoin.size());
        System.assertEquals(false, isLiked_Before);
        System.assertEquals(true, isLiked_After);
    }

    @isTest
    static void testIsReadNewsById() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 0;
        oppNews.Coin_Type__c = '';
        oppNews.Content__c = 'News Corporate 1 Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Published';
        insert oppNews;

        Test.setMock(HttpCalloutMock.class, new OPP_NewsControllerTest.Mock());

        Test.startTest();
        Boolean isRead_Before = OPP_NewsController.isReadNewsById(oppNews.Id);
        OPP_NewsController.markNewsAsReadById(oppNews.Id);
        Boolean isRead_After = OPP_NewsController.isReadNewsById(oppNews.Id);

        List<OPP_News_Coin__c> oppNewsCoin = [SELECT Id, Coin__c FROM OPP_News_Coin__c WHERE Action__c = 'Read' AND OPP_News__c = :oppNews.Id AND OwnerId = :UserInfo.getUserId()];
        Test.stopTest();

        System.assertEquals(1, oppNewsCoin.size());
        System.assertEquals(false, isRead_Before);
        System.assertEquals(true, isRead_After);
    }

    @isTest
    static void testGetNews() {
        Date today = Date.today();
        Date publishedDate = today.addDays(-30);
        Date expiryDate = today.addDays(30);

        OPP_News__c oppNews = new OPP_News__c();
        oppNews.Title__c = 'News Corporate 1 Draft';
        oppNews.Category__c = 'Corporate';
        oppNews.Coin__c = 1;
        oppNews.Coin_Type__c = 'Read';
        oppNews.Content__c = 'News Corporate 1 Draft Content';
        oppNews.Highlight__c = true;
        oppNews.Publish_Date__c = publishedDate;
        oppNews.Expire_Date__c = expiryDate;
        oppNews.Thumbnail__c = '';
        oppNews.View__c = 0;
        oppNews.Status__c = 'Draft';
        insert oppNews;

        Test.startTest();
        List<OPP_News__c> news = OPP_NewsController.getNewsById(oppNews.Id);
        Test.stopTest();

        System.assertEquals('News Corporate 1 Draft', news[0].Title__c);
        System.assertEquals('Corporate', news[0].Category__c);
        System.assertEquals('Draft', news[0].Status__c);
    }
}