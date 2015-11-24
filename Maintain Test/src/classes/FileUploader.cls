public class FileUploader 
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};    
	List<User> UserIds;
    
    public Pagereference ReadFile()
    {
        nameFile=contentFile.toString();
        filelines = nameFile.split('\r\n');
		UserIds = new List<User>();
		
        for (Integer i=1;i<filelines.size();i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
			String TempId = null;
            String CNId = null;
			List<FeedItem> flist = new List<FeedItem>();
			List<DocumentUpload__c> dlist = new List<DocumentUpload__c>();
			List<FeedItem> finallist = new List<FeedItem>();
			List<DocumentUpload__c> doclist = new List<DocumentUpload__c>();
            
            TempId = inputvalues[0];            	                       
                
			String flistQry = null;
			flistQry = 'Select Body,CommentCount,ContentData,ContentDescription,ContentFileName,ContentSize,ContentType,CreatedById,CreatedDate,Id,InsertedById,IsDeleted,LastModifiedDate,LikeCount,LinkUrl,ParentId,RelatedRecordId,SystemModstamp,Title,Type FROM FeedItem where CreatedById =';
			flistQry += '\'' + TempId + '\'';
			system.debug('flistQry ' + flistQry);
			flist = Database.Query(flistQry);
			
			String dlistQry = null;
			dlistQry = 'Select Id,FeedItem_Id__c,English_Translation__c,Type__c,Process_Area__c,Program_Split__c,Language__c from DocumentUpload__c where CreatedById =';
			dlistQry += '\'' + TempId + '\'';
            //dlistQry += '\'' + TempId + '\' Limit 1';
			//Limit on the above line can be removed after testing for 1 record
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
															  //f2.RelatedRecordId = f1.RelatedRecordId;
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
				
				//delete dlist;
				//delete flist;
        		
            }
 return null;       
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