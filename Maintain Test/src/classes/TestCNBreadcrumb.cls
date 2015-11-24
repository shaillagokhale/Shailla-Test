@isTest
Public Class TestCNBreadcrumb{
    Public static testMethod void TestCNBreadcrumb(){
        
        Country__c obCountry = new Country__c();
        obCountry.Name = 'Testcountry';
        obCountry.French_Name__c = 'TestFrench';
        obCountry.Russian_Name__c = 'TestRussian';
        obCountry.Spanish_Name__c = 'TestSpanish';
        insert obCountry;
         
        Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CNBreadcrum';
        checkProfile.Salesforce_Item__c = 'Upload Doc GF Internal View';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile; 
        
        Account objacc = new Account();
        objacc.name = 'testacc';
        objacc.Country__c = obCountry.id;
        insert objacc;
    
         Program_Split__c objPrgmSplit = new Program_Split__c();
        objPrgmSplit.CCM__c = objacc.Id;
        insert objPrgmSplit;
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.Name = 'TestName';
        objConceptNote.CurrencyIsoCode = 'EUR';
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.Language__c = 'ENGLISH';
        objConceptNote.CCM_new__c = objacc.id;
        objConceptNote.Program_Split__c = objPrgmSplit.Id;
        insert objConceptNote;
        
        page__c objpage = new page__c();
        objpage.Name = 'Test';
        objpage.Concept_Note__c = objConceptNote.id;
        insert objpage;
        
        Module__c objModule = new Module__c();
        objModule.Concept_Note__c = objConceptNote.id;
        objModule.Name = 'TestModule';
        objModule.CurrencyIsoCode = 'EUR';
        insert objModule;
        
        CPF_Report__c cpfReport = new CPF_Report__c();
        cpfReport.Concept_Note__c = objConceptNote.Id;
        insert cpfReport;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr', 
        LocaleSidKey='fr', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='test1@fb.com');

        CNBreadcrumb objCNBreadcrumb = new CNBreadcrumb();
        
        System.runAs(u){
                       
        objCNBreadcrumb.strCountryName = obCountry.French_Name__c;
        objCNBreadcrumb.strConceptNoteId = objConceptNote.id;
        objCNBreadcrumb.strCNName = 'CN Test';
        objCNBreadcrumb.strCountryId = obCountry.id;
        objCNBreadcrumb.getParameters();
        System.assertEquals(System.UserInfo.getLanguage(),'fr');
        
        u.LanguageLocaleKey='es';
        u.LocaleSidKey = 'es';
        update u;
        objCNBreadcrumb.strCountryName = obCountry.Russian_Name__c;
        
        objCNBreadcrumb.getParameters();
        System.assertEquals(System.UserInfo.getLanguage(),'es');
        
        u.LanguageLocaleKey='ru';
        u.LocaleSidKey = 'ru';
        update u;
        objCNBreadcrumb.strCountryName = obCountry.Spanish_Name__c;
        
        objCNBreadcrumb.getParameters();
        System.assertEquals(System.UserInfo.getLanguage(),'ru');
        }

        objCNBreadcrumb.strId = objModule.id;
        objCNBreadcrumb.getParameters();

        objCNBreadcrumb.strId = objpage.id;
        objCNBreadcrumb.getParameters();

        objCNBreadcrumb.strId = objConceptNote.id;
        objCNBreadcrumb.getParameters();   
        
         

 }
}