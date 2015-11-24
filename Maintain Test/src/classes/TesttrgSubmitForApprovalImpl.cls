/*********************************************************************************
* Test Class: {TesttrgSubmitForApprovalImpl}
*  DateCreated : 01/30/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of trgSubmitForApprovalImpl.
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      01/30/2014      INITIAL DEVELOPMENT
*********************************************************************************/

@isTest
Public Class TesttrgSubmitForApprovalImpl{
    Public static testMethod void TesttrgSubmitForApprovalImpl(){
    
    Account objAcc = new Account();
    objAcc.name = 'test Acc';
    objAcc.CT_Finance_Officer__c = userinfo.getuserId();
    insert objAcc;
    
    Implementation_Period__c objImplementationPeriod = new Implementation_Period__c();
    objImplementationPeriod.Name = 'Test';
    objImplementationPeriod.Principal_Recipient__c = objAcc.id;
    objImplementationPeriod.CT_Finance_Officer__c = userinfo.getuserId();
    objImplementationPeriod.CT_Legal_Officer__c = userinfo.getuserId();
    objImplementationPeriod.Most_Recent_Submitter__c = userinfo.getuserId();
    insert objImplementationPeriod;
    
    objImplementationPeriod.Approval_Status__c = 'Legal Officer verification';
    update objImplementationPeriod;
    }
}