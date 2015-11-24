Public Class Sidebar{
    Public String strConceptNoteId {get;set;}
    Public String strProgramSplitId {get;set;}
    Public String strPageId {get;set;}
    Public String strCPFReportId {get;set;}
    Public String strCPFReportId2 {get;set;}
    Public String strId {get;set;}    
    Public String strLanguage {get;set;}
    Public String strComponent;
    Public List<Module__c> lstModules {get;set;}
    Public List<Module__c> lstModulesPG {get;set;}
    Public List<CPF_Report__c> lstCPFReport {get;set;}
    Public List<CPF_Report__c> lstCPFReport2 {get;set;}
    public String strGIPId {get;set;}
    Public List<Page__c> lstPages {get;set;}
    Public Boolean blnExpandSection {get;set;}
    Public Implementation_Period__c IP {get;set;}
    Public Boolean blnExternalPro {get;set;}
    public Sidebar(){}
    
    Public void getParameters(){
        checkProfile();
        lstPages = new List<Page__c>();
        lstModules = new List<Module__c>();   
        lstCPFReport = new List<CPF_Report__c>();
        lstCPFReport2 = new List<CPF_Report__c>();
        List<Page__c> lstPage = new List<page__C>();
        List<Module__c> lstModule = new List<Module__C>();
                 
        if(String.IsBlank(strId) == false){
            String TempId = strId.substring(0,3);
            if(TempId == 'a0c'){
                lstPage = [Select Concept_note__c,Concept_note__r.Program_Split__c, Concept_Note__r.Component__c, Concept_Note__r.Language__c,Implementation_Period__c,Implementation_Period__r.Concept_note__c, Implementation_Period__r.Concept_note__r.Program_Split__c From Page__c 
                            Where Id =: strId
                            And (Concept_note__c != null OR Implementation_Period__c != null) Limit 1];
                 IP = new Implementation_Period__c();
                 IP.Id = lstPage[0].Implementation_Period__c;
                if(lstPage.size() > 0) {
                    if(lstPage[0].Implementation_Period__c != null){
                        strConceptNoteId = lstPage[0].Implementation_Period__r.Concept_note__c;
                        strProgramSplitId = lstPage[0].Implementation_Period__r.Concept_note__r.Program_Split__c;
                        strGIPId = lstPage[0].Implementation_Period__c;
                        lstPages = [Select Id,Concept_Note__c,Name,URL_Prefix__c,Order__c, Modular__c, Read_Only__c,Standard_Controller__c From Page__c Where Implementation_Period__c =: strGIPId AND Name != 'Guidance' Order by Order__c];
                        lstModules = new List<Module__c>();   
                        lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strGIPID Order by Name]; 
                    }else{
                        strConceptNoteId = lstPage[0].Concept_note__c;
                        strComponent = lstPage[0].Concept_Note__r.Component__c;
                        strProgramSplitId = lstPage[0].Concept_note__r.Program_Split__c;
                        //strLanguage = lstPage[0].Concept_Note__r.Language__c;
                        lstPages = [Select Id,Name,URL_Prefix__c,Order__c, Modular__c, Read_Only__c,Concept_Note__c,French_Name__c,Spanish_Name__c,Russian_Name__c,Standard_Controller__c From Page__c Where Concept_Note__c =: strConceptNoteId AND Name != 'Guidance'  Order by Order__c];
                        lstModules = [Select Id,Name,Concept_Note__c,Implementation_Period__c,Catalog_Module__r.French_Name__c,Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c  From Module__c Where Concept_Note__c =: strConceptNoteID Order by Modular_Order__c NULLS LAST]; 
                        lstModulesPG = [Select Id,Name,Catalog_Module__r.French_Name__c,Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c  from Module__c where Concept_Note__c =: strConceptNoteId and Catalog_Module__r.Available_for_Programmatic_Gap__c = true Order by Modular_Order__c NULLS LAST];
                        if(strComponent != 'HIV/TB'){
                            lstCPFReport = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId Limit 1];
                            if(!lstCPFReport.isEmpty()){
                                strCPFReportId = lstCPFReport[0].Id; }
                        } else {
                            lstCPFReport = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId AND Component__c = 'HIV/AIDS' Limit 1];
                            if(!lstCPFReport.isEmpty()){
                                strCPFReportId = lstCPFReport[0].Id; }
                            lstCPFReport2 = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId AND Component__c = 'Tuberculosis' Limit 1 ];
                            if(!lstCPFReport2.isEmpty()){
                                strCPFReportId2 = lstCPFReport2[0].Id; }
                        }
                        
                    }                
                }
            }else if(TempId == 'a0L'){
                lstModule = [Select Concept_note__c, Concept_Note__r.Component__c, Concept_note__r.Program_Split__c,Concept_Note__r.Language__c,Implementation_Period__c,Catalog_Module__r.French_Name__c,Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c 
                            From Module__c Where Id =: strId And Concept_note__c != null Limit 1];                
                if(lstModule.size() > 0) {
                    if(lstModule[0].Concept_note__c != null){
                        strConceptNoteId = lstModule[0].Concept_note__c;
                        strProgramSplitId = lstModule[0].Concept_note__r.Program_Split__c;
                        strComponent = lstModule[0].Concept_Note__r.Component__c;
                        //strLanguage = lstModule[0].Concept_Note__r.Language__c;
                        lstPages = [Select Id,Name,URL_Prefix__c,Order__c, Modular__c, Read_Only__c,Concept_Note__c,French_Name__c,Spanish_Name__c,Russian_Name__c,Standard_Controller__c From Page__c Where Concept_Note__c =: strConceptNoteId AND Name != 'Guidance' Order by Order__c];
                        lstModules = [Select Id,Name,Concept_Note__c,Implementation_Period__c,Catalog_Module__r.French_Name__c,Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c From Module__c Where Concept_Note__c =: strConceptNoteID Order by Modular_Order__c NULLS LAST]; 
                        lstModulesPG = [Select Id,Name,Catalog_Module__r.French_Name__c,Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c  from Module__c where Concept_Note__c =: strConceptNoteId and Catalog_Module__r.Available_for_Programmatic_Gap__c = true Order by Modular_Order__c NULLS LAST];
                        if(strComponent != 'HIV/TB'){
                            lstCPFReport = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId Limit 1];
                            if(!lstCPFReport.isEmpty()){
                                strCPFReportId = lstCPFReport[0].Id; }
                        } else {
                            lstCPFReport = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId AND Component__c = 'HIV/AIDS' Limit 1];
                            if(!lstCPFReport.isEmpty()){
                                strCPFReportId = lstCPFReport[0].Id; }
                            lstCPFReport2 = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId AND Component__c = 'Tuberculosis' Limit 1 ];
                            if(!lstCPFReport2.isEmpty()){
                                strCPFReportId2 = lstCPFReport2[0].Id; }
                        }
                    }             
                }
            }else if(TempId == 'a0E'){
                strConceptNoteId = strId;
                List<Concept_Note__c> lstConceptNote = [Select Id, Program_Split__c, Component__c, Language__c from Concept_Note__c where Id = :strConceptNoteId];
                    if(!lstConceptNote.isEmpty()) {
                        strProgramSplitId = lstConceptNote[0].Program_Split__c; 
                        strLanguage = lstConceptNote[0].Language__c;
                        strComponent = lstConceptNote[0].Component__c;
                    }
                lstPages = [Select Id,Name,URL_Prefix__c,Order__c, Modular__c, Read_Only__c,Concept_Note__c,French_Name__c,Spanish_Name__c,Russian_Name__c,Standard_Controller__c From Page__c Where Concept_Note__c =: strConceptNoteId AND Name != 'Guidance' Order by Order__c];
                lstModules = [Select Id,Name,Concept_Note__c,Implementation_Period__c,Catalog_Module__r.French_Name__c,Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c From Module__c Where Concept_Note__c =: strConceptNoteID Order by Modular_Order__c NULLS LAST]; 
                lstModulesPG = [Select Id,Name,Catalog_Module__r.French_Name__c,Catalog_Module__r.Spanish_Name__c,Catalog_Module__r.Russian_Name__c from Module__c where Concept_Note__c =: strConceptNoteId and Catalog_Module__r.Available_for_Programmatic_Gap__c = true Order by Modular_Order__c NULLS LAST];
                if(strComponent != 'HIV/TB'){
                    lstCPFReport = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId Limit 1];
                    if(!lstCPFReport.isEmpty()){
                        strCPFReportId = lstCPFReport[0].Id; }
                } else {
                    lstCPFReport = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId AND Component__c = 'HIV/AIDS' Limit 1];
                    if(!lstCPFReport.isEmpty()){
                        strCPFReportId = lstCPFReport[0].Id; }
                    lstCPFReport2 = [Select Id from CPF_Report__c where Concept_Note__c =: strConceptNoteId AND Component__c = 'Tuberculosis' Limit 1 ];
                    if(!lstCPFReport2.isEmpty()){
                        strCPFReportId2 = lstCPFReport2[0].Id; }
                }
             }
        }
        
         strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
    }
    //TCS 11/09/2014 Added for giving Permission based on profile 
     public void checkProfile(){
      blnExternalPro =false;
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         
         List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
       
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='Sidebar' and Profile_Name__c =: profileName ];
      
      for (Profile_Access_Setting_CN__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
      }
     }
}