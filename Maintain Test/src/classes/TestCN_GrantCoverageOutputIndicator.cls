@isTest
Public Class TestCN_GrantCoverageOutputIndicator{
    Public static testMethod void TestCN_GrantCoverageOutputIndicator(){
            
        Principal_Recipient__c pr =new Principal_Recipient__c();
        pr.Name='pr1';
        insert pr;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        objAcc.Principal_Recipient__c = pr.Id;
        insert objAcc;
    
        
        
        Implementation_Period__c objIP = new Implementation_Period__c();
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
       
        /*Account objAcc1 = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        insert objAcc1;
        
        Implementation_Period__c objIP1 = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc1.Id;
        insert objIP1;
        
        Page__c objPage1 = new Page__c();
        objPage.Implementation_Period__c = objIP1.Id;
        insert objPage1;
        
        Catalog_Module__c objCM1 = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM1;*/
        
       /* Module__c objModule1 = new Module__c();
        objmodule1.Name = 'Test';
        objModule1.Component__c = 'Malaria';
        objModule1.Implementation_Period__c = objIP.Id;
        objModule1.CN_Module__c = objModule.id;
        objModule1.Catalog_Module__c = objCM.id;
        insert objModule1;*/
        
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
        insert objPs;
        
        Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        CN_CoverageOutputIndicator objCls = new CN_CoverageOutputIndicator(sc);
        
        /*Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCls.EditGrantIndicatorResult();
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objCls.SaveGrantIndicatorResult();*/
        
        objCls.strSelectedIndicator = objInd.id;
        objCls.CreateIndicatorOnSelectCatalog();
        
        Apexpages.currentpage().getparameters().put('SaveStdIndicator','1'); 
        objCls.SaveStandardIndicator();
        Apexpages.currentpage().getparameters().put('SaveCusIndicator','1'); 
        objCls.SaveCustomIndicator();
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCls.EditGrantIndicatorResult();
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCls.CancelGrantIndicatorResult();
        
        
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objCls.DeleteGrantIndicatorResult();
    }
}