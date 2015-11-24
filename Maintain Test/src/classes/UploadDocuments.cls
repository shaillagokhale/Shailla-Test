with sharing public class UploadDocuments {
    Public String selectedNote{get;set;}
    Public String selectedNoteName{get;set;}
    Public String strFolderId{get;set;}
    String NONE = '--None--';
    Map<ID, Concept_Note__c> mapConceptNote = new Map<ID, Concept_Note__c>();
    Public List<String> lstSections{get;set;}
    Public UploadDocuments(){
        selectedNote = NONE;
        List<Folder> lstFolder = [SELECT AccessType, CreatedById, CreatedDate, Id, 
                DeveloperName, LastModifiedById, LastModifiedDate, 
                Name, NamespacePrefix, IsReadonly, SystemModstamp, 
                Type FROM Folder
                Where DeveloperName='TRP'];
        if(lstFolder <> null && lstFolder.size()>0){
            strFolderId = lstFolder[0].Id;
        }
        //getSection();
    }
    
    Public List<String> getSections(){
        lstSections = new List<String>();
        //List<DocumentUploadSections__c> lstSec = DocumentUploadSections__c.getOrgDefaults();
        List<DocumentUploadSections__c> lstSec = [Select name, Section__c 
        from DocumentUploadSections__c
        Order by Section_no__c,Sub_Section__c, Section_Order__c];
        if(lstSec <> null && lstSec.size()>0){
            for(DocumentUploadSections__c doc:lstSec){
                lstSections.add(doc.Section__c);        
            }    
        }
        return lstSections;
    }
    
    Public List<SelectOption> getConceptNotes(){
        List<SelectOption> options = new List<SelectOption>();
        List<Concept_Note__c> lstNotes = [Select id, name from Concept_Note__c Limit 10000];
        options.add(new SelectOption(NONE, NONE));
        selectedNote = NONE;
        if(lstNotes <> null && lstNotes.size()>0){
            selectedNote = lstNotes[0].Id;
            for(Concept_Note__c note:lstNotes){
                options.add(new SelectOption(note.Id, note.Name));
                mapConceptNote.put(note.Id, note);
            }
        }
        return options;
    }
    Public void selectNote(){
        System.debug('#### selected note : ' + selectedNote);
        if(selectedNote <> NONE){
            if(mapConceptNote <> null && mapConceptNote.size()>0 && mapConceptNote.containsKey(selectedNote)){
                selectedNoteName = mapConceptNote.get(selectedNote).name;
            }
        }
    }
}