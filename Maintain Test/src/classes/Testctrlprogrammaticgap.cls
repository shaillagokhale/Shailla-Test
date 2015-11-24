@isTest
Public Class Testctrlprogrammaticgap{
    Public Static testMethod void Testctrlprogrammaticgap(){
    
        User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
        
        Country__c objCountry = new Country__c();
        objCountry.Name = 'test';
        objCountry.FPM__c = objUser.id;
        insert objCountry;
        
        
            
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        objAcc.Country__c = objCountry.id;
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        /*Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Implementation_Period_Page_Template__c = objTemplate.Id;
        objCN.Number_of_Years__c = '4';
        objCN.Start_Date__c= system.today();
        insert objCN;*/
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Number_of_Years__c = '4';
        objCN.Implementation_Period_Page_Template__c = objTemplate.Id;
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
        insert objCN;
        
        Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c =  'Malaria';
        objGrant.Name = 'Test';
        objGrant.Principal_Recipient__c = objAcc.Id;
        insert objGrant;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Grant__c = objGrant.Id;
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;
        
        Module__c objModule = new Module__c();
        objmodule.Concept_Note__c = objCN.id;
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        objModule.PG_Cycle__c='FEB - December';
        objModule.Language__c = 'ENGLISH';
        
        insert objModule;
        
        Indicator__c objInd = new Indicator__c();
        objInd.Catalog_Module__c = objCM.id;
        objInd.Indicator_Type__c = 'Coverage/Output';
        objInd.Full_Name_En__c = 'test';
        objInd.Type_of_Data__c = 'Number';
        objInd.Available_for_PG__c = true;
        objInd.Full_Name_En__c = 'test'; 
        insert objInd;
        
        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Catalog_Module__c = objCM.id;
        objIndicator.Available_for_PG__c = true;
        objIndicator.Programme_Area__c = 'Malaria';
        objIndicator.Indicator_Type__c = 'Coverage/Output';
        objIndicator.Catalog_Module__c = objCM.Id;
        objIndicator.Full_Name_En__c = 'test';
        objIndicator.Component__c = objCN.Component__c;
        insert objIndicator;
        
        
        //---
        //Programmatic_Gap__c objPGap = new Programmatic_Gap__c();
        //objPGap.Concept_Note__c = objCN.id;
        //objPGap.Indicator__c = objInd.id;
        //insert objPGap ;
        
        Grant_Indicator__c objGrantIndicator = new Grant_Indicator__c();
        objGrantIndicator.Concept_Note__c = objCN.id;
        insert objGrantIndicator;
        
        Catalog_Module__c objCatalogModule = new Catalog_Module__c();
        objCatalogModule.Name = 'test';
        objCatalogModule.CurrencyIsoCode = 'EUR';
        insert objCatalogModule;
        
        Programmatic_Gap__c objProgrammaticGap = new Programmatic_Gap__c();
        objProgrammaticGap.Concept_Note__c = objCN.id;
        objProgrammaticGap.Catalog_Indicator__c = objIndicator.id;
        objProgrammaticGap.Indicator__c = objGrantIndicator.id; 
        objProgrammaticGap.Group_Sequence__c = 1;
        objProgrammaticGap.Sequence__c = 1;
        objProgrammaticGap.Baseline_Source__c = 'Operational Research';
        objProgrammaticGap.Baseline_year__c = '2002';
        objProgrammaticGap.Baseline_value__c = 1;
        objProgrammaticGap.Rationale_for_Chosen_Indicator__c = 'test';
        objProgrammaticGap.Metric__c = 'test';
        objProgrammaticGap.Coverage_Comments__c = 'test';
        insert objProgrammaticGap;
        
        // Created for Indicator_for_PG_Calculation_E__c=True
        
        
        Guidance__c objGuidance = new Guidance__c ();
        objGuidance.name = 'Programmatic Gap '+objCN.Component__c ;
        insert objGuidance;
        
        Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        ctrlprogrammaticgap objCls = new ctrlprogrammaticgap(sc);

        objCls.intLastMonth = objModule.Concept_Note__c;
       
        //GILanguage.putMultiLingualText(objCls.strLanguage,'GrantCoverageOutputIndicator');
        objCls.FillModules(objIndicator.id);
        objCls.strSelectedIndicator = objIndicator.id;
        objCls.CreateIndicatorOnSelectCatalog();
        objCls.SaveStandardIndicator();
        objCls.saveCycle();
        apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        apexpages.currentpage().getparameters().put('HistoryPrograGap','0');
        objCls.ShowHistoryPopup();
        
        objCls.HidePopupHistory();
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCls.EditProg_Gap();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCls.CancelGrantIndicatorResult();
        
        //Apexpages.currentpage().getparameters().put('SaveIndiIndex','');
        objCls.SaveIndiIndex = 0;
        objCls.SaveGrantIndicatorResult();
        
        objCls.quickSavePG();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCls.DeletePG();
        
        //objCls.savePG();
        objCls.cancelPG();
        objCls.BackCNOverview();
        objCls.Edit_Cycle();
    }
    Public Static testMethod void TestctrlprogrammaticgapLLIN(){
    
    
    //Created for inserting user Record with Different Language 5th Aug 2014
        /*User objUser_Ins = new User();
        objUser_Ins.LanguageLocaleKey='fr';
        objUser_Ins.Alias='TestU';
        objUser_Ins.Email='Test.Test@tcs.com';
        objUser_Ins.FirstName='Test';
        objUser_Ins.LastName='Test';
        objUser_Ins.Username='john@test.com';
        objUser_Ins.TimeZoneSidKey='GMT';
        objUser_Ins.LocaleSidKey='en_US';
        objUser_Ins.EmailEncodingKey = 'ISO-8859-1';
        objUser_Ins.ProfileId='00eb0000000mXxx';
        insert objUser_Ins;*/
        
        
         User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
        
        Country__c objCountry = new Country__c();
        objCountry.Name = 'test';
        objCountry.FPM__c = objUser.id;
        insert objCountry;
            
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        objAcc.Country__c = objCountry.id;
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        /*Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Implementation_Period_Page_Template__c = objTemplate.Id;
        objCN.Number_of_Years__c = '4';
        objCN.Start_Date__c= system.today();
        insert objCN;*/
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Implementation_Period_Page_Template__c = objTemplate.Id;
        objCN.Number_of_Years__c = '4';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
        insert objCN;
        
        Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c =  'Malaria';
        objGrant.Name = 'Test';
        objGrant.Principal_Recipient__c = objAcc.Id;
        insert objGrant;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Grant__c = objGrant.Id;
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;
        system.debug('****objcm**'+objCM.id);
        
        Module__c objModule = new Module__c();
        objmodule.Concept_Note__c = objCN.id;
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        objModule.PG_Cycle__c='FEB - December';
        objModule.Language__c = 'ENGLISH';
        
        insert objModule;
        
             
        Indicator__c objIndicatorLLIN = new Indicator__c();
        objIndicatorLLIN.Catalog_Module__c = objCM.id;
        objIndicatorLLIN.Available_for_PG__c = true;
        objIndicatorLLIN.Programme_Area__c = 'Malaria';
        objIndicatorLLIN.Indicator_Type__c = 'Coverage/Output';
        objIndicatorLLIN.Catalog_Module__c = objCM.Id;
        objIndicatorLLIN.Full_Name_En__c = 'test';
        objIndicatorLLIN.Component__c = objCN.Component__c;
        objIndicatorLLIN.LLIN__c = true;
        insert objIndicatorLLIN;
        system.debug('**objIndicatorLLIN**'+objIndicatorLLIN.id);
        List<Indicator__c>lstAllLLINforModule = new List<Indicator__c>();
        lstAllLLINforModule.add(objIndicatorLLIN);

        //Condition for IRS__c=True added on 5 Aug 2014 
        
        Indicator__c objIndicatorLLIN_IRS = new Indicator__c();
        objIndicatorLLIN_IRS.Catalog_Module__c = objCM.id;
        objIndicatorLLIN_IRS.Available_for_PG__c = true;
        objIndicatorLLIN_IRS.Programme_Area__c = 'Malaria';
        objIndicatorLLIN_IRS.Indicator_Type__c = 'Coverage/Output';
        objIndicatorLLIN_IRS.Catalog_Module__c = objCM.Id;
        objIndicatorLLIN_IRS.Full_Name_En__c = 'test_1';
        objIndicatorLLIN_IRS.Component__c = objCN.Component__c;
        objIndicatorLLIN_IRS.IRS__c = true;
        insert objIndicatorLLIN_IRS;
        system.debug('**objIndicatorLLIN***'+objIndicatorLLIN_IRS.id);
        List<Indicator__c>lstAllLLINforModule_IRS = new List<Indicator__c>();
        lstAllLLINforModule.add(objIndicatorLLIN_IRS);
        
        //Condition for IRS__c=False added on 5 Aug 2014
        Indicator__c objIndicatorLLIN_IRS_False = new Indicator__c();
        objIndicatorLLIN_IRS_False.Catalog_Module__c = objCM.id;
        objIndicatorLLIN_IRS_False.Available_for_PG__c = true;
        objIndicatorLLIN_IRS_False.Programme_Area__c = 'Malaria';
        objIndicatorLLIN_IRS_False.Indicator_Type__c = 'Coverage/Output';
        objIndicatorLLIN_IRS_False.Catalog_Module__c = objCM.Id;
        objIndicatorLLIN_IRS_False.Full_Name_En__c = 'test_1';
        objIndicatorLLIN_IRS_False.Component__c = objCN.Component__c;
        objIndicatorLLIN_IRS_False.IRS__c = False;
        insert objIndicatorLLIN_IRS_False;
        system.debug('**objIndicatorLLIN***'+objIndicatorLLIN_IRS.id);
        List<Indicator__c>lstAllLLINforModule_IRS_False = new List<Indicator__c>();
        lstAllLLINforModule.add(objIndicatorLLIN_IRS_False);
        
        /*Indicator__c objIndicatorLLIN1 = new Indicator__c();
        objIndicatorLLIN1.Catalog_Module__c = objCM.id;
        objIndicatorLLIN1.Available_for_PG__c = true;
        objIndicatorLLIN1.Programme_Area__c = 'Malaria';
        objIndicatorLLIN1.Indicator_Type__c = 'Coverage/Output';
        objIndicatorLLIN1.Catalog_Module__c = objCM.Id;
        objIndicatorLLIN1.Full_Name_En__c = 'test';
        objIndicatorLLIN1.Component__c = objCN.Component__c;
        objIndicatorLLIN1.LLIN__c = true;
        insert objIndicatorLLIN1;
        system.debug('**objIndicatorLLIN**'+objIndicatorLLIN1.id);
        lstAllLLINforModule.add(objIndicatorLLIN1);
        system.debug('**lstAllLLINforModule**'+lstAllLLINforModule);*/
       
        
        Grant_Indicator__c objGrantIndicator = new Grant_Indicator__c();
        objGrantIndicator.Concept_Note__c = objCN.id;
        insert objGrantIndicator;
        
        Catalog_Module__c objCatalogModule = new Catalog_Module__c();
        objCatalogModule.Name = 'test';
        objCatalogModule.CurrencyIsoCode = 'EUR';
        insert objCatalogModule;
        
        Programmatic_Gap__c objProgrammaticGapLLIN = new Programmatic_Gap__c();
        objProgrammaticGapLLIN.Concept_Note__c = objCN.id;
        objProgrammaticGapLLIN.Catalog_Indicator__c = objIndicatorLLIN.id;
        objProgrammaticGapLLIN.Indicator__c = objGrantIndicator.id; 
        objProgrammaticGapLLIN.Group_Sequence__c = 1;
        objProgrammaticGapLLIN.Sequence__c = 1;
        objProgrammaticGapLLIN.Baseline_Source__c = 'Operational Research';
        objProgrammaticGapLLIN.Baseline_year__c = '2002';
        objProgrammaticGapLLIN.Baseline_value__c = 1;
        objProgrammaticGapLLIN.Rationale_for_Chosen_Indicator__c = 'test';
        objProgrammaticGapLLIN.Metric__c = 'test';
        objProgrammaticGapLLIN.Coverage_Comments__c = 'test';
        insert objProgrammaticGapLLIN;
        
        Guidance__c objGuidance = new Guidance__c ();
        objGuidance.name = 'Programmatic Gap '+objCN.Component__c ;
        insert objGuidance;
        
        Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        ctrlprogrammaticgap objCls = new ctrlprogrammaticgap(sc);

        objCls.intLastMonth = objModule.Concept_Note__c;
                //GILanguage.putMultiLingualText(objCls.strLanguage,'GrantCoverageOutputIndicator');
        String strCatalogModule = objCM.id;
        objCls.strCatalogModule = objCM.id;
        objCls.strSelectedIndicator = objIndicatorLLIN.id;
        objCls.fetchLLINformodule();
        objCls.FillModules(objIndicatorLLIN.id);
        objCls.FillModules(objIndicatorLLIN_IRS.id); //Condition for IRS__c=True added on 5 July 2014
        objCls.FillModules(objIndicatorLLIN_IRS_False.id); //Condition for IRS__c=False added on 5 July 2014  
        objCls.strSelectedIndicator = objIndicatorLLIN.id;
        objCls.CreateIndicatorOnSelectCatalog();
        objCls.SaveStandardIndicator();
        objCls.saveCycle();
        apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        apexpages.currentpage().getparameters().put('HistoryPrograGap','0');
        objCls.ShowHistoryPopup();
        
        objCls.HidePopupHistory();
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCls.EditProg_Gap();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCls.CancelGrantIndicatorResult();
        
        //Apexpages.currentpage().getparameters().put('SaveIndiIndex','');
        objCls.SaveIndiIndex = 0;
        objCls.SaveGrantIndicatorResult();
        
        objCls.quickSavePG();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCls.DeletePG();
        
        //objCls.savePG();
        objCls.cancelPG();
        objCls.BackCNOverview();
        objCls.Edit_Cycle();
        

    }
    Public Static testMethod void Testctrlprogrammaticgap1(){
     
    
        User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
		// 
		User objUser_Ins = new User();
        objUser_Ins.LanguageLocaleKey='fr';
        objUser_Ins.Alias='TestU';
        objUser_Ins.Email='Test.Test@tcs.com';
        objUser_Ins.FirstName='Test';
        objUser_Ins.LastName='Test';
        objUser_Ins.Username='j51J@test.com';
        objUser_Ins.TimeZoneSidKey='GMT';
        objUser_Ins.LocaleSidKey='en_US';
        objUser_Ins.EmailEncodingKey = 'ISO-8859-1';
        objUser_Ins.ProfileId='00eb0000000mXxx';
        insert objUser_Ins;

		Country__c objCountry1 = new Country__c();
        objCountry1.Name = 'test';
        objCountry1.FPM__c = objUser_Ins.id;
        insert objCountry1;
		//
        Country__c objCountry = new Country__c();
        objCountry.Name = 'test';
        objCountry.FPM__c = objUser.id;
        insert objCountry;
            
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        objAcc.Country__c = objCountry.id;
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        /*Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Implementation_Period_Page_Template__c = objTemplate.Id;
        objCN.Number_of_Years__c = '4';
        objCN.Start_Date__c= system.today();
        insert objCN;*/
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Implementation_Period_Page_Template__c = objTemplate.Id;
        objCN.Number_of_Years__c = '4';
        objCN.Start_Date__c= system.today();
        insert objCN;
        
        Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c =  'Malaria';
        objGrant.Name = 'Test';
        objGrant.Principal_Recipient__c = objAcc.Id;
        insert objGrant;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Grant__c = objGrant.Id;
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;
        
        Module__c objModule = new Module__c();
        objmodule.Concept_Note__c = objCN.id;
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.id;
        objModule.PG_Cycle__c='FEB - December';
        objModule.Language__c = 'ENGLISH';
        insert objModule;
        
        Indicator__c objInd = new Indicator__c();
        objInd.Catalog_Module__c = objCM.id;
        objInd.Indicator_Type__c = 'Coverage/Output';
        objInd.Full_Name_En__c = 'test';
        objInd.Type_of_Data__c = 'Number';
        objInd.Available_for_PG__c = true;
        objInd.Full_Name_En__c = 'test';
        insert objInd;
        
        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Catalog_Module__c = objCM.id;
        objIndicator.Available_for_PG__c = true;
        objIndicator.Programme_Area__c = 'Malaria';
        objIndicator.Indicator_Type__c = 'Coverage/Output';
        objIndicator.Catalog_Module__c = objCM.Id;
        objIndicator.Full_Name_En__c = 'test';
        objIndicator.Component__c = objCN.Component__c;
        objIndicator.Indicator_for_PG_Calculation_E__c = true;
        insert objIndicator;
        
        
        //---
        //Programmatic_Gap__c objPGap = new Programmatic_Gap__c();
        //objPGap.Concept_Note__c = objCN.id;
        //objPGap.Indicator__c = objInd.id;
        //insert objPGap ;
        
        Grant_Indicator__c objGrantIndicator = new Grant_Indicator__c();
        objGrantIndicator.Concept_Note__c = objCN.id;
        insert objGrantIndicator;
        
        Catalog_Module__c objCatalogModule = new Catalog_Module__c();
        objCatalogModule.Name = 'test';
        objCatalogModule.CurrencyIsoCode = 'EUR';
        insert objCatalogModule;
        
        Programmatic_Gap__c objProgrammaticGap = new Programmatic_Gap__c();
        objProgrammaticGap.Concept_Note__c = objCN.id;
        objProgrammaticGap.Catalog_Indicator__c = objIndicator.id;
        objProgrammaticGap.Indicator__c = objGrantIndicator.id; 
        objProgrammaticGap.Group_Sequence__c = 1;
        objProgrammaticGap.Sequence__c = 1;
        objProgrammaticGap.Baseline_Source__c = 'Operational Research';
        objProgrammaticGap.Baseline_year__c = '2002';
        objProgrammaticGap.Baseline_value__c = 1;
        objProgrammaticGap.Rationale_for_Chosen_Indicator__c = 'test';
        objProgrammaticGap.Metric__c = 'test';
        objProgrammaticGap.Coverage_Comments__c = 'test';
        insert objProgrammaticGap;
        
        // Created for Indicator_for_PG_Calculation_E__c=True
        
        
        Guidance__c objGuidance = new Guidance__c ();
        objGuidance.name = 'Programmatic Gap '+objCN.Component__c ;
        insert objGuidance;
        
        Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objModule);
        ctrlprogrammaticgap objCls = new ctrlprogrammaticgap(sc);

        objCls.intLastMonth = objModule.Concept_Note__c;
       
        //GILanguage.putMultiLingualText(objCls.strLanguage,'GrantCoverageOutputIndicator');
        objCls.FillModules(objIndicator.id);
        objCls.strSelectedIndicator = objIndicator.id;
        objCls.CreateIndicatorOnSelectCatalog();
        objCls.SaveStandardIndicator();
        objCls.saveCycle();
        apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        apexpages.currentpage().getparameters().put('HistoryPrograGap','0');
        objCls.ShowHistoryPopup();
        
        objCls.HidePopupHistory();
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCls.EditProg_Gap();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCls.CancelGrantIndicatorResult();
        
        //Apexpages.currentpage().getparameters().put('SaveIndiIndex','');
        objCls.SaveIndiIndex = 0;
        objCls.SaveGrantIndicatorResult();
        
        objCls.quickSavePG();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCls.DeletePG();
        
        //objCls.savePG();
        objCls.cancelPG();
        objCls.BackCNOverview();
        objCls.Edit_Cycle();
    } 
    Public static testMethod void CheckProfileTest4(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test_IP';
        objIP.Principal_Recipient__c = objAcc.Id;
        insert objIP;


        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test_CM';
        insert objCM;

        Module__c objModule = new Module__c();
        objModule.Name='Test_Module';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.Id;
        insert objModule; 
    	
    	Apexpages.currentpage().getparameters().put('id',objModule.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlprogrammaticgap objPg = new ctrlprogrammaticgap(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='new_programmaticgap';
        checkProfile.Salesforce_Item__c = 'Add Programmatic Table';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        objpg.checkProfile(); 
    }
    
}