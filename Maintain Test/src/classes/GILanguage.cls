Public Class GILanguage{
    Public Static Map<String, String> getMultiLingualText(String Language, String pageName){
        Map<String, String> mapLingual = new Map<String, String>();
        
        String query = 'Select Key__c, ';
        if(Language <> null && Language.trim().toUpperCase()=='FRENCH'){
            query += 'French_Text__c ';
        }
        else if(Language <> null && Language.trim().toUpperCase()=='SPANISH'){
            query += 'Spanish_Text__c ';
        }
        else{
            query += 'English_Text__c ';
        }
        query += 'From Project_multi_lingual__c ';
        query += 'Where Group_Name__c = \'' + pageName + '\' or Group_Name__c = \'GIButtons\' or Group_Name__c = \'psMessage\'';
        
        List<Project_multi_lingual__c> lstPrj = database.Query(query);
        
        if(lstPrj <> null && lstPrj.size()>0){
            for(Project_multi_lingual__c prj: lstPrj){
                String strText = '';
                if(Language <> null && Language.trim().toUpperCase()=='FRENCH'){
                    strText = prj.French_Text__c;
                }
                else if(Language <> null && Language.trim().toUpperCase()=='SPANISH'){
                    strText = prj.Spanish_Text__c;
                }
                else{
                    strText = prj.English_Text__c;
                }
                mapLingual.put(prj.Key__c, strText);
            }
        }
        
        return mapLingual;
    }
}