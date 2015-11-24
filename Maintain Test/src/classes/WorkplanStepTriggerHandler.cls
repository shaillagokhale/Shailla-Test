//***************************************************************************************

// Purpose     :  This Class is handler for Trigger-Workplan_StepTrigger.    
// Date        :  25-Sep-2014
// Created By  :  TCS  
// Author      :  Gaurav Guleria
// Description :  This class inserts the Standard Event on the insertion of the Step records.
//                
//                
//                
// Revision:   :  By Gaurav Guleria dated: 17 Oct.2014:
//                1)If Step is Sequential then Scheduled Start Date(Scheduled_Start_Date__c) is equal to the
//                  Due Date(Due_Date__c) from Predecessor(Step)
//                2)Original Due Date = Original Due Date(From Predecessor)-Duratin(From Step custom Setting)
//                3)Scheduled Start Date = Scheduled Due Date - Original Duration
//                4)Execute Business rules in Step
public with sharing class WorkplanStepTriggerHandler {
    
    /*public static void insertTaskAndEvent(List<Step__c> stepRecordsListforInsert, Set<Id> stepRecordIds){
        Map<Id, Implementation_Period__c> Ipmap = new Map<Id, Implementation_Period__c >([select Id, Name from Implementation_Period__c ]);
        Map<Id, Step__c> milestoneMap = new Map<Id, Step__c>([select Name, Task_Name__c,  
                                    Actual_Completion_Date__c, Status__c, Task_Name__r.Grant_Name__c from Step__c
                                    where id IN :stepRecordIds]);
        Implementation_Period__c ip;
        List<task> tskList = new List<task>();
        List<Event> eventList = new List<Event>();
        for(Step__c mileStone : stepRecordsListforInsert){ 
           if(mileStone.Due_Date__c!= null){
              Event eventRecord = new Event();
              eventRecord.subject = mileStone.Name;
              eventRecord.StartDateTime = mileStone.Due_Date__c;
              eventRecord.EndDateTime= mileStone.Due_Date__c; 
              eventRecord.ActivityDate = mileStone.Due_Date__c;
              eventRecord.Ownerid= userinfo.getUserid() ;
             // eventRecord.whatId = mileStone.IP__c;
              
              eventList.add(eventRecord);
           }
              //create Task Record
              if(mileStone.id!=NULL){
                  Step__c mileStoneRecord = milestoneMap.get(mileStone.id);                          
                           
              if(mileStoneRecord != null && mileStone!=NULL){
                Task taskRecord = new Task();
                if(mileStoneRecord.Task_Name__r.Grant_Name__c != null && mileStone.Due_Date__c!= null){
                    ip = ipMap.get(mileStoneRecord.Task_Name__r.Grant_Name__c);
                    taskRecord.Whatid = ip.id;
                    system.debug('IP ID in Milestones : ' + mileStoneRecord.Task_Name__r.Grant_Name__c);
                    taskRecord.subject = ip.name+' : '+mileStone.Name;
                    taskRecord.Start_Date__c = mileStone.Due_Date__c;
                    taskRecord.ActivityDate = mileStone.Due_Date__c;
                    //taskRecord.Actual_Start_Date__c = mileStone.Actual_Start_Date__c;
                    //taskRecord.Actual_End_Date__c = mileStone.Actual_End_Date__c;
                    //taskRecord.Ownerid= mileStone.Assigned_To__c;
                    taskRecord.status = mileStone.status__c;
                    taskRecord.Description = mileStone.Comments__c;                  
                    system.debug('list1 :' +taskRecord);
                    tskList.add(taskRecord); 
                }                  
                
              }
           }
        }
        //insert Task List
        if(!tskList.Isempty()){
            insert tskList;
        }
        //Insert Event List
        if(!eventList.Isempty())
            upsert eventList;   
    }*/
    /*public static void updateEventRecords(List<Step__c> stepRecordsListforUpdate){
        
        List<Event> updateEventList = new List<Event>();
        Set<String> mileSet = new Set<String>();
        List<Event> processUpdatedTask = new List<Event>();
        Map<String,Step__c> mileMap = new Map<String,Step__c>(); 
        for(Step__c m : stepRecordsListforUpdate){
            mileSet.add(m.Id);
            mileMap.put(m.Id,m);
        }
        if(mileSet.SIZE()>0){
            processUpdatedTask = [Select id,subject,StartDateTime,EndDateTime,ActivityDate,Ownerid,whatId  from Event where whatid IN : mileSet];
        }    
            if(processUpdatedTask.SIZE()>0){
                for(Event t :processUpdatedTask ){
                      if(mileMap.ContainsKey(t.whatId)){
                          if(t.whatId!=NULL){
                              t.subject = mileMap.get(t.whatId).IP__c+' : '+mileMap.get(t.whatId).Name;
                              t.StartDateTime = mileMap.get(t.whatId).Due_Date__c;
                              t.EndDateTime= mileMap.get(t.whatId).Due_Date__c; 
                              t.ActivityDate = mileMap.get(t.whatId).Due_Date__c;
                              t.Ownerid= userinfo.getUserid();
                             // t.whatId = mileMap.get(t.Milestone_Id__c).IP__c;
                              t.whatId = mileMap.get(t.whatId).Id;
                              updateEventList.add(t);
                          }
                      }
                }
                update updateEventList;
            }
         
    }*/
    public static void updateStepRelatedEvents(List<Step__c> oldStepRecordsListforDelete){
        
        Set<String> tskSet = new Set<String>(); 
        for(Step__c m : oldStepRecordsListforDelete){
            tskSet.add(m.Id);
        }
        
        List<Event> deleteMileRelatedEvent = [Select id,subject,StartDateTime,EndDateTime,ActivityDate,Ownerid,whatId  from event where whatId IN : tskSet ];
        if(deletemileRelatedEvent != null)
            delete deleteMileRelatedEvent;
    }
    
    //Executes Business Rules in Step
   public static void executeBusinessRules(List<Step__c> stepRecordsList){
        
        List<Milestone_Lookup__c> stepLookUpList = new List<Milestone_Lookup__c>();        
        List<Milestone_Lookup__c> customStepLookUpList = new List<Milestone_Lookup__c>();
        Set<String> mileLookUpPredecessorNameSet = new Set<String>();
        List<Step__c> predecessorList = new List<Step__c>(); 
        Set<Id> taskIdSet = new Set<Id>();
        List<Task__c> taskList = new List<Task__c>();
        //Map with Task Id as KEY and Task Record(Task__c) as VALUE
        Map<Id,Task__c> taskId_TaskRecordMap = new Map<Id,Task__c>();
        stepLookUpList = [SELECT Duration__c,Milestone__c,Predecessor__c,Task_Name__c,Calculate_Business_Days__c,
                                 Lock_Due_Date__c   FROM Milestone_Lookup__c]; 
        for(Milestone_Lookup__c milook :stepLookUpList){
            mileLookUpPredecessorNameSet.Add(milook.Predecessor__c); //add predecessor from custom setting
            
        }
        predecessorList = [SELECT id,Name,Task_Name__r.Task_Name__c,Task_Name__r.Grant_Name__c,Task_Name__c, Original_Due_Date__c,Original_Duration__c, Lock_Due_Date__c FROM Step__c 
                            WHERE Name IN:mileLookUpPredecessorNameSet];
        for(Step__c milst :stepRecordsList){
            taskIdSet.add(milst.Task_Name__c);
        }        
        taskList = [SELECT id,Task_Name__c, Grant_Name__c from Task__c  WHERE ID IN:taskIdSet];
        for(Task__c tsk:taskList){
            taskId_TaskRecordMap.put(tsk.Id,tsk);
        
        }
        for(Step__c milst :stepRecordsList){
            for(Milestone_Lookup__c milook:stepLookUpList){             
                for(Step__c predess : predecessorList){
                Task__c tsk = new Task__c();
                tsk = taskId_TaskRecordMap.get(milst.Task_Name__c);
                    //checking Milestone name from Custom setting & Matching Task ID & Checking Predecessor present in Environment & Steps From Same Grant
                    if(milst.Name == milook.Milestone__c && tsk.Task_Name__c== milook.Task_Name__c && 
                    tsk.Grant_Name__c == predess.Task_Name__r.Grant_Name__c && predess.name == milook.Predecessor__c){ 
                        //Populate Predecessor in Milestone
                        milst.Original_Predecessors__c = predess.Id; 
                        //Pick Duration from related Step Custom Setting
                        milst.Original_Duration__c = milook.Duration__c;
                        milst.Lock_Due_Date__c= milook.Lock_Due_Date__c;
                        System.debug('@@Duration'+milst.Original_Duration__c);
                        //Calculate Difference between Original Due Date(Original_Due_Date__c) in Step Record
                        //Original Due Date = Original Due Date(From Predecessor)-Duration(From Step custom Setting)
                        //This will exclude Weekends and consider only Business days
                        if(milook.Calculate_Business_Days__c==TRUE){
                            Date originalDueDate = predess.Original_Due_Date__c;
                            Date actualDueDate   = predess.Original_Due_Date__c;
                            
                            DateTime originalDueDateTime = DateTime.Now();
                            DateTime actualDueDateTime   =   DateTime.Now();
                            if(originalDueDate!=NULL){
                                originalDueDateTime = dateTime.newInstance(originalDueDate.year(), originalDueDate.month(),originalDueDate.day());  
                            }
                            if(actualDueDate!=NULL){
                                    actualDueDateTime =   dateTime.newInstance(actualDueDate.year(), actualDueDate.month(),actualDueDate.day());
                            }
                            if(milst.Original_Duration__c!= NULL){
                                    actualDueDateTime =     actualDueDateTime+milst.Original_Duration__c;
                            }
                            if(actualDueDateTime< originalDueDateTime){ 
                                WHILE(actualDueDateTime <= originalDueDateTime){
                                    if (originalDueDateTime.format('E') == 'Sat' || originalDueDateTime.format('E') == 'Sun'){                                
                                        actualDueDateTime-=1;                                
                                    }
                                        originalDueDateTime -= 1;
                                }
                            }
                            else{
                                WHILE(actualDueDateTime >= originalDueDateTime){
                                    if (originalDueDateTime.format('E') == 'Sat' || originalDueDateTime.format('E') == 'Sun'){                                
                                        actualDueDateTime+=1;                                
                                    }
                                        originalDueDateTime += 1;
                                }
                            
                            }
                            milst.Original_Due_Date__c = actualDueDateTime.Date();
                            system.Debug('@@Business Rule Date'+milst.Original_Due_Date__c);
                            system.debug('@@In TRUE Loop');
                            
                        }
                        else{//Calculate_Business_Days__c==FALSE
                            if(predess.Original_Due_Date__c!=NULL && milst.Original_Duration__c!=NULL){
                                milst.Original_Due_Date__c =    predess.Original_Due_Date__c.addDays(Integer.valueof(milst.Original_Duration__c));
                                system.debug('@@In FALSE Loop');
                            }
                        }
                    }
                }
            }
        }    
    }
    //Update Business Rule Date On Step When Predecessor Is Updated
    
    public static void updateBusinessRuleDateOnStepWhenPredecessorIsUpdated(List<Step__c> oldstepRecordsList, List<Step__c> newstepRecordsList){
        Set<Id> predecessorIdSet = new Set<Id>();       
           
        List<Milestone_Lookup__c> stepLookUpList= new List<Milestone_Lookup__c>([SELECT Calculate_Business_Days__c,Duration__c,Milestone__c,
                                                Predecessor__c,Task_Name__c, Lock_Due_Date__c FROM Milestone_Lookup__c]);
        for(Step__c newmist: newstepRecordsList){
            for(Step__c oldmist : oldstepRecordsList){
                if(newmist.Id == oldmist.Id && newmist.Original_Due_Date__c!= oldmist.Original_Due_Date__c){
                    predecessorIdSet.add(newmist.Id);System.Debug('@@In old and new check');
                }
            }   
        }
            
        if(predecessorIdSet.SIZE()>0){
            List<Step__c> mileStoneRecordsList= new List<Step__c>();
            List<Step__c> mileStonePredecessorList= new List<Step__c>();
            mileStoneRecordsList = [SELECT Original_Due_Date__c,Original_Predecessors__c,Task_Name__c,Task_Name__r.Grant_Name__c,
                                    Original_Predecessors__r.Name FROM Step__c WHERE Original_Predecessors__c IN:predecessorIdSet];
            system.Debug(mileStoneRecordsList);                        
            mileStonePredecessorList = [SELECT id,Original_Due_Date__c,Task_Name__c,Task_Name__r.Grant_Name__c FROM Step__c WHERE ID IN:predecessorIdSet];                           
            for(Step__c milst :mileStoneRecordsList){
                for(Step__c predmil :mileStonePredecessorList){
                    if(milst.Original_Predecessors__c == predmil.Id  && milst.Task_Name__r.Grant_Name__c==predmil.Task_Name__r.Grant_Name__c){
                        milst.Original_Due_Date__c = predmil.Original_Due_Date__c;
                        System.Debug('@@In Last loop');
                    }
                }
            }
            update mileStoneRecordsList;
        }
    }
    
    //This method is implemented for US#7564, to update the status of the TAsk dependent on the status of the related task.
    public static void updateTaskStatus(List<Step__c> stepRecordsListforUpdate){
        integer cancelStep=0; //to count the step having status as CANCEL 
        integer completeStep=0; //to count the step having status as COMPLETED
        integer inprogressStep=0; //to count the step having status as INPROGRESS
        integer ntstartStep=0; //to count the step having status as NOT STARTED
        Task__c tsk = new Task__c();
        list<id> milelist = new list<id>();
        for(Step__c m : stepRecordsListforUpdate){
            milelist.add(m.Task_Name__c);
        }
        tsk = [select id,Is_Mandatory__c  from Task__c where id =: milelist[0]];
        list<Step__c> mList= new list<Step__c>([select id, status__c, Is_Mandatory__c from Step__c where Task_Name__c =: tsk.id]); // List of milestone associated with TASK
        for(Step__c m : mList){
            if(m.Status__c == 'Not Started'){
                ntstartStep = ntstartStep+1;// Count +1
            }
            else if (m.Status__c == 'In Progress'){
                inprogressStep=inprogressStep+1;
            }
            else if (m.Status__c == 'Completed'){
                completeStep=completeStep+1;
            }
            else if (m.Status__c == 'Cancelled'){
                cancelStep=cancelStep+1;
            }
            if(tsk.Is_Mandatory__c == false){
                tsk.Is_Mandatory__c = m.Is_Mandatory__c;    
            }    
        }
        
        if(mList.size() == (cancelStep+ntstartStep) && ntstartStep >0) {
            tsk.Status__c = 'Not Started';
        }
        else if(mList.size() == cancelStep){
            tsk.Status__c = 'Cancelled';
        }
        else if(mList.size() == (completeStep+cancelStep) && completeStep>0){
            tsk.Status__c = 'Completed';
        }
        else{
            tsk.Status__c = 'In Progress';
        }
        update tsk; // Update the TASK Status
    }
    
    //This function is to restrict user for deleting the mandatory record
   public static void deleteSteps(List<Step__c> oldStepsListforDelete){
        Set<String> stepsSet = new Set<String>(); 
        for(Step__c steps : oldStepsListforDelete){
            if(steps.Is_Mandatory__c==false){
                stepsSet.add(steps.Id);   
            }          
            else if(steps.Is_Mandatory__c==true){
                steps.adderror('You are Not allowed to delete Mandatory Step.');
            }
        }
    }  
    
    //This function is require to create Events for the steps with the alert Marked.
    public static void insertStepsEvent(List<Step__c> stepRecordsList){
        List<Event> eventList = new List<Event>();
        List<Event> deleteEventList = new List<Event>();
        List<Event> processUpdatedTask = new List<Event>();
        Map<String,Step__c> mileMap = new Map<String,Step__c>(); 
        Set<String> mileSet = new Set<String>();
        for(Step__c m : stepRecordsList){
            mileSet.add(m.Id);
            mileMap.put(m.Id,m);
        }
        if(stepRecordsList.SIZE()>0){
            processUpdatedTask = [Select id,subject,StartDateTime,EndDateTime,ActivityDate,Ownerid,whatId  from Event where whatid IN : mileSet];
        }    
            if(processUpdatedTask.SIZE()>0){
                for(Event e :processUpdatedTask ){
                      if(mileMap.ContainsKey(e.whatId)){
                          if(e.whatId!=NULL){
                            if(mileMap.get(e.whatId).Alert__c==true){
                                e.subject = mileMap.get(e.whatId).IP__c+' : '+mileMap.get(e.whatId).Name;
                                e.IsAllDayEvent = true;
                                e.ActivityDate = mileMap.get(e.whatId).Due_Date__c;
                                e.Ownerid= userinfo.getUserid();
                                // t.whatId = mileMap.get(t.Milestone_Id__c).IP__c;
                                e.whatId = mileMap.get(e.whatId).Id;
                                eventList.add(e);
                            } else if(mileMap.get(e.whatId).Alert__c==false){
                                deleteEventList.add(e);
                            }   
                          }
                      }
                }
                update eventList;
                delete deleteEventList;
            }else {         
                for(Step__c mileStone : stepRecordsList){
                      
                    if(mileStone.Due_Date__c!= null && mileStone.Alert__c==true){
                        system.debug('@@@test :'+Milestone.Responsible__c);
                        
                            Event eventRecord = new Event();
                            eventRecord.subject = mileStone.IP__c +' : ' +mileStone.Name;
                            eventRecord.IsAllDayEvent = true;
                            eventRecord.ActivityDate = mileStone.Due_Date__c;
                            eventRecord.Ownerid= userinfo.getUserid();
                            // eventRecord.whatId = mileStone.IP__c;
                            eventRecord.whatId = mileStone.Id;
                            eventList.add(eventRecord);
                        }    
                    }
                
        //Insert Event List
        if(!eventList.Isempty())
            upsert eventList; 
        }
    }     
}