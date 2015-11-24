@isTest
Public Class TestGIPFundingSource{
    Public static testMethod void TestGIPFundingSourceUSD(){
        
        account objacc = new account();
        objacc.name = 'test';        
        insert objacc; 
        
        CPF_Report__c objCPFReport = new CPF_Report__c();
        objCPFReport.Component__c = 'HIV/AIDS';
        insert objCPFReport;
        
        set<id> setCPFR = new set<id>();
        setCPFR.add(objCPFReport.id); 
        
        Country__c objCountry = new Country__c();
        objCountry.Country_Fiscal_Cycle_End_Date__c = system.today();
        objCountry.Country_Fiscal_Cycle_Start_Date__c = system.today();
        insert objCountry;

        set<id> setcountry = new set<id>();
        setcountry.add(objCountry.id);
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.Start_Date__c = system.today();
        objConceptNote.Component__c = 'HIV/AIDS';
        insert objConceptNote;
        
        Grant__c obGrant = new Grant__c();
        obGrant.Principal_Recipient__c = objacc.id;
        obGrant.Country__c = objCountry.id;
        obGrant.Disease_Component__c = 'HIV/AIDS';
        obGrant.Start_Date__c = system.today();
        obGrant.End_Date__c = system.today().addyears(1);
        insert obGrant;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objacc.id;
        objIP.Grant__c = obGrant.id;
        objIP.End_Date__c = system.today();
        objIP.Start_Date__c = system.today();
        insert objIP;
        
        Disbursement__c objDisbursement = new Disbursement__c();
        objDisbursement.Implementation_Period__c = objIP.id;
        objDisbursement.Amount_Disbursed_EUR__c = 1.1;
        objDisbursement.Amount_Disbursed_USD__c = 2.2;
        objDisbursement.Disbursement_Date__c = system.today(); 
        objDisbursement.CurrencyIsoCode = 'EUR';
        insert objDisbursement;

        
        GIPFundingSource objGIPFundingSource = new GIPFundingSource();
        
        GIPFundingSource.CreateGIPFundingSourceRecords(setcountry,objConceptNote.id,setCPFR);
    }
    
    Public static testMethod void TestGIPFundingSourceEUR(){
        
        account objacc = new account();
        objacc.name = 'test';        
        insert objacc; 
        
        CPF_Report__c objCPFReport = new CPF_Report__c();
        objCPFReport.Component__c = 'HIV/AIDS';
        insert objCPFReport;
        
        set<id> setCPFR = new set<id>();
        setCPFR.add(objCPFReport.id); 
        
        Country__c objCountry = new Country__c();
        objCountry.Country_Fiscal_Cycle_End_Date__c = system.today();
        objCountry.Country_Fiscal_Cycle_Start_Date__c = system.today();
        insert objCountry;

        set<id> setcountry = new set<id>();
        setcountry.add(objCountry.id);
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.CurrencyIsoCode = 'EUR';
        objConceptNote.Start_Date__c = system.today();
        objConceptNote.Component__c = 'HIV/AIDS';
        insert objConceptNote;
        
        Grant__c obGrant = new Grant__c();
        obGrant.Principal_Recipient__c = objacc.id;
        obGrant.Country__c = objCountry.id;
        obGrant.Disease_Component__c = 'HIV/AIDS';
        obGrant.Start_Date__c = system.today();
        obGrant.End_Date__c = system.today().addyears(1);
        insert obGrant;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objacc.id;
        objIP.Grant__c = obGrant.id;
        objIP.End_Date__c = system.today();
        objIP.Start_Date__c = system.today();
        insert objIP;
        
        Disbursement__c objDisbursement = new Disbursement__c();
        objDisbursement.Implementation_Period__c = objIP.id;
        objDisbursement.Amount_Disbursed_EUR__c = 1.1;
        objDisbursement.Amount_Disbursed_USD__c = 2.2;
        objDisbursement.Disbursement_Date__c = system.today(); 
        objDisbursement.CurrencyIsoCode = 'EUR';
        insert objDisbursement;

        
        GIPFundingSource objGIPFundingSource = new GIPFundingSource();
        
        GIPFundingSource.CreateGIPFundingSourceRecords(setcountry,objConceptNote.id,setCPFR);
    }
}