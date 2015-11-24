Public without sharing Class CNImplementers_Temp1{
    Public String strConceptNoteId {get;set;}
    Public String strPageId;
    //Public List<wrapGoalsObjectives> lstGoalsObjectives {get;set;}
    Public List<wrapPrincipalRecipients> lstPrincipalRecipients {get;set;}
    
    Public Boolean blnConfirmDelete {get;set;}
    Public Boolean blnConfirmIndicatorDelete {get;set;}
    Public Boolean blnReadOnly {get;set;}
    
    Public Grant_Indicator__c objNewIndicator {get;set;}
    Public Grant_Indicator__c objNewStdIndicator {get;set;}
    Public list<SelectOption> CatalogIndicatorOptions {get;set;}   
    
    Public List<SelectOption> AccountOptions {get;set;}
    Public List<SelectOption> NewGrantExistingOptions {get;set;}
    Public List<SelectOption> NewGrantOptions {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public Map<Id,Integer> mapGoalIdToIndex;
    Public String CNComponent;
    Public String CNCountry;
    Public Set<Id> setIndicatorId;
    Public List<Indicator__c> lstCatalogIndicator {get;set;}
    Public String setAddGoalCustom {get;set;}
    Public String setAddGoalStandard {get;set;}
    Public String strNewPRName {get;set;}
    Public Account objNewAccount {get;set;}
    Public Account objNewExistingAccount {get;set;}
    Public String SelectedAccId {get;set;}
    Public String GrantExistingName {get;set;}
    
    Public String strPRshortname {get;set;}
    Public String strNewGoalDescription {get;set;}
    
    Public String strLanguage {get;set;}
    Public String strOverview {get;set;}
    Public String strConceptNotes {get;set;}
    Public String strSummary {get;set;}
    Public String strGoalsAndImpactIndicators {get;set;}
    Public String strObjectivesAndOutcomeIndicators {get;set;}
    Public String strModulesAndInterventions {get;set;}
    Public String strGuidance {get;set;}
    Public String strclosePanelLabel {get;set;}
    Public String strGoals {get;set;}
    Public String strImpactIndicators {get;set;}
    Public String strAreYouSure {get;set;}
    Public String strGoalDeleted {get;set;}
    Public String strIndicatorDeleted {get;set;}
    Public String strLinkedToGoals {get;set;}
    Public String strBaseline {get;set;}
    Public String strValue {get;set;}
    Public String strYear {get;set;}
    Public String strSource {get;set;}
    Public String strTargets {get;set;}
    Public String strComments {get;set;}
    Public String strDataType {get;set;}
    Public String strSelectCatalogIndicator {get;set;}
    Public String strSeeHelp {get;set;}
    Public String strADDGOAL {get;set;}
    Public String strEdit {get;set;}
    Public String strDelete {get;set;}
    Public String strSave {get;set;}
    Public String strCancel {get;set;}
    Public String strSelect {get;set;}
    Public String strAddStandardIndicator {get;set;}
    Public String strAddCustomIndicator {get;set;}
    Public List<Page__c> lstPageToDisplay {get;set;}
    Public List<Module__c> lstModules{get;set;}
    Public Date CNStartDate{get;set;}
    Public Date CNEndDate{get;set;}
    Public String CNlengthYear {get;set;}
    Public String CNLocalCurrency {get;set;}
    Public String CNGrantCurrency {get;set;}
    Public Boolean blnExpandSection {get;set;}
    Public boolean blnIsExisting {get;set;}
    Public boolean blnRadioExisting {get;set;}
    Public String strPopupURL {get;set;}
     /* For Custom Setting profile Implementation*/
    public String cnStatus {get;set;}
    public Boolean blnExternalPro {get;set;}
    public Boolean blnEdit {get;set;}
    public Boolean blnDelete {get;set;}
    public Boolean blnAddExistingPR {get;set;}
    public Boolean blnAddNewPR {get;set;}
    /* End  */
    
    
    public CNImplementers_Temp1(ApexPages.StandardController controller) {
        
        //blnReadOnly = CheckProfile.checkProfile();
        strPageId = Apexpages.currentpage().getparameters().get('id');
        blnIsExisting = false;
        if(String.IsBlank(strPageId) == false){
            List<Page__c> lstPage = [Select Concept_note__c,Concept_note__r.Start_Date__c,Concept_Note__r.Status__c,Concept_Note__r.CurrencyISOCode,
                                    Concept_Note__r.Funding_End_Date__c,Concept_note__r.Number_of_Years__c,Concept_note__r.Component__c,
                                    Concept_note__r.Language__c, Concept_Note__r.CCM_new__c, Concept_note__r.CCM_new__r.Country__c,
                                    Concept_Note__r.CCM_New__r.Country__r.Currency__c
                                      From Page__c Where Id =: strPageId And Concept_note__c != null Limit 1];
            
            
            strLanguage = 'ENGLISH';
            if(lstPage.size() > 0) {
                strPopupURL = System.Label.PRBaseUrl +lstPage[0].Concept_Note__c+'&pageId='+strPageId+'&language='+System.UserInfo.getLanguage();
            
                strConceptNoteId = lstPage[0].Concept_note__c;
                CNComponent = lstPage[0].Concept_note__r.Component__c;
                strLanguage = lstPage[0].Concept_note__r.Language__c;
                CNCountry = lstPage[0].Concept_note__r.CCM_new__r.Country__c;
                CNStartDate = lstPage[0].Concept_note__r.Start_Date__c;
                CNEndDate = lstPage[0].Concept_Note__r.Funding_End_Date__c;
                CNlengthYear = lstPage[0].Concept_note__r.Number_of_Years__c;
                CNLocalCurrency = lstPage[0].Concept_note__r.CCM_New__r.Country__r.Currency__c;
                CNGrantCurrency = lstPage[0].Concept_Note__r.CurrencyISOCode;
                
                /*
                if(lstPage[0].Concept_Note__r.Status__c == 'Submitted to the Global Fund'  && CheckProfile.checkProfileGF()==false){
                    blnReadOnly = true; 
                }else if(lstPage[0].Concept_Note__r.Status__c == 'Not yet submitted'){
                    blnReadOnly = CheckProfile.checkProfile();
                } */
                
                 /* For Custom Setting profile Implementation*/
                 cnStatus = lstPage[0].Concept_Note__r.Status__c ;
                 checkProfile();
                 /* End */
                
            }
            getPageText();
            lstPageToDisplay = new List<Page__c>();
            lstPageToDisplay = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Concept_Note__c =: strConceptNoteId  Order by Order__c];
            lstModules = new List<Module__c>();   
            lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Concept_Note__c =: strConceptNoteID Order by Name]; 
        }
        if(String.IsBlank(strConceptNoteId) == false){
            lstPrincipalRecipients = new List<wrapPrincipalRecipients>();
            blnConfirmDelete = false;
            blnConfirmIndicatorDelete = false;
            blndisplaySave = false;
            
            mapGoalIdToIndex = new Map<Id,Integer>();
            lstPrincipalRecipients = new List<wrapPrincipalRecipients>();
            List<Implementation_Period__c> lstGoals = [Select id,Name,Principal_Recipient__c,Principal_Recipient__r.Name,
                                    Principal_Recipient__r.Sub_Type__c,Principal_Recipient__r.Short_Name__c,
                                    Principal_Recipient__r.Type__c,Custom_PR__c,Grant__r.Name,Grant__c,
                                    Principal_Recipient__r.Impact_Outcome_reporting__c, Responsible_for_Impact_Outcome_Reporting__c,
                                    Principal_Recipient__r.Locked__c
                                    From Implementation_Period__c 
                                    Where Concept_Note__c =: strConceptNoteId];
            
            Map<Id,List<Grant__c>> mapPRIdToGrant = new Map<Id,List<Grant__c>>();
            if(lstGoals.size() > 0){
            
                Set<Id> setPRIds = new Set<Id>();
                for(Implementation_Period__c objIP : lstGoals){
                    setPRIds.add(objIP.Principal_Recipient__c);
                }
                if(setPRIds.size() > 0){
                    List<Grant__c> lstGrant = [Select Name,Id,Principal_Recipient__c from Grant__c where Principal_Recipient__c IN: setPRIds];
                    for(Grant__c objGrant : lstGrant){
                        if(mapPRIdToGrant.containskey(objGrant.Principal_Recipient__c)){
                            mapPRIdToGrant.get(objGrant.Principal_Recipient__c).add(objGrant);
                        }else{
                            mapPRIdToGrant.put(objGrant.Principal_Recipient__c,new List<Grant__c>{objGrant});
                        }
                    }
                }
            }
            
            if(lstGoals.size() > 0){
                Integer Count = 1;
                for(Implementation_Period__c objIP : lstGoals){
                    wrapPrincipalRecipients objWrap = new wrapPrincipalRecipients();
                    objWrap.PRDescription = objIP.Principal_Recipient__r.Name;
                    objWrap.PRType = objIP.Principal_Recipient__r.Type__c;
                    objWrap.PRSubType = objIP.Principal_Recipient__r.Sub_Type__c;
                    objWrap.PRshortname = objIP.Principal_Recipient__r.Short_Name__c;
                    objWrap.AccountId = objIP.Principal_Recipient__c;    
                    objWrap.PRId = objIP.Id;
                    objWrap.implementationPeriod = objIP;                    
                   
                    
                    if(objIP.Custom_PR__c == false){
                        objWrap.CustomPR = true;
                        objWrap.blnExistingPR = true;
                    }else{
                        objWrap.CustomPR = objIP.Custom_PR__c;
                        objWrap.blnExistingPR = false;
                    }
                    objWrap.GrantOptions = new List<SelectOption>();
                    objWrap.GrantOptions.add(new SelectOption('','--None--'));
                    objWrap.GrantName = objIP.Grant__r.Name;
                    if(mapPRIdToGrant.containskey(objIP.Principal_Recipient__c) && 
                        mapPRIdToGrant.get(objIP.Principal_Recipient__c) != null &&
                        mapPRIdToGrant.get(objIP.Principal_Recipient__c).size() > 0){
                        for(Grant__c objG : mapPRIdToGrant.get(objIP.Principal_Recipient__c)){
                            if(objIP.Custom_PR__c == false){
                                objWrap.GrantOptions.add(new SelectOption(objG.Name,objG.Name));
                            }else{
                                objWrap.GrantOptions.add(new SelectOption(objG.Id,objG.Name));
                            }
                        }
                    }
                    objWrap.objAccount = new Account(id = objIP.Principal_Recipient__c,Name = objIP.Principal_Recipient__r.Name,
                                                    Impact_Outcome_reporting__c = objIP.Principal_Recipient__r.Impact_Outcome_reporting__c,
                                                    Type__c = objIP.Principal_Recipient__r.Type__c,
                                                    Sub_Type__c = objIP.Principal_Recipient__r.Sub_Type__c,
                                                    Short_Name__c = objIP.Principal_Recipient__r.Short_Name__c,
                                                    Locked__c = objIP.Principal_Recipient__r.Locked__c);
                    objWrap.blnDisplay = true;
                    lstPrincipalRecipients.add(objWrap);
                    Count ++;
                }
            }
            
            SelectedAccId = null;
            FillAccount();
            FillAccountType();            
            SelectedAccId=null;
            objNewAccount = new Account();
            objNewExistingAccount = new Account();
            NewGrantOptions = new List<SelectOption>();
            NewGrantExistingOptions = new List<SelectOption>();
            NewGrantOptions.add(new SelectOption('','Create New Grant'));
        }
    }   
   
   
    public void getPageText(){
       /* system.debug('#####strLanguage->'+strLanguage);
        if(String.IsBlank(strLanguage) == false){
            Map<String,String> MultiLingualTextMap;
            MultiLingualTextMap = GILanguage.getMultiLingualText(strLanguage,'GoalsAndImpactIndicators');
            if(MultiLingualTextMap !=null && MultiLingualTextMap.size()>0)
            {
                strOverview = MultiLingualTextMap.get('GIOverview');
                strConceptNotes = MultiLingualTextMap.get('GIConceptNotes');
                strSummary = MultiLingualTextMap.get('GISummary');
                strGoalsAndImpactIndicators = MultiLingualTextMap.get('GILabel');
                strObjectivesAndOutcomeIndicators = MultiLingualTextMap.get('GIObjectiveAndOutcome');
                strModulesAndInterventions = MultiLingualTextMap.get('GImodulesandinterventions');
                strGuidance = MultiLingualTextMap.get('GIGuidance');
                strclosePanelLabel = MultiLingualTextMap.get('GIlabelClose');
                strGoals = MultiLingualTextMap.get('GIGoals');
                strImpactIndicators = MultiLingualTextMap.get('GIImpactindicators');
                strAreYouSure = MultiLingualTextMap.get('GIAreyousure');
                strGoalDeleted = MultiLingualTextMap.get('GIGoalWillDeleted');
                strIndicatorDeleted = MultiLingualTextMap.get('GIIndicatorWillDeleted');
                strLinkedToGoals = MultiLingualTextMap.get('GILinkedtogoals');
                strBaseline = MultiLingualTextMap.get('GIBaseline');
                strValue = MultiLingualTextMap.get('GIValue');
                strYear = MultiLingualTextMap.get('GIYear');
                strSource = MultiLingualTextMap.get('GISource');
                strTargets = MultiLingualTextMap.get('GITargets');
                strComments = MultiLingualTextMap.get('GIComments');
                strDataType = MultiLingualTextMap.get('GIDataType');
                strSelectCatalogIndicator = MultiLingualTextMap.get('GIbtnSeeHelp');
                strSeeHelp = MultiLingualTextMap.get('GIbtnSeeHelp');
                strADDGOAL = MultiLingualTextMap.get('GIbtnAddGoal');
                strEdit = MultiLingualTextMap.get('GIbtnEdit');
                strDelete = MultiLingualTextMap.get('GIbtnDelete');
                strSave = MultiLingualTextMap.get('GIbtnSave');
                strCancel = MultiLingualTextMap.get('GIbtnCancel');
                strSelect = MultiLingualTextMap.get('GIbtnSelect');
                strAddStandardIndicator = MultiLingualTextMap.get('GIbtnAddStandardIndicator');
                strAddCustomIndicator = MultiLingualTextMap.get('GIbtnAddCustomIndicator');
            }
        }*/
    }
    
    Public void DeleteGoal(){
        Integer DeleteIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex')); 
        if(DeleteIndex != null){
            Id IpIdToDelete = lstPrincipalRecipients[DeleteIndex].PRId;
            List<Implementation_Period__c> lstIPToDelete = [Select id, Custom_PR__c, Principal_Recipient__c From Implementation_Period__c Where Id =: IpIdToDelete];
            system.debug('$%#$#$'+lstIPToDelete);
                Set<Id> setAccountIds = new Set<Id>();
                for(Implementation_Period__c gip : lstIPToDelete){
                    if(gip.Custom_PR__c){
                        setAccountIds.add(gip.Principal_Recipient__c);
                    }        
                }
            if(lstIPToDelete.size() > 0) Delete lstIPToDelete;
            List<Account> lstAccountToDelete = [Select Id FROM Account WHERE Id in :setAccountIds AND (New_PR_Status__c = 'Pending' OR New_PR_Status__c = 'Rejected')];
            System.Debug('%%% lstAccountToDelete: ' + lstAccountToDelete);
            if(lstAccountToDelete.size() > 0) Delete lstAccountToDelete;
            system.debug('$%#$#$'+lstPrincipalRecipients[DeleteIndex]);
            lstPrincipalRecipients.remove(DeleteIndex);            
            blnConfirmDelete = false;
        }
        
        FillAccount();
        objNewAccount = new Account();
        SelectedAccId=null;
        objNewExistingAccount = new Account();
         
    }
    Public void SaveGoal(){
        system.debug('### save goal--');
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            if(SaveIndex > lstPrincipalRecipients.size()){
                //Account objPR = new Account (Name = strNewPRName, Type__c = strPRType, Sub_Type__c = strPRSubType Short_Name__c = strPRshortname);
                if(objNewAccount != null){

                    objNewAccount.Country__c = CNCountry;
                    insert objNewAccount;
                                        
                    Grant__c objGrantNew = new Grant__c(Name = 'Test',Principal_Recipient__c = objNewAccount.Id,Disease_Component__c = CNComponent,Grant_Status__c = 'Concept Note',Country__c = CNCountry,Start_Date__c = CNStartDate,End_Date__c = CNEndDate);
                    insert objGrantNew;
                    Implementation_Period__c objGoal = new Implementation_Period__c(Principal_Recipient__c = objNewAccount.Id, Concept_Note__c = strConceptNoteId,Custom_PR__c = true,Start_Date__c  = CNStartDate,End_Date__c = CNEndDate, Length_Years__c = CNLengthYear,Local_Currency__c = CNLocalCurrency,Currency_of_Grant_Agreement__c = CNGrantCurrency,Grant__c = objGrantNew.id);
                    insert objGoal;
                    //IP_Detail_Information__c objIPDetail = new IP_Detail_Information__c(Implementation_Period__c = objGoal.Id, Budget_Status__c = 'Not yet submitted by PR');
                    //insert objIPDetail;
                    wrapPrincipalRecipients objwarp = new wrapPrincipalRecipients();
                    objwarp.PRDescription = objNewAccount.Name;
                    objwarp.PRType = objNewAccount.Type__c;
                    objwarp.PRSubType = objNewAccount.Sub_Type__c;
                    objwarp.PRshortname = objNewAccount.Short_Name__c;
                    objwarp.AccountId = objNewAccount.Id;   
                    objwarp.PRId = objGoal.id;
                    objwarp.implementationPeriod = objGoal;
                    objwarp.CustomPR = objGoal.Custom_PR__c;
                    objwarp.blnExistingPR = false;
                    objwarp.objAccount = new Account();
                    objwarp.objAccount = objNewAccount;
                    
                   
                    objwarp.GrantOptions = new List<SelectOption>();
                    objwarp.GrantOptions.add(new SelectOption('','--None--'));
                    List<Implementation_Period__c> IPNewInserted = [Select Grant__c,Grant__r.Name From Implementation_Period__c Where Id =: objGoal.id];
                    if(IPNewInserted.size() > 0) objwarp.GrantName = IPNewInserted[0].Grant__r.Name;
                    
                    List<Grant__c> lstGrant = [Select Id,Name From Grant__c Where Principal_Recipient__c =: objNewAccount.id];
                    if(lstGrant.size() > 0){
                        for(Grant__c objG : lstGrant){
                            objwarp.GrantOptions.add(new SelectOption(objG.Id,objG.Name));
                        }
                    }
                    
                    //if(lstGoalsObjectives.size() > 0) objwarpGoal.IndexGoal = lstGoalsObjectives.size() + 1;
                    //else objwarpGoal.IndexGoal = 1;
                    objwarp.blnDisplay = true;
                    
                    lstPrincipalRecipients.add(objwarp);
                    FillAccount();
                    if (objNewAccount.Impact_Outcome_reporting__c == true) {
                        List<account> lstAcc= new list<account>();
                        for(Implementation_Period__c obj:[Select id,Name,Principal_Recipient__c,Principal_Recipient__r.Name,
                                                Principal_Recipient__r.Sub_Type__c,Principal_Recipient__r.Short_Name__c,
                                                Principal_Recipient__r.Type__c,Custom_PR__c,Grant__r.Name,Grant__c,
                                                Principal_Recipient__r.Impact_Outcome_reporting__c
                                                From Implementation_Period__c 
                                                Where Concept_Note__c =: strConceptNoteId
                                                AND Principal_Recipient__c !=:objNewAccount.ID
                                                AND Principal_Recipient__r.Impact_Outcome_reporting__c =TRUE]){
                            lstAcc.add( new account(id=obj.Principal_Recipient__c,Impact_Outcome_reporting__c=false));
                                
                        }
                        
                        update lstAcc;
                        system.debug('lstPrincipalRecipients= '+lstPrincipalRecipients);
                        for(wrapPrincipalRecipients obj:lstPrincipalRecipients){
                            system.debug('obj.objAccount.id= '+obj.objAccount.id);
                            system.debug('objNewAccount.id= '+objNewAccount.id);
                            if(obj.objAccount.id!=objNewAccount.id){
                                obj.objAccount.Impact_Outcome_reporting__c=false;
                            }
                        }
                    }
                    
                    strNewPRName = null;
                }
            }
            objNewAccount = new Account();
            SelectedAccId=null;
            objNewExistingAccount = new Account();
        }
    }
    Public void SaveGoalExisting(){
        system.debug('### save Existing goal--');
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            if(SaveIndex > lstPrincipalRecipients.size()){
                //Account objPR = new Account (Name = strNewPRName, Sub)Type__c = strPRSubType, Type__c = strPRType, Short_Name__c = strPRshortname);
                blnIsExisting = true;
               
                if(objNewExistingAccount != null){
                    //if(blnRadioExisting == true) objNewExistingAccount.Impact_Outcome_reporting__c = true; -- Commented out by Matthew Miller 2014-6-18
                    //insert objNewAccount;
                    String GrantId = null;
                    List<Grant__c> lstGrant = new List<Grant__c>();
                    if(String.Isblank(GrantExistingName)){
                        Grant__c objGrantNew = new Grant__c(Name = 'Test',Principal_Recipient__c = objNewExistingAccount.Id,Disease_Component__c = CNComponent,Grant_Status__c = 'Concept Note',Country__c = CNCountry,Start_Date__c = CNStartDate,End_Date__c = CNEndDate);
                        insert objGrantNew;
                        lstGrant = [Select Id,Name From Grant__c Where id =: objGrantNew.id];
                        GrantId = objGrantNew.id;
                    }else{
                        GrantId = GrantExistingName;
                    }
                    
                    Implementation_Period__c objIP = new Implementation_Period__c(Principal_Recipient__c = objNewExistingAccount.Id, Concept_Note__c = strConceptNoteId,Start_Date__c  = CNStartDate,Length_Years__c = CNLengthYear,End_Date__c = CNEndDate,Local_Currency__c = CNLocalCurrency,Currency_of_Grant_Agreement__c = CNGrantCurrency,Grant__c = GrantId);
                    insert objIP;
                    IP_Detail_Information__c objIPDetail = new IP_Detail_Information__c(Implementation_Period__c = objIP.Id, Budget_Status__c = 'Not yet submitted by PR');
                    insert objIPDetail;
                    
                    wrapPrincipalRecipients objwarp = new wrapPrincipalRecipients();
                    objwarp.PRDescription = objNewExistingAccount.Name;
                    objwarp.PRType = objNewExistingAccount.Type__c;
                    objwarp.PRSubType = objNewExistingAccount.Sub_Type__c;
                    objwarp.PRshortname = objNewExistingAccount.Short_Name__c;
                    objwarp.objAccount = objNewExistingAccount;
                    objwarp.AccountId = objNewExistingAccount.Id;   
                    objwarp.PRId = objIP.id;
                    objwarp.implementationPeriod = objIP;
                    objwarp.CustomPR = true;
                    objwarp.blnExistingPR = true;
                    
                    objwarp.GrantOptions = new List<SelectOption>();
                    objwarp.GrantOptions.add(new SelectOption('','--None--'));
                    List<Implementation_Period__c> IPNewInserted = [Select Grant__c,Grant__r.Name From Implementation_Period__c Where Id =: objIP.id];
                    if(IPNewInserted.size() > 0) objwarp.GrantName = IPNewInserted[0].Grant__r.Name;
                    List<Grant__c> lstGrantExist = [Select Id,Name From Grant__c Where Principal_Recipient__c =: objNewExistingAccount.Id];
                    if(lstGrantExist.size() > 0){
                        for(Grant__c objG : lstGrantExist){
                            objwarp.GrantOptions.add(new SelectOption(objG.Name,objG.Name));
                        }
                    }
                    if(String.Isblank(GrantExistingName) && lstGrant.size() > 0){
                        objwarp.GrantName = lstGrant[0].Name;
                    }else{
                        for(SelectOption obj : NewGrantExistingOptions){
                            if(obj.getvalue() == GrantExistingName){
                                objwarp.GrantName = obj.getLabel();
                            }
                        }
                    }
                    
                    //if(lstGoalsObjectives.size() > 0) objwarpGoal.IndexGoal = lstGoalsObjectives.size() + 1;
                    //else objwarpGoal.IndexGoal = 1;
                    objwarp.blnDisplay = true;
                   
                    //update objNewExistingAccount; -- Commented out by Mathew Miller 2014-6-18 since we are no longer setting the Impact Reporting checkbox (and to prevent update of locked accounts)
                    
                    if(objNewExistingAccount.Impact_Outcome_reporting__c == true){
                        List<account> lstAcc= new list<account>();
                        for(Implementation_Period__c obj:[Select id,Name,Principal_Recipient__c,Principal_Recipient__r.Name,
                                                Principal_Recipient__r.Sub_Type__c,Principal_Recipient__r.Short_Name__c,
                                                Principal_Recipient__r.Type__c,Custom_PR__c,Grant__r.Name,Grant__c,
                                                Principal_Recipient__r.Impact_Outcome_reporting__c
                                                From Implementation_Period__c 
                                                Where Concept_Note__c =: strConceptNoteId
                                                AND Principal_Recipient__c !=:objNewExistingAccount.Id
                                                AND Principal_Recipient__r.Impact_Outcome_reporting__c =TRUE]){
                            lstAcc.add( new account(id=obj.Principal_Recipient__c,Impact_Outcome_reporting__c=false));
                                
                        }
                        update lstAcc;
                        
                        for(wrapPrincipalRecipients obj:lstPrincipalRecipients){
                            if(obj.objAccount.id != objwarp.AccountId)
                            obj.objAccount.Impact_Outcome_reporting__c=false;
                        }
                    }
                    lstPrincipalRecipients.add(objwarp);
                    strNewPRName = null;
                }
            }
        }
        
        FillAccount();
        objNewAccount = new Account();
        SelectedAccId=null;
        objNewExistingAccount = new Account();
    }
    
    Public void UpdateCustomPR(){
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        system.debug('####----true fale----'+lstPrincipalRecipients[SaveIndex].objAccount.Impact_Outcome_reporting__c);

        if(SaveIndex != null){
            update lstPrincipalRecipients[SaveIndex].objAccount;

            if(lstPrincipalRecipients[SaveIndex].objAccount.Impact_Outcome_reporting__c == true) {
                List<account> lstAcc= new list<account>();
                for(Implementation_Period__c obj:[Select id,Name,Principal_Recipient__c,Principal_Recipient__r.Name,
                                        Principal_Recipient__r.Sub_Type__c,Principal_Recipient__r.Short_Name__c,
                                        Principal_Recipient__r.Type__c,Custom_PR__c,Grant__r.Name,Grant__c,
                                        Principal_Recipient__r.Impact_Outcome_reporting__c
                                        From Implementation_Period__c 
                                        Where Concept_Note__c =: strConceptNoteId
                                        AND Principal_Recipient__c !=:lstPrincipalRecipients[SaveIndex].objAccount.ID
                                        AND Principal_Recipient__r.Impact_Outcome_reporting__c =TRUE]){
                    lstAcc.add( new account(id=obj.Principal_Recipient__c,Impact_Outcome_reporting__c=false));
                        
                }
                update lstAcc;
    
                for(wrapPrincipalRecipients obj:lstPrincipalRecipients){
                    if(obj.objAccount.id!=lstPrincipalRecipients[SaveIndex].objAccount.id){
                        obj.objAccount.Impact_Outcome_reporting__c=false;
                    }
                }
            }
            
            lstPrincipalRecipients[SaveIndex].AccountId = lstPrincipalRecipients[SaveIndex].objAccount.Id;
            lstPrincipalRecipients[SaveIndex].PRDescription = lstPrincipalRecipients[SaveIndex].objAccount.Name;
            lstPrincipalRecipients[SaveIndex].PRSubType = lstPrincipalRecipients[SaveIndex].objAccount.Sub_Type__c;
            lstPrincipalRecipients[SaveIndex].PRShortName = lstPrincipalRecipients[SaveIndex].objAccount.Short_Name__c;
            lstPrincipalRecipients[SaveIndex].PRType = lstPrincipalRecipients[SaveIndex].objAccount.Type__c;
            for(SelectOption obj : lstPrincipalRecipients[SaveIndex].GrantOptions){
                if(obj.getvalue() == lstPrincipalRecipients[SaveIndex].GrantName){
                    lstPrincipalRecipients[SaveIndex].GrantName = obj.getLabel();
                }
            }
            system.debug('###---'+lstPrincipalRecipients[SaveIndex].objAccount.Impact_Outcome_reporting__c);
            
            lstPrincipalRecipients[SaveIndex].blnDisplay = true;
        }
    }
    
    Public void EditGoal(){
        system.debug('###---Calll');
        integer EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            system.debug('#### editGoal---'+lstPrincipalRecipients[EditIndex].GrantOptions);
            for(SelectOption obj : lstPrincipalRecipients[EditIndex].GrantOptions){
                if(obj.getlabel() == lstPrincipalRecipients[EditIndex].GrantName){
                    lstPrincipalRecipients[EditIndex].GrantName = obj.getvalue();
                }
            }
           lstPrincipalRecipients[EditIndex].blnDisplay = false;
        }
    }
    Public void CancelGoal(){
        integer CancelIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            for(SelectOption obj : lstPrincipalRecipients[CancelIndex].GrantOptions){
                if(obj.getvalue() == lstPrincipalRecipients[CancelIndex].GrantName){
                    lstPrincipalRecipients[CancelIndex].GrantName = obj.getLabel();
                }
            }
            lstPrincipalRecipients[CancelIndex].blnDisplay = true;
        }
    }
    
    Public void fillExistingAccountFields(){
        objNewExistingAccount = new Account();
        if(String.IsBlank(SelectedAccId) == false){
            List<Account> lstAccountChange = [Select Id,Name,Type__c,Sub_Type__c,Short_Name__c,Impact_Outcome_reporting__c,Locked__c,(Select Id,Name From Grants__r) From Account Where Id =: SelectedAccId];
            if(lstAccountChange.size() > 0){
                objNewExistingAccount = lstAccountChange[0];
                NewGrantExistingOptions = new List<SelectOption>();
                NewGrantExistingOptions.add(new SelectOption('','--Create New--'));
                if(lstAccountChange[0].Grants__r.size() > 0){
                    for(Grant__c objG : lstAccountChange[0].Grants__r){
                        NewGrantExistingOptions.add(new SelectOption(objG.Id,objG.Name));
                    }
                }
            }
        }
    }
    
    Public Boolean blndisplaySave {get;set;}
    
    Public List<SelectOption> AccountTypeOptions {get;private set;}
    Public void FillAccountType(){
        AccountTypeOptions = new List<SelectOption>();
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> AccountTypes = fieldMap.get('Type__c').getDescribe().getPickListValues();
        AccountTypeOptions.add(new SelectOption('','--None--'));
        for(Schema.PicklistEntry Entry : AccountTypes){ 
            AccountTypeOptions.add(new SelectOption(Entry.getLabel(), Entry.getValue()));
        }
    }
    
    Public List<SelectOption> AccountSubTypeOptions {get;private set;}
    Public void FillAccountSubType(){
        AccountSubTypeOptions = new List<SelectOption>();
        Schema.sObjectType objSubType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objSubType.getDescribe(); 
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> AccountSubTypes = fieldMap.get('Sub_Type__c').getDescribe().getPickListValues();
        AccountSubTypeOptions.add(new SelectOption('','--None--'));
        for(Schema.PicklistEntry Entry : AccountSubTypes){ 
            AccountSubTypeOptions.add(new SelectOption(Entry.getLabel(), Entry.getValue()));
        }
    }
    
    Public void FillAccount(){
        AccountOptions = new List<SelectOption>();
        Set<Id> setGrantPRIds = new Set<Id>();
        for(Grant__c gr : [Select Principal_Recipient__c from Grant__c where Country__c =: CNCountry]){
            setGrantPRIds.add(gr.Principal_Recipient__c);
        }
        List<Account> lstAccount= [Select Id,Name,Type__c,Sub_Type__c,Short_Name__c, Locked__c 
                                    From Account 
                                    Where (RecordType.DeveloperName = 'PR' 
                                    OR RecordType.DeveloperName = 'PR_Read_Only')
                                    AND (Country__c =: CNCountry OR Id in :setGrantPRIds)
                                    AND ID Not IN (select Principal_Recipient__c 
                                        From Implementation_Period__c 
                                        Where Concept_Note__c =: strConceptNoteId )
                                    ORDER BY Name
                                  ];
        system.debug('#$#$#$#$#$'+lstAccount);
        AccountOptions.add(new SelectOption('','--'+Label.None+'--'));
        for(Account objAcc : lstAccount){ 
            AccountOptions.add(new SelectOption(objAcc.Id, objAcc.Name));
        }
    }
    
    Public Class wrapPrincipalRecipients{
        Public String PRDescription{get;set;}
        Public Id PRId{get;set;}
        Public Implementation_Period__c implementationPeriod {get;set;}
        Public Account objAccount {get;set;}
        Public Id AccountId {get;set;}
        Public String PRType {get;set;}
        Public String PRSubType {get;set;}
        Public String PRshortname {get;set;}
        Public Boolean blnDisplay {get;set;}
        Public Boolean CustomPR {get;set;}
        Public Boolean blnExistingPR {get;set;}
        Public String strSelectedAccountType {get;set;}
        Public List<SelectOption> GrantOptions {get;set;}
        Public list<SelectOption> PRSubTypeOptions {get;set;}
        Public String GrantName {get;set;}
        
    }
    
     /* For Custom Setting profile Implementation*/
    public void checkProfile(){
    
    blnExternalPro =false;
    blnEdit =false;
    blnDelete =false;
    blnAddExistingPR =false;
    blnAddNewPR =false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('profileName'+profileName);
        List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c,Status__c,Profile_Name__c from Profile_Access_Setting_CN__c where Page_Name__c ='CN_Implementers' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets) ];
        system.debug('profile list'+ checkpage);
        system.debug('CN Status'+ cnStatus);
        for (Profile_Access_Setting_CN__c check : checkpage){
            if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
            if(check.Salesforce_Item__c == 'Edit' && check.Status__c == cnStatus) blnEdit = true;
            if(check.Salesforce_Item__c == 'Delete' && check.Status__c == cnStatus) blnDelete = true;
            if(check.Salesforce_Item__c == 'Add Existing PR' && check.Status__c == cnStatus) blnAddExistingPR = true;
            if(check.Salesforce_Item__c == 'Add New PR' && check.Status__c == cnStatus) blnAddNewPR = true;
        }
    }
    /* End */
    
}