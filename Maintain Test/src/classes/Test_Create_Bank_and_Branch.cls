/************************************
Test class for trigger Create_Bank_and_Branch
and also for AccountBeforeInsertUpdate and 
updateRelatedAccountOwners.

Written by Matthew Miller February 1 2014
************************************/

@isTest
Public Class Test_Create_Bank_and_Branch{
    Public static testMethod void Test_Create_Bank_and_Branch(){
    
    //Query for PR RecordTypeId
    Id prID = [Select ID from RecordType where SObjectType = 'Account' and Name = 'PR'].Id;
    
    
    //Create sample users with Standard User
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    
    User u1 = new User(Alias = 'newUser', Email='newuser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Kapoor', FirstName='Kareena', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuserX@testorg.com');
         insert u1;
         
    User u2 = new User(Alias = 'newUser', Email='newuser2@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Kapoor', FirstName='Ranbir', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuserX2@testorg.com');
         insert u2;
         
    User u3 = new User(Alias = 'newUser', Email='newuser3@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Padukone', FirstName='Deepika', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuserX3@testorg.com');
         insert u3;
    
    //Test PR, Country, Bank, and Branch
        
        Country__c objCountry = new Country__c(Name = 'Afghanistan',FPM__c = u2.Id);
        insert objCountry;
        
        Account objAcc = new Account(Name='Test Acc');
        if(prID != null){
          objAcc.RecordTypeId = prID; }
        insert objAcc;
        
        objCountry.FPM__c = u3.Id;
        update ObjCountry;
        
        Bank__c objBank = new Bank__c();
        objBank.Country__c = objCountry.Id;
        objBank.Name__c = 'Bank of Afghanistan';
        insert objBank;
        
        Bank__c objBranch = new Bank__c();
        objBranch.ABA_Code__c = 'ABAAFG12345';
        objBranch.SWIFT_BIC_Code__c = 'SWAGF12345';
        objBranch.Bank__c = objBank.Id;
     
     //Test Bank Account with lookup filled;   
        
        Bank_Account__c objBA1 = new Bank_Account__c();
        objBA1.Account__c = objAcc.Id;
        objBA1.Bank__c = objBranch.Id;
        objBA1.Approval_Status__c = 'Send to finance system for approval';
        insert objBA1;
        
        objBA1.Approval_Status__c = 'Approved';
        update objBA1;
        
        
     //Test Bank Account with Bank__c lookup not filled, has an existing bank selected
     
        Bank_Account__c objBA2 = new Bank_Account__c();
        objBA2.Account__c = objAcc.Id;
        objBA2.Approval_Status__c = 'Send to finance system for approval';
        objBA2.SWIFT_BIC_Code__c = 'SWAFG98765';
        objBA2.ABA_Code__c = 'ABAAFG98765';
        objBA2.Selected_Country_Id__c = objCountry.Id;
        objBA2.Selected_Bank_Id__c = objBank.Id;
        objBA2.Selected_Branch_Id__c = 'New';
        
        insert objBA2;
        
        objBA2.Approval_Status__c = 'Approved';
        update objBA2; 
     
      
     //Test Bank Account with Bank__c lookup not filled, has no existing bank selected
     
        Bank_Account__c objBA3 = new Bank_Account__c();
        objBA3.Account__c = objAcc.Id;
        objBA3.Approval_Status__c = 'Send to finance system for approval';
        objBA3.SWIFT_BIC_Code__c = 'SWAFG98765';
        objBA3.ABA_Code__c = 'ABAAFG98765';
        objBA3.Selected_Country_Id__c = objCountry.Id;
        objBA3.Selected_Bank_Id__c = 'New';
        objBA3.Selected_Branch_Id__c = 'New';
        insert objBA3;
        
        objBA3.Approval_Status__c = 'Approved';
        update objBA3;
     
        
    }
}