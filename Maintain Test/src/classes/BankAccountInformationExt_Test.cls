/**
 * This class contains unit tests for validating the behavior of Apex classes
 * BankAccountInformationExt
 */
@isTest
private class BankAccountInformationExt_Test {
     public static Void createData() {
        
        /*Country__c objCountry = new Country__c();
        objCountry.Name = 'TestCountry';
        //objCountry.CT_Public_Group_ID__c = objGroup.Id;
        insert objCountry;

        Account objAccount = new Account( );
        objAccount.Name = 'TestAccount';
        objAccount.Country__c = objCountry.Id;
        objAccount.Approval_Status__c = 'Approved';
        insert objAccount;

        Grant__c grant = new Grant__c(Name = 'Grant');
        grant.Principal_Recipient__c = objAccount.id;
        insert grant;
       
         Bank__c bankParent = new Bank__c();
         bankparent.Country__c = objCountry.Id ;
         bankparent.SWIFT_BIC_Code__c = 'bankParent'; 
         bankparent.Name__c = 'bankParent';
         bankparent.ABA_Code__c = 'bankParent';
        insert bankParent;
         
         Bank__c bank1 = new Bank__c();
         bank1.Bank__c = bankParent.id;
         bank1.Country__c = objCountry.Id;
         bank1.SWIFT_BIC_Code__c = 'Test1';
         bank1.Name__c = 'Test1';
         bank1.ABA_Code__c = 'Test1';
         insert bank1;

       /* Bank__c bank2 = new Bank__c();
         bank2.Bank__c = bankParent.id;
         bank2.Country__c = objCountry.Id ;
         bank2.SWIFT_BIC_Code__c = 'Test2';
         bank2.Name__c = 'Test';
         bank2.ABA_Code__c = 'Test2';
        insert bank2;
         
        Bank_Account__c bankAccParent = new Bank_Account__c();
        bankAccParent.Account__c = objAccount.Id;
        insert bankAccParent;
        
        Bank_Account__c bankAcc = new Bank_Account__c(Account__c = objAccount.Id);
        //Bank_Account__c bankAcc = new Bank_Account__c();
        //bankAcc.Account__c = objAccount.Id; 
        bankAcc.Bank__c = bank1.Id;
        bankAcc.Approval_Status__c = 'Approved';
        insert bankAcc;
            
        Attachment attach=new Attachment();     
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = objAccount.id;
        insert attach;
        
        Implementation_Period__c implementationPeriod = new Implementation_Period__c(); 
        implementationPeriod.Principal_Recipient__c = objAccount.Id;
         
        //implementationPeriod.Bank_Account__c = bankAccParent.Id;
        implementationPeriod.Bank_Account__c = bankAcc.Id;
        implementationPeriod.Approval_Status__c = 'Approved';
        insert implementationPeriod;*/
         
        Country__c objCountry = TestClassHelper.insertCountry();
        
        Account objAccount = TestClassHelper.createAccount();
         objAccount.Approval_Status__c = 'Approved';
         insert objAccount;
         
        Grant__c grant =TestClassHelper.createGrant(objAccount);
         insert grant;
         
        Bank__c bankParent = new Bank__c();
         bankparent.Country__c = objCountry.Id ;
         bankparent.SWIFT_BIC_Code__c = 'bankParent'; 
         bankparent.Name__c = 'bankParent';
         bankparent.ABA_Code__c = 'bankParent';
        insert bankParent;
         
        Bank__c bank1 = new Bank__c();
         bank1.Bank__c = bankParent.id;
         bank1.Country__c = objCountry.Id;
         bank1.SWIFT_BIC_Code__c = 'Test1';
         bank1.Name__c = 'Test1';
         bank1.ABA_Code__c = 'Test1';
         insert bank1;

        Bank__c bank2 = new Bank__c();
         bank2.Bank__c = bankParent.id;
         bank2.Country__c = objCountry.Id ;
         bank2.SWIFT_BIC_Code__c = 'Test2';
         bank2.Name__c = 'Test';
         bank2.ABA_Code__c = 'Test2';
        insert bank2;
         
        Bank_Account__c bankAccParent = new Bank_Account__c();
        bankAccParent.Account__c = objAccount.Id;
        insert bankAccParent;
        Test.StartTest();
        Bank_Account__c bankAcc = new Bank_Account__c(Account__c = objAccount.Id);
        bankAcc.Bank__c = bank1.Id;
        bankAcc.Approval_Status__c = 'Update information';
        bankAcc.Selected_Bank_Id__c = 'Test1';
        bankAcc.Branch_Type__c = 'SWIFT';
        bankAcc.Selected_Branch_Id__c = 'None';
        bankAcc.Locked__c = false;
        insert bankAcc;
         
         Attachment attach=new Attachment();     
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = objAccount.id;
        insert attach;
         
         Implementation_Period__c implementationPeriod = TestClassHelper.createIP(grant, objAccount);
         implementationPeriod.Bank_Account__c = bankAcc.Id;
         implementationPeriod.Approval_Status__c = 'Approved';
         insert implementationPeriod;
         Test.stopTest();
    }

