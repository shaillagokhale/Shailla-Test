/*******************************************************************************
* Concept Note Program Split Controller
----------------------------------------------------------------------------------
*History
*Version       Date       DETAIL FEATURES
  1.1         12/05/2014   Added validation for sign-off check boxes  
********************************************************************************/
Global with sharing class CNProgramSplit {

Public Date allocationDate;
public Program_Split__c programSplit {get;set;}
public List<Attachment> lstAttachment {get;set;}
Public String strGuidanceId {get;set;}
Public String strLanguage {get;set;}
public Integer intCountCN {get;set;}
//public Boolean blnGFInternal {get;set;}
public Boolean escalatedReview {get;set;}
public Boolean blnDisplay {get;set;}
public Boolean blnReadOnly {get;set;}
public List<Concept_Note__c> conceptNotes {get;set;}
public List<ConceptNote> lstWrapConceptNotes {get;set;}
public Integer mil {get;set;}
public String CNId {get; set;}
public String PSId {get; set;}
Public String userId;
 
//Added 2014.07.28 by Matthew Miller responding to INC011516
public Boolean blnEditGFInternal {get;set;}
public Boolean blnEditGFRevisionReq {get;set;}
public Boolean blnEditCCMOriginal {get;set;}
public Boolean blnEditCCMRevised {get;set;}

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
Public Boolean blnShowRevisionComment {get;set;}
Public Boolean blnRPSRequest {get;set;}
Public Boolean blnOPSSubmitted {get;set;}
Public Boolean blnRPSSubmitted {get;set;}

/******** New Booleans for GF review panel ********/
Public Boolean blnHasPermissionSetFPM {get;set;}
Public Boolean blnHasPermissionSetRMHoD {get;set;}
Public Boolean blnHasPermissionSetTAP {get;set;}

//New List and Map for Get Document
Public List<DocumentUpload__c> lstDocumentUpload {get; set;}
Public Set<Id> setFeedItemId {get; set;}
Public Map<Id,FeedItem> mapIdFeedItem {get; set;}
Public Map<Integer,String> mapForSort {get;set;}
Public Map<Integer,String> mapForOrder {get;set;}
Public Map<Integer,String> mapForSortFeed {get;set;}
Public List<WrapperDocumentUpdload> lstWrpDocumentUpload {get; set;}
Public Integer sortItem {get;set;}
Public boolean togglebit {get;set;}
Public Integer DeleteIndex {get;set;}
Public Integer DeleteIndexCCM {get;set;}
Public DocumentUpload__c objDocumentUpload {get; set;}
Public FeedItem objFeedItem {get;set;}
Public Boolean blnTGFInternal {get;set;}

Public List<DocumentUpload__c> lstDocumentUploadCCM {get; set;}
Public Set<Id> setFeedItemIdCCM {get; set;}
Public Map<Id,FeedItem> mapIdFeedItemCCM {get; set;}
Public Map<Integer,String> mapForSortCCM {get;set;}
Public Map<Integer,String> mapForOrderCCM {get;set;}
Public Map<Integer,String> mapForSortFeedCCM {get;set;}
Public List<WrapperDocumentUpdload> lstWrpDocumentUploadCCM {get; set;}
Public Integer sortItemCCM {get;set;}
Public boolean togglebitCCM {get;set;}

Set<Id> setExternalIds = new Set<Id>();
//String strQuery = '';

 //TCS 11/09/2014 Defined variable for Profile Access
    public String strStatus ;
    public Boolean blnExternalPro {get; set;}
    public Boolean blnQuickSave {get; set;}
    public Boolean blnSaveReturn {get; set;}
    public Boolean blnIntGFComment {get; set;}
    public Boolean blnUploadGFInternal {get; set;}
    public Boolean blnCCMEndorsement {get; set;}
    public Boolean blnUploadCCMView {get; set;}
    Public Boolean blnSubmitSignOff {get;set;}
    Public Boolean blnReqRevisedSplit {get;set;}
    Public Boolean blnSaveChangeView {get;set;}
    Public Boolean blnGFInternal {get;set;}
    Public Boolean blnDownloadLinkGF {get;set;}
    Public Boolean blnDeleteCCMDoc {get;set;}
    Public Boolean blnRationalCCM {get;set;}
    Public Boolean blnSubPrgSplit {get;set;}
    Public Boolean blnSndElevatedReview {get;set;}
    Public Boolean blnRationaleProposed {get;set;}
    Public Boolean blnGFReqRevSplit {get;set;}
    Public Boolean blnCCMRevised {get;set;}
    
    
    public CNProgramSplit() {
        //blnReadOnly = CheckProfile.checkProfile();
        
        //Update this date for the next round of CN in a couple years
        allocationDate = date.newInstance(2014,1,1);
        userID = System.UserInfo.getUserId();
        blnHasPermissionSetFPM = false;
        blnHasPermissionSetRMHoD = false;
        blnHasPermissionSetTAP = false;
        blnEditGFInternal = false; 
        blnEditGFRevisionReq = false; 
        blnEditCCMOriginal= false;  
        blnEditCCMRevised= false;  
       // checkPermissionSets();
        
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
        PSId = ApexPages.currentPage().getParameters().get('Id');
        
        LoadDocuments();
       
        checkProfile();
        //programSplit = (Program_Split__c) controller.getRecord();
      /*  for(Profile p : [Select Id from Profile where Name LIKE '%CM%' OR Name LIKE '%PR%']) {    
           setExternalIds.add(p.Id); }
           
        blnGFInternal = false;  
                                      
        if(setExternalIds.contains(UserInfo.getProfileId())){
            blnGFInternal = false;
        } else {
            blnGFInternal = true; 
        }   */
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
    
    public void LoadDocuments() {
        
        lstWrpDocumentUpload = new List<WrapperDocumentUpdload>();
        lstWrpDocumentUploadCCM = new List<WrapperDocumentUpdload>();
        
        objFeedItem = new FeedItem(ParentId = PSId, Type='ContentPost');    
        objDocumentUpload = new DocumentUpload__c(Process_Area__c = 'Concept Note',Program_Split__c = PSId);
        system.debug('PSId :: ' +PSId);
        system.debug('CNId :: ' +CNId);
        //Program_Split__c ObjPS = [SELECT Id FROM Program_Split__c Where Id =: PSId];
        //List<Program_Split__Feed> lstFeedItem = [select id from Program_Split__Feed Where ParentId =: PSId];
        List<DocumentUpload__c> lstPSDocumentUpload = new List<DocumentUpload__c>();
        lstPSDocumentUpload = [Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name, TGF_Internal__c from DocumentUpload__c where Program_Split__c =: PSId and Process_Area__c = 'Concept Note'];
        setFeedItemId = new Set<Id>();
        if(lstPSDocumentUpload.size() > 0) {
            for(DocumentUpload__c objFI : lstPSDocumentUpload ) {
                setFeedItemId.add(objFI.FeedItem_Id__c);
            }
        }
        
        lstDocumentUpload = new List<DocumentUpload__c>();
        lstDocumentUpload = [Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,
                            Type__c,Section__c,Name, TGF_Internal__c from DocumentUpload__c where FeedItem_Id__c In: setFeedItemId and TGF_Internal__c = true];
        
        system.debug('lstDocumentUpload.size() :: ' + lstDocumentUpload.size());
        if(lstDocumentUpload.size() > 0) {
            system.debug('setFeedItemId :: ' + setFeedItemId);
            mapIdFeedItem = new Map<Id,FeedItem> ([Select Id,ContentDescription,ContentFileName,body,RelatedRecordId,CreatedDate,CreatedBy.Name From FeedItem Where Id In: setFeedItemId]);
            system.debug('mapIdFeedItem ::' + mapIdFeedItem);
            for(DocumentUpload__c objDocument : lstDocumentUpload) {
                WrapperDocumentUpdload objWrpDocUpload = new WrapperDocumentUpdload();   
                objWrpDocUpload.objDocumentUpload = objDocument;
                objWrpDocUpload.objFeedItem  = mapIdFeedItem.get(objDocument.FeedItem_Id__c);
                lstWrpDocumentUpload.add(objWrpDocUpload);
            }
        }
        
        lstDocumentUploadCCM = new List<DocumentUpload__c>();
        lstDocumentUploadCCM = [Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name, TGF_Internal__c from DocumentUpload__c where FeedItem_Id__c In: setFeedItemId and TGF_Internal__c = false];
        setFeedItemIdCCM = new Set<Id>();
        if(lstDocumentUploadCCM.size() > 0) {
            mapIdFeedItemCCM = new Map<Id,FeedItem> ([Select Id,ContentDescription,ContentFileName,body,RelatedRecordId,CreatedDate,CreatedBy.Name From FeedItem Where Id In: setFeedItemId]);
            for(DocumentUpload__c objDocument : lstDocumentUploadCCM) {
                WrapperDocumentUpdload objWrpDocUpload = new WrapperDocumentUpdload();   
                objWrpDocUpload.objDocumentUpload = objDocument;
                objWrpDocUpload.objFeedItem  = mapIdFeedItemCCM.get(objDocument.FeedItem_Id__c);
                lstWrpDocumentUploadCCM.add(objWrpDocUpload);
            }
        }
    }
    
    public void LoadConceptNotes() {
      programSplit = new Program_Split__c();
      conceptNotes = new List<Concept_Note__c>();
      lstWrapConceptNotes = new List<ConceptNote>();
      
      // ************** Conditional Country rendering *******************
      List<Program_Split__c> lstProgramSplit = [Select Id, Name, CurrencyIsoCode, Agreed__c, CCM__c, CCM__r.Country__r.Name, CCM__r.Country__r.French_Name__c , 
          CCM__r.Country__r.Spanish_Name__c , CCM__r.Country__r.Russian_Name__c , Escalated_Review__c, Evidence_of_CCM_Endorsement__c, 
          Global_Fund_Internal_Review_Comments__c, OPS_Submitted__c, Outside_Range__c,Language__c,Show_Revision_Request_Comments__c,
          Rationale_for_Proposed_Split__c, Rationale_for_Proposed_Split_French__c, Rationale_for_Proposed_Split_Russian__c, Rationale_for_Proposed_Split_Spanish__c,
          Rationale_for_Revised_Split__c, Rationale_for_Revised_Split_French__c, Rationale_for_Revised_Split_Russian__c, Rationale_for_Revised_Split_Spanish__c,
          Global_Fund_Revision_Request_Comments__c,Global_Fund_Revision_Request_Comments_Fr__c,Global_Fund_Revision_Request_Comments_Ru__c,Global_Fund_Revision_Request_Comments_Es__c,
          RPS_In_Reject_Status__c, RPS_Requested__c, RPS_Submitted__c, Status__c, Show_Combined_Concept_Note__c,
          Sign_Off_By_FPM__c,Sign_Off_By_FPM__r.Name,Sign_Off_Date_FPM__c,Sign_Off_FPM__c,
          Sign_Off_By_RM_HoD__c,Sign_Off_By_RM_HoD__r.Name,Sign_Off_Date_RM_HoD__c,Sign_Off_RM_HoD__c,
          Sign_Off_By_TAP__c,Sign_Off_By_TAP__r.Name,Sign_Off_Date_TAP__c,Sign_Off_TAP__c 
        from Program_Split__c where Id = :PSId];
      
      if(lstProgramSplit.size() > 0){
          programSplit = lstProgramSplit[0];
          if(lstProgramSplit[0].Language__c == 'FRENCH'){
              strLanguage = 'FRENCH';
              if(programSplit.Global_Fund_Revision_Request_Comments_Fr__c == null || programSplit.Global_Fund_Revision_Request_Comments_Fr__c == '')
                  blnEditGFRevisionReq  = true;
              if(programSplit.Rationale_for_Proposed_Split_French__c == null || programSplit.Rationale_for_Proposed_Split_French__c == '')
                  blnEditCCMOriginal = true;
              if(programSplit.Rationale_for_Revised_Split_French__c == null || programSplit.Rationale_for_Revised_Split_French__c == '')
                  blnEditCCMRevised = true;
          }
          else if(lstProgramSplit[0].Language__c == 'SPANISH'){
              strLanguage = 'SPANISH';
              if(programSplit.Global_Fund_Revision_Request_Comments_Es__c == null || programSplit.Global_Fund_Revision_Request_Comments_Es__c == '')
                  blnEditGFRevisionReq  = true;
              if(programSplit.Rationale_for_Proposed_Split_Spanish__c == null || programSplit.Rationale_for_Proposed_Split_Spanish__c == '')
                  blnEditCCMOriginal = true;
              if(programSplit.Rationale_for_Revised_Split_Spanish__c == null || programSplit.Rationale_for_Revised_Split_Spanish__c == '')
                  blnEditCCMRevised = true;
          }
          else if(lstProgramSplit[0].Language__c == 'RUSSIAN'){
              strLanguage = 'RUSSIAN'; 
              if(programSplit.Global_Fund_Revision_Request_Comments_Ru__c == null || programSplit.Global_Fund_Revision_Request_Comments_Ru__c == '')
                  blnEditGFRevisionReq  = true;
              if(programSplit.Rationale_for_Proposed_Split_Russian__c == null || programSplit.Rationale_for_Proposed_Split_Russian__c == '')
                  blnEditCCMOriginal = true;
              if(programSplit.Rationale_for_Revised_Split_Russian__c == null || programSplit.Rationale_for_Revised_Split_Russian__c == '')
                  blnEditCCMRevised = true;          
          } else {
              strLanguage = 'ENGLISH'; 
              if(programSplit.Global_Fund_Revision_Request_Comments__c == null || programSplit.Global_Fund_Revision_Request_Comments__c == '')
                  blnEditGFRevisionReq  = true; 
              if(programSplit.Rationale_for_Proposed_Split__c == null || programSplit.Rationale_for_Proposed_Split__c == '')
                  blnEditCCMOriginal = true;
              if(programSplit.Rationale_for_Revised_Split__c == null || programSplit.Rationale_for_Revised_Split__c == '')
                  blnEditCCMRevised = true;
          }
          blnDisplay = true;
          if(programSplit.Agreed__c) blnReadOnly = true; 
          if(programSplit.Show_Revision_Request_Comments__c) blnShowRevisionComment = true;
          if(programSplit.RPS_Requested__c) blnRPSRequest  = true;
          if(programSplit.OPS_Submitted__c) blnOPSSubmitted = true;
          if(programSplit.RPS_Submitted__c) blnRPSSubmitted = true;
          if(programSplit.Global_Fund_Internal_Review_Comments__c == null || programSplit.Global_Fund_Internal_Review_Comments__c == '') blnEditGFInternal  = true;
          
          
      //Most program splits include separate HIV and TB concept notes, but as per a country request, it is possible to show the combined note instead.
      if(!programSplit.Show_Combined_Concept_Note__c){    
          conceptNotes = [Select Name, Component__c,Final_Allocation__c,Status__c,
          New_Split__c, Existing_Split__c, Signed__c, Unsigned__c, Original_Proposed_Split__c, Proportion_of_Allocation__c,
          Escalated_Review__c, Revised_Proposed_Split__c, Revised_Split_Range__c, GF_Program_Split_Signoff__c, 
          GF_Program_Split_Signoff_RM_HoD__c, GF_Program_Split_Signoff_TPA__c, CurrencyIsoCode,
          /*new fields*/ Communicated_Allocation_EUR__c, Communicated_Allocation_USD__c, Existing_Funding_at_Allocation_Date_EUR__c, 
          Signed_Undisbursed_Allocation_Date_USD__c, Signed_Undisbursed_Allocation_Date_EUR__c,Program_Split__r.Total_Allocation_USD__c,Program_Split__r.Total_Allocation_EUR__c,
          Agreed_Split_USD__c, Agreed_Split_EUR__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,
          Additional_Funding_Number__c, Additional_Funding_EUR__c, Proportion_of_Proposed_Split__c, Proportion_of_Revised_Split__c, Proportion_of_Agreed_Split__c
          from Concept_Note__c 
          WHERE Program_Split__c = :programSplit.Id AND Component__c != 'Health Systems Strengthening'
          AND Component__c != 'HIV/TB'
          ORDER BY Component__c];
       }else{
           conceptNotes = 
        [Select Name, Component__c,Final_Allocation__c,Status__c,
          New_Split__c, Existing_Split__c, Signed__c, Unsigned__c, Original_Proposed_Split__c, Proportion_of_Allocation__c,
          Escalated_Review__c, Revised_Proposed_Split__c, Revised_Split_Range__c, GF_Program_Split_Signoff__c, 
          GF_Program_Split_Signoff_RM_HoD__c, GF_Program_Split_Signoff_TPA__c, CurrencyIsoCode,
          /*new fields*/ Communicated_Allocation_EUR__c, Communicated_Allocation_USD__c, Existing_Funding_at_Allocation_Date_EUR__c, 
          Signed_Undisbursed_Allocation_Date_USD__c, Signed_Undisbursed_Allocation_Date_EUR__c,
          Agreed_Split_USD__c, Agreed_Split_EUR__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,Program_Split__r.Total_Allocation_USD__c,Program_Split__r.Total_Allocation_EUR__c,
          Additional_Funding_Number__c, Additional_Funding_EUR__c, Component_Code__c, Proportion_of_Proposed_Split__c, Proportion_of_Revised_Split__c, Proportion_of_Agreed_Split__c
          from Concept_Note__c 
          WHERE Program_Split__c = :programSplit.Id AND Component__c != 'Health Systems Strengthening'
          AND Component__c != 'HIV/AIDS'
          AND Component__c != 'Tuberculosis'
          ORDER BY Component_Code__c];   
       }  
          
      List<Concept_Note__c> lstHSS = [Select Name, Component__c,Final_Allocation__c,Status__c, 
          New_Split__c, Existing_Split__c, Signed__c, Unsigned__c, Original_Proposed_Split__c, Proportion_of_Allocation__c,
          Escalated_Review__c, Revised_Proposed_Split__c, Revised_Split_Range__c, GF_Program_Split_Signoff__c,
          GF_Program_Split_Signoff_RM_HoD__c, GF_Program_Split_Signoff_TPA__c, CurrencyIsoCode,
          /*new fields*/ Communicated_Allocation_EUR__c, Communicated_Allocation_USD__c, Existing_Funding_at_Allocation_Date_EUR__c, 
          Signed_Undisbursed_Allocation_Date_USD__c, Signed_Undisbursed_Allocation_Date_EUR__c,Program_Split__r.Total_Allocation_USD__c,Program_Split__r.Total_Allocation_EUR__c,
          Agreed_Split_USD__c, Agreed_Split_EUR__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,
          Additional_Funding_Number__c, Additional_Funding_EUR__c, Proportion_of_Proposed_Split__c, Proportion_of_Revised_Split__c, Proportion_of_Agreed_Split__c
          from Concept_Note__c 
          WHERE Program_Split__c = :programSplit.Id AND Component__c = 'Health Systems Strengthening'
          AND Open__c = true];
        if(!lstHSS.isEmpty()){
            conceptNotes.addAll(lstHSS); }
            
      /*List<AggregateResult> lstSignedAmount = [Select Grant__r.Disease_Component__c component, SUM(Signed_Amount_USD__c) signedAmountUSD, SUM(Signed_Amount_EUR__c) signedAmountEUR
                                               from Implementation_Period__c WHERE Start_Date__c >= :allocationDate AND Grant__r.Country__c = :programSplit.CCM__r.Country__c
                                               GROUP BY Grant__r.Disease_Component__c];*/
                                               
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
            Decimal unsignedAmount = 0;
            /*Decimal unsignedAmount = objCon.Existing_Split__c;
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
          }*/
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
     
     public void UpdateGFComments() {
         Program_Split__c ps = new Program_Split__c();
         ps.Id = PSId;
         ps.Global_Fund_Internal_Review_Comments__c  = programSplit.Global_Fund_Internal_Review_Comments__c;
         update ps; 
         if(blnEditGFInternal) 
             blnEditGFInternal = false;
     }
     
     public void UpdateRationalProposedSplit() {
         Program_Split__c ps = new Program_Split__c();
         ps.Id = PSId;
         if(strLanguage == 'FRENCH')
             ps.Rationale_for_Proposed_Split_French__c  = programSplit.Rationale_for_Proposed_Split_French__c;
         if(strLanguage == 'SPANISH')
             ps.Rationale_for_Proposed_Split_Spanish__c  = programSplit.Rationale_for_Proposed_Split_Spanish__c;
         if(strLanguage == 'RUSSIAN')
             ps.Rationale_for_Proposed_Split_Russian__c  = programSplit.Rationale_for_Proposed_Split_Russian__c;
         if(strLanguage=='ENGLISH' || strLanguage=='')
             ps.Rationale_for_Proposed_Split__c  = programSplit.Rationale_for_Proposed_Split__c;
          System.debug('Inside UpdateRationalProposedSplit PS list***'+ps);
         update ps;
         if(blnEditCCMOriginal)
             blnEditCCMOriginal  = false;
     }
     
     public void UpdateRationalRequestSplit() {
         Program_Split__c ps = new Program_Split__c();
         ps.Id = PSId;
         /*Commented for Program Split User Story
         if(strLanguage == 'FRENCH')
             ps.Global_Fund_Revision_Request_Comments_Fr__c  = programSplit.Global_Fund_Revision_Request_Comments_Fr__c;
         if(strLanguage == 'SPANISH')
             ps.Global_Fund_Revision_Request_Comments_Es__c = programSplit.Global_Fund_Revision_Request_Comments_Es__c;
         if(strLanguage == 'RUSSIAN')
             ps.Global_Fund_Revision_Request_Comments_Ru__c  = programSplit.Global_Fund_Revision_Request_Comments_Ru__c;
         if(strLanguage=='ENGLISH' || strLanguage=='')
             ps.Global_Fund_Revision_Request_Comments__c  = programSplit.Global_Fund_Revision_Request_Comments__c;*/
             if(strLanguage == 'FRENCH')
             ps.Rationale_for_Revised_Split_French__c  = programSplit.Rationale_for_Revised_Split_French__c;
         if(strLanguage == 'SPANISH')
             ps.Rationale_for_Revised_Split_Spanish__c = programSplit.Rationale_for_Revised_Split_Spanish__c;
         if(strLanguage == 'RUSSIAN')
             ps.Rationale_for_Revised_Split_Russian__c  = programSplit.Rationale_for_Revised_Split_Russian__c;
         if(strLanguage=='ENGLISH' || strLanguage=='')
             ps.Rationale_for_Revised_Split__c  = programSplit.Rationale_for_Revised_Split__c;
         System.debug('Inside UpdateRationalRequestSplit PS list***'+ps);
         update ps; 
         /*Commented for Program Split User Story
         if(blnEditGFRevisionReq)
             blnEditGFRevisionReq = false;*/
             if(blnEditCCMRevised)
             blnEditCCMRevised = false;
     }
     
     public void UpdateRationalRevisedSplit() {
         Program_Split__c ps = new Program_Split__c();
         ps.Id = PSId;
         /*Commented for Program Split User Story
         if(strLanguage == 'FRENCH')
             ps.Rationale_for_Revised_Split_French__c  = programSplit.Rationale_for_Revised_Split_French__c;
         if(strLanguage == 'SPANISH')
             ps.Rationale_for_Revised_Split_Spanish__c = programSplit.Rationale_for_Revised_Split_Spanish__c;
         if(strLanguage == 'RUSSIAN')
             ps.Rationale_for_Revised_Split_Russian__c  = programSplit.Rationale_for_Revised_Split_Russian__c;
         if(strLanguage=='ENGLISH' || strLanguage=='')
             ps.Rationale_for_Revised_Split__c  = programSplit.Rationale_for_Revised_Split__c;*/
             if(strLanguage == 'FRENCH')
             ps.Global_Fund_Revision_Request_Comments_Fr__c  = programSplit.Global_Fund_Revision_Request_Comments_Fr__c;
         if(strLanguage == 'SPANISH')
             ps.Global_Fund_Revision_Request_Comments_Es__c = programSplit.Global_Fund_Revision_Request_Comments_Es__c;
         if(strLanguage == 'RUSSIAN')
             ps.Global_Fund_Revision_Request_Comments_Ru__c  = programSplit.Global_Fund_Revision_Request_Comments_Ru__c;
         if(strLanguage=='ENGLISH' || strLanguage=='')
             ps.Global_Fund_Revision_Request_Comments__c  = programSplit.Global_Fund_Revision_Request_Comments__c;
         update ps; 
         /*Commented for Program Split User Story
         if(blnEditCCMRevised)
             blnEditCCMRevised = false;*/
             if(blnEditGFRevisionReq)
             blnEditGFRevisionReq = false;
             
     }
     
     Public void uploadDocument(){
        
        System.debug('in Upload objFeedItem    ,,,,, objDocumentUpload :'+objFeedItem +'---'+objDocumentUpload );
        System.debug('blnTGFInternal ::: ' + blnTGFInternal);
        if(objFeedItem != null){
            objFeedItem.ContentDescription = 'Other Document'; 
            insert objFeedItem;
            if(objDocumentUpload != null) {
                objDocumentUpload.FeedItem_Id__c = objFeedItem.ID;
                objDocumentUpload.Process_Area__c = 'Concept Note';
               // objDocumentUpload.Concept_Note__c = CNId;
                objDocumentUpload.Program_Split__C = PSId;
                objDocumentUpload.TGF_Internal__c = true;
                insert objDocumentUpload;
            }
        }
        System.debug('objFeedItem  Id::: ' + objFeedItem.ID + ' objDocumentUpload Id ::: '+objDocumentUpload);
        LoadDocuments();
    }
    
    public void CancelRationaleforRequesting() {
        List<Program_Split__c> lstProgramSplit = [Select Id, Name,Global_Fund_Revision_Request_Comments__c,Global_Fund_Revision_Request_Comments_Fr__c,
              Global_Fund_Revision_Request_Comments_Ru__c,Global_Fund_Revision_Request_Comments_Es__c
        from Program_Split__c where Id = : PSId];
        if(strLanguage == 'FRENCH')
             programSplit.Global_Fund_Revision_Request_Comments_Fr__c  = lstProgramSplit[0].Global_Fund_Revision_Request_Comments_Fr__c;
        if(strLanguage == 'SPANISH')
             programSplit.Global_Fund_Revision_Request_Comments_Es__c = lstProgramSplit[0].Global_Fund_Revision_Request_Comments_Es__c;
        if(strLanguage == 'RUSSIAN')
             programSplit.Global_Fund_Revision_Request_Comments_Ru__c  = lstProgramSplit[0].Global_Fund_Revision_Request_Comments_Ru__c;
        if(strLanguage=='ENGLISH' || strLanguage=='')
             programSplit.Global_Fund_Revision_Request_Comments__c  = lstProgramSplit[0].Global_Fund_Revision_Request_Comments__c;
    }
    
    public void CancelGlobalFundComments() {
        List<Program_Split__c> lstProgramSplit = [Select Id, Name,Global_Fund_Internal_Review_Comments__c
        from Program_Split__c where Id = : PSId];  
        programSplit.Global_Fund_Internal_Review_Comments__c  = lstProgramSplit[0].Global_Fund_Internal_Review_Comments__c;
    }
    
    public void CancelRationaleforProposed() {
        List<Program_Split__c> lstProgramSplit = [Select Id, Name,Rationale_for_Proposed_Split_French__c,Rationale_for_Proposed_Split_Spanish__c,
              Rationale_for_Proposed_Split_Russian__c,Rationale_for_Proposed_Split__c
        from Program_Split__c where Id = : PSId];
        if(strLanguage == 'FRENCH')
             programSplit.Rationale_for_Proposed_Split_French__c  = lstProgramSplit[0].Rationale_for_Proposed_Split_French__c;
        if(strLanguage == 'SPANISH')
             programSplit.Rationale_for_Proposed_Split_Spanish__c = lstProgramSplit[0].Rationale_for_Proposed_Split_Spanish__c;
        if(strLanguage == 'RUSSIAN')
             programSplit.Rationale_for_Proposed_Split_Russian__c  = lstProgramSplit[0].Rationale_for_Proposed_Split_Russian__c;
        if(strLanguage=='ENGLISH' || strLanguage=='')
             programSplit.Rationale_for_Proposed_Split__c  = lstProgramSplit[0].Rationale_for_Proposed_Split__c;
    }
    
    public void CancelRationaleforRevised() {
        List<Program_Split__c> lstProgramSplit = [Select Id, Name,Rationale_for_Revised_Split_French__c,Rationale_for_Revised_Split_Spanish__c,
              Rationale_for_Revised_Split_Russian__c,Rationale_for_Revised_Split__c
        from Program_Split__c where Id = : PSId];
        if(strLanguage == 'FRENCH')
             programSplit.Rationale_for_Revised_Split_French__c  = lstProgramSplit[0].Rationale_for_Revised_Split_French__c;
        if(strLanguage == 'SPANISH')
             programSplit.Rationale_for_Revised_Split_Spanish__c = lstProgramSplit[0].Rationale_for_Revised_Split_Spanish__c;
        if(strLanguage == 'RUSSIAN')
             programSplit.Rationale_for_Revised_Split_Russian__c  = lstProgramSplit[0].Rationale_for_Revised_Split_Russian__c;
        if(strLanguage=='ENGLISH' || strLanguage=='')
             programSplit.Rationale_for_Revised_Split__c  = lstProgramSplit[0].Rationale_for_Revised_Split__c;
    }
    
    Public void uploadDocumentCCM(){
        
        System.debug('in Upload objFeedItem    ,,,,, objDocumentUpload :'+objFeedItem +'---'+objDocumentUpload );
        System.debug('blnTGFInternal ::: ' + blnTGFInternal);
        if(objFeedItem != null){
            objFeedItem.ContentDescription = 'Other Document'; 
            objFeedItem.Visibility = 'AllUsers';
            insert objFeedItem;
            if(objDocumentUpload != null) {
                objDocumentUpload.FeedItem_Id__c = objFeedItem.ID;
                objDocumentUpload.Process_Area__c = 'Concept Note';
              //  objDocumentUpload.Concept_Note__c = CNId;
                objDocumentUpload.TGF_Internal__c = false;
                objDocumentUpload.Program_Split__C = PSId;
                insert objDocumentUpload;
            }
        }
        System.debug('objFeedItem  Id::: ' + objFeedItem.ID + ' objDocumentUpload Id ::: '+objDocumentUpload.Id);
        LoadDocuments();
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
     
     public void QuickSave() {
         Save();
         LoadConceptNotes();
         //return null;  
     }
         
     public void changeView() {
         Save();
         if(blnGFInternal) {
             blnGFInternal = false; }
         else if(!blnGFInternal) {
             blnGFInternal = true; } 
        LoadConceptNotes();
        //return null;
     }
     
     public void uncheckSignoff(){
       for(Concept_Note__c objcon : conceptNotes){
              objCon.GF_Program_Split_Signoff__c = false;
              objCon.GF_Program_Split_Signoff_RM_HoD__c = false;
              objCon.GF_Program_Split_Signoff_TPA__c = false;
              programSplit.Sign_Off_FPM__c = false;
              programSplit.Sign_Off_RM_HoD__c = false;
              programSplit.Sign_Off_TAP__c = false;
       }     
     }
     
     public void EscalateReview() {
        if(programSplit.Escalated_Review__c == 'Not Elevated'){
          programSplit.Escalated_Review__c = 'Elevated by Country Team'; }
        uncheckSignoff();
        Save();
        LoadConceptNotes();
        //return null;
     }
     
    public void SubmitProposedSplit() {     
        Decimal OPSTotal = 0;
        Decimal RPSTotal = 0;
        Boolean passed = false;
        String submissionPhase = '';
        uncheckSignoff();
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
        //return null;
    }
     
     
     public void RequestRPS() {
        //Commented for Program Split User Story
        //if(!programSplit.Show_Revision_Request_Comments__c && (programSplit.Rationale_for_Revised_Split__c!='' && programSplit.Rationale_for_Revised_Split__c!=null)){
        if(!programSplit.Show_Revision_Request_Comments__c) {
            programSplit.Show_Revision_Request_Comments__c = true; 
        }
        if(programSplit.Show_Revision_Request_Comments__c && (programSplit.Global_Fund_Revision_Request_Comments__c!='' && programSplit.Global_Fund_Revision_Request_Comments__c!=null)) {
            if(!programSplit.RPS_Requested__c){
                programSplit.RPS_Requested__c = true;                      
            }
        }
        system.debug('Save:Failed ');
        uncheckSignoff();
        Save();
        LoadConceptNotes();
        //return null;
     }
     
     public void submitSignoffFPM(){
         programSplit.Sign_Off_FPM__c = true;
         programSplit.Sign_Off_By_FPM__c = System.UserInfo.getUserId();
         programSplit.Sign_Off_Date_FPM__c = System.today();
         Save();
         SetAgreedSplit();
         LoadConceptNotes();
         //return null;
     }
     public void submitSignoffRM_HoD(){
         programSplit.Sign_Off_RM_HoD__c = true;
         programSplit.Sign_Off_By_RM_HoD__c = System.UserInfo.getUserId();
         programSplit.Sign_Off_Date_RM_HoD__c = System.today();
         Save();
         SetAgreedSplit();
         LoadConceptNotes();
         //return null;
     }
     public void submitSignoffTAP(){
         programSplit.Sign_Off_TAP__c = true;
         programSplit.Sign_Off_By_TAP__c = System.UserInfo.getUserId();
         programSplit.Sign_Off_Date_TAP__c = System.today();
         Save();
         SetAgreedSplit();
         LoadConceptNotes();
         //return null;       
     }
     
     public void SetAgreedSplit() {
        //This section modified by Matthew Miller on 9/6/2014 to automate setting of Agreed Split for combined concept note
        Decimal decSplitTB;
        Decimal decSplitHIV;
           
        /*if(programSplit.Outside_Range__c == 'Issue' && programSplit.Global_Fund_Internal_Review_Comments__c == null){      
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Program_Split_Notes_Outside_Range));
        }*/
        //else{
        /*Integer count = 0;
        for(Concept_Note__c CN : conceptNotes){
            if(!escalatedReview && CN.GF_Program_Split_Signoff__c){
                count++; }
            else if(escalatedReview && CN.GF_Program_Split_Signoff_RM_HoD__c && CN.GF_Program_Split_Signoff_TPA__c){
                count++; }
         }*/
        //if(count == conceptNotes.size()){
        if((!escalatedReview && programSplit.Sign_Off_FPM__c)||(escalatedReview && programSplit.Sign_Off_RM_Hod__c && programSplit.Sign_Off_TAP__c)){     
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
               
               List<Concept_Note__c> lstCombinedCN = [Select Id, Agreed_Split_USD__c, Agreed_Split_EUR__c, CurrencyIsoCode from Concept_Note__c 
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
        //QuickSave();
        Save();
        //switchText();
        /*Integer decision = -1;
        decision = checkforPS();
        system.debug('Decision:' +decision);
        if (decision == 0)           
            RMSignOff = 'Yes';
        if (decision == 1)
            TPASignOff = 'Yes';  */     
      }
    
     //}
     
     public void RejectRevisedSplit() {
        programSplit.RPS_Submitted__c = false;
        programSplit.RPS_In_Reject_Status__c = true;
        uncheckSignoff();
        Save();
        LoadConceptNotes();
        //return null;
     }
     
     public pageReference UploadFile() {
         Save();
         return new pageReference('/p/attach/NoteAttach?pid=' + programSplit.Id + '&retURL=%2Fapex%2FCNProgramSplit?id=' + programSplit.Id + '%26CNId=' + CNId);  
     }
         
     public void removeRow() {
         if(attachmentIdToDelete != NULL){
             delete [Select Id from Attachment where Id =:attachmentIdToDelete];
             lstAttachment = [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :programSplit.Id];
         }
     }
        //TCS changes for sign_off validation begins  
        /*@RemoteAction           
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
        }*/
        
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
        
         Public void DeleteFile(){        
            if(DeleteIndex != null){
                WrapperDocumentUpdload objWrpDocUpload = lstWrpDocumentUpload[DeleteIndex];
                if(objWrpDocUpload != null){
                    if (objWrpDocUpload.objDocumentUpload != null) {
                        List<DocumentUpload__c> lstDocumentUploadToDelete = [Select Id From DocumentUpload__c Where Id =: objWrpDocUpload.objDocumentUpload.Id];
                        if(lstDocumentUploadToDelete != null && lstDocumentUploadToDelete.size() > 0) {
                            delete lstDocumentUploadToDelete;
                        }
                    }
                    
                    if(objWrpDocUpload.objFeedItem != null) {
                        List<FeedItem> lstFeedItemToDelete = [Select Id From FeedItem Where Id =: objWrpDocUpload.objFeedItem.Id];
                        if(lstFeedItemToDelete.size() > 0 && lstFeedItemToDelete != null){
                            Delete lstFeedItemToDelete;
                        }
                    }
                    
                    lstWrpDocumentUpload.remove(DeleteIndex);
                }
            }
        } 
        
        Public void DeleteFileCCM(){        
            if(DeleteIndexCCM != null){
                WrapperDocumentUpdload objWrpDocUpload = lstWrpDocumentUploadCCM[DeleteIndexCCM];
                if(objWrpDocUpload != null){
                    if (objWrpDocUpload.objDocumentUpload != null) {
                        List<DocumentUpload__c> lstDocumentUploadToDelete = [Select Id From DocumentUpload__c Where Id =: objWrpDocUpload.objDocumentUpload.Id];
                        if(lstDocumentUploadToDelete != null && lstDocumentUploadToDelete.size() > 0) {
                            delete lstDocumentUploadToDelete;
                        }
                    }
                    
                    if(objWrpDocUpload.objFeedItem != null) {
                        List<FeedItem> lstFeedItemToDelete = [Select Id From FeedItem Where Id =: objWrpDocUpload.objFeedItem.Id];
                        if(lstFeedItemToDelete.size() > 0 && lstFeedItemToDelete != null){
                            Delete lstFeedItemToDelete;
                        }
                    }                    
                    lstWrpDocumentUploadCCM.remove(DeleteIndexCCM);
                }
            }
        } 
        
        //Beginning of new permission set checking method -- Matthew Miller, 2014-07-17
   /* TCS 15/09/2014: Covering Permission sets in checkProfile function */
   /* Public void checkPermissionSets(){
            String pSet_FPM = '';
            String pSet_RM_HoD = '';
            String pSet_TAP = '';
            
            for(PermissionSet pSet : [Select Id, Name from PermissionSet]){
                if(pSet.Name == 'Program_Split_FPM_Signoff') pSet_FPM = pSet.Id;
                if(pSet.Name == 'Program_Split_RM_HoD_Signoff') pSet_RM_HoD = pSet.Id;
                if(pSet.Name == 'Program_Split_TPA_Signoff') pSet_TAP = pSet.Id;
            }
            
            
            for (PermissionSetAssignment PS1 : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :pset_FPM]) {
                system.debug('user in FPM'+userId);    
                    system.debug('assign in FPM'+PS1.AssigneeId);    
                 if(PS1.AssigneeId == userId){                 
                     blnHasPermissionSetFPM = true;
                     break;
                 }
             }
             for (PermissionSetAssignment PS2 : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :pSet_RM_HoD]) {
                system.debug('user in RM'+userId);    
                    system.debug('assign in RM'+PS2.AssigneeId);    
                 if(PS2.AssigneeId == userId){                 
                     blnHasPermissionSetRMHoD = true;
                     break;
                 }
            }
            for (PermissionSetAssignment PS3 : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = : pSet_TAP]) {
                system.debug('user in RM'+userId);    
                    system.debug('assign in RM'+PS3.AssigneeId);    
                 if(PS3.AssigneeId == userId){                 
                     blnHasPermissionSetTAP = true;
                     break;
                 }
             }
         } */

             
        //Wrapper class
        Public class WrapperDocumentUpdload { 
            Public DocumentUpload__c objDocumentUpload {get; set;} 
            Public FeedItem objFeedItem {get; set;} 
            public WrapperDocumentUpdload() {
                objDocumentUpload = new DocumentUpload__c();
                objFeedItem = new FeedItem();
            }
        }
        
        public void sortByItem() {    
            togglebit = true;
            mapForSort = new map <Integer,String> ();
            mapForSortFeed = new map <Integer,String> ();
                mapForSortFeed.put(1,'');
                mapForSort.put(2,'TGF_Internal__c');
                mapForSortFeed.put(3,'');
                mapForSort.put(4,'Type__c');
                mapForSort.put(5,'Language__c');
                mapForSortFeed.put(6,'');
                mapForSortFeed.put(7,'');                
                
            String Query = 'Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name, TGF_Internal__c from DocumentUpload__c where Concept_Note__c =: CNId and TGF_Internal__c = true order by';
            String sortString  = mapForSort.get(sortItem);
            if(togglebit) {
            Query += ' ' + sortString + ' asc';
            togglebit = false; }
            else {
            Query += ' ' + sortString + ' desc';
            togglebit = true; }
            system.debug('sortItem: ' +sortItem+ 'sortString: '+sortString+'Query: '+Query);    
            lstDocumentUpload = new List<DocumentUpload__c>();
            lstDocumentUpload = Database.Query(Query);    
            system.debug('lstDocumentUpload: '+lstDocumentUpload);
            lstWrpDocumentUpload.clear();
            for(DocumentUpload__c objDocument : lstDocumentUpload) {
                                WrapperDocumentUpdload objWrpDocUpload = new WrapperDocumentUpdload();   
                                objWrpDocUpload.objDocumentUpload = objDocument;
                                objWrpDocUpload.objFeedItem  = mapIdFeedItem.get(objDocument.FeedItem_Id__c);
                                lstWrpDocumentUpload.add(objWrpDocUpload);
                }               
          }    
        
          public void sortByItemCCM() {    
            togglebitCCM = true;
            mapForSortCCM = new map <Integer,String> ();
            mapForSortFeedCCM = new map <Integer,String> ();
                mapForSortFeedCCM.put(1,'');
                mapForSortCCM.put(2,'TGF_Internal__c');
                mapForSortFeedCCM.put(3,'');
                mapForSortCCM.put(4,'Type__c');
                mapForSortCCM.put(5,'Language__c');
                mapForSortFeedCCM.put(6,'');
                mapForSortFeedCCM.put(7,'');                
            
            String Query = 'Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name, TGF_Internal__c from DocumentUpload__c where Concept_Note__c =: CNId and TGF_Internal__c= false  order by';
            String sortString  = mapForSortCCM.get(sortItemCCM);
            if(togglebitCCM) {
            Query += ' ' + sortString + ' asc';
            togglebitCCM = false; }
            else {
            Query += ' ' + sortString + ' desc';
            togglebitCCM = true; }
            lstDocumentUploadCCM = Database.Query(Query);    
            lstWrpDocumentUploadCCM.clear();
            for(DocumentUpload__c objDocument : lstDocumentUploadCCM) {
                                WrapperDocumentUpdload objWrpDocUpload = new WrapperDocumentUpdload();   
                                objWrpDocUpload.objDocumentUpload = objDocument;
                                objWrpDocUpload.objFeedItem  = mapIdFeedItem.get(objDocument.FeedItem_Id__c);
                                lstWrpDocumentUpload.add(objWrpDocUpload);
                }               
          }          
        /*public integer checkforPS () { //Checks for permission set to which user is assigned to         
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
        }*/
 
        //TCS changes for sign_off validation ends
        
      //TCS 11/09/2014 Added for giving Permission based on profile 
     public void checkProfile(){
        blnExternalPro=false;
        blnQuickSave=false;
        blnSaveReturn=false;
        blnIntGFComment=false;
        blnUploadGFInternal=false;
        blnCCMEndorsement=false;
        blnUploadCCMView=false;
        blnSubmitSignOff=false;
        blnReqRevisedSplit=false;
        blnSaveChangeView=false;
        blnGFInternal=false;
        blnDownloadLinkGF=false;
        blnDeleteCCMDoc=false;
        blnRationalCCM=false;
        blnSndElevatedReview = false;
        
        
         for(Concept_Note__c CN : [Select Status__c,Name from Concept_Note__c where Program_Split__c =: PSId limit 1]){
            system.debug('CN '+CN);
            strStatus = CN.Status__c;
            system.debug('Status '+strStatus +' Name '+CN.Status__c);
         }
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Id, PermissionSet.Name, PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CNProgramSplit' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets)];
        system.debug('Query Result '+checkpage.size());
      for (Profile_Access_Setting_CN__c check : checkpage){
        system.debug('Salesforce Item '+check.Salesforce_Item__c);
        system.debug('CNStatus '+strStatus);
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Quick Save' && check.Status__c== strStatus)blnQuickSave = true;
        if(check.Salesforce_Item__c == 'Save and Return' && check.Status__c== strStatus)blnSaveReturn = true;
        if(check.Salesforce_Item__c == 'Internal GF Review Comment' && check.Status__c== strStatus)blnIntGFComment = true;
        if(check.Salesforce_Item__c == 'Upload Doc GF Internal View' && check.Status__c== strStatus)blnUploadGFInternal = true;
        if(check.Salesforce_Item__c == 'Evidence of CCM Endorsement' && check.Status__c== strStatus)blnCCMEndorsement = true;
        if(check.Salesforce_Item__c == 'Upload Doc CCM View' && check.Status__c== strStatus)blnUploadCCMView = true;
        if(check.Salesforce_Item__c == 'Submit Signoff') blnSubmitSignOff = true;
        if(check.Salesforce_Item__c == 'Request Revised Split') blnReqRevisedSplit = true;
        if(check.Salesforce_Item__c == 'Save Change View') blnSaveChangeView = true;
        if(check.Salesforce_Item__c == 'GF Internal') blnGFInternal = true;
        if(check.Salesforce_Item__c == 'Individual Download Link') blnDownloadLinkGF = true;
        if(check.Salesforce_Item__c == 'Delete CCM View Doc') blnDeleteCCMDoc = true;
        if(check.Salesforce_Item__c == 'Rationale CCM') blnRationalCCM = true;
        if(check.Salesforce_Item__c == 'Submit Proposed Split') blnSubPrgSplit = true;
        if(check.Salesforce_Item__c == 'Send To Elevated Review') blnSndElevatedReview = true;
        if(check.Salesforce_Item__c == 'Rationale for Revised Proposed Split') blnCCMRevised = true;
        
        //if(check.Salesforce_Item__c == 'Rationale for Proposed Split' && check.Status__c== strStatus) blnRationaleProposed = true;
        if(check.Salesforce_Item__c == 'GF Reasons for Requesting Revised Split') blnGFReqRevSplit = true;
        }
        system.debug('blnSubmitSignOff '+blnSubmitSignOff );
    }
   
}