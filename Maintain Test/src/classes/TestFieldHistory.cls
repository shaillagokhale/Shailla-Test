@isTest
Public Class TestFieldHistory{
    Public static testMethod void TestFieldHistory(){    
        
        FieldHistory objFH = new FieldHistory();
        objFH.strObjectName = 'Implementation_Period__c';
        objFH.getRetrieveFieldHistory();
        
    }
}