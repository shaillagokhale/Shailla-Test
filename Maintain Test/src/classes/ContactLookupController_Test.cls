/**
 * This class contains unit tests for validating the behavior of Apex classes
 * ContactLookupController
 */
@isTest
private class ContactLookupController_Test {

    static testMethod void myUnitTest() {
  		
	    createData();
	    Country__c objCountry = [Select Id From Country__c LIMIT 1];
	   	PageReference page = new PageReference('');
	    Test.setCurrentPage(page);
	    page.getParameters().put('lksrch','ccm');
	    page.getParameters().put('txt','contactrole2');
	    page.getParameters().put('country',objCountry.Id);
	    Test.startTest();
	    ContactLookupController controller = new ContactLookupController();
		controller.search();
	  	controller.getFormTag();
	  	controller.getAccounts();
	  	controller.getAccountId();
	  	controller.getListSize();
	  	controller.getFormTag();
	   	Test.stopTest();
	}
	
	static testMethod void myUnitTest2() {
  	
	    createData();
	    Country__c objCountry = [Select Id From Country__c LIMIT 1];
	   	PageReference page = new PageReference('');
	    Test.setCurrentPage(page);
	    page.getParameters().put('lksrch','');
	    page.getParameters().put('txt','c');
	    page.getParameters().put('country',objCountry.Id);
	    Test.startTest();
	    ContactLookupController controller = new ContactLookupController();
		controller.search();
	  	controller.getFormTag();
	  	controller.getAccounts();
	  	controller.getAccountId();
	  	controller.getListSize();
	  	controller.getFormTag();
	   	Test.stopTest();
	}
	
	public static void createData() {
		Country__c objCountry = new Country__c();
        objCountry.Name = 'TestCountry';
        //objCountry.CT_Public_Group_ID__c = objGroup.Id;
        insert objCountry;
        
        Account objAccount = new Account();
        objAccount.Name = 'TestAccount';
        objAccount.Country__c = objCountry.Id;
        objAccount.Approval_Status__c = 'LFA verification';
        insert objAccount;
	    List<Contact> lstContact = new List<Contact>();
        Contact c1 = new Contact(LastName = 'c1', AccountId = objAccount.Id, FirstName = 'c1',
                                 Email = 'c1@test.com',Role__c = 'Authorized Signatory for Grant Agreement');                                 
        Contact c2 = new Contact(LastName = 'c2', AccountId = objAccount.Id, FirstName = 'c2',
                                 Email = 'c2@test.com',Role__c = 'Authorized Signatory for Disbursement Request');
		Contact c3 = new Contact(LastName = 'c1', AccountId = objAccount.Id, FirstName = 'c3',
                                 Email = 'c3@test.com',Role__c = 'Authorized Signatory for Disbursement Request');
		Contact ccm1 = new Contact(LastName = 'ccm1', AccountId = objAccount.Id, FirstName = 'ccm1',
                                 Email = 'ccm1@test.com',Role__c = 'Other');                                 
        Contact ccm2 = new Contact(LastName = 'ccm2', AccountId = objAccount.Id, FirstName = 'ccm2',
                                 Email = 'ccm2@test.com',Role__c = 'Other');
        Contact other1 = new Contact(LastName = 'other1', AccountId = objAccount.Id, FirstName = 'other1',
                                 Email = 'other1@test.com',Role__c = 'Other');
		Contact other2 = new Contact(LastName = 'other2', AccountId = objAccount.Id, FirstName = 'other2',
                                 Email = 'other2@test.com',Role__c = 'Other');
		lstContact.add(c1);    
		lstContact.add(c2); 
		lstContact.add(c3);
		lstContact.add(ccm1);
		lstContact.add(ccm2);		
		lstContact.add(other1);		
		lstContact.add(other2);
		insert lstContact;
	}
}