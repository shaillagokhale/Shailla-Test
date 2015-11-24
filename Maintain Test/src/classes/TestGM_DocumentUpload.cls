@isTest
Public Class TestGM_DocumentUpload{
    Public static testMethod void TestGM_DocumentUpload(){
    
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
        objCN.Program_Split__c = objPrgmSplit.Id;
        insert objCN;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        insert objModule;
        
      
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;   
          
        FeedItem objFI = new FeedItem();
        objFI.parentId = objCN.Id;
        objFI.body = 'test';
        objFI.Type  = 'ContentPost';
        objFI.ContentFileName = 'TestDocument.txt';
        objFI.ContentData =  blob.valueof('TestDocument.txt');
        objFI.ContentDescription = 'Detailed Budget XLS'; 
        //objFI.ContentSize = 1;
        insert objFI;
       
        DocumentUpload__c objDoc=new DocumentUpload__c();
        objDoc.Implementation_Period__c = objIP.Id;
        objDoc.FeedItem_Id__c = objFI.id;
        objDoc.Process_Area__c = 'Concept Note';
        objDoc.Description__c = 'test';
        objDoc.Language__c = 'English';
        objDoc.Type__c = 'Concept note narrative';
        //objDoc.Language_Code__c = 'EN';
        insert objDoc; 
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GM_DocumentUpload objGI = new GM_DocumentUpload(sc);
        objGI.strImplementationPeriodId = objIP.Id;
        objGI.CountUpload = 1;
        objGI.objFeedItem.ContentData = blob.valueof('TestDocument.txt');
        
        objGI.objFeedItem.ContentFileName = 'TestDocument.txt';
        objGI.objDocumentUpload.Implementation_Period__c = objIP.Id;
        objGI.objDocumentUpload.FeedItem_Id__c = objFI.id;
        objGI.objDocumentUpload.Process_Area__c = 'Concept Note';
        objGI.objDocumentUpload.Language__c = 'English';
        objGI.objDocumentUpload.Type__c = 'Concept note narrative';
        //objGI.lstDocumentUpload.add(objDoc);
        System.debug('@@@@@@@@lstDocumentUpload'+objGI.lstDocumentUpload);
        GM_DocumentUpload.WrapperDocumentUpdload wrp=new GM_DocumentUpload.WrapperDocumentUpdload();
        wrp.objDocumentUpload  = objDoc;
        wrp.objFeedItem = objFI;
        objGI.lstWrpDocumentUpload.add(wrp);
        objGI.objFeedItem.body = 'Test';        
        PageReference pgrefnew = new PageReference('');
        pgrefnew = objGI.uploadFile();
        objGI.DeleteIndex = 0;
        objGI.DeleteFile();
        
        ObjGI.downloadtemplate();
    }
    Public static testMethod void TestGM_DocumentUpload1(){
    
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
        objCN.Program_Split__c = objPrgmSplit.Id;
        insert objCN;
        
        Implementation_Period__c objIP = new Implementation_Period__c();
        objIP.Principal_Recipient__c = objAcc.Id;
        objIP.Concept_Note__c = objCN.id;
        insert objIP;
        
        Module__c objModule = new Module__c();
        objmodule.Name = 'Test';
        objModule.Component__c = 'Malaria';
        objModule.Implementation_Period__c = objIP.Id;
        insert objModule;
        
      
        Page__c objPage = new Page__c();
        objPage.Implementation_Period__c = objIP.Id;
        insert objPage;   
          
        FeedItem objFI = new FeedItem();
        objFI.parentId = objCN.Id;
        objFI.body = 'test';
        objFI.Type  = 'ContentPost';
        objFI.ContentFileName = 'TestDocument.txt';
        objFI.ContentData =  blob.valueof('TestDocument.txt');
        objFI.ContentDescription = 'Detailed Budget XLS'; 
        //objFI.ContentSize = 1;
        insert objFI;
       
        DocumentUpload__c objDoc=new DocumentUpload__c();
        objDoc.Implementation_Period__c = objIP.Id;
        objDoc.FeedItem_Id__c = objFI.id;
        objDoc.Process_Area__c = 'Concept Note';
        objDoc.Description__c = 'test';
        objDoc.Language__c = 'English';
        objDoc.Type__c = 'Concept note narrative';
        //objDoc.Language_Code__c = 'EN';
        insert objDoc; 
        
        Profile_Access_Setting__c checkProfile = TestClassHelper.createProfileSetting();
        checkProfile.Page_Name__c ='GM_DocumentUpload';
        checkProfile.Salesforce_Item__c = 'External Profile';
          
        insert checkProfile;
        
        
        Apexpages.currentpage().getparameters().put('id',objPage.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPage);
        GM_DocumentUpload objGI = new GM_DocumentUpload(sc);
        objGI.strImplementationPeriodId = objIP.Id;
        objGI.CountUpload = 1;
        objGI.sortItem = 4;
        objGI.objFeedItem.ContentData = blob.valueof('TestDocument.txt');
        
        objGI.objFeedItem.ContentFileName = 'TestDocument.txt';
        objGI.objDocumentUpload.Implementation_Period__c = objIP.Id;
        objGI.objDocumentUpload.FeedItem_Id__c = objFI.id;
        objGI.objDocumentUpload.Process_Area__c = 'Concept Note';
        objGI.objDocumentUpload.Language__c = 'English';
        objGI.objDocumentUpload.Type__c = 'Concept note narrative';
        //objGI.lstDocumentUpload.add(objDoc);
        System.debug('@@@@@@@@lstDocumentUpload'+objGI.lstDocumentUpload);
        GM_DocumentUpload.WrapperDocumentUpdload wrp=new GM_DocumentUpload.WrapperDocumentUpdload();
        wrp.objDocumentUpload  = objDoc;
        wrp.objFeedItem = objFI;
        objGI.lstWrpDocumentUpload.add(wrp);
        objGI.objFeedItem.body = 'Test';        
        PageReference pgrefnew = new PageReference('');
        pgrefnew = objGI.uploadFile();
        objGI.DeleteIndex = 0;
        objGI.DeleteFile();
        objGI.checkProfile();
        objGI.sortByItem();
        
        ObjGI.downloadtemplate();
    }
}