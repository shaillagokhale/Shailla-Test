Public Class GIPFundingSource_Old2{
    Public static void CreateGIPFundingSourceRecords(Set<Id> setCountryId,String ConceptNoteId,Set<Id> setCPFReportId){
        if(setCountryId.size() > 0){
            Integer intYear;
            Integer lastTwoYears = system.today().year() - 2;
            Integer thisYear = system.today().year(); 
            System.debug('lastTwoYears = '+lastTwoYears);
            System.debug('setCountryId = '+setCountryId);
            Set<Id> setIPIds = new Set<id>();
            String strCurrency;
            String strComponent;
            List<Concept_Note__c> lstConceptNote = [Select Start_Date__c,CurrencyIsoCode, Component__c From Concept_Note__c 
                                                    Where Id =: ConceptNoteId];
            if(lstConceptNote.size() > 0){
                if(lstConceptNote[0].Start_Date__c != null){
                    intYear = lstConceptNote[0].Start_Date__c.year();
                    strCurrency = lstConceptNote[0].CurrencyIsoCode; 
                    strComponent = lstConceptNote[0].Component__c;
                }
            }
            
            
            List<Disbursement__c> lstDisbursement = [Select Implementation_Period__c, Implementation_Period__r.Grant__r.Name
                                                    From Disbursement__c
                                                    
                                                    Where CALENDAR_YEAR(Disbursement_Date__c) <=: system.today().year() 
                                                    AND CALENDAR_YEAR(Disbursement_Date__c) >=: lastTwoYears 
                                                    AND (Amount_Disbursed_USD__c > 0 OR Amount_Disbursed_EUR__c > 0)
                                                    AND Implementation_Period__r.Principal_Recipient__r.Country__c IN : setCountryId
                                                    AND Implementation_Period__r.Grant__r.Disease_Component__c = : strComponent
                                                    ];
            
            /*if(lstDisbursement.size() > 0){
                setIPIds.add(lstDisbursement[0].Implementation_Period__c);
            }*/
            
            for(Disbursement__c disb: lstDisbursement){
                setIPIds.add(disb.Implementation_Period__c);
            }
            system.debug('$$$$$$$$$$$'+setIPIds);
           
            
            
            List<AggregateResult> lstDisbursementToCalculate = [Select Sum(Amount_Disbursed_EUR__c) AmountEUR,
                                                    Sum(Amount_Disbursed_USD__c) AmountUSD, CALENDAR_YEAR(Disbursement_Date__c) Ddate,
                                                    Implementation_Period__c GIPId
                                                    From Disbursement__c 
                                                    where Implementation_Period__c IN : setIPIds 
                                                    Group By Implementation_Period__c, CALENDAR_YEAR(Disbursement_Date__c)];
                                                    
            List<Implementation_Period__c> lstGIPs = [Select Id, Grant__r.Name, End_Date__c, Amount_Remaining__c from Implementation_Period__c where Id in: setIPIds];  
                 
            String strCPFReportId;                                        
            if(setCPFReportId.size() > 0){
                for(Id strId : setCPFReportId){
                    strCPFReportId = strId;
                }            
            }
             
            Id RecordTypeD = [Select Id From RecordType Where sobjectType = 'Funding_Source__c' And RecordType.Developername = 'D'].Id;
            
            //Delete existing
            if(RecordTypeD != null && strCPFReportId != null) {            
                List<Funding_Source__c> lstExistingFundingSources = 
                [Select Id from Funding_Source__c WHERE CPF_Report__c = : strCPFReportId
                                                  AND RecordTypeId = : RecordTypeD ];
                if(!lstExistingFundingSources.isEmpty()) {
                    delete lstExistingFundingSources; }
             }
           
          for(Implementation_Period__c gip : lstGIPs) {
           
            Funding_Source__c objFS = new Funding_Source__c(CPF_Report__c = strCPFReportId,RecordTypeID = RecordTypeD,
                                                            Year_2__c = 0, Year_1__c = 0, Current_year__c = 0,
                                                            Year_plus_1__c = 0, Year_plus_2__c = 0, Year_plus_3__c = 0,
                                                            Grant_Number__c = gip.Grant__r.Name);                                                           
            
            if(lstDisbursementToCalculate.size() > 0){
                for(AggregateResult objAgg : lstDisbursementToCalculate){
                    if(objAgg.get('Ddate') != null && intYear != null && objAgg.get('GIPId') == gip.Id){
                    System.debug('%%% Ddate = ' + objAgg.get('Ddate'));
                        
                    if(objAgg.get('Ddate') == (intYear - 2)){
                        if(strCurrency == 'EUR') objFS.year_2__c = (Decimal)objAgg.get('AmountEUR');
                        else objFS.year_2__c = (Decimal)objAgg.get('AmountUSD');  }
                    
                    else if(objAgg.get('Ddate') == (intYear - 1)){
                        if(strCurrency == 'EUR') objFS.year_1__c = (Decimal)objAgg.get('AmountEUR');
                        else  objFS.year_1__c = (Decimal)objAgg.get('AmountUSD');  }
                    
                    else if(objAgg.get('Ddate') == (intYear)){
                        if(strCurrency == 'EUR') objFS.Current_Year__c = (Decimal)objAgg.get('AmountEUR');
                        else objFS.Current_Year__c = (Decimal)objAgg.get('AmountUSD');  }
                    
                    else if(objAgg.get('Ddate') == (intYear + 1)){
                        if(strCurrency == 'EUR') objFS.year_plus_1__c = (Decimal)objAgg.get('AmountEUR');
                        else objFS.year_plus_1__c = (Decimal)objAgg.get('AmountUSD');  }
                    
                    else if(objAgg.get('Ddate') == (intYear + 2)){
                        if(strCurrency == 'EUR') objFS.year_plus_2__c = (Decimal)objAgg.get('AmountEUR');
                        else objFS.year_plus_2__c = (Decimal)objAgg.get('AmountUSD');  }
                    
                    else if(objAgg.get('Ddate') == (intYear + 3)){
                        if(strCurrency == 'EUR') objFS.year_plus_3__c = (Decimal)objAgg.get('AmountEUR');
                        else objFS.year_plus_3__c = (Decimal)objAgg.get('AmountUSD');  }                   
                    }
                }
                
                //Adding the pro-rated amounts from the GIPs     
              if(gip.Amount_Remaining__c != null){                     
                Integer gipEndYear;
                if(objFS.Current_Year__c == null){ objFS.Current_Year__c = 0; }
                if(objFS.Year_plus_1__c == null){ objFS.Year_plus_1__c = 0; }
                if(objFS.Year_plus_2__c == null){ objFS.Year_plus_2__c = 0; }
                if(objFS.Year_plus_3__c == null){ objFS.Year_plus_3__c = 0; }
                

                    if(gip.End_Date__c != null) {
                        gipEndYear = gip.End_Date__c.year();  }
                        
                    if(gipEndYear == thisYear) {
                        objFS.Current_Year__c += gip.Amount_Remaining__c;
                        system.debug('$$$$'+objFS.Current_Year__c);
                      }
                    
                    if(gipEndYear == thisYear + 1) {
                        objFS.Current_Year__c += getRemainingCurrent(gip.End_Date__c, gip.Amount_Remaining__c);
                        objFS.Year_plus_1__c += getRemainingFinal(gip.End_Date__c, gip.Amount_Remaining__c, 1);
                      }
                    
                    if(gipEndYear == thisYear + 2) {
                        objFS.Current_Year__c += getRemainingCurrent(gip.End_Date__c, gip.Amount_Remaining__c);
                        objFS.Year_plus_1__c += getRemainingMid(gip.End_Date__c, gip.Amount_Remaining__c, 1);
                        objFS.Year_plus_2__c += getRemainingFinal(gip.End_Date__c, gip.Amount_Remaining__c, 2);
                      }
                    
                    if(gipEndYear == thisYear + 3) {
                        objFS.Current_Year__c += getRemainingCurrent(gip.End_Date__c, gip.Amount_Remaining__c);
                        objFS.Year_plus_1__c += getRemainingMid(gip.End_Date__c, gip.Amount_Remaining__c, 1);
                        objFS.Year_plus_2__c += getRemainingMid(gip.End_Date__c, gip.Amount_Remaining__c, 2);
                        objFS.Year_plus_3__c += getRemainingFinal(gip.End_Date__c, gip.Amount_Remaining__c, 3);
                      }
                  }

                insert objFS;
             }
          }        
       }      
    }
   
       Public static Decimal getRemainingCurrent(Date gipEndDate, Decimal amtRemaining) {
           Integer thisYear = system.today().year();
           return amtRemaining * (System.today().daysBetween(Date.newInstance(thisYear,12,31))+1) / (System.today().daysBetween(gipEndDate)+1);                 
       }
       
       Public static Decimal getRemainingMid(Date gipEndDate, Decimal amtRemaining, Integer increment) {
           Integer thisYear = system.today().year();
           return amtRemaining * (Date.newInstance(thisYear+increment,1,1).daysBetween(Date.newInstance(thisYear + increment,12,31))+1) / (System.today().daysBetween(gipEndDate)+1);
       }
    
       Public static Decimal getRemainingFinal(Date gipEndDate, Decimal amtRemaining, Integer increment) {
           Integer thisYear = system.today().year();
           return amtRemaining * (Date.newInstance(thisYear+increment,1,1).daysBetween(gipEndDate)+1) / (System.today().daysBetween(gipEndDate)+1);
       }
   

   
}