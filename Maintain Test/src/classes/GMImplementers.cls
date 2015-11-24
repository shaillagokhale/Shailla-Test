Public Class GMImplementers{
    Public String strConceptNoteId {get;set;}
    Public String strImplementationPeriodId {get;set;}
    Public String strPageId {get;set;}
    public String strGIPId {get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public List<Module__c> lstModules {get;set;}
    //Public List<wrapGoalsObjectives> lstGoalsObjectives {get;set;}
    Public List<wrapPrincipalRecipients> lstPrincipalRecipients {get;set;}
    
    Public Boolean blnConfirmDelete {get;set;}
    Public Boolean blnConfirmIndicatorDelete {get;set;}
    Public Boolean blnExpandSection {get;set;}

    
    Public Grant_Indicator__c objNewIndicator {get;set;}
    Public Grant_Indicator__c objNewStdIndicator {get;set;}
    Public list<SelectOption> CatalogIndicatorOptions {get;set;}
    Public List<SelectOption> AccountOptions {get;set;}
    Public List<SelectOption> SectorOptions {get;set;}
    Public String strSelectedIndicator {get;set;}
    Public Map<Id,Integer> mapGoalIdToIndex;
    Public String CNComponent;
    Public String CNCountry;
    Public String strCountry {get;set;}
    Public Set<Id> setIndicatorId;
    Public List<Indicator__c> lstCatalogIndicator {get;set;}
    Public String setAddGoalCustom {get;set;}
    Public String setAddGoalStandard {get;set;}
    Public String strNewPRName {get;set;}
    Public Account objNewAccount {get;set;}
    Public Account objNewExistingAccount {get;set;}
    Public String SelectedAccId {get;set;}
    
    Public String strPRType {get;set;}
    Public String strPRSubType {get;set;}
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
    Public List<Page__c> lstPage {get;set;}
    Public Id AccountRecordType;
    Public Id ImplementersRecordType;
    Public String strGuidanceId {get;set;}
    Public Id IPPrincipalRecipient {get;set;}
    
    //TCS 22/08/2014: Added For Profile Access
    Public Boolean blnExternalPro  {get;set;}
    Public Boolean blnExistRec {get;set;}
    Public Boolean blnDelete {get;set;}
    Public Boolean blnNewRec {get;set;}
    
    public GMImplementers(ApexPages.StandardController controller) {
        strPageId = Apexpages.currentpage().getparameters().get('id');
        blnExpandSection = false;       
        if(String.IsBlank(strPageId) == false){
            List<Page__c> lstPage = [Select Implementation_Period__c,Implementation_Period__r.Principal_Recipient__r.Id, Implementation_Period__r.Principal_Recipient__r.Country__c,Implementation_Period__r.Principal_Recipient__r.Country__r.Name  From Page__c Where Id =: strPageId And Implementation_Period__c != null Limit 1];
            strLanguage = 'ENGLISH';
            
        /*if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }*/ 
            if(lstPage.size() > 0) {
                strImplementationPeriodId = lstPage[0].Implementation_Period__c;
                strCountry = lstPage[0].Implementation_Period__r.Principal_Recipient__r.Country__c;
                IPPrincipalRecipient = lstPage[0].Implementation_Period__r.Principal_Recipient__r.Id;
                //CNComponent = lstPage[0].Concept_note__r.Component__c;
                //strLanguage = lstPage[0].Concept_note__r.Language__c;
                //CNCountry = lstPage[0].Concept_note__r.CCM_new__r.Country__c;                
            lstPages = new List<Page__c>();
            lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId Order by Order__c];
            lstModules = new List<Module__c>();   
            lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strImplementationPeriodID Order by Name]; 
            
            }
            getPageText();
        }
        if(String.IsBlank(strImplementationPeriodId) == false){
            lstPrincipalRecipients = new List<wrapPrincipalRecipients>();
            blnConfirmDelete = false;
            blnConfirmIndicatorDelete = false;
            blndisplaySave = false;
            
            mapGoalIdToIndex = new Map<Id,Integer>();
            lstPrincipalRecipients = new List<wrapPrincipalRecipients>();
            List<Implementer__c> lstImplementers = [Select id,Name,Implementer_Name__c,Sector__c,Account__c,Custom_SR__c,Grant_Implementation_Period__c From Implementer__c Where Grant_Implementation_Period__c =: strImplementationPeriodId And Account__c != null Order By Implementer_Number__c];
            if(lstImplementers.size() > 0){
                Integer Count = 1;
                for(Implementer__c objImp : lstImplementers){
                    wrapPrincipalRecipients objWrap = new wrapPrincipalRecipients();
                    objWrap.ImpName = objImp.Implementer_Name__c;
                    objWrap.Sector = objImp.Sector__c;
                    objWrap.AccountId = objImp.Account__c;
                    objWrap.ImpId = objImp.Id;
                    objWrap.CustomSR = objImp.Custom_SR__c;
                    objWrap.IPId = objImp.Grant_Implementation_Period__c;
                    objWrap.blnDisplay = true;
                    /*objWrap.PRDescription = objIP.Principal_Recipient__r.Name;
                    objWrap.PRType = objIP.Principal_Recipient__r.Type__c;
                    objWrap.PRSubType = objIP.Principal_Recipient__r.Sub_Type__c;
                    objWrap.PRshortname = objIP.Principal_Recipient__r.Short_Name__c;    
                    objWrap.PRId = objIP.Id;*/
                    objWrap.blnDisplay = true;
                    lstPrincipalRecipients.add(objWrap);
                    Count ++;
                }
            }
            List<RecordType> lstRecordType = [Select Id From RecordType Where sobjectType = 'Account' And DeveloperName = 'Implementer_Non_PR'];
            if(!lstRecordType.isEmpty())
            AccountRecordType = lstRecordType[0].Id;
            
            System.debug ('The Record type is ' + AccountRecordType);
            SelectedAccId = null;
            FillAccount();
            FillSector();
            //FillAccountType();
            SelectedAccId=null;
            objNewAccount = new Account(RecordTypeId = AccountRecordType);
            objNewExistingAccount = new Account(RecordTypeId = AccountRecordType);
        }
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name =:label.Identify_Recipients];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
            checkProfile();
    }
    
    public void FillSector(){
        SectorOptions = new List<SelectOption>();
        Schema.sObjectType objType = Implementer__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> ServiceTypes = fieldMap.get('Sector__c').getDescribe().getPickListValues();
        SectorOptions.add(new SelectOption('','--None--')); 
        for (Schema.PicklistEntry Entry : ServiceTypes){ 
            SectorOptions.add(new SelectOption(Entry.getLabel(), Entry.getValue())); 
        }
    }
    
    public void getPageText(){
        system.debug('#####strLanguage->'+strLanguage);
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
        }
    }
    
    Public void DeleteGoal(){
        Integer DeleteIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('DeleteIndex')); 
        if(DeleteIndex != null){
            Id IpIdToDelete = lstPrincipalRecipients[DeleteIndex].ImpId;
            List<Implementer__c> lstIPToDelete = [Select id From Implementer__c Where Id =: IpIdToDelete];
            system.debug('$%#$#$'+lstIPToDelete);
            if(lstIPToDelete.size() > 0) Delete lstIPToDelete;
            system.debug('$%#$#$'+lstPrincipalRecipients[DeleteIndex]);
            lstPrincipalRecipients.remove(DeleteIndex); 
            
            List<Implementer__c> lstIPToUpdate = [Select id,Implementer_Number__c From Implementer__c 
                                                Where Implementer_Number__c >: DeleteIndex
                                                And Grant_Implementation_Period__c =: strImplementationPeriodId                                                 
                                                And Account__c != null];
            if(lstIPToUpdate.size() > 0){
                for(Implementer__c objI : lstIPToUpdate){
                    objI.Implementer_Number__c = objI.Implementer_Number__c - 1;
                }
                update lstIPToUpdate;
            }
            blnConfirmDelete = false;
        }
        
        FillAccount();
        objNewAccount = new Account(RecordTypeId = AccountRecordType);
        SelectedAccId=null;
        objNewExistingAccount = new Account(RecordTypeId = AccountRecordType);
         
    }
    Public void SaveGoal(){
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            if(SaveIndex > lstPrincipalRecipients.size()){
                //Account objPR = new Account (Name = strNewPRName, Type__c = strPRType, Sub_Type__c = strPRSubType Short_Name__c = strPRshortname);
                if(objNewAccount != null){
                    insert objNewAccount;
                    Implementer__c objGoal = new Implementer__c(Account__c = objNewAccount.Id, Implementer_Name__c = objNewAccount.Name,Sector__c = objNewAccount.Sector__c,Grant_Implementation_Period__c = strImplementationPeriodId,Implementer_Type__c = 'SR',Custom_SR__c = true,Implementer_Number__c = SaveIndex);
                    insert objGoal;
                    wrapPrincipalRecipients objWrap = new wrapPrincipalRecipients();
                    objWrap.ImpName = objGoal.Implementer_Name__c;
                    objWrap.Sector = objGoal.Sector__c;
                    objWrap.AccountId = objGoal.Account__c;
                    objWrap.ImpId = objGoal.Id;
                    objWrap.IPId = objGoal.Grant_Implementation_Period__c;
                    objWrap.CustomSR = objGoal.Custom_SR__c;
                    /*objwarp.PRDescription = objNewAccount.Name;
                    objwarp.PRType = objNewAccount.Type__c;
                    objwarp.PRSubType = objNewAccount.Sub_Type__c;
                    objwarp.PRshortname = objNewAccount.Short_Name__c;
                    objwarp.PRId = objGoal.id;*/
                    //if(lstGoalsObjectives.size() > 0) objwarpGoal.IndexGoal = lstGoalsObjectives.size() + 1;
                    //else objwarpGoal.IndexGoal = 1;
                    objWrap.blnDisplay = true;
                    
                    lstPrincipalRecipients.add(objWrap);
                    strNewPRName = null;
                }
            }
            
            FillAccount();
            objNewAccount = new Account(RecordTypeId = AccountRecordType);
            SelectedAccId=null;
            objNewExistingAccount = new Account(RecordTypeId = AccountRecordType);
        }
    }
    Public void SaveGoalExisting(){
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            if(SaveIndex > lstPrincipalRecipients.size()){
                //Account objPR = new Account (Name = strNewPRName, Sub)Type__c = strPRSubType, Type__c = strPRType, Short_Name__c = strPRshortname);
                if(objNewExistingAccount != null){
                    //insert objNewAccount;
                    Implementer__c objIP = new Implementer__c(Account__c = objNewExistingAccount.Id, Implementer_Name__c = objNewExistingAccount.Name,Sector__c = objNewExistingAccount.Sector__c,Grant_Implementation_Period__c = strImplementationPeriodId,Implementer_Type__c = 'SR',Implementer_Number__c = SaveIndex);
                    insert objIP;
                    wrapPrincipalRecipients objWrap= new wrapPrincipalRecipients();
                    objWrap.ImpName = objIP.Implementer_Name__c;
                    objWrap.Sector = objIP.Sector__c;
                    objWrap.AccountId = objIP.Account__c;
                    objWrap.ImpId = objIP.Id;
                    
                    objWrap.IPId = objIP.Grant_Implementation_Period__c;
                    //if(lstGoalsObjectives.size() > 0) objwarpGoal.IndexGoal = lstGoalsObjectives.size() + 1;
                    //else objwarpGoal.IndexGoal = 1;
                    objWrap.blnDisplay = true;
                    lstPrincipalRecipients.add(objWrap);
                    strNewPRName = null;
                }
            }
        }
        
        FillAccount();
        objNewAccount = new Account(RecordTypeId = AccountRecordType);
        SelectedAccId=null;
        objNewExistingAccount = new Account(RecordTypeId = AccountRecordType);
    }
    
    Public void UpdateCustomSR(){
        integer SaveIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('SaveIndex'));
        if(SaveIndex != null){
            Implementer__c objImplementerToUpdate = new Implementer__c();
            objImplementerToUpdate.Id = lstPrincipalRecipients[SaveIndex].ImpId;
            objImplementerToUpdate.Sector__c = lstPrincipalRecipients[SaveIndex].Sector;
            objImplementerToUpdate.Implementer_Name__c = lstPrincipalRecipients[SaveIndex].ImpName;
            update objImplementerToUpdate;
            lstPrincipalRecipients[SaveIndex].blnDisplay = true;
        }
    }
    
    Public void EditGoal(){
        integer EditIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('EditIndex'));
        if(EditIndex != null){
            lstPrincipalRecipients[EditIndex].blnDisplay = false;
        }
    }
    Public void CancelGoal(){
        integer CancelIndex = Integer.valueof(Apexpages.currentpage().getparameters().get('CancelIndex'));
        if(CancelIndex != null){
            lstPrincipalRecipients[CancelIndex].blnDisplay = true;
        }
    }
    
    Public void fillExistingAccountFields(){
        //String SelectedAccId = Apexpages.currentpage().getparameters().get('AccountId');
        objNewExistingAccount = new Account(RecordTypeId = AccountRecordType);
        if(String.IsBlank(SelectedAccId) == false){
            system.debug('#$#$#$'+SelectedAccId);
            List<Account> lstAccountChange = [Select Id,Sector__c,Name From Account Where Id =: SelectedAccId];
            system.debug('#$#$#$'+lstAccountChange);
            if(lstAccountChange.size() > 0) objNewExistingAccount = lstAccountChange[0];
        }
    }
    
    Public Boolean blndisplaySave {get;set;}
    
    /*Public List<SelectOption> AccountTypeOptions {get;private set;}
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
    
    */
    Public void FillAccount(){
        AccountOptions = new List<SelectOption>();
        List<Account> lstAccount= [Select Id,Name,Sector__c 
                                    From Account 
                                    Where Country__c =: strCountry and RecordType.DeveloperName != 'LFA'
                                    and ID Not IN (select Account__c 
                                        From Implementer__c
                                        Where Grant_Implementation_Period__c =: strImplementationPeriodId)
                                        AND ID !=: IPPrincipalRecipient
                                  ];
        system.debug('#$#$#$#$#$'+lstAccount);
        AccountOptions.add(new SelectOption('','--None--'));
        for(Account objAcc : lstAccount){ 
            AccountOptions.add(new SelectOption(objAcc.Id, objAcc.Name));
        }
    }
    
    public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
      List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_Implementers' and Profile_Name__c =: profilename];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Add Existing Recipient')blnExistRec = true;
        if(check.Salesforce_Item__c == 'Delete')blnDelete = true;
        if(check.Salesforce_Item__c == 'Add New Recipient')blnNewRec = true;
      }
    }
    
    Public Class wrapPrincipalRecipients{
        
        Public String ImpName{get;set;}
        Public String Sector{get;set;}
        Public String AccountId{get;set;}
        Public String IPId{get;set;}
        Public String ImpId{get;set;}
        Public Boolean CustomSR{get;set;}
        Public Boolean blnDisplay {get;set;}
        
        Public String PRDescription{get;set;}
        Public Id PRId{get;set;}
        Public String PRType {get;set;}
        Public String PRSubType {get;set;}
        Public String PRshortname {get;set;}
        //Public Boolean blnDisplay {get;set;}
        Public String strSelectedAccountType {get;set;}
    }
    
}