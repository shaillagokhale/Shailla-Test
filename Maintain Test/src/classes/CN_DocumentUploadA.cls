Public Class CN_DocumentUploadA{
    Public List<Page__c> lstPage {get;set;}
    Public String strConcept_NoteId {get;set;}
    Public String strGuidanceId {get;set;}
    Public List<Module__c> lstmodules {get;set;}
    Public FeedItem objFeedItem {get;set;}
    Public String FeedBody {get;set;}
    Public boolean blnExpandSection {get;set;}
    Public Integer DeleteIndex {get;set;}
    Public List<WrapperDocumentUpdload> lstWrpDocumentUpload {get; set;}
    Public DocumentUpload__c objDocumentUpload {get; set;}
    Public List<DocumentUpload__c> lstDocumentUpload {get; set;}
    Public Set<Id> setFeedItemId {get; set;}
    Public Map<Id,FeedItem> mapIdFeedItem {get; set;}
    Public Map<Integer,String> mapForSort {get;set;}
    Public Map<Integer,String> mapForOrder {get;set;}
    Public Map<Integer,String> mapForSortFeed {get;set;}
    Public List<SelectOption> DocTemplates {get;set;}
    Public String SelectedTemplate {get;set;}
    Public Boolean blnReadOnly {get;set;}
    Public Boolean blnDelOnly {get;set;} // Introduced to control Document Delete Functionality
    Public String strUserLanguage {get;set;}
    Public Integer sortItem {get;set;}
    Public boolean togglebit {get;set;}
    Public List<FeedItem> lstFeedItem {get;set;}
    Public Map<Id,DocumentUpload__c> mapIdDocumentUpload {get;set;}
    public Document doc {get; set;} ///used to download all files
    Public String url {get;set;}
    public String strWarning {get;set;}
     /* For Custom Setting profile Implementation*/
    Public Boolean blnExternalPro {get;set;}
    Public Boolean blnUploadDocument {get;set;}
    Public Boolean blnDeleteDocument {get;set;}
    Public Boolean blnIndividualDownloadLink {get;set;}
    Public Boolean blnDownloadAllDocuments {get;set;}
    /* End  */
    
    public CN_DocumentUploadA(){}
    public CN_DocumentUploadA(ApexPages.StandardController controller) {
        strUserLanguage = System.UserInfo.getLanguage();
        //blnReadOnly = CheckProfile.checkProfile();
        strConcept_NoteId = Apexpages.currentpage().getparameters().get('id');                
        togglebit = true;
        mapIdDocumentUpload = new map<Id,DocumentUpload__c> ();
        DocTemplates = new List<SelectOption>();
        DocTemplates.add(new SelectOption('','--Select Template--'));
        DocTemplates.add(new SelectOption('Link','Concept Note Narrative'));
        DocTemplates.add(new SelectOption('Link','CCM Endorsement'));
        DocTemplates.add(new SelectOption('Link','Detailed Budget'));
        DocTemplates.add(new SelectOption('Link','PSM Products and Costs'));
        DocTemplates.add(new SelectOption('Link','Willingness to Pay'));
        DocTemplates.add(new SelectOption('Link','List of Abbreviations and Annexes'));
        
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = 'Manage Documents'];
            if(!lstGuidance.isEmpty()) {
              strGuidanceId = lstGuidance[0].Id; }
        lstWrpDocumentUpload = new List<WrapperDocumentUpdload>();
        if(String.isBlank(strConcept_NoteId) == false){
            if(String.isBlank(strConcept_NoteId) == false){
                
                /*
                List<Concept_Note__c> lstCN = [Select Name, Id, Status__c from Concept_Note__c where Id = :strConcept_NoteId];
                if(!lstCN.isEmpty()){
                    if(lstCN[0].Status__c == 'Submitted to the Global Fund' && CheckProfile.chkPfleCnDocForSubmitted()==true){
                        blnReadOnly = false; 
                        blnDelOnly = false;
                    } 
                    // Introduced to control Document Delete Functionality
                    else if(lstCN[0].Status__c == 'Submitted to the Global Fund' && CheckProfile.chkPfleCnDocForSubmitted()==false){
                        blnReadOnly = true; 
                        blnDelOnly = false;     
                    }else if(lstCN[0].Status__c == 'Not yet submitted' && CheckProfile.chkPfleCnDocForNotSubmitted()==true){
                        blnReadOnly = false;
                        blnDelOnly = true;
                    }
                    // Introduced to control Document Delete Functionality
                    else if(lstCN[0].Status__c == 'Not yet submitted' && CheckProfile.chkPfleCnDocForNotSubmitted()==false){
                        blnReadOnly = true;
                        blnDelOnly = true;
                    }
                    // For all the other status
                    else {
                        blnReadOnly = true;
                        blnDelOnly = false;
                    }
                  } */
                /* For Custom Setting profile Implementation*/
                
                   checkProfile();
                 
                /* End */  
                  
                  
                System.debug('in Constructor' );
                lstPage = new List<Page__c>();   
                lstPage = [Select Id,Name, URL_Prefix__c,Order__c,Modular__c from Page__c where Concept_Note__c=:strConcept_NoteId Order by Order__c];
                lstModules = new List<Module__c>();   
                lstModules = [Select Id,Name From Module__c  where Concept_Note__c =: strConcept_NoteId Order by Name];
                objFeedItem = new FeedItem(ParentId = strConcept_NoteId, Type='ContentPost');
                
                objDocumentUpload = new DocumentUpload__c(Concept_Note__c = strConcept_NoteId,Process_Area__c = 'Concept Note');
                lstDocumentUpload = new List<DocumentUpload__c>();
                lstDocumentUpload = [Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name, TGF_Internal__c from DocumentUpload__c where Concept_Note__c =: strConcept_NoteId];
                setFeedItemId = new Set<Id>();
                System.debug('!!!!lstDocumentUpload ='+lstDocumentUpload +strConcept_NoteId);
                if(lstDocumentUpload.size() > 0) {
                    for(DocumentUpload__c objDocument : lstDocumentUpload) {
                        setFeedItemId.add(objDocument.FeedItem_Id__c);
                        mapIdDocumentUpload.put(objDocument.FeedItem_Id__c,objDocument);
                    }
                    mapIdFeedItem = new Map<Id,FeedItem> ([Select Id,ContentDescription,ContentFileName,body,RelatedRecordId,CreatedDate,CreatedBy.Name From FeedItem Where Id In: setFeedItemId]);
                    for(DocumentUpload__c objDocument : lstDocumentUpload) {
                        WrapperDocumentUpdload objWrpDocUpload = new WrapperDocumentUpdload();   
                        objWrpDocUpload.objDocumentUpload = objDocument;
                        objWrpDocUpload.objFeedItem  = mapIdFeedItem.get(objDocument.FeedItem_Id__c);
                        lstWrpDocumentUpload.add(objWrpDocUpload);
                    }
                }
            }
            FeedBody = null;
        }
    }
            
    Public void DeleteFile(){        
        if(DeleteIndex != null){
            WrapperDocumentUpdload objWrpDocUpload = lstWrpDocumentUpload[DeleteIndex];
            if(objWrpDocUpload != null){
                if (objWrpDocUpload.objDocumentUpload != null) {
                    List<DocumentUpload__c> lstDocumentUploadToDelete = [Select Id From DocumentUpload__c Where Id =: objWrpDocUpload.objDocumentUpload.Id];
                    if(lstDocumentUploadToDelete != null && lstDocumentUploadToDelete.size() > 0) {
                        delete lstDocumentUploadToDelete;
                    }
                }
                
                if(objWrpDocUpload.objFeedItem != null) {
                    List<FeedItem> lstFeedItemToDelete = [Select Id From FeedItem Where Id =: objWrpDocUpload.objFeedItem.Id];
                    if(lstFeedItemToDelete.size() > 0 && lstFeedItemToDelete != null){
                        Delete lstFeedItemToDelete;
                    }
                }
                
                lstWrpDocumentUpload.remove(DeleteIndex);
            }
        }
    } 
    Public PageReference downloadTemplate(){
        return new PageReference(selectedtemplate);
    }
    Public PageReference uploadFile(){
        if(objFeedItem != null){
            if(objFeedItem.ContentSize == Null){                                
                strWarning = 'This file exceeds the maximum size limit of 10MB.';
                return null; //pgrefnew;  
            }
            if(objFeedItem.ContentSize == 0){                               
                strWarning = 'File to be uploaded cannot be empty.';
                return null; //pgrefnew;  
            }
            objFeedItem.ContentDescription = 'Other Document'; 
            insert objFeedItem;
            if(objDocumentUpload != null) {
                objDocumentUpload.FeedItem_Id__c = objFeedItem.ID;
                insert objDocumentUpload;
                objDocumentUpload = new DocumentUpload__c(Concept_Note__c = strConcept_NoteId,Process_Area__c = 'Concept Note');
                objFeedItem = new FeedItem(ParentId = strConcept_NoteId, Type='ContentPost');                 
            }
            FeedBody = null;
        }
        PageReference pgrefnew = new PageReference('/apex/CN_DocumentUpload?id='+strConcept_NoteId);
        pgrefnew.setRedirect(true);
        return pgrefnew;
    }
    //Wrapper class for insert update both the object and display combined List.
    Public class WrapperDocumentUpdload { 
        Public DocumentUpload__c objDocumentUpload {get; set;} 
        Public FeedItem objFeedItem {get; set;} 
        public WrapperDocumentUpdload() {
            objDocumentUpload = new DocumentUpload__c();
            objFeedItem = new FeedItem();
        }
    }

    public void sortByItem() { /*Sorts the list of uploaded documents based on column header clicked*/  
        mapForSort = new Map <Integer,String> ();
        mapForSortFeed = new Map <Integer,String> ();
        mapForSortFeed.put(1,'ContentFileName');
        mapForSort.put(2,'TGF_Internal__c');
        mapForSortFeed.put(3,'body');
        mapForSort.put(4,'Type__c');
        mapForSort.put(5,'Language__c');
        mapForSortFeed.put(6,'CreatedDate');
        mapForSortFeed.put(7,'CreatedBy.Name');                
        
        String sortString = '';
        String query = 'Select Id,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name, TGF_Internal__c from DocumentUpload__c where Concept_Note__c =: strConcept_NoteId order by';
        String queryFeed = 'Select Id,ContentDescription,ContentFileName,body,RelatedRecordId,CreatedDate,CreatedBy.Name From FeedItem Where Id In: setFeedItemId order by';
        sortString = mapForSort.get(sortItem);
        if(sortString == NULL) {
            sortString  = mapForSortFeed.get(sortItem);
            if(togglebit) {
                queryFeed += ' ' + sortString + ' asc';
                togglebit = false; 
            }
            else {
                queryFeed += ' ' + sortString + ' desc';
                togglebit = true; 
            }
            lstFeedItem = new List<FeedItem>();
            system.debug('sortItem: ' +sortItem+ 'sortString: '+sortString+'QueryFeed: '+queryFeed);
            lstFeedItem = Database.Query(queryFeed);
            lstWrpDocumentUpload.clear();
            for(FeedItem objFeed : lstFeedItem) {
                        WrapperDocumentUpdload objWrpDocUpload = new WrapperDocumentUpdload();   
                        objWrpDocUpload.objDocumentUpload = mapIdDocumentUpload.get(objFeed.Id);
                        objWrpDocUpload.objFeedItem  = objFeed;
                        lstWrpDocumentUpload.add(objWrpDocUpload);
            }           
        }/*end of IF*/
        else {      
        if(togglebit) {
        query += ' ' + sortString + ' asc';
        togglebit = false; }
        else {
        query += ' ' + sortString + ' desc';
        togglebit = true; }
        system.debug('sortItem: ' +sortItem+ 'sortString: '+sortString+'Query: '+query);        
        lstDocumentUpload = Database.Query(query);              
        lstWrpDocumentUpload.clear();
        for(DocumentUpload__c objDocument : lstDocumentUpload) {
                        WrapperDocumentUpdload objWrpDocUpload = new WrapperDocumentUpdload();   
                        objWrpDocUpload.objDocumentUpload = objDocument;
                        objWrpDocUpload.objFeedItem  = mapIdFeedItem.get(objDocument.FeedItem_Id__c);
                        lstWrpDocumentUpload.add(objWrpDocUpload);
        }
        }/*end of ELSE*/                             
    }/*end of function*/
    
     Public PageReference downloadall(){
        
        strConcept_NoteId = Apexpages.currentpage().getparameters().get('id');  
        list<FeedItem> lstFeeds = [Select Id, Body,RelatedRecordId, ContentFileName, ContentData from FeedItem Where parentId = :strConcept_NoteId ];        
        system.debug('List of Feeds '+lstFeeds);
        if(lstFeeds.size() > 0) {
        doc=new document();
        doc.Name = 'downloadall.zip';
        /*doc.ContentType = 'application/zip';        
        doc.FolderId = UserInfo.getUserId();
        doc.Body = lstFeeds[0].ContentData;
        doc.Name = lstFeeds[0].ContentFileName;
        insert doc;*/
        system.debug('document Details '+doc);
        doc.Name = lstFeeds[0].ContentFileName;
        doc.FolderId = UserInfo.getUserId();
        doc.Body = lstFeeds[0].ContentData;
        insert doc;}
        //return null;
        
        PageReference pageRef = new PageReference('/servlet/servlet.FileDownload?file='+doc.id);
        pageRef.setRedirect(true);
        //PageReference pageRef = new PageReference('/' + doc.Id);
        
        return pageRef;
    }
    
    /* For Custom Setting profile Implementation*/
    public void checkProfile(){
        blnExternalPro =false;
        blnUploadDocument =false;
        blnDeleteDocument =false;
        blnIndividualDownloadLink =false;
        blnDownloadAllDocuments =false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting_CN__c> checkpage = new List<Profile_Access_Setting_CN__c>();
        List<Concept_Note__c> lstCN = [Select Name, Id, Status__c from Concept_Note__c where Id = :strConcept_NoteId];
        List<String> PermissionSets = new List<String>();
        List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
        if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            
        }}
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting_CN__c where Page_Name__c ='CN_DocumentUpload' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets) ];
        system.debug('profile list'+ checkpage);
        
        for (Profile_Access_Setting_CN__c check : checkpage){
            if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
            if(check.Salesforce_Item__c == 'Upload Document' && check.Status__c == lstCN[0].Status__c) blnUploadDocument = true;
            if(check.Salesforce_Item__c == 'Delete Document' && check.Status__c == lstCN[0].Status__c) blnDeleteDocument = true;
            if(check.Salesforce_Item__c == 'Individual Download Link' && check.Status__c == lstCN[0].Status__c) blnIndividualDownloadLink = true;
            if(check.Salesforce_Item__c == 'Download All Documents' && check.Status__c == lstCN[0].Status__c) blnDownloadAllDocuments = true;
            
        }
    }
    /* End */
}