@isTest
public class TestCNTargets {
	Public static testMethod void TestCNTargets()
    {	
		account objaccount = new account();
        objaccount.name = 'tests';
        insert objaccount;

        Concept_Note__c objConcept_Note = new Concept_Note__c();
        objConcept_Note.name = 'test';
        objConcept_Note.CCM_new__c = objaccount.id;
        objConcept_Note.Language__c = 'ENGLISH';
        objConcept_Note.Component__c = 'Malaria';
        insert objConcept_Note;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;
        
        Module__c objModule = new Module__c();
        objModule.Concept_Note__c = objConcept_Note.id;
        objModule.CN_Module__c = objModule.id;
        objModule.Catalog_Module__c = objCM.Id;        
        insert objModule;
        
        Implementation_Period__c objImplementation_Period = new Implementation_Period__c();
        objImplementation_Period.Principal_Recipient__c = objaccount.id;
        insert objImplementation_Period;
       
        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Catalog_Module__c = objCM.id;
        objIndicator.Available_for_PG__c = true;
        objIndicator.Programme_Area__c = 'Malaria';
        objIndicator.Indicator_Type__c = 'Coverage/Output';
        objIndicator.Catalog_Module__c = objCM.Id;
        objIndicator.Full_Name_En__c = 'test';
        objIndicator.Component__c = objConcept_Note.Component__c;
        objIndicator.Indicator_for_PG_Calculation_E__c = true;      
        insert objIndicator;
        
        
        Grant_Indicator__c objGrant_Indicator = new Grant_Indicator__c();
        objGrant_Indicator.Indicator_Type__c='Coverage/Output';
        objGrant_Indicator.Parent_Module__c = objModule.id;
        objGrant_Indicator.Data_Type__c = 'Number';
        objGrant_Indicator.Indicator__c = objIndicator.Id; 
        objGrant_Indicator.Concept_Note__c = objConcept_Note.id; 
        insert objGrant_Indicator;
        
        CNTargets objCNTargets = new CNTargets();
        List<Grant_Indicator__c> lstGrantIndicator=new List<Grant_Indicator__c>();
        lstGrantIndicator.add(objGrant_Indicator);
        objCNTargets.strGID=objGrant_Indicator.id;
        objCNTargets.lstCNTargets=lstGrantIndicator;
        
        Apexpages.currentpage().getparameters().put('id',objGrant_Indicator.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objGrant_Indicator);
        CNTargets objCNTargts = new CNTargets(sc);
    }
}