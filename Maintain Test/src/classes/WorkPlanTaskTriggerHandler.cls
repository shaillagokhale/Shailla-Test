//***************************************************************************************

// Purpose     :  This Class is handler for Trigger-Workplan_TaskTrigger.    
// Date        :  25-Sep-2014
// Created By  :  TCS 
// Author      :  Gaurav Guleria
// Description :  This class inserts the Standard Event and Milestone on the insertion of the Task. 
//                
//                
//                
// Revision:   :  
//  
public with sharing class WorkPlanTaskTriggerHandler {

    public static void createEventAndStepRecords(List<Task__c> taskList){
        List<Event> eventRecordList = new List<Event>();
        //Fetch all Milestone Lookup custom setting records
        List<Milestone_Lookup__c > miles = new List<Milestone_Lookup__c >([select Milestone__c, Task_Name__c, duration__c, 
                                                Predecessor__c, Lock_Due_Date__c,Is_Mandatory__c from Milestone_Lookup__c ORDER by Name ]);
        //Milestone Lookup Map                                      
        Map<string, Milestone_Lookup__c> milemap = new Map<string, Milestone_Lookup__c>();      
        List<Step__c> stepRecordsList = new List<Step__c>();
        List<Milestone_Lookup__c> milestone = new  List<Milestone_Lookup__c>();
        for(Task__c tsk : taskList){
            //Revision by Gaurav Guleria for Merging Dated: 25 Sep. 2014 
            System.Debug('Start Date@@@@@@'+miles.SIZE());  
            milestone = new List<Milestone_Lookup__c>();
            String taskname = tsk.Task_Name__c;
            if(taskname != 'Adhoc' ){
                if(miles.size()> 0){        
                    for(Milestone_Lookup__c  mle : miles ){
                        if(mle.Task_Name__c == tsk.Task_Name__c){
                            milestone.add(mle);
                            milemap.put(mle.Milestone__c, mle);
                        }
                    }
                //system.debug(tsk.Name+'Milestive records :' +milestone +'&'+tsk.Original_Start_Date__c); 
                date dt;
                for(integer i=0;i<milestone.size();i++){
                    Step__c m = new Step__c();
                    m.Name = milestone[i].Milestone__c ;
                    m.Lock_Due_Date__c = milestone[i].Lock_Due_Date__c ;
                    m.Is_Mandatory__c= milestone[i].Is_Mandatory__c;
                    m.status__c = 'Not Started';
                    m.Task_Name__c = tsk.Id;
                    stepRecordsList.add(m);
                  
                    }
                }
                    
            }
           else if(taskname == 'Adhoc' ){
            Step__c m = new Step__c();
                if(m.Name == null){
                    m.Name = tsk.Name;
                }
                m.status__c = 'Not Started';
                m.Task_Name__c = tsk.Id;
                insert m;
                
           }
        }
        //insert MileStone List 
        if(stepRecordsList.Size()>0){
            insert stepRecordsList; 
        }
    }
    public static void deleteTaskRelatedEvents(List<Task__c> oldTaskListforDelete){
        Set<String> tskSet = new Set<String>(); 
        for(Task__c m : oldTaskListforDelete){
            tskSet.add(m.Id);
        }
        List<Event> deleteTaskRelatedEvent = [Select id,subject,StartDateTime,EndDateTime,ActivityDate,Ownerid,whatId  
                                              FROM event where whatId IN : tskSet ];
        if(deleteTaskRelatedEvent != null){
            delete deleteTaskRelatedEvent;      
        }
            
    }
    
    public static void updateWeekNumber(List<Task__c > taskListforUpdate){
        
    }
    
    // This function is to update the Business Logic with the help of Task_Lookup custom setting
   // This function is to update the Business Logic with the help of Task_Lookup custom setting
    /*public static void updateTaskBusinessLogic(List<Task__c> taskListforUpdate){
        Set<String> tskSet = new Set<String>();
        list<Task_Lookup__c> predlist = new list<Task_Lookup__c>();
        list<Task__c> tsklist = new list<Task__c>();
        list<Task__c> predtsklist = new list<Task__c>([select Task_Name__c, Grant_Name__c,Original_due_date__c from Task__c]);
        list<Task_Lookup__c> tskcslst = new list<Task_Lookup__c>([select Task_Type__c, Predecessor__c, Duration__c, Calculate_Business_Days__c,Is_Mandatory__c from Task_Lookup__c ORDER by Name]);
        for(Task__c tsk : taskListforUpdate){
            if(tsk.Task_Name__c!= null){
                if(tskcslst.size()>0){
                    for(Task_Lookup__c t : tskcslst){
                        if(t.Task_Type__c == tsk.Task_Name__c){
                            tsk.Is_Mandatory__c=t.Is_Mandatory__c;
                            predlist.add(t);
                        }
                    }
                    
                }
            }
            system.debug('***predlist**'+predlist);
            if(predlist.size()>0){
                for(Task__c pt : predtsklist){
                    
                    if(predlist[0].Predecessor__c == pt.Task_Name__c & tsk.Grant_Name__c == pt.Grant_Name__c){
                        tsk.Original_Predecessor__c=pt.id;
                        //tsk.Is_Mandatory__c = predlist[0].Calculate_Business_Days__c;
                        //tsk.Is_Mandatory__c=predlist[0].Is_Mandatory__c;
                        system.debug(predlist[0].Duration__c+'***pt**'+pt.Original_due_date__c);
                        if(predlist[0].Calculate_Business_Days__c == false){
                            system.debug(predlist[0].Duration__c+'***pt**'+pt.Original_due_date__c);
                            
                            tsk.Original_due_date__c = pt.Original_due_date__c.addDays(Integer.valueof(predlist[0].Duration__c));
                        }
                    else if (predlist[0].Calculate_Business_Days__c == true){//to calculate the Business Days
                        Date scheduledStartDate = pt.Original_due_date__c;
                        system.debug('@@scheduledStartDate'+scheduledStartDate);
                        Date actualStartDate = pt.Original_due_date__c;
                        system.debug('@@actualStartDate'+actualStartDate);
                        DateTime scheduledStartDateTime = System.Now();                        
                        DateTime actualStartDateTime = System.Now(); 
                        if(scheduledStartDate!=NULL){                    
                            scheduledStartDateTime = dateTime.newInstance(scheduledStartDate.year(), scheduledStartDate.month(),scheduledStartDate.day());
                            system.debug('@@scheduledStartDateTime'+scheduledStartDateTime);
                        }                   
                        if(actualStartDate!=NULL){
                            actualStartDateTime = dateTime.newInstance(actualStartDate.year(), actualStartDate.month(),actualStartDate.day());
                        }
                        if(predlist[0].Duration__c!=NULL){
                            actualStartDateTime -=  predlist[0].Duration__c;
                            system.debug('@@actualStartDateTime'+actualStartDateTime);
                        }                        
                        while (actualStartDateTime <= scheduledStartDateTime) {
                            if (scheduledStartDateTime.format('E') == 'Sat' || scheduledStartDateTime.format('E') == 'Sun'){                                
                                actualStartDateTime-=1;                                
                            }
                            scheduledStartDateTime-=1;
                            system.debug('@@scheduledStartDateTime1'+scheduledStartDateTime);
                        }
                    tsk.Original_due_date__c = actualStartDateTime.Date();
                    
                    system.debug('@@final'+actualStartDateTime.Date());
                    system.debug('@@final'+tsk.Original_due_date__c);
                   // update tsk;
                    }
                }
            }   
        }
    }
  }*/
  
  //This function is to restrict user for deleting the mandatory record
   public static void deleteTask(List<Task__c> oldTaskListforDelete){
        Set<String> tskSet = new Set<String>(); 
        for(Task__c t : oldTaskListforDelete){
            if(t.Is_Mandatory__c==false){
                tskSet.add(t.Id);   
            }          
            else if(t.Is_Mandatory__c==true){
                t.adderror('You are Not allowed to delete Mandatory Task.');
            }
        }
    }
    
    //This function is to update the child record of the predecessor.
    /*public static void updatePredChild(List<Task__c> taskListforUpdate){
        Set<String> tskSet = new Set<String>();
        list<Task__c> predlist = new list<Task__c>(); 
        list<Task_Lookup__c> tskcslst = new list<Task_Lookup__c>([select Task_Type__c, Predecessor__c, Duration__c, Calculate_Business_Days__c,Is_Mandatory__c from Task_Lookup__c ORDER by Name]);
        for(Task__c tsk : taskListforUpdate){
            predlist.add(tsk);
        }
        system.debug('Predlist :'+predlist);
        if(predlist != null){
            list<Task__c> tsklist = new list<Task__c>([select Original_due_date__c,Task_Name__c,Grant_Name__c from Task__c where Original_Predecessor__c =: predlist[0].Id]);
            system.debug('tsklist :'+tsklist);
        
        if(tsklist!=null){
            for(Task__c tsk : tsklist){
                for(Task_Lookup__c tskcs : tskcslst){
                    if(tsk.Task_Name__c==tskcs.Task_Type__c){
                        if(tskcs.Calculate_Business_Days__c == false){
                            tsk.Original_due_date__c = predlist[0].Original_due_date__c.addDays(Integer.valueof(tskcs.Duration__c));
                        }
                        else if(tskcs.Calculate_Business_Days__c == true){
                            Date scheduledStartDate = predlist[0].Original_due_date__c;
                            system.debug('@@scheduledStartDate'+scheduledStartDate);
                            Date actualStartDate = predlist[0].Original_due_date__c;
                            system.debug('@@actualStartDate'+actualStartDate);
                            DateTime scheduledStartDateTime = System.Now();                        
                            DateTime actualStartDateTime = System.Now(); 
                            if(scheduledStartDate!=NULL){                    
                                scheduledStartDateTime = dateTime.newInstance(scheduledStartDate.year(), scheduledStartDate.month(),scheduledStartDate.day());
                                system.debug('@@scheduledStartDateTime'+scheduledStartDateTime);
                            }                   
                            if(actualStartDate!=NULL){
                                actualStartDateTime = dateTime.newInstance(actualStartDate.year(), actualStartDate.month(),actualStartDate.day());
                            }
                            if(tskcs.Duration__c!=NULL){
                                actualStartDateTime -=  tskcs.Duration__c;
                                system.debug('@@actualStartDateTime'+actualStartDateTime);
                            }                        
                            while (actualStartDateTime <= scheduledStartDateTime) {
                                if (scheduledStartDateTime.format('E') == 'Sat' || scheduledStartDateTime.format('E') == 'Sun'){                                
                                    actualStartDateTime-=1;                                
                                }
                            scheduledStartDateTime-=1;
                            system.debug('@@scheduledStartDateTime1'+scheduledStartDateTime);
                        }
                        tsk.Original_due_date__c = actualStartDateTime.Date();
                        system.debug('@@final'+actualStartDateTime.Date());
                        system.debug('@@final'+tsk.Original_due_date__c);                                      
                        }
                    }
                }
                update tsk;
            }
        } 
        }     
    }*/
}