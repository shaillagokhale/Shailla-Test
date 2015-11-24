@isTest
Public Class ctrlObjectivesOutcomeTest{
    Public static testMethod void ctrlObjectivesOutcomeTest(){
        /*Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;*/
       
        /*Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;*/
        
        /* Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
       Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.id;        
        objIP.Length_Years__c = '4';
        insert objIP;*/
             
        
        
        /*Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
       // Grant_Indicator__feed objIndicatorfeed = new Grant_Indicator__feed();
       // objIndicatorfeed.ParentID = ID;
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Outcome';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;
        
        /*ctrlObjectivesOutcome.wrapGoalsObjectives objWrapper =new ctrlObjectivesOutcome.wrapGoalsObjectives();
        List<ctrlObjectivesOutcome.wrapGoalsObjectives> lstGoalsObjectives ;
        objWrapper.GoalId = objGoal.Id;
        objWrapper.GoalDescription = objGoal.Goal__c;
        objWrapper.IndexGoal = 1;
        objWrapper.blnDisplay = true; 
        lstGoalsObjectives.add(objWrapper);
        insert lstGoalsObjectives;*/
        
        Account objAcc = TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Language__c = 'ENGLISH';
        insert objCN;
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        //objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Concept_note__c = objCN.Id;
        insert Objpage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        
        insert objGoal;
        
        
       Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = TestClassHelper.insertIndicatorGoalJxn(objGoal,objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = TestClassHelper.createProjMultiLanguage();
        insert objPs;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Objective Indicator';
        insert objGuidance;
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlObjectivesOutcome objCO = new ctrlObjectivesOutcome(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCO.SaveGoal();
        objCO.AddNewGoal();
        objCO.getPageText();
        objCO.fillMapGoal();
        objCO.SetCatalogIndicator();
        objCO.FillAllIndicatorMap();
        //objCO.SaveNewSTdCustomIndicator(objIndicator,0);
        //Apexpages.currentpage().getparameters().put('EditIndex','1');
        //objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCO.SaveGoal();
        
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCO.CancelGoal();
         
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCO.EditIndicator();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCO.CancelIndicator();
        
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objCO.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objCO.SaveIndicator();
        
        objCO.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objCO.setAddGoalCustom = objGoal.id;
        objCO.SaveNewIndicator();
        
        objCO.strSelectedIndicator = objCatIndicator.id;
        objCO.CreateIndicatorOnSelectCatalog();
        objCO.setAddGoalStandard = objGoal.id;
        //Apexpages.currentpage().getparameters().put('SaveIndex','0');
        //objCO.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objCO.ShowHistoryPopup();
        objCO.HidePopupHistory();
       
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objCO.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCO.DeleteGoal();
    }
    Public static testMethod void CheckProfileTest2(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
    	
    	Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;

        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Number_of_Years__c = '4';
        objCN.Status__c = 'Not yet submitted';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
        insert objCN;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        //objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        ObjPage.Implementation_Period__c   =objIP.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();  
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        insert objGoal;
    	
    	Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlObjectivesOutcome objPg = new ctrlObjectivesOutcome(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CN_Objectives';
        checkProfile.Salesforce_Item__c = 'Edit';
        checkProfile.Status__c = 'Not yet submitted'; 
        insert checkProfile;
        objpg.checkProfile(); 
    }
    
   /* Public static testMethod void ctrlObjectivesOutcomeTest1(){
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
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.id;        
        objIP.Length_Years__c = '4';
        insert objIP;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
       // Grant_Indicator__feed objIndicatorfeed = new Grant_Indicator__feed();
       // objIndicatorfeed.ParentID = ID;
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Outcome';
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
        
        /*ctrlObjectivesOutcome.wrapGoalsObjectives objWrapper =new ctrlObjectivesOutcome.wrapGoalsObjectives();
        List<ctrlObjectivesOutcome.wrapGoalsObjectives> lstGoalsObjectives ;
        objWrapper.GoalId = objGoal.Id;
        objWrapper.GoalDescription = objGoal.Goal__c;
        objWrapper.IndexGoal = 1;
        objWrapper.blnDisplay = true; 
        lstGoalsObjectives.add(objWrapper);
        insert lstGoalsObjectives;*/
        
      /*   Account objAcc = TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Language__c = 'RUSSIAN';
        insert objCN;
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        //objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Concept_note__c = objCN.Id;   
        insert Objpage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        
        insert objGoal;
        
        
       Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = TestClassHelper.insertIndicatorGoalJxn(objGoal,objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = TestClassHelper.createProjMultiLanguage();
        insert objPs;
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlObjectivesOutcome objCO = new ctrlObjectivesOutcome(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objCO.SaveGoal();
        objCO.AddNewGoal();
        objCO.getPageText();
        objCO.fillMapGoal();
        objCO.SetCatalogIndicator();
        objCO.FillAllIndicatorMap();
        //objCO.SaveNewSTdCustomIndicator(objIndicator,0);
        //Apexpages.currentpage().getparameters().put('EditIndex','1');
        //objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCO.SaveGoal();
        
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCO.CancelGoal();
         
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCO.EditIndicator();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCO.CancelIndicator();
        
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objCO.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objCO.SaveIndicator();
        
        objCO.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objCO.setAddGoalCustom = objGoal.id;
        objCO.SaveNewIndicator();
        
        objCO.strSelectedIndicator = objCatIndicator.id;
        objCO.CreateIndicatorOnSelectCatalog();
        objCO.setAddGoalStandard = objGoal.id;
        //Apexpages.currentpage().getparameters().put('SaveIndex','0');
        //objCO.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objCO.ShowHistoryPopup();
        objCO.HidePopupHistory();
       
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objCO.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCO.DeleteGoal();
    }
    
    Public static testMethod void ctrlObjectivesOutcomeTest2(){
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
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.id;        
        objIP.Length_Years__c = '4';
        insert objIP;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
       // Grant_Indicator__feed objIndicatorfeed = new Grant_Indicator__feed();
       // objIndicatorfeed.ParentID = ID;
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Outcome';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;
        
        ctrlObjectivesOutcome.wrapGoalsObjectives objWrapper =new ctrlObjectivesOutcome.wrapGoalsObjectives();
        List<ctrlObjectivesOutcome.wrapGoalsObjectives> lstGoalsObjectives ;
        objWrapper.GoalId = objGoal.Id;
        objWrapper.GoalDescription = objGoal.Goal__c;
        objWrapper.IndexGoal = 1;
        objWrapper.blnDisplay = true; 
        lstGoalsObjectives.add(objWrapper);
        insert lstGoalsObjectives;*/
      /*   Account objAcc = TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Language__c = 'FRENCH';
        insert objCN;
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        //objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Concept_note__c = objCN.Id;   
        insert Objpage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        
        insert objGoal;
        
        
       Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = TestClassHelper.insertIndicatorGoalJxn(objGoal,objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = TestClassHelper.createProjMultiLanguage();
        insert objPs;
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlObjectivesOutcome objCO = new ctrlObjectivesOutcome(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objCO.SaveGoal();
        objCO.AddNewGoal();
        objCO.getPageText();
        objCO.fillMapGoal();
        objCO.SetCatalogIndicator();
        objCO.FillAllIndicatorMap();
        //objCO.SaveNewSTdCustomIndicator(objIndicator,0);
        //Apexpages.currentpage().getparameters().put('EditIndex','1');
        //objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCO.SaveGoal();
        
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCO.CancelGoal();
         
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCO.EditIndicator();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCO.CancelIndicator();
        
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objCO.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objCO.SaveIndicator();
        
        objCO.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objCO.setAddGoalCustom = objGoal.id;
        objCO.SaveNewIndicator();
        
        objCO.strSelectedIndicator = objCatIndicator.id;
        objCO.CreateIndicatorOnSelectCatalog();
        objCO.setAddGoalStandard = objGoal.id;
        //Apexpages.currentpage().getparameters().put('SaveIndex','0');
        //objCO.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objCO.ShowHistoryPopup();
        objCO.HidePopupHistory();
       
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objCO.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCO.DeleteGoal();
    }
    
    Public static testMethod void ctrlObjectivesOutcomeTest3(){
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
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.id;        
        objIP.Length_Years__c = '4';
        insert objIP;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
       // Grant_Indicator__feed objIndicatorfeed = new Grant_Indicator__feed();
       // objIndicatorfeed.ParentID = ID;
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Outcome';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;
        
        /*ctrlObjectivesOutcome.wrapGoalsObjectives objWrapper =new ctrlObjectivesOutcome.wrapGoalsObjectives();
        List<ctrlObjectivesOutcome.wrapGoalsObjectives> lstGoalsObjectives ;
        objWrapper.GoalId = objGoal.Id;
        objWrapper.GoalDescription = objGoal.Goal__c;
        objWrapper.IndexGoal = 1;
        objWrapper.blnDisplay = true; 
        lstGoalsObjectives.add(objWrapper);
        insert lstGoalsObjectives;*/
      /*  Account objAcc = TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        objCN.Language__c = 'SPANISH';
        insert objCN;
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
        insert objGrant;
        
        Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc);
        //objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Page__c ObjPage = TestClassHelper.createPage();
        ObjPage.Concept_note__c = objCN.Id;   
        insert Objpage;
        
        Goals_Objectives__c objGoal = TestClassHelper.createGoalsObjectives();
        
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        
        insert objGoal;
        
        
       Grant_Indicator__c objIndicator = TestClassHelper.createGrantIndicator();
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
        Ind_Goal_Jxn__c objJun = TestClassHelper.insertIndicatorGoalJxn(objGoal,objIndicator);
        
        Indicator__c objCatIndicator = TestClassHelper.createCatalogIndicator();
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = TestClassHelper.createProjMultiLanguage();
        insert objPs;
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlObjectivesOutcome objCO = new ctrlObjectivesOutcome(sc);
        
        Apexpages.currentpage().getparameters().put('SaveIndex','2');
        objCO.SaveGoal();
        objCO.AddNewGoal();
        objCO.getPageText();
        objCO.fillMapGoal();
        objCO.SetCatalogIndicator();
        objCO.FillAllIndicatorMap();
        //objCO.SaveNewSTdCustomIndicator(objIndicator,0);
        //Apexpages.currentpage().getparameters().put('EditIndex','1');
        //objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('SaveIndex','0');
        objCO.SaveGoal();
        
        Apexpages.currentpage().getparameters().put('EditIndex','0');
        objCO.EditGoal();
        
        Apexpages.currentpage().getparameters().put('CancelIndex','0');
        objCO.CancelGoal();
         
        Apexpages.currentpage().getparameters().put('EditIndiIndex','0');
        objCO.EditIndicator();
        
        Apexpages.currentpage().getparameters().put('CancelIndiIndex','0');
        objCO.CancelIndicator();
        
        
        Apexpages.currentpage().getparameters().put('SaveIndiIndex','0');
        objCO.lstIndicators[0].setGoalIdAdd = objGoal.id;
        objCO.SaveIndicator();
        
        objCO.objNewIndicator = new Grant_indicator__c(Indicator_Full_Name__c = 'Test',Data_Type__c='Percent');
        objCO.setAddGoalCustom = objGoal.id;
        objCO.SaveNewIndicator();
        
        objCO.strSelectedIndicator = objCatIndicator.id;
        objCO.CreateIndicatorOnSelectCatalog();
        objCO.setAddGoalStandard = objGoal.id;
        //Apexpages.currentpage().getparameters().put('SaveIndex','0');
        //objCO.SaveStdIndicator();
        Apexpages.currentpage().getparameters().put('HistoryIndiIndex','0');
        objCO.ShowHistoryPopup();
        objCO.HidePopupHistory();
       
        Apexpages.currentpage().getparameters().put('DeleteIndiIndex','0');
        objCO.DeleteIndicator();
        
        Apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCO.DeleteGoal();
    }
    
    Public static testMethod void ctrlObjectivesOutcomeTest4(){
        Account objAcc = new Account();
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
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.id;        
        objIP.Length_Years__c = '4';
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
        Goals_Objectives__c objGoal = new Goals_Objectives__c();
        objGoal.Goal__c = 'Test Goal';
        objGoal.Concept_Note__c =objCN.Id;
        objGoal.Type__c = 'Objective';
        objGoal.Number__c = 1;
        insert objGoal;
        
        Grant_Indicator__c objIndicator = new Grant_Indicator__c();
        objIndicator.Indicator_Full_Name__c = 'Test Indicator';
        objIndicator.Data_Type__c = 'Percent';
        objIndicator.Concept_Note__c =objCN.Id;
        objIndicator.Goal_Objective__c = objGoal.id;
        insert objIndicator;
        
       // Grant_Indicator__feed objIndicatorfeed = new Grant_Indicator__feed();
       // objIndicatorfeed.ParentID = ID;
        Ind_Goal_Jxn__c objJun = new Ind_Goal_Jxn__c();
        objJun.Goal_Objective__c = objGoal.Id;
        objJun.Indicator__c = objIndicator.Id;
        insert objJun;
        
        Indicator__c objCatIndicator = new Indicator__c();
        objCatIndicator.Programme_Area__c = 'Malaria';
        objCatIndicator.Indicator_Type__c = 'Outcome';
        objCatIndicator.Type_of_Data__c = 'Percent';
        objCatIndicator.Full_Name_En__c = 'Test Cat Indicator';
        insert objCatIndicator;
        
        Project_multi_lingual__c objPs = new Project_multi_lingual__c();
        objPs.English_Text__c = 'Concept Notes';
        objPs.French_Text__c = 'Les notes succinctes';
        objPs.Spanish_Text__c = 'documentos de síntesis';
        objPs.Group_Name__c = 'GoalsAndImpactIndicators';
        objPs.Key__c = 'GIConceptNotes';
        insert objPs;
        
        /*ctrlObjectivesOutcome.wrapGoalsObjectives objWrapper =new ctrlObjectivesOutcome.wrapGoalsObjectives();
        List<ctrlObjectivesOutcome.wrapGoalsObjectives> lstGoalsObjectives ;
        objWrapper.GoalId = objGoal.Id;
        objWrapper.GoalDescription = objGoal.Goal__c;
        objWrapper.IndexGoal = 1;
        objWrapper.blnDisplay = true; 
        lstGoalsObjectives.add(objWrapper);
        insert lstGoalsObjectives;
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        ctrlObjectivesOutcome objCO = new ctrlObjectivesOutcome(sc);
    }*/
}