@isTest
Public Class TestctrlGMIntegratedView{

    Public static testMethod void TestctrlGMIntegratedView(){
        
        account objAccount = TestClassHelper.insertAccount();
 
        Concept_Note__c objConcept_Note = TestClassHelper.createCN();
        objConcept_Note.CCM_new__c = objAccount.id;
        insert objConcept_Note;

        Catalog_Module__c objCM = TestClassHelper.createCatalogModule();
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;
        
        Grant__c objGrant= TestClassHelper.createGrant(objAccount);
        insert objGrant;   
            
        Implementation_Period__c objImplementation_Period = TestClassHelper.createIP(objGrant,objAccount);
        insert objImplementation_Period;

        Implementer__c objImplementer = TestClassHelper.createImplementor();       
       objImplementer.Account__c = objAccount.Id;
       objImplementer.Implementer_Name__c = objAccount.Name;
       objImplementer.Grant_Implementation_Period__c = objImplementation_Period.Id;
        insert objImplementer;

        Period__c objPeriod = TestClassHelper.createPeriod();
        objPeriod.Concept_Note__c = objConcept_Note.Id;
        objPeriod.Implementation_Period__c =  objImplementation_Period.Id;
        objPeriod.Type__c = 'Reporting';
         insert objPeriod;

        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Catalog_Module__c = objCM.id;
        objIndicator.Available_for_PG__c = true;
        objIndicator.Programme_Area__c = 'Malaria';
        //objIndicator.Indicator_Type__c = 'Coverage/Output';
        objIndicator.Catalog_Module__c = objCM.Id;
        objIndicator.Full_Name_En__c = 'test';
        objIndicator.Component__c = objConcept_Note.Component__c;
        insert objIndicator;
    
        Catalog_Cost_Input__c objCCInput = TestClassHelper.insertCostInput();
    
        Goals_Objectives__c objGoals_Objectives = new Goals_Objectives__c();
        objGoals_Objectives.Concept_Note__c = objConcept_Note.id;
        objGoals_Objectives.Type__c = 'Goal';
        insert objGoals_Objectives;
        
        Goals_Objectives__c objGoalsObj = new Goals_Objectives__c ();
        objGoalsObj.Concept_Note__c = objConcept_Note.Id; 
        objGoalsObj.Type__c = 'Objective';
        insert objGoalsObj;

        Module__c objModule = new Module__c();
        objModule.Concept_Note__c = objConcept_Note.id;
        objModule.CN_Module__c = objModule.id;
        objModule.Catalog_Module__c = objCM.Id;  
        objModule.Implementation_Period__c = objImplementation_Period.Id;
        insert objModule;               
        System.Test.startTest();
        
        Intervention__c objIntervention = new Intervention__c();
        objIntervention.Module_rel__c = objModule.id;
        objIntervention.Concept_Note__c = objConcept_Note.id;
        insert objIntervention;
        
        Grant_Intervention__c objGrant_Intervention = new Grant_Intervention__c();
        objGrant_Intervention.Implementation_Period__c = objImplementation_Period.id;
        objGrant_Intervention.Module__c= objModule.id;
        objGrant_Intervention.CN_Intervention__c = objIntervention.Id;
        /*objGrant_Intervention.Indicative_Y1__c = 100;
        objGrant_Intervention.Indicative_Y2__c = 100;
        objGrant_Intervention.Indicative_Y3__c = 100;
        objGrant_Intervention.Indicative_Y4__c = 100;
        objGrant_Intervention.Above_Indicative_Y1__c = 100;
        objGrant_Intervention.Above_Indicative_Y2__c = 100;
        objGrant_Intervention.Above_Indicative_Y3__c = 100;
        objGrant_Intervention.Above_Indicative_Y4__c = 100;*/
        insert objGrant_Intervention;
        
        Budget_Line__c objBudgetLine = TestClassHelper.createBudgetLine();
        objBudgetLine.Grant_Intervention__c = objGrant_Intervention.Id;
        objBudgetLine.Payee__c = objImplementer.Id;
        objBudgetLine.Cost_Input__c = objCCInput.Id;
        objBudgetLine.Q1_Amount__c= 1000;
        objBudgetLine.Q2_Amount__c= 2000;
        objBudgetLine.Q3_Amount__c= 3000;
        objBudgetLine.Q4_Amount__c= 4000;
        objBudgetLine.Q5_Amount__c= 5000;
        objBudgetLine.Q6_Amount__c= 6000;
        objBudgetLine.Q7_Amount__c= 7000;
        objBudgetLine.Q8_Amount__c= 8000;
        objBudgetLine.Q8_Amount__c= 9000;
        objBudgetLine.Currency_Used__c ='Grant Currency';
        insert objBudgetLine;
        
        Grant_Indicator__c objGrant_Indicator3 = new Grant_Indicator__c();
        objGrant_Indicator3.Indicator_Type__c= 'Impact';
        objGrant_Indicator3.Parent_Module__c = objModule.id;
        objGrant_Indicator3.Data_Type__c = 'Number';
        objGrant_Indicator3.Indicator__c = objIndicator.Id;  
        objGrant_Indicator3.Concept_Note__c = objConcept_Note.Id;
        objGrant_Indicator3.Grant_Intervention__c = objGrant_Intervention.Id;           
        insert objGrant_Indicator3;
        
        Grant_Indicator__c objGrant_Indicator1 = new Grant_Indicator__c();
        objGrant_Indicator1.Indicator_Type__c= 'Outcome';
        objGrant_Indicator1.Parent_Module__c = objModule.id;
        objGrant_Indicator1.Data_Type__c = 'Number';
        objGrant_Indicator1.Indicator__c = objIndicator.Id;  
        objGrant_Indicator1.Concept_Note__c = objConcept_Note.Id; 
        objGrant_Indicator1.Grant_Intervention__c = objGrant_Intervention.Id;     
        insert objGrant_Indicator1;     

        Grant_Indicator__c objGrant_Indicator2 = new Grant_Indicator__c();
        objGrant_Indicator2.Indicator_Type__c= 'Coverage/Output';
        objGrant_Indicator2.Parent_Module__c = objModule.id;
        objGrant_Indicator2.Data_Type__c = 'Number';
        objGrant_Indicator2.Indicator__c = objIndicator.Id;  
        objGrant_Indicator2.Concept_Note__c = objConcept_Note.Id; 
        objGrant_Indicator1.Grant_Intervention__c = objGrant_Intervention.Id;     
        insert objGrant_Indicator2; 

 
        Result__c objResult1 = new Result__c();
        objResult1.Indicator__c = objGrant_Indicator1.Id;
        objResult1.Period__c= objPeriod.Id;
        insert objResult1;
        
        Ind_Goal_Jxn__c objInd_Goal_Jxn1 = new Ind_Goal_Jxn__c();
        objInd_Goal_Jxn1.Goal_Objective__c = objGoals_Objectives.id;
        objInd_Goal_Jxn1.Indicator__c = objGrant_Indicator1.id;
        insert objInd_Goal_Jxn1;
        
        Result__c objResult2 = new Result__c();
        objResult2.Indicator__c = objGrant_Indicator2.Id;
        objResult2.Period__c= objPeriod.Id;
        insert objResult2;
        
        Ind_Goal_Jxn__c objInd_Goal_Jxn2 = new Ind_Goal_Jxn__c();
        objInd_Goal_Jxn2.Goal_Objective__c = objGoals_Objectives.id;
        objInd_Goal_Jxn2.Indicator__c = objGrant_Indicator2.id;
        insert objInd_Goal_Jxn2;
         
        Result__c objResult3 = new Result__c();
        objResult3.Indicator__c = objGrant_Indicator3.Id;
        objResult3.Period__c= objPeriod.Id;
        insert objResult3;
        
        Ind_Goal_Jxn__c objInd_Goal_Jxn3 = new Ind_Goal_Jxn__c();
        objInd_Goal_Jxn3.Goal_Objective__c = objGoals_Objectives.id;
        objInd_Goal_Jxn3.Indicator__c = objGrant_Indicator3.id;
        insert objInd_Goal_Jxn3;
        
        Apexpages.currentpage().getparameters().put('id',objImplementation_Period.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objImplementation_Period);
        ctrlGMIntegratedView objGMIntView = new ctrlGMIntegratedView(sc);
        objGMIntView.strCNId = objConcept_Note.Id;
        
        System.Test.stopTest();
    }
}