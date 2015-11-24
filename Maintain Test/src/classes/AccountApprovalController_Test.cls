public with sharing class AccountApprovalController_Test {
  public static testMethod void testAccountApproval(){
  	Country__c objCountry = TestClassHelper.insertCountry();
  	
  	User objUser = [Select ID, country from User where id=:userinfo.getUserId()];
  	
  	Vendor__c objVendor = new Vendor__c();
  	objVendor.Name = 'test'; 
  	objVendor.Country__c = objCountry.Id;
  	objVendor.CurrencyIsoCode ='USD';
  	insert objVendor;
  	
    Account objAcc1 = TestClassHelper.createAccount();
    objAcc1.Country__c = objCountry.Id;
    insert objAcc1;
   
    Contact objContact = new Contact();
  	objContact.AccountId = objAcc1.Id;
  	objContact.LastName = 'test';
  	insert objContact;
  	
  	
  	
   
   Grant__c objGrant  = TestClassHelper.createGrant(objAcc1);
   insert objGrant;
        
   Implementation_Period__c objIP = TestClassHelper.createIP(objGrant,objAcc1);
   objIP.Auth_Sig_for_Grant_Agreement__c = objContact.Id;
   objIP.Auth_Sig_for_Disbursement_Request_1__c = objContact.Id;
   objIP.Auth_Sig_for_Disbursement_Request_2__c = objContact.Id;
   objIP.CCM_Chair__c = objContact.Id;
   objIP.CCM_Civil_Society_Representative__c = objContact.Id;
   insert objIP;
  	 
  	
   Account objAcc = TestClassHelper.createAccount();
   objAcc.Country__c = objCountry.Id;
   objAcc.CT_Finance_Officer__c = objUser.Id;
   objAcc.Address_Line_1__c ='test';
   objAcc.Address_Line_2__c ='test';
   objAcc.Address_Line_3__c ='test';
 
   objAcc.State_Province__c ='testprovince';
   objAcc.Zip_Postal_Code__c ='52013';
   objAcc.PR_Validity_Period_Start_Date__c= Date.today();
   objAcc.PR_Validity_Period_End_Date__c = Date.today().addYears(3);
   objAcc.Type__c ='Gov';
   objAcc.Sub_Type__c='';
   objAcc.Approval_Status__c='Update information';
   objAcc.Submitted_GIP_Id__c = objIP.Id;
   objAcc.Vendor_ID__c = objVendor.id;
   objAcc.Locked__c = false;
   insert objAcc;
   
   
 
  	
  
  Account_Approval__c  objAccountApproval = new Account_Approval__c ();
  	
  	objAccountApproval.Account__c = objAcc.Id;
  	objAccountApproval.Actual_Approver__c = objUser.Id;
  	objAccountApproval.Comments__c = 'testing';
    objAccountApproval.CurrencyIsoCode = 'USD';
  	objAccountApproval.Assigned_To__c = objUser.Id;
  	objAccountApproval.Status__c ='Pending';
  	insert objAccountApproval; 
  	
  
        
  	
  	
  	
  	Account_Approval__c  objAccountApproval1 = new Account_Approval__c ();
  	objAccountApproval1.Status__c ='Pending';
  	objAccountApproval1.Account__c = objAcc1.Id;
  	objAccountApproval1.CurrencyIsoCode = 'USD';
  	insert objAccountApproval1;
  
   ApexPages.currentPage().getParameters().put('accId',objAcc.Id);
   
   AccountApprovalController objAccountAprovalCtrl = new  AccountApprovalController();
   
   objAccountAprovalCtrl.checkApprovals();
   
    objAccountAprovalCtrl.approve();
    
    
   objAccountAprovalCtrl = new  AccountApprovalController();
   ApexPages.currentPage().getParameters().put('accId',objAcc1.Id);
   objAccountAprovalCtrl.checkApprovals();
   objAccountAprovalCtrl.reject();
  
   
  }
 
}