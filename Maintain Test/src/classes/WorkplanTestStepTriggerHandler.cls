// **************************************************************************************
// Purpose         :   This Class is meant for Trigger-Workplan_StepTrigger(on Step__c) and Class-Workplan_StepTriggerHandler
// Date            :   24-Sept-2014
// Created By      :   TCS 
// Author          :   Gaurav Guleria
// Description     :   Used to Test Trigger-Workplan_StepTrigger(Step__c) and Class-Workplan_StepTriggerHandler
// Revisions       :    

//**************************************************************************************
@isTest
public class WorkplanTestStepTriggerHandler {
    public static String profilename = 'Solution Manager';
    public static Set<Id> stepRecordIdsSet= new Set<Id>();
    static testmethod void testmethod_A(){
        
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
        stepRecord.Original_Due_Date__c = System.today()+5;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecord;
        Step__c stepRecordWithParent   = WorkPlanTestUtility.createMileStone(newUser.Id ,stepRecord.Id ,taskRecord.Id );
        stepRecordWithParent.Original_Due_Date__c = System.today()+50;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecordWithParent;
        
       //create Step records.
        List<Step__c> stepRecordList    = WorkPlanTestUtility.createMultipleMileStone(newUser.Id ,stepRecord.Id ,taskRecord.Id );
        stepRecordList[0].Original_Due_Date__c = System.today()+5;
        insert stepRecordList;
        for(ID stepRecId : stepRecordIdsSet){
            stepRecordIdsSet.add(stepRecId);    
        }
        
        
        //create multiple Custom-Settimg-Milestone_Lookup(Milestone_Lookup__c) Record
        
        List<Milestone_Lookup__c> mileStoneLookupList = WorkPlanTestUtility.createMultipleMilestoneLookupRecords(stepRecordWithParent.Name,stepRecord.Name,taskRecord.Name);
        Test.startTest();
            insert mileStoneLookupList;
            
            update stepRecord;
            update stepRecordWithParent;
            
            delete stepRecordWithParent;
            delete stepRecord;
          
            
        Test.stopTest();
        
    }
    
    static testmethod void testUpdateTaskStatus(){
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
        stepRecord.Original_Due_Date__c = System.today()+5;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecord;
        Step__c stepRecordWithParent   = WorkPlanTestUtility.createMileStone(newUser.Id ,stepRecord.Id ,taskRecord.Id );
        stepRecordWithParent.Original_Due_Date__c = System.today()+50;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecordWithParent;
        
       //create Step records.
        List<Step__c> stepRecordList    = new list<Step__c>([select id,Task_Name__c,IP__c, Due_Date__c, Name, Alert__c from Step__c where id=:stepRecord.id]);
        
        
        Test.startTest();
        //Workplan_StepTriggerHandler obj = new Workplan_StepTriggerHandler();        
        WorkplanStepTriggerHandler.updateTaskStatus(stepRecordList);
        WorkplanStepTriggerHandler.insertStepsEvent(stepRecordList);
        Test.stopTest();
    }
}