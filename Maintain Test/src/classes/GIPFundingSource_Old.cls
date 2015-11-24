Public Class GIPFundingSource_Old{
    Public static void CreateGIPFundingSourceRecords(Set<Id> setCountryId,String ConceptNoteId,Set<Id> setCPFReportId){
        if(setCountryId.size() > 0){
            Integer intYear;
            Integer lastTwoYears = system.today().year() - 2; 
            Set<Id> setIPIds = new Set<id>();
            String strCurrency;
            List<Concept_Note__c> lstConceptNote = [Select Start_Date__c,CurrencyIsoCode From Concept_Note__c 
                                                    Where Id =: ConceptNoteId];
            System.debug('lastTwoYears = '+lastTwoYears);
            System.debug('setCountryId = '+setCountryId);
            List<Disbursement__c> lstDisbursement = [Select Implementation_Period__c 
                                                    From Disbursement__c
                                                    
                                                    Where CALENDAR_YEAR(Disbursement_Date__c) <=: system.today().year() 
                                                    AND CALENDAR_YEAR(Disbursement_Date__c) >=: lastTwoYears 
                                                    AND (Amount_Disbursed_USD__c > 0 OR Amount_Disbursed_EUR__c > 0)
                                                    AND Implementation_Period__r.Principal_Recipient__r.Country__c IN : setCountryId
                                                    ];
            
            if(lstDisbursement.size() > 0){
                setIPIds.add(lstDisbursement[0].Implementation_Period__c);
            }
            if(lstConceptNote.size() > 0){
                if(lstConceptNote[0].Start_Date__c != null){
                    intYear = lstConceptNote[0].Start_Date__c.year();
                    strCurrency = lstConceptNote[0].CurrencyIsoCode; 
                }
            }
            
            
            List<AggregateResult> lstDisbursementToCalculate = [Select Sum(Amount_Disbursed_EUR__c) AmountEUR,
                                                    Sum(Amount_Disbursed_USD__c) AmountUSD,Disbursement_Date__c Ddate
                                                    From Disbursement__c 
                                                    where Implementation_Period__c IN : setIPIds 
                                                    Group By Disbursement_Date__c];
                   
            String strCPFReportId;                                        
            if(setCPFReportId.size() > 0){
                for(Id strId : setCPFReportId){
                    strCPFReportId = strId;
                }
            }
             
            Id RecordTypeD = [Select Id From RecordType Where sobjectType = 'Funding_Source__c' And RecordType.Developername = 'D'].Id;
            Funding_Source__c objFS = new Funding_Source__c(CPF_Report__c = strCPFReportId,RecordTypeID = RecordTypeD);
            if(lstDisbursementToCalculate.size() > 0){
                for(AggregateResult objAgg : lstDisbursementToCalculate){
                    if(objAgg.get('Ddate') != null && intYear != null){
                        if(Date.valueof(objAgg.get('Ddate')).year() == (intYear - 2)){
                            if(strCurrency == 'EUR') objFS.year_2__c = (Decimal)objAgg.get('AmountEUR');
                            else objFS.year_2__c = (Decimal)objAgg.get('AmountUSD');
                        }else if(Date.valueof(objAgg.get('Ddate')).year() == (intYear - 1)){
                            if(strCurrency == 'EUR') objFS.year_1__c = (Decimal)objAgg.get('AmountEUR');
                            else  objFS.year_1__c = (Decimal)objAgg.get('AmountUSD');
                        }else if(Date.valueof(objAgg.get('Ddate')).year() == (intYear)){
                            if(strCurrency == 'EUR') objFS.year_2__c = (Decimal)objAgg.get('AmountEUR');
                            else objFS.year_2__c = (Decimal)objAgg.get('AmountUSD');
                        }else if(Date.valueof(objAgg.get('Ddate')).year() == (intYear + 1)){
                            if(strCurrency == 'EUR') objFS.year_plus_1__c = (Decimal)objAgg.get('AmountEUR');
                            else objFS.year_plus_1__c = (Decimal)objAgg.get('AmountUSD');
                        }else if(Date.valueof(objAgg.get('Ddate')).year() == (intYear + 2)){
                            if(strCurrency == 'EUR') objFS.year_plus_2__c = (Decimal)objAgg.get('AmountEUR');
                            else objFS.year_plus_2__c = (Decimal)objAgg.get('AmountUSD');
                        }else if(Date.valueof(objAgg.get('Ddate')).year() == (intYear + 3)){
                            if(strCurrency == 'EUR') objFS.year_plus_3__c = (Decimal)objAgg.get('AmountEUR');
                            else objFS.year_plus_3__c = (Decimal)objAgg.get('AmountUSD');
                        }
                    }
                }
                insert objFS;
            }
            
        }
    }
}