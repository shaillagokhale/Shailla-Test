// **************************************************************************************
// Purpose         :   This Class is meant to Test Trigger-Workplan_TaskTrigger(on Task__c) and WorkPlan_TaskTriggerHandler 
// Date            :   26-Sept-2014
// Created By      :   TCS 
// Author          :   Gaurav Guleria
// Description     :   Tests all functionality of Trigger-Workplan_TaskTrigger(on Task__c) and WorkPlan_TaskTriggerHandler
// Revisions       :    

//**************************************************************************************
@IsTest
public with sharing class WorkplanTestTaskTriggerHandler {
    
    public static String profilename = 'Solution Manager';
    public static Set<Id> stepRecordIdsSet= new Set<Id>();
    
    static testmethod void testmethod_A(){
        
        //create user
        User newUser                        =   WorkPlanTestUtility.singleUser(profilename);
        insert newUser;
        
        //create Account
        Account AccountRecord               = WorkPlanTestUtility.createTestAccount();
        insert AccountRecord;
        //create Grant
        Grant__c grantRecord                =  WorkPlanTestUtility.createGrant(AccountRecord.Id);
        insert grantRecord;
        
        //create Implementation Period
        Implementation_Period__c ImplementationPeriodRecord =  WorkPlanTestUtility.createIp(AccountRecord.Id,grantRecord.Id);
        insert ImplementationPeriodRecord;
        
        //create milestonelookup record
        Milestone_Lookup__c mlookup = new Milestone_Lookup__c();
        mlookup.Task_Name__c= 'Training Plan';
        mlookup.name='test';
        mlookup.Milestone__c = 'testmilestone';
        mlookup.Duration__c = 5;
         
        insert mlookup;
        
        //create tasklookup record
        Task_Lookup__c tlookup = new Task_Lookup__c();
        tlookup.Task_Type__c = 'Training Plan';
        tlookup.Name='test';
        tlookup.Grant_Cycle__c ='Test';
        
        insert tlookup;
        
        //create Task
        Task__c taskRecord                  = WorkPlanTestUtility.createTask(newUser.Id,ImplementationPeriodRecord.Id);
        insert taskRecord; 
        
        
        
        //create Task records
        List<Task__c> taskRecordsList       = WorkPlanTestUtility.createMultipleTaskRecords(newUser.Id ,ImplementationPeriodRecord.Id);
        insert taskRecordsList;
        
        //create Step record
        Step__c stepRecord             = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord.Id);
        insert stepRecord;
        Step__c stepRecordWithParent   = WorkPlanTestUtility.createMileStone(newUser.Id ,stepRecord.Id ,taskRecord.Id );
        insert stepRecordWithParent;
        
       //create Step records.
        List<Step__c> stepRecordList    = WorkPlanTestUtility.createMultipleMileStone(newUser.Id ,stepRecord.Id ,taskRecord.Id );
        insert stepRecordList;
        for(ID stepRecId : stepRecordIdsSet){
            stepRecordIdsSet.add(stepRecId);    
        }
        
        
        //create multiple Custom-Settimg-Milestone_Lookup(Milestone_Lookup__c) Record
        
        List<Milestone_Lookup__c> mileStoneLookupList = WorkPlanTestUtility.createMultipleMilestoneLookupRecords(stepRecordWithParent.Name,stepRecord.Name,taskRecord.Name);
        
        insert mileStoneLookupList;
        System.Debug('Milestone SIZE@@@@'+mileStoneLookupList.SIZE());
        //create multiple Custom-Settimg-Task_Lookup(Task_Lookup__c) Record
        
        List<Task_Lookup__c> taskLookupList = WorkPlanTestUtility.createMultipleTaskLookupRecords(stepRecord.Name,taskRecord.Name);
        
        insert taskLookupList;
        Test.startTest(); 
        
        //delete Task records
        WorkPlanTaskTriggerHandler.deleteTaskRelatedEvents(taskRecordsList);        
        WorkPlanTaskTriggerHandler.deleteTask(taskRecordsList);        
        WorkPlanTaskTriggerHandler.createEventAndStepRecords(taskRecordsList);
        
        Test.stopTest();
       
    } 

}