Public Class ctrlAssumptionSet{
    Public String strSelectedYear {get;set;}
    Public String strSelectedYearAssumption {get;set;}
    Public String strImplementationPeriodId {get;set;}
    Public String strModuleId {get;set;}
    Public List<SelectOption> GrantInterventionOptions {get;set;}
    Public List<SelectOption> CostInputOptions {get;set;}
    Public List<SelectOption> ImplementersOptions {get;set;}
    Public List<wrapAssumptionSet> lstwrapAssumptionSet {get;set;}
    Public List<wrapBudgetLines> lstBudgetLines {get;set;} 
    Public Assumption_set__c objAssumptionSetNewRow {get;set;}
    Public wrapAssumptionSet objAssumptionSetNew {get;set;}
    Public Map<Id,String> MapCostInput;
    Public List<Page__c> lstPageTodisplay {get;set;}
    Public Map<Id,wrapAssumptionSet> mapASIdToWrap;
    Public String strComponent {get;set;}
    Public String strLengthYears {get;set;}
    Public List<SelectOption> AssumptionSetsOptions {get;set;}
    Public List<SelectOption> AllIPCurrencyOptions {get;set;}
    Public List<Assumption_set__c> lstAssumptionSet {get;set;}
    Public String strAssumptionSet {get;set;}
    Public Integer intIndex{get;set;}
    Public Boolean blnHasChild {get;set;}
    Public Boolean blnHasNoChild {get;set;}
    Public wrapAssumption objNewAssumption {get;set;}
    Public Date GIPstartdate {get;set;}
    Public Map<String,Double> conversion_rates {get;set;}
    Public String strGrantCurrency  {get;set;}
    Public String strLocalCurrency {get;set;}
    Public String strOtherCurrency  {get;set;}
    Public Decimal strGrantCurrencyRate {get;set;}
    Public Decimal strLocalCurrencyRate {get;set;}
    Public Decimal strOtherCurrencyRate {get;set;}
    
    public ctrlAssumptionSet(ApexPages.StandardController controller) {
        strImplementationPeriodId = Apexpages.currentpage().getparameters().get('Id');
        
        /****Get the ID of Module****/
        strModuleId = Apexpages.currentpage().getparameters().get('module');
        /**************************/
        if(String.IsBlank(strImplementationPeriodId) == false){ 
            List<Implementation_Period__c> lstImpPeriodTemp = [Select Id,Local_Currency__c,Exchange_Rate__c,Component__c,
                            Other_Currency_Exchange_Rate__c,Currency_of_Grant_Agreement__c,Start_Date__c,Length_Years__c,
                            Other_Currency__c From Implementation_Period__c Where Id =: strImplementationPeriodId];
            
            conversion_rates = new Map<String,Double>();                 
            conversion_rates.put(lstImpPeriodTemp[0].Local_Currency__c,lstImpPeriodTemp[0].Exchange_Rate__c);                             
            conversion_rates.put(lstImpPeriodTemp[0].Other_Currency__c,lstImpPeriodTemp[0].Other_Currency_Exchange_Rate__c);
            strGrantCurrency = lstImpPeriodTemp[0].Currency_of_Grant_Agreement__c;
            strLocalCurrency = lstImpPeriodTemp[0].Local_Currency__c;
            strOtherCurrency = lstImpPeriodTemp[0].Other_Currency__c;
            strLocalCurrencyRate = conversion_rates.get(lstImpPeriodTemp[0].Local_Currency__c); 
            strGrantCurrencyRate = conversion_rates.get(lstImpPeriodTemp[0].Currency_of_Grant_Agreement__c); 
            strOtherCurrencyRate = conversion_rates.get(lstImpPeriodTemp[0].Other_Currency__c); 
            
            AllIPCurrencyOptions = new List<SelectOption>();
            AllIPCurrencyOptions.add(new SelectOption('','--None--'));
            if(lstImpPeriodTemp[0].Local_Currency__c != null){
                AllIPCurrencyOptions.add(new SelectOption('Local Currency',lstImpPeriodTemp[0].Local_Currency__c));
            }
            if(lstImpPeriodTemp[0].Currency_of_Grant_Agreement__c != null){
                AllIPCurrencyOptions.add(new SelectOption('Grant Currency',lstImpPeriodTemp[0].Currency_of_Grant_Agreement__c));
            }
            if(lstImpPeriodTemp[0].Other_Currency__c != null){
                AllIPCurrencyOptions.add(new SelectOption('Other Currency',lstImpPeriodTemp[0].Other_Currency__c));
            }
            
            strImplementationPeriodId = lstImpPeriodTemp[0].id;
            strComponent = lstImpPeriodTemp[0].Component__c;
            strLengthYears = lstImpPeriodTemp[0].Length_Years__c;
            GIPstartdate = lstImpPeriodTemp[0].Start_Date__c;
            lstPageTodisplay = [Select Id,Name,URL_Prefix__c,Order__c,Implementation_Period__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId  Order by Order__c];           
            
            strSelectedYear = 'Year1';
            strSelectedYearAssumption = 'Year1';
            List<Assumption_Set__c> lstAssumptionSet = new List<Assumption_Set__c>();
            lstAssumptionSet = [select id, Name,Cost_Input__c,Cost_Input__r.Name,
                                (                                               
                                Select Assumptions_to_Support_Unit_Cost__c,Y1_Duration_Days__c, 
                                Item_Description__c,Justifications_Comments__c,Unit_of_Measure__c,
                                Y1_Quantity__c, Y1_Unit_Cost_Payment_Currency__c,Payment_Currency__c, 
                                Y1_Net_Salary_Payment_Currency__c,
                                Y1_Total_Salary_Payment_Currency__c,Y1_Level_of_Effort__c,
                                Y1_Social_Security_Obligatory_Charges__c,Y1_Number_of_Persons__c,
                                Y2_Duration_Days__c,Y2_Quantity__c, Y2_Unit_Cost_Payment_Currency__c,Y2_Net_Salary_Payment_Currency__c,
                                Y2_Total_Salary_Payment_Currency__c,Y2_Level_of_Effort__c,
                                Y2_Social_Security_Obligatory_Charges__c,Y2_Number_of_Persons__c,
                                Y3_Duration_Days__c,Y3_Quantity__c, Y3_Unit_Cost_Payment_Currency__c,Y3_Net_Salary_Payment_Currency__c,
                                Y3_Total_Salary_Payment_Currency__c,Y3_Level_of_Effort__c,
                                Y3_Social_Security_Obligatory_Charges__c,Y3_Number_of_Persons__c,
                                Y4_Duration_Days__c,Y4_Quantity__c, Y4_Unit_Cost_Payment_Currency__c,Y4_Net_Salary_Payment_Currency__c,
                                Y4_Total_Salary_Payment_Currency__c,Y4_Level_of_Effort__c,
                                Y4_Social_Security_Obligatory_Charges__c,Y4_Number_of_Persons__c
                                From Assumptions__r),
                                (Select Id From Budget_Lines__r)
                                From Assumption_Set__c 
                                Where Implementation_Period__c =:  strImplementationPeriodId];                            
       
        Set<Id> setAssumptionSet = new Set<Id>();  
        setAssumptionSet.add(strImplementationPeriodId);
        lstwrapAssumptionSet = new List<wrapAssumptionSet>();          
        wrapAssumptionSet objWrap;
        objNewAssumption = new wrapAssumption();
        objNewAssumption.strCurrencyUsedAssumption = 'Grant Currency';
        objNewAssumption.objAssumption = new Assumption__c();
        GrantInterventionOptions = new List<SelectOption>();
        GrantInterventionOptions.add(new SelectOption('','--None--'));            
        
        for(Assumption_Set__c objAS : lstAssumptionSet){        
            objWrap = new wrapAssumptionSet();               
            objWrap.lstAssumptions = new List<wrapAssumption>();
            objWrap.strCostInputName = objAS.Cost_Input__r.Name;
            objWrap.NumberOfBudgetLine = 0;
            objWrap.NumberOfAssumption = 0;
        
            if(objAS.Budget_Lines__r.size() > 0){
                objWrap.NumberOfBudgetLine = objAS.Budget_Lines__r.size();
            }                  
            if(objAS.Assumptions__r.size() > 0){
                objWrap.NumberOfAssumption = objAS.Assumptions__r.size(); 
                for(Assumption__c objAssumption : objAS.Assumptions__r){
                    wrapAssumption objwrapA = new wrapAssumption();
                    objwrapA.objAssumption = new Assumption__c();
                    objwrapA.objAssumption = objAssumption;
                    objwrapA.strCurrencyUsedAssumption = objAssumption.Payment_Currency__c;
                                        
                    if(objAssumption.Y1_Unit_Cost_Payment_Currency__c == null) objAssumption.Y1_Unit_Cost_Payment_Currency__c = 0;
                    if(objAssumption.Y1_Quantity__c == null) objAssumption.Y1_Quantity__c = 0;
                    if(objAssumption.Y1_Net_Salary_Payment_Currency__c == null) objAssumption.Y1_Net_Salary_Payment_Currency__c = 0;
                    //if(objAssumption.Y1_Total_Salary_Payment_Currency__c == null) objAssumption.Y1_Total_Salary_Payment_Currency__c = 0;
                    if(objAssumption.Y1_Level_of_Effort__c == null) objAssumption.Y1_Level_of_Effort__c = 0;
                    if(objAssumption.Y1_Social_Security_Obligatory_Charges__c == null) objAssumption.Y1_Social_Security_Obligatory_Charges__c = 0;
                    if(objAssumption.Y1_Number_of_Persons__c == null) objAssumption.Y1_Number_of_Persons__c = 0;
                    if(objAssumption.Y1_Duration_Days__c == null) objAssumption.Y1_Duration_Days__c = 0;
                                                     
                    if(objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y1_Quantity__c!=null)
                    objwrapA.TotalCostY1 = integer.valueof(objAssumption.Y1_Unit_Cost_Payment_Currency__c * objAssumption.Y1_Quantity__c);
                    
                    if(objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y2_Quantity__c!=null)
                    objwrapA.TotalCostY2 = integer.valueof(objAssumption.Y2_Unit_Cost_Payment_Currency__c * objAssumption.Y2_Quantity__c);
                    
                    if(objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y3_Quantity__c!=null)
                    objwrapA.TotalCostY3 = integer.valueof(objAssumption.Y3_Unit_Cost_Payment_Currency__c * objAssumption.Y3_Quantity__c);
                    
                    if(objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y4_Quantity__c!=null)
                    objwrapA.TotalCostY4 = integer.valueof(objAssumption.Y4_Unit_Cost_Payment_Currency__c * objAssumption.Y4_Quantity__c);
                                     
                    Double conversionRate;
                    if(objAssumption.Payment_Currency__c == 'Local Currency'){
                        conversionRate = conversion_rates.get(strLocalCurrency);
                    }else if(objAssumption.Payment_Currency__c == 'Other Currency'){
                        conversionRate = conversion_rates.get(strOtherCurrency);
                    }
                    if(conversionRate != null){
                         if(objwrapA.TotalCostY1!=null){
                             objwrapA.CurrencyRateInUSDY1 = (objwrapA.TotalCostY1 * conversionRate).setscale(2);
                         }
                         if(objwrapA.TotalCostY2!=null){
                             objwrapA.CurrencyRateInUSDY2 = (objwrapA.TotalCostY2 * conversionRate).setscale(2);
                         }
                         if(objwrapA.TotalCostY3!=null){
                             objwrapA.CurrencyRateInUSDY3 = (objwrapA.TotalCostY3 * conversionRate).setscale(2);
                         }
                         if(objwrapA.TotalCostY4!=null){
                             objwrapA.CurrencyRateInUSDY4 = (objwrapA.TotalCostY4 * conversionRate).setscale(2);
                         }
                    }
                    if(objwrapA.CurrencyRateInUSDY1!=null){                      
                         if(objWrap.TotalOfAllY1Cost == null) objWrap.TotalOfAllY1Cost = objwrapA.CurrencyRateInUSDY1;
                         else objWrap.TotalOfAllY1Cost += objwrapA.CurrencyRateInUSDY1;
                     }else if(objwrapA.TotalCostY1!=null){
                         if(objWrap.TotalOfAllY1Cost == null) objWrap.TotalOfAllY1Cost = objwrapA.TotalCostY1;
                         else objWrap.TotalOfAllY1Cost += objwrapA.TotalCostY1;
                     }
                     if(objwrapA.CurrencyRateInUSDY2!=null){
                         if(objWrap.TotalOfAllY2Cost == null) objWrap.TotalOfAllY2Cost = objwrapA.CurrencyRateInUSDY2;
                         else objWrap.TotalOfAllY2Cost += objwrapA.CurrencyRateInUSDY2;
                     } else if(objwrapA.TotalCostY2!=null){
                         if(objWrap.TotalOfAllY2Cost == null) objWrap.TotalOfAllY2Cost = objwrapA.TotalCostY2;
                         else objWrap.TotalOfAllY2Cost += objwrapA.TotalCostY2;
                     }                                
                     if(objwrapA.CurrencyRateInUSDY3!=null){
                         if(objWrap.TotalOfAllY3Cost == null) objWrap.TotalOfAllY3Cost = objwrapA.CurrencyRateInUSDY3;
                         else objWrap.TotalOfAllY3Cost += objwrapA.CurrencyRateInUSDY3;
                     }else if(objwrapA.TotalCostY3!=null){
                         if(objWrap.TotalOfAllY3Cost == null) objWrap.TotalOfAllY3Cost = objwrapA.TotalCostY3;
                         else objWrap.TotalOfAllY3Cost += objwrapA.TotalCostY3;
                     }
                     if(objwrapA.CurrencyRateInUSDY4!=null){
                         if(objWrap.TotalOfAllY4Cost == null) objWrap.TotalOfAllY4Cost = objwrapA.CurrencyRateInUSDY4;
                         else objWrap.TotalOfAllY4Cost += objwrapA.CurrencyRateInUSDY4;
                     }else if(objwrapA.TotalCostY4!=null){
                         if(objWrap.TotalOfAllY4Cost == null) objWrap.TotalOfAllY4Cost = objwrapA.TotalCostY4;
                         else objWrap.TotalOfAllY4Cost += objwrapA.TotalCostY4;
                     }
                    objWrap.lstAssumptions.add(objWrapA);
                }
            }
            objWrap.objAssumptionSet = new Assumption_Set__c();
            objWrap.objAssumptionSet = objAS;
            objWrap.blnIsEditable = true;                       
            lstwrapAssumptionSet.add(objWrap);
        }        
        FillCostInput();
        objAssumptionSetNewRow = new Assumption_Set__c(Implementation_Period__c = strImplementationPeriodId);
        objAssumptionSetNew = new wrapAssumptionSet();
        mapASIdToWrap = new map<Id,wrapAssumptionSet>();                                 
        }
    }
    
    Public void RetriveAssumptionFromSet(){
        lstBudgetLines[intIndex].lstAssumptions = new List<wrapAssumption>();
        List<Assumption__c> lstAssumptionTemp = [Select Assumptions_to_Support_Unit_Cost__c,Y1_Duration_Days__c, 
                                                    Item_Description__c,Justifications_Comments__c,Unit_of_Measure__c,
                                                    Y1_Quantity__c, Y1_Unit_Cost_Payment_Currency__c,Payment_Currency__c, 
                                                    Y1_Net_Salary_Payment_Currency__c,
                                                    Y1_Total_Salary_Payment_Currency__c,Y1_Level_of_Effort__c,
                                                    Y1_Social_Security_Obligatory_Charges__c,Y1_Number_of_Persons__c,
                                                    Y2_Duration_Days__c,Y2_Quantity__c, Y2_Unit_Cost_Payment_Currency__c,Y2_Net_Salary_Payment_Currency__c,
                                                    Y2_Total_Salary_Payment_Currency__c,Y2_Level_of_Effort__c,
                                                    Y2_Social_Security_Obligatory_Charges__c,Y2_Number_of_Persons__c,
                                                    Y3_Duration_Days__c,Y3_Quantity__c, Y3_Unit_Cost_Payment_Currency__c,Y3_Net_Salary_Payment_Currency__c,
                                                    Y3_Total_Salary_Payment_Currency__c,Y3_Level_of_Effort__c,
                                                    Y3_Social_Security_Obligatory_Charges__c,Y3_Number_of_Persons__c,
                                                    Y4_Duration_Days__c,Y4_Quantity__c, Y4_Unit_Cost_Payment_Currency__c,Y4_Net_Salary_Payment_Currency__c,
                                                    Y4_Total_Salary_Payment_Currency__c,Y4_Level_of_Effort__c,
                                                    Y4_Social_Security_Obligatory_Charges__c,Y4_Number_of_Persons__c
                                                    From Assumption__c Where Assumption_Set__c =: strAssumptionSet];
                                                    
        for(Assumption__c objAssumption : lstAssumptionTemp){
             wrapAssumption objwrapA = new wrapAssumption();
             objwrapA.objAssumption = new Assumption__c();
             objwrapA.objAssumption = objAssumption;
             objwrapA.strCurrencyUsedAssumption = objAssumption.Payment_Currency__c;             
             
             if(objAssumption.Y1_Unit_Cost_Payment_Currency__c == null) objAssumption.Y1_Unit_Cost_Payment_Currency__c = 0;
             if(objAssumption.Y1_Quantity__c == null) objAssumption.Y1_Quantity__c = 0;
             if(objAssumption.Y1_Net_Salary_Payment_Currency__c == null) objAssumption.Y1_Net_Salary_Payment_Currency__c = 0;
             //if(objAssumption.Y1_Total_Salary_Payment_Currency__c == null) objAssumption.Y1_Total_Salary_Payment_Currency__c = 0;
             if(objAssumption.Y1_Level_of_Effort__c == null) objAssumption.Y1_Level_of_Effort__c = 0;
             if(objAssumption.Y1_Social_Security_Obligatory_Charges__c == null) objAssumption.Y1_Social_Security_Obligatory_Charges__c = 0;
             if(objAssumption.Y1_Number_of_Persons__c == null) objAssumption.Y1_Number_of_Persons__c = 0;
             if(objAssumption.Y1_Duration_Days__c == null) objAssumption.Y1_Duration_Days__c = 0;
             
             if(objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y1_Quantity__c!=null)
             objwrapA.TotalCostY1 = integer.valueof(objAssumption.Y1_Unit_Cost_Payment_Currency__c * objAssumption.Y1_Quantity__c);
             
             if(objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y2_Quantity__c!=null)
             objwrapA.TotalCostY2 = integer.valueof(objAssumption.Y2_Unit_Cost_Payment_Currency__c * objAssumption.Y2_Quantity__c);

             if(objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y3_Quantity__c!=null)
             objwrapA.TotalCostY3 = integer.valueof(objAssumption.Y3_Unit_Cost_Payment_Currency__c * objAssumption.Y3_Quantity__c);
             
             if(objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y4_Quantity__c!=null)
             objwrapA.TotalCostY4 = integer.valueof(objAssumption.Y4_Unit_Cost_Payment_Currency__c * objAssumption.Y4_Quantity__c);

             Double conversionRate;
             if(objAssumption.Payment_Currency__c == 'Local Currency'){
                 conversionRate = conversion_rates.get(strLocalCurrency);
             }else if(objAssumption.Payment_Currency__c == 'Other Currency'){
                 conversionRate = conversion_rates.get(strOtherCurrency);
             }
             if(conversionRate != null){
                 if(objwrapA.TotalCostY1!=null){
                     objwrapA.CurrencyRateInUSDY1 = (objwrapA.TotalCostY1 * conversionRate).setscale(2);
                 }
                 if(objwrapA.TotalCostY2!=null){
                     objwrapA.CurrencyRateInUSDY2 = (objwrapA.TotalCostY2 * conversionRate).setscale(2);
                 }
                 if(objwrapA.TotalCostY3!=null){
                     objwrapA.CurrencyRateInUSDY3 = (objwrapA.TotalCostY3 * conversionRate).setscale(2);
                 }
                 if(objwrapA.TotalCostY4!=null){
                     objwrapA.CurrencyRateInUSDY4 = (objwrapA.TotalCostY4 * conversionRate).setscale(2);
                 }
             }
             if(objwrapA.CurrencyRateInUSDY1!=null){                
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objwrapA.CurrencyRateInUSDY1;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objwrapA.CurrencyRateInUSDY1;
             }else if(objwrapA.TotalCostY1!=null){
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objwrapA.TotalCostY1;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objwrapA.TotalCostY1;
             }
             if(objwrapA.CurrencyRateInUSDY2!=null){
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objwrapA.CurrencyRateInUSDY2;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objwrapA.CurrencyRateInUSDY2;
             } else if(objwrapA.TotalCostY2!=null){
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objwrapA.TotalCostY2;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objwrapA.TotalCostY2;
             }                                
             if(objwrapA.CurrencyRateInUSDY3!=null){
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objwrapA.CurrencyRateInUSDY3;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objwrapA.CurrencyRateInUSDY3;
             }else if(objwrapA.TotalCostY3!=null){
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objwrapA.TotalCostY3;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objwrapA.TotalCostY3;
             }
             if(objwrapA.CurrencyRateInUSDY4!=null){
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objwrapA.CurrencyRateInUSDY4;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objwrapA.CurrencyRateInUSDY4;
             }else if(objwrapA.TotalCostY4!=null){
                 if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objwrapA.TotalCostY4;
                 else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objwrapA.TotalCostY4;
             }
             lstwrapAssumptionSet[intIndex].lstAssumptions.add(objWrapA);
        }                                                
    }
    
    Public void ChangeCurrencyRateFromCode(){
        String Code = Apexpages.currentpage().getparameters().get('Code');
        Integer ChangeIndex = integer.valueof(Apexpages.currentpage().getparameters().get('ChangeIndex'));
        if(Code != null && ChangeIndex != null && intIndex != null){ 
             if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Quantity__c!=null)
             lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY1 = integer.valueof(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Unit_Cost_Payment_Currency__c * lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Quantity__c);
             
             if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Quantity__c!=null)
             lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY2 = integer.valueof(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Unit_Cost_Payment_Currency__c * lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Quantity__c);
    
             if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Quantity__c!=null)
             lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY3 = integer.valueof(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Unit_Cost_Payment_Currency__c * lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Quantity__c);
             
             if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Quantity__c!=null)
             lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY4 = integer.valueof(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Unit_Cost_Payment_Currency__c * lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Quantity__c);
            
            Double conversionRate;           
            if(Code == 'Local Currency'){
                conversionRate = conversion_rates.get(strLocalCurrency);
            }else if(Code == 'Other Currency'){
                conversionRate = conversion_rates.get(strOtherCurrency);
            }
            
            if(conversionRate != null){  
                if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY1!=null){
                    lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY1 = (lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY1 * conversionRate).setscale(2);
                }             
                if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY2!=null){
                    lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY2 = (lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY2 * conversionRate).setscale(2);
                }
                if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY3!=null){
                    lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY3 = (lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY3 * conversionRate).setscale(2);
                }
                if(lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY4!=null){
                    lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY4 = (lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].TotalCostY4 * conversionRate).setscale(2);
                }
            }else{
                lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY1 = null;
                lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY2 = null;
                lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY3 = null;
                lstwrapAssumptionSet[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY4 = null;
            }
            lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = null;
            for(wrapAssumption objA: lstwrapAssumptionSet[intIndex].lstAssumptions){
                if(objA.objAssumption.Y1_Quantity__c == null) objA.objAssumption.Y1_Quantity__c = 0;
                if(objA.objAssumption.Y2_Quantity__c == null) objA.objAssumption.Y2_Quantity__c = 0;
                if(objA.objAssumption.Y3_Quantity__c == null) objA.objAssumption.Y3_Quantity__c = 0;
                if(objA.objAssumption.Y4_Quantity__c == null) objA.objAssumption.Y4_Quantity__c = 0;
                
                 if(objA.CurrencyRateInUSDY1!=null){                      
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objA.CurrencyRateInUSDY1;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objA.CurrencyRateInUSDY1;
                }else if(objA.TotalCostY1!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objA.TotalCostY1;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objA.TotalCostY1;
                }
                if(objA.CurrencyRateInUSDY2!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objA.CurrencyRateInUSDY2;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objA.CurrencyRateInUSDY2;
                } else if(objA.TotalCostY2!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objA.TotalCostY2;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objA.TotalCostY2;
                }                                
                if(objA.CurrencyRateInUSDY3!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objA.CurrencyRateInUSDY3;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objA.CurrencyRateInUSDY3;
                }else if(objA.TotalCostY3!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objA.TotalCostY3;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objA.TotalCostY3;
                }
                if(objA.CurrencyRateInUSDY4!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objA.CurrencyRateInUSDY4;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objA.CurrencyRateInUSDY4;
                }else if(objA.TotalCostY4!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objA.TotalCostY4;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objA.TotalCostY4;
                }
            }
        }
    } 
    
    Public void ChangeCurrencyRateFromCodeNew(){
        String Code = Apexpages.currentpage().getparameters().get('Code');
        
        if(Code != null && intIndex != null){       
            if(objNewAssumption.objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y1_Quantity__c!=null)
            objNewAssumption.TotalCostY1 = integer.valueof(objNewAssumption.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y1_Quantity__c);
             
            if(objNewAssumption.objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y2_Quantity__c!=null)
            objNewAssumption.TotalCostY2 = integer.valueof(objNewAssumption.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y2_Quantity__c);
            
            if(objNewAssumption.objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y3_Quantity__c!=null)
            objNewAssumption.TotalCostY3 = integer.valueof(objNewAssumption.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y3_Quantity__c);
             
            if(objNewAssumption.objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y4_Quantity__c!=null)
            objNewAssumption.TotalCostY4 = integer.valueof(objNewAssumption.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y4_Quantity__c);

            Double conversionRate;
            if(Code == 'Local Currency'){
                conversionRate = conversion_rates.get(strLocalCurrency);
            }else if(Code == 'Other Currency'){
                conversionRate = conversion_rates.get(strOtherCurrency);
            }
            if(conversionRate != null){          
                if(objNewAssumption.TotalCostY1!=null){
                    objNewAssumption.CurrencyRateInUSDY1 = (objNewAssumption.TotalCostY1 * conversionRate).setscale(2);
                }
                if(objNewAssumption.TotalCostY2!=null){
                    objNewAssumption.CurrencyRateInUSDY2 = (objNewAssumption.TotalCostY2 * conversionRate).setscale(2);
                }
                if(objNewAssumption.TotalCostY3!=null){
                    objNewAssumption.CurrencyRateInUSDY3 = (objNewAssumption.TotalCostY3 * conversionRate).setscale(2);
                }
                if(objNewAssumption.TotalCostY4!=null){
                    objNewAssumption.CurrencyRateInUSDY4 = (objNewAssumption.TotalCostY4 * conversionRate).setscale(2);
                }
            }else{
                objNewAssumption.CurrencyRateInUSDY1 = null;
                objNewAssumption.CurrencyRateInUSDY2 = null;
                objNewAssumption.CurrencyRateInUSDY3 = null;
                objNewAssumption.CurrencyRateInUSDY4 = null;
            }
            
            lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = null;
            
            if(lstwrapAssumptionSet[intIndex].lstAssumptions != null && lstwrapAssumptionSet[intIndex].lstAssumptions.size() > 0){
                for(wrapAssumption objA: lstwrapAssumptionSet[intIndex].lstAssumptions){
                    if(objA.CurrencyRateInUSDY1!=null){                       
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objA.CurrencyRateInUSDY1;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objA.CurrencyRateInUSDY1;
                    }else if(objA.TotalCostY1!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objA.TotalCostY1;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objA.TotalCostY1;
                    }
                    if(objA.CurrencyRateInUSDY2!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objA.CurrencyRateInUSDY2;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objA.CurrencyRateInUSDY2;
                    } else if(objA.TotalCostY2!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objA.TotalCostY2;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objA.TotalCostY2;
                    }                                
                    if(objA.CurrencyRateInUSDY3!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objA.CurrencyRateInUSDY3;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objA.CurrencyRateInUSDY3;
                    }else if(objA.TotalCostY3!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objA.TotalCostY3;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objA.TotalCostY3;
                    }
                    if(objA.CurrencyRateInUSDY4!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objA.CurrencyRateInUSDY4;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objA.CurrencyRateInUSDY4;
                    }else if(objA.TotalCostY4!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objA.TotalCostY4;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objA.TotalCostY4;
                    }
                }
            }
            if(objNewAssumption.objAssumption.Y1_Quantity__c == null) objNewAssumption.objAssumption.Y1_Quantity__c = 0;
            if(objNewAssumption.objAssumption.Y2_Quantity__c == null) objNewAssumption.objAssumption.Y2_Quantity__c = 0;
            if(objNewAssumption.objAssumption.Y3_Quantity__c == null) objNewAssumption.objAssumption.Y3_Quantity__c = 0;
            if(objNewAssumption.objAssumption.Y4_Quantity__c == null) objNewAssumption.objAssumption.Y4_Quantity__c = 0;   
              
            if(objNewAssumption.CurrencyRateInUSDY1!=null){                      
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objNewAssumption.CurrencyRateInUSDY1;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objNewAssumption.CurrencyRateInUSDY1;
            }else if(objNewAssumption.TotalCostY1!=null){
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objNewAssumption.TotalCostY1;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objNewAssumption.TotalCostY1;
            }
            if(objNewAssumption.CurrencyRateInUSDY2!=null){
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objNewAssumption.CurrencyRateInUSDY2;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objNewAssumption.CurrencyRateInUSDY2;
            } else if(objNewAssumption.TotalCostY2!=null){
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objNewAssumption.TotalCostY2;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objNewAssumption.TotalCostY2;
            }                                
            if(objNewAssumption.CurrencyRateInUSDY3!=null){
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objNewAssumption.CurrencyRateInUSDY3;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objNewAssumption.CurrencyRateInUSDY3;
            }else if(objNewAssumption.TotalCostY3!=null){
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objNewAssumption.TotalCostY3;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objNewAssumption.TotalCostY3;
            }
            if(objNewAssumption.CurrencyRateInUSDY4!=null){
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objNewAssumption.CurrencyRateInUSDY4;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objNewAssumption.CurrencyRateInUSDY4;
            }else if(objNewAssumption.TotalCostY4!=null){
                if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objNewAssumption.TotalCostY4;
                else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objNewAssumption.TotalCostY4;
            }
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
        List<Implementer__c> lstImplementer = [Select Id,Name, Implementer_Name__c From Implementer__c where Grant_Implementation_Period__c =: strImplementationPeriodId];
        if(lstImplementer.size() > 0){
            for(Implementer__c objImp : lstImplementer){
                ImplementersOptions.add(new SelectOption(objImp.Id,objImp.Implementer_Name__c));
            }
        }
    }
    
    Public wrapAssumptionSet fillwraperObject(Assumption_Set__c objAS){
        wrapAssumptionSet objWrap = new wrapAssumptionSet();
        objWrap.objAssumptionSet = new Assumption_Set__c();
        objWrap.objAssumptionSet = objAS;
        objWrap.blnIsEditable = true;        
        objWrap.strCostInputName = objAS.Cost_Input__r.Name;        
        return objWrap;
    }
    
    Public Assumption_Set__c retriveBudjetLine(String BudgetLineId){
        Assumption_Set__c objBudgetLineRetrive = new Assumption_Set__c();
        List<Assumption_Set__c> lstBudgetLineRetrive = [Select Id,Name,Cost_Input__c,Cost_Input__r.name
                                                        From Assumption_Set__c Where Id =: BudgetLineId];
        if(lstBudgetLineRetrive.size() > 0){
            objBudgetLineRetrive = lstBudgetLineRetrive[0];
        }
        return objBudgetLineRetrive;
    }
    
     Public void SaveBudgetLines(){        
            Integer SaveIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));  
            if(SaveIndex != null ){                        
                if(SaveIndex > lstwrapAssumptionSet.size() && objAssumptionSetNewRow != null && String.IsBlank(objAssumptionSetNewRow.Name) == false ){            
                    objAssumptionSetNewRow.id = null;                                  
                    insert objAssumptionSetNewRow;                                                                             
                    wrapAssumptionSet objWrap = new wrapAssumptionSet();
                    Assumption_Set__c objAssumptionSetTemp = retriveBudjetLine(objAssumptionSetNewRow.Id);
                    objWrap = fillwraperObject(objAssumptionSetTemp);
                    lstwrapAssumptionSet.add(objWrap);                                     
                }            
          }
    }   
    
    Public void EditBudgetLine(){
        Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            lstwrapAssumptionSet[EditIndex].blnIsEditable = false;
            wrapAssumptionSet objwrapAssumptionSetTemp = new wrapAssumptionSet();
            objwrapAssumptionSetTemp.objAssumptionSet = new Assumption_Set__c();
            objwrapAssumptionSetTemp.objAssumptionSet = lstwrapAssumptionSet[EditIndex].objAssumptionSet.clone(true);        
            objwrapAssumptionSetTemp.blnIsEditable = lstwrapAssumptionSet[EditIndex].blnIsEditable;
            objwrapAssumptionSetTemp.strASName= lstwrapAssumptionSet[EditIndex].strASName;
            objwrapAssumptionSetTemp.strCostInputName = lstwrapAssumptionSet[EditIndex].strCostInputName;
            objwrapAssumptionSetTemp.strCostGrouping = lstwrapAssumptionSet[EditIndex].strCostGrouping;
            mapASIdToWrap.put(objwrapAssumptionSetTemp.objAssumptionSet.id,objwrapAssumptionSetTemp);        
        }
    }
    
    Public void DeleteAssumption(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(DeleteIndex != null && intIndex != null){
            String strAssumptionid = lstwrapAssumptionSet[intIndex].lstAssumptions[DeleteIndex].objAssumption.Id;
            List<Assumption__c> lstAssumptionToDelete = [Select Id From Assumption__c Where Id =: strAssumptionid];
            if(lstAssumptionToDelete.size() > 0){
                Delete lstAssumptionToDelete;
            }
            lstwrapAssumptionSet[intIndex].lstAssumptions.remove(DeleteIndex);
            if(lstwrapAssumptionSet[intIndex].lstAssumptions.size() > 0){
                lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost= null;
                lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost= null;
                lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost= null;
                lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost= null;
            
                for(wrapAssumption objWrap : lstwrapAssumptionSet[intIndex].lstAssumptions){                    
                    if(objWrap.objAssumption.Y1_Quantity__c == null) objWrap.objAssumption.Y1_Quantity__c = 0;
                    if(objWrap.objAssumption.Y2_Quantity__c == null) objWrap.objAssumption.Y2_Quantity__c = 0;
                    if(objWrap.objAssumption.Y3_Quantity__c == null) objWrap.objAssumption.Y3_Quantity__c = 0;
                    if(objWrap.objAssumption.Y4_Quantity__c == null) objWrap.objAssumption.Y4_Quantity__c = 0;
                    if(objWrap.CurrencyRateInUSDY1!=null){                      
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.CurrencyRateInUSDY1;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.CurrencyRateInUSDY1;
                    }else if(objWrap.TotalCostY1!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.TotalCostY1;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.TotalCostY1;
                    }
                    if(objWrap.CurrencyRateInUSDY2!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.CurrencyRateInUSDY2;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.CurrencyRateInUSDY2;
                    } else if(objWrap.TotalCostY2!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.TotalCostY2;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.TotalCostY2;
                    }                                
                    if(objWrap.CurrencyRateInUSDY3!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.CurrencyRateInUSDY3;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.CurrencyRateInUSDY3;
                    }else if(objWrap.TotalCostY3!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.TotalCostY3;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.TotalCostY3;
                    }
                    if(objWrap.CurrencyRateInUSDY4!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.CurrencyRateInUSDY4;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.CurrencyRateInUSDY4;
                    }else if(objWrap.TotalCostY4!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.TotalCostY4;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.TotalCostY4;
                    }
                }
            }
        }
    }
    
    Public void DeleteBudgetLine(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(DeleteIndex != null){
            String strAssumptionSetid = lstwrapAssumptionSet[DeleteIndex].objAssumptionSet.Id;
            List<Assumption_Set__c> lstwrapAssumptionSetToDelete = [Select Id From Assumption_Set__c Where Id =: strAssumptionSetid];
            if(lstwrapAssumptionSetToDelete.size() > 0){
                Delete lstwrapAssumptionSetToDelete;
            }          
            lstwrapAssumptionSet.remove(DeleteIndex);
        }
    }
    
    Public void SaveAssumption(){
        if(intIndex != null){
            List<Assumption__c> lstAssumptionToUpdate = new List<Assumption__c>();
            lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost= null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost= null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost= null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost= null;
           
            for(wrapAssumption objWrap : lstwrapAssumptionSet[intIndex].lstAssumptions){
                if(objWrap.objAssumption.Y1_Quantity__c == null) objWrap.objAssumption.Y1_Quantity__c = 0;
                if(objWrap.objAssumption.Y2_Quantity__c == null) objWrap.objAssumption.Y2_Quantity__c = 0;
                if(objWrap.objAssumption.Y3_Quantity__c == null) objWrap.objAssumption.Y3_Quantity__c = 0;
                if(objWrap.objAssumption.Y4_Quantity__c == null) objWrap.objAssumption.Y4_Quantity__c = 0;    
                objWrap.objAssumption.Payment_Currency__c = objWrap.strCurrencyUsedAssumption;
                lstAssumptionToUpdate.add(objWrap.objAssumption);
                
                if(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y1_Quantity__c!=null)
                objWrap.TotalCostY1 = integer.valueof(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y1_Quantity__c);
                
                if(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y2_Quantity__c!=null)
                objWrap.TotalCostY2 = integer.valueof(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y2_Quantity__c);

                if(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y3_Quantity__c!=null)
                objWrap.TotalCostY3 = integer.valueof(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y3_Quantity__c);
                 
                if(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y4_Quantity__c!=null)
                objWrap.TotalCostY4 = integer.valueof(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y4_Quantity__c);  
                
                Double conversionRate;
                if(objWrap.objAssumption.Payment_Currency__c == 'Local Currency'){
                    conversionRate = conversion_rates.get(strLocalCurrency);
                }else if(objWrap.objAssumption.Payment_Currency__c == 'Other Currency'){
                    conversionRate = conversion_rates.get(strOtherCurrency);
                }
                if(conversionRate != null){
                     if(objWrap.TotalCostY1!=null){
                         objWrap.CurrencyRateInUSDY1 = (objWrap.TotalCostY1 * conversionRate).setscale(2);
                     }
                     if(objWrap.TotalCostY2!=null){
                         objWrap.CurrencyRateInUSDY2 = (objWrap.TotalCostY2 * conversionRate).setscale(2);
                     }
                     if(objWrap.TotalCostY3!=null){
                         objWrap.CurrencyRateInUSDY3 = (objWrap.TotalCostY3 * conversionRate).setscale(2);
                     }
                     if(objWrap.TotalCostY4!=null){
                         objWrap.CurrencyRateInUSDY4 = (objWrap.TotalCostY4 * conversionRate).setscale(2);
                     }
                }
            
                if(objWrap.CurrencyRateInUSDY1!=null){                      
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.CurrencyRateInUSDY1;    
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.CurrencyRateInUSDY1;
                }else if(objWrap.TotalCostY1!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.TotalCostY1;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.TotalCostY1;
                }    
                if(objWrap.CurrencyRateInUSDY2!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.CurrencyRateInUSDY2;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.CurrencyRateInUSDY2;
                } else if(objWrap.TotalCostY2!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.TotalCostY2;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.TotalCostY2;
                }                                
                if(objWrap.CurrencyRateInUSDY3!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.CurrencyRateInUSDY3;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.CurrencyRateInUSDY3;
                }else if(objWrap.TotalCostY3!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.TotalCostY3;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.TotalCostY3;
                }
                if(objWrap.CurrencyRateInUSDY4!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.CurrencyRateInUSDY4;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.CurrencyRateInUSDY4;
                }else if(objWrap.TotalCostY4!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.TotalCostY4;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.TotalCostY4;
                }
            }
            if(lstAssumptionToUpdate.size() > 0) Update lstAssumptionToUpdate;     
        }
   } 
    
   Public void SaveAssumptionNew(){  
         if(intIndex != null){            
            objNewAssumption.objAssumption.Assumption_Set__c = lstwrapAssumptionSet[intIndex].objAssumptionSet.id;
            objNewAssumption.objAssumption.Payment_Currency__c = objNewAssumption.strCurrencyUsedAssumption;
            if(String.IsBlank(strAssumptionSet) == false){
                objNewAssumption.objAssumption.Assumption_Set__c = strAssumptionSet;
            }                    
            insert objNewAssumption.objAssumption;
            
            if(lstwrapAssumptionSet[intIndex].lstAssumptions != null && lstwrapAssumptionSet[intIndex].lstAssumptions.size() > 0){
                List<Assumption__c> lstAssumptionToUpdate = new List<Assumption__c>();
                lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost= null;
                lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost= null;
                lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost= null;
                lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost= null;
                
                for(wrapAssumption objWrap : lstwrapAssumptionSet[intIndex].lstAssumptions){
                    if(objWrap.objAssumption.Y1_Quantity__c == null) objWrap.objAssumption.Y1_Quantity__c = 0;
                    if(objWrap.objAssumption.Y2_Quantity__c == null) objWrap.objAssumption.Y2_Quantity__c = 0;
                    if(objWrap.objAssumption.Y3_Quantity__c == null) objWrap.objAssumption.Y3_Quantity__c = 0;
                    if(objWrap.objAssumption.Y4_Quantity__c == null) objWrap.objAssumption.Y4_Quantity__c = 0;    
                    objWrap.objAssumption.Payment_Currency__c = objWrap.strCurrencyUsedAssumption;
                    lstAssumptionToUpdate.add(objWrap.objAssumption);
                    
                    if(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y1_Quantity__c!=null)
                    objWrap.TotalCostY1 = integer.valueof(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y1_Quantity__c);
           
                    if(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y2_Quantity__c!=null)
                    objWrap.TotalCostY2 = integer.valueof(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y2_Quantity__c);
    
                    if(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y3_Quantity__c!=null)
                    objWrap.TotalCostY3 = integer.valueof(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y3_Quantity__c);
                     
                    if(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y4_Quantity__c!=null)
                    objWrap.TotalCostY4 = integer.valueof(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y4_Quantity__c);  
                    
                    Double conversionRate;
                    if(objWrap.objAssumption.Payment_Currency__c == 'Local Currency'){
                        conversionRate = conversion_rates.get(strLocalCurrency);
                    }else if(objWrap.objAssumption.Payment_Currency__c == 'Other Currency'){
                        conversionRate = conversion_rates.get(strOtherCurrency);
                    }
                    if(conversionRate != null){
                         if(objWrap.TotalCostY1!=null){
                             objWrap.CurrencyRateInUSDY1 = (objWrap.TotalCostY1 * conversionRate).setscale(2);
                         }
                         if(objWrap.TotalCostY2!=null){
                             objWrap.CurrencyRateInUSDY2 = (objWrap.TotalCostY2 * conversionRate).setscale(2);
                         }
                         if(objWrap.TotalCostY3!=null){
                             objWrap.CurrencyRateInUSDY3 = (objWrap.TotalCostY3 * conversionRate).setscale(2);
                         }
                         if(objWrap.TotalCostY4!=null){
                             objWrap.CurrencyRateInUSDY4 = (objWrap.TotalCostY4 * conversionRate).setscale(2);
                         }
                    } 
                    if(objWrap.CurrencyRateInUSDY1!=null){              
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.CurrencyRateInUSDY1;    
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.CurrencyRateInUSDY1;
                    }else if(objWrap.TotalCostY1!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.TotalCostY1;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.TotalCostY1;
                    }    
                    if(objWrap.CurrencyRateInUSDY2!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.CurrencyRateInUSDY2;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.CurrencyRateInUSDY2;
                    } else if(objWrap.TotalCostY2!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.TotalCostY2;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.TotalCostY2;
                    }                                
                    if(objWrap.CurrencyRateInUSDY3!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.CurrencyRateInUSDY3;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.CurrencyRateInUSDY3;
                    }else if(objWrap.TotalCostY3!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.TotalCostY3;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.TotalCostY3;
                    }
                    if(objWrap.CurrencyRateInUSDY4!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.CurrencyRateInUSDY4;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.CurrencyRateInUSDY4;
                    }else if(objWrap.TotalCostY4!=null){
                        if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.TotalCostY4;
                        else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.TotalCostY4;
                    }    
                }
                if(lstAssumptionToUpdate.size() > 0) Update lstAssumptionToUpdate;
            }else{
                lstwrapAssumptionSet[intIndex].lstAssumptions = new List<wrapAssumption>();
            }
            List<Assumption__c> lstAssumptionTemp = [Select Assumptions_to_Support_Unit_Cost__c,Y1_Duration_Days__c, 
                                                    Item_Description__c,Justifications_Comments__c,Unit_of_Measure__c,
                                                    Y1_Quantity__c, Y1_Unit_Cost_Payment_Currency__c,Payment_Currency__c, 
                                                    Y1_Net_Salary_Payment_Currency__c,
                                                    Y1_Total_Salary_Payment_Currency__c,Y1_Level_of_Effort__c,
                                                    Y1_Social_Security_Obligatory_Charges__c,Y1_Number_of_Persons__c,
                                                    Y2_Duration_Days__c,Y2_Quantity__c, Y2_Unit_Cost_Payment_Currency__c,Y2_Net_Salary_Payment_Currency__c,
                                                    Y2_Total_Salary_Payment_Currency__c,Y2_Level_of_Effort__c,
                                                    Y2_Social_Security_Obligatory_Charges__c,Y2_Number_of_Persons__c,
                                                    Y3_Duration_Days__c,Y3_Quantity__c, Y3_Unit_Cost_Payment_Currency__c,Y3_Net_Salary_Payment_Currency__c,
                                                    Y3_Total_Salary_Payment_Currency__c,Y3_Level_of_Effort__c,
                                                    Y3_Social_Security_Obligatory_Charges__c,Y3_Number_of_Persons__c,
                                                    Y4_Duration_Days__c,Y4_Quantity__c, Y4_Unit_Cost_Payment_Currency__c,Y4_Net_Salary_Payment_Currency__c,
                                                    Y4_Total_Salary_Payment_Currency__c,Y4_Level_of_Effort__c,
                                                    Y4_Social_Security_Obligatory_Charges__c,Y4_Number_of_Persons__c
                                                    From Assumption__c Where Id = :objNewAssumption.objAssumption.Id];
            
            objNewAssumption = new wrapAssumption();
            objNewAssumption.objAssumption = new Assumption__c();
            objNewAssumption.objAssumption = lstAssumptionTemp[0];
            objNewAssumption.strCurrencyUsedAssumption = lstAssumptionTemp[0].Payment_Currency__c;
            if(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c == null) lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c = 0;
            if(lstAssumptionTemp[0].Y1_Quantity__c == null) lstAssumptionTemp[0].Y1_Quantity__c = 0;
            if(lstAssumptionTemp[0].Y2_Quantity__c == null) lstAssumptionTemp[0].Y2_Quantity__c = 0;
            if(lstAssumptionTemp[0].Y3_Quantity__c == null) lstAssumptionTemp[0].Y3_Quantity__c = 0;
            if(lstAssumptionTemp[0].Y4_Quantity__c == null) lstAssumptionTemp[0].Y4_Quantity__c = 0;
            
            if(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c == null) lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c = 0;
            if(lstAssumptionTemp[0].Y1_Quantity__c == null) lstAssumptionTemp[0].Y1_Quantity__c = 0;         
                   
            if(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y1_Quantity__c!=null)
            objNewAssumption.TotalCostY1 = integer.valueof(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y1_Quantity__c);
            
            if(lstAssumptionTemp[0].Y2_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y2_Quantity__c!=null)
            objNewAssumption.TotalCostY2 = integer.valueof(lstAssumptionTemp[0].Y2_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y2_Quantity__c);
            
            if(lstAssumptionTemp[0].Y3_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y3_Quantity__c!=null)
            objNewAssumption.TotalCostY3 = integer.valueof(lstAssumptionTemp[0].Y3_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y3_Quantity__c);
            
            if(lstAssumptionTemp[0].Y4_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y4_Quantity__c!=null)
            objNewAssumption.TotalCostY4 = integer.valueof(lstAssumptionTemp[0].Y4_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y4_Quantity__c); 
            
            Double conversionRate;
            
            if(lstAssumptionTemp[0].Payment_Currency__c== 'Local Currency'){
                conversionRate = conversion_rates.get(strLocalCurrency);
            }else if(lstAssumptionTemp[0].Payment_Currency__c == 'Other Currency'){
                conversionRate = conversion_rates.get(strOtherCurrency);
            }
            if(conversionRate != null){       
                
                if(objNewAssumption.TotalCostY1!=null){
                    objNewAssumption.CurrencyRateInUSDY1 = (objNewAssumption.TotalCostY1 * conversionRate).setscale(2);
                }
                if(objNewAssumption.TotalCostY2!=null){
                    objNewAssumption.CurrencyRateInUSDY2 = (objNewAssumption.TotalCostY2 * conversionRate).setscale(2);
                }
                if(objNewAssumption.TotalCostY3!=null){
                    objNewAssumption.CurrencyRateInUSDY3 = (objNewAssumption.TotalCostY3 * conversionRate).setscale(2);
                }
                if(objNewAssumption.TotalCostY4!=null){
                    objNewAssumption.CurrencyRateInUSDY4 = (objNewAssumption.TotalCostY4 * conversionRate).setscale(2);
                }
            }else{
                objNewAssumption.CurrencyRateInUSDY1 = null;
                objNewAssumption.CurrencyRateInUSDY2 = null;
                objNewAssumption.CurrencyRateInUSDY3 = null;
                objNewAssumption.CurrencyRateInUSDY4 = null;
            }
               
            lstwrapAssumptionSet[intIndex].lstAssumptions.add(objNewAssumption);
            lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost= null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost= null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost= null;
            lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost= null;
             
            for(wrapAssumption objWrap : lstwrapAssumptionSet[intIndex].lstAssumptions){
                 if(objWrap.CurrencyRateInUSDY1!=null){                      
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.CurrencyRateInUSDY1;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.CurrencyRateInUSDY1;
                }else if(objWrap.TotalCostY1!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost = objWrap.TotalCostY1;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY1Cost += objWrap.TotalCostY1;
                }
                if(objWrap.CurrencyRateInUSDY2!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.CurrencyRateInUSDY2;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.CurrencyRateInUSDY2;
                } else if(objWrap.TotalCostY2!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost = objWrap.TotalCostY2;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY2Cost += objWrap.TotalCostY2;
                }                                
                if(objWrap.CurrencyRateInUSDY3!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.CurrencyRateInUSDY3;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.CurrencyRateInUSDY3;
                }else if(objWrap.TotalCostY3!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost = objWrap.TotalCostY3;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY3Cost += objWrap.TotalCostY3;
                }
                if(objWrap.CurrencyRateInUSDY4!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.CurrencyRateInUSDY4;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.CurrencyRateInUSDY4;
                }else if(objWrap.TotalCostY4!=null){
                    if(lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost == null) lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost = objWrap.TotalCostY4;
                    else lstwrapAssumptionSet[intIndex].TotalOfAllY4Cost += objWrap.TotalCostY4;
                }
            }
            update lstwrapAssumptionSet[intIndex].objAssumptionSet;
            objNewAssumption = new wrapAssumption();
            objNewAssumption.objAssumption = new Assumption__c();
        }      
   } 
   
    Public void EditAssumptionRecords(){                  
        Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            intIndex = EditIndex;          
            lstwrapAssumptionSet[EditIndex].blnHasChild = true;              
        }
    }
    
    Public void OpenAssumptionNoRecords(){
        blnHasNoChild = true;
    }
    
    Public void SaveBLAssumptionNoRecords(){
        Integer SaveBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveBLIndex'));
        if(SaveBLIndex != null){
            update lstwrapAssumptionSet[SaveBLIndex].objAssumptionSet;
            blnHasNoChild = false;
        }
    }
    
    Public void CancelAssumptionRecords(){
        Integer CancelIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            lstwrapAssumptionSet[CancelIndex].blnHasChild = false;
        }
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
        Public Decimal TotalOfAllY2Cost {get;set;}
        Public Decimal TotalOfAllY3Cost {get;set;}
        Public Decimal TotalOfAllY4Cost {get;set;}
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
    
    Public Class wrapAssumptionSet {
        Public List<wrapAssumption> lstAssumptions {get;set;}
        Public Assumption_Set__c objAssumptionSet {get;set;}        
        Public String strUnitCostMeasure {get;set;}
        Public Integer NumberOfPersons {get;set;}
        Public Boolean blnHasChild{get;set;}
        Public Boolean blnIsEditable{get;set;}
        Public String strASName {get;set;}
        Public String strCostInputName {get;set;}
        Public String strCostGrouping {get;set;}
        Public Decimal TotalOfAllY1Cost {get;set;}
        Public Decimal TotalOfAllY2Cost {get;set;}
        Public Decimal TotalOfAllY3Cost {get;set;}
        Public Decimal TotalOfAllY4Cost {get;set;}
        Public Integer NumberOfBudgetLine {get;set;}
        Public Integer NumberOfAssumption {get;set;} 
    }
    
    Public Class wrapAssumption{
        Public Assumption__c objAssumption {get;set;}
        Public Decimal TotalCostY1 {get;set;}
        Public Decimal TotalCostY2 {get;set;}
        Public Decimal TotalCostY3 {get;set;}
        Public Decimal TotalCostY4 {get;set;}
        Public Decimal TotalSalaryY1 {get;set;}
        Public Decimal TotalSalaryY2 {get;set;}
        Public Decimal TotalSalaryY3 {get;set;}
        Public Decimal TotalSalaryY4 {get;set;}
        Public Decimal CurrencyRateInUSDY1 {get;set;}
        Public Decimal CurrencyRateInUSDY2 {get;set;}
        Public Decimal CurrencyRateInUSDY3 {get;set;}
        Public Decimal CurrencyRateInUSDY4 {get;set;}
        Public String strCurrencyUsedAssumption {get;set;}
    }
}