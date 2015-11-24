@isTest
Public Class TestctrlCNOverview{
    Public static testMethod void TestctrlCNOverview(){
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Coverage & Output Indicators';
        insert objGuidance;
        
        Guidance__c objGuidance1 = new Guidance__c();
        objGuidance1.Name = 'Concept Note Overview';
        insert objGuidance1;
                
        Country__c obCountry = new Country__c();
        obCountry.Name = 'Testcountry';
        obCountry.French_Name__c = 'TestFrench';
        obCountry.Russian_Name__c = 'TestRussian';
        obCountry.Spanish_Name__c = 'TestSpanish';
        insert obCountry;
        
        Account objacc = new Account();
        objacc.name = 'testacc';
        objacc.Country__c = obCountry.id;
        insert objacc;
        
        
    	Concept_Note__c objConceptNote = TestClassHelper.createCN();
        //Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.CCM_new__c = objAcc.Id;
        objConceptNote.Name = 'TestName';
        objConceptNote.CurrencyIsoCode = 'EUR';
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.Language__c = 'ENGLISH';
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.Component__c = 'Tuberculosis';
        objConceptNote.Status__c = 'Submitted to the Global Fund';
        objConceptNote.Concept_Note_Submission_Date__c = '15 August 2014';
        objConceptNote.Date_of_TRP_Review__c = system.today();
        objConceptNote.Actual_Submission_Date__c = system.today();
        insert objConceptNote; 
        
        
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test';
        objIP.Principal_Recipient__c = objacc.id;
        objIP.Concept_Note__c = objConceptNote.Id;
        insert objIP;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'TestCM';
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;

        
        Module__c objModule = new Module__c();
        objModule.Name = 'Test';
        objModule.Concept_Note__c = objConceptNote.id;
        objModule.Implementation_Period__c = objIP.id;
        objModule.Language__c = 'fr';
        objModule.Catalog_Module__c = objCM.id;
        objModule.French_Name__c = 'English';
        //objModule.Parent_module__c = objParentmodule.id;
        insert objModule;

        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Full_Name_En__c = 'Test';
        objIndicator.Target_Accumulation__c = 'Flow';
        objIndicator.Indicator_Type__c = 'Impact';
        objIndicator.Catalog_Module__c = objCM.id;
        insert objIndicator;
        
        Grant_Indicator__c objGI = new Grant_Indicator__c ();
        objGI.Indicator_Type__c = 'Coverage/Output';
        objGI.Parent_Module__c = objModule.id;
        insert objGI;
        Test.startTest();
        Intervention__c objIntervention = new Intervention__c();
        objIntervention.Module_rel__c = objModule.id;
        objIntervention.Concept_Note__c = objConceptNote.id;
        insert objIntervention;
        
        Grant_Intervention__c objGrantIntervention = new Grant_Intervention__c();
        objGrantIntervention.CN_Intervention__c = objIntervention.id;
        objGrantIntervention.Implementation_Period__c = objIP.id;
        //objGrantIntervention.Implementation_Period__r.Concept_Note__c =objConceptNote.Id;
        objGrantIntervention.Above_Indicative_Y1__c = 10;
        objGrantIntervention.Above_Indicative_Y2__c = 20;
        objGrantIntervention.Above_Indicative_Y3__c = 30;
        objGrantIntervention.Above_Indicative_Y4__c = 40;
        objGrantIntervention.Indicative_Y1__c = 10;
        objGrantIntervention.Indicative_Y2__c = 20;
        objGrantIntervention.Indicative_Y3__c = 30;
        objGrantIntervention.Indicative_Y4__c = 40;
        insert objGrantIntervention;
        
        Grant_Intervention__c objGrantIntervention1 = new Grant_Intervention__c();
        objGrantIntervention1.CN_Intervention__c = objIntervention.id;
        objGrantIntervention1.Implementation_Period__c = objIP.id;
        objGrantIntervention1.Above_Indicative_Y1__c = 10;
        objGrantIntervention1.Above_Indicative_Y2__c = 20;
        objGrantIntervention1.Above_Indicative_Y3__c = 30;
        objGrantIntervention1.Above_Indicative_Y4__c = 40;
        objGrantIntervention1.Indicative_Y1__c = 10;
        objGrantIntervention1.Indicative_Y2__c = 20;
        objGrantIntervention1.Indicative_Y3__c = 30;
        objGrantIntervention1.Indicative_Y4__c = 40;
        insert objGrantIntervention1;
        
        Grant_Intervention__c objGrantIntervention2 = new Grant_Intervention__c();
        objGrantIntervention2.CN_Intervention__c = objIntervention.id;
        objGrantIntervention2.Implementation_Period__c = objIP.id;
        objGrantIntervention2.Above_Indicative_Y1__c = 10;
        objGrantIntervention2.Above_Indicative_Y2__c = 20;
        objGrantIntervention2.Above_Indicative_Y3__c = 30;
        objGrantIntervention2.Above_Indicative_Y4__c = 40;
        objGrantIntervention2.Indicative_Y1__c = 10;
        objGrantIntervention2.Indicative_Y2__c = 20;
        objGrantIntervention2.Indicative_Y3__c = 30;
        objGrantIntervention2.Indicative_Y4__c = 40;
        insert objGrantIntervention2;
        
        Page__c objPage = new Page__c();
        objPage.Concept_Note__c = objConceptNote.Id;
        objPage.Status__c = 'Draft';
        insert objPage;
        Test.stopTest();
        TRPSubmissionDate__c trp = new TRPSubmissionDate__c();
        trp.Name = 'Record1';
        trp.Registration_until__c = System.Today().addDays(1);
        trp.Submission_date_deadline__c = '15 August 2014';
        trp.TRP_review_date__c = '22-26 September 2014';
        insert trp;
        
        Apexpages.currentpage().getparameters().put('id',objConceptNote.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objConceptNote);   
        ctrlCNOverview objctrlCNOverview = new ctrlCNOverview(sc);
        
        //objctrlCNOverview.SubmitToCN();
        objctrlCNOverview.strCNID = objConceptNote.id;
        objctrlCNOverview.strSelectSubDate = '15 August 2014';
        objctrlCNOverview.selectLikli = '1';
        Apexpages.currentpage().getparameters().put('SavePageIndex','0');
        objctrlCNOverview.SavePage();
        objctrlCNOverview.CancelPage();
        objctrlCNOverview.SubmitToCN();
        objctrlCNOverview.submitCNDate();
        objctrlCNOverview.trpDate();
        objctrlCNOverview.CTSubLike();
        objctrlCNOverview.SubmitToTRP();
        
    }
    
    Public static testMethod void TestctrlCNOverview1(){
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Coverage & Output Indicators';
        insert objGuidance;
        
        Guidance__c objGuidance1 = new Guidance__c();
        objGuidance1.Name = 'Concept Note Overview';
        insert objGuidance1;
        
        
        Country__c obCountry = new Country__c();
        obCountry.Name = 'Testcountry';
        obCountry.French_Name__c = 'TestFrench';
        obCountry.Russian_Name__c = 'TestRussian';
        obCountry.Spanish_Name__c = 'TestSpanish';
        insert obCountry;
        
        Account objacc = new Account();
        objacc.name = 'testacc';
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
        objConceptNote.Status__c = 'Submitted to the Global Fund';
        objConceptNote.Concept_Note_Submission_Date__c = '15 August 2014';
        objConceptNote.Date_of_TRP_Review__c = system.today();
        objConceptNote.Actual_Submission_Date__c = system.today();
        objConceptNote.Revised_Submission_Date__c = '15 August 2014';
        insert objConceptNote; 
        
        Test.startTest();
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test';
        objIP.Principal_Recipient__c = objacc.id;
        objIP.Concept_Note__c = objConceptNote.Id;
        insert objIP;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'TestCM';
        objCM.CurrencyIsoCode = 'EUR';
        insert objCM;

        
        Module__c objModule = new Module__c();
        objModule.Name = 'Test';
        objModule.Concept_Note__c = objConceptNote.id;
        objModule.Implementation_Period__c = objIP.id;
        objModule.Language__c = 'fr';
        objModule.Catalog_Module__c = objCM.id;
        objModule.French_Name__c = 'English';
        //objModule.Parent_module__c = objParentmodule.id;
        insert objModule;

        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Full_Name_En__c = 'Test';
        objIndicator.Target_Accumulation__c = 'Flow';
        objIndicator.Indicator_Type__c = 'Impact';
        objIndicator.Catalog_Module__c = objCM.id;
        insert objIndicator;
        
        Grant_Indicator__c objGI = new Grant_Indicator__c ();
        objGI.Indicator_Type__c = 'Coverage/Output';
        objGI.Parent_Module__c = objModule.id;
        insert objGI;
        
        Intervention__c objIntervention = new Intervention__c();
        objIntervention.Module_rel__c = objModule.id;
        objIntervention.Concept_Note__c = objConceptNote.id;
        insert objIntervention;
        
        Grant_Intervention__c objGrantIntervention = new Grant_Intervention__c();
        objGrantIntervention.CN_Intervention__c = objIntervention.id;
        objGrantIntervention.Implementation_Period__c = objIP.id;
        insert objGrantIntervention;
        
        Page__c objPage = new Page__c();
        objPage.Concept_Note__c = objConceptNote.Id;
        objPage.Status__c = 'Draft';
        insert objPage;
        
        DocumentUpload__c docup = new DocumentUpload__c();
        docup.Type__c = 'Willingness To Pay';
        docup.Concept_Note__c = objConceptNote.id;
        insert docup;
        
        CT_Review__c ctr = new CT_Review__c();
        ctr.Name = 'Record2';
        ctr.Document_Type__c = 'Willingness To Pay';
        insert ctr;
        
        TRPSubmissionDate__c trp = new TRPSubmissionDate__c();
        trp.Name = 'Record1';
        trp.Registration_until__c = System.Today().addDays(1);
        trp.Submission_date_deadline__c = '15 August 2014';
        trp.TRP_review_date__c = '22-26 September 2014';
        insert trp;
        Test.stopTest();
        Apexpages.currentpage().getparameters().put('id',objConceptNote.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objConceptNote);   
        ctrlCNOverview objctrlCNOverview = new ctrlCNOverview(sc);
        
        //objctrlCNOverview.SubmitToCN();
        objctrlCNOverview.strCNID = objConceptNote.id;
        objctrlCNOverview.strSelectSubDate = '15 August 2014';
        objctrlCNOverview.selectLikli = '2';
        Apexpages.currentpage().getparameters().put('SavePageIndex','0');
        objctrlCNOverview.SavePage();
        objctrlCNOverview.CancelPage();
        objctrlCNOverview.SubmitToCN();
        objctrlCNOverview.submitCNDate();
        objctrlCNOverview.trpDate();
        objctrlCNOverview.CTSubLike();
        objctrlCNOverview.SubmitToTRP();
    }
     Public static testMethod void CheckProfileTest2(){
    	
    	Account objAcc =TestClassHelper.insertAccount();

        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Number_of_Years__c = '4';
        objCN.Status__c = 'Not yet submitted';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
        insert objCN;
            	
    	Apexpages.currentpage().getparameters().put('id',objCN.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objCN);
        ctrlCNOverview objPg = new ctrlCNOverview(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CNOverview';
        checkProfile.Salesforce_Item__c = 'Register To TRP';
        checkProfile.Status__c = 'Not yet submitted'; 
        insert checkProfile;
        objpg.checkProfile(); 
    }
}