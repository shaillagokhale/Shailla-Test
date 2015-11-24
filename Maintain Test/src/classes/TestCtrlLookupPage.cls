/*********************************************************************************
* {Test} Class: {TestCtrlLookupPage}
* Created by {DeveloperName},  {DateCreated 07/26/2013}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of CtrlLookupPage Controller.* 
*
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
   1.0                        07/26/2013
*********************************************************************************/
@isTest
Public class TestCtrlLookupPage{
    Public static testMethod Void TestCtrlLookupPage(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Country__c objCountry = new Country__c();
        objCountry.Name = 'Test Country';
        objCountry.Region_Name__c ='Test Region';
        insert objCountry;
        
        LFA_Work_Plan__c objWp = new LFA_Work_Plan__c();
        objWp.Name = 'Test Wp';
        objWp.LFA__c = objAcc.Id;
        objWp.Country__c = objCountry.id;
        insert objWp;
        
        Contact objCon = new Contact();
        objCon.AccountId = objAcc.Id;
        objCon.FirstName = 'Test FirstName';
        objCon.LastName = 'Test LastName';        
        objCon.Active_LFA_Member__c = 'yes';
        objCon.Level_of_Experience__c = 'test';
        insert objCon;
        
        System.currentPageReference().getparameters().put('lktp','Contact');
        System.currentPageReference().getParameters().Put('idfield',objAcc.Id);
        System.currentPageReference().getParameters().Put('Country',objCountry.Id);  
        CtrlLookupPage objLookupPage = new CtrlLookupPage();
        objLookupPage.searchString = 'test';
        objLookupPage.getFormTag();
        objLookupPage.getTextBox();
        objLookupPage.search();
    }        
}