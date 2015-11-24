/**
 * This class contains unit tests for validating the behavior of Apex classes
 * Share_Account_CT
 */
@isTest
private class Share_Account_CT_Test {

    static testMethod void myUnitTest() {
        Profile p = [SELECT id from profile where name = 'System Administrator' Limit 1];
        User testUser2 = new User(alias = 'testUse2', email='standarduser2@testorg.com',
                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', 
                 username='teststandarduser2@testorg.com', IsActive=true,
                 CompanyName = 'test Company');
        insert testUser2;
        Country__c objCountry = new Country__c();
        objCountry.Name = 'TestCountry';
        objCountry.CT_Public_Group_ID__c = String.valueOf(testUser2.Id);
        insert objCountry;
    
        /*User testUser1 = new User(alias = 'testUser', email='standarduser@testorg.com',
                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', 
                 username='teststandarduser@testorg.com', IsActive=true,
                 CompanyName = 'test Company');
        test.startTest();
        insert testUser1;
        test.stopTest();*/
        Account objAccount = new Account();
        objAccount.Name = 'TestAccount';
        objAccount.Country__c = objCountry.Id;
        objAccount.LFA_Reviewer__c = testUser2.Id;
        test.startTest();
        insert objAccount;
        test.stopTest();
            
    }
}