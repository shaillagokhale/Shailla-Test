Global Class GMDetailedBudget{
    Public String strImpGuidanceId {get;set;}
    Public String strSelectedYear {get;set;}
    Public String strSelectedYearAssumption {get;set;}
    Public String strModuleId {get;set;}
    Public String strGIPName {get;set;}
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
   
   // public Catalog_Cost_Input__c CSInput{get;set;} 
    Public List<SelectOption> AllCurrencyOptions {get;set;}
    Public List<Assumption_set__c> lstAssumptionSets {get;set;}
    Public String strAssumptionSet {get;set;}
    Public List<SelectOption> AssumptionSetsOptions {get;set;}
    Public Integer intIndex{get;set;}
    Public Boolean blnHasChild {get;set;}
    
    Public wrapAssumption objNewAssumption {get;set;}
    Public Date GIPstartdate {get;set;}
    Public Map<String,Double> conversion_rates {get;set;}
    Public String strGrantCurrency  {get;set;}
    Public String strLocalCurrency {get;set;}
    Public String strOtherCurrency  {get;set;}
    Public String strBudgetStatus {get;set;}
    
    Public Decimal strGrantCurrencyRate {get;set;}
    Public Decimal strLocalCurrencyRate {get;set;}
    Public Decimal strOtherCurrencyRate {get;set;} 
    
   /******************* Variables defined by TCS ********************/
    public String strCostGrpName {get;set;} 
    public Catalog_Cost_Input__c CatalogIC ; 
    Public List<SelectOption> AllCostGrpOptions {get;set;} 
    Public Decimal AmountQtr1{get;set;}
    Public Decimal AmountQtr2{get;set;}
    Public Decimal AmountQtr3{get;set;}
    Public Decimal AmountQtr4{get;set;}
    Public Decimal AmountQtr5{get;set;}
    Public Decimal AmountQtr6{get;set;}
    Public Decimal AmountQtr7{get;set;}
    Public Decimal AmountQtr8{get;set;}
    Public Decimal AmountQtr9{get;set;}
    Public Decimal AmountQtr10{get;set;}
    Public Decimal AmountQtr11{get;set;}
    Public Decimal AmountQtr12{get;set;}
    Public Decimal AmountQtr13{get;set;}
    Public Decimal AmountQtr14{get;set;}
    Public Decimal AmountQtr15{get;set;}
    Public Decimal AmountQtr16{get;set;}
    Public Decimal TotalQtr1{get;set;}
    Public Decimal TotalQtr2{get;set;}
    Public Decimal TotalQtr3{get;set;}
    Public Decimal TotalQtr4{get;set;}
    Public Decimal GrantTotal{get;set;}
    Public List<Module__c> lstModuleTemp {get;set;}    
    Public Implementation_Period__c imp {get;set;} 
    Public IP_Detail_Information__c ipde {get;set;}
    Public String grantcurrency {get;set;} 
    Public double changerate {get;set;}
    
    /** Added for Profile Access**/
    Public Boolean blnExternalPro{get;set;}
    Public Boolean blnAddBL{get;set;}
    Public Boolean blnEdit{get;set;}
    Public Boolean blnPRComment{get;set;}
    Public Boolean blnLFAComment{get;set;}
    Public Boolean blnTGFComment{get;set;}
    Public Boolean blnCGLevel{get;set;}
    Public Boolean blnMAset{get;set;}
    Public Boolean blnAddAssumption{get;set;}
    Public Boolean blnSaveAssumption{get;set;}
    Public Boolean blnDelAssumption{get;set;}
    Public Boolean blnSaveBLAss{get;set;}
    Public Boolean blnCILevel{get;set;}
    Public Boolean blnDelete{get;set;}
    Public Boolean blnDialoguePR{get;set;}
    Public Boolean blnDialogueLFA{get;set;}
    Public Boolean blnDialogueTGF{get;set;}
    public Boolean blnEditFOFields {get;set;}
    public Boolean blnEditPRFields {get;set;}
    public Boolean blnSeeLFAComments {get;set;}
    public Boolean blnLFAFlag {get;set;}
    public Boolean blnEditLFAFields {get;set;}
    public Boolean blnSeeLFAFields {get;set;}
    public Boolean blnSeeFOFields {get;set;}
    public Boolean blnEditCurrency {get;set;}
    public Boolean blnEditActivity {get;set;}
    public Boolean blnEditRecipient {get;set;}
    public Boolean blnEditIntervention {get;set;}
    
    /*TCS 10/16/2014 Spring 3 changes on US Detailed Budget*/
    List<IP_Detail_Information__c> lstIpDetail = new List<IP_Detail_Information__c>();

    public GMDetailedBudget(ApexPages.StandardController controller) {
        strModuleId = Apexpages.currentpage().getparameters().get('Id');
        if(String.IsBlank(strModuleId) == false){
            strLengthYears = null;            
            intIndex = null;
            blnHasChild = false;
            //blnHasNoChild  = false;
            lstModuleTemp = new List<Module__c>();
                            lstModuleTemp = [Select Implementation_Period__c,Implementation_Period__r.Component__c,Implementation_Period_Name__c,
                                            Implementation_Period__r.Length_Years__c,
                                            Implementation_Period__r.Local_Currency__c,
                                            Implementation_Period__r.Currency_of_Grant_Agreement__c,
                                            Implementation_Period__r.Other_Currency__c,
                                            Implementation_Period__r.Start_Date__c,
                                            Implementation_Period__r.Other_Currency_Exchange_Rate__c,
                                            Implementation_Period__r.Exchange_Rate__c,
                                            Implementation_Period__r.Budget_Status__c,
                                            Implementation_Period__r.Total__c,
                                            Implementation_Period__r.Sum__c,
                                            Implementation_Period__r.Budget_Remaining__c,
                                            Implementation_Period__r.Grant__r.Country__r.X200DEMA_Exch_Rate_in_USD__c,
                                            Implementation_Period__r.Grant__r.Country__r.X200DEMA_Exch_Rate_in_EUR__c
                                            From Module__c 
                                            Where id =: strModuleId And Implementation_Period__c != null];
            
            
            conversion_rates = new Map<String,Double>();
            
            /*Set<String> isoCodes = new Set<String>();
            isoCodes.add('EUR');
            isoCodes.add('USD');
            isoCodes.add('NGN');
            
            for(CurrencyType curr: [SELECT IsoCode,ConversionRate 
                                    FROM CurrencyType 
                                    WHERE IsoCode in: isoCodes]){          
                                        conversion_rates.put(curr.IsoCode,curr.ConversionRate);        
                                    }*/
                                      
            system.debug('#$$#$#$3434'+conversion_rates);
            
            lstPageTodisplay = new List<Page__c>();
            if(lstModuleTemp.size() > 0){
                strGIPName = lstModuleTemp[0].Implementation_Period_Name__c;
                
                if(lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c == 'EUR')
                    conversion_rates.put(lstModuleTemp[0].Implementation_Period__r.Local_Currency__c,lstModuleTemp[0].Implementation_Period__r.Grant__r.Country__r.X200DEMA_Exch_Rate_in_EUR__c);                             
               if(lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c == 'USD')
                    conversion_rates.put(lstModuleTemp[0].Implementation_Period__r.Local_Currency__c,lstModuleTemp[0].Implementation_Period__r.Grant__r.Country__r.X200DEMA_Exch_Rate_in_USD__c);                             
               
               // conversion_rates.put(lstModuleTemp[0].Implementation_Period__r.Other_Currency__c,lstModuleTemp[0].Implementation_Period__r.Other_Currency_Exchange_Rate__c); 
                strGrantCurrency = lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c;
                strLocalCurrency = lstModuleTemp[0].Implementation_Period__r.Local_Currency__c;
               // strOtherCurrency = lstModuleTemp[0].Implementation_Period__r.Other_Currency__c;
                strLocalCurrencyRate = conversion_rates.get(lstModuleTemp[0].Implementation_Period__r.Local_Currency__c); 
                strGrantCurrencyRate = conversion_rates.get(lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c); 
               // strOtherCurrencyRate = conversion_rates.get(lstModuleTemp[0].Implementation_Period__r.Other_Currency__c);
                //strBudgetStatus = lstModuleTemp[0].Implementation_Period__r.Budget_Status__c;
                
                AllIPCurrencyOptions = new List<SelectOption>();
                if(lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c != null){
                    AllIPCurrencyOptions.add(new SelectOption('Grant Currency',lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c));
                }
                if(lstModuleTemp[0].Implementation_Period__r.Local_Currency__c != null){
                    AllIPCurrencyOptions.add(new SelectOption('Local Currency',lstModuleTemp[0].Implementation_Period__r.Local_Currency__c));
                }
              /*  if(lstModuleTemp[0].Implementation_Period__r.Other_Currency__c != null){
                    AllIPCurrencyOptions.add(new SelectOption('Other Currency',lstModuleTemp[0].Implementation_Period__r.Other_Currency__c));
                }*/
                
                AllCurrencyOptions = new List<SelectOption>();
                if(lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c != null){
                    AllCurrencyOptions.add(new SelectOption(lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c,lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c));
                }
                if(lstModuleTemp[0].Implementation_Period__r.Local_Currency__c != null){
                    AllCurrencyOptions.add(new SelectOption(lstModuleTemp[0].Implementation_Period__r.Local_Currency__c,lstModuleTemp[0].Implementation_Period__r.Local_Currency__c));
                }
            /*    if(lstModuleTemp[0].Implementation_Period__r.Other_Currency__c != null){
                    AllCurrencyOptions.add(new SelectOption(lstModuleTemp[0].Implementation_Period__r.Other_Currency__c,lstModuleTemp[0].Implementation_Period__r.Other_Currency__c));
                } */
                 
                
                 
                strImplementationPeriodId = lstModuleTemp[0].Implementation_Period__c; 
                grantcurrency =  lstModuleTemp[0].Implementation_Period__r.Currency_of_Grant_Agreement__c;               
                imp = [Select Id,name,Sum__c,Budget_Remaining__c,High_level_budget_GAC_1_USD__c,High_level_budget_GAC_1_EUR__c,Currency_of_Grant_Agreement__c,Grant__r.Country__r.X200DEMA_Exch_Rate_in_USD__c,Grant__r.Country__r.X200DEMA_Exch_Rate_in_EUR__c from Implementation_Period__c where Id =:strImplementationPeriodId];
                ipde = [Select Id,name,Budget_Status__c,High_level_budget_GAC_1_EUR__c,High_level_budget_GAC_1_USD__c,Implementation_Period__c , Remaining_Budget_Amount__c ,Total_Approved_Budget__c ,Total_Budgeted_Amount__c from IP_Detail_Information__c where Implementation_Period__c =:strImplementationPeriodId ]; 
                changerate = imp.Grant__r.Country__r.X200DEMA_Exch_Rate_in_USD__c/imp.Grant__r.Country__r.X200DEMA_Exch_Rate_in_EUR__c;
                strComponent = lstModuleTemp[0].Implementation_Period__r.Component__c;
                strLengthYears = lstModuleTemp[0].Implementation_Period__r.Length_Years__c;
                GIPstartdate = lstModuleTemp[0].Implementation_Period__r.Start_Date__c;
                lstPageTodisplay = [Select Id,Name,URL_Prefix__c,Order__c,Implementation_Period__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId  Order by Order__c];
                GrantInterventionOptions = new List<SelectOption>();
                GrantInterventionOptions.add(new SelectOption('','--None--'));      
                List<Grant_Intervention__c> lstGI = [Select Id,Name From Grant_Intervention__c Where Module__c =: strModuleId Order BY Name];
                if(lstGI.size() > 0){
                    for(Grant_Intervention__c objBL : lstGI){
                        GrantInterventionOptions.add(new SelectOption(objBL.Id,objBL.Name));
                    }
                } 
            }
            
            strSelectedYear = 'Year1';
            strSelectedYearAssumption = 'Year1';
            List<Budget_Line__c> lstGrantIntervention = new List<Budget_Line__c>();
            lstGrantIntervention = [
                                                Select Cost_Grouping__c,Q1_Quantity__c,Q1_Amount__c,Q2_Quantity__c,Q2_Amount__c,
                                                Q3_Quantity__c,Q3_Amount__c,Q4_Quantity__c,Q4_Amount__c,
                                                Q5_Quantity__c,Q5_Amount__c,Q6_Quantity__c,Q6_Amount__c,
                                                Q7_Quantity__c,Q7_Amount__c,Q8_Quantity__c,Q8_Amount__c,
                                                Q9_Quantity__c,Q9_Amount__c,Q10_Quantity__c,Q10_Amount__c,
                                                Q11_Quantity__c,Q11_Amount__c,Q12_Quantity__c,Q12_Amount__c,
                                                Q13_Quantity__c,Q13_Amount__c,Q14_Quantity__c,Q14_Amount__c,
                                                Q15_Quantity__c,Q15_Amount__c,Q16_Quantity__c,Q16_Amount__c,
                                                Q1_Grant_Amount__c,Q2_Grant_Amount__c,Q3_Grant_Amount__c,
                                                Q4_Grant_Amount__c,Q5_Grant_Amount__c,Q6_Grant_Amount__c,
                                                Q7_Grant_Amount__c,Q8_Grant_Amount__c,Q9_Grant_Amount__c,
                                                Q10_Grant_Amount__c,Q11_Grant_Amount__c,Q12_Grant_Amount__c,
                                                Q13_Grant_Amount__c,Q14_Grant_Amount__c,Q15_Grant_Amount__c,Q16_Grant_Amount__c,
                                                Activity__c,Cost_Input__c,Currency_Used__c,Grant_Intervention__c,
                                                Y1_Grant_Amount__c,Y2_Grant_Amount__c,Y3_Grant_Amount__c,
                                                Unit_Cost_Y1__c,Unit_Cost_Y2__c,Unit_Cost_Y3__c,Unit_Cost_Y4__c,LFA_Unit_Cost_Y1__c,LFA_Unit_Cost_Y2__c,LFA_Unit_Cost_Y3__c,LFA_Unit_Cost_Y4__c,
                                                Cost_Input__r.Unit_Cost_Definition__c,Cost_Input__r.Cost_Grouping__c,Cost_Input__r.Is_Inactive__c,
                                                Payee__c,Payee__r.Name, Cost_Input__r.Name,Currency_Code__c,LFA_Y1_Amount__c,LFA_Y2_Amount__c,LFA_Y3_Amount__c,LFA_Y4_Amount__c,
                                                PR_Comments__c,LFA_Comments__c ,TGF_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_TGF_Comment__c,Payee__r.Implementer_Name__c,
                                                Y4_Grant_Amount__c,Grant_Intervention__r.Name,FO_Y1_Amount__c,FO_Y2_Amount__c,FO_Y3_Amount__c,FO_Y4_Amount__c,LFA_Flag__c,FO_Total_Grant_Quantity_Amount__c,
                                                FO_Unit_Cost_Y1__c,FO_Unit_Cost_Y2__c,FO_Unit_Cost_Y3__c,FO_Unit_Cost_Y4__c 
                                                From Budget_Line__c 
                                                Where Cost_Input__r.PSM__c = false And Grant_Intervention__r.Module__c =: strModuleId
                                                Order By Grant_Intervention__r.Name];
                                          
            
            Set<Id> setBudgetLines = new Set<Id>();                            
            for(Budget_Line__c objGI : lstGrantIntervention){
                setBudgetLines.add(objGI.Id);
            }                            
            Map<Id,Budget_line__c> mapIdToBudgetLine = new Map<Id,Budget_Line__c>(
                                                    [Select Id,Cost_Input__r.Cost_Grouping__c,Cost_Grouping__c,
                                                    (Select Assumptions_to_Support_Unit_Cost__c,Y1_Duration_Days__c, 
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
                                                    From Assumptions__r) From Budget_line__c Where Id IN : setBudgetLines]);
            
            
            lstBudgetLines = new List<wrapBudgetLines>();
            wrapBudgetLines objWrap;
            objNewAssumption = new wrapAssumption();
            objNewAssumption.strCurrencyUsedAssumption = 'Grant Currency';
            objNewAssumption.objAssumption = new Assumption__c();
           
           /*************** initialize the variable to zero ***************/
                             /******** By TCS ************/                  
            Amountqtr1 = 0;
            Amountqtr2 = 0;
            Amountqtr3 = 0;
            Amountqtr4 = 0;
            Amountqtr5 = 0;
            Amountqtr6 = 0;
            Amountqtr7 = 0;
            Amountqtr8 = 0;
            Amountqtr9 = 0;
            Amountqtr10 = 0;
            Amountqtr11= 0;
            Amountqtr12= 0;
            Amountqtr13= 0;
            Amountqtr14= 0;
            Amountqtr15= 0;
            Amountqtr16= 0;
            TotalQtr1= 0;
            TotalQtr2= 0;
            TotalQtr3= 0;
            TotalQtr4 =0;
            GrantTotal = 0;
            //for(Grant_Intervention__c objGI : lstGrantIntervention){
                //if(objGI.Budget_Lines__r.size() > 0){
                    for(Budget_Line__c objBL : lstGrantIntervention){
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
                                 if(objAssumption.Y2_Quantity__c == null) objAssumption.Y2_Quantity__c = 0;
                                 if(objAssumption.Y3_Quantity__c == null) objAssumption.Y3_Quantity__c = 0;
                                 if(objAssumption.Y4_Quantity__c == null) objAssumption.Y4_Quantity__c = 0;
                                 
                                 if(objAssumption.Y1_Number_of_Persons__c == null) objAssumption.Y1_Number_of_Persons__c = 0;
                                 if(objAssumption.Y2_Number_of_Persons__c == null) objAssumption.Y2_Number_of_Persons__c = 0;
                                 if(objAssumption.Y3_Number_of_Persons__c == null) objAssumption.Y3_Number_of_Persons__c = 0;
                                 if(objAssumption.Y4_Number_of_Persons__c == null) objAssumption.Y4_Number_of_Persons__c = 0;
                                 
                                 if(objAssumption.Y1_Level_of_Effort__c == null) objAssumption.Y1_Level_of_Effort__c = 0;
                                 if(objAssumption.Y2_Level_of_Effort__c == null) objAssumption.Y2_Level_of_Effort__c = 0;
                                 if(objAssumption.Y3_Level_of_Effort__c == null) objAssumption.Y3_Level_of_Effort__c = 0;
                                 if(objAssumption.Y4_Level_of_Effort__c == null) objAssumption.Y4_Level_of_Effort__c = 0;
                                 
                                 if(objAssumption.Y1_Net_Salary_Payment_Currency__c == null) objAssumption.Y1_Net_Salary_Payment_Currency__c = 0;
                                 //if(objAssumption.Y1_Total_Salary_Payment_Currency__c == null) objAssumption.Y1_Total_Salary_Payment_Currency__c = 0;
                                 if(objAssumption.Y1_Level_of_Effort__c == null) objAssumption.Y1_Level_of_Effort__c = 0;
                                 if(objAssumption.Y1_Social_Security_Obligatory_Charges__c == null) objAssumption.Y1_Social_Security_Obligatory_Charges__c = 0;
                                 
                                 if(objAssumption.Y1_Duration_Days__c == null) objAssumption.Y1_Duration_Days__c = 0;
                                 
                                 if(objBL.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                                     if(objAssumption.Y1_Total_Salary_Payment_Currency__c != null && objAssumption.Y1_Level_of_Effort__c != null && objAssumption.Y1_Number_of_Persons__c != null)
                                     objwrapA.TotalCostY1 = (integer.valueof(objAssumption.Y1_Total_Salary_Payment_Currency__c * objAssumption.Y1_Level_of_Effort__c * objAssumption.Y1_Number_of_Persons__c))/100;
                                     if(objAssumption.Y2_Total_Salary_Payment_Currency__c != null && objAssumption.Y2_Level_of_Effort__c != null && objAssumption.Y2_Number_of_Persons__c != null)
                                     objwrapA.TotalCostY2 = (integer.valueof(objAssumption.Y2_Total_Salary_Payment_Currency__c * objAssumption.Y2_Level_of_Effort__c * objAssumption.Y2_Number_of_Persons__c))/100;
                                     if(objAssumption.Y3_Total_Salary_Payment_Currency__c != null && objAssumption.Y3_Level_of_Effort__c != null && objAssumption.Y3_Number_of_Persons__c != null)
                                     objwrapA.TotalCostY3 = (integer.valueof(objAssumption.Y3_Total_Salary_Payment_Currency__c * objAssumption.Y3_Level_of_Effort__c * objAssumption.Y3_Number_of_Persons__c))/100;
                                     if(objAssumption.Y4_Total_Salary_Payment_Currency__c != null && objAssumption.Y4_Level_of_Effort__c != null && objAssumption.Y4_Number_of_Persons__c != null)
                                     objwrapA.TotalCostY4 = (integer.valueof(objAssumption.Y4_Total_Salary_Payment_Currency__c * objAssumption.Y4_Level_of_Effort__c * objAssumption.Y4_Number_of_Persons__c))/100;
                                     
                                     objwrapA.TotalSalaryY1 = objAssumption.Y1_Total_Salary_Payment_Currency__c;
                                     objwrapA.TotalSalaryY2 = objAssumption.Y2_Total_Salary_Payment_Currency__c;
                                     objwrapA.TotalSalaryY3 = objAssumption.Y3_Total_Salary_Payment_Currency__c;
                                     objwrapA.TotalSalaryY4 = objAssumption.Y4_Total_Salary_Payment_Currency__c;
                                 }else if(objBL.Cost_Input__r.Cost_Grouping__c == '2. Travel related costs (TRC)'){
                                     if(objAssumption.Y1_Unit_Cost_Payment_Currency__c != null && objAssumption.Y1_Quantity__c != null && objAssumption.Y1_Duration_Days__c != null)
                                     objwrapA.TotalCostY1 = integer.valueof(objAssumption.Y1_Unit_Cost_Payment_Currency__c * objAssumption.Y1_Duration_Days__c * objAssumption.Y1_Quantity__c);
                                     if(objAssumption.Y2_Unit_Cost_Payment_Currency__c != null && objAssumption.Y2_Quantity__c != null && objAssumption.Y2_Duration_Days__c != null)
                                     objwrapA.TotalCostY2 = integer.valueof(objAssumption.Y2_Unit_Cost_Payment_Currency__c * objAssumption.Y2_Duration_Days__c * objAssumption.Y2_Quantity__c);
                                     if(objAssumption.Y3_Unit_Cost_Payment_Currency__c != null && objAssumption.Y3_Quantity__c != null && objAssumption.Y3_Duration_Days__c != null)
                                     objwrapA.TotalCostY3 = integer.valueof(objAssumption.Y3_Unit_Cost_Payment_Currency__c * objAssumption.Y3_Duration_Days__c * objAssumption.Y3_Quantity__c);
                                     if(objAssumption.Y4_Unit_Cost_Payment_Currency__c != null && objAssumption.Y4_Quantity__c != null && objAssumption.Y4_Duration_Days__c != null)
                                     objwrapA.TotalCostY4 = integer.valueof(objAssumption.Y4_Unit_Cost_Payment_Currency__c * objAssumption.Y4_Duration_Days__c * objAssumption.Y4_Quantity__c);
                                     system.debug('#$#$#$'+objwrapA.TotalCostY2);
                                 }else{
                                     if(objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y1_Quantity__c!=null)
                                     objwrapA.TotalCostY1 = integer.valueof(objAssumption.Y1_Unit_Cost_Payment_Currency__c * objAssumption.Y1_Quantity__c);
                                     
                                     if(objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y2_Quantity__c!=null)
                                     objwrapA.TotalCostY2 = integer.valueof(objAssumption.Y2_Unit_Cost_Payment_Currency__c * objAssumption.Y2_Quantity__c);

                                     if(objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y3_Quantity__c!=null)
                                     objwrapA.TotalCostY3 = integer.valueof(objAssumption.Y3_Unit_Cost_Payment_Currency__c * objAssumption.Y3_Quantity__c);
                                     
                                     if(objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y4_Quantity__c!=null)
                                     objwrapA.TotalCostY4 = integer.valueof(objAssumption.Y4_Unit_Cost_Payment_Currency__c * objAssumption.Y4_Quantity__c);
                                 }
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
                                 system.debug('#$#$#$'+objwrapA.CurrencyRateInUSDY2);
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
                                
                                 if(objBL.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                                     if(objwrap.TotalQuantityY1 == null) objwrap.TotalQuantityY1 = objAssumption.Y1_Number_of_Persons__c * objAssumption.Y1_Level_of_Effort__c;
                                     else objwrap.TotalQuantityY1 += (objAssumption.Y1_Number_of_Persons__c * objAssumption.Y1_Level_of_Effort__c);
                                     if(objwrap.TotalQuantityY2 == null) objwrap.TotalQuantityY2 = objAssumption.Y2_Number_of_Persons__c * objAssumption.Y2_Level_of_Effort__c;
                                     else objwrap.TotalQuantityY2 += (objAssumption.Y2_Number_of_Persons__c * objAssumption.Y2_Level_of_Effort__c);
                                     if(objwrap.TotalQuantityY3 == null) objwrap.TotalQuantityY3 = objAssumption.Y3_Number_of_Persons__c * objAssumption.Y3_Level_of_Effort__c;
                                     else objwrap.TotalQuantityY3 += (objAssumption.Y3_Number_of_Persons__c * objAssumption.Y3_Level_of_Effort__c);
                                     if(objwrap.TotalQuantityY4 == null) objwrap.TotalQuantityY4 = objAssumption.Y4_Number_of_Persons__c * objAssumption.Y4_Level_of_Effort__c;
                                     else objwrap.TotalQuantityY4 += (objAssumption.Y4_Number_of_Persons__c * objAssumption.Y4_Level_of_Effort__c);
                                     
                                     
                                }else{
                                     if(objwrap.TotalQuantityY1 == null) objwrap.TotalQuantityY1 = objAssumption.Y1_Quantity__c;
                                     else objwrap.TotalQuantityY1 += objAssumption.Y1_Quantity__c;
                                     if(objwrap.TotalQuantityY2 == null) objwrap.TotalQuantityY2 = objAssumption.Y2_Quantity__c;
                                     else objwrap.TotalQuantityY2 += objAssumption.Y2_Quantity__c;
                                     if(objwrap.TotalQuantityY3 == null) objwrap.TotalQuantityY3 = objAssumption.Y3_Quantity__c;
                                     else objwrap.TotalQuantityY3 += objAssumption.Y3_Quantity__c;
                                     if(objwrap.TotalQuantityY4 == null) objwrap.TotalQuantityY4 = objAssumption.Y4_Quantity__c;
                                     else objwrap.TotalQuantityY4 += objAssumption.Y4_Quantity__c;
                                 }
                                 
                                 objWrap.lstAssumptions.add(objWrapA);
                            }
                        }
                        if(objwrap.TotalQuantityY1 != null) objwrap.TotalQuantityY1 = objwrap.TotalQuantityY1/100;
                        if(objwrap.TotalQuantityY2 != null) objwrap.TotalQuantityY2 = objwrap.TotalQuantityY2/100;
                        if(objwrap.TotalQuantityY3 != null) objwrap.TotalQuantityY3 = objwrap.TotalQuantityY3/100;
                        if(objwrap.TotalQuantityY4 != null) objwrap.TotalQuantityY4 = objwrap.TotalQuantityY4/100;
                        
                        Integer divideAmount = null;
                        if(objBL.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                            divideAmount = 4;
                        }else{
                            divideAmount = 1;
                        }
                        
                        if(objwrap.TotalQuantityY1 != 0 && objwrap.TotalQuantityY1 != null){
                            objWrap.UnitCostY1 = (objWrap.TotalOfAllY1Cost / objwrap.TotalQuantityY1).setscale(2);
                            objWrap.UnitCostY1 /= divideAmount;
                        }
                        if(objwrap.TotalQuantityY2 != 0 && objwrap.TotalQuantityY2 != null){
                            objWrap.UnitCostY2 = (objWrap.TotalOfAllY2Cost / objwrap.TotalQuantityY2).setscale(2);
                            objWrap.UnitCostY2 /= divideAmount;
                        }
                        if(objwrap.TotalQuantityY3 != 0 && objwrap.TotalQuantityY3 != null){
                            objWrap.UnitCostY3 = (objWrap.TotalOfAllY3Cost / objwrap.TotalQuantityY3).setscale(2);
                            objWrap.UnitCostY3 /= divideAmount;
                        }
                        if(objwrap.TotalQuantityY4 != 0 && objwrap.TotalQuantityY4 != null){
                            objWrap.UnitCostY4 = (objWrap.TotalOfAllY4Cost / objwrap.TotalQuantityY4).setscale(2);
                            objWrap.UnitCostY4 /= divideAmount;
                        }
                        
                        objWrap.objBudgetLine = new Budget_Line__c();
                        objWrap.objBudgetLine = objBL;
                        objWrap.blnIsEditable = true;
                        objWrap.strUnitCostMeasure = objBL.Cost_Input__r.Unit_Cost_Definition__c;
                        objWrap.strGIName = objBL.Grant_Intervention__r.Name;
                        objWrap.strCostInputName = objBL.Cost_Input__r.Name;
                        objWrap.strCostGrouping = objBL.Cost_Input__r.Cost_Grouping__c;
                        /*Implementer name */
                        objWrap.strPayeeName = objBL.Payee__r.Implementer_Name__c;
                        objWrap.strCurrencyUsed = objBL.Currency_Code__c;
                        
                        if(objBL.Unit_Cost_Y1__c == null) objBL.Unit_Cost_Y1__c = 0;
                        if(objBL.Unit_Cost_Y2__c == null) objBL.Unit_Cost_Y2__c = 0;
                        if(objBL.Unit_Cost_Y3__c == null) objBL.Unit_Cost_Y3__c = 0;
                        if(objBL.Unit_Cost_Y4__c == null) objBL.Unit_Cost_Y4__c = 0;
                        
                        if(objBL.FO_Unit_Cost_Y1__c == null) objBL.FO_Unit_Cost_Y1__c = 0;
                        if(objBL.FO_Unit_Cost_Y2__c == null) objBL.FO_Unit_Cost_Y2__c = 0;
                        if(objBL.FO_Unit_Cost_Y3__c == null) objBL.FO_Unit_Cost_Y3__c = 0;
                        if(objBL.FO_Unit_Cost_Y4__c == null) objBL.FO_Unit_Cost_Y4__c = 0;
                        
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
                          
                       /*   if(objBL.FO_Q1_Quantity__c == null) objBL.FO_Q1_Quantity__c = 0;
                        if(objBL.FO_Q2_Quantity__c == null) objBL.FO_Q2_Quantity__c = 0;
                        if(objBL.FO_Q3_Quantity__c == null) objBL.FO_Q3_Quantity__c = 0;
                        if(objBL.FO_Q4_Quantity__c == null) objBL.FO_Q4_Quantity__c = 0;
                        if(objBL.FO_Q5_Quantity__c == null) objBL.FO_Q5_Quantity__c = 0;
                        if(objBL.FO_Q6_Quantity__c == null) objBL.FO_Q6_Quantity__c = 0;
                        if(objBL.FO_Q7_Quantity__c == null) objBL.FO_Q7_Quantity__c = 0;
                        if(objBL.FO_Q8_Quantity__c == null) objBL.FO_Q8_Quantity__c = 0;
                        if(objBL.FO_Q9_Quantity__c == null) objBL.FO_Q9_Quantity__c = 0;
                        if(objBL.FO_Q10_Quantity__c == null) objBL.FO_Q10_Quantity__c = 0;
                        if(objBL.FO_Q11_Quantity__c == null) objBL.FO_Q11_Quantity__c = 0;
                        if(objBL.FO_Q12_Quantity__c == null) objBL.FO_Q12_Quantity__c = 0;
                        if(objBL.FO_Q13_Quantity__c == null) objBL.FO_Q13_Quantity__c = 0;
                        if(objBL.FO_Q14_Quantity__c == null) objBL.FO_Q14_Quantity__c = 0;
                        if(objBL.FO_Q15_Quantity__c == null) objBL.FO_Q15_Quantity__c = 0;
                        if(objBL.FO_Q16_Quantity__c == null) objBL.FO_Q16_Quantity__c = 0;*/
                        
                        if(objBL.FO_Y1_Amount__c == null) objBL.FO_Y1_Amount__c = 0;
                        if(objBL.FO_Y2_Amount__c == null) objBL.FO_Y2_Amount__c = 0;
                        if(objBL.FO_Y3_Amount__c == null) objBL.FO_Y3_Amount__c = 0;
                        if(objBL.FO_Y4_Amount__c == null) objBL.FO_Y4_Amount__c = 0;
                        
                       /************************ Calculation of Amount ***************/
                                         /********* By TCS *********/ 
                        
                         double ExcRate  ;
                         if(imp.Currency_of_Grant_Agreement__c == objBL.Currency_Code__c) ExcRate = 1;
                         else{
                              if(imp.Currency_of_Grant_Agreement__c == 'USD')	ExcRate = imp.Grant__r.Country__r.X200DEMA_Exch_Rate_in_USD__c ;
                              else ExcRate =  imp.Grant__r.Country__r.X200DEMA_Exch_Rate_in_EUR__c; 	
                         }
                        
                         AmountQtr1 = AmountQtr1+ObjBL.Q1_Amount__c*ExcRate;
                         AmountQtr2 = AmountQtr2+ObjBL.Q2_Amount__c*ExcRate;
                         AmountQtr3 = AmountQtr3+ObjBL.Q3_Amount__c*ExcRate;
                         AmountQtr4 = AmountQtr4+ObjBL.Q4_Amount__c*ExcRate;
                         AmountQtr5 = AmountQtr5+ObjBL.Q5_Amount__c*ExcRate;
                         AmountQtr6 = AmountQtr6+ObjBL.Q6_Amount__c*ExcRate;
                         AmountQtr7 = AmountQtr7+ObjBL.Q7_Amount__c*ExcRate;
                         AmountQtr8 = AmountQtr8+ObjBL.Q8_Amount__c*ExcRate;
                         AmountQtr9 = AmountQtr9+ObjBL.Q9_Amount__c*ExcRate;
                         AmountQtr10 = AmountQtr10+ObjBL.Q10_Amount__c*ExcRate;
                         AmountQtr11 = AmountQtr11+ObjBL.Q11_Amount__c*ExcRate;
                         AmountQtr12 = AmountQtr12+ObjBL.Q12_Amount__c*ExcRate;
                         AmountQtr13 = AmountQtr13+ObjBL.Q13_Amount__c*ExcRate; 
                         AmountQtr14 = AmountQtr14+ObjBL.Q14_Amount__c*ExcRate;
                         AmountQtr15 = AmountQtr15+ObjBL.Q15_Amount__c*ExcRate;
                         AmountQtr16 = AmountQtr16+ObjBL.Q16_Amount__c*ExcRate;
                         TotalQtr1 = AmountQtr1 + AmountQtr2 + AmountQtr3 + AmountQtr4 ;
                         TotalQtr2 = AmountQtr5 + AmountQtr6 + AmountQtr7 + AmountQtr8 ;
                         TotalQtr3 = AmountQtr9 + AmountQtr10 + AmountQtr11 + AmountQtr12 ;
                         TotalQtr4 = AmountQtr13 + AmountQtr14 + AmountQtr15 + AmountQtr16 ;
                         GrantTotal = TotalQtr1 + TotalQtr2 + TotalQtr3 + TotalQtr4;
                         system.debug(''+AmountQtr1+'**1**'+AmountQtr5+'**9**'+AmountQtr9+'**13**'+AmountQtr13);
                        
                       /************************* Completed ***********************/ 
                                           
                        
                        
                        if (objBL.Q1_Grant_Amount__c !=  null) objWrap.Q1Case = integer.valueof(objBL.Q1_Grant_Amount__c);
                        else objWrap.Q1Case = 0;
                        if (objBL.Q2_Grant_Amount__c !=  null) objWrap.Q2Case = integer.valueof(objBL.Q2_Grant_Amount__c);
                        else objWrap.Q2Case = 0;
                        if (objBL.Q3_Grant_Amount__c !=  null) objWrap.Q3Case = integer.valueof(objBL.Q3_Grant_Amount__c);
                        else objWrap.Q3Case = 0;
                        if (objBL.Q4_Grant_Amount__c !=  null) objWrap.Q4Case = integer.valueof(objBL.Q4_Grant_Amount__c);
                        else objWrap.Q4Case = 0;
                        if (objBL.Q5_Grant_Amount__c !=  null) objWrap.Q5Case = integer.valueof(objBL.Q5_Grant_Amount__c);
                        else objWrap.Q5Case = 0;
                        if (objBL.Q6_Grant_Amount__c !=  null) objWrap.Q6Case = integer.valueof(objBL.Q6_Grant_Amount__c);
                        else objWrap.Q6Case = 0;
                        if (objBL.Q7_Grant_Amount__c !=  null) objWrap.Q7Case = integer.valueof(objBL.Q7_Grant_Amount__c);
                        else objWrap.Q7Case = 0;
                        if (objBL.Q8_Grant_Amount__c !=  null) objWrap.Q8Case = integer.valueof(objBL.Q8_Grant_Amount__c);
                        else objWrap.Q8Case = 0;
                        if (objBL.Q9_Grant_Amount__c !=  null) objWrap.Q9Case = integer.valueof(objBL.Q9_Grant_Amount__c);
                        else objWrap.Q9Case = 0;
                        if (objBL.Q10_Grant_Amount__c !=  null) objWrap.Q10Case = integer.valueof(objBL.Q10_Grant_Amount__c);
                        else objWrap.Q10Case = 0;
                        if (objBL.Q11_Grant_Amount__c !=  null) objWrap.Q11Case = integer.valueof(objBL.Q11_Grant_Amount__c);
                        else objWrap.Q11Case = 0;
                        if (objBL.Q12_Grant_Amount__c !=  null) objWrap.Q12Case = integer.valueof(objBL.Q12_Grant_Amount__c);
                        else objWrap.Q12Case = 0;
                        if (objBL.Q13_Grant_Amount__c !=  null) objWrap.Q13Case = integer.valueof(objBL.Q13_Grant_Amount__c);
                        else objWrap.Q13Case = 0;
                        if (objBL.Q14_Grant_Amount__c !=  null) objWrap.Q14Case = integer.valueof(objBL.Q14_Grant_Amount__c);
                        else objWrap.Q14Case = 0;
                        if (objBL.Q15_Grant_Amount__c !=  null) objWrap.Q15Case = integer.valueof(objBL.Q15_Grant_Amount__c);
                        else objWrap.Q15Case = 0;
                        if (objBL.Q16_Grant_Amount__c !=  null) objWrap.Q16Case = integer.valueof(objBL.Q16_Grant_Amount__c);
                        else objWrap.Q16Case = 0;
                        
                        objWrap.TotalQuantityYear1 = objBL.Q1_Quantity__c + objBL.Q2_Quantity__c + objBL.Q3_Quantity__c + objBL.Q4_Quantity__c;
                        objWrap.TotalQuantityYear2 = objBL.Q5_Quantity__c + objBL.Q6_Quantity__c + objBL.Q7_Quantity__c + objBL.Q8_Quantity__c;
                        objWrap.TotalQuantityYear3 = objBL.Q9_Quantity__c + objBL.Q10_Quantity__c + objBL.Q11_Quantity__c + objBL.Q12_Quantity__c;
                        objWrap.TotalQuantityYear4 = objBL.Q13_Quantity__c + objBL.Q14_Quantity__c + objBL.Q15_Quantity__c + objBL.Q16_Quantity__c;
                        objWrap.TotalCaseYear1 = objWrap.Q1Case + objWrap.Q2Case + objWrap.Q3Case + objWrap.Q4Case;
                        objWrap.TotalCaseYear2 = objWrap.Q5Case + objWrap.Q6Case + objWrap.Q7Case + objWrap.Q8Case;
                        objWrap.TotalCaseYear3 = objWrap.Q9Case + objWrap.Q10Case + objWrap.Q11Case + objWrap.Q12Case;
                        objWrap.TotalCaseYear4 = objWrap.Q13Case + objWrap.Q14Case + objWrap.Q15Case + objWrap.Q16Case;
                        system.debug('****TotalQuantityYear1$$$$ '+objWrap.TotalQuantityYear1);
                      /*  objWrap.TotalFOQuantityYear1 = objBL.FO_Q1_Quantity__c + objBL.FO_Q2_Quantity__c + objBL.FO_Q3_Quantity__c + objBL.FO_Q4_Quantity__c;
                        objWrap.TotalFOQuantityYear2 = objBL.FO_Q5_Quantity__c + objBL.FO_Q6_Quantity__c + objBL.FO_Q7_Quantity__c + objBL.FO_Q8_Quantity__c;
                        objWrap.TotalFOQuantityYear3 = objBL.FO_Q9_Quantity__c + objBL.FO_Q10_Quantity__c + objBL.FO_Q11_Quantity__c + objBL.FO_Q12_Quantity__c;
                        objWrap.TotalFOQuantityYear4 = objBL.FO_Q13_Quantity__c + objBL.FO_Q14_Quantity__c + objBL.FO_Q15_Quantity__c + objBL.FO_Q16_Quantity__c;
                        */

                        objWrap.GrantTotalQuantity = objWrap.TotalQuantityYear1 + objWrap.TotalQuantityYear2 + objWrap.TotalQuantityYear3 + objWrap.TotalQuantityYear4;
                        objWrap.GrantTotalAmount = objWrap.TotalCaseYear1+ objWrap.TotalCaseYear2+ objWrap.TotalCaseYear3+ objWrap.TotalCaseYear4;
                        /*TCS 28/10/2014: Change for US Detailed Budget Sprint 4*/
                        if((objBL.FO_Unit_Cost_Y1__c != objBL.Unit_Cost_Y1__c) || (objBL.FO_Unit_Cost_Y2__c != objBL.Unit_Cost_Y2__c)||(objBL.FO_Unit_Cost_Y3__c != objBL.Unit_Cost_Y3__c) || (objBL.FO_Unit_Cost_Y4__c != objBL.Unit_Cost_Y4__c)||(objBL.FO_Y1_Amount__c != integer.valueof(objWrap.TotalQuantityYear1)) || (objBL.FO_Y2_Amount__c != integer.valueof(objWrap.TotalQuantityYear2))||(objBL.FO_Y3_Amount__c != integer.valueof(objWrap.TotalQuantityYear3)) || (objBL.FO_Y4_Amount__c != integer.valueof(objWrap.TotalQuantityYear4))|| (objBL.FO_Total_Grant_Quantity_Amount__c != integer.valueof(objWrap.GrantTotalQuantity))){
                        	objWrap.blnSetColor = true;
                        } 
                        
                         /*TCS 28/10/2014: Change Ended*/
                        lstBudgetLines.add(objWrap);
                        
                        /*if(GrantInterventionIds.Contains(objBL.Grant_Intervention__c) == false){
                            GrantInterventionOptions.add(new SelectOption(objBL.Grant_Intervention__c,objBL.Grant_Intervention__r.Name));
                            GrantInterventionIds.add(objBL.Grant_Intervention__c);
                        }*/
                    }
               // }
               
            //}
            FillCostInput();
            FillImplementers();
            FillCostGroup();
            
            /*TCS 16/10/2014: Spring 3 US Gm Detail Budget Changes Start here*/
            /*lstIpDetail = [SELECt Budget_Status__c FROM IP_Detail_Information__c Where Implementation_Period__c =: strImplementationPeriodId];
             if(lstIpDetail.size()>0){
                strBudgetStatus = lstIpDetail[0].Budget_Status__c;
             }*/
             strBudgetStatus = ipde.Budget_Status__c;
             checkProfile();
            //CSInput = new catalog_cost_input__c();
            objBudgetLineNewRow = new Budget_Line__c();
            objBudgetLineNew = new wrapBudgetLines();
            mapBLIdToWrap = new map<Id,wrapBudgetLines>();
            List<Guidance__c> lstGuidanceImp = [Select Id from Guidance__c where Name =:label.GMDetailBudgetGuidance]; 
              if(lstGuidanceImp.size()>0){
                  strImpGuidanceId = lstGuidanceImp[0].id;   
              }
        }
    }
    
    Public void RetriveAssumptionFromSet(){
        if(intIndex!=NULL){
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
                 if(objAssumption.Y2_Quantity__c == null) objAssumption.Y1_Quantity__c = 0;
                 if(objAssumption.Y3_Quantity__c == null) objAssumption.Y1_Quantity__c = 0;
                 if(objAssumption.Y4_Quantity__c == null) objAssumption.Y1_Quantity__c = 0;
                 
                 if(objAssumption.Y1_Net_Salary_Payment_Currency__c == null) objAssumption.Y1_Net_Salary_Payment_Currency__c = 0;
                 //if(objAssumption.Y1_Total_Salary_Payment_Currency__c == null) objAssumption.Y1_Total_Salary_Payment_Currency__c = 0;
                 if(objAssumption.Y1_Level_of_Effort__c == null) objAssumption.Y1_Level_of_Effort__c = 0;
                 if(objAssumption.Y1_Social_Security_Obligatory_Charges__c == null) objAssumption.Y1_Social_Security_Obligatory_Charges__c = 0;
                 if(objAssumption.Y1_Number_of_Persons__c == null) objAssumption.Y1_Number_of_Persons__c = 0;
                 if(objAssumption.Y1_Duration_Days__c == null) objAssumption.Y1_Duration_Days__c = 0;
                 
                 if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                     if(objAssumption.Y1_Total_Salary_Payment_Currency__c != null && objAssumption.Y1_Level_of_Effort__c != null && objAssumption.Y1_Number_of_Persons__c != null)
                     objwrapA.TotalCostY1 = (integer.valueof(objAssumption.Y1_Total_Salary_Payment_Currency__c * objAssumption.Y1_Level_of_Effort__c * objAssumption.Y1_Number_of_Persons__c))/100;
                     if(objAssumption.Y2_Total_Salary_Payment_Currency__c != null && objAssumption.Y2_Level_of_Effort__c != null && objAssumption.Y2_Number_of_Persons__c != null)
                     objwrapA.TotalCostY2 = (integer.valueof(objAssumption.Y2_Total_Salary_Payment_Currency__c * objAssumption.Y2_Level_of_Effort__c * objAssumption.Y2_Number_of_Persons__c))/100;
                     if(objAssumption.Y3_Total_Salary_Payment_Currency__c != null && objAssumption.Y3_Level_of_Effort__c != null && objAssumption.Y3_Number_of_Persons__c != null)
                     objwrapA.TotalCostY3 = (integer.valueof(objAssumption.Y3_Total_Salary_Payment_Currency__c * objAssumption.Y3_Level_of_Effort__c * objAssumption.Y3_Number_of_Persons__c))/100;
                     if(objAssumption.Y4_Total_Salary_Payment_Currency__c != null && objAssumption.Y4_Level_of_Effort__c != null && objAssumption.Y4_Number_of_Persons__c != null)
                     objwrapA.TotalCostY4 = (integer.valueof(objAssumption.Y4_Total_Salary_Payment_Currency__c * objAssumption.Y4_Level_of_Effort__c * objAssumption.Y4_Number_of_Persons__c))/100;
                     
                     objwrapA.TotalSalaryY1 = objAssumption.Y1_Total_Salary_Payment_Currency__c;
                     objwrapA.TotalSalaryY2 = objAssumption.Y2_Total_Salary_Payment_Currency__c;
                     objwrapA.TotalSalaryY3 = objAssumption.Y3_Total_Salary_Payment_Currency__c;
                     objwrapA.TotalSalaryY4 = objAssumption.Y4_Total_Salary_Payment_Currency__c;
                 }else if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '2. Travel related costs (TRC)'){
                     if(objAssumption.Y1_Unit_Cost_Payment_Currency__c != null && objAssumption.Y1_Quantity__c != null && objAssumption.Y1_Duration_Days__c != null)
                     objwrapA.TotalCostY1 = integer.valueof(objAssumption.Y1_Unit_Cost_Payment_Currency__c * objAssumption.Y1_Duration_Days__c * objAssumption.Y1_Quantity__c);
                     if(objAssumption.Y2_Unit_Cost_Payment_Currency__c != null && objAssumption.Y2_Quantity__c != null && objAssumption.Y2_Duration_Days__c != null)
                     objwrapA.TotalCostY2 = integer.valueof(objAssumption.Y2_Unit_Cost_Payment_Currency__c * objAssumption.Y2_Duration_Days__c * objAssumption.Y2_Quantity__c);
                     if(objAssumption.Y3_Unit_Cost_Payment_Currency__c != null && objAssumption.Y3_Quantity__c != null && objAssumption.Y3_Duration_Days__c != null)
                     objwrapA.TotalCostY3 = integer.valueof(objAssumption.Y3_Unit_Cost_Payment_Currency__c * objAssumption.Y3_Duration_Days__c * objAssumption.Y3_Quantity__c);
                     if(objAssumption.Y4_Unit_Cost_Payment_Currency__c != null && objAssumption.Y4_Quantity__c != null && objAssumption.Y4_Duration_Days__c != null)
                     objwrapA.TotalCostY4 = integer.valueof(objAssumption.Y4_Unit_Cost_Payment_Currency__c * objAssumption.Y4_Duration_Days__c * objAssumption.Y4_Quantity__c);
                 }else{
                     if(objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y1_Quantity__c!=null)
                     objwrapA.TotalCostY1 = integer.valueof(objAssumption.Y1_Unit_Cost_Payment_Currency__c * objAssumption.Y1_Quantity__c);
                     
                     if(objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y2_Quantity__c!=null)
                     objwrapA.TotalCostY2 = integer.valueof(objAssumption.Y2_Unit_Cost_Payment_Currency__c * objAssumption.Y2_Quantity__c);
        
                     if(objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y3_Quantity__c!=null)
                     objwrapA.TotalCostY3 = integer.valueof(objAssumption.Y3_Unit_Cost_Payment_Currency__c * objAssumption.Y3_Quantity__c);
                     
                     if(objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objAssumption.Y4_Quantity__c!=null)
                     objwrapA.TotalCostY4 = integer.valueof(objAssumption.Y4_Unit_Cost_Payment_Currency__c * objAssumption.Y4_Quantity__c);
                 }
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
                     if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objwrapA.CurrencyRateInUSDY1;
                     else lstBudgetLines[intIndex].TotalOfAllY1Cost += objwrapA.CurrencyRateInUSDY1;
                 }else if(objwrapA.TotalCostY1!=null){
                     if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objwrapA.TotalCostY1;
                     else lstBudgetLines[intIndex].TotalOfAllY1Cost += objwrapA.TotalCostY1;
                 }
                 if(objwrapA.CurrencyRateInUSDY2!=null){
                     if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objwrapA.CurrencyRateInUSDY2;
                     else lstBudgetLines[intIndex].TotalOfAllY2Cost += objwrapA.CurrencyRateInUSDY2;
                 } else if(objwrapA.TotalCostY2!=null){
                     if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objwrapA.TotalCostY2;
                     else lstBudgetLines[intIndex].TotalOfAllY2Cost += objwrapA.TotalCostY2;
                 }                                
                 if(objwrapA.CurrencyRateInUSDY3!=null){
                     if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objwrapA.CurrencyRateInUSDY3;
                     else lstBudgetLines[intIndex].TotalOfAllY3Cost += objwrapA.CurrencyRateInUSDY3;
                 }else if(objwrapA.TotalCostY3!=null){
                     if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objwrapA.TotalCostY3;
                     else lstBudgetLines[intIndex].TotalOfAllY3Cost += objwrapA.TotalCostY3;
                 }
                 if(objwrapA.CurrencyRateInUSDY4!=null){
                     if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objwrapA.CurrencyRateInUSDY4;
                     else lstBudgetLines[intIndex].TotalOfAllY4Cost += objwrapA.CurrencyRateInUSDY4;
                 }else if(objwrapA.TotalCostY4!=null){
                     if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objwrapA.TotalCostY4;
                     else lstBudgetLines[intIndex].TotalOfAllY4Cost += objwrapA.TotalCostY4;
                 }
                 if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                     if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objwrapA.objAssumption.Y1_Number_of_Persons__c  * objwrapA.objAssumption.Y1_Level_of_Effort__c;
                     else lstBudgetLines[intIndex].TotalQuantityY1 += (objwrapA.objAssumption.Y1_Number_of_Persons__c  * objwrapA.objAssumption.Y1_Level_of_Effort__c);
                     if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objwrapA.objAssumption.Y2_Number_of_Persons__c  * objwrapA.objAssumption.Y2_Level_of_Effort__c;
                     else lstBudgetLines[intIndex].TotalQuantityY2 += (objwrapA.objAssumption.Y2_Number_of_Persons__c * objwrapA.objAssumption.Y2_Level_of_Effort__c);
                     if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objwrapA.objAssumption.Y3_Number_of_Persons__c  * objwrapA.objAssumption.Y3_Level_of_Effort__c;
                     else lstBudgetLines[intIndex].TotalQuantityY3 += (objwrapA.objAssumption.Y3_Number_of_Persons__c * objwrapA.objAssumption.Y3_Level_of_Effort__c);
                     if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objwrapA.objAssumption.Y4_Number_of_Persons__c  * objwrapA.objAssumption.Y4_Level_of_Effort__c;
                     else lstBudgetLines[intIndex].TotalQuantityY4 += (objwrapA.objAssumption.Y4_Number_of_Persons__c * objwrapA.objAssumption.Y4_Level_of_Effort__c);
                 
                     
                 }else{
                      if(objwrapA.objAssumption.Y1_Quantity__c==Null) objwrapA.objAssumption.Y1_Quantity__c=0;
                      if(objwrapA.objAssumption.Y2_Quantity__c==Null) objwrapA.objAssumption.Y2_Quantity__c=0;
                      if(objwrapA.objAssumption.Y3_Quantity__c==Null) objwrapA.objAssumption.Y3_Quantity__c=0;
                      if(objwrapA.objAssumption.Y4_Quantity__c==Null) objwrapA.objAssumption.Y4_Quantity__c=0;
                    
                     if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objwrapA.objAssumption.Y1_Quantity__c;
                     else lstBudgetLines[intIndex].TotalQuantityY1 += objwrapA.objAssumption.Y1_Quantity__c;
                     if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objwrapA.objAssumption.Y2_Quantity__c;
                     else lstBudgetLines[intIndex].TotalQuantityY2 += objwrapA.objAssumption.Y2_Quantity__c;
                     if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objwrapA.objAssumption.Y3_Quantity__c;
                     else lstBudgetLines[intIndex].TotalQuantityY3 += objwrapA.objAssumption.Y3_Quantity__c;
                     if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objwrapA.objAssumption.Y4_Quantity__c;
                     else lstBudgetLines[intIndex].TotalQuantityY4 += objwrapA.objAssumption.Y4_Quantity__c;
                 }
                 
                 lstBudgetLines[intIndex].lstAssumptions.add(objWrapA);
            }    
            if(lstBudgetLines[intIndex].TotalQuantityY1 != null) lstBudgetLines[intIndex].TotalQuantityY1 = lstBudgetLines[intIndex].TotalQuantityY1/100;
            if(lstBudgetLines[intIndex].TotalQuantityY2 != null) lstBudgetLines[intIndex].TotalQuantityY2 = lstBudgetLines[intIndex].TotalQuantityY2/100;
            if(lstBudgetLines[intIndex].TotalQuantityY3 != null) lstBudgetLines[intIndex].TotalQuantityY3 = lstBudgetLines[intIndex].TotalQuantityY3/100;
            if(lstBudgetLines[intIndex].TotalQuantityY4 != null) lstBudgetLines[intIndex].TotalQuantityY4 = lstBudgetLines[intIndex].TotalQuantityY4/100;
            Integer divideAmount = null;
            if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                divideAmount = 4;
            }else{
                divideAmount = 1;
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != 0 && lstBudgetLines[intIndex].TotalQuantityY1 != null){
                lstBudgetLines[intIndex].UnitCostY1 = (lstBudgetLines[intIndex].TotalOfAllY1Cost / lstBudgetLines[intIndex].TotalQuantityY1).setscale(2);
                lstBudgetLines[intIndex].UnitCostY1 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY2 != 0 && lstBudgetLines[intIndex].TotalQuantityY2 != null){
                lstBudgetLines[intIndex].UnitCostY2 = (lstBudgetLines[intIndex].TotalOfAllY2Cost / lstBudgetLines[intIndex].TotalQuantityY2).setscale(2);
                lstBudgetLines[intIndex].UnitCostY2 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY3 != 0 && lstBudgetLines[intIndex].TotalQuantityY3 != null){
                lstBudgetLines[intIndex].UnitCostY3 = (lstBudgetLines[intIndex].TotalOfAllY3Cost / lstBudgetLines[intIndex].TotalQuantityY3).setscale(2);
                lstBudgetLines[intIndex].UnitCostY3 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY4 != 0 && lstBudgetLines[intIndex].TotalQuantityY4 != null){
                lstBudgetLines[intIndex].UnitCostY4 = (lstBudgetLines[intIndex].TotalOfAllY4Cost / lstBudgetLines[intIndex].TotalQuantityY4).setscale(2);
                lstBudgetLines[intIndex].UnitCostY4 /= divideAmount; 
            } 
        }                                           
    }
    
    Public void ChangeCurrencyRateFromCode(){
        String Code = Apexpages.currentpage().getparameters().get('Code');
        Integer ChangeIndex = integer.valueof(Apexpages.currentpage().getparameters().get('ChangeIndex'));
        if(Code != null && ChangeIndex != null && intIndex != null){
            
            if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
             system.debug('$%%%$INNINININI');
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Net_Salary_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Social_Security_Obligatory_Charges__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Level_of_Effort__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Number_of_Persons__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY1 = (integer.valueof((lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Social_Security_Obligatory_Charges__c) * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Level_of_Effort__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Number_of_Persons__c))/100;
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Net_Salary_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Social_Security_Obligatory_Charges__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Level_of_Effort__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Number_of_Persons__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY2 = (integer.valueof((lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Social_Security_Obligatory_Charges__c) * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Level_of_Effort__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Number_of_Persons__c))/100;
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Net_Salary_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Social_Security_Obligatory_Charges__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Level_of_Effort__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Number_of_Persons__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY3 = (integer.valueof((lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Social_Security_Obligatory_Charges__c) * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Level_of_Effort__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Number_of_Persons__c))/100;
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Net_Salary_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Social_Security_Obligatory_Charges__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Level_of_Effort__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Number_of_Persons__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY4 = (integer.valueof((lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Social_Security_Obligatory_Charges__c) * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Level_of_Effort__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Number_of_Persons__c))/100;
             
             system.debug('$%%%$INNINININI'+lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY1);
             
            if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Net_Salary_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Social_Security_Obligatory_Charges__c != null )
            lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalSalaryY1 = lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Social_Security_Obligatory_Charges__c;
            if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Net_Salary_Payment_Currency__c != null  && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Social_Security_Obligatory_Charges__c != null )
            lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalSalaryY2 = lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Social_Security_Obligatory_Charges__c;
            if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Net_Salary_Payment_Currency__c  != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Social_Security_Obligatory_Charges__c != null )
            lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalSalaryY3 = lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Social_Security_Obligatory_Charges__c;
            if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Net_Salary_Payment_Currency__c != null  && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Social_Security_Obligatory_Charges__c != null )
            lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalSalaryY4 = lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Net_Salary_Payment_Currency__c + lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Social_Security_Obligatory_Charges__c;
         }else if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '2. Travel related costs (TRC)'){
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Unit_Cost_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Quantity__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Duration_Days__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY1 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Duration_Days__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Quantity__c);
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Unit_Cost_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Quantity__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Duration_Days__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY2 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Duration_Days__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Quantity__c);
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Unit_Cost_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Quantity__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Duration_Days__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY3 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Duration_Days__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Quantity__c);
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Unit_Cost_Payment_Currency__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Quantity__c != null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Duration_Days__c != null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY4 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Duration_Days__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Quantity__c);
         }else{
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Quantity__c!=null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY1 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y1_Quantity__c);
             
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Quantity__c!=null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY2 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y2_Quantity__c);
    
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Quantity__c!=null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY3 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y3_Quantity__c);
             
             if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Quantity__c!=null)
             lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY4 = integer.valueof(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Unit_Cost_Payment_Currency__c * lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].objAssumption.Y4_Quantity__c);
         }
            
            Double conversionRate;
            system.debug('@##@#@#@#'+Code);
            if(Code == 'Local Currency'){
                conversionRate = conversion_rates.get(strLocalCurrency);
            }else if(Code == 'Other Currency'){
                conversionRate = conversion_rates.get(strOtherCurrency);
            }
            
            
            system.debug('@##@#@#@#'+conversionRate);
            if(conversionRate != null){
                
                if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY1!=null){
                    lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY1 = (lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY1 * conversionRate).setscale(2);
                }
                system.debug('@##@#@#@#'+lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY1);
                if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY2!=null){
                    lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY2 = (lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY2 * conversionRate).setscale(2);
                }
                if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY3!=null){
                    lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY3 = (lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY3 * conversionRate).setscale(2);
                }
                if(lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY4!=null){
                    lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY4 = (lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].TotalCostY4 * conversionRate).setscale(2);
                }
            }else{
                lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY1 = null;
                lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY2 = null;
                lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY3 = null;
                lstBudgetLines[intIndex].lstAssumptions[ChangeIndex].CurrencyRateInUSDY4 = null;
            }
            lstBudgetLines[intIndex].TotalOfAllY1Cost = null;
            lstBudgetLines[intIndex].TotalOfAllY2Cost = null;
            lstBudgetLines[intIndex].TotalOfAllY3Cost = null;
            lstBudgetLines[intIndex].TotalOfAllY4Cost = null;
            
            lstBudgetLines[intIndex].TotalQuantityY1 = null;
            lstBudgetLines[intIndex].TotalQuantityY2 = null;
            lstBudgetLines[intIndex].TotalQuantityY3 = null;
            lstBudgetLines[intIndex].TotalQuantityY4 = null;
            
            for(wrapAssumption objA: lstBudgetLines[intIndex].lstAssumptions){
                if(objA.objAssumption.Y1_Quantity__c == null) objA.objAssumption.Y1_Quantity__c = 0;
                if(objA.objAssumption.Y2_Quantity__c == null) objA.objAssumption.Y2_Quantity__c = 0;
                if(objA.objAssumption.Y3_Quantity__c == null) objA.objAssumption.Y3_Quantity__c = 0;
                if(objA.objAssumption.Y4_Quantity__c == null) objA.objAssumption.Y4_Quantity__c = 0;
                
                if(objA.CurrencyRateInUSDY1!=null){                      
                    if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objA.CurrencyRateInUSDY1;
                    else lstBudgetLines[intIndex].TotalOfAllY1Cost += objA.CurrencyRateInUSDY1;
                }else if(objA.TotalCostY1!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objA.TotalCostY1;
                    else lstBudgetLines[intIndex].TotalOfAllY1Cost += objA.TotalCostY1;
                }
                if(objA.CurrencyRateInUSDY2!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objA.CurrencyRateInUSDY2;
                    else lstBudgetLines[intIndex].TotalOfAllY2Cost += objA.CurrencyRateInUSDY2;
                } else if(objA.TotalCostY2!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objA.TotalCostY2;
                    else lstBudgetLines[intIndex].TotalOfAllY2Cost += objA.TotalCostY2;
                }                                
                if(objA.CurrencyRateInUSDY3!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objA.CurrencyRateInUSDY3;
                    else lstBudgetLines[intIndex].TotalOfAllY3Cost += objA.CurrencyRateInUSDY3;
                }else if(objA.TotalCostY3!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objA.TotalCostY3;
                    else lstBudgetLines[intIndex].TotalOfAllY3Cost += objA.TotalCostY3;
                }
                if(objA.CurrencyRateInUSDY4!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objA.CurrencyRateInUSDY4;
                    else lstBudgetLines[intIndex].TotalOfAllY4Cost += objA.CurrencyRateInUSDY4;
                }else if(objA.TotalCostY4!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objA.TotalCostY4;
                    else lstBudgetLines[intIndex].TotalOfAllY4Cost += objA.TotalCostY4;
                }
             if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                 if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objA.objAssumption.Y1_Number_of_Persons__c * objA.objAssumption.Y1_Level_of_Effort__c;
                 else lstBudgetLines[intIndex].TotalQuantityY1 += (objA.objAssumption.Y1_Number_of_Persons__c * objA.objAssumption.Y1_Level_of_Effort__c);
                 if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objA.objAssumption.Y2_Number_of_Persons__c * objA.objAssumption.Y2_Level_of_Effort__c;
                 else lstBudgetLines[intIndex].TotalQuantityY2 += (objA.objAssumption.Y2_Number_of_Persons__c * objA.objAssumption.Y2_Level_of_Effort__c);
                 if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objA.objAssumption.Y3_Number_of_Persons__c * objA.objAssumption.Y3_Level_of_Effort__c;
                 else lstBudgetLines[intIndex].TotalQuantityY3 += (objA.objAssumption.Y3_Number_of_Persons__c * objA.objAssumption.Y3_Level_of_Effort__c);
                 if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objA.objAssumption.Y4_Number_of_Persons__c * objA.objAssumption.Y4_Level_of_Effort__c;
                 else lstBudgetLines[intIndex].TotalQuantityY4 += (objA.objAssumption.Y4_Number_of_Persons__c * objA.objAssumption.Y4_Level_of_Effort__c);
                
                 
             }else{
                if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objA.objAssumption.Y1_Quantity__c;
                else lstBudgetLines[intIndex].TotalQuantityY1 += objA.objAssumption.Y1_Quantity__c;
                if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objA.objAssumption.Y2_Quantity__c;
                else lstBudgetLines[intIndex].TotalQuantityY2 += objA.objAssumption.Y2_Quantity__c;
                if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objA.objAssumption.Y3_Quantity__c;
                else lstBudgetLines[intIndex].TotalQuantityY3 += objA.objAssumption.Y3_Quantity__c;
                if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objA.objAssumption.Y4_Quantity__c;
                else lstBudgetLines[intIndex].TotalQuantityY4 += objA.objAssumption.Y4_Quantity__c;
            }
                
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != null) lstBudgetLines[intIndex].TotalQuantityY1 = lstBudgetLines[intIndex].TotalQuantityY1/100;
            if(lstBudgetLines[intIndex].TotalQuantityY2 != null) lstBudgetLines[intIndex].TotalQuantityY2 = lstBudgetLines[intIndex].TotalQuantityY2/100;
            if(lstBudgetLines[intIndex].TotalQuantityY3 != null) lstBudgetLines[intIndex].TotalQuantityY3 = lstBudgetLines[intIndex].TotalQuantityY3/100;
            if(lstBudgetLines[intIndex].TotalQuantityY4 != null) lstBudgetLines[intIndex].TotalQuantityY4 = lstBudgetLines[intIndex].TotalQuantityY4/100;
            Integer divideAmount = null;
            if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                divideAmount = 4;
            }else{
                divideAmount = 1;
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != 0 && lstBudgetLines[intIndex].TotalQuantityY1 != null){
                lstBudgetLines[intIndex].UnitCostY1 = (lstBudgetLines[intIndex].TotalOfAllY1Cost / lstBudgetLines[intIndex].TotalQuantityY1).setscale(2);
                lstBudgetLines[intIndex].UnitCostY1 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY2 != 0 && lstBudgetLines[intIndex].TotalQuantityY2 != null){
                lstBudgetLines[intIndex].UnitCostY2 =(lstBudgetLines[intIndex].TotalOfAllY2Cost / lstBudgetLines[intIndex].TotalQuantityY2).setscale(2);
                lstBudgetLines[intIndex].UnitCostY2 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY3 != 0 && lstBudgetLines[intIndex].TotalQuantityY3 != null){
                lstBudgetLines[intIndex].UnitCostY3 = (lstBudgetLines[intIndex].TotalOfAllY3Cost / lstBudgetLines[intIndex].TotalQuantityY3).setscale(2);
                lstBudgetLines[intIndex].UnitCostY3 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY4 != 0 && lstBudgetLines[intIndex].TotalQuantityY4 != null){
                lstBudgetLines[intIndex].UnitCostY4 = (lstBudgetLines[intIndex].TotalOfAllY4Cost / lstBudgetLines[intIndex].TotalQuantityY4).setscale(2);
                lstBudgetLines[intIndex].UnitCostY4 /= divideAmount; 
            }
        }
    } 
    
    Public void ChangeCurrencyRateFromCodeNew(){
        String Code = Apexpages.currentpage().getparameters().get('Code');
        
        if(Code != null && intIndex != null){
            system.debug('$%%%$%$%'+Code);
         if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
             system.debug('$%%%$INNINININI');
             if(objNewAssumption.objAssumption.Y1_Net_Salary_Payment_Currency__c != null && objNewAssumption.objAssumption.Y1_Social_Security_Obligatory_Charges__c != null && objNewAssumption.objAssumption.Y1_Level_of_Effort__c != null && objNewAssumption.objAssumption.Y1_Number_of_Persons__c != null)
             objNewAssumption.TotalCostY1 = (integer.valueof((objNewAssumption.objAssumption.Y1_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y1_Social_Security_Obligatory_Charges__c) * objNewAssumption.objAssumption.Y1_Level_of_Effort__c * objNewAssumption.objAssumption.Y1_Number_of_Persons__c))/100;
             if(objNewAssumption.objAssumption.Y2_Net_Salary_Payment_Currency__c != null && objNewAssumption.objAssumption.Y2_Social_Security_Obligatory_Charges__c != null && objNewAssumption.objAssumption.Y2_Level_of_Effort__c != null && objNewAssumption.objAssumption.Y2_Number_of_Persons__c != null)
             objNewAssumption.TotalCostY2 = (integer.valueof((objNewAssumption.objAssumption.Y2_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y2_Social_Security_Obligatory_Charges__c) * objNewAssumption.objAssumption.Y2_Level_of_Effort__c * objNewAssumption.objAssumption.Y2_Number_of_Persons__c))/100;
             if(objNewAssumption.objAssumption.Y3_Net_Salary_Payment_Currency__c != null && objNewAssumption.objAssumption.Y3_Social_Security_Obligatory_Charges__c != null && objNewAssumption.objAssumption.Y3_Level_of_Effort__c != null && objNewAssumption.objAssumption.Y3_Number_of_Persons__c != null)
             objNewAssumption.TotalCostY3 = (integer.valueof((objNewAssumption.objAssumption.Y3_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y3_Social_Security_Obligatory_Charges__c) * objNewAssumption.objAssumption.Y3_Level_of_Effort__c * objNewAssumption.objAssumption.Y3_Number_of_Persons__c))/100;
             if(objNewAssumption.objAssumption.Y4_Net_Salary_Payment_Currency__c != null && objNewAssumption.objAssumption.Y4_Social_Security_Obligatory_Charges__c != null && objNewAssumption.objAssumption.Y4_Level_of_Effort__c != null && objNewAssumption.objAssumption.Y4_Number_of_Persons__c != null)
             objNewAssumption.TotalCostY4 = (integer.valueof((objNewAssumption.objAssumption.Y4_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y4_Social_Security_Obligatory_Charges__c) * objNewAssumption.objAssumption.Y4_Level_of_Effort__c * objNewAssumption.objAssumption.Y4_Number_of_Persons__c))/100;
             
             system.debug('$%%%$INNINININI'+objNewAssumption.TotalCostY1);
             
            if(objNewAssumption.objAssumption.Y1_Net_Salary_Payment_Currency__c != null && objNewAssumption.objAssumption.Y1_Social_Security_Obligatory_Charges__c != null )
            objNewAssumption.TotalSalaryY1 = objNewAssumption.objAssumption.Y1_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y1_Social_Security_Obligatory_Charges__c;
            if(objNewAssumption.objAssumption.Y2_Net_Salary_Payment_Currency__c != null  && objNewAssumption.objAssumption.Y2_Social_Security_Obligatory_Charges__c != null )
            objNewAssumption.TotalSalaryY2 = objNewAssumption.objAssumption.Y2_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y2_Social_Security_Obligatory_Charges__c;
            if(objNewAssumption.objAssumption.Y3_Net_Salary_Payment_Currency__c  != null && objNewAssumption.objAssumption.Y3_Social_Security_Obligatory_Charges__c != null )
            objNewAssumption.TotalSalaryY3 = objNewAssumption.objAssumption.Y3_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y3_Social_Security_Obligatory_Charges__c;
            if(objNewAssumption.objAssumption.Y4_Net_Salary_Payment_Currency__c != null  && objNewAssumption.objAssumption.Y4_Social_Security_Obligatory_Charges__c != null )
            objNewAssumption.TotalSalaryY4 = objNewAssumption.objAssumption.Y4_Net_Salary_Payment_Currency__c + objNewAssumption.objAssumption.Y4_Social_Security_Obligatory_Charges__c;
         }else if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '2. Travel related costs (TRC)'){
             if(objNewAssumption.objAssumption.Y1_Unit_Cost_Payment_Currency__c != null && objNewAssumption.objAssumption.Y1_Quantity__c != null && objNewAssumption.objAssumption.Y1_Duration_Days__c != null)
             objNewAssumption.TotalCostY1 = integer.valueof(objNewAssumption.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y1_Duration_Days__c * objNewAssumption.objAssumption.Y1_Quantity__c);
             if(objNewAssumption.objAssumption.Y2_Unit_Cost_Payment_Currency__c != null && objNewAssumption.objAssumption.Y2_Quantity__c != null && objNewAssumption.objAssumption.Y2_Duration_Days__c != null)
             objNewAssumption.TotalCostY2 = integer.valueof(objNewAssumption.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y2_Duration_Days__c * objNewAssumption.objAssumption.Y2_Quantity__c);
             if(objNewAssumption.objAssumption.Y3_Unit_Cost_Payment_Currency__c != null && objNewAssumption.objAssumption.Y3_Quantity__c != null && objNewAssumption.objAssumption.Y3_Duration_Days__c != null)
             objNewAssumption.TotalCostY3 = integer.valueof(objNewAssumption.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y3_Duration_Days__c * objNewAssumption.objAssumption.Y3_Quantity__c);
             if(objNewAssumption.objAssumption.Y4_Unit_Cost_Payment_Currency__c != null && objNewAssumption.objAssumption.Y4_Quantity__c != null && objNewAssumption.objAssumption.Y4_Duration_Days__c != null)
             objNewAssumption.TotalCostY4 = integer.valueof(objNewAssumption.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y4_Duration_Days__c * objNewAssumption.objAssumption.Y4_Quantity__c);
         }else{
             if(objNewAssumption.objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y1_Quantity__c!=null)
             objNewAssumption.TotalCostY1 = integer.valueof(objNewAssumption.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y1_Quantity__c);
             
             if(objNewAssumption.objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y2_Quantity__c!=null)
             objNewAssumption.TotalCostY2 = integer.valueof(objNewAssumption.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y2_Quantity__c);
    
             if(objNewAssumption.objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y3_Quantity__c!=null)
             objNewAssumption.TotalCostY3 = integer.valueof(objNewAssumption.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y3_Quantity__c);
             
             if(objNewAssumption.objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objNewAssumption.objAssumption.Y4_Quantity__c!=null)
             objNewAssumption.TotalCostY4 = integer.valueof(objNewAssumption.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objNewAssumption.objAssumption.Y4_Quantity__c);
         }
        
            Double conversionRate;
            system.debug('@##@#@#@#'+Code);
            if(Code == 'Local Currency'){
                conversionRate = conversion_rates.get(strLocalCurrency);
            }else if(Code == 'Other Currency'){
                conversionRate = conversion_rates.get(strOtherCurrency);
            }
            system.debug('@##@#@#@#'+conversionRate);
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
            
            lstBudgetLines[intIndex].TotalOfAllY1Cost = null;
            lstBudgetLines[intIndex].TotalOfAllY2Cost = null;
            lstBudgetLines[intIndex].TotalOfAllY3Cost = null;
            lstBudgetLines[intIndex].TotalOfAllY4Cost = null;
            lstBudgetLines[intIndex].TotalQuantityY1 = null;
            lstBudgetLines[intIndex].TotalQuantityY2 = null;
            lstBudgetLines[intIndex].TotalQuantityY3 = null;
            lstBudgetLines[intIndex].TotalQuantityY4 = null;
            if(lstBudgetLines[intIndex].lstAssumptions != null && lstBudgetLines[intIndex].lstAssumptions.size() > 0){
                for(wrapAssumption objA: lstBudgetLines[intIndex].lstAssumptions){
                    
                    
                    if(objA.CurrencyRateInUSDY1!=null){                      
                        if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objA.CurrencyRateInUSDY1;
                        else lstBudgetLines[intIndex].TotalOfAllY1Cost += objA.CurrencyRateInUSDY1;
                    }else if(objA.TotalCostY1!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objA.TotalCostY1;
                        else lstBudgetLines[intIndex].TotalOfAllY1Cost += objA.TotalCostY1;
                    }
                    if(objA.CurrencyRateInUSDY2!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objA.CurrencyRateInUSDY2;
                        else lstBudgetLines[intIndex].TotalOfAllY2Cost += objA.CurrencyRateInUSDY2;
                    } else if(objA.TotalCostY2!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objA.TotalCostY2;
                        else lstBudgetLines[intIndex].TotalOfAllY2Cost += objA.TotalCostY2;
                    }                                
                    if(objA.CurrencyRateInUSDY3!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objA.CurrencyRateInUSDY3;
                        else lstBudgetLines[intIndex].TotalOfAllY3Cost += objA.CurrencyRateInUSDY3;
                    }else if(objA.TotalCostY3!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objA.TotalCostY3;
                        else lstBudgetLines[intIndex].TotalOfAllY3Cost += objA.TotalCostY3;
                    }
                    if(objA.CurrencyRateInUSDY4!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objA.CurrencyRateInUSDY4;
                        else lstBudgetLines[intIndex].TotalOfAllY4Cost += objA.CurrencyRateInUSDY4;
                    }else if(objA.TotalCostY4!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objA.TotalCostY4;
                        else lstBudgetLines[intIndex].TotalOfAllY4Cost += objA.TotalCostY4;
                    }
                    if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                         if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objA.objAssumption.Y1_Number_of_Persons__c * objA.objAssumption.Y1_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY1 += (objA.objAssumption.Y1_Number_of_Persons__c * objA.objAssumption.Y1_Level_of_Effort__c);
                         if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objA.objAssumption.Y2_Number_of_Persons__c * objA.objAssumption.Y2_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY2 += (objA.objAssumption.Y2_Number_of_Persons__c * objA.objAssumption.Y2_Level_of_Effort__c);
                         if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objA.objAssumption.Y3_Number_of_Persons__c * objA.objAssumption.Y3_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY3 += (objA.objAssumption.Y3_Number_of_Persons__c * objA.objAssumption.Y3_Level_of_Effort__c);
                         if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objA.objAssumption.Y4_Number_of_Persons__c * objA.objAssumption.Y4_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY4 += (objA.objAssumption.Y4_Number_of_Persons__c * objA.objAssumption.Y4_Level_of_Effort__c);
                    
                        
                     }else{
                        if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objA.objAssumption.Y1_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY1 += objA.objAssumption.Y1_Quantity__c;
                        if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objA.objAssumption.Y2_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY2 += objA.objAssumption.Y2_Quantity__c;
                        if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objA.objAssumption.Y3_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY3 += objA.objAssumption.Y3_Quantity__c;
                        if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objA.objAssumption.Y4_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY4 += objA.objAssumption.Y4_Quantity__c;
                    }
                    
                    
                }
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != null) lstBudgetLines[intIndex].TotalQuantityY1 = lstBudgetLines[intIndex].TotalQuantityY1/100;
            if(lstBudgetLines[intIndex].TotalQuantityY2 != null) lstBudgetLines[intIndex].TotalQuantityY2 = lstBudgetLines[intIndex].TotalQuantityY2/100;
            if(lstBudgetLines[intIndex].TotalQuantityY3 != null) lstBudgetLines[intIndex].TotalQuantityY3 = lstBudgetLines[intIndex].TotalQuantityY3/100;
            if(lstBudgetLines[intIndex].TotalQuantityY4 != null) lstBudgetLines[intIndex].TotalQuantityY4 = lstBudgetLines[intIndex].TotalQuantityY4/100;
            Integer divideAmount = null;
            if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                divideAmount = 4;
            }else{
                divideAmount = 1;
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != 0 && lstBudgetLines[intIndex].TotalQuantityY1 != null){
                lstBudgetLines[intIndex].UnitCostY1 = (lstBudgetLines[intIndex].TotalOfAllY1Cost / lstBudgetLines[intIndex].TotalQuantityY1).setscale(2);
                lstBudgetLines[intIndex].UnitCostY1 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY2 != 0 && lstBudgetLines[intIndex].TotalQuantityY2 != null){
                lstBudgetLines[intIndex].UnitCostY2 = (lstBudgetLines[intIndex].TotalOfAllY2Cost / lstBudgetLines[intIndex].TotalQuantityY2).setscale(2);
                lstBudgetLines[intIndex].UnitCostY2 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY3 != 0 && lstBudgetLines[intIndex].TotalQuantityY3 != null){
                lstBudgetLines[intIndex].UnitCostY3 = (lstBudgetLines[intIndex].TotalOfAllY3Cost / lstBudgetLines[intIndex].TotalQuantityY3).setscale(2);
                lstBudgetLines[intIndex].UnitCostY3 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY4 != 0 && lstBudgetLines[intIndex].TotalQuantityY4 != null){
                lstBudgetLines[intIndex].UnitCostY4 = (lstBudgetLines[intIndex].TotalOfAllY4Cost / lstBudgetLines[intIndex].TotalQuantityY4).setscale(2);
                lstBudgetLines[intIndex].UnitCostY4 /= divideAmount; 
            }
            if(objNewAssumption.objAssumption.Y1_Quantity__c == null) objNewAssumption.objAssumption.Y1_Quantity__c = 0;
            if(objNewAssumption.objAssumption.Y2_Quantity__c == null) objNewAssumption.objAssumption.Y2_Quantity__c = 0;
            if(objNewAssumption.objAssumption.Y3_Quantity__c == null) objNewAssumption.objAssumption.Y3_Quantity__c = 0;
            if(objNewAssumption.objAssumption.Y4_Quantity__c == null) objNewAssumption.objAssumption.Y4_Quantity__c = 0;
            
            if(objNewAssumption.objAssumption.Y1_Number_of_Persons__c == null) objNewAssumption.objAssumption.Y1_Number_of_Persons__c = 0;
            if(objNewAssumption.objAssumption.Y2_Number_of_Persons__c == null) objNewAssumption.objAssumption.Y2_Number_of_Persons__c = 0;
            if(objNewAssumption.objAssumption.Y3_Number_of_Persons__c == null) objNewAssumption.objAssumption.Y3_Number_of_Persons__c = 0;
            if(objNewAssumption.objAssumption.Y4_Number_of_Persons__c == null) objNewAssumption.objAssumption.Y4_Number_of_Persons__c = 0;
             if(objNewAssumption.objAssumption.Y1_Level_of_Effort__c == null) objNewAssumption.objAssumption.Y1_Level_of_Effort__c = 0;
             if(objNewAssumption.objAssumption.Y2_Level_of_Effort__c == null) objNewAssumption.objAssumption.Y2_Level_of_Effort__c = 0;
             if(objNewAssumption.objAssumption.Y3_Level_of_Effort__c == null) objNewAssumption.objAssumption.Y3_Level_of_Effort__c = 0;
             if(objNewAssumption.objAssumption.Y4_Level_of_Effort__c == null) objNewAssumption.objAssumption.Y4_Level_of_Effort__c = 0;
            
            if(objNewAssumption.CurrencyRateInUSDY1!=null){                      
                if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objNewAssumption.CurrencyRateInUSDY1;
                else lstBudgetLines[intIndex].TotalOfAllY1Cost += objNewAssumption.CurrencyRateInUSDY1;
            }else if(objNewAssumption.TotalCostY1!=null){
                if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objNewAssumption.TotalCostY1;
                else lstBudgetLines[intIndex].TotalOfAllY1Cost += objNewAssumption.TotalCostY1;
            }
            if(objNewAssumption.CurrencyRateInUSDY2!=null){
                if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objNewAssumption.CurrencyRateInUSDY2;
                else lstBudgetLines[intIndex].TotalOfAllY2Cost += objNewAssumption.CurrencyRateInUSDY2;
            } else if(objNewAssumption.TotalCostY2!=null){
                if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objNewAssumption.TotalCostY2;
                else lstBudgetLines[intIndex].TotalOfAllY2Cost += objNewAssumption.TotalCostY2;
            }                                
            if(objNewAssumption.CurrencyRateInUSDY3!=null){
                if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objNewAssumption.CurrencyRateInUSDY3;
                else lstBudgetLines[intIndex].TotalOfAllY3Cost += objNewAssumption.CurrencyRateInUSDY3;
            }else if(objNewAssumption.TotalCostY3!=null){
                if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objNewAssumption.TotalCostY3;
                else lstBudgetLines[intIndex].TotalOfAllY3Cost += objNewAssumption.TotalCostY3;
            }
            if(objNewAssumption.CurrencyRateInUSDY4!=null){
                if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objNewAssumption.CurrencyRateInUSDY4;
                else lstBudgetLines[intIndex].TotalOfAllY4Cost += objNewAssumption.CurrencyRateInUSDY4;
            }else if(objNewAssumption.TotalCostY4!=null){
                if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objNewAssumption.TotalCostY4;
                else lstBudgetLines[intIndex].TotalOfAllY4Cost += objNewAssumption.TotalCostY4;
            }               
        }
    } 
    
   /******************************************* Selection Option for Cost Grouping ************/
                                                /************* By TCS ***********/
    Public void FillCostInput(){
        CostInputOptions = new List<SelectOption>();
        MapCostInput = new Map<Id,String>();
        List<Catalog_Cost_Input__c> lstCostInput = [Select Id,Name, Cost_Grouping__c, Unit_Cost_Definition__c 
                                            From Catalog_Cost_Input__c 
                                            Where PSM__c = false AND NAME!=: 'All' AND Is_Inactive__c =: False
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
    
   /***************************************** Completed ******************************/ 
    
    Public void FillCostGroup(){
        AllCostGrpOptions =  new List<Selectoption>(); 
       Schema.DescribeFieldResult fieldResult = Catalog_Cost_Input__c.Cost_Grouping__c.getDescribe();
       AllCostGrpOptions.add(new SelectOption('', '-- None --'));
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for(Schema.PicklistEntry f : ple){
          AllCostGrpOptions.add(new SelectOption(f.getLabel(), f.getValue()));
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
    
        
    Public wrapBudgetLines fillwraperObject(Budget_Line__c objBL){
        wrapBudgetLines objWrap = new wrapBudgetLines();
        objWrap.objBudgetLine = new Budget_Line__c();
        objWrap.objBudgetLine = objBL;
        objWrap.blnIsEditable = true;
        objWrap.strUnitCostMeasure = objBL.Cost_Input__r.Unit_Cost_Definition__c;
        objWrap.strGIName = objBL.Grant_Intervention__r.Name;
        objWrap.strCostInputName = objBL.Cost_Input__r.Name;
        objWrap.strCostGrouping = objBL.Cost_Input__r.Cost_Grouping__c;
        /* Implementer Name change*/
        objWrap.strPayeeName = objBL.Payee__r.Implementer_Name__c;
         /* Implementer Name change*/
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
        
        objWrap.Q1Case = integer.valueof(objBL.Q1_Grant_Amount__c);
        objWrap.Q2Case = integer.valueof(objBL.Q2_Grant_Amount__c);
        objWrap.Q3Case = integer.valueof(objBL.Q3_Grant_Amount__c);
        objWrap.Q4Case = integer.valueof(objBL.Q4_Grant_Amount__c);
        objWrap.Q5Case = integer.valueof(objBL.Q5_Grant_Amount__c);
        objWrap.Q6Case = integer.valueof(objBL.Q6_Grant_Amount__c);
        objWrap.Q7Case = integer.valueof(objBL.Q7_Grant_Amount__c);
        objWrap.Q8Case = integer.valueof(objBL.Q8_Grant_Amount__c);
        objWrap.Q9Case = integer.valueof(objBL.Q9_Grant_Amount__c);
        objWrap.Q10Case = integer.valueof(objBL.Q10_Grant_Amount__c);
        objWrap.Q11Case = integer.valueof(objBL.Q11_Grant_Amount__c);
        objWrap.Q12Case = integer.valueof(objBL.Q12_Grant_Amount__c);
        objWrap.Q13Case = integer.valueof(objBL.Q13_Grant_Amount__c);
        objWrap.Q14Case = integer.valueof(objBL.Q14_Grant_Amount__c);
        objWrap.Q15Case = integer.valueof(objBL.Q15_Grant_Amount__c);
        objWrap.Q16Case = integer.valueof(objBL.Q16_Grant_Amount__c);   
        objWrap.TotalCaseYear1=0;
        objWrap.TotalQuantityYear1 = objBL.Q1_Quantity__c + objBL.Q2_Quantity__c + objBL.Q3_Quantity__c + objBL.Q4_Quantity__c;
        objWrap.TotalQuantityYear2 = objBL.Q5_Quantity__c + objBL.Q6_Quantity__c + objBL.Q7_Quantity__c + objBL.Q8_Quantity__c;
        objWrap.TotalQuantityYear3 = objBL.Q9_Quantity__c + objBL.Q10_Quantity__c + objBL.Q11_Quantity__c + objBL.Q12_Quantity__c;
        objWrap.TotalQuantityYear4 = objBL.Q13_Quantity__c + objBL.Q14_Quantity__c + objBL.Q15_Quantity__c + objBL.Q16_Quantity__c;
        system.debug('Total'+objwrap.TotalcaseYear1+':::objwrap.Q1case::'+objwrap.Q1case+':::Q2case::'+objwrap.Q2case+'::ObjWrap.Q3Case::'+ObjWrap.Q3Case+'::ObjWrap.Q4Case::'+ObjWrap.Q4Case);
        if(objWrap.Q1Case==Null) 
            objWrap.Q1Case = 0;
        if(objWrap.Q2Case==Null) 
            objWrap.Q2Case = 0;
        if(objWrap.Q3Case==Null) 
            objWrap.Q3Case = 0;
        if(objWrap.Q4Case==Null) 
            objWrap.Q4Case = 0;
        if(objWrap.Q5Case==Null) 
            objWrap.Q5Case = 0;
        if(objWrap.Q6Case==Null) 
            objWrap.Q6Case = 0;
        if(objWrap.Q7Case==Null) 
            objWrap.Q7Case = 0;
        if(objWrap.Q8Case==Null) 
            objWrap.Q8Case = 0;
         if(objWrap.Q9Case==Null) 
            objWrap.Q9Case = 0;
         if(objWrap.Q10Case==Null) 
            objWrap.Q10Case = 0;
         if(objWrap.Q11Case==Null) 
            objWrap.Q11Case = 0;
         if(objWrap.Q12Case==Null) 
            objWrap.Q12Case = 0;
         if(objWrap.Q13Case==Null) 
            objWrap.Q13Case = 0;
         if(objWrap.Q14Case==Null) 
            objWrap.Q14Case = 0;
         if(objWrap.Q15Case==Null) 
            objWrap.Q15Case = 0;
         if(objWrap.Q16Case==Null) 
            objWrap.Q16Case = 0;
                                                                 
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
        List<Budget_Line__c> lstBudgetLineRetrive = [Select Cost_Grouping__c ,Cost_Input__r.Is_Inactive__c,Q1_Quantity__c,Q1_Amount__c,Q2_Quantity__c,Q2_Amount__c,
                                                    Q3_Quantity__c,Q3_Amount__c,Q4_Quantity__c,Q4_Amount__c,
                                                    Q5_Quantity__c,Q5_Amount__c,Q6_Quantity__c,Q6_Amount__c,
                                                    Q7_Quantity__c,Q7_Amount__c,Q8_Quantity__c,Q8_Amount__c,
                                                    Q9_Quantity__c,Q9_Amount__c,Q10_Quantity__c,Q10_Amount__c,
                                                    Q11_Quantity__c,Q11_Amount__c,Q12_Quantity__c,Q12_Amount__c,
                                                    Q13_Quantity__c,Q13_Amount__c,Q14_Quantity__c,Q14_Amount__c,
                                                    Q15_Quantity__c,Q15_Amount__c,Q16_Quantity__c,Q16_Amount__c,
                                                    Q1_Grant_Amount__c,Q2_Grant_Amount__c,Q3_Grant_Amount__c,
                                                    Q4_Grant_Amount__c,Q5_Grant_Amount__c,Q6_Grant_Amount__c,
                                                    Q7_Grant_Amount__c,Q8_Grant_Amount__c,Q9_Grant_Amount__c,
                                                    Q10_Grant_Amount__c,Q11_Grant_Amount__c,Q12_Grant_Amount__c,
                                                    Q13_Grant_Amount__c,Q14_Grant_Amount__c,Q15_Grant_Amount__c,
                                                    PR_Comments__c,LFA_Comments__c ,TGF_Comments__c,Q16_Grant_Amount__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_TGF_Comment__c, 
                                                    Activity__c,Cost_Input__c, Currency_Code__c, Currency_Used__c,Grant_Intervention__c,LFA_Unit_Cost_Y1__c,LFA_Unit_Cost_Y2__c,LFA_Unit_Cost_Y3__c,LFA_Unit_Cost_Y4__c,LFA_Y1_Amount__c,LFA_Y2_Amount__c,LFA_Y3_Amount__c,LFA_Y4_Amount__c,
                                                    Y1_Grant_Amount__c,Y2_Grant_Amount__c,Y3_Grant_Amount__c,Unit_Cost_Y1__c,Unit_Cost_Y2__c,Unit_Cost_Y3__c,Unit_Cost_Y4__c,
                                                    Cost_Input__r.Unit_Cost_Definition__c, Cost_Input__r.Cost_Grouping__c, Payee__c,Payee__r.Implementer_Name__c,
                                                    Cost_Input__r.Name,Y4_Grant_Amount__c,Grant_Intervention__r.Name,FO_Y1_Amount__c,FO_Y2_Amount__c,FO_Y3_Amount__c,FO_Y4_Amount__c,LFA_Flag__c,FO_Total_Grant_Quantity_Amount__c,
                                                FO_Unit_Cost_Y1__c,FO_Unit_Cost_Y2__c,FO_Unit_Cost_Y3__c,FO_Unit_Cost_Y4__c 
                                                    From Budget_Line__c Where Id =: BudgetLineId Order BY Grant_Intervention__r.Name];
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
                objBudgetLineNewRow.Budget_Line_Number__c = SaveIndex;
                objBudgetLineNewRow.Currency_Used__c = objBudgetLineNew.strCurrencyUsed;
                system.debug('Currency'+objBudgetLineNew.strCurrencyUsed);
                //objBudgetLineNewRow.Cost_Grouping__c = objBudgetLineNew.strCostGrouping;
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
                
                objBudgetLineNewRow.Q1_Amount__c = (objBudgetLineNewRow.Unit_Cost_Y1__c * objBudgetLineNewRow.Q1_Quantity__c ).setScale(2);
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
                
              /********************** Assign value of CostGrouping *******************/
                //objBudgetLineNewRow.Cost_Grouping__c = objBudgetLineNew.strCostGrp;
               // objBudgetLineNew.strCostGrp = Null; // for checking
                
              /*************************** Calculate total of Qtr's on  **********************/  
              /*************************** Creation of new Budget line   **********************/
                double ExcRate  ;
                 if(imp.Currency_of_Grant_Agreement__c == objBudgetLineNewRow.Currency_Code__c) ExcRate = 1;
                 else{
                      if(imp.Currency_of_Grant_Agreement__c == 'USD')	ExcRate = imp.Grant__r.Country__r.X200DEMA_Exch_Rate_in_USD__c ;
                      else ExcRate =  imp.Grant__r.Country__r.X200DEMA_Exch_Rate_in_EUR__c; 	
                 }
                
                 AmountQtr1 = AmountQtr1+objBudgetLineNewRow.Q1_Amount__c*ExcRate;
                 AmountQtr2 = AmountQtr2+objBudgetLineNewRow.Q2_Amount__c*ExcRate;
                 AmountQtr3 = AmountQtr3+objBudgetLineNewRow.Q3_Amount__c*ExcRate;
                 AmountQtr4 = AmountQtr4+objBudgetLineNewRow.Q4_Amount__c*ExcRate;
                 AmountQtr5 = AmountQtr5+objBudgetLineNewRow.Q5_Amount__c*ExcRate;
                 AmountQtr6 = AmountQtr6+objBudgetLineNewRow.Q6_Amount__c*ExcRate;
                 AmountQtr7 = AmountQtr7+objBudgetLineNewRow.Q7_Amount__c*ExcRate;
                 AmountQtr8 = AmountQtr8+objBudgetLineNewRow.Q8_Amount__c*ExcRate;
                 AmountQtr9 = AmountQtr9+objBudgetLineNewRow.Q9_Amount__c*ExcRate;
                 AmountQtr10 = AmountQtr10+objBudgetLineNewRow.Q10_Amount__c*ExcRate;
                 AmountQtr11 = AmountQtr11+objBudgetLineNewRow.Q11_Amount__c*ExcRate;
                 AmountQtr12 = AmountQtr12+objBudgetLineNewRow.Q12_Amount__c*ExcRate;
                 AmountQtr13 = AmountQtr13+objBudgetLineNewRow.Q13_Amount__c*ExcRate; 
                 AmountQtr14 = AmountQtr14+objBudgetLineNewRow.Q14_Amount__c*ExcRate;
                 AmountQtr15 = AmountQtr15+objBudgetLineNewRow.Q15_Amount__c*ExcRate;
                 AmountQtr16 = AmountQtr16+objBudgetLineNewRow.Q16_Amount__c*ExcRate;
        
                TotalQtr1 = AmountQtr1 + AmountQtr2 + AmountQtr3 + AmountQtr4 ;
                TotalQtr2 = AmountQtr5 + AmountQtr6 + AmountQtr7 + AmountQtr8 ;
                TotalQtr3 = AmountQtr9 + AmountQtr10 + AmountQtr11 + AmountQtr12 ;
                TotalQtr4 = AmountQtr13 + AmountQtr14 + AmountQtr15 + AmountQtr16 ;
                GrantTotal = TotalQtr1 + TotalQtr2 + TotalQtr3 + TotalQtr4;
            /************************** Calculation Compeleted ********************/
                objBudgetLineNewRow.Implementation_Period__c = strImplementationPeriodId ;
                insert objBudgetLineNewRow;
                transient List<Budget_Line__c> BudgetLinelist = new List<Budget_Line__c>();
                 BudgetLinelist = [select Id,Name,Q1_Grant_Amount__c,Q2_Grant_Amount__c,Q3_Grant_Amount__c,Q4_Grant_Amount__c,Q5_Grant_Amount__c,Q6_Grant_Amount__c,Q7_Grant_Amount__c,Q8_Grant_Amount__c,Q9_Grant_Amount__c,Q10_Grant_Amount__c,Q11_Grant_Amount__c,
                                      Q12_Grant_Amount__c,Q13_Grant_Amount__c,Q14_Grant_Amount__c,Q15_Grant_Amount__c,Q16_Grant_Amount__c,
                    				 Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,Q5_Amount__c,Q6_Amount__c,Q7_Amount__c,Q8_Amount__c,Q9_Amount__c,Q10_Amount__c,
                                  Q11_Amount__c,Q12_Amount__c,Q13_Amount__c,Q14_Amount__c,Q15_Amount__c,Q16_Amount__c,Implementation_Period__c,Implementation_Period__r.Sum__c,
                                  Implementation_Period__r.High_level_budget_GAC_1_USD__c,Implementation_Period__r.High_level_budget_GAC_1_EUR__c,Implementation_Period__r.Budget_Remaining__c from Budget_Line__c where Implementation_Period__c =: strImplementationPeriodId];
                                  
                System.Debug('BudgetLinelist'+BudgetLinelist);    
                                   
                 Double Tempsum = 0 ;   
                 for(Budget_Line__c bl : BudgetLinelist){   
                   if( bl.Q1_Amount__c!= Null) Tempsum   = Tempsum +bl.Q1_Grant_Amount__c ;
                   if( bl.Q2_Amount__c!= Null) Tempsum  = Tempsum+ bl.Q2_Grant_Amount__c  ;
                   if( bl.Q3_Amount__c!= Null) Tempsum  = Tempsum+bl.Q3_Grant_Amount__c   ;
                   if( bl.Q4_Amount__c!= Null) Tempsum  = Tempsum+bl.Q4_Grant_Amount__c   ;
                   if( bl.Q5_Amount__c!= Null) Tempsum  = Tempsum+bl.Q5_Grant_Amount__c   ;
                   if( bl.Q6_Amount__c!= Null) Tempsum  = Tempsum+bl.Q6_Grant_Amount__c   ;
                   if( bl.Q7_Amount__c!= Null) Tempsum  = Tempsum+bl.Q7_Grant_Amount__c   ;
                   if( bl.Q8_Amount__c!= Null) Tempsum  = Tempsum+bl.Q8_Grant_Amount__c   ;
                   if( bl.Q9_Amount__c!= Null) Tempsum  = Tempsum+bl.Q9_Grant_Amount__c   ;
                   if( bl.Q10_Amount__c!= Null) Tempsum = Tempsum+bl.Q10_Grant_Amount__c  ;                      
                   if( bl.Q11_Amount__c!= Null) Tempsum = Tempsum+bl.Q11_Grant_Amount__c  ;
                   if( bl.Q12_Amount__c!= Null) Tempsum = Tempsum+bl.Q12_Grant_Amount__c  ;
                   if( bl.Q13_Amount__c!= Null) Tempsum = Tempsum+bl.Q13_Grant_Amount__c  ;
                   if( bl.Q14_Amount__c!= Null) Tempsum = Tempsum+bl.Q14_Grant_Amount__c  ;
                   if( bl.Q15_Amount__c!= Null) Tempsum = Tempsum+bl.Q15_Grant_Amount__c  ;
                   if( bl.Q16_Amount__c!= Null) Tempsum = Tempsum+bl.Q16_Grant_Amount__c  ;
          
                //   Tempsum += bl.Q1_Amount__c+bl.Q2_Amount__c+bl.Q3_Amount__c+bl.Q4_Amount__c+bl.Q5_Amount__c+bl.Q6_Amount__c+bl.Q7_Amount__c+bl.Q8_Amount__c+bl.Q9_Amount__c+bl.Q10_Amount__c+bl.Q11_Amount__c+bl.Q12_Amount__c+bl.Q13_Amount__c+bl.Q14_Amount__c+bl.Q15_Amount__c+bl.Q16_Amount__c;   
                }
                 System.debug('Tempsum'+Tempsum);                 
                 ipde.Total_Budgeted_Amount__c = Tempsum; 
                 //if(imp.Total__c != Null)     
                    //imp.Budget_Remaining__c = imp.Total__c - imp.Sum__c;
                 if(grantcurrency=='USD') {    
                 ipde.Remaining_Budget_Amount__c = ipde.High_level_budget_GAC_1_USD__c -  ipde.Total_Budgeted_Amount__c;   
                 }else{
                 ipde.Remaining_Budget_Amount__c = ipde.High_level_budget_GAC_1_EUR__c - ipde.Total_Budgeted_Amount__c;}            
                Update ipde; 
                              
                wrapBudgetLines objWrap = new wrapBudgetLines();
                Budget_Line__c objBudgetLineTemp = retriveBudjetLine(objBudgetLineNewRow.Id);
                objWrap = fillwraperObject(objBudgetLineTemp);
                objWrap.strUnitCostMeasure = objBudgetLineNew.strUnitCostMeasure;
                lstBudgetLines.add(objWrap);
                objBudgetLineNewRow = new Budget_Line__c();
                strCostGrpName = '';
                objBudgetLineNewRow.Cost_grouping__c = '';
                
            }else{
                if(mapBLIdToWrap.ContainsKey(lstBudgetLines[SaveIndex].objBudgetLine.id)){
                    mapBLIdToWrap.remove(lstBudgetLines[SaveIndex].objBudgetLine.id);
                }
                List<Budget_Line__c> lstBudgetLineToUpdate = new List<Budget_Line__c>();
                system.debug('%%$%$%$%'+lstBudgetLines[SaveIndex].strCurrencyUsed);
                if(lstBudgetLines[SaveIndex].strCurrencyUsed == strGrantCurrency){
                    lstBudgetLines[SaveIndex].objBudgetLine.Currency_Used__c = 'Grant Currency';
                }else if(lstBudgetLines[SaveIndex].strCurrencyUsed == strLocalCurrency){
                    lstBudgetLines[SaveIndex].objBudgetLine.Currency_Used__c = 'Local Currency';
                }else if(lstBudgetLines[SaveIndex].strCurrencyUsed == strOtherCurrency){
                    lstBudgetLines[SaveIndex].objBudgetLine.Currency_Used__c = 'Other Currency';
                }
                
                lstBudgetLineToUpdate.add(lstBudgetLines[SaveIndex].objBudgetLine);
                system.debug('%%$%$%$%'+lstBudgetLineToUpdate);
                Decimal FinalRate = null;
                if(lstBudgetLines[intEditBLIndex].strCurrencyUsed == strLocalCurrency){
                    FinalRate = strLocalCurrencyRate;
                }else if(lstBudgetLines[intEditBLIndex].strCurrencyUsed == strOtherCurrency){
                    FinalRate = strOtherCurrencyRate;
                }
                if(FinalRate == null) FinalRate = 1;
                lstBudgetLines[SaveIndex].Q1Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q1_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q2Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q2_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q3Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q3_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q4Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q4_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q5Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q5_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q6Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q6_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q7Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q7_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q8Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q8_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q9Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q9_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q10Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q10_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q11Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q11_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q12Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q12_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q13Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q13_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q14Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q14_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q15Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q15_Quantity__c * FinalRate);
                lstBudgetLines[SaveIndex].Q16Case = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q16_Quantity__c * FinalRate); 
                
                lstBudgetLines[SaveIndex].objBudgetLine.Q1_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q1_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q2_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q2_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q3_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q3_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q4_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c * lstBudgetLineToUpdate[0].Q4_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q5_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q5_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q6_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q6_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q7_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q7_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q8_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c * lstBudgetLineToUpdate[0].Q8_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q9_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q9_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q10_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q10_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q11_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q11_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q12_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c * lstBudgetLineToUpdate[0].Q12_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q13_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q13_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q14_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q14_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q15_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q15_Quantity__c);
                lstBudgetLines[SaveIndex].objBudgetLine.Q16_Amount__c = integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c * lstBudgetLineToUpdate[0].Q16_Quantity__c);
                system.debug('input Cost'+lstBudgetLines[SaveIndex].inputcost.Cost_Grouping__c);
              //  lstBudgetLines[SaveIndex].objBudgetLine.Cost_Grouping__c = string.valueof(lstBudgetLines[SaveIndex].strCostGrp);
               // CSInput = New Catalog_cost_input__c();
                //lstBudgetLineToUpdate[SaveIndex].Cost_Grouping__c = CSInput.Cost_Grouping__c;    
                  
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
                lstBudgetLines[SaveIndex].blnIsEditable = true;
                strCostGrpName = '';

        /*TCS 18/10/2014 Changes for US Detailed Budget*/
       /* if(lstBudgetLineToUpdate[0].FO_Q1_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q1_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q2_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q2_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q3_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q3_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q4_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q4_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q5_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q5_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q6_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q6_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q7_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q7_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q8_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q8_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q9_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q9_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q10_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q10_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q11_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q11_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q12_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q12_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q13_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q13_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q14_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q14_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q15_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q15_Quantity__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Q16_Quantity__c == null) lstBudgetLineToUpdate[0].FO_Q16_Quantity__c = 0;
        
        
                lstBudgetLines[SaveIndex].TotalFOQuantityYear1 = lstBudgetLineToUpdate[0].FO_Q1_Quantity__c + lstBudgetLineToUpdate[0].FO_Q2_Quantity__c + lstBudgetLineToUpdate[0].FO_Q3_Quantity__c + lstBudgetLineToUpdate[0].FO_Q4_Quantity__c;
                lstBudgetLines[SaveIndex].TotalFOQuantityYear2 = lstBudgetLineToUpdate[0].FO_Q5_Quantity__c + lstBudgetLineToUpdate[0].FO_Q6_Quantity__c + lstBudgetLineToUpdate[0].FO_Q7_Quantity__c + lstBudgetLineToUpdate[0].FO_Q8_Quantity__c;
                lstBudgetLines[SaveIndex].TotalFOQuantityYear3 = lstBudgetLineToUpdate[0].FO_Q9_Quantity__c + lstBudgetLineToUpdate[0].FO_Q10_Quantity__c + lstBudgetLineToUpdate[0].FO_Q11_Quantity__c + lstBudgetLineToUpdate[0].FO_Q12_Quantity__c;
                lstBudgetLines[SaveIndex].TotalFOQuantityYear4 = lstBudgetLineToUpdate[0].FO_Q13_Quantity__c + lstBudgetLineToUpdate[0].FO_Q14_Quantity__c + lstBudgetLineToUpdate[0].FO_Q15_Quantity__c + lstBudgetLineToUpdate[0].FO_Q16_Quantity__c;
                */
                /*TCS 28/10/2014: Changes for sprint 4*/
                if(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y1__c == null) lstBudgetLineToUpdate[0].FO_Unit_Cost_Y1__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y2__c == null) lstBudgetLineToUpdate[0].FO_Unit_Cost_Y2__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y3__c == null) lstBudgetLineToUpdate[0].FO_Unit_Cost_Y3__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y4__c == null) lstBudgetLineToUpdate[0].FO_Unit_Cost_Y4__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Y1_Amount__c == null) lstBudgetLineToUpdate[0].FO_Y1_Amount__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Y2_Amount__c == null) lstBudgetLineToUpdate[0].FO_Y2_Amount__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Y3_Amount__c == null) lstBudgetLineToUpdate[0].FO_Y3_Amount__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Y4_Amount__c == null) lstBudgetLineToUpdate[0].FO_Y4_Amount__c = 0;
                if(lstBudgetLineToUpdate[0].FO_Total_Grant_Quantity_Amount__c == null) lstBudgetLineToUpdate[0].FO_Total_Grant_Quantity_Amount__c = 0;
                
                if((integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y1__c)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y1__c)) || (integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y2__c)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y2__c)) || (integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y3__c)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y3__c))||(integer.valueof(lstBudgetLineToUpdate[0].Unit_Cost_Y4__c)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Unit_Cost_Y4__c)) || (integer.valueof(lstBudgetLines[SaveIndex].TotalQuantityYear1)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Y1_Amount__c))|| (integer.valueof(lstBudgetLines[SaveIndex].TotalQuantityYear2)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Y2_Amount__c))||(integer.valueof(lstBudgetLines[SaveIndex].TotalQuantityYear3)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Y3_Amount__c))||(integer.valueof(lstBudgetLines[SaveIndex].TotalQuantityYear4)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Y4_Amount__c))||(integer.valueof(lstBudgetLines[SaveIndex].GrantTotalQuantity)!= integer.valueof(lstBudgetLineToUpdate[0].FO_Total_Grant_Quantity_Amount__c))){
                	 lstBudgetLines[SaveIndex].blnSetColor = true;
                 }
                 else{
                 	lstBudgetLines[SaveIndex].blnSetColor = false;
                 }
                /*TCS 28/10/2014: Changes for sprint 4*/
                /*********************************** Get the Total of qtr's on update(By TCS) *****************************/
                
                Amountqtr1 = 0;
	            Amountqtr2 = 0;
	            Amountqtr3 = 0;
	            Amountqtr4 = 0;
	            Amountqtr5 = 0;
	            Amountqtr6 = 0;
	            Amountqtr7 = 0;
	            Amountqtr8 = 0;
	            Amountqtr9 = 0;
	            Amountqtr10 = 0;
	            Amountqtr11= 0;
	            Amountqtr12= 0;
	            Amountqtr13= 0;
	            Amountqtr14= 0;
	            Amountqtr15= 0;
	            Amountqtr16= 0;
                
                List<Budget_Line__c> BLEditUpdate = [Select Id,Q1_Grant_Amount__c,Q2_Grant_Amount__c,Q3_Grant_Amount__c,Q4_Grant_Amount__c,Q5_Grant_Amount__c,Q6_Grant_Amount__c,Q7_Grant_Amount__c,Q8_Grant_Amount__c,Q9_Grant_Amount__c,Q10_Grant_Amount__c,Q11_Grant_Amount__c,
                                                     Q12_Grant_Amount__c,Q13_Grant_Amount__c,Q14_Grant_Amount__c,Q15_Grant_Amount__c,Q16_Grant_Amount__c,Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,Q5_Amount__c,Q6_Amount__c,Q7_Amount__c,Q8_Amount__c,
                                                          Q9_Amount__c,Q10_Amount__c,Q11_Amount__c,Q12_Amount__c,Q13_Amount__c,Q14_Amount__c,Q15_Amount__c,Q16_Amount__c
                                                          From Budget_Line__c Where Cost_Input__r.PSM__c = false And Grant_Intervention__r.Module__c =: strModuleId
                                                			Order By Grant_Intervention__r.Name];
                if(BLEditUpdate.size() > 0){
                	for(Budget_Line__c BLEditUpdat: BLEditUpdate){
	                    AmountQtr1 = Amountqtr1+BLEditUpdat.Q1_Grant_Amount__c;
	                    AmountQtr2 = Amountqtr2+BLEditUpdat.Q2_Grant_Amount__c;
	                    AmountQtr3 = Amountqtr3+BLEditUpdat.Q3_Grant_Amount__c;
	                    AmountQtr4 = Amountqtr4+BLEditUpdat.Q4_Grant_Amount__c;
	                    AmountQtr5 = Amountqtr5+BLEditUpdat.Q5_Grant_Amount__c;
	                    AmountQtr6 = Amountqtr6+BLEditUpdat.Q6_Grant_Amount__c;
	                    AmountQtr7 = Amountqtr7+BLEditUpdat.Q7_Grant_Amount__c;
	                    AmountQtr8 = Amountqtr8+BLEditUpdat.Q8_Grant_Amount__c;
	                    AmountQtr9 = Amountqtr9+BLEditUpdat.Q9_Grant_Amount__c;
	                    AmountQtr10 = Amountqtr10+BLEditUpdat.Q10_Grant_Amount__c;
	                    AmountQtr11 = Amountqtr11+BLEditUpdat.Q11_Grant_Amount__c;
	                    AmountQtr12 = Amountqtr12+BLEditUpdat.Q12_Grant_Amount__c;
	                    AmountQtr13 = Amountqtr13+BLEditUpdat.Q13_Grant_Amount__c;
	                    AmountQtr14 = Amountqtr14+BLEditUpdat.Q14_Grant_Amount__c;
	                    AmountQtr15 = Amountqtr15+BLEditUpdat.Q15_Grant_Amount__c;
	                    AmountQtr16 = Amountqtr16+BLEditUpdat.Q16_Grant_Amount__c;
                	}
                    
                    
                    TotalQtr1 = AmountQtr1 + AmountQtr2 + AmountQtr3 + AmountQtr4 ;
                    TotalQtr2 = AmountQtr5 + AmountQtr6 + AmountQtr7 + AmountQtr8 ;
                    TotalQtr3 = AmountQtr9 + AmountQtr10 + AmountQtr11 + AmountQtr12 ;
                    TotalQtr4 = AmountQtr13 + AmountQtr14 + AmountQtr15 + AmountQtr16 ;
                    GrantTotal = TotalQtr1 + TotalQtr2 + TotalQtr3 + TotalQtr4;
                    
                    transient List<Budget_Line__c> BudgetLinelist = new List<Budget_Line__c>();
                    BudgetLinelist = [select Id,Name,Q1_Grant_Amount__c,Q2_Grant_Amount__c,Q3_Grant_Amount__c,Q4_Grant_Amount__c,Q5_Grant_Amount__c,Q6_Grant_Amount__c,Q7_Grant_Amount__c,Q8_Grant_Amount__c,Q9_Grant_Amount__c,Q10_Grant_Amount__c,Q11_Grant_Amount__c,
                                      Q12_Grant_Amount__c,Q13_Grant_Amount__c,Q14_Grant_Amount__c,Q15_Grant_Amount__c,Q16_Grant_Amount__c,
                    				 Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,Q5_Amount__c,Q6_Amount__c,Q7_Amount__c,Q8_Amount__c,Q9_Amount__c,Q10_Amount__c,
                                  Q11_Amount__c,Q12_Amount__c,Q13_Amount__c,Q14_Amount__c,Q15_Amount__c,Q16_Amount__c,Implementation_Period__c,Implementation_Period__r.Sum__c,
                                  Implementation_Period__r.High_level_budget_GAC_1_USD__c,Implementation_Period__r.High_level_budget_GAC_1_EUR__c,Implementation_Period__r.Budget_Remaining__c from Budget_Line__c where Implementation_Period__c =: strImplementationPeriodId];
                                  
                System.Debug('BudgetLinelist'+BudgetLinelist);    
                                   
                 Double Tempsum = 0 ;   
                 for(Budget_Line__c bl : BudgetLinelist){   
                   if( bl.Q1_Amount__c!= Null) Tempsum   = Tempsum +bl.Q1_Grant_Amount__c ;
                   if( bl.Q2_Amount__c!= Null) Tempsum  = Tempsum+ bl.Q2_Grant_Amount__c  ;
                   if( bl.Q3_Amount__c!= Null) Tempsum  = Tempsum+bl.Q3_Grant_Amount__c   ;
                   if( bl.Q4_Amount__c!= Null) Tempsum  = Tempsum+bl.Q4_Grant_Amount__c   ;
                   if( bl.Q5_Amount__c!= Null) Tempsum  = Tempsum+bl.Q5_Grant_Amount__c   ;
                   if( bl.Q6_Amount__c!= Null) Tempsum  = Tempsum+bl.Q6_Grant_Amount__c   ;
                   if( bl.Q7_Amount__c!= Null) Tempsum  = Tempsum+bl.Q7_Grant_Amount__c   ;
                   if( bl.Q8_Amount__c!= Null) Tempsum  = Tempsum+bl.Q8_Grant_Amount__c   ;
                   if( bl.Q9_Amount__c!= Null) Tempsum  = Tempsum+bl.Q9_Grant_Amount__c   ;
                   if( bl.Q10_Amount__c!= Null) Tempsum = Tempsum+bl.Q10_Grant_Amount__c  ;                      
                   if( bl.Q11_Amount__c!= Null) Tempsum = Tempsum+bl.Q11_Grant_Amount__c  ;
                   if( bl.Q12_Amount__c!= Null) Tempsum = Tempsum+bl.Q12_Grant_Amount__c  ;
                   if( bl.Q13_Amount__c!= Null) Tempsum = Tempsum+bl.Q13_Grant_Amount__c  ;
                   if( bl.Q14_Amount__c!= Null) Tempsum = Tempsum+bl.Q14_Grant_Amount__c  ;
                   if( bl.Q15_Amount__c!= Null) Tempsum = Tempsum+bl.Q15_Grant_Amount__c  ;
                   if( bl.Q16_Amount__c!= Null) Tempsum = Tempsum+bl.Q16_Grant_Amount__c  ;
          
                //   Tempsum += bl.Q1_Amount__c+bl.Q2_Amount__c+bl.Q3_Amount__c+bl.Q4_Amount__c+bl.Q5_Amount__c+bl.Q6_Amount__c+bl.Q7_Amount__c+bl.Q8_Amount__c+bl.Q9_Amount__c+bl.Q10_Amount__c+bl.Q11_Amount__c+bl.Q12_Amount__c+bl.Q13_Amount__c+bl.Q14_Amount__c+bl.Q15_Amount__c+bl.Q16_Amount__c;   
                   }
                 System.debug('Tempsum'+Tempsum);                 
                 ipde.Total_Budgeted_Amount__c = Tempsum; 
                 //if(imp.Total__c != Null)     
                    //imp.Budget_Remaining__c = imp.Total__c - imp.Sum__c;
                 if(grantcurrency=='USD') {    
                 ipde.Remaining_Budget_Amount__c = ipde.High_level_budget_GAC_1_USD__c -  ipde.Total_Budgeted_Amount__c;   
                 }else{
                 ipde.Remaining_Budget_Amount__c = ipde.High_level_budget_GAC_1_EUR__c - ipde.Total_Budgeted_Amount__c;}            
                 Update ipde; 
                 } 
                
                /******************************* Completed ****************************************************/
                
            }
           
           /***************************** Short the Wrapper List(by TCS) ***************************************/
                  
             
          List<wrapBudgetLines> newlstBudgetLines = new List<wrapBudgetLines>();
          for(integer i=0;i<GrantInterventionOptions.size();i++){
               string s = string.valueof(GrantInterventionOptions[i].getlabel());
               for(wrapBudgetLines wBL: lstBudgetLines){
                    if(wBL.objBudgetLine.Grant_intervention__r.name == s){
                         newlstBudgetLines.add(wBL);
                    }
              }
           }
           lstBudgetLines.clear();
           lstbudgetLines.addall(newlstBudgetLines); 
           
           /****************************** Completed ************************************************/
           
        }
    }
    
    Public Integer intEditBLIndex;
    
    Public void EditBudgetLine(){
        
        Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            intEditBLIndex = EditIndex;
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
            objwrapBudgetLineTemp.objBudgetLine.Cost_Grouping__c = lstBudgetLines[EditIndex].objBudgetLine.Cost_Grouping__c;
           /* if(CatalogIC != Null){
                objwrapBudgetLineTemp.strCostInputName = CatalogIC.name;   
             objwrapBudgetLineTemp.objBudgetLine.cost_input__c = CatalogIC.id;} */  
              
            objwrapBudgetLineTemp.inputCost = lstBudgetLines[EditIndex].inputCost;
            
          /*********************** Assign value of Cost Group on edit *****************/ 
            if(lstBudgetLines[EditIndex].strCostGrp!=Null) 
            objwrapBudgetLineTemp.strCostGrp = lstBudgetLines[EditIndex].strCostGrp;
          /****************************** Completed ***********************************/  
            
            //objwrapBudgetLineTemp.inputCost.Cost_Grouping__c = lstBudgetLines[EditIndex].inputCost.Cost_grouping__c;
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

       /*TCS 18/10/2014 SSpring 3 CHnages for UUS Detailed Budget*/
        objwrapBudgetLineTemp.TotalFOQuantityYear1 = lstBudgetLines[EditIndex].TotalFOQuantityYear1;
            objwrapBudgetLineTemp.TotalFOQuantityYear2 = lstBudgetLines[EditIndex].TotalFOQuantityYear2;
            objwrapBudgetLineTemp.TotalFOQuantityYear3 = lstBudgetLines[EditIndex].TotalFOQuantityYear3;
            objwrapBudgetLineTemp.TotalFOQuantityYear4 = lstBudgetLines[EditIndex].TotalFOQuantityYear4;
            
         /*************************************  Subtract value of Amount from Qtr's for Edited Budget Line ******************************/  
            
           /* List<Budget_Line__c> BLEdit = [Select Id,Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,Q5_Amount__c,Q6_Amount__c,Q7_Amount__c,Q8_Amount__c,
                                                          Q9_Amount__c,Q10_Amount__c,Q11_Amount__c,Q12_Amount__c,Q13_Amount__c,Q14_Amount__c,Q15_Amount__c,Q16_Amount__c
                                                          From Budget_Line__c Where Id =: lstBudgetLines[EditIndex].objBudgetLine.Id];
            if(BLEdit.size() > 0){
                AmountQtr1 = Amountqtr1-BLEdit[0].Q1_Amount__c;
                AmountQtr2 = Amountqtr2-BLEdit[0].Q2_Amount__c;
                AmountQtr3 = Amountqtr3-BLEdit[0].Q3_Amount__c;
                AmountQtr4 = Amountqtr4-BLEdit[0].Q4_Amount__c;
                AmountQtr5 = Amountqtr5-BLEdit[0].Q5_Amount__c;
                AmountQtr6 = Amountqtr6-BLEdit[0].Q6_Amount__c;
                AmountQtr7 = Amountqtr7-BLEdit[0].Q7_Amount__c;
                AmountQtr8 = Amountqtr8-BLEdit[0].Q8_Amount__c;
                AmountQtr9 = Amountqtr9-BLEdit[0].Q9_Amount__c;
                AmountQtr10 = Amountqtr10-BLEdit[0].Q10_Amount__c;
                AmountQtr11 = Amountqtr11-BLEdit[0].Q11_Amount__c;
                AmountQtr12 = Amountqtr12-BLEdit[0].Q12_Amount__c;
                AmountQtr13 = Amountqtr13-BLEdit[0].Q13_Amount__c;
                AmountQtr14 = Amountqtr14-BLEdit[0].Q14_Amount__c;
                AmountQtr15 = Amountqtr15-BLEdit[0].Q15_Amount__c;
                AmountQtr16 = Amountqtr16-BLEdit[0].Q16_Amount__c;
                
                TotalQtr1 = AmountQtr1 + AmountQtr2 + AmountQtr3 + AmountQtr4 ;
                TotalQtr2 = AmountQtr5 + AmountQtr6 + AmountQtr7 + AmountQtr8 ;
                TotalQtr3 = AmountQtr9 + AmountQtr10 + AmountQtr11 + AmountQtr12 ;
                TotalQtr4 = AmountQtr13 + AmountQtr14 + AmountQtr15 + AmountQtr16 ;
                GrantTotal = TotalQtr1 + TotalQtr2 + TotalQtr3 + TotalQtr4;
            } */
            
         /******************************* Calculation Completed **************************************************/                
        }
    }
    
    Public void ChangeBudgetLineOutFlowsValues(){
        if(intEditBLIndex != null){
            
            Decimal FinalRate = null;
            if(lstBudgetLines[intEditBLIndex].strCurrencyUsed == strLocalCurrency){
                FinalRate = strLocalCurrencyRate;
            }else if(lstBudgetLines[intEditBLIndex].strCurrencyUsed == strOtherCurrency){
                FinalRate = strOtherCurrencyRate;
            }
           
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q1_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q1_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q2_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q2_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q3_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q3_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q4_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q4_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q5_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q5_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q6_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q6_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q7_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q7_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q8_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q8_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q9_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q9_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q10_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q10_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q11_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q11_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q12_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q12_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q13_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q13_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q14_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q14_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q15_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q15_Amount__c = 0;
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Q16_Amount__c == null) lstBudgetLines[intEditBLIndex].objBudgetLine.Q16_Amount__c = 0;
            
            if(FinalRate == null) FinalRate = 1;
            lstBudgetLines[intEditBLIndex].Q1Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q1_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q2Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q2_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q3Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q3_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q4Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q4_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q5Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q5_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q6Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q6_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q7Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q7_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q8Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q8_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q9Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q9_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q10Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q10_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q11Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q11_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q12Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q12_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q13Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q13_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q14Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q14_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q15Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q15_Amount__c * FinalRate);
            lstBudgetLines[intEditBLIndex].Q16Case = integer.valueof(lstBudgetLines[intEditBLIndex].objBudgetLine.Q16_Amount__c * FinalRate);
            
            lstBudgetLines[intEditBLIndex].TotalCaseYear1 = lstBudgetLines[intEditBLIndex].Q1Case + lstBudgetLines[intEditBLIndex].Q2Case + lstBudgetLines[intEditBLIndex].Q3Case + lstBudgetLines[intEditBLIndex].Q4Case;
            lstBudgetLines[intEditBLIndex].TotalCaseYear2 = lstBudgetLines[intEditBLIndex].Q5Case + lstBudgetLines[intEditBLIndex].Q6Case + lstBudgetLines[intEditBLIndex].Q7Case + lstBudgetLines[intEditBLIndex].Q8Case;
            lstBudgetLines[intEditBLIndex].TotalCaseYear3 = lstBudgetLines[intEditBLIndex].Q9Case + lstBudgetLines[intEditBLIndex].Q10Case + lstBudgetLines[intEditBLIndex].Q11Case + lstBudgetLines[intEditBLIndex].Q12Case;
            lstBudgetLines[intEditBLIndex].TotalCaseYear4 = lstBudgetLines[intEditBLIndex].Q13Case + lstBudgetLines[intEditBLIndex].Q14Case + lstBudgetLines[intEditBLIndex].Q15Case + lstBudgetLines[intEditBLIndex].Q16Case;
            
            lstBudgetLines[intEditBLIndex].GrantTotalAmount = lstBudgetLines[intEditBLIndex].TotalCaseYear1+ lstBudgetLines[intEditBLIndex].TotalCaseYear2+ lstBudgetLines[intEditBLIndex].TotalCaseYear3+ lstBudgetLines[intEditBLIndex].TotalCaseYear4;
        }
    }
    Public void ChangeBudgetLineOutFlowsValuesNew(){
        intEditBLIndex = null;
        system.debug('#$$#$#$#$#$'+objBudgetLineNew.strCurrencyUsed);
        Decimal FinalRate = null;
        if(objBudgetLineNew.strCurrencyUsed == 'Local Currency'){
            FinalRate = strLocalCurrencyRate;
            system.debug('FinalRate#$'+FinalRate);
        }else if(objBudgetLineNew.strCurrencyUsed == 'Other Currency'){
            FinalRate = strOtherCurrencyRate;
        }
        system.debug('#$$#$#$#$#$'+FinalRate);
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
        
        system.debug('$$$$$$$'+objBudgetLineNewRow.Q1_Quantity__c);
        system.debug('$$$$$$$'+objBudgetLineNewRow.Unit_Cost_Y1__c);
        if(FinalRate == null) FinalRate = 1;
        objBudgetLineNew.Q1Case = integer.valueof(objBudgetLineNewRow.Q1_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y1__c * FinalRate);
        objBudgetLineNew.Q2Case = integer.valueof(objBudgetLineNewRow.Q2_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y1__c * FinalRate);
        objBudgetLineNew.Q3Case = integer.valueof(objBudgetLineNewRow.Q3_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y1__c * FinalRate);
        objBudgetLineNew.Q4Case = integer.valueof(objBudgetLineNewRow.Q4_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y1__c * FinalRate);
        objBudgetLineNew.Q5Case = integer.valueof(objBudgetLineNewRow.Q5_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y2__c * FinalRate);
        objBudgetLineNew.Q6Case = integer.valueof(objBudgetLineNewRow.Q6_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y2__c * FinalRate);
        objBudgetLineNew.Q7Case = integer.valueof(objBudgetLineNewRow.Q7_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y2__c * FinalRate);
        objBudgetLineNew.Q8Case = integer.valueof(objBudgetLineNewRow.Q8_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y2__c * FinalRate);
        objBudgetLineNew.Q9Case = integer.valueof(objBudgetLineNewRow.Q9_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y3__c * FinalRate);
        objBudgetLineNew.Q10Case = integer.valueof(objBudgetLineNewRow.Q10_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y3__c * FinalRate);
        objBudgetLineNew.Q11Case = integer.valueof(objBudgetLineNewRow.Q11_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y3__c * FinalRate);
        objBudgetLineNew.Q12Case = integer.valueof(objBudgetLineNewRow.Q12_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y3__c * FinalRate);
        objBudgetLineNew.Q13Case = integer.valueof(objBudgetLineNewRow.Q13_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y4__c * FinalRate);
        objBudgetLineNew.Q14Case = integer.valueof(objBudgetLineNewRow.Q14_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y4__c * FinalRate);
        objBudgetLineNew.Q15Case = integer.valueof(objBudgetLineNewRow.Q15_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y4__c * FinalRate);
        objBudgetLineNew.Q16Case = integer.valueof(objBudgetLineNewRow.Q16_Quantity__c * objBudgetLineNewRow.Unit_Cost_Y4__c * FinalRate);
        
        system.debug('$$$$$$$'+objBudgetLineNew.Q1Case);
        system.debug('$$$$$$$'+objBudgetLineNew.Q2Case);
        objBudgetLineNew.TotalQuantityYear1 = objBudgetLineNewRow.Q1_Quantity__c + objBudgetLineNewRow.Q2_Quantity__c + objBudgetLineNewRow.Q3_Quantity__c + objBudgetLineNewRow.Q4_Quantity__c;
        objBudgetLineNew.TotalQuantityYear2 = objBudgetLineNewRow.Q5_Quantity__c + objBudgetLineNewRow.Q6_Quantity__c + objBudgetLineNewRow.Q7_Quantity__c + objBudgetLineNewRow.Q8_Quantity__c;
        objBudgetLineNew.TotalQuantityYear3 = objBudgetLineNewRow.Q9_Quantity__c + objBudgetLineNewRow.Q10_Quantity__c + objBudgetLineNewRow.Q11_Quantity__c + objBudgetLineNewRow.Q12_Quantity__c;
        objBudgetLineNew.TotalQuantityYear4 = objBudgetLineNewRow.Q13_Quantity__c + objBudgetLineNewRow.Q14_Quantity__c + objBudgetLineNewRow.Q15_Quantity__c + objBudgetLineNewRow.Q16_Quantity__c;
        objBudgetLineNew.TotalCaseYear1 = objBudgetLineNew.Q1Case + objBudgetLineNew.Q2Case + objBudgetLineNew.Q3Case + objBudgetLineNew.Q4Case;
        objBudgetLineNew.TotalCaseYear2 = objBudgetLineNew.Q5Case + objBudgetLineNew.Q6Case + objBudgetLineNew.Q7Case + objBudgetLineNew.Q8Case;
        objBudgetLineNew.TotalCaseYear3 = objBudgetLineNew.Q9Case + objBudgetLineNew.Q10Case + objBudgetLineNew.Q11Case + objBudgetLineNew.Q12Case;
        objBudgetLineNew.TotalCaseYear4 = objBudgetLineNew.Q13Case + objBudgetLineNew.Q14Case + objBudgetLineNew.Q15Case + objBudgetLineNew.Q16Case;
        objBudgetLineNew.GrantTotalQuantity = objBudgetLineNew.TotalQuantityYear1 + objBudgetLineNew.TotalQuantityYear2 + objBudgetLineNew.TotalQuantityYear3 + objBudgetLineNew.TotalQuantityYear4;
        objBudgetLineNew.GrantTotalAmount = objBudgetLineNew.TotalCaseYear1+ objBudgetLineNew.TotalCaseYear2+ objBudgetLineNew.TotalCaseYear3+ objBudgetLineNew.TotalCaseYear4;
        
    }
    
    /********************************** Action Support method for Populating the costGrouping and Cost Input ************************/
                                                 /********** By TCS ************/
    // Action Support method to populate Cost input Automatically
    public void PopulateCostInput(){  
        system.debug('**Cost group**'+objBudgetLineNew.strCostGrp);
        CatalogIC = new Catalog_Cost_Input__c();
        if(objBudgetLineNew.strCostGrp!= Null){
            CatalogIC= [Select id,Name,Cost_grouping__c From Catalog_Cost_Input__c where Name=: 'All' and Cost_grouping__c =: objBudgetLineNew.strCostGrp];
            if(CatalogIC!= Null){
                objBudgetLineNewRow.Cost_Input__c = CatalogIC.Id;
                objBudgetLineNewRow.Cost_grouping__c = CatalogIC.Cost_grouping__c;
                strCostGrpName = CatalogIC.Name;
                system.debug('CatalogIC**'+CatalogIC);
            }    
        }
        If(intEditBLIndex!=Null){  
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Cost_Grouping__c != '' && lstBudgetLines[intEditBLIndex].objBudgetLine.Cost_Grouping__c!= Null){
                CatalogIC= [Select id,Name From Catalog_Cost_Input__c where Name=: 'All' and Cost_grouping__c =: lstBudgetLines[intEditBLIndex].objBudgetLine.Cost_Grouping__c];
                If(CatalogIC!=Null){
                    system.debug('**Catalog**'+catalogIC);
                    lstBudgetLines[intEditBLIndex].objBudgetLine.Cost_input__c = CatalogIC.id;
                    lstBudgetLines[intEditBLIndex].strCostInputName = CatalogIC.Name;
                    strCostGrpName = CatalogIC.Name;
                }    
            }
         }  
    }
    
    // Action Support Method to populate Cost Grouping automatically
    public void PopulateCostGrouping(){ 
        if(objBudgetLineNewRow.Cost_Input__c!= NULL){
            CatalogIC= [Select id,Name,Cost_Grouping__c From Catalog_Cost_Input__c where id=: objBudgetLineNewRow.Cost_Input__c];
            if(CatalogIC.Cost_Grouping__C!=''){
                //objBudgetLineNew.strCostGrp = CatalogIC.Cost_Grouping__c;  
                objBudgetLineNewRow.Cost_Grouping__c = CatalogIC.Cost_Grouping__c;
                system.debug('Cost Input'+objBudgetLineNewRow.Cost_Input__c); 
            }
        } 
        If(intEditBLIndex!=Null){             
            if(lstBudgetLines[intEditBLIndex].objBudgetLine.Cost_Input__c!= Null){
                CatalogIC= [Select id,Name,cost_grouping__c From Catalog_Cost_Input__c where id=: lstBudgetLines[intEditBLIndex].objBudgetLine.Cost_Input__c];
                If(CatalogIC.Cost_Grouping__c!= ''){
                    system.debug('**Catalog**'+catalogIC);
                   // objBL.objBudgetLine.Cost_Input__c = CatalogIC.Id;
                   //lstBudgetLines[intEditBLIndex].strCostGrp = CatalogIC.cost_grouping__c;
                   lstBudgetLines[intEditBLIndex].objBudgetLine.Cost_Grouping__c = CatalogIC.cost_grouping__c;
                    //strCostGrpName = CatalogIC.Name;
                    
                   // lstBudgetLines[intEditBLIndex].strCostInputName = CatalogIC.cost_grouping__c;
                }
            }
         }    
    }
    

    
    /********************************* Completed ****************************/
        
    Public void CancelBudgetLine(){
        Integer CancelIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            String BudgetLineid = lstBudgetLines[CancelIndex].objBudgetLine.id;
            lstBudgetLines[CancelIndex] = mapBLIdToWrap.get(BudgetLineid);
            lstBudgetLines[CancelIndex].blnIsEditable = true;
            if(BudgetLineid==Null){
                lstBudgetLines.remove(CancelIndex); 
            }
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
            List<Budget_Line__c> lstBudgetLineToDelete = [Select Id,Q1_Grant_Amount__c,Q2_Grant_Amount__c,Q3_Grant_Amount__c,Q4_Grant_Amount__c,Q5_Grant_Amount__c,Q6_Grant_Amount__c,Q7_Grant_Amount__c,Q8_Grant_Amount__c,Q9_Grant_Amount__c,Q10_Grant_Amount__c,Q11_Grant_Amount__c,
                                                          Q12_Grant_Amount__c,Q13_Grant_Amount__c,Q14_Grant_Amount__c,Q15_Grant_Amount__c,Q16_Grant_Amount__c,Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,Q5_Amount__c,Q6_Amount__c,Q7_Amount__c,Q8_Amount__c,
                                                          Q9_Amount__c,Q10_Amount__c,Q11_Amount__c,Q12_Amount__c,Q13_Amount__c,Q14_Amount__c,Q15_Amount__c,Q16_Amount__c
                                                          From Budget_Line__c Where Id =: strBudgetLineid];
          
          /*************************** Calculation of Total of Qtr's on Deleteion of Budget Line ***********************/
                                                  /************* By TCS ********************/
            if(lstBudgetLineToDelete.size() > 0){
                AmountQtr1 = Amountqtr1-lstBudgetLineToDelete[0].Q1_Grant_Amount__c;
                AmountQtr2 = Amountqtr2-lstBudgetLineToDelete[0].Q2_Grant_Amount__c;
                AmountQtr3 = Amountqtr3-lstBudgetLineToDelete[0].Q3_Grant_Amount__c;
                AmountQtr4 = Amountqtr4-lstBudgetLineToDelete[0].Q4_Grant_Amount__c;
                AmountQtr5 = Amountqtr5-lstBudgetLineToDelete[0].Q5_Grant_Amount__c;
                AmountQtr6 = Amountqtr6-lstBudgetLineToDelete[0].Q6_Grant_Amount__c;
                AmountQtr7 = Amountqtr7-lstBudgetLineToDelete[0].Q7_Grant_Amount__c;
                AmountQtr8 = Amountqtr8-lstBudgetLineToDelete[0].Q8_Grant_Amount__c;
                AmountQtr9 = Amountqtr9-lstBudgetLineToDelete[0].Q9_Grant_Amount__c;
                AmountQtr10 = Amountqtr10-lstBudgetLineToDelete[0].Q10_Grant_Amount__c;
                AmountQtr11 = Amountqtr11-lstBudgetLineToDelete[0].Q11_Grant_Amount__c;
                AmountQtr12 = Amountqtr12-lstBudgetLineToDelete[0].Q12_Grant_Amount__c;
                AmountQtr13 = Amountqtr13-lstBudgetLineToDelete[0].Q13_Grant_Amount__c;
                AmountQtr14 = Amountqtr14-lstBudgetLineToDelete[0].Q14_Grant_Amount__c;
                AmountQtr15 = Amountqtr15-lstBudgetLineToDelete[0].Q15_Grant_Amount__c;
                AmountQtr16 = Amountqtr16-lstBudgetLineToDelete[0].Q16_Grant_Amount__c;
                TotalQtr1 = AmountQtr1 + AmountQtr2 + AmountQtr3 + AmountQtr4 ;
                TotalQtr2 = AmountQtr5 + AmountQtr6 + AmountQtr7 + AmountQtr8 ;
                TotalQtr3 = AmountQtr9 + AmountQtr10 + AmountQtr11 + AmountQtr12 ;
                TotalQtr4 = AmountQtr13 + AmountQtr14 + AmountQtr15 + AmountQtr16 ;
                grantTotal = TotalQtr1 + TotalQtr2 + TotalQtr3 + TotalQtr4;
             /****************************** Compeleted ***********************************/   
                
                Delete lstBudgetLineToDelete;
                
                transient List<Budget_Line__c> BudgetLinelist = new List<Budget_Line__c>();
                          List<Implementation_Period__c> SetIp = new  List<Implementation_Period__c>(); 
                          List<Implementation_Period__c> ListIp = new  List<Implementation_Period__c>(); 
                BudgetLinelist = [select Id,Name,Q1_Grant_Amount__c,Q2_Grant_Amount__c,Q3_Grant_Amount__c,Q4_Grant_Amount__c,Q5_Grant_Amount__c,Q6_Grant_Amount__c,Q7_Grant_Amount__c,Q8_Grant_Amount__c,Q9_Grant_Amount__c,Q10_Grant_Amount__c,Q11_Grant_Amount__c,
                                 Q12_Grant_Amount__c,Q13_Grant_Amount__c,Q14_Grant_Amount__c,Q15_Grant_Amount__c,Q16_Grant_Amount__c,
                    			 Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,Q5_Amount__c,Q6_Amount__c,Q7_Amount__c,Q8_Amount__c,Q9_Amount__c,Q10_Amount__c,
                                 Q11_Amount__c,Q12_Amount__c,Q13_Amount__c,Q14_Amount__c,Q15_Amount__c,Q16_Amount__c,Implementation_Period__c,Implementation_Period__r.Sum__c,
                                 Implementation_Period__r.High_level_budget_GAC_1_USD__c,Implementation_Period__r.High_level_budget_GAC_1_EUR__c,Implementation_Period__r.Budget_Remaining__c from Budget_Line__c where Implementation_Period__c =: strImplementationPeriodId];
                                  
                System.Debug('BudgetLinelist'+BudgetLinelist);    
                                   
                 Double Tempsum = 0 ;   
                 for(Budget_Line__c bl : BudgetLinelist){   
                   if( bl.Q1_Amount__c!= Null) Tempsum   = Tempsum +bl.Q1_Grant_Amount__c ;
                   if( bl.Q2_Amount__c!= Null) Tempsum  = Tempsum+ bl.Q2_Grant_Amount__c  ;
                   if( bl.Q3_Amount__c!= Null) Tempsum  = Tempsum+bl.Q3_Grant_Amount__c   ;
                   if( bl.Q4_Amount__c!= Null) Tempsum  = Tempsum+bl.Q4_Grant_Amount__c   ;
                   if( bl.Q5_Amount__c!= Null) Tempsum  = Tempsum+bl.Q5_Grant_Amount__c   ;
                   if( bl.Q6_Amount__c!= Null) Tempsum  = Tempsum+bl.Q6_Grant_Amount__c   ;
                   if( bl.Q7_Amount__c!= Null) Tempsum  = Tempsum+bl.Q7_Grant_Amount__c   ;
                   if( bl.Q8_Amount__c!= Null) Tempsum  = Tempsum+bl.Q8_Grant_Amount__c   ;
                   if( bl.Q9_Amount__c!= Null) Tempsum  = Tempsum+bl.Q9_Grant_Amount__c   ;
                   if( bl.Q10_Amount__c!= Null) Tempsum = Tempsum+bl.Q10_Grant_Amount__c  ;                      
                   if( bl.Q11_Amount__c!= Null) Tempsum = Tempsum+bl.Q11_Grant_Amount__c  ;
                   if( bl.Q12_Amount__c!= Null) Tempsum = Tempsum+bl.Q12_Grant_Amount__c  ;
                   if( bl.Q13_Amount__c!= Null) Tempsum = Tempsum+bl.Q13_Grant_Amount__c  ;
                   if( bl.Q14_Amount__c!= Null) Tempsum = Tempsum+bl.Q14_Grant_Amount__c  ;
                   if( bl.Q15_Amount__c!= Null) Tempsum = Tempsum+bl.Q15_Grant_Amount__c  ;
                   if( bl.Q16_Amount__c!= Null) Tempsum = Tempsum+bl.Q16_Grant_Amount__c  ;
          
                //   Tempsum += bl.Q1_Amount__c+bl.Q2_Amount__c+bl.Q3_Amount__c+bl.Q4_Amount__c+bl.Q5_Amount__c+bl.Q6_Amount__c+bl.Q7_Amount__c+bl.Q8_Amount__c+bl.Q9_Amount__c+bl.Q10_Amount__c+bl.Q11_Amount__c+bl.Q12_Amount__c+bl.Q13_Amount__c+bl.Q14_Amount__c+bl.Q15_Amount__c+bl.Q16_Amount__c;   
                 }
                 System.debug('Tempsum'+Tempsum);                 
                 ipde.Total_Budgeted_Amount__c = Tempsum; 
                 //if(imp.Total__c != Null)     
                    //imp.Budget_Remaining__c = imp.Total__c - imp.Sum__c;
                 if(grantcurrency=='USD') {    
                 ipde.Remaining_Budget_Amount__c = ipde.High_level_budget_GAC_1_USD__c -  ipde.Total_Budgeted_Amount__c;   
                 }else{
                 ipde.Remaining_Budget_Amount__c = ipde.High_level_budget_GAC_1_EUR__c - ipde.Total_Budgeted_Amount__c;}            
                Update ipde; 
            }
            
            List<Budget_Line__c> lstBudgetLineToUpdate = [Select Id,Budget_Line_Number__c,Cost_Input__r.Is_Inactive__c From Budget_Line__c 
                                                        Where Budget_Line_Number__c >: DeleteIndex
                                                        And Grant_Intervention__r.Module__c =: strModuleId];
            for(Budget_Line__c objBL : lstBudgetLineToUpdate){
                objBL.Budget_Line_Number__c = objBL.Budget_Line_Number__c - 1;
            }
            update lstBudgetLineToUpdate;
            
            lstBudgetLines.remove(DeleteIndex);
        }
    }
    
    Public void DeleteAssumption(){
        Integer DeleteIndex = integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex'));
        if(DeleteIndex != null && intIndex != null){
            String strAssumptionid = lstBudgetLines[intIndex].lstAssumptions[DeleteIndex].objAssumption.Id;
            List<Assumption__c> lstAssumptionToDelete = [Select Id From Assumption__c Where Id =: strAssumptionid];
            if(lstAssumptionToDelete.size() > 0){
                Delete lstAssumptionToDelete;
            }
            lstBudgetLines[intIndex].lstAssumptions.remove(DeleteIndex);
            if(lstBudgetLines[intIndex].lstAssumptions.size() > 0){
                lstBudgetLines[intIndex].TotalOfAllY1Cost= null;
                lstBudgetLines[intIndex].TotalOfAllY2Cost= null;
                lstBudgetLines[intIndex].TotalOfAllY3Cost= null;
                lstBudgetLines[intIndex].TotalOfAllY4Cost= null;
            
                for(wrapAssumption objWrap : lstBudgetLines[intIndex].lstAssumptions){                    
                    if(objWrap.objAssumption.Y1_Quantity__c == null) objWrap.objAssumption.Y1_Quantity__c = 0;
                    if(objWrap.objAssumption.Y2_Quantity__c == null) objWrap.objAssumption.Y2_Quantity__c = 0;
                    if(objWrap.objAssumption.Y3_Quantity__c == null) objWrap.objAssumption.Y3_Quantity__c = 0;
                    if(objWrap.objAssumption.Y4_Quantity__c == null) objWrap.objAssumption.Y4_Quantity__c = 0;
                    if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                         
                         if(objWrap.objAssumption.Y1_Net_Salary_Payment_Currency__c != null && objWrap.objAssumption.Y1_Social_Security_Obligatory_Charges__c != null )
                        objWrap.TotalSalaryY1 = objWrap.objAssumption.Y1_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y1_Social_Security_Obligatory_Charges__c;
                        if(objWrap.objAssumption.Y2_Net_Salary_Payment_Currency__c != null  && objWrap.objAssumption.Y2_Social_Security_Obligatory_Charges__c != null )
                        objWrap.TotalSalaryY2 = objWrap.objAssumption.Y2_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y2_Social_Security_Obligatory_Charges__c;
                        if(objWrap.objAssumption.Y3_Net_Salary_Payment_Currency__c  != null && objWrap.objAssumption.Y3_Social_Security_Obligatory_Charges__c != null )
                        objWrap.TotalSalaryY3 = objWrap.objAssumption.Y3_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y3_Social_Security_Obligatory_Charges__c;
                        if(objWrap.objAssumption.Y4_Net_Salary_Payment_Currency__c != null  && objWrap.objAssumption.Y4_Social_Security_Obligatory_Charges__c != null )
                        objWrap.TotalSalaryY4 = objWrap.objAssumption.Y4_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y4_Social_Security_Obligatory_Charges__c;
                         
                         if(objWrap.TotalSalaryY1 != null && objWrap.objAssumption.Y1_Level_of_Effort__c != null && objWrap.objAssumption.Y1_Number_of_Persons__c != null)
                         objWrap.TotalCostY1 = (integer.valueof(objWrap.TotalSalaryY1 * objWrap.objAssumption.Y1_Level_of_Effort__c * objWrap.objAssumption.Y1_Number_of_Persons__c))/100;
                         if(objWrap.TotalSalaryY2 != null && objWrap.objAssumption.Y2_Level_of_Effort__c != null && objWrap.objAssumption.Y2_Number_of_Persons__c != null)
                         objWrap.TotalCostY2 = (integer.valueof(objWrap.TotalSalaryY2 * objWrap.objAssumption.Y2_Level_of_Effort__c * objWrap.objAssumption.Y2_Number_of_Persons__c))/100;
                         if(objWrap.TotalSalaryY3 != null && objWrap.objAssumption.Y3_Level_of_Effort__c != null && objWrap.objAssumption.Y3_Number_of_Persons__c != null)
                         objWrap.TotalCostY3 = (integer.valueof(objWrap.TotalSalaryY3 * objWrap.objAssumption.Y3_Level_of_Effort__c * objWrap.objAssumption.Y3_Number_of_Persons__c))/100;
                         if(objWrap.TotalSalaryY4 != null && objWrap.objAssumption.Y4_Level_of_Effort__c != null && objWrap.objAssumption.Y4_Number_of_Persons__c != null)
                         objWrap.TotalCostY4 = (integer.valueof(objWrap.TotalSalaryY4 * objWrap.objAssumption.Y4_Level_of_Effort__c * objWrap.objAssumption.Y4_Number_of_Persons__c))/100;
                        
                         
                     }else if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '2. Travel related costs (TRC)'){
                         if(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y1_Quantity__c != null && objWrap.objAssumption.Y1_Duration_Days__c != null)
                         objWrap.TotalCostY1 = integer.valueof(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y1_Duration_Days__c * objWrap.objAssumption.Y1_Quantity__c);
                         if(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y2_Quantity__c != null && objWrap.objAssumption.Y2_Duration_Days__c != null)
                         objWrap.TotalCostY2 = integer.valueof(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y2_Duration_Days__c * objWrap.objAssumption.Y2_Quantity__c);
                         if(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y3_Quantity__c != null && objWrap.objAssumption.Y3_Duration_Days__c != null)
                         objWrap.TotalCostY3 = integer.valueof(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y3_Duration_Days__c * objWrap.objAssumption.Y3_Quantity__c);
                         if(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y4_Quantity__c != null && objWrap.objAssumption.Y4_Duration_Days__c != null)
                         objWrap.TotalCostY4 = integer.valueof(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y4_Duration_Days__c * objWrap.objAssumption.Y4_Quantity__c);
                     }else{
                         if(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y1_Quantity__c!=null)
                         objWrap.TotalCostY1 = integer.valueof(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y1_Quantity__c);
                         
                         if(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y2_Quantity__c!=null)
                         objWrap.TotalCostY2 = integer.valueof(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y2_Quantity__c);
    
                         if(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y3_Quantity__c!=null)
                         objWrap.TotalCostY3 = integer.valueof(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y3_Quantity__c);
                         
                         if(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y4_Quantity__c!=null)
                         objWrap.TotalCostY4 = integer.valueof(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y4_Quantity__c);
                     }
                
                    if(objWrap.CurrencyRateInUSDY1!=null){                      
                        if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objWrap.CurrencyRateInUSDY1;
                        else lstBudgetLines[intIndex].TotalOfAllY1Cost += objWrap.CurrencyRateInUSDY1;
                    }else if(objWrap.TotalCostY1!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objWrap.TotalCostY1;
                        else lstBudgetLines[intIndex].TotalOfAllY1Cost += objWrap.TotalCostY1;
                    }
                    if(objWrap.CurrencyRateInUSDY2!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objWrap.CurrencyRateInUSDY2;
                        else lstBudgetLines[intIndex].TotalOfAllY2Cost += objWrap.CurrencyRateInUSDY2;
                    } else if(objWrap.TotalCostY2!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objWrap.TotalCostY2;
                        else lstBudgetLines[intIndex].TotalOfAllY2Cost += objWrap.TotalCostY2;
                    }                                
                    if(objWrap.CurrencyRateInUSDY3!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objWrap.CurrencyRateInUSDY3;
                        else lstBudgetLines[intIndex].TotalOfAllY3Cost += objWrap.CurrencyRateInUSDY3;
                    }else if(objWrap.TotalCostY3!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objWrap.TotalCostY3;
                        else lstBudgetLines[intIndex].TotalOfAllY3Cost += objWrap.TotalCostY3;
                    }
                    if(objWrap.CurrencyRateInUSDY4!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objWrap.CurrencyRateInUSDY4;
                        else lstBudgetLines[intIndex].TotalOfAllY4Cost += objWrap.CurrencyRateInUSDY4;
                    }else if(objWrap.TotalCostY4!=null){
                        if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objWrap.TotalCostY4;
                        else lstBudgetLines[intIndex].TotalOfAllY4Cost += objWrap.TotalCostY4;
                    }
                    if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                         if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objwrap.objAssumption.Y1_Number_of_Persons__c * objwrap.objAssumption.Y1_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY1 += (objwrap.objAssumption.Y1_Number_of_Persons__c * objwrap.objAssumption.Y1_Level_of_Effort__c);
                         if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objwrap.objAssumption.Y2_Number_of_Persons__c * objwrap.objAssumption.Y2_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY2 += (objwrap.objAssumption.Y2_Number_of_Persons__c * objwrap.objAssumption.Y2_Level_of_Effort__c);
                         if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objwrap.objAssumption.Y3_Number_of_Persons__c * objwrap.objAssumption.Y3_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY3 += (objwrap.objAssumption.Y3_Number_of_Persons__c * objwrap.objAssumption.Y3_Level_of_Effort__c);
                         if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objwrap.objAssumption.Y4_Number_of_Persons__c * objwrap.objAssumption.Y4_Level_of_Effort__c;
                         else lstBudgetLines[intIndex].TotalQuantityY4 += (objwrap.objAssumption.Y4_Number_of_Persons__c * objwrap.objAssumption.Y4_Level_of_Effort__c);
                           
                     }else{
                        if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objWrap.objAssumption.Y1_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY1 += objWrap.objAssumption.Y1_Quantity__c;
                        if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objWrap.objAssumption.Y2_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY2 += objWrap.objAssumption.Y2_Quantity__c;
                        if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objWrap.objAssumption.Y3_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY3 += objWrap.objAssumption.Y3_Quantity__c;
                        if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objWrap.objAssumption.Y4_Quantity__c;
                        else lstBudgetLines[intIndex].TotalQuantityY4 += objWrap.objAssumption.Y4_Quantity__c;
                    }
                }
                if(lstBudgetLines[intIndex].TotalQuantityY1 != null) lstBudgetLines[intIndex].TotalQuantityY1 = lstBudgetLines[intIndex].TotalQuantityY1/100;
                if(lstBudgetLines[intIndex].TotalQuantityY2 != null) lstBudgetLines[intIndex].TotalQuantityY2 = lstBudgetLines[intIndex].TotalQuantityY2/100;
                if(lstBudgetLines[intIndex].TotalQuantityY3 != null) lstBudgetLines[intIndex].TotalQuantityY3 = lstBudgetLines[intIndex].TotalQuantityY3/100;
                if(lstBudgetLines[intIndex].TotalQuantityY4 != null) lstBudgetLines[intIndex].TotalQuantityY4 = lstBudgetLines[intIndex].TotalQuantityY4/100;
                Integer divideAmount = null;
                if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                    divideAmount = 4;
                }else{
                    divideAmount = 1;
                }
                if(lstBudgetLines[intIndex].TotalQuantityY1 != 0 && lstBudgetLines[intIndex].TotalQuantityY1 != null){
                    lstBudgetLines[intIndex].UnitCostY1 = (lstBudgetLines[intIndex].TotalOfAllY1Cost / lstBudgetLines[intIndex].TotalQuantityY1).setscale(2);
                    lstBudgetLines[intIndex].UnitCostY1 /= divideAmount; 
                }
                if(lstBudgetLines[intIndex].TotalQuantityY2 != 0 && lstBudgetLines[intIndex].TotalQuantityY2 != null){
                    lstBudgetLines[intIndex].UnitCostY2 = (lstBudgetLines[intIndex].TotalOfAllY2Cost / lstBudgetLines[intIndex].TotalQuantityY2).setscale(2);
                    lstBudgetLines[intIndex].UnitCostY2 /= divideAmount; 
                }
                if(lstBudgetLines[intIndex].TotalQuantityY3 != 0 && lstBudgetLines[intIndex].TotalQuantityY3 != null){
                    lstBudgetLines[intIndex].UnitCostY3 = (lstBudgetLines[intIndex].TotalOfAllY3Cost / lstBudgetLines[intIndex].TotalQuantityY3).setscale(2);
                    lstBudgetLines[intIndex].UnitCostY3 /= divideAmount; 
                }
                if(lstBudgetLines[intIndex].TotalQuantityY4 != 0 && lstBudgetLines[intIndex].TotalQuantityY4 != null){
                    lstBudgetLines[intIndex].UnitCostY4 = (lstBudgetLines[intIndex].TotalOfAllY4Cost / lstBudgetLines[intIndex].TotalQuantityY4).setscale(2);
                    lstBudgetLines[intIndex].UnitCostY4 /= divideAmount; 
                }
            }
        }
    }
    Public void EditAssumptionRecords(){
        Integer EditIndex = integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            intIndex = EditIndex;
            AssumptionSetsOptions = new List<SelectOption>();
            AssumptionSetsOptions.add(new SelectOption('','--None--'));
            List<Assumption_Set__c> lstAssmSet = [Select Id,Name From Assumption_Set__c 
                                    Where Cost_Input__c =: lstBudgetLines[EditIndex].objBudgetLine.Cost_Input__c
                                    And Implementation_Period__c =: strImplementationPeriodId];
            if(lstAssmSet.size() > 0){
                for(Assumption_Set__c objAs : lstAssmSet){
                    AssumptionSetsOptions.add(new SelectOption(objAs.id,objAs.Name));
                }
            }
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
            lstBudgetLines[intIndex].TotalOfAllY1Cost= null;
            lstBudgetLines[intIndex].TotalOfAllY2Cost= null;
            lstBudgetLines[intIndex].TotalOfAllY3Cost= null;
            lstBudgetLines[intIndex].TotalOfAllY4Cost= null;
            lstBudgetLines[intIndex].TotalQuantityY1= null;
            lstBudgetLines[intIndex].TotalQuantityY2= null;
            lstBudgetLines[intIndex].TotalQuantityY3= null;
            lstBudgetLines[intIndex].TotalQuantityY4= null;
            for(wrapAssumption objWrap : lstBudgetLines[intIndex].lstAssumptions){
                if(objWrap.objAssumption.Y1_Quantity__c == null) objWrap.objAssumption.Y1_Quantity__c = 0;
                if(objWrap.objAssumption.Y2_Quantity__c == null) objWrap.objAssumption.Y2_Quantity__c = 0;
                if(objWrap.objAssumption.Y3_Quantity__c == null) objWrap.objAssumption.Y3_Quantity__c = 0;
                if(objWrap.objAssumption.Y4_Quantity__c == null) objWrap.objAssumption.Y4_Quantity__c = 0;
                objWrap.objAssumption.Payment_Currency__c = objWrap.strCurrencyUsedAssumption;
                lstAssumptionToUpdate.add(objWrap.objAssumption);
                
                if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                     
                     
                    if(objWrap.objAssumption.Y1_Net_Salary_Payment_Currency__c != null && objWrap.objAssumption.Y1_Social_Security_Obligatory_Charges__c != null )
                    objWrap.TotalSalaryY1 = objWrap.objAssumption.Y1_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y1_Social_Security_Obligatory_Charges__c;
                    if(objWrap.objAssumption.Y2_Net_Salary_Payment_Currency__c != null  && objWrap.objAssumption.Y2_Social_Security_Obligatory_Charges__c != null )
                    objWrap.TotalSalaryY2 = objWrap.objAssumption.Y2_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y2_Social_Security_Obligatory_Charges__c;
                    if(objWrap.objAssumption.Y3_Net_Salary_Payment_Currency__c  != null && objWrap.objAssumption.Y3_Social_Security_Obligatory_Charges__c != null )
                    objWrap.TotalSalaryY3 = objWrap.objAssumption.Y3_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y3_Social_Security_Obligatory_Charges__c;
                    if(objWrap.objAssumption.Y4_Net_Salary_Payment_Currency__c != null  && objWrap.objAssumption.Y4_Social_Security_Obligatory_Charges__c != null )
                    objWrap.TotalSalaryY4 = objWrap.objAssumption.Y4_Net_Salary_Payment_Currency__c + objWrap.objAssumption.Y4_Social_Security_Obligatory_Charges__c;
                     
                     if(objWrap.TotalSalaryY1 != null && objWrap.objAssumption.Y1_Level_of_Effort__c != null && objWrap.objAssumption.Y1_Number_of_Persons__c != null)
                     objWrap.TotalCostY1 = (integer.valueof(objWrap.TotalSalaryY1 * objWrap.objAssumption.Y1_Level_of_Effort__c * objWrap.objAssumption.Y1_Number_of_Persons__c))/100;
                     if(objWrap.TotalSalaryY2 != null && objWrap.objAssumption.Y2_Level_of_Effort__c != null && objWrap.objAssumption.Y2_Number_of_Persons__c != null)
                     objWrap.TotalCostY2 = (integer.valueof(objWrap.TotalSalaryY2 * objWrap.objAssumption.Y2_Level_of_Effort__c * objWrap.objAssumption.Y2_Number_of_Persons__c))/100;
                     if(objWrap.TotalSalaryY3 != null && objWrap.objAssumption.Y3_Level_of_Effort__c != null && objWrap.objAssumption.Y3_Number_of_Persons__c != null)
                     objWrap.TotalCostY3 = (integer.valueof(objWrap.TotalSalaryY3 * objWrap.objAssumption.Y3_Level_of_Effort__c * objWrap.objAssumption.Y3_Number_of_Persons__c))/100;
                     if(objWrap.TotalSalaryY4 != null && objWrap.objAssumption.Y4_Level_of_Effort__c != null && objWrap.objAssumption.Y4_Number_of_Persons__c != null)
                     objWrap.TotalCostY4 = (integer.valueof(objWrap.TotalSalaryY4 * objWrap.objAssumption.Y4_Level_of_Effort__c * objWrap.objAssumption.Y4_Number_of_Persons__c))/100;
                     
                     
                 }else if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '2. Travel related costs (TRC)'){
                     if(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y1_Quantity__c != null && objWrap.objAssumption.Y1_Duration_Days__c != null)
                     objWrap.TotalCostY1 = integer.valueof(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y1_Duration_Days__c * objWrap.objAssumption.Y1_Quantity__c);
                     if(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y2_Quantity__c != null && objWrap.objAssumption.Y2_Duration_Days__c != null)
                     objWrap.TotalCostY2 = integer.valueof(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y2_Duration_Days__c * objWrap.objAssumption.Y2_Quantity__c);
                     if(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y3_Quantity__c != null && objWrap.objAssumption.Y3_Duration_Days__c != null)
                     objWrap.TotalCostY3 = integer.valueof(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y3_Duration_Days__c * objWrap.objAssumption.Y3_Quantity__c);
                     if(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c != null && objWrap.objAssumption.Y4_Quantity__c != null && objWrap.objAssumption.Y4_Duration_Days__c != null)
                     objWrap.TotalCostY4 = integer.valueof(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y4_Duration_Days__c * objWrap.objAssumption.Y4_Quantity__c);
                 }else{
                     if(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y1_Quantity__c!=null)
                     objWrap.TotalCostY1 = integer.valueof(objWrap.objAssumption.Y1_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y1_Quantity__c);
                     
                     if(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y2_Quantity__c!=null)
                     objWrap.TotalCostY2 = integer.valueof(objWrap.objAssumption.Y2_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y2_Quantity__c);

                     if(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y3_Quantity__c!=null)
                     objWrap.TotalCostY3 = integer.valueof(objWrap.objAssumption.Y3_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y3_Quantity__c);
                     
                     if(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c!=null && objWrap.objAssumption.Y4_Quantity__c!=null)
                     objWrap.TotalCostY4 = integer.valueof(objWrap.objAssumption.Y4_Unit_Cost_Payment_Currency__c * objWrap.objAssumption.Y4_Quantity__c);
                 }
                Double conversionRate;
            
                if(objWrap.objAssumption.Payment_Currency__c== 'Local Currency'){
                    conversionRate = conversion_rates.get(strLocalCurrency);
                }else if(objWrap.objAssumption.Payment_Currency__c == 'Other Currency'){
                    conversionRate = conversion_rates.get(strOtherCurrency);
                }
                system.debug('@##@#@#@#'+objNewAssumption.TotalCostY2);
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
                    if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objWrap.CurrencyRateInUSDY1;
                    else lstBudgetLines[intIndex].TotalOfAllY1Cost += objWrap.CurrencyRateInUSDY1;
                }else if(objWrap.TotalCostY1!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objWrap.TotalCostY1;
                    else lstBudgetLines[intIndex].TotalOfAllY1Cost += objWrap.TotalCostY1;
                }
                if(objWrap.CurrencyRateInUSDY2!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objWrap.CurrencyRateInUSDY2;
                    else lstBudgetLines[intIndex].TotalOfAllY2Cost += objWrap.CurrencyRateInUSDY2;
                } else if(objWrap.TotalCostY2!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objWrap.TotalCostY2;
                    else lstBudgetLines[intIndex].TotalOfAllY2Cost += objWrap.TotalCostY2;
                }                                
                if(objWrap.CurrencyRateInUSDY3!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objWrap.CurrencyRateInUSDY3;
                    else lstBudgetLines[intIndex].TotalOfAllY3Cost += objWrap.CurrencyRateInUSDY3;
                }else if(objWrap.TotalCostY3!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objWrap.TotalCostY3;
                    else lstBudgetLines[intIndex].TotalOfAllY3Cost += objWrap.TotalCostY3;
                }
                if(objWrap.CurrencyRateInUSDY4!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objWrap.CurrencyRateInUSDY4;
                    else lstBudgetLines[intIndex].TotalOfAllY4Cost += objWrap.CurrencyRateInUSDY4;
                }else if(objWrap.TotalCostY4!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objWrap.TotalCostY4;
                    else lstBudgetLines[intIndex].TotalOfAllY4Cost += objWrap.TotalCostY4;
                }
                
                if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                    if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objwrap.objAssumption.Y1_Number_of_Persons__c * objwrap.objAssumption.Y1_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY1 += (objwrap.objAssumption.Y1_Number_of_Persons__c * objwrap.objAssumption.Y1_Level_of_Effort__c);
                    if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objwrap.objAssumption.Y2_Number_of_Persons__c * objwrap.objAssumption.Y2_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY2 += (objwrap.objAssumption.Y2_Number_of_Persons__c * objwrap.objAssumption.Y2_Level_of_Effort__c);
                    if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objwrap.objAssumption.Y3_Number_of_Persons__c * objwrap.objAssumption.Y3_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY3 += (objwrap.objAssumption.Y3_Number_of_Persons__c * objwrap.objAssumption.Y3_Level_of_Effort__c);
                    if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objwrap.objAssumption.Y4_Number_of_Persons__c * objwrap.objAssumption.Y4_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY4 += (objwrap.objAssumption.Y4_Number_of_Persons__c * objwrap.objAssumption.Y4_Level_of_Effort__c);
                   
                }else{
                    if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objWrap.objAssumption.Y1_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY1 += objWrap.objAssumption.Y1_Quantity__c;
                    if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objWrap.objAssumption.Y2_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY2 += objWrap.objAssumption.Y2_Quantity__c;
                    if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objWrap.objAssumption.Y3_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY3 += objWrap.objAssumption.Y3_Quantity__c;
                    if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objWrap.objAssumption.Y4_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY4 += objWrap.objAssumption.Y4_Quantity__c;
                }
                
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != null) lstBudgetLines[intIndex].TotalQuantityY1 = lstBudgetLines[intIndex].TotalQuantityY1/100;
            if(lstBudgetLines[intIndex].TotalQuantityY2 != null) lstBudgetLines[intIndex].TotalQuantityY2 = lstBudgetLines[intIndex].TotalQuantityY2/100;
            if(lstBudgetLines[intIndex].TotalQuantityY3 != null) lstBudgetLines[intIndex].TotalQuantityY3 = lstBudgetLines[intIndex].TotalQuantityY3/100;
            if(lstBudgetLines[intIndex].TotalQuantityY4 != null) lstBudgetLines[intIndex].TotalQuantityY4 = lstBudgetLines[intIndex].TotalQuantityY4/100;
           /* 
        if(lstBudgetLines[intIndex].TotalFOQuantityY1 != null) lstBudgetLines[intIndex].TotalFOQuantityY1 = lstBudgetLines[intIndex].TotalFOQuantityY1/100;
            if(lstBudgetLines[intIndex].TotalFOQuantityY2 != null) lstBudgetLines[intIndex].TotalFOQuantityY2 = lstBudgetLines[intIndex].TotalFOQuantityY2/100;
            if(lstBudgetLines[intIndex].TotalFOQuantityY3 != null) lstBudgetLines[intIndex].TotalFOQuantityY3 = lstBudgetLines[intIndex].TotalFOQuantityY3/100;
            if(lstBudgetLines[intIndex].TotalFOQuantityY4 != null) lstBudgetLines[intIndex].TotalFOQuantityY4 = lstBudgetLines[intIndex].TotalFOQuantityY4/100;*/
            
        
        Integer divideAmount = null;
            if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                divideAmount = 4;
            }else{
                divideAmount = 1;
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != 0 && lstBudgetLines[intIndex].TotalQuantityY1 != null){
                lstBudgetLines[intIndex].UnitCostY1 = (lstBudgetLines[intIndex].TotalOfAllY1Cost / lstBudgetLines[intIndex].TotalQuantityY1).setscale(0);
                lstBudgetLines[intIndex].UnitCostY1 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY2 != 0 && lstBudgetLines[intIndex].TotalQuantityY2 != null){
                lstBudgetLines[intIndex].UnitCostY2 = (lstBudgetLines[intIndex].TotalOfAllY2Cost / lstBudgetLines[intIndex].TotalQuantityY2).setscale(0);
                lstBudgetLines[intIndex].UnitCostY2 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY3 != 0 && lstBudgetLines[intIndex].TotalQuantityY3 != null){
                lstBudgetLines[intIndex].UnitCostY3 = (lstBudgetLines[intIndex].TotalOfAllY3Cost / lstBudgetLines[intIndex].TotalQuantityY3).setscale(0);
                lstBudgetLines[intIndex].UnitCostY3 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY4 != 0 && lstBudgetLines[intIndex].TotalQuantityY4 != null){
                lstBudgetLines[intIndex].UnitCostY4 = (lstBudgetLines[intIndex].TotalOfAllY4Cost / lstBudgetLines[intIndex].TotalQuantityY4).setscale(0);
                lstBudgetLines[intIndex].UnitCostY4 /= divideAmount; 
            }
            if(lstAssumptionToUpdate.size() > 0) Update lstAssumptionToUpdate;
            
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c = lstBudgetLines[intIndex].UnitCostY1;
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c = lstBudgetLines[intIndex].UnitCostY2;
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c = lstBudgetLines[intIndex].UnitCostY3;
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c = lstBudgetLines[intIndex].UnitCostY4;
            
            if(lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c = 0;
           
            /*TCS 18/10/2014 Spring 3 US DEtailed Budget*/ 
            /*if(lstBudgetLines[intIndex].objBudgetLine.FO_Q1_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q1_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q2_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q2_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q3_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q3_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q4_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q4_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q5_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q5_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q6_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q6_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q7_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q7_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q8_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q8_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q9_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q9_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q10_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q10_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q11_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q11_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q12_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q12_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q13_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q13_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q14_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q14_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q15_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q15_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q16_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q16_Quantity__c = 0;
           */
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c = 0;
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c = 0;
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c = 0;
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c = 0;
            
            lstBudgetLines[intIndex].objBudgetline.Q1_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q1_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q2_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q2_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q3_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q3_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q4_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q4_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q5_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q5_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q6_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q6_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q7_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q7_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q8_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q8_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q9_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q9_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q10_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q10_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q11_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q11_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q12_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q12_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q13_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q13_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q14_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q14_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q15_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q15_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q16_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q16_Quantity__c).setScale(2);
            
            
            update lstBudgetLines[intIndex].objBudgetline;
            
            
            if(lstBudgetLines[intIndex].UnitCostY1 == null) lstBudgetLines[intIndex].UnitCostY1 = 0;
            if(lstBudgetLines[intIndex].UnitCostY2 == null) lstBudgetLines[intIndex].UnitCostY2 = 0;
            if(lstBudgetLines[intIndex].UnitCostY3 == null) lstBudgetLines[intIndex].UnitCostY3 = 0;
            if(lstBudgetLines[intIndex].UnitCostY4 == null) lstBudgetLines[intIndex].UnitCostY4 = 0;
            
            if(lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c = 0;
           
       /* lstBudgetLines[intIndex].TotalFOQuantityYear1 = lstBudgetLines[intIndex].objBudgetLine.FO_Q1_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q2_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q3_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q4_Quantity__c;
            lstBudgetLines[intIndex].TotalFOQuantityYear2 = lstBudgetLines[intIndex].objBudgetLine.FO_Q5_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q6_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q7_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q8_Quantity__c;
            lstBudgetLines[intIndex].TotalFOQuantityYear3 = lstBudgetLines[intIndex].objBudgetLine.FO_Q9_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q10_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q11_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q12_Quantity__c;
            lstBudgetLines[intIndex].TotalFOQuantityYear4 = lstBudgetLines[intIndex].objBudgetLine.FO_Q13_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q14_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q15_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q16_Quantity__c;
            */
            Decimal FinalRate = null;
            if(lstBudgetLines[intIndex].strCurrencyUsed == strLocalCurrency){
                FinalRate = strLocalCurrencyRate;
            }else if(lstBudgetLines[intIndex].strCurrencyUsed == strOtherCurrency){
                FinalRate = strOtherCurrencyRate;
            }            
            if(FinalRate == null) FinalRate = 1;
            
            lstBudgetLines[intIndex].Q1Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q2Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q3Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q4Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q5Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q6Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q7Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q8Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q9Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q10Case =integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q11Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q12Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q13Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q14Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q15Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q16Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c * FinalRate);  
            
            lstBudgetLines[intIndex].TotalQuantityYear1 = lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c;
            lstBudgetLines[intIndex].TotalQuantityYear2 = lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c;
            lstBudgetLines[intIndex].TotalQuantityYear3 = lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c;
            lstBudgetLines[intIndex].TotalQuantityYear4 = lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c;
            lstBudgetLines[intIndex].TotalCaseYear1 = lstBudgetLines[intIndex].Q1Case + lstBudgetLines[intIndex].Q2Case + lstBudgetLines[intIndex].Q3Case + lstBudgetLines[intIndex].Q4Case;
            lstBudgetLines[intIndex].TotalCaseYear2 = lstBudgetLines[intIndex].Q5Case + lstBudgetLines[intIndex].Q6Case + lstBudgetLines[intIndex].Q7Case + lstBudgetLines[intIndex].Q8Case;
            lstBudgetLines[intIndex].TotalCaseYear3 = lstBudgetLines[intIndex].Q9Case + lstBudgetLines[intIndex].Q10Case + lstBudgetLines[intIndex].Q11Case + lstBudgetLines[intIndex].Q12Case;
            lstBudgetLines[intIndex].TotalCaseYear4 = lstBudgetLines[intIndex].Q13Case + lstBudgetLines[intIndex].Q14Case + lstBudgetLines[intIndex].Q15Case + lstBudgetLines[intIndex].Q16Case;
            
            lstBudgetLines[intIndex].GrantTotalQuantity = lstBudgetLines[intIndex].TotalQuantityYear1 + lstBudgetLines[intIndex].TotalQuantityYear2 + lstBudgetLines[intIndex].TotalQuantityYear3 + lstBudgetLines[intIndex].TotalQuantityYear4;
            lstBudgetLines[intIndex].GrantTotalAmount = lstBudgetLines[intIndex].TotalCaseYear1+ lstBudgetLines[intIndex].TotalCaseYear2+ lstBudgetLines[intIndex].TotalCaseYear3+ lstBudgetLines[intIndex].TotalCaseYear4;
            
            //lstBudgetLines[intIndex].blnHasChild = false;
        }
    }
    Public void SaveAssumptionNew(){
        if(intIndex != null){
        
            objNewAssumption.objAssumption.Budget_Line_Number__c = lstBudgetLines[intIndex].objBudgetLine.Id;
            objNewAssumption.objAssumption.Payment_Currency__c = objNewAssumption.strCurrencyUsedAssumption;
            if(String.IsBlank(strAssumptionSet) == false){
                objNewAssumption.objAssumption.Assumption_Set__c = strAssumptionSet;
            }
            
            system.debug(objNewAssumption.objAssumption);
            insert objNewAssumption.objAssumption;
            
            if(lstBudgetLines[intIndex].lstAssumptions != null && lstBudgetLines[intIndex].lstAssumptions.size() > 0){
                List<Assumption__c> lstAssumptionToUpdate = new List<Assumption__c>();
                for(wrapAssumption objWrap : lstBudgetLines[intIndex].lstAssumptions){
                    objWrap.objAssumption.Payment_Currency__c = objWrap.strCurrencyUsedAssumption;
                    lstAssumptionToUpdate.add(objWrap.objAssumption);       
                }
                
                if(lstAssumptionToUpdate.size() > 0) Update lstAssumptionToUpdate;
            }else{
                lstBudgetLines[intIndex].lstAssumptions = new List<wrapAssumption>();
                //lstBudgetLines[intIndex].lstAssumptions.add(objNewAssumption);
                //lstBudgetLines[intIndex].TotalOfAllY1Cost = objNewAssumption.TotalCostY1;
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
             if(lstAssumptionTemp[0].Y1_Net_Salary_Payment_Currency__c == null) lstAssumptionTemp[0].Y1_Net_Salary_Payment_Currency__c = 0;
             //if(objAssumption.Y1_Total_Salary_Payment_Currency__c == null) objAssumption.Y1_Total_Salary_Payment_Currency__c = 0;
             if(lstAssumptionTemp[0].Y1_Level_of_Effort__c == null) lstAssumptionTemp[0].Y1_Level_of_Effort__c = 0;
             if(lstAssumptionTemp[0].Y1_Social_Security_Obligatory_Charges__c == null) lstAssumptionTemp[0].Y1_Social_Security_Obligatory_Charges__c = 0;
             if(lstAssumptionTemp[0].Y1_Number_of_Persons__c == null) lstAssumptionTemp[0].Y1_Number_of_Persons__c = 0;
             if(lstAssumptionTemp[0].Y1_Duration_Days__c == null) lstAssumptionTemp[0].Y1_Duration_Days__c = 0;

             
             if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                 if(lstAssumptionTemp[0].Y1_Total_Salary_Payment_Currency__c != null && lstAssumptionTemp[0].Y1_Level_of_Effort__c != null && lstAssumptionTemp[0].Y1_Number_of_Persons__c != null)
                 objNewAssumption.TotalCostY1 = (integer.valueof(lstAssumptionTemp[0].Y1_Total_Salary_Payment_Currency__c * lstAssumptionTemp[0].Y1_Level_of_Effort__c * lstAssumptionTemp[0].Y1_Number_of_Persons__c))/100;
                 if(lstAssumptionTemp[0].Y2_Total_Salary_Payment_Currency__c != null && lstAssumptionTemp[0].Y2_Level_of_Effort__c != null && lstAssumptionTemp[0].Y2_Number_of_Persons__c != null)
                 objNewAssumption.TotalCostY2 = (integer.valueof(lstAssumptionTemp[0].Y2_Total_Salary_Payment_Currency__c * lstAssumptionTemp[0].Y2_Level_of_Effort__c * lstAssumptionTemp[0].Y2_Number_of_Persons__c))/100;
                 if(lstAssumptionTemp[0].Y3_Total_Salary_Payment_Currency__c != null && lstAssumptionTemp[0].Y3_Level_of_Effort__c != null && lstAssumptionTemp[0].Y3_Number_of_Persons__c != null)
                 objNewAssumption.TotalCostY3 = (integer.valueof(lstAssumptionTemp[0].Y3_Total_Salary_Payment_Currency__c * lstAssumptionTemp[0].Y3_Level_of_Effort__c * lstAssumptionTemp[0].Y3_Number_of_Persons__c))/100;
                 if(lstAssumptionTemp[0].Y4_Total_Salary_Payment_Currency__c != null && lstAssumptionTemp[0].Y4_Level_of_Effort__c != null && lstAssumptionTemp[0].Y4_Number_of_Persons__c != null)
                 objNewAssumption.TotalCostY4 = (integer.valueof(lstAssumptionTemp[0].Y4_Total_Salary_Payment_Currency__c * lstAssumptionTemp[0].Y4_Level_of_Effort__c * lstAssumptionTemp[0].Y4_Number_of_Persons__c))/100;
                 
                 objNewAssumption.TotalSalaryY1 = lstAssumptionTemp[0].Y1_Total_Salary_Payment_Currency__c;
                 objNewAssumption.TotalSalaryY2 = lstAssumptionTemp[0].Y2_Total_Salary_Payment_Currency__c;
                 objNewAssumption.TotalSalaryY3 = lstAssumptionTemp[0].Y3_Total_Salary_Payment_Currency__c;
                 objNewAssumption.TotalSalaryY4 = lstAssumptionTemp[0].Y4_Total_Salary_Payment_Currency__c;
             }else if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '2. Travel related costs (TRC)'){
                 if(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c != null && lstAssumptionTemp[0].Y1_Quantity__c != null && lstAssumptionTemp[0].Y1_Duration_Days__c != null)
                 objNewAssumption.TotalCostY1 = integer.valueof(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y1_Duration_Days__c * lstAssumptionTemp[0].Y1_Quantity__c);
                 if(lstAssumptionTemp[0].Y2_Unit_Cost_Payment_Currency__c != null && lstAssumptionTemp[0].Y2_Quantity__c != null && lstAssumptionTemp[0].Y2_Duration_Days__c != null)
                 objNewAssumption.TotalCostY2 = integer.valueof(lstAssumptionTemp[0].Y2_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y2_Duration_Days__c * lstAssumptionTemp[0].Y2_Quantity__c);
                 if(lstAssumptionTemp[0].Y3_Unit_Cost_Payment_Currency__c != null && lstAssumptionTemp[0].Y3_Quantity__c != null && lstAssumptionTemp[0].Y3_Duration_Days__c != null)
                 objNewAssumption.TotalCostY3 = integer.valueof(lstAssumptionTemp[0].Y3_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y3_Duration_Days__c * lstAssumptionTemp[0].Y3_Quantity__c);
                 if(lstAssumptionTemp[0].Y4_Unit_Cost_Payment_Currency__c != null && lstAssumptionTemp[0].Y4_Quantity__c != null && lstAssumptionTemp[0].Y4_Duration_Days__c != null)
                 objNewAssumption.TotalCostY4 = integer.valueof(lstAssumptionTemp[0].Y4_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y4_Duration_Days__c * lstAssumptionTemp[0].Y4_Quantity__c);
             }else{
                 if(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y1_Quantity__c!=null)
                 objNewAssumption.TotalCostY1 = integer.valueof(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y1_Quantity__c);
                 
                 if(lstAssumptionTemp[0].Y2_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y2_Quantity__c!=null)
                 objNewAssumption.TotalCostY2 = integer.valueof(lstAssumptionTemp[0].Y2_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y2_Quantity__c);

                 if(lstAssumptionTemp[0].Y3_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y3_Quantity__c!=null)
                 objNewAssumption.TotalCostY3 = integer.valueof(lstAssumptionTemp[0].Y3_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y3_Quantity__c);
                 
                 if(lstAssumptionTemp[0].Y4_Unit_Cost_Payment_Currency__c!=null && lstAssumptionTemp[0].Y4_Quantity__c!=null)
                 objNewAssumption.TotalCostY4 = integer.valueof(lstAssumptionTemp[0].Y4_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y4_Quantity__c);
             }
            
            Double conversionRate;
            
            if(lstAssumptionTemp[0].Payment_Currency__c== 'Local Currency'){
                conversionRate = conversion_rates.get(strLocalCurrency);
            }else if(lstAssumptionTemp[0].Payment_Currency__c == 'Other Currency'){
                conversionRate = conversion_rates.get(strOtherCurrency);
            }
            system.debug('@##@#@#@#'+objNewAssumption.TotalCostY2);
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
            //objNewAssumption.TotalCostY1 = integer.valueof(lstAssumptionTemp[0].Y1_Unit_Cost_Payment_Currency__c * lstAssumptionTemp[0].Y1_Quantity__c);
            //lstBudgetLines[intIndex].TotalOfAllY1Cost = objNewAssumption.TotalCostY1;
            
            lstBudgetLines[intIndex].lstAssumptions.add(objNewAssumption);
            lstBudgetLines[intIndex].TotalOfAllY1Cost= null;
            lstBudgetLines[intIndex].TotalOfAllY2Cost= null;
            lstBudgetLines[intIndex].TotalOfAllY3Cost= null;
            lstBudgetLines[intIndex].TotalOfAllY4Cost= null;
            lstBudgetLines[intIndex].TotalQuantityY1= null;
            lstBudgetLines[intIndex].TotalQuantityY2= null;
            lstBudgetLines[intIndex].TotalQuantityY3= null;
            lstBudgetLines[intIndex].TotalQuantityY4= null;
            for(wrapAssumption objWrap : lstBudgetLines[intIndex].lstAssumptions){

                if(objwrap.objAssumption.Y1_Number_of_Persons__c == null) objwrap.objAssumption.Y1_Number_of_Persons__c = 0;
                if(objwrap.objAssumption.Y2_Number_of_Persons__c == null) objwrap.objAssumption.Y2_Number_of_Persons__c = 0;
                if(objwrap.objAssumption.Y3_Number_of_Persons__c == null) objwrap.objAssumption.Y3_Number_of_Persons__c = 0;
                if(objwrap.objAssumption.Y4_Number_of_Persons__c == null) objwrap.objAssumption.Y4_Number_of_Persons__c = 0;
                if(objwrap.objAssumption.Y1_Quantity__c == null) objwrap.objAssumption.Y1_Quantity__c = 0;
                if(objwrap.objAssumption.Y2_Quantity__c == null) objwrap.objAssumption.Y2_Quantity__c = 0;
                if(objwrap.objAssumption.Y3_Quantity__c == null) objwrap.objAssumption.Y3_Quantity__c = 0;
                if(objwrap.objAssumption.Y4_Quantity__c == null) objwrap.objAssumption.Y4_Quantity__c = 0;
                if(objwrap.objAssumption.Y1_Level_of_Effort__c == null) objwrap.objAssumption.Y1_Level_of_Effort__c = 0;
                 if(objwrap.objAssumption.Y2_Level_of_Effort__c == null) objwrap.objAssumption.Y2_Level_of_Effort__c = 0;
                 if(objwrap.objAssumption.Y3_Level_of_Effort__c == null) objwrap.objAssumption.Y3_Level_of_Effort__c = 0;
                 if(objwrap.objAssumption.Y4_Level_of_Effort__c == null) objwrap.objAssumption.Y4_Level_of_Effort__c = 0;
                if(objWrap.CurrencyRateInUSDY1!=null){                      
                    if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objWrap.CurrencyRateInUSDY1;
                    else lstBudgetLines[intIndex].TotalOfAllY1Cost += objWrap.CurrencyRateInUSDY1;
                }else if(objWrap.TotalCostY1!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY1Cost == null) lstBudgetLines[intIndex].TotalOfAllY1Cost = objWrap.TotalCostY1;
                    else lstBudgetLines[intIndex].TotalOfAllY1Cost += objWrap.TotalCostY1;
                }
                if(objWrap.CurrencyRateInUSDY2!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objWrap.CurrencyRateInUSDY2;
                    else lstBudgetLines[intIndex].TotalOfAllY2Cost += objWrap.CurrencyRateInUSDY2;
                } else if(objWrap.TotalCostY2!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY2Cost == null) lstBudgetLines[intIndex].TotalOfAllY2Cost = objWrap.TotalCostY2;
                    else lstBudgetLines[intIndex].TotalOfAllY2Cost += objWrap.TotalCostY2;
                }                                
                if(objWrap.CurrencyRateInUSDY3!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objWrap.CurrencyRateInUSDY3;
                    else lstBudgetLines[intIndex].TotalOfAllY3Cost += objWrap.CurrencyRateInUSDY3;
                }else if(objWrap.TotalCostY3!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY3Cost == null) lstBudgetLines[intIndex].TotalOfAllY3Cost = objWrap.TotalCostY3;
                    else lstBudgetLines[intIndex].TotalOfAllY3Cost += objWrap.TotalCostY3;
                }
                if(objWrap.CurrencyRateInUSDY4!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objWrap.CurrencyRateInUSDY4;
                    else lstBudgetLines[intIndex].TotalOfAllY4Cost += objWrap.CurrencyRateInUSDY4;
                }else if(objWrap.TotalCostY4!=null){
                    if(lstBudgetLines[intIndex].TotalOfAllY4Cost == null) lstBudgetLines[intIndex].TotalOfAllY4Cost = objWrap.TotalCostY4;
                    else lstBudgetLines[intIndex].TotalOfAllY4Cost += objWrap.TotalCostY4;
                }
                if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                    if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objwrap.objAssumption.Y1_Number_of_Persons__c * objwrap.objAssumption.Y1_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY1 += (objwrap.objAssumption.Y1_Number_of_Persons__c * objwrap.objAssumption.Y1_Level_of_Effort__c);
                    if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objwrap.objAssumption.Y2_Number_of_Persons__c * objwrap.objAssumption.Y2_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY2 += (objwrap.objAssumption.Y2_Number_of_Persons__c * objwrap.objAssumption.Y2_Level_of_Effort__c);
                    if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objwrap.objAssumption.Y3_Number_of_Persons__c * objwrap.objAssumption.Y3_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY3 += (objwrap.objAssumption.Y3_Number_of_Persons__c * objwrap.objAssumption.Y3_Level_of_Effort__c);
                    if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objwrap.objAssumption.Y4_Number_of_Persons__c * objwrap.objAssumption.Y4_Level_of_Effort__c;
                    else lstBudgetLines[intIndex].TotalQuantityY4 += (objwrap.objAssumption.Y4_Number_of_Persons__c * objwrap.objAssumption.Y4_Level_of_Effort__c);
                   
                }else{
                    if(lstBudgetLines[intIndex].TotalQuantityY1 == null) lstBudgetLines[intIndex].TotalQuantityY1 = objwrap.objAssumption.Y1_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY1 += objwrap.objAssumption.Y1_Quantity__c;
                    if(lstBudgetLines[intIndex].TotalQuantityY2 == null) lstBudgetLines[intIndex].TotalQuantityY2 = objwrap.objAssumption.Y2_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY2 += objwrap.objAssumption.Y2_Quantity__c;
                    if(lstBudgetLines[intIndex].TotalQuantityY3 == null) lstBudgetLines[intIndex].TotalQuantityY3 = objwrap.objAssumption.Y3_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY3 += objwrap.objAssumption.Y3_Quantity__c;
                    if(lstBudgetLines[intIndex].TotalQuantityY4 == null) lstBudgetLines[intIndex].TotalQuantityY4 = objwrap.objAssumption.Y4_Quantity__c;
                    else lstBudgetLines[intIndex].TotalQuantityY4 += objwrap.objAssumption.Y4_Quantity__c;
                
                }
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != null) lstBudgetLines[intIndex].TotalQuantityY1 = lstBudgetLines[intIndex].TotalQuantityY1/100;
            if(lstBudgetLines[intIndex].TotalQuantityY2 != null) lstBudgetLines[intIndex].TotalQuantityY2 = lstBudgetLines[intIndex].TotalQuantityY2/100;
            if(lstBudgetLines[intIndex].TotalQuantityY3 != null) lstBudgetLines[intIndex].TotalQuantityY3 = lstBudgetLines[intIndex].TotalQuantityY3/100;
            if(lstBudgetLines[intIndex].TotalQuantityY4 != null) lstBudgetLines[intIndex].TotalQuantityY4 = lstBudgetLines[intIndex].TotalQuantityY4/100;
            Integer divideAmount = null;
            if(lstBudgetLines[intIndex].objBudgetLine.Cost_Input__r.Cost_Grouping__c == '1. Human Resources (HR)'){
                divideAmount = 4;
            }else{
                divideAmount = 1;
            }
            if(lstBudgetLines[intIndex].TotalQuantityY1 != 0 && lstBudgetLines[intIndex].TotalQuantityY1 != null){
                lstBudgetLines[intIndex].UnitCostY1 = (lstBudgetLines[intIndex].TotalOfAllY1Cost / lstBudgetLines[intIndex].TotalQuantityY1).setscale(0);
                lstBudgetLines[intIndex].UnitCostY1 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY2 != 0 && lstBudgetLines[intIndex].TotalQuantityY2 != null){
                lstBudgetLines[intIndex].UnitCostY2 = (lstBudgetLines[intIndex].TotalOfAllY2Cost / lstBudgetLines[intIndex].TotalQuantityY2).setscale(0);
                lstBudgetLines[intIndex].UnitCostY2 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY3 != 0 && lstBudgetLines[intIndex].TotalQuantityY3 != null){
                lstBudgetLines[intIndex].UnitCostY3 = (lstBudgetLines[intIndex].TotalOfAllY3Cost / lstBudgetLines[intIndex].TotalQuantityY3).setscale(0);
                lstBudgetLines[intIndex].UnitCostY3 /= divideAmount; 
            }
            if(lstBudgetLines[intIndex].TotalQuantityY4 != 0 && lstBudgetLines[intIndex].TotalQuantityY4 != null){
                lstBudgetLines[intIndex].UnitCostY4 = (lstBudgetLines[intIndex].TotalOfAllY4Cost / lstBudgetLines[intIndex].TotalQuantityY4).setscale(0);
                lstBudgetLines[intIndex].UnitCostY4 /= divideAmount; 
            }    
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c = lstBudgetLines[intIndex].UnitCostY1;
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c = lstBudgetLines[intIndex].UnitCostY2;
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c = lstBudgetLines[intIndex].UnitCostY3;
            lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c = lstBudgetLines[intIndex].UnitCostY4;
            
            
            if(lstBudgetLines[intIndex].UnitCostY1 == null) lstBudgetLines[intIndex].UnitCostY1 = 0;
            if(lstBudgetLines[intIndex].UnitCostY2 == null) lstBudgetLines[intIndex].UnitCostY2 = 0;
            if(lstBudgetLines[intIndex].UnitCostY3 == null) lstBudgetLines[intIndex].UnitCostY3 = 0;
            if(lstBudgetLines[intIndex].UnitCostY4 == null) lstBudgetLines[intIndex].UnitCostY4 = 0;            
            
            if(lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c = 0;
           
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c = 0;
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c = 0;
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c = 0;
            if(lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c == null) lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c = 0;
            
            lstBudgetLines[intIndex].objBudgetline.Q1_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q1_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q2_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q2_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q3_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q3_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q4_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y1__c * lstBudgetLines[intIndex].objBudgetline.Q4_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q5_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q5_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q6_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q6_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q7_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q7_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q8_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y2__c * lstBudgetLines[intIndex].objBudgetline.Q8_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q9_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q9_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q10_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q10_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q11_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q11_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q12_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y3__c * lstBudgetLines[intIndex].objBudgetline.Q12_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q13_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q13_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q14_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q14_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q15_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q15_Quantity__c).setScale(2);
            lstBudgetLines[intIndex].objBudgetline.Q16_Amount__c = (lstBudgetLines[intIndex].objBudgetline.Unit_Cost_Y4__c * lstBudgetLines[intIndex].objBudgetline.Q16_Quantity__c).setScale(2);
           
        /*TCS 18/10/2014 Spring 3 US DEtailed Budget*/ 
           /* if(lstBudgetLines[intIndex].objBudgetLine.FO_Q1_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q1_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q2_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q2_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q3_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q3_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q4_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q4_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q5_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q5_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q6_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q6_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q7_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q7_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q8_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q8_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q9_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q9_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q10_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q10_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q11_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q11_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q12_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q12_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q13_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q13_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q14_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q14_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q15_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q15_Quantity__c = 0;
            if(lstBudgetLines[intIndex].objBudgetLine.FO_Q16_Quantity__c == null) lstBudgetLines[intIndex].objBudgetLine.FO_Q16_Quantity__c = 0;
           */
            update lstBudgetLines[intIndex].objBudgetline;
           
            Decimal FinalRate = null;
            if(lstBudgetLines[intIndex].strCurrencyUsed == strLocalCurrency){
                FinalRate = strLocalCurrencyRate;
            }else if(lstBudgetLines[intIndex].strCurrencyUsed == strOtherCurrency){
                FinalRate = strOtherCurrencyRate;
            }            
            if(FinalRate == null) FinalRate = 1;
            lstBudgetLines[intIndex].Q1Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q2Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q3Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q4Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY1 * lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q5Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q6Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q7Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q8Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY2 * lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q9Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q10Case =integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q11Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q12Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY3 * lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q13Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q14Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q15Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c * FinalRate);
            lstBudgetLines[intIndex].Q16Case = integer.valueof(lstBudgetLines[intIndex].UnitCostY4 * lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c * FinalRate);  
            
            lstBudgetLines[intIndex].TotalQuantityYear1 = lstBudgetLines[intIndex].objBudgetLine.Q1_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q2_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q3_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q4_Quantity__c;
            lstBudgetLines[intIndex].TotalQuantityYear2 = lstBudgetLines[intIndex].objBudgetLine.Q5_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q6_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q7_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q8_Quantity__c;
            lstBudgetLines[intIndex].TotalQuantityYear3 = lstBudgetLines[intIndex].objBudgetLine.Q9_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q10_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q11_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q12_Quantity__c;
            lstBudgetLines[intIndex].TotalQuantityYear4 = lstBudgetLines[intIndex].objBudgetLine.Q13_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q14_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q15_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.Q16_Quantity__c;
            lstBudgetLines[intIndex].TotalCaseYear1 = lstBudgetLines[intIndex].Q1Case + lstBudgetLines[intIndex].Q2Case + lstBudgetLines[intIndex].Q3Case + lstBudgetLines[intIndex].Q4Case;
            lstBudgetLines[intIndex].TotalCaseYear2 = lstBudgetLines[intIndex].Q5Case + lstBudgetLines[intIndex].Q6Case + lstBudgetLines[intIndex].Q7Case + lstBudgetLines[intIndex].Q8Case;
            lstBudgetLines[intIndex].TotalCaseYear3 = lstBudgetLines[intIndex].Q9Case + lstBudgetLines[intIndex].Q10Case + lstBudgetLines[intIndex].Q11Case + lstBudgetLines[intIndex].Q12Case;
            lstBudgetLines[intIndex].TotalCaseYear4 = lstBudgetLines[intIndex].Q13Case + lstBudgetLines[intIndex].Q14Case + lstBudgetLines[intIndex].Q15Case + lstBudgetLines[intIndex].Q16Case;
            
            lstBudgetLines[intIndex].GrantTotalQuantity = lstBudgetLines[intIndex].TotalQuantityYear1 + lstBudgetLines[intIndex].TotalQuantityYear2 + lstBudgetLines[intIndex].TotalQuantityYear3 + lstBudgetLines[intIndex].TotalQuantityYear4;
            lstBudgetLines[intIndex].GrantTotalAmount = lstBudgetLines[intIndex].TotalCaseYear1+ lstBudgetLines[intIndex].TotalCaseYear2+ lstBudgetLines[intIndex].TotalCaseYear3+ lstBudgetLines[intIndex].TotalCaseYear4;
            
        /*lstBudgetLines[intIndex].TotalFOQuantityYear1 = lstBudgetLines[intIndex].objBudgetLine.FO_Q1_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q2_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q3_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q4_Quantity__c;
            lstBudgetLines[intIndex].TotalFOQuantityYear2 = lstBudgetLines[intIndex].objBudgetLine.FO_Q5_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q6_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q7_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q8_Quantity__c;
            lstBudgetLines[intIndex].TotalFOQuantityYear3 = lstBudgetLines[intIndex].objBudgetLine.FO_Q9_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q10_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q11_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q12_Quantity__c;
            lstBudgetLines[intIndex].TotalFOQuantityYear4 = lstBudgetLines[intIndex].objBudgetLine.FO_Q13_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q14_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q15_Quantity__c + lstBudgetLines[intIndex].objBudgetLine.FO_Q16_Quantity__c;
            */
            //lstBudgetLines[intIndex].blnhasChild = false;
            objNewAssumption = new wrapAssumption();
            objNewAssumption.objAssumption = new Assumption__c();
            /*if(lstBudgetLines[intIndex].lstAssumptions != null && lstBudgetLines[intIndex].lstAssumptions.size() > 0){
            SaveAssumption();
            }*/
        }
    }
    Public Boolean blnHasNoChild {get;set;}
    Public void OpenAssumptionNoRecords(){
        Integer OpenBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('OpenBLIndex'));
        System.debug(OpenBLIndex+'OpenBLIndex');
        if(OpenBLIndex != null){
            lstBudgetLines[OpenBLIndex].blnHasNoChild = true;
        }
    }
    Public void SaveBLAssumptionNoRecords(){
        Integer SaveBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SaveBLIndex'));
        if(SaveBLIndex != null){
           update lstBudgetLines[SaveBLIndex].objBudgetLine;
           lstBudgetLines[SaveBLIndex].blnHasNoChild = false;
        }
    }
    Public void CancelBLAssumptionNoRecords(){
        Integer CancelBLIndex = integer.valueof(Apexpages.currentpage().getparameters().get('CancelBLIndex'));
        if(CancelBLIndex != null){           
           lstBudgetLines[CancelBLIndex].blnHasNoChild = false;
        }
    }
    
    Public void NewBudgetLine(){
        objBudgetLineNewRow = new Budget_Line__c();
    }
    
    //TCS 25/08/2014: Added below code for Profile Access
    public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
        List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting__c where Page_Name__c ='GMDetailedBudget' and Profile_Name__c =: profilename];
        system.debug(checkpage);
        for (Profile_Access_Setting__c check : checkpage){
            if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
            if(check.Salesforce_Item__c == 'Add Budget Line'  && check.Status__c == strBudgetStatus)blnAddBL = true;
            if(check.Salesforce_Item__c == 'Edit' && check.Status__c == strBudgetStatus)blnEdit = true;
            if(check.Salesforce_Item__c == 'PR Comments' && check.Status__c == strBudgetStatus)blnPRComment = true;
            if(check.Salesforce_Item__c == 'Edit LFA Comments' && check.Status__c == strBudgetStatus)blnLFAComment = true;
            if(check.Salesforce_Item__c == 'TGF Comments' && check.Status__c == strBudgetStatus)blnTGFComment = true;
            if(check.Salesforce_Item__c == 'Cost Input Level' && check.Status__c == strBudgetStatus)blnCILevel = true;
            if(check.Salesforce_Item__c == 'Delete' && check.Status__c == strBudgetStatus)blnDelete = true;
            if(check.Salesforce_Item__c == 'Cost Grouping' && check.Status__c == strBudgetStatus)blnCGLevel = true;
            if(check.Salesforce_Item__c == 'Manage Assuption Sets' && check.Status__c == strBudgetStatus)blnMAset = true;
            if(check.Salesforce_Item__c == 'Add Assumption' && check.Status__c == strBudgetStatus)blnAddAssumption = true;
            if(check.Salesforce_Item__c == 'Save Assumption' && check.Status__c == strBudgetStatus)blnSaveAssumption = true;
            if(check.Salesforce_Item__c == 'Delete Assumption' && check.Status__c == strBudgetStatus)blnDelAssumption = true;
            if(check.Salesforce_Item__c == 'SaveBLAssumption NoRecords' && check.Status__c == strBudgetStatus)blnSaveBLAss = true;
            if(check.Salesforce_Item__c == 'Dialogue PR')blnDialoguePR = true;
            if(check.Salesforce_Item__c == 'Dialogue LFA')blnDialogueLFA = true;
            if(check.Salesforce_Item__c == 'Dialogue TGF')blnDialogueTGF = true;
            if(check.Salesforce_Item__c == 'Edit FO Fields' && check.Status__c == strBudgetStatus)blnEditFOFields = true;
            if(check.Salesforce_Item__c == 'Edit PR Fields' && check.Status__c == strBudgetStatus)blnEditPRFields = true;
            if(check.Salesforce_Item__c == 'LFA Flag' && check.Status__c == strBudgetStatus)blnLFAFlag = true;
            if(check.Salesforce_Item__c == 'See LFA Comments' && check.Status__c == strBudgetStatus)blnSeeLFAComments = true;
            if(check.Salesforce_Item__c == 'Edit LFA Fields' && check.Status__c == strBudgetStatus)blnEditLFAFields = true;
            if(check.Salesforce_Item__c == 'See LFA Fields' && check.Status__c == strBudgetStatus)blnSeeLFAFields = true;
            if(check.Salesforce_Item__c == 'SeeFOFields' && check.Status__c == strBudgetStatus)blnSeeFOFields = true;
            if(check.Salesforce_Item__c == 'Edit Intervention' && check.Status__c == strBudgetStatus)blnEditIntervention = true;
            if(check.Salesforce_Item__c == 'Edit Recipient' && check.Status__c == strBudgetStatus)blnEditRecipient = true;
            if(check.Salesforce_Item__c == 'Edit Activity' && check.Status__c == strBudgetStatus)blnEditActivity = true;
            if(check.Salesforce_Item__c == 'Edit Currency' && check.Status__c == strBudgetStatus)blnEditCurrency = true;
         }
         system.debug('PR Fields'+blnEditPRFields);
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
        Public String strCostGrp {get;set;}
        Public Catalog_cost_input__c inputCost{get;set;}
        Public Decimal GrantTotalQuantity {get;set;}
        Public Decimal GrantTotalAmount {get;set;}
        Public Decimal TotalOfAllY1Cost {get;set;}
        Public Decimal TotalOfAllY2Cost {get;set;}
        Public Decimal TotalOfAllY3Cost {get;set;}
        Public Decimal TotalOfAllY4Cost {get;set;}
        //Using for Assumption
        Public Decimal UnitCostY1 {get;set;}
        Public Decimal UnitCostY2 {get;set;}
        Public Decimal UnitCostY3 {get;set;}
        Public Decimal UnitCostY4 {get;set;}
        Public Decimal TotalQuantityY1;
        Public Decimal TotalQuantityY2;
        Public Decimal TotalQuantityY3;
        Public Decimal TotalQuantityY4;
        Public List<wrapAssumption> lstAssumptions {get;set;}
        Public Integer NumberOfPersons {get;set;}
        Public Boolean blnHasChild{get;set;}
        Public Boolean blnHasNoChild {get;set;}
        Public Double Q1Case {get;set;}
        Public Double Q2Case {get;set;}
        Public Double Q3Case {get;set;}
        Public Double Q4Case {get;set;}
        Public Double Q5Case {get;set;}
        Public Double Q6Case {get;set;}
        Public Double Q7Case {get;set;}
        Public Double Q8Case {get;set;}
        Public Double Q9Case {get;set;}
        Public Double Q10Case {get;set;}
        Public Double Q11Case {get;set;}
        Public Double Q12Case {get;set;}
        Public Double Q13Case {get;set;}
        Public Double Q14Case {get;set;}
        Public Double Q15Case {get;set;}
        Public Double Q16Case {get;set;}
        
        Public Double TotalQuantityYear1 {get;set;}
        Public Double TotalQuantityYear2 {get;set;}
        Public Double TotalQuantityYear3 {get;set;}
        Public Double TotalQuantityYear4 {get;set;}
        Public Double TotalCaseYear1 {get;set;}
        Public Double TotalCaseYear2 {get;set;}
        Public Double TotalCaseYear3 {get;set;}
        Public Double TotalCaseYear4 {get;set;}
        
        Public Decimal TotalFOQuantityYear1 {get;set;}
        Public Decimal TotalFOQuantityYear2 {get;set;}
        Public Decimal TotalFOQuantityYear3 {get;set;}
        Public Decimal TotalFOQuantityYear4 {get;set;}
        Public Boolean blnSetColor {get; set;}
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