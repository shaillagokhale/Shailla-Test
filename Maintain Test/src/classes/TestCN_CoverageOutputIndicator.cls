@isTest
Public Class TestCN_CoverageOutputIndicator{
    Public Static testMethod void TestCN_CoverageOutputIndicator(){
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Coverage & Output Indicators';
        insert objGuidance;
        
        Country__c obCountry = new Country__c();
        obCountry.Name = 'Testcountry';
        obCountry.French_Name__c = 'TestFrench';
        obCountry.Russian_Name__c = 'TestRussian';
        obCountry.Spanish_Name__c = 'TestSpanish';
        insert obCountry;
        
        Account objacc1 = new Account();
        objacc1.name = 'testacc1';
        objacc1.Country__c = obCountry.id;
        insert objacc1;
        
        Account objacc = new Account();
        objacc.name = objacc1.id;
        objacc.Country__c = obCountry.id;
        insert objacc;
    	
    	Concept_Note__c objConceptNote = TestClassHelper.createCN();
        //Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.Name = 'TestName';
        objConceptNote.CurrencyIsoCode = 'EUR';
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.Language__c = 'ENGLISH';
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.Component__c = 'Tuberculosis';
        objConceptNote.Status__c = 'Not yet submitted';
        insert objConceptNote; 
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test';
        objIP.Principal_Recipient__c = objacc.id;
        insert objIP;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'TestCM';
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;

        
        Module__c objModule = new Module__c();
        objModule.Name = 'Test';
        objModule.Concept_Note__c = objConceptNote.id;
        objModule.Implementation_Period__c = objIP.id;
        objModule.Language__c = 'ENGLISH';
        objModule.Catalog_Module__c = objCM.id;
        //objModule.Parent_module__c = objParentmodule.id;
        insert objModule;
        
        Module__c objModule1 = new Module__c();
        objModule1.Name = 'Test1';
        objModule1.Concept_Note__c = objConceptNote.id;
        objModule1.Implementation_Period__c = objIP.id;
        objModule1.Language__c = 'ENGLISH';
        objModule1.Catalog_Module__c = objCM.id;
        objModule1.CN_Module__c = objModule.id;
        insert objModule1;
        
        objacc.name = objModule1.id;
        update objacc;
        
        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Full_Name_En__c = 'Test';
        objIndicator.Target_Accumulation__c = 'Flow';
        objIndicator.Indicator_Type__c = 'Impact';
        objIndicator.Catalog_Module__c = objCM.id;
        insert objIndicator;
        
        Grant_Indicator__c objGI1 = new Grant_Indicator__c ();
        objGI1.Indicator_Type__c = 'Coverage/Output';
        objGI1.Parent_Module__c = objModule1.id;
        objGI1.Baseline_numerator__c = 1;
        objGI1.IndicativeNumerator1__c = 1;
        objGI1.IndicativeNumerator2__c = 1;
        objGI1.IndicativeNumerator3__c = 1;
        objGI1.IndicativeNumerator4__c = 1;
        objGI1.Above_Indicative_Numerator1__c = 1;
        objGI1.Above_Indicative_Numerator2__c = 1;
        objGI1.Above_Indicative_Numerator3__c = 1;
        objGI1.Above_Indicative_Numerator4__c = 1;
        objGI1.Baseline_Denominator__c = 1;
        objGI1.Indicative_Denominator1__c = 1;
        objGI1.Indicative_Denominator2__c = 1;
        objGI1.Indicative_Denominator3__c = 1;
        objGI1.Indicative_Denominator4__c = 1;
        objGI1.Above_Indicative_Denominator1__c = 1;
        objGI1.Above_Indicative_Denominator2__c = 1;
        objGI1.Above_Indicative_Denominator3__c = 1;
        objGI1.Above_Indicative_Denominator4__c = 1;
        insert objGI1;
        
        Grant_Indicator__c objGI = new Grant_Indicator__c ();
        objGI.Indicator_Type__c = 'Coverage/Output';
        objGI.Parent_Module__c = objModule1.id;
        objGI.Baseline_numerator__c = 1;
        objGI.IndicativeNumerator1__c = 1;
        objGI.IndicativeNumerator2__c = 1;
        objGI.IndicativeNumerator3__c = 1;
        objGI.IndicativeNumerator4__c = 1;
        objGI.Above_Indicative_Numerator1__c = 1;
        objGI.Above_Indicative_Numerator2__c = 1;
        objGI.Above_Indicative_Numerator3__c = 1;
        objGI.Above_Indicative_Numerator4__c = 1;
        objGI.Baseline_Denominator__c = 1;
        objGI.Indicative_Denominator1__c = 1;
        objGI.Indicative_Denominator2__c = 1;
        objGI.Indicative_Denominator3__c = 1;
        objGI.Indicative_Denominator4__c = 1;
        objGI.Above_Indicative_Denominator1__c = 1;
        objGI.Above_Indicative_Denominator2__c = 1;
        objGI.Above_Indicative_Denominator3__c = 1;
        objGI.Above_Indicative_Denominator4__c = 1;
        
        FeedItem objFI = new FeedItem();
        objFI.parentId = objGI1.id;
        objFI.body = 'test';
        objFI.Contentdata = blob.valueof('test');
        objFI.ContentFileName = 'Test';
        insert objFI;
        
        page__c objpage = new page__c();
        objpage.Name = 'Test';
        objpage.Concept_Note__c = objConceptNote.id;
        insert objpage;
        
        Apexpages.currentpage().getparameters().put('id',objModule.id);
        ApexPages.StandardController objSC = new ApexPages.StandardController(objModule);
        CN_CoverageOutputIndicator obCNCOI = new CN_CoverageOutputIndicator(objSC);
        
        CN_CoverageOutputIndicator.GrantIndicatorResult objGrantIndicatorResult = new CN_CoverageOutputIndicator.GrantIndicatorResult ();
        objGrantIndicatorResult.blnIndicatorDisplay  = true;
        objGrantIndicatorResult.blndisplaySave= false;                
        objGrantIndicatorResult.objGrantIndicator = objGI;
        objGrantIndicatorResult.strAssumptions = objGI.comments__c;
        obCNCOI.lstGrantIndicatorResult.add(objGrantIndicatorResult);
        //obCNCOI.ShowHistoryPopup();
        obCNCOI.HidePopupHistory();
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        obCNCOI.EditGrantIndicatorResult();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        obCNCOI.ShowHistoryPopup();
        Apexpages.currentpage().getparameters().put('SaveStdIndicator','1');
        obCNCOI.objStandardGrantIndicatorResult = objGrantIndicatorResult;
        obCNCOI.AddNewStandardGrantIndicatorResult();
        obCNCOI.PageURL = '/apex/CN_DocumentUpload?id=';
        obCNCOI.SaveStandardIndicator();
        
        CN_CoverageOutputIndicator.GrantIndicatorResult objGrantIndicatorResult1 = new CN_CoverageOutputIndicator.GrantIndicatorResult ();
        objGrantIndicatorResult1.blnIndicatorDisplay  = true;
        objGrantIndicatorResult1.blndisplaySave= false;                
        objGrantIndicatorResult1.objGrantIndicator = objGI;
        objGrantIndicatorResult1.strAssumptions = objGI.comments__c;
        //obCNCOI.lstGrantIndicatorResult.add(objGrantIndicatorResult);
        //obCNCOI.lstGrantIndicatorResult.add(objGrantIndicatorResult1);
        obCNCOI.lstGrantIndicatorResult.add(obCNCOI.objStandardGrantIndicatorResult);
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        obCNCOI.CancelGrantIndicatorResult();

        //Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        //obCNCOI.SaveGrantIndicatorResult();
        
        /*Apexpages.currentpage().getparameters().put('DeleteIndiIndex','1');
        obCNCOI.DeleteGrantIndicatorResult();*/
        obCNCOI.strSelectedIndicator = objIndicator.Id;
        obCNCOI.CreateIndicatorOnSelectCatalog();
        
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Baseline_numerator__c = 1;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Baseline_Denominator__c = 2;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator1__c = 3;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator1__c = 4;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator2__c = 5; 
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator2__c = 6;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator3__c = 7;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator3__c = 8;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator4__c = 9;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator4__c = 10;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator1__c = 11;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator1__c = 12;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator2__c = 13; 
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator2__c = 14;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator2__c = 15; 
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator2__c = 16;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator4__c = 17; 
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator4__c = 18;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator2__c = 19;
        obCNCOI.objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator2__c = 20;
        Apexpages.currentpage().getparameters().put('SaveCusIndicator','1');
        obCNCOI.SaveCustomIndicator();
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        obCNCOI.SaveGrantIndicatorResult();
        
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        obCNCOI.DeleteGrantIndicatorResult();
        
    }
    
    Public static testMethod void CheckProfileTest2(){
    	
    	Account objAcc =TestClassHelper.insertAccount();

        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Number_of_Years__c = '4';
        objCN.Status__c = 'Not yet submitted';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
        insert objCN;
        
        
        Module__c objModule = new Module__c();
        objModule.Name='Test_Module';
        insert objModule;
            	
    	Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        
        CN_CoverageOutputIndicator objPg = new CN_CoverageOutputIndicator(sc);
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CN_CoverageOutputIndicator';
        checkProfile.Salesforce_Item__c = 'Add Custom Indicator';
        checkProfile.Status__c = 'Not yet submitted'; 
        insert checkProfile;
        objpg.checkProfile(); 
    }
}