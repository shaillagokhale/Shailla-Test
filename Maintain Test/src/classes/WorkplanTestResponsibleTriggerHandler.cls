// **************************************************************************************
// Purpose         :   This Class is meant for Trigger-WorkPlanResponsibleTrigger(on Responsible__c) and Class-WorkplanResponsibleTriggerHandler
// Date            :   24-Nov-2014
// Created By      :   TCS 
// Author          :   Gaurav Guleria
// Description     :   Used to Test Trigger-WorkPlanResponsibleTrigger(on Responsible__c) and Class-WorkplanResponsibleTriggerHandler
// Revisions       :    

//**************************************************************************************
@isTest
public class WorkplanTestResponsibleTriggerHandler{
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
        
          Test.startTest();
       //create Step records.
        List<Step__c> stepRecordList    = WorkPlanTestUtility.createMultipleMileStone(newUser.Id ,stepRecord.Id ,taskRecord.Id );
        stepRecordList[0].Original_Due_Date__c = System.today()+5;
        insert stepRecordList;
        for(ID stepRecId : stepRecordIdsSet){
            stepRecordIdsSet.add(stepRecId);    
        }
        
        
        //create multiple Custom-Settimg-Milestone_Lookup(Milestone_Lookup__c) Record
       
        List<Milestone_Lookup__c> mileStoneLookupList = WorkPlanTestUtility.createMultipleMilestoneLookupRecords(stepRecordWithParent.Name,stepRecord.Name,taskRecord.Name);
        insert mileStoneLookupList;
        
        List<Responsible__c> responsibleRecList = WorkPlanTestUtility.createMultipleResponsibleRecords(taskRecord.Id, stepRecord.Id ,newUser.Id);
        insert responsibleRecList;
        
        delete responsibleRecList;
         Test.stopTest();
       
        
        
        
        
     
     }


}