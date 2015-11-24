public with sharing class TaskStepsTravel {

   


    Task__c tskRec;
    Step__c mileRec;
    Step__c mile1 {get; set;}
    Step__c milestone = new Step__c();
    public List<Step__c> Records {get; set;} 
    Public List<Step__c> milestoneToDelete;
    public Step__c miles;
    public String contextItem{get;set;} 
    //Id oppId;
    
    //no. of rows added/records in the inner class list
    public Integer count = 1;
    public TaskStepsTravel(ApexPages.StandardController controller) {
    
     //mile1 = new Step__c();
      ID rtId = [SELECT Id FROM RecordType WHERE sObjectType='Step__c' AND Name='Travel Step'].Id;
      milestone = (Step__c)Step__c.sObjectType.newSObject(rtId, true);
       contextItem= '';
       Records = new List<Step__c>();
       milestoneToDelete = new List<Step__c>();
       Records.add(milestone);
       tskRec = (Task__c) controller.getRecord();
       //oppId = controller.getRecord().Id;
       fetchMilestone();
     
    }
     public void addResponsible(){
    
    }
    public void fetchMilestone(){
    
        Records = [Select Id, Name,Due_Date__c,Country__c,Country_Code__c,Alert__c,Start_Date__c,RecordType.name,
End_Date__c,Task_Name__c,Actual_Completion_Date__c,Days_Delay__c,
                                    Status__c,Priority__c,Responsible__c,Comments__c,Is_Mandatory__c from Step__c 
                                    where Task_Name__c = :tskRec.Id ORDER BY Start_Date__c ASC];
                                    
    
    }
    public void AddRow() {
        Id recId = Schema.SObjectType.Step__c.getRecordTypeInfosByName().get('Travel Step').getRecordTypeId();

        //count = count+1;
        mile1= new Step__c();
        mile1.RecordTypeId = recId;
        
        mile1.Task_Name__c = tskRec.Id;
        mile1.Status__c= 'Tentative';
        mile1.Priority__c= 'None';
        Records.add(mile1);
    } 
    
    
   
    
    
    
    
    public PageReference confirmDeleteMilestone(){               
        String stepId = ApexPages.currentPage().getParameters().get('contextItem');
        system.debug('@@taskid'+stepId );
       try{          
           system.debug('@@Id :'+stepId );
            if(stepId != null){
                milestoneToDelete = [Select Id, Name,Due_Date__c,Country__c,Country_Code__c,Start_Date__c,End_Date__c,Task_Name__c,Actual_Completion_Date__c,Days_Delay__c,
                                    Status__c,Priority__c,Responsible__c,Comments__c from Step__c 
                                    where Id = :stepId ];
                system.debug('@@list :'+milestoneToDelete);
                //return new Pagereference('/'+tskRec.id).setRedirect(True);
            }
            if(milestoneToDelete != null){
               delete milestoneToDelete ;
               //return new Pagereference('/'+tskRec.id).setRedirect(True);
               //return null;
               }
               //else{return null;}
               
               return new Pagereference('/apex/Wp_steps?id='+tskRec.id).setRedirect(True);
       }catch(Exception ex){
            ApexPages.addMessages(ex);
        return null;
        }
    } 
    
    public PageReference CustomSave(){   //This Function will take the input from the user
      // Id recId = Schema.SObjectType.Step__c.getRecordTypeInfosByName().get('Travel Step').getRecordTypeId();
        try{
            for(Step__c m :Records){
                if(m.Name == null){
                   m.Name.addError('Enter required field : Name');
                   
                   return null;
                }
                
                //m.RecordTypeId = recId ;
                
            }
            upsert Records;
            return new Pagereference('/'+tskRec.id).setRedirect(True);
        }catch(Exception ex){
          ApexPages.addMessages(ex);
          
           return null;
        }
      
    }
    
   

}