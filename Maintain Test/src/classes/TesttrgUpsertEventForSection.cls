@isTest
Public Class TesttrgUpsertEventForSection{
    Public Static testMethod void TesttrgUpsertEventForSection(){
        Organisations__c objOrg = new Organisations__c();
        objOrg.Name = 'Test Org';
        insert objOrg;
        
        Account objacct = new Account();
        objacct.Name='Test';
        objacct.Approval_Status__c = 'Approved';
        insert objAcct; 
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test con';
        objCN.CCM__c = objOrg.id;
        objCN.CCM_new__c= objacct.id;
        objCN.Modules__c = 'Vector Control';
        insert objCN;
        
        Section__c objSec = new Section__c();
        objSec.name = 'Test Sec';
        objSec.Due_Date__c = System.Today();
        objSec.Concept_Note__c = objCN.id;
        insert objSec;
        
        objSec.Due_Date__c = System.Today().AddDays(1);
        Update objSec;
        
        objSec.Due_Date__c = null;
        Update objSec;
    }
}