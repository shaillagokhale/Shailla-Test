@isTest
public class WorkplanTestTaskStepsTravel {
    public static String profilename = 'Solution Manager';
     static testMethod void testingTaskStepsTravel ()
    {
            User newUser=WorkPlanTestUtility.singleUser(profilename);
            insert newUser;
        
             //create Account
            Account AccountRecord= WorkPlanTestUtility.createTestAccount();
            insert AccountRecord;
            
            //create Grant
            Grant__c grantRecord= WorkPlanTestUtility.createGrant(AccountRecord.Id);
            insert grantRecord;
        
          //create Implementation Period
            Implementation_Period__c ImplementationPeriodRecord =  WorkPlanTestUtility.createIp(AccountRecord.Id,grantRecord.Id);
            insert ImplementationPeriodRecord;

           //create Task
            Task__c taskRecord=WorkPlanTestUtility.createTask(newUser.Id,ImplementationPeriodRecord.Id);
            insert taskRecord; 

         //create Step record
            Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord.Id);
            stepRecord.Original_Due_Date__c = System.today()+5;
            stepRecord.Due_Date__c = System.today()+5;
            insert stepRecord;


        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(taskRecord);
        TaskStepsTravel oTSTravel=new TaskStepsTravel(stdCtrl);
        PageReference pg = Page.Wp_Steps_travel;
        Test.setCurrentPage(pg);
        
        
        oTSTravel.AddRow();
        
        oTSTravel.CustomSave();
        
        oTSTravel.confirmDeleteMilestone();

    }

}