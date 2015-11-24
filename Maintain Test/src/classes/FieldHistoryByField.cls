/*********************************************************************************
* Controller Class: FieldHistoryByField
* DateCreated:  18/09/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - This is a generic component to show history of specified fields.
    This needs following attribute/arguments to pass:
  1. TargetRecordId - Target get Record Id to show history of
  2. TagetObjectAPIname - Target Object (Standard/Custom) API Name
  3. RecordTitle - Title for the history table 
  4. FieldNames - Array of field names
----------------------------------------------------------------------------------
* Unit Test: 
----------------------------------------------------------------------------------
* History:
* - VERSION  DATE            DETAIL FEATURES
    1.0      18/09/2014      INITIAL DEVELOPMENT   
*********************************************************************************/
Public Class FieldHistoryByField{
    Public List<sObject> lstHistoryObject{get;set;} // Stores list of field history object records
    Public String strRecordId{get;set;} // Stores Target Record Id passed from attributes
    Public String strObjectName {get;set;} // Stores Taget Object API name passed from attributes
    Public String strRecordTitle{get;set;} // Stores Record Title passed from attributes
    Public Map<String, String > mapfield{get;set;} // Stores field API name and Label pair to show Label from API name on Page
    Public String [] lstFieldNames {get; set;}
    Public Boolean blnRp{get;set;}
    
    /**********************************************************************************************
    Purpose: - Retrieves complete History of the Traget object for the specified record id
             - also sets the Map with field API name as key and field label as value to be used in VF page
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    **********************************************************************************************/
    Public void getRetrieveFieldHistory(){
        System.Debug('Entering getRetrieveFieldHistory');
        System.Debug('Parameters[0] strObjectName: ' + strObjectName);
        System.Debug('Parameters[1] strRecordId: ' + strRecordId);
        String strQuery;
        String strTargetIDField;
        String strHistoryObjectName = strObjectName;
        String strfieldRationale;
        String strfieldGoals;
        String strfieldTargets;
        
        
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
        
        if(lstFieldNames[0] == 'Reporting_Frequency__c' || lstFieldNames[0] == 'Disaggregated_Baseline_Sources__c'){
        blnRP = true;
        }
        strQuery = 'SELECT CreatedBy.Name,Id, IsDeleted, CreatedById, CreatedDate, Field, OldValue, NewValue,ParentID FROM ';
        //strQuery += strHistoryObjectName +' where ' + strTargetIDField + ' =: strRecordId' + ' AND (Field =:strfieldRationale ' + ' OR Field =:strfieldGoals' + ' OR Field =:strfieldTargets)' + ' ORDER BY CreatedDate DESC,Field asc';       
        strQuery += strHistoryObjectName +' where ' + strTargetIDField + ' =: strRecordId' + ' AND Field IN : lstFieldNames ' + ' ORDER BY CreatedDate DESC,Field asc';
        System.Debug('strQuery : ' + strQuery );
        lstHistoryObject = Database.Query(strQuery );
        
        // To have Map of Field API name and Label of the Trage object, to show Field label by field API name because
        // History (Sobject) contains onle field API name
        mapfield =new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap=new Map<String, Schema.SObjectField>();
        fieldMap = Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sobj : fieldMap.values() ){
            mapfield.put(sobj.getDescribe().getName(),sobj.getDescribe().getLabel());
        }
        
        //Putting fields which are not in the mapfield but in the list like 'created' etc
        for(sObject objHistory : lstHistoryObject){
            if(mapfield.containsKey(string.valueOf(objHistory.get('Field')))==false){
                mapfield.put(string.valueOf(objHistory.get('Field')),string.valueOf(objHistory.get('Field')));
            }
        }
        System.Debug('Entering getRetrieveFieldHistory');        
    }
}