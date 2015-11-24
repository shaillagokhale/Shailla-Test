/* Test Class for GIPApprovalUpdateBankAccount 
*/
@isTest
public class GIPApprovalUpdateBankAccount_Test {
    @isTest
    static void TestGIP() {
        Account objAccount = new Account();
        objAccount.Name = 'TestAccount';
        objAccount.Approval_Status__c = 'Approved';
        insert objAccount;
        Bank_Account__c bankAcc = new Bank_Account__c(Account__c = objAccount.Id);
        bankAcc.Approval_Status__c = 'LFA verification';
        bankAcc.Bank_Account_Validity_Period_End_Date__c = system.today().addDays(3);
        insert bankAcc;
        Implementation_Period__c implementationPeriod = new Implementation_Period__c();
        implementationPeriod.Bank_Account__c =  bankAcc.Id;
        implementationPeriod.Principal_Recipient__c = objAccount.Id;
        implementationPeriod.End_Date__c = system.today().adddays(4);
        insert implementationPeriod;
        
        implementationPeriod.Approval_Status__c = 'Approved';
        test.startTest();
        update implementationPeriod;
        test.stopTest();
        
        for(Bank_Account__c ba : [Select Id, Bank_Account_Validity_Period_End_Date__c
                                 from Bank_Account__c where Id = :bankAcc.Id]){
            system.assert(ba.Bank_Account_Validity_Period_End_Date__c == implementationPeriod.End_Date__c);
        }
        
    }
}