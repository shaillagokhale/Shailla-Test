Public without sharing class ctrlFeedItem {  
   Public static List<FeedItem> getFeedItems(String ParentID) {
       return [select Id,ContentFileName,ContentDescription From FeedItem where  ParentId =: ParentID and Type = 'ContentPost'];                                      
   }
   
    Public static List<FeedItem> getFunctionalTeamFeedItems(String ParentID,Map<Id,User> mapUserId) {
       return [select Id,ContentFileName,RelatedRecordId,ContentDescription From FeedItem where  ParentId =: ParentID and CreatedById IN: mapUserId.keyset() And Type = 'ContentPost'];                                      
   }
}