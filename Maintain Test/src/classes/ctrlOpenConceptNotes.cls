Public with sharing Class ctrlOpenConceptNotes{
    public String CountryId {get;set;}
    public String strLanguage {get;set;}
    public User objUser;
    public List<Concept_Note__C> lstCN  {get;set;}
    public Decimal TotalIndicativeAmount {get;set;}
    public Decimal TotalProposedAmount {get;set;}
    Public List<SelectOption> selOptCountry{get;set;}
    Public String strGuidanceId {get;set;}
    Public Boolean blnReadOnly {get;set;}
    public String strSelectSubDate{get;set;}
 
    //TCS 09/09/2014: Variables for Profile Access
    Public Boolean blnExternalPro {get;set;}
    Public Boolean blnStartDate {get;set;}
    Public Boolean blnEndDate {get;set;}
    Public Boolean blnSubDate {get;set;}
    Public Boolean blnAppCM {get;set;}
    
    //Public String CurrencyIsoCode{get;set;}
    public ctrlOpenConceptNotes(ApexPages.StandardController controller) {
        CountryId = Apexpages.currentpage().getparameters().get('id');
        strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
   
        String UserID = userinfo.getUserId();
       /* if(CheckProfile.checkProfileOpenCNotes()==false){
            blnReadOnly = true;
        }else{
            blnReadOnly = false;
        } */
        checkProfile(); //TCS09/09/2014: Added for Profile Access

        
        
        objUser = [Select ID, Profile.Name, IsPortalEnabled from User where id=:UserID];
       
        
         List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Open Concept Notes'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
              
        if(lstCN==null)
        {
            FillCountry(null);
            lstCN = [Select Id, Name, Final_Allocation__c, Indicative_Amount__c,TRP_Submission_Language__c,Language__c,
                      Proposed_Amount__c, Program_Split__c, Program_Split__r.Agreed__c, Start_Date__c, TRP_Submission_Review_Date__c,Actual_Submission_Date__c,
                      Funding_End_Date__c,Component__c, TRP_Review_Window__c, CCM_New__c, Status__c,P_I_IR_and_Risk_Status__c,Concept_Note_Type__c,CCM_new__r.Country__r.Name,
                      Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,Absorptive_Capacity_Final_Alloc_Status__c, Agreed_Split_USD__c, Agreed_Split_EUR__c,
                      CurrencyISOCode, Concept_Note_Submission_Date__c,Revised_Submission_Date__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,Communicated_Allocation_USD__c,Communicated_Allocation_EUR__c
                      From Concept_Note__c Where Open__c = true Order by Name];
        }
      
        if(lstCN.size() > 0){
                
                
            CalculateIndicativeAmount();
            CalculateProposedAmount();
        }
         
    
    }
    Public Void ConceptNoteByCountry(){
 //List if no country is selected
        if(CountryId == null){
            lstCN = [Select Id, Name, Final_Allocation__c, Indicative_Amount__c, 
                      Proposed_Amount__c,Program_Split__c, Program_Split__r.Agreed__c, Start_Date__c, 
                      Component__c,TRP_Review_Window__c, Status__c,CCM_New__c, Funding_End_Date__c,P_I_IR_and_Risk_Status__c,CCM_new__r.Country__r.Name,
                      Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,Absorptive_Capacity_Final_Alloc_Status__c, Agreed_Split_USD__c, Agreed_Split_EUR__c,
                      CurrencyISOCode, Concept_Note_Submission_Date__c,Revised_Submission_Date__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,Communicated_Allocation_USD__c,Communicated_Allocation_EUR__c
                      From Concept_Note__c Where Open__c = true Order by Name ];
        }
 //List Countries if a country is selected
        if(CountryId != null){
            lstCN = [Select Id, Name, Final_Allocation__c, Indicative_Amount__c,
                      Proposed_Amount__c, Program_Split__c, Program_Split__r.Agreed__c, Start_Date__c, 
                      Component__c, TRP_Review_Window__c, Status__c,CCM_New__c, Funding_End_Date__c,P_I_IR_and_Risk_Status__c,CCM_new__r.Country__r.Name,
                      Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,Absorptive_Capacity_Final_Alloc_Status__c, Agreed_Split_USD__c, Agreed_Split_EUR__c,
                      CurrencyISOCode, Concept_Note_Submission_Date__c,Revised_Submission_Date__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c,Communicated_Allocation_USD__c,Communicated_Allocation_EUR__c
                      From Concept_Note__c Where Open__c = true and CCM_new__r.Country__r.id =:CountryId];
        }
        CalculateIndicativeAmount();
      
        //CalculateProposedAmount();
    }
    Public void FillCountry(String Country){
        //List<Country__c> lstCountry= [Select id,name,French_Name__c , Russian_Name__c , Spanish_Name__c from Country__c order by name asc];
        
        List<Country__c> lstCountry = new List<Country__c>();
        //Getting country list and sorting based on the User language setting
        if(System.UserInfo.getLanguage() == 'fr'){
            lstCountry= [Select id,name,French_Name__c , Russian_Name__c , Spanish_Name__c from Country__c order by name,French_Name__c asc]; }
        else if(System.UserInfo.getLanguage() == 'ru'){
            lstCountry= [Select id,name,French_Name__c , Russian_Name__c , Spanish_Name__c from Country__c order by Russian_Name__c asc];}
        else if(System.UserInfo.getLanguage() == 'es'){
            lstCountry= [Select id,name,French_Name__c , Russian_Name__c , Spanish_Name__c from Country__c order by Spanish_Name__c asc]; }
        else {
            lstCountry= [Select id,name,French_Name__c , Russian_Name__c , Spanish_Name__c from Country__c order by name asc];
        }
        
        selOptCountry= new List<SelectOption>();
        selOptCountry.add(new SelectOption('',Label.All_Countries));
        for(Country__c objCon:lstCountry){
            if(Country==objCon.Name)
            {
                CountryId = objCon.id;
            }
            
            // Settings values in the country
            if(System.UserInfo.getLanguage() == 'fr' && String.isNotBlank(objCon.French_Name__c) ){
               selOptCountry.add(new SelectOption(objCon.id,objCon.Name + ' - ' + objCon.French_Name__c));}
            else if(System.UserInfo.getLanguage() == 'ru' && String.isNotBlank(objCon.Russian_Name__c) ){
                selOptCountry.add(new SelectOption(objCon.id,objCon.Name + ' - ' + objCon.Russian_Name__c)); }
            else if(System.UserInfo.getLanguage() == 'es' && String.isNotBlank(objCon.Spanish_Name__c)){
                selOptCountry.add(new SelectOption(objCon.id,objCon.Name + ' - '  + objCon.Spanish_Name__c)); }
            else {
                selOptCountry.add(new SelectOption(objCon.id,objCon.Name));
            }
            
            
           // selOptCountry.add(new SelectOption(objCon.id,objCon.Name));
        }        
    }
    Public void CalculateIndicativeAmount(){
        TotalIndicativeAmount = 0;      
        /*Set<String> isoCodes = new Set<String>();
        Map<String,Double> conversion_rates = new Map<String,Double>(); 
        for(CurrencyType curr: [SELECT IsoCode,ConversionRate FROM CurrencyType]){         
            conversion_rates.put(curr.IsoCode,curr.ConversionRate);       
         }*/
        
        
        if(lstCN.size()>0){
           for(Concept_Note__c objCN:lstCN){              
              if(objCN.CurrencyIsoCode == 'EUR' && objCN.Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c != null && objCN.Communicated_Allocation_EUR__c != null){
               TotalIndicativeAmount += (objCN.Communicated_Allocation_EUR__c * objCN.Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c); }
              else if(objCN.Communicated_Allocation_USD__c != null){
              TotalIndicativeAmount += objCN.Communicated_Allocation_USD__c; }
               
           }
        }
        if(TotalIndicativeAmount == 0)
            TotalIndicativeAmount = null;
    }
    Public void CalculateProposedAmount(){
        TotalProposedAmount = 0;
        if(lstCN.size()>0){
           for(Concept_Note__c objCN:lstCN){
               if(TotalProposedAmount == null){
                   TotalProposedAmount = objCN.Proposed_Amount__c;
               }
               if(objCN.Proposed_Amount__c != null){
                   TotalProposedAmount += objCN.Proposed_Amount__c;
               }
           }
        }
        if(TotalProposedAmount == 0)
            TotalProposedAmount = null;
    }
    Public void SaveChanges(){
        update lstCN;
        //List if no country is selected
        if(CountryId == null){
            lstCN = [Select Id, Name, Final_Allocation__c, Indicative_Amount__c,Communicated_Allocation_USD__c, Communicated_Allocation_EUR__c,
                      Proposed_Amount__c,Program_Split__c, Program_Split__r.Agreed__c, Start_Date__c, 
                      Component__c,TRP_Review_Window__c, Status__c,CCM_New__c, Funding_End_Date__c,P_I_IR_and_Risk_Status__c,CCM_new__r.Country__r.Name,
                      Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,Absorptive_Capacity_Final_Alloc_Status__c, Agreed_Split_USD__c, Agreed_Split_EUR__c,
                      CurrencyISOCode, Concept_Note_Submission_Date__c,Revised_Submission_Date__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c 
                      From Concept_Note__c Where Open__c = true Order by Name];
        }
 //List Countries if a country is selected
        if(CountryId != null){
            lstCN = [Select Id, Name, Final_Allocation__c, Indicative_Amount__c, Communicated_Allocation_USD__c,Communicated_Allocation_EUR__c,
                      Proposed_Amount__c, Program_Split__c, Program_Split__r.Agreed__c, Start_Date__c,
                      Component__c, TRP_Review_Window__c, Status__c,CCM_New__c, Funding_End_Date__c,P_I_IR_and_Risk_Status__c,CCM_new__r.Country__r.Name,
                      Absorptive_Capacity_Initial_Alloc_Status__c,Absorptive_Capacity_Review_Status__c,Absorptive_Capacity_Final_Alloc_Status__c, Agreed_Split_USD__c, Agreed_Split_EUR__c,
                      CurrencyISOCode, Concept_Note_Submission_Date__c,Revised_Submission_Date__c, Funding_Opportunity__r.Allocation_fix_exchange_rate_USD_per_EUR__c
                      From Concept_Note__c Where Open__c = true and CCM_new__r.Country__r.id =:CountryId];
        }
        CalculateProposedAmount();
            
    }
    
    Public PageReference pageRedirect(){
        system.debug('objUser.Profile.Name ' +objUser.Profile.Name);
        if (objUser.Profile.Name == Label.PR_Read_Only) 
        {        
                        system.debug('objUser.Profile.Name ' +objUser.Profile.Name);
                        PageReference pgrefnew = new PageReference('/apex/GrantMakingHome?sfdc.tabName=01rg00000004QT6');
                pgrefnew.setRedirect(true);
                return pgrefnew;
        }
        return null;
    }
     //TCS 09/09/2014: Added Below function for Profile level access
   public void checkProfile(){
        blnExternalPro =false;
        blnStartDate =false;
        blnEndDate =false;
        blnSubDate =false;
        blnAppCM =false;
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         if(profileName == 'Applicant/CM Admin' || profileName == 'Applicant/CM Read Write')blnAppCM = true;
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c from Profile_Access_Setting_CN__c where Page_Name__c ='OpenConceptNoteH' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets) ];
      
        for (Profile_Access_Setting_CN__c check : checkpage){
          if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
          if(check.Salesforce_Item__c == 'Start Date')blnStartDate = true;
          if(check.Salesforce_Item__c == 'End Date')blnEndDate = true;
          if(check.Salesforce_Item__c == 'Submission Date')blnSubDate = true;
       }
    }
}