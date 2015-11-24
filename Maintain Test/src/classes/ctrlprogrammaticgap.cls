/**************************************************************************************
* Concept Note Programmatic Gap Page - Extensions Class
----------------------------------------------------------------------------------
*History
*Version       Date       DETAIL FEATURES
  1.1         06/05/2014   Added Apex code for Comment Field of PGap Object
***************************************************************************************/
Public Class ctrlprogrammaticgap{ 
    Public String strModuleId  {get;set;}
    Public List<wrapperClsModulePG> lstWrapCls{get;set;}
    Public wrapperClsModulePG objWrapClsStd{get;set;}
    Public String ConceptNoteId {get;set;}
    Public List<SelectOption> CatalogIndicatorOptions {get;set;}
    Public List<SelectOption> CIndOptions {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public Module__c objModuleToUpdateCycle {get;set;}
    Public Map<String,String> MapDisplayMonth {get;set;}
    Public String strStartMonth {get;set;}
    Public String strEndMonth {get;set;}
    Public String intLastMonth {get;set;}
    Public String strSelectedCycle {get;set;}
    public String strCNLanguage {get;set;}
    Public String strGuidanceId {get;set;}
    Public String strGuidanceId2 {get;set;}
    Public Map<Id,wrapperClsModulePG> mapIdTowrap {get;set;}
    Public Set<Id> setCatIndIds;
    Public Set<Id> setModIndIds;
    Public String APITitle {get;set;}
    
    Public GrantIndicatorResult objCustomGrantIndicatorResult{get;set;}
    Public GrantIndicatorResult objStandardGrantIndicatorResult{get;set;}
    Public Boolean blnExpandSection {get;set;}
    
    Public String strLanguage {get;set;}
    Public String strUserLanguage {get;set;}
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
    Public String strComponent{get;set;}
    Public String strCatalogModule;
    Public Boolean blnReadOnly {get;set;}
    Public Decimal setToZero {get;set;} // TCS - 09/05/2014- New variable initialized to D 
    Public Integer SaveIndiIndex {get;set;} // TCS - 13/05/2014- New variable
    Public Boolean blnSave {get;set;}//TCS - changes- Cycle Display
    Public Boolean blnEdit {get;set;}// TCS- changes- Edit Cycle
    
    Public Boolean blnCIndicatorLLIN {get;set;} //TCS changes for Requirement# 48 --Begin--
    Public Boolean blnCIndicatorIRS {get;set;} //Change for Requirement #107-5(553045)
    Public List<Programmatic_Gap__c> PGToInsertLLIN = new List<Programmatic_Gap__c>(); 
    Public List<Indicator__c> lstLLINforModule {get;set;}  
    Public List<Indicator__c> lstAllLLINforModule {get;set;}  
    Public Boolean LLIN {get;set;} 
    Public String strLLINIndName {get;set;} 
    Public Decimal MapSize {get;set;} 
    Public Decimal DecimalDY1 {get;set;}
    Public Decimal DecimalEY1 {get;set;}
    Public Decimal DecimalEY2 {get;set;}
    Public Decimal DecimalEY3 {get;set;}
    Public Decimal DecimalEY4 {get;set;}
    Map<Decimal,String> MapType = new Map<Decimal,String>();
    Map<Decimal,String> MapTypeForLLIN = new Map<Decimal,String>(); //TCS changes for Requirement# 48 --End--
    
        //TCS 10/09/2014: Variables for Profile Access
    Public Boolean blnExternalPro {get;set;}
    Public Boolean blnSaveCycle {get;set;}
    Public Boolean blnEditCycle     {get;set;}
    Public Boolean blnAddPGTable    {get;set;}
    Public Boolean blnEditTable     {get;set;}
    Public Boolean blnDelTable  {get;set;}
    Public Boolean blnCCMComments   {get;set;}
    Public Boolean blnLFAComments {get;set;}
    Public Boolean blnTGFComments {get;set;}
    Public Boolean blnSaveCust {get;set;}
    Public Boolean blnCancel {get;set;}
    public String strStatus ;
    
    Public Boolean showNewE {get;set;}  // TCS changes for Requirement# 107 --Begin--
    //IndicatorforPGCalculation__c IndIdForE= IndicatorforPGCalculation__c.getInstance('IndicatorforPGCalculation');  // TCS changes for Requirement# 107 --End--
    
    public ctrlprogrammaticgap(ApexPages.StandardController controller) {        
        strUserLanguage = 'ENGLISH';
        strGuidanceId2='';
          if(System.UserInfo.getLanguage() == 'fr') strUserLanguage = 'FRENCH';
          if(System.UserInfo.getLanguage() == 'ru') strUserLanguage = 'RUSSIAN';
          if(System.UserInfo.getLanguage() == 'es') strUserLanguage = 'SPANISH';
        setToZero = 0;
        blnEdit = true;
        //cFlag = true;
        blnCIndicatorLLIN = false;
        strSelectedCycle='';/*TCS Change*/
        //blnReadOnly = CheckProfile.checkProfile();
        strModuleId = Apexpages.currentpage().getparameters().get('id');
        setCatIndIds = new Set<Id>();
        setModIndIds = new Set<Id>();
        if(String.IsBlank(strModuleId) == false){
            List<Module__c> lstModule_new = [SELECT ID,Concept_Note__r.Component__c, 
                        PG_Cycle__c ,Concept_Note__r.Year_1__c,Concept_Note__r.Year_2__c,Concept_Note__r.Year_3__c,
                        Concept_Note__r.Year_4__c,Concept_Note__r.Number_of_Years__c, Concept_Note__r.Language__c,
                        Concept_Note__c,Language__c,Concept_Note__r.ID,Concept_Note__r.Status__c,Catalog_Module__c 
                        FROM Module__c WHERE id =: strModuleId];
            if(lstModule_new.size() > 0){
                strCatalogModule = lstModule_new[0].Catalog_Module__c;
                strStatus =lstModule_new[0].Concept_Note__r.Status__c;
                /*if(lstModule_new[0].Concept_Note__r.Status__c == 'Submitted to the Global Fund'  && CheckProfile.checkProfileGF()==false){
                    blnReadOnly = true; }
                else{
                    blnReadOnly = CheckProfile.checkProfile();
                }*/
                 checkProfile();//TCS 10/09/2014 Profile Access Setting
            }
            
            MapDisplayMonth = new Map<String,String>();
            MapDisplayMonth.put('January','01');
            MapDisplayMonth.put('February','02');
            MapDisplayMonth.put('March','03');
            MapDisplayMonth.put('April','04');
            MapDisplayMonth.put('May','05');
            MapDisplayMonth.put('June','06');
            MapDisplayMonth.put('July','07');
            MapDisplayMonth.put('August','08');
            MapDisplayMonth.put('September','09');
            MapDisplayMonth.put('October','10');
            MapDisplayMonth.put('November','11');
            MapDisplayMonth.put('December','12');
            
            if(lstModule_new!=null && lstModule_new.size()>0){
                ConceptNoteId = lstModule_new[0].Concept_Note__c;
                strComponent = lstModule_new[0].Concept_Note__r.Component__c;
                if(lstModule_new[0].Concept_Note__r.Component__c == 'Health Systems Strengthening')
                {strComponent = 'HSS'; }
                strCNLanguage = lstModule_new[0].Concept_Note__r.Language__c;
                if(lstModule_new[0].Language__c != null) strLanguage = lstModule_new[0].Language__c;
                objModuleToUpdateCycle = new module__C();
                
                objModuleToUpdateCycle = lstModule_new[0];
                //strSelectedCycle = objModuleToUpdateCycle.PG_Cycle__c;
            }
            if(strComponent != 'HIV/TB'){
            List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = :String.valueOf('Programmatic Gap ' + strComponent)];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
            }else {
               List<Guidance__c> lstGuidanceHIV = [Select Id from Guidance__c where Name = 'Programmatic Gap HIV/AIDS'];
               List<Guidance__c> lstGuidanceTB = [Select Id from Guidance__c where Name = 'Programmatic Gap Tuberculosis'];
            if(!lstGuidanceHIV.isEmpty()) {
              strGuidanceId = lstGuidanceHIV[0].Id; }
            if(!lstGuidanceTB.isEmpty()) {
              strGuidanceId2 = lstGuidanceTB[0].Id; }
            }
              
            if(objModuleToUpdateCycle.PG_Cycle__c != null){
                list<String> lstSplitMonth = objModuleToUpdateCycle.PG_Cycle__c.split(' - ');
                String StartMonth = lstSplitMonth[0];
                String EndMonth = lstSplitMonth[1];               
                
                strStartMonth = MapDisplayMonth.get(StartMonth);
                system.debug('$$$$$$'+strStartMonth);
                strEndMonth = MapDisplayMonth.get(EndMonth);
                if(objModuleToUpdateCycle.Concept_Note__r.Number_of_Years__c != null){
                    if(objModuleToUpdateCycle.Concept_Note__r.Number_of_Years__c == '4' && objModuleToUpdateCycle.Concept_Note__r.Year_4__c!=null){
                        integer ConceptNoteYear = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c)+1;
                        //integer LastMonth = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c  + 1);
                        if(ConceptNoteYear != null) intLastMonth = String.valueof(ConceptNoteYear);
                        system.debug('#$#$#$#$#$#$'+intLastMonth);
                    }else if(objModuleToUpdateCycle.Concept_Note__r.Year_3__c != null){
                        
                        integer ConceptNoteYear =integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_3__c)+1;
                        system.debug('#$#$#$#$#$#$'+ConceptNoteYear);
                        //intLastMonth = objModuleToUpdateCycle.Concept_Note__r.Year_3__c +1 ;
                        intLastMonth = string.valueof(ConceptNoteYear);
                        system.debug('#$#$#$#$#$#$'+intLastMonth);
                    }
                }else{
                    if(objModuleToUpdateCycle.Concept_Note__r.Year_3__c != null){
                        
                        integer ConceptNoteYear =integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_3__c)+1;
                        system.debug('#$#$#$#$#$#$'+ConceptNoteYear);
                        //intLastMonth = objModuleToUpdateCycle.Concept_Note__r.Year_3__c +1 ;
                        intLastMonth = string.valueof(ConceptNoteYear);
                        system.debug('#$#$#$#$#$#$'+intLastMonth);
                    }
                }
            }else{
                
                if(objModuleToUpdateCycle.Concept_Note__r.Number_of_Years__c == '4' && objModuleToUpdateCycle.Concept_Note__r.Year_4__c!=null){
                    integer ConceptNoteYear = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c)+1;
                    //integer LastMonth = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c  + 1);
                    if(ConceptNoteYear != null) intLastMonth = String.valueof(ConceptNoteYear);
                    
                }else if(objModuleToUpdateCycle.Concept_Note__r.Year_3__c != null){
                    integer ConceptNoteYear =integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_3__c)+1;
                    intLastMonth = string.valueof(ConceptNoteYear);
                    //intLastMonth = objModuleToUpdateCycle.Concept_Note__r.Year_3__c +1 ;
                }
            }
            
            lstWrapCls = new List<wrapperClsModulePG>();
            
            /*List<Grant_Indicator__c> lstGrantIndicator = [Select Id,Name,Indicator_Full_Name__c,Indicator__c,Indicator__r.Full_Name_En__c,
                                    Baseline_Sources__c,Baseline_Year__c,Baseline_value__c,Rationale_for_Chosen_Indicator__c,
                                    Indicator__r.Available_for_PG__c,Indicator__r.Programme_Area__c,
                                    (SELECT Id, Name,Group_Sequence__c ,Metric__c ,Current_Coverage__c,Current_Coverage_per__c,
                                    LFA_Comments__c,Coverage_Comments__c,Module__c,Global_Fund_Comments__c,
                                    Year_1__c ,Year_2__c ,CCM_Comments__c ,Year_3__c,Year_4__c, Specification__c,
                                    Assumptions__c,Program_Area__c,Type__c,Year_1_per__c,Year_2_per__c,
                                    Year_3_per__c,Year_4_per__c
                                    FROM Programmatic_Gaps__r where Concept_Note__c =: ConceptNoteId 
                                    And Indicator__r.Indicator__r.Available_for_PG__c = true 
                                    And Indicator__r.Indicator__r.Programme_Area__c = :strComponent
                                    order by Group_Sequence__c,Sequence__c asc) FROM Grant_Indicator__c 
                                    where  Parent_Module__c =: strModuleId];*/
                                    
                                    //TCS Req 48: Added field LLIN__c in the below query
                                    // TCS changes for Requirement# 107: Modified query to include Indicator_for_PG_Calculation_E__c
            List<Indicator__c> lstCatalogIndicator = [Select Id,Name,Available_for_PG__c,Programme_Area__c,Full_Name_En__c,
                                        French_Name__c, Spanish_Name__c, Russian_Name__c,LLIN__c,Indicator_for_PG_Calculation_E__c,
                                        (SELECT Id, Name,Group_Sequence__c ,Metric__c ,Current_Coverage__c,
                                        Current_Coverage_per__c,Baseline_Source__c,Baseline_Year__c,Baseline_value__c,
                                        Rationale_for_Chosen_Indicator__c,LFA_Comments__c,Coverage_Comments__c,
                                        Module__c,Global_Fund_Comments__c,Year_1__c ,Year_2__c ,CCM_Comments__c ,
                                        CCM_Comments_French__c, CCM_Comments_Russian__c, CCM_Comments_Spanish__c,
                                        Year_3__c,Year_4__c, Specification__c,Assumptions__c,Program_Area__c,
                                        Type__c,Type_Formula__c,Year_1_per__c,Year_2_per__c,Year_3_per__c,Year_4_per__c, Specify_Text__c,Coverage_Text__c //TCS change for Specify_Text__c,Coverage_Text__c
                                        FROM Programmatic_Gaps__r WHERE Concept_Note__c = :ConceptNoteId
                                        AND TYPE__c != 'D. Country need already covered by other existing Global Fund grants'
                                        order by Group_Sequence__c,Sequence__c asc) 
                                    FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                    And Indicator_Type__c =: 'Coverage/Output'
                                    And Available_for_PG__c = true 
                                    And LLIN__c != true
                                     ];
                                     
            List<Indicator__c> lstCI = [Select Id,Full_Name_En__c,French_Name__c, Spanish_Name__c, Russian_Name__c                                         
                                        FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                        And Indicator_Type__c =: 'Coverage/Output'
                                        And Available_for_PG__c = true                                      
                                        ];
                                        
                                        // TCS changes for Requirement# 107: Modified query to include Indicator_for_PG_Calculation_E__c                         
            List <Indicator__c> lstCatalogIndicatorLLIN = [Select Id,Name,Available_for_PG__c,Programme_Area__c,Full_Name_En__c,
                                        French_Name__c, Spanish_Name__c, Russian_Name__c,LLIN__c, Indicator_for_PG_Calculation_E__c,
                                        (SELECT Id, Name,Group_Sequence__c ,Metric__c ,Current_Coverage__c,
                                        Current_Coverage_per__c,Baseline_Source__c,Baseline_Year__c,Baseline_value__c,
                                        Rationale_for_Chosen_Indicator__c,LFA_Comments__c,Coverage_Comments__c,
                                        Module__c,Global_Fund_Comments__c,Year_1__c ,Year_2__c ,CCM_Comments__c ,
                                        CCM_Comments_French__c, CCM_Comments_Russian__c, CCM_Comments_Spanish__c,
                                        Year_3__c,Year_4__c, Specification__c,Assumptions__c,Program_Area__c,
                                        Type__c,Type_Formula__c,Year_1_per__c,Year_2_per__c,Year_3_per__c,Year_4_per__c, Specify_Text__c,Coverage_Text__c //TCS change for Specify_Text__c,Coverage_Text__c
                                        FROM Programmatic_Gaps__r WHERE Concept_Note__c = :ConceptNoteId
                                        AND TYPE__c != '2.Estimated pregnant women to be reached through ANC in all malaria areas'
                                        AND TYPE__c != '3.Estimated children under 1 in all malaria areas reached through EPI clinics'
                                        AND TYPE__c != 'A. Country targets for population coverage (from national strategic plan )'
                                        order by Group_Sequence__c,Sequence__c asc) 
                                    FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                    And Indicator_Type__c =: 'Coverage/Output'
                                    And Available_for_PG__c = true 
                                     And LLIN__c = true
                                    /*And Id not in (Select Catalog_Indicator__c from Programmatic_Gap__c where Concept_Note__c = :ConceptNoteId)*/
                                    /*And Component__c INCLUDES (:strComponent)*/];
            
            
            strLLINIndName = '';
            String TempstrLLINIndName='';
            
            
            if(lstCatalogIndicatorLLIN.size() > 0) {
                for(Indicator__c LLIN: lstCatalogIndicatorLLIN){                    
                    if(strUserLanguage == 'ENGLISH' && LLIN.Full_Name_En__c != null)
                        TempstrLLINIndName=  TempstrLLINIndName + '<br>- ' +LLIN.Full_Name_En__c + '';
                        
                    else if(strUserLanguage == 'FRENCH' && LLIN.French_Name__c != null)
                        TempstrLLINIndName=  TempstrLLINIndName + '<br> ' +LLIN.French_Name__c + ',';
                    else if(strUserLanguage == 'SPANISH' && LLIN.Spanish_Name__c != null)
                        TempstrLLINIndName=  TempstrLLINIndName + '<br> ' +LLIN.Spanish_Name__c + ',';
                    else if(strUserLanguage == 'RUSSIAN' && LLIN.Russian_Name__c != null)
                        TempstrLLINIndName=  TempstrLLINIndName + '<br>' +LLIN.Russian_Name__c + ',';
                }
                strLLINIndName = TempstrLLINIndName;
                //strLLINIndName = TempstrLLINIndName.Substring(0,TempstrLLINIndName.length()-1);
                //lstCatalogIndicatorLLIN[0].Full_Name_En__c = strLLINIndName;  
                lstCatalogIndicator.add(lstCatalogIndicatorLLIN[0]);
            }
            
            //List<Indicator__c> lstCatalogIndicatorWOLLIN = new List<Indicator__c> ();
            for(Programmatic_Gap__c pg : [Select Catalog_Indicator__c from Programmatic_Gap__c where Concept_Note__c = :ConceptNoteId]){
             setCatIndIds.add(pg.Catalog_Indicator__c);
            }                        
            
            
            /*for(Programmatic_Gap__c pg : [Select Catalog_Indicator__c from Programmatic_Gap__c where Module__c = :strModuleId]){
             setModIndIds.add(pg.Catalog_Indicator__c);
             system.debug('****set'+setModIndIds);
            } */
            
            
            CIndOptions = new List<SelectOption>();
            CIndOptions.add(new SelectOption('','--'+Label.None+'--'));       
            
            CatalogIndicatorOptions = new List<SelectOption>();
            CatalogIndicatorOptions.add(new SelectOption('','--None--'));     
            
            for(Indicator__c I: lstCI){
                system.debug('Indicator Name:'+I.Full_Name_En__c);
                if(setCatIndIds != NULL){
                if(!setCatIndIds.contains(I.Id)){                                            
                    if(strUserLanguage == 'ENGLISH' && I.Full_Name_En__c != null){                      
                       CIndOptions.add(new SelectOption(I.Id,I.Full_Name_En__c)); }
                    else if(strUserLanguage == 'FRENCH' && I.French_Name__c != null){
                      CIndOptions.add(new SelectOption(I.Id,I.French_Name__c)); }
                    else if(strUserLanguage == 'SPANISH' && I.Spanish_Name__c != null){
                      CIndOptions.add(new SelectOption(I.Id,I.Spanish_Name__c)); }
                    else if(strUserLanguage == 'RUSSIAN' && I.Russian_Name__c != null){
                      CIndOptions.add(new SelectOption(I.Id,I.Russian_Name__c)); }
                }}
                else{
                    if(strUserLanguage == 'ENGLISH' && I.Full_Name_En__c != null){                      
                       CIndOptions.add(new SelectOption(I.Id,I.Full_Name_En__c)); }
                    else if(strUserLanguage == 'FRENCH' && I.French_Name__c != null){
                      CIndOptions.add(new SelectOption(I.Id,I.French_Name__c)); }
                    else if(strUserLanguage == 'SPANISH' && I.Spanish_Name__c != null){
                      CIndOptions.add(new SelectOption(I.Id,I.Spanish_Name__c)); }
                    else if(strUserLanguage == 'RUSSIAN' && I.Russian_Name__c != null){
                      CIndOptions.add(new SelectOption(I.Id,I.Russian_Name__c)); }  
                }
            }
               
            if(lstCatalogIndicator.size() > 0){
                Integer Index = 0;
                for(Indicator__c objCInd: lstCatalogIndicator){ 
                    if(objCInd.Programmatic_Gaps__r.size() > 0){
                        wrapperClsModulePG objWrpCls = new wrapperClsModulePG();
                        objWrpCls.objCI = new Indicator__c();
                        objWrpCls.objCI = objCInd;
                        
                        if(objWrpCls.objCI.LLIN__c)
                        objWrpCls.showLLIN = true;
                        // TCS changes for Requirement# 107 --Begin--
                        System.debug('objWrpCls.showNewE1 Before'+objWrpCls.showNewE1);
                        //if(objWrpCls.objCI.Id==IndIdForE.Id_GP5__c||objWrpCls.objCI.Id==IndIdForE.Id_VC6__c||strComponent =='Health Systems Strengthening')
                        //if(objWrpCls.objCI.Indicator_for_PG_Calculation_E__c)
                        objWrpCls.showNewE1 = objWrpCls.objCI.Indicator_for_PG_Calculation_E__c;
                        System.debug('objWrpCls.showNewE1 After'+objWrpCls.showNewE1);
                        // TCS changes for Requirement# 107 --End--
                        objWrpCls.lstProgrammaticGap= new List<ProgrammaticGap>();
                        ProgrammaticGap objwrap;
                        
                        
                        Decimal numberA = 0;
                        Decimal numberC = 0;
                        Decimal numberD = 0;
                        Decimal numberF = 0;
                        Decimal numberH = 0;
                        Decimal PercentA = 0;
                        Decimal PercentC = 0;
                        Decimal PercentD = 0;
                        Decimal PercentF = 0;
                        Decimal PercentH = 0;
                        //TCS defined for Req #48
                        Decimal numberB = 0;
                        Decimal numberE = 0;
                        Decimal numberJ = 0;
                        Decimal numberL = 0;
                        Decimal PercentB = 0;
                        Decimal PercentE = 0;
                        Decimal PercentJ = 0;
                        Decimal PercentL = 0;
                        Decimal PercentG = 0;
                        
                        Decimal numberAY2 = 0;
                        Decimal numberCY2 = 0;
                        Decimal numberDY2 = 0;
                        Decimal numberFY2 = 0;
                        Decimal numberHY2 = 0;
                        Decimal PercentAY2 = 0;
                        Decimal PercentCY2 = 0;
                        Decimal PercentDY2 = 0;
                        Decimal PercentFY2 = 0;
                        Decimal PercentHY2 = 0;
                         //TCS defined for Req #48
                        Decimal numberBY2 = 0;
                        Decimal numberEY2 = 0;
                        Decimal numberJY2 = 0;
                        Decimal numberLY2 = 0;
                        Decimal PercentBY2 = 0;
                        Decimal PercentEY2 = 0;
                        Decimal PercentJY2 = 0;
                        Decimal PercentLY2 = 0;
                        Decimal PercentGY2 = 0;
                        
                        Decimal numberAY3 = 0;
                        Decimal numberCY3 = 0;
                        Decimal numberDY3 = 0;
                        Decimal numberFY3 = 0;
                        Decimal numberHY3 = 0;
                        Decimal PercentAY3 = 0;
                        Decimal PercentCY3 = 0;
                        Decimal PercentDY3 = 0;
                        Decimal PercentFY3 = 0;
                        Decimal PercentHY3 = 0;
                        //TCS defined for Req #48
                        Decimal numberBY3 = 0;
                        Decimal numberEY3 = 0;
                        Decimal numberJY3 = 0;
                        Decimal numberLY3 = 0;
                        Decimal PercentBY3 = 0;
                        Decimal PercentEY3 = 0;
                        Decimal PercentJY3 = 0;
                        Decimal PercentLY3 = 0;
                        Decimal PercentGY3 = 0;
                        
                        Decimal numberAY4 = 0;
                        Decimal numberCY4 = 0;
                        Decimal numberDY4 = 0;
                        Decimal numberFY4 = 0;
                        Decimal numberHY4 = 0;
                        Decimal PercentAY4 = 0;
                        Decimal PercentCY4 = 0;
                        Decimal PercentDY4 = 0;
                        Decimal PercentFY4 = 0;
                        Decimal PercentHY4 = 0;
                        //TCS defined for Req #48
                        Decimal numberBY4 = 0;
                        Decimal numberEY4 = 0;
                        Decimal numberJY4 = 0;
                        Decimal numberLY4 = 0;
                        Decimal PercentBY4 = 0;
                        Decimal PercentEY4 = 0;
                        Decimal PercentJY4 = 0;
                        Decimal PercentLY4 = 0;
                        Decimal PercentGY4 = 0;
                        
                        for(Programmatic_Gap__c obj : objCInd.Programmatic_Gaps__r){
                            objwrap = new ProgrammaticGap();
                            objwrap.objPGap = new Programmatic_Gap__c();
                            objwrap.objPGap = obj;
                            /*TCS - 27/05/2014- Added for requirement 48 */
                            /* Code Starts here */
                          if(objCInd.LLIN__c == false)
                          {
                           //--TCS - 09/05/2014- Initialized fields to zero for Programmatic Gap of type D
                            /*TCS changes for Requirement# 107 Starts-- 4 July 2014>
                            /*if(obj.Type_Formula__c == 'D' ) obj.year_1__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.year_2__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.year_3__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.year_4__c = setToZero;
                            
                            if(obj.Type_Formula__c == 'D' ) obj.Year_1_per__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.Year_2_per__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.Year_3_per__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.Year_4_per__c = setToZero;
                            TCS changes for Requirement# 107 End*/ 
                            
                                                        
                            if(obj.Type_Formula__c == 'A' && obj.year_1__c != null) numberA = obj.year_1__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_1__c != null) numberB = obj.year_1__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_1__c != null) numberC = obj.year_1__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_1__c != null) numberD = obj.year_1__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_1__c != null) numberF = obj.year_1__c;
                            //if(obj.Type_Formula__c == 'H' && obj.year_1__c != null) numberH = obj.year_1__c;  //TCS changes for Requirement# 107 4 th Aug 2014
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_1_per__c!= null) PercentA = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_1_per__c!= null) PercentB = obj.Year_1_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_1_per__c!= null) PercentC = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_1_per__c!= null) PercentD = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_1_per__c!= null) PercentF = obj.Year_1_per__c;
                            //if(obj.Type_Formula__c == 'H' && obj.Year_1_per__c!= null) PercentH = obj.Year_1_per__c; //TCS changes for Requirement# 107 4 th Aug 2014
                            
                            if(obj.Type_Formula__c == 'A' && obj.year_2__c != null) numberAY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_2__c != null) numberBY2 = obj.year_2__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_2__c != null) numberCY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_2__c != null) numberDY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_2__c != null) numberFY2 = obj.year_2__c;
                            //if(obj.Type_Formula__c == 'H' && obj.year_2__c != null) numberHY2 = obj.year_2__c; //TCS changes for Requirement# 107 4 th Aug 2014
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_2_per__c!= null) PercentAY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_2_per__c!= null) PercentBY2 = obj.Year_2_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_2_per__c!= null) PercentCY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_2_per__c!= null) PercentDY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_2_per__c!= null) PercentFY2 = obj.Year_2_per__c;
                            //if(obj.Type_Formula__c == 'H' && obj.Year_2_per__c!= null) PercentHY2 = obj.Year_2_per__c; //TCS changes for Requirement# 107 4 th Aug 2014
                            
                            if(obj.Type_Formula__c == 'A' && obj.year_3__c != null) numberAY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_3__c != null) numberBY3 = obj.year_3__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_3__c != null) numberCY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_3__c != null) numberDY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_3__c != null) numberFY3 = obj.year_3__c;
                            //if(obj.Type_Formula__c == 'H' && obj.year_3__c != null) numberHY3 = obj.year_3__c; //TCS changes for Requirement# 107 4 th Aug 2014
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_3_per__c!= null) PercentAY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_3_per__c!= null) PercentBY3 = obj.Year_3_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_3_per__c!= null) PercentCY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_3_per__c!= null) PercentDY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_3_per__c!= null) PercentFY3 = obj.Year_3_per__c;
                            //if(obj.Type_Formula__c == 'H' && obj.Year_3_per__c!= null) PercentHY3 = obj.Year_3_per__c; //TCS changes for Requirement# 107 4 th Aug 2014
                            
                            if(obj.Type_Formula__c == 'A' && obj.year_4__c != null) numberAY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_4__c != null) numberBY4 = obj.year_4__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_4__c != null) numberCY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_4__c != null) numberDY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_4__c != null) numberFY4 = obj.year_4__c;
                            //if(obj.Type_Formula__c == 'H' && obj.year_4__c != null) numberHY4 = obj.year_4__c; //TCS changes for Requirement# 107 4 th Aug 2014
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_4_per__c!= null) PercentAY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_4_per__c!= null) PercentBY4 = obj.Year_4_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_4_per__c!= null) PercentCY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_4_per__c!= null) PercentDY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_4_per__c!= null) PercentFY4 = obj.Year_4_per__c;
                            //if(obj.Type_Formula__c == 'H' && obj.Year_4_per__c!= null) PercentHY4 = obj.Year_4_per__c; //TCS changes for Requirement# 107 4 th Aug 2014
                             }
                          else
                          {
                            if(obj.Type_Formula__c == 'B' && obj.year_1__c != null) numberB = obj.year_1__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_1__c != null) numberC = obj.year_1__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_1__c != null) numberD = obj.year_1__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_1__c != null) numberE = obj.year_1__c;
                            if(obj.Type_Formula__c == 'H' && obj.year_1__c != null) numberH = obj.year_1__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_1__c != null) numberJ = obj.year_1__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_1__c != null) numberL = obj.year_1__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_1_per__c!= null) PercentA = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_1_per__c!= null) PercentG = obj.Year_1_per__c;
                            
                            
                                                       
                            if(obj.Type_Formula__c == 'B' && obj.year_2__c != null) numberBY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_2__c != null) numberCY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_2__c != null) numberDY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_2__c != null) numberEY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'H' && obj.year_2__c != null) numberHY2 = obj.year_2__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_2__c != null) numberJY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_2__c != null) numberLY2 = obj.year_2__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_2_per__c!= null) PercentAY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_2_per__c!= null) PercentGY2 = obj.Year_2_per__c;
                                                        
                            if(obj.Type_Formula__c == 'B' && obj.year_3__c != null) numberBY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_3__c != null) numberCY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_3__c != null) numberDY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_3__c != null) numberEY3 = obj.year_3__c;
                            system.debug('one E section'+obj.Type_Formula__c);
                            system.debug('one E section'+numberEY3);
                            if(obj.Type_Formula__c == 'H' && obj.year_3__c != null) numberHY3 = obj.year_3__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_3__c != null) numberJY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_3__c != null) numberLY3 = obj.year_3__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_3_per__c!= null) PercentAY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_3_per__c!= null) PercentGY3 = obj.Year_3_per__c;
                                                        
                            if(obj.Type_Formula__c == 'B' && obj.year_4__c != null) numberBY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_4__c != null) numberCY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_4__c != null) numberDY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_4__c != null) numberEY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'H' && obj.year_4__c != null) numberHY4 = obj.year_4__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_4__c != null) numberJY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_4__c != null) numberLY4 = obj.year_4__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_4_per__c!= null) PercentAY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_4_per__c!= null) PercentGY4 = obj.Year_4_per__c;
                          } 
                            
                            objwrap.blnHistory =false;
                            objWrpCls.lstProgrammaticGap.add(objwrap);
                        }
                         if(objCInd.LLIN__c == false) {
                            /*TCS changes for Requirement# 107 --Begin--*/
                           //if(objWrpCls.showNewE1)
                             // {
                              if(objCInd.Indicator_for_PG_Calculation_E__c)
                              {
                        objWrpCls.Year1NumberE = numberB - numberC;
                        objWrpCls.Year2NumberE = numberBY2 - numberCY2;
                        objWrpCls.Year3NumberE = numberBY3 - numberCY3;
                        objWrpCls.Year4NumberE = numberBY4 - numberCY4;
                        
                        if(numberB != 0)
                        //objWrpCls.Year1PercentE = integer.valueOf(((numberB - numberC)/numberB)*100);
                        objWrpCls.Year1PercentE = (((numberB - numberC)/numberB)*100).setScale(2);
                        else
                        objWrpCls.Year1PercentE = 0;
                        if(numberBY2 != 0)
                        //objWrpCls.Year2PercentE = integer.valueOf(((numberBY2 - numberCY2)/numberBY2)*100);
                        objWrpCls.Year2PercentE = (((numberBY2 - numberCY2)/numberBY2)*100).setScale(2);
                        else
                        objWrpCls.Year2PercentE = 0;
                        if(numberBY3 != 0)
                       // objWrpCls.Year3PercentE = integer.valueOf(((numberBY3 - numberCY3)/numberBY3)*100);
                        objWrpCls.Year3PercentE = (((numberBY3 - numberCY3)/numberBY3)*100).setScale(2);
                        else
                        objWrpCls.Year3PercentE = 0;
                        if(numberBY4 != 0)
                        //objWrpCls.Year4PercentE = integer.valueOf(((numberBY4 - numberCY4)/numberBY4)*100);
                        objWrpCls.Year4PercentE = (((numberBY4 - numberCY4)/numberBY4)*100).setScale(2);
                        else
                        objWrpCls.Year4PercentE = 0;                                              
                              }
                           else
                              {
                        objWrpCls.Year1NumberE = numberA - numberC;
                        //objWrpCls.Year1PercentE = 100 - PercentC;
                        objWrpCls.Year1PercentE = (100 - PercentC).setScale(2);
                        objWrpCls.Year2NumberE = numberAY2 - (numberCY2);
                        //objWrpCls.Year2PercentE = 100 - (PercentCY2);
                        objWrpCls.Year2PercentE = (100 - (PercentCY2)).setScale(2);
                        objWrpCls.Year3NumberE = numberAY3 - (numberCY3);
                        //objWrpCls.Year3PercentE = 100 - (PercentCY3);
                        objWrpCls.Year3PercentE = (100 - (PercentCY3)).setScale(2);
                        objWrpCls.Year4NumberE = numberAY4 - (numberCY4);
                        //objWrpCls.Year4PercentE = 100 - (PercentCY4);
                        objWrpCls.Year4PercentE = (100 - (PercentCY4)).setScale(2);  
                        
                             
                              }
                             /* TCS changes for Requirement# 107 --End--*/ 
                        
                        objWrpCls.Year1NumberG = (NumberD + numberC); //Calculating F instead of G
                        //objWrpCls.Year1PercentG = (PercentD + PercentC);
                        objWrpCls.Year1PercentG = (PercentD + PercentC).setScale(2);
                        objWrpCls.Year1NumberI = NumberD + numberC + numberF;//
                        //objWrpCls.Year1PercentI = (PercentC + PercentD) + PercentF;
                        objWrpCls.Year1PercentI = ((PercentC + PercentD) + PercentF).setScale(2);
                           
                        objWrpCls.Year2NumberG = numberCY2 + numberDY2;
                        //objWrpCls.Year2PercentG = PercentCY2 + PercentDY2;
                        objWrpCls.Year2PercentG = (PercentCY2 + PercentDY2).setScale(2);
                        objWrpCls.Year2NumberI = NumberFY2 + numberCY2 + numberDY2;
                        //objWrpCls.Year2PercentI = PercentFY2 + PercentCY2 + PercentDY2;
                        objWrpCls.Year2PercentI = (PercentFY2 + PercentCY2 + PercentDY2).setScale(2);
                        
                        objWrpCls.Year3NumberG = numberCY3 + numberDY3;
                        //objWrpCls.Year3PercentG = PercentCY3 + PercentDY3;
                        objWrpCls.Year3PercentG = (PercentCY3 + PercentDY3).setScale(2);
                        objWrpCls.Year3NumberI = NumberFY3 + numberCY3 + numberDY3;
                        //objWrpCls.Year3PercentI = PercentFY3 + PercentCY3 + PercentDY3;
                        objWrpCls.Year3PercentI = (PercentFY3 + PercentCY3 + PercentDY3).setScale(2);
                            
                        objWrpCls.Year4NumberG = numberCY4 + numberDY4;
                        //objWrpCls.Year4PercentG = PercentCY4 + PercentDY4;
                        objWrpCls.Year4PercentG = (PercentCY4 + PercentDY4).setScale(2);
                        objWrpCls.Year4NumberI = NumberFY4 + numberCY4 + numberDY4;
                        //objWrpCls.Year4PercentI = PercentFY4 + PercentCY4 + PercentDY4;
                        objWrpCls.Year4PercentI = (PercentFY4 + PercentCY4 + PercentDY4).setScale(2);
                        
                        objWrpCls.YearE1=objWrpCls.Year1NumberE.format();
                        objWrpCls.YearE2=objWrpCls.Year2NumberE.format();
                        objWrpCls.YearE3=objWrpCls.Year3NumberE.format();
                        objWrpCls.YearE4=objWrpCls.Year4NumberE.format();
                        
                        objWrpCls.YearG1=objWrpCls.Year1NumberG.format();
                        objWrpCls.YearG2=objWrpCls.Year2NumberG.format();
                        objWrpCls.YearG3=objWrpCls.Year3NumberG.format();
                        objWrpCls.YearG4=objWrpCls.Year4NumberG.format();
                        
                        objWrpCls.YearI1=objWrpCls.Year1NumberI.format();
                        objWrpCls.YearI2=objWrpCls.Year2NumberI.format();
                        objWrpCls.YearI3=objWrpCls.Year3NumberI.format();
                        objWrpCls.YearI4=objWrpCls.Year4NumberI.format();
                        }
                        else {
                        objWrpCls.Year1NumberF = numberC + numberD + numberE;                        
                        objWrpCls.Year1NumberG = objWrpCls.Year1NumberF + numberB;
                        objWrpCls.Year1NumberI = objWrpCls.Year1NumberG - numberH;
                        objWrpCls.Year1NumberK = numberJ + numberH;
                        objWrpCls.Year1NumberM = objWrpCls.Year1NumberK + numberL;
                            if(objWrpCls.Year1NumberG == 0)
                            {
                                objWrpCls.Year1PercentH = 0;
                                objWrpCls.Year1PercentJ = 0;
                                objWrpCls.Year1PercentK = 0;
                                objWrpCls.Year1PercentL = 0;
                                objWrpCls.Year1PercentM = 0;
                                objWrpCls.Year1PercentI = 0;
                            }
                        else {
                               /* if(numberH != 0)objWrpCls.Year1PercentH = Math.round((numberH / objWrpCls.Year1NumberG) * 100);
                                if(objWrpCls.Year1NumberI != 0)  objWrpCls.Year1PercentI = Math.round((objWrpCls.Year1NumberI / objWrpCls.Year1NumberG) * 100);
                                if(numberJ != 0)objWrpCls.Year1PercentJ = Math.round((numberJ / objWrpCls.Year1NumberG) * 100);
                                if(objWrpCls.Year1NumberK != 0) objWrpCls.Year1PercentK = Math.round((objWrpCls.Year1NumberK / objWrpCls.Year1NumberG) * 100);
                                if(numberL != 0)objWrpCls.Year1PercentL = Math.round((NumberL / objWrpCls.Year1NumberG) * 100);
                                if(objWrpCls.Year1NumberM != 0)objWrpCls.Year1PercentM = Math.round((objWrpCls.Year1NumberM / objWrpCls.Year1NumberG) * 100);*/
                                
                                if(numberH != 0)objWrpCls.Year1PercentH = ((numberH / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(objWrpCls.Year1NumberI != 0)  objWrpCls.Year1PercentI = ((objWrpCls.Year1NumberI / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(numberJ != 0)objWrpCls.Year1PercentJ = ((numberJ / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(objWrpCls.Year1NumberK != 0) objWrpCls.Year1PercentK = ((objWrpCls.Year1NumberK / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(numberL != 0)objWrpCls.Year1PercentL = ((NumberL / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(objWrpCls.Year1NumberM != 0)objWrpCls.Year1PercentM = ((objWrpCls.Year1NumberM / objWrpCls.Year1NumberG) * 100).setScale(2);
                        }
                        objWrpCls.Year2NumberF = numberCY2 + numberDY2 + numberEY2;                        
                        objWrpCls.Year2NumberG = objWrpCls.Year2NumberF + numberBY2;
                        objWrpCls.Year2NumberI = objWrpCls.Year2NumberG - numberHY2;
                        objWrpCls.Year2NumberK = numberJY2 + numberHY2;
                        objWrpCls.Year2NumberM = objWrpCls.Year2NumberK + numberLY2;
                            if(objWrpCls.Year2NumberG == 0)
                            {
                                objWrpCls.Year2PercentH = 0;
                                objWrpCls.Year2PercentJ = 0;
                                objWrpCls.Year2PercentK = 0;
                                objWrpCls.Year2PercentL = 0;
                                objWrpCls.Year2PercentM = 0;
                                objWrpCls.Year2PercentI = 0;
                            }
                        else {
                                /*if(numberHY2 != 0)objWrpCls.Year2PercentH = Math.round((numberHY2 / objWrpCls.Year2NumberG) * 100);
                                if(objWrpCls.Year2NumberI != 0)  objWrpCls.Year2PercentI = Math.round((objWrpCls.Year2NumberI / objWrpCls.Year2NumberG) * 100);
                                if(numberJY2 != 0)objWrpCls.Year2PercentJ = Math.round((numberJY2 / objWrpCls.Year2NumberG) * 100);
                                if(objWrpCls.Year2NumberK != 0) objWrpCls.Year2PercentK = Math.round((objWrpCls.Year2NumberK / objWrpCls.Year2NumberG) * 100);
                                if(numberL != 0)objWrpCls.Year2PercentL = Math.round((NumberLY2 / objWrpCls.Year2NumberG) * 100);
                                if(objWrpCls.Year2NumberM != 0)objWrpCls.Year2PercentM = Math.round((objWrpCls.Year2NumberM / objWrpCls.Year2NumberG) * 100);*/
                                
                                 if(numberHY2 != 0)objWrpCls.Year2PercentH = ((numberHY2 / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(objWrpCls.Year2NumberI != 0)  objWrpCls.Year2PercentI = ((objWrpCls.Year2NumberI / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(numberJY2 != 0)objWrpCls.Year2PercentJ = ((numberJY2 / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(objWrpCls.Year2NumberK != 0) objWrpCls.Year2PercentK = ((objWrpCls.Year2NumberK / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(numberL != 0)objWrpCls.Year2PercentL = ((NumberLY2 / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(objWrpCls.Year2NumberM != 0)objWrpCls.Year2PercentM = ((objWrpCls.Year2NumberM / objWrpCls.Year2NumberG) * 100).setScale(2);
                        }
                        
                        objWrpCls.Year3NumberF = numberCY3 + numberDY3 + numberEY3;                        
                        objWrpCls.Year3NumberG = objWrpCls.Year3NumberF + numberBY3;
                        objWrpCls.Year3NumberI = objWrpCls.Year3NumberG - numberHY3;
                        objWrpCls.Year3NumberK = numberJY3 + numberHY3;
                        objWrpCls.Year3NumberM = objWrpCls.Year3NumberK + numberLY3;
                            if(objWrpCls.Year3NumberG == 0)
                            {
                                objWrpCls.Year3PercentH = 0;
                                objWrpCls.Year3PercentJ = 0;
                                objWrpCls.Year3PercentK = 0;
                                objWrpCls.Year3PercentL = 0;
                                objWrpCls.Year3PercentM = 0;
                                objWrpCls.Year3PercentI = 0;
                            }
                        else {
                                /*if(numberHY3 != 0)objWrpCls.Year3PercentH = Math.round((numberHY3 / objWrpCls.Year3NumberG) * 100);
                                if(objWrpCls.Year3NumberI != 0)  objWrpCls.Year3PercentI = Math.round((objWrpCls.Year3NumberI / objWrpCls.Year3NumberG) * 100);
                                if(numberJY3 != 0)objWrpCls.Year3PercentJ = Math.round((numberJY3 / objWrpCls.Year3NumberG) * 100);
                                if(objWrpCls.Year3NumberK != 0) objWrpCls.Year3PercentK = Math.round((objWrpCls.Year3NumberK / objWrpCls.Year3NumberG) * 100);
                                if(numberLY3 != 0)objWrpCls.Year3PercentL = Math.round((NumberLY3 / objWrpCls.Year3NumberG) * 100);
                                if(objWrpCls.Year3NumberM != 0)objWrpCls.Year3PercentM = Math.round((objWrpCls.Year3NumberM / objWrpCls.Year3NumberG) * 100);*/
                                
                                if(numberHY3 != 0)objWrpCls.Year3PercentH = ((numberHY3 / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(objWrpCls.Year3NumberI != 0)  objWrpCls.Year3PercentI = ((objWrpCls.Year3NumberI / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(numberJY3 != 0)objWrpCls.Year3PercentJ = ((numberJY3 / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(objWrpCls.Year3NumberK != 0) objWrpCls.Year3PercentK = ((objWrpCls.Year3NumberK / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(numberLY3 != 0)objWrpCls.Year3PercentL = ((NumberLY3 / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(objWrpCls.Year3NumberM != 0)objWrpCls.Year3PercentM = ((objWrpCls.Year3NumberM / objWrpCls.Year3NumberG) * 100).setScale(2);
                        }
                        
                        objWrpCls.Year4NumberF = numberCY4 + numberDY4 + numberEY4;                        
                        objWrpCls.Year4NumberG = objWrpCls.Year4NumberF + numberBY4;
                        objWrpCls.Year4NumberI = objWrpCls.Year4NumberG - numberHY4;
                        objWrpCls.Year4NumberK = numberJY4 + numberHY4;
                        objWrpCls.Year4NumberM = objWrpCls.Year4NumberK + numberLY4;
                            if(objWrpCls.Year4NumberG == 0)
                            {
                                objWrpCls.Year4PercentH = 0;
                                objWrpCls.Year4PercentJ = 0;
                                objWrpCls.Year4PercentK = 0;
                                objWrpCls.Year4PercentL = 0;
                                objWrpCls.Year4PercentM = 0;
                                objWrpCls.Year4PercentI = 0;
                            }
                        else {
                                /*if(numberHY4 != 0)objWrpCls.Year4PercentH = Math.round((numberHY4 / objWrpCls.Year4NumberG) * 100);
                                if(objWrpCls.Year4NumberI != 0)  objWrpCls.Year4PercentI = Math.round((objWrpCls.Year4NumberI / objWrpCls.Year4NumberG) * 100);
                                if(numberJY4 != 0)objWrpCls.Year4PercentJ = Math.round((numberJY4 / objWrpCls.Year4NumberG) * 100);
                                if(objWrpCls.Year4NumberK != 0) objWrpCls.Year4PercentK = Math.round((objWrpCls.Year4NumberK / objWrpCls.Year4NumberG) * 100);
                                if(numberLY4 != 0)objWrpCls.Year4PercentL = Math.round((NumberLY4 / objWrpCls.Year4NumberG) * 100);
                                if(objWrpCls.Year4NumberM != 0)objWrpCls.Year4PercentM = Math.round((objWrpCls.Year4NumberM / objWrpCls.Year4NumberG) * 100);*/
                                
                                if(numberHY4 != 0)objWrpCls.Year4PercentH = ((numberHY4 / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(objWrpCls.Year4NumberI != 0)  objWrpCls.Year4PercentI = ((objWrpCls.Year4NumberI / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(numberJY4 != 0)objWrpCls.Year4PercentJ = ((numberJY4 / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(objWrpCls.Year4NumberK != 0) objWrpCls.Year4PercentK = ((objWrpCls.Year4NumberK / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(numberLY4 != 0)objWrpCls.Year4PercentL = ((NumberLY4 / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(objWrpCls.Year4NumberM != 0)objWrpCls.Year4PercentM = ((objWrpCls.Year4NumberM / objWrpCls.Year4NumberG) * 100).setScale(2);
                        	}
	                        	objWrpCls.YearF1=objWrpCls.Year1NumberF.format();
		                        objWrpCls.YearF2=objWrpCls.Year2NumberF.format();
		                        objWrpCls.YearF3=objWrpCls.Year3NumberF.format();
		                        objWrpCls.YearF4=objWrpCls.Year4NumberF.format();
		                        
		                        objWrpCls.YearG1=objWrpCls.Year1NumberG.format();
		                        objWrpCls.YearG2=objWrpCls.Year2NumberG.format();
		                        objWrpCls.YearG3=objWrpCls.Year3NumberG.format();
		                        objWrpCls.YearG4=objWrpCls.Year4NumberG.format();
		                        
		                        objWrpCls.YearI1=objWrpCls.Year1NumberI.format();
		                        objWrpCls.YearI2=objWrpCls.Year2NumberI.format();
		                        objWrpCls.YearI3=objWrpCls.Year3NumberI.format();
		                        objWrpCls.YearI4=objWrpCls.Year4NumberI.format(); 
		                        
		                        objWrpCls.YearK1=objWrpCls.Year1NumberK.format();
		                        objWrpCls.YearK2=objWrpCls.Year2NumberK.format();
		                        objWrpCls.YearK3=objWrpCls.Year3NumberK.format();
		                        objWrpCls.YearK4=objWrpCls.Year4NumberK.format();
		                        
		                        objWrpCls.YearM1=objWrpCls.Year1NumberM.format();
		                        objWrpCls.YearM2=objWrpCls.Year2NumberM.format();
		                        objWrpCls.YearM3=objWrpCls.Year3NumberM.format();
		                        objWrpCls.YearM4=objWrpCls.Year4NumberM.format(); 
                          }
                        /*TCS Requirement for 48:- Ended Here*/
                        //objWrpCls.lstPG = new List<Programmatic_Gap__c>();
                        //objWrpCls.lstPGHistory.AddAll(objCInd.ProgrammaticGapHistory);
                        objWrpCls.Name = objWrpCls.lstProgrammaticGap[0].objPGap.Program_Area__c;
                        objWrpCls.CoverageComments = objWrpCls.lstProgrammaticGap[0].objPGap.Coverage_Comments__c;
                        objWrpCls.KeyMetric = objWrpCls.lstProgrammaticGap[0].objPGap.Metric__c;
                        objWrpCls.GroupSequence = index;
                        objWrpCls.IndicatorName = objCInd.Full_Name_En__c;
                          if(objWrpCls.showLLIN != NULL)
                          if(objWrpCls.showLLIN) objWrpCls.IndicatorName = strLLINIndName;
                          if(strUserLanguage == 'FRENCH') objWrpCls.IndicatorName = objCInd.French_Name__c;
                          if(strUserLanguage == 'RUSSIAN') objWrpCls.IndicatorName = objCInd.Russian_Name__c;
                          if(strUserLanguage == 'SPANISH') objWrpCls.IndicatorName = objCInd.Spanish_Name__c;
                        objWrpCls.blndisplaySave = true;
                        objWrpCls.isShow = true;
                        lstWrapCls.Add(objWrpCls);
                        
                        
                        
						Index ++;
                    }
                    
                    if(lstWrapCls.size()>0){
                        
                    System.debug('**ListWrapperSize**');
                    blnSave = true;
                    }
                    
                   /*if(!setCatIndIds.contains(objCInd.Id)){                         
                    if(strUserLanguage == 'ENGLISH' && objCInd.Full_Name_En__c != null){                    
                            CIndOptions.add(new SelectOption(objCInd.Id,objCInd.Full_Name_En__c));                      
                     }
                    else if(strUserLanguage == 'FRENCH' && objCInd.French_Name__c != null){
                      CIndOptions.add(new SelectOption(objCInd.Id,objCInd.French_Name__c)); }
                    else if(strUserLanguage == 'SPANISH' && objCInd.Spanish_Name__c != null){
                      CIndOptions.add(new SelectOption(objCInd.Id,objCInd.Spanish_Name__c)); }
                    else if(strUserLanguage == 'RUSSIAN' && objCInd.Russian_Name__c != null){
                      CIndOptions.add(new SelectOption(objCInd.Id,objCInd.Russian_Name__c)); }
                   }*/
                    
                }
                
                    /*List<Indicator__c> lstAll = [Select Name, ID, Full_Name_En__c FROM Indicator__c Where
                                    //And Indicator_Type__c =: 'Coverage/Output'
                                    //And Available_for_PG__c = true
                                   ID NOT IN :setCatIndIds]; 
                    //if(strUserLanguage == 'ENGLISH' && objCInd.Full_Name_En__c != null){
                        for(Indicator__c p: lstAll)
                         {
                            CIndOptions.add(new SelectOption(p.ID,p.Full_Name_En__c));
                            System.debug('CIndOptions999'+CIndOptions);
                        }
                    else if(strUserLanguage == 'FRENCH' && objCInd.French_Name__c != null){
                      CIndOptions.add(new SelectOption(objCInd.Id,objCInd.French_Name__c)); }
                    else if(strUserLanguage == 'SPANISH' && objCInd.Spanish_Name__c != null){
                      CIndOptions.add(new SelectOption(objCInd.Id,objCInd.Spanish_Name__c)); }
                    else if(strUserLanguage == 'RUSSIAN' && objCInd.Russian_Name__c != null){
                      CIndOptions.add(new SelectOption(objCInd.Id,objCInd.Russian_Name__c)); }*/
                  
            }
            
        }
        objWrapClsStd = new wrapperClsModulePG();
        mapIdTowrap = new Map<Id,wrapperClsModulePG>();
        getPageText();
    }
    
    Public Void FillModules(String IndicatorId){
        /* TCS changes for Requirement# 48 , Requirement# 107 --Begin--*/
        List<Indicator__c> CIndicatorLLIN = [Select LLIN__c,IRS__c,Indicator_for_PG_Calculation_E__c FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                    And Indicator_Type__c =: 'Coverage/Output'
                                    And Available_for_PG__c = true
                                    And Id =: IndicatorId];
        if(CIndicatorLLIN.size()>0)
        {
            blnCIndicatorLLIN = CIndicatorLLIN[0].LLIN__c;
            blnCIndicatorIRS = CIndicatorLLIN[0].IRS__c;
            
        showNewE = CIndicatorLLIN[0].Indicator_for_PG_Calculation_E__c;}
        
        /* TCS changes for Requirement# 48 , Requirement# 107 --End--*/
        
        /* TCS changes for Requirement# 107 --Begin--
        System.debug('IndIdForE.Id_GP5__c ' +IndIdForE.Id_GP5__c);
        System.debug('IndIdForE.Id_VC6__c ' +IndIdForE.Id_VC6__c);
        System.debug('strComponent '+strComponent);
        System.debug('IndicatorId '+IndicatorId);
        
        if(IndicatorId ==IndIdForE.Id_GP5__c ||IndicatorId ==IndIdForE.Id_VC6__c ||strComponent =='Health Systems Strengthening')
        showNewE=true;
        else
        {showNewE=false;}
        TCS changes for Requirement# 107 --End--*/
        System.debug('Boolean'+showNewE);
        
        strLLINIndName = '';
        String TempstrLLINIndName = '';
        if(blnCIndicatorIRS)
        MapType.put(1,'A. Total households in the targeted areas');
        else
        {
        MapType.put(1,'A. Total estimated population in need/at risk (from National Strategic Plan)');  
            
        }
        
        MapType.put(2,'B. Country targets (from National Strategic Plan)');//Text Changed on 11 Aug 2014 as a CR 
        MapType.put(3,'C. Country need planned to be covered by domestic & other sources');
       // MapType.put(4,'D. Country need already covered by other existing Global Fund grants'); //Removed for Requirement #107- 5(553045)(Also From Picklist)
        MapType.put(4,'D. Expected annual gap in meeting the need');
        MapType.put(5,'E. Targets to be financed by allocation amount');
        MapType.put(6,'F. Coverage from Allocation amount and other resources');
        MapType.put(7,'G. Targets to be potentially financed by above allocation amount');
        MapType.put(8,'H. Total coverage (allocation amount, above allocation amount and other resources)');
        
        /* TCS changes for Requirement# 48 --Begin--*/
        MapTypeForLLIN.put(1,'A.Estimated population in campaign areas');
        
        // Removed below three rows for Change Request for Programmatic Gap Tables(553045) 
       /* MapTypeForLLIN.put(2,'2.Estimated pregnant women to be reached through ANC in all malaria areas');
        MapTypeForLLIN.put(3,'3.Estimated children under 1 in all malaria areas reached through EPI clinics');         
        MapTypeForLLIN.put(4,'A. Country targets for population coverage (from national strategic plan )');     
        */
        MapTypeForLLIN.put(2,'B. LLINs required for mass campaign');
        MapTypeForLLIN.put(3,'C. LLINs required for distribution through ANC');
        MapTypeForLLIN.put(4,'D. LLINs required for distribution through EPI');
        MapTypeForLLIN.put(5,'E. LLINs to be distributed using other methods of distribution, such as community or school-based distribution');
        MapTypeForLLIN.put(6,'F. Total LLINs required for non-mass campaign distribution:');
        MapTypeForLLIN.put(7,'G. Total number of LLINs required (mass campaign + nonmass campaign):');
        MapTypeForLLIN.put(8,'H.Country need planned to be covered by domestic & other sources');
        MapTypeForLLIN.put(9,'I. Expected annual gap in meeting the need:');
        MapTypeForLLIN.put(10,'J. LLINs to be financed by allocation amount');
        MapTypeForLLIN.put(11,'K. LLINs to be financed from allocation amountand other resources:');
        MapTypeForLLIN.put(12,'L. LLINs to be potentially financed by above allocation amount ');
        MapTypeForLLIN.put(13,'M. Total LLINs allocation amount,above allocation amount and other resources):');         
        
        //Decimal MapSize;
        if(blnCIndicatorLLIN)
        MapSize = MapTypeForLLIN.size();
        else
        MapSize = MapType.size();
        
        objWrapClsStd = new wrapperClsModulePG();
        
        /*lstWrapCls = new List<wrapperClsModulePG>();
        List<Programmatic_Gap__c> lstSavedProgrammatic = [SELECT Id, Name,Group_Sequence__c ,Metric__c ,Current_Coverage__c,Current_Coverage_per__c,LFA_Comments__c,Coverage_Comments__c,Module__c,Global_Fund_Comments__c,
                                                         Year_1__c ,Year_2__c ,CCM_Comments__c ,Year_3__c,Year_4__c, Specification__c,Assumptions__c,Program_Area__c,Type__c,Year_1_per__c,Year_2_per__c,Year_3_per__c,Year_4_per__c
                                                         FROM Programmatic_Gap__c where Concept_Note__c =: ConceptNoteId order by Group_Sequence__c,Sequence__c asc];
        
        Map<Decimal,List<Programmatic_Gap__c>> mapModulePG = new Map<Decimal,List<Programmatic_Gap__c>>();
        
        for(decimal moduleNum=0;moduleNum<9;moduleNum++){
            mapModulePG.put(moduleNum,new List<Programmatic_Gap__c>());
        }                                         
                   
        for(Programmatic_Gap__c objPG:lstSavedProgrammatic){
            If(mapModulePG.ContainsKey(objPG.Group_Sequence__c)){
                mapModulePG.get(objPG.Group_Sequence__c).Add(objPG);
            }Else{
                List<Programmatic_Gap__c> lstPG = new List<Programmatic_Gap__c>();
                lstPG.Add(objPG);
                mapModulePG.put(objPG.Group_Sequence__c,lstPG);
            }
        }
        Integer i=0;
        //for(decimal index:mapModulePG.keyset()){ 
        
        String IndicatorId_new = IndicatorId;*/
         
        
                 
        /*List<Grant_Indicator__c> lstCatIndicators_new = [Select Id,Name,Indicator_Full_Name__c FROM Grant_Indicator__c where id=:IndicatorId_new]; //Parent_Module__c =:strModuleId and Available_For_PG__C = true
        if(!lstCatIndicators_new.isEmpty())
        {
        for(integer index=0;index<lstCatIndicators_new.size();index++){ */
            
            //objWrapClsStd.lstProgrammaticGap = new List<Programmatic_Gap__c>();
            objWrapClsStd.lstProgrammaticGap = new List<ProgrammaticGap>();
            objWrapClsStd.objGI = new Grant_indicator__c();
            objWrapClsStd.objGI.Component__c = strComponent;
            //List<Grant_Indicator__c> lstGI = [Select ID,Name From Grant_Indicator__c Where Indicator__c =: IndicatorId And Parent_Module__c =: strModuleId Limit 1];
            //if(lstGI.size() > 0){
               if(blnCIndicatorLLIN)
               {
                LLIN=true;
                PGToInsertLLIN = new List<Programmatic_Gap__c>();
                  for(Indicator__c allLLIN: lstAllLLINforModule) 
                   {
                    for(Decimal TypeIndex=1;TypeIndex<=MapSize;TypeIndex++){
                    System.debug('MapSize IF '+MapSize);   
                    
                   
                    Programmatic_Gap__c objPG = new Programmatic_Gap__c(Type__c = MapTypeForLLIN.get(TypeIndex),Sequence__c = TypeIndex,Concept_Note__c = ConceptNoteId,Catalog_Indicator__c = allLLIN.Id);
                    
                    //objWrapClsStd.objGI = new Grant_indicator__c(Id = lstGI[0].Id);
                    /*objWrapperClsModulePG.lstPG[index].Type__c = MapType.get(TypeIndex);
                    objWrapperClsModulePG.lstPG[index].Sequence__c = TypeIndex;
                    if(String.isblank(ConceptNoteId) == false)
                    objWrapperClsModulePG.lstPG[index].Concept_Note__c = ConceptNoteId;
                    objWrapperClsModulePG.lstPG[index].Indicator__c = lstCatIndicators_new[index].id;
                     System.debug ('The Indicator is ' +lstCatIndicators_new[index].id);*/
                    ProgrammaticGap objPGap = new ProgrammaticGap();
                    objPGap.objPGap = objPG;
                    //objWrapClsStd.lstPG.Add(objPG);
                        if(allLLIN.Id==IndicatorId)
                        {
                        objWrapClsStd.lstProgrammaticGap.Add(objPGap);
                        }
                        else
                        {
                        PGToInsertLLIN.add(objPG);
                        }
                    }
                  
                            if(strUserLanguage == 'ENGLISH' && allLLIN.Full_Name_En__c != null)
                                TempstrLLINIndName=  TempstrLLINIndName + '<br>-' +allLLIN.Full_Name_En__c + '';
                                
                            else if(strUserLanguage == 'FRENCH' && allLLIN.French_Name__c != null)
                                TempstrLLINIndName=  TempstrLLINIndName + '<br>-' +allLLIN.French_Name__c + ',';
                            else if(strUserLanguage == 'SPANISH' && allLLIN.Spanish_Name__c != null)
                                TempstrLLINIndName=  TempstrLLINIndName + '<br> ' +allLLIN.Spanish_Name__c + ',';
                            else if(strUserLanguage == 'RUSSIAN' && allLLIN.Russian_Name__c != null)
                                TempstrLLINIndName=  TempstrLLINIndName + '<br>' +allLLIN.Russian_Name__c + ',';
                  
                  }
               
                 strLLINIndName  = TempstrLLINIndName;
               } /* TCS changes for Requirement# 48 --End--*/
               else
                 {
                    for(Decimal TypeIndex=1;TypeIndex<=MapSize;TypeIndex++){
                    System.debug('MapSize Else '+MapSize);   
                    
                    Programmatic_Gap__c objPG = new Programmatic_Gap__c(Type__c = MapType.get(TypeIndex),Sequence__c = TypeIndex,Concept_Note__c = ConceptNoteId,Catalog_Indicator__c = IndicatorId);
                    //objWrapClsStd.objGI = new Grant_indicator__c(Id = lstGI[0].Id);
                    /*objWrapperClsModulePG.lstPG[index].Type__c = MapType.get(TypeIndex);
                    objWrapperClsModulePG.lstPG[index].Sequence__c = TypeIndex;
                    if(String.isblank(ConceptNoteId) == false)
                    objWrapperClsModulePG.lstPG[index].Concept_Note__c = ConceptNoteId;
                    objWrapperClsModulePG.lstPG[index].Indicator__c = lstCatIndicators_new[index].id;
                     System.debug ('The Indicator is ' +lstCatIndicators_new[index].id);*/
                    ProgrammaticGap objPGap = new ProgrammaticGap();
                    objPGap.objPGap = objPG;
                    //objWrapClsStd.lstPG.Add(objPG);
                    
                    objWrapClsStd.lstProgrammaticGap.Add(objPGap);
                    
                }
                 }
           // }
           
            objWrapClsStd.isShow = true;
            /*objWrpCls.Name = lstPG1[0].Program_Area__c;
            objWrpCls.CoverageComments = lstPG1[0].Coverage_Comments__c;
            objWrpCls.KeyMetric = lstPG1[0].Metric__c;
            objWrpCls.GroupSequence = index;*/
            
            for(SelectOption obj : CIndOptions){
                if(obj.getValue() == IndicatorId){
                    if(blnCIndicatorLLIN){
                    objWrapClsStd.IndicatorName = strLLINIndName;
                    }
                    else{
                    objWrapClsStd.IndicatorName = obj.getLabel();
                    }
                }
            }
            
            /*for(SelectOption obj : CatalogIndicatorOptions){
                if(obj.getValue() == IndicatorId){
                    objWrapClsStd.IndicatorName = obj.getLabel();
                }
            }*/
            
            
            
            /*objWrpCls.lstPG = lstPG1;
            
            System.debug('The list of programmatic gap records is ' + lstPG1);
            
            if(i==0){
                objWrpCls.isShow=true;
                i++;
            }*/
            //lstWrapCls.Add(objWrpCls);
            
            System.Debug ('The wrapper class is '+lstWrapCls);
            /*TCS Changes for Cycle value Display Starts*/
            MapDisplayMonth = new Map<String,String>();
            MapDisplayMonth.put('January','01');
            MapDisplayMonth.put('February','02');
            MapDisplayMonth.put('March','03');
            MapDisplayMonth.put('April','04');
            MapDisplayMonth.put('May','05');
            MapDisplayMonth.put('June','06');
            MapDisplayMonth.put('July','07');
            MapDisplayMonth.put('August','08');
            MapDisplayMonth.put('September','09');
            MapDisplayMonth.put('October','10');
            MapDisplayMonth.put('November','11');
            MapDisplayMonth.put('December','12');
           
            System.debug('**Strselected**'+objModuleToUpdateCycle.PG_Cycle__c);
             if(objModuleToUpdateCycle.PG_Cycle__c != null){
                list<String> lstSplitMonth = objModuleToUpdateCycle.PG_Cycle__c.split(' - ');
                String StartMonth = lstSplitMonth[0];
                String EndMonth = lstSplitMonth[1];               
                
                strStartMonth = MapDisplayMonth.get(StartMonth);
                system.debug('$$$$$$'+strStartMonth);
                strEndMonth = MapDisplayMonth.get(EndMonth);
                if(objModuleToUpdateCycle.Concept_Note__r.Number_of_Years__c != null){
                    if(objModuleToUpdateCycle.Concept_Note__r.Number_of_Years__c == '4' && objModuleToUpdateCycle.Concept_Note__r.Year_4__c!=null){
                        integer ConceptNoteYear = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c)+1;
                        //integer LastMonth = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c  + 1);
                        if(ConceptNoteYear != null) intLastMonth = String.valueof(ConceptNoteYear);
                        system.debug('#$#$#$#$#$#$'+intLastMonth);
                    }else if(objModuleToUpdateCycle.Concept_Note__r.Year_3__c != null){
                        
                        integer ConceptNoteYear =integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_3__c)+1;
                        system.debug('#$#$#$#$#$#$'+ConceptNoteYear);
                        //intLastMonth = objModuleToUpdateCycle.Concept_Note__r.Year_3__c +1 ;
                        intLastMonth = string.valueof(ConceptNoteYear);
                        system.debug('#$#$#$#$#$#$'+intLastMonth);
                    }
                }else{
                    if(objModuleToUpdateCycle.Concept_Note__r.Year_3__c != null){
                        
                        integer ConceptNoteYear =integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_3__c)+1;
                        system.debug('#$#$#$#$#$#$'+ConceptNoteYear);
                        //intLastMonth = objModuleToUpdateCycle.Concept_Note__r.Year_3__c +1 ;
                        intLastMonth = string.valueof(ConceptNoteYear);
                        system.debug('#$#$#$#$#$#$'+intLastMonth);
                    }
                }
            }else{
                
                if(objModuleToUpdateCycle.Concept_Note__r.Number_of_Years__c == '4' && objModuleToUpdateCycle.Concept_Note__r.Year_4__c!=null){
                    integer ConceptNoteYear = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c)+1;
                    //integer LastMonth = integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_4__c  + 1);
                    if(ConceptNoteYear != null) intLastMonth = String.valueof(ConceptNoteYear);
                    
                }else if(objModuleToUpdateCycle.Concept_Note__r.Year_3__c != null){
                    integer ConceptNoteYear =integer.valueof(objModuleToUpdateCycle.Concept_Note__r.Year_3__c)+1;
                    intLastMonth = string.valueof(ConceptNoteYear);
                    //intLastMonth = objModuleToUpdateCycle.Concept_Note__r.Year_3__c +1 ;
                }
            }
           
       //update objModuleToUpdateCycle;
       System.debug('**Strselected**'+objModuleToUpdateCycle.PG_Cycle__c);
       /*TCS Changes for Cycle value Display Ends*/ 
    
    }
      //Display History
    Public Integer intHistoryIndicator {get;set;}
    Public Integer intHistoryProGap {get;set;}
    Public void ShowHistoryPopup(){
        intHistoryIndicator = integer.valueof(apexpages.currentpage().getparameters().get('HistoryIndiIndex'));
        intHistoryProGap = integer.valueof(apexpages.currentpage().getparameters().get('HistoryPrograGap'));
        system.debug('index:'+ intHistoryIndicator );
        if(intHistoryIndicator!= null){
            //system.debug('blnvar:'+ lstWrapCls[intHistoryIndicator].lstPG.blnHistory);
            lstWrapCls[intHistoryIndicator].lstProgrammaticGap[intHistoryProGap].blnHistory = true;
            //system.debug('Bln:'+ lstWrapCls[intHistoryIndicator].blnHistory);
        }
    }
    //History Popup Close
    public void HidePopupHistory()
    {  
        
        if (intHistoryIndicator > -1) {
           lstWrapCls[intHistoryIndicator].lstProgrammaticGap[intHistoryProGap].blnHistory = false;
        }
    }
    
    /*TCS Changes for Edit Cycle On Edit Click*/
    public void Edit_Cycle()
     {
       blnEdit = false;
     }
    
    
    Public void EditProg_Gap(){
        Integer EditIndiIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndiIndex'));
        if(EditIndiIndex != null){
            
            wrapperClsModulePG objwrapperClsModulePGTemp = new wrapperClsModulePG();
            //objwrapperClsModulePGTemp.objGI = lstWrapCls[EditIndiIndex].objGI.clone(true);
            objwrapperClsModulePGTemp.objCI =   lstWrapCls[EditIndiIndex].objCI.clone(true);
            objwrapperClsModulePGTemp.blnIndicatorDisplay   =   lstWrapCls[EditIndiIndex].blnIndicatorDisplay;
            objwrapperClsModulePGTemp.blndisplaySave    =   lstWrapCls[EditIndiIndex].blndisplaySave;
            objwrapperClsModulePGTemp.IndicatorName =   lstWrapCls[EditIndiIndex].IndicatorName;
            objwrapperClsModulePGTemp.GroupSequence =   lstWrapCls[EditIndiIndex].GroupSequence;
            objwrapperClsModulePGTemp.Name  =   lstWrapCls[EditIndiIndex].Name;
            objwrapperClsModulePGTemp.KeyMetric =   lstWrapCls[EditIndiIndex].KeyMetric;
            objwrapperClsModulePGTemp.CoverageComments  =   lstWrapCls[EditIndiIndex].CoverageComments;
            List<ProgrammaticGap> lstProgrammaticGapTemp = new List<ProgrammaticGap>();
            for(ProgrammaticGap objPG : lstWrapCls[EditIndiIndex].lstProgrammaticGap){
                ProgrammaticGap objPGWrap = new ProgrammaticGap();
                objPGWrap.objPGap = objPG.objPGap.clone(true);
                objPGWrap.blnHistory = objPG.blnHistory;
                lstProgrammaticGapTemp.add(objPGWrap);
            }
            objwrapperClsModulePGTemp.lstProgrammaticGap    =  lstProgrammaticGapTemp;
            /*TCS Changes for requirement 48 Starts */
            if(lstWrapCls[EditIndiIndex].objCI.LLIN__c == false){
            objwrapperClsModulePGTemp.Year1NumberE  =   lstWrapCls[EditIndiIndex].Year1NumberE;
            objwrapperClsModulePGTemp.Year1PercentE =   lstWrapCls[EditIndiIndex].Year1PercentE;
            objwrapperClsModulePGTemp.Year1NumberG  =   lstWrapCls[EditIndiIndex].Year1NumberG;
            objwrapperClsModulePGTemp.Year1PercentG =   lstWrapCls[EditIndiIndex].Year1PercentG;
            objwrapperClsModulePGTemp.Year1NumberI  =   lstWrapCls[EditIndiIndex].Year1NumberI;
            objwrapperClsModulePGTemp.Year1PercentI =   lstWrapCls[EditIndiIndex].Year1PercentI;
            objwrapperClsModulePGTemp.Year2NumberE  =   lstWrapCls[EditIndiIndex].Year2NumberE;
            objwrapperClsModulePGTemp.Year2PercentE =   lstWrapCls[EditIndiIndex].Year2PercentE;
            objwrapperClsModulePGTemp.Year2NumberG  =   lstWrapCls[EditIndiIndex].Year2NumberG;
            objwrapperClsModulePGTemp.Year2PercentG =   lstWrapCls[EditIndiIndex].Year2PercentG;
            objwrapperClsModulePGTemp.Year2NumberI  =   lstWrapCls[EditIndiIndex].Year2NumberI;
            objwrapperClsModulePGTemp.Year2PercentI =   lstWrapCls[EditIndiIndex].Year2PercentI;
            objwrapperClsModulePGTemp.Year3NumberE  =   lstWrapCls[EditIndiIndex].Year3NumberE;
            objwrapperClsModulePGTemp.Year3PercentE =   lstWrapCls[EditIndiIndex].Year3PercentE;
            objwrapperClsModulePGTemp.Year3NumberG  =   lstWrapCls[EditIndiIndex].Year3NumberG;
            objwrapperClsModulePGTemp.Year3PercentG =   lstWrapCls[EditIndiIndex].Year3PercentG;
            objwrapperClsModulePGTemp.Year3NumberI  =   lstWrapCls[EditIndiIndex].Year3NumberI;
            objwrapperClsModulePGTemp.Year3PercentI =   lstWrapCls[EditIndiIndex].Year3PercentI;
            objwrapperClsModulePGTemp.Year4NumberE  =   lstWrapCls[EditIndiIndex].Year4NumberE;
            objwrapperClsModulePGTemp.Year4PercentE =   lstWrapCls[EditIndiIndex].Year4PercentE;
            objwrapperClsModulePGTemp.Year4NumberG  =   lstWrapCls[EditIndiIndex].Year4NumberG;
            objwrapperClsModulePGTemp.Year4PercentG =   lstWrapCls[EditIndiIndex].Year4PercentG;
            objwrapperClsModulePGTemp.Year4NumberI  =   lstWrapCls[EditIndiIndex].Year4NumberI;
            objwrapperClsModulePGTemp.Year4PercentI =   lstWrapCls[EditIndiIndex].Year4PercentI;
            }else {
            objwrapperClsModulePGTemp.Year1NumberD  =   lstWrapCls[EditIndiIndex].Year1NumberD;
            objwrapperClsModulePGTemp.Year1NumberF  =   lstWrapCls[EditIndiIndex].Year1NumberF;
            objwrapperClsModulePGTemp.Year1NumberG  =   lstWrapCls[EditIndiIndex].Year1NumberG;
            objwrapperClsModulePGTemp.Year1PercentH =   lstWrapCls[EditIndiIndex].Year1PercentH;
            objwrapperClsModulePGTemp.Year1NumberI  =   lstWrapCls[EditIndiIndex].Year1NumberI;
            objwrapperClsModulePGTemp.Year1PercentI =   lstWrapCls[EditIndiIndex].Year1PercentI;
            objwrapperClsModulePGTemp.Year1PercentJ =   lstWrapCls[EditIndiIndex].Year1PercentJ;
            objwrapperClsModulePGTemp.Year1NumberK  =   lstWrapCls[EditIndiIndex].Year1NumberK;
            objwrapperClsModulePGTemp.Year1PercentK =   lstWrapCls[EditIndiIndex].Year1PercentK;
            objwrapperClsModulePGTemp.Year1PercentL =   lstWrapCls[EditIndiIndex].Year1PercentL;
            objwrapperClsModulePGTemp.Year1NumberM  =   lstWrapCls[EditIndiIndex].Year1NumberM;
            objwrapperClsModulePGTemp.Year1PercentM =   lstWrapCls[EditIndiIndex].Year1PercentM;
            objwrapperClsModulePGTemp.Year2NumberD  =   lstWrapCls[EditIndiIndex].Year2NumberD;
            objwrapperClsModulePGTemp.Year2NumberF  =   lstWrapCls[EditIndiIndex].Year2NumberF;
            objwrapperClsModulePGTemp.Year2NumberG  =   lstWrapCls[EditIndiIndex].Year2NumberG;
            objwrapperClsModulePGTemp.Year2PercentH =   lstWrapCls[EditIndiIndex].Year2PercentH;
            objwrapperClsModulePGTemp.Year2NumberI  =   lstWrapCls[EditIndiIndex].Year2NumberI;
            objwrapperClsModulePGTemp.Year2PercentI =   lstWrapCls[EditIndiIndex].Year2PercentI;
            objwrapperClsModulePGTemp.Year2PercentJ =   lstWrapCls[EditIndiIndex].Year2PercentJ;
            objwrapperClsModulePGTemp.Year2NumberK  =   lstWrapCls[EditIndiIndex].Year2NumberK;
            objwrapperClsModulePGTemp.Year2PercentK =   lstWrapCls[EditIndiIndex].Year2PercentK;
            objwrapperClsModulePGTemp.Year2PercentL =   lstWrapCls[EditIndiIndex].Year2PercentL;
            objwrapperClsModulePGTemp.Year2NumberM  =   lstWrapCls[EditIndiIndex].Year2NumberM;
            objwrapperClsModulePGTemp.Year2PercentM =   lstWrapCls[EditIndiIndex].Year2PercentM;
            objwrapperClsModulePGTemp.Year3NumberD  =   lstWrapCls[EditIndiIndex].Year3NumberD;
            objwrapperClsModulePGTemp.Year3NumberF  =   lstWrapCls[EditIndiIndex].Year3NumberF;
            objwrapperClsModulePGTemp.Year3NumberG  =   lstWrapCls[EditIndiIndex].Year3NumberG;
            objwrapperClsModulePGTemp.Year3PercentH =   lstWrapCls[EditIndiIndex].Year3PercentH;
            objwrapperClsModulePGTemp.Year3NumberI  =   lstWrapCls[EditIndiIndex].Year3NumberI;
            objwrapperClsModulePGTemp.Year3PercentI =   lstWrapCls[EditIndiIndex].Year3PercentI;
            objwrapperClsModulePGTemp.Year3PercentJ =   lstWrapCls[EditIndiIndex].Year3PercentJ;
            objwrapperClsModulePGTemp.Year3NumberK  =   lstWrapCls[EditIndiIndex].Year3NumberK;
            objwrapperClsModulePGTemp.Year3PercentK =   lstWrapCls[EditIndiIndex].Year3PercentK;
            objwrapperClsModulePGTemp.Year3PercentL =   lstWrapCls[EditIndiIndex].Year3PercentL;
            objwrapperClsModulePGTemp.Year3NumberM  =   lstWrapCls[EditIndiIndex].Year3NumberM;
            objwrapperClsModulePGTemp.Year3PercentM =   lstWrapCls[EditIndiIndex].Year3PercentM;
            objwrapperClsModulePGTemp.Year4NumberD  =   lstWrapCls[EditIndiIndex].Year4NumberD;
            objwrapperClsModulePGTemp.Year4NumberF  =   lstWrapCls[EditIndiIndex].Year4NumberF;
            objwrapperClsModulePGTemp.Year4NumberG  =   lstWrapCls[EditIndiIndex].Year4NumberG;
            objwrapperClsModulePGTemp.Year4PercentH =   lstWrapCls[EditIndiIndex].Year4PercentH;
            objwrapperClsModulePGTemp.Year4NumberI  =   lstWrapCls[EditIndiIndex].Year4NumberI;
            objwrapperClsModulePGTemp.Year4PercentI =   lstWrapCls[EditIndiIndex].Year4PercentI;
            objwrapperClsModulePGTemp.Year4PercentJ =   lstWrapCls[EditIndiIndex].Year4PercentJ;
            objwrapperClsModulePGTemp.Year4NumberK  =   lstWrapCls[EditIndiIndex].Year4NumberK;
            objwrapperClsModulePGTemp.Year4PercentK =   lstWrapCls[EditIndiIndex].Year4PercentK;
            objwrapperClsModulePGTemp.Year4PercentL =   lstWrapCls[EditIndiIndex].Year4PercentL;
            objwrapperClsModulePGTemp.Year4NumberM  =   lstWrapCls[EditIndiIndex].Year4NumberM;
            objwrapperClsModulePGTemp.Year4PercentM =   lstWrapCls[EditIndiIndex].Year4PercentM;
            }/*TCS Changes for requirement 48 End */
            objwrapperClsModulePGTemp.isShow    =   lstWrapCls[EditIndiIndex].isShow;
            system.debug('#$#$#$#$#$#$'+lstWrapCls[EditIndiIndex].objCI.Id);
            mapIdTowrap.put(lstWrapCls[EditIndiIndex].objCI.Id,objwrapperClsModulePGTemp);
            lstWrapCls[EditIndiIndex].blndisplaySave = false;
            /* TCS changes for Requirement# 107 --Begin--*/
            //if(lstWrapCls[EditIndiIndex].objCI.Indicator_for_PG_Calculation_E__c)
            showNewE=lstWrapCls[EditIndiIndex].objCI.Indicator_for_PG_Calculation_E__c;
            /* TCS changes for Requirement# 107 --End--*/
        }
    }
    Public void CancelGrantIndicatorResult(){
        Integer CancelIndiIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndiIndex'));
        if(CancelIndiIndex != null){
            
            system.debug('#$#$#$#$#$#$'+lstWrapCls[CancelIndiIndex].objCI.Id);
            Id CIID = lstWrapCls[CancelIndiIndex].objCI.Id;
            lstWrapCls[CancelIndiIndex] = new wrapperClsModulePG();
            lstWrapCls[CancelIndiIndex] = mapIdTowrap.get(CIID);
            
            lstWrapCls[CancelIndiIndex].blndisplaySave = true;
        }
    } 
    Public void SaveGrantIndicatorResult(){
              
        //Integer SaveIndiIndex; = integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndiIndex'));
        system.debug('**param val**'+SaveIndiIndex);
     
        /*if(SaveIndiIndex != null){
            for(Programmatic_Gap__c objPG : lstWrapCls[SaveIndiIndex].lstPG){
                objPG.Baseline_Source__c = lstWrapCls[SaveIndiIndex].lstPG[0].Baseline_Source__c;
                objPG.Baseline_year__c = lstWrapCls[SaveIndiIndex].lstPG[0].Baseline_year__c;
                objPG.Baseline_value__c = lstWrapCls[SaveIndiIndex].lstPG[0].Baseline_value__c;
                objPG.Rationale_for_Chosen_Indicator__c = lstWrapCls[SaveIndiIndex].lstPG[0].Rationale_for_Chosen_Indicator__c;
            }
            update lstWrapCls[SaveIndiIndex].lstPG;
            lstWrapCls[SaveIndiIndex].blndisplaySave = true;
        }*/
        //objWrpCls.KeyMetric = objWrpCls.lstPGHistory[0].objPGap.Metric__c;
        if(SaveIndiIndex != null){
            if(mapIdTowrap.ContainsKey(lstWrapCls[SaveIndiIndex].objCI.id)){
                mapIdTowrap.remove(lstWrapCls[SaveIndiIndex].objCI.id);
            }
            Decimal numberA = 0;
            Decimal numberC = 0;
            Decimal numberD = 0;
            Decimal numberF = 0;
            Decimal numberH = 0;
            Decimal PercentA = 0;
            Decimal PercentC = 0;
            Decimal PercentD = 0;
            Decimal PercentF = 0;
            Decimal PercentH = 0;
             //TCS defined for Req #48
            Decimal numberB = 0;
            Decimal numberE = 0;
            Decimal numberJ = 0;
            Decimal numberL = 0;
            Decimal PercentB = 0;
            Decimal PercentE = 0;
            Decimal PercentJ = 0;
            Decimal PercentL = 0;
            Decimal PercentG = 0;
            
            Decimal numberAY2 = 0;
            Decimal numberCY2 = 0;
            Decimal numberDY2 = 0;
            Decimal numberFY2 = 0;
            Decimal numberHY2 = 0;
            Decimal PercentAY2 = 0;
            Decimal PercentCY2 = 0;
            Decimal PercentDY2 = 0;
            Decimal PercentFY2 = 0;
            Decimal PercentHY2 = 0;
             //TCS defined for Req #48
            Decimal numberBY2 = 0;
            Decimal numberEY2 = 0;
            Decimal numberJY2 = 0;
            Decimal numberLY2 = 0;
            Decimal PercentBY2 = 0;
            Decimal PercentEY2 = 0;
            Decimal PercentJY2 = 0;
            Decimal PercentLY2 = 0;
            Decimal PercentGY2 = 0;
            
            Decimal numberAY3 = 0;
            Decimal numberCY3 = 0;
            Decimal numberDY3 = 0;
            Decimal numberFY3 = 0;
            Decimal numberHY3 = 0;
            Decimal PercentAY3 = 0;
            Decimal PercentCY3 = 0;
            Decimal PercentDY3 = 0;
            Decimal PercentFY3 = 0;
            Decimal PercentHY3 = 0;
            //TCS defined for Req #48
            Decimal numberBY3 = 0;
            Decimal numberEY3 = 0;
            Decimal numberJY3 = 0;
            Decimal numberLY3 = 0;
            Decimal PercentBY3 = 0;
            Decimal PercentEY3 = 0;
            Decimal PercentJY3 = 0;
            Decimal PercentLY3 = 0;
            Decimal PercentGY3 = 0;
                        
            Decimal numberAY4 = 0;
            Decimal numberCY4 = 0;
            Decimal numberDY4 = 0;
            Decimal numberFY4 = 0;
            Decimal numberHY4 = 0;
            Decimal PercentAY4 = 0;
            Decimal PercentCY4 = 0;
            Decimal PercentDY4 = 0;
            Decimal PercentFY4 = 0;
            Decimal PercentHY4 = 0;
            //TCS defined for Req #48
            Decimal numberBY4 = 0;
            Decimal numberEY4 = 0;
            Decimal numberJY4 = 0;
            Decimal numberLY4 = 0;
            Decimal PercentBY4 = 0;
            Decimal PercentEY4 = 0;
            Decimal PercentJY4 = 0;
            Decimal PercentLY4 = 0;
            Decimal PercentGY4 = 0;
            
                        
            List<Programmatic_Gap__c> PGToUpdate = new List<Programmatic_Gap__c>();
            Map<String,Programmatic_Gap__c> mapToUpdate = new Map<String,Programmatic_Gap__c>();
            
               for(ProgrammaticGap objPG : lstWrapCls[SaveIndiIndex].lstProgrammaticGap){
                objPG.objPGap.Baseline_Source__c = lstWrapCls[SaveIndiIndex].lstProgrammaticGap[0].objPGap.Baseline_Source__c;
                objPG.objPGap.Baseline_year__c = lstWrapCls[SaveIndiIndex].lstProgrammaticGap[0].objPGap.Baseline_year__c;
                objPG.objPGap.Baseline_value__c = lstWrapCls[SaveIndiIndex].lstProgrammaticGap[0].objPGap.Baseline_value__c;
                objPG.objPGap.Specify_Text__c = lstWrapCls[SaveIndiIndex].lstProgrammaticGap[0].objPGap.Specify_Text__c; //TCS change for Specify_Text__c
                system.debug('objPG.objPGap.Specify_Text__c'+objPG.objPGap.Specify_Text__c);
                objPG.objPGap.Coverage_Text__c = lstWrapCls[SaveIndiIndex].lstProgrammaticGap[0].objPGap.Coverage_Text__c;//TCS change for Coverage_Text__c
                objPG.objPGap.Rationale_for_Chosen_Indicator__c = lstWrapCls[SaveIndiIndex].lstProgrammaticGap[0].objPGap.Rationale_for_Chosen_Indicator__c;
                //objPG.objPGap.Id= PGToUpdateLLIN[k].Id;
                
                /*TCS Changes for Req 48 Starts*/
                 if(lstWrapCls[SaveIndiIndex].objCI.LLIN__c  == false) {
                //--TCS - 09/05/2014- Initialized fields to zero for Programmatic Gap of type D
               /* if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.year_1__c = setToZero;
                if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.year_2__c = setToZero;
                if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.year_3__c = setToZero;
                if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.year_4__c = setToZero;
                
                if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.Year_1_per__c = setToZero;
                if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.Year_2_per__c = setToZero;
                if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.Year_3_per__c = setToZero;
                if(objPG.objPGap.Type_Formula__c == 'D' ) objPG.objPGap.Year_4_per__c = setToZero; */
                
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.year_1__c != null) numberA = objPG.objPGap.year_1__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_1__c != null) numberB = objPG.objPGap.year_1__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_1__c != null) numberC = objPG.objPGap.year_1__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_1__c != null) numberD = objPG.objPGap.year_1__c;
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.year_1__c != null) numberF = objPG.objPGap.year_1__c;
               // if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_1__c != null) numberH = objPG.objPGap.year_1__c;
                
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_1_per__c!= null) PercentA = objPG.objPGap.Year_1_per__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.Year_1_per__c!= null) PercentB = objPG.objPGap.Year_1_per__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.Year_1_per__c!= null) PercentC = objPG.objPGap.Year_1_per__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.Year_1_per__c!= null) PercentD = objPG.objPGap.Year_1_per__c;
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_1_per__c!= null) PercentF = objPG.objPGap.Year_1_per__c;
               // if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.Year_1_per__c!= null) PercentH = objPG.objPGap.Year_1_per__c;
                
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.year_2__c != null) numberAY2 = objPG.objPGap.year_2__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_2__c != null) numberBY2 = objPG.objPGap.year_2__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_2__c != null) numberCY2 = objPG.objPGap.year_2__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_2__c != null) numberDY2 = objPG.objPGap.year_2__c;
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.year_2__c != null) numberFY2 = objPG.objPGap.year_2__c;
                //if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_2__c != null) numberHY2 = objPG.objPGap.year_2__c;
                
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_2_per__c!= null) PercentAY2 = objPG.objPGap.Year_2_per__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.Year_2_per__c!= null) PercentBY2 = objPG.objPGap.Year_2_per__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.Year_2_per__c!= null) PercentCY2 = objPG.objPGap.Year_2_per__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.Year_2_per__c!= null) PercentDY2 = objPG.objPGap.Year_2_per__c;
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_2_per__c!= null) PercentFY2 = objPG.objPGap.Year_2_per__c;
                //if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.Year_2_per__c!= null) PercentHY2 = objPG.objPGap.Year_2_per__c;
                
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.year_3__c != null) numberAY3 = objPG.objPGap.year_3__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_3__c != null) numberBY3 = objPG.objPGap.year_3__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_3__c != null) numberCY3 = objPG.objPGap.year_3__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_3__c != null) numberDY3 = objPG.objPGap.year_3__c;
                system.debug('one- condtion ABC'+ (objPG.objPGap.Type_Formula__c));
                system.debug('one- condtion KBC'+ (objPG.objPGap.year_3__c));
                system.debug('number E '+numberDY3);
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.year_3__c != null) numberFY3 = objPG.objPGap.year_3__c;
                //if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_3__c != null) numberHY3 = objPG.objPGap.year_3__c;
                system.debug('number G '+numberFY3);
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_3_per__c!= null) PercentAY3 = objPG.objPGap.Year_3_per__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.Year_3_per__c!= null) PercentBY3 = objPG.objPGap.Year_3_per__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.Year_3_per__c!= null) PercentCY3 = objPG.objPGap.Year_3_per__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.Year_3_per__c!= null) PercentDY3 = objPG.objPGap.Year_3_per__c;
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_3_per__c!= null) PercentFY3 = objPG.objPGap.Year_3_per__c;
                //if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.Year_3_per__c!= null) PercentHY3 = objPG.objPGap.Year_3_per__c;
                
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.year_4__c != null) numberAY4 = objPG.objPGap.year_4__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_4__c != null) numberBY4 = objPG.objPGap.year_4__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_4__c != null) numberCY4 = objPG.objPGap.year_4__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_4__c != null) numberDY4 = objPG.objPGap.year_4__c;
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.year_4__c != null) numberFY4 = objPG.objPGap.year_4__c;
               // if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_4__c != null) numberHY4 = objPG.objPGap.year_4__c;
                
                if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_4_per__c!= null) PercentAY4 = objPG.objPGap.Year_4_per__c;
                if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.Year_4_per__c!= null) PercentBY4 = objPG.objPGap.Year_4_per__c; // TCS changes for Requirement# 107
                if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.Year_4_per__c!= null) PercentCY4 = objPG.objPGap.Year_4_per__c;
                if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.Year_4_per__c!= null) PercentDY4 = objPG.objPGap.Year_4_per__c;
                if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_4_per__c!= null) PercentFY4 = objPG.objPGap.Year_4_per__c;
               // if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.Year_4_per__c!= null) PercentHY4 = objPG.objPGap.Year_4_per__c;
                 }
                 else {
                            if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_1__c != null) numberB = objPG.objPGap.year_1__c;
                            if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_1__c != null) numberC = objPG.objPGap.year_1__c;
                            if(objPG.objPGap.Type_Formula__c == 'D' && objPG.objPGap.year_1__c != null) objPG.objPGap.year_1__c = DecimalDY1;
                            if(objPG.objPGap.Type_Formula__c == 'D' && objPG.objPGap.year_1__c != null) numberD = objPG.objPGap.year_1__c;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_1__c != null) objPG.objPGap.year_1__c = DecimalEY1;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_1__c != null) numberE = objPG.objPGap.year_1__c;
                            if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_1__c != null) numberH = objPG.objPGap.year_1__c;                            
                            if(objPG.objPGap.Type_Formula__c == 'J' && objPG.objPGap.year_1__c != null) numberJ = objPG.objPGap.year_1__c;
                            if(objPG.objPGap.Type_Formula__c == 'L' && objPG.objPGap.year_1__c != null) numberL = objPG.objPGap.year_1__c;
                                                       
                            if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_1_per__c!= null) PercentA = objPG.objPGap.Year_1_per__c;
                            if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_1_per__c!= null) PercentG = objPG.objPGap.Year_1_per__c;
                            
                                                       
                            if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_2__c != null) numberBY2 = objPG.objPGap.year_2__c;
                            if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_2__c != null) numberCY2 = objPG.objPGap.year_2__c;
                            
                            if(objPG.objPGap.Type_Formula__c == 'D' && objPG.objPGap.year_2__c != null) numberDY2 = objPG.objPGap.year_2__c;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_2__c != null) objPG.objPGap.year_2__c = DecimalEY2;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_2__c != null) numberEY2 = objPG.objPGap.year_2__c;
                            if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_2__c != null) numberHY2 = objPG.objPGap.year_2__c;                            
                            if(objPG.objPGap.Type_Formula__c == 'J' && objPG.objPGap.year_2__c != null) numberJY2 = objPG.objPGap.year_2__c;
                            if(objPG.objPGap.Type_Formula__c == 'L' && objPG.objPGap.year_2__c != null) numberLY2 = objPG.objPGap.year_2__c;
                                                       
                            if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_2_per__c!= null) PercentAY2 = objPG.objPGap.Year_2_per__c;
                            if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_2_per__c!= null) PercentGY2 = objPG.objPGap.Year_2_per__c;
                                                        
                            if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_3__c != null) numberBY3 = objPG.objPGap.year_3__c;
                            if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_3__c != null) numberCY3 = objPG.objPGap.year_3__c;
                            if(objPG.objPGap.Type_Formula__c == 'D' && objPG.objPGap.year_3__c != null) numberDY3 = objPG.objPGap.year_3__c;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_3__c != null) objPG.objPGap.year_3__c = DecimalEY3;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_3__c != null) numberEY3 = objPG.objPGap.year_3__c;
                            system.debug('Two E section'+objPG.objPGap.Type_Formula__c);
                            system.debug('Two E section'+numberEY3);
                            if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_3__c != null) numberHY3 = objPG.objPGap.year_3__c;                            
                            if(objPG.objPGap.Type_Formula__c == 'J' && objPG.objPGap.year_3__c != null) numberJY3 = objPG.objPGap.year_3__c;
                            if(objPG.objPGap.Type_Formula__c == 'L' && objPG.objPGap.year_3__c != null) numberLY3 = objPG.objPGap.year_3__c;
                                                       
                            if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_3_per__c!= null) PercentAY3 = objPG.objPGap.Year_3_per__c;
                            if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_3_per__c!= null) PercentGY3 = objPG.objPGap.Year_3_per__c;
                                                        
                            if(objPG.objPGap.Type_Formula__c == 'B' && objPG.objPGap.year_4__c != null) numberBY4 = objPG.objPGap.year_4__c;
                            if(objPG.objPGap.Type_Formula__c == 'C' && objPG.objPGap.year_4__c != null) numberCY4 = objPG.objPGap.year_4__c;
                            if(objPG.objPGap.Type_Formula__c == 'D' && objPG.objPGap.year_4__c != null) numberDY4 = objPG.objPGap.year_4__c;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_4__c != null) objPG.objPGap.year_4__c = DecimalEY4;
                            if(objPG.objPGap.Type_Formula__c == 'E' && objPG.objPGap.year_4__c != null) numberEY4 = objPG.objPGap.year_4__c;
                            if(objPG.objPGap.Type_Formula__c == 'H' && objPG.objPGap.year_4__c != null) numberHY4 = objPG.objPGap.year_4__c;                            
                            if(objPG.objPGap.Type_Formula__c == 'J' && objPG.objPGap.year_4__c != null) numberJY4 = objPG.objPGap.year_4__c;
                            if(objPG.objPGap.Type_Formula__c == 'L' && objPG.objPGap.year_4__c != null) numberLY4 = objPG.objPGap.year_4__c;
                                                       
                            if(objPG.objPGap.Type_Formula__c == 'A' && objPG.objPGap.Year_4_per__c!= null) PercentAY4 = objPG.objPGap.Year_4_per__c;
                            if(objPG.objPGap.Type_Formula__c == 'G' && objPG.objPGap.Year_4_per__c!= null) PercentGY4 = objPG.objPGap.Year_4_per__c;
                         
                         }  
                         
               
             
               
              if(lstWrapCls[SaveIndiIndex].objCI.LLIN__c)
                 {
                       mapToUpdate.put(objPG.objPGap.Type__c,objPG.objPGap);
                       
                 }
              
               PGToUpdate.add(objPG.objPGap);
               
              /*if(lstWrapCls[SaveIndiIndex].objCI.LLIN__c)
                {
                List<Programmatic_Gap__c> PGToUpdateLLIN = [SELECT Id, Catalog_Indicator__c, Type__c, Baseline_Source__c, 
                
                Baseline_year__c, Baseline_value__c, Specify_Text__c , Coverage_Text__c, 
                
                Rationale_for_Chosen_Indicator__c , Metric__c , Program_Area__c , Coverage_Comments__c, 
                
                Group_Sequence__c,Module__c ,  Year_1__c ,Year_2__c , Year_3__c ,Year_4__c  FROM Programmatic_Gap__c  where Module__c =: strModuleId
                And Concept_Note__c =: ConceptNoteId
                And Catalog_Indicator__r.LLIN__c =true
                AND Catalog_Indicator__c !=: lstWrapCls[SaveIndiIndex].objCI.Id];
                
                System.debug('PGToUpdateLLIN %%%%'+PGToUpdateLLIN[0]);
                            
                for(Integer k = 0; k<PGToUpdateLLIN.size();k++)
                {
                objPG.objPGap.Id= PGToUpdateLLIN[i].Id;
                PGToUpdateLLIN.add(objPG.objPGap);
                System.debug('PGToUpdateLLIN'+PGToUpdateLLIN);
                }
               }*/
               
        }

            
            if(lstWrapCls[SaveIndiIndex].objCI.LLIN__c  == false) {
                 /* TCS changes for Requirement# 107 --Begin--*/
                            if(lstWrapCls[SaveIndiIndex].objCI.Indicator_for_PG_Calculation_E__c)
                                {
           lstWrapCls[SaveIndiIndex].Year1NumberE = numberB - numberC;
           lstWrapCls[SaveIndiIndex].Year2NumberE = numberBY2 - numberCY2;
           lstWrapCls[SaveIndiIndex].Year3NumberE = numberBY3 - numberCY3;
           lstWrapCls[SaveIndiIndex].Year4NumberE = numberBY4 - numberCY4;
           
           if(numberB != 0)
           //lstWrapCls[SaveIndiIndex].Year1PercentE = integer.valueof(((numberB - numberC)/numberB)*100);
           lstWrapCls[SaveIndiIndex].Year1PercentE = (((numberB - numberC)/numberB)*100).setScale(2);
           else
           lstWrapCls[SaveIndiIndex].Year1PercentE = 0;
           if(numberBY2 != 0)
           //lstWrapCls[SaveIndiIndex].Year2PercentE = integer.valueof(((numberBY2 - numberCY2)/numberBY2)*100);
           lstWrapCls[SaveIndiIndex].Year2PercentE = (((numberBY2 - numberCY2)/numberBY2)*100).setScale(2);           
           else
           lstWrapCls[SaveIndiIndex].Year2PercentE = 0;
           if(numberBY3 != 0)
           //lstWrapCls[SaveIndiIndex].Year3PercentE = integer.valueof(((numberBY3 - numberCY3)/numberBY3)*100);
           lstWrapCls[SaveIndiIndex].Year3PercentE = (((numberBY3 - numberCY3)/numberBY3)*100).setScale(2);
           else
           lstWrapCls[SaveIndiIndex].Year3PercentE = 0;
           if(numberBY4 != 0)
           //lstWrapCls[SaveIndiIndex].Year4PercentE = integer.valueof(((numberBY4 - numberCY4)/numberBY4)*100);
           lstWrapCls[SaveIndiIndex].Year4PercentE = (((numberBY4 - numberCY4)/numberBY4)*100).setScale(2);
           else
           lstWrapCls[SaveIndiIndex].Year4PercentE = 0;
                                }
                            else{
            lstWrapCls[SaveIndiIndex].Year1NumberE = numberA - numberC;
            //lstWrapCls[SaveIndiIndex].Year1PercentE = 100 - PercentC;
            lstWrapCls[SaveIndiIndex].Year1PercentE = (100 - PercentC).setScale(2);
            lstWrapCls[SaveIndiIndex].Year2NumberE = numberAY2 - numberCY2;
            //lstWrapCls[SaveIndiIndex].Year2PercentE = 100 - PercentCY2;
            lstWrapCls[SaveIndiIndex].Year2PercentE = (100 - PercentCY2).setScale(2);
            lstWrapCls[SaveIndiIndex].Year3NumberE = numberAY3 - numberCY3;
            //lstWrapCls[SaveIndiIndex].Year3PercentE = 100 - PercentCY3;
            lstWrapCls[SaveIndiIndex].Year3PercentE = (100 - PercentCY3).setScale(2);
            lstWrapCls[SaveIndiIndex].Year4NumberE = numberAY4 - numberCY4;
            //lstWrapCls[SaveIndiIndex].Year4PercentE = 100 - PercentCY4;
            lstWrapCls[SaveIndiIndex].Year4PercentE = (100 - PercentCY4).setScale(2);
                                 }
                 /* TCS changes for Requirement# 107 --End--*/                
            
            lstWrapCls[SaveIndiIndex].Year1NumberG = NumberD + numberC ; //Calculating F instead of G
            //lstWrapCls[SaveIndiIndex].Year1PercentG = PercentD + PercentC ;
            lstWrapCls[SaveIndiIndex].Year1PercentG = (PercentD + PercentC).setScale(2);
            lstWrapCls[SaveIndiIndex].Year1NumberI = NumberD + numberC + numberF;//
            //lstWrapCls[SaveIndiIndex].Year1PercentI = (PercentC + PercentD) + PercentF;
            lstWrapCls[SaveIndiIndex].Year1PercentI = ((PercentC + PercentD) + PercentF).setScale(2);
               
            lstWrapCls[SaveIndiIndex].Year2NumberG = numberCY2 + numberDY2;
            //lstWrapCls[SaveIndiIndex].Year2PercentG = PercentCY2 + PercentDY2;
            lstWrapCls[SaveIndiIndex].Year2PercentG = (PercentCY2 + PercentDY2).setScale(2);
            lstWrapCls[SaveIndiIndex].Year2NumberI = NumberFY2 + numberCY2 + numberDY2;
            //lstWrapCls[SaveIndiIndex].Year2PercentI = PercentFY2 + PercentCY2 + PercentDY2;
            lstWrapCls[SaveIndiIndex].Year2PercentI = (PercentFY2 + PercentCY2 + PercentDY2).setScale(2);
            
            lstWrapCls[SaveIndiIndex].Year3NumberG = numberCY3 + numberDY3;
            //lstWrapCls[SaveIndiIndex].Year3PercentG = PercentCY3 + PercentDY3;
            lstWrapCls[SaveIndiIndex].Year3PercentG = (PercentCY3 + PercentDY3).setScale(2);
            lstWrapCls[SaveIndiIndex].Year3NumberI = NumberFY3 + numberCY3 + numberDY3;
            //lstWrapCls[SaveIndiIndex].Year3PercentI = PercentFY3 + PercentCY3 + PercentDY3;
            lstWrapCls[SaveIndiIndex].Year3PercentI = (PercentFY3 + PercentCY3 + PercentDY3).setScale(2);
                
            lstWrapCls[SaveIndiIndex].Year4NumberG = numberCY4 + numberDY4;
            //lstWrapCls[SaveIndiIndex].Year4PercentG = PercentCY4 + PercentDY4;
            lstWrapCls[SaveIndiIndex].Year4PercentG = (PercentCY4 + PercentDY4).setScale(2);
            lstWrapCls[SaveIndiIndex].Year4NumberI = NumberFY4 + numberCY4 + numberDY4;
            //lstWrapCls[SaveIndiIndex].Year4PercentI = PercentFY4 + PercentCY4 + PercentDY4;
            lstWrapCls[SaveIndiIndex].Year4PercentI = (PercentFY4 + PercentCY4 + PercentDY4).setScale(2);
            
                        lstWrapCls[SaveIndiIndex].YearE1=lstWrapCls[SaveIndiIndex].Year1NumberE.format();
             			lstWrapCls[SaveIndiIndex].YearE2=lstWrapCls[SaveIndiIndex].Year2NumberE.format();
             			lstWrapCls[SaveIndiIndex].YearE3=lstWrapCls[SaveIndiIndex].Year3NumberE.format();
             			lstWrapCls[SaveIndiIndex].YearE4=lstWrapCls[SaveIndiIndex].Year4NumberE.format();
             			
                       
                        lstWrapCls[SaveIndiIndex].YearG1=lstWrapCls[SaveIndiIndex].Year1NumberG.format();
                        lstWrapCls[SaveIndiIndex].YearG2=lstWrapCls[SaveIndiIndex].Year2NumberG.format();
                        lstWrapCls[SaveIndiIndex].YearG3=lstWrapCls[SaveIndiIndex].Year3NumberG.format();
                        lstWrapCls[SaveIndiIndex].YearG4=lstWrapCls[SaveIndiIndex].Year4NumberG.format();

                        
                        
                        lstWrapCls[SaveIndiIndex].YearI1=lstWrapCls[SaveIndiIndex].Year1NumberI.format();
                        lstWrapCls[SaveIndiIndex].YearI2=lstWrapCls[SaveIndiIndex].Year2NumberI.format();
                        lstWrapCls[SaveIndiIndex].YearI3=lstWrapCls[SaveIndiIndex].Year3NumberI.format();
                        lstWrapCls[SaveIndiIndex].YearI4=lstWrapCls[SaveIndiIndex].Year4NumberI.format();
             }
             else {
                        lstWrapCls[SaveIndiIndex].Year1NumberF = numberC + numberD + numberE;                        
                        lstWrapCls[SaveIndiIndex].Year1NumberG = lstWrapCls[SaveIndiIndex].Year1NumberF + numberB;
                        lstWrapCls[SaveIndiIndex].Year1NumberK = numberJ + numberH;                     
                        lstWrapCls[SaveIndiIndex].Year1NumberI = lstWrapCls[SaveIndiIndex].Year1NumberG - numberH;
                        lstWrapCls[SaveIndiIndex].Year1NumberM = lstWrapCls[SaveIndiIndex].Year1NumberK + numberL;
                        if(lstWrapCls[SaveIndiIndex].Year1NumberG == 0)
                        {
                            lstWrapCls[SaveIndiIndex].Year1PercentH = 0;
                            lstWrapCls[SaveIndiIndex].Year1PercentI = 0;
                            lstWrapCls[SaveIndiIndex].Year1PercentJ = 0;
                            lstWrapCls[SaveIndiIndex].Year1PercentK = 0;
                            lstWrapCls[SaveIndiIndex].Year1PercentL = 0;
                            lstWrapCls[SaveIndiIndex].Year1PercentM = 0;
                        }
                        else {
                        /*if(numberH != 0)lstWrapCls[SaveIndiIndex].Year1PercentH = Math.round((numberH / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year1NumberI != 0)lstWrapCls[SaveIndiIndex].Year1PercentI = Math.round((lstWrapCls[SaveIndiIndex].Year1NumberI / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100);
                        if(numberJ != 0)lstWrapCls[SaveIndiIndex].Year1PercentJ = Math.round((numberJ / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year1NumberK != 0)lstWrapCls[SaveIndiIndex].Year1PercentK = Math.round((lstWrapCls[SaveIndiIndex].Year1NumberK / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100);
                        if(numberL != 0)lstWrapCls[SaveIndiIndex].Year1PercentL = Math.round((NumberL / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year1NumberM != 0)lstWrapCls[SaveIndiIndex].Year1PercentM = Math.round((lstWrapCls[SaveIndiIndex].Year1NumberM / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100);*/
                        
                        
                        if(numberH != 0)lstWrapCls[SaveIndiIndex].Year1PercentH = ((numberH / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year1NumberI != 0)lstWrapCls[SaveIndiIndex].Year1PercentI = ((lstWrapCls[SaveIndiIndex].Year1NumberI / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100).setScale(2);
                        if(numberJ != 0)lstWrapCls[SaveIndiIndex].Year1PercentJ = ((numberJ / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year1NumberK != 0)lstWrapCls[SaveIndiIndex].Year1PercentK = ((lstWrapCls[SaveIndiIndex].Year1NumberK / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100).setScale(2);
                        if(numberL != 0)lstWrapCls[SaveIndiIndex].Year1PercentL = ((NumberL / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year1NumberM != 0)lstWrapCls[SaveIndiIndex].Year1PercentM = ((lstWrapCls[SaveIndiIndex].Year1NumberM / lstWrapCls[SaveIndiIndex].Year1NumberG) * 100).setScale(2);
                        }
                        
                        lstWrapCls[SaveIndiIndex].Year2NumberF = numberCY2 + numberDY2 + numberEY2;                        
                        lstWrapCls[SaveIndiIndex].Year2NumberG = lstWrapCls[SaveIndiIndex].Year2NumberF + numberBY2;
                        lstWrapCls[SaveIndiIndex].Year2NumberK = numberJY2 + numberHY2;                     
                        lstWrapCls[SaveIndiIndex].Year2NumberI = lstWrapCls[SaveIndiIndex].Year2NumberG - numberHY2;
                        lstWrapCls[SaveIndiIndex].Year2NumberM = lstWrapCls[SaveIndiIndex].Year2NumberK + numberLY2;
                        if(lstWrapCls[SaveIndiIndex].Year2NumberG == 0)
                        {
                            lstWrapCls[SaveIndiIndex].Year2PercentH = 0;
                            lstWrapCls[SaveIndiIndex].Year2PercentI = 0;
                            lstWrapCls[SaveIndiIndex].Year2PercentJ = 0;
                            lstWrapCls[SaveIndiIndex].Year2PercentK = 0;
                            lstWrapCls[SaveIndiIndex].Year2PercentL = 0;
                            lstWrapCls[SaveIndiIndex].Year2PercentM = 0;
                        }
                        else {
                        
                        /*if(numberHY2 != 0)lstWrapCls[SaveIndiIndex].Year2PercentH = Math.round((numberHY2 / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year2NumberI != 0)lstWrapCls[SaveIndiIndex].Year2PercentI = Math.round((lstWrapCls[SaveIndiIndex].Year2NumberI / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100);
                        if(numberJY2 != 0) lstWrapCls[SaveIndiIndex].Year2PercentJ = Math.round((numberJY2 / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year2NumberK != 0)lstWrapCls[SaveIndiIndex].Year2PercentK = Math.round((lstWrapCls[SaveIndiIndex].Year2NumberK / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100);
                        if(numberLY2 != 0)lstWrapCls[SaveIndiIndex].Year2PercentL = Math.round((NumberLY2 / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year2NumberM != 0)lstWrapCls[SaveIndiIndex].Year2PercentM = Math.round((lstWrapCls[SaveIndiIndex].Year2NumberM / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100);*/
                        
                        if(numberHY2 != 0)lstWrapCls[SaveIndiIndex].Year2PercentH = ((numberHY2 / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year2NumberI != 0)lstWrapCls[SaveIndiIndex].Year2PercentI = ((lstWrapCls[SaveIndiIndex].Year2NumberI / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100).setScale(2);
                        if(numberJY2 != 0) lstWrapCls[SaveIndiIndex].Year2PercentJ = ((numberJY2 / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year2NumberK != 0)lstWrapCls[SaveIndiIndex].Year2PercentK = ((lstWrapCls[SaveIndiIndex].Year2NumberK / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100).setScale(2);
                        if(numberLY2 != 0)lstWrapCls[SaveIndiIndex].Year2PercentL = ((NumberLY2 / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year2NumberM != 0)lstWrapCls[SaveIndiIndex].Year2PercentM = ((lstWrapCls[SaveIndiIndex].Year2NumberM / lstWrapCls[SaveIndiIndex].Year2NumberG) * 100).setScale(2);
                        }
                        
                        
                        lstWrapCls[SaveIndiIndex].Year3NumberF = numberCY3 + numberDY3 + numberEY3;                        
                        lstWrapCls[SaveIndiIndex].Year3NumberG = lstWrapCls[SaveIndiIndex].Year3NumberF + numberBY3;
                        lstWrapCls[SaveIndiIndex].Year3NumberI = lstWrapCls[SaveIndiIndex].Year3NumberG - numberHY3;
                        lstWrapCls[SaveIndiIndex].Year3NumberK = numberJY3 + numberHY3;
                        lstWrapCls[SaveIndiIndex].Year3NumberM = lstWrapCls[SaveIndiIndex].Year3NumberK + numberLY3;
                         if(lstWrapCls[SaveIndiIndex].Year3NumberG == 0)
                        {
                            lstWrapCls[SaveIndiIndex].Year3PercentH = 0;
                            lstWrapCls[SaveIndiIndex].Year3PercentI = 0;
                            lstWrapCls[SaveIndiIndex].Year3PercentJ = 0;
                            lstWrapCls[SaveIndiIndex].Year3PercentK = 0;
                            lstWrapCls[SaveIndiIndex].Year3PercentL = 0;
                            lstWrapCls[SaveIndiIndex].Year3PercentM = 0;
                        }
                        else {
                        /*if(numberHY3 != 0)lstWrapCls[SaveIndiIndex].Year3PercentH = Math.round((numberHY3 / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100);                      
                        if(lstWrapCls[SaveIndiIndex].Year3NumberI != 0)lstWrapCls[SaveIndiIndex].Year3PercentI = Math.round((lstWrapCls[SaveIndiIndex].Year3NumberI / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100);
                        if(numberJY3 != 0)lstWrapCls[SaveIndiIndex].Year3PercentJ = Math.round((numberJY3 / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year3NumberK != 0)lstWrapCls[SaveIndiIndex].Year3PercentK = Math.round((lstWrapCls[SaveIndiIndex].Year3NumberK / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100);
                        if(numberLY3 != 0)lstWrapCls[SaveIndiIndex].Year3PercentL = Math.round((NumberLY3 / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100);
                        if(lstWrapCls[SaveIndiIndex].Year3NumberM != 0)lstWrapCls[SaveIndiIndex].Year3PercentM = Math.round((lstWrapCls[SaveIndiIndex].Year3NumberM / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100);*/
                        
                        if(numberHY3 != 0)lstWrapCls[SaveIndiIndex].Year3PercentH = ((numberHY3 / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100).setScale(2);                      
                        if(lstWrapCls[SaveIndiIndex].Year3NumberI != 0)lstWrapCls[SaveIndiIndex].Year3PercentI = ((lstWrapCls[SaveIndiIndex].Year3NumberI / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100).setScale(2);
                        if(numberJY3 != 0)lstWrapCls[SaveIndiIndex].Year3PercentJ = ((numberJY3 / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year3NumberK != 0)lstWrapCls[SaveIndiIndex].Year3PercentK = ((lstWrapCls[SaveIndiIndex].Year3NumberK / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100).setScale(2);
                        if(numberLY3 != 0)lstWrapCls[SaveIndiIndex].Year3PercentL = ((NumberLY3 / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100).setScale(2);
                        if(lstWrapCls[SaveIndiIndex].Year3NumberM != 0)lstWrapCls[SaveIndiIndex].Year3PercentM = ((lstWrapCls[SaveIndiIndex].Year3NumberM / lstWrapCls[SaveIndiIndex].Year3NumberG) * 100).setScale(2);
                        }
                        
                        lstWrapCls[SaveIndiIndex].Year4NumberF = numberCY4 + numberDY4 + numberEY4;                        
                        lstWrapCls[SaveIndiIndex].Year4NumberG = lstWrapCls[SaveIndiIndex].Year4NumberF + numberBY4;
                        lstWrapCls[SaveIndiIndex].Year4NumberI = lstWrapCls[SaveIndiIndex].Year4NumberG - numberHY4;
                        lstWrapCls[SaveIndiIndex].Year4NumberK = numberJY4 + numberHY4;
                        lstWrapCls[SaveIndiIndex].Year4NumberM = lstWrapCls[SaveIndiIndex].Year4NumberK + numberLY4;
                         if(lstWrapCls[SaveIndiIndex].Year4NumberG == 0)
                        {
                            lstWrapCls[SaveIndiIndex].Year4PercentH = 0;
                            lstWrapCls[SaveIndiIndex].Year4PercentI = 0;
                            lstWrapCls[SaveIndiIndex].Year4PercentJ = 0;
                            lstWrapCls[SaveIndiIndex].Year4PercentK = 0;
                            lstWrapCls[SaveIndiIndex].Year4PercentL = 0;
                            lstWrapCls[SaveIndiIndex].Year4PercentM = 0;
                        }
                        else {
                        /*if(numberHY4 != 0)lstWrapCls[SaveIndiIndex].Year4PercentH = Math.round((numberHY4 / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100);                      
                        
                        if(lstWrapCls[SaveIndiIndex].Year4NumberI != 0)lstWrapCls[SaveIndiIndex].Year4PercentI = Math.round((lstWrapCls[SaveIndiIndex].Year4NumberI / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100);
                        if(numberJY4 != 0)lstWrapCls[SaveIndiIndex].Year4PercentJ = Math.round((numberJY4 / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100);
                        
                        if(lstWrapCls[SaveIndiIndex].Year4NumberK != 0)lstWrapCls[SaveIndiIndex].Year4PercentK = Math.round((lstWrapCls[SaveIndiIndex].Year4NumberK / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100);
                        if(numberLY4 != 0)lstWrapCls[SaveIndiIndex].Year4PercentL = Math.round((NumberLY4 / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100);
                        
                        if(lstWrapCls[SaveIndiIndex].Year4NumberM != 0)lstWrapCls[SaveIndiIndex].Year4PercentM = Math.round((lstWrapCls[SaveIndiIndex].Year4NumberM / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100);*/   
                        
                        
                        if(numberHY4 != 0)lstWrapCls[SaveIndiIndex].Year4PercentH = ((numberHY4 / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100).setScale(2);                      
                        
                        if(lstWrapCls[SaveIndiIndex].Year4NumberI != 0)lstWrapCls[SaveIndiIndex].Year4PercentI = ((lstWrapCls[SaveIndiIndex].Year4NumberI / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100).setScale(2);
                        if(numberJY4 != 0)lstWrapCls[SaveIndiIndex].Year4PercentJ = ((numberJY4 / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100).setScale(2);
                        
                        if(lstWrapCls[SaveIndiIndex].Year4NumberK != 0)lstWrapCls[SaveIndiIndex].Year4PercentK = ((lstWrapCls[SaveIndiIndex].Year4NumberK / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100).setScale(2);
                        if(numberLY4 != 0)lstWrapCls[SaveIndiIndex].Year4PercentL = ((NumberLY4 / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100).setScale(2);
                        
                        if(lstWrapCls[SaveIndiIndex].Year4NumberM != 0)lstWrapCls[SaveIndiIndex].Year4PercentM =((lstWrapCls[SaveIndiIndex].Year4NumberM / lstWrapCls[SaveIndiIndex].Year4NumberG) * 100).setScale(2);
                        }
                        
                        		lstWrapCls[SaveIndiIndex].YearF1=lstWrapCls[SaveIndiIndex].Year1NumberF.format();
		                        lstWrapCls[SaveIndiIndex].YearF2=lstWrapCls[SaveIndiIndex].Year2NumberF.format();
		                        lstWrapCls[SaveIndiIndex].YearF3=lstWrapCls[SaveIndiIndex].Year3NumberF.format();
		                        lstWrapCls[SaveIndiIndex].YearF4=lstWrapCls[SaveIndiIndex].Year4NumberF.format();
		                        
		                        lstWrapCls[SaveIndiIndex].YearG1=lstWrapCls[SaveIndiIndex].Year1NumberG.format();
		                        lstWrapCls[SaveIndiIndex].YearG2=lstWrapCls[SaveIndiIndex].Year2NumberG.format();
		                        lstWrapCls[SaveIndiIndex].YearG3=lstWrapCls[SaveIndiIndex].Year3NumberG.format();
		                        lstWrapCls[SaveIndiIndex].YearG4=lstWrapCls[SaveIndiIndex].Year4NumberG.format();
		                        
		                        lstWrapCls[SaveIndiIndex].YearI1=lstWrapCls[SaveIndiIndex].Year1NumberI.format();
		                        lstWrapCls[SaveIndiIndex].YearI2=lstWrapCls[SaveIndiIndex].Year2NumberI.format();
		                        lstWrapCls[SaveIndiIndex].YearI3=lstWrapCls[SaveIndiIndex].Year3NumberI.format();
		                        lstWrapCls[SaveIndiIndex].YearI4=lstWrapCls[SaveIndiIndex].Year4NumberI.format(); 
		                        
		                        lstWrapCls[SaveIndiIndex].YearK1=lstWrapCls[SaveIndiIndex].Year1NumberK.format();
		                        lstWrapCls[SaveIndiIndex].YearK2=lstWrapCls[SaveIndiIndex].Year2NumberK.format();
		                        lstWrapCls[SaveIndiIndex].YearK3=lstWrapCls[SaveIndiIndex].Year3NumberK.format();
		                        lstWrapCls[SaveIndiIndex].YearK4=lstWrapCls[SaveIndiIndex].Year4NumberK.format();
		                        
		                        lstWrapCls[SaveIndiIndex].YearM1=lstWrapCls[SaveIndiIndex].Year1NumberM.format();
		                        lstWrapCls[SaveIndiIndex].YearM2=lstWrapCls[SaveIndiIndex].Year2NumberM.format();
		                        lstWrapCls[SaveIndiIndex].YearM3=lstWrapCls[SaveIndiIndex].Year3NumberM.format();
		                        lstWrapCls[SaveIndiIndex].YearM4=lstWrapCls[SaveIndiIndex].Year4NumberM.format();
             }

                        
                    /*TCS Changes for Req 48 End*/ 
            System.debug('PGToUpdate[0]'+PGToUpdate[0]);
            if(PGToUpdate.size() > 0) 
            {
                System.debug('****');
                update PGToUpdate;
            }
            else
            {
                 System.debug('+++++++');
            }
            
            
            //*********************
            
          /* TCS changes for Requirement# 48 --Begin--*/           
        List<Programmatic_Gap__c> lstToUpdate = new List<Programmatic_Gap__c>();
        if(lstWrapCls[SaveIndiIndex].objCI.LLIN__c)
         {
         List<Programmatic_Gap__c> PGToUpdateLLIN = [SELECT Id, Catalog_Indicator__c, Type__c, Baseline_Source__c, 
    
                                                        Baseline_year__c, Baseline_value__c, Specify_Text__c , Coverage_Text__c, 
                                                        
                                                        Rationale_for_Chosen_Indicator__c , Metric__c , Program_Area__c , Coverage_Comments__c, 
                                                        
                                                        Group_Sequence__c,Module__c ,  Year_1__c ,Year_2__c , Year_3__c ,Year_4__c, Year_1_per__c, Year_2_per__c, Year_3_per__c, Year_4_per__c FROM Programmatic_Gap__c 
                                                        WHERE Module__c =: strModuleId
                                                        AND Concept_Note__c =: ConceptNoteId
                                                        AND Catalog_Indicator__r.LLIN__c =true
                                                        AND Catalog_Indicator__c !=: lstWrapCls[SaveIndiIndex].objCI.Id];
         

 
                         for(Programmatic_Gap__c pgUpd: PGToUpdateLLIN)
                         {
                            if(mapToUpdate.containsKey(pgUpd.Type__c))
                            {
                                Programmatic_Gap__c objPGUpd = mapToUpdate.get(pgUpd.Type__c);
                                
                                pgUpd.Baseline_Source__c = objPGUpd.Baseline_Source__c;
                                pgUpd.Baseline_year__c = objPGUpd.Baseline_year__c;
                                pgUpd.Baseline_value__c = objPGUpd.Baseline_value__c;
                                pgUpd.Specify_Text__c = objPGUpd.Specify_Text__c;
                                pgUpd.Coverage_Text__c = objPGUpd.Coverage_Text__c;
                                pgUpd.Rationale_for_Chosen_Indicator__c = objPGUpd.Rationale_for_Chosen_Indicator__c;
                                System.debug('Update'+objPGUpd);
                                //if(objPGUpd.Type__c == MapTypeForLLIN.get(4))
                                //TCS 8/5/2014: Requirement#107 Updated: Commented if Condition
                               /* if(objPGUpd.Type_Formula__c=='A')
                                {
                                System.debug('Type__c**'+objPGUpd.Type__c);
                                System.debug('LLIN TYpe__C'+MapTypeForLLIN.get(4));
                                pgUpd.Year_1_per__c = objPGUpd.Year_1_per__c;
                                pgUpd.Year_2_per__c = objPGUpd.Year_2_per__c;   
                                pgUpd.Year_3_per__c = objPGUpd.Year_3_per__c;
                                pgUpd.Year_4_per__c = objPGUpd.Year_4_per__c;
                                }
                                else
                                { */
                                pgUpd.Year_1__c = objPGUpd.Year_1__c;
                                pgUpd.Year_2__c = objPGUpd.Year_2__c;
                                pgUpd.Year_3__c = objPGUpd.Year_3__c;
                                pgUpd.Year_4__c = objPGUpd.Year_4__c;
                               // }
                                lstToUpdate.add(pgUpd);
                                System.debug('lstToUpdate **'+lstToUpdate);
                            }
                         }
               
         }
        
            //*********************
            
            
            if(lstToUpdate.size() > 0) update lstToUpdate;
            /* TCS changes for Requirement# 48 --End--*/
            lstWrapCls[SaveIndiIndex].blndisplaySave = true;
            system.debug('updated blndisplaySave'+lstWrapCls[SaveIndiIndex].blndisplaySave);
        }
        blnSave=true; //TCS Changes
    }
    Public void CreateIndicatorOnSelectCatalog(){
        if(String.isBlank(strSelectedIndicator) == false){
            //AddNewProg_Gap();
            //Grant_Indicator__c objIndicator = MapCatalogIndicator.get(strSelectedIndicator);
            system.debug('$%%$%$%$'+strSelectedIndicator);
            FillModules(strSelectedIndicator);           
       System.debug('111111111111111111111111111111111111111111111111 ' +objWrapClsStd.lstProgrammaticGap.size());
        }
    }
    
    
    Public void quickSavePG(){
        
        update objModuleToUpdateCycle;
                
        List<Programmatic_Gap__c> finalPG = new List<Programmatic_Gap__c>();
        List<Programmatic_Gap__c> finalPGLLIN  = new List<Programmatic_Gap__c>(); 
        List<Programmatic_Gap__c> LLINToInsert = new List<Programmatic_Gap__c>(); /* TCS changes for Requirement# 48 --Begin--*/
        Map<String,Programmatic_Gap__c> mapToinsertLLIN =  new Map<String,Programmatic_Gap__c>(); /* TCS changes for Requirement# 48 --End--*/
                       
         
         for(ProgrammaticGap objPG:objWrapClsStd.lstProgrammaticGap){                   
                            objPG.objPGap.Baseline_Source__c = objWrapClsStd.objGI.Baseline_Sources__c;
                            objPG.objPGap.Baseline_year__c = objWrapClsStd.objGI.Baseline_year__c;
                            objPG.objPGap.Baseline_value__c = objWrapClsStd.objGI.Baseline_value__c;
                            objPG.objPGap.Specify_Text__c = objWrapClsStd.objGI.Specify_Text__c;
                            objPG.objPGap.Coverage_Text__c = objWrapClsStd.objGI.Coverage_Text__c;
                            objPG.objPGap.Rationale_for_Chosen_Indicator__c = objWrapClsStd.objGI.Rationale_for_Chosen_Indicator__c;
                            objPG.objPGap.Metric__c = objWrapClsStd.KeyMetric;
                            objPG.objPGap.Program_Area__c = objWrapClsStd.Name;
                            objPG.objPGap.Coverage_Comments__c =  objWrapClsStd.CoverageComments;
                            objPG.objPGap.Group_Sequence__c = objWrapClsStd.GroupSequence;
                            objPG.objPGap.Module__c = strmoduleId;
                            finalPG.Add(objPG.objPGap);                                        
                            mapToinsertLLIN.put(objPG.objPGap.Type__c,objPG.objPGap);
        
          }
          if(finalPG.size()>0) {
            insert finalPG;
          } 
         
         /* TCS changes for Requirement# 48 --Begin--*/
          if(blnCIndicatorLLIN) {
            objWrapClsStd.showLLIN = true;                     
                    
                    
                    for(Programmatic_Gap__c pgToInsert: PGToInsertLLIN)
                         {                           
                            if(mapToinsertLLIN.containsKey(pgToInsert.Type__c))
                            {
                                Programmatic_Gap__c objPGInsert = mapToinsertLLIN.get(pgToInsert.Type__c);                                
                                pgToInsert.Baseline_Source__c = objPGInsert.Baseline_Source__c;
                                pgToInsert.Baseline_year__c = objPGInsert.Baseline_year__c;
                                pgToInsert.Baseline_value__c = objPGInsert.Baseline_value__c;
                                pgToInsert.Specify_Text__c = objPGInsert.Specify_Text__c;
                                pgToInsert.Coverage_Text__c = objPGInsert.Coverage_Text__c;
                                pgToInsert.Rationale_for_Chosen_Indicator__c = objPGInsert.Rationale_for_Chosen_Indicator__c;
                                //TCS 8/5/2014: Requirement#107 Updated: Commented if Condition
                                /* if(objPGInsert.Type__c.contains(MapTypeForLLIN.get(4)))
                                {
                                pgToInsert.Year_1_per__c = objPGInsert.Year_1_per__c;
                                pgToInsert.Year_2_per__c = objPGInsert.Year_2_per__c;   
                                pgToInsert.Year_3_per__c = objPGInsert.Year_3_per__c;
                                pgToInsert.Year_4_per__c = objPGInsert.Year_4_per__c;
                                }
                                else
                                { */
                                pgToInsert.Year_1__c = objPGInsert.Year_1__c;
                                pgToInsert.Year_2__c = objPGInsert.Year_2__c;
                                pgToInsert.Year_3__c = objPGInsert.Year_3__c;
                                pgToInsert.Year_4__c = objPGInsert.Year_4__c;
                               // }
                                pgToInsert.Metric__c = objPGInsert.Metric__c;
                                pgToInsert.Program_Area__c = objPGInsert.Program_Area__c;
                                pgToInsert.Coverage_Comments__c =  objPGInsert.Coverage_Comments__c;
                                pgToInsert.Group_Sequence__c = objPGInsert.Group_Sequence__c;
                                pgToInsert.Module__c = strmoduleId;
                                LLINToInsert.add(pgToInsert);
                            }
                         }
                         
                  if(LLINToInsert.size()>0)
            {               
                  insert LLINToInsert;
            } 
  
         }
                
        /* TCS changes for Requirement# 48 --End--*/
        
        If(finalPG.size() > 0){
            
         
            
            finalPG[0].Catalog_Indicator__c=objWrapClsStd.lstProgrammaticGap[0].objPGap.Catalog_Indicator__c;
            system.debug('$#$#$#$'+finalPG[0].Indicator__c);
            if(lstWrapCls.size() > 0){}
            else {lstWrapCls = new List<wrapperClsModulePG>();}

                                    
                                   //TCS Req 48: Added field LLIN__c in the below query 
                                   // TCS changes for Requirement# 107: Modified query to include Indicator_for_PG_Calculation_E__c
            List<Indicator__c> lstCatalogIndicator = [Select Id,Name,Available_for_PG__c,Programme_Area__c,Full_Name_En__c,
                                        French_Name__c, Spanish_Name__c, Russian_Name__c,LLIN__c,Indicator_for_PG_Calculation_E__c,
                                        (SELECT Id, Name,Group_Sequence__c ,Metric__c ,Current_Coverage__c,
                                        Current_Coverage_per__c,Baseline_Source__c,Baseline_Year__c,Baseline_value__c,
                                        Rationale_for_Chosen_Indicator__c,LFA_Comments__c,Coverage_Comments__c,
                                        Module__c,Global_Fund_Comments__c,Year_1__c ,Year_2__c ,CCM_Comments__c ,
                                        CCM_Comments_Spanish__c, CCM_Comments_French__c, CCM_Comments_Russian__c,
                                        Year_3__c,Year_4__c, Specification__c,Assumptions__c,Program_Area__c,Specify_Text__c ,Coverage_Text__c,
                                        Type__c,Type_Formula__c,Year_1_per__c,Year_2_per__c,Year_3_per__c,Year_4_per__c
                                        FROM Programmatic_Gaps__r  WHERE Concept_Note__c = :ConceptNoteId
                                        order by Group_Sequence__c,Sequence__c asc) 
                                    FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                    And Indicator_Type__c =: 'Coverage/Output'
                                    And Available_for_PG__c = true 
                                    /*And Component__c INCLUDES(:strComponent)*/ //TCS - 21/05/2014 
                                    and Id =: finalPG[0].Catalog_Indicator__c];
            
                                
            if(lstCatalogIndicator.size() > 0){
                Integer Index = 0;
                for(Indicator__c objCInd: lstCatalogIndicator){ 
                    if(objCInd.Programmatic_Gaps__r.size() > 0){
                        wrapperClsModulePG objWrpCls = new wrapperClsModulePG();
                        objWrpCls.objCI = new Indicator__c();
                        objWrpCls.objCI = objCInd;
                        objWrpCls.showNewE1= showNewE; // TCS changes for Requirement# 107
                        objWrpCls.lstProgrammaticGap = new List<ProgrammaticGap>();
                        
                        Decimal numberA = 0;
                        Decimal numberC = 0;
                        Decimal numberD = 0;
                        Decimal numberF = 0;
                        Decimal numberH = 0;
                        Decimal PercentA = 0;
                        Decimal PercentC = 0;
                        Decimal PercentD = 0;
                        Decimal PercentF = 0;
                        Decimal PercentH = 0;
                        //TSC defined for Req #48
                        Decimal numberB = 0;
                        Decimal numberE = 0;
                        Decimal numberJ = 0;
                        Decimal numberL = 0;
                        Decimal PercentB = 0;
                        Decimal PercentE = 0;
                        Decimal PercentJ = 0;
                        Decimal PercentL = 0;
                        Decimal PercentG = 0;
                        
                        Decimal numberAY2 = 0;
                        Decimal numberCY2 = 0;
                        Decimal numberDY2 = 0;
                        Decimal numberFY2 = 0;
                        Decimal numberHY2 = 0;
                        Decimal PercentAY2 = 0;
                        Decimal PercentCY2 = 0;
                        Decimal PercentDY2 = 0;
                        Decimal PercentFY2 = 0;
                        Decimal PercentHY2 = 0;
                        //TSC defined for Req #48
                        Decimal numberBY2 = 0;
                        Decimal numberEY2 = 0;
                        Decimal numberJY2 = 0;
                        Decimal numberLY2 = 0;
                        Decimal PercentBY2 = 0;
                        Decimal PercentEY2 = 0;
                        Decimal PercentJY2 = 0;
                        Decimal PercentLY2 = 0;
                        Decimal PercentGY2 = 0;
                        
                        Decimal numberAY3 = 0;
                        Decimal numberCY3 = 0;
                        Decimal numberDY3 = 0;
                        Decimal numberFY3 = 0;
                        Decimal numberHY3 = 0;
                        Decimal PercentAY3 = 0;
                        Decimal PercentCY3 = 0;
                        Decimal PercentDY3 = 0;
                        Decimal PercentFY3 = 0;
                        Decimal PercentHY3 = 0;
                        //TSC defined for Req #48
                        Decimal numberBY3 = 0;
                        Decimal numberEY3 = 0;
                        Decimal numberJY3 = 0;
                        Decimal numberLY3 = 0;
                        Decimal PercentBY3 = 0;
                        Decimal PercentEY3 = 0;
                        Decimal PercentJY3 = 0;
                        Decimal PercentLY3 = 0;
                        Decimal PercentGY3 = 0;
                        
                        Decimal numberAY4 = 0;
                        Decimal numberCY4 = 0;
                        Decimal numberDY4 = 0;
                        Decimal numberFY4 = 0;
                        Decimal numberHY4 = 0;
                        Decimal PercentAY4 = 0;
                        Decimal PercentCY4 = 0;
                        Decimal PercentDY4 = 0;
                        Decimal PercentFY4 = 0;
                        Decimal PercentHY4 = 0;
                        //TSC defined for Req #48
                        Decimal numberBY4 = 0;
                        Decimal numberEY4 = 0;
                        Decimal numberJY4 = 0;
                        Decimal numberLY4 = 0;
                        Decimal PercentBY4 = 0;
                        Decimal PercentEY4 = 0;
                        Decimal PercentJY4 = 0;
                        Decimal PercentLY4 = 0;
                        Decimal PercentGY4 = 0;
                        
                        for(Programmatic_Gap__c obj : objCInd.Programmatic_Gaps__r){
                            ProgrammaticGap objwrap = new ProgrammaticGap();
                            objwrap.objPGap = new Programmatic_Gap__c();
                            objwrap.objPGap = obj;
                            /*TCS Changes for Req 48 Starts*/
                         if(objCInd.LLIN__c == false)
                          { 
                            //--TCS - 09/05/2014- Initialized fields to zero for Programmatic Gap of type D
                           /* if(obj.Type_Formula__c == 'D' ) obj.year_1__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.year_2__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.year_3__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.year_4__c = setToZero;
                            
                            if(obj.Type_Formula__c == 'D' ) obj.Year_1_per__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.Year_2_per__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.Year_3_per__c = setToZero;
                            if(obj.Type_Formula__c == 'D' ) obj.Year_4_per__c = setToZero;*/
                            
                            if(obj.Type_Formula__c == 'A' && obj.year_1__c != null) numberA = obj.year_1__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_1__c != null) numberB = obj.year_1__c; // TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_1__c != null) numberC = obj.year_1__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_1__c != null) numberD = obj.year_1__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_1__c != null) numberF = obj.year_1__c;
                           // if(obj.Type_Formula__c == 'H' && obj.year_1__c != null) numberH = obj.year_1__c;
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_1_per__c!= null) PercentA = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_1_per__c!= null) PercentB = obj.Year_1_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_1_per__c!= null) PercentC = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_1_per__c!= null) PercentD = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_1_per__c!= null) PercentF = obj.Year_1_per__c;
                           // if(obj.Type_Formula__c == 'H' && obj.Year_1_per__c!= null) PercentH = obj.Year_1_per__c;
                            
                            if(obj.Type_Formula__c == 'A' && obj.year_2__c != null) numberAY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_2__c != null) numberBY2 = obj.year_2__c; // TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_2__c != null) numberCY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_2__c != null) numberDY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_2__c != null) numberFY2 = obj.year_2__c;
                          //  if(obj.Type_Formula__c == 'H' && obj.year_2__c != null) numberHY2 = obj.year_2__c;
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_2_per__c!= null) PercentAY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_2_per__c!= null) PercentBY2 = obj.Year_2_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_2_per__c!= null) PercentCY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_2_per__c!= null) PercentDY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_2_per__c!= null) PercentFY2 = obj.Year_2_per__c;
                          //  if(obj.Type_Formula__c == 'H' && obj.Year_2_per__c!= null) PercentHY2 = obj.Year_2_per__c;
                            
                            if(obj.Type_Formula__c == 'A' && obj.year_3__c != null) numberAY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_3__c != null) numberBY3 = obj.year_3__c; // TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_3__c != null) numberCY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_3__c != null) numberDY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_3__c != null) numberFY3 = obj.year_3__c;
                          //  if(obj.Type_Formula__c == 'H' && obj.year_3__c != null) numberHY3 = obj.year_3__c;
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_3_per__c!= null) PercentAY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_3_per__c!= null) PercentBY3 = obj.Year_3_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_3_per__c!= null) PercentCY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_3_per__c!= null) PercentDY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_3_per__c!= null) PercentFY3 = obj.Year_3_per__c;
                          //  if(obj.Type_Formula__c == 'H' && obj.Year_3_per__c!= null) PercentHY3 = obj.Year_3_per__c;
                            
                            if(obj.Type_Formula__c == 'A' && obj.year_4__c != null) numberAY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'B' && obj.year_4__c != null) numberBY4 = obj.year_4__c; // TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.year_4__c != null) numberCY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_4__c != null) numberDY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'G' && obj.year_4__c != null) numberFY4 = obj.year_4__c;
                          //  if(obj.Type_Formula__c == 'H' && obj.year_4__c != null) numberHY4 = obj.year_4__c;
                            
                            if(obj.Type_Formula__c == 'A' && obj.Year_4_per__c!= null) PercentAY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'B' && obj.Year_4_per__c!= null) PercentBY4 = obj.Year_4_per__c;// TCS changes for Requirement# 107
                            if(obj.Type_Formula__c == 'C' && obj.Year_4_per__c!= null) PercentCY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'E' && obj.Year_4_per__c!= null) PercentDY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_4_per__c!= null) PercentFY4 = obj.Year_4_per__c;
                           // if(obj.Type_Formula__c == 'H' && obj.Year_4_per__c!= null) PercentHY4 = obj.Year_4_per__c;
                            }
                            else
                          {
                            objWrpCls.showLLIN = true;
                            if(obj.Type_Formula__c == 'B' && obj.year_1__c != null) numberB = obj.year_1__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_1__c != null) numberC = obj.year_1__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_1__c != null) numberD = obj.year_1__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_1__c != null) numberE = obj.year_1__c;
                            if(obj.Type_Formula__c == 'H' && obj.year_1__c != null) numberH = obj.year_1__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_1__c != null) numberJ = obj.year_1__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_1__c != null) numberL = obj.year_1__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_1_per__c!= null) PercentA = obj.Year_1_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_1_per__c!= null) PercentG = obj.Year_1_per__c;
                            
                                                       
                            if(obj.Type_Formula__c == 'B' && obj.year_2__c != null) numberBY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_2__c != null) numberCY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_2__c != null) numberDY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_2__c != null) numberEY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'H' && obj.year_2__c != null) numberHY2 = obj.year_2__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_2__c != null) numberJY2 = obj.year_2__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_2__c != null) numberLY2 = obj.year_2__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_2_per__c!= null) PercentAY2 = obj.Year_2_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_2_per__c!= null) PercentGY2 = obj.Year_2_per__c;
                                                        
                            if(obj.Type_Formula__c == 'B' && obj.year_3__c != null) numberBY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_3__c != null) numberCY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_3__c != null) numberDY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_3__c != null) numberEY3 = obj.year_3__c;
                            system.debug('Three E section'+obj.Type_Formula__c);
                            system.debug('Three E section'+numberEY3);
                            if(obj.Type_Formula__c == 'H' && obj.year_3__c != null) numberHY3 = obj.year_3__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_3__c != null) numberJY3 = obj.year_3__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_3__c != null) numberLY3 = obj.year_3__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_3_per__c!= null) PercentAY3 = obj.Year_3_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_3_per__c!= null) PercentGY3 = obj.Year_3_per__c;
                                                        
                            if(obj.Type_Formula__c == 'B' && obj.year_4__c != null) numberBY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'C' && obj.year_4__c != null) numberCY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'D' && obj.year_4__c != null) numberDY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'E' && obj.year_4__c != null) numberEY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'H' && obj.year_4__c != null) numberHY4 = obj.year_4__c;                            
                            if(obj.Type_Formula__c == 'J' && obj.year_4__c != null) numberJY4 = obj.year_4__c;
                            if(obj.Type_Formula__c == 'L' && obj.year_4__c != null) numberLY4 = obj.year_4__c;
                                                       
                            if(obj.Type_Formula__c == 'A' && obj.Year_4_per__c!= null) PercentAY4 = obj.Year_4_per__c;
                            if(obj.Type_Formula__c == 'G' && obj.Year_4_per__c!= null) PercentGY4 = obj.Year_4_per__c;
    
                          }
                            objwrap.blnHistory =false;
                            objWrpCls.lstProgrammaticGap.add(objwrap);
                        }
                        //objWrpCls.ProgrammaticGap.AddAll(objCInd.Programmatic_Gaps__r);
                        if(objCInd.LLIN__c == false)
                          {
                            if(numberB==0){
                            	system.debug('Inside B'+numberB);
           					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'If other is selected please enter a description');//Same old drama 
							ApexPages.addMessage(myMsg);
           					}
                        /* TCS changes for Requirement# 107 --Begin--*/
                            if(objCInd.Indicator_for_PG_Calculation_E__c)
                                {                                              
                        objWrpCls.Year1NumberE = numberB - numberC;
                        objWrpCls.Year2NumberE = numberBY2 - numberCY2;
                        objWrpCls.Year3NumberE = numberBY3 - numberCY3;
                        objWrpCls.Year4NumberE = numberBY4 - numberCY4;
                        if(numberB != 0)
                        //objWrpCls.Year1PercentE = integer.valueOf(((numberB - numberC)/numberB)*100);
                        objWrpCls.Year1PercentE = (((numberB - numberC)/numberB)*100).setScale(2);
                        
                        else
                        objWrpCls.Year1PercentE = 0;
                        if(numberBY2 != 0)
                        //objWrpCls.Year2PercentE = integer.valueof(((numberBY2 - numberCY2)/numberBY2)*100);
                        objWrpCls.Year2PercentE = (((numberBY2 - numberCY2)/numberBY2)*100).setScale(2);
                        else
                        objWrpCls.Year2PercentE = 0;
                        if(numberBY3 != 0)
                        //objWrpCls.Year3PercentE = integer.valueof(((numberBY3 - numberCY3)/numberBY3)*100);
                        objWrpCls.Year3PercentE = (((numberBY3 - numberCY3)/numberBY3)*100).setScale(2);
                        else
                        objWrpCls.Year3PercentE = 0;
                        if(numberBY4 != 0)
                        //objWrpCls.Year4PercentE = integer.valueof(((numberBY4 - numberCY4)/numberBY4)*100);
                        objWrpCls.Year4PercentE = (((numberBY4 - numberCY4)/numberBY4)*100).setScale(2);   
                        else
                        objWrpCls.Year4PercentE = 0;
                                }
                            else{
                        objWrpCls.Year1NumberE = numberA - numberC;
                        //objWrpCls.Year1PercentE = 100 - PercentC;
                        objWrpCls.Year1PercentE = (100 - PercentC).setScale(2);
                        objWrpCls.Year2NumberE = numberAY2 - numberCY2;
                        //objWrpCls.Year2PercentE = 100 - PercentCY2;
                        objWrpCls.Year2PercentE = (100 - PercentCY2).setScale(2);
                        objWrpCls.Year3NumberE = numberAY3 - numberCY3;
                        //objWrpCls.Year3PercentE = 100 - PercentCY3;
                        objWrpCls.Year3PercentE = (100 - PercentCY3).setScale(2);
                        objWrpCls.Year4NumberE = numberAY4 - numberCY4;
                        //objWrpCls.Year4PercentE = 100 - PercentCY4;
                        objWrpCls.Year4PercentE = (100 - PercentCY4).setScale(2);
                                 }
                        /* TCS changes for Requirement# 107 --End--*/   
                              
                        objWrpCls.Year1NumberG = NumberD + numberC ; //Calculating F instead of G
                        //objWrpCls.Year1PercentG = PercentD + PercentC ;
                        objWrpCls.Year1PercentG = (PercentD + PercentC).setScale(2);
                        objWrpCls.Year1NumberI = NumberD + numberC + numberF;//
                        //objWrpCls.Year1PercentI = (PercentC + PercentD) + PercentF;
                        objWrpCls.Year1PercentI = ((PercentC + PercentD) + PercentF).setScale(2);
                           
                        objWrpCls.Year2NumberG = numberCY2 + numberDY2;
                        //objWrpCls.Year2PercentG = PercentCY2 + PercentDY2;
                        objWrpCls.Year2PercentG = (PercentCY2 + PercentDY2).setScale(2);
                        objWrpCls.Year2NumberI = NumberFY2 + numberCY2 + numberDY2;
                        //objWrpCls.Year2PercentI = PercentFY2 + PercentCY2 + PercentDY2;
                        objWrpCls.Year2PercentI = (PercentFY2 + PercentCY2 + PercentDY2).setScale(2);
                        
                        objWrpCls.Year3NumberG = numberCY3 + numberDY3;
                        //objWrpCls.Year3PercentG = PercentCY3 + PercentDY3;
                        objWrpCls.Year3PercentG = (PercentCY3 + PercentDY3).setScale(2);
                        objWrpCls.Year3NumberI = NumberFY3 + numberCY3 + numberDY3;
                        //objWrpCls.Year3PercentI = PercentFY3 + PercentCY3 + PercentDY3;
                        objWrpCls.Year3PercentI = (PercentFY3 + PercentCY3 + PercentDY3).setScale(2);
                            
                        objWrpCls.Year4NumberG = numberCY4 + numberDY4;
                        //objWrpCls.Year4PercentG = PercentCY4 + PercentDY4;
                        objWrpCls.Year4PercentG = (PercentCY4 + PercentDY4).setScale(2);
                        objWrpCls.Year4NumberI = NumberFY4 + numberCY4 + numberDY4;
                        //objWrpCls.Year4PercentI = PercentFY4 + PercentCY4 + PercentDY4;
                        objWrpCls.Year4PercentI = (PercentFY4 + PercentCY4 + PercentDY4).setScale(2);
                        
                        objWrpCls.YearE1=objWrpCls.Year1NumberE.format();
                        objWrpCls.YearE2=objWrpCls.Year2NumberE.format();
                        objWrpCls.YearE3=objWrpCls.Year3NumberE.format();
                        objWrpCls.YearE4=objWrpCls.Year4NumberE.format();
                        
                        objWrpCls.YearG1=objWrpCls.Year1NumberG.format();
                        objWrpCls.YearG2=objWrpCls.Year2NumberG.format();
                        objWrpCls.YearG3=objWrpCls.Year3NumberG.format();
                        objWrpCls.YearG4=objWrpCls.Year4NumberG.format();
                        
                        objWrpCls.YearI1=objWrpCls.Year1NumberI.format();
                        objWrpCls.YearI2=objWrpCls.Year2NumberI.format();
                        objWrpCls.YearI3=objWrpCls.Year3NumberI.format();
                        objWrpCls.YearI4=objWrpCls.Year4NumberI.format();
                         }
                        else {
                        objWrpCls.Year1NumberF = numberC + numberD + numberE;                        
                        objWrpCls.Year1NumberG = objWrpCls.Year1NumberF + numberB;
                        objWrpCls.Year1NumberI = objWrpCls.Year1NumberG - numberH;
                        objWrpCls.Year1NumberK = numberJ + numberH;
                        objWrpCls.Year1NumberM = objWrpCls.Year1NumberK + numberL;
                            if(objWrpCls.Year1NumberG == 0)
                            {
                                objWrpCls.Year1PercentH = 0;
                                objWrpCls.Year1PercentJ = 0;
                                objWrpCls.Year1PercentK = 0;
                                objWrpCls.Year1PercentL = 0;
                                objWrpCls.Year1PercentM = 0;
                                objWrpCls.Year1PercentI = 0;
                            }
                        else {
                               /* if(numberH != 0)objWrpCls.Year1PercentH = Math.round((numberH / objWrpCls.Year1NumberG) * 100);
                                if(objWrpCls.Year1NumberI != 0)  objWrpCls.Year1PercentI = Math.round((objWrpCls.Year1NumberI / objWrpCls.Year1NumberG) * 100);
                                if(numberJ != 0)objWrpCls.Year1PercentJ = Math.round((numberJ / objWrpCls.Year1NumberG) * 100);
                                if(objWrpCls.Year1NumberK != 0) objWrpCls.Year1PercentK = Math.round((objWrpCls.Year1NumberK / objWrpCls.Year1NumberG) * 100);
                                if(numberL != 0)objWrpCls.Year1PercentL = Math.round((NumberL / objWrpCls.Year1NumberG) * 100);
                                if(objWrpCls.Year1NumberM != 0)objWrpCls.Year1PercentM = Math.round((objWrpCls.Year1NumberM / objWrpCls.Year1NumberG) * 100);*/
                                
                                if(numberH != 0)objWrpCls.Year1PercentH = ((numberH / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(objWrpCls.Year1NumberI != 0)  objWrpCls.Year1PercentI = ((objWrpCls.Year1NumberI / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(numberJ != 0)objWrpCls.Year1PercentJ = ((numberJ / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(objWrpCls.Year1NumberK != 0) objWrpCls.Year1PercentK = ((objWrpCls.Year1NumberK / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(numberL != 0)objWrpCls.Year1PercentL = ((NumberL / objWrpCls.Year1NumberG) * 100).setScale(2);
                                if(objWrpCls.Year1NumberM != 0)objWrpCls.Year1PercentM = ((objWrpCls.Year1NumberM / objWrpCls.Year1NumberG) * 100).setScale(2);
                        }
                        objWrpCls.Year2NumberF = numberCY2 + numberDY2 + numberEY2;                        
                        objWrpCls.Year2NumberG = objWrpCls.Year2NumberF + numberBY2;
                        objWrpCls.Year2NumberI = objWrpCls.Year2NumberG - numberHY2;
                        objWrpCls.Year2NumberK = numberJY2 + numberHY2;
                        objWrpCls.Year2NumberM = objWrpCls.Year2NumberK + numberLY2;
                            if(objWrpCls.Year2NumberG == 0)
                            {
                                objWrpCls.Year2PercentH = 0;
                                objWrpCls.Year2PercentJ = 0;
                                objWrpCls.Year2PercentK = 0;
                                objWrpCls.Year2PercentL = 0;
                                objWrpCls.Year2PercentM = 0;
                                objWrpCls.Year2PercentI = 0;
                            }
                        else {
                               /* if(numberHY2 != 0)objWrpCls.Year2PercentH = Math.round((numberHY2 / objWrpCls.Year2NumberG) * 100);
                                if(objWrpCls.Year2NumberI != 0)  objWrpCls.Year2PercentI = Math.round((objWrpCls.Year2NumberI / objWrpCls.Year2NumberG) * 100);
                                if(numberJY2 != 0)objWrpCls.Year2PercentJ = Math.round((numberJY2 / objWrpCls.Year2NumberG) * 100);
                                if(objWrpCls.Year2NumberK != 0) objWrpCls.Year2PercentK = Math.round((objWrpCls.Year2NumberK / objWrpCls.Year2NumberG) * 100);
                                if(numberL != 0)objWrpCls.Year2PercentL = Math.round((NumberLY2 / objWrpCls.Year2NumberG) * 100);
                                if(objWrpCls.Year2NumberM != 0)objWrpCls.Year2PercentM = Math.round((objWrpCls.Year2NumberM / objWrpCls.Year2NumberG) * 100);*/
                                
                                if(numberHY2 != 0)objWrpCls.Year2PercentH = ((numberHY2 / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(objWrpCls.Year2NumberI != 0)  objWrpCls.Year2PercentI = ((objWrpCls.Year2NumberI / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(numberJY2 != 0)objWrpCls.Year2PercentJ = ((numberJY2 / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(objWrpCls.Year2NumberK != 0) objWrpCls.Year2PercentK = ((objWrpCls.Year2NumberK / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(numberL != 0)objWrpCls.Year2PercentL = ((NumberLY2 / objWrpCls.Year2NumberG) * 100).setScale(2);
                                if(objWrpCls.Year2NumberM != 0)objWrpCls.Year2PercentM = ((objWrpCls.Year2NumberM / objWrpCls.Year2NumberG) * 100).setScale(2);
                        }
                        
                        objWrpCls.Year3NumberF = numberCY3 + numberDY3 + numberEY3;                        
                        objWrpCls.Year3NumberG = objWrpCls.Year3NumberF + numberBY3;
                        objWrpCls.Year3NumberI = objWrpCls.Year3NumberG - numberHY3;
                        objWrpCls.Year3NumberK = numberJY3 + numberHY3;
                        objWrpCls.Year3NumberM = objWrpCls.Year3NumberK + numberLY3;
                            if(objWrpCls.Year3NumberG == 0)
                            {
                                objWrpCls.Year3PercentH = 0;
                                objWrpCls.Year3PercentJ = 0;
                                objWrpCls.Year3PercentK = 0;
                                objWrpCls.Year3PercentL = 0;
                                objWrpCls.Year3PercentM = 0;
                                objWrpCls.Year3PercentI = 0;
                            }
                        else {
                                /*if(numberHY3 != 0)objWrpCls.Year3PercentH = Math.round((numberHY3 / objWrpCls.Year3NumberG) * 100);
                                if(objWrpCls.Year3NumberI != 0)  objWrpCls.Year3PercentI = Math.round((objWrpCls.Year3NumberI / objWrpCls.Year3NumberG) * 100);
                                if(numberJY3 != 0)objWrpCls.Year3PercentJ = Math.round((numberJY3 / objWrpCls.Year3NumberG) * 100);
                                if(objWrpCls.Year3NumberK != 0) objWrpCls.Year3PercentK = Math.round((objWrpCls.Year3NumberK / objWrpCls.Year3NumberG) * 100);
                                if(numberLY3 != 0)objWrpCls.Year3PercentL = Math.round((NumberLY3 / objWrpCls.Year3NumberG) * 100);
                                if(objWrpCls.Year3NumberM != 0)objWrpCls.Year3PercentM = Math.round((objWrpCls.Year3NumberM / objWrpCls.Year3NumberG) * 100);*/
                                
                                if(numberHY3 != 0)objWrpCls.Year3PercentH = ((numberHY3 / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(objWrpCls.Year3NumberI != 0)  objWrpCls.Year3PercentI = ((objWrpCls.Year3NumberI / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(numberJY3 != 0)objWrpCls.Year3PercentJ = ((numberJY3 / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(objWrpCls.Year3NumberK != 0) objWrpCls.Year3PercentK = ((objWrpCls.Year3NumberK / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(numberLY3 != 0)objWrpCls.Year3PercentL = ((NumberLY3 / objWrpCls.Year3NumberG) * 100).setScale(2);
                                if(objWrpCls.Year3NumberM != 0)objWrpCls.Year3PercentM = ((objWrpCls.Year3NumberM / objWrpCls.Year3NumberG) * 100).setScale(2);
                        }
                        
                        objWrpCls.Year4NumberF = numberCY4 + numberDY4 + numberEY4;                        
                        objWrpCls.Year4NumberG = objWrpCls.Year4NumberF + numberBY4;
                        objWrpCls.Year4NumberI = objWrpCls.Year4NumberG - numberHY4;
                        objWrpCls.Year4NumberK = numberJY4 + numberHY4;
                        objWrpCls.Year4NumberM = objWrpCls.Year4NumberK + numberLY4;
                            if(objWrpCls.Year4NumberG == 0)
                            {
                                objWrpCls.Year4PercentH = 0;
                                objWrpCls.Year4PercentJ = 0;
                                objWrpCls.Year4PercentK = 0;
                                objWrpCls.Year4PercentL = 0;
                                objWrpCls.Year4PercentM = 0;
                                objWrpCls.Year4PercentI = 0;
                            }
                        else {
                                /*if(numberHY4 != 0)objWrpCls.Year4PercentH = Math.round((numberHY4 / objWrpCls.Year4NumberG) * 100);
                                if(objWrpCls.Year4NumberI != 0)  objWrpCls.Year4PercentI = Math.round((objWrpCls.Year4NumberI / objWrpCls.Year4NumberG) * 100);
                                if(numberJY4 != 0)objWrpCls.Year4PercentJ = Math.round((numberJY4 / objWrpCls.Year4NumberG) * 100);
                                if(objWrpCls.Year4NumberK != 0) objWrpCls.Year4PercentK = Math.round((objWrpCls.Year4NumberK / objWrpCls.Year4NumberG) * 100);
                                if(numberLY4 != 0)objWrpCls.Year4PercentL = Math.round((NumberLY4 / objWrpCls.Year4NumberG) * 100);
                                if(objWrpCls.Year4NumberM != 0)objWrpCls.Year4PercentM = Math.round((objWrpCls.Year4NumberM / objWrpCls.Year4NumberG) * 100);*/
                                
                                
                                if(numberHY4 != 0)objWrpCls.Year4PercentH = ((numberHY4 / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(objWrpCls.Year4NumberI != 0)  objWrpCls.Year4PercentI = ((objWrpCls.Year4NumberI / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(numberJY4 != 0)objWrpCls.Year4PercentJ = ((numberJY4 / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(objWrpCls.Year4NumberK != 0) objWrpCls.Year4PercentK = ((objWrpCls.Year4NumberK / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(numberLY4 != 0)objWrpCls.Year4PercentL = ((NumberLY4 / objWrpCls.Year4NumberG) * 100).setScale(2);
                                if(objWrpCls.Year4NumberM != 0)objWrpCls.Year4PercentM = ((objWrpCls.Year4NumberM / objWrpCls.Year4NumberG) * 100).setScale(2);
                        		}  
                        		objWrpCls.YearF1=objWrpCls.Year1NumberF.format();
		                        objWrpCls.YearF2=objWrpCls.Year2NumberF.format();
		                        objWrpCls.YearF3=objWrpCls.Year3NumberF.format();
		                        objWrpCls.YearF4=objWrpCls.Year4NumberF.format();
		                        
		                        objWrpCls.YearG1=objWrpCls.Year1NumberG.format();
		                        objWrpCls.YearG2=objWrpCls.Year2NumberG.format();
		                        objWrpCls.YearG3=objWrpCls.Year3NumberG.format();
		                        objWrpCls.YearG4=objWrpCls.Year4NumberG.format();
		                        
		                        objWrpCls.YearI1=objWrpCls.Year1NumberI.format();
		                        objWrpCls.YearI2=objWrpCls.Year2NumberI.format();
		                        objWrpCls.YearI3=objWrpCls.Year3NumberI.format();
		                        objWrpCls.YearI4=objWrpCls.Year4NumberI.format(); 
		                        
		                        objWrpCls.YearK1=objWrpCls.Year1NumberK.format();
		                        objWrpCls.YearK2=objWrpCls.Year2NumberK.format();
		                        objWrpCls.YearK3=objWrpCls.Year3NumberK.format();
		                        objWrpCls.YearK4=objWrpCls.Year4NumberK.format();
		                        
		                        objWrpCls.YearM1=objWrpCls.Year1NumberM.format();
		                        objWrpCls.YearM2=objWrpCls.Year2NumberM.format();
		                        objWrpCls.YearM3=objWrpCls.Year3NumberM.format();
		                        objWrpCls.YearM4=objWrpCls.Year4NumberM.format(); 
                          }
                        /*TCS Changes for Req 48 End*/
                        objWrpCls.Name = objWrpCls.lstProgrammaticGap[0].objPGap.Program_Area__c;
                        objWrpCls.CoverageComments = objWrpCls.lstProgrammaticGap[0].objPGap.Coverage_Comments__c;
                        objWrpCls.KeyMetric = objWrpCls.lstProgrammaticGap[0].objPGap.Metric__c;
                        objWrpCls.GroupSequence = index;
                           if(blnCIndicatorLLIN)
                           {
                             objWrpCls.IndicatorName = strLLINIndName;
                           }
                           else
                          {
                            objWrpCls.IndicatorName = objCInd.Full_Name_En__c;
                          }
                          if(strUserLanguage == 'FRENCH') objWrpCls.IndicatorName = objCInd.French_Name__c;
                          if(strUserLanguage == 'RUSSIAN') objWrpCls.IndicatorName = objCInd.Russian_Name__c;
                          if(strUserLanguage == 'SPANISH') objWrpCls.IndicatorName = objCInd.Spanish_Name__c;
                        objWrpCls.isShow = true;
                        objWrpCls.blndisplaySave = true;
                        
                        
                        
                        lstWrapCls.Add(objWrpCls);
                        
                        
                        Index ++;
                    }
                    
                     
                    
                }
                /* TCS changes for Requirement# 48 --Begin--*/
                if(!blnCIndicatorLLIN)
                {
                if(CIndOptions.size()  > 0){
                    integer count = 0;
                    for(SelectOption sel : CIndOptions){
                        if(sel.getValue() != null && sel.getValue() != ''){
                                
                             if(sel.getValue() == finalPG[0].Catalog_Indicator__c){
                                break;
                            }
                        }
                        count++;
                    }
                    if(test.isrunningtest() == false){
                        CIndOptions.remove(count);
                    }
                }
                }
                /* TCS changes for Requirement# 48 --End--*/
                else
                {
                for(Integer i = 0; i< lstAllLLINforModule.size(); i++) 
                {
                 if(CIndOptions.size()  > 0){
                    integer count = 0;
  
  
                        for(SelectOption sel : CIndOptions){
                        if(sel.getValue() != null && sel.getValue() != ''){
                                
                                if(sel.getValue() == lstAllLLINforModule[i].Id)
                                {
                                break;
                            }
                          
                        }
                        count++;
                    }

  if(test.isrunningtest() == false){

                        	CIndOptions.remove(count);
  	                    
                    }
                }
               }
              }
                Integer i=0;                                
            }
        } // if of finalPG.size
        
       blnSave= true; //TCS Changes for Save and Edit Cycle
       blnEdit = true;
    }
    
    Public void DeletePG(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(DeleteIndex != null){
            if(lstWrapCls[DeleteIndex].objCI.LLIN__c  == true){
                system.debug('**boolean Indi**'+blnCIndicatorLLIN);
            List<Programmatic_Gap__c> lstPGToDeleteLLIN = [Select ID, Catalog_Indicator__r.LLIN__c, Catalog_Indicator__c, Catalog_Indicator__r.Module__c,Catalog_Indicator__r.Full_Name_En__c From Programmatic_Gap__c
                                                            Where Catalog_Indicator__r.LLIN__c = true
                                                            And Module__c=:strModuleId];
            List<Indicator__c> lstAll = [Select Name, ID, Full_Name_En__c FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                    And Indicator_Type__c =: 'Coverage/Output'
                                    And Available_for_PG__c = true
                                    And LLIN__c = true]; 
             System.debug('lstAll ^^^^^' +lstAll);                        
            System.debug('lstPGToDelete1 ^^^^^' +lstPGToDeleteLLIN);
            if(lstPGToDeleteLLIN.size() > 0) Delete lstPGToDeleteLLIN;
            for(Indicator__c p: lstAll)
            {CIndOptions.add(new SelectOption(p.Id,p.Full_Name_En__c));
             System.debug('CIndOptions999'+CIndOptions);
            }
           lstWrapCls.remove(DeleteIndex);
            }
            else{
            List<Programmatic_Gap__c> lstPGToDelete = new List<Programmatic_Gap__c>();
             for(ProgrammaticGap objPG : lstWrapCls[DeleteIndex].lstProgrammaticGap){
                lstPGToDelete.add(objPG.objPGap);
               // lstPGToDelete.addAll(lstPGToDeleteLLIN);
            }
            if(lstPGToDelete.size() > 0) Delete lstPGToDelete;
            
           CIndOptions.add(new SelectOption(lstWrapCls[DeleteIndex].objCI.Id,lstWrapCls[DeleteIndex].objCI.Full_Name_En__c));
           lstWrapCls.remove(DeleteIndex);
        }
        
       /*TCS Changes for Edit and Save Cycle after Delete*/ 
       if(lstWrapCls.size()>0){
                 blnSave = true;
        }
        else{
                blnSave = false;
       }
        
    }
    }
    Public PageReference savePG(){
        quickSavePG();
              
        PageReference Pr = New PageReference('/apex/ConceptNoteOverview?Id='+ConceptNoteID);
        return Pr;
    }
    
    Public PageReference cancelPG(){
         
        /*PageReference Pr = New PageReference('/apex/ConceptNoteOverview?Id='+ConceptNoteID);
        return Pr;*/
        return null;
    }
    Public void SaveStandardIndicator(){}
    
    Public class wrapperClsModulePG {
         
        Public Grant_Indicator__c objGI{get;set;}
        Public Indicator__c objCI{get;set;}
        
        Public Boolean blnIndicatorDisplay {get;set;}
        Public Boolean blndisplaySave {get;set;}
        Public Boolean showLLIN {get;set;}
        Public Boolean showNewE1 {get;set;}
        
        Public String IndicatorName {get;set;}
        Public decimal GroupSequence {get;set;}
        Public String Name {get;set;}
        Public String KeyMetric {get;set;}
        Public String CoverageComments {get;set;}
        Public List<ProgrammaticGap> lstProgrammaticGap {get;set;}
        
        //Year1 variables
        Public Decimal Year1Number1 {get;set;}        
        Public Decimal Year1Number2 {get;set;}        
        Public Decimal Year1Number3 {get;set;}        
        Public Decimal Year1PercentA {get;set;}
        
        Public Decimal Year1NumberB {get;set;}
        Public Decimal Year1PercentB {get;set;}
        Public Decimal Year1NumberC {get;set;}
        Public Decimal Year1PercentC {get;set;}
        Public Decimal year1NumberD {get;set;}
        Public Decimal year1PercentD {get;set;}        
        Public Decimal Year1NumberE {get;set;}
        Public Decimal Year1PercentE {get;set;}
        Public Decimal Year1NumberF {get;set;}
        Public Decimal Year1PercentF {get;set;}        
        Public Decimal Year1NumberG {get;set;}
        Public Decimal Year1PercentG {get;set;}        
        Public Decimal Year1NumberH {get;set;}
        Public Decimal Year1PercentH {get;set;}
        Public Decimal Year1NumberI {get;set;}
        Public Decimal Year1PercentI {get;set;}        
        Public Decimal Year1NumberJ {get;set;}
        Public Decimal Year1PercentJ {get;set;}
        Public Decimal Year1NumberK {get;set;}
        Public Decimal Year1PercentK {get;set;}
        Public Decimal Year1NumberL {get;set;}
        Public Decimal Year1PercentL {get;set;}
        Public Decimal Year1NumberM {get;set;}
        Public Decimal Year1PercentM {get;set;}
        
        //Year2 variables
        Public Decimal year2Number1 {get;set;}        
        Public Decimal year2Number2 {get;set;}        
        Public Decimal year2Number3 {get;set;}        
        Public Decimal year2PercentA {get;set;}
        
        Public Decimal year2NumberB {get;set;}
        Public Decimal year2PercentB {get;set;}
        Public Decimal year2NumberC {get;set;}
        Public Decimal year2PercentC {get;set;}
        Public Decimal year2NumberD {get;set;}
        Public Decimal year2PercentD {get;set;}        
        Public Decimal year2NumberE {get;set;}
        Public Decimal year2PercentE {get;set;}
        Public Decimal year2NumberF {get;set;}
        Public Decimal year2PercentF {get;set;}        
        Public Decimal year2NumberG {get;set;}
        Public Decimal year2PercentG {get;set;}        
        Public Decimal year2NumberH {get;set;}
        Public Decimal year2PercentH {get;set;}
        Public Decimal year2NumberI {get;set;}
        Public Decimal year2PercentI {get;set;}        
        Public Decimal year2NumberJ {get;set;}
        Public Decimal year2PercentJ {get;set;}
        Public Decimal year2NumberK {get;set;}
        Public Decimal year2PercentK {get;set;}
        Public Decimal year2NumberL {get;set;}
        Public Decimal year2PercentL {get;set;}
        Public Decimal year2NumberM {get;set;}
        Public Decimal year2PercentM {get;set;}
        
        //Year3 variables
        Public Decimal year3Number1 {get;set;}        
        Public Decimal year3Number2 {get;set;}        
        Public Decimal year3Number3 {get;set;}        
        Public Decimal year3PercentA {get;set;}
        
        Public Decimal year3NumberB {get;set;}
        Public Decimal year3PercentB {get;set;}
        Public Decimal year3NumberC {get;set;}
        Public Decimal year3PercentC {get;set;}
        Public Decimal year3NumberD {get;set;}
        Public Decimal year3PercentD {get;set;}        
        Public Decimal year3NumberE {get;set;}
        Public Decimal year3PercentE {get;set;}
        Public Decimal year3NumberF {get;set;}
        Public Decimal year3PercentF {get;set;}        
        Public Decimal year3NumberG {get;set;}
        Public Decimal year3PercentG {get;set;}        
        Public Decimal year3NumberH {get;set;}
        Public Decimal year3PercentH {get;set;}
        Public Decimal year3NumberI {get;set;}
        Public Decimal year3PercentI {get;set;}        
        Public Decimal year3NumberJ {get;set;}
        Public Decimal year3PercentJ {get;set;}
        Public Decimal year3NumberK {get;set;}
        Public Decimal year3PercentK {get;set;}
        Public Decimal year3NumberL {get;set;}
        Public Decimal year3PercentL {get;set;}
        Public Decimal year3NumberM {get;set;}
        Public Decimal year3PercentM {get;set;}
        
        //Year4 variables
        Public Decimal year4Number1 {get;set;}        
        Public Decimal year4Number2 {get;set;}        
        Public Decimal year4Number3 {get;set;}        
        Public Decimal year4PercentA {get;set;}
        
        Public Decimal year4NumberB {get;set;}
        Public Decimal year4PercentB {get;set;}
        Public Decimal year4NumberC {get;set;}
        Public Decimal year4PercentC {get;set;} 
        Public Decimal year4NumberD {get;set;}
        Public Decimal year4PercentD {get;set;}       
        Public Decimal year4NumberE {get;set;}
        Public Decimal year4PercentE {get;set;}
        Public Decimal year4NumberF {get;set;}
        Public Decimal year4PercentF {get;set;}        
        Public Decimal year4NumberG {get;set;}
        Public Decimal year4PercentG {get;set;}        
        Public Decimal year4NumberH {get;set;}
        Public Decimal year4PercentH {get;set;}
        Public Decimal year4NumberI {get;set;}
        Public Decimal year4PercentI {get;set;}        
        Public Decimal year4NumberJ {get;set;}
        Public Decimal year4PercentJ {get;set;}
        Public Decimal year4NumberK {get;set;}
        Public Decimal year4PercentK {get;set;}
        Public Decimal year4NumberL {get;set;}
        Public Decimal year4PercentL {get;set;}
        Public Decimal year4NumberM {get;set;}
        Public Decimal year4PercentM {get;set;}
        
        Public String YearE1{get;set;}
        Public String YearE2{get;set;}
        Public String YearE3{get;set;}
        Public String YearE4{get;set;}
        
        Public String YearG1{get;set;}
        Public String YearG2{get;set;}
        Public String YearG3{get;set;}
        Public String YearG4{get;set;}
        
        Public String YearI1{get;set;}
        Public String YearI2{get;set;}
        Public String YearI3{get;set;}
        Public String YearI4{get;set;}
        
        Public String YearF1{get;set;}
        Public String YearF2{get;set;}
        Public String YearF3{get;set;}
        Public String YearF4{get;set;}
        
        Public String YearK1{get;set;}
        Public String YearK2{get;set;}
        Public String YearK3{get;set;}
        Public String YearK4{get;set;}
        
        Public String YearM1{get;set;}
        Public String YearM2{get;set;}
        Public String YearM3{get;set;}
        Public String YearM4{get;set;}
                
        //Public List<Programmatic_Gap__c> lstPG{get;set;}
        public Boolean isShow{get;set;}
    }
    Public Class GrantIndicatorResult{
        Public Boolean blnIndicatorDisplay  {get;set;}
        Public Boolean blndisplaySave {get;set;}
        
        Public Grant_Indicator__c objGrantIndicator {get;set;}
        Public String strAssumptions {get;set;}
        Public String strCountryTeamComments {get;set;}
        Public String strLFAComments {get;set;}
        Public List<Result__c> lstResults {get;set;}
        Public Boolean blnHasPost {get;set;}
        Public Integer intPostCount {get;set;}
    }
    Public Class ProgrammaticGap{
        
        Public Boolean blnHistory {get;set;}
        Public Programmatic_Gap__c objPGap {get;set;}
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
        }
    }   
    Public void SaveCycle(){
        
        /*TCS Changes for Updating Cycle in DataBase when edited*/
        
        objModuleToUpdateCycle.PG_Cycle__c = strSelectedCycle;
        update objModuleToUpdateCycle;
        System.debug('**In SAve MOdule**'+objModuleToUpdateCycle);
        System.debug('**strselected**'+strSelectedCycle);
        
    }
    Public PageReference BackCNOverview(){
        PageReference  pageRef = new PageReference('/apex/CNOverview?id='+ConceptNoteId);
        return pageRef ;
    }
    Public void fetchLLINformodule(){
        lstLLINforModule = new List<Indicator__c>();
        lstAllLLINforModule = new List<Indicator__c>();
        //LLIN = false;
        Indicator__c holder = [Select LLIN__c FROM Indicator__c Where Id=:strSelectedIndicator];
        system.debug('Indicator: '+strSelectedIndicator);
        system.debug('LLIN_c: '+holder.LLIN__c);
        LLIN = holder.LLIN__c;
        system.debug('LLIN: '+LLIN);
        if(holder.LLIN__c)
        lstLLINforModule = [Select Name, ID, Full_Name_En__c FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                    And Indicator_Type__c =: 'Coverage/Output'
                                    And Available_for_PG__c = true
                                    And Id !=: strSelectedIndicator
                                    And LLIN__c = true];    
        lstAllLLINforModule = [Select Name, ID, Full_Name_En__c FROM Indicator__c Where Catalog_Module__c =: strCatalogModule
                                    And Indicator_Type__c =: 'Coverage/Output'
                                    And Available_for_PG__c = true
                                    And LLIN__c = true];                                   
        //System.debug('lstLLINforModule ****' +lstLLINforModule[0].Id);
        //return LLIN;
    } 
    public void checkProfile(){
    blnExternalPro =false;
    blnSaveCycle =false;
    blnEditCycle =false;
    blnAddPGTable =false;
    blnEditTable =false;
    blnDelTable =false;
    blnCCMComments =false;
    blnLFAComments =false;
    blnTGFComments =false;
    blnSaveCust =false;
    blnCancel =false;
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Id, PermissionSet.Name, PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='new_programmaticgap' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets)];
      
      for (Profile_Access_Setting_CN__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Save Cycle' && check.Status__c== strStatus) blnSaveCycle = true;
        if(check.Salesforce_Item__c == 'Edit Cycle' && check.Status__c== strStatus) blnEditCycle = true;
         if(check.Salesforce_Item__c == 'Add Programmatic Table' && check.Status__c== strStatus)blnAddPGTable = true;
         if(check.Salesforce_Item__c == 'Edit Table' && check.Status__c== strStatus)blnEditTable = true;
         if(check.Salesforce_Item__c == 'Delete Table' && check.Status__c== strStatus)blnDelTable = true;
         if(check.Salesforce_Item__c == 'CCM Comments' && check.Status__c== strStatus) blnCCMComments = true;
         if(check.Salesforce_Item__c == 'LFA Comments' && check.Status__c== strStatus)blnLFAComments = true;
         if(check.Salesforce_Item__c == 'TGF Comments' && check.Status__c== strStatus)blnTGFComments = true;
         if(check.Salesforce_Item__c == 'Save' && check.Status__c== strStatus)blnSaveCust = true;
         if(check.Salesforce_Item__c == 'Cancel' && check.Status__c== strStatus)blnCancel = true;
       }
    }
    
}