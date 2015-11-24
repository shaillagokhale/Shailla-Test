/*********************************************************************************
* Controller Class: RescalingFormula
* Created by Vera Solutions, DateCreated:  1/28/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Optimization formula to allocate TGF's Concept Note money for the next three years to each 
    eligible CN.
----------------------------------------------------------------------------------
* Unit Test: TestRescalingFormula
----------------------------------------------------------------------------------
* History:
* - VERSION     DATE            DETAIL FEATURES
    1.0         28 Jan 2014     INITIAL DEVELOPMENT   
*********************************************************************************/

global Class RescalingFormula_4feb{    
    private static Integer RDcount = 0;
    private static Integer RUcount = 0;
    public static Decimal intDiffDown = 0;
    public static Decimal intDiffUp = 0;
    
    /**********************************************************************************************
    Purpose: Execute formula that will allocate TGF's Concept Note money for the next three years to each 
             eligible Concept Note
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    WebService static String executeRescalingFormula(String strBandId) {
        try{
            if(String.isBlank(strBandId) == false){
                //Update all Concept Notes in the band, to make sure statuses are appropriately set
                List<Concept_Note__c> lstAllConceptNotes = [Select Id from Concept_Note__c where Band__c = :strBandId];
                update lstAllConceptNotes;
                
                rescalingformula_4feb.updateListCNineligible(strBandId);
                List<Band__c> lstBand = [Select Id, Insufficient_Funds__c from Band__c where Id =: strBandId Limit 1];
                List<Concept_Note__c> lstConceptNoteToUpdate = new List<Concept_Note__c>(); // List used to update CNs 
                List<Concept_Note__c> lstBelowMin = new List<Concept_Note__c>(); 
                List<AggregateResult> lstCNAggregateResult = [Select Sum(Minimum__c) TotalMin,Sum(NAA__c) TotalNAA From Concept_Note__c 
                                                    Where Band__c =: strBandId and Eligible_for_rescaling__c = 'Yes'];
                if(lstCNAggregateResult.size() > 0){
                    Boolean blnMinlessthanNAA = false;
                    Boolean blnMinGraterthanNAA = false;             
                    lstConceptNoteToUpdate = new List<Concept_Note__c>();
                    lstConceptNoteToUpdate = rescalingformula_4feb.updateListCN(strBandId);
                    if(lstConceptNoteToUpdate.size() > 0){
                        
                        //Step 1: Is sum(Min) > sum(NAA)?
                        if((Decimal)lstCNAggregateResult[0].get('TotalMin') > (Decimal)lstCNAggregateResult[0].get('TotalNAA')){
                            blnMinGraterthanNAA = true;
                            Integer count = 0;
                            for(Concept_Note__c objCN : lstConceptNoteToUpdate){
                                objCN.Minimum__c = objCN.Hard_Floor_Including_Risk__c;
                            }
                            update lstConceptNoteToUpdate;
                            lstCNAggregateResult = new List<AggregateResult>();
                            lstCNAggregateResult = [Select Sum(Hard_Floor_Including_Risk__c) TotalHF,Sum(NAA__c) TotalNAA From Concept_Note__c 
                                                    Where Band__c =: strBandId and Eligible_For_Rescaling__c = 'Yes'];
                            count++;
                            //Recheck if sum(hard floor) > sum(NAA). If so, tick insufficient funds.
                            if((decimal)lstCNAggregateResult[0].get('TotalHF') > (decimal)lstCNAggregateResult[0].get('TotalNAA')){
                                lstband[0].Insufficient_Funds__c = true;
                                update lstband;
                            //If sum(hard floor) = sum(NAA) set CFA to Min.
                            }else if((decimal)lstCNAggregateResult[0].get('TotalHF') == (decimal)lstCNAggregateResult[0].get('TotalNAA')){
                                for(Concept_Note__c objCN : lstConceptNoteToUpdate){                                    
                                    objCN.CFA__c = objCN.Minimum__c;                                
                                }
                                update lstConceptNoteToUpdate;
                                //Set final allocation
                                UpdateCFAeqFA(strBandId);
                            //Recheck if sum(hard floor) < sum(NAA). If so, set CFA to NAA.
                            }else if((decimal)lstCNAggregateResult[0].get('TotalHF') < (decimal)lstCNAggregateResult[0].get('TotalNAA')){
                                for(Concept_Note__c objCN : lstConceptNoteToUpdate){
                                    objCN.CFA__c = objCN.NAA__c;
                                }
                                Update lstConceptNoteToUpdate;
                                blnMinlessthanNAA = true;
                            }                                
                        //Is sum(Min) == sum(NAA)?
                        }else if(lstCNAggregateResult[0].get('TotalMin') == lstCNAggregateResult[0].get('TotalNAA')){
                            for(Concept_Note__c objCN : lstConceptNoteToUpdate){
                                objCN.CFA__c = objCN.Minimum__c;
                            }
                            update lstConceptNoteToUpdate;
                            system.debug('##### lstConceptNoteToUpdate.size() ##### '+lstConceptNoteToUpdate.size());
                            UpdateCFAeqFA(strBandId);
                        //Is sum(Min) < sum(NAA)?
                        }else{
                            for(Concept_Note__c objCN : lstConceptNoteToUpdate){
                                objCN.CFA__c = objCN.NAA__c;
                            }
                            update lstConceptNoteToUpdate;
                            
                            blnMinlessthanNAA = true;
                        }
                        update lstConceptNoteToUpdate;
                        //blnMinlessthanNAA = true;
                    }
                    //is sum(Min) < sum(NAA)
                    if(blnMinlessthanNAA == true){
                        intDiffDown = rescalingformula_4feb.getIntDiffDown(strBandId);
                        intDiffUp = rescalingformula_4feb.getIntDiffUp(strBandId);  
                        List<Concept_Note__c> lstAboveMax = new List<Concept_Note__c>();
                        lstAboveMax = rescalingformula_4feb.getlstAboveMax(strBandId);
                        
                        lstBelowMin = new List<Concept_Note__c>();
                        lstBelowMin = rescalingformula_4feb.getlstBelowMin(strBandId);
                        system.debug('##### lstAboveMax.size() ##### '+ lstAboveMax.size());
                        system.debug('##### lstBelowMin.size() ##### '+ lstBelowMin.size());
                        // Step 3: If there are any CNs above their max...
                        if(lstAboveMax.size() > 0){
                            decimal Excess = rescalingformula_4feb.getIntExcess(strBandId); 
                            // Step 4.1: If there are any CNs below their min...
                            if(lstBelowMin.size() > 0){
                                decimal Deficit = rescalingformula_4feb.getIntDeficit(strBandId);                                                 
                                setAboveMaxToMax(strBandId);
                                setBelowMinToMin(strBandId);
                                system.debug('##### rescalingformula_4feb.getIntExcess(strBandId) ##### '+ rescalingformula_4feb.getIntExcess(strBandId));
                                system.debug('##### rescalingformula_4feb.getIntDeficit(strBandId) ##### '+ rescalingformula_4feb.getIntDeficit(strBandId));
                                // Step 5.1: if IntExcess > IntDeficit
                                if(Excess >= Deficit){
                                    system.debug('##### lstAboveMax.size() ##### '+ lstAboveMax.size());
                                    // step A: If there are any CNs above their max...
                                    //if(lstAboveMax.size() > 0){
                                        // step 6.1: Execute RescalingUp
                                        While(lstAboveMax.size() > 0){
                                            executeRescalingUp(strBandId);
                                            rescalingformula_4feb.RUcount ++;
                                            lstAboveMax = new List<Concept_Note__c>();
                                            lstAboveMax = rescalingformula_4feb.getlstAboveMax(strBandId);
                                        }                                    
                                    //}
                                    // step 6.2: Set FA to CFA
                                    system.debug('##### lstConceptNoteToUpdate ##### '+lstConceptNoteToUpdate.size());
                                    UpdateCFAeqFA(strBandId);
                                // Step B: If IntExcess < IntDeficit...
                                }else{
                                    system.debug('##### lstBelowMin.size() ##### '+ lstBelowMin.size());
                                    // Step 6.3: If there are CNs below min, excecute RescalingDown
                                    //if(lstBelowMin.size() > 0){
                                        While(lstBelowMin.size() > 0){
                                            executeRescalingDown(strBandId);
                                            rescalingformula_4feb.RDcount ++;
                                            lstBelowMin = new List<Concept_Note__c>();
                                            lstBelowMin = rescalingformula_4feb.getlstBelowMin(strBandId);
                                        }                                     
                                    //}
                                    // Step 6.4: Set FA to CFA
                                    system.debug('##### lstConceptNoteToUpdate ##### '+lstConceptNoteToUpdate.size());
                                    UpdateCFAeqFA(strBandId);
                                }
                                
                            // Step 4.2: if no CN's are below their Min
                            }else{
                                system.debug('##### lstAboveMax ##### '+lstAboveMax.size());
                                // step 6.6
                                if(lstAboveMax.size() > 0){
                                    While(lstAboveMax.size() > 0){
                                        executeRescalingUp(strBandId);
                                        rescalingformula_4feb.RUcount ++;
                                        lstAboveMax = new List<Concept_Note__c>();
                                        lstAboveMax = rescalingformula_4feb.getlstAboveMax(strBandId);
                                    }
                                }   
                                // step 6.7    
                                system.debug('##### lstConceptNoteToUpdate '+lstConceptNoteToUpdate.size());                         
                                UpdateCFAeqFA(strBandId);
                            }
                            
                        // If no CNs are above their max...
                        }else{ 
                            // step B executeRescalingDown
                            if(lstBelowMin.size() > 0){                         
                                system.debug('##### lstBelowMin ##### '+lstBelowMin.size());
                                While(lstBelowMin.size() > 0){
                                    executeRescalingDown(strBandId);
                                    rescalingformula_4feb.RDcount ++;
                                    lstBelowMin = new List<Concept_Note__c>();
                                    lstBelowMin = rescalingformula_4feb.getlstBelowMin(strBandId);
                                }
                                // step 6.8
                            // step 5.2: Set FA to CFA
                            }
                            system.debug('##### lstConceptNoteToUpdate '+lstConceptNoteToUpdate.size());
                            UpdateCFAeqFA(strBandId);
                        }
                    }
                }
            }
        }catch(exception ex){
           return ex.getMessage();
        }            
        return '';
    }
    /**********************************************************************************************
    Purpose: Set Final_Allocation to CFA
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static void UpdateCFAeqFA(String strBandId){
        List<Concept_Note__c> lstCNFinalAllocation = new List<Concept_Note__c>();
        lstCNFinalAllocation = [Select Id,Minimum__c,Hard_Floor_Including_Risk__c,CFA__c,NAA__c,Risk_Adjustment__c,Final_Allocation__c 
                                  From Concept_Note__c Where Band__c =: strBandId and Eligible_for_Rescaling__c = 'Yes'];
        if(lstCNFinalAllocation.size() > 0){
            for(Concept_Note__c objCN : lstCNFinalAllocation){
                objCN.Final_Allocation__c = objCN.CFA__c + objCN.Risk_Adjustment__c;
            }
            update lstCNFinalAllocation;
       } 
    }
    /**********************************************************************************************
    Purpose: Get list of concept note that are above max
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static List<Concept_Note__c> getlstAboveMax(String strBandId){
        return [Select Id,CFA__c,Maximum__c From Concept_Note__c 
                                        Where CFA_Graterthan_Maximum__c = true And Eligible_for_Rescaling__c = 'Yes' 
                                        And Band__c =: strBandId];
    }
    /**********************************************************************************************
    Purpose: Get list of concept note that are below min
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static List<Concept_Note__c> getlstBelowMin(String strBandId){
        return [Select Id,CFA__c,Minimum__c From Concept_Note__c 
                                        Where CFA_Lessthan_Minimum__c = true And Eligible_for_Rescaling__c = 'Yes' 
                                        And Band__c =: strBandId];
    }
     /**********************************************************************************************
    Purpose: To get list of concept note those are Above min
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static List<Concept_Note__c> getlstAboveMin(String strBandId){
        return [Select Id,CFA__c,Minimum__c From Concept_Note__c 
                                        Where CFA_Graterthan_Minimum__c = true And Eligible_for_Rescaling__c = 'Yes' 
                                        And Band__c =: strBandId];
    }
    /**********************************************************************************************
    Purpose: To get list of concept note those are Below max
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static List<Concept_Note__c> getlstBelowMax(String strBandId){
        return [Select Id,CFA__c,Maximum__c From Concept_Note__c 
                                        Where CFA_Lessthan_Maximum__c = true And Eligible_for_Rescaling__c = 'Yes' 
                                        And Band__c =: strBandId];
    }
    /**********************************************************************************************
    Purpose: To update CFA with Maximum in the list of concept note those are Above Max To Max
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static void setAboveMaxToMax(String strBandId){
        List<Concept_Note__c> lstAboveMaxTemp = new List<Concept_Note__c>();
        lstAboveMaxTemp = rescalingformula_4feb.getlstAboveMax(strBandId);
        if(lstAboveMaxTemp.size() > 0){
            //Create Rescaling Records
            Rescaling_Record__c objRescaling;
            List<Rescaling_Record__c> lstRescalingToInsert = new List<Rescaling_Record__c>();
            for(Concept_Note__c objCN : lstAboveMaxTemp){
                    Decimal oldCFA = objCN.CFA__c;
                    Decimal newCFA = objCN.Maximum__c;
                    objRescaling = new Rescaling_Record__c(Concept_Note__c = objCN.id,New_CFA__c = newCFA,
                                                    Old_CFA__c = oldCFA,Rescaling_Number__c = rescalingformula_4feb.RDcount);
                    lstRescalingToInsert.add(objRescaling);
                }
            if(lstRescalingToInsert.size() > 0) insert lstRescalingToInsert;
            //Set CN CFA to Maximum
            for(Concept_Note__c objCN : lstAboveMaxTemp){
                objCN.CFA__c = objCN.Maximum__c;
            }
            update lstAboveMaxTemp;            
            }
        }
    /**********************************************************************************************
    Purpose: To update CFA with minimum in the list of concept note those are Below Min To Min
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static void setBelowMinToMin(String strBandId){
        List<Concept_Note__c> lstBelowMinTemp = new List<Concept_Note__c>();
        lstBelowMinTemp = rescalingformula_4feb.getlstBelowMin(strBandId);
        if(lstBelowMinTemp.size() > 0){
            //Create Rescaling Records
            Rescaling_Record__c objRescaling;
            List<Rescaling_Record__c> lstRescalingToInsert = new List<Rescaling_Record__c>();
            for(Concept_Note__c objCN : lstBelowMinTemp){
                    Decimal oldCFA = objCN.CFA__c;
                    Decimal newCFA = objCN.Minimum__c;
                    objRescaling = new Rescaling_Record__c(Concept_Note__c = objCN.id,New_CFA__c = newCFA,
                                                    Old_CFA__c = oldCFA,Rescaling_Number__c = rescalingformula_4feb.RDcount);
                    lstRescalingToInsert.add(objRescaling);
                }
            if(lstRescalingToInsert.size() > 0) insert lstRescalingToInsert;
            //Set CN CFA to Min
            for(Concept_Note__c objCN : lstBelowMinTemp){
                objCN.CFA__c = objCN.Minimum__c;
            }
            update lstBelowMinTemp;
        }
    }
    /**********************************************************************************************
    Purpose: To update CFA with new CFA formula and insert Rescaling record with old and new CFA.
            and update Band to rescaling down.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static void executeRescalingDown(String strBandId){
        Decimal intDenomDownTemp = rescalingformula_4feb.getIntDenomDown(strBandId);
        Decimal intDiffDownTemp = intDiffDown;
        setBelowMinToMin(strBandId);
        List<Concept_Note__c> lstAboveMinTemp = new List<Concept_Note__c>();
        lstAboveMinTemp = rescalingformula_4feb.getlstAboveMin(strBandId);
        Rescaling_Record__c objRescaling;
        List<Rescaling_Record__c> lstRescalingToInsert = new List<Rescaling_Record__c>();
        if(lstAboveMinTemp.size() > 0){
            for(Concept_Note__c objCN : lstAboveMinTemp){
                if(intDenomDownTemp != 0){
                    Decimal oldCFA = objCN.CFA__c;
                    objCN.CFA__c = objCN.CFA__c - ((objCN.CFA__c/intDenomDownTemp) * intDiffDownTemp);
                    objRescaling = new Rescaling_Record__c(Concept_Note__c = objCN.id,New_CFA__c = objCN.CFA__c,
                                                    Old_CFA__c = oldCFA,Rescaling_Number__c = rescalingformula_4feb.RDcount);
                    lstRescalingToInsert.add(objRescaling);
                }
            }
            update lstAboveMinTemp;
            if(lstRescalingToInsert.size() > 0) insert lstRescalingToInsert;
            List<Concept_Note__c> lstBelowMinTemp = new List<Concept_Note__c>();
            lstBelowMinTemp = rescalingformula_4feb.getlstBelowMin(strBandId);
            Band__c objBandToUpdate = new Band__c(id = strBandId,  Number_of_CNs_below_Minimum__c = lstBelowMinTemp.size());
            update objBandToUpdate;
        }
        intDiffDown = rescalingformula_4feb.getIntDiffDown(strBandId);
    }
    /**********************************************************************************************
    Purpose: To update CFA with new CFA formula and insert Rescaling record with old and new CFA.
            and update Band to rescaling up;
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static void executeRescalingUp(String strBandId){
        Decimal intDenomUpTemp = rescalingformula_4feb.getIntDenomUp(strBandId);
        Decimal intDiffUpTemp = intDiffUp;
        setAboveMaxToMax(strBandId);
        List<Concept_Note__c> lstBelowMaxTemp = new List<Concept_Note__c>();
        lstBelowMaxTemp = rescalingformula_4feb.getlstBelowMax(strBandId);
        Rescaling_Record__c objRescaling;
        List<Rescaling_Record__c> lstRescalingToInsert = new List<Rescaling_Record__c>();
        if(lstBelowMaxTemp.size() > 0){
            for(Concept_Note__c objCN : lstBelowMaxTemp){
                if(intDenomUpTemp != 0){
                    Decimal oldCFA = objCN.CFA__c;
                    objCN.CFA__c = objCN.CFA__c + ((objCN.CFA__c/intDenomUpTemp) * intDiffUpTemp);
                    objRescaling = new Rescaling_Record__c(Concept_Note__c = objCN.id,New_CFA__c = objCN.CFA__c,
                                                    Old_CFA__c = oldCFA,Rescaling_Number__c = rescalingformula_4feb.RDcount);
                    lstRescalingToInsert.add(objRescaling);
                }
            }
            update lstBelowMaxTemp;
            if(lstRescalingToInsert.size() > 0) insert lstRescalingToInsert;
            List<Concept_Note__c> lstAboveMaxTemp = new List<Concept_Note__c>();
            lstAboveMaxTemp = rescalingformula_4feb.getlstAboveMax(strBandId);
            Band__c objBandToUpdate = new Band__c(id = strBandId,  Number_of_CNs_Above_Maximum__c = lstAboveMaxTemp.size());
            update objBandToUpdate;
        }
        intDiffUp = rescalingformula_4feb.getIntDiffUp(strBandId);  
    }
    /**********************************************************************************************
    Purpose: To update CFA with new CFA formula and insert Rescaling record with old and new CFA.
            and update Band to rescaling up;
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static Decimal getIntDenomDown(String strBandId){
        Decimal intDenomDown = 0;
        List<Concept_Note__c> lstAboveMinTemp = new List<Concept_Note__c>();
        lstAboveMinTemp = rescalingformula_4feb.getlstAboveMin(strBandId);
        if(lstAboveMinTemp.size() > 0){
            for(Concept_Note__c objCN : lstAboveMinTemp){
                if(objCN.CFA__c == null)  objCN.CFA__c = 0;
                intDenomDown += objCN.CFA__c;                        
            }
        }
        return intDenomDown;
    }
    /**********************************************************************************************
    Purpose: get IntDenomUp sum of CFA of BelowMax concept note list.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static Decimal getIntDenomUp(String strBandId){
        Decimal intDenomUp = 0;
        List<Concept_Note__c> lstBelowMaxTemp = new List<Concept_Note__c>();
        lstBelowMaxTemp = rescalingformula_4feb.getlstBelowMax(strBandId);
        if(lstBelowMaxTemp.size() > 0){
            for(Concept_Note__c objCN : lstBelowMaxTemp){
                if(objCN.CFA__c == null)  objCN.CFA__c = 0;
                intDenomUp += objCN.CFA__c;                        
            }
        }
        return intDenomUp;  
    }
    /**********************************************************************************************
    Purpose: get intExcess subtraction of Sum of CFA and Sum of Maximum of Above Max concept note list.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public static Decimal getIntExcess(String strBandId){
        Decimal intExcess = 0;
        List<Concept_Note__c> lstAboveMaxTemp = new List<Concept_Note__c>();
        lstAboveMaxTemp = rescalingformula_4feb.getlstAboveMax(strBandId);
        if(lstAboveMaxTemp.size() > 0){
            Decimal intSumCFA = 0;
            Decimal intSumMaximum = 0;
            for(Concept_Note__c objCN : lstAboveMaxTemp){
                if(objCN.CFA__c != null){
                    intSumCFA += objCN.CFA__c;
                }
                if(objCN.Maximum__c != null){
                    intSumMaximum += objCN.Maximum__c;
                }
            }
            intExcess = intSumCFA - intSumMaximum;
        }
        return intExcess;
    }
     /**********************************************************************************************
    Purpose: get IntDeficit subtraction of Sum of subtraction of minimum and CFA.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/  
     Public static Decimal getIntDeficit(String strBandId){
        Decimal intDeficit = 0;
        List<Concept_Note__c> lstBelowMinTemp = new List<Concept_Note__c>();
        lstBelowMinTemp = rescalingformula_4feb.getlstBelowMin(strBandId);
        if(lstBelowMinTemp.size() > 0){
            for(Concept_Note__c objCN : lstBelowMinTemp){
                if(objCN.CFA__c == null)  objCN.CFA__c = 0;
                if(objCN.Minimum__c == null)  objCN.Minimum__c = 0;
                Decimal Temp = objCN.Minimum__c - objCN.CFA__c;
                intDeficit += Temp;                        
            }
        }  
        return intDeficit; 
    }
    /**********************************************************************************************
    Purpose: get IntDiffUp subtraction of IntExcess and IntDeficit.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/  
    Public static Decimal getIntDiffUp(String strBandId){
        Decimal intDiffUpX = 0;
        intDiffUpX = rescalingformula_4feb.getIntExcess(strBandId) - rescalingformula_4feb.getIntDeficit(strBandId);
        return intDiffUpX;
    }
    /**********************************************************************************************
    Purpose: get IntDiffDown subtraction of IntDeficit and IntExcess.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/  
    Public static Decimal getIntDiffDown(String strBandId){
        Decimal intDiffDownX = 0;
        intDiffDownX = rescalingformula_4feb.getIntDeficit(strBandId) - rescalingformula_4feb.getIntExcess(strBandId);
        return intDiffDownX;
    }
    /**********************************************************************************************
    Purpose: get Updated list concept note.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/  
    Public static List<Concept_Note__c> updateListCN (String strBandId){
        return [Select Id,Minimum__c,Hard_Floor_Including_Risk__c,CFA__c,NAA__c,Risk_Adjustment__c,
                                                Final_Allocation__c 
                                                From Concept_Note__c Where Band__c =: strBandId AND Eligible_for_Rescaling__c = 'Yes'];
    }
    
    /**********************************************************************************************
    Purpose: Update all concept notes where Eligible for Rescaling = No with NFA = Final_Allocation.
    Parameters: strBandId - Band__c id
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/  
    Public static void updateListCNineligible(String strBandId){
        List<Concept_Note__c> CNineligible = [Select Id,NFA__c,Final_Allocation__c 
                                                From Concept_Note__c 
                                                Where Band__c =: strBandId And Eligible_for_Rescaling__c = 'No' ];
        for(Concept_Note__c objCN : CNineligible){
            objCN.Final_Allocation__c=objCN.NFA__c;            
        }        
        update CNineligible;
    }    
}