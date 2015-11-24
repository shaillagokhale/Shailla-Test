@isTest
Public Class TestGrantCoverageOutputIndicator{
    Public static testMethod void TestGrantCoverageOutputIndicator(){
        /*Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;*/
        
    
        /*Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
       
        
        Period__c objPeriod = new Period__c();
        objPeriod.Start_Date__c = system.today();
        objPeriod.Implementation_Period__c = objIP.Id;
        insert objPeriod;
        
        
        Indicator__c objInd = new Indicator__c();
        objInd.Catalog_Module__c = objCM.Id;
        objInd.Indicator_Type__c = 'Coverage/Output';
        objInd.Full_Name_En__c = 'test';
        objInd.Type_of_Data__c = 'Number';
        insert objInd;
       
        
        Grant_Indicator__c objGI = new Grant_Indicator__c();
        objGI.Indicator_Type__c = 'Coverage/Output';
        objGI.Parent_Module__c = objModule.id;
        insert objGI;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GrantCoverageOutputIndicator';
        objPs.Key__c = 'GOHome';
        insert objPs;*/
        
      	Account objAcc = TestClassHelper.insertAccount();
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        insert objIP;
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert Objpage;
        
        Catalog_Module__c objCM = TestClassHelper.createCatalogModule();
        insert objCM;
        
        Module__c objModule = TestClassHelper.createModule();
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        
        Period__c objPeriod = TestClassHelper.createPeriod();
        objPeriod.Start_Date__c = system.today();
        objPeriod.Implementation_Period__c = objIP.Id;
        insert objPeriod;
        
        Indicator__c objInd = TestClassHelper.createCatalogIndicator();
        objInd.Catalog_Module__c = objCM.Id;
        objInd.Indicator_Type__c = 'Coverage/Output';
        objInd.Full_Name_En__c = 'test';
        objInd.Type_of_Data__c = 'Number';
        insert objInd;
        
        Grant_Indicator__c objGI = TestClassHelper.createGrantIndicator();
        objGI.Indicator_Type__c = 'Coverage/Output';
        objGI.Parent_Module__c = objModule.id;
        insert objGI;
        
        Project_multi_lingual__c objPs = TestClassHelper.createProjMultiLanguage();
        objPs.Group_Name__c = 'GrantCoverageOutputIndicator';
        insert objPs;
        
        
        
        Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        GrantCoverageOutputIndicator objCls = new GrantCoverageOutputIndicator(sc);
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCls.EditGrantIndicatorResult();
        objCls.CancelGrantIndicatorResult();
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objCls.SaveGrantIndicatorResult();
        
        objCls.strSelectedIndicator = objInd.id;
        objCls.CreateIndicatorOnSelectCatalog();
        
        Apexpages.currentpage().getparameters().put('SaveStdIndicator','1'); 
        objCls.SaveStandardIndicator();
        Apexpages.currentpage().getparameters().put('SaveCusIndicator','1'); 
        objCls.SaveCustomIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objCls.DeleteGrantIndicatorResult();
        
        
    }
}