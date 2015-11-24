@isTest
Public Class Testfeeditemtrigger  
{
    Public Static testMethod void Testfeeditemtrigger ()
    {
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        objAcc.Short_Name__c = 'MOH';
        
        insert objAcc;
        
        Template__c objTemplate = new Template__c(Name = 'Test Template');
        insert objTemplate;
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.Component__c = 'Malaria';
        objCN.Language__c = 'ENGLISH';
        objCN.CCM_new__c = objAcc.Id;
        objCN.Number_of_Years__c = '3';
        objCN.Page_Template__c = objTemplate.Id;
        insert objCN;
        
        FeedItem objFI = new FeedItem();
        objFI.parentId = objCN.Id;
        objFI.body = 'test';
        objFI.Type  = 'ContentPost';
        objFI.ContentFileName = 'TestDocument.txt';
        objFI.ContentData =  blob.valueof('TestDocument.txt');
     
        insert objFI;
         DocumentUpload__c objDoc=new DocumentUpload__c();
        objDoc.Concept_Note__c = objCN.Id;
        objDoc.FeedItem_Id__c = objFI.id;
        objDoc.Process_Area__c = 'Concept Note';
        objDoc.Description__c = 'test';
        objDoc.Language__c = 'English';
        objDoc.Type__c = 'Concept note narrative';
        //objDoc.Language_Code__c = 'EN';
        insert objDoc; 
        
        delete objFI;
    }
}