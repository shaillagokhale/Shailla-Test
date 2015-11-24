Public with sharing Class ctrlCNOverview{
    public Concept_Note__c objCN {get;set;}
    public String strCNId {get;set;}
    public id idCNId {get;set;}
    Public String strGuidanceId {get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public List<Module__c> lstModules {get;set;}
    Public List<Module__c> lstModulesPG {get;set;}
    Public List<CPF_Report__c> lstCPF {get;set;}
    Public List<String> lstSubItem{get;set;}
    Public List<String> lstDocMissing {get;set;}
    Public String selectLikli{get;set;}
    Public String strSelectSubDateAccess{get;set;}
    Public String strCPFId {get;set;}
    Public Boolean blnExpandSection {get;set;}
    Public List<BLModule> lstBLModule {get;set;}
    Public Integer TotalModuleY1CostA {get;set;}
    Public Integer TotalModuleY2CostA {get;set;}
    Public Integer TotalModuleY3CostA {get;set;}
    Public Integer TotalModuleY4CostA {get;set;}
    Public Integer AllYearModuleTotalCostA  {get;set;}
    Public Integer AllYearModuleTotalCostI  {get;set;}
    Public Integer TotalModuleY1CostI {get;set;}
    Public Integer TotalModuleY2CostI {get;set;}
    Public Integer TotalModuleY3CostI {get;set;}
    Public Integer TotalModuleY4CostI {get;set;}
    Public List<Concept_Note__c> lstCN;//Changes done on 22nd dec
    Public List<TRPIterationSubmission__c> lstTrpSubmissionDate;//Changes done on 22nd dec
    Public List<SelectOption> submissionDate {get;set;}
    Public List<SelectOption> submissionDateTRP {get;set;}//Added on 22nd Dec
    Public String strTrpRelDate {get;set;}
    Public String strTrpRevDate {get;set;}//Changes done on 22nd dec
    Public List<BLModulePR> lstBLModulePR {get;set;}
    Public Integer TotalPRY1CostA {get;set;}
    Public Integer TotalPRY2CostA {get;set;}
    Public Integer TotalPRY3CostA {get;set;}
    Public Integer TotalPRY4CostA {get;set;}
    Public Integer AllYearPRTotalCostA  {get;set;}
    Public Integer AllYearPRTotalCostI  {get;set;}
    Public Integer TotalPRY1CostI {get;set;}
    Public Integer TotalPRY2CostI {get;set;}
    Public Integer TotalPRY3CostI {get;set;}
    Public Integer TotalPRY4CostI {get;set;}
    Public Boolean blnDraftStatusExist {get;set;}
    Public Boolean blnReadOnly {get;set;}
    Public Boolean TRPSubmitted{get;set;}
    Public String strSelectSubDate{get;set;}
    Public String strSelectSubDateIteration{get;set;}//Change done on 22nd Dec
    Public Boolean blnChangeLanguage {get;set;}//Change done on 22nd Dec
    public string strLanguage {get;set;}
    Public string strCNType {get;set;}
    Public string strCTRSubitem{get;set;}
    public string strname{get;set;}//recently added
    //TCS 09/09/2014: Variables for Profile Access
    Public Boolean blnExternalPro {get;set;}
    Public Boolean blnRegisterToTRP {get;set;}
    Public Boolean blnSubmitCN  {get;set;}
    Public Boolean blnFinalCTReview {get;set;}
    Public Boolean blnAccessLikehood {get;set;}
    Public Boolean blnChangeSubmissionDate {get;set;}
    //------added for CN unlock, rollback----------------
    /*
    Public Boolean btnRequestCNunlock {get;set;}
    Public Boolean btnCNunlockRequested {get;set;}
    Public Boolean btnUnlockCN {get;set;}
    Public Boolean btnRollbackCN {get;set;}
    Public Boolean RequestCNunlock {get;set;}
    Public Boolean CNrollbackdone {get;set;}
    Public Boolean unlockedIntegratedView {get;set;}
    */
    //---------------------------------------------------
    public String strStatus ;
    
    Public DocumentUpload__c objDocumentUpload {get;set;}
    transient Public FeedItem objFeedItem {get;set;} 
    
    Public string CNName ;
    Public boolean hasFinalDoc {get;set;}
    
    
  


    public ctrlCNOverview(ApexPages.StandardController controller) {
        
        //blnReadOnly = CheckProfile.checkProfile();  -- commented out by Matthew Miller 23/5/2014
        strCNId = Apexpages.currentpage().getparameters().get('id');
        idCNId = Apexpages.currentpage().getparameters().get('id');
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Concept Note Overview'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
        /*-------------START--------------Commented for CN Rollback/ Unlock-----------------------*/
        //lstCN = [Select Id, Name, Status__c,Concept_Note_Submission_Date__c,Revised_Submission_Date__c,Justification__c,CT_Submission_Date__c,Assess_Submission_Date__c,CCM_Proposed_Date__c,Likelihood__c,Language__c,TRP_Submission_Review_Date__c ,TRP_Submission_Language__c, Actual_Submission_Date__c,Concept_Note_Type__c,Component__c,Date_of_TRP_Review__c,Request_CN_Unlock__c,Revised_Submission_Date_Format__c,Rollback_CN__c,Unlocked_Integrated_View__c,CN_Unlock_Request_Accepted_Rejected__c,Request_language_change__c,CN_Iteration_Submission_Date__c  from Concept_Note__c where Id = :strCNId];
        /*-------------FINISH--------------Commented for CN Rollback/ Unlock-----------------------*/
        lstCN = [Select Id, Name, Status__c,Concept_Note_Submission_Date__c,Revised_Submission_Date__c,Justification__c,CT_Submission_Date__c,Assess_Submission_Date__c,CCM_Proposed_Date__c,Likelihood__c,Language__c,TRP_Submission_Review_Date__c ,TRP_Submission_Language__c, Actual_Submission_Date__c,Concept_Note_Type__c,Component__c,Date_of_TRP_Review__c,Request_language_change__c,CN_Iteration_Submission_Date__c  from Concept_Note__c where Id = :strCNId];
        CNName = lstCN[0].Name;
        strStatus =lstCN[0].Status__c;
        if(lstCN.size() > 0){
            objCN = lstCN[0];
            strCNtype = lstCN[0].Concept_Note_Type__c;
            strStatus =lstCN[0].Status__c;
            
            /*-------START---------Commneted for CN Unlock/rollback---------
            if(lstCN[0].Request_CN_Unlock__c == false){
                RequestCNunlock = false;
            }
            else {
                RequestCNunlock = true;
            }
            if(lstCN[0].Rollback_CN__c == false){
                CNrollbackdone = false;
            }
            else{
                CNrollbackdone = true;
            } 
            if(lstCN[0].Unlocked_Integrated_View__c == false){
                unlockedIntegratedView = false;
            }
            else{
                unlockedIntegratedView = true;
            }
            -------FINISH---------Commneted for CN Unlock/rollback---------*/
            
            //TCS 10/09/2014 Profile Access Setting
          /*  if(lstCN[0].Status__c == 'Submitted to the Global Fund' && CheckProfile.checkProfileGF()==false){
                blnReadOnly = true;
            }else{
                blnReadOnly = CheckProfile.checkProfile();
            }*/
            checkProfile();//TCS 10/09/2014 Profile Access Setting
        }
        
        //if(objCN.Date_of_TRP_Review__c != NULL)
        
        lstPages = [Select Id,Name,French_Name__c,Russian_Name__c,Spanish_Name__c,URL_Prefix__c,Order__c,Modular__c,Status__c,PR_Comments__c,LFA_Comments__c,CT_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_CT_Comment__c From Page__c Where Concept_Note__c =: strCNID Order by Order__c];
        /*lstModules = [Select Id,Name from Module__c where Concept_Note__c =: strCNId];
        lstModulesPG = [Select Id,Name from Module__c where Concept_Note__c =: strCNId and Catalog_Module__r.Available_for_Programmatic_Gap__c = true];
        
        lstCPF = new List<CPF_Report__c>(); 
        lstCPF = [Select Id from CPF_Report__c where Concept_Note__C =: strCNId Limit 1];
        if(lstCPF!=null && lstCPF.size()>0){
            strCPFId = lstCPF[0].Id;
        }*/     
         
         List<AggregateResult> lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.Name Modulename,
                            Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                            Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                            Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                            WHERE CN_Intervention__r.Module_rel__r.concept_Note__c =: strCNId 
                            Group By CN_Intervention__r.Module_rel__r.Name];
                           
         List<AggregateResult> lstGrantIntervantionPR = [Select Implementation_Period__r.Principal_Recipient__r.Name Modulename,
                            Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                            Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                            Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                            WHERE CN_Intervention__r.Module_rel__r.concept_Note__c =: strCNId  
                            Group By Implementation_Period__r.Principal_Recipient__r.Name ];
                            
       
         if(System.UserInfo.getLanguage() == 'fr'){
                            system.debug('getting into french loop'+ System.UserInfo.getLanguage());
         
                            lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.French_Name__c Modulename,
                            Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                            Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                            Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                            WHERE CN_Intervention__r.Module_rel__r.concept_Note__c =: strCNId  
                            Group By CN_Intervention__r.Module_rel__r.French_Name__c];
                            
                            system.debug('lstGrantIntervantionModule'+lstGrantIntervantionModule);
                          
           }
        
        
        if(System.UserInfo.getLanguage() == 'ru'){
        
                            lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.Russian_Name__c Modulename,
                            Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                            Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                            Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                            WHERE Implementation_Period__r.Concept_Note__c =: strCNId 
                            Group By CN_Intervention__r.Module_rel__r.Russian_Name__c];
             
                                   
             }
             
        if(System.UserInfo.getLanguage() == 'es'){
        
                            lstGrantIntervantionModule = [Select CN_Intervention__r.Module_rel__r.Spanish_Name__c Modulename,
                            Sum(Above_Indicative_Y1__c) AboveY1, Sum(Above_Indicative_Y2__c) AboveY2,Sum(Above_Indicative_Y3__c) AboveY3,
                            Sum(Above_Indicative_Y4__c) AboveY4,Sum(Indicative_Y1__c) IndY1,Sum(Indicative_Y2__c) IndY2,
                            Sum(Indicative_Y3__c) IndY3,Sum(Indicative_Y4__c) IndY4 From Grant_Intervention__c 
                            WHERE Implementation_Period__r.Concept_Note__c =: strCNId 
                            Group By CN_Intervention__r.Module_rel__r.Spanish_Name__c];
                  }
               
        map<string,AggregateResult> mapResult = new map<string,AggregateResult>();
        for(AggregateResult objAgg : lstGrantIntervantionModule) {
            mapResult.put(String.valueof(objAgg.get('Modulename')),objAgg);
        }
        
        List<Module__c> lstModulesetOrder = new List<Module__c>();
        lstModulesetOrder = [select Name,French_Name__c,Russian_Name__c,Spanish_Name__c,Modular_Order__c from Module__c where Concept_Note__c =: strCNId And (Name in: mapResult.keyset() OR French_Name__c in: mapResult.keyset() OR Russian_Name__c in: mapResult.keyset() OR Spanish_Name__c in: mapResult.keyset()) Order By Modular_Order__c NULLS LAST];
        
         
        /*List<AggregateResult> lstModulesetOrder = new List<AggregateResult>();
        if(System.UserInfo.getLanguage() == 'ru'){
                 lstModulesetOrder = [select Russian_Name__c moduleNameByLang,Modular_Order__c from Module__c where Concept_Note__c =: strCNId And Russian_Name__c in: mapResult.keyset() Group By Russian_Name__c,Modular_Order__c ];
        }
        else if(System.UserInfo.getLanguage() == 'es'){
                 lstModulesetOrder = [select Spanish_Name__c moduleNameByLang,Modular_Order__c from Module__c where Concept_Note__c =: strCNId And Spanish_Name__c in: mapResult.keyset() Group By Spanish_Name__c,Modular_Order__c ];
        }
        else if(System.UserInfo.getLanguage() == 'fr'){
                 lstModulesetOrder = [select French_Name__c moduleNameByLang,Modular_Order__c from Module__c where Concept_Note__c =: strCNId And French_Name__c in: mapResult.keyset() Group By French_Name__c,Modular_Order__c ];
        }
        else{
                 lstModulesetOrder = [select Name moduleNameByLang,Modular_Order__c from Module__c where Concept_Note__c =: strCNId And Name in: mapResult.keyset() Group By Name,Modular_Order__c];
        }*/
        
       /* map<string,AggregateResult> mapResults = new map<string,AggregateResult>();
        for(AggregateResult objAgg : lstGrantIntervantionModule) {
            mapResults.put(String.valueof(objAgg.get('moduleNameByLang')),objAgg);
        }*/
        
        
        lstBLModule = new List<BLModule>();
      // for(AggregateResult objAgg : lstGrantIntervantionModule){
        
       for(Module__c objModule : lstModulesetOrder){
            AggregateResult objAgg;
            if(System.UserInfo.getLanguage() == 'ru'){
                objAgg = mapResult.get(objModule.Russian_Name__c);
            }
            else if(System.UserInfo.getLanguage() == 'es'){
                objAgg = mapResult.get(objModule.Spanish_Name__c);
            }
            else if(System.UserInfo.getLanguage() == 'fr'){
                objAgg = mapResult.get(objModule.French_Name__c);
            }
            else{
                objAgg = mapResult.get(objModule.Name);
            }
            
            //AggregateResult objAgg = mapResult.get(objModule.Name);
            BLModule objwrap = new BLModule();
            objwrap.ModuleName = String.valueof(objAgg.get('Modulename'));
            if(objAgg.get('IndY1') != null) objwrap.IndY1 = Integer.valueof(objAgg.get('IndY1'));
            else objwrap.IndY1 = 0;
            if(objAgg.get('IndY2') != null) objwrap.IndY2 = Integer.valueof(objAgg.get('IndY2'));
            else objwrap.IndY2 = 0;
            if(objAgg.get('IndY3') != null) objwrap.IndY3 = Integer.valueof(objAgg.get('IndY3'));
            else objwrap.IndY3 = 0;
            if(objAgg.get('IndY4') != null) objwrap.IndY4 = Integer.valueof(objAgg.get('IndY4'));
            else objwrap.IndY4 = 0;
            objwrap.TotalModuleCostI = objwrap.IndY1 + objwrap.IndY2 + objwrap.IndY3 + objwrap.IndY4 ;
            if(objAgg.get('AboveY1') != null) objwrap.AboveY1 = Integer.valueof(objAgg.get('AboveY1'));
            else objwrap.AboveY1 = 0;
            if(objAgg.get('AboveY2') != null) objwrap.AboveY2 = Integer.valueof(objAgg.get('AboveY2'));
            else objwrap.AboveY2 = 0;
            if(objAgg.get('AboveY3') != null) objwrap.AboveY3 = Integer.valueof(objAgg.get('AboveY3'));
            else objwrap.AboveY3 = 0;
            if(objAgg.get('AboveY4') != null) objwrap.AboveY4 = Integer.valueof(objAgg.get('AboveY4'));
            else objwrap.AboveY4 = 0;
            objwrap.TotalModuleCostA = objwrap.AboveY1 + objwrap.AboveY2 + objwrap.AboveY3 + objwrap.AboveY4 ;             
            lstBLModule.add(objwrap);
            system.debug('this is module 1st'+lstBLModule);
            
            
            if(TotalModuleY1CostI == null) TotalModuleY1CostI = objwrap.IndY1;
            else TotalModuleY1CostI += objwrap.IndY1;
            if(TotalModuleY2CostI == null) TotalModuleY2CostI = objwrap.IndY2;
            else TotalModuleY2CostI += objwrap.IndY2;
            if(TotalModuleY3CostI == null) TotalModuleY3CostI = objwrap.IndY3;
            else TotalModuleY3CostI += objwrap.IndY3;
            if(TotalModuleY4CostI == null) TotalModuleY4CostI = objwrap.IndY4;
            else TotalModuleY4CostI += objwrap.IndY4;
            
            if(AllYearModuleTotalCostA == null) AllYearModuleTotalCostA = objwrap.TotalModuleCostA;
            else AllYearModuleTotalCostA += objwrap.TotalModuleCostA;
            
            if(TotalModuleY1CostA == null) TotalModuleY1CostA = objwrap.AboveY1;
            else TotalModuleY1CostA += objwrap.AboveY1;
            if(TotalModuleY2CostA == null) TotalModuleY2CostA = objwrap.AboveY2;
            else TotalModuleY2CostA += objwrap.AboveY2;
            if(TotalModuleY3CostA == null) TotalModuleY3CostA = objwrap.AboveY3;
            else TotalModuleY3CostA += objwrap.AboveY3;
            if(TotalModuleY4CostA == null) TotalModuleY4CostA = objwrap.AboveY4;
            else TotalModuleY4CostA += objwrap.AboveY4;
            
            if(AllYearModuleTotalCostI == null) AllYearModuleTotalCostI = objwrap.TotalModuleCostI;
            else AllYearModuleTotalCostI += objwrap.TotalModuleCostI;
        }
        system.debug('this is module'+lstBLModule);
        
        lstBLModulePR = new List<BLModulePR>();
        for(AggregateResult objAgg : lstGrantIntervantionPR){
            BLModulePR objwrap = new BLModulePR();
            objwrap.ModuleName = String.valueof(objAgg.get('Modulename'));
            if(objAgg.get('IndY1') != null) objwrap.IndY1 = Integer.valueof(objAgg.get('IndY1'));
            else objwrap.IndY1 = 0;
            if(objAgg.get('IndY2') != null) objwrap.IndY2 = Integer.valueof(objAgg.get('IndY2'));
            else objwrap.IndY2 = 0;
            if(objAgg.get('IndY3') != null) objwrap.IndY3 = Integer.valueof(objAgg.get('IndY3'));
            else objwrap.IndY3 = 0;
            if(objAgg.get('IndY4') != null) objwrap.IndY4 = Integer.valueof(objAgg.get('IndY4'));
            else objwrap.IndY4 = 0;
            objwrap.TotalModuleCostI = objwrap.IndY1 + objwrap.IndY2 + objwrap.IndY3 + objwrap.IndY4 ;
            
            if(objAgg.get('AboveY1') != null) objwrap.AboveY1 = Integer.valueof(objAgg.get('AboveY1'));
            else objwrap.AboveY1 = 0;
            if(objAgg.get('AboveY2') != null) objwrap.AboveY2 = Integer.valueof(objAgg.get('AboveY2'));
            else objwrap.AboveY2 = 0;
            if(objAgg.get('AboveY3') != null) objwrap.AboveY3 = Integer.valueof(objAgg.get('AboveY3'));
            else objwrap.AboveY3 = 0;
            if(objAgg.get('AboveY4') != null) objwrap.AboveY4 = Integer.valueof(objAgg.get('AboveY4'));
            else objwrap.AboveY4 = 0;
            objwrap.TotalModuleCostA = objwrap.AboveY1 + objwrap.AboveY2 + objwrap.AboveY3 + objwrap.AboveY4 ;
            lstBLModulePR.add(objwrap);
            
            
            if(TotalPRY1CostA == null) TotalPRY1CostA = objwrap.IndY1;
            else TotalPRY1CostA += objwrap.IndY1;
            if(TotalPRY2CostA == null) TotalPRY2CostA = objwrap.IndY2;
            else TotalPRY2CostA += objwrap.IndY2;
            if(TotalPRY3CostA == null) TotalPRY3CostA = objwrap.IndY3;
            else TotalPRY3CostA += objwrap.IndY3;
            if(TotalPRY4CostA == null) TotalPRY4CostA = objwrap.IndY4;
            else TotalPRY4CostA += objwrap.IndY4;
            
            if(AllYearPRTotalCostA == null) AllYearPRTotalCostA = objwrap.TotalModuleCostA;
            else AllYearPRTotalCostA += objwrap.TotalModuleCostA;
            
            if(TotalPRY1CostI == null) TotalPRY1CostI = objwrap.AboveY1;
            else TotalPRY1CostI += objwrap.AboveY1;
            if(TotalPRY2CostI == null) TotalPRY2CostI = objwrap.AboveY2;
            else TotalPRY2CostI += objwrap.AboveY2;
            if(TotalPRY3CostI == null) TotalPRY3CostI = objwrap.AboveY3;
            else TotalPRY3CostI += objwrap.AboveY3;
            if(TotalPRY4CostI == null) TotalPRY4CostI = objwrap.AboveY4;
            else TotalPRY4CostI += objwrap.AboveY4;
            
            if(AllYearPRTotalCostI == null) AllYearPRTotalCostI = objwrap.TotalModuleCostI;
            else AllYearPRTotalCostI += objwrap.TotalModuleCostI;
        }
        
          strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            system.debug('french loop'+ System.UserInfo.getLanguage());
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
        
        submissionDate = new List<SelectOption>();
        /*Changes for Iteration Submission by applicant 22Dec- start   */
        submissionDateTRP = new List<SelectOption>();
   
    List<TRPIterationSubmission__c> IterationSubmission = [Select IterationSubmissionApplicantEN__c,IterationSubmissionApplicationNonEng__c,TRP_Reviews__c from TRPIterationSubmission__c ORDER BY Name ASC ];
    
   if(IterationSubmission.size() > 0){
            system.debug('**Inside If ListSize'+IterationSubmission.size()); 
           //  submissionDateTRP .add(new SelectOption('--None--','--None--'));
            for(TRPIterationSubmission__c trpSubmit : IterationSubmission){
            
            if(lstCN.size()> 0)
            {
                 if((lstCN[0].Language__c == 'ENGLISH')|| (lstCN[0].Language__c== '')){
               
                submissionDateTRP .add(new SelectOption(trpSubmit.IterationSubmissionApplicantEN__c,trpSubmit.IterationSubmissionApplicantEN__c));
               }
            else{
           
            submissionDateTRP .add(new SelectOption(trpSubmit.IterationSubmissionApplicationNonEng__c,trpSubmit.IterationSubmissionApplicationNonEng__c));
            }
            }
            }
   /*Changes for Iteration Submission by applicant 22Dec- end */
        
        List<TRPSubmissionDate__c> lstCustSetting = [Select Id,Name,Submission_date_deadline__c,Registration_until__c,Order_Submission__c,TRP_review_date__c
                                            From TRPSubmissionDate__c 
                                            Where Registration_until__c>: Date.Today() Order By Order_Submission__c];
         if(lstCustSetting.size() > 0){
             
            for(TRPSubmissionDate__c trp : lstCustSetting){
                
                submissionDate.add(new SelectOption(trp.Submission_date_deadline__c,trp.Submission_date_deadline__c));
                
            }
            }
        
         List<TRPSubmissionDate__c> lstTrpDate = [Select Id,Registration_until__c,Name,Submission_date_deadline__c,Order_Submission__c,TRP_review_date__c
                                            From TRPSubmissionDate__c Order By Order_Submission__c
                                            limit 1];
      
      strTrpRelDate = lstTrpDate[0].TRP_review_date__c;
      system.debug('**strTrpRelDate'+strTrpRelDate);
       
    }
    if(objCN.Concept_Note_Submission_Date__c!=null){
     submissionDate = new List<SelectOption>();
     //submissionDate.add(new SelectOption(objCN.Concept_Note_Submission_Date__c,objCN.Concept_Note_Submission_Date__c));
     if(objCN.Revised_Submission_Date__c!=null){
     submissionDate.add(new SelectOption(objCN.Revised_Submission_Date__c,objCN.Revised_Submission_Date__c));
     }
     /*List<TRPSubmissionDate__c> lstCustCnf = [Select Id,Name,Submission_date_deadline__c,Order_Submission__c,Registration_until__c,TRP_review_date__c
                                            From TRPSubmissionDate__c 
                                            Where Registration_until__c>: Date.Today() AND Submission_date_deadline__c!=:objCN.Concept_Note_Submission_Date__c AND Submission_date_deadline__c!=:'--None--' Order By Order_Submission__c];*/
     
     List<TRPSubmissionDate__c> lstCustCnf = [Select Id,Name,Submission_date_deadline__c,Order_Submission__c,Registration_until__c,TRP_review_date__c
                                            From TRPSubmissionDate__c 
                                            Where Registration_until__c>: Date.Today() AND Submission_date_deadline__c!=:objCN.Revised_Submission_Date__c AND Submission_date_deadline__c!=:'--None--' Order By Order_Submission__c];   
        
        system.debug('**ListSize'+lstCustCnf);
           if(lstCustCnf.size() > 0){
            system.debug('**Inside If ListSize'+lstCustCnf); 
            for(TRPSubmissionDate__c trp : lstCustCnf){
                
                submissionDate.add(new SelectOption(trp.Submission_date_deadline__c,trp.Submission_date_deadline__c));
                
            }
    }
     List<TRPSubmissionDate__c> lstTrpDate = [Select Id,Registration_until__c,Name,Submission_date_deadline__c,TRP_review_date__c
                                            From TRPSubmissionDate__c Where Submission_date_deadline__c =:objCN.Revised_Submission_Date__c
                                            limit 1];
                                            
      if(lstTrpDate.size()>0)
      strTrpRelDate = lstTrpDate[0].TRP_review_date__c;
      
      else{
      strTrpRelDate = '';
      }
      
    /*Document Type Check wriiten by TCS Developer on 1-08-2014 for CT Review*/
    //  DocCheckCust();
      system.debug('**lstTrpDate'+lstTrpDate);
       system.debug('**strTrpRelDate'+strTrpRelDate);
     }
    DocCheckCust();
    Checkfinaldocs();
    
    
   
    
   }
  
    /****************************************************************************************************************************
    Purpose: This Function is used to Check whether all the Mandatory Documents has been uploaded or not.
    *****************************************************************************************************************************/  
    Public pageReference DocCheckCust(){
    List<CT_Review__c> lstReview = [Select id,Completeness_Heading__c,Completeness_Sub_Item__c,Document_Type__c from CT_Review__c];
    system.debug('**lstReview'+lstReview);
    lstSubItem = new List<String>();
    lstDocMissing = new List<String>();
    Map<String,String> docMap = new Map<String,String>();
    
    List<DocumentUpload__c>lstDocumentUpload = [Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name from DocumentUpload__c where Concept_Note__c =: strCNId];
    system.debug('**lstDocumentUpload'+lstDocumentUpload);
    for(DocumentUpload__c doc:lstDocumentUpload){
    docMap.put(doc.Type__c,doc.Type__c);
    }
    
    for(CT_Review__c objDoc : lstReview){
        
        lstSubItem.add(objDoc.Completeness_Sub_Item__c);
        
        if(docMap.get(objDoc.Document_Type__c)==null){
            lstDocMissing.add(objDoc.Document_Type__c);
        }
    }
    system.debug('**lstDocMissing'+lstSubItem);
    system.debug('**lstDocMissing'+lstDocMissing);
    return null;
    }
    
    Public void CTSubLike(){
    System.debug('****strSelectSubDateAccess'+strSelectSubDateAccess);
    if(selectLikli=='1'){
   
    objCN.Likelihood__c = true;
    objCN.CCM_Proposed_Date__c = objCN.Revised_Submission_Date__c;
    objCN.Assess_Submission_Date__c = false;
    }else if(selectLikli=='2'){
    System.debug('****strSelectSubDateAccess'+strSelectSubDateAccess);
    objCN.Likelihood__c = true;
    objCN.CT_Submission_Date__c = strSelectSubDateAccess;
    objCN.Assess_Submission_Date__c = false;
    }
    update objCN;
    //return null;
    }
    
    /*
    //-----------------added for Request CN Unlock-----------------------------
    public void closeRequestCNunlock(){
        Concept_Note__c CNunlock = new Concept_Note__c(id = strCNId, Request_CN_Unlock__c = true);
        update CNunlock;
    }
    
    
    public void YesCNunlock(){
        
        //Unlocked_Itegrated_View();
        Pagereference pr = new Pagereference('/apex/CN_IntegratedView_pdf_unlocked?id='+strCNId);
        pr.setRedirect(true);
        Concept_Note__c CNunlock = new Concept_Note__c(id = strCNId, Request_CN_Unlock__c = false, Status__c = 'Not yet submitted', Unlocked_Integrated_View__c = true, CN_Unlock_Request_Accepted_Rejected__c = true);
        update CNunlock;
        //String pageurl = '?id='+strCNId;
        //Unlocked_Itegrated_View();
        //Pagereference pr = new Pagereference('/apex/CN_IntegratedView_pdf_unlocked?id='+strCNId);
        //pr.setRedirect(true);
        //return pr;
    }
    public Pagereference Unlocked_Itegrated_View(){
        Pagereference pr = new Pagereference('/apex/CN_IntegratedView_pdf_unlocked?id='+strCNId);
        pr.setRedirect(true);
        return null;
    }
    
    
    public void NoCNunlock(){
        Concept_Note__c CNunlock = new Concept_Note__c(id = strCNId, Request_CN_Unlock__c = false, Unlocked_Integrated_View__c = false, CN_Unlock_Request_Accepted_Rejected__c = true);
        update CNunlock;
    }
    
    public void CNrollback(){
        Concept_Note__c CNunlock = new Concept_Note__c(id = strCNId, Rollback_CN__c = true, Status__c = 'Submitted to the Global Fund');
        update CNunlock;
    }
    */
    
    /****************************************************************************************************************************
    Purpose: This Function is used to submit the Concept and Creating a integrated view Document.
    *****************************************************************************************************************************/
    Public pageReference SubmitToCN(){
        if(lstPages != null && lstPages.size() > 0){
            for(Page__c objPage : lstPages){
                if(objPage.Status__c == 'Draft'){
                    objPage.Status__c = 'TGF Review';
                }
            }
            objCN.Status__c = 'Submitted to the Global Fund';

            update objCN;
            update lstPages;
            lstPages = new List<Page__c>();   
            lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c,Status__c,PR_Comments__c,LFA_Comments__c,CT_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_CT_Comment__c From Page__c Where Concept_Note__c =: strCNID Order by Order__c]; 
            CheckBoolean();     
                  
          
           // Add Document Upload record on submit click TCS

             list<DocumentUpload__c> docCount = [select id,type__c,Name from DocumentUpload__c where NAME LIKE: 'CCM_IntegratedView%' AND Concept_Note__c =: strCNId]; 
             integer count = docCount.size()+1;
             Datetime dateTimetemp = System.now();
             string dateTemp = string.valueof(Date.newInstance(dateTimetemp.year(),dateTimetemp.month(),dateTimetemp.day()));
           
            
            objFeedItem = new FeedItem();
                
            objDocumentUpload = new DocumentUpload__c();
           // pagereference Pg = Page.CN_IntegratedView_pdf ; 
            PageReference pg = new PageReference('/apex/CN_IntegratedView_pdf?id=' + strCNId);
            
            transient Blob pdf1; 
            if(Test.isRunningTest() == false){
                
                pdf1 = pg.getcontentAsPdf();              
                
                objFeedItem.Visibility = 'AllUsers'; 
                objFeedItem.Type='ContentPost';
                objFeedItem.ContentData = pdf1;
                objFeedItem.ParentId = strCNId;
                objFeedItem.Body = 'Submit Integrated View';
                objFeedItem.ContentFileName = 'CCM_IntegratedView_'+CNName+'_V'+count+'_'+dateTemp+'.pdf';
                objFeedItem.ContentDescription = 'Other Document';
                insert objFeedItem;               
                
            }
            objDocumentUpload.FeedItem_Id__c = objFeedItem.ID;
            objDocumentUpload.Name='CCM_IntegratedView_'+CNName+'_V'+count+'_'+dateTemp+'.pdf';
            objDocumentUpload.Concept_Note__c = strCNId;
            objDocumentUpload.Process_Area__c = 'Concept Note';
            objDocumentUpload.Type__c = 'Integrated View';
            insert objDocumentUpload;
        }
        return null;
        
         
    }
    
    /****************************************************************************************************************************
    Purpose: This Function is used to update the Status field of Concept after the CT Review is Complete.
             Also Insert the feeditem for Integrated view PDF
    *****************************************************************************************************************************/
    Public pageReference SubmitToTRP(){
       objCN.Status__c = 'Reviewed and OK for TRP/GAC1';
       update objCN;
       
       
       
       // Add Document Upload record on Confirm click
        transient Datetime dateTimetemp = System.now();
        transient string dateTemp = string.valueof(Date.newInstance(dateTimetemp.year(),dateTimetemp.month(),dateTimetemp.day()));
        objFeedItem = new FeedItem();
            
        objDocumentUpload = new DocumentUpload__c();
        PageReference pg = new PageReference('/apex/CN_IntegratedView_pdf?id=' + strCNId);
        transient Blob pdf1;
        if(Test.isRunningTest() == false){
         

        pdf1 = pg.getcontentAsPdf();
        
        objFeedItem.Visibility = 'AllUsers';
        objFeedItem.Type='ContentPost';
        objFeedItem.ContentData = pdf1;
        objFeedItem.ParentId = strCNId;
        objFeedItem.Body = 'Submit Integrated View';
        objFeedItem.ContentFileName = 'IntegratedView_ReadyForTRP_'+CNName+'_'+dateTemp+'.pdf';
        objFeedItem.ContentDescription = 'Other Document'; 
        insert objFeedItem;
        
        }
        objDocumentUpload.FeedItem_Id__c = objFeedItem.ID;
        objDocumentUpload.Concept_Note__c = strCNId;
        objDocumentUpload.Process_Area__c = 'Concept Note';
        objDocumentUpload.Type__c = 'Integrated View';
        insert objDocumentUpload;   
        return null;
      
    }
    
    /****************************************************************************************************************************
    Purpose: This Function is used to update the Submission and Revised Submission dates on CN
    *****************************************************************************************************************************/
    Public void submitCNDate(){
    //system.Debug('strSelectSubDate'+strSelectSubDate);
     system.debug('**objCN.Concept_Note_Submission_Date__c'+objCN.Concept_Note_Submission_Date__c);
     String monthvalue=null;
     
     if(objCN.Concept_Note_Submission_Date__c==null){
     system.debug('**objCN.TRP_Submission_Review_Date__c'+strSelectSubDate);
     objCN.Concept_Note_Submission_Date__c = strSelectSubDate;
     }
     system.debug('**objCN.TRP_Submission_Review_Date__c'+strSelectSubDate);
     objCN.TRP_Submission_Review_Date__c = strTrpRelDate;
     system.debug('**strTrpRelDate'+strTrpRelDate);
     objCN.Revised_Submission_Date__c = strSelectSubDate;
     system.debug('**Revised date'+objCN.Revised_Submission_Date__c);
     /*----------------START------------------Commented for CN Unlock/Rollbac------------------------------------
     if(strSelectSubDate != null && strSelectSubDate != ''){
         objCN.Revised_Submission_Date_Format__c = strSelectSubDate.substring((strSelectSubDate.length()-4), (strSelectSubDate.length()));
         
         if(strSelectSubDate.contains('January')) monthvalue = '01';
         else if(strSelectSubDate.contains('February')) monthvalue = '02';
         else if(strSelectSubDate.contains('March')) monthvalue = '03';
         else if(strSelectSubDate.contains('April')) monthvalue = '04';
         else if(strSelectSubDate.contains('May')) monthvalue = '05';
         else if(strSelectSubDate.contains('June')) monthvalue = '06';
         else if(strSelectSubDate.contains('July')) monthvalue = '07';
         else if(strSelectSubDate.contains('August')) monthvalue = '08';
         else if(strSelectSubDate.contains('September')) monthvalue = '09';
         else if(strSelectSubDate.contains('October')) monthvalue = '10';
         else if(strSelectSubDate.contains('November')) monthvalue = '11';
         else if(strSelectSubDate.contains('December')) monthvalue = '12'; 
         objCN.Revised_Submission_Date_Format__c = objCN.Revised_Submission_Date_Format__c +'-'+monthvalue;
         objCN.Revised_Submission_Date_Format__c = objCN.Revised_Submission_Date_Format__c+'-'+strSelectSubDate.substring(0,2);      
     }
     ----------------START------------------Commented for CN Unlock/Rollbac------------------------------------*/
     /*Commented Based on incidentINC016599 
     
     String s = objCN.TRP_Submission_Language__c;
     objCN.TRP_Submission_Language__c = s;*/
     String s = objCN.Language__c;
     objCN.Language__c = s;
     String justification = objCN.Justification__c;
     objCN.Justification__c = justification;
    
     objCN.Assess_Submission_Date__c = true;
     system.debug('This is CN before update:'+objCN);
     update objCN;
     //TRPSubmitted = true;
    // submissionDate =new List<SelectOption>();
    // submissionDate.add(new SelectOption(strSelectSubDate,strSelectSubDate));
     //system.Debug('Concept_Note_Submission_Date__c'+ objCN.Concept_Note_Submission_Date__c);
    }
     //Changes done on 22nd Dec start
    public void submitCNDateTRP(){
    system.debug('strSelectSubDateIteration'+strSelectSubDateIteration);
    system.debug('strTrpRevDate '+strTrpRevDate );
    objCN.CN_Iteration_Submission_Date__c = strSelectSubDateIteration;
    objCN.TRP_Submission_Review_Date__c = strTrpRevDate ;
    //objCN.Request_language_change__c= blnChangeLanguage  ;Concept_Note_Submission_Date__c
    system.debug(' objCN.CN_Iteration_Submission_Date__c '+  objCN.CN_Iteration_Submission_Date__c  );
    system.debug('objCN.TRP_Submission_Review_Date__c '+ objCN.TRP_Submission_Review_Date__c  );
    system.debug('objCN.Request_language_change__c'+ objCN.Request_language_change__c );
    update objCN;
     
    }
     //Changes done on 22nd Dec end
    /****************************************************************************************************************************
    Purpose: This Function is used get the related Submission Date deadline for selected Submission Date
    *****************************************************************************************************************************/
    Public void trpDate(){
     
      List<TRPSubmissionDate__c> lstTrpDate = [Select Id,Name, Submission_date_deadline__c,TRP_review_date__c
                                            From TRPSubmissionDate__c 
                                           Where Submission_date_deadline__c=: strSelectSubDate];
                                          
      
      strTrpRelDate = lstTrpDate[0].TRP_review_date__c; 
      
      
                                          
    }
    //Changes done on 22nd Dec start
     Public void trpDateSubmission(){
    
     if(lstCN.size()> 0 && strSelectSubDateIteration!= '')
     {
     if((lstCN[0].Language__c == 'ENGLISH')|| (lstCN[0].Language__c== '')){
     
      lstTrpSubmissionDate = [Select IterationSubmissionApplicantEN__c,TRP_Reviews__c from TRPIterationSubmission__c 
      Where IterationSubmissionApplicantEN__c =: strSelectSubDateIteration];
     
       }
       else{
        lstTrpSubmissionDate = [Select IterationSubmissionApplicationNonEng__c,TRP_Reviews__c from TRPIterationSubmission__c 
      Where IterationSubmissionApplicationNonEng__c =: strSelectSubDateIteration];
     
       }
                                     
           
     }      
        strTrpRevDate = lstTrpSubmissionDate[0].TRP_Reviews__c;                                   
    }
    //changes done on 22nd Dec ends
    
    Public void CheckBoolean(){
        if(lstPages != null && lstPages.size() > 0){
            blnDraftStatusExist = false;
            for(Page__c objPage : lstPages){
                if(objPage.Status__c == 'Draft'){
                    blnDraftStatusExist = true;
                    break;
                }
            }
        }
    }
    Public void SavePage(){
        Integer SavePageIndex = integer.valueof(Apexpages.currentpage().getparameters().get('SavePageIndex'));
        if(SavePageIndex != null){
            update lstPages;
            //lstPages = new List<Page__c>();   
            //lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c,Status__c,PR_Comments__c,LFA_Comments__c,CT_Comments__c,Latest_PR_Comment__c,Latest_LFA_Comment__c,Latest_CT_Comment__c From Page__c Where Implementation_Period__c =: strGIPID Order by Order__c]; 
           // blnHasNoChild = false;
        }
    }
    Public void CancelPage(){
        //blnHasNoChild = false;
    }
    
    
    Public Class BLModule{
        Public Integer AboveY1 {get;set;}
        Public Integer AboveY2 {get;set;}
        Public Integer AboveY3 {get;set;}
        Public Integer AboveY4 {get;set;}
        Public Integer IndY1 {get;set;}
        Public Integer IndY2 {get;set;}
        Public Integer IndY3 {get;set;}
        Public Integer IndY4 {get;set;}
        Public Integer TotalModuleCostA {get;set;}
        Public Integer TotalModuleCostI {get;set;}
        Public String ModuleName {get;set;}
    }
    Public Class BLModulePR{
        Public Integer AboveY1 {get;set;}
        Public Integer AboveY2 {get;set;}
        Public Integer AboveY3 {get;set;}
        Public Integer AboveY4 {get;set;}
        Public Integer IndY1 {get;set;}
        Public Integer IndY2 {get;set;}
        Public Integer IndY3 {get;set;}
        Public Integer IndY4 {get;set;}
        Public Integer TotalModuleCostA {get;set;}
        Public Integer TotalModuleCostI {get;set;}
        Public String ModuleName {get;set;}
    }
    
    Public void Checkfinaldocs() {
        Id CNIdforDoc = Apexpages.currentpage().getparameters().get('id');
        list<DocumentUpload__c> lstDocsforCN = [Select Id, Final_TRP_Document__c From DocumentUpload__c Where Concept_Note__c =: CNIdforDoc];
        if(lstDocsforCN.size() > 0) {
            for(DocumentUpload__c objDoc: lstDocsforCN) {
                if(objDoc.Final_TRP_Document__c == true) {
                    hasFinalDoc = true;
                    break;
                }
                    
            }
        }
        else {
            hasFinalDoc = false;
        }
    }

