Public Class GM_DocumentUpload{
    Public List<Page__c> lstPages {get;set;}
    Public String strPageId {get;set;}
    Public List<Module__c> lstmodules {get;set;}
    Public String strImplementationPeriodId {get;set;}
    Public FeedItem objFeedItem {get;set;}
    Public String FeedBody {get;set;}
    Public boolean blnExpandSection {get;set;}
    Public List<WrapperDocumentUpdload> lstWrpDocumentUpload {get; set;}
    Public DocumentUpload__c objDocumentUpload {get; set;}
    Public List<DocumentUpload__c> lstDocumentUpload {get; set;}
    Public Set<Id> setFeedItemId {get; set;}
    Public Map<Id,FeedItem> mapIdFeedItem {get; set;}
    Public String SelectedTemplate {get;set;}
    Public String strUserLanguage {get;set;}
    Public boolean fileoverload {get;set;}
    public Integer fileSize {get;set;} 
    Public String strGuidanceId {get;set;}
    public String strLanguage {get;set;} 
    public String strWarning {get;set;}
    public Document doc {get;set;}
    Public Integer sortItem {get;set;}
    Public boolean togglebit {get;set;}
    
    Public Map<Integer,String> mapForSort {get;set;}
    Public Map<Integer,String> mapForSortFeed {get;set;}
    Public List<FeedItem> lstFeedItem {get;set;}
    Public Map<Id,DocumentUpload__c> mapIdDocumentUpload {get;set;}
    
    //TCS 22/08/2-14: Added for Profile Access
    Public Boolean blnExternalPro  {get;set;}
    Public Boolean blnUploadDoc {get;set;}
    Public Boolean blnDeleteDoc {get;set;}
    Public Boolean blnDownloadAllDocuments {get;set;}
    Public Boolean blnIndividualDownloadLink {get;set;}
    Public Boolean blnTGFInternalChckbox {get;set;}
    Public Boolean blnExternalUserDocument {get;set;}
    
    public GM_DocumentUpload(ApexPages.StandardController controller) {
        strPageId = Apexpages.currentpage().getparameters().get('id');
        strUserLanguage = System.UserInfo.getLanguage();
        togglebit = true;
        mapIdDocumentUpload = new map<Id,DocumentUpload__c> ();
        doc = new Document();        
        if(strUserLanguage == '')
        strUserLanguage = 'en_US';
        fileoverload = false;
        fileSize = 0;
        if(String.isBlank(strPageId) == false){
            List<Page__c> lstPageMain = [Select Implementation_Period__c From Page__c Where Id =: strPageId and Implementation_Period__c != null];
            if(lstPageMain.size() > 0){
                strImplementationPeriodId = lstPageMain[0].Implementation_Period__c;
            }
            if(String.isBlank(strImplementationPeriodId) == false){
                lstWrpDocumentUpload = new List<WrapperDocumentUpdload>();
                lstPages = new List<Page__c>();   
                lstPages = [Select Id,Name,URL_Prefix__c,Order__c,Modular__c From Page__c Where Implementation_Period__c =: strImplementationPeriodId Order by Order__c];
                lstModules = new List<Module__c>();   
                lstModules = [Select Id,Name,Implementation_Period__c From Module__c Where Implementation_Period__c =: strImplementationPeriodID Order by Name];  
                objFeedItem = new FeedItem(ParentId = strImplementationPeriodId);
                
                objDocumentUpload = new DocumentUpload__c(Implementation_Period__c = strImplementationPeriodId,Process_Area__c = 'Grant-making');
                lstDocumentUpload = new List<DocumentUpload__c>();
                lstDocumentUpload = [Select Id,Description__c,Implementation_Period__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,GMType__c,Type__c,Name, TGF_Internal__c from DocumentUpload__c where Implementation_Period__c =: strImplementationPeriodId];
                setFeedItemId = new Set<Id>();
                System.debug('!!!!lstDocumentUpload ='+lstDocumentUpload +strImplementationPeriodId);
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
                        DateTime date1 = objWrpDocUpload.objFeedItem.CreatedDate;
                        objWrpDocUpload.strCreatedDate = date1.format('dd MMMM YYYY H:MM a');
                        lstWrpDocumentUpload.add(objWrpDocUpload);
                    }
                }
                
                
            }
            FeedBody = null;
            
        }
        strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
            
        List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = :label.GM_Manage_Documents];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
       checkProfile();
    }
    Public Integer DeleteIndex {get;set;}
    Public Integer CountUpload {get;set;}
    
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
    //upload a feed item and save tho the documentUpload object.
    Public PageReference uploadFile(){
        System.debug('In Upload  objDocumentUpload ' +objDocumentUpload +'Feed = '+ objFeedItem  );
        
        if(objFeedItem != null){
            if(CountUpload != null){
                if(CountUpload == 1) objFeedItem.ContentDescription = 'Detailed Budget XLS';
                if(CountUpload == 2) objFeedItem.ContentDescription = 'PSM Plan XLS';
                if(CountUpload == 3) objFeedItem.ContentDescription = 'Other Document';  
            }
            system.debug('@#@#@#@#'+objFeedItem);
            system.debug('objFeedItem.ContentSize:' +objFeedItem.ContentSize);            
            if(objFeedItem.ContentSize == Null){                                
                strWarning = 'This file exceeds the maximum size limit of 10MB.';
                return null; //pgrefnew;  
            }
            if(objFeedItem.ContentSize == 0){                               
                strWarning = 'File to be uploaded cannot be empty.';
                return null; //pgrefnew;  
            }   
            //system.debug();
            //objFeedItem.body = FeedBody;
            try {
                insert objFeedItem;
                if(objDocumentUpload != null) {
                    objDocumentUpload.FeedItem_Id__c = objFeedItem.ID;
                    insert objDocumentUpload;                          
                    //send email
                    /*List<Contact> lstContact = [Select Id from Contact where Id = '003g000000Bheha' ];
                    System.debug('!!!!!!!Contact = lstContact ' +lstContact );
                    if(lstContact.size() > 0) { 
                        if(objFeedItem.ContentDescription != 'Other Document'){
                            List<EmailTemplate> lstEmailTemplate = [Select ID,Subject,Body From EmailTemplate 
                                                            Where DeveloperName = 'FeedItem_alertvf'];
                            if(lstEmailTemplate.size() > 0){
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                //set parameters of the email                
                                mail.setTemplateId(lstEmailTemplate[0].Id);
                                mail.setTargetObjectId(lstContact[0].id); 
                                 
                                //send the email;
                                if(test.isrunningtest() == false)
                                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            }
                        }
                    }*/
                    
                    objDocumentUpload = new DocumentUpload__c(Implementation_Period__c = strImplementationPeriodId,Process_Area__c = 'Grant-making');
                    objFeedItem = new FeedItem(ParentId = strImplementationPeriodId);
                }
                FeedBody = null;
            }
            catch (Exception ex) {
                System.debug(ex); 
            }
           
           
        }
        PageReference pgrefnew = new PageReference('/apex/GM_DocumentUpload?id='+strPageId);
        pgrefnew.setRedirect(true);
        return pgrefnew;
    }
    //Wrapper class for insert update both the object and display combined List.
    Public class WrapperDocumentUpdload { 
        Public DocumentUpload__c objDocumentUpload {get; set;} 
        Public FeedItem objFeedItem {get; set;} 
        Public String strCreatedDate {get; set;}
        public WrapperDocumentUpdload() {
            objDocumentUpload = new DocumentUpload__c();
            objFeedItem = new FeedItem();
        }
    }
    
    Public PageReference downloadTemplate(){
        system.debug('***SelectedTemplate:'+selectedtemplate);
        system.debug('StrUserLang ' +strUserLanguage);
        if(SelectedTemplate == Null)
        SelectedTemplate = Label.Grant_Making_narrative_Template_english;
        return new PageReference(selectedtemplate);
    }        
    
    //TCS 22/08/2014: Added Below function for Profile level access
   public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         List<Profile_Access_Setting__c> checkpage = new List<Profile_Access_Setting__c>();
     /*    List<String> PermissionSets = new List<String>();
     List<PermissionSetAssignment> standalonePermSets = [ SELECT PermissionSet.Id, PermissionSet.Name, PermissionSet.Label FROM PermissionSetAssignment WHERE Assignee.Username =: UserInfo.getUserName()];
      if(standalonePermSets.size()>0){
        for(PermissionSetAssignment PermSets : standalonePermSets){
            PermissionSets.add(PermSets.PermissionSet.Label);
            system.debug('Name '+PermSets.PermissionSet.Label);
            //checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_DocumentUpload' and Profile_Name__c =: PermSets.PermissionSet.Label];
        }}/*else{
            PermissionSets.add(profileName);
        }
        checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_DocumentUpload' and (Profile_Name__c =: profileName OR Permission_Sets__c IN: PermissionSets)];*/
       checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GM_DocumentUpload' and Profile_Name__c =: profileName];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile') blnExternalPro = true;
        if(check.Salesforce_Item__c == 'Upload Document')blnUploadDoc = true;
        if(check.Salesforce_Item__c == 'Delete Document')blnDeleteDoc = true;
        if(check.Salesforce_Item__c == 'Download All Document')blnDownloadAllDocuments = true;
        if(check.Salesforce_Item__c == 'Individual Download Link')blnIndividualDownloadLink = true;
        if(check.Salesforce_Item__c == 'TGF Internal Checkbox')blnTGFInternalChckbox = true;
        if(check.Salesforce_Item__c == 'External User Documents')blnExternalUserDocument = true;
       }
    }
    
    //TCS 24/09/2014 : US ID 2483
    public void sortByItem() { /*Sorts the list of uploaded documents based on column header clicked*/  
        mapForSort = new Map <Integer,String> ();
        mapForSortFeed = new Map <Integer,String> ();
        mapForSortFeed.put(1,'ContentFileName');
        mapForSort.put(2,'TGF_Internal__c');
        mapForSortFeed.put(3,'body');
        mapForSort.put(4,'Type__c');
        mapForSort.put(5,'Language__c');
        mapForSortFeed.put(6,'CreatedDate');
        mapForSort.put(7,'CreatedBy.Name');                
        
        String sortString = '';
        String query = 'Select Id,CreatedBy.Name,Description__c,Concept_Note__c,FeedItem_Id__c,Language__c,Language_Code__c,Process_Area__c,Type__c,Section__c,Name,GMType__c, TGF_Internal__c from DocumentUpload__c where Implementation_Period__c =: strImplementationPeriodId order by';
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
                        DateTime date1 = objWrpDocUpload.objFeedItem.CreatedDate;
                        objWrpDocUpload.strCreatedDate = date1.format('dd MMMM YYYY H:MM a');
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
                        DateTime date1 = objWrpDocUpload.objFeedItem.CreatedDate;
                        objWrpDocUpload.strCreatedDate = date1.format('dd MMMM YYYY H:MM a');
                        lstWrpDocumentUpload.add(objWrpDocUpload);
        }
        }/*end of ELSE*/                             
    }/*end of function*/
}