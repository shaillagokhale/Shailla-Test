@isTest
Public Class TestSidebar{
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
        objCN.Program_Split__c = objPrgmSplit.Id;
        insert objCN;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
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
        
        
        Sidebar objS = new Sidebar();
        objS.strId = objPage.Id;
        objS.getParameters();
        
        Sidebar objS1 = new Sidebar();
        objS1.strId = objModule.Id;
        objS1.getParameters();
        
        Sidebar objS2 = new Sidebar();
        objS2.strId = objCN.Id;
        objS2.getParameters();
    }
    
    Public static testMethod void TestSidebar1(){
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
         Program_Split__c objPrgmSplit = new Program_Split__c();
        objPrgmSplit.CCM__c = objAcc.Id;
        insert objPrgmSplit;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        objCN.Program_Split__c = objPrgmSplit.Id;
        insert objCN;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.id;        
        objIP.Length_Years__c = '4';
        insert objIP;
        
        Page__c objPage = new Page__c();
        objPage.Concept_note__c = objCN.Id;
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;
        
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
        
        Sidebar objS = new Sidebar();
        objS.strId = objPage.Id;
        objS.getParameters();
        
        Sidebar objS1 = new Sidebar();
        objS1.strId = objModule.Id;
        objS1.getParameters();
        
        Sidebar objS2 = new Sidebar();
        objS2.strId = objCN.Id;
        objS2.getParameters();
    }
    
     Public static testMethod void CheckProfileTest2(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
    	
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Number_of_Years__c = '4';
        objCN.Status__c = 'Not yet submitted';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
        objCN.Component__c ='HIV/TB';
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Name = 'Test_IP';
        objIP.Principal_Recipient__c = objAcc.Id;
        insert objIP;


        Catalog_Module__c objCM = new Catalog_Module__c();
        objCM.Name = 'Test_CM';
        
        insert objCM;

        Module__c objModule = new Module__c();
        objModule.Name='Test_Module';
        objModule.Implementation_Period__c = objIP.Id;
        objModule.Catalog_Module__c = objCM.Id;
        insert objModule; 
        
        CPF_Report__c objCPF = new CPF_Report__c();
        objCPF.Implementation_cycle__c = 'January - December';
        objCPF.Concept_Note__c = objCN.Id;
        objCPF.Indicative_Y1__c = 10;
        objCPF.Indicative_Y2__c = 20;
        objCPF.Indicative_Y3__c = 10;
        objCPF.Indicative_Y4__c = 30;
        insert objCPF;
    	
    	Apexpages.currentpage().getparameters().put('id',objCPF.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        Sidebar objSidebar = new Sidebar();
        objSidebar.strId = objPage.Id;
        
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='Sidebar';
        checkProfile.Salesforce_Item__c = 'External Profile';
        checkProfile.Status__c = 'Not yet submitted'; 
        //checkProfile.Profile_Name__c = 'Applicant/CM Admin';       
        insert checkProfile;
        objSidebar.checkProfile(); 
    }
}