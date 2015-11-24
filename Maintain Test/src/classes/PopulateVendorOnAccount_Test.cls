@isTest
Public Class PopulateVendorOnAccount_Test{
    Public static testMethod void PopulateVendorOnAccount_Test(){
    
    Account objAcc = new Account(Name = 'Test Account', Short_Name__c = 'TACC');
    insert objAcc;
                                 
    Vendor__c objVendor = new Vendor__c (Name = 'Test Account', AccountId__c = objAcc.Id);
    insert objVendor;
    
    }
}