@isTest
Public Class TestCN_DocumentUpload{
    Public static testMethod void TestCN_DocumentUpload(){
        User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
        Guidance__c objGuidance = new Guidance__c();
        objGuidance.Name = 'Manage Documents';
        insert objGuidance;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        
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
        objCN.Status__c = 'Not yet submitted';
        objCN.Component__c = 'Health Systems Strengthening';
        objCN.Open__c = true;
        insert objCN;
        
        /* For objCN */
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        insert objModule;
              
        Blob b = Blob.valueOf('TestDocument.txt');  
        //objDocumentUpload = objDoc;
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        objPage.Concept_Note__c = objCN.id;
        insert objPage;   

       /* FeedItem objFI = New FeedItem(ContentFileName = 'TestFI.txt',Type='ContentPost',ContentData=blob.valueof('tttt'),ParentId = objCN.Id);
        Insert objFI;*/
        
        FeedItem objFI = new FeedItem();
        objFI.parentId = objCN.Id;
        objFI.body = 'test';
        objFI.Type  = 'ContentPost';
        objFI.ContentFileName = 'TestDocument.txt';
        objFI.ContentData =  blob.valueof('TestDocument.txt');
        objFI.ContentDescription = 'Other Document';
        insert objFI;
       
        DocumentUpload__c objDoc=new DocumentUpload__c();
        objDoc.Concept_Note__c = objCN.Id;
        objDoc.FeedItem_Id__c = objFI.id;
        objDoc.Process_Area__c = 'Concept Note';
        objDoc.Description__c = 'test';
        objDoc.Language__c = 'English';
        objDoc.Type__c = 'Concept note narrative';
        objDoc.Final_TRP_Document__c=true;
       // objDoc.Language_Code__c = 'EN';
        insert objDoc; 
        
        /* For objCN */
        Apexpages.currentpage().getparameters().put('id',objCN.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        CN_DocumentUpload objGI = new CN_DocumentUpload(sc);
        objGI.objFeedItem.ContentData = blob.valueof('TestDocument.txt');
        objGI.strConcept_NoteId = objCN.Id;
        objGI.sortItem = 4;
        objGI.objFeedItem.ContentFileName = 'TestDocument.txt';
        objGI.objDocumentUpload.Concept_Note__c = objCN.Id;
        objGI.objDocumentUpload.FeedItem_Id__c = objFI.id;
        objGI.objDocumentUpload.Process_Area__c = 'Concept Note';
        objGI.objDocumentUpload.Language__c = 'English';
        objGI.objDocumentUpload.Type__c = 'Concept note narrative';
        objGI.lstDocumentUpload.add(objDoc);
        System.debug('@@@@@@@@lstDocumentUpload'+objGI.lstDocumentUpload);
        CN_DocumentUpload.WrapperDocumentUpdload wrp=new CN_DocumentUpload.WrapperDocumentUpdload();
        wrp.objDocumentUpload  = objDoc;
        wrp.objFeedItem = objFI;
        objGI.lstWrpDocumentUpload.add(wrp);
        objGI.uploadFile();
        objGI.DeleteIndex = 0;
        objGI.sortByItem();
        objGI.Docupload = objDoc.Id;
        objGI.toggleField();
        objGI.downloadall();
        objGI.closedocs();
        objGI.DeleteFile();

        /* Added to improve code coverage from 62% to 75%*/
        //objGI.sortByItem();
       
    }  
       // CN_Documentupload CNDU = new CN_Documentupload();
      
        Public static testMethod void CN_DocumentUploadTest1(){
        
        Account objAcc =TestClassHelper.insertAccount();
        Concept_Note__c objCN = TestClassHelper.createCN();
        objCN.CCM_new__c = objAcc.Id;
        insert objCN;
        
        Page__c objPage = TestClassHelper.createPage();
        objPage.Concept_note__c = objCN.Id;
        insert objPage;
        
        Apexpages.currentpage().getparameters().put('id',objCN.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        CN_DocumentUpload objGI = new CN_DocumentUpload(sc);
        
        Profile_Access_Setting_CN__c checkProfile = TestClassHelper.createProfileSettingCN();
        checkProfile.Page_Name__c ='CN_DocumentUpload';
        checkProfile.Salesforce_Item__c = 'Upload Document';
        checkProfile.Status__c = 'Not yet submitted';        
        insert checkProfile;
        objGI.checkProfile(); 
    }
    
}