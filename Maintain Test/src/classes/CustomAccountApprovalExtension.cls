public with sharing class CustomAccountApprovalExtension {
public Account acc {get;set;}
public boolean reqWaiting {get;set;}

    public CustomAccountApprovalExtension(ApexPages.StandardController controller) {
        acc = (Account)controller.getRecord();
        //reqWaiting = false;       
    }
    
    public List<Account_Approval__c> getAccountApprovals(){
      List<Account_Approval__c> lstAccApp =  [Select Id, Status__c, Comments__c from Account_Approval__c where Account__c = :acc.Id AND Status__c = 'Pending'];
      if(!lstAccApp.isEmpty()){
        reqWaiting = true;}
      return lstAccApp;
     }
}