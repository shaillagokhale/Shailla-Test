/*
* Test class for PRUdateFormExtension
*/
@isTest
public class PRUdateFormExtension_Test {
    public static testMethod void TestPRUdateForm1(){
         test.startTest();
        createData();
       
        Implementation_Period__c ip = [SELECT Id,Principal_Recipient__c FROM Implementation_Period__c ];
       
        ApexPages.StandardController cltr = new ApexPages.StandardController(ip);
        PRUdateFormExtension con = new PRUdateFormExtension(cltr);
        Pagereference pgExp = con.renderReadOnly();
        Pagereference pg = new Pagereference('/apex/PR_Update_Form_Readonly?id='+ip.Id);
        //System.assert(pgExp.getURL() == pg.getURL());
        pgExp = con.editPrInformation();
        pgExp = con.renderEditable();
        List<Selectoption> lstContactRole = con.getContactRoleList();
        con.currentPrimary = '0';
        pgExp = con.updatePrimary();
         test.stopTest();
        Contact other_2 = new Contact(LastName = 'other_2', AccountId = ip.Principal_Recipient__c, FirstName = 'other_2',
                         Email = 'other_2@test.com',Role__c = 'Other');
        con.LFAContact = other_2;
        con.getLFAContactList();
        con.getGrantList();
        pgExp = con.updateAccountApprovalStatus();
        //con.submittForApproval();
        //con.saveChangesAndRedirect();
        con.attachfile();
        con.checkPhone('1');
        con.deleteRow();
      
    }
    
    public static testMethod void TestPRUdateForm2(){
        test.StartTest();
        createData();
        
        Implementation_Period__c ip = [SELECT Id,Principal_Recipient__c FROM Implementation_Period__c ];
       
        ApexPages.StandardController cltr = new ApexPages.StandardController(ip);
        PRUdateFormExtension con = new PRUdateFormExtension(cltr);
        
        con.addNewPRContact();
        
        //con.submittForApproval();
        
        con.saveChangesAndRedirect();
        // Clear the Grant Rowes and add new Grant Contacts
        con.selectedIndex = 'grant';
        con.clearPRRow();
        con.selectedIndex = 'dr1';
        con.clearPRRow();
        con.selectedIndex = 'dr2';
        con.clearPRRow();
        Contact other_3 = new Contact(LastName = 'other_3', AccountId = ip.Principal_Recipient__c, FirstName = 'other_3',
                                 Email = 'other_3@test.com',Role__c = 'other_3');
        insert other_3;
        con.setGrantAgreement(other_3);
        // Clear the CCM Rowes and choose new CCM Contacts
        con.CCMContactType = 'ccmchair';
        con.CCMContactId = other_3.id;
        con.updateCCMContact();
        con.CCMContactType = 'ccmcivil';
        con.CCMContactId = other_3.id;
        con.updateCCMContact();
        
        con.CCMContactType = 'grant';
        con.CCMContactId = other_3.id;
        con.updateCCMContact();
        con.CCMContactType = 'request1';
        con.CCMContactId = other_3.id;
        con.updateCCMContact();
        con.CCMContactType = 'request2';
        con.CCMContactId = other_3.id;
        con.updateCCMContact();
        test.stopTest();
        List<Attachment> attachments = [select id, name from Attachment where parent.id=:ip.Principal_Recipient__c];
        con.attachmentIdToDelete = attachments[0].Id;
        con.removeRow();
       // con.submittForApproval();
       // con.saveChangesAndRedirect();
        
       
    }
    
    public static testMethod void TestPRUdateForm3(){
        createData();
        test.startTest();
        Implementation_Period__c ip = [SELECT Id,Principal_Recipient__c FROM Implementation_Period__c ];
        Implementation_Period__c implementationPeriod = new Implementation_Period__c(); 
        implementationPeriod.Principal_Recipient__c = ip.Principal_Recipient__c;
        insert implementationPeriod;
        
        Profile_Access_Setting__c checkProfile = TestClassHelper.createProfileSetting();
        checkProfile.Page_Name__c ='BankAccountInformation';
        checkProfile.Salesforce_Item__c = 'Edit Bank Account Information';
        checkProfile.Status__c = 'Not yet submitted by PR';        
        insert checkProfile;
        
       
        ApexPages.StandardController cltr = new ApexPages.StandardController(implementationPeriod);
        PRUdateFormExtension con = new PRUdateFormExtension(cltr);
        con.submittForApproval();
        con.saveChangesAndRedirect();
        con.checkProfile();
       test.stopTest();
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
        Grant__c grant = new Grant__c(Name = 'Grant',Principal_Recipient__c = objAccount.id);
        insert grant;
        
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
        
        Implementation_Period__c implementationPeriod = new Implementation_Period__c(); 
        implementationPeriod.Principal_Recipient__c = objAccount.Id;
        implementationPeriod.Auth_Sig_for_Grant_Agreement__c = c1.Id;  
        implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = c2.Id;  
        implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = c3.Id;  
        implementationPeriod.CCM_Civil_Society_Representative__c = ccm1.Id;  
        implementationPeriod.CCM_Chair__c = ccm2.Id;  
        insert implementationPeriod;
       
        Attachment attach=new Attachment();     
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = objAccount.id;
        insert attach;
        
    }
}