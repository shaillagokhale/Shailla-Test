public with sharing class CN_Guidance_New {

    public String strLanguage {get; set;}
    public String strGuidanceId {get; set;}
    public String strGuidanceId2 {get; set;}
    public Boolean blnDisplay {get;set;}
    public Guidance__c guidance {get; set;}
    public Guidance__c guidance2 {get; set;}

    public CN_Guidance_New() {
       
       strGuidanceId = ApexPages.currentPage().getParameters().get('Id');
       strGuidanceId2 = ApexPages.currentPage().getParameters().get('Id2');       
       //strLanguage = ApexPages.currentPage().getParameters().get('lang'); 
       strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; } 
       
       if(strGuidanceId != null) {
         List<Guidance__c> lstGuidance = [Select Name, French_Guidance_Name__c, Russian_Guidance_Name__c, Spanish_Guidance_Name__c,
                                           English_Guidance__c, French_Guidance__c, Russian_Guidance__c, Spanish_Guidance__c, 
                                           English_Guidance_Overflow__c, French_Guidance_Overflow__c, Russian_Guidance_Overflow__c, Spanish_Guidance_Overflow__c
                                           from Guidance__c where Id = :strGuidanceId];
         if(lstGuidance.size() > 0) {
             guidance = lstGuidance[0]; 
             blnDisplay = true;
         }else {
             blnDisplay = false;
          }
       } else {
             blnDisplay = false;
         }
         
       if(strGuidanceId2 != null) {
         List<Guidance__c> lstGuidance2 = [Select Name, English_Guidance__c, French_Guidance__c, Russian_Guidance__c, Spanish_Guidance__c,
                                           English_Guidance_Overflow__c, French_Guidance_Overflow__c, Russian_Guidance_Overflow__c, Spanish_Guidance_Overflow__c
                                           from Guidance__c where Id = :strGuidanceId2];
         if(lstGuidance2.size() > 0) {
             guidance2 = lstGuidance2[0]; }
       }  

    }

}