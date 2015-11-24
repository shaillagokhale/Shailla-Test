@isTest
Public Class TestctrlCNSidebar{
    Public static testMethod void TestctrlCNSidebar(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
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
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        objCM.Available_for_Programmatic_Gap__c = true;
        insert objCM;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Concept_note__c = objCN.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        
        CPF_Report__c objCR = new CPF_Report__c();
        objCR.Concept_Note__c = objCN.Id;
        insert objCR;
        
        Apexpages.currentpage().getparameters().put('id',objCN.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objCN);
        //ctrlCNSidebar objCNS = new ctrlCNSidebar(sc);
    }
}