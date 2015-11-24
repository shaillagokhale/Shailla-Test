@isTest
Public Class TestCN_IntegratedView_pdf{
    Public static testMethod void TestCN_IntegratedView_pdf(){
        
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
        
        
        Programmatic_Gap__c objProgrammaticGap = new Programmatic_Gap__c();
        objProgrammaticGap.Concept_Note__c = objConcept_Note.id;
        objProgrammaticGap.Catalog_Indicator__c = objIndicator.id;
        objProgrammaticGap.Indicator__c = objGrant_Indicator.id; 
        objProgrammaticGap.Group_Sequence__c = 1;
        objProgrammaticGap.Sequence__c = 1;
        objProgrammaticGap.Baseline_Source__c = 'Operational Research';
        objProgrammaticGap.Baseline_year__c = '2002';
        objProgrammaticGap.Baseline_value__c = 1;
        objProgrammaticGap.Rationale_for_Chosen_Indicator__c = 'test';
        objProgrammaticGap.Metric__c = 'test';
        objProgrammaticGap.Coverage_Comments__c = 'test';
        objProgrammaticGap.Module__c = objModule.id;
        insert objProgrammaticGap;
        
        Goals_Objectives__c objGoals_Objectives = new Goals_Objectives__c();
        objGoals_Objectives.Concept_Note__c = objConcept_Note.id;
        objGoals_Objectives.Type__c = 'Goal';
        insert objGoals_Objectives;
        
        Ind_Goal_Jxn__c objInd_Goal_Jxn = new Ind_Goal_Jxn__c();
        objInd_Goal_Jxn.Goal_Objective__c = objGoals_Objectives.id;
        objInd_Goal_Jxn.Indicator__c = objGrant_Indicator.id;
        insert objInd_Goal_Jxn;
        
        Goals_Objectives__c objGoals_Objectives1 = new Goals_Objectives__c();
        objGoals_Objectives1.Concept_Note__c = objConcept_Note.id;
        objGoals_Objectives1.Type__c = 'Objectives';
        insert objGoals_Objectives1;
        
        Ind_Goal_Jxn__c objInd_Goal_Jxn1 = new Ind_Goal_Jxn__c();
        objInd_Goal_Jxn1.Goal_Objective__c = objGoals_Objectives1.id;
        objInd_Goal_Jxn1.Indicator__c = objGrant_Indicator.id;
        insert objInd_Goal_Jxn1;
                       
        Intervention__c objIntervention = new Intervention__c();
        objIntervention.Module_rel__c = objModule.id;
        objIntervention.Concept_Note__c = objConcept_Note.id;
        insert objIntervention;
        
        Grant_Intervention__c objGrant_Intervention = new Grant_Intervention__c();
        objGrant_Intervention.Implementation_Period__c = objImplementation_Period.id;
        objGrant_Intervention.Module__c= objModule.id;
        objGrant_Intervention.CN_Intervention__c = objIntervention.Id;
        objGrant_Intervention.Indicative_Y1__c = 100;
        objGrant_Intervention.Indicative_Y2__c = 100;
        objGrant_Intervention.Indicative_Y3__c = 100;
        objGrant_Intervention.Indicative_Y4__c = 100;
        objGrant_Intervention.Above_Indicative_Y1__c = 100;
        objGrant_Intervention.Above_Indicative_Y2__c = 100;
        objGrant_Intervention.Above_Indicative_Y3__c = 100;
        objGrant_Intervention.Above_Indicative_Y4__c = 100;
        insert objGrant_Intervention;
        
        CPF_Report__c objCPF = new CPF_Report__c();
        objCPF.Implementation_cycle__c = 'January - December';
        objCPF.Concept_Note__c = objConcept_Note.Id;
        objCPF.Indicative_Y1__c = 10;
        objCPF.Indicative_Y2__c = 20;
        objCPF.Indicative_Y3__c = 10;
        objCPF.Indicative_Y4__c = 30;
        insert objCPF;
        
        Apexpages.currentpage().getparameters().put('id',objConcept_Note.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objConcept_Note);
        CN_IntegratedView_pdf objCN_IntegratedView_pdf = new CN_IntegratedView_pdf(sc);
    }
    
    Public static testMethod void TestCN_IntegratedView_pdf1(){
        
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
       
        
        Indicator__c objIndicator1 = new Indicator__c();
        objIndicator1.Catalog_Module__c = objCM.id;
        objIndicator1.Available_for_PG__c = true;
        objIndicator1.Programme_Area__c = 'Malaria';
        objIndicator1.Indicator_Type__c = 'Coverage/Output';
        objIndicator1.Catalog_Module__c = objCM.Id;
        objIndicator1.Full_Name_En__c = 'test';
        objIndicator1.Component__c = objConcept_Note.Component__c;
        objIndicator1.LLIN__c = true;      
        insert objIndicator1;
        
        Grant_Indicator__c objGrant_Indicator = new Grant_Indicator__c();
        objGrant_Indicator.Indicator_Type__c='Coverage/Output';
        objGrant_Indicator.Parent_Module__c = objModule.id;
        objGrant_Indicator.Data_Type__c = 'Number';
        objGrant_Indicator.Indicator__c = objIndicator1.Id; 
        objGrant_Indicator.Concept_Note__c = objConcept_Note.id; 
        insert objGrant_Indicator;
        
        Programmatic_Gap__c objProgrammaticGap = new Programmatic_Gap__c();
        objProgrammaticGap.Concept_Note__c = objConcept_Note.id;
        objProgrammaticGap.Catalog_Indicator__c = objIndicator1.id;
        objProgrammaticGap.Indicator__c = objGrant_Indicator.id; 
        objProgrammaticGap.Group_Sequence__c = 1;
        objProgrammaticGap.Sequence__c = 1;
        objProgrammaticGap.Baseline_Source__c = 'Operational Research';
        objProgrammaticGap.Baseline_year__c = '2002';
        objProgrammaticGap.Baseline_value__c = 1;
        objProgrammaticGap.Rationale_for_Chosen_Indicator__c = 'test';
        objProgrammaticGap.Metric__c = 'test';
        objProgrammaticGap.Coverage_Comments__c = 'test';
        objProgrammaticGap.Module__c = objModule.id;
        insert objProgrammaticGap;
        
        Goals_Objectives__c objGoals_Objectives = new Goals_Objectives__c();
        objGoals_Objectives.Concept_Note__c = objConcept_Note.id;
        objGoals_Objectives.Type__c = 'Goal';
        insert objGoals_Objectives;
        
        Ind_Goal_Jxn__c objInd_Goal_Jxn = new Ind_Goal_Jxn__c();
        objInd_Goal_Jxn.Goal_Objective__c = objGoals_Objectives.id;
        objInd_Goal_Jxn.Indicator__c = objGrant_Indicator.id;
        insert objInd_Goal_Jxn;
                       
        Intervention__c objIntervention = new Intervention__c();
        objIntervention.Module_rel__c = objModule.id;
        objIntervention.Concept_Note__c = objConcept_Note.id;
        insert objIntervention;
        
        Grant_Intervention__c objGrant_Intervention = new Grant_Intervention__c();
        objGrant_Intervention.Implementation_Period__c = objImplementation_Period.id;
        objGrant_Intervention.Module__c= objModule.id;
        objGrant_Intervention.CN_Intervention__c = objIntervention.Id;
        objGrant_Intervention.Indicative_Y1__c = 100;
        objGrant_Intervention.Indicative_Y2__c = 100;
        objGrant_Intervention.Indicative_Y3__c = 100;
        objGrant_Intervention.Indicative_Y4__c = 100;
        objGrant_Intervention.Above_Indicative_Y1__c = 100;
        objGrant_Intervention.Above_Indicative_Y2__c = 100;
        objGrant_Intervention.Above_Indicative_Y3__c = 100;
        objGrant_Intervention.Above_Indicative_Y4__c = 100;
        insert objGrant_Intervention;
        
        CPF_Report__c objCPF = new CPF_Report__c();
        objCPF.Implementation_cycle__c = 'January - December';
        objCPF.Concept_Note__c = objConcept_Note.Id;
        objCPF.Indicative_Y1__c = 10;
        objCPF.Indicative_Y2__c = 20;
        objCPF.Indicative_Y3__c = 10;
        objCPF.Indicative_Y4__c = 30;
        insert objCPF;
        
        Apexpages.currentpage().getparameters().put('id',objConcept_Note.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objConcept_Note);
        CN_IntegratedView_pdf objCN_IntegratedView_pdf = new CN_IntegratedView_pdf(sc);
    }
}