    static testMethod void myUnitTest() {
        
        //createData();
        
         Country__c objCountry = TestClassHelper.insertCountry();
        
        Account objAccount = TestClassHelper.createAccount();
        objAccount.Approval_Status__c = 'Approved';
        insert objAccount;
         
        Grant__c grant =TestClassHelper.createGrant(objAccount);
        insert grant;
         
         /*Bank__c bankParent = new Bank__c();
         bankparent.Country__c = objCountry.Id ;
         bankparent.SWIFT_BIC_Code__c = 'bankParent'; 
         bankparent.Name__c = 'bankParent';
         bankparent.ABA_Code__c = 'bankParent';
        insert bankParent;
        
        Bank__c bank2 = new Bank__c();
         bank2.Bank__c = bankParent.id;
         bank2.Country__c = objCountry.Id ;
         bank2.SWIFT_BIC_Code__c = 'Test2';
         bank2.Name__c = 'Test';
         bank2.ABA_Code__c = 'Test2';
        insert bank2;
        
         Bank__c bank1 = new Bank__c();
         bank1.Bank__c = bankParent.id;
         bank1.Country__c = objCountry.Id;
         bank1.SWIFT_BIC_Code__c = 'Test1';
         bank1.Name__c = 'Test1';
         bank1.ABA_Code__c = 'Test1';
         insert bank1;*/
        
        
        Bank__c bankParent = TestClassHelper.createBank();
        bankparent.SWIFT_BIC_Code__c = 'bankParent'; 
        bankparent.Name__c = 'bankParent';
        bankparent.ABA_Code__c = 'bankParent';
        insert bankParent;
        
        Bank__c bank1 = TestClassHelper.createBank();
        bank1.Bank__c = bankParent.id;
        bank1.SWIFT_BIC_Code__c = 'Test1';
        bank1.Name__c = 'Test1';
        bank1.ABA_Code__c = 'Test1';
        insert bank1;
        
        Bank__c bank2 = TestClassHelper.createBank();
         bank2.Bank__c = bankParent.id;
         bank2.Country__c = objCountry.Id ;
         bank2.SWIFT_BIC_Code__c = 'Test2';
         bank2.Name__c = 'Test';
         bank2.ABA_Code__c = 'Test2';
        insert bank2;
    
        
         Test.startTest();
        Bank_Account__c bankAccParent = new Bank_Account__c();
        bankAccParent.Account__c = objAccount.Id;
        insert bankAccParent;
        
        Bank_Account__c bankAcc = TestClassHelper.createBankAcc(); 
        bankAcc.Account__c = objAccount.Id;
        bankAcc.Bank__c = bank1.Id;
        bankAcc.Approval_Status__c = 'Approved';
        bankAcc.Selected_Bank_Id__c = bankParent.id;
        bankAcc.Selected_Country_Id__c = objCountry.id;
        bankAcc.Branch_Type__c = 'SWIFT';
        bankAcc.Selected_Branch_Id__c = 'New';
        insert bankAcc;
         
        Attachment attach = TestClassHelper.createAttach();
        attach.parentId = objAccount.id;
        insert attach;
        /*Attachment attach=new Attachment();     
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = objAccount.id;
        insert attach;*/
         
         Implementation_Period__c implementationPeriod = TestClassHelper.createIP(grant, objAccount);
         implementationPeriod.Bank_Account__c = bankAcc.Id;
         implementationPeriod.Approval_Status__c = 'Approved';
         insert implementationPeriod;
        Test.stopTest();
        //Implementation_Period__c ip = [SELECT Id,Principal_Recipient__c, Bank_Account__c,Approval_Status__c FROM Implementation_Period__c Limit 1 ];
        //system.debug('**implementation period**'+ip[0]);
        
        Profile_Access_Setting__c checkProfile = TestClassHelper.createProfileSetting();
        checkProfile.Page_Name__c ='BankAccountInformation';
        checkProfile.Salesforce_Item__c = 'Edit Bank Account Information';
        checkProfile.Status__c = 'Not yet submitted by PR';        
        insert checkProfile;
        
        ApexPages.currentPage().getParameters().put('mode','view');
        ApexPages.StandardController controller = new ApexPages.StandardController(implementationPeriod);
        BankAccountInformationExt ext = new BankAccountInformationExt(controller);
       
        
         
        ext.updateBankAccount();
        ext.getCountries();
        //Bank__c bankAcc = [Select Id FROM Bank__c WHERE SWIFT_BIC_Code__c = 'bankParent' LIMIT 1];
        ext.bankAccount.Selected_Bank_Id__c = bankParent.id;
        ext.bankAccount.Locked__c = true;
        ext.bankAccount.Bank__c = bankParent.id;
        //Country__c objCountry = [SELECT Id FROM Country__c LIMIT 1];
        ext.bankAccount.Selected_Country_Id__c = objCountry.Id;
        ext.getBranches();
        ext.getBanks();
        ext.attachfile();
        List<Attachment> attachments = [select id, name from Attachment where parent.id=:implementationPeriod.Principal_Recipient__c LIMIT 1];
        ext.attachmentIdToDelete = attachments[0].Id;
        ext.removeRow();
        ext.cancel();
        ext.changeToViewMode();
        ext.edit();
        ext.cancelRecord();
        ext.updateAccountApprovalStatus();
        
        ext.clearBankAccount();
        ext.saveRecord();
        ext.submittForApproval();
        ext.saveChangesAndRedirect();
        ext.checkProfile();
    }
    
    /*static testMethod void myUnitTest2() {
        PageReference page = new PageReference('');
        Test.setCurrentPage(page);
        page.getParameters().put('mode','view');
        createData();
        Implementation_Period__c ip = [SELECT Id,Principal_Recipient__c,Bank_Account__c,Approval_Status__c FROM Implementation_Period__c Limit 1  ];
        ip.Bank_Account__c = null;
        update ip;
        ApexPages.StandardController controller = new ApexPages.StandardController(ip);
        BankAccountInformationExt ext = new BankAccountInformationExt(controller);
    }*/
    
   
}