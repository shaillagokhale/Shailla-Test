/*********************************************************************************
* Test Class: {TesttrgSubmitForApprovalBank}
*  DateCreated : 01/30/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of trgSubmitForApprovalBank.
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      01/30/2014      INITIAL DEVELOPMENT
*********************************************************************************/

@isTest
Public Class TesttrgSubmitForApprovalBank{
    Public static testMethod void TesttrgSubmitForApprovalBank(){
    
    Account objAcc = new Account();
    objAcc.Name = 'Test Account';
    insert objAcc;
    
    Bank_Account__c objBankAccount = new Bank_Account__c(Account__c = objAcc.Id);
    objBankAccount.CT_Finance_Officer__c = userinfo.getuserId();
    insert objBankAccount;
    
    objBankAccount.Approval_Status__c = 'Finance Officer verification';
    update objBankAccount;
    }
}