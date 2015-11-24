/*********************************************************************************
* Controller Class: GIMSelection
* Created by {DeveloperName}, Vera Consulting Services, DateCreated:  09/04/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Standard Controller = Module__c
* - creates Grant_Indicator__c records where Indicator_Type__c = Grant Implementation Measure
----------------------------------------------------------------------------------
* Unit Test: TestGrantCoverageOutputIndicator
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0      Name              09/04/2013      INITIAL DEVELOPMENT   
*********************************************************************************/
Public Class GIMSelection{ 
    Public String strModuleId {get;set;}
    Public String strImplementationPeriodId {get;set;}    
    Public List<GIMResult> lstGIMResult{get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public List<Period__c> lstPeriods{get;set;}
    Public GIMResult objCustomGIMResult{get;set;}
    Public GIMResult objStandardGIMResult {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public Boolean blnExpandSection {get;set;}
    
    Public List<SelectOption> GrantIntervention {get;set;}
    Public List<SelectOption> GrantInterventionGIM {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public Map<ID,Grant_Intervention__c> MapGIntervention;
    Public Boolean blnConfirmIndicatorDelete {get;set;}
    Public Map<Id,GIMResult> mapGIIdTowrap {get;set;}
    
    Public String strLanguage {get;set;}
    Public String strClosepanelLabel {get;set;}
    Public String strGIMSelection {get;set;}
    Public String strTargetAssumptions {get;set;}
    Public String strConceptNotes {get;set;}
    Public String strEdit {get;set;}
    Public String strDelete {get;set;}
    Public String strYear {get;set;}
    Public String strTargets {get;set;}
    Public String strSave {get;set;}
    Public String strCancel {get;set;}
    Public String strAreYouSure {get;set;}
    Public String strIndicatorDeleted {get;set;}
    Public String strSeeHelp {get;set;}
    Public String strGIMDescription{get;set;}
    Public String strDataSource {get;set;}
    Public String strIntervention {get;set;}
    Public String strYes {get;set;}
    Public String strTarget {get;set;}
    Public String strTotal {get;set;}
    Public String strTotalInterventionBudget {get;set;}
    Public String strTotalBudgetPercent{get;set;}
    Public String strDialogue {get;set;}
    Public String strClose {get;set;}
    Public String strAddGIM {get;set;}
    Public String strDescriptionReuiredMessage {get;set;}
    Public String strGIMInterventionRequiredMessage {get;set;}
    Public String strGuidanceId {get;set;}
    
    /**********************************************************************************************
    Purpose: Initialize the constructor method  
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    public GIMSelection(ApexPages.StandardController controller) {
        System.Debug('Entering GrantCoverageOutputIndicator'); 
        strModuleId = Apexpages.currentpage().getparameters().get('id');
        if(String.IsBlank(strModuleId) == false){
            List<Module__c> lstModule = [Select ID, Name, Implementation_Period__c,Language__c 
                                        From Module__c 
                                        Where Id =: strModuleId Limit 1];
            if(lstModule!=null && lstModule.size() > 0) {
                strImplementationPeriodId = lstModule[0].implementation_Period__c; 
                if(lstModule[0].Language__c != null) strLanguage = lstModule[0].Language__c;
                else strLanguage = 'ENGLISH';
                
                lstPages = new List<Page__c>();   
                lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId Order by Order__c];  
                lstModules = new List<Module__c>();   
                lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strImplementationPeriodID Order by Name]; 
                
                blnConfirmIndicatorDelete = false;
                
                fillGrantIntervention();
                getPageText();
                fillPeriods();
                fillGIMResult();                
                AddNewCustomGIMResult();
            }
        }        
        mapGIIdTowrap = new Map<Id,GIMResult>();
        System.Debug('Exiting GrantCoverageOutputIndicator'); 
        
         List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name =: label.Work_Plan_Tracking_Measures];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
                 
    }
        /**********************************************************************************************
    Purpose: Fill Grant Intervention to add as Standard Indicator
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void fillGrantIntervention(){
        System.Debug('Entering fillGrantIntervention');  
        MapGIntervention= new Map<Id,Grant_Intervention__c>
        ([
            Select id,Name,Y1_Total__c, Y2_Total__c, Y3_Total__c, Y4_Total__c,Total_Intervention_Budget__c, Implementation_Period__r.Total_Budget__c 
            From Grant_Intervention__c
            Where Module__c =: strModuleId 
            order by name asc
        ]);
        GrantIntervention = new List<SelectOption>();
        GrantInterventionGIM = new List<SelectOption>();
        GrantIntervention.add(new SelectOption('','--None--'));
        if(MapGIntervention!=null && MapGIntervention.size() > 0){
            for(Grant_Intervention__c objInd : MapGIntervention.values()){
                GrantIntervention.add(new SelectOption(objInd.id,objInd.Name));
                GrantInterventionGIM.add(new SelectOption(objInd.id,objInd.Name));
            }
        }
        System.Debug('Exiting fillGrantIntervention');
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
                    where Implementation_Period__c  =: strImplementationPeriodId
                    Order by Start_Date__c asc];
        System.Debug('Entering fillPeriods');
    }
    
    /**********************************************************************************************
    Purpose: Fill list of Periods to maintain related results of indicator
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Private Void fillGIMResult(){
        System.Debug('Entering fillPeriods');
        lstGIMResult = new List<GIMResult>();
        GIMResult objGIMResult;
        if(lstPeriods!=null && lstPeriods.size()>0){ 
        	               
            List<Grant_Indicator__c> lstGIMs = [select id, name,Indicator_Type__c,Comments__c,Grant_Intervention__c,
                                Target_Area__c, Indicator__c, Baseline_numerator__c ,Baseline_Denominator__c, Baseline_Value__c,
                                Baseline_Year__c ,Baseline_Sources__c,Data_Source__c, Indicator_Full_Name__c, Data_Type__c,
                                (
                                    select id,name,Period__r.Period_Number__c,Period__r.Start_Date__c, Period__r.Start_Date_Short__c, Target_Denominator__c,Target_Numerator__c,Target__c,Comments__c
                                    from Results__r 
                                    where Period__c IN: lstPeriods
                                    order by Period__r.Start_Date__c asc
                                )
                                from Grant_Indicator__c 
                                where Indicator_Type__c =: 'Grant Implementation Measure'
                                and Parent_Module__c =: strModuleId
                                and Grant_Intervention__c != null
                                order by Indicator_Number__c ]; 
            
            
            List<Grant_Indicator__feed> lstIndicatorfeed= [select id,ParentID from Grant_Indicator__feed where parentId IN: lstGIMs];
            Map<ID,Integer> IndicatorsWithFeedItem = new Map<ID,Integer>();
            for(Grant_Indicator__feed objIndiWithFeed: lstIndicatorfeed){
                if(IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)==null){
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,1);
                }else{
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)+1);
                }
            }
                         
            for(Grant_Indicator__c objGI : lstGIMs){
                objGIMResult = new GIMResult();
                objGIMResult.blnIndicatorDisplay  = true;
                objGIMResult.blndisplaySave= false;                
                objGIMResult.objGIM = objGI;
                objGIMResult.strIntervention=objGI.Grant_Intervention__c;
                if(MapGIntervention!=null){
                    objGIMResult.objGIntervention = MapGIntervention.get(objGI.Grant_Intervention__c);
                }
                objGIMResult.lstResults = objGI.Results__r;
                if(objGI.Results__r!=null && objGI.Results__r.size()>0){
                    objGIMResult.strAssumptions = objGI.Results__r[0].Comments__c;
                }
                if(IndicatorsWithFeedItem.get(objGI.ID)!=null){
                        objGIMResult.blnHasPost = true;                     
                        objGIMResult.intPostCount = IndicatorsWithFeedItem.get(objGI.ID);                     
                }
                lstGIMResult.add(objGIMResult);
            }
            
          
        }
     
        System.Debug('Exiting fillPeriods');
        // System.Debug('display'+ objGIMResult.blnIndicatorDisplay  );
    }
    
    /**********************************************************************************************
    Purpose: Sets a New Custom Grant Indicator with Result per Period to be filled by user to save
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Private void AddNewCustomGIMResult(){
        System.Debug('Entering AddNewCustomGIMResult');
        if(lstGIMResult==null) lstGIMResult = new List<GIMResult>();
        objCustomGIMResult= new GIMResult();
        objCustomGIMResult.blnIndicatorDisplay  = true;
        objCustomGIMResult.blndisplaySave= false; 
        objCustomGIMResult.objGIM = new Grant_Indicator__c(Parent_Module__c = strModuleId,Indicator_Type__c = 'Grant Implementation Measure');
        objCustomGIMResult.strAssumptions ='';
        objCustomGIMResult.lstResults = new List<Result__c>();
        Result__c objResult;
        if(lstPeriods!=null && lstPeriods.size()>0){
            for(Period__c objPeriod : lstPeriods){
                objResult = new Result__c();
                objResult.Period__c = objPeriod.ID ;
                objCustomGIMResult.lstResults.add(objResult);
            }
        }
        System.Debug('Exiting AddNewCustomGIMResult');
        //system.debug('display'+objCustomGIMResult.blnIndicatorDisplay);
             }
       
    /**********************************************************************************************
    Purpose: Sets a New Standard Grant Indicator with Result per Period to be filled by user to save
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    /*Private void AddNewStandardGIMResult(){
        System.Debug('Entering AddNewStandardGIMResult');
        if(lstGIMResult==null) lstGIMResult = new List<GIMResult>();
        objStandardGIMResult= new GIMResult();
        objStandardGIMResult.blnIndicatorDisplay  = true;
        objStandardGIMResult.blndisplaySave= false;        
        objStandardGIMResult.objGIM = new Grant_Indicator__c(Parent_Module__c = strModuleId);
        objStandardGIMResult.strAssumptions ='';
        objStandardGIMResult.lstResults = new List<Result__c>();
        Result__c objResult;
        if(lstPeriods!=null && lstPeriods.size()>0){
            for(Period__c objPeriod : lstPeriods){
                objResult = new Result__c();
                objResult.Period__c = objPeriod.ID ;
                objStandardGIMResult.lstResults.add(objResult);
            }
        } 
        System.Debug('Exiting AddNewStandardGIMResult');       
    }*/
    
    /**********************************************************************************************
    Purpose: Sets boolean flags to edit Grant Indicator and Result per period
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void EditGIMResult(){
        System.Debug('Entering EditGIMResult');
        System.Debug('Parameters[0] EditIndiIndex = '+apexpages.currentpage().getparameters().get('EditIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('EditIndiIndex'));
        
        GIMResult objGIMResultTemp = new GIMResult();
        objGIMResultTemp.objGIntervention = new Grant_Intervention__c();
        objGIMResultTemp.objGIM = new Grant_Indicator__c();
        objGIMResultTemp.objGIntervention= lstGIMResult[intIndexIndicator].objGIntervention.clone(true);
        objGIMResultTemp.objGIM= lstGIMResult[intIndexIndicator].objGIM.clone(true);
        objGIMResultTemp.blnIndicatorDisplay = lstGIMResult[intIndexIndicator].blnIndicatorDisplay;
        //system.debug('display'+ objGIMResultTemp.blnIndicatorDisplay);
        objGIMResultTemp.blndisplaySave = lstGIMResult[intIndexIndicator].blndisplaySave;
        objGIMResultTemp.strIntervention= lstGIMResult[intIndexIndicator].strIntervention;
        objGIMResultTemp.strAssumptions = lstGIMResult[intIndexIndicator].strAssumptions;
        objGIMResultTemp.lstResults = new List<Result__c>();
        objGIMResultTemp.lstResults.addall(lstGIMResult[intIndexIndicator].lstResults);
        objGIMResultTemp.blnHasPost = lstGIMResult[intIndexIndicator].blnHasPost;
        objGIMResultTemp.intPostCount= lstGIMResult[intIndexIndicator].intPostCount;
        mapGIIdTowrap.put(objGIMResultTemp.objGIntervention.id,objGIMResultTemp);
        
        lstGIMResult[intIndexIndicator].blnIndicatorDisplay = false;
        lstGIMResult[intIndexIndicator].blndisplaySave = true;
        System.Debug('Exiting EditGIMResult');
    }
    /**********************************************************************************************
    Purpose: Resets boolean flags to cancel Grant Indicator and Result per period from edit
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void CancelGIMResult(){
        System.Debug('Entering CancelGIMResult');
        System.Debug('Parameters[0] CancelIndiIndex = '+apexpages.currentpage().getparameters().get('CancelIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('CancelIndiIndex'));
        String strGIID = lstGIMResult[intIndexIndicator].objGIntervention.id;
        lstGIMResult[intIndexIndicator] = new GIMResult();
        lstGIMResult[intIndexIndicator] = mapGIIdTowrap.get(strGIID);
        lstGIMResult[intIndexIndicator].blnIndicatorDisplay = true;
        lstGIMResult[intIndexIndicator].blndisplaySave = false;
        System.Debug('Exiting CancelGIMResult');
    }
    
    /**********************************************************************************************
    Purpose: Resets boolean flags to cancel Grant Indicator and Result per period from edit
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void DeleteGIMResult(){
        System.Debug('Entering DeleteGIMResult');
        System.Debug('Parameters[0] DeleteIndiIndex = '+apexpages.currentpage().getparameters().get('DeleteIndiIndex'));
        Integer intDeleteIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('DeleteIndiIndex'));
        if(intDeleteIndexIndicator != null){
            List<Grant_Indicator__c> lstIndicatorToDelete = new List<Grant_Indicator__c>();
            GIMResult objGIMResult = lstGIMResult[intDeleteIndexIndicator];
            if(objGIMResult.objGIM.Id != null){
                if(objGIMResult.lstResults !=null){
                    List<Result__c> lstResultToDelete = new List<Result__c>();
                    for(Result__c objResult : objGIMResult.lstResults){
                        if(objResult.id!=null){
                            lstResultToDelete.add(objResult);
                        }
                    }
                    delete lstResultToDelete;
                }
                delete lstGIMResult[intDeleteIndexIndicator].objGIM;
            }
            lstGIMResult.remove(intDeleteIndexIndicator);
            
            List<Grant_Indicator__c> lstGIMsToUpdate = [select id,Indicator_Number__c
                                from Grant_Indicator__c 
                                where Indicator_Type__c =: 'Grant Implementation Measure'
                                and Parent_Module__c =: strModuleId
                                and Grant_Intervention__c != null];
                                
            if(lstGIMsToUpdate.size() > 0){
                for(Grant_Indicator__c objGI : lstGIMsToUpdate){
                    objGI.Indicator_Number__c = objGI.Indicator_Number__c - 1;
                }
                update lstGIMsToUpdate;
            }
            
            blnConfirmIndicatorDelete = false;
        }
        System.Debug('Exiting DeleteGIMResult');
    }
    
    /**********************************************************************************************
    Purpose: Save Grant Indicator Result object after editing
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void SaveGIMResult(){
        System.Debug('Entering SaveGIMResult');
        System.Debug('Parameters[0] SaveIndiIndex = '+apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        if(intIndexIndicator != null){
            if(mapGIIdTowrap.ContainsKey(lstGIMResult[intIndexIndicator].objGIntervention.id)){
                mapGIIdTowrap.remove(lstGIMResult[intIndexIndicator].objGIntervention.id);
            }
            update lstGIMResult[intIndexIndicator].objGIM;
            for(Result__c objResult: lstGIMResult[intIndexIndicator].lstResults){
                objResult.Comments__c=lstGIMResult[intIndexIndicator].strAssumptions;
            }
            update lstGIMResult[intIndexIndicator].lstResults;
        }
        lstGIMResult[intIndexIndicator].blnIndicatorDisplay = true;
        lstGIMResult[intIndexIndicator].blndisplaySave = false;
        System.Debug('Exiting SaveGIMResult');
            }
    
    
    Public void SelectInterventionForGIM(){
        Integer intIndexIndicator = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        if(intIndexIndicator != null){
            if(lstGIMResult[intIndexIndicator].strIntervention!=null){
                lstGIMResult[intIndexIndicator].objGIntervention = MapGIntervention.get(lstGIMResult[intIndexIndicator].strIntervention);
                lstGIMResult[intIndexIndicator].objGIM.Grant_Intervention__c=lstGIMResult[intIndexIndicator].strIntervention;
            }else{
                lstGIMResult[intIndexIndicator].objGIntervention = new Grant_Intervention__c();
            }
        }
    }
    /*Public void SaveStandardIndicator(){
        insert objStandardGIMResult.objGIM;
        for(Result__c objResult: objStandardGIMResult.lstResults){
            objResult.Comments__c=objStandardGIMResult.strAssumptions;
            objResult.Indicator__c = objStandardGIMResult.objGIM.ID;
        }
        insert objStandardGIMResult.lstResults;
        lstGIMResult.add(objStandardGIMResult);
    }*/
    Public void SaveCustomIndicator(){
        Integer SaveIndex = integer.valueof(apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            objCustomGIMResult.objGIM.indicator_Number__c = SaveIndex;
        }
        insert objCustomGIMResult.objGIM;
        for(Result__c objResult: objCustomGIMResult.lstResults){
            objResult.Comments__c=objCustomGIMResult.strAssumptions;
            objResult.Indicator__c = objCustomGIMResult.objGIM.ID;
        }
        insert objCustomGIMResult.lstResults;
        lstGIMResult.add(objCustomGIMResult);
        AddNewCustomGIMResult();
            }
    Public void SelectInterventionForCustomNew(){
        if(objCustomGIMResult.strIntervention!=null){
            objCustomGIMResult.objGIntervention = MapGIntervention.get(objCustomGIMResult.strIntervention);
            objCustomGIMResult.objGIM.Grant_Intervention__c=objCustomGIMResult.strIntervention;
        }else{
           objCustomGIMResult.objGIntervention = new Grant_Intervention__c(); 
        }
    }
    
    public void getPageText(){
        system.debug('#####strLanguage->'+strLanguage);
        if(String.IsBlank(strLanguage) == false){
            Map<String,String> MultiLingualTextMap;
            MultiLingualTextMap = GILanguage.getMultiLingualText(strLanguage,'GIMSelection');
            if(MultiLingualTextMap !=null && MultiLingualTextMap.size()>0)
            {
                strClosepanelLabel = MultiLingualTextMap.get('GOClosePanelLabel');
                strTargetAssumptions = MultiLingualTextMap.get('GIMTargetassumptions');
                strConceptNotes = MultiLingualTextMap.get('GOConceptNotes');
                strEdit = MultiLingualTextMap.get('GIbtnEdit');
                strDelete = MultiLingualTextMap.get('GIbtnDelete');
                strYear = MultiLingualTextMap.get('GOYear');
                strTargets = MultiLingualTextMap.get('GIMTargets');
                strSave = MultiLingualTextMap.get('GIbtnSave');
                strCancel = MultiLingualTextMap.get('GIbtnCancel');
                strAreYouSure = MultiLingualTextMap.get('GIMAreyousure');
                strIndicatorDeleted = MultiLingualTextMap.get('GIMIndicatorWillDeleted');
                strSeeHelp  = MultiLingualTextMap.get('btnSeeHelp');
                strGIMDescription = MultiLingualTextMap.get('GIMDescription');
                strDataSource  = MultiLingualTextMap.get('GIMDataSource');
                strIntervention  = MultiLingualTextMap.get('GIMIntervention');
                strYes  = MultiLingualTextMap.get('btnYes');
                strTarget  = MultiLingualTextMap.get('GIMTarget');
                strTotal  = MultiLingualTextMap.get('GIMTotal');
                strTotalInterventionBudget  = MultiLingualTextMap.get('GIMTotalInterventionBudget');
                strTotalBudgetPercent = MultiLingualTextMap.get('GIMTotalBudgetPercent');
                strDialogue  = MultiLingualTextMap.get('btnDialogue');
                strClose  = MultiLingualTextMap.get('btnClose');
                strAddGIM  = MultiLingualTextMap.get('GIMAddGIM');
                strGIMSelection = MultiLingualTextMap.get('GIMSelection');
                strDescriptionReuiredMessage = MultiLingualTextMap.get('GIMDescriptionReuiredMessage');
                strGIMInterventionRequiredMessage = MultiLingualTextMap.get('GIMInterventionRequiredMessage');
                
                
            }
        }
    }
    
    Public Class GIMResult{
        Public Boolean blnIndicatorDisplay  {get;set;}
        Public Boolean blndisplaySave {get;set;}
        Public String strIntervention{get;set;}
        Public Grant_Intervention__c objGIntervention {get;set;}
        Public Grant_Indicator__c objGIM {get;set;}
        Public String strAssumptions {get;set;}
        Public List<Result__c> lstResults {get;set;}
        Public Boolean blnHasPost {get;set;}
        Public Integer intPostCount {get;set;}
    }
       

}