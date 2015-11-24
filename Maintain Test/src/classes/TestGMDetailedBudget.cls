@isTest
public class TestGMDetailedBudget{
     Public static testMethod void TestGMDetailedBudget(){ 
     
     String AccountRecordType = [Select Id From RecordType Where sobjectType = 'Account' And DeveloperName = 'Implementer_Non_PR'].Id;
     Account objAcc = new Account();
     objAcc.Name = 'Test Acc';
     objAcc.Short_Name__c = 'MOH';
     objAcc.RecordTypeId = AccountRecordType;
     insert objAcc;
     
     Implementation_Period__c ObjImplementationPeriod = new Implementation_Period__c();
     ObjImplementationPeriod.Principal_Recipient__c = objAcc.id;     
     ObjImplementationPeriod.Name = 'NGA-M-test2';
     ObjImplementationPeriod.Currency_of_Grant_Agreement__c = 'EUR';
     ObjImplementationPeriod.Local_Currency__c = 'COP';
     ObjImplementationPeriod.Other_Currency__c = 'EUR';
     insert ObjImplementationPeriod;
     
     Catalog_Cost_Input__c ObjCatalogCostInput= new  Catalog_Cost_Input__c ();
     ObjCatalogCostInput.Name = 'Test1.1 Salaries';
     ObjCatalogCostInput.GIS_ID__c = 123;
     ObjCatalogCostInput.PSM__c = false ;
     ObjCatalogCostInput.CurrencyIsoCode = 'EUR';
     ObjCatalogCostInput.Cost_Grouping__c = '1. Human Resources (HR)';
     ObjCatalogCostInput.Disease_Impact__c= ObjImplementationPeriod.id;
     insert ObjCatalogCostInput;
     
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
     ObjImplementer.Implementer_Name__c = 'test';
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
     insert ObjAssumption;
     
     Page__c objPage = new Page__c();
     objPage.Name = 'Principal Recipients';
     objPage.Implementation_Period__c = ObjImplementationPeriod.id;
     insert objPage;
     
     PSM__c OBjPSM = new PSM__c();
     OBjPSM.Name = 'Test111';
     OBjPSM.CurrencyIsoCode = 'EUR';
     insert OBjPSM;
     
     Profile_Access_Setting__c checkProfile = TestClassHelper.createProfileSetting();
     checkProfile.Page_Name__c ='GMDetailedBudget';
     checkProfile.Salesforce_Item__c = 'External Profile';
     checkProfile.Status__c = 'Not yet submitted by PR';        
     insert checkProfile;
        
     Apexpages.currentpage().getparameters().put('id',ObjModule.Id);
     ApexPages.StandardController sc = new ApexPages.StandardController(ObjModule);
     GMDetailedBudget objGMD = new GMDetailedBudget(sc);
     
    
     objGMD.strComponent = ObjImplementationPeriod.Component__c;
     objGMD.FillCostInput();
     //objGMD.RetriveAssumptionFromSet();
     
     objGMD.FillImplementers();
    // objGMD.objCCIforGrouping.Cost_Grouping__c = ObjCatalogCostInput.Cost_Grouping__c;
   //  objGMD.strSelectedPayee = ObjImplementer.id;
     
    // objGMD.RetreveAndFilterBudgetLines();
     
     objGMD.SaveAssumption();
     
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
   //  objwrapBudgetLines.AssumptionCount = 0;
     objwrapBudgetLines.lstAssumptions = lst;
 //    objGMD.lstBudgetLines.add(objwrapBudgetLines);
    
    objGMD.RetriveAssumptionFromSet();
   /*  objCatalogCostInput.Cost_Grouping__c = '2. Travel related costs (TRC)';
     ObjCatalogCostInput.Disease_Impact__c= ObjImplementationPeriod.id;
     update ObjCatalogCostInput;
     ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.id; 
     update ObjBudgetLine;
     GMDetailedBudget.wrapBudgetLines objwrapBudgetLines1 = new GMDetailedBudget.wrapBudgetLines();
     objwrapBudgetLines1.objBudgetLine = ObjBudgetLine;
     objwrapBudgetLines1.AssumptionCount = 1;
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
     objwrapBudgetLines2.AssumptionCount = 1;
     objwrapBudgetLines2.lstAssumptions = lst;
     objGMD.lstBudgetLines.add(objwrapBudgetLines2);
     objGMD.intIndex = 1;
     objGMD.RetriveAssumptionFromSet();*/
     
     Apexpages.currentpage().getparameters().put('CancelBLIndex','0');
     objGMD.CancelBLAssumptionNoRecords();
     
     Apexpages.currentpage().getparameters().put('DeleteIndex','0');
     objGMD.DeleteBudgetLine();
     
     objGMD.checkProfile();
   
     
    
     }
}