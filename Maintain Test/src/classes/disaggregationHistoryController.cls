public with sharing class disaggregationHistoryController {
    Public List<sObject> lstHistoryObject{get;set;} // Stores list of field history object records
    Public String strRecordId{get;set;} // Stores Target Record Id passed from attributes
    Public String strObjectName {get;set;} // Stores Taget Object API name passed from attributes
    Public String strRecordTitle{get;set;} // Stores Record Title passed from attributes
    Public Map<String, String > mapfield{get;set;} // Stores field API name and Label pair to show Label from API name on Page
    Public Map<String, String > mapfield1{get;set;}
    Public List<sObject> lstHistoryRecords{get;set;}
    
    Public void getGrntDisaggregationFiedHistry() {
        String [] lstGranInfoFields = new String[] {'Disaggregated_Baseline_Sources__c', 'Disaggregated_Baseline_Year__c', 'Disaggregated_Baseline_Value__c'};
        //strRecordId = 'a02g00000077wBX';
        strObjectName = 'Grant_Disaggregated__c';
        String strQuery;
        String strTargetIDField;
        String strHistoryObjectName = strObjectName;        
        if(strObjectName.contains('__c')){
            //For Custom objects
            strHistoryObjectName= strHistoryObjectName.subString(0,strHistoryObjectName.length()-3);
            strTargetIDField = 'ParentID';
            strHistoryObjectName +='__History';
        }else{
            //For Standard objects
            strTargetIDField +='Id';
            strHistoryObjectName +='History';
        }
        lstHistoryRecords = [Select  Parent.Grant_Indicator__c, Parent.Component__c, Parent.Disaggregated_Baseline_Sources__c, 
                            Parent.Disaggregated_Baseline_Value__c, Parent.Disaggregated_Baseline_Year__c,
                            Parent.Name, Parent.Id, ParentId, OldValue, NewValue, Field, CreatedById, CreatedBy.Name, CreatedDate, 
                            Parent.Catalog_Disaggregated__r.Disaggregation_Category__c, Parent.Catalog_Disaggregated__r.Disaggregation_Value__c 
                            From Grant_Disaggregated__History 
                            WHERE Parent.Grant_Indicator__c =: strRecordId
                            ORDER BY CreatedDate DESC,Field asc];
        integer listSize = lstHistoryRecords.size();
        system.debug('**listSize'+listSize);
        for(integer i =0; i < listSize; i++) {
            system.debug('list valuesssssssss'+lstHistoryRecords[i].get('oldValue'));
            if(lstHistoryRecords[i].get('oldValue') == null || lstHistoryRecords[i].get('oldValue') == '--None--' || lstHistoryRecords[i].get('oldValue') =='') {
                lstHistoryRecords.remove(i);
                listSize -= 1;
                i -= 1;
            }
        }
        System.debug('***********'+lstHistoryRecords);      
        // To have Map of Field API name and Label of the Trage object, to show Field label by field API name because
        // History (Sobject) contains onle field API name
        mapfield1=new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
        fieldMap = Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sobj : fieldMap.values() ){
            mapfield1.put(sobj.getDescribe().getName(), sobj.getDescribe().getLabel());
        }
        
        //Putting fields which are not in the mapfield but in the list like 'created' etc
        for(sObject objHistory : lstHistoryRecords){
            if(mapfield1.containsKey(string.valueOf(objHistory.get('Field')))==false){
                mapfield1.put(string.valueOf(objHistory.get('Field')),string.valueOf(objHistory.get('Field')));
            }
        }
        
    }
}