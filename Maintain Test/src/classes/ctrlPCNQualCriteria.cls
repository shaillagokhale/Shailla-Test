Public with sharing Class ctrlPCNQualCriteria{
    public String strCNId;
    Public List<PCN_Criteria__c> lstPerformance {get;set;}
    Public List<PCN_Criteria__c> lstImpact {get;set;}
    Public List<PCN_Criteria__c> lstIncreasingReatofInfection{get;set;}
    Public List<PCN_Criteria__c> lstRisk{get;set;}
    Public List<PCN_Criteria__c> lstAbsorptiveCapacity{get;set;} 
    Public List<PCN_Criteria__c> lstOtherConsideration{get;set;}
    Public List<PCN_Criteria__c> lstFinalAllocationAbsorptiveCapacity{get;set;}    
    Public String strCountryTeanJustification {get;set;}
    Public String strFunctionalTeamComments {get;set;}   
    Public String strRecordTypeName {get;set;}   
    Public String strStatusAbsorptiveCapacity {get;set;}
    Public String strOtherConsideration {get;set;}
    Public String strFinalOtherConsideration {get;set;}  
    Public String strCTSuggestedImpRating {get;set;}
    Public String strCTSuggestedPerfRating {get;set;}
    Public Decimal decCapAmountProvided {get;set;}
    Public Decimal decPastAverage {get;set;}
    Public Decimal decSpendRate {get;set;}  
    Public Decimal decSProposedAmountFAC {get;set;}  
    Public Decimal decSProposedAmountAC {get;set;} 
    Public Decimal decCapAmountFAC {get;set;}  
    Public Decimal decCapAmountAC {get;set;}     
    Public Concept_Note__c objConceptNote{get;set;}
    Public List<FeedItem> lstFeedItems{get;set;}     
    Public List<FeedItem> lstFeedItemsOtherConsideration{get;set;}  
    Public List<FeedItem> lstFeedItemsFinalOtherConsideration{get;set;}
    Public String strAffectedSubPopulation{get;set;}  
    Public String strRecordType{get;set;}    
    Public Boolean blnIsDisableSubmitAll{get;set;}  
    Public Boolean blnIsDisableSubmitAC{get;set;} 
    Public String ShowRequestUpdatePanel{get;set;}  
    Public String ShowFunctionalTeamPanel{get;set;}
    Public List<wrpFunctionalTeam> lstwrpFunctionalTeam{get;set;}
    Public String showsetCapAmount{get;set;}
    Public String strFPMProfileId{get;set;}
    Public String strCountryTeamProfileId{get;set;}
    Public List<UserRecordAccess> lstShare {get;set;} 
    Public String strAccountID {get;set;}  
    //added 
    Public String strShowJustifiedAllocation{get;set;}  
    Public String ShowRequestUpdatePanelOther{get;set;} 
    Public String strUpdateOtherConsideration {get;set;}     
    //end added 
               
    Public ctrlPCNQualCriteria(ApexPages.StandardController controller) {        
        strCNId = Apexpages.currentpage().getparameters().get('id');       
        lstPerformance = New List<PCN_Criteria__c>();
        lstImpact = New List<PCN_Criteria__c>();
        lstIncreasingReatofInfection = New List<PCN_Criteria__c>();
        lstRisk = New List<PCN_Criteria__c>();        
        lstAbsorptiveCapacity = New List<PCN_Criteria__c>();
        lstFinalAllocationAbsorptiveCapacity = New List<PCN_Criteria__c>();  
        lstOtherConsideration = New List<PCN_Criteria__c>();      
        objConceptNote = New Concept_Note__c();
        lstFeedItems = New List<FeedItem>();
        lstFeedItemsOtherConsideration = New List<FeedItem>();
        lstFeedItemsFinalOtherConsideration = New List<FeedItem>();        
        lstwrpFunctionalTeam = New List<wrpFunctionalTeam>();                  
        blnIsDisableSubmitAll = false;
        blnIsDisableSubmitAC = false;   
        ShowRequestUpdatePanel = 'No';  
        ShowRequestUpdatePanelOther = 'No';
        ShowFunctionalTeamPanel = 'No';
        showsetCapAmount = 'No';  
        List<Profile> lstProfiles = New List<Profile>([Select Id From Profile Where Name = 'Country Team']); 
        if(lstProfiles.size()>0){
            strCountryTeamProfileId = lstProfiles[0].Id;    
            //strFPMProfileId = lstProfiles[1].Id;                  
        }      
        if(String.IsBlank(strCNId) == false){           
          retrievePCNRecord();
          //SetStatusImpactPerformance();           
          retrieveOtherConsiderations();
          FeedItem objFeedItem = New FeedItem();           
          lstFeedItemsOtherConsideration.Add(objFeedItem);
          lstFeedItemsFinalOtherConsideration.Add(objFeedItem);  
          preventSubmitAll();      
        }           
    }
    
    Public List<PCN_Criteria__c> EmptyLists(){
        if(!lstPerformance.isEmpty()){ return lstPerformance; }
        if(!lstImpact.isEmpty()){ return lstImpact; }
        if(!lstIncreasingReatofInfection.isEmpty()){ return lstIncreasingReatofInfection; }
        if(!lstRisk.isEmpty()){ return lstRisk; }
        if(!lstAbsorptiveCapacity.isEmpty()){ return lstAbsorptiveCapacity; }
        if(!lstFinalAllocationAbsorptiveCapacity.isEmpty()){ return lstFinalAllocationAbsorptiveCapacity; }
        return null;
    } 
    Public void retrievePCNRecord(){
         List<RecordType> lstRecordTypes = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And 
              (RecordType.DeveloperName = 'Performance' OR RecordType.DeveloperName = 'Impact' OR RecordType.DeveloperName = 'Increasing_Rate_of_Infection' 
              OR RecordType.DeveloperName = 'Risk' OR RecordType.DeveloperName = 'Absorptive_Capacity' OR RecordType.DeveloperName = 'Final_Allocation_Absorptive_Capacity')]);
              
         if(String.IsBlank(strCNId) == false && lstRecordTypes.size()>0){
            lstPerformance = [Select Id,Name,Status__c, Initial_Performance_Theoretical_Adjust__c, Performance_Theoretical_Adjustment__c,
                Country_Team_Justification__c,Functional_Team_Comments__c,LFA_Verification_Needed__c,CT_Suggested_Performance_Rating__c,CT_Suggested_Impact_Rating__c,
                Performance_Rating__c,LFA_Verified_Performance_Rating__c,RecordType.DeveloperName,Initial_Performance_Rating__c
                From PCN_Criteria__c Where Concept_Note__c =: strCNId And RecordTypeId =: lstRecordTypes[4].Id Limit 1];
                
            lstImpact = [Select Id,Name,Status__c,Country_Team_Justification__c,Initial_Impact_Theoretical_Adjustment__c,
                Impact_Rating_Theoretical_Adjustment__c,Functional_Team_Comments__c, 
                CT_Suggested_Impact_Rating__c,Impact_Rating__c,Initial_Impact_Rating__c,RecordType.DeveloperName,
                Initial_Performance_Rating__c From PCN_Criteria__c Where Concept_Note__c =: strCNId And RecordTypeId =: lstRecordTypes[2].Id Limit 1];
                // Initial_P_I_Theoretical_Adjustment__c,P_I_Theoretical_Adjustment__c,
                
            lstIncreasingReatofInfection = [Select Id,Name,Status__c,Country_Team_Justification__c,Functional_Team_Comments__c,Increasing_Rate_of_Infection__c,Initial_Increasing_Rate_of_Infection__c,
                Nature_of_Increasing_Rate_of_Infection__c, 
                RecordType.DeveloperName,Affected_Subpopulation_s__c,Increasing_Rate_Theoretical_Adjustment__c 
                From PCN_Criteria__c Where Concept_Note__c =: strCNId And RecordTypeId =: lstRecordTypes[3].Id Limit 1];
                // Initial_Increasing_Rate_Adjustment__c,Initial_Nature_of_Increasing_Rate__c,
                
            lstRisk = [Select Id,Name,Status__c,Country_Team_Justification__c,
                Functional_Team_Comments__c,Initial_Qualifies_for_Risk_Mitigation__c,Qualifies_for_Risk_Mitigation__c,
                RecordType.DeveloperName,Initial_Risk_Adjustment__c,Risk_Adjustment__c From PCN_Criteria__c 
                Where Concept_Note__c =: strCNId And RecordTypeId =: lstRecordTypes[5].Id Limit 1]; 
                // Initial_Risk_Adjustment_Display__c,Risk_Adjustment_Display__c,
                                
            lstAbsorptiveCapacity = [Select Id,Name,Status__c,Country_Team_Justification__c,Functional_Team_Comments__c,Initial_Qualifies_for_Risk_Mitigation__c,
                Qualifies_for_Risk_Mitigation__c,Absorptive_Capacity_Spend_Ratio__c,Past_Average_Annual_Spend__c,Absorptive_Capacity_Matrix_Category__c,
                Spend_Rate_24_Month_Average__c,Other_Considerations__c,RecordType.DeveloperName,Other_Considerations_Proposed_Amount__c,Cap_Amount_Provided__c,CT_Justification_for_Proposed_Allocation__c From PCN_Criteria__c Where Concept_Note__c =: strCNId And RecordTypeId =: lstRecordTypes[0].Id Limit 1];
                //,Absorptive_Capacity_Other_Considerations__c 
            lstFinalAllocationAbsorptiveCapacity = [Select Id,Country_Team_Justification__c,Cap_Amount_Provided__c,Other_Considerations__c,RecordType.DeveloperName,Other_Considerations_Proposed_Amount__c 
                From PCN_Criteria__c Where Concept_Note__c =: strCNId And RecordTypeId =: lstRecordTypes[1].Id Limit 1];
            
            List<RecordType> lstRecord = New List<RecordType>([Select Id from RecordType where sobjectType = 'PCN_Criteria__c' And RecordType.DeveloperName = 'Other_Considerations']);
            lstOtherConsideration =  [Select Id,Name,Status__c,Country_Team_Justification__c,Functional_Team_Comments__c,Initial_Qualifies_for_Risk_Mitigation__c,
                Qualifies_for_Risk_Mitigation__c,Absorptive_Capacity_Spend_Ratio__c,Past_Average_Annual_Spend__c,Absorptive_Capacity_Matrix_Category__c,
                Spend_Rate_24_Month_Average__c,Other_Considerations__c,RecordType.DeveloperName,Other_Considerations_Proposed_Amount__c,Cap_Amount_Provided__c,CT_Justification_for_Proposed_Allocation__c From PCN_Criteria__c Where Concept_Note__c =: strCNId And RecordTypeId =: lstRecord[0].Id Limit 1];
   
            if(lstAbsorptiveCapacity.Size() > 0) {                
                decPastAverage = lstAbsorptiveCapacity[0].Past_Average_Annual_Spend__c;
                decSpendRate = lstAbsorptiveCapacity[0].Spend_Rate_24_Month_Average__c; 
                decCapAmountAC = lstAbsorptiveCapacity[0].Cap_Amount_Provided__c; //Added in by MM            
            }                    
            if(lstIncreasingReatofInfection.size()>0){
                strCountryTeanJustification = lstIncreasingReatofInfection[0].Country_Team_Justification__c;
            }            
            objConceptNote = [Select Id,Final_Allocation__c,Range_Violated__c,Maximum__c,Minimum__c,Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,CCM_New__c,Performance_Impact_Rate_Risk_Stage__c,Absorptive_Capacity_Stage__c,P_I_IR_and_Risk_Status__c,Language__c,P_I_IR_Review_Deadline__c,LFA_Verified_Performance_Status__c,LFA_Verified_Performance_Deadline__c from Concept_Note__c Where Id =: strCNId];
            strAccountId = objConceptNote.CCM_New__c;
            lstshare = [Select RecordId, HasEditAccess,HasReadAccess from UserRecordAccess where UserId = :UserInfo.getUserId() and RecordId =: strCNId Limit 1];              

        }  
        EmptyLists();
    }
    
    Public void AddNewFile(){ 
       ShowRequestUpdatePanel = 'Yes'; 
       ShowRequestUpdatePanelOther = 'Yes'; 
       FeedItem objFeedItemNew = New FeedItem();
       lstFeedItems.Add(objFeedItemNew);
    }
    
    Public void AddNewFileOtherConsideration(){        
       FeedItem objFeedItemNew = New FeedItem();
       lstFeedItemsOtherConsideration.Add(objFeedItemNew);          
    }
    
    Public void AddNewFileFinalOtherConsideration(){        
       FeedItem objFeedItemNew = New FeedItem();
       lstFeedItemsFinalOtherConsideration.Add(objFeedItemNew);          
    }
       
    Public void changePCNStatusToAccepted(){ 
      system.debug('****strCNId=='+strCNId);
      system.debug('****strRecordTypeName=='+strRecordTypeName);
      if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordTypeName) == false){                   
          if(strRecordTypeName == 'Performance'){
              if(lstPerformance.size()>0){
                 lstPerformance[0].Status__c = 'Accepted';             
                  Update lstPerformance;
              }
          }
          else if(strRecordTypeName == 'Impact'){
              if(lstImpact.size()>0){
                  lstImpact[0].Status__c = 'Accepted';
                  Update lstImpact;
              }
          }
          else if(strRecordTypeName == 'Increasing_Rate_of_Infection'){
              if(lstIncreasingReatofInfection.size()>0){
                  lstIncreasingReatofInfection[0].Status__c = 'Accepted';
                  lstIncreasingReatofInfection[0].Country_Team_Justification__c = strCountryTeanJustification;                  
                  Update lstIncreasingReatofInfection;
              }
          }
          else if(strRecordTypeName == 'Risk'){          
              if(lstRisk.size()>0){                 
                  lstRisk[0].Status__c = 'Accepted';
                  Update lstRisk;
              }
          }         
          else if(strRecordTypeName == 'Absorptive_Capacity'){
              if(lstAbsorptiveCapacity.size()>0){                   
                  lstAbsorptiveCapacity[0].Status__c = 'Accepted';
                  Update lstAbsorptiveCapacity;                  
              }                    
          }
          /*if(objConceptNote != null){
            Update objConceptNote;
          }*/               
       }     
         if(!Test.IsRunningTest()){
             retrievePCNRecord(); 
          } 
          preventSubmitAll();   
       EmptyLists();   
    }  
    
    Public void retrieveFunctionalTeamFiles(){
        lstwrpFunctionalTeam = New List<wrpFunctionalTeam>();                         
        System.debug('####strRecordTypeName =='+strRecordTypeName );  
        Profile objProfile = [Select Id from Profile Where Name = 'Functional Team']; 
        Map<Id,User> mapUsers;
        if(objProfile != null){
            mapUsers = New Map<Id,User>([Select Id From User Where ProfileId =: objProfile.Id]);            
        }   
        if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordTypeName) == false){
            if(strRecordTypeName == 'Performance'){ 
                if(lstPerformance.size()>0){      
                    strFunctionalTeamComments = lstPerformance[0].Functional_Team_Comments__c;                    
                    if(objProfile != null && mapUsers != null && mapUsers.size()>0){                                                   
                        List<Attachment> lstAttachmentFunctionalTeam = [select Id,Name,Description From Attachment where ParentId =: lstPerformance[0].Id And CreatedById IN: mapUsers.keyset()];                                      
                        List<FeedItem> lstFeedItemFunctionalTeam = ctrlFeedItem.getFunctionalTeamFeedItems(lstPerformance[0].Id,mapUsers);                      
                        fillFunctionalTeamFileList(lstAttachmentFunctionalTeam,lstFeedItemFunctionalTeam);
                    }                            
                }
            }
            else if(strRecordTypeName == 'Impact'){
                if(lstImpact.size()>0){                                       
                    strFunctionalTeamComments = lstImpact[0].Functional_Team_Comments__c;                    
                    if(objProfile != null && mapUsers != null && mapUsers.size()>0){                        
                        List<Attachment> lstAttachmentFunctionalTeam = [select Id,Name,Description From Attachment where ParentId =: lstImpact[0].Id And CreatedById IN: mapUsers.keyset()];
                        List<FeedItem> lstFeedItemFunctionalTeam = ctrlFeedItem.getFunctionalTeamFeedItems(lstImpact[0].Id,mapUsers);                      
                        fillFunctionalTeamFileList(lstAttachmentFunctionalTeam,lstFeedItemFunctionalTeam);
                    }
                }
            }
            else if(strRecordTypeName == 'Increasing_Rate_of_Infection'){
                if(lstIncreasingReatofInfection.size()>0){                                                           
                    strFunctionalTeamComments = lstIncreasingReatofInfection[0].Functional_Team_Comments__c;      
                    if(objProfile != null && mapUsers != null && mapUsers.size()>0){                                
                        List<Attachment> lstAttachmentFunctionalTeam = [select Id,Name,Description From Attachment where ParentId =: lstIncreasingReatofInfection[0].Id And CreatedById IN: mapUsers.keyset()];                                               
                        List<FeedItem> lstFeedItemFunctionalTeam = ctrlFeedItem.getFunctionalTeamFeedItems(lstIncreasingReatofInfection[0].Id,mapUsers);                      
                        fillFunctionalTeamFileList(lstAttachmentFunctionalTeam,lstFeedItemFunctionalTeam);
                    }
                }
            }
            else if(strRecordTypeName == 'Risk'){
                if(lstRisk.size()>0){  
                    strFunctionalTeamComments = lstRisk[0].Functional_Team_Comments__c; 
                    if(objProfile != null && mapUsers != null && mapUsers.size()>0){ 
                        List<Attachment> lstAttachmentFunctionalTeam = [select Id,Name,Description From Attachment where ParentId =: lstRisk[0].Id And CreatedById IN: mapUsers.keyset()];                                                  
                        List<FeedItem> lstFeedItemFunctionalTeam = ctrlFeedItem.getFunctionalTeamFeedItems(lstRisk[0].Id,mapUsers);                      
                        fillFunctionalTeamFileList(lstAttachmentFunctionalTeam,lstFeedItemFunctionalTeam);
                    }    
                }
            }             
        } 
        EmptyLists();
    }
    
    Public void fillFunctionalTeamFileList(List<Attachment> lstAttachment,List<FeedItem> lstFeedItemsFT){
        String[] arrHostName = ApexPages.currentPage().getHeaders().get('Host').split('visual');        
        wrpFunctionalTeam objwrpFunctionalTeam;
        if(lstAttachment != null && lstAttachment.size()>0){    
            for(Attachment objAttach:lstAttachment){
                objwrpFunctionalTeam = New wrpFunctionalTeam();
                objwrpFunctionalTeam.strId = objAttach.Id;                
                objwrpFunctionalTeam.strType =  'https://'+arrHostName[0]+'content.force.com/servlet/servlet.FileDownload?file='+objwrpFunctionalTeam.strId;
                objwrpFunctionalTeam.strFileName = objAttach.Name;
                objwrpFunctionalTeam.strReferencePages = objAttach.Description;
                lstwrpFunctionalTeam.Add(objwrpFunctionalTeam);
            }  
        }
        if(lstFeedItemsFT != null && lstFeedItemsFT.size()>0){
             for(FeedItem objFeed: lstFeedItemsFT){
                objwrpFunctionalTeam = New wrpFunctionalTeam();
                objwrpFunctionalTeam.strId = objFeed.RelatedRecordId;               
                objwrpFunctionalTeam.strType = 'https://'+arrHostName[0]+'content.force.com/sfc/servlet.shepherd/version/download/'+objwrpFunctionalTeam.strId+'?asPdf=false&operationContext=CHATTER';
                objwrpFunctionalTeam.strFileName = objFeed.ContentFileName;
                objwrpFunctionalTeam.strReferencePages = objFeed.ContentDescription;
                lstwrpFunctionalTeam.Add(objwrpFunctionalTeam);
            }  
        }
    }
    
    Public void retrievePCNRequestUpdateInformation(){    
        lstFeedItems = New List<FeedItem>();                                
        System.debug('####strRecordTypeName =='+strRecordTypeName );        
        if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordTypeName) == false){ 
            if(strRecordTypeName == 'Performance'){ 
                if(lstPerformance.size()>0){                    
                    strCountryTeanJustification = lstPerformance[0].Country_Team_Justification__c;
                    strCTSuggestedPerfRating = lstPerformance[0].CT_Suggested_Performance_Rating__c;                     
                    lstFeedItems  = ctrlFeedItem.getFeedItems(lstPerformance[0].Id);
                }
            }
            else if(strRecordTypeName == 'Impact'){
                if(lstImpact.size()>0){  
                    strCTSuggestedImpRating = lstPerformance[0].CT_Suggested_Impact_Rating__c;                                     
                    strCountryTeanJustification = lstImpact[0].Country_Team_Justification__c;                      
                    lstFeedItems  = ctrlFeedItem.getFeedItems(lstImpact[0].Id);
                }
            }
            else if(strRecordTypeName == 'Increasing_Rate_of_Infection'){
                if(lstIncreasingReatofInfection.size()>0){                                        
                    strCountryTeanJustification = lstIncreasingReatofInfection[0].Country_Team_Justification__c;                   
                    strAffectedSubPopulation = lstIncreasingReatofInfection[0].Affected_Subpopulation_s__c;                    
                    lstFeedItems  = ctrlFeedItem.getFeedItems(lstIncreasingReatofInfection[0].Id);
                }
            }
            else if(strRecordTypeName == 'Risk'){
                if(lstRisk.size()>0){  
                    strCountryTeanJustification = lstRisk[0].Country_Team_Justification__c;                      
                    lstFeedItems  = ctrlFeedItem.getFeedItems(lstRisk[0].Id);
                }
            }
            else if(strRecordTypeName == 'Absorptive_Capacity'){
                if(lstAbsorptiveCapacity.size()>0){   
                    if(strShowJustifiedAllocation == 'Justified Allocation') {
                        strCountryTeanJustification = lstAbsorptiveCapacity[0].CT_Justification_for_Proposed_Allocation__c; 
                    } else {                 
                        strCountryTeanJustification = lstAbsorptiveCapacity[0].Country_Team_Justification__c;                   
                    }
                    lstFeedItems  = ctrlFeedItem.getFeedItems(lstAbsorptiveCapacity[0].Id);
                }
            }
            else if(strRecordTypeName == 'Final_Allocation_Absorptive_Capacity'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0){                    
                    strCountryTeanJustification = lstFinalAllocationAbsorptiveCapacity[0].Country_Team_Justification__c;                     
                    lstFeedItems  = ctrlFeedItem.getFeedItems(lstFinalAllocationAbsorptiveCapacity[0].Id);
                }
            } 
            FeedItem objFeedItemNew = New FeedItem();   
            lstFeedItems.Add(objFeedItemNew);   
        }
        EmptyLists();
    }
    
    Public void fillFeedItemList(String strParentId){
        List<FeedItem> lstFeedItemToInsert = New List<FeedItem>();                     
        if(lstFeedItems != null && lstFeedItems.size()>0){ 
             for(FeedItem objFeed: lstFeedItems){ 
                 if(objFeed.Id == null){
                     if(objFeed.ContentData != null){                                                                    
                         objFeed.ParentId = strParentId;
                         objFeed.ContentDescription = 'See pg. '+ objFeed.ContentDescription;  
                         lstFeedItemToInsert.Add(objFeed);
                     } 
                 }                          
             }
             if(lstFeedItemToInsert.size()>0) Upsert lstFeedItemToInsert;
        }
    }
    
    Public void uploadPCNRequestUpdatedFile(){
        if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordTypeName) == false){            
           if(strRecordTypeName == 'Performance'){               
               if(lstPerformance.size()>0){   
                    lstPerformance[0].Country_Team_Justification__c = strCountryTeanJustification;  
                    Update lstPerformance;                                  
                    fillFeedItemList(lstPerformance[0].Id);
                }
            }
            else if(strRecordTypeName == 'Impact'){
                if(lstImpact.size()>0){        
                    lstImpact[0].Country_Team_Justification__c = strCountryTeanJustification; 
                    Update lstImpact;                                                  
                    fillFeedItemList(lstImpact[0].Id);                    
                }
            }
            else if(strRecordTypeName == 'Increasing_Rate_of_Infection'){
                if(lstIncreasingReatofInfection.size()>0){       
                    lstIncreasingReatofInfection[0].Country_Team_Justification__c = strCountryTeanJustification;  
                    Update lstIncreasingReatofInfection;                                                     
                    fillFeedItemList(lstIncreasingReatofInfection[0].Id);                   
                }
            }
            else if(strRecordTypeName == 'Risk'){
                if(lstRisk.size()>0){   
                    lstRisk[0].Country_Team_Justification__c = strCountryTeanJustification; 
                    Update lstRisk;               
                    fillFeedItemList(lstRisk[0].Id);
                }
            }
            else if(strRecordTypeName == 'Absorptive_Capacity'){
                if(lstAbsorptiveCapacity.size()>0){      
                //change start 
                    System.debug('@@@@@@@@in Save' + strShowJustifiedAllocation );
                    if(strShowJustifiedAllocation == 'Justified Allocation') {
                        
                        lstAbsorptiveCapacity[0].CT_Justification_for_Proposed_Allocation__c = strCountryTeanJustification; 
                    } else {
                        lstAbsorptiveCapacity[0].Country_Team_Justification__c = strCountryTeanJustification;
                    }                    
                //change end     
                   Update lstAbsorptiveCapacity;                                 
                   fillFeedItemList(lstAbsorptiveCapacity[0].Id);                   
                }
            }
            else if(strRecordTypeName == 'Final_Allocation_Absorptive_Capacity'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0){ 
                   lstFinalAllocationAbsorptiveCapacity[0].Country_Team_Justification__c = strCountryTeanJustification;
                   Update lstFinalAllocationAbsorptiveCapacity;                      
                   fillFeedItemList(lstFinalAllocationAbsorptiveCapacity[0].Id);
                }
            }                      
         }       
         
         retrievePCNRequestUpdateInformation();                     
         EmptyLists(); 
    }
    
    Public void savePCNRequestUpdated() {       
        
      if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordTypeName) == false){            
           if(strRecordTypeName == 'Performance'){               
               if(lstPerformance.size()>0){          
                    system.debug('^^^^strCountryTeanJustification=='+strCountryTeanJustification);    
                    lstPerformance[0].Country_Team_Justification__c = strCountryTeanJustification;                                        
                    Update lstPerformance;                
                    //fillFeedItemList(lstPerformance[0].Id);
                }
            }
            else if(strRecordTypeName == 'Impact'){
                if(lstImpact.size()>0){                                       
                    lstImpact[0].Country_Team_Justification__c = strCountryTeanJustification;
                    Update lstImpact;
                    //fillFeedItemList(lstImpact[0].Id);                    
                }
            }
            else if(strRecordTypeName == 'Increasing_Rate_of_Infection'){
                if(lstIncreasingReatofInfection.size()>0){                                        
                    lstIncreasingReatofInfection[0].Country_Team_Justification__c = strCountryTeanJustification;
                    lstIncreasingReatofInfection[0].Affected_Subpopulation_s__c = strAffectedSubPopulation;
                    Update lstIncreasingReatofInfection;
                    //fillFeedItemList(lstIncreasingReatofInfection[0].Id);                   
                }
            }
            else if(strRecordTypeName == 'Risk'){
                if(lstRisk.size()>0){  
                    lstRisk[0].Country_Team_Justification__c = strCountryTeanJustification;
                    Update lstRisk;
                    //fillFeedItemList(lstRisk[0].Id);
                }
            }
            else if(strRecordTypeName == 'Absorptive_Capacity'){
                if(lstAbsorptiveCapacity.size()>0){                   
                //change start 
                
                   //lstAbsorptiveCapacity[0].Country_Team_Justification__c = strCountryTeanJustification;
                    System.debug('@@@@@@@@in Save' + strShowJustifiedAllocation );
                    if(strShowJustifiedAllocation == 'Justified Allocation') {
                        
                        lstAbsorptiveCapacity[0].CT_Justification_for_Proposed_Allocation__c = strCountryTeanJustification; 
                    } else {
                        lstAbsorptiveCapacity[0].Country_Team_Justification__c = strCountryTeanJustification;
                    }
                    lstAbsorptiveCapacity[0].Cap_Amount_Provided__c = decCapAmountAC;                    
                //change end     
                   Update lstAbsorptiveCapacity;
                   //fillFeedItemList(lstAbsorptiveCapacity[0].Id);                   
                }
            }
            else if(strRecordTypeName == 'Final_Allocation_Absorptive_Capacity'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0){                    
                    lstFinalAllocationAbsorptiveCapacity[0].Country_Team_Justification__c = strCountryTeanJustification;
                    Update lstFinalAllocationAbsorptiveCapacity;
                   // fillFeedItemList(lstFinalAllocationAbsorptiveCapacity[0].Id);
                }
            }                      
         }
         if(!Test.IsRunningTest()){
             retrievePCNRecord(); 
         }          
         ShowRequestUpdatePanel = 'No';
         
         EmptyLists();
    }
    
    //Added  start
    Public pagereference changePCNStatusToRequestUpdatedSubmitted() {
        savePCNRequestUpdated();  
        system.debug('%%%%strRecordTypeName=='+strRecordTypeName);      
        if(String.IsBlank(strCNId) == false) {            
            System.debug('@@@@@@@@@@@ lstAbsorptiveCapacity[0].Status__c ' + lstAbsorptiveCapacity[0].Status__c );
            if(lstAbsorptiveCapacity.size()>0){
                if(lstAbsorptiveCapacity[0].Status__c == 'Cap Amount Provided') {
                    lstAbsorptiveCapacity[0].Status__c = 'Cap Amount Submitted';
                }
                if(lstAbsorptiveCapacity[0].Status__c == 'Proposed Allocation Justified') {
                    lstAbsorptiveCapacity[0].Status__c = 'Proposed Allocation Justification Submitted';
                }              
                Update lstAbsorptiveCapacity; 
               }
                //added start  
                if(lstOtherConsideration.size() > 0) {
                  if(lstOtherConsideration[0].Status__c == 'Other Considerations Provided') {
                        lstOtherConsideration[0].Status__c = 'Other Considerations Submitted';
                    }
                    if(lstOtherConsideration[0].Status__c == 'No Other Considerations Provided') {
                        lstOtherConsideration[0].Status__c = 'No Other Considerations Submitted';
                    }              
                    Update lstOtherConsideration;               
                }
                if((lstAbsorptiveCapacity.size()>0 && (lstAbsorptiveCapacity[0].Status__c == 'Cap Amount Submitted' ||  lstAbsorptiveCapacity[0].Status__c == 'Proposed Allocation Justification Submitted' || lstAbsorptiveCapacity[0].Status__c == 'No Review Required'))
                   && (lstOtherConsideration.size()>0 && (lstOtherConsideration[0].Status__c == 'Other Considerations Submitted' ||  lstOtherConsideration[0].Status__c == 'No Other Considerations Submitted'))) {
                   //if(objConceptNote.Absorptive_Capacity_Review_Status__c == 'Under Review') 
                   objConceptNote.Absorptive_Capacity_Review_Status__c = 'Submitted'; 
                   system.debug('%%%%objConceptNote.Absorptive_Capacity_Review_Status__c=='+objConceptNote.Absorptive_Capacity_Review_Status__c);   
                   update objConceptNote;                    
                }  
                
                if(lstAbsorptiveCapacity.size()>0 && objConceptNote != null && lstAbsorptiveCapacity[0].Cap_Amount_Provided__c != null &&
                   ((objConceptNote.Maximum__c != null && lstAbsorptiveCapacity[0].Cap_Amount_Provided__c > objConceptNote.Maximum__c) || (objConceptNote.Minimum__c != null && lstAbsorptiveCapacity[0].Cap_Amount_Provided__c < objConceptNote.Minimum__c))){
                  objConceptNote.Range_Violated__c = true;
                  Update objConceptNote;
                } 
                
                
                if(lstOtherConsideration.size()>0 && objConceptNote != null && objConceptNote.Final_Allocation__c != null && lstOtherConsideration[0].Other_Considerations_Proposed_Amount__c != null &&
                   ((objConceptNote.Maximum__c != null && (objConceptNote.Final_Allocation__c + lstOtherConsideration[0].Other_Considerations_Proposed_Amount__c) > objConceptNote.Maximum__c) || (objConceptNote.Minimum__c != null && (objConceptNote.Final_Allocation__c + lstOtherConsideration[0].Other_Considerations_Proposed_Amount__c) < objConceptNote.Minimum__c))){
                  objConceptNote.Range_Violated__c = true;
                  Update objConceptNote;
                }     
               //added end
                  
           
        }
        return null;
    }
    //Added  End
    Public pagereference changePCNStatusToRequestUpdated() {
        savePCNRequestUpdated();                  
        system.debug('%%%%strRecordTypeName=='+strRecordTypeName);      
        if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordTypeName) == false){ 
            if(strRecordTypeName == 'Performance'){     
               if(lstPerformance.size()>0){                    
                    lstPerformance[0].Status__c = 'Update Requested';                                       
                    Update lstPerformance;                   
                }
            }
            else if(strRecordTypeName == 'Impact'){
                if(lstImpact.size()>0){                   
                    lstImpact[0].Status__c = 'Update Requested'; 
                    Update lstImpact;
                }
            }
            else if(strRecordTypeName == 'Increasing_Rate_of_Infection'){
                if(lstIncreasingReatofInfection.size()>0){                     
                    lstIncreasingReatofInfection[0].Status__c = 'Update Requested';                    
                    Update lstIncreasingReatofInfection;                   
                }
            }
            else if(strRecordTypeName == 'Risk'){
                if(lstRisk.size()>0){                    
                    lstRisk[0].Status__c = 'Update Requested';
                    Update lstRisk;                   
                }
            }
            else if(strRecordTypeName == 'Absorptive_Capacity'){
                //START UPDATE 
                lstAbsorptiveCapacity[0].Cap_Amount_Provided__c = decCapAmountAC;
                if(lstAbsorptiveCapacity.size()>0){
                   if(strShowJustifiedAllocation == 'Set Cap Amount') {
                       lstAbsorptiveCapacity[0].Status__c = 'Cap Amount Provided';
                   }
                   else if(strShowJustifiedAllocation == 'Justified Allocation') {
                       lstAbsorptiveCapacity[0].Status__c = 'Proposed Allocation Justified';
                   }
                   else {
                      // lstAbsorptiveCapacity[0].Status__c = 'Update Requested';
                   }                   
                   
                   Update lstAbsorptiveCapacity;                               
                }
                /*if(lstAbsorptiveCapacity.size()>0){
                   lstAbsorptiveCapacity[0].Status__c = 'Update Requested';
                   Update lstAbsorptiveCapacity;                               
                }*/
                
                //END UPDATE 
                
            }
            else if(strRecordTypeName == 'Final_Allocation_Absorptive_Capacity'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0){                    
                    lstFinalAllocationAbsorptiveCapacity[0].Status__c = 'Update Requested';
                    Update lstFinalAllocationAbsorptiveCapacity;                  
                }
            }           
            /*if(objConceptNote != null){
                Update objConceptNote;
            }*/    
    
        }
               
        if(!Test.IsRunningTest()){
             retrievePCNRecord(); 
        }  
        preventSubmitAll(); 
        ShowRequestUpdatePanel = 'No';
        //ShowRequestUpdatePanelOther = 'No';
        EmptyLists();        
        return null;        
    }
    
    //To Delete RequestUpdate Upload File
    Public void removeRequestUpdateUploadFiles(){
        Integer intIndex = Integer.valueof(Apexpages.currentPage().getParameters().get('Index'));    
        if(intIndex != null){           
           if(lstFeedItems[intIndex] != null && lstFeedItems[intIndex].Id != null){
                Delete lstFeedItems[intIndex];
           }
           lstFeedItems.remove(intIndex);
        }
        retrievePCNRequestUpdateInformation();            
    }
    
    //To Delete Other Consideration Upload File
    Public void removeOtherConsiderationFile(){
        Integer intIndex = Integer.valueof(Apexpages.currentPage().getParameters().get('OIndex'));    
        if(intIndex != null){           
           if(lstFeedItemsOtherConsideration[intIndex] != null && lstFeedItemsOtherConsideration[intIndex].Id != null){
                Delete lstFeedItemsOtherConsideration[intIndex];
           }
           lstFeedItemsOtherConsideration.remove(intIndex);
        }
        retrieveOtherConsiderations();
        
        //ADDED NEW
        AddNewFileOtherConsideration();
        
        
    }
    
    //To Delete Final Other Consideration Upload File
    Public void removeFinalOtherConsiderationFile(){
        Integer intIndex = Integer.valueof(Apexpages.currentPage().getParameters().get('FOIndex'));    
        if(intIndex != null){           
           if(lstFeedItemsFinalOtherConsideration[intIndex] != null && lstFeedItemsFinalOtherConsideration[intIndex].Id != null){
                Delete lstFeedItemsFinalOtherConsideration[intIndex];
           }
           lstFeedItemsFinalOtherConsideration.remove(intIndex);
        }
        retrieveOtherConsiderations();
    }
    
    Public void preventSubmitAll(){  
        system.debug('@@@111blnIsDisableSubmitAll=='+blnIsDisableSubmitAll);      
        if(!String.IsBlank(strCNId)){
          
           if((lstImpact.Size() > 0 && lstImpact[0].Status__c == 'Under CT Review') 
               || (lstPerformance.Size() >0 && lstPerformance[0].Status__c == 'Under CT Review') 
               || (lstIncreasingReatofInfection.size()>0 && lstIncreasingReatofInfection[0].Status__c == 'Under CT Review')
               || (lstRisk.size() > 0 && lstRisk[0].Status__c == 'Under CT Review') 
               || objConceptNote.P_I_IR_Review_Deadline__c == null) {  
                            
              blnIsDisableSubmitAll = true;             
           }           
           else{               
               blnIsDisableSubmitAll = false;                
           }           
           
           if(lstAbsorptiveCapacity.size()> 0 && lstAbsorptiveCapacity[0].Status__c == 'Under CT Review'){               
               blnIsDisableSubmitAC = true;     
           }
           else{
               blnIsDisableSubmitAC = false;    
           }
        }
        system.debug('@@@blnIsDisableSubmitAll=='+blnIsDisableSubmitAll);
        EmptyLists();
    }
   
    //To set status based on record types.
    Public void SetStatusImpactPerformance() {
        if(String.IsBlank(strCNId) == false){            
            if(objConceptNote != null){
               if(objConceptNote.Performance_Impact_Rate_Risk_Stage__c == 'Finalized'){
                   objConceptNote.P_I_IR_and_Risk_Status__c = 'Data Finalized';                   
               }
               else{
                    if(lstImpact.Size() > 0 || lstPerformance.Size() > 0 || lstIncreasingReatofInfection.Size() > 0 || lstRisk.size()>0){
                        if((lstImpact.Size() > 0 && lstImpact[0].Status__c == 'Under CT Review') || (lstPerformance.Size() >0 && lstPerformance[0].Status__c == 'Under CT Review') || (lstIncreasingReatofInfection.size()>0 && lstIncreasingReatofInfection[0].Status__c == 'Under CT Review') || (lstRisk.size() > 0 && lstRisk[0].Status__c == 'Under CT Review')) {
                            objConceptNote.P_I_IR_and_Risk_Status__c = 'Under Review';   
               
                        }
                        else if (lstImpact.Size() > 0 && lstImpact[0].Status__c == 'Accepted' && lstPerformance.Size() > 0  && 
                            lstPerformance[0].Status__c == 'Accepted' && lstIncreasingReatofInfection.Size() > 0 && lstIncreasingReatofInfection[0].Status__c == 'Accepted' && 
                               lstRisk.size()>0 && lstRisk[0].Status__c == 'Accepted') {
                            objConceptNote.P_I_IR_and_Risk_Status__c = 'Accepted';
                        }
                        else if((lstImpact.Size() > 0 && lstImpact[0].Status__c == 'Update Requested') || 
                            (lstPerformance.Size() > 0 && lstPerformance[0].Status__c == 'Update Requested')
                             || (lstIncreasingReatofInfection.Size() > 0 && lstIncreasingReatofInfection[0].Status__c == 'Update Requested')
                              || (lstRisk.size()>0 && lstRisk[0].Status__c == 'Update Requested')){
                            objConceptNote.P_I_IR_and_Risk_Status__c = 'Update Requested'; 
                        }
                        else{
                            objConceptNote.P_I_IR_and_Risk_Status__c = 'Data Finalized'; 
                        }
                    }
              }
            }
        }   
        EmptyLists();    
    }    
   
    //Click on Set Cap Amount  --- this method is referenced by a command link on VF 2603, a section with style="display:none"
    Public void SetCapAmountPopUp() {
        if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordTypeName) == false){      
            if(strRecordTypeName == 'Absorptive_Capacity'){
                if(lstAbsorptiveCapacity.size()>0){
                    //lstAbsorptiveCapacity[0].Cap_Amount_Provided__c = decCapAmountProvided; commented out MM, this is the wrong var
                    lstAbsorptiveCapacity[0].Cap_Amount_Provided__c = decCapAmountAC;
                    Update lstAbsorptiveCapacity;
                }
            } 
           else if(strRecordTypeName == 'Final_Allocation_Absorptive_Capacity'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0){
                    lstFinalAllocationAbsorptiveCapacity[0].Cap_Amount_Provided__c = decCapAmountProvided;
                    Update lstFinalAllocationAbsorptiveCapacity;
                }
            } 
        }    
    }
    
    Public void SubmitAbsorptiveCapacity(){ 
        if(!String.Isblank(strCNId)){      
            objConceptNote.Absorptive_Capacity_Stage__c = 'Submitted';
            Update objConceptNote;
            objConceptNote = [Select Id,Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,Absorptive_Capacity_Stage__c,LFA_Verified_Performance_Status__c,P_I_IR_and_Risk_Status__c,Performance_Impact_Rate_Risk_Stage__c From Concept_Note__c
                   Where Id =: strCNId]; 
        }   
    }
    
    Public void Submit(){        
       
        if(!String.Isblank(strCNId)){ 
            if(lstAbsorptiveCapacity.size()>0){     
                objConceptNote.Absorptive_Capacity_Initial_Alloc_Status__c = lstAbsorptiveCapacity[0].Status__c;
                Update objConceptNote;
            }
            objConceptNote = [Select Id,Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,Absorptive_Capacity_Stage__c,LFA_Verified_Performance_Status__c,P_I_IR_and_Risk_Status__c,Performance_Impact_Rate_Risk_Stage__c From Concept_Note__c
                   Where Id =: strCNId]; 
        } 
         SubmitAbsorptiveCapacity();
    }

