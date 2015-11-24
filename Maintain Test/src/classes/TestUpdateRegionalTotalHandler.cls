@isTest
Public Class TestUpdateRegionalTotalHandler{
    Public static testMethod void TestaiuUpdateRegionalTotalForRegionalBudgets(){
        Account objAcc = new Account();
        objAcc.name = 'Test Acc';
        objAcc.Short_Name__c= 'Test Acc';
        insert objAcc;
        
        Regional_Budget__c objRB = new Regional_Budget__c();
        objRB.Name = 'Test';
        insert objRB;
        
        LFA_Work_Plan__c objWP = new LFA_Work_Plan__c();
        objWP.LFA__c = objAcc.Id;
        objWP.Regional_Budget__c = objRB.id;
        objWP.Budgeted_ODC__c = 12;
        insert objWP;
        
        objWP.Budgeted_ODC__c = 14;
        update objWP;
        
        Delete objWP;
    }
}