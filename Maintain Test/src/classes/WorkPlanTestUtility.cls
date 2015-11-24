/////////////////////////////////////////////////////////////////////////////////////////
//
// Purpose     :  This is Utility class used in Test Classes.    
// Date        :  24-Sept-2014
// Created By  :  TCS 
// Author      :  Gaurav Guleria
// Description :  Class to create Test Data
//                        
//
/////////////////////////////////////////////////////////////////////////////////////////
public with sharing class WorkPlanTestUtility {
  
     // Inserting Single User with Profile - 
    public static User singleUser(String profilename){
        
        Profile p                                   = [select Id,name from Profile where name=:profilename  limit 1];
        User newUser                                = new User(
            profileId                               = p.id,
            username                                = System.now().millisecond() + 'PortalUser@yahoo.com',
            email                                   = 'portal@ff.com',
            emailencodingkey                        = 'UTF-8',
            localesidkey                            = 'en_US',
            languagelocalekey                       = 'en_US',
            timezonesidkey                          = 'America/Los_Angeles',
            alias                                   ='nuser',
            lastname                                ='user',
            country                                 = 'TestCountry'
         ); 
        
        return newUser;    
    }
    
     //create single Account
     public static Account createTestAccount(){
        Account acc                             = new Account();
        acc.name                                ='Testusr';
        acc.Short_Name__c                       = 'MOH';        
        acc.Address_line_1__c                   = 'Test Address 1';
        acc.Address_line_2__c                   = 'Test Address 2';
        acc.Address_line_3__c                   = 'Test Address 3';
        acc.Short_Name__c                       = 'MOH';
        //acc.Country__c                          = country_Id ;     
        return acc;
     }
     //single Contact Creation 
    public static Contact createTestContact(Id Account_Id)
    {
        Contact tempContact                     = new Contact(); 
        tempContact.lastName                    = 'testContact 1';        
        tempContact.AccountId                   = Account_Id;
        tempContact.Email                       = 'testAccount@test.com';
        return tempContact;
    }
    
    //create Milestone
     public static Step__c createMileStone(Id User_Id ,Id MileStone_Id,Id Task_Id)
    {
        Step__c mileStoneRecord            = new Step__c(); 
        mileStoneRecord.Name                    = 'Test MileStone';
        //mileStoneRecord.Assigned_To__c          = User_Id;        
        mileStoneRecord.Original_Predecessors__c         = MileStone_Id;
        mileStoneRecord.Task_Name__c                 = Task_Id;
        mileStoneRecord.Original_Duration__c             = 60;
        //mileStoneRecord.Actual_Start_Date__c    = Date.Today()-50;
        //mileStoneRecord.Actual_Completion_Date__c      = Date.Today()+50 ;
        //mileStoneRecord.Original_Start_Date__c           = Date.Today()-50;
        //mileStoneRecord.Scheduled_Start_Date__c   = Date.Today()+4;
        mileStoneRecord.Original_Due_Date__c       = Date.Today()+8;
        return mileStoneRecord;
    }
    //create multiple Milestone records
    public static List<Step__c> createMultipleMileStone(Id User_Id ,Id MileStone_Id,Id Task_Id){
        List<Step__c> mileStoneList = new List<Step__c>();
        for(Integer i=0;i<50;i++){
            Step__c mileStoneRecord            = new Step__c(); 
            mileStoneRecord.Name                    = 'Test MileStone'+i;
            //mileStoneRecord.Assigned_To__c          = User_Id;        
            mileStoneRecord.Original_Predecessors__c         = MileStone_Id;
            mileStoneRecord.Task_Name__c                 = Task_Id;
            mileStoneRecord.Original_Duration__c             = 60;
           // mileStoneRecord.Actual_Start_Date__c    = Date.Today()-50;
            //mileStoneRecord.Actual_Completion_Date__c      = Date.Today()+50 ;
            //mileStoneRecord.Original_Start_Date__c           = Date.Today()-50;
           // mileStoneRecord.Scheduled_Start_Date__c   = Date.Today()+4;
            //mileStoneRecord.Planned_End_Date__c       = Date.Today()+8;
            mileStoneList.add(mileStoneRecord);
        }
        return mileStoneList;
    }
     //create Milestone Without Parent MileStone
     public static Step__c createMileStoneWithoutParentMileStone(Id User_Id ,Id Task_Id)
    {
        Step__c mileStoneRecord            = new Step__c(); 
        mileStoneRecord.Name                    = 'Test MileStone';
        //mileStoneRecord.Assigned_To__c          = User_Id; 
        mileStoneRecord.Task_Name__c                 = Task_Id;
        mileStoneRecord.Original_Duration__c             = 60;
        //mileStoneRecord.Actual_Start_Date__c    = Date.Today()-50;
        //mileStoneRecord.Actual_Completion_Date__c      = Date.Today()+50 ;
       // mileStoneRecord.Original_Start_Date__c           = Date.Today()-49;
        //mileStoneRecord.Scheduled_Start_Date__c   = Date.Today()+4;
        //mileStoneRecord.Planned_End_Date__c       = Date.Today()+8;
        return mileStoneRecord;
    }
    
    public static Grant__c createGrant(Id account_Id){                
        Grant__c objGrant                       = new Grant__c();
        objGrant.Disease_Component__c           =  'Malaria';
        objGrant.Name                           = 'Test';
        objGrant.Principal_Recipient__c         = account_Id;               
        return objGrant;
    }    
    
    public static Implementation_Period__c createIp(Id Account_Id, Id Grant_Id){
        
        Implementation_Period__C ip             = new Implementation_Period__C();
        ip.name                                 = 'Test';
        ip.Principal_Recipient__c               = Account_Id;     
        ip.Grant__c                             = Grant_Id;
        ip.Start_Date__c                        = Date.today();
        //ip.End_Date__c                          =Date.today().addYears(3);
        ip.Length_Years__c                      ='3';        
        return ip;
    }
    //create Single Task
    public static Task__c createTask( Id User_Id,Id ImplementationPeriod_Id)
    {
        RecordType rt = [SELECT id FROM RecordType WHERE Name='Concept Note' AND SobjectType='Task__c' LIMIT 1];        
        Task__c TaskRecord                      = new Task__c(); 
        //TaskRecord.Country__c                   = Country_Id;        
        //TaskRecord.Complete__c                  = 40;
        //TaskRecord.Actual_Start_Date__c         = Date.Today()-50;
        //TaskRecord.Actual_Completion_Date__c           = Date.Today()+50 ;
        //TaskRecord.Assigned_To__c               = User_Id;
        TaskRecord.Comments__c                  = 'Test Comments';
        //TaskRecord.Country__c                   = Country_Id;
        TaskRecord.Grant_Name__c                =  ImplementationPeriod_Id;        
        //TaskRecord.Duration__c                  = 50;
        //TaskRecord.End_Date__c                    = Date.Today()+50 ;
        //TaskRecord.Original_due_date__c           = Date.Today()+50 ;
        //TaskRecord.Original_Start_Date__c       = Date.Today()-50;
        TaskRecord.Status__c                    = 'In Progress;';
        TaskRecord.Name                = 'Test Task';
        TaskRecord.Task_Name__c                 = 'Training Plan';
        TaskRecord.RecordTypeId = rt.Id;
        //TaskRecord.Task__c = 'Test Task';
        return TaskRecord;
    }
     //create Multiple Task
    public static List<Task__c> createMultipleTaskRecords(Id User_Id,Id ImplementationPeriod_Id)
    {
         List<Task__c> TaskRecordList                  = new List<Task__c>();
         for(Integer i=0;i<50;i++){  
            Task__c TaskRecord                      = new Task__c(); 
            //TaskRecord.Country__c                   = Country_Id;        
            //TaskRecord.Complete__c                  = 40;
            //TaskRecord.Actual_Start_Date__c         = Date.Today()-50;
            //TaskRecord.Actual_Completion_Date__c           = Date.Today()+50 ;
            //TaskRecord.Assigned_To__c               = User_Id;
            TaskRecord.Comments__c                  = 'Test Comments';
            //TaskRecord.Country__c                   = Country_Id;
            TaskRecord.Grant_Name__c     = ImplementationPeriod_Id;        
            //TaskRecord.Duration__c                  = 50;
            //TaskRecord.End_Date__c                  = Date.Today()+50 ;
            //TaskRecord.Original_Start_Date__c       = Date.Today()-50;
            TaskRecord.Status__c                    = 'In Progress;';
            TaskRecord.Name                = 'Test Task';
            TaskRecord.Task_Name__c                 = 'Training Plan';
            TaskRecordList.add(TaskRecord);
            
         }
         return TaskRecordList;
    }
    //create Custom-Settimg-Milestone_Lookup(Milestone_Lookup__c) Record
     public static Milestone_Lookup__c createMilestoneLookup(String milestone,String predecessor,String Task_Name){
        Milestone_Lookup__c mileLookUp = new Milestone_Lookup__c();
        mileLookUp.Name = 'Test MileLookUp1';
        mileLookUp.Duration__c = 50;
        mileLookUp.Milestone__c = milestone;
        mileLookUp.Predecessor__c = predecessor;
        mileLookUp.Task_Name__c = Task_Name;
        
        
        return mileLookUp;
     }
     //create multiple of Milestone Lookup records
     public static List<Milestone_Lookup__c> createMultipleMilestoneLookupRecords(String milestone,String predecessor,String Task_Name){
        List<Milestone_Lookup__c> mileStoneLookUpList = new List<Milestone_Lookup__c>();
        for(Integer i=0;i<50;i++){            
            Milestone_Lookup__c mileLookUp = new Milestone_Lookup__c();
            mileLookUp.Name = 'Test MileLookUp'+Math.Random();
            mileLookUp.Duration__c = 50;
            mileLookUp.Milestone__c = milestone;
            mileLookUp.Predecessor__c = predecessor;
            mileLookUp.Task_Name__c = Task_Name;
            mileStoneLookUpList.add(mileLookUp);
        }
        return mileStoneLookUpList;
     }
     //create Custom-Setting-Task_Lookup(Task_Lookup__c) Record
     public static Task_Lookup__c createTaskLookup(String grantCycle,String predecessor,String Task_Name){
        Task_Lookup__c taskLookUp = new Task_Lookup__c();
        taskLookUp.Name = 'Test MileLookUp1';
        taskLookUp.Task_Type__c = Task_Name;
        TaskLookUp.Grant_Cycle__c = grantCycle;
        
        
        return taskLookUp;
     }
      //create multiple of Task Lookup records
     public static List<Task_Lookup__c> createMultipleTaskLookupRecords(String grantCyle,String Task_Name){
        List<Task_Lookup__c> TaskLookUpList = new List<Task_Lookup__c>();
        for(Integer i=0;i<50;i++){            
            Task_Lookup__c TaskLookUp = new Task_Lookup__c();
            TaskLookUp.Name = 'Test MileLookUp'+Math.Random();
            TaskLookUp.Grant_Cycle__c = grantCyle;
            TaskLookUp.Task_Type__c = Task_Name;
            
            TaskLookUpList.add(TaskLookUp);
        }
        return TaskLookUpList;
     }
      //create multiple of Responsible records
      
     public static List<Responsible__c> createMultipleResponsibleRecords(Id taskId, Id stepId,Id userId){
        List<Responsible__c> responsibleList = new List<Responsible__c>();
        for(Integer i=0;i<50;i++){            
            Responsible__c res = new Responsible__c();
            res.Responsible__c = userId;
            res.Task__c = taskId;
            res.Step__c = stepId;
            
            responsibleList.add(res);
        }
        return responsibleList;
     }
}