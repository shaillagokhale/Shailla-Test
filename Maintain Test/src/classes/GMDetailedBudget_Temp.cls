Public Class GMDetailedBudget_Temp{
    Public String strSelectedYear {get;set;}
    Public String strModuleId {get;set;}
    Public List<SelectOption> GrantInterventionOptions {get;set;}
    Public List<SelectOption> CostInputOptions {get;set;}
    Public List<SelectOption> ImplementersOptions {get;set;}
    Public List<wrapBudgetLines> lstBudgetLines {get;set;}
    //Public wrapBudgetLines objBudgetLineNewRow {get;set;}
    Public Budget_Line__c objBudgetLineNewRow {get;set;}
    Public wrapBudgetLines objBudgetLineNew {get;set;}
    Public Map<Id,String> MapCostInput;
    Public List<Page__c> lstPageTodisplay {get;set;}
    Public String strImplementationPeriodId {get;set;}
    Public Map<Id,wrapBudgetLines> mapBLIdToWrap;
    Public String strComponent {get;set;}
    Public String strLengthYears {get;set;}
    Public List<SelectOption> AllIPCurrencyOptions {get;set;}
    Public Integer intIndex{get;set;}
    Public Boolean blnHasChild {get;set;}
    Public Boolean blnHasNoChild {get;set;}
    Public wrapAssumption objNewAssumption {get;set;}
    
    
    public GMDetailedBudget_Temp(ApexPages.StandardController controller) {
        strModuleId = Apexpages.currentpage().getparameters().get('Id');
        if(String.IsBlank(strModuleId) == false){
            strLengthYears = null;
            intIndex = null;
            blnHasChild = false;
            blnHasNoChild  = false;
            List<Module__c> lstModuleTemp = [Select Implementation_Period__c,Implementation_Period__r.Component__c,
                                            Implementation_Period__r.Length_Years__c,
                                            Implementation_Period__r.Local_Currency__c,
                                            Implementation_Period__r.Currency_of_Grant_Agreement__c,
                                            Implementation_Period__r.Other_Currency__c
                                            From Module__c 
                                            Where id =: strModuleId And Implementation_Period__c != null];
            
            lstPageTodisplay = new List<Page__c>();
            if(lstModuleTemp.size() > 0){
                AllIPCurrencyOptions = new List<SelectOption>();
                AllIPCurrencyOptions.add(new SelectOption('','--None--'));
                if(lstModuleTemp[0].Implementation_Period__r.Local_Currency__c != null){
                    AllIPCurrencyOptions.add(new SelectOption('Local Currency',lstModuleTemp[0].Implementation_Period__r.Local_Currency__c));
                }
                if(lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c != null){
                    AllIPCurrencyOptions.add(new SelectOption('Grant Currency',lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c));
                }
                if(lstModuleTemp[0].Implementation_Period__r.Other_Currency__c != null){
                    AllIPCurrencyOptions.add(new SelectOption('Other Currency',lstModuleTemp[0].Implementation_Period__r.Other_Currency__c));
                }
                strImplementationPeriodId = lstModuleTemp[0].Implementation_Period__c;
                strComponent = lstModuleTemp[0].Implementation_Period__r.Component__c;
                strLengthYears = lstModuleTemp[0].Implementation_Period__r.Length_Years__c;
                lstPageTodisplay = [Select Id,Name,URL_Prefix__c,Order__c,Implementation_Period__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId  Order by Order__c];
            }
            
            strSelectedYear = 'Year1';
            List<Grant_Intervention__c> lstGrantIntervention = new List<Grant_Intervention__c>();
            lstGrantIntervention = [Select id,Name,(
                                                Select Q1_Quantity__c,Q1_Amount__c,Q2_Quantity__c,Q2_Amount__c,
                                                Q3_Quantity__c,Q3_Amount__c,Q4_Quantity__c,Q4_Amount__c,
                                                Q5_Quantity__c,Q5_Amount__c,Q6_Quantity__c,Q6_Amount__c,
                                                Q7_Quantity__c,Q7_Amount__c,Q8_Quantity__c,Q8_Amount__c,
                                                Q9_Quantity__c,Q9_Amount__c,Q10_Quantity__c,Q10_Amount__c,
                                                Q11_Quantity__c,Q11_Amount__c,Q12_Quantity__c,Q12_Amount__c,
                                                Q13_Quantity__c,Q13_Amount__c,Q14_Quantity__c,Q14_Amount__c,
                                                Q15_Quantity__c,Q15_Amount__c,Q16_Quantity__c,Q16_Amount__c,
                                                Activity__c,Cost_Input__c,Currency_Used__c,Grant_Intervention__c,
                                                Y1_Grant_Amount__c,Y2_Grant_Amount__c,Y3_Grant_Amount__c,
                                                Unit_Cost_Y1__c,Unit_Cost_Y2__c,Unit_Cost_Y3__c,Unit_Cost_Y4__c,
                                                Cost_Input__r.Unit_Cost_Definition__c,Cost_Input__r.Cost_Grouping__c,
                                                Payee__c,Payee__r.Name, Cost_Input__r.Name,Currency_Code__c,
                                                PR_Comments__c,LFA_Comments__c ,TGF_Comments__c,                                             
                                                Y4_Grant_Amount__c,Grant_Intervention__r.Name From Budget_Lines__r
                                            )
                                        From Grant_Intervention__c 
                                        Where Module__c != null And Module__c =: strModuleId];
            
            Set<Id> setBudgetLines = new Set<Id>();                            
            for(Grant_Intervention__c objGI : lstGrantIntervention){
                if(objGI.Budget_Lines__r.size() > 0){
                    for(Budget_Line__c objBL : objGI.Budget_Lines__r){
                        setBudgetLines.add(objBL.Id);
                    }
                }
            }                            
            Map<Id,Budget_line__c> mapIdToBudgetLine = new Map<Id,Budget_Line__c>(
                                                    [Select Id,(Select Assumptions_to_Support_Unit_Cost__c,Y1_Duration_Days__c, 
                                                    Item_Description__c,Justifications_Comments__c,Unit_of_Measure__c,
                                                    Y1_Quantity__c, Y1_Unit_Cost_Payment_Currency__c,Payment_Currency__c, Cost_Input__r.Cost_Grouping__c 
                                                    From Assumptions__r) From Budget_line__c Where Id IN : setBudgetLines]);
            
            
            lstBudgetLines = new List<wrapBudgetLines>();
            wrapBudgetLines objWrap;
            objNewAssumption = new wrapAssumption();
            objNewAssumption.objAssumption = new Assumption__c();
            GrantInterventionOptions = new List<SelectOption>();
            GrantInterventionOptions.add(new SelectOption('','--None--'));
            for(Grant_Intervention__c objGI : lstGrantIntervention){
                if(objGI.Budget_Lines__r.size() > 0){
                    for(Budget_Line__c objBL : objGI.Budget_Lines__r){
                        //objWrap = new wrapBudgetLines();
                        //objWrap = fillwraperObject(objBL);
                        
                        objWrap = new wrapBudgetLines();
                        if(mapIdToBudgetLine.size() > 0 && mapIdToBudgetLine.get(objBL.Id) != null && mapIdToBudgetLine.get(objBL.Id).Assumptions__r.size() > 0){
                            objWrap.lstAssumptions = new List<wrapAssumption>();
                            for(Assumption__c objAssumption : mapIdToBudgetLine.get(objBL.Id).Assumptions__r){
                                 wrapAssumption objwrapA = new wrapAssumption();
                                 objwrapA.objAssumption = new Assumption__c();
                                 objwrapA.objAssumption = objAssumption;
                                 objwrapA.strCurrencyUsedAssumption = objAssumption.Payment_Currency__c;
                                 if(objAssumption.Y1_Unit_Cost_Payment_Currency__c == null) objAssumption.Y1_Unit_Cost_Payment_Currency__c = 0;
                                 if(objAssumption.Y1_Quantity__c == null) objAssumption.Y1_Quantity__c = 0;
                                 objwrapA.TotalCostY1 = integer.valueof(objAssumption.Y1_Unit_Cost_Payment_Currency__c * objAssumption.Y1_Quantity__c);
                                 if(objWrap.TotalOfAllY1Cost == null) objWrap.TotalOfAllY1Cost = objwrapA.TotalCostY1;
                                 else objWrap.TotalOfAllY1Cost += objwrapA.TotalCostY1;
                                 objWrap.lstAssumptions.add(objWrapA);
                            }
                        }
                        objWrap.objBudgetLine = new Budget_Line__c();
                        objWrap.objBudgetLine = objBL;
                        objWrap.blnIsEditable = true;
                        objWrap.strUnitCostMeasure = objBL.Cost_Input__r.Unit_Cost_Definition__c;
                        objWrap.strGIName = objBL.Grant_Intervention__r.Name;
                        objWrap.strCostInputName = objBL.Cost_Input__r.Name;
                        objWrap.strCostGrouping = objBL.Cost_Input__r.Cost_Grouping__c;
                        objWrap.strPayeeName = objBL.Payee__r.Name;
                        objWrap.strCurrencyUsed = objBL.Currency_Code__c;
                        
                        if(objBL.Unit_Cost_Y1__c == null) objBL.Unit_Cost_Y1__c = 0;
                        if(objBL.Unit_Cost_Y2__c == null) objBL.Unit_Cost_Y2__c = 0;
                        if(objBL.Unit_Cost_Y3__c == null) objBL.Unit_Cost_Y3__c = 0;
                        if(objBL.Unit_Cost_Y4__c == null) objBL.Unit_Cost_Y4__c = 0;
                        
                        if(objBL.Q1_Quantity__c == null) objBL.Q1_Quantity__c = 0;
                        if(objBL.Q2_Quantity__c == null) objBL.Q2_Quantity__c = 0;
                        if(objBL.Q3_Quantity__c == null) objBL.Q3_Quantity__c = 0;
                        if(objBL.Q4_Quantity__c == null) objBL.Q4_Quantity__c = 0;
                        if(objBL.Q5_Quantity__c == null) objBL.Q5_Quantity__c = 0;
                        if(objBL.Q6_Quantity__c == null) objBL.Q6_Quantity__c = 0;
                        if(objBL.Q7_Quantity__c == null) objBL.Q7_Quantity__c = 0;
                        if(objBL.Q8_Quantity__c == null) objBL.Q8_Quantity__c = 0;
                        if(objBL.Q9_Quantity__c == null) objBL.Q9_Quantity__c = 0;
                        if(objBL.Q10_Quantity__c == null) objBL.Q10_Quantity__c = 0;
                        if(objBL.Q11_Quantity__c == null) objBL.Q11_Quantity__c = 0;
                        if(objBL.Q12_Quantity__c == null) objBL.Q12_Quantity__c = 0;
                        if(objBL.Q13_Quantity__c == null) objBL.Q13_Quantity__c = 0;
                        if(objBL.Q14_Quantity__c == null) objBL.Q14_Quantity__c = 0;
                        if(objBL.Q15_Quantity__c == null) objBL.Q15_Quantity__c = 0;
                        if(objBL.Q16_Quantity__c == null) objBL.Q16_Quantity__c = 0;
                        
                        if(objBL.Q1_Amount__c == null) objBL.Q1_Amount__c = 0;
                        if(objBL.Q2_Amount__c == null) objBL.Q2_Amount__c = 0;
                        if(objBL.Q3_Amount__c == null) objBL.Q3_Amount__c = 0;
                        if(objBL.Q4_Amount__c == null) objBL.Q4_Amount__c = 0;
                        if(objBL.Q5_Amount__c == null) objBL.Q5_Amount__c = 0;
                        if(objBL.Q6_Amount__c == null) objBL.Q6_Amount__c = 0;
                        if(objBL.Q7_Amount__c == null) objBL.Q7_Amount__c = 0;
                        if(objBL.Q8_Amount__c == null) objBL.Q8_Amount__c = 0;
                        if(objBL.Q9_Amount__c == null) objBL.Q9_Amount__c = 0;
                        if(objBL.Q10_Amount__c == null) objBL.Q10_Amount__c = 0;
                        if(objBL.Q11_Amount__c == null) objBL.Q11_Amount__c = 0;
                        if(objBL.Q12_Amount__c == null) objBL.Q12_Amount__c = 0;
                        if(objBL.Q13_Amount__c == null) objBL.Q13_Amount__c = 0;
                        if(objBL.Q14_Amount__c == null) objBL.Q14_Amount__c = 0;
                        if(objBL.Q15_Amount__c == null) objBL.Q15_Amount__c = 0;
                        if(objBL.Q16_Amount__c == null) objBL.Q16_Amount__c = 0;                        
                        
                        objWrap.Q1Case = integer.valueof(objBL.Q1_Amount__c);
                        objWrap.Q2Case = integer.valueof(objBL.Q2_Amount__c);
                        objWrap.Q3Case = integer.valueof(objBL.Q3_Amount__c);
                        objWrap.Q4Case = integer.valueof(objBL.Q4_Amount__c);
                        objWrap.Q5Case = integer.valueof(objBL.Q5_Amount__c);
                        objWrap.Q6Case = integer.valueof(objBL.Q6_Amount__c);
                        objWrap.Q7Case = integer.valueof(objBL.Q7_Amount__c);
                        objWrap.Q8Case = integer.valueof(objBL.Q8_Amount__c);
                        objWrap.Q9Case = integer.valueof(objBL.Q9_Amount__c);
                        objWrap.Q10Case = integer.valueof(objBL.Q10_Amount__c);
                        objWrap.Q11Case = integer.valueof(objBL.Q11_Amount__c);
                        objWrap.Q12Case = integer.valueof(objBL.Q12_Amount__c);
                        objWrap.Q13Case = integer.valueof(objBL.Q13_Amount__c);
                        objWrap.Q14Case = integer.valueof(objBL.Q14_Amount__c);
                        objWrap.Q15Case = integer.valueof(objBL.Q15_Amount__c);
                        objWrap.Q16Case = integer.valueof(objBL.Q16_Amount__c);
                       
                        
                        objWrap.TotalQuantityYear1 = objBL.Q1_Quantity__c + objBL.Q2_Quantity__c + objBL.Q3_Quantity__c + objBL.Q4_Quantity__c;
                        objWrap.TotalQuantityYear2 = objBL.Q5_Quantity__c + objBL.Q6_Quantity__c + objBL.Q7_Quantity__c + objBL.Q8_Quantity__c;
                        objWrap.TotalQuantityYear3 = objBL.Q9_Quantity__c + objBL.Q10_Quantity__c + objBL.Q11_Quantity__c + objBL.Q12_Quantity__c;
                        objWrap.TotalQuantityYear4 = objBL.Q13_Quantity__c + objBL.Q14_Quantity__c + objBL.Q15_Quantity__c + objBL.Q16_Quantity__c;
                        objWrap.TotalCaseYear1 = objWrap.Q1Case + objWrap.Q2Case + objWrap.Q3Case + objWrap.Q4Case;
                        objWrap.TotalCaseYear2 = objWrap.Q5Case + objWrap.Q6Case + objWrap.Q7Case + objWrap.Q8Case;
                        objWrap.TotalCaseYear3 = objWrap.Q9Case + objWrap.Q10Case + objWrap.Q11Case + objWrap.Q12Case;
                        objWrap.TotalCaseYear4 = objWrap.Q13Case + objWrap.Q14Case + objWrap.Q15Case + objWrap.Q16Case;
                        
                        objWrap.GrantTotalQuantity = objWrap.TotalQuantityYear1 + objWrap.TotalQuantityYear2 + objWrap.TotalQuantityYear3 + objWrap.TotalQuantityYear4;
                        objWrap.GrantTotalAmount = objWrap.TotalCaseYear1+ objWrap.TotalCaseYear2+ objWrap.TotalCaseYear3+ objWrap.TotalCaseYear4;
                        lstBudgetLines.add(objWrap);
                    }
                }
                GrantInterventionOptions.add(new SelectOption(objGI.Id,objGI.Name));
            }
            FillCostInput();
            FillImplementers();
            objBudgetLineNewRow = new Budget_Line__c();
            objBudgetLineNew = new wrapBudgetLines();
            mapBLIdToWrap = new map<Id,wrapBudgetLines>();
        }
    }
    
    Public void FillCostInput(){
        CostInputOptions = new List<SelectOption>();
        MapCostInput = new Map<Id,String>();
        List<Catalog_Cost_Input__c> lstCostInput = [Select Id,Name, Cost_Grouping__c, Unit_Cost_Definition__c 
                                            From Catalog_Cost_Input__c 
                                            Where PSM__c = false 
                                            AND Disease_Impact__c INCLUDES(:strComponent) 
                                            Order by Cost_Input_Number__c];
        CostInputOptions.add(new SelectOption('','--None--'));
        if(lstCostInput.size() > 0){
            for(Catalog_Cost_Input__c objCI : lstCostInput){
                CostInputOptions.add(new SelectOption(objCI.Id,objCI.Name));
                MapCostInput.put(objCI.Id,objCI.Unit_Cost_Definition__c);
            }
        }
    }
    
    Public void FillImplementers(){
        ImplementersOptions = new List<SelectOption>();
        ImplementersOptions.add(new SelectOption('','--None--'));
        List<Implementer__c> lstImplementer = [Select Id,Name From Implementer__c where Grant_Implementation_Period__c =: strImplementationPeriodId];
        if(lstImplementer.size() > 0){
            for(Implementer__c objImp : lstImplementer){
                ImplementersOptions.add(new SelectOption(objImp.Id,objImp.Name));
            }
        }
    }
    
        
    Public wrapBudgetLines fillwraperObject(Budget_Line__c objBL){
        wrapBudgetLines objWrap = new wrapBudgetLines();
        objWrap.objBudgetLine = new Budget_Line__c();
        objWrap.objBudgetLine = objBL;
        objWrap.blnIsEditable = true;
        objWrap.strUnitCostMeasure = objBL.Cost_Input__r.Unit_Cost_Definition__c;
        objWrap.strGIName = objBL.Grant_Intervention__r.Name;
        objWrap.strCostInputName = objBL.Cost_Input__r.Name;
        objWrap.strCostGrouping = objBL.Cost_Input__r.Cost_Grouping__c;
        objWrap.strPayeeName = objBL.Payee__r.Name;
        objWrap.strCurrencyUsed = objBL.Currency_Code__c;
        if(objBL.Unit_Cost_Y1__c == null) objBL.Unit_Cost_Y1__c = 0;
        if(objBL.Unit_Cost_Y2__c == null) objBL.Unit_Cost_Y2__c = 0;
        if(objBL.Unit_Cost_Y3__c == null) objBL.Unit_Cost_Y3__c = 0;
        if(objBL.Unit_Cost_Y4__c == null) objBL.Unit_Cost_Y4__c = 0;
        
        if(objBL.Q1_Quantity__c == null) objBL.Q1_Quantity__c = 0;
        if(objBL.Q2_Quantity__c == null) objBL.Q2_Quantity__c = 0;
        if(objBL.Q3_Quantity__c == null) objBL.Q3_Quantity__c = 0;
        if(objBL.Q4_Quantity__c == null) objBL.Q4_Quantity__c = 0;
        if(objBL.Q5_Quantity__c == null) objBL.Q5_Quantity__c = 0;
        if(objBL.Q6_Quantity__c == null) objBL.Q6_Quantity__c = 0;
        if(objBL.Q7_Quantity__c == null) objBL.Q7_Quantity__c = 0;
        if(objBL.Q8_Quantity__c == null) objBL.Q8_Quantity__c = 0;
        if(objBL.Q9_Quantity__c == null) objBL.Q9_Quantity__c = 0;
        if(objBL.Q10_Quantity__c == null) objBL.Q10_Quantity__c = 0;
        if(objBL.Q11_Quantity__c == null) objBL.Q11_Quantity__c = 0;
        if(objBL.Q12_Quantity__c == null) objBL.Q12_Quantity__c = 0;
        if(objBL.Q13_Quantity__c == null) objBL.Q13_Quantity__c = 0;
        if(objBL.Q14_Quantity__c == null) objBL.Q14_Quantity__c = 0;
        if(objBL.Q15_Quantity__c == null) objBL.Q15_Quantity__c = 0;
        if(objBL.Q16_Quantity__c == null) objBL.Q16_Quantity__c = 0;
        
        objWrap.Q1Case = integer.valueof(objBL.Unit_Cost_Y1__c * objBL.Q1_Quantity__c);
        objWrap.Q2Case = integer.valueof(objBL.Unit_Cost_Y1__c * objBL.Q2_Quantity__c);
        objWrap.Q3Case = integer.valueof(objBL.Unit_Cost_Y1__c * objBL.Q3_Quantity__c);
        objWrap.Q4Case = integer.valueof(objBL.Unit_Cost_Y1__c * objBL.Q4_Quantity__c);
        objWrap.Q5Case = integer.valueof(objBL.Unit_Cost_Y2__c * objBL.Q5_Quantity__c);
        objWrap.Q6Case = integer.valueof(objBL.Unit_Cost_Y2__c * objBL.Q6_Quantity__c);
        objWrap.Q7Case = integer.valueof(objBL.Unit_Cost_Y2__c * objBL.Q7_Quantity__c);
        objWrap.Q8Case = integer.valueof(objBL.Unit_Cost_Y2__c * objBL.Q8_Quantity__c);
        objWrap.Q9Case = integer.valueof(objBL.Unit_Cost_Y3__c * objBL.Q9_Quantity__c);
        objWrap.Q10Case =integer.valueof(objBL.Unit_Cost_Y3__c * objBL.Q10_Quantity__c);
        objWrap.Q11Case = integer.valueof(objBL.Unit_Cost_Y3__c * objBL.Q11_Quantity__c);
        objWrap.Q12Case = integer.valueof(objBL.Unit_Cost_Y3__c * objBL.Q12_Quantity__c);
        objWrap.Q13Case = integer.valueof(objBL.Unit_Cost_Y4__c * objBL.Q13_Quantity__c);
        objWrap.Q14Case = integer.valueof(objBL.Unit_Cost_Y4__c * objBL.Q14_Quantity__c);
        objWrap.Q15Case = integer.valueof(objBL.Unit_Cost_Y4__c * objBL.Q15_Quantity__c);
        objWrap.Q16Case = integer.valueof(objBL.Unit_Cost_Y4__c * objBL.Q16_Quantity__c);     
        
        objWrap.TotalQuantityYear1 = objBL.Q1_Quantity__c + objBL.Q2_Quantity__c + objBL.Q3_Quantity__c + objBL.Q4_Quantity__c;
        objWrap.TotalQuantityYear2 = objBL.Q5_Quantity__c + objBL.Q6_Quantity__c + objBL.Q7_Quantity__c + objBL.Q8_Quantity__c;
        objWrap.TotalQuantityYear3 = objBL.Q9_Quantity__c + objBL.Q10_Quantity__c + objBL.Q11_Quantity__c + objBL.Q12_Quantity__c;
        objWrap.TotalQuantityYear4 = objBL.Q13_Quantity__c + objBL.Q14_Quantity__c + objBL.Q15_Quantity__c + objBL.Q16_Quantity__c;
        objWrap.TotalCaseYear1 = objWrap.Q1Case + objWrap.Q2Case + objWrap.Q3Case + objWrap.Q4Case;
        objWrap.TotalCaseYear2 = objWrap.Q5Case + objWrap.Q6Case + objWrap.Q7Case + objWrap.Q8Case;
        objWrap.TotalCaseYear3 = objWrap.Q9Case + objWrap.Q10Case + objWrap.Q11Case + objWrap.Q12Case;
        objWrap.TotalCaseYear4 = objWrap.Q13Case + objWrap.Q14Case + objWrap.Q15Case + objWrap.Q16Case;
        objWrap.GrantTotalQuantity = objWrap.TotalQuantityYear1 + objWrap.TotalQuantityYear2 + objWrap.TotalQuantityYear3 + objWrap.TotalQuantityYear4;
        objWrap.GrantTotalAmount = objWrap.TotalCaseYear1+ objWrap.TotalCaseYear2+ objWrap.TotalCaseYear3+ objWrap.TotalCaseYear4;
        return objWrap;
    }
    
    Public Budget_Line__c retriveBudjetLine(String BudgetLineId){
        Budget_Line__c objBudgetLineRetrive = new Budget_Line__c();
        List<Budget_Line__c> lstBudgetLineRetrive = [Select Q1_Quantity__c,Q1_Amount__c,Q2_Quantity__c,Q2_Amount__c,
                                                    Q3_Quantity__c,Q3_Amount__c,Q4_Quantity__c,Q4_Amount__c,
                                                    Q5_Quantity__c,Q5_Amount__c,Q6_Quantity__c,Q6_Amount__c,
                                                    Q7_Quantity__c,Q7_Amount__c,Q8_Quantity__c,Q8_Amount__c,
                                                    Q9_Quantity__c,Q9_Amount__c,Q10_Quantity__c,Q10_Amount__c,
                                                    Q11_Quantity__c,Q11_Amount__c,Q12_Quantity__c,Q12_Amount__c,
                                                    Q13_Quantity__c,Q13_Amount__c,Q14_Quantity__c,Q14_Amount__c,
                                                    Q15_Quantity__c,Q15_Amount__c,Q16_Quantity__c,Q16_Amount__c,
                                                    Activity__c,Cost_Input__c, Currency_Code__c, Currency_Used__c,Grant_Intervention__c,
                                                    Y1_Grant_Amount__c,Y2_Grant_Amount__c,Y3_Grant_Amount__c,Unit_Cost_Y1__c,Unit_Cost_Y2__c,Unit_Cost_Y3__c,Unit_Cost_Y4__c,
                                                    Cost_Input__r.Unit_Cost_Definition__c, Cost_Input__r.Cost_Grouping__c, Payee__c,Payee__r.Name,
                                                    Cost_Input__r.Name,Y4_Grant_Amount__c,Grant_Intervention__r.Name
                                                    From Budget_Line__c Where Id =: BudgetLineId];
        if(lstBudgetLineRetrive.size() > 0){
            objBudgetLineRetrive = lstBudgetLineRetrive[0];
        }
        return objBudgetLineRetrive;
    }
    
    Public void SaveBudgetLines(){
        Integer SaveIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            if(SaveIndex > lstBudgetLines.size() && objBudgetLineNewRow != null){
                objBudgetLineNewRow.id = null;
                //objBudgetLineNewRow.Currency_Used__c = objBudgetLineNew.strCurrencyUsed;
                if(objBudgetLineNewRow.Unit_Cost_Y1__c == null) objBudgetLineNewRow.Unit_Cost_Y1__c = 0;
                if(objBudgetLineNewRow.Unit_Cost_Y2__c == null) objBudgetLineNewRow.Unit_Cost_Y2__c = 0;
                if(objBudgetLineNewRow.Unit_Cost_Y3__c == null) objBudgetLineNewRow.Unit_Cost_Y3__c = 0;
                if(objBudgetLineNewRow.Unit_Cost_Y4__c == null) objBudgetLineNewRow.Unit_Cost_Y4__c = 0;
                
                if(objBudgetLineNewRow.Q1_Quantity__c == null) objBudgetLineNewRow.Q1_Quantity__c = 0;
                if(objBudgetLineNewRow.Q2_Quantity__c == null) objBudgetLineNewRow.Q2_Quantity__c = 0;
                if(objBudgetLineNewRow.Q3_Quantity__c == null) objBudgetLineNewRow.Q3_Quantity__c = 0;
                if(objBudgetLineNewRow.Q4_Quantity__c == null) objBudgetLineNewRow.Q4_Quantity__c = 0;
                if(objBudgetLineNewRow.Q5_Quantity__c == null) objBudgetLineNewRow.Q5_Quantity__c = 0;
                if(objBudgetLineNewRow.Q6_Quantity__c == null) objBudgetLineNewRow.Q6_Quantity__c = 0;
                if(objBudgetLineNewRow.Q7_Quantity__c == null) objBudgetLineNewRow.Q7_Quantity__c = 0;
                if(objBudgetLineNewRow.Q8_Quantity__c == null) objBudgetLineNewRow.Q8_Quantity__c = 0;
                if(objBudgetLineNewRow.Q9_Quantity__c == null) objBudgetLineNewRow.Q9_Quantity__c = 0;
                if(objBudgetLineNewRow.Q10_Quantity__c == null) objBudgetLineNewRow.Q10_Quantity__c = 0;
                if(objBudgetLineNewRow.Q11_Quantity__c == null) objBudgetLineNewRow.Q11_Quantity__c = 0;
                if(objBudgetLineNewRow.Q12_Quantity__c == null) objBudgetLineNewRow.Q12_Quantity__c = 0;
                if(objBudgetLineNewRow.Q13_Quantity__c == null) objBudgetLineNewRow.Q13_Quantity__c = 0;
                if(objBudgetLineNewRow.Q14_Quantity__c == null) objBudgetLineNewRow.Q14_Quantity__c = 0;
                if(objBudgetLineNewRow.Q15_Quantity__c == null) objBudgetLineNewRow.Q15_Quantity__c = 0;
                if(objBudgetLineNewRow.Q16_Quantity__c == null) objBudgetLineNewRow.Q16_Quantity__c = 0;
                
                objBudgetLineNewRow.Q1_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y1__c * objBudgetLineNewRow.Q1_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q2_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y1__c * objBudgetLineNewRow.Q2_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q3_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y1__c * objBudgetLineNewRow.Q3_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q4_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y1__c * objBudgetLineNewRow.Q4_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q5_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y2__c * objBudgetLineNewRow.Q5_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q6_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y2__c * objBudgetLineNewRow.Q6_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q7_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y2__c * objBudgetLineNewRow.Q7_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q8_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y2__c * objBudgetLineNewRow.Q8_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q9_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y3__c * objBudgetLineNewRow.Q9_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q10_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y3__c * objBudgetLineNewRow.Q10_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q11_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y3__c * objBudgetLineNewRow.Q11_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q12_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y3__c * objBudgetLineNewRow.Q12_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q13_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y4__c * objBudgetLineNewRow.Q13_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q14_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y4__c * objBudgetLineNewRow.Q14_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q15_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y4__c * objBudgetLineNewRow.Q15_Quantity__c).setScale(2);
                objBudgetLineNewRow.Q16_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y4__c * objBudgetLineNewRow.Q16_Quantity__c).setScale(2);
                
                
                insert objBudgetLineNewRow;
                
                wrapBudgetLines objWrap = new wrapBudgetLines();
                Budget_Line__c objBudgetLineTemp = retriveBudjetLine(objBudgetLineNewRow.Id);
                objWrap = fillwraperObject(objBudgetLineTemp);
                //objWrap.strUnitCostMeasure = objBudgetLineNew.strUnitCostMeasure;
                lstBudgetLines.add(objWrap);
            }else{
                if(mapBLIdToWrap.ContainsKey(lstBudgetLines[SaveIndex].objBudgetLine.id)){
                    mapBLIdToWrap.remove(lstBudgetLines[SaveIndex].objBudgetLine.id);
                }
                List<Budget_Line__c> lstBudgetLineToUpdate = new List<Budget_Line__c>();
                system.debug('%%$%$%$%'+lstBudgetLines[SaveIndex].strCurrencyUsed);
                //lstBudgetLines[SaveIndex].objBudgetLine.Currency_Used__c = lstBudgetLines[SaveIndex].strCurrencyUsed;                 
                
                lstBudgetLineToUpdate.add(lstBudgetLines[SaveIndex].objBudgetLine);
                system.debug('%%$%$%$%'+lstBudgetLineToUpdate);
                
                lstBudgetLines[SaveIndex].Q1Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q1_Quantity__c);
                lstBudgetLines[SaveIndex].Q2Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q2_Quantity__c);
                lstBudgetLines[SaveIndex].Q3Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q3_Quantity__c);
                lstBudgetLines[SaveIndex].Q4Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q4_Quantity__c);
                lstBudgetLines[SaveIndex].Q5Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q5_Quantity__c);
                lstBudgetLines[SaveIndex].Q6Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q6_Quantity__c);
                lstBudgetLines[SaveIndex].Q7Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q7_Quantity__c);
                lstBudgetLines[SaveIndex].Q8Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q8_Quantity__c);
                lstBudgetLines[SaveIndex].Q9Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q9_Quantity__c);
                lstBudgetLines[SaveIndex].Q10Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q10_Quantity__c);
                lstBudgetLines[SaveIndex].Q11Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q11_Quantity__c);
                lstBudgetLines[SaveIndex].Q12Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q12_Quantity__c);
                lstBudgetLines[SaveIndex].Q13Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q13_Quantity__c);
                lstBudgetLines[SaveIndex].Q14Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q14_Quantity__c);
                lstBudgetLines[SaveIndex].Q15Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q15_Quantity__c);
                lstBudgetLines[SaveIndex].Q16Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q16_Quantity__c); 
                
                lstBudgetLines[SaveIndex].objBudgetLine.Q1_Amount__c = lstBudgetLines[SaveIndex].Q1Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q2_Amount__c = lstBudgetLines[SaveIndex].Q2Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q3_Amount__c = lstBudgetLines[SaveIndex].Q3Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q4_Amount__c = lstBudgetLines[SaveIndex].Q4Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q5_Amount__c = lstBudgetLines[SaveIndex].Q5Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q6_Amount__c = lstBudgetLines[SaveIndex].Q6Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q7_Amount__c = lstBudgetLines[SaveIndex].Q7Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q8_Amount__c = lstBudgetLines[SaveIndex].Q8Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q9_Amount__c = lstBudgetLines[SaveIndex].Q9Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q10_Amount__c = lstBudgetLines[SaveIndex].Q10Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q11_Amount__c = lstBudgetLines[SaveIndex].Q11Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q12_Amount__c = lstBudgetLines[SaveIndex].Q12Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q13_Amount__c = lstBudgetLines[SaveIndex].Q13Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q14_Amount__c = lstBudgetLines[SaveIndex].Q14Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q15_Amount__c = lstBudgetLines[SaveIndex].Q15Case;
                lstBudgetLines[SaveIndex].objBudgetLine.Q16_Amount__c = lstBudgetLines[SaveIndex].Q16Case;
                                
                update lstBudgetLineToUpdate;                
                
                for(SelectOption SO:GrantInterventionOptions){
                    if(SO.getValue() == String.Valueof(lstBudgetLineToUpdate[0].Grant_Intervention__c)){
                        lstBudgetLines[SaveIndex].strGIName = SO.getLabel();
                    }
                }
                for(SelectOption SO:CostInputOptions){
                    if(SO.getValue() == String.Valueof(lstBudgetLineToUpdate[0].Cost_Input__c)){
                        lstBudgetLines[SaveIndex].strCostInputName = SO.getLabel();
                    }
                }
                for(SelectOption SO:ImplementersOptions){
                    if(SO.getValue() == String.Valueof(lstBudgetLineToUpdate[0].Payee__c)){
                        lstBudgetLines[SaveIndex].strPayeeName = SO.getLabel();
                    }
                }
                
                lstBudgetLines[SaveIndex].objBudgetLine = lstBudgetLineToUpdate[0];
                lstBudgetLines[SaveIndex].blnIsEditable = true;
                //lstBudgetLines[SaveIndex].strUnitCostMeasure = objWrap.objBudgetLine.Cost_Input__r.Unit_Cost_Definition__c;
                if(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c == null) lstBudgetLineToUpdate[0].Unit_Cost_Y1__c = 0;
                if(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c == null) lstBudgetLineToUpdate[0].Unit_Cost_Y2__c = 0;
                if(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c == null) lstBudgetLineToUpdate[0].Unit_Cost_Y3__c = 0;
                if(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c == null) lstBudgetLineToUpdate[0].Unit_Cost_Y4__c = 0;
                
                if(lstBudgetLineToUpdate[0].Q1_Quantity__c == null) lstBudgetLineToUpdate[0].Q1_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q2_Quantity__c == null) lstBudgetLineToUpdate[0].Q2_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q3_Quantity__c == null) lstBudgetLineToUpdate[0].Q3_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q4_Quantity__c == null) lstBudgetLineToUpdate[0].Q4_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q5_Quantity__c == null) lstBudgetLineToUpdate[0].Q5_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q6_Quantity__c == null) lstBudgetLineToUpdate[0].Q6_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q7_Quantity__c == null) lstBudgetLineToUpdate[0].Q7_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q8_Quantity__c == null) lstBudgetLineToUpdate[0].Q8_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q9_Quantity__c == null) lstBudgetLineToUpdate[0].Q9_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q10_Quantity__c == null) lstBudgetLineToUpdate[0].Q10_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q11_Quantity__c == null) lstBudgetLineToUpdate[0].Q11_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q12_Quantity__c == null) lstBudgetLineToUpdate[0].Q12_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q13_Quantity__c == null) lstBudgetLineToUpdate[0].Q13_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q14_Quantity__c == null) lstBudgetLineToUpdate[0].Q14_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q15_Quantity__c == null) lstBudgetLineToUpdate[0].Q15_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].Q16_Quantity__c == null) lstBudgetLineToUpdate[0].Q16_Quantity__c = 0;
                
                lstBudgetLines[SaveIndex].TotalQuantityYear1 = lstBudgetLineToUpdate[0].Q1_Quantity__c + lstBudgetLineToUpdate[0].Q2_Quantity__c + lstBudgetLineToUpdate[0].Q3_Quantity__c + lstBudgetLineToUpdate[0].Q4_Quantity__c;
                lstBudgetLines[SaveIndex].TotalQuantityYear2 = lstBudgetLineToUpdate[0].Q5_Quantity__c + lstBudgetLineToUpdate[0].Q6_Quantity__c + lstBudgetLineToUpdate[0].Q7_Quantity__c + lstBudgetLineToUpdate[0].Q8_Quantity__c;
                lstBudgetLines[SaveIndex].TotalQuantityYear3 = lstBudgetLineToUpdate[0].Q9_Quantity__c + lstBudgetLineToUpdate[0].Q10_Quantity__c + lstBudgetLineToUpdate[0].Q11_Quantity__c + lstBudgetLineToUpdate[0].Q12_Quantity__c;
                lstBudgetLines[SaveIndex].TotalQuantityYear4 = lstBudgetLineToUpdate[0].Q13_Quantity__c + lstBudgetLineToUpdate[0].Q14_Quantity__c + lstBudgetLineToUpdate[0].Q15_Quantity__c + lstBudgetLineToUpdate[0].Q16_Quantity__c;
                lstBudgetLines[SaveIndex].TotalCaseYear1 = lstBudgetLines[SaveIndex].Q1Case + lstBudgetLines[SaveIndex].Q2Case + lstBudgetLines[SaveIndex].Q3Case + lstBudgetLines[SaveIndex].Q4Case;
                lstBudgetLines[SaveIndex].TotalCaseYear2 = lstBudgetLines[SaveIndex].Q5Case + lstBudgetLines[SaveIndex].Q6Case + lstBudgetLines[SaveIndex].Q7Case + lstBudgetLines[SaveIndex].Q8Case;
                lstBudgetLines[SaveIndex].TotalCaseYear3 = lstBudgetLines[SaveIndex].Q9Case + lstBudgetLines[SaveIndex].Q10Case + lstBudgetLines[SaveIndex].Q11Case + lstBudgetLines[SaveIndex].Q12Case;
                lstBudgetLines[SaveIndex].TotalCaseYear4 = lstBudgetLines[SaveIndex].Q13Case + lstBudgetLines[SaveIndex].Q14Case + lstBudgetLines[SaveIndex].Q15Case + lstBudgetLines[SaveIndex].Q16Case;
                lstBudgetLines[SaveIndex].GrantTotalQuantity = lstBudgetLines[SaveIndex].TotalQuantityYear1 + lstBudgetLines[SaveIndex].TotalQuantityYear2 + lstBudgetLines[SaveIndex].TotalQuantityYear3 + lstBudgetLines[SaveIndex].TotalQuantityYear4;
                lstBudgetLines[SaveIndex].GrantTotalAmount = lstBudgetLines[SaveIndex].TotalCaseYear1+ lstBudgetLines[SaveIndex].TotalCaseYear2+ lstBudgetLines[SaveIndex].TotalCaseYear3+ lstBudgetLines[SaveIndex].TotalCaseYear4;
                //system.debug('$$lstBudgetLineToUpdate$$$'+lstBudgetLineToUpdate[0]);
                //Budget_Line__c objBudgetLineTemp = retriveBudjetLine(lstBudgetLineToUpdate[0].Id);
                //system.debug('$$objBudgetLineTemp$$$'+objBudgetLineTemp);
                //lstBudgetLines[SaveIndex] = fillwraperObject(objBudgetLineTemp);
                //system.debug('$$objBudgetLineTemp$$$'+lstBudgetLines[SaveIndex]);*/
                lstBudgetLines[SaveIndex].blnIsEditable = true;
            }
        }
    }
    
    Public void EditBudgetLine(){
        Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            lstBudgetLines[EditIndex].blnIsEditable = false;
            wrapBudgetLines objwrapBudgetLineTemp = new wrapBudgetLines();
            objwrapBudgetLineTemp.objBudgetLine = new Budget_Line__c();
            objwrapBudgetLineTemp.objBudgetLine = lstBudgetLines[EditIndex].objBudgetLine.clone(true);        
            objwrapBudgetLineTemp.blnIsEditable = lstBudgetLines[EditIndex].blnIsEditable;
            objwrapBudgetLineTemp.strGIName = lstBudgetLines[EditIndex].strGIName;
            objwrapBudgetLineTemp.strCostInputName = lstBudgetLines[EditIndex].strCostInputName;
            objwrapBudgetLineTemp.strCostGrouping = lstBudgetLines[EditIndex].strCostGrouping;
            objwrapBudgetLineTemp.strPayeeName = lstBudgetLines[EditIndex].strPayeeName;
            objwrapBudgetLineTemp.strCurrencyUsed = lstBudgetLines[EditIndex].strCurrencyUsed;
            objwrapBudgetLineTemp.Q1Case = lstBudgetLines[EditIndex].Q1Case;
            objwrapBudgetLineTemp.Q2Case = lstBudgetLines[EditIndex].Q2Case;
            objwrapBudgetLineTemp.Q3Case = lstBudgetLines[EditIndex].Q3Case;
            objwrapBudgetLineTemp.Q4Case = lstBudgetLines[EditIndex].Q4Case;
            objwrapBudgetLineTemp.Q5Case = lstBudgetLines[EditIndex].Q5Case;
            objwrapBudgetLineTemp.Q6Case = lstBudgetLines[EditIndex].Q6Case;
            objwrapBudgetLineTemp.Q7Case = lstBudgetLines[EditIndex].Q7Case;
            objwrapBudgetLineTemp.Q8Case = lstBudgetLines[EditIndex].Q8Case;
            objwrapBudgetLineTemp.Q9case = lstBudgetLines[EditIndex].Q9Case;
            objwrapBudgetLineTemp.Q10Case = lstBudgetLines[EditIndex].Q10Case;
            objwrapBudgetLineTemp.Q11Case = lstBudgetLines[EditIndex].Q11Case;
            objwrapBudgetLineTemp.Q12Case = lstBudgetLines[EditIndex].Q12Case;
            objwrapBudgetLineTemp.Q13Case = lstBudgetLines[EditIndex].Q13Case;
            objwrapBudgetLineTemp.Q14Case = lstBudgetLines[EditIndex].Q14Case;
            objwrapBudgetLineTemp.Q15Case = lstBudgetLines[EditIndex].Q15Case;
            objwrapBudgetLineTemp.Q16Case = lstBudgetLines[EditIndex].Q16Case;
            objwrapBudgetLineTemp.TotalQuantityYear1 = lstBudgetLines[EditIndex].TotalQuantityYear1;
            objwrapBudgetLineTemp.TotalQuantityYear2 = lstBudgetLines[EditIndex].TotalQuantityYear2;
            objwrapBudgetLineTemp.TotalQuantityYear3 = lstBudgetLines[EditIndex].TotalQuantityYear3;
            objwrapBudgetLineTemp.TotalQuantityYear4 = lstBudgetLines[EditIndex].TotalQuantityYear4;
            objwrapBudgetLineTemp.TotalCaseYear1 = lstBudgetLines[EditIndex].TotalCaseYear1;
            objwrapBudgetLineTemp.TotalCaseYear2 = lstBudgetLines[EditIndex].TotalCaseYear2;
            objwrapBudgetLineTemp.TotalCaseYear3 = lstBudgetLines[EditIndex].TotalCaseYear3;
            objwrapBudgetLineTemp.TotalCaseYear4 = lstBudgetLines[EditIndex].TotalCaseYear4;
            objwrapBudgetLineTemp.GrantTotalQuantity = lstBudgetLines[EditIndex].GrantTotalQuantity;
            objwrapBudgetLineTemp.GrantTotalAmount = lstBudgetLines[EditIndex].GrantTotalAmount;
            mapBLIdToWrap.put(objwrapBudgetLineTemp.objBudgetLine.id,objwrapBudgetLineTemp);        
        }
    }
        
    Public void CancelBudgetLine(){
        Integer CancelIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            String BudgetLineid = lstBudgetLines[CancelIndex].objBudgetLine.id;
            lstBudgetLines[CancelIndex] = mapBLIdToWrap.get(BudgetLineid);
            lstBudgetLines[CancelIndex].blnIsEditable = true;
        }
    }
    
    Public void SelectUnitMeasure(){
        Integer SelectIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SelectIndex'));
        if(SelectIndex != null){
            String CostInputid = lstBudgetLines[SelectIndex].objBudgetLine.Cost_Input__c;
            lstBudgetLines[SelectIndex].strUnitCostMeasure = MapCostInput.get(CostInputid);
        }
    }
    
    Public void SelectUnitMeasureNew(){
        String CostInputId = Apexpages.currentpage().getparameters().get('CostInputId');
        if(String.isBlank(CostInputId) == false){
            objBudgetLineNew.strUnitCostMeasure = MapCostInput.get(CostInputid);
        }
    }
        
    Public void DeleteBudgetLine(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(DeleteIndex != null){
            String strBudgetLineid = lstBudgetLines[DeleteIndex].objBudgetLine.Id;
            List<Budget_Line__c> lstBudgetLineToDelete = [Select Id From Budget_Line__c Where Id =: strBudgetLineid];
            if(lstBudgetLineToDelete.size() > 0){
                Delete lstBudgetLineToDelete;
            }
            lstBudgetLines.remove(DeleteIndex);
        }
    }
    
    
    Public void EditAssumptionRecords(){
        Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            lstBudgetLines[EditIndex].blnHasChild = true;
        }
        
    }
    Public void CancelAssumptionRecords(){
        Integer CancelIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            lstBudgetLines[CancelIndex].blnHasChild = false;
        }
    }
    
    Public void SaveAssumption(){
        if(intIndex != null){
            List<Assumption__c> lstAssumptionToUpdate = new List<Assumption__c>();
            for(wrapAssumption objWrap : lstBudgetLines[intIndex].lstAssumptions){
                lstAssumptionToUpdate.add(objWrap.objAssumption);
            }
            if(lstAssumptionToUpdate.size() > 0) Update lstAssumptionToUpdate;
            blnHasChild = false;
        }
    }
    Public void SaveAssumptionNew(){
        if(intIndex != null){
            objNewAssumption.objAssumption.Budget_Line_Number__c = lstBudgetLines[intIndex].objBudgetLine.Id;
            insert objNewAssumption.objAssumption;
            lstBudgetLines[intIndex].lstAssumptions.add(objNewAssumption);
            SaveAssumption();
        }
    }
    Public void OpenAssumptionNoRecords(){
        blnHasNoChild = true;
    }
    Public void SaveBLAssumptionNoRecords(){
        Integer SaveBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveBLIndex'));
        if(SaveBLIndex != null){
            update lstBudgetLines[SaveBLIndex].objBudgetLine;
            blnHasNoChild = false;
        }
    }
    Public void CancelBLAssumptionNoRecords(){
        blnHasNoChild = false;
    }
    Public Class wrapBudgetLines{
        Public Budget_Line__c objBudgetLine {get;set;}
        Public Boolean blnIsEditable{get;set;}
        Public String strUnitCostMeasure {get;set;}
        Public String strGIName {get;set;}
        Public String strCostInputName {get;set;}
        Public String strCostGrouping {get;set;}
        Public String strPayeeName {get;set;}
        Public String strCurrencyUsed {get;set;}
        Public Decimal GrantTotalQuantity {get;set;}
        Public Decimal GrantTotalAmount {get;set;}
        Public Decimal TotalOfAllY1Cost {get;set;}
        Public List<wrapAssumption> lstAssumptions {get;set;}
        Public Integer NumberOfPersons {get;set;}
        Public Boolean blnHasChild{get;set;}
        Public Decimal Q1Case {get;set;}
        Public Decimal Q2Case {get;set;}
        Public Decimal Q3Case {get;set;}
        Public Decimal Q4Case {get;set;}
        Public Decimal Q5Case {get;set;}
        Public Decimal Q6Case {get;set;}
        Public Decimal Q7Case {get;set;}
        Public Decimal Q8Case {get;set;}
        Public Decimal Q9Case {get;set;}
        Public Decimal Q10Case {get;set;}
        Public Decimal Q11Case {get;set;}
        Public Decimal Q12Case {get;set;}
        Public Decimal Q13Case {get;set;}
        Public Decimal Q14Case {get;set;}
        Public Decimal Q15Case {get;set;}
        Public Decimal Q16Case {get;set;}
        
        Public Decimal TotalQuantityYear1 {get;set;}
        Public Decimal TotalQuantityYear2 {get;set;}
        Public Decimal TotalQuantityYear3 {get;set;}
        Public Decimal TotalQuantityYear4 {get;set;}
        Public Decimal TotalCaseYear1 {get;set;}
        Public Decimal TotalCaseYear2 {get;set;}
        Public Decimal TotalCaseYear3 {get;set;}
        Public Decimal TotalCaseYear4 {get;set;}
    }
    Public Class wrapAssumption{
        Public Assumption__c objAssumption {get;set;}
        Public Decimal TotalCostY1 {get;set;}
        Public String strCurrencyUsedAssumption {get;set;}
    }
}