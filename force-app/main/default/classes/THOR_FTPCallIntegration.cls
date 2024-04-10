public class THOR_FTPCallIntegration implements Database.batchable<String>,Database.AllowsCallouts, Database.stateful
{
    
    public  String fileC = '';
    public Iterable<String>start(Database.BatchableContext BC) 
    {
        List<String>temp = new List<String>();
        temp.add('temp');
        return temp;
    }
    
    public void execute(Database.BatchableContext BC, List<String> scope) {
        
        try 
        {                
            THORIntegration__c CS = THORIntegration__c.getInstance();
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(CS.FTP_Endpoint__c);
            
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('username', CS.Username__c);
            request.setHeader('password', CS.Password__c);
            request.setHeader('port', CS.Port__c);
            request.setHeader('ftp-host', CS.ftp_host__c);
            //request.setHeader('ftp-type', 'FTP');
            request.setHeader('path', CS.Path__c);
            request.setHeader('content-length', '0');	
            request.setHeader('file', CS.File__c);
            request.setTimeout(120000);
            string body = '';
            
            HttpResponse response = http.send(request);
            String file = response.getBody();
            fileC = file;
            
            system.debug('fileC--1--'+fileC);
            
            List<String>filelist= new List<String>();
            filelist.add(file);
            
            //return filelist;
            
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    public void finish(Database.BatchableContext BC) 
    {
        system.debug('fileC----'+fileC);
        Id batchId = Database.executeBatch(new THOR_FTPIntegration(fileC), 500);
    }
    
    
    
    
}