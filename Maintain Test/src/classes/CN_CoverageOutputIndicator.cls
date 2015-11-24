/*********************************************************************************
* Controller Class: CoverageOutputIndicator
* DateCreated:  08/26/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - page is opened from a button on the CN ModulesInterventions page
* - creates Result/Target record for each Grant_Indicator__c records where 
    Type = 'Coverage/Output' and Module =: master module__c.Module
----------------------------------------------------------------------------------
* Unit Test: TestCoverageOutputIndicator
----------------------------------------------------------------------------------
* History:
* - VERSION  DATE            DETAIL FEATURES
    1.0      08/26/2013      INITIAL DEVELOPMENT   
*********************************************************************************/
Public Class CN_CoverageOutputIndicator{ 
    Public String strModuleId {get;set;}
    Public String strParentModuleId;
    Public String strCatalogModuleId {get;set;}
   // Public String strImplementationPeriodId {get;set;} 
    Public String strCNId {get;set;}    
    Public String strGuidanceId {get;set;}   
    Public List<GrantIndicatorResult> lstGrantIndicatorResult{get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public List<Period__c> lstPeriods{get;set;}
    Public GrantIndicatorResult objCustomGrantIndicatorResult{get;set;}
    Public GrantIndicatorResult objStandardGrantIndicatorResult{get;set;}
    Public List<GrantIndicatorResult> lstobjStandardGrantIndicatorResult{get;set;}
    Public Boolean blnExpandSection {get;set;}
    Public String PRName {get;set;}
    Public List<SelectOption> PROptions {get;set;}
    Public List<String> SelectedPR {get;set;}
    Public List<SelectOption> CatalogIndicatorOptions {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public Map<ID,Indicator__c> MapCatalogIndicator;
    Public Boolean blnConfirmIndicatorDelete {get;set;}
    Public Map<Id,GrantIndicatorResult> mapGIIdTowrap {get;set;}
    Public Map<Id,Id> mapGrantModuleToGIP {get;set;}
    Public Map<Id,Principal_Recipient__c> mapPrincipleRecipientToPRid {get;set;}
    //For Multi-Country/Regional
    Public List<Country__c> lstCountries {get;set;}
    Public Boolean blnMultiCountryRegional {get;set;}
    Public List<SelectOption> IndicatorCountryOptions {get;set;}
    Public String CNComponent {get;set;}
    Public Boolean blnReadOnly {get;set;}
    Public Set<Id> setPRIds;
    
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
    Public String APIname {get;set;}
    Public String APITitle {get;set;}
    Public String strGrantImpPeriod {get;set;}
    
    //TCS 11/09/2014 Defined variable for Profile Access
    public String strStatus ;
    public Boolean blnExternalPro {get; set;}
    public Boolean blnCustInd {get; set;}
    public Boolean blnStndInd {get; set;}
    public Boolean blnEdit {get; set;}
    public Boolean blnDelete {get; set;}
    public Boolean blnComments {get; set;}
    public Boolean chkNumAndPer {get; set;}
    public Boolean chkOther {get; set;}
    Public String UserLanguage {get;set;}
    public String PageURL;
    /**********************************************************************************************
    Purpose: Initialize the constructor method  
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    public CN_CoverageOutputIndicator(ApexPages.StandardController controller) {
        UserLanguage = System.UserInfo.getLanguage();
        PageURL = ApexPages.currentPage().getUrl();
        //blnReadOnly = CheckProfile.checkProfile();
        setPRIds = new Set<Id>();
        mapGrantModuleToGIP = new Map<Id,Id>();
        System.Debug('Entering GrantCoverageOutputIndicator'); 
        strModuleId = Apexpages.currentpage().getparameters().get('id');
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Coverage & Output Indicators'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
        if(String.IsBlank(strModuleId) == false){
            for(Grant_Intervention__c gi : [Select Implementation_Period__r.Principal_Recipient__c from Grant_Intervention__c where CN_Intervention__r.Module_rel__c = :strModuleId]){
                setPRIds.add(gi.Implementation_Period__r.Principal_Recipient__c);
            }
            
                       
            
            List<Module__c> lstModule = [Select ID, Concept_Note__c, Concept_Note__r.Component__c, Name,Implementation_Period__c,Language__c,
                                        Catalog_Module__c, Concept_Note__r.Status__c,Concept_Note__r.Language__c,
                                         (Select id,Implementation_Period__c,Implementation_Period__r.Principal_Recipient__c,
                                          Implementation_Period__r.Principal_Recipient__r.Name from Modules1__r 
                                          where Implementation_Period__c!=null 
                                          and Implementation_Period__r.Principal_Recipient__c!=null 
                                          and Implementation_Period__r.Principal_Recipient__r.Name!=null)
                                        From Module__c 
                                        Where Id =: strModuleId Limit 1];
            if(lstModule!=null && lstModule.size() > 0) {
                strCNId = lstModule[0].Concept_Note__c;
                 //                                 INC014758
                 strStatus = lstModule[0].Concept_Note__r.Status__c ;//used in checkProfile function
                 checkProfile();
                //Added lstModule[0].Concept_Note__r.Status__c =='Reviewed and OK for TRP/GAC1' Condition for disabling the page
               /* if(lstModule[0].Concept_Note__r.Status__c == 'Submitted to the Global Fund' && CheckProfile.checkProfileGF()==false){
                    blnReadOnly = true; 
                 }else if(lstModule[0].Concept_Note__r.Status__c == 'Not yet submitted'){
                    blnReadOnly = CheckProfile.checkProfile();
                 } */
                 
                CNComponent = lstModule[0].Concept_Note__r.Component__c;
                PROptions = new List<SelectOption>();
                PROptions.add(new SelectOption('','--'+Label.None+'--'));
                Set<id> setPRIds = new Set<Id>();
                strGrantImpPeriod = lstModule[0].Implementation_Period__c;
                if(lstModule[0].Modules1__r!=null && lstModule[0].Modules1__r.size()>0){
                    for(Module__c objMod : lstModule[0].Modules1__r){
                        mapGrantModuleToGIP.put(objMod.Id,objMod.Implementation_Period__c);  //Added by MM 2014-07-11
                        if(setPRIds.contains(objMod.Implementation_Period__r.Principal_Recipient__c) == false){
                            PROptions.add(new SelectOption(objMod.Id,objMod.Implementation_Period__r.Principal_Recipient__r.Name));
                            setPRIds.add(objMod.Implementation_Period__r.Principal_Recipient__c);
                        }
                    }
                    strParentModuleId = lstModule[0].Modules1__r[0].id;
                }
                strCatalogModuleId = lstModule[0].Catalog_Module__c;
                if(lstModule[0].Concept_Note__r.Language__c != null) strLanguage = lstModule[0].Concept_Note__r.Language__c;
                else strLanguage = 'ENGLISH';
                system.debug('str language'+ strLanguage);
                /* Added new code for language  start *******
                strLanguage = 'ENGLISH';
                if(System.UserInfo.getLanguage() == 'fr'){
                strLanguage = 'FRENCH'; }
                if(System.UserInfo.getLanguage() == 'ru'){
                strLanguage = 'RUSSIAN'; }
                if(System.UserInfo.getLanguage() == 'es'){
                strLanguage = 'SPANISH'; }
                 end ************************************** */
                
                lstPages = new List<Page__c>();   
                lstModules = new List<Module__c>();
                blnMultiCountryRegional = false;
                if(strCNId !=null){  
                    lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c, Concept_Note__r.Concept_Note_Type__c From Page__c Where Concept_Note__c =: strCNId Order by Order__c];
                    lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Concept_Note__c =: strCNId Order by Name];
                    if(lstPages.size() > 0){
                        if(lstPages[0].Concept_note__r.Concept_Note_Type__c == 'Regional' || lstPages[0].Concept_note__r.Concept_Note_Type__c == 'Multi-Country'){
                            blnMultiCountryRegional = true; } else { blnMultiCountryRegional = false;}
                    }
                    SetCountries();
                }
                
          
                blnConfirmIndicatorDelete = false;
                getPageText();
                fillPeriods();
                fillGrantIndicatorResult();
                fillCatalogIndicator();
                
                AddNewCustomGrantIndicatorResult();
            }
        }        
        mapGIIdTowrap = new Map<Id,GrantIndicatorResult>();
        System.Debug('Exiting GrantCoverageOutputIndicator'); 
        
    }

   
    /**********************************************************************************************
    Purpose: Fill Catalog Indicator to add as Standard Indicator
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void fillCatalogIndicator(){
        System.Debug('Entering fillCatalogIndicator'); 
         
        if(!blnMultiCountryRegional) { 
            mapCatalogIndicator = new Map<Id,Indicator__c>
            ([
                Select id,Name,Type_of_Data__c,Full_Name_En__c,Target_Accumulation__c,Indicator_Type__c,Russian_Name__c,French_Name__c, Spanish_Name__c,Is_Disaggregated__c, Disaggregated_Name__c from Indicator__c 
                Where Catalog_Module__c =: strCatalogModuleId
                And Indicator_Type__c = 'Coverage/Output' 
                And Full_Name_En__c != null And Type_of_Data__c != null
                   
            ]); }
        else {
          if(strModuleId != null){ 
            mapCatalogIndicator = new Map<Id,Indicator__c>
            ([
                Select id,Name,Type_of_Data__c,Full_Name_En__c,Target_Accumulation__c,Indicator_Type__c,Russian_Name__c,French_Name__c, Spanish_Name__c, Is_Disaggregated__c,Disaggregated_name__c,
                (Select Id, Grant_Implementation_Period__r.Principal_Recipient__c from Grant_Indicators__r where Parent_Module__r.CN_Module__c =: strModuleId)
                from Indicator__c 
                Where Catalog_Module__c =: strCatalogModuleId
                And Indicator_Type__c = 'Coverage/Output' 
                And Full_Name_En__c != null And Type_of_Data__c != null
            ]); }
          }           
            
        CatalogIndicatorOptions = new List<SelectOption>();
        CatalogIndicatorOptions.add(new SelectOption('','--'+label.None+'--'));       
        if(mapCatalogIndicator!=null && mapCatalogIndicator.size() > 0){
            for(Indicator__c objInd : mapCatalogIndicator.values()){
                if(objInd.Full_Name_En__c != null && objInd.Is_Disaggregated__c != true){
                    CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Full_Name_En__c));
                }
                else if((objInd.Full_Name_En__c != null || objInd.Disaggregated_name__c != null) && objInd.Is_Disaggregated__c == true){
                    CatalogIndicatorOptions.add(new SelectOption(objInd.id,objInd.Disaggregated_name__c));
                }
            }
        }
        System.Debug('Exiting fillCatalogIndicator');
    }
    
    /**********************************************************************************************
    Purpose: fill countries to which this indicator has not been assigned
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    
    Public void SetCountries(){
        System.Debug('Entering SetCountries'); 
        lstCountries = new List<Country__c>();
        
        lstCountries = [Select id,Name from Country__c 
                                    WHERE Id IN (Select Country__c from Multi_Country__c
                                                 Where Concept_Note__c = : strCNId)];

        IndicatorCountryOptions = new List<SelectOption>();
        IndicatorCountryOptions.add(new SelectOption('','--'+label.None+'--'));
        if(lstCountries.size() > 0){
            for(Country__c objCountry : lstCountries){
                IndicatorCountryOptions.add(new SelectOption(objCountry.id,objCountry.Name));
            }
        }
        System.Debug('Exiting SetCountries'); 
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
                    where Concept_Note__c  =: strCNId
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
        System.Debug('Entering fillGrantIndicatorResult');
        lstGrantIndicatorResult = new List<GrantIndicatorResult>();
        GrantIndicatorResult objGrantIndicatorResult;
       // if(lstPeriods!=null && lstPeriods.size()>0){                   
            List<Grant_Indicator__c> lstGrantIndicators = [select id, name,Indicator_Type__c,Comments__c,Comments_French__c,Comments_Spanish__c,Comments_Russian__c,
                                Target_Area__c,Sub_National_Area__c, LFA_Comments__c, Country_Team_Comments__c,Tied_To__c, Indicator__c, Baseline_numerator__c ,Baseline_Denominator__c, Baseline_Value__c,
                                Baseline_Year__c ,Baseline_Sources__c, Indicator_Full_Name__c, Data_Type__c,Target_Accumulation__c,Grant_Implementation_Period__r.Principal_Recipient__c,
                                Above_Indicative_Denominator1__c,Above_Indicative_Denominator2__c,Decimal_Places__c,Spanish_Name__c ,Russian_Name__c,French_Name__c,Is_Disaggregated__c, Disaggregated_Name__c,
                                Above_Indicative_Denominator3__c,Above_Indicative_Denominator4__c,
                                Above_Indicative_Numerator1__c,Above_Indicative_Numerator2__c,
                                Above_Indicative_Numerator3__c,Above_Indicative_Numerator4__c,
                                Above_Indicative_Percent1__c,Above_Indicative_Percent2__c,Above_Indicative_Percent3__c,
                                Above_Indicative_Percent4__c,Indicative_Denominator1__c,Indicative_Denominator2__c,
                                Indicative_Denominator3__c,Indicative_Denominator4__c,IndicativeNumerator1__c,
                                IndicativeNumerator2__c,IndicativeNumerator3__c,IndicativeNumerator4__c,
                                Indicative_Percent1__c,Indicative_Percent2__c,Indicative_Percent3__c,Indicative_Percent4__c,
                                Parent_module__r.Implementation_period__r.Principal_recipient__r.Name, Country__c, Country__r.Name,Component__c, Standard_or_Custom__c,Is_IP_Coverage_Indicator__c
                                from Grant_Indicator__c 
                                where Indicator_Type__c =: 'Coverage/Output'
                                and Parent_Module__r.CN_Module__c =: strModuleId and Is_IP_Coverage_Indicator__c =false 
                                order by Indicator_Number__c]; 
                                //Parent_Module__r.CN_Module__c
            
            List<Grant_Indicator__feed> lstIndicatorfeed= [select id,ParentID from Grant_Indicator__feed where parentId IN: lstGrantIndicators];
            Map<ID,Integer> IndicatorsWithFeedItem = new Map<ID,Integer>();
            for(Grant_Indicator__feed objIndiWithFeed: lstIndicatorfeed){
                if(IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)==null){
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,1);
                }else{
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)+1);
                }
            }
                                 
            system.debug('lstGrantIndicators.size = '+lstGrantIndicators.size());
            for(Grant_Indicator__c objGI : lstGrantIndicators){
                objGrantIndicatorResult = new GrantIndicatorResult();
                objGrantIndicatorResult.blnIndicatorDisplay  = true;
                objGrantIndicatorResult.blndisplaySave= false;                
                objGrantIndicatorResult.objGrantIndicator = objGI;
                system.debug('objgi value'+ objGI);
                system.debug('strLanguage 2'+strLanguage);
                if(strLanguage == 'FRENCH'){
                    objGrantIndicatorResult.strAssumptions = objGI.Comments_French__c;
                }else if(strLanguage == 'RUSSIAN'){
                    objGrantIndicatorResult.strAssumptions = objGI.Comments_Russian__c;
                }else if(strLanguage == 'SPANISH'){
                    objGrantIndicatorResult.strAssumptions = objGI.Comments_Spanish__c;
                }else{
                    objGrantIndicatorResult.strAssumptions = objGI.Comments__c;               
                }
                system.debug('Assumption:'+ objGrantIndicatorResult.strAssumptions);
                objGrantIndicatorResult.PRName = objGI.Parent_module__r.Implementation_period__r.Principal_recipient__r.Name;
                if(IndicatorsWithFeedItem.get(objGI.ID)!=null){
                    objGrantIndicatorResult.blnHasPost = true;                     
                    objGrantIndicatorResult.intPostCount = IndicatorsWithFeedItem.get(objGI.ID);                     
                }
               
                lstGrantIndicatorResult.add(objGrantIndicatorResult);
            }
            system.debug('lstGrantIndicatorResult.size = '+lstGrantIndicatorResult.size());
       // }
        System.Debug('Exiting fillGrantIndicatorResult');
        system.debug('List:'+lstGrantIndicatorResult);
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
        objCustomGrantIndicatorResult.objGrantIndicator = new Grant_Indicator__c(Indicator_Type__c = 'Coverage/Output',Component__c = CNComponent,Decimal_Places__c = '0');
        objCustomGrantIndicatorResult.strAssumptions ='';
        objCustomGrantIndicatorResult.strCountryTeamComments ='';
        objCustomGrantIndicatorResult.strLFAComments ='';
      
        
       
        System.Debug('Exiting AddNewCustomGrantIndicatorResult');
    }
    
    /**********************************************************************************************
    Purpose: Sets a New Standard Grant Indicator with Result per Period to be filled by user to save
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    @TestVisible
    Private void AddNewStandardGrantIndicatorResult(){
    chkNumAndPer=false;
    chkOther=false;
        System.Debug('Entering AddNewStandardGrantIndicatorResult');
        lstobjStandardGrantIndicatorResult=new List<GrantIndicatorResult>();
        if(lstGrantIndicatorResult==null) lstGrantIndicatorResult = new List<GrantIndicatorResult>();
        System.Debug('**PROptions'+PROptions);
       if(MapCatalogIndicator.containskey(strSelectedIndicator) && MapCatalogIndicator.get(strSelectedIndicator) != null){
            Indicator__c objCatalogIndicator = MapCatalogIndicator.get(strSelectedIndicator);
       for(String PRModuleid:SelectedPR)
        {
                objStandardGrantIndicatorResult= new GrantIndicatorResult();
                objStandardGrantIndicatorResult.objGrantIndicator = new Grant_Indicator__c(Indicator_Type__c = 'Coverage/Output', Component__c = CNComponent,Decimal_Places__c = '0');
                objStandardGrantIndicatorResult.objGrantIndicator.Standard_or_Custom__c = 'Standard';
                objStandardGrantIndicatorResult.objGrantIndicator.Indicator__c = objCatalogIndicator .Id;
                objStandardGrantIndicatorResult.objGrantIndicator.Decimal_Places__c = '0';
                objStandardGrantIndicatorResult.objGrantIndicator.French_Name__c = objCatalogIndicator.French_Name__c;
                objStandardGrantIndicatorResult.objGrantIndicator.Russian_Name__c = objCatalogIndicator.Russian_Name__c;
                objStandardGrantIndicatorResult.objGrantIndicator.Spanish_Name__c = objCatalogIndicator.Spanish_Name__c;
                if(objCatalogIndicator.Is_Disaggregated__c != true){
                    objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Full_Name__c = objCatalogIndicator.Full_Name_En__c;
                    }   
                else{
                        objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Full_Name__c = objStandardGrantIndicatorResult.objGrantIndicator.Disaggregated_Name__c = objCatalogIndicator.Disaggregated_Name__c;
                        objStandardGrantIndicatorResult.objGrantIndicator.Is_Disaggregated__c = objCatalogIndicator.Is_Disaggregated__c;
                    }
                objStandardGrantIndicatorResult.objGrantIndicator.Data_Type__c = objCatalogIndicator.Type_of_Data__c;
        if( objStandardGrantIndicatorResult.objGrantIndicator.Data_Type__c=='Number and Percent')
        {
        chkNumAndPer=true;
        }else
        {
        chkOther=true;
        }
                objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Type__c = 'Coverage/Output';
                objStandardGrantIndicatorResult.objGrantIndicator.Target_Accumulation__c = objCatalogIndicator .Target_Accumulation__c;
                objStandardGrantIndicatorResult.objGrantIndicator.Component__c = CNComponent;
                objStandardGrantIndicatorResult.blnIndicatorDisplay  = true;
                objStandardGrantIndicatorResult.blndisplaySave= false;        
                objStandardGrantIndicatorResult.strAssumptions ='';
                objStandardGrantIndicatorResult.strCountryTeamComments ='';
                objStandardGrantIndicatorResult.strLFAComments ='';
                objStandardGrantIndicatorResult.PRName=PRModuleid;
                System.Debug('**objStandardGrantIndicatorResult.objGrantIndicator**'+objStandardGrantIndicatorResult.objGrantIndicator.Data_Type__c);
                for(SelectOption sel : PROptions ){
                System.Debug('**sel'+sel.getLabel());   
                System.Debug('**sel'+objStandardGrantIndicatorResult.PRName);
                if(sel.getValue() == PRModuleid)
                    objStandardGrantIndicatorResult.PRNameMultiselectPR = sel.getLabel();
                    }
                System.Debug('**sel'+objStandardGrantIndicatorResult.PRNameMultiselectPR);
                lstobjStandardGrantIndicatorResult.add(objStandardGrantIndicatorResult);
                
                    }
        
        System.Debug('**Selected PR size **'+SelectedPR.size());
        System.Debug('**lstobjStandardGrantIndicatorResult'+lstobjStandardGrantIndicatorResult);
        System.Debug('Exiting AddNewStandardGrantIndicatorResult');       
        
         }
          System.Debug('**chkNumAndPer'+chkNumAndPer);
          System.Debug('**chkOther'+chkOther);
       }
      
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
    //History Popup Close
    public void HidePopupHistory()
    {  
        
        if (intHistoryIndicator > -1) {
           lstGrantIndicatorResult[intHistoryIndicator].blnHistory = false;
        }
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
        objGrantIndicatorResultTemp.blnIndicatorDisplay = lstGrantIndicatorResult[intIndexIndicator].blnIndicatorDisplay;
        objGrantIndicatorResultTemp.blndisplaySave = lstGrantIndicatorResult[intIndexIndicator].blndisplaySave;
        objGrantIndicatorResultTemp.objGrantIndicator = lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.clone(true);
        objGrantIndicatorResultTemp.strAssumptions = lstGrantIndicatorResult[intIndexIndicator].strAssumptions;
        objGrantIndicatorResultTemp.strCountryTeamComments = lstGrantIndicatorResult[intIndexIndicator].strCountryTeamComments;
        objGrantIndicatorResultTemp.strLFAComments = lstGrantIndicatorResult[intIndexIndicator].strLFAComments;
        system.debug('Inedit:'+ objGrantIndicatorResultTemp.strAssumptions);
        for(SelectOption sel : PROptions){
            if(sel.getlabel() == lstGrantIndicatorResult[intIndexIndicator].PRname){
                //lstGrantIndicatorResult[intIndexIndicator].PRname = sel.getvalue();
                lstGrantIndicatorResult[intIndexIndicator].PRname = sel.getvalue();
                system.debug('Name:'+sel.getvalue());
                system.debug('NameL:'+sel.getlabel());
            }
        }
        
        objGrantIndicatorResultTemp.PRName = lstGrantIndicatorResult[intIndexIndicator].PRName;
        
        objGrantIndicatorResultTemp.blnHasPost = lstGrantIndicatorResult[intIndexIndicator].blnHasPost;
        objGrantIndicatorResultTemp.intPostCount = lstGrantIndicatorResult[intIndexIndicator].intPostCount;
        mapGIIdTowrap.put(objGrantIndicatorResultTemp.objGrantIndicator.id,objGrantIndicatorResultTemp);
        lstGrantIndicatorResult[intIndexIndicator].blnIndicatorDisplay = false;
        lstGrantIndicatorResult[intIndexIndicator].blndisplaySave = true;
        System.Debug('Exiting EditGrantIndicatorResult');
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
        
        for(SelectOption sel : PROptions){
            if(sel.getvalue() == lstGrantIndicatorResult[intIndexIndicator].PRname){
                lstGrantIndicatorResult[intIndexIndicator].PRname = sel.getlabel();
            }
        }
        
        //objGrantIndicatorResultTemp.PRName = lstGrantIndicatorResult[intIndexIndicator].PRName;
        if(PROptions!=null && PROptions.size()==1)
    {
    PROptions.add(new SelectOption('','--'+Label.None+'--'));
    }
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
    if(PROptions!=null && PROptions.size()==1)
    {
    PROptions.add(new SelectOption('','--'+Label.None+'--'));
    }
    if(SelectedPR!=null && SelectedPR.size() > 0) {
        System.debug('INside CancelSelectedPR');
        SelectedPR.clear();
    } 
        if(intDeleteIndexIndicator != null){
            List<Grant_Indicator__c> lstIndicatorToDelete = new List<Grant_Indicator__c>();
            GrantIndicatorResult objGrantIndicatorResult = lstGrantIndicatorResult[intDeleteIndexIndicator];
            if(objGrantIndicatorResult.objGrantIndicator.Id != null){
                
                delete lstGrantIndicatorResult[intDeleteIndexIndicator].objGrantIndicator;
            }
            lstGrantIndicatorResult.remove(intDeleteIndexIndicator);
            
            List<Grant_Indicator__c> lstIndicatorToUpdate = [Select Id,Indicator_number__c,Indicator_Type__c,Decimal_Places__c From Grant_Indicator__c 
                                                Where Indicator_number__c >: intDeleteIndexIndicator 
                                                And Indicator_Type__c = 'Coverage/Output'
                                                And Parent_Module__r.CN_Module__c =: strModuleId];
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
        if(intIndexIndicator != null){
            if(mapGIIdTowrap.ContainsKey(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.id)){
                mapGIIdTowrap.remove(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.id);
            }
            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Baseline_numerator__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Baseline_Denominator__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Baseline_Denominator__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Baseline_Value__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Baseline_numerator__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Baseline_Denominator__c))*100);//.round(roundingMode.HALF_UP);
                    
            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator1__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator1__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator1__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Percent1__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator1__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator1__c))*100);//.round(roundingMode.HALF_UP);

            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator2__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator2__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator2__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Percent2__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator2__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator2__c))*100);//.round(roundingMode.HALF_UP);

            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator3__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator3__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator3__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Percent3__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator3__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator3__c))*100);//.round(roundingMode.HALF_UP);

            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator4__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator4__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator4__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Percent4__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.IndicativeNumerator4__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Indicative_Denominator4__c))*100);//.round(roundingMode.HALF_UP);

                
            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator1__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator1__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator1__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Percent1__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator1__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator1__c))*100);//.round(roundingMode.HALF_UP);

                
            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator2__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator2__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator2__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Percent2__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator2__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator2__c))*100);//.round(roundingMode.HALF_UP);

            
            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator3__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator3__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator3__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Percent3__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator3__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator3__c))*100);//.round(roundingMode.HALF_UP);

            if(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator4__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator4__c != null && lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator4__c != 0)
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Percent4__c = (((lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Numerator4__c)/(lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Above_Indicative_Denominator4__c))*100);//.round(roundingMode.HALF_UP);

            if(String.isBlank(lstGrantIndicatorResult[intIndexIndicator].PRname) == false){
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Parent_Module__c = lstGrantIndicatorResult[intIndexIndicator].PRname;
            }
            system.debug('ass:'+lstGrantIndicatorResult[intIndexIndicator].strAssumptions);
            if(strLanguage == 'FRENCH'){
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Comments_French__c = lstGrantIndicatorResult[intIndexIndicator].strAssumptions;
            }else if(strLanguage == 'RUSSIAN'){
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Comments_Russian__c = lstGrantIndicatorResult[intIndexIndicator].strAssumptions;
            }else if(strLanguage == 'SPANISH'){
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Comments_Spanish__c = lstGrantIndicatorResult[intIndexIndicator].strAssumptions;
            }else{
                lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator.Comments__c = lstGrantIndicatorResult[intIndexIndicator].strAssumptions;              
            }
            update lstGrantIndicatorResult[intIndexIndicator].objGrantIndicator;
           system.debug('after:'+lstGrantIndicatorResult[intIndexIndicator].strAssumptions); 
        }
        for(SelectOption sel : PROptions){
            if(sel.getValue() == lstGrantIndicatorResult[intIndexIndicator].PRname){
                lstGrantIndicatorResult[intIndexIndicator].PRname = sel.getlabel();
            }
        }
        lstGrantIndicatorResult[intIndexIndicator].blnIndicatorDisplay = true;
        lstGrantIndicatorResult[intIndexIndicator].blndisplaySave = false;
        fillGrantIndicatorResult();
        System.Debug('Exiting SaveGrantIndicatorResult');
    }
    
    Public void CreateIndicatorOnSelectCatalog(){
        
        /*TCS Development Team*/
       
    System.debug('***strSelectedIndicator**'+strSelectedIndicator);
    List<Grant_Indicator__c> selectedGrantIndicator = [Select Id,Name,Indicator__c,Grant_Intervention__c,Grant_Intervention__r.Implementation_period__c,Decimal_Places__c From Grant_Indicator__c where Parent_module__c!='' AND Indicator__c =:strSelectedIndicator];
    System.debug('***strSelectedIndicator**'+selectedGrantIndicator);   
    System.debug('***SelectedPR**'+SelectedPR);     

        if(String.isBlank(strSelectedIndicator) == false){
            AddNewStandardGrantIndicatorResult();
            
            /*if(MapCatalogIndicator.containskey(strSelectedIndicator) && MapCatalogIndicator.get(strSelectedIndicator) != null){
                Indicator__c objCatalogIndicator = MapCatalogIndicator.get(strSelectedIndicator);
                objStandardGrantIndicatorResult.objGrantIndicator.Standard_or_Custom__c = 'Standard';
                objStandardGrantIndicatorResult.objGrantIndicator.Indicator__c = objCatalogIndicator .Id;
                objStandardGrantIndicatorResult.objGrantIndicator.Decimal_Places__c = '0';
                objStandardGrantIndicatorResult.objGrantIndicator.French_Name__c = objCatalogIndicator.French_Name__c;
                objStandardGrantIndicatorResult.objGrantIndicator.Russian_Name__c = objCatalogIndicator.Russian_Name__c;
                objStandardGrantIndicatorResult.objGrantIndicator.Spanish_Name__c = objCatalogIndicator.Spanish_Name__c;
                if(objCatalogIndicator.Is_Disaggregated__c != true){
                    objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Full_Name__c = objCatalogIndicator.Full_Name_En__c;
                }
                else{
                    objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Full_Name__c = objStandardGrantIndicatorResult.objGrantIndicator.Disaggregated_Name__c = objCatalogIndicator.Disaggregated_Name__c;
                    objStandardGrantIndicatorResult.objGrantIndicator.Is_Disaggregated__c = objCatalogIndicator.Is_Disaggregated__c;
                }
                objStandardGrantIndicatorResult.objGrantIndicator.Data_Type__c = objCatalogIndicator .Type_of_Data__c;
                objStandardGrantIndicatorResult.objGrantIndicator.Indicator_Type__c = 'Coverage/Output';
                objStandardGrantIndicatorResult.objGrantIndicator.Target_Accumulation__c = objCatalogIndicator .Target_Accumulation__c;
                objStandardGrantIndicatorResult.objGrantIndicator.Component__c = CNComponent;
            }*/
        }
    }
     Public void CreateIndicatorOnSelectCatalogPR(){
        System.debug('***strSelectedIndicator**'+strSelectedIndicator);
        for(integer i=0;i<PROptions.Size();i++)
        {
        String Strcontact='--';
        String selectedValue =Strcontact+label.None+Strcontact;
        if(PROptions[i].getlabel() == selectedValue)
        PROptions.remove(i);
        }
    }
    Public PageReference CancelSelectedPR(){
     if(SelectedPR!=null && SelectedPR.size() > 0) {
        System.debug('INside CancelSelectedPR');
        SelectedPR.clear();
        //return Null;
     } 
     if(PROptions!=null && PROptions.size()==1)
    {
    PROptions.add(new SelectOption('','--'+Label.None+'--'));
    }
        System.debug('***Selected PR list**'+SelectedPR);
        return Null;
    }
    
    Public pagereference SaveStandardIndicator(){
        List<GrantIndicatorResult> listofGrantIndicatorResult=new List<GrantIndicatorResult>(); 
        List<Grant_Indicator__c> listofGrantIndicator=new List<Grant_Indicator__c>(); 
        system.debug('lstobjStandardGrantIndicatorResult-->'+lstobjStandardGrantIndicatorResult);
        system.debug('lstobjStandardGrantIndicatorResult-->'+lstobjStandardGrantIndicatorResult.size());
        for(GrantIndicatorResult gir:lstobjStandardGrantIndicatorResult)
        {
        Integer SaveStdIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveStdIndicator'));
        gir.objGrantIndicator.Indicator_Number__c = SaveStdIndicator;
        gir.objGrantIndicator.Indicator_Type__c = 'Coverage/Output';
        gir.objGrantIndicator.Component__c = CNComponent;
        
        gir.objGrantIndicator.Parent_Module__c = gir.PRname;
        
        if(gir.objGrantIndicator.Baseline_numerator__c != null && gir.objGrantIndicator.Baseline_Denominator__c != null && gir.objGrantIndicator.Baseline_Denominator__c != 0)
            gir.objGrantIndicator.Baseline_Value__c = (((gir.objGrantIndicator.Baseline_numerator__c)/(gir.objGrantIndicator.Baseline_Denominator__c))*100);

        
        if(gir.objGrantIndicator.IndicativeNumerator1__c != null && gir.objGrantIndicator.Indicative_Denominator1__c != null && gir.objGrantIndicator.Indicative_Denominator1__c != 0)
            gir.objGrantIndicator.Indicative_Percent1__c = (((gir.objGrantIndicator.IndicativeNumerator1__c)/(gir.objGrantIndicator.Indicative_Denominator1__c))*100);//.round(roundingMode.HALF_UP);
     
        
        if(gir.objGrantIndicator.IndicativeNumerator2__c != null && gir.objGrantIndicator.Indicative_Denominator2__c != null && gir.objGrantIndicator.Indicative_Denominator2__c != 0)
            gir.objGrantIndicator.Indicative_Percent2__c = (((gir.objGrantIndicator.IndicativeNumerator2__c)/(gir.objGrantIndicator.Indicative_Denominator2__c))*100);//.round(roundingMode.HALF_UP);

             
        if(gir.objGrantIndicator.IndicativeNumerator3__c != null && gir.objGrantIndicator.Indicative_Denominator3__c != null && gir.objGrantIndicator.Indicative_Denominator3__c != 0)
            gir.objGrantIndicator.Indicative_Percent3__c = (((gir.objGrantIndicator.IndicativeNumerator3__c)/(gir.objGrantIndicator.Indicative_Denominator3__c))*100);//.round(roundingMode.HALF_UP);

            
        if(gir.objGrantIndicator.IndicativeNumerator4__c != null && gir.objGrantIndicator.Indicative_Denominator4__c != null && gir.objGrantIndicator.Indicative_Denominator4__c != 0)
            gir.objGrantIndicator.Indicative_Percent4__c = (((gir.objGrantIndicator.IndicativeNumerator4__c)/(gir.objGrantIndicator.Indicative_Denominator4__c))*100);//.round(roundingMode.HALF_UP);

            
        if(gir.objGrantIndicator.Above_Indicative_Numerator1__c != null && gir.objGrantIndicator.Above_Indicative_Denominator1__c != null && gir.objGrantIndicator.Above_Indicative_Denominator1__c != 0)
            gir.objGrantIndicator.Above_Indicative_Percent1__c = (((gir.objGrantIndicator.Above_Indicative_Numerator1__c)/(gir.objGrantIndicator.Above_Indicative_Denominator1__c))*100);//.round(roundingMode.HALF_UP);

        if(gir.objGrantIndicator.Above_Indicative_Numerator2__c != null && gir.objGrantIndicator.Above_Indicative_Denominator2__c != null && gir.objGrantIndicator.Above_Indicative_Denominator2__c != 0)
            gir.objGrantIndicator.Above_Indicative_Percent2__c = (((gir.objGrantIndicator.Above_Indicative_Numerator2__c)/(gir.objGrantIndicator.Above_Indicative_Denominator2__c))*100);//.round(roundingMode.HALF_UP);
      
        if(gir.objGrantIndicator.Above_Indicative_Numerator3__c != null && gir.objGrantIndicator.Above_Indicative_Denominator3__c != null && gir.objGrantIndicator.Above_Indicative_Denominator3__c != 0)
            gir.objGrantIndicator.Above_Indicative_Percent3__c = (((gir.objGrantIndicator.Above_Indicative_Numerator3__c)/(gir.objGrantIndicator.Above_Indicative_Denominator3__c))*100);//.round(roundingMode.HALF_UP);

            
        if(gir.objGrantIndicator.Above_Indicative_Numerator4__c != null && gir.objGrantIndicator.Above_Indicative_Denominator4__c != null && gir.objGrantIndicator.Above_Indicative_Denominator4__c != 0)
            gir.objGrantIndicator.Above_Indicative_Percent4__c = (((gir.objGrantIndicator.Above_Indicative_Numerator4__c)/(gir.objGrantIndicator.Above_Indicative_Denominator4__c))*100);//.round(roundingMode.HALF_UP);

        if(strLanguage == 'FRENCH'){
            gir.objGrantIndicator.Comments_French__c = gir.strAssumptions;
        }else if(strLanguage == 'RUSSIAN'){
            gir.objGrantIndicator.Comments_Russian__c = gir.strAssumptions;
        }else if(strLanguage == 'SPANISH'){
            gir.objGrantIndicator.Comments_Spanish__c = gir.strAssumptions;
        }else{
            gir.objGrantIndicator.Comments__c = gir.strAssumptions;              
        }
        
        //gir.objGrantIndicator.Grant_Implementation_Period__c = strGrantImpPeriod ;
        gir.objGrantIndicator.Grant_Implementation_Period__c = mapGrantModuleToGIP.get(gir.PRName);
    
        listofGrantIndicatorResult.add(gir);
        listofGrantIndicator.add(gir.objGrantIndicator);
        
        }
        system.debug('**listofGrantIndicator'+listofGrantIndicator);
        insert listofGrantIndicator;
        for(SelectOption sel : PROptions){
            if(sel.getValue() == objStandardGrantIndicatorResult.PRname){
                objStandardGrantIndicatorResult.PRname = sel.getlabel();
            }
        }
        
        lstGrantIndicatorResult.addAll(listofGrantIndicatorResult);
        fillCatalogIndicator();
        AddNewStandardGrantIndicatorResult();
        fillGrantIndicatorResult();
        if(SelectedPR!=null && SelectedPR.size() > 0) {
        SelectedPR.clear();
        }
    	//if(PROptions!=null && PROptions.size()==1)
    	//{
    	//PROptions.add(new SelectOption('','--'+Label.None+'--'));
    	//system.debug('###---PRoprtion after save'+PROptions);
    	//}
    	system.debug('###---PageURL'+PageURL);  
    	Pagereference pr = new Pagereference(PageURL);
        pr.setRedirect(true);
        return pr; 
     
    }
    Public void SaveCustomIndicator(){
        system.debug('###---call');
        Integer SaveCusIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveCusIndicator'));
        objCustomGrantIndicatorResult.objGrantIndicator.Indicator_Number__c = SaveCusIndicator;
        objCustomGrantIndicatorResult.objGrantIndicator.Parent_Module__c = objCustomGrantIndicatorResult.PRname;
        //strAssumptions
        if(strLanguage == 'FRENCH'){
                objCustomGrantIndicatorResult.objGrantIndicator.Comments_French__c = objCustomGrantIndicatorResult.strAssumptions;
            }else if(strLanguage == 'RUSSIAN'){
                objCustomGrantIndicatorResult.objGrantIndicator.Comments_Russian__c = objCustomGrantIndicatorResult.strAssumptions;
            }else if(strLanguage == 'SPANISH'){
                objCustomGrantIndicatorResult.objGrantIndicator.Comments_Spanish__c = objCustomGrantIndicatorResult.strAssumptions;
            }else{
                objCustomGrantIndicatorResult.objGrantIndicator.Comments__c = objCustomGrantIndicatorResult.strAssumptions;              
            }
        

        //if(objCustomGrantIndicatorResult.objGrantIndicator.Baseline_numerator__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Baseline_Denominator__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Baseline_Denominator__c != 0)
        //    objCustomGrantIndicatorResult.objGrantIndicator.Baseline_Value__c = (((objCustomGrantIndicatorResult.objGrantIndicator.Baseline_numerator__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Baseline_Denominator__c))*100);//.round(roundingMode.HALF_UP);

        if(objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator1__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator1__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator1__c != 0)
            objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Percent1__c = (((objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator1__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator1__c))*100);//.round(roundingMode.HALF_UP);

            
        if(objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator2__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator2__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator2__c != 0)
            objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Percent2__c = (((objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator2__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator2__c))*100);//.round(roundingMode.HALF_UP);

            
        if(objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator3__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator3__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator3__c != 0)
            objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Percent3__c = (((objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator3__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator3__c))*100);//.round(roundingMode.HALF_UP);

            
        if(objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator4__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator4__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator4__c != 0)
            objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Percent4__c = (((objCustomGrantIndicatorResult.objGrantIndicator.IndicativeNumerator4__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Indicative_Denominator4__c))*100);//.round(roundingMode.HALF_UP);

                
        if(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator1__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator1__c != null  && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator1__c != 0)
            objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Percent1__c = (((objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator1__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator1__c))*100);//.round(roundingMode.HALF_UP);

        if(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator2__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator2__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator2__c != 0)
            objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Percent2__c = (((objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator2__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator2__c))*100);//.round(roundingMode.HALF_UP);

            
        if(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator3__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator3__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator3__c != null)
            objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Percent3__c = (((objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator3__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator3__c))*100);//.round(roundingMode.HALF_UP);

            
        if(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator4__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator4__c != null && objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator4__c != 0)
            objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Percent4__c = (((objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Numerator4__c)/(objCustomGrantIndicatorResult.objGrantIndicator.Above_Indicative_Denominator4__c))*100);//.round(roundingMode.HALF_UP);
        
        //objCustomGrantIndicatorResult.objGrantIndicator.Grant_Implementation_Period__c = strGrantImpPeriod ;
        objCustomGrantIndicatorResult.objGrantIndicator.Grant_Implementation_Period__c = mapGrantModuleToGIP.get(objCustomGrantIndicatorResult.PRName);
        objCustomGrantIndicatorResult.objGrantIndicator.Standard_or_Custom__c = 'Custom';
        
        insert objCustomGrantIndicatorResult.objGrantIndicator;
        for(SelectOption sel : PROptions){
            if(sel.getValue() == objCustomGrantIndicatorResult.PRname){
                objCustomGrantIndicatorResult.PRname = sel.getlabel();
            }
        }
        lstGrantIndicatorResult.add(objCustomGrantIndicatorResult);
        AddNewCustomGrantIndicatorResult();
        fillGrantIndicatorResult();
    }
    public void getPageText(){
        /*system.debug('#####strLanguage->'+strLanguage);
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
                strComments = MultiLingualTextMap.get('GOComments');
                strCountryTeamComments = MultiLingualTextMap.get('GOCountryTeamComments');
                strLFAComments = MultiLingualTextMap.get('GOLFAComments');
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
        }*/
    }
    //TCS 11/09/2014 Added for giving Permission based on profile 
     public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CN_CoverageOutputIndicator' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets)];
      
      for (Profile_Access_Setting_CN__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Add Custom Indicator' && check.Status__c== strStatus)blnCustInd = true;
        if(check.Salesforce_Item__c == 'Add Standard Indicator' && check.Status__c== strStatus)blnStndInd = true;
         if(check.Salesforce_Item__c == 'Edit' && check.Status__c== strStatus)blnEdit = true;
         if(check.Salesforce_Item__c == 'Delete' && check.Status__c== strStatus)blnDelete = true;
         if(check.Salesforce_Item__c == 'Comments' && check.Status__c== strStatus)blnComments = true;
        }
    }
    
    
    Public Class GrantIndicatorResult{
        Public Boolean blnIndicatorDisplay  {get;set;}
        Public Boolean blndisplaySave {get;set;}
        Public String PRName {get;set;}
        Public Boolean blnHistory  {get;set;}
        Public Grant_Indicator__c objGrantIndicator {get;set;}
        Public String strAssumptions {get;set;}
        Public String strCountryTeamComments {get;set;}
        Public String strLFAComments {get;set;}
        Public List<Result__c> lstResults {get;set;}
        Public Boolean blnHasPost {get;set;}
        Public Integer intPostCount {get;set;}
        Public String PRNameMultiselectPR {get;set;}
    }
}