@isTest
public class WorkplanTestTaskSteps {
    public static String profilename = 'Solution Manager';
     static testMethod void testingTaskSteps ()
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

        //create Attachment
        Attachment oAttach=new Attachment ();
        oAttach.Name='Unit Test Attachment';
        Blob oBlob=Blob.valueOf('Unit Test Attachment Body');
        oAttach.body=oBlob;
        oAttach.parentId=stepRecord.Id;
        insert oAttach;

        PageReference pg = Page.Wp_Steps;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('selectedMilestone',stepRecord.Id);
         ApexPages.currentPage().getParameters().put('selectedMilestone1',stepRecord.Id);
        ApexPages.currentPage().getParameters().put('contextItem',stepRecord.Id);
        ApexPages.currentPage().getParameters().put('attachmentsId',oAttach.Id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(taskRecord);         
        TaskSteps oTSTravel=new TaskSteps(stdCtrl);
        
        
        
         TEST.startTest();

        oTSTravel.AddRow();
        
        oTSTravel.CustomSave();    
      
        oTSTravel.cancelPopUp();
        
        oTSTravel.milefilelist();
        
        oTSTravel.upload();      
        
        oTSTravel.deleteAttachment();
        
        oTSTravel.confirmDeleteMilestone();    
        
        oTSTravel.fetchMilestone();
       
         TEST.stopTest();
    }

}