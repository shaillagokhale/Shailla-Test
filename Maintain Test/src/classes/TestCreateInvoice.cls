/*********************************************************************************
* {Test} Class: {TestCreateInvoice}
* Created by {DeveloperName},  {DateCreated 07/26/2013}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for cover all methods of CreateInvoice Controller.* 
*
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
   1.0                        03/07/2013
*********************************************************************************/

@isTest
Public class TestCreateInvoice{
    Public static testMethod Void TestCreateInvoice(){
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
        
        LFA_Service__c objService = new LFA_Service__c();
        objService.Name='Test1';
        objService.LFA_Work_Plan__c = objWp.Id;
        objService.Service_Type__c = 'Key Services';
        objService.Status__c = 'TGF Agreed';
        insert objService;
        
        LFA_Invoice__c objIn = new LFA_Invoice__c();
        objIn.Name = 'Test1';
        objIn.LFA_Work_Plan__c = objWp.Id;
        objIn.Type__c = 'Services';
        Insert objIn;
        
        LFA_Invoice__c objIn2 = new LFA_Invoice__c();
        objIn2.Name = 'Test2';
        objIn2.LFA_Work_Plan__c = objWp.Id;
        objIn2.Type__c = 'Draft';
        Insert objIn2;
        
        LFA_Invoice__c objIn1 = new LFA_Invoice__c();
        objIn1.Name = 'Test1';
        objIn1.LFA_Work_Plan__c = objWp.Id;
        objIn1.Type__c = 'Services';
        
        Service_Invoice__c objSI = new Service_Invoice__c();
        objSI.LFA_Invoice__c = objIn.Id;
        objSI.LFA_Service__c = objService.Id;
        Insert objSI;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(objWp);
        Apexpages.currentpage().getparameters().put('Id',objWp.Id);
        CreateInvoice objCI1 = new CreateInvoice(sc1);
        
        Apexpages.currentpage().getparameters().put('InvoiceId',objIn.Id);
        Apexpages.currentpage().getparameters().put('Id',objWp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objWp);
        CreateInvoice objCI = new CreateInvoice(sc);
        objCI.objInvoice = objIn1;
        objCI.decTotalValue = 1000;
        objCI.lstwrapServicesType[0].lstwrapServices[0].blnIsChecked = true;
        objCI.ShowServices();
        objCI.SubmitInvoice();
        objCI.SaveDraft();
        objCI.CancelToWorkPlan();
        //have added this for testing purposes test
        
        
    }
}