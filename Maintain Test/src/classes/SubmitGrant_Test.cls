/**
 * This class contains unit tests for validating the behavior of Apex classes
 * SubmitGrant
 */
@isTest
public with sharing class SubmitGrant_Test {
    static testMethod void myUnitTest() {
        Account objAccount = new Account();
        objAccount.Name = 'TestAccount';
        objAccount.Approval_Status__c = 'Approved';
        insert objAccount;
        Account Coordinating_Mechanism = new Account();
        Coordinating_Mechanism.Name = 'Test1Account';
        Coordinating_Mechanism.Approval_Status__c = 'Approved';
        insert Coordinating_Mechanism;
        Account Fund_Agent = new Account();
        Fund_Agent.Name = 'Fund_Agent';
        Fund_Agent.Approval_Status__c = 'Approved';
        insert Fund_Agent; 

        Bank_Account__c bankAcc = new Bank_Account__c(Account__c = objAccount.Id);
        bankAcc.Approval_Status__c = 'Approved';
        insert bankAcc;
        Grant__c grant = new Grant__c(Name = 'Grant',Principal_Recipient__c = objAccount.id , Start_Date__c = System.today(),
                                      Grant_Status__c = 'In Progress',Disease_Component__c  = 'HIV/AIDS',
                                      Concept_Note_Type__c = 'Country' ,Grant_Type__c = 'SSF', End_Date__c = System.today(),
                                      Contractual_Arrangement_Legal_Framework__c = 'UNDP');
        insert grant;
  
        Contact c1 = new Contact(LastName = 'c1', AccountId = objAccount.Id, FirstName = 'c1',
        Email = 'c1@test.com',Role__c = 'Authorized Signatory for Grant Agreement'); 
        insert c1;
        Contact c2 = new Contact(LastName = 'c2', AccountId = objAccount.Id, FirstName = 'c2',
        Email = 'c2@test.com',Role__c = 'Other'); 
        insert c2;
        Contact c3 = new Contact(LastName = 'c2c3', AccountId = objAccount.Id, FirstName = 'cc32',
        Email = 'c2c3@test.com',Role__c = 'Other');
        insert c3; 
 
        Implementation_Period__c implementationPeriod = new Implementation_Period__c(); 
        implementationPeriod.Principal_Recipient__c = objAccount.Id;
        implementationPeriod.Bank_Account__c = bankAcc.Id;
        implementationPeriod.Start_Date__c  = System.today();
        implementationPeriod.End_Date__c  = System.today().addDays(2);
        implementationPeriod.Implementation_Cycle__c = 'AB'; 
        implementationPeriod.Grant__c = grant.Id; 
              
        implementationPeriod.Local_Fund_Agent__c = Fund_Agent.Id;
  
        implementationPeriod.Auth_Sig_for_Grant_Agreement__c = c1.Id; 
        implementationPeriod.Financing_Mechanism__c = 'Regular Grant'; 
        implementationPeriod.Grant_Tax_Exemption__c = 'Goods & Services'; 
        implementationPeriod.Currency_of_Grant_Agreement__c = 'USD'; 
        implementationPeriod.Governance_and_Programme_Management__c = '0';
        implementationPeriod.Financial_Management_System__c = '0'; 
        implementationPeriod.Procurement_and_Supply_Chain_Management__c = '0';
        implementationPeriod.Monitoring_Evaluation__c = '0'; 
        implementationPeriod.Sub_Recipient_Management__c = '0'; 

        implementationPeriod.CCM_Chair__c = c2.Id; 

        implementationPeriod.CCM_Civil_Society_Representative__c = c3.Id;
        implementationPeriod.Secretariat_Funding_Decision_Cycle__c = 'Annual'; 
        implementationPeriod.Anti_Terrorism_Screening_and_other_Backg__c = 'Satisfactory'; 
        implementationPeriod.Approval_of_External_Auditor_Terms_of_Re__c = 'Yes'; 
        implementationPeriod.External_Audit_Approval_date__c = System.today();
        implementationPeriod.Investigations_Misuse_mi__c = 'No'; 
        implementationPeriod.Ineligible_Expenditure_Reported_Grant__c = 'No';
        implementationPeriod.Ineligible_Expenditure_Reported_PR__c = 'No'; 
        implementationPeriod.Did_TGF_Claim_reimbursement__c = 'No'; 
        implementationPeriod.Grant__c = grant.Id; 
        implementationPeriod.Bank_Account__c = bankAcc.Id; 

        implementationPeriod.Coordinating_Mechanism__c = Coordinating_Mechanism.Id;
        implementationPeriod.GIP_Submission_for_Approval_Type__c = 'Modification of existing GIP';
        implementationPeriod.Regional_Team_Leader__c = UserInfo.getUserId();
        implementationPeriod.Regional_Finance_Manager__c = UserInfo.getUserId();
        implementationPeriod.Head_of_Department__c = UserInfo.getUserId();
        implementationPeriod.Fund_Portfolio_Manager__c = UserInfo.getUserId();
        insert implementationPeriod;
        test.startTest();
        List<String> error = SubmitGrant.Submit(implementationPeriod.id); 
        System.debug('>>>>error >>' + error );
        test.stopTest();
    }
}