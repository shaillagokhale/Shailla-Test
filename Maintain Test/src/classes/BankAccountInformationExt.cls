public with sharing class BankAccountInformationExt {

    public Implementation_Period__c implementationPeriod {get;set;} 
    public Account account {get;set;}
    public boolean readOnly {get;set;}
    public boolean edit {get;set;}
    public boolean view {get;set;}
    public boolean lock {get;set;}
    public boolean newBankAccount {get;set;}
    public Bank_Account__c bankAccount {get;set;}
    public List<Attachment> lstAttachment {get;set;}
    public String attachmentIdToDelete{get;set;}
    public String selectedCountry {get;set;}
    public String selectedBank {get;set;}
    public String selectedBranch {get;set;}
    
    //Variables from which protected account fields are set
    public String varBankAccountNumber {get;set;}
    public String varIBAN {get;set;}
    public String varIntermedBankAccountNumber {get;set;}
    public String varIntermedIBAN {get;set;}
    
    //TCS 15/10/2014: US Core Data Form
    public Boolean blnEditBankInformation {get; set;}
    
    
    private Id currentBankAccount;
    public BankAccountInformationExt(ApexPages.StandardController controller) {
    	checkProfile(); //TCS 15/10/2014: US Core Data Form
        implementationPeriod = (Implementation_Period__c) controller.getRecord();
        readOnly = true;
        edit = false;
        view = false;
        if(ApexPages.currentPage().getParameters().get('mode') != NULL &&
            ApexPages.currentPage().getParameters().get('mode') == 'view') {
            readOnly = false;
          edit = false;
          view = true;
        }
        // TODO : Add Error
         account = [SELECT Id , Approval_Status__c FROM Account WHERE Id =: implementationPeriod.Principal_Recipient__c limit 1];
         
         currentBankAccount = implementationPeriod.Bank_Account__c ;
         getBankAccount();
        lstAttachment = [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :bankAccount.Id];
     
     if(bankAccount.Approval_Status__c == 'Update information' && !bankAccount.Locked__c) {
        readOnly = false;
            edit = false;
            view = true;
     }
     if(bankAccount.Approval_Status__c == 'Approved' && !bankAccount.Locked__c) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Changing any information on this form requires you to resubmit the information for approval.'));return;
     }
     if(!bankAccount.Locked__c && (bankAccount.Approval_Status__c == 'LFA verification' || bankAccount.Approval_Status__c == 'Send to finance system for approval' || bankAccount.Approval_Status__c == 'Finance Officer verification')) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'If you need to make changes after you have already submitted information for review, please contact your Country Team Finance Officer'));return;
     }
     if(bankAccount.Locked__c){
       //Added 2014-6-18 by Matthew Miller as part of the introduction of locking mechanisms
       readOnly = true;
       edit = false;
       view = false;
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'This bank account is locked and may not be edited'));return;
     }
    }
    
    public void getBankAccount(){
     List<Bank_Account__c> lstBankAccount = [Select 
                                             //Basic fields
                                             Bank_Account_Type__c,Account__c, Account__r.Name,Name, Bank_Account_Name_Beneficiary__c,Approval_Status__c,Approval_Status_Explanation__c,
                                             Bank_Account_Legal_Owner_Name__c,Bank_Account_Validity_Period_Start_Date__c,Bank_Account_Validity_Period_End_Date__c,                                             
                                             Branch_Number__c, Branch_Type__c, GIP_Submission_Id__c, IBAN_No__c, Bank_Account_Number__c, BSB_Routing_No_RTGS_IFSC_Code__c, Approved_in_GFS__c,
                                             //Protected versions of account numbers (set by workflow to show, e.g., 12****7890)
                                             Bank_Account_Number_Protected__c, IBAN_No_Protected__c, Intermediary_Bank_Account_Number_Protect__c, Intermediary_Bank_IBAN_No_Protected__c,                                                                                          
                                             //Hidden fields related to the custom select lists
                                             Bank_Name_txt__c, Country_txt__c, Selected_Bank_Id__c, Selected_Country_Id__c, Selected_Branch_Id__c,
                                             //Fields through the Bank__c lookup
                                             Bank__c, Bank__r.Name__c,Bank__r.SWIFT_BIC_Code__c, Bank__r.ABA_Code__c, 
                                             Bank__r.Bank__r.Name__c, Bank__r.Bank__r.Country__r.Name,                                             
                                             //Formula fields that pull through Bank__c or from fields on Bank Account
                                             Bank_Name_GFS__c, Country_GFS__c, SWIFT_BIC_Code_GFS__c, ABA_Code_GFS__c,
                                             //Fields for creating a new bank
                                             New_Bank_Name__c,SWIFT_BIC_Code__c,ABA_Code__c,
                                             //The checkbox for locking -- addes 2014-6-18
                                             Locked__c,
                                             //Address
                                             Bank_Address_line_1__c,  Bank_Address_line_2__c, Bank_Address_line_3__c,
                                             City__c, State_Province__c,Postal_Code_Zip__c,
                                             //Intermediary Bank and other fields
                                             Intermediary_Bank__c,Intermediary_Bank_Name__c,Intermediary_Bank_Address__c,Intermediary_Bank_City__c,Intermediary_Bank_Country__c,                                             
                                             Intermediary_Bank_Code__c,Intermediary_Bank_Branch_Number__c,Intermediary_Bank_Account_Number__c,Intermediary_Bank_Swift_BIC_code__c,
                                             Intermediary_Bank_ABA_Routing_No__c,Intermediary_Bank_IBAN_No__c, Bank_Account_Currency__c,Bank_Account_in_the_Grant_Currency__c,
                                             Please_Explain_Rationale__c,Separate_bank_account_in_local_currency__c,Local_Currency_Bank_Account_Details__c ,Bank_Code__c, Additional_Account_Name__c, 
                                             WB_Bank_Account_Additional_Instruction__c, WB_Bank_Account_Instruction__c
                                             FROM Bank_Account__c WHERE Id =: implementationPeriod.Bank_Account__c ];
        
                                  
     if(lstBankAccount.size() > 0) {
         bankAccount = lstBankAccount[0];
         currentBankAccount = bankAccount.Id;
     } else if(currentBankAccount == NULL){
         bankAccount = new Bank_Account__c();
         bankAccount.Account__c = account.Id;
         // Switch to edit mode
         readOnly = false;
         edit = true;
         view = false;
     }
     //Setting the variables related to the protected fields -- 
     //If the account is not locked, the fields will be set from these variables at the end
     varBankAccountNumber = bankAccount.Bank_Account_Number__c;
     varIBAN = bankAccount.IBAN_No__c;
     varIntermedBankAccountNumber = bankAccount.Intermediary_Bank_Account_Number__c;
     varIntermedIBAN = bankAccount.Intermediary_Bank_IBAN_No__c;
     lock = bankAccount.Approved_in_GFS__c;
    }
    
    public void updateBankAccount() {
        if(implementationPeriod.Bank_Account__c != NULL) {
                 getBankAccount();
        }       
    }
    
    public List<Selectoption> getCountries(){
        List<Selectoption> lstCountry = new List<Selectoption>();
        lstCountry.add(new Selectoption('none','--None--'));
        for(Country__c c : [Select Name, Id from Country__c Order by Name Asc]) {
            lstCountry.add(new Selectoption(c.Id,c.Name));
        }
        return lstCountry;
    }
    
    // SWIFT/ABA select list
    public List<Selectoption> getBranches(){
        String type = bankAccount.Branch_Type__c;
        List<Selectoption> lstBranch = new List<Selectoption>();
        lstBranch.add(new Selectoption('none','--None--'));        
        if(bankAccount.Selected_Bank_Id__c == NULL) {
            return lstBranch;
        }
        else{
        List<Bank__c> lstBranches = [Select Name, Name__c, SWIFT_BIC_Code__c, 
                       ABA_Code__c, Id 
                       from Bank__c where Bank__c = :bankAccount.Selected_Bank_Id__c];

            for(Bank__c bk : lstBranches){
                if(bk.SWIFT_BIC_Code__c != null && (type == null || type == 'SWIFT' || type == 'Other')){
                    lstBranch.add(new SelectOption(bk.Id, bk.SWIFT_BIC_Code__c));
                }
            }
            for(Bank__c bk : lstBranches){
                if(bk.ABA_Code__c != null && (type == null || type == 'ABA' || type == 'Other')){
                    lstBranch.add(new SelectOption(bk.Id, bk.ABA_Code__c));
                }
            }
            lstBranch.add(new Selectoption('New','Create New Branch'));
            return lstBranch;
        }
    }
    
    
    public List<Selectoption> getBanks(){
        List<Selectoption> lstBanks = new List<Selectoption>();
        lstBanks.add(new Selectoption('none','--None--'));
        if(bankAccount.Selected_Country_Id__c == NULL) {
            return lstBanks;
        }
        for(Bank__c b : [Select Name,Name__c, Id from Bank__c 
                            Where Bank__c = null and Country__c = :bankAccount.Selected_Country_Id__c Order 
                            by Name__c]) {
            lstBanks.add(new Selectoption(b.Id,b.Name__c));
        }
        lstBanks.add(new Selectoption('New','Create New Bank'));
        
        return lstBanks;
    }
    
    public void removeRow() {
        if(attachmentIdToDelete != NULL){
                delete [Select Id from Attachment where Id =:attachmentIdToDelete];
                lstAttachment = [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :bankAccount.Id];
        }
    }
    
    public Pagereference cancel() {
        return NULL;
    }
    
    public pageReference clearBankAccount() {
        implementationPeriod.Bank_Account__c = null;
        update implementationPeriod;
        
        currentBankAccount = null;
        getBankAccount();
       
        return null; 
    }
    
    public Pagereference changeToViewMode() {
        
        try {
            bankAccount.Approval_Status__c = 'Update Information';
            update bankAccount;
      }catch(Exception ex) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));return NULL;
      }
      
      if(bankAccount.Approval_Status__c == 'Update Information'){
        readOnly = false;
            edit = false;
            view = true;    
      }
      
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You must submit this information for approval or you will not receive a grant from The Global Fund.'));
        System.debug('Greetings from Line 157');
      return NULL;
    }
    
    public Pagereference edit() {
        readOnly = false;
        edit = true;
        view = false;
        return NULL;
    }
    
    public PageReference updateAccountApprovalStatus() {
        bankAccount.Approval_Status__c = 'Finance Officer verification';
        bankAccount.GIP_Submission_Id__c = implementationPeriod.Id;
       
        try {
            update bankAccount;
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your Bank Account information has been submitted for review.'));
        readOnly = true;
            edit = false;
            view = false;
      return NULL;
    }

   public Pagereference saveRecord() {
    if(bankAccount.Selected_Country_Id__c == 'none' && bankAccount.Selected_Bank_Id__c == 'New') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You are adding a new bank; please select a country.'));return NULL;
    }
    if(bankAccount.Selected_Bank_Id__c == 'New' && bankAccount.New_Bank_Name__c == NULL) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please insert new bank details.'));return NULL;
    }
    if(bankAccount.Selected_Bank_Id__c == 'New' && bankAccount.Selected_Branch_Id__c != 'New') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'If you are adding a new bank, you must also add a new branch.'));return NULL;
    }
    if(bankAccount.Selected_Branch_Id__c == 'New' && bankAccount.ABA_Code__c == NULL && bankAccount.SWIFT_BIC_Code__c == NULL) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please insert new Branch details (SWIFT or ABA).'));return NULL;
    }
    
    //Setting the protected fields from the variables if the account is not locked
    if(!lock){
      bankAccount.Bank_Account_Number__c = varBankAccountNumber;
      bankAccount.IBAN_No__c = varIBAN;
      bankAccount.Intermediary_Bank_Account_Number__c = varIntermedBankAccountNumber;
      bankAccount.Intermediary_Bank_IBAN_No__c = varIntermedIBAN;
     }
    
    //Storing Country, Bank names in fields for approval by finance,
    //and Salesforce Ids for later record creation upon approval
    if(bankAccount.Selected_Country_Id__c != 'none' && bankAccount.Selected_Country_Id__c != 'New') {
        //bankAccount.Selected_Country_Id__c = selectedCountry;
        List<Country__c> lstSelectedCountry = [Select Id, Name from Country__c where Id = :bankAccount.Selected_Country_Id__c];
        if(!lstSelectedCountry.isEmpty() && lstSelectedCountry.size()==1){
         bankAccount.Country_txt__c = lstSelectedCountry[0].Name;
       }
    }
    
    if(bankAccount.Selected_Bank_Id__c != 'none' && bankAccount.Selected_Bank_Id__c != 'New') {
        //bankAccount.Selected_Bank_Id__c = selectedBank;
        List<Bank__c> lstSelectedBank = [Select Id, Name__c from Bank__c where Id = :bankAccount.Selected_Bank_Id__c];
        if(!lstSelectedBank.isEmpty() && lstSelectedBank.size()==1){
         bankAccount.Bank_Name_txt__c = lstSelectedBank[0].Name__c;
       }  
    }/*else{  //Not sure why I put this in here in the first place. -MM
      bankAccount.Bank_Name_txt__c = bankAccount.Selected_Bank_Id__c;
      }*/
    
    //Storing Branch Id in the lookup field if it's an existing branch
    if(bankAccount.Selected_Branch_Id__c != 'none' && bankAccount.Selected_Branch_Id__c != 'New') {
        
        try{
            bankAccount.Bank__c = bankAccount.Selected_Branch_Id__c;
         }catch(Exception ex){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
       }
    }else if(bankAccount.Selected_Branch_Id__c == 'none' || bankAccount.Selected_Branch_Id__c == 'New'){
       bankAccount.Bank__c = null;
      }
      
      if(bankAccount.Bank__c != null){
        bankAccount.New_Bank_Name__c = null;
        bankAccount.SWIFT_BIC_Code__c = null;
        bankAccount.ABA_Code__c = null;
       
      }
        
   
    try {
        if((bankAccount.Bank_Account_in_the_Grant_Currency__c == 'No')&&(bankAccount.Please_Explain_Rationale__c == null))
        {
          bankAccount.Please_Explain_Rationale__c.addError('Please Fill the Please Explain Rationale field');  
          return null;
        }
        
         if((bankAccount.Separate_bank_account_in_local_currency__c == 'Yes')&&(bankAccount.Local_Currency_Bank_Account_Details__c == null))
        {
          bankAccount.Local_Currency_Bank_Account_Details__c.addError('Please Fill the Local Currency Bank Account Details field');  
          return null;
        }
        if(bankAccount.Bank_Account_Name_Beneficiary__c== null) {
          bankAccount.Bank_Account_Name_Beneficiary__c.addError('Please Fill the Bank Account Name/Beneficiary Field');  
          return null;
        }
    
        upsert bankAccount;
        implementationPeriod.Bank_Account__c = bankAccount.Id;
        update implementationPeriod;
      }catch(Exception ex) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));return NULL;
      }
    readOnly = false;
        edit = false;
        view = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You must submit this information for approval or you will not receive a grant from The Global Fund.'));
        System.debug('Greetings from Line 256');
        getBankAccount();      
      return null;
    }
    
    public Pagereference cancelRecord() {
        getBankAccount();
    readOnly = false;
        edit = false;
        view = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You must submit this information for approval or you will not receive a grant from The Global Fund.'));
        System.debug('Greetings from Line 266');
      return NULL;
    }
    
    public Pagereference attachfile(){
        
        Pagereference ref = new Pagereference('/p/attach/NoteAttach?pid='+bankAccount.Id+'&parentname='+bankAccount.Name+'&retURL=/apex/BankAccountInformation?id='+implementationPeriod.Id+'%26mode=view');
        ref.setRedirect(true);
        return ref;
    }
    
    public Pagereference submittForApproval() {
          // Save Record;
          saveRecord();
        // field Valiations
        System.debug('>>>>> Test');
        String errorMessage = 'sd';
        Set<String> errorFields = new Set<String>();
    
        if(bankAccount.Account__c == NULL) { errorFields.add('Account'); }
        if(bankAccount.Bank_Account_Currency__c == NULL) { errorFields.add('Bank Account Currency'); }
        if(bankAccount.Bank_Account_in_the_Grant_Currency__c == NULL) { errorFields.add('Bank Account in the Grant Currency'); }
        if(bankAccount.Bank_Account_Number__c == NULL) { errorFields.add('Bank Account Number'); }
        if(bankAccount.Name == NULL) { errorFields.add('Bank Account Name'); }

        if(bankAccount.Bank_Address_line_1__c == NULL) { errorFields.add('Bank Address line 1'); }
        if(selectedBank == 'none') { errorFields.add('Bank Name'); }
        if(bankAccount.City__c == NULL) { errorFields.add('City'); }
        if(bankAccount.Postal_Code_Zip__c == NULL) { errorFields.add('PostalCode/ZipCode'); }
        if(selectedBranch == 'none') { errorFields.add('Branch Name'); }
        if(bankAccount.Selected_Country_Id__c == 'none') { errorFields.add('Country'); }
        if(bankAccount.Intermediary_Bank__c == NULL) { errorFields.add('Intermediary Bank?'); }
        if(bankAccount.Branch_Type__c == NULL) { errorFields.add('Branch Type'); }
        if(bankAccount.Separate_bank_account_in_local_currency__c == NULL) { errorFields.add('Separate bank account in local currency'); }
        System.debug('>>>>> errorFields.size()'+errorFields.size());
        if(errorFields.size() > 0) {
            errorMessage = 'You must enter values in the following fields:<br/>';
            errorMessage += '<ul>';
            for(String field : errorFields) {
                errorMessage += '<li>'+field+'</li>';
            }
            errorMessage += '</ul>';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
        return NULL;
        }
        return NULL;
    }
    
    public Pagereference saveChangesAndRedirect() {
      saveRecord();
      Pagereference pg = new Pagereference('/'+implementationPeriod.Id);
      pg.setRedirect(true);
      return pg;
        
    }
     /* For Custom Setting profile Implementation*/
     //TCS 15/10/2014: US Core Data Form
    public void checkProfile(){
                blnEditBankInformation = false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting__c> checkpage = new List<Profile_Access_Setting__c>();
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting__c where Page_Name__c ='BankAccountInformation' and Profile_Name__c =: profileName ];
        for (Profile_Access_Setting__c check : checkpage){
            if(check.Salesforce_Item__c == 'Edit Bank Account Information') blnEditBankInformation = true;
            }
    }
    /* End */
}