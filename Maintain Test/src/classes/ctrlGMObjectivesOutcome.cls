Public Class ctrlGMObjectivesOutcome{
    Public String strImpGuidanceId {get;set;}
    Public String strPageId {get;set;}
    Public List<wrapGoalsObjectives> lstGoalsObjectives {get;set;}
    Public Boolean blnConfirmDelete {get;set;}
    Public Boolean blnConfirmIndicatorDelete {get;set;}
    Public List<wrapIndicator> lstindicators {get;set;}
    Public Grant_Indicator__c objNewIndicator {get;set;}
    Public Grant_Indicator__c objNewStdIndicator {get;set;}
    Public list<SelectOption> CatalogIndicatorOptions {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public Map<Id,Integer> mapGoalIdToIndex;
    Public String CNComponent;
    Public Set<Id> setIndicatorId;
    Public List<Indicator__c> lstCatalogIndicator {get;set;}
    Public String setAddGoalCustom {get;set;}
    Public String setAddGoalStandard {get;set;}
    Public String strNewGoalDescription {get;set;}
    Public List<Page__c> lstPage {get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public String strImplementationPeriodID {get;set;}
    Public boolean blnExpandSection {get;set;}
    Public boolean blnReadOnly {get;set;}
    Grant_Indicator__c CNTarget1;
    public String strSelectedGID {get; set;}
    
    Grant_Disaggregated__c GrantDis;
    public String strSelectedGD {get; set;}
    
    //For country selection:
    Public List<Country__c> lstCountries {get;set;}
    Public Boolean blnMultiCountryRegional {get;set;}
    Public List<SelectOption> IndicatorCountryOptions {get;set;}
    
    Public String strLanguage {get;set;}
    Public String strOverview {get;set;}
    Public String strConceptNotes {get;set;}
    Public String strSummary {get;set;}
    Public String strctrlObjectivesOutcome {get;set;}
    Public String strObjectivesAndOutcomeIndicators {get;set;}
    Public String strModulesAndInterventions {get;set;}
    Public String strGuidance {get;set;}
    Public String strclosePanelLabel {get;set;}
    Public String strGoals {get;set;}
    Public String strImpactIndicators {get;set;}
    Public String strAreYouSure {get;set;}
    Public String strGoalDeleted {get;set;}
    Public String strIndicatorDeleted {get;set;}
    Public String strLinkedToGoals {get;set;}
    Public String strLinkedToObjectives {get;set;}
    Public String strBaseline {get;set;}
    Public String strValue {get;set;}
    Public String strYear {get;set;}
    Public String strSource {get;set;}
    Public String strTargets {get;set;}
    Public String strComments {get;set;}
    Public String strDataType {get;set;}
    Public String strSelectCatalogIndicator {get;set;}
    Public String strSeeHelp {get;set;}
    Public String strADDGOAL {get;set;}
    Public String strEdit {get;set;}
    Public String strDelete {get;set;}
    Public String strSave {get;set;}
    Public String strCancel {get;set;}
    Public String strSelect {get;set;}
    Public String strAddStandardIndicator {get;set;}
    Public String strAddCustomIndicator {get;set;}
    Public String APIname {get;set;}
    Public String APITitle {get;set;}
    Public Boolean blnGMReadOnly {get;set;}
    Public string IPName {get;set;}
    public String strGuidanceId {get;set;}
    Public Boolean blnEditMode {get;set;}
    public Boolean blnExternalPro {get;set;}
    public Boolean blnEdit {get;set;}
    public Boolean blnDelete {get;set;}
    public Boolean blnComments {get;set;}
    public Boolean blnCTComments {get;set;}
    public Boolean blnLFAComments {get;set;}
    public Boolean blnPRComments {get;set;}
    public Boolean blnAddObjective {get;set;}
    public Boolean blnAddStdInd {get;set;}
    public Boolean blnAddCustInd {get;set;}
    public Boolean blnHistory {get;set;}
    public Boolean blnDiscussion {get;set;}
    
    public List<wrapDAGIndicator> lstwrapDAGIndicator {get;set;}
 	public String ICategory;
    public List<Catalog_Disaggregated__c> lstDAGIndicators {get;set;}
    

   
    public ctrlGMObjectivesOutcome(ApexPages.StandardController controller) {
        //blnReadOnly = CheckProfile.checkProfile();
        lstwrapDAGIndicator = new List<wrapDAGIndicator>();
        CNTarget1 = new Grant_Indicator__c();   
        GrantDis = new Grant_Disaggregated__c();     
        List<Page__c> lstPage= new  List<Page__c>();
        strPageId = Apexpages.currentpage().getparameters().get('id');
        blnMultiCountryRegional = false;
        if(String.IsBlank(strPageId) == false){
            strLanguage = 'ENGLISH';
            lstPage = [Select Concept_Note__c,Russian_Name__c,Spanish_Name__c,French_Name__c, Implementation_Period__r.Concept_Note__r.Id ,Implementation_Period__c,Implementation_Period__r.Name,Implementation_Period__r.Concept_Note__c,Implementation_Period__r.Component__c,Implementation_Period__r.Grant__r.Disease_Component__c,Implementation_Period__r.Language__c From Page__c Where Id =: strPageId And Implementation_Period__c != null Limit 1];
            if(lstPage.size() > 0) {
                if(lstPage[0].Implementation_Period__c != null){
                    
                    if(lstPage[0].Concept_note__c==null)
                    {
                        blnGMReadOnly=true;
                    }
                    IpName= lstPage[0].Implementation_Period__r.Name;
                   // strImpPeriodId = lstPage[0].Implementation_Period__r.Concept_note__c;
                    strImplementationPeriodId = lstPage[0].Implementation_Period__c;
                    lstPages = new List<Page__c>();   
                    lstPages = [Select Id,Name,Russian_Name__c,Spanish_Name__c,French_Name__c,URL_Prefix__c,Order__c,Modular__c From Page__c Where Implementation_Period__c =: strImplementationPeriodID Order by Order__c];
                    lstModules = new List<Module__c>();   
                    lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strImplementationPeriodID Order by Name]; 
                    
                    CNComponent = lstPage[0].Implementation_Period__r.Component__c;
                    strLanguage = lstPage[0].Implementation_Period__r.Language__c;  
                }/*else{
                    strConceptNoteId = lstPage[0].Concept_note__c;
                    lstPages = new List<Page__c>();   
                    lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Concept_Note__c =: strConceptNoteID Order by Order__c]; 
                    lstModules = new List<Module__c>();   
                    lstModules = [Select Id,Name,Concept_Note__c,Implementation_Period__c From Module__c Where Concept_Note__c =: strConceptNoteID Order by Name]; 
                    CNComponent = lstPage[0].Concept_note__r.Component__c;
                    strLanguage = lstPage[0].Concept_note__r.Language__c; 
                    if(lstPage[0].Concept_note__r.Concept_Note_Type__c == 'Regional' || lstPage[0].Concept_note__r.Concept_Note_Type__c == 'Multi-Country'){
                        blnMultiCountryRegional = true; } else { blnMultiCountryRegional = false;}                   
                }
                if(lstPage[0].Concept_note__r.Status__c == 'Submitted to the Global Fund' && CheckProfile.checkProfileGF()==false){
                    blnReadOnly = true; 
                }else if(lstPage[0].Concept_note__r.Status__c == 'Not yet submitted'){
                    blnReadOnly = CheckProfile.checkProfile();
                }*/
            }
            getPageText();
        }
        if(String.IsBlank(strImplementationPeriodId) == false){
            lstGoalsObjectives = new List<wrapGoalsObjectives>();
            lstindicators = new  List<wrapIndicator>();
            blnConfirmDelete = false;
            blnConfirmIndicatorDelete = false;
            blndisplaySave = false;
           
        
            mapGoalIdToIndex = new Map<Id,Integer>();
            lstGoalsObjectives = new List<wrapGoalsObjectives>();
            List<Goals_Objectives__c> lstGoals = [Select id,Name,Goal__c,Goal_Russian__c,Goal_French__c,Goal_Spanish__c From Goals_Objectives__c 
                            Where Implementation_Period__c =: strImplementationPeriodID 
                            And Type__c = 'Objective' Order By Number__c];
            if(lstGoals.size() > 0){
                Integer Count = 1;
                for(Goals_Objectives__c objGO : lstGoals){
                    wrapGoalsObjectives objWrap = new wrapGoalsObjectives();
                    objWrap.GoalDescription = objGO.Goal__c;
                    
                     if(strLanguage == 'RUSSIAN')
                      objWrap.GoalDescription = objGO.Goal_Russian__c;
                    if(strLanguage == 'FRENCH')
                       objWrap.GoalDescription = objGO.Goal_French__c;  
                    if(strLanguage == 'SPANISH')
                       objWrap.GoalDescription = objGO.Goal_Spanish__c;
                    
                    objWrap.GoalId = objGO.Id;
                    objWrap.IndexGoal = Count;
                    objWrap.blnDisplay = true;
                    lstGoalsObjectives.add(objWrap);
                    Count ++;
                }
                fillMapGoal();
            }
            
            List<Ind_Goal_Jxn__c> lstGoaljunction = [Select Goal_Objective__c,Goal_Objective__r.Goal__c,Goal_Objective__r.Goal_Russian__c,Goal_Objective__r.Goal_French__c,Goal_Objective__r.Goal_Spanish__c,
                                                    Indicator__c From Ind_Goal_Jxn__c 
                                                    Where Goal_Objective__r.Implementation_Period__c =: strImplementationPeriodID 
                                                    And Goal_Objective__r.Type__c = 'Objective'
                                                    And Indicator__r.Grant_Implementation_Period__c =: strImplementationPeriodID];
            setIndicatorId = new Set<Id>();   
            Set<Id> setGoalId = new Set<Id>();              
            if(lstGoaljunction.size() > 0){
                for(Ind_Goal_Jxn__c obj : lstGoaljunction){
                    setIndicatorId.add(obj.Indicator__c);
                    setGoalId.add(obj.Goal_Objective__c);
                }
            }                 
            List<Grant_Indicator__c> lstIndicator = new List<Grant_Indicator__c>();          
            if(setIndicatorId.size() > 0){
                lstIndicator = [Select Id,Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c, Is_Disaggregated__c, Disaggregated_Name__c, Spanish_Name__c,Russian_Name__c,French_Name__c,Comments__c,Comments_Russian__c,Comments_French__c,Comments_Spanish__c, Country__c, Country__r.Name,
                                        Target_Value_Y1__c,Target_Value_Y2__c,Target_Value_Y3__c,Target_Value_Y4__c,Indicator_Type__c ,Decimal_Places__c,
                                        Standard_or_Custom__c,Baseline_Sources__c,Indicator__c,Data_Type__c,Y1_Report_Due__c,Y2_Report_Due__c,Y3_Report_Due__c,Y4_Report_Due__c ,Component__c,
                                        (Select Goal_Objective__c From Indicator_Goal_Junctions__r
                                                Where Goal_Objective__c In : setGoalId) 
                                        From Grant_Indicator__c
                                        Where Id In : setIndicatorId Order By Indicator_Number__c]; 
            }
            List<Grant_Indicator__feed> lstIndicatorfeed= [select id,ParentID from Grant_Indicator__feed where parentId IN: lstIndicator];
            Map<ID,Integer> IndicatorsWithFeedItem = new Map<ID,Integer>();
            for(Grant_Indicator__feed objIndiWithFeed: lstIndicatorfeed){
                if(IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)==null){
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,1);
                }else{
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)+1);
                }
            }
            if(lstIndicator.size() > 0){
                for(Grant_Indicator__c objGI :lstIndicator){
                    wrapIndicator objWrapInd = new wrapIndicator();
                    objWrapInd.objIndicator = new Grant_Indicator__c();
                    objWrapInd.objIndicator = objGI;
                    objWrapInd.blnIndicatorDisplay = true;
                    objWrapInd.MapIDGoalIndex = new Map<Id,Integer>();
                    objWrapInd.MapIDGoalIndex.putAll(mapGoalIdToIndex);
                    for(Id Goalid : objWrapInd.MapIDGoalIndex.keyset()){
                        objWrapInd.MapIDGoalIndex.put(Goalid ,0);
                    }
                    for(Ind_Goal_Jxn__c objInd :objGI.Indicator_Goal_Junctions__r){
                        if(objWrapInd.MapIDGoalIndex.ContainsKey(objInd.Goal_Objective__c) == true){
                            objWrapInd.MapIDGoalIndex.put(objInd.Goal_Objective__c,mapGoalIdToIndex.get(objInd.Goal_Objective__c));
                        }
                    }
                    if(IndicatorsWithFeedItem.get(objGI.ID)!=null){
                        objWrapInd.blnHasPost = true;                     
                        objWrapInd.intPostCount = IndicatorsWithFeedItem.get(objGI.ID);                     
                    }
                    lstindicators.add(objWrapInd);
                }
            }
            SetCatalogIndicator();
            SetCountries();
            objNewIndicator = new Grant_Indicator__c(Grant_Implementation_Period__c = strImplementationPeriodId,Standard_or_Custom__c = 'Custom', Indicator_Type__c = 'Outcome',Component__c = CNComponent);
        }
    
      /*  strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
          */
          
            if(lstPage.size() > 0) { 
                if(lstPage[0].Implementation_Period__c != null){
                     List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name =:label.GM_Objectives_Outcome_Indicators];
                     if(!lstGuidance.isEmpty()) {
                          strGuidanceId = lstGuidance[0].Id;
                     }
                 }
                 else{
                     List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Goals & Impact Indicators'];
                     if(!lstGuidance.isEmpty()) {
                         strGuidanceId = lstGuidance[0].Id;
                     }
                }
            }
            
            List<Guidance__c> lstGuidanceImp = [Select Id from Guidance__c where Name =:label.GM_Objectives_Outcome_Indicators]; 
              if(lstGuidanceImp!=Null){
                  strImpGuidanceId = lstGuidanceImp[0].id;   
              }  
        blnEditMode = false;
        checkProfile();//TCS 25/08/2014 Added for Profile Access
    }
    
    
    
    public void getPageText(){
        system.debug('#####strLanguage->'+strLanguage);
        if(String.IsBlank(strLanguage) == false){
            Map<String,String> MultiLingualTextMap;
            MultiLingualTextMap = GILanguage.getMultiLingualText(strLanguage,'goalsandimpactindicators');
            if(MultiLingualTextMap !=null && MultiLingualTextMap.size()>0)
            {
                strOverview = MultiLingualTextMap.get('GIOverview');
                strConceptNotes = MultiLingualTextMap.get('GIConceptNotes');
                strSummary = MultiLingualTextMap.get('GISummary');
                strctrlObjectivesOutcome = MultiLingualTextMap.get('GILabel');
                strObjectivesAndOutcomeIndicators = MultiLingualTextMap.get('GIObjectiveAndOutcome');
                strModulesAndInterventions = MultiLingualTextMap.get('GImodulesandinterventions');
                strGuidance = MultiLingualTextMap.get('GIGuidance');
                strclosePanelLabel = MultiLingualTextMap.get('GIlabelClose');
                strGoals = MultiLingualTextMap.get('GIGoals');
                strImpactIndicators = MultiLingualTextMap.get('GIImpactindicators');
                strAreYouSure = MultiLingualTextMap.get('GIAreyousure');
                strGoalDeleted = MultiLingualTextMap.get('GIGoalWillDeleted');
                strIndicatorDeleted = MultiLingualTextMap.get('GIIndicatorWillDeleted');
                strLinkedToGoals = MultiLingualTextMap.get('GILinkedtogoals');
                strLinkedToObjectives = MultiLingualTextMap.get('GILinkedtoobjectives');
                strBaseline = MultiLingualTextMap.get('GIBaseline');
                strValue = MultiLingualTextMap.get('GIValue');
                strYear = MultiLingualTextMap.get('GIYear');
                strSource = MultiLingualTextMap.get('GISource');
                strTargets = MultiLingualTextMap.get('GITargets');
                strComments = MultiLingualTextMap.get('GIComments');
                strDataType = MultiLingualTextMap.get('GIDataType');
                strSelectCatalogIndicator = MultiLingualTextMap.get('GIbtnAddStandardIndicator');
                strSeeHelp = MultiLingualTextMap.get('GIbtnSeeHelp');
                strADDGOAL = MultiLingualTextMap.get('GIbtnAddGoal');
                strEdit = MultiLingualTextMap.get('GIbtnEdit');
                strDelete = MultiLingualTextMap.get('GIbtnDelete');
                strSave = MultiLingualTextMap.get('GIbtnSave');
                strCancel = MultiLingualTextMap.get('GIbtnCancel');
                strSelect = MultiLingualTextMap.get('GIbtnSelect');
                strAddStandardIndicator = MultiLingualTextMap.get('GIbtnAddStandardIndicator');
                strAddCustomIndicator = MultiLingualTextMap.get('GIbtnAddCustomIndicator');
            }
        }
    }
    
    Public void fillMapGoal(){
        if(lstGoalsObjectives.size() > 0){
            for(wrapGoalsObjectives objGO : lstGoalsObjectives){
                mapGoalIdToIndex.put(objGO.GoalId,objGO.IndexGoal);
            }
        }
    }
    
    Public void SetCatalogIndicator(){
        lstCatalogIndicator = new list<Indicator__c>();
        if(!blnMultiCountryRegional){
            lstCatalogIndicator = [Select id,Name,Type_of_Data__c,Full_Name_En__c,Is_Disaggregated__c, Disaggregated_Name__c, Spanish_Name__c,Russian_Name__c,French_Name__c,Component__c from Indicator__c 
                                    Where Component__c INCLUDES (:CNComponent)
                                    And Indicator_Type__c = 'Outcome' 
                                        And Id Not IN (Select Indicator__c 
                                        From Grant_Indicator__c Where Id In :setIndicatorId)];  }
        else {
            lstCatalogIndicator = [Select id,Name,Type_of_Data__c,Full_Name_En__c,Is_Disaggregated__c, Disaggregated_Name__c, Spanish_Name__c,Russian_Name__c,French_Name__c,Component__c from Indicator__c 
                                    Where Component__c INCLUDES (:CNComponent)
                                    And Indicator_Type__c = 'Outcome'];  }                                                                       
                                        
        CatalogIndicatorOptions = new List<SelectOption>();
        CatalogIndicatorOptions.add(new SelectOption('','--'+Label.None+'--'));
        if(lstCatalogIndicator.size() > 0){
            for(Indicator__c objInd : lstCatalogIndicator){
                if(strLanguage == 'ENGLISH' && objInd.Full_Name_En__c != null){
                	if(objInd.Is_Disaggregated__c == true){
                	CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Disaggregated_Name__c));
                	}else{
                  CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Full_Name_En__c));} }
                if(strLanguage == 'FRENCH' && objInd.French_Name__c != null){
                  CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.French_Name__c)); }
                if(strLanguage == 'RUSSIAN' && objInd.Russian_Name__c != null){
                  CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Russian_Name__c)); }
                if(strLanguage == 'SPANISH' && objInd.Spanish_Name__c != null){
                  CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Spanish_Name__c)); }
             }
        }
    }
    
    /**********************************************************************************************
    Purpose: fill countries
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SetCountries(){
        System.Debug('Entering SetCountries'); 
        lstCountries = new List<Country__c>();
        
        lstCountries = [Select id,Name from Country__c 
                                    WHERE Id IN (Select Country__c from Multi_Country__c
                                                 Where Implementation_Period__c = : strImplementationPeriodId)];

        IndicatorCountryOptions = new List<SelectOption>();
        IndicatorCountryOptions.add(new SelectOption('','--'+Label.None+'--'));
        if(lstCountries.size() > 0){
            for(Country__c objCountry : lstCountries){
                IndicatorCountryOptions.add(new SelectOption(objCountry.id,objCountry.Name));
            }
        }
        System.Debug('Exiting SetCountries'); 
    }   
    
    Public void EditGoal(){
    	integer EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            lstGoalsObjectives[EditIndex].blnDisplay = false;
        }
        
    }
    
    Public void DeleteGoal(){
        Integer DeleteIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex')); 
        if(DeleteIndex != null){
            List<Goals_Objectives__c> lstGoalsToDelete = [Select Id,Name from Goals_Objectives__c Where Id =: lstGoalsObjectives[DeleteIndex].GoalId];
            
            
            for(integer i=lstGoalsObjectives[DeleteIndex].IndexGoal-1 ;i<lstGoalsObjectives.size();i++){
                lstGoalsObjectives[i].IndexGoal = lstGoalsObjectives[i].IndexGoal - 1;
            }
            lstGoalsObjectives.remove(DeleteIndex);
            
            List<Goals_Objectives__c> lstGoalsToUpdate = [Select Id,Number__c from Goals_Objectives__c 
                                                    Where Number__c >: DeleteIndex
                                                    And Type__c = 'Objective'
                                                    And Implementation_Period__c =: strImplementationPeriodID];
            for(Goals_Objectives__c objG : lstGoalsToUpdate){
                objG.Number__c = objG.Number__c - 1;
            }
            update lstGoalsToUpdate;
            List<String> objGoalsId = new List<String>();
            for (Goals_Objectives__c goal:lstGoalsToDelete )
            {
            	String goalId = goal.Id;
            	objGoalsId.add(goalId);
            }
            system.debug('Goal Id**'+objGoalsId);
             if(lstGoalsToDelete.size() > 0){
            //Delete Junction Object
            	List<Ind_Goal_Jxn__c> indGoalJunction = [SELECT Indicator__c FROM Ind_Goal_Jxn__c WHERE Goal_Objective__c IN: objGoalsId];
            //Delete Indicator if Objective is deleted
            		List<String> indicatorId = new List<String>();
            		for (Ind_Goal_Jxn__c indicator : indGoalJunction)
            		{
            			String indId = indicator.Indicator__c;
            			indicatorId.add(indId);
            		}
                    system.debug('Goals to Delete '+lstGoalsToDelete);
                    system.debug('Junction to Delete '+indGoalJunction);
                    //List<Ind_Goal_Jxn__c> indicators = [SELECT Indicator__c,Name FROM Ind_Goal_Jxn__c WHERE Indicator__c IN : indicatorId and Goal_Objective__c Not IN: objGoalsId ];
                 /*  List<Ind_Goal_Jxn__c> indicators = [SELECT Indicator__c,Name FROM Ind_Goal_Jxn__c WHERE Indicator__c IN : indicatorId AND Goal_Objective__c IN: objGoalsId];
                  	system.debug('Number of Indicators '+indicators);
                   List<String> indicatorids = new List<String>();
                   for(Ind_Goal_Jxn__c indicator :indicators )
	                {
                        String indId = indicator.Indicator__c;
                        indicatorids.add(indId);
	                }
                    system.debug('Goals to Delete1 '+lstGoalsToDelete);
                    system.debug('Junction to Delete1 '+indGoalJunction);
                    if(indicators.size() == 1){
 				   List<Grant_Indicator__c> lstGIndToDelete = [Select Id From Grant_Indicator__c Where Indicator_Type__c = 'Outcome'AND Id IN: indicatorId];
		       
		           system.debug('Indicator to Delete '+lstGIndToDelete);
		           if(lstGIndToDelete.size() > 0) Delete lstGIndToDelete; 
                 }
                  /*  else{
                     List<Grant_Indicator__c> lstGIndToDelete = [Select Id From Grant_Indicator__c Where Indicator_Type__c = 'Impact' AND Id Not IN: indicatorIds and Goal_Objective__c Not IN:objGoalsId  ];
                     if(lstGIndToDelete.size() > 0) Delete lstGIndToDelete; 
                    } */
		        if(lstGoalsToDelete.size() > 0) Delete lstGoalsToDelete;
		        List<Grant_Indicator__c> LstIndicator = new List<Grant_Indicator__c>();
 		        List<Grant_Indicator__c> indicators = [SELECT Id from Grant_Indicator__c Where Indicator_Type__c = 'Outcome' AND Grant_Implementation_period__c =: strImplementationPeriodID ];
		    	for (Grant_Indicator__c indToDelete : indicators){
		    		List<Ind_Goal_Jxn__c> indicatorsjxn = [SELECT Indicator__c FROM Ind_Goal_Jxn__c WHERE Indicator__c = : indToDelete.Id ];
		    			if(indicatorsjxn.size() == 0) LstIndicator.add(indToDelete);
		    	}
		    	if(LstIndicator.size() >0) Delete LstIndicator;
		    }
            fillMapGoal();
            blnConfirmDelete = false;
        }
    }
    
    Public void SaveGoal(){
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            if(SaveIndex > lstGoalsObjectives.size()){
                Goals_Objectives__c objGoal = new Goals_Objectives__c(Implementation_Period__c = strImplementationPeriodID,Type__c = 'Objective',Number__c = SaveIndex);  //Goal__c = strNewGoalDescription,
                
                 if(strLanguage == 'RUSSIAN')
                     objGoal.Goal_Russian__c = strNewGoalDescription;
                  else if(strLanguage == 'FRENCH')
                     objGoal.Goal_French__c = strNewGoalDescription;  
                  else if(strLanguage == 'SPANISH')
                     objGoal.Goal_Spanish__c = strNewGoalDescription;
                  else
                     objGoal.Goal__c =  strNewGoalDescription; 
                
                insert objGoal;
                wrapGoalsObjectives objwarpGoal = new wrapGoalsObjectives();
                objwarpGoal.GoalId = objGoal.id;
                objwarpGoal.GoalDescription = objGoal.Goal__c;
                
                if(strLanguage == 'RUSSIAN')
                     objwarpGoal.GoalDescription = objGoal.Goal_Russian__c;
                  else if(strLanguage == 'FRENCH')
                     objwarpGoal.GoalDescription = objGoal.Goal_French__c;
                  else if(strLanguage == 'SPANISH')
                    objwarpGoal.GoalDescription = objGoal.Goal_Spanish__c;
                
                if(lstGoalsObjectives.size() > 0) objwarpGoal.IndexGoal = lstGoalsObjectives.size() + 1;
                else objwarpGoal.IndexGoal = 1;
                objwarpGoal.blnDisplay = true;
                mapGoalIdToIndex.put(objwarpGoal.GoalId,objwarpGoal.IndexGoal);
                lstGoalsObjectives.add(objwarpGoal);
                strNewGoalDescription = null;
            }else{
                Goals_Objectives__c objGoal = new Goals_Objectives__c(Implementation_Period__c = strImplementationPeriodID,Type__c = 'Objective');
                               
                 if(strLanguage == 'RUSSIAN')
                    objGoal.Goal_Russian__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                  else if(strLanguage == 'FRENCH')
                    objGoal.Goal_French__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                  else if(strLanguage == 'SPANISH')
                    objGoal.Goal_Spanish__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                  else
                    objGoal.Goal__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                    
                
                objGoal.id = lstGoalsObjectives[SaveIndex].GoalId;
                update objGoal;
                lstGoalsObjectives[SaveIndex].blnDisplay = true;
                mapGoalIdToIndex.put(lstGoalsObjectives[SaveIndex].GoalId,lstGoalsObjectives[SaveIndex].IndexGoal);
            }
            FillAllIndicatorMap();
        }
        
    }
    Public void CancelGoal(){
        integer CancelIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            if(lstGoalsObjectives[CancelIndex].GoalId != null){
                lstGoalsObjectives[CancelIndex].blnDisplay = true;
            }else{
                lstGoalsObjectives.remove(CancelIndex);
            }
        }
    }
    Public void AddNewGoal(){
        wrapGoalsObjectives objWrap = new wrapGoalsObjectives();
        objWrap.GoalId = null;
        objWrap.blnDisplay = false;
        if(lstGoalsObjectives.size() > 0) objWrap.IndexGoal = lstGoalsObjectives.size()+1;
        else objWrap.IndexGoal = 1;
        lstGoalsObjectives.add(objWrap);
    }
    
    Public Boolean blndisplaySave {get;set;}
    Public void EditIndicator(){
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('EditIndiIndex'));
        if(intIndexIndicator != null){
            lstIndicators[intIndexIndicator].blnIndicatorDisplay = false;
            lstIndicators[intIndexIndicator].blndisplaySave = true;
            blnEditMode = true;
        }
    }
    //Display History
    Public Integer intHistoryIndicator {get;set;}
    Public void ShowHistoryPopup(){
        intHistoryIndicator = integer.valueof(apexpages.currentpage().getparameters().get('HistoryIndiIndex'));
        system.debug('hh:'+intHistoryIndicator);
        if(intHistoryIndicator!= null){
            APIname = 'Grant_Indicator__c';
            //APITitle = 'History of :';
            
            lstIndicators[intHistoryIndicator].blnHistory = true;
            system.debug('Bln:'+ lstIndicators[intHistoryIndicator].blnHistory);
            
        }
        
   
    }
    //History Popup Close
    public void HidePopupHistory()
    {  
        
        if (intHistoryIndicator > -1) {
           lstIndicators[intHistoryIndicator].blnHistory = false;
        }
    }
    Public void CancelIndicator(){
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('CancelIndiIndex'));
        lstIndicators[intIndexIndicator].blnIndicatorDisplay = true;
        lstIndicators[intIndexIndicator].blndisplaySave = false;
    }
    Public void SaveIndicator(){
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        if(intIndexIndicator != null){
            List<Grant_Indicator__c> lstIndicatorToUpdate = new List<Grant_Indicator__c>();
            lstIndicatorToUpdate.add(lstIndicators[intIndexIndicator].objIndicator);
            lstIndicators[intIndexIndicator].blnIndicatorDisplay = true;
            lstIndicators[intIndexIndicator].blndisplaySave = false;
            
            if(lstIndicatorToUpdate.size() > 0){
                update lstIndicatorToUpdate;
            
                Set<Id> goalToDelete = new Set<Id>();
                Set<Id> goalToinsert = new Set<Id>();
            
          for(Id goalId : lstIndicators[intIndexIndicator].MapIDGoalIndex.keyset()){
                    if(lstIndicators[intIndexIndicator].MapIDGoalIndex.get(goalId) != 0){
                        if(lstIndicators[intIndexIndicator].setGoalIdAdd.contains(goalId) == false){
                            goalToDelete.add(goalId);
                        }
                    }
                }
                if(String.IsBlank(lstIndicators[intIndexIndicator].setGoalIdAdd) == false && lstIndicators[intIndexIndicator].setGoalIdAdd.contains(',')){
                    for(String str: lstIndicators[intIndexIndicator].setGoalIdAdd.Split(',')){
                        if(lstIndicators[intIndexIndicator].MapIDGoalIndex.get(str) == 0){
                            goalToinsert.add(str);
                        }
                    }
                }
                if(goalToDelete.size() > 0){
                    List<Ind_Goal_Jxn__c> lstGoalJunToDelete = [Select id from Ind_Goal_Jxn__c Where Goal_Objective__c In: goalToDelete And Indicator__c =: lstIndicatorToUpdate[0].id];
                    if(lstGoalJunToDelete.size() > 0) Delete lstGoalJunToDelete;
                }
                if(goalToinsert.size() > 0){
                    List<Ind_Goal_Jxn__c> lstGoalJunToInsert = new List<Ind_Goal_Jxn__c>();
                    for(Id goalInsertId : goalToinsert){
                        Ind_Goal_Jxn__c objGoalJun = new Ind_Goal_Jxn__c(Goal_Objective__c = goalInsertId,Indicator__c = lstIndicatorToUpdate[0].id);
                        lstGoalJunToInsert.add(objGoalJun);
                    }
                    if(lstGoalJunToInsert.size() > 0) Insert lstGoalJunToInsert;
                }
            
                List<Grant_Indicator__c> lstIndicatorTemp = [Select Name,Id,Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c, Is_Disaggregated__c, Disaggregated_Name__c, Spanish_Name__c,Russian_Name__c,French_Name__c,Comments__c,Comments_Russian__c,Comments_French__c,Comments_Spanish__c,Indicator_Type__c,Country__c, Country__r.Name,
                                        Target_Value_Y1__c,Target_Value_Y2__c,Target_Value_Y3__c,Target_Value_Y4__c,Decimal_Places__c,
                                        Standard_or_Custom__c,Baseline_Sources__c,Indicator__c,Data_Type__c,Y1_Report_Due__c,Y2_Report_Due__c,Y3_Report_Due__c,Y4_Report_Due__c,Component__c,
                                        (Select Goal_Objective__c From Indicator_Goal_Junctions__r) 
                                        From Grant_Indicator__c
                                        Where Id =: lstIndicatorToUpdate[0].id];
            
                lstIndicators[intIndexIndicator].objIndicator = lstIndicatorTemp[0];
                lstIndicators[intIndexIndicator].MapIDGoalIndex = new Map<Id,Integer>();
                lstIndicators[intIndexIndicator].MapIDGoalIndex.putAll(mapGoalIdToIndex);
            
                for(Id Goalid : lstIndicators[intIndexIndicator].MapIDGoalIndex.keyset()){
                    lstIndicators[intIndexIndicator].MapIDGoalIndex.put(Goalid ,0);
                }
                for(Ind_Goal_Jxn__c objInd :lstIndicators[intIndexIndicator].objIndicator.Indicator_Goal_Junctions__r){
                    if(lstIndicators[intIndexIndicator].MapIDGoalIndex.ContainsKey(objInd.Goal_Objective__c) == true){
                        lstIndicators[intIndexIndicator].MapIDGoalIndex.put(objInd.Goal_Objective__c,mapGoalIdToIndex.get(objInd.Goal_Objective__c));
                    }
                }
            }
        }
       blnEditMode = false; 
    }
    
    
    Public void SaveNewSTdCustomIndicator(Grant_Indicator__c objIndicator,Integer Index){
        List<Grant_Indicator__c> lstGrantIndicatorToInsert = new List<Grant_Indicator__c>();
       /* if(objIndicator.Indicator_Full_Name__c != null && objIndicator.Data_Type__c != null){
            objIndicator.Indicator_number__c = Index;
            lstGrantIndicatorToInsert.add(objIndicator);
        }*/
        
         if(strLanguage == 'RUSSIAN')
         {
             if(objIndicator.Russian_Name__c != null && objIndicator.Data_Type__c != null){
                objIndicator.Indicator_number__c = Index;
                lstGrantIndicatorToInsert.add(objIndicator);
             }
         }   
         else if(strLanguage == 'FRENCH')
         {
            if(objIndicator.French_Name__c != null && objIndicator.Data_Type__c != null){
               objIndicator.Indicator_number__c = Index;
               lstGrantIndicatorToInsert.add(objIndicator);
            }
         }
         else if(strLanguage == 'SPANISH')
         {
              if(objIndicator.Spanish_Name__c != null && objIndicator.Data_Type__c != null){
                objIndicator.Indicator_number__c = Index;
                lstGrantIndicatorToInsert.add(objIndicator);
              }
         }     
         else
           if(objIndicator.Indicator_Full_Name__c != null && objIndicator.Data_Type__c != null){
              objIndicator.Indicator_number__c = Index;
              lstGrantIndicatorToInsert.add(objIndicator);
              }
        
        if(lstGrantIndicatorToInsert.size() > 0){
            insert lstGrantIndicatorToInsert;    
            
            if(lstwrapDAGIndicator.size() > 0) {
            	system.debug('lstwrapDAGIndicator :' +lstwrapDAGIndicator);
            	for(wrapDAGIndicator objWrap : lstwrapDAGIndicator) {
            		
            		objWrap.GDAGIndicator.Grant_Indicator__c = lstGrantIndicatorToInsert[0].Id;            		
            		system.debug('###Indicator Id :' +lstGrantIndicatorToInsert[0].Id);
            		Grant_Disaggregated__c gd = new Grant_Disaggregated__c();
            		gd = objWrap.GDAGIndicator;
            		
            		insert gd;
            	} 
            }                    
            
            List<Ind_Goal_Jxn__c> lstGoalJunToInsert = new List<Ind_Goal_Jxn__c>();
            Set<Id> setGoalInsertCus = new Set<Id>();
            system.debug('#$#$setAddGoalCustom#$#$#$'+setAddGoalCustom);
            if(String.IsBlank(setAddGoalCustom) == false){
                for(String str: setAddGoalCustom.Split(',')){
                    setGoalInsertCus.add(str);
                  }
                for(Id goalInsertId : setGoalInsertCus){
                    Ind_Goal_Jxn__c objGoalJun = new Ind_Goal_Jxn__c(Goal_Objective__c = goalInsertId,Indicator__c = lstGrantIndicatorToInsert[0].id);
                    lstGoalJunToInsert.add(objGoalJun);
                }
                setAddGoalCustom = null;
            }else if(String.IsBlank(setAddGoalStandard) == false){
                for(String str: setAddGoalStandard.Split(',')){
                    setGoalInsertCus.add(str);
                }
                for(Id goalInsertId : setGoalInsertCus){
                    Ind_Goal_Jxn__c objGoalJun = new Ind_Goal_Jxn__c(Goal_Objective__c = goalInsertId,Indicator__c = lstGrantIndicatorToInsert[0].id);
                    lstGoalJunToInsert.add(objGoalJun);
                }
                setAddGoalStandard = null;
            }
            
            system.debug('#$#$lstGoalJunToInsert#$#$#$'+lstGoalJunToInsert);
            if(lstGoalJunToInsert.size() > 0){
                Insert lstGoalJunToInsert;
                setIndicatorId.add(lstGrantIndicatorToInsert[0].id);
                List<Grant_Indicator__c> lstIndicatorTemp = [Select Name,Id,Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c, Is_Disaggregated__c, Disaggregated_Name__c, Spanish_Name__c,Russian_Name__c,French_Name__c,Comments__c,Comments_Russian__c,Comments_French__c,Comments_Spanish__c,Indicator_Type__c,Country__c, Country__r.Name,
                                        Target_Value_Y1__c,Target_Value_Y2__c,Target_Value_Y3__c,Target_Value_Y4__c,Decimal_Places__c,
                                        Standard_or_Custom__c,Baseline_Sources__c,Indicator__c,Data_Type__c,Y1_Report_Due__c,Y2_Report_Due__c,Y3_Report_Due__c,Y4_Report_Due__c,Component__c,
                                        (Select Goal_Objective__c From Indicator_Goal_Junctions__r
                                                Where ID IN: lstGoalJunToInsert) 
                                        From Grant_Indicator__c
                                        Where Id =: lstGrantIndicatorToInsert[0].id];
                wrapIndicator objWrapInd = new wrapIndicator();
                objWrapInd.objIndicator = new Grant_Indicator__c();
                objWrapInd.objIndicator = lstIndicatorTemp[0];
                objWrapInd.blnIndicatorDisplay = true;
                objWrapInd.MapIDGoalIndex = new Map<id,Integer>();
                lstindicators.add(objWrapInd);

                FillAllIndicatorMap();
            }
            SetCatalogIndicator();           
        } 
       blnEditMode = false;  
    }
    
    Public void FillAllIndicatorMap(){
        if(lstIndicators.size() > 0){
            for(wrapIndicator objWrapInd :lstIndicators){
                objWrapInd.MapIDGoalIndex = new Map<Id,Integer>();
                objWrapInd.MapIDGoalIndex.putAll(mapGoalIdToIndex);
                
                for(Id Goalid : objWrapInd.MapIDGoalIndex.keyset()){
                    objWrapInd.MapIDGoalIndex.put(Goalid ,0);
                }
                for(Ind_Goal_Jxn__c objInd :objWrapInd.objIndicator.Indicator_Goal_Junctions__r){
                    if(objWrapInd.MapIDGoalIndex.ContainsKey(objInd.Goal_Objective__c) == true){
                        objWrapInd.MapIDGoalIndex.put(objInd.Goal_Objective__c,mapGoalIdToIndex.get(objInd.Goal_Objective__c));
                    }
                }
            } 
        }
    }
    
    Public void SaveNewIndicator(){
        Integer SaveIndicatorIndex = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndex'));
        SaveNewSTdCustomIndicator(objNewIndicator,SaveIndicatorIndex);
        objNewIndicator = new Grant_Indicator__c(Grant_Implementation_Period__c = strImplementationPeriodID,Standard_or_Custom__c = 'Custom', Indicator_Type__c = 'Outcome',Component__c = CNComponent);
    }
    
    Public void CreateIndicatorOnSelectCatalog(){
        if(String.isBlank(strSelectedIndicator) == false){
            //List<Indicator__c> lstIndicatorForSelectname = [Select Name,Type_of_Data__c From Indicator__c Where Id =: strSelectedIndicator Limit 1];
            for(Indicator__c objInd : lstCatalogIndicator){
                if(objInd.Id == strSelectedIndicator){
                    objNewStdIndicator = new Grant_Indicator__c(Grant_Implementation_Period__c = strImplementationPeriodId,
                                                        Standard_or_Custom__c = 'Standard',
                                                        Indicator__c = objInd.Id,
                                                        Indicator_Type__c = 'Outcome',
                                                        Component__c = CNComponent,
                                                        Data_Type__c = objInd.Type_of_Data__c,
                                                        Decimal_Places__c='0');
                             
                    objNewStdIndicator.Is_Disaggregated__c = objInd.Is_Disaggregated__c;
                    objNewStdIndicator.Disaggregated_Name__c =  objInd.Disaggregated_Name__c;                                 
                               if(strLanguage == 'RUSSIAN')
                                      objNewStdIndicator.Russian_Name__c = objInd.Russian_Name__c;
                                else if(strLanguage == 'FRENCH')
                                       objNewStdIndicator.French_Name__c = objInd.French_Name__c;
                                else if(strLanguage == 'SPANISH')
                                       objNewStdIndicator.Spanish_Name__c = objInd.Spanish_Name__c; 
                                else if(objInd.Is_Disaggregated__c)
                                objNewStdIndicator.Indicator_Full_Name__c = objInd.Disaggregated_Name__c; 
                                else    
                                     objNewStdIndicator.Indicator_Full_Name__c = objInd.Full_Name_En__c; 
                                     
                                //TCS 27/09/2014: Added for Disaggregation
                    lstwrapDAGIndicator = new List<wrapDAGIndicator>();
                    if(objInd.Is_Disaggregated__c) {                    
                    lstDAGIndicators = new List<Catalog_Disaggregated__c>();
                    ICategory = '';                                         			                   		
                    lstDAGIndicators = [Select Disaggregation_Category__c, Disaggregation_Value__c from Catalog_Disaggregated__c where Catalog_Indicator__c =: objInd.Id order by Disaggregation_Category__c];
                    for(Catalog_Disaggregated__c ObjIndi : lstDAGIndicators) {
                    	wrapDAGIndicator objWrapDAGIndicator = new wrapDAGIndicator();
                    	if(ObjIndi.Disaggregation_Category__c == ICategory)
                        	objWrapDAGIndicator.Disaggregation_Category = '';
                    	else {
                  			ICategory = ObjIndi.Disaggregation_Category__c;
                  			objWrapDAGIndicator.Disaggregation_Category = ICategory; }

                        objWrapDAGIndicator.Disaggregation_Value = ObjIndi.Disaggregation_Value__c;                        
                        objWrapDAGIndicator.GDAGIndicator = new Grant_Disaggregated__c();
                        objWrapDAGIndicator.GDAGIndicator.Catalog_Disaggregated__c = ObjIndi.Id;                        			
                        objWrapDAGIndicator.GDAGIndicator.Component__c = CNComponent;                                              
                        lstwrapDAGIndicator.add(objWrapDAGIndicator);
                 	}     }                                                                 
                    break;
                }                                    
            }                                        
        }
        
    }
    
    Public void DeleteIndicator(){
        Integer intDeleteIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('DeleteIndiIndex'));
        if(intDeleteIndexIndicator != null){
            List<Grant_Indicator__c> lstIndicatorToDelete = new List<Grant_Indicator__c>();
            if(lstIndicators[intDeleteIndexIndicator].objIndicator.Id != null){
                lstIndicatorToDelete.add(lstIndicators[intDeleteIndexIndicator].objIndicator);
            }
            
            List<Grant_Indicator__c> lstIndicatorToUpdate = [Select Id,Indicator_Number__c,Indicator_Type__c  from Grant_Indicator__c 
                                                    Where Indicator_Number__c >: intDeleteIndexIndicator
                                                    And Grant_Implementation_Period__c =: strImplementationPeriodId];
            for(Grant_Indicator__c objG : lstIndicatorToUpdate){
                objG.Indicator_Number__c = objG.Indicator_Number__c - 1;
            }
            update lstIndicatorToUpdate;
            
            lstIndicators.remove(intDeleteIndexIndicator);
            
            if(lstIndicatorToDelete.size() > 0) Delete lstIndicatorToDelete;          
            
            blnConfirmIndicatorDelete = false;
            SetCatalogIndicator();
        }
        
    }
    
    Public void SaveStdIndicator(){
        Integer SaveIndicatorIndex = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndex'));
        SaveNewSTdCustomIndicator(objNewStdIndicator,SaveIndicatorIndex);
        
    }
    
    //TCS 25/08/2014 Created for Profile Access 
    public void checkProfile(){
    	Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_Objectives' and Profile_Name__c =: profilename];
        system.debug(checkpage);
        for (Profile_Access_Setting__c check : checkpage){
            if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
            if(check.Salesforce_Item__c == 'Edit')blnEdit = true;
            if(check.Salesforce_Item__c == 'Delete')blnDelete = true;
            if(check.Salesforce_Item__c == 'Comments')blnComments = true;
            if(check.Salesforce_Item__c == 'CT Comments')blnCTComments = true;
            if(check.Salesforce_Item__c == 'LFA Comments')blnLFAComments = true;
            if(check.Salesforce_Item__c == 'PR Comments')blnPRComments = true;
            if(check.Salesforce_Item__c == 'Add Objective')blnAddObjective = true;
            if(check.Salesforce_Item__c == 'Add Standard Indicator')blnAddStdInd = true;
            if(check.Salesforce_Item__c == 'Add Custom Indicator')blnAddCustInd = true;
            if(check.Salesforce_Item__c == 'Discussion')blnDiscussion = true;
            if(check.Salesforce_Item__c == 'History')blnHistory = true;
        }
      }
     
    Public Class wrapGoalsObjectives{
        Public String GoalDescription{get;set;}
        Public Id GoalId{get;set;}
        Public Integer IndexGoal {get;set;}
        Public Boolean blnDisplay {get;set;}
    }
    Public Class wrapIndicator{
        Public Grant_Indicator__c objIndicator {get;set;}
        Public Boolean blndisplaySave {get;set;}
        Public Integer IndexIndicator {get;set;}
        Public Boolean blnIndicatorDisplay {get;set;}
        Public Map<id,Integer> MapIDGoalIndex {get;set;}
        Public String setGoalIdAdd {get;set;}
        Public String setGoalIdRemove {get;set;}
        Public Boolean isStandard {get;set;}
        Public Boolean blnHasPost {get;set;}
        Public Boolean blnHistory {get;set;}
        Public Integer intPostCount {get;set;}
        Public Boolean blnComponentSaveDisplay {get;set;}
    }
    Public Class wrapDAGIndicator { //TCS 29/09/2014: Added for Disaggregation
    	public String ICategory;
    	public Grant_Disaggregated__c GDAGIndicator {get;set;}
    	public String Disaggregation_Value {get;set;}
    	public String Disaggregation_Category {get;set;}
    }
    
    public Grant_Indicator__c CNTarget {
    get{
        if(strSelectedGID != '' && strSelectedGID != null) {
        Grant_Indicator__c gc = [select id, Indicator_Full_Name__c,Data_Type__c, Above_Indicative_Denominator1__c,Above_Indicative_Denominator2__c,Decimal_Places__c,Spanish_Name__c ,Russian_Name__c,French_Name__c,
                                Above_Indicative_Denominator3__c,Above_Indicative_Denominator4__c,
                                Above_Indicative_Numerator1__c,Above_Indicative_Numerator2__c,
                                Above_Indicative_Numerator3__c,Above_Indicative_Numerator4__c,
                                Above_Indicative_Percent1__c,Above_Indicative_Percent2__c,Above_Indicative_Percent3__c,
                                Above_Indicative_Percent4__c,Indicative_Denominator1__c,Indicative_Denominator2__c,
                                Indicative_Denominator3__c,Indicative_Denominator4__c,IndicativeNumerator1__c,
                                IndicativeNumerator2__c,IndicativeNumerator3__c,IndicativeNumerator4__c,
                                Indicative_Percent1__c,Indicative_Percent2__c,Indicative_Percent3__c,Indicative_Percent4__c,PR_Comments__c,Comments__c,Country_Team_Comments__c,LFA_Comments__c                                
                                from Grant_Indicator__c 
                                where Id =: strSelectedGID limit 1];
                                CNTarget1 = gc;
                                return gc;
        }
                                else 
                                return null;
    }                          
   
}
    
    Public void saveGlobalComments(){
        strSelectedGID = '';
    //fetchCNTargets();
    //system.debug('***CNTarget'+CNTarget.Country_Team_Comments__c);
    system.debug('***CNTarget'+CNTarget1);
    
    update CNTarget1;
    
    }
    public Grant_Disaggregated__c GDComm {
    get{
        if(strSelectedGD != '' && strSelectedGD != null) {
        Grant_Disaggregated__c gc = [select id,PR_Comments__c,Global_Fund_Comments__c,LFA_Comments__c                                
                                from Grant_Disaggregated__c 
                                where Id =: strSelectedGD limit 1];
                                GrantDis = gc;
                                return gc;
                        }
                                else 
                                return null;
            }                          
   
        }
     
    Public void saveGDComments(){
    	system.debug('ppppppppppppp'+strSelectedGD);
        strSelectedGD = '';
    //fetchCNTargets();
    //system.debug('***CNTarget'+CNTarget.Country_Team_Comments__c);
    system.debug('***CNTarget'+GrantDis);
    Grant_Disaggregated__c gd = new Grant_Disaggregated__c();
    gd.id = GrantDis.id;
    update GrantDis;
    
    }
}