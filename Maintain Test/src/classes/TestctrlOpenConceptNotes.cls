@isTest
Public Class TestctrlOpenConceptNotes{
    Public Static testMethod void TestctrlOpenConceptNotes(){
        
        User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
        
        Guidance__c objGuidance1 = new Guidance__c();
        objGuidance1.Name = 'Open Concept Notes';
        insert objGuidance1;
        
        Account objAcct = new Account();
        objAcct.Name = 'Test Acct';
        insert objAcct;
        
        Country__c objCon = new Country__c();
        objCon.Name = objUser.Country;
        insert objCon;
        
        //Concept_Note__c objCN = new Concept_Note__c();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Name = 'Test con';
        objCN.CCM_New__c = objAcct.id;
        objCN.Proposed_Amount__c = 12000;
        objCN.Final_Allocation__c = 10.25;
        objCN.CurrencyIsoCode = 'EUR';
        insert objCN;
        
        //Concept_Note__c objCN2 = new Concept_Note__c();
        Concept_Note__c objCN2 = TestClassHelper.createCN();
        objCN2.Name = 'Test con';
        objCN2.CCM_New__c = objAcct.id;
        objCN2.Proposed_Amount__c = 12000;
        objCN2.Final_Allocation__c = 10.25;
        insert objCN2;
        
         PageReference objPageReference = new PageReference('google.com');
        //Apexpages.currentpage().getParameters().put('id',objCN.id);
        ApexPages.StandardController std = new ApexPages.StandardController(objCN);
        ctrlOpenConceptNotes obj = new ctrlOpenConceptNotes(std);
        
        obj.ConceptNoteByCountry();
        
        System.runAs(objUser){
          obj.FillCountry(objUser.Country);
         System.assertEquals(System.UserInfo.getLanguage(),'en_US');  
             
          objUser.LanguageLocaleKey='es';
          objUser.LocaleSidKey = 'es';
          update objUser;
          obj.FillCountry(objUser.Country);
          System.assertEquals(System.UserInfo.getLanguage(),'es');   
            
             
           objUser.LanguageLocaleKey='ru';
           objUser.LocaleSidKey = 'ru';
           update objUser;
          obj.FillCountry(objUser.Country);
           System.assertEquals(System.UserInfo.getLanguage(),'ru');   
            
            objUser.LanguageLocaleKey='fr';
          objUser.LocaleSidKey = 'fr';
          update objUser;
          obj.FillCountry(objUser.Country);
          System.assertEquals(System.UserInfo.getLanguage(),'fr');
             
         }
                
        obj.FillCountry(objUser.Country);
        obj.CalculateIndicativeAmount();
        obj.CalculateProposedAmount();
        obj.SaveChanges();
        objPageReference = obj.pageRedirect();
                       
        //Concept_Note__c objCN1 = new Concept_Note__c();
        Concept_Note__c objCN1 = TestClassHelper.createCN();
        objCN1.Name = 'Test CN';
        objCN1.CCM_New__c = objAcct.id;
        objCN1.Proposed_Amount__c = 0;
        insert objCN1;
        
        ApexPages.StandardController std1 = new ApexPages.StandardController(objCN1);
        obj = new ctrlOpenConceptNotes(std1);
        obj.CalculateIndicativeAmount();
        obj.CalculateProposedAmount();
    }
    Public static testMethod void CheckProfileTest4(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
    	
    	User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
    	
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Country__c objCon = new Country__c();
        objCon.Name = objUser.Country;
        insert objCon;
        
       
    	
    	Apexpages.currentpage().getparameters().put('id',objCon.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objCon);
        ctrlOpenConceptNotes objPg = new ctrlOpenConceptNotes(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='OpenConceptNoteH';
        checkProfile.Salesforce_Item__c = 'Start Date';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        objPg.SaveChanges();
        objPg.ConceptNoteByCountry();
        objpg.checkProfile(); 
    }
}