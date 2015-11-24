@isTest
Public Class GoalsAndImpactIndicatorsTest{
    Public static testMethod void GoalsAndImpactIndicatorsTest(){
        
       /* Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
       // Concept_Note__c objCN = TestClassHelper.insertCN();
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Goal';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Impact';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;*/
        
        Account objAcc =TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        objGoal.Concept_Note__c =objCN.Id;
        insert objGoal;
         
        Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Indicator_Type__c = 'Impact';
        objIndicator.Component__c = 'HIV';
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun =TestClassHelper.insertIndicatorGoalJxn(objGoal, objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        objCatIndicator.Component__c = 'Malaria';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs =TestClassHelper.createProjMultiLanguage();
        insert objPs;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Goals & Impact Indicators';
        insert objGuidance;
        
        Guidance__c objGuidance1 = new Guidance__c();
        objGuidance1.Name = 'Impact Indicator';
        insert objGuidance1;
        system.debug('**objGuidance'+objGuidance);
        
        Guidance__c objGuidance2 = new Guidance__c();
        objGuidance2.Name = 'GM Goals & Impact Indicators';
        insert objGuidance2;
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        
        Implementation_Period__c objimp = TestClassHelper.createIP(objGrant,objAcc);
        objimp.Concept_Note__c = objCN.Id;
        insert objimp;
        
        Page__c objPage1 = TestClassHelper.createPage();
        objPage1.Implementation_Period__c = objimp.Id;
        insert objPage1;
        
        Module__c objModule = TestClassHelper.createModule();
        objModule.Implementation_Period__c = objimp.Id;
        insert objModule;
               
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        system.debug('**sc'+sc);
        GoalsAndImpactIndicators objGI = new GoalsAndImpactIndicators(sc);
              
        system.debug('**strImpGuidanceId '+objGI.strImpGuidanceId);  
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objGI.SaveGoal();
        
        objGI.RefreshIndicators();
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objGI.EditIndicator();
    
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objGI.CancelIndicator();
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objGI.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objGI.SaveIndicator();
        
        objGI.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objGI.setAddGoalCustom = objGoal.id;
        objGI.SaveNewIndicator();
        
        objGI.strSelectedIndicator = objCatIndicator.id;
        objGI.CreateIndicatorOnSelectCatalog();
        objGI.setAddGoalStandard = objGoal.id;
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objGI.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objGI.ShowHistoryPopup();
        objGI.HidePopupHistory();
        
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objGI.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objGI.DeleteGoal();
    }
    Public static testMethod void GoalsAndImpactIndicatorsTest1(){
        
        /*Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'RUSSIAN';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Goal';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Impact';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        objCatIndicator.Component__c = 'Malaria';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs; */
         Account objAcc =TestClassHelper.insertAccount();
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Language__c = 'RUSSIAN';
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        
        insert objPage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        objGoal.Concept_Note__c =objCN.Id;
        insert objGoal;
         
        Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Indicator_Type__c = 'Impact';
        objIndicator.Component__c = 'HIV';
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun =TestClassHelper.insertIndicatorGoalJxn(objGoal, objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        objCatIndicator.Component__c = 'Malaria';
        objCatIndicator.Russian_Name__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs =TestClassHelper.createProjMultiLanguage();
        insert objPs;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Goals & Impact Indicators';
        insert objGuidance;
        
        Guidance__c objGuidance1 = new Guidance__c();
        objGuidance1.Name = 'Impact Indicator';
        insert objGuidance1;
        system.debug('**objGuidance'+objGuidance);
        
        Guidance__c objGuidance2 = new Guidance__c();
        objGuidance2.Name = 'GM Goals & Impact Indicators';
        insert objGuidance2;
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        
        Implementation_Period__c objimp = TestClassHelper.createIP(objGrant,objAcc);
        objimp.Concept_Note__c = objCN.Id;
        insert objimp;
        
        Page__c objPage1 = TestClassHelper.createPage();
        objPage1.Implementation_Period__c = objimp.Id;
        insert objPage1;
        
        Module__c objModule = TestClassHelper.createModule();
        objModule.Implementation_Period__c = objimp.Id;
        insert objModule;
                
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GoalsAndImpactIndicators objGI = new GoalsAndImpactIndicators(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objGI.SaveGoal();
        
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objGI.EditIndicator();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objGI.CancelIndicator();
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objGI.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objGI.SaveIndicator();
        
        objGI.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objGI.setAddGoalCustom = objGoal.id;
        objGI.SaveNewIndicator();
        
        objGI.strSelectedIndicator = objCatIndicator.id;
        objGI.CreateIndicatorOnSelectCatalog();
        objGI.setAddGoalStandard = objGoal.id;
        //Apexpages.currentpage().getparameters().put('SaveIndex','0');
        //objGI.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objGI.ShowHistoryPopup();
        objGI.HidePopupHistory();
        objGI.RefreshIndicators();
        
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objGI.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objGI.DeleteGoal();
    }
    
    Public static testMethod void GoalsAndImpactIndicatorsTest2(){
        
        /*Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'FRENCH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Goal';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Impact';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        objCatIndicator.Component__c = 'Malaria';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;*/
        
        Account objAcc =TestClassHelper.insertAccount();
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Language__c = 'FRENCH';
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        
        insert objPage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        objGoal.Concept_Note__c =objCN.Id;
        insert objGoal;
         
        Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Indicator_Type__c = 'Impact';
        objIndicator.Component__c = 'HIV';
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun =TestClassHelper.insertIndicatorGoalJxn(objGoal, objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        objCatIndicator.Component__c = 'Malaria';
        objCatIndicator.French_Name__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs =TestClassHelper.createProjMultiLanguage();
        insert objPs;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Goals & Impact Indicators';
        insert objGuidance;
        
        Guidance__c objGuidance1 = new Guidance__c();
        objGuidance1.Name = 'Impact Indicator';
        insert objGuidance1;
        system.debug('**objGuidance'+objGuidance);
        
        Guidance__c objGuidance2 = new Guidance__c();
        objGuidance2.Name = 'GM Goals & Impact Indicators';
        insert objGuidance2;
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        
        Implementation_Period__c objimp = TestClassHelper.createIP(objGrant,objAcc);
        objimp.Concept_Note__c = objCN.Id;
        insert objimp;
        
        Page__c objPage1 = TestClassHelper.createPage();
        objPage1.Implementation_Period__c = objimp.Id;
        insert objPage1;
        
        Module__c objModule = TestClassHelper.createModule();
        objModule.Implementation_Period__c = objimp.Id;
        insert objModule;
                
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GoalsAndImpactIndicators objGI = new GoalsAndImpactIndicators(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objGI.SaveGoal();
        
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objGI.EditIndicator();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objGI.CancelIndicator();
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objGI.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objGI.SaveIndicator();
        
        objGI.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objGI.setAddGoalCustom = objGoal.id;
        objGI.SaveNewIndicator();
        
        objGI.strSelectedIndicator = objCatIndicator.id;
        objGI.CreateIndicatorOnSelectCatalog();
        objGI.setAddGoalStandard = objGoal.id;
        //Apexpages.currentpage().getparameters().put('SaveIndex','0');
        //objGI.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objGI.ShowHistoryPopup();
        objGI.HidePopupHistory();
        objGI.RefreshIndicators();
        
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objGI.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objGI.DeleteGoal();
    }
    
    Public static testMethod void GoalsAndImpactIndicatorsTest3(){
        
        /*Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'SPANISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Goal';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Impact';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        objCatIndicator.Component__c = 'Malaria';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;*/
        Account objAcc =TestClassHelper.insertAccount();
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Language__c = 'SPANISH';
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        objGoal.Concept_Note__c =objCN.Id;
        insert objGoal;
         
        Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Indicator_Type__c = 'Impact';
        objIndicator.Component__c = 'HIV';
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun =TestClassHelper.insertIndicatorGoalJxn(objGoal, objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        objCatIndicator.Component__c = 'Malaria';
        objCatIndicator.Spanish_Name__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs =TestClassHelper.createProjMultiLanguage();
        insert objPs;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Goals & Impact Indicators';
        insert objGuidance;
        
        Guidance__c objGuidance1 = new Guidance__c();
        objGuidance1.Name = 'Impact Indicator';
        insert objGuidance1;
        system.debug('**objGuidance'+objGuidance);
        
        Guidance__c objGuidance2 = new Guidance__c();
        objGuidance2.Name = 'GM Goals & Impact Indicators';
        insert objGuidance2;
        
        Grant__c objGrant = TestClassHelper.createGrant(objAcc);
        
        Implementation_Period__c objimp = TestClassHelper.createIP(objGrant,objAcc);
        objimp.Concept_Note__c = objCN.Id;
        insert objimp;
        
        Page__c objPage1 = TestClassHelper.createPage();
        objPage1.Implementation_Period__c = objimp.Id;
        insert objPage1;
        
        Module__c objModule = TestClassHelper.createModule();
        objModule.Implementation_Period__c = objimp.Id;
        insert objModule;
                
        Apexpages.currentpage().getparameters().put('id',objPage1.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage1);
        GoalsAndImpactIndicators objGI = new GoalsAndImpactIndicators(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objGI.SaveGoal();
        
        
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objGI.EditIndicator();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objGI.CancelIndicator();
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objGI.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objGI.SaveIndicator();
        
        objGI.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objGI.setAddGoalCustom = objGoal.id;
        objGI.SaveNewIndicator();
        
        objGI.strSelectedIndicator = objCatIndicator.id;
        objGI.CreateIndicatorOnSelectCatalog();
        objGI.setAddGoalStandard = objGoal.id;
        //Apexpages.currentpage().getparameters().put('SaveIndex','0');
        //objGI.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objGI.ShowHistoryPopup();
        objGI.HidePopupHistory();
        objGI.RefreshIndicators();
        
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objGI.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objGI.DeleteGoal();
       
    }
    
    Public static testMethod void GoalsAndImpactIndicatorsTest4(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
    	
    	Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GoalsAndImpactIndicators objGI = new GoalsAndImpactIndicators(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='GoalsAndImpactIndicator';
        checkProfile.Salesforce_Item__c = 'Add Custom Indicator';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        objGI.checkProfile(); 
    }
    
   /* Public static testMethod void GoalsAndImpactIndicatorsTest4(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test IP';
        objIP.Principal_Recipient__c = objAcc.Id;
        insert objIP;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'SPANISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Goal';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Impact';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        objCatIndicator.Component__c = 'Malaria';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;
                
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GoalsAndImpactIndicators objGI = new GoalsAndImpactIndicators(sc);
    }*/
    
}