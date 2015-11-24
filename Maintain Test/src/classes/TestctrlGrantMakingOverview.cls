@isTest
global class TestctrlGrantMakingOverview{
    Public static testMethod void ctrlGrantMakingOverviewTest(){
        
        /*Period__c ObjRP = new Period__c();
        ObjRP.Country__c = 'Test';
        insert ObjRP; 
        
        Module__c ObjModule = new Module__c();
        ObjModule.Name = 'Test';
        ObjModule.CurrencyIsoCode = 'EUR';
        insert ObjModule;
     
        Implementer__c ObjImplementer = new Implementer__c();
        ObjImplementer.Implementer_Name__c = 'Test';       
        insert ObjImplementer;
      
        Implementation_Period__c ObjImplementationPeriod = new Implementation_Period__c();
        ObjImplementationPeriod.Name = 'NGA-M-UNDP';
        ObjImplementationPeriod.Principal_Recipient__c = '001g000000A8HKj';
        insert ObjImplementationPeriod;
        
        Grant_Intervention__c ObjGrantIntervention = new Grant_Intervention__c();
        ObjGrantIntervention.Implementation_Period__c = objIP.id;
        insert ObjGrantIntervention;
        
        Catalog_Cost_Input__c ObjCatalogCostInput = new Catalog_Cost_Input__c();
        ObjCatalogCostInput.Name = '8.2 Renovation/constructions';
        ObjCatalogCostInput.GIS_ID__c = 46;
        ObjCatalogCostInput.CurrencyIsoCode = 'EUR'; 
        ObjCatalogCostInput.Cost_Grouping__c = '1. Human Resources (HR)';
        insert ObjCatalogCostInput;
       
        //Catalog_Cost_Input__c ObjCatalogCostInput = TestClassHelper.insertCostInput();
       
        Budget_Line__c ObjBudgetLine = new Budget_Line__c();
        ObjBudgetLine.CurrencyIsoCode = 'EUR';   
        ObjBudgetLine.Grant_Intervention__c = ObjGrantIntervention.id; 
        ObjBudgetLine.Payee__c = ObjImplementer.id;  
        ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.Id;
        insert ObjBudgetLine;
               
      
        Page__c ObjPage = new Page__c();
        Objpage.Name = 'Test';
        Objpage.Status__c= 'Draft';
        Objpage.Implementation_Period__c = ObjImplementationPeriod.id;
        insert Objpage;*/
        
        
        Account objAcc = TestClassHelper.insertAccount();
        Period__c ObjRP = TestClassHelper.insertPeriod();
        
        Module__c ObjModule = TestClassHelper.createModule();
        insert ObjModule;
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementer__c ObjImplementer = TestClassHelper.insertImplementor();
        test.startTest();
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        objIP.Rationale_for_Program__c= 'rationaleTest';//Revert commented after changes to field type is deployed
        objIP.Goals_and_Strategies_for_program__c= 'goalsAndStrategiesTest';
        objIP.Target_beneficiaries_of_program__c = 'beneficiariesTest';
        insert objIP;
        
        Grant_Intervention__c ObjGrantIntervention = TestClassHelper.createGrantIntervention(objIP);
        insert ObjGrantIntervention;
        
        Catalog_Cost_Input__c ObjCatalogCostInput = TestClassHelper.insertCostInput();
        
        
        Budget_Line__c ObjBudgetLine = TestClassHelper.createBudgetLine();
        ObjBudgetLine.Grant_Intervention__c = ObjGrantIntervention.id; 
        ObjBudgetLine.Payee__c = ObjImplementer.id;  
        ObjBudgetLine.Cost_Input__c = ObjCatalogCostInput.Id;
        insert ObjBudgetLine;
        
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Implementation_Period__c = objIP.Id;
        insert Objpage;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = label.Grant_Making_Overview;
        insert objGuidance;
        
        Apexpages.currentpage().getparameters().put('id',objIP.Id);       
        ApexPages.StandardController sc = new ApexPages.StandardController(objIP);
        //system.debug('**sc'+sc);
        ctrlGrantMakingOverview objGMO = new ctrlGrantMakingOverview(sc);
        objGMO.strGuidanceId  = objGuidance.Id;
           
        ctrlGrantMakingOverview.loadDataModule();
        ctrlGrantMakingOverview.loadDataPayee();
        ctrlGrantMakingOverview.loadDataCost();
         test.stopTest();
        Apexpages.currentpage().getparameters().put('SavePageIndex','0');
        objGMO.SavePage();
        
        Apexpages.currentpage().getparameters().put('ReviewIndex','0');
        //objGMO.SubmitToReview();
        Apexpages.currentpage().getparameters().put('CancelPageIndex','0');
        objGMO.CancelPage();
        objGMO.SaveChanges();
        //objGMO.SubmitToGrant();
        objGMO.CheckBoolean();   
        //objGMO.saveIP();
        //objGMO.cancelIP();
        //objGMO.saveText();
        objGMO.doEdit();
             
    }
     Public static testMethod void ctrlGrantMakingOverviewTest1(){
     	test.startTest();
        Account objAcc = TestClassHelper.insertAccount();
        Period__c ObjRP = TestClassHelper.insertPeriod();
        
        Module__c ObjModule = TestClassHelper.createModule();
        insert ObjModule;
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementer__c ObjImplementer = TestClassHelper.insertImplementor();
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        objIP.Rationale_for_Program__c= 'rationaleTest';//Revert commented after changes to field type is deployed
        objIP.Goals_and_Strategies_for_program__c= 'goalsAndStrategiesTest';
        objIP.Target_beneficiaries_of_program__c = 'beneficiariesTest';
        insert objIP;
        
        IP_Detail_Information__c objIpDetails = new IP_Detail_Information__c();
        objIpDetails.Budget_Status__c = 'Not yet submitted by PR';
        objIpDetails.Implementation_Period__c = objIP.Id;
        insert objIpDetails;
        
        Profile_Access_Setting__c checkProfile = TestClassHelper.createProfileSetting();
        checkProfile.Page_Name__c ='GrantMakingOverview';
        checkProfile.Salesforce_Item__c = 'Submit Budget to Country Team';
        checkProfile.Status__c = 'Not yet submitted by PR';        
        insert checkProfile;
        
        Apexpages.currentpage().getparameters().put('id',objIP.Id);       
        ApexPages.StandardController sc = new ApexPages.StandardController(objIP);
        //system.debug('**sc'+sc);
        ctrlGrantMakingOverview objGMO = new ctrlGrantMakingOverview(sc);
        //objGMO.strGuidanceId  = objGuidance.Id;
        objGMO.checkProfile();
        objGMO.SubmitDetailBudget();
     }

}