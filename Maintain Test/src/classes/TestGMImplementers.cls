@isTest
Public Class TestGMImplementers{
    Public static testMethod void TestGMImplementers(){
        
        
        /*String AccountRecordType = [Select Id From RecordType Where sobjectType = 'Account' And DeveloperName = 'Implementer_Non_PR'].Id;
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        objAcc.RecordTypeId = AccountRecordType;
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
       
         
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;      
        
        
        Implementer__c objImp = new Implementer__c();
        objImp.Account__c = objAcc.Id;
        objImp.Grant_Implementation_Period__c = objIP.Id;
        insert objImp;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;*/
        
        String AccountRecordType = [Select Id From RecordType Where sobjectType = 'Account' And DeveloperName = 'Implementer_Non_PR'].Id;
        Account objAcc = TestClassHelper.createAccount();
        objAcc.RecordTypeId = AccountRecordType;
        insert objAcc;
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert Objpage;
        
        Implementer__c objImp = TestClassHelper.createImplementor();
        objImp.Account__c = objAcc.Id;
        objImp.Grant_Implementation_Period__c = objIP.Id;
        insert objImp;
        
        Project_multi_lingual__c objPs = TestClassHelper.createProjMultiLanguage();
        insert objPs;
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GMImplementers objGI = new GMImplementers(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objGI.objNewAccount = new Account(name = 'Test',RecordTypeId = AccountRecordType);
        
        Test.startTest();
        objGI.SaveGoal();
        Test.stopTest();
        
        objGI.objNewAccount = new Account();
        objGI.objNewAccount = objAcc;
        Apexpages.currentpage().getparameters().put('SaveIndex','3');
        objGI.SaveGoalExisting();
        
        objGI.fillExistingAccountFields();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objGI.DeleteGoal();
    }
}