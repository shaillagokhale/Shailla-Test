public with sharing class WorkPlanCreateStepsVFPExtension {
    /****/
    String selectedStep{get;set;}
    
    /*****/
    Task__c tskRec;
    Step__c mileRec;
    ID oppId;
    Step__c mile1 {get; set;}
    Step__c milestone = new Step__c();
    public List<Step__c> Records {get; set;} 
    public Step__c miles;
    //no. of rows added/records in the inner class list
    public Integer count = 1;
    public WorkPlanCreateStepsVFPExtension(ApexPages.StandardController controller){
        
      Records = new List<Step__c>();
      Records.add(milestone);
      tskRec = (Task__c) controller.getRecord();
      // mileRec = (Step__c) controller.getRecord();
      oppId = ApexPages.CurrentPage().getParameters().get('id'); 
      system.debug('@@oppId :'+oppId );
      fetchMilestone();
    }
    public void addResponsible(){
    String milestoneId = ApexPages.currentPage().getParameters().get('stepId');
    
    
    }
    public void fetchMilestone(){
    
        Records = [Select Id, Name,Due_Date__c,Task_Name__c,Actual_Completion_Date__c,Days_Delay__c,
                                    Status__c,Priority__c,Responsible__c,Comments__c from Step__c 
                                    where Task_Name__c = :oppId ORDER BY Due_Date__c ASC];
    
    }
     public void AddRow()
    {
       
    //count = count+1;
     mile1= new Step__c();
     
    mile1.Task_Name__c = oppId;
    mile1.Status__c= 'Not Started';
    mile1.Priority__c= 'None';
    Records.add(mile1);
    } 
    
    public void confirmDeleteMilestone(){               
        String milestoneId = ApexPages.currentPage().getParameters().get('selectedMilestone');
        Step__c milestoneToDelete;
        try{
        
            if(milestoneId != null){
                milestoneToDelete = [Select name, id from Step__c where id = :milestoneId];
            }
            if(milestoneToDelete != null){
            Database.DeleteResult res = Database.delete(milestoneToDelete, false);
            if(res.isSuccess()){
                system.debug('Delete Successful');
                //displayDeleteMilesPopUp = false;
            }
        }
        }Catch(Exception ex){
            system.debug('Exception in deleting task');
        
        }
    } 
    
    public PageReference CustomSave(){   //This Function will take the input from the user
    
        
           //refreshPage=true;

         
        try{
            for(Step__c m :Records){
                if(m.Name == null){
                   m.Name.addError('Enter required field : Name');
                   return null;
                }
                    
            }
            upsert Records;
            return new Pagereference('/'+oppId).setRedirect(True);
        }catch(Exception ex){
          ApexPages.addMessages(ex);
          
           return null;
        }
      
    }
}