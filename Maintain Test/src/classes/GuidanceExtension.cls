public with sharing class GuidanceExtension {

    public String strLanguage {get; set;}

    public GuidanceExtension(ApexPages.StandardController controller) {
        
       if(ApexPages.currentPage().getParameters().get('lang') != NULL){
        strLanguage = ApexPages.currentPage().getParameters().get('lang'); } 
    

    }

}