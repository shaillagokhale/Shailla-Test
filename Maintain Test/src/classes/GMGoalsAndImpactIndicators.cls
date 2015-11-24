/* Controller Class: GoalsAndImpactIndicators
* DateCreated:  12/08/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - page is opened from Url : /apex/GoalsAndImpactIndicators?id={Page__c.Id}
* - create,edit,delete,update Goals and Indicators and create Goal Indicator junction.
----------------------------------------------------------------------------------
* Unit Test: GoalsAndImpactIndicatorsTest
----------------------------------------------------------------------------------
* History:
* - VERSION  DATE            DETAIL FEATURES
    1.0      12/08/2013      INITIAL DEVELOPMENT   
*********************************************************************************/

Public Class GMGoalsAndImpactIndicators{
    Public String strConceptNoteId {get;set;}
    Public String strPageId {get;set;}
    Public List<Module__c> lstModules {get;set;}
    public String strGIPId {get;set;}
    Public List<wrapGoalsObjectives> lstGoalsObjectives {get;set;}
    Public Boolean blnConfirmDelete {get;set;}
    Public Boolean blnConfirmIndicatorDelete {get;set;}
    Public Boolean blnMultiCountryRegional {get;set;}
    Public List<wrapIndicator> lstindicators {get;set;}
    Public Grant_Indicator__c objNewIndicator {get;set;}
    Public Grant_Indicator__c objNewStdIndicator {get;set;}
    Public List<SelectOption> CatalogIndicatorOptions {get;set;}
    Public List<SelectOption> IndicatorCountryOptions {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public String strSelectedCountry {get;set;}
    Public Map<Id,Integer> mapGoalIdToIndex;
    Public String CNComponent;
    Public Set<Id> setIndicatorId;
    Public List<Indicator__c> lstCatalogIndicator {get;set;}
    Public List<Country__c> lstCountries {get;set;}
    Public String setAddGoalCustom {get;set;}
    Public String setAddGoalStandard {get;set;}
    Public String strNewGoalDescription {get;set;}
    Public Boolean blnExpandSection {get;set;}
    Public List<Page__c> lstPagetoDisplay {get;set;}
    
    Public String strLanguage {get;set;}
    Public String strOverview {get;set;}
    Public String strConceptNotes {get;set;}
    Public String strSummary {get;set;}
    Public String strGoalsAndImpactIndicators {get;set;}
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
    Public List<Page__c> lstPages{get;set;}
    Public Map<Id,wrapIndicator> mapIndIdToWrap;
    Public String APIname {get;set;}
    Public String APITitle {get;set;}
    Public Boolean blnReadOnly {get;set;}
    Public Boolean blnEditMode {get;set;}
    Set<Id> setProfileIds {get;set;}
    Grant_Indicator__c CNTarget1;
    public String strSelectedGID {get; set;}
    
    Grant_Disaggregated__c GrantDis;
    public String strSelectedGD {get; set;}
    
    Public String strGuidanceId {get;set;}
    //TCS 22/08/2014:  Added for Profile Access
    Public Boolean blnExternalPro {get;set;}
    Public Boolean blnEdit {get;set;}
    Public Boolean blnDelete {get;set;}
    Public Boolean blnComments {get;set;}
    public Boolean blnCTComments {get;set;}
    public Boolean blnLFAComments {get;set;}
    public Boolean blnPRComments {get;set;}
    Public Boolean blnAddGoal {get;set;}
    Public Boolean blnStdInd {get;set;}
    Public Boolean blnCustInd {get;set;}
    Public Boolean blnDiscussion {get;set;}
 	public List<wrapDAGIndicator> lstwrapDAGIndicator {get;set;}
 	public String ICategory;
    public List<Catalog_Disaggregated__c> lstDAGIndicators {get;set;}

    //TCS 22/09/2014: Added for Disaggregation
    //Public String ICategory;        
    /**********************************************************************************************
    Purpose: Initialize the constructor method  
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    public GMGoalsAndImpactIndicators(ApexPages.StandardController controller) {
    	lstwrapDAGIndicator = new List<wrapDAGIndicator>();
    	CNTarget1 = new Grant_Indicator__c();
    	GrantDis = new Grant_Disaggregated__c();
        System.Debug('Entering GoalsAndImpactIndicators_Paging'); 
        strPageId = Apexpages.currentpage().getparameters().get('id');
        blnExpandSection = false; 
        blnMultiCountryRegional = false;
        //blnReadOnly = CheckProfile.checkProfile();
        if(String.IsBlank(strPageId) == false){
            List<Page__c> lstPage = [Select French_Name__c,Spanish_Name__c,Implementation_Period__c,Implementation_Period__r.Concept_note__c,Implementation_Period__r.Component__c,Concept_note__r.Component__c,Concept_note__r.Language__c,Concept_note__r.Concept_Note_Type__c, Implementation_Period__r.Concept_note__r.Language__c  From Page__c Where Id =: strPageId And (Concept_note__c != null OR Implementation_Period__c != null) Limit 1];
            setProfileIds = new Set<Id>();
            for(Profile p : [Select Id from Profile where Name = 'Test']){
                setProfileIds.add(p.Id);
             }
            
            if(lstPage.size() > 0) {
                
                if(lstPage[0].Implementation_Period__c != null){
                  strConceptNoteId = lstPage[0].Implementation_Period__r.Concept_note__c;
                    strGIPId = lstPage[0].Implementation_Period__c;
                    lstPages = new List<Page__c>();
                    lstPages = [Select Id,Name,URL_Prefix__c,Order__c, Modular__c, Read_Only__c From Page__c Where Implementation_Period__c =: strGIPId  Order by Order__c];
                    lstModules = new List<Module__c>();   
                    lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strGIPID Order by Name]; 
                    CNComponent = lstPage[0].Implementation_Period__r.Component__c;
                        strLanguage = lstPage[0].Implementation_Period__r.Concept_Note__r.Language__c;
                }
                /*else{
                    strConceptNoteId = lstPage[0].Concept_note__c;
                    lstPages = new List<Page__c>();
                    lstPages = [Select Id,Name,URL_Prefix__c,Order__c, Modular__c, Read_Only__c From Page__c Where Concept_Note__c =: strConceptNoteId  Order by Order__c];
                    CNComponent = lstPage[0].Concept_note__r.Component__c;
                    strLanguage = lstPage[0].Concept_note__r.Language__c;
                    if(lstPage[0].Concept_note__r.Concept_Note_Type__c == 'Regional' || lstPage[0].Concept_note__r.Concept_Note_Type__c == 'Multi-Country'){
                        blnMultiCountryRegional = true; } else { blnMultiCountryRegional = false;}
                    lstModules = new List<Module__c>();   
                    lstModules = [Select Id,Name,Concept_Note__c,Implementation_Period__c From Module__c Where Concept_Note__c =: strConceptNoteID Order by Name]; 
                }  */              
            }
            //getPageText();
        }
        
        if(String.IsBlank(strGIPId) == false){
            lstGoalsObjectives = new List<wrapGoalsObjectives>();
            lstindicators = new  List<wrapIndicator>();
            blnConfirmDelete = false;
            blnConfirmIndicatorDelete = false;
            blndisplaySave = false;
            List<Concept_Note__c> lstCN = [Select Id, Status__c from Concept_Note__c where Id = :strConceptNoteId];
            if(!lstCN.isEmpty()){
              if(lstCN[0].Status__c == 'Submitted to the Global Fund' && CheckProfile.checkProfileGF()==false){
                  blnReadOnly = true;
              }else if(lstCN[0].Status__c == 'Not yet submitted'){
                  blnReadOnly = CheckProfile.checkProfile();
              } 
            }
            
            mapGoalIdToIndex = new Map<Id,Integer>();           
            lstGoalsObjectives = new List<wrapGoalsObjectives>();
            
            List<Goals_Objectives__c> lstGoals = [Select id,Name,Goal__c,Goal_Russian__c,Goal_French__c,Goal_Spanish__c,Number__c 
                                            From Goals_Objectives__c 
                                            Where Implementation_Period__c =: strGIPId  
                                            And Type__c = 'Goal' And Number__c != null 
                                            Order By Number__c];
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
                    objWrap.IndexGoal = integer.valueof(objGO.Number__c);
                    objWrap.IndexGoalDec = Count;
                    objWrap.IndexGoalDec = objGo.Number__c;
                    objWrap.blnDisplay = true;
                    lstGoalsObjectives.add(objWrap);
                    Count ++;
                }                
                fillMapGoal();
            }
            
            
            List<Ind_Goal_Jxn__c> lstGoaljunction = [Select Goal_Objective__c,Goal_Objective__r.Goal__c,Goal_Objective__r.Goal_Russian__c,Goal_Objective__r.Goal_French__c,Goal_Objective__r.Goal_Spanish__c,
                                                    Indicator__c From Ind_Goal_Jxn__c 
                                                    Where Goal_Objective__r.Implementation_Period__c =: strGIPId 
                                                    And Goal_Objective__r.Type__c = 'Goal'
                                                    And Indicator__r.Grant_Implementation_Period__c =: strGIPId];
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
                lstIndicator = [Select Id,Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c, Is_Disaggregated__c, Disaggregated_Name__c, Spanish_Name__c,Russian_Name__c,French_Name__c,Comments__c,Comments_Russian__c,Comments_French__c,Comments_Spanish__c,Indicator_Type__c,Country__c, Country__r.Name,
                                        Target_Value_Y1__c,Target_Value_Y2__c,Target_Value_Y3__c,Target_Value_Y4__c,Decimal_Places__c ,
                                        Standard_or_Custom__c,Baseline_Sources__c,Indicator__c,Data_Type__c,Y1_Report_Due__c,Y2_Report_Due__c,Y3_Report_Due__c,Y4_Report_Due__c,Component__c,
                                        (Select Goal_Objective__c From Indicator_Goal_Junctions__r
                                                Where Goal_Objective__c In : setGoalId)
                                        From Grant_Indicator__c
                                        Where Id In : setIndicatorId ]; 
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
                            //if(mapGoalIdToIndex.get(objInd.Goal_Objective__c) == 0)
                            //    objWrapInd.MapIDGoalIndex.put(objInd.Goal_Objective__c,10);
                            //else
                            objWrapInd.MapIDGoalIndex.put(objInd.Goal_Objective__c,mapGoalIdToIndex.get(objInd.Goal_Objective__c));
                        }
                    }
                    if(IndicatorsWithFeedItem.get(objGI.ID)!=null){
                        objWrapInd.blnHasPost = true;                     
                        objWrapInd.intPostCount = IndicatorsWithFeedItem.get(objGI.ID);                     
                    }
                    //TCS 22/09/2014: Added for Disaggregation
                    /*ICategory = '';                     
                    objWrapInd.lstDAGIndicators = [Select Disaggregation_Category__c, Disaggregation_Value__c from Disaggregated_Indicator__c where Indicator_Name__c =: objGI.Indicator_Full_Name__c order by Disaggregation_Category__c];
                    for(Disaggregated_Indicator__c ObjInd : objWrapInd.lstDAGIndicators) {
                        if(ObjInd.Disaggregation_Category__c == ICategory)
                            ObjInd.Disaggregation_Category__c = '';
                        else
                            ICategory = ObjInd.Disaggregation_Category__c;                          
                    }*/
                    lstindicators.add(objWrapInd);
                }
            }
            SetCatalogIndicator();            
            objNewIndicator = new Grant_Indicator__c(Grant_Implementation_Period__c = strGIPId,Standard_or_Custom__c = 'Custom',Indicator_Type__c = 'Impact',Component__c = CNComponent);
         
    
         //System.Debug( 'Exiting GoalsAndImpactIndicators_Paging' ); 
        mapIndIdToWrap = new Map<Id,wrapIndicator>();
         //SetCountries();
    
    
         List<Guidance__c> lstGuidance = new  List<Guidance__c>([Select Id from Guidance__c where Name = 'Goals & Impact Indicators']);
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
    
    }
    checkProfile(); 
    getHistoryTrack();
    blnEditMode = false;
    }
    /**********************************************************************************************
    Purpose: Get page labels for differnt seletcted language.
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/

    /*public void getPageText(){
        System.Debug('Entering getPageText'); 
        if(String.IsBlank(strLanguage) == false){
            Map<String,String> MultiLingualTextMap;
            MultiLingualTextMap = GILanguage.getMultiLingualText(strLanguage,'GoalsAndImpactIndicators');
            if(MultiLingualTextMap !=null && MultiLingualTextMap.size()>0)
            {
                strOverview = MultiLingualTextMap.get('GIOverview');
                strConceptNotes = MultiLingualTextMap.get('GIConceptNotes');
                strSummary = MultiLingualTextMap.get('GISummary');
                strGoalsAndImpactIndicators = MultiLingualTextMap.get('GILabel');
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
                strBaseline = MultiLingualTextMap.get('GIBaseline');
                strValue = MultiLingualTextMap.get('GIValue');
                strYear = MultiLingualTextMap.get('GIYear');
                strSource = MultiLingualTextMap.get('GISource');
                strTargets = MultiLingualTextMap.get('GITargets');
                strComments = MultiLingualTextMap.get('GIComments');
                strDataType = MultiLingualTextMap.get('GIDataType');
                strSelectCatalogIndicator = MultiLingualTextMap.get('GIbtnSelectCatalogIndicator');
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
        System.Debug('Existing getPageText'); 
    }*/
    
    /**********************************************************************************************
    Purpose: Keep map of each goal and its display index
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void fillMapGoal(){
        System.Debug('Entering fillMapGoal'); 
        if(lstGoalsObjectives.size() > 0){
            for(wrapGoalsObjectives objGO : lstGoalsObjectives){
                if(objGO.IndexGoal == null)
                    objGO.IndexGoal = 0;
                mapGoalIdToIndex.put(objGO.GoalId,objGO.IndexGoal);
            }
        }
        System.Debug('Existing fillMapGoal'); 
    }
    
    /**********************************************************************************************
    Purpose: fill catalog indicators which does not already exist in display indicators.
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SetCatalogIndicator(){
        System.Debug('Entering SetCatalogIndicator'); 
        lstCatalogIndicator = new list<Indicator__c>();

           /*if(!blnMultiCountryRegional){
                lstCatalogIndicator = [Select id,Name,Type_of_Data__c,Full_Name_En__c, Is_Disaggregated__c, Disaggregated_Name__c, Russian_Name__c,Spanish_Name__c,French_Name__c from Indicator__c 
                                        Where Component__c INCLUDES(:CNComponent) 
                                        And Indicator_Type__c = 'Impact' 
                                        null And Type_of_Data__c != null
                                            And Id Not IN (Select Indicator__c 
                                        From Grant_Indicator__c Where Id In :setIndicatorId)];  }
            else{ */
            
                lstCatalogIndicator = [Select id,Name,Type_of_Data__c,Full_Name_En__c, Is_Disaggregated__c, Disaggregated_Name__c, Russian_Name__c,Spanish_Name__c,French_Name__c, Component__c from Indicator__c 
                                        Where Component__c INCLUDES(:CNComponent) 
                                        And Indicator_Type__c = 'Impact' 
                                        /*And Full_Name_En__c != null*/ And Type_of_Data__c != null ];   
          
         
                                                                                                                 
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
        System.Debug('Existing SetCatalogIndicator'); 
    }
    
    /**********************************************************************************************
    Purpose: fill countries to which this indicator has not been assigned
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
  /*  Public void SetCountries(){
        System.Debug('Entering SetCountries'); 
        lstCountries = new List<Country__c>();
        
        lstCountries = [Select id,Name from Country__c 
                                    WHERE Id IN (Select Country__c from Multi_Country__c
                                                 Where Concept_Note__c = : strConceptNoteId)];

        IndicatorCountryOptions = new List<SelectOption>();
        IndicatorCountryOptions.add(new SelectOption('','--None--'));
        if(lstCountries.size() > 0){
            for(Country__c objCountry : lstCountries){
                IndicatorCountryOptions.add(new SelectOption(objCountry.id,objCountry.Name));
            }
        }
        System.Debug('Exiting SetCountries'); 
    }    */
    
    /**********************************************************************************************
    Purpose: Delete selected Goal record from database.
    Parameters: Index of Goal list displayed on the page.
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void DeleteGoal(){
        System.Debug('Entering DeleteGoal'); 
        System.Debug('Parameters[0] DeleteIndex: '+Apexpages.CurrentPage().getParameters().Get('DeleteIndex'));
        Integer DeleteIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex')); 
        if(DeleteIndex != null){
            List<Goals_Objectives__c> lstGoalsToDelete = [Select Id,Name from Goals_Objectives__c Where Id =: lstGoalsObjectives[DeleteIndex].GoalId 
                                                And Type__c = 'Goal'];
            
            for(integer i=lstGoalsObjectives[DeleteIndex].IndexGoal-1 ;i<lstGoalsObjectives.size();i++){
                lstGoalsObjectives[i].IndexGoal = lstGoalsObjectives[i].IndexGoal - 1;
            }
              lstGoalsObjectives.remove(DeleteIndex);
            List<Goals_Objectives__c> lstGoalsToUpdate = [Select Id,Number__c from Goals_Objectives__c 
                                                    Where Number__c >: DeleteIndex
                                                    And Type__c = 'Goal' and Implementation_Period__c =: strGIPId ];
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
                List<Ind_Goal_Jxn__c> indGoalJunction = [SELECT Indicator__c,Name FROM Ind_Goal_Jxn__c WHERE Goal_Objective__c IN: objGoalsId];
                
            //Delete Indicator if Objective is deleted
                    List<String> indicatorId = new List<String>();
                    for (Ind_Goal_Jxn__c indicator : indGoalJunction)
                    {
                        String indId = indicator.Indicator__c;
                        indicatorId.add(indId);
                    }
                List<Ind_Goal_Jxn__c> indicators = [SELECT Indicator__c,Name FROM Ind_Goal_Jxn__c WHERE Indicator__c IN : indicatorId and Goal_Objective__c Not IN: objGoalsId ];
                List<string> indicatorids = new List<string>();
                for(Ind_Goal_Jxn__c indicator :indicators )
                {
                        String indId = indicator.Indicator__c;
                        indicatorids.add(indId);
                }
                    system.debug('Goals to Delete '+lstGoalsToDelete);
                    system.debug('Junction to Delete '+indGoalJunction);
                    if(indicators.size() == 0){
                 List<Grant_Indicator__c> lstGIndToDelete = [Select Id From Grant_Indicator__c Where Indicator_Type__c = 'Impact' AND Id IN: indicatorId];
                //if(indGoalJunction.size() > 0) Delete indGoalJunction;
                   system.debug('Indicator to Delete '+lstGIndToDelete);
                     if(lstGIndToDelete.size() > 0) Delete lstGIndToDelete; 
                    }
                    else{
                     List<Grant_Indicator__c> lstGIndToDelete = [Select Id From Grant_Indicator__c Where Indicator_Type__c = 'Impact' AND Id Not IN: indicatorIds and Goal_Objective__c Not IN:objGoalsId  ];
                     if(lstGIndToDelete.size() > 0) Delete lstGIndToDelete; 
                    }
                    
                    
                     if(lstGoalsToDelete.size() > 0) Delete lstGoalsToDelete;
            }
            /*Set<integer> setIndIndex = new Set<Integer>();
            for(integer i=0;i<lstIndicators.size();i++){
                system.debug('@#@#@#@@#'+lstIndicators[i].MapIDGoalIndex.get(lstGoalsObjectives[DeleteIndex].GoalId));
                Integer Count = 0;
                if(lstIndicators[i].MapIDGoalIndex != null){
                    system.debug('@#@#@#@@#'+lstIndicators[i].MapIDGoalIndex);
                    if(lstIndicators[i].MapIDGoalIndex.get(lstGoalsObjectives[DeleteIndex].GoalId) == DeleteIndex){
                        for(Id Goalid : lstIndicators[i].MapIDGoalIndex.keyset()){
                            if(lstIndicators[i].MapIDGoalIndex.get(Goalid) > 0){
                                Count ++;
                            }
                        }
                    }
                    system.debug('@#@#@#@@#'+Count);
                    
                    if(!(Count == 1)){
                        setIndIndex.add(i);
                    }
                    system.debug('@#@#@#@@#'+setIndIndex);
                }
            }
            if(setIndIndex.size() > 0){
                for(Integer IndIndexRemove : setIndIndex){
                    lstIndicators.remove(IndIndexRemove);
                }
            }*/
          
            fillMapGoal();
            blnConfirmDelete = false;
        }
        System.Debug('Existing DeleteGoal');
    }
    
    /**********************************************************************************************
    Purpose: Update existing Goal or save new goal record. 
    Parameters: Index of Goal list displayed on the page.
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SaveGoal(){
        System.Debug('Entering SaveGoal'); 
        System.Debug('Parameters[0] SaveIndex: '+Apexpages.CurrentPage().getParameters().Get('SaveIndex'));
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        Integer intNumber = 0;
        if(SaveIndex != null){
            if(SaveIndex > lstGoalsObjectives.size()){
                List<AggregateResult> lstNumber = [select max(Number__c) Number from Goals_Objectives__c Where Implementation_Period__c =: strGIPId and Type__c = 'Goal'];
                if(lstNumber.size() > 0) {
                    if(lstNumber[0].get('Number') != null)
                        intNumber = (Integer.valueof(lstNumber[0].get('Number'))  + 1);
                    else {
                        intNumber = 1;
                    }
                } 
                Goals_Objectives__c objGoal = new Goals_Objectives__c(Implementation_Period__c = strGIPId,Type__c = 'Goal',Number__c = intNumber); //Goal__c = strNewGoalDescription,
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
                
                objwarpGoal.IndexGoalDec = objGoal.Number__c;
                //if(lstGoalsObjectives.size() > 0) objwarpGoal.IndexGoal = lstGoalsObjectives.size() + 1;
                //else objwarpGoal.IndexGoal = 1;
                objwarpGoal.IndexGoal = intNumber ;
                objwarpGoal.blnDisplay = true;
                mapGoalIdToIndex.put(objwarpGoal.GoalId,objwarpGoal.IndexGoal);
                lstGoalsObjectives.add(objwarpGoal);
                strNewGoalDescription = null;
            }else{
                Goals_Objectives__c objGoal = new Goals_Objectives__c(Implementation_Period__c = strGIPId,Type__c = 'Goal');
                
                 if(strLanguage == 'RUSSIAN')
                    objGoal.Goal_Russian__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                  else if(strLanguage == 'FRENCH')
                    objGoal.Goal_French__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                  else if(strLanguage == 'SPANISH')
                    objGoal.Goal_Spanish__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                  else
                    objGoal.Goal__c = lstGoalsObjectives[SaveIndex].GoalDescription;
                    
                objGoal.Number__c = lstGoalsObjectives[SaveIndex].indexGoalDec;
                objGoal.id = lstGoalsObjectives[SaveIndex].GoalId;
                update objGoal;
                lstGoalsObjectives[SaveIndex].blnDisplay = true;
                mapGoalIdToIndex.put(lstGoalsObjectives[SaveIndex].GoalId,lstGoalsObjectives[SaveIndex].IndexGoal);
            }
            FillAllIndicatorMap();
        }
        System.Debug('Existing SaveGoal');
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
    /**********************************************************************************************
    Purpose: Edit indicator record.
    Parameters: Index of Indicator list displayed on the page.
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public Boolean blndisplaySave {get;set;}
    Public void EditIndicator(){
        System.Debug('Entering EditIndicator'); 
        System.Debug('Parameters[0] EditIndiIndex: '+Apexpages.CurrentPage().getParameters().Get('EditIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('EditIndiIndex'));
        wrapIndicator objwrapIndicatorTemp = new wrapIndicator();
        objwrapIndicatorTemp.objIndicator = new Grant_Indicator__c();
        objwrapIndicatorTemp.objIndicator = lstIndicators[intIndexIndicator].objIndicator.clone(true);        
        objwrapIndicatorTemp.blndisplaySave = lstIndicators[intIndexIndicator].blndisplaySave;
        objwrapIndicatorTemp.IndexIndicator = lstIndicators[intIndexIndicator].IndexIndicator;
        objwrapIndicatorTemp.blnIndicatorDisplay = lstIndicators[intIndexIndicator].blnIndicatorDisplay;
        objwrapIndicatorTemp.MapIDGoalIndex = lstIndicators[intIndexIndicator].MapIDGoalIndex;
        objwrapIndicatorTemp.setGoalIdAdd =lstIndicators[intIndexIndicator].setGoalIdAdd;
        objwrapIndicatorTemp.setGoalIdRemove =lstIndicators[intIndexIndicator].setGoalIdRemove;
        objwrapIndicatorTemp.isStandard = lstIndicators[intIndexIndicator].isStandard;
        objwrapIndicatorTemp.blnHasPost =lstIndicators[intIndexIndicator].blnHasPost;
        objwrapIndicatorTemp.intPostCount = 100;
        mapIndIdToWrap.put(objwrapIndicatorTemp.objIndicator.id,objwrapIndicatorTemp);        
        if(intIndexIndicator != null){
            lstIndicators[intIndexIndicator].blnIndicatorDisplay = false;
            lstIndicators[intIndexIndicator].blndisplaySave = true;            
        }
        System.Debug('Existing EditIndicator'); 
        blnEditMode = true;
    }
    
    /**********************************************************************************************
    Purpose: Cancel Edited indicator record.
    Parameters: Index of Indicator list displayed on the page.
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void CancelIndicator(){
        System.Debug('Entering CancelIndicator'); 
        System.Debug('Parameters[0] CancelIndiIndex: '+Apexpages.CurrentPage().getParameters().Get('CancelIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('CancelIndiIndex'));
        String IndId = lstIndicators[intIndexIndicator].objIndicator.id;
        lstIndicators[intIndexIndicator] = new wrapIndicator();
        lstIndicators[intIndexIndicator] = mapIndIdToWrap.get(IndId);
        lstIndicators[intIndexIndicator].blnIndicatorDisplay = true;
        lstIndicators[intIndexIndicator].blndisplaySave = false;
        System.Debug('Existing CancelIndicator'); 
        blnEditMode = false;
    }
    
    /**********************************************************************************************
    Purpose: Save Edited indicator record And also save/remove goal from junction object 
             from selecting and diselecting Goal from page.
    Parameters: Index of Indicator list displayed on the page.
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SaveIndicator(){
        System.Debug('Entering SaveIndicator'); 
        System.Debug('Parameters[0] SaveIndiIndex: '+Apexpages.CurrentPage().getParameters().Get('SaveIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        if(intIndexIndicator != null){
            if(mapIndIdToWrap.ContainsKey(lstIndicators[intIndexIndicator].objIndicator.id)){
                mapIndIdToWrap.remove(lstIndicators[intIndexIndicator].objIndicator.id);
            }
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
                if(String.IsBlank(lstIndicators[intIndexIndicator].setGoalIdAdd) == false){
                     //&& lstIndicators[intIndexIndicator].setGoalIdAdd.contains(',')
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
            
                List<Grant_Indicator__c> lstIndicatorTemp = [Select Id,Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c, Is_Disaggregated__c, Disaggregated_Name__c, Spanish_Name__c,Russian_Name__c,French_Name__c,Comments__c,Comments_Russian__c,Comments_French__c,Comments_Spanish__c,Indicator_Type__c, Country__c,Country__r.Name,
                                        Target_Value_Y1__c,Target_Value_Y2__c,Target_Value_Y3__c,Target_Value_Y4__c,Decimal_Places__c ,
                                        Standard_or_Custom__c,Baseline_Sources__c,Indicator__c,Data_Type__c,Y1_Report_Due__c,Y2_Report_Due__c,Y3_Report_Due__c,Y4_Report_Due__c,Component__c,
                                        (Select Goal_Objective__c From Indicator_Goal_Junctions__r) 
                                        From Grant_Indicator__c
                                        Where Id =: lstIndicatorToUpdate[0].id Order By Indicator_Number__c];
            
                lstIndicators[intIndexIndicator].objIndicator = lstIndicatorTemp[0];
                lstIndicators[intIndexIndicator].MapIDGoalIndex = new Map<Id,Integer>();
                lstIndicators[intIndexIndicator].MapIDGoalIndex.putAll(mapGoalIdToIndex);
            
                for(Id Goalid : lstIndicators[intIndexIndicator].MapIDGoalIndex.keyset()){
                    lstIndicators[intIndexIndicator].MapIDGoalIndex.put(Goalid ,0);
                }
                for(Ind_Goal_Jxn__c objInd :lstIndicators[intIndexIndicator].objIndicator.Indicator_Goal_Junctions__r){
                    if(lstIndicators[intIndexIndicator].MapIDGoalIndex.ContainsKey(objInd.Goal_Objective__c) == true){
                        //if(mapGoalIdToIndex.get(objInd.Goal_Objective__c) == 0)
                        //    lstIndicators[intIndexIndicator].MapIDGoalIndex.put(objInd.Goal_Objective__c,10);
                        //else
                        lstIndicators[intIndexIndicator].MapIDGoalIndex.put(objInd.Goal_Objective__c,mapGoalIdToIndex.get(objInd.Goal_Objective__c));
                    }
                }
            }
        }
        //system.debug('>>>>>>>>>>>>'+DisagreegationTableController.aggreegationWrapperList);
        //DisagreegationTableController.SaveAction();
        //dc.SaveAction();
        blnEditMode = false;
        System.Debug('Existing SaveIndicator'); 
    }
    
    /**********************************************************************************************
    Purpose: Save standard/custom indicator and create junction records 
             from selecting goals and inserted indicator.
    Parameters: standard/custom indicator
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SaveNewSTdCustomIndicator(Grant_Indicator__c objIndicator){
        List<Grant_Indicator__c> lstGrantIndicatorToInsert = new List<Grant_Indicator__c>();
        
         if(strLanguage == 'RUSSIAN')
         {
             if(objIndicator.Russian_Name__c != null && objIndicator.Data_Type__c != null){
                lstGrantIndicatorToInsert.add(objIndicator);
             }
         }   
         else if(strLanguage == 'FRENCH')
         {
            if(objIndicator.French_Name__c != null && objIndicator.Data_Type__c != null){
               lstGrantIndicatorToInsert.add(objIndicator);
            }
         }
         else if(strLanguage == 'SPANISH')
         {
              if(objIndicator.Spanish_Name__c != null && objIndicator.Data_Type__c != null){
                lstGrantIndicatorToInsert.add(objIndicator);
              }
          }     
          else
           if(objIndicator.Indicator_Full_Name__c != null && objIndicator.Data_Type__c != null){
              lstGrantIndicatorToInsert.add(objIndicator);
              }
        
        if(lstGrantIndicatorToInsert.size() > 0){
            insert lstGrantIndicatorToInsert;
            system.debug('aaaaaaaaaa'+lstGrantIndicatorToInsert);
             system.debug('aaaaaaaaaa'+lstGrantIndicatorToInsert[0].id);
            //TCS 27/09/2014: Added for Disaggregation
            system.debug('This is here');
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
                List<Grant_Indicator__c> lstIndicatorTemp = [Select Id,Is_Disaggregated__c, Disaggregated_Name__c, Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c,Spanish_Name__c,Russian_Name__c,French_Name__c,Comments__c,Comments_Russian__c,Comments_French__c,Comments_Spanish__c,Indicator_Type__c, Country__c,Country__r.Name,
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
    
    /**********************************************************************************************
    Purpose: update All indicators map of goal and its index related indicator record.
    Parameters:  NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
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
    
    /**********************************************************************************************
    Purpose: Save new custom indicator.
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SaveNewIndicator(){
        Integer SaveIndex = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndex'));
        objNewIndicator.Indicator_Number__c = SaveIndex;
        SaveNewSTdCustomIndicator(objNewIndicator);
        objNewIndicator = new Grant_Indicator__c(Grant_Implementation_Period__c = strGIPId,Standard_or_Custom__c = 'Custom',Indicator_Type__c = 'Impact',Component__c = CNComponent);
    }
    
    
    /**********************************************************************************************
    Purpose: Refresh list of indicators when working with a multi-country/regional
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void RefreshIndicators() {
        if(blnMultiCountryRegional){ 
        strSelectedIndicator = ''; }
     }
    
    /**********************************************************************************************
    Purpose: On select catalog indicator from picklist refresh the standard indicator panel.
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void CreateIndicatorOnSelectCatalog(){
        if(String.isBlank(strSelectedIndicator) == false){
            //List<Indicator__c> lstIndicatorForSelectname = [Select Name,Type_of_Data__c From Indicator__c Where Id =: strSelectedIndicator Limit 1];
            for(Indicator__c objInd : lstCatalogIndicator){
                if(objInd.Id == strSelectedIndicator){
                    objNewStdIndicator = new Grant_Indicator__c(Grant_Implementation_Period__c = strGIPId,
                                                        Standard_or_Custom__c = 'Standard',
                                                        Indicator__c = objInd.Id,
                                                        Data_Type__c = objInd.Type_of_Data__c,
                                                        Component__c = CNComponent,
                                                        Indicator_Type__c = 'Impact');   
                    objNewStdIndicator.Is_Disaggregated__c = objInd.Is_Disaggregated__c;
                    objNewStdIndicator.Disaggregated_Name__c =  objInd.Disaggregated_Name__c;                                  
                                if(strLanguage == 'RUSSIAN')
                                      objNewStdIndicator.Russian_Name__c = objInd.Russian_Name__c;
                                else if(strLanguage == 'FRENCH')
                                       objNewStdIndicator.French_Name__c = objInd.French_Name__c;
                                else if(strLanguage == 'SPANISH')
                                       objNewStdIndicator.Spanish_Name__c = objInd.Spanish_Name__c; 
                                else  if(objInd.Is_Disaggregated__c)
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
    
    /**********************************************************************************************
    Purpose: Delete selecting indicator.
    Parameters: Index of Indicator list displayed on the page.
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void DeleteIndicator(){
        Integer intDeleteIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('DeleteIndiIndex'));
        if(intDeleteIndexIndicator != null){
            List<Grant_Indicator__c> lstIndicatorToDelete = new List<Grant_Indicator__c>();
            if(lstIndicators[intDeleteIndexIndicator].objIndicator.Id != null){
                lstIndicatorToDelete.add(lstIndicators[intDeleteIndexIndicator].objIndicator);
            }
            lstIndicators.remove(intDeleteIndexIndicator);
            
            if(lstIndicatorToDelete.size() > 0) Delete lstIndicatorToDelete;
            
            List<Grant_indicator__c> lstIndicatorToUpdate = [Select Id,Indicator_Number__c From Grant_Indicator__c 
                                    Where Grant_Implementation_Period__c =: strGIPId And Indicator_Number__c >: intDeleteIndexIndicator];
            if(lstIndicatorToUpdate.size() > 0){
                for(Grant_indicator__c objGI : lstIndicatorToUpdate){
                    objGI.Indicator_Number__c = objGI.Indicator_Number__c - 1;
                }
            }
            
            blnConfirmIndicatorDelete = false;
            SetCatalogIndicator();
        }
    }
    
    /**********************************************************************************************
    Purpose: Save standard indicator record.
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SaveStdIndicator(){
        Integer SaveIndex = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndex'));
        objNewStdIndicator.Indicator_Number__c = SaveIndex;
        SaveNewSTdCustomIndicator(objNewStdIndicator);
    }
    /**********************************************************************************************
    Purpose: Created for Profile Access
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    Created Date: 22/08/2014
    **********************************************************************************************/
    
    public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
      List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_GoalsAndImpactIndicators' and Profile_Name__c =: profilename];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Edit')blnEdit = true;
        if(check.Salesforce_Item__c == 'Delete')blnDelete = true;
        if(check.Salesforce_Item__c == 'Comments')blnComments = true;
        if(check.Salesforce_Item__c == 'CT Comments')blnCTComments = true;
        if(check.Salesforce_Item__c == 'LFA Comments')blnLFAComments = true;
        if(check.Salesforce_Item__c == 'PR Comments')blnPRComments = true;
        if(check.Salesforce_Item__c == 'Add Goal')blnAddGoal = true;
        if(check.Salesforce_Item__c == 'Add Standard Indicator')blnStdInd = true;
        if(check.Salesforce_Item__c == 'Add Custom Indicator')blnCustInd = true;
        if(check.Salesforce_Item__c == 'Discussion')blnDiscussion = true;
      }
    }
    
     Public String [] lstGranInfoFields {get; set;}
    public Boolean blnHistory{get;set;}
    public List<sObject> lstHistory {get;set;}
    public Set<Id> grantDisID{get;set;}
    Public Map<String, String > mapfield {get;set;}
    Public String strRecordId {get;set;} // Stores Target Record Id passed from attributes
    Public String strObjectName {get;set;} // Stores Taget Object API name passed from attributes
    Public String strRecordTitle {get;set;}
    
    public void getHistoryTrack(){
    lstGranInfoFields = new String[] {'Disaggregated_Baseline_Sources__c', 'Disaggregated_Baseline_Year__c', 'Disaggregated_Baseline_Value__c'};
    
    lstHistory = new List<sObject>();
    lstHistory = [SELECT CreatedBy.Name,Id, IsDeleted, CreatedById, CreatedDate, Field, OldValue, NewValue,ParentID FROM Grant_Disaggregated__History 
                  where ParentId=: 'a1Zg00000019mleEAA' AND Field IN :lstGranInfoFields ORDER BY CreatedDate DESC,Field asc];
    system.debug('**lstHistory'+lstHistory);
        mapfield =new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap =new Map<String, Schema.SObjectField>();
        fieldMap = Schema.getGlobalDescribe().get('Grant_Disaggregated__c').getDescribe().fields.getMap();
        for(Schema.SObjectField sobj : fieldMap.values() ){
            mapfield.put(sobj.getDescribe().getName(),sobj.getDescribe().getLabel());
            system.debug('mapfield'+ mapfield);
        }
        
        
        //Putting fields which are not in the mapfield but in the list like 'created' etc
        for(sObject objHistory : lstHistory){
        System.debug('****************'+(mapfield.containsKey(string.valueOf(objHistory.get('Field')))));
            if(mapfield.containsKey(string.valueOf(objHistory.get('Field')))==false){
            system.debug('hhhhhhhhhhhhhhhhhhhhhhhh'+string.valueOf(objHistory.get('Field'))+'000000000000000000000000'+string.valueOf(objHistory.get('Field')));
            system.debug('eeeeeeeeeeeeee'+string.valueOf(objHistory.get('Field'))+'qqqqqqqqqqqqq'+string.valueOf(objHistory.get('Field')));

                mapfield.put(string.valueOf(objHistory.get('Field')),string.valueOf(objHistory.get('Field')));
            }
        }
        //return lstHistory;
    }
    
    
 
    Public Class wrapGoalsObjectives{
        Public String GoalDescription{get;set;}
        Public Id GoalId{get;set;}
        Public Integer IndexGoal {get;set;}
        Public Decimal IndexGoalDec {get;set;}
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
        Public Integer intPostCount {get;set;}
        Public Boolean blnHistory {get;set;}
        //TCS 22/09/2014: Added for Disaggregation
        //Public List<Disaggregated_Indicator__c> lstDAGIndicators {get;set;}
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