/////////////////////////////////////////
//***SUBMIT ALL BUTTON FUNCTIONALITY***//
/////////////////////////////////////////    
    Public void SubmitAll(){            
       if(objConceptNote != null){
           if(lstPerformance.size()>0 && lstPerformance[0].Status__c == 'Accepted'){
              lstPerformance[0].Country_Team_Justification__c = '';
              lstPerformance[0].Performance_Rating__c = lstPerformance[0].Initial_Performance_Rating__c;  
              Update lstPerformance;              
              List<FeedItem> lstFIPerformance = ctrlFeedItem.getFeedItems(lstPerformance[0].Id);
              Delete lstFIPerformance;              
           }
           if(lstImpact.size()>0 && lstImpact[0].Status__c == 'Accepted'){
              lstImpact[0].Country_Team_Justification__c = ''; 
              lstImpact[0].Impact_Rating__c = lstImpact[0].Initial_Impact_Rating__c;
              Update lstImpact;              
              List<FeedItem> lstFIImpact = ctrlFeedItem.getFeedItems(lstImpact[0].Id);
              Delete lstFIImpact;              
           }
           if(lstIncreasingReatofInfection.size()>0 && lstIncreasingReatofInfection[0].Status__c == 'Accepted'){
              lstIncreasingReatofInfection[0].Country_Team_Justification__c = '';
              lstIncreasingReatofInfection[0].Increasing_Rate_of_Infection__c = lstIncreasingReatofInfection[0].Initial_Increasing_Rate_of_infection__c;
              Update lstIncreasingReatofInfection;             
              List<FeedItem> lstFIlstIncreasingReatofInfection = ctrlFeedItem.getFeedItems(lstIncreasingReatofInfection[0].Id);
              Delete lstFIlstIncreasingReatofInfection;              
           }
           if(lstRisk.size()>0 && lstRisk[0].Status__c == 'Accepted'){
              lstRisk[0].Country_Team_Justification__c = '';
              lstRisk[0].Qualifies_for_Risk_Mitigation__c = lstRisk[0].Initial_Qualifies_for_Risk_Mitigation__c;  
              Update lstRisk;                            
              List<FeedItem> lstFIlstRisk = ctrlFeedItem.getFeedItems(lstRisk[0].Id);
              Delete lstFIlstRisk;              
           }
           //SetStatusImpactPerformance();
           objConceptNote.Performance_Impact_Rate_Risk_Stage__c = 'Submitted';
           Update objConceptNote;
           objConceptNote = [Select Id,Absorptive_Capacity_Initial_Alloc_Status__c,LFA_Verified_Performance_Status__c,Absorptive_Capacity_Stage__c,Absorptive_Capacity_Review_Status__c, P_I_IR_and_Risk_Status__c,Performance_Impact_Rate_Risk_Stage__c From Concept_Note__c
               Where Id =: strCNId];
        }
         EmptyLists();
    }   
  
    Public void retrieveOtherConsiderations() {
        lstFeedItemsOtherConsideration = New List<FeedItem>();
        lstFeedItemsFinalOtherConsideration = New List<FeedItem>();
        if(String.IsBlank(strCNId) == false){
            system.debug('%%%%%lstAbsorptiveCapacity=='+lstAbsorptiveCapacity);
            //if(lstAbsorptiveCapacity.size()>0) { 
            if(lstOtherConsideration.size()>0) {    
             //  strOtherConsideration = lstAbsorptiveCapacity[0].Absorptive_Capacity_Other_Considerations__c; 
               strOtherConsideration = lstOtherConsideration[0].Other_Considerations__c;               
               lstFeedItemsOtherConsideration   =  ctrlFeedItem.getFeedItems(lstOtherConsideration[0].Id);
               decSProposedAmountAC =  lstOtherConsideration[0].Other_Considerations_Proposed_Amount__c;
               //decCapAmountAC = lstOtherConsideration[0].Cap_Amount_Provided__c; commented out by MM
            }
             if(lstFinalAllocationAbsorptiveCapacity.size()>0) {    
               // strFinalOtherConsideration = lstFinalAllocationAbsorptiveCapacity[0].Final_Other_Considerations__c;
               strFinalOtherConsideration = lstFinalAllocationAbsorptiveCapacity[0].Other_Considerations__c;               
               lstFeedItemsFinalOtherConsideration =  ctrlFeedItem.getFeedItems(lstFinalAllocationAbsorptiveCapacity[0].Id);               
               decSProposedAmountFAC = lstFinalAllocationAbsorptiveCapacity[0].Other_Considerations_Proposed_Amount__c;
               decCapAmountFAC = lstFinalAllocationAbsorptiveCapacity[0].Cap_Amount_Provided__c;
            }
        }
        EmptyLists();
    }
    
    Public void uploadOtherConsiderationsFiles(){
         String strRecordtypeName = Apexpages.CurrentPage().getParameters().get('RecordType');
         if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordtypeName) == false) {      
            if(strRecordtypeName == 'Other_Considerations'){
                if(lstOtherConsideration.size()>0) { 
                  //  lstAbsorptiveCapacity[0].Absorptive_Capacity_Other_Considerations__c = strOtherConsideration;
                    lstOtherConsideration[0].Other_Considerations__c = strOtherConsideration;
                    lstOtherConsideration[0].Other_Considerations_Proposed_Amount__c = decSProposedAmountAC;
                    //lstOtherConsideration[0].Cap_Amount_Provided__c = decCapAmountAC; commented out by MM
                    Update lstOtherConsideration;                                        
                    List<FeedItem> lstFeedItemToInsert = New List<FeedItem>();
                    if(lstFeedItemsOtherConsideration != null && lstFeedItemsOtherConsideration.size()>0){ 
                         for(FeedItem objFeed: lstFeedItemsOtherConsideration){ 
                             if(objFeed.Id == null){
                                 if(objFeed.ContentData != null){                                                                             
                                     objFeed.ParentId = lstOtherConsideration[0].Id;  
                                     objFeed.ContentDescription = 'See pg. '+ objFeed.ContentDescription; 
                                     lstFeedItemToInsert.Add(objFeed); 
                                 }
                             }                                                    
                         }
                         if(lstFeedItemToInsert.size()>0) Upsert lstFeedItemToInsert;
                     }                    
                }
            } 
           else if(strRecordtypeName == 'Final_Allocation_Absorptive_Capacity'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0) { 
                   // lstFinalAllocationAbsorptiveCapacity[0].Final_Other_Considerations__c = strFinalOtherConsideration;
                    lstFinalAllocationAbsorptiveCapacity[0].Other_Considerations__c = strFinalOtherConsideration;
                    lstFinalAllocationAbsorptiveCapacity[0].Other_Considerations_Proposed_Amount__c = decSProposedAmountFAC;
                    lstFinalAllocationAbsorptiveCapacity[0].Cap_Amount_Provided__c = decCapAmountFAC;
                    Update lstFinalAllocationAbsorptiveCapacity;                                        
                    List<FeedItem> lstFeedItemToInsert = New List<FeedItem>();
                    if(lstFeedItemsFinalOtherConsideration != null && lstFeedItemsFinalOtherConsideration.size()>0){ 
                         for(FeedItem objFeed: lstFeedItemsFinalOtherConsideration){
                             if(objFeed.Id == null){ 
                                 if(objFeed.ContentData != null){                                               
                                     objFeed.ParentId = lstFinalAllocationAbsorptiveCapacity[0].Id;  
                                     objFeed.ContentDescription = 'See pg. '+ objFeed.ContentDescription; 
                                     lstFeedItemToInsert.Add(objFeed); 
                                 }  
                             }                         
                         }
                         if(lstFeedItemToInsert.size()>0) Upsert lstFeedItemToInsert;
                    }                  
                }
            } 
        }
        retrieveOtherConsiderations();
        AddNewFileOtherConsideration();
        AddNewFileFinalOtherConsideration();
    }
    Public void SaveOtherConsiderations() {
        system.debug('****strRecordtypeName=='+strRecordtypeName);
        system.debug('****strOtherConsideration=='+strOtherConsideration);
        if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordtypeName) == false) {      
            if(strRecordtypeName == 'Other_Considerations'){
                if(lstOtherConsideration.size()>0) {                    
                  //  lstAbsorptiveCapacity[0].Absorptive_Capacity_Other_Considerations__c = strOtherConsideration;
                    lstOtherConsideration[0].Other_Considerations__c = strOtherConsideration;
                    lstOtherConsideration[0].Other_Considerations_Proposed_Amount__c = decSProposedAmountAC;
                    //lstOtherConsideration[0].Cap_Amount_Provided__c = decCapAmountAC; commented out by MM
                    
                    //ADDED START
                    if(strUpdateOtherConsideration == 'SaveOther') {
                        lstOtherConsideration[0].Status__c = 'Other Considerations Provided';
                    }
                    if(strUpdateOtherConsideration == 'NoOther') {
                        lstOtherConsideration[0].Status__c = 'No Other Considerations Provided';
                    }
                    
                    //ADDED END
                    
                    Update lstOtherConsideration;                          
                }
            } 
           else if(strRecordtypeName == 'Final_Allocation_Absorptive_Capacity'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0) {                   
                   // lstFinalAllocationAbsorptiveCapacity[0].Final_Other_Considerations__c = strFinalOtherConsideration;
                    lstFinalAllocationAbsorptiveCapacity[0].Other_Considerations__c = strFinalOtherConsideration;
                    lstFinalAllocationAbsorptiveCapacity[0].Other_Considerations_Proposed_Amount__c = decSProposedAmountFAC;
                    lstFinalAllocationAbsorptiveCapacity[0].Cap_Amount_Provided__c = decCapAmountFAC;
                    Update lstFinalAllocationAbsorptiveCapacity;                            
                }
            } 
        }
        ShowRequestUpdatePanelOther = 'No';  
        EmptyLists();
         
    }
    
    Public void SubmitOtherConsiderations() {        
        SaveOtherConsiderations();
        if(String.IsBlank(strCNId) == false && String.IsBlank(strRecordtypeName) == false) {      
            if(strRecordtypeName == 'Other_Considerations'){
                if(lstOtherConsideration.size()>0) {                   
                    //lstOtherConsideration[0].Status__c = 'Other Considerations Submitted';
                    if(lstOtherConsideration[0].Status__c == 'Draft Other Considerations Saved') {
                        lstOtherConsideration[0].Status__c = 'Other Considerations Submitted';
                    }
                    if(lstOtherConsideration[0].Status__c == 'No Other Considerations Entered') {
                        lstOtherConsideration[0].Status__c = 'No Other Considerations Submitted';
                    }
                    
                    Update lstOtherConsideration;     
                    //added start  
                   if(lstAbsorptiveCapacity.size() > 0) {
                       if((lstAbsorptiveCapacity[0].Status__c == 'Cap Amount Submitted' ||  lstAbsorptiveCapacity[0].Status__c == 'Proposed Allocation Justification Submitted')
                           && (lstOtherConsideration[0].Status__c == 'Other Considerations Submitted' ||  lstOtherConsideration[0].Status__c == 'No Other Considerations Submitted')) {
                               if(objConceptNote.Absorptive_Capacity_Review_Status__c == 'Under Review') 
                                   objConceptNote.Absorptive_Capacity_Review_Status__c = 'Submitted';    
                               update objConceptNote;                    
                           }
                   
                   }
                   //added end                                
                }
            } 
           else if(strRecordtypeName == 'Final_Other_Considerations'){
                if(lstFinalAllocationAbsorptiveCapacity.size()>0) {                   
                    lstFinalAllocationAbsorptiveCapacity[0].Status__c = 'Other Considerations Submitted';
                    Update lstFinalAllocationAbsorptiveCapacity;                        
                }
            } 
        }  
        EmptyLists(); 
    }    
    
    Public Class wrpFunctionalTeam{
        Public String strId{get;set;}
        Public String strType{get;set;}
        Public String strFileName{get;set;}
        Public String strReferencePages{get;set;}
    }
}