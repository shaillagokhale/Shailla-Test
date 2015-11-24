/*********************************************************************************
* {Controller} Class: {ctrlLookupPage}
*  DateCreated : 07/23/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Used for open contact lookup in Team Structure Page.
* 
* Unit Test: TestCtrlLookupPage
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
     1.0                      07/23/2013      INITIAL DEVELOPMENT
*********************************************************************************/

public with sharing class ctrlLookupPage{

    transient public List<CustomLookup> lstCustomlookup{get;set;}    
    public string searchString{get;set;} // search keyword
    Public string strAccId;
    public string strsObjectName;
    Public string strCountryId;
    Public string strParentAccountId;
    transient public List<sobject> results; // search results
    

    /********************************************************************
        Constructor
    ********************************************************************/
    public ctrlLookupPage() {
        lstCustomlookup = new List<Customlookup>();
        strsObjectName = System.currentPageReference().getParameters().get('lktp');
        strAccId = System.currentPageReference().getParameters().get('idfield');
        strCountryId  = System.currentPageReference().getParameters().get('Country');
        strParentAccountId = System.currentPageReference().getParameters().get('ParentId');
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');    
        runSearch();  
    }
    /********************************************************************
        Name : search
        Purpose : Performs the keyword search
    ********************************************************************/ 
  
    public PageReference search() {
        lstCustomlookup = new List<Customlookup>();
        runSearch();
        return null;
    }
    
    /********************************************************************
        Name : runSearch
        Purpose : Prepare the query and issue the search command
    ********************************************************************/
    
    private void runSearch() {
        results = performSearch(searchString);     
    } 
    
    /********************************************************************
        Name : performSearch
        Purpose : Run the search and return the records found
    ********************************************************************/  
  
    private List<sobject> performSearch(string searchString) {
        String soql = '';
        soql = 'select id,Name,FirstName,LastName';    
        
        if(strsObjectName != '' && strsObjectName != null){        
            soql += ' from '+ strsObjectName ;
        }
        List<Contact> lstContact = new List<Contact>();
        if(String.IsBlank(strCountryId)== false && (String.IsBlank(strAccId)== false || String.IsBlank(strParentAccountId)== false)){
            lstContact = [Select Id,Name,FirstName,LastName,
                                 (Select id from Rates__r Where Contact__c != null and Country__c =: strCountryId) 
                                  from Contact where (AccountId = : strAccId OR AccountId = :strParentAccountId OR 
                                  (Contact.Account.ParentId != null AND Contact.Account.ParentId =:strParentAccountId)) Order By LastName ASC];
            
            set<Id> setConId = new set<Id>();
            for(Contact objCon:lstContact){
                if(objCon.Rates__r.size() == 0){
                    setConId.add(objCon.Id);
                }
            }            
            soql = soql +  ' where (AccountId = : strAccId OR AccountId = :strParentAccountId OR (Contact.Account.ParentId != null AND Contact.Account.ParentId =:strParentAccountId)) ';
            
            if(searchString != '' && searchString != null){
                String strLikeString = '%' +  searchString + '%';
                soql = soql +  ' And Name LIKE :strLikeString';
            }
            soql = soql + ' And Id IN :setConId';
        }        
        results = database.query(soql); 
        
        CustomLookup objlookup = new CustomLookup();
        for(sobject s:results){
            objlookup = new CustomLookup();
            objlookup.Id = s.Id;
            objlookup.strName =  string.valueOf(s.get('Name'));
            objlookup.strFname = string.valueOf(s.get('FirstName'));
            objlookup.strLname = string.valueOf(s.get('LastName'));        
            lstCustomlookup.add(objlookup);        
        }   
        return null; 
    } 

    /********************************************************************
        Name : getFormTag
        Purpose : Used by the visualforce page to send the link to the right dom element
    ********************************************************************/  
  
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    /********************************************************************
        Name : getTextBox
        Purpose : Used by the visualforce page to send the link to the right dom element for the text box
    ********************************************************************/  
  
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
    
    /********************************************************************
        Wrapper Class : Customlookup
    ********************************************************************/
    
    public class Customlookup{
        Public Id Id{get;set;}
        Public String strName{get;set;}
        Public String strFname{get;set;}
        Public String strLname{get;set;}
    }
}