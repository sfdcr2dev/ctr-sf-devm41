/* Author Softever */
public class ESS_Menu_DTO {

    public class MenuListDTO {
        @RemoteAction
        public string menuGroup {get;set;}
        @RemoteAction
        public string icon {get;set;}
        @RemoteAction
        public string menuName {get;set;}
        @RemoteAction
        public string pageUrl {get;set;}
        @RemoteAction
        public integer notiCount {get;set;}
        @RemoteAction
        public boolean isShow {get;set;}
        @RemoteAction
        public string notiColor {get;set;}
    }
    
    public class MenuApproverDTO {
        @RemoteAction
        public boolean isApprover {get;set;}
        @RemoteAction
        public integer notiCount {get;set;}
    }

}