Public class updateCPFGrantInterventions {

Public static void updateCPF(Set<Id> cnIds) {

Map<String,Integer> MapDisplayMonth = new Map<String,Integer>();  
    MapDisplayMonth.put('January',1);
    MapDisplayMonth.put('February',2);
    MapDisplayMonth.put('March',3);
    MapDisplayMonth.put('April',4);
    MapDisplayMonth.put('May',5);
    MapDisplayMonth.put('June',6);
    MapDisplayMonth.put('July',7);
    MapDisplayMonth.put('August',8);
    MapDisplayMonth.put('September',9);
    MapDisplayMonth.put('October',10);
    MapDisplayMonth.put('November',11);
    MapDisplayMonth.put('December',12);

//Set<Id> for grouping modules by component
Set<Id> setHIVModIds = new Set<Id>();
Set<Id> setTBModIds = new Set<Id>();
Set<Id> setCModIds = new Set<Id>();

//List of CPF Reports to update at the end
List<CPF_Report__c> lstCPFtoUpdate = new List<CPF_Report__c>();

List<Module__c> lstModules = [Select Id, Catalog_Module__r.Component_Multi__c from Module__c 
                              WHERE CN_Module__r.Concept_Note__c in :cnIds];
   if(!lstModules.isEmpty()){
       System.Debug(lstModules);
       for(Module__c m : lstModules){
           if(m.Catalog_Module__r.Component_Multi__c != null){
               String comp = getComponent(m.Catalog_Module__r.Component_Multi__c.split(';',0));
               System.Debug('comp String = ' + comp);
               if(comp == 'H') setHIVModIds.add(m.Id);
               else if(comp == 'T') setTBModIds.add(m.Id);
               else if(comp == 'C') setCModIds.add(m.Id);
           }
           
       }
   }
   



//We are no longer going to use this list; we will use the CN list instead
List<CPF_Report__c> lstCPFReport = [Select Id, Concept_Note__c, Above_Indicative_Y1__c, Above_Indicative_Y2__c, 
                                    Above_Indicative_Y3__c,Above_Indicative_Y4__c,
                                    Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c, Indicative_Y4__c,
                                    Concept_Note__r.CCM_New__r.Country__r.Fiscal_Cycle_End_Month__c, Component__c,
                                    Concept_Note__r.Component__c
                                     from CPF_Report__c where Concept_Note__c in :cnIds];
                                     System.Debug('%%% lstCPFReport: ' + lstCPFReport);

//test.Starttest();                               
List<Concept_Note__c> lstConceptNotes = [Select Name, Id, Component__c, CCM_New__r.Country__r.Fiscal_Cycle_End_Month__c,
                                            Number_of_Years__c, Start_Date__c, Concept_Note_Submission_Date__c, 
                                            Concept_Note_Submission_Month__c, CCM_New__r.Country__r.Country_Fiscal_Cycle_Start_Date__c,
                                            (Select Above_Indicative_Y1__c, Above_Indicative_Y2__c, 
                                                Above_Indicative_Y3__c,Above_Indicative_Y4__c,
                                                Indicative_Y1__c,Indicative_Y2__c,Indicative_Y3__c, Indicative_Y4__c,
                                                Component__c from CPF_Reports__r) from Concept_Note__c
                                                WHERE Id in : cnIds limit 1];
//test.Stoptest();

List<AggregateResult> lstBudgetHIV = [Select 
                                Sum(Above_Indicative_Y1__c) AY1, Sum(Above_Indicative_Y2__c) AY2,
                                Sum(Above_Indicative_Y3__c) AY3, Sum(Above_Indicative_Y4__c) AY4,                                
                                Sum(Indicative_Y1__c) Y1, Sum(Indicative_Y2__c) Y2,
                                Sum(Indicative_Y3__c) Y3, Sum(Indicative_Y4__c) Y4,
                                Implementation_Period__r.Concept_Note__c CN
                                    From Grant_Intervention__c 
                                    Where CN_Intervention__r.Module_rel__r.Concept_Note__c in : cnIds
                                    And Module__c in : setHIVModIds
                                    GROUP BY Implementation_Period__r.Concept_Note__c];
                                    
List<AggregateResult> lstBudgetTB = [Select 
                                Sum(Above_Indicative_Y1__c) AY1, Sum(Above_Indicative_Y2__c) AY2,
                                Sum(Above_Indicative_Y3__c) AY3, Sum(Above_Indicative_Y4__c) AY4,                                
                                Sum(Indicative_Y1__c) Y1, Sum(Indicative_Y2__c) Y2,
                                Sum(Indicative_Y3__c) Y3, Sum(Indicative_Y4__c) Y4,
                                Implementation_Period__r.Concept_Note__c CN
                                    From Grant_Intervention__c 
                                    Where CN_Intervention__r.Module_rel__r.Concept_Note__c in : cnIds
                                    And Module__c in : setTBModIds
                                    GROUP BY Implementation_Period__r.Concept_Note__c];
                                     
List<AggregateResult> lstBudgetC = [Select 
                                Sum(Above_Indicative_Y1__c) AY1, Sum(Above_Indicative_Y2__c) AY2,
                                Sum(Above_Indicative_Y3__c) AY3, Sum(Above_Indicative_Y4__c) AY4,                                
                                Sum(Indicative_Y1__c) Y1, Sum(Indicative_Y2__c) Y2,
                                Sum(Indicative_Y3__c) Y3, Sum(Indicative_Y4__c) Y4,
                                Implementation_Period__r.Concept_Note__c CN
                                    From Grant_Intervention__c 
                                    Where CN_Intervention__r.Module_rel__r.Concept_Note__c in : cnIds
                                    And Module__c in : setCModIds
                                    GROUP BY Implementation_Period__r.Concept_Note__c];                                      

List<AggregateResult> lstIndicativeValues = [Select 
                                Sum(Above_Indicative_Y1__c) AY1, Sum(Above_Indicative_Y2__c) AY2,
                                Sum(Above_Indicative_Y3__c) AY3, Sum(Above_Indicative_Y4__c) AY4,                                
                                Sum(Indicative_Y1__c) Y1, Sum(Indicative_Y2__c) Y2,
                                Sum(Indicative_Y3__c) Y3, Sum(Indicative_Y4__c) Y4,
                                Implementation_Period__r.Concept_Note__c CN
                                    From Grant_Intervention__c 
                                    Where CN_Intervention__r.Module_rel__r.Concept_Note__c in : cnIds
                                    GROUP BY Implementation_Period__r.Concept_Note__c];
                                    
                                    
for(Concept_Note__c objCN : lstConceptNotes){

    //Added 2014.07.21 to resolve incident INC011312
    for(AggregateResult objAgg : lstIndicativeValues){
        if(objAgg.get('CN') == objCN.Id){
            objCN.Allocated_Year_1__c = (Decimal)objAgg.get('Y1');
            objCN.Allocated_Year_2__c = (Decimal)objAgg.get('Y2');
            objCN.Allocated_Year_3__c = (Decimal)objAgg.get('Y3');
            objCN.Allocated_Year_4__c = (Decimal)objAgg.get('Y4');
            
            objCN.Above_Allocated_Year_1__c = (Decimal)objAgg.get('AY1');
            objCN.Above_Allocated_Year_2__c = (Decimal)objAgg.get('AY2');
            objCN.Above_Allocated_Year_3__c = (Decimal)objAgg.get('AY3');
            objCN.Above_Allocated_Year_4__c = (Decimal)objAgg.get('AY4'); 
            
            if(objCN.Allocated_Year_1__c == null) objCN.Allocated_Year_1__c = 0;
            if(objCN.Allocated_Year_2__c == null) objCN.Allocated_Year_2__c = 0;
            if(objCN.Allocated_Year_3__c == null) objCN.Allocated_Year_3__c = 0;
            if(objCN.Allocated_Year_4__c == null) objCN.Allocated_Year_4__c = 0;
            
            if(objCN.Above_Allocated_Year_1__c == null) objCN.Above_Allocated_Year_1__c = 0;
            if(objCN.Above_Allocated_Year_2__c == null) objCN.Above_Allocated_Year_2__c = 0;
            if(objCN.Above_Allocated_Year_3__c == null) objCN.Above_Allocated_Year_3__c = 0;
            if(objCN.Above_Allocated_Year_4__c == null) objCN.Above_Allocated_Year_4__c = 0;            
        }
    }


    //added by Matthew Miller on 22/5/2014. This boolean refers to whether the CN application year and start year are the same
    Boolean blnCPFAligned = true;
    if(objCN.Concept_Note_Submission_Date__c != null && objCN.Start_Date__c != null && objCN.Concept_Note_Submission_Month__c != null && objCN.CCM_New__r.Country__r.Country_Fiscal_Cycle_Start_Date__c != null){
        Date subDate = Date.newInstance(Integer.valueOf(objCN.Concept_Note_Submission_Date__c.substring(objCN.Concept_Note_Submission_Date__c.length()-4)), Integer.valueOf(objCN.Concept_Note_Submission_Month__c), 15);    
        if(getFY(objCN.Start_Date__c, objCN.CCM_New__r.Country__r.Country_Fiscal_Cycle_Start_Date__c.month()) != getFY(subDate, objCN.CCM_New__r.Country__r.Country_Fiscal_Cycle_Start_Date__c.month())){
            blnCPFAligned = false;
            System.Debug('%%% Year comparison: ' + objCN.Concept_Note_Submission_Date__c.substring(objCN.Concept_Note_Submission_Date__c.length()-4) + ' = ' + String.valueOf(objCN.Start_Date__c.year()));
        }
       /* if(objCN.Concept_Note_Submission_Date__c.substring(objCN.Concept_Note_Submission_Date__c.length()-4) != String.valueOf(objCN.Start_Date__c.year())){
            blnCPFAligned = false;
            System.Debug('%%% Year comparison: ' + objCN.Concept_Note_Submission_Date__c.substring(objCN.Concept_Note_Submission_Date__c.length()-4) + ' = ' + String.valueOf(objCN.Start_Date__c.year())); 
            
        }*/
    }
    System.Debug('%%% CN Name and blnCPFAligned: '+objCN.Name + ' / ' + blnCPFAligned);
 
    //Fiscal Year Ratio i.e. how a given calendar year is split between two fiscal years     
    Decimal FYratio;
    if(objCN.CCM_New__r.Country__r.Fiscal_Cycle_End_Month__c != null){
      if(MapDisplayMonth.get(objCN.CCM_New__r.Country__r.Fiscal_Cycle_End_Month__c) != null){
        FYratio = (Decimal.valueOf(MapDisplayMonth.get(objCN.CCM_New__r.Country__r.Fiscal_Cycle_End_Month__c)) / 12);
      }
    }


 //NON-COMBINED SCENARIO
 if(objCN.Component__c != 'HIV/TB'){
 System.Debug('%%% Concept Note '+ objCN.Name + ' is in Non-Combined Scenario');
 
  for(CPF_Report__c cpf : objCN.CPF_Reports__r) {
  
    //Clear all the values first
    cpf.Indicative_Y1__c = 0;
    cpf.Indicative_Y2__c = 0;
    cpf.Indicative_Y3__c = 0;
    cpf.Indicative_Y4__c  = 0;
    cpf.Above_Indicative_Y1__c  = 0;
    cpf.Above_Indicative_Y2__c = 0;
    cpf.Above_Indicative_Y3__c = 0;
    cpf.Above_Indicative_Y4__c = 0;
                                                                                                                                                              
    for(AggregateResult objAgg : lstIndicativeValues) {
            if(objAgg.get('CN') == objCN.Id) {
                 if(FYRatio != null){
                      System.Debug('%%% CN: ' + objAgg.get('CN'));
                      System.Debug('%%% objAgg: ' + objAgg); 
                    Decimal AY1 = (Decimal)objAgg.get('AY1'); 
                     if(AY1 == null) AY1 = 0;            
                    Decimal AY2 = (Decimal)objAgg.get('AY2');  
                     if(AY2 == null) AY2 = 0;            
                    Decimal AY3 = (Decimal)objAgg.get('AY3');
                     if(AY3 == null) AY3 = 0;                    
                    Decimal AY4 = (Decimal)objAgg.get('AY4');  
                     if(AY4 == null) AY4 = 0;                  
                    Decimal Y1 = (Decimal)objAgg.get('Y1');   
                     if(Y1 == null) Y1 = 0;                 
                    Decimal Y2 = (Decimal)objAgg.get('Y2');    
                     if(Y2 == null) Y2 = 0;               
                    Decimal Y3 = (Decimal)objAgg.get('Y3'); 
                     if(Y3 == null) Y3 = 0;                 
                    Decimal Y4 = (Decimal)objAgg.get('Y4');
                      if(Y4 == null) Y4 = 0;
                    
                    //This section updated by Matthew Miller on 23/5/2014 according to instructions from Mans                
                    if(blnCPFAligned){    
                        cpf.Above_Indicative_Y1__c = AY1 * FYRatio;
                        cpf.Above_Indicative_Y2__c = AY2 * FYRatio + AY1 *(1-FYRatio);
                        cpf.Above_Indicative_Y3__c = AY3 * FYRatio + AY2 *(1-FYRatio);
                        cpf.Above_Indicative_Y4__c = AY4 * FYRatio + AY3 *(1-FYRatio);
                        
                        cpf.Indicative_Y1__c = Y1 * FYRatio;
                        cpf.Indicative_Y2__c = Y2 * FYRatio + Y1 *(1-FYRatio);
                        cpf.Indicative_Y3__c = Y3 * FYRatio + Y2 *(1-FYRatio);
                        cpf.Indicative_Y4__c = Y4 * FYRatio + Y3 *(1-FYRatio);

                     }else {
                        cpf.Above_Indicative_Y1__c = 0;
                        cpf.Above_Indicative_Y2__c = AY1 * FYRatio;
                        cpf.Above_Indicative_Y3__c = AY2 * FYRatio + AY1 *(1-FYRatio);
                        cpf.Above_Indicative_Y4__c = AY3 * FYRatio + AY2 *(1-FYRatio);
                        
                        cpf.Indicative_Y1__c = 0;
                        cpf.Indicative_Y2__c = Y1 * FYRatio;
                        cpf.Indicative_Y3__c = Y2 * FYRatio + Y1 *(1-FYRatio);
                        cpf.Indicative_Y4__c = Y3 * FYRatio + Y2 *(1-FYRatio);
                     }


                        if(cpf.Indicative_Y1__c == null) cpf.Indicative_Y1__c = 0;
                        if(cpf.Indicative_Y2__c == null) cpf.Indicative_Y2__c = 0;
                        if(cpf.Indicative_Y3__c == null) cpf.Indicative_Y3__c = 0;
                        if(cpf.Indicative_Y4__c == null) cpf.Indicative_Y4__c  = 0;
                        if(cpf.Above_Indicative_Y1__c == null) cpf.Above_Indicative_Y1__c  = 0;
                        if(cpf.Above_Indicative_Y2__c  == null) cpf.Above_Indicative_Y2__c = 0;
                        if(cpf.Above_Indicative_Y3__c == null) cpf.Above_Indicative_Y3__c = 0;
                        if(cpf.Above_Indicative_Y4__c  == null) cpf.Above_Indicative_Y4__c = 0;
                  }  
                    break;
                }
          }
          //update cpf; 
          lstCPFtoUpdate.add(cpf);         
       }
     }//End Non-Combined scenario
     
     
     //COMBINED CONCEPT NOTE (HIV/TB) SCENARIO
    else {
     System.Debug('%%% Concept Note '+ objCN.Name + ' is in Combined HIV/TB Scenario');
    
    //FUNDING RATIO CALCULATION PER CN, FOLLOWED BY ASSIGNMENT TO CPF REPORTS
         Decimal HIV_Total = 0;
         Decimal TB_Total = 0;
         Decimal Funding_Total;
         Decimal FundingRatio;
         
         Decimal AY1H = 0;
         Decimal AY2H = 0;
         Decimal AY3H = 0;
         Decimal AY4H = 0;
         Decimal Y1H = 0;
         Decimal Y2H = 0;
         Decimal Y3H = 0;
         Decimal Y4H = 0;
         Decimal AY1T = 0;
         Decimal AY2T = 0;
         Decimal AY3T = 0;
         Decimal AY4T = 0;
         Decimal Y1T = 0;
         Decimal Y2T = 0;
         Decimal Y3T = 0;
         Decimal Y4T = 0;

         for(AggregateResult objAgg : lstBudgetHIV) {
           if(objAgg.get('CN') == objCN.Id) {
            AY1H = (Decimal)objAgg.get('AY1');
             if(AY1H == null) AY1H = 0;
            AY2H = (Decimal)objAgg.get('AY2');
             if(AY2H == null) AY2H = 0;
            AY3H = (Decimal)objAgg.get('AY3');
             if(AY3H == null) AY3H = 0;
            AY4H = (Decimal)objAgg.get('AY4');
             if(AY4H == null) AY4H = 0;
            Y1H = (Decimal)objAgg.get('Y1');
             if(Y1H == null) Y1H = 0;
            Y2H = (Decimal)objAgg.get('Y2');
             if(Y2H == null) Y2H = 0;
            Y3H = (Decimal)objAgg.get('Y3');
             if(Y3H == null) Y3H = 0;
            Y4H = (Decimal)objAgg.get('Y4');
             if(Y4H == null) Y4H = 0;
           HIV_Total = AY1H + AY2H + AY3H + AY4H + Y1H + Y2H + Y3H + Y4H;
          }
         }
         
         for(AggregateResult objAgg : lstBudgetTB) {
           if(objAgg.get('CN') == objCN.Id) {
            AY1T = (Decimal)objAgg.get('AY1');
             if(AY1T == null) AY1T = 0;
            AY2T = (Decimal)objAgg.get('AY2');
             if(AY2T == null) AY2T = 0;
            AY3T = (Decimal)objAgg.get('AY3');
             if(AY3T == null) AY3T = 0;
            AY4T = (Decimal)objAgg.get('AY4');
             if(AY4T == null) AY4T = 0;
            Y1T = (Decimal)objAgg.get('Y1');
             if(Y1T == null) Y1T = 0;
            Y2T = (Decimal)objAgg.get('Y2');
             if(Y2T == null) Y2T = 0;
            Y3T = (Decimal)objAgg.get('Y3');
             if(Y3T == null) Y3T = 0;
            Y4T = (Decimal)objAgg.get('Y4');
             if(Y4T == null) Y4T = 0;
           TB_Total = AY1T + AY2T + AY3T + AY4T + Y1T + Y2T + Y3T + Y4T;
          }
         }
        
        //FundingRatio is the proportion of HIV/TB spending that goes to HIV. 1-FundingRatio is therefore the proportion that goes to TB.
        Funding_Total = HIV_Total + TB_Total;
        if(Funding_Total != 0) FundingRatio = HIV_Total / Funding_Total;   
         System.Debug('%%% HIV_Total = ' + HIV_Total + ', TB_Total = ' + TB_Total + ', Funding_Total = ' + Funding_Total + ', FundingRatio = ' + FundingRatio);

          
       //Now, looking at the CPF Reports 
       for(CPF_Report__c cpf : objCN.CPF_Reports__r) {
       
        //Clear all the values first
        cpf.Indicative_Y1__c = 0;
        cpf.Indicative_Y2__c = 0;
        cpf.Indicative_Y3__c = 0;
        cpf.Indicative_Y4__c  = 0;
        cpf.Above_Indicative_Y1__c  = 0;
        cpf.Above_Indicative_Y2__c = 0;
        cpf.Above_Indicative_Y3__c = 0;
        cpf.Above_Indicative_Y4__c = 0;
        
        Decimal AY1=0;
        Decimal AY2=0;
        Decimal AY3=0;
        Decimal AY4=0;
        Decimal Y1=0;
        Decimal Y2=0;
        Decimal Y3=0;
        Decimal Y4=0;

        if(cpf.Component__c == 'HIV/AIDS'){
        
            AY1=AY1H;
            AY2=AY2H;
            AY3=AY3H;
            AY4=AY4H;
            Y1=Y1H;
            Y2=Y2H;
            Y3=Y3H;
            Y4=Y4H;
            
            //Since this is an HIV CN, do not adjust FundingRatio
            
        }else if(cpf.Component__c == 'Tuberculosis'){
            
            AY1=AY1T;
            AY2=AY2T;
            AY3=AY3T;
            AY4=AY4T;
            Y1=Y1T;
            Y2=Y2T;
            Y3=Y3T;
            Y4=Y4T;

            //Since this is a TB CN, we will invert FundingRatio for the later cross-cutting calculations:
            if(FundingRatio != null) FundingRatio = 1-FundingRatio;
        }
        
        if(FYRatio != null){
            if(blnCPFAligned){    
                cpf.Above_Indicative_Y1__c = AY1 * FYRatio;
                cpf.Above_Indicative_Y2__c = AY2 * FYRatio + AY1 *(1-FYRatio);
                cpf.Above_Indicative_Y3__c = AY3 * FYRatio + AY2 *(1-FYRatio);
                cpf.Above_Indicative_Y4__c = AY4 * FYRatio + AY3 *(1-FYRatio);
                
                cpf.Indicative_Y1__c = Y1 * FYRatio;
                cpf.Indicative_Y2__c = Y2 * FYRatio + Y1 *(1-FYRatio);
                cpf.Indicative_Y3__c = Y3 * FYRatio + Y2 *(1-FYRatio);
                cpf.Indicative_Y4__c = Y4 * FYRatio + Y3 *(1-FYRatio);
    
             }else {
                cpf.Above_Indicative_Y1__c = 0;
                cpf.Above_Indicative_Y2__c = AY1 * FYRatio;
                cpf.Above_Indicative_Y3__c = AY2 * FYRatio + AY1 *(1-FYRatio);
                cpf.Above_Indicative_Y4__c = AY3 * FYRatio + AY2 *(1-FYRatio);
                
                cpf.Indicative_Y1__c = 0;
                cpf.Indicative_Y2__c = Y1 * FYRatio;
                cpf.Indicative_Y3__c = Y2 * FYRatio + Y1 *(1-FYRatio);
                cpf.Indicative_Y4__c = Y3 * FYRatio + Y2 *(1-FYRatio);
             }

            if(cpf.Indicative_Y1__c == null) cpf.Indicative_Y1__c = 0;
            if(cpf.Indicative_Y2__c == null) cpf.Indicative_Y2__c = 0;
            if(cpf.Indicative_Y3__c == null) cpf.Indicative_Y3__c = 0;
            if(cpf.Indicative_Y4__c == null) cpf.Indicative_Y4__c  = 0;
            if(cpf.Above_Indicative_Y1__c == null) cpf.Above_Indicative_Y1__c  = 0;
            if(cpf.Above_Indicative_Y2__c  == null) cpf.Above_Indicative_Y2__c = 0;
            if(cpf.Above_Indicative_Y3__c == null) cpf.Above_Indicative_Y3__c = 0;
            if(cpf.Above_Indicative_Y4__c  == null) cpf.Above_Indicative_Y4__c = 0;
        
        }

        for(AggregateResult objAgg : lstBudgetC) {
            if(objAgg.get('CN') == objCN.Id) {
                 if(FYRatio != null && FundingRatio != null){
                    Decimal AY1C = (Decimal)objAgg.get('AY1');
                     if(AY1C == null) AY1C = 0;
                    Decimal AY2C = (Decimal)objAgg.get('AY2');
                     if(AY2C == null) AY2C = 0;
                    Decimal AY3C = (Decimal)objAgg.get('AY3');
                     if(AY3C == null) AY3C = 0;
                    Decimal AY4C = (Decimal)objAgg.get('AY4');
                     if(AY4C == null) AY4C = 0;
                    Decimal Y1C = (Decimal)objAgg.get('Y1');
                     if(Y1C == null) Y1C = 0;
                    Decimal Y2C = (Decimal)objAgg.get('Y2');
                     if(Y2C == null) Y2C = 0;
                    Decimal Y3C = (Decimal)objAgg.get('Y3');
                     if(Y3C == null) Y3C = 0;
                    Decimal Y4C = (Decimal)objAgg.get('Y4');
                     if(Y4C == null) Y4C = 0;
                        
                     if(blnCPFAligned){                   
                        cpf.Above_Indicative_Y1__c += (AY1C * FYRatio) * (FundingRatio);
                        cpf.Above_Indicative_Y2__c += (AY2C * FYRatio + AY1C *(1-FYRatio))* (FundingRatio);
                        cpf.Above_Indicative_Y3__c += (AY3C * FYRatio + AY2C *(1-FYRatio))* (FundingRatio);
                        cpf.Above_Indicative_Y4__c += (AY4C * FYRatio + AY3C *(1-FYRatio))* (FundingRatio);
                        
                        cpf.Indicative_Y1__c += (Y1C * FYRatio) * (FundingRatio);
                        cpf.Indicative_Y2__c += (Y2C * FYRatio + Y1C *(1-FYRatio))* (FundingRatio);
                        cpf.Indicative_Y3__c += (Y3C * FYRatio + Y2C *(1-FYRatio))* (FundingRatio);
                        cpf.Indicative_Y4__c += (Y4C * FYRatio + Y3C *(1-FYRatio))* (FundingRatio);
                        
                      }else{
                        cpf.Above_Indicative_Y2__c += (AY1C * FYRatio) * (FundingRatio);
                        cpf.Above_Indicative_Y3__c += (AY2C * FYRatio + AY1C *(1-FYRatio))* (FundingRatio);
                        cpf.Above_Indicative_Y4__c += (AY3C * FYRatio + AY2C *(1-FYRatio))* (FundingRatio);
                         
                        cpf.Indicative_Y2__c += (Y1C * FYRatio) * (FundingRatio);
                        cpf.Indicative_Y3__c += (Y2C * FYRatio + Y1C *(1-FYRatio))* (FundingRatio);
                        cpf.Indicative_Y4__c += (Y3C * FYRatio + Y2C *(1-FYRatio))* (FundingRatio);
                      }
                    }  
                    break;
                }
            } //end of loop through C aggregateResult
        
        //update cpf;
        lstCPFtoUpdate.add(cpf); 
      }

    } 
    
  }
  update lstCPFtoUpdate;
  update lstConceptNotes;
    
 }
 
 //string[] regions = salesRegions.Sales_Regions__c.split(';',0);
   Public static String getComponent(List<String> lstComp){
       Set<String> setComp = new Set<String>();
       if(!lstComp.isEmpty()){
       for(String s : lstComp){
           setComp.add(s); }
        }   
       String strComponent;
       if(setComp.contains('HIV/AIDS') && !setComp.contains('Tuberculosis')){
           strComponent = 'H'; }
       else if(!setComp.contains('HIV/AIDS') && setComp.contains('Tuberculosis')){
           strComponent = 'T'; }
       else{
           strComponent = 'C'; }
       /*if(setComp.contains('HIV/AIDS') && setComp.contains('Tuberculosis')){
           strComponent = 'C'; } -- Changed by MM 26/5/2014 to fix potential issue with modules not being included if they didn't meet any of these criteria  */
       
       return strComponent;
   }
   
   Public static Integer getFY(Date disbDate, Integer FYstartMonth) {
      if(disbDate.month() >= FYstartMonth && FYStartMonth != 1){
          return disbDate.year()+1; 
      } else{
          return disbDate.year(); 
      }          
   }

}