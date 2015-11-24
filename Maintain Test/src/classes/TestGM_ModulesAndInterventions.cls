@isTest
Public Class TestGM_ModulesAndInterventions{
    Public static testMethod void TestGM_ModulesAndInterventions(){
        /*Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;*/
        
        
       /* Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;*/
        
        
        
        
        /*Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c =  'Malaria';
        objGrant.Name = 'Test';
        objGrant.Principal_Recipient__c = objAcc.Id;
        insert objGrant;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Grant__c = objGrant.Id;
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM;
        
        Catalog_Module__c objCM1 = new Catalog_Module__c();
        objCM1.Name = 'Test CM1';
        objCM1.Component__c = 'Malaria';
        objCM1.component_multi__c = 'Malaria';
        insert objCM1;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        
        Module__c objModule1 = new Module__c();
        objmodule1.Name = 'Test';
        objModule1.Component__c = 'Malaria';
        objModule1.Implementation_Period__c = objIP.Id;
        insert objModule1;
        
        Grant_Intervention__c objInt = new Grant_Intervention__c();
        objInt.Name = 'Test';
        objInt.Implementation_Period__c = objIP.Id;
        
        objInt.Module__c = objModule.Id;
        insert objInt;
        
        Catalog_Intervention__c objCI = new Catalog_Intervention__c();
        objCI.Name = 'Test CI';
        objCI.Catalog_Module__c  = objCM.Id;
        insert objCI; */
        
        
        
       /* Account objAcc = TestClassHelper.insertAccount();
                
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.id;
        insert objCN;
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        insert objIP;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;*/
        
        Account objAcc = TestClassHelper.createAccount();
        insert objAcc;        
        Concept_Note__c objCN = TestClassHelper.createCN();
        //objCN.Concept_Note_Submission_Date__c = '2014-12-01';
       //objCN.start_date__c = system.today();
        objCN.CCM_new__c = objAcc.id;
        insert objCN;
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        test.startTest();
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        objIP.Status__c = 'Concept Note';
        insert objIP;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        objIP.Status__c = 'Grant-Making';
        update objIP;
        
        Catalog_Module__c objCM = TestClassHelper.createCatalogModule();
        insert objCM;
        
       
        Catalog_Module__c objCM1 = TestClassHelper.createCatalogModule();
        objCM1.Name = 'Test CM1';
        objCM1.Component__c = 'Malaria';
        objCM1.component_multi__c = 'Malaria';
        insert objCM1;
        
        
        Module__c objModule = TestClassHelper.createModule();
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        objModule.Component__c = 'Malaria';
        insert objModule;
       
        
        /*Module__c objModule1 = TestClassHelper.createModule();
        objModule1.Component__c = 'Malaria';
        objModule1.Implementation_Period__c = objIP.Id; 
        insert objModule1;*/
        
        
        Grant_Intervention__c objInt = TestClassHelper.createGrantIntervention(objIP);
        objInt.Name = 'TestIntervention';
        objInt.Module__c = objModule.Id;
        insert objInt;
        
        
        Catalog_Intervention__c objCI = TestClassHelper.createCatalogIntervention();
        objCI.Catalog_Module__c  = objCM.Id;
        insert objCI; 
        test.stopTest();
        
    
    
        
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GM_ModulesAndInterventions objCls = new GM_ModulesAndInterventions(sc);
        
        objCls.lstCatModules[0].isSelected = true;
        objCls.AddSelectedModule();
        
        Apexpages.currentpage().getparameters().put('parentRowIndex','0');
        
        objCls.lstModules[0].lstinterventions[0].isSelected = true;
       
        objCls.AddSelectedIntervention();
        
        
    
        
        Apexpages.currentpage().getparameters().put('parentRowIndex','0');
       
        objCls.AddCustomIntervention();
        
        
        
        Apexpages.currentpage().getparameters().put('ChildCancelIndex','0');
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelInterventionEdit();
        
        
         
        Apexpages.currentpage().getparameters().put('EditIndex','0');
         objCls.EditModule();
        
       
        Apexpages.currentpage().getparameters().put('ChildEditIndex','0');
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        
        objCls.EditGrantIntervention();
                                    
      
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveModule();
        
        
        /*String indexModule = String.valueof(objCls.lstModules.size()+1);
        Apexpages.currentpage().getparameters().put('SaveIndex',indexModule);
        objCls.SaveModule();*/
       
         
         
        Apexpages.currentpage().getparameters().put('ChildSaveIndex','0');
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCls.SaveGrantIntervention();
       
        
        /*String indexInt = String.valueof(objCls.lstModules[0].childInterventions.size()+1);
        Apexpages.currentpage().getparameters().put('ChildSaveIndex',indexInt);
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
         objCls.SaveGrantIntervention();*/
        
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCls.CancelModule();
        
        
          Apexpages.currentpage().getparameters().put('DeleteIndex','0');
          Apexpages.currentpage().getparameters().put('ChildDeleteIndex','1');   
          Apexpages.currentpage().getparameters().put('deleteModuleIndex','1');    
        
         
         objCls.DeleteIntervention(); 
         
         objCls.DeleteModule(); 
          
      
       /* test.startTest();
        Apexpages.currentpage().getparameters().put('deleteModuleIndex','1');
        
        objCls.DeleteModule();
         test.stopTest();     */
        
        
    }
    
}