@isTest
Public Class TestCreatePR{
    Public static TestMethod void TestCreatePR(){
        Country__c objCountry = new Country__c();
        objCountry.Name = 'Test Country';
        insert objCountry;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Page__c objPage = new Page__c();
        objPage.Name = 'Test Page';
        insert objPage;
        
        Apexpages.currentpage().getParameters().put('cnId',objCN.Id);
        Apexpages.currentpage().getParameters().put('pageId',objPage.Id);
        Apexpages.currentpage().getParameters().put('language','fr');
        Apexpages.currentpage().getParameters().put('GM','GM');
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
        CreatePR objCPR = new CreatePR(sc);
        objCPR.cnStart = system.today();
        objCPR.cnEnd = system.today();
        objCPR.component = '10';
        objCPR.ccmId = objAcc.Id;
        objCPR.countryId = objCountry.Id;
        objCPR.length = '10';
        objCPR.cnLocalCurrency = '10';
        objCPR.cnGrantCurrency = '10';
        objCPR.objAccount = new Account(Name = 'test');
        objCPR.saveRecord();
        
        Apexpages.currentpage().getParameters().put('cnId',objCN.Id);
        Apexpages.currentpage().getParameters().put('pageId',objPage.Id);
        Apexpages.currentpage().getParameters().put('language','ru');
        Apexpages.currentpage().getParameters().put('GM','GM');
        ApexPages.StandardController sc1 = new ApexPages.StandardController(objAcc);
        CreatePR objCPR1 = new CreatePR(sc1);
        
        Apexpages.currentpage().getParameters().put('cnId',objCN.Id);
        Apexpages.currentpage().getParameters().put('pageId',objPage.Id);
        Apexpages.currentpage().getParameters().put('language','es');
        Apexpages.currentpage().getParameters().put('GM','GM');
        ApexPages.StandardController sc2 = new ApexPages.StandardController(objAcc);
        CreatePR objCPR2 = new CreatePR(sc2);
    }
}