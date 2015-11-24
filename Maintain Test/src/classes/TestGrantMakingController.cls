@isTest
Public Class TestGrantMakingController{
    Public Static testMethod void TestGrantMakingController(){
        Organisations__c objOrg = new Organisations__c();
        objOrg.name = 'testOrg';
        insert objOrg;
    
        Concept_Note__c objNote = new Concept_Note__c();
        objNote.name = 'test concept note';
        objNote.ccm__c = objOrg.Id;
        objNote.Status__c = 'Submitted';
        insert objNote;
        
        
        DocumentUploadSections__c obj =new DocumentUploadSections__c();
        obj.name='1';
        obj.TRP_Review__c=true;
        insert obj;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.description='Outcome of GAC Review'.toUpperCase();
        attach.parentId=objNote.id;
        insert attach;
        
        obj =new DocumentUploadSections__c();
        obj.name='2';
        obj.GAC_Review__c=true;
        insert obj;
        
        attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        attach.description='TRP review form'.toUpperCase();
        attach.body=bodyBlob;
        attach.parentId=objNote.id;
        insert attach;
        
        obj =new DocumentUploadSections__c();
        obj.name='1';
        obj.Grant_Making__c=true;
        obj.Language__c='English';
        obj.IsTemplate__c =false;
        obj.sub_Section__c = 'Grant Making Work Plan';
        insert obj;
        
        obj =new DocumentUploadSections__c();
        obj.name='1';
        obj.Grant_Making__c=true;
        obj.Language__c='Spanish';
        obj.IsTemplate__c =false;
        obj.sub_Section__c = 'Grant Making Work Plan';
        insert obj;
        
        GrantMakingController objClass = new GrantMakingController();
        objClass.getConceptNotes();
        objClass.getImplementers();
        objClass.selectedNote = objNote.Id;
        objClass.selectNote();
        objClass.getGrantMakingGuideline();
        objClass.getSections();
        objClass.selectedNote = objNote.Id;
        objClass.getGACreview();
        objClass.getTRPreview();
        objClass.selectImplementers();
        
    }
}