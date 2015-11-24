/*******************************************************************************
* Concept Note Program Split Controller
----------------------------------------------------------------------------------
*History
*Version       Date       DETAIL FEATURES
  1.1         12/05/2014   Added validation for sign-off check boxes  
********************************************************************************/
Global with sharing class CNProgramSplit_archive {
Public Date allocationDate;
public Program_Split__c programSplit {get;set;}
public List<Attachment> lstAttachment {get;set;}
Public String strGuidanceId {get;set;}
Public String strLanguage {get;set;}
public Integer intCountCN {get;set;}
public Boolean blnGFInternal {get;set;}
public Boolean escalatedReview {get;set;}
public Boolean blnDisplay {get;set;}
public Boolean blnReadOnly {get;set;}
public List<Concept_Note__c> conceptNotes {get;set;}
public List<ConceptNote> lstWrapConceptNotes {get;set;}
public Integer mil {get;set;}
String CNId;
String PSId;

//Variables for totals
public Decimal intTotalOPS {get;set;}
public Decimal intTotalRPS {get;set;}
public Decimal intTotalallocation {get;set;}
public String attachmentIdToDelete{get;set;}
public Decimal finalTotalAllocation {get;set;}
public String FPMSignOff {get;set;}
public String RMSignOff {get;set;}
public String TPASignOff {get;set;}
public Integer intRMSignOff {get;set;}
public Integer intTPASignOff {get;set;}

Set<Id> setExternalIds = new Set<Id>();
//String strQuery = '';

    public CNProgramSplit_archive() {
        blnReadOnly = CheckProfile.checkProfile();
        //Update this date for the next round of CN in a couple years
        allocationDate = date.newInstance(2014,1,1);
        
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Program Split'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
              
        strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
            
        //escalatedReview = false;
        CNId = ApexPages.currentPage().getParameters().get('CNId');
        //programSplit = (Program_Split__c) controller.getRecord();
        for(Profile p : [Select Id from Profile where Name LIKE '%CM%' OR Name LIKE '%PR%']) {    
           setExternalIds.add(p.Id); }
           
        blnGFInternal = false;  
                                      
        if(setExternalIds.contains(UserInfo.getProfileId())){
            blnGFInternal = false;
        } else {
            blnGFInternal = true; 
        }   
        finalTotalAllocation = 0;        
        RMSignOff = 'Yes';
        TPASignOff = 'Yes';
        intRMSignOff = 0;
        intTPASignOff = 0;
        LoadConceptNotes();
        loadAttachments();
        //AggregateValues();
        if(programSplit.Agreed__c == true)
         for(Concept_Note__c CN : conceptNotes){
                    if (CN.Agreed_Split_USD__c != NULL)                                                
                    finalTotalAllocation += CN.Agreed_Split_USD__c;
                    if (CN.Agreed_Split_EUR__c != NULL)                
                    finalTotalAllocation += CN.Agreed_Split_EUR__c;
                    FPMSignOff = 'Yes';
         }
         switchText();
         if(intRMSignOff == 1)
             RMSignOff = '-';
         if(intTPASignOff == 1)
             TPASignOff = '-';          
    }
    
    public Class ConceptNote{
        Public Concept_Note__c objCN {get; set;}
        Public Decimal signedAmount {get;set;}
        Public Decimal unsignedAmount {get;set;}

      public ConceptNote(Concept_Note__c CN, Decimal signed, Decimal unsigned) {
        objCN = CN;
        signedAmount = signed;
        unsignedAmount = unsigned;                     
       }
     } 
    

    
    public void LoadConceptNotes() {
      programSplit = new Program_Split__c();
      conceptNotes = new List<Concept_Note__c>();
      lstWrapConceptNotes = new List<ConceptNote>();
      PSId = ApexPages.currentPage().getParameters().get('Id');
      
      // ************** Conditional Country rendering *******************
      List<Program_Split__c> lstProgramSplit = [Select Id, Name, CurrencyIsoCode, Agreed__c, CCM__c, CCM__r.Country__r.Name, CCM__r.Country__r.French_Name__c , 
          CCM__r.Country__r.Spanish_Name__c , CCM__r.Country__r.Russian_Name__c , Escalated_Review__c, Evidence_of_CCM_Endorsement__c, 
          Global_Fund_Internal_Review_Comments__c, OPS_Submitted__c, Outside_Range__c, Rationale_for_Proposed_Split__c, RPS_In_Reject_Status__c,
          RPS_Requested__c, RPS_Submitted__c, Status__c, Show_Combined_Concept_Note__c from Program_Split__c where Id = :PSId];
      
      if(lstProgramSplit.size() > 0){
          programSplit = lstProgramSplit[0];
          blnDisplay = true;
          if(programSplit.Agreed__c) blnReadOnly = true;
      
      //Most program splits include separate HIV and TB concept notes, but as per a country request, it is possible to show the combined note instead.
      if(!programSplit.Show_Combined_Concept_Note__c){    
          conceptNotes = 
        [Select Name, Component__c,Final_Allocation__c,
          New_Split__c, Existing_Split__c, Signed__c, Unsigned__c, Original_Proposed_Split__c, Proportion_of_Allocation__c,
          Escalated_Review__c, Revised_Proposed_Split__c, Revised_Split_Range__c, GF_Program_Split_Signoff__c, 
          GF_Program_Split_Signoff_RM_HoD__c, GF_Program_Split_Signoff_TPA__c, CurrencyIsoCode,
          /*new fields*/ Communicated_Allocation_EUR__c, Communicated_Allocation_USD__c, Existing_Funding_at_Allocation_Date_EUR__c, 
          Signed_Undisbursed_Allocation_Date_USD__c, Signed_Undisbursed_Allocation_Date_EUR__c,
          Agreed_Split_USD__c, Agreed_Split_EUR__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,
          Additional_Funding_Number__c, Additional_Funding_EUR__c
          from Concept_Note__c 
          WHERE Program_Split__c = :programSplit.Id AND Component__c != 'Health Systems Strengthening'
          AND Component__c != 'HIV/TB'
          ORDER BY Component__c];
       }else{
           conceptNotes = 
        [Select Name, Component__c,Final_Allocation__c,
          New_Split__c, Existing_Split__c, Signed__c, Unsigned__c, Original_Proposed_Split__c, Proportion_of_Allocation__c,
          Escalated_Review__c, Revised_Proposed_Split__c, Revised_Split_Range__c, GF_Program_Split_Signoff__c, 
          GF_Program_Split_Signoff_RM_HoD__c, GF_Program_Split_Signoff_TPA__c, CurrencyIsoCode,
          /*new fields*/ Communicated_Allocation_EUR__c, Communicated_Allocation_USD__c, Existing_Funding_at_Allocation_Date_EUR__c, 
          Signed_Undisbursed_Allocation_Date_USD__c, Signed_Undisbursed_Allocation_Date_EUR__c,
          Agreed_Split_USD__c, Agreed_Split_EUR__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,
          Additional_Funding_Number__c, Additional_Funding_EUR__c, Component_Code__c
          from Concept_Note__c 
          WHERE Program_Split__c = :programSplit.Id AND Component__c != 'Health Systems Strengthening'
          AND Component__c != 'HIV/AIDS'
          AND Component__c != 'Tuberculosis'
          ORDER BY Component_Code__c];   
       }  
          
      List<Concept_Note__c> lstHSS = [Select Name, Component__c,Final_Allocation__c, 
          New_Split__c, Existing_Split__c, Signed__c, Unsigned__c, Original_Proposed_Split__c, Proportion_of_Allocation__c,
          Escalated_Review__c, Revised_Proposed_Split__c, Revised_Split_Range__c, GF_Program_Split_Signoff__c,
          GF_Program_Split_Signoff_RM_HoD__c, GF_Program_Split_Signoff_TPA__c, CurrencyIsoCode,
          /*new fields*/ Communicated_Allocation_EUR__c, Communicated_Allocation_USD__c, Existing_Funding_at_Allocation_Date_EUR__c, 
          Signed_Undisbursed_Allocation_Date_USD__c, Signed_Undisbursed_Allocation_Date_EUR__c,
          Agreed_Split_USD__c, Agreed_Split_EUR__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,
          Additional_Funding_Number__c, Additional_Funding_EUR__c
          from Concept_Note__c 
          WHERE Program_Split__c = :programSplit.Id AND Component__c = 'Health Systems Strengthening'
          AND Open__c = true];
        if(!lstHSS.isEmpty()){
            conceptNotes.addAll(lstHSS); }
            
      List<AggregateResult> lstSignedAmount = [Select Grant__r.Disease_Component__c component, SUM(Signed_Amount_USD__c) signedAmountUSD, SUM(Signed_Amount_EUR__c) signedAmountEUR
                                               from Implementation_Period__c WHERE Start_Date__c >= :allocationDate AND Grant__r.Country__c = :programSplit.CCM__r.Country__c
                                               GROUP BY Grant__r.Disease_Component__c];
                                               
        intCountCN = conceptNotes.size()+1;
        intTotalallocation = 0;
        for(Concept_Note__c objcon : conceptNotes){            
            if(objcon.Communicated_Allocation_USD__c != null && objcon.CurrencyIsoCode == 'USD'){
                intTotalallocation += objcon.Communicated_Allocation_USD__c;
            }else if(objcon.Communicated_Allocation_EUR__c != null && objcon.CurrencyIsoCode == 'EUR'){
                intTotalallocation += objcon.Communicated_Allocation_EUR__c;
            }else{
                intTotalallocation= intTotalallocation; }  
            
            Decimal signedAmount = 0;
            Decimal unsignedAmount = objCon.Existing_Split__c;
              if(unsignedAmount == null) unsignedAmount = 0;
            for(AggregateResult objAgg: lstSignedAmount){
                if(objAgg.get('component') == objcon.Component__c){
                  if(objcon.CurrencyIsoCode == 'USD'){
                    if(objAgg.get('signedAmountUSD') != null){
                        signedAmount = (decimal)objAgg.get('signedAmountUSD');                       
                    }else{
                        signedAmount = 0;
                    }
                    if(objAgg.get('signedAmountEUR') != null && objcon.Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c != null){                    
                        signedAmount += (decimal)objAgg.get('signedAmountEUR')*objcon.Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c;                       
                    }
                 }
                 if(objcon.CurrencyIsoCode == 'EUR'){
                    if(objAgg.get('signedAmountEUR') != null){
                        signedAmount = (decimal)objAgg.get('signedAmountEUR');                       
                    }else{
                        signedAmount = 0;
                    }
                    if(objAgg.get('signedAmountUSD') != null && objcon.Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c != null){
                        signedAmount += (decimal)objAgg.get('signedAmountUSD')/objcon.Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c;                       
                    }
                 }
               unsignedAmount -= signedAmount;
                 if(unsignedAmount < 0) unsignedAmount = 0;
               break;
            }           
          }
          ConceptNote newCN = new ConceptNote(objcon, signedAmount, unsignedAmount);
          lstWrapConceptNotes.add(newCN);
        }
        //        if(programSplit.Escalated_Review__c == 'testing the translation workbench (russian value)''Escalated Automatically' || programSplit.Escalated_Review__c == 'Escalated by FPM'){ 
        if(programSplit.Escalated_Review__c == 'Elevated Automatically' || programSplit.Escalated_Review__c == 'Elevated by Country Team'){ 
            escalatedReview = true;  }
        else{
            escalatedReview = false;  }
        AggregateValues();
      } 
      else {
          blnDisplay = false;
       }
      
      
               
     }
     
     public void loadAttachments () {
        if(programSplit != null){
         lstAttachment = 
             [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :programSplit.Id]; }
     }
     
     public void AggregateValues() {
          
      List<AggregateResult> lstCNAggregateResult = new List<AggregateResult>();
      lstCNAggregateResult = [Select Sum(Original_Proposed_Split__c) TotalOPS, Sum(Revised_Proposed_Split__c) TotalRPS From Concept_Note__c 
                                                    Where /*Program_Split__c = :programSplit.Id*/ Id in: conceptNotes];      
      
      decimal decRPS = (decimal)lstCNAggregateResult[0].get('TotalRPS');
      decimal decOPS = (decimal)lstCNAggregateResult[0].get('TotalOPS'); 
      
      if(decRPS != null){ 
        intTotalRPS = decRPS ; //decRPS.intValue(); 
        }
      if(decOPS != null){ 
        intTotalOPS = decOPS; //decOPS.intValue(); 
        }
      
     }
     
     public void Save() {    
         update programSplit;
         update conceptNotes;  
         //LoadConceptNotes();
       }
     
     public pageReference SaveClose() {
         Save();
         if(CNId != null) {
           return new pageReference('/apex/CNoverview?Id=' + CNId); }
         else {
           return new pageReference('/apex/OpenConceptNotesH');  }
      }
      
      public pageReference Cancel() {
         if(CNId != null) {
           return new pageReference('/apex/CNoverview?Id=' + CNId); }
         else {
           return new pageReference('/apex/OpenConceptNotesH');  }
      }
     
     public pageReference QuickSave() {
         Save();
         LoadConceptNotes();
         return null;  }
         
     public pageReference changeView() {
         Save();
         if(blnGFInternal) {
             blnGFInternal = false; }
         else if(!blnGFInternal) {
             blnGFInternal = true; }
        LoadConceptNotes();
        return null;
     }
     
     public void uncheckSignoff(){
       for(Concept_Note__c objcon : conceptNotes){
              objCon.GF_Program_Split_Signoff__c = false;
              objCon.GF_Program_Split_Signoff_RM_HoD__c = false;
              objCon.GF_Program_Split_Signoff_TPA__c = false;
       }     
     }
     
     public pageReference EscalateReview() {
        if(programSplit.Escalated_Review__c == 'Not Elevated'){
          programSplit.Escalated_Review__c = 'Elevated by Country Team'; }
        uncheckSignoff();
        Save();
        LoadConceptNotes();
        return null;
     }
     
    public pageReference SubmitProposedSplit() {     
        Decimal OPSTotal = 0;
        Decimal RPSTotal = 0;
        Boolean passed = false;
        String submissionPhase = '';
        
        Save();
        LoadConceptNotes();
        
        system.debug('intTotalOPS:'+intTotalOPS);
        system.debug(programSplit.OPS_Submitted__c);   
        system.debug(programSplit.RPS_Submitted__c);  
        system.debug(programSplit.Rationale_for_Proposed_Split__c); 
        if(!programSplit.OPS_Submitted__c){      
            system.debug('intTotalOPS:'+intTotalOPS);
            //if(intTotalOPS== intTotalAllocation && (programSplit.Rationale_for_Proposed_Split__c != null || programSplit.Rationale_for_Proposed_Split__c != '')){
                programSplit.OPS_Submitted__c = true;               
                passed = true;
                submissionPhase = 'OPS';
           // }             
        }
        else if(!programSplit.RPS_Submitted__c){
            system.debug('intTotalRPS2:'+intTotalRPS);
            //if(intTotalRPS == intTotalAllocation && (programSplit.Rationale_for_Proposed_Split__c != null || programSplit.Rationale_for_Proposed_Split__c != '')){
                programSplit.RPS_Submitted__c = true;
                programSplit.RPS_In_Reject_Status__c = false;
                passed = true;
                submissionPhase = 'RPS';
            //}
        } 
    
        if(passed){
            system.debug('Save:passed '+passed );
            uncheckSignoff();
            
          
            integer intEscalated=0;
            integer intRangeCheck=0;
            for(Concept_Note__c objcon : conceptNotes){
                system.debug('#$#$#$'+submissionPhase);
                system.debug('#$#$#$'+objcon.Revised_Split_Range__c);
                system.debug('#$#$#$'+programSplit.RPS_Submitted__c);
                if(submissionPhase == 'OPS'){
                    if((objcon.Escalated_Review__c != '-') && programSplit.OPS_Submitted__c){
                        intEscalated++;  }
                    if(intEscalated > 0){
                      programSplit.Escalated_Review__c = 'Elevated Automatically';
                    }else{
                      programSplit.Escalated_Review__c = 'Not Elevated'; }
                }
                
                else if(submissionPhase == 'RPS'){    
                    if((objcon.Revised_Split_Range__c != '-') && programSplit.RPS_Submitted__c){
                      
                      intRangeCheck++;  } 
                      system.debug('#$#$#$'+intRangeCheck );      
                    if(intRangeCheck > 0){
                      programSplit.Outside_Range__c = 'Issue';
                    }else{
                      programSplit.Outside_Range__c = 'No Issue'; }
                }
            }
        Save();
        LoadConceptNotes();            
        }
        //pageReference p = new pageReference ('/apex/CNProgramSplit?id='+PSId );
        //p.setredirect(true);
        return null;
    }
     
     
     public pageReference RequestRPS() {
        if(!programSplit.RPS_Requested__c){
          programSplit.RPS_Requested__c = true;                      
        }
        uncheckSignoff();
        Save();
        LoadConceptNotes();
        return null;
     }
     
     public void SetAgreedSplit() {
        //This section modified by Matthew Miller on 9/6/2014 to automate setting of Agreed Split for combined concept note
        Decimal decSplitTB;
        Decimal decSplitHIV;
           
        if(programSplit.Outside_Range__c == 'Issue' && programSplit.Global_Fund_Internal_Review_Comments__c == null){      
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Program_Split_Notes_Outside_Range));
        }
        else{
        Integer count = 0;
        for(Concept_Note__c CN : conceptNotes){
            if((!escalatedReview || programSplit.RPS_Submitted__c) && CN.GF_Program_Split_Signoff__c){
                count++; }
            else if(escalatedReview && !programSplit.RPS_Requested__c && CN.GF_Program_Split_Signoff_RM_HoD__c && CN.GF_Program_Split_Signoff_TPA__c){
                count++; }
         }
        if(count == conceptNotes.size()){       
            for(Concept_Note__c CN : conceptNotes){
                if(programSplit.RPS_Submitted__c ){
                  if(CN.CurrencyIsoCode == 'USD'){                    
                    CN.Agreed_Split_USD__c = CN.Revised_Proposed_Split__c;
                      if(CN.Agreed_Split_USD__c != null) finalTotalAllocation += CN.Agreed_Split_USD__c;
                  } else {                    
                    CN.Agreed_Split_EUR__c = CN.Revised_Proposed_Split__c;
                      if(CN.Agreed_Split_EUR__c != null) finalTotalAllocation += CN.Agreed_Split_EUR__c;
                  }
                }
                else if(!programSplit.RPS_Submitted__c){
                  if(CN.CurrencyIsoCode == 'USD'){                    
                    CN.Agreed_Split_USD__c = CN.Original_Proposed_Split__c;                    
                      if(CN.Agreed_Split_USD__c != null) finalTotalAllocation += CN.Agreed_Split_USD__c;
                  } else {
                    CN.Agreed_Split_EUR__c = CN.Original_Proposed_Split__c;
                      if(CN.Agreed_Split_EUR__c != null) finalTotalAllocation += CN.Agreed_Split_EUR__c;
                  }                  
                }
                
                //Here we are setting the agreed splits of H and T to variables for use below in setting the C agreed split
                if(CN.CurrencyIsoCode == 'USD'){
                    if(CN.Component__c == 'HIV/AIDS') decSplitHIV = CN.Agreed_Split_USD__c;
                    if(CN.Component__c == 'Tuberculosis') decSplitTB = CN.Agreed_Split_USD__c;
                }else if(CN.CurrencyIsoCode == 'EUR'){
                    if(CN.Component__c == 'HIV/AIDS') decSplitHIV = CN.Agreed_Split_EUR__c;
                    if(CN.Component__c == 'Tuberculosis') decSplitTB = CN.Agreed_Split_EUR__c;
                }
             }
           
           //In this section, we will query for the combined concept note, and if it exists, we will add together the agreed splits of H and T and update the C record.
           if(!programSplit.Show_Combined_Concept_Note__c){
               
               List<Concept_Note__c> lstCombinedCN = [Select Id, Agreed_Split_USD__c, Agreed_Split_EUR__c from Concept_Note__c 
                                               WHERE Component__c = 'HIV/TB'
                                               AND Program_Split__c = :programSplit.Id];
                                               
               if(lstCombinedCN.size() > 0 ){
                if(decSplitHIV == null) decSplitHIV = 0;
                if(decSplitTB == null) decSplitTB = 0;
                   if(lstCombinedCN[0].CurrencyIsoCode == 'USD'){
                       lstCombinedCN[0].Agreed_Split_USD__c = decSplitHIV + decSplitTB;
                   }else if(lstCombinedCN[0].CurrencyIsoCode == 'EUR'){
                       lstCombinedCN[0].Agreed_Split_EUR__c = decSplitHIV + decSplitTB;
                   }
               update lstCombinedCN;
               }                
           }
           
           programSplit.Agreed__c = true;
           FPMSignOff = 'Yes';
           RMSignOff = 'Yes';
           TPASignOff = 'Yes';
        }
        QuickSave();
        //switchText();
        Integer decision = -1;
        decision = checkforPS();
        system.debug('Decision:' +decision);
        if (decision == 0)           
            RMSignOff = 'Yes';
        if (decision == 1)
            TPASignOff = 'Yes';       
      }
    
     }
     
     public pageReference RejectRevisedSplit() {
        programSplit.RPS_Submitted__c = false;
        programSplit.RPS_In_Reject_Status__c = true;
        uncheckSignoff();
        Save();
        LoadConceptNotes();
        return null;
     }
     
     public pageReference UploadFile() {
         Save();
         return new pageReference('/p/attach/NoteAttach?pid=' + programSplit.Id + '&retURL=%2Fapex%2FCNProgramSplit?id=' + programSplit.Id + '%26CNId=' + CNId);  }
         
     public void removeRow() {
         if(attachmentIdToDelete != NULL){
             delete [Select Id from Attachment where Id =:attachmentIdToDelete];
             lstAttachment = [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :programSplit.Id];
         }
     }
        //TCS changes for sign_off validation begins  
        @RemoteAction           
        global static integer fetchPermissionSet(String user, Integer result) {  
                        system.debug('in function');
         for (PermissionSetAssignment PS1 : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :Label.Program_Split_RM_HoD_Signoff]) {
            system.debug('user in RM'+user);    
                system.debug('assign in RM'+PS1.AssigneeId);    
             if(PS1.AssigneeId == user){                 
                 result = 1;                 
                 break;
             }
         }
         for (PermissionSetAssignment PS2 : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :Label.Program_Split_TPA_Signoff]) {
             if(PS2.AssigneeId == user){                 
                 result = 2;                 
                 break;
             }
         }         
         return result;         
        }
        
        public void switchText(){ // sets value for  changing text
          if(conceptNotes != null){  
            for(Concept_Note__c CN : conceptNotes) {                        
                 if (!CN.GF_Program_Split_Signoff_RM_HoD__c)
                     intRMSignOff = 1;
                 if (!CN.GF_Program_Split_Signoff_TPA__c)
                     intTPASignOff = 1;
              }
           }                      
        }
        
        public integer checkforPS () { //Checks for permission set to which user is assigned to         
            Integer returnint = -1;
            User u = [select Id from user where id=:userinfo.getuserid()];
            string userID = u.Id;            
            for (PermissionSetAssignment PS : [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :userID]) {
                if(PS.PermissionSetId == Label.Program_Split_RM_HoD_Signoff)
                {returnint = 0;
                 break;
                }
                if(PS.PermissionSetId == Label.Program_Split_TPA_Signoff)
                {returnint = 1;
                 break;
                }
            }
            return returnint;
        }
        //TCS changes for sign_off validation ends
}