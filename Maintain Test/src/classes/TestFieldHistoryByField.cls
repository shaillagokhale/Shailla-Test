@isTest
Public Class TestFieldHistoryByField{
    Public static testMethod void TestFieldHistoryByField(){    
        
        
        
        FieldHistoryByField objFH = new FieldHistoryByField();
        objFH.strObjectName = 'Implementation_Period__c';
        objFH.lstFieldNames = new String[] {'Rationale_for_Program__c'};
        objFH.getRetrieveFieldHistory();
        
    }
}