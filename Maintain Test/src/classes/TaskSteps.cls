public with sharing class TaskSteps {

    Task__c tskRec;
    Step__c mileRec;
    Step__c mile1 {get; set;}
    Step__c milestone = new Step__c();
    public List<Step__c> Records {get; set;} 
    Public List<Step__c> milestoneToDelete;
    public Step__c miles;
    public String contextItem{get;set;}
    public String parentId {get;set;} 
    public List<Attachment> taskAttachments {get;set;}
    public blob file_value{get;set;}
    public string file_name{get;set;}
    public boolean displaymilepopup{get;set;}
    public Boolean displayDeleteMilesPopUp{get;set;}
    public Step__c milestonelist{get;set;}
    //Id oppId;
    
    public Attachment a{get;set;}
    /*public String fileName = '';
    public string getfileName(){
        return filename;
        
    }
    public void setfileName(String filenameStr){
        filename = filenameStr;        
    }
    
    public Blob filebody = blob.valueof('');
    public Blob getfileBody(){
        return filebody;        
    }
    
    public void setfileBody(Blob fileb){
        filebody = fileb;    
    }
    public string paramVar{get;set;}
    public Attachment getA(){
        if(a == null){
            a = new Attachment();
        }
        return a;        
    }
    public void setA(Attachment ax){
      a = ax;    
    }*/
    
    //no. of rows added/records in the inner class list
    public Integer count = 1;
    public TaskSteps(ApexPages.StandardController controller) {
       contextItem= '';
       Records = new List<Step__c>();
       milestoneToDelete = new List<Step__c>();
       Records.add(milestone);
       tskRec = (Task__c) controller.getRecord();
       fetchMilestone();
       
       
    }
    
     public void addResponsible(){
    
    }
    
    public void fetchMilestone(){
    
        Records = [Select Id, Name,Due_Date__c,Task_Name__c,Actual_Completion_Date__c,Days_Delay__c,Alert__c,
                                    Status__c,Priority__c,Responsible__c,Comments__c,Is_Mandatory__c from Step__c 
                                    where Task_Name__c = :tskRec.Id ORDER BY Due_Date__c ASC];
                                    
    
    }
    
    public void AddRow() {
       
        //count = count+1;
         mile1= new Step__c();
         
        mile1.Task_Name__c = tskRec.Id;
        mile1.Status__c= 'Not Started';
        mile1.Priority__c= 'None';
        Records.add(mile1);
    } 
   
    
    public PageReference confirmDeleteMilestone(){               
        String stepId = ApexPages.currentPage().getParameters().get('contextItem');
        system.debug('@@taskid'+stepId );
       try{          
           system.debug('@@Id :'+stepId );
            if(stepId != null){
                milestoneToDelete = [Select Id, Name,Due_Date__c,Task_Name__c,Actual_Completion_Date__c,Days_Delay__c,
                                    Status__c,Priority__c,Responsible__c,Comments__c from Step__c 
                                    where Id = :stepId ];
                system.debug('@@list :'+milestoneToDelete);
            }
            if(milestoneToDelete != null){
               delete milestoneToDelete ;
               }
               return new Pagereference('/apex/Wp_steps?id='+tskRec.id).setRedirect(True);
       }catch(Exception ex){
            ApexPages.addMessages(ex);
        return null;
        }
    } 
    
    public PageReference CustomSave(){   //This Function will take the input from the user
    
        try{
            for(Step__c m :Records){
                if(m.Name == null){
                   m.Name.addError('Enter required field : Name');
                   return null;
                }
                    
            }
            upsert Records;
            return new Pagereference('/'+tskRec.id).setRedirect(True);
        }catch(Exception ex){
          ApexPages.addMessages(ex);
          
           return null;
        }
      
    }
    
   public void milefilelist(){
        displaymilepopup=true;
        //parentId='';
        parentId= ApexPages.currentPage().getParameters().get('selectedMilestone'); 
        system.debug(' @@ id :'+ApexPages.currentPage().getParameters().get('selectedMilestone'));
        try{        
            if(parentId!= null){
                milestonelist= [Select name,(SELECT id,name FROM Attachments) from Step__c where id = :parentId];
               system.debug('List :'+milestonelist);
               taskAttachments=new list<attachment>();
               for(Attachment a : milestonelist.attachments){
                taskAttachments.add(a);
                
               }
               }
            
        }Catch(Exception ex){
            system.debug('Exception in Attach file method');
        
        }    
    }
    public void upload() {
        //parentId= ApexPages.currentPage().getParameters().get('selectedMilestone1');
        //milefilelist();
        //system.debug(a.name+'Task id: TID : mytaskid:'+parentId );
         a = new Attachment();    
        system.debug(file_name  +' Attchment: '+ file_name);
        if (file_name != null && file_value != null) {
            
            a.body= file_value;
            a.name = file_name;
            //TODO : Change the name to whatever you want in case you are not getting
            // value in debug statement above
            //a.name= 'New Attachment';
            a.OwnerId = UserInfo.getUserId();
            a.parentId = parentId ;           
            insert a;            
            System.debug('>>>>>>>>>>>>'+taskAttachments);
            a.body= null;
            taskAttachments.add(a);     
            file_value = null;                
        }   
        
        //a=null;
    }
    public void cancelPopUp(){
        //displayEditPopUp = false;
        //displayAttachPopUp = false;
        displaymilepopup= false;
        file_value = null ;
        file_name = null;       
    }
    
    public void deleteAttachment(){
        String attachmentId = ApexPages.currentPage().getParameters().get('attachmentsId'); 
        system.debug('<<<<<<<<<<<<<<<<<'+attachmentId);
        Attachment fileToDelete;  
        try{
            if(attachmentId != null){
                fileToDelete = [select id, name from Attachment where id=: attachmentId];
            }
            
            if(fileToDelete !=null){
            Database.DeleteResult res = Database.delete(fileToDelete, false);
            if(res.isSuccess()){
                system.debug('Delete Successful'+taskAttachments);
                displayDeleteMilesPopUp = false;
                for(integer i=0; i<taskAttachments.size(); i++)
                {
                    if(taskAttachments[i].id==attachmentId){
                        taskAttachments.remove(i);
                    }
                }
                
            }
        }
        }Catch(Exception ex){
            system.debug('Exception in deleting task');
        }             
    } 

}