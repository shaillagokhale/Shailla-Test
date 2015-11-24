/*********************************************************************************
* Test Class: {TesttrgSubmitForApproval}
*  DateCreated : 01/30/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of trgSubmitForApproval.
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      01/30/2014      INITIAL DEVELOPMENT
*********************************************************************************/

@isTest
Public Class TesttrgSubmitForApproval{
    Public static testMethod void TesttrgSubmitForApproval(){
        
        Account objAcc = new Account();
        objAcc.name = 'test Acc';
        objAcc.CT_Finance_Officer__c = userinfo.getuserId();
        insert objAcc;
                
        objAcc.Approval_Status__c = 'Finance Officer verification';
        update objAcc;
    }
}