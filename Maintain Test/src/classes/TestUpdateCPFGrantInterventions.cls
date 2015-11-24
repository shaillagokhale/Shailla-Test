@isTest
Public Class TestUpdateCPFGrantInterventions{
    Public static testMethod void TestUpdateCPFGrantInterventions(){
                
        Country__c objCountry = new Country__c();
        objCountry.Name = 'ind';
        objCountry.Country_Fiscal_Cycle_End_Date__c = system.today();
        insert objCountry;
    
        Account objAccount = new Account();
        objAccount.name = 'test';
        objAccount.country__c = objCountry.id;
        insert objAccount;
        
        Concept_Note__c objConcept_Note = new Concept_Note__c();
        objConcept_Note.Name = 'test';
        objConcept_Note.Component__c = 'Tuberculosis';
        objConcept_Note.CCM_new__c = objAccount.id;
        objConcept_Note.Number_of_Years__c = '4';
        insert objConcept_Note;
        
        Concept_Note__c objConcept_Note1 = new Concept_Note__c();
        objConcept_Note1.Name = 'test';
        objConcept_Note1.Component__c = 'HIV/TB';
        objConcept_Note1.CCM_new__c = objAccount.id;
        objConcept_Note1.Number_of_Years__c = '4';
        insert objConcept_Note1;
        
        CPF_Report__c objCPF_Report = new CPF_Report__c();
        objCPF_Report.Concept_Note__c = objConcept_Note.id;
        insert objCPF_Report;
        
        Catalog_Module__c objCatalogModule = new Catalog_Module__c();
        objCatalogModule.Name = 'Test Catalog Module';
        objCatalogModule.Component_Multi__c = 'Tuberculosis';
        insert objCatalogModule;
        
        Catalog_Module__c objCatalogModule1 = new Catalog_Module__c();
        objCatalogModule1.Name = 'Test Catalog Module';
        objCatalogModule1.Component_Multi__c = 'HIV/TB;Tuberculosis';
        insert objCatalogModule1;
        
        Module__c objModule = new Module__c();
        objModule.Name = 'Test Module';
        objModule.CurrencyIsoCode = 'USD';
        objModule.Concept_Note__c = objConcept_Note.id;
        objModule.Catalog_Module__c = objCatalogModule.Id;
        insert objModule;
        
        Module__c objModule1 = new Module__c();
        objModule1.Name = 'Test Module';
        objModule1.CurrencyIsoCode = 'USD';
        objModule1.Catalog_Module__c = objCatalogModule1.Id;
        objModule1.CN_Module__c = objModule.Id;
        insert objModule1;
        
        Implementation_Period__c objImplementation_Period = new Implementation_Period__c();
        objImplementation_Period.Concept_Note__c = objConcept_Note.id;
        objImplementation_Period.Principal_Recipient__c = objAccount.id;
        insert objImplementation_Period;
        
        Grant_Intervention__c objGrant_Intervention = new Grant_Intervention__c();
        objGrant_Intervention.Implementation_Period__c = objImplementation_Period.id;
        objGrant_Intervention.Module__c = objModule1.id;
        insert objGrant_Intervention;
        
        set<Id> setCNID = new set<Id>();
        //setCNID.add(objConcept_Note.id);
        setCNID.add(objConcept_Note1.id);
        
        updateCPFGrantInterventions objupdateCPFGrantInterventions = new updateCPFGrantInterventions();
        updateCPFGrantInterventions.updateCPF(setCNID);
    }
    
    /*Public static testMethod void TestUpdateCPFGrantInterventionsHIV(){
                
        Country__c objCountry = new Country__c();
        objCountry.Name = 'ind';
        objCountry.Country_Fiscal_Cycle_End_Date__c = system.today();
        insert objCountry;
    
        Account objAccount = new Account();
        objAccount.name = 'test';
        objAccount.country__c = objCountry.id;
        insert objAccount;
        
        Concept_Note__c objConcept_Note = new Concept_Note__c();
        objConcept_Note.Name = 'test';
        
        objConcept_Note.CCM_new__c = objAccount.id;
        objConcept_Note.Concept_Note_Submission_Date__c = string.valueof(system.today());
        objConcept_Note.Start_Date__c = system.today();
        insert objConcept_Note;
        
        Concept_Note__c objConcept_Note1 = new Concept_Note__c();
        objConcept_Note1.Name = 'test1';
        objConcept_Note1.Component__c = 'HIV/TB';
        objConcept_Note1.CCM_new__c = objAccount.id;
        objConcept_Note1.Concept_Note_Submission_Date__c = string.valueof(system.today());
        objConcept_Note1.Start_Date__c = system.today();
        objConcept_Note1.Number_of_Years__c = '3';
        insert objConcept_Note1;
        
        CPF_Report__c objCPF_Report = new CPF_Report__c();
        objCPF_Report.Concept_Note__c = objConcept_Note.id;
        insert objCPF_Report;
        
        Catalog_Module__c objCatalogModule = new Catalog_Module__c();
        objCatalogModule.Name = 'Test Catalog Module';
        objCatalogModule.Component_Multi__c = 'HIV/TB';
        insert objCatalogModule;
        
        Module__c objModule = new Module__c();
        objModule.Name = 'Test Module';
        objModule.CurrencyIsoCode = 'USD';
        objModule.Concept_Note__c = objConcept_Note.id;
        objModule.Catalog_Module__c = objCatalogModule.Id;
        insert objModule;
        
        Module__c objModule1 = new Module__c();
        objModule1.Name = 'Test Module';
        objModule1.CurrencyIsoCode = 'USD';
        objModule1.Catalog_Module__c = objCatalogModule.Id;
        objModule1.CN_Module__c = objModule.Id;
        insert objModule1;
        
        Implementation_Period__c objImplementation_Period = new Implementation_Period__c();
        objImplementation_Period.Concept_Note__c = objConcept_Note.id;
        objImplementation_Period.Principal_Recipient__c = objAccount.id;
        insert objImplementation_Period;
        
        Grant_Intervention__c objGrant_Intervention = new Grant_Intervention__c();
        objGrant_Intervention.Implementation_Period__c = objImplementation_Period.id;
        objGrant_Intervention.Module__c = objModule.id;
        insert objGrant_Intervention;
        
        
        
        set<Id> setCNID = new set<Id>();
        setCNID.add(objConcept_Note.id);
        setCNID.add(objConcept_Note1.id);        
        updateCPFGrantInterventions objupdateCPFGrantInterventions = new updateCPFGrantInterventions();
        updateCPFGrantInterventions.updateCPF(setCNID);
    }*/
}