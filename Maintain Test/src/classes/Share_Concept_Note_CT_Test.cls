/**
 * This class contains unit tests for validating the behavior of Apex classes
 * Share_CN_CCM_CT
 */
@isTest
private class Share_Concept_Note_CT_Test {

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
    
      /*User testUser = new User(alias = 'testUser', email='standarduser@testorg.com',
                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', 
                 username='teststandarduser@testorg.com', IsActive=true,
                 CompanyName = 'test Company');
        insert testUser;*/
      Account objAccount = new Account();
        objAccount.Name = 'TestAccount';
        objAccount.Country__c = objCountry.Id;
        objAccount.LFA_Reviewer__c = testUser2.Id;
        
        insert objAccount;
        
        
        Concept_Note__c objCN = new Concept_Note__c();
        objCN.Name = 'Test CN';
        objCN.CCM_New__c = objAccount.id;
        objCN.Start_Date__c = system.today();
        objCN.Funding_End_Date__c = system.today();
        test.startTest();
        insert objCN;
        test.stopTest();
            
    }
}