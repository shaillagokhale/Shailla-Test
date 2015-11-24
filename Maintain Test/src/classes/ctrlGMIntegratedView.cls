Global with sharing Class ctrlGMIntegratedView{
    public String strGIPId {get;set;}
    public String strCNId {get;set;}
    Public List<Goals_Objectives__c> lstGoals {get;set;}
    Public List<Goals_Objectives__c> lstObjectives {get;set;}
    public List<Implementation_Period__c> lstIP {get;set;}
    Public List<Period__c> lstRP {get;set;}
    Public List<Grant_Indicator__c> lstImpact {get;set;}
    Public List<Grant_Indicator__c> lstOutcome {get;set;}
    //Public List<Module__C> lstModules {get;set;}
    Public List<WrapModule> lstModules {get;set;}
    Public List<Grant_Intervention__c> lstInterventions;
    Public List<BLPayee> lstBLPayee {get;set;}   
    Public List<BLCost> lstBLCost {get;set;} 
    Public List<BLCost> lstBudgetLineCost{get;set;}
    Public List<Grant_Indicator__c> lstCOIndicators {get;set;}
    Public Date Today { get { return Date.today(); }}
    
    Public Integer TotalP1Cost {get;set;}
    Public Integer TotalP2Cost {get;set;}
    Public Integer TotalP3Cost {get;set;}
    Public Integer TotalP4Cost {get;set;}
    Public Integer TotalP5Cost {get;set;}
    Public Integer TotalP6Cost {get;set;}
    Public Integer TotalP7Cost {get;set;}
    Public Integer TotalP8Cost {get;set;}
    Public Integer AllYearTotalCost {get;set;}
    
    Public Integer TotalPayeeP1Cost {get;set;}
    Public Integer TotalPayeeP2Cost {get;set;}
    Public Integer TotalPayeeP3Cost {get;set;}
    Public Integer TotalPayeeP4Cost {get;set;}
    Public Integer TotalPayeeP5Cost {get;set;}
    Public Integer TotalPayeeP6Cost {get;set;}
    Public Integer TotalPayeeP7Cost {get;set;}
    Public Integer TotalPayeeP8Cost {get;set;}
    Public Integer AllYearPayeeTotalCost {get;set;}

    public ctrlGMIntegratedView(ApexPages.StandardController controller) {
    
        strGIPId = Apexpages.currentpage().getparameters().get('id'); 
        
        if(String.IsBlank(strGIPId) == false){
            List<Implementation_Period__c> lstIP = [Select Id,Concept_Note__c From Implementation_Period__c Where Id =: strGIPId And Concept_Note__c != null Limit 1];
            if(lstIP.size() > 0) strCNId = lstIP[0].Concept_Note__c; 

        lstGoals = new List<Goals_Objectives__c>();   
        lstGoals = [Select Id,Goal__c,Number__c From Goals_Objectives__c Where Concept_Note__c =: strCNID And Type__c = 'Goal' Order by Number__c];  
        
        lstObjectives = new List<Goals_Objectives__c>();   
        lstObjectives = [Select Id,Goal__c,Number__c From Goals_Objectives__c Where Concept_Note__c =: strCNID And Type__c = 'Objective' Order by Number__c];  
        
        lstRP = new List<Period__c>();   
        lstRP = [Select Id, Period_Number__c,Start_Date__c,End_Date__c,Due_Date__c,Document__c,PU__c,DR__c,EFR__c,Period_Length__c, Audit_Report__c,AR_Due_Date__c,EFR_Due_Date__c,PU_Due_Date__c  From Period__c Where Implementation_Period__c =: strGIPID And Type__c = 'Reporting' Order by Period_Number__c];          
       
        lstImpact = new List<Grant_Indicator__c>();
        lstImpact = [Select Id,Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c,Comments__c,Indicator_Type__c,
                                        Target_Value_Y1__c,Target_Value_Y2__c,Target_Value_Y3__c,Target_Value_Y4__c,Decimal_Places__c,
                                        Standard_or_Custom__c,Baseline_Sources__c,Indicator__c,Data_Type__c,
                                        Y1_Report_Due__c,Y2_Report_Due__c,Y3_Report_Due__c,Y4_Report_Due__c,
                                        (Select Id,Goal_Objective__r.Number__c from Indicator_Goal_Junctions__r)
                                         from Grant_Indicator__c where Concept_Note__c =: strCNId And Indicator_Type__c = 'Impact'];
                                        
        
        lstOutcome = new List<Grant_Indicator__c>();
        lstOutcome = [Select Id,Baseline_Value__c,Baseline_Year__c,Indicator_Full_Name__c,Comments__c,Indicator_Type__c,
                                        Target_Value_Y1__c,Target_Value_Y2__c,Target_Value_Y3__c,Target_Value_Y4__c,Decimal_Places__c,
                                        Standard_or_Custom__c,Baseline_Sources__c,Indicator__c,Data_Type__c,
                                        Y1_Report_Due__c,Y2_Report_Due__c,Y3_Report_Due__c,Y4_Report_Due__c,
                                        (Select Id,Goal_Objective__r.Number__c from Indicator_Goal_Junctions__r)
                                        from Grant_Indicator__c where Concept_Note__c =: strCNId And Indicator_Type__c = 'Outcome'];                                
       
        List<Module__c> lstModulesTemp = new List<Module__c>();      
        lstModulesTemp = [Select Id,Name, 
                    (Select Id,Name,Catalog_Intervention__r.Description__c,P1_Grant_Amount__c,P2_Grant_Amount__c,P3_Grant_Amount__c,P4_Grant_Amount__c,P5_Grant_Amount__c,P6_Grant_Amount__c,P7_Grant_Amount__c,P8_Grant_Amount__c from Grant_Interventions__r),
                    (Select Id,Indicator_Full_Name__c,Data_Type__c,Tied_To__c,Target_Accumulation__c,Baseline_Sources__c,Baseline_Numerator__c,Baseline_Denominator__c,Baseline_Value__c, Target_Area__c from Grant_Indicators__r Where Indicator_Type__c = 'Coverage/Output')
                    from Module__c where Implementation_Period__c =: strGIPId];
                  
        system.debug('$#$#$#$#$'+lstModulesTemp);
                    
        Set<Id> setIndiIds = new Set<Id>();      
        for(Module__c objMod : lstModulesTemp){
            for(Grant_Indicator__c objGI : objMod.Grant_Indicators__r){
                setIndiIds.add(objGI.Id);
            }
        }       
        
        Set<Id> setIntIds = new Set<Id>();      
        for(Module__c objMod : lstModulesTemp){
            for(Grant_Intervention__c objInt : objMod.Grant_Interventions__r){
                setIntIds.add(objInt.Id);
            }
        }
        
        Map<Id,List<Grant_Indicator__c>> mapInterventionIdToIndicator = new Map<Id,List<Grant_Indicator__c>>();
        List<Grant_Indicator__c> lstIndicatorTemp = [Select Id,Name,Indicator_Full_Name__c,Data_Source__c,Grant_Intervention__c,(Select Period__c,id,Target__c,Target_Denominator__c,
                                        Target_Numerator__c From Results__r)
                                        From Grant_Indicator__c Where Grant_Intervention__c IN : setIntIds];
        
        if(lstIndicatorTemp.size() > 0){
            for(Grant_Indicator__c objGI : lstIndicatorTemp){
                if(mapInterventionIdToIndicator.containsKey(objGI.Grant_Intervention__c)){
                    mapInterventionIdToIndicator.get(objGI.Grant_Intervention__c).add(objGI);
                }else{
                    mapInterventionIdToIndicator.put(objGI.Grant_Intervention__c,new List<Grant_Indicator__c>{objGI});
                }
            }
        }
        
        
        List<Result__c> lstResultGI = [Select Period__c,id,Target__c,Target_Denominator__c,Target_Numerator__c,Indicator__r.Grant_Intervention__c From Result__c 
                                        Where Indicator__r.Grant_Intervention__c IN : setIntIds];
                                        
        Map<Id,List<Result__c>> mapGIIdToResult = new Map<Id,List<Result__c>>();
        if(lstResultGI.size() > 0){
            for(Result__c objResult : lstResultGI){
                if(mapGIIdToResult.ContainsKey(objResult.Indicator__r.Grant_Intervention__c)){
                    mapGIIdToResult.get(objResult.Indicator__r.Grant_Intervention__c).add(objResult);
                }else{
                    mapGIIdToResult.put(objResult.Indicator__r.Grant_Intervention__c,new List<Result__c>{objResult});
                }
            }
        }
        
        Map<Id,Grant_Indicator__c> mapIndicator = new Map<Id,Grant_Indicator__c>([Select Id,Indicator_Full_Name__c,
                                            Tied_to__c,Target_Accumulation__c,Baseline_Sources__c,
                                            (Select Period__c,id,Target__c,Target_Denominator__c,Target_Numerator__c
                                             From Results__r) 
                                            From Grant_Indicator__c Where Id IN : setIndiIds
                                           ]);
        Set<Id> setPeriodIds = new Set<Id>();                                  
        if(mapIndicator.size() > 0){
            
            for(Grant_Indicator__c objGI : mapIndicator.values()){
                for(Result__c objR : objGI.Results__r){
                    setPeriodIds.add(objR.Period__c);
                }
            }
        }
        Map<id,period__c> mapPeriod;
        if(setPeriodIds.size() > 0){
            mapPeriod = new map<Id,period__c>([Select Id,Period_Number__c From Period__c Where Id IN : setPeriodIds]);
        }
        system.debug('$#$#$#$#$'+lstModulesTemp);
        lstModules = new List<wrapModule>();
        for(Module__c objMod : lstModulesTemp){
            WrapModule objWrap = new WrapModule();
            objWrap.objModule = new Module__c ();
            objWrap.objModule = objMod;
            objWrap.lstIndicator = new List<WrapIndicator>();
            objWrap.lstIntervention = new List<WrapIntervention>();
            system.debug('$#$#$#$#$'+objMod.Grant_Indicators__r);
            for(Grant_Indicator__c objGI : objMod.Grant_Indicators__r){
                WrapIndicator objI = new WrapIndicator();
                objI.objIndicator = new Grant_Indicator__c();
                objI.objIndicator = objGI;
                objI.lstPeriodResultsIndicator = new List<WrapPeriodResults>();
                if(mapIndicator.size() > 0 && mapIndicator.get(objGI.Id) != null){
                    if(mapIndicator.get(objGI.Id).Results__r.size() > 0){
                        for(Result__c objRes : mapIndicator.get(objGI.Id).Results__r){
                            WrapPeriodResults objPR = new WrapPeriodResults();
                            objPR.objPeriod = new Period__c();
                            objPR.objResult = new Result__c();
                            if(mapPeriod.size() > 0 && mapPeriod.get(objRes.Period__c) != null){
                                objPR.objPeriod = mapPeriod.get(objRes.Period__c);
                            }
                            objPR.objResult = objRes;
                            objI.lstPeriodResultsIndicator.add(objPR);
                        }
                    }
                }
                objWrap.lstIndicator.add(objI);
                system.debug('$#$#$#$#$'+objWrap.lstIndicator);
            }
            
            for(Grant_Intervention__c objGI : objMod.Grant_Interventions__r){
                WrapIntervention objInt = new WrapIntervention();
                objInt.objIntervention = new Grant_Intervention__c();
                objInt.objIntervention = objGI;
                objInt.lstIndicatorInt = new List<WrapIndicator>();
                if(mapInterventionIdToIndicator.size() > 0 && mapInterventionIdToIndicator.get(objGI.Id) != null && mapInterventionIdToIndicator.get(objGI.Id).size() > 0){
                    for(Grant_Indicator__c objGInd : mapInterventionIdToIndicator.get(objGI.Id)){
                        WrapIndicator objI = new WrapIndicator();
                        objI.objIndicator = new Grant_Indicator__c();
                        objI.objIndicator = objGInd;
                        objI.lstPeriodResultsIndicator = new List<WrapPeriodResults>();
                        if(objGInd.Results__r != null && objGInd.Results__r.size() > 0){
                            for(Result__c objRes : objGInd.Results__r){
                                WrapPeriodResults objPR = new WrapPeriodResults();
                                objPR.objResult = new Result__c();
                                objPR.objResult = objRes;
                                objI.lstPeriodResultsIndicator.add(objPR);
                            }
                        }
                        objInt.lstIndicatorInt.add(objI);
                    }
                }
                objWrap.lstIntervention.add(objInt);
            }
            
            lstModules.add(objWrap);
        }
        
        lstCOIndicators = new List<Grant_Indicator__c>();
        lstCOIndicators = [SELECT Id, 
              (Select Id,Period__c,Period__r.Period_Number__c,Target__c,Target_Denominator__c,Target_Numerator__c from Results__r) 
              from Grant_Indicator__c Where Type__C = 'Coverage/Output' and Grant_Implementation_Period__c =: strGIPId];
                
    //Get aggregated budget data
        
        List<AggregateResult> lstBudgetLineCost = [Select Cost_Input__r.Cost_Grouping__c CostGrouping,Sum(P1_Amount__c) CostP1,Sum(P2_Amount__c) CostP2,Sum(P3_Amount__c) CostP3,Sum(P4_Amount__c) CostP4,Sum(P5_Amount__c) CostP5,Sum(P6_Amount__c) CostP6,Sum(P7_Amount__c) CostP7,Sum(P8_Amount__c) CostP8 From Budget_Line__c WHERE Cost_Input__r.Cost_Grouping__c != null And Grant_Intervention__r.Module__r.Implementation_Period__c =: strGIPId GROUP BY Cost_Input__r.Cost_Grouping__c ];
        
        lstBLCost = new List<BLCost>();
        for(AggregateResult objAgg : lstBudgetLineCost){
            BLCost objwrap = new BLCost();
            objwrap.CostGrouping = String.valueof(objAgg.get('CostGrouping'));
            if(objAgg.get('CostP1') != null) objwrap.CostP1 = Integer.valueof(objAgg.get('CostP1'));
            else objwrap.CostP1 = 0;
            if(objAgg.get('CostP2') != null) objwrap.CostP2 = Integer.valueof(objAgg.get('CostP2'));
            else objwrap.CostP2 = 0;
            if(objAgg.get('CostP3') != null) objwrap.CostP3 = Integer.valueof(objAgg.get('CostP3'));
            else objwrap.CostP3 = 0;
            if(objAgg.get('CostP4') != null) objwrap.CostP4 = Integer.valueof(objAgg.get('CostP4'));
            else objwrap.CostP4= 0;
            if(objAgg.get('CostP5') != null) objwrap.CostP5 = Integer.valueof(objAgg.get('CostP5'));
            else objwrap.CostP5= 0;
            if(objAgg.get('CostP6') != null) objwrap.CostP4 = Integer.valueof(objAgg.get('CostP6'));
            else objwrap.CostP6= 0;
            if(objAgg.get('CostP7') != null) objwrap.CostP7 = Integer.valueof(objAgg.get('CostP7'));
            else objwrap.CostP7= 0;
            if(objAgg.get('CostP8') != null) objwrap.CostP8 = Integer.valueof(objAgg.get('CostP8'));
            else objwrap.CostP8= 0;
            
            
        if(TotalP1Cost == null) TotalP1Cost = objwrap.CostP1;
            else TotalP1Cost += objwrap.CostP1;
            if(TotalP2Cost == null) TotalP2Cost = objwrap.CostP2;
            else TotalP2Cost += objwrap.CostP2;
            if(TotalP3Cost == null) TotalP3Cost = objwrap.CostP3;
            else TotalP3Cost += objwrap.CostP3;
            if(TotalP4Cost == null) TotalP4Cost = objwrap.CostP4;
            else TotalP4Cost += objwrap.CostP4;
            if(TotalP5Cost == null) TotalP5Cost = objwrap.CostP5;
            else TotalP5Cost += objwrap.CostP5;
            if(TotalP6Cost == null) TotalP5Cost = objwrap.CostP6;
            else TotalP6Cost += objwrap.CostP6;
            if(TotalP7Cost == null) TotalP7Cost = objwrap.CostP7;
            else TotalP7Cost += objwrap.CostP7;
            if(TotalP8Cost == null) TotalP8Cost = objwrap.CostP8;
            else TotalP8Cost += objwrap.CostP8;
            if(AllYearTotalCost == null) AllYearTotalCost = objwrap.TotalCost;
            else AllYearTotalCost += objwrap.TotalCost;
            lstBLCost.add(objwrap);    
        }
        
///Get the period-level budget data grouped by payee
        List<AggregateResult> lstBudgetLinePayee = [Select Payee__r.Implementer_Name__c PayeeName,Sum(P1_Amount__c) PayeeP1,Sum(P2_Amount__c) PayeeP2,Sum(P3_Amount__c) PayeeP3,Sum(P4_Amount__c) PayeeP4,Sum(P5_Amount__c) PayeeP5,Sum(P6_Amount__c) PayeeP6,Sum(P7_Amount__c) PayeeP7,Sum(P8_Amount__c) PayeeP8 FROM Budget_Line__c where Payee__c != null AND Grant_Intervention__r.Module__r.Implementation_Period__c =: strGIPId GROUP BY Payee__r.Implementer_Name__c ];

        lstBLPayee = new List<BLPayee>();
        for(AggregateResult objAgg : lstBudgetLinePayee){
            BLPayee objwrap = new BLPayee();
            objwrap.PayeeName = String.valueof(objAgg.get('PayeeName'));
            if(objAgg.get('PayeeP1') != null) objwrap.PayeeCostP1 = Integer.valueof(objAgg.get('PayeeP1'));
            else objwrap.PayeeCostP1 = 0;
            if(objAgg.get('PayeeP2') != null) objwrap.PayeeCostP2 = Integer.valueof(objAgg.get('PayeeP2'));
            else objwrap.PayeeCostP2 = 0;
            if(objAgg.get('PayeeP3') != null) objwrap.PayeeCostP3 = Integer.valueof(objAgg.get('PayeeP3'));
            else objwrap.PayeeCostP3 = 0;
            if(objAgg.get('PayeeP4') != null) objwrap.PayeeCostP4 = Integer.valueof(objAgg.get('PayeeP4'));
            else objwrap.PayeeCostP4= 0;
            if(objAgg.get('PayeeP5') != null) objwrap.PayeeCostP5 = Integer.valueof(objAgg.get('PayeeP5'));
            else objwrap.PayeeCostP5 = 0;
            if(objAgg.get('PayeeP6') != null) objwrap.PayeeCostP6 = Integer.valueof(objAgg.get('PayeeP6'));
            else objwrap.PayeeCostP6 = 0;
            if(objAgg.get('PayeeP7') != null) objwrap.PayeeCostP7 = Integer.valueof(objAgg.get('PayeeP7'));
            else objwrap.PayeeCostP7 = 0;
            if(objAgg.get('PayeeP8') != null) objwrap.PayeeCostP8 = Integer.valueof(objAgg.get('PayeeP8'));
            else objwrap.PayeeCostP8= 0;
            
            
            if(TotalPayeeP1Cost == null) TotalPayeeP1Cost = objwrap.PayeeCostP1;
            else TotalPayeeP1Cost += objwrap.PayeeCostP1;
            if(TotalPayeeP2Cost == null) TotalPayeeP2Cost = objwrap.PayeeCostP2;
            else TotalPayeeP2Cost += objwrap.PayeeCostP2;
            if(TotalPayeeP3Cost == null) TotalPayeeP3Cost = objwrap.PayeeCostP3;
            else TotalPayeeP3Cost += objwrap.PayeeCostP3;
            if(TotalPayeeP4Cost == null) TotalPayeeP4Cost = objwrap.PayeeCostP4;
            else TotalPayeeP4Cost += objwrap.PayeeCostP4;
            if(AllYearPayeeTotalCost == null) AllYearPayeeTotalCost = objwrap.TotalPayeeCost;
            else AllYearPayeeTotalCost += objwrap.TotalPayeeCost;
            lstBLPayee.add(objwrap);
        }
        }
        
    }
    
    global Class BLCost{
        Public Integer CostP1 {get;set;}
        Public Integer CostP2 {get;set;}
        Public Integer CostP3 {get;set;}
        Public Integer CostP4 {get;set;}
        Public Integer CostP5 {get;set;}
        Public Integer CostP6 {get;set;}
        Public Integer CostP7 {get;set;}
        Public Integer CostP8 {get;set;}
        Public Integer TotalCost {get;set;}
        Public String CostGrouping {get;set;}
    }
    global Class BLPayee{
        Public Integer PayeeCostP1 {get;set;}
        Public Integer PayeeCostP2 {get;set;}
        Public Integer PayeeCostP3 {get;set;}
        Public Integer PayeeCostP4 {get;set;}
        Public Integer PayeeCostP5 {get;set;}
        Public Integer PayeeCostP6 {get;set;}
        Public Integer PayeeCostP7 {get;set;}
        Public Integer PayeeCostP8 {get;set;}
        Public Integer TotalPayeeCost {get;set;}
        Public String PayeeName {get;set;}
    }
    
    Public Class WrapModule{
        Public Module__c objModule {get;set;}
        Public List<WrapIndicator> lstIndicator {get;set;}
        Public List<WrapIntervention> lstIntervention {get;set;}
    }
    Public Class WrapIndicator{
        Public Grant_Indicator__c objIndicator {get;set;}
        Public List<WrapPeriodResults> lstPeriodResultsIndicator {get;set;}
    }
    Public Class WrapIntervention{
        Public Grant_Intervention__c objIntervention {get;set;}
        Public List<WrapIndicator> lstIndicatorInt {get;set;}
        //Public List<WrapPeriodResults> lstPeriodResultsIntervention {get;set;}
    }
    Public Class WrapPeriodResults{
        Public Period__c objPeriod{get;set;}
        Public Result__c objResult{get;set;}
    }
}