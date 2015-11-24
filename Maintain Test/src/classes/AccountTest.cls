public without sharing class AccountTest {
    
    public wrapAccount objWrap {get;set;}
    
    public AccountTest(){
    
        objWrap = new wrapAccount();        
    }
    
    public pageReference Save(){
     Account acct = new Account(Name = objWrap.strName);
     insert acct;
     return null;
    }
    
    public class wrapAccount{
    
    public String strName {get;set;}
    public String strShortName {get;set;}
    Public String strPRType {get;set;}
    Public String strPRSubType {get;set;}
    
    public wrapAccount(){
    
    }
    
    
    }
}