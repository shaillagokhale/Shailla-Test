@isTest
Public Class TestCNImplementers{
    Public static testMethod void TestCNImplementers(){
    	
    	Test.startTest();
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;
        
        Grant__c objGrant = new Grant__c();
        objGrant.Name = 'Test Grant';
        objGrant.Principal_Recipient__c = objAcc.Id;
        insert objGrant;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Program_Split__c objPrgmSplit = new Program_Split__c();
        objPrgmSplit.CCM__c = objAcc.Id;
        insert objPrgmSplit;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Indicative_Amount__c = 10;
        objCN.Program_Split__c = objPrgmSplit.Id;
        objCN.Status__c = 'Not yet submitted';
        objCN.Component__c = 'Health Systems Strengthening';
        objCN.Open__c = true;
        insert objCN;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;
        
        Test.stopTest();
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        CNImplementers_Temp1 objGI = new CNImplementers_Temp1(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objGI.objNewAccount = new Account(name = 'Test');
        objGI.SaveGoal();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objGI.UpdateCustomPR();
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objGI.EditGoal();
        
        objGI.FillAccountSubType();
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objGI.CancelGoal();       
        
        objGI.objNewExistingAccount = new Account();
        objGI.objNewExistingAccount = objAcc;
        Apexpages.currentpage().getparameters().put('SaveIndex','3');
        objGI.SaveGoalExisting();
        
        objGI.SelectedAccId = objAcc.Id;
        objGI.fillExistingAccountFields();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objGI.DeleteGoal();
        
    }
    
    Public static testMethod void CNImplementersTest1(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
    	
    	Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        CNImplementers_Temp1 objGI = new CNImplementers_Temp1(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CN_Implementers';
        checkProfile.Salesforce_Item__c = 'Edit';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        objGI.checkProfile(); 
    }
}