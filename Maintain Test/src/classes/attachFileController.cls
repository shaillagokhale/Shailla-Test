public class attachFileController {
   
   /* Public String conceptNoteId{get;set;}
    Public String strSection{get;set;}
    Public String strSubsection{get;set;}
    Public Attachment objAttachment{get;set;}
    //Public List<Attachment> lstAttachment{get;set;}
    
    Public Document objDocument{get;set;}
    List<Document> lstDocument;
    Public Boolean isReadOnly{get;set;}
    //Public String currentURL{get;set;}
    Public String strType{get;set;}
    Public String strFolderId{get;set;}
    Public Decimal subSectionNo{get;set;}
    Public String strAllAttachmentsFor{get;set;}
    Static String strDOCUMENT = 'DOCUMENT';
    Static String strATTACHMENT = 'ATTACHMENT';
    Public boolean allowUploadDocument{get;set;}
    Public boolean blnAllowMultipleAttachments{get;set;}
    Public boolean blnGrantMaking{get;set;}
    Public Class Templates{
        Public String Section{get;set;}
        //Public List<Document> documents{get;set;}
        Public boolean selected{get;set;}
        Public Document document{get;set;}
        Public DocumentUploadSections__c settings{get;set;}
        Public String note{get;set;}
        Public String outputLink{get;set;}
        Public Boolean allowedProfile{get;set;}
        Public Templates(){}
        Public Templates(String Section, DocumentUploadSections__c settings, String note, Boolean allowedProfile){
            this.Section = Section;
            this.settings = settings;
            this.note = note;
            this.selected = false;
            this.allowedProfile = allowedProfile;
        }
    }
    string setNote(string strNote, String docId, boolean allowedProfile){
        strNote = NVL(strNote);
        System.debug('@@@@ Note: ' + strNote);
        if(strNote.indexOf('{') >= 0){
            String linkText = strNote.subString(strNote.indexOf('{') + 1, strNote.indexOf('}'));
            System.debug('@@@@ Link Text: ' + linkText);
            String link = '';
            if(NVL(docId) <> '' && allowedProfile == true){
                link = '<strong><a href="/servlet/servlet.FileDownload?file=' + docId + '" target="_blank">' + linkText + '</a></strong>';
            }
            else{
                link = '<strong>' + linkText + '</strong>';
            }
            System.debug('@@@@ Link: ' + link);
            strNote = strNote.replace('{' + linkText + '}', link);
            
        }
        System.debug('@@@@ Final Note: ' + strNote);
        if(strNote.lastIndexOf('{') >= 0 && strNote.LastIndexOf('}') >= 0){
            System.debug('@@@@ one more link to replace...');
            return setNote(strNote, docId, allowedProfile);
        }
        else{
            System.debug('@@@@ no more link to replace...');
            return strNote;
        }
    }
    List<Templates> lstTemplates = new List<Templates>();
    String getLanguage(){
        String language = '';
        String locale = UserInfo.getLocale();
        if(locale == 'es' || locale == 'es_AR' || locale == 'es_BO' || locale == 'es_CL' || locale == 'es_CO' || locale == 'es_CR' || locale == 'es_DO' || locale == 'es_EC' || locale == 'es_ES' || locale == 'es_GT' || locale == 'es_HN' || locale == 'es_MX' || locale == 'es_PA' || locale == 'es_PE' || locale == 'es_PR' || locale == 'es_PY' || locale == 'es_SVUS' || locale == 'es_UY' || locale == 'es_VE'){
            language = 'Spanish';
        }
        else if(locale == 'en_AU' || locale == 'en_BB' || locale == 'en_BM' || locale == 'en_CA' || locale == 'en_GB' || locale == 'en_GH' || locale == 'en_ID' || locale == 'en_IE' || locale == 'en_IN' || locale == 'en_MY' || locale == 'en_NG' || locale == 'en_NZ' || locale == 'en_PH' || locale == 'en_SG' || locale == 'en_US' || locale == 'en_ZA'){
            language = 'English';            
        }
        else{
            language = 'English';
        }
        
        return language;
    }
    
    boolean checkProfile(String strProfiles){
        if(NVL(strProfiles) <> ''){
            List<String> lstProf = strProfiles.split('#');
            if(lstProf <> null && lstProf.size()>0){
                ID userId = UserInfo.getUserId();
                List<User> lstUser = [Select Profile.Name, UserRole.Name From User where Id=:userId];
                
                if(lstUser <> null && lstUser.size()>0){
                    String ProfileName = NVL(lstUser[0].Profile.Name);
                    String UserRole = NVL(lstUser[0].UserRole.Name);
                    
                    for(String prof:lstProf){
                        System.debug('@@@@@ Profile/User role name from custom setting : ' + NVL(prof).toUpperCase());
                        System.debug('@@@@@ Profile name from User Object : ' + ProfileName.toUpperCase());
                        System.debug('@@@@@ UserRole name from User Object : ' + UserRole.toUpperCase());
                        
                        if(NVL(prof).toUpperCase() == ProfileName.toUpperCase() && ProfileName <> ''){
                            return true;
                        }
                        if(NVL(prof).toUpperCase() == UserRole.toUpperCase() && UserRole <> ''){
                            return true;
                        }
                    }
                }
            }
            else{
                return true;
            }
            return false;
        }
        return true;
    }
    /*
    boolean checkProfile(String strProfiles){
        if(NVL(strProfiles) <> ''){
            List<String> lstProf = strProfiles.split('#');
            ID currentProfileId = UserInfo.getProfileId();
            List<Profile> lstProfile = [Select Name from Profile Where Id=:currentProfileId];
            
            if(lstProf <> null && lstProf.size()>0){
                for(String str:lstProf){
                    if(lstProfile <> null && lstProfile.size()>0){
                        for(Profile prof:lstProfile){
                            if(NVL(prof.name).toUpperCase() == NVL(str).toUpperCase()){
                                return true;
                            }
                        }
                    }
                }
            }
            else{
                return true;
            }
            return false;
        }
        return true;
    }
    */
    
    /*
    void FillTemplate(){
        System.debug('##### FillTemplate');
        String language = getLanguage();
        List<DocumentUploadSections__c> lstSections = [Select Note__c, Note_2__c, Section__c, IsTemplate__c, 
                 Sub_Section__c, Allowed_Profile__c
                 from DocumentUploadSections__c
                 Where Sub_Section__c =:strSubsection
                 and (Language__c = null OR Language__c =: language)
                 order by Section_Order__c];
        
        Set<String> setSection = new Set<String>();
        if(lstSections <> null && lstSections.size()>0){
            for(DocumentUploadSections__c sec:lstSections){
                setSection.add(sec.Section__c);
                System.debug('###### IsTemplate: ' + sec.IsTemplate__c);
                System.debug('###### Section: ' + sec.Section__c);
                System.debug('###### Note: ' + NVL(sec.Note__c) + ' ' + NVL(sec.Note_2__c));
                lstTemplates.add(new Templates(sec.Section__c, sec, NVL(sec.Note__c) + ' ' + NVL(sec.Note_2__c), checkProfile(sec.Allowed_Profile__c)));
            }
        }
        
        List<Document> lstDocs;
        if(setSection <> null && setSection.size()>0){
            lstDocs = [SELECT BodyLength, CreatedById, CreatedDate, Description, Id, Name, 
                        DeveloperName, Type, LastModifiedById, LastModifiedDate, 
                        CreatedBy.Name
                        FROM Document 
                        Where Description In:setSection
                        And FolderId =: strFolderId
                        Order by Description];
        }
        if(lstDocs <> null && lstDocs.size()>0){
            for(String str:setSection){
                for(Document doc:lstDocs){
                    if(NVL(str) == NVL(doc.Description)){
                        //lstTemplates.add(new Templates(str, doc));
                        for(Templates temp:lstTemplates){
                            if(temp.Section == str){
                                temp.document = doc;
                                temp.note = setNote(temp.note, doc.Id, temp.allowedProfile);
                                allowedProfileGlobal = temp.allowedProfile;
                                break;
                            }
                        }
                        break;
                    }
                }   
            }
        }

        for(Templates temp:lstTemplates){
            if(temp.document==null){
                temp.note = setNote(temp.note, null, temp.allowedProfile);
            }
        }        
        
    }
    
    Public List<Templates> getTemplates(){
        System.debug('##### getTemplates');
        if(lstTemplates.size()==0){
            lstTemplates = new List<Templates>();
            FillTemplate();
        }
        System.debug('##### Templates : ' + lstTemplates);
        return lstTemplates;
    }
    
    void retrieveDocuments(){
        if(lstDocument == null || lstDocument.size() == 0){
            lstDocument = [SELECT BodyLength, CreatedById, CreatedDate, Description, Id, Name, 
                        DeveloperName, CreatedBy.Name
                        FROM Document 
                        Where Description=:strSection
                        And FolderId =: strFolderId];
        }
    }
    
    Public List<Document> getDocuments(){
        
        System.debug('#### getDocuments: folder Id : ' + strFolderId);
        System.debug('#### getDocuments: Type : ' + strType);
        System.debug('#### getDocuments: Section : ' + strSection);
        
        retrieveDocuments();
        if(lstDocument <> null && lstDocument.size()>0){
            allowUploadDocument = blnAllowMultipleAttachments;
        }
        else{
            allowUploadDocument = true;
        }             
        return lstDocument;
    }
    Public attachFileController(){
        strSection = null;
        strSubSection = null;
        objAttachment = new Attachment();
        
        objDocument = new Document();
        lstDocument = new List<Document>();
        if(isReadOnly == null){
            isReadOnly = false;
        }
        if(NVL(strType) == ''){
            strType = strATTACHMENT;
        }
        System.debug('#### folder Id : ' + strFolderId);
        System.debug('#### Type : ' + strType);
        System.debug('#### Section : ' + strSection);
        if(conceptNoteId <> null && conceptNoteId <> ''){
            getAttachments();
        }
    }
    Public void replaceDocument(){
        if(lstDocument <> null && lstDocument.size()>0){
            //Document doc = new Document(Id=lstDocument[0].Id);
            objDocument.Id = lstDocument[0].Id;
            Update objDocument;
            lstDocument = new List<Document>();
            retrieveDocuments();
        }
    }
    Public void saveAttachments(){
        System.debug('##### strType in Save : ' + strType);
        System.debug('##### conceptNoteId in Save : ' + conceptNoteId);
        System.debug('##### strFolderId in Save : ' + strFolderId);
        if(strType == strATTACHMENT){
            
            try{
                Integer attNo=0;
                if(NVL(conceptNoteId) <> ''){
                    if(lstAttachments <> null && lstAttachments.size()>0){
                        attNo = lstAttachments.size() + 1;
                    }
                    else{
                        attNo = 1;
                    }
                    objAttachment.parentId = conceptNoteId;
                    objAttachment.Description = strSubsection + ' ' + attNo;
                    insert objAttachment;
                }

            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            }
            finally{
                objAttachment = new Attachment();
            }
        }
        if(strType == strDOCUMENT){
            try{
                if(NVL(strFolderId) <> ''){
                    objDocument.Description = strSection;
                    objDocument.FolderId = strFolderId;
                    //objDocument.DeveloperName = objDocument.name.replace(' ', '_');
                    insert objDocument;
                }
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            }
            finally{
                objDocument = new Document();
            }
        }
    }
    //Public string trpGacReviewLabel{get;set;}
    Public string trpGacReviewDocId{get;set;}
    Public boolean allowedProfileGlobal{get;set;}
    Public class AttachmentList{
        Public boolean selected{get;set;}
        Public Attachment objAtt{get;set;}
        Public Attachment objReplace{get;set;}
        Public Boolean allowedProfile{get;set;}
        Public AttachmentList(){
            this.objReplace = new Attachment();
            this.objAtt = new Attachment();
        }
        Public AttachmentList(Attachment objAtt, Boolean allowedProfile){
            this.objAtt = objAtt;
            this.objReplace = new Attachment();
            this.allowedProfile = allowedProfile;
        }
    }
    
    Public List<AttachmentList> lstAttachments{get;set;}
    
    //Public List<AttachmentList> getAttachments(){
    Public void getAttachments(){
        if(objAttachment == null){
            objAttachment = new Attachment();
        }
        Boolean allowedProfile = true;
        List<DocumentUploadSections__c> lstSections;
        System.debug('######### conceptNoteId in get Attachments : ' + conceptNoteId);
        //if(lstAttachments == null || lstAttachments.size()==0){
        lstSections = [Select Section__c, Allowed_Profile__c
                 from DocumentUploadSections__c
                 Where Sub_Section__c Like: '%' + strSubsection + '%'
                 order by Section_Order__c];
        
        
        if(lstSections <> null && lstSections.size()>0){
            allowedProfile = checkProfile(lstSections[0].Allowed_Profile__c);
            allowedProfileGlobal = allowedProfile;
        }
        if(NVL(conceptNoteId) <> ''){
            retrieveAttachments(allowedProfile);
        }
            
        //}
        if(allowedProfile == false){
            allowUploadDocument = false;
        }
        else if(lstAttachments <> null && lstAttachments.size()>0){
            allowUploadDocument = blnAllowMultipleAttachments;
        }
        else{
            allowUploadDocument = true;
        }
        //return lstAttachments;
    }
    void retrieveAttachments(Boolean allowedProfile){
        string trpReviewId='';
        string gacReviewId='';
        List<Attachment> lstAtt;
        List<DocumentUploadSections__c> lstSections;
        System.debug('######### conceptNoteId in retrieveAttachments(): ' + conceptNoteId);
        if(NVL(strAllAttachmentsFor) <> ''){
            Set<String> setSubSection = new Set<String>();
            if(strAllAttachmentsFor.toUpperCase() == 'GACREVIEW'){
                lstSections = [Select name, Note__c, Section__c, 
                         Sub_Section__c, IsTemplate__c, Allowed_Profile__c
                         from DocumentUploadSections__c
                         Where GAC_Review__c=true
                         order by Section_Order__c];
                 
            }  
            if(strAllAttachmentsFor.toUpperCase() == 'TRPREVIEW'){
                lstSections = [Select name, Note__c, Section__c, 
                         Sub_Section__c, IsTemplate__c, Allowed_Profile__c
                         from DocumentUploadSections__c
                         Where (TRP_Review__c=true Or Feedback_TRP_Review__c = true)
                         order by Section_Order__c];
                         
                System.debug('@@@@@@@ lstSections for TRPREVIEW : ' + lstSections);
            }        
             if(lstSections <> null && lstSections.size()>0){
                 for(DocumentUploadSections__c sec:lstSections){
                     setSubSection.add(sec.Sub_Section__c);
                 }
             }
             if(setSubSection <> null && setSubSection.size()>0){
                    lstAtt = new List<Attachment>(); 
                    List<Attachment> lstTempAtt = [SELECT Id, BodyLength, Description, Name, 
                        ParentId, IsPrivate, CreatedBy.Name
                        FROM Attachment Where ParentId =: conceptNoteId];
                        //FROM Attachment Where ParentId =: conceptNoteId and Description in:setSubSection];
                    for(String strSection: setSubSection){
                        for(Attachment att:lstTempAtt){
                            if(NVL(att.Description).toUpperCase().contains(NVL(strSection).toUpperCase())){
                                lstAtt.add(att);
                            }
                        }
                    }
                    System.debug('@@@@@@@ lstSections for ' + strAllAttachmentsFor.toUpperCase() + ' : ' + lstAtt);
             }
             
             if(lstAtt <> null && lstAtt.size()>0){
                 for(Attachment att:lstAtt){
                     if(att.Description.toUpperCase() == 'Outcome of GAC Review'.toUpperCase()){
                         gacReviewId = att.Id;
                     }
                     if(att.Description.toUpperCase() == 'TRP review form'.toUpperCase()){
                         trpReviewId = att.Id;
                     }
                 }
             }
             
             if(strAllAttachmentsFor.toUpperCase() == 'GACREVIEW'){
                 if(NVL(gacReviewId) <> ''){
                     trpGacReviewDocId = gacReviewId;
                     //trpGacReviewLabel = '<a href="/servlet/servlet.FileDownload?file=' + gacReviewId + '" target="_blank">' + strSubSection + '</a>';
                     //strSubSection = '<a href="/servlet/servlet.FileDownload?file=' + gacReviewId + '" target="_blank">' + strSubSection + '</a>';
                 }
                 else{
                     //trpGacReviewLabel = strSubSection;
                 }
             }
             if(strAllAttachmentsFor.toUpperCase() == 'TRPREVIEW'){
                 if(NVL(trpReviewId) <> ''){
                     trpGacReviewDocId = trpReviewId;
                     //trpGacReviewLabel = '<a href="/servlet/servlet.FileDownload?file=' + trpReviewId + '" target="_blank">' + strSubSection + '</a>';
                     //strSubSection = '<a href="/servlet/servlet.FileDownload?file=' + trpReviewId + '" target="_blank">' + strSubSection + '</a>';
                 }
                 else{
                     //trpGacReviewLabel = strSubSection;
                 }
             }
        }
        else{
            
            lstAtt = [SELECT Id, BodyLength, ContentType, CreatedById, CreatedDate, Description, Name, 
                        LastModifiedById, LastModifiedDate, OwnerId, ParentId, IsPrivate, CreatedBy.Name
                        FROM Attachment Where ParentId =: conceptNoteId and Description Like: '%' + strSubsection + '%'];
        }
        lstAttachments = new List<AttachmentList>();
        if(lstAtt <> null && lstAtt.size()>0){
            for(Attachment att: lstAtt){
                lstAttachments.add(new AttachmentList(att, allowedProfile));
            }
        }
        System.debug('######### strAllAttachmentsFor : ' + strAllAttachmentsFor);
        System.debug('##### lstAttachments : ' + lstAttachments);
        allowUploadDocument = allowedProfile;
        allowedProfileGlobal = allowedProfile;
        //return lstAttachments;
    }
    
    Public String replaceAttachId {get;set;}
    Public String replaceAttRowId{get;set;}
    Public void replaceAttachment(){
        //String replaceAttachId = ApexPages.currentPage().getParameters().get('replaceAttachId');   
        //String replaceAttRowId = ApexPages.currentPage().getParameters().get('replaceAttRowId');      
        //replaceAttachId = '00Pg0000000KWB6';
        //replaceAttRowId = '0';
        System.debug('##### replaceAttachId : ' + replaceAttachId);
        System.debug('##### replaceAttRowId : ' + replaceAttRowId);
        if(NVL(replaceAttachId) <> '' && NVL(replaceAttRowId) <> ''){
            if(lstAttachments <> null && lstAttachments.size()>=integer.valueOf(replaceAttRowId)){
                //update lstAttachments[integer.valueOf(replaceAttRowId)].objAtt;
                lstAttachments[integer.valueOf(replaceAttRowId)].objReplace.Id = replaceAttachId;
                Update lstAttachments[integer.valueOf(replaceAttRowId)].objReplace;
                lstAttachments[integer.valueOf(replaceAttRowId)].objAtt = lstAttachments[integer.valueOf(replaceAttRowId)].objReplace;
                lstAttachments[integer.valueOf(replaceAttRowId)].objReplace = new Attachment();
                System.debug('##### attachment replaced');
            }
        }
        //retrieveAttachments();
    }
    Public void DeleteSingleAttachment(){
        System.debug('##### replaceAttachId : ' + replaceAttachId);
        System.debug('##### replaceAttRowId : ' + replaceAttRowId);
        if(NVL(replaceAttachId) <> '' && NVL(replaceAttRowId) <> ''){
            if(lstAttachments <> null && lstAttachments.size()>=integer.valueOf(replaceAttRowId)){
                Delete lstAttachments[integer.valueOf(replaceAttRowId)].objAtt;
                lstAttachments.remove(integer.valueOf(replaceAttRowId));
                System.debug('##### attachment replaced');
            }
        }
    }
    Public void DeleteAttachments(){
        List<Attachment> lstDelete = new List<Attachment>();
        if(lstAttachments <> null && lstAttachments.size()>0){
            for(AttachmentList att:lstAttachments){
                System.debug('###### Is selected : ' + att.selected);
                if(att.selected == true){
                    lstDelete.add(att.objAtt);
                }
            }
        }
        System.debug('@@@@@ attachments to delete: ' + lstDelete);
        if(lstDelete <> null && lstDelete.size()>0){
            Delete lstDelete;
        }
    }
    String NVL(String str){
        if(str == null)
            return '';
        else
            return str.trim();
    }
    static testMethod void TestMethodAttachFileController() {
        AttachFileController clsTest = new AttachFileController();
        clsTest.setNote('test {string}', 'testid', true);
        clsTest.setNote('test {string}', 'testid', true);
        clsTest.getLanguage();
        clsTest.checkProfile('System Administrator');
        clsTest.checkProfile('test');
        clsTest.FillTemplate();
        clsTest.retrieveDocuments();
        clsTest.getAttachments();
        clsTest.getDocuments();
        clsTest.replaceDocument();
        clsTest.retrieveAttachments(true);
        clsTest.retrieveAttachments(false);
        clsTest.replaceAttachment();
        clsTest.DeleteSingleAttachment();
    } */
}