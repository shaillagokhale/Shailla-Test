Public Class GIPFundingSourceOld3{
    Public static void CreateGIPFundingSourceRecords(Set<Id> setCountryId,String ConceptNoteId,Set<Id> setCPFReportId){
        
        Map<String,Integer> MapDisplayMonth = new Map<String,Integer>();
        Map<Id, Funding_Source__c> mapGrantFundingSource = new Map<Id, Funding_Source__c>();
        Map<Id, List<Disbursement__c>> mapGrantDisbursement = new Map<Id, List<Disbursement__c>>();
        List<Country__c> lstCountry = new List<Country__c>();
        List<Grant__c> lstQueryGrants = new List<Grant__c>();
        List<Grant> lstGrants = new List<Grant>();
        List<Disbursement__c> lstDisbursementsAll = new List<Disbursement__c>();
        List<Concept_Note__c> lstConceptNote = new List<Concept_Note__c>();
        List<Grant_Intervention__c> lstGrantInterventionAggregate = new List<Grant_Intervention__c>();
        Set<Id> setGIPIds = new Set<Id>();
        
        Date today = System.today();
        
        String strCurrency;
        String strComponent;
        String FYstartMonth;
        String FYendMonth;
        Date currentFYStartDate;
        Date currentFYEndDate;
        Decimal FYratio;
        Date rangeStartDate;
        Date rangeEndDate;
        Integer CNYear;                 
        
        //Adding map values for creating CN Year and range dates   
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
        
        //Variable E for Current Year calculation (A,B,C,D are per Grant and are in the wrapper class)
        Decimal varE; //Months between today and current period end date
            
        if(setCountryId.size() > 0){
            lstCountry = [Select Fiscal_Cycle_Start_Month__c, Fiscal_Cycle_End_Month__c from Country__c where Id in: setCountryId];
            lstConceptNote = [Select Start_Date__c, Actual_Submission_Date__c, Target_Submission_Date__c, CurrencyIsoCode, Component__c From Concept_Note__c Where Id =: ConceptNoteId];
            
            //Setting values from Concept Note                                        
            if(lstConceptNote.size() > 0){
                if(lstConceptNote[0].Start_Date__c != null){
                    if(lstConceptNote[0].Actual_Submission_Date__c != null){
                        CNYear = getFY(lstConceptNote[0].Actual_Submission_Date__c, MapDisplayMonth.get(FYstartMonth)); 
                    }else if(lstConceptNote[0].Target_Submission_Date__c != null){  
                        CNYear = getFY(lstConceptNote[0].Target_Submission_Date__c, MapDisplayMonth.get(FYstartMonth)); 
                    }else if(lstConceptNote[0].Start_Date__c!= null){                                            
                        CNYear = getFY(lstConceptNote[0].Start_Date__c, MapDisplayMonth.get(FYstartMonth)); }
                    
                    strCurrency = lstConceptNote[0].CurrencyIsoCode; 
                    strComponent = lstConceptNote[0].Component__c;
                  }            
               }
            
            //Setting CPF Report ID
            String strCPFReportId;                                        
            if(setCPFReportId.size() > 0){
                for(Id strId : setCPFReportId){
                    strCPFReportId = strId;
                }            
             }
             
            //Querying for RecordTypeId of D Funding Source
            Id RecordTypeD = [Select Id From RecordType Where sobjectType = 'Funding_Source__c' And RecordType.Developername = 'D'].Id;
            
            
            if(lstCountry.size() > 0 && CNYear != null){
                //Setting the dates of the CN start fiscal year and the total range
                FYstartMonth = lstCountry[0].Fiscal_Cycle_Start_Month__c;
                FYendMonth = lstCountry[0].Fiscal_Cycle_End_Month__c;
              if(FYstartMonth != null && FYendMonth != null){
                
                if(FYStartMonth == 'January'){
                    currentFYStartDate = Date.newInstance(CNYear, MapDisplayMonth.get(FYstartMonth), 1);
                    rangeStartDate = Date.newInstance(CNYear-2, MapDisplayMonth.get(FYstartMonth), 1);               
                }else {                
                    currentFYStartDate = Date.newInstance(CNYear-1, MapDisplayMonth.get(FYstartMonth), 1);                  
                    rangeStartDate = Date.newInstance(CNYear-3, MapDisplayMonth.get(FYstartMonth), 1); }                                
                
                currentFYEndDate = Date.newInstance(CNYear, MapDisplayMonth.get(FYendMonth), date.daysInMonth(today.year(), MapDisplayMonth.get(FYendMonth))); 
                rangeEndDate = Date.newInstance(CNYear+3, MapDisplayMonth.get(FYendMonth), date.daysInMonth(today.year(), MapDisplayMonth.get(FYendMonth)));
                FYratio = (Decimal.valueOf(MapDisplayMonth.get(FYendMonth)) / 12);
                 System.Debug('$$$ ' + currentFYEndDate);
                 System.debug('%%% FYRatio: ' + FYRatio);
                
                //Setting VARIABLE E, the one universal (non-Grant-specific) variable
                varE = (today.daysBetween(currentFYEndDate)/30.436875).setScale(0,System.roundingMode.HALF_UP);
                if(varE < 0) { varE = 0; }
                 
                //Querying grants - these will be added to a wrapper class, but additionally this source list will
                //be referenced later when querying Disbursements and Grant Interventions.        
                if(strComponent == 'HIV/TB'){
                    lstQueryGrants = [Select Id, Name, 
                                        (Select Id, Signed_Amount_EUR__c, Signed_Amount_USD__c, Amount_Remaining__c, 
                                         Start_Date__c, End_Date__c, Grant__c, Grant__r.Name
                                            FROM Implementation_Periods__r 
                                            WHERE 
                                            Start_Date__c <= :rangeEndDate 
                                            AND End_Date__c >= :rangeStartDate
                                            AND End_Date__c != null
                                            ORDER BY End_Date__c DESC) 
                                    
                                       FROM Grant__c   
                                       WHERE Country__c IN : setCountryId
                                       AND (Disease_Component__c = 'HIV/AIDS'
                                       OR Disease_Component__c = 'Tuberculosis'
                                       OR Disease_Component__c = 'HIV/TB')];   
                  } else {
                      lstQueryGrants = [Select Id, Name, 
                                        (Select Id, Signed_Amount_EUR__c, Signed_Amount_USD__c, Amount_Remaining__c, 
                                         Start_Date__c, End_Date__c, Grant__c, Grant__r.Name
                                            FROM Implementation_Periods__r 
                                            WHERE 
                                            Start_Date__c <= :rangeEndDate 
                                            AND End_Date__c >= :rangeStartDate
                                            AND End_Date__c != null
                                            ORDER BY End_Date__c DESC) 
                                    
                                       FROM Grant__c   
                                       WHERE Country__c IN : setCountryId
                                       AND Disease_Component__c = : strComponent];  
                          }                    
                
                  //Adding new Funding Sources in a map, retrievable by Grant ID 
                  for(Grant__c grant: lstQueryGrants){  
                    for(Implementation_Period__c GIP : grant.Implementation_Periods__r){
                      setGIPIds.add(GIP.Id); }               
                    Funding_Source__c objFS = new Funding_Source__c(CPF_Report__c = strCPFReportId,RecordTypeID = RecordTypeD,
                                                            Year_2__c = 0, Year_1__c = 0, Current_year__c = 0,
                                                            Year_plus_1__c = 0, Year_plus_2__c = 0, Year_plus_3__c = 0,
                                                            Grant_Number__c = grant.Name);
                                                            
                    mapGrantFundingSource.put(grant.Id, objFS);
                    
                    //Adding the wrapper objects
                    Grant newGrant = new Grant(grant);
                    mapGrantDisbursement.put(grant.Id, newGrant.lstDisbursements);
                    lstGrants.add(newGrant);                
                  }
   
                  /****************************************************************************/
                  /*                            P A S T   Y E A R S                           */
                  /****************************************************************************/
                  
                  //Splitting out past year disbursements according to FY
                  lstDisbursementsAll = [Select Amount_Disbursed_EUR__c, Amount_Disbursed_USD__c, Disbursement_Date__c,
                                            Implementation_Period__c, Implementation_Period__r.Grant__c
                                            from Disbursement__c where Implementation_Period__c in : setGIPIds
                                            AND Disbursement_Date__c >= :rangeStartDate
                                            AND Disbursement_Date__c != null];
                        
                  
                  for(Disbursement__c disbursementPast : lstDisbursementsAll){
                    Integer FY = getFY(disbursementPast.Disbursement_Date__c, MapDisplayMonth.get(FYstartMonth));                 
                      if(strCurrency == 'EUR' && disbursementPast.Amount_Disbursed_EUR__c != null){
                          if(FY == CNYear-2){
                            mapGrantFundingSource.get(disbursementPast.Implementation_Period__r.Grant__c).Year_2__c += disbursementPast.Amount_Disbursed_EUR__c;  }
                          if(FY == CNYear-1){
                            mapGrantFundingSource.get(disbursementPast.Implementation_Period__r.Grant__c).Year_1__c += disbursementPast.Amount_Disbursed_EUR__c;  }                              
                      }
                      if(strCurrency == 'USD' && disbursementPast.Amount_Disbursed_USD__c != null){
                          if(FY == CNYear-2){
                            mapGrantFundingSource.get(disbursementPast.Implementation_Period__r.Grant__c).Year_2__c += disbursementPast.Amount_Disbursed_USD__c;  }
                          if(FY == CNYear-1){
                            mapGrantFundingSource.get(disbursementPast.Implementation_Period__r.Grant__c).Year_1__c += disbursementPast.Amount_Disbursed_USD__c;  }             
                      }
                   }
                  
                 /****************************************************************************/
                 /*                         C N   S T A R T   Y E A R                        */
                 /****************************************************************************/                         
                 
                 for(Disbursement__c objDisb: lstDisbursementsAll){
                     if(mapGrantDisbursement.get(objDisb.Implementation_Period__r.Grant__c) != null){
                         mapGrantDisbursement.get(objDisb.Implementation_Period__r.Grant__c).add(objDisb);
                     }
                  }
                  
                 for(Grant gr : lstGrants){
                     gr.varA = 0; //Amount Signed for the GIP covering this period with latest end date
                     gr.varB = 0; //Total disbursed all time under this GIP
                     gr.varC = 0; //Total disbursed in current period under all GIPs
                     gr.varD = 0; //Months between today and GIP End Date
   
                     
                     if(gr.objGrant.Implementation_Periods__r.size() > 0){
                         //Setting VARIABLE A
                         if(gr.objGrant.Implementation_Periods__r[0].End_Date__c >= currentFYStartDate){
                             if(strCurrency == 'USD'){
                               gr.varA = gr.objGrant.Implementation_Periods__r[0].Signed_Amount_USD__c; }
                             else if(strCurrency == 'EUR'){
                               gr.varA = gr.objGrant.Implementation_Periods__r[0].Signed_Amount_EUR__c; }
                         
                         //Setting VARIABLE D
                         gr.varD = (today.daysBetween(gr.objGrant.Implementation_Periods__r[0].End_Date__c)/30.436875).setScale(0,System.roundingMode.HALF_UP); 
                       }    
                     }
     
                     for(Disbursement__c grDisb : gr.lstDisbursements){
                         //Setting VARIABLE B
                         if(grDisb.Implementation_Period__c == gr.objGrant.Implementation_Periods__r[0].Id){
                             if(strCurrency == 'USD' && grDisb.Amount_Disbursed_USD__c != null){
                                 gr.varB += grDisb.Amount_Disbursed_USD__c; }
                             else if(strCurrency == 'EUR' && grDisb.Amount_Disbursed_EUR__c != null){
                                 gr.varB += grDisb.Amount_Disbursed_EUR__c; }
                          }
                         //Setting VARIABLE C
                         if(getFY(grDisb.Disbursement_Date__c, MapDisplayMonth.get(FYstartMonth)) == CNYear){
                             if(strCurrency == 'USD' && grDisb.Amount_Disbursed_USD__c != null){
                                 gr.varC += grDisb.Amount_Disbursed_USD__c; }
                             else if(strCurrency == 'EUR' && grDisb.Amount_Disbursed_EUR__c != null){
                                 gr.varC += grDisb.Amount_Disbursed_EUR__c; }
                          }
                      }
                     
                     //Checking to see if variables are null, or if D = 0 
                     if(gr.VarA == null){ 
                       gr.varA = 0; }
                     if(gr.VarB == null){ 
                       gr.varB = 0; }
                     if(gr.VarC == null){ 
                       gr.varC = 0; }
                     if(gr.VarD == null){ 
                       gr.varD = 1; }
                     if(gr.varD <= 0){
                       gr.varD = 1; }
                       
                     Decimal varEtemp;
                     if(gr.objGrant.Implementation_Periods__r.size() > 0){
                       if(currentFYEndDate > gr.objGrant.Implementation_Periods__r[0].End_Date__c){
                         varEtemp = (today.daysBetween(gr.objGrant.Implementation_Periods__r[0].End_Date__c)/30.436875).setScale(0,System.roundingMode.HALF_UP);
                       } else {
                         varEtemp = varE;
                       }
                     }else {
                         varEtemp = varE;
                     }
                     
                     if(varEtemp < 0 || varEtemp == null) { varEtemp = 0; }
                     
                    
                       
                     mapGrantFundingSource.get(gr.objGrant.Id).Current_Year__c = gr.varC + (gr.varA - gr.varB) * (varE / gr.varD);
                     //System.debug('%%%' + gr.objGrant.Name + ': ' + gr.varC + '+ (' + gr.varA + ' - ' + gr.varB + ') * (' + varE + ' / ' + gr.varD + ')' );               
                     
                     if(mapGrantFundingSource.get(gr.objGrant.Id).Current_Year__c == null){
                       mapGrantFundingSource.get(gr.objGrant.Id).Current_Year__c = 0;
                     }
                    
                }
                  
                      
                                                       
             /****************************************************************************/
             /*                         F U T U R E   Y E A R S                          */
             /****************************************************************************/
             
             /*       
             lstGrantInterventionAggregate = [Select 
                                Above_Indicative_Y1__c, Above_Indicative_Y2__c,
                                Above_Indicative_Y3__c, Above_Indicative_Y4__c,                                
                                Indicative_Y1__c, Indicative_Y2__c,
                                Indicative_Y3__c, Indicative_Y4__c,
                                Implementation_Period__r.Grant__c
                                    From Grant_Intervention__c 
                                    Where Implementation_Period__c in :setGIPIds];
              
             if(lstGrantInterventionAggregate.size() > 0){
                 for(Grant_Intervention__c objGI : lstGrantInterventionAggregate){
                     if(objGI.Indicative_Y1__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Current_Year__c += (objGI.Indicative_Y1__c * FYratio);
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_1__c += (objGI.Indicative_Y1__c * (1-FYratio));
                     }
                     if(objGI.Indicative_Y2__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_1__c += (objGI.Indicative_Y2__c * FYratio);
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_2__c += (objGI.Indicative_Y2__c * (1-FYratio));
                     }
                     if(objGI.Indicative_Y3__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_2__c += (objGI.Indicative_Y3__c * FYratio);
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_3__c += (objGI.Indicative_Y3__c * (1-FYratio));
                     }
                     if(objGI.Indicative_Y4__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_3__c += objGI.Indicative_Y4__c;
                     }
                     if(objGI.Above_Indicative_Y1__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Current_Year__c += (objGI.Above_Indicative_Y1__c * FYratio);
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_1__c += (objGI.Above_Indicative_Y1__c * (1-FYratio));
                     }
                     if(objGI.Above_Indicative_Y2__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_1__c += (objGI.Above_Indicative_Y2__c * FYratio);
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_2__c += (objGI.Above_Indicative_Y2__c * (1-FYratio));
                     }
                     if(objGI.Above_Indicative_Y3__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_2__c += (objGI.Above_Indicative_Y3__c * FYratio);
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_3__c += (objGI.Above_Indicative_Y3__c * (1-FYratio));
                     }
                     if(objGI.Above_Indicative_Y4__c != null){
                         mapGrantFundingSource.get(objGI.Implementation_Period__r.Grant__c).Year_plus_3__c += objGI.Above_Indicative_Y4__c;
                     }
                  } 
               }
               */
               
            /****************************************************************************/
            /*               I N S E R T I N G   N E W   R E C O R D S                  */
            /****************************************************************************/   
              
            //Delete existing before inserting
            if(RecordTypeD != null && strCPFReportId != null) {            
                List<Funding_Source__c> lstExistingFundingSources = 
                [Select Id from Funding_Source__c WHERE CPF_Report__c = : strCPFReportId
                                                  AND RecordTypeId = : RecordTypeD ];
                if(!lstExistingFundingSources.isEmpty()) {
                    delete lstExistingFundingSources; }

                }
              
              //Inserting Funding Source records only if at least one field value is not equal to zero 
              for(Grant grFinal : lstGrants){
                  if(mapGrantFundingSource.get(grFinal.objGrant.Id) != null){
                      if(mapGrantFundingSource.get(grFinal.objGrant.Id).Year_2__c != 0 ||
                         mapGrantFundingSource.get(grFinal.objGrant.Id).Year_1__c != 0 ||
                         mapGrantFundingSource.get(grFinal.objGrant.Id).Current_Year__c != 0 ||
                         mapGrantFundingSource.get(grFinal.objGrant.Id).Year_plus_1__c != 0 ||
                         mapGrantFundingSource.get(grFinal.objGrant.Id).Year_plus_2__c != 0 ||
                         mapGrantFundingSource.get(grFinal.objGrant.Id).Year_plus_3__c != 0 ) { 
                          insert mapGrantFundingSource.get(grFinal.objGrant.Id);
                       }
                  }
                }               
             }
           }   
        }        
     }
     
     Public static Integer getFY(Date disbDate, Integer FYstartMonth) {
          if(disbDate.month() >= FYstartMonth && FYStartMonth != 1){
              return disbDate.year()+1; 
          } else{
              return disbDate.year(); 
          }          
     }
     
     public Class Grant {
            Public Grant__c objGrant;
            Public List<Disbursement__c> lstDisbursements;
            
            //Variables for Current Year calculation
            Decimal varA; //Amount Signed for the GIP covering this period with latest end date
            Decimal varB; //Total disbursed in current period under this GIP
            Decimal varC; //Total disrbursed in current period under all GIPs
            Decimal varD; //Months between today and GIP End Date
    
          public Grant(Grant__c grant) {
            objGrant = grant;
            lstDisbursements = new List<Disbursement__c>();               
           }
      } 
  }