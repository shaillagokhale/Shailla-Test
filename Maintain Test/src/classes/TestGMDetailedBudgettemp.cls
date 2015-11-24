@isTest
public class TestGMDetailedBudgettemp{
     Public static testMethod void TestGMDetailedBudgettemp(){ 
     
    // String AccountRecordType = [Select Id From RecordType Where sobjectType = 'Account' And DeveloperName = 'Implementer_Non_PR'].Id;
     
     Account objAcc = TestClassHelper.insertAccount();
     
     Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
     insert objGrant;
     
     Implementation_Period__c ObjImplementationPeriod = TestClassHelper.createIP(objGrant,objAcc);
     ObjImplementationPeriod.Currency_of_Grant_Agreement__c = 'EUR';
     ObjImplementationPeriod.Local_Currency__c = 'COP';
     ObjImplementationPeriod.Other_Currency__c = 'EUR';
     ObjImplementationPeriod.Exchange_Rate__c = 50;
     ObjImplementationPeriod.Budget_Status__c = 'Draft';
     insert ObjImplementationPeriod;
      
     Module__c ObjModule = TestClassHelper.createModule();
     ObjModule.Implementation_Period__c = ObjImplementationPeriod.id;
     insert ObjModule; 
     
     Grant_Intervention__c ObjGrantIntervention = TestClassHelper.createGrantIntervention(ObjImplementationPeriod);
     ObjGrantIntervention.Module__c = ObjModule.id;
     insert ObjGrantIntervention;
     
     Catalog_Cost_Input__c ObjCatalogCostInput = TestClassHelper.createCostInput();
     ObjCatalogCostInput.Cost_Grouping__c = '1. Human Resources (HR)';
     insert ObjCatalogCostInput;
      
     Budget_Line__c ObjBudgetLine = TestClassHelper.createBudgetLine();
     ObjBudgetLine.Grant_Intervention__c = ObjGrantIntervention.id;
     ObjBudgetLine.Cost_input__c = ObjCatalogCostInput.id;
     ObjBudgetLine.Q1_Amount__c = 1;
     ObjBudgetLine.Q2_Amount__c = 2;
     ObjBudgetLine.Q3_Amount__c = 3;
     ObjBudgetLine.Q4_Amount__c = 4;
     ObjBudgetLine.Q5_Amount__c = 2;
     ObjBudgetLine.Q6_Amount__c = 3;
     ObjBudgetLine.Q7_Amount__c = 2;
     ObjBudgetLine.Q8_Amount__c = 4;
     ObjBudgetLine.Q9_Amount__c = 2;
     ObjBudgetLine.Q10_Amount__c =5;
     ObjBudgetLine.Q11_Amount__c = 1;
     ObjBudgetLine.Q12_Amount__c = 1;
     ObjBudgetLine.Q13_Amount__c = 7;
     ObjBudgetLine.Q14_Amount__c = 1;
     ObjBudgetLine.Q15_Amount__c = 2;
     ObjBudgetLine.Q16_Amount__c = 2;
     insert ObjBudgetLine ;
     
     Budget_Line__c ObjBudgetLine2 = TestClassHelper.createBudgetLine();
     ObjBudgetLine2.Grant_Intervention__c = ObjGrantIntervention.id;
     ObjBudgetLine2.Cost_input__c = ObjCatalogCostInput.id;
     ObjBudgetLine2.Q1_Amount__c = 1;
     ObjBudgetLine2.Q2_Amount__c = 2;
     ObjBudgetLine2.Q3_Amount__c = 3;
     ObjBudgetLine2.Q4_Amount__c = 4;
     ObjBudgetLine2.Q5_Amount__c = 2;
     ObjBudgetLine2.Q6_Amount__c = 3;
     ObjBudgetLine2.Q7_Amount__c = 2;
     ObjBudgetLine2.Q8_Amount__c = 4;
     ObjBudgetLine2.Q9_Amount__c = 2;
     ObjBudgetLine2.Q10_Amount__c =5;
     ObjBudgetLine2.Q11_Amount__c = 1;
     ObjBudgetLine2.Q12_Amount__c = 1;
     ObjBudgetLine2.Q13_Amount__c = 7;
     ObjBudgetLine2.Q14_Amount__c = 1;
     ObjBudgetLine2.Q15_Amount__c = 2;
     ObjBudgetLine2.Q16_Amount__c = 2;
   //  insert ObjBudgetLine2 ;
     


     /*

     Module__c ObjModule = new Module__c();
     ObjModule.Name = 'PMTCT';
     ObjModule.CurrencyIsoCode = 'EUR';
     ObjModule.Implementation_Period__c = ObjImplementationPeriod.id;
     insert ObjModule;

     Grant_Intervention__c ObjGrantIntervention = new Grant_Intervention__c();
     ObjGrantIntervention.Implementation_Period__c = ObjImplementationPeriod.id;
     ObjGrantIntervention.Name = 'Testmonty';
     ObjGrantIntervention.CurrencyIsoCode = 'EUR';
     ObjGrantIntervention.Module__c = ObjModule.id;
     insert ObjGrantIntervention;
     
     Implementer__c ObjImplementer = new Implementer__c();
     ObjImplementer.Name = 'test';
     ObjImplementer.Grant_Implementation_Period__c = ObjImplementationPeriod.id;
     insert ObjImplementer;
     
     Budget_Line__c ObjBudgetLine = new Budget_Line__c();
     ObjBudgetLine.Grant_Intervention__c = ObjGrantIntervention.id; 
     ObjBudgetLine.CurrencyIsoCode = 'EUR';
     ObjBudgetLine.Budget_Line_Number__c = 1; 
     ObjBudgetLine.Currency_Used__c = 'Grant Currency';  
     ObjBudgetLine.Payee__c = ObjImplementer.id; 
     ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.id; 
     insert ObjBudgetLine;
     
    */
     
     Assumption_Set__c ObjAssumptionSet = new Assumption_Set__c();
     ObjAssumptionSet.Name = 'test';
     ObjAssumptionSet.CurrencyIsoCode = 'EUR';
     ObjAssumptionSet.Implementation_Period__c = ObjImplementationPeriod.id;
     ObjAssumptionSet.Cost_Input__c = ObjBudgetLine.Cost_Input__c;
     insert ObjAssumptionSet;
     
     Assumption__c ObjAssumption = new Assumption__c();
     ObjAssumption.Name='Test test';
     ObjAssumption.CurrencyIsoCode = 'EUR';
     ObjAssumption.Payment_Currency__c = 'Local Currency';
     ObjAssumption.Budget_Line_Number__c = ObjBudgetLine.id;
     ObjAssumption.Assumption_Set__c = ObjAssumptionSet.id;
     ObjAssumption.Cost_Input__c = ObjCatalogCostInput.id;
     ObjAssumption.Y1_Quantity__c= 1;
     ObjAssumption.Y1_Unit_Cost_Payment_Currency__c= 3;
     ObjAssumption.Y1_Net_Salary_Payment_Currency__c= 12;
    
     ObjAssumption.Y1_Level_of_Effort__c= 0;
     ObjAssumption.Y1_Social_Security_Obligatory_Charges__c= 5;
     ObjAssumption.Y1_Number_of_Persons__c= 10;
     ObjAssumption.Y2_Duration_Days__c= 7;
     ObjAssumption.Y2_Quantity__c= 8;
     ObjAssumption.Y2_Unit_Cost_Payment_Currency__c= 1;
     ObjAssumption.Y2_Net_Salary_Payment_Currency__c= 9;
    
     ObjAssumption.Y2_Level_of_Effort__c= 2;
     ObjAssumption.Y2_Social_Security_Obligatory_Charges__c= 1;
     ObjAssumption.Y2_Number_of_Persons__c= 1;
     ObjAssumption.Y4_Duration_Days__c= 2;
     ObjAssumption.Y4_Quantity__c= 3;
     ObjAssumption.Y4_Unit_Cost_Payment_Currency__c= 5;
     ObjAssumption.Y4_Net_Salary_Payment_Currency__c= 6;
     
     ObjAssumption.Y4_Level_of_Effort__c= 1;
     ObjAssumption.Y4_Social_Security_Obligatory_Charges__c= 3;
     ObjAssumption.Y3_Number_of_Persons__c= 7;
     ObjAssumption.Y3_Duration_Days__c= 8;
     ObjAssumption.Y3_Quantity__c= 1;
     ObjAssumption.Y3_Unit_Cost_Payment_Currency__c= 3;
     ObjAssumption.Y3_Net_Salary_Payment_Currency__c= 6;
     
     ObjAssumption.Y3_Level_of_Effort__c= 2;
     ObjAssumption.Y3_Social_Security_Obligatory_Charges__c= 8;
     ObjAssumption.Y3_Number_of_Persons__c= 2;
     insert ObjAssumption;
     
     Page__c objPage = new Page__c();
     objPage.Name = 'Principal Recipients';
     objPage.Implementation_Period__c = ObjImplementationPeriod.id;
     insert objPage;
     
     PSM__c OBjPSM = new PSM__c();
     OBjPSM.Name = 'Test111';
     OBjPSM.CurrencyIsoCode = 'EUR';
     insert OBjPSM;
     
     Apexpages.currentpage().getparameters().put('id',ObjModule.Id);
     ApexPages.StandardController sc = new ApexPages.StandardController(ObjModule);
     GMDetailedBudget objGMD = new GMDetailedBudget(sc);
     
    
     objGMD.strComponent = ObjImplementationPeriod.Component__c;
     objGMD.FillCostInput();
  //   objGMD.RetriveAssumptionFromSet();
     
     objGMD.FillImplementers();
     objGMD.FillCostGroup();
    // objGMD.objCCIforGrouping.Cost_Grouping__c = ObjCatalogCostInput.Cost_Grouping__c;
   //  objGMD.strSelectedPayee = ObjImplementer.id;
     
    // objGMD.RetreveAndFilterBudgetLines();
     
    /* objGMD.SaveAssumption();
     
     objGMD.SaveAssumptionNew();
     
     objGMD.ChangeBudgetLineOutFlowsValues();
     
     objGMD.ChangeBudgetLineOutFlowsValuesNew();
     Apexpages.currentpage().getparameters().put('intIndex','0');
     objGMD.SaveAssumption();
     
     Apexpages.currentpage().getparameters().put('Code','0');
     objGMD.ChangeCurrencyRateFromCodeNew();
     
     Apexpages.currentpage().getparameters().put('Code','0');
     Apexpages.currentpage().getparameters().put('ChangeIndex','0');
     objGMD.ChangeCurrencyRateFromCode();
     
     Apexpages.currentpage().getparameters().put('CancelIndex','0');
     objGMD.CancelAssumptionRecords();
     
     Apexpages.currentpage().getparameters().put('OpenBLIndex','0');
     objGMD.OpenAssumptionNoRecords();
     
     Apexpages.currentpage().getparameters().put('SaveBLIndex','0');
     objGMD.SaveBLAssumptionNoRecords();
     
     //Apexpages.currentpage().getparameters().put('SaveIndex','0');
     //objGMD.SaveBudgetLines();
  //   objGMD.RetreveAndFilterBudgetLines();
     
      objGMD.intIndex = 0;
     
     
     GMDetailedBudget.wrapAssumption objwrapAssumption  = new GMDetailedBudget.wrapAssumption();
     objwrapAssumption.strCurrencyUsedAssumption = 'Grant Currency';
     objwrapAssumption.objAssumption  = ObjAssumption;
     List<GMDetailedBudget.wrapAssumption> lst= new List<GMDetailedBudget.wrapAssumption>();
     lst.add(objwrapAssumption);
     
     GMDetailedBudget.wrapBudgetLines objWrp = objGMD.fillwraperObject(ObjBudgetLine);
     objGMD.strAssumptionSet = String.valueOf(ObjAssumptionSet.id);
     GMDetailedBudget.wrapBudgetLines objwrapBudgetLines = new GMDetailedBudget.wrapBudgetLines();
     objwrapBudgetLines.objBudgetLine = ObjBudgetLine;
     //objwrapBudgetLines.AssumptionCount = 0;
     objwrapBudgetLines.lstAssumptions = lst;
 //    objGMD.lstBudgetLines.add(objwrapBudgetLines);
    
   // objGMD.RetriveAssumptionFromSet();
     objCatalogCostInput.Cost_Grouping__c = '2. Travel related costs (TRC)';
     ObjCatalogCostInput.Disease_Impact__c= ObjImplementationPeriod.id;
     update ObjCatalogCostInput;
     ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.id; 
     update ObjBudgetLine;
     GMDetailedBudget.wrapBudgetLines objwrapBudgetLines1 = new GMDetailedBudget.wrapBudgetLines();
     objwrapBudgetLines1.objBudgetLine = ObjBudgetLine;
     //objwrapBudgetLines1.AssumptionCount = 1;
     objwrapBudgetLines1.lstAssumptions = lst;
     
     objGMD.lstBudgetLines.add(objwrapBudgetLines1 );
     objGMD.intIndex = 1;
     objGMD.RetriveAssumptionFromSet();
     objCatalogCostInput.Cost_Grouping__c = '2. Travel related costs (TRC)';
     ObjCatalogCostInput.Disease_Impact__c= ObjImplementationPeriod.id;
     update ObjCatalogCostInput;
     ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.id; 
     update ObjBudgetLine;
     
     GMDetailedBudget.wrapBudgetLines objwrapBudgetLines2 = new GMDetailedBudget.wrapBudgetLines();
     objwrapBudgetLines2.objBudgetLine = ObjBudgetLine;
     //objwrapBudgetLines2.AssumptionCount = 1;
     objwrapBudgetLines2.lstAssumptions = lst;
     objGMD.lstBudgetLines.add(objwrapBudgetLines2);
     objGMD.intIndex = 1;
     objGMD.RetriveAssumptionFromSet();
     
     Apexpages.currentpage().getparameters().put('CancelBLIndex','0');
     objGMD.CancelBLAssumptionNoRecords();
     
     Apexpages.currentpage().getparameters().put('DeleteIndex','0');
     objGMD.DeleteBudgetLine();*/
     
   
     
     test.starttest();
     
     
     Apexpages.currentpage().getparameters().put('EditIndex','0');
     objGMD.EditBudgetLine();
     
     
     
     Apexpages.currentpage().getparameters().put('CancelIndex','0');
     objGMD.CancelBudgetLine();
     
     objGMD.EditBudgetLine();
     objGMD.retriveBudjetLine(ObjBudgetLine.id);
     
     /*Apexpages.currentpage().getparameters().put('Code','USD');
     Apexpages.currentpage().getparameters().put('ChangeIndex','0');
     //Apexpages.currentpage().getparameters().put('intIndex','0');
       //objGMD.intIndex = 0;
       objGMD.ChangeCurrencyRateFromCode();*/
     
     Apexpages.currentpage().getparameters().put('SelectIndex','0');
     objGMD.SelectUnitMeasure();

     
     objGMD.PopulateCostInput();
     objGMD.PopulateCostGrouping();
     
     objGMD.fillwraperObject(ObjBudgetLine);
     
     
     
   
     Apexpages.currentpage().getparameters().put('SaveIndex','0');
     objGMD.SaveBudgetLines();
     
     
     GMDetailedBudget.wrapAssumption objwrapAssumption  = new GMDetailedBudget.wrapAssumption();
     objwrapAssumption.strCurrencyUsedAssumption = 'Grant Currency';
     objwrapAssumption.objAssumption  = ObjAssumption;
     List<GMDetailedBudget.wrapAssumption> lst= new List<GMDetailedBudget.wrapAssumption>();
     lst.add(objwrapAssumption);
     
     
     
     GMDetailedBudget.wrapBudgetLines objwrapBudgetLines = objGMD.fillwraperObject(ObjBudgetLine);
     objGMD.strAssumptionSet = String.valueOf(ObjAssumptionSet.id);
    // GMDetailedBudget.wrapBudgetLines objwrapBudgetLines = new GMDetailedBudget.wrapBudgetLines();
     objwrapBudgetLines.objBudgetLine = ObjBudgetLine;
     //objwrapBudgetLines.AssumptionCount = 0;
     objwrapBudgetLines.lstAssumptions = lst;
     objGMD.lstBudgetLines.add(objwrapBudgetLines);

    
   // objGMD.RetriveAssumptionFromSet();
     objCatalogCostInput.Cost_Grouping__c = '1. Human Resources (HR)';
     ObjCatalogCostInput.Disease_Impact__c= ObjImplementationPeriod.id;
     update ObjCatalogCostInput;
     ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.id; 
     update ObjBudgetLine;
     
     GMDetailedBudget.wrapBudgetLines objwrapBudgetLines1 = new GMDetailedBudget.wrapBudgetLines();
     objwrapBudgetLines1.objBudgetLine = ObjBudgetLine;
     //objwrapBudgetLines1.AssumptionCount = 1;
     objwrapBudgetLines1.lstAssumptions = lst;
     
     objGMD.lstBudgetLines.add(objwrapBudgetLines1 );
     objGMD.intIndex = 1;
     objGMD.RetriveAssumptionFromSet();
     objCatalogCostInput.Cost_Grouping__c = '1. Human Resources (HR)';
     ObjCatalogCostInput.Disease_Impact__c= ObjImplementationPeriod.id;
     update ObjCatalogCostInput;
     ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.id; 
     update ObjBudgetLine;
     
     GMDetailedBudget.wrapBudgetLines objwrapBudgetLines2 = new GMDetailedBudget.wrapBudgetLines();
     objwrapBudgetLines2.objBudgetLine = ObjBudgetLine;
     //objwrapBudgetLines2.AssumptionCount = 1;
     objwrapBudgetLines2.lstAssumptions = lst;
     objGMD.lstBudgetLines.add(objwrapBudgetLines2);
     objGMD.intIndex = 1;
     objGMD.RetriveAssumptionFromSet();
     
     Apexpages.currentpage().getparameters().put('intIndex','0');
     objGMD.SaveAssumption();
     
     objGMD.SaveAssumptionNew();
     
    
     Apexpages.currentpage().getparameters().put('Code','USD');
     Apexpages.currentpage().getparameters().put('ChangeIndex','0');
     //Apexpages.currentpage().getparameters().put('intIndex','0');
     //objGMD.intIndex = 0;
     objGMD.ChangeCurrencyRateFromCode();
      
     Apexpages.currentpage().getparameters().put('Code','0');
     objGMD.ChangeCurrencyRateFromCodeNew();
     
     Apexpages.currentpage().getparameters().put('CostInputId',ObjBudgetLine.Cost_input__c);
     objGMD.SelectUnitMeasureNew();
     
     Apexpages.currentpage().getparameters().put('CancelIndex','0');
     objGMD.CancelAssumptionRecords();
     
      Apexpages.currentpage().getparameters().put('OpenBLIndex','0');
     objGMD.OpenAssumptionNoRecords();
     
      Apexpages.currentpage().getparameters().put('DeleteIndex','1');
     objGMD.DeleteAssumption();
     
     
     Apexpages.currentpage().getparameters().put('EditIndex','0');
     objGMD.EditAssumptionRecords();
     
     Apexpages.currentpage().getparameters().put('CancelBLIndex','0');
     objGMD.CancelBLAssumptionNoRecords();
     
     Apexpages.currentpage().getparameters().put('SaveBLIndex','0');
     objGMD.SaveBLAssumptionNoRecords();
      
         
     Apexpages.currentpage().getparameters().put('intEditBLIndex','0');
     objGMD.ChangeBudgetLineOutFlowsValues();
     
     objGMD.ChangeBudgetLineOutFlowsValuesNew();
     
     Apexpages.currentpage().getparameters().put('DeleteIndex','0');
     objGMD.DeleteBudgetLine();
     
      test.stopTest();
     
     }
     
    
}