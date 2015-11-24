public with sharing class CN_Training_temp {

Public String strLanguage {get;set;}
Public String strGuidanceArea {get;set;}

    public CN_Training_temp(){
    
    strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
 
    }
}