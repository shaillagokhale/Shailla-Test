public class RecreateDocuments 
{
// Class is invoked on Click of a Button in VFs/Page - RecreateDocuments_button
// 1) Receive an input as - Login person's Full Name
// 2) Queries for an Inactive user having the logged in person's Name
// 3) Recreate's FeedItem and DocumentUpload Records
    
    List<User> UserIds;
    public Boolean bln{get;set;}
    public RecreateDocuments(){        
        checkUser();                   
    }
    public void checkUser(){
         bln=false;        
         List<User> UserFlagCheck = new List<User>();
         UserFlagCheck = [select Id,Recreate_Documents__c from User where Id=:UserInfo.getUserId()];
         if(UserFlagCheck!= null){
            bln = UserFlagCheck[0].Recreate_Documents__c;
         }
         system.debug('UserFlagCheck'+UserFlagCheck);
         system.debug('constructor call');
         system.debug('bln='+bln);
    }
    public Pagereference Recreate()
    {                    
        String Username = UserInfo.getName();        
        System.debug('name'+ Username);
        String[] inputvalues = new String[]{};
            UserIds = new List<User>();
            String TempId = null;
            String CNId = null;        	
        	List<User> UserId = new List<User>();
        	//String UserIdQry = 'Select Id from User where name =';
        	// Need to add the Criteria to Query only the Inactive User's Id in the below Query
        	String UserIdQry = 'Select Id from User where name =';
        	UserIdQry += '\'' + Username + '\''; 
        	System.debug('UserIdQry ' + UserIdQry);
        	UserId = Database.Query(UserIdQry);
        	System.debug('UserId ' + UserId);
        	TempId = UserId[0].Id;
        	System.debug('TempId ' + TempId);
        
			List<FeedItem> flist = new List<FeedItem>();
			List<DocumentUpload__c> dlist = new List<DocumentUpload__c>();
			List<FeedItem> finallist = new List<FeedItem>();
			List<DocumentUpload__c> doclist = new List<DocumentUpload__c>();
                
			String flistQry = null;
			flistQry = 'Select Body,CommentCount,ContentData,ContentDescription,ContentFileName,ContentSize,ContentType,CreatedById,CreatedDate,Id,InsertedById,IsDeleted,LastModifiedDate,LikeCount,LinkUrl,ParentId,RelatedRecordId,SystemModstamp,Title,Type FROM FeedItem where CreatedById =';
            flistQry += '\'' + TempId + '\' limit 50';
			system.debug('flistQry ' + flistQry);			
			flist = Database.Query(flistQry);
        
			String dlistQry = null;
			dlistQry = 'Select Id,FeedItem_Id__c,English_Translation__c,Type__c,Process_Area__c,Program_Split__c,Language__c from DocumentUpload__c where CreatedById =';
			dlistQry += '\'' + TempId + '\'';            
			dlist = Database.Query(dlistQry);
			
			system.debug('dlist ' + dlist);
			system.debug('flist ' + flist);

	            if(flist.size() != null){
									for(FeedItem f1: flist){
															  FeedItem f2 = new FeedItem();
															  f2.body = f1.body;
															  f2.ContentFileName = f1.ContentFileName;
															  f2.ContentDescription = f1.ContentDescription;
															  f2.ContentData = f1.ContentData;                                     						                                                              															  
															  f2.Title = f1.Title;
															  f2.Type = f1.Type;
															  f2.Visibility = 'AllUsers';  
															  f2.ParentId = f1.ParentId;															  
															  finallist.add(f2);
															}
								}
						insert finallist;	
        
				system.debug('finallist size'+finallist.size());
				for(FeedItem f2: finallist){
	                DocumentUpload__c du = new DocumentUpload__c();
					du.FeedItem_Id__c = f2.Id;
					du.Concept_Note__c = f2.ParentId; 
                    for(FeedItem fi:flist){
						if(f2.ContentFileName == fi.ContentFileName && f2.ContentDescription == fi.ContentDescription && f2.ParentId == fi.ParentId){								
								for(DocumentUpload__c Doc: dlist){
									If(Doc.FeedItem_Id__c == fi.Id){                                                                    
									du.Type__c = Doc.Type__c;
                                    du.Process_Area__c = Doc.Process_Area__c;
                                    du.Program_Split__c = Doc.Program_Split__c;
                                    du.Language__c = Doc.Language__c;    
								}                       
								}
							}	
                    	}			  
											  doclist.add(du);    
											  system.debug('doclist'+doclist);    
											}    
				insert doclist;
				delete dlist;
				delete flist;     
        	
         User UserFlagUpd;
         UserFlagUpd = [select Id,Recreate_Documents__c from User where Id=:UserInfo.getUserId()];
         if(UserFlagUpd!= null){
            UserFlagUpd.Recreate_Documents__c = true;                          
        }
        update UserFlagUpd;
        system.debug('UserFlagUpd'+UserFlagUpd);       
        PageReference pg = new PageReference('/GM/RecreateDocuments_button');
        pg.setRedirect(true);
        return pg;
}
public List<User> getUserIds()
    {
        if (UserIds!= NULL)
            if (UserIds.size() > 0)
                return UserIds;
            else
                return null;                    
        else
            return null;
    }       


}