// **************************************************************************************
// Purpose         :   This Class is meant for Class-WorkPlanCreateTaskandStepsVFPExtension
// Date            :   12-Dec-2014
// Created By      :   TCS 
// Author          :   Gaurav Guleria
// Description     :   Used to Test Class-WorkPlanCreateTaskandStepsVFPExtension
// Revisions       :    

//**************************************************************************************
@isTest
public class WorkplanTestCreateTaskandStepsExtension{
    public static String profilename = 'Solution Manager';
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
        
        //create Custom-Setting-Task_Lookup(Task_Lookup__c) Record
        Task_Lookup__c tskLookUp = WorkPlanTestUtility.createTaskLookup('Concept Note','GAC 2 Review','Send Docs to GAC Secretariat');
        insert tskLookUp ;
        
        TEST.startTest();
        Apexpages.StandardController stdController = new Apexpages.StandardController(ImplementationPeriodRecord);
        WorkPlanCreateTaskandStepsVFPExtension obj = new WorkPlanCreateTaskandStepsVFPExtension(stdController); 
        obj.refreshGrantList();
        obj.statusVal='---Select Status---' ;
        obj.implementationPeriodId='---Select Grant---';
        obj.createWorkPlan();
        obj.getCountries();
        obj.getdiseaseComponent();
        obj.getgrantStatus();
        
        TEST.stopTest();
        
    }
    
    static testmethod void testmethod_C(){
        User newUser                        =   WorkPlanTestUtility.singleUser(profilename);
        insert newUser;
        
        //create Account
        Account AccountRecord  = WorkPlanTestUtility.createTestAccount();
        insert AccountRecord;
        //create Grant
        Grant__c grantRecord =  WorkPlanTestUtility.createGrant(AccountRecord.Id);
                      
        insert grantRecord;
        
        //create Implementation Period
        Implementation_Period__c ImplementationPeriodRecord =  WorkPlanTestUtility.createIp(AccountRecord.Id,grantRecord.Id);
        ImplementationPeriodRecord.Status__c ='Concept Note';
        insert ImplementationPeriodRecord;
        
        //create milestonelookup record
        Milestone_Lookup__c mlookup = new Milestone_Lookup__c();
        mlookup.Task_Name__c= 'Training Plan';
        mlookup.name='test';
        mlookup.Milestone__c = 'testmilestone';
        mlookup.Duration__c = 5;
         
        insert mlookup;
        
        //create Custom-Setting-Task_Lookup(Task_Lookup__c) Record
        
        List<Task_Lookup__c> tsklookuplst = new List<Task_Lookup__c>();
        Task_Lookup__c tskLookUp = WorkPlanTestUtility.createTaskLookup('Concept Note','GAC 2 Review','Send Docs to GAC Secretariat');
        Task_Lookup__c tskLookUp2 = WorkPlanTestUtility.createTaskLookup('Grant-Making','GAC 3 Review','Send Docs to GAC Secretariat');
        
        tskLookUp2.Name = 'test2';
        insert tskLookUp2;
        insert tskLookUp;
        tsklookuplst.add(tskLookUp);
        tsklookuplst.add(tskLookUp2);
        //insert tsklookuplst;
         
      
          
             
        TEST.startTest();
        Apexpages.StandardController stdController = new Apexpages.StandardController(ImplementationPeriodRecord);
        WorkPlanCreateTaskandStepsVFPExtension obj = new WorkPlanCreateTaskandStepsVFPExtension(stdController); 
        obj.refreshGrantList();
        obj.statusVal='Concept Note' ;
        obj.implementationPeriodId=ImplementationPeriodRecord.Id;
        obj.createWorkPlan();
        obj.getCountries();
        obj.getdiseaseComponent();
        obj.getgrantStatus();
        
        TEST.stopTest();
     }
     
     static testmethod void testmethod_B(){
        User newUser                        =   WorkPlanTestUtility.singleUser(profilename);
        insert newUser;
        
        //create Account
        Account AccountRecord  = WorkPlanTestUtility.createTestAccount();
        insert AccountRecord;
        //create Grant
        Grant__c grantRecord =  WorkPlanTestUtility.createGrant(AccountRecord.Id);
                      
        insert grantRecord;
        
        //create Implementation Period
        Implementation_Period__c ImplementationPeriodRecord =  WorkPlanTestUtility.createIp(AccountRecord.Id,grantRecord.Id);
        ImplementationPeriodRecord.Status__c ='Concept Note';
        insert ImplementationPeriodRecord;
        
        //create milestonelookup record
        Milestone_Lookup__c mlookup = new Milestone_Lookup__c();
        mlookup.Task_Name__c= 'Training Plan';
        mlookup.name='test';
        mlookup.Milestone__c = 'testmilestone';
        mlookup.Duration__c = 5;
         
        insert mlookup;
        
        //create Custom-Setting-Task_Lookup(Task_Lookup__c) Record
        
        List<Task_Lookup__c> tsklookuplst = new List<Task_Lookup__c>();
        Task_Lookup__c tskLookUp = WorkPlanTestUtility.createTaskLookup('Concept Note','GAC 2 Review','Send Docs to GAC Secretariat');
        Task_Lookup__c tskLookUp2 = WorkPlanTestUtility.createTaskLookup('Grant-Making','GAC 3 Review','Send Docs to GAC Secretariat');
        
        tskLookUp2.Name = 'test2';
        insert tskLookUp2;
        insert tskLookUp;
        tsklookuplst.add(tskLookUp);
        tsklookuplst.add(tskLookUp2);
        //insert tsklookuplst;
         
        Task__c taskRecord      = WorkPlanTestUtility.createTask(newUser.Id,ImplementationPeriodRecord.Id);
        insert taskRecord; 
          
             
        TEST.startTest();
        Apexpages.StandardController stdController = new Apexpages.StandardController(ImplementationPeriodRecord);
        WorkPlanCreateTaskandStepsVFPExtension obj = new WorkPlanCreateTaskandStepsVFPExtension(stdController); 
        obj.refreshGrantList();
        obj.statusVal='Concept Note' ;
        obj.implementationPeriodId=ImplementationPeriodRecord.Id;
        obj.createWorkPlan();
        obj.getCountries();
        obj.getdiseaseComponent();
        obj.getgrantStatus();
        
        TEST.stopTest();
     }



}