@isTest
Public Class TestGMSidebar{
    Public static testMethod void TestSidebar(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        
        Program_Split__c objPrgmSplit = new Program_Split__c();
        objPrgmSplit.CCM__c = objAcc.Id;
        insert objPrgmSplit;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Indicative_Amount__c = 10;
        objCN.Program_Split__c = objPrgmSplit.Id;
        objCN.Component__c = 'Health Systems Strengthening';
        objCN.Open__c = true;
        insert objCN;
        
        Concept_Note__c objCN1 = new Concept_Note__c();
        objCN1.Name = 'Test CN1';
        objCN1.Component__c = 'HIV/TB';
        objCN1.Language__c = 'SPANISH';
        objCN1.CCM_new__c = objAcc.Id;
        objCN1.Number_of_Years__c = '3';
        objCN1.Page_Template__c = objTemplate.Id;
        objCN1.Indicative_Amount__c = 10;
        insert objCN1;
        
        
        Grant__c objGrant  = TestClassHelper.createGrant(objAcc);
     	insert objGrant;
     
     	Implementation_Period__c IP = TestClassHelper.createIP(objGrant,objAcc);
        insert IP;
        
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Page__c objPage2 = new Page__c();
        objPage2.Concept_note__c = objCN1.Id;
        insert objPage2;
        
        Page__c objPage1 = new Page__c();
        objPage1.Implementation_Period__c = IP.Id;
        insert objPage1;
        
        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test CM';
        insert objCM;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Concept_note__c = objCN.Id;
        objModule.Catalog_Module__c = objCM.id;
        insert objModule;
        
        CPF_Report__c cpfReport = new CPF_Report__c();
        cpfReport.Concept_Note__c = objCN.Id;
        insert cpfReport;
        
        Test.startTest();
        GMSidebar objS = new GMSidebar();
        objS.strId = objPage.Id;
        objS.getParameters();
        objS.strId = objPage1.Id;
        objS.getParameters();
        objS.strId = objPage2.Id;
        objS.getParameters();
        
        GMSidebar objS1 = new GMSidebar();
        objS1.strId = objModule.Id;
        objS1.getParameters();
        objModule.Component__c = 'HIV/TB';
        objS1.getParameters();
        Test.StopTest();
        GMSidebar objS2 = new GMSidebar();
        objS2.strId = objCN.Id;
        objS2.getParameters();
        
        GMSidebar objS3 = new GMSidebar();
        objS3.strId = objCN1.Id;
        objS3.getParameters();
    
    	
        Profile_Access_Setting__c checkProfile = TestClassHelper.createProfileSetting();
        checkProfile.Page_Name__c ='GMSidebar';
        checkProfile.Salesforce_Item__c = 'External Profile';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        objS3.checkProfile(); 
    }

}