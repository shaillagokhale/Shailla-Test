public without sharing class RSVPextension {

    public Campaign campaign {get;set;}
    public CampaignMember campaignMember {get;set;}
    public Contact contact {get;set;}
    List<CampaignMember> lstCampaignMember = new List<CampaignMember>();
    public Boolean blnDisplay {get;set;}
    public String strConId;
    

    public RSVPextension(ApexPages.StandardController controller) {
    
    campaign = (Campaign) controller.getRecord();
    if(ApexPages.currentPage().getParameters().get('ContactId') != NULL){
        strConId = ApexPages.currentPage().getParameters().get('ContactId'); }
    if(strConId != null){
        contact = [Select Name, Id from Contact where Id = :strConId]; }
        
    getCampaignMember();


    }
    
    public void getCampaignMember(){
    
    if(contact != null && campaign != null){
       blnDisplay = true;
    
       lstCampaignMember = [Select Id, ContactId, Contact.Name, Comments__c, Status__c, CampaignId from CampaignMember where ContactId = :contact.Id AND CampaignId = :campaign.Id];       
       if(!lstCampaignMember.isEmpty()){
           campaignMember = lstCampaignMember[0]; }
       else {
           campaignMember = new CampaignMember (ContactId = contact.Id, CampaignId = campaign.Id); }
       }
       else {
           blnDisplay = false; }    
    }
    
    
    public List<Selectoption> getResponses(){
        List<Selectoption> lstResponses = new List<Selectoption>();
        lstResponses.add(new Selectoption('','--None--'));
        lstResponses.add(new Selectoption('Accepted','Yes'));
        lstResponses.add(new Selectoption('Declined','No'));     
        return lstResponses;
    }
    
    
    public pageReference Save(){
        
        try{
            upsert campaignMember; }
        catch(Exception ex) {
            ApexPages.addMessages(ex); }
    
        return new pageReference('/apex/RSVP?id=' + campaign.Id + '&ContactId=' + contact.Id);       
     }
     

     

}