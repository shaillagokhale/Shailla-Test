@isTest
Public Class TestCN_Budget{
    Public static testMethod void testCN_Budget(){
        Account objAccount = new Account();
        objAccount.Name = 'Test_Account';
        insert objAccount;
        
        Test.startTest();
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test_IP';
        objIP.Principal_Recipient__c = objAccount.Id;
        insert objIP;
        
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test_CM';
        insert objCM;
        
        Module__c objModule = new Module__c();
        objModule.Name='Test_Module';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.Id;
        insert objModule;
        
        Program_Split__c objPrgmSplit = new Program_Split__c();
        objPrgmSplit.CCM__c = objAccount.Id;
        insert objPrgmSplit;
        
        Template__c objTemplate = new Template__c();
        objTemplate.Name = 'Test Template';
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAccount.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Indicative_Amount__c = 10;
        objCN.Program_Split__c = objPrgmSplit.Id;
        objCN.Status__c = 'Reviewed and OK for TRP/GAC1';
        objCN.Component__c = 'Health Systems Strengthening';
        objCN.Open__c = true;
        insert objCN;
        
        Intervention__c objIntervention = new Intervention__c();
        objIntervention.Name = 'Test_Intervention';
        objIntervention.Concept_Note__c = objCN.Id;
        objIntervention.Module_rel__c = objModule.Id;
        insert objIntervention;
        
        Grant_Intervention__c objGI = new Grant_Intervention__c();
        objGI.name = 'Test_GI';
        objGI.CN_Intervention__c = objIntervention.Id;
        objGI.Implementation_Period__c = objIP.Id;
        insert objGI;
        Test.stopTest();
        Apexpages.currentpage().getparameters().put('id',objModule.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        CN_Budget objCNBudget = new CN_Budget(sc);
      
        objCNBudget.SaveDraft();
        objCNBudget.SaveReturn();
        
        Apexpages.currentpage().getparameters().put('HistoryIndexCN','0');
        Apexpages.currentpage().getparameters().put('HistoryIndexGI','0');
        Apexpages.currentpage().getparameters().put('DeleteIndexGI','0');
        Apexpages.currentpage().getparameters().put('DeleteIndexCN','0');
        objCNBudget.ShowHistoryPopup();
        objCNBudget.HidePopupHistory();
         
        objCNBudget.CalculateField();
        objCNBudget.EditPR ();
        objCNBudget.SavePR ();
        objCNBudget.CancelPR ();
        Apexpages.currentpage().getparameters().put('DeleteIndexCN','0');
        Apexpages.currentpage().getparameters().put('DeleteIndexGI','0');
        objCNBudget.DeletePR();
    }
    
    Public static testMethod void CN_DocumentUploadTest1(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test_IP';
        objIP.Principal_Recipient__c = objAcc.Id;
        insert objIP;
        
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test_CM';
        insert objCM;
        
        Module__c objModule = new Module__c();
        objModule.Name='Test_Module';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.Id;
        insert objModule;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
    	
    	Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        CN_Budget objGI = new CN_Budget(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CN_Budget';
        checkProfile.Salesforce_Item__c = 'Edit Above Allocated Values';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        objGI.checkProfile(); 
    }
}