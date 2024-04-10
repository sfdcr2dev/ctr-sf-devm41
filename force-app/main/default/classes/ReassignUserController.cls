/* Class for Reassign User */
public with sharing class ReassignUserController {

    public string ProjectOrganizationId {get;set;}
    public Id ProjectId {get;set;}
    public string ProjectName {get;set;}
    public Set<Id> AssignedUserIds {get;set;}
    public Set<Id> FinalAssignedUserIds {get;set;}
    public Set<Id> DeletedAssignedUserIds {get;set;}
    public Id NewAssignUserId {get;set;}
    public integer UserIndex {get;set;}
    public Id RemoveAssignUserId {get;set;}
    public integer RemoveUserIndex {get;set;}
    public List<AvailableUserWrapper> AvailableWrappers {get;set;}
    public List<AssignedUserWrapper> AssignedWrappers {get;set;}
    public List<Assigned_User__c> SelectedUsers {get;set;}
    public boolean isUserAssigned {get;set;}
    public boolean isAlreadyAssignedUser {get;set;}
    
    public Project_Organization__c WP2 {get;set;}
    
    public integer AvailableWrapperSize {get;set;}
    public integer AssignedWrapperSize {get;set;}
    
    public class AvailableUserWrapper {
        public integer UserIndex {get;set;}
        public Id UserId {get;set;}
        public string UserName {get;set;}
    }
    
    public class AssignedUserWrapper {
        public integer UserIndex {get;set;}
        public Id UserId {get;set;}
        public string UserName {get;set;}
    }
    
    public ReassignUserController(ApexPages.StandardController controller) {

        AvailableWrapperSize = 0;
        AssignedWrapperSize = 0;
        isUserAssigned = false;
        isAlreadyAssignedUser = false;
        
        SelectedUsers = new List<Assigned_User__c>();
        DeletedAssignedUserIds = new Set<Id>();
        FinalAssignedUserIds = new Set<Id>();
        AssignedWrappers = new List<AssignedUserWrapper>();
        
        Project_Organization__c currentWP2 = (Project_Organization__c)controller.getRecord();
        
        ProjectOrganizationId = currentWP2.Id;
        
        WP2 = [select id, Project__c, Project__r.Name, Work_Process_Status__c from Project_Organization__c where Id =: ProjectOrganizationId];
        
        if(WP2 != null) {
            ProjectId = WP2.Project__c;
            ProjectName = WP2.Project__r.Name;
        }

        CheckAssignedUser();
        CheckAvailableUser();

    }

    
    public void CheckAvailableUser() {
        AvailableWrappers = new List<AvailableUserWrapper>();
        
        List<User> Users = [select id, name, Profile.Name from User where (Id NOT IN: AssignedUserIds AND (Profile.Name = 'Reassign Team' OR UserRole.Name like '%TOPPMP-AI%'))  order by Name];
        
        if(Users.size() > 0) {
            integer count = 0;
            for(User user : Users) {
                AvailableUserWrapper AU = new AvailableUserWrapper();
                AU.UserIndex = count;
                AU.UserId = user.Id;
                AU.UserName = user.Name;
                AvailableWrappers.add(AU);
                count++;
                
                AvailableWrapperSize = AvailableWrappers.size();
            }
        } 
    }
    
    public void CheckAssignedUser() {
       
       AssignedUserIds = new Set<Id>();
       List<Assigned_User__c> AssignedUsers = new List<Assigned_User__c>();
       
       AssignedUsers = [select id, User__c, Project__c, User__r.Name from Assigned_User__c where Project__c =: ProjectId];
       
       if(AssignedUsers.size() > 0) {
           isAlreadyAssignedUser = true;
           integer count = 0;
           for(Assigned_User__c user : AssignedUsers) {
                AssignedUserWrapper AU = new AssignedUserWrapper();
                AU.UserIndex = count;
                AU.UserId = user.User__c;
                AU.UserName = user.User__r.Name;
                AssignedWrappers.add(AU);
                count++;
                AssignedUserIds.add(user.User__c);
                
                AssignedWrapperSize = AssignedWrappers.size();
            }
       }
       
    }
    
    public void AddAvailableUser() {
        
        isUserAssigned = true;
        User newUser = [select id, name from User where Id =: NewAssignUserId];
        
        AssignedUserWrapper auWrapper = new AssignedUserWrapper();
        auWrapper.UserId = newUser.Id;
        auWrapper.UserName = newUser.Name;
        
        System.debug(AssignedWrappers);
        AssignedWrappers.add(auWrapper);
        System.debug(UserIndex);
        
        if(AvailableWrappers.size() > 0) {
        	AvailableWrappers.remove(UserIndex);
        	System.debug(AssignedWrappers);
            integer count = 0;
            for(AvailableUserWrapper user : AvailableWrappers) {
                user.UserIndex = count;
                count++;
            }
        }
        
        if(AssignedWrappers.size() > 0) {
            integer count = 0;
            for(AssignedUserWrapper user : AssignedWrappers) {
                user.UserIndex = count;
                count++;
            }
        }
        
        AvailableWrapperSize = AvailableWrappers.size();
        AssignedWrapperSize = AssignedWrappers.size();
        
    }
    
    public void RemoveAssignedUser() {
        
        User removeUser = [select id, name from User where Id =: RemoveAssignUserId];
        
        AvailableUserWrapper auWrapper = new AvailableUserWrapper();
        auWrapper.UserId = removeUser.Id;
        auWrapper.UserName = removeUser.Name;
        
        AvailableWrappers.add(auWrapper);
        AssignedWrappers.remove(RemoveUserIndex);
        
        DeletedAssignedUserIds.add(removeUser.Id);
        
        if(AssignedWrappers.size() > 0) {
            integer count = 0;
            for(AssignedUserWrapper user : AssignedWrappers) {
                user.UserIndex = count;
                count++;
            }
        }
        
        if(AvailableWrappers.size() > 0) {
            integer count = 0;
            for(AvailableUserWrapper user : AvailableWrappers) {
                user.UserIndex = count;
                count++;
            }
        }
        
        AvailableWrapperSize = AvailableWrappers.size();
        AssignedWrapperSize = AssignedWrappers.size();
    }
    
    public PageReference AssignSelectedUser() {
        
        if(AssignedWrappers.size() > 0) {
            for(AssignedUserWrapper selectedUser : AssignedWrappers) {
                
                string currentUserId = selectedUser.UserId;
                FinalAssignedUserIds.add(currentUserId);
                
                List<Assigned_User__c> alreadyAssignedUsers = [select id, User__c, Project__c, User__r.Name from Assigned_User__c where User__c =: currentUserId  AND Project__c =: ProjectId];
                
                if(alreadyAssignedUsers.size() == 0) {
                    Assigned_User__c assignedUser = new Assigned_User__c();
                    assignedUser.Name = selectedUser.UserName;
                    assignedUser.User__c = selectedUser.UserId;
                    assignedUser.Project__c = ProjectId;
                    SelectedUsers.add(assignedUser);
                }
            }
            
            //Delete Selected User
            List<Assigned_User__c> deletedAssignedUsers = [select id, User__c, Project__c from Assigned_User__c where User__c IN: DeletedAssignedUserIds AND Project__c =: ProjectId];
            
            if(deletedAssignedUsers.size() > 0) {
                List<Assigned_User__c> finalDeletedUsers = new List<Assigned_User__c>();
                
                for(Assigned_User__c deleteUser : deletedAssignedUsers) {
                
                    boolean foundMatch = false;
                    
                    for(Id finalUser : FinalAssignedUserIds) {
                    
                        if(deleteUser.User__c == finalUser) {
                            foundMatch = true;
                            break;
                        }
                    }
                    
                    if(!foundMatch) {
                        finalDeletedUsers.add(deleteUser);
                    }
                }
                
                if(finalDeletedUsers.size() > 0) {
                    delete(finalDeletedUsers);
                }
                
            }
            
            if(SelectedUsers.size() > 0) {
                insert(SelectedUsers);
                
                //Update Work Process Status
                if(WP2.Work_Process_Status__c == 'Not Start') {
                    WP2.Work_Process_Status__c = 'In Progress';
                    update(WP2);
                }
                
                String url = '/'+ ProjectOrganizationId;
        
                PageReference PageRefBack = new PageReference(url);
            
                return PageRefBack;
            }
            
        }
        else {
        
            List<Assigned_User__c> deletedUser = [select id from Assigned_User__c where Project__c =: ProjectId];
        
            if(deletedUser.size() > 0) {
                delete(deletedUser);
            }
        
            return null;
        }
        
        return null;
        
    }

}