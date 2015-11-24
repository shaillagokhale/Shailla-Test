public with sharing class CreateVendorExtension {
    public Vendor__c vendor{get;set;}
    public String countryName{get;set;}
    public String strAccountId;
    Public Boolean blnAccountLocked {get;set;}
    Public List<Account> lstAcct;
   
    public CreateVendorExtension(ApexPages.StandardController stdController) {
      strAccountId = ApexPages.currentPage().getParameters().get('accId');
      blnAccountLocked = false;
      lstAcct = new List<Account>();
      vendor = (Vendor__c)stdController.getRecord(); 
      lstAcct = [Select Id, Vendor_Id__c, Locked__c from Account where Id = :strAccountId];
      if(lstAcct.size() > 0){
           blnAccountLocked = lstAcct[0].Locked__c; }
    }
     

    Public PageReference saveRecord() {
      vendor.Country__c = vendor.Country_Id__c;
      insert vendor;
      //Added by Matthew Miller on 2014-16-6 in order to deprecate the trigger PopulateVendorOnAccount
      if(lstAcct.size() > 0){
              lstAcct[0].Vendor_Id__c = vendor.Id;
              update lstAcct;
        }
      return NULL;
    }
}