/*********************************************************************************
* Controller Class: GrantCoverageOutputIndicator
* DateCreated:  08/26/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - page is opened from a button on the GM ModulesInterventions page
* - creates Result/Target record for each Grant_Indicator__c records where 
    Type = 'Coverage/Output' and Module =: master module__c.Module
----------------------------------------------------------------------------------
* Unit Test: TestGrantCoverageOutputIndicator
----------------------------------------------------------------------------------
* History:
* - VERSION  DATE            DETAIL FEATURES
    1.0      08/26/2013      INITIAL DEVELOPMENT   
*********************************************************************************/
Public Class GrantCoverageOutputIndicator1{ 
    Public String strModuleId {get;set;}
    Public String strCatalogModuleId {get;set;}
    Public String strImplementationPeriodId {get;set;}    
    Public List<GrantIndicatorResult> lstGrantIndicatorResult{get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public List<Period__c> lstPeriods{get;set;}
    Public GrantIndicatorResult objCustomGrantIndicatorResult{get;set;}
    Public GrantIndicatorResult objStandardGrantIndicatorResult{get;set;}
    Public Boolean blnExpandSection {get;set;}
    Public String strComponent {get;set;}
    
    Public List<SelectOption> CatalogIndicatorOptions {get;set;}
    Public List<SelectOption> SubsetofOptions {get;set;}
    Public List<SelectOption> AllRPFreqOption{get;set;}
    Public List<SelectOption> AllRPFreqOptionCust {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public String strSubIndicator {get;set;}
    Public String strSubIndicatorExist {get;set;}
    Public String strReportFreq{get;set;}
    Public Map<ID,Indicator__c> MapCatalogIndicator;
    Public Map<ID,Grant_Indicator__c> MapGrantIndicator;
    Public Boolean blnConfirmIndicatorDelete {get;set;}
    Public Map<Id,GrantIndicatorResult> mapGIIdTowrap {get;set;}
    
    Public String strLanguage {get;set;}
    Public String strHome {get;set;}
    Public String strModules {get;set;}
    Public String strHealthProducts {get;set;}
    Public String strDetailedBudget {get;set;}
    Public String strClosepanelLabel {get;set;}
    Public String strOutputIndicators {get;set;}
    Public String strCoverage {get;set;}
    Public String strResponsiblePrincipalRecipient {get;set;}
    Public String strTargetArea{get;set;}
    Public String strTiedTo{get;set;}
    Public String strNum {get;set;}
    Public String strDen {get;set;}
    Public String strTargetAssumptions {get;set;}
    Public String strAddAnIndicator {get;set;}
    Public String strSeeCNTargets {get;set;}
    Public String strConceptNotes {get;set;}
    Public String strSummary {get;set;}
    Public String strGoalsAndImpactIndicators {get;set;}
    Public String strGuidance {get;set;}
    Public String strEdit {get;set;}
    Public String strDelete {get;set;}
    Public String strSelectCatalogIndicator {get;set;}
    Public String strBaseline {get;set;}
    Public String strYear {get;set;}
    Public String strSource {get;set;}
    Public String strComments {get;set;}
    Public String strCountryTeamComments {get;set;}
    Public String strLFAComments {get;set;}
    Public String strTargets {get;set;}
    Public String strDataType {get;set;}
    Public String strSave {get;set;}
    Public String strCancel {get;set;}
    Public String strAreYouSure {get;set;}
    Public String strIndicatorDeleted {get;set;}
    Public String strAddStandardIndicator {get;set;}
    Public String strAddCustomIndicator {get;set;}
    Public String strSelect{get;set;}
    Public String strGuidanceId {get;set;}
    Public String strAnd {get;set;}
    Public String grantIndicatorId {get;set;}
    Grant_Indicator__c CNTarget1;
    Public Grant_Indicator__c objGIndi {get;set;}
    
    Grant_Disaggregated__c GrantDis;
    public String strSelectedGD {get; set;}
    
    Public String APIname {get;set;}
    Public Boolean blnEditMode {get;set;}
    
    public Boolean blnExternalPro {get;set;}
    public Boolean blnEdit {get;set;}
    public Boolean blnDelete {get;set;}
    public Boolean blnComments {get;set;}
    public Boolean blnCTComments {get;set;}
    public Boolean blnLFAComments {get;set;}
    public Boolean blnPRComments {get;set;}
    public Boolean blnAddStdInd {get;set;}
    public Boolean blnAddCustInd {get;set;}
    public Boolean blnHistory {get;set;}
    public Boolean blnDiscussion {get;set;}
    public String strSelectedGID {get; set;}
    
    
    //TCS 22/09/2014: Added for Disaggregation    
    public List<wrapDAGIndicator> lstwrapDAGIndicator {get;set;}
    public String ICategory;
    public List<Catalog_Disaggregated__c> lstDAGIndicators {get;set;}
    /**********************************************************************************************
    Purpose: Initialize the constructor method  
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    public GrantCoverageOutputIndicator1(ApexPages.StandardController controller) {
    CNTarget1 = new Grant_Indicator__c();
    GrantDis = new Grant_Disaggregated__c();   
        System.Debug('Entering GrantCoverageOutputIndicator'); 
        strModuleId = Apexpages.currentpage().getparameters().get('id');
        system.debug(' Module Id** '+strModuleId);
        strAnd = '&';
        if(String.IsBlank(strModuleId) == false){
            List<Module__c> lstModule = [Select ID, Name, Implementation_Period__c,Language__c,Catalog_Module__c,Implementation_Period__r.Component__c 
                                        From Module__c 
                                        Where Id =: strModuleId Limit 1];
            if(lstModule!=null && lstModule.size() > 0) {
                strImplementationPeriodId = lstModule[0].implementation_Period__c;
                strComponent = lstModule[0].Implementation_Period__r.Component__c; 
                if(strComponent == 'Health Systems Strengthening'){
                strComponent = 'HSS';
                }
                strCatalogModuleId = lstModule[0].Catalog_Module__c;
                if(lstModule[0].Language__c != null) strLanguage = lstModule[0].Language__c;
                else strLanguage = 'ENGLISH';
                
                lstPages = new List<Page__c>();   
                lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId Order by Order__c];
                lstModules = new List<Module__c>();   
                lstModules = [Select Id,Name,Implementation_Period__c,implementation_Period__r.Name From Module__c Where Implementation_Period__c =: strImplementationPeriodID Order by Name]; 
          
                blnConfirmIndicatorDelete = false;
                getPageText();
                fillPeriods();
                fillGrantIndicatorResult();
                fillCatalogIndicator();
                fillsubset();
                //FillFreOpCust();
                AddNewCustomGrantIndicatorResult();
            }
        }        
        mapGIIdTowrap = new Map<Id,GrantIndicatorResult>();
        System.Debug('Exiting GrantCoverageOutputIndicator'); 
          List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name =: label.GM_Coverage_Output_Indicators];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
            blnEditMode = false;
        checkProfile();//TCS 25/08/2014 Added for Profile Access
        //fetchCNTargets();
        AllRPFreqOptionCust =  new List<Selectoption>(); 
       Schema.DescribeFieldResult fieldResult = Indicator__c.Reporting_Frequency__c.getDescribe();
       AllRPFreqOptionCust.add(new SelectOption('', '-- None --'));
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for(Schema.PicklistEntry f : ple){
          AllRPFreqOptionCust.add(new SelectOption(f.getLabel(), f.getValue()));
       }
       system.debug('***AllRPFreqOption'+AllRPFreqOption);
    }
    
    Public void FillFreOpCust(){
       AllRPFreqOption =  new List<Selectoption>(); 
       Schema.DescribeFieldResult fieldResult = Indicator__c.Reporting_Frequency__c.getDescribe();
       AllRPFreqOption.add(new SelectOption('', '-- None --'));
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for(Schema.PicklistEntry f : ple){
          AllRPFreqOption.add(new SelectOption(f.getLabel(), f.getValue()));
       }
       system.debug('***AllRPFreqOption'+AllRPFreqOption);               
    } 
    
    
    
    /**********************************************************************************************
    Purpose: Fill Subset Indicator
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void fillsubset(){
        System.Debug('Entering fillsubset');  
        
       
        Set<Id> setIP = new Set<Id>();
        Set<Id> setGID = new Set<Id>();                             
        Implementation_Period__c ipObject = [Select Id,Name,Concept_note__c from Implementation_Period__c where Id =:strImplementationPeriodId];    
        system.debug('***IP GRANT OBJECT'+ipObject);
        List<Implementation_Period__c> lstIPObject = [Select Id,Name,Concept_note__c from Implementation_Period__c where Concept_note__c =:ipObject.Concept_Note__c];
        system.debug('***IP List from CN'+lstIPObject); 
        for(Implementation_Period__c objIP: lstIPObject){
        setIP.add(objIP.Id);
        }
        system.debug('***setIP'+setIP); 
        List <Grant_Indicator__c> lstGrantRec = [Select id,Name,Indicator_Full_Name__c,Disaggregated_Name__c,Is_Disaggregated__c,Target_Accumulation__c,Grant_Implementation_Period__c
                                            From Grant_Indicator__c 
                                            Where Indicator_Type__c =: 'Coverage/Output'
                                            and Grant_Implementation_Period__c in: setIP];
        for(Grant_Indicator__c grObj :lstGrantRec ){
            setGID.add(grObj.Id);
        }
        MapGrantIndicator = new Map<Id,Grant_Indicator__c>
        ([Select id,Name,Indicator_Full_Name__c,Disaggregated_Name__c,Is_Disaggregated__c,Target_Accumulation__c,Grant_Implementation_Period__c
                                            From Grant_Indicator__c 
                                            Where Indicator_Type__c =: 'Coverage/Output'
                                            and Id in : setGID
                                           ]
         
        );
        system.debug('***MapGrantIndicator'+MapGrantIndicator);                                                                         
        SubsetofOptions = new List<SelectOption>();
        SubsetofOptions.add(new SelectOption('','--None--'));
        if(MapGrantIndicator!=null && MapGrantIndicator.size() > 0){
            for(Grant_Indicator__c objSub : MapGrantIndicator.values()){
                 if(objSub.Is_Disaggregated__c == true){
                    SubsetofOptions.add(new SelectOption(objSub.Disaggregated_Name__c,objSub.Disaggregated_Name__c));
                    }else{
                  SubsetofOptions.add(new SelectOption(objSub.Indicator_Full_Name__c,objSub.Indicator_Full_Name__c));} 
            }
        }
        system.debug('***SubsetofOptions'+SubsetofOptions); 
        System.Debug('Exiting fillCatalogIndicator');
    }
    
    /**********************************************************************************************
    Purpose: Fill Catalog Indicator to add as Standard Indicator
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void fillCatalogIndicator(){
        System.Debug('Entering fillCatalogIndicator');  
        mapCatalogIndicator = new Map<Id,Indicator__c>
        ([
            Select id,Name,Type_of_Data__c,Full_Name_En__c,Reporting_Frequency__c,Disaggregated_Name__c,Is_Disaggregated__c,Target_Accumulation__c from Indicator__c 
            Where Catalog_Module__c =: strCatalogModuleId
            And Indicator_Type__c = 'Coverage/Output' 
            And Full_Name_En__c != null And Type_of_Data__c != null
                And Id Not IN (Select Indicator__c 
                From Grant_Indicator__c 
                Where Indicator_Type__c =: 'Coverage/Output'
                and Parent_Module__c =: strModuleId)
        ]);
        CatalogIndicatorOptions = new List<SelectOption>();
        CatalogIndicatorOptions.add(new SelectOption('','--None--'));
        if(mapCatalogIndicator!=null && mapCatalogIndicator.size() > 0){
            for(Indicator__c objInd : mapCatalogIndicator.values()){
                 if(objInd.Is_Disaggregated__c == true){
                    CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Disaggregated_Name__c));
                    }else{
                  CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Full_Name_En__c));} 
            }
        }
        System.Debug('Exiting fillCatalogIndicator');
    }
    
    /********* V.Singh method to show history button */
    
     //Display History
    Public Integer intHistoryIndicator {get;set;}
    Public void ShowHistoryPopup(){
        intHistoryIndicator = integer.valueof(apexpages.currentpage().getparameters().get('HistoryIndiIndex'));
        system.debug('hh:'+intHistoryIndicator);
        if(intHistoryIndicator!= null){
            APIname = 'Grant_Indicator__c';
            //APITitle = 'History of :';
            
            lstGrantIndicatorResult[intHistoryIndicator].blnHistory = true;
            system.debug('Bln:'+ lstGrantIndicatorResult[intHistoryIndicator].blnHistory);
            
        }
        
   
    }
     public void HidePopupHistory()
    {  
        
        if (intHistoryIndicator > -1) {
           lstGrantIndicatorResult[intHistoryIndicator].blnHistory = false;
        }
    }
    //History Popup Close
    
    public void ChangeFreq(){
    	System.debug('**Inside report Freq');
    if(strReportFreq == 'Based on Reporting Frequency'){
    	Set<ID> setPrID = new Set<Id>();
        if(lstPeriods==null) lstPeriods = new List<Period__c>();
        lstPeriods = [select id,name, Start_Date__c, End_Date__c, Start_Date_Short__c 
                    from Period__c 
                    where Implementation_Period__c  =: strImplementationPeriodId And Flow_to_GrantIndicator__c = false
                    Order by Start_Date__c asc];
        System.Debug('Entering fillPeriods');
        List<Period__c> lstPr = [select id,name, Start_Date__c, End_Date__c, Start_Date_Short__c 
                    from Period__c 
                    where Implementation_Period__c  =: strImplementationPeriodId And Flow_to_GrantIndicator__c = true
                    Order by Start_Date__c asc];
        for(Period__c pr : lstPr){
        setPrID.add(pr.Id);
        }
        List<Result__c> lstResDel = [Select Id from Result__c where Period__c in: setPrID];
        delete lstResDel;
        
        objStandardGrantIndicatorResult= new GrantIndicatorResult();
        objStandardGrantIndicatorResult.lstResults = new List<Result__c>();
        Result__c objResult;
        
        if(lstPeriods!=null && lstPeriods.size()>0){
            for(Period__c objPeriod : lstPeriods){
                objResult = new Result__c();
                objResult.Period__c = objPeriod.ID ;
                objStandardGrantIndicatorResult.lstResults.add(objResult);
            }
        } 
        }else{
        	Set<ID> setPrID = new Set<Id>();
        if(lstPeriods==null) lstPeriods = new List<Period__c>();
        lstPeriods = [select id,name, Start_Date__c, End_Date__c, Start_Date_Short__c 
                    from Period__c 
                    where Implementation_Period__c  =: strImplementationPeriodId And Flow_to_GrantIndicator__c = true
                    Order by Start_Date__c asc];
        System.Debug('Entering fillPeriods');
        List<Period__c> lstPr = [select id,name, Start_Date__c, End_Date__c, Start_Date_Short__c 
                    from Period__c 
                    where Implementation_Period__c  =: strImplementationPeriodId And Flow_to_GrantIndicator__c = false
                    Order by Start_Date__c asc];
       for(Period__c pr : lstPr){
        setPrID.add(pr.Id);
        }
        System.Debug('**setPrID'+setPrID);
        List<Result__c> lstResDel = [Select Id from Result__c where Period__c in: setPrID];
        System.Debug('**lstResDel'+lstResDel);
        delete lstResDel;
        objStandardGrantIndicatorResult= new GrantIndicatorResult();
        objStandardGrantIndicatorResult.lstResults = new List<Result__c>();
        Result__c objResult;
        
        if(lstPeriods!=null && lstPeriods.size()>0){
            for(Period__c objPeriod : lstPeriods){
                objResult = new Result__c();
                objResult.Period__c = objPeriod.ID ;
                objStandardGrantIndicatorResult.lstResults.add(objResult);
            }
        } 
        }
        
    } 
    /**********************************************************************************************
    Purpose: Fill list of Periods to maintain related results of indicator
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Private void fillPeriods(){
        System.Debug('Exiting fillPeriods');
        
        if(lstPeriods==null) lstPeriods = new List<Period__c>();
        lstPeriods = [select id,name, Start_Date__c, End_Date__c, Start_Date_Short__c 
                    from Period__c 
                    where Implementation_Period__c  =: strImplementationPeriodId And Flow_to_GrantIndicator__c = false
                    Order by Start_Date__c asc];
        System.Debug('Entering fillPeriods');
        
    }
    
    /**********************************************************************************************
    Purpose: Fill list of Periods to maintain related results of indicator
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Private Void fillGrantIndicatorResult(){
        System.Debug('Entering fillPeriods');
        lstGrantIndicatorResult = new List<GrantIndicatorResult>();
        GrantIndicatorResult objGrantIndicatorResult;
        if(lstPeriods!=null && lstPeriods.size()>0){                   
            List<Grant_Indicator__c> lstGrantIndicators = [select id, name,Indicator_Type__c,Comments__c,
                                Target_Area__c, LFA_Comments__c, Country_Team_Comments__c, Sub_National_Area__c, Tied_To__c, Indicator__c, Baseline_numerator__c ,Baseline_Denominator__c, Baseline_Value__c,
                                Baseline_Year__c ,Baseline_Sources__c, Indicator_Full_Name__c, Is_Disaggregated__c, Disaggregated_Name__c,Subset_Of__c, Data_Type__c,Target_Accumulation__c,Component__c,Decimal_Places__c,Reporting_Frequency__c,Indicator__r.Reporting_Frequency__c,Standard_or_Custom__c,
                                (
                                    select id,name,Period__r.Period_Number__c,Period__r.Start_Date__c, Period__r.Start_Date_Short__c, Target_Denominator__c,Target_Numerator__c,Target__c,Comments__c,LFA_Comments__c,Country_Team_Comments__c
                                    from Results__r 
                                    where Period__c IN: lstPeriods
                                    order by Period__r.Start_Date__c asc
                                )
                                from Grant_Indicator__c 
                                where Indicator_Type__c =: 'Coverage/Output'
                                and Parent_Module__c =: strModuleId and Is_IP_Coverage_Indicator__c = true
                                order by Indicator_Number__c]; 
            system.debug('Query List '+lstGrantIndicators +' Module Id** '+strModuleId);
            List<Grant_Indicator__feed> lstIndicatorfeed= [select id,ParentID from Grant_Indicator__feed where parentId IN: lstGrantIndicators];
            Map<ID,Integer> IndicatorsWithFeedItem = new Map<ID,Integer>();
            for(Grant_Indicator__feed objIndiWithFeed: lstIndicatorfeed){
                if(IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)==null){
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,1);
                }else{
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)+1);
                }
            }
                                 
                                
            for(Grant_Indicator__c objGI : lstGrantIndicators){
                objGrantIndicatorResult = new GrantIndicatorResult();
                objGrantIndicatorResult.blnIndicatorDisplay  = true;
                objGrantIndicatorResult.blndisplaySave= false;                
                objGrantIndicatorResult.objGrantIndicator = objGI;
                objGrantIndicatorResult.lstResults = objGI.Results__r;
                if(objGI.Results__r!=null && objGI.Results__r.size()>0){
                    objGrantIndicatorResult.strAssumptions = objGI.Results__r[0].Comments__c;  
                    objGrantIndicatorResult.strLFAComments=objGI.Results__r[0].LFA_Comments__c; 
                    objGrantIndicatorResult.strCountryTeamComments=objGI.Results__r[0].Country_Team_Comments__c;           
                }
                if(IndicatorsWithFeedItem.get(objGI.ID)!=null){
                        objGrantIndicatorResult.blnHasPost = true;                     
                        objGrantIndicatorResult.intPostCount = IndicatorsWithFeedItem.get(objGI.ID);                     
                }
                
                //TCS: 29/09/2014 Added for disaggregation
                                
                objGrantIndicatorResult.CNTarget = [select Id, Indicator_Full_Name__c,Data_Type__c, Above_Indicative_Denominator1__c,Above_Indicative_Denominator2__c,Decimal_Places__c,Spanish_Name__c ,Russian_Name__c,French_Name__c,
                                                    Above_Indicative_Denominator3__c,Above_Indicative_Denominator4__c,
                                                    Above_Indicative_Numerator1__c,Above_Indicative_Numerator2__c,
                                                    Above_Indicative_Numerator3__c,Above_Indicative_Numerator4__c,
                                                    Above_Indicative_Percent1__c,Above_Indicative_Percent2__c,Above_Indicative_Percent3__c,
                                                    Above_Indicative_Percent4__c,Indicative_Denominator1__c,Indicative_Denominator2__c,
                                                    Indicative_Denominator3__c,Indicative_Denominator4__c,IndicativeNumerator1__c,
                                                    IndicativeNumerator2__c,IndicativeNumerator3__c,IndicativeNumerator4__c,
                                                    Indicative_Percent1__c,Indicative_Percent2__c,Indicative_Percent3__c,Indicative_Percent4__c,Comments__c,Country_Team_Comments__c,LFA_Comments__c,Subset_Of__c,Reporting_Frequency__c,Indicator__r.Reporting_Frequency__c,Standard_or_Custom__c                                 
                                                    from Grant_Indicator__c
                                                    Where Id =: objGI.Id
                                                    limit 1];
                                                    
                lstGrantIndicatorResult.add(objGrantIndicatorResult);
            }
        }
        System.Debug('Exiting fillPeriods List'+lstGrantIndicatorResult);
    }
    
    /**********************************************************************************************
    Purpose: Sets a New Custom Grant Indicator with Result per Period to be filled by user to save
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Private void AddNewCustomGrantIndicatorResult(){
        System.Debug('Entering AddNewCustomGrantIndicatorResult');
        if(lstGrantIndicatorResult==null) lstGrantIndicatorResult = new List<GrantIndicatorResult>();
        objCustomGrantIndicatorResult= new GrantIndicatorResult();
        objCustomGrantIndicatorResult.blnIndicatorDisplay  = true;
        objCustomGrantIndicatorResult.blndisplaySave= false; 
        objCustomGrantIndicatorResult.objGrantIndicator = new Grant_Indicator__c(Parent_Module__c = strModuleId,Indicator_Type__c = 'Coverage/Output',Component__c = strComponent);
        //objCustomGrantIndicatorResult.strAssumptions ='';
        //objCustomGrantIndicatorResult.strCountryTeamComments ='';
        //objCustomGrantIndicatorResult.strLFAComments ='';
        objCustomGrantIndicatorResult.lstResults = new List<Result__c>();
        Result__c objResult;
        if(lstPeriods!=null && lstPeriods.size()>0){
            for(Period__c objPeriod : lstPeriods){
                objResult = new Result__c();
                objResult.Period__c = objPeriod.ID ;
                objCustomGrantIndicatorResult.lstResults.add(objResult);
            }
        }
        System.Debug('Exiting AddNewCustomGrantIndicatorResult');
    }
    
    /**********************************************************************************************
    Purpose: Sets a New Standard Grant Indicator with Result per Period to be filled by user to save
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Private void AddNewStandardGrantIndicatorResult(){
        System.Debug('Entering AddNewStandardGrantIndicatorResult');
        if(lstGrantIndicatorResult==null) lstGrantIndicatorResult = new List<GrantIndicatorResult>();
        objStandardGrantIndicatorResult= new GrantIndicatorResult();
        objStandardGrantIndicatorResult.blnIndicatorDisplay  = true;
        objStandardGrantIndicatorResult.blndisplaySave= false;        
        objStandardGrantIndicatorResult.objGrantIndicator = new Grant_Indicator__c(Parent_Module__c = strModuleId,Indicator_Type__c = 'Coverage/Output');
        //objStandardGrantIndicatorResult.strAssumptions ='';
        //objStandardGrantIndicatorResult.strCountryTeamComments ='';
        //objStandardGrantIndicatorResult.strLFAComments ='';
        objStandardGrantIndicatorResult.lstResults = new List<Result__c>();
        Result__c objResult;
        if(lstPeriods!=null && lstPeriods.size()>0){
            for(Period__c objPeriod : lstPeriods){
                objResult = new Result__c();
                objResult.Period__c = objPeriod.ID ;
                objStandardGrantIndicatorResult.lstResults.add(objResult);
            }
        } 
        System.Debug('Exiting AddNewStandardGrantIndicatorResult');       
    }
    
    /**********************************************************************************************
    Purpose: Sets boolean flags to edit Grant Indicator and Result per period
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void EditGrantIndicatorResult(){
        System.Debug('Entering EditGrantIndicatorResult');
        System.Debug('Parameters[0] EditIndiIndex = '+apexpages.currentpage().getparameters().get('EditIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('EditIndiIndex'));
        
         
        GrantIndicatorResult objGrantIndicatorResultTemp = new GrantIndicatorResult();
        //objGrantIndicatorResultTemp.blnIndicatorDisplay = lstGrantIndicatorResult[intIndexIndicator].blnIndicatorDisplay;
        objGrantIndicatorResultTemp.blndisplaySave = lstGrantIndicatorResult[intIndexIndicator].blndisplaySave;
        objGrantIndicatorResultTemp.blnIndicatorDisplay = false;
        strSubIndicatorExist = lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Subset_Of__c;
        objGrantIndicatorResultTemp.objGrantIndicator = lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.clone(true);
        //objGrantIndicatorResultTemp.strAssumptions = lstGrantIndicatorResult[intIndexIndicator].strAssumptions;
        //objGrantIndicatorResultTemp.strCountryTeamComments = lstGrantIndicatorResult[intIndexIndicator].strCountryTeamComments;
        //objGrantIndicatorResultTemp.strLFAComments = lstGrantIndicatorResult[intIndexIndicator].strLFAComments;
        objGrantIndicatorResultTemp.lstResults = new List<Result__c>();
        if(lstGrantIndicatorResult[intIndexIndicator].lstResults.size()!=0){
        objGrantIndicatorResultTemp.lstResults.addall(lstGrantIndicatorResult[intIndexIndicator].lstResults);
        }
            if(lstGrantIndicatorResult[intIndexIndicator].lstResults.size()==0){
        Result__c objResult;
        if(lstPeriods!=null && lstPeriods.size()>0){
            for(Period__c objPeriod : lstPeriods){
                objResult = new Result__c();
                objResult.Period__c = objPeriod.ID ;
                objResult.Indicator__c = objGrantIndicatorResultTemp.objGrantIndicator.id;
                insert objResult;
               System.debug('*****objResult'+objResult);
               objGrantIndicatorResultTemp.lstResults.add(objResult);
               lstGrantIndicatorResult[intIndexIndicator].lstResults.add(objResult);
            }
          //lstGrantIndicatorResult.add(objResult);  
        } 
        
        }
        
        //objGrantIndicatorResultTemp.lstResults = new List<Result__c>();
        //if(lstGrantIndicatorResult[intIndexIndicator].lstResults.size()!=0){
        //objGrantIndicatorResultTemp.lstResults.addall(lstGrantIndicatorResult[intIndexIndicator].lstResults);
        //}
        objGrantIndicatorResultTemp.blnHasPost = lstGrantIndicatorResult[intIndexIndicator].blnHasPost;
        objGrantIndicatorResultTemp.intPostCount = lstGrantIndicatorResult[intIndexIndicator].intPostCount;
        mapGIIdTowrap.put(objGrantIndicatorResultTemp.objGrantIndicator.id,objGrantIndicatorResultTemp);
        lstGrantIndicatorResult[intIndexIndicator].blnIndicatorDisplay = false;
        lstGrantIndicatorResult[intIndexIndicator].blndisplaySave = true;
        blnEditMode = true;
        System.debug('*****Outside If of Edit'+lstGrantIndicatorResult[intIndexIndicator].lstResults.size());
        //fillGrantIndicatorResult();
        
        System.Debug('Exiting EditGrantIndicatorResult');
          /********Added to populate reporting frequency as per Catalog indicator on create***********/
            //Indicator__c objCatalogIndicator = lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicator__c;
            AllRPFreqOption =  new List<Selectoption>();
            String lstStr = lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicator__r.Reporting_Frequency__c; 
            system.debug('***lstStr'+lstStr); 
            List<String> lstNewStr = new List<String>();
             
           
            AllRPFreqOption.add(new SelectOption('', '-- None --'));
            if(lstStr!=null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Standard_or_Custom__c == 'Standard'){
            lstNewStr = lstStr.split(';');
            system.debug('***lstNewStr'+lstNewStr);
            for(String f : lstNewStr){
                AllRPFreqOption.add(new SelectOption(f,f));
            }
            }else{
            FillFreOpCust();
            }
            system.debug('***AllRPFreqOption'+AllRPFreqOption);
    }
    /**********************************************************************************************
    Purpose: Resets boolean flags to cancel Grant Indicator and Result per period from edit
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void CancelGrantIndicatorResult(){
        System.Debug('Entering CancelGrantIndicatorResult');
        System.Debug('Parameters[0] CancelIndiIndex = '+apexpages.currentpage().getparameters().get('CancelIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('CancelIndiIndex'));
        String GIid = lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.id;
        lstGrantIndicatorResult[intIndexIndicator] = new GrantIndicatorResult();
        lstGrantIndicatorResult[intIndexIndicator] = mapGIIdTowrap.get(GIid);
        lstGrantIndicatorResult[intIndexIndicator].blnIndicatorDisplay = true;
        lstGrantIndicatorResult[intIndexIndicator].blndisplaySave = false;
        blnEditMode = false;
        System.Debug('Exiting CancelGrantIndicatorResult');
    }
    
    /**********************************************************************************************
    Purpose: Resets boolean flags to cancel Grant Indicator and Result per period from edit
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void DeleteGrantIndicatorResult(){
        System.Debug('Entering DeleteGrantIndicatorResult');
        System.Debug('Parameters[0] DeleteIndiIndex = '+apexpages.currentpage().getparameters().get('DeleteIndiIndex'));
        Integer intDeleteIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('DeleteIndiIndex'));
        if(intDeleteIndexIndicator != null){
            List<Grant_Indicator__c> lstIndicatorToDelete = new List<Grant_Indicator__c>();
            GrantIndicatorResult objGrantIndicatorResult = lstGrantIndicatorResult[intDeleteIndexIndicator];
            if(objGrantIndicatorResult.objGrantIndicator.Id != null){
                if(objGrantIndicatorResult.lstResults !=null){
                    List<Result__c> lstResultToDelete = new List<Result__c>();
                    for(Result__c objResult : objGrantIndicatorResult.lstResults){
                        if(objResult.id!=null){
                            lstResultToDelete.add(objResult);
                        }
                    }
                    delete lstResultToDelete;
                }
                delete lstGrantIndicatorResult[intDeleteIndexIndicator].objGrantIndicator;
            }
            lstGrantIndicatorResult.remove(intDeleteIndexIndicator);
            
            List<Grant_Indicator__c> lstIndicatorToUpdate = [Select Id,Indicator_number__c From Grant_Indicator__c 
                                                Where Indicator_number__c >: intDeleteIndexIndicator 
                                                And Indicator_Type__c = 'Coverage/Output'
                                                And Parent_Module__c =: strModuleId];
            if(lstIndicatorToUpdate.size() > 0){
                for(Grant_Indicator__c objGi : lstIndicatorToUpdate){
                    objGi.Indicator_number__c = objGi.Indicator_number__c - 1;
                }
                Update lstIndicatorToUpdate;
            }
            
            
            blnConfirmIndicatorDelete = false;
            fillCatalogIndicator();
        }
        System.Debug('Exiting DeleteGrantIndicatorResult');
    }
    
    /**********************************************************************************************
    Purpose: Save Grant Indicator Result object after editing
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void SaveGrantIndicatorResult(){
        System.Debug('Entering SaveGrantIndicatorResult');
        System.Debug('Parameters[0] SaveIndiIndex = '+apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        system.debug('****strSubIndicatorExist'+strSubIndicatorExist);
        if(intIndexIndicator != null){
            if(mapGIIdTowrap.ContainsKey(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.id)){
                mapGIIdTowrap.remove(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.id);
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Subset_of__c = strSubIndicatorExist;
                //lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Reporting_Frequency__c = strReportFreq;
            }
            update lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator;
            for(Result__c objResult: lstGrantIndicatorResult[intIndexIndicator].lstResults){
                //objResult.Comments__c=lstGrantIndicatorResult[intIndexIndicator].strAssumptions;
               // objResult.LFA_Comments__c = lstGrantIndicatorResult[intIndexIndicator].strLFAComments;
                //objResult.Country_Team_Comments__c = lstGrantIndicatorResult[intIndexIndicator].strCountryTeamComments;
            }
            update lstGrantIndicatorResult[intIndexIndicator].lstResults;
        }
        lstGrantIndicatorResult[intIndexIndicator].blnIndicatorDisplay = true;
        lstGrantIndicatorResult[intIndexIndicator].blndisplaySave = false;
        blnEditMode = false;
        System.Debug('Exiting SaveGrantIndicatorResult');
    }
    
    Public void CreateIndicatorOnSelectCatalog(){
        System.debug('**Inside Create'+strSelectedIndicator);
        if(String.isBlank(strSelectedIndicator) == false){
            AddNewStandardGrantIndicatorResult();
            Indicator__c objCatalogIndicator = MapCatalogIndicator.get(strSelectedIndicator);
            objStandardGrantIndicatorResult.objGrantIndicator.Standard_or_Custom__c = 'Standard';
            objStandardGrantIndicatorResult.objGrantIndicator.Indicator__c = objCatalogIndicator.Id;
            objStandardGrantIndicatorResult.objGrantIndicator.Is_Disaggregated__c = objCatalogIndicator.Is_Disaggregated__c;
            objStandardGrantIndicatorResult.objGrantIndicator.Disaggregated_Name__c =  objCatalogIndicator.Disaggregated_Name__c;
            if(objCatalogIndicator.Is_Disaggregated__c == true){
                objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Full_Name__c = objCatalogIndicator.Disaggregated_Name__c;
            }
            else{
                objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Full_Name__c = objCatalogIndicator.Full_Name_En__c;/*Full_Name_En__c;*/
            }
            objStandardGrantIndicatorResult.objGrantIndicator.Data_Type__c = objCatalogIndicator .Type_of_Data__c;
            objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Type__c = 'Coverage/Output';
            objStandardGrantIndicatorResult.objGrantIndicator.Component__c = strComponent;
            objStandardGrantIndicatorResult.objGrantIndicator.Target_Accumulation__c = objCatalogIndicator .Target_Accumulation__c;
            /********Added to populate reporting frequency as per Catalog indicator on create***********/
            AllRPFreqOption =  new List<Selectoption>();
            String lstStr = objCatalogIndicator.Reporting_Frequency__c; 
            system.debug('***lstStr'+lstStr); 
            List<String> lstNewStr = new List<String>();
            lstNewStr = lstStr.split(';');
            system.debug('***lstNewStr'+lstNewStr);  
            Schema.DescribeFieldResult fieldResult = Indicator__c.Reporting_Frequency__c.getDescribe();
            AllRPFreqOption.add(new SelectOption('', '-- None --'));
            
            for(String f : lstNewStr){
                AllRPFreqOption.add(new SelectOption(f,f));
            }
            system.debug('***AllRPFreqOption'+AllRPFreqOption);          
            //TCS 01/10/2014: Added for Disaggregation
                    lstwrapDAGIndicator = new List<wrapDAGIndicator>();
                    if(objCatalogIndicator.Is_Disaggregated__c) {                    
                    lstDAGIndicators = new List<Catalog_Disaggregated__c>();
                    ICategory = '';                                                                             
                    lstDAGIndicators = [Select Disaggregation_Category__c, Disaggregation_Value__c from Catalog_Disaggregated__c where Catalog_Indicator__c =: objCatalogIndicator.Id order by Disaggregation_Category__c];
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
                        objWrapDAGIndicator.GDAGIndicator.Component__c = strComponent;                                              
                        lstwrapDAGIndicator.add(objWrapDAGIndicator);
                    }     }
        }
       
    }
    
    Public void SaveStandardIndicator(){
        Integer SaveStdIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveStdIndicator'));
        objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Number__c = SaveStdIndicator;
        objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Type__c = 'Coverage/Output';
        objStandardGrantIndicatorResult.objGrantIndicator.Is_IP_Coverage_Indicator__c = true;
        objStandardGrantIndicatorResult.objGrantIndicator.Component__c = strComponent;
         system.debug('****strReportFreq'+strReportFreq);
        //objStandardGrantIndicatorResult.objGrantIndicator.Reporting_Frequency__c = strReportFreq;
        system.debug('****strSubIndicator'+strSubIndicator);
        objStandardGrantIndicatorResult.objGrantIndicator.Subset_of__c = strSubIndicator;
        system.debug('List of Indicator Saved** '+objStandardGrantIndicatorResult.objGrantIndicator);
        insert objStandardGrantIndicatorResult.objGrantIndicator;
        
        //TCS 01/10/2014: Added for Disaggregation            
            if(lstwrapDAGIndicator.size() > 0) {                
                for(wrapDAGIndicator objWrap : lstwrapDAGIndicator) {                   
                    objWrap.GDAGIndicator.Grant_Indicator__c = objStandardGrantIndicatorResult.objGrantIndicator.Id;                    
                    system.debug('###Indicator Id :' +objStandardGrantIndicatorResult.objGrantIndicator.Id);
                    Grant_Disaggregated__c gd = new Grant_Disaggregated__c();
                    gd = objWrap.GDAGIndicator;                 
                    insert gd;
                }               
            }
        for(Result__c objResult: objStandardGrantIndicatorResult.lstResults){
             //objResult.Comments__c=objStandardGrantIndicatorResult.strAssumptions;
             //objResult.LFA_Comments__c=objStandardGrantIndicatorResult.strLFAComments;
             //objResult.Country_Team_Comments__c =objStandardGrantIndicatorResult.strCountryTeamComments;
            objResult.Indicator__c = objStandardGrantIndicatorResult.objGrantIndicator.ID;
            }        
        insert objStandardGrantIndicatorResult.lstResults;
        lstGrantIndicatorResult.add(objStandardGrantIndicatorResult);
        fillCatalogIndicator();
        
    }
    Public void SaveCustomIndicator(){
        Integer SaveCusIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveCusIndicator'));
        objCustomGrantIndicatorResult.objGrantIndicator.Indicator_Number__c = SaveCusIndicator;
        objCustomGrantIndicatorResult.objGrantIndicator.Indicator_Type__c = 'Coverage/Output';
        objCustomGrantIndicatorResult.objGrantIndicator.Is_IP_Coverage_Indicator__c = true;
        objCustomGrantIndicatorResult.objGrantIndicator.Component__c = strComponent;
        system.debug('****strSubIndicator'+strSubIndicator);
        objCustomGrantIndicatorResult.objGrantIndicator.Subset_of__c = strSubIndicator;
        //objCustomGrantIndicatorResult.objGrantIndicator.Reporting_Frequency__c = strReportFreq;
        insert objCustomGrantIndicatorResult.objGrantIndicator;
        for(Result__c objResult: objCustomGrantIndicatorResult.lstResults){
             //objResult.Comments__c=objCustomGrantIndicatorResult.strAssumptions;
            // objResult.LFA_Comments__c=objStandardGrantIndicatorResult.strLFAComments;
            // objResult.Country_Team_Comments__c =objStandardGrantIndicatorResult.strCountryTeamComments;
            objResult.Indicator__c = objCustomGrantIndicatorResult.objGrantIndicator.ID;
        }
        insert objCustomGrantIndicatorResult.lstResults;
        lstGrantIndicatorResult.add(objCustomGrantIndicatorResult);
        AddNewCustomGrantIndicatorResult();
        
    }
    public void getPageText(){
        system.debug('#####strLanguage->'+strLanguage);
        if(String.IsBlank(strLanguage) == false){
            Map<String,String> MultiLingualTextMap;
            MultiLingualTextMap = GILanguage.getMultiLingualText(strLanguage,'GrantCoverageOutputIndicator');
            if(MultiLingualTextMap !=null && MultiLingualTextMap.size()>0)
            {
                strHome = MultiLingualTextMap.get('GOHome');
                strModules = MultiLingualTextMap.get('GOmodules');
                strHealthProducts = MultiLingualTextMap.get('GOhealthproducts');
                strDetailedBudget = MultiLingualTextMap.get('GOdetailedbudget');
                strClosepanelLabel = MultiLingualTextMap.get('GOClosePanelLabel');
                strOutputIndicators = MultiLingualTextMap.get('GOOutputIndicators');
                strCoverage = MultiLingualTextMap.get('GOCoverage');
                strResponsiblePrincipalRecipient = MultiLingualTextMap.get('GOResponsibleprincipalrecipient');
                strTargetArea = MultiLingualTextMap.get('GOstrTargetArea'); //remove Tied to
                strNum = MultiLingualTextMap.get('GONum');
                strDen = MultiLingualTextMap.get('GODen');
                strTargetAssumptions = MultiLingualTextMap.get('GOTargetassumptions');
                strAddAnIndicator = MultiLingualTextMap.get('GOAddanindicator');
                strSeeCNTargets = MultiLingualTextMap.get('GOSeeCNtargets');
                strConceptNotes = MultiLingualTextMap.get('GOConceptNotes');
                strSummary = MultiLingualTextMap.get('GOSummary');
                strGoalsAndImpactIndicators = MultiLingualTextMap.get('GOLabel');
                strGuidance = MultiLingualTextMap.get('GOGuidance');
                strEdit = MultiLingualTextMap.get('GIbtnEdit');
                strDelete = MultiLingualTextMap.get('GIbtnDelete');
                strSelectCatalogIndicator = MultiLingualTextMap.get('GObtnSelectCatalogIndicator');
                strBaseline = MultiLingualTextMap.get('GOBaseline');
                strYear = MultiLingualTextMap.get('GOYear');
                strSource = MultiLingualTextMap.get('GOSource');
                //strComments = MultiLingualTextMap.get('GOComments');
                //strCountryTeamComments = MultiLingualTextMap.get('GOCountryTeamComments');
                //strLFAComments = MultiLingualTextMap.get('GOLFAComments');
                strTargets = MultiLingualTextMap.get('GOTargets');
                strTiedTo = MultiLingualTextMap.get('GOTiedTo');
                strDataType = MultiLingualTextMap.get('GODataType');
                strSave = MultiLingualTextMap.get('GIbtnSave');
                strCancel = MultiLingualTextMap.get('GIbtnCancel');
                strAreYouSure = MultiLingualTextMap.get('GOAreyousure');
                strIndicatorDeleted = MultiLingualTextMap.get('GOIndicatorWillDeleted');
                strAddStandardIndicator = MultiLingualTextMap.get('GIbtnAddStandardIndicator');
                strAddCustomIndicator = MultiLingualTextMap.get('GIbtnAddCustomIndicator');
                strSelect = MultiLingualTextMap.get('GIbtnSelect');
            }
        }
    }
    //TCS 25/08/2014 Created for Profile Access 
    public void checkProfile(){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GrantCoverageOutputIndicator' and Profile_Name__c =: profilename];
        system.debug(checkpage);
        for (Profile_Access_Setting__c check : checkpage){
            if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
            if(check.Salesforce_Item__c == 'Edit')blnEdit = true;
            if(check.Salesforce_Item__c == 'Delete')blnDelete = true;
            if(check.Salesforce_Item__c == 'Comments')blnComments = true;
            if(check.Salesforce_Item__c == 'CT Comments')blnCTComments = true;
            if(check.Salesforce_Item__c == 'LFA Comments')blnLFAComments = true;
            if(check.Salesforce_Item__c == 'PR Comments')blnPRComments = true;
            if(check.Salesforce_Item__c == 'Add Standard Indicator')blnAddStdInd = true;
            if(check.Salesforce_Item__c == 'Add Custom Indicator')blnAddCustInd = true;
            if(check.Salesforce_Item__c == 'Discussion')blnDiscussion = true;
            if(check.Salesforce_Item__c == 'History')blnHistory = true;
        }
      }
      
    Public Class GrantIndicatorResult{
        Public Boolean blnIndicatorDisplay  {get;set;}
        Public Boolean blndisplaySave {get;set;}
        
        Public Grant_Indicator__c CNTarget {get;set;}
        Public Grant_Indicator__c objGrantIndicator {get;set;}
        Public String strAssumptions {get;set;}
        Public String strCountryTeamComments {get;set;}
        Public String strLFAComments {get;set;}
        Public List<Result__c> lstResults {get;set;}
        Public Boolean blnHasPost {get;set;}
        Public Integer intPostCount {get;set;}
        
        Public Boolean blnHistory  {get;set;}
        
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

Public Class wrapDAGIndicator { //TCS 01/10/2014: Added for Disaggregation
        public String ICategory;
        public Grant_Disaggregated__c GDAGIndicator {get;set;}
        public String Disaggregation_Value {get;set;}
        public String Disaggregation_Category {get;set;}
    }
   /* Public void fetchCNTargets() {
        system.debug('***strSelectedGID'+strSelectedGID);
        CNTarget = [select id, Indicator_Full_Name__c,Data_Type__c, Above_Indicative_Denominator1__c,Above_Indicative_Denominator2__c,Decimal_Places__c,Spanish_Name__c ,Russian_Name__c,French_Name__c,
                                Above_Indicative_Denominator3__c,Above_Indicative_Denominator4__c,
                                Above_Indicative_Numerator1__c,Above_Indicative_Numerator2__c,
                                Above_Indicative_Numerator3__c,Above_Indicative_Numerator4__c,
                                Above_Indicative_Percent1__c,Above_Indicative_Percent2__c,Above_Indicative_Percent3__c,
                                Above_Indicative_Percent4__c,Indicative_Denominator1__c,Indicative_Denominator2__c,
                                Indicative_Denominator3__c,Indicative_Denominator4__c,IndicativeNumerator1__c,
                                IndicativeNumerator2__c,IndicativeNumerator3__c,IndicativeNumerator4__c,
                                Indicative_Percent1__c,Indicative_Percent2__c,Indicative_Percent3__c,Indicative_Percent4__c,Comments__c,Country_Team_Comments__c,LFA_Comments__c                                
                                from Grant_Indicator__c 
                                where Id =: strSelectedGID limit 1];     
        system.debug('CNTARGET:' +CNTarget);
    }*/
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