@isTest
Public Class TestCPFReport{
    Public static testMethod void TestCPFReport(){
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Financial Gap Analysis & Counterpart Financing';
        insert objGuidance;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        /*Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Status__c = 'Submitted to the Global Fund';
        insert objCN;*/
        
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Number_of_Years__c = '4';
        objCN.Status__c = 'Submitted to the Global Fund';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
        insert objCN;
        
        CPF_Report__c objCPF = new CPF_Report__c();
        objCPF.Implementation_cycle__c = 'January - December';
        objCPF.Concept_Note__c = objCN.Id;
        objCPF.Indicative_Y1__c = 10;
        objCPF.Indicative_Y2__c = 20;
        objCPF.Indicative_Y3__c = 10;
        objCPF.Indicative_Y4__c = 30;
        insert objCPF;
        
        Apexpages.currentpage().getparameters().put('id',objCPF.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objCPF);
        CPFReport objCls = new CPFReport(sc);
        
        objCls.actionShowHistoryPopUp();
        Apexpages.currentpage().getparameters().put('pramRecordId','0');
        Apexpages.currentpage().getparameters().put('pramRecordName','test');
        objCls.getshowHistoryPopup();
        objCls.HidePopupHistory();
        
        objCls.AddNewFSC();
        apexpages.currentpage().getparameters().put('DeleteIndex','0');
        objCls.DeleteNewFSC();
        objCls.SaveRecordsAndReturnCPF();
        objCls.RefreshLineD();
    }
    Public static testMethod void CheckProfileTest2(){
    	
    	Account objAcc =TestClassHelper.insertAccount();
    	
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.Number_of_Years__c = '4';
        objCN.Status__c = 'Not yet submitted';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Start_Date__c= system.today();
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
        CPFReport objPg = new CPFReport(sc);
    	
    	Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CPFReport';
        checkProfile.Salesforce_Item__c = 'Save and Return';
        checkProfile.Status__c = 'Not yet submitted'; 
        //checkProfile.Profile_Name__c = 'Applicant/CM Admin';       
        insert checkProfile;
        objpg.checkProfile(); 
    }
}