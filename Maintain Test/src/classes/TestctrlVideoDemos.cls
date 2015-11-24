@isTest
Public Class TestctrlVideoDemos{
    Public static testMethod void TestctrlVideoDemos(){ 
     
     ctrlVideoDemos RelatedToFilter = new ctrlVideoDemos();
         Video_Demo__c vid = new Video_Demo__c();
         vid.Name = 'test';
         vid.Video_Embed_Code__c = 'test';
         vid.Related_To__c = 'test';
         vid.Description__c = 'test';
         vid.Points__c = 10;
         vid.Video_URL__c = 'www.test.com';
     insert vid;  
         RelatedToFilter.SelectedRelatedTo = 'All'; 
     ctrlVideoDemos SortButton = new ctrlVideoDemos(); 
         SortButton.SelectedSort = 'Name';
         
          sortButton.RelatedToFilter();
          sortButton.SortButton();
         
             
    }
}