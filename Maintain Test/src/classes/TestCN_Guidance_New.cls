@isTest
Public Class TestCN_Guidance_New {
    Public static testMethod void TestCN_Guidance_New (){
         Guidance__c objGuidance = new Guidance__c();
         objGuidance.Name = 'test';
         insert objGuidance;
         
         CN_Guidance_New objCN_Guidance_New = new CN_Guidance_New ();  
         
         ApexPages.currentPage().getParameters().put('Id',objGuidance.id);
         ApexPages.currentPage().getParameters().put('Id2',objGuidance.id);       
         ApexPages.currentPage().getParameters().put('lang','EN');  
         
         objCN_Guidance_New = new CN_Guidance_New ();
         
         ApexPages.currentPage().getParameters().put('Id','12121');
         ApexPages.currentPage().getParameters().put('Id2','12121'); 
         
         objCN_Guidance_New = new CN_Guidance_New ();   
    }
}