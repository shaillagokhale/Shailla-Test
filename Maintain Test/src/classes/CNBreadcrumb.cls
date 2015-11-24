Public Class CNBreadcrumb{
    Public String strConceptNoteId {get;set;}
    Public String strId {get;set;}
    Public String strCNName {get;set;}    
    Public String strLanguage {get;set;}
    Public String strCountryName {get;set;}
    Public String strCountryId {get;set;}
    public Boolean blnExternalPro {get; set;}
    public CNBreadcrumb(){}

    Public void getParameters(){       
        checkProfile();
        strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
            
    
        List<Page__c> lstPage = new List<page__c>();
        if(String.IsBlank(strId) == false){
            String TempId = strId.substring(0,3);
            if(TempId == 'a0c'){
                lstPage = [Select Concept_note__c,Concept_Note__r.Language__c,Concept_Note__r.Name,Concept_Note__r.CCM_New__r.Country__r.Name,Concept_Note__r.CCM_New__r.Country__r.French_Name__c,Concept_Note__r.CCM_New__r.Country__c,
                      Concept_Note__r.CCM_New__r.Country__r.Russian_Name__c,Concept_Note__r.CCM_New__r.Country__r.Spanish_Name__c  
                    From Page__c 
                    Where Id =: strId And Concept_note__c != null Limit 1];
                if(lstPage.size() > 0) {
                        strConceptNoteId = lstPage[0].Concept_note__c;                        
                        strCNName = lstPage[0].Concept_Note__r.Name;
                        strLanguage = lstPage[0].Concept_Note__r.Language__c;
                        strCountryName = lstPage[0].Concept_Note__r.CCM_New__r.Country__r.Name;
                        
                         if(System.UserInfo.getLanguage() == 'fr')
                            strCountryName = lstPage[0].Concept_Note__r.CCM_New__r.Country__r.French_Name__c;
                         if(System.UserInfo.getLanguage() == 'ru')
                            strCountryName = lstPage[0].Concept_Note__r.CCM_New__r.Country__r.Russian_Name__c;
                         if(System.UserInfo.getLanguage() == 'es')
                            strCountryName = lstPage[0].Concept_Note__r.CCM_New__r.Country__r.Spanish_Name__c; 
                              
                        strCountryId = lstPage[0].Concept_Note__r.CCM_New__r.Country__c;                
                    }                
            }else if(TempId == 'a0L'){
                List<Module__c> lstModule = [Select Concept_note__c,Concept_note__r.Name,Concept_Note__r.Language__c,Concept_Note__r.CCM_New__r.Country__c,Concept_Note__r.CCM_New__r.Country__r.Name,
                            Concept_Note__r.CCM_New__r.Country__r.French_Name__c,Concept_Note__r.CCM_New__r.Country__r.Russian_Name__c,Concept_Note__r.CCM_New__r.Country__r.Spanish_Name__c     
                            From Module__c Where Id =: strId And Concept_note__c != null Limit 1];                
                if(lstModule.size() > 0) {                    
                        strConceptNoteId = lstModule[0].Concept_note__c; 
                        strCNName = lstModule[0].Concept_Note__r.Name;                      
                        strLanguage = lstModule[0].Concept_Note__r.Language__c;
                        strCountryName = lstModule[0].Concept_Note__r.CCM_New__r.Country__r.Name;
                        if(System.UserInfo.getLanguage() == 'fr')
                            strCountryName = lstModule[0].Concept_Note__r.CCM_New__r.Country__r.French_Name__c;
                         if(System.UserInfo.getLanguage() == 'ru')
                            strCountryName = lstModule[0].Concept_Note__r.CCM_New__r.Country__r.Russian_Name__c;
                         if(System.UserInfo.getLanguage() == 'es')
                            strCountryName = lstModule[0].Concept_Note__r.CCM_New__r.Country__r.Spanish_Name__c; 
                        
                        strCountryId = lstModule[0].Concept_Note__r.CCM_New__r.Country__c;                      
                }             
            }else if(TempId == 'a0E'){
                strConceptNoteId = strId;
                List<Concept_Note__c> lstConceptNote = [Select Id,Language__c,Name,CCM_New__r.Country__c,CCM_New__r.Country__r.Name,CCM_New__r.Country__r.French_Name__c,
                CCM_New__r.Country__r.Russian_Name__c,CCM_New__r.Country__r.Spanish_Name__c from Concept_Note__c where Id = :strConceptNoteId];
                    if(!lstConceptNote.isEmpty()) {
                        strConceptNoteId = lstConceptNote[0].Id;
                        strCNName = lstConceptNote[0].Name;
                        strLanguage = lstConceptNote[0].Language__c;
                        strCountryName = lstConceptNote[0].CCM_New__r.Country__r.Name; 
                      
                        if(System.UserInfo.getLanguage() == 'fr')
                            strCountryName = lstConceptNote[0].CCM_New__r.Country__r.French_Name__c;
                         if(System.UserInfo.getLanguage() == 'ru')
                            strCountryName = lstConceptNote[0].CCM_New__r.Country__r.Russian_Name__c;
                         if(System.UserInfo.getLanguage() == 'es')
                            strCountryName = lstConceptNote[0].CCM_New__r.Country__r.Spanish_Name__c; 
                        
                        strCountryId = lstConceptNote[0].CCM_New__r.Country__c;
                    }                
            }
        }
    }
    
    //TCS 11/09/2014 Added for giving Permission based on profile 
     public void checkProfile(){
        blnExternalPro =false;
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
       
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CNBreadcrum' and Profile_Name__c =: profileName ];
      
      for (Profile_Access_Setting_CN__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
      }
     }
}