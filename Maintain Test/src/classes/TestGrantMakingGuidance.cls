@isTest
Public Class TestGrantMakingGuidance {
    Public static testMethod void TestGrantMakingGuidance (){
         Guidance__c objGuidance = new Guidance__c();
         objGuidance.Name = 'test';
         insert objGuidance;
         
         GrantMakingGuidance objGrantMakingGuidance = new GrantMakingGuidance ();  
         
         ApexPages.currentPage().getParameters().put('Id',objGuidance.id);
         ApexPages.currentPage().getParameters().put('Id2',objGuidance.id);       
         ApexPages.currentPage().getParameters().put('lang','EN');  
         
         objGrantMakingGuidance = new GrantMakingGuidance ();  
    
         
         ApexPages.currentPage().getParameters().put('Id','12121');
         ApexPages.currentPage().getParameters().put('Id2','12121'); 
         
         
    }
    
}