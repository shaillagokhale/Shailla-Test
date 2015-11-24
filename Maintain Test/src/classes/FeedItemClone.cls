public class FeedItemClone {
public FeedItemClone(){
      List<FeedItem> flist = new List<FeedItem>();
      List<DocumentUpload__c> dlist = new List<DocumentUpload__c>();
      List<FeedItem> finallist = new List<FeedItem>();
      List<DocumentUpload__c> doclist = new List<DocumentUpload__c>();
      flist = [Select Body,CommentCount,ContentData,ContentDescription,ContentFileName,ContentSize,ContentType,CreatedById,CreatedDate,Id,InsertedById,IsDeleted,LastModifiedDate,LikeCount,LinkUrl,ParentId,RelatedRecordId,SystemModstamp,Title,Type FROM FeedItem where CreatedById = '005b0000001VN5W' and ParentId = 'a0Eb0000008YOWOEA4'];
      dlist = [Select Id,FeedItem_Id__c,English_Translation__c,Type__c from DocumentUpload__c where CreatedById = '005b0000001VN5W'];     
      system.debug('f1 query'+flist.size());
      system.debug('dlist query'+dlist.size());
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
      } }
      insert finallist;  
      system.debug('finallist size'+finallist.size());
      for(FeedItem f2: finallist){
      DocumentUpload__c du = new DocumentUpload__c();
      du.FeedItem_Id__c = f2.Id;
      du.Concept_Note__c = f2.ParentId;          
      doclist.add(du);    
      system.debug('doclist'+doclist);    
      }    
      insert doclist;
      system.debug('doclist size'+doclist.size());                 
    }    
}