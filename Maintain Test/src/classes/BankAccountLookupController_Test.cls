/**
 * This class contains unit tests for validating the behavior of Apex classes
 * BankAccountLookupController
 */
@isTest
private class BankAccountLookupController_Test {

    static testMethod void myUnitTest() {
    	Account objAccount = new Account();
        objAccount.Name = 'TestAccount';
        objAccount.Approval_Status__c = 'LFA verification';
        insert objAccount;
        Bank_Account__c bankAccParent = new Bank_Account__c(Account__c = objAccount.Id);
        insert bankAccParent;
      	Bank_Account__c bankAcc = new Bank_Account__c(Account__c = objAccount.Id);
      	bankAcc.Approval_Status__c = 'Update information';
      	insert bankAcc;
      	PageReference page = new PageReference('');
		Test.setCurrentPage(page);
	    page.getParameters().put('lksrch','B');
	    page.getParameters().put('txt','c');
	    page.getParameters().put('accId',objAccount.Id); 
	    BankAccountLookupController cltr = new BankAccountLookupController();   
	    cltr.search();
	    cltr.DoSort();
	    cltr.getAccountId();
	    cltr.getListSize();
	    cltr.QueryAccounts();
	    cltr.getFormTag();
	    cltr.getAccounts();
	    cltr.searchText = '';
	    cltr.DoSort();
    }
    
}