public with sharing class PRUdateFormExtension {

    public Implementation_Period__c implementationPeriod {get;set;} 
    public Account account  {get;set;} 
    public List<Contact> listContacts{get;set;}
    public List<SelectOption> roles {get;set;}
    public String currentPrimary{get;set;}
    public List<Contact> lstContactForRole{get;set;}
    public String selectedIndex{get;set;}
    //public Attachment attach {get;set;}
    
    //CCM Contacts
     public Contact contactCCMChair  {get;set;} 
     //public Id contactCCMChairAttachmentId  {get;set;} 
     //public Attachment attachContactCCMChair {get;set;}
     public Contact contactCCMCivilSociety {get;set;} 
     //public Id contactCCMCivilSocietyAttachmentId  {get;set;} 
     //public Attachment attachCCMCivilSociety {get;set;}
     public String CCMContactId{get;set;}
     public String CCMContactType{get;set;}
        
     //PR Authorized Signatory Contacts
     public Contact grantAgreement  {get;set;} 
     public Contact disbursementRequest1 {get;set;} 
     public Contact disbursementRequest2 {get;set;} 
     
     //Boolean for controlling mode -- Added 2014-06-17 by Matthew Miller
     Public Boolean blnFinanceMode {get;set;}
     
     //TCS 15/10/2014: US Core Data Form
	 Public Boolean blnEditPRInformation {get;set;}
     public boolean attachmentMessage{get;set;}
     public Contact LFAContact{get;set;}
     public String attachmentIdToDelete{get;set;}
     public static Id contactPRRecordTypeId {get;set;}
     public List<Attachment> lstAttachment {get;set;}
     public void setGrantAgreement(Contact grantAgreement) {
         this.grantAgreement  = grantAgreement;
     }

     public PRUdateFormExtension(ApexPages.StandardController controller) {
     	checkProfile(); //TCS 15/10/2014: US Core Data Form
         if(controller.getId() == NULL || (controller.getId().length() != 15 && controller.getId().length() != 18)) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check the Implementation Period Id before procceding.'));return;
             
         }
         implementationPeriod = (Implementation_Period__c) controller.getRecord();
         // TODO : Add Error
         init();
         account = getAccount(implementationPeriod.Principal_Recipient__c);
         getContact(implementationPeriod.Principal_Recipient__c);             
         populateRoles();
         contactPRRecordTypeId= Schema.SObjectType.Contact.RecordTypeInfosByName.get('PR').getRecordTypeId();
     }

     public void init() {
         //Using a custom setting to set the Boolean that controls the mode -- Added 2014-06-17 by Matthew Miller
         blnFinanceMode = false;
         List<PR_Update_Mode__c> lstCustSetting = [Select Finance_Mode__c from PR_Update_Mode__c ORDER BY CreatedDate DESC LIMIT 1];
         if(lstCustSetting.size() > 0){
             blnFinanceMode = lstCustSetting[0].Finance_Mode__c;
         }
         
         LFAContact = new Contact(); 
         Set<Id> contactIds = new Set<Id>();
         contactCCMCivilSociety = new Contact();
         contactCCMChair = new Contact();
         attachmentMessage = false;
         if(Test.isRunningTest()) {
            implementationPeriod = [SELECT Principal_Recipient__c,Implementation_Period__c.Local_Fund_Agent__c,CCM_Chair__c,
            Approval_Status_Explanation__c , Grant_Tax_Exemption__c ,Name, Auth_Sig_for_Grant_Agreement__c, CCM_Civil_Society_Representative__c, 
            Auth_Sig_for_Disbursement_Request_1__c,   Auth_Sig_for_Disbursement_Request_2__c, Country__c FROM  Implementation_Period__c
            WHERE Id =: implementationPeriod.Id];
         }
         if(implementationPeriod.CCM_Chair__c != NULL) {contactIds.add(implementationPeriod.CCM_Chair__c);}
         if(implementationPeriod.CCM_Civil_Society_Representative__c != NULL) {contactIds.add(implementationPeriod.CCM_Civil_Society_Representative__c);}
         if(implementationPeriod.Auth_Sig_for_Grant_Agreement__c != NULL) {contactIds.add(implementationPeriod.Auth_Sig_for_Grant_Agreement__c);}
         if(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c != NULL) {contactIds.add(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c);}
         if(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c != NULL) {contactIds.add(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c);}
         populateMapContact(contactIds);
         
         if(implementationPeriod.CCM_Chair__c != NULL) {
             contactCCMChair = getContactById(implementationPeriod.CCM_Chair__c);
             //attachContactCCMChair = getAttachmentId(implementationPeriod.CCM_Chair__c);
         }
         if(implementationPeriod.CCM_Civil_Society_Representative__c != NULL) {
             contactCCMCivilSociety = getContactById(implementationPeriod.CCM_Civil_Society_Representative__c);
             //attachCCMCivilSociety = getAttachmentId(implementationPeriod.CCM_Civil_Society_Representative__c);
         }
         grantAgreement = getContactById(implementationPeriod.Auth_Sig_for_Grant_Agreement__c);
         grantAgreement.Role__c = 'Authorized Signatory for Grant Agreement';
         disbursementRequest1 = getContactById(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c);
         disbursementRequest1.Role__c = 'Authorized Signatory for Disbursement Request';
         disbursementRequest2 = getContactById(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c);
         disbursementRequest2.Role__c = 'Authorized Signatory for Disbursement Request';
         lstAttachment = [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :implementationPeriod.Principal_Recipient__c];
     }
     
     /*
     public Attachment getAttachmentId(Id contactId) {
         List<Attachment> attList = [SELECT Id, Name, LastModifiedDate FROM Attachment WHERE ParentId =:contactId order by createdDate desc];
         if(attList.size() > 0) {
             return attList[0];
         }
         return new Attachment();
     }
     */
     public void removeRow() {
         if(attachmentIdToDelete != NULL){
             delete [Select Id from Attachment where Id =:attachmentIdToDelete];
             lstAttachment = [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :implementationPeriod.Principal_Recipient__c];
         }
     }

     public Pagereference renderReadOnly(){  //Modified 2014-06-17 by Matthew Miller to include Locked__c
         if(account.Approval_Status__c == 'LFA verification' || account.Approval_Status__c == 'Send to finance system for approval' ||
                 account.Approval_Status__c == 'Reject' || account.Approval_Status__c == 'Correction required' || account.Approval_Status__c == 'Approved' 
                 || account.Approval_Status__c == 'Finance Officer verification' || account.Locked__c) {
             Pagereference pg = new Pagereference('/apex/PR_Update_Form_Readonly?id='+implementationPeriod.Id);
             pg.setRedirect(true);
             return pg;
         }

         return NULL;
     }


     public PageReference renderEditable()   // //upd by jl  //Modified 2014-06-17 by Matthew Miller to include Locked__c
     {
         if(account.Approval_Status__c == 'Update Information' && account.Locked__c == false){
             Pagereference pg = new Pagereference('/apex/PR_Update_Form?id='+implementationPeriod.Id);
             pg.setRedirect(true);
             return pg;
         }       
         return NULL;
     }
     
     public Pagereference editPrInformation() {


         if(account != null)
         {
             account.Approval_Status__c = 'Update Information';
             update account;

         }

         Pagereference pg = new Pagereference('/apex/PR_Update_Form?id='+implementationPeriod.Id);
         pg.setRedirect(true);
         return pg;
     }
     
     
     public List<Selectoption> getContactRoleList() {
         List<Selectoption> lstSelectOptions = new List<Selectoption>();
         lstSelectOptions.add(new Selectoption('','--None--'));
         lstSelectOptions.add(new Selectoption('Other','Other'));
         lstSelectOptions.add(new Selectoption('Focal point' ,'Focal Point'));
         return lstSelectOptions;
     }

     /* Get All contact associated to the Account Contact Relationship where account is
      * Implementation Period account
      */
     public void getContact(Id accountId) {
         listContacts = new List<Contact>();

         for(Contact contact : [SELECT Id, FirstName , LastName, Email,Phone ,Salutation , 
                                Title, Role__c,Primary_Contact__c
                                FROM Contact 
                                WHERE AccountId = :accountId
                                AND (Role__c = 'Other' OR Role__c = 'Focal Point')]) {
             listContacts.add(contact);
         }

         // add 2 blank rows if there are no contacts
         if(listContacts.size() == 0) {
             //listContacts.add(new Contact(AccountId=account.Id));
             //listContacts.add(new Contact());
         }
     }

     /* Get all required Account fields from Implementation Period account 
      */
     public Account getAccount(Id accountId){
         /*String query = 'SELECT ';
         List<Schema.FieldSetMember> lstFields = SObjectType.Account.FieldSets.PR_Information.getFields();
         for(Schema.FieldSetMember f : lstFields) {
             if(f.getFieldPath() == 'Ethics_COI_Code_of_Conduct__c' || 
                     f.getFieldPath() == 'Address_line_1__c' || 
                     f.getFieldPath() == 'Approval_Status__c' || 
                     f.getFieldPath() == 'Approval_Status_Explanation__c' || 
                     f.getFieldPath() == 'Country__c') {
                 continue;
             }
             query += f.getFieldPath() + ', ';
         }
         query += 'Id , Country__c, Ethics_COI_Code_of_Conduct__c,Address_line_1__c ,Approval_Status__c, Approval_Status_Explanation__c, Locked__c FROM Account ';
         query += 'Where Id = \''+accountId+'\' LIMIT 1';
         return Database.query(query);*/
         Account acct = new Account();
         List<Account> lstAccount = [Select Id, Name, PR_Validity_Period_Start_Date__c, Full_Legal__c, PR_Validity_Period_End_Date__c, Legal_Abbreviation__c, Address_line_1__c, 
                                     Country_Fiscal_Cycle__c, Address_line_2__c, Type__c,  Address_line_3__c, Sub_Type__c, City__c, PR_Fiscal_Cycle_Start_Month__c, 
                                     State_Province__c, PR_Fiscal_Cycle_Start_Day__c, Zip_Postal_Code__c, PR_Fiscal_Cycle_End_Month__c, Country_address__c, PR_Fiscal_Cycle_End_Day__c,
                                     Ethics_COI_Code_of_Conduct__c, Approval_Status__c, Approval_Status_Explanation__c, Country__c, Locked__c, Submitted_GIP_Id__c
                                     from Account where Id = :accountId];
         if(lstAccount.size() > 0) acct = lstAccount[0];
         return acct;
     }

     
     public void populateRoles() {
         roles = new List<SelectOption>();
         roles.add(new SelectOption('none','--None--'));
         for(Schema.Picklistentry role : Account_Contact_Relationship__c.Role__c.getDescribe().getPicklistValues()){
             roles.add(new SelectOption(role.getValue(),role.getValue()));
         }
     }
        
     public PageReference updateAccountApprovalStatus() {
         attachmentMessage =false;
         account.Approval_Status__c =  'Finance Officer verification';
         account.Most_Recent_Submitter__c = UserInfo.getUserId();
         try {
             update account;
         } catch(Exception ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
         }
         if(account.Approval_Status__c == 'LFA verification' || account.Approval_Status__c == 'Send to finance system for approval' ||
                 account.Approval_Status__c == 'Reject' || account.Approval_Status__c == 'Correction required' || account.Approval_Status__c == 'Finance Officer verification') {
             Pagereference pg = new Pagereference('/apex/PR_Update_Form_Readonly?id='+implementationPeriod.Id);
             pg.setRedirect(true);
             return pg;
         }
         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your PR Request has been submitted.'));
         return NULL;
     }

     public Pagereference updatePrimary(){
         if(currentPrimary == NULL) {
             return NULL;
         }
         if(currentPrimary.length() != 15 &&  currentPrimary.length() != 18) {
             // TODO Throw ERROR
             //return NULL;
         }  
         for(Contact c : listContacts) {
             c.Primary_Contact__c = false;
         } 
         listContacts[Integer.valueof(currentPrimary)].Primary_Contact__c = true;

         return NULL;
     }

     public List<Contact> getLFAContactList() {

         if(LFAContact.AccountId == NULL) {
             return NULL;
         }       
         Account a = [SELECT Country__c From Account WHERE Id = :implementationPeriod.Principal_Recipient__c];
         return [SELECT Id, Name , FirstName , LastName, Email,Phone ,Salutation, MailingCity, MailingCountry,
                 MailingPostalCode,MailingState,MailingStreet,Fax,Account.Name,
                 Title, Role__c,Primary_Contact__c FROM Contact 
                 WHERE Account.Country__c =:a.Country__c AND Account.RecordType.Name = 'LFA']; 


     }

     public List<Grant__c> getGrantList() {

         return [SELECT Name , Start_Date__c , End_Date__c ,Grant_Status__c ,Sub_Status__c FROM Grant__c 
                 WHERE Principal_Recipient__c =:implementationPeriod.Principal_Recipient__c];

     }

     public Pagereference submittForApproval() {    
         system.debug('-=-=-=-implementationPeriod=-=-=-'+implementationPeriod);
         // Save Record first 
         Pagereference pg = saveRecord();
         boolean hasPrimaryContact = false;
         if(blnFinanceMode) hasPrimaryContact = true;
                                 
         attachmentMessage = false;
         // field Validations
         String errorMessage = 'sd';
         List<String> errorFields = new List<String>();
         if(account.Ethics_COI_Code_of_Conduct__c != 'Yes') {
             errorFields.add('Please confirm that you have read the Policy on Ethics and COI and the Code of Conduct : Select at the bottom.');
         }
         if(account.Name == NULL) {errorFields.add('PR Organization');}
         if(account.Legal_Abbreviation__c == NULL) {errorFields.add('Official Abbreviation');}
         if(account.Address_line_1__c == NULL) {errorFields.add('Address line 1');}
         if(account.Type__c == NULL) {errorFields.add('PR Type');}
         if(account.City__c == NULL) {errorFields.add('City');}
         if(account.Country_address__c == NULL) {errorFields.add('Country (Mailing Address)');}
         if(account.PR_Fiscal_Cycle_Start_Month__c == NULL) {errorFields.add('PR Fiscal Cycle Start Month');}
         if(account.PR_Fiscal_Cycle_Start_Day__c == NULL) {errorFields.add('PR Fiscal Cycle Start Day');}
         if(account.PR_Fiscal_Cycle_End_Month__c == NULL) {errorFields.add('PR Fiscal Cycle End Month');}
         if(account.PR_Fiscal_Cycle_End_Day__c == NULL) {errorFields.add('PR Fiscal Cycle End Day');}        
         //if(account.Country__c == NULL) {errorFields.add('Country');}
         
         //PR Contacts. Now the page will only check for the first signatory if the page is in Finance Mode. Modified 2014-06-17 by Matthew Miller
           if(!blnFinanceMode){
              if(implementationPeriod.Auth_Sig_for_Grant_Agreement__c == NULL) {errorFields.add('Authorized Signatory for Grant Agreement');}
              if(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c == NULL) {errorFields.add('Authorized Signatory for Disbursement Request 1');}
              //if(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c== NULL) {errorFields.add('Authorized Signatory for Disbursement Request 2');} -- 2014.6.17 No longer required for any user
           }      

         List<Contact> ccmContact = new List<Contact>();
         if(contactCCMChair != null) ccmContact.add(contactCCMChair);
         if(contactCCMCivilSociety != null) ccmContact.add(contactCCMCivilSociety);
         /* for(Contact contact : ccmContact) {                // upd by jl
        if(Contact.Salutation == NULL) {
        errorFields.add('CCM-Contact.Salutation');
        }
        if(Contact.FirstName == NULL) {
        errorFields.add('CCM-Contact.First Name');
        }
        if(Contact.LastName == NULL) {
        errorFields.add('CCM-Contact.Last Name');
        }
        if(Contact.Email == NULL) {
        errorFields.add('CCM-Contact.Email');
        }
        if(Contact.Phone == NULL) {
        errorFields.add('CCM-Contact.Phone');
        }
        if(Contact.Title == NULL) {
        errorFields.add('CCM-Contact.Title');
        }
                }   */
         List<Contact> signatoryContact = new List<Contact>();
         if(grantAgreement != null && !blnFinanceMode) signatoryContact.add(grantAgreement);
         if(disbursementRequest1 != null && !blnFinanceMode) signatoryContact.add(disbursementRequest1);        
         if(disbursementRequest2 != null){
           if(disbursementRequest2.LastName != null) signatoryContact.add(disbursementRequest2);         
         }
         
         for(Contact contact : signatoryContact) {  
             if(contact.FirstName == NULL) { errorFields.add(contact.Role__c + ' First Name');}
             if(contact.LastName == NULL) {errorFields.add(contact.Role__c + ' Last Name');}
             //if(contact.Email == NULL) { errorFields.add(contact.Role__c + ' Email');}  -- As per request of Finance, Email and Phone are no longer required. 2014-6-17 modified by Matthew Miller
             //if(Contact.Phone == NULL) {errorFields.add(contact.Role__c + ' Phone');}
             if(contact.Phone != null){
             if(!checkPhone(contact.Phone)){errorFields.add(Contact.Role__c + ' Phone must be 9 to 15 digits.');}
             }
             if(contact.Title == NULL) {errorFields.add(contact.Role__c + ' Title');}
             if(contact.Primary_Contact__c) {hasPrimaryContact = true;}
         }

         for(Contact contact : listContacts) {
               if(!blnFinanceMode){
                 if(contact.FirstName == NULL) {errorFields.add('PR Contact First Name');}
                 if(contact.Role__c == NULL) {errorFields.add('PR Contact Role');}
                 //if(contact.Email == NULL) {errorFields.add('PR Contact Email');} -- As per request of Finance, Email and Phone are no longer required. 2014-6-17 modified by Matthew Miller
                 if(contact.Phone != null){
                   if(!checkPhone(contact.Phone)) {errorFields.add('PR Contact Phone must be 9 to 15 digits.');}}
                 }
             
                 if(contact.Primary_Contact__c){
                   if(!blnFinanceMode){
                     //if(contact.Phone == NULL) {errorFields.add('PR Contact Phone');}                     
                     if(contact.Salutation == NULL) {errorFields.add('PR Contact Salutation');}
                     if(contact.Title == NULL) {errorFields.add('PR Contact Title');}
                   }
                   hasPrimaryContact = true;
                 }
           }


         //CCM Contacts. If the page is in Finance Mode, these are not required. Modified 2014-06-17 by Matthew Miller
         if(!blnFinanceMode){
           if(implementationPeriod.CCM_Civil_Society_Representative__c == NULL) { errorFields.add('CCM Civil Society Representative'); }               
           if(implementationPeriod.CCM_Chair__c == NULL) { errorFields.add('CCM Chair'); }
         }

         if(implementationPeriod.Grant_Tax_Exemption__c== NULL) {errorFields.add('Grant Tax Exemption');}

         if(errorFields.size() > 0) {
             errorMessage = 'Your information has been saved successfully, but before submitting you must enter values in the following fields:<br/>';
             errorMessage += '<ul>';
             errorFields.sort();
             for(String field : errorFields) {
                 errorMessage += '<li>'+field+'</li>';
             }
             errorMessage += '</ul>';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
             return NULL;
         } else if(!hasPrimaryContact){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Primary Contact.'));
             return NULL;
         }

         // Check Primary Contact on Implementation Period
         List<Contact> contactList = [SELECT Id , Name FROM Contact 
                                      WHERE Primary_Contact__c = true 
                                      AND AccountId = :implementationPeriod.Principal_Recipient__c
                                      AND (Id in :listContacts OR Id in :signatoryContact)];
         if(contactList.size() == 0 && !blnFinanceMode) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must select one PR Contact as the Primary Contact for the organization'));
             return NULL;
         }
         if(contactList.size() > 1) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must select ONLY one PR Contact as the Primary Contact for the organization'));
             return NULL;
         }
         
         List<Contact> primaryOffPage = [SELECT Id , Name FROM Contact 
                                      WHERE Primary_Contact__c = true 
                                      AND AccountId = :implementationPeriod.Principal_Recipient__c
                                      AND Id not in :listContacts AND Id not in :signatoryContact];
                                      
               for(Contact pc : primaryOffPage){
                  pc.Primary_Contact__c = false; }
               update primaryOffPage;

         // Check SubmitGrant class Validations 
         /*String response = SubmitGrant.Submit(implementationPeriod.Id);
            if(SubmitGrant.Submit(implementationPeriod.Id) != 'true') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must enter values in the following fields:'+response));
          return NULL;
            }
            List<Bank_Account__c> lstBankAcc = [SELECT Id FROM Bank_Account__c 
                                     WHERE Id = :implementationPeriod.Bank_Account__c
                                     AND Approval_Status__c = 'Approved'];
            if(account.Approval_Status__c != 'Approved' || lstBankAcc.size() <= 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Principal Recipient and Bank Account approval status must be Approved'));
          return NULL;
            }*/

         return NULL;
     } 

     public Pagereference saveRecord() {
         attachmentMessage = false;
         contactPRRecordTypeId= Schema.SObjectType.Contact.RecordTypeInfosByName.get('PR').getRecordTypeId();
         // Update Implementation Period
         try{
             if(contactCCMCivilSociety.Id != NULL) {
                 implementationPeriod.CCM_Civil_Society_Representative__c = contactCCMCivilSociety.Id;
             }
             if(contactCCMChair.Id != NULL) {
                 implementationPeriod.CCM_Chair__c = contactCCMChair.Id;
             }
             System.debug('>>>>>grantAgreement'+grantAgreement);
             // Populate GrantAgreement
             if(grantAgreement.Id == NULL) {
                 if(/*grantAgreement.Email != NULL &&*/ grantAgreement.LastName != NULL){ //MM removed the email as a requirement for upsert on 23.01.2014
                     grantAgreement.RecordTypeId = contactPRRecordTypeId;
                     grantAgreement.AccountId = account.Id;
                     grantAgreement.Role__c = 'Authorized Signatory for Grant Agreement';
                     insert grantAgreement;
                     System.debug('>>>>>grantAgreementiiiiiii'+grantAgreement);
                     implementationPeriod.Auth_Sig_for_Grant_Agreement__c = grantAgreement.Id;
                     System.debug('>>>>>implementationPeriod.Auth_Sig_for_Grant_Agreement__c'+implementationPeriod.Auth_Sig_for_Grant_Agreement__c);
                 }
             } else {

                 implementationPeriod.Auth_Sig_for_Grant_Agreement__c = grantAgreement.Id;
                 upsert grantAgreement;  
             }
             System.debug('>>>>>disbursementRequest1'+disbursementRequest1);
             // Populate disbursementRequest1
             if(disbursementRequest1.Id == NULL) {
                 if(/*disbursementRequest1.email != NULL &&*/ disbursementRequest1.Lastname != NULL){ //MM removed the email as a requirement for upsert on 23.01.2014
                     disbursementRequest1.RecordTypeId = contactPRRecordTypeId;
                     disbursementRequest1.AccountId = account.Id;
                     disbursementRequest1.Role__c = 'Authorized Signatory for Disbursement Request';
                     insert disbursementRequest1;
                     implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = disbursementRequest1.Id;
                 }
             } else {
                 upsert disbursementRequest1;    
             }
             System.debug('>>>>>disbursementRequest2'+disbursementRequest2);
             // Populate disbursementRequest2
             if(disbursementRequest2.Id == NULL) {
                 if(/*disbursementRequest2.email != NULL &&*/ disbursementRequest2.Lastname != NULL){ //MM removed the email as a requirement for upsert on 23.01.2014
                     disbursementRequest2.RecordTypeId = contactPRRecordTypeId;
                     disbursementRequest2.AccountId = account.Id;
                     disbursementRequest2.Role__c = 'Authorized Signatory for Disbursement Request';
                     insert disbursementRequest2;
                     implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = disbursementRequest2.Id;
                 }
             } else {
                 upsert disbursementRequest2;    
             }
             System.debug('>>>>>implementationPeriod'+implementationPeriod);
             update implementationPeriod;
             account.Submitted_GIP_Id__c = implementationPeriod.Id;
             update account;

             // Upsert Key Contacts
             system.debug('>>>>clistContactsoUpdate'+listContacts);
             List<Contact> lstContactToUpdate = new List<Contact>();
             for(Contact c : listContacts) {
                 system.debug('------0--->'+c);
                 if(c.Id != NULL) {
                     system.debug('------1--->'+c);
                     lstContactToUpdate.add(c);
                     system.debug('>>>>'+c);
                 } else {
                     /*
                                  if(c.LastName == NULL)
                                  {
                                    c.LastName.addError('Last Name : You Must Enter a Value');
                                    return null;
                                  }

                                  if(c.email == NULL)
                                  {
                                    c.email.addError('Email : You Must Enter a Value');
                                    return null;
                                  }


                                  if(c.Role__c == NULL)
                                  {
                                    c.Role__c.addError('Role : You Must Enter a Value');
                                    return null;
                                  }
                      */
                     system.debug('------2--->'+c);
                     if(c.email != NULL && c.LastName != NULL && c.Role__c != NULL ) {
                         c.RecordTypeId = contactPRRecordTypeId;
                         c.AccountId = account.Id;
                         lstContactToUpdate.add(c);
                     }
                 }

             }  
             system.debug('>>>>lstContactToUpdate'+lstContactToUpdate);
             upsert lstContactToUpdate;

             /*
             // Process Attachment
             if(attach.Id == NULL && attach.Name != NULL && attach.body != NULL) {
                 attach.ParentId = account.Id;
                 upsert attach;                    
             }

             // Process CCM Contacts
             
             if(attachCCMCivilSociety.Id == NULL && attachCCMCivilSociety.Name != NULL && contactCCMCivilSociety.Id != NULL) {
                 attachCCMCivilSociety.ParentId = contactCCMCivilSociety.Id;
                 upsert attachCCMCivilSociety;                     
             }

             if(attachContactCCMChair.Id == NULL && attachContactCCMChair.Name != NULL && contactCCMChair.Id != NULL) {
                 attachContactCCMChair.ParentId = contactCCMChair.Id;
                 upsert attachContactCCMChair;                     
             }
             */
         } catch (exception ex) {
             return NULL;
         }
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Information Saved Successfully.'));return NULL;
     }

     public Pagereference deleteRow(){
         if(selectedIndex == NULL) {
             return null;
         }
         Contact contact  = listContacts.get(Integer.valueOf(selectedIndex));
         try{
             if(contact.Id != NULL) {
                 delete contact;
             }
         } catch (exception ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));return NULL;
         }
         listContacts.remove(Integer.valueOf(selectedIndex));
         return NULL;
     }
     
      public Pagereference clearPRRow(){
         Contact c = new Contact();
         c.RecordTypeId = contactPRRecordTypeId;
         c.AccountId = account.Id;
         if(selectedIndex == 'grant') {
            c.Role__c = 'Authorized Signatory for Grant Agreement';
            grantAgreement = c;
            implementationPeriod.Auth_Sig_for_Grant_Agreement__c = null;
         }
         if(selectedIndex == 'dr1') {
            c.Role__c = 'Authorized Signatory for Disbursement Request';
            disbursementRequest1 = c;
            implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = null;
         }
         if(selectedIndex == 'dr2') {
            c.Role__c = 'Authorized Signatory for Disbursement Request';
            disbursementRequest2 = c;
            implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = null;
         }
         return NULL;
     }

     public Pagereference updateCCMContact(){
        System.debug('listContacts>>>>>'+listContacts);
         if(CCMContactId == NULL) {return NULL;}
         if(CCMContactType == 'ccmchair') {
             contactCCMChair = getContactById(CCMContactId);
             implementationPeriod.CCM_Chair__c = CCMContactId;      //upd by jl
         }

         if(CCMContactType == 'ccmcivil') {
             contactCCMCivilSociety = getContactById(CCMContactId);
             implementationPeriod.CCM_Civil_Society_Representative__c = CCMContactId;   //upd by jl
         }

         if(CCMContactType == 'grant') {
             grantAgreement = getContactById(CCMContactId);
             grantAgreement.Role__c = 'Authorized Signatory for Grant Agreement';
             implementationPeriod.Auth_Sig_for_Grant_Agreement__c = CCMContactId;    //upd by jl
         }
         if(CCMContactType == 'request1') {
             disbursementRequest1 = getContactById(CCMContactId);
             disbursementRequest1.Role__c = 'Authorized Signatory for Disbursement Request';
             implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = CCMContactId;   //upd by jl
         }
         if(CCMContactType == 'request2') {
             disbursementRequest2 = getContactById(CCMContactId);
             disbursementRequest2.Role__c = 'Authorized Signatory for Disbursement Request';
             implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = CCMContactId;   //upd by jl
         }
         return NULL;
     }

         public Static Map<Id,Contact> mapContacts = new Map<Id,Contact>(); 
         
         public static void populateMapContact(Set<Id> contactIdSet) {
            mapContacts = new Map<Id,Contact>([SELECT Name,Id, FirstName , LastName, Email,Phone ,Salutation , 
                                                                 Title, Role__c,Primary_Contact__c
                                                                 FROM Contact 
                                                                 WHERE Id in: contactIdSet ]);
         }
         
     public Contact getContactById(Id contactId) {
           
         if(contactId == NULL) {
             return new Contact();
         }
           if(!mapContacts.containsKey(contactId)) {
           
            List<Contact> lstAddCons = [SELECT Name,Id, FirstName , LastName, Email,Phone ,Salutation , 
                                             Title, Role__c,Primary_Contact__c
                                             FROM Contact 
                                             WHERE Id =: contactId limit 1];
            if(!lstAddCons.isEmpty()){
            Contact c = lstAddCons[0]; 
                 mapContacts.put(c.Id,c);    }        
           }
         return mapContacts.get(contactId);
     }

     public Pagereference addNewPRContact(){
         for(Contact c : listContacts) {
             c.Primary_Contact__c = false;
         }
         listContacts.add(new Contact(LastName = '', AccountId=account.Id));
         return NULL;
     }


     /* Check if Phone number is 15 Digit or 9 Digit
      */
     public boolean checkPhone(String phone) {
         if(phone.length() <= 15 && phone.length() >= 9) {
             return true;
         }
         return false;
     }
     
     /*
     public Pagereference uploadPRLetter(){

         if(attach.Name != NULL && attach.body != NULL) {
             if(attach.Id == NULL) {
                 attach.ParentId = account.Id;
             }
             try{
                 upsert attach;  
                 attachmentMessage = true;
             }catch (exception ex) {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
                 return NULL;
             }       
         }
         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Attachment '+attach.Name+' has been successfully attached to accout '+ account.Name));
         return NULL;
     }
     
     
     public Pagereference uploadCCMChair() {
         System.debug('><>>'+contactCCMCivilSociety);
         if(contactCCMChair.Id == NULL || attachContactCCMChair.Name == NULL ) {
             return null;
         }       
         System.debug('><>>'+23);    
         try{
             if(contactCCMCivilSociety.id == NULL) {
                 attachContactCCMChair.ParentId = contactCCMChair.Id;    
             }
             upsert attachContactCCMChair;
             //contactCCMChair = getContactById(implementationPeriod.CCM_Chair__c);
             attachContactCCMChair = getAttachmentId(implementationPeriod.CCM_Chair__c);
             System.debug('><>>'+contactCCMCivilSociety);
         }catch (exception ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
             return NULL;
         }  
         return NULL;  
     }
     /*
     public Pagereference uploadCCMCivil() {
         System.debug('><>>'+contactCCMCivilSociety.Id);
         System.debug('><>>'+attachCCMCivilSociety.Name);
         if(contactCCMCivilSociety.Id == NULL || attachCCMCivilSociety.Name == NULL ) {
             return null;
         }
         System.debug('><>>'+3);     
         try{
             if(attachCCMCivilSociety.id == NULL) {
                 attachCCMCivilSociety.ParentId = contactCCMCivilSociety.Id; 
             }
             upsert attachCCMCivilSociety;       
             //contactCCMCivilSociety = getContactById(implementationPeriod.CCM_Civil_Society_Representative__c);
             attachCCMCivilSociety = getAttachmentId(implementationPeriod.CCM_Civil_Society_Representative__c);
             System.debug('><>>'+attachCCMCivilSociety);
         }catch (exception ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
             return NULL;
         }   
         return NULL; 
     }
     */

     public Pagereference saveChangesAndRedirect() {
         saveRecord();
         Pagereference pg = new Pagereference('/apex/grantmakingoverview?id='+implementationPeriod.Id);
         pg.setRedirect(true);
         return pg;

     }

     public Pagereference attachfile(){
         saveRecord();
         Pagereference ref = new Pagereference('/p/attach/NoteAttach?pid='+account.Id+'&parentname='+account.Name+'&retURL=/apex/PR_Update_Form?id='+implementationPeriod.Id);
         ref.setRedirect(true);
         return ref;
     }
     /*
     public Pagereference rerenderUplaodButton() {
         attach.ParentId = account.Id;
         system.debug('*************attach.Name********'+ attach);   
         return null;
     }      
     */ 
     /* For Custom Setting profile Implementation*/
     //TCS 15/10/2014: US Core Data Form
    public void checkProfile(){
                blnEditPRInformation = false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting__c> checkpage = new List<Profile_Access_Setting__c>();
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting__c where Page_Name__c ='PR Update Form Readonly' and Profile_Name__c =: profileName ];
        for (Profile_Access_Setting__c check : checkpage){
            if(check.Salesforce_Item__c == 'Edit PR Information') blnEditPRInformation = true;
            }
    }
    /* End */
}