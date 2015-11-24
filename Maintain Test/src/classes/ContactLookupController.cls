public with sharing class ContactLookupController {
    

    //No need to store lst in ViewState as we are doing paramter passing in javascript    
  List<Contact> lstAccount = null;  
  String customerRecordName = 'Customer Account';
  string previousSortField = '';
  String selectedCustAcc{get;set;}
  String country{get;set;}
  public String role{get;set;}
  Integer pageSize = 25;
  public ApexPages.StandardSetController ssController{get;set;}
    
  public ContactLookupController () {
    isAscending = true;
    previousSortField = 'Name';
    SortField = 'Name';
    string searchString = System.currentPageReference().getParameters().get('lksrch');
    country = System.currentPageReference().getParameters().get('country');
    if(searchString != null && searchString != ''){
      this.searchText = searchString;   
    }
    QueryAccounts();          
  } 
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
  
  public String getAccountTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
  
  public String getAccountId() {
    return System.currentPageReference().getParameters().get('accId');
  }
  
  public List<Contact> getAccounts() {
    return ssController.getRecords();
  }
  
  public PageReference search() {
    isAscending = true;
    SortField = 'LastModifiedDate';
    QueryAccounts();
    return null;
  } 
  
  public void QueryAccounts() {    
    if( searchText == null) {
       NormalQuery();
       return ;  
    }
    string searchString = getSearchString();
    SearchQuery(searchString);             
  } 
  
  public Integer getListSize() {
    return ssController.getRecords().size();
  }
  
   // Query to get Account with search criteris on Name, Phone
  private void SearchQuery(string searchString) {
    string sortingOrder = 'ASC';
    string strQuery = '';
    if (isAscending == false){
      sortingOrder = 'DESC';
    }
    system.debug('*************searchString********'+ searchString);
    String textBoxId = getAccountTextBox();
    if(textBoxId.indexOf('contactrole2') > 0 || textBoxId.indexOf('contactrole3') > 0 || textBoxId.indexOf('contactrole4') > 0)  {
        //role = textBoxId.indexOf('contactrole2') > 0 ? 'Authorized Signatory for Grant Agreement' : 'Authorized Signatory for Disbursement Request';
        if(searchString != '' && searchString != null){
        //strQuery = 'Select Id, Name,Title FROM Contact where AccountId = \''+getAccountId()+'\' AND Role__c = \'' + role + '\' AND Name LIKE \'' + searchString + '%\' ';
        strQuery = 'Select Id, Name,Title,Role__c FROM Contact where AccountId = \''+getAccountId()+'\' AND Name LIKE \'' + searchString + '%\' ';
        // strQuery = 'Select Id, Name FROM Contact where AccountId = \''+getAccountId()+'\' AND Name LIKE \'' + searchString + '%\' ';
        }   
        else {
        strQuery = 'Select Id, Name,Title,Role__c FROM Contact where AccountId = \''+getAccountId()+'\'  ';
     //     strQuery = 'Select Id, Name FROM Contact where AccountId = \''+getAccountId() + '\' ';
        }
    } else {
        // CCM Contact
        if(searchString != '' && searchString != null){
       strQuery = 'Select Id, Name,Title,Role__c FROM Contact where Account.Country__c = \''+country+'\' AND Name LIKE \'' + searchString + '%\' ';
        }   
        else {
        strQuery = 'Select Id, Name,Title,Role__c FROM Contact where Account.Country__c = \''+country+'\'';   
        }
        strQuery = strQuery + ' AND Account.RecordType.Name = \'Applicant/Coordinating Mechanism\'';
    }
    strQuery = strQuery + ' ORDER BY ' + SortField;
    strQuery = strQuery + ' ' + sortingOrder;
    strQuery = strQuery + ' NULLS LAST limit 1000';         
    system.debug(strQuery);
    ssController = new ApexPages.StandardSetController(Database.query( strQuery)); 
    ssController.setPageSize(pageSize); 
  }
  
  
  // Query to get recently modified 20 contacts 
  private void NormalQuery() {
    string sortingOrder = 'ASC';
    string strQuery = '';
    if (isAscending == false){
      sortingOrder = 'DESC';
    }
    String textBoxId = getAccountTextBox(); 
    //contactrole
    if(textBoxId.indexOf('contactrole2') > 0 || textBoxId.indexOf('contactrole3') > 0 || textBoxId.indexOf('contactrole4') > 0)  {
        //role = textBoxId.indexOf('contactrole2') > 0 ? 'Authorized Signatory for Grant Agreement' : 'Authorized Signatory for Disbursement Request';
      //strQuery = 'Select Id, Name FROM Contact where AccountId = \''+getAccountId()+'\' AND Role__c = \'' + role + '\' '; 
      strQuery = 'Select Id, Name ,Title,Role__c FROM Contact where AccountId = \''+getAccountId()+'\' '; 
      // strQuery = 'Select Id, Name FROM Contact where AccountId = \''+getAccountId()+'\' ';       
    } else {
        // CCM Contact
      strQuery = 'Select Id, Name,Title,Role__c FROM Contact where Account.Country__c = \''+country+'\''; 
        strQuery = strQuery + ' AND Account.RecordType.Name = \'Applicant/Coordinating Mechanism\'';
    }
      
    strQuery = strQuery + ' ORDER BY ' + SortField;
    strQuery = strQuery + ' ' + sortingOrder;
    strQuery = strQuery + ' NULLS LAST limit 1000';
    system.debug(strQuery);
    ssController = new ApexPages.StandardSetController(Database.query( strQuery)); 
    ssController.setPageSize(pageSize); 
  }
  
  private string getSearchString() {
    if(searchText == null) {
        return '';
    }
    string input = searchText.replace('*','%');
    if(input.indexOf('%') == -1){
      input = '%' + input + '%';
    }
    return input;
  }
  public string searchText {
    get;
    set; 
  } 

  public boolean isAscending {
    get;
    set;
  }

  public string sortField {
    get;
    set {
      this.previousSortField = sortField;
      this.sortField = value;
      if(previousSortField == sortField) {
        isAscending = !isAscending;
        return;
      }
      this.isAscending = true;  
    }
  }
    
  // SORTING
  public PageReference DoSort(){
    if(searchText == null || searchText == '') {
      NormalQuery();
      return null;  
    }
    string searchString = getSearchString();
    SearchQuery(searchString);    
    return null;
  } 
  }