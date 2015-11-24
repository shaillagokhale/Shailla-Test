@isTest
Public Class TestGIMSelection{
    Public static testMethod void TestGIMSelection(){
       
       /* Account objAcc = new Account();
        objAcc.Name = 'T';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test';
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
        
        Grant_Intervention__c objGInt = new Grant_Intervention__c();
        objGInt.Name = 'Test GI';
        objGInt.Module__c = objModule.Id;
        objGInt.Implementation_Period__c = objIP.Id;
        insert objGInt;
        
        Period__c objPeriod = new Period__c();
        objPeriod.Start_Date__c = system.today();
        objPeriod.Implementation_Period__c = objIP.Id;
        insert objPeriod;
        
        Grant_Indicator__c  objInd = new Grant_Indicator__c ();
        
        objInd.Indicator_Type__c = 'Grant Implementation Measure';
        objInd.Parent_Module__c = objModule.Id;
        objInd.Grant_Intervention__c = objGInt.Id;
        insert objInd;
        
        Grant_Indicator__c objGI = new Grant_Indicator__c();
        objGI.Indicator_Type__c = 'Coverage/Output';
        objGI.Parent_Module__c = objModule.id;
        insert objGI;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GIMSelection';
        objPs.Key__c = 'GOClosePanelLabel';
        insert objPs;*/
        
        Account objAcc = TestClassHelper.insertAccount(); 
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
         Implementation_Period__c objIP =TestClassHelper.createIP(objGrant, objAcc);
        insert objIP;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Catalog_Module__c objCM =TestClassHelper.createCatalogModule();
        insert objCM;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        
        Grant_Intervention__c objGInt = new Grant_Intervention__c();
        objGInt.Name = 'Test GI';
        objGInt.Module__c = objModule.Id;
        objGInt.Implementation_Period__c = objIP.Id;
        insert objGInt;
        
        Period__c objPeriod = TestClassHelper.createPeriod();
        objPeriod.Start_Date__c = system.today();
        objPeriod.Implementation_Period__c = objIP.Id;
        insert objPeriod;
        
        Grant_Indicator__c objInd =TestClassHelper.createGrantIndicator();
        objInd.Indicator_Type__c = 'Grant Implementation Measure';
        objInd.Parent_Module__c = objModule.Id;
        objInd.Grant_Intervention__c = objGInt.Id;
        insert objInd;
        
        Grant_Indicator__c objGI = TestClassHelper.createGrantIndicator();
        objGI.Indicator_Type__c = 'Coverage/Output';
        objGI.Parent_Module__c = objModule.id;
        insert objGI;
        
        Project_multi_lingual__c objPs =TestClassHelper.createProjMultiLanguage();
        objPs.Group_Name__c = 'GIMSelection';
        insert objPs;
        
        
        
        
        Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        GIMSelection objCls = new GIMSelection(sc);
        
        //objCls.AddNewCustomGIMResult();
        //objCls.AddNewStandardGIMResult();
        
        apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCls.EditGIMResult();
        
        apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCls.CancelGIMResult();
        
        apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objCls.SaveGIMResult();
        objCls.SelectInterventionForGIM();
        apexpages.currentpage().getparameters().put('SaveIndex','1');
        objCls.SaveCustomIndicator();
        objCls.SelectInterventionForCustomNew();
        
        apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objCls.DeleteGIMResult();
  
    }
}