public void checkProfile(){
        blnExternalPro =false;
        blnRegisterToTRP =false;
        blnSubmitCN  =false;
        blnFinalCTReview =false;
        blnAccessLikehood =false;
        blnChangeSubmissionDate =false;
        /*-------START---------Commented for CN Unlock/rollback---------
        btnRequestCNunlock =false;
        btnCNunlockRequested =false;
        btnUnlockCN =false;
        btnRollbackCN =false;
        -------FINISH---------Commented for CN Unlock/rollback---------*/
        
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        System.Debug('****profileName:-'+profileName);
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CNOverview' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets)];
        System.Debug('****checkpage:-'+checkpage);
      for (Profile_Access_Setting_CN__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Register To TRP' && check.Status__c== strStatus)blnRegisterToTRP = true;
        if(check.Salesforce_Item__c == 'Submit CN' && check.Status__c== strStatus)blnSubmitCN = true;
         if(check.Salesforce_Item__c == 'Final CT Review' && check.Status__c== strStatus)blnFinalCTReview = true;
         if(check.Salesforce_Item__c == 'Access Likehood' && check.Status__c== strStatus)blnAccessLikehood = true;
         if(check.Salesforce_Item__c == 'Change Submission Date' && check.Status__c== strStatus)blnChangeSubmissionDate = true;
         /*-------START---------Commented for CN Unlock/rollback---------
         if(check.Salesforce_Item__c == 'Request CN Unlock'  && check.Status__c != strStatus)btnRequestCNunlock = true;
         if(check.Salesforce_Item__c == 'CN unlock requested')btnCNunlockRequested = true;
         if(check.Salesforce_Item__c == 'Unlock CN')btnUnlockCN = true;
         if(check.Salesforce_Item__c == 'Rollback CN' && check.Status__c != strStatus)btnRollbackCN = true;  
         system.debug('****btnRequestCNunlock:-'+btnRequestCNunlock+'****btnCNunlockRequested:-'+btnCNunlockRequested+'****btnUnlockCN:-'+btnUnlockCN+'****btnRollbackCN:-'+btnRollbackCN);
         -------FINISH---------Commented for CN Unlock/rollback---------*/
       }
    }
}