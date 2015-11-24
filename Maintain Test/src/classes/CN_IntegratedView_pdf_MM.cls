/*********************************************************************************
* Controller Class: ctrlCNintegratedPdf
* DateCreated:  12/20/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - concatenated from CN_GrantCoverageOutputIndicator, CN_Budget and GM_IntegratedView
----------------------------------------------------------------------------------
* Unit Test:
----------------------------------------------------------------------------------
* History:
* - VERSION  DATE            DETAIL FEATURES
    1.0      12/20/2013      INITIAL DEVELOPMENT   
*********************************************************************************/
Public Class CN_IntegratedView_pdf_MM{
    Public List<Goals_Objectives__c> lstGoals {get;set;}
    Public List<Goals_Objectives__c> lstObjectives {get;set;}
    Public List<Ind_Goal_Jxn__c> lstGoaljunction{get;set;}
    Public List<Ind_Goal_Jxn__c> lstObjectivejunction{get;set;}
    Public List<Grant_Indicator__c> lstImpactIndicators {get;set;}
    Public List<Grant_Indicator__c> lstOutcomeIndicators {get;set;}
    Public List<CNModule> lstCNModule{get;set;}
    Public Decimal intTotalIndicativemain {get;set;}
    Public Decimal intTotalAbovemain {get;set;}
    public List<WrapperCPFAllReport> lstWrapperCPFAllReport{get;set;}
    public List<CPF_Report__c> lstCPFNewFundingReport{get;set;}
    Public List<BLModule> lstBLModule {get;set;}
    Public List<BLModulePR> lstBLModulePR {get;set;}
    Concept_Note__c objCN;
    //Public Date objdt = System.Today();
    Public String objname{get;set;}
    Public String Pathpdf ='';
    Public string datename {get;set;}
    
    //----Programatic gap
    Public List<wrapperClsModulePG> lstWrapCls{get;set;} 
    Public List<Module__c> lstModuleNew{get;set;}
    Public String strCatalogModule;
    Public String ConceptNoteId {get;set;}
    Public String strUserLanguage {get;set;}
    Public Boolean showNewE {get;set;}
    Public Decimal setToZero {get;set;}  
        
    // --------------- CPF Report ----------------------
    Public List<CPF_Report__c> lstCPFR;
    Public List<CPF_Report__c> lstCPFReport {get;set;}
    Public CPF_Report__c objCPFReport {get;set;}
    Public List<Funding_Source__c> lstFundingSource;
    Public Map<String,String> MapDisplayMonth {get;set;}
    Public Boolean blnReadOnly {get;set;}
    Public String strCNId {get;set;}
    Public String strCountryId {get;set;}
    Public String strGuidanceId {get;set;}
    Public String strLanguage {get;set;}
    Public String strComponent {get;set;}
    Public Integer TotalModuleY1CostA {get;set;}
    Public Integer TotalModuleY2CostA {get;set;}
    Public Integer TotalModuleY3CostA {get;set;}
    Public Integer TotalModuleY4CostA {get;set;}
    Public Integer AllYearModuleTotalCostA  {get;set;}
    Public Integer AllYearModuleTotalCostI  {get;set;}
    Public Integer TotalModuleY1CostI {get;set;}
    Public Integer TotalModuleY2CostI {get;set;}
    Public Integer TotalModuleY3CostI {get;set;}
    Public Integer TotalModuleY4CostI {get;set;}
    Public Integer TotalPRY1CostA {get;set;}
    Public Integer TotalPRY2CostA {get;set;}
    Public Integer TotalPRY3CostA {get;set;}
    Public Integer TotalPRY4CostA {get;set;}
    Public Integer AllYearPRTotalCostA  {get;set;}
    Public Integer AllYearPRTotalCostI  {get;set;}
    Public Integer TotalPRY1CostI {get;set;}
    Public Integer TotalPRY2CostI {get;set;}
    Public Integer TotalPRY3CostI {get;set;}
    Public Integer TotalPRY4CostI {get;set;}
   
    Public List<WrapperFundingSource> lstWrapperFundingSourceNSF {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceB {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceC {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceD {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceJ {get;set;}
    Public List<WrapperFundingSource> lstWrapperFundingSourceI {get;set;}
    
    /**********************************************************************************************
    Purpose: Initialize the constructor method  
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    public CN_IntegratedView_pdf_MM(ApexPages.StandardController controller) {
        if(Apexpages.currentpage().getparameters().get('id')!=null){
            String strCNID = Apexpages.currentpage().getparameters().get('id');  
            objCN = [select id,name,Number_of_Years__c,Language__c,Translation_Status__c from Concept_Note__c where id=:strCNID ];
            lstCPFR = [Select Id,Name From CPF_Report__c Where Concept_Note__c =: strCNID];
            ConceptNoteId = strCNID ;
            fillGoals();
            fillObjectives();
            
            //---Prog. Gap
            lstModuleNew  = [select id,name,Parent_module__c,Russian_Name__c,Spanish_Name__c,French_Name__c,Catalog_Module__c,
                                Language__c,Total_Above_Indicative_Amount__c,Total_Indicative_Amount__c from Module__c where Concept_Note__c=:strCNID Order By Modular_Order__c NULLS LAST];
            System.debug('lstModuleNew' + lstModuleNew);
            if(lstModuleNew.size() > 0){
                strCatalogModule = lstModuleNew[0].Catalog_Module__c;
            }
            fillModules();
            
            fillCPFReports();
            
            List<AggregateResult> lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.Name Modulename,
                            Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                            Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                            Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                            WHERE Implementation_Period__r.Concept_Note__c =: strCNID 
                            Group By CN_Intervention__r.Module_rel__r.Name ];
                           
            List<AggregateResult> lstGrantIntervantionPR = [Select Implementation_Period__r.Principal_Recipient__r.Name Modulename,
                                Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                                Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                                Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                                WHERE Implementation_Period__r.Concept_Note__c =: strCNID 
                                Group By Implementation_Period__r.Principal_Recipient__r.Name ];
                                
           
            if(System.UserInfo.getLanguage() == 'fr'){ 
                                lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.French_Name__c Modulename,
                                Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                                Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                                Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                                WHERE Implementation_Period__r.Concept_Note__c =: strCNID 
                                Group By CN_Intervention__r.Module_rel__r.French_Name__c];             
            }
            
            
            if(System.UserInfo.getLanguage() == 'ru'){
                                lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.Russian_Name__c Modulename,
                                Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                                Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                                Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                                WHERE Implementation_Period__r.Concept_Note__c =: strCNID 
                                Group By CN_Intervention__r.Module_rel__r.Russian_Name__c];                   
            }
                 
            if(System.UserInfo.getLanguage() == 'es'){
                                lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.Spanish_Name__c Modulename,
                                Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                                Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                                Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                                WHERE Implementation_Period__r.Concept_Note__c =: strCNID 
                                Group By CN_Intervention__r.Module_rel__r.Spanish_Name__c ];
            }
                   
            lstBLModule = new List<BLModule>();
            for(AggregateResult objAgg : lstGrantIntervantionModule){
                BLModule objwrap = new BLModule();
                objwrap.ModuleName = String.valueof(objAgg.get('Modulename'));
                if(objAgg.get('IndY1') != null) objwrap.IndY1 = Integer.valueof(objAgg.get('IndY1'));
                else objwrap.IndY1 = 0;
                if(objAgg.get('IndY2') != null) objwrap.IndY2 = Integer.valueof(objAgg.get('IndY2'));
                else objwrap.IndY2 = 0;
                if(objAgg.get('IndY3') != null) objwrap.IndY3 = Integer.valueof(objAgg.get('IndY3'));
                else objwrap.IndY3 = 0;
                if(objAgg.get('IndY4') != null) objwrap.IndY4 = Integer.valueof(objAgg.get('IndY4'));
                else objwrap.IndY4 = 0;
                objwrap.TotalModuleCostI = objwrap.IndY1 + objwrap.IndY2 + objwrap.IndY3 + objwrap.IndY4 ;
                if(objAgg.get('AboveY1') != null) objwrap.AboveY1 = Integer.valueof(objAgg.get('AboveY1'));
                else objwrap.AboveY1 = 0;
                if(objAgg.get('AboveY2') != null) objwrap.AboveY2 = Integer.valueof(objAgg.get('AboveY2'));
                else objwrap.AboveY2 = 0;
                if(objAgg.get('AboveY3') != null) objwrap.AboveY3 = Integer.valueof(objAgg.get('AboveY3'));
                else objwrap.AboveY3 = 0;
                if(objAgg.get('AboveY4') != null) objwrap.AboveY4 = Integer.valueof(objAgg.get('AboveY4'));
                else objwrap.AboveY4 = 0;
                objwrap.TotalModuleCostA = objwrap.AboveY1 + objwrap.AboveY2 + objwrap.AboveY3 + objwrap.AboveY4 ;
                lstBLModule.add(objwrap);
                
                
                if(TotalModuleY1CostI == null) TotalModuleY1CostI = objwrap.IndY1;
                else TotalModuleY1CostI += objwrap.IndY1;
                if(TotalModuleY2CostI == null) TotalModuleY2CostI = objwrap.IndY2;
                else TotalModuleY2CostI += objwrap.IndY2;
                if(TotalModuleY3CostI == null) TotalModuleY3CostI = objwrap.IndY3;
                else TotalModuleY3CostI += objwrap.IndY3;
                if(TotalModuleY4CostI == null) TotalModuleY4CostI = objwrap.IndY4;
                else TotalModuleY4CostI += objwrap.IndY4;
                
                if(AllYearModuleTotalCostA == null) AllYearModuleTotalCostA = objwrap.TotalModuleCostA;
                else AllYearModuleTotalCostA += objwrap.TotalModuleCostA;
                
                if(TotalModuleY1CostA == null) TotalModuleY1CostA = objwrap.AboveY1;
                else TotalModuleY1CostA += objwrap.AboveY1;
                if(TotalModuleY2CostA == null) TotalModuleY2CostA = objwrap.AboveY2;
                else TotalModuleY2CostA += objwrap.AboveY2;
                if(TotalModuleY3CostA == null) TotalModuleY3CostA = objwrap.AboveY3;
                else TotalModuleY3CostA += objwrap.AboveY3;
                if(TotalModuleY4CostA == null) TotalModuleY4CostA = objwrap.AboveY4;
                else TotalModuleY4CostA += objwrap.AboveY4;
                
                if(AllYearModuleTotalCostI == null) AllYearModuleTotalCostI = objwrap.TotalModuleCostI;
                else AllYearModuleTotalCostI += objwrap.TotalModuleCostI;
            }
            
            
            lstBLModulePR = new List<BLModulePR>();
            for(AggregateResult objAgg : lstGrantIntervantionPR){
                BLModulePR objwrap = new BLModulePR();
                objwrap.ModuleName = String.valueof(objAgg.get('Modulename'));
                if(objAgg.get('IndY1') != null) objwrap.IndY1 = Integer.valueof(objAgg.get('IndY1'));
                else objwrap.IndY1 = 0;
                if(objAgg.get('IndY2') != null) objwrap.IndY2 = Integer.valueof(objAgg.get('IndY2'));
                else objwrap.IndY2 = 0;
                if(objAgg.get('IndY3') != null) objwrap.IndY3 = Integer.valueof(objAgg.get('IndY3'));
                else objwrap.IndY3 = 0;
                if(objAgg.get('IndY4') != null) objwrap.IndY4 = Integer.valueof(objAgg.get('IndY4'));
                else objwrap.IndY4 = 0;
                objwrap.TotalModuleCostI = objwrap.IndY1 + objwrap.IndY2 + objwrap.IndY3 + objwrap.IndY4 ;
                
                if(objAgg.get('AboveY1') != null) objwrap.AboveY1 = Integer.valueof(objAgg.get('AboveY1'));
                else objwrap.AboveY1 = 0;
                if(objAgg.get('AboveY2') != null) objwrap.AboveY2 = Integer.valueof(objAgg.get('AboveY2'));
                else objwrap.AboveY2 = 0;
                if(objAgg.get('AboveY3') != null) objwrap.AboveY3 = Integer.valueof(objAgg.get('AboveY3'));
                else objwrap.AboveY3 = 0;
                if(objAgg.get('AboveY4') != null) objwrap.AboveY4 = Integer.valueof(objAgg.get('AboveY4'));
                else objwrap.AboveY4 = 0;
                objwrap.TotalModuleCostA = objwrap.AboveY1 + objwrap.AboveY2 + objwrap.AboveY3 + objwrap.AboveY4 ;
                lstBLModulePR.add(objwrap);
                
                
                if(TotalPRY1CostA == null) TotalPRY1CostA = objwrap.IndY1;
                else TotalPRY1CostA += objwrap.IndY1;
                if(TotalPRY2CostA == null) TotalPRY2CostA = objwrap.IndY2;
                else TotalPRY2CostA += objwrap.IndY2;
                if(TotalPRY3CostA == null) TotalPRY3CostA = objwrap.IndY3;
                else TotalPRY3CostA += objwrap.IndY3;
                if(TotalPRY4CostA == null) TotalPRY4CostA = objwrap.IndY4;
                else TotalPRY4CostA += objwrap.IndY4;
                
                if(AllYearPRTotalCostA == null) AllYearPRTotalCostA = objwrap.TotalModuleCostA;
                else AllYearPRTotalCostA += objwrap.TotalModuleCostA;
                
                if(TotalPRY1CostI == null) TotalPRY1CostI = objwrap.AboveY1;
                else TotalPRY1CostI += objwrap.AboveY1;
                if(TotalPRY2CostI == null) TotalPRY2CostI = objwrap.AboveY2;
                else TotalPRY2CostI += objwrap.AboveY2;
                if(TotalPRY3CostI == null) TotalPRY3CostI = objwrap.AboveY3;
                else TotalPRY3CostI += objwrap.AboveY3;
                if(TotalPRY4CostI == null) TotalPRY4CostI = objwrap.AboveY4;
                else TotalPRY4CostI += objwrap.AboveY4;
                
                if(AllYearPRTotalCostI == null) AllYearPRTotalCostI = objwrap.TotalModuleCostI;
                else AllYearPRTotalCostI += objwrap.TotalModuleCostI;
            }
            
            
            if(objCN.Translation_Status__c == 'Translation complete') strLanguage = 'ENGLISH';
                else strLanguage = objCN.Language__c;
            datename  = Datetime.now().format('MM/dd/yyyy');
            objname = objCN.name +'_'+ datename + '.pdf' ;
            objname = objname.replace(' ', '_');
            system.debug('@@@'+objname );
            Pathpdf = 'attachment; filename='+ objname ; 
            Apexpages.currentPage().getHeaders().put('content-disposition', Pathpdf );
       
        }
    }
    private List<wrapperClsModulePG> fillModulesNew(string strCatalogM,String strModuleIdNew){
           system.debug('strCatalogM' + strCatalogM ); 
           system.debug('strModuleIdNew' + strModuleIdNew); 
           lstWrapCls = new List<wrapperClsModulePG>();
                                    
           List<Indicator__c> lstCatalogIndicator = [Select Id,Name,Available_for_PG__c,Programme_Area__c,Full_Name_En__c,
                                        French_Name__c, Spanish_Name__c, Russian_Name__c,LLIN__c,Indicator_for_PG_Calculation_E__c,
                                        (SELECT Id, Name,Group_Sequence__c, Coverage_Text__c ,Metric__c ,Current_Coverage__c,
                                        Current_Coverage_per__c,Baseline_Source__c,Baseline_Year__c,Baseline_value__c,
                                        Rationale_for_Chosen_Indicator__c,LFA_Comments__c,Coverage_Comments__c,CCM_Comments_Spanish__c,
                                        Module__c,Global_Fund_Comments__c,Year_1__c ,Year_2__c ,CCM_Comments__c,CCM_Comments_French__c,
                                        Year_3__c,Year_4__c, Specification__c,Assumptions__c,Program_Area__c,CCM_Comments_Russian__c,
                                        Type__c,Type_Formula__c,Year_1_per__c,Year_2_per__c,Year_3_per__c,Year_4_per__c, Specify_Text__c 
                                        FROM Programmatic_Gaps__r WHERE Concept_Note__c = :ConceptNoteId
                                        /*And Module__c =: strModuleIdNew And Type_Formula__c !=: 'D'*/
                                        order by Group_Sequence__c,Sequence__c asc) 
                                        FROM Indicator__c Where Catalog_Module__c =: strCatalogM
                                        And Indicator_Type__c =: 'Coverage/Output'
                                        And Available_for_PG__c = true];
            
            System.debug('lstCatalogIndicator ' + lstCatalogIndicator );
            System.Debug('ConceptNoteId' + ConceptNoteId);    
            /*for(Programmatic_Gap__c pg : [Select Catalog_Indicator__c from Programmatic_Gap__c where Concept_Note__c = :ConceptNoteId]){
             setCatIndIds.add(pg.Catalog_Indicator__c);
            }*/                        
             
            if(lstCatalogIndicator.size() > 0){
                Integer Index = 0;
                for(Indicator__c objCInd: lstCatalogIndicator){ 
                    if(objCInd.Programmatic_Gaps__r.size() > 0){
                        wrapperClsModulePG objWrpCls = new wrapperClsModulePG();
                        objWrpCls.objCI = new Indicator__c();
                        objWrpCls.objCI = objCInd;
                        
                        if(objWrpCls.objCI.LLIN__c)
                        objWrpCls.showLLIN = true;
                        
                        showNewE = objWrpCls.objCI.Indicator_for_PG_Calculation_E__c;
                        objWrpCls.showNewE1= showNewE; 
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
                           
                            if(objCInd.LLIN__c == false)
                            {
                               //--TCS - 09/05/2014- Initialized fields to zero for Programmatic Gap of type D
                                if(obj.Type_Formula__c == 'D' ) obj.year_1__c = setToZero;
                                if(obj.Type_Formula__c == 'D' ) obj.year_2__c = setToZero;
                                if(obj.Type_Formula__c == 'D' ) obj.year_3__c = setToZero;
                                if(obj.Type_Formula__c == 'D' ) obj.year_4__c = setToZero;
                                
                                if(obj.Type_Formula__c == 'D' ) obj.Year_1_per__c = setToZero;
                                if(obj.Type_Formula__c == 'D' ) obj.Year_2_per__c = setToZero;
                                if(obj.Type_Formula__c == 'D' ) obj.Year_3_per__c = setToZero;
                                if(obj.Type_Formula__c == 'D' ) obj.Year_4_per__c = setToZero;
                                                            
                                if(obj.Type_Formula__c == 'A' && obj.year_1__c != null) numberA = obj.year_1__c;
                                if(obj.Type_Formula__c == 'B' && obj.year_1__c != null) numberB = obj.year_1__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.year_1__c != null) numberC = obj.year_1__c;
                                if(obj.Type_Formula__c == 'D' && obj.year_1__c != null) numberD = obj.year_1__c;
                                if(obj.Type_Formula__c == 'F' && obj.year_1__c != null) numberF = obj.year_1__c;
                                if(obj.Type_Formula__c == 'H' && obj.year_1__c != null) numberH = obj.year_1__c;
                                
                                if(obj.Type_Formula__c == 'A' && obj.Year_1_per__c!= null) PercentA = obj.Year_1_per__c;
                                if(obj.Type_Formula__c == 'B' && obj.Year_1_per__c!= null) PercentB = obj.Year_1_per__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.Year_1_per__c!= null) PercentC = obj.Year_1_per__c;
                                if(obj.Type_Formula__c == 'D' && obj.Year_1_per__c!= null) PercentD = obj.Year_1_per__c;
                                if(obj.Type_Formula__c == 'F' && obj.Year_1_per__c!= null) PercentF = obj.Year_1_per__c;
                                if(obj.Type_Formula__c == 'H' && obj.Year_1_per__c!= null) PercentH = obj.Year_1_per__c;
                                
                                if(obj.Type_Formula__c == 'A' && obj.year_2__c != null) numberAY2 = obj.year_2__c;
                                if(obj.Type_Formula__c == 'B' && obj.year_2__c != null) numberBY2 = obj.year_2__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.year_2__c != null) numberCY2 = obj.year_2__c;
                                if(obj.Type_Formula__c == 'D' && obj.year_2__c != null) numberDY2 = obj.year_2__c;
                                if(obj.Type_Formula__c == 'F' && obj.year_2__c != null) numberFY2 = obj.year_2__c;
                                if(obj.Type_Formula__c == 'H' && obj.year_2__c != null) numberHY2 = obj.year_2__c;
                                
                                if(obj.Type_Formula__c == 'A' && obj.Year_2_per__c!= null) PercentAY2 = obj.Year_2_per__c;
                                if(obj.Type_Formula__c == 'B' && obj.Year_2_per__c!= null) PercentBY2 = obj.Year_2_per__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.Year_2_per__c!= null) PercentCY2 = obj.Year_2_per__c;
                                if(obj.Type_Formula__c == 'D' && obj.Year_2_per__c!= null) PercentDY2 = obj.Year_2_per__c;
                                if(obj.Type_Formula__c == 'F' && obj.Year_2_per__c!= null) PercentFY2 = obj.Year_2_per__c;
                                if(obj.Type_Formula__c == 'H' && obj.Year_2_per__c!= null) PercentHY2 = obj.Year_2_per__c;
                                
                                if(obj.Type_Formula__c == 'A' && obj.year_3__c != null) numberAY3 = obj.year_3__c;
                                if(obj.Type_Formula__c == 'B' && obj.year_3__c != null) numberBY3 = obj.year_3__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.year_3__c != null) numberCY3 = obj.year_3__c;
                                if(obj.Type_Formula__c == 'D' && obj.year_3__c != null) numberDY3 = obj.year_3__c;
                                if(obj.Type_Formula__c == 'F' && obj.year_3__c != null) numberFY3 = obj.year_3__c;
                                if(obj.Type_Formula__c == 'H' && obj.year_3__c != null) numberHY3 = obj.year_3__c;
                                
                                if(obj.Type_Formula__c == 'A' && obj.Year_3_per__c!= null) PercentAY3 = obj.Year_3_per__c;
                                if(obj.Type_Formula__c == 'B' && obj.Year_3_per__c!= null) PercentBY3 = obj.Year_3_per__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.Year_3_per__c!= null) PercentCY3 = obj.Year_3_per__c;
                                if(obj.Type_Formula__c == 'D' && obj.Year_3_per__c!= null) PercentDY3 = obj.Year_3_per__c;
                                if(obj.Type_Formula__c == 'F' && obj.Year_3_per__c!= null) PercentFY3 = obj.Year_3_per__c;
                                if(obj.Type_Formula__c == 'H' && obj.Year_3_per__c!= null) PercentHY3 = obj.Year_3_per__c;
                                
                                if(obj.Type_Formula__c == 'A' && obj.year_4__c != null) numberAY4 = obj.year_4__c;
                                if(obj.Type_Formula__c == 'B' && obj.year_4__c != null) numberBY4 = obj.year_4__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.year_4__c != null) numberCY4 = obj.year_4__c;
                                if(obj.Type_Formula__c == 'D' && obj.year_4__c != null) numberDY4 = obj.year_4__c;
                                if(obj.Type_Formula__c == 'F' && obj.year_4__c != null) numberFY4 = obj.year_4__c;
                                if(obj.Type_Formula__c == 'H' && obj.year_4__c != null) numberHY4 = obj.year_4__c;
                                
                                if(obj.Type_Formula__c == 'A' && obj.Year_4_per__c!= null) PercentAY4 = obj.Year_4_per__c;
                                if(obj.Type_Formula__c == 'B' && obj.Year_4_per__c!= null) PercentBY4 = obj.Year_4_per__c;// TCS changes for Requirement# 107
                                if(obj.Type_Formula__c == 'C' && obj.Year_4_per__c!= null) PercentCY4 = obj.Year_4_per__c;
                                if(obj.Type_Formula__c == 'D' && obj.Year_4_per__c!= null) PercentDY4 = obj.Year_4_per__c;
                                if(obj.Type_Formula__c == 'F' && obj.Year_4_per__c!= null) PercentFY4 = obj.Year_4_per__c;
                                if(obj.Type_Formula__c == 'H' && obj.Year_4_per__c!= null) PercentHY4 = obj.Year_4_per__c;
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
                            if(objCInd.Indicator_for_PG_Calculation_E__c)
                            {
                                objWrpCls.Year1NumberE = numberB - numberC;
                                objWrpCls.Year2NumberE = numberBY2 - numberCY2;
                                objWrpCls.Year3NumberE = numberBY3 - numberCY3;
                                objWrpCls.Year4NumberE = numberBY4 - numberCY4;
                                if(numberB != 0)
                                    objWrpCls.Year1PercentE = integer.valueOf(((numberB - numberC)/numberB)*100);
                                else
                                    objWrpCls.Year1PercentE = 0;
                                if(numberBY2 != 0)
                                    objWrpCls.Year2PercentE = integer.valueOf(((numberBY2 - numberCY2)/numberBY2)*100);
                                else
                                    objWrpCls.Year2PercentE = 0;
                                if(numberBY3 != 0)
                                    objWrpCls.Year3PercentE = integer.valueOf(((numberBY3 - numberCY3)/numberBY3)*100);
                                else
                                    objWrpCls.Year3PercentE = 0;
                                if(numberBY4 != 0)
                                    objWrpCls.Year4PercentE = integer.valueOf(((numberBY4 - numberCY4)/numberBY4)*100);
                                else
                                    objWrpCls.Year4PercentE = 0;                                              
                            }
                            else
                            {
                                objWrpCls.Year1NumberE = numberA - (numberC + numberD);
                                objWrpCls.Year1PercentE = 100 - (PercentC + PercentD);
                                objWrpCls.Year2NumberE = numberAY2 - (numberCY2 + numberDY2);
                                objWrpCls.Year2PercentE = 100 - (PercentCY2 + PercentDY2);
                                objWrpCls.Year3NumberE = numberAY3 - (numberCY3 + numberDY3);
                                objWrpCls.Year3PercentE = 100 - (PercentCY3 + PercentDY3);
                                objWrpCls.Year4NumberE = numberAY4 - (numberCY4 + numberDY4);
                                objWrpCls.Year4PercentE = 100 - (PercentCY4 + PercentDY4);         
                            }
                            
                            objWrpCls.Year1NumberG = NumberF + (numberC + numberD);
                            objWrpCls.Year1PercentG = PercentF + (PercentC + PercentD);
                            objWrpCls.Year1NumberI = NumberF + (numberC + numberD) + numberH;
                            objWrpCls.Year1PercentI = PercentF + (PercentC + PercentD) + PercentH;
                               
                            objWrpCls.Year2NumberG = NumberFY2 + (numberCY2 + numberDY2);
                            objWrpCls.Year2PercentG = PercentFY2 + (PercentCY2 + PercentDY2);
                            objWrpCls.Year2NumberI = NumberFY2 + (numberCY2 + numberDY2) + numberHY2;
                            objWrpCls.Year2PercentI = PercentFY2 + (PercentCY2 + PercentDY2) + PercentHY2;
                            
                            objWrpCls.Year3NumberG = NumberFY3 + (numberCY3 + numberDY3);
                            objWrpCls.Year3PercentG = PercentFY3 + (PercentCY3 + PercentDY3);
                            objWrpCls.Year3NumberI = NumberFY3 + (numberCY3 + numberDY3) + numberHY3;
                            objWrpCls.Year3PercentI = PercentFY3 + (PercentCY3 + PercentDY3) + PercentHY3;
                                
                            objWrpCls.Year4NumberG = NumberFY4 + (numberCY4 + numberDY4);
                            objWrpCls.Year4PercentG = PercentFY4 + (PercentCY4 + PercentDY4);
                            objWrpCls.Year4NumberI = NumberFY4 + (numberCY4 + numberDY4) + numberHY4;
                            objWrpCls.Year4PercentI = PercentFY4 + (PercentCY4 + PercentDY4) + PercentHY4;
                        } else {
                            objWrpCls.Year1NumberF = numberC + numberD + numberE;                        
                            objWrpCls.Year1NumberG = objWrpCls.Year1NumberF + numberB;
                            objWrpCls.Year1NumberI = objWrpCls.Year1NumberG - numberH;
                            objWrpCls.Year1NumberK = numberJ + numberH;
                            objWrpCls.Year1NumberM = objWrpCls.Year1NumberK + numberL;
                            if(objWrpCls.Year1NumberG == 0) {
                                objWrpCls.Year1PercentH = 0;
                                objWrpCls.Year1PercentJ = 0;
                                objWrpCls.Year1PercentK = 0;
                                objWrpCls.Year1PercentL = 0;
                                objWrpCls.Year1PercentM = 0;
                                objWrpCls.Year1PercentI = 0;
                            }
                            else {
                                    if(numberH != 0)objWrpCls.Year1PercentH = Math.round((numberH / objWrpCls.Year1NumberG) * 100);
                                    if(objWrpCls.Year1NumberI != 0)  objWrpCls.Year1PercentI = Math.round((objWrpCls.Year1NumberI / objWrpCls.Year1NumberG) * 100);
                                    if(numberJ != 0)objWrpCls.Year1PercentJ = Math.round((numberJ / objWrpCls.Year1NumberG) * 100);
                                    if(objWrpCls.Year1NumberK != 0) objWrpCls.Year1PercentK = Math.round((objWrpCls.Year1NumberK / objWrpCls.Year1NumberG) * 100);
                                    if(numberL != 0)objWrpCls.Year1PercentL = Math.round((NumberL / objWrpCls.Year1NumberG) * 100);
                                    if(objWrpCls.Year1NumberM != 0)objWrpCls.Year1PercentM = Math.round((objWrpCls.Year1NumberM / objWrpCls.Year1NumberG) * 100);
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
                                    if(numberHY2 != 0)objWrpCls.Year2PercentH = Math.round((numberHY2 / objWrpCls.Year2NumberG) * 100);
                                    if(objWrpCls.Year2NumberI != 0)  objWrpCls.Year2PercentI = Math.round((objWrpCls.Year2NumberI / objWrpCls.Year2NumberG) * 100);
                                    if(numberJY2 != 0)objWrpCls.Year2PercentJ = Math.round((numberJY2 / objWrpCls.Year2NumberG) * 100);
                                    if(objWrpCls.Year2NumberK != 0) objWrpCls.Year2PercentK = Math.round((objWrpCls.Year2NumberK / objWrpCls.Year2NumberG) * 100);
                                    if(numberL != 0)objWrpCls.Year2PercentL = Math.round((NumberLY2 / objWrpCls.Year2NumberG) * 100);
                                    if(objWrpCls.Year2NumberM != 0)objWrpCls.Year2PercentM = Math.round((objWrpCls.Year2NumberM / objWrpCls.Year2NumberG) * 100);
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
                                    if(numberHY3 != 0)objWrpCls.Year3PercentH = Math.round((numberHY3 / objWrpCls.Year3NumberG) * 100);
                                    if(objWrpCls.Year3NumberI != 0)  objWrpCls.Year3PercentI = Math.round((objWrpCls.Year3NumberI / objWrpCls.Year3NumberG) * 100);
                                    if(numberJY3 != 0)objWrpCls.Year3PercentJ = Math.round((numberJY3 / objWrpCls.Year3NumberG) * 100);
                                    if(objWrpCls.Year3NumberK != 0) objWrpCls.Year3PercentK = Math.round((objWrpCls.Year3NumberK / objWrpCls.Year3NumberG) * 100);
                                    if(numberLY3 != 0)objWrpCls.Year3PercentL = Math.round((NumberLY3 / objWrpCls.Year3NumberG) * 100);
                                    if(objWrpCls.Year3NumberM != 0)objWrpCls.Year3PercentM = Math.round((objWrpCls.Year3NumberM / objWrpCls.Year3NumberG) * 100);
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
                                    if(numberHY4 != 0)objWrpCls.Year4PercentH = Math.round((numberHY4 / objWrpCls.Year4NumberG) * 100);
                                    if(objWrpCls.Year4NumberI != 0)  objWrpCls.Year4PercentI = Math.round((objWrpCls.Year4NumberI / objWrpCls.Year4NumberG) * 100);
                                    if(numberJY4 != 0)objWrpCls.Year4PercentJ = Math.round((numberJY4 / objWrpCls.Year4NumberG) * 100);
                                    if(objWrpCls.Year4NumberK != 0) objWrpCls.Year4PercentK = Math.round((objWrpCls.Year4NumberK / objWrpCls.Year4NumberG) * 100);
                                    if(numberLY4 != 0)objWrpCls.Year4PercentL = Math.round((NumberLY4 / objWrpCls.Year4NumberG) * 100);
                                    if(objWrpCls.Year4NumberM != 0)objWrpCls.Year4PercentM = Math.round((objWrpCls.Year4NumberM / objWrpCls.Year4NumberG) * 100);
                            }   
                        }
                        
                        //objWrpCls.lstPG = new List<Programmatic_Gap__c>();
                        //objWrpCls.lstPGHistory.AddAll(objCInd.ProgrammaticGapHistory);
                        objWrpCls.Name = objWrpCls.lstProgrammaticGap[0].objPGap.Program_Area__c;
                        objWrpCls.CoverageComments = objWrpCls.lstProgrammaticGap[0].objPGap.Coverage_Comments__c;
                        objWrpCls.KeyMetric = objWrpCls.lstProgrammaticGap[0].objPGap.Metric__c;
                        objWrpCls.GroupSequence = index;
                        objWrpCls.IndicatorName = objCInd.Full_Name_En__c;
                          if(strUserLanguage == 'FRENCH') objWrpCls.IndicatorName = objCInd.French_Name__c;
                          if(strUserLanguage == 'RUSSIAN') objWrpCls.IndicatorName = objCInd.Russian_Name__c;
                          if(strUserLanguage == 'SPANISH') objWrpCls.IndicatorName = objCInd.Spanish_Name__c;
                        objWrpCls.blndisplaySave = true;
                        objWrpCls.isShow = true;
                        lstWrapCls.Add(objWrpCls);
                        Index ++;
                        
                        System.Debug('lstWrapCls' + lstWrapCls);  
                }
            }
        }
        return lstWrapCls;
    }
    Private void fillGoals(){
        lstGoals = [Select Id,Goal__c,Goal_French__c,Goal_Spanish__c,Goal_Russian__c,Number__c From Goals_Objectives__c Where Concept_Note__c =: objCN.id And Type__c = 'Goal' Order by Number__c];  
        lstGoaljunction = [Select Goal_Objective__c,Goal_Objective__r.Goal__c,Goal_Objective__r.Number__c, Indicator__c,
            Indicator__r.Indicator_Full_Name__c,Indicator__r.French_Name__c,Indicator__r.Spanish_Name__c,Indicator__r.Russian_Name__c,Indicator__r.Baseline_Value__c,Indicator__r.Baseline_Sources__c,
            Indicator__r.Baseline_Year__c,Indicator__r.Target_Value_Y1__c,Indicator__r.Target_Value_Y2__c,
            Indicator__r.Target_Value_Y3__c,Indicator__r.Target_Value_Y4__c,Indicator__r.Comments__c,Indicator__r.Comments_French__c,Indicator__r.Comments_Spanish__c,Indicator__r.Comments_Russian__c,Indicator__r.Country__r.Name
            From Ind_Goal_Jxn__c
            Where Goal_Objective__r.Concept_Note__c =: objCN.id
            And Goal_Objective__r.Type__c = 'Goal'
            And Indicator__r.Concept_Note__c =: objCN.id
            Order by Goal_Objective__r.Number__c];
        Set<Id> setIndIds = new Set<Id>();
        for(Ind_Goal_Jxn__c goalJxn : lstGoalJunction){
            setIndIds.add(goalJxn.Indicator__c);
        }
        lstImpactIndicators = [Select Indicator_Full_Name__c,French_Name__c,Spanish_Name__c,Russian_Name__c,Baseline_Value__c,Baseline_Sources__c,
            Baseline_Year__c,Target_Value_Y1__c,Target_Value_Y2__c, Target_Value_Y3__c,Target_Value_Y4__c,Decimal_Places__c,
            Comments__c,Comments_French__c,Comments_Spanish__c,Comments_Russian__c,Country__r.Name,
            (Select Id, Goal_Objective__r.Number__c from Indicator_Goal_Junctions__r ORDER BY Goal_Objective__r.Number__c)
            from Grant_Indicator__c where Id in : setIndIds];

    }
    Private void fillObjectives(){
        lstObjectives = [Select Id,Goal__c,Goal_French__c,Goal_Spanish__c,Goal_Russian__c,Number__c From Goals_Objectives__c Where Concept_Note__c =: objCN.id And Type__c = 'Objective' Order by Number__c];  
        lstObjectivejunction = [Select Goal_Objective__c,Goal_Objective__r.Goal__c,Goal_Objective__r.Number__c,Indicator__c,
            Indicator__r.Indicator_Full_Name__c,Indicator__r.French_Name__c,Indicator__r.Spanish_Name__c,Indicator__r.Russian_Name__c,Indicator__r.Baseline_Value__c,Indicator__r.Baseline_Sources__c,
            Indicator__r.Baseline_Year__c,Indicator__r.Target_Value_Y1__c,Indicator__r.Target_Value_Y2__c,
            Indicator__r.Target_Value_Y3__c,Indicator__r.Target_Value_Y4__c,Indicator__r.Comments__c,Indicator__r.Comments_French__c,Indicator__r.Comments_Spanish__c,Indicator__r.Comments_Russian__c,Indicator__r.Country__r.Name
            From Ind_Goal_Jxn__c
            Where Goal_Objective__r.Concept_Note__c =: objCN.id
            And Goal_Objective__r.Type__c = 'Objective'
            And Indicator__r.Concept_Note__c =: objCN.id
            Order by Goal_Objective__r.Number__c];
            
        Set<Id> setIndIds = new Set<Id>();
        for(Ind_Goal_Jxn__c objJxn : lstObjectiveJunction){
            setIndIds.add(objJxn.Indicator__c);
        }
        lstOutcomeIndicators = [Select Indicator_Full_Name__c,French_Name__c,Spanish_Name__c,Russian_Name__c,Baseline_Value__c,Baseline_Sources__c,
            Baseline_Year__c,Target_Value_Y1__c,Target_Value_Y2__c, Target_Value_Y3__c,Target_Value_Y4__c,
            Comments__c,Comments_French__c,Comments_Spanish__c,Comments_Russian__c,Country__r.Name,Decimal_Places__c,
            (Select Id, Goal_Objective__r.Number__c from Indicator_Goal_Junctions__r ORDER BY Goal_Objective__r.Number__c)
            from Grant_Indicator__c where Id in : setIndIds];
    }
    
    Private void fillModules(){
        lstCNModule = new List<CNModule>();
        CNModule objCNModule;
        intTotalIndicativemain =0;
        intTotalAbovemain =0;
        For(Module__c objModule: [select Id,Name,French_Name__c,Spanish_Name__c,Catalog_Module__c,Russian_Name__c,Modular_Order__c from Module__c where Concept_Note__c=:objCN.id Order By Modular_Order__c NULLS LAST]){
            objCNModule = new CNModule();
            objCNModule.objModule = objModule;
            objCNModule.lstGI=GetGrantIndicatorForModule(objModule.Id);
            objCNModule.lstCI=GetCNInterventionForModule(objModule.Id);
            
            //Prog. Gap
            objCNModule.lstPG = fillModulesNew(objModule.Catalog_Module__c,objModule.Id);
            system.debug('objCNModule.lstPG' + objCNModule.lstPG);
            //******************************************
            Decimal intTotalIndicativeY1 = 0;
            Decimal intTotalIndicativeY2 = 0;
            Decimal intTotalIndicativeY3 = 0;
            Decimal intTotalIndicativeY4 = 0;
            
            Decimal intTotalAboveY1 = 0;
            Decimal intTotalAboveY2 = 0;
            Decimal intTotalAboveY3 = 0;
            Decimal intTotalAboveY4 = 0;
            
            Decimal intTotalIndicative = 0;
            Decimal intTotalAbove = 0;
            //for(objCNModule.lstCI){
            //for(CNModule objModultCI: objCNModule.lstCI){
            
            for(CNIntervention objCNInt : objCNModule.lstCI){
                for(Grant_Intervention__c objGI : objCNInt.lstGrantIntervention ){
                   
                    intTotalIndicativeY1 += ConvertToValue(objGI.Indicative_Y1__c);
                    intTotalIndicativeY2 += ConvertToValue(objGI.Indicative_Y2__c);
                    intTotalIndicativeY3 += ConvertToValue(objGI.Indicative_Y3__c);
                    intTotalIndicativeY4 += ConvertToValue(objGI.Indicative_Y4__c);
                    
                    intTotalAboveY1 += ConvertToValue(objGI.Above_Indicative_Y1__c);
                    intTotalAboveY2 += ConvertToValue(objGI.Above_Indicative_Y2__c);
                    intTotalAboveY3 += ConvertToValue(objGI.Above_Indicative_Y3__c);
                    intTotalAboveY4 += ConvertToValue(objGI.Above_Indicative_Y4__c);
                    }   
            }
              
            objCNModule.TIndicative=0;
            objCNModule.TAbove=0;

            if(objCN.Number_of_Years__c== '4'){
                //system.debug(objCNModule.TAbove+'$$'+objCNModule.TIndicative);
                objCNModule.TIndicative += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3 + intTotalIndicativeY4;
                objCNModule.TAbove += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3 + intTotalAboveY4;
                //system.debug(objCNModule.TAbove+'$$'+objCNModule.TIndicative);
            }else{
                objCNModule.TIndicative += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3;
                objCNModule.TAbove += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3;
            }
            intTotalIndicativemain += objCNModule.TIndicative;
            intTotalAbovemain += objCNModule.TAbove ;
            //******************************************
            
            lstCNModule.add(objCNModule); 
            //////**********Total For Intervation**********//////
            CNIntervention objCNIntervention;
            intTotalIndicativeY1 = 0;
            intTotalIndicativeY2 = 0;
            intTotalIndicativeY3 = 0;
            intTotalIndicativeY4 = 0;
            
            intTotalAboveY1 = 0;
            intTotalAboveY2 = 0;
            intTotalAboveY3 = 0;
            intTotalAboveY4 = 0;
            
            intTotalIndicative = 0;
            intTotalAbove = 0;
            for(Grant_Indicator__c objGI : objCNModule.lstGI){
                    intTotalIndicativeY1 += ConvertToValue(objGI.Indicative_Percent1__c);
                    intTotalIndicativeY2 += ConvertToValue(objGI.Indicative_Percent2__c);
                    intTotalIndicativeY3 += ConvertToValue(objGI.Indicative_Percent3__c);
                    intTotalIndicativeY4 += ConvertToValue(objGI.Indicative_Percent4__c);
                    
                    intTotalAboveY1 += ConvertToValue(objGI.Above_Indicative_Percent1__c);
                    intTotalAboveY2 += ConvertToValue(objGI.Above_Indicative_Percent2__c);
                    intTotalAboveY3 += ConvertToValue(objGI.Above_Indicative_Percent3__c);
                    intTotalAboveY4 += ConvertToValue(objGI.Above_Indicative_Percent4__c);
                    /*intTotalIndicativeY1 += ConvertToValue(objGI.Indicative_Y1__c);
                    intTotalIndicativeY2 += ConvertToValue(objGI.Indicative_Y2__c);
                    intTotalIndicativeY3 += ConvertToValue(objGI.Indicative_Y3__c);
                    intTotalIndicativeY4 += ConvertToValue(objGI.Indicative_Y4__c);
                    
                    intTotalAboveY1 += ConvertToValue(objGI.Above_Indicative_Y1__c);
                    intTotalAboveY2 += ConvertToValue(objGI.Above_Indicative_Y2__c);
                    intTotalAboveY3 += ConvertToValue(objGI.Above_Indicative_Y3__c);
                    intTotalAboveY4 += ConvertToValue(objGI.Above_Indicative_Y4__c);*/
            }   
            //system.debug('I1:'+intTotalIndicativeY1+'I2:'+ intTotalIndicativeY2 +'I3:'+ intTotalIndicativeY3+'I4:'+ intTotalIndicativeY4);
            //system.debug('1a:'+intTotalAboveY1+'2a:'+ intTotalAboveY2 +'3a:'+ intTotalAboveY3 +'4a:'+ intTotalAboveY4 );
             
            objCNModule.TIndicativeIndi=0;
            objCNModule.TAboveIndi=0;
            if(objCN.Number_of_Years__c== '4'){
                //system.debug(objCNModule.TAbove+'$$'+objCNModule.TIndicative);
                objCNModule.TIndicativeIndi += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3 + intTotalIndicativeY4;
                objCNModule.TAboveIndi += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3 + intTotalAboveY4;
                //system.debug(objCNModule.TAbove+'$$'+objCNModule.TIndicative);
            }else{
                objCNModule.TIndicativeIndi += intTotalIndicativeY1 + intTotalIndicativeY2 + intTotalIndicativeY3;
                objCNModule.TAboveIndi += intTotalAboveY1 + intTotalAboveY2 + intTotalAboveY3;
            }
             system.debug('@@objCNModule.TIndicativeIndi : '+objCNModule.TIndicativeIndi + '@@objCNModule.TAboveIndi : ' +objCNModule.TAboveIndi );
 
            system.debug('@intTotalIndicativemain  : '+intTotalIndicativemain  + '@intTotalAbovemain  : ' +intTotalAbovemain  );
     
        }
    }
    Private List<Grant_Indicator__c> GetGrantIndicatorForModule(String strModuleId){
        return [select id,name,type__c,Indicator_Full_Name__c,French_Name__c,Spanish_Name__c,Russian_Name__c,Parent_Module__r.Implementation_Period__r.Principal_Recipient__r.Name,tied_to__c,
            Baseline_numerator__c,Baseline_Denominator__c,Baseline_Value__c,Baseline_Year__c,Baseline_Sources__c,data_type__c,Decimal_Places__c,
            IndicativeNumerator1__c,IndicativeNumerator2__c,IndicativeNumerator3__c,IndicativeNumerator4__c,
            Indicative_Denominator1__c,Indicative_Denominator2__c,Indicative_Denominator3__c,Indicative_Denominator4__c,
            Indicative_Percent1__c,Indicative_Percent2__c,Indicative_Percent3__c,Indicative_Percent4__c,
            Above_Indicative_Numerator1__c, Above_Indicative_Numerator2__c, Above_Indicative_Numerator3__c, Above_Indicative_Numerator4__c,
            Above_Indicative_Denominator1__c,Above_Indicative_Denominator2__c,Above_Indicative_Denominator3__c,Above_Indicative_Denominator4__c,
            Above_Indicative_Percent1__c,Above_Indicative_Percent2__c,Above_Indicative_Percent3__c,Above_Indicative_Percent4__c,
            Comments__c,Comments_French__c,Comments_Spanish__c,Comments_Russian__c,Country__r.Name           
            from Grant_Indicator__c where Indicator_Type__c='Coverage/Output'
            and Parent_Module__r.CN_Module__c=:strModuleId];
    } 
    
    Private List<CNIntervention> GetCNInterventionForModule(String strModuleId){
        List<Intervention__c> lstIntervention = [
                    Select Id, Name, French_Name__c,Spanish_Name__c,Russian_Name__c, Standard_or_Custom__c,
                           Description_of_intervention__c,Description_of_Intervention_French__c,Description_of_Intervention_Spanish__c,Description_of_Intervention_Russian__c,
                           Custom_Intervention_Name__c, Custom_Intervention_Name_French__c, Custom_Intervention_Name_Russian__c, Custom_Intervention_Name_Spanish__c, 
                        (
                            Select Id, Name,Implementation_Period__r.Principal_Recipient__r.Name,
                             Implementation_Period__r.Principal_Recipient__r.Short_Name__c, 
                            Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c ,Indicative_Y4__c, 
                            Above_Indicative_Y1__c,Above_Indicative_Y2__c,Above_Indicative_Y3__c,
                            Above_Indicative_Y4__c,CN_cost_assumptions__c,CN_cost_assumptions_French__c,CN_cost_assumptions_Spanish__c,CN_cost_assumptions_Russian__c,
                            CN_other_funding__c,CN_other_funding_French__c,CN_other_funding_Spanish__c,CN_other_funding_Russian__c
                            from Grant_Interventions__r 
                            Order By Implementation_Period__r.Principal_Recipient__r.Short_Name__c
                        )
                    from Intervention__c  where Module_rel__c=:strModuleId  Order By Name
                    ];
        List<CNIntervention> lstCNIntervention = new List<CNIntervention>();
        CNIntervention objCNIntervention;
        
       
        for(Intervention__c objCNI : lstIntervention)
        {
            objCNIntervention = new CNIntervention();
            objCNIntervention.objIntervention = objCNI;
            objCNIntervention.lstGrantIntervention = objCNI.Grant_Interventions__r;         
            lstCNIntervention.add(objCNIntervention);
        }
                
        return lstCNIntervention;
        
    }
    Private Decimal ConvertToValue(Decimal Value){
        if(Value != null){
            return value;
        }
        return 0;
    }
    
    Public Void fillCPFReports(){
        if(lstCPFR != null && lstCPFR.size() > 0){
            lstCPFReport = [Select Id, Start_Year__c, National_Strategic_Funding_Total__c ,Funding_Request_in_Indicative_Year_1__c,country__c,country__r.name,Concept_Note__r.CCM_new__r.Country__r.Country_Fiscal_Cycle_Months__c,Currency__c,Component__c,B_Year_2_Total__c,
                Concept_Note__r.Status__c, Concept_Note__r.Component__c,Concept_Note__r.Number_of_Years__c, Funding_Request_in_Indicative_Year_2__c,Funding_Request_in_Indicative_Year_3__c,country__r.Country_Fiscal_Cycle_Months__c, A_Current_Year__c, A_Year_plus_1__c, A_Year_plus_2__c, A_Year_plus_3__c,
                D_Year_2_Total__c,D_Year_1_Total__c,D_Current_Year_Total__c,D_Year_plus_1_Total__c,D_Year_plus_2_Total__c,D_Year_3_Total__c,B_Year_1_Total__c,B_Current_Year_Total__c,B_Year_plus_1_Total__c,B_Year_plus_2_Total__c,B_Year_3_Total__c,
                C_Year_plus_3_Total__c,C_Year_plus_2_Total__c,C_Year_plus_1_Total__c,C_Current_Year_Total__c,C_Year_1_Total__c,C_Year_2_Total__c,Anticipated_Funding_Gap_Total__c,Anticipated_Resources_Total__c,
                Funding_Request_above_Indicative_Year_1__c,Funding_Request_above_Indicative_Year_2__c,Anticipated_Resources_Current_Year__c,Anticipated_Resources_Year_1__c,Anticipated_Resources_Year_2__c,Anticipated_Resources_Year_3__c  ,
                Cycle_Start_Month__c,Cycle_End_Month__c,Implementation_cycle__c,Reporting_Cycle__c,Concept_Note__c,Concept_Note__r.Language__c,
                Funding_Request_above_Indicative_Year_3__c,Above_Indicative_Y1__c, Above_Indicative_Y2__c, Above_Indicative_Y3__c,Above_Indicative_Y4__c,
                Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c, Indicative_Y4__c, Total_Y1__c, Total_Y2__c, Total_Y3__c, Total_Y4__c From CPF_Report__c Where Id IN :lstCPFR];
                
            objCPFReport = new CPF_Report__c();
            blnReadOnly = CheckProfile.checkProfile();
            
            if(lstCPFReport.size() > 0){
                objCPFReport = lstCPFReport[0];               
                if(objCPFReport.Concept_Note__c != null){
                    strCNId = lstCPFReport[0].Concept_Note__c;
                    strComponent = lstCPFReport[0].Concept_Note__r.Component__c;
                    if(lstCPFReport[0].Concept_Note__r.Status__c == 'Submitted to the Global Fund'){
                        blnReadOnly = true; }
                    
                        
                    //testing Read-Only:
                    //blnReadOnly = true;
                    
                    //Running update on Grant Intervention records
                        Set<Id> cnIds = new Set<Id>();
                        cnIds.add(lstCPFReport[0].Concept_Note__c);
                        //updateCPFGrantInterventions.updateCPF(cnIds);
                        strLanguage = lstCPFReport[0].Concept_Note__r.Language__c;
                  /*   strLanguage = 'ENGLISH';
                if(System.UserInfo.getLanguage() == 'fr'){
                    strLanguage = 'FRENCH'; }
                if(System.UserInfo.getLanguage() == 'ru'){
                    strLanguage = 'RUSSIAN'; }
                if(System.UserInfo.getLanguage() == 'es'){
                    strLanguage = 'SPANISH'; }
                */
                    
                    strCountryId = lstCPFReport[0].Country__c;
                    /*List<AggregateResult> lstIndicativeValues = [Select Sum(Above_Indicative_Y1__c) AY1,
                                                Sum(Above_Indicative_Y2__c) AY2,Sum(Above_Indicative_Y3__c) AY3,
                                                Sum(Above_Indicative_Y4__c) AY4,Sum(Indicative_Y4__c) Y4,
                                                Sum(Indicative_Y1__c) Y1,Sum(Indicative_Y2__c) Y2,
                                                Sum(Indicative_Y3__c) Y3 From Grant_Intervention__c 
                                                Where Implementation_Period__r.concept_Note__c =: strCNId];
                    if(lstIndicativeValues.size() > 0){
                        AboveIndicativeY1 = (Decimal)lstIndicativeValues[0].get('AY1');
                        AboveIndicativeY2 = (Decimal)lstIndicativeValues[0].get('AY2');
                        AboveIndicativeY3 = (Decimal)lstIndicativeValues[0].get('AY3');
                        AboveIndicativeY4 = (Decimal)lstIndicativeValues[0].get('AY4');
                        IndicativeY1 = (Decimal)lstIndicativeValues[0].get('Y1');
                        IndicativeY2 = (Decimal)lstIndicativeValues[0].get('Y2');
                        IndicativeY3 = (Decimal)lstIndicativeValues[0].get('Y3');
                        IndicativeY4 = (Decimal)lstIndicativeValues[0].get('Y4');
                        if(IndicativeY1 == null) IndicativeY1 = 0;
                        if(IndicativeY2 == null) IndicativeY2 = 0;
                        if(IndicativeY3 == null) IndicativeY3 = 0;
                        if(IndicativeY4 == null) IndicativeY4 = 0;
                        if(AboveIndicativeY1 == null) AboveIndicativeY1 = 0;
                        if(AboveIndicativeY2 == null) AboveIndicativeY2 = 0;
                        if(AboveIndicativeY3 == null) AboveIndicativeY3 = 0;
                        if(AboveIndicativeY4 == null) AboveIndicativeY4 = 0;
                        TotalY1 = IndicativeY1 + AboveIndicativeY1;
                        TotalY2 = IndicativeY2 + AboveIndicativeY2;
                        TotalY3 = IndicativeY3 + AboveIndicativeY3;
                        TotalY4 = IndicativeY4 + AboveIndicativeY4;
                    }*/
                    
                }
                /* Comented on 5132014 
                Decimal MTotal_Temp = 0;
                Integer FinalDivideCountM = 1;
                if(objCPFReport.Indicative_Y1__c != null && objCPFReport.Indicative_Y1__c != 0){
                    MTotal_Temp += objCPFReport.Indicative_Y1__c;
                }
                if(objCPFReport.Indicative_Y2__c != null && objCPFReport.Indicative_Y2__c != 0){
                    MTotal_Temp += objCPFReport.Indicative_Y2__c;
                    FinalDivideCountM++;
                }
                if(objCPFReport.Indicative_Y3__c != null && objCPFReport.Indicative_Y3__c != 0){
                    MTotal_Temp += objCPFReport.Indicative_Y3__c;
                    FinalDivideCountM++;
                }
                if(objCPFReport.Indicative_Y4__c != null && objCPFReport.Indicative_Y4__c != 0){
                    MTotal_Temp += objCPFReport.Indicative_Y4__c;
                    FinalDivideCountM++;
                }
                    
                MAverage = MTotal_Temp / FinalDivideCountM;
                if(MAverage != 0){
                    MAverage = MAverage.setScale(0, System.roundingMode.HALF_UP);
                }
                
                Decimal OTotal_Temp = 0;
                Integer FinalDivideCountO = 1;
                
                if(objCPFReport.Total_Y1__c!= null){
                    OTotal_Temp += objCPFReport.Total_Y1__c;
                }
                if(objCPFReport.Total_Y2__c!= null){
                    OTotal_Temp += objCPFReport.Total_Y2__c;   
                    FinalDivideCountO++;        
                }
                if(objCPFReport.Total_Y3__c!= null){
                    OTotal_Temp += objCPFReport.Total_Y3__c;  
                    FinalDivideCountO++;      
                }
                if(objCPFReport.Total_Y4__c!= null){
                    OTotal_Temp += objCPFReport.Total_Y4__c; 
                    FinalDivideCountO++;       
                }
                OAverage = OTotal_Temp/FinalDivideCountO;
                if(OAverage != 0){
                    OAverage = OAverage.setScale(0, System.roundingMode.HALF_UP);
                }
                
                system.debug('####'+objCPFReport.Anticipated_Resources_Year_1__c);
                system.debug('####'+objCPFReport.A_Year_plus_1__c);
                
               */
                /*AnnualAnticipatedFundingGap1 = objCPFReport.A_Year_plus_1__c - objCPFReport.Anticipated_Resources_Year_1__c;
                AnnualAnticipatedFundingGap2 = objCPFReport.A_Year_plus_2__c - objCPFReport.Anticipated_Resources_Year_2__c;
                AnnualAnticipatedFundingGap3 = objCPFReport.A_Year_plus_3__c - objCPFReport.Anticipated_Resources_Year_3__c;*/
                
            }            
            lstCPFNewFundingReport = [Select Id, Start_Year__c, National_Strategic_Funding_Total__c ,Funding_Request_in_Indicative_Year_1__c,country__c,country__r.name,Concept_Note__r.CCM_new__r.Country__r.Country_Fiscal_Cycle_Months__c,Currency__c,Component__c,B_Year_2_Total__c,
                Concept_Note__r.Status__c, Concept_Note__r.Component__c,Concept_Note__r.Number_of_Years__c, Funding_Request_in_Indicative_Year_2__c,Funding_Request_in_Indicative_Year_3__c,country__r.Country_Fiscal_Cycle_Months__c, A_Current_Year__c, A_Year_plus_1__c, A_Year_plus_2__c, A_Year_plus_3__c,
                D_Year_2_Total__c,D_Year_1_Total__c,D_Current_Year_Total__c,D_Year_plus_1_Total__c,D_Year_plus_2_Total__c,D_Year_3_Total__c,B_Year_1_Total__c,B_Current_Year_Total__c,B_Year_plus_1_Total__c,B_Year_plus_2_Total__c,B_Year_3_Total__c,
                C_Year_plus_3_Total__c,C_Year_plus_2_Total__c,C_Year_plus_1_Total__c,C_Current_Year_Total__c,C_Year_1_Total__c,C_Year_2_Total__c,Anticipated_Funding_Gap_Total__c,Anticipated_Resources_Total__c,
                Funding_Request_above_Indicative_Year_1__c,Funding_Request_above_Indicative_Year_2__c,Anticipated_Resources_Current_Year__c,Anticipated_Resources_Year_1__c,Anticipated_Resources_Year_2__c,Anticipated_Resources_Year_3__c  ,
                Cycle_Start_Month__c,Cycle_End_Month__c,Implementation_cycle__c,Reporting_Cycle__c,Concept_Note__c,Concept_Note__r.Language__c,
                Funding_Request_above_Indicative_Year_3__c,Above_Indicative_Y1__c, Above_Indicative_Y2__c, Above_Indicative_Y3__c,Above_Indicative_Y4__c,
                Indicative_Y1__c,Indicative_Y2__c,J_Year_2_Total__c,J_Year_1_Total__c,J_Current_Year_Total__c,
                Indicative_Y3__c, Indicative_Y4__c, Total_Y1__c, Total_Y2__c, Total_Y3__c, Total_Y4__c, J_Year_plus_1_Total__c, J_Year_plus_2_Total__c ,J_Year_3_Total__c ,
                (Select Name,Id,CCM_Comments__c,RecordType.DeveloperName,CPF_Report__c,Current_Year__c,External_Source_Type__c,  Global_Fund_Comments__c,CCM_Comments_Russian__c,
                                                        Grant_Number__c,LFA_Comments__c,National_Strategic_Funding_Total__c,Other_External_Source__c,CCM_Comments_French__c,
                                                        Type__c,Year_plus_1__c,Year_plus_2__c,Year_plus_3__c,Year_1__c,Year_2__c,CCM_Comments_Spanish__c                                                        
                                                        From Funding_Sources__r order by  RecordType.DeveloperName,Type__c NULLS LAST)
                From CPF_Report__c Where Id IN :lstCPFR];


            lstFundingSource = new List<Funding_Source__c>([Select Name,Id,CCM_Comments__c,RecordType.DeveloperName,CPF_Report__c,Current_Year__c,External_Source_Type__c,  Global_Fund_Comments__c,
                                                        Grant_Number__c,LFA_Comments__c,National_Strategic_Funding_Total__c,Other_External_Source__c,
                                                        Type__c,Year_plus_1__c,Year_plus_2__c,Year_plus_3__c,Year_1__c,Year_2__c                                                        
                                                        From Funding_Source__c Where CPF_Report__c = 'a0xg0000005d9o5AAA' or CPF_Report__c = 'a0xg0000005cc2wAAA' Order By  RecordType.DeveloperName,Type__c NULLS LAST]);  
            MapDisplayMonth = new Map<String,String>();
            MapDisplayMonth.put(Label.January,'01');
            MapDisplayMonth.put(Label.February,'02');
            MapDisplayMonth.put(Label.March,'03');
            MapDisplayMonth.put(Label.April,'04');
            MapDisplayMonth.put(Label.May,'05');
            MapDisplayMonth.put(Label.June,'06');
            MapDisplayMonth.put(Label.July,'07');
            MapDisplayMonth.put(Label.August,'08');
            MapDisplayMonth.put(Label.September,'09');
            MapDisplayMonth.put(Label.October,'10');
            MapDisplayMonth.put(Label.November,'11');
            MapDisplayMonth.put(Label.December,'12');
            // strImplementCycle
            
            /*if(objCPFReport.Concept_Note__c != null){
                strImplementCycle = objCPFReport.Concept_Note__r.CCM_new__r.Country__r.Country_Fiscal_Cycle_Months__c;
            }else{
                if(objCPFReport.country__c != null){
                    strImplementCycle = objCPFReport.country__r.Country_Fiscal_Cycle_Months__c;
                }
            }
            if(strImplementCycle != null){
                list<String> lstSplitMonth = strImplementCycle.split(' - ');
                if(lstSplitMonth!=null && lstSplitMonth.size()>1){
                    String StartMonth = lstSplitMonth[0];
                    String EndMonth = lstSplitMonth[1];               
                    
                    //Date dtetoday = system.today();
                    //intCurrentYear = dtetoday.Year();
                    if(objCPFReport.Start_Year__c != null) {
                      intCurrentYear = Integer.valueOf(objCPFReport.Start_Year__c); }
                    
                    strStartMonth = MapDisplayMonth.get(StartMonth);
                    strEndMonth = MapDisplayMonth.get(EndMonth);
                }
            }*/
            
            FillWrapperCPFReport();  
        }
    }
    
    //Fill Wrapper Class.
    Public void FillWrapperCPFReport() {
        lstWrapperCPFAllReport = new List<WrapperCPFAllReport>();
    
        for(CPF_Report__c objCPFReportAll: lstCPFNewFundingReport){            
            WrapperCPFAllReport objWrapperCPFAllReport = new WrapperCPFAllReport();
           
            if(objCPFReportAll.Funding_Sources__r.Size() > 0){
            
               String StrRT = '';
               // WrapperCPFReport objWrapCPFReport;// = new WrapperCPFReport();
                List<WrapperFundingSource> lstWrapperFundingSource ;               
                lstWrapperFundingSourceNSF = new List<WrapperFundingSource>();
                lstWrapperFundingSourceB = new List<WrapperFundingSource>();
                lstWrapperFundingSourceC = new List<WrapperFundingSource>();
                lstWrapperFundingSourceD = new List<WrapperFundingSource>();
                lstWrapperFundingSourceJ = new List<WrapperFundingSource>();
                lstWrapperFundingSourceI = new List<WrapperFundingSource>();
                WrapperFundingSource objFS;
                
                for(Funding_Source__c objFunding : objCPFReportAll.Funding_Sources__r){
                    
                    if(StrRT != objFunding.RecordType.DeveloperName){
                       // objWrapCPFReport = new WrapperCPFReport();
                        //objWrapCPFReport.strRecordTypeName = objFunding.RecordType.DeveloperName;
                        StrRT = objFunding.RecordType.DeveloperName;
                        lstWrapperFundingSource = new List<WrapperFundingSource>();
                        if(objFunding.RecordType.DeveloperName == 'National_Strategic_Funding'){
                            lstWrapperFundingSourceNSF = lstWrapperFundingSource ;
                        }else if(objFunding.RecordType.DeveloperName == 'B'){
                            lstWrapperFundingSourceB = lstWrapperFundingSource;
                        }else if(objFunding.RecordType.DeveloperName == 'C'){
                            lstWrapperFundingSourceC = lstWrapperFundingSource;
                        }else if(objFunding.RecordType.DeveloperName == 'D'){
                            lstWrapperFundingSourceD = lstWrapperFundingSource;
                        }else if(objFunding.RecordType.DeveloperName == 'J'){
                            lstWrapperFundingSourceJ = lstWrapperFundingSource;
                        }else if(objFunding.RecordType.DeveloperName == 'I'){
                            lstWrapperFundingSourceI = lstWrapperFundingSource;
                        }
                       // lstWrapperCPFReport.add(objWrapCPFReport); 
                    }                    
                    objFS = new  WrapperFundingSource();
                    if(objFunding.RecordType.DeveloperName == 'National_Strategic_Funding'){
                        objFS.strName = Label.Funding_Needs_NSP;  //'Total Funding needs for the National Strategic Plan (provide annual amounts)';
                        if(objCPFReportAll.Anticipated_Resources_Current_Year__c != null && objFunding.Current_Year__c != null)
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGapCurr = objFunding.Current_Year__c - objCPFReportAll.Anticipated_Resources_Current_Year__c;
                        else if(objCPFReportAll.Anticipated_Resources_Current_Year__c == null && objFunding.Current_Year__c != null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGapCurr = objFunding.Current_Year__c;
                        else if (objCPFReportAll.Anticipated_Resources_Current_Year__c != null && objFunding.Current_Year__c == null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGapCurr = - objCPFReportAll.Anticipated_Resources_Current_Year__c;
                        
                        if(objCPFReportAll.Anticipated_Resources_Year_1__c != null && objFunding.Year_plus_1__c != null)
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap1 = objFunding.Year_plus_1__c - objCPFReportAll.Anticipated_Resources_Year_1__c;
                        else if(objCPFReportAll.Anticipated_Resources_Year_1__c == null && objFunding.Year_plus_1__c != null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap1 = objFunding.Year_plus_1__c;
                        else if (objCPFReportAll.Anticipated_Resources_Year_1__c != null && objFunding.Year_plus_1__c == null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap1 = - objCPFReportAll.Anticipated_Resources_Year_1__c;
                            
                        if(objCPFReportAll.Anticipated_Resources_Year_2__c != null && objFunding.Year_plus_2__c != null)
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap2 = objFunding.Year_plus_2__c - objCPFReportAll.Anticipated_Resources_Year_2__c;
                        else if(objCPFReportAll.Anticipated_Resources_Year_2__c == null && objFunding.Year_plus_2__c != null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap2 = objFunding.Year_plus_2__c;
                        else if (objCPFReportAll.Anticipated_Resources_Year_2__c != null && objFunding.Year_plus_2__c == null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap2 = - objCPFReportAll.Anticipated_Resources_Year_2__c;
                        
                        if(objCPFReportAll.Anticipated_Resources_Year_3__c != null && objFunding.Year_plus_3__c != null)
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap3 = objFunding.Year_plus_3__c - objCPFReportAll.Anticipated_Resources_Year_3__c;
                        else if(objCPFReportAll.Anticipated_Resources_Year_3__c == null && objFunding.Year_plus_3__c != null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap3 = objFunding.Year_plus_3__c;
                        else if (objCPFReportAll.Anticipated_Resources_Year_3__c != null && objFunding.Year_plus_3__c == null) 
                            objWrapperCPFAllReport.AnnualAnticipatedFundingGap3 = - objCPFReportAll.Anticipated_Resources_Year_3__c;
                        
                    }else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '1'){
                        objFS.strName = Label.DS_B1_Loans; //'Domestic source B1: Loans';                    
                        if(objWrapperCPFAllReport.TotalK1 == null) objWrapperCPFAllReport.TotalK1 = objFunding.Year_1__c;                  
                        if(objWrapperCPFAllReport.TotalK2 == null) objWrapperCPFAllReport.TotalK2 = objFunding.Year_2__c;
                        if(objWrapperCPFAllReport.TotalK == null) objWrapperCPFAllReport.TotalK = objFunding.Current_Year__c;
                    }
                    else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '2'){
                        objFS.strName = Label.DS_B2_Debt_Relief; //'Domestic source B2: Debt relief';
                        if(objWrapperCPFAllReport.TotalK1 == null) objWrapperCPFAllReport.TotalK1 = 0;
                        if(objFunding.Year_1__c != null){
                            objWrapperCPFAllReport.TotalK1 += objFunding.Year_1__c;
                        }
                        if(objWrapperCPFAllReport.TotalK2 == null) objWrapperCPFAllReport.TotalK2 = 0;
                        if(objFunding.Year_2__c != null){
                            objWrapperCPFAllReport.TotalK2 += objFunding.Year_2__c;
                        }
                        if(objWrapperCPFAllReport.TotalK == null) objWrapperCPFAllReport.TotalK = 0;
                        if(objFunding.Current_Year__c != null){
                            objWrapperCPFAllReport.TotalK += objFunding.Current_Year__c;
                        }
                        
                    }
                    else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '3'){
                        objFS.strName = Label.DS_B3_Govt_Revenues; //'Domestic source B3: Government revenues';
                        if(objWrapperCPFAllReport.TotalK1 == null) objWrapperCPFAllReport.TotalK1 = 0;
                        if(objFunding.Year_1__c != null){
                            objWrapperCPFAllReport.TotalK1 += objFunding.Year_1__c;
                        }
                        if(objWrapperCPFAllReport.TotalK2 == null) objWrapperCPFAllReport.TotalK2 = 0;
                        if(objFunding.Year_2__c != null){
                            objWrapperCPFAllReport.TotalK2 += objFunding.Year_2__c;
                        }
                        if(objWrapperCPFAllReport.TotalK == null) objWrapperCPFAllReport.TotalK = 0;
                        if(objFunding.Current_Year__c != null){
                            objWrapperCPFAllReport.TotalK += objFunding.Current_Year__c;
                        }
                    }
                    else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '4'){
                        objFS.strName = Label.DS_B4_Social_Health_Insurance;  //'Domestic source B4: Social health insurance';
                        if(objWrapperCPFAllReport.TotalK1 == null) objWrapperCPFAllReport.TotalK1 = 0;
                        if(objFunding.Year_1__c != null){
                            objWrapperCPFAllReport.TotalK1 += objFunding.Year_1__c;
                        }
                        if(objWrapperCPFAllReport.TotalK2 == null) objWrapperCPFAllReport.TotalK2 = 0;
                        if(objFunding.Year_2__c != null){
                            objWrapperCPFAllReport.TotalK2 += objFunding.Year_2__c;
                        }
                        if(objWrapperCPFAllReport.TotalK == null) objWrapperCPFAllReport.TotalK = 0;
                        if(objFunding.Current_Year__c != null){
                            objWrapperCPFAllReport.TotalK += objFunding.Current_Year__c;
                        }
                    }
                    else if(objFunding.RecordType.DeveloperName == 'B' && objFunding.Type__c == '5')
                        objFS.strName = Label.DS_B5_Prival_Sector_Contributions; //'Domestic source B5: Private sector contributions national';
                    else if(objFunding.RecordType.DeveloperName == 'C'){
                        if(objFunding.External_Source_Type__c == null) objFunding.External_Source_Type__c = '';
                        if(objFunding.Type__c != null){
                            objFS.strName = 'C'+objFunding.Type__c;
                        }
                    }                    
                    else if(objFunding.RecordType.DeveloperName == 'D'){
                        if(objFunding.Grant_Number__c == null) objFunding.Grant_Number__c = '';
                        objFS.strName = objFunding.Grant_Number__c;
                    }                
                    else if(objFunding.RecordType.DeveloperName == 'I' && objFunding.Type__c == '2')
                        objFS.strName = Label.Line_H_Funding_Request_Allocated_Amount;   // 'LINE H: Funding request within the Indicative Amount';
                    else if(objFunding.RecordType.DeveloperName == 'I' && objFunding.Type__c == '1')
                        objFS.strName =Label.Line_I_Funding_Request_Above_Allocated;    // 'LINE I: Funding request above the Indicative Amount';
                    else if(objFunding.RecordType.DeveloperName == 'J' && objFunding.Type__c == '1')
                        objFS.strName = Label.DS_J1_Loans;                              //'Domestic source J1: Loans';
                    else if(objFunding.RecordType.DeveloperName == 'J' && objFunding.Type__c == '2')
                        objFS.strName = Label.DS_J2_Debt_Relief;                        //'Domestic source J2: Debt Relief';
                    else if(objFunding.RecordType.DeveloperName == 'J' && objFunding.Type__c == '3')
                        objFS.strName = Label.DS_J3_Govt_Funding;                       // 'Domestic source J3: Government funding resources';
                    //objFS.objFundingSource = new Funding_Source__c();
                    objFS.objFundingSource = objFunding;
                    lstWrapperFundingSource.add(objFS);
                }
                
                if(lstWrapperFundingSourceI.size() > 0 && lstWrapperFundingSourceI.size() == 2){
                    WrapperFundingSource objWrap = new WrapperFundingSource();
                    objWrap = lstWrapperFundingSourceI[1];
                    lstWrapperFundingSourceI[1] = lstWrapperFundingSourceI[0];
                    lstWrapperFundingSourceI[0] = objWrap;
                }
                
                
                //Add to Wrapper Class For All CPF Report
                objWrapperCPFAllReport.objCPFReport  = objCPFReportAll;
                objWrapperCPFAllReport.lstWrapperFundingSourceNSF = lstWrapperFundingSourceNSF;
                objWrapperCPFAllReport.lstWrapperFundingSourceB = lstWrapperFundingSourceB;
                objWrapperCPFAllReport.lstWrapperFundingSourceC = lstWrapperFundingSourceC;
                objWrapperCPFAllReport.lstWrapperFundingSourceD = lstWrapperFundingSourceD;
                objWrapperCPFAllReport.lstWrapperFundingSourceJ = lstWrapperFundingSourceJ;
                objWrapperCPFAllReport.lstWrapperFundingSourceI = lstWrapperFundingSourceI;
                
//                ======================= added 5132014=========================
                
                
                
                if(objCPFReportAll.Concept_Note__c != null){
                    objWrapperCPFAllReport.strImplementCycle = objCPFReportAll.Concept_Note__r.CCM_new__r.Country__r.Country_Fiscal_Cycle_Months__c;
                }else{
                    if(objCPFReportAll.country__c != null){
                        objWrapperCPFAllReport.strImplementCycle = objCPFReportAll.country__r.Country_Fiscal_Cycle_Months__c;
                    }
                }
                if(objWrapperCPFAllReport.strImplementCycle != null){
                    list<String> lstSplitMonth = objWrapperCPFAllReport.strImplementCycle.split(' - ');
                    if(lstSplitMonth!=null && lstSplitMonth.size()>1){
                        String StartMonth = lstSplitMonth[0];
                        String EndMonth = lstSplitMonth[1];               
                        
                        //Date dtetoday = system.today();
                        //intCurrentYear = dtetoday.Year();
                        if(objCPFReportAll.Start_Year__c != null) {
                          objWrapperCPFAllReport.intCurrentYear = Integer.valueOf(objCPFReportAll.Start_Year__c); }
                        
                        objWrapperCPFAllReport.strStartMonth = MapDisplayMonth.get(StartMonth);
                        objWrapperCPFAllReport.strEndMonth = MapDisplayMonth.get(EndMonth);
                    }
                }
            
                Decimal MTotal_Temp = 0;
                Integer FinalDivideCountM = 0;
                if(objCPFReportAll.Indicative_Y1__c != null && objCPFReportAll.Indicative_Y1__c != 0){
                    MTotal_Temp += objCPFReportAll.Indicative_Y1__c;
                    FinalDivideCountM++;
                }
                if(objCPFReportAll.Indicative_Y2__c != null && objCPFReportAll.Indicative_Y2__c != 0){
                    MTotal_Temp += objCPFReportAll.Indicative_Y2__c;
                    FinalDivideCountM++;
                }
                if(objCPFReportAll.Indicative_Y3__c != null && objCPFReportAll.Indicative_Y3__c != 0){
                    MTotal_Temp += objCPFReportAll.Indicative_Y3__c;
                    FinalDivideCountM++;
                }
                if(objCPFReportAll.Indicative_Y4__c != null && objCPFReportAll.Indicative_Y4__c != 0){
                    MTotal_Temp += objCPFReportAll.Indicative_Y4__c;
                    FinalDivideCountM++;
                }
                    
                if(FinalDivideCountM != 0) objWrapperCPFAllReport.MAverage = MTotal_Temp / FinalDivideCountM;
                  else objWrapperCPFAllReport.MAverage = 0;
                if(objWrapperCPFAllReport.MAverage != 0){
                    objWrapperCPFAllReport.MAverage = objWrapperCPFAllReport.MAverage.setScale(0, System.roundingMode.HALF_UP);
                }
                
                Decimal OTotal_Temp = 0;
                Integer FinalDivideCountO = 0;
                
                if(objCPFReportAll.Total_Y1__c!= null && objCPFReportAll.Total_Y1__c != 0){
                    OTotal_Temp += objCPFReportAll.Total_Y1__c;
                    FinalDivideCountO++;
                }
                if(objCPFReportAll.Total_Y2__c!= null && objCPFReportAll.Total_Y2__c != 0){
                    OTotal_Temp += objCPFReportAll.Total_Y2__c;   
                    FinalDivideCountO++;        
                }
                if(objCPFReportAll.Total_Y3__c!= null && objCPFReportAll.Total_Y3__c != 0){
                    OTotal_Temp += objCPFReportAll.Total_Y3__c;  
                    FinalDivideCountO++;      
                }
                if(objCPFReportAll.Total_Y4__c!= null && objCPFReportAll.Total_Y4__c != 0){
                    OTotal_Temp += objCPFReportAll.Total_Y4__c; 
                    FinalDivideCountO++;       
                }
                if(FinalDivideCountO != 0) objWrapperCPFAllReport.OAverage = OTotal_Temp/FinalDivideCountO;
                  else objWrapperCPFAllReport.OAverage = 0;
                if(objWrapperCPFAllReport.OAverage != 0){
                    objWrapperCPFAllReport.OAverage = objWrapperCPFAllReport.OAverage.setScale(0, System.roundingMode.HALF_UP);
                }
                
                if(objWrapperCPFAllReport.LAverage == null) {objWrapperCPFAllReport.LAverage = 0; }
                if(objWrapperCPFAllReport.TotalK != null) { objWrapperCPFAllReport.LAverage += objWrapperCPFAllReport.TotalK;}
                if(objWrapperCPFAllReport.TotalK1 != null) { objWrapperCPFAllReport.LAverage += objWrapperCPFAllReport.TotalK1;}
                if(objWrapperCPFAllReport.TotalK2 != null) { objWrapperCPFAllReport.LAverage += objWrapperCPFAllReport.TotalK2;}
                objWrapperCPFAllReport.LAverage = objWrapperCPFAllReport.LAverage / 3;
                
                if(objWrapperCPFAllReport.LAverage == null) objWrapperCPFAllReport.LAverage = 0;
                if(objWrapperCPFAllReport.MAverage == null) objWrapperCPFAllReport.MAverage = 0;
                        
                if(objWrapperCPFAllReport.LAverage + objWrapperCPFAllReport.MAverage != 0){
                    objWrapperCPFAllReport.NAverage = (objWrapperCPFAllReport.LAverage / (objWrapperCPFAllReport.LAverage + objWrapperCPFAllReport.MAverage) * 100); 
                    if(objWrapperCPFAllReport.NAverage != 0) objWrapperCPFAllReport.NAverage = objWrapperCPFAllReport.NAverage.setScale(2); }
                
                if(objWrapperCPFAllReport.LAverage + objWrapperCPFAllReport.OAverage != 0){
                    objWrapperCPFAllReport.PAverage = (objWrapperCPFAllReport.LAverage / (objWrapperCPFAllReport.LAverage + objWrapperCPFAllReport.OAverage) * 100);
                    if(objWrapperCPFAllReport.PAverage != 0) objWrapperCPFAllReport.PAverage = objWrapperCPFAllReport.PAverage.setScale(2); }
            
                lstWrapperCPFAllReport.add(objWrapperCPFAllReport); 
                system.debug('objWrapperCPFAllReport' + objWrapperCPFAllReport);
                
            }
        }
    }
   
    Public Class CNIntervention{
        Public Intervention__c objIntervention {get;set;}
        Public List<Grant_Intervention__c> lstGrantIntervention {get;set;}        
    }
    Public Class CNModule{
        Public Module__c objModule{get;set;}
        Public Decimal TIndicative {get;set;}
        public Decimal TAbove{get;set;}
        Public Decimal TIndicativeIndi{get;set;}
        Public Decimal TAboveIndi {get;set;}
        Public List<Grant_Indicator__c> lstGI{get;set;}
        Public List<CNIntervention> lstCI{get;set;}
        Public List<wrapperClsModulePG> lstPG {get;set;}
        
    }
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
        
        //Public List<Programmatic_Gap__c> lstPG{get;set;}
        public Boolean isShow{get;set;}
    }
     Public Class ProgrammaticGap {
        
        Public Boolean blnHistory {get;set;}
        Public Programmatic_Gap__c objPGap {get;set;}
    }
    // Decalartion for wrapper class for funding source.
    Public class WrapperFundingSource{
        
        Public Boolean blnDisplayInput {get;set;}
        Public String strName {get;set;}
        Public Funding_Source__c objFundingSource {get;set;}        
    }
    public class WrapperCPFAllReport{
        public CPF_Report__c  objCPFReport {get;set;}
        public List<WrapperFundingSource> lstWrapperFundingSourceNSF {get;set;}       
        public List<WrapperFundingSource> lstWrapperFundingSourceB {get;set;}
        public List<WrapperFundingSource> lstWrapperFundingSourceC {get;set;} 
        public List<WrapperFundingSource> lstWrapperFundingSourceD {get;set;}
        public List<WrapperFundingSource> lstWrapperFundingSourceJ {get;set;}
        public List<WrapperFundingSource> lstWrapperFundingSourceI {get;set;}
        
        Public Decimal AnnualAnticipatedFundingGapCurr{get;set;}
        Public Decimal AnnualAnticipatedFundingGap1{get;set;}
        Public Decimal AnnualAnticipatedFundingGap2{get;set;}
        Public Decimal AnnualAnticipatedFundingGap3{get;set;}
        
        Public Decimal TotalK1 {get;set;}
        Public Decimal TotalK2 {get;set;}
        Public Decimal TotalK {get;set;}    
    
        Public Decimal MAverage{get;set;}
        Public Decimal OAverage{get;set;}
        Public Decimal LAverage {get;set;}
        Public Decimal NAverage{get;set;}
        Public Decimal PAverage{get;set;}
    
        Public String strImplementCycle {get;set;}
        Public String strStartMonth {get;set;}
        Public String strEndMonth {get;set;}    
        Public Integer intCurrentYear {get;set;}
        
        public WrapperCPFAllReport(){
            objCPFReport = new CPF_Report__c();
            lstWrapperFundingSourceNSF = new List<WrapperFundingSource>();
            lstWrapperFundingSourceB = new List<WrapperFundingSource>();
            lstWrapperFundingSourceC = new List<WrapperFundingSource>();
            lstWrapperFundingSourceD = new List<WrapperFundingSource>();
            lstWrapperFundingSourceJ = new List<WrapperFundingSource>();
            lstWrapperFundingSourceI = new List<WrapperFundingSource>();
            AnnualAnticipatedFundingGapCurr= 0;
            AnnualAnticipatedFundingGap1= 0;
            AnnualAnticipatedFundingGap2= 0;
            AnnualAnticipatedFundingGap3= 0;
        }
    }
    Public Class BLModule{
        Public Integer AboveY1 {get;set;}
        Public Integer AboveY2 {get;set;}
        Public Integer AboveY3 {get;set;}
        Public Integer AboveY4 {get;set;}
        Public Integer IndY1 {get;set;}
        Public Integer IndY2 {get;set;}
        Public Integer IndY3 {get;set;}
        Public Integer IndY4 {get;set;}
        Public Integer TotalModuleCostA {get;set;}
        Public Integer TotalModuleCostI {get;set;}
        Public String ModuleName {get;set;}
    }
    Public Class BLModulePR{
        Public Integer AboveY1 {get;set;}
        Public Integer AboveY2 {get;set;}
        Public Integer AboveY3 {get;set;}
        Public Integer AboveY4 {get;set;}
        Public Integer IndY1 {get;set;}
        Public Integer IndY2 {get;set;}
        Public Integer IndY3 {get;set;}
        Public Integer IndY4 {get;set;}
        Public Integer TotalModuleCostA {get;set;}
        Public Integer TotalModuleCostI {get;set;}
        Public String ModuleName {get;set;}
    }
}