@isTest
Public Class TestCNProgramSplit {
    Public static testMethod void TestCNProgramSplit (){
        
        Account objAccount = new Account();
        objAccount.name = 'test';
        insert objAccount;
        
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Program Split';
        insert objGuidance;
        
        Funding_Opportunity__c objFundOpp = new Funding_Opportunity__c (Name = '2014to16', isCurrent__c = true);
        insert objFundOpp;
        
        Program_Split__c objProgramSplit = new Program_Split__c();
        objProgramSplit.Name = 'test';
        objProgramSplit.CCM__c = objAccount.id;
        objProgramSplit.OPS_Submitted__c = true;
        objProgramSplit.RPS_Submitted__c = false;
        objProgramSplit.Language__c = 'SPANISH';
        objProgramSplit.Show_Combined_Concept_Note__c = false;
        insert objProgramSplit;
        
        Template__c objTemplate = new Template__c();
        objTemplate.name = 'test';
        insert objTemplate;
        
        Page__c objPage = new Page__c();
        objPage.Template__c = objTemplate.id;
        insert objPage;
        
        List<Concept_Note__c> lstConceptNote = new List<Concept_Note__c>();
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'Health Systems Strengthening';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        objConceptNote.Agreed_Split_USD__c = 200000;
        objConceptNote.Agreed_Split_EUR__c = 200000;
        lstConceptNote.Add(objConceptNote); 
        
        objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'HIV/AIDS';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        lstConceptNote.Add(objConceptNote);
        
        objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'Tuberculosis';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        lstConceptNote.Add(objConceptNote);
        
        objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'HIV/TB';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
         //Added
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        //
        lstConceptNote.Add(objConceptNote);
        
        insert lstConceptNote;
        
        Grant__c objGrant = new Grant__c();
        objGrant.Disease_Component__c  = 'Health Systems Strengthening';
        objGrant.Principal_Recipient__c = objAccount.id;
        insert objGrant;
        
       
        Implementation_Period__c objImplementationPeriod = new Implementation_Period__c();
        objImplementationPeriod.name='test';
        objImplementationPeriod.Principal_Recipient__c = objAccount.id;
        objImplementationPeriod.Start_Date__c = system.today();
        objImplementationPeriod.grant__c = objGrant.id;
        objImplementationPeriod.Concept_Note__c = objConceptNote.id;
        insert objImplementationPeriod;
        
       
        String user;
        Integer result;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objProgramSplit.id);
        CNProgramSplit objCNProgramSplit = new CNProgramSplit();
        //objCNProgramSplit.Save();
        objCNProgramSplit.SaveClose();
        objCNProgramSplit.SubmitProposedSplit();
        objCNProgramSplit.Cancel();
        objCNProgramSplit.QuickSave();
        objCNProgramSplit.changeView();
        objCNProgramSplit.DeleteFile();
        objCNProgramSplit.DeleteFileccm();
        objCNProgramSplit.LoadDocuments();
        Test.stopTest();
        
         Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CNProgramSplit';
        checkProfile.Salesforce_Item__c = 'Upload Doc GF Internal View';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        
        Profile_Access_Setting_CN__c checkProfile1 = TestClassHelper.createProfileSettingCN();
        checkProfile1.Page_Name__c ='CNProgramSplit';
        checkProfile1.Salesforce_Item__c = 'Evidence of CCM Endorsement';
        checkProfile1.Status__c = 'Not yet submitted';        
        insert checkProfile1;
        
        objCNProgramSplit.checkProfile(); 
    }
    
    Public static testMethod void TestCNProgramSplit1 (){
    
        Account objAccount = new Account();
        objAccount.name = 'test';
        insert objAccount;
        
        Template__c objTemplate = new Template__c();
        objTemplate.name = 'test2';
        insert objTemplate;
        
        Program_Split__c objProgramSplit = new Program_Split__c();
        objProgramSplit.Name = 'test';
        objProgramSplit.CCM__c = objAccount.id;
        objProgramSplit.OPS_Submitted__c = false;
        objProgramSplit.RPS_Submitted__c = true;
        objProgramSplit.Language__c = 'FRENCH';
        objProgramSplit.Show_Combined_Concept_Note__c = false;
        objProgramSplit.Escalated_Review__c = 'Elevated Automatically';
        objProgramSplit.Sign_Off_RM_Hod__c = true;
        objProgramSplit.Sign_Off_TAP__c = true;
        insert objProgramSplit;
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'HIV/TB';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        insert objConceptNote;
        
         FeedItem objFI = new FeedItem();
        objFI.parentId = objProgramSplit.Id;
        objFI.body = 'test';
        objFI.Type  = 'ContentPost';
        objFI.ContentFileName = 'TestDocument.txt';
        objFI.ContentData =  blob.valueof('TestDocument.txt');
     //   objFI.ContentDescription = 'Other Document'; 
        insert objFI;
        
        DocumentUpload__c objDocUpload = new DocumentUpload__c();
        objDocUpload.FeedItem_Id__c = objFI.Id;
        objDocUpload.TGF_Internal__c = true;
        objDocUpload.Description__c = 'Test';
        objDocUpload.Concept_Note__c = objConceptNote.Id;
        objDocUpload.Process_Area__c = 'Concept Note';
        objDocUpload.Program_Split__C = objProgramSplit.Id;
        insert objDocUpload;
        
         Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CNProgramSplit';
        checkProfile.Salesforce_Item__c = 'Save and Return';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        
        Profile_Access_Setting_CN__c checkProfile1 = TestClassHelper.createProfileSettingCN();
        checkProfile1.Page_Name__c ='CNProgramSplit';
        checkProfile1.Salesforce_Item__c = 'Internal GF Review Comment';
        checkProfile1.Status__c = 'Not yet submitted';        
        insert checkProfile1;
        
        
        
        ApexPages.currentPage().getParameters().put('Id',objProgramSplit.id);
        CNProgramSplit objCNProgramSplit = new CNProgramSplit();
        objCNProgramSplit.sortItemCCM = 4;
        objCNProgramSplit.sortItem = 4;
        objCNProgramSplit.submitSignoffTAP();
        objCNProgramSplit.SetAgreedSplit();
        objCNProgramSplit.RequestRPS();
        objCNProgramSplit.RejectRevisedSplit();
        objCNProgramSplit.SubmitProposedSplit();   
        //CNProgramSplit.fetchPermissionSet(user,result);
        objCNProgramSplit.UploadFile();
        objCNProgramSplit.removeRow();
        objCNProgramSplit.UpdateRationalRequestSplit();
        objCNProgramSplit.UpdateRationalRevisedSplit();
        objCNProgramSplit.sortByItem();
        objCNProgramSplit.sortByItemCCM();
        //objCNProgramSplit.uploadDocument();
        objCNProgramSplit.checkProfile(); 
    }
    
    Public static testMethod void TestCNProgramSplit2 (){
    
        Account objAccount = new Account();
        objAccount.name = 'test';
        insert objAccount;
        
        Template__c objTemplate = new Template__c();
        objTemplate.name = 'test1';
        insert objTemplate;
        
        Program_Split__c objProgramSplit = new Program_Split__c();
        objProgramSplit.Name = 'test';
        objProgramSplit.CCM__c = objAccount.id;
        objProgramSplit.OPS_Submitted__c = false;
        objProgramSplit.Agreed__c = true;
        objProgramSplit.RPS_Submitted__c = false;
        objProgramSplit.Show_Combined_Concept_Note__c = true;
        insert objProgramSplit;
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'Health Systems Strengthening';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        objConceptNote.Status__c = 'Not yet submitted';
        insert objConceptNote;
        
        FeedItem objFI = new FeedItem();
        objFI.parentId = objProgramSplit.Id;
        objFI.body = 'test';
        objFI.Type  = 'ContentPost';
        objFI.ContentFileName = 'TestDocument.txt';
        objFI.ContentData =  blob.valueof('TestDocument.txt');
     //   objFI.ContentDescription = 'Other Document'; 
        insert objFI;
        
        DocumentUpload__c objDocUpload = new DocumentUpload__c();
        objDocUpload.FeedItem_Id__c = objFI.Id;
        objDocUpload.TGF_Internal__c = false;
        objDocUpload.Description__c = 'Test';
        objDocUpload.Process_Area__c = 'Concept Note';
        objDocUpload.Concept_Note__c = objConceptNote.Id;
        objDocUpload.Program_Split__C = objProgramSplit.Id;
        insert objDocUpload;
        
        ApexPages.currentPage().getParameters().put('Id',objProgramSplit.id);
        CNProgramSplit objCNProgramSplit = new CNProgramSplit();
        objCNProgramSplit.uncheckSignoff();
        objCNProgramSplit.EscalateReview();
        objCNProgramSplit.RequestRPS();
        objCNProgramSplit.submitSignoffFPM();
        objCNProgramSplit.submitSignoffRM_HoD();
        objCNProgramSplit.UpdateGFComments();
        objCNProgramSplit.UpdateRationalProposedSplit();
        objCNProgramSplit.CancelRationaleforRequesting();
        objCNProgramSplit.CancelGlobalFundComments();
        objCNProgramSplit.CancelRationaleforRevised();
        objCNProgramSplit.CancelRationaleforProposed();
        objCNProgramSplit.CancelRationaleforProposed();
        
       Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CNProgramSplit';
        checkProfile.Salesforce_Item__c = 'External Profile';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        
        Profile_Access_Setting_CN__c checkProfile1 = TestClassHelper.createProfileSettingCN();
        checkProfile1.Page_Name__c ='CNProgramSplit';
        checkProfile1.Salesforce_Item__c = 'Quick Save';
        checkProfile1.Status__c = 'Not yet submitted';        
        insert checkProfile1;
        
        objCNProgramSplit.checkProfile(); 
    }
    Public static testMethod void TestCNProgramSplit3 (){
    
        Account objAccount = new Account();
        objAccount.name = 'test';
        insert objAccount;
        
        Template__c objTemplate = new Template__c();
        objTemplate.name = 'test2';
        insert objTemplate;
        
        Program_Split__c objProgramSplit = new Program_Split__c();
        objProgramSplit.Name = 'test';
        objProgramSplit.CCM__c = objAccount.id;
        objProgramSplit.OPS_Submitted__c = false;
        objProgramSplit.RPS_Submitted__c = true;
        objProgramSplit.Language__c = 'RUSSIAN';
        objProgramSplit.Show_Combined_Concept_Note__c = false;
        objProgramSplit.Escalated_Review__c = 'Elevated Automatically';
        objProgramSplit.Sign_Off_RM_Hod__c = true;
        objProgramSplit.Sign_Off_TAP__c = true;
        insert objProgramSplit;
        
        Concept_Note__c objConceptNote = new Concept_Note__c();
        objConceptNote.Program_Split__c = objProgramSplit.id;
        objConceptNote.CCM_new__c = objAccount.id;
        objConceptNote.Component__c = 'HIV/TB';
        objConceptNote.Page_Template__c = objTemplate.id;
        objConceptNote.Implementation_Period_Page_Template__c = objTemplate.id;
        objConceptNote.Communicated_Allocation_USD__c = 2000000;
        objConceptNote.Pre_MRL__c = 1000000;
        objConceptNote.Original_Proposed_Split__c = 2000000;
        objConceptNote.Revised_Proposed_Split__c = 1000000;
        insert objConceptNote;
        
         FeedItem objFI = new FeedItem();
        objFI.parentId = objProgramSplit.Id;
        objFI.body = 'test';
        objFI.Type  = 'ContentPost';
        objFI.ContentFileName = 'TestDocument.txt';
        objFI.ContentData =  blob.valueof('TestDocument.txt');
     //   objFI.ContentDescription = 'Other Document'; 
        insert objFI;
        
        DocumentUpload__c objDocUpload = new DocumentUpload__c();
        objDocUpload.FeedItem_Id__c = objFI.Id;
        objDocUpload.TGF_Internal__c = true;
        objDocUpload.Description__c = 'Test';
        objDocUpload.Concept_Note__c = objConceptNote.Id;
        objDocUpload.Process_Area__c = 'Concept Note';
        objDocUpload.Program_Split__C = objProgramSplit.Id;
        insert objDocUpload;
        
         Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CNProgramSplit';
        checkProfile.Salesforce_Item__c = 'Save and Return';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        
        Profile_Access_Setting_CN__c checkProfile1 = TestClassHelper.createProfileSettingCN();
        checkProfile1.Page_Name__c ='CNProgramSplit';
        checkProfile1.Salesforce_Item__c = 'Internal GF Review Comment';
        checkProfile1.Status__c = 'Not yet submitted';        
        insert checkProfile1;
        
        
        
        ApexPages.currentPage().getParameters().put('Id',objProgramSplit.id);
        CNProgramSplit objCNProgramSplit = new CNProgramSplit();
        objCNProgramSplit.sortItemCCM = 4;
        objCNProgramSplit.sortItem = 4;
        objCNProgramSplit.submitSignoffTAP();
        objCNProgramSplit.SetAgreedSplit();
        objCNProgramSplit.RequestRPS();
        objCNProgramSplit.RejectRevisedSplit();
        objCNProgramSplit.SubmitProposedSplit();   
        //CNProgramSplit.fetchPermissionSet(user,result);
        objCNProgramSplit.UploadFile();
        objCNProgramSplit.removeRow();
        objCNProgramSplit.UpdateRationalRequestSplit();
        objCNProgramSplit.UpdateRationalRevisedSplit();
        objCNProgramSplit.sortByItem();
        objCNProgramSplit.sortByItemCCM();
        //objCNProgramSplit.uploadDocument();
        objCNProgramSplit.checkProfile(); 
    }
    
    
}