Public with sharing Class ctrlVideoDemos{
  Public List<Video_Demo__c> lstVideos {get;set;}
  Public List<selectoption> RelatedToOptions{get;set;}
  Public String SelectedRelatedTo {get;set;}
  Public String SelectedSort {get;set;}
  Public List<Video_Demo__c> lstvid {get;set;}
  Public String VidId {get;set {VidId = value;
            System.debug('value: '+value);
            }
        }
  
    public ctrlVideoDemos(){
        Schema.DescribeFieldResult F = Video_Demo__c.Related_To__c.getDescribe();
        RelatedToOptions = new List<selectoption>();
        RelatedToOptions.add(new SelectOption('All','All'));
        List<Schema.PicklistEntry> RelatedList = F.getPickListValues();
        for (Schema.PicklistEntry Entry : RelatedList){ 
            RelatedToOptions.add(new SelectOption(Entry.getLabel(), Entry.getValue()));
        } 
        lstVideos = [Select Id,Name,Description__c,Video_URL__c,Video_Embed_Code__c,Related_To__c,CreatedDate,Points__c From Video_Demo__c];        
        RelatedToFilter();
    }    
    Public Void RelatedToFilter(){
        String Query = 'Select Id,Name,Description__c,Video_URL__c,Video_Embed_Code__c,Related_To__c,CreatedDate,Points__c From Video_Demo__c';        
        if(SelectedRelatedTo == 'All'){
            Query += '';
        }else{
        if(String.Isblank(SelectedRelatedTo) == false){
            Query += ' Where Related_To__c INCLUDES(:SelectedRelatedTo)';
        }}
        lstVideos = Database.Query(Query);
    }
    Public Void SortButton(){
        String Query = 'Select Id,Name,Description__c,Video_URL__c,Video_Embed_Code__c,Related_To__c,CreatedDate,Points__c From Video_Demo__c';
        if(SelectedRelatedTo == 'All'){
            Query += '';
        }else{
        if(String.Isblank(SelectedRelatedTo) == false){
            Query += ' Where Related_To__c INCLUDES(:SelectedRelatedTo)';
        }}
        if(SelectedSort == 'Name'){
            Query += ' Order By Name';
        }
        if(SelectedSort == 'CreatedDate'){
            Query += ' Order By CreatedDate DESC';
        }
        if(SelectedSort == 'Points'){
            Query += ' Order By Points__c DESC';
        }
        lstVideos = Database.Query(Query);
    }
    /*Public Void VoteForThis(){
        System.debug('VidId: '+VidId);
        lstVid = [Select Id,Points__c from Video_Demo__c Where ID =: VidId Limit 1];
             lstVid[0].Points__c + 10;
        update lstVid;
    }*/
}